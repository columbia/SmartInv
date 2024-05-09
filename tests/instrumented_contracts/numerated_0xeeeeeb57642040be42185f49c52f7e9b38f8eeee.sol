1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts@4.5.0/utils/math/SafeCast.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
11  * checks.
12  *
13  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
14  * easily result in undesired exploitation or bugs, since developers usually
15  * assume that overflows raise errors. `SafeCast` restores this intuition by
16  * reverting the transaction when such an operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  *
21  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
22  * all math on `uint256` and `int256` and then downcasting.
23  */
24 library SafeCast {
25     /**
26      * @dev Returns the downcasted uint224 from uint256, reverting on
27      * overflow (when the input is greater than largest uint224).
28      *
29      * Counterpart to Solidity's `uint224` operator.
30      *
31      * Requirements:
32      *
33      * - input must fit into 224 bits
34      */
35     function toUint224(uint256 value) internal pure returns (uint224) {
36         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
37         return uint224(value);
38     }
39 
40     /**
41      * @dev Returns the downcasted uint128 from uint256, reverting on
42      * overflow (when the input is greater than largest uint128).
43      *
44      * Counterpart to Solidity's `uint128` operator.
45      *
46      * Requirements:
47      *
48      * - input must fit into 128 bits
49      */
50     function toUint128(uint256 value) internal pure returns (uint128) {
51         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
52         return uint128(value);
53     }
54 
55     /**
56      * @dev Returns the downcasted uint96 from uint256, reverting on
57      * overflow (when the input is greater than largest uint96).
58      *
59      * Counterpart to Solidity's `uint96` operator.
60      *
61      * Requirements:
62      *
63      * - input must fit into 96 bits
64      */
65     function toUint96(uint256 value) internal pure returns (uint96) {
66         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
67         return uint96(value);
68     }
69 
70     /**
71      * @dev Returns the downcasted uint64 from uint256, reverting on
72      * overflow (when the input is greater than largest uint64).
73      *
74      * Counterpart to Solidity's `uint64` operator.
75      *
76      * Requirements:
77      *
78      * - input must fit into 64 bits
79      */
80     function toUint64(uint256 value) internal pure returns (uint64) {
81         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
82         return uint64(value);
83     }
84 
85     /**
86      * @dev Returns the downcasted uint32 from uint256, reverting on
87      * overflow (when the input is greater than largest uint32).
88      *
89      * Counterpart to Solidity's `uint32` operator.
90      *
91      * Requirements:
92      *
93      * - input must fit into 32 bits
94      */
95     function toUint32(uint256 value) internal pure returns (uint32) {
96         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
97         return uint32(value);
98     }
99 
100     /**
101      * @dev Returns the downcasted uint16 from uint256, reverting on
102      * overflow (when the input is greater than largest uint16).
103      *
104      * Counterpart to Solidity's `uint16` operator.
105      *
106      * Requirements:
107      *
108      * - input must fit into 16 bits
109      */
110     function toUint16(uint256 value) internal pure returns (uint16) {
111         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
112         return uint16(value);
113     }
114 
115     /**
116      * @dev Returns the downcasted uint8 from uint256, reverting on
117      * overflow (when the input is greater than largest uint8).
118      *
119      * Counterpart to Solidity's `uint8` operator.
120      *
121      * Requirements:
122      *
123      * - input must fit into 8 bits.
124      */
125     function toUint8(uint256 value) internal pure returns (uint8) {
126         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
127         return uint8(value);
128     }
129 
130     /**
131      * @dev Converts a signed int256 into an unsigned uint256.
132      *
133      * Requirements:
134      *
135      * - input must be greater than or equal to 0.
136      */
137     function toUint256(int256 value) internal pure returns (uint256) {
138         require(value >= 0, "SafeCast: value must be positive");
139         return uint256(value);
140     }
141 
142     /**
143      * @dev Returns the downcasted int128 from int256, reverting on
144      * overflow (when the input is less than smallest int128 or
145      * greater than largest int128).
146      *
147      * Counterpart to Solidity's `int128` operator.
148      *
149      * Requirements:
150      *
151      * - input must fit into 128 bits
152      *
153      * _Available since v3.1._
154      */
155     function toInt128(int256 value) internal pure returns (int128) {
156         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
157         return int128(value);
158     }
159 
160     /**
161      * @dev Returns the downcasted int64 from int256, reverting on
162      * overflow (when the input is less than smallest int64 or
163      * greater than largest int64).
164      *
165      * Counterpart to Solidity's `int64` operator.
166      *
167      * Requirements:
168      *
169      * - input must fit into 64 bits
170      *
171      * _Available since v3.1._
172      */
173     function toInt64(int256 value) internal pure returns (int64) {
174         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
175         return int64(value);
176     }
177 
178     /**
179      * @dev Returns the downcasted int32 from int256, reverting on
180      * overflow (when the input is less than smallest int32 or
181      * greater than largest int32).
182      *
183      * Counterpart to Solidity's `int32` operator.
184      *
185      * Requirements:
186      *
187      * - input must fit into 32 bits
188      *
189      * _Available since v3.1._
190      */
191     function toInt32(int256 value) internal pure returns (int32) {
192         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
193         return int32(value);
194     }
195 
196     /**
197      * @dev Returns the downcasted int16 from int256, reverting on
198      * overflow (when the input is less than smallest int16 or
199      * greater than largest int16).
200      *
201      * Counterpart to Solidity's `int16` operator.
202      *
203      * Requirements:
204      *
205      * - input must fit into 16 bits
206      *
207      * _Available since v3.1._
208      */
209     function toInt16(int256 value) internal pure returns (int16) {
210         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
211         return int16(value);
212     }
213 
214     /**
215      * @dev Returns the downcasted int8 from int256, reverting on
216      * overflow (when the input is less than smallest int8 or
217      * greater than largest int8).
218      *
219      * Counterpart to Solidity's `int8` operator.
220      *
221      * Requirements:
222      *
223      * - input must fit into 8 bits.
224      *
225      * _Available since v3.1._
226      */
227     function toInt8(int256 value) internal pure returns (int8) {
228         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
229         return int8(value);
230     }
231 
232     /**
233      * @dev Converts an unsigned uint256 into a signed int256.
234      *
235      * Requirements:
236      *
237      * - input must be less than or equal to maxInt256.
238      */
239     function toInt256(uint256 value) internal pure returns (int256) {
240         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
241         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
242         return int256(value);
243     }
244 }
245 
246 // File: @openzeppelin/contracts@4.5.0/governance/utils/IVotes.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (governance/utils/IVotes.sol)
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Common interface for {ERC20Votes}, {ERC721Votes}, and other {Votes}-enabled contracts.
254  *
255  * _Available since v4.5._
256  */
257 interface IVotes {
258     /**
259      * @dev Emitted when an account changes their delegate.
260      */
261     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
262 
263     /**
264      * @dev Emitted when a token transfer or delegate change results in changes to a delegate's number of votes.
265      */
266     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
267 
268     /**
269      * @dev Returns the current amount of votes that `account` has.
270      */
271     function getVotes(address account) external view returns (uint256);
272 
273     /**
274      * @dev Returns the amount of votes that `account` had at the end of a past block (`blockNumber`).
275      */
276     function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
277 
278     /**
279      * @dev Returns the total supply of votes available at the end of a past block (`blockNumber`).
280      *
281      * NOTE: This value is the sum of all available votes, which is not necessarily the sum of all delegated votes.
282      * Votes that have not been delegated are still part of total supply, even though they would not participate in a
283      * vote.
284      */
285     function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
286 
287     /**
288      * @dev Returns the delegate that `account` has chosen.
289      */
290     function delegates(address account) external view returns (address);
291 
292     /**
293      * @dev Delegates votes from the sender to `delegatee`.
294      */
295     function delegate(address delegatee) external;
296 
297     /**
298      * @dev Delegates votes from signer to `delegatee`.
299      */
300     function delegateBySig(
301         address delegatee,
302         uint256 nonce,
303         uint256 expiry,
304         uint8 v,
305         bytes32 r,
306         bytes32 s
307     ) external;
308 }
309 
310 // File: @openzeppelin/contracts@4.5.0/utils/Strings.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev String operations.
319  */
320 library Strings {
321     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
322 
323     /**
324      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
325      */
326     function toString(uint256 value) internal pure returns (string memory) {
327         // Inspired by OraclizeAPI's implementation - MIT licence
328         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
329 
330         if (value == 0) {
331             return "0";
332         }
333         uint256 temp = value;
334         uint256 digits;
335         while (temp != 0) {
336             digits++;
337             temp /= 10;
338         }
339         bytes memory buffer = new bytes(digits);
340         while (value != 0) {
341             digits -= 1;
342             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
343             value /= 10;
344         }
345         return string(buffer);
346     }
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
350      */
351     function toHexString(uint256 value) internal pure returns (string memory) {
352         if (value == 0) {
353             return "0x00";
354         }
355         uint256 temp = value;
356         uint256 length = 0;
357         while (temp != 0) {
358             length++;
359             temp >>= 8;
360         }
361         return toHexString(value, length);
362     }
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
366      */
367     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
368         bytes memory buffer = new bytes(2 * length + 2);
369         buffer[0] = "0";
370         buffer[1] = "x";
371         for (uint256 i = 2 * length + 1; i > 1; --i) {
372             buffer[i] = _HEX_SYMBOLS[value & 0xf];
373             value >>= 4;
374         }
375         require(value == 0, "Strings: hex length insufficient");
376         return string(buffer);
377     }
378 }
379 
380 // File: @openzeppelin/contracts@4.5.0/utils/cryptography/ECDSA.sol
381 
382 
383 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
390  *
391  * These functions can be used to verify that a message was signed by the holder
392  * of the private keys of a given address.
393  */
394 library ECDSA {
395     enum RecoverError {
396         NoError,
397         InvalidSignature,
398         InvalidSignatureLength,
399         InvalidSignatureS,
400         InvalidSignatureV
401     }
402 
403     function _throwError(RecoverError error) private pure {
404         if (error == RecoverError.NoError) {
405             return; // no error: do nothing
406         } else if (error == RecoverError.InvalidSignature) {
407             revert("ECDSA: invalid signature");
408         } else if (error == RecoverError.InvalidSignatureLength) {
409             revert("ECDSA: invalid signature length");
410         } else if (error == RecoverError.InvalidSignatureS) {
411             revert("ECDSA: invalid signature 's' value");
412         } else if (error == RecoverError.InvalidSignatureV) {
413             revert("ECDSA: invalid signature 'v' value");
414         }
415     }
416 
417     /**
418      * @dev Returns the address that signed a hashed message (`hash`) with
419      * `signature` or error string. This address can then be used for verification purposes.
420      *
421      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
422      * this function rejects them by requiring the `s` value to be in the lower
423      * half order, and the `v` value to be either 27 or 28.
424      *
425      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
426      * verification to be secure: it is possible to craft signatures that
427      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
428      * this is by receiving a hash of the original message (which may otherwise
429      * be too long), and then calling {toEthSignedMessageHash} on it.
430      *
431      * Documentation for signature generation:
432      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
433      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
434      *
435      * _Available since v4.3._
436      */
437     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
438         // Check the signature length
439         // - case 65: r,s,v signature (standard)
440         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
441         if (signature.length == 65) {
442             bytes32 r;
443             bytes32 s;
444             uint8 v;
445             // ecrecover takes the signature parameters, and the only way to get them
446             // currently is to use assembly.
447             assembly {
448                 r := mload(add(signature, 0x20))
449                 s := mload(add(signature, 0x40))
450                 v := byte(0, mload(add(signature, 0x60)))
451             }
452             return tryRecover(hash, v, r, s);
453         } else if (signature.length == 64) {
454             bytes32 r;
455             bytes32 vs;
456             // ecrecover takes the signature parameters, and the only way to get them
457             // currently is to use assembly.
458             assembly {
459                 r := mload(add(signature, 0x20))
460                 vs := mload(add(signature, 0x40))
461             }
462             return tryRecover(hash, r, vs);
463         } else {
464             return (address(0), RecoverError.InvalidSignatureLength);
465         }
466     }
467 
468     /**
469      * @dev Returns the address that signed a hashed message (`hash`) with
470      * `signature`. This address can then be used for verification purposes.
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
481      */
482     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
483         (address recovered, RecoverError error) = tryRecover(hash, signature);
484         _throwError(error);
485         return recovered;
486     }
487 
488     /**
489      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
490      *
491      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
492      *
493      * _Available since v4.3._
494      */
495     function tryRecover(
496         bytes32 hash,
497         bytes32 r,
498         bytes32 vs
499     ) internal pure returns (address, RecoverError) {
500         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
501         uint8 v = uint8((uint256(vs) >> 255) + 27);
502         return tryRecover(hash, v, r, s);
503     }
504 
505     /**
506      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
507      *
508      * _Available since v4.2._
509      */
510     function recover(
511         bytes32 hash,
512         bytes32 r,
513         bytes32 vs
514     ) internal pure returns (address) {
515         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
516         _throwError(error);
517         return recovered;
518     }
519 
520     /**
521      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
522      * `r` and `s` signature fields separately.
523      *
524      * _Available since v4.3._
525      */
526     function tryRecover(
527         bytes32 hash,
528         uint8 v,
529         bytes32 r,
530         bytes32 s
531     ) internal pure returns (address, RecoverError) {
532         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
533         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
534         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
535         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
536         //
537         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
538         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
539         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
540         // these malleable signatures as well.
541         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
542             return (address(0), RecoverError.InvalidSignatureS);
543         }
544         if (v != 27 && v != 28) {
545             return (address(0), RecoverError.InvalidSignatureV);
546         }
547 
548         // If the signature is valid (and not malleable), return the signer address
549         address signer = ecrecover(hash, v, r, s);
550         if (signer == address(0)) {
551             return (address(0), RecoverError.InvalidSignature);
552         }
553 
554         return (signer, RecoverError.NoError);
555     }
556 
557     /**
558      * @dev Overload of {ECDSA-recover} that receives the `v`,
559      * `r` and `s` signature fields separately.
560      */
561     function recover(
562         bytes32 hash,
563         uint8 v,
564         bytes32 r,
565         bytes32 s
566     ) internal pure returns (address) {
567         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
568         _throwError(error);
569         return recovered;
570     }
571 
572     /**
573      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
574      * produces hash corresponding to the one signed with the
575      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
576      * JSON-RPC method as part of EIP-191.
577      *
578      * See {recover}.
579      */
580     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
581         // 32 is the length in bytes of hash,
582         // enforced by the type signature above
583         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
584     }
585 
586     /**
587      * @dev Returns an Ethereum Signed Message, created from `s`. This
588      * produces hash corresponding to the one signed with the
589      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
590      * JSON-RPC method as part of EIP-191.
591      *
592      * See {recover}.
593      */
594     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
595         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
596     }
597 
598     /**
599      * @dev Returns an Ethereum Signed Typed Data, created from a
600      * `domainSeparator` and a `structHash`. This produces hash corresponding
601      * to the one signed with the
602      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
603      * JSON-RPC method as part of EIP-712.
604      *
605      * See {recover}.
606      */
607     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
608         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
609     }
610 }
611 
612 // File: @openzeppelin/contracts@4.5.0/utils/cryptography/draft-EIP712.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
622  *
623  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
624  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
625  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
626  *
627  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
628  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
629  * ({_hashTypedDataV4}).
630  *
631  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
632  * the chain id to protect against replay attacks on an eventual fork of the chain.
633  *
634  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
635  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
636  *
637  * _Available since v3.4._
638  */
639 abstract contract EIP712 {
640     /* solhint-disable var-name-mixedcase */
641     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
642     // invalidate the cached domain separator if the chain id changes.
643     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
644     uint256 private immutable _CACHED_CHAIN_ID;
645     address private immutable _CACHED_THIS;
646 
647     bytes32 private immutable _HASHED_NAME;
648     bytes32 private immutable _HASHED_VERSION;
649     bytes32 private immutable _TYPE_HASH;
650 
651     /* solhint-enable var-name-mixedcase */
652 
653     /**
654      * @dev Initializes the domain separator and parameter caches.
655      *
656      * The meaning of `name` and `version` is specified in
657      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
658      *
659      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
660      * - `version`: the current major version of the signing domain.
661      *
662      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
663      * contract upgrade].
664      */
665     constructor(string memory name, string memory version) {
666         bytes32 hashedName = keccak256(bytes(name));
667         bytes32 hashedVersion = keccak256(bytes(version));
668         bytes32 typeHash = keccak256(
669             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
670         );
671         _HASHED_NAME = hashedName;
672         _HASHED_VERSION = hashedVersion;
673         _CACHED_CHAIN_ID = block.chainid;
674         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
675         _CACHED_THIS = address(this);
676         _TYPE_HASH = typeHash;
677     }
678 
679     /**
680      * @dev Returns the domain separator for the current chain.
681      */
682     function _domainSeparatorV4() internal view returns (bytes32) {
683         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
684             return _CACHED_DOMAIN_SEPARATOR;
685         } else {
686             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
687         }
688     }
689 
690     function _buildDomainSeparator(
691         bytes32 typeHash,
692         bytes32 nameHash,
693         bytes32 versionHash
694     ) private view returns (bytes32) {
695         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
696     }
697 
698     /**
699      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
700      * function returns the hash of the fully encoded EIP712 message for this domain.
701      *
702      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
703      *
704      * ```solidity
705      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
706      *     keccak256("Mail(address to,string contents)"),
707      *     mailTo,
708      *     keccak256(bytes(mailContents))
709      * )));
710      * address signer = ECDSA.recover(digest, signature);
711      * ```
712      */
713     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
714         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
715     }
716 }
717 
718 // File: @openzeppelin/contracts@4.5.0/token/ERC20/extensions/draft-IERC20Permit.sol
719 
720 
721 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 /**
726  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
727  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
728  *
729  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
730  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
731  * need to send a transaction, and thus is not required to hold Ether at all.
732  */
733 interface IERC20Permit {
734     /**
735      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
736      * given ``owner``'s signed approval.
737      *
738      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
739      * ordering also apply here.
740      *
741      * Emits an {Approval} event.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      * - `deadline` must be a timestamp in the future.
747      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
748      * over the EIP712-formatted function arguments.
749      * - the signature must use ``owner``'s current nonce (see {nonces}).
750      *
751      * For more information on the signature format, see the
752      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
753      * section].
754      */
755     function permit(
756         address owner,
757         address spender,
758         uint256 value,
759         uint256 deadline,
760         uint8 v,
761         bytes32 r,
762         bytes32 s
763     ) external;
764 
765     /**
766      * @dev Returns the current nonce for `owner`. This value must be
767      * included whenever a signature is generated for {permit}.
768      *
769      * Every successful call to {permit} increases ``owner``'s nonce by one. This
770      * prevents a signature from being used multiple times.
771      */
772     function nonces(address owner) external view returns (uint256);
773 
774     /**
775      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
776      */
777     // solhint-disable-next-line func-name-mixedcase
778     function DOMAIN_SEPARATOR() external view returns (bytes32);
779 }
780 
781 // File: @openzeppelin/contracts@4.5.0/utils/Counters.sol
782 
783 
784 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 /**
789  * @title Counters
790  * @author Matt Condon (@shrugs)
791  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
792  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
793  *
794  * Include with `using Counters for Counters.Counter;`
795  */
796 library Counters {
797     struct Counter {
798         // This variable should never be directly accessed by users of the library: interactions must be restricted to
799         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
800         // this feature: see https://github.com/ethereum/solidity/issues/4637
801         uint256 _value; // default: 0
802     }
803 
804     function current(Counter storage counter) internal view returns (uint256) {
805         return counter._value;
806     }
807 
808     function increment(Counter storage counter) internal {
809         unchecked {
810             counter._value += 1;
811         }
812     }
813 
814     function decrement(Counter storage counter) internal {
815         uint256 value = counter._value;
816         require(value > 0, "Counter: decrement overflow");
817         unchecked {
818             counter._value = value - 1;
819         }
820     }
821 
822     function reset(Counter storage counter) internal {
823         counter._value = 0;
824     }
825 }
826 
827 // File: @openzeppelin/contracts@4.5.0/utils/math/Math.sol
828 
829 
830 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
831 
832 pragma solidity ^0.8.0;
833 
834 /**
835  * @dev Standard math utilities missing in the Solidity language.
836  */
837 library Math {
838     /**
839      * @dev Returns the largest of two numbers.
840      */
841     function max(uint256 a, uint256 b) internal pure returns (uint256) {
842         return a >= b ? a : b;
843     }
844 
845     /**
846      * @dev Returns the smallest of two numbers.
847      */
848     function min(uint256 a, uint256 b) internal pure returns (uint256) {
849         return a < b ? a : b;
850     }
851 
852     /**
853      * @dev Returns the average of two numbers. The result is rounded towards
854      * zero.
855      */
856     function average(uint256 a, uint256 b) internal pure returns (uint256) {
857         // (a + b) / 2 can overflow.
858         return (a & b) + (a ^ b) / 2;
859     }
860 
861     /**
862      * @dev Returns the ceiling of the division of two numbers.
863      *
864      * This differs from standard division with `/` in that it rounds up instead
865      * of rounding down.
866      */
867     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
868         // (a + b - 1) / b can overflow on addition, so we distribute.
869         return a / b + (a % b == 0 ? 0 : 1);
870     }
871 }
872 
873 // File: @openzeppelin/contracts@4.5.0/utils/Arrays.sol
874 
875 
876 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
877 
878 pragma solidity ^0.8.0;
879 
880 
881 /**
882  * @dev Collection of functions related to array types.
883  */
884 library Arrays {
885     /**
886      * @dev Searches a sorted `array` and returns the first index that contains
887      * a value greater or equal to `element`. If no such index exists (i.e. all
888      * values in the array are strictly less than `element`), the array length is
889      * returned. Time complexity O(log n).
890      *
891      * `array` is expected to be sorted in ascending order, and to contain no
892      * repeated elements.
893      */
894     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
895         if (array.length == 0) {
896             return 0;
897         }
898 
899         uint256 low = 0;
900         uint256 high = array.length;
901 
902         while (low < high) {
903             uint256 mid = Math.average(low, high);
904 
905             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
906             // because Math.average rounds down (it does integer division with truncation).
907             if (array[mid] > element) {
908                 high = mid;
909             } else {
910                 low = mid + 1;
911             }
912         }
913 
914         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
915         if (low > 0 && array[low - 1] == element) {
916             return low - 1;
917         } else {
918             return low;
919         }
920     }
921 }
922 
923 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
924 
925 
926 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
927 
928 pragma solidity ^0.8.0;
929 
930 /**
931  * @dev Provides information about the current execution context, including the
932  * sender of the transaction and its data. While these are generally available
933  * via msg.sender and msg.data, they should not be accessed in such a direct
934  * manner, since when dealing with meta-transactions the account sending and
935  * paying for execution may not be the actual sender (as far as an application
936  * is concerned).
937  *
938  * This contract is only required for intermediate, library-like contracts.
939  */
940 abstract contract Context {
941     function _msgSender() internal view virtual returns (address) {
942         return msg.sender;
943     }
944 
945     function _msgData() internal view virtual returns (bytes calldata) {
946         return msg.data;
947     }
948 }
949 
950 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
951 
952 
953 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 
958 /**
959  * @dev Contract module which provides a basic access control mechanism, where
960  * there is an account (an owner) that can be granted exclusive access to
961  * specific functions.
962  *
963  * By default, the owner account will be the one that deploys the contract. This
964  * can later be changed with {transferOwnership}.
965  *
966  * This module is used through inheritance. It will make available the modifier
967  * `onlyOwner`, which can be applied to your functions to restrict their use to
968  * the owner.
969  */
970 abstract contract Ownable is Context {
971     address private _owner;
972 
973     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
974 
975     /**
976      * @dev Initializes the contract setting the deployer as the initial owner.
977      */
978     constructor() {
979         _transferOwnership(_msgSender());
980     }
981 
982     /**
983      * @dev Returns the address of the current owner.
984      */
985     function owner() public view virtual returns (address) {
986         return _owner;
987     }
988 
989     /**
990      * @dev Throws if called by any account other than the owner.
991      */
992     modifier onlyOwner() {
993         require(owner() == _msgSender(), "Ownable: caller is not the owner");
994         _;
995     }
996 
997     /**
998      * @dev Leaves the contract without owner. It will not be possible to call
999      * `onlyOwner` functions anymore. Can only be called by the current owner.
1000      *
1001      * NOTE: Renouncing ownership will leave the contract without an owner,
1002      * thereby removing any functionality that is only available to the owner.
1003      */
1004     function renounceOwnership() public virtual onlyOwner {
1005         _transferOwnership(address(0));
1006     }
1007 
1008     /**
1009      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1010      * Can only be called by the current owner.
1011      */
1012     function transferOwnership(address newOwner) public virtual onlyOwner {
1013         require(newOwner != address(0), "Ownable: new owner is the zero address");
1014         _transferOwnership(newOwner);
1015     }
1016 
1017     /**
1018      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1019      * Internal function without access restriction.
1020      */
1021     function _transferOwnership(address newOwner) internal virtual {
1022         address oldOwner = _owner;
1023         _owner = newOwner;
1024         emit OwnershipTransferred(oldOwner, newOwner);
1025     }
1026 }
1027 
1028 // File: @openzeppelin/contracts@4.5.0/token/ERC20/IERC20.sol
1029 
1030 
1031 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 /**
1036  * @dev Interface of the ERC20 standard as defined in the EIP.
1037  */
1038 interface IERC20 {
1039     /**
1040      * @dev Returns the amount of tokens in existence.
1041      */
1042     function totalSupply() external view returns (uint256);
1043 
1044     /**
1045      * @dev Returns the amount of tokens owned by `account`.
1046      */
1047     function balanceOf(address account) external view returns (uint256);
1048 
1049     /**
1050      * @dev Moves `amount` tokens from the caller's account to `to`.
1051      *
1052      * Returns a boolean value indicating whether the operation succeeded.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function transfer(address to, uint256 amount) external returns (bool);
1057 
1058     /**
1059      * @dev Returns the remaining number of tokens that `spender` will be
1060      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1061      * zero by default.
1062      *
1063      * This value changes when {approve} or {transferFrom} are called.
1064      */
1065     function allowance(address owner, address spender) external view returns (uint256);
1066 
1067     /**
1068      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1069      *
1070      * Returns a boolean value indicating whether the operation succeeded.
1071      *
1072      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1073      * that someone may use both the old and the new allowance by unfortunate
1074      * transaction ordering. One possible solution to mitigate this race
1075      * condition is to first reduce the spender's allowance to 0 and set the
1076      * desired value afterwards:
1077      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1078      *
1079      * Emits an {Approval} event.
1080      */
1081     function approve(address spender, uint256 amount) external returns (bool);
1082 
1083     /**
1084      * @dev Moves `amount` tokens from `from` to `to` using the
1085      * allowance mechanism. `amount` is then deducted from the caller's
1086      * allowance.
1087      *
1088      * Returns a boolean value indicating whether the operation succeeded.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 amount
1096     ) external returns (bool);
1097 
1098     /**
1099      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1100      * another (`to`).
1101      *
1102      * Note that `value` may be zero.
1103      */
1104     event Transfer(address indexed from, address indexed to, uint256 value);
1105 
1106     /**
1107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1108      * a call to {approve}. `value` is the new allowance.
1109      */
1110     event Approval(address indexed owner, address indexed spender, uint256 value);
1111 }
1112 
1113 // File: @openzeppelin/contracts@4.5.0/token/ERC20/extensions/IERC20Metadata.sol
1114 
1115 
1116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 /**
1122  * @dev Interface for the optional metadata functions from the ERC20 standard.
1123  *
1124  * _Available since v4.1._
1125  */
1126 interface IERC20Metadata is IERC20 {
1127     /**
1128      * @dev Returns the name of the token.
1129      */
1130     function name() external view returns (string memory);
1131 
1132     /**
1133      * @dev Returns the symbol of the token.
1134      */
1135     function symbol() external view returns (string memory);
1136 
1137     /**
1138      * @dev Returns the decimals places of the token.
1139      */
1140     function decimals() external view returns (uint8);
1141 }
1142 
1143 // File: @openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol
1144 
1145 
1146 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 
1152 
1153 /**
1154  * @dev Implementation of the {IERC20} interface.
1155  *
1156  * This implementation is agnostic to the way tokens are created. This means
1157  * that a supply mechanism has to be added in a derived contract using {_mint}.
1158  * For a generic mechanism see {ERC20PresetMinterPauser}.
1159  *
1160  * TIP: For a detailed writeup see our guide
1161  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1162  * to implement supply mechanisms].
1163  *
1164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1165  * instead returning `false` on failure. This behavior is nonetheless
1166  * conventional and does not conflict with the expectations of ERC20
1167  * applications.
1168  *
1169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1170  * This allows applications to reconstruct the allowance for all accounts just
1171  * by listening to said events. Other implementations of the EIP may not emit
1172  * these events, as it isn't required by the specification.
1173  *
1174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1175  * functions have been added to mitigate the well-known issues around setting
1176  * allowances. See {IERC20-approve}.
1177  */
1178 contract ERC20 is Context, IERC20, IERC20Metadata {
1179     mapping(address => uint256) private _balances;
1180 
1181     mapping(address => mapping(address => uint256)) private _allowances;
1182 
1183     uint256 private _totalSupply;
1184 
1185     string private _name;
1186     string private _symbol;
1187 
1188     /**
1189      * @dev Sets the values for {name} and {symbol}.
1190      *
1191      * The default value of {decimals} is 18. To select a different value for
1192      * {decimals} you should overload it.
1193      *
1194      * All two of these values are immutable: they can only be set once during
1195      * construction.
1196      */
1197     constructor(string memory name_, string memory symbol_) {
1198         _name = name_;
1199         _symbol = symbol_;
1200     }
1201 
1202     /**
1203      * @dev Returns the name of the token.
1204      */
1205     function name() public view virtual override returns (string memory) {
1206         return _name;
1207     }
1208 
1209     /**
1210      * @dev Returns the symbol of the token, usually a shorter version of the
1211      * name.
1212      */
1213     function symbol() public view virtual override returns (string memory) {
1214         return _symbol;
1215     }
1216 
1217     /**
1218      * @dev Returns the number of decimals used to get its user representation.
1219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1221      *
1222      * Tokens usually opt for a value of 18, imitating the relationship between
1223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1224      * overridden;
1225      *
1226      * NOTE: This information is only used for _display_ purposes: it in
1227      * no way affects any of the arithmetic of the contract, including
1228      * {IERC20-balanceOf} and {IERC20-transfer}.
1229      */
1230     function decimals() public view virtual override returns (uint8) {
1231         return 18;
1232     }
1233 
1234     /**
1235      * @dev See {IERC20-totalSupply}.
1236      */
1237     function totalSupply() public view virtual override returns (uint256) {
1238         return _totalSupply;
1239     }
1240 
1241     /**
1242      * @dev See {IERC20-balanceOf}.
1243      */
1244     function balanceOf(address account) public view virtual override returns (uint256) {
1245         return _balances[account];
1246     }
1247 
1248     /**
1249      * @dev See {IERC20-transfer}.
1250      *
1251      * Requirements:
1252      *
1253      * - `to` cannot be the zero address.
1254      * - the caller must have a balance of at least `amount`.
1255      */
1256     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1257         address owner = _msgSender();
1258         _transfer(owner, to, amount);
1259         return true;
1260     }
1261 
1262     /**
1263      * @dev See {IERC20-allowance}.
1264      */
1265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1266         return _allowances[owner][spender];
1267     }
1268 
1269     /**
1270      * @dev See {IERC20-approve}.
1271      *
1272      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1273      * `transferFrom`. This is semantically equivalent to an infinite approval.
1274      *
1275      * Requirements:
1276      *
1277      * - `spender` cannot be the zero address.
1278      */
1279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1280         address owner = _msgSender();
1281         _approve(owner, spender, amount);
1282         return true;
1283     }
1284 
1285     /**
1286      * @dev See {IERC20-transferFrom}.
1287      *
1288      * Emits an {Approval} event indicating the updated allowance. This is not
1289      * required by the EIP. See the note at the beginning of {ERC20}.
1290      *
1291      * NOTE: Does not update the allowance if the current allowance
1292      * is the maximum `uint256`.
1293      *
1294      * Requirements:
1295      *
1296      * - `from` and `to` cannot be the zero address.
1297      * - `from` must have a balance of at least `amount`.
1298      * - the caller must have allowance for ``from``'s tokens of at least
1299      * `amount`.
1300      */
1301     function transferFrom(
1302         address from,
1303         address to,
1304         uint256 amount
1305     ) public virtual override returns (bool) {
1306         address spender = _msgSender();
1307         _spendAllowance(from, spender, amount);
1308         _transfer(from, to, amount);
1309         return true;
1310     }
1311 
1312     /**
1313      * @dev Atomically increases the allowance granted to `spender` by the caller.
1314      *
1315      * This is an alternative to {approve} that can be used as a mitigation for
1316      * problems described in {IERC20-approve}.
1317      *
1318      * Emits an {Approval} event indicating the updated allowance.
1319      *
1320      * Requirements:
1321      *
1322      * - `spender` cannot be the zero address.
1323      */
1324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1325         address owner = _msgSender();
1326         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1327         return true;
1328     }
1329 
1330     /**
1331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1332      *
1333      * This is an alternative to {approve} that can be used as a mitigation for
1334      * problems described in {IERC20-approve}.
1335      *
1336      * Emits an {Approval} event indicating the updated allowance.
1337      *
1338      * Requirements:
1339      *
1340      * - `spender` cannot be the zero address.
1341      * - `spender` must have allowance for the caller of at least
1342      * `subtractedValue`.
1343      */
1344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1345         address owner = _msgSender();
1346         uint256 currentAllowance = _allowances[owner][spender];
1347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1348         unchecked {
1349             _approve(owner, spender, currentAllowance - subtractedValue);
1350         }
1351 
1352         return true;
1353     }
1354 
1355     /**
1356      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1357      *
1358      * This internal function is equivalent to {transfer}, and can be used to
1359      * e.g. implement automatic token fees, slashing mechanisms, etc.
1360      *
1361      * Emits a {Transfer} event.
1362      *
1363      * Requirements:
1364      *
1365      * - `from` cannot be the zero address.
1366      * - `to` cannot be the zero address.
1367      * - `from` must have a balance of at least `amount`.
1368      */
1369     function _transfer(
1370         address from,
1371         address to,
1372         uint256 amount
1373     ) internal virtual {
1374         require(from != address(0), "ERC20: transfer from the zero address");
1375         require(to != address(0), "ERC20: transfer to the zero address");
1376 
1377         _beforeTokenTransfer(from, to, amount);
1378 
1379         uint256 fromBalance = _balances[from];
1380         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1381         unchecked {
1382             _balances[from] = fromBalance - amount;
1383         }
1384         _balances[to] += amount;
1385 
1386         emit Transfer(from, to, amount);
1387 
1388         _afterTokenTransfer(from, to, amount);
1389     }
1390 
1391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1392      * the total supply.
1393      *
1394      * Emits a {Transfer} event with `from` set to the zero address.
1395      *
1396      * Requirements:
1397      *
1398      * - `account` cannot be the zero address.
1399      */
1400     function _mint(address account, uint256 amount) internal virtual {
1401         require(account != address(0), "ERC20: mint to the zero address");
1402 
1403         _beforeTokenTransfer(address(0), account, amount);
1404 
1405         _totalSupply += amount;
1406         _balances[account] += amount;
1407         emit Transfer(address(0), account, amount);
1408 
1409         _afterTokenTransfer(address(0), account, amount);
1410     }
1411 
1412     /**
1413      * @dev Destroys `amount` tokens from `account`, reducing the
1414      * total supply.
1415      *
1416      * Emits a {Transfer} event with `to` set to the zero address.
1417      *
1418      * Requirements:
1419      *
1420      * - `account` cannot be the zero address.
1421      * - `account` must have at least `amount` tokens.
1422      */
1423     function _burn(address account, uint256 amount) internal virtual {
1424         require(account != address(0), "ERC20: burn from the zero address");
1425 
1426         _beforeTokenTransfer(account, address(0), amount);
1427 
1428         uint256 accountBalance = _balances[account];
1429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1430         unchecked {
1431             _balances[account] = accountBalance - amount;
1432         }
1433         _totalSupply -= amount;
1434 
1435         emit Transfer(account, address(0), amount);
1436 
1437         _afterTokenTransfer(account, address(0), amount);
1438     }
1439 
1440     /**
1441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1442      *
1443      * This internal function is equivalent to `approve`, and can be used to
1444      * e.g. set automatic allowances for certain subsystems, etc.
1445      *
1446      * Emits an {Approval} event.
1447      *
1448      * Requirements:
1449      *
1450      * - `owner` cannot be the zero address.
1451      * - `spender` cannot be the zero address.
1452      */
1453     function _approve(
1454         address owner,
1455         address spender,
1456         uint256 amount
1457     ) internal virtual {
1458         require(owner != address(0), "ERC20: approve from the zero address");
1459         require(spender != address(0), "ERC20: approve to the zero address");
1460 
1461         _allowances[owner][spender] = amount;
1462         emit Approval(owner, spender, amount);
1463     }
1464 
1465     /**
1466      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1467      *
1468      * Does not update the allowance amount in case of infinite allowance.
1469      * Revert if not enough allowance is available.
1470      *
1471      * Might emit an {Approval} event.
1472      */
1473     function _spendAllowance(
1474         address owner,
1475         address spender,
1476         uint256 amount
1477     ) internal virtual {
1478         uint256 currentAllowance = allowance(owner, spender);
1479         if (currentAllowance != type(uint256).max) {
1480             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1481             unchecked {
1482                 _approve(owner, spender, currentAllowance - amount);
1483             }
1484         }
1485     }
1486 
1487     /**
1488      * @dev Hook that is called before any transfer of tokens. This includes
1489      * minting and burning.
1490      *
1491      * Calling conditions:
1492      *
1493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1494      * will be transferred to `to`.
1495      * - when `from` is zero, `amount` tokens will be minted for `to`.
1496      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1497      * - `from` and `to` are never both zero.
1498      *
1499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1500      */
1501     function _beforeTokenTransfer(
1502         address from,
1503         address to,
1504         uint256 amount
1505     ) internal virtual {}
1506 
1507     /**
1508      * @dev Hook that is called after any transfer of tokens. This includes
1509      * minting and burning.
1510      *
1511      * Calling conditions:
1512      *
1513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1514      * has been transferred to `to`.
1515      * - when `from` is zero, `amount` tokens have been minted for `to`.
1516      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1517      * - `from` and `to` are never both zero.
1518      *
1519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1520      */
1521     function _afterTokenTransfer(
1522         address from,
1523         address to,
1524         uint256 amount
1525     ) internal virtual {}
1526 }
1527 
1528 // File: @openzeppelin/contracts@4.5.0/token/ERC20/extensions/draft-ERC20Permit.sol
1529 
1530 
1531 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1532 
1533 pragma solidity ^0.8.0;
1534 
1535 
1536 
1537 
1538 
1539 
1540 /**
1541  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1542  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1543  *
1544  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1545  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1546  * need to send a transaction, and thus is not required to hold Ether at all.
1547  *
1548  * _Available since v3.4._
1549  */
1550 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1551     using Counters for Counters.Counter;
1552 
1553     mapping(address => Counters.Counter) private _nonces;
1554 
1555     // solhint-disable-next-line var-name-mixedcase
1556     bytes32 private immutable _PERMIT_TYPEHASH =
1557         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1558 
1559     /**
1560      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1561      *
1562      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1563      */
1564     constructor(string memory name) EIP712(name, "1") {}
1565 
1566     /**
1567      * @dev See {IERC20Permit-permit}.
1568      */
1569     function permit(
1570         address owner,
1571         address spender,
1572         uint256 value,
1573         uint256 deadline,
1574         uint8 v,
1575         bytes32 r,
1576         bytes32 s
1577     ) public virtual override {
1578         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1579 
1580         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1581 
1582         bytes32 hash = _hashTypedDataV4(structHash);
1583 
1584         address signer = ECDSA.recover(hash, v, r, s);
1585         require(signer == owner, "ERC20Permit: invalid signature");
1586 
1587         _approve(owner, spender, value);
1588     }
1589 
1590     /**
1591      * @dev See {IERC20Permit-nonces}.
1592      */
1593     function nonces(address owner) public view virtual override returns (uint256) {
1594         return _nonces[owner].current();
1595     }
1596 
1597     /**
1598      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1599      */
1600     // solhint-disable-next-line func-name-mixedcase
1601     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1602         return _domainSeparatorV4();
1603     }
1604 
1605     /**
1606      * @dev "Consume a nonce": return the current value and increment.
1607      *
1608      * _Available since v4.1._
1609      */
1610     function _useNonce(address owner) internal virtual returns (uint256 current) {
1611         Counters.Counter storage nonce = _nonces[owner];
1612         current = nonce.current();
1613         nonce.increment();
1614     }
1615 }
1616 
1617 // File: @openzeppelin/contracts@4.5.0/token/ERC20/extensions/ERC20Votes.sol
1618 
1619 
1620 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Votes.sol)
1621 
1622 pragma solidity ^0.8.0;
1623 
1624 
1625 
1626 
1627 
1628 
1629 /**
1630  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1631  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1632  *
1633  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1634  *
1635  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1636  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1637  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1638  *
1639  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1640  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1641  *
1642  * _Available since v4.2._
1643  */
1644 abstract contract ERC20Votes is IVotes, ERC20Permit {
1645     struct Checkpoint {
1646         uint32 fromBlock;
1647         uint224 votes;
1648     }
1649 
1650     bytes32 private constant _DELEGATION_TYPEHASH =
1651         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1652 
1653     mapping(address => address) private _delegates;
1654     mapping(address => Checkpoint[]) private _checkpoints;
1655     Checkpoint[] private _totalSupplyCheckpoints;
1656 
1657     /**
1658      * @dev Get the `pos`-th checkpoint for `account`.
1659      */
1660     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1661         return _checkpoints[account][pos];
1662     }
1663 
1664     /**
1665      * @dev Get number of checkpoints for `account`.
1666      */
1667     function numCheckpoints(address account) public view virtual returns (uint32) {
1668         return SafeCast.toUint32(_checkpoints[account].length);
1669     }
1670 
1671     /**
1672      * @dev Get the address `account` is currently delegating to.
1673      */
1674     function delegates(address account) public view virtual override returns (address) {
1675         return _delegates[account];
1676     }
1677 
1678     /**
1679      * @dev Gets the current votes balance for `account`
1680      */
1681     function getVotes(address account) public view virtual override returns (uint256) {
1682         uint256 pos = _checkpoints[account].length;
1683         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1684     }
1685 
1686     /**
1687      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1688      *
1689      * Requirements:
1690      *
1691      * - `blockNumber` must have been already mined
1692      */
1693     function getPastVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
1694         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1695         return _checkpointsLookup(_checkpoints[account], blockNumber);
1696     }
1697 
1698     /**
1699      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1700      * It is but NOT the sum of all the delegated votes!
1701      *
1702      * Requirements:
1703      *
1704      * - `blockNumber` must have been already mined
1705      */
1706     function getPastTotalSupply(uint256 blockNumber) public view virtual override returns (uint256) {
1707         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1708         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1709     }
1710 
1711     /**
1712      * @dev Lookup a value in a list of (sorted) checkpoints.
1713      */
1714     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1715         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1716         //
1717         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1718         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1719         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1720         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1721         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1722         // out of bounds (in which case we're looking too far in the past and the result is 0).
1723         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1724         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1725         // the same.
1726         uint256 high = ckpts.length;
1727         uint256 low = 0;
1728         while (low < high) {
1729             uint256 mid = Math.average(low, high);
1730             if (ckpts[mid].fromBlock > blockNumber) {
1731                 high = mid;
1732             } else {
1733                 low = mid + 1;
1734             }
1735         }
1736 
1737         return high == 0 ? 0 : ckpts[high - 1].votes;
1738     }
1739 
1740     /**
1741      * @dev Delegate votes from the sender to `delegatee`.
1742      */
1743     function delegate(address delegatee) public virtual override {
1744         _delegate(_msgSender(), delegatee);
1745     }
1746 
1747     /**
1748      * @dev Delegates votes from signer to `delegatee`
1749      */
1750     function delegateBySig(
1751         address delegatee,
1752         uint256 nonce,
1753         uint256 expiry,
1754         uint8 v,
1755         bytes32 r,
1756         bytes32 s
1757     ) public virtual override {
1758         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1759         address signer = ECDSA.recover(
1760             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1761             v,
1762             r,
1763             s
1764         );
1765         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1766         _delegate(signer, delegatee);
1767     }
1768 
1769     /**
1770      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1771      */
1772     function _maxSupply() internal view virtual returns (uint224) {
1773         return type(uint224).max;
1774     }
1775 
1776     /**
1777      * @dev Snapshots the totalSupply after it has been increased.
1778      */
1779     function _mint(address account, uint256 amount) internal virtual override {
1780         super._mint(account, amount);
1781         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1782 
1783         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1784     }
1785 
1786     /**
1787      * @dev Snapshots the totalSupply after it has been decreased.
1788      */
1789     function _burn(address account, uint256 amount) internal virtual override {
1790         super._burn(account, amount);
1791 
1792         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1793     }
1794 
1795     /**
1796      * @dev Move voting power when tokens are transferred.
1797      *
1798      * Emits a {DelegateVotesChanged} event.
1799      */
1800     function _afterTokenTransfer(
1801         address from,
1802         address to,
1803         uint256 amount
1804     ) internal virtual override {
1805         super._afterTokenTransfer(from, to, amount);
1806 
1807         _moveVotingPower(delegates(from), delegates(to), amount);
1808     }
1809 
1810     /**
1811      * @dev Change delegation for `delegator` to `delegatee`.
1812      *
1813      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1814      */
1815     function _delegate(address delegator, address delegatee) internal virtual {
1816         address currentDelegate = delegates(delegator);
1817         uint256 delegatorBalance = balanceOf(delegator);
1818         _delegates[delegator] = delegatee;
1819 
1820         emit DelegateChanged(delegator, currentDelegate, delegatee);
1821 
1822         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1823     }
1824 
1825     function _moveVotingPower(
1826         address src,
1827         address dst,
1828         uint256 amount
1829     ) private {
1830         if (src != dst && amount > 0) {
1831             if (src != address(0)) {
1832                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1833                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1834             }
1835 
1836             if (dst != address(0)) {
1837                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1838                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1839             }
1840         }
1841     }
1842 
1843     function _writeCheckpoint(
1844         Checkpoint[] storage ckpts,
1845         function(uint256, uint256) view returns (uint256) op,
1846         uint256 delta
1847     ) private returns (uint256 oldWeight, uint256 newWeight) {
1848         uint256 pos = ckpts.length;
1849         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1850         newWeight = op(oldWeight, delta);
1851 
1852         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1853             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1854         } else {
1855             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1856         }
1857     }
1858 
1859     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1860         return a + b;
1861     }
1862 
1863     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1864         return a - b;
1865     }
1866 }
1867 
1868 // File: @openzeppelin/contracts@4.5.0/token/ERC20/extensions/ERC20Snapshot.sol
1869 
1870 
1871 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
1872 
1873 pragma solidity ^0.8.0;
1874 
1875 
1876 
1877 
1878 /**
1879  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1880  * total supply at the time are recorded for later access.
1881  *
1882  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1883  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1884  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1885  * used to create an efficient ERC20 forking mechanism.
1886  *
1887  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1888  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1889  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1890  * and the account address.
1891  *
1892  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1893  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
1894  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1895  *
1896  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1897  * alternative consider {ERC20Votes}.
1898  *
1899  * ==== Gas Costs
1900  *
1901  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1902  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1903  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1904  *
1905  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1906  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1907  * transfers will have normal cost until the next snapshot, and so on.
1908  */
1909 
1910 abstract contract ERC20Snapshot is ERC20 {
1911     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1912     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1913 
1914     using Arrays for uint256[];
1915     using Counters for Counters.Counter;
1916 
1917     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1918     // Snapshot struct, but that would impede usage of functions that work on an array.
1919     struct Snapshots {
1920         uint256[] ids;
1921         uint256[] values;
1922     }
1923 
1924     mapping(address => Snapshots) private _accountBalanceSnapshots;
1925     Snapshots private _totalSupplySnapshots;
1926 
1927     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1928     Counters.Counter private _currentSnapshotId;
1929 
1930     /**
1931      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1932      */
1933     event Snapshot(uint256 id);
1934 
1935     /**
1936      * @dev Creates a new snapshot and returns its snapshot id.
1937      *
1938      * Emits a {Snapshot} event that contains the same id.
1939      *
1940      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1941      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1942      *
1943      * [WARNING]
1944      * ====
1945      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1946      * you must consider that it can potentially be used by attackers in two ways.
1947      *
1948      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1949      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1950      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1951      * section above.
1952      *
1953      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1954      * ====
1955      */
1956     function _snapshot() internal virtual returns (uint256) {
1957         _currentSnapshotId.increment();
1958 
1959         uint256 currentId = _getCurrentSnapshotId();
1960         emit Snapshot(currentId);
1961         return currentId;
1962     }
1963 
1964     /**
1965      * @dev Get the current snapshotId
1966      */
1967     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1968         return _currentSnapshotId.current();
1969     }
1970 
1971     /**
1972      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1973      */
1974     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1975         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1976 
1977         return snapshotted ? value : balanceOf(account);
1978     }
1979 
1980     /**
1981      * @dev Retrieves the total supply at the time `snapshotId` was created.
1982      */
1983     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1984         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1985 
1986         return snapshotted ? value : totalSupply();
1987     }
1988 
1989     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1990     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1991     function _beforeTokenTransfer(
1992         address from,
1993         address to,
1994         uint256 amount
1995     ) internal virtual override {
1996         super._beforeTokenTransfer(from, to, amount);
1997 
1998         if (from == address(0)) {
1999             // mint
2000             _updateAccountSnapshot(to);
2001             _updateTotalSupplySnapshot();
2002         } else if (to == address(0)) {
2003             // burn
2004             _updateAccountSnapshot(from);
2005             _updateTotalSupplySnapshot();
2006         } else {
2007             // transfer
2008             _updateAccountSnapshot(from);
2009             _updateAccountSnapshot(to);
2010         }
2011     }
2012 
2013     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
2014         require(snapshotId > 0, "ERC20Snapshot: id is 0");
2015         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
2016 
2017         // When a valid snapshot is queried, there are three possibilities:
2018         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
2019         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
2020         //  to this id is the current one.
2021         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
2022         //  requested id, and its value is the one to return.
2023         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
2024         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
2025         //  larger than the requested one.
2026         //
2027         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
2028         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
2029         // exactly this.
2030 
2031         uint256 index = snapshots.ids.findUpperBound(snapshotId);
2032 
2033         if (index == snapshots.ids.length) {
2034             return (false, 0);
2035         } else {
2036             return (true, snapshots.values[index]);
2037         }
2038     }
2039 
2040     function _updateAccountSnapshot(address account) private {
2041         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
2042     }
2043 
2044     function _updateTotalSupplySnapshot() private {
2045         _updateSnapshot(_totalSupplySnapshots, totalSupply());
2046     }
2047 
2048     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
2049         uint256 currentId = _getCurrentSnapshotId();
2050         if (_lastSnapshotId(snapshots.ids) < currentId) {
2051             snapshots.ids.push(currentId);
2052             snapshots.values.push(currentValue);
2053         }
2054     }
2055 
2056     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
2057         if (ids.length == 0) {
2058             return 0;
2059         } else {
2060             return ids[ids.length - 1];
2061         }
2062     }
2063 }
2064 
2065 // File: contracts/ElkV3.sol
2066 
2067 
2068 pragma solidity >=0.8.0;
2069 
2070 
2071 
2072 
2073 
2074 
2075 contract Elk is ERC20, ERC20Snapshot, Ownable, ERC20Permit, ERC20Votes {
2076     constructor() ERC20("Elk", "ELK") ERC20Permit("Elk") {
2077         _mint(msg.sender, 42424242 * 10 ** decimals());
2078     }
2079 
2080     function snapshot() public onlyOwner {
2081         _snapshot();
2082     }
2083 
2084     // The following functions are overrides required by Solidity.
2085 
2086     function _beforeTokenTransfer(address from, address to, uint256 amount)
2087         internal
2088         override(ERC20, ERC20Snapshot)
2089     {
2090         super._beforeTokenTransfer(from, to, amount);
2091     }
2092 
2093     function _afterTokenTransfer(address from, address to, uint256 amount)
2094         internal
2095         override(ERC20, ERC20Votes)
2096     {
2097         super._afterTokenTransfer(from, to, amount);
2098     }
2099 
2100     function _mint(address to, uint256 amount)
2101         internal
2102         override(ERC20, ERC20Votes)
2103     {
2104         super._mint(to, amount);
2105     }
2106 
2107     function _burn(address account, uint256 amount)
2108         internal
2109         override(ERC20, ERC20Votes)
2110     {
2111         super._burn(account, amount);
2112     }
2113 }