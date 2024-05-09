1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.18 <0.9.0;
3 
4 
5 //import "../../utils/Context.sol";
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 //import "@openzeppelin/contracts/utils/Address.sol";
28 /**
29  * @dev Collection of functions related to the address type
30  */
31 library Address {
32     /**
33      * @dev Returns true if `account` is a contract.
34      *
35      * [IMPORTANT]
36      * ====
37      * It is unsafe to assume that an address for which this function returns
38      * false is an externally-owned account (EOA) and not a contract.
39      *
40      * Among others, `isContract` will return false for the following
41      * types of addresses:
42      *
43      *  - an externally-owned account
44      *  - a contract in construction
45      *  - an address where a contract will be created
46      *  - an address where a contract lived, but was destroyed
47      * ====
48      *
49      * [IMPORTANT]
50      * ====
51      * You shouldn't rely on `isContract` to protect against flash loan attacks!
52      *
53      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
54      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
55      * constructor.
56      * ====
57      */
58     function isContract(address account) internal view returns (bool) {
59         // This method relies on extcodesize/address.code.length, which returns 0
60         // for contracts in construction, since the code is only stored at the end
61         // of the constructor execution.
62 
63         return account.code.length > 0;
64     }
65 
66     /**
67      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
68      * `recipient`, forwarding all available gas and reverting on errors.
69      *
70      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
71      * of certain opcodes, possibly making contracts go over the 2300 gas limit
72      * imposed by `transfer`, making them unable to receive funds via
73      * `transfer`. {sendValue} removes this limitation.
74      *
75      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
76      *
77      * IMPORTANT: because control is transferred to `recipient`, care must be
78      * taken to not create reentrancy vulnerabilities. Consider using
79      * {ReentrancyGuard} or the
80      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
81      */
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         (bool success, ) = recipient.call{value: amount}("");
86         require(success, "Address: unable to send value, recipient may have reverted");
87     }
88 
89     /**
90      * @dev Performs a Solidity function call using a low level `call`. A
91      * plain `call` is an unsafe replacement for a function call: use this
92      * function instead.
93      *
94      * If `target` reverts with a revert reason, it is bubbled up by this
95      * function (like regular Solidity function calls).
96      *
97      * Returns the raw returned data. To convert to the expected return value,
98      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
99      *
100      * Requirements:
101      *
102      * - `target` must be a contract.
103      * - calling `target` with `data` must not revert.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
113      * `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCall(
118         address target,
119         bytes memory data,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but also transferring `value` wei to `target`.
128      *
129      * Requirements:
130      *
131      * - the calling contract must have an ETH balance of at least `value`.
132      * - the called Solidity function must be `payable`.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value
140     ) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
146      * with `errorMessage` as a fallback revert reason when `target` reverts.
147      *
148      * _Available since v3.1._
149      */
150     function functionCallWithValue(
151         address target,
152         bytes memory data,
153         uint256 value,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         require(address(this).balance >= value, "Address: insufficient balance for call");
157         (bool success, bytes memory returndata) = target.call{value: value}(data);
158         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
168         return functionStaticCall(target, data, "Address: low-level static call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
173      * but performing a static call.
174      *
175      * _Available since v3.3._
176      */
177     function functionStaticCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal view returns (bytes memory) {
182         (bool success, bytes memory returndata) = target.staticcall(data);
183         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
198      * but performing a delegate call.
199      *
200      * _Available since v3.4._
201      */
202     function functionDelegateCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
213      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
214      *
215      * _Available since v4.8._
216      */
217     function verifyCallResultFromTarget(
218         address target,
219         bool success,
220         bytes memory returndata,
221         string memory errorMessage
222     ) internal view returns (bytes memory) {
223         if (success) {
224             if (returndata.length == 0) {
225                 // only check isContract if the call was successful and the return data is empty
226                 // otherwise we already know that it was a contract
227                 require(isContract(target), "Address: call to non-contract");
228             }
229             return returndata;
230         } else {
231             _revert(returndata, errorMessage);
232         }
233     }
234 
235     /**
236      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
237      * revert reason or using the provided one.
238      *
239      * _Available since v4.3._
240      */
241     function verifyCallResult(
242         bool success,
243         bytes memory returndata,
244         string memory errorMessage
245     ) internal pure returns (bytes memory) {
246         if (success) {
247             return returndata;
248         } else {
249             _revert(returndata, errorMessage);
250         }
251     }
252 
253     function _revert(bytes memory returndata, string memory errorMessage) private pure {
254         // Look for revert reason and bubble it up if present
255         if (returndata.length > 0) {
256             // The easiest way to bubble the revert reason is using memory via assembly
257             /// @solidity memory-safe-assembly
258             assembly {
259                 let returndata_size := mload(returndata)
260                 revert(add(32, returndata), returndata_size)
261             }
262         } else {
263             revert(errorMessage);
264         }
265     }
266 }
267 
268 
269 //import "./math/Math.sol";
270 /**
271  * @dev Standard math utilities missing in the Solidity language.
272  */
273 library Math {
274     enum Rounding {
275         Down, // Toward negative infinity
276         Up, // Toward infinity
277         Zero // Toward zero
278     }
279 
280     /**
281      * @dev Returns the largest of two numbers.
282      */
283     function max(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a > b ? a : b;
285     }
286 
287     /**
288      * @dev Returns the smallest of two numbers.
289      */
290     function min(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a < b ? a : b;
292     }
293 
294     /**
295      * @dev Returns the average of two numbers. The result is rounded towards
296      * zero.
297      */
298     function average(uint256 a, uint256 b) internal pure returns (uint256) {
299         // (a + b) / 2 can overflow.
300         return (a & b) + (a ^ b) / 2;
301     }
302 
303     /**
304      * @dev Returns the ceiling of the division of two numbers.
305      *
306      * This differs from standard division with `/` in that it rounds up instead
307      * of rounding down.
308      */
309     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
310         // (a + b - 1) / b can overflow on addition, so we distribute.
311         return a == 0 ? 0 : (a - 1) / b + 1;
312     }
313 
314     /**
315      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
316      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
317      * with further edits by Uniswap Labs also under MIT license.
318      */
319     function mulDiv(
320         uint256 x,
321         uint256 y,
322         uint256 denominator
323     ) internal pure returns (uint256 result) {
324         unchecked {
325             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
326             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
327             // variables such that product = prod1 * 2^256 + prod0.
328             uint256 prod0; // Least significant 256 bits of the product
329             uint256 prod1; // Most significant 256 bits of the product
330             assembly {
331                 let mm := mulmod(x, y, not(0))
332                 prod0 := mul(x, y)
333                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
334             }
335 
336             // Handle non-overflow cases, 256 by 256 division.
337             if (prod1 == 0) {
338                 return prod0 / denominator;
339             }
340 
341             // Make sure the result is less than 2^256. Also prevents denominator == 0.
342             require(denominator > prod1);
343 
344             ///////////////////////////////////////////////
345             // 512 by 256 division.
346             ///////////////////////////////////////////////
347 
348             // Make division exact by subtracting the remainder from [prod1 prod0].
349             uint256 remainder;
350             assembly {
351                 // Compute remainder using mulmod.
352                 remainder := mulmod(x, y, denominator)
353 
354                 // Subtract 256 bit number from 512 bit number.
355                 prod1 := sub(prod1, gt(remainder, prod0))
356                 prod0 := sub(prod0, remainder)
357             }
358 
359             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
360             // See https://cs.stackexchange.com/q/138556/92363.
361 
362             // Does not overflow because the denominator cannot be zero at this stage in the function.
363             uint256 twos = denominator & (~denominator + 1);
364             assembly {
365                 // Divide denominator by twos.
366                 denominator := div(denominator, twos)
367 
368                 // Divide [prod1 prod0] by twos.
369                 prod0 := div(prod0, twos)
370 
371                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
372                 twos := add(div(sub(0, twos), twos), 1)
373             }
374 
375             // Shift in bits from prod1 into prod0.
376             prod0 |= prod1 * twos;
377 
378             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
379             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
380             // four bits. That is, denominator * inv = 1 mod 2^4.
381             uint256 inverse = (3 * denominator) ^ 2;
382 
383             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
384             // in modular arithmetic, doubling the correct bits in each step.
385             inverse *= 2 - denominator * inverse; // inverse mod 2^8
386             inverse *= 2 - denominator * inverse; // inverse mod 2^16
387             inverse *= 2 - denominator * inverse; // inverse mod 2^32
388             inverse *= 2 - denominator * inverse; // inverse mod 2^64
389             inverse *= 2 - denominator * inverse; // inverse mod 2^128
390             inverse *= 2 - denominator * inverse; // inverse mod 2^256
391 
392             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
393             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
394             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
395             // is no longer required.
396             result = prod0 * inverse;
397             return result;
398         }
399     }
400 
401     /**
402      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
403      */
404     function mulDiv(
405         uint256 x,
406         uint256 y,
407         uint256 denominator,
408         Rounding rounding
409     ) internal pure returns (uint256) {
410         uint256 result = mulDiv(x, y, denominator);
411         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
412             result += 1;
413         }
414         return result;
415     }
416 
417     /**
418      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
419      *
420      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
421      */
422     function sqrt(uint256 a) internal pure returns (uint256) {
423         if (a == 0) {
424             return 0;
425         }
426 
427         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
428         //
429         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
430         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
431         //
432         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
433         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
434         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
435         //
436         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
437         uint256 result = 1 << (log2(a) >> 1);
438 
439         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
440         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
441         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
442         // into the expected uint128 result.
443         unchecked {
444             result = (result + a / result) >> 1;
445             result = (result + a / result) >> 1;
446             result = (result + a / result) >> 1;
447             result = (result + a / result) >> 1;
448             result = (result + a / result) >> 1;
449             result = (result + a / result) >> 1;
450             result = (result + a / result) >> 1;
451             return min(result, a / result);
452         }
453     }
454 
455     /**
456      * @notice Calculates sqrt(a), following the selected rounding direction.
457      */
458     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
459         unchecked {
460             uint256 result = sqrt(a);
461             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
462         }
463     }
464 
465     /**
466      * @dev Return the log in base 2, rounded down, of a positive value.
467      * Returns 0 if given 0.
468      */
469     function log2(uint256 value) internal pure returns (uint256) {
470         uint256 result = 0;
471         unchecked {
472             if (value >> 128 > 0) {
473                 value >>= 128;
474                 result += 128;
475             }
476             if (value >> 64 > 0) {
477                 value >>= 64;
478                 result += 64;
479             }
480             if (value >> 32 > 0) {
481                 value >>= 32;
482                 result += 32;
483             }
484             if (value >> 16 > 0) {
485                 value >>= 16;
486                 result += 16;
487             }
488             if (value >> 8 > 0) {
489                 value >>= 8;
490                 result += 8;
491             }
492             if (value >> 4 > 0) {
493                 value >>= 4;
494                 result += 4;
495             }
496             if (value >> 2 > 0) {
497                 value >>= 2;
498                 result += 2;
499             }
500             if (value >> 1 > 0) {
501                 result += 1;
502             }
503         }
504         return result;
505     }
506 
507     /**
508      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
509      * Returns 0 if given 0.
510      */
511     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
512         unchecked {
513             uint256 result = log2(value);
514             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
515         }
516     }
517 
518     /**
519      * @dev Return the log in base 10, rounded down, of a positive value.
520      * Returns 0 if given 0.
521      */
522     function log10(uint256 value) internal pure returns (uint256) {
523         uint256 result = 0;
524         unchecked {
525             if (value >= 10**64) {
526                 value /= 10**64;
527                 result += 64;
528             }
529             if (value >= 10**32) {
530                 value /= 10**32;
531                 result += 32;
532             }
533             if (value >= 10**16) {
534                 value /= 10**16;
535                 result += 16;
536             }
537             if (value >= 10**8) {
538                 value /= 10**8;
539                 result += 8;
540             }
541             if (value >= 10**4) {
542                 value /= 10**4;
543                 result += 4;
544             }
545             if (value >= 10**2) {
546                 value /= 10**2;
547                 result += 2;
548             }
549             if (value >= 10**1) {
550                 result += 1;
551             }
552         }
553         return result;
554     }
555 
556     /**
557      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
558      * Returns 0 if given 0.
559      */
560     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
561         unchecked {
562             uint256 result = log10(value);
563             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
564         }
565     }
566 
567     /**
568      * @dev Return the log in base 256, rounded down, of a positive value.
569      * Returns 0 if given 0.
570      *
571      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
572      */
573     function log256(uint256 value) internal pure returns (uint256) {
574         uint256 result = 0;
575         unchecked {
576             if (value >> 128 > 0) {
577                 value >>= 128;
578                 result += 16;
579             }
580             if (value >> 64 > 0) {
581                 value >>= 64;
582                 result += 8;
583             }
584             if (value >> 32 > 0) {
585                 value >>= 32;
586                 result += 4;
587             }
588             if (value >> 16 > 0) {
589                 value >>= 16;
590                 result += 2;
591             }
592             if (value >> 8 > 0) {
593                 result += 1;
594             }
595         }
596         return result;
597     }
598 
599     /**
600      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
601      * Returns 0 if given 0.
602      */
603     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
604         unchecked {
605             uint256 result = log256(value);
606             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
607         }
608     }
609 }
610 
611 
612 //import "@openzeppelin/contracts/utils/Strings.sol";
613 /**
614  * @dev String operations.
615  */
616 library Strings {
617     bytes16 private constant _SYMBOLS = "0123456789abcdef";
618     uint8 private constant _ADDRESS_LENGTH = 20;
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
622      */
623     function toString(uint256 value) internal pure returns (string memory) {
624         unchecked {
625             uint256 length = Math.log10(value) + 1;
626             string memory buffer = new string(length);
627             uint256 ptr;
628             /// @solidity memory-safe-assembly
629             assembly {
630                 ptr := add(buffer, add(32, length))
631             }
632             while (true) {
633                 ptr--;
634                 /// @solidity memory-safe-assembly
635                 assembly {
636                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
637                 }
638                 value /= 10;
639                 if (value == 0) break;
640             }
641             return buffer;
642         }
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
647      */
648     function toHexString(uint256 value) internal pure returns (string memory) {
649         unchecked {
650             return toHexString(value, Math.log256(value) + 1);
651         }
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
656      */
657     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
658         bytes memory buffer = new bytes(2 * length + 2);
659         buffer[0] = "0";
660         buffer[1] = "x";
661         for (uint256 i = 2 * length + 1; i > 1; --i) {
662             buffer[i] = _SYMBOLS[value & 0xf];
663             value >>= 4;
664         }
665         require(value == 0, "Strings: hex length insufficient");
666         return string(buffer);
667     }
668 
669     /**
670      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
671      */
672     function toHexString(address addr) internal pure returns (string memory) {
673         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
674     }
675 }
676 
677 
678 //import "@openzeppelin/contracts/access/Ownable.sol";
679 /**
680  * @dev Contract module which provides a basic access control mechanism, where
681  * there is an account (an owner) that can be granted exclusive access to
682  * specific functions.
683  *
684  * By default, the owner account will be the one that deploys the contract. This
685  * can later be changed with {transferOwnership}.
686  *
687  * This module is used through inheritance. It will make available the modifier
688  * `onlyOwner`, which can be applied to your functions to restrict their use to
689  * the owner.
690  */
691 abstract contract Ownable is Context {
692     address private _owner;
693 
694     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
695 
696     /**
697      * @dev Initializes the contract setting the deployer as the initial owner.
698      */
699     constructor() {
700         _transferOwnership(_msgSender());
701     }
702 
703     /**
704      * @dev Throws if called by any account other than the owner.
705      */
706     modifier onlyOwner() {
707         _checkOwner();
708         _;
709     }
710 
711     /**
712      * @dev Returns the address of the current owner.
713      */
714     function owner() public view virtual returns (address) {
715         return _owner;
716     }
717 
718     /**
719      * @dev Throws if the sender is not the owner.
720      */
721     function _checkOwner() internal view virtual {
722         require(owner() == _msgSender(), "Ownable: caller is not the owner");
723     }
724 
725     /**
726      * @dev Leaves the contract without owner. It will not be possible to call
727      * `onlyOwner` functions anymore. Can only be called by the current owner.
728      *
729      * NOTE: Renouncing ownership will leave the contract without an owner,
730      * thereby removing any functionality that is only available to the owner.
731      */
732     function renounceOwnership() public virtual onlyOwner {
733         _transferOwnership(address(0));
734     }
735 
736     /**
737      * @dev Transfers ownership of the contract to a new account (`newOwner`).
738      * Can only be called by the current owner.
739      */
740     function transferOwnership(address newOwner) public virtual onlyOwner {
741         require(newOwner != address(0), "Ownable: new owner is the zero address");
742         _transferOwnership(newOwner);
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
747      * Internal function without access restriction.
748      */
749     function _transferOwnership(address newOwner) internal virtual {
750         address oldOwner = _owner;
751         _owner = newOwner;
752         emit OwnershipTransferred(oldOwner, newOwner);
753     }
754 }
755 
756 
757 //import "../utils/introspection/IERC165.sol";
758 /**
759  * @dev Interface of the ERC165 standard, as defined in the
760  * https://eips.ethereum.org/EIPS/eip-165[EIP].
761  *
762  * Implementers can declare support of contract interfaces, which can then be
763  * queried by others ({ERC165Checker}).
764  *
765  * For an implementation, see {ERC165}.
766  */
767 interface IERC165 {
768     /**
769      * @dev Returns true if this contract implements the interface defined by
770      * `interfaceId`. See the corresponding
771      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
772      * to learn more about how these ids are created.
773      *
774      * This function call must use less than 30 000 gas.
775      */
776     function supportsInterface(bytes4 interfaceId) external view returns (bool);
777 }
778 
779 
780 //import "../../utils/introspection/ERC165.sol";
781 /**
782  * @dev Implementation of the {IERC165} interface.
783  *
784  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
785  * for the additional interface id that will be supported. For example:
786  *
787  * ```solidity
788  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
789  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
790  * }
791  * ```
792  *
793  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
794  */
795 abstract contract ERC165 is IERC165 {
796     /**
797      * @dev See {IERC165-supportsInterface}.
798      */
799     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
800         return interfaceId == type(IERC165).interfaceId;
801     }
802 }
803 
804 
805 //import "./IERC721.sol";
806 /**
807  * @dev Required interface of an ERC721 compliant contract.
808  */
809 interface IERC721 is IERC165 {
810     /**
811      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
812      */
813     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
814 
815     /**
816      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
817      */
818     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
819 
820     /**
821      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
822      */
823     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
824 
825     /**
826      * @dev Returns the number of tokens in ``owner``'s account.
827      */
828     function balanceOf(address owner) external view returns (uint256 balance);
829 
830     /**
831      * @dev Returns the owner of the `tokenId` token.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function ownerOf(uint256 tokenId) external view returns (address owner);
838 
839     /**
840      * @dev Safely transfers `tokenId` token from `from` to `to`.
841      *
842      * Requirements:
843      *
844      * - `from` cannot be the zero address.
845      * - `to` cannot be the zero address.
846      * - `tokenId` token must exist and be owned by `from`.
847      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId,
856         bytes calldata data
857     ) external;
858 
859     /**
860      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
861      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
862      *
863      * Requirements:
864      *
865      * - `from` cannot be the zero address.
866      * - `to` cannot be the zero address.
867      * - `tokenId` token must exist and be owned by `from`.
868      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
869      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
870      *
871      * Emits a {Transfer} event.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) external;
878 
879     /**
880      * @dev Transfers `tokenId` token from `from` to `to`.
881      *
882      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
883      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
884      * understand this adds an external call which potentially creates a reentrancy vulnerability.
885      *
886      * Requirements:
887      *
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must be owned by `from`.
891      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
892      *
893      * Emits a {Transfer} event.
894      */
895     function transferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) external;
900 
901     /**
902      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
903      * The approval is cleared when the token is transferred.
904      *
905      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
906      *
907      * Requirements:
908      *
909      * - The caller must own the token or be an approved operator.
910      * - `tokenId` must exist.
911      *
912      * Emits an {Approval} event.
913      */
914     function approve(address to, uint256 tokenId) external;
915 
916     /**
917      * @dev Approve or remove `operator` as an operator for the caller.
918      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
919      *
920      * Requirements:
921      *
922      * - The `operator` cannot be the caller.
923      *
924      * Emits an {ApprovalForAll} event.
925      */
926     function setApprovalForAll(address operator, bool _approved) external;
927 
928     /**
929      * @dev Returns the account approved for `tokenId` token.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function getApproved(uint256 tokenId) external view returns (address operator);
936 
937     /**
938      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
939      *
940      * See {setApprovalForAll}
941      */
942     function isApprovedForAll(address owner, address operator) external view returns (bool);
943 }
944 
945 
946 //import "./IERC721Receiver.sol";
947 /**
948  * @title ERC721 token receiver interface
949  * @dev Interface for any contract that wants to support safeTransfers
950  * from ERC721 asset contracts.
951  */
952 interface IERC721Receiver {
953     /**
954      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
955      * by `operator` from `from`, this function is called.
956      *
957      * It must return its Solidity selector to confirm the token transfer.
958      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
959      *
960      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
961      */
962     function onERC721Received(
963         address operator,
964         address from,
965         uint256 tokenId,
966         bytes calldata data
967     ) external returns (bytes4);
968 }
969 
970 
971 //import "./extensions/IERC721Metadata.sol";
972 /**
973  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
974  * @dev See https://eips.ethereum.org/EIPS/eip-721
975  */
976 interface IERC721Metadata is IERC721 {
977     /**
978      * @dev Returns the token collection name.
979      */
980     function name() external view returns (string memory);
981 
982     /**
983      * @dev Returns the token collection symbol.
984      */
985     function symbol() external view returns (string memory);
986 
987     /**
988      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
989      */
990     function tokenURI(uint256 tokenId) external view returns (string memory);
991 }
992 
993 
994 //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
995 /**
996  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
997  * the Metadata extension, but not including the Enumerable extension, which is available separately as
998  * {ERC721Enumerable}.
999  */
1000 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1001     using Address for address;
1002     using Strings for uint256;
1003 
1004     // Token name
1005     string private _name;
1006 
1007     // Token symbol
1008     string private _symbol;
1009 
1010     // Mapping from token ID to owner address
1011     mapping(uint256 => address) private _owners;
1012 
1013     // Mapping owner address to token count
1014     mapping(address => uint256) private _balances;
1015 
1016     // Mapping from token ID to approved address
1017     mapping(uint256 => address) private _tokenApprovals;
1018 
1019     // Mapping from owner to operator approvals
1020     mapping(address => mapping(address => bool)) private _operatorApprovals;
1021 
1022     /**
1023      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1024      */
1025     constructor(string memory name_, string memory symbol_) {
1026         _name = name_;
1027         _symbol = symbol_;
1028     }
1029 
1030     /**
1031      * @dev See {IERC165-supportsInterface}.
1032      */
1033     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1034         return
1035             interfaceId == type(IERC721).interfaceId ||
1036             interfaceId == type(IERC721Metadata).interfaceId ||
1037             super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-balanceOf}.
1042      */
1043     function balanceOf(address owner) public view virtual override returns (uint256) {
1044         require(owner != address(0), "ERC721: address zero is not a valid owner");
1045         return _balances[owner];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-ownerOf}.
1050      */
1051     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1052         address owner = _ownerOf(tokenId);
1053         require(owner != address(0), "ERC721: invalid token ID");
1054         return owner;
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Metadata-name}.
1059      */
1060     function name() public view virtual override returns (string memory) {
1061         return _name;
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Metadata-symbol}.
1066      */
1067     function symbol() public view virtual override returns (string memory) {
1068         return _symbol;
1069     }
1070 
1071     /**
1072      * @dev See {IERC721Metadata-tokenURI}.
1073      */
1074     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1075         _requireMinted(tokenId);
1076 
1077         string memory baseURI = _baseURI();
1078         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1079     }
1080 
1081     /**
1082      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1083      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1084      * by default, can be overridden in child contracts.
1085      */
1086     function _baseURI() internal view virtual returns (string memory) {
1087         return "";
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-approve}.
1092      */
1093     function approve(address to, uint256 tokenId) public virtual override {
1094         address owner = ERC721.ownerOf(tokenId);
1095         require(to != owner, "ERC721: approval to current owner");
1096 
1097         require(
1098             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1099             "ERC721: approve caller is not token owner or approved for all"
1100         );
1101 
1102         _approve(to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-getApproved}.
1107      */
1108     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1109         _requireMinted(tokenId);
1110 
1111         return _tokenApprovals[tokenId];
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-setApprovalForAll}.
1116      */
1117     function setApprovalForAll(address operator, bool approved) public virtual override {
1118         _setApprovalForAll(_msgSender(), operator, approved);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-isApprovedForAll}.
1123      */
1124     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1125         return _operatorApprovals[owner][operator];
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-transferFrom}.
1130      */
1131     function transferFrom(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) public virtual override {
1136         //solhint-disable-next-line max-line-length
1137         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1138 
1139         _transfer(from, to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-safeTransferFrom}.
1144      */
1145     function safeTransferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) public virtual override {
1150         safeTransferFrom(from, to, tokenId, "");
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-safeTransferFrom}.
1155      */
1156     function safeTransferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes memory data
1161     ) public virtual override {
1162         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1163         _safeTransfer(from, to, tokenId, data);
1164     }
1165 
1166     /**
1167      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1168      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1169      *
1170      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1171      *
1172      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1173      * implement alternative mechanisms to perform token transfer, such as signature-based.
1174      *
1175      * Requirements:
1176      *
1177      * - `from` cannot be the zero address.
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must exist and be owned by `from`.
1180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _safeTransfer(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory data
1189     ) internal virtual {
1190         _transfer(from, to, tokenId);
1191         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1192     }
1193 
1194     /**
1195      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1196      */
1197     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1198         return _owners[tokenId];
1199     }
1200 
1201     /**
1202      * @dev Returns whether `tokenId` exists.
1203      *
1204      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1205      *
1206      * Tokens start existing when they are minted (`_mint`),
1207      * and stop existing when they are burned (`_burn`).
1208      */
1209     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1210         return _ownerOf(tokenId) != address(0);
1211     }
1212 
1213     /**
1214      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      */
1220     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1221         address owner = ERC721.ownerOf(tokenId);
1222         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1223     }
1224 
1225     /**
1226      * @dev Safely mints `tokenId` and transfers it to `to`.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must not exist.
1231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _safeMint(address to, uint256 tokenId) internal virtual {
1236         _safeMint(to, tokenId, "");
1237     }
1238 
1239     /**
1240      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1241      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1242      */
1243     function _safeMint(
1244         address to,
1245         uint256 tokenId,
1246         bytes memory data
1247     ) internal virtual {
1248         _mint(to, tokenId);
1249         require(
1250             _checkOnERC721Received(address(0), to, tokenId, data),
1251             "ERC721: transfer to non ERC721Receiver implementer"
1252         );
1253     }
1254 
1255     /**
1256      * @dev Mints `tokenId` and transfers it to `to`.
1257      *
1258      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1259      *
1260      * Requirements:
1261      *
1262      * - `tokenId` must not exist.
1263      * - `to` cannot be the zero address.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _mint(address to, uint256 tokenId) internal virtual {
1268         require(to != address(0), "ERC721: mint to the zero address");
1269         require(!_exists(tokenId), "ERC721: token already minted");
1270 
1271         _beforeTokenTransfer(address(0), to, tokenId, 1);
1272 
1273         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1274         require(!_exists(tokenId), "ERC721: token already minted");
1275 
1276         unchecked {
1277             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1278             // Given that tokens are minted one by one, it is impossible in practice that
1279             // this ever happens. Might change if we allow batch minting.
1280             // The ERC fails to describe this case.
1281             _balances[to] += 1;
1282         }
1283 
1284         _owners[tokenId] = to;
1285 
1286         emit Transfer(address(0), to, tokenId);
1287 
1288         _afterTokenTransfer(address(0), to, tokenId, 1);
1289     }
1290 
1291     /**
1292      * @dev Destroys `tokenId`.
1293      * The approval is cleared when the token is burned.
1294      * This is an internal function that does not check if the sender is authorized to operate on the token.
1295      *
1296      * Requirements:
1297      *
1298      * - `tokenId` must exist.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _burn(uint256 tokenId) internal virtual {
1303         address owner = ERC721.ownerOf(tokenId);
1304 
1305         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1306 
1307         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1308         owner = ERC721.ownerOf(tokenId);
1309 
1310         // Clear approvals
1311         delete _tokenApprovals[tokenId];
1312 
1313         unchecked {
1314             // Cannot overflow, as that would require more tokens to be burned/transferred
1315             // out than the owner initially received through minting and transferring in.
1316             _balances[owner] -= 1;
1317         }
1318         delete _owners[tokenId];
1319 
1320         emit Transfer(owner, address(0), tokenId);
1321 
1322         _afterTokenTransfer(owner, address(0), tokenId, 1);
1323     }
1324 
1325     /**
1326      * @dev Transfers `tokenId` from `from` to `to`.
1327      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1328      *
1329      * Requirements:
1330      *
1331      * - `to` cannot be the zero address.
1332      * - `tokenId` token must be owned by `from`.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function _transfer(
1337         address from,
1338         address to,
1339         uint256 tokenId
1340     ) internal virtual {
1341         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1342         require(to != address(0), "ERC721: transfer to the zero address");
1343 
1344         _beforeTokenTransfer(from, to, tokenId, 1);
1345 
1346         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1347         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1348 
1349         // Clear approvals from the previous owner
1350         delete _tokenApprovals[tokenId];
1351 
1352         unchecked {
1353             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1354             // `from`'s balance is the number of token held, which is at least one before the current
1355             // transfer.
1356             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1357             // all 2**256 token ids to be minted, which in practice is impossible.
1358             _balances[from] -= 1;
1359             _balances[to] += 1;
1360         }
1361         _owners[tokenId] = to;
1362 
1363         emit Transfer(from, to, tokenId);
1364 
1365         _afterTokenTransfer(from, to, tokenId, 1);
1366     }
1367 
1368     /**
1369      * @dev Approve `to` to operate on `tokenId`
1370      *
1371      * Emits an {Approval} event.
1372      */
1373     function _approve(address to, uint256 tokenId) internal virtual {
1374         _tokenApprovals[tokenId] = to;
1375         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1376     }
1377 
1378     /**
1379      * @dev Approve `operator` to operate on all of `owner` tokens
1380      *
1381      * Emits an {ApprovalForAll} event.
1382      */
1383     function _setApprovalForAll(
1384         address owner,
1385         address operator,
1386         bool approved
1387     ) internal virtual {
1388         require(owner != operator, "ERC721: approve to caller");
1389         _operatorApprovals[owner][operator] = approved;
1390         emit ApprovalForAll(owner, operator, approved);
1391     }
1392 
1393     /**
1394      * @dev Reverts if the `tokenId` has not been minted yet.
1395      */
1396     function _requireMinted(uint256 tokenId) internal view virtual {
1397         require(_exists(tokenId), "ERC721: invalid token ID");
1398     }
1399 
1400     /**
1401      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1402      * The call is not executed if the target address is not a contract.
1403      *
1404      * @param from address representing the previous owner of the given token ID
1405      * @param to target address that will receive the tokens
1406      * @param tokenId uint256 ID of the token to be transferred
1407      * @param data bytes optional data to send along with the call
1408      * @return bool whether the call correctly returned the expected magic value
1409      */
1410     function _checkOnERC721Received(
1411         address from,
1412         address to,
1413         uint256 tokenId,
1414         bytes memory data
1415     ) private returns (bool) {
1416         if (to.isContract()) {
1417             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1418                 return retval == IERC721Receiver.onERC721Received.selector;
1419             } catch (bytes memory reason) {
1420                 if (reason.length == 0) {
1421                     revert("ERC721: transfer to non ERC721Receiver implementer");
1422                 } else {
1423                     /// @solidity memory-safe-assembly
1424                     assembly {
1425                         revert(add(32, reason), mload(reason))
1426                     }
1427                 }
1428             }
1429         } else {
1430             return true;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1436      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1437      *
1438      * Calling conditions:
1439      *
1440      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1441      * - When `from` is zero, the tokens will be minted for `to`.
1442      * - When `to` is zero, ``from``'s tokens will be burned.
1443      * - `from` and `to` are never both zero.
1444      * - `batchSize` is non-zero.
1445      *
1446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1447      */
1448     function _beforeTokenTransfer(
1449         address from,
1450         address to,
1451         uint256, /* firstTokenId */
1452         uint256 batchSize
1453     ) internal virtual {
1454         if (batchSize > 1) {
1455             if (from != address(0)) {
1456                 _balances[from] -= batchSize;
1457             }
1458             if (to != address(0)) {
1459                 _balances[to] += batchSize;
1460             }
1461         }
1462     }
1463 
1464     /**
1465      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1466      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1471      * - When `from` is zero, the tokens were minted for `to`.
1472      * - When `to` is zero, ``from``'s tokens were burned.
1473      * - `from` and `to` are never both zero.
1474      * - `batchSize` is non-zero.
1475      *
1476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1477      */
1478     function _afterTokenTransfer(
1479         address from,
1480         address to,
1481         uint256 firstTokenId,
1482         uint256 batchSize
1483     ) internal virtual {}
1484 }
1485 
1486 
1487 //import "../../interfaces/IERC2981.sol";
1488 /**
1489  * @dev Interface for the NFT Royalty Standard.
1490  *
1491  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1492  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1493  *
1494  * _Available since v4.5._
1495  */
1496 interface IERC2981 is IERC165 {
1497     /**
1498      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1499      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1500      */
1501     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1502         external
1503         view
1504         returns (address receiver, uint256 royaltyAmount);
1505 }
1506 
1507 
1508 //import "@openzeppelin/contracts/token/common/ERC2981.sol";
1509 /**
1510  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1511  *
1512  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1513  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1514  *
1515  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1516  * fee is specified in basis points by default.
1517  *
1518  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1519  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1520  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1521  *
1522  * _Available since v4.5._
1523  */
1524 abstract contract ERC2981 is IERC2981, ERC165 {
1525     struct RoyaltyInfo {
1526         address receiver;
1527         uint96 royaltyFraction;
1528     }
1529 
1530     RoyaltyInfo private _defaultRoyaltyInfo;
1531     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1532 
1533     /**
1534      * @dev See {IERC165-supportsInterface}.
1535      */
1536     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1537         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1538     }
1539 
1540     /**
1541      * @inheritdoc IERC2981
1542      */
1543     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1544         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1545 
1546         if (royalty.receiver == address(0)) {
1547             royalty = _defaultRoyaltyInfo;
1548         }
1549 
1550         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1551 
1552         return (royalty.receiver, royaltyAmount);
1553     }
1554 
1555     /**
1556      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1557      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1558      * override.
1559      */
1560     function _feeDenominator() internal pure virtual returns (uint96) {
1561         return 10000;
1562     }
1563 
1564     /**
1565      * @dev Sets the royalty information that all ids in this contract will default to.
1566      *
1567      * Requirements:
1568      *
1569      * - `receiver` cannot be the zero address.
1570      * - `feeNumerator` cannot be greater than the fee denominator.
1571      */
1572     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1573         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1574         require(receiver != address(0), "ERC2981: invalid receiver");
1575 
1576         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1577     }
1578 
1579     /**
1580      * @dev Removes default royalty information.
1581      */
1582     function _deleteDefaultRoyalty() internal virtual {
1583         delete _defaultRoyaltyInfo;
1584     }
1585 
1586     /**
1587      * @dev Sets the royalty information for a specific token id, overriding the global default.
1588      *
1589      * Requirements:
1590      *
1591      * - `receiver` cannot be the zero address.
1592      * - `feeNumerator` cannot be greater than the fee denominator.
1593      */
1594     function _setTokenRoyalty(
1595         uint256 tokenId,
1596         address receiver,
1597         uint96 feeNumerator
1598     ) internal virtual {
1599         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1600         require(receiver != address(0), "ERC2981: Invalid parameters");
1601 
1602         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1603     }
1604 
1605     /**
1606      * @dev Resets royalty information for the token id back to the global default.
1607      */
1608     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1609         delete _tokenRoyaltyInfo[tokenId];
1610     }
1611 }
1612 
1613 
1614 //import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
1615 /**
1616  * @dev Contract module that helps prevent reentrant calls to a function.
1617  *
1618  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1619  * available, which can be applied to functions to make sure there are no nested
1620  * (reentrant) calls to them.
1621  *
1622  * Note that because there is a single `nonReentrant` guard, functions marked as
1623  * `nonReentrant` may not call one another. This can be worked around by making
1624  * those functions `private`, and then adding `external` `nonReentrant` entry
1625  * points to them.
1626  *
1627  * TIP: If you would like to learn more about reentrancy and alternative ways
1628  * to protect against it, check out our blog post
1629  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1630  */
1631 abstract contract ReentrancyGuard {
1632     // Booleans are more expensive than uint256 or any type that takes up a full
1633     // word because each write operation emits an extra SLOAD to first read the
1634     // slot's contents, replace the bits taken up by the boolean, and then write
1635     // back. This is the compiler's defense against contract upgrades and
1636     // pointer aliasing, and it cannot be disabled.
1637 
1638     // The values being non-zero value makes deployment a bit more expensive,
1639     // but in exchange the refund on every call to nonReentrant will be lower in
1640     // amount. Since refunds are capped to a percentage of the total
1641     // transaction's gas, it is best to keep them low in cases like this one, to
1642     // increase the likelihood of the full refund coming into effect.
1643     uint256 private constant _NOT_ENTERED = 1;
1644     uint256 private constant _ENTERED = 2;
1645 
1646     uint256 private _status;
1647 
1648     constructor() {
1649         _status = _NOT_ENTERED;
1650     }
1651 
1652     /**
1653      * @dev Prevents a contract from calling itself, directly or indirectly.
1654      * Calling a `nonReentrant` function from another `nonReentrant`
1655      * function is not supported. It is possible to prevent this from happening
1656      * by making the `nonReentrant` function external, and making it call a
1657      * `private` function that does the actual work.
1658      */
1659     modifier nonReentrant() {
1660         _nonReentrantBefore();
1661         _;
1662         _nonReentrantAfter();
1663     }
1664 
1665     function _nonReentrantBefore() private {
1666         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1667         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1668 
1669         // Any calls to nonReentrant after this point will fail
1670         _status = _ENTERED;
1671     }
1672 
1673     function _nonReentrantAfter() private {
1674         // By storing the original value once again, a refund is triggered (see
1675         // https://eips.ethereum.org/EIPS/eip-2200)
1676         _status = _NOT_ENTERED;
1677     }
1678 }
1679 
1680 
1681 //import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
1682 /**
1683  * @dev These functions deal with verification of Merkle Tree proofs.
1684  *
1685  * The tree and the proofs can be generated using our
1686  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1687  * You will find a quickstart guide in the readme.
1688  *
1689  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1690  * hashing, or use a hash function other than keccak256 for hashing leaves.
1691  * This is because the concatenation of a sorted pair of internal nodes in
1692  * the merkle tree could be reinterpreted as a leaf value.
1693  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1694  * against this attack out of the box.
1695  */
1696 library MerkleProof {
1697     /**
1698      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1699      * defined by `root`. For this, a `proof` must be provided, containing
1700      * sibling hashes on the branch from the leaf to the root of the tree. Each
1701      * pair of leaves and each pair of pre-images are assumed to be sorted.
1702      */
1703     function verify(
1704         bytes32[] memory proof,
1705         bytes32 root,
1706         bytes32 leaf
1707     ) internal pure returns (bool) {
1708         return processProof(proof, leaf) == root;
1709     }
1710 
1711     /**
1712      * @dev Calldata version of {verify}
1713      *
1714      * _Available since v4.7._
1715      */
1716     function verifyCalldata(
1717         bytes32[] calldata proof,
1718         bytes32 root,
1719         bytes32 leaf
1720     ) internal pure returns (bool) {
1721         return processProofCalldata(proof, leaf) == root;
1722     }
1723 
1724     /**
1725      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1726      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1727      * hash matches the root of the tree. When processing the proof, the pairs
1728      * of leafs & pre-images are assumed to be sorted.
1729      *
1730      * _Available since v4.4._
1731      */
1732     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1733         bytes32 computedHash = leaf;
1734         for (uint256 i = 0; i < proof.length; i++) {
1735             computedHash = _hashPair(computedHash, proof[i]);
1736         }
1737         return computedHash;
1738     }
1739 
1740     /**
1741      * @dev Calldata version of {processProof}
1742      *
1743      * _Available since v4.7._
1744      */
1745     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1746         bytes32 computedHash = leaf;
1747         for (uint256 i = 0; i < proof.length; i++) {
1748             computedHash = _hashPair(computedHash, proof[i]);
1749         }
1750         return computedHash;
1751     }
1752 
1753     /**
1754      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1755      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1756      *
1757      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1758      *
1759      * _Available since v4.7._
1760      */
1761     function multiProofVerify(
1762         bytes32[] memory proof,
1763         bool[] memory proofFlags,
1764         bytes32 root,
1765         bytes32[] memory leaves
1766     ) internal pure returns (bool) {
1767         return processMultiProof(proof, proofFlags, leaves) == root;
1768     }
1769 
1770     /**
1771      * @dev Calldata version of {multiProofVerify}
1772      *
1773      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1774      *
1775      * _Available since v4.7._
1776      */
1777     function multiProofVerifyCalldata(
1778         bytes32[] calldata proof,
1779         bool[] calldata proofFlags,
1780         bytes32 root,
1781         bytes32[] memory leaves
1782     ) internal pure returns (bool) {
1783         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1784     }
1785 
1786     /**
1787      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1788      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1789      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1790      * respectively.
1791      *
1792      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1793      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1794      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1795      *
1796      * _Available since v4.7._
1797      */
1798     function processMultiProof(
1799         bytes32[] memory proof,
1800         bool[] memory proofFlags,
1801         bytes32[] memory leaves
1802     ) internal pure returns (bytes32 merkleRoot) {
1803         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1804         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1805         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1806         // the merkle tree.
1807         uint256 leavesLen = leaves.length;
1808         uint256 totalHashes = proofFlags.length;
1809 
1810         // Check proof validity.
1811         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1812 
1813         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1814         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1815         bytes32[] memory hashes = new bytes32[](totalHashes);
1816         uint256 leafPos = 0;
1817         uint256 hashPos = 0;
1818         uint256 proofPos = 0;
1819         // At each step, we compute the next hash using two values:
1820         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1821         //   get the next hash.
1822         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1823         //   `proof` array.
1824         for (uint256 i = 0; i < totalHashes; i++) {
1825             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1826             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1827             hashes[i] = _hashPair(a, b);
1828         }
1829 
1830         if (totalHashes > 0) {
1831             return hashes[totalHashes - 1];
1832         } else if (leavesLen > 0) {
1833             return leaves[0];
1834         } else {
1835             return proof[0];
1836         }
1837     }
1838 
1839     /**
1840      * @dev Calldata version of {processMultiProof}.
1841      *
1842      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1843      *
1844      * _Available since v4.7._
1845      */
1846     function processMultiProofCalldata(
1847         bytes32[] calldata proof,
1848         bool[] calldata proofFlags,
1849         bytes32[] memory leaves
1850     ) internal pure returns (bytes32 merkleRoot) {
1851         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1852         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1853         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1854         // the merkle tree.
1855         uint256 leavesLen = leaves.length;
1856         uint256 totalHashes = proofFlags.length;
1857 
1858         // Check proof validity.
1859         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1860 
1861         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1862         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1863         bytes32[] memory hashes = new bytes32[](totalHashes);
1864         uint256 leafPos = 0;
1865         uint256 hashPos = 0;
1866         uint256 proofPos = 0;
1867         // At each step, we compute the next hash using two values:
1868         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1869         //   get the next hash.
1870         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1871         //   `proof` array.
1872         for (uint256 i = 0; i < totalHashes; i++) {
1873             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1874             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1875             hashes[i] = _hashPair(a, b);
1876         }
1877 
1878         if (totalHashes > 0) {
1879             return hashes[totalHashes - 1];
1880         } else if (leavesLen > 0) {
1881             return leaves[0];
1882         } else {
1883             return proof[0];
1884         }
1885     }
1886 
1887     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1888         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1889     }
1890 
1891     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1892         /// @solidity memory-safe-assembly
1893         assembly {
1894             mstore(0x00, a)
1895             mstore(0x20, b)
1896             value := keccak256(0x00, 0x40)
1897         }
1898     }
1899 }
1900 
1901 
1902 //import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";
1903 interface IOperatorFilterRegistry {
1904     /**
1905      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1906      *         true if supplied registrant address is not registered.
1907      */
1908     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1909 
1910     /**
1911      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1912      */
1913     function register(address registrant) external;
1914 
1915     /**
1916      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1917      */
1918     function registerAndSubscribe(address registrant, address subscription) external;
1919 
1920     /**
1921      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1922      *         address without subscribing.
1923      */
1924     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1925 
1926     /**
1927      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1928      *         Note that this does not remove any filtered addresses or codeHashes.
1929      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1930      */
1931     function unregister(address addr) external;
1932 
1933     /**
1934      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1935      */
1936     function updateOperator(address registrant, address operator, bool filtered) external;
1937 
1938     /**
1939      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1940      */
1941     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1942 
1943     /**
1944      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1945      */
1946     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1947 
1948     /**
1949      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1950      */
1951     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1952 
1953     /**
1954      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1955      *         subscription if present.
1956      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1957      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1958      *         used.
1959      */
1960     function subscribe(address registrant, address registrantToSubscribe) external;
1961 
1962     /**
1963      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1964      */
1965     function unsubscribe(address registrant, bool copyExistingEntries) external;
1966 
1967     /**
1968      * @notice Get the subscription address of a given registrant, if any.
1969      */
1970     function subscriptionOf(address addr) external returns (address registrant);
1971 
1972     /**
1973      * @notice Get the set of addresses subscribed to a given registrant.
1974      *         Note that order is not guaranteed as updates are made.
1975      */
1976     function subscribers(address registrant) external returns (address[] memory);
1977 
1978     /**
1979      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1980      *         Note that order is not guaranteed as updates are made.
1981      */
1982     function subscriberAt(address registrant, uint256 index) external returns (address);
1983 
1984     /**
1985      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1986      */
1987     function copyEntriesOf(address registrant, address registrantToCopy) external;
1988 
1989     /**
1990      * @notice Returns true if operator is filtered by a given address or its subscription.
1991      */
1992     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1993 
1994     /**
1995      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1996      */
1997     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1998 
1999     /**
2000      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2001      */
2002     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2003 
2004     /**
2005      * @notice Returns a list of filtered operators for a given address or its subscription.
2006      */
2007     function filteredOperators(address addr) external returns (address[] memory);
2008 
2009     /**
2010      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2011      *         Note that order is not guaranteed as updates are made.
2012      */
2013     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2014 
2015     /**
2016      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2017      *         its subscription.
2018      *         Note that order is not guaranteed as updates are made.
2019      */
2020     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2021 
2022     /**
2023      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2024      *         its subscription.
2025      *         Note that order is not guaranteed as updates are made.
2026      */
2027     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2028 
2029     /**
2030      * @notice Returns true if an address has registered
2031      */
2032     function isRegistered(address addr) external returns (bool);
2033 
2034     /**
2035      * @dev Convenience method to compute the code hash of an arbitrary contract
2036      */
2037     function codeHashOf(address addr) external returns (bytes32);
2038 }
2039 
2040 
2041 //import {CANONICAL_CORI_SUBSCRIPTION} from "./lib/Constants.sol";
2042 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2043 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2044 
2045 
2046 //import {OperatorFilterer} from "./OperatorFilterer.sol";
2047 /**
2048  * @title  OperatorFilterer
2049  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2050  *         registrant's entries in the OperatorFilterRegistry.
2051  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2052  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2053  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2054  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2055  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2056  *         will be locked to the options set during construction.
2057  */
2058 
2059 abstract contract OperatorFilterer {
2060     /// @dev Emitted when an operator is not allowed.
2061     error OperatorNotAllowed(address operator);
2062 
2063     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2064         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2065 
2066     /// @dev The constructor that is called when the contract is being deployed.
2067     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2068         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2069         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2070         // order for the modifier to filter addresses.
2071         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2072             if (subscribe) {
2073                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2074             } else {
2075                 if (subscriptionOrRegistrantToCopy != address(0)) {
2076                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2077                 } else {
2078                     OPERATOR_FILTER_REGISTRY.register(address(this));
2079                 }
2080             }
2081         }
2082     }
2083 
2084     /**
2085      * @dev A helper function to check if an operator is allowed.
2086      */
2087     modifier onlyAllowedOperator(address from) virtual {
2088         // Allow spending tokens from addresses with balance
2089         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2090         // from an EOA.
2091         if (from != msg.sender) {
2092             _checkFilterOperator(msg.sender);
2093         }
2094         _;
2095     }
2096 
2097     /**
2098      * @dev A helper function to check if an operator approval is allowed.
2099      */
2100     modifier onlyAllowedOperatorApproval(address operator) virtual {
2101         _checkFilterOperator(operator);
2102         _;
2103     }
2104 
2105     /**
2106      * @dev A helper function to check if an operator is allowed.
2107      */
2108     function _checkFilterOperator(address operator) internal view virtual {
2109         // Check registry code length to facilitate testing in environments without a deployed registry.
2110         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2111             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2112             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2113             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2114                 revert OperatorNotAllowed(operator);
2115             }
2116         }
2117     }
2118 }
2119 
2120 
2121 //import "operator-filter-registry/src/DefaultOperatorFilterer.sol";
2122 /**
2123  * @title  DefaultOperatorFilterer
2124  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2125  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2126  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2127  *         will be locked to the options set during construction.
2128  */
2129 
2130 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2131     /// @dev The constructor that is called when the contract is being deployed.
2132     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2133 }
2134 
2135 
2136 //import "./common/IAirdrop.sol";
2137 interface IAirdrop {
2138     //--------------------
2139     // function
2140     //--------------------
2141     function getTotal() external view returns (uint256);
2142     function getAt( uint256 at ) external view returns (address);
2143 }
2144 
2145 
2146 //import "./common/IERC721Monitor.sol";
2147 interface IERC721Monitor{
2148     function onTransfered( address from, address to, uint256 tokenId, uint256 batchSize ) external;
2149 }
2150 
2151 
2152 //-----------------------------------
2153 // Token(ERC721)
2154 //-----------------------------------
2155 contract Token is Ownable, ERC721, ReentrancyGuard, ERC2981, DefaultOperatorFilterer {
2156     //--------------------------------------
2157     // constant
2158     //--------------------------------------
2159     // mainnet
2160     string constant private TOKEN_NAME = "SUKIGAKU";
2161     string constant private TOKEN_SYMBOL = "SUKIGAKU";
2162     address constant private OWNER_ADDRESS = 0x9383B5C421C30Cd79a6C5233539779F387e40826;
2163 
2164     uint96 constant private ROYALTY_FEE_NUMERATOR = 1000;    // 1000/10000 = 10%
2165     uint256 constant private BLOCK_SEC_MARGIN = 30;
2166     uint256 constant private TOKEN_ID_OFS = 1;
2167 
2168     // enum
2169     uint256 constant private INFO_SALE_SUSPENDED = 0;
2170     uint256 constant private INFO_SALE_START = 1;
2171     uint256 constant private INFO_SALE_END = 2;
2172     uint256 constant private INFO_SALE_PRICE = 3;
2173     uint256 constant private INFO_SALE_WHITELISTED = 4;
2174     uint256 constant private INFO_SALE_USER_MINTED = 5;
2175     uint256 constant private INFO_SALE_USER_MINTABLE = 6;
2176     uint256 constant private INFO_MAX = 7;
2177     uint256 constant private USER_INFO_SALE_TYPE = INFO_MAX;
2178     uint256 constant private USER_INFO_TOTAL_SUPPLY = INFO_MAX + 1;
2179     uint256 constant private USER_INFO_TOKEN_MAX = INFO_MAX + 2;
2180     uint256 constant private USER_INFO_MINT_LIMIT = INFO_MAX + 3;
2181     uint256 constant private USER_INFO_MAX = INFO_MAX + 4;
2182 
2183     //--------------------------------------
2184     // storage
2185     //--------------------------------------
2186     address private _manager;
2187 
2188     IAirdrop private _airdrop;
2189     IERC721Monitor private _monitor;
2190 
2191     string private _base_uri_for_hidden;
2192     string private _base_uri_for_revealed;
2193     uint256 private _token_max;
2194     uint256 private _token_reserved;
2195     uint256 private _token_airdrop;
2196     uint256 private _token_mint_limit;
2197     uint256 private _total_supply;
2198 
2199     // PRIVATE(whitelist)
2200     bool private _PRIVATE_SALE_is_suspended;
2201     uint256 private _PRIVATE_SALE_start;
2202     uint256 private _PRIVATE_SALE_end;
2203     uint256 private _PRIVATE_SALE_price;
2204     bytes32 private _PRIVATE_SALE_merkle_root;
2205     mapping( address => uint256 ) private _PRIVATE_SALE_map_user_minted;
2206 
2207     // PUBLIC
2208     bool private _PUBLIC_SALE_is_suspended;
2209     uint256 private _PUBLIC_SALE_start;
2210     uint256 private _PUBLIC_SALE_end;
2211     uint256 private _PUBLIC_SALE_price;
2212     uint256 private _PUBLIC_SALE_mintable;
2213     mapping( address => uint256 ) private _PUBLIC_SALE_map_user_minted;
2214 
2215     //--------------------------------------------------------
2216     // [modifier] onlyOwnerOrManager
2217     //--------------------------------------------------------
2218     modifier onlyOwnerOrManager() {
2219         require( msg.sender == owner() || msg.sender == manager(), "caller is not the owner neither manager" );
2220         _;
2221     }
2222 
2223     //--------------------------------------------------------
2224     // constructor
2225     //--------------------------------------------------------
2226     constructor() ERC721( TOKEN_NAME, TOKEN_SYMBOL ) {
2227         if( owner() != OWNER_ADDRESS ){
2228             transferOwnership( OWNER_ADDRESS );
2229         }
2230         _manager = msg.sender;
2231 
2232         _setDefaultRoyalty( OWNER_ADDRESS, ROYALTY_FEE_NUMERATOR );
2233 
2234         //-----------------------
2235         // mainnet
2236         //-----------------------
2237         _airdrop = IAirdrop( 0xa01f756E1cD24a001c8c6ECC62d5E5f3F26390b8 );
2238         _base_uri_for_hidden = "ipfs://QmU2PZd2K5HCAa2aFKsuByf4WZKigbshfQrJzATDhE3iJm/";
2239         _token_max = 7000;
2240         _token_reserved = 50;
2241         _token_airdrop = 133;
2242         _token_mint_limit = 15;
2243 
2244         //***********************
2245         // PRIVATE(whitelist)
2246         //***********************
2247         _PRIVATE_SALE_start = 1678359600;               // 2023-03-09 20:00:00(JST)
2248         _PRIVATE_SALE_end   = 1678446000;               // 2023-03-10 20:00:00(JST)
2249         _PRIVATE_SALE_price = 14000000000000000;        // 0.014 ETH
2250         _PRIVATE_SALE_merkle_root = 0xe62c6a4890da808ccc76575d03ad8b2383780515a5095dcf496660e284a2cf3b;
2251         
2252         //~~~~~~~~~~~~~~~~~~~~~~~
2253         // PUBLIC
2254         //~~~~~~~~~~~~~~~~~~~~~~~
2255         _PUBLIC_SALE_start = 1678446000;                // 2023-03-10 20:00:00(JST)
2256         _PUBLIC_SALE_end   = 1679144400;                // 2023-03-18 22:00:00(JST)
2257         _PUBLIC_SALE_price = 14000000000000000;         // 0.014 ETH
2258         _PUBLIC_SALE_mintable = 15;                     // 15
2259     }
2260 
2261     //======================================================================================
2262     // [public/override] 
2263     //======================================================================================
2264     function supportsInterface(bytes4 interfaceId) public view override( ERC721, ERC2981 ) returns (bool) {
2265         return super.supportsInterface(interfaceId);
2266     }
2267 
2268     //======================================================================================
2269     // [external/onlyOwnerOrManager] for ERC2981
2270     //======================================================================================
2271     function setDefaultRoyalty( address receiver, uint96 feeNumerator ) external onlyOwnerOrManager { _setDefaultRoyalty( receiver, feeNumerator ); }
2272     function deleteDefaultRoyalty() external onlyOwnerOrManager { _deleteDefaultRoyalty(); }
2273     function setTokenRoyalty( uint256 tokenId, address receiver, uint96 feeNumerator ) external onlyOwnerOrManager { _setTokenRoyalty( tokenId, receiver, feeNumerator ); }
2274     function resetTokenRoyalty( uint256 tokenId ) external onlyOwnerOrManager { _resetTokenRoyalty( tokenId ); }
2275 
2276     //======================================================================================
2277     // [public/override/onlyAllowedOperatorApproval/onlyAllowedOperator] for OperatorFilter
2278     //======================================================================================
2279     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) { super.setApprovalForAll(operator, approved); }
2280     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) { super.approve(operator, tokenId); }
2281     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) { super.transferFrom(from, to, tokenId); }
2282     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) { super.safeTransferFrom(from, to, tokenId); }
2283     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) { super.safeTransferFrom(from, to, tokenId, data); }
2284 
2285     //--------------------------------------------------------
2286     // [public] manager
2287     //--------------------------------------------------------
2288     function manager() public view returns (address) {
2289         return( _manager );
2290     }
2291 
2292     //--------------------------------------------------------
2293     // [external/onlyOwner] setManager
2294     //--------------------------------------------------------
2295     function setManager( address target ) external onlyOwner {
2296         _manager = target;
2297     }
2298 
2299     //--------------------------------------------------------
2300     // [external] get
2301     //--------------------------------------------------------
2302     function airdrop() external view returns (address) { return( address(_airdrop) ); }
2303     function monitor() external view returns (address) { return( address(_monitor) ); }
2304 
2305     function baseUriForHidden() external view returns (string memory) { return( _base_uri_for_hidden ); }
2306     function baseUriForRevealed() external view returns (string memory) { return( _base_uri_for_revealed ); }
2307     function tokenMax() external view returns (uint256) { return( _token_max ); }
2308     function tokenReserved() external view returns (uint256) { return( _token_reserved ); }
2309     function tokenAirdrop() external view returns (uint256) { return( _token_airdrop ); }
2310     function tokenMintLimit() external view returns (uint256) { return( _token_mint_limit ); }    
2311     function totalSupply() external view returns (uint256) { return( _total_supply ); }
2312 
2313     //--------------------------------------------------------
2314     // [external/onlyOwnerOrManager] set
2315     //--------------------------------------------------------
2316     function setAirdrop( address target ) external onlyOwnerOrManager { _airdrop = IAirdrop(target); }
2317     function setMonitor( address target ) external onlyOwnerOrManager { _monitor = IERC721Monitor(target); }
2318 
2319     function setBaseUriForHidden( string calldata uri ) external onlyOwnerOrManager { _base_uri_for_hidden = uri; }
2320     function setBaseUriForRevealed( string calldata uri ) external onlyOwnerOrManager { _base_uri_for_revealed = uri; }
2321     function setTokenMax( uint256 num ) external onlyOwnerOrManager { _token_max = num; }
2322     function setTokenReserved( uint256 num ) external onlyOwnerOrManager { _token_reserved = num; }
2323     function setTokenAirdrop( uint256 num ) external onlyOwnerOrManager { _token_airdrop = num; }
2324     function setTokenMintLimit( uint256 num ) external onlyOwnerOrManager { _token_mint_limit = num; }
2325 
2326     //--------------------------------------------------------
2327     // [public/override] tokenURI
2328     //--------------------------------------------------------
2329     function tokenURI( uint256 tokenId ) public view override returns (string memory) {
2330         require( _exists( tokenId ), "nonexistent token" );
2331 
2332         if( bytes(_base_uri_for_revealed).length > 0 ){
2333             return( string( abi.encodePacked( _base_uri_for_revealed, Strings.toString( tokenId ) ) ) );            
2334         }
2335 
2336         return( string( abi.encodePacked( _base_uri_for_hidden, Strings.toString( tokenId ) ) ) );
2337     }
2338 
2339     //********************************************************
2340     // [public] getInfo - PRIVATE(whitelist)
2341     //********************************************************
2342     function PRIVATE_SALE_getInfo( address target, uint256 amount, bytes32[] calldata merkleProof ) public view returns (uint256[INFO_MAX] memory) {
2343         uint256[INFO_MAX] memory arrRet;
2344 
2345         if( _PRIVATE_SALE_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
2346         arrRet[INFO_SALE_START] = _PRIVATE_SALE_start;
2347         arrRet[INFO_SALE_END] = _PRIVATE_SALE_end;
2348         arrRet[INFO_SALE_PRICE] = _PRIVATE_SALE_price;
2349         if( _checkWhitelisted( target, amount, merkleProof ) ){
2350             arrRet[INFO_SALE_WHITELISTED] = 1;
2351             arrRet[INFO_SALE_USER_MINTABLE] = amount;
2352         }
2353         arrRet[INFO_SALE_USER_MINTED] = _PRIVATE_SALE_map_user_minted[target];
2354 
2355         return( arrRet );
2356     }
2357 
2358     //********************************************************
2359     // [external/onlyOwnerOrManager] write - PRIVATE(whitelist)
2360     //********************************************************
2361     function PRIVATE_SALE_suspend( bool flag ) external onlyOwnerOrManager { _PRIVATE_SALE_is_suspended = flag; }
2362     function PRIVATE_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager { _PRIVATE_SALE_start = start; _PRIVATE_SALE_end = end; }
2363     function PRIVATE_SALE_setPrice( uint256 price ) external onlyOwnerOrManager { _PRIVATE_SALE_price = price; }
2364     function PRIVATE_SALE_setMerkleRoot( bytes32 root ) external onlyOwnerOrManager { _PRIVATE_SALE_merkle_root = root; }
2365 
2366     //********************************************************
2367     // [external/payable/nonReentrant] mint - PRIVATE(whitelist)
2368     //********************************************************
2369     function PRIVATE_SALE_mint( uint256 num, uint256 amount, bytes32[] calldata merkleProof ) external payable nonReentrant {
2370         uint256[INFO_MAX] memory arrInfo = PRIVATE_SALE_getInfo( msg.sender, amount, merkleProof );
2371 
2372         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PRIVATE SALE: suspended" );
2373         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PRIVATE SALE: not opend" );
2374         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PRIVATE SALE: finished" );
2375         require( arrInfo[INFO_SALE_WHITELISTED] == 1, "PRIVATE SALE: not whitelisted" );
2376         require( arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PRIVATE SALE: reached the limit" );
2377 
2378         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
2379 
2380         _PRIVATE_SALE_map_user_minted[msg.sender] += num;
2381 
2382         // mint
2383         _mintTokens( msg.sender, num );
2384     }
2385 
2386     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2387     // [public] getInfo - PUBLIC
2388     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2389     function PUBLIC_SALE_getInfo( address target ) public view returns (uint256[INFO_MAX] memory) {
2390         uint256[INFO_MAX] memory arrRet;
2391 
2392         if( _PUBLIC_SALE_is_suspended ){ arrRet[INFO_SALE_SUSPENDED] = 1; }
2393         arrRet[INFO_SALE_START] = _PUBLIC_SALE_start;
2394         arrRet[INFO_SALE_END] = _PUBLIC_SALE_end;
2395         arrRet[INFO_SALE_PRICE] = _PUBLIC_SALE_price;
2396         arrRet[INFO_SALE_WHITELISTED] = 1;
2397         arrRet[INFO_SALE_USER_MINTED] = _PUBLIC_SALE_map_user_minted[target];
2398         arrRet[INFO_SALE_USER_MINTABLE] = _PUBLIC_SALE_mintable;
2399 
2400         return( arrRet );
2401     }
2402 
2403     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2404     // [external/onlyOwnerOrManager] write - PUBLIC
2405     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2406     function PUBLIC_SALE_suspend( bool flag ) external onlyOwnerOrManager { _PUBLIC_SALE_is_suspended = flag; }
2407     function PUBLIC_SALE_setStartEnd( uint256 start, uint256 end ) external onlyOwnerOrManager { _PUBLIC_SALE_start = start; _PUBLIC_SALE_end = end; }
2408     function PUBLIC_SALE_setPrice( uint256 price ) external onlyOwnerOrManager { _PUBLIC_SALE_price = price; }
2409     function PUBLIC_SALE_setMintable( uint256 mintable ) external onlyOwnerOrManager { _PUBLIC_SALE_mintable = mintable; }
2410 
2411     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2412     // [external/payable/nonReentrant] mint - PUBLIC
2413     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2414     function PUBLIC_SALE_mint( uint256 num ) external payable nonReentrant {
2415         uint256[INFO_MAX] memory arrInfo = PUBLIC_SALE_getInfo( msg.sender );
2416 
2417         require( arrInfo[INFO_SALE_SUSPENDED] == 0, "PUBLIC SALE: suspended" );
2418         require( arrInfo[INFO_SALE_START] == 0 || arrInfo[INFO_SALE_START] <= (block.timestamp+BLOCK_SEC_MARGIN), "PUBLIC SALE: not opend" );
2419         require( arrInfo[INFO_SALE_END] == 0 || (arrInfo[INFO_SALE_END]+BLOCK_SEC_MARGIN) > block.timestamp, "PUBLIC SALE: finished" );
2420         require( arrInfo[INFO_SALE_USER_MINTABLE] == 0 || arrInfo[INFO_SALE_USER_MINTABLE] >= (arrInfo[INFO_SALE_USER_MINTED]+num), "PUBLIC SALE: reached the limit" );
2421 
2422         _checkPayment( msg.sender, arrInfo[INFO_SALE_PRICE]*num, msg.value );
2423 
2424         _PUBLIC_SALE_map_user_minted[msg.sender] += num;
2425 
2426         // mint
2427         _mintTokens( msg.sender, num );
2428     }
2429 
2430     //--------------------------------------------------------
2431     // [internal] _checkWhitelisted
2432     //--------------------------------------------------------
2433     function _checkWhitelisted( address target, uint256 amount, bytes32[] calldata merkleProof ) internal view returns (bool) {
2434         bytes32 node = keccak256( abi.encodePacked( target, amount ) );
2435         return( MerkleProof.verify( merkleProof, _PRIVATE_SALE_merkle_root, node ) );
2436     }
2437 
2438     //--------------------------------------------------------
2439     // [internal] _checkPayment
2440     //--------------------------------------------------------
2441     function _checkPayment( address msgSender, uint256 price, uint256 payment ) internal {
2442         require( price <= payment, "insufficient value" );
2443 
2444         // refund if overpaymented
2445         if( price < payment ){
2446             uint256 change = payment - price;
2447             address payable target = payable( msgSender );
2448             Address.sendValue( target, change );
2449         }
2450     }
2451 
2452     //--------------------------------------------------------
2453     // [internal] _mintTokens
2454     //--------------------------------------------------------
2455     function _mintTokens( address to, uint256 num ) internal {
2456         require( _total_supply >= (_token_reserved+_token_airdrop), "reservation or airdrop not finished" );
2457         require( (_total_supply+num) <= _token_max, "exceeded the supply range" );
2458         require( _token_mint_limit == 0 || _token_mint_limit >= num, "reached mint limitation" );
2459 
2460         uint256 tokenId = _total_supply + TOKEN_ID_OFS;
2461         _total_supply += num;
2462 
2463         // mint
2464         for( uint256 i=0; i<num; i++ ){
2465             _mint( to, tokenId+i );
2466         }
2467     }
2468 
2469     //--------------------------------------------------------
2470     // [external/onlyOwnerOrManager] reserveTokens
2471     //--------------------------------------------------------
2472     function reserveTokens( uint256 num ) external onlyOwnerOrManager {
2473         require( (_total_supply+num) <= _token_reserved, "exceeded the reservation range" );
2474 
2475         uint256 tokenId = _total_supply + TOKEN_ID_OFS;
2476         _total_supply += num;
2477 
2478         // mint
2479         for( uint256 i=0; i<num; i++ ){
2480             _mint( owner(), tokenId+i );
2481         }
2482     }
2483 
2484     //--------------------------------------------------------
2485     // [external/onlyOwnerOrManager] airdropTokens
2486     //--------------------------------------------------------
2487     function airdropTokens( uint256 num ) external onlyOwnerOrManager {
2488         require( address(_airdrop) != address(0x0), "invalid airdrop" );
2489         require( _token_airdrop == _airdrop.getTotal(), "invalid airdrop total" );
2490         require( _token_reserved <= _total_supply, "reservation not finished" );
2491         require( (_total_supply+num) <= (_token_reserved+_token_airdrop), "exceeded the airdrop range" );
2492 
2493         uint256 at = _total_supply - _token_reserved;
2494         uint256 tokenId = _total_supply + TOKEN_ID_OFS;
2495         _total_supply += num;
2496 
2497         // mint
2498         for( uint256 i=0; i<num; i++ ){
2499             _mint( _airdrop.getAt( at+i ), tokenId+i );
2500         }
2501     }
2502 
2503     //--------------------------------------------------------
2504     // [external] getUserInfo
2505     //--------------------------------------------------------
2506     function getUserInfo( address target, uint256 amount, bytes32[] calldata merkleProof ) external view returns (uint256[USER_INFO_MAX] memory) {
2507         uint256[USER_INFO_MAX] memory userInfo;
2508         uint256[INFO_MAX] memory info;
2509 
2510         // PRIVATE(whitelist)
2511         if( (_PRIVATE_SALE_end == 0 || _PRIVATE_SALE_end > (block.timestamp+BLOCK_SEC_MARGIN/2)) && _checkWhitelisted( target, amount, merkleProof ) ){
2512             userInfo[USER_INFO_SALE_TYPE] = 1;
2513             info = PRIVATE_SALE_getInfo( target, amount, merkleProof );
2514         }
2515         // PUBLIC
2516         else{
2517             userInfo[USER_INFO_SALE_TYPE] = 2;
2518             info = PUBLIC_SALE_getInfo( target );
2519         }
2520 
2521         for( uint256 i=0; i<INFO_MAX; i++ ){
2522             userInfo[i] = info[i];
2523         }
2524 
2525         userInfo[USER_INFO_TOTAL_SUPPLY] = _total_supply;
2526         userInfo[USER_INFO_TOKEN_MAX] = _token_max;
2527         userInfo[USER_INFO_MINT_LIMIT] = _token_mint_limit;
2528 
2529         return( userInfo );
2530     }
2531 
2532     //--------------------------------------------------------
2533     // [external] checkBalance
2534     //--------------------------------------------------------
2535     function checkBalance() external view returns (uint256) {
2536         return( address(this).balance );
2537     }
2538 
2539     //--------------------------------------------------------
2540     // [external/onlyOwnerOrManager] withdraw
2541     //--------------------------------------------------------
2542     function withdraw( uint256 amount ) external onlyOwnerOrManager {
2543         require( amount <= address(this).balance, "insufficient balance" );
2544 
2545         address payable target = payable( owner() );
2546         Address.sendValue( target, amount );
2547     }
2548 
2549     //--------------------------------------------------------
2550     // [internal/override] _afterTokenTransfer
2551     //--------------------------------------------------------
2552     function _afterTokenTransfer( address from, address to, uint256 firstTokenId, uint256 batchSize ) internal override {
2553         super._afterTokenTransfer( from, to, firstTokenId, batchSize );
2554 
2555         if( address(_monitor) != address(0x0) ){
2556             _monitor.onTransfered( from, to, firstTokenId, batchSize );
2557         }
2558     }
2559 }