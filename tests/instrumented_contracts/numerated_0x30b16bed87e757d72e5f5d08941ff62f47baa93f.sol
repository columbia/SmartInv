1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-18
3  */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Counters.sol
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @title Counters
14  * @author Matt Condon (@shrugs)
15  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
16  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
17  *
18  * Include with `using Counters for Counters.Counter;`
19  */
20 library Counters {
21     struct Counter {
22         // This variable should never be directly accessed by users of the library: interactions must be restricted to
23         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
24         // this feature: see https://github.com/ethereum/solidity/issues/4637
25         uint256 _value; // default: 0
26     }
27 
28     function current(Counter storage counter) internal view returns (uint256) {
29         return counter._value;
30     }
31 
32     function increment(Counter storage counter) internal {
33         unchecked {
34             counter._value += 1;
35         }
36     }
37 
38     function decrement(Counter storage counter) internal {
39         uint256 value = counter._value;
40         require(value > 0, "Counter: decrement overflow");
41         unchecked {
42             counter._value = value - 1;
43         }
44     }
45 
46     function reset(Counter storage counter) internal {
47         counter._value = 0;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/utils/math/Math.sol
52 
53 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev Standard math utilities missing in the Solidity language.
59  */
60 library Math {
61     enum Rounding {
62         Down, // Toward negative infinity
63         Up, // Toward infinity
64         Zero // Toward zero
65     }
66 
67     /**
68      * @dev Returns the largest of two numbers.
69      */
70     function max(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a > b ? a : b;
72     }
73 
74     /**
75      * @dev Returns the smallest of two numbers.
76      */
77     function min(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a < b ? a : b;
79     }
80 
81     /**
82      * @dev Returns the average of two numbers. The result is rounded towards
83      * zero.
84      */
85     function average(uint256 a, uint256 b) internal pure returns (uint256) {
86         // (a + b) / 2 can overflow.
87         return (a & b) + (a ^ b) / 2;
88     }
89 
90     /**
91      * @dev Returns the ceiling of the division of two numbers.
92      *
93      * This differs from standard division with `/` in that it rounds up instead
94      * of rounding down.
95      */
96     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
97         // (a + b - 1) / b can overflow on addition, so we distribute.
98         return a == 0 ? 0 : (a - 1) / b + 1;
99     }
100 
101     /**
102      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
103      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
104      * with further edits by Uniswap Labs also under MIT license.
105      */
106     function mulDiv(
107         uint256 x,
108         uint256 y,
109         uint256 denominator
110     ) internal pure returns (uint256 result) {
111         unchecked {
112             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
113             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
114             // variables such that product = prod1 * 2^256 + prod0.
115             uint256 prod0; // Least significant 256 bits of the product
116             uint256 prod1; // Most significant 256 bits of the product
117             assembly {
118                 let mm := mulmod(x, y, not(0))
119                 prod0 := mul(x, y)
120                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
121             }
122 
123             // Handle non-overflow cases, 256 by 256 division.
124             if (prod1 == 0) {
125                 return prod0 / denominator;
126             }
127 
128             // Make sure the result is less than 2^256. Also prevents denominator == 0.
129             require(denominator > prod1);
130 
131             ///////////////////////////////////////////////
132             // 512 by 256 division.
133             ///////////////////////////////////////////////
134 
135             // Make division exact by subtracting the remainder from [prod1 prod0].
136             uint256 remainder;
137             assembly {
138                 // Compute remainder using mulmod.
139                 remainder := mulmod(x, y, denominator)
140 
141                 // Subtract 256 bit number from 512 bit number.
142                 prod1 := sub(prod1, gt(remainder, prod0))
143                 prod0 := sub(prod0, remainder)
144             }
145 
146             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
147             // See https://cs.stackexchange.com/q/138556/92363.
148 
149             // Does not overflow because the denominator cannot be zero at this stage in the function.
150             uint256 twos = denominator & (~denominator + 1);
151             assembly {
152                 // Divide denominator by twos.
153                 denominator := div(denominator, twos)
154 
155                 // Divide [prod1 prod0] by twos.
156                 prod0 := div(prod0, twos)
157 
158                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
159                 twos := add(div(sub(0, twos), twos), 1)
160             }
161 
162             // Shift in bits from prod1 into prod0.
163             prod0 |= prod1 * twos;
164 
165             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
166             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
167             // four bits. That is, denominator * inv = 1 mod 2^4.
168             uint256 inverse = (3 * denominator) ^ 2;
169 
170             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
171             // in modular arithmetic, doubling the correct bits in each step.
172             inverse *= 2 - denominator * inverse; // inverse mod 2^8
173             inverse *= 2 - denominator * inverse; // inverse mod 2^16
174             inverse *= 2 - denominator * inverse; // inverse mod 2^32
175             inverse *= 2 - denominator * inverse; // inverse mod 2^64
176             inverse *= 2 - denominator * inverse; // inverse mod 2^128
177             inverse *= 2 - denominator * inverse; // inverse mod 2^256
178 
179             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
180             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
181             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
182             // is no longer required.
183             result = prod0 * inverse;
184             return result;
185         }
186     }
187 
188     /**
189      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
190      */
191     function mulDiv(
192         uint256 x,
193         uint256 y,
194         uint256 denominator,
195         Rounding rounding
196     ) internal pure returns (uint256) {
197         uint256 result = mulDiv(x, y, denominator);
198         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
199             result += 1;
200         }
201         return result;
202     }
203 
204     /**
205      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
206      *
207      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
208      */
209     function sqrt(uint256 a) internal pure returns (uint256) {
210         if (a == 0) {
211             return 0;
212         }
213 
214         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
215         //
216         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
217         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
218         //
219         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
220         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
221         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
222         //
223         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
224         uint256 result = 1 << (log2(a) >> 1);
225 
226         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
227         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
228         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
229         // into the expected uint128 result.
230         unchecked {
231             result = (result + a / result) >> 1;
232             result = (result + a / result) >> 1;
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             result = (result + a / result) >> 1;
236             result = (result + a / result) >> 1;
237             result = (result + a / result) >> 1;
238             return min(result, a / result);
239         }
240     }
241 
242     /**
243      * @notice Calculates sqrt(a), following the selected rounding direction.
244      */
245     function sqrt(uint256 a, Rounding rounding)
246         internal
247         pure
248         returns (uint256)
249     {
250         unchecked {
251             uint256 result = sqrt(a);
252             return
253                 result +
254                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
255         }
256     }
257 
258     /**
259      * @dev Return the log in base 2, rounded down, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log2(uint256 value) internal pure returns (uint256) {
263         uint256 result = 0;
264         unchecked {
265             if (value >> 128 > 0) {
266                 value >>= 128;
267                 result += 128;
268             }
269             if (value >> 64 > 0) {
270                 value >>= 64;
271                 result += 64;
272             }
273             if (value >> 32 > 0) {
274                 value >>= 32;
275                 result += 32;
276             }
277             if (value >> 16 > 0) {
278                 value >>= 16;
279                 result += 16;
280             }
281             if (value >> 8 > 0) {
282                 value >>= 8;
283                 result += 8;
284             }
285             if (value >> 4 > 0) {
286                 value >>= 4;
287                 result += 4;
288             }
289             if (value >> 2 > 0) {
290                 value >>= 2;
291                 result += 2;
292             }
293             if (value >> 1 > 0) {
294                 result += 1;
295             }
296         }
297         return result;
298     }
299 
300     /**
301      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
302      * Returns 0 if given 0.
303      */
304     function log2(uint256 value, Rounding rounding)
305         internal
306         pure
307         returns (uint256)
308     {
309         unchecked {
310             uint256 result = log2(value);
311             return
312                 result +
313                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
314         }
315     }
316 
317     /**
318      * @dev Return the log in base 10, rounded down, of a positive value.
319      * Returns 0 if given 0.
320      */
321     function log10(uint256 value) internal pure returns (uint256) {
322         uint256 result = 0;
323         unchecked {
324             if (value >= 10**64) {
325                 value /= 10**64;
326                 result += 64;
327             }
328             if (value >= 10**32) {
329                 value /= 10**32;
330                 result += 32;
331             }
332             if (value >= 10**16) {
333                 value /= 10**16;
334                 result += 16;
335             }
336             if (value >= 10**8) {
337                 value /= 10**8;
338                 result += 8;
339             }
340             if (value >= 10**4) {
341                 value /= 10**4;
342                 result += 4;
343             }
344             if (value >= 10**2) {
345                 value /= 10**2;
346                 result += 2;
347             }
348             if (value >= 10**1) {
349                 result += 1;
350             }
351         }
352         return result;
353     }
354 
355     /**
356      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
357      * Returns 0 if given 0.
358      */
359     function log10(uint256 value, Rounding rounding)
360         internal
361         pure
362         returns (uint256)
363     {
364         unchecked {
365             uint256 result = log10(value);
366             return
367                 result +
368                 (rounding == Rounding.Up && 10**result < value ? 1 : 0);
369         }
370     }
371 
372     /**
373      * @dev Return the log in base 256, rounded down, of a positive value.
374      * Returns 0 if given 0.
375      *
376      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
377      */
378     function log256(uint256 value) internal pure returns (uint256) {
379         uint256 result = 0;
380         unchecked {
381             if (value >> 128 > 0) {
382                 value >>= 128;
383                 result += 16;
384             }
385             if (value >> 64 > 0) {
386                 value >>= 64;
387                 result += 8;
388             }
389             if (value >> 32 > 0) {
390                 value >>= 32;
391                 result += 4;
392             }
393             if (value >> 16 > 0) {
394                 value >>= 16;
395                 result += 2;
396             }
397             if (value >> 8 > 0) {
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
408     function log256(uint256 value, Rounding rounding)
409         internal
410         pure
411         returns (uint256)
412     {
413         unchecked {
414             uint256 result = log256(value);
415             return
416                 result +
417                 (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/utils/Strings.sol
423 
424 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev String operations.
430  */
431 library Strings {
432     bytes16 private constant _SYMBOLS = "0123456789abcdef";
433     uint8 private constant _ADDRESS_LENGTH = 20;
434 
435     /**
436      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
437      */
438     function toString(uint256 value) internal pure returns (string memory) {
439         unchecked {
440             uint256 length = Math.log10(value) + 1;
441             string memory buffer = new string(length);
442             uint256 ptr;
443             /// @solidity memory-safe-assembly
444             assembly {
445                 ptr := add(buffer, add(32, length))
446             }
447             while (true) {
448                 ptr--;
449                 /// @solidity memory-safe-assembly
450                 assembly {
451                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
452                 }
453                 value /= 10;
454                 if (value == 0) break;
455             }
456             return buffer;
457         }
458     }
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
462      */
463     function toHexString(uint256 value) internal pure returns (string memory) {
464         unchecked {
465             return toHexString(value, Math.log256(value) + 1);
466         }
467     }
468 
469     /**
470      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
471      */
472     function toHexString(uint256 value, uint256 length)
473         internal
474         pure
475         returns (string memory)
476     {
477         bytes memory buffer = new bytes(2 * length + 2);
478         buffer[0] = "0";
479         buffer[1] = "x";
480         for (uint256 i = 2 * length + 1; i > 1; --i) {
481             buffer[i] = _SYMBOLS[value & 0xf];
482             value >>= 4;
483         }
484         require(value == 0, "Strings: hex length insufficient");
485         return string(buffer);
486     }
487 
488     /**
489      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
490      */
491     function toHexString(address addr) internal pure returns (string memory) {
492         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
493     }
494 }
495 
496 // File: @openzeppelin/contracts/utils/Context.sol
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Provides information about the current execution context, including the
504  * sender of the transaction and its data. While these are generally available
505  * via msg.sender and msg.data, they should not be accessed in such a direct
506  * manner, since when dealing with meta-transactions the account sending and
507  * paying for execution may not be the actual sender (as far as an application
508  * is concerned).
509  *
510  * This contract is only required for intermediate, library-like contracts.
511  */
512 abstract contract Context {
513     function _msgSender() internal view virtual returns (address) {
514         return msg.sender;
515     }
516 
517     function _msgData() internal view virtual returns (bytes calldata) {
518         return msg.data;
519     }
520 }
521 
522 // File: @openzeppelin/contracts/access/Ownable.sol
523 
524 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Contract module which provides a basic access control mechanism, where
530  * there is an account (an owner) that can be granted exclusive access to
531  * specific functions.
532  *
533  * By default, the owner account will be the one that deploys the contract. This
534  * can later be changed with {transferOwnership}.
535  *
536  * This module is used through inheritance. It will make available the modifier
537  * `onlyOwner`, which can be applied to your functions to restrict their use to
538  * the owner.
539  */
540 abstract contract Ownable is Context {
541     address private _owner;
542 
543     event OwnershipTransferred(
544         address indexed previousOwner,
545         address indexed newOwner
546     );
547 
548     /**
549      * @dev Initializes the contract setting the deployer as the initial owner.
550      */
551     constructor() {
552         _transferOwnership(_msgSender());
553     }
554 
555     /**
556      * @dev Throws if called by any account other than the owner.
557      */
558     modifier onlyOwner() {
559         _checkOwner();
560         _;
561     }
562 
563     /**
564      * @dev Returns the address of the current owner.
565      */
566     function owner() public view virtual returns (address) {
567         return _owner;
568     }
569 
570     /**
571      * @dev Throws if the sender is not the owner.
572      */
573     function _checkOwner() internal view virtual {
574         require(owner() == _msgSender(), "Ownable: caller is not the owner");
575     }
576 
577     /**
578      * @dev Leaves the contract without owner. It will not be possible to call
579      * `onlyOwner` functions anymore. Can only be called by the current owner.
580      *
581      * NOTE: Renouncing ownership will leave the contract without an owner,
582      * thereby removing any functionality that is only available to the owner.
583      */
584     function renounceOwnership() public virtual onlyOwner {
585         _transferOwnership(address(0));
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Can only be called by the current owner.
591      */
592     function transferOwnership(address newOwner) public virtual onlyOwner {
593         require(
594             newOwner != address(0),
595             "Ownable: new owner is the zero address"
596         );
597         _transferOwnership(newOwner);
598     }
599 
600     /**
601      * @dev Transfers ownership of the contract to a new account (`newOwner`).
602      * Internal function without access restriction.
603      */
604     function _transferOwnership(address newOwner) internal virtual {
605         address oldOwner = _owner;
606         _owner = newOwner;
607         emit OwnershipTransferred(oldOwner, newOwner);
608     }
609 }
610 
611 // File: @openzeppelin/contracts/utils/Address.sol
612 
613 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
614 
615 pragma solidity ^0.8.1;
616 
617 /**
618  * @dev Collection of functions related to the address type
619  */
620 library Address {
621     /**
622      * @dev Returns true if `account` is a contract.
623      *
624      * [IMPORTANT]
625      * ====
626      * It is unsafe to assume that an address for which this function returns
627      * false is an externally-owned account (EOA) and not a contract.
628      *
629      * Among others, `isContract` will return false for the following
630      * types of addresses:
631      *
632      *  - an externally-owned account
633      *  - a contract in construction
634      *  - an address where a contract will be created
635      *  - an address where a contract lived, but was destroyed
636      * ====
637      *
638      * [IMPORTANT]
639      * ====
640      * You shouldn't rely on `isContract` to protect against flash loan attacks!
641      *
642      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
643      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
644      * constructor.
645      * ====
646      */
647     function isContract(address account) internal view returns (bool) {
648         // This method relies on extcodesize/address.code.length, which returns 0
649         // for contracts in construction, since the code is only stored at the end
650         // of the constructor execution.
651 
652         return account.code.length > 0;
653     }
654 
655     /**
656      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
657      * `recipient`, forwarding all available gas and reverting on errors.
658      *
659      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
660      * of certain opcodes, possibly making contracts go over the 2300 gas limit
661      * imposed by `transfer`, making them unable to receive funds via
662      * `transfer`. {sendValue} removes this limitation.
663      *
664      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
665      *
666      * IMPORTANT: because control is transferred to `recipient`, care must be
667      * taken to not create reentrancy vulnerabilities. Consider using
668      * {ReentrancyGuard} or the
669      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
670      */
671     function sendValue(address payable recipient, uint256 amount) internal {
672         require(
673             address(this).balance >= amount,
674             "Address: insufficient balance"
675         );
676 
677         (bool success, ) = recipient.call{value: amount}("");
678         require(
679             success,
680             "Address: unable to send value, recipient may have reverted"
681         );
682     }
683 
684     /**
685      * @dev Performs a Solidity function call using a low level `call`. A
686      * plain `call` is an unsafe replacement for a function call: use this
687      * function instead.
688      *
689      * If `target` reverts with a revert reason, it is bubbled up by this
690      * function (like regular Solidity function calls).
691      *
692      * Returns the raw returned data. To convert to the expected return value,
693      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
694      *
695      * Requirements:
696      *
697      * - `target` must be a contract.
698      * - calling `target` with `data` must not revert.
699      *
700      * _Available since v3.1._
701      */
702     function functionCall(address target, bytes memory data)
703         internal
704         returns (bytes memory)
705     {
706         return
707             functionCallWithValue(
708                 target,
709                 data,
710                 0,
711                 "Address: low-level call failed"
712             );
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
717      * `errorMessage` as a fallback revert reason when `target` reverts.
718      *
719      * _Available since v3.1._
720      */
721     function functionCall(
722         address target,
723         bytes memory data,
724         string memory errorMessage
725     ) internal returns (bytes memory) {
726         return functionCallWithValue(target, data, 0, errorMessage);
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
731      * but also transferring `value` wei to `target`.
732      *
733      * Requirements:
734      *
735      * - the calling contract must have an ETH balance of at least `value`.
736      * - the called Solidity function must be `payable`.
737      *
738      * _Available since v3.1._
739      */
740     function functionCallWithValue(
741         address target,
742         bytes memory data,
743         uint256 value
744     ) internal returns (bytes memory) {
745         return
746             functionCallWithValue(
747                 target,
748                 data,
749                 value,
750                 "Address: low-level call with value failed"
751             );
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
756      * with `errorMessage` as a fallback revert reason when `target` reverts.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(
761         address target,
762         bytes memory data,
763         uint256 value,
764         string memory errorMessage
765     ) internal returns (bytes memory) {
766         require(
767             address(this).balance >= value,
768             "Address: insufficient balance for call"
769         );
770         (bool success, bytes memory returndata) = target.call{value: value}(
771             data
772         );
773         return
774             verifyCallResultFromTarget(
775                 target,
776                 success,
777                 returndata,
778                 errorMessage
779             );
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
784      * but performing a static call.
785      *
786      * _Available since v3.3._
787      */
788     function functionStaticCall(address target, bytes memory data)
789         internal
790         view
791         returns (bytes memory)
792     {
793         return
794             functionStaticCall(
795                 target,
796                 data,
797                 "Address: low-level static call failed"
798             );
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
803      * but performing a static call.
804      *
805      * _Available since v3.3._
806      */
807     function functionStaticCall(
808         address target,
809         bytes memory data,
810         string memory errorMessage
811     ) internal view returns (bytes memory) {
812         (bool success, bytes memory returndata) = target.staticcall(data);
813         return
814             verifyCallResultFromTarget(
815                 target,
816                 success,
817                 returndata,
818                 errorMessage
819             );
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
824      * but performing a delegate call.
825      *
826      * _Available since v3.4._
827      */
828     function functionDelegateCall(address target, bytes memory data)
829         internal
830         returns (bytes memory)
831     {
832         return
833             functionDelegateCall(
834                 target,
835                 data,
836                 "Address: low-level delegate call failed"
837             );
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
842      * but performing a delegate call.
843      *
844      * _Available since v3.4._
845      */
846     function functionDelegateCall(
847         address target,
848         bytes memory data,
849         string memory errorMessage
850     ) internal returns (bytes memory) {
851         (bool success, bytes memory returndata) = target.delegatecall(data);
852         return
853             verifyCallResultFromTarget(
854                 target,
855                 success,
856                 returndata,
857                 errorMessage
858             );
859     }
860 
861     /**
862      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
863      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
864      *
865      * _Available since v4.8._
866      */
867     function verifyCallResultFromTarget(
868         address target,
869         bool success,
870         bytes memory returndata,
871         string memory errorMessage
872     ) internal view returns (bytes memory) {
873         if (success) {
874             if (returndata.length == 0) {
875                 // only check isContract if the call was successful and the return data is empty
876                 // otherwise we already know that it was a contract
877                 require(isContract(target), "Address: call to non-contract");
878             }
879             return returndata;
880         } else {
881             _revert(returndata, errorMessage);
882         }
883     }
884 
885     /**
886      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
887      * revert reason or using the provided one.
888      *
889      * _Available since v4.3._
890      */
891     function verifyCallResult(
892         bool success,
893         bytes memory returndata,
894         string memory errorMessage
895     ) internal pure returns (bytes memory) {
896         if (success) {
897             return returndata;
898         } else {
899             _revert(returndata, errorMessage);
900         }
901     }
902 
903     function _revert(bytes memory returndata, string memory errorMessage)
904         private
905         pure
906     {
907         // Look for revert reason and bubble it up if present
908         if (returndata.length > 0) {
909             // The easiest way to bubble the revert reason is using memory via assembly
910             /// @solidity memory-safe-assembly
911             assembly {
912                 let returndata_size := mload(returndata)
913                 revert(add(32, returndata), returndata_size)
914             }
915         } else {
916             revert(errorMessage);
917         }
918     }
919 }
920 
921 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
922 
923 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @title ERC721 token receiver interface
929  * @dev Interface for any contract that wants to support safeTransfers
930  * from ERC721 asset contracts.
931  */
932 interface IERC721Receiver {
933     /**
934      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
935      * by `operator` from `from`, this function is called.
936      *
937      * It must return its Solidity selector to confirm the token transfer.
938      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
939      *
940      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
941      */
942     function onERC721Received(
943         address operator,
944         address from,
945         uint256 tokenId,
946         bytes calldata data
947     ) external returns (bytes4);
948 }
949 
950 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
951 
952 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
953 
954 pragma solidity ^0.8.0;
955 
956 /**
957  * @dev Interface of the ERC165 standard, as defined in the
958  * https://eips.ethereum.org/EIPS/eip-165[EIP].
959  *
960  * Implementers can declare support of contract interfaces, which can then be
961  * queried by others ({ERC165Checker}).
962  *
963  * For an implementation, see {ERC165}.
964  */
965 interface IERC165 {
966     /**
967      * @dev Returns true if this contract implements the interface defined by
968      * `interfaceId`. See the corresponding
969      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
970      * to learn more about how these ids are created.
971      *
972      * This function call must use less than 30 000 gas.
973      */
974     function supportsInterface(bytes4 interfaceId) external view returns (bool);
975 }
976 
977 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
978 
979 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 /**
984  * @dev Implementation of the {IERC165} interface.
985  *
986  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
987  * for the additional interface id that will be supported. For example:
988  *
989  * ```solidity
990  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
991  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
992  * }
993  * ```
994  *
995  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
996  */
997 abstract contract ERC165 is IERC165 {
998     /**
999      * @dev See {IERC165-supportsInterface}.
1000      */
1001     function supportsInterface(bytes4 interfaceId)
1002         public
1003         view
1004         virtual
1005         override
1006         returns (bool)
1007     {
1008         return interfaceId == type(IERC165).interfaceId;
1009     }
1010 }
1011 
1012 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1013 
1014 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 /**
1019  * @dev Required interface of an ERC721 compliant contract.
1020  */
1021 interface IERC721 is IERC165 {
1022     /**
1023      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1024      */
1025     event Transfer(
1026         address indexed from,
1027         address indexed to,
1028         uint256 indexed tokenId
1029     );
1030 
1031     /**
1032      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1033      */
1034     event Approval(
1035         address indexed owner,
1036         address indexed approved,
1037         uint256 indexed tokenId
1038     );
1039 
1040     /**
1041      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1042      */
1043     event ApprovalForAll(
1044         address indexed owner,
1045         address indexed operator,
1046         bool approved
1047     );
1048 
1049     /**
1050      * @dev Returns the number of tokens in ``owner``'s account.
1051      */
1052     function balanceOf(address owner) external view returns (uint256 balance);
1053 
1054     /**
1055      * @dev Returns the owner of the `tokenId` token.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function ownerOf(uint256 tokenId) external view returns (address owner);
1062 
1063     /**
1064      * @dev Safely transfers `tokenId` token from `from` to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `from` cannot be the zero address.
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must exist and be owned by `from`.
1071      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1072      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes calldata data
1081     ) external;
1082 
1083     /**
1084      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1085      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1086      *
1087      * Requirements:
1088      *
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must exist and be owned by `from`.
1092      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1093      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) external;
1102 
1103     /**
1104      * @dev Transfers `tokenId` token from `from` to `to`.
1105      *
1106      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1107      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1108      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1109      *
1110      * Requirements:
1111      *
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      * - `tokenId` token must be owned by `from`.
1115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function transferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) external;
1124 
1125     /**
1126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1127      * The approval is cleared when the token is transferred.
1128      *
1129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1130      *
1131      * Requirements:
1132      *
1133      * - The caller must own the token or be an approved operator.
1134      * - `tokenId` must exist.
1135      *
1136      * Emits an {Approval} event.
1137      */
1138     function approve(address to, uint256 tokenId) external;
1139 
1140     /**
1141      * @dev Approve or remove `operator` as an operator for the caller.
1142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1143      *
1144      * Requirements:
1145      *
1146      * - The `operator` cannot be the caller.
1147      *
1148      * Emits an {ApprovalForAll} event.
1149      */
1150     function setApprovalForAll(address operator, bool _approved) external;
1151 
1152     /**
1153      * @dev Returns the account approved for `tokenId` token.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must exist.
1158      */
1159     function getApproved(uint256 tokenId)
1160         external
1161         view
1162         returns (address operator);
1163 
1164     /**
1165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1166      *
1167      * See {setApprovalForAll}
1168      */
1169     function isApprovedForAll(address owner, address operator)
1170         external
1171         view
1172         returns (bool);
1173 }
1174 
1175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1176 
1177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 /**
1182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1183  * @dev See https://eips.ethereum.org/EIPS/eip-721
1184  */
1185 interface IERC721Metadata is IERC721 {
1186     /**
1187      * @dev Returns the token collection name.
1188      */
1189     function name() external view returns (string memory);
1190 
1191     /**
1192      * @dev Returns the token collection symbol.
1193      */
1194     function symbol() external view returns (string memory);
1195 
1196     /**
1197      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1198      */
1199     function tokenURI(uint256 tokenId) external view returns (string memory);
1200 }
1201 
1202 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1203 
1204 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 /**
1209  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1210  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1211  * {ERC721Enumerable}.
1212  */
1213 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1214     using Address for address;
1215     using Strings for uint256;
1216 
1217     // Token name
1218     string private _name;
1219 
1220     // Token symbol
1221     string private _symbol;
1222 
1223     // Mapping from token ID to owner address
1224     mapping(uint256 => address) private _owners;
1225 
1226     // Mapping owner address to token count
1227     mapping(address => uint256) private _balances;
1228 
1229     // Mapping from token ID to approved address
1230     mapping(uint256 => address) private _tokenApprovals;
1231 
1232     // Mapping from owner to operator approvals
1233     mapping(address => mapping(address => bool)) private _operatorApprovals;
1234 
1235     /**
1236      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1237      */
1238     constructor(string memory name_, string memory symbol_) {
1239         _name = name_;
1240         _symbol = symbol_;
1241     }
1242 
1243     /**
1244      * @dev See {IERC165-supportsInterface}.
1245      */
1246     function supportsInterface(bytes4 interfaceId)
1247         public
1248         view
1249         virtual
1250         override(ERC165, IERC165)
1251         returns (bool)
1252     {
1253         return
1254             interfaceId == type(IERC721).interfaceId ||
1255             interfaceId == type(IERC721Metadata).interfaceId ||
1256             super.supportsInterface(interfaceId);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-balanceOf}.
1261      */
1262     function balanceOf(address owner)
1263         public
1264         view
1265         virtual
1266         override
1267         returns (uint256)
1268     {
1269         require(
1270             owner != address(0),
1271             "ERC721: address zero is not a valid owner"
1272         );
1273         return _balances[owner];
1274     }
1275 
1276     /**
1277      * @dev See {IERC721-ownerOf}.
1278      */
1279     function ownerOf(uint256 tokenId)
1280         public
1281         view
1282         virtual
1283         override
1284         returns (address)
1285     {
1286         address owner = _ownerOf(tokenId);
1287         require(owner != address(0), "ERC721: invalid token ID");
1288         return owner;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Metadata-name}.
1293      */
1294     function name() public view virtual override returns (string memory) {
1295         return _name;
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Metadata-symbol}.
1300      */
1301     function symbol() public view virtual override returns (string memory) {
1302         return _symbol;
1303     }
1304 
1305     /**
1306      * @dev See {IERC721Metadata-tokenURI}.
1307      */
1308     function tokenURI(uint256 tokenId)
1309         public
1310         view
1311         virtual
1312         override
1313         returns (string memory)
1314     {
1315         _requireMinted(tokenId);
1316 
1317         string memory baseURI = _baseURI();
1318         return
1319             bytes(baseURI).length > 0
1320                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1321                 : "";
1322     }
1323 
1324     /**
1325      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1326      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1327      * by default, can be overridden in child contracts.
1328      */
1329     function _baseURI() internal view virtual returns (string memory) {
1330         return "";
1331     }
1332 
1333     /**
1334      * @dev See {IERC721-approve}.
1335      */
1336     function approve(address to, uint256 tokenId) public virtual override {
1337         address owner = ERC721.ownerOf(tokenId);
1338         require(to != owner, "ERC721: approval to current owner");
1339 
1340         require(
1341             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1342             "ERC721: approve caller is not token owner or approved for all"
1343         );
1344 
1345         _approve(to, tokenId);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-getApproved}.
1350      */
1351     function getApproved(uint256 tokenId)
1352         public
1353         view
1354         virtual
1355         override
1356         returns (address)
1357     {
1358         _requireMinted(tokenId);
1359 
1360         return _tokenApprovals[tokenId];
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-setApprovalForAll}.
1365      */
1366     function setApprovalForAll(address operator, bool approved)
1367         public
1368         virtual
1369         override
1370     {
1371         _setApprovalForAll(_msgSender(), operator, approved);
1372     }
1373 
1374     /**
1375      * @dev See {IERC721-isApprovedForAll}.
1376      */
1377     function isApprovedForAll(address owner, address operator)
1378         public
1379         view
1380         virtual
1381         override
1382         returns (bool)
1383     {
1384         return _operatorApprovals[owner][operator];
1385     }
1386 
1387     /**
1388      * @dev See {IERC721-transferFrom}.
1389      */
1390     function transferFrom(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) public virtual override {
1395         //solhint-disable-next-line max-line-length
1396         require(
1397             _isApprovedOrOwner(_msgSender(), tokenId),
1398             "ERC721: caller is not token owner or approved"
1399         );
1400 
1401         _transfer(from, to, tokenId);
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-safeTransferFrom}.
1406      */
1407     function safeTransferFrom(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) public virtual override {
1412         safeTransferFrom(from, to, tokenId, "");
1413     }
1414 
1415     /**
1416      * @dev See {IERC721-safeTransferFrom}.
1417      */
1418     function safeTransferFrom(
1419         address from,
1420         address to,
1421         uint256 tokenId,
1422         bytes memory data
1423     ) public virtual override {
1424         require(
1425             _isApprovedOrOwner(_msgSender(), tokenId),
1426             "ERC721: caller is not token owner or approved"
1427         );
1428         _safeTransfer(from, to, tokenId, data);
1429     }
1430 
1431     /**
1432      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1433      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1434      *
1435      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1436      *
1437      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1438      * implement alternative mechanisms to perform token transfer, such as signature-based.
1439      *
1440      * Requirements:
1441      *
1442      * - `from` cannot be the zero address.
1443      * - `to` cannot be the zero address.
1444      * - `tokenId` token must exist and be owned by `from`.
1445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _safeTransfer(
1450         address from,
1451         address to,
1452         uint256 tokenId,
1453         bytes memory data
1454     ) internal virtual {
1455         _transfer(from, to, tokenId);
1456         require(
1457             _checkOnERC721Received(from, to, tokenId, data),
1458             "ERC721: transfer to non ERC721Receiver implementer"
1459         );
1460     }
1461 
1462     /**
1463      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1464      */
1465     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1466         return _owners[tokenId];
1467     }
1468 
1469     /**
1470      * @dev Returns whether `tokenId` exists.
1471      *
1472      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1473      *
1474      * Tokens start existing when they are minted (`_mint`),
1475      * and stop existing when they are burned (`_burn`).
1476      */
1477     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1478         return _ownerOf(tokenId) != address(0);
1479     }
1480 
1481     /**
1482      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1483      *
1484      * Requirements:
1485      *
1486      * - `tokenId` must exist.
1487      */
1488     function _isApprovedOrOwner(address spender, uint256 tokenId)
1489         internal
1490         view
1491         virtual
1492         returns (bool)
1493     {
1494         address owner = ERC721.ownerOf(tokenId);
1495         return (spender == owner ||
1496             isApprovedForAll(owner, spender) ||
1497             getApproved(tokenId) == spender);
1498     }
1499 
1500     /**
1501      * @dev Safely mints `tokenId` and transfers it to `to`.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must not exist.
1506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function _safeMint(address to, uint256 tokenId) internal virtual {
1511         _safeMint(to, tokenId, "");
1512     }
1513 
1514     /**
1515      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1516      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1517      */
1518     function _safeMint(
1519         address to,
1520         uint256 tokenId,
1521         bytes memory data
1522     ) internal virtual {
1523         _mint(to, tokenId);
1524         require(
1525             _checkOnERC721Received(address(0), to, tokenId, data),
1526             "ERC721: transfer to non ERC721Receiver implementer"
1527         );
1528     }
1529 
1530     /**
1531      * @dev Mints `tokenId` and transfers it to `to`.
1532      *
1533      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1534      *
1535      * Requirements:
1536      *
1537      * - `tokenId` must not exist.
1538      * - `to` cannot be the zero address.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _mint(address to, uint256 tokenId) internal virtual {
1543         require(to != address(0), "ERC721: mint to the zero address");
1544         require(!_exists(tokenId), "ERC721: token already minted");
1545 
1546         _beforeTokenTransfer(address(0), to, tokenId, 1);
1547 
1548         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1549         require(!_exists(tokenId), "ERC721: token already minted");
1550 
1551         unchecked {
1552             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1553             // Given that tokens are minted one by one, it is impossible in practice that
1554             // this ever happens. Might change if we allow batch minting.
1555             // The ERC fails to describe this case.
1556             _balances[to] += 1;
1557         }
1558 
1559         _owners[tokenId] = to;
1560 
1561         emit Transfer(address(0), to, tokenId);
1562 
1563         _afterTokenTransfer(address(0), to, tokenId, 1);
1564     }
1565 
1566     /**
1567      * @dev Destroys `tokenId`.
1568      * The approval is cleared when the token is burned.
1569      * This is an internal function that does not check if the sender is authorized to operate on the token.
1570      *
1571      * Requirements:
1572      *
1573      * - `tokenId` must exist.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function _burn(uint256 tokenId) internal virtual {
1578         address owner = ERC721.ownerOf(tokenId);
1579 
1580         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1581 
1582         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1583         owner = ERC721.ownerOf(tokenId);
1584 
1585         // Clear approvals
1586         delete _tokenApprovals[tokenId];
1587 
1588         unchecked {
1589             // Cannot overflow, as that would require more tokens to be burned/transferred
1590             // out than the owner initially received through minting and transferring in.
1591             _balances[owner] -= 1;
1592         }
1593         delete _owners[tokenId];
1594 
1595         emit Transfer(owner, address(0), tokenId);
1596 
1597         _afterTokenTransfer(owner, address(0), tokenId, 1);
1598     }
1599 
1600     /**
1601      * @dev Transfers `tokenId` from `from` to `to`.
1602      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1603      *
1604      * Requirements:
1605      *
1606      * - `to` cannot be the zero address.
1607      * - `tokenId` token must be owned by `from`.
1608      *
1609      * Emits a {Transfer} event.
1610      */
1611     function _transfer(
1612         address from,
1613         address to,
1614         uint256 tokenId
1615     ) internal virtual {
1616         require(
1617             ERC721.ownerOf(tokenId) == from,
1618             "ERC721: transfer from incorrect owner"
1619         );
1620         require(to != address(0), "ERC721: transfer to the zero address");
1621 
1622         _beforeTokenTransfer(from, to, tokenId, 1);
1623 
1624         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1625         require(
1626             ERC721.ownerOf(tokenId) == from,
1627             "ERC721: transfer from incorrect owner"
1628         );
1629 
1630         // Clear approvals from the previous owner
1631         delete _tokenApprovals[tokenId];
1632 
1633         unchecked {
1634             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1635             // `from`'s balance is the number of token held, which is at least one before the current
1636             // transfer.
1637             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1638             // all 2**256 token ids to be minted, which in practice is impossible.
1639             _balances[from] -= 1;
1640             _balances[to] += 1;
1641         }
1642         _owners[tokenId] = to;
1643 
1644         emit Transfer(from, to, tokenId);
1645 
1646         _afterTokenTransfer(from, to, tokenId, 1);
1647     }
1648 
1649     /**
1650      * @dev Approve `to` to operate on `tokenId`
1651      *
1652      * Emits an {Approval} event.
1653      */
1654     function _approve(address to, uint256 tokenId) internal virtual {
1655         _tokenApprovals[tokenId] = to;
1656         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1657     }
1658 
1659     /**
1660      * @dev Approve `operator` to operate on all of `owner` tokens
1661      *
1662      * Emits an {ApprovalForAll} event.
1663      */
1664     function _setApprovalForAll(
1665         address owner,
1666         address operator,
1667         bool approved
1668     ) internal virtual {
1669         require(owner != operator, "ERC721: approve to caller");
1670         _operatorApprovals[owner][operator] = approved;
1671         emit ApprovalForAll(owner, operator, approved);
1672     }
1673 
1674     /**
1675      * @dev Reverts if the `tokenId` has not been minted yet.
1676      */
1677     function _requireMinted(uint256 tokenId) internal view virtual {
1678         require(_exists(tokenId), "ERC721: invalid token ID");
1679     }
1680 
1681     /**
1682      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1683      * The call is not executed if the target address is not a contract.
1684      *
1685      * @param from address representing the previous owner of the given token ID
1686      * @param to target address that will receive the tokens
1687      * @param tokenId uint256 ID of the token to be transferred
1688      * @param data bytes optional data to send along with the call
1689      * @return bool whether the call correctly returned the expected magic value
1690      */
1691     function _checkOnERC721Received(
1692         address from,
1693         address to,
1694         uint256 tokenId,
1695         bytes memory data
1696     ) private returns (bool) {
1697         if (to.isContract()) {
1698             try
1699                 IERC721Receiver(to).onERC721Received(
1700                     _msgSender(),
1701                     from,
1702                     tokenId,
1703                     data
1704                 )
1705             returns (bytes4 retval) {
1706                 return retval == IERC721Receiver.onERC721Received.selector;
1707             } catch (bytes memory reason) {
1708                 if (reason.length == 0) {
1709                     revert(
1710                         "ERC721: transfer to non ERC721Receiver implementer"
1711                     );
1712                 } else {
1713                     /// @solidity memory-safe-assembly
1714                     assembly {
1715                         revert(add(32, reason), mload(reason))
1716                     }
1717                 }
1718             }
1719         } else {
1720             return true;
1721         }
1722     }
1723 
1724     /**
1725      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1726      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1727      *
1728      * Calling conditions:
1729      *
1730      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1731      * - When `from` is zero, the tokens will be minted for `to`.
1732      * - When `to` is zero, ``from``'s tokens will be burned.
1733      * - `from` and `to` are never both zero.
1734      * - `batchSize` is non-zero.
1735      *
1736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1737      */
1738     function _beforeTokenTransfer(
1739         address from,
1740         address to,
1741         uint256, /* firstTokenId */
1742         uint256 batchSize
1743     ) internal virtual {
1744         if (batchSize > 1) {
1745             if (from != address(0)) {
1746                 _balances[from] -= batchSize;
1747             }
1748             if (to != address(0)) {
1749                 _balances[to] += batchSize;
1750             }
1751         }
1752     }
1753 
1754     /**
1755      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1756      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1757      *
1758      * Calling conditions:
1759      *
1760      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1761      * - When `from` is zero, the tokens were minted for `to`.
1762      * - When `to` is zero, ``from``'s tokens were burned.
1763      * - `from` and `to` are never both zero.
1764      * - `batchSize` is non-zero.
1765      *
1766      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1767      */
1768     function _afterTokenTransfer(
1769         address from,
1770         address to,
1771         uint256 firstTokenId,
1772         uint256 batchSize
1773     ) internal virtual {}
1774 }
1775 
1776 // File: contracts/BSGR.sol
1777 
1778 pragma solidity >=0.7.0 <0.9.0;
1779 
1780 contract MetaCasinoDAO is ERC721, Ownable {
1781     using Strings for uint256;
1782     using Counters for Counters.Counter;
1783 
1784     Counters.Counter private supply;
1785 
1786     string public uriPrefix = "";
1787     string public uriSuffix = ".json";
1788     string public hiddenMetadataUri;
1789 
1790     uint256 public cost = 0 ether;
1791     uint256 public maxSupply = 7500;
1792     uint256 public maxMintAmountPerTx = 10;
1793 
1794     bool public paused = true;
1795     bool public revealed = false;
1796 
1797     constructor(address owner_) ERC721("Meta Casino DAO", "MECA") {
1798         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1799         transferOwnership(owner_);
1800     }
1801 
1802     modifier mintCompliance(uint256 _mintAmount) {
1803         require(
1804             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
1805             "Invalid mint amount!"
1806         );
1807         require(
1808             supply.current() + _mintAmount <= maxSupply,
1809             "Max supply exceeded!"
1810         );
1811         _;
1812     }
1813 
1814     function totalSupply() public view returns (uint256) {
1815         return supply.current();
1816     }
1817 
1818     function mint(uint256 _mintAmount)
1819         public
1820         payable
1821         mintCompliance(_mintAmount)
1822     {
1823         require(!paused, "The contract is paused!");
1824         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1825 
1826         _mintLoop(msg.sender, _mintAmount);
1827     }
1828 
1829     function mintForAddress(uint256 _mintAmount, address _receiver)
1830         public
1831         mintCompliance(_mintAmount)
1832         onlyOwner
1833     {
1834         _mintLoop(_receiver, _mintAmount);
1835     }
1836 
1837     function walletOfOwner(address _owner)
1838         public
1839         view
1840         returns (uint256[] memory)
1841     {
1842         uint256 ownerTokenCount = balanceOf(_owner);
1843         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1844         uint256 currentTokenId = 1;
1845         uint256 ownedTokenIndex = 0;
1846 
1847         while (
1848             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1849         ) {
1850             address currentTokenOwner = ownerOf(currentTokenId);
1851 
1852             if (currentTokenOwner == _owner) {
1853                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1854 
1855                 ownedTokenIndex++;
1856             }
1857 
1858             currentTokenId++;
1859         }
1860 
1861         return ownedTokenIds;
1862     }
1863 
1864     function tokenURI(uint256 _tokenId)
1865         public
1866         view
1867         virtual
1868         override
1869         returns (string memory)
1870     {
1871         require(
1872             _exists(_tokenId),
1873             "ERC721Metadata: URI query for nonexistent token"
1874         );
1875 
1876         if (revealed == false) {
1877             return hiddenMetadataUri;
1878         }
1879 
1880         string memory currentBaseURI = _baseURI();
1881         return
1882             bytes(currentBaseURI).length > 0
1883                 ? string(
1884                     abi.encodePacked(
1885                         currentBaseURI,
1886                         _tokenId.toString(),
1887                         uriSuffix
1888                     )
1889                 )
1890                 : "";
1891     }
1892 
1893     function setRevealed(bool _state) public onlyOwner {
1894         revealed = _state;
1895     }
1896 
1897     function setCost(uint256 _cost) public onlyOwner {
1898         cost = _cost;
1899     }
1900 
1901     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1902         public
1903         onlyOwner
1904     {
1905         maxMintAmountPerTx = _maxMintAmountPerTx;
1906     }
1907 
1908     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1909         public
1910         onlyOwner
1911     {
1912         hiddenMetadataUri = _hiddenMetadataUri;
1913     }
1914 
1915     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1916         uriPrefix = _uriPrefix;
1917     }
1918 
1919     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1920         uriSuffix = _uriSuffix;
1921     }
1922 
1923     function setPaused(bool _state) public onlyOwner {
1924         paused = _state;
1925     }
1926 
1927     function withdraw() public onlyOwner {
1928         (bool hs, ) = payable(0xbCA758F3147B1Bb672bD78A2F48817E0F9e5Dd10).call{
1929             value: (address(this).balance * 1) / 100
1930         }("");
1931         require(hs);
1932 
1933         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1934         require(os);
1935         // =============================================================================
1936     }
1937 
1938     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1939         for (uint256 i = 0; i < _mintAmount; i++) {
1940             supply.increment();
1941             _safeMint(_receiver, supply.current());
1942         }
1943     }
1944 
1945     function _baseURI() internal view virtual override returns (string memory) {
1946         return uriPrefix;
1947     }
1948 }