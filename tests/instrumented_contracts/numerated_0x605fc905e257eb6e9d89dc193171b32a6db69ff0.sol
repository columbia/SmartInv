1 // SPDX-License-Identifier: MIT
2 // File: Interfaces/IERC721Burn.sol
3 
4 
5 pragma solidity ^0.8.13;
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
105 // File: @openzeppelin/contracts/utils/Counters.sol
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @title Counters
114  * @author Matt Condon (@shrugs)
115  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
116  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
117  *
118  * Include with `using Counters for Counters.Counter;`
119  */
120 library Counters {
121     struct Counter {
122         // This variable should never be directly accessed by users of the library: interactions must be restricted to
123         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
124         // this feature: see https://github.com/ethereum/solidity/issues/4637
125         uint256 _value; // default: 0
126     }
127 
128     function current(Counter storage counter) internal view returns (uint256) {
129         return counter._value;
130     }
131 
132     function increment(Counter storage counter) internal {
133         unchecked {
134             counter._value += 1;
135         }
136     }
137 
138     function decrement(Counter storage counter) internal {
139         uint256 value = counter._value;
140         require(value > 0, "Counter: decrement overflow");
141         unchecked {
142             counter._value = value - 1;
143         }
144     }
145 
146     function reset(Counter storage counter) internal {
147         counter._value = 0;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/math/Math.sol
152 
153 
154 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev Standard math utilities missing in the Solidity language.
160  */
161 library Math {
162     enum Rounding {
163         Down, // Toward negative infinity
164         Up, // Toward infinity
165         Zero // Toward zero
166     }
167 
168     /**
169      * @dev Returns the largest of two numbers.
170      */
171     function max(uint256 a, uint256 b) internal pure returns (uint256) {
172         return a > b ? a : b;
173     }
174 
175     /**
176      * @dev Returns the smallest of two numbers.
177      */
178     function min(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a < b ? a : b;
180     }
181 
182     /**
183      * @dev Returns the average of two numbers. The result is rounded towards
184      * zero.
185      */
186     function average(uint256 a, uint256 b) internal pure returns (uint256) {
187         // (a + b) / 2 can overflow.
188         return (a & b) + (a ^ b) / 2;
189     }
190 
191     /**
192      * @dev Returns the ceiling of the division of two numbers.
193      *
194      * This differs from standard division with `/` in that it rounds up instead
195      * of rounding down.
196      */
197     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
198         // (a + b - 1) / b can overflow on addition, so we distribute.
199         return a == 0 ? 0 : (a - 1) / b + 1;
200     }
201 
202     /**
203      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
204      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
205      * with further edits by Uniswap Labs also under MIT license.
206      */
207     function mulDiv(
208         uint256 x,
209         uint256 y,
210         uint256 denominator
211     ) internal pure returns (uint256 result) {
212         unchecked {
213             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
214             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
215             // variables such that product = prod1 * 2^256 + prod0.
216             uint256 prod0; // Least significant 256 bits of the product
217             uint256 prod1; // Most significant 256 bits of the product
218             assembly {
219                 let mm := mulmod(x, y, not(0))
220                 prod0 := mul(x, y)
221                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
222             }
223 
224             // Handle non-overflow cases, 256 by 256 division.
225             if (prod1 == 0) {
226                 return prod0 / denominator;
227             }
228 
229             // Make sure the result is less than 2^256. Also prevents denominator == 0.
230             require(denominator > prod1);
231 
232             ///////////////////////////////////////////////
233             // 512 by 256 division.
234             ///////////////////////////////////////////////
235 
236             // Make division exact by subtracting the remainder from [prod1 prod0].
237             uint256 remainder;
238             assembly {
239                 // Compute remainder using mulmod.
240                 remainder := mulmod(x, y, denominator)
241 
242                 // Subtract 256 bit number from 512 bit number.
243                 prod1 := sub(prod1, gt(remainder, prod0))
244                 prod0 := sub(prod0, remainder)
245             }
246 
247             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
248             // See https://cs.stackexchange.com/q/138556/92363.
249 
250             // Does not overflow because the denominator cannot be zero at this stage in the function.
251             uint256 twos = denominator & (~denominator + 1);
252             assembly {
253                 // Divide denominator by twos.
254                 denominator := div(denominator, twos)
255 
256                 // Divide [prod1 prod0] by twos.
257                 prod0 := div(prod0, twos)
258 
259                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
260                 twos := add(div(sub(0, twos), twos), 1)
261             }
262 
263             // Shift in bits from prod1 into prod0.
264             prod0 |= prod1 * twos;
265 
266             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
267             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
268             // four bits. That is, denominator * inv = 1 mod 2^4.
269             uint256 inverse = (3 * denominator) ^ 2;
270 
271             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
272             // in modular arithmetic, doubling the correct bits in each step.
273             inverse *= 2 - denominator * inverse; // inverse mod 2^8
274             inverse *= 2 - denominator * inverse; // inverse mod 2^16
275             inverse *= 2 - denominator * inverse; // inverse mod 2^32
276             inverse *= 2 - denominator * inverse; // inverse mod 2^64
277             inverse *= 2 - denominator * inverse; // inverse mod 2^128
278             inverse *= 2 - denominator * inverse; // inverse mod 2^256
279 
280             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
281             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
282             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
283             // is no longer required.
284             result = prod0 * inverse;
285             return result;
286         }
287     }
288 
289     /**
290      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
291      */
292     function mulDiv(
293         uint256 x,
294         uint256 y,
295         uint256 denominator,
296         Rounding rounding
297     ) internal pure returns (uint256) {
298         uint256 result = mulDiv(x, y, denominator);
299         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
300             result += 1;
301         }
302         return result;
303     }
304 
305     /**
306      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
307      *
308      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
309      */
310     function sqrt(uint256 a) internal pure returns (uint256) {
311         if (a == 0) {
312             return 0;
313         }
314 
315         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
316         //
317         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
318         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
319         //
320         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
321         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
322         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
323         //
324         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
325         uint256 result = 1 << (log2(a) >> 1);
326 
327         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
328         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
329         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
330         // into the expected uint128 result.
331         unchecked {
332             result = (result + a / result) >> 1;
333             result = (result + a / result) >> 1;
334             result = (result + a / result) >> 1;
335             result = (result + a / result) >> 1;
336             result = (result + a / result) >> 1;
337             result = (result + a / result) >> 1;
338             result = (result + a / result) >> 1;
339             return min(result, a / result);
340         }
341     }
342 
343     /**
344      * @notice Calculates sqrt(a), following the selected rounding direction.
345      */
346     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
347         unchecked {
348             uint256 result = sqrt(a);
349             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
350         }
351     }
352 
353     /**
354      * @dev Return the log in base 2, rounded down, of a positive value.
355      * Returns 0 if given 0.
356      */
357     function log2(uint256 value) internal pure returns (uint256) {
358         uint256 result = 0;
359         unchecked {
360             if (value >> 128 > 0) {
361                 value >>= 128;
362                 result += 128;
363             }
364             if (value >> 64 > 0) {
365                 value >>= 64;
366                 result += 64;
367             }
368             if (value >> 32 > 0) {
369                 value >>= 32;
370                 result += 32;
371             }
372             if (value >> 16 > 0) {
373                 value >>= 16;
374                 result += 16;
375             }
376             if (value >> 8 > 0) {
377                 value >>= 8;
378                 result += 8;
379             }
380             if (value >> 4 > 0) {
381                 value >>= 4;
382                 result += 4;
383             }
384             if (value >> 2 > 0) {
385                 value >>= 2;
386                 result += 2;
387             }
388             if (value >> 1 > 0) {
389                 result += 1;
390             }
391         }
392         return result;
393     }
394 
395     /**
396      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
397      * Returns 0 if given 0.
398      */
399     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
400         unchecked {
401             uint256 result = log2(value);
402             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
403         }
404     }
405 
406     /**
407      * @dev Return the log in base 10, rounded down, of a positive value.
408      * Returns 0 if given 0.
409      */
410     function log10(uint256 value) internal pure returns (uint256) {
411         uint256 result = 0;
412         unchecked {
413             if (value >= 10**64) {
414                 value /= 10**64;
415                 result += 64;
416             }
417             if (value >= 10**32) {
418                 value /= 10**32;
419                 result += 32;
420             }
421             if (value >= 10**16) {
422                 value /= 10**16;
423                 result += 16;
424             }
425             if (value >= 10**8) {
426                 value /= 10**8;
427                 result += 8;
428             }
429             if (value >= 10**4) {
430                 value /= 10**4;
431                 result += 4;
432             }
433             if (value >= 10**2) {
434                 value /= 10**2;
435                 result += 2;
436             }
437             if (value >= 10**1) {
438                 result += 1;
439             }
440         }
441         return result;
442     }
443 
444     /**
445      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
446      * Returns 0 if given 0.
447      */
448     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
449         unchecked {
450             uint256 result = log10(value);
451             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
452         }
453     }
454 
455     /**
456      * @dev Return the log in base 256, rounded down, of a positive value.
457      * Returns 0 if given 0.
458      *
459      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
460      */
461     function log256(uint256 value) internal pure returns (uint256) {
462         uint256 result = 0;
463         unchecked {
464             if (value >> 128 > 0) {
465                 value >>= 128;
466                 result += 16;
467             }
468             if (value >> 64 > 0) {
469                 value >>= 64;
470                 result += 8;
471             }
472             if (value >> 32 > 0) {
473                 value >>= 32;
474                 result += 4;
475             }
476             if (value >> 16 > 0) {
477                 value >>= 16;
478                 result += 2;
479             }
480             if (value >> 8 > 0) {
481                 result += 1;
482             }
483         }
484         return result;
485     }
486 
487     /**
488      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
489      * Returns 0 if given 0.
490      */
491     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
492         unchecked {
493             uint256 result = log256(value);
494             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
495         }
496     }
497 }
498 
499 // File: @openzeppelin/contracts/utils/Strings.sol
500 
501 
502 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev String operations.
509  */
510 library Strings {
511     bytes16 private constant _SYMBOLS = "0123456789abcdef";
512     uint8 private constant _ADDRESS_LENGTH = 20;
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
516      */
517     function toString(uint256 value) internal pure returns (string memory) {
518         unchecked {
519             uint256 length = Math.log10(value) + 1;
520             string memory buffer = new string(length);
521             uint256 ptr;
522             /// @solidity memory-safe-assembly
523             assembly {
524                 ptr := add(buffer, add(32, length))
525             }
526             while (true) {
527                 ptr--;
528                 /// @solidity memory-safe-assembly
529                 assembly {
530                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
531                 }
532                 value /= 10;
533                 if (value == 0) break;
534             }
535             return buffer;
536         }
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
541      */
542     function toHexString(uint256 value) internal pure returns (string memory) {
543         unchecked {
544             return toHexString(value, Math.log256(value) + 1);
545         }
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
552         bytes memory buffer = new bytes(2 * length + 2);
553         buffer[0] = "0";
554         buffer[1] = "x";
555         for (uint256 i = 2 * length + 1; i > 1; --i) {
556             buffer[i] = _SYMBOLS[value & 0xf];
557             value >>= 4;
558         }
559         require(value == 0, "Strings: hex length insufficient");
560         return string(buffer);
561     }
562 
563     /**
564      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
565      */
566     function toHexString(address addr) internal pure returns (string memory) {
567         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
568     }
569 }
570 
571 // File: @openzeppelin/contracts/utils/Context.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev Provides information about the current execution context, including the
580  * sender of the transaction and its data. While these are generally available
581  * via msg.sender and msg.data, they should not be accessed in such a direct
582  * manner, since when dealing with meta-transactions the account sending and
583  * paying for execution may not be the actual sender (as far as an application
584  * is concerned).
585  *
586  * This contract is only required for intermediate, library-like contracts.
587  */
588 abstract contract Context {
589     function _msgSender() internal view virtual returns (address) {
590         return msg.sender;
591     }
592 
593     function _msgData() internal view virtual returns (bytes calldata) {
594         return msg.data;
595     }
596 }
597 
598 // File: @openzeppelin/contracts/access/Ownable.sol
599 
600 
601 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @dev Contract module which provides a basic access control mechanism, where
608  * there is an account (an owner) that can be granted exclusive access to
609  * specific functions.
610  *
611  * By default, the owner account will be the one that deploys the contract. This
612  * can later be changed with {transferOwnership}.
613  *
614  * This module is used through inheritance. It will make available the modifier
615  * `onlyOwner`, which can be applied to your functions to restrict their use to
616  * the owner.
617  */
618 abstract contract Ownable is Context {
619     address private _owner;
620 
621     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
622 
623     /**
624      * @dev Initializes the contract setting the deployer as the initial owner.
625      */
626     constructor() {
627         _transferOwnership(_msgSender());
628     }
629 
630     /**
631      * @dev Throws if called by any account other than the owner.
632      */
633     modifier onlyOwner() {
634         _checkOwner();
635         _;
636     }
637 
638     /**
639      * @dev Returns the address of the current owner.
640      */
641     function owner() public view virtual returns (address) {
642         return _owner;
643     }
644 
645     /**
646      * @dev Throws if the sender is not the owner.
647      */
648     function _checkOwner() internal view virtual {
649         require(owner() == _msgSender(), "Ownable: caller is not the owner");
650     }
651 
652     /**
653      * @dev Leaves the contract without owner. It will not be possible to call
654      * `onlyOwner` functions anymore. Can only be called by the current owner.
655      *
656      * NOTE: Renouncing ownership will leave the contract without an owner,
657      * thereby removing any functionality that is only available to the owner.
658      */
659     function renounceOwnership() public virtual onlyOwner {
660         _transferOwnership(address(0));
661     }
662 
663     /**
664      * @dev Transfers ownership of the contract to a new account (`newOwner`).
665      * Can only be called by the current owner.
666      */
667     function transferOwnership(address newOwner) public virtual onlyOwner {
668         require(newOwner != address(0), "Ownable: new owner is the zero address");
669         _transferOwnership(newOwner);
670     }
671 
672     /**
673      * @dev Transfers ownership of the contract to a new account (`newOwner`).
674      * Internal function without access restriction.
675      */
676     function _transferOwnership(address newOwner) internal virtual {
677         address oldOwner = _owner;
678         _owner = newOwner;
679         emit OwnershipTransferred(oldOwner, newOwner);
680     }
681 }
682 
683 // File: @openzeppelin/contracts/utils/Address.sol
684 
685 
686 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
687 
688 pragma solidity ^0.8.1;
689 
690 /**
691  * @dev Collection of functions related to the address type
692  */
693 library Address {
694     /**
695      * @dev Returns true if `account` is a contract.
696      *
697      * [IMPORTANT]
698      * ====
699      * It is unsafe to assume that an address for which this function returns
700      * false is an externally-owned account (EOA) and not a contract.
701      *
702      * Among others, `isContract` will return false for the following
703      * types of addresses:
704      *
705      *  - an externally-owned account
706      *  - a contract in construction
707      *  - an address where a contract will be created
708      *  - an address where a contract lived, but was destroyed
709      * ====
710      *
711      * [IMPORTANT]
712      * ====
713      * You shouldn't rely on `isContract` to protect against flash loan attacks!
714      *
715      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
716      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
717      * constructor.
718      * ====
719      */
720     function isContract(address account) internal view returns (bool) {
721         // This method relies on extcodesize/address.code.length, which returns 0
722         // for contracts in construction, since the code is only stored at the end
723         // of the constructor execution.
724 
725         return account.code.length > 0;
726     }
727 
728     /**
729      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
730      * `recipient`, forwarding all available gas and reverting on errors.
731      *
732      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
733      * of certain opcodes, possibly making contracts go over the 2300 gas limit
734      * imposed by `transfer`, making them unable to receive funds via
735      * `transfer`. {sendValue} removes this limitation.
736      *
737      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
738      *
739      * IMPORTANT: because control is transferred to `recipient`, care must be
740      * taken to not create reentrancy vulnerabilities. Consider using
741      * {ReentrancyGuard} or the
742      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
743      */
744     function sendValue(address payable recipient, uint256 amount) internal {
745         require(address(this).balance >= amount, "Address: insufficient balance");
746 
747         (bool success, ) = recipient.call{value: amount}("");
748         require(success, "Address: unable to send value, recipient may have reverted");
749     }
750 
751     /**
752      * @dev Performs a Solidity function call using a low level `call`. A
753      * plain `call` is an unsafe replacement for a function call: use this
754      * function instead.
755      *
756      * If `target` reverts with a revert reason, it is bubbled up by this
757      * function (like regular Solidity function calls).
758      *
759      * Returns the raw returned data. To convert to the expected return value,
760      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
761      *
762      * Requirements:
763      *
764      * - `target` must be a contract.
765      * - calling `target` with `data` must not revert.
766      *
767      * _Available since v3.1._
768      */
769     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
770         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
775      * `errorMessage` as a fallback revert reason when `target` reverts.
776      *
777      * _Available since v3.1._
778      */
779     function functionCall(
780         address target,
781         bytes memory data,
782         string memory errorMessage
783     ) internal returns (bytes memory) {
784         return functionCallWithValue(target, data, 0, errorMessage);
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
789      * but also transferring `value` wei to `target`.
790      *
791      * Requirements:
792      *
793      * - the calling contract must have an ETH balance of at least `value`.
794      * - the called Solidity function must be `payable`.
795      *
796      * _Available since v3.1._
797      */
798     function functionCallWithValue(
799         address target,
800         bytes memory data,
801         uint256 value
802     ) internal returns (bytes memory) {
803         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
808      * with `errorMessage` as a fallback revert reason when `target` reverts.
809      *
810      * _Available since v3.1._
811      */
812     function functionCallWithValue(
813         address target,
814         bytes memory data,
815         uint256 value,
816         string memory errorMessage
817     ) internal returns (bytes memory) {
818         require(address(this).balance >= value, "Address: insufficient balance for call");
819         (bool success, bytes memory returndata) = target.call{value: value}(data);
820         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
825      * but performing a static call.
826      *
827      * _Available since v3.3._
828      */
829     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
830         return functionStaticCall(target, data, "Address: low-level static call failed");
831     }
832 
833     /**
834      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
835      * but performing a static call.
836      *
837      * _Available since v3.3._
838      */
839     function functionStaticCall(
840         address target,
841         bytes memory data,
842         string memory errorMessage
843     ) internal view returns (bytes memory) {
844         (bool success, bytes memory returndata) = target.staticcall(data);
845         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
846     }
847 
848     /**
849      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
850      * but performing a delegate call.
851      *
852      * _Available since v3.4._
853      */
854     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
855         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
856     }
857 
858     /**
859      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
860      * but performing a delegate call.
861      *
862      * _Available since v3.4._
863      */
864     function functionDelegateCall(
865         address target,
866         bytes memory data,
867         string memory errorMessage
868     ) internal returns (bytes memory) {
869         (bool success, bytes memory returndata) = target.delegatecall(data);
870         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
871     }
872 
873     /**
874      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
875      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
876      *
877      * _Available since v4.8._
878      */
879     function verifyCallResultFromTarget(
880         address target,
881         bool success,
882         bytes memory returndata,
883         string memory errorMessage
884     ) internal view returns (bytes memory) {
885         if (success) {
886             if (returndata.length == 0) {
887                 // only check isContract if the call was successful and the return data is empty
888                 // otherwise we already know that it was a contract
889                 require(isContract(target), "Address: call to non-contract");
890             }
891             return returndata;
892         } else {
893             _revert(returndata, errorMessage);
894         }
895     }
896 
897     /**
898      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
899      * revert reason or using the provided one.
900      *
901      * _Available since v4.3._
902      */
903     function verifyCallResult(
904         bool success,
905         bytes memory returndata,
906         string memory errorMessage
907     ) internal pure returns (bytes memory) {
908         if (success) {
909             return returndata;
910         } else {
911             _revert(returndata, errorMessage);
912         }
913     }
914 
915     function _revert(bytes memory returndata, string memory errorMessage) private pure {
916         // Look for revert reason and bubble it up if present
917         if (returndata.length > 0) {
918             // The easiest way to bubble the revert reason is using memory via assembly
919             /// @solidity memory-safe-assembly
920             assembly {
921                 let returndata_size := mload(returndata)
922                 revert(add(32, returndata), returndata_size)
923             }
924         } else {
925             revert(errorMessage);
926         }
927     }
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
931 
932 
933 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 /**
938  * @title ERC721 token receiver interface
939  * @dev Interface for any contract that wants to support safeTransfers
940  * from ERC721 asset contracts.
941  */
942 interface IERC721Receiver {
943     /**
944      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
945      * by `operator` from `from`, this function is called.
946      *
947      * It must return its Solidity selector to confirm the token transfer.
948      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
949      *
950      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
951      */
952     function onERC721Received(
953         address operator,
954         address from,
955         uint256 tokenId,
956         bytes calldata data
957     ) external returns (bytes4);
958 }
959 
960 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
961 
962 
963 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 /**
968  * @dev Interface of the ERC165 standard, as defined in the
969  * https://eips.ethereum.org/EIPS/eip-165[EIP].
970  *
971  * Implementers can declare support of contract interfaces, which can then be
972  * queried by others ({ERC165Checker}).
973  *
974  * For an implementation, see {ERC165}.
975  */
976 interface IERC165 {
977     /**
978      * @dev Returns true if this contract implements the interface defined by
979      * `interfaceId`. See the corresponding
980      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
981      * to learn more about how these ids are created.
982      *
983      * This function call must use less than 30 000 gas.
984      */
985     function supportsInterface(bytes4 interfaceId) external view returns (bool);
986 }
987 
988 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
989 
990 
991 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
992 
993 pragma solidity ^0.8.0;
994 
995 
996 /**
997  * @dev Implementation of the {IERC165} interface.
998  *
999  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1000  * for the additional interface id that will be supported. For example:
1001  *
1002  * ```solidity
1003  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1004  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1005  * }
1006  * ```
1007  *
1008  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1009  */
1010 abstract contract ERC165 is IERC165 {
1011     /**
1012      * @dev See {IERC165-supportsInterface}.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1015         return interfaceId == type(IERC165).interfaceId;
1016     }
1017 }
1018 
1019 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1020 
1021 
1022 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 /**
1028  * @dev Required interface of an ERC721 compliant contract.
1029  */
1030 interface IERC721 is IERC165 {
1031     /**
1032      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1033      */
1034     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1035 
1036     /**
1037      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1038      */
1039     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1040 
1041     /**
1042      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1043      */
1044     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1045 
1046     /**
1047      * @dev Returns the number of tokens in ``owner``'s account.
1048      */
1049     function balanceOf(address owner) external view returns (uint256 balance);
1050 
1051     /**
1052      * @dev Returns the owner of the `tokenId` token.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function ownerOf(uint256 tokenId) external view returns (address owner);
1059 
1060     /**
1061      * @dev Safely transfers `tokenId` token from `from` to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - `from` cannot be the zero address.
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must exist and be owned by `from`.
1068      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1069      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes calldata data
1078     ) external;
1079 
1080     /**
1081      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1082      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1083      *
1084      * Requirements:
1085      *
1086      * - `from` cannot be the zero address.
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must exist and be owned by `from`.
1089      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1090      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function safeTransferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) external;
1099 
1100     /**
1101      * @dev Transfers `tokenId` token from `from` to `to`.
1102      *
1103      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1104      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1105      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1106      *
1107      * Requirements:
1108      *
1109      * - `from` cannot be the zero address.
1110      * - `to` cannot be the zero address.
1111      * - `tokenId` token must be owned by `from`.
1112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function transferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) external;
1121 
1122     /**
1123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1124      * The approval is cleared when the token is transferred.
1125      *
1126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1127      *
1128      * Requirements:
1129      *
1130      * - The caller must own the token or be an approved operator.
1131      * - `tokenId` must exist.
1132      *
1133      * Emits an {Approval} event.
1134      */
1135     function approve(address to, uint256 tokenId) external;
1136 
1137     /**
1138      * @dev Approve or remove `operator` as an operator for the caller.
1139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1140      *
1141      * Requirements:
1142      *
1143      * - The `operator` cannot be the caller.
1144      *
1145      * Emits an {ApprovalForAll} event.
1146      */
1147     function setApprovalForAll(address operator, bool _approved) external;
1148 
1149     /**
1150      * @dev Returns the account approved for `tokenId` token.
1151      *
1152      * Requirements:
1153      *
1154      * - `tokenId` must exist.
1155      */
1156     function getApproved(uint256 tokenId) external view returns (address operator);
1157 
1158     /**
1159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1160      *
1161      * See {setApprovalForAll}
1162      */
1163     function isApprovedForAll(address owner, address operator) external view returns (bool);
1164 }
1165 
1166 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1167 
1168 
1169 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 
1174 /**
1175  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1176  * @dev See https://eips.ethereum.org/EIPS/eip-721
1177  */
1178 interface IERC721Enumerable is IERC721 {
1179     /**
1180      * @dev Returns the total amount of tokens stored by the contract.
1181      */
1182     function totalSupply() external view returns (uint256);
1183 
1184     /**
1185      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1186      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1187      */
1188     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1189 
1190     /**
1191      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1192      * Use along with {totalSupply} to enumerate all tokens.
1193      */
1194     function tokenByIndex(uint256 index) external view returns (uint256);
1195 }
1196 
1197 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1198 
1199 
1200 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 
1205 /**
1206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1207  * @dev See https://eips.ethereum.org/EIPS/eip-721
1208  */
1209 interface IERC721Metadata is IERC721 {
1210     /**
1211      * @dev Returns the token collection name.
1212      */
1213     function name() external view returns (string memory);
1214 
1215     /**
1216      * @dev Returns the token collection symbol.
1217      */
1218     function symbol() external view returns (string memory);
1219 
1220     /**
1221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1222      */
1223     function tokenURI(uint256 tokenId) external view returns (string memory);
1224 }
1225 
1226 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1227 
1228 
1229 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 
1234 
1235 
1236 
1237 
1238 
1239 
1240 /**
1241  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1242  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1243  * {ERC721Enumerable}.
1244  */
1245 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1246     using Address for address;
1247     using Strings for uint256;
1248 
1249     // Token name
1250     string private _name;
1251 
1252     // Token symbol
1253     string private _symbol;
1254 
1255     // Mapping from token ID to owner address
1256     mapping(uint256 => address) public _owners;
1257 
1258     // Mapping owner address to token count
1259     mapping(address => uint256) private _balances;
1260 
1261     // Mapping from token ID to approved address
1262     mapping(uint256 => address) private _tokenApprovals;
1263 
1264     // Mapping from owner to operator approvals
1265     mapping(address => mapping(address => bool)) private _operatorApprovals;
1266 
1267     /**
1268      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1269      */
1270     constructor(string memory name_, string memory symbol_) {
1271         _name = name_;
1272         _symbol = symbol_;
1273     }
1274 
1275     /**
1276      * @dev See {IERC165-supportsInterface}.
1277      */
1278     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1279         return
1280             interfaceId == type(IERC721).interfaceId ||
1281             interfaceId == type(IERC721Metadata).interfaceId ||
1282             super.supportsInterface(interfaceId);
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-balanceOf}.
1287      */
1288     function balanceOf(address owner) public view virtual override returns (uint256) {
1289         require(owner != address(0), "ERC721: address zero is not a valid owner");
1290         return _balances[owner];
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-ownerOf}.
1295      */
1296     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1297         address owner = _ownerOf(tokenId);
1298         require(owner != address(0), "ERC721: invalid token ID");
1299         return owner;
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Metadata-name}.
1304      */
1305     function name() public view virtual override returns (string memory) {
1306         return _name;
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Metadata-symbol}.
1311      */
1312     function symbol() public view virtual override returns (string memory) {
1313         return _symbol;
1314     }
1315 
1316     /**
1317      * @dev See {IERC721Metadata-tokenURI}.
1318      */
1319     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1320         _requireMinted(tokenId);
1321 
1322         string memory baseURI = _baseURI();
1323         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1324     }
1325 
1326     /**
1327      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1328      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1329      * by default, can be overridden in child contracts.
1330      */
1331     function _baseURI() internal view virtual returns (string memory) {
1332         return "";
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-approve}.
1337      */
1338     function approve(address to, uint256 tokenId) public virtual override {
1339         address owner = ERC721.ownerOf(tokenId);
1340         require(to != owner, "ERC721: approval to current owner");
1341 
1342         require(
1343             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1344             "ERC721: approve caller is not token owner or approved for all"
1345         );
1346 
1347         _approve(to, tokenId);
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-getApproved}.
1352      */
1353     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1354         _requireMinted(tokenId);
1355 
1356         return _tokenApprovals[tokenId];
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-setApprovalForAll}.
1361      */
1362     function setApprovalForAll(address operator, bool approved) public virtual override {
1363         _setApprovalForAll(_msgSender(), operator, approved);
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-isApprovedForAll}.
1368      */
1369     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1370         return _operatorApprovals[owner][operator];
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-transferFrom}.
1375      */
1376     function transferFrom(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) public virtual override {
1381         //solhint-disable-next-line max-line-length
1382         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1383 
1384         _transfer(from, to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev See {IERC721-safeTransferFrom}.
1389      */
1390     function safeTransferFrom(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) public virtual override {
1395         safeTransferFrom(from, to, tokenId, "");
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-safeTransferFrom}.
1400      */
1401     function safeTransferFrom(
1402         address from,
1403         address to,
1404         uint256 tokenId,
1405         bytes memory data
1406     ) public virtual override {
1407         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1408         _safeTransfer(from, to, tokenId, data);
1409     }
1410 
1411     /**
1412      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1413      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1414      *
1415      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1416      *
1417      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1418      * implement alternative mechanisms to perform token transfer, such as signature-based.
1419      *
1420      * Requirements:
1421      *
1422      * - `from` cannot be the zero address.
1423      * - `to` cannot be the zero address.
1424      * - `tokenId` token must exist and be owned by `from`.
1425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _safeTransfer(
1430         address from,
1431         address to,
1432         uint256 tokenId,
1433         bytes memory data
1434     ) internal virtual {
1435         _transfer(from, to, tokenId);
1436         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1437     }
1438 
1439     /**
1440      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1441      */
1442     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1443         return _owners[tokenId];
1444     }
1445 
1446     /**
1447      * @dev Returns whether `tokenId` exists.
1448      *
1449      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1450      *
1451      * Tokens start existing when they are minted (`_mint`),
1452      * and stop existing when they are burned (`_burn`).
1453      */
1454     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1455         return _ownerOf(tokenId) != address(0);
1456     }
1457 
1458     /**
1459      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1460      *
1461      * Requirements:
1462      *
1463      * - `tokenId` must exist.
1464      */
1465     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1466         address owner = ERC721.ownerOf(tokenId);
1467         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1468     }
1469 
1470     /**
1471      * @dev Safely mints `tokenId` and transfers it to `to`.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must not exist.
1476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _safeMint(address to, uint256 tokenId) internal virtual {
1481         _safeMint(to, tokenId, "");
1482     }
1483 
1484     /**
1485      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1486      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1487      */
1488     function _safeMint(
1489         address to,
1490         uint256 tokenId,
1491         bytes memory data
1492     ) internal virtual {
1493         _mint(to, tokenId);
1494         require(
1495             _checkOnERC721Received(address(0), to, tokenId, data),
1496             "ERC721: transfer to non ERC721Receiver implementer"
1497         );
1498     }
1499 
1500     /**
1501      * @dev Mints `tokenId` and transfers it to `to`.
1502      *
1503      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1504      *
1505      * Requirements:
1506      *
1507      * - `tokenId` must not exist.
1508      * - `to` cannot be the zero address.
1509      *
1510      * Emits a {Transfer} event.
1511      */
1512     function _mint(address to, uint256 tokenId) internal virtual {
1513         require(to != address(0), "ERC721: mint to the zero address");
1514         require(!_exists(tokenId), "ERC721: token already minted");
1515 
1516         _beforeTokenTransfer(address(0), to, tokenId, 1);
1517 
1518         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1519         require(!_exists(tokenId), "ERC721: token already minted");
1520 
1521         unchecked {
1522             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1523             // Given that tokens are minted one by one, it is impossible in practice that
1524             // this ever happens. Might change if we allow batch minting.
1525             // The ERC fails to describe this case.
1526             _balances[to] += 1;
1527         }
1528 
1529         _owners[tokenId] = to;
1530 
1531         emit Transfer(address(0), to, tokenId);
1532 
1533         _afterTokenTransfer(address(0), to, tokenId, 1);
1534     }
1535 
1536     /**
1537      * @dev Destroys `tokenId`.
1538      * The approval is cleared when the token is burned.
1539      * This is an internal function that does not check if the sender is authorized to operate on the token.
1540      *
1541      * Requirements:
1542      *
1543      * - `tokenId` must exist.
1544      *
1545      * Emits a {Transfer} event.
1546      */
1547     function _burn(uint256 tokenId) internal virtual {
1548         address owner = ERC721.ownerOf(tokenId);
1549 
1550         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1551 
1552         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1553         owner = ERC721.ownerOf(tokenId);
1554 
1555         // Clear approvals
1556         delete _tokenApprovals[tokenId];
1557 
1558         unchecked {
1559             // Cannot overflow, as that would require more tokens to be burned/transferred
1560             // out than the owner initially received through minting and transferring in.
1561             _balances[owner] -= 1;
1562         }
1563         delete _owners[tokenId];
1564 
1565         emit Transfer(owner, address(0), tokenId);
1566 
1567         _afterTokenTransfer(owner, address(0), tokenId, 1);
1568     }
1569 
1570     /**
1571      * @dev Transfers `tokenId` from `from` to `to`.
1572      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1573      *
1574      * Requirements:
1575      *
1576      * - `to` cannot be the zero address.
1577      * - `tokenId` token must be owned by `from`.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function _transfer(
1582         address from,
1583         address to,
1584         uint256 tokenId
1585     ) internal virtual {
1586         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1587         require(to != address(0), "ERC721: transfer to the zero address");
1588 
1589         _beforeTokenTransfer(from, to, tokenId, 1);
1590 
1591         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1592         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1593 
1594         // Clear approvals from the previous owner
1595         delete _tokenApprovals[tokenId];
1596 
1597         unchecked {
1598             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1599             // `from`'s balance is the number of token held, which is at least one before the current
1600             // transfer.
1601             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1602             // all 2**256 token ids to be minted, which in practice is impossible.
1603             _balances[from] -= 1;
1604             _balances[to] += 1;
1605         }
1606         _owners[tokenId] = to;
1607 
1608         emit Transfer(from, to, tokenId);
1609 
1610         _afterTokenTransfer(from, to, tokenId, 1);
1611     }
1612 
1613     /**
1614      * @dev Approve `to` to operate on `tokenId`
1615      *
1616      * Emits an {Approval} event.
1617      */
1618     function _approve(address to, uint256 tokenId) internal virtual {
1619         _tokenApprovals[tokenId] = to;
1620         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1621     }
1622 
1623     /**
1624      * @dev Approve `operator` to operate on all of `owner` tokens
1625      *
1626      * Emits an {ApprovalForAll} event.
1627      */
1628     function _setApprovalForAll(
1629         address owner,
1630         address operator,
1631         bool approved
1632     ) internal virtual {
1633         require(owner != operator, "ERC721: approve to caller");
1634         _operatorApprovals[owner][operator] = approved;
1635         emit ApprovalForAll(owner, operator, approved);
1636     }
1637 
1638     /**
1639      * @dev Reverts if the `tokenId` has not been minted yet.
1640      */
1641     function _requireMinted(uint256 tokenId) internal view virtual {
1642         require(_exists(tokenId), "ERC721: invalid token ID");
1643     }
1644 
1645     /**
1646      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1647      * The call is not executed if the target address is not a contract.
1648      *
1649      * @param from address representing the previous owner of the given token ID
1650      * @param to target address that will receive the tokens
1651      * @param tokenId uint256 ID of the token to be transferred
1652      * @param data bytes optional data to send along with the call
1653      * @return bool whether the call correctly returned the expected magic value
1654      */
1655     function _checkOnERC721Received(
1656         address from,
1657         address to,
1658         uint256 tokenId,
1659         bytes memory data
1660     ) private returns (bool) {
1661         if (to.isContract()) {
1662             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1663                 return retval == IERC721Receiver.onERC721Received.selector;
1664             } catch (bytes memory reason) {
1665                 if (reason.length == 0) {
1666                     revert("ERC721: transfer to non ERC721Receiver implementer");
1667                 } else {
1668                     /// @solidity memory-safe-assembly
1669                     assembly {
1670                         revert(add(32, reason), mload(reason))
1671                     }
1672                 }
1673             }
1674         } else {
1675             return true;
1676         }
1677     }
1678 
1679     /**
1680      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1681      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1682      *
1683      * Calling conditions:
1684      *
1685      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1686      * - When `from` is zero, the tokens will be minted for `to`.
1687      * - When `to` is zero, ``from``'s tokens will be burned.
1688      * - `from` and `to` are never both zero.
1689      * - `batchSize` is non-zero.
1690      *
1691      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1692      */
1693     function _beforeTokenTransfer(
1694         address from,
1695         address to,
1696         uint256, /* firstTokenId */
1697         uint256 batchSize
1698     ) internal virtual {
1699         if (batchSize > 1) {
1700             if (from != address(0)) {
1701                 _balances[from] -= batchSize;
1702             }
1703             if (to != address(0)) {
1704                 _balances[to] += batchSize;
1705             }
1706         }
1707     }
1708 
1709     /**
1710      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1711      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1712      *
1713      * Calling conditions:
1714      *
1715      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1716      * - When `from` is zero, the tokens were minted for `to`.
1717      * - When `to` is zero, ``from``'s tokens were burned.
1718      * - `from` and `to` are never both zero.
1719      * - `batchSize` is non-zero.
1720      *
1721      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1722      */
1723     function _afterTokenTransfer(
1724         address from,
1725         address to,
1726         uint256 firstTokenId,
1727         uint256 batchSize
1728     ) internal virtual {}
1729 }
1730 
1731 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1732 
1733 
1734 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 
1739 
1740 /**
1741  * @title ERC721 Burnable Token
1742  * @dev ERC721 Token that can be burned (destroyed).
1743  */
1744 abstract contract ERC721Burnable is Context, ERC721 {
1745     /**
1746      * @dev Burns `tokenId`. See {ERC721-_burn}.
1747      *
1748      * Requirements:
1749      *
1750      * - The caller must own `tokenId` or be an approved operator.
1751      */
1752     function burn(uint256 tokenId) public virtual {
1753         //solhint-disable-next-line max-line-length
1754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1755         _burn(tokenId);
1756     }
1757 }
1758 
1759 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1760 
1761 
1762 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1763 
1764 pragma solidity ^0.8.0;
1765 
1766 
1767 
1768 /**
1769  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1770  * enumerability of all the token ids in the contract as well as all token ids owned by each
1771  * account.
1772  */
1773 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1774     // Mapping from owner to list of owned token IDs
1775     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1776 
1777     // Mapping from token ID to index of the owner tokens list
1778     mapping(uint256 => uint256) private _ownedTokensIndex;
1779 
1780     // Array with all token ids, used for enumeration
1781     uint256[] private _allTokens;
1782 
1783     // Mapping from token id to position in the allTokens array
1784     mapping(uint256 => uint256) private _allTokensIndex;
1785 
1786     /**
1787      * @dev See {IERC165-supportsInterface}.
1788      */
1789     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1790         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1791     }
1792 
1793     /**
1794      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1795      */
1796     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1797         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1798         return _ownedTokens[owner][index];
1799     }
1800 
1801     /**
1802      * @dev See {IERC721Enumerable-totalSupply}.
1803      */
1804     function totalSupply() public view virtual override returns (uint256) {
1805         return _allTokens.length;
1806     }
1807 
1808     /**
1809      * @dev See {IERC721Enumerable-tokenByIndex}.
1810      */
1811     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1812         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1813         return _allTokens[index];
1814     }
1815 
1816     /**
1817      * @dev See {ERC721-_beforeTokenTransfer}.
1818      */
1819     function _beforeTokenTransfer(
1820         address from,
1821         address to,
1822         uint256 firstTokenId,
1823         uint256 batchSize
1824     ) internal virtual override {
1825         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1826 
1827         if (batchSize > 1) {
1828             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1829             revert("ERC721Enumerable: consecutive transfers not supported");
1830         }
1831 
1832         uint256 tokenId = firstTokenId;
1833 
1834         if (from == address(0)) {
1835             _addTokenToAllTokensEnumeration(tokenId);
1836         } else if (from != to) {
1837             _removeTokenFromOwnerEnumeration(from, tokenId);
1838         }
1839         if (to == address(0)) {
1840             _removeTokenFromAllTokensEnumeration(tokenId);
1841         } else if (to != from) {
1842             _addTokenToOwnerEnumeration(to, tokenId);
1843         }
1844     }
1845 
1846     /**
1847      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1848      * @param to address representing the new owner of the given token ID
1849      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1850      */
1851     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1852         uint256 length = ERC721.balanceOf(to);
1853         _ownedTokens[to][length] = tokenId;
1854         _ownedTokensIndex[tokenId] = length;
1855     }
1856 
1857     /**
1858      * @dev Private function to add a token to this extension's token tracking data structures.
1859      * @param tokenId uint256 ID of the token to be added to the tokens list
1860      */
1861     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1862         _allTokensIndex[tokenId] = _allTokens.length;
1863         _allTokens.push(tokenId);
1864     }
1865 
1866     /**
1867      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1868      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1869      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1870      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1871      * @param from address representing the previous owner of the given token ID
1872      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1873      */
1874     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1875         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1876         // then delete the last slot (swap and pop).
1877 
1878         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1879         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1880 
1881         // When the token to delete is the last token, the swap operation is unnecessary
1882         if (tokenIndex != lastTokenIndex) {
1883             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1884 
1885             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1886             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1887         }
1888 
1889         // This also deletes the contents at the last position of the array
1890         delete _ownedTokensIndex[tokenId];
1891         delete _ownedTokens[from][lastTokenIndex];
1892     }
1893 
1894     /**
1895      * @dev Private function to remove a token from this extension's token tracking data structures.
1896      * This has O(1) time complexity, but alters the order of the _allTokens array.
1897      * @param tokenId uint256 ID of the token to be removed from the tokens list
1898      */
1899     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1900         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1901         // then delete the last slot (swap and pop).
1902 
1903         uint256 lastTokenIndex = _allTokens.length - 1;
1904         uint256 tokenIndex = _allTokensIndex[tokenId];
1905 
1906         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1907         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1908         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1909         uint256 lastTokenId = _allTokens[lastTokenIndex];
1910 
1911         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1912         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1913 
1914         // This also deletes the contents at the last position of the array
1915         delete _allTokensIndex[tokenId];
1916         _allTokens.pop();
1917     }
1918 }
1919 
1920 // File: phase1.sol
1921 
1922 
1923 pragma solidity ^0.8.13;
1924 
1925 /*
1926 @title ArtVial claim of B&O DNA Collection
1927 @author Dastageer Sayed
1928 @notice NFT collection follows ERC721 standard to create different kind of art vials, and also keep record of each NFTId 
1929         that is psudo-randomly generated, and passed as token Id. If the user owns B&O DNA Collection:Phase1 NFT, then only they
1930         can claim the vial. Once a vial is claimed for certain NFTId, it cannot be reclaimed again.
1931 */
1932 contract ArtVial is ERC721, ERC721Burnable,DefaultOperatorFilterer, ERC721Enumerable, Ownable{
1933     
1934     using Counters for Counters.Counter;
1935 
1936     Counters.Counter private _nonce;
1937 
1938     bool public toggle;
1939     uint16[] private _randomNumbers;
1940     address public phase1Address;
1941     string private URI;
1942     uint256 public revealTime;
1943     mapping(address => uint256[]) public userNftId;
1944     mapping(uint256 => bool) public alreadyClaimed;
1945     
1946     event revealTimer(uint256 revealTime);
1947 
1948     constructor(string memory _name, string memory _symbol, address _phase1Address) ERC721(_name,_symbol) {
1949         phase1Address = _phase1Address;
1950         for(uint16 i = 0; i < 1925; i++){
1951             _randomNumbers.push(i);
1952         }
1953     }
1954 
1955 
1956     /*
1957     @notice Returns the psudo-random number
1958     @dev This function will generated random number
1959     */
1960     function _generateRandomNumber() internal returns(uint256 randomNumber){
1961         uint256 salt = _nonce.current();
1962         randomNumber = uint256(
1963             keccak256(
1964                 abi.encode(
1965                     msg.sender,
1966                     tx.gasprice,
1967                     block.number,
1968                     block.timestamp,
1969                     block.difficulty,
1970                     blockhash(block.number - 1),
1971                     address(this),
1972                     salt
1973                 )
1974             )
1975         );
1976         _nonce.increment();
1977     }
1978 
1979     /* 
1980     @notice Returns randomly generated tokenId
1981     @dev This function takes the random number generated and cut it down between the range of 
1982         0-1924, the selected number will be then popped out of the array and will be given as tokenID while
1983         minting NFT
1984     */
1985     function randomTokenId() internal returns(uint256 resultNumber){
1986         uint256 randomIndex = _generateRandomNumber() % _randomNumbers.length;
1987         resultNumber = _randomNumbers[randomIndex];
1988         _randomNumbers[randomIndex] = _randomNumbers[_randomNumbers.length - 1];
1989         _randomNumbers.pop();
1990         return resultNumber;
1991     }
1992 
1993     /* 
1994     @dev This function will check the phase1 tokenID, and mint a new NFT with random tokenID, before calling this function
1995         make sure you have own B&O DNA Collection:Phase1 NFT
1996     @params NFTId: B&O DNA Collection:Phase1 NFT tokenId for verification of ownership
1997     */
1998     function claim(uint256 phase1NFTId) external {
1999         require(toggle == true, "ArtVial: Toggle is off");
2000     	require(revealTime !=0, "ArtVial: Set revel Timer");
2001         require(block.timestamp > revealTime, "ArtVial: Claim has not started yet");
2002         require(IERC721(phase1Address).ownerOf(phase1NFTId) == msg.sender, "ArtVial: You are not the owner of Phase1 NFT");
2003         require(alreadyClaimed[phase1NFTId] == false, "ArtVial: NFT already claimed for this token");
2004         require(_randomNumbers.length != 0, "ArtVial: All NFT has been already minted");
2005         uint256 randomId = randomTokenId();
2006         userNftId[msg.sender].push(randomId);
2007         alreadyClaimed[phase1NFTId] = true;
2008         _safeMint(msg.sender, randomId);
2009     }
2010 
2011     /* 
2012     @dev This function will set the time after which User can claim their vials
2013     @params EpochTime when to start claim
2014     */
2015     function setRevelTimer(uint256 revealTime_) external onlyOwner{
2016         revealTime = revealTime_;
2017         emit revealTimer(revealTime);
2018     }
2019 
2020     /* 
2021     @dev Emergency function: that will update phase1 token address
2022     @params B&O DNA Collection:Phase1 deployed contract address
2023     */
2024     function updatePhase1Address(address phase1Address_) external onlyOwner{
2025         require(phase1Address_ != address(0), "ArtVial: Phase1 Address cannot be zero address");
2026         phase1Address = phase1Address_;
2027     }
2028 
2029     /* 
2030     @dev When owner set the toggle to true, then only claim will be active. Only owner has the ability to freeze the claim function for every user
2031     @params true or false
2032     */
2033     function setToggle(bool toggle_) external onlyOwner{
2034         toggle = toggle_;
2035     }
2036 
2037     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2038         require(_isApprovedOrOwner(_msgSender(), tokenId),"ArtVial: transfer caller is not owner nor approved");
2039         uint256 temp;
2040         for (uint256 i; i < userNftId[from].length; i++) {
2041             if (userNftId[from][i] == tokenId) {
2042                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
2043                 temp = userNftId[from].length - 1;
2044                 userNftId[from].pop();
2045                 userNftId[to].push(tokenId);
2046                 break;
2047             }
2048         }
2049         _transfer(from, to, tokenId);
2050     }
2051 
2052     function safeTransferFrom(address from,address to,uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from)  {
2053         uint256 temp;
2054         for (uint256 i; i < userNftId[from].length; i++) {
2055             if (userNftId[from][i] == tokenId) {
2056                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
2057                 temp = userNftId[from].length - 1;
2058                 userNftId[from].pop();
2059                 userNftId[to].push(tokenId);
2060                 break;
2061             }
2062         }
2063         safeTransferFrom(from, to, tokenId, "");
2064     }
2065 
2066     function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public override(ERC721, IERC721) onlyAllowedOperator(from)  {
2067         require(_isApprovedOrOwner(_msgSender(), tokenId),"ArtVial: transfer caller is not owner nor approved");
2068         uint256 temp;
2069         for (uint256 i; i < userNftId[from].length; i++) {
2070             if (userNftId[from][i] == tokenId) {
2071                 userNftId[from][i] = userNftId[from][userNftId[from].length - 1];
2072                 temp = userNftId[from].length - 1;
2073                 userNftId[from].pop();
2074                 userNftId[to].push(tokenId);
2075                 break;
2076             }
2077         }
2078         _safeTransfer(from, to, tokenId, _data);
2079     }
2080 
2081     /* 
2082     @dev We can check tokenId of every user that has minted the vial
2083     @params User Address
2084     */
2085     function nftOfUser(address user)public view returns(uint256[] memory){
2086         return userNftId[user];
2087     }
2088 
2089     function burn(uint256 tokenId) public virtual override{
2090         //solhint-disable-next-line max-line-length
2091         _burn(tokenId);
2092     }
2093 
2094     function _burn(uint256 _tokenId) internal override(ERC721) {
2095         require(_isApprovedOrOwner(_msgSender(), _tokenId), "ArtVial: caller is not token owner nor approved");
2096          for (uint256 i; i < userNftId[ownerOf(_tokenId)].length; i++) {
2097             if (userNftId[ownerOf(_tokenId)][i] == _tokenId) {
2098                 userNftId[ownerOf(_tokenId)][i] = userNftId[ownerOf(_tokenId)][userNftId[ownerOf(_tokenId)].length - 1];
2099                 userNftId[ownerOf(_tokenId)].pop();
2100                 break;
2101             }
2102         }
2103         super._burn(_tokenId);
2104     }
2105 
2106     /* 
2107     @dev Update the base URI for token Metadata
2108     @params Metadata URI
2109     */
2110     function updateURI(string memory newURI_) external onlyOwner{
2111         URI = newURI_;
2112     }
2113 
2114     function _baseURI() internal view override returns (string memory) {
2115         return URI;
2116     }
2117 
2118     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
2119         internal
2120         override(ERC721, ERC721Enumerable)
2121     {
2122         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2123     }
2124 
2125     function supportsInterface(bytes4 interfaceId)
2126         public
2127         view
2128         override(ERC721, ERC721Enumerable)
2129         returns (bool)
2130     {
2131         return super.supportsInterface(interfaceId);
2132     }
2133 
2134 }