1 // Sources flattened with hardhat v2.12.4 https://hardhat.org
2 
3 // File contracts/OperatorFilterer.sol
4 
5 
6 pragma solidity ^0.8.4;
7 
8 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
9 /// mandatory on-chain royalty enforcement in order for new collections to
10 /// receive royalties.
11 /// For more information, see:
12 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
13 abstract contract OperatorFilterer {
14     /// @dev The default OpenSea operator blocklist subscription.
15     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
16 
17     /// @dev The OpenSea operator filter registry.
18     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
19 
20     /// @dev Registers the current contract to OpenSea's operator filter,
21     /// and subscribe to the default OpenSea operator blocklist.
22     /// Note: Will not revert nor update existing settings for repeated registration.
23     function _registerForOperatorFiltering() internal virtual {
24         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
25     }
26 
27     /// @dev Registers the current contract to OpenSea's operator filter.
28     /// Note: Will not revert nor update existing settings for repeated registration.
29     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
30         internal
31         virtual
32     {
33         /// @solidity memory-safe-assembly
34         assembly {
35             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
36 
37             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
38             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
39 
40             for {} iszero(subscribe) {} {
41                 if iszero(subscriptionOrRegistrantToCopy) {
42                     functionSelector := 0x4420e486 // `register(address)`.
43                     break
44                 }
45                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
46                 break
47             }
48             // Store the function selector.
49             mstore(0x00, shl(224, functionSelector))
50             // Store the `address(this)`.
51             mstore(0x04, address())
52             // Store the `subscriptionOrRegistrantToCopy`.
53             mstore(0x24, subscriptionOrRegistrantToCopy)
54             // Register into the registry.
55             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
56                 // If the function selector has not been overwritten,
57                 // it is an out-of-gas error.
58                 if eq(shr(224, mload(0x00)), functionSelector) {
59                     // To prevent gas under-estimation.
60                     revert(0, 0)
61                 }
62             }
63             // Restore the part of the free memory pointer that was overwritten,
64             // which is guaranteed to be zero, because of Solidity's memory size limits.
65             mstore(0x24, 0)
66         }
67     }
68 
69     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
70     modifier onlyAllowedOperator(address from) virtual {
71         if (from != msg.sender) {
72             if (!_isPriorityOperator(msg.sender)) {
73                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
74             }
75         }
76         _;
77     }
78 
79     /// @dev Modifier to guard a function from approving a blocked operator..
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         if (!_isPriorityOperator(operator)) {
82             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
83         }
84         _;
85     }
86 
87     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
88     function _revertIfBlocked(address operator) private view {
89         /// @solidity memory-safe-assembly
90         assembly {
91             // Store the function selector of `isOperatorAllowed(address,address)`,
92             // shifted left by 6 bytes, which is enough for 8tb of memory.
93             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
94             mstore(0x00, 0xc6171134001122334455)
95             // Store the `address(this)`.
96             mstore(0x1a, address())
97             // Store the `operator`.
98             mstore(0x3a, operator)
99 
100             // `isOperatorAllowed` always returns true if it does not revert.
101             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
102                 // Bubble up the revert if the staticcall reverts.
103                 returndatacopy(0x00, 0x00, returndatasize())
104                 revert(0x00, returndatasize())
105             }
106 
107             // We'll skip checking if `from` is inside the blacklist.
108             // Even though that can block transferring out of wrapper contracts,
109             // we don't want tokens to be stuck.
110 
111             // Restore the part of the free memory pointer that was overwritten,
112             // which is guaranteed to be zero, if less than 8tb of memory is used.
113             mstore(0x3a, 0)
114         }
115     }
116 
117     /// @dev For deriving contracts to override, so that operator filtering
118     /// can be turned on / off.
119     /// Returns true by default.
120     function _operatorFilteringEnabled() internal view virtual returns (bool) {
121         return true;
122     }
123 
124     /// @dev For deriving contracts to override, so that preferred marketplaces can
125     /// skip operator filtering, helping users save gas.
126     /// Returns false for all inputs by default.
127     function _isPriorityOperator(address) internal view virtual returns (bool) {
128         return false;
129     }
130 }
131 
132 
133 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 abstract contract Context {
151     function _msgSender() internal view virtual returns (address) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view virtual returns (bytes calldata) {
156         return msg.data;
157     }
158 }
159 
160 
161 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
162 
163 
164 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Contract module which provides a basic access control mechanism, where
170  * there is an account (an owner) that can be granted exclusive access to
171  * specific functions.
172  *
173  * By default, the owner account will be the one that deploys the contract. This
174  * can later be changed with {transferOwnership}.
175  *
176  * This module is used through inheritance. It will make available the modifier
177  * `onlyOwner`, which can be applied to your functions to restrict their use to
178  * the owner.
179  */
180 abstract contract Ownable is Context {
181     address private _owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     /**
186      * @dev Initializes the contract setting the deployer as the initial owner.
187      */
188     constructor() {
189         _transferOwnership(_msgSender());
190     }
191 
192     /**
193      * @dev Throws if called by any account other than the owner.
194      */
195     modifier onlyOwner() {
196         _checkOwner();
197         _;
198     }
199 
200     /**
201      * @dev Returns the address of the current owner.
202      */
203     function owner() public view virtual returns (address) {
204         return _owner;
205     }
206 
207     /**
208      * @dev Throws if the sender is not the owner.
209      */
210     function _checkOwner() internal view virtual {
211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
212     }
213 
214     /**
215      * @dev Leaves the contract without owner. It will not be possible to call
216      * `onlyOwner` functions anymore. Can only be called by the current owner.
217      *
218      * NOTE: Renouncing ownership will leave the contract without an owner,
219      * thereby removing any functionality that is only available to the owner.
220      */
221     function renounceOwnership() public virtual onlyOwner {
222         _transferOwnership(address(0));
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Internal function without access restriction.
237      */
238     function _transferOwnership(address newOwner) internal virtual {
239         address oldOwner = _owner;
240         _owner = newOwner;
241         emit OwnershipTransferred(oldOwner, newOwner);
242     }
243 }
244 
245 
246 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
247 
248 
249 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev Standard math utilities missing in the Solidity language.
255  */
256 library Math {
257     enum Rounding {
258         Down, // Toward negative infinity
259         Up, // Toward infinity
260         Zero // Toward zero
261     }
262 
263     /**
264      * @dev Returns the largest of two numbers.
265      */
266     function max(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a > b ? a : b;
268     }
269 
270     /**
271      * @dev Returns the smallest of two numbers.
272      */
273     function min(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a < b ? a : b;
275     }
276 
277     /**
278      * @dev Returns the average of two numbers. The result is rounded towards
279      * zero.
280      */
281     function average(uint256 a, uint256 b) internal pure returns (uint256) {
282         // (a + b) / 2 can overflow.
283         return (a & b) + (a ^ b) / 2;
284     }
285 
286     /**
287      * @dev Returns the ceiling of the division of two numbers.
288      *
289      * This differs from standard division with `/` in that it rounds up instead
290      * of rounding down.
291      */
292     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
293         // (a + b - 1) / b can overflow on addition, so we distribute.
294         return a == 0 ? 0 : (a - 1) / b + 1;
295     }
296 
297     /**
298      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
299      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
300      * with further edits by Uniswap Labs also under MIT license.
301      */
302     function mulDiv(
303         uint256 x,
304         uint256 y,
305         uint256 denominator
306     ) internal pure returns (uint256 result) {
307         unchecked {
308             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
309             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
310             // variables such that product = prod1 * 2^256 + prod0.
311             uint256 prod0; // Least significant 256 bits of the product
312             uint256 prod1; // Most significant 256 bits of the product
313             assembly {
314                 let mm := mulmod(x, y, not(0))
315                 prod0 := mul(x, y)
316                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
317             }
318 
319             // Handle non-overflow cases, 256 by 256 division.
320             if (prod1 == 0) {
321                 return prod0 / denominator;
322             }
323 
324             // Make sure the result is less than 2^256. Also prevents denominator == 0.
325             require(denominator > prod1);
326 
327             ///////////////////////////////////////////////
328             // 512 by 256 division.
329             ///////////////////////////////////////////////
330 
331             // Make division exact by subtracting the remainder from [prod1 prod0].
332             uint256 remainder;
333             assembly {
334                 // Compute remainder using mulmod.
335                 remainder := mulmod(x, y, denominator)
336 
337                 // Subtract 256 bit number from 512 bit number.
338                 prod1 := sub(prod1, gt(remainder, prod0))
339                 prod0 := sub(prod0, remainder)
340             }
341 
342             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
343             // See https://cs.stackexchange.com/q/138556/92363.
344 
345             // Does not overflow because the denominator cannot be zero at this stage in the function.
346             uint256 twos = denominator & (~denominator + 1);
347             assembly {
348                 // Divide denominator by twos.
349                 denominator := div(denominator, twos)
350 
351                 // Divide [prod1 prod0] by twos.
352                 prod0 := div(prod0, twos)
353 
354                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
355                 twos := add(div(sub(0, twos), twos), 1)
356             }
357 
358             // Shift in bits from prod1 into prod0.
359             prod0 |= prod1 * twos;
360 
361             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
362             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
363             // four bits. That is, denominator * inv = 1 mod 2^4.
364             uint256 inverse = (3 * denominator) ^ 2;
365 
366             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
367             // in modular arithmetic, doubling the correct bits in each step.
368             inverse *= 2 - denominator * inverse; // inverse mod 2^8
369             inverse *= 2 - denominator * inverse; // inverse mod 2^16
370             inverse *= 2 - denominator * inverse; // inverse mod 2^32
371             inverse *= 2 - denominator * inverse; // inverse mod 2^64
372             inverse *= 2 - denominator * inverse; // inverse mod 2^128
373             inverse *= 2 - denominator * inverse; // inverse mod 2^256
374 
375             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
376             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
377             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
378             // is no longer required.
379             result = prod0 * inverse;
380             return result;
381         }
382     }
383 
384     /**
385      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
386      */
387     function mulDiv(
388         uint256 x,
389         uint256 y,
390         uint256 denominator,
391         Rounding rounding
392     ) internal pure returns (uint256) {
393         uint256 result = mulDiv(x, y, denominator);
394         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
395             result += 1;
396         }
397         return result;
398     }
399 
400     /**
401      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
402      *
403      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
404      */
405     function sqrt(uint256 a) internal pure returns (uint256) {
406         if (a == 0) {
407             return 0;
408         }
409 
410         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
411         //
412         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
413         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
414         //
415         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
416         // ΓåÆ `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
417         // ΓåÆ `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
418         //
419         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
420         uint256 result = 1 << (log2(a) >> 1);
421 
422         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
423         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
424         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
425         // into the expected uint128 result.
426         unchecked {
427             result = (result + a / result) >> 1;
428             result = (result + a / result) >> 1;
429             result = (result + a / result) >> 1;
430             result = (result + a / result) >> 1;
431             result = (result + a / result) >> 1;
432             result = (result + a / result) >> 1;
433             result = (result + a / result) >> 1;
434             return min(result, a / result);
435         }
436     }
437 
438     /**
439      * @notice Calculates sqrt(a), following the selected rounding direction.
440      */
441     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
442         unchecked {
443             uint256 result = sqrt(a);
444             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
445         }
446     }
447 
448     /**
449      * @dev Return the log in base 2, rounded down, of a positive value.
450      * Returns 0 if given 0.
451      */
452     function log2(uint256 value) internal pure returns (uint256) {
453         uint256 result = 0;
454         unchecked {
455             if (value >> 128 > 0) {
456                 value >>= 128;
457                 result += 128;
458             }
459             if (value >> 64 > 0) {
460                 value >>= 64;
461                 result += 64;
462             }
463             if (value >> 32 > 0) {
464                 value >>= 32;
465                 result += 32;
466             }
467             if (value >> 16 > 0) {
468                 value >>= 16;
469                 result += 16;
470             }
471             if (value >> 8 > 0) {
472                 value >>= 8;
473                 result += 8;
474             }
475             if (value >> 4 > 0) {
476                 value >>= 4;
477                 result += 4;
478             }
479             if (value >> 2 > 0) {
480                 value >>= 2;
481                 result += 2;
482             }
483             if (value >> 1 > 0) {
484                 result += 1;
485             }
486         }
487         return result;
488     }
489 
490     /**
491      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
492      * Returns 0 if given 0.
493      */
494     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
495         unchecked {
496             uint256 result = log2(value);
497             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
498         }
499     }
500 
501     /**
502      * @dev Return the log in base 10, rounded down, of a positive value.
503      * Returns 0 if given 0.
504      */
505     function log10(uint256 value) internal pure returns (uint256) {
506         uint256 result = 0;
507         unchecked {
508             if (value >= 10**64) {
509                 value /= 10**64;
510                 result += 64;
511             }
512             if (value >= 10**32) {
513                 value /= 10**32;
514                 result += 32;
515             }
516             if (value >= 10**16) {
517                 value /= 10**16;
518                 result += 16;
519             }
520             if (value >= 10**8) {
521                 value /= 10**8;
522                 result += 8;
523             }
524             if (value >= 10**4) {
525                 value /= 10**4;
526                 result += 4;
527             }
528             if (value >= 10**2) {
529                 value /= 10**2;
530                 result += 2;
531             }
532             if (value >= 10**1) {
533                 result += 1;
534             }
535         }
536         return result;
537     }
538 
539     /**
540      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
541      * Returns 0 if given 0.
542      */
543     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
544         unchecked {
545             uint256 result = log10(value);
546             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
547         }
548     }
549 
550     /**
551      * @dev Return the log in base 256, rounded down, of a positive value.
552      * Returns 0 if given 0.
553      *
554      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
555      */
556     function log256(uint256 value) internal pure returns (uint256) {
557         uint256 result = 0;
558         unchecked {
559             if (value >> 128 > 0) {
560                 value >>= 128;
561                 result += 16;
562             }
563             if (value >> 64 > 0) {
564                 value >>= 64;
565                 result += 8;
566             }
567             if (value >> 32 > 0) {
568                 value >>= 32;
569                 result += 4;
570             }
571             if (value >> 16 > 0) {
572                 value >>= 16;
573                 result += 2;
574             }
575             if (value >> 8 > 0) {
576                 result += 1;
577             }
578         }
579         return result;
580     }
581 
582     /**
583      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
584      * Returns 0 if given 0.
585      */
586     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
587         unchecked {
588             uint256 result = log256(value);
589             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
590         }
591     }
592 }
593 
594 
595 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
596 
597 
598 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev String operations.
604  */
605 library Strings {
606     bytes16 private constant _SYMBOLS = "0123456789abcdef";
607     uint8 private constant _ADDRESS_LENGTH = 20;
608 
609     /**
610      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
611      */
612     function toString(uint256 value) internal pure returns (string memory) {
613         unchecked {
614             uint256 length = Math.log10(value) + 1;
615             string memory buffer = new string(length);
616             uint256 ptr;
617             /// @solidity memory-safe-assembly
618             assembly {
619                 ptr := add(buffer, add(32, length))
620             }
621             while (true) {
622                 ptr--;
623                 /// @solidity memory-safe-assembly
624                 assembly {
625                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
626                 }
627                 value /= 10;
628                 if (value == 0) break;
629             }
630             return buffer;
631         }
632     }
633 
634     /**
635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
636      */
637     function toHexString(uint256 value) internal pure returns (string memory) {
638         unchecked {
639             return toHexString(value, Math.log256(value) + 1);
640         }
641     }
642 
643     /**
644      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
645      */
646     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
647         bytes memory buffer = new bytes(2 * length + 2);
648         buffer[0] = "0";
649         buffer[1] = "x";
650         for (uint256 i = 2 * length + 1; i > 1; --i) {
651             buffer[i] = _SYMBOLS[value & 0xf];
652             value >>= 4;
653         }
654         require(value == 0, "Strings: hex length insufficient");
655         return string(buffer);
656     }
657 
658     /**
659      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
660      */
661     function toHexString(address addr) internal pure returns (string memory) {
662         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
663     }
664 }
665 
666 
667 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
668 
669 
670 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
671 
672 pragma solidity ^0.8.1;
673 
674 /**
675  * @dev Collection of functions related to the address type
676  */
677 library Address {
678     /**
679      * @dev Returns true if `account` is a contract.
680      *
681      * [IMPORTANT]
682      * ====
683      * It is unsafe to assume that an address for which this function returns
684      * false is an externally-owned account (EOA) and not a contract.
685      *
686      * Among others, `isContract` will return false for the following
687      * types of addresses:
688      *
689      *  - an externally-owned account
690      *  - a contract in construction
691      *  - an address where a contract will be created
692      *  - an address where a contract lived, but was destroyed
693      * ====
694      *
695      * [IMPORTANT]
696      * ====
697      * You shouldn't rely on `isContract` to protect against flash loan attacks!
698      *
699      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
700      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
701      * constructor.
702      * ====
703      */
704     function isContract(address account) internal view returns (bool) {
705         // This method relies on extcodesize/address.code.length, which returns 0
706         // for contracts in construction, since the code is only stored at the end
707         // of the constructor execution.
708 
709         return account.code.length > 0;
710     }
711 
712     /**
713      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
714      * `recipient`, forwarding all available gas and reverting on errors.
715      *
716      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
717      * of certain opcodes, possibly making contracts go over the 2300 gas limit
718      * imposed by `transfer`, making them unable to receive funds via
719      * `transfer`. {sendValue} removes this limitation.
720      *
721      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
722      *
723      * IMPORTANT: because control is transferred to `recipient`, care must be
724      * taken to not create reentrancy vulnerabilities. Consider using
725      * {ReentrancyGuard} or the
726      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
727      */
728     function sendValue(address payable recipient, uint256 amount) internal {
729         require(address(this).balance >= amount, "Address: insufficient balance");
730 
731         (bool success, ) = recipient.call{value: amount}("");
732         require(success, "Address: unable to send value, recipient may have reverted");
733     }
734 
735     /**
736      * @dev Performs a Solidity function call using a low level `call`. A
737      * plain `call` is an unsafe replacement for a function call: use this
738      * function instead.
739      *
740      * If `target` reverts with a revert reason, it is bubbled up by this
741      * function (like regular Solidity function calls).
742      *
743      * Returns the raw returned data. To convert to the expected return value,
744      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
745      *
746      * Requirements:
747      *
748      * - `target` must be a contract.
749      * - calling `target` with `data` must not revert.
750      *
751      * _Available since v3.1._
752      */
753     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
754         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
759      * `errorMessage` as a fallback revert reason when `target` reverts.
760      *
761      * _Available since v3.1._
762      */
763     function functionCall(
764         address target,
765         bytes memory data,
766         string memory errorMessage
767     ) internal returns (bytes memory) {
768         return functionCallWithValue(target, data, 0, errorMessage);
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
773      * but also transferring `value` wei to `target`.
774      *
775      * Requirements:
776      *
777      * - the calling contract must have an ETH balance of at least `value`.
778      * - the called Solidity function must be `payable`.
779      *
780      * _Available since v3.1._
781      */
782     function functionCallWithValue(
783         address target,
784         bytes memory data,
785         uint256 value
786     ) internal returns (bytes memory) {
787         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
792      * with `errorMessage` as a fallback revert reason when `target` reverts.
793      *
794      * _Available since v3.1._
795      */
796     function functionCallWithValue(
797         address target,
798         bytes memory data,
799         uint256 value,
800         string memory errorMessage
801     ) internal returns (bytes memory) {
802         require(address(this).balance >= value, "Address: insufficient balance for call");
803         (bool success, bytes memory returndata) = target.call{value: value}(data);
804         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
809      * but performing a static call.
810      *
811      * _Available since v3.3._
812      */
813     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
814         return functionStaticCall(target, data, "Address: low-level static call failed");
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
819      * but performing a static call.
820      *
821      * _Available since v3.3._
822      */
823     function functionStaticCall(
824         address target,
825         bytes memory data,
826         string memory errorMessage
827     ) internal view returns (bytes memory) {
828         (bool success, bytes memory returndata) = target.staticcall(data);
829         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
834      * but performing a delegate call.
835      *
836      * _Available since v3.4._
837      */
838     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
839         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
844      * but performing a delegate call.
845      *
846      * _Available since v3.4._
847      */
848     function functionDelegateCall(
849         address target,
850         bytes memory data,
851         string memory errorMessage
852     ) internal returns (bytes memory) {
853         (bool success, bytes memory returndata) = target.delegatecall(data);
854         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
855     }
856 
857     /**
858      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
859      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
860      *
861      * _Available since v4.8._
862      */
863     function verifyCallResultFromTarget(
864         address target,
865         bool success,
866         bytes memory returndata,
867         string memory errorMessage
868     ) internal view returns (bytes memory) {
869         if (success) {
870             if (returndata.length == 0) {
871                 // only check isContract if the call was successful and the return data is empty
872                 // otherwise we already know that it was a contract
873                 require(isContract(target), "Address: call to non-contract");
874             }
875             return returndata;
876         } else {
877             _revert(returndata, errorMessage);
878         }
879     }
880 
881     /**
882      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
883      * revert reason or using the provided one.
884      *
885      * _Available since v4.3._
886      */
887     function verifyCallResult(
888         bool success,
889         bytes memory returndata,
890         string memory errorMessage
891     ) internal pure returns (bytes memory) {
892         if (success) {
893             return returndata;
894         } else {
895             _revert(returndata, errorMessage);
896         }
897     }
898 
899     function _revert(bytes memory returndata, string memory errorMessage) private pure {
900         // Look for revert reason and bubble it up if present
901         if (returndata.length > 0) {
902             // The easiest way to bubble the revert reason is using memory via assembly
903             /// @solidity memory-safe-assembly
904             assembly {
905                 let returndata_size := mload(returndata)
906                 revert(add(32, returndata), returndata_size)
907             }
908         } else {
909             revert(errorMessage);
910         }
911     }
912 }
913 
914 
915 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Interface of the ERC165 standard, as defined in the
924  * https://eips.ethereum.org/EIPS/eip-165[EIP].
925  *
926  * Implementers can declare support of contract interfaces, which can then be
927  * queried by others ({ERC165Checker}).
928  *
929  * For an implementation, see {ERC165}.
930  */
931 interface IERC165 {
932     /**
933      * @dev Returns true if this contract implements the interface defined by
934      * `interfaceId`. See the corresponding
935      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
936      * to learn more about how these ids are created.
937      *
938      * This function call must use less than 30 000 gas.
939      */
940     function supportsInterface(bytes4 interfaceId) external view returns (bool);
941 }
942 
943 
944 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
945 
946 
947 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
948 
949 pragma solidity ^0.8.0;
950 
951 /**
952  * @dev Implementation of the {IERC165} interface.
953  *
954  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
955  * for the additional interface id that will be supported. For example:
956  *
957  * ```solidity
958  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
959  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
960  * }
961  * ```
962  *
963  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
964  */
965 abstract contract ERC165 is IERC165 {
966     /**
967      * @dev See {IERC165-supportsInterface}.
968      */
969     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
970         return interfaceId == type(IERC165).interfaceId;
971     }
972 }
973 
974 
975 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.0
976 
977 
978 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
979 
980 pragma solidity ^0.8.0;
981 
982 /**
983  * @title ERC721 token receiver interface
984  * @dev Interface for any contract that wants to support safeTransfers
985  * from ERC721 asset contracts.
986  */
987 interface IERC721Receiver {
988     /**
989      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
990      * by `operator` from `from`, this function is called.
991      *
992      * It must return its Solidity selector to confirm the token transfer.
993      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
994      *
995      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
996      */
997     function onERC721Received(
998         address operator,
999         address from,
1000         uint256 tokenId,
1001         bytes calldata data
1002     ) external returns (bytes4);
1003 }
1004 
1005 
1006 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
1007 
1008 
1009 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 /**
1014  * @dev Required interface of an ERC721 compliant contract.
1015  */
1016 interface IERC721 is IERC165 {
1017     /**
1018      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1019      */
1020     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1021 
1022     /**
1023      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1024      */
1025     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1026 
1027     /**
1028      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1029      */
1030     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1031 
1032     /**
1033      * @dev Returns the number of tokens in ``owner``'s account.
1034      */
1035     function balanceOf(address owner) external view returns (uint256 balance);
1036 
1037     /**
1038      * @dev Returns the owner of the `tokenId` token.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      */
1044     function ownerOf(uint256 tokenId) external view returns (address owner);
1045 
1046     /**
1047      * @dev Safely transfers `tokenId` token from `from` to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - `from` cannot be the zero address.
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must exist and be owned by `from`.
1054      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1055      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes calldata data
1064     ) external;
1065 
1066     /**
1067      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1068      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1069      *
1070      * Requirements:
1071      *
1072      * - `from` cannot be the zero address.
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must exist and be owned by `from`.
1075      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1076      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function safeTransferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) external;
1085 
1086     /**
1087      * @dev Transfers `tokenId` token from `from` to `to`.
1088      *
1089      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1090      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1091      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1092      *
1093      * Requirements:
1094      *
1095      * - `from` cannot be the zero address.
1096      * - `to` cannot be the zero address.
1097      * - `tokenId` token must be owned by `from`.
1098      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) external;
1107 
1108     /**
1109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1110      * The approval is cleared when the token is transferred.
1111      *
1112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1113      *
1114      * Requirements:
1115      *
1116      * - The caller must own the token or be an approved operator.
1117      * - `tokenId` must exist.
1118      *
1119      * Emits an {Approval} event.
1120      */
1121     function approve(address to, uint256 tokenId) external;
1122 
1123     /**
1124      * @dev Approve or remove `operator` as an operator for the caller.
1125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1126      *
1127      * Requirements:
1128      *
1129      * - The `operator` cannot be the caller.
1130      *
1131      * Emits an {ApprovalForAll} event.
1132      */
1133     function setApprovalForAll(address operator, bool _approved) external;
1134 
1135     /**
1136      * @dev Returns the account approved for `tokenId` token.
1137      *
1138      * Requirements:
1139      *
1140      * - `tokenId` must exist.
1141      */
1142     function getApproved(uint256 tokenId) external view returns (address operator);
1143 
1144     /**
1145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1146      *
1147      * See {setApprovalForAll}
1148      */
1149     function isApprovedForAll(address owner, address operator) external view returns (bool);
1150 }
1151 
1152 
1153 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.0
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1162  * @dev See https://eips.ethereum.org/EIPS/eip-721
1163  */
1164 interface IERC721Metadata is IERC721 {
1165     /**
1166      * @dev Returns the token collection name.
1167      */
1168     function name() external view returns (string memory);
1169 
1170     /**
1171      * @dev Returns the token collection symbol.
1172      */
1173     function symbol() external view returns (string memory);
1174 
1175     /**
1176      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1177      */
1178     function tokenURI(uint256 tokenId) external view returns (string memory);
1179 }
1180 
1181 
1182 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.0
1183 
1184 
1185 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 
1191 
1192 
1193 
1194 
1195 /**
1196  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1197  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1198  * {ERC721Enumerable}.
1199  */
1200 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1201     using Address for address;
1202     using Strings for uint256;
1203 
1204     // Token name
1205     string private _name;
1206 
1207     // Token symbol
1208     string private _symbol;
1209 
1210     // Mapping from token ID to owner address
1211     mapping(uint256 => address) private _owners;
1212 
1213     // Mapping owner address to token count
1214     mapping(address => uint256) private _balances;
1215 
1216     // Mapping from token ID to approved address
1217     mapping(uint256 => address) private _tokenApprovals;
1218 
1219     // Mapping from owner to operator approvals
1220     mapping(address => mapping(address => bool)) private _operatorApprovals;
1221 
1222     /**
1223      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1224      */
1225     constructor(string memory name_, string memory symbol_) {
1226         _name = name_;
1227         _symbol = symbol_;
1228     }
1229 
1230     /**
1231      * @dev See {IERC165-supportsInterface}.
1232      */
1233     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1234         return
1235             interfaceId == type(IERC721).interfaceId ||
1236             interfaceId == type(IERC721Metadata).interfaceId ||
1237             super.supportsInterface(interfaceId);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-balanceOf}.
1242      */
1243     function balanceOf(address owner) public view virtual override returns (uint256) {
1244         require(owner != address(0), "ERC721: address zero is not a valid owner");
1245         return _balances[owner];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-ownerOf}.
1250      */
1251     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1252         address owner = _ownerOf(tokenId);
1253         require(owner != address(0), "ERC721: invalid token ID");
1254         return owner;
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Metadata-name}.
1259      */
1260     function name() public view virtual override returns (string memory) {
1261         return _name;
1262     }
1263 
1264     /**
1265      * @dev See {IERC721Metadata-symbol}.
1266      */
1267     function symbol() public view virtual override returns (string memory) {
1268         return _symbol;
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Metadata-tokenURI}.
1273      */
1274     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1275         _requireMinted(tokenId);
1276 
1277         string memory baseURI = _baseURI();
1278         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1279     }
1280 
1281     /**
1282      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1283      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1284      * by default, can be overridden in child contracts.
1285      */
1286     function _baseURI() internal view virtual returns (string memory) {
1287         return "";
1288     }
1289 
1290     /**
1291      * @dev See {IERC721-approve}.
1292      */
1293     function approve(address to, uint256 tokenId) public virtual override {
1294         address owner = ERC721.ownerOf(tokenId);
1295         require(to != owner, "ERC721: approval to current owner");
1296 
1297         require(
1298             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1299             "ERC721: approve caller is not token owner or approved for all"
1300         );
1301 
1302         _approve(to, tokenId);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-getApproved}.
1307      */
1308     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1309         _requireMinted(tokenId);
1310 
1311         return _tokenApprovals[tokenId];
1312     }
1313 
1314     /**
1315      * @dev See {IERC721-setApprovalForAll}.
1316      */
1317     function setApprovalForAll(address operator, bool approved) public virtual override {
1318         _setApprovalForAll(_msgSender(), operator, approved);
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-isApprovedForAll}.
1323      */
1324     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1325         return _operatorApprovals[owner][operator];
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-transferFrom}.
1330      */
1331     function transferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) public virtual override {
1336         //solhint-disable-next-line max-line-length
1337         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1338 
1339         _transfer(from, to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-safeTransferFrom}.
1344      */
1345     function safeTransferFrom(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) public virtual override {
1350         safeTransferFrom(from, to, tokenId, "");
1351     }
1352 
1353     /**
1354      * @dev See {IERC721-safeTransferFrom}.
1355      */
1356     function safeTransferFrom(
1357         address from,
1358         address to,
1359         uint256 tokenId,
1360         bytes memory data
1361     ) public virtual override {
1362         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1363         _safeTransfer(from, to, tokenId, data);
1364     }
1365 
1366     /**
1367      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1368      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1369      *
1370      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1371      *
1372      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1373      * implement alternative mechanisms to perform token transfer, such as signature-based.
1374      *
1375      * Requirements:
1376      *
1377      * - `from` cannot be the zero address.
1378      * - `to` cannot be the zero address.
1379      * - `tokenId` token must exist and be owned by `from`.
1380      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1381      *
1382      * Emits a {Transfer} event.
1383      */
1384     function _safeTransfer(
1385         address from,
1386         address to,
1387         uint256 tokenId,
1388         bytes memory data
1389     ) internal virtual {
1390         _transfer(from, to, tokenId);
1391         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1392     }
1393 
1394     /**
1395      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1396      */
1397     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1398         return _owners[tokenId];
1399     }
1400 
1401     /**
1402      * @dev Returns whether `tokenId` exists.
1403      *
1404      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1405      *
1406      * Tokens start existing when they are minted (`_mint`),
1407      * and stop existing when they are burned (`_burn`).
1408      */
1409     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1410         return _ownerOf(tokenId) != address(0);
1411     }
1412 
1413     /**
1414      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1415      *
1416      * Requirements:
1417      *
1418      * - `tokenId` must exist.
1419      */
1420     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1421         address owner = ERC721.ownerOf(tokenId);
1422         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1423     }
1424 
1425     /**
1426      * @dev Safely mints `tokenId` and transfers it to `to`.
1427      *
1428      * Requirements:
1429      *
1430      * - `tokenId` must not exist.
1431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function _safeMint(address to, uint256 tokenId) internal virtual {
1436         _safeMint(to, tokenId, "");
1437     }
1438 
1439     /**
1440      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1441      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1442      */
1443     function _safeMint(
1444         address to,
1445         uint256 tokenId,
1446         bytes memory data
1447     ) internal virtual {
1448         _mint(to, tokenId);
1449         require(
1450             _checkOnERC721Received(address(0), to, tokenId, data),
1451             "ERC721: transfer to non ERC721Receiver implementer"
1452         );
1453     }
1454 
1455     /**
1456      * @dev Mints `tokenId` and transfers it to `to`.
1457      *
1458      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must not exist.
1463      * - `to` cannot be the zero address.
1464      *
1465      * Emits a {Transfer} event.
1466      */
1467     function _mint(address to, uint256 tokenId) internal virtual {
1468         require(to != address(0), "ERC721: mint to the zero address");
1469         require(!_exists(tokenId), "ERC721: token already minted");
1470 
1471         _beforeTokenTransfer(address(0), to, tokenId, 1);
1472 
1473         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1474         require(!_exists(tokenId), "ERC721: token already minted");
1475 
1476         unchecked {
1477             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1478             // Given that tokens are minted one by one, it is impossible in practice that
1479             // this ever happens. Might change if we allow batch minting.
1480             // The ERC fails to describe this case.
1481             _balances[to] += 1;
1482         }
1483 
1484         _owners[tokenId] = to;
1485 
1486         emit Transfer(address(0), to, tokenId);
1487 
1488         _afterTokenTransfer(address(0), to, tokenId, 1);
1489     }
1490 
1491     /**
1492      * @dev Destroys `tokenId`.
1493      * The approval is cleared when the token is burned.
1494      * This is an internal function that does not check if the sender is authorized to operate on the token.
1495      *
1496      * Requirements:
1497      *
1498      * - `tokenId` must exist.
1499      *
1500      * Emits a {Transfer} event.
1501      */
1502     function _burn(uint256 tokenId) internal virtual {
1503         address owner = ERC721.ownerOf(tokenId);
1504 
1505         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1506 
1507         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1508         owner = ERC721.ownerOf(tokenId);
1509 
1510         // Clear approvals
1511         delete _tokenApprovals[tokenId];
1512 
1513         unchecked {
1514             // Cannot overflow, as that would require more tokens to be burned/transferred
1515             // out than the owner initially received through minting and transferring in.
1516             _balances[owner] -= 1;
1517         }
1518         delete _owners[tokenId];
1519 
1520         emit Transfer(owner, address(0), tokenId);
1521 
1522         _afterTokenTransfer(owner, address(0), tokenId, 1);
1523     }
1524 
1525     /**
1526      * @dev Transfers `tokenId` from `from` to `to`.
1527      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1528      *
1529      * Requirements:
1530      *
1531      * - `to` cannot be the zero address.
1532      * - `tokenId` token must be owned by `from`.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _transfer(
1537         address from,
1538         address to,
1539         uint256 tokenId
1540     ) internal virtual {
1541         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1542         require(to != address(0), "ERC721: transfer to the zero address");
1543 
1544         _beforeTokenTransfer(from, to, tokenId, 1);
1545 
1546         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1547         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1548 
1549         // Clear approvals from the previous owner
1550         delete _tokenApprovals[tokenId];
1551 
1552         unchecked {
1553             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1554             // `from`'s balance is the number of token held, which is at least one before the current
1555             // transfer.
1556             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1557             // all 2**256 token ids to be minted, which in practice is impossible.
1558             _balances[from] -= 1;
1559             _balances[to] += 1;
1560         }
1561         _owners[tokenId] = to;
1562 
1563         emit Transfer(from, to, tokenId);
1564 
1565         _afterTokenTransfer(from, to, tokenId, 1);
1566     }
1567 
1568     /**
1569      * @dev Approve `to` to operate on `tokenId`
1570      *
1571      * Emits an {Approval} event.
1572      */
1573     function _approve(address to, uint256 tokenId) internal virtual {
1574         _tokenApprovals[tokenId] = to;
1575         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1576     }
1577 
1578     /**
1579      * @dev Approve `operator` to operate on all of `owner` tokens
1580      *
1581      * Emits an {ApprovalForAll} event.
1582      */
1583     function _setApprovalForAll(
1584         address owner,
1585         address operator,
1586         bool approved
1587     ) internal virtual {
1588         require(owner != operator, "ERC721: approve to caller");
1589         _operatorApprovals[owner][operator] = approved;
1590         emit ApprovalForAll(owner, operator, approved);
1591     }
1592 
1593     /**
1594      * @dev Reverts if the `tokenId` has not been minted yet.
1595      */
1596     function _requireMinted(uint256 tokenId) internal view virtual {
1597         require(_exists(tokenId), "ERC721: invalid token ID");
1598     }
1599 
1600     /**
1601      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1602      * The call is not executed if the target address is not a contract.
1603      *
1604      * @param from address representing the previous owner of the given token ID
1605      * @param to target address that will receive the tokens
1606      * @param tokenId uint256 ID of the token to be transferred
1607      * @param data bytes optional data to send along with the call
1608      * @return bool whether the call correctly returned the expected magic value
1609      */
1610     function _checkOnERC721Received(
1611         address from,
1612         address to,
1613         uint256 tokenId,
1614         bytes memory data
1615     ) private returns (bool) {
1616         if (to.isContract()) {
1617             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1618                 return retval == IERC721Receiver.onERC721Received.selector;
1619             } catch (bytes memory reason) {
1620                 if (reason.length == 0) {
1621                     revert("ERC721: transfer to non ERC721Receiver implementer");
1622                 } else {
1623                     /// @solidity memory-safe-assembly
1624                     assembly {
1625                         revert(add(32, reason), mload(reason))
1626                     }
1627                 }
1628             }
1629         } else {
1630             return true;
1631         }
1632     }
1633 
1634     /**
1635      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1636      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1637      *
1638      * Calling conditions:
1639      *
1640      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1641      * - When `from` is zero, the tokens will be minted for `to`.
1642      * - When `to` is zero, ``from``'s tokens will be burned.
1643      * - `from` and `to` are never both zero.
1644      * - `batchSize` is non-zero.
1645      *
1646      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1647      */
1648     function _beforeTokenTransfer(
1649         address from,
1650         address to,
1651         uint256, /* firstTokenId */
1652         uint256 batchSize
1653     ) internal virtual {
1654         if (batchSize > 1) {
1655             if (from != address(0)) {
1656                 _balances[from] -= batchSize;
1657             }
1658             if (to != address(0)) {
1659                 _balances[to] += batchSize;
1660             }
1661         }
1662     }
1663 
1664     /**
1665      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1666      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1667      *
1668      * Calling conditions:
1669      *
1670      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1671      * - When `from` is zero, the tokens were minted for `to`.
1672      * - When `to` is zero, ``from``'s tokens were burned.
1673      * - `from` and `to` are never both zero.
1674      * - `batchSize` is non-zero.
1675      *
1676      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1677      */
1678     function _afterTokenTransfer(
1679         address from,
1680         address to,
1681         uint256 firstTokenId,
1682         uint256 batchSize
1683     ) internal virtual {}
1684 }
1685 
1686 
1687 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.0
1688 
1689 
1690 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1691 
1692 pragma solidity ^0.8.0;
1693 
1694 /**
1695  * @dev These functions deal with verification of Merkle Tree proofs.
1696  *
1697  * The tree and the proofs can be generated using our
1698  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1699  * You will find a quickstart guide in the readme.
1700  *
1701  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1702  * hashing, or use a hash function other than keccak256 for hashing leaves.
1703  * This is because the concatenation of a sorted pair of internal nodes in
1704  * the merkle tree could be reinterpreted as a leaf value.
1705  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1706  * against this attack out of the box.
1707  */
1708 library MerkleProof {
1709     /**
1710      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1711      * defined by `root`. For this, a `proof` must be provided, containing
1712      * sibling hashes on the branch from the leaf to the root of the tree. Each
1713      * pair of leaves and each pair of pre-images are assumed to be sorted.
1714      */
1715     function verify(
1716         bytes32[] memory proof,
1717         bytes32 root,
1718         bytes32 leaf
1719     ) internal pure returns (bool) {
1720         return processProof(proof, leaf) == root;
1721     }
1722 
1723     /**
1724      * @dev Calldata version of {verify}
1725      *
1726      * _Available since v4.7._
1727      */
1728     function verifyCalldata(
1729         bytes32[] calldata proof,
1730         bytes32 root,
1731         bytes32 leaf
1732     ) internal pure returns (bool) {
1733         return processProofCalldata(proof, leaf) == root;
1734     }
1735 
1736     /**
1737      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1738      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1739      * hash matches the root of the tree. When processing the proof, the pairs
1740      * of leafs & pre-images are assumed to be sorted.
1741      *
1742      * _Available since v4.4._
1743      */
1744     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1745         bytes32 computedHash = leaf;
1746         for (uint256 i = 0; i < proof.length; i++) {
1747             computedHash = _hashPair(computedHash, proof[i]);
1748         }
1749         return computedHash;
1750     }
1751 
1752     /**
1753      * @dev Calldata version of {processProof}
1754      *
1755      * _Available since v4.7._
1756      */
1757     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1758         bytes32 computedHash = leaf;
1759         for (uint256 i = 0; i < proof.length; i++) {
1760             computedHash = _hashPair(computedHash, proof[i]);
1761         }
1762         return computedHash;
1763     }
1764 
1765     /**
1766      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1767      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1768      *
1769      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1770      *
1771      * _Available since v4.7._
1772      */
1773     function multiProofVerify(
1774         bytes32[] memory proof,
1775         bool[] memory proofFlags,
1776         bytes32 root,
1777         bytes32[] memory leaves
1778     ) internal pure returns (bool) {
1779         return processMultiProof(proof, proofFlags, leaves) == root;
1780     }
1781 
1782     /**
1783      * @dev Calldata version of {multiProofVerify}
1784      *
1785      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1786      *
1787      * _Available since v4.7._
1788      */
1789     function multiProofVerifyCalldata(
1790         bytes32[] calldata proof,
1791         bool[] calldata proofFlags,
1792         bytes32 root,
1793         bytes32[] memory leaves
1794     ) internal pure returns (bool) {
1795         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1796     }
1797 
1798     /**
1799      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1800      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1801      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1802      * respectively.
1803      *
1804      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1805      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1806      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1807      *
1808      * _Available since v4.7._
1809      */
1810     function processMultiProof(
1811         bytes32[] memory proof,
1812         bool[] memory proofFlags,
1813         bytes32[] memory leaves
1814     ) internal pure returns (bytes32 merkleRoot) {
1815         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1816         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1817         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1818         // the merkle tree.
1819         uint256 leavesLen = leaves.length;
1820         uint256 totalHashes = proofFlags.length;
1821 
1822         // Check proof validity.
1823         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1824 
1825         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1826         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1827         bytes32[] memory hashes = new bytes32[](totalHashes);
1828         uint256 leafPos = 0;
1829         uint256 hashPos = 0;
1830         uint256 proofPos = 0;
1831         // At each step, we compute the next hash using two values:
1832         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1833         //   get the next hash.
1834         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1835         //   `proof` array.
1836         for (uint256 i = 0; i < totalHashes; i++) {
1837             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1838             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1839             hashes[i] = _hashPair(a, b);
1840         }
1841 
1842         if (totalHashes > 0) {
1843             return hashes[totalHashes - 1];
1844         } else if (leavesLen > 0) {
1845             return leaves[0];
1846         } else {
1847             return proof[0];
1848         }
1849     }
1850 
1851     /**
1852      * @dev Calldata version of {processMultiProof}.
1853      *
1854      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1855      *
1856      * _Available since v4.7._
1857      */
1858     function processMultiProofCalldata(
1859         bytes32[] calldata proof,
1860         bool[] calldata proofFlags,
1861         bytes32[] memory leaves
1862     ) internal pure returns (bytes32 merkleRoot) {
1863         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1864         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1865         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1866         // the merkle tree.
1867         uint256 leavesLen = leaves.length;
1868         uint256 totalHashes = proofFlags.length;
1869 
1870         // Check proof validity.
1871         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1872 
1873         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1874         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1875         bytes32[] memory hashes = new bytes32[](totalHashes);
1876         uint256 leafPos = 0;
1877         uint256 hashPos = 0;
1878         uint256 proofPos = 0;
1879         // At each step, we compute the next hash using two values:
1880         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1881         //   get the next hash.
1882         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1883         //   `proof` array.
1884         for (uint256 i = 0; i < totalHashes; i++) {
1885             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1886             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1887             hashes[i] = _hashPair(a, b);
1888         }
1889 
1890         if (totalHashes > 0) {
1891             return hashes[totalHashes - 1];
1892         } else if (leavesLen > 0) {
1893             return leaves[0];
1894         } else {
1895             return proof[0];
1896         }
1897     }
1898 
1899     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1900         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1901     }
1902 
1903     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1904         /// @solidity memory-safe-assembly
1905         assembly {
1906             mstore(0x00, a)
1907             mstore(0x20, b)
1908             value := keccak256(0x00, 0x40)
1909         }
1910     }
1911 }
1912 
1913 
1914 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.0
1915 
1916 
1917 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1918 
1919 pragma solidity ^0.8.0;
1920 
1921 /**
1922  * @dev Interface for the NFT Royalty Standard.
1923  *
1924  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1925  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1926  *
1927  * _Available since v4.5._
1928  */
1929 interface IERC2981 is IERC165 {
1930     /**
1931      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1932      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1933      */
1934     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1935         external
1936         view
1937         returns (address receiver, uint256 royaltyAmount);
1938 }
1939 
1940 
1941 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.0
1942 
1943 
1944 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1945 
1946 pragma solidity ^0.8.0;
1947 
1948 
1949 /**
1950  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1951  *
1952  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1953  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1954  *
1955  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1956  * fee is specified in basis points by default.
1957  *
1958  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1959  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1960  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1961  *
1962  * _Available since v4.5._
1963  */
1964 abstract contract ERC2981 is IERC2981, ERC165 {
1965     struct RoyaltyInfo {
1966         address receiver;
1967         uint96 royaltyFraction;
1968     }
1969 
1970     RoyaltyInfo private _defaultRoyaltyInfo;
1971     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1972 
1973     /**
1974      * @dev See {IERC165-supportsInterface}.
1975      */
1976     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1977         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1978     }
1979 
1980     /**
1981      * @inheritdoc IERC2981
1982      */
1983     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1984         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1985 
1986         if (royalty.receiver == address(0)) {
1987             royalty = _defaultRoyaltyInfo;
1988         }
1989 
1990         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1991 
1992         return (royalty.receiver, royaltyAmount);
1993     }
1994 
1995     /**
1996      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1997      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1998      * override.
1999      */
2000     function _feeDenominator() internal pure virtual returns (uint96) {
2001         return 10000;
2002     }
2003 
2004     /**
2005      * @dev Sets the royalty information that all ids in this contract will default to.
2006      *
2007      * Requirements:
2008      *
2009      * - `receiver` cannot be the zero address.
2010      * - `feeNumerator` cannot be greater than the fee denominator.
2011      */
2012     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2013         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2014         require(receiver != address(0), "ERC2981: invalid receiver");
2015 
2016         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2017     }
2018 
2019     /**
2020      * @dev Removes default royalty information.
2021      */
2022     function _deleteDefaultRoyalty() internal virtual {
2023         delete _defaultRoyaltyInfo;
2024     }
2025 
2026     /**
2027      * @dev Sets the royalty information for a specific token id, overriding the global default.
2028      *
2029      * Requirements:
2030      *
2031      * - `receiver` cannot be the zero address.
2032      * - `feeNumerator` cannot be greater than the fee denominator.
2033      */
2034     function _setTokenRoyalty(
2035         uint256 tokenId,
2036         address receiver,
2037         uint96 feeNumerator
2038     ) internal virtual {
2039         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2040         require(receiver != address(0), "ERC2981: Invalid parameters");
2041 
2042         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2043     }
2044 
2045     /**
2046      * @dev Resets royalty information for the token id back to the global default.
2047      */
2048     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2049         delete _tokenRoyaltyInfo[tokenId];
2050     }
2051 }
2052 
2053 
2054 // File contracts/kongu.sol
2055 
2056 //SPDX-License-Identifier: MIT
2057 pragma solidity ^0.8.11;
2058 
2059 
2060 
2061 
2062 
2063 
2064 error InsufficientEth();
2065 error MaxSupplyReached();
2066 error WalletMintLimitReached();
2067 error NotAuthorized();
2068 
2069 contract Kongu is ERC721,ERC2981, Ownable, OperatorFilterer {
2070     
2071     using Strings for uint256;
2072 
2073     enum Phase{
2074         NONE,
2075         WHITELIST,
2076         WAITLIST,
2077         PUBLIC
2078     }
2079 
2080     Phase public mintingPhase;
2081 
2082     string public baseURI;
2083     string public metadataExtension = ".json";
2084 
2085     uint256 public totalSupply;
2086     uint256 constant public maxSupply = 350;
2087     uint256 constant public price = 0.25 ether;
2088 
2089     bool public operatorFilteringEnabled;
2090 
2091     bytes32 public wlMerkle = 0xac9ea287e28a6b9a01e90b4b5002798329590ddedf39dafb45e1bdd0526b10f3;
2092     bytes32 public waitlistMerkle = 0xedbec8cf8100be3c76e6cb642a053df985ea0f5b9b164254886487e7afbbeddb;
2093 
2094     mapping(address => uint8) public minted;
2095 
2096     constructor(string memory _metadata) ERC721("Kongu", "KONGU") {
2097         setBaseURI(_metadata);
2098         _registerForOperatorFiltering();
2099         operatorFilteringEnabled = true;
2100 
2101         // Set royalty receiver to the contract creator,
2102         _setDefaultRoyalty(msg.sender, 750);
2103     }
2104 
2105     modifier onlySender() {
2106         require(msg.sender == tx.origin);
2107         _;
2108     }
2109 
2110     modifier WLPhaseOpen() {
2111         require(mintingPhase == Phase.WHITELIST);
2112         _;
2113     }
2114 
2115     modifier WaitListPhaseOpen() {
2116         require(mintingPhase == Phase.WAITLIST);
2117         _;
2118     }
2119 
2120     modifier PublicPhaseOpen() {
2121         require(mintingPhase == Phase.PUBLIC);
2122         _;
2123     }
2124 
2125     function whitelistMint(bytes32[] calldata _merkleProof) public payable onlySender WLPhaseOpen
2126     {
2127         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2128 
2129         if (!MerkleProof.verify(_merkleProof, wlMerkle, leaf)) revert NotAuthorized();
2130         if(msg.value < price) revert InsufficientEth();
2131         if(minted[msg.sender] & 1 != 0) revert WalletMintLimitReached();
2132         if(totalSupply + 1 > maxSupply) revert MaxSupplyReached();
2133 
2134         minted[msg.sender] = minted[msg.sender] | 1;
2135         totalSupply++;
2136         _mint(msg.sender, totalSupply);
2137     }
2138 
2139     function waitlistMint(bytes32[] calldata _merkleProof) public payable onlySender WaitListPhaseOpen
2140     {
2141         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2142 
2143         if (!MerkleProof.verify(_merkleProof, waitlistMerkle, leaf)) revert NotAuthorized();
2144         if(msg.value < price) revert InsufficientEth();
2145         if(minted[msg.sender] & 2 != 0) revert WalletMintLimitReached();
2146         if(totalSupply + 1 > maxSupply) revert MaxSupplyReached();
2147 
2148         minted[msg.sender] = minted[msg.sender] | 1;
2149         totalSupply++;
2150         _mint(msg.sender, totalSupply);
2151     }
2152 
2153     function publicMint() public payable onlySender PublicPhaseOpen
2154     {
2155         if(msg.value < price) revert InsufficientEth();
2156         if(minted[msg.sender] >= 2) revert WalletMintLimitReached();
2157         if(totalSupply + 1 > maxSupply) revert MaxSupplyReached();
2158 
2159         minted[msg.sender] = minted[msg.sender] | 2;
2160         totalSupply++;
2161         _mint(msg.sender, totalSupply);
2162     }
2163 
2164     function founderReserveMint(address vaultAddress) public onlySender onlyOwner
2165     {
2166         for(int256 i=0; i<5; ++i)
2167         {
2168             totalSupply++;
2169             _mint(vaultAddress, totalSupply);
2170         }
2171     }
2172 
2173     function endSale() external onlyOwner
2174     {
2175         mintingPhase = Phase.NONE;
2176     }
2177     function openWhiteList() external onlyOwner
2178     {
2179         mintingPhase = Phase.WHITELIST;
2180     }
2181     function openWaitList() external onlyOwner
2182     {
2183         mintingPhase = Phase.WAITLIST;
2184     }
2185     function openPublic() external onlyOwner
2186     {
2187         mintingPhase = Phase.PUBLIC;
2188     }
2189 
2190     function changeWLMerkle(bytes32 _wlMerkle) external onlyOwner
2191     {
2192         wlMerkle = _wlMerkle;
2193     }
2194 
2195     function changeWaitListMerkle(bytes32 _waitListMerkle) external onlyOwner
2196     {
2197         waitlistMerkle = _waitListMerkle;
2198     }
2199     
2200     function withdrawEther(address to) external onlyOwner {
2201         uint256 balance = address(this).balance;
2202         if (balance == 0) revert InsufficientEth();
2203         (bool callSuccess, ) = payable(to).call{value: balance}("");
2204         require(callSuccess, "Withdraw failed");
2205     }
2206 
2207     function _baseURI() internal view virtual override returns (string memory) {
2208         return baseURI;
2209     }
2210 
2211     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2212         baseURI = _newBaseURI;
2213     }
2214 
2215     function tokenURI(uint256 tokenId)
2216         public
2217         view
2218         virtual
2219         override
2220         returns (string memory)
2221     {
2222         require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2223         string memory currentBaseURI = _baseURI();
2224         return bytes(currentBaseURI).length > 0 ? string( abi.encodePacked(currentBaseURI, tokenId.toString(), metadataExtension )): "";
2225     }
2226 
2227     function setApprovalForAll(address operator, bool approved)
2228         public
2229         override
2230         onlyAllowedOperatorApproval(operator)
2231     {
2232         super.setApprovalForAll(operator, approved);
2233     }
2234 
2235     function approve(address operator, uint256 tokenId)
2236         public
2237         override
2238         onlyAllowedOperatorApproval(operator)
2239     {
2240         super.approve(operator, tokenId);
2241     }
2242 
2243     function transferFrom(address from, address to, uint256 tokenId)
2244         public
2245         override
2246         onlyAllowedOperator(from)
2247     {
2248         super.transferFrom(from, to, tokenId);
2249     }
2250 
2251     function safeTransferFrom(address from, address to, uint256 tokenId)
2252         public
2253         override
2254         onlyAllowedOperator(from)
2255     {
2256         super.safeTransferFrom(from, to, tokenId);
2257     }
2258 
2259     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2260         public
2261         override
2262         onlyAllowedOperator(from)
2263     {
2264         super.safeTransferFrom(from, to, tokenId, data);
2265     }
2266 
2267     function supportsInterface(bytes4 interfaceId)
2268         public
2269         view
2270         virtual
2271         override (ERC721, ERC2981)
2272         returns (bool)
2273     {
2274         // Supports the following `interfaceId`s:
2275         // - IERC165: 0x01ffc9a7
2276         // - IERC721: 0x80ac58cd
2277         // - IERC721Metadata: 0x5b5e139f
2278         // - IERC2981: 0x2a55205a
2279         return ERC721.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2280     }
2281 
2282     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
2283         _setDefaultRoyalty(receiver, feeNumerator);
2284     }
2285 
2286     function setOperatorFilteringEnabled(bool value) public onlyOwner {
2287         operatorFilteringEnabled = value;
2288     }
2289 
2290     function _operatorFilteringEnabled() internal view override returns (bool) {
2291         return operatorFilteringEnabled;
2292     }
2293 
2294     function _isPriorityOperator(address operator) internal pure override returns (bool) {
2295         // OpenSea Seaport Conduit:
2296         return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
2297     }
2298 }