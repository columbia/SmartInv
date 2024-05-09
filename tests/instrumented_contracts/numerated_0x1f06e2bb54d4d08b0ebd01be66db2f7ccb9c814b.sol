1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Counters.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @title Counters
95  * @author Matt Condon (@shrugs)
96  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
97  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
98  *
99  * Include with `using Counters for Counters.Counter;`
100  */
101 library Counters {
102     struct Counter {
103         // This variable should never be directly accessed by users of the library: interactions must be restricted to
104         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
105         // this feature: see https://github.com/ethereum/solidity/issues/4637
106         uint256 _value; // default: 0
107     }
108 
109     function current(Counter storage counter) internal view returns (uint256) {
110         return counter._value;
111     }
112 
113     function increment(Counter storage counter) internal {
114         unchecked {
115             counter._value += 1;
116         }
117     }
118 
119     function decrement(Counter storage counter) internal {
120         uint256 value = counter._value;
121         require(value > 0, "Counter: decrement overflow");
122         unchecked {
123             counter._value = value - 1;
124         }
125     }
126 
127     function reset(Counter storage counter) internal {
128         counter._value = 0;
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/math/Math.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Standard math utilities missing in the Solidity language.
141  */
142 library Math {
143     enum Rounding {
144         Down, // Toward negative infinity
145         Up, // Toward infinity
146         Zero // Toward zero
147     }
148 
149     /**
150      * @dev Returns the largest of two numbers.
151      */
152     function max(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a > b ? a : b;
154     }
155 
156     /**
157      * @dev Returns the smallest of two numbers.
158      */
159     function min(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a < b ? a : b;
161     }
162 
163     /**
164      * @dev Returns the average of two numbers. The result is rounded towards
165      * zero.
166      */
167     function average(uint256 a, uint256 b) internal pure returns (uint256) {
168         // (a + b) / 2 can overflow.
169         return (a & b) + (a ^ b) / 2;
170     }
171 
172     /**
173      * @dev Returns the ceiling of the division of two numbers.
174      *
175      * This differs from standard division with `/` in that it rounds up instead
176      * of rounding down.
177      */
178     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
179         // (a + b - 1) / b can overflow on addition, so we distribute.
180         return a == 0 ? 0 : (a - 1) / b + 1;
181     }
182 
183     /**
184      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
185      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
186      * with further edits by Uniswap Labs also under MIT license.
187      */
188     function mulDiv(
189         uint256 x,
190         uint256 y,
191         uint256 denominator
192     ) internal pure returns (uint256 result) {
193         unchecked {
194             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
195             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
196             // variables such that product = prod1 * 2^256 + prod0.
197             uint256 prod0; // Least significant 256 bits of the product
198             uint256 prod1; // Most significant 256 bits of the product
199             assembly {
200                 let mm := mulmod(x, y, not(0))
201                 prod0 := mul(x, y)
202                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
203             }
204 
205             // Handle non-overflow cases, 256 by 256 division.
206             if (prod1 == 0) {
207                 return prod0 / denominator;
208             }
209 
210             // Make sure the result is less than 2^256. Also prevents denominator == 0.
211             require(denominator > prod1);
212 
213             ///////////////////////////////////////////////
214             // 512 by 256 division.
215             ///////////////////////////////////////////////
216 
217             // Make division exact by subtracting the remainder from [prod1 prod0].
218             uint256 remainder;
219             assembly {
220                 // Compute remainder using mulmod.
221                 remainder := mulmod(x, y, denominator)
222 
223                 // Subtract 256 bit number from 512 bit number.
224                 prod1 := sub(prod1, gt(remainder, prod0))
225                 prod0 := sub(prod0, remainder)
226             }
227 
228             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
229             // See https://cs.stackexchange.com/q/138556/92363.
230 
231             // Does not overflow because the denominator cannot be zero at this stage in the function.
232             uint256 twos = denominator & (~denominator + 1);
233             assembly {
234                 // Divide denominator by twos.
235                 denominator := div(denominator, twos)
236 
237                 // Divide [prod1 prod0] by twos.
238                 prod0 := div(prod0, twos)
239 
240                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
241                 twos := add(div(sub(0, twos), twos), 1)
242             }
243 
244             // Shift in bits from prod1 into prod0.
245             prod0 |= prod1 * twos;
246 
247             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
248             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
249             // four bits. That is, denominator * inv = 1 mod 2^4.
250             uint256 inverse = (3 * denominator) ^ 2;
251 
252             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
253             // in modular arithmetic, doubling the correct bits in each step.
254             inverse *= 2 - denominator * inverse; // inverse mod 2^8
255             inverse *= 2 - denominator * inverse; // inverse mod 2^16
256             inverse *= 2 - denominator * inverse; // inverse mod 2^32
257             inverse *= 2 - denominator * inverse; // inverse mod 2^64
258             inverse *= 2 - denominator * inverse; // inverse mod 2^128
259             inverse *= 2 - denominator * inverse; // inverse mod 2^256
260 
261             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
262             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
263             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
264             // is no longer required.
265             result = prod0 * inverse;
266             return result;
267         }
268     }
269 
270     /**
271      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
272      */
273     function mulDiv(
274         uint256 x,
275         uint256 y,
276         uint256 denominator,
277         Rounding rounding
278     ) internal pure returns (uint256) {
279         uint256 result = mulDiv(x, y, denominator);
280         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
281             result += 1;
282         }
283         return result;
284     }
285 
286     /**
287      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
288      *
289      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
290      */
291     function sqrt(uint256 a) internal pure returns (uint256) {
292         if (a == 0) {
293             return 0;
294         }
295 
296         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
297         //
298         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
299         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
300         //
301         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
302         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
303         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
304         //
305         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
306         uint256 result = 1 << (log2(a) >> 1);
307 
308         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
309         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
310         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
311         // into the expected uint128 result.
312         unchecked {
313             result = (result + a / result) >> 1;
314             result = (result + a / result) >> 1;
315             result = (result + a / result) >> 1;
316             result = (result + a / result) >> 1;
317             result = (result + a / result) >> 1;
318             result = (result + a / result) >> 1;
319             result = (result + a / result) >> 1;
320             return min(result, a / result);
321         }
322     }
323 
324     /**
325      * @notice Calculates sqrt(a), following the selected rounding direction.
326      */
327     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
328         unchecked {
329             uint256 result = sqrt(a);
330             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
331         }
332     }
333 
334     /**
335      * @dev Return the log in base 2, rounded down, of a positive value.
336      * Returns 0 if given 0.
337      */
338     function log2(uint256 value) internal pure returns (uint256) {
339         uint256 result = 0;
340         unchecked {
341             if (value >> 128 > 0) {
342                 value >>= 128;
343                 result += 128;
344             }
345             if (value >> 64 > 0) {
346                 value >>= 64;
347                 result += 64;
348             }
349             if (value >> 32 > 0) {
350                 value >>= 32;
351                 result += 32;
352             }
353             if (value >> 16 > 0) {
354                 value >>= 16;
355                 result += 16;
356             }
357             if (value >> 8 > 0) {
358                 value >>= 8;
359                 result += 8;
360             }
361             if (value >> 4 > 0) {
362                 value >>= 4;
363                 result += 4;
364             }
365             if (value >> 2 > 0) {
366                 value >>= 2;
367                 result += 2;
368             }
369             if (value >> 1 > 0) {
370                 result += 1;
371             }
372         }
373         return result;
374     }
375 
376     /**
377      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
378      * Returns 0 if given 0.
379      */
380     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
381         unchecked {
382             uint256 result = log2(value);
383             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
384         }
385     }
386 
387     /**
388      * @dev Return the log in base 10, rounded down, of a positive value.
389      * Returns 0 if given 0.
390      */
391     function log10(uint256 value) internal pure returns (uint256) {
392         uint256 result = 0;
393         unchecked {
394             if (value >= 10**64) {
395                 value /= 10**64;
396                 result += 64;
397             }
398             if (value >= 10**32) {
399                 value /= 10**32;
400                 result += 32;
401             }
402             if (value >= 10**16) {
403                 value /= 10**16;
404                 result += 16;
405             }
406             if (value >= 10**8) {
407                 value /= 10**8;
408                 result += 8;
409             }
410             if (value >= 10**4) {
411                 value /= 10**4;
412                 result += 4;
413             }
414             if (value >= 10**2) {
415                 value /= 10**2;
416                 result += 2;
417             }
418             if (value >= 10**1) {
419                 result += 1;
420             }
421         }
422         return result;
423     }
424 
425     /**
426      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
427      * Returns 0 if given 0.
428      */
429     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
430         unchecked {
431             uint256 result = log10(value);
432             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
433         }
434     }
435 
436     /**
437      * @dev Return the log in base 256, rounded down, of a positive value.
438      * Returns 0 if given 0.
439      *
440      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
441      */
442     function log256(uint256 value) internal pure returns (uint256) {
443         uint256 result = 0;
444         unchecked {
445             if (value >> 128 > 0) {
446                 value >>= 128;
447                 result += 16;
448             }
449             if (value >> 64 > 0) {
450                 value >>= 64;
451                 result += 8;
452             }
453             if (value >> 32 > 0) {
454                 value >>= 32;
455                 result += 4;
456             }
457             if (value >> 16 > 0) {
458                 value >>= 16;
459                 result += 2;
460             }
461             if (value >> 8 > 0) {
462                 result += 1;
463             }
464         }
465         return result;
466     }
467 
468     /**
469      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
470      * Returns 0 if given 0.
471      */
472     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
473         unchecked {
474             uint256 result = log256(value);
475             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/Strings.sol
481 
482 
483 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev String operations.
490  */
491 library Strings {
492     bytes16 private constant _SYMBOLS = "0123456789abcdef";
493     uint8 private constant _ADDRESS_LENGTH = 20;
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
497      */
498     function toString(uint256 value) internal pure returns (string memory) {
499         unchecked {
500             uint256 length = Math.log10(value) + 1;
501             string memory buffer = new string(length);
502             uint256 ptr;
503             /// @solidity memory-safe-assembly
504             assembly {
505                 ptr := add(buffer, add(32, length))
506             }
507             while (true) {
508                 ptr--;
509                 /// @solidity memory-safe-assembly
510                 assembly {
511                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
512                 }
513                 value /= 10;
514                 if (value == 0) break;
515             }
516             return buffer;
517         }
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
522      */
523     function toHexString(uint256 value) internal pure returns (string memory) {
524         unchecked {
525             return toHexString(value, Math.log256(value) + 1);
526         }
527     }
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
531      */
532     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
533         bytes memory buffer = new bytes(2 * length + 2);
534         buffer[0] = "0";
535         buffer[1] = "x";
536         for (uint256 i = 2 * length + 1; i > 1; --i) {
537             buffer[i] = _SYMBOLS[value & 0xf];
538             value >>= 4;
539         }
540         require(value == 0, "Strings: hex length insufficient");
541         return string(buffer);
542     }
543 
544     /**
545      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
546      */
547     function toHexString(address addr) internal pure returns (string memory) {
548         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
549     }
550 }
551 
552 // File: @openzeppelin/contracts/utils/Context.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev Provides information about the current execution context, including the
561  * sender of the transaction and its data. While these are generally available
562  * via msg.sender and msg.data, they should not be accessed in such a direct
563  * manner, since when dealing with meta-transactions the account sending and
564  * paying for execution may not be the actual sender (as far as an application
565  * is concerned).
566  *
567  * This contract is only required for intermediate, library-like contracts.
568  */
569 abstract contract Context {
570     function _msgSender() internal view virtual returns (address) {
571         return msg.sender;
572     }
573 
574     function _msgData() internal view virtual returns (bytes calldata) {
575         return msg.data;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/utils/Address.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
583 
584 pragma solidity ^0.8.1;
585 
586 /**
587  * @dev Collection of functions related to the address type
588  */
589 library Address {
590     /**
591      * @dev Returns true if `account` is a contract.
592      *
593      * [IMPORTANT]
594      * ====
595      * It is unsafe to assume that an address for which this function returns
596      * false is an externally-owned account (EOA) and not a contract.
597      *
598      * Among others, `isContract` will return false for the following
599      * types of addresses:
600      *
601      *  - an externally-owned account
602      *  - a contract in construction
603      *  - an address where a contract will be created
604      *  - an address where a contract lived, but was destroyed
605      * ====
606      *
607      * [IMPORTANT]
608      * ====
609      * You shouldn't rely on `isContract` to protect against flash loan attacks!
610      *
611      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
612      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
613      * constructor.
614      * ====
615      */
616     function isContract(address account) internal view returns (bool) {
617         // This method relies on extcodesize/address.code.length, which returns 0
618         // for contracts in construction, since the code is only stored at the end
619         // of the constructor execution.
620 
621         return account.code.length > 0;
622     }
623 
624     /**
625      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
626      * `recipient`, forwarding all available gas and reverting on errors.
627      *
628      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
629      * of certain opcodes, possibly making contracts go over the 2300 gas limit
630      * imposed by `transfer`, making them unable to receive funds via
631      * `transfer`. {sendValue} removes this limitation.
632      *
633      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
634      *
635      * IMPORTANT: because control is transferred to `recipient`, care must be
636      * taken to not create reentrancy vulnerabilities. Consider using
637      * {ReentrancyGuard} or the
638      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
639      */
640     function sendValue(address payable recipient, uint256 amount) internal {
641         require(address(this).balance >= amount, "Address: insufficient balance");
642 
643         (bool success, ) = recipient.call{value: amount}("");
644         require(success, "Address: unable to send value, recipient may have reverted");
645     }
646 
647     /**
648      * @dev Performs a Solidity function call using a low level `call`. A
649      * plain `call` is an unsafe replacement for a function call: use this
650      * function instead.
651      *
652      * If `target` reverts with a revert reason, it is bubbled up by this
653      * function (like regular Solidity function calls).
654      *
655      * Returns the raw returned data. To convert to the expected return value,
656      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
657      *
658      * Requirements:
659      *
660      * - `target` must be a contract.
661      * - calling `target` with `data` must not revert.
662      *
663      * _Available since v3.1._
664      */
665     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
666         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
671      * `errorMessage` as a fallback revert reason when `target` reverts.
672      *
673      * _Available since v3.1._
674      */
675     function functionCall(
676         address target,
677         bytes memory data,
678         string memory errorMessage
679     ) internal returns (bytes memory) {
680         return functionCallWithValue(target, data, 0, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but also transferring `value` wei to `target`.
686      *
687      * Requirements:
688      *
689      * - the calling contract must have an ETH balance of at least `value`.
690      * - the called Solidity function must be `payable`.
691      *
692      * _Available since v3.1._
693      */
694     function functionCallWithValue(
695         address target,
696         bytes memory data,
697         uint256 value
698     ) internal returns (bytes memory) {
699         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
704      * with `errorMessage` as a fallback revert reason when `target` reverts.
705      *
706      * _Available since v3.1._
707      */
708     function functionCallWithValue(
709         address target,
710         bytes memory data,
711         uint256 value,
712         string memory errorMessage
713     ) internal returns (bytes memory) {
714         require(address(this).balance >= value, "Address: insufficient balance for call");
715         (bool success, bytes memory returndata) = target.call{value: value}(data);
716         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
721      * but performing a static call.
722      *
723      * _Available since v3.3._
724      */
725     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
726         return functionStaticCall(target, data, "Address: low-level static call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
731      * but performing a static call.
732      *
733      * _Available since v3.3._
734      */
735     function functionStaticCall(
736         address target,
737         bytes memory data,
738         string memory errorMessage
739     ) internal view returns (bytes memory) {
740         (bool success, bytes memory returndata) = target.staticcall(data);
741         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
746      * but performing a delegate call.
747      *
748      * _Available since v3.4._
749      */
750     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
751         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
756      * but performing a delegate call.
757      *
758      * _Available since v3.4._
759      */
760     function functionDelegateCall(
761         address target,
762         bytes memory data,
763         string memory errorMessage
764     ) internal returns (bytes memory) {
765         (bool success, bytes memory returndata) = target.delegatecall(data);
766         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
771      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
772      *
773      * _Available since v4.8._
774      */
775     function verifyCallResultFromTarget(
776         address target,
777         bool success,
778         bytes memory returndata,
779         string memory errorMessage
780     ) internal view returns (bytes memory) {
781         if (success) {
782             if (returndata.length == 0) {
783                 // only check isContract if the call was successful and the return data is empty
784                 // otherwise we already know that it was a contract
785                 require(isContract(target), "Address: call to non-contract");
786             }
787             return returndata;
788         } else {
789             _revert(returndata, errorMessage);
790         }
791     }
792 
793     /**
794      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
795      * revert reason or using the provided one.
796      *
797      * _Available since v4.3._
798      */
799     function verifyCallResult(
800         bool success,
801         bytes memory returndata,
802         string memory errorMessage
803     ) internal pure returns (bytes memory) {
804         if (success) {
805             return returndata;
806         } else {
807             _revert(returndata, errorMessage);
808         }
809     }
810 
811     function _revert(bytes memory returndata, string memory errorMessage) private pure {
812         // Look for revert reason and bubble it up if present
813         if (returndata.length > 0) {
814             // The easiest way to bubble the revert reason is using memory via assembly
815             /// @solidity memory-safe-assembly
816             assembly {
817                 let returndata_size := mload(returndata)
818                 revert(add(32, returndata), returndata_size)
819             }
820         } else {
821             revert(errorMessage);
822         }
823     }
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
827 
828 
829 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
830 
831 pragma solidity ^0.8.0;
832 
833 /**
834  * @title ERC721 token receiver interface
835  * @dev Interface for any contract that wants to support safeTransfers
836  * from ERC721 asset contracts.
837  */
838 interface IERC721Receiver {
839     /**
840      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
841      * by `operator` from `from`, this function is called.
842      *
843      * It must return its Solidity selector to confirm the token transfer.
844      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
845      *
846      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
847      */
848     function onERC721Received(
849         address operator,
850         address from,
851         uint256 tokenId,
852         bytes calldata data
853     ) external returns (bytes4);
854 }
855 
856 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
857 
858 
859 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
860 
861 pragma solidity ^0.8.0;
862 
863 /**
864  * @dev Interface of the ERC165 standard, as defined in the
865  * https://eips.ethereum.org/EIPS/eip-165[EIP].
866  *
867  * Implementers can declare support of contract interfaces, which can then be
868  * queried by others ({ERC165Checker}).
869  *
870  * For an implementation, see {ERC165}.
871  */
872 interface IERC165 {
873     /**
874      * @dev Returns true if this contract implements the interface defined by
875      * `interfaceId`. See the corresponding
876      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
877      * to learn more about how these ids are created.
878      *
879      * This function call must use less than 30 000 gas.
880      */
881     function supportsInterface(bytes4 interfaceId) external view returns (bool);
882 }
883 
884 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
885 
886 
887 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 
892 /**
893  * @dev Implementation of the {IERC165} interface.
894  *
895  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
896  * for the additional interface id that will be supported. For example:
897  *
898  * ```solidity
899  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
900  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
901  * }
902  * ```
903  *
904  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
905  */
906 abstract contract ERC165 is IERC165 {
907     /**
908      * @dev See {IERC165-supportsInterface}.
909      */
910     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
911         return interfaceId == type(IERC165).interfaceId;
912     }
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
916 
917 
918 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @dev Required interface of an ERC721 compliant contract.
925  */
926 interface IERC721 is IERC165 {
927     /**
928      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
929      */
930     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
931 
932     /**
933      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
934      */
935     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
936 
937     /**
938      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
939      */
940     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
941 
942     /**
943      * @dev Returns the number of tokens in ``owner``'s account.
944      */
945     function balanceOf(address owner) external view returns (uint256 balance);
946 
947     /**
948      * @dev Returns the owner of the `tokenId` token.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must exist.
953      */
954     function ownerOf(uint256 tokenId) external view returns (address owner);
955 
956     /**
957      * @dev Safely transfers `tokenId` token from `from` to `to`.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must exist and be owned by `from`.
964      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes calldata data
974     ) external;
975 
976     /**
977      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
978      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must exist and be owned by `from`.
985      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
987      *
988      * Emits a {Transfer} event.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) external;
995 
996     /**
997      * @dev Transfers `tokenId` token from `from` to `to`.
998      *
999      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1000      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1001      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) external;
1017 
1018     /**
1019      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1020      * The approval is cleared when the token is transferred.
1021      *
1022      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1023      *
1024      * Requirements:
1025      *
1026      * - The caller must own the token or be an approved operator.
1027      * - `tokenId` must exist.
1028      *
1029      * Emits an {Approval} event.
1030      */
1031     function approve(address to, uint256 tokenId) external;
1032 
1033     /**
1034      * @dev Approve or remove `operator` as an operator for the caller.
1035      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1036      *
1037      * Requirements:
1038      *
1039      * - The `operator` cannot be the caller.
1040      *
1041      * Emits an {ApprovalForAll} event.
1042      */
1043     function setApprovalForAll(address operator, bool _approved) external;
1044 
1045     /**
1046      * @dev Returns the account approved for `tokenId` token.
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must exist.
1051      */
1052     function getApproved(uint256 tokenId) external view returns (address operator);
1053 
1054     /**
1055      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1056      *
1057      * See {setApprovalForAll}
1058      */
1059     function isApprovedForAll(address owner, address operator) external view returns (bool);
1060 }
1061 
1062 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1063 
1064 
1065 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1066 
1067 pragma solidity ^0.8.0;
1068 
1069 
1070 /**
1071  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1072  * @dev See https://eips.ethereum.org/EIPS/eip-721
1073  */
1074 interface IERC721Metadata is IERC721 {
1075     /**
1076      * @dev Returns the token collection name.
1077      */
1078     function name() external view returns (string memory);
1079 
1080     /**
1081      * @dev Returns the token collection symbol.
1082      */
1083     function symbol() external view returns (string memory);
1084 
1085     /**
1086      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1087      */
1088     function tokenURI(uint256 tokenId) external view returns (string memory);
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1092 
1093 
1094 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1095 
1096 pragma solidity ^0.8.0;
1097 
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 /**
1106  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1107  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1108  * {ERC721Enumerable}.
1109  */
1110 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1111     using Address for address;
1112     using Strings for uint256;
1113 
1114     // Token name
1115     string private _name;
1116 
1117     // Token symbol
1118     string private _symbol;
1119 
1120     // Mapping from token ID to owner address
1121     mapping(uint256 => address) private _owners;
1122 
1123     // Mapping owner address to token count
1124     mapping(address => uint256) private _balances;
1125 
1126     // Mapping from token ID to approved address
1127     mapping(uint256 => address) private _tokenApprovals;
1128 
1129     // Mapping from owner to operator approvals
1130     mapping(address => mapping(address => bool)) private _operatorApprovals;
1131 
1132     /**
1133      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1134      */
1135     constructor(string memory name_, string memory symbol_) {
1136         _name = name_;
1137         _symbol = symbol_;
1138     }
1139 
1140     /**
1141      * @dev See {IERC165-supportsInterface}.
1142      */
1143     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1144         return
1145             interfaceId == type(IERC721).interfaceId ||
1146             interfaceId == type(IERC721Metadata).interfaceId ||
1147             super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-balanceOf}.
1152      */
1153     function balanceOf(address owner) public view virtual override returns (uint256) {
1154         require(owner != address(0), "ERC721: address zero is not a valid owner");
1155         return _balances[owner];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-ownerOf}.
1160      */
1161     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1162         address owner = _ownerOf(tokenId);
1163         require(owner != address(0), "ERC721: invalid token ID");
1164         return owner;
1165     }
1166 
1167     /**
1168      * @dev See {IERC721Metadata-name}.
1169      */
1170     function name() public view virtual override returns (string memory) {
1171         return _name;
1172     }
1173 
1174     /**
1175      * @dev See {IERC721Metadata-symbol}.
1176      */
1177     function symbol() public view virtual override returns (string memory) {
1178         return _symbol;
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Metadata-tokenURI}.
1183      */
1184     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1185         _requireMinted(tokenId);
1186 
1187         string memory baseURI = _baseURI();
1188         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1189     }
1190 
1191     /**
1192      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1193      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1194      * by default, can be overridden in child contracts.
1195      */
1196     function _baseURI() internal view virtual returns (string memory) {
1197         return "";
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-approve}.
1202      */
1203     function approve(address to, uint256 tokenId) public virtual override {
1204         address owner = ERC721.ownerOf(tokenId);
1205         require(to != owner, "ERC721: approval to current owner");
1206 
1207         require(
1208             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1209             "ERC721: approve caller is not token owner or approved for all"
1210         );
1211 
1212         _approve(to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-getApproved}.
1217      */
1218     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1219         _requireMinted(tokenId);
1220 
1221         return _tokenApprovals[tokenId];
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-setApprovalForAll}.
1226      */
1227     function setApprovalForAll(address operator, bool approved) public virtual override {
1228         _setApprovalForAll(_msgSender(), operator, approved);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-isApprovedForAll}.
1233      */
1234     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1235         return _operatorApprovals[owner][operator];
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-transferFrom}.
1240      */
1241     function transferFrom(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) public virtual override {
1246         //solhint-disable-next-line max-line-length
1247         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1248 
1249         _transfer(from, to, tokenId);
1250     }
1251 
1252     /**
1253      * @dev See {IERC721-safeTransferFrom}.
1254      */
1255     function safeTransferFrom(
1256         address from,
1257         address to,
1258         uint256 tokenId
1259     ) public virtual override {
1260         safeTransferFrom(from, to, tokenId, "");
1261     }
1262 
1263     /**
1264      * @dev See {IERC721-safeTransferFrom}.
1265      */
1266     function safeTransferFrom(
1267         address from,
1268         address to,
1269         uint256 tokenId,
1270         bytes memory data
1271     ) public virtual override {
1272         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1273         _safeTransfer(from, to, tokenId, data);
1274     }
1275 
1276     /**
1277      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1278      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1279      *
1280      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1281      *
1282      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1283      * implement alternative mechanisms to perform token transfer, such as signature-based.
1284      *
1285      * Requirements:
1286      *
1287      * - `from` cannot be the zero address.
1288      * - `to` cannot be the zero address.
1289      * - `tokenId` token must exist and be owned by `from`.
1290      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function _safeTransfer(
1295         address from,
1296         address to,
1297         uint256 tokenId,
1298         bytes memory data
1299     ) internal virtual {
1300         _transfer(from, to, tokenId);
1301         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1302     }
1303 
1304     /**
1305      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1306      */
1307     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1308         return _owners[tokenId];
1309     }
1310 
1311     /**
1312      * @dev Returns whether `tokenId` exists.
1313      *
1314      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1315      *
1316      * Tokens start existing when they are minted (`_mint`),
1317      * and stop existing when they are burned (`_burn`).
1318      */
1319     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1320         return _ownerOf(tokenId) != address(0);
1321     }
1322 
1323     /**
1324      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1325      *
1326      * Requirements:
1327      *
1328      * - `tokenId` must exist.
1329      */
1330     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1331         address owner = ERC721.ownerOf(tokenId);
1332         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1333     }
1334 
1335     /**
1336      * @dev Safely mints `tokenId` and transfers it to `to`.
1337      *
1338      * Requirements:
1339      *
1340      * - `tokenId` must not exist.
1341      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function _safeMint(address to, uint256 tokenId) internal virtual {
1346         _safeMint(to, tokenId, "");
1347     }
1348 
1349     /**
1350      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1351      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1352      */
1353     function _safeMint(
1354         address to,
1355         uint256 tokenId,
1356         bytes memory data
1357     ) internal virtual {
1358         _mint(to, tokenId);
1359         require(
1360             _checkOnERC721Received(address(0), to, tokenId, data),
1361             "ERC721: transfer to non ERC721Receiver implementer"
1362         );
1363     }
1364 
1365     /**
1366      * @dev Mints `tokenId` and transfers it to `to`.
1367      *
1368      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1369      *
1370      * Requirements:
1371      *
1372      * - `tokenId` must not exist.
1373      * - `to` cannot be the zero address.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function _mint(address to, uint256 tokenId) internal virtual {
1378         require(to != address(0), "ERC721: mint to the zero address");
1379         require(!_exists(tokenId), "ERC721: token already minted");
1380 
1381         _beforeTokenTransfer(address(0), to, tokenId, 1);
1382 
1383         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1384         require(!_exists(tokenId), "ERC721: token already minted");
1385 
1386         unchecked {
1387             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1388             // Given that tokens are minted one by one, it is impossible in practice that
1389             // this ever happens. Might change if we allow batch minting.
1390             // The ERC fails to describe this case.
1391             _balances[to] += 1;
1392         }
1393 
1394         _owners[tokenId] = to;
1395 
1396         emit Transfer(address(0), to, tokenId);
1397 
1398         _afterTokenTransfer(address(0), to, tokenId, 1);
1399     }
1400 
1401     /**
1402      * @dev Destroys `tokenId`.
1403      * The approval is cleared when the token is burned.
1404      * This is an internal function that does not check if the sender is authorized to operate on the token.
1405      *
1406      * Requirements:
1407      *
1408      * - `tokenId` must exist.
1409      *
1410      * Emits a {Transfer} event.
1411      */
1412     function _burn(uint256 tokenId) internal virtual {
1413         address owner = ERC721.ownerOf(tokenId);
1414 
1415         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1416 
1417         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1418         owner = ERC721.ownerOf(tokenId);
1419 
1420         // Clear approvals
1421         delete _tokenApprovals[tokenId];
1422 
1423         unchecked {
1424             // Cannot overflow, as that would require more tokens to be burned/transferred
1425             // out than the owner initially received through minting and transferring in.
1426             _balances[owner] -= 1;
1427         }
1428         delete _owners[tokenId];
1429 
1430         emit Transfer(owner, address(0), tokenId);
1431 
1432         _afterTokenTransfer(owner, address(0), tokenId, 1);
1433     }
1434 
1435     /**
1436      * @dev Transfers `tokenId` from `from` to `to`.
1437      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1438      *
1439      * Requirements:
1440      *
1441      * - `to` cannot be the zero address.
1442      * - `tokenId` token must be owned by `from`.
1443      *
1444      * Emits a {Transfer} event.
1445      */
1446     function _transfer(
1447         address from,
1448         address to,
1449         uint256 tokenId
1450     ) internal virtual {
1451         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1452         require(to != address(0), "ERC721: transfer to the zero address");
1453 
1454         _beforeTokenTransfer(from, to, tokenId, 1);
1455 
1456         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1457         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1458 
1459         // Clear approvals from the previous owner
1460         delete _tokenApprovals[tokenId];
1461 
1462         unchecked {
1463             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1464             // `from`'s balance is the number of token held, which is at least one before the current
1465             // transfer.
1466             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1467             // all 2**256 token ids to be minted, which in practice is impossible.
1468             _balances[from] -= 1;
1469             _balances[to] += 1;
1470         }
1471         _owners[tokenId] = to;
1472 
1473         emit Transfer(from, to, tokenId);
1474 
1475         _afterTokenTransfer(from, to, tokenId, 1);
1476     }
1477 
1478     /**
1479      * @dev Approve `to` to operate on `tokenId`
1480      *
1481      * Emits an {Approval} event.
1482      */
1483     function _approve(address to, uint256 tokenId) internal virtual {
1484         _tokenApprovals[tokenId] = to;
1485         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1486     }
1487 
1488     /**
1489      * @dev Approve `operator` to operate on all of `owner` tokens
1490      *
1491      * Emits an {ApprovalForAll} event.
1492      */
1493     function _setApprovalForAll(
1494         address owner,
1495         address operator,
1496         bool approved
1497     ) internal virtual {
1498         require(owner != operator, "ERC721: approve to caller");
1499         _operatorApprovals[owner][operator] = approved;
1500         emit ApprovalForAll(owner, operator, approved);
1501     }
1502 
1503     /**
1504      * @dev Reverts if the `tokenId` has not been minted yet.
1505      */
1506     function _requireMinted(uint256 tokenId) internal view virtual {
1507         require(_exists(tokenId), "ERC721: invalid token ID");
1508     }
1509 
1510     /**
1511      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1512      * The call is not executed if the target address is not a contract.
1513      *
1514      * @param from address representing the previous owner of the given token ID
1515      * @param to target address that will receive the tokens
1516      * @param tokenId uint256 ID of the token to be transferred
1517      * @param data bytes optional data to send along with the call
1518      * @return bool whether the call correctly returned the expected magic value
1519      */
1520     function _checkOnERC721Received(
1521         address from,
1522         address to,
1523         uint256 tokenId,
1524         bytes memory data
1525     ) private returns (bool) {
1526         if (to.isContract()) {
1527             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1528                 return retval == IERC721Receiver.onERC721Received.selector;
1529             } catch (bytes memory reason) {
1530                 if (reason.length == 0) {
1531                     revert("ERC721: transfer to non ERC721Receiver implementer");
1532                 } else {
1533                     /// @solidity memory-safe-assembly
1534                     assembly {
1535                         revert(add(32, reason), mload(reason))
1536                     }
1537                 }
1538             }
1539         } else {
1540             return true;
1541         }
1542     }
1543 
1544     /**
1545      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1546      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1547      *
1548      * Calling conditions:
1549      *
1550      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1551      * - When `from` is zero, the tokens will be minted for `to`.
1552      * - When `to` is zero, ``from``'s tokens will be burned.
1553      * - `from` and `to` are never both zero.
1554      * - `batchSize` is non-zero.
1555      *
1556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1557      */
1558     function _beforeTokenTransfer(
1559         address from,
1560         address to,
1561         uint256, /* firstTokenId */
1562         uint256 batchSize
1563     ) internal virtual {
1564         if (batchSize > 1) {
1565             if (from != address(0)) {
1566                 _balances[from] -= batchSize;
1567             }
1568             if (to != address(0)) {
1569                 _balances[to] += batchSize;
1570             }
1571         }
1572     }
1573 
1574     /**
1575      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1576      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1577      *
1578      * Calling conditions:
1579      *
1580      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1581      * - When `from` is zero, the tokens were minted for `to`.
1582      * - When `to` is zero, ``from``'s tokens were burned.
1583      * - `from` and `to` are never both zero.
1584      * - `batchSize` is non-zero.
1585      *
1586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1587      */
1588     function _afterTokenTransfer(
1589         address from,
1590         address to,
1591         uint256 firstTokenId,
1592         uint256 batchSize
1593     ) internal virtual {}
1594 }
1595 
1596 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1597 
1598 
1599 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1600 
1601 pragma solidity ^0.8.0;
1602 
1603 
1604 
1605 /**
1606  * @title ERC721 Burnable Token
1607  * @dev ERC721 Token that can be burned (destroyed).
1608  */
1609 abstract contract ERC721Burnable is Context, ERC721 {
1610     /**
1611      * @dev Burns `tokenId`. See {ERC721-_burn}.
1612      *
1613      * Requirements:
1614      *
1615      * - The caller must own `tokenId` or be an approved operator.
1616      */
1617     function burn(uint256 tokenId) public virtual {
1618         //solhint-disable-next-line max-line-length
1619         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1620         _burn(tokenId);
1621     }
1622 }
1623 
1624 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1625 
1626 
1627 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1628 
1629 pragma solidity ^0.8.0;
1630 
1631 
1632 /**
1633  * @dev ERC721 token with storage based token URI management.
1634  */
1635 abstract contract ERC721URIStorage is ERC721 {
1636     using Strings for uint256;
1637 
1638     // Optional mapping for token URIs
1639     mapping(uint256 => string) private _tokenURIs;
1640 
1641     /**
1642      * @dev See {IERC721Metadata-tokenURI}.
1643      */
1644     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1645         _requireMinted(tokenId);
1646 
1647         string memory _tokenURI = _tokenURIs[tokenId];
1648         string memory base = _baseURI();
1649 
1650         // If there is no base URI, return the token URI.
1651         if (bytes(base).length == 0) {
1652             return _tokenURI;
1653         }
1654         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1655         if (bytes(_tokenURI).length > 0) {
1656             return string(abi.encodePacked(base, _tokenURI));
1657         }
1658 
1659         return super.tokenURI(tokenId);
1660     }
1661 
1662     /**
1663      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1664      *
1665      * Requirements:
1666      *
1667      * - `tokenId` must exist.
1668      */
1669     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1670         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1671         _tokenURIs[tokenId] = _tokenURI;
1672     }
1673 
1674     /**
1675      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1676      * token-specific URI was set for the token, and if so, it deletes the token URI from
1677      * the storage mapping.
1678      */
1679     function _burn(uint256 tokenId) internal virtual override {
1680         super._burn(tokenId);
1681 
1682         if (bytes(_tokenURIs[tokenId]).length != 0) {
1683             delete _tokenURIs[tokenId];
1684         }
1685     }
1686 }
1687 
1688 // File: PulseBitcoinLockNFT.sol
1689 
1690 
1691 pragma solidity ^0.8.0;
1692 
1693 
1694 
1695 
1696 
1697 
1698 contract PulseBitcoinLockNFT is ERC721, ERC721URIStorage, ERC721Burnable  {
1699     using Counters for Counters.Counter;
1700 
1701     Counters.Counter private _tokenIdCounter;
1702 
1703     address public immutable token;
1704     address public immutable tipReceiver;
1705 
1706     mapping(uint=>uint) public tokenIdsToAmounts; // tokenIds to deposit amounts
1707     mapping(uint=>bool) public tokenIdsToTransferable; // tokenIds to deposit amounts
1708     mapping(uint=>uint) public lockTime; // tokenIds to lockTime
1709 
1710     event LockUpAndMint(address indexed minter, uint indexed _lockupAmount, uint _tipAmount, uint _lockTimeInterval, string uri, uint unlockPeriod, uint tokenId, uint indexed currentTime);
1711     event Burn(address indexed burner, uint indexed currentTime, uint tokenId, uint indexed amount);
1712 
1713     constructor(string memory _name, string memory _symbol, address _lockedToken, address _tipReceiver) ERC721(_name, _symbol) {
1714         token = _lockedToken;
1715         tipReceiver = _tipReceiver;
1716     }
1717 
1718     function lockUpAndMint(uint lockupAmount, uint tipAmount, uint _lockTimeInterval, bool transferable, address mintTo, string memory uri) public {
1719         require(lockupAmount>0, "amount can't be zero");
1720         require(IERC20(token).transferFrom(msg.sender, address(this), lockupAmount), "transferFrom failed.");
1721         if (tipAmount > 0) {
1722           require(IERC20(token).transferFrom(msg.sender, tipReceiver, tipAmount), "transferFrom failed.");
1723         }
1724 
1725         uint tokenId = _tokenIdCounter.current();
1726         tokenIdsToAmounts[tokenId] = lockupAmount;
1727         tokenIdsToTransferable[tokenId] = transferable;
1728         lockTime[tokenId] = block.timestamp+_lockTimeInterval;
1729         mint(mintTo, uri);
1730         
1731         emit LockUpAndMint(msg.sender, lockupAmount, tipAmount, _lockTimeInterval, uri, lockTime[tokenId], tokenId, block.timestamp);
1732     }
1733 
1734     function mint(address mintTo, string memory _uri) internal {
1735         uint tokenId = _tokenIdCounter.current();
1736         _tokenIdCounter.increment();
1737         _safeMint(mintTo, tokenId);
1738         _setTokenURI(tokenId, _uri);
1739     }
1740 
1741     function tokenURI(uint tokenId)
1742         public
1743         view
1744         override(ERC721, ERC721URIStorage)
1745         returns (string memory)
1746     {
1747         return super.tokenURI(tokenId);
1748     }
1749 
1750     
1751     function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
1752         internal
1753         override(ERC721)
1754     {
1755         if(from != address(0) && to != address(0))
1756             require(block.timestamp >= lockTime[tokenId] || tokenIdsToTransferable[tokenId], "Token is Non-Transferable and LockUp Period hasnt ended");
1757         super._beforeTokenTransfer(from, to, tokenId, batchSize);
1758     }
1759 
1760     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1761         require(block.timestamp >= lockTime[tokenId], "Token is in locked state");
1762         uint amountToTransfer = tokenIdsToAmounts[tokenId];
1763         tokenIdsToAmounts[tokenId] = 0;
1764         super._burn(tokenId);
1765         IERC20(token).transfer(msg.sender, amountToTransfer);
1766 
1767         emit Burn(msg.sender, block.timestamp, tokenId, amountToTransfer);
1768     }
1769 }