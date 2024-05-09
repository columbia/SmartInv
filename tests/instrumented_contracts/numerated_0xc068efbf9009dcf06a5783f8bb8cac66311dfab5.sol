1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
3 
4 pragma solidity ^0.8.0;
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114     uint8 private constant _ADDRESS_LENGTH = 20;
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
118      */
119     function toString(uint256 value) internal pure returns (string memory) {
120         // Inspired by OraclizeAPI's implementation - MIT licence
121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
122 
123         if (value == 0) {
124             return "0";
125         }
126         uint256 temp = value;
127         uint256 digits;
128         while (temp != 0) {
129             digits++;
130             temp /= 10;
131         }
132         bytes memory buffer = new bytes(digits);
133         while (value != 0) {
134             digits -= 1;
135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
136             value /= 10;
137         }
138         return string(buffer);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
143      */
144     function toHexString(uint256 value) internal pure returns (string memory) {
145         if (value == 0) {
146             return "0x00";
147         }
148         uint256 temp = value;
149         uint256 length = 0;
150         while (temp != 0) {
151             length++;
152             temp >>= 8;
153         }
154         return toHexString(value, length);
155     }
156 
157     /**
158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
159      */
160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
161         bytes memory buffer = new bytes(2 * length + 2);
162         buffer[0] = "0";
163         buffer[1] = "x";
164         for (uint256 i = 2 * length + 1; i > 1; --i) {
165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
166             value >>= 4;
167         }
168         require(value == 0, "Strings: hex length insufficient");
169         return string(buffer);
170     }
171 
172     /**
173      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
174      */
175     function toHexString(address addr) internal pure returns (string memory) {
176         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
177     }
178 }
179 
180 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @dev These functions deal with verification of Merkle Tree proofs.
186  *
187  * The proofs can be generated using the JavaScript library
188  * https://github.com/miguelmota/merkletreejs[merkletreejs].
189  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
190  *
191  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
192  *
193  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
194  * hashing, or use a hash function other than keccak256 for hashing leaves.
195  * This is because the concatenation of a sorted pair of internal nodes in
196  * the merkle tree could be reinterpreted as a leaf value.
197  */
198 library MerkleProof {
199     /**
200      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
201      * defined by `root`. For this, a `proof` must be provided, containing
202      * sibling hashes on the branch from the leaf to the root of the tree. Each
203      * pair of leaves and each pair of pre-images are assumed to be sorted.
204      */
205     function verify(
206         bytes32[] memory proof,
207         bytes32 root,
208         bytes32 leaf
209     ) internal pure returns (bool) {
210         return processProof(proof, leaf) == root;
211     }
212 
213     /**
214      * @dev Calldata version of {verify}
215      *
216      * _Available since v4.7._
217      */
218     function verifyCalldata(
219         bytes32[] calldata proof,
220         bytes32 root,
221         bytes32 leaf
222     ) internal pure returns (bool) {
223         return processProofCalldata(proof, leaf) == root;
224     }
225 
226     /**
227      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
228      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
229      * hash matches the root of the tree. When processing the proof, the pairs
230      * of leafs & pre-images are assumed to be sorted.
231      *
232      * _Available since v4.4._
233      */
234     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
235         bytes32 computedHash = leaf;
236         for (uint256 i = 0; i < proof.length; i++) {
237             computedHash = _hashPair(computedHash, proof[i]);
238         }
239         return computedHash;
240     }
241 
242     /**
243      * @dev Calldata version of {processProof}
244      *
245      * _Available since v4.7._
246      */
247     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
248         bytes32 computedHash = leaf;
249         for (uint256 i = 0; i < proof.length; i++) {
250             computedHash = _hashPair(computedHash, proof[i]);
251         }
252         return computedHash;
253     }
254 
255     /**
256      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
257      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
258      *
259      * _Available since v4.7._
260      */
261     function multiProofVerify(
262         bytes32[] memory proof,
263         bool[] memory proofFlags,
264         bytes32 root,
265         bytes32[] memory leaves
266     ) internal pure returns (bool) {
267         return processMultiProof(proof, proofFlags, leaves) == root;
268     }
269 
270     /**
271      * @dev Calldata version of {multiProofVerify}
272      *
273      * _Available since v4.7._
274      */
275     function multiProofVerifyCalldata(
276         bytes32[] calldata proof,
277         bool[] calldata proofFlags,
278         bytes32 root,
279         bytes32[] memory leaves
280     ) internal pure returns (bool) {
281         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
282     }
283 
284     /**
285      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
286      * consuming from one or the other at each step according to the instructions given by
287      * `proofFlags`.
288      *
289      * _Available since v4.7._
290      */
291     function processMultiProof(
292         bytes32[] memory proof,
293         bool[] memory proofFlags,
294         bytes32[] memory leaves
295     ) internal pure returns (bytes32 merkleRoot) {
296         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
297         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
298         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
299         // the merkle tree.
300         uint256 leavesLen = leaves.length;
301         uint256 totalHashes = proofFlags.length;
302 
303         // Check proof validity.
304         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
305 
306         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
307         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
308         bytes32[] memory hashes = new bytes32[](totalHashes);
309         uint256 leafPos = 0;
310         uint256 hashPos = 0;
311         uint256 proofPos = 0;
312         // At each step, we compute the next hash using two values:
313         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
314         //   get the next hash.
315         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
316         //   `proof` array.
317         for (uint256 i = 0; i < totalHashes; i++) {
318             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
319             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
320             hashes[i] = _hashPair(a, b);
321         }
322 
323         if (totalHashes > 0) {
324             return hashes[totalHashes - 1];
325         } else if (leavesLen > 0) {
326             return leaves[0];
327         } else {
328             return proof[0];
329         }
330     }
331 
332     /**
333      * @dev Calldata version of {processMultiProof}
334      *
335      * _Available since v4.7._
336      */
337     function processMultiProofCalldata(
338         bytes32[] calldata proof,
339         bool[] calldata proofFlags,
340         bytes32[] memory leaves
341     ) internal pure returns (bytes32 merkleRoot) {
342         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
343         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
344         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
345         // the merkle tree.
346         uint256 leavesLen = leaves.length;
347         uint256 totalHashes = proofFlags.length;
348 
349         // Check proof validity.
350         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
351 
352         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
353         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
354         bytes32[] memory hashes = new bytes32[](totalHashes);
355         uint256 leafPos = 0;
356         uint256 hashPos = 0;
357         uint256 proofPos = 0;
358         // At each step, we compute the next hash using two values:
359         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
360         //   get the next hash.
361         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
362         //   `proof` array.
363         for (uint256 i = 0; i < totalHashes; i++) {
364             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
365             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
366             hashes[i] = _hashPair(a, b);
367         }
368 
369         if (totalHashes > 0) {
370             return hashes[totalHashes - 1];
371         } else if (leavesLen > 0) {
372             return leaves[0];
373         } else {
374             return proof[0];
375         }
376     }
377 
378     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
379         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
380     }
381 
382     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
383         /// @solidity memory-safe-assembly
384         assembly {
385             mstore(0x00, a)
386             mstore(0x20, b)
387             value := keccak256(0x00, 0x40)
388         }
389     }
390 }
391 
392 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
398  *
399  * These functions can be used to verify that a message was signed by the holder
400  * of the private keys of a given address.
401  */
402 library ECDSA {
403     enum RecoverError {
404         NoError,
405         InvalidSignature,
406         InvalidSignatureLength,
407         InvalidSignatureS,
408         InvalidSignatureV
409     }
410 
411     function _throwError(RecoverError error) private pure {
412         if (error == RecoverError.NoError) {
413             return; // no error: do nothing
414         } else if (error == RecoverError.InvalidSignature) {
415             revert("ECDSA: invalid signature");
416         } else if (error == RecoverError.InvalidSignatureLength) {
417             revert("ECDSA: invalid signature length");
418         } else if (error == RecoverError.InvalidSignatureS) {
419             revert("ECDSA: invalid signature 's' value");
420         } else if (error == RecoverError.InvalidSignatureV) {
421             revert("ECDSA: invalid signature 'v' value");
422         }
423     }
424 
425     /**
426      * @dev Returns the address that signed a hashed message (`hash`) with
427      * `signature` or error string. This address can then be used for verification purposes.
428      *
429      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
430      * this function rejects them by requiring the `s` value to be in the lower
431      * half order, and the `v` value to be either 27 or 28.
432      *
433      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
434      * verification to be secure: it is possible to craft signatures that
435      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
436      * this is by receiving a hash of the original message (which may otherwise
437      * be too long), and then calling {toEthSignedMessageHash} on it.
438      *
439      * Documentation for signature generation:
440      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
441      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
442      *
443      * _Available since v4.3._
444      */
445     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
446         // Check the signature length
447         // - case 65: r,s,v signature (standard)
448         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
449         if (signature.length == 65) {
450             bytes32 r;
451             bytes32 s;
452             uint8 v;
453             // ecrecover takes the signature parameters, and the only way to get them
454             // currently is to use assembly.
455             /// @solidity memory-safe-assembly
456             assembly {
457                 r := mload(add(signature, 0x20))
458                 s := mload(add(signature, 0x40))
459                 v := byte(0, mload(add(signature, 0x60)))
460             }
461             return tryRecover(hash, v, r, s);
462         } else if (signature.length == 64) {
463             bytes32 r;
464             bytes32 vs;
465             // ecrecover takes the signature parameters, and the only way to get them
466             // currently is to use assembly.
467             /// @solidity memory-safe-assembly
468             assembly {
469                 r := mload(add(signature, 0x20))
470                 vs := mload(add(signature, 0x40))
471             }
472             return tryRecover(hash, r, vs);
473         } else {
474             return (address(0), RecoverError.InvalidSignatureLength);
475         }
476     }
477 
478     /**
479      * @dev Returns the address that signed a hashed message (`hash`) with
480      * `signature`. This address can then be used for verification purposes.
481      *
482      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
483      * this function rejects them by requiring the `s` value to be in the lower
484      * half order, and the `v` value to be either 27 or 28.
485      *
486      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
487      * verification to be secure: it is possible to craft signatures that
488      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
489      * this is by receiving a hash of the original message (which may otherwise
490      * be too long), and then calling {toEthSignedMessageHash} on it.
491      */
492     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
493         (address recovered, RecoverError error) = tryRecover(hash, signature);
494         _throwError(error);
495         return recovered;
496     }
497 
498     /**
499      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
500      *
501      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
502      *
503      * _Available since v4.3._
504      */
505     function tryRecover(
506         bytes32 hash,
507         bytes32 r,
508         bytes32 vs
509     ) internal pure returns (address, RecoverError) {
510         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
511         uint8 v = uint8((uint256(vs) >> 255) + 27);
512         return tryRecover(hash, v, r, s);
513     }
514 
515     /**
516      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
517      *
518      * _Available since v4.2._
519      */
520     function recover(
521         bytes32 hash,
522         bytes32 r,
523         bytes32 vs
524     ) internal pure returns (address) {
525         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
526         _throwError(error);
527         return recovered;
528     }
529 
530     /**
531      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
532      * `r` and `s` signature fields separately.
533      *
534      * _Available since v4.3._
535      */
536     function tryRecover(
537         bytes32 hash,
538         uint8 v,
539         bytes32 r,
540         bytes32 s
541     ) internal pure returns (address, RecoverError) {
542         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
543         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
544         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
545         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
546         //
547         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
548         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
549         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
550         // these malleable signatures as well.
551         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
552             return (address(0), RecoverError.InvalidSignatureS);
553         }
554         if (v != 27 && v != 28) {
555             return (address(0), RecoverError.InvalidSignatureV);
556         }
557 
558         // If the signature is valid (and not malleable), return the signer address
559         address signer = ecrecover(hash, v, r, s);
560         if (signer == address(0)) {
561             return (address(0), RecoverError.InvalidSignature);
562         }
563 
564         return (signer, RecoverError.NoError);
565     }
566 
567     /**
568      * @dev Overload of {ECDSA-recover} that receives the `v`,
569      * `r` and `s` signature fields separately.
570      */
571     function recover(
572         bytes32 hash,
573         uint8 v,
574         bytes32 r,
575         bytes32 s
576     ) internal pure returns (address) {
577         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
578         _throwError(error);
579         return recovered;
580     }
581 
582     /**
583      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
584      * produces hash corresponding to the one signed with the
585      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
586      * JSON-RPC method as part of EIP-191.
587      *
588      * See {recover}.
589      */
590     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
591         // 32 is the length in bytes of hash,
592         // enforced by the type signature above
593         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
594     }
595 
596     /**
597      * @dev Returns an Ethereum Signed Message, created from `s`. This
598      * produces hash corresponding to the one signed with the
599      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
600      * JSON-RPC method as part of EIP-191.
601      *
602      * See {recover}.
603      */
604     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
605         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
606     }
607 
608     /**
609      * @dev Returns an Ethereum Signed Typed Data, created from a
610      * `domainSeparator` and a `structHash`. This produces hash corresponding
611      * to the one signed with the
612      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
613      * JSON-RPC method as part of EIP-712.
614      *
615      * See {recover}.
616      */
617     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
618         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
619     }
620 }
621 
622 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Contract module that helps prevent reentrant calls to a function.
628  *
629  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
630  * available, which can be applied to functions to make sure there are no nested
631  * (reentrant) calls to them.
632  *
633  * Note that because there is a single `nonReentrant` guard, functions marked as
634  * `nonReentrant` may not call one another. This can be worked around by making
635  * those functions `private`, and then adding `external` `nonReentrant` entry
636  * points to them.
637  *
638  * TIP: If you would like to learn more about reentrancy and alternative ways
639  * to protect against it, check out our blog post
640  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
641  */
642 abstract contract ReentrancyGuard {
643     // Booleans are more expensive than uint256 or any type that takes up a full
644     // word because each write operation emits an extra SLOAD to first read the
645     // slot's contents, replace the bits taken up by the boolean, and then write
646     // back. This is the compiler's defense against contract upgrades and
647     // pointer aliasing, and it cannot be disabled.
648 
649     // The values being non-zero value makes deployment a bit more expensive,
650     // but in exchange the refund on every call to nonReentrant will be lower in
651     // amount. Since refunds are capped to a percentage of the total
652     // transaction's gas, it is best to keep them low in cases like this one, to
653     // increase the likelihood of the full refund coming into effect.
654     uint256 private constant _NOT_ENTERED = 1;
655     uint256 private constant _ENTERED = 2;
656 
657     uint256 private _status;
658 
659     constructor() {
660         _status = _NOT_ENTERED;
661     }
662 
663     /**
664      * @dev Prevents a contract from calling itself, directly or indirectly.
665      * Calling a `nonReentrant` function from another `nonReentrant`
666      * function is not supported. It is possible to prevent this from happening
667      * by making the `nonReentrant` function external, and making it call a
668      * `private` function that does the actual work.
669      */
670     modifier nonReentrant() {
671         // On the first call to nonReentrant, _notEntered will be true
672         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
673 
674         // Any calls to nonReentrant after this point will fail
675         _status = _ENTERED;
676 
677         _;
678 
679         // By storing the original value once again, a refund is triggered (see
680         // https://eips.ethereum.org/EIPS/eip-2200)
681         _status = _NOT_ENTERED;
682     }
683 }
684 
685 // ERC721A Contracts v4.0.0
686 // Creator: Chiru Labs
687 
688 pragma solidity ^0.8.4;
689 
690 /**
691  * @dev Interface of an ERC721A compliant contract.
692  */
693 interface IERC721A {
694     /**
695      * The caller must own the token or be an approved operator.
696      */
697     error ApprovalCallerNotOwnerNorApproved();
698 
699     /**
700      * The token does not exist.
701      */
702     error ApprovalQueryForNonexistentToken();
703 
704     /**
705      * The caller cannot approve to their own address.
706      */
707     error ApproveToCaller();
708 
709     /**
710      * The caller cannot approve to the current owner.
711      */
712     error ApprovalToCurrentOwner();
713 
714     /**
715      * Cannot query the balance for the zero address.
716      */
717     error BalanceQueryForZeroAddress();
718 
719     /**
720      * Cannot mint to the zero address.
721      */
722     error MintToZeroAddress();
723 
724     /**
725      * The quantity of tokens minted must be more than zero.
726      */
727     error MintZeroQuantity();
728 
729     /**
730      * The token does not exist.
731      */
732     error OwnerQueryForNonexistentToken();
733 
734     /**
735      * The caller must own the token or be an approved operator.
736      */
737     error TransferCallerNotOwnerNorApproved();
738 
739     /**
740      * The token must be owned by `from`.
741      */
742     error TransferFromIncorrectOwner();
743 
744     /**
745      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
746      */
747     error TransferToNonERC721ReceiverImplementer();
748 
749     /**
750      * Cannot transfer to the zero address.
751      */
752     error TransferToZeroAddress();
753 
754     /**
755      * The token does not exist.
756      */
757     error URIQueryForNonexistentToken();
758 
759     struct TokenOwnership {
760         // The address of the owner.
761         address addr;
762         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
763         uint64 startTimestamp;
764         // Whether the token has been burned.
765         bool burned;
766     }
767 
768     /**
769      * @dev Returns the total amount of tokens stored by the contract.
770      *
771      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
772      */
773     function totalSupply() external view returns (uint256);
774 
775     // ==============================
776     //            IERC165
777     // ==============================
778 
779     /**
780      * @dev Returns true if this contract implements the interface defined by
781      * `interfaceId`. See the corresponding
782      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
783      * to learn more about how these ids are created.
784      *
785      * This function call must use less than 30 000 gas.
786      */
787     function supportsInterface(bytes4 interfaceId) external view returns (bool);
788 
789     // ==============================
790     //            IERC721
791     // ==============================
792 
793     /**
794      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
795      */
796     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
797 
798     /**
799      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
800      */
801     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
805      */
806     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
807 
808     /**
809      * @dev Returns the number of tokens in ``owner``'s account.
810      */
811     function balanceOf(address owner) external view returns (uint256 balance);
812 
813     /**
814      * @dev Returns the owner of the `tokenId` token.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function ownerOf(uint256 tokenId) external view returns (address owner);
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes calldata data
840     ) external;
841 
842     /**
843      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
844      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must exist and be owned by `from`.
851      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) external;
861 
862     /**
863      * @dev Transfers `tokenId` token from `from` to `to`.
864      *
865      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      *
874      * Emits a {Transfer} event.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) external;
881 
882     /**
883      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
884      * The approval is cleared when the token is transferred.
885      *
886      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
887      *
888      * Requirements:
889      *
890      * - The caller must own the token or be an approved operator.
891      * - `tokenId` must exist.
892      *
893      * Emits an {Approval} event.
894      */
895     function approve(address to, uint256 tokenId) external;
896 
897     /**
898      * @dev Approve or remove `operator` as an operator for the caller.
899      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
900      *
901      * Requirements:
902      *
903      * - The `operator` cannot be the caller.
904      *
905      * Emits an {ApprovalForAll} event.
906      */
907     function setApprovalForAll(address operator, bool _approved) external;
908 
909     /**
910      * @dev Returns the account approved for `tokenId` token.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function getApproved(uint256 tokenId) external view returns (address operator);
917 
918     /**
919      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
920      *
921      * See {setApprovalForAll}
922      */
923     function isApprovedForAll(address owner, address operator) external view returns (bool);
924 
925     // ==============================
926     //        IERC721Metadata
927     // ==============================
928 
929     /**
930      * @dev Returns the token collection name.
931      */
932     function name() external view returns (string memory);
933 
934     /**
935      * @dev Returns the token collection symbol.
936      */
937     function symbol() external view returns (string memory);
938 
939     /**
940      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
941      */
942     function tokenURI(uint256 tokenId) external view returns (string memory);
943 }
944 
945 
946 // ERC721A Contracts v4.0.0
947 // Creator: Chiru Labs
948 
949 pragma solidity ^0.8.4;
950 
951 /**
952  * @dev ERC721 token receiver interface.
953  */
954 interface ERC721A__IERC721Receiver {
955     function onERC721Received(
956         address operator,
957         address from,
958         uint256 tokenId,
959         bytes calldata data
960     ) external returns (bytes4);
961 }
962 
963 /**
964  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
965  * the Metadata extension. Built to optimize for lower gas during batch mints.
966  *
967  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
968  *
969  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
970  *
971  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
972  */
973 contract ERC721A is IERC721A {
974     // Mask of an entry in packed address data.
975     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
976 
977     // The bit position of `numberMinted` in packed address data.
978     uint256 private constant BITPOS_NUMBER_MINTED = 64;
979 
980     // The bit position of `numberBurned` in packed address data.
981     uint256 private constant BITPOS_NUMBER_BURNED = 128;
982 
983     // The bit position of `aux` in packed address data.
984     uint256 private constant BITPOS_AUX = 192;
985 
986     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
987     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
988 
989     // The bit position of `startTimestamp` in packed ownership.
990     uint256 private constant BITPOS_START_TIMESTAMP = 160;
991 
992     // The bit mask of the `burned` bit in packed ownership.
993     uint256 private constant BITMASK_BURNED = 1 << 224;
994     
995     // The bit position of the `nextInitialized` bit in packed ownership.
996     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
997 
998     // The bit mask of the `nextInitialized` bit in packed ownership.
999     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1000 
1001     // The tokenId of the next token to be minted.
1002     uint256 private _currentIndex;
1003 
1004     // The number of tokens burned.
1005     uint256 private _burnCounter;
1006 
1007     // Token name
1008     string private _name;
1009 
1010     // Token symbol
1011     string private _symbol;
1012 
1013     // Mapping from token ID to ownership details
1014     // An empty struct value does not necessarily mean the token is unowned.
1015     // See `_packedOwnershipOf` implementation for details.
1016     //
1017     // Bits Layout:
1018     // - [0..159]   `addr`
1019     // - [160..223] `startTimestamp`
1020     // - [224]      `burned`
1021     // - [225]      `nextInitialized`
1022     mapping(uint256 => uint256) private _packedOwnerships;
1023 
1024     // Mapping owner address to address data.
1025     //
1026     // Bits Layout:
1027     // - [0..63]    `balance`
1028     // - [64..127]  `numberMinted`
1029     // - [128..191] `numberBurned`
1030     // - [192..255] `aux`
1031     mapping(address => uint256) private _packedAddressData;
1032 
1033     // Mapping from token ID to approved address.
1034     mapping(uint256 => address) private _tokenApprovals;
1035 
1036     // Mapping from owner to operator approvals
1037     mapping(address => mapping(address => bool)) private _operatorApprovals;
1038 
1039     constructor(string memory name_, string memory symbol_) {
1040         _name = name_;
1041         _symbol = symbol_;
1042         _currentIndex = _startTokenId();
1043     }
1044 
1045     /**
1046      * @dev Returns the starting token ID. 
1047      * To change the starting token ID, please override this function.
1048      */
1049     function _startTokenId() internal view virtual returns (uint256) {
1050         return 0;
1051     }
1052 
1053     /**
1054      * @dev Returns the next token ID to be minted.
1055      */
1056     function _nextTokenId() internal view returns (uint256) {
1057         return _currentIndex;
1058     }
1059 
1060     /**
1061      * @dev Returns the total number of tokens in existence.
1062      * Burned tokens will reduce the count. 
1063      * To get the total number of tokens minted, please see `_totalMinted`.
1064      */
1065     function totalSupply() public view override returns (uint256) {
1066         // Counter underflow is impossible as _burnCounter cannot be incremented
1067         // more than `_currentIndex - _startTokenId()` times.
1068         unchecked {
1069             return _currentIndex - _burnCounter - _startTokenId();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns the total amount of tokens minted in the contract.
1075      */
1076     function _totalMinted() internal view returns (uint256) {
1077         // Counter underflow is impossible as _currentIndex does not decrement,
1078         // and it is initialized to `_startTokenId()`
1079         unchecked {
1080             return _currentIndex - _startTokenId();
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the total number of tokens burned.
1086      */
1087     function _totalBurned() internal view returns (uint256) {
1088         return _burnCounter;
1089     }
1090 
1091     /**
1092      * @dev See {IERC165-supportsInterface}.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1095         // The interface IDs are constants representing the first 4 bytes of the XOR of
1096         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1097         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1098         return
1099             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1100             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1101             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-balanceOf}.
1106      */
1107     function balanceOf(address owner) public view override returns (uint256) {
1108         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1109         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1110     }
1111 
1112     /**
1113      * Returns the number of tokens minted by `owner`.
1114      */
1115     function _numberMinted(address owner) internal view returns (uint256) {
1116         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1117     }
1118 
1119     /**
1120      * Returns the number of tokens burned by or on behalf of `owner`.
1121      */
1122     function _numberBurned(address owner) internal view returns (uint256) {
1123         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1124     }
1125 
1126     /**
1127      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1128      */
1129     function _getAux(address owner) internal view returns (uint64) {
1130         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1131     }
1132 
1133     /**
1134      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1135      * If there are multiple variables, please pack them into a uint64.
1136      */
1137     function _setAux(address owner, uint64 aux) internal {
1138         uint256 packed = _packedAddressData[owner];
1139         uint256 auxCasted;
1140         assembly { // Cast aux without masking.
1141             auxCasted := aux
1142         }
1143         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1144         _packedAddressData[owner] = packed;
1145     }
1146 
1147     /**
1148      * Returns the packed ownership data of `tokenId`.
1149      */
1150     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1151         uint256 curr = tokenId;
1152 
1153         unchecked {
1154             if (_startTokenId() <= curr)
1155                 if (curr < _currentIndex) {
1156                     uint256 packed = _packedOwnerships[curr];
1157                     // If not burned.
1158                     if (packed & BITMASK_BURNED == 0) {
1159                         // Invariant:
1160                         // There will always be an ownership that has an address and is not burned
1161                         // before an ownership that does not have an address and is not burned.
1162                         // Hence, curr will not underflow.
1163                         //
1164                         // We can directly compare the packed value.
1165                         // If the address is zero, packed is zero.
1166                         while (packed == 0) {
1167                             packed = _packedOwnerships[--curr];
1168                         }
1169                         return packed;
1170                     }
1171                 }
1172         }
1173         revert OwnerQueryForNonexistentToken();
1174     }
1175 
1176     /**
1177      * Returns the unpacked `TokenOwnership` struct from `packed`.
1178      */
1179     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1180         ownership.addr = address(uint160(packed));
1181         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1182         ownership.burned = packed & BITMASK_BURNED != 0;
1183     }
1184 
1185     /**
1186      * Returns the unpacked `TokenOwnership` struct at `index`.
1187      */
1188     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1189         return _unpackedOwnership(_packedOwnerships[index]);
1190     }
1191 
1192     /**
1193      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1194      */
1195     function _initializeOwnershipAt(uint256 index) internal {
1196         if (_packedOwnerships[index] == 0) {
1197             _packedOwnerships[index] = _packedOwnershipOf(index);
1198         }
1199     }
1200 
1201     /**
1202      * Gas spent here starts off proportional to the maximum mint batch size.
1203      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1204      */
1205     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1206         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-ownerOf}.
1211      */
1212     function ownerOf(uint256 tokenId) public view override returns (address) {
1213         return address(uint160(_packedOwnershipOf(tokenId)));
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Metadata-name}.
1218      */
1219     function name() public view virtual override returns (string memory) {
1220         return _name;
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Metadata-symbol}.
1225      */
1226     function symbol() public view virtual override returns (string memory) {
1227         return _symbol;
1228     }
1229 
1230     /**
1231      * @dev See {IERC721Metadata-tokenURI}.
1232      */
1233     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1234         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1235 
1236         string memory baseURI = _baseURI();
1237         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1238     }
1239 
1240     /**
1241      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1242      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1243      * by default, can be overriden in child contracts.
1244      */
1245     function _baseURI() internal view virtual returns (string memory) {
1246         return '';
1247     }
1248 
1249     /**
1250      * @dev Casts the address to uint256 without masking.
1251      */
1252     function _addressToUint256(address value) private pure returns (uint256 result) {
1253         assembly {
1254             result := value
1255         }
1256     }
1257 
1258     /**
1259      * @dev Casts the boolean to uint256 without branching.
1260      */
1261     function _boolToUint256(bool value) private pure returns (uint256 result) {
1262         assembly {
1263             result := value
1264         }
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-approve}.
1269      */
1270     function approve(address to, uint256 tokenId) public virtual override {
1271         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1272         if (to == owner) revert ApprovalToCurrentOwner();
1273 
1274         if (_msgSenderERC721A() != owner)
1275             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1276                 revert ApprovalCallerNotOwnerNorApproved();
1277             }
1278 
1279         _tokenApprovals[tokenId] = to;
1280         emit Approval(owner, to, tokenId);
1281     }
1282 
1283     /**
1284      * @dev See {IERC721-getApproved}.
1285      */
1286     function getApproved(uint256 tokenId) public view override returns (address) {
1287         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1288 
1289         return _tokenApprovals[tokenId];
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-setApprovalForAll}.
1294      */
1295     function setApprovalForAll(address operator, bool approved) public virtual override {
1296         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1297 
1298         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1299         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-isApprovedForAll}.
1304      */
1305     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1306         return _operatorApprovals[owner][operator];
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-transferFrom}.
1311      */
1312     function transferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         _transfer(from, to, tokenId);
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-safeTransferFrom}.
1322      */
1323     function safeTransferFrom(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) public virtual override {
1328         safeTransferFrom(from, to, tokenId, '');
1329     }
1330 
1331     /**
1332      * @dev See {IERC721-safeTransferFrom}.
1333      */
1334     function safeTransferFrom(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes memory _data
1339     ) public virtual override {
1340         _transfer(from, to, tokenId);
1341         if (to.code.length != 0)
1342             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1343                 revert TransferToNonERC721ReceiverImplementer();
1344             }
1345     }
1346 
1347     /**
1348      * @dev Returns whether `tokenId` exists.
1349      *
1350      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1351      *
1352      * Tokens start existing when they are minted (`_mint`),
1353      */
1354     function _exists(uint256 tokenId) internal view returns (bool) {
1355         return
1356             _startTokenId() <= tokenId &&
1357             tokenId < _currentIndex && // If within bounds,
1358             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1359     }
1360 
1361     /**
1362      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1363      */
1364     function _safeMint(address to, uint256 quantity) internal {
1365         _safeMint(to, quantity, '');
1366     }
1367 
1368     /**
1369      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1370      *
1371      * Requirements:
1372      *
1373      * - If `to` refers to a smart contract, it must implement
1374      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1375      * - `quantity` must be greater than 0.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function _safeMint(
1380         address to,
1381         uint256 quantity,
1382         bytes memory _data
1383     ) internal {
1384         uint256 startTokenId = _currentIndex;
1385         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1386         if (quantity == 0) revert MintZeroQuantity();
1387 
1388         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1389 
1390         // Overflows are incredibly unrealistic.
1391         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1392         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1393         unchecked {
1394             // Updates:
1395             // - `balance += quantity`.
1396             // - `numberMinted += quantity`.
1397             //
1398             // We can directly add to the balance and number minted.
1399             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1400 
1401             // Updates:
1402             // - `address` to the owner.
1403             // - `startTimestamp` to the timestamp of minting.
1404             // - `burned` to `false`.
1405             // - `nextInitialized` to `quantity == 1`.
1406             _packedOwnerships[startTokenId] =
1407                 _addressToUint256(to) |
1408                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1409                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1410 
1411             uint256 updatedIndex = startTokenId;
1412             uint256 end = updatedIndex + quantity;
1413 
1414             if (to.code.length != 0) {
1415                 do {
1416                     emit Transfer(address(0), to, updatedIndex);
1417                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1418                         revert TransferToNonERC721ReceiverImplementer();
1419                     }
1420                 } while (updatedIndex < end);
1421                 // Reentrancy protection
1422                 if (_currentIndex != startTokenId) revert();
1423             } else {
1424                 do {
1425                     emit Transfer(address(0), to, updatedIndex++);
1426                 } while (updatedIndex < end);
1427             }
1428             _currentIndex = updatedIndex;
1429         }
1430         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1431     }
1432 
1433     /**
1434      * @dev Mints `quantity` tokens and transfers them to `to`.
1435      *
1436      * Requirements:
1437      *
1438      * - `to` cannot be the zero address.
1439      * - `quantity` must be greater than 0.
1440      *
1441      * Emits a {Transfer} event.
1442      */
1443     function _mint(address to, uint256 quantity) internal {
1444         uint256 startTokenId = _currentIndex;
1445         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1446         if (quantity == 0) revert MintZeroQuantity();
1447 
1448         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1449 
1450         // Overflows are incredibly unrealistic.
1451         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1452         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1453         unchecked {
1454             // Updates:
1455             // - `balance += quantity`.
1456             // - `numberMinted += quantity`.
1457             //
1458             // We can directly add to the balance and number minted.
1459             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1460 
1461             // Updates:
1462             // - `address` to the owner.
1463             // - `startTimestamp` to the timestamp of minting.
1464             // - `burned` to `false`.
1465             // - `nextInitialized` to `quantity == 1`.
1466             _packedOwnerships[startTokenId] =
1467                 _addressToUint256(to) |
1468                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1469                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1470 
1471             uint256 updatedIndex = startTokenId;
1472             uint256 end = updatedIndex + quantity;
1473 
1474             do {
1475                 emit Transfer(address(0), to, updatedIndex++);
1476             } while (updatedIndex < end);
1477 
1478             _currentIndex = updatedIndex;
1479         }
1480         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1481     }
1482 
1483     /**
1484      * @dev Transfers `tokenId` from `from` to `to`.
1485      *
1486      * Requirements:
1487      *
1488      * - `to` cannot be the zero address.
1489      * - `tokenId` token must be owned by `from`.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _transfer(
1494         address from,
1495         address to,
1496         uint256 tokenId
1497     ) private {
1498         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1499 
1500         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1501 
1502         address approvedAddress = _tokenApprovals[tokenId];
1503 
1504         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1505             isApprovedForAll(from, _msgSenderERC721A()) ||
1506             approvedAddress == _msgSenderERC721A());
1507 
1508         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1509         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1510 
1511         _beforeTokenTransfers(from, to, tokenId, 1);
1512 
1513         // Clear approvals from the previous owner.
1514         if (_addressToUint256(approvedAddress) != 0) {
1515             delete _tokenApprovals[tokenId];
1516         }
1517 
1518         // Underflow of the sender's balance is impossible because we check for
1519         // ownership above and the recipient's balance can't realistically overflow.
1520         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1521         unchecked {
1522             // We can directly increment and decrement the balances.
1523             --_packedAddressData[from]; // Updates: `balance -= 1`.
1524             ++_packedAddressData[to]; // Updates: `balance += 1`.
1525 
1526             // Updates:
1527             // - `address` to the next owner.
1528             // - `startTimestamp` to the timestamp of transfering.
1529             // - `burned` to `false`.
1530             // - `nextInitialized` to `true`.
1531             _packedOwnerships[tokenId] =
1532                 _addressToUint256(to) |
1533                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1534                 BITMASK_NEXT_INITIALIZED;
1535 
1536             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1537             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1538                 uint256 nextTokenId = tokenId + 1;
1539                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1540                 if (_packedOwnerships[nextTokenId] == 0) {
1541                     // If the next slot is within bounds.
1542                     if (nextTokenId != _currentIndex) {
1543                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1544                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1545                     }
1546                 }
1547             }
1548         }
1549 
1550         emit Transfer(from, to, tokenId);
1551         _afterTokenTransfers(from, to, tokenId, 1);
1552     }
1553 
1554     /**
1555      * @dev Equivalent to `_burn(tokenId, false)`.
1556      */
1557     function _burn(uint256 tokenId) internal virtual {
1558         _burn(tokenId, false);
1559     }
1560 
1561     /**
1562      * @dev Destroys `tokenId`.
1563      * The approval is cleared when the token is burned.
1564      *
1565      * Requirements:
1566      *
1567      * - `tokenId` must exist.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1572         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1573 
1574         address from = address(uint160(prevOwnershipPacked));
1575         address approvedAddress = _tokenApprovals[tokenId];
1576 
1577         if (approvalCheck) {
1578             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1579                 isApprovedForAll(from, _msgSenderERC721A()) ||
1580                 approvedAddress == _msgSenderERC721A());
1581 
1582             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1583         }
1584 
1585         _beforeTokenTransfers(from, address(0), tokenId, 1);
1586 
1587         // Clear approvals from the previous owner.
1588         if (_addressToUint256(approvedAddress) != 0) {
1589             delete _tokenApprovals[tokenId];
1590         }
1591 
1592         // Underflow of the sender's balance is impossible because we check for
1593         // ownership above and the recipient's balance can't realistically overflow.
1594         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1595         unchecked {
1596             // Updates:
1597             // - `balance -= 1`.
1598             // - `numberBurned += 1`.
1599             //
1600             // We can directly decrement the balance, and increment the number burned.
1601             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1602             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1603 
1604             // Updates:
1605             // - `address` to the last owner.
1606             // - `startTimestamp` to the timestamp of burning.
1607             // - `burned` to `true`.
1608             // - `nextInitialized` to `true`.
1609             _packedOwnerships[tokenId] =
1610                 _addressToUint256(from) |
1611                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1612                 BITMASK_BURNED | 
1613                 BITMASK_NEXT_INITIALIZED;
1614 
1615             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1616             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1617                 uint256 nextTokenId = tokenId + 1;
1618                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1619                 if (_packedOwnerships[nextTokenId] == 0) {
1620                     // If the next slot is within bounds.
1621                     if (nextTokenId != _currentIndex) {
1622                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1623                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1624                     }
1625                 }
1626             }
1627         }
1628 
1629         emit Transfer(from, address(0), tokenId);
1630         _afterTokenTransfers(from, address(0), tokenId, 1);
1631 
1632         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1633         unchecked {
1634             _burnCounter++;
1635         }
1636     }
1637 
1638     /**
1639      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1640      *
1641      * @param from address representing the previous owner of the given token ID
1642      * @param to target address that will receive the tokens
1643      * @param tokenId uint256 ID of the token to be transferred
1644      * @param _data bytes optional data to send along with the call
1645      * @return bool whether the call correctly returned the expected magic value
1646      */
1647     function _checkContractOnERC721Received(
1648         address from,
1649         address to,
1650         uint256 tokenId,
1651         bytes memory _data
1652     ) private returns (bool) {
1653         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1654             bytes4 retval
1655         ) {
1656             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1657         } catch (bytes memory reason) {
1658             if (reason.length == 0) {
1659                 revert TransferToNonERC721ReceiverImplementer();
1660             } else {
1661                 assembly {
1662                     revert(add(32, reason), mload(reason))
1663                 }
1664             }
1665         }
1666     }
1667 
1668     /**
1669      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1670      * And also called before burning one token.
1671      *
1672      * startTokenId - the first token id to be transferred
1673      * quantity - the amount to be transferred
1674      *
1675      * Calling conditions:
1676      *
1677      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1678      * transferred to `to`.
1679      * - When `from` is zero, `tokenId` will be minted for `to`.
1680      * - When `to` is zero, `tokenId` will be burned by `from`.
1681      * - `from` and `to` are never both zero.
1682      */
1683     function _beforeTokenTransfers(
1684         address from,
1685         address to,
1686         uint256 startTokenId,
1687         uint256 quantity
1688     ) internal virtual {}
1689 
1690     /**
1691      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1692      * minting.
1693      * And also called after one token has been burned.
1694      *
1695      * startTokenId - the first token id to be transferred
1696      * quantity - the amount to be transferred
1697      *
1698      * Calling conditions:
1699      *
1700      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1701      * transferred to `to`.
1702      * - When `from` is zero, `tokenId` has been minted for `to`.
1703      * - When `to` is zero, `tokenId` has been burned by `from`.
1704      * - `from` and `to` are never both zero.
1705      */
1706     function _afterTokenTransfers(
1707         address from,
1708         address to,
1709         uint256 startTokenId,
1710         uint256 quantity
1711     ) internal virtual {}
1712 
1713     /**
1714      * @dev Returns the message sender (defaults to `msg.sender`).
1715      *
1716      * If you are writing GSN compatible contracts, you need to override this function.
1717      */
1718     function _msgSenderERC721A() internal view virtual returns (address) {
1719         return msg.sender;
1720     }
1721 
1722     /**
1723      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1724      */
1725     function _toString(uint256 value) internal pure returns (string memory ptr) {
1726         assembly {
1727             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1728             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1729             // We will need 1 32-byte word to store the length, 
1730             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1731             ptr := add(mload(0x40), 128)
1732             // Update the free memory pointer to allocate.
1733             mstore(0x40, ptr)
1734 
1735             // Cache the end of the memory to calculate the length later.
1736             let end := ptr
1737 
1738             // We write the string from the rightmost digit to the leftmost digit.
1739             // The following is essentially a do-while loop that also handles the zero case.
1740             // Costs a bit more than early returning for the zero case,
1741             // but cheaper in terms of deployment and overall runtime costs.
1742             for { 
1743                 // Initialize and perform the first pass without check.
1744                 let temp := value
1745                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1746                 ptr := sub(ptr, 1)
1747                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1748                 mstore8(ptr, add(48, mod(temp, 10)))
1749                 temp := div(temp, 10)
1750             } temp { 
1751                 // Keep dividing `temp` until zero.
1752                 temp := div(temp, 10)
1753             } { // Body of the for loop.
1754                 ptr := sub(ptr, 1)
1755                 mstore8(ptr, add(48, mod(temp, 10)))
1756             }
1757             
1758             let length := sub(end, ptr)
1759             // Move the pointer 32 bytes leftwards to make room for the length.
1760             ptr := sub(ptr, 32)
1761             // Store the length.
1762             mstore(ptr, length)
1763         }
1764     }
1765 }
1766 
1767 pragma solidity ^0.8.13;
1768 
1769 interface IOperatorFilterRegistry {
1770     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1771     function register(address registrant) external;
1772     function registerAndSubscribe(address registrant, address subscription) external;
1773     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1774     function unregister(address addr) external;
1775     function updateOperator(address registrant, address operator, bool filtered) external;
1776     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1777     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1778     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1779     function subscribe(address registrant, address registrantToSubscribe) external;
1780     function unsubscribe(address registrant, bool copyExistingEntries) external;
1781     function subscriptionOf(address addr) external returns (address registrant);
1782     function subscribers(address registrant) external returns (address[] memory);
1783     function subscriberAt(address registrant, uint256 index) external returns (address);
1784     function copyEntriesOf(address registrant, address registrantToCopy) external;
1785     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1786     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1787     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1788     function filteredOperators(address addr) external returns (address[] memory);
1789     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1790     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1791     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1792     function isRegistered(address addr) external returns (bool);
1793     function codeHashOf(address addr) external returns (bytes32);
1794 }
1795 
1796 pragma solidity ^0.8.13;
1797 
1798 
1799 /**
1800  * @title  OperatorFilterer
1801  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1802  *         registrant's entries in the OperatorFilterRegistry.
1803  */
1804 abstract contract OperatorFilterer {
1805     error OperatorNotAllowed(address operator);
1806 
1807     IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
1808         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1809 
1810     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1811         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1812         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1813         // order for the modifier to filter addresses.
1814         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1815             if (subscribe) {
1816                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1817             } else {
1818                 if (subscriptionOrRegistrantToCopy != address(0)) {
1819                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1820                 } else {
1821                     OPERATOR_FILTER_REGISTRY.register(address(this));
1822                 }
1823             }
1824         }
1825     }
1826 
1827     modifier onlyAllowedOperator(address from) virtual {
1828         // Check registry code length to facilitate testing in environments without a deployed registry.
1829         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1830             // Allow spending tokens from addresses with balance
1831             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1832             // from an EOA.
1833             if (from == msg.sender) {
1834                 _;
1835                 return;
1836             }
1837             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1838                 revert OperatorNotAllowed(msg.sender);
1839             }
1840         }
1841         _;
1842     }
1843 
1844     modifier onlyAllowedOperatorApproval(address operator) virtual {
1845         // Check registry code length to facilitate testing in environments without a deployed registry.
1846         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1847             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1848                 revert OperatorNotAllowed(operator);
1849             }
1850         }
1851         _;
1852     }
1853 }
1854 
1855 pragma solidity ^0.8.13;
1856 
1857 /**
1858  * @title  DefaultOperatorFilterer
1859  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1860  */
1861 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1862     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1863 
1864     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1865 }
1866 
1867 contract DrunkenVikingsTribe is ERC721A, DefaultOperatorFilterer, Ownable, ReentrancyGuard {
1868     uint256 public MAX_SUPPLY = 3636;
1869 
1870     
1871     uint256 public FREE_SUPPLY = 333;
1872     uint256 public WHITELIST_SUPPLY = 3636;
1873     uint256 public PUBLIC_SUPPLY = 3636;
1874     
1875     bool public IS_FREE_ACTIVE = false;
1876     bool public IS_WHITELIST_ACTIVE = false;
1877     bool public IS_PUBLIC_ACTIVE = false;
1878 
1879     
1880     uint256 public FREE_TX_LIMIT = 1;
1881     uint256 public WHITELIST_TX_LIMIT = 2;
1882     uint256 public PUBLIC_TX_LIMIT = 2;
1883 
1884     
1885     uint256 public FREE_WALLET_LIMIT = 1;
1886     uint256 public WHITELIST_WALLET_LIMIT = 2;
1887     uint256 public PUBLIC_WALLET_LIMIT = 2;
1888 
1889     
1890     uint256 public FREE_PRICE = 0 ether;
1891     uint256 public WHITELIST_PRICE = 0.009 ether;
1892     uint256 public PUBLIC_PRICE = 0.012 ether;
1893 
1894     
1895     uint256 public FREE_COUNT = 0;
1896     uint256 public WHITELIST_COUNT = 0;
1897     uint256 public PUBLIC_COUNT = 0;
1898 
1899     
1900     bytes32 public FREE_ROOT;
1901     bytes32 public WHITELIST_ROOT;
1902 
1903     
1904     mapping(address => uint) public FREE_Minted;
1905     mapping(address => uint) public WHITELIST_Minted;
1906     mapping(address => uint) public PUBLIC_Minted;
1907 
1908     bool public _revealed = false;
1909 
1910     string private baseURI = "";
1911     string private preRevealURI = "https://ipfs.w3bmint.xyz/ipfs/QmXdPbaX5j78XnjUqaSEDgw5Enzr6PWhbCi8ePZuSwivQP";
1912 
1913     mapping(address => uint256) addressBlockBought;
1914 
1915     address public constant RL_ADDRESS = 0xc9b5553910bA47719e0202fF9F617B8BE06b3A09; 
1916 
1917     constructor(
1918         bytes32 _Free,
1919         bytes32 _Whitelist) ERC721A("DrunkenVikingsTribe", "DVT") {
1920         
1921         FREE_ROOT = _Free;
1922         WHITELIST_ROOT = _Whitelist;
1923         
1924         _safeMint(0x9C63aF2ed991F9ddEB63eEECAf79c95E9F3368B5, 1);
1925     }
1926 
1927     modifier isSecured(uint256 currentValue) {
1928         require(addressBlockBought[msg.sender] < block.timestamp, "CANNOT_MINT_ON_THE_SAME_BLOCK");
1929         require(tx.origin == msg.sender,"CONTRACTS_NOT_ALLOWED_TO_MINT");
1930         require(msg.value == currentValue, "WRONG_ETH_VALUE");
1931         _;
1932     }
1933 
1934     function validateMint(bool isActive, uint256 count, uint256 supply, uint256 mintedOfUser, uint256 walletLimit, uint256 txLimit, uint256 numberOfTokens, bool isProofValid) private view {
1935         require(isActive, "MINT_IS_NOT_YET_ACTIVE");
1936         require(isProofValid, "PROOF_INVALID");
1937         require(numberOfTokens + totalSupply() <= MAX_SUPPLY, "NOT_ENOUGH_SUPPLY");
1938         require(numberOfTokens + count <= supply, "NOT_ENOUGH_SUPPLY");
1939         require(mintedOfUser + numberOfTokens <= walletLimit || walletLimit == 0, "EXCEED__MINT_LIMIT");
1940         require(numberOfTokens <= txLimit || txLimit == 0, "EXCEED_MINT_LIMIT");
1941     }
1942 
1943     
1944     function FREEMint(uint256 numberOfTokens, bytes32[] memory proof) external isSecured(FREE_PRICE * numberOfTokens) payable {
1945         validateMint(IS_FREE_ACTIVE, FREE_COUNT, FREE_SUPPLY, FREE_Minted[msg.sender], FREE_WALLET_LIMIT, FREE_TX_LIMIT, numberOfTokens, MerkleProof.verify(proof, FREE_ROOT, keccak256(abi.encodePacked(msg.sender))));
1946         addressBlockBought[msg.sender] = block.timestamp;
1947         FREE_Minted[msg.sender] += numberOfTokens;
1948         FREE_COUNT += numberOfTokens;
1949         _safeMint(msg.sender, numberOfTokens);
1950     }
1951 
1952     function WHITELISTMint(uint256 numberOfTokens, bytes32[] memory proof) external isSecured(WHITELIST_PRICE * numberOfTokens) payable {
1953         validateMint(IS_WHITELIST_ACTIVE, WHITELIST_COUNT, WHITELIST_SUPPLY, WHITELIST_Minted[msg.sender], WHITELIST_WALLET_LIMIT, WHITELIST_TX_LIMIT, numberOfTokens, MerkleProof.verify(proof, WHITELIST_ROOT, keccak256(abi.encodePacked(msg.sender))));
1954         addressBlockBought[msg.sender] = block.timestamp;
1955         WHITELIST_Minted[msg.sender] += numberOfTokens;
1956         WHITELIST_COUNT += numberOfTokens;
1957         _safeMint(msg.sender, numberOfTokens);
1958     }
1959 
1960     function PUBLICMint(uint256 numberOfTokens) external isSecured(PUBLIC_PRICE * numberOfTokens) payable {
1961         validateMint(IS_PUBLIC_ACTIVE, PUBLIC_COUNT, PUBLIC_SUPPLY, PUBLIC_Minted[msg.sender], PUBLIC_WALLET_LIMIT, PUBLIC_TX_LIMIT, numberOfTokens, true);
1962         addressBlockBought[msg.sender] = block.timestamp;
1963         PUBLIC_Minted[msg.sender] += numberOfTokens;
1964         PUBLIC_COUNT += numberOfTokens;
1965         _safeMint(msg.sender, numberOfTokens);
1966     }
1967 
1968 
1969     // URI
1970     function setBaseURI(string calldata URI) external onlyOwner {
1971         baseURI = URI;
1972     }
1973 
1974     function reveal(bool revealed, string calldata _baseURI) external onlyOwner {
1975         _revealed = revealed;
1976         baseURI = _baseURI;
1977     }
1978 
1979     // LIVE TOGGLES
1980 
1981     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1982         if (_revealed) {
1983             return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
1984         } else {
1985             return string(abi.encodePacked(preRevealURI));
1986         }
1987     }
1988 
1989     function numberMinted(address owner) public view returns (uint256) {
1990         return _numberMinted(owner);
1991     }
1992 
1993     // ROOT SETTERS
1994     
1995     function setFREERoot(bytes32 _root) external onlyOwner {
1996         FREE_ROOT = _root;
1997     }
1998 
1999     function setWHITELISTRoot(bytes32 _root) external onlyOwner {
2000         WHITELIST_ROOT = _root;
2001     }
2002 
2003 
2004     // TOGGLES
2005     
2006     function toggleFREEMintStatus() external onlyOwner {
2007         IS_FREE_ACTIVE = !IS_FREE_ACTIVE;
2008     }
2009     function toggleWHITELISTMintStatus() external onlyOwner {
2010         IS_WHITELIST_ACTIVE = !IS_WHITELIST_ACTIVE;
2011     }
2012     function togglePUBLICMintStatus() external onlyOwner {
2013         IS_PUBLIC_ACTIVE = !IS_PUBLIC_ACTIVE;
2014     }
2015 
2016     // SUPPLY CHANGERS
2017     
2018     function setFREESupply(uint256 _supply) external onlyOwner {
2019         FREE_SUPPLY = _supply;
2020     }
2021 
2022     function setWHITELISTSupply(uint256 _supply) external onlyOwner {
2023         WHITELIST_SUPPLY = _supply;
2024     }
2025 
2026     function setPUBLICSupply(uint256 _supply) external onlyOwner {
2027         PUBLIC_SUPPLY = _supply;
2028     }
2029 
2030 
2031     // PRICE CHANGERS
2032     
2033     function setFREEPrice(uint256 _price) external onlyOwner {
2034         FREE_PRICE = _price;
2035     }
2036 
2037     function setWHITELISTPrice(uint256 _price) external onlyOwner {
2038         WHITELIST_PRICE = _price;
2039     }
2040 
2041     function setPUBLICPrice(uint256 _price) external onlyOwner {
2042         PUBLIC_PRICE = _price;
2043     }
2044 
2045 
2046     // MAX SUPPLY
2047     function updateMaxSupply(uint256 _maxSupply) external onlyOwner {
2048         MAX_SUPPLY = _maxSupply;
2049     }
2050 
2051     // withdraw
2052     function withdraw() external onlyOwner {
2053         uint256 RLFee = (address(this).balance * 600) / 10000;
2054         (bool successRLTransfer, ) = payable(RL_ADDRESS).call{ value: RLFee }("");
2055         require(successRLTransfer, "Transfer Failed!");
2056 
2057         
2058         (bool successFinal, ) = payable(0x20A1468F3C9527ebd33F324bDE4c7Ea45faF1d7a).call{ value: address(this).balance }("");
2059         require(successFinal, "Transfer Failed!");
2060 
2061     }
2062 
2063     // OPENSEA's royalties functions
2064     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2065         super.setApprovalForAll(operator, approved);
2066     }
2067 
2068     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2069         super.approve(operator, tokenId);
2070     }
2071 
2072     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2073         super.transferFrom(from, to, tokenId);
2074     }
2075 
2076     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2077         super.safeTransferFrom(from, to, tokenId);
2078     }
2079 
2080     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
2081         super.safeTransferFrom(from, to, tokenId, data);
2082     }
2083 }
