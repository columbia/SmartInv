1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.17 <0.9.0;
3 
4 
5 //import "./math/Math.sol";
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     enum Rounding {
12         Down, // Toward negative infinity
13         Up, // Toward infinity
14         Zero // Toward zero
15     }
16 
17     /**
18      * @dev Returns the largest of two numbers.
19      */
20     function max(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a > b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     function min(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a < b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the average of two numbers. The result is rounded towards
33      * zero.
34      */
35     function average(uint256 a, uint256 b) internal pure returns (uint256) {
36         // (a + b) / 2 can overflow.
37         return (a & b) + (a ^ b) / 2;
38     }
39 
40     /**
41      * @dev Returns the ceiling of the division of two numbers.
42      *
43      * This differs from standard division with `/` in that it rounds up instead
44      * of rounding down.
45      */
46     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
47         // (a + b - 1) / b can overflow on addition, so we distribute.
48         return a == 0 ? 0 : (a - 1) / b + 1;
49     }
50 
51     /**
52      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
53      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
54      * with further edits by Uniswap Labs also under MIT license.
55      */
56     function mulDiv(
57         uint256 x,
58         uint256 y,
59         uint256 denominator
60     ) internal pure returns (uint256 result) {
61         unchecked {
62             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
63             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
64             // variables such that product = prod1 * 2^256 + prod0.
65             uint256 prod0; // Least significant 256 bits of the product
66             uint256 prod1; // Most significant 256 bits of the product
67             assembly {
68                 let mm := mulmod(x, y, not(0))
69                 prod0 := mul(x, y)
70                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
71             }
72 
73             // Handle non-overflow cases, 256 by 256 division.
74             if (prod1 == 0) {
75                 return prod0 / denominator;
76             }
77 
78             // Make sure the result is less than 2^256. Also prevents denominator == 0.
79             require(denominator > prod1);
80 
81             ///////////////////////////////////////////////
82             // 512 by 256 division.
83             ///////////////////////////////////////////////
84 
85             // Make division exact by subtracting the remainder from [prod1 prod0].
86             uint256 remainder;
87             assembly {
88                 // Compute remainder using mulmod.
89                 remainder := mulmod(x, y, denominator)
90 
91                 // Subtract 256 bit number from 512 bit number.
92                 prod1 := sub(prod1, gt(remainder, prod0))
93                 prod0 := sub(prod0, remainder)
94             }
95 
96             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
97             // See https://cs.stackexchange.com/q/138556/92363.
98 
99             // Does not overflow because the denominator cannot be zero at this stage in the function.
100             uint256 twos = denominator & (~denominator + 1);
101             assembly {
102                 // Divide denominator by twos.
103                 denominator := div(denominator, twos)
104 
105                 // Divide [prod1 prod0] by twos.
106                 prod0 := div(prod0, twos)
107 
108                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
109                 twos := add(div(sub(0, twos), twos), 1)
110             }
111 
112             // Shift in bits from prod1 into prod0.
113             prod0 |= prod1 * twos;
114 
115             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
116             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
117             // four bits. That is, denominator * inv = 1 mod 2^4.
118             uint256 inverse = (3 * denominator) ^ 2;
119 
120             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
121             // in modular arithmetic, doubling the correct bits in each step.
122             inverse *= 2 - denominator * inverse; // inverse mod 2^8
123             inverse *= 2 - denominator * inverse; // inverse mod 2^16
124             inverse *= 2 - denominator * inverse; // inverse mod 2^32
125             inverse *= 2 - denominator * inverse; // inverse mod 2^64
126             inverse *= 2 - denominator * inverse; // inverse mod 2^128
127             inverse *= 2 - denominator * inverse; // inverse mod 2^256
128 
129             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
130             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
131             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
132             // is no longer required.
133             result = prod0 * inverse;
134             return result;
135         }
136     }
137 
138     /**
139      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
140      */
141     function mulDiv(
142         uint256 x,
143         uint256 y,
144         uint256 denominator,
145         Rounding rounding
146     ) internal pure returns (uint256) {
147         uint256 result = mulDiv(x, y, denominator);
148         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
149             result += 1;
150         }
151         return result;
152     }
153 
154     /**
155      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
156      *
157      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
158      */
159     function sqrt(uint256 a) internal pure returns (uint256) {
160         if (a == 0) {
161             return 0;
162         }
163 
164         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
165         //
166         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
167         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
168         //
169         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
170         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
171         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
172         //
173         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
174         uint256 result = 1 << (log2(a) >> 1);
175 
176         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
177         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
178         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
179         // into the expected uint128 result.
180         unchecked {
181             result = (result + a / result) >> 1;
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             return min(result, a / result);
189         }
190     }
191 
192     /**
193      * @notice Calculates sqrt(a), following the selected rounding direction.
194      */
195     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
196         unchecked {
197             uint256 result = sqrt(a);
198             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
199         }
200     }
201 
202     /**
203      * @dev Return the log in base 2, rounded down, of a positive value.
204      * Returns 0 if given 0.
205      */
206     function log2(uint256 value) internal pure returns (uint256) {
207         uint256 result = 0;
208         unchecked {
209             if (value >> 128 > 0) {
210                 value >>= 128;
211                 result += 128;
212             }
213             if (value >> 64 > 0) {
214                 value >>= 64;
215                 result += 64;
216             }
217             if (value >> 32 > 0) {
218                 value >>= 32;
219                 result += 32;
220             }
221             if (value >> 16 > 0) {
222                 value >>= 16;
223                 result += 16;
224             }
225             if (value >> 8 > 0) {
226                 value >>= 8;
227                 result += 8;
228             }
229             if (value >> 4 > 0) {
230                 value >>= 4;
231                 result += 4;
232             }
233             if (value >> 2 > 0) {
234                 value >>= 2;
235                 result += 2;
236             }
237             if (value >> 1 > 0) {
238                 result += 1;
239             }
240         }
241         return result;
242     }
243 
244     /**
245      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
246      * Returns 0 if given 0.
247      */
248     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
249         unchecked {
250             uint256 result = log2(value);
251             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
252         }
253     }
254 
255     /**
256      * @dev Return the log in base 10, rounded down, of a positive value.
257      * Returns 0 if given 0.
258      */
259     function log10(uint256 value) internal pure returns (uint256) {
260         uint256 result = 0;
261         unchecked {
262             if (value >= 10**64) {
263                 value /= 10**64;
264                 result += 64;
265             }
266             if (value >= 10**32) {
267                 value /= 10**32;
268                 result += 32;
269             }
270             if (value >= 10**16) {
271                 value /= 10**16;
272                 result += 16;
273             }
274             if (value >= 10**8) {
275                 value /= 10**8;
276                 result += 8;
277             }
278             if (value >= 10**4) {
279                 value /= 10**4;
280                 result += 4;
281             }
282             if (value >= 10**2) {
283                 value /= 10**2;
284                 result += 2;
285             }
286             if (value >= 10**1) {
287                 result += 1;
288             }
289         }
290         return result;
291     }
292 
293     /**
294      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
298         unchecked {
299             uint256 result = log10(value);
300             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
301         }
302     }
303 
304     /**
305      * @dev Return the log in base 256, rounded down, of a positive value.
306      * Returns 0 if given 0.
307      *
308      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
309      */
310     function log256(uint256 value) internal pure returns (uint256) {
311         uint256 result = 0;
312         unchecked {
313             if (value >> 128 > 0) {
314                 value >>= 128;
315                 result += 16;
316             }
317             if (value >> 64 > 0) {
318                 value >>= 64;
319                 result += 8;
320             }
321             if (value >> 32 > 0) {
322                 value >>= 32;
323                 result += 4;
324             }
325             if (value >> 16 > 0) {
326                 value >>= 16;
327                 result += 2;
328             }
329             if (value >> 8 > 0) {
330                 result += 1;
331             }
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
338      * Returns 0 if given 0.
339      */
340     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
341         unchecked {
342             uint256 result = log256(value);
343             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
344         }
345     }
346 }
347 
348 //import "@openzeppelin/contracts/utils/Strings.sol";
349 /**
350  * @dev String operations.
351  */
352 library Strings {
353     bytes16 private constant _SYMBOLS = "0123456789abcdef";
354     uint8 private constant _ADDRESS_LENGTH = 20;
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
358      */
359     function toString(uint256 value) internal pure returns (string memory) {
360         unchecked {
361             uint256 length = Math.log10(value) + 1;
362             string memory buffer = new string(length);
363             uint256 ptr;
364             /// @solidity memory-safe-assembly
365             assembly {
366                 ptr := add(buffer, add(32, length))
367             }
368             while (true) {
369                 ptr--;
370                 /// @solidity memory-safe-assembly
371                 assembly {
372                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
373                 }
374                 value /= 10;
375                 if (value == 0) break;
376             }
377             return buffer;
378         }
379     }
380 
381     /**
382      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
383      */
384     function toHexString(uint256 value) internal pure returns (string memory) {
385         unchecked {
386             return toHexString(value, Math.log256(value) + 1);
387         }
388     }
389 
390     /**
391      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
392      */
393     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
394         bytes memory buffer = new bytes(2 * length + 2);
395         buffer[0] = "0";
396         buffer[1] = "x";
397         for (uint256 i = 2 * length + 1; i > 1; --i) {
398             buffer[i] = _SYMBOLS[value & 0xf];
399             value >>= 4;
400         }
401         require(value == 0, "Strings: hex length insufficient");
402         return string(buffer);
403     }
404 
405     /**
406      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
407      */
408     function toHexString(address addr) internal pure returns (string memory) {
409         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
410     }
411 }
412 
413 
414 //import "../../utils/Address.sol";
415 /**
416  * @dev Collection of functions related to the address type
417  */
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      *
436      * [IMPORTANT]
437      * ====
438      * You shouldn't rely on `isContract` to protect against flash loan attacks!
439      *
440      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
441      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
442      * constructor.
443      * ====
444      */
445     function isContract(address account) internal view returns (bool) {
446         // This method relies on extcodesize/address.code.length, which returns 0
447         // for contracts in construction, since the code is only stored at the end
448         // of the constructor execution.
449 
450         return account.code.length > 0;
451     }
452 
453     /**
454      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
455      * `recipient`, forwarding all available gas and reverting on errors.
456      *
457      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
458      * of certain opcodes, possibly making contracts go over the 2300 gas limit
459      * imposed by `transfer`, making them unable to receive funds via
460      * `transfer`. {sendValue} removes this limitation.
461      *
462      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
463      *
464      * IMPORTANT: because control is transferred to `recipient`, care must be
465      * taken to not create reentrancy vulnerabilities. Consider using
466      * {ReentrancyGuard} or the
467      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
468      */
469     function sendValue(address payable recipient, uint256 amount) internal {
470         require(address(this).balance >= amount, "Address: insufficient balance");
471 
472         (bool success, ) = recipient.call{value: amount}("");
473         require(success, "Address: unable to send value, recipient may have reverted");
474     }
475 
476     /**
477      * @dev Performs a Solidity function call using a low level `call`. A
478      * plain `call` is an unsafe replacement for a function call: use this
479      * function instead.
480      *
481      * If `target` reverts with a revert reason, it is bubbled up by this
482      * function (like regular Solidity function calls).
483      *
484      * Returns the raw returned data. To convert to the expected return value,
485      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
486      *
487      * Requirements:
488      *
489      * - `target` must be a contract.
490      * - calling `target` with `data` must not revert.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
500      * `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, 0, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but also transferring `value` wei to `target`.
515      *
516      * Requirements:
517      *
518      * - the calling contract must have an ETH balance of at least `value`.
519      * - the called Solidity function must be `payable`.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value
527     ) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
533      * with `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(
538         address target,
539         bytes memory data,
540         uint256 value,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(address(this).balance >= value, "Address: insufficient balance for call");
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         (bool success, bytes memory returndata) = target.staticcall(data);
570         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but performing a delegate call.
576      *
577      * _Available since v3.4._
578      */
579     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
580         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
585      * but performing a delegate call.
586      *
587      * _Available since v3.4._
588      */
589     function functionDelegateCall(
590         address target,
591         bytes memory data,
592         string memory errorMessage
593     ) internal returns (bytes memory) {
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
600      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
601      *
602      * _Available since v4.8._
603      */
604     function verifyCallResultFromTarget(
605         address target,
606         bool success,
607         bytes memory returndata,
608         string memory errorMessage
609     ) internal view returns (bytes memory) {
610         if (success) {
611             if (returndata.length == 0) {
612                 // only check isContract if the call was successful and the return data is empty
613                 // otherwise we already know that it was a contract
614                 require(isContract(target), "Address: call to non-contract");
615             }
616             return returndata;
617         } else {
618             _revert(returndata, errorMessage);
619         }
620     }
621 
622     /**
623      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
624      * revert reason or using the provided one.
625      *
626      * _Available since v4.3._
627      */
628     function verifyCallResult(
629         bool success,
630         bytes memory returndata,
631         string memory errorMessage
632     ) internal pure returns (bytes memory) {
633         if (success) {
634             return returndata;
635         } else {
636             _revert(returndata, errorMessage);
637         }
638     }
639 
640     function _revert(bytes memory returndata, string memory errorMessage) private pure {
641         // Look for revert reason and bubble it up if present
642         if (returndata.length > 0) {
643             // The easiest way to bubble the revert reason is using memory via assembly
644             /// @solidity memory-safe-assembly
645             assembly {
646                 let returndata_size := mload(returndata)
647                 revert(add(32, returndata), returndata_size)
648             }
649         } else {
650             revert(errorMessage);
651         }
652     }
653 }
654 
655 
656 //import "../../utils/Context.sol";
657 /**
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 abstract contract Context {
668     function _msgSender() internal view virtual returns (address) {
669         return msg.sender;
670     }
671 
672     function _msgData() internal view virtual returns (bytes calldata) {
673         return msg.data;
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
699     constructor(address initialOwner) {
700         _transferOwnership(initialOwner);
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
1508 
1509 //import "@openzeppelin/contracts/token/common/ERC2981.sol";
1510 /**
1511  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1512  *
1513  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1514  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1515  *
1516  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1517  * fee is specified in basis points by default.
1518  *
1519  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1520  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1521  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1522  *
1523  * _Available since v4.5._
1524  */
1525 abstract contract ERC2981 is IERC2981, ERC165 {
1526     struct RoyaltyInfo {
1527         address receiver;
1528         uint96 royaltyFraction;
1529     }
1530 
1531     RoyaltyInfo private _defaultRoyaltyInfo;
1532     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1533 
1534     /**
1535      * @dev See {IERC165-supportsInterface}.
1536      */
1537     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1538         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1539     }
1540 
1541     /**
1542      * @inheritdoc IERC2981
1543      */
1544     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1545         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1546 
1547         if (royalty.receiver == address(0)) {
1548             royalty = _defaultRoyaltyInfo;
1549         }
1550 
1551         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1552 
1553         return (royalty.receiver, royaltyAmount);
1554     }
1555 
1556     /**
1557      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1558      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1559      * override.
1560      */
1561     function _feeDenominator() internal pure virtual returns (uint96) {
1562         return 10000;
1563     }
1564 
1565     /**
1566      * @dev Sets the royalty information that all ids in this contract will default to.
1567      *
1568      * Requirements:
1569      *
1570      * - `receiver` cannot be the zero address.
1571      * - `feeNumerator` cannot be greater than the fee denominator.
1572      */
1573     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1574         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1575         require(receiver != address(0), "ERC2981: invalid receiver");
1576 
1577         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1578     }
1579 
1580     /**
1581      * @dev Removes default royalty information.
1582      */
1583     function _deleteDefaultRoyalty() internal virtual {
1584         delete _defaultRoyaltyInfo;
1585     }
1586 
1587     /**
1588      * @dev Sets the royalty information for a specific token id, overriding the global default.
1589      *
1590      * Requirements:
1591      *
1592      * - `receiver` cannot be the zero address.
1593      * - `feeNumerator` cannot be greater than the fee denominator.
1594      */
1595     function _setTokenRoyalty(
1596         uint256 tokenId,
1597         address receiver,
1598         uint96 feeNumerator
1599     ) internal virtual {
1600         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1601         require(receiver != address(0), "ERC2981: Invalid parameters");
1602 
1603         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1604     }
1605 
1606     /**
1607      * @dev Resets royalty information for the token id back to the global default.
1608      */
1609     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1610         delete _tokenRoyaltyInfo[tokenId];
1611     }
1612 }
1613 
1614 
1615 //import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";
1616 interface IOperatorFilterRegistry {
1617     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1618     function register(address registrant) external;
1619     function registerAndSubscribe(address registrant, address subscription) external;
1620     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1621     function unregister(address addr) external;
1622     function updateOperator(address registrant, address operator, bool filtered) external;
1623     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1624     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1625     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1626     function subscribe(address registrant, address registrantToSubscribe) external;
1627     function unsubscribe(address registrant, bool copyExistingEntries) external;
1628     function subscriptionOf(address addr) external returns (address registrant);
1629     function subscribers(address registrant) external returns (address[] memory);
1630     function subscriberAt(address registrant, uint256 index) external returns (address);
1631     function copyEntriesOf(address registrant, address registrantToCopy) external;
1632     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1633     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1634     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1635     function filteredOperators(address addr) external returns (address[] memory);
1636     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1637     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1638     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1639     function isRegistered(address addr) external returns (bool);
1640     function codeHashOf(address addr) external returns (bytes32);
1641 }
1642 
1643 
1644 //import {OperatorFilterer} from "./OperatorFilterer.sol";
1645 /**
1646  * @title  OperatorFilterer
1647  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1648  *         registrant's entries in the OperatorFilterRegistry.
1649  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1650  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1651  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1652  */
1653 abstract contract OperatorFilterer {
1654     error OperatorNotAllowed(address operator);
1655 
1656     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1657         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1658 
1659     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1660         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1661         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1662         // order for the modifier to filter addresses.
1663         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1664             if (subscribe) {
1665                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1666             } else {
1667                 if (subscriptionOrRegistrantToCopy != address(0)) {
1668                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1669                 } else {
1670                     OPERATOR_FILTER_REGISTRY.register(address(this));
1671                 }
1672             }
1673         }
1674     }
1675 
1676     modifier onlyAllowedOperator(address from) virtual {
1677         // Allow spending tokens from addresses with balance
1678         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1679         // from an EOA.
1680         if (from != msg.sender) {
1681             _checkFilterOperator(msg.sender);
1682         }
1683         _;
1684     }
1685 
1686     modifier onlyAllowedOperatorApproval(address operator) virtual {
1687         _checkFilterOperator(operator);
1688         _;
1689     }
1690 
1691     function _checkFilterOperator(address operator) internal view virtual {
1692         // Check registry code length to facilitate testing in environments without a deployed registry.
1693         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1694             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1695                 revert OperatorNotAllowed(operator);
1696             }
1697         }
1698     }
1699 }
1700 
1701 
1702 //import "operator-filter-registry/src/DefaultOperatorFilterer.sol";
1703 /**
1704  * @title  DefaultOperatorFilterer
1705  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1706  */
1707 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1708     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1709 
1710     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1711 }
1712 
1713 
1714 //import "./Common/IMintable.sol";
1715 //--------------------------------------------
1716 // Mintable intterface
1717 //--------------------------------------------
1718 interface IMintable {
1719     //----------------
1720     // write
1721     //----------------
1722     function mintByMinter( address to, uint256 tokenId ) external;
1723 }
1724 
1725 
1726 //------------------------------------------------------------
1727 // Token(ERC721)
1728 //------------------------------------------------------------
1729 contract Token is Ownable, ERC721, IMintable, ERC2981, DefaultOperatorFilterer {
1730     //--------------------------------------------------------
1731     // constants
1732     //--------------------------------------------------------
1733     string constant private TOKEN_NAME = "IROIRO";
1734     string constant private TOKEN_SYMBOL = "IROIRO";
1735     address constant private OWNER_ADDRESS = 0xc78b8E9f12EDbc74A708F9B5A0472B33b3B286ce;
1736 
1737 
1738     // Royalty
1739     uint96 constant private ROYALTY_FEE_NUMERATOR = 500;    // 500/10000 = 5%
1740 
1741     //--------------------------------------------------------
1742     // storage
1743     //--------------------------------------------------------
1744     address private _manager;
1745     address private _minter;
1746 
1747     string private _base_uri_for_hidden;
1748     string private _base_uri_for_revealed;
1749     uint256 private _token_id_from;
1750     uint256 private _token_id_to;
1751 
1752     //--------------------------------------------------------
1753     // [modifier] onlyOwnerOrManager
1754     //--------------------------------------------------------
1755     modifier onlyOwnerOrManager() {
1756         require( msg.sender == owner() || msg.sender == manager(), "caller is not the owner neither manager" );
1757         _;
1758     }
1759 
1760     //--------------------------------------------------------
1761     // [modifier] onlyMinter
1762     //--------------------------------------------------------
1763     modifier onlyMinter() {
1764         require( msg.sender == minter(), "caller is not the minter" );
1765         _;
1766     }
1767 
1768     //--------------------------------------------------------
1769     // constructor
1770     //--------------------------------------------------------
1771     constructor() Ownable( OWNER_ADDRESS ) ERC721( TOKEN_NAME, TOKEN_SYMBOL ) {
1772         _setDefaultRoyalty( OWNER_ADDRESS, ROYALTY_FEE_NUMERATOR );
1773         _manager = msg.sender;
1774 
1775         _base_uri_for_hidden = "ipfs://QmbJAjHuXRC1nvpWa8gqwSxREo47rZwCRzff1iCpzUpt5m/";
1776         _token_id_from = 1;
1777         _token_id_to = 5000;
1778     }
1779 
1780     //=======================================================================
1781     // [public/override] supportsInterface
1782     //=======================================================================
1783     function supportsInterface(bytes4 interfaceId) public view override( ERC721, ERC2981 ) returns (bool) {
1784         return super.supportsInterface(interfaceId);
1785     }
1786 
1787     //=======================================================================
1788     // [external/onlyOwnerOrManager] for ERC2981
1789     //=======================================================================
1790     function setDefaultRoyalty( address receiver, uint96 feeNumerator ) external onlyOwnerOrManager { _setDefaultRoyalty( receiver, feeNumerator ); }
1791     function deleteDefaultRoyalty() external onlyOwnerOrManager { _deleteDefaultRoyalty(); }
1792     function setTokenRoyalty( uint256 tokenId, address receiver, uint96 feeNumerator ) external onlyOwnerOrManager { _setTokenRoyalty( tokenId, receiver, feeNumerator ); }
1793     function resetTokenRoyalty( uint256 tokenId ) external onlyOwnerOrManager { _resetTokenRoyalty( tokenId ); }
1794 
1795     //=======================================================================
1796     // [public/override/onlyAllowedOperatorApproval] for OperatorFilter
1797     //=======================================================================
1798     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) { super.setApprovalForAll(operator, approved); }
1799     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) { super.approve(operator, tokenId); }
1800     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) { super.transferFrom(from, to, tokenId); }
1801     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) { super.safeTransferFrom(from, to, tokenId); }
1802     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) { super.safeTransferFrom(from, to, tokenId, data); }
1803 
1804     //--------------------------------------------------------
1805     // [public] manager
1806     //--------------------------------------------------------
1807     function manager() public view returns (address) {
1808         return( _manager );
1809     }
1810 
1811     //--------------------------------------------------------
1812     // [external/onlyOwner] setManager
1813     //--------------------------------------------------------
1814     function setManager( address target ) external onlyOwner {
1815         _manager = target;
1816     }
1817 
1818     //--------------------------------------------------------
1819     // [public] minter
1820     //--------------------------------------------------------
1821     function minter() public view returns (address) {
1822         return( _minter );
1823     }
1824 
1825     //--------------------------------------------------------
1826     // [external/onlyOwnerOrManager] setMinter
1827     //--------------------------------------------------------
1828     function setMinter( address target ) external onlyOwnerOrManager {
1829         _minter = target;
1830     }
1831 
1832     //--------------------------------------------------------
1833     // [external] get
1834     //--------------------------------------------------------
1835     function baseUriForHidden() external view returns (string memory) { return( _base_uri_for_hidden ); }
1836     function baseUriForRevealed() external view returns (string memory) { return( _base_uri_for_revealed ); }
1837     function tokenIdFrom() external view returns (uint256) { return( _token_id_from ); }
1838     function tokenIdTo()external view returns (uint256) { return( _token_id_to ); }
1839 
1840     //--------------------------------------------------------
1841     // [external/onlyOwnerOrManager] set
1842     //--------------------------------------------------------
1843     function setBaseUriForHidden( string calldata baseUri ) external onlyOwnerOrManager { _base_uri_for_hidden = baseUri; }
1844     function setBaseUriForRevealed( string calldata baseUri ) external onlyOwnerOrManager { _base_uri_for_revealed = baseUri; }
1845     function setTokenIdFrom( uint256 idFrom ) external onlyOwnerOrManager { _token_id_from = idFrom; }
1846     function setTokenIdTo( uint256 idTo )external onlyOwnerOrManager { _token_id_to = idTo; }
1847 
1848     //--------------------------------------------------------
1849     // [public/override] tokenURI
1850     //--------------------------------------------------------
1851     function tokenURI( uint256 tokenId ) public view override returns (string memory) {
1852         require( _exists( tokenId ), "nonexistent token" );
1853 
1854         if( bytes(_base_uri_for_revealed).length > 0 ){
1855             return( string( abi.encodePacked( _base_uri_for_revealed, Strings.toString( tokenId ) ) ) );          
1856         }
1857 
1858         return( string( abi.encodePacked( _base_uri_for_hidden, Strings.toString( tokenId ) ) ) );
1859     }
1860 
1861     //--------------------------------------------------------
1862     // [external/override/onlyMinter] mintByMinter
1863     //--------------------------------------------------------
1864     function mintByMinter( address to, uint256 tokenId ) external override onlyMinter {
1865         require( tokenId >=_token_id_from && tokenId <= _token_id_to, "invalid tokenId" );
1866 
1867         _mint( to, tokenId );
1868     }
1869 
1870 }