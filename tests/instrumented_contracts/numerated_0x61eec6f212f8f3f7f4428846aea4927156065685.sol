1 // SPDX-License-Identifier: MIT
2 
3 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
4 
5 
6 pragma solidity ^0.8.13;
7 
8 interface IOperatorFilterRegistry {
9     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
10     function register(address registrant) external;
11     function registerAndSubscribe(address registrant, address subscription) external;
12     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
13     function unregister(address addr) external;
14     function updateOperator(address registrant, address operator, bool filtered) external;
15     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
16     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
17     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
18     function subscribe(address registrant, address registrantToSubscribe) external;
19     function unsubscribe(address registrant, bool copyExistingEntries) external;
20     function subscriptionOf(address addr) external returns (address registrant);
21     function subscribers(address registrant) external returns (address[] memory);
22     function subscriberAt(address registrant, uint256 index) external returns (address);
23     function copyEntriesOf(address registrant, address registrantToCopy) external;
24     function isOperatorFiltered(address registrant, address operator) external returns (bool);
25     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
26     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
27     function filteredOperators(address addr) external returns (address[] memory);
28     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
29     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
30     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
31     function isRegistered(address addr) external returns (bool);
32     function codeHashOf(address addr) external returns (bytes32);
33 }
34 
35 // File: operator-filter-registry/src/OperatorFilterer.sol
36 
37 
38 pragma solidity ^0.8.13;
39 
40 
41 /**
42  * @title  OperatorFilterer
43  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
44  *         registrant's entries in the OperatorFilterRegistry.
45  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
46  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
47  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
48  */
49 abstract contract OperatorFilterer {
50     error OperatorNotAllowed(address operator);
51 
52     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
53         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
54 
55     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
56         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
57         // will not revert, but the contract will need to be registered with the registry once it is deployed in
58         // order for the modifier to filter addresses.
59         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
60             if (subscribe) {
61                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
62             } else {
63                 if (subscriptionOrRegistrantToCopy != address(0)) {
64                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
65                 } else {
66                     OPERATOR_FILTER_REGISTRY.register(address(this));
67                 }
68             }
69         }
70     }
71 
72     modifier onlyAllowedOperator(address from) virtual {
73         // Allow spending tokens from addresses with balance
74         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75         // from an EOA.
76         if (from != msg.sender) {
77             _checkFilterOperator(msg.sender);
78         }
79         _;
80     }
81 
82     modifier onlyAllowedOperatorApproval(address operator) virtual {
83         _checkFilterOperator(operator);
84         _;
85     }
86 
87     function _checkFilterOperator(address operator) internal view virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94     }
95 }
96 
97 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
98 
99 
100 pragma solidity ^0.8.13;
101 
102 
103 /**
104  * @title  DefaultOperatorFilterer
105  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
106  */
107 abstract contract DefaultOperatorFilterer is OperatorFilterer {
108     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
109 
110     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
111 }
112 
113 // File: @openzeppelin/contracts/utils/Counters.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @title Counters
122  * @author Matt Condon (@shrugs)
123  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
124  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
125  *
126  * Include with `using Counters for Counters.Counter;`
127  */
128 library Counters {
129     struct Counter {
130         // This variable should never be directly accessed by users of the library: interactions must be restricted to
131         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
132         // this feature: see https://github.com/ethereum/solidity/issues/4637
133         uint256 _value; // default: 0
134     }
135 
136     function current(Counter storage counter) internal view returns (uint256) {
137         return counter._value;
138     }
139 
140     function increment(Counter storage counter) internal {
141         unchecked {
142             counter._value += 1;
143         }
144     }
145 
146     function decrement(Counter storage counter) internal {
147         uint256 value = counter._value;
148         require(value > 0, "Counter: decrement overflow");
149         unchecked {
150             counter._value = value - 1;
151         }
152     }
153 
154     function reset(Counter storage counter) internal {
155         counter._value = 0;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/utils/math/Math.sol
160 
161 
162 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev Standard math utilities missing in the Solidity language.
168  */
169 library Math {
170     enum Rounding {
171         Down, // Toward negative infinity
172         Up, // Toward infinity
173         Zero // Toward zero
174     }
175 
176     /**
177      * @dev Returns the largest of two numbers.
178      */
179     function max(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a > b ? a : b;
181     }
182 
183     /**
184      * @dev Returns the smallest of two numbers.
185      */
186     function min(uint256 a, uint256 b) internal pure returns (uint256) {
187         return a < b ? a : b;
188     }
189 
190     /**
191      * @dev Returns the average of two numbers. The result is rounded towards
192      * zero.
193      */
194     function average(uint256 a, uint256 b) internal pure returns (uint256) {
195         // (a + b) / 2 can overflow.
196         return (a & b) + (a ^ b) / 2;
197     }
198 
199     /**
200      * @dev Returns the ceiling of the division of two numbers.
201      *
202      * This differs from standard division with `/` in that it rounds up instead
203      * of rounding down.
204      */
205     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
206         // (a + b - 1) / b can overflow on addition, so we distribute.
207         return a == 0 ? 0 : (a - 1) / b + 1;
208     }
209 
210     /**
211      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
212      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
213      * with further edits by Uniswap Labs also under MIT license.
214      */
215     function mulDiv(
216         uint256 x,
217         uint256 y,
218         uint256 denominator
219     ) internal pure returns (uint256 result) {
220         unchecked {
221             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
222             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
223             // variables such that product = prod1 * 2^256 + prod0.
224             uint256 prod0; // Least significant 256 bits of the product
225             uint256 prod1; // Most significant 256 bits of the product
226             assembly {
227                 let mm := mulmod(x, y, not(0))
228                 prod0 := mul(x, y)
229                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
230             }
231 
232             // Handle non-overflow cases, 256 by 256 division.
233             if (prod1 == 0) {
234                 return prod0 / denominator;
235             }
236 
237             // Make sure the result is less than 2^256. Also prevents denominator == 0.
238             require(denominator > prod1);
239 
240             ///////////////////////////////////////////////
241             // 512 by 256 division.
242             ///////////////////////////////////////////////
243 
244             // Make division exact by subtracting the remainder from [prod1 prod0].
245             uint256 remainder;
246             assembly {
247                 // Compute remainder using mulmod.
248                 remainder := mulmod(x, y, denominator)
249 
250                 // Subtract 256 bit number from 512 bit number.
251                 prod1 := sub(prod1, gt(remainder, prod0))
252                 prod0 := sub(prod0, remainder)
253             }
254 
255             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
256             // See https://cs.stackexchange.com/q/138556/92363.
257 
258             // Does not overflow because the denominator cannot be zero at this stage in the function.
259             uint256 twos = denominator & (~denominator + 1);
260             assembly {
261                 // Divide denominator by twos.
262                 denominator := div(denominator, twos)
263 
264                 // Divide [prod1 prod0] by twos.
265                 prod0 := div(prod0, twos)
266 
267                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
268                 twos := add(div(sub(0, twos), twos), 1)
269             }
270 
271             // Shift in bits from prod1 into prod0.
272             prod0 |= prod1 * twos;
273 
274             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
275             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
276             // four bits. That is, denominator * inv = 1 mod 2^4.
277             uint256 inverse = (3 * denominator) ^ 2;
278 
279             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
280             // in modular arithmetic, doubling the correct bits in each step.
281             inverse *= 2 - denominator * inverse; // inverse mod 2^8
282             inverse *= 2 - denominator * inverse; // inverse mod 2^16
283             inverse *= 2 - denominator * inverse; // inverse mod 2^32
284             inverse *= 2 - denominator * inverse; // inverse mod 2^64
285             inverse *= 2 - denominator * inverse; // inverse mod 2^128
286             inverse *= 2 - denominator * inverse; // inverse mod 2^256
287 
288             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
289             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
290             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
291             // is no longer required.
292             result = prod0 * inverse;
293             return result;
294         }
295     }
296 
297     /**
298      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
299      */
300     function mulDiv(
301         uint256 x,
302         uint256 y,
303         uint256 denominator,
304         Rounding rounding
305     ) internal pure returns (uint256) {
306         uint256 result = mulDiv(x, y, denominator);
307         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
308             result += 1;
309         }
310         return result;
311     }
312 
313     /**
314      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
315      *
316      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
317      */
318     function sqrt(uint256 a) internal pure returns (uint256) {
319         if (a == 0) {
320             return 0;
321         }
322 
323         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
324         //
325         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
326         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
327         //
328         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
329         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
330         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
331         //
332         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
333         uint256 result = 1 << (log2(a) >> 1);
334 
335         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
336         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
337         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
338         // into the expected uint128 result.
339         unchecked {
340             result = (result + a / result) >> 1;
341             result = (result + a / result) >> 1;
342             result = (result + a / result) >> 1;
343             result = (result + a / result) >> 1;
344             result = (result + a / result) >> 1;
345             result = (result + a / result) >> 1;
346             result = (result + a / result) >> 1;
347             return min(result, a / result);
348         }
349     }
350 
351     /**
352      * @notice Calculates sqrt(a), following the selected rounding direction.
353      */
354     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
355         unchecked {
356             uint256 result = sqrt(a);
357             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
358         }
359     }
360 
361     /**
362      * @dev Return the log in base 2, rounded down, of a positive value.
363      * Returns 0 if given 0.
364      */
365     function log2(uint256 value) internal pure returns (uint256) {
366         uint256 result = 0;
367         unchecked {
368             if (value >> 128 > 0) {
369                 value >>= 128;
370                 result += 128;
371             }
372             if (value >> 64 > 0) {
373                 value >>= 64;
374                 result += 64;
375             }
376             if (value >> 32 > 0) {
377                 value >>= 32;
378                 result += 32;
379             }
380             if (value >> 16 > 0) {
381                 value >>= 16;
382                 result += 16;
383             }
384             if (value >> 8 > 0) {
385                 value >>= 8;
386                 result += 8;
387             }
388             if (value >> 4 > 0) {
389                 value >>= 4;
390                 result += 4;
391             }
392             if (value >> 2 > 0) {
393                 value >>= 2;
394                 result += 2;
395             }
396             if (value >> 1 > 0) {
397                 result += 1;
398             }
399         }
400         return result;
401     }
402 
403     /**
404      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
405      * Returns 0 if given 0.
406      */
407     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
408         unchecked {
409             uint256 result = log2(value);
410             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
411         }
412     }
413 
414     /**
415      * @dev Return the log in base 10, rounded down, of a positive value.
416      * Returns 0 if given 0.
417      */
418     function log10(uint256 value) internal pure returns (uint256) {
419         uint256 result = 0;
420         unchecked {
421             if (value >= 10**64) {
422                 value /= 10**64;
423                 result += 64;
424             }
425             if (value >= 10**32) {
426                 value /= 10**32;
427                 result += 32;
428             }
429             if (value >= 10**16) {
430                 value /= 10**16;
431                 result += 16;
432             }
433             if (value >= 10**8) {
434                 value /= 10**8;
435                 result += 8;
436             }
437             if (value >= 10**4) {
438                 value /= 10**4;
439                 result += 4;
440             }
441             if (value >= 10**2) {
442                 value /= 10**2;
443                 result += 2;
444             }
445             if (value >= 10**1) {
446                 result += 1;
447             }
448         }
449         return result;
450     }
451 
452     /**
453      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
454      * Returns 0 if given 0.
455      */
456     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
457         unchecked {
458             uint256 result = log10(value);
459             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
460         }
461     }
462 
463     /**
464      * @dev Return the log in base 256, rounded down, of a positive value.
465      * Returns 0 if given 0.
466      *
467      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
468      */
469     function log256(uint256 value) internal pure returns (uint256) {
470         uint256 result = 0;
471         unchecked {
472             if (value >> 128 > 0) {
473                 value >>= 128;
474                 result += 16;
475             }
476             if (value >> 64 > 0) {
477                 value >>= 64;
478                 result += 8;
479             }
480             if (value >> 32 > 0) {
481                 value >>= 32;
482                 result += 4;
483             }
484             if (value >> 16 > 0) {
485                 value >>= 16;
486                 result += 2;
487             }
488             if (value >> 8 > 0) {
489                 result += 1;
490             }
491         }
492         return result;
493     }
494 
495     /**
496      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
497      * Returns 0 if given 0.
498      */
499     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
500         unchecked {
501             uint256 result = log256(value);
502             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
503         }
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/Strings.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev String operations.
517  */
518 library Strings {
519     bytes16 private constant _SYMBOLS = "0123456789abcdef";
520     uint8 private constant _ADDRESS_LENGTH = 20;
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
524      */
525     function toString(uint256 value) internal pure returns (string memory) {
526         unchecked {
527             uint256 length = Math.log10(value) + 1;
528             string memory buffer = new string(length);
529             uint256 ptr;
530             /// @solidity memory-safe-assembly
531             assembly {
532                 ptr := add(buffer, add(32, length))
533             }
534             while (true) {
535                 ptr--;
536                 /// @solidity memory-safe-assembly
537                 assembly {
538                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
539                 }
540                 value /= 10;
541                 if (value == 0) break;
542             }
543             return buffer;
544         }
545     }
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
549      */
550     function toHexString(uint256 value) internal pure returns (string memory) {
551         unchecked {
552             return toHexString(value, Math.log256(value) + 1);
553         }
554     }
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
558      */
559     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
560         bytes memory buffer = new bytes(2 * length + 2);
561         buffer[0] = "0";
562         buffer[1] = "x";
563         for (uint256 i = 2 * length + 1; i > 1; --i) {
564             buffer[i] = _SYMBOLS[value & 0xf];
565             value >>= 4;
566         }
567         require(value == 0, "Strings: hex length insufficient");
568         return string(buffer);
569     }
570 
571     /**
572      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
573      */
574     function toHexString(address addr) internal pure returns (string memory) {
575         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
576     }
577 }
578 
579 // File: @openzeppelin/contracts/utils/Context.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @dev Provides information about the current execution context, including the
588  * sender of the transaction and its data. While these are generally available
589  * via msg.sender and msg.data, they should not be accessed in such a direct
590  * manner, since when dealing with meta-transactions the account sending and
591  * paying for execution may not be the actual sender (as far as an application
592  * is concerned).
593  *
594  * This contract is only required for intermediate, library-like contracts.
595  */
596 abstract contract Context {
597     function _msgSender() internal view virtual returns (address) {
598         return msg.sender;
599     }
600 
601     function _msgData() internal view virtual returns (bytes calldata) {
602         return msg.data;
603     }
604 }
605 
606 // File: @openzeppelin/contracts/access/Ownable.sol
607 
608 
609 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Contract module which provides a basic access control mechanism, where
616  * there is an account (an owner) that can be granted exclusive access to
617  * specific functions.
618  *
619  * By default, the owner account will be the one that deploys the contract. This
620  * can later be changed with {transferOwnership}.
621  *
622  * This module is used through inheritance. It will make available the modifier
623  * `onlyOwner`, which can be applied to your functions to restrict their use to
624  * the owner.
625  */
626 abstract contract Ownable is Context {
627     address private _owner;
628 
629     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
630 
631     /**
632      * @dev Initializes the contract setting the deployer as the initial owner.
633      */
634     constructor() {
635         _transferOwnership(_msgSender());
636     }
637 
638     /**
639      * @dev Throws if called by any account other than the owner.
640      */
641     modifier onlyOwner() {
642         _checkOwner();
643         _;
644     }
645 
646     /**
647      * @dev Returns the address of the current owner.
648      */
649     function owner() public view virtual returns (address) {
650         return _owner;
651     }
652 
653     /**
654      * @dev Throws if the sender is not the owner.
655      */
656     function _checkOwner() internal view virtual {
657         require(owner() == _msgSender(), "Ownable: caller is not the owner");
658     }
659 
660     /**
661      * @dev Leaves the contract without owner. It will not be possible to call
662      * `onlyOwner` functions anymore. Can only be called by the current owner.
663      *
664      * NOTE: Renouncing ownership will leave the contract without an owner,
665      * thereby removing any functionality that is only available to the owner.
666      */
667     function renounceOwnership() public virtual onlyOwner {
668         _transferOwnership(address(0));
669     }
670 
671     /**
672      * @dev Transfers ownership of the contract to a new account (`newOwner`).
673      * Can only be called by the current owner.
674      */
675     function transferOwnership(address newOwner) public virtual onlyOwner {
676         require(newOwner != address(0), "Ownable: new owner is the zero address");
677         _transferOwnership(newOwner);
678     }
679 
680     /**
681      * @dev Transfers ownership of the contract to a new account (`newOwner`).
682      * Internal function without access restriction.
683      */
684     function _transferOwnership(address newOwner) internal virtual {
685         address oldOwner = _owner;
686         _owner = newOwner;
687         emit OwnershipTransferred(oldOwner, newOwner);
688     }
689 }
690 
691 // File: @openzeppelin/contracts/utils/Address.sol
692 
693 
694 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
695 
696 pragma solidity ^0.8.1;
697 
698 /**
699  * @dev Collection of functions related to the address type
700  */
701 library Address {
702     /**
703      * @dev Returns true if `account` is a contract.
704      *
705      * [IMPORTANT]
706      * ====
707      * It is unsafe to assume that an address for which this function returns
708      * false is an externally-owned account (EOA) and not a contract.
709      *
710      * Among others, `isContract` will return false for the following
711      * types of addresses:
712      *
713      *  - an externally-owned account
714      *  - a contract in construction
715      *  - an address where a contract will be created
716      *  - an address where a contract lived, but was destroyed
717      * ====
718      *
719      * [IMPORTANT]
720      * ====
721      * You shouldn't rely on `isContract` to protect against flash loan attacks!
722      *
723      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
724      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
725      * constructor.
726      * ====
727      */
728     function isContract(address account) internal view returns (bool) {
729         // This method relies on extcodesize/address.code.length, which returns 0
730         // for contracts in construction, since the code is only stored at the end
731         // of the constructor execution.
732 
733         return account.code.length > 0;
734     }
735 
736     /**
737      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
738      * `recipient`, forwarding all available gas and reverting on errors.
739      *
740      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
741      * of certain opcodes, possibly making contracts go over the 2300 gas limit
742      * imposed by `transfer`, making them unable to receive funds via
743      * `transfer`. {sendValue} removes this limitation.
744      *
745      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
746      *
747      * IMPORTANT: because control is transferred to `recipient`, care must be
748      * taken to not create reentrancy vulnerabilities. Consider using
749      * {ReentrancyGuard} or the
750      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
751      */
752     function sendValue(address payable recipient, uint256 amount) internal {
753         require(address(this).balance >= amount, "Address: insufficient balance");
754 
755         (bool success, ) = recipient.call{value: amount}("");
756         require(success, "Address: unable to send value, recipient may have reverted");
757     }
758 
759     /**
760      * @dev Performs a Solidity function call using a low level `call`. A
761      * plain `call` is an unsafe replacement for a function call: use this
762      * function instead.
763      *
764      * If `target` reverts with a revert reason, it is bubbled up by this
765      * function (like regular Solidity function calls).
766      *
767      * Returns the raw returned data. To convert to the expected return value,
768      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
769      *
770      * Requirements:
771      *
772      * - `target` must be a contract.
773      * - calling `target` with `data` must not revert.
774      *
775      * _Available since v3.1._
776      */
777     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
778         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
783      * `errorMessage` as a fallback revert reason when `target` reverts.
784      *
785      * _Available since v3.1._
786      */
787     function functionCall(
788         address target,
789         bytes memory data,
790         string memory errorMessage
791     ) internal returns (bytes memory) {
792         return functionCallWithValue(target, data, 0, errorMessage);
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
797      * but also transferring `value` wei to `target`.
798      *
799      * Requirements:
800      *
801      * - the calling contract must have an ETH balance of at least `value`.
802      * - the called Solidity function must be `payable`.
803      *
804      * _Available since v3.1._
805      */
806     function functionCallWithValue(
807         address target,
808         bytes memory data,
809         uint256 value
810     ) internal returns (bytes memory) {
811         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
816      * with `errorMessage` as a fallback revert reason when `target` reverts.
817      *
818      * _Available since v3.1._
819      */
820     function functionCallWithValue(
821         address target,
822         bytes memory data,
823         uint256 value,
824         string memory errorMessage
825     ) internal returns (bytes memory) {
826         require(address(this).balance >= value, "Address: insufficient balance for call");
827         (bool success, bytes memory returndata) = target.call{value: value}(data);
828         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
829     }
830 
831     /**
832      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
833      * but performing a static call.
834      *
835      * _Available since v3.3._
836      */
837     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
838         return functionStaticCall(target, data, "Address: low-level static call failed");
839     }
840 
841     /**
842      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
843      * but performing a static call.
844      *
845      * _Available since v3.3._
846      */
847     function functionStaticCall(
848         address target,
849         bytes memory data,
850         string memory errorMessage
851     ) internal view returns (bytes memory) {
852         (bool success, bytes memory returndata) = target.staticcall(data);
853         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
854     }
855 
856     /**
857      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
858      * but performing a delegate call.
859      *
860      * _Available since v3.4._
861      */
862     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
863         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
864     }
865 
866     /**
867      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
868      * but performing a delegate call.
869      *
870      * _Available since v3.4._
871      */
872     function functionDelegateCall(
873         address target,
874         bytes memory data,
875         string memory errorMessage
876     ) internal returns (bytes memory) {
877         (bool success, bytes memory returndata) = target.delegatecall(data);
878         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
879     }
880 
881     /**
882      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
883      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
884      *
885      * _Available since v4.8._
886      */
887     function verifyCallResultFromTarget(
888         address target,
889         bool success,
890         bytes memory returndata,
891         string memory errorMessage
892     ) internal view returns (bytes memory) {
893         if (success) {
894             if (returndata.length == 0) {
895                 // only check isContract if the call was successful and the return data is empty
896                 // otherwise we already know that it was a contract
897                 require(isContract(target), "Address: call to non-contract");
898             }
899             return returndata;
900         } else {
901             _revert(returndata, errorMessage);
902         }
903     }
904 
905     /**
906      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
907      * revert reason or using the provided one.
908      *
909      * _Available since v4.3._
910      */
911     function verifyCallResult(
912         bool success,
913         bytes memory returndata,
914         string memory errorMessage
915     ) internal pure returns (bytes memory) {
916         if (success) {
917             return returndata;
918         } else {
919             _revert(returndata, errorMessage);
920         }
921     }
922 
923     function _revert(bytes memory returndata, string memory errorMessage) private pure {
924         // Look for revert reason and bubble it up if present
925         if (returndata.length > 0) {
926             // The easiest way to bubble the revert reason is using memory via assembly
927             /// @solidity memory-safe-assembly
928             assembly {
929                 let returndata_size := mload(returndata)
930                 revert(add(32, returndata), returndata_size)
931             }
932         } else {
933             revert(errorMessage);
934         }
935     }
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
939 
940 
941 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 /**
946  * @title ERC721 token receiver interface
947  * @dev Interface for any contract that wants to support safeTransfers
948  * from ERC721 asset contracts.
949  */
950 interface IERC721Receiver {
951     /**
952      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
953      * by `operator` from `from`, this function is called.
954      *
955      * It must return its Solidity selector to confirm the token transfer.
956      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
957      *
958      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
959      */
960     function onERC721Received(
961         address operator,
962         address from,
963         uint256 tokenId,
964         bytes calldata data
965     ) external returns (bytes4);
966 }
967 
968 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
969 
970 
971 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
972 
973 pragma solidity ^0.8.0;
974 
975 /**
976  * @dev Interface of the ERC165 standard, as defined in the
977  * https://eips.ethereum.org/EIPS/eip-165[EIP].
978  *
979  * Implementers can declare support of contract interfaces, which can then be
980  * queried by others ({ERC165Checker}).
981  *
982  * For an implementation, see {ERC165}.
983  */
984 interface IERC165 {
985     /**
986      * @dev Returns true if this contract implements the interface defined by
987      * `interfaceId`. See the corresponding
988      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
989      * to learn more about how these ids are created.
990      *
991      * This function call must use less than 30 000 gas.
992      */
993     function supportsInterface(bytes4 interfaceId) external view returns (bool);
994 }
995 
996 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
997 
998 
999 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 
1004 /**
1005  * @dev Implementation of the {IERC165} interface.
1006  *
1007  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1008  * for the additional interface id that will be supported. For example:
1009  *
1010  * ```solidity
1011  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1012  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1013  * }
1014  * ```
1015  *
1016  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1017  */
1018 abstract contract ERC165 is IERC165 {
1019     /**
1020      * @dev See {IERC165-supportsInterface}.
1021      */
1022     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1023         return interfaceId == type(IERC165).interfaceId;
1024     }
1025 }
1026 
1027 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1028 
1029 
1030 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 
1035 /**
1036  * @dev Required interface of an ERC721 compliant contract.
1037  */
1038 interface IERC721 is IERC165 {
1039     /**
1040      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1041      */
1042     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1043 
1044     /**
1045      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1046      */
1047     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1048 
1049     /**
1050      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1051      */
1052     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1053 
1054     /**
1055      * @dev Returns the number of tokens in ``owner``'s account.
1056      */
1057     function balanceOf(address owner) external view returns (uint256 balance);
1058 
1059     /**
1060      * @dev Returns the owner of the `tokenId` token.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function ownerOf(uint256 tokenId) external view returns (address owner);
1067 
1068     /**
1069      * @dev Safely transfers `tokenId` token from `from` to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must exist and be owned by `from`.
1076      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1077      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function safeTransferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes calldata data
1086     ) external;
1087 
1088     /**
1089      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1090      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1091      *
1092      * Requirements:
1093      *
1094      * - `from` cannot be the zero address.
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must exist and be owned by `from`.
1097      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1098      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) external;
1107 
1108     /**
1109      * @dev Transfers `tokenId` token from `from` to `to`.
1110      *
1111      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1112      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1113      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1114      *
1115      * Requirements:
1116      *
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must be owned by `from`.
1120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function transferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) external;
1129 
1130     /**
1131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1132      * The approval is cleared when the token is transferred.
1133      *
1134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1135      *
1136      * Requirements:
1137      *
1138      * - The caller must own the token or be an approved operator.
1139      * - `tokenId` must exist.
1140      *
1141      * Emits an {Approval} event.
1142      */
1143     function approve(address to, uint256 tokenId) external;
1144 
1145     /**
1146      * @dev Approve or remove `operator` as an operator for the caller.
1147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1148      *
1149      * Requirements:
1150      *
1151      * - The `operator` cannot be the caller.
1152      *
1153      * Emits an {ApprovalForAll} event.
1154      */
1155     function setApprovalForAll(address operator, bool _approved) external;
1156 
1157     /**
1158      * @dev Returns the account approved for `tokenId` token.
1159      *
1160      * Requirements:
1161      *
1162      * - `tokenId` must exist.
1163      */
1164     function getApproved(uint256 tokenId) external view returns (address operator);
1165 
1166     /**
1167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1168      *
1169      * See {setApprovalForAll}
1170      */
1171     function isApprovedForAll(address owner, address operator) external view returns (bool);
1172 }
1173 
1174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1175 
1176 
1177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 
1182 /**
1183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1184  * @dev See https://eips.ethereum.org/EIPS/eip-721
1185  */
1186 interface IERC721Metadata is IERC721 {
1187     /**
1188      * @dev Returns the token collection name.
1189      */
1190     function name() external view returns (string memory);
1191 
1192     /**
1193      * @dev Returns the token collection symbol.
1194      */
1195     function symbol() external view returns (string memory);
1196 
1197     /**
1198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1199      */
1200     function tokenURI(uint256 tokenId) external view returns (string memory);
1201 }
1202 
1203 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1204 
1205 
1206 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 
1211 
1212 
1213 
1214 
1215 
1216 
1217 /**
1218  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1219  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1220  * {ERC721Enumerable}.
1221  */
1222 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1223     using Address for address;
1224     using Strings for uint256;
1225 
1226     // Token name
1227     string private _name;
1228 
1229     // Token symbol
1230     string private _symbol;
1231 
1232     // Mapping from token ID to owner address
1233     mapping(uint256 => address) private _owners;
1234 
1235     // Mapping owner address to token count
1236     mapping(address => uint256) private _balances;
1237 
1238     // Mapping from token ID to approved address
1239     mapping(uint256 => address) private _tokenApprovals;
1240 
1241     // Mapping from owner to operator approvals
1242     mapping(address => mapping(address => bool)) private _operatorApprovals;
1243 
1244     /**
1245      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1246      */
1247     constructor(string memory name_, string memory symbol_) {
1248         _name = name_;
1249         _symbol = symbol_;
1250     }
1251 
1252     /**
1253      * @dev See {IERC165-supportsInterface}.
1254      */
1255     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1256         return
1257             interfaceId == type(IERC721).interfaceId ||
1258             interfaceId == type(IERC721Metadata).interfaceId ||
1259             super.supportsInterface(interfaceId);
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-balanceOf}.
1264      */
1265     function balanceOf(address owner) public view virtual override returns (uint256) {
1266         require(owner != address(0), "ERC721: address zero is not a valid owner");
1267         return _balances[owner];
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-ownerOf}.
1272      */
1273     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1274         address owner = _ownerOf(tokenId);
1275         require(owner != address(0), "ERC721: invalid token ID");
1276         return owner;
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Metadata-name}.
1281      */
1282     function name() public view virtual override returns (string memory) {
1283         return _name;
1284     }
1285 
1286     /**
1287      * @dev See {IERC721Metadata-symbol}.
1288      */
1289     function symbol() public view virtual override returns (string memory) {
1290         return _symbol;
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Metadata-tokenURI}.
1295      */
1296     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1297         _requireMinted(tokenId);
1298 
1299         string memory baseURI = _baseURI();
1300         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1301     }
1302 
1303     /**
1304      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1305      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1306      * by default, can be overridden in child contracts.
1307      */
1308     function _baseURI() internal view virtual returns (string memory) {
1309         return "";
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-approve}.
1314      */
1315     function approve(address to, uint256 tokenId) public virtual override {
1316         address owner = ERC721.ownerOf(tokenId);
1317         require(to != owner, "ERC721: approval to current owner");
1318 
1319         require(
1320             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1321             "ERC721: approve caller is not token owner or approved for all"
1322         );
1323 
1324         _approve(to, tokenId);
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-getApproved}.
1329      */
1330     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1331         _requireMinted(tokenId);
1332 
1333         return _tokenApprovals[tokenId];
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-setApprovalForAll}.
1338      */
1339     function setApprovalForAll(address operator, bool approved) public virtual override {
1340         _setApprovalForAll(_msgSender(), operator, approved);
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-isApprovedForAll}.
1345      */
1346     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1347         return _operatorApprovals[owner][operator];
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-transferFrom}.
1352      */
1353     function transferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId
1357     ) public virtual override {
1358         //solhint-disable-next-line max-line-length
1359         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1360 
1361         _transfer(from, to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-safeTransferFrom}.
1366      */
1367     function safeTransferFrom(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) public virtual override {
1372         safeTransferFrom(from, to, tokenId, "");
1373     }
1374 
1375     /**
1376      * @dev See {IERC721-safeTransferFrom}.
1377      */
1378     function safeTransferFrom(
1379         address from,
1380         address to,
1381         uint256 tokenId,
1382         bytes memory data
1383     ) public virtual override {
1384         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1385         _safeTransfer(from, to, tokenId, data);
1386     }
1387 
1388     /**
1389      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1390      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1391      *
1392      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1393      *
1394      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1395      * implement alternative mechanisms to perform token transfer, such as signature-based.
1396      *
1397      * Requirements:
1398      *
1399      * - `from` cannot be the zero address.
1400      * - `to` cannot be the zero address.
1401      * - `tokenId` token must exist and be owned by `from`.
1402      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function _safeTransfer(
1407         address from,
1408         address to,
1409         uint256 tokenId,
1410         bytes memory data
1411     ) internal virtual {
1412         _transfer(from, to, tokenId);
1413         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1414     }
1415 
1416     /**
1417      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1418      */
1419     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1420         return _owners[tokenId];
1421     }
1422 
1423     /**
1424      * @dev Returns whether `tokenId` exists.
1425      *
1426      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1427      *
1428      * Tokens start existing when they are minted (`_mint`),
1429      * and stop existing when they are burned (`_burn`).
1430      */
1431     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1432         return _ownerOf(tokenId) != address(0);
1433     }
1434 
1435     /**
1436      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must exist.
1441      */
1442     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1443         address owner = ERC721.ownerOf(tokenId);
1444         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1445     }
1446 
1447     /**
1448      * @dev Safely mints `tokenId` and transfers it to `to`.
1449      *
1450      * Requirements:
1451      *
1452      * - `tokenId` must not exist.
1453      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1454      *
1455      * Emits a {Transfer} event.
1456      */
1457     function _safeMint(address to, uint256 tokenId) internal virtual {
1458         _safeMint(to, tokenId, "");
1459     }
1460 
1461     /**
1462      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1463      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1464      */
1465     function _safeMint(
1466         address to,
1467         uint256 tokenId,
1468         bytes memory data
1469     ) internal virtual {
1470         _mint(to, tokenId);
1471         require(
1472             _checkOnERC721Received(address(0), to, tokenId, data),
1473             "ERC721: transfer to non ERC721Receiver implementer"
1474         );
1475     }
1476 
1477     /**
1478      * @dev Mints `tokenId` and transfers it to `to`.
1479      *
1480      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1481      *
1482      * Requirements:
1483      *
1484      * - `tokenId` must not exist.
1485      * - `to` cannot be the zero address.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _mint(address to, uint256 tokenId) internal virtual {
1490         require(to != address(0), "ERC721: mint to the zero address");
1491         require(!_exists(tokenId), "ERC721: token already minted");
1492 
1493         _beforeTokenTransfer(address(0), to, tokenId, 1);
1494 
1495         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1496         require(!_exists(tokenId), "ERC721: token already minted");
1497 
1498         unchecked {
1499             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1500             // Given that tokens are minted one by one, it is impossible in practice that
1501             // this ever happens. Might change if we allow batch minting.
1502             // The ERC fails to describe this case.
1503             _balances[to] += 1;
1504         }
1505 
1506         _owners[tokenId] = to;
1507 
1508         emit Transfer(address(0), to, tokenId);
1509 
1510         _afterTokenTransfer(address(0), to, tokenId, 1);
1511     }
1512 
1513     /**
1514      * @dev Destroys `tokenId`.
1515      * The approval is cleared when the token is burned.
1516      * This is an internal function that does not check if the sender is authorized to operate on the token.
1517      *
1518      * Requirements:
1519      *
1520      * - `tokenId` must exist.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function _burn(uint256 tokenId) internal virtual {
1525         address owner = ERC721.ownerOf(tokenId);
1526 
1527         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1528 
1529         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1530         owner = ERC721.ownerOf(tokenId);
1531 
1532         // Clear approvals
1533         delete _tokenApprovals[tokenId];
1534 
1535         unchecked {
1536             // Cannot overflow, as that would require more tokens to be burned/transferred
1537             // out than the owner initially received through minting and transferring in.
1538             _balances[owner] -= 1;
1539         }
1540         delete _owners[tokenId];
1541 
1542         emit Transfer(owner, address(0), tokenId);
1543 
1544         _afterTokenTransfer(owner, address(0), tokenId, 1);
1545     }
1546 
1547     /**
1548      * @dev Transfers `tokenId` from `from` to `to`.
1549      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1550      *
1551      * Requirements:
1552      *
1553      * - `to` cannot be the zero address.
1554      * - `tokenId` token must be owned by `from`.
1555      *
1556      * Emits a {Transfer} event.
1557      */
1558     function _transfer(
1559         address from,
1560         address to,
1561         uint256 tokenId
1562     ) internal virtual {
1563         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1564         require(to != address(0), "ERC721: transfer to the zero address");
1565 
1566         _beforeTokenTransfer(from, to, tokenId, 1);
1567 
1568         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1569         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1570 
1571         // Clear approvals from the previous owner
1572         delete _tokenApprovals[tokenId];
1573 
1574         unchecked {
1575             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1576             // `from`'s balance is the number of token held, which is at least one before the current
1577             // transfer.
1578             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1579             // all 2**256 token ids to be minted, which in practice is impossible.
1580             _balances[from] -= 1;
1581             _balances[to] += 1;
1582         }
1583         _owners[tokenId] = to;
1584 
1585         emit Transfer(from, to, tokenId);
1586 
1587         _afterTokenTransfer(from, to, tokenId, 1);
1588     }
1589 
1590     /**
1591      * @dev Approve `to` to operate on `tokenId`
1592      *
1593      * Emits an {Approval} event.
1594      */
1595     function _approve(address to, uint256 tokenId) internal virtual {
1596         _tokenApprovals[tokenId] = to;
1597         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1598     }
1599 
1600     /**
1601      * @dev Approve `operator` to operate on all of `owner` tokens
1602      *
1603      * Emits an {ApprovalForAll} event.
1604      */
1605     function _setApprovalForAll(
1606         address owner,
1607         address operator,
1608         bool approved
1609     ) internal virtual {
1610         require(owner != operator, "ERC721: approve to caller");
1611         _operatorApprovals[owner][operator] = approved;
1612         emit ApprovalForAll(owner, operator, approved);
1613     }
1614 
1615     /**
1616      * @dev Reverts if the `tokenId` has not been minted yet.
1617      */
1618     function _requireMinted(uint256 tokenId) internal view virtual {
1619         require(_exists(tokenId), "ERC721: invalid token ID");
1620     }
1621 
1622     /**
1623      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1624      * The call is not executed if the target address is not a contract.
1625      *
1626      * @param from address representing the previous owner of the given token ID
1627      * @param to target address that will receive the tokens
1628      * @param tokenId uint256 ID of the token to be transferred
1629      * @param data bytes optional data to send along with the call
1630      * @return bool whether the call correctly returned the expected magic value
1631      */
1632     function _checkOnERC721Received(
1633         address from,
1634         address to,
1635         uint256 tokenId,
1636         bytes memory data
1637     ) private returns (bool) {
1638         if (to.isContract()) {
1639             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1640                 return retval == IERC721Receiver.onERC721Received.selector;
1641             } catch (bytes memory reason) {
1642                 if (reason.length == 0) {
1643                     revert("ERC721: transfer to non ERC721Receiver implementer");
1644                 } else {
1645                     /// @solidity memory-safe-assembly
1646                     assembly {
1647                         revert(add(32, reason), mload(reason))
1648                     }
1649                 }
1650             }
1651         } else {
1652             return true;
1653         }
1654     }
1655 
1656     /**
1657      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1658      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1659      *
1660      * Calling conditions:
1661      *
1662      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1663      * - When `from` is zero, the tokens will be minted for `to`.
1664      * - When `to` is zero, ``from``'s tokens will be burned.
1665      * - `from` and `to` are never both zero.
1666      * - `batchSize` is non-zero.
1667      *
1668      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1669      */
1670     function _beforeTokenTransfer(
1671         address from,
1672         address to,
1673         uint256, /* firstTokenId */
1674         uint256 batchSize
1675     ) internal virtual {
1676         if (batchSize > 1) {
1677             if (from != address(0)) {
1678                 _balances[from] -= batchSize;
1679             }
1680             if (to != address(0)) {
1681                 _balances[to] += batchSize;
1682             }
1683         }
1684     }
1685 
1686     /**
1687      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1688      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1689      *
1690      * Calling conditions:
1691      *
1692      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1693      * - When `from` is zero, the tokens were minted for `to`.
1694      * - When `to` is zero, ``from``'s tokens were burned.
1695      * - `from` and `to` are never both zero.
1696      * - `batchSize` is non-zero.
1697      *
1698      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1699      */
1700     function _afterTokenTransfer(
1701         address from,
1702         address to,
1703         uint256 firstTokenId,
1704         uint256 batchSize
1705     ) internal virtual {}
1706 }
1707 
1708 // File: contracts/c.sol
1709 
1710 
1711 
1712 
1713 
1714 pragma solidity >=0.7.0 <0.9.0;
1715 
1716 
1717 contract GhettoSquad is ERC721, Ownable, DefaultOperatorFilterer {
1718   using Strings for uint256;
1719   using Counters for Counters.Counter;
1720 
1721   Counters.Counter private supply;
1722 
1723   string public uriPrefix = "";
1724   string public uriSuffix = ".json";
1725   string public hiddenMetadataUri;
1726 
1727   uint256 public cost = 0.005 ether;
1728   uint256 public maxSupply = 4444;
1729   uint256 public maxMintAmountPerTx = 5;
1730   uint256 public nftPerAddressLimit = 5;
1731 
1732   bool public paused = false;
1733   bool public revealed = false;
1734 
1735   mapping(address => uint256) public addressMintedBalance;
1736 
1737   constructor() ERC721("Ghetto Squad", "GSD") {
1738     setHiddenMetadataUri("ipfs://bafybeia44lesnp7gzml7ceaazmfjhwnlr6dlax6wxzzafl6kitudrjdniy/hidden.json");
1739   }
1740 
1741   modifier mintCompliance(uint256 _mintAmount) {
1742     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1743     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1744 
1745     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1746     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1747     _;
1748   }
1749 
1750   function totalSupply() public view returns (uint256) {
1751     return supply.current();
1752   }
1753 
1754   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1755     require(!paused, "The contract is paused!");
1756     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1757 
1758     _mintLoop(msg.sender, _mintAmount);
1759   }
1760 
1761   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1762     _mintLoop(_receiver, _mintAmount);
1763   }
1764 
1765   function walletOfOwner(address _owner)
1766     public
1767     view
1768     returns (uint256[] memory)
1769   {
1770     uint256 ownerTokenCount = balanceOf(_owner);
1771     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1772     uint256 currentTokenId = 1;
1773     uint256 ownedTokenIndex = 0;
1774 
1775     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1776       address currentTokenOwner = ownerOf(currentTokenId);
1777 
1778       if (currentTokenOwner == _owner) {
1779         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1780 
1781         ownedTokenIndex++;
1782       }
1783 
1784       currentTokenId++;
1785     }
1786 
1787     return ownedTokenIds;
1788   }
1789 
1790   function tokenURI(uint256 _tokenId)
1791     public
1792     view
1793     virtual
1794     override
1795     returns (string memory)
1796   {
1797     require(
1798       _exists(_tokenId),
1799       "ERC721Metadata: URI query for nonexistent token"
1800     );
1801 
1802     if (revealed == false) {
1803       return hiddenMetadataUri;
1804     }
1805 
1806     string memory currentBaseURI = _baseURI();
1807     return bytes(currentBaseURI).length > 0
1808         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1809         : "";
1810   }
1811 
1812   function setRevealed(bool _state) public onlyOwner {
1813     revealed = _state;
1814   }
1815 
1816   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1817     nftPerAddressLimit = _limit;
1818   }
1819 
1820   function setCost(uint256 _cost) public onlyOwner {
1821     cost = _cost;
1822   }
1823 
1824   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1825     maxMintAmountPerTx = _maxMintAmountPerTx;
1826   }
1827 
1828   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1829     hiddenMetadataUri = _hiddenMetadataUri;
1830   }
1831 
1832   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1833     uriPrefix = _uriPrefix;
1834   }
1835 
1836   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1837     uriSuffix = _uriSuffix;
1838   }
1839 
1840   function setPaused(bool _state) public onlyOwner {
1841     paused = _state;
1842   }
1843 
1844   function withdraw() public onlyOwner {
1845     // This will transfer the remaining contract balance to the owner.
1846     // Do not remove this otherwise you will not be able to withdraw the funds.
1847     // =============================================================================
1848     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1849     require(os);
1850     // =============================================================================
1851   }
1852 
1853   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1854     for (uint256 i = 0; i < _mintAmount; i++) {
1855       addressMintedBalance[_receiver]++;
1856       supply.increment();
1857       _safeMint(_receiver, supply.current());
1858     }
1859   }
1860 
1861   function _baseURI() internal view virtual override returns (string memory) {
1862     return uriPrefix;
1863   }
1864 
1865   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1866     super.setApprovalForAll(operator, approved);
1867   }
1868 
1869   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1870     super.approve(operator, tokenId);
1871   }
1872 
1873   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1874     super.transferFrom(from, to, tokenId);
1875   }
1876 
1877   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1878     super.safeTransferFrom(from, to, tokenId);
1879   }
1880 
1881   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1882     public
1883     override
1884     onlyAllowedOperator(from)
1885   {
1886     super.safeTransferFrom(from, to, tokenId, data);
1887   }
1888 }