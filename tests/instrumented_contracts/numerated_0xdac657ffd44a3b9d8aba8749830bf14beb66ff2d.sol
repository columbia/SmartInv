1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.2;
4 
5 //verified by Qkyrie
6 
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     /**
13      * @dev Returns the largest of two numbers.
14      */
15     function max(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a >= b ? a : b;
17     }
18 
19     /**
20      * @dev Returns the smallest of two numbers.
21      */
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the average of two numbers. The result is rounded towards
28      * zero.
29      */
30     function average(uint256 a, uint256 b) internal pure returns (uint256) {
31         // (a + b) / 2 can overflow.
32         return (a & b) + (a ^ b) / 2;
33     }
34 
35     /**
36      * @dev Returns the ceiling of the division of two numbers.
37      *
38      * This differs from standard division with `/` in that it rounds up instead
39      * of rounding down.
40      */
41     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
42         // (a + b - 1) / b can overflow on addition, so we distribute.
43         return a / b + (a % b == 0 ? 0 : 1);
44     }
45 }
46 
47 
48 /**
49  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
50  * checks.
51  *
52  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
53  * easily result in undesired exploitation or bugs, since developers usually
54  * assume that overflows raise errors. `SafeCast` restores this intuition by
55  * reverting the transaction when such an operation overflows.
56  *
57  * Using this library instead of the unchecked operations eliminates an entire
58  * class of bugs, so it's recommended to use it always.
59  *
60  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
61  * all math on `uint256` and `int256` and then downcasting.
62  */
63 library SafeCast {
64     /**
65      * @dev Returns the downcasted uint224 from uint256, reverting on
66      * overflow (when the input is greater than largest uint224).
67      *
68      * Counterpart to Solidity's `uint224` operator.
69      *
70      * Requirements:
71      *
72      * - input must fit into 224 bits
73      */
74     function toUint224(uint256 value) internal pure returns (uint224) {
75         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
76         return uint224(value);
77     }
78 
79     /**
80      * @dev Returns the downcasted uint128 from uint256, reverting on
81      * overflow (when the input is greater than largest uint128).
82      *
83      * Counterpart to Solidity's `uint128` operator.
84      *
85      * Requirements:
86      *
87      * - input must fit into 128 bits
88      */
89     function toUint128(uint256 value) internal pure returns (uint128) {
90         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
91         return uint128(value);
92     }
93 
94     /**
95      * @dev Returns the downcasted uint96 from uint256, reverting on
96      * overflow (when the input is greater than largest uint96).
97      *
98      * Counterpart to Solidity's `uint96` operator.
99      *
100      * Requirements:
101      *
102      * - input must fit into 96 bits
103      */
104     function toUint96(uint256 value) internal pure returns (uint96) {
105         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
106         return uint96(value);
107     }
108 
109     /**
110      * @dev Returns the downcasted uint64 from uint256, reverting on
111      * overflow (when the input is greater than largest uint64).
112      *
113      * Counterpart to Solidity's `uint64` operator.
114      *
115      * Requirements:
116      *
117      * - input must fit into 64 bits
118      */
119     function toUint64(uint256 value) internal pure returns (uint64) {
120         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
121         return uint64(value);
122     }
123 
124     /**
125      * @dev Returns the downcasted uint32 from uint256, reverting on
126      * overflow (when the input is greater than largest uint32).
127      *
128      * Counterpart to Solidity's `uint32` operator.
129      *
130      * Requirements:
131      *
132      * - input must fit into 32 bits
133      */
134     function toUint32(uint256 value) internal pure returns (uint32) {
135         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
136         return uint32(value);
137     }
138 
139     /**
140      * @dev Returns the downcasted uint16 from uint256, reverting on
141      * overflow (when the input is greater than largest uint16).
142      *
143      * Counterpart to Solidity's `uint16` operator.
144      *
145      * Requirements:
146      *
147      * - input must fit into 16 bits
148      */
149     function toUint16(uint256 value) internal pure returns (uint16) {
150         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
151         return uint16(value);
152     }
153 
154     /**
155      * @dev Returns the downcasted uint8 from uint256, reverting on
156      * overflow (when the input is greater than largest uint8).
157      *
158      * Counterpart to Solidity's `uint8` operator.
159      *
160      * Requirements:
161      *
162      * - input must fit into 8 bits.
163      */
164     function toUint8(uint256 value) internal pure returns (uint8) {
165         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
166         return uint8(value);
167     }
168 
169     /**
170      * @dev Converts a signed int256 into an unsigned uint256.
171      *
172      * Requirements:
173      *
174      * - input must be greater than or equal to 0.
175      */
176     function toUint256(int256 value) internal pure returns (uint256) {
177         require(value >= 0, "SafeCast: value must be positive");
178         return uint256(value);
179     }
180 
181     /**
182      * @dev Returns the downcasted int128 from int256, reverting on
183      * overflow (when the input is less than smallest int128 or
184      * greater than largest int128).
185      *
186      * Counterpart to Solidity's `int128` operator.
187      *
188      * Requirements:
189      *
190      * - input must fit into 128 bits
191      *
192      * _Available since v3.1._
193      */
194     function toInt128(int256 value) internal pure returns (int128) {
195         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
196         return int128(value);
197     }
198 
199     /**
200      * @dev Returns the downcasted int64 from int256, reverting on
201      * overflow (when the input is less than smallest int64 or
202      * greater than largest int64).
203      *
204      * Counterpart to Solidity's `int64` operator.
205      *
206      * Requirements:
207      *
208      * - input must fit into 64 bits
209      *
210      * _Available since v3.1._
211      */
212     function toInt64(int256 value) internal pure returns (int64) {
213         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
214         return int64(value);
215     }
216 
217     /**
218      * @dev Returns the downcasted int32 from int256, reverting on
219      * overflow (when the input is less than smallest int32 or
220      * greater than largest int32).
221      *
222      * Counterpart to Solidity's `int32` operator.
223      *
224      * Requirements:
225      *
226      * - input must fit into 32 bits
227      *
228      * _Available since v3.1._
229      */
230     function toInt32(int256 value) internal pure returns (int32) {
231         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
232         return int32(value);
233     }
234 
235     /**
236      * @dev Returns the downcasted int16 from int256, reverting on
237      * overflow (when the input is less than smallest int16 or
238      * greater than largest int16).
239      *
240      * Counterpart to Solidity's `int16` operator.
241      *
242      * Requirements:
243      *
244      * - input must fit into 16 bits
245      *
246      * _Available since v3.1._
247      */
248     function toInt16(int256 value) internal pure returns (int16) {
249         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
250         return int16(value);
251     }
252 
253     /**
254      * @dev Returns the downcasted int8 from int256, reverting on
255      * overflow (when the input is less than smallest int8 or
256      * greater than largest int8).
257      *
258      * Counterpart to Solidity's `int8` operator.
259      *
260      * Requirements:
261      *
262      * - input must fit into 8 bits.
263      *
264      * _Available since v3.1._
265      */
266     function toInt8(int256 value) internal pure returns (int8) {
267         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
268         return int8(value);
269     }
270 
271     /**
272      * @dev Converts an unsigned uint256 into a signed int256.
273      *
274      * Requirements:
275      *
276      * - input must be less than or equal to maxInt256.
277      */
278     function toInt256(uint256 value) internal pure returns (int256) {
279         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
280         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
281         return int256(value);
282     }
283 }
284 
285 
286 /**
287  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
288  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
289  *
290  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
291  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
292  * need to send a transaction, and thus is not required to hold Ether at all.
293  */
294 interface IERC20Permit {
295     /**
296      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
297      * given ``owner``'s signed approval.
298      *
299      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
300      * ordering also apply here.
301      *
302      * Emits an {Approval} event.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      * - `deadline` must be a timestamp in the future.
308      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
309      * over the EIP712-formatted function arguments.
310      * - the signature must use ``owner``'s current nonce (see {nonces}).
311      *
312      * For more information on the signature format, see the
313      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
314      * section].
315      */
316     function permit(
317         address owner,
318         address spender,
319         uint256 value,
320         uint256 deadline,
321         uint8 v,
322         bytes32 r,
323         bytes32 s
324     ) external;
325 
326     /**
327      * @dev Returns the current nonce for `owner`. This value must be
328      * included whenever a signature is generated for {permit}.
329      *
330      * Every successful call to {permit} increases ``owner``'s nonce by one. This
331      * prevents a signature from being used multiple times.
332      */
333     function nonces(address owner) external view returns (uint256);
334 
335     /**
336      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
337      */
338     // solhint-disable-next-line func-name-mixedcase
339     function DOMAIN_SEPARATOR() external view returns (bytes32);
340 }
341 
342 
343 /**
344  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
345  *
346  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
347  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
348  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
349  *
350  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
351  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
352  * ({_hashTypedDataV4}).
353  *
354  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
355  * the chain id to protect against replay attacks on an eventual fork of the chain.
356  *
357  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
358  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
359  *
360  * _Available since v3.4._
361  */
362 abstract contract EIP712 {
363     /* solhint-disable var-name-mixedcase */
364     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
365     // invalidate the cached domain separator if the chain id changes.
366     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
367     uint256 private immutable _CACHED_CHAIN_ID;
368 
369     bytes32 private immutable _HASHED_NAME;
370     bytes32 private immutable _HASHED_VERSION;
371     bytes32 private immutable _TYPE_HASH;
372 
373     /* solhint-enable var-name-mixedcase */
374 
375     /**
376      * @dev Initializes the domain separator and parameter caches.
377      *
378      * The meaning of `name` and `version` is specified in
379      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
380      *
381      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
382      * - `version`: the current major version of the signing domain.
383      *
384      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
385      * contract upgrade].
386      */
387     constructor(string memory name, string memory version) {
388         bytes32 hashedName = keccak256(bytes(name));
389         bytes32 hashedVersion = keccak256(bytes(version));
390         bytes32 typeHash = keccak256(
391             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
392         );
393         _HASHED_NAME = hashedName;
394         _HASHED_VERSION = hashedVersion;
395         _CACHED_CHAIN_ID = block.chainid;
396         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
397         _TYPE_HASH = typeHash;
398     }
399 
400     /**
401      * @dev Returns the domain separator for the current chain.
402      */
403     function _domainSeparatorV4() internal view returns (bytes32) {
404         if (block.chainid == _CACHED_CHAIN_ID) {
405             return _CACHED_DOMAIN_SEPARATOR;
406         } else {
407             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
408         }
409     }
410 
411     function _buildDomainSeparator(
412         bytes32 typeHash,
413         bytes32 nameHash,
414         bytes32 versionHash
415     ) private view returns (bytes32) {
416         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
417     }
418 
419     /**
420      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
421      * function returns the hash of the fully encoded EIP712 message for this domain.
422      *
423      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
424      *
425      * ```solidity
426      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
427      *     keccak256("Mail(address to,string contents)"),
428      *     mailTo,
429      *     keccak256(bytes(mailContents))
430      * )));
431      * address signer = ECDSA.recover(digest, signature);
432      * ```
433      */
434     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
435         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
436     }
437 }
438 
439 /**
440  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
441  *
442  * These functions can be used to verify that a message was signed by the holder
443  * of the private keys of a given address.
444  */
445 library ECDSA {
446     enum RecoverError {
447         NoError,
448         InvalidSignature,
449         InvalidSignatureLength,
450         InvalidSignatureS,
451         InvalidSignatureV
452     }
453 
454     function _throwError(RecoverError error) private pure {
455         if (error == RecoverError.NoError) {
456             return; // no error: do nothing
457         } else if (error == RecoverError.InvalidSignature) {
458             revert("ECDSA: invalid signature");
459         } else if (error == RecoverError.InvalidSignatureLength) {
460             revert("ECDSA: invalid signature length");
461         } else if (error == RecoverError.InvalidSignatureS) {
462             revert("ECDSA: invalid signature 's' value");
463         } else if (error == RecoverError.InvalidSignatureV) {
464             revert("ECDSA: invalid signature 'v' value");
465         }
466     }
467 
468     /**
469      * @dev Returns the address that signed a hashed message (`hash`) with
470      * `signature` or error string. This address can then be used for verification purposes.
471      *
472      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
473      * this function rejects them by requiring the `s` value to be in the lower
474      * half order, and the `v` value to be either 27 or 28.
475      *
476      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
477      * verification to be secure: it is possible to craft signatures that
478      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
479      * this is by receiving a hash of the original message (which may otherwise
480      * be too long), and then calling {toEthSignedMessageHash} on it.
481      *
482      * Documentation for signature generation:
483      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
484      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
485      *
486      * _Available since v4.3._
487      */
488     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
489         // Check the signature length
490         // - case 65: r,s,v signature (standard)
491         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
492         if (signature.length == 65) {
493             bytes32 r;
494             bytes32 s;
495             uint8 v;
496             // ecrecover takes the signature parameters, and the only way to get them
497             // currently is to use assembly.
498             assembly {
499                 r := mload(add(signature, 0x20))
500                 s := mload(add(signature, 0x40))
501                 v := byte(0, mload(add(signature, 0x60)))
502             }
503             return tryRecover(hash, v, r, s);
504         } else if (signature.length == 64) {
505             bytes32 r;
506             bytes32 vs;
507             // ecrecover takes the signature parameters, and the only way to get them
508             // currently is to use assembly.
509             assembly {
510                 r := mload(add(signature, 0x20))
511                 vs := mload(add(signature, 0x40))
512             }
513             return tryRecover(hash, r, vs);
514         } else {
515             return (address(0), RecoverError.InvalidSignatureLength);
516         }
517     }
518 
519     /**
520      * @dev Returns the address that signed a hashed message (`hash`) with
521      * `signature`. This address can then be used for verification purposes.
522      *
523      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
524      * this function rejects them by requiring the `s` value to be in the lower
525      * half order, and the `v` value to be either 27 or 28.
526      *
527      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
528      * verification to be secure: it is possible to craft signatures that
529      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
530      * this is by receiving a hash of the original message (which may otherwise
531      * be too long), and then calling {toEthSignedMessageHash} on it.
532      */
533     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
534         (address recovered, RecoverError error) = tryRecover(hash, signature);
535         _throwError(error);
536         return recovered;
537     }
538 
539     /**
540      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
541      *
542      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
543      *
544      * _Available since v4.3._
545      */
546     function tryRecover(
547         bytes32 hash,
548         bytes32 r,
549         bytes32 vs
550     ) internal pure returns (address, RecoverError) {
551         bytes32 s;
552         uint8 v;
553         assembly {
554             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
555             v := add(shr(255, vs), 27)
556         }
557         return tryRecover(hash, v, r, s);
558     }
559 
560     /**
561      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
562      *
563      * _Available since v4.2._
564      */
565     function recover(
566         bytes32 hash,
567         bytes32 r,
568         bytes32 vs
569     ) internal pure returns (address) {
570         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
571         _throwError(error);
572         return recovered;
573     }
574 
575     /**
576      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
577      * `r` and `s` signature fields separately.
578      *
579      * _Available since v4.3._
580      */
581     function tryRecover(
582         bytes32 hash,
583         uint8 v,
584         bytes32 r,
585         bytes32 s
586     ) internal pure returns (address, RecoverError) {
587         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
588         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
589         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
590         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
591         //
592         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
593         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
594         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
595         // these malleable signatures as well.
596         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
597             return (address(0), RecoverError.InvalidSignatureS);
598         }
599         if (v != 27 && v != 28) {
600             return (address(0), RecoverError.InvalidSignatureV);
601         }
602 
603         // If the signature is valid (and not malleable), return the signer address
604         address signer = ecrecover(hash, v, r, s);
605         if (signer == address(0)) {
606             return (address(0), RecoverError.InvalidSignature);
607         }
608 
609         return (signer, RecoverError.NoError);
610     }
611 
612     /**
613      * @dev Overload of {ECDSA-recover} that receives the `v`,
614      * `r` and `s` signature fields separately.
615      */
616     function recover(
617         bytes32 hash,
618         uint8 v,
619         bytes32 r,
620         bytes32 s
621     ) internal pure returns (address) {
622         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
623         _throwError(error);
624         return recovered;
625     }
626 
627     /**
628      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
629      * produces hash corresponding to the one signed with the
630      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
631      * JSON-RPC method as part of EIP-191.
632      *
633      * See {recover}.
634      */
635     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
636         // 32 is the length in bytes of hash,
637         // enforced by the type signature above
638         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
639     }
640 
641     /**
642      * @dev Returns an Ethereum Signed Typed Data, created from a
643      * `domainSeparator` and a `structHash`. This produces hash corresponding
644      * to the one signed with the
645      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
646      * JSON-RPC method as part of EIP-712.
647      *
648      * See {recover}.
649      */
650     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
651         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
652     }
653 }
654 
655 
656 /**
657  * @title Counters
658  * @author Matt Condon (@shrugs)
659  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
660  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
661  *
662  * Include with `using Counters for Counters.Counter;`
663  */
664 library Counters {
665     struct Counter {
666         // This variable should never be directly accessed by users of the library: interactions must be restricted to
667         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
668         // this feature: see https://github.com/ethereum/solidity/issues/4637
669         uint256 _value; // default: 0
670     }
671 
672     function current(Counter storage counter) internal view returns (uint256) {
673         return counter._value;
674     }
675 
676     function increment(Counter storage counter) internal {
677     unchecked {
678         counter._value += 1;
679     }
680     }
681 
682     function decrement(Counter storage counter) internal {
683         uint256 value = counter._value;
684         require(value > 0, "Counter: decrement overflow");
685     unchecked {
686         counter._value = value - 1;
687     }
688     }
689 
690     function reset(Counter storage counter) internal {
691         counter._value = 0;
692     }
693 }
694 
695 
696 /**
697  * @dev Provides information about the current execution context, including the
698  * sender of the transaction and its data. While these are generally available
699  * via msg.sender and msg.data, they should not be accessed in such a direct
700  * manner, since when dealing with meta-transactions the account sending and
701  * paying for execution may not be the actual sender (as far as an application
702  * is concerned).
703  *
704  * This contract is only required for intermediate, library-like contracts.
705  */
706 abstract contract Context {
707     function _msgSender() internal view virtual returns (address) {
708         return msg.sender;
709     }
710 
711     function _msgData() internal view virtual returns (bytes calldata) {
712         return msg.data;
713     }
714 }
715 
716 
717 /**
718  * @dev Contract module which provides a basic access control mechanism, where
719  * there is an account (an owner) that can be granted exclusive access to
720  * specific functions.
721  *
722  * By default, the owner account will be the one that deploys the contract. This
723  * can later be changed with {transferOwnership}.
724  *
725  * This module is used through inheritance. It will make available the modifier
726  * `onlyOwner`, which can be applied to your functions to restrict their use to
727  * the owner.
728  */
729 abstract contract Ownable is Context {
730     address private _owner;
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     /**
735      * @dev Initializes the contract setting the deployer as the initial owner.
736      */
737     constructor() {
738         _setOwner(_msgSender());
739     }
740 
741     /**
742      * @dev Returns the address of the current owner.
743      */
744     function owner() public view virtual returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than the owner.
750      */
751     modifier onlyOwner() {
752         require(owner() == _msgSender(), "Ownable: caller is not the owner");
753         _;
754     }
755 
756     /**
757      * @dev Leaves the contract without owner. It will not be possible to call
758      * `onlyOwner` functions anymore. Can only be called by the current owner.
759      *
760      * NOTE: Renouncing ownership will leave the contract without an owner,
761      * thereby removing any functionality that is only available to the owner.
762      */
763     function renounceOwnership() public virtual onlyOwner {
764         _setOwner(address(0));
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public virtual onlyOwner {
772         require(newOwner != address(0), "Ownable: new owner is the zero address");
773         _setOwner(newOwner);
774     }
775 
776     function _setOwner(address newOwner) private {
777         address oldOwner = _owner;
778         _owner = newOwner;
779         emit OwnershipTransferred(oldOwner, newOwner);
780     }
781 }
782 
783 /**
784  * @dev Interface of the ERC20 standard as defined in the EIP.
785  */
786 interface IERC20 {
787     /**
788      * @dev Returns the amount of tokens in existence.
789      */
790     function totalSupply() external view returns (uint256);
791 
792     /**
793      * @dev Returns the amount of tokens owned by `account`.
794      */
795     function balanceOf(address account) external view returns (uint256);
796 
797     /**
798      * @dev Moves `amount` tokens from the caller's account to `recipient`.
799      *
800      * Returns a boolean value indicating whether the operation succeeded.
801      *
802      * Emits a {Transfer} event.
803      */
804     function transfer(address recipient, uint256 amount) external returns (bool);
805 
806     /**
807      * @dev Returns the remaining number of tokens that `spender` will be
808      * allowed to spend on behalf of `owner` through {transferFrom}. This is
809      * zero by default.
810      *
811      * This value changes when {approve} or {transferFrom} are called.
812      */
813     function allowance(address owner, address spender) external view returns (uint256);
814 
815     /**
816      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
817      *
818      * Returns a boolean value indicating whether the operation succeeded.
819      *
820      * IMPORTANT: Beware that changing an allowance with this method brings the risk
821      * that someone may use both the old and the new allowance by unfortunate
822      * transaction ordering. One possible solution to mitigate this race
823      * condition is to first reduce the spender's allowance to 0 and set the
824      * desired value afterwards:
825      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
826      *
827      * Emits an {Approval} event.
828      */
829     function approve(address spender, uint256 amount) external returns (bool);
830 
831     /**
832      * @dev Moves `amount` tokens from `sender` to `recipient` using the
833      * allowance mechanism. `amount` is then deducted from the caller's
834      * allowance.
835      *
836      * Returns a boolean value indicating whether the operation succeeded.
837      *
838      * Emits a {Transfer} event.
839      */
840     function transferFrom(
841         address sender,
842         address recipient,
843         uint256 amount
844     ) external returns (bool);
845 
846     /**
847      * @dev Emitted when `value` tokens are moved from one account (`from`) to
848      * another (`to`).
849      *
850      * Note that `value` may be zero.
851      */
852     event Transfer(address indexed from, address indexed to, uint256 value);
853 
854     /**
855      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
856      * a call to {approve}. `value` is the new allowance.
857      */
858     event Approval(address indexed owner, address indexed spender, uint256 value);
859 }
860 /**
861  * @dev Interface for the optional metadata functions from the ERC20 standard.
862  *
863  * _Available since v4.1._
864  */
865 interface IERC20Metadata is IERC20 {
866     /**
867      * @dev Returns the name of the token.
868      */
869     function name() external view returns (string memory);
870 
871     /**
872      * @dev Returns the symbol of the token.
873      */
874     function symbol() external view returns (string memory);
875 
876     /**
877      * @dev Returns the decimals places of the token.
878      */
879     function decimals() external view returns (uint8);
880 }
881 
882 
883 /**
884  * @dev Implementation of the {IERC20} interface.
885  *
886  * This implementation is agnostic to the way tokens are created. This means
887  * that a supply mechanism has to be added in a derived contract using {_mint}.
888  * For a generic mechanism see {ERC20PresetMinterPauser}.
889  *
890  * TIP: For a detailed writeup see our guide
891  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
892  * to implement supply mechanisms].
893  *
894  * We have followed general OpenZeppelin Contracts guidelines: functions revert
895  * instead returning `false` on failure. This behavior is nonetheless
896  * conventional and does not conflict with the expectations of ERC20
897  * applications.
898  *
899  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
900  * This allows applications to reconstruct the allowance for all accounts just
901  * by listening to said events. Other implementations of the EIP may not emit
902  * these events, as it isn't required by the specification.
903  *
904  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
905  * functions have been added to mitigate the well-known issues around setting
906  * allowances. See {IERC20-approve}.
907  */
908 contract ERC20 is Context, IERC20, IERC20Metadata {
909     mapping(address => uint256) private _balances;
910 
911     mapping(address => mapping(address => uint256)) private _allowances;
912 
913     uint256 private _totalSupply;
914 
915     string private _name;
916     string private _symbol;
917 
918     /**
919      * @dev Sets the values for {name} and {symbol}.
920      *
921      * The default value of {decimals} is 18. To select a different value for
922      * {decimals} you should overload it.
923      *
924      * All two of these values are immutable: they can only be set once during
925      * construction.
926      */
927     constructor(string memory name_, string memory symbol_) {
928         _name = name_;
929         _symbol = symbol_;
930     }
931 
932     /**
933      * @dev Returns the name of the token.
934      */
935     function name() public view virtual override returns (string memory) {
936         return _name;
937     }
938 
939     /**
940      * @dev Returns the symbol of the token, usually a shorter version of the
941      * name.
942      */
943     function symbol() public view virtual override returns (string memory) {
944         return _symbol;
945     }
946 
947     /**
948      * @dev Returns the number of decimals used to get its user representation.
949      * For example, if `decimals` equals `2`, a balance of `505` tokens should
950      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
951      *
952      * Tokens usually opt for a value of 18, imitating the relationship between
953      * Ether and Wei. This is the value {ERC20} uses, unless this function is
954      * overridden;
955      *
956      * NOTE: This information is only used for _display_ purposes: it in
957      * no way affects any of the arithmetic of the contract, including
958      * {IERC20-balanceOf} and {IERC20-transfer}.
959      */
960     function decimals() public view virtual override returns (uint8) {
961         return 18;
962     }
963 
964     /**
965      * @dev See {IERC20-totalSupply}.
966      */
967     function totalSupply() public view virtual override returns (uint256) {
968         return _totalSupply;
969     }
970 
971     /**
972      * @dev See {IERC20-balanceOf}.
973      */
974     function balanceOf(address account) public view virtual override returns (uint256) {
975         return _balances[account];
976     }
977 
978     /**
979      * @dev See {IERC20-transfer}.
980      *
981      * Requirements:
982      *
983      * - `recipient` cannot be the zero address.
984      * - the caller must have a balance of at least `amount`.
985      */
986     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
987         _transfer(_msgSender(), recipient, amount);
988         return true;
989     }
990 
991     /**
992      * @dev See {IERC20-allowance}.
993      */
994     function allowance(address owner, address spender) public view virtual override returns (uint256) {
995         return _allowances[owner][spender];
996     }
997 
998     /**
999      * @dev See {IERC20-approve}.
1000      *
1001      * Requirements:
1002      *
1003      * - `spender` cannot be the zero address.
1004      */
1005     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1006         _approve(_msgSender(), spender, amount);
1007         return true;
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-transferFrom}.
1012      *
1013      * Emits an {Approval} event indicating the updated allowance. This is not
1014      * required by the EIP. See the note at the beginning of {ERC20}.
1015      *
1016      * Requirements:
1017      *
1018      * - `sender` and `recipient` cannot be the zero address.
1019      * - `sender` must have a balance of at least `amount`.
1020      * - the caller must have allowance for ``sender``'s tokens of at least
1021      * `amount`.
1022      */
1023     function transferFrom(
1024         address sender,
1025         address recipient,
1026         uint256 amount
1027     ) public virtual override returns (bool) {
1028         _transfer(sender, recipient, amount);
1029 
1030         uint256 currentAllowance = _allowances[sender][_msgSender()];
1031         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1032     unchecked {
1033         _approve(sender, _msgSender(), currentAllowance - amount);
1034     }
1035 
1036         return true;
1037     }
1038 
1039     /**
1040      * @dev Atomically increases the allowance granted to `spender` by the caller.
1041      *
1042      * This is an alternative to {approve} that can be used as a mitigation for
1043      * problems described in {IERC20-approve}.
1044      *
1045      * Emits an {Approval} event indicating the updated allowance.
1046      *
1047      * Requirements:
1048      *
1049      * - `spender` cannot be the zero address.
1050      */
1051     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1052         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1053         return true;
1054     }
1055 
1056     /**
1057      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1058      *
1059      * This is an alternative to {approve} that can be used as a mitigation for
1060      * problems described in {IERC20-approve}.
1061      *
1062      * Emits an {Approval} event indicating the updated allowance.
1063      *
1064      * Requirements:
1065      *
1066      * - `spender` cannot be the zero address.
1067      * - `spender` must have allowance for the caller of at least
1068      * `subtractedValue`.
1069      */
1070     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1071         uint256 currentAllowance = _allowances[_msgSender()][spender];
1072         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1073     unchecked {
1074         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1075     }
1076 
1077         return true;
1078     }
1079 
1080     /**
1081      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1082      *
1083      * This internal function is equivalent to {transfer}, and can be used to
1084      * e.g. implement automatic token fees, slashing mechanisms, etc.
1085      *
1086      * Emits a {Transfer} event.
1087      *
1088      * Requirements:
1089      *
1090      * - `sender` cannot be the zero address.
1091      * - `recipient` cannot be the zero address.
1092      * - `sender` must have a balance of at least `amount`.
1093      */
1094     function _transfer(
1095         address sender,
1096         address recipient,
1097         uint256 amount
1098     ) internal virtual {
1099         require(sender != address(0), "ERC20: transfer from the zero address");
1100         require(recipient != address(0), "ERC20: transfer to the zero address");
1101 
1102         _beforeTokenTransfer(sender, recipient, amount);
1103 
1104         uint256 senderBalance = _balances[sender];
1105         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1106     unchecked {
1107         _balances[sender] = senderBalance - amount;
1108     }
1109         _balances[recipient] += amount;
1110 
1111         emit Transfer(sender, recipient, amount);
1112 
1113         _afterTokenTransfer(sender, recipient, amount);
1114     }
1115 
1116     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1117      * the total supply.
1118      *
1119      * Emits a {Transfer} event with `from` set to the zero address.
1120      *
1121      * Requirements:
1122      *
1123      * - `account` cannot be the zero address.
1124      */
1125     function _mint(address account, uint256 amount) internal virtual {
1126         require(account != address(0), "ERC20: mint to the zero address");
1127 
1128         _beforeTokenTransfer(address(0), account, amount);
1129 
1130         _totalSupply += amount;
1131         _balances[account] += amount;
1132         emit Transfer(address(0), account, amount);
1133 
1134         _afterTokenTransfer(address(0), account, amount);
1135     }
1136 
1137     /**
1138      * @dev Destroys `amount` tokens from `account`, reducing the
1139      * total supply.
1140      *
1141      * Emits a {Transfer} event with `to` set to the zero address.
1142      *
1143      * Requirements:
1144      *
1145      * - `account` cannot be the zero address.
1146      * - `account` must have at least `amount` tokens.
1147      */
1148     function _burn(address account, uint256 amount) internal virtual {
1149         require(account != address(0), "ERC20: burn from the zero address");
1150 
1151         _beforeTokenTransfer(account, address(0), amount);
1152 
1153         uint256 accountBalance = _balances[account];
1154         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1155     unchecked {
1156         _balances[account] = accountBalance - amount;
1157     }
1158         _totalSupply -= amount;
1159 
1160         emit Transfer(account, address(0), amount);
1161 
1162         _afterTokenTransfer(account, address(0), amount);
1163     }
1164 
1165     /**
1166      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1167      *
1168      * This internal function is equivalent to `approve`, and can be used to
1169      * e.g. set automatic allowances for certain subsystems, etc.
1170      *
1171      * Emits an {Approval} event.
1172      *
1173      * Requirements:
1174      *
1175      * - `owner` cannot be the zero address.
1176      * - `spender` cannot be the zero address.
1177      */
1178     function _approve(
1179         address owner,
1180         address spender,
1181         uint256 amount
1182     ) internal virtual {
1183         require(owner != address(0), "ERC20: approve from the zero address");
1184         require(spender != address(0), "ERC20: approve to the zero address");
1185 
1186         _allowances[owner][spender] = amount;
1187         emit Approval(owner, spender, amount);
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before any transfer of tokens. This includes
1192      * minting and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1197      * will be transferred to `to`.
1198      * - when `from` is zero, `amount` tokens will be minted for `to`.
1199      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1200      * - `from` and `to` are never both zero.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _beforeTokenTransfer(
1205         address from,
1206         address to,
1207         uint256 amount
1208     ) internal virtual {}
1209 
1210     /**
1211      * @dev Hook that is called after any transfer of tokens. This includes
1212      * minting and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1217      * has been transferred to `to`.
1218      * - when `from` is zero, `amount` tokens have been minted for `to`.
1219      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1220      * - `from` and `to` are never both zero.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _afterTokenTransfer(
1225         address from,
1226         address to,
1227         uint256 amount
1228     ) internal virtual {}
1229 }
1230 
1231 
1232 /**
1233  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1234  * tokens and those that they have an allowance for, in a way that can be
1235  * recognized off-chain (via event analysis).
1236  */
1237 abstract contract ERC20Burnable is Context, ERC20 {
1238     /**
1239      * @dev Destroys `amount` tokens from the caller.
1240      *
1241      * See {ERC20-_burn}.
1242      */
1243     function burn(uint256 amount) public virtual {
1244         _burn(_msgSender(), amount);
1245     }
1246 
1247     /**
1248      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1249      * allowance.
1250      *
1251      * See {ERC20-_burn} and {ERC20-allowance}.
1252      *
1253      * Requirements:
1254      *
1255      * - the caller must have allowance for ``accounts``'s tokens of at least
1256      * `amount`.
1257      */
1258     function burnFrom(address account, uint256 amount) public virtual {
1259         uint256 currentAllowance = allowance(account, _msgSender());
1260         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1261     unchecked {
1262         _approve(account, _msgSender(), currentAllowance - amount);
1263     }
1264         _burn(account, amount);
1265     }
1266 }
1267 
1268 /**
1269  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1270  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1271  *
1272  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1273  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1274  * need to send a transaction, and thus is not required to hold Ether at all.
1275  *
1276  * _Available since v3.4._
1277  */
1278 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1279     using Counters for Counters.Counter;
1280 
1281     mapping(address => Counters.Counter) private _nonces;
1282 
1283     // solhint-disable-next-line var-name-mixedcase
1284     bytes32 private immutable _PERMIT_TYPEHASH =
1285     keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1286 
1287     /**
1288      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1289      *
1290      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1291      */
1292     constructor(string memory name) EIP712(name, "1") {}
1293 
1294     /**
1295      * @dev See {IERC20Permit-permit}.
1296      */
1297     function permit(
1298         address owner,
1299         address spender,
1300         uint256 value,
1301         uint256 deadline,
1302         uint8 v,
1303         bytes32 r,
1304         bytes32 s
1305     ) public virtual override {
1306         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1307 
1308         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1309 
1310         bytes32 hash = _hashTypedDataV4(structHash);
1311 
1312         address signer = ECDSA.recover(hash, v, r, s);
1313         require(signer == owner, "ERC20Permit: invalid signature");
1314 
1315         _approve(owner, spender, value);
1316     }
1317 
1318     /**
1319      * @dev See {IERC20Permit-nonces}.
1320      */
1321     function nonces(address owner) public view virtual override returns (uint256) {
1322         return _nonces[owner].current();
1323     }
1324 
1325     /**
1326      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1327      */
1328     // solhint-disable-next-line func-name-mixedcase
1329     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1330         return _domainSeparatorV4();
1331     }
1332 
1333     /**
1334      * @dev "Consume a nonce": return the current value and increment.
1335      *
1336      * _Available since v4.1._
1337      */
1338     function _useNonce(address owner) internal virtual returns (uint256 current) {
1339         Counters.Counter storage nonce = _nonces[owner];
1340         current = nonce.current();
1341         nonce.increment();
1342     }
1343 }
1344 
1345 
1346 /**
1347  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1348  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1349  *
1350  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1351  *
1352  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1353  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1354  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1355  *
1356  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1357  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1358  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1359  * will significantly increase the base gas cost of transfers.
1360  *
1361  * _Available since v4.2._
1362  */
1363 abstract contract ERC20Votes is ERC20Permit {
1364     struct Checkpoint {
1365         uint32 fromBlock;
1366         uint224 votes;
1367     }
1368 
1369     bytes32 private constant _DELEGATION_TYPEHASH =
1370     keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1371 
1372     mapping(address => address) private _delegates;
1373     mapping(address => Checkpoint[]) private _checkpoints;
1374     Checkpoint[] private _totalSupplyCheckpoints;
1375 
1376     /**
1377      * @dev Emitted when an account changes their delegate.
1378      */
1379     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1380 
1381     /**
1382      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1383      */
1384     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1385 
1386     /**
1387      * @dev Get the `pos`-th checkpoint for `account`.
1388      */
1389     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1390         return _checkpoints[account][pos];
1391     }
1392 
1393     /**
1394      * @dev Get number of checkpoints for `account`.
1395      */
1396     function numCheckpoints(address account) public view virtual returns (uint32) {
1397         return SafeCast.toUint32(_checkpoints[account].length);
1398     }
1399 
1400     /**
1401      * @dev Get the address `account` is currently delegating to.
1402      */
1403     function delegates(address account) public view virtual returns (address) {
1404         return _delegates[account];
1405     }
1406 
1407     /**
1408      * @dev Gets the current votes balance for `account`
1409      */
1410     function getVotes(address account) public view returns (uint256) {
1411         uint256 pos = _checkpoints[account].length;
1412         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1413     }
1414 
1415     /**
1416      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1417      *
1418      * Requirements:
1419      *
1420      * - `blockNumber` must have been already mined
1421      */
1422     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1423         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1424         return _checkpointsLookup(_checkpoints[account], blockNumber);
1425     }
1426 
1427     /**
1428      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1429      * It is but NOT the sum of all the delegated votes!
1430      *
1431      * Requirements:
1432      *
1433      * - `blockNumber` must have been already mined
1434      */
1435     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1436         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1437         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1438     }
1439 
1440     /**
1441      * @dev Lookup a value in a list of (sorted) checkpoints.
1442      */
1443     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1444         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1445         //
1446         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1447         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1448         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1449         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1450         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1451         // out of bounds (in which case we're looking too far in the past and the result is 0).
1452         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1453         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1454         // the same.
1455         uint256 high = ckpts.length;
1456         uint256 low = 0;
1457         while (low < high) {
1458             uint256 mid = Math.average(low, high);
1459             if (ckpts[mid].fromBlock > blockNumber) {
1460                 high = mid;
1461             } else {
1462                 low = mid + 1;
1463             }
1464         }
1465 
1466         return high == 0 ? 0 : ckpts[high - 1].votes;
1467     }
1468 
1469     /**
1470      * @dev Delegate votes from the sender to `delegatee`.
1471      */
1472     function delegate(address delegatee) public virtual {
1473         return _delegate(_msgSender(), delegatee);
1474     }
1475 
1476     /**
1477      * @dev Delegates votes from signer to `delegatee`
1478      */
1479     function delegateBySig(
1480         address delegatee,
1481         uint256 nonce,
1482         uint256 expiry,
1483         uint8 v,
1484         bytes32 r,
1485         bytes32 s
1486     ) public virtual {
1487         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1488         address signer = ECDSA.recover(
1489             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1490             v,
1491             r,
1492             s
1493         );
1494         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1495         return _delegate(signer, delegatee);
1496     }
1497 
1498     /**
1499      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1500      */
1501     function _maxSupply() internal view virtual returns (uint224) {
1502         return type(uint224).max;
1503     }
1504 
1505     /**
1506      * @dev Snapshots the totalSupply after it has been increased.
1507      */
1508     function _mint(address account, uint256 amount) internal virtual override {
1509         super._mint(account, amount);
1510         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1511 
1512         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1513     }
1514 
1515     /**
1516      * @dev Snapshots the totalSupply after it has been decreased.
1517      */
1518     function _burn(address account, uint256 amount) internal virtual override {
1519         super._burn(account, amount);
1520 
1521         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1522     }
1523 
1524     /**
1525      * @dev Move voting power when tokens are transferred.
1526      *
1527      * Emits a {DelegateVotesChanged} event.
1528      */
1529     function _afterTokenTransfer(
1530         address from,
1531         address to,
1532         uint256 amount
1533     ) internal virtual override {
1534         super._afterTokenTransfer(from, to, amount);
1535 
1536         _moveVotingPower(delegates(from), delegates(to), amount);
1537     }
1538 
1539     /**
1540      * @dev Change delegation for `delegator` to `delegatee`.
1541      *
1542      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1543      */
1544     function _delegate(address delegator, address delegatee) internal virtual {
1545         address currentDelegate = delegates(delegator);
1546         uint256 delegatorBalance = balanceOf(delegator);
1547         _delegates[delegator] = delegatee;
1548 
1549         emit DelegateChanged(delegator, currentDelegate, delegatee);
1550 
1551         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1552     }
1553 
1554     function _moveVotingPower(
1555         address src,
1556         address dst,
1557         uint256 amount
1558     ) private {
1559         if (src != dst && amount > 0) {
1560             if (src != address(0)) {
1561                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1562                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1563             }
1564 
1565             if (dst != address(0)) {
1566                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1567                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1568             }
1569         }
1570     }
1571 
1572     function _writeCheckpoint(
1573         Checkpoint[] storage ckpts,
1574         function(uint256, uint256) view returns (uint256) op,
1575         uint256 delta
1576     ) private returns (uint256 oldWeight, uint256 newWeight) {
1577         uint256 pos = ckpts.length;
1578         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1579         newWeight = op(oldWeight, delta);
1580 
1581         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1582             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1583         } else {
1584             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1585         }
1586     }
1587 
1588     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1589         return a + b;
1590     }
1591 
1592     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1593         return a - b;
1594     }
1595 }
1596 
1597 
1598 contract HumanDAO is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
1599     constructor() ERC20("humanDAO", "HDAO") ERC20Permit("humanDAO") {
1600         _mint(msg.sender, 1000 * 10 ** decimals());
1601     }
1602 
1603     function mint(address to, uint256 amount) public onlyOwner {
1604         _mint(to, amount);
1605     }
1606 
1607     // The following functions are overrides required by Solidity.
1608 
1609     function _afterTokenTransfer(address from, address to, uint256 amount)
1610     internal
1611     override(ERC20, ERC20Votes)
1612     {
1613         super._afterTokenTransfer(from, to, amount);
1614     }
1615 
1616     function _mint(address to, uint256 amount)
1617     internal
1618     override(ERC20, ERC20Votes)
1619     {
1620         super._mint(to, amount);
1621     }
1622 
1623     function _burn(address account, uint256 amount)
1624     internal
1625     override(ERC20, ERC20Votes)
1626     {
1627         super._burn(account, amount);
1628     }
1629 }