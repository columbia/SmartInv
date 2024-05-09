1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/utils/math/SafeCast.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
12  * checks.
13  *
14  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
15  * easily result in undesired exploitation or bugs, since developers usually
16  * assume that overflows raise errors. `SafeCast` restores this intuition by
17  * reverting the transaction when such an operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  *
22  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
23  * all math on `uint256` and `int256` and then downcasting.
24  */
25 library SafeCast {
26     /**
27      * @dev Returns the downcasted uint224 from uint256, reverting on
28      * overflow (when the input is greater than largest uint224).
29      *
30      * Counterpart to Solidity's `uint224` operator.
31      *
32      * Requirements:
33      *
34      * - input must fit into 224 bits
35      */
36     function toUint224(uint256 value) internal pure returns (uint224) {
37         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
38         return uint224(value);
39     }
40 
41     /**
42      * @dev Returns the downcasted uint128 from uint256, reverting on
43      * overflow (when the input is greater than largest uint128).
44      *
45      * Counterpart to Solidity's `uint128` operator.
46      *
47      * Requirements:
48      *
49      * - input must fit into 128 bits
50      */
51     function toUint128(uint256 value) internal pure returns (uint128) {
52         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
53         return uint128(value);
54     }
55 
56     /**
57      * @dev Returns the downcasted uint96 from uint256, reverting on
58      * overflow (when the input is greater than largest uint96).
59      *
60      * Counterpart to Solidity's `uint96` operator.
61      *
62      * Requirements:
63      *
64      * - input must fit into 96 bits
65      */
66     function toUint96(uint256 value) internal pure returns (uint96) {
67         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
68         return uint96(value);
69     }
70 
71     /**
72      * @dev Returns the downcasted uint64 from uint256, reverting on
73      * overflow (when the input is greater than largest uint64).
74      *
75      * Counterpart to Solidity's `uint64` operator.
76      *
77      * Requirements:
78      *
79      * - input must fit into 64 bits
80      */
81     function toUint64(uint256 value) internal pure returns (uint64) {
82         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
83         return uint64(value);
84     }
85 
86     /**
87      * @dev Returns the downcasted uint32 from uint256, reverting on
88      * overflow (when the input is greater than largest uint32).
89      *
90      * Counterpart to Solidity's `uint32` operator.
91      *
92      * Requirements:
93      *
94      * - input must fit into 32 bits
95      */
96     function toUint32(uint256 value) internal pure returns (uint32) {
97         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
98         return uint32(value);
99     }
100 
101     /**
102      * @dev Returns the downcasted uint16 from uint256, reverting on
103      * overflow (when the input is greater than largest uint16).
104      *
105      * Counterpart to Solidity's `uint16` operator.
106      *
107      * Requirements:
108      *
109      * - input must fit into 16 bits
110      */
111     function toUint16(uint256 value) internal pure returns (uint16) {
112         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
113         return uint16(value);
114     }
115 
116     /**
117      * @dev Returns the downcasted uint8 from uint256, reverting on
118      * overflow (when the input is greater than largest uint8).
119      *
120      * Counterpart to Solidity's `uint8` operator.
121      *
122      * Requirements:
123      *
124      * - input must fit into 8 bits.
125      */
126     function toUint8(uint256 value) internal pure returns (uint8) {
127         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
128         return uint8(value);
129     }
130 
131     /**
132      * @dev Converts a signed int256 into an unsigned uint256.
133      *
134      * Requirements:
135      *
136      * - input must be greater than or equal to 0.
137      */
138     function toUint256(int256 value) internal pure returns (uint256) {
139         require(value >= 0, "SafeCast: value must be positive");
140         return uint256(value);
141     }
142 
143     /**
144      * @dev Returns the downcasted int128 from int256, reverting on
145      * overflow (when the input is less than smallest int128 or
146      * greater than largest int128).
147      *
148      * Counterpart to Solidity's `int128` operator.
149      *
150      * Requirements:
151      *
152      * - input must fit into 128 bits
153      *
154      * _Available since v3.1._
155      */
156     function toInt128(int256 value) internal pure returns (int128) {
157         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
158         return int128(value);
159     }
160 
161     /**
162      * @dev Returns the downcasted int64 from int256, reverting on
163      * overflow (when the input is less than smallest int64 or
164      * greater than largest int64).
165      *
166      * Counterpart to Solidity's `int64` operator.
167      *
168      * Requirements:
169      *
170      * - input must fit into 64 bits
171      *
172      * _Available since v3.1._
173      */
174     function toInt64(int256 value) internal pure returns (int64) {
175         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
176         return int64(value);
177     }
178 
179     /**
180      * @dev Returns the downcasted int32 from int256, reverting on
181      * overflow (when the input is less than smallest int32 or
182      * greater than largest int32).
183      *
184      * Counterpart to Solidity's `int32` operator.
185      *
186      * Requirements:
187      *
188      * - input must fit into 32 bits
189      *
190      * _Available since v3.1._
191      */
192     function toInt32(int256 value) internal pure returns (int32) {
193         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
194         return int32(value);
195     }
196 
197     /**
198      * @dev Returns the downcasted int16 from int256, reverting on
199      * overflow (when the input is less than smallest int16 or
200      * greater than largest int16).
201      *
202      * Counterpart to Solidity's `int16` operator.
203      *
204      * Requirements:
205      *
206      * - input must fit into 16 bits
207      *
208      * _Available since v3.1._
209      */
210     function toInt16(int256 value) internal pure returns (int16) {
211         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
212         return int16(value);
213     }
214 
215     /**
216      * @dev Returns the downcasted int8 from int256, reverting on
217      * overflow (when the input is less than smallest int8 or
218      * greater than largest int8).
219      *
220      * Counterpart to Solidity's `int8` operator.
221      *
222      * Requirements:
223      *
224      * - input must fit into 8 bits.
225      *
226      * _Available since v3.1._
227      */
228     function toInt8(int256 value) internal pure returns (int8) {
229         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
230         return int8(value);
231     }
232 
233     /**
234      * @dev Converts an unsigned uint256 into a signed int256.
235      *
236      * Requirements:
237      *
238      * - input must be less than or equal to maxInt256.
239      */
240     function toInt256(uint256 value) internal pure returns (int256) {
241         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
242         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
243         return int256(value);
244     }
245 }
246 
247 // File: contracts/token/ERC20/extensions/draft-IERC20Permit.sol
248 
249 
250 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
256  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
257  *
258  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
259  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
260  * need to send a transaction, and thus is not required to hold Ether at all.
261  */
262 interface IERC20Permit {
263     /**
264      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
265      * given ``owner``'s signed approval.
266      *
267      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
268      * ordering also apply here.
269      *
270      * Emits an {Approval} event.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      * - `deadline` must be a timestamp in the future.
276      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
277      * over the EIP712-formatted function arguments.
278      * - the signature must use ``owner``'s current nonce (see {nonces}).
279      *
280      * For more information on the signature format, see the
281      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
282      * section].
283      */
284     function permit(
285         address owner,
286         address spender,
287         uint256 value,
288         uint256 deadline,
289         uint8 v,
290         bytes32 r,
291         bytes32 s
292     ) external;
293 
294     /**
295      * @dev Returns the current nonce for `owner`. This value must be
296      * included whenever a signature is generated for {permit}.
297      *
298      * Every successful call to {permit} increases ``owner``'s nonce by one. This
299      * prevents a signature from being used multiple times.
300      */
301     function nonces(address owner) external view returns (uint256);
302 
303     /**
304      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
305      */
306     // solhint-disable-next-line func-name-mixedcase
307     function DOMAIN_SEPARATOR() external view returns (bytes32);
308 }
309 
310 // File: contracts/utils/introspection/IERC165.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Interface of the ERC165 standard, as defined in the
319  * https://eips.ethereum.org/EIPS/eip-165[EIP].
320  *
321  * Implementers can declare support of contract interfaces, which can then be
322  * queried by others ({ERC165Checker}).
323  *
324  * For an implementation, see {ERC165}.
325  */
326 interface IERC165 {
327     /**
328      * @dev Returns true if this contract implements the interface defined by
329      * `interfaceId`. See the corresponding
330      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
331      * to learn more about how these ids are created.
332      *
333      * This function call must use less than 30 000 gas.
334      */
335     function supportsInterface(bytes4 interfaceId) external view returns (bool);
336 }
337 
338 // File: contracts/utils/introspection/ERC165.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 
346 /**
347  * @dev Implementation of the {IERC165} interface.
348  *
349  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
350  * for the additional interface id that will be supported. For example:
351  *
352  * ```solidity
353  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
354  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
355  * }
356  * ```
357  *
358  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
359  */
360 abstract contract ERC165 is IERC165 {
361     /**
362      * @dev See {IERC165-supportsInterface}.
363      */
364     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365         return interfaceId == type(IERC165).interfaceId;
366     }
367 }
368 
369 // File: contracts/utils/Strings.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev String operations.
378  */
379 library Strings {
380     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
381 
382     /**
383      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
384      */
385     function toString(uint256 value) internal pure returns (string memory) {
386         // Inspired by OraclizeAPI's implementation - MIT licence
387         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
388 
389         if (value == 0) {
390             return "0";
391         }
392         uint256 temp = value;
393         uint256 digits;
394         while (temp != 0) {
395             digits++;
396             temp /= 10;
397         }
398         bytes memory buffer = new bytes(digits);
399         while (value != 0) {
400             digits -= 1;
401             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
402             value /= 10;
403         }
404         return string(buffer);
405     }
406 
407     /**
408      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
409      */
410     function toHexString(uint256 value) internal pure returns (string memory) {
411         if (value == 0) {
412             return "0x00";
413         }
414         uint256 temp = value;
415         uint256 length = 0;
416         while (temp != 0) {
417             length++;
418             temp >>= 8;
419         }
420         return toHexString(value, length);
421     }
422 
423     /**
424      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
425      */
426     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
427         bytes memory buffer = new bytes(2 * length + 2);
428         buffer[0] = "0";
429         buffer[1] = "x";
430         for (uint256 i = 2 * length + 1; i > 1; --i) {
431             buffer[i] = _HEX_SYMBOLS[value & 0xf];
432             value >>= 4;
433         }
434         require(value == 0, "Strings: hex length insufficient");
435         return string(buffer);
436     }
437 }
438 
439 // File: contracts/utils/cryptography/ECDSA.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
449  *
450  * These functions can be used to verify that a message was signed by the holder
451  * of the private keys of a given address.
452  */
453 library ECDSA {
454     enum RecoverError {
455         NoError,
456         InvalidSignature,
457         InvalidSignatureLength,
458         InvalidSignatureS,
459         InvalidSignatureV
460     }
461 
462     function _throwError(RecoverError error) private pure {
463         if (error == RecoverError.NoError) {
464             return; // no error: do nothing
465         } else if (error == RecoverError.InvalidSignature) {
466             revert("ECDSA: invalid signature");
467         } else if (error == RecoverError.InvalidSignatureLength) {
468             revert("ECDSA: invalid signature length");
469         } else if (error == RecoverError.InvalidSignatureS) {
470             revert("ECDSA: invalid signature 's' value");
471         } else if (error == RecoverError.InvalidSignatureV) {
472             revert("ECDSA: invalid signature 'v' value");
473         }
474     }
475 
476     /**
477      * @dev Returns the address that signed a hashed message (`hash`) with
478      * `signature` or error string. This address can then be used for verification purposes.
479      *
480      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
481      * this function rejects them by requiring the `s` value to be in the lower
482      * half order, and the `v` value to be either 27 or 28.
483      *
484      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
485      * verification to be secure: it is possible to craft signatures that
486      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
487      * this is by receiving a hash of the original message (which may otherwise
488      * be too long), and then calling {toEthSignedMessageHash} on it.
489      *
490      * Documentation for signature generation:
491      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
492      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
493      *
494      * _Available since v4.3._
495      */
496     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
497         // Check the signature length
498         // - case 65: r,s,v signature (standard)
499         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
500         if (signature.length == 65) {
501             bytes32 r;
502             bytes32 s;
503             uint8 v;
504             // ecrecover takes the signature parameters, and the only way to get them
505             // currently is to use assembly.
506             assembly {
507                 r := mload(add(signature, 0x20))
508                 s := mload(add(signature, 0x40))
509                 v := byte(0, mload(add(signature, 0x60)))
510             }
511             return tryRecover(hash, v, r, s);
512         } else if (signature.length == 64) {
513             bytes32 r;
514             bytes32 vs;
515             // ecrecover takes the signature parameters, and the only way to get them
516             // currently is to use assembly.
517             assembly {
518                 r := mload(add(signature, 0x20))
519                 vs := mload(add(signature, 0x40))
520             }
521             return tryRecover(hash, r, vs);
522         } else {
523             return (address(0), RecoverError.InvalidSignatureLength);
524         }
525     }
526 
527     /**
528      * @dev Returns the address that signed a hashed message (`hash`) with
529      * `signature`. This address can then be used for verification purposes.
530      *
531      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
532      * this function rejects them by requiring the `s` value to be in the lower
533      * half order, and the `v` value to be either 27 or 28.
534      *
535      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
536      * verification to be secure: it is possible to craft signatures that
537      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
538      * this is by receiving a hash of the original message (which may otherwise
539      * be too long), and then calling {toEthSignedMessageHash} on it.
540      */
541     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
542         (address recovered, RecoverError error) = tryRecover(hash, signature);
543         _throwError(error);
544         return recovered;
545     }
546 
547     /**
548      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
549      *
550      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
551      *
552      * _Available since v4.3._
553      */
554     function tryRecover(
555         bytes32 hash,
556         bytes32 r,
557         bytes32 vs
558     ) internal pure returns (address, RecoverError) {
559         bytes32 s;
560         uint8 v;
561         assembly {
562             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
563             v := add(shr(255, vs), 27)
564         }
565         return tryRecover(hash, v, r, s);
566     }
567 
568     /**
569      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
570      *
571      * _Available since v4.2._
572      */
573     function recover(
574         bytes32 hash,
575         bytes32 r,
576         bytes32 vs
577     ) internal pure returns (address) {
578         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
579         _throwError(error);
580         return recovered;
581     }
582 
583     /**
584      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
585      * `r` and `s` signature fields separately.
586      *
587      * _Available since v4.3._
588      */
589     function tryRecover(
590         bytes32 hash,
591         uint8 v,
592         bytes32 r,
593         bytes32 s
594     ) internal pure returns (address, RecoverError) {
595         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
596         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
597         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
598         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
599         //
600         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
601         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
602         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
603         // these malleable signatures as well.
604         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
605             return (address(0), RecoverError.InvalidSignatureS);
606         }
607         if (v != 27 && v != 28) {
608             return (address(0), RecoverError.InvalidSignatureV);
609         }
610 
611         // If the signature is valid (and not malleable), return the signer address
612         address signer = ecrecover(hash, v, r, s);
613         if (signer == address(0)) {
614             return (address(0), RecoverError.InvalidSignature);
615         }
616 
617         return (signer, RecoverError.NoError);
618     }
619 
620     /**
621      * @dev Overload of {ECDSA-recover} that receives the `v`,
622      * `r` and `s` signature fields separately.
623      */
624     function recover(
625         bytes32 hash,
626         uint8 v,
627         bytes32 r,
628         bytes32 s
629     ) internal pure returns (address) {
630         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
631         _throwError(error);
632         return recovered;
633     }
634 
635     /**
636      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
637      * produces hash corresponding to the one signed with the
638      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
639      * JSON-RPC method as part of EIP-191.
640      *
641      * See {recover}.
642      */
643     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
644         // 32 is the length in bytes of hash,
645         // enforced by the type signature above
646         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
647     }
648 
649     /**
650      * @dev Returns an Ethereum Signed Message, created from `s`. This
651      * produces hash corresponding to the one signed with the
652      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
653      * JSON-RPC method as part of EIP-191.
654      *
655      * See {recover}.
656      */
657     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
658         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
659     }
660 
661     /**
662      * @dev Returns an Ethereum Signed Typed Data, created from a
663      * `domainSeparator` and a `structHash`. This produces hash corresponding
664      * to the one signed with the
665      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
666      * JSON-RPC method as part of EIP-712.
667      *
668      * See {recover}.
669      */
670     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
671         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
672     }
673 }
674 
675 // File: contracts/utils/cryptography/draft-EIP712.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
685  *
686  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
687  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
688  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
689  *
690  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
691  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
692  * ({_hashTypedDataV4}).
693  *
694  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
695  * the chain id to protect against replay attacks on an eventual fork of the chain.
696  *
697  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
698  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
699  *
700  * _Available since v3.4._
701  */
702 abstract contract EIP712 {
703     /* solhint-disable var-name-mixedcase */
704     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
705     // invalidate the cached domain separator if the chain id changes.
706     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
707     uint256 private immutable _CACHED_CHAIN_ID;
708     address private immutable _CACHED_THIS;
709 
710     bytes32 private immutable _HASHED_NAME;
711     bytes32 private immutable _HASHED_VERSION;
712     bytes32 private immutable _TYPE_HASH;
713 
714     /* solhint-enable var-name-mixedcase */
715 
716     /**
717      * @dev Initializes the domain separator and parameter caches.
718      *
719      * The meaning of `name` and `version` is specified in
720      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
721      *
722      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
723      * - `version`: the current major version of the signing domain.
724      *
725      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
726      * contract upgrade].
727      */
728     constructor(string memory name, string memory version) {
729         bytes32 hashedName = keccak256(bytes(name));
730         bytes32 hashedVersion = keccak256(bytes(version));
731         bytes32 typeHash = keccak256(
732             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
733         );
734         _HASHED_NAME = hashedName;
735         _HASHED_VERSION = hashedVersion;
736         _CACHED_CHAIN_ID = block.chainid;
737         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
738         _CACHED_THIS = address(this);
739         _TYPE_HASH = typeHash;
740     }
741 
742     /**
743      * @dev Returns the domain separator for the current chain.
744      */
745     function _domainSeparatorV4() internal view returns (bytes32) {
746         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
747             return _CACHED_DOMAIN_SEPARATOR;
748         } else {
749             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
750         }
751     }
752 
753     function _buildDomainSeparator(
754         bytes32 typeHash,
755         bytes32 nameHash,
756         bytes32 versionHash
757     ) private view returns (bytes32) {
758         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
759     }
760 
761     /**
762      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
763      * function returns the hash of the fully encoded EIP712 message for this domain.
764      *
765      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
766      *
767      * ```solidity
768      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
769      *     keccak256("Mail(address to,string contents)"),
770      *     mailTo,
771      *     keccak256(bytes(mailContents))
772      * )));
773      * address signer = ECDSA.recover(digest, signature);
774      * ```
775      */
776     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
777         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
778     }
779 }
780 
781 // File: contracts/access/IAccessControl.sol
782 
783 
784 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 /**
789  * @dev External interface of AccessControl declared to support ERC165 detection.
790  */
791 interface IAccessControl {
792     /**
793      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
794      *
795      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
796      * {RoleAdminChanged} not being emitted signaling this.
797      *
798      * _Available since v3.1._
799      */
800     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
801 
802     /**
803      * @dev Emitted when `account` is granted `role`.
804      *
805      * `sender` is the account that originated the contract call, an admin role
806      * bearer except when using {AccessControl-_setupRole}.
807      */
808     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
809 
810     /**
811      * @dev Emitted when `account` is revoked `role`.
812      *
813      * `sender` is the account that originated the contract call:
814      *   - if using `revokeRole`, it is the admin role bearer
815      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
816      */
817     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
818 
819     /**
820      * @dev Returns `true` if `account` has been granted `role`.
821      */
822     function hasRole(bytes32 role, address account) external view returns (bool);
823 
824     /**
825      * @dev Returns the admin role that controls `role`. See {grantRole} and
826      * {revokeRole}.
827      *
828      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
829      */
830     function getRoleAdmin(bytes32 role) external view returns (bytes32);
831 
832     /**
833      * @dev Grants `role` to `account`.
834      *
835      * If `account` had not been already granted `role`, emits a {RoleGranted}
836      * event.
837      *
838      * Requirements:
839      *
840      * - the caller must have ``role``'s admin role.
841      */
842     function grantRole(bytes32 role, address account) external;
843 
844     /**
845      * @dev Revokes `role` from `account`.
846      *
847      * If `account` had been granted `role`, emits a {RoleRevoked} event.
848      *
849      * Requirements:
850      *
851      * - the caller must have ``role``'s admin role.
852      */
853     function revokeRole(bytes32 role, address account) external;
854 
855     /**
856      * @dev Revokes `role` from the calling account.
857      *
858      * Roles are often managed via {grantRole} and {revokeRole}: this function's
859      * purpose is to provide a mechanism for accounts to lose their privileges
860      * if they are compromised (such as when a trusted device is misplaced).
861      *
862      * If the calling account had been granted `role`, emits a {RoleRevoked}
863      * event.
864      *
865      * Requirements:
866      *
867      * - the caller must be `account`.
868      */
869     function renounceRole(bytes32 role, address account) external;
870 }
871 
872 // File: contracts/utils/Counters.sol
873 
874 
875 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
876 
877 pragma solidity ^0.8.0;
878 
879 /**
880  * @title Counters
881  * @author Matt Condon (@shrugs)
882  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
883  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
884  *
885  * Include with `using Counters for Counters.Counter;`
886  */
887 library Counters {
888     struct Counter {
889         // This variable should never be directly accessed by users of the library: interactions must be restricted to
890         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
891         // this feature: see https://github.com/ethereum/solidity/issues/4637
892         uint256 _value; // default: 0
893     }
894 
895     function current(Counter storage counter) internal view returns (uint256) {
896         return counter._value;
897     }
898 
899     function increment(Counter storage counter) internal {
900         unchecked {
901             counter._value += 1;
902         }
903     }
904 
905     function decrement(Counter storage counter) internal {
906         uint256 value = counter._value;
907         require(value > 0, "Counter: decrement overflow");
908         unchecked {
909             counter._value = value - 1;
910         }
911     }
912 
913     function reset(Counter storage counter) internal {
914         counter._value = 0;
915     }
916 }
917 
918 // File: contracts/utils/math/Math.sol
919 
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @dev Standard math utilities missing in the Solidity language.
927  */
928 library Math {
929     /**
930      * @dev Returns the largest of two numbers.
931      */
932     function max(uint256 a, uint256 b) internal pure returns (uint256) {
933         return a >= b ? a : b;
934     }
935 
936     /**
937      * @dev Returns the smallest of two numbers.
938      */
939     function min(uint256 a, uint256 b) internal pure returns (uint256) {
940         return a < b ? a : b;
941     }
942 
943     /**
944      * @dev Returns the average of two numbers. The result is rounded towards
945      * zero.
946      */
947     function average(uint256 a, uint256 b) internal pure returns (uint256) {
948         // (a + b) / 2 can overflow.
949         return (a & b) + (a ^ b) / 2;
950     }
951 
952     /**
953      * @dev Returns the ceiling of the division of two numbers.
954      *
955      * This differs from standard division with `/` in that it rounds up instead
956      * of rounding down.
957      */
958     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
959         // (a + b - 1) / b can overflow on addition, so we distribute.
960         return a / b + (a % b == 0 ? 0 : 1);
961     }
962 }
963 
964 // File: contracts/utils/Arrays.sol
965 
966 
967 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
968 
969 pragma solidity ^0.8.0;
970 
971 
972 /**
973  * @dev Collection of functions related to array types.
974  */
975 library Arrays {
976     /**
977      * @dev Searches a sorted `array` and returns the first index that contains
978      * a value greater or equal to `element`. If no such index exists (i.e. all
979      * values in the array are strictly less than `element`), the array length is
980      * returned. Time complexity O(log n).
981      *
982      * `array` is expected to be sorted in ascending order, and to contain no
983      * repeated elements.
984      */
985     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
986         if (array.length == 0) {
987             return 0;
988         }
989 
990         uint256 low = 0;
991         uint256 high = array.length;
992 
993         while (low < high) {
994             uint256 mid = Math.average(low, high);
995 
996             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
997             // because Math.average rounds down (it does integer division with truncation).
998             if (array[mid] > element) {
999                 high = mid;
1000             } else {
1001                 low = mid + 1;
1002             }
1003         }
1004 
1005         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1006         if (low > 0 && array[low - 1] == element) {
1007             return low - 1;
1008         } else {
1009             return low;
1010         }
1011     }
1012 }
1013 
1014 // File: contracts/utils/Context.sol
1015 
1016 
1017 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @dev Provides information about the current execution context, including the
1023  * sender of the transaction and its data. While these are generally available
1024  * via msg.sender and msg.data, they should not be accessed in such a direct
1025  * manner, since when dealing with meta-transactions the account sending and
1026  * paying for execution may not be the actual sender (as far as an application
1027  * is concerned).
1028  *
1029  * This contract is only required for intermediate, library-like contracts.
1030  */
1031 abstract contract Context {
1032     function _msgSender() internal view virtual returns (address) {
1033         return msg.sender;
1034     }
1035 
1036     function _msgData() internal view virtual returns (bytes calldata) {
1037         return msg.data;
1038     }
1039 }
1040 
1041 // File: contracts/security/Pausable.sol
1042 
1043 
1044 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 /**
1050  * @dev Contract module which allows children to implement an emergency stop
1051  * mechanism that can be triggered by an authorized account.
1052  *
1053  * This module is used through inheritance. It will make available the
1054  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1055  * the functions of your contract. Note that they will not be pausable by
1056  * simply including this module, only once the modifiers are put in place.
1057  */
1058 abstract contract Pausable is Context {
1059     /**
1060      * @dev Emitted when the pause is triggered by `account`.
1061      */
1062     event Paused(address account);
1063 
1064     /**
1065      * @dev Emitted when the pause is lifted by `account`.
1066      */
1067     event Unpaused(address account);
1068 
1069     bool private _paused;
1070 
1071     /**
1072      * @dev Initializes the contract in unpaused state.
1073      */
1074     constructor() {
1075         _paused = false;
1076     }
1077 
1078     /**
1079      * @dev Returns true if the contract is paused, and false otherwise.
1080      */
1081     function paused() public view virtual returns (bool) {
1082         return _paused;
1083     }
1084 
1085     /**
1086      * @dev Modifier to make a function callable only when the contract is not paused.
1087      *
1088      * Requirements:
1089      *
1090      * - The contract must not be paused.
1091      */
1092     modifier whenNotPaused() {
1093         require(!paused(), "Pausable: paused");
1094         _;
1095     }
1096 
1097     /**
1098      * @dev Modifier to make a function callable only when the contract is paused.
1099      *
1100      * Requirements:
1101      *
1102      * - The contract must be paused.
1103      */
1104     modifier whenPaused() {
1105         require(paused(), "Pausable: not paused");
1106         _;
1107     }
1108 
1109     /**
1110      * @dev Triggers stopped state.
1111      *
1112      * Requirements:
1113      *
1114      * - The contract must not be paused.
1115      */
1116     function _pause() internal virtual whenNotPaused {
1117         _paused = true;
1118         emit Paused(_msgSender());
1119     }
1120 
1121     /**
1122      * @dev Returns to normal state.
1123      *
1124      * Requirements:
1125      *
1126      * - The contract must be paused.
1127      */
1128     function _unpause() internal virtual whenPaused {
1129         _paused = false;
1130         emit Unpaused(_msgSender());
1131     }
1132 }
1133 
1134 // File: contracts/access/AccessControl.sol
1135 
1136 
1137 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 
1142 
1143 
1144 
1145 /**
1146  * @dev Contract module that allows children to implement role-based access
1147  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1148  * members except through off-chain means by accessing the contract event logs. Some
1149  * applications may benefit from on-chain enumerability, for those cases see
1150  * {AccessControlEnumerable}.
1151  *
1152  * Roles are referred to by their `bytes32` identifier. These should be exposed
1153  * in the external API and be unique. The best way to achieve this is by
1154  * using `public constant` hash digests:
1155  *
1156  * ```
1157  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1158  * ```
1159  *
1160  * Roles can be used to represent a set of permissions. To restrict access to a
1161  * function call, use {hasRole}:
1162  *
1163  * ```
1164  * function foo() public {
1165  *     require(hasRole(MY_ROLE, msg.sender));
1166  *     ...
1167  * }
1168  * ```
1169  *
1170  * Roles can be granted and revoked dynamically via the {grantRole} and
1171  * {revokeRole} functions. Each role has an associated admin role, and only
1172  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1173  *
1174  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1175  * that only accounts with this role will be able to grant or revoke other
1176  * roles. More complex role relationships can be created by using
1177  * {_setRoleAdmin}.
1178  *
1179  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1180  * grant and revoke this role. Extra precautions should be taken to secure
1181  * accounts that have been granted it.
1182  */
1183 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1184     struct RoleData {
1185         mapping(address => bool) members;
1186         bytes32 adminRole;
1187     }
1188 
1189     mapping(bytes32 => RoleData) private _roles;
1190 
1191     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1192 
1193     /**
1194      * @dev Modifier that checks that an account has a specific role. Reverts
1195      * with a standardized message including the required role.
1196      *
1197      * The format of the revert reason is given by the following regular expression:
1198      *
1199      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1200      *
1201      * _Available since v4.1._
1202      */
1203     modifier onlyRole(bytes32 role) {
1204         _checkRole(role, _msgSender());
1205         _;
1206     }
1207 
1208     /**
1209      * @dev See {IERC165-supportsInterface}.
1210      */
1211     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1212         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1213     }
1214 
1215     /**
1216      * @dev Returns `true` if `account` has been granted `role`.
1217      */
1218     function hasRole(bytes32 role, address account) public view override returns (bool) {
1219         return _roles[role].members[account];
1220     }
1221 
1222     /**
1223      * @dev Revert with a standard message if `account` is missing `role`.
1224      *
1225      * The format of the revert reason is given by the following regular expression:
1226      *
1227      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1228      */
1229     function _checkRole(bytes32 role, address account) internal view {
1230         if (!hasRole(role, account)) {
1231             revert(
1232                 string(
1233                     abi.encodePacked(
1234                         "AccessControl: account ",
1235                         Strings.toHexString(uint160(account), 20),
1236                         " is missing role ",
1237                         Strings.toHexString(uint256(role), 32)
1238                     )
1239                 )
1240             );
1241         }
1242     }
1243 
1244     /**
1245      * @dev Returns the admin role that controls `role`. See {grantRole} and
1246      * {revokeRole}.
1247      *
1248      * To change a role's admin, use {_setRoleAdmin}.
1249      */
1250     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1251         return _roles[role].adminRole;
1252     }
1253 
1254     /**
1255      * @dev Grants `role` to `account`.
1256      *
1257      * If `account` had not been already granted `role`, emits a {RoleGranted}
1258      * event.
1259      *
1260      * Requirements:
1261      *
1262      * - the caller must have ``role``'s admin role.
1263      */
1264     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1265         _grantRole(role, account);
1266     }
1267 
1268     /**
1269      * @dev Revokes `role` from `account`.
1270      *
1271      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1272      *
1273      * Requirements:
1274      *
1275      * - the caller must have ``role``'s admin role.
1276      */
1277     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1278         _revokeRole(role, account);
1279     }
1280 
1281     /**
1282      * @dev Revokes `role` from the calling account.
1283      *
1284      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1285      * purpose is to provide a mechanism for accounts to lose their privileges
1286      * if they are compromised (such as when a trusted device is misplaced).
1287      *
1288      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1289      * event.
1290      *
1291      * Requirements:
1292      *
1293      * - the caller must be `account`.
1294      */
1295     function renounceRole(bytes32 role, address account) public virtual override {
1296         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1297 
1298         _revokeRole(role, account);
1299     }
1300 
1301     /**
1302      * @dev Grants `role` to `account`.
1303      *
1304      * If `account` had not been already granted `role`, emits a {RoleGranted}
1305      * event. Note that unlike {grantRole}, this function doesn't perform any
1306      * checks on the calling account.
1307      *
1308      * [WARNING]
1309      * ====
1310      * This function should only be called from the constructor when setting
1311      * up the initial roles for the system.
1312      *
1313      * Using this function in any other way is effectively circumventing the admin
1314      * system imposed by {AccessControl}.
1315      * ====
1316      *
1317      * NOTE: This function is deprecated in favor of {_grantRole}.
1318      */
1319     function _setupRole(bytes32 role, address account) internal virtual {
1320         _grantRole(role, account);
1321     }
1322 
1323     /**
1324      * @dev Sets `adminRole` as ``role``'s admin role.
1325      *
1326      * Emits a {RoleAdminChanged} event.
1327      */
1328     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1329         bytes32 previousAdminRole = getRoleAdmin(role);
1330         _roles[role].adminRole = adminRole;
1331         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1332     }
1333 
1334     /**
1335      * @dev Grants `role` to `account`.
1336      *
1337      * Internal function without access restriction.
1338      */
1339     function _grantRole(bytes32 role, address account) internal virtual {
1340         if (!hasRole(role, account)) {
1341             _roles[role].members[account] = true;
1342             emit RoleGranted(role, account, _msgSender());
1343         }
1344     }
1345 
1346     /**
1347      * @dev Revokes `role` from `account`.
1348      *
1349      * Internal function without access restriction.
1350      */
1351     function _revokeRole(bytes32 role, address account) internal virtual {
1352         if (hasRole(role, account)) {
1353             _roles[role].members[account] = false;
1354             emit RoleRevoked(role, account, _msgSender());
1355         }
1356     }
1357 }
1358 
1359 // File: contracts/token/ERC20/IERC20.sol
1360 
1361 
1362 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
1363 
1364 pragma solidity ^0.8.0;
1365 
1366 /**
1367  * @dev Interface of the ERC20 standard as defined in the EIP.
1368  */
1369 interface IERC20 {
1370     /**
1371      * @dev Returns the amount of tokens in existence.
1372      */
1373     function totalSupply() external view returns (uint256);
1374 
1375     /**
1376      * @dev Returns the amount of tokens owned by `account`.
1377      */
1378     function balanceOf(address account) external view returns (uint256);
1379 
1380     /**
1381      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1382      *
1383      * Returns a boolean value indicating whether the operation succeeded.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function transfer(address recipient, uint256 amount) external returns (bool);
1388 
1389     /**
1390      * @dev Returns the remaining number of tokens that `spender` will be
1391      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1392      * zero by default.
1393      *
1394      * This value changes when {approve} or {transferFrom} are called.
1395      */
1396     function allowance(address owner, address spender) external view returns (uint256);
1397 
1398     /**
1399      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1400      *
1401      * Returns a boolean value indicating whether the operation succeeded.
1402      *
1403      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1404      * that someone may use both the old and the new allowance by unfortunate
1405      * transaction ordering. One possible solution to mitigate this race
1406      * condition is to first reduce the spender's allowance to 0 and set the
1407      * desired value afterwards:
1408      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1409      *
1410      * Emits an {Approval} event.
1411      */
1412     function approve(address spender, uint256 amount) external returns (bool);
1413 
1414     /**
1415      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1416      * allowance mechanism. `amount` is then deducted from the caller's
1417      * allowance.
1418      *
1419      * Returns a boolean value indicating whether the operation succeeded.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function transferFrom(
1424         address sender,
1425         address recipient,
1426         uint256 amount
1427     ) external returns (bool);
1428 
1429     /**
1430      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1431      * another (`to`).
1432      *
1433      * Note that `value` may be zero.
1434      */
1435     event Transfer(address indexed from, address indexed to, uint256 value);
1436 
1437     /**
1438      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1439      * a call to {approve}. `value` is the new allowance.
1440      */
1441     event Approval(address indexed owner, address indexed spender, uint256 value);
1442 }
1443 
1444 // File: contracts/token/ERC20/extensions/IERC20Metadata.sol
1445 
1446 
1447 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1448 
1449 pragma solidity ^0.8.0;
1450 
1451 
1452 /**
1453  * @dev Interface for the optional metadata functions from the ERC20 standard.
1454  *
1455  * _Available since v4.1._
1456  */
1457 interface IERC20Metadata is IERC20 {
1458     /**
1459      * @dev Returns the name of the token.
1460      */
1461     function name() external view returns (string memory);
1462 
1463     /**
1464      * @dev Returns the symbol of the token.
1465      */
1466     function symbol() external view returns (string memory);
1467 
1468     /**
1469      * @dev Returns the decimals places of the token.
1470      */
1471     function decimals() external view returns (uint8);
1472 }
1473 
1474 // File: contracts/token/ERC20/ERC20.sol
1475 
1476 
1477 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
1478 
1479 pragma solidity ^0.8.0;
1480 
1481 
1482 
1483 
1484 /**
1485  * @dev Implementation of the {IERC20} interface.
1486  *
1487  * This implementation is agnostic to the way tokens are created. This means
1488  * that a supply mechanism has to be added in a derived contract using {_mint}.
1489  * For a generic mechanism see {ERC20PresetMinterPauser}.
1490  *
1491  * TIP: For a detailed writeup see our guide
1492  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1493  * to implement supply mechanisms].
1494  *
1495  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1496  * instead returning `false` on failure. This behavior is nonetheless
1497  * conventional and does not conflict with the expectations of ERC20
1498  * applications.
1499  *
1500  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1501  * This allows applications to reconstruct the allowance for all accounts just
1502  * by listening to said events. Other implementations of the EIP may not emit
1503  * these events, as it isn't required by the specification.
1504  *
1505  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1506  * functions have been added to mitigate the well-known issues around setting
1507  * allowances. See {IERC20-approve}.
1508  */
1509 contract ERC20 is Context, IERC20, IERC20Metadata {
1510     mapping(address => uint256) private _balances;
1511 
1512     mapping(address => mapping(address => uint256)) private _allowances;
1513 
1514     uint256 private _totalSupply;
1515 
1516     string private _name;
1517     string private _symbol;
1518 
1519     /**
1520      * @dev Sets the values for {name} and {symbol}.
1521      *
1522      * The default value of {decimals} is 18. To select a different value for
1523      * {decimals} you should overload it.
1524      *
1525      * All two of these values are immutable: they can only be set once during
1526      * construction.
1527      */
1528     constructor(string memory name_, string memory symbol_) {
1529         _name = name_;
1530         _symbol = symbol_;
1531     }
1532 
1533     /**
1534      * @dev Returns the name of the token.
1535      */
1536     function name() public view virtual override returns (string memory) {
1537         return _name;
1538     }
1539 
1540     /**
1541      * @dev Returns the symbol of the token, usually a shorter version of the
1542      * name.
1543      */
1544     function symbol() public view virtual override returns (string memory) {
1545         return _symbol;
1546     }
1547 
1548     /**
1549      * @dev Returns the number of decimals used to get its user representation.
1550      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1551      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1552      *
1553      * Tokens usually opt for a value of 18, imitating the relationship between
1554      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1555      * overridden;
1556      *
1557      * NOTE: This information is only used for _display_ purposes: it in
1558      * no way affects any of the arithmetic of the contract, including
1559      * {IERC20-balanceOf} and {IERC20-transfer}.
1560      */
1561     function decimals() public view virtual override returns (uint8) {
1562         return 18;
1563     }
1564 
1565     /**
1566      * @dev See {IERC20-totalSupply}.
1567      */
1568     function totalSupply() public view virtual override returns (uint256) {
1569         return _totalSupply;
1570     }
1571 
1572     /**
1573      * @dev See {IERC20-balanceOf}.
1574      */
1575     function balanceOf(address account) public view virtual override returns (uint256) {
1576         return _balances[account];
1577     }
1578 
1579     /**
1580      * @dev See {IERC20-transfer}.
1581      *
1582      * Requirements:
1583      *
1584      * - `recipient` cannot be the zero address.
1585      * - the caller must have a balance of at least `amount`.
1586      */
1587     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1588         _transfer(_msgSender(), recipient, amount);
1589         return true;
1590     }
1591 
1592     /**
1593      * @dev See {IERC20-allowance}.
1594      */
1595     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1596         return _allowances[owner][spender];
1597     }
1598 
1599     /**
1600      * @dev See {IERC20-approve}.
1601      *
1602      * Requirements:
1603      *
1604      * - `spender` cannot be the zero address.
1605      */
1606     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1607         _approve(_msgSender(), spender, amount);
1608         return true;
1609     }
1610 
1611     /**
1612      * @dev See {IERC20-transferFrom}.
1613      *
1614      * Emits an {Approval} event indicating the updated allowance. This is not
1615      * required by the EIP. See the note at the beginning of {ERC20}.
1616      *
1617      * Requirements:
1618      *
1619      * - `sender` and `recipient` cannot be the zero address.
1620      * - `sender` must have a balance of at least `amount`.
1621      * - the caller must have allowance for ``sender``'s tokens of at least
1622      * `amount`.
1623      */
1624     function transferFrom(
1625         address sender,
1626         address recipient,
1627         uint256 amount
1628     ) public virtual override returns (bool) {
1629         _transfer(sender, recipient, amount);
1630 
1631         uint256 currentAllowance = _allowances[sender][_msgSender()];
1632         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1633         unchecked {
1634             _approve(sender, _msgSender(), currentAllowance - amount);
1635         }
1636 
1637         return true;
1638     }
1639 
1640     /**
1641      * @dev Atomically increases the allowance granted to `spender` by the caller.
1642      *
1643      * This is an alternative to {approve} that can be used as a mitigation for
1644      * problems described in {IERC20-approve}.
1645      *
1646      * Emits an {Approval} event indicating the updated allowance.
1647      *
1648      * Requirements:
1649      *
1650      * - `spender` cannot be the zero address.
1651      */
1652     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1653         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1654         return true;
1655     }
1656 
1657     /**
1658      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1659      *
1660      * This is an alternative to {approve} that can be used as a mitigation for
1661      * problems described in {IERC20-approve}.
1662      *
1663      * Emits an {Approval} event indicating the updated allowance.
1664      *
1665      * Requirements:
1666      *
1667      * - `spender` cannot be the zero address.
1668      * - `spender` must have allowance for the caller of at least
1669      * `subtractedValue`.
1670      */
1671     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1672         uint256 currentAllowance = _allowances[_msgSender()][spender];
1673         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1674         unchecked {
1675             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1676         }
1677 
1678         return true;
1679     }
1680 
1681     /**
1682      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1683      *
1684      * This internal function is equivalent to {transfer}, and can be used to
1685      * e.g. implement automatic token fees, slashing mechanisms, etc.
1686      *
1687      * Emits a {Transfer} event.
1688      *
1689      * Requirements:
1690      *
1691      * - `sender` cannot be the zero address.
1692      * - `recipient` cannot be the zero address.
1693      * - `sender` must have a balance of at least `amount`.
1694      */
1695     function _transfer(
1696         address sender,
1697         address recipient,
1698         uint256 amount
1699     ) internal virtual {
1700         require(sender != address(0), "ERC20: transfer from the zero address");
1701         require(recipient != address(0), "ERC20: transfer to the zero address");
1702 
1703         _beforeTokenTransfer(sender, recipient, amount);
1704 
1705         uint256 senderBalance = _balances[sender];
1706         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1707         unchecked {
1708             _balances[sender] = senderBalance - amount;
1709         }
1710         _balances[recipient] += amount;
1711 
1712         emit Transfer(sender, recipient, amount);
1713 
1714         _afterTokenTransfer(sender, recipient, amount);
1715     }
1716 
1717     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1718      * the total supply.
1719      *
1720      * Emits a {Transfer} event with `from` set to the zero address.
1721      *
1722      * Requirements:
1723      *
1724      * - `account` cannot be the zero address.
1725      */
1726     function _mint(address account, uint256 amount) internal virtual {
1727         require(account != address(0), "ERC20: mint to the zero address");
1728 
1729         _beforeTokenTransfer(address(0), account, amount);
1730 
1731         _totalSupply += amount;
1732         _balances[account] += amount;
1733         emit Transfer(address(0), account, amount);
1734 
1735         _afterTokenTransfer(address(0), account, amount);
1736     }
1737 
1738     /**
1739      * @dev Destroys `amount` tokens from `account`, reducing the
1740      * total supply.
1741      *
1742      * Emits a {Transfer} event with `to` set to the zero address.
1743      *
1744      * Requirements:
1745      *
1746      * - `account` cannot be the zero address.
1747      * - `account` must have at least `amount` tokens.
1748      */
1749     function _burn(address account, uint256 amount) internal virtual {
1750         require(account != address(0), "ERC20: burn from the zero address");
1751 
1752         _beforeTokenTransfer(account, address(0), amount);
1753 
1754         uint256 accountBalance = _balances[account];
1755         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1756         unchecked {
1757             _balances[account] = accountBalance - amount;
1758         }
1759         _totalSupply -= amount;
1760 
1761         emit Transfer(account, address(0), amount);
1762 
1763         _afterTokenTransfer(account, address(0), amount);
1764     }
1765 
1766     /**
1767      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1768      *
1769      * This internal function is equivalent to `approve`, and can be used to
1770      * e.g. set automatic allowances for certain subsystems, etc.
1771      *
1772      * Emits an {Approval} event.
1773      *
1774      * Requirements:
1775      *
1776      * - `owner` cannot be the zero address.
1777      * - `spender` cannot be the zero address.
1778      */
1779     function _approve(
1780         address owner,
1781         address spender,
1782         uint256 amount
1783     ) internal virtual {
1784         require(owner != address(0), "ERC20: approve from the zero address");
1785         require(spender != address(0), "ERC20: approve to the zero address");
1786 
1787         _allowances[owner][spender] = amount;
1788         emit Approval(owner, spender, amount);
1789     }
1790 
1791     /**
1792      * @dev Hook that is called before any transfer of tokens. This includes
1793      * minting and burning.
1794      *
1795      * Calling conditions:
1796      *
1797      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1798      * will be transferred to `to`.
1799      * - when `from` is zero, `amount` tokens will be minted for `to`.
1800      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1801      * - `from` and `to` are never both zero.
1802      *
1803      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1804      */
1805     function _beforeTokenTransfer(
1806         address from,
1807         address to,
1808         uint256 amount
1809     ) internal virtual {}
1810 
1811     /**
1812      * @dev Hook that is called after any transfer of tokens. This includes
1813      * minting and burning.
1814      *
1815      * Calling conditions:
1816      *
1817      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1818      * has been transferred to `to`.
1819      * - when `from` is zero, `amount` tokens have been minted for `to`.
1820      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1821      * - `from` and `to` are never both zero.
1822      *
1823      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1824      */
1825     function _afterTokenTransfer(
1826         address from,
1827         address to,
1828         uint256 amount
1829     ) internal virtual {}
1830 }
1831 
1832 // File: contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1833 
1834 
1835 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1836 
1837 pragma solidity ^0.8.0;
1838 
1839 
1840 
1841 
1842 
1843 
1844 /**
1845  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1846  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1847  *
1848  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1849  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1850  * need to send a transaction, and thus is not required to hold Ether at all.
1851  *
1852  * _Available since v3.4._
1853  */
1854 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1855     using Counters for Counters.Counter;
1856 
1857     mapping(address => Counters.Counter) private _nonces;
1858 
1859     // solhint-disable-next-line var-name-mixedcase
1860     bytes32 private immutable _PERMIT_TYPEHASH =
1861         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1862 
1863     /**
1864      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1865      *
1866      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1867      */
1868     constructor(string memory name) EIP712(name, "1") {}
1869 
1870     /**
1871      * @dev See {IERC20Permit-permit}.
1872      */
1873     function permit(
1874         address owner,
1875         address spender,
1876         uint256 value,
1877         uint256 deadline,
1878         uint8 v,
1879         bytes32 r,
1880         bytes32 s
1881     ) public virtual override {
1882         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1883 
1884         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1885 
1886         bytes32 hash = _hashTypedDataV4(structHash);
1887 
1888         address signer = ECDSA.recover(hash, v, r, s);
1889         require(signer == owner, "ERC20Permit: invalid signature");
1890 
1891         _approve(owner, spender, value);
1892     }
1893 
1894     /**
1895      * @dev See {IERC20Permit-nonces}.
1896      */
1897     function nonces(address owner) public view virtual override returns (uint256) {
1898         return _nonces[owner].current();
1899     }
1900 
1901     /**
1902      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1903      */
1904     // solhint-disable-next-line func-name-mixedcase
1905     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1906         return _domainSeparatorV4();
1907     }
1908 
1909     /**
1910      * @dev "Consume a nonce": return the current value and increment.
1911      *
1912      * _Available since v4.1._
1913      */
1914     function _useNonce(address owner) internal virtual returns (uint256 current) {
1915         Counters.Counter storage nonce = _nonces[owner];
1916         current = nonce.current();
1917         nonce.increment();
1918     }
1919 }
1920 
1921 // File: contracts/token/ERC20/extensions/ERC20Votes.sol
1922 
1923 
1924 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Votes.sol)
1925 
1926 pragma solidity ^0.8.0;
1927 
1928 
1929 
1930 
1931 
1932 /**
1933  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1934  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1935  *
1936  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1937  *
1938  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1939  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1940  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1941  *
1942  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1943  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1944  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1945  * will significantly increase the base gas cost of transfers.
1946  *
1947  * _Available since v4.2._
1948  */
1949 abstract contract ERC20Votes is ERC20Permit {
1950     struct Checkpoint {
1951         uint32 fromBlock;
1952         uint224 votes;
1953     }
1954 
1955     bytes32 private constant _DELEGATION_TYPEHASH =
1956         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1957 
1958     mapping(address => address) private _delegates;
1959     mapping(address => Checkpoint[]) private _checkpoints;
1960     Checkpoint[] private _totalSupplyCheckpoints;
1961 
1962     /**
1963      * @dev Emitted when an account changes their delegate.
1964      */
1965     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1966 
1967     /**
1968      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1969      */
1970     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1971 
1972     /**
1973      * @dev Get the `pos`-th checkpoint for `account`.
1974      */
1975     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1976         return _checkpoints[account][pos];
1977     }
1978 
1979     /**
1980      * @dev Get number of checkpoints for `account`.
1981      */
1982     function numCheckpoints(address account) public view virtual returns (uint32) {
1983         return SafeCast.toUint32(_checkpoints[account].length);
1984     }
1985 
1986     /**
1987      * @dev Get the address `account` is currently delegating to.
1988      */
1989     function delegates(address account) public view virtual returns (address) {
1990         return _delegates[account];
1991     }
1992 
1993     /**
1994      * @dev Gets the current votes balance for `account`
1995      */
1996     function getVotes(address account) public view returns (uint256) {
1997         uint256 pos = _checkpoints[account].length;
1998         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1999     }
2000 
2001     /**
2002      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
2003      *
2004      * Requirements:
2005      *
2006      * - `blockNumber` must have been already mined
2007      */
2008     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
2009         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2010         return _checkpointsLookup(_checkpoints[account], blockNumber);
2011     }
2012 
2013     /**
2014      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
2015      * It is but NOT the sum of all the delegated votes!
2016      *
2017      * Requirements:
2018      *
2019      * - `blockNumber` must have been already mined
2020      */
2021     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
2022         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
2023         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
2024     }
2025 
2026     /**
2027      * @dev Lookup a value in a list of (sorted) checkpoints.
2028      */
2029     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
2030         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
2031         //
2032         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
2033         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
2034         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
2035         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
2036         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
2037         // out of bounds (in which case we're looking too far in the past and the result is 0).
2038         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
2039         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
2040         // the same.
2041         uint256 high = ckpts.length;
2042         uint256 low = 0;
2043         while (low < high) {
2044             uint256 mid = Math.average(low, high);
2045             if (ckpts[mid].fromBlock > blockNumber) {
2046                 high = mid;
2047             } else {
2048                 low = mid + 1;
2049             }
2050         }
2051 
2052         return high == 0 ? 0 : ckpts[high - 1].votes;
2053     }
2054 
2055     /**
2056      * @dev Delegate votes from the sender to `delegatee`.
2057      */
2058     function delegate(address delegatee) public virtual {
2059         _delegate(_msgSender(), delegatee);
2060     }
2061 
2062     /**
2063      * @dev Delegates votes from signer to `delegatee`
2064      */
2065     function delegateBySig(
2066         address delegatee,
2067         uint256 nonce,
2068         uint256 expiry,
2069         uint8 v,
2070         bytes32 r,
2071         bytes32 s
2072     ) public virtual {
2073         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
2074         address signer = ECDSA.recover(
2075             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
2076             v,
2077             r,
2078             s
2079         );
2080         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
2081         _delegate(signer, delegatee);
2082     }
2083 
2084     /**
2085      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
2086      */
2087     function _maxSupply() internal view virtual returns (uint224) {
2088         return type(uint224).max;
2089     }
2090 
2091     /**
2092      * @dev Snapshots the totalSupply after it has been increased.
2093      */
2094     function _mint(address account, uint256 amount) internal virtual override {
2095         super._mint(account, amount);
2096         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
2097 
2098         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
2099     }
2100 
2101     /**
2102      * @dev Snapshots the totalSupply after it has been decreased.
2103      */
2104     function _burn(address account, uint256 amount) internal virtual override {
2105         super._burn(account, amount);
2106 
2107         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
2108     }
2109 
2110     /**
2111      * @dev Move voting power when tokens are transferred.
2112      *
2113      * Emits a {DelegateVotesChanged} event.
2114      */
2115     function _afterTokenTransfer(
2116         address from,
2117         address to,
2118         uint256 amount
2119     ) internal virtual override {
2120         super._afterTokenTransfer(from, to, amount);
2121 
2122         _moveVotingPower(delegates(from), delegates(to), amount);
2123     }
2124 
2125     /**
2126      * @dev Change delegation for `delegator` to `delegatee`.
2127      *
2128      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
2129      */
2130     function _delegate(address delegator, address delegatee) internal virtual {
2131         address currentDelegate = delegates(delegator);
2132         uint256 delegatorBalance = balanceOf(delegator);
2133         _delegates[delegator] = delegatee;
2134 
2135         emit DelegateChanged(delegator, currentDelegate, delegatee);
2136 
2137         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
2138     }
2139 
2140     function _moveVotingPower(
2141         address src,
2142         address dst,
2143         uint256 amount
2144     ) private {
2145         if (src != dst && amount > 0) {
2146             if (src != address(0)) {
2147                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
2148                 emit DelegateVotesChanged(src, oldWeight, newWeight);
2149             }
2150 
2151             if (dst != address(0)) {
2152                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
2153                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
2154             }
2155         }
2156     }
2157 
2158     function _writeCheckpoint(
2159         Checkpoint[] storage ckpts,
2160         function(uint256, uint256) view returns (uint256) op,
2161         uint256 delta
2162     ) private returns (uint256 oldWeight, uint256 newWeight) {
2163         uint256 pos = ckpts.length;
2164         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
2165         newWeight = op(oldWeight, delta);
2166 
2167         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
2168             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
2169         } else {
2170             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
2171         }
2172     }
2173 
2174     function _add(uint256 a, uint256 b) private pure returns (uint256) {
2175         return a + b;
2176     }
2177 
2178     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
2179         return a - b;
2180     }
2181 }
2182 
2183 // File: contracts/token/ERC20/extensions/ERC20Snapshot.sol
2184 
2185 
2186 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
2187 
2188 pragma solidity ^0.8.0;
2189 
2190 
2191 
2192 
2193 /**
2194  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
2195  * total supply at the time are recorded for later access.
2196  *
2197  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
2198  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
2199  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
2200  * used to create an efficient ERC20 forking mechanism.
2201  *
2202  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
2203  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
2204  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
2205  * and the account address.
2206  *
2207  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
2208  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
2209  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
2210  *
2211  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
2212  * alternative consider {ERC20Votes}.
2213  *
2214  * ==== Gas Costs
2215  *
2216  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
2217  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
2218  * smaller since identical balances in subsequent snapshots are stored as a single entry.
2219  *
2220  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
2221  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
2222  * transfers will have normal cost until the next snapshot, and so on.
2223  */
2224 
2225 abstract contract ERC20Snapshot is ERC20 {
2226     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
2227     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
2228 
2229     using Arrays for uint256[];
2230     using Counters for Counters.Counter;
2231 
2232     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
2233     // Snapshot struct, but that would impede usage of functions that work on an array.
2234     struct Snapshots {
2235         uint256[] ids;
2236         uint256[] values;
2237     }
2238 
2239     mapping(address => Snapshots) private _accountBalanceSnapshots;
2240     Snapshots private _totalSupplySnapshots;
2241 
2242     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
2243     Counters.Counter private _currentSnapshotId;
2244 
2245     /**
2246      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
2247      */
2248     event Snapshot(uint256 id);
2249 
2250     /**
2251      * @dev Creates a new snapshot and returns its snapshot id.
2252      *
2253      * Emits a {Snapshot} event that contains the same id.
2254      *
2255      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
2256      * set of accounts, for example using {AccessControl}, or it may be open to the public.
2257      *
2258      * [WARNING]
2259      * ====
2260      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
2261      * you must consider that it can potentially be used by attackers in two ways.
2262      *
2263      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
2264      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
2265      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
2266      * section above.
2267      *
2268      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
2269      * ====
2270      */
2271     function _snapshot() internal virtual returns (uint256) {
2272         _currentSnapshotId.increment();
2273 
2274         uint256 currentId = _getCurrentSnapshotId();
2275         emit Snapshot(currentId);
2276         return currentId;
2277     }
2278 
2279     /**
2280      * @dev Get the current snapshotId
2281      */
2282     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
2283         return _currentSnapshotId.current();
2284     }
2285 
2286     /**
2287      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
2288      */
2289     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
2290         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
2291 
2292         return snapshotted ? value : balanceOf(account);
2293     }
2294 
2295     /**
2296      * @dev Retrieves the total supply at the time `snapshotId` was created.
2297      */
2298     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
2299         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
2300 
2301         return snapshotted ? value : totalSupply();
2302     }
2303 
2304     // Update balance and/or total supply snapshots before the values are modified. This is implemented
2305     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
2306     function _beforeTokenTransfer(
2307         address from,
2308         address to,
2309         uint256 amount
2310     ) internal virtual override {
2311         super._beforeTokenTransfer(from, to, amount);
2312 
2313         if (from == address(0)) {
2314             // mint
2315             _updateAccountSnapshot(to);
2316             _updateTotalSupplySnapshot();
2317         } else if (to == address(0)) {
2318             // burn
2319             _updateAccountSnapshot(from);
2320             _updateTotalSupplySnapshot();
2321         } else {
2322             // transfer
2323             _updateAccountSnapshot(from);
2324             _updateAccountSnapshot(to);
2325         }
2326     }
2327 
2328     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
2329         require(snapshotId > 0, "ERC20Snapshot: id is 0");
2330         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
2331 
2332         // When a valid snapshot is queried, there are three possibilities:
2333         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
2334         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
2335         //  to this id is the current one.
2336         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
2337         //  requested id, and its value is the one to return.
2338         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
2339         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
2340         //  larger than the requested one.
2341         //
2342         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
2343         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
2344         // exactly this.
2345 
2346         uint256 index = snapshots.ids.findUpperBound(snapshotId);
2347 
2348         if (index == snapshots.ids.length) {
2349             return (false, 0);
2350         } else {
2351             return (true, snapshots.values[index]);
2352         }
2353     }
2354 
2355     function _updateAccountSnapshot(address account) private {
2356         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
2357     }
2358 
2359     function _updateTotalSupplySnapshot() private {
2360         _updateSnapshot(_totalSupplySnapshots, totalSupply());
2361     }
2362 
2363     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
2364         uint256 currentId = _getCurrentSnapshotId();
2365         if (_lastSnapshotId(snapshots.ids) < currentId) {
2366             snapshots.ids.push(currentId);
2367             snapshots.values.push(currentValue);
2368         }
2369     }
2370 
2371     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
2372         if (ids.length == 0) {
2373             return 0;
2374         } else {
2375             return ids[ids.length - 1];
2376         }
2377     }
2378 }
2379 
2380 // File: contracts/token/ERC20/extensions/ERC20Burnable.sol
2381 
2382 
2383 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
2384 
2385 pragma solidity ^0.8.0;
2386 
2387 
2388 
2389 /**
2390  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2391  * tokens and those that they have an allowance for, in a way that can be
2392  * recognized off-chain (via event analysis).
2393  */
2394 abstract contract ERC20Burnable is Context, ERC20 {
2395     /**
2396      * @dev Destroys `amount` tokens from the caller.
2397      *
2398      * See {ERC20-_burn}.
2399      */
2400     function burn(uint256 amount) public virtual {
2401         _burn(_msgSender(), amount);
2402     }
2403 
2404     /**
2405      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2406      * allowance.
2407      *
2408      * See {ERC20-_burn} and {ERC20-allowance}.
2409      *
2410      * Requirements:
2411      *
2412      * - the caller must have allowance for ``accounts``'s tokens of at least
2413      * `amount`.
2414      */
2415     function burnFrom(address account, uint256 amount) public virtual {
2416         uint256 currentAllowance = allowance(account, _msgSender());
2417         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
2418         unchecked {
2419             _approve(account, _msgSender(), currentAllowance - amount);
2420         }
2421         _burn(account, amount);
2422     }
2423 }
2424 
2425 // File: HanChain.sol
2426 
2427 
2428 pragma solidity ^0.8.2;
2429 
2430 
2431 
2432 
2433 
2434 
2435 
2436 
2437 contract HanChain is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl, Pausable, ERC20Permit, ERC20Votes {
2438     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
2439     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2440 
2441     constructor() ERC20("HanChain", "HAN") ERC20Permit("HanChain") {
2442         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
2443         _grantRole(SNAPSHOT_ROLE, msg.sender);
2444         _grantRole(PAUSER_ROLE, msg.sender);
2445         _mint(msg.sender, 1500000000 * 10 ** decimals());
2446     }
2447 
2448     function snapshot() public onlyRole(SNAPSHOT_ROLE) {
2449         _snapshot();
2450     }
2451 
2452     function pause() public onlyRole(PAUSER_ROLE) {
2453         _pause();
2454     }
2455 
2456     function unpause() public onlyRole(PAUSER_ROLE) {
2457         _unpause();
2458     }
2459 
2460     function _beforeTokenTransfer(address from, address to, uint256 amount)
2461         internal
2462         whenNotPaused
2463         override(ERC20, ERC20Snapshot)
2464     {
2465         super._beforeTokenTransfer(from, to, amount);
2466     }
2467 
2468     // The following functions are overrides required by Solidity.
2469 
2470     function _afterTokenTransfer(address from, address to, uint256 amount)
2471         internal
2472         override(ERC20, ERC20Votes)
2473     {
2474         super._afterTokenTransfer(from, to, amount);
2475     }
2476 
2477     function _mint(address to, uint256 amount)
2478         internal
2479         override(ERC20, ERC20Votes)
2480     {
2481         super._mint(to, amount);
2482     }
2483 
2484     function _burn(address account, uint256 amount)
2485         internal
2486         override(ERC20, ERC20Votes)
2487     {
2488         super._burn(account, amount);
2489     }
2490 }