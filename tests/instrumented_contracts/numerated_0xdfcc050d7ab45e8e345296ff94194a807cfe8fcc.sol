1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/math/Math.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Standard math utilities missing in the Solidity language.
240  */
241 library Math {
242     enum Rounding {
243         Down, // Toward negative infinity
244         Up, // Toward infinity
245         Zero // Toward zero
246     }
247 
248     /**
249      * @dev Returns the largest of two numbers.
250      */
251     function max(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a >= b ? a : b;
253     }
254 
255     /**
256      * @dev Returns the smallest of two numbers.
257      */
258     function min(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a < b ? a : b;
260     }
261 
262     /**
263      * @dev Returns the average of two numbers. The result is rounded towards
264      * zero.
265      */
266     function average(uint256 a, uint256 b) internal pure returns (uint256) {
267         // (a + b) / 2 can overflow.
268         return (a & b) + (a ^ b) / 2;
269     }
270 
271     /**
272      * @dev Returns the ceiling of the division of two numbers.
273      *
274      * This differs from standard division with `/` in that it rounds up instead
275      * of rounding down.
276      */
277     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
278         // (a + b - 1) / b can overflow on addition, so we distribute.
279         return a == 0 ? 0 : (a - 1) / b + 1;
280     }
281 
282     /**
283      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
284      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
285      * with further edits by Uniswap Labs also under MIT license.
286      */
287     function mulDiv(
288         uint256 x,
289         uint256 y,
290         uint256 denominator
291     ) internal pure returns (uint256 result) {
292         unchecked {
293             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
294             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
295             // variables such that product = prod1 * 2^256 + prod0.
296             uint256 prod0; // Least significant 256 bits of the product
297             uint256 prod1; // Most significant 256 bits of the product
298             assembly {
299                 let mm := mulmod(x, y, not(0))
300                 prod0 := mul(x, y)
301                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
302             }
303 
304             // Handle non-overflow cases, 256 by 256 division.
305             if (prod1 == 0) {
306                 return prod0 / denominator;
307             }
308 
309             // Make sure the result is less than 2^256. Also prevents denominator == 0.
310             require(denominator > prod1);
311 
312             ///////////////////////////////////////////////
313             // 512 by 256 division.
314             ///////////////////////////////////////////////
315 
316             // Make division exact by subtracting the remainder from [prod1 prod0].
317             uint256 remainder;
318             assembly {
319                 // Compute remainder using mulmod.
320                 remainder := mulmod(x, y, denominator)
321 
322                 // Subtract 256 bit number from 512 bit number.
323                 prod1 := sub(prod1, gt(remainder, prod0))
324                 prod0 := sub(prod0, remainder)
325             }
326 
327             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
328             // See https://cs.stackexchange.com/q/138556/92363.
329 
330             // Does not overflow because the denominator cannot be zero at this stage in the function.
331             uint256 twos = denominator & (~denominator + 1);
332             assembly {
333                 // Divide denominator by twos.
334                 denominator := div(denominator, twos)
335 
336                 // Divide [prod1 prod0] by twos.
337                 prod0 := div(prod0, twos)
338 
339                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
340                 twos := add(div(sub(0, twos), twos), 1)
341             }
342 
343             // Shift in bits from prod1 into prod0.
344             prod0 |= prod1 * twos;
345 
346             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
347             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
348             // four bits. That is, denominator * inv = 1 mod 2^4.
349             uint256 inverse = (3 * denominator) ^ 2;
350 
351             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
352             // in modular arithmetic, doubling the correct bits in each step.
353             inverse *= 2 - denominator * inverse; // inverse mod 2^8
354             inverse *= 2 - denominator * inverse; // inverse mod 2^16
355             inverse *= 2 - denominator * inverse; // inverse mod 2^32
356             inverse *= 2 - denominator * inverse; // inverse mod 2^64
357             inverse *= 2 - denominator * inverse; // inverse mod 2^128
358             inverse *= 2 - denominator * inverse; // inverse mod 2^256
359 
360             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
361             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
362             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
363             // is no longer required.
364             result = prod0 * inverse;
365             return result;
366         }
367     }
368 
369     /**
370      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
371      */
372     function mulDiv(
373         uint256 x,
374         uint256 y,
375         uint256 denominator,
376         Rounding rounding
377     ) internal pure returns (uint256) {
378         uint256 result = mulDiv(x, y, denominator);
379         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
380             result += 1;
381         }
382         return result;
383     }
384 
385     /**
386      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
387      *
388      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
389      */
390     function sqrt(uint256 a) internal pure returns (uint256) {
391         if (a == 0) {
392             return 0;
393         }
394 
395         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
396         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
397         // `msb(a) <= a < 2*msb(a)`.
398         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
399         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
400         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
401         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
402         uint256 result = 1;
403         uint256 x = a;
404         if (x >> 128 > 0) {
405             x >>= 128;
406             result <<= 64;
407         }
408         if (x >> 64 > 0) {
409             x >>= 64;
410             result <<= 32;
411         }
412         if (x >> 32 > 0) {
413             x >>= 32;
414             result <<= 16;
415         }
416         if (x >> 16 > 0) {
417             x >>= 16;
418             result <<= 8;
419         }
420         if (x >> 8 > 0) {
421             x >>= 8;
422             result <<= 4;
423         }
424         if (x >> 4 > 0) {
425             x >>= 4;
426             result <<= 2;
427         }
428         if (x >> 2 > 0) {
429             result <<= 1;
430         }
431 
432         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
433         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
434         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
435         // into the expected uint128 result.
436         unchecked {
437             result = (result + a / result) >> 1;
438             result = (result + a / result) >> 1;
439             result = (result + a / result) >> 1;
440             result = (result + a / result) >> 1;
441             result = (result + a / result) >> 1;
442             result = (result + a / result) >> 1;
443             result = (result + a / result) >> 1;
444             return min(result, a / result);
445         }
446     }
447 
448     /**
449      * @notice Calculates sqrt(a), following the selected rounding direction.
450      */
451     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
452         uint256 result = sqrt(a);
453         if (rounding == Rounding.Up && result * result < a) {
454             result += 1;
455         }
456         return result;
457     }
458 }
459 
460 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Contract module that helps prevent reentrant calls to a function.
469  *
470  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
471  * available, which can be applied to functions to make sure there are no nested
472  * (reentrant) calls to them.
473  *
474  * Note that because there is a single `nonReentrant` guard, functions marked as
475  * `nonReentrant` may not call one another. This can be worked around by making
476  * those functions `private`, and then adding `external` `nonReentrant` entry
477  * points to them.
478  *
479  * TIP: If you would like to learn more about reentrancy and alternative ways
480  * to protect against it, check out our blog post
481  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
482  */
483 abstract contract ReentrancyGuard {
484     // Booleans are more expensive than uint256 or any type that takes up a full
485     // word because each write operation emits an extra SLOAD to first read the
486     // slot's contents, replace the bits taken up by the boolean, and then write
487     // back. This is the compiler's defense against contract upgrades and
488     // pointer aliasing, and it cannot be disabled.
489 
490     // The values being non-zero value makes deployment a bit more expensive,
491     // but in exchange the refund on every call to nonReentrant will be lower in
492     // amount. Since refunds are capped to a percentage of the total
493     // transaction's gas, it is best to keep them low in cases like this one, to
494     // increase the likelihood of the full refund coming into effect.
495     uint256 private constant _NOT_ENTERED = 1;
496     uint256 private constant _ENTERED = 2;
497 
498     uint256 private _status;
499 
500     constructor() {
501         _status = _NOT_ENTERED;
502     }
503 
504     /**
505      * @dev Prevents a contract from calling itself, directly or indirectly.
506      * Calling a `nonReentrant` function from another `nonReentrant`
507      * function is not supported. It is possible to prevent this from happening
508      * by making the `nonReentrant` function external, and making it call a
509      * `private` function that does the actual work.
510      */
511     modifier nonReentrant() {
512         // On the first call to nonReentrant, _notEntered will be true
513         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
514 
515         // Any calls to nonReentrant after this point will fail
516         _status = _ENTERED;
517 
518         _;
519 
520         // By storing the original value once again, a refund is triggered (see
521         // https://eips.ethereum.org/EIPS/eip-2200)
522         _status = _NOT_ENTERED;
523     }
524 }
525 
526 // File: @openzeppelin/contracts/utils/Address.sol
527 
528 
529 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
530 
531 pragma solidity ^0.8.1;
532 
533 /**
534  * @dev Collection of functions related to the address type
535  */
536 library Address {
537     /**
538      * @dev Returns true if `account` is a contract.
539      *
540      * [IMPORTANT]
541      * ====
542      * It is unsafe to assume that an address for which this function returns
543      * false is an externally-owned account (EOA) and not a contract.
544      *
545      * Among others, `isContract` will return false for the following
546      * types of addresses:
547      *
548      *  - an externally-owned account
549      *  - a contract in construction
550      *  - an address where a contract will be created
551      *  - an address where a contract lived, but was destroyed
552      * ====
553      *
554      * [IMPORTANT]
555      * ====
556      * You shouldn't rely on `isContract` to protect against flash loan attacks!
557      *
558      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
559      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
560      * constructor.
561      * ====
562      */
563     function isContract(address account) internal view returns (bool) {
564         // This method relies on extcodesize/address.code.length, which returns 0
565         // for contracts in construction, since the code is only stored at the end
566         // of the constructor execution.
567 
568         return account.code.length > 0;
569     }
570 
571     /**
572      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
573      * `recipient`, forwarding all available gas and reverting on errors.
574      *
575      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
576      * of certain opcodes, possibly making contracts go over the 2300 gas limit
577      * imposed by `transfer`, making them unable to receive funds via
578      * `transfer`. {sendValue} removes this limitation.
579      *
580      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
581      *
582      * IMPORTANT: because control is transferred to `recipient`, care must be
583      * taken to not create reentrancy vulnerabilities. Consider using
584      * {ReentrancyGuard} or the
585      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
586      */
587     function sendValue(address payable recipient, uint256 amount) internal {
588         require(address(this).balance >= amount, "Address: insufficient balance");
589 
590         (bool success, ) = recipient.call{value: amount}("");
591         require(success, "Address: unable to send value, recipient may have reverted");
592     }
593 
594     /**
595      * @dev Performs a Solidity function call using a low level `call`. A
596      * plain `call` is an unsafe replacement for a function call: use this
597      * function instead.
598      *
599      * If `target` reverts with a revert reason, it is bubbled up by this
600      * function (like regular Solidity function calls).
601      *
602      * Returns the raw returned data. To convert to the expected return value,
603      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
604      *
605      * Requirements:
606      *
607      * - `target` must be a contract.
608      * - calling `target` with `data` must not revert.
609      *
610      * _Available since v3.1._
611      */
612     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionCall(target, data, "Address: low-level call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
618      * `errorMessage` as a fallback revert reason when `target` reverts.
619      *
620      * _Available since v3.1._
621      */
622     function functionCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         return functionCallWithValue(target, data, 0, errorMessage);
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
632      * but also transferring `value` wei to `target`.
633      *
634      * Requirements:
635      *
636      * - the calling contract must have an ETH balance of at least `value`.
637      * - the called Solidity function must be `payable`.
638      *
639      * _Available since v3.1._
640      */
641     function functionCallWithValue(
642         address target,
643         bytes memory data,
644         uint256 value
645     ) internal returns (bytes memory) {
646         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
651      * with `errorMessage` as a fallback revert reason when `target` reverts.
652      *
653      * _Available since v3.1._
654      */
655     function functionCallWithValue(
656         address target,
657         bytes memory data,
658         uint256 value,
659         string memory errorMessage
660     ) internal returns (bytes memory) {
661         require(address(this).balance >= value, "Address: insufficient balance for call");
662         require(isContract(target), "Address: call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.call{value: value}(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
670      * but performing a static call.
671      *
672      * _Available since v3.3._
673      */
674     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
675         return functionStaticCall(target, data, "Address: low-level static call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
680      * but performing a static call.
681      *
682      * _Available since v3.3._
683      */
684     function functionStaticCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal view returns (bytes memory) {
689         require(isContract(target), "Address: static call to non-contract");
690 
691         (bool success, bytes memory returndata) = target.staticcall(data);
692         return verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
697      * but performing a delegate call.
698      *
699      * _Available since v3.4._
700      */
701     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
702         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
707      * but performing a delegate call.
708      *
709      * _Available since v3.4._
710      */
711     function functionDelegateCall(
712         address target,
713         bytes memory data,
714         string memory errorMessage
715     ) internal returns (bytes memory) {
716         require(isContract(target), "Address: delegate call to non-contract");
717 
718         (bool success, bytes memory returndata) = target.delegatecall(data);
719         return verifyCallResult(success, returndata, errorMessage);
720     }
721 
722     /**
723      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
724      * revert reason using the provided one.
725      *
726      * _Available since v4.3._
727      */
728     function verifyCallResult(
729         bool success,
730         bytes memory returndata,
731         string memory errorMessage
732     ) internal pure returns (bytes memory) {
733         if (success) {
734             return returndata;
735         } else {
736             // Look for revert reason and bubble it up if present
737             if (returndata.length > 0) {
738                 // The easiest way to bubble the revert reason is using memory via assembly
739                 /// @solidity memory-safe-assembly
740                 assembly {
741                     let returndata_size := mload(returndata)
742                     revert(add(32, returndata), returndata_size)
743                 }
744             } else {
745                 revert(errorMessage);
746             }
747         }
748     }
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
752 
753 
754 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 /**
759  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
760  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
761  *
762  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
763  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
764  * need to send a transaction, and thus is not required to hold Ether at all.
765  */
766 interface IERC20Permit {
767     /**
768      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
769      * given ``owner``'s signed approval.
770      *
771      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
772      * ordering also apply here.
773      *
774      * Emits an {Approval} event.
775      *
776      * Requirements:
777      *
778      * - `spender` cannot be the zero address.
779      * - `deadline` must be a timestamp in the future.
780      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
781      * over the EIP712-formatted function arguments.
782      * - the signature must use ``owner``'s current nonce (see {nonces}).
783      *
784      * For more information on the signature format, see the
785      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
786      * section].
787      */
788     function permit(
789         address owner,
790         address spender,
791         uint256 value,
792         uint256 deadline,
793         uint8 v,
794         bytes32 r,
795         bytes32 s
796     ) external;
797 
798     /**
799      * @dev Returns the current nonce for `owner`. This value must be
800      * included whenever a signature is generated for {permit}.
801      *
802      * Every successful call to {permit} increases ``owner``'s nonce by one. This
803      * prevents a signature from being used multiple times.
804      */
805     function nonces(address owner) external view returns (uint256);
806 
807     /**
808      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
809      */
810     // solhint-disable-next-line func-name-mixedcase
811     function DOMAIN_SEPARATOR() external view returns (bytes32);
812 }
813 
814 // File: @openzeppelin/contracts/utils/Context.sol
815 
816 
817 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Provides information about the current execution context, including the
823  * sender of the transaction and its data. While these are generally available
824  * via msg.sender and msg.data, they should not be accessed in such a direct
825  * manner, since when dealing with meta-transactions the account sending and
826  * paying for execution may not be the actual sender (as far as an application
827  * is concerned).
828  *
829  * This contract is only required for intermediate, library-like contracts.
830  */
831 abstract contract Context {
832     function _msgSender() internal view virtual returns (address) {
833         return msg.sender;
834     }
835 
836     function _msgData() internal view virtual returns (bytes calldata) {
837         return msg.data;
838     }
839 }
840 
841 // File: @openzeppelin/contracts/access/Ownable.sol
842 
843 
844 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
845 
846 pragma solidity ^0.8.0;
847 
848 
849 /**
850  * @dev Contract module which provides a basic access control mechanism, where
851  * there is an account (an owner) that can be granted exclusive access to
852  * specific functions.
853  *
854  * By default, the owner account will be the one that deploys the contract. This
855  * can later be changed with {transferOwnership}.
856  *
857  * This module is used through inheritance. It will make available the modifier
858  * `onlyOwner`, which can be applied to your functions to restrict their use to
859  * the owner.
860  */
861 abstract contract Ownable is Context {
862     address private _owner;
863 
864     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
865 
866     /**
867      * @dev Initializes the contract setting the deployer as the initial owner.
868      */
869     constructor() {
870         _transferOwnership(_msgSender());
871     }
872 
873     /**
874      * @dev Throws if called by any account other than the owner.
875      */
876     modifier onlyOwner() {
877         _checkOwner();
878         _;
879     }
880 
881     /**
882      * @dev Returns the address of the current owner.
883      */
884     function owner() public view virtual returns (address) {
885         return _owner;
886     }
887 
888     /**
889      * @dev Throws if the sender is not the owner.
890      */
891     function _checkOwner() internal view virtual {
892         require(owner() == _msgSender(), "Ownable: caller is not the owner");
893     }
894 
895     /**
896      * @dev Leaves the contract without owner. It will not be possible to call
897      * `onlyOwner` functions anymore. Can only be called by the current owner.
898      *
899      * NOTE: Renouncing ownership will leave the contract without an owner,
900      * thereby removing any functionality that is only available to the owner.
901      */
902     function renounceOwnership() public virtual onlyOwner {
903         _transferOwnership(address(0));
904     }
905 
906     /**
907      * @dev Transfers ownership of the contract to a new account (`newOwner`).
908      * Can only be called by the current owner.
909      */
910     function transferOwnership(address newOwner) public virtual onlyOwner {
911         require(newOwner != address(0), "Ownable: new owner is the zero address");
912         _transferOwnership(newOwner);
913     }
914 
915     /**
916      * @dev Transfers ownership of the contract to a new account (`newOwner`).
917      * Internal function without access restriction.
918      */
919     function _transferOwnership(address newOwner) internal virtual {
920         address oldOwner = _owner;
921         _owner = newOwner;
922         emit OwnershipTransferred(oldOwner, newOwner);
923     }
924 }
925 
926 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
927 
928 
929 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 /**
934  * @dev Interface of the ERC20 standard as defined in the EIP.
935  */
936 interface IERC20 {
937     /**
938      * @dev Emitted when `value` tokens are moved from one account (`from`) to
939      * another (`to`).
940      *
941      * Note that `value` may be zero.
942      */
943     event Transfer(address indexed from, address indexed to, uint256 value);
944 
945     /**
946      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
947      * a call to {approve}. `value` is the new allowance.
948      */
949     event Approval(address indexed owner, address indexed spender, uint256 value);
950 
951     /**
952      * @dev Returns the amount of tokens in existence.
953      */
954     function totalSupply() external view returns (uint256);
955 
956     /**
957      * @dev Returns the amount of tokens owned by `account`.
958      */
959     function balanceOf(address account) external view returns (uint256);
960 
961     /**
962      * @dev Moves `amount` tokens from the caller's account to `to`.
963      *
964      * Returns a boolean value indicating whether the operation succeeded.
965      *
966      * Emits a {Transfer} event.
967      */
968     function transfer(address to, uint256 amount) external returns (bool);
969 
970     /**
971      * @dev Returns the remaining number of tokens that `spender` will be
972      * allowed to spend on behalf of `owner` through {transferFrom}. This is
973      * zero by default.
974      *
975      * This value changes when {approve} or {transferFrom} are called.
976      */
977     function allowance(address owner, address spender) external view returns (uint256);
978 
979     /**
980      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
981      *
982      * Returns a boolean value indicating whether the operation succeeded.
983      *
984      * IMPORTANT: Beware that changing an allowance with this method brings the risk
985      * that someone may use both the old and the new allowance by unfortunate
986      * transaction ordering. One possible solution to mitigate this race
987      * condition is to first reduce the spender's allowance to 0 and set the
988      * desired value afterwards:
989      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
990      *
991      * Emits an {Approval} event.
992      */
993     function approve(address spender, uint256 amount) external returns (bool);
994 
995     /**
996      * @dev Moves `amount` tokens from `from` to `to` using the
997      * allowance mechanism. `amount` is then deducted from the caller's
998      * allowance.
999      *
1000      * Returns a boolean value indicating whether the operation succeeded.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function transferFrom(
1005         address from,
1006         address to,
1007         uint256 amount
1008     ) external returns (bool);
1009 }
1010 
1011 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1012 
1013 
1014 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1015 
1016 pragma solidity ^0.8.0;
1017 
1018 
1019 
1020 
1021 /**
1022  * @title SafeERC20
1023  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1024  * contract returns false). Tokens that return no value (and instead revert or
1025  * throw on failure) are also supported, non-reverting calls are assumed to be
1026  * successful.
1027  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1028  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1029  */
1030 library SafeERC20 {
1031     using Address for address;
1032 
1033     function safeTransfer(
1034         IERC20 token,
1035         address to,
1036         uint256 value
1037     ) internal {
1038         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1039     }
1040 
1041     function safeTransferFrom(
1042         IERC20 token,
1043         address from,
1044         address to,
1045         uint256 value
1046     ) internal {
1047         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1048     }
1049 
1050     /**
1051      * @dev Deprecated. This function has issues similar to the ones found in
1052      * {IERC20-approve}, and its usage is discouraged.
1053      *
1054      * Whenever possible, use {safeIncreaseAllowance} and
1055      * {safeDecreaseAllowance} instead.
1056      */
1057     function safeApprove(
1058         IERC20 token,
1059         address spender,
1060         uint256 value
1061     ) internal {
1062         // safeApprove should only be called when setting an initial allowance,
1063         // or when resetting it to zero. To increase and decrease it, use
1064         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1065         require(
1066             (value == 0) || (token.allowance(address(this), spender) == 0),
1067             "SafeERC20: approve from non-zero to non-zero allowance"
1068         );
1069         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1070     }
1071 
1072     function safeIncreaseAllowance(
1073         IERC20 token,
1074         address spender,
1075         uint256 value
1076     ) internal {
1077         uint256 newAllowance = token.allowance(address(this), spender) + value;
1078         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1079     }
1080 
1081     function safeDecreaseAllowance(
1082         IERC20 token,
1083         address spender,
1084         uint256 value
1085     ) internal {
1086         unchecked {
1087             uint256 oldAllowance = token.allowance(address(this), spender);
1088             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1089             uint256 newAllowance = oldAllowance - value;
1090             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1091         }
1092     }
1093 
1094     function safePermit(
1095         IERC20Permit token,
1096         address owner,
1097         address spender,
1098         uint256 value,
1099         uint256 deadline,
1100         uint8 v,
1101         bytes32 r,
1102         bytes32 s
1103     ) internal {
1104         uint256 nonceBefore = token.nonces(owner);
1105         token.permit(owner, spender, value, deadline, v, r, s);
1106         uint256 nonceAfter = token.nonces(owner);
1107         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1108     }
1109 
1110     /**
1111      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1112      * on the return value: the return value is optional (but if data is returned, it must not be false).
1113      * @param token The token targeted by the call.
1114      * @param data The call data (encoded using abi.encode or one of its variants).
1115      */
1116     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1117         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1118         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1119         // the target address contains contract code and also asserts for success in the low-level call.
1120 
1121         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1122         if (returndata.length > 0) {
1123             // Return data is optional
1124             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1125         }
1126     }
1127 }
1128 
1129 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1130 
1131 
1132 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 
1137 /**
1138  * @dev Interface for the optional metadata functions from the ERC20 standard.
1139  *
1140  * _Available since v4.1._
1141  */
1142 interface IERC20Metadata is IERC20 {
1143     /**
1144      * @dev Returns the name of the token.
1145      */
1146     function name() external view returns (string memory);
1147 
1148     /**
1149      * @dev Returns the symbol of the token.
1150      */
1151     function symbol() external view returns (string memory);
1152 
1153     /**
1154      * @dev Returns the decimals places of the token.
1155      */
1156     function decimals() external view returns (uint8);
1157 }
1158 
1159 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1160 
1161 
1162 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 
1167 
1168 
1169 /**
1170  * @dev Implementation of the {IERC20} interface.
1171  *
1172  * This implementation is agnostic to the way tokens are created. This means
1173  * that a supply mechanism has to be added in a derived contract using {_mint}.
1174  * For a generic mechanism see {ERC20PresetMinterPauser}.
1175  *
1176  * TIP: For a detailed writeup see our guide
1177  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1178  * to implement supply mechanisms].
1179  *
1180  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1181  * instead returning `false` on failure. This behavior is nonetheless
1182  * conventional and does not conflict with the expectations of ERC20
1183  * applications.
1184  *
1185  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1186  * This allows applications to reconstruct the allowance for all accounts just
1187  * by listening to said events. Other implementations of the EIP may not emit
1188  * these events, as it isn't required by the specification.
1189  *
1190  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1191  * functions have been added to mitigate the well-known issues around setting
1192  * allowances. See {IERC20-approve}.
1193  */
1194 contract ERC20 is Context, IERC20, IERC20Metadata {
1195     mapping(address => uint256) private _balances;
1196 
1197     mapping(address => mapping(address => uint256)) private _allowances;
1198 
1199     uint256 private _totalSupply;
1200 
1201     string private _name;
1202     string private _symbol;
1203 
1204     /**
1205      * @dev Sets the values for {name} and {symbol}.
1206      *
1207      * The default value of {decimals} is 18. To select a different value for
1208      * {decimals} you should overload it.
1209      *
1210      * All two of these values are immutable: they can only be set once during
1211      * construction.
1212      */
1213     constructor(string memory name_, string memory symbol_) {
1214         _name = name_;
1215         _symbol = symbol_;
1216     }
1217 
1218     /**
1219      * @dev Returns the name of the token.
1220      */
1221     function name() public view virtual override returns (string memory) {
1222         return _name;
1223     }
1224 
1225     /**
1226      * @dev Returns the symbol of the token, usually a shorter version of the
1227      * name.
1228      */
1229     function symbol() public view virtual override returns (string memory) {
1230         return _symbol;
1231     }
1232 
1233     /**
1234      * @dev Returns the number of decimals used to get its user representation.
1235      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1236      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1237      *
1238      * Tokens usually opt for a value of 18, imitating the relationship between
1239      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1240      * overridden;
1241      *
1242      * NOTE: This information is only used for _display_ purposes: it in
1243      * no way affects any of the arithmetic of the contract, including
1244      * {IERC20-balanceOf} and {IERC20-transfer}.
1245      */
1246     function decimals() public view virtual override returns (uint8) {
1247         return 18;
1248     }
1249 
1250     /**
1251      * @dev See {IERC20-totalSupply}.
1252      */
1253     function totalSupply() public view virtual override returns (uint256) {
1254         return _totalSupply;
1255     }
1256 
1257     /**
1258      * @dev See {IERC20-balanceOf}.
1259      */
1260     function balanceOf(address account) public view virtual override returns (uint256) {
1261         return _balances[account];
1262     }
1263 
1264     /**
1265      * @dev See {IERC20-transfer}.
1266      *
1267      * Requirements:
1268      *
1269      * - `to` cannot be the zero address.
1270      * - the caller must have a balance of at least `amount`.
1271      */
1272     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1273         address owner = _msgSender();
1274         _transfer(owner, to, amount);
1275         return true;
1276     }
1277 
1278     /**
1279      * @dev See {IERC20-allowance}.
1280      */
1281     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1282         return _allowances[owner][spender];
1283     }
1284 
1285     /**
1286      * @dev See {IERC20-approve}.
1287      *
1288      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1289      * `transferFrom`. This is semantically equivalent to an infinite approval.
1290      *
1291      * Requirements:
1292      *
1293      * - `spender` cannot be the zero address.
1294      */
1295     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1296         address owner = _msgSender();
1297         _approve(owner, spender, amount);
1298         return true;
1299     }
1300 
1301     /**
1302      * @dev See {IERC20-transferFrom}.
1303      *
1304      * Emits an {Approval} event indicating the updated allowance. This is not
1305      * required by the EIP. See the note at the beginning of {ERC20}.
1306      *
1307      * NOTE: Does not update the allowance if the current allowance
1308      * is the maximum `uint256`.
1309      *
1310      * Requirements:
1311      *
1312      * - `from` and `to` cannot be the zero address.
1313      * - `from` must have a balance of at least `amount`.
1314      * - the caller must have allowance for ``from``'s tokens of at least
1315      * `amount`.
1316      */
1317     function transferFrom(
1318         address from,
1319         address to,
1320         uint256 amount
1321     ) public virtual override returns (bool) {
1322         address spender = _msgSender();
1323         _spendAllowance(from, spender, amount);
1324         _transfer(from, to, amount);
1325         return true;
1326     }
1327 
1328     /**
1329      * @dev Atomically increases the allowance granted to `spender` by the caller.
1330      *
1331      * This is an alternative to {approve} that can be used as a mitigation for
1332      * problems described in {IERC20-approve}.
1333      *
1334      * Emits an {Approval} event indicating the updated allowance.
1335      *
1336      * Requirements:
1337      *
1338      * - `spender` cannot be the zero address.
1339      */
1340     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1341         address owner = _msgSender();
1342         _approve(owner, spender, allowance(owner, spender) + addedValue);
1343         return true;
1344     }
1345 
1346     /**
1347      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1348      *
1349      * This is an alternative to {approve} that can be used as a mitigation for
1350      * problems described in {IERC20-approve}.
1351      *
1352      * Emits an {Approval} event indicating the updated allowance.
1353      *
1354      * Requirements:
1355      *
1356      * - `spender` cannot be the zero address.
1357      * - `spender` must have allowance for the caller of at least
1358      * `subtractedValue`.
1359      */
1360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1361         address owner = _msgSender();
1362         uint256 currentAllowance = allowance(owner, spender);
1363         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1364         unchecked {
1365             _approve(owner, spender, currentAllowance - subtractedValue);
1366         }
1367 
1368         return true;
1369     }
1370 
1371     /**
1372      * @dev Moves `amount` of tokens from `from` to `to`.
1373      *
1374      * This internal function is equivalent to {transfer}, and can be used to
1375      * e.g. implement automatic token fees, slashing mechanisms, etc.
1376      *
1377      * Emits a {Transfer} event.
1378      *
1379      * Requirements:
1380      *
1381      * - `from` cannot be the zero address.
1382      * - `to` cannot be the zero address.
1383      * - `from` must have a balance of at least `amount`.
1384      */
1385     function _transfer(
1386         address from,
1387         address to,
1388         uint256 amount
1389     ) internal virtual {
1390         require(from != address(0), "ERC20: transfer from the zero address");
1391         require(to != address(0), "ERC20: transfer to the zero address");
1392 
1393         _beforeTokenTransfer(from, to, amount);
1394 
1395         uint256 fromBalance = _balances[from];
1396         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1397         unchecked {
1398             _balances[from] = fromBalance - amount;
1399         }
1400         _balances[to] += amount;
1401 
1402         emit Transfer(from, to, amount);
1403 
1404         _afterTokenTransfer(from, to, amount);
1405     }
1406 
1407     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1408      * the total supply.
1409      *
1410      * Emits a {Transfer} event with `from` set to the zero address.
1411      *
1412      * Requirements:
1413      *
1414      * - `account` cannot be the zero address.
1415      */
1416     function _mint(address account, uint256 amount) internal virtual {
1417         require(account != address(0), "ERC20: mint to the zero address");
1418 
1419         _beforeTokenTransfer(address(0), account, amount);
1420 
1421         _totalSupply += amount;
1422         _balances[account] += amount;
1423         emit Transfer(address(0), account, amount);
1424 
1425         _afterTokenTransfer(address(0), account, amount);
1426     }
1427 
1428     /**
1429      * @dev Destroys `amount` tokens from `account`, reducing the
1430      * total supply.
1431      *
1432      * Emits a {Transfer} event with `to` set to the zero address.
1433      *
1434      * Requirements:
1435      *
1436      * - `account` cannot be the zero address.
1437      * - `account` must have at least `amount` tokens.
1438      */
1439     function _burn(address account, uint256 amount) internal virtual {
1440         require(account != address(0), "ERC20: burn from the zero address");
1441 
1442         _beforeTokenTransfer(account, address(0), amount);
1443 
1444         uint256 accountBalance = _balances[account];
1445         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1446         unchecked {
1447             _balances[account] = accountBalance - amount;
1448         }
1449         _totalSupply -= amount;
1450 
1451         emit Transfer(account, address(0), amount);
1452 
1453         _afterTokenTransfer(account, address(0), amount);
1454     }
1455 
1456     /**
1457      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1458      *
1459      * This internal function is equivalent to `approve`, and can be used to
1460      * e.g. set automatic allowances for certain subsystems, etc.
1461      *
1462      * Emits an {Approval} event.
1463      *
1464      * Requirements:
1465      *
1466      * - `owner` cannot be the zero address.
1467      * - `spender` cannot be the zero address.
1468      */
1469     function _approve(
1470         address owner,
1471         address spender,
1472         uint256 amount
1473     ) internal virtual {
1474         require(owner != address(0), "ERC20: approve from the zero address");
1475         require(spender != address(0), "ERC20: approve to the zero address");
1476 
1477         _allowances[owner][spender] = amount;
1478         emit Approval(owner, spender, amount);
1479     }
1480 
1481     /**
1482      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1483      *
1484      * Does not update the allowance amount in case of infinite allowance.
1485      * Revert if not enough allowance is available.
1486      *
1487      * Might emit an {Approval} event.
1488      */
1489     function _spendAllowance(
1490         address owner,
1491         address spender,
1492         uint256 amount
1493     ) internal virtual {
1494         uint256 currentAllowance = allowance(owner, spender);
1495         if (currentAllowance != type(uint256).max) {
1496             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1497             unchecked {
1498                 _approve(owner, spender, currentAllowance - amount);
1499             }
1500         }
1501     }
1502 
1503     /**
1504      * @dev Hook that is called before any transfer of tokens. This includes
1505      * minting and burning.
1506      *
1507      * Calling conditions:
1508      *
1509      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1510      * will be transferred to `to`.
1511      * - when `from` is zero, `amount` tokens will be minted for `to`.
1512      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1513      * - `from` and `to` are never both zero.
1514      *
1515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1516      */
1517     function _beforeTokenTransfer(
1518         address from,
1519         address to,
1520         uint256 amount
1521     ) internal virtual {}
1522 
1523     /**
1524      * @dev Hook that is called after any transfer of tokens. This includes
1525      * minting and burning.
1526      *
1527      * Calling conditions:
1528      *
1529      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1530      * has been transferred to `to`.
1531      * - when `from` is zero, `amount` tokens have been minted for `to`.
1532      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1533      * - `from` and `to` are never both zero.
1534      *
1535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1536      */
1537     function _afterTokenTransfer(
1538         address from,
1539         address to,
1540         uint256 amount
1541     ) internal virtual {}
1542 }
1543 
1544 // File: Exchange.sol
1545 
1546 
1547 pragma solidity ^0.8.11;
1548 
1549 
1550 
1551 
1552 
1553 
1554 
1555 
1556 
1557 contract Exchange is Ownable, ReentrancyGuard {
1558     using SafeMath for uint256;
1559     using SafeERC20 for ERC20;
1560 
1561     mapping(address => uint256) private _tokenListRate;
1562     mapping (address => bool) private _isBlackList;
1563 
1564     address private _goalToken;
1565 
1566     event _exchange(address user, address token, uint256 rate, uint256 amount_from, uint256 amount_to);
1567 
1568     event _addToBlackList(address user);
1569     event _removeFromBlackList(address user);
1570 
1571     event _addToTokenListRate(address token, uint256 rate);
1572     event _removeFromTokenListRate(address token);
1573 
1574     constructor(address token){
1575         _goalToken = token;
1576     }
1577 
1578     function exchange(address user, address token, uint256 amount) public {
1579 
1580         uint256 _amount = amount;
1581 
1582         require(!_isBlackList[user], "Sender in Black List");
1583         require(amount > 0, 'Amount error');
1584 
1585         require(_tokenListRate[token] > 0, "Token not in Allowed List");
1586 
1587         ERC20 _token = ERC20(token);
1588         uint256 _decimals = uint256(_token.decimals());
1589 
1590         // amount = amount.mul(10 ** _decimals);
1591         require(_token.allowance(user, address(this)) >= amount, 'Allowance error');
1592         _token.safeTransferFrom(user, address(this), amount);
1593 
1594 
1595         ERC20 _goal = ERC20(_goalToken);
1596         uint256 _gdecimals = uint256(_goal.decimals());
1597 
1598         amount = _amount.mul(10 ** _gdecimals).div(10 ** _decimals).mul(10 ** 8).div(_tokenListRate[token]);
1599         _goal.safeTransfer(user, amount);
1600 
1601         emit _exchange(user, token, _tokenListRate[token], _amount, amount);
1602 
1603     }
1604 
1605 
1606     function withdraw(address token, uint256 amount) public onlyOwner{
1607 
1608         ERC20 _token = ERC20(token);
1609         //uint256 _decimals = uint256(_token.decimals());
1610         //amount = amount.mul(10 ** _decimals);
1611 
1612         _token.safeTransfer(owner(), amount);
1613 
1614     }
1615 
1616 
1617     function addToBlackList(address user) public onlyOwner {
1618         _isBlackList[user] = true;
1619         emit _addToBlackList(user);
1620     }
1621 
1622     function removeFromBlackList(address user) public onlyOwner {
1623         _isBlackList[user] = false;
1624         emit _removeFromBlackList(user);
1625     }
1626 
1627 
1628     function addTotokenListRate(address token, uint256 rate) public onlyOwner {
1629         _tokenListRate[token] = rate;
1630         emit _addToTokenListRate(token, rate);
1631     }
1632 
1633     function removeFromtokenListRate(address token) public onlyOwner {
1634         _tokenListRate[token] = 0;
1635         emit _removeFromTokenListRate(token);
1636     }
1637 
1638 
1639     function setGoalToken(address token) public onlyOwner {
1640         _goalToken = token;
1641     }
1642 
1643     function getGoalToken() public view onlyOwner returns(address){
1644         return _goalToken;
1645     }
1646 
1647 
1648 }