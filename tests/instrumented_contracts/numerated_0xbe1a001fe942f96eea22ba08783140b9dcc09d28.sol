1 // File: @openzeppelin/contracts@4.2.0/utils/Context.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // File: @openzeppelin/contracts@4.2.0/utils/Counters.sol
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @title Counters
31  * @author Matt Condon (@shrugs)
32  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
33  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
34  *
35  * Include with `using Counters for Counters.Counter;`
36  */
37 library Counters {
38   struct Counter {
39     // This variable should never be directly accessed by users of the library: interactions must be restricted to
40     // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
41     // this feature: see https://github.com/ethereum/solidity/issues/4637
42     uint _value; // default: 0
43   }
44 
45   function current(Counter storage counter) internal view returns (uint) {
46     return counter._value;
47   }
48 
49   function increment(Counter storage counter) internal {
50     unchecked {
51       counter._value += 1;
52     }
53   }
54 
55   function decrement(Counter storage counter) internal {
56     uint value = counter._value;
57     require(value > 0, 'Counter: decrement overflow');
58     unchecked {
59       counter._value = value - 1;
60     }
61   }
62 
63   function reset(Counter storage counter) internal {
64     counter._value = 0;
65   }
66 }
67 
68 // File: @openzeppelin/contracts@4.2.0/utils/cryptography/ECDSA.sol
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
74  *
75  * These functions can be used to verify that a message was signed by the holder
76  * of the private keys of a given address.
77  */
78 library ECDSA {
79   /**
80    * @dev Returns the address that signed a hashed message (`hash`) with
81    * `signature`. This address can then be used for verification purposes.
82    *
83    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
84    * this function rejects them by requiring the `s` value to be in the lower
85    * half order, and the `v` value to be either 27 or 28.
86    *
87    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
88    * verification to be secure: it is possible to craft signatures that
89    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
90    * this is by receiving a hash of the original message (which may otherwise
91    * be too long), and then calling {toEthSignedMessageHash} on it.
92    *
93    * Documentation for signature generation:
94    * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
95    * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
96    */
97   function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
98     // Check the signature length
99     // - case 65: r,s,v signature (standard)
100     // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
101     if (signature.length == 65) {
102       bytes32 r;
103       bytes32 s;
104       uint8 v;
105       // ecrecover takes the signature parameters, and the only way to get them
106       // currently is to use assembly.
107       assembly {
108         r := mload(add(signature, 0x20))
109         s := mload(add(signature, 0x40))
110         v := byte(0, mload(add(signature, 0x60)))
111       }
112       return recover(hash, v, r, s);
113     } else if (signature.length == 64) {
114       bytes32 r;
115       bytes32 vs;
116       // ecrecover takes the signature parameters, and the only way to get them
117       // currently is to use assembly.
118       assembly {
119         r := mload(add(signature, 0x20))
120         vs := mload(add(signature, 0x40))
121       }
122       return recover(hash, r, vs);
123     } else {
124       revert('ECDSA: invalid signature length');
125     }
126   }
127 
128   /**
129    * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
130    *
131    * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
132    *
133    * _Available since v4.2._
134    */
135   function recover(
136     bytes32 hash,
137     bytes32 r,
138     bytes32 vs
139   ) internal pure returns (address) {
140     bytes32 s;
141     uint8 v;
142     assembly {
143       s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
144       v := add(shr(255, vs), 27)
145     }
146     return recover(hash, v, r, s);
147   }
148 
149   /**
150    * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
151    */
152   function recover(
153     bytes32 hash,
154     uint8 v,
155     bytes32 r,
156     bytes32 s
157   ) internal pure returns (address) {
158     // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
159     // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
160     // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
161     // signatures from current libraries generate a unique signature with an s-value in the lower half order.
162     //
163     // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
164     // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
165     // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
166     // these malleable signatures as well.
167     require(
168       uint(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
169       "ECDSA: invalid signature 's' value"
170     );
171     require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
172 
173     // If the signature is valid (and not malleable), return the signer address
174     address signer = ecrecover(hash, v, r, s);
175     require(signer != address(0), 'ECDSA: invalid signature');
176 
177     return signer;
178   }
179 
180   /**
181    * @dev Returns an Ethereum Signed Message, created from a `hash`. This
182    * produces hash corresponding to the one signed with the
183    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
184    * JSON-RPC method as part of EIP-191.
185    *
186    * See {recover}.
187    */
188   function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
189     // 32 is the length in bytes of hash,
190     // enforced by the type signature above
191     return keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', hash));
192   }
193 
194   /**
195    * @dev Returns an Ethereum Signed Typed Data, created from a
196    * `domainSeparator` and a `structHash`. This produces hash corresponding
197    * to the one signed with the
198    * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
199    * JSON-RPC method as part of EIP-712.
200    *
201    * See {recover}.
202    */
203   function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
204     internal
205     pure
206     returns (bytes32)
207   {
208     return keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
209   }
210 }
211 
212 // File: @openzeppelin/contracts@4.2.0/utils/cryptography/draft-EIP712.sol
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
218  *
219  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
220  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
221  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
222  *
223  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
224  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
225  * ({_hashTypedDataV4}).
226  *
227  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
228  * the chain id to protect against replay attacks on an eventual fork of the chain.
229  *
230  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
231  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
232  *
233  * _Available since v3.4._
234  */
235 abstract contract EIP712 {
236   /* solhint-disable var-name-mixedcase */
237   // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
238   // invalidate the cached domain separator if the chain id changes.
239   bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
240   uint private immutable _CACHED_CHAIN_ID;
241 
242   bytes32 private immutable _HASHED_NAME;
243   bytes32 private immutable _HASHED_VERSION;
244   bytes32 private immutable _TYPE_HASH;
245 
246   /* solhint-enable var-name-mixedcase */
247 
248   /**
249    * @dev Initializes the domain separator and parameter caches.
250    *
251    * The meaning of `name` and `version` is specified in
252    * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
253    *
254    * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
255    * - `version`: the current major version of the signing domain.
256    *
257    * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
258    * contract upgrade].
259    */
260   constructor(string memory name, string memory version) {
261     bytes32 hashedName = keccak256(bytes(name));
262     bytes32 hashedVersion = keccak256(bytes(version));
263     bytes32 typeHash = keccak256(
264       'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
265     );
266     _HASHED_NAME = hashedName;
267     _HASHED_VERSION = hashedVersion;
268     _CACHED_CHAIN_ID = block.chainid;
269     _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
270     _TYPE_HASH = typeHash;
271   }
272 
273   /**
274    * @dev Returns the domain separator for the current chain.
275    */
276   function _domainSeparatorV4() internal view returns (bytes32) {
277     if (block.chainid == _CACHED_CHAIN_ID) {
278       return _CACHED_DOMAIN_SEPARATOR;
279     } else {
280       return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
281     }
282   }
283 
284   function _buildDomainSeparator(
285     bytes32 typeHash,
286     bytes32 nameHash,
287     bytes32 versionHash
288   ) private view returns (bytes32) {
289     return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
290   }
291 
292   /**
293    * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
294    * function returns the hash of the fully encoded EIP712 message for this domain.
295    *
296    * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
297    *
298    * ```solidity
299    * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
300    *     keccak256("Mail(address to,string contents)"),
301    *     mailTo,
302    *     keccak256(bytes(mailContents))
303    * )));
304    * address signer = ECDSA.recover(digest, signature);
305    * ```
306    */
307   function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
308     return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
309   }
310 }
311 
312 // File: @openzeppelin/contracts@4.2.0/token/ERC20/extensions/draft-IERC20Permit.sol
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
318  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
319  *
320  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
321  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
322  * need to send a transaction, and thus is not required to hold Ether at all.
323  */
324 interface IERC20Permit {
325   /**
326    * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
327    * given ``owner``'s signed approval.
328    *
329    * IMPORTANT: The same issues {IERC20-approve} has related to transaction
330    * ordering also apply here.
331    *
332    * Emits an {Approval} event.
333    *
334    * Requirements:
335    *
336    * - `spender` cannot be the zero address.
337    * - `deadline` must be a timestamp in the future.
338    * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
339    * over the EIP712-formatted function arguments.
340    * - the signature must use ``owner``'s current nonce (see {nonces}).
341    *
342    * For more information on the signature format, see the
343    * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
344    * section].
345    */
346   function permit(
347     address owner,
348     address spender,
349     uint value,
350     uint deadline,
351     uint8 v,
352     bytes32 r,
353     bytes32 s
354   ) external;
355 
356   /**
357    * @dev Returns the current nonce for `owner`. This value must be
358    * included whenever a signature is generated for {permit}.
359    *
360    * Every successful call to {permit} increases ``owner``'s nonce by one. This
361    * prevents a signature from being used multiple times.
362    */
363   function nonces(address owner) external view returns (uint);
364 
365   /**
366    * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
367    */
368   // solhint-disable-next-line func-name-mixedcase
369   function DOMAIN_SEPARATOR() external view returns (bytes32);
370 }
371 
372 // File: @openzeppelin/contracts@4.2.0/utils/structs/EnumerableSet.sol
373 
374 pragma solidity ^0.8.0;
375 
376 /**
377  * @dev Library for managing
378  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
379  * types.
380  *
381  * Sets have the following properties:
382  *
383  * - Elements are added, removed, and checked for existence in constant time
384  * (O(1)).
385  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
386  *
387  * ```
388  * contract Example {
389  *     // Add the library methods
390  *     using EnumerableSet for EnumerableSet.AddressSet;
391  *
392  *     // Declare a set state variable
393  *     EnumerableSet.AddressSet private mySet;
394  * }
395  * ```
396  *
397  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
398  * and `uint256` (`UintSet`) are supported.
399  */
400 library EnumerableSet {
401   // To implement this library for multiple types with as little code
402   // repetition as possible, we write it in terms of a generic Set type with
403   // bytes32 values.
404   // The Set implementation uses private functions, and user-facing
405   // implementations (such as AddressSet) are just wrappers around the
406   // underlying Set.
407   // This means that we can only create new EnumerableSets for types that fit
408   // in bytes32.
409 
410   struct Set {
411     // Storage of set values
412     bytes32[] _values;
413     // Position of the value in the `values` array, plus 1 because index 0
414     // means a value is not in the set.
415     mapping(bytes32 => uint) _indexes;
416   }
417 
418   /**
419    * @dev Add a value to a set. O(1).
420    *
421    * Returns true if the value was added to the set, that is if it was not
422    * already present.
423    */
424   function _add(Set storage set, bytes32 value) private returns (bool) {
425     if (!_contains(set, value)) {
426       set._values.push(value);
427       // The value is stored at length-1, but we add 1 to all indexes
428       // and use 0 as a sentinel value
429       set._indexes[value] = set._values.length;
430       return true;
431     } else {
432       return false;
433     }
434   }
435 
436   /**
437    * @dev Removes a value from a set. O(1).
438    *
439    * Returns true if the value was removed from the set, that is if it was
440    * present.
441    */
442   function _remove(Set storage set, bytes32 value) private returns (bool) {
443     // We read and store the value's index to prevent multiple reads from the same storage slot
444     uint valueIndex = set._indexes[value];
445 
446     if (valueIndex != 0) {
447       // Equivalent to contains(set, value)
448       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
449       // the array, and then remove the last element (sometimes called as 'swap and pop').
450       // This modifies the order of the array, as noted in {at}.
451 
452       uint toDeleteIndex = valueIndex - 1;
453       uint lastIndex = set._values.length - 1;
454 
455       if (lastIndex != toDeleteIndex) {
456         bytes32 lastvalue = set._values[lastIndex];
457 
458         // Move the last value to the index where the value to delete is
459         set._values[toDeleteIndex] = lastvalue;
460         // Update the index for the moved value
461         set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
462       }
463 
464       // Delete the slot where the moved value was stored
465       set._values.pop();
466 
467       // Delete the index for the deleted slot
468       delete set._indexes[value];
469 
470       return true;
471     } else {
472       return false;
473     }
474   }
475 
476   /**
477    * @dev Returns true if the value is in the set. O(1).
478    */
479   function _contains(Set storage set, bytes32 value) private view returns (bool) {
480     return set._indexes[value] != 0;
481   }
482 
483   /**
484    * @dev Returns the number of values on the set. O(1).
485    */
486   function _length(Set storage set) private view returns (uint) {
487     return set._values.length;
488   }
489 
490   /**
491    * @dev Returns the value stored at position `index` in the set. O(1).
492    *
493    * Note that there are no guarantees on the ordering of values inside the
494    * array, and it may change when more values are added or removed.
495    *
496    * Requirements:
497    *
498    * - `index` must be strictly less than {length}.
499    */
500   function _at(Set storage set, uint index) private view returns (bytes32) {
501     return set._values[index];
502   }
503 
504   // Bytes32Set
505 
506   struct Bytes32Set {
507     Set _inner;
508   }
509 
510   /**
511    * @dev Add a value to a set. O(1).
512    *
513    * Returns true if the value was added to the set, that is if it was not
514    * already present.
515    */
516   function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
517     return _add(set._inner, value);
518   }
519 
520   /**
521    * @dev Removes a value from a set. O(1).
522    *
523    * Returns true if the value was removed from the set, that is if it was
524    * present.
525    */
526   function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
527     return _remove(set._inner, value);
528   }
529 
530   /**
531    * @dev Returns true if the value is in the set. O(1).
532    */
533   function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
534     return _contains(set._inner, value);
535   }
536 
537   /**
538    * @dev Returns the number of values in the set. O(1).
539    */
540   function length(Bytes32Set storage set) internal view returns (uint) {
541     return _length(set._inner);
542   }
543 
544   /**
545    * @dev Returns the value stored at position `index` in the set. O(1).
546    *
547    * Note that there are no guarantees on the ordering of values inside the
548    * array, and it may change when more values are added or removed.
549    *
550    * Requirements:
551    *
552    * - `index` must be strictly less than {length}.
553    */
554   function at(Bytes32Set storage set, uint index) internal view returns (bytes32) {
555     return _at(set._inner, index);
556   }
557 
558   // AddressSet
559 
560   struct AddressSet {
561     Set _inner;
562   }
563 
564   /**
565    * @dev Add a value to a set. O(1).
566    *
567    * Returns true if the value was added to the set, that is if it was not
568    * already present.
569    */
570   function add(AddressSet storage set, address value) internal returns (bool) {
571     return _add(set._inner, bytes32(uint(uint160(value))));
572   }
573 
574   /**
575    * @dev Removes a value from a set. O(1).
576    *
577    * Returns true if the value was removed from the set, that is if it was
578    * present.
579    */
580   function remove(AddressSet storage set, address value) internal returns (bool) {
581     return _remove(set._inner, bytes32(uint(uint160(value))));
582   }
583 
584   /**
585    * @dev Returns true if the value is in the set. O(1).
586    */
587   function contains(AddressSet storage set, address value) internal view returns (bool) {
588     return _contains(set._inner, bytes32(uint(uint160(value))));
589   }
590 
591   /**
592    * @dev Returns the number of values in the set. O(1).
593    */
594   function length(AddressSet storage set) internal view returns (uint) {
595     return _length(set._inner);
596   }
597 
598   /**
599    * @dev Returns the value stored at position `index` in the set. O(1).
600    *
601    * Note that there are no guarantees on the ordering of values inside the
602    * array, and it may change when more values are added or removed.
603    *
604    * Requirements:
605    *
606    * - `index` must be strictly less than {length}.
607    */
608   function at(AddressSet storage set, uint index) internal view returns (address) {
609     return address(uint160(uint(_at(set._inner, index))));
610   }
611 
612   // UintSet
613 
614   struct UintSet {
615     Set _inner;
616   }
617 
618   /**
619    * @dev Add a value to a set. O(1).
620    *
621    * Returns true if the value was added to the set, that is if it was not
622    * already present.
623    */
624   function add(UintSet storage set, uint value) internal returns (bool) {
625     return _add(set._inner, bytes32(value));
626   }
627 
628   /**
629    * @dev Removes a value from a set. O(1).
630    *
631    * Returns true if the value was removed from the set, that is if it was
632    * present.
633    */
634   function remove(UintSet storage set, uint value) internal returns (bool) {
635     return _remove(set._inner, bytes32(value));
636   }
637 
638   /**
639    * @dev Returns true if the value is in the set. O(1).
640    */
641   function contains(UintSet storage set, uint value) internal view returns (bool) {
642     return _contains(set._inner, bytes32(value));
643   }
644 
645   /**
646    * @dev Returns the number of values on the set. O(1).
647    */
648   function length(UintSet storage set) internal view returns (uint) {
649     return _length(set._inner);
650   }
651 
652   /**
653    * @dev Returns the value stored at position `index` in the set. O(1).
654    *
655    * Note that there are no guarantees on the ordering of values inside the
656    * array, and it may change when more values are added or removed.
657    *
658    * Requirements:
659    *
660    * - `index` must be strictly less than {length}.
661    */
662   function at(UintSet storage set, uint index) internal view returns (uint) {
663     return uint(_at(set._inner, index));
664   }
665 }
666 
667 // File: @openzeppelin/contracts@4.2.0/utils/introspection/IERC165.sol
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Interface of the ERC165 standard, as defined in the
673  * https://eips.ethereum.org/EIPS/eip-165[EIP].
674  *
675  * Implementers can declare support of contract interfaces, which can then be
676  * queried by others ({ERC165Checker}).
677  *
678  * For an implementation, see {ERC165}.
679  */
680 interface IERC165 {
681   /**
682    * @dev Returns true if this contract implements the interface defined by
683    * `interfaceId`. See the corresponding
684    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
685    * to learn more about how these ids are created.
686    *
687    * This function call must use less than 30 000 gas.
688    */
689   function supportsInterface(bytes4 interfaceId) external view returns (bool);
690 }
691 
692 // File: @openzeppelin/contracts@4.2.0/utils/introspection/ERC165.sol
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @dev Implementation of the {IERC165} interface.
698  *
699  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
700  * for the additional interface id that will be supported. For example:
701  *
702  * ```solidity
703  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
705  * }
706  * ```
707  *
708  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
709  */
710 abstract contract ERC165 is IERC165 {
711   /**
712    * @dev See {IERC165-supportsInterface}.
713    */
714   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715     return interfaceId == type(IERC165).interfaceId;
716   }
717 }
718 
719 // File: @openzeppelin/contracts@4.2.0/utils/Strings.sol
720 
721 pragma solidity ^0.8.0;
722 
723 /**
724  * @dev String operations.
725  */
726 library Strings {
727   bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
728 
729   /**
730    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
731    */
732   function toString(uint value) internal pure returns (string memory) {
733     // Inspired by OraclizeAPI's implementation - MIT licence
734     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
735 
736     if (value == 0) {
737       return '0';
738     }
739     uint temp = value;
740     uint digits;
741     while (temp != 0) {
742       digits++;
743       temp /= 10;
744     }
745     bytes memory buffer = new bytes(digits);
746     while (value != 0) {
747       digits -= 1;
748       buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
749       value /= 10;
750     }
751     return string(buffer);
752   }
753 
754   /**
755    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
756    */
757   function toHexString(uint value) internal pure returns (string memory) {
758     if (value == 0) {
759       return '0x00';
760     }
761     uint temp = value;
762     uint length = 0;
763     while (temp != 0) {
764       length++;
765       temp >>= 8;
766     }
767     return toHexString(value, length);
768   }
769 
770   /**
771    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
772    */
773   function toHexString(uint value, uint length) internal pure returns (string memory) {
774     bytes memory buffer = new bytes(2 * length + 2);
775     buffer[0] = '0';
776     buffer[1] = 'x';
777     for (uint i = 2 * length + 1; i > 1; --i) {
778       buffer[i] = _HEX_SYMBOLS[value & 0xf];
779       value >>= 4;
780     }
781     require(value == 0, 'Strings: hex length insufficient');
782     return string(buffer);
783   }
784 }
785 
786 
787 // File: @openzeppelin/contracts@4.2.0/token/ERC20/IERC20.sol
788 
789 pragma solidity ^0.8.0;
790 
791 /**
792  * @dev Interface of the ERC20 standard as defined in the EIP.
793  */
794 interface IERC20 {
795     /**
796      * @dev Returns the amount of tokens in existence.
797      */
798     function totalSupply() external view returns (uint256);
799 
800     /**
801      * @dev Returns the amount of tokens owned by `account`.
802      */
803     function balanceOf(address account) external view returns (uint256);
804 
805     /**
806      * @dev Moves `amount` tokens from the caller's account to `recipient`.
807      *
808      * Returns a boolean value indicating whether the operation succeeded.
809      *
810      * Emits a {Transfer} event.
811      */
812     function transfer(address recipient, uint256 amount) external returns (bool);
813 
814     /**
815      * @dev Returns the remaining number of tokens that `spender` will be
816      * allowed to spend on behalf of `owner` through {transferFrom}. This is
817      * zero by default.
818      *
819      * This value changes when {approve} or {transferFrom} are called.
820      */
821     function allowance(address owner, address spender) external view returns (uint256);
822 
823     /**
824      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
825      *
826      * Returns a boolean value indicating whether the operation succeeded.
827      *
828      * IMPORTANT: Beware that changing an allowance with this method brings the risk
829      * that someone may use both the old and the new allowance by unfortunate
830      * transaction ordering. One possible solution to mitigate this race
831      * condition is to first reduce the spender's allowance to 0 and set the
832      * desired value afterwards:
833      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
834      *
835      * Emits an {Approval} event.
836      */
837     function approve(address spender, uint256 amount) external returns (bool);
838 
839     /**
840      * @dev Moves `amount` tokens from `sender` to `recipient` using the
841      * allowance mechanism. `amount` is then deducted from the caller's
842      * allowance.
843      *
844      * Returns a boolean value indicating whether the operation succeeded.
845      *
846      * Emits a {Transfer} event.
847      */
848     function transferFrom(
849         address sender,
850         address recipient,
851         uint256 amount
852     ) external returns (bool);
853 
854     /**
855      * @dev Emitted when `value` tokens are moved from one account (`from`) to
856      * another (`to`).
857      *
858      * Note that `value` may be zero.
859      */
860     event Transfer(address indexed from, address indexed to, uint256 value);
861 
862     /**
863      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
864      * a call to {approve}. `value` is the new allowance.
865      */
866     event Approval(address indexed owner, address indexed spender, uint256 value);
867 }
868 
869 // File: @openzeppelin/contracts@4.2.0/token/ERC20/extensions/IERC20Metadata.sol
870 
871 pragma solidity ^0.8.0;
872 
873 /**
874  * @dev Interface for the optional metadata functions from the ERC20 standard.
875  *
876  * _Available since v4.1._
877  */
878 interface IERC20Metadata is IERC20 {
879     /**
880      * @dev Returns the name of the token.
881      */
882     function name() external view returns (string memory);
883 
884     /**
885      * @dev Returns the symbol of the token.
886      */
887     function symbol() external view returns (string memory);
888 
889     /**
890      * @dev Returns the decimals places of the token.
891      */
892     function decimals() external view returns (uint8);
893 }
894 
895 
896 // File: @openzeppelin/contracts@4.2.0/token/ERC20/ERC20.sol
897 
898 pragma solidity ^0.8.0;
899 
900 /**
901  * @dev Implementation of the {IERC20} interface.
902  *
903  * This implementation is agnostic to the way tokens are created. This means
904  * that a supply mechanism has to be added in a derived contract using {_mint}.
905  * For a generic mechanism see {ERC20PresetMinterPauser}.
906  *
907  * TIP: For a detailed writeup see our guide
908  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
909  * to implement supply mechanisms].
910  *
911  * We have followed general OpenZeppelin guidelines: functions revert instead
912  * of returning `false` on failure. This behavior is nonetheless conventional
913  * and does not conflict with the expectations of ERC20 applications.
914  *
915  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
916  * This allows applications to reconstruct the allowance for all accounts just
917  * by listening to said events. Other implementations of the EIP may not emit
918  * these events, as it isn't required by the specification.
919  *
920  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
921  * functions have been added to mitigate the well-known issues around setting
922  * allowances. See {IERC20-approve}.
923  */
924 contract ERC20 is Context, IERC20, IERC20Metadata {
925     mapping(address => uint256) private _balances;
926 
927     mapping(address => mapping(address => uint256)) private _allowances;
928 
929     uint256 private _totalSupply;
930 
931     string private _name;
932     string private _symbol;
933 
934     /**
935      * @dev Sets the values for {name} and {symbol}.
936      *
937      * The default value of {decimals} is 18. To select a different value for
938      * {decimals} you should overload it.
939      *
940      * All two of these values are immutable: they can only be set once during
941      * construction.
942      */
943     constructor(string memory name_, string memory symbol_) {
944         _name = name_;
945         _symbol = symbol_;
946     }
947 
948     /**
949      * @dev Returns the name of the token.
950      */
951     function name() public view virtual override returns (string memory) {
952         return _name;
953     }
954 
955     /**
956      * @dev Returns the symbol of the token, usually a shorter version of the
957      * name.
958      */
959     function symbol() public view virtual override returns (string memory) {
960         return _symbol;
961     }
962 
963     /**
964      * @dev Returns the number of decimals used to get its user representation.
965      * For example, if `decimals` equals `2`, a balance of `505` tokens should
966      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
967      *
968      * Tokens usually opt for a value of 18, imitating the relationship between
969      * Ether and Wei. This is the value {ERC20} uses, unless this function is
970      * overridden;
971      *
972      * NOTE: This information is only used for _display_ purposes: it in
973      * no way affects any of the arithmetic of the contract, including
974      * {IERC20-balanceOf} and {IERC20-transfer}.
975      */
976     function decimals() public view virtual override returns (uint8) {
977         return 18;
978     }
979 
980     /**
981      * @dev See {IERC20-totalSupply}.
982      */
983     function totalSupply() public view virtual override returns (uint256) {
984         return _totalSupply;
985     }
986 
987     /**
988      * @dev See {IERC20-balanceOf}.
989      */
990     function balanceOf(address account) public view virtual override returns (uint256) {
991         return _balances[account];
992     }
993 
994     /**
995      * @dev See {IERC20-transfer}.
996      *
997      * Requirements:
998      *
999      * - `recipient` cannot be the zero address.
1000      * - the caller must have a balance of at least `amount`.
1001      */
1002     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1003         _transfer(_msgSender(), recipient, amount);
1004         return true;
1005     }
1006 
1007     /**
1008      * @dev See {IERC20-allowance}.
1009      */
1010     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1011         return _allowances[owner][spender];
1012     }
1013 
1014     /**
1015      * @dev See {IERC20-approve}.
1016      *
1017      * Requirements:
1018      *
1019      * - `spender` cannot be the zero address.
1020      */
1021     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1022         _approve(_msgSender(), spender, amount);
1023         return true;
1024     }
1025 
1026     /**
1027      * @dev See {IERC20-transferFrom}.
1028      *
1029      * Emits an {Approval} event indicating the updated allowance. This is not
1030      * required by the EIP. See the note at the beginning of {ERC20}.
1031      *
1032      * Requirements:
1033      *
1034      * - `sender` and `recipient` cannot be the zero address.
1035      * - `sender` must have a balance of at least `amount`.
1036      * - the caller must have allowance for ``sender``'s tokens of at least
1037      * `amount`.
1038      */
1039     function transferFrom(
1040         address sender,
1041         address recipient,
1042         uint256 amount
1043     ) public virtual override returns (bool) {
1044         _transfer(sender, recipient, amount);
1045 
1046         uint256 currentAllowance = _allowances[sender][_msgSender()];
1047         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1048         unchecked {
1049             _approve(sender, _msgSender(), currentAllowance - amount);
1050         }
1051 
1052         return true;
1053     }
1054 
1055     /**
1056      * @dev Atomically increases the allowance granted to `spender` by the caller.
1057      *
1058      * This is an alternative to {approve} that can be used as a mitigation for
1059      * problems described in {IERC20-approve}.
1060      *
1061      * Emits an {Approval} event indicating the updated allowance.
1062      *
1063      * Requirements:
1064      *
1065      * - `spender` cannot be the zero address.
1066      */
1067     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1068         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1069         return true;
1070     }
1071 
1072     /**
1073      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1074      *
1075      * This is an alternative to {approve} that can be used as a mitigation for
1076      * problems described in {IERC20-approve}.
1077      *
1078      * Emits an {Approval} event indicating the updated allowance.
1079      *
1080      * Requirements:
1081      *
1082      * - `spender` cannot be the zero address.
1083      * - `spender` must have allowance for the caller of at least
1084      * `subtractedValue`.
1085      */
1086     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1087         uint256 currentAllowance = _allowances[_msgSender()][spender];
1088         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1089         unchecked {
1090             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1091         }
1092 
1093         return true;
1094     }
1095 
1096     /**
1097      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1098      *
1099      * This internal function is equivalent to {transfer}, and can be used to
1100      * e.g. implement automatic token fees, slashing mechanisms, etc.
1101      *
1102      * Emits a {Transfer} event.
1103      *
1104      * Requirements:
1105      *
1106      * - `sender` cannot be the zero address.
1107      * - `recipient` cannot be the zero address.
1108      * - `sender` must have a balance of at least `amount`.
1109      */
1110     function _transfer(
1111         address sender,
1112         address recipient,
1113         uint256 amount
1114     ) internal virtual {
1115         require(sender != address(0), "ERC20: transfer from the zero address");
1116         require(recipient != address(0), "ERC20: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(sender, recipient, amount);
1119 
1120         uint256 senderBalance = _balances[sender];
1121         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1122         unchecked {
1123             _balances[sender] = senderBalance - amount;
1124         }
1125         _balances[recipient] += amount;
1126 
1127         emit Transfer(sender, recipient, amount);
1128 
1129         _afterTokenTransfer(sender, recipient, amount);
1130     }
1131 
1132     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1133      * the total supply.
1134      *
1135      * Emits a {Transfer} event with `from` set to the zero address.
1136      *
1137      * Requirements:
1138      *
1139      * - `account` cannot be the zero address.
1140      */
1141     function _mint(address account, uint256 amount) internal virtual {
1142         require(account != address(0), "ERC20: mint to the zero address");
1143 
1144         _beforeTokenTransfer(address(0), account, amount);
1145 
1146         _totalSupply += amount;
1147         _balances[account] += amount;
1148         emit Transfer(address(0), account, amount);
1149 
1150         _afterTokenTransfer(address(0), account, amount);
1151     }
1152 
1153     /**
1154      * @dev Destroys `amount` tokens from `account`, reducing the
1155      * total supply.
1156      *
1157      * Emits a {Transfer} event with `to` set to the zero address.
1158      *
1159      * Requirements:
1160      *
1161      * - `account` cannot be the zero address.
1162      * - `account` must have at least `amount` tokens.
1163      */
1164     function _burn(address account, uint256 amount) internal virtual {
1165         require(account != address(0), "ERC20: burn from the zero address");
1166 
1167         _beforeTokenTransfer(account, address(0), amount);
1168 
1169         uint256 accountBalance = _balances[account];
1170         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1171         unchecked {
1172             _balances[account] = accountBalance - amount;
1173         }
1174         _totalSupply -= amount;
1175 
1176         emit Transfer(account, address(0), amount);
1177 
1178         _afterTokenTransfer(account, address(0), amount);
1179     }
1180 
1181     /**
1182      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1183      *
1184      * This internal function is equivalent to `approve`, and can be used to
1185      * e.g. set automatic allowances for certain subsystems, etc.
1186      *
1187      * Emits an {Approval} event.
1188      *
1189      * Requirements:
1190      *
1191      * - `owner` cannot be the zero address.
1192      * - `spender` cannot be the zero address.
1193      */
1194     function _approve(
1195         address owner,
1196         address spender,
1197         uint256 amount
1198     ) internal virtual {
1199         require(owner != address(0), "ERC20: approve from the zero address");
1200         require(spender != address(0), "ERC20: approve to the zero address");
1201 
1202         _allowances[owner][spender] = amount;
1203         emit Approval(owner, spender, amount);
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before any transfer of tokens. This includes
1208      * minting and burning.
1209      *
1210      * Calling conditions:
1211      *
1212      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1213      * will be transferred to `to`.
1214      * - when `from` is zero, `amount` tokens will be minted for `to`.
1215      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1216      * - `from` and `to` are never both zero.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _beforeTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 amount
1224     ) internal virtual {}
1225 
1226     /**
1227      * @dev Hook that is called after any transfer of tokens. This includes
1228      * minting and burning.
1229      *
1230      * Calling conditions:
1231      *
1232      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1233      * has been transferred to `to`.
1234      * - when `from` is zero, `amount` tokens have been minted for `to`.
1235      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1236      * - `from` and `to` are never both zero.
1237      *
1238      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1239      */
1240     function _afterTokenTransfer(
1241         address from,
1242         address to,
1243         uint256 amount
1244     ) internal virtual {}
1245 }
1246 
1247 
1248 // File: @openzeppelin/contracts@4.2.0/access/AccessControl.sol
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 /**
1253  * @dev External interface of AccessControl declared to support ERC165 detection.
1254  */
1255 interface IAccessControl {
1256   function hasRole(bytes32 role, address account) external view returns (bool);
1257 
1258   function getRoleAdmin(bytes32 role) external view returns (bytes32);
1259 
1260   function grantRole(bytes32 role, address account) external;
1261 
1262   function revokeRole(bytes32 role, address account) external;
1263 
1264   function renounceRole(bytes32 role, address account) external;
1265 }
1266 
1267 /**
1268  * @dev Contract module that allows children to implement role-based access
1269  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1270  * members except through off-chain means by accessing the contract event logs. Some
1271  * applications may benefit from on-chain enumerability, for those cases see
1272  * {AccessControlEnumerable}.
1273  *
1274  * Roles are referred to by their `bytes32` identifier. These should be exposed
1275  * in the external API and be unique. The best way to achieve this is by
1276  * using `public constant` hash digests:
1277  *
1278  * ```
1279  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1280  * ```
1281  *
1282  * Roles can be used to represent a set of permissions. To restrict access to a
1283  * function call, use {hasRole}:
1284  *
1285  * ```
1286  * function foo() public {
1287  *     require(hasRole(MY_ROLE, msg.sender));
1288  *     ...
1289  * }
1290  * ```
1291  *
1292  * Roles can be granted and revoked dynamically via the {grantRole} and
1293  * {revokeRole} functions. Each role has an associated admin role, and only
1294  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1295  *
1296  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1297  * that only accounts with this role will be able to grant or revoke other
1298  * roles. More complex role relationships can be created by using
1299  * {_setRoleAdmin}.
1300  *
1301  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1302  * grant and revoke this role. Extra precautions should be taken to secure
1303  * accounts that have been granted it.
1304  */
1305 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1306   struct RoleData {
1307     mapping(address => bool) members;
1308     bytes32 adminRole;
1309   }
1310 
1311   mapping(bytes32 => RoleData) private _roles;
1312 
1313   bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1314 
1315   /**
1316    * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1317    *
1318    * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1319    * {RoleAdminChanged} not being emitted signaling this.
1320    *
1321    * _Available since v3.1._
1322    */
1323   event RoleAdminChanged(
1324     bytes32 indexed role,
1325     bytes32 indexed previousAdminRole,
1326     bytes32 indexed newAdminRole
1327   );
1328 
1329   /**
1330    * @dev Emitted when `account` is granted `role`.
1331    *
1332    * `sender` is the account that originated the contract call, an admin role
1333    * bearer except when using {_setupRole}.
1334    */
1335   event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1336 
1337   /**
1338    * @dev Emitted when `account` is revoked `role`.
1339    *
1340    * `sender` is the account that originated the contract call:
1341    *   - if using `revokeRole`, it is the admin role bearer
1342    *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1343    */
1344   event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1345 
1346   /**
1347    * @dev Modifier that checks that an account has a specific role. Reverts
1348    * with a standardized message including the required role.
1349    *
1350    * The format of the revert reason is given by the following regular expression:
1351    *
1352    *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1353    *
1354    * _Available since v4.1._
1355    */
1356   modifier onlyRole(bytes32 role) {
1357     _checkRole(role, _msgSender());
1358     _;
1359   }
1360 
1361   /**
1362    * @dev See {IERC165-supportsInterface}.
1363    */
1364   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1365     return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1366   }
1367 
1368   /**
1369    * @dev Returns `true` if `account` has been granted `role`.
1370    */
1371   function hasRole(bytes32 role, address account) public view override returns (bool) {
1372     return _roles[role].members[account];
1373   }
1374 
1375   /**
1376    * @dev Revert with a standard message if `account` is missing `role`.
1377    *
1378    * The format of the revert reason is given by the following regular expression:
1379    *
1380    *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
1381    */
1382   function _checkRole(bytes32 role, address account) internal view {
1383     if (!hasRole(role, account)) {
1384       revert(
1385         string(
1386           abi.encodePacked(
1387             'AccessControl: account ',
1388             Strings.toHexString(uint160(account), 20),
1389             ' is missing role ',
1390             Strings.toHexString(uint(role), 32)
1391           )
1392         )
1393       );
1394     }
1395   }
1396 
1397   /**
1398    * @dev Returns the admin role that controls `role`. See {grantRole} and
1399    * {revokeRole}.
1400    *
1401    * To change a role's admin, use {_setRoleAdmin}.
1402    */
1403   function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1404     return _roles[role].adminRole;
1405   }
1406 
1407   /**
1408    * @dev Grants `role` to `account`.
1409    *
1410    * If `account` had not been already granted `role`, emits a {RoleGranted}
1411    * event.
1412    *
1413    * Requirements:
1414    *
1415    * - the caller must have ``role``'s admin role.
1416    */
1417   function grantRole(bytes32 role, address account)
1418     public
1419     virtual
1420     override
1421     onlyRole(getRoleAdmin(role))
1422   {
1423     _grantRole(role, account);
1424   }
1425 
1426   /**
1427    * @dev Revokes `role` from `account`.
1428    *
1429    * If `account` had been granted `role`, emits a {RoleRevoked} event.
1430    *
1431    * Requirements:
1432    *
1433    * - the caller must have ``role``'s admin role.
1434    */
1435   function revokeRole(bytes32 role, address account)
1436     public
1437     virtual
1438     override
1439     onlyRole(getRoleAdmin(role))
1440   {
1441     _revokeRole(role, account);
1442   }
1443 
1444   /**
1445    * @dev Revokes `role` from the calling account.
1446    *
1447    * Roles are often managed via {grantRole} and {revokeRole}: this function's
1448    * purpose is to provide a mechanism for accounts to lose their privileges
1449    * if they are compromised (such as when a trusted device is misplaced).
1450    *
1451    * If the calling account had been granted `role`, emits a {RoleRevoked}
1452    * event.
1453    *
1454    * Requirements:
1455    *
1456    * - the caller must be `account`.
1457    */
1458   function renounceRole(bytes32 role, address account) public virtual override {
1459     require(account == _msgSender(), 'AccessControl: can only renounce roles for self');
1460 
1461     _revokeRole(role, account);
1462   }
1463 
1464   /**
1465    * @dev Grants `role` to `account`.
1466    *
1467    * If `account` had not been already granted `role`, emits a {RoleGranted}
1468    * event. Note that unlike {grantRole}, this function doesn't perform any
1469    * checks on the calling account.
1470    *
1471    * [WARNING]
1472    * ====
1473    * This function should only be called from the constructor when setting
1474    * up the initial roles for the system.
1475    *
1476    * Using this function in any other way is effectively circumventing the admin
1477    * system imposed by {AccessControl}.
1478    * ====
1479    */
1480   function _setupRole(bytes32 role, address account) internal virtual {
1481     _grantRole(role, account);
1482   }
1483 
1484   /**
1485    * @dev Sets `adminRole` as ``role``'s admin role.
1486    *
1487    * Emits a {RoleAdminChanged} event.
1488    */
1489   function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1490     emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1491     _roles[role].adminRole = adminRole;
1492   }
1493 
1494   function _grantRole(bytes32 role, address account) private {
1495     if (!hasRole(role, account)) {
1496       _roles[role].members[account] = true;
1497       emit RoleGranted(role, account, _msgSender());
1498     }
1499   }
1500 
1501   function _revokeRole(bytes32 role, address account) private {
1502     if (hasRole(role, account)) {
1503       _roles[role].members[account] = false;
1504       emit RoleRevoked(role, account, _msgSender());
1505     }
1506   }
1507 }
1508 
1509 // File: @openzeppelin/contracts@4.2.0/access/AccessControlEnumerable.sol
1510 
1511 pragma solidity ^0.8.0;
1512 
1513 /**
1514  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1515  */
1516 interface IAccessControlEnumerable {
1517     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1518 
1519     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1520 }
1521 
1522 /**
1523  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1524  */
1525 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1526     using EnumerableSet for EnumerableSet.AddressSet;
1527 
1528     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1529 
1530     /**
1531      * @dev See {IERC165-supportsInterface}.
1532      */
1533     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1534         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1535     }
1536 
1537     /**
1538      * @dev Returns one of the accounts that have `role`. `index` must be a
1539      * value between 0 and {getRoleMemberCount}, non-inclusive.
1540      *
1541      * Role bearers are not sorted in any particular way, and their ordering may
1542      * change at any point.
1543      *
1544      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1545      * you perform all queries on the same block. See the following
1546      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1547      * for more information.
1548      */
1549     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1550         return _roleMembers[role].at(index);
1551     }
1552 
1553     /**
1554      * @dev Returns the number of accounts that have `role`. Can be used
1555      * together with {getRoleMember} to enumerate all bearers of a role.
1556      */
1557     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1558         return _roleMembers[role].length();
1559     }
1560 
1561     /**
1562      * @dev Overload {grantRole} to track enumerable memberships
1563      */
1564     function grantRole(bytes32 role, address account) public virtual override {
1565         super.grantRole(role, account);
1566         _roleMembers[role].add(account);
1567     }
1568 
1569     /**
1570      * @dev Overload {revokeRole} to track enumerable memberships
1571      */
1572     function revokeRole(bytes32 role, address account) public virtual override {
1573         super.revokeRole(role, account);
1574         _roleMembers[role].remove(account);
1575     }
1576 
1577     /**
1578      * @dev Overload {renounceRole} to track enumerable memberships
1579      */
1580     function renounceRole(bytes32 role, address account) public virtual override {
1581         super.renounceRole(role, account);
1582         _roleMembers[role].remove(account);
1583     }
1584 
1585     /**
1586      * @dev Overload {_setupRole} to track enumerable memberships
1587      */
1588     function _setupRole(bytes32 role, address account) internal virtual override {
1589         super._setupRole(role, account);
1590         _roleMembers[role].add(account);
1591     }
1592 }
1593 
1594 // File: @openzeppelin/contracts@4.2.0/security/Pausable.sol
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 /**
1599  * @dev Contract module which allows children to implement an emergency stop
1600  * mechanism that can be triggered by an authorized account.
1601  *
1602  * This module is used through inheritance. It will make available the
1603  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1604  * the functions of your contract. Note that they will not be pausable by
1605  * simply including this module, only once the modifiers are put in place.
1606  */
1607 abstract contract Pausable is Context {
1608     /**
1609      * @dev Emitted when the pause is triggered by `account`.
1610      */
1611     event Paused(address account);
1612 
1613     /**
1614      * @dev Emitted when the pause is lifted by `account`.
1615      */
1616     event Unpaused(address account);
1617 
1618     bool private _paused;
1619 
1620     /**
1621      * @dev Initializes the contract in unpaused state.
1622      */
1623     constructor() {
1624         _paused = false;
1625     }
1626 
1627     /**
1628      * @dev Returns true if the contract is paused, and false otherwise.
1629      */
1630     function paused() public view virtual returns (bool) {
1631         return _paused;
1632     }
1633 
1634     /**
1635      * @dev Modifier to make a function callable only when the contract is not paused.
1636      *
1637      * Requirements:
1638      *
1639      * - The contract must not be paused.
1640      */
1641     modifier whenNotPaused() {
1642         require(!paused(), "Pausable: paused");
1643         _;
1644     }
1645 
1646     /**
1647      * @dev Modifier to make a function callable only when the contract is paused.
1648      *
1649      * Requirements:
1650      *
1651      * - The contract must be paused.
1652      */
1653     modifier whenPaused() {
1654         require(paused(), "Pausable: not paused");
1655         _;
1656     }
1657 
1658     /**
1659      * @dev Triggers stopped state.
1660      *
1661      * Requirements:
1662      *
1663      * - The contract must not be paused.
1664      */
1665     function _pause() internal virtual whenNotPaused {
1666         _paused = true;
1667         emit Paused(_msgSender());
1668     }
1669 
1670     /**
1671      * @dev Returns to normal state.
1672      *
1673      * Requirements:
1674      *
1675      * - The contract must be paused.
1676      */
1677     function _unpause() internal virtual whenPaused {
1678         _paused = false;
1679         emit Unpaused(_msgSender());
1680     }
1681 }
1682 
1683 // File: @openzeppelin/contracts@4.2.0/token/ERC20/extensions/ERC20Pausable.sol
1684 
1685 pragma solidity ^0.8.0;
1686 
1687 /**
1688  * @dev ERC20 token with pausable token transfers, minting and burning.
1689  *
1690  * Useful for scenarios such as preventing trades until the end of an evaluation
1691  * period, or having an emergency switch for freezing all token transfers in the
1692  * event of a large bug.
1693  */
1694 abstract contract ERC20Pausable is ERC20, Pausable {
1695     /**
1696      * @dev See {ERC20-_beforeTokenTransfer}.
1697      *
1698      * Requirements:
1699      *
1700      * - the contract must not be paused.
1701      */
1702     function _beforeTokenTransfer(
1703         address from,
1704         address to,
1705         uint256 amount
1706     ) internal virtual override {
1707         super._beforeTokenTransfer(from, to, amount);
1708 
1709         require(!paused(), "ERC20Pausable: token transfer while paused");
1710     }
1711 }
1712 
1713 // File: @openzeppelin/contracts@4.2.0/token/ERC20/extensions/ERC20Burnable.sol
1714 
1715 pragma solidity ^0.8.0;
1716 
1717 /**
1718  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1719  * tokens and those that they have an allowance for, in a way that can be
1720  * recognized off-chain (via event analysis).
1721  */
1722 abstract contract ERC20Burnable is Context, ERC20 {
1723     /**
1724      * @dev Destroys `amount` tokens from the caller.
1725      *
1726      * See {ERC20-_burn}.
1727      */
1728     function burn(uint256 amount) public virtual {
1729         _burn(_msgSender(), amount);
1730     }
1731 
1732     /**
1733      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1734      * allowance.
1735      *
1736      * See {ERC20-_burn} and {ERC20-allowance}.
1737      *
1738      * Requirements:
1739      *
1740      * - the caller must have allowance for ``accounts``'s tokens of at least
1741      * `amount`.
1742      */
1743     function burnFrom(address account, uint256 amount) public virtual {
1744         uint256 currentAllowance = allowance(account, _msgSender());
1745         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1746         unchecked {
1747             _approve(account, _msgSender(), currentAllowance - amount);
1748         }
1749         _burn(account, amount);
1750     }
1751 }
1752 
1753 
1754 // File: @openzeppelin/contracts@4.2.0/token/ERC20/extensions/draft-ERC20Permit.sol
1755 
1756 pragma solidity ^0.8.0;
1757 
1758 /**
1759  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1760  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1761  *
1762  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1763  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1764  * need to send a transaction, and thus is not required to hold Ether at all.
1765  *
1766  * _Available since v3.4._
1767  */
1768 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1769     using Counters for Counters.Counter;
1770 
1771     mapping(address => Counters.Counter) private _nonces;
1772 
1773     // solhint-disable-next-line var-name-mixedcase
1774     bytes32 private immutable _PERMIT_TYPEHASH =
1775         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1776 
1777     /**
1778      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1779      *
1780      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1781      */
1782     constructor(string memory name) EIP712(name, "1") {}
1783 
1784     /**
1785      * @dev See {IERC20Permit-permit}.
1786      */
1787     function permit(
1788         address owner,
1789         address spender,
1790         uint256 value,
1791         uint256 deadline,
1792         uint8 v,
1793         bytes32 r,
1794         bytes32 s
1795     ) public virtual override {
1796         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1797 
1798         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1799 
1800         bytes32 hash = _hashTypedDataV4(structHash);
1801 
1802         address signer = ECDSA.recover(hash, v, r, s);
1803         require(signer == owner, "ERC20Permit: invalid signature");
1804 
1805         _approve(owner, spender, value);
1806     }
1807 
1808     /**
1809      * @dev See {IERC20Permit-nonces}.
1810      */
1811     function nonces(address owner) public view virtual override returns (uint256) {
1812         return _nonces[owner].current();
1813     }
1814 
1815     /**
1816      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1817      */
1818     // solhint-disable-next-line func-name-mixedcase
1819     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1820         return _domainSeparatorV4();
1821     }
1822 
1823     /**
1824      * @dev "Consume a nonce": return the current value and increment.
1825      *
1826      * _Available since v4.1._
1827      */
1828     function _useNonce(address owner) internal virtual returns (uint256 current) {
1829         Counters.Counter storage nonce = _nonces[owner];
1830         current = nonce.current();
1831         nonce.increment();
1832     }
1833 }
1834 
1835 // File: @openzeppelin/contracts@4.2.0/token/ERC20/presets/ERC20PresetMinterPauser.sol
1836 
1837 pragma solidity ^0.8.0;
1838 
1839 /**
1840  * @dev {ERC20} token, including:
1841  *
1842  *  - ability for holders to burn (destroy) their tokens
1843  *  - a minter role that allows for token minting (creation)
1844  *  - a pauser role that allows to stop all token transfers
1845  *
1846  * This contract uses {AccessControl} to lock permissioned functions using the
1847  * different roles - head to its documentation for details.
1848  *
1849  * The account that deploys the contract will be granted the minter and pauser
1850  * roles, as well as the default admin role, which will let it grant both minter
1851  * and pauser roles to other accounts.
1852  */
1853 contract ERC20PresetMinterPauser is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
1854     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1855     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1856 
1857     /**
1858      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1859      * account that deploys the contract.
1860      *
1861      * See {ERC20-constructor}.
1862      */
1863     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
1864         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1865 
1866         _setupRole(MINTER_ROLE, _msgSender());
1867         _setupRole(PAUSER_ROLE, _msgSender());
1868     }
1869 
1870     /**
1871      * @dev Creates `amount` new tokens for `to`.
1872      *
1873      * See {ERC20-_mint}.
1874      *
1875      * Requirements:
1876      *
1877      * - the caller must have the `MINTER_ROLE`.
1878      */
1879     function mint(address to, uint256 amount) public virtual {
1880         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1881         _mint(to, amount);
1882     }
1883 
1884     /**
1885      * @dev Pauses all token transfers.
1886      *
1887      * See {ERC20Pausable} and {Pausable-_pause}.
1888      *
1889      * Requirements:
1890      *
1891      * - the caller must have the `PAUSER_ROLE`.
1892      */
1893     function pause() public virtual {
1894         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1895         _pause();
1896     }
1897 
1898     /**
1899      * @dev Unpauses all token transfers.
1900      *
1901      * See {ERC20Pausable} and {Pausable-_unpause}.
1902      *
1903      * Requirements:
1904      *
1905      * - the caller must have the `PAUSER_ROLE`.
1906      */
1907     function unpause() public virtual {
1908         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1909         _unpause();
1910     }
1911 
1912     function _beforeTokenTransfer(
1913         address from,
1914         address to,
1915         uint256 amount
1916     ) internal virtual override(ERC20, ERC20Pausable) {
1917         super._beforeTokenTransfer(from, to, amount);
1918     }
1919 }
1920 
1921 // File: BetaToken.sol
1922 
1923 pragma solidity 0.8.6;
1924 
1925 contract BetaToken is ERC20PresetMinterPauser('Beta Token', 'BETA'), ERC20Permit('BETA') {
1926   function _beforeTokenTransfer(
1927     address from,
1928     address to,
1929     uint amount
1930   ) internal virtual override(ERC20, ERC20PresetMinterPauser) {
1931     ERC20PresetMinterPauser._beforeTokenTransfer(from, to, amount);
1932   }
1933 }