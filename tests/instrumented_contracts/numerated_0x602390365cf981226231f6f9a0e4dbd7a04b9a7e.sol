1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
3 
4 pragma solidity ^0.8.13;
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library Math {
10     enum Rounding {
11         Down, // Toward negative infinity
12         Up, // Toward infinity
13         Zero // Toward zero
14     }
15 
16     /**
17      * @dev Returns the largest of two numbers.
18      */
19     function max(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a > b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the smallest of two numbers.
25      */
26     function min(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a < b ? a : b;
28     }
29 
30     /**
31      * @dev Returns the average of two numbers. The result is rounded towards
32      * zero.
33      */
34     function average(uint256 a, uint256 b) internal pure returns (uint256) {
35         // (a + b) / 2 can overflow.
36         return (a & b) + (a ^ b) / 2;
37     }
38 
39     /**
40      * @dev Returns the ceiling of the division of two numbers.
41      *
42      * This differs from standard division with `/` in that it rounds up instead
43      * of rounding down.
44      */
45     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
46         // (a + b - 1) / b can overflow on addition, so we distribute.
47         return a == 0 ? 0 : (a - 1) / b + 1;
48     }
49 
50     /**
51      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
52      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
53      * with further edits by Uniswap Labs also under MIT license.
54      */
55     function mulDiv(
56         uint256 x,
57         uint256 y,
58         uint256 denominator
59     ) internal pure returns (uint256 result) {
60     unchecked {
61         // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
62         // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
63         // variables such that product = prod1 * 2^256 + prod0.
64         uint256 prod0; // Least significant 256 bits of the product
65         uint256 prod1; // Most significant 256 bits of the product
66         assembly {
67             let mm := mulmod(x, y, not(0))
68             prod0 := mul(x, y)
69             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
70         }
71 
72         // Handle non-overflow cases, 256 by 256 division.
73         if (prod1 == 0) {
74             return prod0 / denominator;
75         }
76 
77         // Make sure the result is less than 2^256. Also prevents denominator == 0.
78         require(denominator > prod1);
79 
80         ///////////////////////////////////////////////
81         // 512 by 256 division.
82         ///////////////////////////////////////////////
83 
84         // Make division exact by subtracting the remainder from [prod1 prod0].
85         uint256 remainder;
86         assembly {
87         // Compute remainder using mulmod.
88             remainder := mulmod(x, y, denominator)
89 
90         // Subtract 256 bit number from 512 bit number.
91             prod1 := sub(prod1, gt(remainder, prod0))
92             prod0 := sub(prod0, remainder)
93         }
94 
95         // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
96         // See https://cs.stackexchange.com/q/138556/92363.
97 
98         // Does not overflow because the denominator cannot be zero at this stage in the function.
99         uint256 twos = denominator & (~denominator + 1);
100         assembly {
101         // Divide denominator by twos.
102             denominator := div(denominator, twos)
103 
104         // Divide [prod1 prod0] by twos.
105             prod0 := div(prod0, twos)
106 
107         // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
108             twos := add(div(sub(0, twos), twos), 1)
109         }
110 
111         // Shift in bits from prod1 into prod0.
112         prod0 |= prod1 * twos;
113 
114         // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
115         // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
116         // four bits. That is, denominator * inv = 1 mod 2^4.
117         uint256 inverse = (3 * denominator) ^ 2;
118 
119         // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
120         // in modular arithmetic, doubling the correct bits in each step.
121         inverse *= 2 - denominator * inverse; // inverse mod 2^8
122         inverse *= 2 - denominator * inverse; // inverse mod 2^16
123         inverse *= 2 - denominator * inverse; // inverse mod 2^32
124         inverse *= 2 - denominator * inverse; // inverse mod 2^64
125         inverse *= 2 - denominator * inverse; // inverse mod 2^128
126         inverse *= 2 - denominator * inverse; // inverse mod 2^256
127 
128         // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
129         // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
130         // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
131         // is no longer required.
132         result = prod0 * inverse;
133         return result;
134     }
135     }
136 
137     /**
138      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
139      */
140     function mulDiv(
141         uint256 x,
142         uint256 y,
143         uint256 denominator,
144         Rounding rounding
145     ) internal pure returns (uint256) {
146         uint256 result = mulDiv(x, y, denominator);
147         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
148             result += 1;
149         }
150         return result;
151     }
152 
153     /**
154      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
155      *
156      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
157      */
158     function sqrt(uint256 a) internal pure returns (uint256) {
159         if (a == 0) {
160             return 0;
161         }
162 
163         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
164         //
165         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
166         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
167         //
168         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
169         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
170         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
171         //
172         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
173         uint256 result = 1 << (log2(a) >> 1);
174 
175         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
176         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
177         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
178         // into the expected uint128 result.
179     unchecked {
180         result = (result + a / result) >> 1;
181         result = (result + a / result) >> 1;
182         result = (result + a / result) >> 1;
183         result = (result + a / result) >> 1;
184         result = (result + a / result) >> 1;
185         result = (result + a / result) >> 1;
186         result = (result + a / result) >> 1;
187         return min(result, a / result);
188     }
189     }
190 
191     /**
192      * @notice Calculates sqrt(a), following the selected rounding direction.
193      */
194     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
195     unchecked {
196         uint256 result = sqrt(a);
197         return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
198     }
199     }
200 
201     /**
202      * @dev Return the log in base 2, rounded down, of a positive value.
203      * Returns 0 if given 0.
204      */
205     function log2(uint256 value) internal pure returns (uint256) {
206         uint256 result = 0;
207     unchecked {
208         if (value >> 128 > 0) {
209             value >>= 128;
210             result += 128;
211         }
212         if (value >> 64 > 0) {
213             value >>= 64;
214             result += 64;
215         }
216         if (value >> 32 > 0) {
217             value >>= 32;
218             result += 32;
219         }
220         if (value >> 16 > 0) {
221             value >>= 16;
222             result += 16;
223         }
224         if (value >> 8 > 0) {
225             value >>= 8;
226             result += 8;
227         }
228         if (value >> 4 > 0) {
229             value >>= 4;
230             result += 4;
231         }
232         if (value >> 2 > 0) {
233             value >>= 2;
234             result += 2;
235         }
236         if (value >> 1 > 0) {
237             result += 1;
238         }
239     }
240         return result;
241     }
242 
243     /**
244      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
245      * Returns 0 if given 0.
246      */
247     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
248     unchecked {
249         uint256 result = log2(value);
250         return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
251     }
252     }
253 
254     /**
255      * @dev Return the log in base 10, rounded down, of a positive value.
256      * Returns 0 if given 0.
257      */
258     function log10(uint256 value) internal pure returns (uint256) {
259         uint256 result = 0;
260     unchecked {
261         if (value >= 10**64) {
262             value /= 10**64;
263             result += 64;
264         }
265         if (value >= 10**32) {
266             value /= 10**32;
267             result += 32;
268         }
269         if (value >= 10**16) {
270             value /= 10**16;
271             result += 16;
272         }
273         if (value >= 10**8) {
274             value /= 10**8;
275             result += 8;
276         }
277         if (value >= 10**4) {
278             value /= 10**4;
279             result += 4;
280         }
281         if (value >= 10**2) {
282             value /= 10**2;
283             result += 2;
284         }
285         if (value >= 10**1) {
286             result += 1;
287         }
288     }
289         return result;
290     }
291 
292     /**
293      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
294      * Returns 0 if given 0.
295      */
296     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
297     unchecked {
298         uint256 result = log10(value);
299         return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
300     }
301     }
302 
303     /**
304      * @dev Return the log in base 256, rounded down, of a positive value.
305      * Returns 0 if given 0.
306      *
307      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
308      */
309     function log256(uint256 value) internal pure returns (uint256) {
310         uint256 result = 0;
311     unchecked {
312         if (value >> 128 > 0) {
313             value >>= 128;
314             result += 16;
315         }
316         if (value >> 64 > 0) {
317             value >>= 64;
318             result += 8;
319         }
320         if (value >> 32 > 0) {
321             value >>= 32;
322             result += 4;
323         }
324         if (value >> 16 > 0) {
325             value >>= 16;
326             result += 2;
327         }
328         if (value >> 8 > 0) {
329             result += 1;
330         }
331     }
332         return result;
333     }
334 
335     /**
336      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
337      * Returns 0 if given 0.
338      */
339     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
340     unchecked {
341         uint256 result = log256(value);
342         return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
343     }
344     }
345 }
346 
347 library Strings {
348     bytes16 private constant _SYMBOLS = "0123456789abcdef";
349     uint8 private constant _ADDRESS_LENGTH = 20;
350 
351     /**
352      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
353      */
354     function toString(uint256 value) internal pure returns (string memory) {
355     unchecked {
356         uint256 length = Math.log10(value) + 1;
357         string memory buffer = new string(length);
358         uint256 ptr;
359         /// @solidity memory-safe-assembly
360         assembly {
361             ptr := add(buffer, add(32, length))
362         }
363         while (true) {
364             ptr--;
365             /// @solidity memory-safe-assembly
366             assembly {
367                 mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
368             }
369             value /= 10;
370             if (value == 0) break;
371         }
372         return buffer;
373     }
374     }
375 
376     /**
377      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
378      */
379     function toHexString(uint256 value) internal pure returns (string memory) {
380     unchecked {
381         return toHexString(value, Math.log256(value) + 1);
382     }
383     }
384 
385     /**
386      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
387      */
388     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
389         bytes memory buffer = new bytes(2 * length + 2);
390         buffer[0] = "0";
391         buffer[1] = "x";
392         for (uint256 i = 2 * length + 1; i > 1; --i) {
393             buffer[i] = _SYMBOLS[value & 0xf];
394             value >>= 4;
395         }
396         require(value == 0, "Strings: hex length insufficient");
397         return string(buffer);
398     }
399 
400     /**
401      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
402      */
403     function toHexString(address addr) internal pure returns (string memory) {
404         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
405     }
406 }
407 
408 abstract contract Context {
409     function _msgSender() internal view virtual returns (address) {
410         return msg.sender;
411     }
412 
413     function _msgData() internal view virtual returns (bytes calldata) {
414         return msg.data;
415     }
416 }
417 
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
462      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
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
655 interface IERC165 {
656     /**
657      * @dev Returns true if this contract implements the interface defined by
658      * `interfaceId`. See the corresponding
659      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
660      * to learn more about how these ids are created.
661      *
662      * This function call must use less than 30 000 gas.
663      */
664     function supportsInterface(bytes4 interfaceId) external view returns (bool);
665 }
666 
667 interface IERC721 is IERC165 {
668     /**
669      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
670      */
671     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
672 
673     /**
674      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
675      */
676     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
677 
678     /**
679      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
680      */
681     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
682 
683     /**
684      * @dev Returns the number of tokens in ``owner``'s account.
685      */
686     function balanceOf(address owner) external view returns (uint256 balance);
687 
688     /**
689      * @dev Returns the owner of the `tokenId` token.
690      *
691      * Requirements:
692      *
693      * - `tokenId` must exist.
694      */
695     function ownerOf(uint256 tokenId) external view returns (address owner);
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
707      *
708      * Emits a {Transfer} event.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes calldata data
715     ) external;
716 
717     /**
718      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
719      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
720      *
721      * Requirements:
722      *
723      * - `from` cannot be the zero address.
724      * - `to` cannot be the zero address.
725      * - `tokenId` token must exist and be owned by `from`.
726      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
727      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
728      *
729      * Emits a {Transfer} event.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) external;
736 
737     /**
738      * @dev Transfers `tokenId` token from `from` to `to`.
739      *
740      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
741      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
742      * understand this adds an external call which potentially creates a reentrancy vulnerability.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      *
751      * Emits a {Transfer} event.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) external;
758 
759     /**
760      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
761      * The approval is cleared when the token is transferred.
762      *
763      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
764      *
765      * Requirements:
766      *
767      * - The caller must own the token or be an approved operator.
768      * - `tokenId` must exist.
769      *
770      * Emits an {Approval} event.
771      */
772     function approve(address to, uint256 tokenId) external;
773 
774     /**
775      * @dev Approve or remove `operator` as an operator for the caller.
776      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
777      *
778      * Requirements:
779      *
780      * - The `operator` cannot be the caller.
781      *
782      * Emits an {ApprovalForAll} event.
783      */
784     function setApprovalForAll(address operator, bool _approved) external;
785 
786     /**
787      * @dev Returns the account approved for `tokenId` token.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function getApproved(uint256 tokenId) external view returns (address operator);
794 
795     /**
796      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
797      *
798      * See {setApprovalForAll}
799      */
800     function isApprovedForAll(address owner, address operator) external view returns (bool);
801 }
802 
803 
804 
805 /**
806  * @dev Implementation of the {IERC165} interface.
807  *
808  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
809  * for the additional interface id that will be supported. For example:
810  *
811  * ```solidity
812  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
813  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
814  * }
815  * ```
816  *
817  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
818  */
819 abstract contract ERC165 is IERC165 {
820     /**
821      * @dev See {IERC165-supportsInterface}.
822      */
823     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
824         return interfaceId == type(IERC165).interfaceId;
825     }
826 }
827 
828 
829 /**
830  * @title ERC721 token receiver interface
831  * @dev Interface for any contract that wants to support safeTransfers
832  * from ERC721 asset contracts.
833  */
834 interface IERC721Receiver {
835     /**
836      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
837      * by `operator` from `from`, this function is called.
838      *
839      * It must return its Solidity selector to confirm the token transfer.
840      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
841      *
842      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
843      */
844     function onERC721Received(
845         address operator,
846         address from,
847         uint256 tokenId,
848         bytes calldata data
849     ) external returns (bytes4);
850 }
851 
852 /**
853  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
854  * @dev See https://eips.ethereum.org/EIPS/eip-721
855  */
856 interface IERC721Metadata is IERC721 {
857     /**
858      * @dev Returns the token collection name.
859      */
860     function name() external view returns (string memory);
861 
862     /**
863      * @dev Returns the token collection symbol.
864      */
865     function symbol() external view returns (string memory);
866 
867     /**
868      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
869      */
870     function tokenURI(uint256 tokenId) external view returns (string memory);
871 }
872 
873 abstract contract Ownable is Context {
874     address private _owner;
875 
876     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
877 
878     /**
879      * @dev Initializes the contract setting the deployer as the initial owner.
880      */
881     constructor() {
882         _transferOwnership(_msgSender());
883     }
884 
885     /**
886      * @dev Throws if called by any account other than the owner.
887      */
888     modifier onlyOwner() {
889         _checkOwner();
890         _;
891     }
892 
893     /**
894      * @dev Returns the address of the current owner.
895      */
896     function owner() public view virtual returns (address) {
897         return _owner;
898     }
899 
900     /**
901      * @dev Throws if the sender is not the owner.
902      */
903     function _checkOwner() internal view virtual {
904         require(owner() == _msgSender(), "Ownable: caller is not the owner");
905     }
906 
907     /**
908      * @dev Leaves the contract without owner. It will not be possible to call
909      * `onlyOwner` functions anymore. Can only be called by the current owner.
910      *
911      * NOTE: Renouncing ownership will leave the contract without an owner,
912      * thereby removing any functionality that is only available to the owner.
913      */
914     function renounceOwnership() public virtual onlyOwner {
915         _transferOwnership(address(0));
916     }
917 
918     /**
919      * @dev Transfers ownership of the contract to a new account (`newOwner`).
920      * Can only be called by the current owner.
921      */
922     function transferOwnership(address newOwner) public virtual onlyOwner {
923         require(newOwner != address(0), "Ownable: new owner is the zero address");
924         _transferOwnership(newOwner);
925     }
926 
927     /**
928      * @dev Transfers ownership of the contract to a new account (`newOwner`).
929      * Internal function without access restriction.
930      */
931     function _transferOwnership(address newOwner) internal virtual {
932         address oldOwner = _owner;
933         _owner = newOwner;
934         emit OwnershipTransferred(oldOwner, newOwner);
935     }
936 }
937 interface IOperatorFilterRegistry {
938     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
939     function register(address registrant) external;
940     function registerAndSubscribe(address registrant, address subscription) external;
941     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
942     function unregister(address addr) external;
943     function updateOperator(address registrant, address operator, bool filtered) external;
944     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
945     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
946     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
947     function subscribe(address registrant, address registrantToSubscribe) external;
948     function unsubscribe(address registrant, bool copyExistingEntries) external;
949     function subscriptionOf(address addr) external returns (address registrant);
950     function subscribers(address registrant) external returns (address[] memory);
951     function subscriberAt(address registrant, uint256 index) external returns (address);
952     function copyEntriesOf(address registrant, address registrantToCopy) external;
953     function isOperatorFiltered(address registrant, address operator) external returns (bool);
954     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
955     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
956     function filteredOperators(address addr) external returns (address[] memory);
957     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
958     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
959     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
960     function isRegistered(address addr) external returns (bool);
961     function codeHashOf(address addr) external returns (bytes32);
962 }
963 
964 /**
965  * @title  OperatorFilterer
966  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
967  *         registrant's entries in the OperatorFilterRegistry.
968  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
969  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
970  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
971  */
972 abstract contract OperatorFilterer {
973     error OperatorNotAllowed(address operator);
974 
975     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
976     IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
977 
978     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
979         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
980         // will not revert, but the contract will need to be registered with the registry once it is deployed in
981         // order for the modifier to filter addresses.
982         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
983             if (subscribe) {
984                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
985             } else {
986                 if (subscriptionOrRegistrantToCopy != address(0)) {
987                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
988                 } else {
989                     OPERATOR_FILTER_REGISTRY.register(address(this));
990                 }
991             }
992         }
993     }
994 
995     modifier onlyAllowedOperator(address from) virtual {
996         // Allow spending tokens from addresses with balance
997         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
998         // from an EOA.
999         if (from != msg.sender) {
1000             _checkFilterOperator(msg.sender);
1001         }
1002         _;
1003     }
1004 
1005     modifier onlyAllowedOperatorApproval(address operator) virtual {
1006         _checkFilterOperator(operator);
1007         _;
1008     }
1009 
1010     function _checkFilterOperator(address operator) internal view virtual {
1011         // Check registry code length to facilitate testing in environments without a deployed registry.
1012         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1013             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1014                 revert OperatorNotAllowed(operator);
1015             }
1016         }
1017     }
1018 }
1019 
1020 /**
1021  * @title  DefaultOperatorFilterer
1022  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1023  */
1024 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1025     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1026 
1027     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1028 }
1029 
1030 /**
1031  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1032  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1033  * {ERC721Enumerable}.
1034  */
1035 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Ownable, DefaultOperatorFilterer {
1036     using Address for address;
1037     using Strings for uint256;
1038 
1039     // Token name
1040     string private _name;
1041 
1042     // Token symbol
1043     string private _symbol;
1044 
1045     // Mapping from token ID to owner address
1046     mapping(uint256 => address) private _owners;
1047 
1048     // Mapping owner address to token count
1049     mapping(address => uint256) private _balances;
1050 
1051     // Mapping from token ID to approved address
1052     mapping(uint256 => address) private _tokenApprovals;
1053 
1054     // Mapping from owner to operator approvals
1055     mapping(address => mapping(address => bool)) private _operatorApprovals;
1056 
1057     // Price per mint
1058     uint256 private _pricePerMint = 1.42 ether;
1059 
1060     // Max tokens
1061     uint256 constant _maxTokens = 469;
1062 
1063     // FP allocation
1064     uint256 constant _fpMaxTokens = 157;
1065 
1066     // Current tokens
1067     uint256 private _currTokens = 0;
1068 
1069     // minted from FP
1070     uint256 private _fpCurrTokens = 0;
1071 
1072     // Is sale
1073     bool private _isSale = false;
1074 
1075     //funds address
1076     address constant _fundsAddress = 0x202b8934e2E14cAF19B9a0aA70D4c5047599aDb1;
1077 
1078     //FP minters
1079     mapping(address => uint256) private _fpWallets;
1080 
1081     //Mint event
1082     event Mint(address indexed minter, uint256 indexed tokenId, uint256 indexed pricePerToken);
1083 
1084     //script
1085     string constant _script = "let seed=parseInt(hash.slice(0,16)),e=document.createElement('canvas'),t=document.createElement('style');function f(){return seed^=seed<<13,seed^=seed>>17,seed^=seed<<5,(seed<0?1+~seed:seed)%1e3/1e3}t.innerText='body {background: black;height:100vh;width:100vw;margin:0;padding:0;overflow:hidden;display:flex;justify-content:center;align-items:center;}',document.head.appendChild(t);let n,d,a,l,c,i=new Uint8Array(1024),r=f();c=r<.25?parseInt(57*f())+148:r<.7?parseInt(59*f())+89:parseInt(59*f())+30;let s,o,b=f()<.4?1:0;function h(){let t=new URLSearchParams(location.search).has('fullscreen');if(n=t?window.innerWidth:parseInt(window.innerWidth/c)*c,d=n/(16/9),d>window.innerHeight)if(d=window.innerHeight,t)n=d*(16/9);else{n=parseInt(d*(16/9)/c)*c,d=n/(16/9)}n=parseInt(n),d=parseInt(d),d-=d%2==1?1:0,a=d/(b+1),l=n/c,e.height=d,e.width=n}r=f(),s=r<.7?.05:r<.9?.1:.15,r=f(),o=r<.05?.1:r<.85?.3:.5,h(),window.addEventListener('resize',(()=>{h(),w(),B()}));let F;r=f(),F=r<.03?0:r<.07?1:r<.11?2:r<.16?3:r<.22?4:r<.28?5:r<.34?6:r<.41?7:r<.48?8:r<.55?9:r<.64?10:r<.73?11:r<.82?12:r<.91?13:14;let p=[[['#6baed6','#5fa4ce'],['#4292c6','#3586ba'],['#08519c','#034488'],['#08306b','#04285e'],['#c6dbef','#b1cae2'],['#deebf7','#cbddee'],['#fee0d2','#f1cab7'],['#fb6a4a','#e85838'],['#ef3b2c','#df2e1f'],['#a50f15','#8c080d'],['#67000d','#4b000a']],[['#10002b','#10002b'],['#FF005C','#FF005C'],['#bc00dd','#bc00dd'],['#c0fdff','#c0fdff'],['#d51fa5','#d51fa5'],['#13F4EF','#13F4EF'],['#FFFFFF','#FFFFFF']],[['#0d0d0d','#0d0d0d'],['#1f1f1f','#1f1f1f'],['#313131','#313131'],['#434444','#434444'],['#212121','#212121'],['#737373','#737373'],['#f9f9f7','#f9f9f7'],['#f4f3ef','#f4f3ef'],['#efeee8','#efeee8'],['#eae8e0','#eae8e0'],['#e5e3d9','#e5e3d9'],['#d6d4c9','#d6d4c9']],[['#282A36','#282A36'],['#6ECCDD','#6ECCDD'],['#EC1D24','#EC1D24'],['#F76B8B','#F76B8B']],[['#f9b294','#f9b294'],['#f2727f','#f2727f'],['#c06c86','#c06c86'],['#6d5c7e','#6d5c7e'],['#325d7f','#325d7f']],[['#99b998','#99b998'],['#fdceaa','#fdceaa'],['#f4837d','#f4837d'],['#eb4960','#eb4960'],['#27363b','#27363b']],[['#162039','#162039'],['#143b5a','#143b5a'],['#234a75','#234a75'],['#25538e','#25538e'],['#7f6b53','#7f6b53'],['#b39e8d','#b39e8d']],[['#251B37','#251B37'],['#372948','#372948'],['#FFCACA','#FFCACA'],['#FFECEF','#FFECEF'],['#675083','#675083'],['#e19c9c','#e19c9c']],[['#8f00ff','#8f00ff'],['#adff02','#adff02'],['#ff006d','#ff006d'],['#ff7d00','#ff7d00'],['#ffdd00','#ffdd00'],['#01befe','#01befe']],[['#ff6663','#ff6663'],['#e0ff4f','#e0ff4f'],['#22162b','#22162b'],['#e8e2fa','#e8e2fa'],['#723dcb','#723dcb'],['#45159c','#45159c']],[['#062105','#062105'],['#0c8900','#0c8900'],['#2bc20e','#2bc20e'],['#9cff00','#9cff00'],['#39ff13','#39ff13'],['#262729','#262729']],[['#780116','#780116'],['#981e1d','#981e1d'],['#c32f27','#c32f27'],['#d8572a','#d8572a'],['#db7c26','#db7c26'],['#f7b538','#f7b538']],[['#F9546B','#F9546B'],['#FC7651','#FC7651'],['#FFDB60','#FFDB60'],['#42CFCA','#42CFCA'],['#009F93','#009F93']],[['#A8A7A7','#A8A7A7'],['#CC527A','#CC527A'],['#E8175D','#E8175D'],['#474747','#474747'],['#363636','#363636']],[['#7dd6f6','#7dd6f6'],['#797ef6','#797ef6'],['#4adede','#4adede'],['#1aa7ec','#1aa7ec'],['#1e2f97','#1e2f97']]][F];f()<.4&&function(){let e=[],t=[];for(let t=0;t<p.length;t++)e.push(...p[t]);for(let n=0;n<p.length;n++){let n=[];for(let t=0;t<2;t++){let t=parseInt(f()*e.length);n.push(e[t]),e.splice(t,1)}t.push(n)}p=t}();let u=p[parseInt(f()*p.length)][parseInt(2*f())];const C=e.getContext('2d');let g=f(),A=0;function w(){g<.2?A=l/1.3:g<.7&&(A=l/13)}w();let I,m=[],E=[];0==b?E.push(!(f()<.65)):f()<.65?E.push(!1,!0):E.push(!0,!1),r=f(),I=r<.1?2:r<.35?3:r<.65?4:r<.85?5:6;for(let e=0;e<=b;e++){let t=[];for(let n=0;n<c;n++){let n=parseInt(f()*(I-1))+1,d=1,a=1,l=[[],[]];for(let t=0;t<I;t++){let c=p[parseInt(f()*p.length)];if(c[0]!==c[1]){let e=parseInt(c[0].slice(1,3),16),t=parseInt(c[0].slice(3,5),16),f=parseInt(c[0].slice(5,7),16),n=parseInt(c[1].slice(1,3),16),d=parseInt(c[1].slice(3,5),16),a=parseInt(c[1].slice(5,7),16);c=[`rgba(${e},${t},${f},`,`rgba(${n},${d},${a},`]}else{let e=parseInt(c[0].slice(1,3),16),t=parseInt(c[0].slice(3,5),16),f=parseInt(c[0].slice(5,7),16);c=[`rgba(${e},${t},${f},`]}if(t<n){let a;a=t==n-1?d:d*f(),d-=a;for(let t=0;t<c.length;t++)c[t]+=`${E[e]?1:o})`;l[0].push([c,a])}else{let n;n=t==I-1?a:a*f(),a-=n;for(let t=0;t<c.length;t++)c[t]+=`${E[e]?o:1})`;l[1].push([c,n])}}t.push(l)}m.push(t)}B(),document.body.appendChild(e);let y=window.AudioContext||window.webkitAudioContext;function D(e,t,f,n){if(e.length>1){let d=C.createLinearGradient(t,f,t,f+n);return d.addColorStop(0,e[0]),d.addColorStop(1,e[1]),d}return e[0]}function B(){C.fillStyle=u,C.fillRect(0,0,n,d),C.lineWidth=A;for(let e=0;e<=b;e++){let t=e*a;for(let f=0;f<c;f++){let n=m[e][f],d=i[f]/255,c=Math.ceil(s*a),r=d*a-c,o=a-r-c,b=c;E[e]&&(o=r,r=a-o-c,b=d/s>1?c:c*d/s);let h=0,F=0,p=f*l;if(o>0)for(let f=0;f<n[1].length;f++){let d=Math.ceil(o*n[1][f][1]),c=h+t;c+d>(e+1)*a&&(d=(e+1)*a-c,d<0&&(d=0)),C.fillStyle=D(n[1][f][0],p,c,d),C.fillRect(p,c,l,d),A&&C.strokeRect(p,c,l,d),h+=d}if(r>0)for(let f=0;f<n[0].length;f++){let d=Math.ceil(r*n[0][f][1]),c=F+h+t+b;c+d>(e+1)*a&&(d=(e+1)*a-c,d<0&&(d=0)),C.fillStyle=D(n[0][f][0],p,c,d),C.fillRect(p,c,l,d),A&&C.strokeRect(p,c,l,d),F+=d}}}}navigator.mediaDevices.getUserMedia({audio:!0}).then((e=>{let t=new y,f=t.createAnalyser();f.fftSize=2048,f.maxDecibels=-10,t.createMediaStreamSource(e).connect(f),requestAnimationFrame((function e(){f.getByteFrequencyData(i),B(),requestAnimationFrame(e)}))})).catch((e=>{console.log(e),alert('Microphone not found!\\nAudio capturing is recommended to fully enjoy Sensthesia')}));";
1086 
1087     //Hashes
1088     mapping(uint256 => bytes32) private _hashes;
1089 
1090     /**
1091      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1092      */
1093     constructor(string memory name_, string memory symbol_) {
1094         _name = name_;
1095         _symbol = symbol_;
1096         _safeMint(_fundsAddress);
1097     }
1098 
1099     /**
1100      * @dev See {IERC165-supportsInterface}.
1101      */
1102     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1103         return
1104         interfaceId == type(IERC721).interfaceId ||
1105         interfaceId == type(IERC721Metadata).interfaceId ||
1106         super.supportsInterface(interfaceId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-balanceOf}.
1111      */
1112     function balanceOf(address owner) public view virtual override returns (uint256) {
1113         require(owner != address(0), "ERC721: address zero is not a valid owner");
1114         return _balances[owner];
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-ownerOf}.
1119      */
1120     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1121         address owner = _ownerOf(tokenId);
1122         require(owner != address(0), "ERC721: invalid token ID");
1123         return owner;
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Metadata-name}.
1128      */
1129     function name() public view virtual override returns (string memory) {
1130         return _name;
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Metadata-symbol}.
1135      */
1136     function symbol() public view virtual override returns (string memory) {
1137         return _symbol;
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Metadata-tokenURI}.
1142      */
1143     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1144         _requireMinted(tokenId);
1145 
1146         string memory baseURI = _baseURI();
1147         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1148     }
1149 
1150     /**
1151      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1152      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1153      * by default, can be overridden in child contracts.
1154      */
1155     function _baseURI() internal view virtual returns (string memory) {
1156         return string(abi.encodePacked("https://token.zeblocks.com/", Strings.toHexString(address(this)), "/"));
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-approve}.
1161      */
1162     function approve(address to, uint256 tokenId) public virtual override onlyAllowedOperatorApproval(to) {
1163         address owner = ERC721.ownerOf(tokenId);
1164         require(to != owner, "ERC721: approval to current owner");
1165 
1166         require(
1167             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1168             "ERC721: approve caller is not token owner or approved for all"
1169         );
1170 
1171         _approve(to, tokenId);
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-getApproved}.
1176      */
1177     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1178         _requireMinted(tokenId);
1179 
1180         return _tokenApprovals[tokenId];
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-setApprovalForAll}.
1185      */
1186     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperatorApproval(operator) {
1187         _setApprovalForAll(_msgSender(), operator, approved);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-isApprovedForAll}.
1192      */
1193     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1194         return _operatorApprovals[owner][operator];
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-transferFrom}.
1199      */
1200     function transferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) public virtual override onlyAllowedOperator(from) {
1205         //solhint-disable-next-line max-line-length
1206         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1207 
1208         _transfer(from, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-safeTransferFrom}.
1213      */
1214     function safeTransferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) public virtual override onlyAllowedOperator(from) {
1219         safeTransferFrom(from, to, tokenId, "");
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-safeTransferFrom}.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId,
1229         bytes memory data
1230     ) public virtual override onlyAllowedOperator(from) {
1231         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1232         _safeTransfer(from, to, tokenId, data);
1233     }
1234 
1235     /**
1236      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1237      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1238      *
1239      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1240      *
1241      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1242      * implement alternative mechanisms to perform token transfer, such as signature-based.
1243      *
1244      * Requirements:
1245      *
1246      * - `from` cannot be the zero address.
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must exist and be owned by `from`.
1249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _safeTransfer(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory data
1258     ) internal virtual {
1259         _transfer(from, to, tokenId);
1260         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1261     }
1262 
1263     /**
1264      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1265      */
1266     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1267         return _owners[tokenId];
1268     }
1269 
1270     /**
1271      * @dev Returns whether `tokenId` exists.
1272      *
1273      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1274      *
1275      * Tokens start existing when they are minted (`_mint`),
1276      * and stop existing when they are burned (`_burn`).
1277      */
1278     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1279         return _ownerOf(tokenId) != address(0);
1280     }
1281 
1282     /**
1283      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1284      *
1285      * Requirements:
1286      *
1287      * - `tokenId` must exist.
1288      */
1289     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1290         address owner = ERC721.ownerOf(tokenId);
1291         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1292     }
1293 
1294     function mint() external payable {
1295         require(_isSale,"Sale is not active!");
1296 
1297         uint256 realPricePerMint = _pricePerMint;
1298         if(hasFreeMint(_msgSender())){
1299             realPricePerMint = 0;
1300             _fpWallets[_msgSender()]--;
1301             _fpCurrTokens++;
1302         }
1303 
1304         require((realPricePerMint == 0 && _currTokens < _maxTokens) || ((_currTokens - _fpCurrTokens) < (_maxTokens - _fpMaxTokens)),"Minted out!");
1305 
1306         require(msg.value >= realPricePerMint, "Minting below price!");
1307 
1308         uint256 refund = msg.value - realPricePerMint;
1309         if (refund > 0) {
1310             (bool success, ) = payable(_msgSender()).call{value:refund}("");
1311             require(success, "Refund tx failed.");
1312             }
1313         uint256 remaining = msg.value - refund;
1314         if(remaining > 0) {
1315             (bool success, ) = payable(_fundsAddress).call{value:remaining}("");
1316             require(success, "Tx to funds wallet failed.");
1317         }
1318 
1319         uint256 tokenId = _safeMint(_msgSender());
1320         emit Mint(_msgSender(), tokenId, realPricePerMint);
1321     }
1322 
1323 
1324     /**
1325      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1326      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1327      */
1328     function _safeMint(
1329         address to
1330     ) internal virtual returns (uint256 _tokenId){
1331         uint256 tokenId = _mint(to);
1332         require(
1333             _checkOnERC721Received(address(0), to, tokenId, ""),
1334             "ERC721: transfer to non ERC721Receiver implementer"
1335         );
1336         return tokenId;
1337     }
1338 
1339     /**
1340      * @dev Mints `tokenId` and transfers it to `to`.
1341      *
1342      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1343      *
1344      * Requirements:
1345      *
1346      * - `tokenId` must not exist.
1347      * - `to` cannot be the zero address.
1348      *
1349      * Emits a {Transfer} event.
1350      */
1351     function _mint(address to) internal virtual returns (uint256 _tokenId) {
1352 
1353     unchecked {
1354         // Will not overflow unless all 2**256 token ids are minted to the same owner.
1355         // Given that tokens are minted one by one, it is impossible in practice that
1356         // this ever happens. Might change if we allow batch minting.
1357         // The ERC fails to describe this case.
1358         _balances[to] += 1;
1359     }
1360         uint256 tokenId = _currTokens;
1361         _owners[tokenId] = to;
1362         _currTokens++;
1363         bytes32 hash = keccak256(abi.encodePacked(_currTokens, block.number, blockhash(block.number - 3), _msgSender(), block.timestamp, block.coinbase));
1364         _hashes[tokenId] = hash;
1365 
1366         emit Transfer(address(0), to, tokenId);
1367 
1368         return tokenId;
1369     }
1370 
1371     /**
1372      * @dev Transfers `tokenId` from `from` to `to`.
1373      *  As opposed to {transferFrom}, this imposes no restrictions on _msgSender().
1374      *
1375      * Requirements:
1376      *
1377      * - `to` cannot be the zero address.
1378      * - `tokenId` token must be owned by `from`.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _transfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) internal virtual {
1387         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1388         require(to != address(0), "ERC721: transfer to the zero address");
1389 
1390 
1391         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1392         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1393 
1394         // Clear approvals from the previous owner
1395         delete _tokenApprovals[tokenId];
1396 
1397     unchecked {
1398         // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1399         // `from`'s balance is the number of token held, which is at least one before the current
1400         // transfer.
1401         // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1402         // all 2**256 token ids to be minted, which in practice is impossible.
1403         _balances[from] -= 1;
1404         _balances[to] += 1;
1405     }
1406         _owners[tokenId] = to;
1407 
1408         emit Transfer(from, to, tokenId);
1409 
1410     }
1411 
1412     /**
1413      * @dev Approve `to` to operate on `tokenId`
1414      *
1415      * Emits an {Approval} event.
1416      */
1417     function _approve(address to, uint256 tokenId) internal virtual {
1418         _tokenApprovals[tokenId] = to;
1419         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1420     }
1421 
1422     /**
1423      * @dev Approve `operator` to operate on all of `owner` tokens
1424      *
1425      * Emits an {ApprovalForAll} event.
1426      */
1427     function _setApprovalForAll(
1428         address owner,
1429         address operator,
1430         bool approved
1431     ) internal virtual {
1432         require(owner != operator, "ERC721: approve to caller");
1433         _operatorApprovals[owner][operator] = approved;
1434         emit ApprovalForAll(owner, operator, approved);
1435     }
1436 
1437     /**
1438      * @dev Reverts if the `tokenId` has not been minted yet.
1439      */
1440     function _requireMinted(uint256 tokenId) internal view virtual {
1441         require(_exists(tokenId), "ERC721: invalid token ID");
1442     }
1443 
1444     /**
1445      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1446      * The call is not executed if the target address is not a contract.
1447      *
1448      * @param from address representing the previous owner of the given token ID
1449      * @param to target address that will receive the tokens
1450      * @param tokenId uint256 ID of the token to be transferred
1451      * @param data bytes optional data to send along with the call
1452      * @return bool whether the call correctly returned the expected magic value
1453      */
1454     function _checkOnERC721Received(
1455         address from,
1456         address to,
1457         uint256 tokenId,
1458         bytes memory data
1459     ) private returns (bool) {
1460         if (to.isContract()) {
1461             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1462                 return retval == IERC721Receiver.onERC721Received.selector;
1463             } catch (bytes memory reason) {
1464                 if (reason.length == 0) {
1465                     revert("ERC721: transfer to non ERC721Receiver implementer");
1466                 } else {
1467                     /// @solidity memory-safe-assembly
1468                     assembly {
1469                         revert(add(32, reason), mload(reason))
1470                     }
1471                 }
1472             }
1473         } else {
1474             return true;
1475         }
1476     }
1477 
1478     function setIsSale(bool isSale) external onlyOwner {
1479         _isSale = isSale;
1480     }
1481 
1482     function getIsSale() public view returns (bool) {
1483         return _isSale;
1484     }
1485 
1486     function setPricePerMint(uint256 pricePerMint) external onlyOwner {
1487         _pricePerMint = pricePerMint;
1488     }
1489 
1490     function getPricePerMint() public view returns (uint256){
1491         return _pricePerMint;
1492     }
1493 
1494     function setFpWallets(address[] memory wallets, uint256[] memory allocations) external onlyOwner {
1495         require(wallets.length==allocations.length, "Array mismatch!");
1496         for(uint i=0;i<wallets.length;i++){
1497             _fpWallets[wallets[i]] = allocations[i];
1498         }
1499     }
1500 
1501     function getScript(uint256 tokenId) public view returns (string memory){
1502         _requireMinted(tokenId);
1503         return string(abi.encodePacked("let hash='",Strings.toHexString(uint256(_hashes[tokenId]), 32),"';", _script));
1504     }
1505 
1506     function getHash(uint256 tokenId) public view returns (bytes32){
1507         _requireMinted(tokenId);
1508         return _hashes[tokenId];
1509     }
1510 
1511     function totalSupply() public view returns (uint256){
1512         return _currTokens;
1513     }
1514 
1515     function getMaxSupply() public pure returns (uint256){
1516         return _maxTokens;
1517     }
1518 
1519     function fpTotalSupply() public view returns (uint256){
1520         return _fpCurrTokens;
1521     }
1522 
1523     function getFpMaxSupply() public pure returns (uint256){
1524         return _fpMaxTokens;
1525     }
1526 
1527     function hasFreeMint(address wallet) public view returns (bool){
1528         return (_fpCurrTokens < _fpMaxTokens && _fpWallets[wallet] > 0);
1529     }
1530 }