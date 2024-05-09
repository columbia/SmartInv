1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Counters.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @title Counters
13  * @author Matt Condon (@shrugs)
14  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
15  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
16  *
17  * Include with `using Counters for Counters.Counter;`
18  */
19 library Counters {
20     struct Counter {
21         // This variable should never be directly accessed by users of the library: interactions must be restricted to
22         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
23         // this feature: see https://github.com/ethereum/solidity/issues/4637
24         uint256 _value; // default: 0
25     }
26 
27     function current(Counter storage counter) internal view returns (uint256) {
28         return counter._value;
29     }
30 
31     function increment(Counter storage counter) internal {
32         unchecked {
33             counter._value += 1;
34         }
35     }
36 
37     function decrement(Counter storage counter) internal {
38         uint256 value = counter._value;
39         require(value > 0, "Counter: decrement overflow");
40         unchecked {
41             counter._value = value - 1;
42         }
43     }
44 
45     function reset(Counter storage counter) internal {
46         counter._value = 0;
47     }
48 }
49 
50 // File: @openzeppelin/contracts/utils/math/Math.sol
51 
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
245     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
246         unchecked {
247             uint256 result = sqrt(a);
248             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
249         }
250     }
251 
252     /**
253      * @dev Return the log in base 2, rounded down, of a positive value.
254      * Returns 0 if given 0.
255      */
256     function log2(uint256 value) internal pure returns (uint256) {
257         uint256 result = 0;
258         unchecked {
259             if (value >> 128 > 0) {
260                 value >>= 128;
261                 result += 128;
262             }
263             if (value >> 64 > 0) {
264                 value >>= 64;
265                 result += 64;
266             }
267             if (value >> 32 > 0) {
268                 value >>= 32;
269                 result += 32;
270             }
271             if (value >> 16 > 0) {
272                 value >>= 16;
273                 result += 16;
274             }
275             if (value >> 8 > 0) {
276                 value >>= 8;
277                 result += 8;
278             }
279             if (value >> 4 > 0) {
280                 value >>= 4;
281                 result += 4;
282             }
283             if (value >> 2 > 0) {
284                 value >>= 2;
285                 result += 2;
286             }
287             if (value >> 1 > 0) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log2(value);
301             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 10, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      */
309     function log10(uint256 value) internal pure returns (uint256) {
310         uint256 result = 0;
311         unchecked {
312             if (value >= 10**64) {
313                 value /= 10**64;
314                 result += 64;
315             }
316             if (value >= 10**32) {
317                 value /= 10**32;
318                 result += 32;
319             }
320             if (value >= 10**16) {
321                 value /= 10**16;
322                 result += 16;
323             }
324             if (value >= 10**8) {
325                 value /= 10**8;
326                 result += 8;
327             }
328             if (value >= 10**4) {
329                 value /= 10**4;
330                 result += 4;
331             }
332             if (value >= 10**2) {
333                 value /= 10**2;
334                 result += 2;
335             }
336             if (value >= 10**1) {
337                 result += 1;
338             }
339         }
340         return result;
341     }
342 
343     /**
344      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
345      * Returns 0 if given 0.
346      */
347     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
348         unchecked {
349             uint256 result = log10(value);
350             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
351         }
352     }
353 
354     /**
355      * @dev Return the log in base 256, rounded down, of a positive value.
356      * Returns 0 if given 0.
357      *
358      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
359      */
360     function log256(uint256 value) internal pure returns (uint256) {
361         uint256 result = 0;
362         unchecked {
363             if (value >> 128 > 0) {
364                 value >>= 128;
365                 result += 16;
366             }
367             if (value >> 64 > 0) {
368                 value >>= 64;
369                 result += 8;
370             }
371             if (value >> 32 > 0) {
372                 value >>= 32;
373                 result += 4;
374             }
375             if (value >> 16 > 0) {
376                 value >>= 16;
377                 result += 2;
378             }
379             if (value >> 8 > 0) {
380                 result += 1;
381             }
382         }
383         return result;
384     }
385 
386     /**
387      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
388      * Returns 0 if given 0.
389      */
390     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
391         unchecked {
392             uint256 result = log256(value);
393             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Strings.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev String operations.
408  */
409 library Strings {
410     bytes16 private constant _SYMBOLS = "0123456789abcdef";
411     uint8 private constant _ADDRESS_LENGTH = 20;
412 
413     /**
414      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
415      */
416     function toString(uint256 value) internal pure returns (string memory) {
417         unchecked {
418             uint256 length = Math.log10(value) + 1;
419             string memory buffer = new string(length);
420             uint256 ptr;
421             /// @solidity memory-safe-assembly
422             assembly {
423                 ptr := add(buffer, add(32, length))
424             }
425             while (true) {
426                 ptr--;
427                 /// @solidity memory-safe-assembly
428                 assembly {
429                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
430                 }
431                 value /= 10;
432                 if (value == 0) break;
433             }
434             return buffer;
435         }
436     }
437 
438     /**
439      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
440      */
441     function toHexString(uint256 value) internal pure returns (string memory) {
442         unchecked {
443             return toHexString(value, Math.log256(value) + 1);
444         }
445     }
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
449      */
450     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
451         bytes memory buffer = new bytes(2 * length + 2);
452         buffer[0] = "0";
453         buffer[1] = "x";
454         for (uint256 i = 2 * length + 1; i > 1; --i) {
455             buffer[i] = _SYMBOLS[value & 0xf];
456             value >>= 4;
457         }
458         require(value == 0, "Strings: hex length insufficient");
459         return string(buffer);
460     }
461 
462     /**
463      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
464      */
465     function toHexString(address addr) internal pure returns (string memory) {
466         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
467     }
468 }
469 
470 // File: @openzeppelin/contracts/utils/Context.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Provides information about the current execution context, including the
479  * sender of the transaction and its data. While these are generally available
480  * via msg.sender and msg.data, they should not be accessed in such a direct
481  * manner, since when dealing with meta-transactions the account sending and
482  * paying for execution may not be the actual sender (as far as an application
483  * is concerned).
484  *
485  * This contract is only required for intermediate, library-like contracts.
486  */
487 abstract contract Context {
488     function _msgSender() internal view virtual returns (address) {
489         return msg.sender;
490     }
491 
492     function _msgData() internal view virtual returns (bytes calldata) {
493         return msg.data;
494     }
495 }
496 
497 // File: @openzeppelin/contracts/access/Ownable.sol
498 
499 
500 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Contract module which provides a basic access control mechanism, where
507  * there is an account (an owner) that can be granted exclusive access to
508  * specific functions.
509  *
510  * By default, the owner account will be the one that deploys the contract. This
511  * can later be changed with {transferOwnership}.
512  *
513  * This module is used through inheritance. It will make available the modifier
514  * `onlyOwner`, which can be applied to your functions to restrict their use to
515  * the owner.
516  */
517 abstract contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     /**
523      * @dev Initializes the contract setting the deployer as the initial owner.
524      */
525     constructor() {
526         _transferOwnership(_msgSender());
527     }
528 
529     /**
530      * @dev Throws if called by any account other than the owner.
531      */
532     modifier onlyOwner() {
533         _checkOwner();
534         _;
535     }
536 
537     /**
538      * @dev Returns the address of the current owner.
539      */
540     function owner() public view virtual returns (address) {
541         return _owner;
542     }
543 
544     /**
545      * @dev Throws if the sender is not the owner.
546      */
547     function _checkOwner() internal view virtual {
548         require(owner() == _msgSender(), "Ownable: caller is not the owner");
549     }
550 
551     /**
552      * @dev Leaves the contract without owner. It will not be possible to call
553      * `onlyOwner` functions anymore. Can only be called by the current owner.
554      *
555      * NOTE: Renouncing ownership will leave the contract without an owner,
556      * thereby removing any functionality that is only available to the owner.
557      */
558     function renounceOwnership() public virtual onlyOwner {
559         _transferOwnership(address(0));
560     }
561 
562     /**
563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
564      * Can only be called by the current owner.
565      */
566     function transferOwnership(address newOwner) public virtual onlyOwner {
567         require(newOwner != address(0), "Ownable: new owner is the zero address");
568         _transferOwnership(newOwner);
569     }
570 
571     /**
572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
573      * Internal function without access restriction.
574      */
575     function _transferOwnership(address newOwner) internal virtual {
576         address oldOwner = _owner;
577         _owner = newOwner;
578         emit OwnershipTransferred(oldOwner, newOwner);
579     }
580 }
581 
582 // File: @openzeppelin/contracts/utils/Address.sol
583 
584 
585 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
586 
587 pragma solidity ^0.8.1;
588 
589 /**
590  * @dev Collection of functions related to the address type
591  */
592 library Address {
593     /**
594      * @dev Returns true if `account` is a contract.
595      *
596      * [IMPORTANT]
597      * ====
598      * It is unsafe to assume that an address for which this function returns
599      * false is an externally-owned account (EOA) and not a contract.
600      *
601      * Among others, `isContract` will return false for the following
602      * types of addresses:
603      *
604      *  - an externally-owned account
605      *  - a contract in construction
606      *  - an address where a contract will be created
607      *  - an address where a contract lived, but was destroyed
608      * ====
609      *
610      * [IMPORTANT]
611      * ====
612      * You shouldn't rely on `isContract` to protect against flash loan attacks!
613      *
614      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
615      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
616      * constructor.
617      * ====
618      */
619     function isContract(address account) internal view returns (bool) {
620         // This method relies on extcodesize/address.code.length, which returns 0
621         // for contracts in construction, since the code is only stored at the end
622         // of the constructor execution.
623 
624         return account.code.length > 0;
625     }
626 
627     /**
628      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
629      * `recipient`, forwarding all available gas and reverting on errors.
630      *
631      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
632      * of certain opcodes, possibly making contracts go over the 2300 gas limit
633      * imposed by `transfer`, making them unable to receive funds via
634      * `transfer`. {sendValue} removes this limitation.
635      *
636      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
637      *
638      * IMPORTANT: because control is transferred to `recipient`, care must be
639      * taken to not create reentrancy vulnerabilities. Consider using
640      * {ReentrancyGuard} or the
641      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
642      */
643     function sendValue(address payable recipient, uint256 amount) internal {
644         require(address(this).balance >= amount, "Address: insufficient balance");
645 
646         (bool success, ) = recipient.call{value: amount}("");
647         require(success, "Address: unable to send value, recipient may have reverted");
648     }
649 
650     /**
651      * @dev Performs a Solidity function call using a low level `call`. A
652      * plain `call` is an unsafe replacement for a function call: use this
653      * function instead.
654      *
655      * If `target` reverts with a revert reason, it is bubbled up by this
656      * function (like regular Solidity function calls).
657      *
658      * Returns the raw returned data. To convert to the expected return value,
659      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
660      *
661      * Requirements:
662      *
663      * - `target` must be a contract.
664      * - calling `target` with `data` must not revert.
665      *
666      * _Available since v3.1._
667      */
668     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
669         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
674      * `errorMessage` as a fallback revert reason when `target` reverts.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(
679         address target,
680         bytes memory data,
681         string memory errorMessage
682     ) internal returns (bytes memory) {
683         return functionCallWithValue(target, data, 0, errorMessage);
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
688      * but also transferring `value` wei to `target`.
689      *
690      * Requirements:
691      *
692      * - the calling contract must have an ETH balance of at least `value`.
693      * - the called Solidity function must be `payable`.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(
698         address target,
699         bytes memory data,
700         uint256 value
701     ) internal returns (bytes memory) {
702         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
707      * with `errorMessage` as a fallback revert reason when `target` reverts.
708      *
709      * _Available since v3.1._
710      */
711     function functionCallWithValue(
712         address target,
713         bytes memory data,
714         uint256 value,
715         string memory errorMessage
716     ) internal returns (bytes memory) {
717         require(address(this).balance >= value, "Address: insufficient balance for call");
718         (bool success, bytes memory returndata) = target.call{value: value}(data);
719         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
724      * but performing a static call.
725      *
726      * _Available since v3.3._
727      */
728     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
729         return functionStaticCall(target, data, "Address: low-level static call failed");
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
734      * but performing a static call.
735      *
736      * _Available since v3.3._
737      */
738     function functionStaticCall(
739         address target,
740         bytes memory data,
741         string memory errorMessage
742     ) internal view returns (bytes memory) {
743         (bool success, bytes memory returndata) = target.staticcall(data);
744         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
749      * but performing a delegate call.
750      *
751      * _Available since v3.4._
752      */
753     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
754         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
759      * but performing a delegate call.
760      *
761      * _Available since v3.4._
762      */
763     function functionDelegateCall(
764         address target,
765         bytes memory data,
766         string memory errorMessage
767     ) internal returns (bytes memory) {
768         (bool success, bytes memory returndata) = target.delegatecall(data);
769         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
774      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
775      *
776      * _Available since v4.8._
777      */
778     function verifyCallResultFromTarget(
779         address target,
780         bool success,
781         bytes memory returndata,
782         string memory errorMessage
783     ) internal view returns (bytes memory) {
784         if (success) {
785             if (returndata.length == 0) {
786                 // only check isContract if the call was successful and the return data is empty
787                 // otherwise we already know that it was a contract
788                 require(isContract(target), "Address: call to non-contract");
789             }
790             return returndata;
791         } else {
792             _revert(returndata, errorMessage);
793         }
794     }
795 
796     /**
797      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
798      * revert reason or using the provided one.
799      *
800      * _Available since v4.3._
801      */
802     function verifyCallResult(
803         bool success,
804         bytes memory returndata,
805         string memory errorMessage
806     ) internal pure returns (bytes memory) {
807         if (success) {
808             return returndata;
809         } else {
810             _revert(returndata, errorMessage);
811         }
812     }
813 
814     function _revert(bytes memory returndata, string memory errorMessage) private pure {
815         // Look for revert reason and bubble it up if present
816         if (returndata.length > 0) {
817             // The easiest way to bubble the revert reason is using memory via assembly
818             /// @solidity memory-safe-assembly
819             assembly {
820                 let returndata_size := mload(returndata)
821                 revert(add(32, returndata), returndata_size)
822             }
823         } else {
824             revert(errorMessage);
825         }
826     }
827 }
828 
829 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
830 
831 
832 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 /**
837  * @title ERC721 token receiver interface
838  * @dev Interface for any contract that wants to support safeTransfers
839  * from ERC721 asset contracts.
840  */
841 interface IERC721Receiver {
842     /**
843      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
844      * by `operator` from `from`, this function is called.
845      *
846      * It must return its Solidity selector to confirm the token transfer.
847      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
848      *
849      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
850      */
851     function onERC721Received(
852         address operator,
853         address from,
854         uint256 tokenId,
855         bytes calldata data
856     ) external returns (bytes4);
857 }
858 
859 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
860 
861 
862 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 /**
867  * @dev Interface of the ERC165 standard, as defined in the
868  * https://eips.ethereum.org/EIPS/eip-165[EIP].
869  *
870  * Implementers can declare support of contract interfaces, which can then be
871  * queried by others ({ERC165Checker}).
872  *
873  * For an implementation, see {ERC165}.
874  */
875 interface IERC165 {
876     /**
877      * @dev Returns true if this contract implements the interface defined by
878      * `interfaceId`. See the corresponding
879      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
880      * to learn more about how these ids are created.
881      *
882      * This function call must use less than 30 000 gas.
883      */
884     function supportsInterface(bytes4 interfaceId) external view returns (bool);
885 }
886 
887 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
888 
889 
890 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 /**
896  * @dev Implementation of the {IERC165} interface.
897  *
898  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
899  * for the additional interface id that will be supported. For example:
900  *
901  * ```solidity
902  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
903  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
904  * }
905  * ```
906  *
907  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
908  */
909 abstract contract ERC165 is IERC165 {
910     /**
911      * @dev See {IERC165-supportsInterface}.
912      */
913     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
914         return interfaceId == type(IERC165).interfaceId;
915     }
916 }
917 
918 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
919 
920 
921 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 
926 /**
927  * @dev Required interface of an ERC721 compliant contract.
928  */
929 interface IERC721 is IERC165 {
930     /**
931      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
932      */
933     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
934 
935     /**
936      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
937      */
938     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
939 
940     /**
941      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
942      */
943     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
944 
945     /**
946      * @dev Returns the number of tokens in ``owner``'s account.
947      */
948     function balanceOf(address owner) external view returns (uint256 balance);
949 
950     /**
951      * @dev Returns the owner of the `tokenId` token.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must exist.
956      */
957     function ownerOf(uint256 tokenId) external view returns (address owner);
958 
959     /**
960      * @dev Safely transfers `tokenId` token from `from` to `to`.
961      *
962      * Requirements:
963      *
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      * - `tokenId` token must exist and be owned by `from`.
967      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes calldata data
977     ) external;
978 
979     /**
980      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
981      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
982      *
983      * Requirements:
984      *
985      * - `from` cannot be the zero address.
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must exist and be owned by `from`.
988      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function safeTransferFrom(
994         address from,
995         address to,
996         uint256 tokenId
997     ) external;
998 
999     /**
1000      * @dev Transfers `tokenId` token from `from` to `to`.
1001      *
1002      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1003      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1004      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) external;
1020 
1021     /**
1022      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1023      * The approval is cleared when the token is transferred.
1024      *
1025      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1026      *
1027      * Requirements:
1028      *
1029      * - The caller must own the token or be an approved operator.
1030      * - `tokenId` must exist.
1031      *
1032      * Emits an {Approval} event.
1033      */
1034     function approve(address to, uint256 tokenId) external;
1035 
1036     /**
1037      * @dev Approve or remove `operator` as an operator for the caller.
1038      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1039      *
1040      * Requirements:
1041      *
1042      * - The `operator` cannot be the caller.
1043      *
1044      * Emits an {ApprovalForAll} event.
1045      */
1046     function setApprovalForAll(address operator, bool _approved) external;
1047 
1048     /**
1049      * @dev Returns the account approved for `tokenId` token.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function getApproved(uint256 tokenId) external view returns (address operator);
1056 
1057     /**
1058      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1059      *
1060      * See {setApprovalForAll}
1061      */
1062     function isApprovedForAll(address owner, address operator) external view returns (bool);
1063 }
1064 
1065 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1066 
1067 
1068 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 
1073 /**
1074  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1075  * @dev See https://eips.ethereum.org/EIPS/eip-721
1076  */
1077 interface IERC721Metadata is IERC721 {
1078     /**
1079      * @dev Returns the token collection name.
1080      */
1081     function name() external view returns (string memory);
1082 
1083     /**
1084      * @dev Returns the token collection symbol.
1085      */
1086     function symbol() external view returns (string memory);
1087 
1088     /**
1089      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1090      */
1091     function tokenURI(uint256 tokenId) external view returns (string memory);
1092 }
1093 
1094 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1095 
1096 
1097 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 
1102 
1103 
1104 
1105 
1106 
1107 
1108 /**
1109  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1110  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1111  * {ERC721Enumerable}.
1112  */
1113 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1114     using Address for address;
1115     using Strings for uint256;
1116 
1117     // Token name
1118     string private _name;
1119 
1120     // Token symbol
1121     string private _symbol;
1122 
1123     // Mapping from token ID to owner address
1124     mapping(uint256 => address) private _owners;
1125 
1126     // Mapping owner address to token count
1127     mapping(address => uint256) private _balances;
1128 
1129     // Mapping from token ID to approved address
1130     mapping(uint256 => address) private _tokenApprovals;
1131 
1132     // Mapping from owner to operator approvals
1133     mapping(address => mapping(address => bool)) private _operatorApprovals;
1134 
1135     /**
1136      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1137      */
1138     constructor(string memory name_, string memory symbol_) {
1139         _name = name_;
1140         _symbol = symbol_;
1141     }
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1147         return
1148             interfaceId == type(IERC721).interfaceId ||
1149             interfaceId == type(IERC721Metadata).interfaceId ||
1150             super.supportsInterface(interfaceId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-balanceOf}.
1155      */
1156     function balanceOf(address owner) public view virtual override returns (uint256) {
1157         require(owner != address(0), "ERC721: address zero is not a valid owner");
1158         return _balances[owner];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-ownerOf}.
1163      */
1164     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1165         address owner = _ownerOf(tokenId);
1166         require(owner != address(0), "ERC721: invalid token ID");
1167         return owner;
1168     }
1169 
1170     /**
1171      * @dev See {IERC721Metadata-name}.
1172      */
1173     function name() public view virtual override returns (string memory) {
1174         return _name;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Metadata-symbol}.
1179      */
1180     function symbol() public view virtual override returns (string memory) {
1181         return _symbol;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-tokenURI}.
1186      */
1187     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1188         _requireMinted(tokenId);
1189 
1190         string memory baseURI = _baseURI();
1191         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1192     }
1193 
1194     /**
1195      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1196      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1197      * by default, can be overridden in child contracts.
1198      */
1199     function _baseURI() internal view virtual returns (string memory) {
1200         return "";
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-approve}.
1205      */
1206     function approve(address to, uint256 tokenId) public virtual override {
1207         address owner = ERC721.ownerOf(tokenId);
1208         require(to != owner, "ERC721: approval to current owner");
1209 
1210         require(
1211             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1212             "ERC721: approve caller is not token owner or approved for all"
1213         );
1214 
1215         _approve(to, tokenId);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-getApproved}.
1220      */
1221     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1222         _requireMinted(tokenId);
1223 
1224         return _tokenApprovals[tokenId];
1225     }
1226 
1227     /**
1228      * @dev See {IERC721-setApprovalForAll}.
1229      */
1230     function setApprovalForAll(address operator, bool approved) public virtual override {
1231         _setApprovalForAll(_msgSender(), operator, approved);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-isApprovedForAll}.
1236      */
1237     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1238         return _operatorApprovals[owner][operator];
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-transferFrom}.
1243      */
1244     function transferFrom(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) public virtual override {
1249         //solhint-disable-next-line max-line-length
1250         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1251 
1252         _transfer(from, to, tokenId);
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-safeTransferFrom}.
1257      */
1258     function safeTransferFrom(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) public virtual override {
1263         safeTransferFrom(from, to, tokenId, "");
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-safeTransferFrom}.
1268      */
1269     function safeTransferFrom(
1270         address from,
1271         address to,
1272         uint256 tokenId,
1273         bytes memory data
1274     ) public virtual override {
1275         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1276         _safeTransfer(from, to, tokenId, data);
1277     }
1278 
1279     /**
1280      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1281      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1282      *
1283      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1284      *
1285      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1286      * implement alternative mechanisms to perform token transfer, such as signature-based.
1287      *
1288      * Requirements:
1289      *
1290      * - `from` cannot be the zero address.
1291      * - `to` cannot be the zero address.
1292      * - `tokenId` token must exist and be owned by `from`.
1293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _safeTransfer(
1298         address from,
1299         address to,
1300         uint256 tokenId,
1301         bytes memory data
1302     ) internal virtual {
1303         _transfer(from, to, tokenId);
1304         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1305     }
1306 
1307     /**
1308      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1309      */
1310     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1311         return _owners[tokenId];
1312     }
1313 
1314     /**
1315      * @dev Returns whether `tokenId` exists.
1316      *
1317      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1318      *
1319      * Tokens start existing when they are minted (`_mint`),
1320      * and stop existing when they are burned (`_burn`).
1321      */
1322     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1323         return _ownerOf(tokenId) != address(0);
1324     }
1325 
1326     /**
1327      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1328      *
1329      * Requirements:
1330      *
1331      * - `tokenId` must exist.
1332      */
1333     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1334         address owner = ERC721.ownerOf(tokenId);
1335         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1336     }
1337 
1338     /**
1339      * @dev Safely mints `tokenId` and transfers it to `to`.
1340      *
1341      * Requirements:
1342      *
1343      * - `tokenId` must not exist.
1344      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function _safeMint(address to, uint256 tokenId) internal virtual {
1349         _safeMint(to, tokenId, "");
1350     }
1351 
1352     /**
1353      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1354      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1355      */
1356     function _safeMint(
1357         address to,
1358         uint256 tokenId,
1359         bytes memory data
1360     ) internal virtual {
1361         _mint(to, tokenId);
1362         require(
1363             _checkOnERC721Received(address(0), to, tokenId, data),
1364             "ERC721: transfer to non ERC721Receiver implementer"
1365         );
1366     }
1367 
1368     /**
1369      * @dev Mints `tokenId` and transfers it to `to`.
1370      *
1371      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1372      *
1373      * Requirements:
1374      *
1375      * - `tokenId` must not exist.
1376      * - `to` cannot be the zero address.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function _mint(address to, uint256 tokenId) internal virtual {
1381         require(to != address(0), "ERC721: mint to the zero address");
1382         require(!_exists(tokenId), "ERC721: token already minted");
1383 
1384         _beforeTokenTransfer(address(0), to, tokenId, 1);
1385 
1386         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1387         require(!_exists(tokenId), "ERC721: token already minted");
1388 
1389         unchecked {
1390             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1391             // Given that tokens are minted one by one, it is impossible in practice that
1392             // this ever happens. Might change if we allow batch minting.
1393             // The ERC fails to describe this case.
1394             _balances[to] += 1;
1395         }
1396 
1397         _owners[tokenId] = to;
1398 
1399         emit Transfer(address(0), to, tokenId);
1400 
1401         _afterTokenTransfer(address(0), to, tokenId, 1);
1402     }
1403 
1404     /**
1405      * @dev Destroys `tokenId`.
1406      * The approval is cleared when the token is burned.
1407      * This is an internal function that does not check if the sender is authorized to operate on the token.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must exist.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _burn(uint256 tokenId) internal virtual {
1416         address owner = ERC721.ownerOf(tokenId);
1417 
1418         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1419 
1420         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1421         owner = ERC721.ownerOf(tokenId);
1422 
1423         // Clear approvals
1424         delete _tokenApprovals[tokenId];
1425 
1426         unchecked {
1427             // Cannot overflow, as that would require more tokens to be burned/transferred
1428             // out than the owner initially received through minting and transferring in.
1429             _balances[owner] -= 1;
1430         }
1431         delete _owners[tokenId];
1432 
1433         emit Transfer(owner, address(0), tokenId);
1434 
1435         _afterTokenTransfer(owner, address(0), tokenId, 1);
1436     }
1437 
1438     /**
1439      * @dev Transfers `tokenId` from `from` to `to`.
1440      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1441      *
1442      * Requirements:
1443      *
1444      * - `to` cannot be the zero address.
1445      * - `tokenId` token must be owned by `from`.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _transfer(
1450         address from,
1451         address to,
1452         uint256 tokenId
1453     ) internal virtual {
1454         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1455         require(to != address(0), "ERC721: transfer to the zero address");
1456 
1457         _beforeTokenTransfer(from, to, tokenId, 1);
1458 
1459         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1460         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1461 
1462         // Clear approvals from the previous owner
1463         delete _tokenApprovals[tokenId];
1464 
1465         unchecked {
1466             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1467             // `from`'s balance is the number of token held, which is at least one before the current
1468             // transfer.
1469             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1470             // all 2**256 token ids to be minted, which in practice is impossible.
1471             _balances[from] -= 1;
1472             _balances[to] += 1;
1473         }
1474         _owners[tokenId] = to;
1475 
1476         emit Transfer(from, to, tokenId);
1477 
1478         _afterTokenTransfer(from, to, tokenId, 1);
1479     }
1480 
1481     /**
1482      * @dev Approve `to` to operate on `tokenId`
1483      *
1484      * Emits an {Approval} event.
1485      */
1486     function _approve(address to, uint256 tokenId) internal virtual {
1487         _tokenApprovals[tokenId] = to;
1488         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1489     }
1490 
1491     /**
1492      * @dev Approve `operator` to operate on all of `owner` tokens
1493      *
1494      * Emits an {ApprovalForAll} event.
1495      */
1496     function _setApprovalForAll(
1497         address owner,
1498         address operator,
1499         bool approved
1500     ) internal virtual {
1501         require(owner != operator, "ERC721: approve to caller");
1502         _operatorApprovals[owner][operator] = approved;
1503         emit ApprovalForAll(owner, operator, approved);
1504     }
1505 
1506     /**
1507      * @dev Reverts if the `tokenId` has not been minted yet.
1508      */
1509     function _requireMinted(uint256 tokenId) internal view virtual {
1510         require(_exists(tokenId), "ERC721: invalid token ID");
1511     }
1512 
1513     /**
1514      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1515      * The call is not executed if the target address is not a contract.
1516      *
1517      * @param from address representing the previous owner of the given token ID
1518      * @param to target address that will receive the tokens
1519      * @param tokenId uint256 ID of the token to be transferred
1520      * @param data bytes optional data to send along with the call
1521      * @return bool whether the call correctly returned the expected magic value
1522      */
1523     function _checkOnERC721Received(
1524         address from,
1525         address to,
1526         uint256 tokenId,
1527         bytes memory data
1528     ) private returns (bool) {
1529         if (to.isContract()) {
1530             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1531                 return retval == IERC721Receiver.onERC721Received.selector;
1532             } catch (bytes memory reason) {
1533                 if (reason.length == 0) {
1534                     revert("ERC721: transfer to non ERC721Receiver implementer");
1535                 } else {
1536                     /// @solidity memory-safe-assembly
1537                     assembly {
1538                         revert(add(32, reason), mload(reason))
1539                     }
1540                 }
1541             }
1542         } else {
1543             return true;
1544         }
1545     }
1546 
1547     /**
1548      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1549      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1550      *
1551      * Calling conditions:
1552      *
1553      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1554      * - When `from` is zero, the tokens will be minted for `to`.
1555      * - When `to` is zero, ``from``'s tokens will be burned.
1556      * - `from` and `to` are never both zero.
1557      * - `batchSize` is non-zero.
1558      *
1559      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1560      */
1561     function _beforeTokenTransfer(
1562         address from,
1563         address to,
1564         uint256, /* firstTokenId */
1565         uint256 batchSize
1566     ) internal virtual {
1567         if (batchSize > 1) {
1568             if (from != address(0)) {
1569                 _balances[from] -= batchSize;
1570             }
1571             if (to != address(0)) {
1572                 _balances[to] += batchSize;
1573             }
1574         }
1575     }
1576 
1577     /**
1578      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1579      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1580      *
1581      * Calling conditions:
1582      *
1583      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1584      * - When `from` is zero, the tokens were minted for `to`.
1585      * - When `to` is zero, ``from``'s tokens were burned.
1586      * - `from` and `to` are never both zero.
1587      * - `batchSize` is non-zero.
1588      *
1589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1590      */
1591     function _afterTokenTransfer(
1592         address from,
1593         address to,
1594         uint256 firstTokenId,
1595         uint256 batchSize
1596     ) internal virtual {}
1597 }
1598 
1599 // File: contracts/BlockBotzClubV2.sol
1600 
1601 
1602 
1603 
1604 pragma solidity >=0.7.0 <0.9.0;
1605 
1606 
1607 
1608 
1609 contract BlockBotzClubV2 is ERC721, Ownable {
1610   using Strings for uint256;
1611   using Counters for Counters.Counter;
1612 
1613   Counters.Counter private supply;
1614 
1615   string public uriPrefix = "";
1616   string public uriSuffix = ".json";
1617   string public hiddenMetadataUri;
1618   
1619   uint256 public cost = 0.001 ether;
1620   uint256 public maxSupply = 2500;
1621   uint256 public maxMintAmountPerTx = 20;
1622 
1623   bool public paused = true;
1624   bool public revealed = false;
1625 
1626   constructor() ERC721("BlockBotzClubV2", "BV2") {
1627     setHiddenMetadataUri("ipfs://QmRhrHBkUvYWVGMYsAUnt6hJx3k1DV9gbZQSEjeM1gJdTt/hidden.json");
1628   }
1629 
1630   modifier mintCompliance(uint256 _mintAmount) {
1631     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1632     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1633     _;
1634   }
1635 
1636   function totalSupply() public view returns (uint256) {
1637     return supply.current();
1638   }
1639 
1640   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1641     require(!paused, "The contract is paused!");
1642     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1643 
1644     _mintLoop(msg.sender, _mintAmount);
1645   }
1646   
1647   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1648     _mintLoop(_receiver, _mintAmount);
1649   }
1650 
1651   function walletOfOwner(address _owner)
1652     public
1653     view
1654     returns (uint256[] memory)
1655   {
1656     uint256 ownerTokenCount = balanceOf(_owner);
1657     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1658     uint256 currentTokenId = 1;
1659     uint256 ownedTokenIndex = 0;
1660 
1661     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1662       address currentTokenOwner = ownerOf(currentTokenId);
1663 
1664       if (currentTokenOwner == _owner) {
1665         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1666 
1667         ownedTokenIndex++;
1668       }
1669 
1670       currentTokenId++;
1671     }
1672 
1673     return ownedTokenIds;
1674   }
1675 
1676   function tokenURI(uint256 _tokenId)
1677     public
1678     view
1679     virtual
1680     override
1681     returns (string memory)
1682   {
1683     require(
1684       _exists(_tokenId),
1685       "ERC721Metadata: URI query for nonexistent token"
1686     );
1687 
1688     if (revealed == false) {
1689       return hiddenMetadataUri;
1690     }
1691 
1692     string memory currentBaseURI = _baseURI();
1693     return bytes(currentBaseURI).length > 0
1694         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1695         : "";
1696   }
1697 
1698   function setRevealed(bool _state) public onlyOwner {
1699     revealed = _state;
1700   }
1701 
1702   function setCost(uint256 _cost) public onlyOwner {
1703     cost = _cost;
1704   }
1705 
1706   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1707     maxMintAmountPerTx = _maxMintAmountPerTx;
1708   }
1709 
1710   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1711     hiddenMetadataUri = _hiddenMetadataUri;
1712   }
1713 
1714   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1715     uriPrefix = _uriPrefix;
1716   }
1717 
1718   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1719     uriSuffix = _uriSuffix;
1720   }
1721 
1722   function setPaused(bool _state) public onlyOwner {
1723     paused = _state;
1724   }
1725 
1726   function withdraw() public onlyOwner {
1727     // This will transfer the remaining contract balance to the owner.
1728     // Do not remove this otherwise you will not be able to withdraw the funds.
1729     // =============================================================================
1730     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1731     require(os);
1732     // =============================================================================
1733   }
1734 
1735   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1736     for (uint256 i = 0; i < _mintAmount; i++) {
1737       supply.increment();
1738       _safeMint(_receiver, supply.current());
1739     }
1740   }
1741 
1742   function _baseURI() internal view virtual override returns (string memory) {
1743     return uriPrefix;
1744   }
1745 }