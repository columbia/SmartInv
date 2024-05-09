1 // File: IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/math/Math.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Standard math utilities missing in the Solidity language.
120  */
121 library Math {
122     enum Rounding {
123         Down, // Toward negative infinity
124         Up, // Toward infinity
125         Zero // Toward zero
126     }
127 
128     /**
129      * @dev Returns the largest of two numbers.
130      */
131     function max(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a > b ? a : b;
133     }
134 
135     /**
136      * @dev Returns the smallest of two numbers.
137      */
138     function min(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a < b ? a : b;
140     }
141 
142     /**
143      * @dev Returns the average of two numbers. The result is rounded towards
144      * zero.
145      */
146     function average(uint256 a, uint256 b) internal pure returns (uint256) {
147         // (a + b) / 2 can overflow.
148         return (a & b) + (a ^ b) / 2;
149     }
150 
151     /**
152      * @dev Returns the ceiling of the division of two numbers.
153      *
154      * This differs from standard division with `/` in that it rounds up instead
155      * of rounding down.
156      */
157     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
158         // (a + b - 1) / b can overflow on addition, so we distribute.
159         return a == 0 ? 0 : (a - 1) / b + 1;
160     }
161 
162     /**
163      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
164      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
165      * with further edits by Uniswap Labs also under MIT license.
166      */
167     function mulDiv(
168         uint256 x,
169         uint256 y,
170         uint256 denominator
171     ) internal pure returns (uint256 result) {
172         unchecked {
173             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
174             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
175             // variables such that product = prod1 * 2^256 + prod0.
176             uint256 prod0; // Least significant 256 bits of the product
177             uint256 prod1; // Most significant 256 bits of the product
178             assembly {
179                 let mm := mulmod(x, y, not(0))
180                 prod0 := mul(x, y)
181                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
182             }
183 
184             // Handle non-overflow cases, 256 by 256 division.
185             if (prod1 == 0) {
186                 return prod0 / denominator;
187             }
188 
189             // Make sure the result is less than 2^256. Also prevents denominator == 0.
190             require(denominator > prod1);
191 
192             ///////////////////////////////////////////////
193             // 512 by 256 division.
194             ///////////////////////////////////////////////
195 
196             // Make division exact by subtracting the remainder from [prod1 prod0].
197             uint256 remainder;
198             assembly {
199                 // Compute remainder using mulmod.
200                 remainder := mulmod(x, y, denominator)
201 
202                 // Subtract 256 bit number from 512 bit number.
203                 prod1 := sub(prod1, gt(remainder, prod0))
204                 prod0 := sub(prod0, remainder)
205             }
206 
207             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
208             // See https://cs.stackexchange.com/q/138556/92363.
209 
210             // Does not overflow because the denominator cannot be zero at this stage in the function.
211             uint256 twos = denominator & (~denominator + 1);
212             assembly {
213                 // Divide denominator by twos.
214                 denominator := div(denominator, twos)
215 
216                 // Divide [prod1 prod0] by twos.
217                 prod0 := div(prod0, twos)
218 
219                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
220                 twos := add(div(sub(0, twos), twos), 1)
221             }
222 
223             // Shift in bits from prod1 into prod0.
224             prod0 |= prod1 * twos;
225 
226             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
227             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
228             // four bits. That is, denominator * inv = 1 mod 2^4.
229             uint256 inverse = (3 * denominator) ^ 2;
230 
231             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
232             // in modular arithmetic, doubling the correct bits in each step.
233             inverse *= 2 - denominator * inverse; // inverse mod 2^8
234             inverse *= 2 - denominator * inverse; // inverse mod 2^16
235             inverse *= 2 - denominator * inverse; // inverse mod 2^32
236             inverse *= 2 - denominator * inverse; // inverse mod 2^64
237             inverse *= 2 - denominator * inverse; // inverse mod 2^128
238             inverse *= 2 - denominator * inverse; // inverse mod 2^256
239 
240             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
241             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
242             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
243             // is no longer required.
244             result = prod0 * inverse;
245             return result;
246         }
247     }
248 
249     /**
250      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
251      */
252     function mulDiv(
253         uint256 x,
254         uint256 y,
255         uint256 denominator,
256         Rounding rounding
257     ) internal pure returns (uint256) {
258         uint256 result = mulDiv(x, y, denominator);
259         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
260             result += 1;
261         }
262         return result;
263     }
264 
265     /**
266      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
267      *
268      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
269      */
270     function sqrt(uint256 a) internal pure returns (uint256) {
271         if (a == 0) {
272             return 0;
273         }
274 
275         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
276         //
277         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
278         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
279         //
280         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
281         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
282         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
283         //
284         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
285         uint256 result = 1 << (log2(a) >> 1);
286 
287         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
288         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
289         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
290         // into the expected uint128 result.
291         unchecked {
292             result = (result + a / result) >> 1;
293             result = (result + a / result) >> 1;
294             result = (result + a / result) >> 1;
295             result = (result + a / result) >> 1;
296             result = (result + a / result) >> 1;
297             result = (result + a / result) >> 1;
298             result = (result + a / result) >> 1;
299             return min(result, a / result);
300         }
301     }
302 
303     /**
304      * @notice Calculates sqrt(a), following the selected rounding direction.
305      */
306     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
307         unchecked {
308             uint256 result = sqrt(a);
309             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
310         }
311     }
312 
313     /**
314      * @dev Return the log in base 2, rounded down, of a positive value.
315      * Returns 0 if given 0.
316      */
317     function log2(uint256 value) internal pure returns (uint256) {
318         uint256 result = 0;
319         unchecked {
320             if (value >> 128 > 0) {
321                 value >>= 128;
322                 result += 128;
323             }
324             if (value >> 64 > 0) {
325                 value >>= 64;
326                 result += 64;
327             }
328             if (value >> 32 > 0) {
329                 value >>= 32;
330                 result += 32;
331             }
332             if (value >> 16 > 0) {
333                 value >>= 16;
334                 result += 16;
335             }
336             if (value >> 8 > 0) {
337                 value >>= 8;
338                 result += 8;
339             }
340             if (value >> 4 > 0) {
341                 value >>= 4;
342                 result += 4;
343             }
344             if (value >> 2 > 0) {
345                 value >>= 2;
346                 result += 2;
347             }
348             if (value >> 1 > 0) {
349                 result += 1;
350             }
351         }
352         return result;
353     }
354 
355     /**
356      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
357      * Returns 0 if given 0.
358      */
359     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
360         unchecked {
361             uint256 result = log2(value);
362             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
363         }
364     }
365 
366     /**
367      * @dev Return the log in base 10, rounded down, of a positive value.
368      * Returns 0 if given 0.
369      */
370     function log10(uint256 value) internal pure returns (uint256) {
371         uint256 result = 0;
372         unchecked {
373             if (value >= 10**64) {
374                 value /= 10**64;
375                 result += 64;
376             }
377             if (value >= 10**32) {
378                 value /= 10**32;
379                 result += 32;
380             }
381             if (value >= 10**16) {
382                 value /= 10**16;
383                 result += 16;
384             }
385             if (value >= 10**8) {
386                 value /= 10**8;
387                 result += 8;
388             }
389             if (value >= 10**4) {
390                 value /= 10**4;
391                 result += 4;
392             }
393             if (value >= 10**2) {
394                 value /= 10**2;
395                 result += 2;
396             }
397             if (value >= 10**1) {
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
408     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
409         unchecked {
410             uint256 result = log10(value);
411             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
412         }
413     }
414 
415     /**
416      * @dev Return the log in base 256, rounded down, of a positive value.
417      * Returns 0 if given 0.
418      *
419      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
420      */
421     function log256(uint256 value) internal pure returns (uint256) {
422         uint256 result = 0;
423         unchecked {
424             if (value >> 128 > 0) {
425                 value >>= 128;
426                 result += 16;
427             }
428             if (value >> 64 > 0) {
429                 value >>= 64;
430                 result += 8;
431             }
432             if (value >> 32 > 0) {
433                 value >>= 32;
434                 result += 4;
435             }
436             if (value >> 16 > 0) {
437                 value >>= 16;
438                 result += 2;
439             }
440             if (value >> 8 > 0) {
441                 result += 1;
442             }
443         }
444         return result;
445     }
446 
447     /**
448      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
449      * Returns 0 if given 0.
450      */
451     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
452         unchecked {
453             uint256 result = log256(value);
454             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/utils/Strings.sol
460 
461 
462 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev String operations.
469  */
470 library Strings {
471     bytes16 private constant _SYMBOLS = "0123456789abcdef";
472     uint8 private constant _ADDRESS_LENGTH = 20;
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
476      */
477     function toString(uint256 value) internal pure returns (string memory) {
478         unchecked {
479             uint256 length = Math.log10(value) + 1;
480             string memory buffer = new string(length);
481             uint256 ptr;
482             /// @solidity memory-safe-assembly
483             assembly {
484                 ptr := add(buffer, add(32, length))
485             }
486             while (true) {
487                 ptr--;
488                 /// @solidity memory-safe-assembly
489                 assembly {
490                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
491                 }
492                 value /= 10;
493                 if (value == 0) break;
494             }
495             return buffer;
496         }
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
501      */
502     function toHexString(uint256 value) internal pure returns (string memory) {
503         unchecked {
504             return toHexString(value, Math.log256(value) + 1);
505         }
506     }
507 
508     /**
509      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
510      */
511     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
512         bytes memory buffer = new bytes(2 * length + 2);
513         buffer[0] = "0";
514         buffer[1] = "x";
515         for (uint256 i = 2 * length + 1; i > 1; --i) {
516             buffer[i] = _SYMBOLS[value & 0xf];
517             value >>= 4;
518         }
519         require(value == 0, "Strings: hex length insufficient");
520         return string(buffer);
521     }
522 
523     /**
524      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
525      */
526     function toHexString(address addr) internal pure returns (string memory) {
527         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/utils/Context.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes calldata) {
554         return msg.data;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/utils/Address.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
562 
563 pragma solidity ^0.8.1;
564 
565 /**
566  * @dev Collection of functions related to the address type
567  */
568 library Address {
569     /**
570      * @dev Returns true if `account` is a contract.
571      *
572      * [IMPORTANT]
573      * ====
574      * It is unsafe to assume that an address for which this function returns
575      * false is an externally-owned account (EOA) and not a contract.
576      *
577      * Among others, `isContract` will return false for the following
578      * types of addresses:
579      *
580      *  - an externally-owned account
581      *  - a contract in construction
582      *  - an address where a contract will be created
583      *  - an address where a contract lived, but was destroyed
584      * ====
585      *
586      * [IMPORTANT]
587      * ====
588      * You shouldn't rely on `isContract` to protect against flash loan attacks!
589      *
590      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
591      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
592      * constructor.
593      * ====
594      */
595     function isContract(address account) internal view returns (bool) {
596         // This method relies on extcodesize/address.code.length, which returns 0
597         // for contracts in construction, since the code is only stored at the end
598         // of the constructor execution.
599 
600         return account.code.length > 0;
601     }
602 
603     /**
604      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
605      * `recipient`, forwarding all available gas and reverting on errors.
606      *
607      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
608      * of certain opcodes, possibly making contracts go over the 2300 gas limit
609      * imposed by `transfer`, making them unable to receive funds via
610      * `transfer`. {sendValue} removes this limitation.
611      *
612      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
613      *
614      * IMPORTANT: because control is transferred to `recipient`, care must be
615      * taken to not create reentrancy vulnerabilities. Consider using
616      * {ReentrancyGuard} or the
617      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
618      */
619     function sendValue(address payable recipient, uint256 amount) internal {
620         require(address(this).balance >= amount, "Address: insufficient balance");
621 
622         (bool success, ) = recipient.call{value: amount}("");
623         require(success, "Address: unable to send value, recipient may have reverted");
624     }
625 
626     /**
627      * @dev Performs a Solidity function call using a low level `call`. A
628      * plain `call` is an unsafe replacement for a function call: use this
629      * function instead.
630      *
631      * If `target` reverts with a revert reason, it is bubbled up by this
632      * function (like regular Solidity function calls).
633      *
634      * Returns the raw returned data. To convert to the expected return value,
635      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
636      *
637      * Requirements:
638      *
639      * - `target` must be a contract.
640      * - calling `target` with `data` must not revert.
641      *
642      * _Available since v3.1._
643      */
644     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
645         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
650      * `errorMessage` as a fallback revert reason when `target` reverts.
651      *
652      * _Available since v3.1._
653      */
654     function functionCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal returns (bytes memory) {
659         return functionCallWithValue(target, data, 0, errorMessage);
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
664      * but also transferring `value` wei to `target`.
665      *
666      * Requirements:
667      *
668      * - the calling contract must have an ETH balance of at least `value`.
669      * - the called Solidity function must be `payable`.
670      *
671      * _Available since v3.1._
672      */
673     function functionCallWithValue(
674         address target,
675         bytes memory data,
676         uint256 value
677     ) internal returns (bytes memory) {
678         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
683      * with `errorMessage` as a fallback revert reason when `target` reverts.
684      *
685      * _Available since v3.1._
686      */
687     function functionCallWithValue(
688         address target,
689         bytes memory data,
690         uint256 value,
691         string memory errorMessage
692     ) internal returns (bytes memory) {
693         require(address(this).balance >= value, "Address: insufficient balance for call");
694         (bool success, bytes memory returndata) = target.call{value: value}(data);
695         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
700      * but performing a static call.
701      *
702      * _Available since v3.3._
703      */
704     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
705         return functionStaticCall(target, data, "Address: low-level static call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
710      * but performing a static call.
711      *
712      * _Available since v3.3._
713      */
714     function functionStaticCall(
715         address target,
716         bytes memory data,
717         string memory errorMessage
718     ) internal view returns (bytes memory) {
719         (bool success, bytes memory returndata) = target.staticcall(data);
720         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
725      * but performing a delegate call.
726      *
727      * _Available since v3.4._
728      */
729     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
730         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
735      * but performing a delegate call.
736      *
737      * _Available since v3.4._
738      */
739     function functionDelegateCall(
740         address target,
741         bytes memory data,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         (bool success, bytes memory returndata) = target.delegatecall(data);
745         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
746     }
747 
748     /**
749      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
750      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
751      *
752      * _Available since v4.8._
753      */
754     function verifyCallResultFromTarget(
755         address target,
756         bool success,
757         bytes memory returndata,
758         string memory errorMessage
759     ) internal view returns (bytes memory) {
760         if (success) {
761             if (returndata.length == 0) {
762                 // only check isContract if the call was successful and the return data is empty
763                 // otherwise we already know that it was a contract
764                 require(isContract(target), "Address: call to non-contract");
765             }
766             return returndata;
767         } else {
768             _revert(returndata, errorMessage);
769         }
770     }
771 
772     /**
773      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
774      * revert reason or using the provided one.
775      *
776      * _Available since v4.3._
777      */
778     function verifyCallResult(
779         bool success,
780         bytes memory returndata,
781         string memory errorMessage
782     ) internal pure returns (bytes memory) {
783         if (success) {
784             return returndata;
785         } else {
786             _revert(returndata, errorMessage);
787         }
788     }
789 
790     function _revert(bytes memory returndata, string memory errorMessage) private pure {
791         // Look for revert reason and bubble it up if present
792         if (returndata.length > 0) {
793             // The easiest way to bubble the revert reason is using memory via assembly
794             /// @solidity memory-safe-assembly
795             assembly {
796                 let returndata_size := mload(returndata)
797                 revert(add(32, returndata), returndata_size)
798             }
799         } else {
800             revert(errorMessage);
801         }
802     }
803 }
804 
805 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
806 
807 
808 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 /**
813  * @title ERC721 token receiver interface
814  * @dev Interface for any contract that wants to support safeTransfers
815  * from ERC721 asset contracts.
816  */
817 interface IERC721Receiver {
818     /**
819      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
820      * by `operator` from `from`, this function is called.
821      *
822      * It must return its Solidity selector to confirm the token transfer.
823      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
824      *
825      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
826      */
827     function onERC721Received(
828         address operator,
829         address from,
830         uint256 tokenId,
831         bytes calldata data
832     ) external returns (bytes4);
833 }
834 
835 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
836 
837 
838 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
839 
840 pragma solidity ^0.8.0;
841 
842 /**
843  * @dev Interface of the ERC165 standard, as defined in the
844  * https://eips.ethereum.org/EIPS/eip-165[EIP].
845  *
846  * Implementers can declare support of contract interfaces, which can then be
847  * queried by others ({ERC165Checker}).
848  *
849  * For an implementation, see {ERC165}.
850  */
851 interface IERC165 {
852     /**
853      * @dev Returns true if this contract implements the interface defined by
854      * `interfaceId`. See the corresponding
855      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
856      * to learn more about how these ids are created.
857      *
858      * This function call must use less than 30 000 gas.
859      */
860     function supportsInterface(bytes4 interfaceId) external view returns (bool);
861 }
862 
863 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
864 
865 
866 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 
871 /**
872  * @dev Implementation of the {IERC165} interface.
873  *
874  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
875  * for the additional interface id that will be supported. For example:
876  *
877  * ```solidity
878  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
880  * }
881  * ```
882  *
883  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
884  */
885 abstract contract ERC165 is IERC165 {
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
890         return interfaceId == type(IERC165).interfaceId;
891     }
892 }
893 
894 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
895 
896 
897 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 
902 /**
903  * @dev Required interface of an ERC721 compliant contract.
904  */
905 interface IERC721 is IERC165 {
906     /**
907      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
908      */
909     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
910 
911     /**
912      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
913      */
914     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
915 
916     /**
917      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
918      */
919     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
920 
921     /**
922      * @dev Returns the number of tokens in ``owner``'s account.
923      */
924     function balanceOf(address owner) external view returns (uint256 balance);
925 
926     /**
927      * @dev Returns the owner of the `tokenId` token.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function ownerOf(uint256 tokenId) external view returns (address owner);
934 
935     /**
936      * @dev Safely transfers `tokenId` token from `from` to `to`.
937      *
938      * Requirements:
939      *
940      * - `from` cannot be the zero address.
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must exist and be owned by `from`.
943      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes calldata data
953     ) external;
954 
955     /**
956      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
957      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must exist and be owned by `from`.
964      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) external;
974 
975     /**
976      * @dev Transfers `tokenId` token from `from` to `to`.
977      *
978      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
979      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
980      * understand this adds an external call which potentially creates a reentrancy vulnerability.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
988      *
989      * Emits a {Transfer} event.
990      */
991     function transferFrom(
992         address from,
993         address to,
994         uint256 tokenId
995     ) external;
996 
997     /**
998      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
999      * The approval is cleared when the token is transferred.
1000      *
1001      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1002      *
1003      * Requirements:
1004      *
1005      * - The caller must own the token or be an approved operator.
1006      * - `tokenId` must exist.
1007      *
1008      * Emits an {Approval} event.
1009      */
1010     function approve(address to, uint256 tokenId) external;
1011 
1012     /**
1013      * @dev Approve or remove `operator` as an operator for the caller.
1014      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1015      *
1016      * Requirements:
1017      *
1018      * - The `operator` cannot be the caller.
1019      *
1020      * Emits an {ApprovalForAll} event.
1021      */
1022     function setApprovalForAll(address operator, bool _approved) external;
1023 
1024     /**
1025      * @dev Returns the account approved for `tokenId` token.
1026      *
1027      * Requirements:
1028      *
1029      * - `tokenId` must exist.
1030      */
1031     function getApproved(uint256 tokenId) external view returns (address operator);
1032 
1033     /**
1034      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1035      *
1036      * See {setApprovalForAll}
1037      */
1038     function isApprovedForAll(address owner, address operator) external view returns (bool);
1039 }
1040 
1041 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1042 
1043 
1044 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 /**
1050  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1051  * @dev See https://eips.ethereum.org/EIPS/eip-721
1052  */
1053 interface IERC721Metadata is IERC721 {
1054     /**
1055      * @dev Returns the token collection name.
1056      */
1057     function name() external view returns (string memory);
1058 
1059     /**
1060      * @dev Returns the token collection symbol.
1061      */
1062     function symbol() external view returns (string memory);
1063 
1064     /**
1065      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1066      */
1067     function tokenURI(uint256 tokenId) external view returns (string memory);
1068 }
1069 
1070 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1071 
1072 
1073 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1074 
1075 pragma solidity ^0.8.0;
1076 
1077 
1078 
1079 
1080 
1081 
1082 
1083 
1084 /**
1085  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1086  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1087  * {ERC721Enumerable}.
1088  */
1089 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1090     using Address for address;
1091     using Strings for uint256;
1092 
1093     // Token name
1094     string private _name;
1095 
1096     // Token symbol
1097     string private _symbol;
1098 
1099     // Mapping from token ID to owner address
1100     mapping(uint256 => address) private _owners;
1101 
1102     // Mapping owner address to token count
1103     mapping(address => uint256) private _balances;
1104 
1105     // Mapping from token ID to approved address
1106     mapping(uint256 => address) private _tokenApprovals;
1107 
1108     // Mapping from owner to operator approvals
1109     mapping(address => mapping(address => bool)) private _operatorApprovals;
1110 
1111     /**
1112      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1113      */
1114     constructor(string memory name_, string memory symbol_) {
1115         _name = name_;
1116         _symbol = symbol_;
1117     }
1118 
1119     /**
1120      * @dev See {IERC165-supportsInterface}.
1121      */
1122     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1123         return
1124             interfaceId == type(IERC721).interfaceId ||
1125             interfaceId == type(IERC721Metadata).interfaceId ||
1126             super.supportsInterface(interfaceId);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-balanceOf}.
1131      */
1132     function balanceOf(address owner) public view virtual override returns (uint256) {
1133         require(owner != address(0), "ERC721: address zero is not a valid owner");
1134         return _balances[owner];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-ownerOf}.
1139      */
1140     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1141         address owner = _ownerOf(tokenId);
1142         require(owner != address(0), "ERC721: invalid token ID");
1143         return owner;
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Metadata-name}.
1148      */
1149     function name() public view virtual override returns (string memory) {
1150         return _name;
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Metadata-symbol}.
1155      */
1156     function symbol() public view virtual override returns (string memory) {
1157         return _symbol;
1158     }
1159 
1160     /**
1161      * @dev See {IERC721Metadata-tokenURI}.
1162      */
1163     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1164         _requireMinted(tokenId);
1165 
1166         string memory baseURI = _baseURI();
1167         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1168     }
1169 
1170     /**
1171      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1172      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1173      * by default, can be overridden in child contracts.
1174      */
1175     function _baseURI() internal view virtual returns (string memory) {
1176         return "";
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-approve}.
1181      */
1182     function approve(address to, uint256 tokenId) public virtual override {
1183         address owner = ERC721.ownerOf(tokenId);
1184         require(to != owner, "ERC721: approval to current owner");
1185 
1186         require(
1187             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1188             "ERC721: approve caller is not token owner or approved for all"
1189         );
1190 
1191         _approve(to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-getApproved}.
1196      */
1197     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1198         _requireMinted(tokenId);
1199 
1200         return _tokenApprovals[tokenId];
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-setApprovalForAll}.
1205      */
1206     function setApprovalForAll(address operator, bool approved) public virtual override {
1207         _setApprovalForAll(_msgSender(), operator, approved);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-isApprovedForAll}.
1212      */
1213     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1214         return _operatorApprovals[owner][operator];
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-transferFrom}.
1219      */
1220     function transferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) public virtual override {
1225         //solhint-disable-next-line max-line-length
1226         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1227 
1228         _transfer(from, to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-safeTransferFrom}.
1233      */
1234     function safeTransferFrom(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) public virtual override {
1239         safeTransferFrom(from, to, tokenId, "");
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-safeTransferFrom}.
1244      */
1245     function safeTransferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes memory data
1250     ) public virtual override {
1251         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1252         _safeTransfer(from, to, tokenId, data);
1253     }
1254 
1255     /**
1256      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1257      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1258      *
1259      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1260      *
1261      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1262      * implement alternative mechanisms to perform token transfer, such as signature-based.
1263      *
1264      * Requirements:
1265      *
1266      * - `from` cannot be the zero address.
1267      * - `to` cannot be the zero address.
1268      * - `tokenId` token must exist and be owned by `from`.
1269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _safeTransfer(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes memory data
1278     ) internal virtual {
1279         _transfer(from, to, tokenId);
1280         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1281     }
1282 
1283     /**
1284      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1285      */
1286     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1287         return _owners[tokenId];
1288     }
1289 
1290     /**
1291      * @dev Returns whether `tokenId` exists.
1292      *
1293      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1294      *
1295      * Tokens start existing when they are minted (`_mint`),
1296      * and stop existing when they are burned (`_burn`).
1297      */
1298     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1299         return _ownerOf(tokenId) != address(0);
1300     }
1301 
1302     /**
1303      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      */
1309     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1310         address owner = ERC721.ownerOf(tokenId);
1311         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1312     }
1313 
1314     /**
1315      * @dev Safely mints `tokenId` and transfers it to `to`.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must not exist.
1320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function _safeMint(address to, uint256 tokenId) internal virtual {
1325         _safeMint(to, tokenId, "");
1326     }
1327 
1328     /**
1329      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1330      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1331      */
1332     function _safeMint(
1333         address to,
1334         uint256 tokenId,
1335         bytes memory data
1336     ) internal virtual {
1337         _mint(to, tokenId);
1338         require(
1339             _checkOnERC721Received(address(0), to, tokenId, data),
1340             "ERC721: transfer to non ERC721Receiver implementer"
1341         );
1342     }
1343 
1344     /**
1345      * @dev Mints `tokenId` and transfers it to `to`.
1346      *
1347      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1348      *
1349      * Requirements:
1350      *
1351      * - `tokenId` must not exist.
1352      * - `to` cannot be the zero address.
1353      *
1354      * Emits a {Transfer} event.
1355      */
1356     function _mint(address to, uint256 tokenId) internal virtual {
1357         require(to != address(0), "ERC721: mint to the zero address");
1358         require(!_exists(tokenId), "ERC721: token already minted");
1359 
1360         _beforeTokenTransfer(address(0), to, tokenId, 1);
1361 
1362         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1363         require(!_exists(tokenId), "ERC721: token already minted");
1364 
1365         unchecked {
1366             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1367             // Given that tokens are minted one by one, it is impossible in practice that
1368             // this ever happens. Might change if we allow batch minting.
1369             // The ERC fails to describe this case.
1370             _balances[to] += 1;
1371         }
1372 
1373         _owners[tokenId] = to;
1374 
1375         emit Transfer(address(0), to, tokenId);
1376 
1377         _afterTokenTransfer(address(0), to, tokenId, 1);
1378     }
1379 
1380     /**
1381      * @dev Destroys `tokenId`.
1382      * The approval is cleared when the token is burned.
1383      * This is an internal function that does not check if the sender is authorized to operate on the token.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must exist.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _burn(uint256 tokenId) internal virtual {
1392         address owner = ERC721.ownerOf(tokenId);
1393 
1394         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1395 
1396         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1397         owner = ERC721.ownerOf(tokenId);
1398 
1399         // Clear approvals
1400         delete _tokenApprovals[tokenId];
1401 
1402         unchecked {
1403             // Cannot overflow, as that would require more tokens to be burned/transferred
1404             // out than the owner initially received through minting and transferring in.
1405             _balances[owner] -= 1;
1406         }
1407         delete _owners[tokenId];
1408 
1409         emit Transfer(owner, address(0), tokenId);
1410 
1411         _afterTokenTransfer(owner, address(0), tokenId, 1);
1412     }
1413 
1414     /**
1415      * @dev Transfers `tokenId` from `from` to `to`.
1416      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1417      *
1418      * Requirements:
1419      *
1420      * - `to` cannot be the zero address.
1421      * - `tokenId` token must be owned by `from`.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _transfer(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) internal virtual {
1430         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1431         require(to != address(0), "ERC721: transfer to the zero address");
1432 
1433         _beforeTokenTransfer(from, to, tokenId, 1);
1434 
1435         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1436         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1437 
1438         // Clear approvals from the previous owner
1439         delete _tokenApprovals[tokenId];
1440 
1441         unchecked {
1442             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1443             // `from`'s balance is the number of token held, which is at least one before the current
1444             // transfer.
1445             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1446             // all 2**256 token ids to be minted, which in practice is impossible.
1447             _balances[from] -= 1;
1448             _balances[to] += 1;
1449         }
1450         _owners[tokenId] = to;
1451 
1452         emit Transfer(from, to, tokenId);
1453 
1454         _afterTokenTransfer(from, to, tokenId, 1);
1455     }
1456 
1457     /**
1458      * @dev Approve `to` to operate on `tokenId`
1459      *
1460      * Emits an {Approval} event.
1461      */
1462     function _approve(address to, uint256 tokenId) internal virtual {
1463         _tokenApprovals[tokenId] = to;
1464         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1465     }
1466 
1467     /**
1468      * @dev Approve `operator` to operate on all of `owner` tokens
1469      *
1470      * Emits an {ApprovalForAll} event.
1471      */
1472     function _setApprovalForAll(
1473         address owner,
1474         address operator,
1475         bool approved
1476     ) internal virtual {
1477         require(owner != operator, "ERC721: approve to caller");
1478         _operatorApprovals[owner][operator] = approved;
1479         emit ApprovalForAll(owner, operator, approved);
1480     }
1481 
1482     /**
1483      * @dev Reverts if the `tokenId` has not been minted yet.
1484      */
1485     function _requireMinted(uint256 tokenId) internal view virtual {
1486         require(_exists(tokenId), "ERC721: invalid token ID");
1487     }
1488 
1489     /**
1490      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1491      * The call is not executed if the target address is not a contract.
1492      *
1493      * @param from address representing the previous owner of the given token ID
1494      * @param to target address that will receive the tokens
1495      * @param tokenId uint256 ID of the token to be transferred
1496      * @param data bytes optional data to send along with the call
1497      * @return bool whether the call correctly returned the expected magic value
1498      */
1499     function _checkOnERC721Received(
1500         address from,
1501         address to,
1502         uint256 tokenId,
1503         bytes memory data
1504     ) private returns (bool) {
1505         if (to.isContract()) {
1506             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1507                 return retval == IERC721Receiver.onERC721Received.selector;
1508             } catch (bytes memory reason) {
1509                 if (reason.length == 0) {
1510                     revert("ERC721: transfer to non ERC721Receiver implementer");
1511                 } else {
1512                     /// @solidity memory-safe-assembly
1513                     assembly {
1514                         revert(add(32, reason), mload(reason))
1515                     }
1516                 }
1517             }
1518         } else {
1519             return true;
1520         }
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1525      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1526      *
1527      * Calling conditions:
1528      *
1529      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1530      * - When `from` is zero, the tokens will be minted for `to`.
1531      * - When `to` is zero, ``from``'s tokens will be burned.
1532      * - `from` and `to` are never both zero.
1533      * - `batchSize` is non-zero.
1534      *
1535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1536      */
1537     function _beforeTokenTransfer(
1538         address from,
1539         address to,
1540         uint256, /* firstTokenId */
1541         uint256 batchSize
1542     ) internal virtual {
1543         if (batchSize > 1) {
1544             if (from != address(0)) {
1545                 _balances[from] -= batchSize;
1546             }
1547             if (to != address(0)) {
1548                 _balances[to] += batchSize;
1549             }
1550         }
1551     }
1552 
1553     /**
1554      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1555      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1556      *
1557      * Calling conditions:
1558      *
1559      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1560      * - When `from` is zero, the tokens were minted for `to`.
1561      * - When `to` is zero, ``from``'s tokens were burned.
1562      * - `from` and `to` are never both zero.
1563      * - `batchSize` is non-zero.
1564      *
1565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1566      */
1567     function _afterTokenTransfer(
1568         address from,
1569         address to,
1570         uint256 firstTokenId,
1571         uint256 batchSize
1572     ) internal virtual {}
1573 }
1574 
1575 // File: TERC721.sol
1576 
1577 pragma solidity ^0.8.13;
1578 
1579 
1580 
1581 
1582 contract DungeonsPass is ERC721, DefaultOperatorFilterer {
1583     address public owner = msg.sender;
1584 
1585     uint256 public supply = 2020;
1586     uint256 public free_supply = 200;
1587     uint256 public price = 2000000000000000;
1588     string public base_uri = "https://dungeonsgenesis.s3.us-west-1.amazonaws.com/";
1589 
1590     uint256 public latest_token_id = 0;
1591 
1592     modifier only_owner() {
1593         require(msg.sender == owner, "This function is restricted to the owner");
1594         _;
1595     }
1596 
1597     constructor() ERC721("Dungeons Pass", "DP") {
1598         owner = msg.sender;
1599     }
1600 
1601     function set_price(uint256 _price) external only_owner {
1602         price = _price;
1603     }
1604 
1605     function set_free_supply(uint256 _free_supply) external only_owner {
1606         free_supply = _free_supply;
1607     }
1608 
1609     function mint(address wallet, uint256 n_items) internal {
1610         require(latest_token_id + n_items <= supply, "Can't mint requested amount!");
1611         for (uint256 i = 0; i < n_items; i++) {
1612             latest_token_id++;
1613             _mint(wallet, latest_token_id);
1614         }
1615     }
1616 
1617     function free_mint() public {
1618         require(latest_token_id < free_supply, "No more free mints!");
1619         mint(msg.sender, 1);
1620     }
1621 
1622     function public_mint(uint256 n_items) external payable {
1623         require(msg.value >= price * n_items, "Not enough eth sent!");
1624         mint(msg.sender, n_items);
1625     }
1626 
1627     function admin_mint(address wallet, uint256 n_items) external only_owner {
1628         mint(wallet, n_items);
1629     }
1630 
1631     function _baseURI() internal view override returns (string memory) {
1632         return base_uri;
1633     }
1634 
1635     function set_base_uri(string memory new_uri) external only_owner {
1636         base_uri = new_uri;
1637     }
1638 
1639     function contractURI() public pure returns (string memory) {
1640         return "http://dungeonspass.com";
1641     }
1642 
1643     function withdraw(address payable wallet) public only_owner {
1644         uint256 amount = address(this).balance;
1645         wallet.transfer(amount);
1646         emit Transfer(address(this), wallet, amount);
1647     }
1648 
1649 
1650     // Creator Royalties ===================================================
1651     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1652         super.setApprovalForAll(operator, approved);
1653     }
1654 
1655     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1656         super.approve(operator, tokenId);
1657     }
1658 
1659     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1660         super.transferFrom(from, to, tokenId);
1661     }
1662 
1663     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1664         super.safeTransferFrom(from, to, tokenId);
1665     }
1666 
1667     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
1668         super.safeTransferFrom(from, to, tokenId, data);
1669     }
1670 }