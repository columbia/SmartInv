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
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 // File: operator-filter-registry/src/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 abstract contract OperatorFilterer {
39     error OperatorNotAllowed(address operator);
40 
41     IOperatorFilterRegistry constant operatorFilterRegistry =
42         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
43 
44     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
45         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
46         // will not revert, but the contract will need to be registered with the registry once it is deployed in
47         // order for the modifier to filter addresses.
48         if (address(operatorFilterRegistry).code.length > 0) {
49             if (subscribe) {
50                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
51             } else {
52                 if (subscriptionOrRegistrantToCopy != address(0)) {
53                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
54                 } else {
55                     operatorFilterRegistry.register(address(this));
56                 }
57             }
58         }
59     }
60 
61     modifier onlyAllowedOperator(address from) virtual {
62         // Check registry code length to facilitate testing in environments without a deployed registry.
63         if (address(operatorFilterRegistry).code.length > 0) {
64             // Allow spending tokens from addresses with balance
65             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
66             // from an EOA.
67             if (from == msg.sender) {
68                 _;
69                 return;
70             }
71             if (
72                 !(
73                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
74                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
75                 )
76             ) {
77                 revert OperatorNotAllowed(msg.sender);
78             }
79         }
80         _;
81     }
82 }
83 
84 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
85 
86 
87 pragma solidity ^0.8.13;
88 
89 
90 abstract contract DefaultOperatorFilterer is OperatorFilterer {
91     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
92 
93     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
94 }
95 
96 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Contract module that helps prevent reentrant calls to a function.
105  *
106  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
107  * available, which can be applied to functions to make sure there are no nested
108  * (reentrant) calls to them.
109  *
110  * Note that because there is a single `nonReentrant` guard, functions marked as
111  * `nonReentrant` may not call one another. This can be worked around by making
112  * those functions `private`, and then adding `external` `nonReentrant` entry
113  * points to them.
114  *
115  * TIP: If you would like to learn more about reentrancy and alternative ways
116  * to protect against it, check out our blog post
117  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
118  */
119 abstract contract ReentrancyGuard {
120     // Booleans are more expensive than uint256 or any type that takes up a full
121     // word because each write operation emits an extra SLOAD to first read the
122     // slot's contents, replace the bits taken up by the boolean, and then write
123     // back. This is the compiler's defense against contract upgrades and
124     // pointer aliasing, and it cannot be disabled.
125 
126     // The values being non-zero value makes deployment a bit more expensive,
127     // but in exchange the refund on every call to nonReentrant will be lower in
128     // amount. Since refunds are capped to a percentage of the total
129     // transaction's gas, it is best to keep them low in cases like this one, to
130     // increase the likelihood of the full refund coming into effect.
131     uint256 private constant _NOT_ENTERED = 1;
132     uint256 private constant _ENTERED = 2;
133 
134     uint256 private _status;
135 
136     constructor() {
137         _status = _NOT_ENTERED;
138     }
139 
140     /**
141      * @dev Prevents a contract from calling itself, directly or indirectly.
142      * Calling a `nonReentrant` function from another `nonReentrant`
143      * function is not supported. It is possible to prevent this from happening
144      * by making the `nonReentrant` function external, and making it call a
145      * `private` function that does the actual work.
146      */
147     modifier nonReentrant() {
148         _nonReentrantBefore();
149         _;
150         _nonReentrantAfter();
151     }
152 
153     function _nonReentrantBefore() private {
154         // On the first call to nonReentrant, _status will be _NOT_ENTERED
155         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
156 
157         // Any calls to nonReentrant after this point will fail
158         _status = _ENTERED;
159     }
160 
161     function _nonReentrantAfter() private {
162         // By storing the original value once again, a refund is triggered (see
163         // https://eips.ethereum.org/EIPS/eip-2200)
164         _status = _NOT_ENTERED;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/math/Math.sol
169 
170 
171 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Standard math utilities missing in the Solidity language.
177  */
178 library Math {
179     enum Rounding {
180         Down, // Toward negative infinity
181         Up, // Toward infinity
182         Zero // Toward zero
183     }
184 
185     /**
186      * @dev Returns the largest of two numbers.
187      */
188     function max(uint256 a, uint256 b) internal pure returns (uint256) {
189         return a > b ? a : b;
190     }
191 
192     /**
193      * @dev Returns the smallest of two numbers.
194      */
195     function min(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a < b ? a : b;
197     }
198 
199     /**
200      * @dev Returns the average of two numbers. The result is rounded towards
201      * zero.
202      */
203     function average(uint256 a, uint256 b) internal pure returns (uint256) {
204         // (a + b) / 2 can overflow.
205         return (a & b) + (a ^ b) / 2;
206     }
207 
208     /**
209      * @dev Returns the ceiling of the division of two numbers.
210      *
211      * This differs from standard division with `/` in that it rounds up instead
212      * of rounding down.
213      */
214     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
215         // (a + b - 1) / b can overflow on addition, so we distribute.
216         return a == 0 ? 0 : (a - 1) / b + 1;
217     }
218 
219     /**
220      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
221      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
222      * with further edits by Uniswap Labs also under MIT license.
223      */
224     function mulDiv(
225         uint256 x,
226         uint256 y,
227         uint256 denominator
228     ) internal pure returns (uint256 result) {
229         unchecked {
230             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
231             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
232             // variables such that product = prod1 * 2^256 + prod0.
233             uint256 prod0; // Least significant 256 bits of the product
234             uint256 prod1; // Most significant 256 bits of the product
235             assembly {
236                 let mm := mulmod(x, y, not(0))
237                 prod0 := mul(x, y)
238                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
239             }
240 
241             // Handle non-overflow cases, 256 by 256 division.
242             if (prod1 == 0) {
243                 return prod0 / denominator;
244             }
245 
246             // Make sure the result is less than 2^256. Also prevents denominator == 0.
247             require(denominator > prod1);
248 
249             ///////////////////////////////////////////////
250             // 512 by 256 division.
251             ///////////////////////////////////////////////
252 
253             // Make division exact by subtracting the remainder from [prod1 prod0].
254             uint256 remainder;
255             assembly {
256                 // Compute remainder using mulmod.
257                 remainder := mulmod(x, y, denominator)
258 
259                 // Subtract 256 bit number from 512 bit number.
260                 prod1 := sub(prod1, gt(remainder, prod0))
261                 prod0 := sub(prod0, remainder)
262             }
263 
264             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
265             // See https://cs.stackexchange.com/q/138556/92363.
266 
267             // Does not overflow because the denominator cannot be zero at this stage in the function.
268             uint256 twos = denominator & (~denominator + 1);
269             assembly {
270                 // Divide denominator by twos.
271                 denominator := div(denominator, twos)
272 
273                 // Divide [prod1 prod0] by twos.
274                 prod0 := div(prod0, twos)
275 
276                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
277                 twos := add(div(sub(0, twos), twos), 1)
278             }
279 
280             // Shift in bits from prod1 into prod0.
281             prod0 |= prod1 * twos;
282 
283             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
284             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
285             // four bits. That is, denominator * inv = 1 mod 2^4.
286             uint256 inverse = (3 * denominator) ^ 2;
287 
288             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
289             // in modular arithmetic, doubling the correct bits in each step.
290             inverse *= 2 - denominator * inverse; // inverse mod 2^8
291             inverse *= 2 - denominator * inverse; // inverse mod 2^16
292             inverse *= 2 - denominator * inverse; // inverse mod 2^32
293             inverse *= 2 - denominator * inverse; // inverse mod 2^64
294             inverse *= 2 - denominator * inverse; // inverse mod 2^128
295             inverse *= 2 - denominator * inverse; // inverse mod 2^256
296 
297             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
298             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
299             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
300             // is no longer required.
301             result = prod0 * inverse;
302             return result;
303         }
304     }
305 
306     /**
307      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
308      */
309     function mulDiv(
310         uint256 x,
311         uint256 y,
312         uint256 denominator,
313         Rounding rounding
314     ) internal pure returns (uint256) {
315         uint256 result = mulDiv(x, y, denominator);
316         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
317             result += 1;
318         }
319         return result;
320     }
321 
322     /**
323      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
324      *
325      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
326      */
327     function sqrt(uint256 a) internal pure returns (uint256) {
328         if (a == 0) {
329             return 0;
330         }
331 
332         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
333         //
334         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
335         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
336         //
337         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
338         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
339         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
340         //
341         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
342         uint256 result = 1 << (log2(a) >> 1);
343 
344         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
345         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
346         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
347         // into the expected uint128 result.
348         unchecked {
349             result = (result + a / result) >> 1;
350             result = (result + a / result) >> 1;
351             result = (result + a / result) >> 1;
352             result = (result + a / result) >> 1;
353             result = (result + a / result) >> 1;
354             result = (result + a / result) >> 1;
355             result = (result + a / result) >> 1;
356             return min(result, a / result);
357         }
358     }
359 
360     /**
361      * @notice Calculates sqrt(a), following the selected rounding direction.
362      */
363     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
364         unchecked {
365             uint256 result = sqrt(a);
366             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
367         }
368     }
369 
370     /**
371      * @dev Return the log in base 2, rounded down, of a positive value.
372      * Returns 0 if given 0.
373      */
374     function log2(uint256 value) internal pure returns (uint256) {
375         uint256 result = 0;
376         unchecked {
377             if (value >> 128 > 0) {
378                 value >>= 128;
379                 result += 128;
380             }
381             if (value >> 64 > 0) {
382                 value >>= 64;
383                 result += 64;
384             }
385             if (value >> 32 > 0) {
386                 value >>= 32;
387                 result += 32;
388             }
389             if (value >> 16 > 0) {
390                 value >>= 16;
391                 result += 16;
392             }
393             if (value >> 8 > 0) {
394                 value >>= 8;
395                 result += 8;
396             }
397             if (value >> 4 > 0) {
398                 value >>= 4;
399                 result += 4;
400             }
401             if (value >> 2 > 0) {
402                 value >>= 2;
403                 result += 2;
404             }
405             if (value >> 1 > 0) {
406                 result += 1;
407             }
408         }
409         return result;
410     }
411 
412     /**
413      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
414      * Returns 0 if given 0.
415      */
416     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
417         unchecked {
418             uint256 result = log2(value);
419             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
420         }
421     }
422 
423     /**
424      * @dev Return the log in base 10, rounded down, of a positive value.
425      * Returns 0 if given 0.
426      */
427     function log10(uint256 value) internal pure returns (uint256) {
428         uint256 result = 0;
429         unchecked {
430             if (value >= 10**64) {
431                 value /= 10**64;
432                 result += 64;
433             }
434             if (value >= 10**32) {
435                 value /= 10**32;
436                 result += 32;
437             }
438             if (value >= 10**16) {
439                 value /= 10**16;
440                 result += 16;
441             }
442             if (value >= 10**8) {
443                 value /= 10**8;
444                 result += 8;
445             }
446             if (value >= 10**4) {
447                 value /= 10**4;
448                 result += 4;
449             }
450             if (value >= 10**2) {
451                 value /= 10**2;
452                 result += 2;
453             }
454             if (value >= 10**1) {
455                 result += 1;
456             }
457         }
458         return result;
459     }
460 
461     /**
462      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
463      * Returns 0 if given 0.
464      */
465     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
466         unchecked {
467             uint256 result = log10(value);
468             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
469         }
470     }
471 
472     /**
473      * @dev Return the log in base 256, rounded down, of a positive value.
474      * Returns 0 if given 0.
475      *
476      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
477      */
478     function log256(uint256 value) internal pure returns (uint256) {
479         uint256 result = 0;
480         unchecked {
481             if (value >> 128 > 0) {
482                 value >>= 128;
483                 result += 16;
484             }
485             if (value >> 64 > 0) {
486                 value >>= 64;
487                 result += 8;
488             }
489             if (value >> 32 > 0) {
490                 value >>= 32;
491                 result += 4;
492             }
493             if (value >> 16 > 0) {
494                 value >>= 16;
495                 result += 2;
496             }
497             if (value >> 8 > 0) {
498                 result += 1;
499             }
500         }
501         return result;
502     }
503 
504     /**
505      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
506      * Returns 0 if given 0.
507      */
508     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
509         unchecked {
510             uint256 result = log256(value);
511             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
512         }
513     }
514 }
515 
516 // File: @openzeppelin/contracts/utils/Strings.sol
517 
518 
519 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @dev String operations.
526  */
527 library Strings {
528     bytes16 private constant _SYMBOLS = "0123456789abcdef";
529     uint8 private constant _ADDRESS_LENGTH = 20;
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
533      */
534     function toString(uint256 value) internal pure returns (string memory) {
535         unchecked {
536             uint256 length = Math.log10(value) + 1;
537             string memory buffer = new string(length);
538             uint256 ptr;
539             /// @solidity memory-safe-assembly
540             assembly {
541                 ptr := add(buffer, add(32, length))
542             }
543             while (true) {
544                 ptr--;
545                 /// @solidity memory-safe-assembly
546                 assembly {
547                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
548                 }
549                 value /= 10;
550                 if (value == 0) break;
551             }
552             return buffer;
553         }
554     }
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
558      */
559     function toHexString(uint256 value) internal pure returns (string memory) {
560         unchecked {
561             return toHexString(value, Math.log256(value) + 1);
562         }
563     }
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
567      */
568     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
569         bytes memory buffer = new bytes(2 * length + 2);
570         buffer[0] = "0";
571         buffer[1] = "x";
572         for (uint256 i = 2 * length + 1; i > 1; --i) {
573             buffer[i] = _SYMBOLS[value & 0xf];
574             value >>= 4;
575         }
576         require(value == 0, "Strings: hex length insufficient");
577         return string(buffer);
578     }
579 
580     /**
581      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
582      */
583     function toHexString(address addr) internal pure returns (string memory) {
584         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/Context.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev Provides information about the current execution context, including the
597  * sender of the transaction and its data. While these are generally available
598  * via msg.sender and msg.data, they should not be accessed in such a direct
599  * manner, since when dealing with meta-transactions the account sending and
600  * paying for execution may not be the actual sender (as far as an application
601  * is concerned).
602  *
603  * This contract is only required for intermediate, library-like contracts.
604  */
605 abstract contract Context {
606     function _msgSender() internal view virtual returns (address) {
607         return msg.sender;
608     }
609 
610     function _msgData() internal view virtual returns (bytes calldata) {
611         return msg.data;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/access/Ownable.sol
616 
617 
618 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 
623 /**
624  * @dev Contract module which provides a basic access control mechanism, where
625  * there is an account (an owner) that can be granted exclusive access to
626  * specific functions.
627  *
628  * By default, the owner account will be the one that deploys the contract. This
629  * can later be changed with {transferOwnership}.
630  *
631  * This module is used through inheritance. It will make available the modifier
632  * `onlyOwner`, which can be applied to your functions to restrict their use to
633  * the owner.
634  */
635 abstract contract Ownable is Context {
636     address private _owner;
637 
638     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
639 
640     /**
641      * @dev Initializes the contract setting the deployer as the initial owner.
642      */
643     constructor() {
644         _transferOwnership(_msgSender());
645     }
646 
647     /**
648      * @dev Throws if called by any account other than the owner.
649      */
650     modifier onlyOwner() {
651         _checkOwner();
652         _;
653     }
654 
655     /**
656      * @dev Returns the address of the current owner.
657      */
658     function owner() public view virtual returns (address) {
659         return _owner;
660     }
661 
662     /**
663      * @dev Throws if the sender is not the owner.
664      */
665     function _checkOwner() internal view virtual {
666         require(owner() == _msgSender(), "Ownable: caller is not the owner");
667     }
668 
669     /**
670      * @dev Leaves the contract without owner. It will not be possible to call
671      * `onlyOwner` functions anymore. Can only be called by the current owner.
672      *
673      * NOTE: Renouncing ownership will leave the contract without an owner,
674      * thereby removing any functionality that is only available to the owner.
675      */
676     function renounceOwnership() public virtual onlyOwner {
677         _transferOwnership(address(0));
678     }
679 
680     /**
681      * @dev Transfers ownership of the contract to a new account (`newOwner`).
682      * Can only be called by the current owner.
683      */
684     function transferOwnership(address newOwner) public virtual onlyOwner {
685         require(newOwner != address(0), "Ownable: new owner is the zero address");
686         _transferOwnership(newOwner);
687     }
688 
689     /**
690      * @dev Transfers ownership of the contract to a new account (`newOwner`).
691      * Internal function without access restriction.
692      */
693     function _transferOwnership(address newOwner) internal virtual {
694         address oldOwner = _owner;
695         _owner = newOwner;
696         emit OwnershipTransferred(oldOwner, newOwner);
697     }
698 }
699 
700 // File: @openzeppelin/contracts/utils/Address.sol
701 
702 
703 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
704 
705 pragma solidity ^0.8.1;
706 
707 /**
708  * @dev Collection of functions related to the address type
709  */
710 library Address {
711     /**
712      * @dev Returns true if `account` is a contract.
713      *
714      * [IMPORTANT]
715      * ====
716      * It is unsafe to assume that an address for which this function returns
717      * false is an externally-owned account (EOA) and not a contract.
718      *
719      * Among others, `isContract` will return false for the following
720      * types of addresses:
721      *
722      *  - an externally-owned account
723      *  - a contract in construction
724      *  - an address where a contract will be created
725      *  - an address where a contract lived, but was destroyed
726      * ====
727      *
728      * [IMPORTANT]
729      * ====
730      * You shouldn't rely on `isContract` to protect against flash loan attacks!
731      *
732      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
733      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
734      * constructor.
735      * ====
736      */
737     function isContract(address account) internal view returns (bool) {
738         // This method relies on extcodesize/address.code.length, which returns 0
739         // for contracts in construction, since the code is only stored at the end
740         // of the constructor execution.
741 
742         return account.code.length > 0;
743     }
744 
745     /**
746      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
747      * `recipient`, forwarding all available gas and reverting on errors.
748      *
749      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
750      * of certain opcodes, possibly making contracts go over the 2300 gas limit
751      * imposed by `transfer`, making them unable to receive funds via
752      * `transfer`. {sendValue} removes this limitation.
753      *
754      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
755      *
756      * IMPORTANT: because control is transferred to `recipient`, care must be
757      * taken to not create reentrancy vulnerabilities. Consider using
758      * {ReentrancyGuard} or the
759      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
760      */
761     function sendValue(address payable recipient, uint256 amount) internal {
762         require(address(this).balance >= amount, "Address: insufficient balance");
763 
764         (bool success, ) = recipient.call{value: amount}("");
765         require(success, "Address: unable to send value, recipient may have reverted");
766     }
767 
768     /**
769      * @dev Performs a Solidity function call using a low level `call`. A
770      * plain `call` is an unsafe replacement for a function call: use this
771      * function instead.
772      *
773      * If `target` reverts with a revert reason, it is bubbled up by this
774      * function (like regular Solidity function calls).
775      *
776      * Returns the raw returned data. To convert to the expected return value,
777      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
778      *
779      * Requirements:
780      *
781      * - `target` must be a contract.
782      * - calling `target` with `data` must not revert.
783      *
784      * _Available since v3.1._
785      */
786     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
787         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
792      * `errorMessage` as a fallback revert reason when `target` reverts.
793      *
794      * _Available since v3.1._
795      */
796     function functionCall(
797         address target,
798         bytes memory data,
799         string memory errorMessage
800     ) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, 0, errorMessage);
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
806      * but also transferring `value` wei to `target`.
807      *
808      * Requirements:
809      *
810      * - the calling contract must have an ETH balance of at least `value`.
811      * - the called Solidity function must be `payable`.
812      *
813      * _Available since v3.1._
814      */
815     function functionCallWithValue(
816         address target,
817         bytes memory data,
818         uint256 value
819     ) internal returns (bytes memory) {
820         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
825      * with `errorMessage` as a fallback revert reason when `target` reverts.
826      *
827      * _Available since v3.1._
828      */
829     function functionCallWithValue(
830         address target,
831         bytes memory data,
832         uint256 value,
833         string memory errorMessage
834     ) internal returns (bytes memory) {
835         require(address(this).balance >= value, "Address: insufficient balance for call");
836         (bool success, bytes memory returndata) = target.call{value: value}(data);
837         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
842      * but performing a static call.
843      *
844      * _Available since v3.3._
845      */
846     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
847         return functionStaticCall(target, data, "Address: low-level static call failed");
848     }
849 
850     /**
851      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
852      * but performing a static call.
853      *
854      * _Available since v3.3._
855      */
856     function functionStaticCall(
857         address target,
858         bytes memory data,
859         string memory errorMessage
860     ) internal view returns (bytes memory) {
861         (bool success, bytes memory returndata) = target.staticcall(data);
862         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
863     }
864 
865     /**
866      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
867      * but performing a delegate call.
868      *
869      * _Available since v3.4._
870      */
871     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
872         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
873     }
874 
875     /**
876      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
877      * but performing a delegate call.
878      *
879      * _Available since v3.4._
880      */
881     function functionDelegateCall(
882         address target,
883         bytes memory data,
884         string memory errorMessage
885     ) internal returns (bytes memory) {
886         (bool success, bytes memory returndata) = target.delegatecall(data);
887         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
888     }
889 
890     /**
891      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
892      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
893      *
894      * _Available since v4.8._
895      */
896     function verifyCallResultFromTarget(
897         address target,
898         bool success,
899         bytes memory returndata,
900         string memory errorMessage
901     ) internal view returns (bytes memory) {
902         if (success) {
903             if (returndata.length == 0) {
904                 // only check isContract if the call was successful and the return data is empty
905                 // otherwise we already know that it was a contract
906                 require(isContract(target), "Address: call to non-contract");
907             }
908             return returndata;
909         } else {
910             _revert(returndata, errorMessage);
911         }
912     }
913 
914     /**
915      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
916      * revert reason or using the provided one.
917      *
918      * _Available since v4.3._
919      */
920     function verifyCallResult(
921         bool success,
922         bytes memory returndata,
923         string memory errorMessage
924     ) internal pure returns (bytes memory) {
925         if (success) {
926             return returndata;
927         } else {
928             _revert(returndata, errorMessage);
929         }
930     }
931 
932     function _revert(bytes memory returndata, string memory errorMessage) private pure {
933         // Look for revert reason and bubble it up if present
934         if (returndata.length > 0) {
935             // The easiest way to bubble the revert reason is using memory via assembly
936             /// @solidity memory-safe-assembly
937             assembly {
938                 let returndata_size := mload(returndata)
939                 revert(add(32, returndata), returndata_size)
940             }
941         } else {
942             revert(errorMessage);
943         }
944     }
945 }
946 
947 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
948 
949 
950 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 /**
955  * @title ERC721 token receiver interface
956  * @dev Interface for any contract that wants to support safeTransfers
957  * from ERC721 asset contracts.
958  */
959 interface IERC721Receiver {
960     /**
961      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
962      * by `operator` from `from`, this function is called.
963      *
964      * It must return its Solidity selector to confirm the token transfer.
965      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
966      *
967      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
968      */
969     function onERC721Received(
970         address operator,
971         address from,
972         uint256 tokenId,
973         bytes calldata data
974     ) external returns (bytes4);
975 }
976 
977 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
978 
979 
980 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 /**
985  * @dev Interface of the ERC165 standard, as defined in the
986  * https://eips.ethereum.org/EIPS/eip-165[EIP].
987  *
988  * Implementers can declare support of contract interfaces, which can then be
989  * queried by others ({ERC165Checker}).
990  *
991  * For an implementation, see {ERC165}.
992  */
993 interface IERC165 {
994     /**
995      * @dev Returns true if this contract implements the interface defined by
996      * `interfaceId`. See the corresponding
997      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
998      * to learn more about how these ids are created.
999      *
1000      * This function call must use less than 30 000 gas.
1001      */
1002     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1003 }
1004 
1005 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 /**
1014  * @dev Implementation of the {IERC165} interface.
1015  *
1016  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1017  * for the additional interface id that will be supported. For example:
1018  *
1019  * ```solidity
1020  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1021  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1022  * }
1023  * ```
1024  *
1025  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1026  */
1027 abstract contract ERC165 is IERC165 {
1028     /**
1029      * @dev See {IERC165-supportsInterface}.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1032         return interfaceId == type(IERC165).interfaceId;
1033     }
1034 }
1035 
1036 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1037 
1038 
1039 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 
1044 /**
1045  * @dev Required interface of an ERC721 compliant contract.
1046  */
1047 interface IERC721 is IERC165 {
1048     /**
1049      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1050      */
1051     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1052 
1053     /**
1054      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1055      */
1056     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1057 
1058     /**
1059      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1060      */
1061     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1062 
1063     /**
1064      * @dev Returns the number of tokens in ``owner``'s account.
1065      */
1066     function balanceOf(address owner) external view returns (uint256 balance);
1067 
1068     /**
1069      * @dev Returns the owner of the `tokenId` token.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      */
1075     function ownerOf(uint256 tokenId) external view returns (address owner);
1076 
1077     /**
1078      * @dev Safely transfers `tokenId` token from `from` to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must exist and be owned by `from`.
1085      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1086      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes calldata data
1095     ) external;
1096 
1097     /**
1098      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1099      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1100      *
1101      * Requirements:
1102      *
1103      * - `from` cannot be the zero address.
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must exist and be owned by `from`.
1106      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function safeTransferFrom(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) external;
1116 
1117     /**
1118      * @dev Transfers `tokenId` token from `from` to `to`.
1119      *
1120      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1121      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1122      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1123      *
1124      * Requirements:
1125      *
1126      * - `from` cannot be the zero address.
1127      * - `to` cannot be the zero address.
1128      * - `tokenId` token must be owned by `from`.
1129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function transferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) external;
1138 
1139     /**
1140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1141      * The approval is cleared when the token is transferred.
1142      *
1143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1144      *
1145      * Requirements:
1146      *
1147      * - The caller must own the token or be an approved operator.
1148      * - `tokenId` must exist.
1149      *
1150      * Emits an {Approval} event.
1151      */
1152     function approve(address to, uint256 tokenId) external;
1153 
1154     /**
1155      * @dev Approve or remove `operator` as an operator for the caller.
1156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1157      *
1158      * Requirements:
1159      *
1160      * - The `operator` cannot be the caller.
1161      *
1162      * Emits an {ApprovalForAll} event.
1163      */
1164     function setApprovalForAll(address operator, bool _approved) external;
1165 
1166     /**
1167      * @dev Returns the account approved for `tokenId` token.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      */
1173     function getApproved(uint256 tokenId) external view returns (address operator);
1174 
1175     /**
1176      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1177      *
1178      * See {setApprovalForAll}
1179      */
1180     function isApprovedForAll(address owner, address operator) external view returns (bool);
1181 }
1182 
1183 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1184 
1185 
1186 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 /**
1192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1193  * @dev See https://eips.ethereum.org/EIPS/eip-721
1194  */
1195 interface IERC721Metadata is IERC721 {
1196     /**
1197      * @dev Returns the token collection name.
1198      */
1199     function name() external view returns (string memory);
1200 
1201     /**
1202      * @dev Returns the token collection symbol.
1203      */
1204     function symbol() external view returns (string memory);
1205 
1206     /**
1207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1208      */
1209     function tokenURI(uint256 tokenId) external view returns (string memory);
1210 }
1211 
1212 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1213 
1214 
1215 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 
1226 /**
1227  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1228  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1229  * {ERC721Enumerable}.
1230  */
1231 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1232     using Address for address;
1233     using Strings for uint256;
1234 
1235     // Token name
1236     string private _name;
1237 
1238     // Token symbol
1239     string private _symbol;
1240 
1241     // Mapping from token ID to owner address
1242     mapping(uint256 => address) private _owners;
1243 
1244     // Mapping owner address to token count
1245     mapping(address => uint256) private _balances;
1246 
1247     // Mapping from token ID to approved address
1248     mapping(uint256 => address) private _tokenApprovals;
1249 
1250     // Mapping from owner to operator approvals
1251     mapping(address => mapping(address => bool)) private _operatorApprovals;
1252 
1253     /**
1254      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1255      */
1256     constructor(string memory name_, string memory symbol_) {
1257         _name = name_;
1258         _symbol = symbol_;
1259     }
1260 
1261     /**
1262      * @dev See {IERC165-supportsInterface}.
1263      */
1264     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1265         return
1266             interfaceId == type(IERC721).interfaceId ||
1267             interfaceId == type(IERC721Metadata).interfaceId ||
1268             super.supportsInterface(interfaceId);
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-balanceOf}.
1273      */
1274     function balanceOf(address owner) public view virtual override returns (uint256) {
1275         require(owner != address(0), "ERC721: address zero is not a valid owner");
1276         return _balances[owner];
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-ownerOf}.
1281      */
1282     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1283         address owner = _ownerOf(tokenId);
1284         require(owner != address(0), "ERC721: invalid token ID");
1285         return owner;
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Metadata-name}.
1290      */
1291     function name() public view virtual override returns (string memory) {
1292         return _name;
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Metadata-symbol}.
1297      */
1298     function symbol() public view virtual override returns (string memory) {
1299         return _symbol;
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Metadata-tokenURI}.
1304      */
1305     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1306         _requireMinted(tokenId);
1307 
1308         string memory baseURI = _baseURI();
1309         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1310     }
1311 
1312     /**
1313      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1314      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1315      * by default, can be overridden in child contracts.
1316      */
1317     function _baseURI() internal view virtual returns (string memory) {
1318         return "";
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-approve}.
1323      */
1324     function approve(address to, uint256 tokenId) public virtual override {
1325         address owner = ERC721.ownerOf(tokenId);
1326         require(to != owner, "ERC721: approval to current owner");
1327 
1328         require(
1329             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1330             "ERC721: approve caller is not token owner or approved for all"
1331         );
1332 
1333         _approve(to, tokenId);
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-getApproved}.
1338      */
1339     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1340         _requireMinted(tokenId);
1341 
1342         return _tokenApprovals[tokenId];
1343     }
1344 
1345     /**
1346      * @dev See {IERC721-setApprovalForAll}.
1347      */
1348     function setApprovalForAll(address operator, bool approved) public virtual override {
1349         _setApprovalForAll(_msgSender(), operator, approved);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-isApprovedForAll}.
1354      */
1355     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1356         return _operatorApprovals[owner][operator];
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-transferFrom}.
1361      */
1362     function transferFrom(
1363         address from,
1364         address to,
1365         uint256 tokenId
1366     ) public virtual override {
1367         //solhint-disable-next-line max-line-length
1368         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1369 
1370         _transfer(from, to, tokenId);
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-safeTransferFrom}.
1375      */
1376     function safeTransferFrom(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) public virtual override {
1381         safeTransferFrom(from, to, tokenId, "");
1382     }
1383 
1384     /**
1385      * @dev See {IERC721-safeTransferFrom}.
1386      */
1387     function safeTransferFrom(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory data
1392     ) public virtual override {
1393         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1394         _safeTransfer(from, to, tokenId, data);
1395     }
1396 
1397     /**
1398      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1399      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1400      *
1401      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1402      *
1403      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1404      * implement alternative mechanisms to perform token transfer, such as signature-based.
1405      *
1406      * Requirements:
1407      *
1408      * - `from` cannot be the zero address.
1409      * - `to` cannot be the zero address.
1410      * - `tokenId` token must exist and be owned by `from`.
1411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _safeTransfer(
1416         address from,
1417         address to,
1418         uint256 tokenId,
1419         bytes memory data
1420     ) internal virtual {
1421         _transfer(from, to, tokenId);
1422         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1423     }
1424 
1425     /**
1426      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1427      */
1428     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1429         return _owners[tokenId];
1430     }
1431 
1432     /**
1433      * @dev Returns whether `tokenId` exists.
1434      *
1435      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1436      *
1437      * Tokens start existing when they are minted (`_mint`),
1438      * and stop existing when they are burned (`_burn`).
1439      */
1440     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1441         return _ownerOf(tokenId) != address(0);
1442     }
1443 
1444     /**
1445      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1446      *
1447      * Requirements:
1448      *
1449      * - `tokenId` must exist.
1450      */
1451     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1452         address owner = ERC721.ownerOf(tokenId);
1453         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1454     }
1455 
1456     /**
1457      * @dev Safely mints `tokenId` and transfers it to `to`.
1458      *
1459      * Requirements:
1460      *
1461      * - `tokenId` must not exist.
1462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _safeMint(address to, uint256 tokenId) internal virtual {
1467         _safeMint(to, tokenId, "");
1468     }
1469 
1470     /**
1471      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1472      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1473      */
1474     function _safeMint(
1475         address to,
1476         uint256 tokenId,
1477         bytes memory data
1478     ) internal virtual {
1479         _mint(to, tokenId);
1480         require(
1481             _checkOnERC721Received(address(0), to, tokenId, data),
1482             "ERC721: transfer to non ERC721Receiver implementer"
1483         );
1484     }
1485 
1486     /**
1487      * @dev Mints `tokenId` and transfers it to `to`.
1488      *
1489      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1490      *
1491      * Requirements:
1492      *
1493      * - `tokenId` must not exist.
1494      * - `to` cannot be the zero address.
1495      *
1496      * Emits a {Transfer} event.
1497      */
1498     function _mint(address to, uint256 tokenId) internal virtual {
1499         require(to != address(0), "ERC721: mint to the zero address");
1500         require(!_exists(tokenId), "ERC721: token already minted");
1501 
1502         _beforeTokenTransfer(address(0), to, tokenId, 1);
1503 
1504         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1505         require(!_exists(tokenId), "ERC721: token already minted");
1506 
1507         unchecked {
1508             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1509             // Given that tokens are minted one by one, it is impossible in practice that
1510             // this ever happens. Might change if we allow batch minting.
1511             // The ERC fails to describe this case.
1512             _balances[to] += 1;
1513         }
1514 
1515         _owners[tokenId] = to;
1516 
1517         emit Transfer(address(0), to, tokenId);
1518 
1519         _afterTokenTransfer(address(0), to, tokenId, 1);
1520     }
1521 
1522     /**
1523      * @dev Destroys `tokenId`.
1524      * The approval is cleared when the token is burned.
1525      * This is an internal function that does not check if the sender is authorized to operate on the token.
1526      *
1527      * Requirements:
1528      *
1529      * - `tokenId` must exist.
1530      *
1531      * Emits a {Transfer} event.
1532      */
1533     function _burn(uint256 tokenId) internal virtual {
1534         address owner = ERC721.ownerOf(tokenId);
1535 
1536         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1537 
1538         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1539         owner = ERC721.ownerOf(tokenId);
1540 
1541         // Clear approvals
1542         delete _tokenApprovals[tokenId];
1543 
1544         unchecked {
1545             // Cannot overflow, as that would require more tokens to be burned/transferred
1546             // out than the owner initially received through minting and transferring in.
1547             _balances[owner] -= 1;
1548         }
1549         delete _owners[tokenId];
1550 
1551         emit Transfer(owner, address(0), tokenId);
1552 
1553         _afterTokenTransfer(owner, address(0), tokenId, 1);
1554     }
1555 
1556     /**
1557      * @dev Transfers `tokenId` from `from` to `to`.
1558      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1559      *
1560      * Requirements:
1561      *
1562      * - `to` cannot be the zero address.
1563      * - `tokenId` token must be owned by `from`.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _transfer(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) internal virtual {
1572         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1573         require(to != address(0), "ERC721: transfer to the zero address");
1574 
1575         _beforeTokenTransfer(from, to, tokenId, 1);
1576 
1577         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1578         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1579 
1580         // Clear approvals from the previous owner
1581         delete _tokenApprovals[tokenId];
1582 
1583         unchecked {
1584             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1585             // `from`'s balance is the number of token held, which is at least one before the current
1586             // transfer.
1587             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1588             // all 2**256 token ids to be minted, which in practice is impossible.
1589             _balances[from] -= 1;
1590             _balances[to] += 1;
1591         }
1592         _owners[tokenId] = to;
1593 
1594         emit Transfer(from, to, tokenId);
1595 
1596         _afterTokenTransfer(from, to, tokenId, 1);
1597     }
1598 
1599     /**
1600      * @dev Approve `to` to operate on `tokenId`
1601      *
1602      * Emits an {Approval} event.
1603      */
1604     function _approve(address to, uint256 tokenId) internal virtual {
1605         _tokenApprovals[tokenId] = to;
1606         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1607     }
1608 
1609     /**
1610      * @dev Approve `operator` to operate on all of `owner` tokens
1611      *
1612      * Emits an {ApprovalForAll} event.
1613      */
1614     function _setApprovalForAll(
1615         address owner,
1616         address operator,
1617         bool approved
1618     ) internal virtual {
1619         require(owner != operator, "ERC721: approve to caller");
1620         _operatorApprovals[owner][operator] = approved;
1621         emit ApprovalForAll(owner, operator, approved);
1622     }
1623 
1624     /**
1625      * @dev Reverts if the `tokenId` has not been minted yet.
1626      */
1627     function _requireMinted(uint256 tokenId) internal view virtual {
1628         require(_exists(tokenId), "ERC721: invalid token ID");
1629     }
1630 
1631     /**
1632      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1633      * The call is not executed if the target address is not a contract.
1634      *
1635      * @param from address representing the previous owner of the given token ID
1636      * @param to target address that will receive the tokens
1637      * @param tokenId uint256 ID of the token to be transferred
1638      * @param data bytes optional data to send along with the call
1639      * @return bool whether the call correctly returned the expected magic value
1640      */
1641     function _checkOnERC721Received(
1642         address from,
1643         address to,
1644         uint256 tokenId,
1645         bytes memory data
1646     ) private returns (bool) {
1647         if (to.isContract()) {
1648             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1649                 return retval == IERC721Receiver.onERC721Received.selector;
1650             } catch (bytes memory reason) {
1651                 if (reason.length == 0) {
1652                     revert("ERC721: transfer to non ERC721Receiver implementer");
1653                 } else {
1654                     /// @solidity memory-safe-assembly
1655                     assembly {
1656                         revert(add(32, reason), mload(reason))
1657                     }
1658                 }
1659             }
1660         } else {
1661             return true;
1662         }
1663     }
1664 
1665     /**
1666      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1667      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1668      *
1669      * Calling conditions:
1670      *
1671      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1672      * - When `from` is zero, the tokens will be minted for `to`.
1673      * - When `to` is zero, ``from``'s tokens will be burned.
1674      * - `from` and `to` are never both zero.
1675      * - `batchSize` is non-zero.
1676      *
1677      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1678      */
1679     function _beforeTokenTransfer(
1680         address from,
1681         address to,
1682         uint256, /* firstTokenId */
1683         uint256 batchSize
1684     ) internal virtual {
1685         if (batchSize > 1) {
1686             if (from != address(0)) {
1687                 _balances[from] -= batchSize;
1688             }
1689             if (to != address(0)) {
1690                 _balances[to] += batchSize;
1691             }
1692         }
1693     }
1694 
1695     /**
1696      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1697      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1698      *
1699      * Calling conditions:
1700      *
1701      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1702      * - When `from` is zero, the tokens were minted for `to`.
1703      * - When `to` is zero, ``from``'s tokens were burned.
1704      * - `from` and `to` are never both zero.
1705      * - `batchSize` is non-zero.
1706      *
1707      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1708      */
1709     function _afterTokenTransfer(
1710         address from,
1711         address to,
1712         uint256 firstTokenId,
1713         uint256 batchSize
1714     ) internal virtual {}
1715 }
1716 
1717 // File: erc721a/contracts/IERC721A.sol
1718 
1719 
1720 // ERC721A Contracts v4.2.3
1721 // Creator: Chiru Labs
1722 
1723 pragma solidity ^0.8.4;
1724 
1725 /**
1726  * @dev Interface of ERC721A.
1727  */
1728 interface IERC721A {
1729     /**
1730      * The caller must own the token or be an approved operator.
1731      */
1732     error ApprovalCallerNotOwnerNorApproved();
1733 
1734     /**
1735      * The token does not exist.
1736      */
1737     error ApprovalQueryForNonexistentToken();
1738 
1739     /**
1740      * Cannot query the balance for the zero address.
1741      */
1742     error BalanceQueryForZeroAddress();
1743 
1744     /**
1745      * Cannot mint to the zero address.
1746      */
1747     error MintToZeroAddress();
1748 
1749     /**
1750      * The quantity of tokens minted must be more than zero.
1751      */
1752     error MintZeroQuantity();
1753 
1754     /**
1755      * The token does not exist.
1756      */
1757     error OwnerQueryForNonexistentToken();
1758 
1759     /**
1760      * The caller must own the token or be an approved operator.
1761      */
1762     error TransferCallerNotOwnerNorApproved();
1763 
1764     /**
1765      * The token must be owned by `from`.
1766      */
1767     error TransferFromIncorrectOwner();
1768 
1769     /**
1770      * Cannot safely transfer to a contract that does not implement the
1771      * ERC721Receiver interface.
1772      */
1773     error TransferToNonERC721ReceiverImplementer();
1774 
1775     /**
1776      * Cannot transfer to the zero address.
1777      */
1778     error TransferToZeroAddress();
1779 
1780     /**
1781      * The token does not exist.
1782      */
1783     error URIQueryForNonexistentToken();
1784 
1785     /**
1786      * The `quantity` minted with ERC2309 exceeds the safety limit.
1787      */
1788     error MintERC2309QuantityExceedsLimit();
1789 
1790     /**
1791      * The `extraData` cannot be set on an unintialized ownership slot.
1792      */
1793     error OwnershipNotInitializedForExtraData();
1794 
1795     // =============================================================
1796     //                            STRUCTS
1797     // =============================================================
1798 
1799     struct TokenOwnership {
1800         // The address of the owner.
1801         address addr;
1802         // Stores the start time of ownership with minimal overhead for tokenomics.
1803         uint64 startTimestamp;
1804         // Whether the token has been burned.
1805         bool burned;
1806         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1807         uint24 extraData;
1808     }
1809 
1810     // =============================================================
1811     //                         TOKEN COUNTERS
1812     // =============================================================
1813 
1814     /**
1815      * @dev Returns the total number of tokens in existence.
1816      * Burned tokens will reduce the count.
1817      * To get the total number of tokens minted, please see {_totalMinted}.
1818      */
1819     function totalSupply() external view returns (uint256);
1820 
1821     // =============================================================
1822     //                            IERC165
1823     // =============================================================
1824 
1825     /**
1826      * @dev Returns true if this contract implements the interface defined by
1827      * `interfaceId`. See the corresponding
1828      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1829      * to learn more about how these ids are created.
1830      *
1831      * This function call must use less than 30000 gas.
1832      */
1833     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1834 
1835     // =============================================================
1836     //                            IERC721
1837     // =============================================================
1838 
1839     /**
1840      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1841      */
1842     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1843 
1844     /**
1845      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1846      */
1847     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1848 
1849     /**
1850      * @dev Emitted when `owner` enables or disables
1851      * (`approved`) `operator` to manage all of its assets.
1852      */
1853     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1854 
1855     /**
1856      * @dev Returns the number of tokens in `owner`'s account.
1857      */
1858     function balanceOf(address owner) external view returns (uint256 balance);
1859 
1860     /**
1861      * @dev Returns the owner of the `tokenId` token.
1862      *
1863      * Requirements:
1864      *
1865      * - `tokenId` must exist.
1866      */
1867     function ownerOf(uint256 tokenId) external view returns (address owner);
1868 
1869     /**
1870      * @dev Safely transfers `tokenId` token from `from` to `to`,
1871      * checking first that contract recipients are aware of the ERC721 protocol
1872      * to prevent tokens from being forever locked.
1873      *
1874      * Requirements:
1875      *
1876      * - `from` cannot be the zero address.
1877      * - `to` cannot be the zero address.
1878      * - `tokenId` token must exist and be owned by `from`.
1879      * - If the caller is not `from`, it must be have been allowed to move
1880      * this token by either {approve} or {setApprovalForAll}.
1881      * - If `to` refers to a smart contract, it must implement
1882      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1883      *
1884      * Emits a {Transfer} event.
1885      */
1886     function safeTransferFrom(
1887         address from,
1888         address to,
1889         uint256 tokenId,
1890         bytes calldata data
1891     ) external payable;
1892 
1893     /**
1894      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1895      */
1896     function safeTransferFrom(
1897         address from,
1898         address to,
1899         uint256 tokenId
1900     ) external payable;
1901 
1902     /**
1903      * @dev Transfers `tokenId` from `from` to `to`.
1904      *
1905      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1906      * whenever possible.
1907      *
1908      * Requirements:
1909      *
1910      * - `from` cannot be the zero address.
1911      * - `to` cannot be the zero address.
1912      * - `tokenId` token must be owned by `from`.
1913      * - If the caller is not `from`, it must be approved to move this token
1914      * by either {approve} or {setApprovalForAll}.
1915      *
1916      * Emits a {Transfer} event.
1917      */
1918     function transferFrom(
1919         address from,
1920         address to,
1921         uint256 tokenId
1922     ) external payable;
1923 
1924     /**
1925      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1926      * The approval is cleared when the token is transferred.
1927      *
1928      * Only a single account can be approved at a time, so approving the
1929      * zero address clears previous approvals.
1930      *
1931      * Requirements:
1932      *
1933      * - The caller must own the token or be an approved operator.
1934      * - `tokenId` must exist.
1935      *
1936      * Emits an {Approval} event.
1937      */
1938     function approve(address to, uint256 tokenId) external payable;
1939 
1940     /**
1941      * @dev Approve or remove `operator` as an operator for the caller.
1942      * Operators can call {transferFrom} or {safeTransferFrom}
1943      * for any token owned by the caller.
1944      *
1945      * Requirements:
1946      *
1947      * - The `operator` cannot be the caller.
1948      *
1949      * Emits an {ApprovalForAll} event.
1950      */
1951     function setApprovalForAll(address operator, bool _approved) external;
1952 
1953     /**
1954      * @dev Returns the account approved for `tokenId` token.
1955      *
1956      * Requirements:
1957      *
1958      * - `tokenId` must exist.
1959      */
1960     function getApproved(uint256 tokenId) external view returns (address operator);
1961 
1962     /**
1963      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1964      *
1965      * See {setApprovalForAll}.
1966      */
1967     function isApprovedForAll(address owner, address operator) external view returns (bool);
1968 
1969     // =============================================================
1970     //                        IERC721Metadata
1971     // =============================================================
1972 
1973     /**
1974      * @dev Returns the token collection name.
1975      */
1976     function name() external view returns (string memory);
1977 
1978     /**
1979      * @dev Returns the token collection symbol.
1980      */
1981     function symbol() external view returns (string memory);
1982 
1983     /**
1984      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1985      */
1986     function tokenURI(uint256 tokenId) external view returns (string memory);
1987 
1988     // =============================================================
1989     //                           IERC2309
1990     // =============================================================
1991 
1992     /**
1993      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1994      * (inclusive) is transferred from `from` to `to`, as defined in the
1995      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1996      *
1997      * See {_mintERC2309} for more details.
1998      */
1999     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
2000 }
2001 
2002 // File: erc721a/contracts/ERC721A.sol
2003 
2004 
2005 // ERC721A Contracts v4.2.3
2006 // Creator: Chiru Labs
2007 
2008 pragma solidity ^0.8.4;
2009 
2010 
2011 /**
2012  * @dev Interface of ERC721 token receiver.
2013  */
2014 interface ERC721A__IERC721Receiver {
2015     function onERC721Received(
2016         address operator,
2017         address from,
2018         uint256 tokenId,
2019         bytes calldata data
2020     ) external returns (bytes4);
2021 }
2022 
2023 /**
2024  * @title ERC721A
2025  *
2026  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
2027  * Non-Fungible Token Standard, including the Metadata extension.
2028  * Optimized for lower gas during batch mints.
2029  *
2030  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
2031  * starting from `_startTokenId()`.
2032  *
2033  * Assumptions:
2034  *
2035  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2036  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
2037  */
2038 contract ERC721A is IERC721A {
2039     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
2040     struct TokenApprovalRef {
2041         address value;
2042     }
2043 
2044     // =============================================================
2045     //                           CONSTANTS
2046     // =============================================================
2047 
2048     // Mask of an entry in packed address data.
2049     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2050 
2051     // The bit position of `numberMinted` in packed address data.
2052     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
2053 
2054     // The bit position of `numberBurned` in packed address data.
2055     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
2056 
2057     // The bit position of `aux` in packed address data.
2058     uint256 private constant _BITPOS_AUX = 192;
2059 
2060     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2061     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2062 
2063     // The bit position of `startTimestamp` in packed ownership.
2064     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2065 
2066     // The bit mask of the `burned` bit in packed ownership.
2067     uint256 private constant _BITMASK_BURNED = 1 << 224;
2068 
2069     // The bit position of the `nextInitialized` bit in packed ownership.
2070     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2071 
2072     // The bit mask of the `nextInitialized` bit in packed ownership.
2073     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2074 
2075     // The bit position of `extraData` in packed ownership.
2076     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2077 
2078     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2079     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2080 
2081     // The mask of the lower 160 bits for addresses.
2082     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2083 
2084     // The maximum `quantity` that can be minted with {_mintERC2309}.
2085     // This limit is to prevent overflows on the address data entries.
2086     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2087     // is required to cause an overflow, which is unrealistic.
2088     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2089 
2090     // The `Transfer` event signature is given by:
2091     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2092     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2093         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2094 
2095     // =============================================================
2096     //                            STORAGE
2097     // =============================================================
2098 
2099     // The next token ID to be minted.
2100     uint256 private _currentIndex;
2101 
2102     // The number of tokens burned.
2103     uint256 private _burnCounter;
2104 
2105     // Token name
2106     string private _name;
2107 
2108     // Token symbol
2109     string private _symbol;
2110 
2111     // Mapping from token ID to ownership details
2112     // An empty struct value does not necessarily mean the token is unowned.
2113     // See {_packedOwnershipOf} implementation for details.
2114     //
2115     // Bits Layout:
2116     // - [0..159]   `addr`
2117     // - [160..223] `startTimestamp`
2118     // - [224]      `burned`
2119     // - [225]      `nextInitialized`
2120     // - [232..255] `extraData`
2121     mapping(uint256 => uint256) private _packedOwnerships;
2122 
2123     // Mapping owner address to address data.
2124     //
2125     // Bits Layout:
2126     // - [0..63]    `balance`
2127     // - [64..127]  `numberMinted`
2128     // - [128..191] `numberBurned`
2129     // - [192..255] `aux`
2130     mapping(address => uint256) private _packedAddressData;
2131 
2132     // Mapping from token ID to approved address.
2133     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2134 
2135     // Mapping from owner to operator approvals
2136     mapping(address => mapping(address => bool)) private _operatorApprovals;
2137 
2138     // =============================================================
2139     //                          CONSTRUCTOR
2140     // =============================================================
2141 
2142     constructor(string memory name_, string memory symbol_) {
2143         _name = name_;
2144         _symbol = symbol_;
2145         _currentIndex = _startTokenId();
2146     }
2147 
2148     // =============================================================
2149     //                   TOKEN COUNTING OPERATIONS
2150     // =============================================================
2151 
2152     /**
2153      * @dev Returns the starting token ID.
2154      * To change the starting token ID, please override this function.
2155      */
2156     function _startTokenId() internal view virtual returns (uint256) {
2157         return 0;
2158     }
2159 
2160     /**
2161      * @dev Returns the next token ID to be minted.
2162      */
2163     function _nextTokenId() internal view virtual returns (uint256) {
2164         return _currentIndex;
2165     }
2166 
2167     /**
2168      * @dev Returns the total number of tokens in existence.
2169      * Burned tokens will reduce the count.
2170      * To get the total number of tokens minted, please see {_totalMinted}.
2171      */
2172     function totalSupply() public view virtual override returns (uint256) {
2173         // Counter underflow is impossible as _burnCounter cannot be incremented
2174         // more than `_currentIndex - _startTokenId()` times.
2175         unchecked {
2176             return _currentIndex - _burnCounter - _startTokenId();
2177         }
2178     }
2179 
2180     /**
2181      * @dev Returns the total amount of tokens minted in the contract.
2182      */
2183     function _totalMinted() internal view virtual returns (uint256) {
2184         // Counter underflow is impossible as `_currentIndex` does not decrement,
2185         // and it is initialized to `_startTokenId()`.
2186         unchecked {
2187             return _currentIndex - _startTokenId();
2188         }
2189     }
2190 
2191     /**
2192      * @dev Returns the total number of tokens burned.
2193      */
2194     function _totalBurned() internal view virtual returns (uint256) {
2195         return _burnCounter;
2196     }
2197 
2198     // =============================================================
2199     //                    ADDRESS DATA OPERATIONS
2200     // =============================================================
2201 
2202     /**
2203      * @dev Returns the number of tokens in `owner`'s account.
2204      */
2205     function balanceOf(address owner) public view virtual override returns (uint256) {
2206         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2207         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2208     }
2209 
2210     /**
2211      * Returns the number of tokens minted by `owner`.
2212      */
2213     function _numberMinted(address owner) internal view returns (uint256) {
2214         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2215     }
2216 
2217     /**
2218      * Returns the number of tokens burned by or on behalf of `owner`.
2219      */
2220     function _numberBurned(address owner) internal view returns (uint256) {
2221         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2222     }
2223 
2224     /**
2225      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2226      */
2227     function _getAux(address owner) internal view returns (uint64) {
2228         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2229     }
2230 
2231     /**
2232      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2233      * If there are multiple variables, please pack them into a uint64.
2234      */
2235     function _setAux(address owner, uint64 aux) internal virtual {
2236         uint256 packed = _packedAddressData[owner];
2237         uint256 auxCasted;
2238         // Cast `aux` with assembly to avoid redundant masking.
2239         assembly {
2240             auxCasted := aux
2241         }
2242         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2243         _packedAddressData[owner] = packed;
2244     }
2245 
2246     // =============================================================
2247     //                            IERC165
2248     // =============================================================
2249 
2250     /**
2251      * @dev Returns true if this contract implements the interface defined by
2252      * `interfaceId`. See the corresponding
2253      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2254      * to learn more about how these ids are created.
2255      *
2256      * This function call must use less than 30000 gas.
2257      */
2258     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2259         // The interface IDs are constants representing the first 4 bytes
2260         // of the XOR of all function selectors in the interface.
2261         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2262         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2263         return
2264             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2265             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2266             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2267     }
2268 
2269     // =============================================================
2270     //                        IERC721Metadata
2271     // =============================================================
2272 
2273     /**
2274      * @dev Returns the token collection name.
2275      */
2276     function name() public view virtual override returns (string memory) {
2277         return _name;
2278     }
2279 
2280     /**
2281      * @dev Returns the token collection symbol.
2282      */
2283     function symbol() public view virtual override returns (string memory) {
2284         return _symbol;
2285     }
2286 
2287     /**
2288      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2289      */
2290     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2291         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2292 
2293         string memory baseURI = _baseURI();
2294         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2295     }
2296 
2297     /**
2298      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2299      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2300      * by default, it can be overridden in child contracts.
2301      */
2302     function _baseURI() internal view virtual returns (string memory) {
2303         return '';
2304     }
2305 
2306     // =============================================================
2307     //                     OWNERSHIPS OPERATIONS
2308     // =============================================================
2309 
2310     /**
2311      * @dev Returns the owner of the `tokenId` token.
2312      *
2313      * Requirements:
2314      *
2315      * - `tokenId` must exist.
2316      */
2317     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2318         return address(uint160(_packedOwnershipOf(tokenId)));
2319     }
2320 
2321     /**
2322      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2323      * It gradually moves to O(1) as tokens get transferred around over time.
2324      */
2325     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2326         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2327     }
2328 
2329     /**
2330      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2331      */
2332     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2333         return _unpackedOwnership(_packedOwnerships[index]);
2334     }
2335 
2336     /**
2337      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2338      */
2339     function _initializeOwnershipAt(uint256 index) internal virtual {
2340         if (_packedOwnerships[index] == 0) {
2341             _packedOwnerships[index] = _packedOwnershipOf(index);
2342         }
2343     }
2344 
2345     /**
2346      * Returns the packed ownership data of `tokenId`.
2347      */
2348     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2349         uint256 curr = tokenId;
2350 
2351         unchecked {
2352             if (_startTokenId() <= curr)
2353                 if (curr < _currentIndex) {
2354                     uint256 packed = _packedOwnerships[curr];
2355                     // If not burned.
2356                     if (packed & _BITMASK_BURNED == 0) {
2357                         // Invariant:
2358                         // There will always be an initialized ownership slot
2359                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2360                         // before an unintialized ownership slot
2361                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2362                         // Hence, `curr` will not underflow.
2363                         //
2364                         // We can directly compare the packed value.
2365                         // If the address is zero, packed will be zero.
2366                         while (packed == 0) {
2367                             packed = _packedOwnerships[--curr];
2368                         }
2369                         return packed;
2370                     }
2371                 }
2372         }
2373         revert OwnerQueryForNonexistentToken();
2374     }
2375 
2376     /**
2377      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2378      */
2379     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2380         ownership.addr = address(uint160(packed));
2381         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2382         ownership.burned = packed & _BITMASK_BURNED != 0;
2383         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2384     }
2385 
2386     /**
2387      * @dev Packs ownership data into a single uint256.
2388      */
2389     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2390         assembly {
2391             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2392             owner := and(owner, _BITMASK_ADDRESS)
2393             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2394             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2395         }
2396     }
2397 
2398     /**
2399      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2400      */
2401     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2402         // For branchless setting of the `nextInitialized` flag.
2403         assembly {
2404             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2405             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2406         }
2407     }
2408 
2409     // =============================================================
2410     //                      APPROVAL OPERATIONS
2411     // =============================================================
2412 
2413     /**
2414      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2415      * The approval is cleared when the token is transferred.
2416      *
2417      * Only a single account can be approved at a time, so approving the
2418      * zero address clears previous approvals.
2419      *
2420      * Requirements:
2421      *
2422      * - The caller must own the token or be an approved operator.
2423      * - `tokenId` must exist.
2424      *
2425      * Emits an {Approval} event.
2426      */
2427     function approve(address to, uint256 tokenId) public payable virtual override {
2428         address owner = ownerOf(tokenId);
2429 
2430         if (_msgSenderERC721A() != owner)
2431             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2432                 revert ApprovalCallerNotOwnerNorApproved();
2433             }
2434 
2435         _tokenApprovals[tokenId].value = to;
2436         emit Approval(owner, to, tokenId);
2437     }
2438 
2439     /**
2440      * @dev Returns the account approved for `tokenId` token.
2441      *
2442      * Requirements:
2443      *
2444      * - `tokenId` must exist.
2445      */
2446     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2447         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2448 
2449         return _tokenApprovals[tokenId].value;
2450     }
2451 
2452     /**
2453      * @dev Approve or remove `operator` as an operator for the caller.
2454      * Operators can call {transferFrom} or {safeTransferFrom}
2455      * for any token owned by the caller.
2456      *
2457      * Requirements:
2458      *
2459      * - The `operator` cannot be the caller.
2460      *
2461      * Emits an {ApprovalForAll} event.
2462      */
2463     function setApprovalForAll(address operator, bool approved) public virtual override {
2464         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2465         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2466     }
2467 
2468     /**
2469      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2470      *
2471      * See {setApprovalForAll}.
2472      */
2473     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2474         return _operatorApprovals[owner][operator];
2475     }
2476 
2477     /**
2478      * @dev Returns whether `tokenId` exists.
2479      *
2480      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2481      *
2482      * Tokens start existing when they are minted. See {_mint}.
2483      */
2484     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2485         return
2486             _startTokenId() <= tokenId &&
2487             tokenId < _currentIndex && // If within bounds,
2488             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2489     }
2490 
2491     /**
2492      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2493      */
2494     function _isSenderApprovedOrOwner(
2495         address approvedAddress,
2496         address owner,
2497         address msgSender
2498     ) private pure returns (bool result) {
2499         assembly {
2500             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2501             owner := and(owner, _BITMASK_ADDRESS)
2502             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2503             msgSender := and(msgSender, _BITMASK_ADDRESS)
2504             // `msgSender == owner || msgSender == approvedAddress`.
2505             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2506         }
2507     }
2508 
2509     /**
2510      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2511      */
2512     function _getApprovedSlotAndAddress(uint256 tokenId)
2513         private
2514         view
2515         returns (uint256 approvedAddressSlot, address approvedAddress)
2516     {
2517         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2518         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2519         assembly {
2520             approvedAddressSlot := tokenApproval.slot
2521             approvedAddress := sload(approvedAddressSlot)
2522         }
2523     }
2524 
2525     // =============================================================
2526     //                      TRANSFER OPERATIONS
2527     // =============================================================
2528 
2529     /**
2530      * @dev Transfers `tokenId` from `from` to `to`.
2531      *
2532      * Requirements:
2533      *
2534      * - `from` cannot be the zero address.
2535      * - `to` cannot be the zero address.
2536      * - `tokenId` token must be owned by `from`.
2537      * - If the caller is not `from`, it must be approved to move this token
2538      * by either {approve} or {setApprovalForAll}.
2539      *
2540      * Emits a {Transfer} event.
2541      */
2542     function transferFrom(
2543         address from,
2544         address to,
2545         uint256 tokenId
2546     ) public payable virtual override {
2547         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2548 
2549         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2550 
2551         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2552 
2553         // The nested ifs save around 20+ gas over a compound boolean condition.
2554         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2555             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2556 
2557         if (to == address(0)) revert TransferToZeroAddress();
2558 
2559         _beforeTokenTransfers(from, to, tokenId, 1);
2560 
2561         // Clear approvals from the previous owner.
2562         assembly {
2563             if approvedAddress {
2564                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2565                 sstore(approvedAddressSlot, 0)
2566             }
2567         }
2568 
2569         // Underflow of the sender's balance is impossible because we check for
2570         // ownership above and the recipient's balance can't realistically overflow.
2571         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2572         unchecked {
2573             // We can directly increment and decrement the balances.
2574             --_packedAddressData[from]; // Updates: `balance -= 1`.
2575             ++_packedAddressData[to]; // Updates: `balance += 1`.
2576 
2577             // Updates:
2578             // - `address` to the next owner.
2579             // - `startTimestamp` to the timestamp of transfering.
2580             // - `burned` to `false`.
2581             // - `nextInitialized` to `true`.
2582             _packedOwnerships[tokenId] = _packOwnershipData(
2583                 to,
2584                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2585             );
2586 
2587             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2588             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2589                 uint256 nextTokenId = tokenId + 1;
2590                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2591                 if (_packedOwnerships[nextTokenId] == 0) {
2592                     // If the next slot is within bounds.
2593                     if (nextTokenId != _currentIndex) {
2594                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2595                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2596                     }
2597                 }
2598             }
2599         }
2600 
2601         emit Transfer(from, to, tokenId);
2602         _afterTokenTransfers(from, to, tokenId, 1);
2603     }
2604 
2605     /**
2606      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2607      */
2608     function safeTransferFrom(
2609         address from,
2610         address to,
2611         uint256 tokenId
2612     ) public payable virtual override {
2613         safeTransferFrom(from, to, tokenId, '');
2614     }
2615 
2616     /**
2617      * @dev Safely transfers `tokenId` token from `from` to `to`.
2618      *
2619      * Requirements:
2620      *
2621      * - `from` cannot be the zero address.
2622      * - `to` cannot be the zero address.
2623      * - `tokenId` token must exist and be owned by `from`.
2624      * - If the caller is not `from`, it must be approved to move this token
2625      * by either {approve} or {setApprovalForAll}.
2626      * - If `to` refers to a smart contract, it must implement
2627      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2628      *
2629      * Emits a {Transfer} event.
2630      */
2631     function safeTransferFrom(
2632         address from,
2633         address to,
2634         uint256 tokenId,
2635         bytes memory _data
2636     ) public payable virtual override {
2637         transferFrom(from, to, tokenId);
2638         if (to.code.length != 0)
2639             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2640                 revert TransferToNonERC721ReceiverImplementer();
2641             }
2642     }
2643 
2644     /**
2645      * @dev Hook that is called before a set of serially-ordered token IDs
2646      * are about to be transferred. This includes minting.
2647      * And also called before burning one token.
2648      *
2649      * `startTokenId` - the first token ID to be transferred.
2650      * `quantity` - the amount to be transferred.
2651      *
2652      * Calling conditions:
2653      *
2654      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2655      * transferred to `to`.
2656      * - When `from` is zero, `tokenId` will be minted for `to`.
2657      * - When `to` is zero, `tokenId` will be burned by `from`.
2658      * - `from` and `to` are never both zero.
2659      */
2660     function _beforeTokenTransfers(
2661         address from,
2662         address to,
2663         uint256 startTokenId,
2664         uint256 quantity
2665     ) internal virtual {}
2666 
2667     /**
2668      * @dev Hook that is called after a set of serially-ordered token IDs
2669      * have been transferred. This includes minting.
2670      * And also called after one token has been burned.
2671      *
2672      * `startTokenId` - the first token ID to be transferred.
2673      * `quantity` - the amount to be transferred.
2674      *
2675      * Calling conditions:
2676      *
2677      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2678      * transferred to `to`.
2679      * - When `from` is zero, `tokenId` has been minted for `to`.
2680      * - When `to` is zero, `tokenId` has been burned by `from`.
2681      * - `from` and `to` are never both zero.
2682      */
2683     function _afterTokenTransfers(
2684         address from,
2685         address to,
2686         uint256 startTokenId,
2687         uint256 quantity
2688     ) internal virtual {}
2689 
2690     /**
2691      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2692      *
2693      * `from` - Previous owner of the given token ID.
2694      * `to` - Target address that will receive the token.
2695      * `tokenId` - Token ID to be transferred.
2696      * `_data` - Optional data to send along with the call.
2697      *
2698      * Returns whether the call correctly returned the expected magic value.
2699      */
2700     function _checkContractOnERC721Received(
2701         address from,
2702         address to,
2703         uint256 tokenId,
2704         bytes memory _data
2705     ) private returns (bool) {
2706         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2707             bytes4 retval
2708         ) {
2709             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2710         } catch (bytes memory reason) {
2711             if (reason.length == 0) {
2712                 revert TransferToNonERC721ReceiverImplementer();
2713             } else {
2714                 assembly {
2715                     revert(add(32, reason), mload(reason))
2716                 }
2717             }
2718         }
2719     }
2720 
2721     // =============================================================
2722     //                        MINT OPERATIONS
2723     // =============================================================
2724 
2725     /**
2726      * @dev Mints `quantity` tokens and transfers them to `to`.
2727      *
2728      * Requirements:
2729      *
2730      * - `to` cannot be the zero address.
2731      * - `quantity` must be greater than 0.
2732      *
2733      * Emits a {Transfer} event for each mint.
2734      */
2735     function _mint(address to, uint256 quantity) internal virtual {
2736         uint256 startTokenId = _currentIndex;
2737         if (quantity == 0) revert MintZeroQuantity();
2738 
2739         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2740 
2741         // Overflows are incredibly unrealistic.
2742         // `balance` and `numberMinted` have a maximum limit of 2**64.
2743         // `tokenId` has a maximum limit of 2**256.
2744         unchecked {
2745             // Updates:
2746             // - `balance += quantity`.
2747             // - `numberMinted += quantity`.
2748             //
2749             // We can directly add to the `balance` and `numberMinted`.
2750             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2751 
2752             // Updates:
2753             // - `address` to the owner.
2754             // - `startTimestamp` to the timestamp of minting.
2755             // - `burned` to `false`.
2756             // - `nextInitialized` to `quantity == 1`.
2757             _packedOwnerships[startTokenId] = _packOwnershipData(
2758                 to,
2759                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2760             );
2761 
2762             uint256 toMasked;
2763             uint256 end = startTokenId + quantity;
2764 
2765             // Use assembly to loop and emit the `Transfer` event for gas savings.
2766             // The duplicated `log4` removes an extra check and reduces stack juggling.
2767             // The assembly, together with the surrounding Solidity code, have been
2768             // delicately arranged to nudge the compiler into producing optimized opcodes.
2769             assembly {
2770                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2771                 toMasked := and(to, _BITMASK_ADDRESS)
2772                 // Emit the `Transfer` event.
2773                 log4(
2774                     0, // Start of data (0, since no data).
2775                     0, // End of data (0, since no data).
2776                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2777                     0, // `address(0)`.
2778                     toMasked, // `to`.
2779                     startTokenId // `tokenId`.
2780                 )
2781 
2782                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2783                 // that overflows uint256 will make the loop run out of gas.
2784                 // The compiler will optimize the `iszero` away for performance.
2785                 for {
2786                     let tokenId := add(startTokenId, 1)
2787                 } iszero(eq(tokenId, end)) {
2788                     tokenId := add(tokenId, 1)
2789                 } {
2790                     // Emit the `Transfer` event. Similar to above.
2791                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2792                 }
2793             }
2794             if (toMasked == 0) revert MintToZeroAddress();
2795 
2796             _currentIndex = end;
2797         }
2798         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2799     }
2800 
2801     /**
2802      * @dev Mints `quantity` tokens and transfers them to `to`.
2803      *
2804      * This function is intended for efficient minting only during contract creation.
2805      *
2806      * It emits only one {ConsecutiveTransfer} as defined in
2807      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2808      * instead of a sequence of {Transfer} event(s).
2809      *
2810      * Calling this function outside of contract creation WILL make your contract
2811      * non-compliant with the ERC721 standard.
2812      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2813      * {ConsecutiveTransfer} event is only permissible during contract creation.
2814      *
2815      * Requirements:
2816      *
2817      * - `to` cannot be the zero address.
2818      * - `quantity` must be greater than 0.
2819      *
2820      * Emits a {ConsecutiveTransfer} event.
2821      */
2822     function _mintERC2309(address to, uint256 quantity) internal virtual {
2823         uint256 startTokenId = _currentIndex;
2824         if (to == address(0)) revert MintToZeroAddress();
2825         if (quantity == 0) revert MintZeroQuantity();
2826         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2827 
2828         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2829 
2830         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2831         unchecked {
2832             // Updates:
2833             // - `balance += quantity`.
2834             // - `numberMinted += quantity`.
2835             //
2836             // We can directly add to the `balance` and `numberMinted`.
2837             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2838 
2839             // Updates:
2840             // - `address` to the owner.
2841             // - `startTimestamp` to the timestamp of minting.
2842             // - `burned` to `false`.
2843             // - `nextInitialized` to `quantity == 1`.
2844             _packedOwnerships[startTokenId] = _packOwnershipData(
2845                 to,
2846                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2847             );
2848 
2849             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2850 
2851             _currentIndex = startTokenId + quantity;
2852         }
2853         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2854     }
2855 
2856     /**
2857      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2858      *
2859      * Requirements:
2860      *
2861      * - If `to` refers to a smart contract, it must implement
2862      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2863      * - `quantity` must be greater than 0.
2864      *
2865      * See {_mint}.
2866      *
2867      * Emits a {Transfer} event for each mint.
2868      */
2869     function _safeMint(
2870         address to,
2871         uint256 quantity,
2872         bytes memory _data
2873     ) internal virtual {
2874         _mint(to, quantity);
2875 
2876         unchecked {
2877             if (to.code.length != 0) {
2878                 uint256 end = _currentIndex;
2879                 uint256 index = end - quantity;
2880                 do {
2881                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2882                         revert TransferToNonERC721ReceiverImplementer();
2883                     }
2884                 } while (index < end);
2885                 // Reentrancy protection.
2886                 if (_currentIndex != end) revert();
2887             }
2888         }
2889     }
2890 
2891     /**
2892      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2893      */
2894     function _safeMint(address to, uint256 quantity) internal virtual {
2895         _safeMint(to, quantity, '');
2896     }
2897 
2898     // =============================================================
2899     //                        BURN OPERATIONS
2900     // =============================================================
2901 
2902     /**
2903      * @dev Equivalent to `_burn(tokenId, false)`.
2904      */
2905     function _burn(uint256 tokenId) internal virtual {
2906         _burn(tokenId, false);
2907     }
2908 
2909     /**
2910      * @dev Destroys `tokenId`.
2911      * The approval is cleared when the token is burned.
2912      *
2913      * Requirements:
2914      *
2915      * - `tokenId` must exist.
2916      *
2917      * Emits a {Transfer} event.
2918      */
2919     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2920         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2921 
2922         address from = address(uint160(prevOwnershipPacked));
2923 
2924         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2925 
2926         if (approvalCheck) {
2927             // The nested ifs save around 20+ gas over a compound boolean condition.
2928             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2929                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2930         }
2931 
2932         _beforeTokenTransfers(from, address(0), tokenId, 1);
2933 
2934         // Clear approvals from the previous owner.
2935         assembly {
2936             if approvedAddress {
2937                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2938                 sstore(approvedAddressSlot, 0)
2939             }
2940         }
2941 
2942         // Underflow of the sender's balance is impossible because we check for
2943         // ownership above and the recipient's balance can't realistically overflow.
2944         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2945         unchecked {
2946             // Updates:
2947             // - `balance -= 1`.
2948             // - `numberBurned += 1`.
2949             //
2950             // We can directly decrement the balance, and increment the number burned.
2951             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2952             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2953 
2954             // Updates:
2955             // - `address` to the last owner.
2956             // - `startTimestamp` to the timestamp of burning.
2957             // - `burned` to `true`.
2958             // - `nextInitialized` to `true`.
2959             _packedOwnerships[tokenId] = _packOwnershipData(
2960                 from,
2961                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2962             );
2963 
2964             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2965             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2966                 uint256 nextTokenId = tokenId + 1;
2967                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2968                 if (_packedOwnerships[nextTokenId] == 0) {
2969                     // If the next slot is within bounds.
2970                     if (nextTokenId != _currentIndex) {
2971                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2972                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2973                     }
2974                 }
2975             }
2976         }
2977 
2978         emit Transfer(from, address(0), tokenId);
2979         _afterTokenTransfers(from, address(0), tokenId, 1);
2980 
2981         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2982         unchecked {
2983             _burnCounter++;
2984         }
2985     }
2986 
2987     // =============================================================
2988     //                     EXTRA DATA OPERATIONS
2989     // =============================================================
2990 
2991     /**
2992      * @dev Directly sets the extra data for the ownership data `index`.
2993      */
2994     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2995         uint256 packed = _packedOwnerships[index];
2996         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2997         uint256 extraDataCasted;
2998         // Cast `extraData` with assembly to avoid redundant masking.
2999         assembly {
3000             extraDataCasted := extraData
3001         }
3002         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
3003         _packedOwnerships[index] = packed;
3004     }
3005 
3006     /**
3007      * @dev Called during each token transfer to set the 24bit `extraData` field.
3008      * Intended to be overridden by the cosumer contract.
3009      *
3010      * `previousExtraData` - the value of `extraData` before transfer.
3011      *
3012      * Calling conditions:
3013      *
3014      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3015      * transferred to `to`.
3016      * - When `from` is zero, `tokenId` will be minted for `to`.
3017      * - When `to` is zero, `tokenId` will be burned by `from`.
3018      * - `from` and `to` are never both zero.
3019      */
3020     function _extraData(
3021         address from,
3022         address to,
3023         uint24 previousExtraData
3024     ) internal view virtual returns (uint24) {}
3025 
3026     /**
3027      * @dev Returns the next extra data for the packed ownership data.
3028      * The returned result is shifted into position.
3029      */
3030     function _nextExtraData(
3031         address from,
3032         address to,
3033         uint256 prevOwnershipPacked
3034     ) private view returns (uint256) {
3035         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3036         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3037     }
3038 
3039     // =============================================================
3040     //                       OTHER OPERATIONS
3041     // =============================================================
3042 
3043     /**
3044      * @dev Returns the message sender (defaults to `msg.sender`).
3045      *
3046      * If you are writing GSN compatible contracts, you need to override this function.
3047      */
3048     function _msgSenderERC721A() internal view virtual returns (address) {
3049         return msg.sender;
3050     }
3051 
3052     /**
3053      * @dev Converts a uint256 to its ASCII string decimal representation.
3054      */
3055     function _toString(uint256 value) internal pure virtual returns (string memory str) {
3056         assembly {
3057             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
3058             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
3059             // We will need 1 word for the trailing zeros padding, 1 word for the length,
3060             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
3061             let m := add(mload(0x40), 0xa0)
3062             // Update the free memory pointer to allocate.
3063             mstore(0x40, m)
3064             // Assign the `str` to the end.
3065             str := sub(m, 0x20)
3066             // Zeroize the slot after the string.
3067             mstore(str, 0)
3068 
3069             // Cache the end of the memory to calculate the length later.
3070             let end := str
3071 
3072             // We write the string from rightmost digit to leftmost digit.
3073             // The following is essentially a do-while loop that also handles the zero case.
3074             // prettier-ignore
3075             for { let temp := value } 1 {} {
3076                 str := sub(str, 1)
3077                 // Write the character to the pointer.
3078                 // The ASCII index of the '0' character is 48.
3079                 mstore8(str, add(48, mod(temp, 10)))
3080                 // Keep dividing `temp` until zero.
3081                 temp := div(temp, 10)
3082                 // prettier-ignore
3083                 if iszero(temp) { break }
3084             }
3085 
3086             let length := sub(end, str)
3087             // Move the pointer 32 bytes leftwards to make room for the length.
3088             str := sub(str, 0x20)
3089             // Store the length.
3090             mstore(str, length)
3091         }
3092     }
3093 }
3094 
3095 // File: neonft.sol
3096 
3097 
3098 pragma solidity ^0.8.14;
3099 
3100 
3101 
3102 
3103 
3104 
3105 contract NEOnft is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
3106     string public baseURI;
3107     uint256 public currentSupply = 0;
3108     uint256 public mintLimit = 10;
3109     uint256 public presaleMaxMint = 3;
3110     uint256 public _totalSupply = 3333;
3111     uint256 public cost = 0.001 ether;
3112     bool public paused = true;
3113     bool public presale = true;
3114     bool public revealed = true;
3115     mapping(address => bool) private whitelisted;
3116     mapping(address => uint256) private walletMintedBalance;
3117     address public collabAddress = 0xcBf92Aac95b9f46F6686f69360550d1fb76fA065;
3118 
3119     constructor(string memory _initBaseURI)
3120         ERC721A("NEO NFTS", "NEO")
3121     {
3122         baseURI = _initBaseURI;
3123     }
3124 
3125     function _baseURI() internal view virtual override returns (string memory) {
3126         return baseURI;
3127     }
3128 
3129     modifier mintCompliance(uint256 quantity) {
3130         require(quantity > 0 && quantity <= mintLimit, "Invalid mint amount!");
3131         require(
3132             currentSupply + quantity <= _totalSupply,
3133             "You can't mint more than available token"
3134         );
3135         _;
3136     }
3137 
3138     function mint(uint256 quantity) external payable mintCompliance(quantity) {
3139         require(!paused, "The contract is paused!");
3140         require(
3141             tx.origin == msg.sender,
3142             "Cannot mint through a custom contract"
3143         );
3144         if (msg.sender != owner()) {
3145             if (presale) {
3146                 require(whitelisted[msg.sender], "Wallet not whitelisted");
3147                 require(
3148                     walletMintedBalance[msg.sender] + quantity <= presaleMaxMint,
3149                     "Presale token limit reached"
3150                 );
3151             }
3152             require(msg.value >= quantity * cost);
3153         }
3154         _mintNft(quantity);
3155     }
3156 
3157     function _mintNft(uint256 _mintAmount) internal {
3158         _safeMint(msg.sender, _mintAmount);
3159         if (presale) {
3160             for (uint256 i = 1; i <= _mintAmount; i++) {
3161                 walletMintedBalance[msg.sender]++;
3162             }
3163         }
3164         currentSupply = currentSupply + _mintAmount;
3165     }
3166 
3167     function tokenURI(uint256 tokenId)
3168         public
3169         view
3170         override
3171         returns (string memory)
3172     {
3173         require(
3174             _exists(tokenId),
3175             "ERC721Metadata: URI query for nonexistant token"
3176         );
3177         string memory currentBaseURI = _baseURI();
3178         if (revealed) {
3179             return
3180                 bytes(currentBaseURI).length > 0
3181                     ? string(
3182                         abi.encodePacked(
3183                             currentBaseURI,
3184                             Strings.toString(tokenId),
3185                             ".json"
3186                         )
3187                     )
3188                     : "";
3189         } else {
3190             return string(abi.encodePacked(_baseURI(), "hidden.json"));
3191         }
3192     }
3193 
3194     function isWhitelisted(address _user) public view onlyOwner returns (bool) {
3195         return whitelisted[_user];
3196     }
3197 
3198     function getWalletPremintBalance(address _user) public view onlyOwner returns (uint256) {
3199         return walletMintedBalance[_user];
3200     }
3201 
3202     function setPaused(bool _state) public onlyOwner {
3203         paused = _state;
3204     }
3205 
3206     function setRevealed(bool _state) public onlyOwner {
3207         revealed = _state;
3208     }
3209 
3210     function setPresale(bool _state) public onlyOwner {
3211         presale = _state;
3212     }
3213 
3214     function setPricePerNFT(uint256 _newpricePerNFT) public onlyOwner {
3215         cost = _newpricePerNFT;
3216     }
3217   
3218     function setbaseURI(string memory baseURI_) public onlyOwner {
3219         baseURI = baseURI_;
3220     }
3221 
3222     function addWhitelistUsers(address[] calldata _users) public onlyOwner {
3223         for (uint256 i; i < _users.length; i++) {
3224             whitelisted[_users[i]] = true;
3225         }
3226     }
3227 
3228     function addWhitelistUser(address _user) public onlyOwner {
3229         whitelisted[_user] = true;
3230     }
3231 
3232     function removeWhitelistUser(address _user) public onlyOwner {
3233         whitelisted[_user] = false;
3234     }
3235 
3236     function withdraw() public payable nonReentrant onlyOwner {
3237         (bool oh, ) = payable(collabAddress).call{
3238             value: (address(this).balance * 1) / 100
3239         }("");
3240         require(oh);
3241 
3242         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
3243         require(os);
3244     }
3245 
3246     /**
3247      * @dev implements operator-filter-registry blocklist filtering because https://opensea.io/blog/announcements/on-creator-fees/
3248      */
3249     function transferFrom(
3250         address from,
3251         address to,
3252         uint256 tokenId
3253     ) public payable override(ERC721A) onlyAllowedOperator(from) {
3254         super.transferFrom(from, to, tokenId);
3255     }    
3256 
3257     /**
3258      * @dev implements operator-filter-registry blocklist filtering because https://opensea.io/blog/announcements/on-creator-fees/
3259      */
3260     function safeTransferFrom(
3261         address from,
3262         address to,
3263         uint256 tokenId
3264     ) public payable override(ERC721A) onlyAllowedOperator(from) {
3265         super.safeTransferFrom(from, to, tokenId);
3266     }
3267 
3268     /**
3269      * @dev implements operator-filter-registry blocklist filtering because https://opensea.io/blog/announcements/on-creator-fees/
3270      */
3271     function safeTransferFrom(
3272         address from,
3273         address to,
3274         uint256 tokenId,
3275         bytes memory data
3276     ) public payable override(ERC721A) onlyAllowedOperator(from) {
3277         super.safeTransferFrom(from, to, tokenId, data);
3278     }    
3279 }