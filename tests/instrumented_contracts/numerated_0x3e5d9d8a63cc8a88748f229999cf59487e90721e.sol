1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/math/SafeCast.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
10  * checks.
11  *
12  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
13  * easily result in undesired exploitation or bugs, since developers usually
14  * assume that overflows raise errors. `SafeCast` restores this intuition by
15  * reverting the transaction when such an operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  *
20  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
21  * all math on `uint256` and `int256` and then downcasting.
22  */
23 library SafeCast {
24     /**
25      * @dev Returns the downcasted uint224 from uint256, reverting on
26      * overflow (when the input is greater than largest uint224).
27      *
28      * Counterpart to Solidity's `uint224` operator.
29      *
30      * Requirements:
31      *
32      * - input must fit into 224 bits
33      */
34     function toUint224(uint256 value) internal pure returns (uint224) {
35         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
36         return uint224(value);
37     }
38 
39     /**
40      * @dev Returns the downcasted uint128 from uint256, reverting on
41      * overflow (when the input is greater than largest uint128).
42      *
43      * Counterpart to Solidity's `uint128` operator.
44      *
45      * Requirements:
46      *
47      * - input must fit into 128 bits
48      */
49     function toUint128(uint256 value) internal pure returns (uint128) {
50         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
51         return uint128(value);
52     }
53 
54     /**
55      * @dev Returns the downcasted uint96 from uint256, reverting on
56      * overflow (when the input is greater than largest uint96).
57      *
58      * Counterpart to Solidity's `uint96` operator.
59      *
60      * Requirements:
61      *
62      * - input must fit into 96 bits
63      */
64     function toUint96(uint256 value) internal pure returns (uint96) {
65         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
66         return uint96(value);
67     }
68 
69     /**
70      * @dev Returns the downcasted uint64 from uint256, reverting on
71      * overflow (when the input is greater than largest uint64).
72      *
73      * Counterpart to Solidity's `uint64` operator.
74      *
75      * Requirements:
76      *
77      * - input must fit into 64 bits
78      */
79     function toUint64(uint256 value) internal pure returns (uint64) {
80         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
81         return uint64(value);
82     }
83 
84     /**
85      * @dev Returns the downcasted uint32 from uint256, reverting on
86      * overflow (when the input is greater than largest uint32).
87      *
88      * Counterpart to Solidity's `uint32` operator.
89      *
90      * Requirements:
91      *
92      * - input must fit into 32 bits
93      */
94     function toUint32(uint256 value) internal pure returns (uint32) {
95         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
96         return uint32(value);
97     }
98 
99     /**
100      * @dev Returns the downcasted uint16 from uint256, reverting on
101      * overflow (when the input is greater than largest uint16).
102      *
103      * Counterpart to Solidity's `uint16` operator.
104      *
105      * Requirements:
106      *
107      * - input must fit into 16 bits
108      */
109     function toUint16(uint256 value) internal pure returns (uint16) {
110         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
111         return uint16(value);
112     }
113 
114     /**
115      * @dev Returns the downcasted uint8 from uint256, reverting on
116      * overflow (when the input is greater than largest uint8).
117      *
118      * Counterpart to Solidity's `uint8` operator.
119      *
120      * Requirements:
121      *
122      * - input must fit into 8 bits.
123      */
124     function toUint8(uint256 value) internal pure returns (uint8) {
125         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
126         return uint8(value);
127     }
128 
129     /**
130      * @dev Converts a signed int256 into an unsigned uint256.
131      *
132      * Requirements:
133      *
134      * - input must be greater than or equal to 0.
135      */
136     function toUint256(int256 value) internal pure returns (uint256) {
137         require(value >= 0, "SafeCast: value must be positive");
138         return uint256(value);
139     }
140 
141     /**
142      * @dev Returns the downcasted int128 from int256, reverting on
143      * overflow (when the input is less than smallest int128 or
144      * greater than largest int128).
145      *
146      * Counterpart to Solidity's `int128` operator.
147      *
148      * Requirements:
149      *
150      * - input must fit into 128 bits
151      *
152      * _Available since v3.1._
153      */
154     function toInt128(int256 value) internal pure returns (int128) {
155         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
156         return int128(value);
157     }
158 
159     /**
160      * @dev Returns the downcasted int64 from int256, reverting on
161      * overflow (when the input is less than smallest int64 or
162      * greater than largest int64).
163      *
164      * Counterpart to Solidity's `int64` operator.
165      *
166      * Requirements:
167      *
168      * - input must fit into 64 bits
169      *
170      * _Available since v3.1._
171      */
172     function toInt64(int256 value) internal pure returns (int64) {
173         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
174         return int64(value);
175     }
176 
177     /**
178      * @dev Returns the downcasted int32 from int256, reverting on
179      * overflow (when the input is less than smallest int32 or
180      * greater than largest int32).
181      *
182      * Counterpart to Solidity's `int32` operator.
183      *
184      * Requirements:
185      *
186      * - input must fit into 32 bits
187      *
188      * _Available since v3.1._
189      */
190     function toInt32(int256 value) internal pure returns (int32) {
191         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
192         return int32(value);
193     }
194 
195     /**
196      * @dev Returns the downcasted int16 from int256, reverting on
197      * overflow (when the input is less than smallest int16 or
198      * greater than largest int16).
199      *
200      * Counterpart to Solidity's `int16` operator.
201      *
202      * Requirements:
203      *
204      * - input must fit into 16 bits
205      *
206      * _Available since v3.1._
207      */
208     function toInt16(int256 value) internal pure returns (int16) {
209         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
210         return int16(value);
211     }
212 
213     /**
214      * @dev Returns the downcasted int8 from int256, reverting on
215      * overflow (when the input is less than smallest int8 or
216      * greater than largest int8).
217      *
218      * Counterpart to Solidity's `int8` operator.
219      *
220      * Requirements:
221      *
222      * - input must fit into 8 bits.
223      *
224      * _Available since v3.1._
225      */
226     function toInt8(int256 value) internal pure returns (int8) {
227         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
228         return int8(value);
229     }
230 
231     /**
232      * @dev Converts an unsigned uint256 into a signed int256.
233      *
234      * Requirements:
235      *
236      * - input must be less than or equal to maxInt256.
237      */
238     function toInt256(uint256 value) internal pure returns (int256) {
239         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
240         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
241         return int256(value);
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/math/Math.sol
246 
247 
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Standard math utilities missing in the Solidity language.
253  */
254 library Math {
255     /**
256      * @dev Returns the largest of two numbers.
257      */
258     function max(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a >= b ? a : b;
260     }
261 
262     /**
263      * @dev Returns the smallest of two numbers.
264      */
265     function min(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a < b ? a : b;
267     }
268 
269     /**
270      * @dev Returns the average of two numbers. The result is rounded towards
271      * zero.
272      */
273     function average(uint256 a, uint256 b) internal pure returns (uint256) {
274         // (a + b) / 2 can overflow.
275         return (a & b) + (a ^ b) / 2;
276     }
277 
278     /**
279      * @dev Returns the ceiling of the division of two numbers.
280      *
281      * This differs from standard division with `/` in that it rounds up instead
282      * of rounding down.
283      */
284     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
285         // (a + b - 1) / b can overflow on addition, so we distribute.
286         return a / b + (a % b == 0 ? 0 : 1);
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Counters.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @title Counters
298  * @author Matt Condon (@shrugs)
299  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
300  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
301  *
302  * Include with `using Counters for Counters.Counter;`
303  */
304 library Counters {
305     struct Counter {
306         // This variable should never be directly accessed by users of the library: interactions must be restricted to
307         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
308         // this feature: see https://github.com/ethereum/solidity/issues/4637
309         uint256 _value; // default: 0
310     }
311 
312     function current(Counter storage counter) internal view returns (uint256) {
313         return counter._value;
314     }
315 
316     function increment(Counter storage counter) internal {
317         unchecked {
318             counter._value += 1;
319         }
320     }
321 
322     function decrement(Counter storage counter) internal {
323         uint256 value = counter._value;
324         require(value > 0, "Counter: decrement overflow");
325         unchecked {
326             counter._value = value - 1;
327         }
328     }
329 
330     function reset(Counter storage counter) internal {
331         counter._value = 0;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
343  *
344  * These functions can be used to verify that a message was signed by the holder
345  * of the private keys of a given address.
346  */
347 library ECDSA {
348     enum RecoverError {
349         NoError,
350         InvalidSignature,
351         InvalidSignatureLength,
352         InvalidSignatureS,
353         InvalidSignatureV
354     }
355 
356     function _throwError(RecoverError error) private pure {
357         if (error == RecoverError.NoError) {
358             return; // no error: do nothing
359         } else if (error == RecoverError.InvalidSignature) {
360             revert("ECDSA: invalid signature");
361         } else if (error == RecoverError.InvalidSignatureLength) {
362             revert("ECDSA: invalid signature length");
363         } else if (error == RecoverError.InvalidSignatureS) {
364             revert("ECDSA: invalid signature 's' value");
365         } else if (error == RecoverError.InvalidSignatureV) {
366             revert("ECDSA: invalid signature 'v' value");
367         }
368     }
369 
370     /**
371      * @dev Returns the address that signed a hashed message (`hash`) with
372      * `signature` or error string. This address can then be used for verification purposes.
373      *
374      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
375      * this function rejects them by requiring the `s` value to be in the lower
376      * half order, and the `v` value to be either 27 or 28.
377      *
378      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
379      * verification to be secure: it is possible to craft signatures that
380      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
381      * this is by receiving a hash of the original message (which may otherwise
382      * be too long), and then calling {toEthSignedMessageHash} on it.
383      *
384      * Documentation for signature generation:
385      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
386      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
387      *
388      * _Available since v4.3._
389      */
390     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
391         // Check the signature length
392         // - case 65: r,s,v signature (standard)
393         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
394         if (signature.length == 65) {
395             bytes32 r;
396             bytes32 s;
397             uint8 v;
398             // ecrecover takes the signature parameters, and the only way to get them
399             // currently is to use assembly.
400             assembly {
401                 r := mload(add(signature, 0x20))
402                 s := mload(add(signature, 0x40))
403                 v := byte(0, mload(add(signature, 0x60)))
404             }
405             return tryRecover(hash, v, r, s);
406         } else if (signature.length == 64) {
407             bytes32 r;
408             bytes32 vs;
409             // ecrecover takes the signature parameters, and the only way to get them
410             // currently is to use assembly.
411             assembly {
412                 r := mload(add(signature, 0x20))
413                 vs := mload(add(signature, 0x40))
414             }
415             return tryRecover(hash, r, vs);
416         } else {
417             return (address(0), RecoverError.InvalidSignatureLength);
418         }
419     }
420 
421     /**
422      * @dev Returns the address that signed a hashed message (`hash`) with
423      * `signature`. This address can then be used for verification purposes.
424      *
425      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
426      * this function rejects them by requiring the `s` value to be in the lower
427      * half order, and the `v` value to be either 27 or 28.
428      *
429      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
430      * verification to be secure: it is possible to craft signatures that
431      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
432      * this is by receiving a hash of the original message (which may otherwise
433      * be too long), and then calling {toEthSignedMessageHash} on it.
434      */
435     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
436         (address recovered, RecoverError error) = tryRecover(hash, signature);
437         _throwError(error);
438         return recovered;
439     }
440 
441     /**
442      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
443      *
444      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
445      *
446      * _Available since v4.3._
447      */
448     function tryRecover(
449         bytes32 hash,
450         bytes32 r,
451         bytes32 vs
452     ) internal pure returns (address, RecoverError) {
453         bytes32 s;
454         uint8 v;
455         assembly {
456             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
457             v := add(shr(255, vs), 27)
458         }
459         return tryRecover(hash, v, r, s);
460     }
461 
462     /**
463      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
464      *
465      * _Available since v4.2._
466      */
467     function recover(
468         bytes32 hash,
469         bytes32 r,
470         bytes32 vs
471     ) internal pure returns (address) {
472         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
473         _throwError(error);
474         return recovered;
475     }
476 
477     /**
478      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
479      * `r` and `s` signature fields separately.
480      *
481      * _Available since v4.3._
482      */
483     function tryRecover(
484         bytes32 hash,
485         uint8 v,
486         bytes32 r,
487         bytes32 s
488     ) internal pure returns (address, RecoverError) {
489         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
490         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
491         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
492         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
493         //
494         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
495         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
496         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
497         // these malleable signatures as well.
498         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
499             return (address(0), RecoverError.InvalidSignatureS);
500         }
501         if (v != 27 && v != 28) {
502             return (address(0), RecoverError.InvalidSignatureV);
503         }
504 
505         // If the signature is valid (and not malleable), return the signer address
506         address signer = ecrecover(hash, v, r, s);
507         if (signer == address(0)) {
508             return (address(0), RecoverError.InvalidSignature);
509         }
510 
511         return (signer, RecoverError.NoError);
512     }
513 
514     /**
515      * @dev Overload of {ECDSA-recover} that receives the `v`,
516      * `r` and `s` signature fields separately.
517      */
518     function recover(
519         bytes32 hash,
520         uint8 v,
521         bytes32 r,
522         bytes32 s
523     ) internal pure returns (address) {
524         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
525         _throwError(error);
526         return recovered;
527     }
528 
529     /**
530      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
531      * produces hash corresponding to the one signed with the
532      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
533      * JSON-RPC method as part of EIP-191.
534      *
535      * See {recover}.
536      */
537     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
538         // 32 is the length in bytes of hash,
539         // enforced by the type signature above
540         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
541     }
542 
543     /**
544      * @dev Returns an Ethereum Signed Typed Data, created from a
545      * `domainSeparator` and a `structHash`. This produces hash corresponding
546      * to the one signed with the
547      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
548      * JSON-RPC method as part of EIP-712.
549      *
550      * See {recover}.
551      */
552     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
553         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
554     }
555 }
556 
557 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
558 
559 
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
566  *
567  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
568  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
569  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
570  *
571  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
572  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
573  * ({_hashTypedDataV4}).
574  *
575  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
576  * the chain id to protect against replay attacks on an eventual fork of the chain.
577  *
578  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
579  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
580  *
581  * _Available since v3.4._
582  */
583 abstract contract EIP712 {
584     /* solhint-disable var-name-mixedcase */
585     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
586     // invalidate the cached domain separator if the chain id changes.
587     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
588     uint256 private immutable _CACHED_CHAIN_ID;
589 
590     bytes32 private immutable _HASHED_NAME;
591     bytes32 private immutable _HASHED_VERSION;
592     bytes32 private immutable _TYPE_HASH;
593 
594     /* solhint-enable var-name-mixedcase */
595 
596     /**
597      * @dev Initializes the domain separator and parameter caches.
598      *
599      * The meaning of `name` and `version` is specified in
600      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
601      *
602      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
603      * - `version`: the current major version of the signing domain.
604      *
605      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
606      * contract upgrade].
607      */
608     constructor(string memory name, string memory version) {
609         bytes32 hashedName = keccak256(bytes(name));
610         bytes32 hashedVersion = keccak256(bytes(version));
611         bytes32 typeHash = keccak256(
612             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
613         );
614         _HASHED_NAME = hashedName;
615         _HASHED_VERSION = hashedVersion;
616         _CACHED_CHAIN_ID = block.chainid;
617         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
618         _TYPE_HASH = typeHash;
619     }
620 
621     /**
622      * @dev Returns the domain separator for the current chain.
623      */
624     function _domainSeparatorV4() internal view returns (bytes32) {
625         if (block.chainid == _CACHED_CHAIN_ID) {
626             return _CACHED_DOMAIN_SEPARATOR;
627         } else {
628             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
629         }
630     }
631 
632     function _buildDomainSeparator(
633         bytes32 typeHash,
634         bytes32 nameHash,
635         bytes32 versionHash
636     ) private view returns (bytes32) {
637         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
638     }
639 
640     /**
641      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
642      * function returns the hash of the fully encoded EIP712 message for this domain.
643      *
644      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
645      *
646      * ```solidity
647      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
648      *     keccak256("Mail(address to,string contents)"),
649      *     mailTo,
650      *     keccak256(bytes(mailContents))
651      * )));
652      * address signer = ECDSA.recover(digest, signature);
653      * ```
654      */
655     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
656         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
657     }
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
661 
662 
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
668  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
669  *
670  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
671  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
672  * need to send a transaction, and thus is not required to hold Ether at all.
673  */
674 interface IERC20Permit {
675     /**
676      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
677      * given ``owner``'s signed approval.
678      *
679      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
680      * ordering also apply here.
681      *
682      * Emits an {Approval} event.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      * - `deadline` must be a timestamp in the future.
688      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
689      * over the EIP712-formatted function arguments.
690      * - the signature must use ``owner``'s current nonce (see {nonces}).
691      *
692      * For more information on the signature format, see the
693      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
694      * section].
695      */
696     function permit(
697         address owner,
698         address spender,
699         uint256 value,
700         uint256 deadline,
701         uint8 v,
702         bytes32 r,
703         bytes32 s
704     ) external;
705 
706     /**
707      * @dev Returns the current nonce for `owner`. This value must be
708      * included whenever a signature is generated for {permit}.
709      *
710      * Every successful call to {permit} increases ``owner``'s nonce by one. This
711      * prevents a signature from being used multiple times.
712      */
713     function nonces(address owner) external view returns (uint256);
714 
715     /**
716      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
717      */
718     // solhint-disable-next-line func-name-mixedcase
719     function DOMAIN_SEPARATOR() external view returns (bytes32);
720 }
721 
722 // File: @openzeppelin/contracts/utils/Context.sol
723 
724 
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Provides information about the current execution context, including the
730  * sender of the transaction and its data. While these are generally available
731  * via msg.sender and msg.data, they should not be accessed in such a direct
732  * manner, since when dealing with meta-transactions the account sending and
733  * paying for execution may not be the actual sender (as far as an application
734  * is concerned).
735  *
736  * This contract is only required for intermediate, library-like contracts.
737  */
738 abstract contract Context {
739     function _msgSender() internal view virtual returns (address) {
740         return msg.sender;
741     }
742 
743     function _msgData() internal view virtual returns (bytes calldata) {
744         return msg.data;
745     }
746 }
747 
748 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
749 
750 
751 
752 pragma solidity ^0.8.0;
753 
754 /**
755  * @dev Interface of the ERC20 standard as defined in the EIP.
756  */
757 interface IERC20 {
758     /**
759      * @dev Returns the amount of tokens in existence.
760      */
761     function totalSupply() external view returns (uint256);
762 
763     /**
764      * @dev Returns the amount of tokens owned by `account`.
765      */
766     function balanceOf(address account) external view returns (uint256);
767 
768     /**
769      * @dev Moves `amount` tokens from the caller's account to `recipient`.
770      *
771      * Returns a boolean value indicating whether the operation succeeded.
772      *
773      * Emits a {Transfer} event.
774      */
775     function transfer(address recipient, uint256 amount) external returns (bool);
776 
777     /**
778      * @dev Returns the remaining number of tokens that `spender` will be
779      * allowed to spend on behalf of `owner` through {transferFrom}. This is
780      * zero by default.
781      *
782      * This value changes when {approve} or {transferFrom} are called.
783      */
784     function allowance(address owner, address spender) external view returns (uint256);
785 
786     /**
787      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
788      *
789      * Returns a boolean value indicating whether the operation succeeded.
790      *
791      * IMPORTANT: Beware that changing an allowance with this method brings the risk
792      * that someone may use both the old and the new allowance by unfortunate
793      * transaction ordering. One possible solution to mitigate this race
794      * condition is to first reduce the spender's allowance to 0 and set the
795      * desired value afterwards:
796      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
797      *
798      * Emits an {Approval} event.
799      */
800     function approve(address spender, uint256 amount) external returns (bool);
801 
802     /**
803      * @dev Moves `amount` tokens from `sender` to `recipient` using the
804      * allowance mechanism. `amount` is then deducted from the caller's
805      * allowance.
806      *
807      * Returns a boolean value indicating whether the operation succeeded.
808      *
809      * Emits a {Transfer} event.
810      */
811     function transferFrom(
812         address sender,
813         address recipient,
814         uint256 amount
815     ) external returns (bool);
816 
817     /**
818      * @dev Emitted when `value` tokens are moved from one account (`from`) to
819      * another (`to`).
820      *
821      * Note that `value` may be zero.
822      */
823     event Transfer(address indexed from, address indexed to, uint256 value);
824 
825     /**
826      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
827      * a call to {approve}. `value` is the new allowance.
828      */
829     event Approval(address indexed owner, address indexed spender, uint256 value);
830 }
831 
832 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
833 
834 
835 
836 pragma solidity ^0.8.0;
837 
838 
839 /**
840  * @dev Interface for the optional metadata functions from the ERC20 standard.
841  *
842  * _Available since v4.1._
843  */
844 interface IERC20Metadata is IERC20 {
845     /**
846      * @dev Returns the name of the token.
847      */
848     function name() external view returns (string memory);
849 
850     /**
851      * @dev Returns the symbol of the token.
852      */
853     function symbol() external view returns (string memory);
854 
855     /**
856      * @dev Returns the decimals places of the token.
857      */
858     function decimals() external view returns (uint8);
859 }
860 
861 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
862 
863 
864 
865 pragma solidity ^0.8.0;
866 
867 
868 
869 
870 /**
871  * @dev Implementation of the {IERC20} interface.
872  *
873  * This implementation is agnostic to the way tokens are created. This means
874  * that a supply mechanism has to be added in a derived contract using {_mint}.
875  * For a generic mechanism see {ERC20PresetMinterPauser}.
876  *
877  * TIP: For a detailed writeup see our guide
878  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
879  * to implement supply mechanisms].
880  *
881  * We have followed general OpenZeppelin Contracts guidelines: functions revert
882  * instead returning `false` on failure. This behavior is nonetheless
883  * conventional and does not conflict with the expectations of ERC20
884  * applications.
885  *
886  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
887  * This allows applications to reconstruct the allowance for all accounts just
888  * by listening to said events. Other implementations of the EIP may not emit
889  * these events, as it isn't required by the specification.
890  *
891  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
892  * functions have been added to mitigate the well-known issues around setting
893  * allowances. See {IERC20-approve}.
894  */
895 contract ERC20 is Context, IERC20, IERC20Metadata {
896     mapping(address => uint256) private _balances;
897 
898     mapping(address => mapping(address => uint256)) private _allowances;
899 
900     uint256 private _totalSupply;
901 
902     string private _name;
903     string private _symbol;
904 
905     /**
906      * @dev Sets the values for {name} and {symbol}.
907      *
908      * The default value of {decimals} is 18. To select a different value for
909      * {decimals} you should overload it.
910      *
911      * All two of these values are immutable: they can only be set once during
912      * construction.
913      */
914     constructor(string memory name_, string memory symbol_) {
915         _name = name_;
916         _symbol = symbol_;
917     }
918 
919     /**
920      * @dev Returns the name of the token.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev Returns the symbol of the token, usually a shorter version of the
928      * name.
929      */
930     function symbol() public view virtual override returns (string memory) {
931         return _symbol;
932     }
933 
934     /**
935      * @dev Returns the number of decimals used to get its user representation.
936      * For example, if `decimals` equals `2`, a balance of `505` tokens should
937      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
938      *
939      * Tokens usually opt for a value of 18, imitating the relationship between
940      * Ether and Wei. This is the value {ERC20} uses, unless this function is
941      * overridden;
942      *
943      * NOTE: This information is only used for _display_ purposes: it in
944      * no way affects any of the arithmetic of the contract, including
945      * {IERC20-balanceOf} and {IERC20-transfer}.
946      */
947     function decimals() public view virtual override returns (uint8) {
948         return 18;
949     }
950 
951     /**
952      * @dev See {IERC20-totalSupply}.
953      */
954     function totalSupply() public view virtual override returns (uint256) {
955         return _totalSupply;
956     }
957 
958     /**
959      * @dev See {IERC20-balanceOf}.
960      */
961     function balanceOf(address account) public view virtual override returns (uint256) {
962         return _balances[account];
963     }
964 
965     /**
966      * @dev See {IERC20-transfer}.
967      *
968      * Requirements:
969      *
970      * - `recipient` cannot be the zero address.
971      * - the caller must have a balance of at least `amount`.
972      */
973     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
974         _transfer(_msgSender(), recipient, amount);
975         return true;
976     }
977 
978     /**
979      * @dev See {IERC20-allowance}.
980      */
981     function allowance(address owner, address spender) public view virtual override returns (uint256) {
982         return _allowances[owner][spender];
983     }
984 
985     /**
986      * @dev See {IERC20-approve}.
987      *
988      * Requirements:
989      *
990      * - `spender` cannot be the zero address.
991      */
992     function approve(address spender, uint256 amount) public virtual override returns (bool) {
993         _approve(_msgSender(), spender, amount);
994         return true;
995     }
996 
997     /**
998      * @dev See {IERC20-transferFrom}.
999      *
1000      * Emits an {Approval} event indicating the updated allowance. This is not
1001      * required by the EIP. See the note at the beginning of {ERC20}.
1002      *
1003      * Requirements:
1004      *
1005      * - `sender` and `recipient` cannot be the zero address.
1006      * - `sender` must have a balance of at least `amount`.
1007      * - the caller must have allowance for ``sender``'s tokens of at least
1008      * `amount`.
1009      */
1010     function transferFrom(
1011         address sender,
1012         address recipient,
1013         uint256 amount
1014     ) public virtual override returns (bool) {
1015         _transfer(sender, recipient, amount);
1016 
1017         uint256 currentAllowance = _allowances[sender][_msgSender()];
1018         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1019         unchecked {
1020             _approve(sender, _msgSender(), currentAllowance - amount);
1021         }
1022 
1023         return true;
1024     }
1025 
1026     /**
1027      * @dev Atomically increases the allowance granted to `spender` by the caller.
1028      *
1029      * This is an alternative to {approve} that can be used as a mitigation for
1030      * problems described in {IERC20-approve}.
1031      *
1032      * Emits an {Approval} event indicating the updated allowance.
1033      *
1034      * Requirements:
1035      *
1036      * - `spender` cannot be the zero address.
1037      */
1038     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1039         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1040         return true;
1041     }
1042 
1043     /**
1044      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1045      *
1046      * This is an alternative to {approve} that can be used as a mitigation for
1047      * problems described in {IERC20-approve}.
1048      *
1049      * Emits an {Approval} event indicating the updated allowance.
1050      *
1051      * Requirements:
1052      *
1053      * - `spender` cannot be the zero address.
1054      * - `spender` must have allowance for the caller of at least
1055      * `subtractedValue`.
1056      */
1057     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1058         uint256 currentAllowance = _allowances[_msgSender()][spender];
1059         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1060         unchecked {
1061             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1062         }
1063 
1064         return true;
1065     }
1066 
1067     /**
1068      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1069      *
1070      * This internal function is equivalent to {transfer}, and can be used to
1071      * e.g. implement automatic token fees, slashing mechanisms, etc.
1072      *
1073      * Emits a {Transfer} event.
1074      *
1075      * Requirements:
1076      *
1077      * - `sender` cannot be the zero address.
1078      * - `recipient` cannot be the zero address.
1079      * - `sender` must have a balance of at least `amount`.
1080      */
1081     function _transfer(
1082         address sender,
1083         address recipient,
1084         uint256 amount
1085     ) internal virtual {
1086         require(sender != address(0), "ERC20: transfer from the zero address");
1087         require(recipient != address(0), "ERC20: transfer to the zero address");
1088 
1089         _beforeTokenTransfer(sender, recipient, amount);
1090 
1091         uint256 senderBalance = _balances[sender];
1092         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1093         unchecked {
1094             _balances[sender] = senderBalance - amount;
1095         }
1096         _balances[recipient] += amount;
1097 
1098         emit Transfer(sender, recipient, amount);
1099 
1100         _afterTokenTransfer(sender, recipient, amount);
1101     }
1102 
1103     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1104      * the total supply.
1105      *
1106      * Emits a {Transfer} event with `from` set to the zero address.
1107      *
1108      * Requirements:
1109      *
1110      * - `account` cannot be the zero address.
1111      */
1112     function _mint(address account, uint256 amount) internal virtual {
1113         require(account != address(0), "ERC20: mint to the zero address");
1114 
1115         _beforeTokenTransfer(address(0), account, amount);
1116 
1117         _totalSupply += amount;
1118         _balances[account] += amount;
1119         emit Transfer(address(0), account, amount);
1120 
1121         _afterTokenTransfer(address(0), account, amount);
1122     }
1123 
1124     /**
1125      * @dev Destroys `amount` tokens from `account`, reducing the
1126      * total supply.
1127      *
1128      * Emits a {Transfer} event with `to` set to the zero address.
1129      *
1130      * Requirements:
1131      *
1132      * - `account` cannot be the zero address.
1133      * - `account` must have at least `amount` tokens.
1134      */
1135     function _burn(address account, uint256 amount) internal virtual {
1136         require(account != address(0), "ERC20: burn from the zero address");
1137 
1138         _beforeTokenTransfer(account, address(0), amount);
1139 
1140         uint256 accountBalance = _balances[account];
1141         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1142         unchecked {
1143             _balances[account] = accountBalance - amount;
1144         }
1145         _totalSupply -= amount;
1146 
1147         emit Transfer(account, address(0), amount);
1148 
1149         _afterTokenTransfer(account, address(0), amount);
1150     }
1151 
1152     /**
1153      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1154      *
1155      * This internal function is equivalent to `approve`, and can be used to
1156      * e.g. set automatic allowances for certain subsystems, etc.
1157      *
1158      * Emits an {Approval} event.
1159      *
1160      * Requirements:
1161      *
1162      * - `owner` cannot be the zero address.
1163      * - `spender` cannot be the zero address.
1164      */
1165     function _approve(
1166         address owner,
1167         address spender,
1168         uint256 amount
1169     ) internal virtual {
1170         require(owner != address(0), "ERC20: approve from the zero address");
1171         require(spender != address(0), "ERC20: approve to the zero address");
1172 
1173         _allowances[owner][spender] = amount;
1174         emit Approval(owner, spender, amount);
1175     }
1176 
1177     /**
1178      * @dev Hook that is called before any transfer of tokens. This includes
1179      * minting and burning.
1180      *
1181      * Calling conditions:
1182      *
1183      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1184      * will be transferred to `to`.
1185      * - when `from` is zero, `amount` tokens will be minted for `to`.
1186      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1187      * - `from` and `to` are never both zero.
1188      *
1189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1190      */
1191     function _beforeTokenTransfer(
1192         address from,
1193         address to,
1194         uint256 amount
1195     ) internal virtual {}
1196 
1197     /**
1198      * @dev Hook that is called after any transfer of tokens. This includes
1199      * minting and burning.
1200      *
1201      * Calling conditions:
1202      *
1203      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1204      * has been transferred to `to`.
1205      * - when `from` is zero, `amount` tokens have been minted for `to`.
1206      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1207      * - `from` and `to` are never both zero.
1208      *
1209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1210      */
1211     function _afterTokenTransfer(
1212         address from,
1213         address to,
1214         uint256 amount
1215     ) internal virtual {}
1216 }
1217 
1218 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1219 
1220 
1221 
1222 pragma solidity ^0.8.0;
1223 
1224 
1225 
1226 /**
1227  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1228  * tokens and those that they have an allowance for, in a way that can be
1229  * recognized off-chain (via event analysis).
1230  */
1231 abstract contract ERC20Burnable is Context, ERC20 {
1232     /**
1233      * @dev Destroys `amount` tokens from the caller.
1234      *
1235      * See {ERC20-_burn}.
1236      */
1237     function burn(uint256 amount) public virtual {
1238         _burn(_msgSender(), amount);
1239     }
1240 
1241     /**
1242      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1243      * allowance.
1244      *
1245      * See {ERC20-_burn} and {ERC20-allowance}.
1246      *
1247      * Requirements:
1248      *
1249      * - the caller must have allowance for ``accounts``'s tokens of at least
1250      * `amount`.
1251      */
1252     function burnFrom(address account, uint256 amount) public virtual {
1253         uint256 currentAllowance = allowance(account, _msgSender());
1254         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1255         unchecked {
1256             _approve(account, _msgSender(), currentAllowance - amount);
1257         }
1258         _burn(account, amount);
1259     }
1260 }
1261 
1262 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1263 
1264 
1265 
1266 pragma solidity ^0.8.0;
1267 
1268 
1269 
1270 
1271 
1272 
1273 /**
1274  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1275  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1276  *
1277  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1278  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1279  * need to send a transaction, and thus is not required to hold Ether at all.
1280  *
1281  * _Available since v3.4._
1282  */
1283 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1284     using Counters for Counters.Counter;
1285 
1286     mapping(address => Counters.Counter) private _nonces;
1287 
1288     // solhint-disable-next-line var-name-mixedcase
1289     bytes32 private immutable _PERMIT_TYPEHASH =
1290         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1291 
1292     /**
1293      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1294      *
1295      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1296      */
1297     constructor(string memory name) EIP712(name, "1") {}
1298 
1299     /**
1300      * @dev See {IERC20Permit-permit}.
1301      */
1302     function permit(
1303         address owner,
1304         address spender,
1305         uint256 value,
1306         uint256 deadline,
1307         uint8 v,
1308         bytes32 r,
1309         bytes32 s
1310     ) public virtual override {
1311         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1312 
1313         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1314 
1315         bytes32 hash = _hashTypedDataV4(structHash);
1316 
1317         address signer = ECDSA.recover(hash, v, r, s);
1318         require(signer == owner, "ERC20Permit: invalid signature");
1319 
1320         _approve(owner, spender, value);
1321     }
1322 
1323     /**
1324      * @dev See {IERC20Permit-nonces}.
1325      */
1326     function nonces(address owner) public view virtual override returns (uint256) {
1327         return _nonces[owner].current();
1328     }
1329 
1330     /**
1331      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1332      */
1333     // solhint-disable-next-line func-name-mixedcase
1334     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1335         return _domainSeparatorV4();
1336     }
1337 
1338     /**
1339      * @dev "Consume a nonce": return the current value and increment.
1340      *
1341      * _Available since v4.1._
1342      */
1343     function _useNonce(address owner) internal virtual returns (uint256 current) {
1344         Counters.Counter storage nonce = _nonces[owner];
1345         current = nonce.current();
1346         nonce.increment();
1347     }
1348 }
1349 
1350 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol
1351 
1352 
1353 
1354 pragma solidity ^0.8.0;
1355 
1356 
1357 
1358 
1359 
1360 /**
1361  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1362  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1363  *
1364  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1365  *
1366  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1367  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1368  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1369  *
1370  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1371  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1372  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1373  * will significantly increase the base gas cost of transfers.
1374  *
1375  * _Available since v4.2._
1376  */
1377 abstract contract ERC20Votes is ERC20Permit {
1378     struct Checkpoint {
1379         uint32 fromBlock;
1380         uint224 votes;
1381     }
1382 
1383     bytes32 private constant _DELEGATION_TYPEHASH =
1384         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1385 
1386     mapping(address => address) private _delegates;
1387     mapping(address => Checkpoint[]) private _checkpoints;
1388     Checkpoint[] private _totalSupplyCheckpoints;
1389 
1390     /**
1391      * @dev Emitted when an account changes their delegate.
1392      */
1393     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1394 
1395     /**
1396      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1397      */
1398     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1399 
1400     /**
1401      * @dev Get the `pos`-th checkpoint for `account`.
1402      */
1403     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1404         return _checkpoints[account][pos];
1405     }
1406 
1407     /**
1408      * @dev Get number of checkpoints for `account`.
1409      */
1410     function numCheckpoints(address account) public view virtual returns (uint32) {
1411         return SafeCast.toUint32(_checkpoints[account].length);
1412     }
1413 
1414     /**
1415      * @dev Get the address `account` is currently delegating to.
1416      */
1417     function delegates(address account) public view virtual returns (address) {
1418         return _delegates[account];
1419     }
1420 
1421     /**
1422      * @dev Gets the current votes balance for `account`
1423      */
1424     function getVotes(address account) public view returns (uint256) {
1425         uint256 pos = _checkpoints[account].length;
1426         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1427     }
1428 
1429     /**
1430      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1431      *
1432      * Requirements:
1433      *
1434      * - `blockNumber` must have been already mined
1435      */
1436     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1437         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1438         return _checkpointsLookup(_checkpoints[account], blockNumber);
1439     }
1440 
1441     /**
1442      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1443      * It is but NOT the sum of all the delegated votes!
1444      *
1445      * Requirements:
1446      *
1447      * - `blockNumber` must have been already mined
1448      */
1449     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1450         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1451         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1452     }
1453 
1454     /**
1455      * @dev Lookup a value in a list of (sorted) checkpoints.
1456      */
1457     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1458         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1459         //
1460         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1461         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1462         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1463         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1464         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1465         // out of bounds (in which case we're looking too far in the past and the result is 0).
1466         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1467         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1468         // the same.
1469         uint256 high = ckpts.length;
1470         uint256 low = 0;
1471         while (low < high) {
1472             uint256 mid = Math.average(low, high);
1473             if (ckpts[mid].fromBlock > blockNumber) {
1474                 high = mid;
1475             } else {
1476                 low = mid + 1;
1477             }
1478         }
1479 
1480         return high == 0 ? 0 : ckpts[high - 1].votes;
1481     }
1482 
1483     /**
1484      * @dev Delegate votes from the sender to `delegatee`.
1485      */
1486     function delegate(address delegatee) public virtual {
1487         return _delegate(_msgSender(), delegatee);
1488     }
1489 
1490     /**
1491      * @dev Delegates votes from signer to `delegatee`
1492      */
1493     function delegateBySig(
1494         address delegatee,
1495         uint256 nonce,
1496         uint256 expiry,
1497         uint8 v,
1498         bytes32 r,
1499         bytes32 s
1500     ) public virtual {
1501         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1502         address signer = ECDSA.recover(
1503             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1504             v,
1505             r,
1506             s
1507         );
1508         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1509         return _delegate(signer, delegatee);
1510     }
1511 
1512     /**
1513      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1514      */
1515     function _maxSupply() internal view virtual returns (uint224) {
1516         return type(uint224).max;
1517     }
1518 
1519     /**
1520      * @dev Snapshots the totalSupply after it has been increased.
1521      */
1522     function _mint(address account, uint256 amount) internal virtual override {
1523         super._mint(account, amount);
1524         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1525 
1526         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1527     }
1528 
1529     /**
1530      * @dev Snapshots the totalSupply after it has been decreased.
1531      */
1532     function _burn(address account, uint256 amount) internal virtual override {
1533         super._burn(account, amount);
1534 
1535         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1536     }
1537 
1538     /**
1539      * @dev Move voting power when tokens are transferred.
1540      *
1541      * Emits a {DelegateVotesChanged} event.
1542      */
1543     function _afterTokenTransfer(
1544         address from,
1545         address to,
1546         uint256 amount
1547     ) internal virtual override {
1548         super._afterTokenTransfer(from, to, amount);
1549 
1550         _moveVotingPower(delegates(from), delegates(to), amount);
1551     }
1552 
1553     /**
1554      * @dev Change delegation for `delegator` to `delegatee`.
1555      *
1556      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1557      */
1558     function _delegate(address delegator, address delegatee) internal virtual {
1559         address currentDelegate = delegates(delegator);
1560         uint256 delegatorBalance = balanceOf(delegator);
1561         _delegates[delegator] = delegatee;
1562 
1563         emit DelegateChanged(delegator, currentDelegate, delegatee);
1564 
1565         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1566     }
1567 
1568     function _moveVotingPower(
1569         address src,
1570         address dst,
1571         uint256 amount
1572     ) private {
1573         if (src != dst && amount > 0) {
1574             if (src != address(0)) {
1575                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1576                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1577             }
1578 
1579             if (dst != address(0)) {
1580                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1581                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1582             }
1583         }
1584     }
1585 
1586     function _writeCheckpoint(
1587         Checkpoint[] storage ckpts,
1588         function(uint256, uint256) view returns (uint256) op,
1589         uint256 delta
1590     ) private returns (uint256 oldWeight, uint256 newWeight) {
1591         uint256 pos = ckpts.length;
1592         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1593         newWeight = op(oldWeight, delta);
1594 
1595         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1596             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1597         } else {
1598             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1599         }
1600     }
1601 
1602     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1603         return a + b;
1604     }
1605 
1606     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1607         return a - b;
1608     }
1609 }
1610 
1611 // File: MetalSwap/Token/MetalSwap.sol
1612 
1613 
1614 pragma solidity ^0.8.7;
1615 
1616 
1617 
1618 
1619 
1620 contract MetalSwap is ERC20, ERC20Permit, ERC20Votes,ERC20Burnable {
1621     constructor(address owner, uint256 initialSupply ) ERC20("MetalSwap", "XMT") ERC20Permit("MetalSwap") {
1622         _mint(owner, initialSupply);
1623     }
1624 
1625     // The functions below are overrides required by Solidity.
1626 
1627     function _afterTokenTransfer(address from, address to, uint256 amount)
1628         internal
1629         override(ERC20, ERC20Votes)
1630     {
1631         super._afterTokenTransfer(from, to, amount);
1632     }
1633 
1634     function _mint(address to, uint256 amount)
1635         internal
1636         override(ERC20, ERC20Votes)
1637     {
1638         super._mint(to, amount);
1639     }
1640 
1641     function _burn(address account, uint256 amount)
1642         internal
1643         override(ERC20, ERC20Votes)
1644     {
1645         super._burn(account, amount);
1646     }
1647 }