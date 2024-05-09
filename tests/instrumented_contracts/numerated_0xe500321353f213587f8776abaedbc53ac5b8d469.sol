1 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
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
31  *
32  * [WARNING]
33  * ====
34  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
35  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
36  *
37  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
38  * ====
39  */
40 library EnumerableSet {
41     // To implement this library for multiple types with as little code
42     // repetition as possible, we write it in terms of a generic Set type with
43     // bytes32 values.
44     // The Set implementation uses private functions, and user-facing
45     // implementations (such as AddressSet) are just wrappers around the
46     // underlying Set.
47     // This means that we can only create new EnumerableSets for types that fit
48     // in bytes32.
49 
50     struct Set {
51         // Storage of set values
52         bytes32[] _values;
53         // Position of the value in the `values` array, plus 1 because index 0
54         // means a value is not in the set.
55         mapping(bytes32 => uint256) _indexes;
56     }
57 
58     /**
59      * @dev Add a value to a set. O(1).
60      *
61      * Returns true if the value was added to the set, that is if it was not
62      * already present.
63      */
64     function _add(Set storage set, bytes32 value) private returns (bool) {
65         if (!_contains(set, value)) {
66             set._values.push(value);
67             // The value is stored at length-1, but we add 1 to all indexes
68             // and use 0 as a sentinel value
69             set._indexes[value] = set._values.length;
70             return true;
71         } else {
72             return false;
73         }
74     }
75 
76     /**
77      * @dev Removes a value from a set. O(1).
78      *
79      * Returns true if the value was removed from the set, that is if it was
80      * present.
81      */
82     function _remove(Set storage set, bytes32 value) private returns (bool) {
83         // We read and store the value's index to prevent multiple reads from the same storage slot
84         uint256 valueIndex = set._indexes[value];
85 
86         if (valueIndex != 0) {
87             // Equivalent to contains(set, value)
88             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
89             // the array, and then remove the last element (sometimes called as 'swap and pop').
90             // This modifies the order of the array, as noted in {at}.
91 
92             uint256 toDeleteIndex = valueIndex - 1;
93             uint256 lastIndex = set._values.length - 1;
94 
95             if (lastIndex != toDeleteIndex) {
96                 bytes32 lastValue = set._values[lastIndex];
97 
98                 // Move the last value to the index where the value to delete is
99                 set._values[toDeleteIndex] = lastValue;
100                 // Update the index for the moved value
101                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
102             }
103 
104             // Delete the slot where the moved value was stored
105             set._values.pop();
106 
107             // Delete the index for the deleted slot
108             delete set._indexes[value];
109 
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     /**
117      * @dev Returns true if the value is in the set. O(1).
118      */
119     function _contains(Set storage set, bytes32 value) private view returns (bool) {
120         return set._indexes[value] != 0;
121     }
122 
123     /**
124      * @dev Returns the number of values on the set. O(1).
125      */
126     function _length(Set storage set) private view returns (uint256) {
127         return set._values.length;
128     }
129 
130     /**
131      * @dev Returns the value stored at position `index` in the set. O(1).
132      *
133      * Note that there are no guarantees on the ordering of values inside the
134      * array, and it may change when more values are added or removed.
135      *
136      * Requirements:
137      *
138      * - `index` must be strictly less than {length}.
139      */
140     function _at(Set storage set, uint256 index) private view returns (bytes32) {
141         return set._values[index];
142     }
143 
144     /**
145      * @dev Return the entire set in an array
146      *
147      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
148      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
149      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
150      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
151      */
152     function _values(Set storage set) private view returns (bytes32[] memory) {
153         return set._values;
154     }
155 
156     // Bytes32Set
157 
158     struct Bytes32Set {
159         Set _inner;
160     }
161 
162     /**
163      * @dev Add a value to a set. O(1).
164      *
165      * Returns true if the value was added to the set, that is if it was not
166      * already present.
167      */
168     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
169         return _add(set._inner, value);
170     }
171 
172     /**
173      * @dev Removes a value from a set. O(1).
174      *
175      * Returns true if the value was removed from the set, that is if it was
176      * present.
177      */
178     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
179         return _remove(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns true if the value is in the set. O(1).
184      */
185     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
186         return _contains(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns the number of values in the set. O(1).
191      */
192     function length(Bytes32Set storage set) internal view returns (uint256) {
193         return _length(set._inner);
194     }
195 
196     /**
197      * @dev Returns the value stored at position `index` in the set. O(1).
198      *
199      * Note that there are no guarantees on the ordering of values inside the
200      * array, and it may change when more values are added or removed.
201      *
202      * Requirements:
203      *
204      * - `index` must be strictly less than {length}.
205      */
206     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
207         return _at(set._inner, index);
208     }
209 
210     /**
211      * @dev Return the entire set in an array
212      *
213      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
214      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
215      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
216      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
217      */
218     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
219         return _values(set._inner);
220     }
221 
222     // AddressSet
223 
224     struct AddressSet {
225         Set _inner;
226     }
227 
228     /**
229      * @dev Add a value to a set. O(1).
230      *
231      * Returns true if the value was added to the set, that is if it was not
232      * already present.
233      */
234     function add(AddressSet storage set, address value) internal returns (bool) {
235         return _add(set._inner, bytes32(uint256(uint160(value))));
236     }
237 
238     /**
239      * @dev Removes a value from a set. O(1).
240      *
241      * Returns true if the value was removed from the set, that is if it was
242      * present.
243      */
244     function remove(AddressSet storage set, address value) internal returns (bool) {
245         return _remove(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns true if the value is in the set. O(1).
250      */
251     function contains(AddressSet storage set, address value) internal view returns (bool) {
252         return _contains(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     /**
256      * @dev Returns the number of values in the set. O(1).
257      */
258     function length(AddressSet storage set) internal view returns (uint256) {
259         return _length(set._inner);
260     }
261 
262     /**
263      * @dev Returns the value stored at position `index` in the set. O(1).
264      *
265      * Note that there are no guarantees on the ordering of values inside the
266      * array, and it may change when more values are added or removed.
267      *
268      * Requirements:
269      *
270      * - `index` must be strictly less than {length}.
271      */
272     function at(AddressSet storage set, uint256 index) internal view returns (address) {
273         return address(uint160(uint256(_at(set._inner, index))));
274     }
275 
276     /**
277      * @dev Return the entire set in an array
278      *
279      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
280      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
281      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
282      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
283      */
284     function values(AddressSet storage set) internal view returns (address[] memory) {
285         bytes32[] memory store = _values(set._inner);
286         address[] memory result;
287 
288         /// @solidity memory-safe-assembly
289         assembly {
290             result := store
291         }
292 
293         return result;
294     }
295 
296     // UintSet
297 
298     struct UintSet {
299         Set _inner;
300     }
301 
302     /**
303      * @dev Add a value to a set. O(1).
304      *
305      * Returns true if the value was added to the set, that is if it was not
306      * already present.
307      */
308     function add(UintSet storage set, uint256 value) internal returns (bool) {
309         return _add(set._inner, bytes32(value));
310     }
311 
312     /**
313      * @dev Removes a value from a set. O(1).
314      *
315      * Returns true if the value was removed from the set, that is if it was
316      * present.
317      */
318     function remove(UintSet storage set, uint256 value) internal returns (bool) {
319         return _remove(set._inner, bytes32(value));
320     }
321 
322     /**
323      * @dev Returns true if the value is in the set. O(1).
324      */
325     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
326         return _contains(set._inner, bytes32(value));
327     }
328 
329     /**
330      * @dev Returns the number of values on the set. O(1).
331      */
332     function length(UintSet storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336     /**
337      * @dev Returns the value stored at position `index` in the set. O(1).
338      *
339      * Note that there are no guarantees on the ordering of values inside the
340      * array, and it may change when more values are added or removed.
341      *
342      * Requirements:
343      *
344      * - `index` must be strictly less than {length}.
345      */
346     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
347         return uint256(_at(set._inner, index));
348     }
349 
350     /**
351      * @dev Return the entire set in an array
352      *
353      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
354      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
355      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
356      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
357      */
358     function values(UintSet storage set) internal view returns (uint256[] memory) {
359         bytes32[] memory store = _values(set._inner);
360         uint256[] memory result;
361 
362         /// @solidity memory-safe-assembly
363         assembly {
364             result := store
365         }
366 
367         return result;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/Counters.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @title Counters
380  * @author Matt Condon (@shrugs)
381  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
382  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
383  *
384  * Include with `using Counters for Counters.Counter;`
385  */
386 library Counters {
387     struct Counter {
388         // This variable should never be directly accessed by users of the library: interactions must be restricted to
389         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
390         // this feature: see https://github.com/ethereum/solidity/issues/4637
391         uint256 _value; // default: 0
392     }
393 
394     function current(Counter storage counter) internal view returns (uint256) {
395         return counter._value;
396     }
397 
398     function increment(Counter storage counter) internal {
399         unchecked {
400             counter._value += 1;
401         }
402     }
403 
404     function decrement(Counter storage counter) internal {
405         uint256 value = counter._value;
406         require(value > 0, "Counter: decrement overflow");
407         unchecked {
408             counter._value = value - 1;
409         }
410     }
411 
412     function reset(Counter storage counter) internal {
413         counter._value = 0;
414     }
415 }
416 
417 // File: @openzeppelin/contracts/utils/Strings.sol
418 
419 
420 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev String operations.
426  */
427 library Strings {
428     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
429     uint8 private constant _ADDRESS_LENGTH = 20;
430 
431     /**
432      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
433      */
434     function toString(uint256 value) internal pure returns (string memory) {
435         // Inspired by OraclizeAPI's implementation - MIT licence
436         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
437 
438         if (value == 0) {
439             return "0";
440         }
441         uint256 temp = value;
442         uint256 digits;
443         while (temp != 0) {
444             digits++;
445             temp /= 10;
446         }
447         bytes memory buffer = new bytes(digits);
448         while (value != 0) {
449             digits -= 1;
450             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
451             value /= 10;
452         }
453         return string(buffer);
454     }
455 
456     /**
457      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
458      */
459     function toHexString(uint256 value) internal pure returns (string memory) {
460         if (value == 0) {
461             return "0x00";
462         }
463         uint256 temp = value;
464         uint256 length = 0;
465         while (temp != 0) {
466             length++;
467             temp >>= 8;
468         }
469         return toHexString(value, length);
470     }
471 
472     /**
473      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
474      */
475     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
476         bytes memory buffer = new bytes(2 * length + 2);
477         buffer[0] = "0";
478         buffer[1] = "x";
479         for (uint256 i = 2 * length + 1; i > 1; --i) {
480             buffer[i] = _HEX_SYMBOLS[value & 0xf];
481             value >>= 4;
482         }
483         require(value == 0, "Strings: hex length insufficient");
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
489      */
490     function toHexString(address addr) internal pure returns (string memory) {
491         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
492     }
493 }
494 
495 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
496 
497 
498 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
505  *
506  * These functions can be used to verify that a message was signed by the holder
507  * of the private keys of a given address.
508  */
509 library ECDSA {
510     enum RecoverError {
511         NoError,
512         InvalidSignature,
513         InvalidSignatureLength,
514         InvalidSignatureS,
515         InvalidSignatureV
516     }
517 
518     function _throwError(RecoverError error) private pure {
519         if (error == RecoverError.NoError) {
520             return; // no error: do nothing
521         } else if (error == RecoverError.InvalidSignature) {
522             revert("ECDSA: invalid signature");
523         } else if (error == RecoverError.InvalidSignatureLength) {
524             revert("ECDSA: invalid signature length");
525         } else if (error == RecoverError.InvalidSignatureS) {
526             revert("ECDSA: invalid signature 's' value");
527         } else if (error == RecoverError.InvalidSignatureV) {
528             revert("ECDSA: invalid signature 'v' value");
529         }
530     }
531 
532     /**
533      * @dev Returns the address that signed a hashed message (`hash`) with
534      * `signature` or error string. This address can then be used for verification purposes.
535      *
536      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
537      * this function rejects them by requiring the `s` value to be in the lower
538      * half order, and the `v` value to be either 27 or 28.
539      *
540      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
541      * verification to be secure: it is possible to craft signatures that
542      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
543      * this is by receiving a hash of the original message (which may otherwise
544      * be too long), and then calling {toEthSignedMessageHash} on it.
545      *
546      * Documentation for signature generation:
547      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
548      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
549      *
550      * _Available since v4.3._
551      */
552     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
553         if (signature.length == 65) {
554             bytes32 r;
555             bytes32 s;
556             uint8 v;
557             // ecrecover takes the signature parameters, and the only way to get them
558             // currently is to use assembly.
559             /// @solidity memory-safe-assembly
560             assembly {
561                 r := mload(add(signature, 0x20))
562                 s := mload(add(signature, 0x40))
563                 v := byte(0, mload(add(signature, 0x60)))
564             }
565             return tryRecover(hash, v, r, s);
566         } else {
567             return (address(0), RecoverError.InvalidSignatureLength);
568         }
569     }
570 
571     /**
572      * @dev Returns the address that signed a hashed message (`hash`) with
573      * `signature`. This address can then be used for verification purposes.
574      *
575      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
576      * this function rejects them by requiring the `s` value to be in the lower
577      * half order, and the `v` value to be either 27 or 28.
578      *
579      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
580      * verification to be secure: it is possible to craft signatures that
581      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
582      * this is by receiving a hash of the original message (which may otherwise
583      * be too long), and then calling {toEthSignedMessageHash} on it.
584      */
585     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
586         (address recovered, RecoverError error) = tryRecover(hash, signature);
587         _throwError(error);
588         return recovered;
589     }
590 
591     /**
592      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
593      *
594      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
595      *
596      * _Available since v4.3._
597      */
598     function tryRecover(
599         bytes32 hash,
600         bytes32 r,
601         bytes32 vs
602     ) internal pure returns (address, RecoverError) {
603         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
604         uint8 v = uint8((uint256(vs) >> 255) + 27);
605         return tryRecover(hash, v, r, s);
606     }
607 
608     /**
609      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
610      *
611      * _Available since v4.2._
612      */
613     function recover(
614         bytes32 hash,
615         bytes32 r,
616         bytes32 vs
617     ) internal pure returns (address) {
618         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
619         _throwError(error);
620         return recovered;
621     }
622 
623     /**
624      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
625      * `r` and `s` signature fields separately.
626      *
627      * _Available since v4.3._
628      */
629     function tryRecover(
630         bytes32 hash,
631         uint8 v,
632         bytes32 r,
633         bytes32 s
634     ) internal pure returns (address, RecoverError) {
635         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
636         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
637         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
638         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
639         //
640         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
641         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
642         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
643         // these malleable signatures as well.
644         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
645             return (address(0), RecoverError.InvalidSignatureS);
646         }
647         if (v != 27 && v != 28) {
648             return (address(0), RecoverError.InvalidSignatureV);
649         }
650 
651         // If the signature is valid (and not malleable), return the signer address
652         address signer = ecrecover(hash, v, r, s);
653         if (signer == address(0)) {
654             return (address(0), RecoverError.InvalidSignature);
655         }
656 
657         return (signer, RecoverError.NoError);
658     }
659 
660     /**
661      * @dev Overload of {ECDSA-recover} that receives the `v`,
662      * `r` and `s` signature fields separately.
663      */
664     function recover(
665         bytes32 hash,
666         uint8 v,
667         bytes32 r,
668         bytes32 s
669     ) internal pure returns (address) {
670         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
671         _throwError(error);
672         return recovered;
673     }
674 
675     /**
676      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
677      * produces hash corresponding to the one signed with the
678      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
679      * JSON-RPC method as part of EIP-191.
680      *
681      * See {recover}.
682      */
683     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
684         // 32 is the length in bytes of hash,
685         // enforced by the type signature above
686         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
687     }
688 
689     /**
690      * @dev Returns an Ethereum Signed Message, created from `s`. This
691      * produces hash corresponding to the one signed with the
692      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
693      * JSON-RPC method as part of EIP-191.
694      *
695      * See {recover}.
696      */
697     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
698         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
699     }
700 
701     /**
702      * @dev Returns an Ethereum Signed Typed Data, created from a
703      * `domainSeparator` and a `structHash`. This produces hash corresponding
704      * to the one signed with the
705      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
706      * JSON-RPC method as part of EIP-712.
707      *
708      * See {recover}.
709      */
710     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
711         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
712     }
713 }
714 
715 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
725  *
726  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
727  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
728  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
729  *
730  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
731  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
732  * ({_hashTypedDataV4}).
733  *
734  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
735  * the chain id to protect against replay attacks on an eventual fork of the chain.
736  *
737  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
738  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
739  *
740  * _Available since v3.4._
741  */
742 abstract contract EIP712 {
743     /* solhint-disable var-name-mixedcase */
744     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
745     // invalidate the cached domain separator if the chain id changes.
746     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
747     uint256 private immutable _CACHED_CHAIN_ID;
748     address private immutable _CACHED_THIS;
749 
750     bytes32 private immutable _HASHED_NAME;
751     bytes32 private immutable _HASHED_VERSION;
752     bytes32 private immutable _TYPE_HASH;
753 
754     /* solhint-enable var-name-mixedcase */
755 
756     /**
757      * @dev Initializes the domain separator and parameter caches.
758      *
759      * The meaning of `name` and `version` is specified in
760      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
761      *
762      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
763      * - `version`: the current major version of the signing domain.
764      *
765      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
766      * contract upgrade].
767      */
768     constructor(string memory name, string memory version) {
769         bytes32 hashedName = keccak256(bytes(name));
770         bytes32 hashedVersion = keccak256(bytes(version));
771         bytes32 typeHash = keccak256(
772             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
773         );
774         _HASHED_NAME = hashedName;
775         _HASHED_VERSION = hashedVersion;
776         _CACHED_CHAIN_ID = block.chainid;
777         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
778         _CACHED_THIS = address(this);
779         _TYPE_HASH = typeHash;
780     }
781 
782     /**
783      * @dev Returns the domain separator for the current chain.
784      */
785     function _domainSeparatorV4() internal view returns (bytes32) {
786         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
787             return _CACHED_DOMAIN_SEPARATOR;
788         } else {
789             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
790         }
791     }
792 
793     function _buildDomainSeparator(
794         bytes32 typeHash,
795         bytes32 nameHash,
796         bytes32 versionHash
797     ) private view returns (bytes32) {
798         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
799     }
800 
801     /**
802      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
803      * function returns the hash of the fully encoded EIP712 message for this domain.
804      *
805      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
806      *
807      * ```solidity
808      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
809      *     keccak256("Mail(address to,string contents)"),
810      *     mailTo,
811      *     keccak256(bytes(mailContents))
812      * )));
813      * address signer = ECDSA.recover(digest, signature);
814      * ```
815      */
816     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
817         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
818     }
819 }
820 
821 // File: @openzeppelin/contracts/utils/Context.sol
822 
823 
824 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
825 
826 pragma solidity ^0.8.0;
827 
828 /**
829  * @dev Provides information about the current execution context, including the
830  * sender of the transaction and its data. While these are generally available
831  * via msg.sender and msg.data, they should not be accessed in such a direct
832  * manner, since when dealing with meta-transactions the account sending and
833  * paying for execution may not be the actual sender (as far as an application
834  * is concerned).
835  *
836  * This contract is only required for intermediate, library-like contracts.
837  */
838 abstract contract Context {
839     function _msgSender() internal view virtual returns (address) {
840         return msg.sender;
841     }
842 
843     function _msgData() internal view virtual returns (bytes calldata) {
844         return msg.data;
845     }
846 }
847 
848 // File: @openzeppelin/contracts/access/Ownable.sol
849 
850 
851 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 
856 /**
857  * @dev Contract module which provides a basic access control mechanism, where
858  * there is an account (an owner) that can be granted exclusive access to
859  * specific functions.
860  *
861  * By default, the owner account will be the one that deploys the contract. This
862  * can later be changed with {transferOwnership}.
863  *
864  * This module is used through inheritance. It will make available the modifier
865  * `onlyOwner`, which can be applied to your functions to restrict their use to
866  * the owner.
867  */
868 abstract contract Ownable is Context {
869     address private _owner;
870 
871     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
872 
873     /**
874      * @dev Initializes the contract setting the deployer as the initial owner.
875      */
876     constructor() {
877         _transferOwnership(_msgSender());
878     }
879 
880     /**
881      * @dev Throws if called by any account other than the owner.
882      */
883     modifier onlyOwner() {
884         _checkOwner();
885         _;
886     }
887 
888     /**
889      * @dev Returns the address of the current owner.
890      */
891     function owner() public view virtual returns (address) {
892         return _owner;
893     }
894 
895     /**
896      * @dev Throws if the sender is not the owner.
897      */
898     function _checkOwner() internal view virtual {
899         require(owner() == _msgSender(), "Ownable: caller is not the owner");
900     }
901 
902     /**
903      * @dev Leaves the contract without owner. It will not be possible to call
904      * `onlyOwner` functions anymore. Can only be called by the current owner.
905      *
906      * NOTE: Renouncing ownership will leave the contract without an owner,
907      * thereby removing any functionality that is only available to the owner.
908      */
909     function renounceOwnership() public virtual onlyOwner {
910         _transferOwnership(address(0));
911     }
912 
913     /**
914      * @dev Transfers ownership of the contract to a new account (`newOwner`).
915      * Can only be called by the current owner.
916      */
917     function transferOwnership(address newOwner) public virtual onlyOwner {
918         require(newOwner != address(0), "Ownable: new owner is the zero address");
919         _transferOwnership(newOwner);
920     }
921 
922     /**
923      * @dev Transfers ownership of the contract to a new account (`newOwner`).
924      * Internal function without access restriction.
925      */
926     function _transferOwnership(address newOwner) internal virtual {
927         address oldOwner = _owner;
928         _owner = newOwner;
929         emit OwnershipTransferred(oldOwner, newOwner);
930     }
931 }
932 
933 // File: @openzeppelin/contracts/utils/Address.sol
934 
935 
936 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
937 
938 pragma solidity ^0.8.1;
939 
940 /**
941  * @dev Collection of functions related to the address type
942  */
943 library Address {
944     /**
945      * @dev Returns true if `account` is a contract.
946      *
947      * [IMPORTANT]
948      * ====
949      * It is unsafe to assume that an address for which this function returns
950      * false is an externally-owned account (EOA) and not a contract.
951      *
952      * Among others, `isContract` will return false for the following
953      * types of addresses:
954      *
955      *  - an externally-owned account
956      *  - a contract in construction
957      *  - an address where a contract will be created
958      *  - an address where a contract lived, but was destroyed
959      * ====
960      *
961      * [IMPORTANT]
962      * ====
963      * You shouldn't rely on `isContract` to protect against flash loan attacks!
964      *
965      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
966      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
967      * constructor.
968      * ====
969      */
970     function isContract(address account) internal view returns (bool) {
971         // This method relies on extcodesize/address.code.length, which returns 0
972         // for contracts in construction, since the code is only stored at the end
973         // of the constructor execution.
974 
975         return account.code.length > 0;
976     }
977 
978     /**
979      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
980      * `recipient`, forwarding all available gas and reverting on errors.
981      *
982      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
983      * of certain opcodes, possibly making contracts go over the 2300 gas limit
984      * imposed by `transfer`, making them unable to receive funds via
985      * `transfer`. {sendValue} removes this limitation.
986      *
987      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
988      *
989      * IMPORTANT: because control is transferred to `recipient`, care must be
990      * taken to not create reentrancy vulnerabilities. Consider using
991      * {ReentrancyGuard} or the
992      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
993      */
994     function sendValue(address payable recipient, uint256 amount) internal {
995         require(address(this).balance >= amount, "Address: insufficient balance");
996 
997         (bool success, ) = recipient.call{value: amount}("");
998         require(success, "Address: unable to send value, recipient may have reverted");
999     }
1000 
1001     /**
1002      * @dev Performs a Solidity function call using a low level `call`. A
1003      * plain `call` is an unsafe replacement for a function call: use this
1004      * function instead.
1005      *
1006      * If `target` reverts with a revert reason, it is bubbled up by this
1007      * function (like regular Solidity function calls).
1008      *
1009      * Returns the raw returned data. To convert to the expected return value,
1010      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1011      *
1012      * Requirements:
1013      *
1014      * - `target` must be a contract.
1015      * - calling `target` with `data` must not revert.
1016      *
1017      * _Available since v3.1._
1018      */
1019     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1020         return functionCall(target, data, "Address: low-level call failed");
1021     }
1022 
1023     /**
1024      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1025      * `errorMessage` as a fallback revert reason when `target` reverts.
1026      *
1027      * _Available since v3.1._
1028      */
1029     function functionCall(
1030         address target,
1031         bytes memory data,
1032         string memory errorMessage
1033     ) internal returns (bytes memory) {
1034         return functionCallWithValue(target, data, 0, errorMessage);
1035     }
1036 
1037     /**
1038      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1039      * but also transferring `value` wei to `target`.
1040      *
1041      * Requirements:
1042      *
1043      * - the calling contract must have an ETH balance of at least `value`.
1044      * - the called Solidity function must be `payable`.
1045      *
1046      * _Available since v3.1._
1047      */
1048     function functionCallWithValue(
1049         address target,
1050         bytes memory data,
1051         uint256 value
1052     ) internal returns (bytes memory) {
1053         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1054     }
1055 
1056     /**
1057      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1058      * with `errorMessage` as a fallback revert reason when `target` reverts.
1059      *
1060      * _Available since v3.1._
1061      */
1062     function functionCallWithValue(
1063         address target,
1064         bytes memory data,
1065         uint256 value,
1066         string memory errorMessage
1067     ) internal returns (bytes memory) {
1068         require(address(this).balance >= value, "Address: insufficient balance for call");
1069         require(isContract(target), "Address: call to non-contract");
1070 
1071         (bool success, bytes memory returndata) = target.call{value: value}(data);
1072         return verifyCallResult(success, returndata, errorMessage);
1073     }
1074 
1075     /**
1076      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1077      * but performing a static call.
1078      *
1079      * _Available since v3.3._
1080      */
1081     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1082         return functionStaticCall(target, data, "Address: low-level static call failed");
1083     }
1084 
1085     /**
1086      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1087      * but performing a static call.
1088      *
1089      * _Available since v3.3._
1090      */
1091     function functionStaticCall(
1092         address target,
1093         bytes memory data,
1094         string memory errorMessage
1095     ) internal view returns (bytes memory) {
1096         require(isContract(target), "Address: static call to non-contract");
1097 
1098         (bool success, bytes memory returndata) = target.staticcall(data);
1099         return verifyCallResult(success, returndata, errorMessage);
1100     }
1101 
1102     /**
1103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1104      * but performing a delegate call.
1105      *
1106      * _Available since v3.4._
1107      */
1108     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1109         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1114      * but performing a delegate call.
1115      *
1116      * _Available since v3.4._
1117      */
1118     function functionDelegateCall(
1119         address target,
1120         bytes memory data,
1121         string memory errorMessage
1122     ) internal returns (bytes memory) {
1123         require(isContract(target), "Address: delegate call to non-contract");
1124 
1125         (bool success, bytes memory returndata) = target.delegatecall(data);
1126         return verifyCallResult(success, returndata, errorMessage);
1127     }
1128 
1129     /**
1130      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1131      * revert reason using the provided one.
1132      *
1133      * _Available since v4.3._
1134      */
1135     function verifyCallResult(
1136         bool success,
1137         bytes memory returndata,
1138         string memory errorMessage
1139     ) internal pure returns (bytes memory) {
1140         if (success) {
1141             return returndata;
1142         } else {
1143             // Look for revert reason and bubble it up if present
1144             if (returndata.length > 0) {
1145                 // The easiest way to bubble the revert reason is using memory via assembly
1146                 /// @solidity memory-safe-assembly
1147                 assembly {
1148                     let returndata_size := mload(returndata)
1149                     revert(add(32, returndata), returndata_size)
1150                 }
1151             } else {
1152                 revert(errorMessage);
1153             }
1154         }
1155     }
1156 }
1157 
1158 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1159 
1160 
1161 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 /**
1166  * @title ERC721 token receiver interface
1167  * @dev Interface for any contract that wants to support safeTransfers
1168  * from ERC721 asset contracts.
1169  */
1170 interface IERC721Receiver {
1171     /**
1172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1173      * by `operator` from `from`, this function is called.
1174      *
1175      * It must return its Solidity selector to confirm the token transfer.
1176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1177      *
1178      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1179      */
1180     function onERC721Received(
1181         address operator,
1182         address from,
1183         uint256 tokenId,
1184         bytes calldata data
1185     ) external returns (bytes4);
1186 }
1187 
1188 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1189 
1190 
1191 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 /**
1196  * @dev Interface of the ERC165 standard, as defined in the
1197  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1198  *
1199  * Implementers can declare support of contract interfaces, which can then be
1200  * queried by others ({ERC165Checker}).
1201  *
1202  * For an implementation, see {ERC165}.
1203  */
1204 interface IERC165 {
1205     /**
1206      * @dev Returns true if this contract implements the interface defined by
1207      * `interfaceId`. See the corresponding
1208      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1209      * to learn more about how these ids are created.
1210      *
1211      * This function call must use less than 30 000 gas.
1212      */
1213     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1214 }
1215 
1216 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1217 
1218 
1219 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 
1224 /**
1225  * @dev Implementation of the {IERC165} interface.
1226  *
1227  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1228  * for the additional interface id that will be supported. For example:
1229  *
1230  * ```solidity
1231  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1232  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1233  * }
1234  * ```
1235  *
1236  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1237  */
1238 abstract contract ERC165 is IERC165 {
1239     /**
1240      * @dev See {IERC165-supportsInterface}.
1241      */
1242     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1243         return interfaceId == type(IERC165).interfaceId;
1244     }
1245 }
1246 
1247 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1248 
1249 
1250 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 
1255 /**
1256  * @dev Required interface of an ERC721 compliant contract.
1257  */
1258 interface IERC721 is IERC165 {
1259     /**
1260      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1261      */
1262     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1263 
1264     /**
1265      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1266      */
1267     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1268 
1269     /**
1270      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1271      */
1272     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1273 
1274     /**
1275      * @dev Returns the number of tokens in ``owner``'s account.
1276      */
1277     function balanceOf(address owner) external view returns (uint256 balance);
1278 
1279     /**
1280      * @dev Returns the owner of the `tokenId` token.
1281      *
1282      * Requirements:
1283      *
1284      * - `tokenId` must exist.
1285      */
1286     function ownerOf(uint256 tokenId) external view returns (address owner);
1287 
1288     /**
1289      * @dev Safely transfers `tokenId` token from `from` to `to`.
1290      *
1291      * Requirements:
1292      *
1293      * - `from` cannot be the zero address.
1294      * - `to` cannot be the zero address.
1295      * - `tokenId` token must exist and be owned by `from`.
1296      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function safeTransferFrom(
1302         address from,
1303         address to,
1304         uint256 tokenId,
1305         bytes calldata data
1306     ) external;
1307 
1308     /**
1309      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1310      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1311      *
1312      * Requirements:
1313      *
1314      * - `from` cannot be the zero address.
1315      * - `to` cannot be the zero address.
1316      * - `tokenId` token must exist and be owned by `from`.
1317      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1318      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function safeTransferFrom(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) external;
1327 
1328     /**
1329      * @dev Transfers `tokenId` token from `from` to `to`.
1330      *
1331      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1332      *
1333      * Requirements:
1334      *
1335      * - `from` cannot be the zero address.
1336      * - `to` cannot be the zero address.
1337      * - `tokenId` token must be owned by `from`.
1338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1339      *
1340      * Emits a {Transfer} event.
1341      */
1342     function transferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) external;
1347 
1348     /**
1349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1350      * The approval is cleared when the token is transferred.
1351      *
1352      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1353      *
1354      * Requirements:
1355      *
1356      * - The caller must own the token or be an approved operator.
1357      * - `tokenId` must exist.
1358      *
1359      * Emits an {Approval} event.
1360      */
1361     function approve(address to, uint256 tokenId) external;
1362 
1363     /**
1364      * @dev Approve or remove `operator` as an operator for the caller.
1365      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1366      *
1367      * Requirements:
1368      *
1369      * - The `operator` cannot be the caller.
1370      *
1371      * Emits an {ApprovalForAll} event.
1372      */
1373     function setApprovalForAll(address operator, bool _approved) external;
1374 
1375     /**
1376      * @dev Returns the account approved for `tokenId` token.
1377      *
1378      * Requirements:
1379      *
1380      * - `tokenId` must exist.
1381      */
1382     function getApproved(uint256 tokenId) external view returns (address operator);
1383 
1384     /**
1385      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1386      *
1387      * See {setApprovalForAll}
1388      */
1389     function isApprovedForAll(address owner, address operator) external view returns (bool);
1390 }
1391 
1392 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1393 
1394 
1395 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1396 
1397 pragma solidity ^0.8.0;
1398 
1399 
1400 /**
1401  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1402  * @dev See https://eips.ethereum.org/EIPS/eip-721
1403  */
1404 interface IERC721Metadata is IERC721 {
1405     /**
1406      * @dev Returns the token collection name.
1407      */
1408     function name() external view returns (string memory);
1409 
1410     /**
1411      * @dev Returns the token collection symbol.
1412      */
1413     function symbol() external view returns (string memory);
1414 
1415     /**
1416      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1417      */
1418     function tokenURI(uint256 tokenId) external view returns (string memory);
1419 }
1420 
1421 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1422 
1423 
1424 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1425 
1426 pragma solidity ^0.8.0;
1427 
1428 
1429 
1430 
1431 
1432 
1433 
1434 
1435 /**
1436  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1437  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1438  * {ERC721Enumerable}.
1439  */
1440 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1441     using Address for address;
1442     using Strings for uint256;
1443 
1444     // Token name
1445     string private _name;
1446 
1447     // Token symbol
1448     string private _symbol;
1449 
1450     // Mapping from token ID to owner address
1451     mapping(uint256 => address) private _owners;
1452 
1453     // Mapping owner address to token count
1454     mapping(address => uint256) private _balances;
1455 
1456     // Mapping from token ID to approved address
1457     mapping(uint256 => address) private _tokenApprovals;
1458 
1459     // Mapping from owner to operator approvals
1460     mapping(address => mapping(address => bool)) private _operatorApprovals;
1461 
1462     /**
1463      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1464      */
1465     constructor(string memory name_, string memory symbol_) {
1466         _name = name_;
1467         _symbol = symbol_;
1468     }
1469 
1470     /**
1471      * @dev See {IERC165-supportsInterface}.
1472      */
1473     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1474         return
1475             interfaceId == type(IERC721).interfaceId ||
1476             interfaceId == type(IERC721Metadata).interfaceId ||
1477             super.supportsInterface(interfaceId);
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-balanceOf}.
1482      */
1483     function balanceOf(address owner) public view virtual override returns (uint256) {
1484         require(owner != address(0), "ERC721: address zero is not a valid owner");
1485         return _balances[owner];
1486     }
1487 
1488     /**
1489      * @dev See {IERC721-ownerOf}.
1490      */
1491     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1492         address owner = _owners[tokenId];
1493         require(owner != address(0), "ERC721: invalid token ID");
1494         return owner;
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
1515         _requireMinted(tokenId);
1516 
1517         string memory baseURI = _baseURI();
1518         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1519     }
1520 
1521     /**
1522      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1523      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1524      * by default, can be overridden in child contracts.
1525      */
1526     function _baseURI() internal view virtual returns (string memory) {
1527         return "";
1528     }
1529 
1530     /**
1531      * @dev See {IERC721-approve}.
1532      */
1533     function approve(address to, uint256 tokenId) public virtual override {
1534         address owner = ERC721.ownerOf(tokenId);
1535         require(to != owner, "ERC721: approval to current owner");
1536 
1537         require(
1538             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1539             "ERC721: approve caller is not token owner nor approved for all"
1540         );
1541 
1542         _approve(to, tokenId);
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-getApproved}.
1547      */
1548     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1549         _requireMinted(tokenId);
1550 
1551         return _tokenApprovals[tokenId];
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-setApprovalForAll}.
1556      */
1557     function setApprovalForAll(address operator, bool approved) public virtual override {
1558         _setApprovalForAll(_msgSender(), operator, approved);
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-isApprovedForAll}.
1563      */
1564     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1565         return _operatorApprovals[owner][operator];
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-transferFrom}.
1570      */
1571     function transferFrom(
1572         address from,
1573         address to,
1574         uint256 tokenId
1575     ) public virtual override {
1576         //solhint-disable-next-line max-line-length
1577         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1578 
1579         _transfer(from, to, tokenId);
1580     }
1581 
1582     /**
1583      * @dev See {IERC721-safeTransferFrom}.
1584      */
1585     function safeTransferFrom(
1586         address from,
1587         address to,
1588         uint256 tokenId
1589     ) public virtual override {
1590         safeTransferFrom(from, to, tokenId, "");
1591     }
1592 
1593     /**
1594      * @dev See {IERC721-safeTransferFrom}.
1595      */
1596     function safeTransferFrom(
1597         address from,
1598         address to,
1599         uint256 tokenId,
1600         bytes memory data
1601     ) public virtual override {
1602         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1603         _safeTransfer(from, to, tokenId, data);
1604     }
1605 
1606     /**
1607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1609      *
1610      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1611      *
1612      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1613      * implement alternative mechanisms to perform token transfer, such as signature-based.
1614      *
1615      * Requirements:
1616      *
1617      * - `from` cannot be the zero address.
1618      * - `to` cannot be the zero address.
1619      * - `tokenId` token must exist and be owned by `from`.
1620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _safeTransfer(
1625         address from,
1626         address to,
1627         uint256 tokenId,
1628         bytes memory data
1629     ) internal virtual {
1630         _transfer(from, to, tokenId);
1631         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1632     }
1633 
1634     /**
1635      * @dev Returns whether `tokenId` exists.
1636      *
1637      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1638      *
1639      * Tokens start existing when they are minted (`_mint`),
1640      * and stop existing when they are burned (`_burn`).
1641      */
1642     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1643         return _owners[tokenId] != address(0);
1644     }
1645 
1646     /**
1647      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must exist.
1652      */
1653     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1654         address owner = ERC721.ownerOf(tokenId);
1655         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1656     }
1657 
1658     /**
1659      * @dev Safely mints `tokenId` and transfers it to `to`.
1660      *
1661      * Requirements:
1662      *
1663      * - `tokenId` must not exist.
1664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function _safeMint(address to, uint256 tokenId) internal virtual {
1669         _safeMint(to, tokenId, "");
1670     }
1671 
1672     /**
1673      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1674      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1675      */
1676     function _safeMint(
1677         address to,
1678         uint256 tokenId,
1679         bytes memory data
1680     ) internal virtual {
1681         _mint(to, tokenId);
1682         require(
1683             _checkOnERC721Received(address(0), to, tokenId, data),
1684             "ERC721: transfer to non ERC721Receiver implementer"
1685         );
1686     }
1687 
1688     /**
1689      * @dev Mints `tokenId` and transfers it to `to`.
1690      *
1691      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1692      *
1693      * Requirements:
1694      *
1695      * - `tokenId` must not exist.
1696      * - `to` cannot be the zero address.
1697      *
1698      * Emits a {Transfer} event.
1699      */
1700     function _mint(address to, uint256 tokenId) internal virtual {
1701         require(to != address(0), "ERC721: mint to the zero address");
1702         require(!_exists(tokenId), "ERC721: token already minted");
1703 
1704         _beforeTokenTransfer(address(0), to, tokenId);
1705 
1706         _balances[to] += 1;
1707         _owners[tokenId] = to;
1708 
1709         emit Transfer(address(0), to, tokenId);
1710 
1711         _afterTokenTransfer(address(0), to, tokenId);
1712     }
1713 
1714     /**
1715      * @dev Destroys `tokenId`.
1716      * The approval is cleared when the token is burned.
1717      *
1718      * Requirements:
1719      *
1720      * - `tokenId` must exist.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _burn(uint256 tokenId) internal virtual {
1725         address owner = ERC721.ownerOf(tokenId);
1726 
1727         _beforeTokenTransfer(owner, address(0), tokenId);
1728 
1729         // Clear approvals
1730         _approve(address(0), tokenId);
1731 
1732         _balances[owner] -= 1;
1733         delete _owners[tokenId];
1734 
1735         emit Transfer(owner, address(0), tokenId);
1736 
1737         _afterTokenTransfer(owner, address(0), tokenId);
1738     }
1739 
1740     /**
1741      * @dev Transfers `tokenId` from `from` to `to`.
1742      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1743      *
1744      * Requirements:
1745      *
1746      * - `to` cannot be the zero address.
1747      * - `tokenId` token must be owned by `from`.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function _transfer(
1752         address from,
1753         address to,
1754         uint256 tokenId
1755     ) internal virtual {
1756         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1757         require(to != address(0), "ERC721: transfer to the zero address");
1758 
1759         _beforeTokenTransfer(from, to, tokenId);
1760 
1761         // Clear approvals from the previous owner
1762         _approve(address(0), tokenId);
1763 
1764         _balances[from] -= 1;
1765         _balances[to] += 1;
1766         _owners[tokenId] = to;
1767 
1768         emit Transfer(from, to, tokenId);
1769 
1770         _afterTokenTransfer(from, to, tokenId);
1771     }
1772 
1773     /**
1774      * @dev Approve `to` to operate on `tokenId`
1775      *
1776      * Emits an {Approval} event.
1777      */
1778     function _approve(address to, uint256 tokenId) internal virtual {
1779         _tokenApprovals[tokenId] = to;
1780         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1781     }
1782 
1783     /**
1784      * @dev Approve `operator` to operate on all of `owner` tokens
1785      *
1786      * Emits an {ApprovalForAll} event.
1787      */
1788     function _setApprovalForAll(
1789         address owner,
1790         address operator,
1791         bool approved
1792     ) internal virtual {
1793         require(owner != operator, "ERC721: approve to caller");
1794         _operatorApprovals[owner][operator] = approved;
1795         emit ApprovalForAll(owner, operator, approved);
1796     }
1797 
1798     /**
1799      * @dev Reverts if the `tokenId` has not been minted yet.
1800      */
1801     function _requireMinted(uint256 tokenId) internal view virtual {
1802         require(_exists(tokenId), "ERC721: invalid token ID");
1803     }
1804 
1805     /**
1806      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1807      * The call is not executed if the target address is not a contract.
1808      *
1809      * @param from address representing the previous owner of the given token ID
1810      * @param to target address that will receive the tokens
1811      * @param tokenId uint256 ID of the token to be transferred
1812      * @param data bytes optional data to send along with the call
1813      * @return bool whether the call correctly returned the expected magic value
1814      */
1815     function _checkOnERC721Received(
1816         address from,
1817         address to,
1818         uint256 tokenId,
1819         bytes memory data
1820     ) private returns (bool) {
1821         if (to.isContract()) {
1822             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1823                 return retval == IERC721Receiver.onERC721Received.selector;
1824             } catch (bytes memory reason) {
1825                 if (reason.length == 0) {
1826                     revert("ERC721: transfer to non ERC721Receiver implementer");
1827                 } else {
1828                     /// @solidity memory-safe-assembly
1829                     assembly {
1830                         revert(add(32, reason), mload(reason))
1831                     }
1832                 }
1833             }
1834         } else {
1835             return true;
1836         }
1837     }
1838 
1839     /**
1840      * @dev Hook that is called before any token transfer. This includes minting
1841      * and burning.
1842      *
1843      * Calling conditions:
1844      *
1845      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1846      * transferred to `to`.
1847      * - When `from` is zero, `tokenId` will be minted for `to`.
1848      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1849      * - `from` and `to` are never both zero.
1850      *
1851      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1852      */
1853     function _beforeTokenTransfer(
1854         address from,
1855         address to,
1856         uint256 tokenId
1857     ) internal virtual {}
1858 
1859     /**
1860      * @dev Hook that is called after any transfer of tokens. This includes
1861      * minting and burning.
1862      *
1863      * Calling conditions:
1864      *
1865      * - when `from` and `to` are both non-zero.
1866      * - `from` and `to` are never both zero.
1867      *
1868      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1869      */
1870     function _afterTokenTransfer(
1871         address from,
1872         address to,
1873         uint256 tokenId
1874     ) internal virtual {}
1875 }
1876 
1877 // File: BountyGamesR2.sol
1878 
1879 
1880 pragma solidity ^0.8.2;
1881 
1882 
1883 
1884 
1885 
1886 
1887 
1888 contract BountyGamesR2 is ERC721, EIP712, Ownable {
1889     using Counters for Counters.Counter;
1890     using Strings for uint256;
1891     using EnumerableSet for EnumerableSet.UintSet;
1892 
1893     Counters.Counter private _tokenIdCounter;
1894     address _signerAddress;
1895 
1896     string _baseUri;
1897     string _contractUri;
1898 
1899     uint256 _turnInFee = 0;
1900     uint256 _tMult = 5;
1901 
1902     mapping(uint256 => uint256) public batches;
1903 
1904     bool public canUnlock = true;
1905     uint256 public startSalesTimestamp = 1662660000;
1906     uint256 public endSalesTimestamp = 1662919200;
1907 
1908     mapping(address => uint256) public accountToMintedFreeTokens;
1909     mapping(address => EnumerableSet.UintSet) accountToLockedTokens;
1910 
1911     event Arrest(uint256 tokenId, address owner);
1912     event Release(uint256 tokenId, address owner);
1913 
1914     constructor()
1915         ERC721("Bounty Games Round 2", "BOUNTYR2")
1916         EIP712("BOUNTYR2", "1.0.0")
1917     {
1918         _contractUri = "ipfs:/QmPJLGsVyJCnEdUXetFnvtR5KH1TauF4Yey1d7HqAEQiSf";
1919         _baseUri = "https://dead-heads-api.herokuapp.com/api/bounty/";
1920         _signerAddress = 0x594CbAA41586785d80a6dbbee01F4662Eb09e0d0;
1921 
1922         batches[0] = 0;
1923         batches[1] = 20000000000000000;
1924         batches[2] = 40000000000000000;
1925         batches[3] = 60000000000000000;
1926         batches[5] = 75000000000000000;
1927         batches[10] = 125000000000000000;
1928         batches[20] = 225000000000000000;
1929         batches[50] = 500000000000000000;
1930     }
1931 
1932     function batchMint(uint batchCount, uint256 maxFreeMint, uint256 freeMintQuantity, bytes calldata signature) external  payable {
1933         
1934         require(isSalesActive(), "sale is not active");
1935         if(freeMintQuantity > 0){
1936             require(recoverAddress(msg.sender, maxFreeMint, signature) == _signerAddress, "user cannot free mint");
1937             require(accountToMintedFreeTokens[msg.sender] < maxFreeMint, "You already minted your free mint");
1938         }else{
1939             require(batchCount > 0, "You must choose a quantity");
1940         }
1941         
1942         uint price = batches[batchCount];
1943         require(price > 0 || batchCount == 0, "Invalid batch");
1944         require(msg.value >= price, "ether sent is under price");
1945 
1946         if(freeMintQuantity > 0){
1947             accountToMintedFreeTokens[msg.sender] += freeMintQuantity;
1948         }
1949 
1950         for (uint256 i = 0; i < batchCount + freeMintQuantity; i++) {
1951             safeMint(msg.sender);
1952         }
1953     }
1954 
1955 
1956     function safeMint(address to) internal {
1957         uint256 tokenId = _tokenIdCounter.current();
1958         _tokenIdCounter.increment();
1959         _safeMint(to, tokenId);
1960     }
1961 
1962     function totalSupply() public view returns (uint256) {
1963         return _tokenIdCounter.current();
1964     }
1965 
1966     function isSalesActive() public view returns (bool) {
1967         return
1968             block.timestamp >= startSalesTimestamp &&
1969             block.timestamp <= endSalesTimestamp;
1970     }
1971 
1972     function setSalesDates(uint256 start, uint256 end) external onlyOwner {
1973         startSalesTimestamp = start;
1974         endSalesTimestamp = end;
1975     }
1976 
1977     function contractURI() public view returns (string memory) {
1978         return _contractUri;
1979     }
1980     
1981     function setBaseURI(string memory newBaseURI) external onlyOwner {
1982         _baseUri = newBaseURI;
1983     }
1984 
1985     function setContractURI(string memory newContractURI) external onlyOwner {
1986         _contractUri = newContractURI;
1987     }
1988 
1989     function setPrice(uint256 newBatchQuantity, uint256 newBatchPrice) external onlyOwner{
1990         batches[newBatchQuantity] = newBatchPrice;
1991     }
1992 
1993     function getTurnInFee() public view returns (uint256) {
1994         return _turnInFee;
1995     }
1996 
1997     function setTMult(uint256 newtMult) external onlyOwner {
1998         _tMult = newtMult;
1999     }
2000 
2001     function setTurnInFee() internal  {
2002         _turnInFee = address(this).balance / 1000 * _tMult;
2003     }  
2004 
2005     function setCanUnlock(bool newCanUnlock) external onlyOwner {
2006         canUnlock = newCanUnlock;
2007         setTurnInFee();
2008     }
2009 
2010     function arrest(uint256 tokenId) external payable {
2011         require(msg.value >= _turnInFee, "ether sent is under turn in price, try again");
2012         require(!canUnlock, "cannot arrest yet");
2013 
2014         address tokenOwner = ownerOf(tokenId);
2015 
2016         require(
2017             tokenOwner == msg.sender || msg.sender == owner(),
2018             "user does not own this token"
2019         );
2020 
2021         _transfer(tokenOwner, address(this), tokenId);
2022 
2023         accountToLockedTokens[tokenOwner].add(tokenId);
2024 
2025         emit Arrest(tokenId, tokenOwner);
2026 
2027         setTurnInFee();
2028     }
2029 
2030     function lockedTokensFromAccount(address accountAddress) external view returns (uint[] memory tokenIds) {
2031         uint amount = accountToLockedTokens[accountAddress].length();
2032         tokenIds = new uint[](amount);
2033 
2034         for (uint i = 0; i < amount; i++) {
2035             tokenIds[i] = accountToLockedTokens[accountAddress].at(i);
2036         }
2037     }
2038 
2039     function _hash(address account, uint maxFreeMints) internal view returns (bytes32) {
2040         return
2041             _hashTypedDataV4(
2042                 keccak256(
2043                     abi.encode(
2044                         keccak256("NFT(uint256 maxFreeMints,address account)"),
2045                         maxFreeMints,
2046                         account
2047                     )
2048                 )
2049             );
2050     }
2051 
2052     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2053         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2054 
2055         return string(abi.encodePacked(_baseUri, tokenId.toString()));
2056     }
2057 
2058     function recoverAddress(address account, uint256 maxFreeMints, bytes calldata signature) public view returns (address) {
2059         return ECDSA.recover(_hash(account, maxFreeMints), signature);
2060     }
2061 
2062     function setSignerAddress(address signerAddress) external onlyOwner {
2063         _signerAddress = signerAddress;
2064     }
2065 
2066     function sendPrize(uint256 amount, address winner) external onlyOwner {
2067         require(payable(winner).send(amount));
2068     }
2069 
2070     function withdraw(uint256 amount) external onlyOwner {
2071         require(payable(msg.sender).send(amount));
2072     }
2073 }