1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
81 
82 
83 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
90  *
91  * These functions can be used to verify that a message was signed by the holder
92  * of the private keys of a given address.
93  */
94 library ECDSA {
95     enum RecoverError {
96         NoError,
97         InvalidSignature,
98         InvalidSignatureLength,
99         InvalidSignatureS,
100         InvalidSignatureV
101     }
102 
103     function _throwError(RecoverError error) private pure {
104         if (error == RecoverError.NoError) {
105             return; // no error: do nothing
106         } else if (error == RecoverError.InvalidSignature) {
107             revert("ECDSA: invalid signature");
108         } else if (error == RecoverError.InvalidSignatureLength) {
109             revert("ECDSA: invalid signature length");
110         } else if (error == RecoverError.InvalidSignatureS) {
111             revert("ECDSA: invalid signature 's' value");
112         } else if (error == RecoverError.InvalidSignatureV) {
113             revert("ECDSA: invalid signature 'v' value");
114         }
115     }
116 
117     /**
118      * @dev Returns the address that signed a hashed message (`hash`) with
119      * `signature` or error string. This address can then be used for verification purposes.
120      *
121      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
122      * this function rejects them by requiring the `s` value to be in the lower
123      * half order, and the `v` value to be either 27 or 28.
124      *
125      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
126      * verification to be secure: it is possible to craft signatures that
127      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
128      * this is by receiving a hash of the original message (which may otherwise
129      * be too long), and then calling {toEthSignedMessageHash} on it.
130      *
131      * Documentation for signature generation:
132      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
133      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
134      *
135      * _Available since v4.3._
136      */
137     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
138         // Check the signature length
139         // - case 65: r,s,v signature (standard)
140         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
141         if (signature.length == 65) {
142             bytes32 r;
143             bytes32 s;
144             uint8 v;
145             // ecrecover takes the signature parameters, and the only way to get them
146             // currently is to use assembly.
147             /// @solidity memory-safe-assembly
148             assembly {
149                 r := mload(add(signature, 0x20))
150                 s := mload(add(signature, 0x40))
151                 v := byte(0, mload(add(signature, 0x60)))
152             }
153             return tryRecover(hash, v, r, s);
154         } else if (signature.length == 64) {
155             bytes32 r;
156             bytes32 vs;
157             // ecrecover takes the signature parameters, and the only way to get them
158             // currently is to use assembly.
159             /// @solidity memory-safe-assembly
160             assembly {
161                 r := mload(add(signature, 0x20))
162                 vs := mload(add(signature, 0x40))
163             }
164             return tryRecover(hash, r, vs);
165         } else {
166             return (address(0), RecoverError.InvalidSignatureLength);
167         }
168     }
169 
170     /**
171      * @dev Returns the address that signed a hashed message (`hash`) with
172      * `signature`. This address can then be used for verification purposes.
173      *
174      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
175      * this function rejects them by requiring the `s` value to be in the lower
176      * half order, and the `v` value to be either 27 or 28.
177      *
178      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
179      * verification to be secure: it is possible to craft signatures that
180      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
181      * this is by receiving a hash of the original message (which may otherwise
182      * be too long), and then calling {toEthSignedMessageHash} on it.
183      */
184     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
185         (address recovered, RecoverError error) = tryRecover(hash, signature);
186         _throwError(error);
187         return recovered;
188     }
189 
190     /**
191      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
192      *
193      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
194      *
195      * _Available since v4.3._
196      */
197     function tryRecover(
198         bytes32 hash,
199         bytes32 r,
200         bytes32 vs
201     ) internal pure returns (address, RecoverError) {
202         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
203         uint8 v = uint8((uint256(vs) >> 255) + 27);
204         return tryRecover(hash, v, r, s);
205     }
206 
207     /**
208      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
209      *
210      * _Available since v4.2._
211      */
212     function recover(
213         bytes32 hash,
214         bytes32 r,
215         bytes32 vs
216     ) internal pure returns (address) {
217         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
218         _throwError(error);
219         return recovered;
220     }
221 
222     /**
223      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
224      * `r` and `s` signature fields separately.
225      *
226      * _Available since v4.3._
227      */
228     function tryRecover(
229         bytes32 hash,
230         uint8 v,
231         bytes32 r,
232         bytes32 s
233     ) internal pure returns (address, RecoverError) {
234         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
235         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
236         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
237         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
238         //
239         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
240         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
241         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
242         // these malleable signatures as well.
243         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
244             return (address(0), RecoverError.InvalidSignatureS);
245         }
246         if (v != 27 && v != 28) {
247             return (address(0), RecoverError.InvalidSignatureV);
248         }
249 
250         // If the signature is valid (and not malleable), return the signer address
251         address signer = ecrecover(hash, v, r, s);
252         if (signer == address(0)) {
253             return (address(0), RecoverError.InvalidSignature);
254         }
255 
256         return (signer, RecoverError.NoError);
257     }
258 
259     /**
260      * @dev Overload of {ECDSA-recover} that receives the `v`,
261      * `r` and `s` signature fields separately.
262      */
263     function recover(
264         bytes32 hash,
265         uint8 v,
266         bytes32 r,
267         bytes32 s
268     ) internal pure returns (address) {
269         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
270         _throwError(error);
271         return recovered;
272     }
273 
274     /**
275      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
276      * produces hash corresponding to the one signed with the
277      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
278      * JSON-RPC method as part of EIP-191.
279      *
280      * See {recover}.
281      */
282     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
283         // 32 is the length in bytes of hash,
284         // enforced by the type signature above
285         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
286     }
287 
288     /**
289      * @dev Returns an Ethereum Signed Message, created from `s`. This
290      * produces hash corresponding to the one signed with the
291      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
292      * JSON-RPC method as part of EIP-191.
293      *
294      * See {recover}.
295      */
296     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
297         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
298     }
299 
300     /**
301      * @dev Returns an Ethereum Signed Typed Data, created from a
302      * `domainSeparator` and a `structHash`. This produces hash corresponding
303      * to the one signed with the
304      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
305      * JSON-RPC method as part of EIP-712.
306      *
307      * See {recover}.
308      */
309     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
310         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
311     }
312 }
313 
314 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Contract module that helps prevent reentrant calls to a function.
323  *
324  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
325  * available, which can be applied to functions to make sure there are no nested
326  * (reentrant) calls to them.
327  *
328  * Note that because there is a single `nonReentrant` guard, functions marked as
329  * `nonReentrant` may not call one another. This can be worked around by making
330  * those functions `private`, and then adding `external` `nonReentrant` entry
331  * points to them.
332  *
333  * TIP: If you would like to learn more about reentrancy and alternative ways
334  * to protect against it, check out our blog post
335  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
336  */
337 abstract contract ReentrancyGuard {
338     // Booleans are more expensive than uint256 or any type that takes up a full
339     // word because each write operation emits an extra SLOAD to first read the
340     // slot's contents, replace the bits taken up by the boolean, and then write
341     // back. This is the compiler's defense against contract upgrades and
342     // pointer aliasing, and it cannot be disabled.
343 
344     // The values being non-zero value makes deployment a bit more expensive,
345     // but in exchange the refund on every call to nonReentrant will be lower in
346     // amount. Since refunds are capped to a percentage of the total
347     // transaction's gas, it is best to keep them low in cases like this one, to
348     // increase the likelihood of the full refund coming into effect.
349     uint256 private constant _NOT_ENTERED = 1;
350     uint256 private constant _ENTERED = 2;
351 
352     uint256 private _status;
353 
354     constructor() {
355         _status = _NOT_ENTERED;
356     }
357 
358     /**
359      * @dev Prevents a contract from calling itself, directly or indirectly.
360      * Calling a `nonReentrant` function from another `nonReentrant`
361      * function is not supported. It is possible to prevent this from happening
362      * by making the `nonReentrant` function external, and making it call a
363      * `private` function that does the actual work.
364      */
365     modifier nonReentrant() {
366         // On the first call to nonReentrant, _notEntered will be true
367         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
368 
369         // Any calls to nonReentrant after this point will fail
370         _status = _ENTERED;
371 
372         _;
373 
374         // By storing the original value once again, a refund is triggered (see
375         // https://eips.ethereum.org/EIPS/eip-2200)
376         _status = _NOT_ENTERED;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/utils/Context.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Provides information about the current execution context, including the
389  * sender of the transaction and its data. While these are generally available
390  * via msg.sender and msg.data, they should not be accessed in such a direct
391  * manner, since when dealing with meta-transactions the account sending and
392  * paying for execution may not be the actual sender (as far as an application
393  * is concerned).
394  *
395  * This contract is only required for intermediate, library-like contracts.
396  */
397 abstract contract Context {
398     function _msgSender() internal view virtual returns (address) {
399         return msg.sender;
400     }
401 
402     function _msgData() internal view virtual returns (bytes calldata) {
403         return msg.data;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/access/Ownable.sol
408 
409 
410 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Contract module which provides a basic access control mechanism, where
417  * there is an account (an owner) that can be granted exclusive access to
418  * specific functions.
419  *
420  * By default, the owner account will be the one that deploys the contract. This
421  * can later be changed with {transferOwnership}.
422  *
423  * This module is used through inheritance. It will make available the modifier
424  * `onlyOwner`, which can be applied to your functions to restrict their use to
425  * the owner.
426  */
427 abstract contract Ownable is Context {
428     address private _owner;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor() {
436         _transferOwnership(_msgSender());
437     }
438 
439     /**
440      * @dev Throws if called by any account other than the owner.
441      */
442     modifier onlyOwner() {
443         _checkOwner();
444         _;
445     }
446 
447     /**
448      * @dev Returns the address of the current owner.
449      */
450     function owner() public view virtual returns (address) {
451         return _owner;
452     }
453 
454     /**
455      * @dev Throws if the sender is not the owner.
456      */
457     function _checkOwner() internal view virtual {
458         require(owner() == _msgSender(), "Ownable: caller is not the owner");
459     }
460 
461     /**
462      * @dev Leaves the contract without owner. It will not be possible to call
463      * `onlyOwner` functions anymore. Can only be called by the current owner.
464      *
465      * NOTE: Renouncing ownership will leave the contract without an owner,
466      * thereby removing any functionality that is only available to the owner.
467      */
468     function renounceOwnership() public virtual onlyOwner {
469         _transferOwnership(address(0));
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         _transferOwnership(newOwner);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Internal function without access restriction.
484      */
485     function _transferOwnership(address newOwner) internal virtual {
486         address oldOwner = _owner;
487         _owner = newOwner;
488         emit OwnershipTransferred(oldOwner, newOwner);
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev These functions deal with verification of Merkle Tree proofs.
501  *
502  * The proofs can be generated using the JavaScript library
503  * https://github.com/miguelmota/merkletreejs[merkletreejs].
504  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
505  *
506  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
507  *
508  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
509  * hashing, or use a hash function other than keccak256 for hashing leaves.
510  * This is because the concatenation of a sorted pair of internal nodes in
511  * the merkle tree could be reinterpreted as a leaf value.
512  */
513 library MerkleProof {
514     /**
515      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
516      * defined by `root`. For this, a `proof` must be provided, containing
517      * sibling hashes on the branch from the leaf to the root of the tree. Each
518      * pair of leaves and each pair of pre-images are assumed to be sorted.
519      */
520     function verify(
521         bytes32[] memory proof,
522         bytes32 root,
523         bytes32 leaf
524     ) internal pure returns (bool) {
525         return processProof(proof, leaf) == root;
526     }
527 
528     /**
529      * @dev Calldata version of {verify}
530      *
531      * _Available since v4.7._
532      */
533     function verifyCalldata(
534         bytes32[] calldata proof,
535         bytes32 root,
536         bytes32 leaf
537     ) internal pure returns (bool) {
538         return processProofCalldata(proof, leaf) == root;
539     }
540 
541     /**
542      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
543      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
544      * hash matches the root of the tree. When processing the proof, the pairs
545      * of leafs & pre-images are assumed to be sorted.
546      *
547      * _Available since v4.4._
548      */
549     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
550         bytes32 computedHash = leaf;
551         for (uint256 i = 0; i < proof.length; i++) {
552             computedHash = _hashPair(computedHash, proof[i]);
553         }
554         return computedHash;
555     }
556 
557     /**
558      * @dev Calldata version of {processProof}
559      *
560      * _Available since v4.7._
561      */
562     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
563         bytes32 computedHash = leaf;
564         for (uint256 i = 0; i < proof.length; i++) {
565             computedHash = _hashPair(computedHash, proof[i]);
566         }
567         return computedHash;
568     }
569 
570     /**
571      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
572      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
573      *
574      * _Available since v4.7._
575      */
576     function multiProofVerify(
577         bytes32[] memory proof,
578         bool[] memory proofFlags,
579         bytes32 root,
580         bytes32[] memory leaves
581     ) internal pure returns (bool) {
582         return processMultiProof(proof, proofFlags, leaves) == root;
583     }
584 
585     /**
586      * @dev Calldata version of {multiProofVerify}
587      *
588      * _Available since v4.7._
589      */
590     function multiProofVerifyCalldata(
591         bytes32[] calldata proof,
592         bool[] calldata proofFlags,
593         bytes32 root,
594         bytes32[] memory leaves
595     ) internal pure returns (bool) {
596         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
597     }
598 
599     /**
600      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
601      * consuming from one or the other at each step according to the instructions given by
602      * `proofFlags`.
603      *
604      * _Available since v4.7._
605      */
606     function processMultiProof(
607         bytes32[] memory proof,
608         bool[] memory proofFlags,
609         bytes32[] memory leaves
610     ) internal pure returns (bytes32 merkleRoot) {
611         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
612         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
613         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
614         // the merkle tree.
615         uint256 leavesLen = leaves.length;
616         uint256 totalHashes = proofFlags.length;
617 
618         // Check proof validity.
619         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
620 
621         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
622         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
623         bytes32[] memory hashes = new bytes32[](totalHashes);
624         uint256 leafPos = 0;
625         uint256 hashPos = 0;
626         uint256 proofPos = 0;
627         // At each step, we compute the next hash using two values:
628         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
629         //   get the next hash.
630         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
631         //   `proof` array.
632         for (uint256 i = 0; i < totalHashes; i++) {
633             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
634             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
635             hashes[i] = _hashPair(a, b);
636         }
637 
638         if (totalHashes > 0) {
639             return hashes[totalHashes - 1];
640         } else if (leavesLen > 0) {
641             return leaves[0];
642         } else {
643             return proof[0];
644         }
645     }
646 
647     /**
648      * @dev Calldata version of {processMultiProof}
649      *
650      * _Available since v4.7._
651      */
652     function processMultiProofCalldata(
653         bytes32[] calldata proof,
654         bool[] calldata proofFlags,
655         bytes32[] memory leaves
656     ) internal pure returns (bytes32 merkleRoot) {
657         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
658         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
659         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
660         // the merkle tree.
661         uint256 leavesLen = leaves.length;
662         uint256 totalHashes = proofFlags.length;
663 
664         // Check proof validity.
665         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
666 
667         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
668         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
669         bytes32[] memory hashes = new bytes32[](totalHashes);
670         uint256 leafPos = 0;
671         uint256 hashPos = 0;
672         uint256 proofPos = 0;
673         // At each step, we compute the next hash using two values:
674         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
675         //   get the next hash.
676         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
677         //   `proof` array.
678         for (uint256 i = 0; i < totalHashes; i++) {
679             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
680             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
681             hashes[i] = _hashPair(a, b);
682         }
683 
684         if (totalHashes > 0) {
685             return hashes[totalHashes - 1];
686         } else if (leavesLen > 0) {
687             return leaves[0];
688         } else {
689             return proof[0];
690         }
691     }
692 
693     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
694         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
695     }
696 
697     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
698         /// @solidity memory-safe-assembly
699         assembly {
700             mstore(0x00, a)
701             mstore(0x20, b)
702             value := keccak256(0x00, 0x40)
703         }
704     }
705 }
706 
707 // File: erc721a/contracts/IERC721A.sol
708 
709 
710 // ERC721A Contracts v4.1.0
711 // Creator: Chiru Labs
712 
713 pragma solidity ^0.8.4;
714 
715 /**
716  * @dev Interface of an ERC721A compliant contract.
717  */
718 interface IERC721A {
719     /**
720      * The caller must own the token or be an approved operator.
721      */
722     error ApprovalCallerNotOwnerNorApproved();
723 
724     /**
725      * The token does not exist.
726      */
727     error ApprovalQueryForNonexistentToken();
728 
729     /**
730      * The caller cannot approve to their own address.
731      */
732     error ApproveToCaller();
733 
734     /**
735      * Cannot query the balance for the zero address.
736      */
737     error BalanceQueryForZeroAddress();
738 
739     /**
740      * Cannot mint to the zero address.
741      */
742     error MintToZeroAddress();
743 
744     /**
745      * The quantity of tokens minted must be more than zero.
746      */
747     error MintZeroQuantity();
748 
749     /**
750      * The token does not exist.
751      */
752     error OwnerQueryForNonexistentToken();
753 
754     /**
755      * The caller must own the token or be an approved operator.
756      */
757     error TransferCallerNotOwnerNorApproved();
758 
759     /**
760      * The token must be owned by `from`.
761      */
762     error TransferFromIncorrectOwner();
763 
764     /**
765      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
766      */
767     error TransferToNonERC721ReceiverImplementer();
768 
769     /**
770      * Cannot transfer to the zero address.
771      */
772     error TransferToZeroAddress();
773 
774     /**
775      * The token does not exist.
776      */
777     error URIQueryForNonexistentToken();
778 
779     /**
780      * The `quantity` minted with ERC2309 exceeds the safety limit.
781      */
782     error MintERC2309QuantityExceedsLimit();
783 
784     /**
785      * The `extraData` cannot be set on an unintialized ownership slot.
786      */
787     error OwnershipNotInitializedForExtraData();
788 
789     struct TokenOwnership {
790         // The address of the owner.
791         address addr;
792         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
793         uint64 startTimestamp;
794         // Whether the token has been burned.
795         bool burned;
796         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
797         uint24 extraData;
798     }
799 
800     /**
801      * @dev Returns the total amount of tokens stored by the contract.
802      *
803      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
804      */
805     function totalSupply() external view returns (uint256);
806 
807     // ==============================
808     //            IERC165
809     // ==============================
810 
811     /**
812      * @dev Returns true if this contract implements the interface defined by
813      * `interfaceId`. See the corresponding
814      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
815      * to learn more about how these ids are created.
816      *
817      * This function call must use less than 30 000 gas.
818      */
819     function supportsInterface(bytes4 interfaceId) external view returns (bool);
820 
821     // ==============================
822     //            IERC721
823     // ==============================
824 
825     /**
826      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
827      */
828     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
829 
830     /**
831      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
832      */
833     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
834 
835     /**
836      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
837      */
838     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
839 
840     /**
841      * @dev Returns the number of tokens in ``owner``'s account.
842      */
843     function balanceOf(address owner) external view returns (uint256 balance);
844 
845     /**
846      * @dev Returns the owner of the `tokenId` token.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      */
852     function ownerOf(uint256 tokenId) external view returns (address owner);
853 
854     /**
855      * @dev Safely transfers `tokenId` token from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes calldata data
872     ) external;
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
876      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must exist and be owned by `from`.
883      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) external;
893 
894     /**
895      * @dev Transfers `tokenId` token from `from` to `to`.
896      *
897      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
905      *
906      * Emits a {Transfer} event.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) external;
913 
914     /**
915      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
916      * The approval is cleared when the token is transferred.
917      *
918      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
919      *
920      * Requirements:
921      *
922      * - The caller must own the token or be an approved operator.
923      * - `tokenId` must exist.
924      *
925      * Emits an {Approval} event.
926      */
927     function approve(address to, uint256 tokenId) external;
928 
929     /**
930      * @dev Approve or remove `operator` as an operator for the caller.
931      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
932      *
933      * Requirements:
934      *
935      * - The `operator` cannot be the caller.
936      *
937      * Emits an {ApprovalForAll} event.
938      */
939     function setApprovalForAll(address operator, bool _approved) external;
940 
941     /**
942      * @dev Returns the account approved for `tokenId` token.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function getApproved(uint256 tokenId) external view returns (address operator);
949 
950     /**
951      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
952      *
953      * See {setApprovalForAll}
954      */
955     function isApprovedForAll(address owner, address operator) external view returns (bool);
956 
957     // ==============================
958     //        IERC721Metadata
959     // ==============================
960 
961     /**
962      * @dev Returns the token collection name.
963      */
964     function name() external view returns (string memory);
965 
966     /**
967      * @dev Returns the token collection symbol.
968      */
969     function symbol() external view returns (string memory);
970 
971     /**
972      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
973      */
974     function tokenURI(uint256 tokenId) external view returns (string memory);
975 
976     // ==============================
977     //            IERC2309
978     // ==============================
979 
980     /**
981      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
982      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
983      */
984     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
985 }
986 
987 // File: erc721a/contracts/ERC721A.sol
988 
989 
990 // ERC721A Contracts v4.1.0
991 // Creator: Chiru Labs
992 
993 pragma solidity ^0.8.4;
994 
995 
996 /**
997  * @dev ERC721 token receiver interface.
998  */
999 interface ERC721A__IERC721Receiver {
1000     function onERC721Received(
1001         address operator,
1002         address from,
1003         uint256 tokenId,
1004         bytes calldata data
1005     ) external returns (bytes4);
1006 }
1007 
1008 /**
1009  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
1010  * including the Metadata extension. Built to optimize for lower gas during batch mints.
1011  *
1012  * Assumes serials are sequentially minted starting at `_startTokenId()`
1013  * (defaults to 0, e.g. 0, 1, 2, 3..).
1014  *
1015  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1016  *
1017  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1018  */
1019 contract ERC721A is IERC721A {
1020     // Mask of an entry in packed address data.
1021     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1022 
1023     // The bit position of `numberMinted` in packed address data.
1024     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1025 
1026     // The bit position of `numberBurned` in packed address data.
1027     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1028 
1029     // The bit position of `aux` in packed address data.
1030     uint256 private constant BITPOS_AUX = 192;
1031 
1032     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1033     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1034 
1035     // The bit position of `startTimestamp` in packed ownership.
1036     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1037 
1038     // The bit mask of the `burned` bit in packed ownership.
1039     uint256 private constant BITMASK_BURNED = 1 << 224;
1040 
1041     // The bit position of the `nextInitialized` bit in packed ownership.
1042     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1043 
1044     // The bit mask of the `nextInitialized` bit in packed ownership.
1045     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1046 
1047     // The bit position of `extraData` in packed ownership.
1048     uint256 private constant BITPOS_EXTRA_DATA = 232;
1049 
1050     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1051     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1052 
1053     // The mask of the lower 160 bits for addresses.
1054     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
1055 
1056     // The maximum `quantity` that can be minted with `_mintERC2309`.
1057     // This limit is to prevent overflows on the address data entries.
1058     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
1059     // is required to cause an overflow, which is unrealistic.
1060     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1061 
1062     // The tokenId of the next token to be minted.
1063     uint256 private _currentIndex;
1064 
1065     // The number of tokens burned.
1066     uint256 private _burnCounter;
1067 
1068     // Token name
1069     string private _name;
1070 
1071     // Token symbol
1072     string private _symbol;
1073 
1074     // Mapping from token ID to ownership details
1075     // An empty struct value does not necessarily mean the token is unowned.
1076     // See `_packedOwnershipOf` implementation for details.
1077     //
1078     // Bits Layout:
1079     // - [0..159]   `addr`
1080     // - [160..223] `startTimestamp`
1081     // - [224]      `burned`
1082     // - [225]      `nextInitialized`
1083     // - [232..255] `extraData`
1084     mapping(uint256 => uint256) private _packedOwnerships;
1085 
1086     // Mapping owner address to address data.
1087     //
1088     // Bits Layout:
1089     // - [0..63]    `balance`
1090     // - [64..127]  `numberMinted`
1091     // - [128..191] `numberBurned`
1092     // - [192..255] `aux`
1093     mapping(address => uint256) private _packedAddressData;
1094 
1095     // Mapping from token ID to approved address.
1096     mapping(uint256 => address) private _tokenApprovals;
1097 
1098     // Mapping from owner to operator approvals
1099     mapping(address => mapping(address => bool)) private _operatorApprovals;
1100 
1101     constructor(string memory name_, string memory symbol_) {
1102         _name = name_;
1103         _symbol = symbol_;
1104         _currentIndex = _startTokenId();
1105     }
1106 
1107     /**
1108      * @dev Returns the starting token ID.
1109      * To change the starting token ID, please override this function.
1110      */
1111     function _startTokenId() internal view virtual returns (uint256) {
1112         return 0;
1113     }
1114 
1115     /**
1116      * @dev Returns the next token ID to be minted.
1117      */
1118     function _nextTokenId() internal view returns (uint256) {
1119         return _currentIndex;
1120     }
1121 
1122     /**
1123      * @dev Returns the total number of tokens in existence.
1124      * Burned tokens will reduce the count.
1125      * To get the total number of tokens minted, please see `_totalMinted`.
1126      */
1127     function totalSupply() public view override returns (uint256) {
1128         // Counter underflow is impossible as _burnCounter cannot be incremented
1129         // more than `_currentIndex - _startTokenId()` times.
1130         unchecked {
1131             return _currentIndex - _burnCounter - _startTokenId();
1132         }
1133     }
1134 
1135     /**
1136      * @dev Returns the total amount of tokens minted in the contract.
1137      */
1138     function _totalMinted() internal view returns (uint256) {
1139         // Counter underflow is impossible as _currentIndex does not decrement,
1140         // and it is initialized to `_startTokenId()`
1141         unchecked {
1142             return _currentIndex - _startTokenId();
1143         }
1144     }
1145 
1146     /**
1147      * @dev Returns the total number of tokens burned.
1148      */
1149     function _totalBurned() internal view returns (uint256) {
1150         return _burnCounter;
1151     }
1152 
1153     /**
1154      * @dev See {IERC165-supportsInterface}.
1155      */
1156     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1157         // The interface IDs are constants representing the first 4 bytes of the XOR of
1158         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1159         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1160         return
1161             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1162             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1163             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-balanceOf}.
1168      */
1169     function balanceOf(address owner) public view override returns (uint256) {
1170         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1171         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1172     }
1173 
1174     /**
1175      * Returns the number of tokens minted by `owner`.
1176      */
1177     function _numberMinted(address owner) internal view returns (uint256) {
1178         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1179     }
1180 
1181     /**
1182      * Returns the number of tokens burned by or on behalf of `owner`.
1183      */
1184     function _numberBurned(address owner) internal view returns (uint256) {
1185         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1186     }
1187 
1188     /**
1189      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1190      */
1191     function _getAux(address owner) internal view returns (uint64) {
1192         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1193     }
1194 
1195     /**
1196      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1197      * If there are multiple variables, please pack them into a uint64.
1198      */
1199     function _setAux(address owner, uint64 aux) internal {
1200         uint256 packed = _packedAddressData[owner];
1201         uint256 auxCasted;
1202         // Cast `aux` with assembly to avoid redundant masking.
1203         assembly {
1204             auxCasted := aux
1205         }
1206         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1207         _packedAddressData[owner] = packed;
1208     }
1209 
1210     /**
1211      * Returns the packed ownership data of `tokenId`.
1212      */
1213     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1214         uint256 curr = tokenId;
1215 
1216         unchecked {
1217             if (_startTokenId() <= curr)
1218                 if (curr < _currentIndex) {
1219                     uint256 packed = _packedOwnerships[curr];
1220                     // If not burned.
1221                     if (packed & BITMASK_BURNED == 0) {
1222                         // Invariant:
1223                         // There will always be an ownership that has an address and is not burned
1224                         // before an ownership that does not have an address and is not burned.
1225                         // Hence, curr will not underflow.
1226                         //
1227                         // We can directly compare the packed value.
1228                         // If the address is zero, packed is zero.
1229                         while (packed == 0) {
1230                             packed = _packedOwnerships[--curr];
1231                         }
1232                         return packed;
1233                     }
1234                 }
1235         }
1236         revert OwnerQueryForNonexistentToken();
1237     }
1238 
1239     /**
1240      * Returns the unpacked `TokenOwnership` struct from `packed`.
1241      */
1242     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1243         ownership.addr = address(uint160(packed));
1244         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1245         ownership.burned = packed & BITMASK_BURNED != 0;
1246         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1247     }
1248 
1249     /**
1250      * Returns the unpacked `TokenOwnership` struct at `index`.
1251      */
1252     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1253         return _unpackedOwnership(_packedOwnerships[index]);
1254     }
1255 
1256     /**
1257      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1258      */
1259     function _initializeOwnershipAt(uint256 index) internal {
1260         if (_packedOwnerships[index] == 0) {
1261             _packedOwnerships[index] = _packedOwnershipOf(index);
1262         }
1263     }
1264 
1265     /**
1266      * Gas spent here starts off proportional to the maximum mint batch size.
1267      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1268      */
1269     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1270         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1271     }
1272 
1273     /**
1274      * @dev Packs ownership data into a single uint256.
1275      */
1276     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1277         assembly {
1278             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1279             owner := and(owner, BITMASK_ADDRESS)
1280             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1281             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1282         }
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-ownerOf}.
1287      */
1288     function ownerOf(uint256 tokenId) public view override returns (address) {
1289         return address(uint160(_packedOwnershipOf(tokenId)));
1290     }
1291 
1292     /**
1293      * @dev See {IERC721Metadata-name}.
1294      */
1295     function name() public view virtual override returns (string memory) {
1296         return _name;
1297     }
1298 
1299     /**
1300      * @dev See {IERC721Metadata-symbol}.
1301      */
1302     function symbol() public view virtual override returns (string memory) {
1303         return _symbol;
1304     }
1305 
1306     /**
1307      * @dev See {IERC721Metadata-tokenURI}.
1308      */
1309     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1310         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1311 
1312         string memory baseURI = _baseURI();
1313         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1314     }
1315 
1316     /**
1317      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1318      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1319      * by default, it can be overridden in child contracts.
1320      */
1321     function _baseURI() internal view virtual returns (string memory) {
1322         return '';
1323     }
1324 
1325     /**
1326      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1327      */
1328     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1329         // For branchless setting of the `nextInitialized` flag.
1330         assembly {
1331             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1332             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1333         }
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-approve}.
1338      */
1339     function approve(address to, uint256 tokenId) public override {
1340         address owner = ownerOf(tokenId);
1341 
1342         if (_msgSenderERC721A() != owner)
1343             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1344                 revert ApprovalCallerNotOwnerNorApproved();
1345             }
1346 
1347         _tokenApprovals[tokenId] = to;
1348         emit Approval(owner, to, tokenId);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-getApproved}.
1353      */
1354     function getApproved(uint256 tokenId) public view override returns (address) {
1355         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1356 
1357         return _tokenApprovals[tokenId];
1358     }
1359 
1360     /**
1361      * @dev See {IERC721-setApprovalForAll}.
1362      */
1363     function setApprovalForAll(address operator, bool approved) public virtual override {
1364         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1365 
1366         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1367         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1368     }
1369 
1370     /**
1371      * @dev See {IERC721-isApprovedForAll}.
1372      */
1373     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1374         return _operatorApprovals[owner][operator];
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-safeTransferFrom}.
1379      */
1380     function safeTransferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) public virtual override {
1385         safeTransferFrom(from, to, tokenId, '');
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-safeTransferFrom}.
1390      */
1391     function safeTransferFrom(
1392         address from,
1393         address to,
1394         uint256 tokenId,
1395         bytes memory _data
1396     ) public virtual override {
1397         transferFrom(from, to, tokenId);
1398         if (to.code.length != 0)
1399             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1400                 revert TransferToNonERC721ReceiverImplementer();
1401             }
1402     }
1403 
1404     /**
1405      * @dev Returns whether `tokenId` exists.
1406      *
1407      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1408      *
1409      * Tokens start existing when they are minted (`_mint`),
1410      */
1411     function _exists(uint256 tokenId) internal view returns (bool) {
1412         return
1413             _startTokenId() <= tokenId &&
1414             tokenId < _currentIndex && // If within bounds,
1415             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1416     }
1417 
1418     /**
1419      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1420      */
1421     function _safeMint(address to, uint256 quantity) internal {
1422         _safeMint(to, quantity, '');
1423     }
1424 
1425     /**
1426      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1427      *
1428      * Requirements:
1429      *
1430      * - If `to` refers to a smart contract, it must implement
1431      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1432      * - `quantity` must be greater than 0.
1433      *
1434      * See {_mint}.
1435      *
1436      * Emits a {Transfer} event for each mint.
1437      */
1438     function _safeMint(
1439         address to,
1440         uint256 quantity,
1441         bytes memory _data
1442     ) internal {
1443         _mint(to, quantity);
1444 
1445         unchecked {
1446             if (to.code.length != 0) {
1447                 uint256 end = _currentIndex;
1448                 uint256 index = end - quantity;
1449                 do {
1450                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1451                         revert TransferToNonERC721ReceiverImplementer();
1452                     }
1453                 } while (index < end);
1454                 // Reentrancy protection.
1455                 if (_currentIndex != end) revert();
1456             }
1457         }
1458     }
1459 
1460     /**
1461      * @dev Mints `quantity` tokens and transfers them to `to`.
1462      *
1463      * Requirements:
1464      *
1465      * - `to` cannot be the zero address.
1466      * - `quantity` must be greater than 0.
1467      *
1468      * Emits a {Transfer} event for each mint.
1469      */
1470     function _mint(address to, uint256 quantity) internal {
1471         uint256 startTokenId = _currentIndex;
1472         if (to == address(0)) revert MintToZeroAddress();
1473         if (quantity == 0) revert MintZeroQuantity();
1474 
1475         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1476 
1477         // Overflows are incredibly unrealistic.
1478         // `balance` and `numberMinted` have a maximum limit of 2**64.
1479         // `tokenId` has a maximum limit of 2**256.
1480         unchecked {
1481             // Updates:
1482             // - `balance += quantity`.
1483             // - `numberMinted += quantity`.
1484             //
1485             // We can directly add to the `balance` and `numberMinted`.
1486             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1487 
1488             // Updates:
1489             // - `address` to the owner.
1490             // - `startTimestamp` to the timestamp of minting.
1491             // - `burned` to `false`.
1492             // - `nextInitialized` to `quantity == 1`.
1493             _packedOwnerships[startTokenId] = _packOwnershipData(
1494                 to,
1495                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1496             );
1497 
1498             uint256 tokenId = startTokenId;
1499             uint256 end = startTokenId + quantity;
1500             do {
1501                 emit Transfer(address(0), to, tokenId++);
1502             } while (tokenId < end);
1503 
1504             _currentIndex = end;
1505         }
1506         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1507     }
1508 
1509     /**
1510      * @dev Mints `quantity` tokens and transfers them to `to`.
1511      *
1512      * This function is intended for efficient minting only during contract creation.
1513      *
1514      * It emits only one {ConsecutiveTransfer} as defined in
1515      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1516      * instead of a sequence of {Transfer} event(s).
1517      *
1518      * Calling this function outside of contract creation WILL make your contract
1519      * non-compliant with the ERC721 standard.
1520      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1521      * {ConsecutiveTransfer} event is only permissible during contract creation.
1522      *
1523      * Requirements:
1524      *
1525      * - `to` cannot be the zero address.
1526      * - `quantity` must be greater than 0.
1527      *
1528      * Emits a {ConsecutiveTransfer} event.
1529      */
1530     function _mintERC2309(address to, uint256 quantity) internal {
1531         uint256 startTokenId = _currentIndex;
1532         if (to == address(0)) revert MintToZeroAddress();
1533         if (quantity == 0) revert MintZeroQuantity();
1534         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1535 
1536         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1537 
1538         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1539         unchecked {
1540             // Updates:
1541             // - `balance += quantity`.
1542             // - `numberMinted += quantity`.
1543             //
1544             // We can directly add to the `balance` and `numberMinted`.
1545             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1546 
1547             // Updates:
1548             // - `address` to the owner.
1549             // - `startTimestamp` to the timestamp of minting.
1550             // - `burned` to `false`.
1551             // - `nextInitialized` to `quantity == 1`.
1552             _packedOwnerships[startTokenId] = _packOwnershipData(
1553                 to,
1554                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1555             );
1556 
1557             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1558 
1559             _currentIndex = startTokenId + quantity;
1560         }
1561         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1562     }
1563 
1564     /**
1565      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1566      */
1567     function _getApprovedAddress(uint256 tokenId)
1568         private
1569         view
1570         returns (uint256 approvedAddressSlot, address approvedAddress)
1571     {
1572         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1573         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1574         assembly {
1575             // Compute the slot.
1576             mstore(0x00, tokenId)
1577             mstore(0x20, tokenApprovalsPtr.slot)
1578             approvedAddressSlot := keccak256(0x00, 0x40)
1579             // Load the slot's value from storage.
1580             approvedAddress := sload(approvedAddressSlot)
1581         }
1582     }
1583 
1584     /**
1585      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1586      */
1587     function _isOwnerOrApproved(
1588         address approvedAddress,
1589         address from,
1590         address msgSender
1591     ) private pure returns (bool result) {
1592         assembly {
1593             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1594             from := and(from, BITMASK_ADDRESS)
1595             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1596             msgSender := and(msgSender, BITMASK_ADDRESS)
1597             // `msgSender == from || msgSender == approvedAddress`.
1598             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1599         }
1600     }
1601 
1602     /**
1603      * @dev Transfers `tokenId` from `from` to `to`.
1604      *
1605      * Requirements:
1606      *
1607      * - `to` cannot be the zero address.
1608      * - `tokenId` token must be owned by `from`.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function transferFrom(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) public virtual override {
1617         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1618 
1619         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1620 
1621         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1622 
1623         // The nested ifs save around 20+ gas over a compound boolean condition.
1624         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1625             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1626 
1627         if (to == address(0)) revert TransferToZeroAddress();
1628 
1629         _beforeTokenTransfers(from, to, tokenId, 1);
1630 
1631         // Clear approvals from the previous owner.
1632         assembly {
1633             if approvedAddress {
1634                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1635                 sstore(approvedAddressSlot, 0)
1636             }
1637         }
1638 
1639         // Underflow of the sender's balance is impossible because we check for
1640         // ownership above and the recipient's balance can't realistically overflow.
1641         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1642         unchecked {
1643             // We can directly increment and decrement the balances.
1644             --_packedAddressData[from]; // Updates: `balance -= 1`.
1645             ++_packedAddressData[to]; // Updates: `balance += 1`.
1646 
1647             // Updates:
1648             // - `address` to the next owner.
1649             // - `startTimestamp` to the timestamp of transfering.
1650             // - `burned` to `false`.
1651             // - `nextInitialized` to `true`.
1652             _packedOwnerships[tokenId] = _packOwnershipData(
1653                 to,
1654                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1655             );
1656 
1657             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1658             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1659                 uint256 nextTokenId = tokenId + 1;
1660                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1661                 if (_packedOwnerships[nextTokenId] == 0) {
1662                     // If the next slot is within bounds.
1663                     if (nextTokenId != _currentIndex) {
1664                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1665                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1666                     }
1667                 }
1668             }
1669         }
1670 
1671         emit Transfer(from, to, tokenId);
1672         _afterTokenTransfers(from, to, tokenId, 1);
1673     }
1674 
1675     /**
1676      * @dev Equivalent to `_burn(tokenId, false)`.
1677      */
1678     function _burn(uint256 tokenId) internal virtual {
1679         _burn(tokenId, false);
1680     }
1681 
1682     /**
1683      * @dev Destroys `tokenId`.
1684      * The approval is cleared when the token is burned.
1685      *
1686      * Requirements:
1687      *
1688      * - `tokenId` must exist.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1693         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1694 
1695         address from = address(uint160(prevOwnershipPacked));
1696 
1697         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1698 
1699         if (approvalCheck) {
1700             // The nested ifs save around 20+ gas over a compound boolean condition.
1701             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1702                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1703         }
1704 
1705         _beforeTokenTransfers(from, address(0), tokenId, 1);
1706 
1707         // Clear approvals from the previous owner.
1708         assembly {
1709             if approvedAddress {
1710                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1711                 sstore(approvedAddressSlot, 0)
1712             }
1713         }
1714 
1715         // Underflow of the sender's balance is impossible because we check for
1716         // ownership above and the recipient's balance can't realistically overflow.
1717         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1718         unchecked {
1719             // Updates:
1720             // - `balance -= 1`.
1721             // - `numberBurned += 1`.
1722             //
1723             // We can directly decrement the balance, and increment the number burned.
1724             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1725             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1726 
1727             // Updates:
1728             // - `address` to the last owner.
1729             // - `startTimestamp` to the timestamp of burning.
1730             // - `burned` to `true`.
1731             // - `nextInitialized` to `true`.
1732             _packedOwnerships[tokenId] = _packOwnershipData(
1733                 from,
1734                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1735             );
1736 
1737             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1738             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1739                 uint256 nextTokenId = tokenId + 1;
1740                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1741                 if (_packedOwnerships[nextTokenId] == 0) {
1742                     // If the next slot is within bounds.
1743                     if (nextTokenId != _currentIndex) {
1744                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1745                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1746                     }
1747                 }
1748             }
1749         }
1750 
1751         emit Transfer(from, address(0), tokenId);
1752         _afterTokenTransfers(from, address(0), tokenId, 1);
1753 
1754         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1755         unchecked {
1756             _burnCounter++;
1757         }
1758     }
1759 
1760     /**
1761      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1762      *
1763      * @param from address representing the previous owner of the given token ID
1764      * @param to target address that will receive the tokens
1765      * @param tokenId uint256 ID of the token to be transferred
1766      * @param _data bytes optional data to send along with the call
1767      * @return bool whether the call correctly returned the expected magic value
1768      */
1769     function _checkContractOnERC721Received(
1770         address from,
1771         address to,
1772         uint256 tokenId,
1773         bytes memory _data
1774     ) private returns (bool) {
1775         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1776             bytes4 retval
1777         ) {
1778             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1779         } catch (bytes memory reason) {
1780             if (reason.length == 0) {
1781                 revert TransferToNonERC721ReceiverImplementer();
1782             } else {
1783                 assembly {
1784                     revert(add(32, reason), mload(reason))
1785                 }
1786             }
1787         }
1788     }
1789 
1790     /**
1791      * @dev Directly sets the extra data for the ownership data `index`.
1792      */
1793     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1794         uint256 packed = _packedOwnerships[index];
1795         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1796         uint256 extraDataCasted;
1797         // Cast `extraData` with assembly to avoid redundant masking.
1798         assembly {
1799             extraDataCasted := extraData
1800         }
1801         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1802         _packedOwnerships[index] = packed;
1803     }
1804 
1805     /**
1806      * @dev Returns the next extra data for the packed ownership data.
1807      * The returned result is shifted into position.
1808      */
1809     function _nextExtraData(
1810         address from,
1811         address to,
1812         uint256 prevOwnershipPacked
1813     ) private view returns (uint256) {
1814         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1815         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1816     }
1817 
1818     /**
1819      * @dev Called during each token transfer to set the 24bit `extraData` field.
1820      * Intended to be overridden by the cosumer contract.
1821      *
1822      * `previousExtraData` - the value of `extraData` before transfer.
1823      *
1824      * Calling conditions:
1825      *
1826      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1827      * transferred to `to`.
1828      * - When `from` is zero, `tokenId` will be minted for `to`.
1829      * - When `to` is zero, `tokenId` will be burned by `from`.
1830      * - `from` and `to` are never both zero.
1831      */
1832     function _extraData(
1833         address from,
1834         address to,
1835         uint24 previousExtraData
1836     ) internal view virtual returns (uint24) {}
1837 
1838     /**
1839      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1840      * This includes minting.
1841      * And also called before burning one token.
1842      *
1843      * startTokenId - the first token id to be transferred
1844      * quantity - the amount to be transferred
1845      *
1846      * Calling conditions:
1847      *
1848      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1849      * transferred to `to`.
1850      * - When `from` is zero, `tokenId` will be minted for `to`.
1851      * - When `to` is zero, `tokenId` will be burned by `from`.
1852      * - `from` and `to` are never both zero.
1853      */
1854     function _beforeTokenTransfers(
1855         address from,
1856         address to,
1857         uint256 startTokenId,
1858         uint256 quantity
1859     ) internal virtual {}
1860 
1861     /**
1862      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1863      * This includes minting.
1864      * And also called after one token has been burned.
1865      *
1866      * startTokenId - the first token id to be transferred
1867      * quantity - the amount to be transferred
1868      *
1869      * Calling conditions:
1870      *
1871      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1872      * transferred to `to`.
1873      * - When `from` is zero, `tokenId` has been minted for `to`.
1874      * - When `to` is zero, `tokenId` has been burned by `from`.
1875      * - `from` and `to` are never both zero.
1876      */
1877     function _afterTokenTransfers(
1878         address from,
1879         address to,
1880         uint256 startTokenId,
1881         uint256 quantity
1882     ) internal virtual {}
1883 
1884     /**
1885      * @dev Returns the message sender (defaults to `msg.sender`).
1886      *
1887      * If you are writing GSN compatible contracts, you need to override this function.
1888      */
1889     function _msgSenderERC721A() internal view virtual returns (address) {
1890         return msg.sender;
1891     }
1892 
1893     /**
1894      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1895      */
1896     function _toString(uint256 value) internal pure returns (string memory ptr) {
1897         assembly {
1898             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1899             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1900             // We will need 1 32-byte word to store the length,
1901             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1902             ptr := add(mload(0x40), 128)
1903             // Update the free memory pointer to allocate.
1904             mstore(0x40, ptr)
1905 
1906             // Cache the end of the memory to calculate the length later.
1907             let end := ptr
1908 
1909             // We write the string from the rightmost digit to the leftmost digit.
1910             // The following is essentially a do-while loop that also handles the zero case.
1911             // Costs a bit more than early returning for the zero case,
1912             // but cheaper in terms of deployment and overall runtime costs.
1913             for {
1914                 // Initialize and perform the first pass without check.
1915                 let temp := value
1916                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1917                 ptr := sub(ptr, 1)
1918                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1919                 mstore8(ptr, add(48, mod(temp, 10)))
1920                 temp := div(temp, 10)
1921             } temp {
1922                 // Keep dividing `temp` until zero.
1923                 temp := div(temp, 10)
1924             } {
1925                 // Body of the for loop.
1926                 ptr := sub(ptr, 1)
1927                 mstore8(ptr, add(48, mod(temp, 10)))
1928             }
1929 
1930             let length := sub(end, ptr)
1931             // Move the pointer 32 bytes leftwards to make room for the length.
1932             ptr := sub(ptr, 32)
1933             // Store the length.
1934             mstore(ptr, length)
1935         }
1936     }
1937 }
1938 
1939 // File: contracts/BoredJametPunksClub.sol
1940 
1941 
1942 pragma solidity ^0.8.15;
1943 
1944 
1945 
1946 
1947 
1948 
1949 
1950 enum Mode {
1951     INIT,
1952     CLAIM,
1953     PRESALE,
1954     PUBLIC,
1955     FINAL
1956 }
1957 
1958 contract BoredJametPunksClub is ERC721A, Ownable, ReentrancyGuard {
1959     using ECDSA for bytes32;
1960     using Strings for uint256;
1961 
1962     string private _tokenBaseURI;
1963 
1964     uint256 public constant MAX_QTY = 3_333;
1965 
1966     // gifting config
1967     uint256 public constant QTY_FOR_GIFT = 33;
1968     uint256 public qtyMintedForGifting;
1969 
1970     // airdrop claim config
1971     uint256 public constant QTY_FOR_AIRDROP = 210;
1972     uint256 public qtyMintedForAirdrop;
1973     bytes32 private airdropRoot;
1974     mapping(address => bool) public airdropAddresses;
1975 
1976     // claim config
1977     uint256 public constant QTY_FOR_CLAIM = 123;
1978     uint256 public qtyMintedForClaim;
1979     mapping(address => bool) public claimAddresses;
1980     address private claimSigner;
1981 
1982     // free after paid mint(s)
1983     uint256 public constant FREE_AFTER = 2;
1984 
1985     // presale config
1986     uint256 public presalePrice = 0.0095 ether;
1987     uint256 public constant QTY_FOR_PRESALE = 2_222;
1988     uint256 public constant MAX_QTY_PER_PRESALE = 3;
1989     uint256 public qtyMintedForPresale;
1990     mapping(address => uint256) public presaleAddresses;
1991     address private presaleSigner;
1992 
1993     // public sale config
1994     uint256 public publicPrice = 0.015 ether;
1995     uint256 public constant MAX_QTY_PER_PUBLIC = 3;
1996     uint256 public qtyMintedForPublic;
1997     mapping(address => uint256) public publicAddresses;
1998 
1999     Mode public mode = Mode.INIT;
2000     bool public paused = false;
2001 
2002     constructor(
2003         bytes32 airdropRoot_,
2004         address claimSigner_,
2005         address presaleSigner_,
2006         string memory tokenBaseURI_
2007     ) 
2008         ERC721A("BoredJametPunksClub", "BJPC")
2009     {
2010         airdropRoot = airdropRoot_;
2011         claimSigner = claimSigner_;
2012         presaleSigner = presaleSigner_;
2013         _tokenBaseURI = tokenBaseURI_;
2014     }
2015 
2016     function gift(address to, uint256 qty) external onlyOwner nonReentrant {
2017         require(!paused, "paused");
2018         require(mode == Mode.INIT, "not in init mode");
2019         require(qtyMintedForGifting + qty <= QTY_FOR_GIFT, "exceeds gift qty");
2020         require(totalSupply() + qty <= MAX_QTY, "exceeds total supply");
2021 
2022         qtyMintedForGifting += qty;
2023 
2024         _safeMint(to, qty);
2025     }
2026 
2027     function claimAirdrop(uint256 qty, bytes32[] calldata proof) external nonReentrant {
2028         require(!paused, "paused");
2029         require(mode != Mode.INIT, "should not be in init mode");
2030         require(MerkleProof.verify(proof, airdropRoot, keccak256(
2031             abi.encodePacked(msg.sender, qty)
2032         )), "not eligible");
2033         require(tx.origin == msg.sender, "invalid origin");
2034         require(qtyMintedForAirdrop + qty <= QTY_FOR_AIRDROP, "exceeds airdrop qty");
2035         require(totalSupply() + qty <= MAX_QTY, "exceeds total supply");
2036         require(!airdropAddresses[msg.sender], "already airdropped");
2037 
2038         airdropAddresses[msg.sender] = true;
2039         qtyMintedForAirdrop += qty;
2040 
2041         _safeMint(msg.sender, qty);
2042     }
2043 
2044     function recoverSigner(address sender, bytes memory signature) internal pure returns (address) {
2045         return keccak256(
2046             abi.encodePacked(
2047                 "\x19Ethereum Signed Message:\n32",
2048                 bytes32(uint256(uint160(sender)))
2049             )
2050         ).recover(signature);
2051     }
2052 
2053     function claimMint(bytes calldata signature) external nonReentrant {
2054         require(!paused, "paused");
2055         require(mode == Mode.CLAIM, "not in claim mode");
2056         require(claimSigner == recoverSigner(msg.sender, signature), "invalid signature");
2057         require(tx.origin == msg.sender, "invalid origin");
2058         require(qtyMintedForClaim + 1 <= QTY_FOR_CLAIM, "exceeds total claim qty");
2059         require(totalSupply() + 1 <= MAX_QTY, "exceeds total supply");
2060         require(!claimAddresses[msg.sender], "already claimed");
2061 
2062         claimAddresses[msg.sender] = true;
2063         qtyMintedForClaim++;
2064 
2065         _safeMint(msg.sender, 1);
2066     }
2067 
2068     function presaleMint(uint256 qty, bytes calldata signature) external payable nonReentrant {
2069         require(!paused, "paused");
2070         require(mode == Mode.PRESALE, "not in presale mode");
2071         require(presaleSigner == recoverSigner(msg.sender, signature), "invalid signature");
2072         require(tx.origin == msg.sender, "invalid origin");
2073         require(qtyMintedForPresale + qty <= QTY_FOR_PRESALE, "exceeds total presale qty");
2074         require(qty <= MAX_QTY_PER_PRESALE, "exceeds qty per mint");
2075         require(totalSupply() + qty <= MAX_QTY, "exceeds total supply");
2076 
2077         uint256 oldQty = presaleAddresses[msg.sender];
2078         uint256 newQty = oldQty + qty;
2079         require(newQty <= MAX_QTY_PER_PRESALE, "exceeded allowed qty");
2080         
2081         uint256 cost = presalePrice;
2082         if (oldQty < FREE_AFTER) {
2083             uint256 adjQty = qty;
2084 
2085             if (newQty > FREE_AFTER) {
2086                 adjQty -= (newQty - FREE_AFTER);
2087             }
2088 
2089             cost *= adjQty;
2090         } else {
2091             cost = 0;
2092         }
2093 
2094         require(msg.value == cost, "incorrect eth");
2095         presaleAddresses[msg.sender] = newQty;
2096         qtyMintedForPresale += qty;
2097 
2098         _safeMint(msg.sender, qty);
2099     }
2100 
2101     function publicMint(uint256 qty) external payable nonReentrant {
2102         require(!paused, "paused");
2103         require(mode == Mode.PUBLIC, "not in public mode");
2104         require(tx.origin == msg.sender, "invalid origin");
2105         require(qty <= MAX_QTY_PER_PUBLIC, "exceeds qty per mint");
2106         require(totalSupply() + qty <= MAX_QTY, "exceeds total supply");
2107 
2108         uint256 oldQty = publicAddresses[msg.sender];
2109         uint256 newQty = oldQty + qty;
2110         require(newQty <= MAX_QTY_PER_PUBLIC, "exceeds allowed qty");
2111 
2112         uint256 cost = publicPrice;
2113         if (oldQty < FREE_AFTER) {
2114             uint256 adjQty = qty;
2115 
2116             if (newQty > FREE_AFTER) {
2117                 adjQty -= (newQty - FREE_AFTER);
2118             }
2119 
2120             cost *= adjQty;
2121         } else {
2122             cost = 0;
2123         }
2124 
2125         require(msg.value == cost, "incorrect eth");
2126         publicAddresses[msg.sender] = newQty;
2127         // qtyMintedForPublic += qty;
2128 
2129         _safeMint(msg.sender, qty);
2130     }
2131 
2132     function finalMint(address to) external onlyOwner nonReentrant {
2133         require(!paused, "paused");
2134         require(mode == Mode.FINAL, "not in final mode");
2135 
2136         uint256 unminted = MAX_QTY - totalSupply();
2137         require(unminted > 0, "reached max qty");
2138 
2139         _safeMint(to, unminted);
2140     }
2141 
2142     function _startTokenId() internal view override virtual returns (uint256) {
2143         return 1;
2144     }
2145 
2146     function _baseURI() internal view virtual override returns (string memory) {
2147         return _tokenBaseURI;
2148     }
2149 
2150     function tokenBaseURI() external view returns (string memory) {
2151         return _tokenBaseURI;
2152     }
2153 
2154     function setTokenBaseURI(string calldata tokenBaseURI_) external onlyOwner {
2155         _tokenBaseURI = tokenBaseURI_;
2156     }
2157 
2158     function tokenURI(uint256 tokenId) public override view returns (string memory) {
2159         require(_exists(tokenId), "nonexistent token");
2160 
2161         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
2162     }
2163 
2164     function setAirdropRoot(bytes32 airdropRoot_) external onlyOwner
2165     {
2166         airdropRoot = airdropRoot_;
2167     }
2168 
2169     function setClaimSigner(address claimSigner_) external onlyOwner
2170     {
2171         claimSigner = claimSigner_;
2172     }
2173 
2174     function setPresaleSigner(address presaleSigner_) external onlyOwner
2175     {
2176         presaleSigner = presaleSigner_;
2177     }
2178 
2179     function setPaused(bool paused_) external onlyOwner {
2180         paused = paused_;
2181     }
2182 
2183     function setPresalePrice(uint256 presalePrice_) external onlyOwner {
2184         presalePrice = presalePrice_;
2185     }
2186 
2187     function setPublicPrice(uint256 publicPrice_) external onlyOwner {
2188         publicPrice = publicPrice_;
2189     }
2190 
2191     function withdraw() external onlyOwner {
2192         uint256 totalBalance = address(this).balance;
2193         require(totalBalance > 0, "no balance");
2194 
2195         uint256 balanceA = totalBalance * 30 / 100;
2196         (bool success, ) = payable(0x2e04434e79Bc456c06F3E6e60143bEe69b7b0c43)
2197             .call{value: balanceA }("");
2198         require(success, "failed transfer");
2199 
2200         (success, ) = payable(owner()).call{value: totalBalance - balanceA}("");
2201         require(success, "failed transfer");
2202     }
2203 
2204     function setMode(Mode mode_) external onlyOwner {
2205         mode = mode_;
2206     }
2207 }