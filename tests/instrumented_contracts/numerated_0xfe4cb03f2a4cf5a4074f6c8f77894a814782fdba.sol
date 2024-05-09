1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: IOperatorFilterRegistry.sol
7 
8 
9 pragma solidity ^0.8.13;
10 
11 interface IOperatorFilterRegistry {
12     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
13     function register(address registrant) external;
14     function registerAndSubscribe(address registrant, address subscription) external;
15     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
16     function unregister(address addr) external;
17     function updateOperator(address registrant, address operator, bool filtered) external;
18     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
19     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
20     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
21     function subscribe(address registrant, address registrantToSubscribe) external;
22     function unsubscribe(address registrant, bool copyExistingEntries) external;
23     function subscriptionOf(address addr) external returns (address registrant);
24     function subscribers(address registrant) external returns (address[] memory);
25     function subscriberAt(address registrant, uint256 index) external returns (address);
26     function copyEntriesOf(address registrant, address registrantToCopy) external;
27     function isOperatorFiltered(address registrant, address operator) external returns (bool);
28     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
29     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
30     function filteredOperators(address addr) external returns (address[] memory);
31     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
32     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
33     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
34     function isRegistered(address addr) external returns (bool);
35     function codeHashOf(address addr) external returns (bytes32);
36 }
37 
38 // File: OperatorFilterer.sol
39 
40 
41 pragma solidity ^0.8.13;
42 
43 
44 /**
45  * @title  OperatorFilterer
46  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
47  *         registrant's entries in the OperatorFilterRegistry.
48  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
49  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
50  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
51  */
52 abstract contract OperatorFilterer {
53     error OperatorNotAllowed(address operator);
54 
55     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
56         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
57 
58     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
59         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
60         // will not revert, but the contract will need to be registered with the registry once it is deployed in
61         // order for the modifier to filter addresses.
62         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
63             if (subscribe) {
64                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
65             } else {
66                 if (subscriptionOrRegistrantToCopy != address(0)) {
67                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
68                 } else {
69                     OPERATOR_FILTER_REGISTRY.register(address(this));
70                 }
71             }
72         }
73     }
74 
75     modifier onlyAllowedOperator(address from) virtual {
76         // Allow spending tokens from addresses with balance
77         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
78         // from an EOA.
79         if (from != msg.sender) {
80             _checkFilterOperator(msg.sender);
81         }
82         _;
83     }
84 
85     modifier onlyAllowedOperatorApproval(address operator) virtual {
86         _checkFilterOperator(operator);
87         _;
88     }
89 
90     function _checkFilterOperator(address operator) internal view virtual {
91         // Check registry code length to facilitate testing in environments without a deployed registry.
92         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
93             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
94                 revert OperatorNotAllowed(operator);
95             }
96         }
97     }
98 }
99 
100 // File: DefaultOperatorFilterer.sol
101 
102 
103 pragma solidity ^0.8.13;
104 
105 
106 /**
107  * @title  DefaultOperatorFilterer
108  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
109  */
110 abstract contract DefaultOperatorFilterer is OperatorFilterer {
111     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
112 
113     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
114 }
115 
116 // File: @openzeppelin/contracts@4.8.0/utils/Counters.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @title Counters
125  * @author Matt Condon (@shrugs)
126  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
127  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
128  *
129  * Include with `using Counters for Counters.Counter;`
130  */
131 library Counters {
132     struct Counter {
133         // This variable should never be directly accessed by users of the library: interactions must be restricted to
134         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
135         // this feature: see https://github.com/ethereum/solidity/issues/4637
136         uint256 _value; // default: 0
137     }
138 
139     function current(Counter storage counter) internal view returns (uint256) {
140         return counter._value;
141     }
142 
143     function increment(Counter storage counter) internal {
144         unchecked {
145             counter._value += 1;
146         }
147     }
148 
149     function decrement(Counter storage counter) internal {
150         uint256 value = counter._value;
151         require(value > 0, "Counter: decrement overflow");
152         unchecked {
153             counter._value = value - 1;
154         }
155     }
156 
157     function reset(Counter storage counter) internal {
158         counter._value = 0;
159     }
160 }
161 
162 // File: @openzeppelin/contracts@4.8.0/utils/math/Math.sol
163 
164 
165 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Standard math utilities missing in the Solidity language.
171  */
172 library Math {
173     enum Rounding {
174         Down, // Toward negative infinity
175         Up, // Toward infinity
176         Zero // Toward zero
177     }
178 
179     /**
180      * @dev Returns the largest of two numbers.
181      */
182     function max(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a > b ? a : b;
184     }
185 
186     /**
187      * @dev Returns the smallest of two numbers.
188      */
189     function min(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a < b ? a : b;
191     }
192 
193     /**
194      * @dev Returns the average of two numbers. The result is rounded towards
195      * zero.
196      */
197     function average(uint256 a, uint256 b) internal pure returns (uint256) {
198         // (a + b) / 2 can overflow.
199         return (a & b) + (a ^ b) / 2;
200     }
201 
202     /**
203      * @dev Returns the ceiling of the division of two numbers.
204      *
205      * This differs from standard division with `/` in that it rounds up instead
206      * of rounding down.
207      */
208     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
209         // (a + b - 1) / b can overflow on addition, so we distribute.
210         return a == 0 ? 0 : (a - 1) / b + 1;
211     }
212 
213     /**
214      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
215      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
216      * with further edits by Uniswap Labs also under MIT license.
217      */
218     function mulDiv(
219         uint256 x,
220         uint256 y,
221         uint256 denominator
222     ) internal pure returns (uint256 result) {
223         unchecked {
224             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
225             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
226             // variables such that product = prod1 * 2^256 + prod0.
227             uint256 prod0; // Least significant 256 bits of the product
228             uint256 prod1; // Most significant 256 bits of the product
229             assembly {
230                 let mm := mulmod(x, y, not(0))
231                 prod0 := mul(x, y)
232                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
233             }
234 
235             // Handle non-overflow cases, 256 by 256 division.
236             if (prod1 == 0) {
237                 return prod0 / denominator;
238             }
239 
240             // Make sure the result is less than 2^256. Also prevents denominator == 0.
241             require(denominator > prod1);
242 
243             ///////////////////////////////////////////////
244             // 512 by 256 division.
245             ///////////////////////////////////////////////
246 
247             // Make division exact by subtracting the remainder from [prod1 prod0].
248             uint256 remainder;
249             assembly {
250                 // Compute remainder using mulmod.
251                 remainder := mulmod(x, y, denominator)
252 
253                 // Subtract 256 bit number from 512 bit number.
254                 prod1 := sub(prod1, gt(remainder, prod0))
255                 prod0 := sub(prod0, remainder)
256             }
257 
258             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
259             // See https://cs.stackexchange.com/q/138556/92363.
260 
261             // Does not overflow because the denominator cannot be zero at this stage in the function.
262             uint256 twos = denominator & (~denominator + 1);
263             assembly {
264                 // Divide denominator by twos.
265                 denominator := div(denominator, twos)
266 
267                 // Divide [prod1 prod0] by twos.
268                 prod0 := div(prod0, twos)
269 
270                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
271                 twos := add(div(sub(0, twos), twos), 1)
272             }
273 
274             // Shift in bits from prod1 into prod0.
275             prod0 |= prod1 * twos;
276 
277             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
278             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
279             // four bits. That is, denominator * inv = 1 mod 2^4.
280             uint256 inverse = (3 * denominator) ^ 2;
281 
282             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
283             // in modular arithmetic, doubling the correct bits in each step.
284             inverse *= 2 - denominator * inverse; // inverse mod 2^8
285             inverse *= 2 - denominator * inverse; // inverse mod 2^16
286             inverse *= 2 - denominator * inverse; // inverse mod 2^32
287             inverse *= 2 - denominator * inverse; // inverse mod 2^64
288             inverse *= 2 - denominator * inverse; // inverse mod 2^128
289             inverse *= 2 - denominator * inverse; // inverse mod 2^256
290 
291             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
292             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
293             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
294             // is no longer required.
295             result = prod0 * inverse;
296             return result;
297         }
298     }
299 
300     /**
301      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
302      */
303     function mulDiv(
304         uint256 x,
305         uint256 y,
306         uint256 denominator,
307         Rounding rounding
308     ) internal pure returns (uint256) {
309         uint256 result = mulDiv(x, y, denominator);
310         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
311             result += 1;
312         }
313         return result;
314     }
315 
316     /**
317      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
318      *
319      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
320      */
321     function sqrt(uint256 a) internal pure returns (uint256) {
322         if (a == 0) {
323             return 0;
324         }
325 
326         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
327         //
328         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
329         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
330         //
331         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
332         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
333         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
334         //
335         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
336         uint256 result = 1 << (log2(a) >> 1);
337 
338         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
339         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
340         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
341         // into the expected uint128 result.
342         unchecked {
343             result = (result + a / result) >> 1;
344             result = (result + a / result) >> 1;
345             result = (result + a / result) >> 1;
346             result = (result + a / result) >> 1;
347             result = (result + a / result) >> 1;
348             result = (result + a / result) >> 1;
349             result = (result + a / result) >> 1;
350             return min(result, a / result);
351         }
352     }
353 
354     /**
355      * @notice Calculates sqrt(a), following the selected rounding direction.
356      */
357     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
358         unchecked {
359             uint256 result = sqrt(a);
360             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
361         }
362     }
363 
364     /**
365      * @dev Return the log in base 2, rounded down, of a positive value.
366      * Returns 0 if given 0.
367      */
368     function log2(uint256 value) internal pure returns (uint256) {
369         uint256 result = 0;
370         unchecked {
371             if (value >> 128 > 0) {
372                 value >>= 128;
373                 result += 128;
374             }
375             if (value >> 64 > 0) {
376                 value >>= 64;
377                 result += 64;
378             }
379             if (value >> 32 > 0) {
380                 value >>= 32;
381                 result += 32;
382             }
383             if (value >> 16 > 0) {
384                 value >>= 16;
385                 result += 16;
386             }
387             if (value >> 8 > 0) {
388                 value >>= 8;
389                 result += 8;
390             }
391             if (value >> 4 > 0) {
392                 value >>= 4;
393                 result += 4;
394             }
395             if (value >> 2 > 0) {
396                 value >>= 2;
397                 result += 2;
398             }
399             if (value >> 1 > 0) {
400                 result += 1;
401             }
402         }
403         return result;
404     }
405 
406     /**
407      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
408      * Returns 0 if given 0.
409      */
410     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
411         unchecked {
412             uint256 result = log2(value);
413             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
414         }
415     }
416 
417     /**
418      * @dev Return the log in base 10, rounded down, of a positive value.
419      * Returns 0 if given 0.
420      */
421     function log10(uint256 value) internal pure returns (uint256) {
422         uint256 result = 0;
423         unchecked {
424             if (value >= 10**64) {
425                 value /= 10**64;
426                 result += 64;
427             }
428             if (value >= 10**32) {
429                 value /= 10**32;
430                 result += 32;
431             }
432             if (value >= 10**16) {
433                 value /= 10**16;
434                 result += 16;
435             }
436             if (value >= 10**8) {
437                 value /= 10**8;
438                 result += 8;
439             }
440             if (value >= 10**4) {
441                 value /= 10**4;
442                 result += 4;
443             }
444             if (value >= 10**2) {
445                 value /= 10**2;
446                 result += 2;
447             }
448             if (value >= 10**1) {
449                 result += 1;
450             }
451         }
452         return result;
453     }
454 
455     /**
456      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
457      * Returns 0 if given 0.
458      */
459     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
460         unchecked {
461             uint256 result = log10(value);
462             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
463         }
464     }
465 
466     /**
467      * @dev Return the log in base 256, rounded down, of a positive value.
468      * Returns 0 if given 0.
469      *
470      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
471      */
472     function log256(uint256 value) internal pure returns (uint256) {
473         uint256 result = 0;
474         unchecked {
475             if (value >> 128 > 0) {
476                 value >>= 128;
477                 result += 16;
478             }
479             if (value >> 64 > 0) {
480                 value >>= 64;
481                 result += 8;
482             }
483             if (value >> 32 > 0) {
484                 value >>= 32;
485                 result += 4;
486             }
487             if (value >> 16 > 0) {
488                 value >>= 16;
489                 result += 2;
490             }
491             if (value >> 8 > 0) {
492                 result += 1;
493             }
494         }
495         return result;
496     }
497 
498     /**
499      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
500      * Returns 0 if given 0.
501      */
502     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
503         unchecked {
504             uint256 result = log256(value);
505             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
506         }
507     }
508 }
509 
510 // File: @openzeppelin/contracts@4.8.0/utils/Strings.sol
511 
512 
513 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev String operations.
520  */
521 library Strings {
522     bytes16 private constant _SYMBOLS = "0123456789abcdef";
523     uint8 private constant _ADDRESS_LENGTH = 20;
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
527      */
528     function toString(uint256 value) internal pure returns (string memory) {
529         unchecked {
530             uint256 length = Math.log10(value) + 1;
531             string memory buffer = new string(length);
532             uint256 ptr;
533             /// @solidity memory-safe-assembly
534             assembly {
535                 ptr := add(buffer, add(32, length))
536             }
537             while (true) {
538                 ptr--;
539                 /// @solidity memory-safe-assembly
540                 assembly {
541                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
542                 }
543                 value /= 10;
544                 if (value == 0) break;
545             }
546             return buffer;
547         }
548     }
549 
550     /**
551      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
552      */
553     function toHexString(uint256 value) internal pure returns (string memory) {
554         unchecked {
555             return toHexString(value, Math.log256(value) + 1);
556         }
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
561      */
562     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
563         bytes memory buffer = new bytes(2 * length + 2);
564         buffer[0] = "0";
565         buffer[1] = "x";
566         for (uint256 i = 2 * length + 1; i > 1; --i) {
567             buffer[i] = _SYMBOLS[value & 0xf];
568             value >>= 4;
569         }
570         require(value == 0, "Strings: hex length insufficient");
571         return string(buffer);
572     }
573 
574     /**
575      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
576      */
577     function toHexString(address addr) internal pure returns (string memory) {
578         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
579     }
580 }
581 
582 // File: @openzeppelin/contracts@4.8.0/utils/Context.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Provides information about the current execution context, including the
591  * sender of the transaction and its data. While these are generally available
592  * via msg.sender and msg.data, they should not be accessed in such a direct
593  * manner, since when dealing with meta-transactions the account sending and
594  * paying for execution may not be the actual sender (as far as an application
595  * is concerned).
596  *
597  * This contract is only required for intermediate, library-like contracts.
598  */
599 abstract contract Context {
600     function _msgSender() internal view virtual returns (address) {
601         return msg.sender;
602     }
603 
604     function _msgData() internal view virtual returns (bytes calldata) {
605         return msg.data;
606     }
607 }
608 
609 // File: @openzeppelin/contracts@4.8.0/access/Ownable.sol
610 
611 
612 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Contract module which provides a basic access control mechanism, where
619  * there is an account (an owner) that can be granted exclusive access to
620  * specific functions.
621  *
622  * By default, the owner account will be the one that deploys the contract. This
623  * can later be changed with {transferOwnership}.
624  *
625  * This module is used through inheritance. It will make available the modifier
626  * `onlyOwner`, which can be applied to your functions to restrict their use to
627  * the owner.
628  */
629 abstract contract Ownable is Context {
630     address private _owner;
631 
632     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
633 
634     /**
635      * @dev Initializes the contract setting the deployer as the initial owner.
636      */
637     constructor() {
638         _transferOwnership(_msgSender());
639     }
640 
641     /**
642      * @dev Throws if called by any account other than the owner.
643      */
644     modifier onlyOwner() {
645         _checkOwner();
646         _;
647     }
648 
649     /**
650      * @dev Returns the address of the current owner.
651      */
652     function owner() public view virtual returns (address) {
653         return _owner;
654     }
655 
656     /**
657      * @dev Throws if the sender is not the owner.
658      */
659     function _checkOwner() internal view virtual {
660         require(owner() == _msgSender(), "Ownable: caller is not the owner");
661     }
662 
663     /**
664      * @dev Leaves the contract without owner. It will not be possible to call
665      * `onlyOwner` functions anymore. Can only be called by the current owner.
666      *
667      * NOTE: Renouncing ownership will leave the contract without an owner,
668      * thereby removing any functionality that is only available to the owner.
669      */
670     function renounceOwnership() public virtual onlyOwner {
671         _transferOwnership(address(0));
672     }
673 
674     /**
675      * @dev Transfers ownership of the contract to a new account (`newOwner`).
676      * Can only be called by the current owner.
677      */
678     function transferOwnership(address newOwner) public virtual onlyOwner {
679         require(newOwner != address(0), "Ownable: new owner is the zero address");
680         _transferOwnership(newOwner);
681     }
682 
683     /**
684      * @dev Transfers ownership of the contract to a new account (`newOwner`).
685      * Internal function without access restriction.
686      */
687     function _transferOwnership(address newOwner) internal virtual {
688         address oldOwner = _owner;
689         _owner = newOwner;
690         emit OwnershipTransferred(oldOwner, newOwner);
691     }
692 }
693 
694 // File: @openzeppelin/contracts@4.8.0/security/Pausable.sol
695 
696 
697 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @dev Contract module which allows children to implement an emergency stop
704  * mechanism that can be triggered by an authorized account.
705  *
706  * This module is used through inheritance. It will make available the
707  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
708  * the functions of your contract. Note that they will not be pausable by
709  * simply including this module, only once the modifiers are put in place.
710  */
711 abstract contract Pausable is Context {
712     /**
713      * @dev Emitted when the pause is triggered by `account`.
714      */
715     event Paused(address account);
716 
717     /**
718      * @dev Emitted when the pause is lifted by `account`.
719      */
720     event Unpaused(address account);
721 
722     bool private _paused;
723 
724     /**
725      * @dev Initializes the contract in unpaused state.
726      */
727     constructor() {
728         _paused = false;
729     }
730 
731     /**
732      * @dev Modifier to make a function callable only when the contract is not paused.
733      *
734      * Requirements:
735      *
736      * - The contract must not be paused.
737      */
738     modifier whenNotPaused() {
739         _requireNotPaused();
740         _;
741     }
742 
743     /**
744      * @dev Modifier to make a function callable only when the contract is paused.
745      *
746      * Requirements:
747      *
748      * - The contract must be paused.
749      */
750     modifier whenPaused() {
751         _requirePaused();
752         _;
753     }
754 
755     /**
756      * @dev Returns true if the contract is paused, and false otherwise.
757      */
758     function paused() public view virtual returns (bool) {
759         return _paused;
760     }
761 
762     /**
763      * @dev Throws if the contract is paused.
764      */
765     function _requireNotPaused() internal view virtual {
766         require(!paused(), "Pausable: paused");
767     }
768 
769     /**
770      * @dev Throws if the contract is not paused.
771      */
772     function _requirePaused() internal view virtual {
773         require(paused(), "Pausable: not paused");
774     }
775 
776     /**
777      * @dev Triggers stopped state.
778      *
779      * Requirements:
780      *
781      * - The contract must not be paused.
782      */
783     function _pause() internal virtual whenNotPaused {
784         _paused = true;
785         emit Paused(_msgSender());
786     }
787 
788     /**
789      * @dev Returns to normal state.
790      *
791      * Requirements:
792      *
793      * - The contract must be paused.
794      */
795     function _unpause() internal virtual whenPaused {
796         _paused = false;
797         emit Unpaused(_msgSender());
798     }
799 }
800 
801 // File: @openzeppelin/contracts@4.8.0/utils/Address.sol
802 
803 
804 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
805 
806 pragma solidity ^0.8.1;
807 
808 /**
809  * @dev Collection of functions related to the address type
810  */
811 library Address {
812     /**
813      * @dev Returns true if `account` is a contract.
814      *
815      * [IMPORTANT]
816      * ====
817      * It is unsafe to assume that an address for which this function returns
818      * false is an externally-owned account (EOA) and not a contract.
819      *
820      * Among others, `isContract` will return false for the following
821      * types of addresses:
822      *
823      *  - an externally-owned account
824      *  - a contract in construction
825      *  - an address where a contract will be created
826      *  - an address where a contract lived, but was destroyed
827      * ====
828      *
829      * [IMPORTANT]
830      * ====
831      * You shouldn't rely on `isContract` to protect against flash loan attacks!
832      *
833      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
834      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
835      * constructor.
836      * ====
837      */
838     function isContract(address account) internal view returns (bool) {
839         // This method relies on extcodesize/address.code.length, which returns 0
840         // for contracts in construction, since the code is only stored at the end
841         // of the constructor execution.
842 
843         return account.code.length > 0;
844     }
845 
846     /**
847      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
848      * `recipient`, forwarding all available gas and reverting on errors.
849      *
850      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
851      * of certain opcodes, possibly making contracts go over the 2300 gas limit
852      * imposed by `transfer`, making them unable to receive funds via
853      * `transfer`. {sendValue} removes this limitation.
854      *
855      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
856      *
857      * IMPORTANT: because control is transferred to `recipient`, care must be
858      * taken to not create reentrancy vulnerabilities. Consider using
859      * {ReentrancyGuard} or the
860      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
861      */
862     function sendValue(address payable recipient, uint256 amount) internal {
863         require(address(this).balance >= amount, "Address: insufficient balance");
864 
865         (bool success, ) = recipient.call{value: amount}("");
866         require(success, "Address: unable to send value, recipient may have reverted");
867     }
868 
869     /**
870      * @dev Performs a Solidity function call using a low level `call`. A
871      * plain `call` is an unsafe replacement for a function call: use this
872      * function instead.
873      *
874      * If `target` reverts with a revert reason, it is bubbled up by this
875      * function (like regular Solidity function calls).
876      *
877      * Returns the raw returned data. To convert to the expected return value,
878      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
879      *
880      * Requirements:
881      *
882      * - `target` must be a contract.
883      * - calling `target` with `data` must not revert.
884      *
885      * _Available since v3.1._
886      */
887     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
888         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
889     }
890 
891     /**
892      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
893      * `errorMessage` as a fallback revert reason when `target` reverts.
894      *
895      * _Available since v3.1._
896      */
897     function functionCall(
898         address target,
899         bytes memory data,
900         string memory errorMessage
901     ) internal returns (bytes memory) {
902         return functionCallWithValue(target, data, 0, errorMessage);
903     }
904 
905     /**
906      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
907      * but also transferring `value` wei to `target`.
908      *
909      * Requirements:
910      *
911      * - the calling contract must have an ETH balance of at least `value`.
912      * - the called Solidity function must be `payable`.
913      *
914      * _Available since v3.1._
915      */
916     function functionCallWithValue(
917         address target,
918         bytes memory data,
919         uint256 value
920     ) internal returns (bytes memory) {
921         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
922     }
923 
924     /**
925      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
926      * with `errorMessage` as a fallback revert reason when `target` reverts.
927      *
928      * _Available since v3.1._
929      */
930     function functionCallWithValue(
931         address target,
932         bytes memory data,
933         uint256 value,
934         string memory errorMessage
935     ) internal returns (bytes memory) {
936         require(address(this).balance >= value, "Address: insufficient balance for call");
937         (bool success, bytes memory returndata) = target.call{value: value}(data);
938         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
939     }
940 
941     /**
942      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
943      * but performing a static call.
944      *
945      * _Available since v3.3._
946      */
947     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
948         return functionStaticCall(target, data, "Address: low-level static call failed");
949     }
950 
951     /**
952      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
953      * but performing a static call.
954      *
955      * _Available since v3.3._
956      */
957     function functionStaticCall(
958         address target,
959         bytes memory data,
960         string memory errorMessage
961     ) internal view returns (bytes memory) {
962         (bool success, bytes memory returndata) = target.staticcall(data);
963         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
964     }
965 
966     /**
967      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
968      * but performing a delegate call.
969      *
970      * _Available since v3.4._
971      */
972     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
973         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
978      * but performing a delegate call.
979      *
980      * _Available since v3.4._
981      */
982     function functionDelegateCall(
983         address target,
984         bytes memory data,
985         string memory errorMessage
986     ) internal returns (bytes memory) {
987         (bool success, bytes memory returndata) = target.delegatecall(data);
988         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
989     }
990 
991     /**
992      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
993      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
994      *
995      * _Available since v4.8._
996      */
997     function verifyCallResultFromTarget(
998         address target,
999         bool success,
1000         bytes memory returndata,
1001         string memory errorMessage
1002     ) internal view returns (bytes memory) {
1003         if (success) {
1004             if (returndata.length == 0) {
1005                 // only check isContract if the call was successful and the return data is empty
1006                 // otherwise we already know that it was a contract
1007                 require(isContract(target), "Address: call to non-contract");
1008             }
1009             return returndata;
1010         } else {
1011             _revert(returndata, errorMessage);
1012         }
1013     }
1014 
1015     /**
1016      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1017      * revert reason or using the provided one.
1018      *
1019      * _Available since v4.3._
1020      */
1021     function verifyCallResult(
1022         bool success,
1023         bytes memory returndata,
1024         string memory errorMessage
1025     ) internal pure returns (bytes memory) {
1026         if (success) {
1027             return returndata;
1028         } else {
1029             _revert(returndata, errorMessage);
1030         }
1031     }
1032 
1033     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1034         // Look for revert reason and bubble it up if present
1035         if (returndata.length > 0) {
1036             // The easiest way to bubble the revert reason is using memory via assembly
1037             /// @solidity memory-safe-assembly
1038             assembly {
1039                 let returndata_size := mload(returndata)
1040                 revert(add(32, returndata), returndata_size)
1041             }
1042         } else {
1043             revert(errorMessage);
1044         }
1045     }
1046 }
1047 
1048 // File: @openzeppelin/contracts@4.8.0/token/ERC721/IERC721Receiver.sol
1049 
1050 
1051 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 /**
1056  * @title ERC721 token receiver interface
1057  * @dev Interface for any contract that wants to support safeTransfers
1058  * from ERC721 asset contracts.
1059  */
1060 interface IERC721Receiver {
1061     /**
1062      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1063      * by `operator` from `from`, this function is called.
1064      *
1065      * It must return its Solidity selector to confirm the token transfer.
1066      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1067      *
1068      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1069      */
1070     function onERC721Received(
1071         address operator,
1072         address from,
1073         uint256 tokenId,
1074         bytes calldata data
1075     ) external returns (bytes4);
1076 }
1077 
1078 // File: @openzeppelin/contracts@4.8.0/utils/introspection/IERC165.sol
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 /**
1086  * @dev Interface of the ERC165 standard, as defined in the
1087  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1088  *
1089  * Implementers can declare support of contract interfaces, which can then be
1090  * queried by others ({ERC165Checker}).
1091  *
1092  * For an implementation, see {ERC165}.
1093  */
1094 interface IERC165 {
1095     /**
1096      * @dev Returns true if this contract implements the interface defined by
1097      * `interfaceId`. See the corresponding
1098      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1099      * to learn more about how these ids are created.
1100      *
1101      * This function call must use less than 30 000 gas.
1102      */
1103     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1104 }
1105 
1106 // File: @openzeppelin/contracts@4.8.0/interfaces/IERC2981.sol
1107 
1108 
1109 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 
1114 /**
1115  * @dev Interface for the NFT Royalty Standard.
1116  *
1117  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1118  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1119  *
1120  * _Available since v4.5._
1121  */
1122 interface IERC2981 is IERC165 {
1123     /**
1124      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1125      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1126      */
1127     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1128         external
1129         view
1130         returns (address receiver, uint256 royaltyAmount);
1131 }
1132 
1133 // File: @openzeppelin/contracts@4.8.0/utils/introspection/ERC165.sol
1134 
1135 
1136 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 /**
1142  * @dev Implementation of the {IERC165} interface.
1143  *
1144  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1145  * for the additional interface id that will be supported. For example:
1146  *
1147  * ```solidity
1148  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1149  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1150  * }
1151  * ```
1152  *
1153  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1154  */
1155 abstract contract ERC165 is IERC165 {
1156     /**
1157      * @dev See {IERC165-supportsInterface}.
1158      */
1159     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1160         return interfaceId == type(IERC165).interfaceId;
1161     }
1162 }
1163 
1164 // File: @openzeppelin/contracts@4.8.0/token/common/ERC2981.sol
1165 
1166 
1167 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 
1173 /**
1174  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1175  *
1176  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1177  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1178  *
1179  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1180  * fee is specified in basis points by default.
1181  *
1182  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1183  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1184  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1185  *
1186  * _Available since v4.5._
1187  */
1188 abstract contract ERC2981 is IERC2981, ERC165 {
1189     struct RoyaltyInfo {
1190         address receiver;
1191         uint96 royaltyFraction;
1192     }
1193 
1194     RoyaltyInfo private _defaultRoyaltyInfo;
1195     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1196 
1197     /**
1198      * @dev See {IERC165-supportsInterface}.
1199      */
1200     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1201         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1202     }
1203 
1204     /**
1205      * @inheritdoc IERC2981
1206      */
1207     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1208         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1209 
1210         if (royalty.receiver == address(0)) {
1211             royalty = _defaultRoyaltyInfo;
1212         }
1213 
1214         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1215 
1216         return (royalty.receiver, royaltyAmount);
1217     }
1218 
1219     /**
1220      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1221      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1222      * override.
1223      */
1224     function _feeDenominator() internal pure virtual returns (uint96) {
1225         return 10000;
1226     }
1227 
1228     /**
1229      * @dev Sets the royalty information that all ids in this contract will default to.
1230      *
1231      * Requirements:
1232      *
1233      * - `receiver` cannot be the zero address.
1234      * - `feeNumerator` cannot be greater than the fee denominator.
1235      */
1236     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1237         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1238         require(receiver != address(0), "ERC2981: invalid receiver");
1239 
1240         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1241     }
1242 
1243     /**
1244      * @dev Removes default royalty information.
1245      */
1246     function _deleteDefaultRoyalty() internal virtual {
1247         delete _defaultRoyaltyInfo;
1248     }
1249 
1250     /**
1251      * @dev Sets the royalty information for a specific token id, overriding the global default.
1252      *
1253      * Requirements:
1254      *
1255      * - `receiver` cannot be the zero address.
1256      * - `feeNumerator` cannot be greater than the fee denominator.
1257      */
1258     function _setTokenRoyalty(
1259         uint256 tokenId,
1260         address receiver,
1261         uint96 feeNumerator
1262     ) internal virtual {
1263         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1264         require(receiver != address(0), "ERC2981: Invalid parameters");
1265 
1266         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1267     }
1268 
1269     /**
1270      * @dev Resets royalty information for the token id back to the global default.
1271      */
1272     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1273         delete _tokenRoyaltyInfo[tokenId];
1274     }
1275 }
1276 
1277 // File: @openzeppelin/contracts@4.8.0/token/ERC721/IERC721.sol
1278 
1279 
1280 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 
1285 /**
1286  * @dev Required interface of an ERC721 compliant contract.
1287  */
1288 interface IERC721 is IERC165 {
1289     /**
1290      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1291      */
1292     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1293 
1294     /**
1295      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1296      */
1297     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1298 
1299     /**
1300      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1301      */
1302     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1303 
1304     /**
1305      * @dev Returns the number of tokens in ``owner``'s account.
1306      */
1307     function balanceOf(address owner) external view returns (uint256 balance);
1308 
1309     /**
1310      * @dev Returns the owner of the `tokenId` token.
1311      *
1312      * Requirements:
1313      *
1314      * - `tokenId` must exist.
1315      */
1316     function ownerOf(uint256 tokenId) external view returns (address owner);
1317 
1318     /**
1319      * @dev Safely transfers `tokenId` token from `from` to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must exist and be owned by `from`.
1326      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1327      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes calldata data
1336     ) external;
1337 
1338     /**
1339      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1340      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1341      *
1342      * Requirements:
1343      *
1344      * - `from` cannot be the zero address.
1345      * - `to` cannot be the zero address.
1346      * - `tokenId` token must exist and be owned by `from`.
1347      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1348      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1349      *
1350      * Emits a {Transfer} event.
1351      */
1352     function safeTransferFrom(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) external;
1357 
1358     /**
1359      * @dev Transfers `tokenId` token from `from` to `to`.
1360      *
1361      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1362      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1363      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1364      *
1365      * Requirements:
1366      *
1367      * - `from` cannot be the zero address.
1368      * - `to` cannot be the zero address.
1369      * - `tokenId` token must be owned by `from`.
1370      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function transferFrom(
1375         address from,
1376         address to,
1377         uint256 tokenId
1378     ) external;
1379 
1380     /**
1381      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1382      * The approval is cleared when the token is transferred.
1383      *
1384      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1385      *
1386      * Requirements:
1387      *
1388      * - The caller must own the token or be an approved operator.
1389      * - `tokenId` must exist.
1390      *
1391      * Emits an {Approval} event.
1392      */
1393     function approve(address to, uint256 tokenId) external;
1394 
1395     /**
1396      * @dev Approve or remove `operator` as an operator for the caller.
1397      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1398      *
1399      * Requirements:
1400      *
1401      * - The `operator` cannot be the caller.
1402      *
1403      * Emits an {ApprovalForAll} event.
1404      */
1405     function setApprovalForAll(address operator, bool _approved) external;
1406 
1407     /**
1408      * @dev Returns the account approved for `tokenId` token.
1409      *
1410      * Requirements:
1411      *
1412      * - `tokenId` must exist.
1413      */
1414     function getApproved(uint256 tokenId) external view returns (address operator);
1415 
1416     /**
1417      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1418      *
1419      * See {setApprovalForAll}
1420      */
1421     function isApprovedForAll(address owner, address operator) external view returns (bool);
1422 }
1423 
1424 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/IERC721Enumerable.sol
1425 
1426 
1427 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1428 
1429 pragma solidity ^0.8.0;
1430 
1431 
1432 /**
1433  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1434  * @dev See https://eips.ethereum.org/EIPS/eip-721
1435  */
1436 interface IERC721Enumerable is IERC721 {
1437     /**
1438      * @dev Returns the total amount of tokens stored by the contract.
1439      */
1440     function totalSupply() external view returns (uint256);
1441 
1442     /**
1443      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1444      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1445      */
1446     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1447 
1448     /**
1449      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1450      * Use along with {totalSupply} to enumerate all tokens.
1451      */
1452     function tokenByIndex(uint256 index) external view returns (uint256);
1453 }
1454 
1455 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/IERC721Metadata.sol
1456 
1457 
1458 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1459 
1460 pragma solidity ^0.8.0;
1461 
1462 
1463 /**
1464  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1465  * @dev See https://eips.ethereum.org/EIPS/eip-721
1466  */
1467 interface IERC721Metadata is IERC721 {
1468     /**
1469      * @dev Returns the token collection name.
1470      */
1471     function name() external view returns (string memory);
1472 
1473     /**
1474      * @dev Returns the token collection symbol.
1475      */
1476     function symbol() external view returns (string memory);
1477 
1478     /**
1479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1480      */
1481     function tokenURI(uint256 tokenId) external view returns (string memory);
1482 }
1483 
1484 // File: @openzeppelin/contracts@4.8.0/token/ERC721/ERC721.sol
1485 
1486 
1487 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 
1492 
1493 
1494 
1495 
1496 
1497 
1498 /**
1499  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1500  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1501  * {ERC721Enumerable}.
1502  */
1503 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1504     using Address for address;
1505     using Strings for uint256;
1506 
1507     // Token name
1508     string private _name;
1509 
1510     // Token symbol
1511     string private _symbol;
1512 
1513     // Mapping from token ID to owner address
1514     mapping(uint256 => address) private _owners;
1515 
1516     // Mapping owner address to token count
1517     mapping(address => uint256) private _balances;
1518 
1519     // Mapping from token ID to approved address
1520     mapping(uint256 => address) private _tokenApprovals;
1521 
1522     // Mapping from owner to operator approvals
1523     mapping(address => mapping(address => bool)) private _operatorApprovals;
1524 
1525     /**
1526      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1527      */
1528     constructor(string memory name_, string memory symbol_) {
1529         _name = name_;
1530         _symbol = symbol_;
1531     }
1532 
1533     /**
1534      * @dev See {IERC165-supportsInterface}.
1535      */
1536     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1537         return
1538             interfaceId == type(IERC721).interfaceId ||
1539             interfaceId == type(IERC721Metadata).interfaceId ||
1540             super.supportsInterface(interfaceId);
1541     }
1542 
1543     /**
1544      * @dev See {IERC721-balanceOf}.
1545      */
1546     function balanceOf(address owner) public view virtual override returns (uint256) {
1547         require(owner != address(0), "ERC721: address zero is not a valid owner");
1548         return _balances[owner];
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-ownerOf}.
1553      */
1554     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1555         address owner = _ownerOf(tokenId);
1556         require(owner != address(0), "ERC721: invalid token ID");
1557         return owner;
1558     }
1559 
1560     /**
1561      * @dev See {IERC721Metadata-name}.
1562      */
1563     function name() public view virtual override returns (string memory) {
1564         return _name;
1565     }
1566 
1567     /**
1568      * @dev See {IERC721Metadata-symbol}.
1569      */
1570     function symbol() public view virtual override returns (string memory) {
1571         return _symbol;
1572     }
1573 
1574     /**
1575      * @dev See {IERC721Metadata-tokenURI}.
1576      */
1577     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1578         _requireMinted(tokenId);
1579 
1580         string memory baseURI = _baseURI();
1581         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1582     }
1583 
1584     /**
1585      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1586      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1587      * by default, can be overridden in child contracts.
1588      */
1589     function _baseURI() internal view virtual returns (string memory) {
1590         return "";
1591     }
1592 
1593     /**
1594      * @dev See {IERC721-approve}.
1595      */
1596     function approve(address to, uint256 tokenId) public virtual override {
1597         address owner = ERC721.ownerOf(tokenId);
1598         require(to != owner, "ERC721: approval to current owner");
1599 
1600         require(
1601             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1602             "ERC721: approve caller is not token owner or approved for all"
1603         );
1604 
1605         _approve(to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev See {IERC721-getApproved}.
1610      */
1611     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1612         _requireMinted(tokenId);
1613 
1614         return _tokenApprovals[tokenId];
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-setApprovalForAll}.
1619      */
1620     function setApprovalForAll(address operator, bool approved) public virtual override {
1621         _setApprovalForAll(_msgSender(), operator, approved);
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-isApprovedForAll}.
1626      */
1627     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1628         return _operatorApprovals[owner][operator];
1629     }
1630 
1631     /**
1632      * @dev See {IERC721-transferFrom}.
1633      */
1634     function transferFrom(
1635         address from,
1636         address to,
1637         uint256 tokenId
1638     ) public virtual override {
1639         //solhint-disable-next-line max-line-length
1640         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1641 
1642         _transfer(from, to, tokenId);
1643     }
1644 
1645     /**
1646      * @dev See {IERC721-safeTransferFrom}.
1647      */
1648     function safeTransferFrom(
1649         address from,
1650         address to,
1651         uint256 tokenId
1652     ) public virtual override {
1653         safeTransferFrom(from, to, tokenId, "");
1654     }
1655 
1656     /**
1657      * @dev See {IERC721-safeTransferFrom}.
1658      */
1659     function safeTransferFrom(
1660         address from,
1661         address to,
1662         uint256 tokenId,
1663         bytes memory data
1664     ) public virtual override {
1665         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1666         _safeTransfer(from, to, tokenId, data);
1667     }
1668 
1669     /**
1670      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1671      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1672      *
1673      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1674      *
1675      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1676      * implement alternative mechanisms to perform token transfer, such as signature-based.
1677      *
1678      * Requirements:
1679      *
1680      * - `from` cannot be the zero address.
1681      * - `to` cannot be the zero address.
1682      * - `tokenId` token must exist and be owned by `from`.
1683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1684      *
1685      * Emits a {Transfer} event.
1686      */
1687     function _safeTransfer(
1688         address from,
1689         address to,
1690         uint256 tokenId,
1691         bytes memory data
1692     ) internal virtual {
1693         _transfer(from, to, tokenId);
1694         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1695     }
1696 
1697     /**
1698      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1699      */
1700     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1701         return _owners[tokenId];
1702     }
1703 
1704     /**
1705      * @dev Returns whether `tokenId` exists.
1706      *
1707      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1708      *
1709      * Tokens start existing when they are minted (`_mint`),
1710      * and stop existing when they are burned (`_burn`).
1711      */
1712     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1713         return _ownerOf(tokenId) != address(0);
1714     }
1715 
1716     /**
1717      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1718      *
1719      * Requirements:
1720      *
1721      * - `tokenId` must exist.
1722      */
1723     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1724         address owner = ERC721.ownerOf(tokenId);
1725         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1726     }
1727 
1728     /**
1729      * @dev Safely mints `tokenId` and transfers it to `to`.
1730      *
1731      * Requirements:
1732      *
1733      * - `tokenId` must not exist.
1734      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1735      *
1736      * Emits a {Transfer} event.
1737      */
1738     function _safeMint(address to, uint256 tokenId) internal virtual {
1739         _safeMint(to, tokenId, "");
1740     }
1741 
1742     /**
1743      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1744      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1745      */
1746     function _safeMint(
1747         address to,
1748         uint256 tokenId,
1749         bytes memory data
1750     ) internal virtual {
1751         _mint(to, tokenId);
1752         require(
1753             _checkOnERC721Received(address(0), to, tokenId, data),
1754             "ERC721: transfer to non ERC721Receiver implementer"
1755         );
1756     }
1757 
1758     /**
1759      * @dev Mints `tokenId` and transfers it to `to`.
1760      *
1761      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1762      *
1763      * Requirements:
1764      *
1765      * - `tokenId` must not exist.
1766      * - `to` cannot be the zero address.
1767      *
1768      * Emits a {Transfer} event.
1769      */
1770     function _mint(address to, uint256 tokenId) internal virtual {
1771         require(to != address(0), "ERC721: mint to the zero address");
1772         require(!_exists(tokenId), "ERC721: token already minted");
1773 
1774         _beforeTokenTransfer(address(0), to, tokenId, 1);
1775 
1776         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1777         require(!_exists(tokenId), "ERC721: token already minted");
1778 
1779         unchecked {
1780             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1781             // Given that tokens are minted one by one, it is impossible in practice that
1782             // this ever happens. Might change if we allow batch minting.
1783             // The ERC fails to describe this case.
1784             _balances[to] += 1;
1785         }
1786 
1787         _owners[tokenId] = to;
1788 
1789         emit Transfer(address(0), to, tokenId);
1790 
1791         _afterTokenTransfer(address(0), to, tokenId, 1);
1792     }
1793 
1794     /**
1795      * @dev Destroys `tokenId`.
1796      * The approval is cleared when the token is burned.
1797      * This is an internal function that does not check if the sender is authorized to operate on the token.
1798      *
1799      * Requirements:
1800      *
1801      * - `tokenId` must exist.
1802      *
1803      * Emits a {Transfer} event.
1804      */
1805     function _burn(uint256 tokenId) internal virtual {
1806         address owner = ERC721.ownerOf(tokenId);
1807 
1808         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1809 
1810         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1811         owner = ERC721.ownerOf(tokenId);
1812 
1813         // Clear approvals
1814         delete _tokenApprovals[tokenId];
1815 
1816         unchecked {
1817             // Cannot overflow, as that would require more tokens to be burned/transferred
1818             // out than the owner initially received through minting and transferring in.
1819             _balances[owner] -= 1;
1820         }
1821         delete _owners[tokenId];
1822 
1823         emit Transfer(owner, address(0), tokenId);
1824 
1825         _afterTokenTransfer(owner, address(0), tokenId, 1);
1826     }
1827 
1828     /**
1829      * @dev Transfers `tokenId` from `from` to `to`.
1830      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1831      *
1832      * Requirements:
1833      *
1834      * - `to` cannot be the zero address.
1835      * - `tokenId` token must be owned by `from`.
1836      *
1837      * Emits a {Transfer} event.
1838      */
1839     function _transfer(
1840         address from,
1841         address to,
1842         uint256 tokenId
1843     ) internal virtual {
1844         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1845         require(to != address(0), "ERC721: transfer to the zero address");
1846 
1847         _beforeTokenTransfer(from, to, tokenId, 1);
1848 
1849         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1850         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1851 
1852         // Clear approvals from the previous owner
1853         delete _tokenApprovals[tokenId];
1854 
1855         unchecked {
1856             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1857             // `from`'s balance is the number of token held, which is at least one before the current
1858             // transfer.
1859             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1860             // all 2**256 token ids to be minted, which in practice is impossible.
1861             _balances[from] -= 1;
1862             _balances[to] += 1;
1863         }
1864         _owners[tokenId] = to;
1865 
1866         emit Transfer(from, to, tokenId);
1867 
1868         _afterTokenTransfer(from, to, tokenId, 1);
1869     }
1870 
1871     /**
1872      * @dev Approve `to` to operate on `tokenId`
1873      *
1874      * Emits an {Approval} event.
1875      */
1876     function _approve(address to, uint256 tokenId) internal virtual {
1877         _tokenApprovals[tokenId] = to;
1878         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1879     }
1880 
1881     /**
1882      * @dev Approve `operator` to operate on all of `owner` tokens
1883      *
1884      * Emits an {ApprovalForAll} event.
1885      */
1886     function _setApprovalForAll(
1887         address owner,
1888         address operator,
1889         bool approved
1890     ) internal virtual {
1891         require(owner != operator, "ERC721: approve to caller");
1892         _operatorApprovals[owner][operator] = approved;
1893         emit ApprovalForAll(owner, operator, approved);
1894     }
1895 
1896     /**
1897      * @dev Reverts if the `tokenId` has not been minted yet.
1898      */
1899     function _requireMinted(uint256 tokenId) internal view virtual {
1900         require(_exists(tokenId), "ERC721: invalid token ID");
1901     }
1902 
1903     /**
1904      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1905      * The call is not executed if the target address is not a contract.
1906      *
1907      * @param from address representing the previous owner of the given token ID
1908      * @param to target address that will receive the tokens
1909      * @param tokenId uint256 ID of the token to be transferred
1910      * @param data bytes optional data to send along with the call
1911      * @return bool whether the call correctly returned the expected magic value
1912      */
1913     function _checkOnERC721Received(
1914         address from,
1915         address to,
1916         uint256 tokenId,
1917         bytes memory data
1918     ) private returns (bool) {
1919         if (to.isContract()) {
1920             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1921                 return retval == IERC721Receiver.onERC721Received.selector;
1922             } catch (bytes memory reason) {
1923                 if (reason.length == 0) {
1924                     revert("ERC721: transfer to non ERC721Receiver implementer");
1925                 } else {
1926                     /// @solidity memory-safe-assembly
1927                     assembly {
1928                         revert(add(32, reason), mload(reason))
1929                     }
1930                 }
1931             }
1932         } else {
1933             return true;
1934         }
1935     }
1936 
1937     /**
1938      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1939      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1940      *
1941      * Calling conditions:
1942      *
1943      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1944      * - When `from` is zero, the tokens will be minted for `to`.
1945      * - When `to` is zero, ``from``'s tokens will be burned.
1946      * - `from` and `to` are never both zero.
1947      * - `batchSize` is non-zero.
1948      *
1949      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1950      */
1951     function _beforeTokenTransfer(
1952         address from,
1953         address to,
1954         uint256, /* firstTokenId */
1955         uint256 batchSize
1956     ) internal virtual {
1957         if (batchSize > 1) {
1958             if (from != address(0)) {
1959                 _balances[from] -= batchSize;
1960             }
1961             if (to != address(0)) {
1962                 _balances[to] += batchSize;
1963             }
1964         }
1965     }
1966 
1967     /**
1968      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1969      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1970      *
1971      * Calling conditions:
1972      *
1973      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1974      * - When `from` is zero, the tokens were minted for `to`.
1975      * - When `to` is zero, ``from``'s tokens were burned.
1976      * - `from` and `to` are never both zero.
1977      * - `batchSize` is non-zero.
1978      *
1979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1980      */
1981     function _afterTokenTransfer(
1982         address from,
1983         address to,
1984         uint256 firstTokenId,
1985         uint256 batchSize
1986     ) internal virtual {}
1987 }
1988 
1989 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Royalty.sol
1990 
1991 
1992 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Royalty.sol)
1993 
1994 pragma solidity ^0.8.0;
1995 
1996 
1997 
1998 
1999 /**
2000  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
2001  * information.
2002  *
2003  * Royalty information can be specified globally for all token ids via {ERC2981-_setDefaultRoyalty}, and/or individually for
2004  * specific token ids via {ERC2981-_setTokenRoyalty}. The latter takes precedence over the first.
2005  *
2006  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2007  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2008  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2009  *
2010  * _Available since v4.5._
2011  */
2012 abstract contract ERC721Royalty is ERC2981, ERC721 {
2013     /**
2014      * @dev See {IERC165-supportsInterface}.
2015      */
2016     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
2017         return super.supportsInterface(interfaceId);
2018     }
2019 
2020     /**
2021      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
2022      */
2023     function _burn(uint256 tokenId) internal virtual override {
2024         super._burn(tokenId);
2025         _resetTokenRoyalty(tokenId);
2026     }
2027 }
2028 
2029 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Burnable.sol
2030 
2031 
2032 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
2033 
2034 pragma solidity ^0.8.0;
2035 
2036 
2037 
2038 /**
2039  * @title ERC721 Burnable Token
2040  * @dev ERC721 Token that can be burned (destroyed).
2041  */
2042 abstract contract ERC721Burnable is Context, ERC721 {
2043     /**
2044      * @dev Burns `tokenId`. See {ERC721-_burn}.
2045      *
2046      * Requirements:
2047      *
2048      * - The caller must own `tokenId` or be an approved operator.
2049      */
2050     function burn(uint256 tokenId) public virtual {
2051         //solhint-disable-next-line max-line-length
2052         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2053         _burn(tokenId);
2054     }
2055 }
2056 
2057 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721URIStorage.sol
2058 
2059 
2060 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
2061 
2062 pragma solidity ^0.8.0;
2063 
2064 
2065 /**
2066  * @dev ERC721 token with storage based token URI management.
2067  */
2068 abstract contract ERC721URIStorage is ERC721 {
2069     using Strings for uint256;
2070 
2071     // Optional mapping for token URIs
2072     mapping(uint256 => string) private _tokenURIs;
2073 
2074     /**
2075      * @dev See {IERC721Metadata-tokenURI}.
2076      */
2077     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2078         _requireMinted(tokenId);
2079 
2080         string memory _tokenURI = _tokenURIs[tokenId];
2081         string memory base = _baseURI();
2082 
2083         // If there is no base URI, return the token URI.
2084         if (bytes(base).length == 0) {
2085             return _tokenURI;
2086         }
2087         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2088         if (bytes(_tokenURI).length > 0) {
2089             return string(abi.encodePacked(base, _tokenURI));
2090         }
2091 
2092         return super.tokenURI(tokenId);
2093     }
2094 
2095     /**
2096      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2097      *
2098      * Requirements:
2099      *
2100      * - `tokenId` must exist.
2101      */
2102     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2103         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
2104         _tokenURIs[tokenId] = _tokenURI;
2105     }
2106 
2107     /**
2108      * @dev See {ERC721-_burn}. This override additionally checks to see if a
2109      * token-specific URI was set for the token, and if so, it deletes the token URI from
2110      * the storage mapping.
2111      */
2112     function _burn(uint256 tokenId) internal virtual override {
2113         super._burn(tokenId);
2114 
2115         if (bytes(_tokenURIs[tokenId]).length != 0) {
2116             delete _tokenURIs[tokenId];
2117         }
2118     }
2119 }
2120 
2121 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Enumerable.sol
2122 
2123 
2124 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
2125 
2126 pragma solidity ^0.8.0;
2127 
2128 
2129 
2130 /**
2131  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2132  * enumerability of all the token ids in the contract as well as all token ids owned by each
2133  * account.
2134  */
2135 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2136     // Mapping from owner to list of owned token IDs
2137     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2138 
2139     // Mapping from token ID to index of the owner tokens list
2140     mapping(uint256 => uint256) private _ownedTokensIndex;
2141 
2142     // Array with all token ids, used for enumeration
2143     uint256[] private _allTokens;
2144 
2145     // Mapping from token id to position in the allTokens array
2146     mapping(uint256 => uint256) private _allTokensIndex;
2147 
2148     /**
2149      * @dev See {IERC165-supportsInterface}.
2150      */
2151     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2152         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2153     }
2154 
2155     /**
2156      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2157      */
2158     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2159         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2160         return _ownedTokens[owner][index];
2161     }
2162 
2163     /**
2164      * @dev See {IERC721Enumerable-totalSupply}.
2165      */
2166     function totalSupply() public view virtual override returns (uint256) {
2167         return _allTokens.length;
2168     }
2169 
2170     /**
2171      * @dev See {IERC721Enumerable-tokenByIndex}.
2172      */
2173     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2174         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2175         return _allTokens[index];
2176     }
2177 
2178     /**
2179      * @dev See {ERC721-_beforeTokenTransfer}.
2180      */
2181     function _beforeTokenTransfer(
2182         address from,
2183         address to,
2184         uint256 firstTokenId,
2185         uint256 batchSize
2186     ) internal virtual override {
2187         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
2188 
2189         if (batchSize > 1) {
2190             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
2191             revert("ERC721Enumerable: consecutive transfers not supported");
2192         }
2193 
2194         uint256 tokenId = firstTokenId;
2195 
2196         if (from == address(0)) {
2197             _addTokenToAllTokensEnumeration(tokenId);
2198         } else if (from != to) {
2199             _removeTokenFromOwnerEnumeration(from, tokenId);
2200         }
2201         if (to == address(0)) {
2202             _removeTokenFromAllTokensEnumeration(tokenId);
2203         } else if (to != from) {
2204             _addTokenToOwnerEnumeration(to, tokenId);
2205         }
2206     }
2207 
2208     /**
2209      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2210      * @param to address representing the new owner of the given token ID
2211      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2212      */
2213     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2214         uint256 length = ERC721.balanceOf(to);
2215         _ownedTokens[to][length] = tokenId;
2216         _ownedTokensIndex[tokenId] = length;
2217     }
2218 
2219     /**
2220      * @dev Private function to add a token to this extension's token tracking data structures.
2221      * @param tokenId uint256 ID of the token to be added to the tokens list
2222      */
2223     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2224         _allTokensIndex[tokenId] = _allTokens.length;
2225         _allTokens.push(tokenId);
2226     }
2227 
2228     /**
2229      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2230      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2231      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2232      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2233      * @param from address representing the previous owner of the given token ID
2234      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2235      */
2236     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2237         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2238         // then delete the last slot (swap and pop).
2239 
2240         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2241         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2242 
2243         // When the token to delete is the last token, the swap operation is unnecessary
2244         if (tokenIndex != lastTokenIndex) {
2245             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2246 
2247             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2248             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2249         }
2250 
2251         // This also deletes the contents at the last position of the array
2252         delete _ownedTokensIndex[tokenId];
2253         delete _ownedTokens[from][lastTokenIndex];
2254     }
2255 
2256     /**
2257      * @dev Private function to remove a token from this extension's token tracking data structures.
2258      * This has O(1) time complexity, but alters the order of the _allTokens array.
2259      * @param tokenId uint256 ID of the token to be removed from the tokens list
2260      */
2261     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2262         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2263         // then delete the last slot (swap and pop).
2264 
2265         uint256 lastTokenIndex = _allTokens.length - 1;
2266         uint256 tokenIndex = _allTokensIndex[tokenId];
2267 
2268         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2269         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2270         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2271         uint256 lastTokenId = _allTokens[lastTokenIndex];
2272 
2273         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2274         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2275 
2276         // This also deletes the contents at the last position of the array
2277         delete _allTokensIndex[tokenId];
2278         _allTokens.pop();
2279     }
2280 }
2281 
2282 // File: contracts/test.sol
2283 
2284 
2285 pragma solidity ^0.8.13;
2286 
2287 
2288 
2289 
2290 
2291 
2292 
2293 
2294 
2295 
2296 
2297 
2298 contract FootBallApeFanClub is DefaultOperatorFilterer, ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable, ERC721Royalty {
2299     using Counters for Counters.Counter;
2300 
2301     Counters.Counter private _tokenIdCounter;
2302 
2303     uint256 public cost = 0.04 ether;
2304     uint256 public maxSupply = 10000;
2305     uint256 public maxMintAmountPerTx = 50;
2306 
2307     string public BaseURI = "ipfs://QmbPtEwTBVKbMV6TJuitTF95gdYfxChZfa6cXJjsYcyEPG/";
2308 
2309     address public owner_address = 0xb5aDac2dbDd9fd2f4a94daEC07616a36Babb02dA;
2310 
2311     mapping (uint256 => string) private _tokenURIs;
2312 
2313     constructor() ERC721("FootBallApeFanClub", "FAFC") {
2314         _setDefaultRoyalty(owner_address, 500);
2315     }
2316 
2317     function _baseURI() internal view override returns (string memory) {
2318         return BaseURI;
2319     }
2320 
2321     function pause() public onlyOwner {
2322         _pause();
2323     }
2324 
2325     function unpause() public onlyOwner {
2326         _unpause();
2327     }
2328 
2329     function setBaseURI(string memory _URI) public onlyOwner {
2330         BaseURI = _URI;
2331     }
2332 
2333     function mint(uint256 _mintAmount) public payable {
2334         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
2335         require(msg.value >= _mintAmount * cost, "Not enough ether sent");
2336         require(totalSupply() + _mintAmount <= maxSupply, "Not enough left to mint all your requests");
2337         for (uint256 i = 0; i < _mintAmount; i++) {
2338             safeMint(msg.sender);
2339         }
2340     }
2341 
2342     function airdrop(address[] memory _adresses, uint256 _mintAmount) public onlyOwner {
2343         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
2344         for (uint256 j = 0; j < _adresses.length; j++) {
2345             require(totalSupply() + _mintAmount <= maxSupply, "Not enough left to mint all your requests");
2346             for (uint256 i = 0; i < _mintAmount; i++) {
2347                 safeMint(_adresses[j]);
2348             }
2349         }
2350     }
2351 
2352     function safeMint(address to) internal {
2353         uint256 tokenId = _tokenIdCounter.current() + 1;
2354         _tokenIdCounter.increment();
2355         _safeMint(to, tokenId);
2356         _setTokenURI(tokenId);
2357     }
2358 
2359     function setmaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2360         maxMintAmountPerTx = _maxMintAmountPerTx;
2361     }
2362 
2363     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
2364         maxSupply = _maxSupply;
2365     }
2366 
2367     function setcost(uint256 _cost) external onlyOwner {
2368         cost = _cost;
2369     }
2370 
2371     function withdraw() public onlyOwner {
2372         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2373         require(os);
2374     }
2375 
2376     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
2377         internal
2378         whenNotPaused
2379         override(ERC721, ERC721Enumerable)
2380     {
2381         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2382     }
2383 
2384     // The following functions are overrides required by Solidity.
2385 
2386     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage, ERC721Royalty) {
2387         super._burn(tokenId);
2388     }
2389 
2390     function tokenURI(uint256 tokenId)
2391         public
2392         view
2393         override(ERC721, ERC721URIStorage)
2394         returns (string memory)
2395     {
2396         return string.concat(super.tokenURI(tokenId), ".json");
2397     }
2398 
2399     function _setTokenURI(uint256 tokenId) internal virtual {
2400         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2401         string memory suffix = string.concat(Strings.toString(tokenId), ".json");
2402         string memory _tokenURI = string(abi.encodePacked(_baseURI(), suffix));
2403         _tokenURIs[tokenId] = _tokenURI;
2404     }
2405 
2406     function supportsInterface(bytes4 interfaceId)
2407         public
2408         view
2409         override(ERC721, ERC721Enumerable, ERC721Royalty)
2410         returns (bool)
2411     {
2412         return super.supportsInterface(interfaceId);
2413     }
2414 
2415      function setApprovalForAll(address operator, bool approved) 
2416         public 
2417         override(ERC721,IERC721)
2418         onlyAllowedOperatorApproval(operator) 
2419     {
2420         super.setApprovalForAll(operator, approved);
2421     }
2422 
2423     function approve(address operator, uint256 tokenId) 
2424         public 
2425         override(ERC721,IERC721)
2426         onlyAllowedOperatorApproval(operator) 
2427     {
2428         super.approve(operator, tokenId);
2429     }
2430 
2431     function transferFrom(address from, address to, uint256 tokenId) 
2432         public 
2433         override(ERC721,IERC721)
2434         onlyAllowedOperator(from) 
2435     {
2436         super.transferFrom(from, to, tokenId);
2437     }
2438 
2439     function safeTransferFrom(address from, address to, uint256 tokenId) 
2440         public 
2441         override(ERC721,IERC721)
2442         onlyAllowedOperator(from) 
2443     {
2444         super.safeTransferFrom(from, to, tokenId);
2445     }
2446 
2447     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2448         public
2449         override(ERC721,IERC721)
2450         onlyAllowedOperator(from)
2451     {
2452         super.safeTransferFrom(from, to, tokenId, data);
2453     }
2454     
2455 }