1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/Context
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/ECDSA
30 
31 /**
32  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
33  *
34  * These functions can be used to verify that a message was signed by the holder
35  * of the private keys of a given address.
36  */
37 library ECDSA {
38     enum RecoverError {
39         NoError,
40         InvalidSignature,
41         InvalidSignatureLength,
42         InvalidSignatureS,
43         InvalidSignatureV
44     }
45 
46     function _throwError(RecoverError error) private pure {
47         if (error == RecoverError.NoError) {
48             return; // no error: do nothing
49         } else if (error == RecoverError.InvalidSignature) {
50             revert("ECDSA: invalid signature");
51         } else if (error == RecoverError.InvalidSignatureLength) {
52             revert("ECDSA: invalid signature length");
53         } else if (error == RecoverError.InvalidSignatureS) {
54             revert("ECDSA: invalid signature 's' value");
55         } else if (error == RecoverError.InvalidSignatureV) {
56             revert("ECDSA: invalid signature 'v' value");
57         }
58     }
59 
60     /**
61      * @dev Returns the address that signed a hashed message (`hash`) with
62      * `signature` or error string. This address can then be used for verification purposes.
63      *
64      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
65      * this function rejects them by requiring the `s` value to be in the lower
66      * half order, and the `v` value to be either 27 or 28.
67      *
68      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
69      * verification to be secure: it is possible to craft signatures that
70      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
71      * this is by receiving a hash of the original message (which may otherwise
72      * be too long), and then calling {toEthSignedMessageHash} on it.
73      *
74      * Documentation for signature generation:
75      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
76      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
77      *
78      * _Available since v4.3._
79      */
80     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
81         // Check the signature length
82         // - case 65: r,s,v signature (standard)
83         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
84         if (signature.length == 65) {
85             bytes32 r;
86             bytes32 s;
87             uint8 v;
88             // ecrecover takes the signature parameters, and the only way to get them
89             // currently is to use assembly.
90             assembly {
91                 r := mload(add(signature, 0x20))
92                 s := mload(add(signature, 0x40))
93                 v := byte(0, mload(add(signature, 0x60)))
94             }
95             return tryRecover(hash, v, r, s);
96         } else if (signature.length == 64) {
97             bytes32 r;
98             bytes32 vs;
99             // ecrecover takes the signature parameters, and the only way to get them
100             // currently is to use assembly.
101             assembly {
102                 r := mload(add(signature, 0x20))
103                 vs := mload(add(signature, 0x40))
104             }
105             return tryRecover(hash, r, vs);
106         } else {
107             return (address(0), RecoverError.InvalidSignatureLength);
108         }
109     }
110 
111     /**
112      * @dev Returns the address that signed a hashed message (`hash`) with
113      * `signature`. This address can then be used for verification purposes.
114      *
115      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
116      * this function rejects them by requiring the `s` value to be in the lower
117      * half order, and the `v` value to be either 27 or 28.
118      *
119      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
120      * verification to be secure: it is possible to craft signatures that
121      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
122      * this is by receiving a hash of the original message (which may otherwise
123      * be too long), and then calling {toEthSignedMessageHash} on it.
124      */
125     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
126         (address recovered, RecoverError error) = tryRecover(hash, signature);
127         _throwError(error);
128         return recovered;
129     }
130 
131     /**
132      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
133      *
134      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
135      *
136      * _Available since v4.3._
137      */
138     function tryRecover(
139         bytes32 hash,
140         bytes32 r,
141         bytes32 vs
142     ) internal pure returns (address, RecoverError) {
143         bytes32 s;
144         uint8 v;
145         assembly {
146             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
147             v := add(shr(255, vs), 27)
148         }
149         return tryRecover(hash, v, r, s);
150     }
151 
152     /**
153      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
154      *
155      * _Available since v4.2._
156      */
157     function recover(
158         bytes32 hash,
159         bytes32 r,
160         bytes32 vs
161     ) internal pure returns (address) {
162         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
163         _throwError(error);
164         return recovered;
165     }
166 
167     /**
168      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
169      * `r` and `s` signature fields separately.
170      *
171      * _Available since v4.3._
172      */
173     function tryRecover(
174         bytes32 hash,
175         uint8 v,
176         bytes32 r,
177         bytes32 s
178     ) internal pure returns (address, RecoverError) {
179         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
180         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
181         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
182         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
183         //
184         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
185         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
186         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
187         // these malleable signatures as well.
188         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
189             return (address(0), RecoverError.InvalidSignatureS);
190         }
191         if (v != 27 && v != 28) {
192             return (address(0), RecoverError.InvalidSignatureV);
193         }
194 
195         // If the signature is valid (and not malleable), return the signer address
196         address signer = ecrecover(hash, v, r, s);
197         if (signer == address(0)) {
198             return (address(0), RecoverError.InvalidSignature);
199         }
200 
201         return (signer, RecoverError.NoError);
202     }
203 
204     /**
205      * @dev Overload of {ECDSA-recover} that receives the `v`,
206      * `r` and `s` signature fields separately.
207      */
208     function recover(
209         bytes32 hash,
210         uint8 v,
211         bytes32 r,
212         bytes32 s
213     ) internal pure returns (address) {
214         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
215         _throwError(error);
216         return recovered;
217     }
218 
219     /**
220      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
221      * produces hash corresponding to the one signed with the
222      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
223      * JSON-RPC method as part of EIP-191.
224      *
225      * See {recover}.
226      */
227     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
228         // 32 is the length in bytes of hash,
229         // enforced by the type signature above
230         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
231     }
232 
233     /**
234      * @dev Returns an Ethereum Signed Typed Data, created from a
235      * `domainSeparator` and a `structHash`. This produces hash corresponding
236      * to the one signed with the
237      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
238      * JSON-RPC method as part of EIP-712.
239      *
240      * See {recover}.
241      */
242     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
243         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
244     }
245 }
246 
247 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/EnumerableSet
248 
249 /**
250  * @dev Library for managing
251  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
252  * types.
253  *
254  * Sets have the following properties:
255  *
256  * - Elements are added, removed, and checked for existence in constant time
257  * (O(1)).
258  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
259  *
260  * ```
261  * contract Example {
262  *     // Add the library methods
263  *     using EnumerableSet for EnumerableSet.AddressSet;
264  *
265  *     // Declare a set state variable
266  *     EnumerableSet.AddressSet private mySet;
267  * }
268  * ```
269  *
270  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
271  * and `uint256` (`UintSet`) are supported.
272  */
273 library EnumerableSet {
274     // To implement this library for multiple types with as little code
275     // repetition as possible, we write it in terms of a generic Set type with
276     // bytes32 values.
277     // The Set implementation uses private functions, and user-facing
278     // implementations (such as AddressSet) are just wrappers around the
279     // underlying Set.
280     // This means that we can only create new EnumerableSets for types that fit
281     // in bytes32.
282 
283     struct Set {
284         // Storage of set values
285         bytes32[] _values;
286         // Position of the value in the `values` array, plus 1 because index 0
287         // means a value is not in the set.
288         mapping(bytes32 => uint256) _indexes;
289     }
290 
291     /**
292      * @dev Add a value to a set. O(1).
293      *
294      * Returns true if the value was added to the set, that is if it was not
295      * already present.
296      */
297     function _add(Set storage set, bytes32 value) private returns (bool) {
298         if (!_contains(set, value)) {
299             set._values.push(value);
300             // The value is stored at length-1, but we add 1 to all indexes
301             // and use 0 as a sentinel value
302             set._indexes[value] = set._values.length;
303             return true;
304         } else {
305             return false;
306         }
307     }
308 
309     /**
310      * @dev Removes a value from a set. O(1).
311      *
312      * Returns true if the value was removed from the set, that is if it was
313      * present.
314      */
315     function _remove(Set storage set, bytes32 value) private returns (bool) {
316         // We read and store the value's index to prevent multiple reads from the same storage slot
317         uint256 valueIndex = set._indexes[value];
318 
319         if (valueIndex != 0) {
320             // Equivalent to contains(set, value)
321             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
322             // the array, and then remove the last element (sometimes called as 'swap and pop').
323             // This modifies the order of the array, as noted in {at}.
324 
325             uint256 toDeleteIndex = valueIndex - 1;
326             uint256 lastIndex = set._values.length - 1;
327 
328             if (lastIndex != toDeleteIndex) {
329                 bytes32 lastvalue = set._values[lastIndex];
330 
331                 // Move the last value to the index where the value to delete is
332                 set._values[toDeleteIndex] = lastvalue;
333                 // Update the index for the moved value
334                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
335             }
336 
337             // Delete the slot where the moved value was stored
338             set._values.pop();
339 
340             // Delete the index for the deleted slot
341             delete set._indexes[value];
342 
343             return true;
344         } else {
345             return false;
346         }
347     }
348 
349     /**
350      * @dev Returns true if the value is in the set. O(1).
351      */
352     function _contains(Set storage set, bytes32 value) private view returns (bool) {
353         return set._indexes[value] != 0;
354     }
355 
356     /**
357      * @dev Returns the number of values on the set. O(1).
358      */
359     function _length(Set storage set) private view returns (uint256) {
360         return set._values.length;
361     }
362 
363     /**
364      * @dev Returns the value stored at position `index` in the set. O(1).
365      *
366      * Note that there are no guarantees on the ordering of values inside the
367      * array, and it may change when more values are added or removed.
368      *
369      * Requirements:
370      *
371      * - `index` must be strictly less than {length}.
372      */
373     function _at(Set storage set, uint256 index) private view returns (bytes32) {
374         return set._values[index];
375     }
376 
377     /**
378      * @dev Return the entire set in an array
379      *
380      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
381      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
382      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
383      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
384      */
385     function _values(Set storage set) private view returns (bytes32[] memory) {
386         return set._values;
387     }
388 
389     // Bytes32Set
390 
391     struct Bytes32Set {
392         Set _inner;
393     }
394 
395     /**
396      * @dev Add a value to a set. O(1).
397      *
398      * Returns true if the value was added to the set, that is if it was not
399      * already present.
400      */
401     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
402         return _add(set._inner, value);
403     }
404 
405     /**
406      * @dev Removes a value from a set. O(1).
407      *
408      * Returns true if the value was removed from the set, that is if it was
409      * present.
410      */
411     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
412         return _remove(set._inner, value);
413     }
414 
415     /**
416      * @dev Returns true if the value is in the set. O(1).
417      */
418     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
419         return _contains(set._inner, value);
420     }
421 
422     /**
423      * @dev Returns the number of values in the set. O(1).
424      */
425     function length(Bytes32Set storage set) internal view returns (uint256) {
426         return _length(set._inner);
427     }
428 
429     /**
430      * @dev Returns the value stored at position `index` in the set. O(1).
431      *
432      * Note that there are no guarantees on the ordering of values inside the
433      * array, and it may change when more values are added or removed.
434      *
435      * Requirements:
436      *
437      * - `index` must be strictly less than {length}.
438      */
439     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
440         return _at(set._inner, index);
441     }
442 
443     /**
444      * @dev Return the entire set in an array
445      *
446      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
447      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
448      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
449      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
450      */
451     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
452         return _values(set._inner);
453     }
454 
455     // AddressSet
456 
457     struct AddressSet {
458         Set _inner;
459     }
460 
461     /**
462      * @dev Add a value to a set. O(1).
463      *
464      * Returns true if the value was added to the set, that is if it was not
465      * already present.
466      */
467     function add(AddressSet storage set, address value) internal returns (bool) {
468         return _add(set._inner, bytes32(uint256(uint160(value))));
469     }
470 
471     /**
472      * @dev Removes a value from a set. O(1).
473      *
474      * Returns true if the value was removed from the set, that is if it was
475      * present.
476      */
477     function remove(AddressSet storage set, address value) internal returns (bool) {
478         return _remove(set._inner, bytes32(uint256(uint160(value))));
479     }
480 
481     /**
482      * @dev Returns true if the value is in the set. O(1).
483      */
484     function contains(AddressSet storage set, address value) internal view returns (bool) {
485         return _contains(set._inner, bytes32(uint256(uint160(value))));
486     }
487 
488     /**
489      * @dev Returns the number of values in the set. O(1).
490      */
491     function length(AddressSet storage set) internal view returns (uint256) {
492         return _length(set._inner);
493     }
494 
495     /**
496      * @dev Returns the value stored at position `index` in the set. O(1).
497      *
498      * Note that there are no guarantees on the ordering of values inside the
499      * array, and it may change when more values are added or removed.
500      *
501      * Requirements:
502      *
503      * - `index` must be strictly less than {length}.
504      */
505     function at(AddressSet storage set, uint256 index) internal view returns (address) {
506         return address(uint160(uint256(_at(set._inner, index))));
507     }
508 
509     /**
510      * @dev Return the entire set in an array
511      *
512      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
513      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
514      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
515      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
516      */
517     function values(AddressSet storage set) internal view returns (address[] memory) {
518         bytes32[] memory store = _values(set._inner);
519         address[] memory result;
520 
521         assembly {
522             result := store
523         }
524 
525         return result;
526     }
527 
528     // UintSet
529 
530     struct UintSet {
531         Set _inner;
532     }
533 
534     /**
535      * @dev Add a value to a set. O(1).
536      *
537      * Returns true if the value was added to the set, that is if it was not
538      * already present.
539      */
540     function add(UintSet storage set, uint256 value) internal returns (bool) {
541         return _add(set._inner, bytes32(value));
542     }
543 
544     /**
545      * @dev Removes a value from a set. O(1).
546      *
547      * Returns true if the value was removed from the set, that is if it was
548      * present.
549      */
550     function remove(UintSet storage set, uint256 value) internal returns (bool) {
551         return _remove(set._inner, bytes32(value));
552     }
553 
554     /**
555      * @dev Returns true if the value is in the set. O(1).
556      */
557     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
558         return _contains(set._inner, bytes32(value));
559     }
560 
561     /**
562      * @dev Returns the number of values on the set. O(1).
563      */
564     function length(UintSet storage set) internal view returns (uint256) {
565         return _length(set._inner);
566     }
567 
568     /**
569      * @dev Returns the value stored at position `index` in the set. O(1).
570      *
571      * Note that there are no guarantees on the ordering of values inside the
572      * array, and it may change when more values are added or removed.
573      *
574      * Requirements:
575      *
576      * - `index` must be strictly less than {length}.
577      */
578     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
579         return uint256(_at(set._inner, index));
580     }
581 
582     /**
583      * @dev Return the entire set in an array
584      *
585      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
586      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
587      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
588      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
589      */
590     function values(UintSet storage set) internal view returns (uint256[] memory) {
591         bytes32[] memory store = _values(set._inner);
592         uint256[] memory result;
593 
594         assembly {
595             result := store
596         }
597 
598         return result;
599     }
600 }
601 
602 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/IAccessControl
603 
604 /**
605  * @dev External interface of AccessControl declared to support ERC165 detection.
606  */
607 interface IAccessControl {
608     /**
609      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
610      *
611      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
612      * {RoleAdminChanged} not being emitted signaling this.
613      *
614      * _Available since v3.1._
615      */
616     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
617 
618     /**
619      * @dev Emitted when `account` is granted `role`.
620      *
621      * `sender` is the account that originated the contract call, an admin role
622      * bearer except when using {AccessControl-_setupRole}.
623      */
624     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
625 
626     /**
627      * @dev Emitted when `account` is revoked `role`.
628      *
629      * `sender` is the account that originated the contract call:
630      *   - if using `revokeRole`, it is the admin role bearer
631      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
632      */
633     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
634 
635     /**
636      * @dev Returns `true` if `account` has been granted `role`.
637      */
638     function hasRole(bytes32 role, address account) external view returns (bool);
639 
640     /**
641      * @dev Returns the admin role that controls `role`. See {grantRole} and
642      * {revokeRole}.
643      *
644      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
645      */
646     function getRoleAdmin(bytes32 role) external view returns (bytes32);
647 
648     /**
649      * @dev Grants `role` to `account`.
650      *
651      * If `account` had not been already granted `role`, emits a {RoleGranted}
652      * event.
653      *
654      * Requirements:
655      *
656      * - the caller must have ``role``'s admin role.
657      */
658     function grantRole(bytes32 role, address account) external;
659 
660     /**
661      * @dev Revokes `role` from `account`.
662      *
663      * If `account` had been granted `role`, emits a {RoleRevoked} event.
664      *
665      * Requirements:
666      *
667      * - the caller must have ``role``'s admin role.
668      */
669     function revokeRole(bytes32 role, address account) external;
670 
671     /**
672      * @dev Revokes `role` from the calling account.
673      *
674      * Roles are often managed via {grantRole} and {revokeRole}: this function's
675      * purpose is to provide a mechanism for accounts to lose their privileges
676      * if they are compromised (such as when a trusted device is misplaced).
677      *
678      * If the calling account had been granted `role`, emits a {RoleRevoked}
679      * event.
680      *
681      * Requirements:
682      *
683      * - the caller must be `account`.
684      */
685     function renounceRole(bytes32 role, address account) external;
686 }
687 
688 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/IERC165
689 
690 /**
691  * @dev Interface of the ERC165 standard, as defined in the
692  * https://eips.ethereum.org/EIPS/eip-165[EIP].
693  *
694  * Implementers can declare support of contract interfaces, which can then be
695  * queried by others ({ERC165Checker}).
696  *
697  * For an implementation, see {ERC165}.
698  */
699 interface IERC165 {
700     /**
701      * @dev Returns true if this contract implements the interface defined by
702      * `interfaceId`. See the corresponding
703      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
704      * to learn more about how these ids are created.
705      *
706      * This function call must use less than 30 000 gas.
707      */
708     function supportsInterface(bytes4 interfaceId) external view returns (bool);
709 }
710 
711 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/IERC20
712 
713 /**
714  * @dev Interface of the ERC20 standard as defined in the EIP.
715  */
716 interface IERC20 {
717     /**
718      * @dev Returns the amount of tokens in existence.
719      */
720     function totalSupply() external view returns (uint256);
721 
722     /**
723      * @dev Returns the amount of tokens owned by `account`.
724      */
725     function balanceOf(address account) external view returns (uint256);
726 
727     /**
728      * @dev Moves `amount` tokens from the caller's account to `recipient`.
729      *
730      * Returns a boolean value indicating whether the operation succeeded.
731      *
732      * Emits a {Transfer} event.
733      */
734     function transfer(address recipient, uint256 amount) external returns (bool);
735 
736     /**
737      * @dev Returns the remaining number of tokens that `spender` will be
738      * allowed to spend on behalf of `owner` through {transferFrom}. This is
739      * zero by default.
740      *
741      * This value changes when {approve} or {transferFrom} are called.
742      */
743     function allowance(address owner, address spender) external view returns (uint256);
744 
745     /**
746      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
747      *
748      * Returns a boolean value indicating whether the operation succeeded.
749      *
750      * IMPORTANT: Beware that changing an allowance with this method brings the risk
751      * that someone may use both the old and the new allowance by unfortunate
752      * transaction ordering. One possible solution to mitigate this race
753      * condition is to first reduce the spender's allowance to 0 and set the
754      * desired value afterwards:
755      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
756      *
757      * Emits an {Approval} event.
758      */
759     function approve(address spender, uint256 amount) external returns (bool);
760 
761     /**
762      * @dev Moves `amount` tokens from `sender` to `recipient` using the
763      * allowance mechanism. `amount` is then deducted from the caller's
764      * allowance.
765      *
766      * Returns a boolean value indicating whether the operation succeeded.
767      *
768      * Emits a {Transfer} event.
769      */
770     function transferFrom(
771         address sender,
772         address recipient,
773         uint256 amount
774     ) external returns (bool);
775 
776     /**
777      * @dev Emitted when `value` tokens are moved from one account (`from`) to
778      * another (`to`).
779      *
780      * Note that `value` may be zero.
781      */
782     event Transfer(address indexed from, address indexed to, uint256 value);
783 
784     /**
785      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
786      * a call to {approve}. `value` is the new allowance.
787      */
788     event Approval(address indexed owner, address indexed spender, uint256 value);
789 }
790 
791 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/Strings
792 
793 /**
794  * @dev String operations.
795  */
796 library Strings {
797     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
798 
799     /**
800      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
801      */
802     function toString(uint256 value) internal pure returns (string memory) {
803         // Inspired by OraclizeAPI's implementation - MIT licence
804         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
805 
806         if (value == 0) {
807             return "0";
808         }
809         uint256 temp = value;
810         uint256 digits;
811         while (temp != 0) {
812             digits++;
813             temp /= 10;
814         }
815         bytes memory buffer = new bytes(digits);
816         while (value != 0) {
817             digits -= 1;
818             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
819             value /= 10;
820         }
821         return string(buffer);
822     }
823 
824     /**
825      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
826      */
827     function toHexString(uint256 value) internal pure returns (string memory) {
828         if (value == 0) {
829             return "0x00";
830         }
831         uint256 temp = value;
832         uint256 length = 0;
833         while (temp != 0) {
834             length++;
835             temp >>= 8;
836         }
837         return toHexString(value, length);
838     }
839 
840     /**
841      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
842      */
843     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
844         bytes memory buffer = new bytes(2 * length + 2);
845         buffer[0] = "0";
846         buffer[1] = "x";
847         for (uint256 i = 2 * length + 1; i > 1; --i) {
848             buffer[i] = _HEX_SYMBOLS[value & 0xf];
849             value >>= 4;
850         }
851         require(value == 0, "Strings: hex length insufficient");
852         return string(buffer);
853     }
854 }
855 
856 // Part: uniswap/uniswap-lib@2.1.0/TransferHelper
857 
858 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
859 library TransferHelper {
860     function safeApprove(
861         address token,
862         address to,
863         uint256 value
864     ) internal {
865         // bytes4(keccak256(bytes('approve(address,uint256)')));
866         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
867         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
868     }
869 
870     function safeTransfer(
871         address token,
872         address to,
873         uint256 value
874     ) internal {
875         // bytes4(keccak256(bytes('transfer(address,uint256)')));
876         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
877         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
878     }
879 
880     function safeTransferFrom(
881         address token,
882         address from,
883         address to,
884         uint256 value
885     ) internal {
886         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
887         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
888         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
889     }
890 
891     function safeTransferETH(address to, uint256 value) internal {
892         (bool success, ) = to.call{value: value}(new bytes(0));
893         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
894     }
895 }
896 
897 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/ERC165
898 
899 /**
900  * @dev Implementation of the {IERC165} interface.
901  *
902  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
903  * for the additional interface id that will be supported. For example:
904  *
905  * ```solidity
906  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
907  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
908  * }
909  * ```
910  *
911  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
912  */
913 abstract contract ERC165 is IERC165 {
914     /**
915      * @dev See {IERC165-supportsInterface}.
916      */
917     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
918         return interfaceId == type(IERC165).interfaceId;
919     }
920 }
921 
922 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/IAccessControlEnumerable
923 
924 /**
925  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
926  */
927 interface IAccessControlEnumerable is IAccessControl {
928     /**
929      * @dev Returns one of the accounts that have `role`. `index` must be a
930      * value between 0 and {getRoleMemberCount}, non-inclusive.
931      *
932      * Role bearers are not sorted in any particular way, and their ordering may
933      * change at any point.
934      *
935      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
936      * you perform all queries on the same block. See the following
937      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
938      * for more information.
939      */
940     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
941 
942     /**
943      * @dev Returns the number of accounts that have `role`. Can be used
944      * together with {getRoleMember} to enumerate all bearers of a role.
945      */
946     function getRoleMemberCount(bytes32 role) external view returns (uint256);
947 }
948 
949 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/AccessControl
950 
951 /**
952  * @dev Contract module that allows children to implement role-based access
953  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
954  * members except through off-chain means by accessing the contract event logs. Some
955  * applications may benefit from on-chain enumerability, for those cases see
956  * {AccessControlEnumerable}.
957  *
958  * Roles are referred to by their `bytes32` identifier. These should be exposed
959  * in the external API and be unique. The best way to achieve this is by
960  * using `public constant` hash digests:
961  *
962  * ```
963  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
964  * ```
965  *
966  * Roles can be used to represent a set of permissions. To restrict access to a
967  * function call, use {hasRole}:
968  *
969  * ```
970  * function foo() public {
971  *     require(hasRole(MY_ROLE, msg.sender));
972  *     ...
973  * }
974  * ```
975  *
976  * Roles can be granted and revoked dynamically via the {grantRole} and
977  * {revokeRole} functions. Each role has an associated admin role, and only
978  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
979  *
980  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
981  * that only accounts with this role will be able to grant or revoke other
982  * roles. More complex role relationships can be created by using
983  * {_setRoleAdmin}.
984  *
985  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
986  * grant and revoke this role. Extra precautions should be taken to secure
987  * accounts that have been granted it.
988  */
989 abstract contract AccessControl is Context, IAccessControl, ERC165 {
990     struct RoleData {
991         mapping(address => bool) members;
992         bytes32 adminRole;
993     }
994 
995     mapping(bytes32 => RoleData) private _roles;
996 
997     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
998 
999     /**
1000      * @dev Modifier that checks that an account has a specific role. Reverts
1001      * with a standardized message including the required role.
1002      *
1003      * The format of the revert reason is given by the following regular expression:
1004      *
1005      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1006      *
1007      * _Available since v4.1._
1008      */
1009     modifier onlyRole(bytes32 role) {
1010         _checkRole(role, _msgSender());
1011         _;
1012     }
1013 
1014     /**
1015      * @dev See {IERC165-supportsInterface}.
1016      */
1017     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1018         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1019     }
1020 
1021     /**
1022      * @dev Returns `true` if `account` has been granted `role`.
1023      */
1024     function hasRole(bytes32 role, address account) public view override returns (bool) {
1025         return _roles[role].members[account];
1026     }
1027 
1028     /**
1029      * @dev Revert with a standard message if `account` is missing `role`.
1030      *
1031      * The format of the revert reason is given by the following regular expression:
1032      *
1033      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1034      */
1035     function _checkRole(bytes32 role, address account) internal view {
1036         if (!hasRole(role, account)) {
1037             revert(
1038                 string(
1039                     abi.encodePacked(
1040                         "AccessControl: account ",
1041                         Strings.toHexString(uint160(account), 20),
1042                         " is missing role ",
1043                         Strings.toHexString(uint256(role), 32)
1044                     )
1045                 )
1046             );
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns the admin role that controls `role`. See {grantRole} and
1052      * {revokeRole}.
1053      *
1054      * To change a role's admin, use {_setRoleAdmin}.
1055      */
1056     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1057         return _roles[role].adminRole;
1058     }
1059 
1060     /**
1061      * @dev Grants `role` to `account`.
1062      *
1063      * If `account` had not been already granted `role`, emits a {RoleGranted}
1064      * event.
1065      *
1066      * Requirements:
1067      *
1068      * - the caller must have ``role``'s admin role.
1069      */
1070     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1071         _grantRole(role, account);
1072     }
1073 
1074     /**
1075      * @dev Revokes `role` from `account`.
1076      *
1077      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1078      *
1079      * Requirements:
1080      *
1081      * - the caller must have ``role``'s admin role.
1082      */
1083     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1084         _revokeRole(role, account);
1085     }
1086 
1087     /**
1088      * @dev Revokes `role` from the calling account.
1089      *
1090      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1091      * purpose is to provide a mechanism for accounts to lose their privileges
1092      * if they are compromised (such as when a trusted device is misplaced).
1093      *
1094      * If the calling account had been granted `role`, emits a {RoleRevoked}
1095      * event.
1096      *
1097      * Requirements:
1098      *
1099      * - the caller must be `account`.
1100      */
1101     function renounceRole(bytes32 role, address account) public virtual override {
1102         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1103 
1104         _revokeRole(role, account);
1105     }
1106 
1107     /**
1108      * @dev Grants `role` to `account`.
1109      *
1110      * If `account` had not been already granted `role`, emits a {RoleGranted}
1111      * event. Note that unlike {grantRole}, this function doesn't perform any
1112      * checks on the calling account.
1113      *
1114      * [WARNING]
1115      * ====
1116      * This function should only be called from the constructor when setting
1117      * up the initial roles for the system.
1118      *
1119      * Using this function in any other way is effectively circumventing the admin
1120      * system imposed by {AccessControl}.
1121      * ====
1122      */
1123     function _setupRole(bytes32 role, address account) internal virtual {
1124         _grantRole(role, account);
1125     }
1126 
1127     /**
1128      * @dev Sets `adminRole` as ``role``'s admin role.
1129      *
1130      * Emits a {RoleAdminChanged} event.
1131      */
1132     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1133         bytes32 previousAdminRole = getRoleAdmin(role);
1134         _roles[role].adminRole = adminRole;
1135         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1136     }
1137 
1138     function _grantRole(bytes32 role, address account) private {
1139         if (!hasRole(role, account)) {
1140             _roles[role].members[account] = true;
1141             emit RoleGranted(role, account, _msgSender());
1142         }
1143     }
1144 
1145     function _revokeRole(bytes32 role, address account) private {
1146         if (hasRole(role, account)) {
1147             _roles[role].members[account] = false;
1148             emit RoleRevoked(role, account, _msgSender());
1149         }
1150     }
1151 }
1152 
1153 // Part: OpenZeppelin/openzeppelin-contracts@4.3.1/AccessControlEnumerable
1154 
1155 /**
1156  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1157  */
1158 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1159     using EnumerableSet for EnumerableSet.AddressSet;
1160 
1161     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1162 
1163     /**
1164      * @dev See {IERC165-supportsInterface}.
1165      */
1166     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1167         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1168     }
1169 
1170     /**
1171      * @dev Returns one of the accounts that have `role`. `index` must be a
1172      * value between 0 and {getRoleMemberCount}, non-inclusive.
1173      *
1174      * Role bearers are not sorted in any particular way, and their ordering may
1175      * change at any point.
1176      *
1177      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1178      * you perform all queries on the same block. See the following
1179      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1180      * for more information.
1181      */
1182     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1183         return _roleMembers[role].at(index);
1184     }
1185 
1186     /**
1187      * @dev Returns the number of accounts that have `role`. Can be used
1188      * together with {getRoleMember} to enumerate all bearers of a role.
1189      */
1190     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1191         return _roleMembers[role].length();
1192     }
1193 
1194     /**
1195      * @dev Overload {grantRole} to track enumerable memberships
1196      */
1197     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1198         super.grantRole(role, account);
1199         _roleMembers[role].add(account);
1200     }
1201 
1202     /**
1203      * @dev Overload {revokeRole} to track enumerable memberships
1204      */
1205     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1206         super.revokeRole(role, account);
1207         _roleMembers[role].remove(account);
1208     }
1209 
1210     /**
1211      * @dev Overload {renounceRole} to track enumerable memberships
1212      */
1213     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1214         super.renounceRole(role, account);
1215         _roleMembers[role].remove(account);
1216     }
1217 
1218     /**
1219      * @dev Overload {_setupRole} to track enumerable memberships
1220      */
1221     function _setupRole(bytes32 role, address account) internal virtual override {
1222         super._setupRole(role, account);
1223         _roleMembers[role].add(account);
1224     }
1225 }
1226 
1227 // File: swapContract.sol
1228 
1229 contract SwapContract is AccessControlEnumerable
1230 {
1231     bytes32 public constant VALIDATOR_ROLE = keccak256("VALIDATOR_ROLE");
1232 
1233     IERC20 public tokenAddress;
1234     uint256 public maxSwapAmountPerTx;
1235     uint256 public minSwapAmountPerTx;
1236 
1237     uint128 [3] public swapRatios;
1238     bool [3] public swapEnabled;
1239 
1240     mapping(address => bool) public swapLimitsSaved;
1241     mapping(address => uint256 [3]) swapLimits;
1242 
1243     event Deposit(address user, uint256 amount, uint256 amountToReceive, address newAddress);
1244     event TokensClaimed(address recipient, uint256 amount);
1245 
1246     /**
1247       * @dev throws if transaction sender is not in owner role
1248       */
1249     modifier onlyOwner() {
1250         require(
1251             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
1252             "Caller is not in owner role"
1253         );
1254         _;
1255     }
1256 
1257     /**
1258       * @dev throws if transaction sender is not in owner or validator role
1259       */
1260     modifier onlyOwnerAndValidator() {
1261         require(
1262             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) || hasRole(VALIDATOR_ROLE, _msgSender()),
1263             "Caller is not in owner or validator role"
1264         );
1265         _;
1266     }
1267 
1268     /**
1269       * @dev Constructor of contract
1270       * @param _tokenAddress Token contract address
1271       * @param validatorAddress Swap limits validator address
1272       * @param _swapRatios Swap ratios array
1273       * @param _swapEnabled Array that represents if swap enabled for ratio
1274       * @param _minSwapAmountPerTx Minimum token amount for swap per transaction
1275       * @param _maxSwapAmountPerTx Maximum token amount for swap per transaction
1276       */
1277     constructor(
1278         IERC20 _tokenAddress,
1279         address validatorAddress,
1280         uint128 [3] memory _swapRatios,
1281         bool [3] memory _swapEnabled,
1282         uint256 _minSwapAmountPerTx,
1283         uint256 _maxSwapAmountPerTx
1284     )
1285     {
1286         swapRatios = _swapRatios;
1287         swapEnabled = _swapEnabled;
1288         maxSwapAmountPerTx = _maxSwapAmountPerTx;
1289         minSwapAmountPerTx = _minSwapAmountPerTx;
1290         tokenAddress = _tokenAddress;
1291         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1292         _setupRole(VALIDATOR_ROLE, validatorAddress);
1293     }
1294 
1295      /**
1296       * @dev Transfers tokens from sender to the contract.
1297       * User calls this function when he wants to deposit tokens for the first time.
1298       * @param amountToSend Maximum amount of tokens to send
1299       * @param newAddress Address in the blockchain where the user wants to get tokens
1300       * @param signedAddress Signed Address
1301       * @param signedSwapLimits Signed swap limits
1302       * @param signature Signed address + swapLimits keccak hash
1303       */
1304     function depositWithSignature(
1305         uint256 amountToSend,
1306         address newAddress,
1307         address signedAddress,
1308         uint256 [3] memory signedSwapLimits,
1309         bytes memory signature
1310     ) external
1311     {
1312         address sender = _msgSender();
1313         uint256 senderBalance = tokenAddress.balanceOf(sender);
1314         require(senderBalance >= amountToSend, "swapContract: Insufficient balance");
1315         require(amountToSend >= minSwapAmountPerTx, "swapContract: Less than required minimum of tokens requested");
1316         require(amountToSend <= maxSwapAmountPerTx, "swapContract: Swap limit per transaction exceeded");
1317         require(sender == signedAddress, "swapContract: Signed and sender address does not match");
1318         require(!swapLimitsSaved[sender], "swapContract: Swap limits already saved");
1319 
1320         bytes32 hashedParams = keccak256(abi.encodePacked(signedAddress, signedSwapLimits));
1321         address validatorAddress = ECDSA.recover(ECDSA.toEthSignedMessageHash(hashedParams), signature);
1322         require(isValidator(validatorAddress), "swapContract: Invalid swap limits validator");
1323 
1324         (uint256[3] memory swapLimitsNew, uint256 amountToPay, uint256 amountToReceive) = calculateAmountsAfterSwap(
1325             signedSwapLimits, amountToSend, true
1326         );
1327         require(amountToPay > 0, "swapContract: Swap limit reached");
1328         require(amountToReceive > 0, "swapContract: Amount to receive is zero");
1329 
1330         swapLimits[sender] = swapLimitsNew;
1331         swapLimitsSaved[sender] = true;
1332 
1333         TransferHelper.safeTransferFrom(address(tokenAddress), sender, address(this), amountToPay);
1334         emit Deposit(sender, amountToPay, amountToReceive, newAddress);
1335     }
1336 
1337     /**
1338       * @dev Transfers tokens from sender to the contract.
1339       * User calls this function when he wants to deposit tokens
1340       * if the swap limits have been already saved into the contract storage
1341       * @param amountToSend Maximum amount of tokens to send
1342       * @param newAddress Address in the blockchain where the user wants to get tokens
1343       */
1344      function deposit(
1345         uint256 amountToSend,
1346         address newAddress
1347     ) external
1348     {
1349         address sender = _msgSender();
1350         uint256 senderBalance = tokenAddress.balanceOf(sender);
1351         require(senderBalance >= amountToSend, "swapContract: Not enough balance");
1352         require(amountToSend >= minSwapAmountPerTx, "swapContract: Less than required minimum of tokens requested");
1353         require(amountToSend <= maxSwapAmountPerTx, "swapContract: Swap limit per transaction exceeded");
1354         require(swapLimitsSaved[sender], "swapContract: Swap limits not saved");
1355 
1356         (uint256[3] memory swapLimitsNew, uint256 amountToPay, uint256 amountToReceive) = calculateAmountsAfterSwap(
1357             swapLimits[sender], amountToSend, true
1358         );
1359 
1360         require(amountToPay > 0, "swapContract: Swap limit reached");
1361         require(amountToReceive > 0, "swapContract: Amount to receive is zero");
1362 
1363         swapLimits[sender] = swapLimitsNew;
1364 
1365         TransferHelper.safeTransferFrom(address(tokenAddress), sender, address(this), amountToPay);
1366         emit Deposit(sender, amountToPay, amountToReceive, newAddress);
1367     }
1368 
1369     /**
1370       * @dev Calculates actual amount to pay, amount to receive and new swap limits after swap
1371       * @param _swapLimits Swap limits array
1372       * @param amountToSend Maximum amount of tokens to send
1373       * @param checkIfSwapEnabled Check if swap enabled for a ratio
1374       * @return swapLimitsNew Swap limits after deposit is processed
1375       * @return amountToPay Actual amount of tokens to pay (amountToPay <= amountToSend)
1376       * @return amountToReceive Amount of tokens to receive after deposit is processed
1377       */
1378     function calculateAmountsAfterSwap(
1379         uint256[3] memory _swapLimits,
1380         uint256 amountToSend,
1381         bool checkIfSwapEnabled
1382     ) public view returns (
1383         uint256[3] memory swapLimitsNew, uint256 amountToPay, uint256 amountToReceive)
1384     {
1385         amountToReceive = 0;
1386         uint256 remainder = amountToSend;
1387         for (uint256 i = 0; i < _swapLimits.length; i++) {
1388             if (checkIfSwapEnabled && !swapEnabled[i] || swapRatios[i] == 0) {
1389                 continue;
1390             }
1391             uint256 swapLimit = _swapLimits[i];
1392 
1393             if (remainder <= swapLimit) {
1394                 amountToReceive += remainder / swapRatios[i];
1395                 _swapLimits[i] -= remainder;
1396                 remainder = 0;
1397                 break;
1398             } else {
1399                 amountToReceive += swapLimit / swapRatios[i];
1400                 remainder -= swapLimit;
1401                 _swapLimits[i] = 0;
1402             }
1403         }
1404         amountToPay = amountToSend - remainder;
1405         swapLimitsNew = _swapLimits;
1406     }
1407 
1408     /**
1409       * @dev Claims the deposited tokens
1410       * @param recipient Tokens recipient
1411       * @param amount Tokens amount
1412       */
1413     function claimTokens(address recipient, uint256 amount) external onlyOwner
1414     {
1415         uint256 balance = tokenAddress.balanceOf(address(this));
1416         require(balance > 0, "swapContract: Token balance is zero");
1417         require(balance >= amount, "swapContract: Not enough balance to claim");
1418         if (amount == 0) {
1419             amount = balance;
1420         }
1421         TransferHelper.safeTransfer(address(tokenAddress), recipient, amount);
1422         emit TokensClaimed(recipient, amount);
1423     }
1424 
1425     /**
1426       * @dev Changes requirement for minimal token amount to deposit
1427       * @param _minSwapAmountPerTx Amount of tokens
1428       */
1429     function setMinSwapAmountPerTx(uint256 _minSwapAmountPerTx) external onlyOwner {
1430         minSwapAmountPerTx = _minSwapAmountPerTx;
1431     }
1432 
1433     /**
1434       * @dev Changes requirement for maximum token amount to deposit
1435       * @param _maxSwapAmountPerTx Amount of tokens
1436       */
1437     function setMaxSwapAmountPerTx(uint256 _maxSwapAmountPerTx) external onlyOwner {
1438         maxSwapAmountPerTx = _maxSwapAmountPerTx;
1439     }
1440 
1441     /**
1442       * @dev Changes swap ratio
1443       * @param index Ratio index
1444       * @param ratio Ratio value
1445       */
1446     function setSwapRatio(uint128 index, uint128 ratio) external onlyOwner {
1447         swapRatios[index] = ratio;
1448     }
1449 
1450     /**
1451       * @dev Enables swap for a ratio
1452       * @param index Swap rate index
1453       */
1454     function enableSwap(uint128 index) external onlyOwner {
1455         swapEnabled[index] = true;
1456     }
1457 
1458     /**
1459       * @dev Disables swap for a ratio
1460       * @param index Swap rate index
1461       */
1462     function disableSwap(uint128 index) external onlyOwner {
1463         swapEnabled[index] = false;
1464     }
1465 
1466     /**
1467       * @dev Function to check if address is belongs to owner role
1468       * @param account Account address to check
1469       */
1470     function isOwner(address account) public view returns (bool) {
1471         return hasRole(DEFAULT_ADMIN_ROLE, account);
1472     }
1473 
1474     /**
1475       * @dev Function to check if address is belongs to validator role
1476       * @param account Account address to check
1477       */
1478     function isValidator(address account) public view returns (bool) {
1479         return hasRole(VALIDATOR_ROLE, account);
1480     }
1481 
1482     /**
1483       * @dev Returns account swap limits array
1484       * @param account Account address
1485       * @return Account swap limits array
1486       */
1487     function swapLimitsArray(address account) external view returns (uint256[3] memory)
1488     {
1489         return swapLimits[account];
1490     }
1491 
1492     /**
1493       * @dev Returns array that represents if swap enabled for ratio
1494       * @return Array that represents if swap enabled for ratio
1495       */
1496     function swapEnabledArray() external view returns (bool[3] memory)
1497     {
1498         return swapEnabled;
1499     }
1500 
1501     /**
1502       * @dev Updates swap limits for account
1503       * @param account Account address
1504       * @param _swapLimits Swap limits array
1505       */
1506     function updateSwapLimits(address account, uint256[3] memory _swapLimits) external onlyOwnerAndValidator {
1507         swapLimits[account] = _swapLimits;
1508         swapLimitsSaved[account] = true;
1509     }
1510 }
