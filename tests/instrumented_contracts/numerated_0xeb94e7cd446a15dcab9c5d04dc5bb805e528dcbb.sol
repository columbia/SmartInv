1 // RavenFund - Staking
2 //
3 // The raven symbolizes prophecy, insight, transformation, and intelligence. It also represents long-term success.
4 // The 1st AI-powered hedge fund
5 //
6 // https://www.ravenfund.app/
7 // https://twitter.com/RavenFund
8 // https://t.me/RavenFundPortal
9 
10 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
11 
12 
13 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Standard signed math utilities missing in the Solidity language.
19  */
20 library SignedMath {
21     /**
22      * @dev Returns the largest of two signed numbers.
23      */
24     function max(int256 a, int256 b) internal pure returns (int256) {
25         return a > b ? a : b;
26     }
27 
28     /**
29      * @dev Returns the smallest of two signed numbers.
30      */
31     function min(int256 a, int256 b) internal pure returns (int256) {
32         return a < b ? a : b;
33     }
34 
35     /**
36      * @dev Returns the average of two signed numbers without overflow.
37      * The result is rounded towards zero.
38      */
39     function average(int256 a, int256 b) internal pure returns (int256) {
40         // Formula from the book "Hacker's Delight"
41         int256 x = (a & b) + ((a ^ b) >> 1);
42         return x + (int256(uint256(x) >> 255) & (a ^ b));
43     }
44 
45     /**
46      * @dev Returns the absolute unsigned value of a signed value.
47      */
48     function abs(int256 n) internal pure returns (uint256) {
49         unchecked {
50             // must be unchecked in order to support `n = type(int256).min`
51             return uint256(n >= 0 ? n : -n);
52         }
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/math/Math.sol
57 
58 
59 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
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
112     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
113         unchecked {
114             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
115             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
116             // variables such that product = prod1 * 2^256 + prod0.
117             uint256 prod0; // Least significant 256 bits of the product
118             uint256 prod1; // Most significant 256 bits of the product
119             assembly {
120                 let mm := mulmod(x, y, not(0))
121                 prod0 := mul(x, y)
122                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
123             }
124 
125             // Handle non-overflow cases, 256 by 256 division.
126             if (prod1 == 0) {
127                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
128                 // The surrounding unchecked block does not change this fact.
129                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
130                 return prod0 / denominator;
131             }
132 
133             // Make sure the result is less than 2^256. Also prevents denominator == 0.
134             require(denominator > prod1, "Math: mulDiv overflow");
135 
136             ///////////////////////////////////////////////
137             // 512 by 256 division.
138             ///////////////////////////////////////////////
139 
140             // Make division exact by subtracting the remainder from [prod1 prod0].
141             uint256 remainder;
142             assembly {
143                 // Compute remainder using mulmod.
144                 remainder := mulmod(x, y, denominator)
145 
146                 // Subtract 256 bit number from 512 bit number.
147                 prod1 := sub(prod1, gt(remainder, prod0))
148                 prod0 := sub(prod0, remainder)
149             }
150 
151             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
152             // See https://cs.stackexchange.com/q/138556/92363.
153 
154             // Does not overflow because the denominator cannot be zero at this stage in the function.
155             uint256 twos = denominator & (~denominator + 1);
156             assembly {
157                 // Divide denominator by twos.
158                 denominator := div(denominator, twos)
159 
160                 // Divide [prod1 prod0] by twos.
161                 prod0 := div(prod0, twos)
162 
163                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
164                 twos := add(div(sub(0, twos), twos), 1)
165             }
166 
167             // Shift in bits from prod1 into prod0.
168             prod0 |= prod1 * twos;
169 
170             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
171             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
172             // four bits. That is, denominator * inv = 1 mod 2^4.
173             uint256 inverse = (3 * denominator) ^ 2;
174 
175             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
176             // in modular arithmetic, doubling the correct bits in each step.
177             inverse *= 2 - denominator * inverse; // inverse mod 2^8
178             inverse *= 2 - denominator * inverse; // inverse mod 2^16
179             inverse *= 2 - denominator * inverse; // inverse mod 2^32
180             inverse *= 2 - denominator * inverse; // inverse mod 2^64
181             inverse *= 2 - denominator * inverse; // inverse mod 2^128
182             inverse *= 2 - denominator * inverse; // inverse mod 2^256
183 
184             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
185             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
186             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
187             // is no longer required.
188             result = prod0 * inverse;
189             return result;
190         }
191     }
192 
193     /**
194      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
195      */
196     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
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
312             if (value >= 10 ** 64) {
313                 value /= 10 ** 64;
314                 result += 64;
315             }
316             if (value >= 10 ** 32) {
317                 value /= 10 ** 32;
318                 result += 32;
319             }
320             if (value >= 10 ** 16) {
321                 value /= 10 ** 16;
322                 result += 16;
323             }
324             if (value >= 10 ** 8) {
325                 value /= 10 ** 8;
326                 result += 8;
327             }
328             if (value >= 10 ** 4) {
329                 value /= 10 ** 4;
330                 result += 4;
331             }
332             if (value >= 10 ** 2) {
333                 value /= 10 ** 2;
334                 result += 2;
335             }
336             if (value >= 10 ** 1) {
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
350             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
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
387      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
388      * Returns 0 if given 0.
389      */
390     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
391         unchecked {
392             uint256 result = log256(value);
393             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/utils/Strings.sol
399 
400 
401 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 
407 /**
408  * @dev String operations.
409  */
410 library Strings {
411     bytes16 private constant _SYMBOLS = "0123456789abcdef";
412     uint8 private constant _ADDRESS_LENGTH = 20;
413 
414     /**
415      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
416      */
417     function toString(uint256 value) internal pure returns (string memory) {
418         unchecked {
419             uint256 length = Math.log10(value) + 1;
420             string memory buffer = new string(length);
421             uint256 ptr;
422             /// @solidity memory-safe-assembly
423             assembly {
424                 ptr := add(buffer, add(32, length))
425             }
426             while (true) {
427                 ptr--;
428                 /// @solidity memory-safe-assembly
429                 assembly {
430                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
431                 }
432                 value /= 10;
433                 if (value == 0) break;
434             }
435             return buffer;
436         }
437     }
438 
439     /**
440      * @dev Converts a `int256` to its ASCII `string` decimal representation.
441      */
442     function toString(int256 value) internal pure returns (string memory) {
443         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
448      */
449     function toHexString(uint256 value) internal pure returns (string memory) {
450         unchecked {
451             return toHexString(value, Math.log256(value) + 1);
452         }
453     }
454 
455     /**
456      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
457      */
458     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
459         bytes memory buffer = new bytes(2 * length + 2);
460         buffer[0] = "0";
461         buffer[1] = "x";
462         for (uint256 i = 2 * length + 1; i > 1; --i) {
463             buffer[i] = _SYMBOLS[value & 0xf];
464             value >>= 4;
465         }
466         require(value == 0, "Strings: hex length insufficient");
467         return string(buffer);
468     }
469 
470     /**
471      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
472      */
473     function toHexString(address addr) internal pure returns (string memory) {
474         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
475     }
476 
477     /**
478      * @dev Returns true if the two strings are equal.
479      */
480     function equal(string memory a, string memory b) internal pure returns (bool) {
481         return keccak256(bytes(a)) == keccak256(bytes(b));
482     }
483 }
484 
485 // File: @unlock-protocol/contracts/dist/PublicLock/IPublicLockV13.sol
486 
487 
488 pragma solidity >=0.5.17 <0.9.0;
489 pragma experimental ABIEncoderV2;
490 
491 /**
492  * @title The PublicLock Interface
493  */
494 
495 interface IPublicLockV13 {
496   /// Functions
497   function initialize(
498     address _lockCreator,
499     uint _expirationDuration,
500     address _tokenAddress,
501     uint _keyPrice,
502     uint _maxNumberOfKeys,
503     string calldata _lockName
504   ) external;
505 
506   // default role from OpenZeppelin
507   function DEFAULT_ADMIN_ROLE()
508     external
509     view
510     returns (bytes32 role);
511 
512   /**
513    * @notice The version number of the current implementation on this network.
514    * @return The current version number.
515    */
516   function publicLockVersion()
517     external
518     pure
519     returns (uint16);
520 
521   /**
522    * @dev Called by lock manager to withdraw all funds from the lock
523    * @param _tokenAddress specifies the token address to withdraw or 0 for ETH. This is usually
524    * the same as `tokenAddress` in MixinFunds.
525    * @param _recipient specifies the address that will receive the tokens
526    * @param _amount specifies the max amount to withdraw, which may be reduced when
527    * considering the available balance. Set to 0 or MAX_UINT to withdraw everything.
528    * -- however be wary of draining funds as it breaks the `cancelAndRefund` and `expireAndRefundFor` use cases.
529    */
530   function withdraw(
531     address _tokenAddress,
532     address payable _recipient,
533     uint _amount
534   ) external;
535 
536   /**
537    * A function which lets a Lock manager of the lock to change the price for future purchases.
538    * @dev Throws if called by other than a Lock manager
539    * @dev Throws if lock has been disabled
540    * @dev Throws if _tokenAddress is not a valid token
541    * @param _keyPrice The new price to set for keys
542    * @param _tokenAddress The address of the erc20 token to use for pricing the keys,
543    * or 0 to use ETH
544    */
545   function updateKeyPricing(
546     uint _keyPrice,
547     address _tokenAddress
548   ) external;
549 
550   /**
551    * Update the main key properties for the entire lock:
552    *
553    * - default duration of each key
554    * - the maximum number of keys the lock can edit
555    * - the maximum number of keys a single address can hold
556    *
557    * @notice keys previously bought are unaffected by this changes in expiration duration (i.e.
558    * existing keys timestamps are not recalculated/updated)
559    * @param _newExpirationDuration the new amount of time for each key purchased or type(uint).max for a non-expiring key
560    * @param _maxKeysPerAcccount the maximum amount of key a single user can own
561    * @param _maxNumberOfKeys uint the maximum number of keys
562    * @dev _maxNumberOfKeys Can't be smaller than the existing supply
563    */
564   function updateLockConfig(
565     uint _newExpirationDuration,
566     uint _maxNumberOfKeys,
567     uint _maxKeysPerAcccount
568   ) external;
569 
570   /**
571    * Checks if the user has a non-expired key.
572    * @param _user The address of the key owner
573    */
574   function getHasValidKey(
575     address _user
576   ) external view returns (bool);
577 
578   /**
579    * @dev Returns the key's ExpirationTimestamp field for a given owner.
580    * @param _tokenId the id of the key
581    * @dev Returns 0 if the owner has never owned a key for this lock
582    */
583   function keyExpirationTimestampFor(
584     uint _tokenId
585   ) external view returns (uint timestamp);
586 
587   /**
588    * Public function which returns the total number of unique owners (both expired
589    * and valid).  This may be larger than totalSupply.
590    */
591   function numberOfOwners() external view returns (uint);
592 
593   /**
594    * Allows the Lock owner to assign
595    * @param _lockName a descriptive name for this Lock.
596    * @param _lockSymbol a Symbol for this Lock (default to KEY).
597    * @param _baseTokenURI the baseTokenURI for this Lock
598    */
599   function setLockMetadata(
600     string calldata _lockName,
601     string calldata _lockSymbol,
602     string calldata _baseTokenURI
603   ) external;
604 
605   /**
606    * @dev Gets the token symbol
607    * @return string representing the token symbol
608    */
609   function symbol() external view returns (string memory);
610 
611   /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
612    * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
613    *  3986. The URI may point to a JSON file that conforms to the "ERC721
614    *  Metadata JSON Schema".
615    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
616    * @param _tokenId The tokenID we're inquiring about
617    * @return String representing the URI for the requested token
618    */
619   function tokenURI(
620     uint256 _tokenId
621   ) external view returns (string memory);
622 
623   /**
624    * Allows a Lock manager to add or remove an event hook
625    * @param _onKeyPurchaseHook Hook called when the `purchase` function is called
626    * @param _onKeyCancelHook Hook called when the internal `_cancelAndRefund` function is called
627    * @param _onValidKeyHook Hook called to determine if the contract should overide the status for a given address
628    * @param _onTokenURIHook Hook called to generate a data URI used for NFT metadata
629    * @param _onKeyTransferHook Hook called when a key is transfered
630    * @param _onKeyExtendHook Hook called when a key is extended or renewed
631    * @param _onKeyGrantHook Hook called when a key is granted
632    */
633   function setEventHooks(
634     address _onKeyPurchaseHook,
635     address _onKeyCancelHook,
636     address _onValidKeyHook,
637     address _onTokenURIHook,
638     address _onKeyTransferHook,
639     address _onKeyExtendHook,
640     address _onKeyGrantHook
641   ) external;
642 
643   /**
644    * Allows a Lock manager to give a collection of users a key with no charge.
645    * Each key may be assigned a different expiration date.
646    * @dev Throws if called by other than a Lock manager
647    * @param _recipients An array of receiving addresses
648    * @param _expirationTimestamps An array of expiration Timestamps for the keys being granted
649    * @return the ids of the granted tokens
650    */
651   function grantKeys(
652     address[] calldata _recipients,
653     uint[] calldata _expirationTimestamps,
654     address[] calldata _keyManagers
655   ) external returns (uint256[] memory);
656 
657   /**
658    * Allows the Lock owner to extend an existing keys with no charge.
659    * @param _tokenId The id of the token to extend
660    * @param _duration The duration in secondes to add ot the key
661    * @dev set `_duration` to 0 to use the default duration of the lock
662    */
663   function grantKeyExtension(
664     uint _tokenId,
665     uint _duration
666   ) external;
667 
668   /**
669    * @dev Purchase function
670    * @param _values array of tokens amount to pay for this purchase >= the current keyPrice - any applicable discount
671    * (_values is ignored when using ETH)
672    * @param _recipients array of addresses of the recipients of the purchased key
673    * @param _referrers array of addresses of the users making the referral
674    * @param _keyManagers optional array of addresses to grant managing rights to a specific address on creation
675    * @param _data array of arbitrary data populated by the front-end which initiated the sale
676    * @notice when called for an existing and non-expired key, the `_keyManager` param will be ignored
677    * @dev Setting _value to keyPrice exactly doubles as a security feature. That way if the lock owner increases the
678    * price while my transaction is pending I can't be charged more than I expected (only applicable to ERC-20 when more
679    * than keyPrice is approved for spending).
680    * @return tokenIds the ids of the created tokens
681    */
682   function purchase(
683     uint256[] calldata _values,
684     address[] calldata _recipients,
685     address[] calldata _referrers,
686     address[] calldata _keyManagers,
687     bytes[] calldata _data
688   ) external payable returns (uint256[] memory tokenIds);
689 
690   /**
691    * @dev Extend function
692    * @param _value the number of tokens to pay for this purchase >= the current keyPrice - any applicable discount
693    * (_value is ignored when using ETH)
694    * @param _tokenId the id of the key to extend
695    * @param _referrer address of the user making the referral
696    * @param _data arbitrary data populated by the front-end which initiated the sale
697    * @dev Throws if lock is disabled or key does not exist for _recipient. Throws if _recipient == address(0).
698    */
699   function extend(
700     uint _value,
701     uint _tokenId,
702     address _referrer,
703     bytes calldata _data
704   ) external payable;
705 
706   /**
707    * Returns the percentage of the keyPrice to be sent to the referrer (in basis points)
708    * @param _referrer the address of the referrer
709    * @return referrerFee the percentage of the keyPrice to be sent to the referrer (in basis points)
710    */
711   function referrerFees(
712     address _referrer
713   ) external view returns (uint referrerFee);
714 
715   /**
716    * Set a specific percentage of the keyPrice to be sent to the referrer while purchasing,
717    * extending or renewing a key.
718    * @param _referrer the address of the referrer
719    * @param _feeBasisPoint the percentage of the price to be used for this
720    * specific referrer (in basis points)
721    * @dev To send a fixed percentage of the key price to all referrers, sett a percentage to `address(0)`
722    */
723   function setReferrerFee(
724     address _referrer,
725     uint _feeBasisPoint
726   ) external;
727 
728   /**
729    * Merge existing keys
730    * @param _tokenIdFrom the id of the token to substract time from
731    * @param _tokenIdTo the id of the destination token  to add time
732    * @param _amount the amount of time to transfer (in seconds)
733    */
734   function mergeKeys(
735     uint _tokenIdFrom,
736     uint _tokenIdTo,
737     uint _amount
738   ) external;
739 
740   /**
741    * Deactivate an existing key
742    * @param _tokenId the id of token to burn
743    * @notice the key will be expired and ownership records will be destroyed
744    */
745   function burn(uint _tokenId) external;
746 
747   /**
748    * @param _gasRefundValue price in wei or token in smallest price unit
749    * @dev Set the value to be refunded to the sender on purchase
750    */
751   function setGasRefundValue(
752     uint256 _gasRefundValue
753   ) external;
754 
755   /**
756    * _gasRefundValue price in wei or token in smallest price unit
757    * @dev Returns the value/price to be refunded to the sender on purchase
758    */
759   function gasRefundValue()
760     external
761     view
762     returns (uint256 _gasRefundValue);
763 
764   /**
765    * @notice returns the minimum price paid for a purchase with these params.
766    * @dev this considers any discount from Unlock or the OnKeyPurchase hook.
767    */
768   function purchasePriceFor(
769     address _recipient,
770     address _referrer,
771     bytes calldata _data
772   ) external view returns (uint);
773 
774   /**
775    * Allow a Lock manager to change the transfer fee.
776    * @dev Throws if called by other than a Lock manager
777    * @param _transferFeeBasisPoints The new transfer fee in basis-points(bps).
778    * Ex: 200 bps = 2%
779    */
780   function updateTransferFee(
781     uint _transferFeeBasisPoints
782   ) external;
783 
784   /**
785    * Determines how much of a fee would need to be paid in order to
786    * transfer to another account.  This is pro-rated so the fee goes
787    * down overtime.
788    * @dev Throws if _tokenId does not have a valid key
789    * @param _tokenId The id of the key check the transfer fee for.
790    * @param _time The amount of time to calculate the fee for.
791    * @return The transfer fee in seconds.
792    */
793   function getTransferFee(
794     uint _tokenId,
795     uint _time
796   ) external view returns (uint);
797 
798   /**
799    * @dev Invoked by a Lock manager to expire the user's key
800    * and perform a refund and cancellation of the key
801    * @param _tokenId The key id we wish to refund to
802    * @param _amount The amount to refund to the key-owner
803    * @dev Throws if called by other than a Lock manager
804    * @dev Throws if _keyOwner does not have a valid key
805    */
806   function expireAndRefundFor(
807     uint _tokenId,
808     uint _amount
809   ) external;
810 
811   /**
812    * @dev allows the key manager to expire a given tokenId
813    * and send a refund to the keyOwner based on the amount of time remaining.
814    * @param _tokenId The id of the key to cancel.
815    * @notice cancel is enabled with a 10% penalty by default on all Locks.
816    */
817   function cancelAndRefund(uint _tokenId) external;
818 
819   /**
820    * Allow a Lock manager to change the refund penalty.
821    * @dev Throws if called by other than a Lock manager
822    * @param _freeTrialLength The new duration of free trials for this lock
823    * @param _refundPenaltyBasisPoints The new refund penaly in basis-points(bps)
824    */
825   function updateRefundPenalty(
826     uint _freeTrialLength,
827     uint _refundPenaltyBasisPoints
828   ) external;
829 
830   /**
831    * @dev Determines how much of a refund a key owner would receive if they issued
832    * @param _tokenId the id of the token to get the refund value for.
833    * @notice Due to the time required to mine a tx, the actual refund amount will be lower
834    * than what the user reads from this call.
835    * @return refund the amount of tokens refunded
836    */
837   function getCancelAndRefundValue(
838     uint _tokenId
839   ) external view returns (uint refund);
840 
841   function addLockManager(address account) external;
842 
843   function isLockManager(
844     address account
845   ) external view returns (bool);
846 
847   /**
848    * Returns the address of the `onKeyPurchaseHook` hook.
849    * @return hookAddress address of the hook
850    */
851   function onKeyPurchaseHook()
852     external
853     view
854     returns (address hookAddress);
855 
856   /**
857    * Returns the address of the `onKeyCancelHook` hook.
858    * @return hookAddress address of the hook
859    */
860   function onKeyCancelHook()
861     external
862     view
863     returns (address hookAddress);
864 
865   /**
866    * Returns the address of the `onValidKeyHook` hook.
867    * @return hookAddress address of the hook
868    */
869   function onValidKeyHook()
870     external
871     view
872     returns (address hookAddress);
873 
874   /**
875    * Returns the address of the `onTokenURIHook` hook.
876    * @return hookAddress address of the hook
877    */
878   function onTokenURIHook()
879     external
880     view
881     returns (address hookAddress);
882 
883   /**
884    * Returns the address of the `onKeyTransferHook` hook.
885    * @return hookAddress address of the hook
886    */
887   function onKeyTransferHook()
888     external
889     view
890     returns (address hookAddress);
891 
892   /**
893    * Returns the address of the `onKeyExtendHook` hook.
894    * @return hookAddress the address ok the hook
895    */
896   function onKeyExtendHook()
897     external
898     view
899     returns (address hookAddress);
900 
901   /**
902    * Returns the address of the `onKeyGrantHook` hook.
903    * @return hookAddress the address ok the hook
904    */
905   function onKeyGrantHook()
906     external
907     view
908     returns (address hookAddress);
909 
910   function renounceLockManager() external;
911 
912   /**
913    * @return the maximum number of key allowed for a single address
914    */
915   function maxKeysPerAddress() external view returns (uint);
916 
917   function expirationDuration()
918     external
919     view
920     returns (uint256);
921 
922   function freeTrialLength()
923     external
924     view
925     returns (uint256);
926 
927   function keyPrice() external view returns (uint256);
928 
929   function maxNumberOfKeys()
930     external
931     view
932     returns (uint256);
933 
934   function refundPenaltyBasisPoints()
935     external
936     view
937     returns (uint256);
938 
939   function tokenAddress() external view returns (address);
940 
941   function transferFeeBasisPoints()
942     external
943     view
944     returns (uint256);
945 
946   function unlockProtocol() external view returns (address);
947 
948   function keyManagerOf(
949     uint
950   ) external view returns (address);
951 
952   ///===================================================================
953 
954   /**
955    * @notice Allows the key owner to safely share their key (parent key) by
956    * transferring a portion of the remaining time to a new key (child key).
957    * @dev Throws if key is not valid.
958    * @dev Throws if `_to` is the zero address
959    * @param _to The recipient of the shared key
960    * @param _tokenId the key to share
961    * @param _timeShared The amount of time shared
962    * checks if `_to` is a smart contract (code size > 0). If so, it calls
963    * `onERC721Received` on `_to` and throws if the return value is not
964    * `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
965    * @dev Emit Transfer event
966    */
967   function shareKey(
968     address _to,
969     uint _tokenId,
970     uint _timeShared
971   ) external;
972 
973   /**
974    * @notice Update transfer and cancel rights for a given key
975    * @param _tokenId The id of the key to assign rights for
976    * @param _keyManager The address to assign the rights to for the given key
977    */
978   function setKeyManagerOf(
979     uint _tokenId,
980     address _keyManager
981   ) external;
982 
983   /**
984    * Check if a certain key is valid
985    * @param _tokenId the id of the key to check validity
986    * @notice this makes use of the onValidKeyHook if it is set
987    */
988   function isValidKey(
989     uint _tokenId
990   ) external view returns (bool);
991 
992   /**
993    * Returns the number of keys owned by `_keyOwner` (expired or not)
994    * @param _keyOwner address for which we are retrieving the total number of keys
995    * @return numberOfKeys total number of keys owned by the address
996    */
997   function totalKeys(
998     address _keyOwner
999   ) external view returns (uint numberOfKeys);
1000 
1001   /// @notice A descriptive name for a collection of NFTs in this contract
1002   function name()
1003     external
1004     view
1005     returns (string memory _name);
1006 
1007   ///===================================================================
1008 
1009   /// From ERC165.sol
1010   function supportsInterface(
1011     bytes4 interfaceId
1012   ) external view returns (bool);
1013 
1014   ///===================================================================
1015 
1016   /// From ERC-721
1017   /**
1018    * In the specific case of a Lock, `balanceOf` returns only the tokens with a valid expiration timerange
1019    * @return balance The number of valid keys owned by `_keyOwner`
1020    */
1021   function balanceOf(
1022     address _owner
1023   ) external view returns (uint256 balance);
1024 
1025   /**
1026    * @dev Returns the owner of the NFT specified by `tokenId`.
1027    */
1028   function ownerOf(
1029     uint256 tokenId
1030   ) external view returns (address _owner);
1031 
1032   /**
1033    * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1034    * another (`to`).
1035    *
1036    * Requirements:
1037    * - `from`, `to` cannot be zero.
1038    * - `tokenId` must be owned by `from`.
1039    * - If the caller is not `from`, it must be have been allowed to move this
1040    * NFT by either {approve} or {setApprovalForAll}.
1041    */
1042   function safeTransferFrom(
1043     address from,
1044     address to,
1045     uint256 tokenId
1046   ) external;
1047 
1048   /**
1049    * an ERC721-like function to transfer a token from one account to another.
1050    * @param from the owner of token to transfer
1051    * @param to the address that will receive the token
1052    * @param tokenId the id of the token
1053    * @dev Requirements: if the caller is not `from`, it must be approved to move this token by
1054    * either {approve} or {setApprovalForAll}.
1055    * The key manager will be reset to address zero after the transfer
1056    */
1057   function transferFrom(
1058     address from,
1059     address to,
1060     uint256 tokenId
1061   ) external;
1062 
1063   /**
1064    * Lending a key allows you to transfer the token while retaining the
1065    * ownerships right by setting yourself as a key manager first.
1066    * @param from the owner of token to transfer
1067    * @param to the address that will receive the token
1068    * @param tokenId the id of the token
1069    * @notice This function can only be called by 1) the key owner when no key manager is set or 2) the key manager.
1070    * After calling the function, the `_recipent` will be the new owner, and the sender of the tx
1071    * will become the key manager.
1072    */
1073   function lendKey(
1074     address from,
1075     address to,
1076     uint tokenId
1077   ) external;
1078 
1079   /**
1080    * Unlend is called when you have lent a key and want to claim its full ownership back.
1081    * @param _recipient the address that will receive the token ownership
1082    * @param _tokenId the id of the token
1083    * @dev Only the key manager of the token can call this function
1084    */
1085   function unlendKey(
1086     address _recipient,
1087     uint _tokenId
1088   ) external;
1089 
1090   function approve(address to, uint256 tokenId) external;
1091 
1092   /**
1093    * @notice Get the approved address for a single NFT
1094    * @dev Throws if `_tokenId` is not a valid NFT.
1095    * @param _tokenId The NFT to find the approved address for
1096    * @return operator The approved address for this NFT, or the zero address if there is none
1097    */
1098   function getApproved(
1099     uint256 _tokenId
1100   ) external view returns (address operator);
1101 
1102   /**
1103    * @dev Sets or unsets the approval of a given operator
1104    * An operator is allowed to transfer all tokens of the sender on their behalf
1105    * @param _operator operator address to set the approval
1106    * @param _approved representing the status of the approval to be set
1107    * @notice disabled when transfers are disabled
1108    */
1109   function setApprovalForAll(
1110     address _operator,
1111     bool _approved
1112   ) external;
1113 
1114   /**
1115    * @dev Tells whether an operator is approved by a given keyManager
1116    * @param _owner owner address which you want to query the approval of
1117    * @param _operator operator address which you want to query the approval of
1118    * @return bool whether the given operator is approved by the given owner
1119    */
1120   function isApprovedForAll(
1121     address _owner,
1122     address _operator
1123   ) external view returns (bool);
1124 
1125   function safeTransferFrom(
1126     address from,
1127     address to,
1128     uint256 tokenId,
1129     bytes calldata data
1130   ) external;
1131 
1132   /**
1133    * Returns the total number of keys, including non-valid ones
1134    * @return _totalKeysCreated the total number of keys, valid or not
1135    */
1136   function totalSupply() external view returns (uint256 _totalKeysCreated);
1137 
1138   function tokenOfOwnerByIndex(
1139     address _owner,
1140     uint256 index
1141   ) external view returns (uint256 tokenId);
1142 
1143   function tokenByIndex(
1144     uint256 index
1145   ) external view returns (uint256);
1146 
1147   /**
1148    * Innherited from Open Zeppelin AccessControl.sol
1149    */
1150   function getRoleAdmin(
1151     bytes32 role
1152   ) external view returns (bytes32);
1153 
1154   function grantRole(
1155     bytes32 role,
1156     address account
1157   ) external;
1158 
1159   function revokeRole(
1160     bytes32 role,
1161     address account
1162   ) external;
1163 
1164   function renounceRole(
1165     bytes32 role,
1166     address account
1167   ) external;
1168 
1169   function hasRole(
1170     bytes32 role,
1171     address account
1172   ) external view returns (bool);
1173 
1174   /** `owner()` is provided as an helper to mimick the `Ownable` contract ABI.
1175    * The `Ownable` logic is used by many 3rd party services to determine
1176    * contract ownership - e.g. who is allowed to edit metadata on Opensea.
1177    *
1178    * @notice This logic is NOT used internally by the Unlock Protocol and is made
1179    * available only as a convenience helper.
1180    */
1181   function owner() external view returns (address owner);
1182 
1183   function setOwner(address account) external;
1184 
1185   function isOwner(
1186     address account
1187   ) external view returns (bool isOwner);
1188 
1189   /**
1190    * Migrate data from the previous single owner => key mapping to
1191    * the new data structure w multiple tokens.
1192    * @param _calldata an ABI-encoded representation of the params (v10: the number of records to migrate as `uint`)
1193    * @dev when all record schemas are sucessfully upgraded, this function will update the `schemaVersion`
1194    * variable to the latest/current lock version
1195    */
1196   function migrate(bytes calldata _calldata) external;
1197 
1198   /**
1199    * Returns the version number of the data schema currently used by the lock
1200    * @notice if this is different from `publicLockVersion`, then the ability to purchase, grant
1201    * or extend keys is disabled.
1202    * @dev will return 0 if no ;igration has ever been run
1203    */
1204   function schemaVersion() external view returns (uint);
1205 
1206   /**
1207    * Set the schema version to the latest
1208    * @notice only lock manager call call this
1209    */
1210   function updateSchemaVersion() external;
1211 
1212   /**
1213    * Renew a given token
1214    * @notice only works for non-free, expiring, ERC20 locks
1215    * @param _tokenId the ID fo the token to renew
1216    * @param _referrer the address of the person to be granted UDT
1217    */
1218   function renewMembershipFor(
1219     uint _tokenId,
1220     address _referrer
1221   ) external;
1222 
1223   /**
1224    * @dev helper to check if a key is currently renewable 
1225    * it will revert if the pricing or duration of the lock have been modified 
1226    * unfavorably since the key was bought(price increase or duration decrease).
1227    * It will also revert if a lock is not renewable or if the key is not ready for renewal yet 
1228    * (at least 90% expired).
1229    * @param tokenId the id of the token to check
1230    * @param referrer the address where to send the referrer fee
1231    * @return true if the terms has changed
1232    */
1233   function isRenewable(uint256 tokenId, address referrer) external view returns (bool);
1234 }
1235 
1236 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1237 
1238 
1239 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 /**
1244  * @dev Contract module that helps prevent reentrant calls to a function.
1245  *
1246  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1247  * available, which can be applied to functions to make sure there are no nested
1248  * (reentrant) calls to them.
1249  *
1250  * Note that because there is a single `nonReentrant` guard, functions marked as
1251  * `nonReentrant` may not call one another. This can be worked around by making
1252  * those functions `private`, and then adding `external` `nonReentrant` entry
1253  * points to them.
1254  *
1255  * TIP: If you would like to learn more about reentrancy and alternative ways
1256  * to protect against it, check out our blog post
1257  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1258  */
1259 abstract contract ReentrancyGuard {
1260     // Booleans are more expensive than uint256 or any type that takes up a full
1261     // word because each write operation emits an extra SLOAD to first read the
1262     // slot's contents, replace the bits taken up by the boolean, and then write
1263     // back. This is the compiler's defense against contract upgrades and
1264     // pointer aliasing, and it cannot be disabled.
1265 
1266     // The values being non-zero value makes deployment a bit more expensive,
1267     // but in exchange the refund on every call to nonReentrant will be lower in
1268     // amount. Since refunds are capped to a percentage of the total
1269     // transaction's gas, it is best to keep them low in cases like this one, to
1270     // increase the likelihood of the full refund coming into effect.
1271     uint256 private constant _NOT_ENTERED = 1;
1272     uint256 private constant _ENTERED = 2;
1273 
1274     uint256 private _status;
1275 
1276     constructor() {
1277         _status = _NOT_ENTERED;
1278     }
1279 
1280     /**
1281      * @dev Prevents a contract from calling itself, directly or indirectly.
1282      * Calling a `nonReentrant` function from another `nonReentrant`
1283      * function is not supported. It is possible to prevent this from happening
1284      * by making the `nonReentrant` function external, and making it call a
1285      * `private` function that does the actual work.
1286      */
1287     modifier nonReentrant() {
1288         _nonReentrantBefore();
1289         _;
1290         _nonReentrantAfter();
1291     }
1292 
1293     function _nonReentrantBefore() private {
1294         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1295         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1296 
1297         // Any calls to nonReentrant after this point will fail
1298         _status = _ENTERED;
1299     }
1300 
1301     function _nonReentrantAfter() private {
1302         // By storing the original value once again, a refund is triggered (see
1303         // https://eips.ethereum.org/EIPS/eip-2200)
1304         _status = _NOT_ENTERED;
1305     }
1306 
1307     /**
1308      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1309      * `nonReentrant` function in the call stack.
1310      */
1311     function _reentrancyGuardEntered() internal view returns (bool) {
1312         return _status == _ENTERED;
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1317 
1318 
1319 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 // CAUTION
1324 // This version of SafeMath should only be used with Solidity 0.8 or later,
1325 // because it relies on the compiler's built in overflow checks.
1326 
1327 /**
1328  * @dev Wrappers over Solidity's arithmetic operations.
1329  *
1330  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1331  * now has built in overflow checking.
1332  */
1333 library SafeMath {
1334     /**
1335      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1336      *
1337      * _Available since v3.4._
1338      */
1339     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1340         unchecked {
1341             uint256 c = a + b;
1342             if (c < a) return (false, 0);
1343             return (true, c);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1349      *
1350      * _Available since v3.4._
1351      */
1352     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1353         unchecked {
1354             if (b > a) return (false, 0);
1355             return (true, a - b);
1356         }
1357     }
1358 
1359     /**
1360      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1361      *
1362      * _Available since v3.4._
1363      */
1364     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1365         unchecked {
1366             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1367             // benefit is lost if 'b' is also tested.
1368             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1369             if (a == 0) return (true, 0);
1370             uint256 c = a * b;
1371             if (c / a != b) return (false, 0);
1372             return (true, c);
1373         }
1374     }
1375 
1376     /**
1377      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1378      *
1379      * _Available since v3.4._
1380      */
1381     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1382         unchecked {
1383             if (b == 0) return (false, 0);
1384             return (true, a / b);
1385         }
1386     }
1387 
1388     /**
1389      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1390      *
1391      * _Available since v3.4._
1392      */
1393     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1394         unchecked {
1395             if (b == 0) return (false, 0);
1396             return (true, a % b);
1397         }
1398     }
1399 
1400     /**
1401      * @dev Returns the addition of two unsigned integers, reverting on
1402      * overflow.
1403      *
1404      * Counterpart to Solidity's `+` operator.
1405      *
1406      * Requirements:
1407      *
1408      * - Addition cannot overflow.
1409      */
1410     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1411         return a + b;
1412     }
1413 
1414     /**
1415      * @dev Returns the subtraction of two unsigned integers, reverting on
1416      * overflow (when the result is negative).
1417      *
1418      * Counterpart to Solidity's `-` operator.
1419      *
1420      * Requirements:
1421      *
1422      * - Subtraction cannot overflow.
1423      */
1424     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1425         return a - b;
1426     }
1427 
1428     /**
1429      * @dev Returns the multiplication of two unsigned integers, reverting on
1430      * overflow.
1431      *
1432      * Counterpart to Solidity's `*` operator.
1433      *
1434      * Requirements:
1435      *
1436      * - Multiplication cannot overflow.
1437      */
1438     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1439         return a * b;
1440     }
1441 
1442     /**
1443      * @dev Returns the integer division of two unsigned integers, reverting on
1444      * division by zero. The result is rounded towards zero.
1445      *
1446      * Counterpart to Solidity's `/` operator.
1447      *
1448      * Requirements:
1449      *
1450      * - The divisor cannot be zero.
1451      */
1452     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1453         return a / b;
1454     }
1455 
1456     /**
1457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1458      * reverting when dividing by zero.
1459      *
1460      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1461      * opcode (which leaves remaining gas untouched) while Solidity uses an
1462      * invalid opcode to revert (consuming all remaining gas).
1463      *
1464      * Requirements:
1465      *
1466      * - The divisor cannot be zero.
1467      */
1468     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1469         return a % b;
1470     }
1471 
1472     /**
1473      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1474      * overflow (when the result is negative).
1475      *
1476      * CAUTION: This function is deprecated because it requires allocating memory for the error
1477      * message unnecessarily. For custom revert reasons use {trySub}.
1478      *
1479      * Counterpart to Solidity's `-` operator.
1480      *
1481      * Requirements:
1482      *
1483      * - Subtraction cannot overflow.
1484      */
1485     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1486         unchecked {
1487             require(b <= a, errorMessage);
1488             return a - b;
1489         }
1490     }
1491 
1492     /**
1493      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1494      * division by zero. The result is rounded towards zero.
1495      *
1496      * Counterpart to Solidity's `/` operator. Note: this function uses a
1497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1498      * uses an invalid opcode to revert (consuming all remaining gas).
1499      *
1500      * Requirements:
1501      *
1502      * - The divisor cannot be zero.
1503      */
1504     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1505         unchecked {
1506             require(b > 0, errorMessage);
1507             return a / b;
1508         }
1509     }
1510 
1511     /**
1512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1513      * reverting with custom message when dividing by zero.
1514      *
1515      * CAUTION: This function is deprecated because it requires allocating memory for the error
1516      * message unnecessarily. For custom revert reasons use {tryMod}.
1517      *
1518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1519      * opcode (which leaves remaining gas untouched) while Solidity uses an
1520      * invalid opcode to revert (consuming all remaining gas).
1521      *
1522      * Requirements:
1523      *
1524      * - The divisor cannot be zero.
1525      */
1526     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1527         unchecked {
1528             require(b > 0, errorMessage);
1529             return a % b;
1530         }
1531     }
1532 }
1533 
1534 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1535 
1536 
1537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1538 
1539 pragma solidity ^0.8.0;
1540 
1541 /**
1542  * @dev Interface of the ERC165 standard, as defined in the
1543  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1544  *
1545  * Implementers can declare support of contract interfaces, which can then be
1546  * queried by others ({ERC165Checker}).
1547  *
1548  * For an implementation, see {ERC165}.
1549  */
1550 interface IERC165 {
1551     /**
1552      * @dev Returns true if this contract implements the interface defined by
1553      * `interfaceId`. See the corresponding
1554      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1555      * to learn more about how these ids are created.
1556      *
1557      * This function call must use less than 30 000 gas.
1558      */
1559     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1560 }
1561 
1562 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1563 
1564 
1565 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 
1570 /**
1571  * @dev Required interface of an ERC721 compliant contract.
1572  */
1573 interface IERC721 is IERC165 {
1574     /**
1575      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1576      */
1577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1578 
1579     /**
1580      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1581      */
1582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1583 
1584     /**
1585      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1586      */
1587     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1588 
1589     /**
1590      * @dev Returns the number of tokens in ``owner``'s account.
1591      */
1592     function balanceOf(address owner) external view returns (uint256 balance);
1593 
1594     /**
1595      * @dev Returns the owner of the `tokenId` token.
1596      *
1597      * Requirements:
1598      *
1599      * - `tokenId` must exist.
1600      */
1601     function ownerOf(uint256 tokenId) external view returns (address owner);
1602 
1603     /**
1604      * @dev Safely transfers `tokenId` token from `from` to `to`.
1605      *
1606      * Requirements:
1607      *
1608      * - `from` cannot be the zero address.
1609      * - `to` cannot be the zero address.
1610      * - `tokenId` token must exist and be owned by `from`.
1611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1617 
1618     /**
1619      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1620      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1621      *
1622      * Requirements:
1623      *
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must exist and be owned by `from`.
1627      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1633 
1634     /**
1635      * @dev Transfers `tokenId` token from `from` to `to`.
1636      *
1637      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1638      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1639      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1640      *
1641      * Requirements:
1642      *
1643      * - `from` cannot be the zero address.
1644      * - `to` cannot be the zero address.
1645      * - `tokenId` token must be owned by `from`.
1646      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function transferFrom(address from, address to, uint256 tokenId) external;
1651 
1652     /**
1653      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1654      * The approval is cleared when the token is transferred.
1655      *
1656      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1657      *
1658      * Requirements:
1659      *
1660      * - The caller must own the token or be an approved operator.
1661      * - `tokenId` must exist.
1662      *
1663      * Emits an {Approval} event.
1664      */
1665     function approve(address to, uint256 tokenId) external;
1666 
1667     /**
1668      * @dev Approve or remove `operator` as an operator for the caller.
1669      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1670      *
1671      * Requirements:
1672      *
1673      * - The `operator` cannot be the caller.
1674      *
1675      * Emits an {ApprovalForAll} event.
1676      */
1677     function setApprovalForAll(address operator, bool approved) external;
1678 
1679     /**
1680      * @dev Returns the account approved for `tokenId` token.
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must exist.
1685      */
1686     function getApproved(uint256 tokenId) external view returns (address operator);
1687 
1688     /**
1689      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1690      *
1691      * See {setApprovalForAll}
1692      */
1693     function isApprovedForAll(address owner, address operator) external view returns (bool);
1694 }
1695 
1696 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1697 
1698 
1699 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1700 
1701 pragma solidity ^0.8.0;
1702 
1703 /**
1704  * @dev Interface of the ERC20 standard as defined in the EIP.
1705  */
1706 interface IERC20 {
1707     /**
1708      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1709      * another (`to`).
1710      *
1711      * Note that `value` may be zero.
1712      */
1713     event Transfer(address indexed from, address indexed to, uint256 value);
1714 
1715     /**
1716      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1717      * a call to {approve}. `value` is the new allowance.
1718      */
1719     event Approval(address indexed owner, address indexed spender, uint256 value);
1720 
1721     /**
1722      * @dev Returns the amount of tokens in existence.
1723      */
1724     function totalSupply() external view returns (uint256);
1725 
1726     /**
1727      * @dev Returns the amount of tokens owned by `account`.
1728      */
1729     function balanceOf(address account) external view returns (uint256);
1730 
1731     /**
1732      * @dev Moves `amount` tokens from the caller's account to `to`.
1733      *
1734      * Returns a boolean value indicating whether the operation succeeded.
1735      *
1736      * Emits a {Transfer} event.
1737      */
1738     function transfer(address to, uint256 amount) external returns (bool);
1739 
1740     /**
1741      * @dev Returns the remaining number of tokens that `spender` will be
1742      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1743      * zero by default.
1744      *
1745      * This value changes when {approve} or {transferFrom} are called.
1746      */
1747     function allowance(address owner, address spender) external view returns (uint256);
1748 
1749     /**
1750      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1751      *
1752      * Returns a boolean value indicating whether the operation succeeded.
1753      *
1754      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1755      * that someone may use both the old and the new allowance by unfortunate
1756      * transaction ordering. One possible solution to mitigate this race
1757      * condition is to first reduce the spender's allowance to 0 and set the
1758      * desired value afterwards:
1759      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1760      *
1761      * Emits an {Approval} event.
1762      */
1763     function approve(address spender, uint256 amount) external returns (bool);
1764 
1765     /**
1766      * @dev Moves `amount` tokens from `from` to `to` using the
1767      * allowance mechanism. `amount` is then deducted from the caller's
1768      * allowance.
1769      *
1770      * Returns a boolean value indicating whether the operation succeeded.
1771      *
1772      * Emits a {Transfer} event.
1773      */
1774     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1775 }
1776 
1777 // File: contracts/RFStakePool.sol
1778 
1779 
1780 
1781 
1782 pragma solidity ^0.8.19;
1783 
1784 
1785 
1786 
1787 
1788 
1789 
1790 contract RavenFundStaking is ReentrancyGuard {
1791     using SafeMath for uint256;
1792 
1793     IERC20 public stakingToken;
1794     address public rewardsProvider;
1795     address public teamWallet;
1796     address public owner;
1797     Lockers[] public lockSubNFT;
1798 
1799     struct Lockers {
1800         IPublicLockV13 instance;
1801         IERC721 nft;
1802     }
1803 
1804     uint256 public maxStakeAmount = 0;
1805     uint256 public minClaimAmount = 15_000 ether;
1806     uint256 public stakeWaitTime = 12 hours;
1807     uint256 public claimInterval = 24 hours;
1808     uint256 public timeElapsedFactor = 7 days;
1809     uint256 public rewardResetInterval = 15 days;
1810     uint256 public malusNoSubscription = 70;
1811     uint256 public totalDistributed = 0;
1812 
1813     bool public enableClaim = false;
1814     bool public enableStake = false;
1815     bool public activateSendTeam = true;
1816 
1817     struct StakerInfo {
1818         uint256 amountStaked;
1819         uint256 lastStakeTime;
1820         uint256 lastClaimTime;
1821         uint256 rewardsEarned;
1822         uint256 rewardsClaimed;
1823         uint256 lastRewardUpdateTime;
1824         uint256 keyArray;
1825     }
1826 
1827     uint256 public totalStakedAmount;
1828 
1829     struct Funds {
1830         uint256 amount;
1831         uint256 depositTime;
1832     }
1833 
1834     Funds[] public fundDeposits;
1835     uint256 public consolidatedFunds = 0;
1836 
1837     mapping(address => StakerInfo) public stakers;
1838     address[] public stakerAddresses;
1839 
1840     constructor(address _stakingToken, address _rewardsProvider, address _teamWallet) {
1841         stakingToken = IERC20(_stakingToken);
1842         rewardsProvider = _rewardsProvider;
1843         teamWallet = _teamWallet;
1844         owner = msg.sender;
1845     }
1846 
1847     modifier onlyRewardsProvider() {
1848         require(msg.sender == rewardsProvider || msg.sender == owner || msg.sender == teamWallet, "Not the rewards provider");
1849         _;
1850     }
1851 
1852     function stake(uint256 amount) external nonReentrant {
1853         require(enableStake, "Stake not enabled.");
1854         StakerInfo storage staker = stakers[msg.sender];
1855         if (maxStakeAmount > 0) {
1856             require(staker.amountStaked + amount <= maxStakeAmount, "Max stake amount reached");
1857         }
1858 
1859         if (staker.lastRewardUpdateTime == 0) {
1860             staker.lastRewardUpdateTime = block.timestamp;
1861         }
1862 
1863         if (staker.keyArray == 0){
1864             stakerAddresses.push(msg.sender);
1865             staker.keyArray = stakerAddresses.length;
1866         }
1867 
1868         uint256 allowance = stakingToken.allowance(msg.sender, address(this));
1869         require(allowance >= amount, "Allowance is not sufficient to stake tokens");
1870 
1871         staker.lastStakeTime = block.timestamp;
1872         staker.amountStaked = staker.amountStaked.add(amount);
1873         totalStakedAmount = totalStakedAmount.add(amount);
1874 
1875         require(stakingToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
1876     }
1877 
1878     function withdraw(uint256 amount) external nonReentrant {
1879         StakerInfo storage staker = stakers[msg.sender];
1880 
1881         require(amount > 0, "Amount must be greater than 0");
1882         require(staker.amountStaked >= amount, "Insufficient staked amount");
1883 
1884         staker.amountStaked = staker.amountStaked.sub(amount);
1885         totalStakedAmount = totalStakedAmount.sub(amount);
1886 
1887         if (staker.amountStaked <= 0) {
1888             uint256 reward = staker.rewardsEarned;
1889             staker.rewardsEarned = 0;
1890             staker.lastClaimTime = block.timestamp;
1891             uint256 contractBalance = address(this).balance;
1892             if (reward > 0 && contractBalance >= reward && activateSendTeam){
1893                 calibrateFundArray(reward);
1894 
1895                 payable(teamWallet).transfer(reward);
1896             }
1897         }
1898 
1899         require(stakingToken.transfer(msg.sender, amount), "Token transfer failed");
1900     }
1901 
1902     function canClaim(address stakerAddress) public view returns (bool) {
1903         StakerInfo storage staker = stakers[stakerAddress];
1904         uint256 reward = previewStakerRewards(stakerAddress);
1905         uint256 contractBalance = address(this).balance;
1906         return enableClaim && reward > 0 && contractBalance >= reward && (staker.amountStaked >= minClaimAmount) && (block.timestamp > staker.lastStakeTime + stakeWaitTime) && (block.timestamp > staker.lastClaimTime + claimInterval);
1907     }
1908 
1909     function reasonClaim(address stakerAddress) public view returns (string memory) {
1910         StakerInfo storage staker = stakers[stakerAddress];
1911         uint256 reward = previewStakerRewards(stakerAddress);
1912         uint256 contractBalance = address(this).balance;
1913         if (!enableClaim){
1914             return "Claim not enabled, please wait a moment.";
1915         }
1916         if (staker.amountStaked < minClaimAmount) {
1917             return string(abi.encodePacked("To be eligible, you have to stake a minimum $RAVEN of ", Strings.toString(minClaimAmount.div(1 ether))));
1918         }
1919         if (block.timestamp <= staker.lastStakeTime + stakeWaitTime) {
1920             return Strings.toString(staker.lastStakeTime + stakeWaitTime);
1921         }
1922         if (block.timestamp <= staker.lastClaimTime + claimInterval) {
1923             return Strings.toString(staker.lastClaimTime + claimInterval);
1924         }
1925         if (reward <= 0){
1926             return "You don't have any reward to claim for the moment.";
1927         }
1928         if (contractBalance < reward) {
1929             return "Please wait new funds to claim your reward.";
1930         }
1931         return "You can claim !";
1932     }
1933 
1934     function claim() external nonReentrant {
1935         require(enableClaim, "Claim not enabled.");
1936         StakerInfo storage staker = stakers[msg.sender];
1937         require(staker.amountStaked >= minClaimAmount, "Not enough tokens staked to claim.");
1938         require(block.timestamp > staker.lastStakeTime + stakeWaitTime, "Need to wait after staking");
1939         require(block.timestamp > staker.lastClaimTime + claimInterval, "Already claimed recently");
1940 
1941         updateStakerRewards(msg.sender);
1942 
1943         uint256 reward = staker.rewardsEarned;
1944         require(reward > 0, "No rewards available");
1945 
1946         uint256 contractBalance = address(this).balance;
1947         require(contractBalance >= reward, "Not enough ETH in the contract");
1948 
1949         calibrateFundArray(reward);
1950         staker.rewardsEarned = 0;
1951         staker.lastClaimTime = block.timestamp;
1952         staker.rewardsClaimed = staker.rewardsClaimed.add(reward);
1953         totalDistributed = totalDistributed.add(reward);
1954 
1955         payable(msg.sender).transfer(reward);
1956     }
1957 
1958     function previewStakerRewards(address stakerAddress) public view returns (uint256) {
1959         StakerInfo storage staker = stakers[stakerAddress];
1960 
1961         if (staker.amountStaked < minClaimAmount || totalStakedAmount <= 0 || timeElapsedFactor <= 0) {
1962             return staker.rewardsEarned;
1963         }
1964 
1965         uint256 totalReward = 0;
1966         for(uint256 i = 0; i < fundDeposits.length; i++) {
1967             if (fundDeposits[i].amount == 0) {
1968                 continue;
1969             }
1970             uint256 referenceTime = max(staker.lastRewardUpdateTime, fundDeposits[i].depositTime);
1971             uint256 timeElapsed = block.timestamp.sub(referenceTime);
1972             
1973             uint256 timeFactor;
1974             if(timeElapsed >= timeElapsedFactor) {
1975                 timeFactor = 1 ether;
1976             } else {
1977                 timeFactor = timeElapsed.mul(1 ether).div(timeElapsedFactor);
1978             }
1979             
1980             uint256 stakerShare = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
1981             uint256 rewardFromThisDeposit = fundDeposits[i].amount.mul(stakerShare).div(1 ether);
1982             rewardFromThisDeposit = rewardFromThisDeposit.mul(timeFactor).div(1 ether);
1983 
1984             if (!ownsActiveNFT(stakerAddress)) {
1985                 rewardFromThisDeposit = rewardFromThisDeposit.mul(malusNoSubscription).div(100);
1986             }
1987 
1988             totalReward = totalReward.add(rewardFromThisDeposit);
1989         }
1990         // Then add rewards from consolidated funds
1991         uint256 stakerShareFromConsolidated = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
1992         uint256 rewardFromConsolidated = consolidatedFunds.mul(stakerShareFromConsolidated).div(1 ether);
1993         if (!ownsActiveNFT(stakerAddress)) {
1994             rewardFromConsolidated = rewardFromConsolidated.mul(malusNoSubscription).div(100);
1995         }
1996 
1997         totalReward = totalReward.add(rewardFromConsolidated);
1998 
1999         return staker.rewardsEarned.add(totalReward);
2000     }
2001 
2002     function updateStakerRewards(address stakerAddress) internal {
2003         StakerInfo storage staker = stakers[stakerAddress];
2004 
2005         if (staker.amountStaked < minClaimAmount || totalStakedAmount <= 0 || timeElapsedFactor <= 0) {
2006             staker.lastRewardUpdateTime = block.timestamp;
2007             return;
2008         }
2009 
2010         uint256 totalReward = 0;
2011         for(uint256 i = 0; i < fundDeposits.length; i++) {
2012             if (fundDeposits[i].amount == 0) {
2013                 continue;
2014             }
2015             uint256 referenceTime = max(staker.lastRewardUpdateTime, fundDeposits[i].depositTime);
2016             uint256 timeElapsed = block.timestamp.sub(referenceTime);
2017             
2018             uint256 timeFactor;
2019             if(timeElapsed >= timeElapsedFactor) {
2020                 timeFactor = 1 ether;
2021             } else {
2022                 timeFactor = timeElapsed.mul(1 ether).div(timeElapsedFactor);
2023             }
2024             
2025             uint256 stakerShare = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
2026             uint256 rewardFromThisDeposit = fundDeposits[i].amount.mul(stakerShare).div(1 ether);
2027             rewardFromThisDeposit = rewardFromThisDeposit.mul(timeFactor).div(1 ether);
2028 
2029             if (!ownsActiveNFT(stakerAddress)) {
2030                 rewardFromThisDeposit = rewardFromThisDeposit.mul(malusNoSubscription).div(100);
2031             }
2032 
2033             totalReward = totalReward.add(rewardFromThisDeposit);
2034         }
2035         // Then add rewards from consolidated funds
2036         uint256 stakerShareFromConsolidated = staker.amountStaked.mul(1 ether).div(totalStakedAmount);
2037         uint256 rewardFromConsolidated = consolidatedFunds.mul(stakerShareFromConsolidated).div(1 ether);
2038         if (!ownsActiveNFT(stakerAddress)) {
2039             rewardFromConsolidated = rewardFromConsolidated.mul(malusNoSubscription).div(100);
2040         }
2041         totalReward = totalReward.add(rewardFromConsolidated);
2042         staker.rewardsEarned = staker.rewardsEarned.add(totalReward);
2043         staker.lastRewardUpdateTime = block.timestamp;
2044     }
2045 
2046     function consolidateFunds() private {
2047         Funds[] memory newFundDeposits = new Funds[](fundDeposits.length);
2048 
2049         uint256 count = 0;
2050         for (uint256 i = 0; i < fundDeposits.length; i++) {
2051             uint256 timeElapsed = block.timestamp.sub(fundDeposits[i].depositTime);
2052             if (timeElapsed >= timeElapsedFactor) {
2053                 consolidatedFunds = consolidatedFunds.add(fundDeposits[i].amount);
2054             } else {
2055                 newFundDeposits[count] = fundDeposits[i];
2056                 count++;
2057             }
2058         }
2059 
2060         if (count > 0) {
2061             if (fundDeposits.length != count) {
2062                 while (fundDeposits.length > count) {
2063                     fundDeposits.pop();
2064                 }
2065                 
2066                 for (uint256 i = 0; i < count; i++) {
2067                     fundDeposits[i] = newFundDeposits[i];
2068                 }
2069             }
2070         } else {
2071             delete fundDeposits;
2072         }
2073     }
2074 
2075     function getTotalAvailableRewards() public view returns (uint256) {
2076         uint256 totalAvailable = consolidatedFunds;
2077 
2078         for (uint256 i = 0; i < fundDeposits.length; i++) {
2079             totalAvailable = totalAvailable.add(fundDeposits[i].amount);
2080         }
2081 
2082         return totalAvailable;
2083     }
2084 
2085     function depositETH() external payable onlyRewardsProvider {
2086         fundDeposits.push(Funds({
2087             amount: msg.value,
2088             depositTime: block.timestamp
2089         }));
2090 
2091         consolidateFunds();
2092     }
2093 
2094     function withdrawFunds() external onlyRewardsProvider {
2095         uint256 balance = address(this).balance;
2096         require(balance > 0, "No funds to withdraw");
2097         payable(msg.sender).transfer(balance);
2098 
2099         delete fundDeposits;
2100         consolidatedFunds = 0;
2101     }
2102 
2103     function unClaim(uint256 indexStart, uint256 indexStop) external onlyRewardsProvider {
2104         uint256 iStart = indexStart;
2105         uint256 iEnd = stakerAddresses.length;
2106         if (indexStop > 0 && indexStop > indexStart){
2107             iEnd = indexStop;
2108         }
2109         uint256 totalReward = 0;
2110         for (uint256 i = iStart; i < iEnd; i++) {
2111             StakerInfo storage staker = stakers[stakerAddresses[i]];
2112             if (block.timestamp - staker.lastClaimTime > rewardResetInterval && staker.rewardsEarned > 0) {
2113                 totalReward = totalReward.add(staker.rewardsEarned);
2114                 staker.rewardsEarned = 0;
2115                 staker.lastClaimTime = block.timestamp;
2116                 staker.lastRewardUpdateTime = block.timestamp;
2117             }
2118         }
2119         uint256 balance = address(this).balance;
2120         if (totalReward > 0 && balance >= totalReward && activateSendTeam){
2121             calibrateFundArray(totalReward);
2122             payable(teamWallet).transfer(totalReward);
2123         }
2124     }
2125 
2126     function getStakersArray() public view returns (address[] memory) {
2127         return stakerAddresses;
2128     }
2129 
2130     function getFundDepositsArray() public view returns (Funds[] memory) {
2131         return fundDeposits;
2132     }
2133 
2134     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2135         return a > b ? a : b;
2136     }
2137 
2138     function calibrateFundArray(uint256 amount) private {
2139         uint256 rewardLeftToClaim = amount;
2140         for (uint256 i = 0; i < fundDeposits.length && rewardLeftToClaim > 0; i++) {
2141             if (fundDeposits[i].amount == 0) {
2142                 continue;
2143             }
2144             if (fundDeposits[i].amount <= rewardLeftToClaim) {
2145                 rewardLeftToClaim = rewardLeftToClaim.sub(fundDeposits[i].amount);
2146                 delete fundDeposits[i];
2147             } else {
2148                 fundDeposits[i].amount = fundDeposits[i].amount.sub(rewardLeftToClaim);
2149                 rewardLeftToClaim = 0;
2150             }
2151         }
2152         if (rewardLeftToClaim > 0 && consolidatedFunds > 0) {
2153             if (consolidatedFunds <= rewardLeftToClaim) {
2154                 rewardLeftToClaim = rewardLeftToClaim.sub(consolidatedFunds);
2155                 consolidatedFunds = 0;
2156             } else {
2157                 consolidatedFunds = consolidatedFunds.sub(rewardLeftToClaim);
2158                 rewardLeftToClaim = 0;
2159             }
2160         }
2161     }
2162 
2163     function ownsActiveNFT(address _user) public view returns (bool) {
2164         for (uint256 i = 0; i < lockSubNFT.length; i++) {
2165             if (lockSubNFT[i].instance.getHasValidKey(_user)) {
2166                 return true;
2167             }
2168         }
2169         return false;
2170     }
2171 
2172     function ownsActiveNFTList(address _user) public view returns (address[] memory) {
2173         uint256 activeCount = 0;
2174         for (uint256 i = 0; i < lockSubNFT.length; i++) {
2175             if (lockSubNFT[i].instance.getHasValidKey(_user)) {
2176                 activeCount++;
2177             }
2178         }
2179         address[] memory activeLockersAddress = new address[](activeCount);
2180 
2181         uint256 j = 0;
2182         for (uint256 i = 0; i < lockSubNFT.length; i++) {
2183             if (lockSubNFT[i].instance.getHasValidKey(_user)) {
2184                 activeLockersAddress[j] = address(lockSubNFT[i].nft);
2185                 j++;
2186             }
2187         }
2188 
2189         return activeLockersAddress;
2190     }
2191 
2192     function cleanLockers() external onlyRewardsProvider {
2193         delete lockSubNFT;
2194     }
2195 
2196     function setSubscriptionLockers(address[] calldata _lockers) external onlyRewardsProvider {
2197         for (uint i = 0; i < _lockers.length; i++) {
2198             address currentLocker = _lockers[i];
2199             Lockers memory lock;
2200             lock.instance = IPublicLockV13(currentLocker);
2201             lock.nft = IERC721(currentLocker);
2202             lockSubNFT.push(lock);
2203         }
2204     }
2205 
2206     function enableContract(bool _c, bool _s) external onlyRewardsProvider {
2207         enableClaim = _c;
2208         enableStake = _s;
2209     }
2210 
2211     function setTotalStakedAmount(uint256 _amount) external onlyRewardsProvider {
2212         totalStakedAmount = _amount;
2213     }
2214 
2215     function setRewardsProvider(address _provider) external onlyRewardsProvider {
2216         rewardsProvider = _provider;
2217     }
2218 
2219     function setOwner(address _owner) external onlyRewardsProvider {
2220         owner = _owner;
2221     }
2222 
2223     function setMaxStakeAmount(uint256 _amount) external onlyRewardsProvider {
2224         maxStakeAmount = _amount;
2225     }
2226 
2227     function setMinClaimAmount(uint256 _amount) external onlyRewardsProvider {
2228         minClaimAmount = _amount;
2229     }
2230 
2231     function setStakeWaitTime(uint256 _time) external onlyRewardsProvider {
2232         stakeWaitTime = _time;
2233     }
2234 
2235     function setClaimInterval(uint256 _interval) external onlyRewardsProvider {
2236         claimInterval = _interval;
2237     }
2238 
2239     function setTimeElapsedFactor(uint256 _time) external onlyRewardsProvider {
2240         timeElapsedFactor = _time;
2241     }
2242 
2243     function setMalusNoSubscription(uint256 _malus) external onlyRewardsProvider {
2244         malusNoSubscription = _malus;
2245     }
2246 
2247     function setRewardResetInterval(uint256 _reset) external onlyRewardsProvider {
2248         rewardResetInterval = _reset;
2249     }
2250 
2251     function setTotalDistributed(uint256 _t) external onlyRewardsProvider {
2252         totalDistributed = _t;
2253     }
2254 
2255     function setActivateSendTeam(bool _a) external onlyRewardsProvider {
2256         activateSendTeam = _a;
2257     }
2258 }