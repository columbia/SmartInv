1 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard signed math utilities missing in the Solidity language.
10  */
11 library SignedMath {
12     /**
13      * @dev Returns the largest of two signed numbers.
14      */
15     function max(int256 a, int256 b) internal pure returns (int256) {
16         return a > b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two signed numbers.
21      */
22     function min(int256 a, int256 b) internal pure returns (int256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two signed numbers without overflow.
28      * The result is rounded towards zero.
29      */
30     function average(int256 a, int256 b) internal pure returns (int256) {
31         // Formula from the book "Hacker's Delight"
32         int256 x = (a & b) + ((a ^ b) >> 1);
33         return x + (int256(uint256(x) >> 255) & (a ^ b));
34     }
35 
36     /**
37      * @dev Returns the absolute unsigned value of a signed value.
38      */
39     function abs(int256 n) internal pure returns (uint256) {
40         unchecked {
41             // must be unchecked in order to support `n = type(int256).min`
42             return uint256(n >= 0 ? n : -n);
43         }
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard math utilities missing in the Solidity language.
56  */
57 library Math {
58     enum Rounding {
59         Down, // Toward negative infinity
60         Up, // Toward infinity
61         Zero // Toward zero
62     }
63 
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a > b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow.
84         return (a & b) + (a ^ b) / 2;
85     }
86 
87     /**
88      * @dev Returns the ceiling of the division of two numbers.
89      *
90      * This differs from standard division with `/` in that it rounds up instead
91      * of rounding down.
92      */
93     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
94         // (a + b - 1) / b can overflow on addition, so we distribute.
95         return a == 0 ? 0 : (a - 1) / b + 1;
96     }
97 
98     /**
99      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
100      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
101      * with further edits by Uniswap Labs also under MIT license.
102      */
103     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
104         unchecked {
105             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
106             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
107             // variables such that product = prod1 * 2^256 + prod0.
108             uint256 prod0; // Least significant 256 bits of the product
109             uint256 prod1; // Most significant 256 bits of the product
110             assembly {
111                 let mm := mulmod(x, y, not(0))
112                 prod0 := mul(x, y)
113                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
114             }
115 
116             // Handle non-overflow cases, 256 by 256 division.
117             if (prod1 == 0) {
118                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
119                 // The surrounding unchecked block does not change this fact.
120                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
121                 return prod0 / denominator;
122             }
123 
124             // Make sure the result is less than 2^256. Also prevents denominator == 0.
125             require(denominator > prod1, "Math: mulDiv overflow");
126 
127             ///////////////////////////////////////////////
128             // 512 by 256 division.
129             ///////////////////////////////////////////////
130 
131             // Make division exact by subtracting the remainder from [prod1 prod0].
132             uint256 remainder;
133             assembly {
134                 // Compute remainder using mulmod.
135                 remainder := mulmod(x, y, denominator)
136 
137                 // Subtract 256 bit number from 512 bit number.
138                 prod1 := sub(prod1, gt(remainder, prod0))
139                 prod0 := sub(prod0, remainder)
140             }
141 
142             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
143             // See https://cs.stackexchange.com/q/138556/92363.
144 
145             // Does not overflow because the denominator cannot be zero at this stage in the function.
146             uint256 twos = denominator & (~denominator + 1);
147             assembly {
148                 // Divide denominator by twos.
149                 denominator := div(denominator, twos)
150 
151                 // Divide [prod1 prod0] by twos.
152                 prod0 := div(prod0, twos)
153 
154                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
155                 twos := add(div(sub(0, twos), twos), 1)
156             }
157 
158             // Shift in bits from prod1 into prod0.
159             prod0 |= prod1 * twos;
160 
161             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
162             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
163             // four bits. That is, denominator * inv = 1 mod 2^4.
164             uint256 inverse = (3 * denominator) ^ 2;
165 
166             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
167             // in modular arithmetic, doubling the correct bits in each step.
168             inverse *= 2 - denominator * inverse; // inverse mod 2^8
169             inverse *= 2 - denominator * inverse; // inverse mod 2^16
170             inverse *= 2 - denominator * inverse; // inverse mod 2^32
171             inverse *= 2 - denominator * inverse; // inverse mod 2^64
172             inverse *= 2 - denominator * inverse; // inverse mod 2^128
173             inverse *= 2 - denominator * inverse; // inverse mod 2^256
174 
175             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
176             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
177             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
178             // is no longer required.
179             result = prod0 * inverse;
180             return result;
181         }
182     }
183 
184     /**
185      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
186      */
187     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
188         uint256 result = mulDiv(x, y, denominator);
189         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
190             result += 1;
191         }
192         return result;
193     }
194 
195     /**
196      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
197      *
198      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
199      */
200     function sqrt(uint256 a) internal pure returns (uint256) {
201         if (a == 0) {
202             return 0;
203         }
204 
205         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
206         //
207         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
208         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
209         //
210         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
211         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
212         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
213         //
214         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
215         uint256 result = 1 << (log2(a) >> 1);
216 
217         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
218         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
219         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
220         // into the expected uint128 result.
221         unchecked {
222             result = (result + a / result) >> 1;
223             result = (result + a / result) >> 1;
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             result = (result + a / result) >> 1;
227             result = (result + a / result) >> 1;
228             result = (result + a / result) >> 1;
229             return min(result, a / result);
230         }
231     }
232 
233     /**
234      * @notice Calculates sqrt(a), following the selected rounding direction.
235      */
236     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
237         unchecked {
238             uint256 result = sqrt(a);
239             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
240         }
241     }
242 
243     /**
244      * @dev Return the log in base 2, rounded down, of a positive value.
245      * Returns 0 if given 0.
246      */
247     function log2(uint256 value) internal pure returns (uint256) {
248         uint256 result = 0;
249         unchecked {
250             if (value >> 128 > 0) {
251                 value >>= 128;
252                 result += 128;
253             }
254             if (value >> 64 > 0) {
255                 value >>= 64;
256                 result += 64;
257             }
258             if (value >> 32 > 0) {
259                 value >>= 32;
260                 result += 32;
261             }
262             if (value >> 16 > 0) {
263                 value >>= 16;
264                 result += 16;
265             }
266             if (value >> 8 > 0) {
267                 value >>= 8;
268                 result += 8;
269             }
270             if (value >> 4 > 0) {
271                 value >>= 4;
272                 result += 4;
273             }
274             if (value >> 2 > 0) {
275                 value >>= 2;
276                 result += 2;
277             }
278             if (value >> 1 > 0) {
279                 result += 1;
280             }
281         }
282         return result;
283     }
284 
285     /**
286      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
287      * Returns 0 if given 0.
288      */
289     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
290         unchecked {
291             uint256 result = log2(value);
292             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
293         }
294     }
295 
296     /**
297      * @dev Return the log in base 10, rounded down, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value) internal pure returns (uint256) {
301         uint256 result = 0;
302         unchecked {
303             if (value >= 10 ** 64) {
304                 value /= 10 ** 64;
305                 result += 64;
306             }
307             if (value >= 10 ** 32) {
308                 value /= 10 ** 32;
309                 result += 32;
310             }
311             if (value >= 10 ** 16) {
312                 value /= 10 ** 16;
313                 result += 16;
314             }
315             if (value >= 10 ** 8) {
316                 value /= 10 ** 8;
317                 result += 8;
318             }
319             if (value >= 10 ** 4) {
320                 value /= 10 ** 4;
321                 result += 4;
322             }
323             if (value >= 10 ** 2) {
324                 value /= 10 ** 2;
325                 result += 2;
326             }
327             if (value >= 10 ** 1) {
328                 result += 1;
329             }
330         }
331         return result;
332     }
333 
334     /**
335      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
336      * Returns 0 if given 0.
337      */
338     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
339         unchecked {
340             uint256 result = log10(value);
341             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
342         }
343     }
344 
345     /**
346      * @dev Return the log in base 256, rounded down, of a positive value.
347      * Returns 0 if given 0.
348      *
349      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
350      */
351     function log256(uint256 value) internal pure returns (uint256) {
352         uint256 result = 0;
353         unchecked {
354             if (value >> 128 > 0) {
355                 value >>= 128;
356                 result += 16;
357             }
358             if (value >> 64 > 0) {
359                 value >>= 64;
360                 result += 8;
361             }
362             if (value >> 32 > 0) {
363                 value >>= 32;
364                 result += 4;
365             }
366             if (value >> 16 > 0) {
367                 value >>= 16;
368                 result += 2;
369             }
370             if (value >> 8 > 0) {
371                 result += 1;
372             }
373         }
374         return result;
375     }
376 
377     /**
378      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = log256(value);
384             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Strings.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 
398 /**
399  * @dev String operations.
400  */
401 library Strings {
402     bytes16 private constant _SYMBOLS = "0123456789abcdef";
403     uint8 private constant _ADDRESS_LENGTH = 20;
404 
405     /**
406      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
407      */
408     function toString(uint256 value) internal pure returns (string memory) {
409         unchecked {
410             uint256 length = Math.log10(value) + 1;
411             string memory buffer = new string(length);
412             uint256 ptr;
413             /// @solidity memory-safe-assembly
414             assembly {
415                 ptr := add(buffer, add(32, length))
416             }
417             while (true) {
418                 ptr--;
419                 /// @solidity memory-safe-assembly
420                 assembly {
421                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
422                 }
423                 value /= 10;
424                 if (value == 0) break;
425             }
426             return buffer;
427         }
428     }
429 
430     /**
431      * @dev Converts a `int256` to its ASCII `string` decimal representation.
432      */
433     function toString(int256 value) internal pure returns (string memory) {
434         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
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
467 
468     /**
469      * @dev Returns true if the two strings are equal.
470      */
471     function equal(string memory a, string memory b) internal pure returns (bool) {
472         return keccak256(bytes(a)) == keccak256(bytes(b));
473     }
474 }
475 
476 // File: @unlock-protocol/contracts/dist/PublicLock/IPublicLockV13.sol
477 
478 
479 pragma solidity >=0.5.17 <0.9.0;
480 pragma experimental ABIEncoderV2;
481 
482 /**
483  * @title The PublicLock Interface
484  */
485 
486 interface IPublicLockV13 {
487   /// Functions
488   function initialize(
489     address _lockCreator,
490     uint _expirationDuration,
491     address _tokenAddress,
492     uint _keyPrice,
493     uint _maxNumberOfKeys,
494     string calldata _lockName
495   ) external;
496 
497   // default role from OpenZeppelin
498   function DEFAULT_ADMIN_ROLE()
499     external
500     view
501     returns (bytes32 role);
502 
503   /**
504    * @notice The version number of the current implementation on this network.
505    * @return The current version number.
506    */
507   function publicLockVersion()
508     external
509     pure
510     returns (uint16);
511 
512   /**
513    * @dev Called by lock manager to withdraw all funds from the lock
514    * @param _tokenAddress specifies the token address to withdraw or 0 for ETH. This is usually
515    * the same as `tokenAddress` in MixinFunds.
516    * @param _recipient specifies the address that will receive the tokens
517    * @param _amount specifies the max amount to withdraw, which may be reduced when
518    * considering the available balance. Set to 0 or MAX_UINT to withdraw everything.
519    * -- however be wary of draining funds as it breaks the `cancelAndRefund` and `expireAndRefundFor` use cases.
520    */
521   function withdraw(
522     address _tokenAddress,
523     address payable _recipient,
524     uint _amount
525   ) external;
526 
527   /**
528    * A function which lets a Lock manager of the lock to change the price for future purchases.
529    * @dev Throws if called by other than a Lock manager
530    * @dev Throws if lock has been disabled
531    * @dev Throws if _tokenAddress is not a valid token
532    * @param _keyPrice The new price to set for keys
533    * @param _tokenAddress The address of the erc20 token to use for pricing the keys,
534    * or 0 to use ETH
535    */
536   function updateKeyPricing(
537     uint _keyPrice,
538     address _tokenAddress
539   ) external;
540 
541   /**
542    * Update the main key properties for the entire lock:
543    *
544    * - default duration of each key
545    * - the maximum number of keys the lock can edit
546    * - the maximum number of keys a single address can hold
547    *
548    * @notice keys previously bought are unaffected by this changes in expiration duration (i.e.
549    * existing keys timestamps are not recalculated/updated)
550    * @param _newExpirationDuration the new amount of time for each key purchased or type(uint).max for a non-expiring key
551    * @param _maxKeysPerAcccount the maximum amount of key a single user can own
552    * @param _maxNumberOfKeys uint the maximum number of keys
553    * @dev _maxNumberOfKeys Can't be smaller than the existing supply
554    */
555   function updateLockConfig(
556     uint _newExpirationDuration,
557     uint _maxNumberOfKeys,
558     uint _maxKeysPerAcccount
559   ) external;
560 
561   /**
562    * Checks if the user has a non-expired key.
563    * @param _user The address of the key owner
564    */
565   function getHasValidKey(
566     address _user
567   ) external view returns (bool);
568 
569   /**
570    * @dev Returns the key's ExpirationTimestamp field for a given owner.
571    * @param _tokenId the id of the key
572    * @dev Returns 0 if the owner has never owned a key for this lock
573    */
574   function keyExpirationTimestampFor(
575     uint _tokenId
576   ) external view returns (uint timestamp);
577 
578   /**
579    * Public function which returns the total number of unique owners (both expired
580    * and valid).  This may be larger than totalSupply.
581    */
582   function numberOfOwners() external view returns (uint);
583 
584   /**
585    * Allows the Lock owner to assign
586    * @param _lockName a descriptive name for this Lock.
587    * @param _lockSymbol a Symbol for this Lock (default to KEY).
588    * @param _baseTokenURI the baseTokenURI for this Lock
589    */
590   function setLockMetadata(
591     string calldata _lockName,
592     string calldata _lockSymbol,
593     string calldata _baseTokenURI
594   ) external;
595 
596   /**
597    * @dev Gets the token symbol
598    * @return string representing the token symbol
599    */
600   function symbol() external view returns (string memory);
601 
602   /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
603    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
604    *  3986. The URI may point to a JSON file that conforms to the "ERC721
605    *  Metadata JSON Schema".
606    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
607    * @param _tokenId The tokenID we're inquiring about
608    * @return String representing the URI for the requested token
609    */
610   function tokenURI(
611     uint256 _tokenId
612   ) external view returns (string memory);
613 
614   /**
615    * Allows a Lock manager to add or remove an event hook
616    * @param _onKeyPurchaseHook Hook called when the `purchase` function is called
617    * @param _onKeyCancelHook Hook called when the internal `_cancelAndRefund` function is called
618    * @param _onValidKeyHook Hook called to determine if the contract should overide the status for a given address
619    * @param _onTokenURIHook Hook called to generate a data URI used for NFT metadata
620    * @param _onKeyTransferHook Hook called when a key is transfered
621    * @param _onKeyExtendHook Hook called when a key is extended or renewed
622    * @param _onKeyGrantHook Hook called when a key is granted
623    */
624   function setEventHooks(
625     address _onKeyPurchaseHook,
626     address _onKeyCancelHook,
627     address _onValidKeyHook,
628     address _onTokenURIHook,
629     address _onKeyTransferHook,
630     address _onKeyExtendHook,
631     address _onKeyGrantHook
632   ) external;
633 
634   /**
635    * Allows a Lock manager to give a collection of users a key with no charge.
636    * Each key may be assigned a different expiration date.
637    * @dev Throws if called by other than a Lock manager
638    * @param _recipients An array of receiving addresses
639    * @param _expirationTimestamps An array of expiration Timestamps for the keys being granted
640    * @return the ids of the granted tokens
641    */
642   function grantKeys(
643     address[] calldata _recipients,
644     uint[] calldata _expirationTimestamps,
645     address[] calldata _keyManagers
646   ) external returns (uint256[] memory);
647 
648   /**
649    * Allows the Lock owner to extend an existing keys with no charge.
650    * @param _tokenId The id of the token to extend
651    * @param _duration The duration in secondes to add ot the key
652    * @dev set `_duration` to 0 to use the default duration of the lock
653    */
654   function grantKeyExtension(
655     uint _tokenId,
656     uint _duration
657   ) external;
658 
659   /**
660    * @dev Purchase function
661    * @param _values array of tokens amount to pay for this purchase >= the current keyPrice - any applicable discount
662    * (_values is ignored when using ETH)
663    * @param _recipients array of addresses of the recipients of the purchased key
664    * @param _referrers array of addresses of the users making the referral
665    * @param _keyManagers optional array of addresses to grant managing rights to a specific address on creation
666    * @param _data array of arbitrary data populated by the front-end which initiated the sale
667    * @notice when called for an existing and non-expired key, the `_keyManager` param will be ignored
668    * @dev Setting _value to keyPrice exactly doubles as a security feature. That way if the lock owner increases the
669    * price while my transaction is pending I can't be charged more than I expected (only applicable to ERC-20 when more
670    * than keyPrice is approved for spending).
671    * @return tokenIds the ids of the created tokens
672    */
673   function purchase(
674     uint256[] calldata _values,
675     address[] calldata _recipients,
676     address[] calldata _referrers,
677     address[] calldata _keyManagers,
678     bytes[] calldata _data
679   ) external payable returns (uint256[] memory tokenIds);
680 
681   /**
682    * @dev Extend function
683    * @param _value the number of tokens to pay for this purchase >= the current keyPrice - any applicable discount
684    * (_value is ignored when using ETH)
685    * @param _tokenId the id of the key to extend
686    * @param _referrer address of the user making the referral
687    * @param _data arbitrary data populated by the front-end which initiated the sale
688    * @dev Throws if lock is disabled or key does not exist for _recipient. Throws if _recipient == address(0).
689    */
690   function extend(
691     uint _value,
692     uint _tokenId,
693     address _referrer,
694     bytes calldata _data
695   ) external payable;
696 
697   /**
698    * Returns the percentage of the keyPrice to be sent to the referrer (in basis points)
699    * @param _referrer the address of the referrer
700    * @return referrerFee the percentage of the keyPrice to be sent to the referrer (in basis points)
701    */
702   function referrerFees(
703     address _referrer
704   ) external view returns (uint referrerFee);
705 
706   /**
707    * Set a specific percentage of the keyPrice to be sent to the referrer while purchasing,
708    * extending or renewing a key.
709    * @param _referrer the address of the referrer
710    * @param _feeBasisPoint the percentage of the price to be used for this
711    * specific referrer (in basis points)
712    * @dev To send a fixed percentage of the key price to all referrers, sett a percentage to `address(0)`
713    */
714   function setReferrerFee(
715     address _referrer,
716     uint _feeBasisPoint
717   ) external;
718 
719   /**
720    * Merge existing keys
721    * @param _tokenIdFrom the id of the token to substract time from
722    * @param _tokenIdTo the id of the destination token  to add time
723    * @param _amount the amount of time to transfer (in seconds)
724    */
725   function mergeKeys(
726     uint _tokenIdFrom,
727     uint _tokenIdTo,
728     uint _amount
729   ) external;
730 
731   /**
732    * Deactivate an existing key
733    * @param _tokenId the id of token to burn
734    * @notice the key will be expired and ownership records will be destroyed
735    */
736   function burn(uint _tokenId) external;
737 
738   /**
739    * @param _gasRefundValue price in wei or token in smallest price unit
740    * @dev Set the value to be refunded to the sender on purchase
741    */
742   function setGasRefundValue(
743     uint256 _gasRefundValue
744   ) external;
745 
746   /**
747    * _gasRefundValue price in wei or token in smallest price unit
748    * @dev Returns the value/price to be refunded to the sender on purchase
749    */
750   function gasRefundValue()
751     external
752     view
753     returns (uint256 _gasRefundValue);
754 
755   /**
756    * @notice returns the minimum price paid for a purchase with these params.
757    * @dev this considers any discount from Unlock or the OnKeyPurchase hook.
758    */
759   function purchasePriceFor(
760     address _recipient,
761     address _referrer,
762     bytes calldata _data
763   ) external view returns (uint);
764 
765   /**
766    * Allow a Lock manager to change the transfer fee.
767    * @dev Throws if called by other than a Lock manager
768    * @param _transferFeeBasisPoints The new transfer fee in basis-points(bps).
769    * Ex: 200 bps = 2%
770    */
771   function updateTransferFee(
772     uint _transferFeeBasisPoints
773   ) external;
774 
775   /**
776    * Determines how much of a fee would need to be paid in order to
777    * transfer to another account.  This is pro-rated so the fee goes
778    * down overtime.
779    * @dev Throws if _tokenId does not have a valid key
780    * @param _tokenId The id of the key check the transfer fee for.
781    * @param _time The amount of time to calculate the fee for.
782    * @return The transfer fee in seconds.
783    */
784   function getTransferFee(
785     uint _tokenId,
786     uint _time
787   ) external view returns (uint);
788 
789   /**
790    * @dev Invoked by a Lock manager to expire the user's key
791    * and perform a refund and cancellation of the key
792    * @param _tokenId The key id we wish to refund to
793    * @param _amount The amount to refund to the key-owner
794    * @dev Throws if called by other than a Lock manager
795    * @dev Throws if _keyOwner does not have a valid key
796    */
797   function expireAndRefundFor(
798     uint _tokenId,
799     uint _amount
800   ) external;
801 
802   /**
803    * @dev allows the key manager to expire a given tokenId
804    * and send a refund to the keyOwner based on the amount of time remaining.
805    * @param _tokenId The id of the key to cancel.
806    * @notice cancel is enabled with a 10% penalty by default on all Locks.
807    */
808   function cancelAndRefund(uint _tokenId) external;
809 
810   /**
811    * Allow a Lock manager to change the refund penalty.
812    * @dev Throws if called by other than a Lock manager
813    * @param _freeTrialLength The new duration of free trials for this lock
814    * @param _refundPenaltyBasisPoints The new refund penaly in basis-points(bps)
815    */
816   function updateRefundPenalty(
817     uint _freeTrialLength,
818     uint _refundPenaltyBasisPoints
819   ) external;
820 
821   /**
822    * @dev Determines how much of a refund a key owner would receive if they issued
823    * @param _tokenId the id of the token to get the refund value for.
824    * @notice Due to the time required to mine a tx, the actual refund amount will be lower
825    * than what the user reads from this call.
826    * @return refund the amount of tokens refunded
827    */
828   function getCancelAndRefundValue(
829     uint _tokenId
830   ) external view returns (uint refund);
831 
832   function addLockManager(address account) external;
833 
834   function isLockManager(
835     address account
836   ) external view returns (bool);
837 
838   /**
839    * Returns the address of the `onKeyPurchaseHook` hook.
840    * @return hookAddress address of the hook
841    */
842   function onKeyPurchaseHook()
843     external
844     view
845     returns (address hookAddress);
846 
847   /**
848    * Returns the address of the `onKeyCancelHook` hook.
849    * @return hookAddress address of the hook
850    */
851   function onKeyCancelHook()
852     external
853     view
854     returns (address hookAddress);
855 
856   /**
857    * Returns the address of the `onValidKeyHook` hook.
858    * @return hookAddress address of the hook
859    */
860   function onValidKeyHook()
861     external
862     view
863     returns (address hookAddress);
864 
865   /**
866    * Returns the address of the `onTokenURIHook` hook.
867    * @return hookAddress address of the hook
868    */
869   function onTokenURIHook()
870     external
871     view
872     returns (address hookAddress);
873 
874   /**
875    * Returns the address of the `onKeyTransferHook` hook.
876    * @return hookAddress address of the hook
877    */
878   function onKeyTransferHook()
879     external
880     view
881     returns (address hookAddress);
882 
883   /**
884    * Returns the address of the `onKeyExtendHook` hook.
885    * @return hookAddress the address ok the hook
886    */
887   function onKeyExtendHook()
888     external
889     view
890     returns (address hookAddress);
891 
892   /**
893    * Returns the address of the `onKeyGrantHook` hook.
894    * @return hookAddress the address ok the hook
895    */
896   function onKeyGrantHook()
897     external
898     view
899     returns (address hookAddress);
900 
901   function renounceLockManager() external;
902 
903   /**
904    * @return the maximum number of key allowed for a single address
905    */
906   function maxKeysPerAddress() external view returns (uint);
907 
908   function expirationDuration()
909     external
910     view
911     returns (uint256);
912 
913   function freeTrialLength()
914     external
915     view
916     returns (uint256);
917 
918   function keyPrice() external view returns (uint256);
919 
920   function maxNumberOfKeys()
921     external
922     view
923     returns (uint256);
924 
925   function refundPenaltyBasisPoints()
926     external
927     view
928     returns (uint256);
929 
930   function tokenAddress() external view returns (address);
931 
932   function transferFeeBasisPoints()
933     external
934     view
935     returns (uint256);
936 
937   function unlockProtocol() external view returns (address);
938 
939   function keyManagerOf(
940     uint
941   ) external view returns (address);
942 
943   ///===================================================================
944 
945   /**
946    * @notice Allows the key owner to safely share their key (parent key) by
947    * transferring a portion of the remaining time to a new key (child key).
948    * @dev Throws if key is not valid.
949    * @dev Throws if `_to` is the zero address
950    * @param _to The recipient of the shared key
951    * @param _tokenId the key to share
952    * @param _timeShared The amount of time shared
953    * checks if `_to` is a smart contract (code size > 0). If so, it calls
954    * `onERC721Received` on `_to` and throws if the return value is not
955    * `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
956    * @dev Emit Transfer event
957    */
958   function shareKey(
959     address _to,
960     uint _tokenId,
961     uint _timeShared
962   ) external;
963 
964   /**
965    * @notice Update transfer and cancel rights for a given key
966    * @param _tokenId The id of the key to assign rights for
967    * @param _keyManager The address to assign the rights to for the given key
968    */
969   function setKeyManagerOf(
970     uint _tokenId,
971     address _keyManager
972   ) external;
973 
974   /**
975    * Check if a certain key is valid
976    * @param _tokenId the id of the key to check validity
977    * @notice this makes use of the onValidKeyHook if it is set
978    */
979   function isValidKey(
980     uint _tokenId
981   ) external view returns (bool);
982 
983   /**
984    * Returns the number of keys owned by `_keyOwner` (expired or not)
985    * @param _keyOwner address for which we are retrieving the total number of keys
986    * @return numberOfKeys total number of keys owned by the address
987    */
988   function totalKeys(
989     address _keyOwner
990   ) external view returns (uint numberOfKeys);
991 
992   /// @notice A descriptive name for a collection of NFTs in this contract
993   function name()
994     external
995     view
996     returns (string memory _name);
997 
998   ///===================================================================
999 
1000   /// From ERC165.sol
1001   function supportsInterface(
1002     bytes4 interfaceId
1003   ) external view returns (bool);
1004 
1005   ///===================================================================
1006 
1007   /// From ERC-721
1008   /**
1009    * In the specific case of a Lock, `balanceOf` returns only the tokens with a valid expiration timerange
1010    * @return balance The number of valid keys owned by `_keyOwner`
1011    */
1012   function balanceOf(
1013     address _owner
1014   ) external view returns (uint256 balance);
1015 
1016   /**
1017    * @dev Returns the owner of the NFT specified by `tokenId`.
1018    */
1019   function ownerOf(
1020     uint256 tokenId
1021   ) external view returns (address _owner);
1022 
1023   /**
1024    * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1025    * another (`to`).
1026    *
1027    * Requirements:
1028    * - `from`, `to` cannot be zero.
1029    * - `tokenId` must be owned by `from`.
1030    * - If the caller is not `from`, it must be have been allowed to move this
1031    * NFT by either {approve} or {setApprovalForAll}.
1032    */
1033   function safeTransferFrom(
1034     address from,
1035     address to,
1036     uint256 tokenId
1037   ) external;
1038 
1039   /**
1040    * an ERC721-like function to transfer a token from one account to another.
1041    * @param from the owner of token to transfer
1042    * @param to the address that will receive the token
1043    * @param tokenId the id of the token
1044    * @dev Requirements: if the caller is not `from`, it must be approved to move this token by
1045    * either {approve} or {setApprovalForAll}.
1046    * The key manager will be reset to address zero after the transfer
1047    */
1048   function transferFrom(
1049     address from,
1050     address to,
1051     uint256 tokenId
1052   ) external;
1053 
1054   /**
1055    * Lending a key allows you to transfer the token while retaining the
1056    * ownerships right by setting yourself as a key manager first.
1057    * @param from the owner of token to transfer
1058    * @param to the address that will receive the token
1059    * @param tokenId the id of the token
1060    * @notice This function can only be called by 1) the key owner when no key manager is set or 2) the key manager.
1061    * After calling the function, the `_recipent` will be the new owner, and the sender of the tx
1062    * will become the key manager.
1063    */
1064   function lendKey(
1065     address from,
1066     address to,
1067     uint tokenId
1068   ) external;
1069 
1070   /**
1071    * Unlend is called when you have lent a key and want to claim its full ownership back.
1072    * @param _recipient the address that will receive the token ownership
1073    * @param _tokenId the id of the token
1074    * @dev Only the key manager of the token can call this function
1075    */
1076   function unlendKey(
1077     address _recipient,
1078     uint _tokenId
1079   ) external;
1080 
1081   function approve(address to, uint256 tokenId) external;
1082 
1083   /**
1084    * @notice Get the approved address for a single NFT
1085    * @dev Throws if `_tokenId` is not a valid NFT.
1086    * @param _tokenId The NFT to find the approved address for
1087    * @return operator The approved address for this NFT, or the zero address if there is none
1088    */
1089   function getApproved(
1090     uint256 _tokenId
1091   ) external view returns (address operator);
1092 
1093   /**
1094    * @dev Sets or unsets the approval of a given operator
1095    * An operator is allowed to transfer all tokens of the sender on their behalf
1096    * @param _operator operator address to set the approval
1097    * @param _approved representing the status of the approval to be set
1098    * @notice disabled when transfers are disabled
1099    */
1100   function setApprovalForAll(
1101     address _operator,
1102     bool _approved
1103   ) external;
1104 
1105   /**
1106    * @dev Tells whether an operator is approved by a given keyManager
1107    * @param _owner owner address which you want to query the approval of
1108    * @param _operator operator address which you want to query the approval of
1109    * @return bool whether the given operator is approved by the given owner
1110    */
1111   function isApprovedForAll(
1112     address _owner,
1113     address _operator
1114   ) external view returns (bool);
1115 
1116   function safeTransferFrom(
1117     address from,
1118     address to,
1119     uint256 tokenId,
1120     bytes calldata data
1121   ) external;
1122 
1123   /**
1124    * Returns the total number of keys, including non-valid ones
1125    * @return _totalKeysCreated the total number of keys, valid or not
1126    */
1127   function totalSupply() external view returns (uint256 _totalKeysCreated);
1128 
1129   function tokenOfOwnerByIndex(
1130     address _owner,
1131     uint256 index
1132   ) external view returns (uint256 tokenId);
1133 
1134   function tokenByIndex(
1135     uint256 index
1136   ) external view returns (uint256);
1137 
1138   /**
1139    * Innherited from Open Zeppelin AccessControl.sol
1140    */
1141   function getRoleAdmin(
1142     bytes32 role
1143   ) external view returns (bytes32);
1144 
1145   function grantRole(
1146     bytes32 role,
1147     address account
1148   ) external;
1149 
1150   function revokeRole(
1151     bytes32 role,
1152     address account
1153   ) external;
1154 
1155   function renounceRole(
1156     bytes32 role,
1157     address account
1158   ) external;
1159 
1160   function hasRole(
1161     bytes32 role,
1162     address account
1163   ) external view returns (bool);
1164 
1165   /** `owner()` is provided as an helper to mimick the `Ownable` contract ABI.
1166    * The `Ownable` logic is used by many 3rd party services to determine
1167    * contract ownership - e.g. who is allowed to edit metadata on Opensea.
1168    *
1169    * @notice This logic is NOT used internally by the Unlock Protocol and is made
1170    * available only as a convenience helper.
1171    */
1172   function owner() external view returns (address owner);
1173 
1174   function setOwner(address account) external;
1175 
1176   function isOwner(
1177     address account
1178   ) external view returns (bool isOwner);
1179 
1180   /**
1181    * Migrate data from the previous single owner => key mapping to
1182    * the new data structure w multiple tokens.
1183    * @param _calldata an ABI-encoded representation of the params (v10: the number of records to migrate as `uint`)
1184    * @dev when all record schemas are sucessfully upgraded, this function will update the `schemaVersion`
1185    * variable to the latest/current lock version
1186    */
1187   function migrate(bytes calldata _calldata) external;
1188 
1189   /**
1190    * Returns the version number of the data schema currently used by the lock
1191    * @notice if this is different from `publicLockVersion`, then the ability to purchase, grant
1192    * or extend keys is disabled.
1193    * @dev will return 0 if no ;igration has ever been run
1194    */
1195   function schemaVersion() external view returns (uint);
1196 
1197   /**
1198    * Set the schema version to the latest
1199    * @notice only lock manager call call this
1200    */
1201   function updateSchemaVersion() external;
1202 
1203   /**
1204    * Renew a given token
1205    * @notice only works for non-free, expiring, ERC20 locks
1206    * @param _tokenId the ID fo the token to renew
1207    * @param _referrer the address of the person to be granted UDT
1208    */
1209   function renewMembershipFor(
1210     uint _tokenId,
1211     address _referrer
1212   ) external;
1213 
1214   /**
1215    * @dev helper to check if a key is currently renewable 
1216    * it will revert if the pricing or duration of the lock have been modified 
1217    * unfavorably since the key was bought(price increase or duration decrease).
1218    * It will also revert if a lock is not renewable or if the key is not ready for renewal yet 
1219    * (at least 90% expired).
1220    * @param tokenId the id of the token to check
1221    * @param referrer the address where to send the referrer fee
1222    * @return true if the terms has changed
1223    */
1224   function isRenewable(uint256 tokenId, address referrer) external view returns (bool);
1225 }
1226 
1227 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1228 
1229 
1230 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
1231 
1232 pragma solidity ^0.8.0;
1233 
1234 /**
1235  * @dev Contract module that helps prevent reentrant calls to a function.
1236  *
1237  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1238  * available, which can be applied to functions to make sure there are no nested
1239  * (reentrant) calls to them.
1240  *
1241  * Note that because there is a single `nonReentrant` guard, functions marked as
1242  * `nonReentrant` may not call one another. This can be worked around by making
1243  * those functions `private`, and then adding `external` `nonReentrant` entry
1244  * points to them.
1245  *
1246  * TIP: If you would like to learn more about reentrancy and alternative ways
1247  * to protect against it, check out our blog post
1248  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1249  */
1250 abstract contract ReentrancyGuard {
1251     // Booleans are more expensive than uint256 or any type that takes up a full
1252     // word because each write operation emits an extra SLOAD to first read the
1253     // slot's contents, replace the bits taken up by the boolean, and then write
1254     // back. This is the compiler's defense against contract upgrades and
1255     // pointer aliasing, and it cannot be disabled.
1256 
1257     // The values being non-zero value makes deployment a bit more expensive,
1258     // but in exchange the refund on every call to nonReentrant will be lower in
1259     // amount. Since refunds are capped to a percentage of the total
1260     // transaction's gas, it is best to keep them low in cases like this one, to
1261     // increase the likelihood of the full refund coming into effect.
1262     uint256 private constant _NOT_ENTERED = 1;
1263     uint256 private constant _ENTERED = 2;
1264 
1265     uint256 private _status;
1266 
1267     constructor() {
1268         _status = _NOT_ENTERED;
1269     }
1270 
1271     /**
1272      * @dev Prevents a contract from calling itself, directly or indirectly.
1273      * Calling a `nonReentrant` function from another `nonReentrant`
1274      * function is not supported. It is possible to prevent this from happening
1275      * by making the `nonReentrant` function external, and making it call a
1276      * `private` function that does the actual work.
1277      */
1278     modifier nonReentrant() {
1279         _nonReentrantBefore();
1280         _;
1281         _nonReentrantAfter();
1282     }
1283 
1284     function _nonReentrantBefore() private {
1285         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1286         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1287 
1288         // Any calls to nonReentrant after this point will fail
1289         _status = _ENTERED;
1290     }
1291 
1292     function _nonReentrantAfter() private {
1293         // By storing the original value once again, a refund is triggered (see
1294         // https://eips.ethereum.org/EIPS/eip-2200)
1295         _status = _NOT_ENTERED;
1296     }
1297 
1298     /**
1299      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1300      * `nonReentrant` function in the call stack.
1301      */
1302     function _reentrancyGuardEntered() internal view returns (bool) {
1303         return _status == _ENTERED;
1304     }
1305 }
1306 
1307 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1308 
1309 
1310 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 // CAUTION
1315 // This version of SafeMath should only be used with Solidity 0.8 or later,
1316 // because it relies on the compiler's built in overflow checks.
1317 
1318 /**
1319  * @dev Wrappers over Solidity's arithmetic operations.
1320  *
1321  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1322  * now has built in overflow checking.
1323  */
1324 library SafeMath {
1325     /**
1326      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1327      *
1328      * _Available since v3.4._
1329      */
1330     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1331         unchecked {
1332             uint256 c = a + b;
1333             if (c < a) return (false, 0);
1334             return (true, c);
1335         }
1336     }
1337 
1338     /**
1339      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1340      *
1341      * _Available since v3.4._
1342      */
1343     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1344         unchecked {
1345             if (b > a) return (false, 0);
1346             return (true, a - b);
1347         }
1348     }
1349 
1350     /**
1351      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1352      *
1353      * _Available since v3.4._
1354      */
1355     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1356         unchecked {
1357             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1358             // benefit is lost if 'b' is also tested.
1359             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1360             if (a == 0) return (true, 0);
1361             uint256 c = a * b;
1362             if (c / a != b) return (false, 0);
1363             return (true, c);
1364         }
1365     }
1366 
1367     /**
1368      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1369      *
1370      * _Available since v3.4._
1371      */
1372     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1373         unchecked {
1374             if (b == 0) return (false, 0);
1375             return (true, a / b);
1376         }
1377     }
1378 
1379     /**
1380      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1381      *
1382      * _Available since v3.4._
1383      */
1384     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1385         unchecked {
1386             if (b == 0) return (false, 0);
1387             return (true, a % b);
1388         }
1389     }
1390 
1391     /**
1392      * @dev Returns the addition of two unsigned integers, reverting on
1393      * overflow.
1394      *
1395      * Counterpart to Solidity's `+` operator.
1396      *
1397      * Requirements:
1398      *
1399      * - Addition cannot overflow.
1400      */
1401     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1402         return a + b;
1403     }
1404 
1405     /**
1406      * @dev Returns the subtraction of two unsigned integers, reverting on
1407      * overflow (when the result is negative).
1408      *
1409      * Counterpart to Solidity's `-` operator.
1410      *
1411      * Requirements:
1412      *
1413      * - Subtraction cannot overflow.
1414      */
1415     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1416         return a - b;
1417     }
1418 
1419     /**
1420      * @dev Returns the multiplication of two unsigned integers, reverting on
1421      * overflow.
1422      *
1423      * Counterpart to Solidity's `*` operator.
1424      *
1425      * Requirements:
1426      *
1427      * - Multiplication cannot overflow.
1428      */
1429     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1430         return a * b;
1431     }
1432 
1433     /**
1434      * @dev Returns the integer division of two unsigned integers, reverting on
1435      * division by zero. The result is rounded towards zero.
1436      *
1437      * Counterpart to Solidity's `/` operator.
1438      *
1439      * Requirements:
1440      *
1441      * - The divisor cannot be zero.
1442      */
1443     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1444         return a / b;
1445     }
1446 
1447     /**
1448      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1449      * reverting when dividing by zero.
1450      *
1451      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1452      * opcode (which leaves remaining gas untouched) while Solidity uses an
1453      * invalid opcode to revert (consuming all remaining gas).
1454      *
1455      * Requirements:
1456      *
1457      * - The divisor cannot be zero.
1458      */
1459     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1460         return a % b;
1461     }
1462 
1463     /**
1464      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1465      * overflow (when the result is negative).
1466      *
1467      * CAUTION: This function is deprecated because it requires allocating memory for the error
1468      * message unnecessarily. For custom revert reasons use {trySub}.
1469      *
1470      * Counterpart to Solidity's `-` operator.
1471      *
1472      * Requirements:
1473      *
1474      * - Subtraction cannot overflow.
1475      */
1476     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1477         unchecked {
1478             require(b <= a, errorMessage);
1479             return a - b;
1480         }
1481     }
1482 
1483     /**
1484      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1485      * division by zero. The result is rounded towards zero.
1486      *
1487      * Counterpart to Solidity's `/` operator. Note: this function uses a
1488      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1489      * uses an invalid opcode to revert (consuming all remaining gas).
1490      *
1491      * Requirements:
1492      *
1493      * - The divisor cannot be zero.
1494      */
1495     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1496         unchecked {
1497             require(b > 0, errorMessage);
1498             return a / b;
1499         }
1500     }
1501 
1502     /**
1503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1504      * reverting with custom message when dividing by zero.
1505      *
1506      * CAUTION: This function is deprecated because it requires allocating memory for the error
1507      * message unnecessarily. For custom revert reasons use {tryMod}.
1508      *
1509      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1510      * opcode (which leaves remaining gas untouched) while Solidity uses an
1511      * invalid opcode to revert (consuming all remaining gas).
1512      *
1513      * Requirements:
1514      *
1515      * - The divisor cannot be zero.
1516      */
1517     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1518         unchecked {
1519             require(b > 0, errorMessage);
1520             return a % b;
1521         }
1522     }
1523 }
1524 
1525 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1526 
1527 
1528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 /**
1533  * @dev Interface of the ERC165 standard, as defined in the
1534  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1535  *
1536  * Implementers can declare support of contract interfaces, which can then be
1537  * queried by others ({ERC165Checker}).
1538  *
1539  * For an implementation, see {ERC165}.
1540  */
1541 interface IERC165 {
1542     /**
1543      * @dev Returns true if this contract implements the interface defined by
1544      * `interfaceId`. See the corresponding
1545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1546      * to learn more about how these ids are created.
1547      *
1548      * This function call must use less than 30 000 gas.
1549      */
1550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1551 }
1552 
1553 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1554 
1555 
1556 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1557 
1558 pragma solidity ^0.8.0;
1559 
1560 
1561 /**
1562  * @dev Required interface of an ERC721 compliant contract.
1563  */
1564 interface IERC721 is IERC165 {
1565     /**
1566      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1567      */
1568     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1569 
1570     /**
1571      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1572      */
1573     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1574 
1575     /**
1576      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1577      */
1578     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1579 
1580     /**
1581      * @dev Returns the number of tokens in ``owner``'s account.
1582      */
1583     function balanceOf(address owner) external view returns (uint256 balance);
1584 
1585     /**
1586      * @dev Returns the owner of the `tokenId` token.
1587      *
1588      * Requirements:
1589      *
1590      * - `tokenId` must exist.
1591      */
1592     function ownerOf(uint256 tokenId) external view returns (address owner);
1593 
1594     /**
1595      * @dev Safely transfers `tokenId` token from `from` to `to`.
1596      *
1597      * Requirements:
1598      *
1599      * - `from` cannot be the zero address.
1600      * - `to` cannot be the zero address.
1601      * - `tokenId` token must exist and be owned by `from`.
1602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1604      *
1605      * Emits a {Transfer} event.
1606      */
1607     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1608 
1609     /**
1610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1612      *
1613      * Requirements:
1614      *
1615      * - `from` cannot be the zero address.
1616      * - `to` cannot be the zero address.
1617      * - `tokenId` token must exist and be owned by `from`.
1618      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1624 
1625     /**
1626      * @dev Transfers `tokenId` token from `from` to `to`.
1627      *
1628      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1629      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1630      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1631      *
1632      * Requirements:
1633      *
1634      * - `from` cannot be the zero address.
1635      * - `to` cannot be the zero address.
1636      * - `tokenId` token must be owned by `from`.
1637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1638      *
1639      * Emits a {Transfer} event.
1640      */
1641     function transferFrom(address from, address to, uint256 tokenId) external;
1642 
1643     /**
1644      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1645      * The approval is cleared when the token is transferred.
1646      *
1647      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1648      *
1649      * Requirements:
1650      *
1651      * - The caller must own the token or be an approved operator.
1652      * - `tokenId` must exist.
1653      *
1654      * Emits an {Approval} event.
1655      */
1656     function approve(address to, uint256 tokenId) external;
1657 
1658     /**
1659      * @dev Approve or remove `operator` as an operator for the caller.
1660      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1661      *
1662      * Requirements:
1663      *
1664      * - The `operator` cannot be the caller.
1665      *
1666      * Emits an {ApprovalForAll} event.
1667      */
1668     function setApprovalForAll(address operator, bool approved) external;
1669 
1670     /**
1671      * @dev Returns the account approved for `tokenId` token.
1672      *
1673      * Requirements:
1674      *
1675      * - `tokenId` must exist.
1676      */
1677     function getApproved(uint256 tokenId) external view returns (address operator);
1678 
1679     /**
1680      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1681      *
1682      * See {setApprovalForAll}
1683      */
1684     function isApprovedForAll(address owner, address operator) external view returns (bool);
1685 }
1686 
1687 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1688 
1689 
1690 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1691 
1692 pragma solidity ^0.8.0;
1693 
1694 /**
1695  * @dev Interface of the ERC20 standard as defined in the EIP.
1696  */
1697 interface IERC20 {
1698     /**
1699      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1700      * another (`to`).
1701      *
1702      * Note that `value` may be zero.
1703      */
1704     event Transfer(address indexed from, address indexed to, uint256 value);
1705 
1706     /**
1707      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1708      * a call to {approve}. `value` is the new allowance.
1709      */
1710     event Approval(address indexed owner, address indexed spender, uint256 value);
1711 
1712     /**
1713      * @dev Returns the amount of tokens in existence.
1714      */
1715     function totalSupply() external view returns (uint256);
1716 
1717     /**
1718      * @dev Returns the amount of tokens owned by `account`.
1719      */
1720     function balanceOf(address account) external view returns (uint256);
1721 
1722     /**
1723      * @dev Moves `amount` tokens from the caller's account to `to`.
1724      *
1725      * Returns a boolean value indicating whether the operation succeeded.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function transfer(address to, uint256 amount) external returns (bool);
1730 
1731     /**
1732      * @dev Returns the remaining number of tokens that `spender` will be
1733      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1734      * zero by default.
1735      *
1736      * This value changes when {approve} or {transferFrom} are called.
1737      */
1738     function allowance(address owner, address spender) external view returns (uint256);
1739 
1740     /**
1741      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1742      *
1743      * Returns a boolean value indicating whether the operation succeeded.
1744      *
1745      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1746      * that someone may use both the old and the new allowance by unfortunate
1747      * transaction ordering. One possible solution to mitigate this race
1748      * condition is to first reduce the spender's allowance to 0 and set the
1749      * desired value afterwards:
1750      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1751      *
1752      * Emits an {Approval} event.
1753      */
1754     function approve(address spender, uint256 amount) external returns (bool);
1755 
1756     /**
1757      * @dev Moves `amount` tokens from `from` to `to` using the
1758      * allowance mechanism. `amount` is then deducted from the caller's
1759      * allowance.
1760      *
1761      * Returns a boolean value indicating whether the operation succeeded.
1762      *
1763      * Emits a {Transfer} event.
1764      */
1765     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1766 }
1767 
1768 // File: contracts/RFStakePoolV2.sol
1769 
1770 
1771 
1772 // RavenFund - $RAVEN
1773 //
1774 // The raven symbolizes prophecy, insight, transformation, and intelligence. It also represents long-term success.
1775 // The 1st AI-powered hedge fund
1776 //
1777 // https://www.ravenfund.app/
1778 // https://twitter.com/RavenFund
1779 // https://t.me/RavenFundPortal
1780 
1781 pragma solidity ^0.8.19;
1782 
1783 
1784 
1785 
1786 
1787 
1788 
1789 interface IRavenFundStaking {
1790     function stakingToken() external view returns (IERC20);
1791     function rewardsProvider() external view returns (address);
1792     function teamWallet() external view returns (address);
1793     function owner() external view returns (address);
1794     function lockSubNFT(uint256 _index) external view returns (IPublicLockV13, IERC721);
1795     function maxStakeAmount() external view returns (uint256);
1796     function minClaimAmount() external view returns (uint256);
1797     function stakeWaitTime() external view returns (uint256);
1798     function claimInterval() external view returns (uint256);
1799     function timeElapsedFactor() external view returns (uint256);
1800     function rewardResetInterval() external view returns (uint256);
1801     function malusNoSubscription() external view returns (uint256);
1802     function totalDistributed() external view returns (uint256);
1803     function enableClaim() external view returns (bool);
1804     function enableStake() external view returns (bool);
1805     function activateSendTeam() external view returns (bool);
1806     function totalStakedAmount() external view returns (uint256);
1807     function fundDeposits(uint256 _index) external view returns (uint256, uint256);
1808     function consolidatedFunds() external view returns (uint256);
1809     function stakers(address _address) external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256);
1810     function stakerAddresses(uint256 _index) external view returns (address);
1811 }
1812 
1813 contract RavenFundStakingV2 is ReentrancyGuard {
1814     using SafeMath for uint256;
1815 
1816     IRavenFundStaking public ravenFundStakingV1;
1817     address public ravenFundStakingOldAddress;
1818     IERC20 public stakingToken;
1819     address public rewardsProvider;
1820     address public teamWallet;
1821     address public owner;
1822     Lockers[] public lockSubNFT;
1823 
1824     struct Lockers {
1825         IPublicLockV13 instance;
1826         IERC721 nft;
1827     }
1828 
1829     uint256 public maxStakeAmount = 0;
1830     uint256 public minClaimAmount = 15_000 ether;
1831     uint256 public stakeWaitTime = 12 hours;
1832     uint256 public claimInterval = 24 hours;
1833     uint256 public timeElapsedFactor = 7 days;
1834     uint256 public rewardResetInterval = 15 days;
1835     uint256 public malusNoSubscription = 70;
1836     uint256 public totalDistributed = 0;
1837 
1838     bool public enableClaim = false;
1839     bool public enableStake = false;
1840     bool public activateSendTeam = true;
1841     bool public activateConsolidate = true;
1842     bool public activateRestore = true;
1843 
1844     struct StakerInfo {
1845         uint256 amountStaked;
1846         uint256 lastStakeTime;
1847         uint256 lastClaimTime;
1848         uint256 rewardsEarned;
1849         uint256 rewardsClaimed;
1850         uint256 lastRewardUpdateTime;
1851         uint256 keyArray;
1852         bool restoring;
1853     }
1854 
1855     uint256 public totalStakedAmount;
1856 
1857     struct Funds {
1858         uint256 amount;
1859         uint256 depositTime;
1860     }
1861 
1862     Funds[] public fundDeposits;
1863     uint256 public consolidatedFunds = 0;
1864 
1865     mapping(address => StakerInfo) public stakers;
1866     address[] public stakerAddresses;
1867 
1868     constructor(address _stakingToken, address _rewardsProvider, address _teamWallet) {
1869         stakingToken = IERC20(_stakingToken);
1870         rewardsProvider = _rewardsProvider;
1871         teamWallet = _teamWallet;
1872         owner = msg.sender;
1873         ravenFundStakingV1 = IRavenFundStaking(address(0xeb94e7cD446a15DCab9C5d04dc5Bb805E528DCbb));
1874     }
1875 
1876     modifier onlyRewardsProvider() {
1877         require(msg.sender == rewardsProvider || msg.sender == owner || msg.sender == teamWallet, "Not the rewards provider");
1878         _;
1879     }
1880 
1881     function stake(uint256 amount) external nonReentrant {
1882         require(enableStake, "Stake not enabled.");
1883         (uint256 amountStaked, uint256 lastStakeTime, uint256 lastClaimTime, uint256 rewardsEarned, uint256 rewardsClaimed, uint256 lastRewardUpdateTime, uint256 keyArray) = ravenFundStakingV1.stakers(msg.sender);
1884         require(amountStaked <= 0, "Restore your token to the new contract before");
1885         StakerInfo storage staker = stakers[msg.sender];
1886         require(staker.restoring == false, "Finish restore before stake again");
1887         if (maxStakeAmount > 0) {
1888             require(staker.amountStaked + amount <= maxStakeAmount, "Max stake amount reached");
1889         }
1890 
1891         if (staker.lastRewardUpdateTime == 0) {
1892             staker.lastRewardUpdateTime = block.timestamp;
1893         }
1894 
1895         if (staker.keyArray == 0){
1896             stakerAddresses.push(msg.sender);
1897             staker.keyArray = stakerAddresses.length;
1898         }
1899 
1900         uint256 allowance = stakingToken.allowance(msg.sender, address(this));
1901         require(allowance >= amount, "Allowance is not sufficient to stake tokens");
1902 
1903         staker.lastStakeTime = block.timestamp;
1904         staker.amountStaked = staker.amountStaked.add(amount);
1905         totalStakedAmount = totalStakedAmount.add(amount);
1906 
1907         require(stakingToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
1908     }
1909 
1910     function withdraw(uint256 amount) external nonReentrant {
1911         StakerInfo storage staker = stakers[msg.sender];
1912 
1913         require(amount > 0, "Amount must be greater than 0");
1914         require(staker.amountStaked >= amount, "Insufficient staked amount");
1915 
1916         staker.amountStaked = staker.amountStaked.sub(amount);
1917         totalStakedAmount = totalStakedAmount.sub(amount);
1918 
1919         if (staker.amountStaked <= 0) {
1920             uint256 reward = staker.rewardsEarned;
1921             staker.rewardsEarned = 0;
1922             staker.lastClaimTime = block.timestamp;
1923             uint256 contractBalance = address(this).balance;
1924             if (reward > 0 && contractBalance >= reward && activateSendTeam){
1925                 calibrateFundArray(reward);
1926 
1927                 payable(teamWallet).transfer(reward);
1928             }
1929         }
1930 
1931         require(stakingToken.transfer(msg.sender, amount), "Token transfer failed");
1932     }
1933 
1934     function canRestore(address stakerAddress) public view returns (bool) {
1935         (uint256 amountStaked, uint256 lastStakeTime, uint256 lastClaimTime, uint256 rewardsEarned, uint256 rewardsClaimed, uint256 lastRewardUpdateTime, uint256 keyArray) = ravenFundStakingV1.stakers(stakerAddress);
1936         if (amountStaked > 0)
1937         {
1938             StakerInfo storage staker = stakers[stakerAddress];
1939             if (staker.amountStaked <= 0)
1940             {
1941                 return true;
1942             }
1943         }
1944         return false;
1945     }
1946 
1947     function restoreStep1() external nonReentrant {
1948         require(canRestore(msg.sender), "You cannot restore data");
1949         require(activateRestore, "You cannot restore data");
1950         (uint256 amountStaked, uint256 lastStakeTime, uint256 lastClaimTime, uint256 rewardsEarned, uint256 rewardsClaimed, uint256 lastRewardUpdateTime, uint256 keyArray) = ravenFundStakingV1.stakers(msg.sender);
1951 
1952         stakers[msg.sender] = StakerInfo(amountStaked, lastStakeTime, lastClaimTime, rewardsEarned, rewardsClaimed, lastRewardUpdateTime, keyArray, true);
1953         stakerAddresses.push(msg.sender);
1954         stakers[msg.sender].keyArray = stakerAddresses.length;
1955 
1956         //withdraw with contract old
1957     }
1958 
1959     function restoreStep2() external nonReentrant {
1960         // after withdraw with contract old
1961         StakerInfo storage staker = stakers[msg.sender];
1962         require(staker.amountStaked > 0, "Nothing to restore");
1963         require(staker.restoring, "Not in restore mode");
1964 
1965         uint256 allowance = stakingToken.allowance(msg.sender, address(this));
1966         require(allowance >= staker.amountStaked, "Allowance is not sufficient to stake tokens");
1967 
1968         require(stakingToken.transferFrom(msg.sender, address(this), staker.amountStaked), "Token transfer failed");
1969 
1970         staker.restoring = false;
1971         totalStakedAmount = totalStakedAmount.add(staker.amountStaked);
1972     }
1973 
1974     function canClaim(address stakerAddress) public view returns (bool) {
1975         StakerInfo storage staker = stakers[stakerAddress];
1976         uint256 reward = previewStakerRewards(stakerAddress);
1977         uint256 contractBalance = address(this).balance;
1978         return enableClaim && reward > 0 && contractBalance >= reward && (staker.amountStaked >= minClaimAmount) && (block.timestamp > staker.lastStakeTime + stakeWaitTime) && (block.timestamp > staker.lastClaimTime + claimInterval);
1979     }
1980 
1981     function reasonClaim(address stakerAddress) public view returns (string memory) {
1982         StakerInfo storage staker = stakers[stakerAddress];
1983         uint256 reward = previewStakerRewards(stakerAddress);
1984         uint256 contractBalance = address(this).balance;
1985         if (!enableClaim){
1986             return "Claim not enabled, please wait a moment.";
1987         }
1988         if (staker.amountStaked < minClaimAmount) {
1989             return string(abi.encodePacked("To be eligible, you have to stake a minimum $RAVEN of ", Strings.toString(minClaimAmount.div(1 ether))));
1990         }
1991         if (block.timestamp <= staker.lastStakeTime + stakeWaitTime) {
1992             return Strings.toString(staker.lastStakeTime + stakeWaitTime);
1993         }
1994         if (block.timestamp <= staker.lastClaimTime + claimInterval) {
1995             return Strings.toString(staker.lastClaimTime + claimInterval);
1996         }
1997         if (reward <= 0){
1998             return "You don't have any reward to claim for the moment.";
1999         }
2000         if (contractBalance < reward) {
2001             return "Please wait new funds to claim your reward.";
2002         }
2003         return "You can claim !";
2004     }
2005 
2006     function claim() external nonReentrant {
2007         require(enableClaim, "Claim not enabled.");
2008         StakerInfo storage staker = stakers[msg.sender];
2009         require(staker.amountStaked >= minClaimAmount, "Not enough tokens staked to claim.");
2010         require(block.timestamp > staker.lastStakeTime + stakeWaitTime, "Need to wait after staking");
2011         require(block.timestamp > staker.lastClaimTime + claimInterval, "Already claimed recently");
2012 
2013         updateStakerRewards(msg.sender);
2014 
2015         uint256 reward = staker.rewardsEarned;
2016         require(reward > 0, "No rewards available");
2017 
2018         uint256 contractBalance = address(this).balance;
2019         require(contractBalance >= reward, "Not enough ETH in the contract");
2020 
2021         calibrateFundArray(reward);
2022         staker.rewardsEarned = 0;
2023         staker.lastClaimTime = block.timestamp;
2024         staker.rewardsClaimed = staker.rewardsClaimed.add(reward);
2025         totalDistributed = totalDistributed.add(reward);
2026 
2027         payable(msg.sender).transfer(reward);
2028     }
2029 
2030     function previewStakerRewards(address stakerAddress) public view returns (uint256) {
2031         StakerInfo storage staker = stakers[stakerAddress];
2032 
2033         if (staker.amountStaked < minClaimAmount || totalStakedAmount <= 0 || timeElapsedFactor <= 0) {
2034             return staker.rewardsEarned;
2035         }
2036 
2037         uint256 totalReward = 0;
2038         for(uint256 i = 0; i < fundDeposits.length; i++) {
2039             if (fundDeposits[i].amount == 0) {
2040                 continue;
2041             }
2042             uint256 referenceTime = max(staker.lastRewardUpdateTime, fundDeposits[i].depositTime);
2043             uint256 timeElapsed = block.timestamp.sub(referenceTime);
2044             
2045             uint256 timeFactor;
2046             if(timeElapsed >= timeElapsedFactor) {
2047                 timeFactor = 1 ether;
2048             } else {
2049                 timeFactor = timeElapsed.mul(1 ether).div(timeElapsedFactor);
2050             }
2051             
2052             uint256 stakerShare = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
2053             uint256 rewardFromThisDeposit = fundDeposits[i].amount.mul(stakerShare).div(1 ether);
2054             rewardFromThisDeposit = rewardFromThisDeposit.mul(timeFactor).div(1 ether);
2055 
2056             if (!ownsActiveNFT(stakerAddress)) {
2057                 rewardFromThisDeposit = rewardFromThisDeposit.mul(malusNoSubscription).div(100);
2058             }
2059 
2060             totalReward = totalReward.add(rewardFromThisDeposit);
2061         }
2062         // Then add rewards from consolidated funds
2063         uint256 timeElapsedConsolidated = block.timestamp.sub(staker.lastRewardUpdateTime);
2064         uint256 timeFactorConsolidated;
2065         if(timeElapsedConsolidated >= timeElapsedFactor) {
2066             timeFactorConsolidated = 1 ether;
2067         } else {
2068             timeFactorConsolidated = timeElapsedConsolidated.mul(1 ether).div(timeElapsedFactor);
2069         }
2070         uint256 stakerShareFromConsolidated = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
2071         uint256 rewardFromConsolidated = consolidatedFunds.mul(stakerShareFromConsolidated).div(1 ether);
2072         rewardFromConsolidated = rewardFromConsolidated.mul(timeFactorConsolidated).div(1 ether);
2073         if (!ownsActiveNFT(stakerAddress)) {
2074             rewardFromConsolidated = rewardFromConsolidated.mul(malusNoSubscription).div(100);
2075         }
2076 
2077         totalReward = totalReward.add(rewardFromConsolidated);
2078 
2079         return staker.rewardsEarned.add(totalReward);
2080     }
2081 
2082     function updateStakerRewards(address stakerAddress) internal {
2083         StakerInfo storage staker = stakers[stakerAddress];
2084 
2085         if (staker.amountStaked < minClaimAmount || totalStakedAmount <= 0 || timeElapsedFactor <= 0) {
2086             staker.lastRewardUpdateTime = block.timestamp;
2087             return;
2088         }
2089 
2090         uint256 totalReward = 0;
2091         for(uint256 i = 0; i < fundDeposits.length; i++) {
2092             if (fundDeposits[i].amount == 0) {
2093                 continue;
2094             }
2095             uint256 referenceTime = max(staker.lastRewardUpdateTime, fundDeposits[i].depositTime);
2096             uint256 timeElapsed = block.timestamp.sub(referenceTime);
2097             
2098             uint256 timeFactor;
2099             if(timeElapsed >= timeElapsedFactor) {
2100                 timeFactor = 1 ether;
2101             } else {
2102                 timeFactor = timeElapsed.mul(1 ether).div(timeElapsedFactor);
2103             }
2104             
2105             uint256 stakerShare = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
2106             uint256 rewardFromThisDeposit = fundDeposits[i].amount.mul(stakerShare).div(1 ether);
2107             rewardFromThisDeposit = rewardFromThisDeposit.mul(timeFactor).div(1 ether);
2108 
2109             if (!ownsActiveNFT(stakerAddress)) {
2110                 rewardFromThisDeposit = rewardFromThisDeposit.mul(malusNoSubscription).div(100);
2111             }
2112 
2113             totalReward = totalReward.add(rewardFromThisDeposit);
2114         }
2115         // Then add rewards from consolidated funds
2116         uint256 timeElapsedConsolidated = block.timestamp.sub(staker.lastRewardUpdateTime);
2117         uint256 timeFactorConsolidated;
2118         if(timeElapsedConsolidated >= timeElapsedFactor) {
2119             timeFactorConsolidated = 1 ether;
2120         } else {
2121             timeFactorConsolidated = timeElapsedConsolidated.mul(1 ether).div(timeElapsedFactor);
2122         }
2123         uint256 stakerShareFromConsolidated = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
2124         uint256 rewardFromConsolidated = consolidatedFunds.mul(stakerShareFromConsolidated).div(1 ether);
2125         rewardFromConsolidated = rewardFromConsolidated.mul(timeFactorConsolidated).div(1 ether);
2126         if (!ownsActiveNFT(stakerAddress)) {
2127             rewardFromConsolidated = rewardFromConsolidated.mul(malusNoSubscription).div(100);
2128         }
2129 
2130         totalReward = totalReward.add(rewardFromConsolidated);
2131         staker.rewardsEarned = staker.rewardsEarned.add(totalReward);
2132         staker.lastRewardUpdateTime = block.timestamp;
2133     }
2134 
2135     function consolidateFunds() private {
2136         Funds[] memory newFundDeposits = new Funds[](fundDeposits.length);
2137 
2138         uint256 count = 0;
2139         for (uint256 i = 0; i < fundDeposits.length; i++) {
2140             uint256 timeElapsed = block.timestamp.sub(fundDeposits[i].depositTime);
2141             if (timeElapsed >= timeElapsedFactor) {
2142                 consolidatedFunds = consolidatedFunds.add(fundDeposits[i].amount);
2143             } else {
2144                 newFundDeposits[count] = fundDeposits[i];
2145                 count++;
2146             }
2147         }
2148 
2149         if (count > 0) {
2150             if (fundDeposits.length != count) {
2151                 while (fundDeposits.length > count) {
2152                     fundDeposits.pop();
2153                 }
2154                 
2155                 for (uint256 i = 0; i < count; i++) {
2156                     fundDeposits[i] = newFundDeposits[i];
2157                 }
2158             }
2159         } else {
2160             delete fundDeposits;
2161         }
2162     }
2163 
2164     function getTotalAvailableRewards() public view returns (uint256) {
2165         uint256 totalAvailable = consolidatedFunds;
2166 
2167         for (uint256 i = 0; i < fundDeposits.length; i++) {
2168             totalAvailable = totalAvailable.add(fundDeposits[i].amount);
2169         }
2170 
2171         return totalAvailable;
2172     }
2173 
2174     receive() external payable {}
2175 
2176     function depositETH() external payable onlyRewardsProvider {
2177         fundDeposits.push(Funds({
2178             amount: msg.value,
2179             depositTime: block.timestamp
2180         }));
2181 
2182         if (activateConsolidate){
2183             consolidateFunds();
2184         }
2185     }
2186 
2187     function withdrawFunds() external onlyRewardsProvider {
2188         uint256 balance = address(this).balance;
2189         require(balance > 0, "No funds to withdraw");
2190         payable(msg.sender).transfer(balance);
2191 
2192         delete fundDeposits;
2193         consolidatedFunds = 0;
2194     }
2195 
2196     function getStakersArray() public view returns (address[] memory) {
2197         return stakerAddresses;
2198     }
2199 
2200     function getFundDepositsArray() public view returns (Funds[] memory) {
2201         return fundDeposits;
2202     }
2203 
2204     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2205         return a > b ? a : b;
2206     }
2207 
2208     function calibrateFundArray(uint256 amount) private {
2209         uint256 rewardLeftToClaim = amount;
2210         for (uint256 i = 0; i < fundDeposits.length && rewardLeftToClaim > 0; i++) {
2211             if (fundDeposits[i].amount == 0) {
2212                 continue;
2213             }
2214             if (fundDeposits[i].amount <= rewardLeftToClaim) {
2215                 rewardLeftToClaim = rewardLeftToClaim.sub(fundDeposits[i].amount);
2216                 delete fundDeposits[i];
2217             } else {
2218                 fundDeposits[i].amount = fundDeposits[i].amount.sub(rewardLeftToClaim);
2219                 rewardLeftToClaim = 0;
2220             }
2221         }
2222         if (rewardLeftToClaim > 0 && consolidatedFunds > 0) {
2223             if (consolidatedFunds <= rewardLeftToClaim) {
2224                 rewardLeftToClaim = rewardLeftToClaim.sub(consolidatedFunds);
2225                 consolidatedFunds = 0;
2226             } else {
2227                 consolidatedFunds = consolidatedFunds.sub(rewardLeftToClaim);
2228                 rewardLeftToClaim = 0;
2229             }
2230         }
2231     }
2232 
2233     function ownsActiveNFT(address _user) public view returns (bool) {
2234         for (uint256 i = 0; i < lockSubNFT.length; i++) {
2235             if (lockSubNFT[i].instance.getHasValidKey(_user)) {
2236                 return true;
2237             }
2238         }
2239         return false;
2240     }
2241 
2242     function ownsActiveNFTList(address _user) public view returns (address[] memory) {
2243         uint256 activeCount = 0;
2244         for (uint256 i = 0; i < lockSubNFT.length; i++) {
2245             if (lockSubNFT[i].instance.getHasValidKey(_user)) {
2246                 activeCount++;
2247             }
2248         }
2249         address[] memory activeLockersAddress = new address[](activeCount);
2250 
2251         uint256 j = 0;
2252         for (uint256 i = 0; i < lockSubNFT.length; i++) {
2253             if (lockSubNFT[i].instance.getHasValidKey(_user)) {
2254                 activeLockersAddress[j] = address(lockSubNFT[i].nft);
2255                 j++;
2256             }
2257         }
2258 
2259         return activeLockersAddress;
2260     }
2261 
2262     function cleanFundDeposits() external onlyRewardsProvider {
2263         delete fundDeposits;
2264     }
2265 
2266     function cleanLockers() external onlyRewardsProvider {
2267         delete lockSubNFT;
2268     }
2269 
2270     function setSubscriptionLockers(address[] calldata _lockers) external onlyRewardsProvider {
2271         for (uint i = 0; i < _lockers.length; i++) {
2272             address currentLocker = _lockers[i];
2273             Lockers memory lock;
2274             lock.instance = IPublicLockV13(currentLocker);
2275             lock.nft = IERC721(currentLocker);
2276             lockSubNFT.push(lock);
2277         }
2278     }
2279 
2280     function enableContract(bool _c, bool _s) external onlyRewardsProvider {
2281         enableClaim = _c;
2282         enableStake = _s;
2283     }
2284 
2285     function setTotalStakedAmount(uint256 _amount) external onlyRewardsProvider {
2286         totalStakedAmount = _amount;
2287     }
2288 
2289     function setRewardsProvider(address _provider) external onlyRewardsProvider {
2290         rewardsProvider = _provider;
2291     }
2292 
2293     function setOwner(address _owner) external onlyRewardsProvider {
2294         owner = _owner;
2295     }
2296 
2297     function setMaxStakeAmount(uint256 _amount) external onlyRewardsProvider {
2298         maxStakeAmount = _amount;
2299     }
2300 
2301     function setMinClaimAmount(uint256 _amount) external onlyRewardsProvider {
2302         minClaimAmount = _amount;
2303     }
2304 
2305     function setStakeWaitTime(uint256 _time) external onlyRewardsProvider {
2306         stakeWaitTime = _time;
2307     }
2308 
2309     function setClaimInterval(uint256 _interval) external onlyRewardsProvider {
2310         claimInterval = _interval;
2311     }
2312 
2313     function setTimeElapsedFactor(uint256 _time) external onlyRewardsProvider {
2314         timeElapsedFactor = _time;
2315     }
2316 
2317     function setMalusNoSubscription(uint256 _malus) external onlyRewardsProvider {
2318         malusNoSubscription = _malus;
2319     }
2320 
2321     function setRewardResetInterval(uint256 _reset) external onlyRewardsProvider {
2322         rewardResetInterval = _reset;
2323     }
2324 
2325     function setTotalDistributed(uint256 _t) external onlyRewardsProvider {
2326         totalDistributed = _t;
2327     }
2328 
2329     function setActivateSendTeam(bool _a) external onlyRewardsProvider {
2330         activateSendTeam = _a;
2331     }
2332 
2333     function setActivateConsolidate(bool _c) external onlyRewardsProvider {
2334         activateConsolidate = _c;
2335     }
2336 
2337     function setActivateRestore(bool _r) external onlyRewardsProvider {
2338         activateRestore = _r;
2339     }
2340 
2341     function setConsolidatedFunds(uint256 _c) external onlyRewardsProvider {
2342         consolidatedFunds = _c;
2343     }
2344 
2345     function setStaker(address s, uint256 amount, uint256 ls, uint256 lc, uint256 re, uint256 rc, uint256 lr, bool r) external onlyRewardsProvider {
2346         stakers[s].amountStaked = amount;
2347         stakers[s].lastStakeTime = ls;
2348         stakers[s].lastClaimTime = lc;
2349         stakers[s].rewardsEarned = re;
2350         stakers[s].rewardsClaimed = rc;
2351         stakers[s].lastRewardUpdateTime = lr;
2352         stakers[s].restoring = r;
2353     }
2354 
2355     function restoreFundDeposit(uint256 amount, uint256 ts) external onlyRewardsProvider {
2356         fundDeposits.push(Funds({
2357             amount: amount,
2358             depositTime: ts
2359         }));
2360     }
2361 }