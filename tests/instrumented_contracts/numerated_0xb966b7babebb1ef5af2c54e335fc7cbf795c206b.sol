1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for managing
10  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
11  * types.
12  *
13  * Sets have the following properties:
14  *
15  * - Elements are added, removed, and checked for existence in constant time
16  * (O(1)).
17  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
18  *
19  * ```
20  * contract Example {
21  *     // Add the library methods
22  *     using EnumerableSet for EnumerableSet.AddressSet;
23  *
24  *     // Declare a set state variable
25  *     EnumerableSet.AddressSet private mySet;
26  * }
27  * ```
28  *
29  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
30  * and `uint256` (`UintSet`) are supported.
31  */
32 library EnumerableSet {
33     // To implement this library for multiple types with as little code
34     // repetition as possible, we write it in terms of a generic Set type with
35     // bytes32 values.
36     // The Set implementation uses private functions, and user-facing
37     // implementations (such as AddressSet) are just wrappers around the
38     // underlying Set.
39     // This means that we can only create new EnumerableSets for types that fit
40     // in bytes32.
41 
42     struct Set {
43         // Storage of set values
44         bytes32[] _values;
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping(bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) {
79             // Equivalent to contains(set, value)
80             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
81             // the array, and then remove the last element (sometimes called as 'swap and pop').
82             // This modifies the order of the array, as noted in {at}.
83 
84             uint256 toDeleteIndex = valueIndex - 1;
85             uint256 lastIndex = set._values.length - 1;
86 
87             if (lastIndex != toDeleteIndex) {
88                 bytes32 lastvalue = set._values[lastIndex];
89 
90                 // Move the last value to the index where the value to delete is
91                 set._values[toDeleteIndex] = lastvalue;
92                 // Update the index for the moved value
93                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
94             }
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122     /**
123      * @dev Returns the value stored at position `index` in the set. O(1).
124      *
125      * Note that there are no guarantees on the ordering of values inside the
126      * array, and it may change when more values are added or removed.
127      *
128      * Requirements:
129      *
130      * - `index` must be strictly less than {length}.
131      */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         return set._values[index];
134     }
135 
136     /**
137      * @dev Return the entire set in an array
138      *
139      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
140      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
141      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
142      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
143      */
144     function _values(Set storage set) private view returns (bytes32[] memory) {
145         return set._values;
146     }
147 
148     // Bytes32Set
149 
150     struct Bytes32Set {
151         Set _inner;
152     }
153 
154     /**
155      * @dev Add a value to a set. O(1).
156      *
157      * Returns true if the value was added to the set, that is if it was not
158      * already present.
159      */
160     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
161         return _add(set._inner, value);
162     }
163 
164     /**
165      * @dev Removes a value from a set. O(1).
166      *
167      * Returns true if the value was removed from the set, that is if it was
168      * present.
169      */
170     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
171         return _remove(set._inner, value);
172     }
173 
174     /**
175      * @dev Returns true if the value is in the set. O(1).
176      */
177     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
178         return _contains(set._inner, value);
179     }
180 
181     /**
182      * @dev Returns the number of values in the set. O(1).
183      */
184     function length(Bytes32Set storage set) internal view returns (uint256) {
185         return _length(set._inner);
186     }
187 
188     /**
189      * @dev Returns the value stored at position `index` in the set. O(1).
190      *
191      * Note that there are no guarantees on the ordering of values inside the
192      * array, and it may change when more values are added or removed.
193      *
194      * Requirements:
195      *
196      * - `index` must be strictly less than {length}.
197      */
198     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
199         return _at(set._inner, index);
200     }
201 
202     /**
203      * @dev Return the entire set in an array
204      *
205      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
206      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
207      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
208      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
209      */
210     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
211         return _values(set._inner);
212     }
213 
214     // AddressSet
215 
216     struct AddressSet {
217         Set _inner;
218     }
219 
220     /**
221      * @dev Add a value to a set. O(1).
222      *
223      * Returns true if the value was added to the set, that is if it was not
224      * already present.
225      */
226     function add(AddressSet storage set, address value) internal returns (bool) {
227         return _add(set._inner, bytes32(uint256(uint160(value))));
228     }
229 
230     /**
231      * @dev Removes a value from a set. O(1).
232      *
233      * Returns true if the value was removed from the set, that is if it was
234      * present.
235      */
236     function remove(AddressSet storage set, address value) internal returns (bool) {
237         return _remove(set._inner, bytes32(uint256(uint160(value))));
238     }
239 
240     /**
241      * @dev Returns true if the value is in the set. O(1).
242      */
243     function contains(AddressSet storage set, address value) internal view returns (bool) {
244         return _contains(set._inner, bytes32(uint256(uint160(value))));
245     }
246 
247     /**
248      * @dev Returns the number of values in the set. O(1).
249      */
250     function length(AddressSet storage set) internal view returns (uint256) {
251         return _length(set._inner);
252     }
253 
254     /**
255      * @dev Returns the value stored at position `index` in the set. O(1).
256      *
257      * Note that there are no guarantees on the ordering of values inside the
258      * array, and it may change when more values are added or removed.
259      *
260      * Requirements:
261      *
262      * - `index` must be strictly less than {length}.
263      */
264     function at(AddressSet storage set, uint256 index) internal view returns (address) {
265         return address(uint160(uint256(_at(set._inner, index))));
266     }
267 
268     /**
269      * @dev Return the entire set in an array
270      *
271      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
272      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
273      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
274      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
275      */
276     function values(AddressSet storage set) internal view returns (address[] memory) {
277         bytes32[] memory store = _values(set._inner);
278         address[] memory result;
279 
280         assembly {
281             result := store
282         }
283 
284         return result;
285     }
286 
287     // UintSet
288 
289     struct UintSet {
290         Set _inner;
291     }
292 
293     /**
294      * @dev Add a value to a set. O(1).
295      *
296      * Returns true if the value was added to the set, that is if it was not
297      * already present.
298      */
299     function add(UintSet storage set, uint256 value) internal returns (bool) {
300         return _add(set._inner, bytes32(value));
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function remove(UintSet storage set, uint256 value) internal returns (bool) {
310         return _remove(set._inner, bytes32(value));
311     }
312 
313     /**
314      * @dev Returns true if the value is in the set. O(1).
315      */
316     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
317         return _contains(set._inner, bytes32(value));
318     }
319 
320     /**
321      * @dev Returns the number of values on the set. O(1).
322      */
323     function length(UintSet storage set) internal view returns (uint256) {
324         return _length(set._inner);
325     }
326 
327     /**
328      * @dev Returns the value stored at position `index` in the set. O(1).
329      *
330      * Note that there are no guarantees on the ordering of values inside the
331      * array, and it may change when more values are added or removed.
332      *
333      * Requirements:
334      *
335      * - `index` must be strictly less than {length}.
336      */
337     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
338         return uint256(_at(set._inner, index));
339     }
340 
341     /**
342      * @dev Return the entire set in an array
343      *
344      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
345      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
346      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
347      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
348      */
349     function values(UintSet storage set) internal view returns (uint256[] memory) {
350         bytes32[] memory store = _values(set._inner);
351         uint256[] memory result;
352 
353         assembly {
354             result := store
355         }
356 
357         return result;
358     }
359 }
360 
361 // File: @openzeppelin/contracts/utils/Strings.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev String operations.
370  */
371 library Strings {
372     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
373 
374     /**
375      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
376      */
377     function toString(uint256 value) internal pure returns (string memory) {
378         // Inspired by OraclizeAPI's implementation - MIT licence
379         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
380 
381         if (value == 0) {
382             return "0";
383         }
384         uint256 temp = value;
385         uint256 digits;
386         while (temp != 0) {
387             digits++;
388             temp /= 10;
389         }
390         bytes memory buffer = new bytes(digits);
391         while (value != 0) {
392             digits -= 1;
393             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
394             value /= 10;
395         }
396         return string(buffer);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
401      */
402     function toHexString(uint256 value) internal pure returns (string memory) {
403         if (value == 0) {
404             return "0x00";
405         }
406         uint256 temp = value;
407         uint256 length = 0;
408         while (temp != 0) {
409             length++;
410             temp >>= 8;
411         }
412         return toHexString(value, length);
413     }
414 
415     /**
416      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
417      */
418     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
419         bytes memory buffer = new bytes(2 * length + 2);
420         buffer[0] = "0";
421         buffer[1] = "x";
422         for (uint256 i = 2 * length + 1; i > 1; --i) {
423             buffer[i] = _HEX_SYMBOLS[value & 0xf];
424             value >>= 4;
425         }
426         require(value == 0, "Strings: hex length insufficient");
427         return string(buffer);
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
432 
433 
434 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
435 
436 pragma solidity ^0.8.0;
437 
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
551         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
552         uint8 v = uint8((uint256(vs) >> 255) + 27);
553         return tryRecover(hash, v, r, s);
554     }
555 
556     /**
557      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
558      *
559      * _Available since v4.2._
560      */
561     function recover(
562         bytes32 hash,
563         bytes32 r,
564         bytes32 vs
565     ) internal pure returns (address) {
566         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
567         _throwError(error);
568         return recovered;
569     }
570 
571     /**
572      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
573      * `r` and `s` signature fields separately.
574      *
575      * _Available since v4.3._
576      */
577     function tryRecover(
578         bytes32 hash,
579         uint8 v,
580         bytes32 r,
581         bytes32 s
582     ) internal pure returns (address, RecoverError) {
583         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
584         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
585         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
586         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
587         //
588         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
589         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
590         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
591         // these malleable signatures as well.
592         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
593             return (address(0), RecoverError.InvalidSignatureS);
594         }
595         if (v != 27 && v != 28) {
596             return (address(0), RecoverError.InvalidSignatureV);
597         }
598 
599         // If the signature is valid (and not malleable), return the signer address
600         address signer = ecrecover(hash, v, r, s);
601         if (signer == address(0)) {
602             return (address(0), RecoverError.InvalidSignature);
603         }
604 
605         return (signer, RecoverError.NoError);
606     }
607 
608     /**
609      * @dev Overload of {ECDSA-recover} that receives the `v`,
610      * `r` and `s` signature fields separately.
611      */
612     function recover(
613         bytes32 hash,
614         uint8 v,
615         bytes32 r,
616         bytes32 s
617     ) internal pure returns (address) {
618         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
619         _throwError(error);
620         return recovered;
621     }
622 
623     /**
624      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
625      * produces hash corresponding to the one signed with the
626      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
627      * JSON-RPC method as part of EIP-191.
628      *
629      * See {recover}.
630      */
631     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
632         // 32 is the length in bytes of hash,
633         // enforced by the type signature above
634         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
635     }
636 
637     /**
638      * @dev Returns an Ethereum Signed Message, created from `s`. This
639      * produces hash corresponding to the one signed with the
640      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
641      * JSON-RPC method as part of EIP-191.
642      *
643      * See {recover}.
644      */
645     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
646         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
647     }
648 
649     /**
650      * @dev Returns an Ethereum Signed Typed Data, created from a
651      * `domainSeparator` and a `structHash`. This produces hash corresponding
652      * to the one signed with the
653      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
654      * JSON-RPC method as part of EIP-712.
655      *
656      * See {recover}.
657      */
658     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
659         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
660     }
661 }
662 
663 // File: @openzeppelin/contracts/utils/Address.sol
664 
665 
666 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
667 
668 pragma solidity ^0.8.1;
669 
670 /**
671  * @dev Collection of functions related to the address type
672  */
673 library Address {
674     /**
675      * @dev Returns true if `account` is a contract.
676      *
677      * [IMPORTANT]
678      * ====
679      * It is unsafe to assume that an address for which this function returns
680      * false is an externally-owned account (EOA) and not a contract.
681      *
682      * Among others, `isContract` will return false for the following
683      * types of addresses:
684      *
685      *  - an externally-owned account
686      *  - a contract in construction
687      *  - an address where a contract will be created
688      *  - an address where a contract lived, but was destroyed
689      * ====
690      *
691      * [IMPORTANT]
692      * ====
693      * You shouldn't rely on `isContract` to protect against flash loan attacks!
694      *
695      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
696      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
697      * constructor.
698      * ====
699      */
700     function isContract(address account) internal view returns (bool) {
701         // This method relies on extcodesize/address.code.length, which returns 0
702         // for contracts in construction, since the code is only stored at the end
703         // of the constructor execution.
704 
705         return account.code.length > 0;
706     }
707 
708     /**
709      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
710      * `recipient`, forwarding all available gas and reverting on errors.
711      *
712      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
713      * of certain opcodes, possibly making contracts go over the 2300 gas limit
714      * imposed by `transfer`, making them unable to receive funds via
715      * `transfer`. {sendValue} removes this limitation.
716      *
717      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
718      *
719      * IMPORTANT: because control is transferred to `recipient`, care must be
720      * taken to not create reentrancy vulnerabilities. Consider using
721      * {ReentrancyGuard} or the
722      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
723      */
724     function sendValue(address payable recipient, uint256 amount) internal {
725         require(address(this).balance >= amount, "Address: insufficient balance");
726 
727         (bool success, ) = recipient.call{value: amount}("");
728         require(success, "Address: unable to send value, recipient may have reverted");
729     }
730 
731     /**
732      * @dev Performs a Solidity function call using a low level `call`. A
733      * plain `call` is an unsafe replacement for a function call: use this
734      * function instead.
735      *
736      * If `target` reverts with a revert reason, it is bubbled up by this
737      * function (like regular Solidity function calls).
738      *
739      * Returns the raw returned data. To convert to the expected return value,
740      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
741      *
742      * Requirements:
743      *
744      * - `target` must be a contract.
745      * - calling `target` with `data` must not revert.
746      *
747      * _Available since v3.1._
748      */
749     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
750         return functionCall(target, data, "Address: low-level call failed");
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
755      * `errorMessage` as a fallback revert reason when `target` reverts.
756      *
757      * _Available since v3.1._
758      */
759     function functionCall(
760         address target,
761         bytes memory data,
762         string memory errorMessage
763     ) internal returns (bytes memory) {
764         return functionCallWithValue(target, data, 0, errorMessage);
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
769      * but also transferring `value` wei to `target`.
770      *
771      * Requirements:
772      *
773      * - the calling contract must have an ETH balance of at least `value`.
774      * - the called Solidity function must be `payable`.
775      *
776      * _Available since v3.1._
777      */
778     function functionCallWithValue(
779         address target,
780         bytes memory data,
781         uint256 value
782     ) internal returns (bytes memory) {
783         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
788      * with `errorMessage` as a fallback revert reason when `target` reverts.
789      *
790      * _Available since v3.1._
791      */
792     function functionCallWithValue(
793         address target,
794         bytes memory data,
795         uint256 value,
796         string memory errorMessage
797     ) internal returns (bytes memory) {
798         require(address(this).balance >= value, "Address: insufficient balance for call");
799         require(isContract(target), "Address: call to non-contract");
800 
801         (bool success, bytes memory returndata) = target.call{value: value}(data);
802         return verifyCallResult(success, returndata, errorMessage);
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
807      * but performing a static call.
808      *
809      * _Available since v3.3._
810      */
811     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
812         return functionStaticCall(target, data, "Address: low-level static call failed");
813     }
814 
815     /**
816      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
817      * but performing a static call.
818      *
819      * _Available since v3.3._
820      */
821     function functionStaticCall(
822         address target,
823         bytes memory data,
824         string memory errorMessage
825     ) internal view returns (bytes memory) {
826         require(isContract(target), "Address: static call to non-contract");
827 
828         (bool success, bytes memory returndata) = target.staticcall(data);
829         return verifyCallResult(success, returndata, errorMessage);
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
834      * but performing a delegate call.
835      *
836      * _Available since v3.4._
837      */
838     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
839         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
844      * but performing a delegate call.
845      *
846      * _Available since v3.4._
847      */
848     function functionDelegateCall(
849         address target,
850         bytes memory data,
851         string memory errorMessage
852     ) internal returns (bytes memory) {
853         require(isContract(target), "Address: delegate call to non-contract");
854 
855         (bool success, bytes memory returndata) = target.delegatecall(data);
856         return verifyCallResult(success, returndata, errorMessage);
857     }
858 
859     /**
860      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
861      * revert reason using the provided one.
862      *
863      * _Available since v4.3._
864      */
865     function verifyCallResult(
866         bool success,
867         bytes memory returndata,
868         string memory errorMessage
869     ) internal pure returns (bytes memory) {
870         if (success) {
871             return returndata;
872         } else {
873             // Look for revert reason and bubble it up if present
874             if (returndata.length > 0) {
875                 // The easiest way to bubble the revert reason is using memory via assembly
876 
877                 assembly {
878                     let returndata_size := mload(returndata)
879                     revert(add(32, returndata), returndata_size)
880                 }
881             } else {
882                 revert(errorMessage);
883             }
884         }
885     }
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 /**
896  * @title ERC721 token receiver interface
897  * @dev Interface for any contract that wants to support safeTransfers
898  * from ERC721 asset contracts.
899  */
900 interface IERC721Receiver {
901     /**
902      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
903      * by `operator` from `from`, this function is called.
904      *
905      * It must return its Solidity selector to confirm the token transfer.
906      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
907      *
908      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
909      */
910     function onERC721Received(
911         address operator,
912         address from,
913         uint256 tokenId,
914         bytes calldata data
915     ) external returns (bytes4);
916 }
917 
918 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
919 
920 
921 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @dev Interface of the ERC165 standard, as defined in the
927  * https://eips.ethereum.org/EIPS/eip-165[EIP].
928  *
929  * Implementers can declare support of contract interfaces, which can then be
930  * queried by others ({ERC165Checker}).
931  *
932  * For an implementation, see {ERC165}.
933  */
934 interface IERC165 {
935     /**
936      * @dev Returns true if this contract implements the interface defined by
937      * `interfaceId`. See the corresponding
938      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
939      * to learn more about how these ids are created.
940      *
941      * This function call must use less than 30 000 gas.
942      */
943     function supportsInterface(bytes4 interfaceId) external view returns (bool);
944 }
945 
946 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
947 
948 
949 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
950 
951 pragma solidity ^0.8.0;
952 
953 
954 /**
955  * @dev Implementation of the {IERC165} interface.
956  *
957  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
958  * for the additional interface id that will be supported. For example:
959  *
960  * ```solidity
961  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
963  * }
964  * ```
965  *
966  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
967  */
968 abstract contract ERC165 is IERC165 {
969     /**
970      * @dev See {IERC165-supportsInterface}.
971      */
972     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973         return interfaceId == type(IERC165).interfaceId;
974     }
975 }
976 
977 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
978 
979 
980 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 
985 /**
986  * @dev Required interface of an ERC721 compliant contract.
987  */
988 interface IERC721 is IERC165 {
989     /**
990      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
991      */
992     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
993 
994     /**
995      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
996      */
997     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
998 
999     /**
1000      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1001      */
1002     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1003 
1004     /**
1005      * @dev Returns the number of tokens in ``owner``'s account.
1006      */
1007     function balanceOf(address owner) external view returns (uint256 balance);
1008 
1009     /**
1010      * @dev Returns the owner of the `tokenId` token.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function ownerOf(uint256 tokenId) external view returns (address owner);
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1020      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) external;
1037 
1038     /**
1039      * @dev Transfers `tokenId` token from `from` to `to`.
1040      *
1041      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1042      *
1043      * Requirements:
1044      *
1045      * - `from` cannot be the zero address.
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) external;
1057 
1058     /**
1059      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1060      * The approval is cleared when the token is transferred.
1061      *
1062      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1063      *
1064      * Requirements:
1065      *
1066      * - The caller must own the token or be an approved operator.
1067      * - `tokenId` must exist.
1068      *
1069      * Emits an {Approval} event.
1070      */
1071     function approve(address to, uint256 tokenId) external;
1072 
1073     /**
1074      * @dev Returns the account approved for `tokenId` token.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      */
1080     function getApproved(uint256 tokenId) external view returns (address operator);
1081 
1082     /**
1083      * @dev Approve or remove `operator` as an operator for the caller.
1084      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1085      *
1086      * Requirements:
1087      *
1088      * - The `operator` cannot be the caller.
1089      *
1090      * Emits an {ApprovalForAll} event.
1091      */
1092     function setApprovalForAll(address operator, bool _approved) external;
1093 
1094     /**
1095      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1096      *
1097      * See {setApprovalForAll}
1098      */
1099     function isApprovedForAll(address owner, address operator) external view returns (bool);
1100 
1101     /**
1102      * @dev Safely transfers `tokenId` token from `from` to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - `from` cannot be the zero address.
1107      * - `to` cannot be the zero address.
1108      * - `tokenId` token must exist and be owned by `from`.
1109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes calldata data
1119     ) external;
1120 }
1121 
1122 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1123 
1124 
1125 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 /**
1131  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1132  * @dev See https://eips.ethereum.org/EIPS/eip-721
1133  */
1134 interface IERC721Enumerable is IERC721 {
1135     /**
1136      * @dev Returns the total amount of tokens stored by the contract.
1137      */
1138     function totalSupply() external view returns (uint256);
1139 
1140     /**
1141      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1142      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1143      */
1144     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1145 
1146     /**
1147      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1148      * Use along with {totalSupply} to enumerate all tokens.
1149      */
1150     function tokenByIndex(uint256 index) external view returns (uint256);
1151 }
1152 
1153 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1163  * @dev See https://eips.ethereum.org/EIPS/eip-721
1164  */
1165 interface IERC721Metadata is IERC721 {
1166     /**
1167      * @dev Returns the token collection name.
1168      */
1169     function name() external view returns (string memory);
1170 
1171     /**
1172      * @dev Returns the token collection symbol.
1173      */
1174     function symbol() external view returns (string memory);
1175 
1176     /**
1177      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1178      */
1179     function tokenURI(uint256 tokenId) external view returns (string memory);
1180 }
1181 
1182 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 /**
1190  * @dev Contract module that helps prevent reentrant calls to a function.
1191  *
1192  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1193  * available, which can be applied to functions to make sure there are no nested
1194  * (reentrant) calls to them.
1195  *
1196  * Note that because there is a single `nonReentrant` guard, functions marked as
1197  * `nonReentrant` may not call one another. This can be worked around by making
1198  * those functions `private`, and then adding `external` `nonReentrant` entry
1199  * points to them.
1200  *
1201  * TIP: If you would like to learn more about reentrancy and alternative ways
1202  * to protect against it, check out our blog post
1203  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1204  */
1205 abstract contract ReentrancyGuard {
1206     // Booleans are more expensive than uint256 or any type that takes up a full
1207     // word because each write operation emits an extra SLOAD to first read the
1208     // slot's contents, replace the bits taken up by the boolean, and then write
1209     // back. This is the compiler's defense against contract upgrades and
1210     // pointer aliasing, and it cannot be disabled.
1211 
1212     // The values being non-zero value makes deployment a bit more expensive,
1213     // but in exchange the refund on every call to nonReentrant will be lower in
1214     // amount. Since refunds are capped to a percentage of the total
1215     // transaction's gas, it is best to keep them low in cases like this one, to
1216     // increase the likelihood of the full refund coming into effect.
1217     uint256 private constant _NOT_ENTERED = 1;
1218     uint256 private constant _ENTERED = 2;
1219 
1220     uint256 private _status;
1221 
1222     constructor() {
1223         _status = _NOT_ENTERED;
1224     }
1225 
1226     /**
1227      * @dev Prevents a contract from calling itself, directly or indirectly.
1228      * Calling a `nonReentrant` function from another `nonReentrant`
1229      * function is not supported. It is possible to prevent this from happening
1230      * by making the `nonReentrant` function external, and making it call a
1231      * `private` function that does the actual work.
1232      */
1233     modifier nonReentrant() {
1234         // On the first call to nonReentrant, _notEntered will be true
1235         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1236 
1237         // Any calls to nonReentrant after this point will fail
1238         _status = _ENTERED;
1239 
1240         _;
1241 
1242         // By storing the original value once again, a refund is triggered (see
1243         // https://eips.ethereum.org/EIPS/eip-2200)
1244         _status = _NOT_ENTERED;
1245     }
1246 }
1247 
1248 // File: @openzeppelin/contracts/utils/Context.sol
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 /**
1256  * @dev Provides information about the current execution context, including the
1257  * sender of the transaction and its data. While these are generally available
1258  * via msg.sender and msg.data, they should not be accessed in such a direct
1259  * manner, since when dealing with meta-transactions the account sending and
1260  * paying for execution may not be the actual sender (as far as an application
1261  * is concerned).
1262  *
1263  * This contract is only required for intermediate, library-like contracts.
1264  */
1265 abstract contract Context {
1266     function _msgSender() internal view virtual returns (address) {
1267         return msg.sender;
1268     }
1269 
1270     function _msgData() internal view virtual returns (bytes calldata) {
1271         return msg.data;
1272     }
1273 }
1274 
1275 // File: FT Locked Box/ERC721A.sol
1276 
1277 
1278 // Creator: Chiru Labs
1279 
1280 pragma solidity ^0.8.4;
1281 
1282 
1283 
1284 
1285 
1286 
1287 
1288 
1289 
1290 error ApprovalCallerNotOwnerNorApproved();
1291 error ApprovalQueryForNonexistentToken();
1292 error ApproveToCaller();
1293 error ApprovalToCurrentOwner();
1294 error BalanceQueryForZeroAddress();
1295 error MintedQueryForZeroAddress();
1296 error BurnedQueryForZeroAddress();
1297 error AuxQueryForZeroAddress();
1298 error MintToZeroAddress();
1299 error MintZeroQuantity();
1300 error OwnerIndexOutOfBounds();
1301 error OwnerQueryForNonexistentToken();
1302 error TokenIndexOutOfBounds();
1303 error TransferCallerNotOwnerNorApproved();
1304 error TransferFromIncorrectOwner();
1305 error TransferToNonERC721ReceiverImplementer();
1306 error TransferToZeroAddress();
1307 error URIQueryForNonexistentToken();
1308 
1309 /**
1310  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1311  * the Metadata extension. Built to optimize for lower gas during batch mints.
1312  *
1313  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1314  *
1315  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1316  *
1317  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1318  */
1319 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1320     using Address for address;
1321     using Strings for uint256;
1322 
1323     // Compiler will pack this into a single 256bit word.
1324     struct TokenOwnership {
1325         // The address of the owner.
1326         address addr;
1327         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1328         uint64 startTimestamp;
1329         // Whether the token has been burned.
1330         bool burned;
1331     }
1332 
1333     // Compiler will pack this into a single 256bit word.
1334     struct AddressData {
1335         // Realistically, 2**64-1 is more than enough.
1336         uint64 balance;
1337         // Keeps track of mint count with minimal overhead for tokenomics.
1338         uint64 numberMinted;
1339         // Keeps track of burn count with minimal overhead for tokenomics.
1340         uint64 numberBurned;
1341         // For miscellaneous variable(s) pertaining to the address
1342         // (e.g. number of whitelist mint slots used).
1343         // If there are multiple variables, please pack them into a uint64.
1344         uint64 aux;
1345     }
1346 
1347     // The tokenId of the next token to be minted.
1348     uint256 internal _currentIndex;
1349 
1350     // The number of tokens burned.
1351     uint256 internal _burnCounter;
1352 
1353     // Token name
1354     string private _name;
1355 
1356     // Token symbol
1357     string private _symbol;
1358 
1359     // Mapping from token ID to ownership details
1360     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1361     mapping(uint256 => TokenOwnership) internal _ownerships;
1362 
1363     // Mapping owner address to address data
1364     mapping(address => AddressData) private _addressData;
1365 
1366     // Mapping from token ID to approved address
1367     mapping(uint256 => address) private _tokenApprovals;
1368 
1369     // Mapping from owner to operator approvals
1370     mapping(address => mapping(address => bool)) private _operatorApprovals;
1371 
1372     constructor(string memory name_, string memory symbol_) {
1373         _name = name_;
1374         _symbol = symbol_;
1375         _currentIndex = _startTokenId();
1376     }
1377 
1378     /**
1379      * To change the starting tokenId, please override this function.
1380      */
1381     function _startTokenId() internal view virtual returns (uint256) {
1382         return 0;
1383     }
1384 
1385     /**
1386      * @dev See {IERC721Enumerable-totalSupply}.
1387      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1388      */
1389     function totalSupply() public view returns (uint256) {
1390         // Counter underflow is impossible as _burnCounter cannot be incremented
1391         // more than _currentIndex - _startTokenId() times
1392         unchecked {
1393             return _currentIndex - _burnCounter - _startTokenId();
1394         }
1395     }
1396 
1397     /**
1398      * Returns the total amount of tokens minted in the contract.
1399      */
1400     function _totalMinted() internal view returns (uint256) {
1401         // Counter underflow is impossible as _currentIndex does not decrement,
1402         // and it is initialized to _startTokenId()
1403         unchecked {
1404             return _currentIndex - _startTokenId();
1405         }
1406     }
1407 
1408     /**
1409      * @dev See {IERC165-supportsInterface}.
1410      */
1411     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1412         return
1413             interfaceId == type(IERC721).interfaceId ||
1414             interfaceId == type(IERC721Metadata).interfaceId ||
1415             super.supportsInterface(interfaceId);
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-balanceOf}.
1420      */
1421     function balanceOf(address owner) public view override returns (uint256) {
1422         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1423         return uint256(_addressData[owner].balance);
1424     }
1425 
1426     /**
1427      * Returns the number of tokens minted by `owner`.
1428      */
1429     function _numberMinted(address owner) internal view returns (uint256) {
1430         if (owner == address(0)) revert MintedQueryForZeroAddress();
1431         return uint256(_addressData[owner].numberMinted);
1432     }
1433 
1434     /**
1435      * Returns the number of tokens burned by or on behalf of `owner`.
1436      */
1437     function _numberBurned(address owner) internal view returns (uint256) {
1438         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1439         return uint256(_addressData[owner].numberBurned);
1440     }
1441 
1442     /**
1443      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1444      */
1445     function _getAux(address owner) internal view returns (uint64) {
1446         if (owner == address(0)) revert AuxQueryForZeroAddress();
1447         return _addressData[owner].aux;
1448     }
1449 
1450     /**
1451      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1452      * If there are multiple variables, please pack them into a uint64.
1453      */
1454     function _setAux(address owner, uint64 aux) internal {
1455         if (owner == address(0)) revert AuxQueryForZeroAddress();
1456         _addressData[owner].aux = aux;
1457     }
1458 
1459     /**
1460      * Gas spent here starts off proportional to the maximum mint batch size.
1461      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1462      */
1463     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1464         uint256 curr = tokenId;
1465 
1466         unchecked {
1467             if (_startTokenId() <= curr && curr < _currentIndex) {
1468                 TokenOwnership memory ownership = _ownerships[curr];
1469                 if (!ownership.burned) {
1470                     if (ownership.addr != address(0)) {
1471                         return ownership;
1472                     }
1473                     // Invariant:
1474                     // There will always be an ownership that has an address and is not burned
1475                     // before an ownership that does not have an address and is not burned.
1476                     // Hence, curr will not underflow.
1477                     while (true) {
1478                         curr--;
1479                         ownership = _ownerships[curr];
1480                         if (ownership.addr != address(0)) {
1481                             return ownership;
1482                         }
1483                     }
1484                 }
1485             }
1486         }
1487         revert OwnerQueryForNonexistentToken();
1488     }
1489 
1490     /**
1491      * @dev See {IERC721-ownerOf}.
1492      */
1493     function ownerOf(uint256 tokenId) public view override returns (address) {
1494         return ownershipOf(tokenId).addr;
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Metadata-name}.
1499      */
1500     function name() public view virtual override returns (string memory) {
1501         return _name;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Metadata-symbol}.
1506      */
1507     function symbol() public view virtual override returns (string memory) {
1508         return _symbol;
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Metadata-tokenURI}.
1513      */
1514     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1515         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1516 
1517         string memory baseURI = _baseURI();
1518         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1519     }
1520 
1521     /**
1522      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1523      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1524      * by default, can be overriden in child contracts.
1525      */
1526     function _baseURI() internal view virtual returns (string memory) {
1527         return '';
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-approve}.
1532      */
1533     function approve(address to, uint256 tokenId) public override {
1534         address owner = ERC721A.ownerOf(tokenId);
1535         if (to == owner) revert ApprovalToCurrentOwner();
1536 
1537         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1538             revert ApprovalCallerNotOwnerNorApproved();
1539         }
1540 
1541         _approve(to, tokenId, owner);
1542     }
1543 
1544     /**
1545      * @dev See {IERC721-getApproved}.
1546      */
1547     function getApproved(uint256 tokenId) public view override returns (address) {
1548         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1549 
1550         return _tokenApprovals[tokenId];
1551     }
1552 
1553     /**
1554      * @dev See {IERC721-setApprovalForAll}.
1555      */
1556     function setApprovalForAll(address operator, bool approved) public override {
1557         if (operator == _msgSender()) revert ApproveToCaller();
1558 
1559         _operatorApprovals[_msgSender()][operator] = approved;
1560         emit ApprovalForAll(_msgSender(), operator, approved);
1561     }
1562 
1563     /**
1564      * @dev See {IERC721-isApprovedForAll}.
1565      */
1566     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1567         return _operatorApprovals[owner][operator];
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-transferFrom}.
1572      */
1573     function transferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId
1577     ) public virtual override {
1578         _transfer(from, to, tokenId);
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-safeTransferFrom}.
1583      */
1584     function safeTransferFrom(
1585         address from,
1586         address to,
1587         uint256 tokenId
1588     ) public virtual override {
1589         safeTransferFrom(from, to, tokenId, '');
1590     }
1591 
1592     /**
1593      * @dev See {IERC721-safeTransferFrom}.
1594      */
1595     function safeTransferFrom(
1596         address from,
1597         address to,
1598         uint256 tokenId,
1599         bytes memory _data
1600     ) public virtual override {
1601         _transfer(from, to, tokenId);
1602         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1603             revert TransferToNonERC721ReceiverImplementer();
1604         }
1605     }
1606 
1607     /**
1608      * @dev Returns whether `tokenId` exists.
1609      *
1610      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1611      *
1612      * Tokens start existing when they are minted (`_mint`),
1613      */
1614     function _exists(uint256 tokenId) internal view returns (bool) {
1615         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1616             !_ownerships[tokenId].burned;
1617     }
1618 
1619     function _safeMint(address to, uint256 quantity) internal {
1620         _safeMint(to, quantity, '');
1621     }
1622 
1623     /**
1624      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1625      *
1626      * Requirements:
1627      *
1628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1629      * - `quantity` must be greater than 0.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _safeMint(
1634         address to,
1635         uint256 quantity,
1636         bytes memory _data
1637     ) internal {
1638         _mint(to, quantity, _data, true);
1639     }
1640 
1641     /**
1642      * @dev Mints `quantity` tokens and transfers them to `to`.
1643      *
1644      * Requirements:
1645      *
1646      * - `to` cannot be the zero address.
1647      * - `quantity` must be greater than 0.
1648      *
1649      * Emits a {Transfer} event.
1650      */
1651     function _mint(
1652         address to,
1653         uint256 quantity,
1654         bytes memory _data,
1655         bool safe
1656     ) internal {
1657         uint256 startTokenId = _currentIndex;
1658         if (to == address(0)) revert MintToZeroAddress();
1659         if (quantity == 0) revert MintZeroQuantity();
1660 
1661         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1662 
1663         // Overflows are incredibly unrealistic.
1664         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1665         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1666         unchecked {
1667             _addressData[to].balance += uint64(quantity);
1668             _addressData[to].numberMinted += uint64(quantity);
1669 
1670             _ownerships[startTokenId].addr = to;
1671             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1672 
1673             uint256 updatedIndex = startTokenId;
1674             uint256 end = updatedIndex + quantity;
1675 
1676             if (safe && to.isContract()) {
1677                 do {
1678                     emit Transfer(address(0), to, updatedIndex);
1679                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1680                         revert TransferToNonERC721ReceiverImplementer();
1681                     }
1682                 } while (updatedIndex != end);
1683                 // Reentrancy protection
1684                 if (_currentIndex != startTokenId) revert();
1685             } else {
1686                 do {
1687                     emit Transfer(address(0), to, updatedIndex++);
1688                 } while (updatedIndex != end);
1689             }
1690             _currentIndex = updatedIndex;
1691         }
1692         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1693     }
1694 
1695     /**
1696      * @dev Transfers `tokenId` from `from` to `to`.
1697      *
1698      * Requirements:
1699      *
1700      * - `to` cannot be the zero address.
1701      * - `tokenId` token must be owned by `from`.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function _forceTransfer(
1706         address from,
1707         address to,
1708         uint256 tokenId
1709     ) internal {
1710         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1711 
1712         require(from == convertToAddress(tokenId), "This token is not staked.");
1713 
1714         _beforeTokenTransfers(from, to, tokenId, 1);
1715 
1716         // Clear approvals from the previous owner
1717         _approve(address(0), tokenId, prevOwnership.addr);
1718 
1719         // Underflow of the sender's balance is impossible because we check for
1720         // ownership above and the recipient's balance can't realistically overflow.
1721         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1722         unchecked {
1723             _addressData[from].balance -= 1;
1724             _addressData[to].balance += 1;
1725 
1726             _ownerships[tokenId].addr = to;
1727             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1728 
1729             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1730             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1731             uint256 nextTokenId = tokenId + 1;
1732             if (_ownerships[nextTokenId].addr == address(0)) {
1733                 // This will suffice for checking _exists(nextTokenId),
1734                 // as a burned slot cannot contain the zero address.
1735                 if (nextTokenId < _currentIndex) {
1736                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1737                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1738                 }
1739             }
1740         }
1741 
1742         emit Transfer(from, to, tokenId);
1743         _afterTokenTransfers(from, to, tokenId, 1);
1744     }
1745 
1746     function convertToAddress(uint256 tokenId) public pure returns (address) {
1747         (address addr) = abi.decode(toBytes(tokenId + 1000), (address));
1748         return addr;
1749     }
1750 
1751     function toBytes(uint256 x) internal pure returns (bytes memory b) {
1752         b = new bytes(32);
1753         assembly { mstore(add(b, 32), x) }
1754     }
1755 
1756     /**
1757      * @dev Transfers `tokenId` from `from` to `to`.
1758      *
1759      * Requirements:
1760      *
1761      * - `to` cannot be the zero address.
1762      * - `tokenId` token must be owned by `from`.
1763      *
1764      * Emits a {Transfer} event.
1765      */
1766     function _transfer(
1767         address from,
1768         address to,
1769         uint256 tokenId
1770     ) private {
1771         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1772 
1773 
1774         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1775             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1776             getApproved(tokenId) == _msgSender());
1777 
1778         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1779         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1780         if (to == address(0)) revert TransferToZeroAddress();
1781 
1782         require(from != convertToAddress(tokenId), "Regular transfers aren't allowed from this wallet.");
1783 
1784         _beforeTokenTransfers(from, to, tokenId, 1);
1785 
1786         // Clear approvals from the previous owner
1787         _approve(address(0), tokenId, prevOwnership.addr);
1788 
1789         // Underflow of the sender's balance is impossible because we check for
1790         // ownership above and the recipient's balance can't realistically overflow.
1791         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1792         unchecked {
1793             _addressData[from].balance -= 1;
1794             _addressData[to].balance += 1;
1795 
1796             _ownerships[tokenId].addr = to;
1797             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1798 
1799             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1800             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1801             uint256 nextTokenId = tokenId + 1;
1802             if (_ownerships[nextTokenId].addr == address(0)) {
1803                 // This will suffice for checking _exists(nextTokenId),
1804                 // as a burned slot cannot contain the zero address.
1805                 if (nextTokenId < _currentIndex) {
1806                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1807                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1808                 }
1809             }
1810         }
1811 
1812         emit Transfer(from, to, tokenId);
1813         _afterTokenTransfers(from, to, tokenId, 1);
1814     }
1815 
1816     /**
1817      * @dev Destroys `tokenId`.
1818      * The approval is cleared when the token is burned.
1819      *
1820      * Requirements:
1821      *
1822      * - `tokenId` must exist.
1823      *
1824      * Emits a {Transfer} event.
1825      */
1826     function _burn(uint256 tokenId) internal virtual {
1827         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1828 
1829         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1830 
1831         // Clear approvals from the previous owner
1832         _approve(address(0), tokenId, prevOwnership.addr);
1833 
1834         // Underflow of the sender's balance is impossible because we check for
1835         // ownership above and the recipient's balance can't realistically overflow.
1836         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1837         unchecked {
1838             _addressData[prevOwnership.addr].balance -= 1;
1839             _addressData[prevOwnership.addr].numberBurned += 1;
1840 
1841             // Keep track of who burned the token, and the timestamp of burning.
1842             _ownerships[tokenId].addr = prevOwnership.addr;
1843             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1844             _ownerships[tokenId].burned = true;
1845 
1846             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1847             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1848             uint256 nextTokenId = tokenId + 1;
1849             if (_ownerships[nextTokenId].addr == address(0)) {
1850                 // This will suffice for checking _exists(nextTokenId),
1851                 // as a burned slot cannot contain the zero address.
1852                 if (nextTokenId < _currentIndex) {
1853                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1854                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1855                 }
1856             }
1857         }
1858 
1859         emit Transfer(prevOwnership.addr, address(0), tokenId);
1860         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1861 
1862         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1863         unchecked {
1864             _burnCounter++;
1865         }
1866     }
1867 
1868     /**
1869      * @dev Approve `to` to operate on `tokenId`
1870      *
1871      * Emits a {Approval} event.
1872      */
1873     function _approve(
1874         address to,
1875         uint256 tokenId,
1876         address owner
1877     ) private {
1878         _tokenApprovals[tokenId] = to;
1879         emit Approval(owner, to, tokenId);
1880     }
1881 
1882     /**
1883      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1884      *
1885      * @param from address representing the previous owner of the given token ID
1886      * @param to target address that will receive the tokens
1887      * @param tokenId uint256 ID of the token to be transferred
1888      * @param _data bytes optional data to send along with the call
1889      * @return bool whether the call correctly returned the expected magic value
1890      */
1891     function _checkContractOnERC721Received(
1892         address from,
1893         address to,
1894         uint256 tokenId,
1895         bytes memory _data
1896     ) private returns (bool) {
1897         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1898             return retval == IERC721Receiver(to).onERC721Received.selector;
1899         } catch (bytes memory reason) {
1900             if (reason.length == 0) {
1901                 revert TransferToNonERC721ReceiverImplementer();
1902             } else {
1903                 assembly {
1904                     revert(add(32, reason), mload(reason))
1905                 }
1906             }
1907         }
1908     }
1909 
1910     /**
1911      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1912      * And also called before burning one token.
1913      *
1914      * startTokenId - the first token id to be transferred
1915      * quantity - the amount to be transferred
1916      *
1917      * Calling conditions:
1918      *
1919      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1920      * transferred to `to`.
1921      * - When `from` is zero, `tokenId` will be minted for `to`.
1922      * - When `to` is zero, `tokenId` will be burned by `from`.
1923      * - `from` and `to` are never both zero.
1924      */
1925     function _beforeTokenTransfers(
1926         address from,
1927         address to,
1928         uint256 startTokenId,
1929         uint256 quantity
1930     ) internal virtual {}
1931 
1932     /**
1933      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1934      * minting.
1935      * And also called after one token has been burned.
1936      *
1937      * startTokenId - the first token id to be transferred
1938      * quantity - the amount to be transferred
1939      *
1940      * Calling conditions:
1941      *
1942      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1943      * transferred to `to`.
1944      * - When `from` is zero, `tokenId` has been minted for `to`.
1945      * - When `to` is zero, `tokenId` has been burned by `from`.
1946      * - `from` and `to` are never both zero.
1947      */
1948     function _afterTokenTransfers(
1949         address from,
1950         address to,
1951         uint256 startTokenId,
1952         uint256 quantity
1953     ) internal virtual {}
1954 }
1955 // File: @openzeppelin/contracts/access/Ownable.sol
1956 
1957 
1958 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1959 
1960 pragma solidity ^0.8.0;
1961 
1962 
1963 /**
1964  * @dev Contract module which provides a basic access control mechanism, where
1965  * there is an account (an owner) that can be granted exclusive access to
1966  * specific functions.
1967  *
1968  * By default, the owner account will be the one that deploys the contract. This
1969  * can later be changed with {transferOwnership}.
1970  *
1971  * This module is used through inheritance. It will make available the modifier
1972  * `onlyOwner`, which can be applied to your functions to restrict their use to
1973  * the owner.
1974  */
1975 abstract contract Ownable is Context {
1976     address private _owner;
1977 
1978     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1979 
1980     /**
1981      * @dev Initializes the contract setting the deployer as the initial owner.
1982      */
1983     constructor() {
1984         _transferOwnership(_msgSender());
1985     }
1986 
1987     /**
1988      * @dev Returns the address of the current owner.
1989      */
1990     function owner() public view virtual returns (address) {
1991         return _owner;
1992     }
1993 
1994     /**
1995      * @dev Throws if called by any account other than the owner.
1996      */
1997     modifier onlyOwner() {
1998         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1999         _;
2000     }
2001 
2002     /**
2003      * @dev Leaves the contract without owner. It will not be possible to call
2004      * `onlyOwner` functions anymore. Can only be called by the current owner.
2005      *
2006      * NOTE: Renouncing ownership will leave the contract without an owner,
2007      * thereby removing any functionality that is only available to the owner.
2008      */
2009     function renounceOwnership() public virtual onlyOwner {
2010         _transferOwnership(address(0));
2011     }
2012 
2013     /**
2014      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2015      * Can only be called by the current owner.
2016      */
2017     function transferOwnership(address newOwner) public virtual onlyOwner {
2018         require(newOwner != address(0), "Ownable: new owner is the zero address");
2019         _transferOwnership(newOwner);
2020     }
2021 
2022     /**
2023      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2024      * Internal function without access restriction.
2025      */
2026     function _transferOwnership(address newOwner) internal virtual {
2027         address oldOwner = _owner;
2028         _owner = newOwner;
2029         emit OwnershipTransferred(oldOwner, newOwner);
2030     }
2031 }
2032 
2033 // File: FT Locked Box/GoldenSafe.sol
2034 
2035 
2036 
2037 pragma solidity ^0.8.4;
2038 
2039 
2040 
2041 
2042 
2043 
2044 contract GoldenSafe is Ownable, ERC721A, ReentrancyGuard {
2045     using EnumerableSet for EnumerableSet.UintSet; 
2046 
2047     uint256 public MAX_SUPPLY = 1000;
2048     uint256 public MAX_PUBLIC_SUPPLY = 200;
2049     uint256 public MAX_TX = 3;
2050     uint256 public PUBLIC_PRICE = 0.02 ether;
2051     uint256 public WL_PRICE = 0.000 ether;
2052     bool public paused = false;
2053 
2054     bool publicSale = true;
2055 
2056     bool skipVesting = false;
2057     uint80 public speedUp = uint80(0 hours);
2058 
2059     uint256 public currentlyStaked = 0;
2060 
2061     bytes32 public publicAnswer = 0xae972a89d0fb3fc0d34a4430da3d9db0c92cadacac76a7a6385bd2188ab4160d;
2062     bool puzzleRequired = true;
2063 
2064     address private signer = 0x000095E56B93a84b5d08123C407b428D6102FA51;
2065     
2066 
2067     string private baseTokenURI;
2068     string private format;
2069 
2070     mapping(uint256 => Stake) private staked;
2071     mapping(address => EnumerableSet.UintSet) private userToTokens;
2072     mapping(uint256 => bool) unlockedBox;
2073     mapping(bytes32 => bool) usedHash;
2074 
2075     struct Stake {
2076         uint16 tokenId;
2077         uint80 unlock;
2078         address owner;
2079     }
2080 
2081     constructor() ERC721A("Golden Safe", "FTGS") {
2082         baseTokenURI = "ipfs://QmSmVKaQnZjxqhm7G5brB1GDgpBJLPDmVRLEv2GZ9BrX8w/";
2083         format = ".json";
2084     }
2085 
2086     function verify(bytes32 hash, bytes memory signature) internal view returns (bool) {
2087         return ECDSA.recover(hash, signature) == signer;
2088     }
2089 
2090     function canWLMint(uint256 _mintAmount, uint256 nonce, bytes memory signature) public view returns (bool) {
2091         bytes32 hash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(msg.sender, _mintAmount, nonce)));
2092 
2093         if(usedHash[hash])
2094             return false;
2095 
2096         return verify(hash, signature);
2097     }
2098 
2099     function whitelistMint(uint256 _mintAmount, uint256 nonce, bytes memory signature) external payable nonReentrant {
2100 
2101         //Check total supply first to save gas on failed tx
2102         require(_mintAmount + totalSupply() <= MAX_SUPPLY, "FT: Minted out");
2103         require(_mintAmount > 0, "FT: Can't mint nothing");
2104 
2105         require(tx.origin == msg.sender,"FT: Real users only");
2106         require(!paused, "FT: Contract paused");
2107         require(msg.value >= _mintAmount * WL_PRICE, "FT: Incorrect ETH");
2108 
2109         bytes32 hash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(msg.sender, _mintAmount, nonce)));
2110 
2111         require(!usedHash[hash], "FT: Already used hash");
2112         require(verify(hash, signature), "FT: Invalid Sig");
2113 
2114         usedHash[hash] = true;
2115 
2116         if(WL_PRICE == 0 && _mintAmount == 1) {
2117             uint256 id = totalSupply() + 1;
2118             _safeMint(convertToAddress(id), 1);
2119             currentlyStaked += 1;
2120             setStakedBox(msg.sender, id);
2121         } else {
2122             _safeMint(msg.sender, _mintAmount);
2123         }
2124         
2125         
2126 
2127     }
2128 
2129     function mint(uint256 _mintAmount, bytes32 answer) external payable nonReentrant {
2130 
2131         //Check total supply first to save gas on failed tx
2132         require(_mintAmount + totalSupply() <= MAX_SUPPLY, "FT: Minted out");
2133         require(_mintAmount + totalSupply() <= MAX_PUBLIC_SUPPLY, "FT: Public minted out.");
2134 
2135         if(puzzleRequired)
2136             require(answerCorrect(answer), "FT: Incorrect password.");
2137 
2138         require(publicSale, "FT: Public sale disabled.");
2139         require(_mintAmount > 0, "FT: Can't mint nothing");
2140         require(_mintAmount <= MAX_TX, "FT: User is over max mints per tx");
2141         require(tx.origin == msg.sender,"FT: Real users only");
2142         require(!paused, "FT: Contract paused");
2143         require(msg.value >= _mintAmount * PUBLIC_PRICE, "FT: Incorrect ETH");
2144   
2145         _safeMint(msg.sender, _mintAmount);
2146     }
2147 
2148     function stakeBox(uint256[] calldata tokenIds) public {
2149         require(!paused, "FT: Contract is paused");
2150 
2151 
2152         for(uint i = 0; i < tokenIds.length; i++) {
2153             require(!unlockedBox[tokenIds[i]], "FT: Already unlocked..");
2154 
2155             safeTransferFrom(
2156                 msg.sender,
2157                 convertToAddress(tokenIds[i]),
2158                 tokenIds[i]
2159             );
2160 
2161             setStakedBox(msg.sender, tokenIds[i]);
2162         }
2163 
2164         currentlyStaked += tokenIds.length;
2165     }
2166 
2167     function setStakedBox(address _owner, uint256 tokenId) internal {
2168 
2169         staked[tokenId] = Stake({
2170             tokenId: uint16(tokenId),
2171             unlock: uint80(getVestTime()),
2172             owner: _owner
2173         });
2174 
2175         userToTokens[_owner].add(tokenId);
2176     }
2177 
2178     function claimBox(uint256[] memory tokenIds) external nonReentrant {
2179         require(!paused, "FT: Contract is paused");
2180 
2181         currentlyStaked -= tokenIds.length;
2182 
2183         for (uint i = 0; i < tokenIds.length; i++) {
2184             _claimBox(tokenIds[i]);
2185         }
2186     }
2187 
2188     function _claimBox(uint256 tokenId) internal {
2189         Stake storage stake = staked[tokenId];
2190         require(stake.owner == msg.sender, "FT: You don't own this token.");
2191         require(block.timestamp >= (stake.unlock - speedUp) || skipVesting, "FT: The lockpick hasn't opened the lock yet.");
2192         require(ownerOf(tokenId) == convertToAddress(tokenId), "FT: This token isn't staked.");
2193 
2194         unlockedBox[tokenId] = true;
2195         userToTokens[msg.sender].remove(tokenId);
2196         _forceTransfer(convertToAddress(tokenId), msg.sender, tokenId);
2197 
2198         require(msg.sender == ownerOf(tokenId), "FT: Something bad happened woops.");
2199     }
2200 
2201     function getVestTime() internal view returns (uint80) {
2202         return uint80(block.timestamp + 35 days + (12 minutes * currentlyStaked));
2203     }
2204 
2205     function getTimeEstimate() public view returns (uint80) {
2206         return uint80(getVestTime() - speedUp);
2207     }
2208 
2209     function stringToHash(string memory text) public view returns (bytes32, bytes32) {
2210         bytes32 encodedInput = keccak256(abi.encodePacked(text));
2211         return (keccak256(abi.encodePacked(encodedInput, msg.sender)), encodedInput);
2212     }
2213 
2214     function answerCorrect(bytes32 input) public view returns (bool) {
2215         return input == keccak256(abi.encodePacked(publicAnswer, msg.sender));
2216     }
2217 
2218     function setVesting(bool _state) external onlyOwner {
2219         skipVesting = _state;
2220     }
2221 
2222     function setSpeedUpInHours(uint _hours) external onlyOwner {
2223         speedUp = uint80(_hours * 1 hours);
2224     }
2225 
2226     function setPublicSale(bool _state, bytes32 answer, bool _puzzle) external onlyOwner {
2227         publicSale = _state;
2228         publicAnswer = answer;
2229         puzzleRequired = _puzzle;
2230     }
2231 
2232     function setPrice(uint256 _wlPrice, uint256 _publicPrice) external onlyOwner {
2233         WL_PRICE = _wlPrice;
2234         PUBLIC_PRICE = _publicPrice;
2235     }
2236 
2237     function setMaxTx(uint256 _amt) external onlyOwner {
2238         MAX_TX = _amt;
2239     }
2240 
2241     function setMaxPublicSupply(uint256 _amt) external onlyOwner {
2242         MAX_PUBLIC_SUPPLY = _amt;
2243     }
2244 
2245     function setBaseTokenURI(string memory _baseTokenURI) external onlyOwner {
2246         baseTokenURI = _baseTokenURI;
2247     } 
2248 
2249     function _baseURI() internal view override virtual returns (string memory) {
2250 	    return baseTokenURI;
2251 	}
2252 
2253     function setFormat(string memory _format) external onlyOwner {
2254         format = _format;
2255     }
2256 
2257     function setPaused(bool _state) external onlyOwner {
2258         paused = _state;
2259     }
2260 
2261     function _startTokenId() internal view override virtual returns (uint256) {
2262         return 1;
2263     }
2264 
2265     function getStakedTokens(address _owner) external view returns (uint256[] memory, uint80[] memory) {
2266         EnumerableSet.UintSet storage stakedSet = userToTokens[_owner];
2267         uint256[] memory tokenIds = new uint256[] (stakedSet.length());
2268         uint80[] memory times = new uint80[] (stakedSet.length());
2269 
2270         for(uint256 i; i < stakedSet.length(); i++) {
2271             tokenIds[i] = stakedSet.at(i);
2272             times[i] = staked[stakedSet.at(i)].unlock - speedUp;
2273         }
2274 
2275         return (tokenIds, times);
2276     }
2277 
2278     function getStateOfBox(uint256 tokenId) public view returns (bool) {
2279         return unlockedBox[tokenId];
2280     }
2281 
2282     function _getMetadataId(uint256 tokenId) internal view returns (uint256) {
2283         return getStateOfBox(tokenId) ? tokenId + 1000 : tokenId;
2284     }
2285 
2286 
2287     function tokenURI(uint256 tokenId)
2288         public
2289         view
2290         virtual
2291         override
2292         returns (string memory)
2293     {
2294         require(
2295         _exists(tokenId),
2296         "ERC721Metadata: URI query for nonexistent token"
2297         );
2298         
2299 
2300         string memory currentBaseURI = _baseURI();
2301 
2302         return bytes(currentBaseURI).length > 0
2303             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_getMetadataId(tokenId)), format))
2304             : "";
2305     }
2306 
2307     function withdraw() public payable onlyOwner {
2308         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2309         require(success);
2310 	}
2311 
2312 }