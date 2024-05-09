1 // File: IOperatorFilterRegistry.sol
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
33 // File: OperatorFilterer.sol
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
71         // Check registry code length to facilitate testing in environments without a deployed registry.
72         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
73             // Allow spending tokens from addresses with balance
74             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75             // from an EOA.
76             if (from == msg.sender) {
77                 _;
78                 return;
79             }
80             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94         _;
95     }
96 }
97 
98 // File: DefaultOperatorFilterer.sol
99 
100 
101 pragma solidity ^0.8.13;
102 
103 
104 /**
105  * @title  DefaultOperatorFilterer
106  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
107  */
108 abstract contract DefaultOperatorFilterer is OperatorFilterer {
109     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
110 
111     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
112 }
113 
114 // File: @openzeppelin/contracts/utils/math/Math.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Standard math utilities missing in the Solidity language.
123  */
124 library Math {
125     enum Rounding {
126         Down, // Toward negative infinity
127         Up, // Toward infinity
128         Zero // Toward zero
129     }
130 
131     /**
132      * @dev Returns the largest of two numbers.
133      */
134     function max(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a > b ? a : b;
136     }
137 
138     /**
139      * @dev Returns the smallest of two numbers.
140      */
141     function min(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a < b ? a : b;
143     }
144 
145     /**
146      * @dev Returns the average of two numbers. The result is rounded towards
147      * zero.
148      */
149     function average(uint256 a, uint256 b) internal pure returns (uint256) {
150         // (a + b) / 2 can overflow.
151         return (a & b) + (a ^ b) / 2;
152     }
153 
154     /**
155      * @dev Returns the ceiling of the division of two numbers.
156      *
157      * This differs from standard division with `/` in that it rounds up instead
158      * of rounding down.
159      */
160     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
161         // (a + b - 1) / b can overflow on addition, so we distribute.
162         return a == 0 ? 0 : (a - 1) / b + 1;
163     }
164 
165     /**
166      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
167      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
168      * with further edits by Uniswap Labs also under MIT license.
169      */
170     function mulDiv(
171         uint256 x,
172         uint256 y,
173         uint256 denominator
174     ) internal pure returns (uint256 result) {
175         unchecked {
176             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
177             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
178             // variables such that product = prod1 * 2^256 + prod0.
179             uint256 prod0; // Least significant 256 bits of the product
180             uint256 prod1; // Most significant 256 bits of the product
181             assembly {
182                 let mm := mulmod(x, y, not(0))
183                 prod0 := mul(x, y)
184                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
185             }
186 
187             // Handle non-overflow cases, 256 by 256 division.
188             if (prod1 == 0) {
189                 return prod0 / denominator;
190             }
191 
192             // Make sure the result is less than 2^256. Also prevents denominator == 0.
193             require(denominator > prod1);
194 
195             ///////////////////////////////////////////////
196             // 512 by 256 division.
197             ///////////////////////////////////////////////
198 
199             // Make division exact by subtracting the remainder from [prod1 prod0].
200             uint256 remainder;
201             assembly {
202                 // Compute remainder using mulmod.
203                 remainder := mulmod(x, y, denominator)
204 
205                 // Subtract 256 bit number from 512 bit number.
206                 prod1 := sub(prod1, gt(remainder, prod0))
207                 prod0 := sub(prod0, remainder)
208             }
209 
210             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
211             // See https://cs.stackexchange.com/q/138556/92363.
212 
213             // Does not overflow because the denominator cannot be zero at this stage in the function.
214             uint256 twos = denominator & (~denominator + 1);
215             assembly {
216                 // Divide denominator by twos.
217                 denominator := div(denominator, twos)
218 
219                 // Divide [prod1 prod0] by twos.
220                 prod0 := div(prod0, twos)
221 
222                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
223                 twos := add(div(sub(0, twos), twos), 1)
224             }
225 
226             // Shift in bits from prod1 into prod0.
227             prod0 |= prod1 * twos;
228 
229             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
230             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
231             // four bits. That is, denominator * inv = 1 mod 2^4.
232             uint256 inverse = (3 * denominator) ^ 2;
233 
234             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
235             // in modular arithmetic, doubling the correct bits in each step.
236             inverse *= 2 - denominator * inverse; // inverse mod 2^8
237             inverse *= 2 - denominator * inverse; // inverse mod 2^16
238             inverse *= 2 - denominator * inverse; // inverse mod 2^32
239             inverse *= 2 - denominator * inverse; // inverse mod 2^64
240             inverse *= 2 - denominator * inverse; // inverse mod 2^128
241             inverse *= 2 - denominator * inverse; // inverse mod 2^256
242 
243             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
244             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
245             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
246             // is no longer required.
247             result = prod0 * inverse;
248             return result;
249         }
250     }
251 
252     /**
253      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
254      */
255     function mulDiv(
256         uint256 x,
257         uint256 y,
258         uint256 denominator,
259         Rounding rounding
260     ) internal pure returns (uint256) {
261         uint256 result = mulDiv(x, y, denominator);
262         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
263             result += 1;
264         }
265         return result;
266     }
267 
268     /**
269      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
270      *
271      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
272      */
273     function sqrt(uint256 a) internal pure returns (uint256) {
274         if (a == 0) {
275             return 0;
276         }
277 
278         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
279         //
280         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
281         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
282         //
283         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
284         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
285         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
286         //
287         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
288         uint256 result = 1 << (log2(a) >> 1);
289 
290         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
291         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
292         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
293         // into the expected uint128 result.
294         unchecked {
295             result = (result + a / result) >> 1;
296             result = (result + a / result) >> 1;
297             result = (result + a / result) >> 1;
298             result = (result + a / result) >> 1;
299             result = (result + a / result) >> 1;
300             result = (result + a / result) >> 1;
301             result = (result + a / result) >> 1;
302             return min(result, a / result);
303         }
304     }
305 
306     /**
307      * @notice Calculates sqrt(a), following the selected rounding direction.
308      */
309     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
310         unchecked {
311             uint256 result = sqrt(a);
312             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
313         }
314     }
315 
316     /**
317      * @dev Return the log in base 2, rounded down, of a positive value.
318      * Returns 0 if given 0.
319      */
320     function log2(uint256 value) internal pure returns (uint256) {
321         uint256 result = 0;
322         unchecked {
323             if (value >> 128 > 0) {
324                 value >>= 128;
325                 result += 128;
326             }
327             if (value >> 64 > 0) {
328                 value >>= 64;
329                 result += 64;
330             }
331             if (value >> 32 > 0) {
332                 value >>= 32;
333                 result += 32;
334             }
335             if (value >> 16 > 0) {
336                 value >>= 16;
337                 result += 16;
338             }
339             if (value >> 8 > 0) {
340                 value >>= 8;
341                 result += 8;
342             }
343             if (value >> 4 > 0) {
344                 value >>= 4;
345                 result += 4;
346             }
347             if (value >> 2 > 0) {
348                 value >>= 2;
349                 result += 2;
350             }
351             if (value >> 1 > 0) {
352                 result += 1;
353             }
354         }
355         return result;
356     }
357 
358     /**
359      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
360      * Returns 0 if given 0.
361      */
362     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
363         unchecked {
364             uint256 result = log2(value);
365             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
366         }
367     }
368 
369     /**
370      * @dev Return the log in base 10, rounded down, of a positive value.
371      * Returns 0 if given 0.
372      */
373     function log10(uint256 value) internal pure returns (uint256) {
374         uint256 result = 0;
375         unchecked {
376             if (value >= 10**64) {
377                 value /= 10**64;
378                 result += 64;
379             }
380             if (value >= 10**32) {
381                 value /= 10**32;
382                 result += 32;
383             }
384             if (value >= 10**16) {
385                 value /= 10**16;
386                 result += 16;
387             }
388             if (value >= 10**8) {
389                 value /= 10**8;
390                 result += 8;
391             }
392             if (value >= 10**4) {
393                 value /= 10**4;
394                 result += 4;
395             }
396             if (value >= 10**2) {
397                 value /= 10**2;
398                 result += 2;
399             }
400             if (value >= 10**1) {
401                 result += 1;
402             }
403         }
404         return result;
405     }
406 
407     /**
408      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
409      * Returns 0 if given 0.
410      */
411     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
412         unchecked {
413             uint256 result = log10(value);
414             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
415         }
416     }
417 
418     /**
419      * @dev Return the log in base 256, rounded down, of a positive value.
420      * Returns 0 if given 0.
421      *
422      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
423      */
424     function log256(uint256 value) internal pure returns (uint256) {
425         uint256 result = 0;
426         unchecked {
427             if (value >> 128 > 0) {
428                 value >>= 128;
429                 result += 16;
430             }
431             if (value >> 64 > 0) {
432                 value >>= 64;
433                 result += 8;
434             }
435             if (value >> 32 > 0) {
436                 value >>= 32;
437                 result += 4;
438             }
439             if (value >> 16 > 0) {
440                 value >>= 16;
441                 result += 2;
442             }
443             if (value >> 8 > 0) {
444                 result += 1;
445             }
446         }
447         return result;
448     }
449 
450     /**
451      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
452      * Returns 0 if given 0.
453      */
454     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
455         unchecked {
456             uint256 result = log256(value);
457             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
458         }
459     }
460 }
461 
462 // File: @openzeppelin/contracts/utils/Strings.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev String operations.
472  */
473 library Strings {
474     bytes16 private constant _SYMBOLS = "0123456789abcdef";
475     uint8 private constant _ADDRESS_LENGTH = 20;
476 
477     /**
478      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
479      */
480     function toString(uint256 value) internal pure returns (string memory) {
481         unchecked {
482             uint256 length = Math.log10(value) + 1;
483             string memory buffer = new string(length);
484             uint256 ptr;
485             /// @solidity memory-safe-assembly
486             assembly {
487                 ptr := add(buffer, add(32, length))
488             }
489             while (true) {
490                 ptr--;
491                 /// @solidity memory-safe-assembly
492                 assembly {
493                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
494                 }
495                 value /= 10;
496                 if (value == 0) break;
497             }
498             return buffer;
499         }
500     }
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
504      */
505     function toHexString(uint256 value) internal pure returns (string memory) {
506         unchecked {
507             return toHexString(value, Math.log256(value) + 1);
508         }
509     }
510 
511     /**
512      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
513      */
514     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
515         bytes memory buffer = new bytes(2 * length + 2);
516         buffer[0] = "0";
517         buffer[1] = "x";
518         for (uint256 i = 2 * length + 1; i > 1; --i) {
519             buffer[i] = _SYMBOLS[value & 0xf];
520             value >>= 4;
521         }
522         require(value == 0, "Strings: hex length insufficient");
523         return string(buffer);
524     }
525 
526     /**
527      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
528      */
529     function toHexString(address addr) internal pure returns (string memory) {
530         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
531     }
532 }
533 
534 // File: @openzeppelin/contracts/utils/Context.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Provides information about the current execution context, including the
543  * sender of the transaction and its data. While these are generally available
544  * via msg.sender and msg.data, they should not be accessed in such a direct
545  * manner, since when dealing with meta-transactions the account sending and
546  * paying for execution may not be the actual sender (as far as an application
547  * is concerned).
548  *
549  * This contract is only required for intermediate, library-like contracts.
550  */
551 abstract contract Context {
552     function _msgSender() internal view virtual returns (address) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes calldata) {
557         return msg.data;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/access/Ownable.sol
562 
563 
564 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @dev Contract module which provides a basic access control mechanism, where
571  * there is an account (an owner) that can be granted exclusive access to
572  * specific functions.
573  *
574  * By default, the owner account will be the one that deploys the contract. This
575  * can later be changed with {transferOwnership}.
576  *
577  * This module is used through inheritance. It will make available the modifier
578  * `onlyOwner`, which can be applied to your functions to restrict their use to
579  * the owner.
580  */
581 abstract contract Ownable is Context {
582     address private _owner;
583 
584     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586     /**
587      * @dev Initializes the contract setting the deployer as the initial owner.
588      */
589     constructor() {
590         _transferOwnership(_msgSender());
591     }
592 
593     /**
594      * @dev Throws if called by any account other than the owner.
595      */
596     modifier onlyOwner() {
597         _checkOwner();
598         _;
599     }
600 
601     /**
602      * @dev Returns the address of the current owner.
603      */
604     function owner() public view virtual returns (address) {
605         return _owner;
606     }
607 
608     /**
609      * @dev Throws if the sender is not the owner.
610      */
611     function _checkOwner() internal view virtual {
612         require(owner() == _msgSender(), "Ownable: caller is not the owner");
613     }
614 
615     /**
616      * @dev Leaves the contract without owner. It will not be possible to call
617      * `onlyOwner` functions anymore. Can only be called by the current owner.
618      *
619      * NOTE: Renouncing ownership will leave the contract without an owner,
620      * thereby removing any functionality that is only available to the owner.
621      */
622     function renounceOwnership() public virtual onlyOwner {
623         _transferOwnership(address(0));
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      * Can only be called by the current owner.
629      */
630     function transferOwnership(address newOwner) public virtual onlyOwner {
631         require(newOwner != address(0), "Ownable: new owner is the zero address");
632         _transferOwnership(newOwner);
633     }
634 
635     /**
636      * @dev Transfers ownership of the contract to a new account (`newOwner`).
637      * Internal function without access restriction.
638      */
639     function _transferOwnership(address newOwner) internal virtual {
640         address oldOwner = _owner;
641         _owner = newOwner;
642         emit OwnershipTransferred(oldOwner, newOwner);
643     }
644 }
645 
646 // File: @openzeppelin/contracts/utils/Address.sol
647 
648 
649 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
650 
651 pragma solidity ^0.8.1;
652 
653 /**
654  * @dev Collection of functions related to the address type
655  */
656 library Address {
657     /**
658      * @dev Returns true if `account` is a contract.
659      *
660      * [IMPORTANT]
661      * ====
662      * It is unsafe to assume that an address for which this function returns
663      * false is an externally-owned account (EOA) and not a contract.
664      *
665      * Among others, `isContract` will return false for the following
666      * types of addresses:
667      *
668      *  - an externally-owned account
669      *  - a contract in construction
670      *  - an address where a contract will be created
671      *  - an address where a contract lived, but was destroyed
672      * ====
673      *
674      * [IMPORTANT]
675      * ====
676      * You shouldn't rely on `isContract` to protect against flash loan attacks!
677      *
678      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
679      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
680      * constructor.
681      * ====
682      */
683     function isContract(address account) internal view returns (bool) {
684         // This method relies on extcodesize/address.code.length, which returns 0
685         // for contracts in construction, since the code is only stored at the end
686         // of the constructor execution.
687 
688         return account.code.length > 0;
689     }
690 
691     /**
692      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
693      * `recipient`, forwarding all available gas and reverting on errors.
694      *
695      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
696      * of certain opcodes, possibly making contracts go over the 2300 gas limit
697      * imposed by `transfer`, making them unable to receive funds via
698      * `transfer`. {sendValue} removes this limitation.
699      *
700      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
701      *
702      * IMPORTANT: because control is transferred to `recipient`, care must be
703      * taken to not create reentrancy vulnerabilities. Consider using
704      * {ReentrancyGuard} or the
705      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
706      */
707     function sendValue(address payable recipient, uint256 amount) internal {
708         require(address(this).balance >= amount, "Address: insufficient balance");
709 
710         (bool success, ) = recipient.call{value: amount}("");
711         require(success, "Address: unable to send value, recipient may have reverted");
712     }
713 
714     /**
715      * @dev Performs a Solidity function call using a low level `call`. A
716      * plain `call` is an unsafe replacement for a function call: use this
717      * function instead.
718      *
719      * If `target` reverts with a revert reason, it is bubbled up by this
720      * function (like regular Solidity function calls).
721      *
722      * Returns the raw returned data. To convert to the expected return value,
723      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
724      *
725      * Requirements:
726      *
727      * - `target` must be a contract.
728      * - calling `target` with `data` must not revert.
729      *
730      * _Available since v3.1._
731      */
732     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
733         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
738      * `errorMessage` as a fallback revert reason when `target` reverts.
739      *
740      * _Available since v3.1._
741      */
742     function functionCall(
743         address target,
744         bytes memory data,
745         string memory errorMessage
746     ) internal returns (bytes memory) {
747         return functionCallWithValue(target, data, 0, errorMessage);
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
752      * but also transferring `value` wei to `target`.
753      *
754      * Requirements:
755      *
756      * - the calling contract must have an ETH balance of at least `value`.
757      * - the called Solidity function must be `payable`.
758      *
759      * _Available since v3.1._
760      */
761     function functionCallWithValue(
762         address target,
763         bytes memory data,
764         uint256 value
765     ) internal returns (bytes memory) {
766         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
771      * with `errorMessage` as a fallback revert reason when `target` reverts.
772      *
773      * _Available since v3.1._
774      */
775     function functionCallWithValue(
776         address target,
777         bytes memory data,
778         uint256 value,
779         string memory errorMessage
780     ) internal returns (bytes memory) {
781         require(address(this).balance >= value, "Address: insufficient balance for call");
782         (bool success, bytes memory returndata) = target.call{value: value}(data);
783         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
788      * but performing a static call.
789      *
790      * _Available since v3.3._
791      */
792     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
793         return functionStaticCall(target, data, "Address: low-level static call failed");
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
798      * but performing a static call.
799      *
800      * _Available since v3.3._
801      */
802     function functionStaticCall(
803         address target,
804         bytes memory data,
805         string memory errorMessage
806     ) internal view returns (bytes memory) {
807         (bool success, bytes memory returndata) = target.staticcall(data);
808         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
813      * but performing a delegate call.
814      *
815      * _Available since v3.4._
816      */
817     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
818         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
823      * but performing a delegate call.
824      *
825      * _Available since v3.4._
826      */
827     function functionDelegateCall(
828         address target,
829         bytes memory data,
830         string memory errorMessage
831     ) internal returns (bytes memory) {
832         (bool success, bytes memory returndata) = target.delegatecall(data);
833         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
834     }
835 
836     /**
837      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
838      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
839      *
840      * _Available since v4.8._
841      */
842     function verifyCallResultFromTarget(
843         address target,
844         bool success,
845         bytes memory returndata,
846         string memory errorMessage
847     ) internal view returns (bytes memory) {
848         if (success) {
849             if (returndata.length == 0) {
850                 // only check isContract if the call was successful and the return data is empty
851                 // otherwise we already know that it was a contract
852                 require(isContract(target), "Address: call to non-contract");
853             }
854             return returndata;
855         } else {
856             _revert(returndata, errorMessage);
857         }
858     }
859 
860     /**
861      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
862      * revert reason or using the provided one.
863      *
864      * _Available since v4.3._
865      */
866     function verifyCallResult(
867         bool success,
868         bytes memory returndata,
869         string memory errorMessage
870     ) internal pure returns (bytes memory) {
871         if (success) {
872             return returndata;
873         } else {
874             _revert(returndata, errorMessage);
875         }
876     }
877 
878     function _revert(bytes memory returndata, string memory errorMessage) private pure {
879         // Look for revert reason and bubble it up if present
880         if (returndata.length > 0) {
881             // The easiest way to bubble the revert reason is using memory via assembly
882             /// @solidity memory-safe-assembly
883             assembly {
884                 let returndata_size := mload(returndata)
885                 revert(add(32, returndata), returndata_size)
886             }
887         } else {
888             revert(errorMessage);
889         }
890     }
891 }
892 
893 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
894 
895 
896 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 /**
901  * @title ERC721 token receiver interface
902  * @dev Interface for any contract that wants to support safeTransfers
903  * from ERC721 asset contracts.
904  */
905 interface IERC721Receiver {
906     /**
907      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
908      * by `operator` from `from`, this function is called.
909      *
910      * It must return its Solidity selector to confirm the token transfer.
911      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
912      *
913      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
914      */
915     function onERC721Received(
916         address operator,
917         address from,
918         uint256 tokenId,
919         bytes calldata data
920     ) external returns (bytes4);
921 }
922 
923 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 /**
931  * @dev Interface of the ERC165 standard, as defined in the
932  * https://eips.ethereum.org/EIPS/eip-165[EIP].
933  *
934  * Implementers can declare support of contract interfaces, which can then be
935  * queried by others ({ERC165Checker}).
936  *
937  * For an implementation, see {ERC165}.
938  */
939 interface IERC165 {
940     /**
941      * @dev Returns true if this contract implements the interface defined by
942      * `interfaceId`. See the corresponding
943      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
944      * to learn more about how these ids are created.
945      *
946      * This function call must use less than 30 000 gas.
947      */
948     function supportsInterface(bytes4 interfaceId) external view returns (bool);
949 }
950 
951 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
952 
953 
954 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 /**
960  * @dev Implementation of the {IERC165} interface.
961  *
962  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
963  * for the additional interface id that will be supported. For example:
964  *
965  * ```solidity
966  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
967  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
968  * }
969  * ```
970  *
971  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
972  */
973 abstract contract ERC165 is IERC165 {
974     /**
975      * @dev See {IERC165-supportsInterface}.
976      */
977     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
978         return interfaceId == type(IERC165).interfaceId;
979     }
980 }
981 
982 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
983 
984 
985 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 
990 /**
991  * @dev Required interface of an ERC721 compliant contract.
992  */
993 interface IERC721 is IERC165 {
994     /**
995      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
996      */
997     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
998 
999     /**
1000      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1001      */
1002     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1003 
1004     /**
1005      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1006      */
1007     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1008 
1009     /**
1010      * @dev Returns the number of tokens in ``owner``'s account.
1011      */
1012     function balanceOf(address owner) external view returns (uint256 balance);
1013 
1014     /**
1015      * @dev Returns the owner of the `tokenId` token.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      */
1021     function ownerOf(uint256 tokenId) external view returns (address owner);
1022 
1023     /**
1024      * @dev Safely transfers `tokenId` token from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must exist and be owned by `from`.
1031      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1032      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId,
1040         bytes calldata data
1041     ) external;
1042 
1043     /**
1044      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1045      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1046      *
1047      * Requirements:
1048      *
1049      * - `from` cannot be the zero address.
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must exist and be owned by `from`.
1052      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) external;
1062 
1063     /**
1064      * @dev Transfers `tokenId` token from `from` to `to`.
1065      *
1066      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1067      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1068      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1069      *
1070      * Requirements:
1071      *
1072      * - `from` cannot be the zero address.
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must be owned by `from`.
1075      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function transferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) external;
1084 
1085     /**
1086      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1087      * The approval is cleared when the token is transferred.
1088      *
1089      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1090      *
1091      * Requirements:
1092      *
1093      * - The caller must own the token or be an approved operator.
1094      * - `tokenId` must exist.
1095      *
1096      * Emits an {Approval} event.
1097      */
1098     function approve(address to, uint256 tokenId) external;
1099 
1100     /**
1101      * @dev Approve or remove `operator` as an operator for the caller.
1102      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1103      *
1104      * Requirements:
1105      *
1106      * - The `operator` cannot be the caller.
1107      *
1108      * Emits an {ApprovalForAll} event.
1109      */
1110     function setApprovalForAll(address operator, bool _approved) external;
1111 
1112     /**
1113      * @dev Returns the account approved for `tokenId` token.
1114      *
1115      * Requirements:
1116      *
1117      * - `tokenId` must exist.
1118      */
1119     function getApproved(uint256 tokenId) external view returns (address operator);
1120 
1121     /**
1122      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1123      *
1124      * See {setApprovalForAll}
1125      */
1126     function isApprovedForAll(address owner, address operator) external view returns (bool);
1127 }
1128 
1129 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1130 
1131 
1132 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 
1137 /**
1138  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1139  * @dev See https://eips.ethereum.org/EIPS/eip-721
1140  */
1141 interface IERC721Metadata is IERC721 {
1142     /**
1143      * @dev Returns the token collection name.
1144      */
1145     function name() external view returns (string memory);
1146 
1147     /**
1148      * @dev Returns the token collection symbol.
1149      */
1150     function symbol() external view returns (string memory);
1151 
1152     /**
1153      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1154      */
1155     function tokenURI(uint256 tokenId) external view returns (string memory);
1156 }
1157 
1158 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1159 
1160 
1161 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 
1166 
1167 
1168 
1169 
1170 
1171 
1172 /**
1173  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1174  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1175  * {ERC721Enumerable}.
1176  */
1177 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1178     using Address for address;
1179     using Strings for uint256;
1180 
1181     // Token name
1182     string private _name;
1183 
1184     // Token symbol
1185     string private _symbol;
1186 
1187     // Mapping from token ID to owner address
1188     mapping(uint256 => address) private _owners;
1189 
1190     // Mapping owner address to token count
1191     mapping(address => uint256) private _balances;
1192 
1193     // Mapping from token ID to approved address
1194     mapping(uint256 => address) private _tokenApprovals;
1195 
1196     // Mapping from owner to operator approvals
1197     mapping(address => mapping(address => bool)) private _operatorApprovals;
1198 
1199     /**
1200      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1201      */
1202     constructor(string memory name_, string memory symbol_) {
1203         _name = name_;
1204         _symbol = symbol_;
1205     }
1206 
1207     /**
1208      * @dev See {IERC165-supportsInterface}.
1209      */
1210     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1211         return
1212             interfaceId == type(IERC721).interfaceId ||
1213             interfaceId == type(IERC721Metadata).interfaceId ||
1214             super.supportsInterface(interfaceId);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-balanceOf}.
1219      */
1220     function balanceOf(address owner) public view virtual override returns (uint256) {
1221         require(owner != address(0), "ERC721: address zero is not a valid owner");
1222         return _balances[owner];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-ownerOf}.
1227      */
1228     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1229         address owner = _ownerOf(tokenId);
1230         require(owner != address(0), "ERC721: invalid token ID");
1231         return owner;
1232     }
1233 
1234     /**
1235      * @dev See {IERC721Metadata-name}.
1236      */
1237     function name() public view virtual override returns (string memory) {
1238         return _name;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Metadata-symbol}.
1243      */
1244     function symbol() public view virtual override returns (string memory) {
1245         return _symbol;
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Metadata-tokenURI}.
1250      */
1251     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1252         _requireMinted(tokenId);
1253 
1254         string memory baseURI = _baseURI();
1255         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1256     }
1257 
1258     /**
1259      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1260      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1261      * by default, can be overridden in child contracts.
1262      */
1263     function _baseURI() internal view virtual returns (string memory) {
1264         return "";
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-approve}.
1269      */
1270     function approve(address to, uint256 tokenId) public virtual override {
1271         address owner = ERC721.ownerOf(tokenId);
1272         require(to != owner, "ERC721: approval to current owner");
1273 
1274         require(
1275             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1276             "ERC721: approve caller is not token owner or approved for all"
1277         );
1278 
1279         _approve(to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev See {IERC721-getApproved}.
1284      */
1285     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1286         _requireMinted(tokenId);
1287 
1288         return _tokenApprovals[tokenId];
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-setApprovalForAll}.
1293      */
1294     function setApprovalForAll(address operator, bool approved) public virtual override {
1295         _setApprovalForAll(_msgSender(), operator, approved);
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-isApprovedForAll}.
1300      */
1301     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1302         return _operatorApprovals[owner][operator];
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-transferFrom}.
1307      */
1308     function transferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) public virtual override {
1313         //solhint-disable-next-line max-line-length
1314         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1315 
1316         _transfer(from, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev See {IERC721-safeTransferFrom}.
1321      */
1322     function safeTransferFrom(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) public virtual override {
1327         safeTransferFrom(from, to, tokenId, "");
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-safeTransferFrom}.
1332      */
1333     function safeTransferFrom(
1334         address from,
1335         address to,
1336         uint256 tokenId,
1337         bytes memory data
1338     ) public virtual override {
1339         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1340         _safeTransfer(from, to, tokenId, data);
1341     }
1342 
1343     /**
1344      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1345      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1346      *
1347      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1348      *
1349      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1350      * implement alternative mechanisms to perform token transfer, such as signature-based.
1351      *
1352      * Requirements:
1353      *
1354      * - `from` cannot be the zero address.
1355      * - `to` cannot be the zero address.
1356      * - `tokenId` token must exist and be owned by `from`.
1357      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _safeTransfer(
1362         address from,
1363         address to,
1364         uint256 tokenId,
1365         bytes memory data
1366     ) internal virtual {
1367         _transfer(from, to, tokenId);
1368         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1369     }
1370 
1371     /**
1372      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1373      */
1374     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1375         return _owners[tokenId];
1376     }
1377 
1378     /**
1379      * @dev Returns whether `tokenId` exists.
1380      *
1381      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1382      *
1383      * Tokens start existing when they are minted (`_mint`),
1384      * and stop existing when they are burned (`_burn`).
1385      */
1386     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1387         return _ownerOf(tokenId) != address(0);
1388     }
1389 
1390     /**
1391      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1392      *
1393      * Requirements:
1394      *
1395      * - `tokenId` must exist.
1396      */
1397     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1398         address owner = ERC721.ownerOf(tokenId);
1399         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1400     }
1401 
1402     /**
1403      * @dev Safely mints `tokenId` and transfers it to `to`.
1404      *
1405      * Requirements:
1406      *
1407      * - `tokenId` must not exist.
1408      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1409      *
1410      * Emits a {Transfer} event.
1411      */
1412     function _safeMint(address to, uint256 tokenId) internal virtual {
1413         _safeMint(to, tokenId, "");
1414     }
1415 
1416     /**
1417      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1418      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1419      */
1420     function _safeMint(
1421         address to,
1422         uint256 tokenId,
1423         bytes memory data
1424     ) internal virtual {
1425         _mint(to, tokenId);
1426         require(
1427             _checkOnERC721Received(address(0), to, tokenId, data),
1428             "ERC721: transfer to non ERC721Receiver implementer"
1429         );
1430     }
1431 
1432     /**
1433      * @dev Mints `tokenId` and transfers it to `to`.
1434      *
1435      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1436      *
1437      * Requirements:
1438      *
1439      * - `tokenId` must not exist.
1440      * - `to` cannot be the zero address.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function _mint(address to, uint256 tokenId) internal virtual {
1445         require(to != address(0), "ERC721: mint to the zero address");
1446         require(!_exists(tokenId), "ERC721: token already minted");
1447 
1448         _beforeTokenTransfer(address(0), to, tokenId, 1);
1449 
1450         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1451         require(!_exists(tokenId), "ERC721: token already minted");
1452 
1453         unchecked {
1454             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1455             // Given that tokens are minted one by one, it is impossible in practice that
1456             // this ever happens. Might change if we allow batch minting.
1457             // The ERC fails to describe this case.
1458             _balances[to] += 1;
1459         }
1460 
1461         _owners[tokenId] = to;
1462 
1463         emit Transfer(address(0), to, tokenId);
1464 
1465         _afterTokenTransfer(address(0), to, tokenId, 1);
1466     }
1467 
1468     /**
1469      * @dev Destroys `tokenId`.
1470      * The approval is cleared when the token is burned.
1471      * This is an internal function that does not check if the sender is authorized to operate on the token.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _burn(uint256 tokenId) internal virtual {
1480         address owner = ERC721.ownerOf(tokenId);
1481 
1482         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1483 
1484         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1485         owner = ERC721.ownerOf(tokenId);
1486 
1487         // Clear approvals
1488         delete _tokenApprovals[tokenId];
1489 
1490         unchecked {
1491             // Cannot overflow, as that would require more tokens to be burned/transferred
1492             // out than the owner initially received through minting and transferring in.
1493             _balances[owner] -= 1;
1494         }
1495         delete _owners[tokenId];
1496 
1497         emit Transfer(owner, address(0), tokenId);
1498 
1499         _afterTokenTransfer(owner, address(0), tokenId, 1);
1500     }
1501 
1502     /**
1503      * @dev Transfers `tokenId` from `from` to `to`.
1504      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1505      *
1506      * Requirements:
1507      *
1508      * - `to` cannot be the zero address.
1509      * - `tokenId` token must be owned by `from`.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function _transfer(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) internal virtual {
1518         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1519         require(to != address(0), "ERC721: transfer to the zero address");
1520 
1521         _beforeTokenTransfer(from, to, tokenId, 1);
1522 
1523         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1524         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1525 
1526         // Clear approvals from the previous owner
1527         delete _tokenApprovals[tokenId];
1528 
1529         unchecked {
1530             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1531             // `from`'s balance is the number of token held, which is at least one before the current
1532             // transfer.
1533             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1534             // all 2**256 token ids to be minted, which in practice is impossible.
1535             _balances[from] -= 1;
1536             _balances[to] += 1;
1537         }
1538         _owners[tokenId] = to;
1539 
1540         emit Transfer(from, to, tokenId);
1541 
1542         _afterTokenTransfer(from, to, tokenId, 1);
1543     }
1544 
1545     /**
1546      * @dev Approve `to` to operate on `tokenId`
1547      *
1548      * Emits an {Approval} event.
1549      */
1550     function _approve(address to, uint256 tokenId) internal virtual {
1551         _tokenApprovals[tokenId] = to;
1552         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev Approve `operator` to operate on all of `owner` tokens
1557      *
1558      * Emits an {ApprovalForAll} event.
1559      */
1560     function _setApprovalForAll(
1561         address owner,
1562         address operator,
1563         bool approved
1564     ) internal virtual {
1565         require(owner != operator, "ERC721: approve to caller");
1566         _operatorApprovals[owner][operator] = approved;
1567         emit ApprovalForAll(owner, operator, approved);
1568     }
1569 
1570     /**
1571      * @dev Reverts if the `tokenId` has not been minted yet.
1572      */
1573     function _requireMinted(uint256 tokenId) internal view virtual {
1574         require(_exists(tokenId), "ERC721: invalid token ID");
1575     }
1576 
1577     /**
1578      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1579      * The call is not executed if the target address is not a contract.
1580      *
1581      * @param from address representing the previous owner of the given token ID
1582      * @param to target address that will receive the tokens
1583      * @param tokenId uint256 ID of the token to be transferred
1584      * @param data bytes optional data to send along with the call
1585      * @return bool whether the call correctly returned the expected magic value
1586      */
1587     function _checkOnERC721Received(
1588         address from,
1589         address to,
1590         uint256 tokenId,
1591         bytes memory data
1592     ) private returns (bool) {
1593         if (to.isContract()) {
1594             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1595                 return retval == IERC721Receiver.onERC721Received.selector;
1596             } catch (bytes memory reason) {
1597                 if (reason.length == 0) {
1598                     revert("ERC721: transfer to non ERC721Receiver implementer");
1599                 } else {
1600                     /// @solidity memory-safe-assembly
1601                     assembly {
1602                         revert(add(32, reason), mload(reason))
1603                     }
1604                 }
1605             }
1606         } else {
1607             return true;
1608         }
1609     }
1610 
1611     /**
1612      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1613      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1614      *
1615      * Calling conditions:
1616      *
1617      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1618      * - When `from` is zero, the tokens will be minted for `to`.
1619      * - When `to` is zero, ``from``'s tokens will be burned.
1620      * - `from` and `to` are never both zero.
1621      * - `batchSize` is non-zero.
1622      *
1623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1624      */
1625     function _beforeTokenTransfer(
1626         address from,
1627         address to,
1628         uint256, /* firstTokenId */
1629         uint256 batchSize
1630     ) internal virtual {
1631         if (batchSize > 1) {
1632             if (from != address(0)) {
1633                 _balances[from] -= batchSize;
1634             }
1635             if (to != address(0)) {
1636                 _balances[to] += batchSize;
1637             }
1638         }
1639     }
1640 
1641     /**
1642      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1643      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1644      *
1645      * Calling conditions:
1646      *
1647      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1648      * - When `from` is zero, the tokens were minted for `to`.
1649      * - When `to` is zero, ``from``'s tokens were burned.
1650      * - `from` and `to` are never both zero.
1651      * - `batchSize` is non-zero.
1652      *
1653      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1654      */
1655     function _afterTokenTransfer(
1656         address from,
1657         address to,
1658         uint256 firstTokenId,
1659         uint256 batchSize
1660     ) internal virtual {}
1661 }
1662 
1663 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1664 
1665 
1666 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1667 
1668 pragma solidity ^0.8.0;
1669 
1670 
1671 /**
1672  * @dev ERC721 token with storage based token URI management.
1673  */
1674 abstract contract ERC721URIStorage is ERC721 {
1675     using Strings for uint256;
1676 
1677     // Optional mapping for token URIs
1678     mapping(uint256 => string) private _tokenURIs;
1679 
1680     /**
1681      * @dev See {IERC721Metadata-tokenURI}.
1682      */
1683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1684         _requireMinted(tokenId);
1685 
1686         string memory _tokenURI = _tokenURIs[tokenId];
1687         string memory base = _baseURI();
1688 
1689         // If there is no base URI, return the token URI.
1690         if (bytes(base).length == 0) {
1691             return _tokenURI;
1692         }
1693         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1694         if (bytes(_tokenURI).length > 0) {
1695             return string(abi.encodePacked(base, _tokenURI));
1696         }
1697 
1698         return super.tokenURI(tokenId);
1699     }
1700 
1701     /**
1702      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1703      *
1704      * Requirements:
1705      *
1706      * - `tokenId` must exist.
1707      */
1708     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1709         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1710         _tokenURIs[tokenId] = _tokenURI;
1711     }
1712 
1713     /**
1714      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1715      * token-specific URI was set for the token, and if so, it deletes the token URI from
1716      * the storage mapping.
1717      */
1718     function _burn(uint256 tokenId) internal virtual override {
1719         super._burn(tokenId);
1720 
1721         if (bytes(_tokenURIs[tokenId]).length != 0) {
1722             delete _tokenURIs[tokenId];
1723         }
1724     }
1725 }
1726 
1727 // File: PunnyPickles.sol
1728 
1729 /*
1730 __________                            __________.__        __   .__                 
1731 \______   \__ __  ____   ____ ___.__. \______   \__| ____ |  | _|  |   ____   ______
1732  |     ___/  |  \/    \ /    <   |  |  |     ___/  |/ ___\|  |/ /  | _/ __ \ /  ___/
1733  |    |   |  |  /   |  \   |  \___  |  |    |   |  \  \___|    <|  |_\  ___/ \___ \ 
1734  |____|   |____/|___|  /___|  / ____|  |____|   |__|\___  >__|_ \____/\___  >____  >
1735                      \/     \/\/                        \/     \/         \/     \/ 
1736 
1737 */
1738 
1739 pragma solidity 0.8.17;
1740 
1741 
1742 
1743 
1744 
1745 contract PunnyPickles is ERC721, ERC721URIStorage, DefaultOperatorFilterer, Ownable {
1746 
1747     uint256 public _totalSupply = 5555;
1748     uint256 public _tokenId = 0; 
1749     bool public PAUSED = true;
1750     uint public MINT_PRICE = 0 ether;
1751     uint256 public MAX_MINT = 3;
1752     string public baseURI = "ipfs://QmQBi7aEackAdxHLooUgKPhqjK52oLS77NMcTgPw6kgFZw/";
1753 
1754     constructor() ERC721("PunnyPickles", "PP") {
1755         baseURI;
1756     }
1757 
1758     function togglePause() public onlyOwner {
1759         PAUSED = !PAUSED;
1760     }
1761 
1762     function safeMint(address to, uint256 _numTokens) public payable {
1763         require(PAUSED == false, "Minting is currently paused.");
1764         require(balanceOf(to) + _numTokens <= MAX_MINT, "The specified address already holds the maximum number of mintable NFTs.");
1765         require(msg.value >= MINT_PRICE, "Not enough ether sent.");
1766         require((_tokenId + _numTokens) <= _totalSupply, "Total Supply cannot be exceeded.");
1767         require(_numTokens <= MAX_MINT, "You cannot mint that many in one transaction.");
1768 
1769         for(uint256 i = 1; i <= _numTokens; ++i) {
1770             _tokenId++;
1771             _safeMint(to, _tokenId);
1772             _setTokenURI(_tokenId, baseURI);
1773         }       
1774     }
1775 
1776     function withdrawAll() external payable onlyOwner {
1777         require(address(this).balance > 0, "Zero Balance");
1778         uint256 balance = address(this).balance;
1779         uint256 balanceOne = balance * 50 / 100;
1780         uint256 balanceTwo = balance * 50 / 100;
1781         ( bool transferOne, ) = payable(0xB3Fd26693c5d392D2db1f9cA6ec5e38E76f6447B).call{value: balanceOne}("");
1782         ( bool transferTwo, ) = payable(0x4Caae36aBddec390a2ccad46d94aac287932d6Ec).call{value: balanceTwo}("");
1783         require(transferOne && transferTwo, "Transfer failed.");
1784     }
1785 
1786     function setBaseURI(string memory _baseURI) external onlyOwner {
1787         baseURI = _baseURI;
1788     }
1789 
1790     function setSupply(uint _MAX_SUPPLY) external onlyOwner {
1791         if (_MAX_SUPPLY <= _totalSupply && _MAX_SUPPLY > _tokenId) {
1792             _totalSupply = _MAX_SUPPLY;
1793         }
1794     }
1795 
1796     function setMaxMint(uint _MAX_MINT) external onlyOwner {
1797         MAX_MINT = _MAX_MINT;
1798     }
1799 
1800     function totalSupply() public virtual view returns (uint256) {
1801         return _totalSupply;
1802     }
1803   
1804     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1805         super.setApprovalForAll(operator, approved);
1806     }
1807 
1808     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1809         super.approve(operator, tokenId);
1810     }
1811 
1812     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1813         super.transferFrom(from, to, tokenId);
1814     }
1815 
1816     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1817         super.safeTransferFrom(from, to, tokenId);
1818     }
1819 
1820     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1821         public
1822         override
1823         onlyAllowedOperator(from)
1824     {
1825         super.safeTransferFrom(from, to, tokenId, data);
1826     }
1827 
1828     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1829         super._burn(tokenId);
1830     }
1831 
1832     function tokenURI(uint256 tokenId)
1833         public
1834         view
1835         override(ERC721, ERC721URIStorage)
1836 
1837         returns (string memory)
1838     {
1839         return string.concat(baseURI, Strings.toString(tokenId), ".json");
1840     }
1841 }