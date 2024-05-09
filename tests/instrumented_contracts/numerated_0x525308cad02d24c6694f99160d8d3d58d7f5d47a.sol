1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 /*
5   __  __ ___ _      _   _____   __  _____ ___  _  ____   _____  
6  |  \/  |_ _| |    /_\ |   \ \ / / |_   _/ _ \| |/ /\ \ / / _ \ 
7  | |\/| || || |__ / _ \| |) \ V /    | || (_) | ' <  \ V / (_) |
8  |_|  |_|___|____/_/ \_\___/ |_|     |_| \___/|_|\_\  |_| \___/ 
9                                                                 
10 */
11 // SPDX-License-Identifier: MIT
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @title Counters
19  * @author Matt Condon (@shrugs)
20  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
21  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
22  *
23  * Include with `using Counters for Counters.Counter;`
24  */
25 library Counters {
26     struct Counter {
27         // This variable should never be directly accessed by users of the library: interactions must be restricted to
28         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
29         // this feature: see https://github.com/ethereum/solidity/issues/4637
30         uint256 _value; // default: 0
31     }
32 
33     function current(Counter storage counter) internal view returns (uint256) {
34         return counter._value;
35     }
36 
37     function increment(Counter storage counter) internal {
38         unchecked {
39             counter._value += 1;
40         }
41     }
42 
43     function decrement(Counter storage counter) internal {
44         uint256 value = counter._value;
45         require(value > 0, "Counter: decrement overflow");
46         unchecked {
47             counter._value = value - 1;
48         }
49     }
50 
51     function reset(Counter storage counter) internal {
52         counter._value = 0;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/math/Math.sol
57 
58 
59 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Standard math utilities missing in the Solidity language.
65  */
66 library Math {
67     enum Rounding {
68         Down, // Toward negative infinity
69         Up, // Toward infinity
70         Zero // Toward zero
71     }
72 
73     /**
74      * @dev Returns the largest of two numbers.
75      */
76     function max(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a > b ? a : b;
78     }
79 
80     /**
81      * @dev Returns the smallest of two numbers.
82      */
83     function min(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a < b ? a : b;
85     }
86 
87     /**
88      * @dev Returns the average of two numbers. The result is rounded towards
89      * zero.
90      */
91     function average(uint256 a, uint256 b) internal pure returns (uint256) {
92         // (a + b) / 2 can overflow.
93         return (a & b) + (a ^ b) / 2;
94     }
95 
96     /**
97      * @dev Returns the ceiling of the division of two numbers.
98      *
99      * This differs from standard division with `/` in that it rounds up instead
100      * of rounding down.
101      */
102     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
103         // (a + b - 1) / b can overflow on addition, so we distribute.
104         return a == 0 ? 0 : (a - 1) / b + 1;
105     }
106 
107     /**
108      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
109      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
110      * with further edits by Uniswap Labs also under MIT license.
111      */
112     function mulDiv(
113         uint256 x,
114         uint256 y,
115         uint256 denominator
116     ) internal pure returns (uint256 result) {
117         unchecked {
118             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
119             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
120             // variables such that product = prod1 * 2^256 + prod0.
121             uint256 prod0; // Least significant 256 bits of the product
122             uint256 prod1; // Most significant 256 bits of the product
123             assembly {
124                 let mm := mulmod(x, y, not(0))
125                 prod0 := mul(x, y)
126                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
127             }
128 
129             // Handle non-overflow cases, 256 by 256 division.
130             if (prod1 == 0) {
131                 return prod0 / denominator;
132             }
133 
134             // Make sure the result is less than 2^256. Also prevents denominator == 0.
135             require(denominator > prod1);
136 
137             ///////////////////////////////////////////////
138             // 512 by 256 division.
139             ///////////////////////////////////////////////
140 
141             // Make division exact by subtracting the remainder from [prod1 prod0].
142             uint256 remainder;
143             assembly {
144                 // Compute remainder using mulmod.
145                 remainder := mulmod(x, y, denominator)
146 
147                 // Subtract 256 bit number from 512 bit number.
148                 prod1 := sub(prod1, gt(remainder, prod0))
149                 prod0 := sub(prod0, remainder)
150             }
151 
152             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
153             // See https://cs.stackexchange.com/q/138556/92363.
154 
155             // Does not overflow because the denominator cannot be zero at this stage in the function.
156             uint256 twos = denominator & (~denominator + 1);
157             assembly {
158                 // Divide denominator by twos.
159                 denominator := div(denominator, twos)
160 
161                 // Divide [prod1 prod0] by twos.
162                 prod0 := div(prod0, twos)
163 
164                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
165                 twos := add(div(sub(0, twos), twos), 1)
166             }
167 
168             // Shift in bits from prod1 into prod0.
169             prod0 |= prod1 * twos;
170 
171             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
172             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
173             // four bits. That is, denominator * inv = 1 mod 2^4.
174             uint256 inverse = (3 * denominator) ^ 2;
175 
176             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
177             // in modular arithmetic, doubling the correct bits in each step.
178             inverse *= 2 - denominator * inverse; // inverse mod 2^8
179             inverse *= 2 - denominator * inverse; // inverse mod 2^16
180             inverse *= 2 - denominator * inverse; // inverse mod 2^32
181             inverse *= 2 - denominator * inverse; // inverse mod 2^64
182             inverse *= 2 - denominator * inverse; // inverse mod 2^128
183             inverse *= 2 - denominator * inverse; // inverse mod 2^256
184 
185             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
186             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
187             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
188             // is no longer required.
189             result = prod0 * inverse;
190             return result;
191         }
192     }
193 
194     /**
195      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
196      */
197     function mulDiv(
198         uint256 x,
199         uint256 y,
200         uint256 denominator,
201         Rounding rounding
202     ) internal pure returns (uint256) {
203         uint256 result = mulDiv(x, y, denominator);
204         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
205             result += 1;
206         }
207         return result;
208     }
209 
210     /**
211      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
212      *
213      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
214      */
215     function sqrt(uint256 a) internal pure returns (uint256) {
216         if (a == 0) {
217             return 0;
218         }
219 
220         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
221         //
222         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
223         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
224         //
225         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
226         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
227         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
228         //
229         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
230         uint256 result = 1 << (log2(a) >> 1);
231 
232         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
233         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
234         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
235         // into the expected uint128 result.
236         unchecked {
237             result = (result + a / result) >> 1;
238             result = (result + a / result) >> 1;
239             result = (result + a / result) >> 1;
240             result = (result + a / result) >> 1;
241             result = (result + a / result) >> 1;
242             result = (result + a / result) >> 1;
243             result = (result + a / result) >> 1;
244             return min(result, a / result);
245         }
246     }
247 
248     /**
249      * @notice Calculates sqrt(a), following the selected rounding direction.
250      */
251     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
252         unchecked {
253             uint256 result = sqrt(a);
254             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
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
304     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
305         unchecked {
306             uint256 result = log2(value);
307             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
308         }
309     }
310 
311     /**
312      * @dev Return the log in base 10, rounded down, of a positive value.
313      * Returns 0 if given 0.
314      */
315     function log10(uint256 value) internal pure returns (uint256) {
316         uint256 result = 0;
317         unchecked {
318             if (value >= 10**64) {
319                 value /= 10**64;
320                 result += 64;
321             }
322             if (value >= 10**32) {
323                 value /= 10**32;
324                 result += 32;
325             }
326             if (value >= 10**16) {
327                 value /= 10**16;
328                 result += 16;
329             }
330             if (value >= 10**8) {
331                 value /= 10**8;
332                 result += 8;
333             }
334             if (value >= 10**4) {
335                 value /= 10**4;
336                 result += 4;
337             }
338             if (value >= 10**2) {
339                 value /= 10**2;
340                 result += 2;
341             }
342             if (value >= 10**1) {
343                 result += 1;
344             }
345         }
346         return result;
347     }
348 
349     /**
350      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
351      * Returns 0 if given 0.
352      */
353     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
354         unchecked {
355             uint256 result = log10(value);
356             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
357         }
358     }
359 
360     /**
361      * @dev Return the log in base 256, rounded down, of a positive value.
362      * Returns 0 if given 0.
363      *
364      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
365      */
366     function log256(uint256 value) internal pure returns (uint256) {
367         uint256 result = 0;
368         unchecked {
369             if (value >> 128 > 0) {
370                 value >>= 128;
371                 result += 16;
372             }
373             if (value >> 64 > 0) {
374                 value >>= 64;
375                 result += 8;
376             }
377             if (value >> 32 > 0) {
378                 value >>= 32;
379                 result += 4;
380             }
381             if (value >> 16 > 0) {
382                 value >>= 16;
383                 result += 2;
384             }
385             if (value >> 8 > 0) {
386                 result += 1;
387             }
388         }
389         return result;
390     }
391 
392     /**
393      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
394      * Returns 0 if given 0.
395      */
396     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
397         unchecked {
398             uint256 result = log256(value);
399             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/utils/Strings.sol
405 
406 
407 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 
412 /**
413  * @dev String operations.
414  */
415 library Strings {
416     bytes16 private constant _SYMBOLS = "0123456789abcdef";
417     uint8 private constant _ADDRESS_LENGTH = 20;
418 
419     /**
420      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
421      */
422     function toString(uint256 value) internal pure returns (string memory) {
423         unchecked {
424             uint256 length = Math.log10(value) + 1;
425             string memory buffer = new string(length);
426             uint256 ptr;
427             /// @solidity memory-safe-assembly
428             assembly {
429                 ptr := add(buffer, add(32, length))
430             }
431             while (true) {
432                 ptr--;
433                 /// @solidity memory-safe-assembly
434                 assembly {
435                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
436                 }
437                 value /= 10;
438                 if (value == 0) break;
439             }
440             return buffer;
441         }
442     }
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
446      */
447     function toHexString(uint256 value) internal pure returns (string memory) {
448         unchecked {
449             return toHexString(value, Math.log256(value) + 1);
450         }
451     }
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
455      */
456     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
457         bytes memory buffer = new bytes(2 * length + 2);
458         buffer[0] = "0";
459         buffer[1] = "x";
460         for (uint256 i = 2 * length + 1; i > 1; --i) {
461             buffer[i] = _SYMBOLS[value & 0xf];
462             value >>= 4;
463         }
464         require(value == 0, "Strings: hex length insufficient");
465         return string(buffer);
466     }
467 
468     /**
469      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
470      */
471     function toHexString(address addr) internal pure returns (string memory) {
472         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Context.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Provides information about the current execution context, including the
485  * sender of the transaction and its data. While these are generally available
486  * via msg.sender and msg.data, they should not be accessed in such a direct
487  * manner, since when dealing with meta-transactions the account sending and
488  * paying for execution may not be the actual sender (as far as an application
489  * is concerned).
490  *
491  * This contract is only required for intermediate, library-like contracts.
492  */
493 abstract contract Context {
494     function _msgSender() internal view virtual returns (address) {
495         return msg.sender;
496     }
497 
498     function _msgData() internal view virtual returns (bytes calldata) {
499         return msg.data;
500     }
501 }
502 
503 // File: @openzeppelin/contracts/access/Ownable.sol
504 
505 
506 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Contract module which provides a basic access control mechanism, where
513  * there is an account (an owner) that can be granted exclusive access to
514  * specific functions.
515  *
516  * By default, the owner account will be the one that deploys the contract. This
517  * can later be changed with {transferOwnership}.
518  *
519  * This module is used through inheritance. It will make available the modifier
520  * `onlyOwner`, which can be applied to your functions to restrict their use to
521  * the owner.
522  */
523 abstract contract Ownable is Context {
524     address private _owner;
525 
526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
527 
528     /**
529      * @dev Initializes the contract setting the deployer as the initial owner.
530      */
531     constructor() {
532         _transferOwnership(_msgSender());
533     }
534 
535     /**
536      * @dev Throws if called by any account other than the owner.
537      */
538     modifier onlyOwner() {
539         _checkOwner();
540         _;
541     }
542 
543     /**
544      * @dev Returns the address of the current owner.
545      */
546     function owner() public view virtual returns (address) {
547         return _owner;
548     }
549 
550     /**
551      * @dev Throws if the sender is not the owner.
552      */
553     function _checkOwner() internal view virtual {
554         require(owner() == _msgSender(), "Ownable: caller is not the owner");
555     }
556 
557     /**
558      * @dev Leaves the contract without owner. It will not be possible to call
559      * `onlyOwner` functions anymore. Can only be called by the current owner.
560      *
561      * NOTE: Renouncing ownership will leave the contract without an owner,
562      * thereby removing any functionality that is only available to the owner.
563      */
564     function renounceOwnership() public virtual onlyOwner {
565         _transferOwnership(address(0));
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Can only be called by the current owner.
571      */
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         _transferOwnership(newOwner);
575     }
576 
577     /**
578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
579      * Internal function without access restriction.
580      */
581     function _transferOwnership(address newOwner) internal virtual {
582         address oldOwner = _owner;
583         _owner = newOwner;
584         emit OwnershipTransferred(oldOwner, newOwner);
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/Address.sol
589 
590 
591 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
592 
593 pragma solidity ^0.8.1;
594 
595 /**
596  * @dev Collection of functions related to the address type
597  */
598 library Address {
599     /**
600      * @dev Returns true if `account` is a contract.
601      *
602      * [IMPORTANT]
603      * ====
604      * It is unsafe to assume that an address for which this function returns
605      * false is an externally-owned account (EOA) and not a contract.
606      *
607      * Among others, `isContract` will return false for the following
608      * types of addresses:
609      *
610      *  - an externally-owned account
611      *  - a contract in construction
612      *  - an address where a contract will be created
613      *  - an address where a contract lived, but was destroyed
614      * ====
615      *
616      * [IMPORTANT]
617      * ====
618      * You shouldn't rely on `isContract` to protect against flash loan attacks!
619      *
620      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
621      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
622      * constructor.
623      * ====
624      */
625     function isContract(address account) internal view returns (bool) {
626         // This method relies on extcodesize/address.code.length, which returns 0
627         // for contracts in construction, since the code is only stored at the end
628         // of the constructor execution.
629 
630         return account.code.length > 0;
631     }
632 
633     /**
634      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
635      * `recipient`, forwarding all available gas and reverting on errors.
636      *
637      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
638      * of certain opcodes, possibly making contracts go over the 2300 gas limit
639      * imposed by `transfer`, making them unable to receive funds via
640      * `transfer`. {sendValue} removes this limitation.
641      *
642      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
643      *
644      * IMPORTANT: because control is transferred to `recipient`, care must be
645      * taken to not create reentrancy vulnerabilities. Consider using
646      * {ReentrancyGuard} or the
647      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
648      */
649     function sendValue(address payable recipient, uint256 amount) internal {
650         require(address(this).balance >= amount, "Address: insufficient balance");
651 
652         (bool success, ) = recipient.call{value: amount}("");
653         require(success, "Address: unable to send value, recipient may have reverted");
654     }
655 
656     /**
657      * @dev Performs a Solidity function call using a low level `call`. A
658      * plain `call` is an unsafe replacement for a function call: use this
659      * function instead.
660      *
661      * If `target` reverts with a revert reason, it is bubbled up by this
662      * function (like regular Solidity function calls).
663      *
664      * Returns the raw returned data. To convert to the expected return value,
665      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
666      *
667      * Requirements:
668      *
669      * - `target` must be a contract.
670      * - calling `target` with `data` must not revert.
671      *
672      * _Available since v3.1._
673      */
674     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
675         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
680      * `errorMessage` as a fallback revert reason when `target` reverts.
681      *
682      * _Available since v3.1._
683      */
684     function functionCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         return functionCallWithValue(target, data, 0, errorMessage);
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
694      * but also transferring `value` wei to `target`.
695      *
696      * Requirements:
697      *
698      * - the calling contract must have an ETH balance of at least `value`.
699      * - the called Solidity function must be `payable`.
700      *
701      * _Available since v3.1._
702      */
703     function functionCallWithValue(
704         address target,
705         bytes memory data,
706         uint256 value
707     ) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
713      * with `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCallWithValue(
718         address target,
719         bytes memory data,
720         uint256 value,
721         string memory errorMessage
722     ) internal returns (bytes memory) {
723         require(address(this).balance >= value, "Address: insufficient balance for call");
724         (bool success, bytes memory returndata) = target.call{value: value}(data);
725         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
730      * but performing a static call.
731      *
732      * _Available since v3.3._
733      */
734     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
735         return functionStaticCall(target, data, "Address: low-level static call failed");
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
740      * but performing a static call.
741      *
742      * _Available since v3.3._
743      */
744     function functionStaticCall(
745         address target,
746         bytes memory data,
747         string memory errorMessage
748     ) internal view returns (bytes memory) {
749         (bool success, bytes memory returndata) = target.staticcall(data);
750         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but performing a delegate call.
756      *
757      * _Available since v3.4._
758      */
759     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
760         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
765      * but performing a delegate call.
766      *
767      * _Available since v3.4._
768      */
769     function functionDelegateCall(
770         address target,
771         bytes memory data,
772         string memory errorMessage
773     ) internal returns (bytes memory) {
774         (bool success, bytes memory returndata) = target.delegatecall(data);
775         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
780      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
781      *
782      * _Available since v4.8._
783      */
784     function verifyCallResultFromTarget(
785         address target,
786         bool success,
787         bytes memory returndata,
788         string memory errorMessage
789     ) internal view returns (bytes memory) {
790         if (success) {
791             if (returndata.length == 0) {
792                 // only check isContract if the call was successful and the return data is empty
793                 // otherwise we already know that it was a contract
794                 require(isContract(target), "Address: call to non-contract");
795             }
796             return returndata;
797         } else {
798             _revert(returndata, errorMessage);
799         }
800     }
801 
802     /**
803      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
804      * revert reason or using the provided one.
805      *
806      * _Available since v4.3._
807      */
808     function verifyCallResult(
809         bool success,
810         bytes memory returndata,
811         string memory errorMessage
812     ) internal pure returns (bytes memory) {
813         if (success) {
814             return returndata;
815         } else {
816             _revert(returndata, errorMessage);
817         }
818     }
819 
820     function _revert(bytes memory returndata, string memory errorMessage) private pure {
821         // Look for revert reason and bubble it up if present
822         if (returndata.length > 0) {
823             // The easiest way to bubble the revert reason is using memory via assembly
824             /// @solidity memory-safe-assembly
825             assembly {
826                 let returndata_size := mload(returndata)
827                 revert(add(32, returndata), returndata_size)
828             }
829         } else {
830             revert(errorMessage);
831         }
832     }
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
836 
837 
838 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @title ERC721 token receiver interface
844  * @dev Interface for any contract that wants to support safeTransfers
845  * from ERC721 asset contracts.
846  */
847 interface IERC721Receiver {
848     /**
849      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
850      * by `operator` from `from`, this function is called.
851      *
852      * It must return its Solidity selector to confirm the token transfer.
853      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
854      *
855      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
856      */
857     function onERC721Received(
858         address operator,
859         address from,
860         uint256 tokenId,
861         bytes calldata data
862     ) external returns (bytes4);
863 }
864 
865 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 /**
873  * @dev Interface of the ERC165 standard, as defined in the
874  * https://eips.ethereum.org/EIPS/eip-165[EIP].
875  *
876  * Implementers can declare support of contract interfaces, which can then be
877  * queried by others ({ERC165Checker}).
878  *
879  * For an implementation, see {ERC165}.
880  */
881 interface IERC165 {
882     /**
883      * @dev Returns true if this contract implements the interface defined by
884      * `interfaceId`. See the corresponding
885      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
886      * to learn more about how these ids are created.
887      *
888      * This function call must use less than 30 000 gas.
889      */
890     function supportsInterface(bytes4 interfaceId) external view returns (bool);
891 }
892 
893 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
894 
895 
896 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 
901 /**
902  * @dev Implementation of the {IERC165} interface.
903  *
904  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
905  * for the additional interface id that will be supported. For example:
906  *
907  * ```solidity
908  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
910  * }
911  * ```
912  *
913  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
914  */
915 abstract contract ERC165 is IERC165 {
916     /**
917      * @dev See {IERC165-supportsInterface}.
918      */
919     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
920         return interfaceId == type(IERC165).interfaceId;
921     }
922 }
923 
924 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
925 
926 
927 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 
932 /**
933  * @dev Required interface of an ERC721 compliant contract.
934  */
935 interface IERC721 is IERC165 {
936     /**
937      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
938      */
939     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
940 
941     /**
942      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
943      */
944     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
945 
946     /**
947      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
948      */
949     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
950 
951     /**
952      * @dev Returns the number of tokens in ``owner``'s account.
953      */
954     function balanceOf(address owner) external view returns (uint256 balance);
955 
956     /**
957      * @dev Returns the owner of the `tokenId` token.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      */
963     function ownerOf(uint256 tokenId) external view returns (address owner);
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`.
967      *
968      * Requirements:
969      *
970      * - `from` cannot be the zero address.
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must exist and be owned by `from`.
973      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
975      *
976      * Emits a {Transfer} event.
977      */
978     function safeTransferFrom(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes calldata data
983     ) external;
984 
985     /**
986      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
987      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) external;
1004 
1005     /**
1006      * @dev Transfers `tokenId` token from `from` to `to`.
1007      *
1008      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1009      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1010      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) external;
1026 
1027     /**
1028      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1029      * The approval is cleared when the token is transferred.
1030      *
1031      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1032      *
1033      * Requirements:
1034      *
1035      * - The caller must own the token or be an approved operator.
1036      * - `tokenId` must exist.
1037      *
1038      * Emits an {Approval} event.
1039      */
1040     function approve(address to, uint256 tokenId) external;
1041 
1042     /**
1043      * @dev Approve or remove `operator` as an operator for the caller.
1044      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1045      *
1046      * Requirements:
1047      *
1048      * - The `operator` cannot be the caller.
1049      *
1050      * Emits an {ApprovalForAll} event.
1051      */
1052     function setApprovalForAll(address operator, bool _approved) external;
1053 
1054     /**
1055      * @dev Returns the account approved for `tokenId` token.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function getApproved(uint256 tokenId) external view returns (address operator);
1062 
1063     /**
1064      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1065      *
1066      * See {setApprovalForAll}
1067      */
1068     function isApprovedForAll(address owner, address operator) external view returns (bool);
1069 }
1070 
1071 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1072 
1073 
1074 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1075 
1076 pragma solidity ^0.8.0;
1077 
1078 
1079 /**
1080  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1081  * @dev See https://eips.ethereum.org/EIPS/eip-721
1082  */
1083 interface IERC721Metadata is IERC721 {
1084     /**
1085      * @dev Returns the token collection name.
1086      */
1087     function name() external view returns (string memory);
1088 
1089     /**
1090      * @dev Returns the token collection symbol.
1091      */
1092     function symbol() external view returns (string memory);
1093 
1094     /**
1095      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1096      */
1097     function tokenURI(uint256 tokenId) external view returns (string memory);
1098 }
1099 
1100 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1101 
1102 
1103 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 /**
1115  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1116  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1117  * {ERC721Enumerable}.
1118  */
1119 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1120     using Address for address;
1121     using Strings for uint256;
1122 
1123     // Token name
1124     string private _name;
1125 
1126     // Token symbol
1127     string private _symbol;
1128 
1129     // Mapping from token ID to owner address
1130     mapping(uint256 => address) private _owners;
1131 
1132     // Mapping owner address to token count
1133     mapping(address => uint256) private _balances;
1134 
1135     // Mapping from token ID to approved address
1136     mapping(uint256 => address) private _tokenApprovals;
1137 
1138     // Mapping from owner to operator approvals
1139     mapping(address => mapping(address => bool)) private _operatorApprovals;
1140 
1141     /**
1142      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1143      */
1144     constructor(string memory name_, string memory symbol_) {
1145         _name = name_;
1146         _symbol = symbol_;
1147     }
1148 
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      */
1152     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1153         return
1154             interfaceId == type(IERC721).interfaceId ||
1155             interfaceId == type(IERC721Metadata).interfaceId ||
1156             super.supportsInterface(interfaceId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-balanceOf}.
1161      */
1162     function balanceOf(address owner) public view virtual override returns (uint256) {
1163         require(owner != address(0), "ERC721: address zero is not a valid owner");
1164         return _balances[owner];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-ownerOf}.
1169      */
1170     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1171         address owner = _ownerOf(tokenId);
1172         require(owner != address(0), "ERC721: invalid token ID");
1173         return owner;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Metadata-name}.
1178      */
1179     function name() public view virtual override returns (string memory) {
1180         return _name;
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Metadata-symbol}.
1185      */
1186     function symbol() public view virtual override returns (string memory) {
1187         return _symbol;
1188     }
1189 
1190     /**
1191      * @dev See {IERC721Metadata-tokenURI}.
1192      */
1193     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1194         _requireMinted(tokenId);
1195 
1196         string memory baseURI = _baseURI();
1197         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1198     }
1199 
1200     /**
1201      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1202      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1203      * by default, can be overridden in child contracts.
1204      */
1205     function _baseURI() internal view virtual returns (string memory) {
1206         return "";
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-approve}.
1211      */
1212     function approve(address to, uint256 tokenId) public virtual override {
1213         address owner = ERC721.ownerOf(tokenId);
1214         require(to != owner, "ERC721: approval to current owner");
1215 
1216         require(
1217             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1218             "ERC721: approve caller is not token owner or approved for all"
1219         );
1220 
1221         _approve(to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-getApproved}.
1226      */
1227     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1228         _requireMinted(tokenId);
1229 
1230         return _tokenApprovals[tokenId];
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-setApprovalForAll}.
1235      */
1236     function setApprovalForAll(address operator, bool approved) public virtual override {
1237         _setApprovalForAll(_msgSender(), operator, approved);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-isApprovedForAll}.
1242      */
1243     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1244         return _operatorApprovals[owner][operator];
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-transferFrom}.
1249      */
1250     function transferFrom(
1251         address from,
1252         address to,
1253         uint256 tokenId
1254     ) public virtual override {
1255         //solhint-disable-next-line max-line-length
1256         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1257 
1258         _transfer(from, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) public virtual override {
1269         safeTransferFrom(from, to, tokenId, "");
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-safeTransferFrom}.
1274      */
1275     function safeTransferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory data
1280     ) public virtual override {
1281         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1282         _safeTransfer(from, to, tokenId, data);
1283     }
1284 
1285     /**
1286      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1287      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1288      *
1289      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1290      *
1291      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1292      * implement alternative mechanisms to perform token transfer, such as signature-based.
1293      *
1294      * Requirements:
1295      *
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      * - `tokenId` token must exist and be owned by `from`.
1299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _safeTransfer(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory data
1308     ) internal virtual {
1309         _transfer(from, to, tokenId);
1310         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1311     }
1312 
1313     /**
1314      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1315      */
1316     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1317         return _owners[tokenId];
1318     }
1319 
1320     /**
1321      * @dev Returns whether `tokenId` exists.
1322      *
1323      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1324      *
1325      * Tokens start existing when they are minted (`_mint`),
1326      * and stop existing when they are burned (`_burn`).
1327      */
1328     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1329         return _ownerOf(tokenId) != address(0);
1330     }
1331 
1332     /**
1333      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1334      *
1335      * Requirements:
1336      *
1337      * - `tokenId` must exist.
1338      */
1339     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1340         address owner = ERC721.ownerOf(tokenId);
1341         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1342     }
1343 
1344     /**
1345      * @dev Safely mints `tokenId` and transfers it to `to`.
1346      *
1347      * Requirements:
1348      *
1349      * - `tokenId` must not exist.
1350      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1351      *
1352      * Emits a {Transfer} event.
1353      */
1354     function _safeMint(address to, uint256 tokenId) internal virtual {
1355         _safeMint(to, tokenId, "");
1356     }
1357 
1358     /**
1359      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1360      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1361      */
1362     function _safeMint(
1363         address to,
1364         uint256 tokenId,
1365         bytes memory data
1366     ) internal virtual {
1367         _mint(to, tokenId);
1368         require(
1369             _checkOnERC721Received(address(0), to, tokenId, data),
1370             "ERC721: transfer to non ERC721Receiver implementer"
1371         );
1372     }
1373 
1374     /**
1375      * @dev Mints `tokenId` and transfers it to `to`.
1376      *
1377      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1378      *
1379      * Requirements:
1380      *
1381      * - `tokenId` must not exist.
1382      * - `to` cannot be the zero address.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _mint(address to, uint256 tokenId) internal virtual {
1387         require(to != address(0), "ERC721: mint to the zero address");
1388         require(!_exists(tokenId), "ERC721: token already minted");
1389 
1390         _beforeTokenTransfer(address(0), to, tokenId, 1);
1391 
1392         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1393         require(!_exists(tokenId), "ERC721: token already minted");
1394 
1395         unchecked {
1396             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1397             // Given that tokens are minted one by one, it is impossible in practice that
1398             // this ever happens. Might change if we allow batch minting.
1399             // The ERC fails to describe this case.
1400             _balances[to] += 1;
1401         }
1402 
1403         _owners[tokenId] = to;
1404 
1405         emit Transfer(address(0), to, tokenId);
1406 
1407         _afterTokenTransfer(address(0), to, tokenId, 1);
1408     }
1409 
1410     /**
1411      * @dev Destroys `tokenId`.
1412      * The approval is cleared when the token is burned.
1413      * This is an internal function that does not check if the sender is authorized to operate on the token.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _burn(uint256 tokenId) internal virtual {
1422         address owner = ERC721.ownerOf(tokenId);
1423 
1424         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1425 
1426         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1427         owner = ERC721.ownerOf(tokenId);
1428 
1429         // Clear approvals
1430         delete _tokenApprovals[tokenId];
1431 
1432         unchecked {
1433             // Cannot overflow, as that would require more tokens to be burned/transferred
1434             // out than the owner initially received through minting and transferring in.
1435             _balances[owner] -= 1;
1436         }
1437         delete _owners[tokenId];
1438 
1439         emit Transfer(owner, address(0), tokenId);
1440 
1441         _afterTokenTransfer(owner, address(0), tokenId, 1);
1442     }
1443 
1444     /**
1445      * @dev Transfers `tokenId` from `from` to `to`.
1446      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1447      *
1448      * Requirements:
1449      *
1450      * - `to` cannot be the zero address.
1451      * - `tokenId` token must be owned by `from`.
1452      *
1453      * Emits a {Transfer} event.
1454      */
1455     function _transfer(
1456         address from,
1457         address to,
1458         uint256 tokenId
1459     ) internal virtual {
1460         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1461         require(to != address(0), "ERC721: transfer to the zero address");
1462 
1463         _beforeTokenTransfer(from, to, tokenId, 1);
1464 
1465         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1466         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1467 
1468         // Clear approvals from the previous owner
1469         delete _tokenApprovals[tokenId];
1470 
1471         unchecked {
1472             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1473             // `from`'s balance is the number of token held, which is at least one before the current
1474             // transfer.
1475             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1476             // all 2**256 token ids to be minted, which in practice is impossible.
1477             _balances[from] -= 1;
1478             _balances[to] += 1;
1479         }
1480         _owners[tokenId] = to;
1481 
1482         emit Transfer(from, to, tokenId);
1483 
1484         _afterTokenTransfer(from, to, tokenId, 1);
1485     }
1486 
1487     /**
1488      * @dev Approve `to` to operate on `tokenId`
1489      *
1490      * Emits an {Approval} event.
1491      */
1492     function _approve(address to, uint256 tokenId) internal virtual {
1493         _tokenApprovals[tokenId] = to;
1494         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1495     }
1496 
1497     /**
1498      * @dev Approve `operator` to operate on all of `owner` tokens
1499      *
1500      * Emits an {ApprovalForAll} event.
1501      */
1502     function _setApprovalForAll(
1503         address owner,
1504         address operator,
1505         bool approved
1506     ) internal virtual {
1507         require(owner != operator, "ERC721: approve to caller");
1508         _operatorApprovals[owner][operator] = approved;
1509         emit ApprovalForAll(owner, operator, approved);
1510     }
1511 
1512     /**
1513      * @dev Reverts if the `tokenId` has not been minted yet.
1514      */
1515     function _requireMinted(uint256 tokenId) internal view virtual {
1516         require(_exists(tokenId), "ERC721: invalid token ID");
1517     }
1518 
1519     /**
1520      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1521      * The call is not executed if the target address is not a contract.
1522      *
1523      * @param from address representing the previous owner of the given token ID
1524      * @param to target address that will receive the tokens
1525      * @param tokenId uint256 ID of the token to be transferred
1526      * @param data bytes optional data to send along with the call
1527      * @return bool whether the call correctly returned the expected magic value
1528      */
1529     function _checkOnERC721Received(
1530         address from,
1531         address to,
1532         uint256 tokenId,
1533         bytes memory data
1534     ) private returns (bool) {
1535         if (to.isContract()) {
1536             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1537                 return retval == IERC721Receiver.onERC721Received.selector;
1538             } catch (bytes memory reason) {
1539                 if (reason.length == 0) {
1540                     revert("ERC721: transfer to non ERC721Receiver implementer");
1541                 } else {
1542                     /// @solidity memory-safe-assembly
1543                     assembly {
1544                         revert(add(32, reason), mload(reason))
1545                     }
1546                 }
1547             }
1548         } else {
1549             return true;
1550         }
1551     }
1552 
1553     /**
1554      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1555      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1556      *
1557      * Calling conditions:
1558      *
1559      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1560      * - When `from` is zero, the tokens will be minted for `to`.
1561      * - When `to` is zero, ``from``'s tokens will be burned.
1562      * - `from` and `to` are never both zero.
1563      * - `batchSize` is non-zero.
1564      *
1565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1566      */
1567     function _beforeTokenTransfer(
1568         address from,
1569         address to,
1570         uint256, /* firstTokenId */
1571         uint256 batchSize
1572     ) internal virtual {
1573         if (batchSize > 1) {
1574             if (from != address(0)) {
1575                 _balances[from] -= batchSize;
1576             }
1577             if (to != address(0)) {
1578                 _balances[to] += batchSize;
1579             }
1580         }
1581     }
1582 
1583     /**
1584      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1585      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1586      *
1587      * Calling conditions:
1588      *
1589      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1590      * - When `from` is zero, the tokens were minted for `to`.
1591      * - When `to` is zero, ``from``'s tokens were burned.
1592      * - `from` and `to` are never both zero.
1593      * - `batchSize` is non-zero.
1594      *
1595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1596      */
1597     function _afterTokenTransfer(
1598         address from,
1599         address to,
1600         uint256 firstTokenId,
1601         uint256 batchSize
1602     ) internal virtual {}
1603 }
1604 
1605 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1606 
1607 
1608 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
1609 
1610 pragma solidity ^0.8.0;
1611 
1612 
1613 
1614 /**
1615  * @title ERC721 Burnable Token
1616  * @dev ERC721 Token that can be burned (destroyed).
1617  */
1618 abstract contract ERC721Burnable is Context, ERC721 {
1619     /**
1620      * @dev Burns `tokenId`. See {ERC721-_burn}.
1621      *
1622      * Requirements:
1623      *
1624      * - The caller must own `tokenId` or be an approved operator.
1625      */
1626     function burn(uint256 tokenId) public virtual {
1627         //solhint-disable-next-line max-line-length
1628         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1629         _burn(tokenId);
1630     }
1631 }
1632 
1633 // File: miladytokyo.sol
1634 
1635 
1636 
1637 pragma solidity >=0.7.0 <0.9.0;
1638 
1639 
1640 
1641 
1642 
1643 contract MiladyTokyo is ERC721, Ownable, ERC721Burnable {
1644     using Strings for uint256;
1645     using Counters for Counters.Counter;
1646 
1647     Counters.Counter private supply;
1648 
1649     string public uriPrefix = "ipfs://bafybeibpx74yumxhbkbjbxk3af4mnbexuwy6ll4mj7sr2ubmi5a2lkmfmy/";
1650     string public uriSuffix = ".json";
1651 
1652     uint256 public cost = 0.01 ether;
1653     uint256 public maxSupply = 5000;
1654     uint256 public maxMintAmountPerTx = 10;
1655     uint256 public maxFreeMints = 420;
1656 
1657     bool public paused = false;
1658 
1659     mapping(address => bool) public hasClaimedFreeNFT;
1660 
1661     constructor() ERC721("MILADY TOKYO", "MILJP") {
1662         _mintLoop(msg.sender, 15);
1663     }
1664 
1665     modifier mintCompliance(uint256 _mintAmount) {
1666         require(_mintAmount > 0, "Invalid mint amount!");
1667         require(_mintAmount <= maxMintAmountPerTx, "Exceeded max mint amount per transaction!");
1668         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1669         _;
1670     }
1671 
1672     function totalSupply() public view returns (uint256) {
1673         return supply.current();
1674     }
1675 
1676     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1677         require(!paused, "The contract is paused!");
1678 
1679         uint256 discountedMints = 0;
1680 
1681         if (maxFreeMints > 0 && !hasClaimedFreeNFT[msg.sender]) {
1682             discountedMints += 1;
1683             maxFreeMints -= 1;
1684             hasClaimedFreeNFT[msg.sender] = true;
1685         }
1686 
1687         uint256 totalCost = cost * (_mintAmount - discountedMints);
1688         uint256 discount = 0;
1689 
1690         if ((_mintAmount - discountedMints) >= maxMintAmountPerTx) {
1691             // Apply 10% discount if purchasing max (when no free mints in place)
1692             discount = totalCost * 10 / 100;
1693         }
1694 
1695         uint256 finalCost = totalCost - discount;
1696         require(msg.value >= finalCost, "Insufficient funds!");
1697 
1698         _mintLoop(msg.sender, _mintAmount);
1699     }
1700 
1701     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1702         uint256 ownerTokenCount = balanceOf(_owner);
1703         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1704         uint256 currentTokenId = 1;
1705         uint256 ownedTokenIndex = 0;
1706 
1707         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1708             address currentTokenOwner = ownerOf(currentTokenId);
1709 
1710             if (currentTokenOwner == _owner) {
1711                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1712                 ownedTokenIndex++;
1713             }
1714 
1715             currentTokenId++;
1716         }
1717 
1718         return ownedTokenIds;
1719     }
1720 
1721     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1722         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1723 
1724         string memory currentBaseURI = _baseURI();
1725         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
1726     }
1727 
1728     function setCost(uint256 _cost) public onlyOwner {
1729         cost = _cost;
1730     }
1731 
1732     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1733         maxMintAmountPerTx = _maxMintAmountPerTx;
1734     }
1735 
1736     function setMaxFreeMints(uint256 _maxFreeMints) public onlyOwner {
1737         maxFreeMints = _maxFreeMints;
1738     }
1739 
1740     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1741         uriPrefix = _uriPrefix;
1742     }
1743 
1744     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1745         uriSuffix = _uriSuffix;
1746     }
1747 
1748     function setPaused(bool _state) public onlyOwner {
1749         paused = _state;
1750     }
1751 
1752     function withdraw() public onlyOwner {
1753         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1754         require(os);
1755     }
1756 
1757     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1758         uint256 i = 0;
1759         while (i < _mintAmount) {
1760             supply.increment();
1761             _safeMint(_receiver, supply.current());
1762             i++;
1763         }
1764     }
1765 
1766     function _baseURI() internal view virtual override returns (string memory) {
1767         return uriPrefix;
1768     }
1769 
1770     function hasClaimed(address _address) public view returns (bool) {
1771         return hasClaimedFreeNFT[_address];
1772     }
1773 }