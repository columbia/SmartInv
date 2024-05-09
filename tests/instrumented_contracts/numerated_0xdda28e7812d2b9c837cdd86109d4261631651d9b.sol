1 // SPDX-License-Identifier: MIT
2 // File: Interfaces/IERC721Burn.sol
3 
4 
5 pragma solidity ^0.8.4;
6 
7 interface IERC721Burn{
8     function burn(uint256 tokenId) external;
9 }
10 // File: opensea-enforcement/IOperatorFilterRegistry.sol
11 
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
17     function register(address registrant) external;
18     function registerAndSubscribe(address registrant, address subscription) external;
19     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
20     function updateOperator(address registrant, address operator, bool filtered) external;
21     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
22     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
23     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
24     function subscribe(address registrant, address registrantToSubscribe) external;
25     function unsubscribe(address registrant, bool copyExistingEntries) external;
26     function subscriptionOf(address addr) external returns (address registrant);
27     function subscribers(address registrant) external returns (address[] memory);
28     function subscriberAt(address registrant, uint256 index) external returns (address);
29     function copyEntriesOf(address registrant, address registrantToCopy) external;
30     function isOperatorFiltered(address registrant, address operator) external returns (bool);
31     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
32     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
33     function filteredOperators(address addr) external returns (address[] memory);
34     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
35     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
36     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
37     function isRegistered(address addr) external returns (bool);
38     function codeHashOf(address addr) external returns (bytes32);
39 }
40 
41 // File: opensea-enforcement/OperatorFilterer.sol
42 
43 
44 pragma solidity ^0.8.13;
45 
46 
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry constant operatorFilterRegistry =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(operatorFilterRegistry).code.length > 0) {
58             if (subscribe) {
59                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     operatorFilterRegistry.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Check registry code length to facilitate testing in environments without a deployed registry.
72         if (address(operatorFilterRegistry).code.length > 0) {
73             // Allow spending tokens from addresses with balance
74             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75             // from an EOA.
76             if (from == msg.sender) {
77                 _;
78                 return;
79             }
80             if (
81                 !(
82                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
83                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
84                 )
85             ) {
86                 revert OperatorNotAllowed(msg.sender);
87             }
88         }
89         _;
90     }
91 }
92 
93 // File: opensea-enforcement/DefaultOperatorFilterer.sol
94 
95 
96 pragma solidity ^0.8.13;
97 
98 
99 abstract contract DefaultOperatorFilterer is OperatorFilterer {
100     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
101 
102     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
103 }
104 
105 
106 // File: @openzeppelin/contracts/utils/math/Math.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Standard math utilities missing in the Solidity language.
115  */
116 library Math {
117     enum Rounding {
118         Down, // Toward negative infinity
119         Up, // Toward infinity
120         Zero // Toward zero
121     }
122 
123     /**
124      * @dev Returns the largest of two numbers.
125      */
126     function max(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a > b ? a : b;
128     }
129 
130     /**
131      * @dev Returns the smallest of two numbers.
132      */
133     function min(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a < b ? a : b;
135     }
136 
137     /**
138      * @dev Returns the average of two numbers. The result is rounded towards
139      * zero.
140      */
141     function average(uint256 a, uint256 b) internal pure returns (uint256) {
142         // (a + b) / 2 can overflow.
143         return (a & b) + (a ^ b) / 2;
144     }
145 
146     /**
147      * @dev Returns the ceiling of the division of two numbers.
148      *
149      * This differs from standard division with `/` in that it rounds up instead
150      * of rounding down.
151      */
152     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
153         // (a + b - 1) / b can overflow on addition, so we distribute.
154         return a == 0 ? 0 : (a - 1) / b + 1;
155     }
156 
157     /**
158      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
159      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
160      * with further edits by Uniswap Labs also under MIT license.
161      */
162     function mulDiv(
163         uint256 x,
164         uint256 y,
165         uint256 denominator
166     ) internal pure returns (uint256 result) {
167         unchecked {
168             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
169             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
170             // variables such that product = prod1 * 2^256 + prod0.
171             uint256 prod0; // Least significant 256 bits of the product
172             uint256 prod1; // Most significant 256 bits of the product
173             assembly {
174                 let mm := mulmod(x, y, not(0))
175                 prod0 := mul(x, y)
176                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
177             }
178 
179             // Handle non-overflow cases, 256 by 256 division.
180             if (prod1 == 0) {
181                 return prod0 / denominator;
182             }
183 
184             // Make sure the result is less than 2^256. Also prevents denominator == 0.
185             require(denominator > prod1);
186 
187             ///////////////////////////////////////////////
188             // 512 by 256 division.
189             ///////////////////////////////////////////////
190 
191             // Make division exact by subtracting the remainder from [prod1 prod0].
192             uint256 remainder;
193             assembly {
194                 // Compute remainder using mulmod.
195                 remainder := mulmod(x, y, denominator)
196 
197                 // Subtract 256 bit number from 512 bit number.
198                 prod1 := sub(prod1, gt(remainder, prod0))
199                 prod0 := sub(prod0, remainder)
200             }
201 
202             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
203             // See https://cs.stackexchange.com/q/138556/92363.
204 
205             // Does not overflow because the denominator cannot be zero at this stage in the function.
206             uint256 twos = denominator & (~denominator + 1);
207             assembly {
208                 // Divide denominator by twos.
209                 denominator := div(denominator, twos)
210 
211                 // Divide [prod1 prod0] by twos.
212                 prod0 := div(prod0, twos)
213 
214                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
215                 twos := add(div(sub(0, twos), twos), 1)
216             }
217 
218             // Shift in bits from prod1 into prod0.
219             prod0 |= prod1 * twos;
220 
221             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
222             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
223             // four bits. That is, denominator * inv = 1 mod 2^4.
224             uint256 inverse = (3 * denominator) ^ 2;
225 
226             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
227             // in modular arithmetic, doubling the correct bits in each step.
228             inverse *= 2 - denominator * inverse; // inverse mod 2^8
229             inverse *= 2 - denominator * inverse; // inverse mod 2^16
230             inverse *= 2 - denominator * inverse; // inverse mod 2^32
231             inverse *= 2 - denominator * inverse; // inverse mod 2^64
232             inverse *= 2 - denominator * inverse; // inverse mod 2^128
233             inverse *= 2 - denominator * inverse; // inverse mod 2^256
234 
235             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
236             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
237             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
238             // is no longer required.
239             result = prod0 * inverse;
240             return result;
241         }
242     }
243 
244     /**
245      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
246      */
247     function mulDiv(
248         uint256 x,
249         uint256 y,
250         uint256 denominator,
251         Rounding rounding
252     ) internal pure returns (uint256) {
253         uint256 result = mulDiv(x, y, denominator);
254         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
255             result += 1;
256         }
257         return result;
258     }
259 
260     /**
261      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
262      *
263      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
264      */
265     function sqrt(uint256 a) internal pure returns (uint256) {
266         if (a == 0) {
267             return 0;
268         }
269 
270         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
271         //
272         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
273         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
274         //
275         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
276         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
277         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
278         //
279         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
280         uint256 result = 1 << (log2(a) >> 1);
281 
282         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
283         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
284         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
285         // into the expected uint128 result.
286         unchecked {
287             result = (result + a / result) >> 1;
288             result = (result + a / result) >> 1;
289             result = (result + a / result) >> 1;
290             result = (result + a / result) >> 1;
291             result = (result + a / result) >> 1;
292             result = (result + a / result) >> 1;
293             result = (result + a / result) >> 1;
294             return min(result, a / result);
295         }
296     }
297 
298     /**
299      * @notice Calculates sqrt(a), following the selected rounding direction.
300      */
301     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
302         unchecked {
303             uint256 result = sqrt(a);
304             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
305         }
306     }
307 
308     /**
309      * @dev Return the log in base 2, rounded down, of a positive value.
310      * Returns 0 if given 0.
311      */
312     function log2(uint256 value) internal pure returns (uint256) {
313         uint256 result = 0;
314         unchecked {
315             if (value >> 128 > 0) {
316                 value >>= 128;
317                 result += 128;
318             }
319             if (value >> 64 > 0) {
320                 value >>= 64;
321                 result += 64;
322             }
323             if (value >> 32 > 0) {
324                 value >>= 32;
325                 result += 32;
326             }
327             if (value >> 16 > 0) {
328                 value >>= 16;
329                 result += 16;
330             }
331             if (value >> 8 > 0) {
332                 value >>= 8;
333                 result += 8;
334             }
335             if (value >> 4 > 0) {
336                 value >>= 4;
337                 result += 4;
338             }
339             if (value >> 2 > 0) {
340                 value >>= 2;
341                 result += 2;
342             }
343             if (value >> 1 > 0) {
344                 result += 1;
345             }
346         }
347         return result;
348     }
349 
350     /**
351      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
352      * Returns 0 if given 0.
353      */
354     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
355         unchecked {
356             uint256 result = log2(value);
357             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
358         }
359     }
360 
361     /**
362      * @dev Return the log in base 10, rounded down, of a positive value.
363      * Returns 0 if given 0.
364      */
365     function log10(uint256 value) internal pure returns (uint256) {
366         uint256 result = 0;
367         unchecked {
368             if (value >= 10**64) {
369                 value /= 10**64;
370                 result += 64;
371             }
372             if (value >= 10**32) {
373                 value /= 10**32;
374                 result += 32;
375             }
376             if (value >= 10**16) {
377                 value /= 10**16;
378                 result += 16;
379             }
380             if (value >= 10**8) {
381                 value /= 10**8;
382                 result += 8;
383             }
384             if (value >= 10**4) {
385                 value /= 10**4;
386                 result += 4;
387             }
388             if (value >= 10**2) {
389                 value /= 10**2;
390                 result += 2;
391             }
392             if (value >= 10**1) {
393                 result += 1;
394             }
395         }
396         return result;
397     }
398 
399     /**
400      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
401      * Returns 0 if given 0.
402      */
403     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
404         unchecked {
405             uint256 result = log10(value);
406             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
407         }
408     }
409 
410     /**
411      * @dev Return the log in base 256, rounded down, of a positive value.
412      * Returns 0 if given 0.
413      *
414      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
415      */
416     function log256(uint256 value) internal pure returns (uint256) {
417         uint256 result = 0;
418         unchecked {
419             if (value >> 128 > 0) {
420                 value >>= 128;
421                 result += 16;
422             }
423             if (value >> 64 > 0) {
424                 value >>= 64;
425                 result += 8;
426             }
427             if (value >> 32 > 0) {
428                 value >>= 32;
429                 result += 4;
430             }
431             if (value >> 16 > 0) {
432                 value >>= 16;
433                 result += 2;
434             }
435             if (value >> 8 > 0) {
436                 result += 1;
437             }
438         }
439         return result;
440     }
441 
442     /**
443      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
444      * Returns 0 if given 0.
445      */
446     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
447         unchecked {
448             uint256 result = log256(value);
449             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/utils/Strings.sol
455 
456 
457 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev String operations.
464  */
465 library Strings {
466     bytes16 private constant _SYMBOLS = "0123456789abcdef";
467     uint8 private constant _ADDRESS_LENGTH = 20;
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
471      */
472     function toString(uint256 value) internal pure returns (string memory) {
473         unchecked {
474             uint256 length = Math.log10(value) + 1;
475             string memory buffer = new string(length);
476             uint256 ptr;
477             /// @solidity memory-safe-assembly
478             assembly {
479                 ptr := add(buffer, add(32, length))
480             }
481             while (true) {
482                 ptr--;
483                 /// @solidity memory-safe-assembly
484                 assembly {
485                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
486                 }
487                 value /= 10;
488                 if (value == 0) break;
489             }
490             return buffer;
491         }
492     }
493 
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
496      */
497     function toHexString(uint256 value) internal pure returns (string memory) {
498         unchecked {
499             return toHexString(value, Math.log256(value) + 1);
500         }
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = _SYMBOLS[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 
518     /**
519      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
520      */
521     function toHexString(address addr) internal pure returns (string memory) {
522         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
523     }
524 }
525 
526 // File: @openzeppelin/contracts/utils/Context.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev Provides information about the current execution context, including the
535  * sender of the transaction and its data. While these are generally available
536  * via msg.sender and msg.data, they should not be accessed in such a direct
537  * manner, since when dealing with meta-transactions the account sending and
538  * paying for execution may not be the actual sender (as far as an application
539  * is concerned).
540  *
541  * This contract is only required for intermediate, library-like contracts.
542  */
543 abstract contract Context {
544     function _msgSender() internal view virtual returns (address) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes calldata) {
549         return msg.data;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/access/Ownable.sol
554 
555 
556 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Contract module which provides a basic access control mechanism, where
563  * there is an account (an owner) that can be granted exclusive access to
564  * specific functions.
565  *
566  * By default, the owner account will be the one that deploys the contract. This
567  * can later be changed with {transferOwnership}.
568  *
569  * This module is used through inheritance. It will make available the modifier
570  * `onlyOwner`, which can be applied to your functions to restrict their use to
571  * the owner.
572  */
573 abstract contract Ownable is Context {
574     address private _owner;
575 
576     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
577 
578     /**
579      * @dev Initializes the contract setting the deployer as the initial owner.
580      */
581     constructor() {
582         _transferOwnership(_msgSender());
583     }
584 
585     /**
586      * @dev Throws if called by any account other than the owner.
587      */
588     modifier onlyOwner() {
589         _checkOwner();
590         _;
591     }
592 
593     /**
594      * @dev Returns the address of the current owner.
595      */
596     function owner() public view virtual returns (address) {
597         return _owner;
598     }
599 
600     /**
601      * @dev Throws if the sender is not the owner.
602      */
603     function _checkOwner() internal view virtual {
604         require(owner() == _msgSender(), "Ownable: caller is not the owner");
605     }
606 
607     /**
608      * @dev Leaves the contract without owner. It will not be possible to call
609      * `onlyOwner` functions anymore. Can only be called by the current owner.
610      *
611      * NOTE: Renouncing ownership will leave the contract without an owner,
612      * thereby removing any functionality that is only available to the owner.
613      */
614     function renounceOwnership() public virtual onlyOwner {
615         _transferOwnership(address(0));
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), "Ownable: new owner is the zero address");
624         _transferOwnership(newOwner);
625     }
626 
627     /**
628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
629      * Internal function without access restriction.
630      */
631     function _transferOwnership(address newOwner) internal virtual {
632         address oldOwner = _owner;
633         _owner = newOwner;
634         emit OwnershipTransferred(oldOwner, newOwner);
635     }
636 }
637 
638 // File: @openzeppelin/contracts/utils/Address.sol
639 
640 
641 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
642 
643 pragma solidity ^0.8.1;
644 
645 /**
646  * @dev Collection of functions related to the address type
647  */
648 library Address {
649     /**
650      * @dev Returns true if `account` is a contract.
651      *
652      * [IMPORTANT]
653      * ====
654      * It is unsafe to assume that an address for which this function returns
655      * false is an externally-owned account (EOA) and not a contract.
656      *
657      * Among others, `isContract` will return false for the following
658      * types of addresses:
659      *
660      *  - an externally-owned account
661      *  - a contract in construction
662      *  - an address where a contract will be created
663      *  - an address where a contract lived, but was destroyed
664      * ====
665      *
666      * [IMPORTANT]
667      * ====
668      * You shouldn't rely on `isContract` to protect against flash loan attacks!
669      *
670      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
671      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
672      * constructor.
673      * ====
674      */
675     function isContract(address account) internal view returns (bool) {
676         // This method relies on extcodesize/address.code.length, which returns 0
677         // for contracts in construction, since the code is only stored at the end
678         // of the constructor execution.
679 
680         return account.code.length > 0;
681     }
682 
683     /**
684      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
685      * `recipient`, forwarding all available gas and reverting on errors.
686      *
687      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
688      * of certain opcodes, possibly making contracts go over the 2300 gas limit
689      * imposed by `transfer`, making them unable to receive funds via
690      * `transfer`. {sendValue} removes this limitation.
691      *
692      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
693      *
694      * IMPORTANT: because control is transferred to `recipient`, care must be
695      * taken to not create reentrancy vulnerabilities. Consider using
696      * {ReentrancyGuard} or the
697      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
698      */
699     function sendValue(address payable recipient, uint256 amount) internal {
700         require(address(this).balance >= amount, "Address: insufficient balance");
701 
702         (bool success, ) = recipient.call{value: amount}("");
703         require(success, "Address: unable to send value, recipient may have reverted");
704     }
705 
706     /**
707      * @dev Performs a Solidity function call using a low level `call`. A
708      * plain `call` is an unsafe replacement for a function call: use this
709      * function instead.
710      *
711      * If `target` reverts with a revert reason, it is bubbled up by this
712      * function (like regular Solidity function calls).
713      *
714      * Returns the raw returned data. To convert to the expected return value,
715      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
716      *
717      * Requirements:
718      *
719      * - `target` must be a contract.
720      * - calling `target` with `data` must not revert.
721      *
722      * _Available since v3.1._
723      */
724     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
725         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
730      * `errorMessage` as a fallback revert reason when `target` reverts.
731      *
732      * _Available since v3.1._
733      */
734     function functionCall(
735         address target,
736         bytes memory data,
737         string memory errorMessage
738     ) internal returns (bytes memory) {
739         return functionCallWithValue(target, data, 0, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but also transferring `value` wei to `target`.
745      *
746      * Requirements:
747      *
748      * - the calling contract must have an ETH balance of at least `value`.
749      * - the called Solidity function must be `payable`.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(
754         address target,
755         bytes memory data,
756         uint256 value
757     ) internal returns (bytes memory) {
758         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
763      * with `errorMessage` as a fallback revert reason when `target` reverts.
764      *
765      * _Available since v3.1._
766      */
767     function functionCallWithValue(
768         address target,
769         bytes memory data,
770         uint256 value,
771         string memory errorMessage
772     ) internal returns (bytes memory) {
773         require(address(this).balance >= value, "Address: insufficient balance for call");
774         (bool success, bytes memory returndata) = target.call{value: value}(data);
775         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but performing a static call.
781      *
782      * _Available since v3.3._
783      */
784     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
785         return functionStaticCall(target, data, "Address: low-level static call failed");
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
790      * but performing a static call.
791      *
792      * _Available since v3.3._
793      */
794     function functionStaticCall(
795         address target,
796         bytes memory data,
797         string memory errorMessage
798     ) internal view returns (bytes memory) {
799         (bool success, bytes memory returndata) = target.staticcall(data);
800         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
801     }
802 
803     /**
804      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
805      * but performing a delegate call.
806      *
807      * _Available since v3.4._
808      */
809     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
810         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
815      * but performing a delegate call.
816      *
817      * _Available since v3.4._
818      */
819     function functionDelegateCall(
820         address target,
821         bytes memory data,
822         string memory errorMessage
823     ) internal returns (bytes memory) {
824         (bool success, bytes memory returndata) = target.delegatecall(data);
825         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
830      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
831      *
832      * _Available since v4.8._
833      */
834     function verifyCallResultFromTarget(
835         address target,
836         bool success,
837         bytes memory returndata,
838         string memory errorMessage
839     ) internal view returns (bytes memory) {
840         if (success) {
841             if (returndata.length == 0) {
842                 // only check isContract if the call was successful and the return data is empty
843                 // otherwise we already know that it was a contract
844                 require(isContract(target), "Address: call to non-contract");
845             }
846             return returndata;
847         } else {
848             _revert(returndata, errorMessage);
849         }
850     }
851 
852     /**
853      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
854      * revert reason or using the provided one.
855      *
856      * _Available since v4.3._
857      */
858     function verifyCallResult(
859         bool success,
860         bytes memory returndata,
861         string memory errorMessage
862     ) internal pure returns (bytes memory) {
863         if (success) {
864             return returndata;
865         } else {
866             _revert(returndata, errorMessage);
867         }
868     }
869 
870     function _revert(bytes memory returndata, string memory errorMessage) private pure {
871         // Look for revert reason and bubble it up if present
872         if (returndata.length > 0) {
873             // The easiest way to bubble the revert reason is using memory via assembly
874             /// @solidity memory-safe-assembly
875             assembly {
876                 let returndata_size := mload(returndata)
877                 revert(add(32, returndata), returndata_size)
878             }
879         } else {
880             revert(errorMessage);
881         }
882     }
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
886 
887 
888 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
889 
890 pragma solidity ^0.8.0;
891 
892 /**
893  * @title ERC721 token receiver interface
894  * @dev Interface for any contract that wants to support safeTransfers
895  * from ERC721 asset contracts.
896  */
897 interface IERC721Receiver {
898     /**
899      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
900      * by `operator` from `from`, this function is called.
901      *
902      * It must return its Solidity selector to confirm the token transfer.
903      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
904      *
905      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
906      */
907     function onERC721Received(
908         address operator,
909         address from,
910         uint256 tokenId,
911         bytes calldata data
912     ) external returns (bytes4);
913 }
914 
915 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
943 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
944 
945 
946 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
947 
948 pragma solidity ^0.8.0;
949 
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
974 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
975 
976 
977 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
978 
979 pragma solidity ^0.8.0;
980 
981 
982 /**
983  * @dev Required interface of an ERC721 compliant contract.
984  */
985 interface IERC721 is IERC165 {
986     /**
987      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
988      */
989     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
990 
991     /**
992      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
993      */
994     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
995 
996     /**
997      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
998      */
999     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1000 
1001     /**
1002      * @dev Returns the number of tokens in ``owner``'s account.
1003      */
1004     function balanceOf(address owner) external view returns (uint256 balance);
1005 
1006     /**
1007      * @dev Returns the owner of the `tokenId` token.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      */
1013     function ownerOf(uint256 tokenId) external view returns (address owner);
1014 
1015     /**
1016      * @dev Safely transfers `tokenId` token from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `from` cannot be the zero address.
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must exist and be owned by `from`.
1023      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1024      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes calldata data
1033     ) external;
1034 
1035     /**
1036      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1037      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1038      *
1039      * Requirements:
1040      *
1041      * - `from` cannot be the zero address.
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must exist and be owned by `from`.
1044      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) external;
1054 
1055     /**
1056      * @dev Transfers `tokenId` token from `from` to `to`.
1057      *
1058      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1059      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1060      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1061      *
1062      * Requirements:
1063      *
1064      * - `from` cannot be the zero address.
1065      * - `to` cannot be the zero address.
1066      * - `tokenId` token must be owned by `from`.
1067      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function transferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) external;
1076 
1077     /**
1078      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1079      * The approval is cleared when the token is transferred.
1080      *
1081      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1082      *
1083      * Requirements:
1084      *
1085      * - The caller must own the token or be an approved operator.
1086      * - `tokenId` must exist.
1087      *
1088      * Emits an {Approval} event.
1089      */
1090     function approve(address to, uint256 tokenId) external;
1091 
1092     /**
1093      * @dev Approve or remove `operator` as an operator for the caller.
1094      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1095      *
1096      * Requirements:
1097      *
1098      * - The `operator` cannot be the caller.
1099      *
1100      * Emits an {ApprovalForAll} event.
1101      */
1102     function setApprovalForAll(address operator, bool _approved) external;
1103 
1104     /**
1105      * @dev Returns the account approved for `tokenId` token.
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must exist.
1110      */
1111     function getApproved(uint256 tokenId) external view returns (address operator);
1112 
1113     /**
1114      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1115      *
1116      * See {setApprovalForAll}
1117      */
1118     function isApprovedForAll(address owner, address operator) external view returns (bool);
1119 }
1120 
1121 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1122 
1123 
1124 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 
1129 /**
1130  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1131  * @dev See https://eips.ethereum.org/EIPS/eip-721
1132  */
1133 interface IERC721Enumerable is IERC721 {
1134     /**
1135      * @dev Returns the total amount of tokens stored by the contract.
1136      */
1137     function totalSupply() external view returns (uint256);
1138 
1139     /**
1140      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1141      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1142      */
1143     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1144 
1145     /**
1146      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1147      * Use along with {totalSupply} to enumerate all tokens.
1148      */
1149     function tokenByIndex(uint256 index) external view returns (uint256);
1150 }
1151 
1152 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1153 
1154 
1155 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1156 
1157 pragma solidity ^0.8.0;
1158 
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
1181 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1182 
1183 
1184 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
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
1211     mapping(uint256 => address) public _owners;
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
1278         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
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
1686 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1687 
1688 
1689 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1690 
1691 pragma solidity ^0.8.0;
1692 
1693 
1694 
1695 /**
1696  * @title ERC721 Burnable Token
1697  * @dev ERC721 Token that can be burned (destroyed).
1698  */
1699 abstract contract ERC721Burnable is Context, ERC721 {
1700     /**
1701      * @dev Burns `tokenId`. See {ERC721-_burn}.
1702      *
1703      * Requirements:
1704      *
1705      * - The caller must own `tokenId` or be an approved operator.
1706      */
1707     function burn(uint256 tokenId) public virtual {
1708         //solhint-disable-next-line max-line-length
1709         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1710         _burn(tokenId);
1711     }
1712 }
1713 
1714 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1715 
1716 
1717 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1718 
1719 pragma solidity ^0.8.0;
1720 
1721 
1722 
1723 /**
1724  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1725  * enumerability of all the token ids in the contract as well as all token ids owned by each
1726  * account.
1727  */
1728 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1729     // Mapping from owner to list of owned token IDs
1730     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1731 
1732     // Mapping from token ID to index of the owner tokens list
1733     mapping(uint256 => uint256) private _ownedTokensIndex;
1734 
1735     // Array with all token ids, used for enumeration
1736     uint256[] private _allTokens;
1737 
1738     // Mapping from token id to position in the allTokens array
1739     mapping(uint256 => uint256) private _allTokensIndex;
1740 
1741     /**
1742      * @dev See {IERC165-supportsInterface}.
1743      */
1744     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1745         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1746     }
1747 
1748     /**
1749      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1750      */
1751     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1752         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1753         return _ownedTokens[owner][index];
1754     }
1755 
1756     /**
1757      * @dev See {IERC721Enumerable-totalSupply}.
1758      */
1759     function totalSupply() public view virtual override returns (uint256) {
1760         return _allTokens.length;
1761     }
1762 
1763     /**
1764      * @dev See {IERC721Enumerable-tokenByIndex}.
1765      */
1766     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1767         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1768         return _allTokens[index];
1769     }
1770 
1771     /**
1772      * @dev See {ERC721-_beforeTokenTransfer}.
1773      */
1774     function _beforeTokenTransfer(
1775         address from,
1776         address to,
1777         uint256 firstTokenId,
1778         uint256 batchSize
1779     ) internal virtual override {
1780         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1781 
1782         if (batchSize > 1) {
1783             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1784             revert("ERC721Enumerable: consecutive transfers not supported");
1785         }
1786 
1787         uint256 tokenId = firstTokenId;
1788 
1789         if (from == address(0)) {
1790             _addTokenToAllTokensEnumeration(tokenId);
1791         } else if (from != to) {
1792             _removeTokenFromOwnerEnumeration(from, tokenId);
1793         }
1794         if (to == address(0)) {
1795             _removeTokenFromAllTokensEnumeration(tokenId);
1796         } else if (to != from) {
1797             _addTokenToOwnerEnumeration(to, tokenId);
1798         }
1799     }
1800 
1801     /**
1802      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1803      * @param to address representing the new owner of the given token ID
1804      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1805      */
1806     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1807         uint256 length = ERC721.balanceOf(to);
1808         _ownedTokens[to][length] = tokenId;
1809         _ownedTokensIndex[tokenId] = length;
1810     }
1811 
1812     /**
1813      * @dev Private function to add a token to this extension's token tracking data structures.
1814      * @param tokenId uint256 ID of the token to be added to the tokens list
1815      */
1816     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1817         _allTokensIndex[tokenId] = _allTokens.length;
1818         _allTokens.push(tokenId);
1819     }
1820 
1821     /**
1822      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1823      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1824      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1825      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1826      * @param from address representing the previous owner of the given token ID
1827      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1828      */
1829     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1830         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1831         // then delete the last slot (swap and pop).
1832 
1833         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1834         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1835 
1836         // When the token to delete is the last token, the swap operation is unnecessary
1837         if (tokenIndex != lastTokenIndex) {
1838             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1839 
1840             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1841             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1842         }
1843 
1844         // This also deletes the contents at the last position of the array
1845         delete _ownedTokensIndex[tokenId];
1846         delete _ownedTokens[from][lastTokenIndex];
1847     }
1848 
1849     /**
1850      * @dev Private function to remove a token from this extension's token tracking data structures.
1851      * This has O(1) time complexity, but alters the order of the _allTokens array.
1852      * @param tokenId uint256 ID of the token to be removed from the tokens list
1853      */
1854     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1855         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1856         // then delete the last slot (swap and pop).
1857 
1858         uint256 lastTokenIndex = _allTokens.length - 1;
1859         uint256 tokenIndex = _allTokensIndex[tokenId];
1860 
1861         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1862         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1863         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1864         uint256 lastTokenId = _allTokens[lastTokenIndex];
1865 
1866         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1867         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1868 
1869         // This also deletes the contents at the last position of the array
1870         delete _allTokensIndex[tokenId];
1871         _allTokens.pop();
1872     }
1873 }
1874 
1875 // File: phase2.sol
1876 
1877 
1878 pragma solidity ^0.8.13;
1879 
1880 contract Phase2 is ERC721, ERC721Burnable,DefaultOperatorFilterer, ERC721Enumerable, Ownable{
1881 
1882     bool public toggle;
1883     address public phase1NFTAddress;
1884     address public artVialNFTAddress;
1885     string private URI;
1886     uint256 public revealTime;
1887     mapping(address => uint256[]) public userNftId;
1888 
1889     event revealTimer(uint256 revealTime);
1890 
1891     constructor(string memory _name, string memory _symbol, address _phase1NFTAddress, address _artVialNFTAddress) ERC721(_name,_symbol) {
1892         phase1NFTAddress = _phase1NFTAddress;
1893         artVialNFTAddress = _artVialNFTAddress;
1894     }
1895 
1896     /* 
1897     @dev This function will burn the phase1 and Art Vial NFT, and mint a new NFT of phase 2 with same tokenID as Phase1, before calling this function
1898         make sure you have taken the allowance of tokenId from the phase1 and art vial claim contract
1899     @params phase1TokenId: TokenId for Phase1
1900     @params artVialTokenId: TokenId for Art Vial
1901     */
1902     function merge(uint256 phase1TokenId, uint256 artVialTokenId) public {
1903         require(toggle == true, "Phase2: Toggle is off");
1904         require(revealTime !=0, "Phase2: Set revel Timer");
1905         require(block.timestamp > revealTime, "Phase2: Redeem has not started yet");
1906         require(IERC721(phase1NFTAddress).ownerOf(phase1TokenId) == msg.sender, "Phase2: You are not the owner of Phase1 NFT");
1907         require(IERC721(artVialNFTAddress).ownerOf(artVialTokenId) == msg.sender, "Phase2: You are not the owner of Art Vial NFT");
1908         IERC721Burn(phase1NFTAddress).burn(phase1TokenId);
1909         IERC721Burn(artVialNFTAddress).burn(artVialTokenId);
1910         userNftId[msg.sender].push(phase1TokenId);
1911         _safeMint(msg.sender, phase1TokenId);
1912     }
1913 
1914     function setToggle(bool toggle_) external onlyOwner{
1915         toggle = toggle_;
1916     }
1917 
1918     /* 
1919     @dev Emergency function: that will update phase1 & art-vial token address
1920     @params B&O DNA Collection:Phase1 and Art Vial deployed contract address
1921     */
1922     function updatePhaseAddresses(address phase1Address_, address artVialAddress_) external onlyOwner{
1923         require(phase1Address_ != address(0), "Phase2: Phase1 address cannot be zero address");
1924         require(artVialAddress_ != address(0), "Phase2: Art Vial address cannot be zero address");
1925         phase1NFTAddress = phase1Address_;
1926         artVialNFTAddress = artVialAddress_;
1927     }
1928 
1929     /* 
1930     @dev This function will set the time after which User can claim their vials
1931     @params EpochTime when to start claim
1932     */
1933     function setRevelTimer(uint256 revealTime_) external onlyOwner{
1934         revealTime = revealTime_;
1935         emit revealTimer(revealTime);
1936     }
1937 
1938     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721,IERC721) onlyAllowedOperator(from) {
1939         require(_isApprovedOrOwner(_msgSender(), tokenId),"Phase3: transfer caller is not owner nor approved");
1940         for (uint256 i; i < userNftId[from].length; i++) {
1941             if (userNftId[from][i] == tokenId) {
1942                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
1943                 userNftId[from].pop();
1944                 userNftId[to].push(tokenId);
1945                 break;
1946             }
1947         }
1948         _transfer(from, to, tokenId);
1949     }
1950 
1951     function safeTransferFrom(address from,address to,uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from)  {
1952         for (uint256 i; i < userNftId[from].length; i++) {
1953             if (userNftId[from][i] == tokenId) {
1954                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
1955                 userNftId[from].pop();
1956                 userNftId[to].push(tokenId);
1957                 break;
1958             }
1959         }
1960         safeTransferFrom(from, to, tokenId, "");
1961     }
1962 
1963     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override(ERC721, IERC721) onlyAllowedOperator(from)  {
1964         require(_isApprovedOrOwner(_msgSender(), tokenId),"Phase2: transfer caller is not owner nor approved");
1965         for (uint256 i; i < userNftId[from].length; i++) {
1966             if (userNftId[from][i] == tokenId) {
1967                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
1968                 userNftId[from].pop();
1969                 userNftId[to].push(tokenId);
1970                 break;
1971             }
1972         }
1973         _safeTransfer(from, to, tokenId, _data);
1974     }
1975 
1976     function nftOfUser(address user)public view returns(uint256[] memory){
1977         return userNftId[user];
1978     }
1979 
1980     function burn(uint256 tokenId) public virtual override{
1981         //solhint-disable-next-line max-line-length
1982         _burn(tokenId);
1983     }
1984 
1985     function _burn(uint256 _tokenId) internal override(ERC721) {
1986         require(_isApprovedOrOwner(_msgSender(), _tokenId), "Phase2: caller is not token owner nor approved");
1987         address tokenOwner = ownerOf(_tokenId); 
1988          for (uint256 i; i < userNftId[tokenOwner].length; i++) {
1989             if (userNftId[tokenOwner][i] == _tokenId) {
1990                 userNftId[tokenOwner][i] = userNftId[tokenOwner][userNftId[tokenOwner].length - 1];
1991                 userNftId[tokenOwner].pop();
1992                 break;
1993             }
1994         }
1995         super._burn(_tokenId);
1996     }
1997 
1998     function updateURI(string memory newURI_) external onlyOwner{
1999         URI = newURI_;
2000     }
2001 
2002     function _baseURI() internal view override returns (string memory) {
2003         return URI;
2004     }
2005 
2006    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
2007         internal
2008         override(ERC721, ERC721Enumerable)
2009     {
2010         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2011     }
2012 
2013 
2014     function supportsInterface(bytes4 interfaceId)
2015         public
2016         view
2017         override(ERC721, ERC721Enumerable)
2018         returns (bool)
2019     {
2020         return super.supportsInterface(interfaceId);
2021     }
2022 
2023 }