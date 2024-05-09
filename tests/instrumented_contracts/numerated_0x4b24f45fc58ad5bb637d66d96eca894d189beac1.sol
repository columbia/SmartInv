1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
97      *
98      * _Available since v4.7._
99      */
100     function multiProofVerifyCalldata(
101         bytes32[] calldata proof,
102         bool[] calldata proofFlags,
103         bytes32 root,
104         bytes32[] memory leaves
105     ) internal pure returns (bool) {
106         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
107     }
108 
109     /**
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Contract module that helps prevent reentrant calls to a function.
226  *
227  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
228  * available, which can be applied to functions to make sure there are no nested
229  * (reentrant) calls to them.
230  *
231  * Note that because there is a single `nonReentrant` guard, functions marked as
232  * `nonReentrant` may not call one another. This can be worked around by making
233  * those functions `private`, and then adding `external` `nonReentrant` entry
234  * points to them.
235  *
236  * TIP: If you would like to learn more about reentrancy and alternative ways
237  * to protect against it, check out our blog post
238  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
239  */
240 abstract contract ReentrancyGuard {
241     // Booleans are more expensive than uint256 or any type that takes up a full
242     // word because each write operation emits an extra SLOAD to first read the
243     // slot's contents, replace the bits taken up by the boolean, and then write
244     // back. This is the compiler's defense against contract upgrades and
245     // pointer aliasing, and it cannot be disabled.
246 
247     // The values being non-zero value makes deployment a bit more expensive,
248     // but in exchange the refund on every call to nonReentrant will be lower in
249     // amount. Since refunds are capped to a percentage of the total
250     // transaction's gas, it is best to keep them low in cases like this one, to
251     // increase the likelihood of the full refund coming into effect.
252     uint256 private constant _NOT_ENTERED = 1;
253     uint256 private constant _ENTERED = 2;
254 
255     uint256 private _status;
256 
257     constructor() {
258         _status = _NOT_ENTERED;
259     }
260 
261     /**
262      * @dev Prevents a contract from calling itself, directly or indirectly.
263      * Calling a `nonReentrant` function from another `nonReentrant`
264      * function is not supported. It is possible to prevent this from happening
265      * by making the `nonReentrant` function external, and making it call a
266      * `private` function that does the actual work.
267      */
268     modifier nonReentrant() {
269         // On the first call to nonReentrant, _notEntered will be true
270         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
271 
272         // Any calls to nonReentrant after this point will fail
273         _status = _ENTERED;
274 
275         _;
276 
277         // By storing the original value once again, a refund is triggered (see
278         // https://eips.ethereum.org/EIPS/eip-2200)
279         _status = _NOT_ENTERED;
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Strings.sol
284 
285 
286 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev String operations.
292  */
293 library Strings {
294     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
295     uint8 private constant _ADDRESS_LENGTH = 20;
296 
297     /**
298      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
299      */
300     function toString(uint256 value) internal pure returns (string memory) {
301         // Inspired by OraclizeAPI's implementation - MIT licence
302         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
303 
304         if (value == 0) {
305             return "0";
306         }
307         uint256 temp = value;
308         uint256 digits;
309         while (temp != 0) {
310             digits++;
311             temp /= 10;
312         }
313         bytes memory buffer = new bytes(digits);
314         while (value != 0) {
315             digits -= 1;
316             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
317             value /= 10;
318         }
319         return string(buffer);
320     }
321 
322     /**
323      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
324      */
325     function toHexString(uint256 value) internal pure returns (string memory) {
326         if (value == 0) {
327             return "0x00";
328         }
329         uint256 temp = value;
330         uint256 length = 0;
331         while (temp != 0) {
332             length++;
333             temp >>= 8;
334         }
335         return toHexString(value, length);
336     }
337 
338     /**
339      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
340      */
341     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
342         bytes memory buffer = new bytes(2 * length + 2);
343         buffer[0] = "0";
344         buffer[1] = "x";
345         for (uint256 i = 2 * length + 1; i > 1; --i) {
346             buffer[i] = _HEX_SYMBOLS[value & 0xf];
347             value >>= 4;
348         }
349         require(value == 0, "Strings: hex length insufficient");
350         return string(buffer);
351     }
352 
353     /**
354      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
355      */
356     function toHexString(address addr) internal pure returns (string memory) {
357         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
358     }
359 }
360 
361 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
362 
363 
364 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
371  *
372  * These functions can be used to verify that a message was signed by the holder
373  * of the private keys of a given address.
374  */
375 library ECDSA {
376     enum RecoverError {
377         NoError,
378         InvalidSignature,
379         InvalidSignatureLength,
380         InvalidSignatureS,
381         InvalidSignatureV
382     }
383 
384     function _throwError(RecoverError error) private pure {
385         if (error == RecoverError.NoError) {
386             return; // no error: do nothing
387         } else if (error == RecoverError.InvalidSignature) {
388             revert("ECDSA: invalid signature");
389         } else if (error == RecoverError.InvalidSignatureLength) {
390             revert("ECDSA: invalid signature length");
391         } else if (error == RecoverError.InvalidSignatureS) {
392             revert("ECDSA: invalid signature 's' value");
393         } else if (error == RecoverError.InvalidSignatureV) {
394             revert("ECDSA: invalid signature 'v' value");
395         }
396     }
397 
398     /**
399      * @dev Returns the address that signed a hashed message (`hash`) with
400      * `signature` or error string. This address can then be used for verification purposes.
401      *
402      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
403      * this function rejects them by requiring the `s` value to be in the lower
404      * half order, and the `v` value to be either 27 or 28.
405      *
406      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
407      * verification to be secure: it is possible to craft signatures that
408      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
409      * this is by receiving a hash of the original message (which may otherwise
410      * be too long), and then calling {toEthSignedMessageHash} on it.
411      *
412      * Documentation for signature generation:
413      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
414      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
415      *
416      * _Available since v4.3._
417      */
418     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
419         if (signature.length == 65) {
420             bytes32 r;
421             bytes32 s;
422             uint8 v;
423             // ecrecover takes the signature parameters, and the only way to get them
424             // currently is to use assembly.
425             /// @solidity memory-safe-assembly
426             assembly {
427                 r := mload(add(signature, 0x20))
428                 s := mload(add(signature, 0x40))
429                 v := byte(0, mload(add(signature, 0x60)))
430             }
431             return tryRecover(hash, v, r, s);
432         } else {
433             return (address(0), RecoverError.InvalidSignatureLength);
434         }
435     }
436 
437     /**
438      * @dev Returns the address that signed a hashed message (`hash`) with
439      * `signature`. This address can then be used for verification purposes.
440      *
441      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
442      * this function rejects them by requiring the `s` value to be in the lower
443      * half order, and the `v` value to be either 27 or 28.
444      *
445      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
446      * verification to be secure: it is possible to craft signatures that
447      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
448      * this is by receiving a hash of the original message (which may otherwise
449      * be too long), and then calling {toEthSignedMessageHash} on it.
450      */
451     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
452         (address recovered, RecoverError error) = tryRecover(hash, signature);
453         _throwError(error);
454         return recovered;
455     }
456 
457     /**
458      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
459      *
460      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
461      *
462      * _Available since v4.3._
463      */
464     function tryRecover(
465         bytes32 hash,
466         bytes32 r,
467         bytes32 vs
468     ) internal pure returns (address, RecoverError) {
469         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
470         uint8 v = uint8((uint256(vs) >> 255) + 27);
471         return tryRecover(hash, v, r, s);
472     }
473 
474     /**
475      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
476      *
477      * _Available since v4.2._
478      */
479     function recover(
480         bytes32 hash,
481         bytes32 r,
482         bytes32 vs
483     ) internal pure returns (address) {
484         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
485         _throwError(error);
486         return recovered;
487     }
488 
489     /**
490      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
491      * `r` and `s` signature fields separately.
492      *
493      * _Available since v4.3._
494      */
495     function tryRecover(
496         bytes32 hash,
497         uint8 v,
498         bytes32 r,
499         bytes32 s
500     ) internal pure returns (address, RecoverError) {
501         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
502         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
503         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
504         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
505         //
506         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
507         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
508         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
509         // these malleable signatures as well.
510         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
511             return (address(0), RecoverError.InvalidSignatureS);
512         }
513         if (v != 27 && v != 28) {
514             return (address(0), RecoverError.InvalidSignatureV);
515         }
516 
517         // If the signature is valid (and not malleable), return the signer address
518         address signer = ecrecover(hash, v, r, s);
519         if (signer == address(0)) {
520             return (address(0), RecoverError.InvalidSignature);
521         }
522 
523         return (signer, RecoverError.NoError);
524     }
525 
526     /**
527      * @dev Overload of {ECDSA-recover} that receives the `v`,
528      * `r` and `s` signature fields separately.
529      */
530     function recover(
531         bytes32 hash,
532         uint8 v,
533         bytes32 r,
534         bytes32 s
535     ) internal pure returns (address) {
536         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
537         _throwError(error);
538         return recovered;
539     }
540 
541     /**
542      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
543      * produces hash corresponding to the one signed with the
544      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
545      * JSON-RPC method as part of EIP-191.
546      *
547      * See {recover}.
548      */
549     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
550         // 32 is the length in bytes of hash,
551         // enforced by the type signature above
552         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
553     }
554 
555     /**
556      * @dev Returns an Ethereum Signed Message, created from `s`. This
557      * produces hash corresponding to the one signed with the
558      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
559      * JSON-RPC method as part of EIP-191.
560      *
561      * See {recover}.
562      */
563     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
564         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
565     }
566 
567     /**
568      * @dev Returns an Ethereum Signed Typed Data, created from a
569      * `domainSeparator` and a `structHash`. This produces hash corresponding
570      * to the one signed with the
571      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
572      * JSON-RPC method as part of EIP-712.
573      *
574      * See {recover}.
575      */
576     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
577         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
578     }
579 }
580 
581 // File: @openzeppelin/contracts/utils/Context.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @dev Provides information about the current execution context, including the
590  * sender of the transaction and its data. While these are generally available
591  * via msg.sender and msg.data, they should not be accessed in such a direct
592  * manner, since when dealing with meta-transactions the account sending and
593  * paying for execution may not be the actual sender (as far as an application
594  * is concerned).
595  *
596  * This contract is only required for intermediate, library-like contracts.
597  */
598 abstract contract Context {
599     function _msgSender() internal view virtual returns (address) {
600         return msg.sender;
601     }
602 
603     function _msgData() internal view virtual returns (bytes calldata) {
604         return msg.data;
605     }
606 }
607 
608 // File: @openzeppelin/contracts/access/Ownable.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 
616 /**
617  * @dev Contract module which provides a basic access control mechanism, where
618  * there is an account (an owner) that can be granted exclusive access to
619  * specific functions.
620  *
621  * By default, the owner account will be the one that deploys the contract. This
622  * can later be changed with {transferOwnership}.
623  *
624  * This module is used through inheritance. It will make available the modifier
625  * `onlyOwner`, which can be applied to your functions to restrict their use to
626  * the owner.
627  */
628 abstract contract Ownable is Context {
629     address private _owner;
630 
631     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
632 
633     /**
634      * @dev Initializes the contract setting the deployer as the initial owner.
635      */
636     constructor() {
637         _transferOwnership(_msgSender());
638     }
639 
640     /**
641      * @dev Throws if called by any account other than the owner.
642      */
643     modifier onlyOwner() {
644         _checkOwner();
645         _;
646     }
647 
648     /**
649      * @dev Returns the address of the current owner.
650      */
651     function owner() public view virtual returns (address) {
652         return _owner;
653     }
654 
655     /**
656      * @dev Throws if the sender is not the owner.
657      */
658     function _checkOwner() internal view virtual {
659         require(owner() == _msgSender(), "Ownable: caller is not the owner");
660     }
661 
662     /**
663      * @dev Leaves the contract without owner. It will not be possible to call
664      * `onlyOwner` functions anymore. Can only be called by the current owner.
665      *
666      * NOTE: Renouncing ownership will leave the contract without an owner,
667      * thereby removing any functionality that is only available to the owner.
668      */
669     function renounceOwnership() public virtual onlyOwner {
670         _transferOwnership(address(0));
671     }
672 
673     /**
674      * @dev Transfers ownership of the contract to a new account (`newOwner`).
675      * Can only be called by the current owner.
676      */
677     function transferOwnership(address newOwner) public virtual onlyOwner {
678         require(newOwner != address(0), "Ownable: new owner is the zero address");
679         _transferOwnership(newOwner);
680     }
681 
682     /**
683      * @dev Transfers ownership of the contract to a new account (`newOwner`).
684      * Internal function without access restriction.
685      */
686     function _transferOwnership(address newOwner) internal virtual {
687         address oldOwner = _owner;
688         _owner = newOwner;
689         emit OwnershipTransferred(oldOwner, newOwner);
690     }
691 }
692 
693 // File: @openzeppelin/contracts/utils/Address.sol
694 
695 
696 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
697 
698 pragma solidity ^0.8.1;
699 
700 /**
701  * @dev Collection of functions related to the address type
702  */
703 library Address {
704     /**
705      * @dev Returns true if `account` is a contract.
706      *
707      * [IMPORTANT]
708      * ====
709      * It is unsafe to assume that an address for which this function returns
710      * false is an externally-owned account (EOA) and not a contract.
711      *
712      * Among others, `isContract` will return false for the following
713      * types of addresses:
714      *
715      *  - an externally-owned account
716      *  - a contract in construction
717      *  - an address where a contract will be created
718      *  - an address where a contract lived, but was destroyed
719      * ====
720      *
721      * [IMPORTANT]
722      * ====
723      * You shouldn't rely on `isContract` to protect against flash loan attacks!
724      *
725      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
726      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
727      * constructor.
728      * ====
729      */
730     function isContract(address account) internal view returns (bool) {
731         // This method relies on extcodesize/address.code.length, which returns 0
732         // for contracts in construction, since the code is only stored at the end
733         // of the constructor execution.
734 
735         return account.code.length > 0;
736     }
737 
738     /**
739      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
740      * `recipient`, forwarding all available gas and reverting on errors.
741      *
742      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
743      * of certain opcodes, possibly making contracts go over the 2300 gas limit
744      * imposed by `transfer`, making them unable to receive funds via
745      * `transfer`. {sendValue} removes this limitation.
746      *
747      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
748      *
749      * IMPORTANT: because control is transferred to `recipient`, care must be
750      * taken to not create reentrancy vulnerabilities. Consider using
751      * {ReentrancyGuard} or the
752      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
753      */
754     function sendValue(address payable recipient, uint256 amount) internal {
755         require(address(this).balance >= amount, "Address: insufficient balance");
756 
757         (bool success, ) = recipient.call{value: amount}("");
758         require(success, "Address: unable to send value, recipient may have reverted");
759     }
760 
761     /**
762      * @dev Performs a Solidity function call using a low level `call`. A
763      * plain `call` is an unsafe replacement for a function call: use this
764      * function instead.
765      *
766      * If `target` reverts with a revert reason, it is bubbled up by this
767      * function (like regular Solidity function calls).
768      *
769      * Returns the raw returned data. To convert to the expected return value,
770      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
771      *
772      * Requirements:
773      *
774      * - `target` must be a contract.
775      * - calling `target` with `data` must not revert.
776      *
777      * _Available since v3.1._
778      */
779     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
780         return functionCall(target, data, "Address: low-level call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
785      * `errorMessage` as a fallback revert reason when `target` reverts.
786      *
787      * _Available since v3.1._
788      */
789     function functionCall(
790         address target,
791         bytes memory data,
792         string memory errorMessage
793     ) internal returns (bytes memory) {
794         return functionCallWithValue(target, data, 0, errorMessage);
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
799      * but also transferring `value` wei to `target`.
800      *
801      * Requirements:
802      *
803      * - the calling contract must have an ETH balance of at least `value`.
804      * - the called Solidity function must be `payable`.
805      *
806      * _Available since v3.1._
807      */
808     function functionCallWithValue(
809         address target,
810         bytes memory data,
811         uint256 value
812     ) internal returns (bytes memory) {
813         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
818      * with `errorMessage` as a fallback revert reason when `target` reverts.
819      *
820      * _Available since v3.1._
821      */
822     function functionCallWithValue(
823         address target,
824         bytes memory data,
825         uint256 value,
826         string memory errorMessage
827     ) internal returns (bytes memory) {
828         require(address(this).balance >= value, "Address: insufficient balance for call");
829         require(isContract(target), "Address: call to non-contract");
830 
831         (bool success, bytes memory returndata) = target.call{value: value}(data);
832         return verifyCallResult(success, returndata, errorMessage);
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
837      * but performing a static call.
838      *
839      * _Available since v3.3._
840      */
841     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
842         return functionStaticCall(target, data, "Address: low-level static call failed");
843     }
844 
845     /**
846      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
847      * but performing a static call.
848      *
849      * _Available since v3.3._
850      */
851     function functionStaticCall(
852         address target,
853         bytes memory data,
854         string memory errorMessage
855     ) internal view returns (bytes memory) {
856         require(isContract(target), "Address: static call to non-contract");
857 
858         (bool success, bytes memory returndata) = target.staticcall(data);
859         return verifyCallResult(success, returndata, errorMessage);
860     }
861 
862     /**
863      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
864      * but performing a delegate call.
865      *
866      * _Available since v3.4._
867      */
868     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
869         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
870     }
871 
872     /**
873      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
874      * but performing a delegate call.
875      *
876      * _Available since v3.4._
877      */
878     function functionDelegateCall(
879         address target,
880         bytes memory data,
881         string memory errorMessage
882     ) internal returns (bytes memory) {
883         require(isContract(target), "Address: delegate call to non-contract");
884 
885         (bool success, bytes memory returndata) = target.delegatecall(data);
886         return verifyCallResult(success, returndata, errorMessage);
887     }
888 
889     /**
890      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
891      * revert reason using the provided one.
892      *
893      * _Available since v4.3._
894      */
895     function verifyCallResult(
896         bool success,
897         bytes memory returndata,
898         string memory errorMessage
899     ) internal pure returns (bytes memory) {
900         if (success) {
901             return returndata;
902         } else {
903             // Look for revert reason and bubble it up if present
904             if (returndata.length > 0) {
905                 // The easiest way to bubble the revert reason is using memory via assembly
906                 /// @solidity memory-safe-assembly
907                 assembly {
908                     let returndata_size := mload(returndata)
909                     revert(add(32, returndata), returndata_size)
910                 }
911             } else {
912                 revert(errorMessage);
913             }
914         }
915     }
916 }
917 
918 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
919 
920 
921 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 /**
926  * @title ERC721 token receiver interface
927  * @dev Interface for any contract that wants to support safeTransfers
928  * from ERC721 asset contracts.
929  */
930 interface IERC721Receiver {
931     /**
932      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
933      * by `operator` from `from`, this function is called.
934      *
935      * It must return its Solidity selector to confirm the token transfer.
936      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
937      *
938      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
939      */
940     function onERC721Received(
941         address operator,
942         address from,
943         uint256 tokenId,
944         bytes calldata data
945     ) external returns (bytes4);
946 }
947 
948 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
949 
950 
951 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 /**
956  * @dev Interface of the ERC165 standard, as defined in the
957  * https://eips.ethereum.org/EIPS/eip-165[EIP].
958  *
959  * Implementers can declare support of contract interfaces, which can then be
960  * queried by others ({ERC165Checker}).
961  *
962  * For an implementation, see {ERC165}.
963  */
964 interface IERC165 {
965     /**
966      * @dev Returns true if this contract implements the interface defined by
967      * `interfaceId`. See the corresponding
968      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
969      * to learn more about how these ids are created.
970      *
971      * This function call must use less than 30 000 gas.
972      */
973     function supportsInterface(bytes4 interfaceId) external view returns (bool);
974 }
975 
976 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
977 
978 
979 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 
984 /**
985  * @dev Interface for the NFT Royalty Standard.
986  *
987  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
988  * support for royalty payments across all NFT marketplaces and ecosystem participants.
989  *
990  * _Available since v4.5._
991  */
992 interface IERC2981 is IERC165 {
993     /**
994      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
995      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
996      */
997     function royaltyInfo(uint256 tokenId, uint256 salePrice)
998         external
999         view
1000         returns (address receiver, uint256 royaltyAmount);
1001 }
1002 
1003 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1004 
1005 
1006 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 
1011 /**
1012  * @dev Implementation of the {IERC165} interface.
1013  *
1014  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1015  * for the additional interface id that will be supported. For example:
1016  *
1017  * ```solidity
1018  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1019  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1020  * }
1021  * ```
1022  *
1023  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1024  */
1025 abstract contract ERC165 is IERC165 {
1026     /**
1027      * @dev See {IERC165-supportsInterface}.
1028      */
1029     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1030         return interfaceId == type(IERC165).interfaceId;
1031     }
1032 }
1033 
1034 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1035 
1036 
1037 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1038 
1039 pragma solidity ^0.8.0;
1040 
1041 
1042 /**
1043  * @dev Required interface of an ERC721 compliant contract.
1044  */
1045 interface IERC721 is IERC165 {
1046     /**
1047      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1048      */
1049     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1050 
1051     /**
1052      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1053      */
1054     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1055 
1056     /**
1057      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1058      */
1059     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1060 
1061     /**
1062      * @dev Returns the number of tokens in ``owner``'s account.
1063      */
1064     function balanceOf(address owner) external view returns (uint256 balance);
1065 
1066     /**
1067      * @dev Returns the owner of the `tokenId` token.
1068      *
1069      * Requirements:
1070      *
1071      * - `tokenId` must exist.
1072      */
1073     function ownerOf(uint256 tokenId) external view returns (address owner);
1074 
1075     /**
1076      * @dev Safely transfers `tokenId` token from `from` to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must exist and be owned by `from`.
1083      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function safeTransferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes calldata data
1093     ) external;
1094 
1095     /**
1096      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1097      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must exist and be owned by `from`.
1104      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function safeTransferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) external;
1114 
1115     /**
1116      * @dev Transfers `tokenId` token from `from` to `to`.
1117      *
1118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1119      *
1120      * Requirements:
1121      *
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must be owned by `from`.
1125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function transferFrom(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) external;
1134 
1135     /**
1136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1137      * The approval is cleared when the token is transferred.
1138      *
1139      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1140      *
1141      * Requirements:
1142      *
1143      * - The caller must own the token or be an approved operator.
1144      * - `tokenId` must exist.
1145      *
1146      * Emits an {Approval} event.
1147      */
1148     function approve(address to, uint256 tokenId) external;
1149 
1150     /**
1151      * @dev Approve or remove `operator` as an operator for the caller.
1152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1153      *
1154      * Requirements:
1155      *
1156      * - The `operator` cannot be the caller.
1157      *
1158      * Emits an {ApprovalForAll} event.
1159      */
1160     function setApprovalForAll(address operator, bool _approved) external;
1161 
1162     /**
1163      * @dev Returns the account approved for `tokenId` token.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must exist.
1168      */
1169     function getApproved(uint256 tokenId) external view returns (address operator);
1170 
1171     /**
1172      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1173      *
1174      * See {setApprovalForAll}
1175      */
1176     function isApprovedForAll(address owner, address operator) external view returns (bool);
1177 }
1178 
1179 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1180 
1181 
1182 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 /**
1188  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1189  * @dev See https://eips.ethereum.org/EIPS/eip-721
1190  */
1191 interface IERC721Enumerable is IERC721 {
1192     /**
1193      * @dev Returns the total amount of tokens stored by the contract.
1194      */
1195     function totalSupply() external view returns (uint256);
1196 
1197     /**
1198      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1199      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1200      */
1201     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1202 
1203     /**
1204      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1205      * Use along with {totalSupply} to enumerate all tokens.
1206      */
1207     function tokenByIndex(uint256 index) external view returns (uint256);
1208 }
1209 
1210 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1211 
1212 
1213 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 
1218 /**
1219  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1220  * @dev See https://eips.ethereum.org/EIPS/eip-721
1221  */
1222 interface IERC721Metadata is IERC721 {
1223     /**
1224      * @dev Returns the token collection name.
1225      */
1226     function name() external view returns (string memory);
1227 
1228     /**
1229      * @dev Returns the token collection symbol.
1230      */
1231     function symbol() external view returns (string memory);
1232 
1233     /**
1234      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1235      */
1236     function tokenURI(uint256 tokenId) external view returns (string memory);
1237 }
1238 
1239 // File: contracts/ERC721A.sol
1240 
1241 
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 
1253 /**
1254  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1255  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1256  *
1257  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1258  *
1259  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1260  *
1261  * Does not support burning tokens to address(0).
1262  */
1263 contract ERC721A is
1264   Context,
1265   ERC165,
1266   IERC721,
1267   IERC721Metadata,
1268   IERC721Enumerable
1269 {
1270   using Address for address;
1271   using Strings for uint256;
1272 
1273   struct TokenOwnership {
1274     address addr;
1275     uint64 startTimestamp;
1276   }
1277 
1278   struct AddressData {
1279     uint128 balance;
1280     uint128 numberMinted;
1281   }
1282 
1283   uint256 private currentIndex = 0;
1284 
1285   uint256 internal immutable collectionSize;
1286   uint256 internal immutable maxBatchSize;
1287 
1288   // Token name
1289   string private _name;
1290 
1291   // Token symbol
1292   string private _symbol;
1293 
1294   // Mapping from token ID to ownership details
1295   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1296   mapping(uint256 => TokenOwnership) private _ownerships;
1297 
1298   // Mapping owner address to address data
1299   mapping(address => AddressData) private _addressData;
1300 
1301   // Mapping from token ID to approved address
1302   mapping(uint256 => address) private _tokenApprovals;
1303 
1304   // Mapping from owner to operator approvals
1305   mapping(address => mapping(address => bool)) private _operatorApprovals;
1306 
1307   /**
1308    * @dev
1309    * `maxBatchSize` refers to how much a minter can mint at a time.
1310    * `collectionSize_` refers to how many tokens are in the collection.
1311    */
1312   constructor(
1313     string memory name_,
1314     string memory symbol_,
1315     uint256 maxBatchSize_,
1316     uint256 collectionSize_
1317   ) {
1318     require(
1319       collectionSize_ > 0,
1320       "ERC721A: collection must have a nonzero supply"
1321     );
1322     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1323     _name = name_;
1324     _symbol = symbol_;
1325     maxBatchSize = maxBatchSize_;
1326     collectionSize = collectionSize_;
1327   }
1328 
1329   /**
1330    * @dev See {IERC721Enumerable-totalSupply}.
1331    */
1332   function totalSupply() public view override returns (uint256) {
1333     return currentIndex;
1334   }
1335 
1336   /**
1337    * @dev See {IERC721Enumerable-tokenByIndex}.
1338    */
1339   function tokenByIndex(uint256 index) public view override returns (uint256) {
1340     require(index < totalSupply(), "ERC721A: global index out of bounds");
1341     return index;
1342   }
1343 
1344   /**
1345    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1346    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1347    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1348    */
1349   function tokenOfOwnerByIndex(address owner, uint256 index)
1350     public
1351     view
1352     override
1353     returns (uint256)
1354   {
1355     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1356     uint256 numMintedSoFar = totalSupply();
1357     uint256 tokenIdsIdx = 0;
1358     address currOwnershipAddr = address(0);
1359     for (uint256 i = 0; i < numMintedSoFar; i++) {
1360       TokenOwnership memory ownership = _ownerships[i];
1361       if (ownership.addr != address(0)) {
1362         currOwnershipAddr = ownership.addr;
1363       }
1364       if (currOwnershipAddr == owner) {
1365         if (tokenIdsIdx == index) {
1366           return i;
1367         }
1368         tokenIdsIdx++;
1369       }
1370     }
1371     revert("ERC721A: unable to get token of owner by index");
1372   }
1373 
1374   /**
1375    * @dev See {IERC165-supportsInterface}.
1376    */
1377   function supportsInterface(bytes4 interfaceId)
1378     public
1379     view
1380     virtual
1381     override(ERC165, IERC165)
1382     returns (bool)
1383   {
1384     return
1385       interfaceId == type(IERC721).interfaceId ||
1386       interfaceId == type(IERC721Metadata).interfaceId ||
1387       interfaceId == type(IERC721Enumerable).interfaceId ||
1388       super.supportsInterface(interfaceId);
1389   }
1390 
1391   /**
1392    * @dev See {IERC721-balanceOf}.
1393    */
1394   function balanceOf(address owner) public view override returns (uint256) {
1395     require(owner != address(0), "ERC721A: balance query for the zero address");
1396     return uint256(_addressData[owner].balance);
1397   }
1398 
1399   function _numberMinted(address owner) internal view returns (uint256) {
1400     require(
1401       owner != address(0),
1402       "ERC721A: number minted query for the zero address"
1403     );
1404     return uint256(_addressData[owner].numberMinted);
1405   }
1406 
1407   function ownershipOf(uint256 tokenId)
1408     internal
1409     view
1410     returns (TokenOwnership memory)
1411   {
1412     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1413 
1414     uint256 lowestTokenToCheck;
1415     if (tokenId >= maxBatchSize) {
1416       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1417     }
1418 
1419     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1420       TokenOwnership memory ownership = _ownerships[curr];
1421       if (ownership.addr != address(0)) {
1422         return ownership;
1423       }
1424     }
1425 
1426     revert("ERC721A: unable to determine the owner of token");
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-ownerOf}.
1431    */
1432   function ownerOf(uint256 tokenId) public view override returns (address) {
1433     return ownershipOf(tokenId).addr;
1434   }
1435 
1436   /**
1437    * @dev See {IERC721Metadata-name}.
1438    */
1439   function name() public view virtual override returns (string memory) {
1440     return _name;
1441   }
1442 
1443   /**
1444    * @dev See {IERC721Metadata-symbol}.
1445    */
1446   function symbol() public view virtual override returns (string memory) {
1447     return _symbol;
1448   }
1449 
1450   /**
1451    * @dev See {IERC721Metadata-tokenURI}.
1452    */
1453   function tokenURI(uint256 tokenId)
1454     public
1455     view
1456     virtual
1457     override
1458     returns (string memory)
1459   {
1460     require(
1461       _exists(tokenId),
1462       "ERC721Metadata: URI query for nonexistent token"
1463     );
1464 
1465     string memory baseURI = _baseURI();
1466     return
1467       bytes(baseURI).length > 0
1468         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1469         : "";
1470   }
1471 
1472   /**
1473    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1474    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1475    * by default, can be overriden in child contracts.
1476    */
1477   function _baseURI() internal view virtual returns (string memory) {
1478     return "";
1479   }
1480 
1481   /**
1482    * @dev See {IERC721-approve}.
1483    */
1484   function approve(address to, uint256 tokenId) public override {
1485     address owner = ERC721A.ownerOf(tokenId);
1486     require(to != owner, "ERC721A: approval to current owner");
1487 
1488     require(
1489       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1490       "ERC721A: approve caller is not owner nor approved for all"
1491     );
1492 
1493     _approve(to, tokenId, owner);
1494   }
1495 
1496   /**
1497    * @dev See {IERC721-getApproved}.
1498    */
1499   function getApproved(uint256 tokenId) public view override returns (address) {
1500     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1501 
1502     return _tokenApprovals[tokenId];
1503   }
1504 
1505   /**
1506    * @dev See {IERC721-setApprovalForAll}.
1507    */
1508   function setApprovalForAll(address operator, bool approved) public override {
1509     require(operator != _msgSender(), "ERC721A: approve to caller");
1510 
1511     _operatorApprovals[_msgSender()][operator] = approved;
1512     emit ApprovalForAll(_msgSender(), operator, approved);
1513   }
1514 
1515   /**
1516    * @dev See {IERC721-isApprovedForAll}.
1517    */
1518   function isApprovedForAll(address owner, address operator)
1519     public
1520     view
1521     virtual
1522     override
1523     returns (bool)
1524   {
1525     return _operatorApprovals[owner][operator];
1526   }
1527 
1528   /**
1529    * @dev See {IERC721-transferFrom}.
1530    */
1531   function transferFrom(
1532     address from,
1533     address to,
1534     uint256 tokenId
1535   ) public override {
1536     _transfer(from, to, tokenId);
1537   }
1538 
1539   /**
1540    * @dev See {IERC721-safeTransferFrom}.
1541    */
1542   function safeTransferFrom(
1543     address from,
1544     address to,
1545     uint256 tokenId
1546   ) public override {
1547     safeTransferFrom(from, to, tokenId, "");
1548   }
1549 
1550   /**
1551    * @dev See {IERC721-safeTransferFrom}.
1552    */
1553   function safeTransferFrom(
1554     address from,
1555     address to,
1556     uint256 tokenId,
1557     bytes memory _data
1558   ) public override {
1559     _transfer(from, to, tokenId);
1560     require(
1561       _checkOnERC721Received(from, to, tokenId, _data),
1562       "ERC721A: transfer to non ERC721Receiver implementer"
1563     );
1564   }
1565 
1566   /**
1567    * @dev Returns whether `tokenId` exists.
1568    *
1569    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1570    *
1571    * Tokens start existing when they are minted (`_mint`),
1572    */
1573   function _exists(uint256 tokenId) internal view returns (bool) {
1574     return tokenId < currentIndex;
1575   }
1576 
1577   function _safeMint(address to, uint256 quantity) internal {
1578     _safeMint(to, quantity, "");
1579   }
1580 
1581   /**
1582    * @dev Mints `quantity` tokens and transfers them to `to`.
1583    *
1584    * Requirements:
1585    *
1586    * - there must be `quantity` tokens remaining unminted in the total collection.
1587    * - `to` cannot be the zero address.
1588    * - `quantity` cannot be larger than the max batch size.
1589    *
1590    * Emits a {Transfer} event.
1591    */
1592   function _safeMint(
1593     address to,
1594     uint256 quantity,
1595     bytes memory _data
1596   ) internal {
1597     uint256 startTokenId = currentIndex;
1598     require(to != address(0), "ERC721A: mint to the zero address");
1599     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1600     require(!_exists(startTokenId), "ERC721A: token already minted");
1601     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1602 
1603     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1604 
1605     AddressData memory addressData = _addressData[to];
1606     _addressData[to] = AddressData(
1607       addressData.balance + uint128(quantity),
1608       addressData.numberMinted + uint128(quantity)
1609     );
1610     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1611 
1612     uint256 updatedIndex = startTokenId;
1613 
1614     for (uint256 i = 0; i < quantity; i++) {
1615       emit Transfer(address(0), to, updatedIndex);
1616       require(
1617         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1618         "ERC721A: transfer to non ERC721Receiver implementer"
1619       );
1620       updatedIndex++;
1621     }
1622 
1623     currentIndex = updatedIndex;
1624     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1625   }
1626 
1627   /**
1628    * @dev Transfers `tokenId` from `from` to `to`.
1629    *
1630    * Requirements:
1631    *
1632    * - `to` cannot be the zero address.
1633    * - `tokenId` token must be owned by `from`.
1634    *
1635    * Emits a {Transfer} event.
1636    */
1637   function _transfer(
1638     address from,
1639     address to,
1640     uint256 tokenId
1641   ) private {
1642     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1643 
1644     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1645       getApproved(tokenId) == _msgSender() ||
1646       isApprovedForAll(prevOwnership.addr, _msgSender()));
1647 
1648     require(
1649       isApprovedOrOwner,
1650       "ERC721A: transfer caller is not owner nor approved"
1651     );
1652 
1653     require(
1654       prevOwnership.addr == from,
1655       "ERC721A: transfer from incorrect owner"
1656     );
1657     require(to != address(0), "ERC721A: transfer to the zero address");
1658 
1659     _beforeTokenTransfers(from, to, tokenId, 1);
1660 
1661     // Clear approvals from the previous owner
1662     _approve(address(0), tokenId, prevOwnership.addr);
1663 
1664     _addressData[from].balance -= 1;
1665     _addressData[to].balance += 1;
1666     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1667 
1668     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1669     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1670     uint256 nextTokenId = tokenId + 1;
1671     if (_ownerships[nextTokenId].addr == address(0)) {
1672       if (_exists(nextTokenId)) {
1673         _ownerships[nextTokenId] = TokenOwnership(
1674           prevOwnership.addr,
1675           prevOwnership.startTimestamp
1676         );
1677       }
1678     }
1679 
1680     emit Transfer(from, to, tokenId);
1681     _afterTokenTransfers(from, to, tokenId, 1);
1682   }
1683 
1684   /**
1685    * @dev Approve `to` to operate on `tokenId`
1686    *
1687    * Emits a {Approval} event.
1688    */
1689   function _approve(
1690     address to,
1691     uint256 tokenId,
1692     address owner
1693   ) private {
1694     _tokenApprovals[tokenId] = to;
1695     emit Approval(owner, to, tokenId);
1696   }
1697 
1698   uint256 public nextOwnerToExplicitlySet = 0;
1699 
1700   /**
1701    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1702    */
1703   function _setOwnersExplicit(uint256 quantity) internal {
1704     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1705     require(quantity > 0, "quantity must be nonzero");
1706     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1707     if (endIndex > collectionSize - 1) {
1708       endIndex = collectionSize - 1;
1709     }
1710     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1711     require(_exists(endIndex), "not enough minted yet for this cleanup");
1712     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1713       if (_ownerships[i].addr == address(0)) {
1714         TokenOwnership memory ownership = ownershipOf(i);
1715         _ownerships[i] = TokenOwnership(
1716           ownership.addr,
1717           ownership.startTimestamp
1718         );
1719       }
1720     }
1721     nextOwnerToExplicitlySet = endIndex + 1;
1722   }
1723 
1724   /**
1725    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1726    * The call is not executed if the target address is not a contract.
1727    *
1728    * @param from address representing the previous owner of the given token ID
1729    * @param to target address that will receive the tokens
1730    * @param tokenId uint256 ID of the token to be transferred
1731    * @param _data bytes optional data to send along with the call
1732    * @return bool whether the call correctly returned the expected magic value
1733    */
1734   function _checkOnERC721Received(
1735     address from,
1736     address to,
1737     uint256 tokenId,
1738     bytes memory _data
1739   ) private returns (bool) {
1740     if (to.isContract()) {
1741       try
1742         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1743       returns (bytes4 retval) {
1744         return retval == IERC721Receiver(to).onERC721Received.selector;
1745       } catch (bytes memory reason) {
1746         if (reason.length == 0) {
1747           revert("ERC721A: transfer to non ERC721Receiver implementer");
1748         } else {
1749           assembly {
1750             revert(add(32, reason), mload(reason))
1751           }
1752         }
1753       }
1754     } else {
1755       return true;
1756     }
1757   }
1758 
1759   /**
1760    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1761    *
1762    * startTokenId - the first token id to be transferred
1763    * quantity - the amount to be transferred
1764    *
1765    * Calling conditions:
1766    *
1767    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1768    * transferred to `to`.
1769    * - When `from` is zero, `tokenId` will be minted for `to`.
1770    */
1771   function _beforeTokenTransfers(
1772     address from,
1773     address to,
1774     uint256 startTokenId,
1775     uint256 quantity
1776   ) internal virtual {}
1777 
1778   /**
1779    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1780    * minting.
1781    *
1782    * startTokenId - the first token id to be transferred
1783    * quantity - the amount to be transferred
1784    *
1785    * Calling conditions:
1786    *
1787    * - when `from` and `to` are both non-zero.
1788    * - `from` and `to` are never both zero.
1789    */
1790   function _afterTokenTransfers(
1791     address from,
1792     address to,
1793     uint256 startTokenId,
1794     uint256 quantity
1795   ) internal virtual {}
1796 }
1797 // File: contracts/SmartContract.sol
1798 
1799 
1800 
1801 // Created by HashLips
1802 // The Nerdy Coder Clones
1803 
1804 pragma solidity ^0.8.0;
1805 
1806 
1807 
1808 
1809 
1810 
1811 
1812 contract CavemanNFT is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1813     using Strings for uint256;
1814     using ECDSA for bytes32;
1815 
1816     string public baseURI;
1817     string public notRevealedUri;
1818     string public baseExtension = ".json";
1819     uint256 public wlCost = 0.0099 ether;
1820     uint256 public cost = 0.0099 ether;
1821 
1822     uint256 public maxSupply = 5555;
1823     uint256 public maxMint = 3;
1824     uint256 public maxWLMint = 2;
1825     uint256 public freeMint = 1;
1826     uint256 public revealTokenId = 0;
1827     uint256 public maxWLTxn = 3555;
1828     uint256 public curWLTxn = 0;
1829     bool public paused = false;
1830 
1831     uint256 public wlStartTime = 1664978400;
1832     uint256 public publicStartTime = 1664985600;
1833 
1834     address public royaltyAddress;
1835     uint256 public royaltyPercent;
1836 
1837     bytes32 public wlMerkleRoot =
1838         0x0b0bb9fe82a11cfc656681511ef2ed3048f5201f87208bf1d8919ac7cb42dc6a;
1839 
1840     mapping(address => bool) public wlMintInit;
1841     mapping(uint256 => bool) public cavemanStaked;
1842     mapping(address => bool) public cavemanSacrificed;
1843 
1844     constructor() ERC721A("Caveman NFT", "CAVEMAN", 200, maxSupply) {
1845         royaltyAddress = 0x29aF568493D19eCD9443826425bEbc10A746a28b;
1846         royaltyPercent = 10;
1847         setBaseURI("");
1848         setNotRevealedURI(
1849             "ipfs://QmbM3pzF1HDabhLiYcHoGpJRszzix8eq3bDXmNi6hVMXGv/hidden.json"
1850         );
1851     }
1852 
1853     modifier eoaOnly() {
1854         require(tx.origin == msg.sender, "EOA Only");
1855         _;
1856     }
1857 
1858     // internal
1859     function _baseURI() internal view virtual override returns (string memory) {
1860         return baseURI;
1861     }
1862 
1863     // public
1864     function mint(uint256 _mintAmt) public payable nonReentrant eoaOnly {
1865         uint256 supply = totalSupply();
1866         require(!paused, "Mint Paused");
1867         require(block.timestamp >= publicStartTime, "Mint Not Open Yet");
1868         require(_mintAmt > 0, "Invalid Mint Amount");
1869         require(_mintAmt <= maxMint, "Mint Amount Too High");
1870         require(supply + _mintAmt <= maxSupply, "Not Enough NFT Left");
1871 
1872         if (msg.sender != owner()) {
1873             require(msg.value >= cost * _mintAmt, "Value Not Match");
1874         }
1875 
1876         _safeMint(msg.sender, _mintAmt);
1877     }
1878 
1879     function whitelistMint(uint256 _mintAmt, bytes32[] calldata _merkleProof)
1880         public
1881         payable
1882         nonReentrant
1883         eoaOnly
1884     {
1885         require(
1886             _whitelistVerify(_merkleProof, wlMerkleRoot),
1887             "Invalid merkle proof"
1888         );
1889         require(!paused, "Mint Paused");
1890         require(block.timestamp >= wlStartTime, "Mint Not Open Yet");
1891         require(_mintAmt > 0, "Invalid Mint Amount");
1892         require(_mintAmt <= maxWLMint, "Mint Amount Too High");
1893         require(curWLTxn <= maxWLTxn, "Max Whitelist Transaction Reached");
1894         require(totalSupply() + _mintAmt <= maxSupply, "Not Enough NFT Left");
1895         require(!wlMintInit[msg.sender], "Wallet Already Minted");
1896 
1897         if (msg.sender != owner()) {
1898             require(
1899                 msg.value >= wlCost * (_mintAmt - freeMint),
1900                 "Value Not Match"
1901             );
1902         }
1903 
1904         if (!wlMintInit[msg.sender]) {
1905             wlMintInit[msg.sender] = true;
1906         }
1907 
1908         _safeMint(msg.sender, _mintAmt);
1909         curWLTxn = curWLTxn++;
1910     }
1911 
1912     function giveAwayMint(uint256 _mintAmt) public onlyOwner {
1913         require(_mintAmt > 0, "Invalid Mint Amount");
1914         require(totalSupply() + _mintAmt <= maxSupply, "Not Enough NFT Left");
1915         _safeMint(msg.sender, _mintAmt);
1916     }
1917 
1918     function gift(address[] calldata receivers) public onlyOwner {
1919         require(
1920             totalSupply() + receivers.length <= maxSupply,
1921             "Not Enough NFT Left"
1922         );
1923         for (uint256 i = 0; i < receivers.length; i++) {
1924             _safeMint(receivers[i], 1);
1925         }
1926     }
1927 
1928     function tokenURI(uint256 tokenId)
1929         public
1930         view
1931         virtual
1932         override
1933         returns (string memory)
1934     {
1935         require(
1936             _exists(tokenId),
1937             "ERC721Metadata: URI query for nonexistent token"
1938         );
1939 
1940         if (tokenId >= revealTokenId) {
1941             return notRevealedUri;
1942         }
1943 
1944         string memory currentBaseURI = _baseURI();
1945         return
1946             bytes(currentBaseURI).length > 0
1947                 ? string(
1948                     abi.encodePacked(
1949                         currentBaseURI,
1950                         tokenId.toString(),
1951                         baseExtension
1952                     )
1953                 )
1954                 : "";
1955     }
1956 
1957     function checkWhitelist(bytes32[] calldata _merkleProof)
1958         public
1959         view
1960         returns (bool)
1961     {
1962         return _whitelistVerify(_merkleProof, wlMerkleRoot);
1963     }
1964 
1965     function _whitelistVerify(bytes32[] memory _proof, bytes32 _root)
1966         internal
1967         view
1968         returns (bool)
1969     {
1970         return
1971             MerkleProof.verify(
1972                 _proof,
1973                 _root,
1974                 keccak256(abi.encodePacked(msg.sender))
1975             );
1976     }
1977 
1978     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1979         external
1980         view
1981         override
1982         returns (address receiver, uint256 royaltyAmount)
1983     {
1984         require(_exists(tokenId), "Non-existent token");
1985         return (royaltyAddress, (salePrice * royaltyPercent) / 100);
1986     }
1987 
1988     function walletOfOwner(address _owner)
1989         public
1990         view
1991         returns (uint256[] memory)
1992     {
1993         uint256 ownerTokenCount = balanceOf(_owner);
1994         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1995         for (uint256 i; i < ownerTokenCount; i++) {
1996             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1997         }
1998         return tokenIds;
1999     }
2000 
2001     function SacrificeRitual(uint256 tokenId) public virtual {
2002         require(ownerOf(tokenId) == msg.sender, "You do not own the NFT");
2003         cavemanSacrificed[msg.sender] = true;
2004         safeTransferFrom(
2005             msg.sender,
2006             0x000000000000000000000000000000000000dEaD,
2007             tokenId
2008         );
2009     }
2010 
2011     function stakeCaveman(uint256 tokenId) public virtual {
2012         require(ownerOf(tokenId) == msg.sender, "You do not own the NFT");
2013         require(cavemanStaked[tokenId] == false, "NFT is Staked");
2014         cavemanStaked[tokenId] = true;
2015     }
2016 
2017     function unstakeCaveman(uint256 tokenId) public virtual {
2018         require(ownerOf(tokenId) == msg.sender, "You do not own the NFT");
2019         require(cavemanStaked[tokenId] == true, "NFT is Not Staked");
2020         cavemanStaked[tokenId] = false;
2021     }
2022 
2023     function _beforeTokenTransfers(
2024         address,
2025         address,
2026         uint256 startTokenId,
2027         uint256 quantity
2028     ) internal view override {
2029         uint256 tokenId = startTokenId;
2030         for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
2031             require(cavemanStaked[tokenId] == false, "Nft Staked");
2032         }
2033     }
2034 
2035     //only owner
2036     function setCost(uint256 _newCost) public onlyOwner {
2037         cost = _newCost;
2038     }
2039 
2040     function setWLCost(uint256 _newWLCost) public onlyOwner {
2041         wlCost = _newWLCost;
2042     }
2043 
2044     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2045         baseURI = _newBaseURI;
2046     }
2047 
2048     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2049         notRevealedUri = _notRevealedURI;
2050     }
2051 
2052     function setBaseExtension(string memory _newBaseExtension)
2053         public
2054         onlyOwner
2055     {
2056         baseExtension = _newBaseExtension;
2057     }
2058 
2059     function setRevealTokenId(uint256 _revealTokenId) public onlyOwner {
2060         revealTokenId = _revealTokenId;
2061     }
2062 
2063     function pause(bool _state) public onlyOwner {
2064         paused = _state;
2065     }
2066 
2067     function setWhitelistRoot(bytes32 _wlMerkleRoot) external onlyOwner {
2068         wlMerkleRoot = _wlMerkleRoot;
2069     }
2070 
2071     function setwlStartTime(uint256 _wlStartTime) external onlyOwner {
2072         wlStartTime = _wlStartTime;
2073     }
2074 
2075     function setpublicStartTime(uint256 _publicStartTime) external onlyOwner {
2076         publicStartTime = _publicStartTime;
2077     }
2078 
2079     function withdraw() public payable onlyOwner {
2080         require(payable(msg.sender).send(address(this).balance));
2081     }
2082 
2083     // ======== Royalties =========
2084 
2085     function setRoyaltyReceiver(address royaltyReceiver) public onlyOwner {
2086         royaltyAddress = royaltyReceiver;
2087     }
2088 
2089     function setRoyaltyPercentage(uint256 royaltyPercentage) public onlyOwner {
2090         royaltyPercent = royaltyPercentage;
2091     }
2092 
2093     function serverNow() public view returns (uint256 currenttimeStamp) {
2094         return block.timestamp;
2095     }
2096 }