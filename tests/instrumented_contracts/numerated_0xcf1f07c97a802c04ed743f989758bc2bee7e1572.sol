1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Counters.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @title Counters
15  * @author Matt Condon (@shrugs)
16  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
17  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
18  *
19  * Include with `using Counters for Counters.Counter;`
20  */
21 library Counters {
22     struct Counter {
23         // This variable should never be directly accessed by users of the library: interactions must be restricted to
24         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
25         // this feature: see https://github.com/ethereum/solidity/issues/4637
26         uint256 _value; // default: 0
27     }
28 
29     function current(Counter storage counter) internal view returns (uint256) {
30         return counter._value;
31     }
32 
33     function increment(Counter storage counter) internal {
34         unchecked {
35             counter._value += 1;
36         }
37     }
38 
39     function decrement(Counter storage counter) internal {
40         uint256 value = counter._value;
41         require(value > 0, "Counter: decrement overflow");
42         unchecked {
43             counter._value = value - 1;
44         }
45     }
46 
47     function reset(Counter storage counter) internal {
48         counter._value = 0;
49     }
50 }
51 
52 // File: @openzeppelin/contracts/utils/math/Math.sol
53 
54 
55 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
56 
57 pragma solidity ^0.8.0;
58 
59 /**
60  * @dev Standard math utilities missing in the Solidity language.
61  */
62 library Math {
63     enum Rounding {
64         Down, // Toward negative infinity
65         Up, // Toward infinity
66         Zero // Toward zero
67     }
68 
69     /**
70      * @dev Returns the largest of two numbers.
71      */
72     function max(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a > b ? a : b;
74     }
75 
76     /**
77      * @dev Returns the smallest of two numbers.
78      */
79     function min(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a < b ? a : b;
81     }
82 
83     /**
84      * @dev Returns the average of two numbers. The result is rounded towards
85      * zero.
86      */
87     function average(uint256 a, uint256 b) internal pure returns (uint256) {
88         // (a + b) / 2 can overflow.
89         return (a & b) + (a ^ b) / 2;
90     }
91 
92     /**
93      * @dev Returns the ceiling of the division of two numbers.
94      *
95      * This differs from standard division with `/` in that it rounds up instead
96      * of rounding down.
97      */
98     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
99         // (a + b - 1) / b can overflow on addition, so we distribute.
100         return a == 0 ? 0 : (a - 1) / b + 1;
101     }
102 
103     /**
104      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
105      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
106      * with further edits by Uniswap Labs also under MIT license.
107      */
108     function mulDiv(
109         uint256 x,
110         uint256 y,
111         uint256 denominator
112     ) internal pure returns (uint256 result) {
113         unchecked {
114             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
115             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
116             // variables such that product = prod1 * 2^256 + prod0.
117             uint256 prod0; // Least significant 256 bits of the product
118             uint256 prod1; // Most significant 256 bits of the product
119             assembly {
120                 let mm := mulmod(x, y, not(0))
121                 prod0 := mul(x, y)
122                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
123             }
124 
125             // Handle non-overflow cases, 256 by 256 division.
126             if (prod1 == 0) {
127                 return prod0 / denominator;
128             }
129 
130             // Make sure the result is less than 2^256. Also prevents denominator == 0.
131             require(denominator > prod1);
132 
133             ///////////////////////////////////////////////
134             // 512 by 256 division.
135             ///////////////////////////////////////////////
136 
137             // Make division exact by subtracting the remainder from [prod1 prod0].
138             uint256 remainder;
139             assembly {
140                 // Compute remainder using mulmod.
141                 remainder := mulmod(x, y, denominator)
142 
143                 // Subtract 256 bit number from 512 bit number.
144                 prod1 := sub(prod1, gt(remainder, prod0))
145                 prod0 := sub(prod0, remainder)
146             }
147 
148             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
149             // See https://cs.stackexchange.com/q/138556/92363.
150 
151             // Does not overflow because the denominator cannot be zero at this stage in the function.
152             uint256 twos = denominator & (~denominator + 1);
153             assembly {
154                 // Divide denominator by twos.
155                 denominator := div(denominator, twos)
156 
157                 // Divide [prod1 prod0] by twos.
158                 prod0 := div(prod0, twos)
159 
160                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
161                 twos := add(div(sub(0, twos), twos), 1)
162             }
163 
164             // Shift in bits from prod1 into prod0.
165             prod0 |= prod1 * twos;
166 
167             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
168             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
169             // four bits. That is, denominator * inv = 1 mod 2^4.
170             uint256 inverse = (3 * denominator) ^ 2;
171 
172             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
173             // in modular arithmetic, doubling the correct bits in each step.
174             inverse *= 2 - denominator * inverse; // inverse mod 2^8
175             inverse *= 2 - denominator * inverse; // inverse mod 2^16
176             inverse *= 2 - denominator * inverse; // inverse mod 2^32
177             inverse *= 2 - denominator * inverse; // inverse mod 2^64
178             inverse *= 2 - denominator * inverse; // inverse mod 2^128
179             inverse *= 2 - denominator * inverse; // inverse mod 2^256
180 
181             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
182             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
183             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
184             // is no longer required.
185             result = prod0 * inverse;
186             return result;
187         }
188     }
189 
190     /**
191      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
192      */
193     function mulDiv(
194         uint256 x,
195         uint256 y,
196         uint256 denominator,
197         Rounding rounding
198     ) internal pure returns (uint256) {
199         uint256 result = mulDiv(x, y, denominator);
200         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
201             result += 1;
202         }
203         return result;
204     }
205 
206     /**
207      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
208      *
209      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
210      */
211     function sqrt(uint256 a) internal pure returns (uint256) {
212         if (a == 0) {
213             return 0;
214         }
215 
216         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
217         //
218         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
219         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
220         //
221         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
222         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
223         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
224         //
225         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
226         uint256 result = 1 << (log2(a) >> 1);
227 
228         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
229         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
230         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
231         // into the expected uint128 result.
232         unchecked {
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             result = (result + a / result) >> 1;
236             result = (result + a / result) >> 1;
237             result = (result + a / result) >> 1;
238             result = (result + a / result) >> 1;
239             result = (result + a / result) >> 1;
240             return min(result, a / result);
241         }
242     }
243 
244     /**
245      * @notice Calculates sqrt(a), following the selected rounding direction.
246      */
247     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
248         unchecked {
249             uint256 result = sqrt(a);
250             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
251         }
252     }
253 
254     /**
255      * @dev Return the log in base 2, rounded down, of a positive value.
256      * Returns 0 if given 0.
257      */
258     function log2(uint256 value) internal pure returns (uint256) {
259         uint256 result = 0;
260         unchecked {
261             if (value >> 128 > 0) {
262                 value >>= 128;
263                 result += 128;
264             }
265             if (value >> 64 > 0) {
266                 value >>= 64;
267                 result += 64;
268             }
269             if (value >> 32 > 0) {
270                 value >>= 32;
271                 result += 32;
272             }
273             if (value >> 16 > 0) {
274                 value >>= 16;
275                 result += 16;
276             }
277             if (value >> 8 > 0) {
278                 value >>= 8;
279                 result += 8;
280             }
281             if (value >> 4 > 0) {
282                 value >>= 4;
283                 result += 4;
284             }
285             if (value >> 2 > 0) {
286                 value >>= 2;
287                 result += 2;
288             }
289             if (value >> 1 > 0) {
290                 result += 1;
291             }
292         }
293         return result;
294     }
295 
296     /**
297      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
301         unchecked {
302             uint256 result = log2(value);
303             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
304         }
305     }
306 
307     /**
308      * @dev Return the log in base 10, rounded down, of a positive value.
309      * Returns 0 if given 0.
310      */
311     function log10(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >= 10**64) {
315                 value /= 10**64;
316                 result += 64;
317             }
318             if (value >= 10**32) {
319                 value /= 10**32;
320                 result += 32;
321             }
322             if (value >= 10**16) {
323                 value /= 10**16;
324                 result += 16;
325             }
326             if (value >= 10**8) {
327                 value /= 10**8;
328                 result += 8;
329             }
330             if (value >= 10**4) {
331                 value /= 10**4;
332                 result += 4;
333             }
334             if (value >= 10**2) {
335                 value /= 10**2;
336                 result += 2;
337             }
338             if (value >= 10**1) {
339                 result += 1;
340             }
341         }
342         return result;
343     }
344 
345     /**
346      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
347      * Returns 0 if given 0.
348      */
349     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
350         unchecked {
351             uint256 result = log10(value);
352             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
353         }
354     }
355 
356     /**
357      * @dev Return the log in base 256, rounded down, of a positive value.
358      * Returns 0 if given 0.
359      *
360      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
361      */
362     function log256(uint256 value) internal pure returns (uint256) {
363         uint256 result = 0;
364         unchecked {
365             if (value >> 128 > 0) {
366                 value >>= 128;
367                 result += 16;
368             }
369             if (value >> 64 > 0) {
370                 value >>= 64;
371                 result += 8;
372             }
373             if (value >> 32 > 0) {
374                 value >>= 32;
375                 result += 4;
376             }
377             if (value >> 16 > 0) {
378                 value >>= 16;
379                 result += 2;
380             }
381             if (value >> 8 > 0) {
382                 result += 1;
383             }
384         }
385         return result;
386     }
387 
388     /**
389      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
390      * Returns 0 if given 0.
391      */
392     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
393         unchecked {
394             uint256 result = log256(value);
395             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/Strings.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 
408 /**
409  * @dev String operations.
410  */
411 library Strings {
412     bytes16 private constant _SYMBOLS = "0123456789abcdef";
413     uint8 private constant _ADDRESS_LENGTH = 20;
414 
415     /**
416      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
417      */
418     function toString(uint256 value) internal pure returns (string memory) {
419         unchecked {
420             uint256 length = Math.log10(value) + 1;
421             string memory buffer = new string(length);
422             uint256 ptr;
423             /// @solidity memory-safe-assembly
424             assembly {
425                 ptr := add(buffer, add(32, length))
426             }
427             while (true) {
428                 ptr--;
429                 /// @solidity memory-safe-assembly
430                 assembly {
431                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
432                 }
433                 value /= 10;
434                 if (value == 0) break;
435             }
436             return buffer;
437         }
438     }
439 
440     /**
441      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
442      */
443     function toHexString(uint256 value) internal pure returns (string memory) {
444         unchecked {
445             return toHexString(value, Math.log256(value) + 1);
446         }
447     }
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
451      */
452     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
453         bytes memory buffer = new bytes(2 * length + 2);
454         buffer[0] = "0";
455         buffer[1] = "x";
456         for (uint256 i = 2 * length + 1; i > 1; --i) {
457             buffer[i] = _SYMBOLS[value & 0xf];
458             value >>= 4;
459         }
460         require(value == 0, "Strings: hex length insufficient");
461         return string(buffer);
462     }
463 
464     /**
465      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
466      */
467     function toHexString(address addr) internal pure returns (string memory) {
468         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/Context.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Provides information about the current execution context, including the
481  * sender of the transaction and its data. While these are generally available
482  * via msg.sender and msg.data, they should not be accessed in such a direct
483  * manner, since when dealing with meta-transactions the account sending and
484  * paying for execution may not be the actual sender (as far as an application
485  * is concerned).
486  *
487  * This contract is only required for intermediate, library-like contracts.
488  */
489 abstract contract Context {
490     function _msgSender() internal view virtual returns (address) {
491         return msg.sender;
492     }
493 
494     function _msgData() internal view virtual returns (bytes calldata) {
495         return msg.data;
496     }
497 }
498 
499 // File: @openzeppelin/contracts/access/Ownable.sol
500 
501 
502 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Contract module which provides a basic access control mechanism, where
509  * there is an account (an owner) that can be granted exclusive access to
510  * specific functions.
511  *
512  * By default, the owner account will be the one that deploys the contract. This
513  * can later be changed with {transferOwnership}.
514  *
515  * This module is used through inheritance. It will make available the modifier
516  * `onlyOwner`, which can be applied to your functions to restrict their use to
517  * the owner.
518  */
519 abstract contract Ownable is Context {
520     address private _owner;
521 
522     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
523 
524     /**
525      * @dev Initializes the contract setting the deployer as the initial owner.
526      */
527     constructor() {
528         _transferOwnership(_msgSender());
529     }
530 
531     /**
532      * @dev Throws if called by any account other than the owner.
533      */
534     modifier onlyOwner() {
535         _checkOwner();
536         _;
537     }
538 
539     /**
540      * @dev Returns the address of the current owner.
541      */
542     function owner() public view virtual returns (address) {
543         return _owner;
544     }
545 
546     /**
547      * @dev Throws if the sender is not the owner.
548      */
549     function _checkOwner() internal view virtual {
550         require(owner() == _msgSender(), "Ownable: caller is not the owner");
551     }
552 
553     /**
554      * @dev Leaves the contract without owner. It will not be possible to call
555      * `onlyOwner` functions anymore. Can only be called by the current owner.
556      *
557      * NOTE: Renouncing ownership will leave the contract without an owner,
558      * thereby removing any functionality that is only available to the owner.
559      */
560     function renounceOwnership() public virtual onlyOwner {
561         _transferOwnership(address(0));
562     }
563 
564     /**
565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
566      * Can only be called by the current owner.
567      */
568     function transferOwnership(address newOwner) public virtual onlyOwner {
569         require(newOwner != address(0), "Ownable: new owner is the zero address");
570         _transferOwnership(newOwner);
571     }
572 
573     /**
574      * @dev Transfers ownership of the contract to a new account (`newOwner`).
575      * Internal function without access restriction.
576      */
577     function _transferOwnership(address newOwner) internal virtual {
578         address oldOwner = _owner;
579         _owner = newOwner;
580         emit OwnershipTransferred(oldOwner, newOwner);
581     }
582 }
583 
584 // File: @openzeppelin/contracts/utils/Address.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
588 
589 pragma solidity ^0.8.1;
590 
591 /**
592  * @dev Collection of functions related to the address type
593  */
594 library Address {
595     /**
596      * @dev Returns true if `account` is a contract.
597      *
598      * [IMPORTANT]
599      * ====
600      * It is unsafe to assume that an address for which this function returns
601      * false is an externally-owned account (EOA) and not a contract.
602      *
603      * Among others, `isContract` will return false for the following
604      * types of addresses:
605      *
606      *  - an externally-owned account
607      *  - a contract in construction
608      *  - an address where a contract will be created
609      *  - an address where a contract lived, but was destroyed
610      * ====
611      *
612      * [IMPORTANT]
613      * ====
614      * You shouldn't rely on `isContract` to protect against flash loan attacks!
615      *
616      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
617      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
618      * constructor.
619      * ====
620      */
621     function isContract(address account) internal view returns (bool) {
622         // This method relies on extcodesize/address.code.length, which returns 0
623         // for contracts in construction, since the code is only stored at the end
624         // of the constructor execution.
625 
626         return account.code.length > 0;
627     }
628 
629     /**
630      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
631      * `recipient`, forwarding all available gas and reverting on errors.
632      *
633      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
634      * of certain opcodes, possibly making contracts go over the 2300 gas limit
635      * imposed by `transfer`, making them unable to receive funds via
636      * `transfer`. {sendValue} removes this limitation.
637      *
638      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
639      *
640      * IMPORTANT: because control is transferred to `recipient`, care must be
641      * taken to not create reentrancy vulnerabilities. Consider using
642      * {ReentrancyGuard} or the
643      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
644      */
645     function sendValue(address payable recipient, uint256 amount) internal {
646         require(address(this).balance >= amount, "Address: insufficient balance");
647 
648         (bool success, ) = recipient.call{value: amount}("");
649         require(success, "Address: unable to send value, recipient may have reverted");
650     }
651 
652     /**
653      * @dev Performs a Solidity function call using a low level `call`. A
654      * plain `call` is an unsafe replacement for a function call: use this
655      * function instead.
656      *
657      * If `target` reverts with a revert reason, it is bubbled up by this
658      * function (like regular Solidity function calls).
659      *
660      * Returns the raw returned data. To convert to the expected return value,
661      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
662      *
663      * Requirements:
664      *
665      * - `target` must be a contract.
666      * - calling `target` with `data` must not revert.
667      *
668      * _Available since v3.1._
669      */
670     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
671         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
676      * `errorMessage` as a fallback revert reason when `target` reverts.
677      *
678      * _Available since v3.1._
679      */
680     function functionCall(
681         address target,
682         bytes memory data,
683         string memory errorMessage
684     ) internal returns (bytes memory) {
685         return functionCallWithValue(target, data, 0, errorMessage);
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
690      * but also transferring `value` wei to `target`.
691      *
692      * Requirements:
693      *
694      * - the calling contract must have an ETH balance of at least `value`.
695      * - the called Solidity function must be `payable`.
696      *
697      * _Available since v3.1._
698      */
699     function functionCallWithValue(
700         address target,
701         bytes memory data,
702         uint256 value
703     ) internal returns (bytes memory) {
704         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
709      * with `errorMessage` as a fallback revert reason when `target` reverts.
710      *
711      * _Available since v3.1._
712      */
713     function functionCallWithValue(
714         address target,
715         bytes memory data,
716         uint256 value,
717         string memory errorMessage
718     ) internal returns (bytes memory) {
719         require(address(this).balance >= value, "Address: insufficient balance for call");
720         (bool success, bytes memory returndata) = target.call{value: value}(data);
721         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
726      * but performing a static call.
727      *
728      * _Available since v3.3._
729      */
730     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
731         return functionStaticCall(target, data, "Address: low-level static call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
736      * but performing a static call.
737      *
738      * _Available since v3.3._
739      */
740     function functionStaticCall(
741         address target,
742         bytes memory data,
743         string memory errorMessage
744     ) internal view returns (bytes memory) {
745         (bool success, bytes memory returndata) = target.staticcall(data);
746         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
751      * but performing a delegate call.
752      *
753      * _Available since v3.4._
754      */
755     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
756         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
761      * but performing a delegate call.
762      *
763      * _Available since v3.4._
764      */
765     function functionDelegateCall(
766         address target,
767         bytes memory data,
768         string memory errorMessage
769     ) internal returns (bytes memory) {
770         (bool success, bytes memory returndata) = target.delegatecall(data);
771         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
772     }
773 
774     /**
775      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
776      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
777      *
778      * _Available since v4.8._
779      */
780     function verifyCallResultFromTarget(
781         address target,
782         bool success,
783         bytes memory returndata,
784         string memory errorMessage
785     ) internal view returns (bytes memory) {
786         if (success) {
787             if (returndata.length == 0) {
788                 // only check isContract if the call was successful and the return data is empty
789                 // otherwise we already know that it was a contract
790                 require(isContract(target), "Address: call to non-contract");
791             }
792             return returndata;
793         } else {
794             _revert(returndata, errorMessage);
795         }
796     }
797 
798     /**
799      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
800      * revert reason or using the provided one.
801      *
802      * _Available since v4.3._
803      */
804     function verifyCallResult(
805         bool success,
806         bytes memory returndata,
807         string memory errorMessage
808     ) internal pure returns (bytes memory) {
809         if (success) {
810             return returndata;
811         } else {
812             _revert(returndata, errorMessage);
813         }
814     }
815 
816     function _revert(bytes memory returndata, string memory errorMessage) private pure {
817         // Look for revert reason and bubble it up if present
818         if (returndata.length > 0) {
819             // The easiest way to bubble the revert reason is using memory via assembly
820             /// @solidity memory-safe-assembly
821             assembly {
822                 let returndata_size := mload(returndata)
823                 revert(add(32, returndata), returndata_size)
824             }
825         } else {
826             revert(errorMessage);
827         }
828     }
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
832 
833 
834 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 /**
839  * @title ERC721 token receiver interface
840  * @dev Interface for any contract that wants to support safeTransfers
841  * from ERC721 asset contracts.
842  */
843 interface IERC721Receiver {
844     /**
845      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
846      * by `operator` from `from`, this function is called.
847      *
848      * It must return its Solidity selector to confirm the token transfer.
849      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
850      *
851      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
852      */
853     function onERC721Received(
854         address operator,
855         address from,
856         uint256 tokenId,
857         bytes calldata data
858     ) external returns (bytes4);
859 }
860 
861 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
862 
863 
864 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 /**
869  * @dev Interface of the ERC165 standard, as defined in the
870  * https://eips.ethereum.org/EIPS/eip-165[EIP].
871  *
872  * Implementers can declare support of contract interfaces, which can then be
873  * queried by others ({ERC165Checker}).
874  *
875  * For an implementation, see {ERC165}.
876  */
877 interface IERC165 {
878     /**
879      * @dev Returns true if this contract implements the interface defined by
880      * `interfaceId`. See the corresponding
881      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
882      * to learn more about how these ids are created.
883      *
884      * This function call must use less than 30 000 gas.
885      */
886     function supportsInterface(bytes4 interfaceId) external view returns (bool);
887 }
888 
889 // File: @openzeppelin/contracts/interfaces/IERC165.sol
890 
891 
892 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @dev Implementation of the {IERC165} interface.
907  *
908  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
909  * for the additional interface id that will be supported. For example:
910  *
911  * ```solidity
912  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
913  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
914  * }
915  * ```
916  *
917  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
918  */
919 abstract contract ERC165 is IERC165 {
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
924         return interfaceId == type(IERC165).interfaceId;
925     }
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
929 
930 
931 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @dev Required interface of an ERC721 compliant contract.
938  */
939 interface IERC721 is IERC165 {
940     /**
941      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
942      */
943     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
944 
945     /**
946      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
947      */
948     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
949 
950     /**
951      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
952      */
953     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
954 
955     /**
956      * @dev Returns the number of tokens in ``owner``'s account.
957      */
958     function balanceOf(address owner) external view returns (uint256 balance);
959 
960     /**
961      * @dev Returns the owner of the `tokenId` token.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function ownerOf(uint256 tokenId) external view returns (address owner);
968 
969     /**
970      * @dev Safely transfers `tokenId` token from `from` to `to`.
971      *
972      * Requirements:
973      *
974      * - `from` cannot be the zero address.
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must exist and be owned by `from`.
977      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes calldata data
987     ) external;
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must exist and be owned by `from`.
998      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) external;
1008 
1009     /**
1010      * @dev Transfers `tokenId` token from `from` to `to`.
1011      *
1012      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1013      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1014      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) external;
1030 
1031     /**
1032      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1033      * The approval is cleared when the token is transferred.
1034      *
1035      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1036      *
1037      * Requirements:
1038      *
1039      * - The caller must own the token or be an approved operator.
1040      * - `tokenId` must exist.
1041      *
1042      * Emits an {Approval} event.
1043      */
1044     function approve(address to, uint256 tokenId) external;
1045 
1046     /**
1047      * @dev Approve or remove `operator` as an operator for the caller.
1048      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1049      *
1050      * Requirements:
1051      *
1052      * - The `operator` cannot be the caller.
1053      *
1054      * Emits an {ApprovalForAll} event.
1055      */
1056     function setApprovalForAll(address operator, bool _approved) external;
1057 
1058     /**
1059      * @dev Returns the account approved for `tokenId` token.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      */
1065     function getApproved(uint256 tokenId) external view returns (address operator);
1066 
1067     /**
1068      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1069      *
1070      * See {setApprovalForAll}
1071      */
1072     function isApprovedForAll(address owner, address operator) external view returns (bool);
1073 }
1074 
1075 // File: @openzeppelin/contracts/interfaces/IERC721.sol
1076 
1077 
1078 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
1079 
1080 pragma solidity ^0.8.0;
1081 
1082 
1083 // File: @openzeppelin/contracts/interfaces/IERC4906.sol
1084 
1085 
1086 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC4906.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 
1091 
1092 /// @title EIP-721 Metadata Update Extension
1093 interface IERC4906 is IERC165, IERC721 {
1094     /// @dev This event emits when the metadata of a token is changed.
1095     /// So that the third-party platforms such as NFT market could
1096     /// timely update the images and related attributes of the NFT.
1097     event MetadataUpdate(uint256 _tokenId);
1098 
1099     /// @dev This event emits when the metadata of a range of tokens is changed.
1100     /// So that the third-party platforms such as NFT market could
1101     /// timely update the images and related attributes of the NFTs.
1102     event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
1103 }
1104 
1105 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1106 
1107 
1108 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1109 
1110 pragma solidity ^0.8.0;
1111 
1112 
1113 /**
1114  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1115  * @dev See https://eips.ethereum.org/EIPS/eip-721
1116  */
1117 interface IERC721Metadata is IERC721 {
1118     /**
1119      * @dev Returns the token collection name.
1120      */
1121     function name() external view returns (string memory);
1122 
1123     /**
1124      * @dev Returns the token collection symbol.
1125      */
1126     function symbol() external view returns (string memory);
1127 
1128     /**
1129      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1130      */
1131     function tokenURI(uint256 tokenId) external view returns (string memory);
1132 }
1133 
1134 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1135 
1136 
1137 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 /**
1149  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1150  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1151  * {ERC721Enumerable}.
1152  */
1153 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1154     using Address for address;
1155     using Strings for uint256;
1156 
1157     // Token name
1158     string private _name;
1159 
1160     // Token symbol
1161     string private _symbol;
1162 
1163     // Mapping from token ID to owner address
1164     mapping(uint256 => address) private _owners;
1165 
1166     // Mapping owner address to token count
1167     mapping(address => uint256) private _balances;
1168 
1169     // Mapping from token ID to approved address
1170     mapping(uint256 => address) private _tokenApprovals;
1171 
1172     // Mapping from owner to operator approvals
1173     mapping(address => mapping(address => bool)) private _operatorApprovals;
1174 
1175     /**
1176      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1177      */
1178     constructor(string memory name_, string memory symbol_) {
1179         _name = name_;
1180         _symbol = symbol_;
1181     }
1182 
1183     /**
1184      * @dev See {IERC165-supportsInterface}.
1185      */
1186     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1187         return
1188             interfaceId == type(IERC721).interfaceId ||
1189             interfaceId == type(IERC721Metadata).interfaceId ||
1190             super.supportsInterface(interfaceId);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-balanceOf}.
1195      */
1196     function balanceOf(address owner) public view virtual override returns (uint256) {
1197         require(owner != address(0), "ERC721: address zero is not a valid owner");
1198         return _balances[owner];
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-ownerOf}.
1203      */
1204     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1205         address owner = _ownerOf(tokenId);
1206         require(owner != address(0), "ERC721: invalid token ID");
1207         return owner;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Metadata-name}.
1212      */
1213     function name() public view virtual override returns (string memory) {
1214         return _name;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Metadata-symbol}.
1219      */
1220     function symbol() public view virtual override returns (string memory) {
1221         return _symbol;
1222     }
1223 
1224     /**
1225      * @dev See {IERC721Metadata-tokenURI}.
1226      */
1227     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1228         _requireMinted(tokenId);
1229 
1230         string memory baseURI = _baseURI();
1231         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1232     }
1233 
1234     /**
1235      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1236      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1237      * by default, can be overridden in child contracts.
1238      */
1239     function _baseURI() internal view virtual returns (string memory) {
1240         return "";
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-approve}.
1245      */
1246     function approve(address to, uint256 tokenId) public virtual override {
1247         address owner = ERC721.ownerOf(tokenId);
1248         require(to != owner, "ERC721: approval to current owner");
1249 
1250         require(
1251             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1252             "ERC721: approve caller is not token owner or approved for all"
1253         );
1254 
1255         _approve(to, tokenId);
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-getApproved}.
1260      */
1261     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1262         _requireMinted(tokenId);
1263 
1264         return _tokenApprovals[tokenId];
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-setApprovalForAll}.
1269      */
1270     function setApprovalForAll(address operator, bool approved) public virtual override {
1271         _setApprovalForAll(_msgSender(), operator, approved);
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-isApprovedForAll}.
1276      */
1277     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1278         return _operatorApprovals[owner][operator];
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-transferFrom}.
1283      */
1284     function transferFrom(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) public virtual override {
1289         //solhint-disable-next-line max-line-length
1290         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1291 
1292         _transfer(from, to, tokenId);
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-safeTransferFrom}.
1297      */
1298     function safeTransferFrom(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) public virtual override {
1303         safeTransferFrom(from, to, tokenId, "");
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-safeTransferFrom}.
1308      */
1309     function safeTransferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory data
1314     ) public virtual override {
1315         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1316         _safeTransfer(from, to, tokenId, data);
1317     }
1318 
1319     /**
1320      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1321      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1322      *
1323      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1324      *
1325      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1326      * implement alternative mechanisms to perform token transfer, such as signature-based.
1327      *
1328      * Requirements:
1329      *
1330      * - `from` cannot be the zero address.
1331      * - `to` cannot be the zero address.
1332      * - `tokenId` token must exist and be owned by `from`.
1333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _safeTransfer(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory data
1342     ) internal virtual {
1343         _transfer(from, to, tokenId);
1344         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1345     }
1346 
1347     /**
1348      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1349      */
1350     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1351         return _owners[tokenId];
1352     }
1353 
1354     /**
1355      * @dev Returns whether `tokenId` exists.
1356      *
1357      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1358      *
1359      * Tokens start existing when they are minted (`_mint`),
1360      * and stop existing when they are burned (`_burn`).
1361      */
1362     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1363         return _ownerOf(tokenId) != address(0);
1364     }
1365 
1366     /**
1367      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1368      *
1369      * Requirements:
1370      *
1371      * - `tokenId` must exist.
1372      */
1373     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1374         address owner = ERC721.ownerOf(tokenId);
1375         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1376     }
1377 
1378     /**
1379      * @dev Safely mints `tokenId` and transfers it to `to`.
1380      *
1381      * Requirements:
1382      *
1383      * - `tokenId` must not exist.
1384      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1385      *
1386      * Emits a {Transfer} event.
1387      */
1388     function _safeMint(address to, uint256 tokenId) internal virtual {
1389         _safeMint(to, tokenId, "");
1390     }
1391 
1392     /**
1393      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1394      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1395      */
1396     function _safeMint(
1397         address to,
1398         uint256 tokenId,
1399         bytes memory data
1400     ) internal virtual {
1401         _mint(to, tokenId);
1402         require(
1403             _checkOnERC721Received(address(0), to, tokenId, data),
1404             "ERC721: transfer to non ERC721Receiver implementer"
1405         );
1406     }
1407 
1408     /**
1409      * @dev Mints `tokenId` and transfers it to `to`.
1410      *
1411      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1412      *
1413      * Requirements:
1414      *
1415      * - `tokenId` must not exist.
1416      * - `to` cannot be the zero address.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function _mint(address to, uint256 tokenId) internal virtual {
1421         require(to != address(0), "ERC721: mint to the zero address");
1422         require(!_exists(tokenId), "ERC721: token already minted");
1423 
1424         _beforeTokenTransfer(address(0), to, tokenId, 1);
1425 
1426         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1427         require(!_exists(tokenId), "ERC721: token already minted");
1428 
1429         unchecked {
1430             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1431             // Given that tokens are minted one by one, it is impossible in practice that
1432             // this ever happens. Might change if we allow batch minting.
1433             // The ERC fails to describe this case.
1434             _balances[to] += 1;
1435         }
1436 
1437         _owners[tokenId] = to;
1438 
1439         emit Transfer(address(0), to, tokenId);
1440 
1441         _afterTokenTransfer(address(0), to, tokenId, 1);
1442     }
1443 
1444     /**
1445      * @dev Destroys `tokenId`.
1446      * The approval is cleared when the token is burned.
1447      * This is an internal function that does not check if the sender is authorized to operate on the token.
1448      *
1449      * Requirements:
1450      *
1451      * - `tokenId` must exist.
1452      *
1453      * Emits a {Transfer} event.
1454      */
1455     function _burn(uint256 tokenId) internal virtual {
1456         address owner = ERC721.ownerOf(tokenId);
1457 
1458         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1459 
1460         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1461         owner = ERC721.ownerOf(tokenId);
1462 
1463         // Clear approvals
1464         delete _tokenApprovals[tokenId];
1465 
1466         unchecked {
1467             // Cannot overflow, as that would require more tokens to be burned/transferred
1468             // out than the owner initially received through minting and transferring in.
1469             _balances[owner] -= 1;
1470         }
1471         delete _owners[tokenId];
1472 
1473         emit Transfer(owner, address(0), tokenId);
1474 
1475         _afterTokenTransfer(owner, address(0), tokenId, 1);
1476     }
1477 
1478     /**
1479      * @dev Transfers `tokenId` from `from` to `to`.
1480      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1481      *
1482      * Requirements:
1483      *
1484      * - `to` cannot be the zero address.
1485      * - `tokenId` token must be owned by `from`.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _transfer(
1490         address from,
1491         address to,
1492         uint256 tokenId
1493     ) internal virtual {
1494         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1495         require(to != address(0), "ERC721: transfer to the zero address");
1496 
1497         _beforeTokenTransfer(from, to, tokenId, 1);
1498 
1499         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1500         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1501 
1502         // Clear approvals from the previous owner
1503         delete _tokenApprovals[tokenId];
1504 
1505         unchecked {
1506             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1507             // `from`'s balance is the number of token held, which is at least one before the current
1508             // transfer.
1509             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1510             // all 2**256 token ids to be minted, which in practice is impossible.
1511             _balances[from] -= 1;
1512             _balances[to] += 1;
1513         }
1514         _owners[tokenId] = to;
1515 
1516         emit Transfer(from, to, tokenId);
1517 
1518         _afterTokenTransfer(from, to, tokenId, 1);
1519     }
1520 
1521     /**
1522      * @dev Approve `to` to operate on `tokenId`
1523      *
1524      * Emits an {Approval} event.
1525      */
1526     function _approve(address to, uint256 tokenId) internal virtual {
1527         _tokenApprovals[tokenId] = to;
1528         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1529     }
1530 
1531     /**
1532      * @dev Approve `operator` to operate on all of `owner` tokens
1533      *
1534      * Emits an {ApprovalForAll} event.
1535      */
1536     function _setApprovalForAll(
1537         address owner,
1538         address operator,
1539         bool approved
1540     ) internal virtual {
1541         require(owner != operator, "ERC721: approve to caller");
1542         _operatorApprovals[owner][operator] = approved;
1543         emit ApprovalForAll(owner, operator, approved);
1544     }
1545 
1546     /**
1547      * @dev Reverts if the `tokenId` has not been minted yet.
1548      */
1549     function _requireMinted(uint256 tokenId) internal view virtual {
1550         require(_exists(tokenId), "ERC721: invalid token ID");
1551     }
1552 
1553     /**
1554      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1555      * The call is not executed if the target address is not a contract.
1556      *
1557      * @param from address representing the previous owner of the given token ID
1558      * @param to target address that will receive the tokens
1559      * @param tokenId uint256 ID of the token to be transferred
1560      * @param data bytes optional data to send along with the call
1561      * @return bool whether the call correctly returned the expected magic value
1562      */
1563     function _checkOnERC721Received(
1564         address from,
1565         address to,
1566         uint256 tokenId,
1567         bytes memory data
1568     ) private returns (bool) {
1569         if (to.isContract()) {
1570             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1571                 return retval == IERC721Receiver.onERC721Received.selector;
1572             } catch (bytes memory reason) {
1573                 if (reason.length == 0) {
1574                     revert("ERC721: transfer to non ERC721Receiver implementer");
1575                 } else {
1576                     /// @solidity memory-safe-assembly
1577                     assembly {
1578                         revert(add(32, reason), mload(reason))
1579                     }
1580                 }
1581             }
1582         } else {
1583             return true;
1584         }
1585     }
1586 
1587     /**
1588      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1589      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1594      * - When `from` is zero, the tokens will be minted for `to`.
1595      * - When `to` is zero, ``from``'s tokens will be burned.
1596      * - `from` and `to` are never both zero.
1597      * - `batchSize` is non-zero.
1598      *
1599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1600      */
1601     function _beforeTokenTransfer(
1602         address from,
1603         address to,
1604         uint256 firstTokenId,
1605         uint256 batchSize
1606     ) internal virtual {}
1607 
1608     /**
1609      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1610      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1611      *
1612      * Calling conditions:
1613      *
1614      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1615      * - When `from` is zero, the tokens were minted for `to`.
1616      * - When `to` is zero, ``from``'s tokens were burned.
1617      * - `from` and `to` are never both zero.
1618      * - `batchSize` is non-zero.
1619      *
1620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1621      */
1622     function _afterTokenTransfer(
1623         address from,
1624         address to,
1625         uint256 firstTokenId,
1626         uint256 batchSize
1627     ) internal virtual {}
1628 
1629     /**
1630      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1631      *
1632      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1633      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1634      * that `ownerOf(tokenId)` is `a`.
1635      */
1636     // solhint-disable-next-line func-name-mixedcase
1637     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1638         _balances[account] += amount;
1639     }
1640 }
1641 
1642 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1643 
1644 
1645 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1646 
1647 pragma solidity ^0.8.0;
1648 
1649 
1650 
1651 /**
1652  * @dev ERC721 token with storage based token URI management.
1653  */
1654 abstract contract ERC721URIStorage is IERC4906, ERC721 {
1655     using Strings for uint256;
1656 
1657     // Optional mapping for token URIs
1658     mapping(uint256 => string) private _tokenURIs;
1659 
1660     /**
1661      * @dev See {IERC165-supportsInterface}
1662      */
1663     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
1664         return interfaceId == bytes4(0x49064906) || super.supportsInterface(interfaceId);
1665     }
1666 
1667     /**
1668      * @dev See {IERC721Metadata-tokenURI}.
1669      */
1670     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1671         _requireMinted(tokenId);
1672 
1673         string memory _tokenURI = _tokenURIs[tokenId];
1674         string memory base = _baseURI();
1675 
1676         // If there is no base URI, return the token URI.
1677         if (bytes(base).length == 0) {
1678             return _tokenURI;
1679         }
1680         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1681         if (bytes(_tokenURI).length > 0) {
1682             return string(abi.encodePacked(base, _tokenURI));
1683         }
1684 
1685         return super.tokenURI(tokenId);
1686     }
1687 
1688     /**
1689      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1690      *
1691      * Emits {MetadataUpdate}.
1692      *
1693      * Requirements:
1694      *
1695      * - `tokenId` must exist.
1696      */
1697     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1698         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1699         _tokenURIs[tokenId] = _tokenURI;
1700 
1701         emit MetadataUpdate(tokenId);
1702     }
1703 
1704     /**
1705      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1706      * token-specific URI was set for the token, and if so, it deletes the token URI from
1707      * the storage mapping.
1708      */
1709     function _burn(uint256 tokenId) internal virtual override {
1710         super._burn(tokenId);
1711 
1712         if (bytes(_tokenURIs[tokenId]).length != 0) {
1713             delete _tokenURIs[tokenId];
1714         }
1715     }
1716 }
1717 
1718 // File: Immtest.sol
1719 
1720 
1721 pragma solidity ^0.8.0;
1722 
1723 
1724 
1725 
1726 
1727 contract ImmortalsNFT is ERC721URIStorage, Ownable {
1728     using Counters for Counters.Counter;
1729     Counters.Counter private _tokenIds;
1730 
1731     // NFT Info
1732     string public baseURI;
1733     uint256 public mintPrice = 79000000000000000;
1734     uint256 public maxSupply;
1735     uint256 public whitelistMintLimit;
1736     uint256 public totalMinted;
1737     // Allocation of Mint Funds
1738     address payable private team1;
1739     address payable private team2;
1740     address payable private team3;
1741     address payable private team4;
1742 
1743     // Phases of Mints
1744     bool public whitelistMintLive;
1745     bool public publicMintLive;
1746 
1747     // Tracking whether someone is Whitelisted/Staked/Presale Claimable.
1748     mapping(address => bool) public whitelist;
1749     mapping(address => uint256) internal mintedAmount;
1750    
1751 
1752     constructor(
1753         string memory uri_,
1754         address team1_,
1755         address team2_,
1756         address team3_,
1757         address team4_,
1758         uint256 _maxSupply,
1759         uint256 _whitelistMintLimit
1760     ) ERC721("The Immortals", "X_X") {
1761         baseURI = uri_;
1762         team1 = payable(team1_);
1763         team2 = payable(team2_);
1764         team3 = payable(team3_);
1765         team4 = payable(team4_);
1766         maxSupply = _maxSupply;
1767         whitelistMintLimit = _whitelistMintLimit;
1768         
1769     }
1770 
1771     // Current Minted Amount of NFTS
1772     function totalSupply() public view returns (uint256) {
1773         return _tokenIds.current();
1774     }
1775 
1776     
1777     
1778     
1779     // Function of the team to mint at the start
1780     function ownerMint(uint256 numberOfTokens) external onlyOwner {
1781     require(numberOfTokens > 0, "Invalid number of tokens");
1782     require(totalSupply() + numberOfTokens <= maxSupply, "Maximum supply reached");
1783 
1784     for (uint256 i = 0; i < numberOfTokens; ++i) {
1785         mint(msg.sender);
1786     }
1787 }
1788 
1789 
1790     // Enabling whitelist minting
1791     function enableWhitelistMint() public onlyOwner {
1792         whitelistMintLive = true;
1793     }
1794 
1795     // Enabling public minting
1796     function enablePublicMint() public onlyOwner {
1797         publicMintLive = true;
1798     }
1799 
1800     // Uploading whitelist users and claimable amounts
1801     function addToWhitelist(address[] calldata users) external onlyOwner {
1802     
1803 
1804     for (uint256 i = 0; i < users.length; ++i) {
1805         address user = users[i];
1806         require(user != address(0), "Invalid user address");
1807         whitelist[user] = true;
1808         
1809     }
1810 }
1811     
1812     
1813 
1814 // Whitelist mint function
1815 function whitelistMint() external payable {
1816     require(whitelistMintLive, "Whitelist minting is not available");
1817     require(whitelist[msg.sender], "Whitelist minting is not available for the sender");
1818     require(msg.value >= mintPrice, "Insufficient payment");
1819     require(totalMinted + 1 <= whitelistMintLimit, "Minting limit reached");
1820 
1821     whitelist[msg.sender] = false;
1822     mint(msg.sender);
1823     totalMinted++;
1824 }
1825 
1826 // Public mint function
1827 function publicMint() external payable {
1828     require(publicMintLive, "Public minting is not available");
1829     require(msg.value >= mintPrice, "Insufficient payment");
1830     require(totalMinted + 1 <= whitelistMintLimit, "Minting limit reached");
1831 
1832     mint(msg.sender);
1833     totalMinted++;
1834 }
1835 
1836     // Mint function
1837     function mint(address recipient) internal {
1838         require(totalSupply() < maxSupply, "Maximum supply reached");
1839 
1840         _tokenIds.increment();
1841         uint256 newItemId = _tokenIds.current();
1842         _mint(recipient, newItemId);
1843         mintedAmount[recipient] += 1;
1844 
1845         string memory tokenURI = string(abi.encodePacked(baseURI, Strings.toString(newItemId), ".json"));
1846         _setTokenURI(newItemId, tokenURI);
1847     }
1848 
1849     // Airdrop tokens to multiple addresses
1850     function airdrop(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
1851         require(recipients.length == amounts.length, "Arrays length mismatch");
1852 
1853         for (uint256 i = 0; i < recipients.length; ++i) {
1854             address recipient = recipients[i];
1855             uint256 amount = amounts[i];
1856             require(amount > 0 && amount <= 2, "Invalid amount");
1857 
1858             for (uint256 j = 0; j < amount; ++j) {
1859             mint(recipient);
1860         }
1861     }
1862 }
1863  
1864 
1865     // Withdraw funds from the contract
1866     function withdraw() public onlyOwner {
1867         uint256 totalBalance = address(this).balance;
1868         require(totalBalance > 0, "No funds to withdraw");
1869 
1870                                             //percentages
1871         uint256 team1Share = (totalBalance * 64) / 100;
1872         uint256 team2Share = (totalBalance * 20) / 100;
1873         uint256 team3Share = (totalBalance * 10) / 100;
1874         uint256 team4Share =(totalBalance * 6) / 100;
1875 
1876         team1.transfer(team1Share);
1877         team2.transfer(team2Share);
1878         team3.transfer(team3Share);
1879         team4.transfer(team4Share);
1880     }
1881 }