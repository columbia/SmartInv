1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/math/Math.sol
49 
50 
51 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Standard math utilities missing in the Solidity language.
57  */
58 library Math {
59     enum Rounding {
60         Down, // Toward negative infinity
61         Up, // Toward infinity
62         Zero // Toward zero
63     }
64 
65     /**
66      * @dev Returns the largest of two numbers.
67      */
68     function max(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a > b ? a : b;
70     }
71 
72     /**
73      * @dev Returns the smallest of two numbers.
74      */
75     function min(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a < b ? a : b;
77     }
78 
79     /**
80      * @dev Returns the average of two numbers. The result is rounded towards
81      * zero.
82      */
83     function average(uint256 a, uint256 b) internal pure returns (uint256) {
84         // (a + b) / 2 can overflow.
85         return (a & b) + (a ^ b) / 2;
86     }
87 
88     /**
89      * @dev Returns the ceiling of the division of two numbers.
90      *
91      * This differs from standard division with `/` in that it rounds up instead
92      * of rounding down.
93      */
94     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
95         // (a + b - 1) / b can overflow on addition, so we distribute.
96         return a == 0 ? 0 : (a - 1) / b + 1;
97     }
98 
99     /**
100      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
101      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
102      * with further edits by Uniswap Labs also under MIT license.
103      */
104     function mulDiv(
105         uint256 x,
106         uint256 y,
107         uint256 denominator
108     ) internal pure returns (uint256 result) {
109         unchecked {
110             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
111             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
112             // variables such that product = prod1 * 2^256 + prod0.
113             uint256 prod0; // Least significant 256 bits of the product
114             uint256 prod1; // Most significant 256 bits of the product
115             assembly {
116                 let mm := mulmod(x, y, not(0))
117                 prod0 := mul(x, y)
118                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
119             }
120 
121             // Handle non-overflow cases, 256 by 256 division.
122             if (prod1 == 0) {
123                 return prod0 / denominator;
124             }
125 
126             // Make sure the result is less than 2^256. Also prevents denominator == 0.
127             require(denominator > prod1);
128 
129             ///////////////////////////////////////////////
130             // 512 by 256 division.
131             ///////////////////////////////////////////////
132 
133             // Make division exact by subtracting the remainder from [prod1 prod0].
134             uint256 remainder;
135             assembly {
136                 // Compute remainder using mulmod.
137                 remainder := mulmod(x, y, denominator)
138 
139                 // Subtract 256 bit number from 512 bit number.
140                 prod1 := sub(prod1, gt(remainder, prod0))
141                 prod0 := sub(prod0, remainder)
142             }
143 
144             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
145             // See https://cs.stackexchange.com/q/138556/92363.
146 
147             // Does not overflow because the denominator cannot be zero at this stage in the function.
148             uint256 twos = denominator & (~denominator + 1);
149             assembly {
150                 // Divide denominator by twos.
151                 denominator := div(denominator, twos)
152 
153                 // Divide [prod1 prod0] by twos.
154                 prod0 := div(prod0, twos)
155 
156                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
157                 twos := add(div(sub(0, twos), twos), 1)
158             }
159 
160             // Shift in bits from prod1 into prod0.
161             prod0 |= prod1 * twos;
162 
163             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
164             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
165             // four bits. That is, denominator * inv = 1 mod 2^4.
166             uint256 inverse = (3 * denominator) ^ 2;
167 
168             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
169             // in modular arithmetic, doubling the correct bits in each step.
170             inverse *= 2 - denominator * inverse; // inverse mod 2^8
171             inverse *= 2 - denominator * inverse; // inverse mod 2^16
172             inverse *= 2 - denominator * inverse; // inverse mod 2^32
173             inverse *= 2 - denominator * inverse; // inverse mod 2^64
174             inverse *= 2 - denominator * inverse; // inverse mod 2^128
175             inverse *= 2 - denominator * inverse; // inverse mod 2^256
176 
177             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
178             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
179             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
180             // is no longer required.
181             result = prod0 * inverse;
182             return result;
183         }
184     }
185 
186     /**
187      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
188      */
189     function mulDiv(
190         uint256 x,
191         uint256 y,
192         uint256 denominator,
193         Rounding rounding
194     ) internal pure returns (uint256) {
195         uint256 result = mulDiv(x, y, denominator);
196         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
197             result += 1;
198         }
199         return result;
200     }
201 
202     /**
203      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
204      *
205      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
206      */
207     function sqrt(uint256 a) internal pure returns (uint256) {
208         if (a == 0) {
209             return 0;
210         }
211 
212         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
213         //
214         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
215         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
216         //
217         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
218         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
219         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
220         //
221         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
222         uint256 result = 1 << (log2(a) >> 1);
223 
224         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
225         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
226         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
227         // into the expected uint128 result.
228         unchecked {
229             result = (result + a / result) >> 1;
230             result = (result + a / result) >> 1;
231             result = (result + a / result) >> 1;
232             result = (result + a / result) >> 1;
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             result = (result + a / result) >> 1;
236             return min(result, a / result);
237         }
238     }
239 
240     /**
241      * @notice Calculates sqrt(a), following the selected rounding direction.
242      */
243     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
244         unchecked {
245             uint256 result = sqrt(a);
246             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
247         }
248     }
249 
250     /**
251      * @dev Return the log in base 2, rounded down, of a positive value.
252      * Returns 0 if given 0.
253      */
254     function log2(uint256 value) internal pure returns (uint256) {
255         uint256 result = 0;
256         unchecked {
257             if (value >> 128 > 0) {
258                 value >>= 128;
259                 result += 128;
260             }
261             if (value >> 64 > 0) {
262                 value >>= 64;
263                 result += 64;
264             }
265             if (value >> 32 > 0) {
266                 value >>= 32;
267                 result += 32;
268             }
269             if (value >> 16 > 0) {
270                 value >>= 16;
271                 result += 16;
272             }
273             if (value >> 8 > 0) {
274                 value >>= 8;
275                 result += 8;
276             }
277             if (value >> 4 > 0) {
278                 value >>= 4;
279                 result += 4;
280             }
281             if (value >> 2 > 0) {
282                 value >>= 2;
283                 result += 2;
284             }
285             if (value >> 1 > 0) {
286                 result += 1;
287             }
288         }
289         return result;
290     }
291 
292     /**
293      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
294      * Returns 0 if given 0.
295      */
296     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
297         unchecked {
298             uint256 result = log2(value);
299             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
300         }
301     }
302 
303     /**
304      * @dev Return the log in base 10, rounded down, of a positive value.
305      * Returns 0 if given 0.
306      */
307     function log10(uint256 value) internal pure returns (uint256) {
308         uint256 result = 0;
309         unchecked {
310             if (value >= 10**64) {
311                 value /= 10**64;
312                 result += 64;
313             }
314             if (value >= 10**32) {
315                 value /= 10**32;
316                 result += 32;
317             }
318             if (value >= 10**16) {
319                 value /= 10**16;
320                 result += 16;
321             }
322             if (value >= 10**8) {
323                 value /= 10**8;
324                 result += 8;
325             }
326             if (value >= 10**4) {
327                 value /= 10**4;
328                 result += 4;
329             }
330             if (value >= 10**2) {
331                 value /= 10**2;
332                 result += 2;
333             }
334             if (value >= 10**1) {
335                 result += 1;
336             }
337         }
338         return result;
339     }
340 
341     /**
342      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
343      * Returns 0 if given 0.
344      */
345     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
346         unchecked {
347             uint256 result = log10(value);
348             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
349         }
350     }
351 
352     /**
353      * @dev Return the log in base 256, rounded down, of a positive value.
354      * Returns 0 if given 0.
355      *
356      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
357      */
358     function log256(uint256 value) internal pure returns (uint256) {
359         uint256 result = 0;
360         unchecked {
361             if (value >> 128 > 0) {
362                 value >>= 128;
363                 result += 16;
364             }
365             if (value >> 64 > 0) {
366                 value >>= 64;
367                 result += 8;
368             }
369             if (value >> 32 > 0) {
370                 value >>= 32;
371                 result += 4;
372             }
373             if (value >> 16 > 0) {
374                 value >>= 16;
375                 result += 2;
376             }
377             if (value >> 8 > 0) {
378                 result += 1;
379             }
380         }
381         return result;
382     }
383 
384     /**
385      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
386      * Returns 0 if given 0.
387      */
388     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
389         unchecked {
390             uint256 result = log256(value);
391             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/utils/Strings.sol
397 
398 
399 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev String operations.
406  */
407 library Strings {
408     bytes16 private constant _SYMBOLS = "0123456789abcdef";
409     uint8 private constant _ADDRESS_LENGTH = 20;
410 
411     /**
412      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
413      */
414     function toString(uint256 value) internal pure returns (string memory) {
415         unchecked {
416             uint256 length = Math.log10(value) + 1;
417             string memory buffer = new string(length);
418             uint256 ptr;
419             /// @solidity memory-safe-assembly
420             assembly {
421                 ptr := add(buffer, add(32, length))
422             }
423             while (true) {
424                 ptr--;
425                 /// @solidity memory-safe-assembly
426                 assembly {
427                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
428                 }
429                 value /= 10;
430                 if (value == 0) break;
431             }
432             return buffer;
433         }
434     }
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
438      */
439     function toHexString(uint256 value) internal pure returns (string memory) {
440         unchecked {
441             return toHexString(value, Math.log256(value) + 1);
442         }
443     }
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
447      */
448     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
449         bytes memory buffer = new bytes(2 * length + 2);
450         buffer[0] = "0";
451         buffer[1] = "x";
452         for (uint256 i = 2 * length + 1; i > 1; --i) {
453             buffer[i] = _SYMBOLS[value & 0xf];
454             value >>= 4;
455         }
456         require(value == 0, "Strings: hex length insufficient");
457         return string(buffer);
458     }
459 
460     /**
461      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
462      */
463     function toHexString(address addr) internal pure returns (string memory) {
464         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
465     }
466 }
467 
468 // File: @openzeppelin/contracts/utils/Context.sol
469 
470 
471 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev Provides information about the current execution context, including the
477  * sender of the transaction and its data. While these are generally available
478  * via msg.sender and msg.data, they should not be accessed in such a direct
479  * manner, since when dealing with meta-transactions the account sending and
480  * paying for execution may not be the actual sender (as far as an application
481  * is concerned).
482  *
483  * This contract is only required for intermediate, library-like contracts.
484  */
485 abstract contract Context {
486     function _msgSender() internal view virtual returns (address) {
487         return msg.sender;
488     }
489 
490     function _msgData() internal view virtual returns (bytes calldata) {
491         return msg.data;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/access/Ownable.sol
496 
497 
498 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Contract module which provides a basic access control mechanism, where
505  * there is an account (an owner) that can be granted exclusive access to
506  * specific functions.
507  *
508  * By default, the owner account will be the one that deploys the contract. This
509  * can later be changed with {transferOwnership}.
510  *
511  * This module is used through inheritance. It will make available the modifier
512  * `onlyOwner`, which can be applied to your functions to restrict their use to
513  * the owner.
514  */
515 abstract contract Ownable is Context {
516     address private _owner;
517 
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519 
520     /**
521      * @dev Initializes the contract setting the deployer as the initial owner.
522      */
523     constructor() {
524         _transferOwnership(_msgSender());
525     }
526 
527     /**
528      * @dev Throws if called by any account other than the owner.
529      */
530     modifier onlyOwner() {
531         _checkOwner();
532         _;
533     }
534 
535     /**
536      * @dev Returns the address of the current owner.
537      */
538     function owner() public view virtual returns (address) {
539         return _owner;
540     }
541 
542     /**
543      * @dev Throws if the sender is not the owner.
544      */
545     function _checkOwner() internal view virtual {
546         require(owner() == _msgSender(), "Ownable: caller is not the owner");
547     }
548 
549     /**
550      * @dev Leaves the contract without owner. It will not be possible to call
551      * `onlyOwner` functions anymore. Can only be called by the current owner.
552      *
553      * NOTE: Renouncing ownership will leave the contract without an owner,
554      * thereby removing any functionality that is only available to the owner.
555      */
556     function renounceOwnership() public virtual onlyOwner {
557         _transferOwnership(address(0));
558     }
559 
560     /**
561      * @dev Transfers ownership of the contract to a new account (`newOwner`).
562      * Can only be called by the current owner.
563      */
564     function transferOwnership(address newOwner) public virtual onlyOwner {
565         require(newOwner != address(0), "Ownable: new owner is the zero address");
566         _transferOwnership(newOwner);
567     }
568 
569     /**
570      * @dev Transfers ownership of the contract to a new account (`newOwner`).
571      * Internal function without access restriction.
572      */
573     function _transferOwnership(address newOwner) internal virtual {
574         address oldOwner = _owner;
575         _owner = newOwner;
576         emit OwnershipTransferred(oldOwner, newOwner);
577     }
578 }
579 
580 // File: @openzeppelin/contracts/security/Pausable.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Contract module which allows children to implement an emergency stop
590  * mechanism that can be triggered by an authorized account.
591  *
592  * This module is used through inheritance. It will make available the
593  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
594  * the functions of your contract. Note that they will not be pausable by
595  * simply including this module, only once the modifiers are put in place.
596  */
597 abstract contract Pausable is Context {
598     /**
599      * @dev Emitted when the pause is triggered by `account`.
600      */
601     event Paused(address account);
602 
603     /**
604      * @dev Emitted when the pause is lifted by `account`.
605      */
606     event Unpaused(address account);
607 
608     bool private _paused;
609 
610     /**
611      * @dev Initializes the contract in unpaused state.
612      */
613     constructor() {
614         _paused = false;
615     }
616 
617     /**
618      * @dev Modifier to make a function callable only when the contract is not paused.
619      *
620      * Requirements:
621      *
622      * - The contract must not be paused.
623      */
624     modifier whenNotPaused() {
625         _requireNotPaused();
626         _;
627     }
628 
629     /**
630      * @dev Modifier to make a function callable only when the contract is paused.
631      *
632      * Requirements:
633      *
634      * - The contract must be paused.
635      */
636     modifier whenPaused() {
637         _requirePaused();
638         _;
639     }
640 
641     /**
642      * @dev Returns true if the contract is paused, and false otherwise.
643      */
644     function paused() public view virtual returns (bool) {
645         return _paused;
646     }
647 
648     /**
649      * @dev Throws if the contract is paused.
650      */
651     function _requireNotPaused() internal view virtual {
652         require(!paused(), "Pausable: paused");
653     }
654 
655     /**
656      * @dev Throws if the contract is not paused.
657      */
658     function _requirePaused() internal view virtual {
659         require(paused(), "Pausable: not paused");
660     }
661 
662     /**
663      * @dev Triggers stopped state.
664      *
665      * Requirements:
666      *
667      * - The contract must not be paused.
668      */
669     function _pause() internal virtual whenNotPaused {
670         _paused = true;
671         emit Paused(_msgSender());
672     }
673 
674     /**
675      * @dev Returns to normal state.
676      *
677      * Requirements:
678      *
679      * - The contract must be paused.
680      */
681     function _unpause() internal virtual whenPaused {
682         _paused = false;
683         emit Unpaused(_msgSender());
684     }
685 }
686 
687 // File: @openzeppelin/contracts/utils/Address.sol
688 
689 
690 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
691 
692 pragma solidity ^0.8.1;
693 
694 /**
695  * @dev Collection of functions related to the address type
696  */
697 library Address {
698     /**
699      * @dev Returns true if `account` is a contract.
700      *
701      * [IMPORTANT]
702      * ====
703      * It is unsafe to assume that an address for which this function returns
704      * false is an externally-owned account (EOA) and not a contract.
705      *
706      * Among others, `isContract` will return false for the following
707      * types of addresses:
708      *
709      *  - an externally-owned account
710      *  - a contract in construction
711      *  - an address where a contract will be created
712      *  - an address where a contract lived, but was destroyed
713      * ====
714      *
715      * [IMPORTANT]
716      * ====
717      * You shouldn't rely on `isContract` to protect against flash loan attacks!
718      *
719      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
720      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
721      * constructor.
722      * ====
723      */
724     function isContract(address account) internal view returns (bool) {
725         // This method relies on extcodesize/address.code.length, which returns 0
726         // for contracts in construction, since the code is only stored at the end
727         // of the constructor execution.
728 
729         return account.code.length > 0;
730     }
731 
732     /**
733      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
734      * `recipient`, forwarding all available gas and reverting on errors.
735      *
736      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
737      * of certain opcodes, possibly making contracts go over the 2300 gas limit
738      * imposed by `transfer`, making them unable to receive funds via
739      * `transfer`. {sendValue} removes this limitation.
740      *
741      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
742      *
743      * IMPORTANT: because control is transferred to `recipient`, care must be
744      * taken to not create reentrancy vulnerabilities. Consider using
745      * {ReentrancyGuard} or the
746      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
747      */
748     function sendValue(address payable recipient, uint256 amount) internal {
749         require(address(this).balance >= amount, "Address: insufficient balance");
750 
751         (bool success, ) = recipient.call{value: amount}("");
752         require(success, "Address: unable to send value, recipient may have reverted");
753     }
754 
755     /**
756      * @dev Performs a Solidity function call using a low level `call`. A
757      * plain `call` is an unsafe replacement for a function call: use this
758      * function instead.
759      *
760      * If `target` reverts with a revert reason, it is bubbled up by this
761      * function (like regular Solidity function calls).
762      *
763      * Returns the raw returned data. To convert to the expected return value,
764      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
765      *
766      * Requirements:
767      *
768      * - `target` must be a contract.
769      * - calling `target` with `data` must not revert.
770      *
771      * _Available since v3.1._
772      */
773     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
774         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
779      * `errorMessage` as a fallback revert reason when `target` reverts.
780      *
781      * _Available since v3.1._
782      */
783     function functionCall(
784         address target,
785         bytes memory data,
786         string memory errorMessage
787     ) internal returns (bytes memory) {
788         return functionCallWithValue(target, data, 0, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but also transferring `value` wei to `target`.
794      *
795      * Requirements:
796      *
797      * - the calling contract must have an ETH balance of at least `value`.
798      * - the called Solidity function must be `payable`.
799      *
800      * _Available since v3.1._
801      */
802     function functionCallWithValue(
803         address target,
804         bytes memory data,
805         uint256 value
806     ) internal returns (bytes memory) {
807         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
812      * with `errorMessage` as a fallback revert reason when `target` reverts.
813      *
814      * _Available since v3.1._
815      */
816     function functionCallWithValue(
817         address target,
818         bytes memory data,
819         uint256 value,
820         string memory errorMessage
821     ) internal returns (bytes memory) {
822         require(address(this).balance >= value, "Address: insufficient balance for call");
823         (bool success, bytes memory returndata) = target.call{value: value}(data);
824         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
829      * but performing a static call.
830      *
831      * _Available since v3.3._
832      */
833     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
834         return functionStaticCall(target, data, "Address: low-level static call failed");
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
839      * but performing a static call.
840      *
841      * _Available since v3.3._
842      */
843     function functionStaticCall(
844         address target,
845         bytes memory data,
846         string memory errorMessage
847     ) internal view returns (bytes memory) {
848         (bool success, bytes memory returndata) = target.staticcall(data);
849         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
850     }
851 
852     /**
853      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
854      * but performing a delegate call.
855      *
856      * _Available since v3.4._
857      */
858     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
859         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
860     }
861 
862     /**
863      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
864      * but performing a delegate call.
865      *
866      * _Available since v3.4._
867      */
868     function functionDelegateCall(
869         address target,
870         bytes memory data,
871         string memory errorMessage
872     ) internal returns (bytes memory) {
873         (bool success, bytes memory returndata) = target.delegatecall(data);
874         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
875     }
876 
877     /**
878      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
879      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
880      *
881      * _Available since v4.8._
882      */
883     function verifyCallResultFromTarget(
884         address target,
885         bool success,
886         bytes memory returndata,
887         string memory errorMessage
888     ) internal view returns (bytes memory) {
889         if (success) {
890             if (returndata.length == 0) {
891                 // only check isContract if the call was successful and the return data is empty
892                 // otherwise we already know that it was a contract
893                 require(isContract(target), "Address: call to non-contract");
894             }
895             return returndata;
896         } else {
897             _revert(returndata, errorMessage);
898         }
899     }
900 
901     /**
902      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
903      * revert reason or using the provided one.
904      *
905      * _Available since v4.3._
906      */
907     function verifyCallResult(
908         bool success,
909         bytes memory returndata,
910         string memory errorMessage
911     ) internal pure returns (bytes memory) {
912         if (success) {
913             return returndata;
914         } else {
915             _revert(returndata, errorMessage);
916         }
917     }
918 
919     function _revert(bytes memory returndata, string memory errorMessage) private pure {
920         // Look for revert reason and bubble it up if present
921         if (returndata.length > 0) {
922             // The easiest way to bubble the revert reason is using memory via assembly
923             /// @solidity memory-safe-assembly
924             assembly {
925                 let returndata_size := mload(returndata)
926                 revert(add(32, returndata), returndata_size)
927             }
928         } else {
929             revert(errorMessage);
930         }
931     }
932 }
933 
934 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
935 
936 
937 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 /**
942  * @title ERC721 token receiver interface
943  * @dev Interface for any contract that wants to support safeTransfers
944  * from ERC721 asset contracts.
945  */
946 interface IERC721Receiver {
947     /**
948      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
949      * by `operator` from `from`, this function is called.
950      *
951      * It must return its Solidity selector to confirm the token transfer.
952      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
953      *
954      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
955      */
956     function onERC721Received(
957         address operator,
958         address from,
959         uint256 tokenId,
960         bytes calldata data
961     ) external returns (bytes4);
962 }
963 
964 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
965 
966 
967 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
968 
969 pragma solidity ^0.8.0;
970 
971 /**
972  * @dev Interface of the ERC165 standard, as defined in the
973  * https://eips.ethereum.org/EIPS/eip-165[EIP].
974  *
975  * Implementers can declare support of contract interfaces, which can then be
976  * queried by others ({ERC165Checker}).
977  *
978  * For an implementation, see {ERC165}.
979  */
980 interface IERC165 {
981     /**
982      * @dev Returns true if this contract implements the interface defined by
983      * `interfaceId`. See the corresponding
984      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
985      * to learn more about how these ids are created.
986      *
987      * This function call must use less than 30 000 gas.
988      */
989     function supportsInterface(bytes4 interfaceId) external view returns (bool);
990 }
991 
992 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
993 
994 
995 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
996 
997 pragma solidity ^0.8.0;
998 
999 
1000 /**
1001  * @dev Implementation of the {IERC165} interface.
1002  *
1003  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1004  * for the additional interface id that will be supported. For example:
1005  *
1006  * ```solidity
1007  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1008  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1009  * }
1010  * ```
1011  *
1012  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1013  */
1014 abstract contract ERC165 is IERC165 {
1015     /**
1016      * @dev See {IERC165-supportsInterface}.
1017      */
1018     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1019         return interfaceId == type(IERC165).interfaceId;
1020     }
1021 }
1022 
1023 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1024 
1025 
1026 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 /**
1032  * @dev Required interface of an ERC721 compliant contract.
1033  */
1034 interface IERC721 is IERC165 {
1035     /**
1036      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1037      */
1038     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1039 
1040     /**
1041      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1042      */
1043     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1044 
1045     /**
1046      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1047      */
1048     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1049 
1050     /**
1051      * @dev Returns the number of tokens in ``owner``'s account.
1052      */
1053     function balanceOf(address owner) external view returns (uint256 balance);
1054 
1055     /**
1056      * @dev Returns the owner of the `tokenId` token.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      */
1062     function ownerOf(uint256 tokenId) external view returns (address owner);
1063 
1064     /**
1065      * @dev Safely transfers `tokenId` token from `from` to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      * - `tokenId` token must exist and be owned by `from`.
1072      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes calldata data
1082     ) external;
1083 
1084     /**
1085      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1086      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1087      *
1088      * Requirements:
1089      *
1090      * - `from` cannot be the zero address.
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must exist and be owned by `from`.
1093      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) external;
1103 
1104     /**
1105      * @dev Transfers `tokenId` token from `from` to `to`.
1106      *
1107      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1108      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1109      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1110      *
1111      * Requirements:
1112      *
1113      * - `from` cannot be the zero address.
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function transferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) external;
1125 
1126     /**
1127      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1128      * The approval is cleared when the token is transferred.
1129      *
1130      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1131      *
1132      * Requirements:
1133      *
1134      * - The caller must own the token or be an approved operator.
1135      * - `tokenId` must exist.
1136      *
1137      * Emits an {Approval} event.
1138      */
1139     function approve(address to, uint256 tokenId) external;
1140 
1141     /**
1142      * @dev Approve or remove `operator` as an operator for the caller.
1143      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1144      *
1145      * Requirements:
1146      *
1147      * - The `operator` cannot be the caller.
1148      *
1149      * Emits an {ApprovalForAll} event.
1150      */
1151     function setApprovalForAll(address operator, bool _approved) external;
1152 
1153     /**
1154      * @dev Returns the account approved for `tokenId` token.
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must exist.
1159      */
1160     function getApproved(uint256 tokenId) external view returns (address operator);
1161 
1162     /**
1163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1164      *
1165      * See {setApprovalForAll}
1166      */
1167     function isApprovedForAll(address owner, address operator) external view returns (bool);
1168 }
1169 
1170 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1171 
1172 
1173 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1180  * @dev See https://eips.ethereum.org/EIPS/eip-721
1181  */
1182 interface IERC721Enumerable is IERC721 {
1183     /**
1184      * @dev Returns the total amount of tokens stored by the contract.
1185      */
1186     function totalSupply() external view returns (uint256);
1187 
1188     /**
1189      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1190      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1191      */
1192     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1193 
1194     /**
1195      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1196      * Use along with {totalSupply} to enumerate all tokens.
1197      */
1198     function tokenByIndex(uint256 index) external view returns (uint256);
1199 }
1200 
1201 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1202 
1203 
1204 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 /**
1210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1211  * @dev See https://eips.ethereum.org/EIPS/eip-721
1212  */
1213 interface IERC721Metadata is IERC721 {
1214     /**
1215      * @dev Returns the token collection name.
1216      */
1217     function name() external view returns (string memory);
1218 
1219     /**
1220      * @dev Returns the token collection symbol.
1221      */
1222     function symbol() external view returns (string memory);
1223 
1224     /**
1225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1226      */
1227     function tokenURI(uint256 tokenId) external view returns (string memory);
1228 }
1229 
1230 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1231 
1232 
1233 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 /**
1245  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1246  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1247  * {ERC721Enumerable}.
1248  */
1249 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1250     using Address for address;
1251     using Strings for uint256;
1252 
1253     // Token name
1254     string private _name;
1255 
1256     // Token symbol
1257     string private _symbol;
1258 
1259     // Mapping from token ID to owner address
1260     mapping(uint256 => address) private _owners;
1261 
1262     // Mapping owner address to token count
1263     mapping(address => uint256) private _balances;
1264 
1265     // Mapping from token ID to approved address
1266     mapping(uint256 => address) private _tokenApprovals;
1267 
1268     // Mapping from owner to operator approvals
1269     mapping(address => mapping(address => bool)) private _operatorApprovals;
1270 
1271     /**
1272      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1273      */
1274     constructor(string memory name_, string memory symbol_) {
1275         _name = name_;
1276         _symbol = symbol_;
1277     }
1278 
1279     /**
1280      * @dev See {IERC165-supportsInterface}.
1281      */
1282     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1283         return
1284             interfaceId == type(IERC721).interfaceId ||
1285             interfaceId == type(IERC721Metadata).interfaceId ||
1286             super.supportsInterface(interfaceId);
1287     }
1288 
1289     /**
1290      * @dev See {IERC721-balanceOf}.
1291      */
1292     function balanceOf(address owner) public view virtual override returns (uint256) {
1293         require(owner != address(0), "ERC721: address zero is not a valid owner");
1294         return _balances[owner];
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-ownerOf}.
1299      */
1300     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1301         address owner = _ownerOf(tokenId);
1302         require(owner != address(0), "ERC721: invalid token ID");
1303         return owner;
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Metadata-name}.
1308      */
1309     function name() public view virtual override returns (string memory) {
1310         return _name;
1311     }
1312 
1313     /**
1314      * @dev See {IERC721Metadata-symbol}.
1315      */
1316     function symbol() public view virtual override returns (string memory) {
1317         return _symbol;
1318     }
1319 
1320     /**
1321      * @dev See {IERC721Metadata-tokenURI}.
1322      */
1323     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1324         _requireMinted(tokenId);
1325 
1326         string memory baseURI = _baseURI();
1327         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1328     }
1329 
1330     /**
1331      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1332      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1333      * by default, can be overridden in child contracts.
1334      */
1335     function _baseURI() internal view virtual returns (string memory) {
1336         return "";
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-approve}.
1341      */
1342     function approve(address to, uint256 tokenId) public virtual override {
1343         address owner = ERC721.ownerOf(tokenId);
1344         require(to != owner, "ERC721: approval to current owner");
1345 
1346         require(
1347             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1348             "ERC721: approve caller is not token owner or approved for all"
1349         );
1350 
1351         _approve(to, tokenId);
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-getApproved}.
1356      */
1357     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1358         _requireMinted(tokenId);
1359 
1360         return _tokenApprovals[tokenId];
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-setApprovalForAll}.
1365      */
1366     function setApprovalForAll(address operator, bool approved) public virtual override {
1367         _setApprovalForAll(_msgSender(), operator, approved);
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-isApprovedForAll}.
1372      */
1373     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1374         return _operatorApprovals[owner][operator];
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-transferFrom}.
1379      */
1380     function transferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) public virtual override {
1385         //solhint-disable-next-line max-line-length
1386         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1387 
1388         _transfer(from, to, tokenId);
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-safeTransferFrom}.
1393      */
1394     function safeTransferFrom(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) public virtual override {
1399         safeTransferFrom(from, to, tokenId, "");
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-safeTransferFrom}.
1404      */
1405     function safeTransferFrom(
1406         address from,
1407         address to,
1408         uint256 tokenId,
1409         bytes memory data
1410     ) public virtual override {
1411         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1412         _safeTransfer(from, to, tokenId, data);
1413     }
1414 
1415     /**
1416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1418      *
1419      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1420      *
1421      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1422      * implement alternative mechanisms to perform token transfer, such as signature-based.
1423      *
1424      * Requirements:
1425      *
1426      * - `from` cannot be the zero address.
1427      * - `to` cannot be the zero address.
1428      * - `tokenId` token must exist and be owned by `from`.
1429      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1430      *
1431      * Emits a {Transfer} event.
1432      */
1433     function _safeTransfer(
1434         address from,
1435         address to,
1436         uint256 tokenId,
1437         bytes memory data
1438     ) internal virtual {
1439         _transfer(from, to, tokenId);
1440         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1441     }
1442 
1443     /**
1444      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1445      */
1446     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1447         return _owners[tokenId];
1448     }
1449 
1450     /**
1451      * @dev Returns whether `tokenId` exists.
1452      *
1453      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1454      *
1455      * Tokens start existing when they are minted (`_mint`),
1456      * and stop existing when they are burned (`_burn`).
1457      */
1458     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1459         return _ownerOf(tokenId) != address(0);
1460     }
1461 
1462     /**
1463      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1464      *
1465      * Requirements:
1466      *
1467      * - `tokenId` must exist.
1468      */
1469     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1470         address owner = ERC721.ownerOf(tokenId);
1471         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1472     }
1473 
1474     /**
1475      * @dev Safely mints `tokenId` and transfers it to `to`.
1476      *
1477      * Requirements:
1478      *
1479      * - `tokenId` must not exist.
1480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function _safeMint(address to, uint256 tokenId) internal virtual {
1485         _safeMint(to, tokenId, "");
1486     }
1487 
1488     /**
1489      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1490      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1491      */
1492     function _safeMint(
1493         address to,
1494         uint256 tokenId,
1495         bytes memory data
1496     ) internal virtual {
1497         _mint(to, tokenId);
1498         require(
1499             _checkOnERC721Received(address(0), to, tokenId, data),
1500             "ERC721: transfer to non ERC721Receiver implementer"
1501         );
1502     }
1503 
1504     /**
1505      * @dev Mints `tokenId` and transfers it to `to`.
1506      *
1507      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1508      *
1509      * Requirements:
1510      *
1511      * - `tokenId` must not exist.
1512      * - `to` cannot be the zero address.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function _mint(address to, uint256 tokenId) internal virtual {
1517         require(to != address(0), "ERC721: mint to the zero address");
1518         require(!_exists(tokenId), "ERC721: token already minted");
1519 
1520         _beforeTokenTransfer(address(0), to, tokenId, 1);
1521 
1522         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1523         require(!_exists(tokenId), "ERC721: token already minted");
1524 
1525         unchecked {
1526             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1527             // Given that tokens are minted one by one, it is impossible in practice that
1528             // this ever happens. Might change if we allow batch minting.
1529             // The ERC fails to describe this case.
1530             _balances[to] += 1;
1531         }
1532 
1533         _owners[tokenId] = to;
1534 
1535         emit Transfer(address(0), to, tokenId);
1536 
1537         _afterTokenTransfer(address(0), to, tokenId, 1);
1538     }
1539 
1540     /**
1541      * @dev Destroys `tokenId`.
1542      * The approval is cleared when the token is burned.
1543      * This is an internal function that does not check if the sender is authorized to operate on the token.
1544      *
1545      * Requirements:
1546      *
1547      * - `tokenId` must exist.
1548      *
1549      * Emits a {Transfer} event.
1550      */
1551     function _burn(uint256 tokenId) internal virtual {
1552         address owner = ERC721.ownerOf(tokenId);
1553 
1554         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1555 
1556         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1557         owner = ERC721.ownerOf(tokenId);
1558 
1559         // Clear approvals
1560         delete _tokenApprovals[tokenId];
1561 
1562         unchecked {
1563             // Cannot overflow, as that would require more tokens to be burned/transferred
1564             // out than the owner initially received through minting and transferring in.
1565             _balances[owner] -= 1;
1566         }
1567         delete _owners[tokenId];
1568 
1569         emit Transfer(owner, address(0), tokenId);
1570 
1571         _afterTokenTransfer(owner, address(0), tokenId, 1);
1572     }
1573 
1574     /**
1575      * @dev Transfers `tokenId` from `from` to `to`.
1576      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1577      *
1578      * Requirements:
1579      *
1580      * - `to` cannot be the zero address.
1581      * - `tokenId` token must be owned by `from`.
1582      *
1583      * Emits a {Transfer} event.
1584      */
1585     function _transfer(
1586         address from,
1587         address to,
1588         uint256 tokenId
1589     ) internal virtual {
1590         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1591         require(to != address(0), "ERC721: transfer to the zero address");
1592 
1593         _beforeTokenTransfer(from, to, tokenId, 1);
1594 
1595         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1596         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1597 
1598         // Clear approvals from the previous owner
1599         delete _tokenApprovals[tokenId];
1600 
1601         unchecked {
1602             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1603             // `from`'s balance is the number of token held, which is at least one before the current
1604             // transfer.
1605             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1606             // all 2**256 token ids to be minted, which in practice is impossible.
1607             _balances[from] -= 1;
1608             _balances[to] += 1;
1609         }
1610         _owners[tokenId] = to;
1611 
1612         emit Transfer(from, to, tokenId);
1613 
1614         _afterTokenTransfer(from, to, tokenId, 1);
1615     }
1616 
1617     /**
1618      * @dev Approve `to` to operate on `tokenId`
1619      *
1620      * Emits an {Approval} event.
1621      */
1622     function _approve(address to, uint256 tokenId) internal virtual {
1623         _tokenApprovals[tokenId] = to;
1624         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1625     }
1626 
1627     /**
1628      * @dev Approve `operator` to operate on all of `owner` tokens
1629      *
1630      * Emits an {ApprovalForAll} event.
1631      */
1632     function _setApprovalForAll(
1633         address owner,
1634         address operator,
1635         bool approved
1636     ) internal virtual {
1637         require(owner != operator, "ERC721: approve to caller");
1638         _operatorApprovals[owner][operator] = approved;
1639         emit ApprovalForAll(owner, operator, approved);
1640     }
1641 
1642     /**
1643      * @dev Reverts if the `tokenId` has not been minted yet.
1644      */
1645     function _requireMinted(uint256 tokenId) internal view virtual {
1646         require(_exists(tokenId), "ERC721: invalid token ID");
1647     }
1648 
1649     /**
1650      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1651      * The call is not executed if the target address is not a contract.
1652      *
1653      * @param from address representing the previous owner of the given token ID
1654      * @param to target address that will receive the tokens
1655      * @param tokenId uint256 ID of the token to be transferred
1656      * @param data bytes optional data to send along with the call
1657      * @return bool whether the call correctly returned the expected magic value
1658      */
1659     function _checkOnERC721Received(
1660         address from,
1661         address to,
1662         uint256 tokenId,
1663         bytes memory data
1664     ) private returns (bool) {
1665         if (to.isContract()) {
1666             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1667                 return retval == IERC721Receiver.onERC721Received.selector;
1668             } catch (bytes memory reason) {
1669                 if (reason.length == 0) {
1670                     revert("ERC721: transfer to non ERC721Receiver implementer");
1671                 } else {
1672                     /// @solidity memory-safe-assembly
1673                     assembly {
1674                         revert(add(32, reason), mload(reason))
1675                     }
1676                 }
1677             }
1678         } else {
1679             return true;
1680         }
1681     }
1682 
1683     /**
1684      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1685      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1686      *
1687      * Calling conditions:
1688      *
1689      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1690      * - When `from` is zero, the tokens will be minted for `to`.
1691      * - When `to` is zero, ``from``'s tokens will be burned.
1692      * - `from` and `to` are never both zero.
1693      * - `batchSize` is non-zero.
1694      *
1695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1696      */
1697     function _beforeTokenTransfer(
1698         address from,
1699         address to,
1700         uint256, /* firstTokenId */
1701         uint256 batchSize
1702     ) internal virtual {
1703         if (batchSize > 1) {
1704             if (from != address(0)) {
1705                 _balances[from] -= batchSize;
1706             }
1707             if (to != address(0)) {
1708                 _balances[to] += batchSize;
1709             }
1710         }
1711     }
1712 
1713     /**
1714      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1715      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1716      *
1717      * Calling conditions:
1718      *
1719      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1720      * - When `from` is zero, the tokens were minted for `to`.
1721      * - When `to` is zero, ``from``'s tokens were burned.
1722      * - `from` and `to` are never both zero.
1723      * - `batchSize` is non-zero.
1724      *
1725      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1726      */
1727     function _afterTokenTransfer(
1728         address from,
1729         address to,
1730         uint256 firstTokenId,
1731         uint256 batchSize
1732     ) internal virtual {}
1733 }
1734 
1735 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1736 
1737 
1738 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1739 
1740 pragma solidity ^0.8.0;
1741 
1742 
1743 
1744 /**
1745  * @title ERC721 Burnable Token
1746  * @dev ERC721 Token that can be burned (destroyed).
1747  */
1748 abstract contract ERC721Burnable is Context, ERC721 {
1749     /**
1750      * @dev Burns `tokenId`. See {ERC721-_burn}.
1751      *
1752      * Requirements:
1753      *
1754      * - The caller must own `tokenId` or be an approved operator.
1755      */
1756     function burn(uint256 tokenId) public virtual {
1757         //solhint-disable-next-line max-line-length
1758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1759         _burn(tokenId);
1760     }
1761 }
1762 
1763 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1764 
1765 
1766 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1767 
1768 pragma solidity ^0.8.0;
1769 
1770 
1771 /**
1772  * @dev ERC721 token with storage based token URI management.
1773  */
1774 abstract contract ERC721URIStorage is ERC721 {
1775     using Strings for uint256;
1776 
1777     // Optional mapping for token URIs
1778     mapping(uint256 => string) private _tokenURIs;
1779 
1780     /**
1781      * @dev See {IERC721Metadata-tokenURI}.
1782      */
1783     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1784         _requireMinted(tokenId);
1785 
1786         string memory _tokenURI = _tokenURIs[tokenId];
1787         string memory base = _baseURI();
1788 
1789         // If there is no base URI, return the token URI.
1790         if (bytes(base).length == 0) {
1791             return _tokenURI;
1792         }
1793         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1794         if (bytes(_tokenURI).length > 0) {
1795             return string(abi.encodePacked(base, _tokenURI));
1796         }
1797 
1798         return super.tokenURI(tokenId);
1799     }
1800 
1801     /**
1802      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1803      *
1804      * Requirements:
1805      *
1806      * - `tokenId` must exist.
1807      */
1808     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1809         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1810         _tokenURIs[tokenId] = _tokenURI;
1811     }
1812 
1813     /**
1814      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1815      * token-specific URI was set for the token, and if so, it deletes the token URI from
1816      * the storage mapping.
1817      */
1818     function _burn(uint256 tokenId) internal virtual override {
1819         super._burn(tokenId);
1820 
1821         if (bytes(_tokenURIs[tokenId]).length != 0) {
1822             delete _tokenURIs[tokenId];
1823         }
1824     }
1825 }
1826 
1827 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1828 
1829 
1830 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1831 
1832 pragma solidity ^0.8.0;
1833 
1834 
1835 
1836 /**
1837  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1838  * enumerability of all the token ids in the contract as well as all token ids owned by each
1839  * account.
1840  */
1841 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1842     // Mapping from owner to list of owned token IDs
1843     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1844 
1845     // Mapping from token ID to index of the owner tokens list
1846     mapping(uint256 => uint256) private _ownedTokensIndex;
1847 
1848     // Array with all token ids, used for enumeration
1849     uint256[] private _allTokens;
1850 
1851     // Mapping from token id to position in the allTokens array
1852     mapping(uint256 => uint256) private _allTokensIndex;
1853 
1854     /**
1855      * @dev See {IERC165-supportsInterface}.
1856      */
1857     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1858         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1859     }
1860 
1861     /**
1862      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1863      */
1864     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1865         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1866         return _ownedTokens[owner][index];
1867     }
1868 
1869     /**
1870      * @dev See {IERC721Enumerable-totalSupply}.
1871      */
1872     function totalSupply() public view virtual override returns (uint256) {
1873         return _allTokens.length;
1874     }
1875 
1876     /**
1877      * @dev See {IERC721Enumerable-tokenByIndex}.
1878      */
1879     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1880         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1881         return _allTokens[index];
1882     }
1883 
1884     /**
1885      * @dev See {ERC721-_beforeTokenTransfer}.
1886      */
1887     function _beforeTokenTransfer(
1888         address from,
1889         address to,
1890         uint256 firstTokenId,
1891         uint256 batchSize
1892     ) internal virtual override {
1893         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1894 
1895         if (batchSize > 1) {
1896             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1897             revert("ERC721Enumerable: consecutive transfers not supported");
1898         }
1899 
1900         uint256 tokenId = firstTokenId;
1901 
1902         if (from == address(0)) {
1903             _addTokenToAllTokensEnumeration(tokenId);
1904         } else if (from != to) {
1905             _removeTokenFromOwnerEnumeration(from, tokenId);
1906         }
1907         if (to == address(0)) {
1908             _removeTokenFromAllTokensEnumeration(tokenId);
1909         } else if (to != from) {
1910             _addTokenToOwnerEnumeration(to, tokenId);
1911         }
1912     }
1913 
1914     /**
1915      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1916      * @param to address representing the new owner of the given token ID
1917      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1918      */
1919     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1920         uint256 length = ERC721.balanceOf(to);
1921         _ownedTokens[to][length] = tokenId;
1922         _ownedTokensIndex[tokenId] = length;
1923     }
1924 
1925     /**
1926      * @dev Private function to add a token to this extension's token tracking data structures.
1927      * @param tokenId uint256 ID of the token to be added to the tokens list
1928      */
1929     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1930         _allTokensIndex[tokenId] = _allTokens.length;
1931         _allTokens.push(tokenId);
1932     }
1933 
1934     /**
1935      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1936      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1937      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1938      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1939      * @param from address representing the previous owner of the given token ID
1940      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1941      */
1942     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1943         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1944         // then delete the last slot (swap and pop).
1945 
1946         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1947         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1948 
1949         // When the token to delete is the last token, the swap operation is unnecessary
1950         if (tokenIndex != lastTokenIndex) {
1951             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1952 
1953             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1954             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1955         }
1956 
1957         // This also deletes the contents at the last position of the array
1958         delete _ownedTokensIndex[tokenId];
1959         delete _ownedTokens[from][lastTokenIndex];
1960     }
1961 
1962     /**
1963      * @dev Private function to remove a token from this extension's token tracking data structures.
1964      * This has O(1) time complexity, but alters the order of the _allTokens array.
1965      * @param tokenId uint256 ID of the token to be removed from the tokens list
1966      */
1967     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1968         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1969         // then delete the last slot (swap and pop).
1970 
1971         uint256 lastTokenIndex = _allTokens.length - 1;
1972         uint256 tokenIndex = _allTokensIndex[tokenId];
1973 
1974         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1975         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1976         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1977         uint256 lastTokenId = _allTokens[lastTokenIndex];
1978 
1979         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1980         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1981 
1982         // This also deletes the contents at the last position of the array
1983         delete _allTokensIndex[tokenId];
1984         _allTokens.pop();
1985     }
1986 }
1987 
1988 // File: inakatabi.sol
1989 
1990 
1991 pragma solidity ^0.8.9;
1992 
1993 
1994 
1995 
1996 
1997 
1998 
1999 
2000 contract InakaTabi is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
2001     using Strings for uint256;
2002     using Counters for Counters.Counter;
2003     Counters.Counter private _tokenIdCounter;
2004 
2005     constructor() ERC721("InakaTabi", "InakaTabi") {}
2006 
2007     string  private baseURI = "https://";
2008     string  private extentionJson = ".json";
2009     uint256 private maxSupply = 2000;
2010     bool    private isSale = false;
2011 
2012     function _baseURI() internal view override returns (string memory) {
2013         return baseURI;
2014     }
2015 
2016     function setBaseURI(string memory _URI) public onlyOwner {
2017         baseURI = _URI;
2018     }
2019 
2020     function pause() public onlyOwner {
2021         _pause();
2022     }
2023 
2024     function unpause() public onlyOwner {
2025         _unpause();
2026     }
2027 
2028     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
2029         internal
2030         whenNotPaused
2031         override(ERC721, ERC721Enumerable)
2032     {
2033         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2034     }
2035 
2036     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
2037         super._burn(tokenId);
2038     }
2039 
2040     function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
2041         string memory currentBaseURI = _baseURI();
2042         require(_exists(tokenId), "Invalid token ID");
2043         return string(abi.encodePacked(currentBaseURI, tokenId.toString(), extentionJson));
2044     }
2045 
2046     function supportsInterface(bytes4 interfaceId)
2047         public
2048         view
2049         override(ERC721, ERC721Enumerable)
2050         returns (bool)
2051     {
2052         return super.supportsInterface(interfaceId);
2053     }
2054 
2055     function whiteSetIsSale(bool _isSale) public onlyOwner {
2056         isSale = _isSale;
2057     }
2058 
2059     bool private isComming = false;
2060 
2061     function whiteOpenSales() public onlyOwner {
2062         isSale = true;
2063         isComming = true;
2064     }
2065 
2066     function whiteCloseSale() public onlyOwner {
2067         isSale = false;
2068     }
2069 
2070     function whiteGetStatus() external view returns(bool[3] memory) {
2071         bool _isComming = isComming;
2072         bool _isClose   = !isSale;
2073         bool _mintedOut = totalSupply() == maxSupply; 
2074 
2075         return [
2076             _isComming,
2077             _isClose,
2078             _mintedOut
2079         ];
2080     }
2081 
2082     function whiteGetAddress() external view returns(bool) {
2083         return WhiteList[msg.sender].isWhite;
2084     }
2085 
2086     function whiteIsMinted() external view returns(bool) {
2087         return WhiteList[msg.sender].isMinted;
2088     }
2089 
2090     function whiteMint() public {
2091         if (isSale) {
2092             require(totalSupply() < maxSupply, "Sold out");
2093             require(WhiteList[msg.sender].isWhite == true, "You're not white list");
2094             require(WhiteList[msg.sender].isMinted == false, "you're already mint");
2095             require(isMintClosed == false, "Minted out");
2096             uint256 tokenId = _tokenIdCounter.current();
2097             tokenId+=1;
2098             _tokenIdCounter.increment();
2099             _safeMint(msg.sender, tokenId);
2100 
2101             WhiteList[msg.sender].isMinted = true;
2102         }
2103         else {
2104             revert("Not Sale");
2105         }
2106     }
2107 
2108     function whiteTeamMint(uint256 _mintAmount) public onlyOwner returns(bool) {
2109         require(isMintClosed == false, "Minted out");
2110         require(totalSupply() + _mintAmount < maxSupply+1, "Sold out");
2111         
2112             uint256 tokenId = _tokenIdCounter.current();
2113             for (uint256 i = 1; i <= _mintAmount; i++) {
2114                 _tokenIdCounter.increment();
2115                 _safeMint(msg.sender, tokenId + i);
2116             }
2117             return true;        
2118     }
2119 
2120     bool private isMintClosed = false;
2121 
2122     function whiteMintClose() public onlyOwner {
2123         isMintClosed = true;
2124     }
2125 
2126     struct WhiteMap {
2127         uint256 idx;
2128         bool isWhite;
2129         bool isMinted;
2130     }
2131     mapping(address => WhiteMap) public WhiteList;
2132     address[] public WhiteGroup;
2133 
2134     function whiteAdd(address _address) public onlyOwner {
2135         WhiteMap storage _WhiteListAddress = WhiteList[_address];
2136 
2137         if(_WhiteListAddress.idx == 0) {
2138             WhiteGroup.push(_address);
2139             uint256 currentIdx = WhiteGroup.length -1;
2140             _WhiteListAddress.idx = currentIdx + 1;
2141             _WhiteListAddress.isWhite = true;
2142         }
2143     }
2144 
2145     function whiteAddBulk(address[] memory _address) public onlyOwner {
2146         for (uint256 i = 0; i < _address.length; i++)
2147         {
2148             address _whiteAddressGroup = _address[i];
2149             WhiteMap storage _WhiteListAddress = WhiteList[_whiteAddressGroup];
2150             _WhiteListAddress.isWhite = true;
2151             if(_WhiteListAddress.idx == 0) {
2152                 WhiteGroup.push(_whiteAddressGroup);
2153                 uint256 currentIdx = WhiteGroup.length -1;
2154                 _WhiteListAddress.idx = currentIdx + 1;
2155             }
2156         }
2157     }
2158 
2159     function whiteRm(address _address) public onlyOwner {
2160         delete WhiteList[_address];
2161     }
2162 
2163     function whiteLength() public view returns(uint256) {
2164         return WhiteGroup.length;        
2165     }
2166 
2167 }