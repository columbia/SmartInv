1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/math/Math.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Standard math utilities missing in the Solidity language.
58  */
59 library Math {
60     enum Rounding {
61         Down, // Toward negative infinity
62         Up, // Toward infinity
63         Zero // Toward zero
64     }
65 
66     /**
67      * @dev Returns the largest of two numbers.
68      */
69     function max(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a > b ? a : b;
71     }
72 
73     /**
74      * @dev Returns the smallest of two numbers.
75      */
76     function min(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a < b ? a : b;
78     }
79 
80     /**
81      * @dev Returns the average of two numbers. The result is rounded towards
82      * zero.
83      */
84     function average(uint256 a, uint256 b) internal pure returns (uint256) {
85         // (a + b) / 2 can overflow.
86         return (a & b) + (a ^ b) / 2;
87     }
88 
89     /**
90      * @dev Returns the ceiling of the division of two numbers.
91      *
92      * This differs from standard division with `/` in that it rounds up instead
93      * of rounding down.
94      */
95     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
96         // (a + b - 1) / b can overflow on addition, so we distribute.
97         return a == 0 ? 0 : (a - 1) / b + 1;
98     }
99 
100     /**
101      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
102      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
103      * with further edits by Uniswap Labs also under MIT license.
104      */
105     function mulDiv(
106         uint256 x,
107         uint256 y,
108         uint256 denominator
109     ) internal pure returns (uint256 result) {
110         unchecked {
111             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
112             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
113             // variables such that product = prod1 * 2^256 + prod0.
114             uint256 prod0; // Least significant 256 bits of the product
115             uint256 prod1; // Most significant 256 bits of the product
116             assembly {
117                 let mm := mulmod(x, y, not(0))
118                 prod0 := mul(x, y)
119                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
120             }
121 
122             // Handle non-overflow cases, 256 by 256 division.
123             if (prod1 == 0) {
124                 return prod0 / denominator;
125             }
126 
127             // Make sure the result is less than 2^256. Also prevents denominator == 0.
128             require(denominator > prod1);
129 
130             ///////////////////////////////////////////////
131             // 512 by 256 division.
132             ///////////////////////////////////////////////
133 
134             // Make division exact by subtracting the remainder from [prod1 prod0].
135             uint256 remainder;
136             assembly {
137                 // Compute remainder using mulmod.
138                 remainder := mulmod(x, y, denominator)
139 
140                 // Subtract 256 bit number from 512 bit number.
141                 prod1 := sub(prod1, gt(remainder, prod0))
142                 prod0 := sub(prod0, remainder)
143             }
144 
145             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
146             // See https://cs.stackexchange.com/q/138556/92363.
147 
148             // Does not overflow because the denominator cannot be zero at this stage in the function.
149             uint256 twos = denominator & (~denominator + 1);
150             assembly {
151                 // Divide denominator by twos.
152                 denominator := div(denominator, twos)
153 
154                 // Divide [prod1 prod0] by twos.
155                 prod0 := div(prod0, twos)
156 
157                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
158                 twos := add(div(sub(0, twos), twos), 1)
159             }
160 
161             // Shift in bits from prod1 into prod0.
162             prod0 |= prod1 * twos;
163 
164             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
165             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
166             // four bits. That is, denominator * inv = 1 mod 2^4.
167             uint256 inverse = (3 * denominator) ^ 2;
168 
169             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
170             // in modular arithmetic, doubling the correct bits in each step.
171             inverse *= 2 - denominator * inverse; // inverse mod 2^8
172             inverse *= 2 - denominator * inverse; // inverse mod 2^16
173             inverse *= 2 - denominator * inverse; // inverse mod 2^32
174             inverse *= 2 - denominator * inverse; // inverse mod 2^64
175             inverse *= 2 - denominator * inverse; // inverse mod 2^128
176             inverse *= 2 - denominator * inverse; // inverse mod 2^256
177 
178             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
179             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
180             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
181             // is no longer required.
182             result = prod0 * inverse;
183             return result;
184         }
185     }
186 
187     /**
188      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
189      */
190     function mulDiv(
191         uint256 x,
192         uint256 y,
193         uint256 denominator,
194         Rounding rounding
195     ) internal pure returns (uint256) {
196         uint256 result = mulDiv(x, y, denominator);
197         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
198             result += 1;
199         }
200         return result;
201     }
202 
203     /**
204      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
205      *
206      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
207      */
208     function sqrt(uint256 a) internal pure returns (uint256) {
209         if (a == 0) {
210             return 0;
211         }
212 
213         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
214         //
215         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
216         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
217         //
218         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
219         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
220         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
221         //
222         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
223         uint256 result = 1 << (log2(a) >> 1);
224 
225         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
226         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
227         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
228         // into the expected uint128 result.
229         unchecked {
230             result = (result + a / result) >> 1;
231             result = (result + a / result) >> 1;
232             result = (result + a / result) >> 1;
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             result = (result + a / result) >> 1;
236             result = (result + a / result) >> 1;
237             return min(result, a / result);
238         }
239     }
240 
241     /**
242      * @notice Calculates sqrt(a), following the selected rounding direction.
243      */
244     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
245         unchecked {
246             uint256 result = sqrt(a);
247             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
248         }
249     }
250 
251     /**
252      * @dev Return the log in base 2, rounded down, of a positive value.
253      * Returns 0 if given 0.
254      */
255     function log2(uint256 value) internal pure returns (uint256) {
256         uint256 result = 0;
257         unchecked {
258             if (value >> 128 > 0) {
259                 value >>= 128;
260                 result += 128;
261             }
262             if (value >> 64 > 0) {
263                 value >>= 64;
264                 result += 64;
265             }
266             if (value >> 32 > 0) {
267                 value >>= 32;
268                 result += 32;
269             }
270             if (value >> 16 > 0) {
271                 value >>= 16;
272                 result += 16;
273             }
274             if (value >> 8 > 0) {
275                 value >>= 8;
276                 result += 8;
277             }
278             if (value >> 4 > 0) {
279                 value >>= 4;
280                 result += 4;
281             }
282             if (value >> 2 > 0) {
283                 value >>= 2;
284                 result += 2;
285             }
286             if (value >> 1 > 0) {
287                 result += 1;
288             }
289         }
290         return result;
291     }
292 
293     /**
294      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
298         unchecked {
299             uint256 result = log2(value);
300             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
301         }
302     }
303 
304     /**
305      * @dev Return the log in base 10, rounded down, of a positive value.
306      * Returns 0 if given 0.
307      */
308     function log10(uint256 value) internal pure returns (uint256) {
309         uint256 result = 0;
310         unchecked {
311             if (value >= 10**64) {
312                 value /= 10**64;
313                 result += 64;
314             }
315             if (value >= 10**32) {
316                 value /= 10**32;
317                 result += 32;
318             }
319             if (value >= 10**16) {
320                 value /= 10**16;
321                 result += 16;
322             }
323             if (value >= 10**8) {
324                 value /= 10**8;
325                 result += 8;
326             }
327             if (value >= 10**4) {
328                 value /= 10**4;
329                 result += 4;
330             }
331             if (value >= 10**2) {
332                 value /= 10**2;
333                 result += 2;
334             }
335             if (value >= 10**1) {
336                 result += 1;
337             }
338         }
339         return result;
340     }
341 
342     /**
343      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
344      * Returns 0 if given 0.
345      */
346     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
347         unchecked {
348             uint256 result = log10(value);
349             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
350         }
351     }
352 
353     /**
354      * @dev Return the log in base 256, rounded down, of a positive value.
355      * Returns 0 if given 0.
356      *
357      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
358      */
359     function log256(uint256 value) internal pure returns (uint256) {
360         uint256 result = 0;
361         unchecked {
362             if (value >> 128 > 0) {
363                 value >>= 128;
364                 result += 16;
365             }
366             if (value >> 64 > 0) {
367                 value >>= 64;
368                 result += 8;
369             }
370             if (value >> 32 > 0) {
371                 value >>= 32;
372                 result += 4;
373             }
374             if (value >> 16 > 0) {
375                 value >>= 16;
376                 result += 2;
377             }
378             if (value >> 8 > 0) {
379                 result += 1;
380             }
381         }
382         return result;
383     }
384 
385     /**
386      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
387      * Returns 0 if given 0.
388      */
389     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
390         unchecked {
391             uint256 result = log256(value);
392             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/utils/Strings.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev String operations.
407  */
408 library Strings {
409     bytes16 private constant _SYMBOLS = "0123456789abcdef";
410     uint8 private constant _ADDRESS_LENGTH = 20;
411 
412     /**
413      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
414      */
415     function toString(uint256 value) internal pure returns (string memory) {
416         unchecked {
417             uint256 length = Math.log10(value) + 1;
418             string memory buffer = new string(length);
419             uint256 ptr;
420             /// @solidity memory-safe-assembly
421             assembly {
422                 ptr := add(buffer, add(32, length))
423             }
424             while (true) {
425                 ptr--;
426                 /// @solidity memory-safe-assembly
427                 assembly {
428                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
429                 }
430                 value /= 10;
431                 if (value == 0) break;
432             }
433             return buffer;
434         }
435     }
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
439      */
440     function toHexString(uint256 value) internal pure returns (string memory) {
441         unchecked {
442             return toHexString(value, Math.log256(value) + 1);
443         }
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
448      */
449     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
450         bytes memory buffer = new bytes(2 * length + 2);
451         buffer[0] = "0";
452         buffer[1] = "x";
453         for (uint256 i = 2 * length + 1; i > 1; --i) {
454             buffer[i] = _SYMBOLS[value & 0xf];
455             value >>= 4;
456         }
457         require(value == 0, "Strings: hex length insufficient");
458         return string(buffer);
459     }
460 
461     /**
462      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
463      */
464     function toHexString(address addr) internal pure returns (string memory) {
465         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/Context.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 /**
477  * @dev Provides information about the current execution context, including the
478  * sender of the transaction and its data. While these are generally available
479  * via msg.sender and msg.data, they should not be accessed in such a direct
480  * manner, since when dealing with meta-transactions the account sending and
481  * paying for execution may not be the actual sender (as far as an application
482  * is concerned).
483  *
484  * This contract is only required for intermediate, library-like contracts.
485  */
486 abstract contract Context {
487     function _msgSender() internal view virtual returns (address) {
488         return msg.sender;
489     }
490 
491     function _msgData() internal view virtual returns (bytes calldata) {
492         return msg.data;
493     }
494 }
495 
496 // File: @openzeppelin/contracts/access/Ownable.sol
497 
498 
499 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 
504 /**
505  * @dev Contract module which provides a basic access control mechanism, where
506  * there is an account (an owner) that can be granted exclusive access to
507  * specific functions.
508  *
509  * By default, the owner account will be the one that deploys the contract. This
510  * can later be changed with {transferOwnership}.
511  *
512  * This module is used through inheritance. It will make available the modifier
513  * `onlyOwner`, which can be applied to your functions to restrict their use to
514  * the owner.
515  */
516 abstract contract Ownable is Context {
517     address private _owner;
518 
519     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
520 
521     /**
522      * @dev Initializes the contract setting the deployer as the initial owner.
523      */
524     constructor() {
525         _transferOwnership(_msgSender());
526     }
527 
528     /**
529      * @dev Throws if called by any account other than the owner.
530      */
531     modifier onlyOwner() {
532         _checkOwner();
533         _;
534     }
535 
536     /**
537      * @dev Returns the address of the current owner.
538      */
539     function owner() public view virtual returns (address) {
540         return _owner;
541     }
542 
543     /**
544      * @dev Throws if the sender is not the owner.
545      */
546     function _checkOwner() internal view virtual {
547         require(owner() == _msgSender(), "Ownable: caller is not the owner");
548     }
549 
550     /**
551      * @dev Leaves the contract without owner. It will not be possible to call
552      * `onlyOwner` functions anymore. Can only be called by the current owner.
553      *
554      * NOTE: Renouncing ownership will leave the contract without an owner,
555      * thereby removing any functionality that is only available to the owner.
556      */
557     function renounceOwnership() public virtual onlyOwner {
558         _transferOwnership(address(0));
559     }
560 
561     /**
562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
563      * Can only be called by the current owner.
564      */
565     function transferOwnership(address newOwner) public virtual onlyOwner {
566         require(newOwner != address(0), "Ownable: new owner is the zero address");
567         _transferOwnership(newOwner);
568     }
569 
570     /**
571      * @dev Transfers ownership of the contract to a new account (`newOwner`).
572      * Internal function without access restriction.
573      */
574     function _transferOwnership(address newOwner) internal virtual {
575         address oldOwner = _owner;
576         _owner = newOwner;
577         emit OwnershipTransferred(oldOwner, newOwner);
578     }
579 }
580 
581 // File: @openzeppelin/contracts/utils/Address.sol
582 
583 
584 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
585 
586 pragma solidity ^0.8.1;
587 
588 /**
589  * @dev Collection of functions related to the address type
590  */
591 library Address {
592     /**
593      * @dev Returns true if `account` is a contract.
594      *
595      * [IMPORTANT]
596      * ====
597      * It is unsafe to assume that an address for which this function returns
598      * false is an externally-owned account (EOA) and not a contract.
599      *
600      * Among others, `isContract` will return false for the following
601      * types of addresses:
602      *
603      *  - an externally-owned account
604      *  - a contract in construction
605      *  - an address where a contract will be created
606      *  - an address where a contract lived, but was destroyed
607      * ====
608      *
609      * [IMPORTANT]
610      * ====
611      * You shouldn't rely on `isContract` to protect against flash loan attacks!
612      *
613      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
614      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
615      * constructor.
616      * ====
617      */
618     function isContract(address account) internal view returns (bool) {
619         // This method relies on extcodesize/address.code.length, which returns 0
620         // for contracts in construction, since the code is only stored at the end
621         // of the constructor execution.
622 
623         return account.code.length > 0;
624     }
625 
626     /**
627      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
628      * `recipient`, forwarding all available gas and reverting on errors.
629      *
630      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
631      * of certain opcodes, possibly making contracts go over the 2300 gas limit
632      * imposed by `transfer`, making them unable to receive funds via
633      * `transfer`. {sendValue} removes this limitation.
634      *
635      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
636      *
637      * IMPORTANT: because control is transferred to `recipient`, care must be
638      * taken to not create reentrancy vulnerabilities. Consider using
639      * {ReentrancyGuard} or the
640      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
641      */
642     function sendValue(address payable recipient, uint256 amount) internal {
643         require(address(this).balance >= amount, "Address: insufficient balance");
644 
645         (bool success, ) = recipient.call{value: amount}("");
646         require(success, "Address: unable to send value, recipient may have reverted");
647     }
648 
649     /**
650      * @dev Performs a Solidity function call using a low level `call`. A
651      * plain `call` is an unsafe replacement for a function call: use this
652      * function instead.
653      *
654      * If `target` reverts with a revert reason, it is bubbled up by this
655      * function (like regular Solidity function calls).
656      *
657      * Returns the raw returned data. To convert to the expected return value,
658      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
659      *
660      * Requirements:
661      *
662      * - `target` must be a contract.
663      * - calling `target` with `data` must not revert.
664      *
665      * _Available since v3.1._
666      */
667     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
668         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
673      * `errorMessage` as a fallback revert reason when `target` reverts.
674      *
675      * _Available since v3.1._
676      */
677     function functionCall(
678         address target,
679         bytes memory data,
680         string memory errorMessage
681     ) internal returns (bytes memory) {
682         return functionCallWithValue(target, data, 0, errorMessage);
683     }
684 
685     /**
686      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
687      * but also transferring `value` wei to `target`.
688      *
689      * Requirements:
690      *
691      * - the calling contract must have an ETH balance of at least `value`.
692      * - the called Solidity function must be `payable`.
693      *
694      * _Available since v3.1._
695      */
696     function functionCallWithValue(
697         address target,
698         bytes memory data,
699         uint256 value
700     ) internal returns (bytes memory) {
701         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
706      * with `errorMessage` as a fallback revert reason when `target` reverts.
707      *
708      * _Available since v3.1._
709      */
710     function functionCallWithValue(
711         address target,
712         bytes memory data,
713         uint256 value,
714         string memory errorMessage
715     ) internal returns (bytes memory) {
716         require(address(this).balance >= value, "Address: insufficient balance for call");
717         (bool success, bytes memory returndata) = target.call{value: value}(data);
718         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
723      * but performing a static call.
724      *
725      * _Available since v3.3._
726      */
727     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
728         return functionStaticCall(target, data, "Address: low-level static call failed");
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
733      * but performing a static call.
734      *
735      * _Available since v3.3._
736      */
737     function functionStaticCall(
738         address target,
739         bytes memory data,
740         string memory errorMessage
741     ) internal view returns (bytes memory) {
742         (bool success, bytes memory returndata) = target.staticcall(data);
743         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
748      * but performing a delegate call.
749      *
750      * _Available since v3.4._
751      */
752     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
753         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
758      * but performing a delegate call.
759      *
760      * _Available since v3.4._
761      */
762     function functionDelegateCall(
763         address target,
764         bytes memory data,
765         string memory errorMessage
766     ) internal returns (bytes memory) {
767         (bool success, bytes memory returndata) = target.delegatecall(data);
768         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
769     }
770 
771     /**
772      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
773      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
774      *
775      * _Available since v4.8._
776      */
777     function verifyCallResultFromTarget(
778         address target,
779         bool success,
780         bytes memory returndata,
781         string memory errorMessage
782     ) internal view returns (bytes memory) {
783         if (success) {
784             if (returndata.length == 0) {
785                 // only check isContract if the call was successful and the return data is empty
786                 // otherwise we already know that it was a contract
787                 require(isContract(target), "Address: call to non-contract");
788             }
789             return returndata;
790         } else {
791             _revert(returndata, errorMessage);
792         }
793     }
794 
795     /**
796      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
797      * revert reason or using the provided one.
798      *
799      * _Available since v4.3._
800      */
801     function verifyCallResult(
802         bool success,
803         bytes memory returndata,
804         string memory errorMessage
805     ) internal pure returns (bytes memory) {
806         if (success) {
807             return returndata;
808         } else {
809             _revert(returndata, errorMessage);
810         }
811     }
812 
813     function _revert(bytes memory returndata, string memory errorMessage) private pure {
814         // Look for revert reason and bubble it up if present
815         if (returndata.length > 0) {
816             // The easiest way to bubble the revert reason is using memory via assembly
817             /// @solidity memory-safe-assembly
818             assembly {
819                 let returndata_size := mload(returndata)
820                 revert(add(32, returndata), returndata_size)
821             }
822         } else {
823             revert(errorMessage);
824         }
825     }
826 }
827 
828 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 /**
836  * @title ERC721 token receiver interface
837  * @dev Interface for any contract that wants to support safeTransfers
838  * from ERC721 asset contracts.
839  */
840 interface IERC721Receiver {
841     /**
842      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
843      * by `operator` from `from`, this function is called.
844      *
845      * It must return its Solidity selector to confirm the token transfer.
846      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
847      *
848      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
849      */
850     function onERC721Received(
851         address operator,
852         address from,
853         uint256 tokenId,
854         bytes calldata data
855     ) external returns (bytes4);
856 }
857 
858 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
859 
860 
861 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866  * @dev Interface of the ERC165 standard, as defined in the
867  * https://eips.ethereum.org/EIPS/eip-165[EIP].
868  *
869  * Implementers can declare support of contract interfaces, which can then be
870  * queried by others ({ERC165Checker}).
871  *
872  * For an implementation, see {ERC165}.
873  */
874 interface IERC165 {
875     /**
876      * @dev Returns true if this contract implements the interface defined by
877      * `interfaceId`. See the corresponding
878      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
879      * to learn more about how these ids are created.
880      *
881      * This function call must use less than 30 000 gas.
882      */
883     function supportsInterface(bytes4 interfaceId) external view returns (bool);
884 }
885 
886 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 
894 /**
895  * @dev Implementation of the {IERC165} interface.
896  *
897  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
898  * for the additional interface id that will be supported. For example:
899  *
900  * ```solidity
901  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
902  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
903  * }
904  * ```
905  *
906  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
907  */
908 abstract contract ERC165 is IERC165 {
909     /**
910      * @dev See {IERC165-supportsInterface}.
911      */
912     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
913         return interfaceId == type(IERC165).interfaceId;
914     }
915 }
916 
917 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
918 
919 
920 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
921 
922 pragma solidity ^0.8.0;
923 
924 
925 /**
926  * @dev Required interface of an ERC721 compliant contract.
927  */
928 interface IERC721 is IERC165 {
929     /**
930      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
931      */
932     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
933 
934     /**
935      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
936      */
937     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
938 
939     /**
940      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
941      */
942     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
943 
944     /**
945      * @dev Returns the number of tokens in ``owner``'s account.
946      */
947     function balanceOf(address owner) external view returns (uint256 balance);
948 
949     /**
950      * @dev Returns the owner of the `tokenId` token.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function ownerOf(uint256 tokenId) external view returns (address owner);
957 
958     /**
959      * @dev Safely transfers `tokenId` token from `from` to `to`.
960      *
961      * Requirements:
962      *
963      * - `from` cannot be the zero address.
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must exist and be owned by `from`.
966      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
967      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
968      *
969      * Emits a {Transfer} event.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes calldata data
976     ) external;
977 
978     /**
979      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
980      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId
996     ) external;
997 
998     /**
999      * @dev Transfers `tokenId` token from `from` to `to`.
1000      *
1001      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1002      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1003      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must be owned by `from`.
1010      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) external;
1019 
1020     /**
1021      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1022      * The approval is cleared when the token is transferred.
1023      *
1024      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1025      *
1026      * Requirements:
1027      *
1028      * - The caller must own the token or be an approved operator.
1029      * - `tokenId` must exist.
1030      *
1031      * Emits an {Approval} event.
1032      */
1033     function approve(address to, uint256 tokenId) external;
1034 
1035     /**
1036      * @dev Approve or remove `operator` as an operator for the caller.
1037      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1038      *
1039      * Requirements:
1040      *
1041      * - The `operator` cannot be the caller.
1042      *
1043      * Emits an {ApprovalForAll} event.
1044      */
1045     function setApprovalForAll(address operator, bool _approved) external;
1046 
1047     /**
1048      * @dev Returns the account approved for `tokenId` token.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      */
1054     function getApproved(uint256 tokenId) external view returns (address operator);
1055 
1056     /**
1057      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1058      *
1059      * See {setApprovalForAll}
1060      */
1061     function isApprovedForAll(address owner, address operator) external view returns (bool);
1062 }
1063 
1064 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1065 
1066 
1067 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 
1072 /**
1073  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1074  * @dev See https://eips.ethereum.org/EIPS/eip-721
1075  */
1076 interface IERC721Metadata is IERC721 {
1077     /**
1078      * @dev Returns the token collection name.
1079      */
1080     function name() external view returns (string memory);
1081 
1082     /**
1083      * @dev Returns the token collection symbol.
1084      */
1085     function symbol() external view returns (string memory);
1086 
1087     /**
1088      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1089      */
1090     function tokenURI(uint256 tokenId) external view returns (string memory);
1091 }
1092 
1093 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1094 
1095 
1096 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 
1107 /**
1108  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1109  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1110  * {ERC721Enumerable}.
1111  */
1112 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1113     using Address for address;
1114     using Strings for uint256;
1115 
1116     // Token name
1117     string private _name;
1118 
1119     // Token symbol
1120     string private _symbol;
1121 
1122     // Mapping from token ID to owner address
1123     mapping(uint256 => address) private _owners;
1124 
1125     // Mapping owner address to token count
1126     mapping(address => uint256) private _balances;
1127 
1128     // Mapping from token ID to approved address
1129     mapping(uint256 => address) private _tokenApprovals;
1130 
1131     // Mapping from owner to operator approvals
1132     mapping(address => mapping(address => bool)) private _operatorApprovals;
1133 
1134     /**
1135      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1136      */
1137     constructor(string memory name_, string memory symbol_) {
1138         _name = name_;
1139         _symbol = symbol_;
1140     }
1141 
1142     /**
1143      * @dev See {IERC165-supportsInterface}.
1144      */
1145     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1146         return
1147             interfaceId == type(IERC721).interfaceId ||
1148             interfaceId == type(IERC721Metadata).interfaceId ||
1149             super.supportsInterface(interfaceId);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-balanceOf}.
1154      */
1155     function balanceOf(address owner) public view virtual override returns (uint256) {
1156         require(owner != address(0), "ERC721: address zero is not a valid owner");
1157         return _balances[owner];
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-ownerOf}.
1162      */
1163     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1164         address owner = _ownerOf(tokenId);
1165         require(owner != address(0), "ERC721: invalid token ID");
1166         return owner;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Metadata-name}.
1171      */
1172     function name() public view virtual override returns (string memory) {
1173         return _name;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Metadata-symbol}.
1178      */
1179     function symbol() public view virtual override returns (string memory) {
1180         return _symbol;
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Metadata-tokenURI}.
1185      */
1186     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1187         _requireMinted(tokenId);
1188 
1189         string memory baseURI = _baseURI();
1190         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1191     }
1192 
1193     /**
1194      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1195      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1196      * by default, can be overridden in child contracts.
1197      */
1198     function _baseURI() internal view virtual returns (string memory) {
1199         return "";
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-approve}.
1204      */
1205     function approve(address to, uint256 tokenId) public virtual override {
1206         address owner = ERC721.ownerOf(tokenId);
1207         require(to != owner, "ERC721: approval to current owner");
1208 
1209         require(
1210             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1211             "ERC721: approve caller is not token owner or approved for all"
1212         );
1213 
1214         _approve(to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-getApproved}.
1219      */
1220     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1221         _requireMinted(tokenId);
1222 
1223         return _tokenApprovals[tokenId];
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-setApprovalForAll}.
1228      */
1229     function setApprovalForAll(address operator, bool approved) public virtual override {
1230         _setApprovalForAll(_msgSender(), operator, approved);
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-isApprovedForAll}.
1235      */
1236     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1237         return _operatorApprovals[owner][operator];
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-transferFrom}.
1242      */
1243     function transferFrom(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) public virtual override {
1248         //solhint-disable-next-line max-line-length
1249         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1250 
1251         _transfer(from, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev See {IERC721-safeTransferFrom}.
1256      */
1257     function safeTransferFrom(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) public virtual override {
1262         safeTransferFrom(from, to, tokenId, "");
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-safeTransferFrom}.
1267      */
1268     function safeTransferFrom(
1269         address from,
1270         address to,
1271         uint256 tokenId,
1272         bytes memory data
1273     ) public virtual override {
1274         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1275         _safeTransfer(from, to, tokenId, data);
1276     }
1277 
1278     /**
1279      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1280      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1281      *
1282      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1283      *
1284      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1285      * implement alternative mechanisms to perform token transfer, such as signature-based.
1286      *
1287      * Requirements:
1288      *
1289      * - `from` cannot be the zero address.
1290      * - `to` cannot be the zero address.
1291      * - `tokenId` token must exist and be owned by `from`.
1292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function _safeTransfer(
1297         address from,
1298         address to,
1299         uint256 tokenId,
1300         bytes memory data
1301     ) internal virtual {
1302         _transfer(from, to, tokenId);
1303         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1304     }
1305 
1306     /**
1307      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1308      */
1309     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1310         return _owners[tokenId];
1311     }
1312 
1313     /**
1314      * @dev Returns whether `tokenId` exists.
1315      *
1316      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1317      *
1318      * Tokens start existing when they are minted (`_mint`),
1319      * and stop existing when they are burned (`_burn`).
1320      */
1321     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1322         return _ownerOf(tokenId) != address(0);
1323     }
1324 
1325     /**
1326      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1327      *
1328      * Requirements:
1329      *
1330      * - `tokenId` must exist.
1331      */
1332     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1333         address owner = ERC721.ownerOf(tokenId);
1334         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1335     }
1336 
1337     /**
1338      * @dev Safely mints `tokenId` and transfers it to `to`.
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must not exist.
1343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _safeMint(address to, uint256 tokenId) internal virtual {
1348         _safeMint(to, tokenId, "");
1349     }
1350 
1351     /**
1352      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1353      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1354      */
1355     function _safeMint(
1356         address to,
1357         uint256 tokenId,
1358         bytes memory data
1359     ) internal virtual {
1360         _mint(to, tokenId);
1361         require(
1362             _checkOnERC721Received(address(0), to, tokenId, data),
1363             "ERC721: transfer to non ERC721Receiver implementer"
1364         );
1365     }
1366 
1367     /**
1368      * @dev Mints `tokenId` and transfers it to `to`.
1369      *
1370      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1371      *
1372      * Requirements:
1373      *
1374      * - `tokenId` must not exist.
1375      * - `to` cannot be the zero address.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _mint(address to, uint256 tokenId) internal virtual {
1380         require(to != address(0), "ERC721: mint to the zero address");
1381         require(!_exists(tokenId), "ERC721: token already minted");
1382 
1383         _beforeTokenTransfer(address(0), to, tokenId, 1);
1384 
1385         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1386         require(!_exists(tokenId), "ERC721: token already minted");
1387 
1388         unchecked {
1389             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1390             // Given that tokens are minted one by one, it is impossible in practice that
1391             // this ever happens. Might change if we allow batch minting.
1392             // The ERC fails to describe this case.
1393             _balances[to] += 1;
1394         }
1395 
1396         _owners[tokenId] = to;
1397 
1398         emit Transfer(address(0), to, tokenId);
1399 
1400         _afterTokenTransfer(address(0), to, tokenId, 1);
1401     }
1402 
1403     /**
1404      * @dev Destroys `tokenId`.
1405      * The approval is cleared when the token is burned.
1406      * This is an internal function that does not check if the sender is authorized to operate on the token.
1407      *
1408      * Requirements:
1409      *
1410      * - `tokenId` must exist.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _burn(uint256 tokenId) internal virtual {
1415         address owner = ERC721.ownerOf(tokenId);
1416 
1417         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1418 
1419         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1420         owner = ERC721.ownerOf(tokenId);
1421 
1422         // Clear approvals
1423         delete _tokenApprovals[tokenId];
1424 
1425         unchecked {
1426             // Cannot overflow, as that would require more tokens to be burned/transferred
1427             // out than the owner initially received through minting and transferring in.
1428             _balances[owner] -= 1;
1429         }
1430         delete _owners[tokenId];
1431 
1432         emit Transfer(owner, address(0), tokenId);
1433 
1434         _afterTokenTransfer(owner, address(0), tokenId, 1);
1435     }
1436 
1437     /**
1438      * @dev Transfers `tokenId` from `from` to `to`.
1439      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1440      *
1441      * Requirements:
1442      *
1443      * - `to` cannot be the zero address.
1444      * - `tokenId` token must be owned by `from`.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function _transfer(
1449         address from,
1450         address to,
1451         uint256 tokenId
1452     ) internal virtual {
1453         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1454         require(to != address(0), "ERC721: transfer to the zero address");
1455 
1456         _beforeTokenTransfer(from, to, tokenId, 1);
1457 
1458         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1459         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1460 
1461         // Clear approvals from the previous owner
1462         delete _tokenApprovals[tokenId];
1463 
1464         unchecked {
1465             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1466             // `from`'s balance is the number of token held, which is at least one before the current
1467             // transfer.
1468             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1469             // all 2**256 token ids to be minted, which in practice is impossible.
1470             _balances[from] -= 1;
1471             _balances[to] += 1;
1472         }
1473         _owners[tokenId] = to;
1474 
1475         emit Transfer(from, to, tokenId);
1476 
1477         _afterTokenTransfer(from, to, tokenId, 1);
1478     }
1479 
1480     /**
1481      * @dev Approve `to` to operate on `tokenId`
1482      *
1483      * Emits an {Approval} event.
1484      */
1485     function _approve(address to, uint256 tokenId) internal virtual {
1486         _tokenApprovals[tokenId] = to;
1487         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1488     }
1489 
1490     /**
1491      * @dev Approve `operator` to operate on all of `owner` tokens
1492      *
1493      * Emits an {ApprovalForAll} event.
1494      */
1495     function _setApprovalForAll(
1496         address owner,
1497         address operator,
1498         bool approved
1499     ) internal virtual {
1500         require(owner != operator, "ERC721: approve to caller");
1501         _operatorApprovals[owner][operator] = approved;
1502         emit ApprovalForAll(owner, operator, approved);
1503     }
1504 
1505     /**
1506      * @dev Reverts if the `tokenId` has not been minted yet.
1507      */
1508     function _requireMinted(uint256 tokenId) internal view virtual {
1509         require(_exists(tokenId), "ERC721: invalid token ID");
1510     }
1511 
1512     /**
1513      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1514      * The call is not executed if the target address is not a contract.
1515      *
1516      * @param from address representing the previous owner of the given token ID
1517      * @param to target address that will receive the tokens
1518      * @param tokenId uint256 ID of the token to be transferred
1519      * @param data bytes optional data to send along with the call
1520      * @return bool whether the call correctly returned the expected magic value
1521      */
1522     function _checkOnERC721Received(
1523         address from,
1524         address to,
1525         uint256 tokenId,
1526         bytes memory data
1527     ) private returns (bool) {
1528         if (to.isContract()) {
1529             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1530                 return retval == IERC721Receiver.onERC721Received.selector;
1531             } catch (bytes memory reason) {
1532                 if (reason.length == 0) {
1533                     revert("ERC721: transfer to non ERC721Receiver implementer");
1534                 } else {
1535                     /// @solidity memory-safe-assembly
1536                     assembly {
1537                         revert(add(32, reason), mload(reason))
1538                     }
1539                 }
1540             }
1541         } else {
1542             return true;
1543         }
1544     }
1545 
1546     /**
1547      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1548      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1549      *
1550      * Calling conditions:
1551      *
1552      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1553      * - When `from` is zero, the tokens will be minted for `to`.
1554      * - When `to` is zero, ``from``'s tokens will be burned.
1555      * - `from` and `to` are never both zero.
1556      * - `batchSize` is non-zero.
1557      *
1558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1559      */
1560     function _beforeTokenTransfer(
1561         address from,
1562         address to,
1563         uint256, /* firstTokenId */
1564         uint256 batchSize
1565     ) internal virtual {
1566         if (batchSize > 1) {
1567             if (from != address(0)) {
1568                 _balances[from] -= batchSize;
1569             }
1570             if (to != address(0)) {
1571                 _balances[to] += batchSize;
1572             }
1573         }
1574     }
1575 
1576     /**
1577      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1578      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1579      *
1580      * Calling conditions:
1581      *
1582      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1583      * - When `from` is zero, the tokens were minted for `to`.
1584      * - When `to` is zero, ``from``'s tokens were burned.
1585      * - `from` and `to` are never both zero.
1586      * - `batchSize` is non-zero.
1587      *
1588      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1589      */
1590     function _afterTokenTransfer(
1591         address from,
1592         address to,
1593         uint256 firstTokenId,
1594         uint256 batchSize
1595     ) internal virtual {}
1596 }
1597 
1598 // File: contracts/Sapiens.sol
1599 
1600 
1601 
1602 // Amended by HashLips
1603 /**
1604     !Disclaimer!
1605 
1606     These contracts have been used to create tutorials,
1607     and was created for the purpose to teach people
1608     how to create smart contracts on the blockchain.
1609     please review this code on your own before using any of
1610     the following code for production.
1611     The developer will not be responsible or liable for all loss or 
1612     damage whatsoever caused by you participating in any way in the 
1613     experimental code, whether putting money into the contract or 
1614     using the code for your own project.
1615 */
1616 
1617 pragma solidity >=0.7.0 <0.9.0;
1618 
1619 
1620 
1621 
1622 contract HomoSapiensClub is ERC721, Ownable {
1623   using Strings for uint256;
1624   using Counters for Counters.Counter;
1625 
1626   Counters.Counter private supply;
1627 
1628   string public uriPrefix = "";
1629   string public uriSuffix = ".json";
1630   string public hiddenMetadataUri;
1631   
1632   uint256 public cost = 0 ether;
1633   uint256 public maxSupply = 7777;
1634   uint256 public maxMintAmountPerTx = 8;
1635 
1636   bool public paused = true;
1637   bool public revealed = false;
1638 
1639   constructor() ERC721("Homo Sapiens Club", "HSC") {
1640     setHiddenMetadataUri("ipfs://QmPxM7zQwtrbiTCou36EoBHSDNXJJmfWFAi2qUiKZ6WKk1/hidden.json");
1641   }
1642 
1643   modifier mintCompliance(uint256 _mintAmount) {
1644     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1645     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1646     _;
1647   }
1648 
1649   function totalSupply() public view returns (uint256) {
1650     return supply.current();
1651   }
1652 
1653   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1654     require(!paused, "The contract is paused!");
1655     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1656 
1657     _mintLoop(msg.sender, _mintAmount);
1658   }
1659   
1660   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1661     _mintLoop(_receiver, _mintAmount);
1662   }
1663 
1664   function walletOfOwner(address _owner)
1665     public
1666     view
1667     returns (uint256[] memory)
1668   {
1669     uint256 ownerTokenCount = balanceOf(_owner);
1670     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1671     uint256 currentTokenId = 1;
1672     uint256 ownedTokenIndex = 0;
1673 
1674     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1675       address currentTokenOwner = ownerOf(currentTokenId);
1676 
1677       if (currentTokenOwner == _owner) {
1678         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1679 
1680         ownedTokenIndex++;
1681       }
1682 
1683       currentTokenId++;
1684     }
1685 
1686     return ownedTokenIds;
1687   }
1688 
1689   function tokenURI(uint256 _tokenId)
1690     public
1691     view
1692     virtual
1693     override
1694     returns (string memory)
1695   {
1696     require(
1697       _exists(_tokenId),
1698       "ERC721Metadata: URI query for nonexistent token"
1699     );
1700 
1701     if (revealed == false) {
1702       return hiddenMetadataUri;
1703     }
1704 
1705     string memory currentBaseURI = _baseURI();
1706     return bytes(currentBaseURI).length > 0
1707         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1708         : "";
1709   }
1710 
1711   function setRevealed(bool _state) public onlyOwner {
1712     revealed = _state;
1713   }
1714 
1715   function setCost(uint256 _cost) public onlyOwner {
1716     cost = _cost;
1717   }
1718 
1719   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1720     maxMintAmountPerTx = _maxMintAmountPerTx;
1721   }
1722 
1723   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1724     hiddenMetadataUri = _hiddenMetadataUri;
1725   }
1726 
1727   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1728     uriPrefix = _uriPrefix;
1729   }
1730 
1731   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1732     uriSuffix = _uriSuffix;
1733   }
1734 
1735   function setPaused(bool _state) public onlyOwner {
1736     paused = _state;
1737   }
1738 
1739   function withdraw() public onlyOwner {
1740     // This will pay HashLips 1% of the initial sale.
1741     // You can remove this if you want, or keep it in to support HashLips and his channel.
1742     // =============================================================================
1743     (bool hs, ) = payable(0x77Dc8c3d5884a5234734b53f1EBC667f931E027B).call{value: address(this).balance * 5 / 100}("");
1744     require(hs);
1745     // =============================================================================
1746 
1747     // This will transfer the remaining contract balance to the owner.
1748     // Do not remove this otherwise you will not be able to withdraw the funds.
1749     // =============================================================================
1750     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1751     require(os);
1752     // =============================================================================
1753   }
1754 
1755   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1756     for (uint256 i = 0; i < _mintAmount; i++) {
1757       supply.increment();
1758       _safeMint(_receiver, supply.current());
1759     }
1760   }
1761 
1762   function _baseURI() internal view virtual override returns (string memory) {
1763     return uriPrefix;
1764   }
1765 }