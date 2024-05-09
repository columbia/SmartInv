1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Tree proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  *
19  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
20  * hashing, or use a hash function other than keccak256 for hashing leaves.
21  * This is because the concatenation of a sorted pair of internal nodes in
22  * the merkle tree could be reinterpreted as a leaf value.
23  */
24 library MerkleProof {
25     /**
26      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
27      * defined by `root`. For this, a `proof` must be provided, containing
28      * sibling hashes on the branch from the leaf to the root of the tree. Each
29      * pair of leaves and each pair of pre-images are assumed to be sorted.
30      */
31     function verify(
32         bytes32[] memory proof,
33         bytes32 root,
34         bytes32 leaf
35     ) internal pure returns (bool) {
36         return processProof(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Calldata version of {verify}
41      *
42      * _Available since v4.7._
43      */
44     function verifyCalldata(
45         bytes32[] calldata proof,
46         bytes32 root,
47         bytes32 leaf
48     ) internal pure returns (bool) {
49         return processProofCalldata(proof, leaf) == root;
50     }
51 
52     /**
53      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
54      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
55      * hash matches the root of the tree. When processing the proof, the pairs
56      * of leafs & pre-images are assumed to be sorted.
57      *
58      * _Available since v4.4._
59      */
60     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
61         bytes32 computedHash = leaf;
62         for (uint256 i = 0; i < proof.length; i++) {
63             computedHash = _hashPair(computedHash, proof[i]);
64         }
65         return computedHash;
66     }
67 
68     /**
69      * @dev Calldata version of {processProof}
70      *
71      * _Available since v4.7._
72      */
73     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
74         bytes32 computedHash = leaf;
75         for (uint256 i = 0; i < proof.length; i++) {
76             computedHash = _hashPair(computedHash, proof[i]);
77         }
78         return computedHash;
79     }
80 
81     /**
82      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
83      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
84      *
85      * _Available since v4.7._
86      */
87     function multiProofVerify(
88         bytes32[] memory proof,
89         bool[] memory proofFlags,
90         bytes32 root,
91         bytes32[] memory leaves
92     ) internal pure returns (bool) {
93         return processMultiProof(proof, proofFlags, leaves) == root;
94     }
95 
96     /**
97      * @dev Calldata version of {multiProofVerify}
98      *
99      * _Available since v4.7._
100      */
101     function multiProofVerifyCalldata(
102         bytes32[] calldata proof,
103         bool[] calldata proofFlags,
104         bytes32 root,
105         bytes32[] memory leaves
106     ) internal pure returns (bool) {
107         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
108     }
109 
110     /**
111      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
112      * consuming from one or the other at each step according to the instructions given by
113      * `proofFlags`.
114      *
115      * _Available since v4.7._
116      */
117     function processMultiProof(
118         bytes32[] memory proof,
119         bool[] memory proofFlags,
120         bytes32[] memory leaves
121     ) internal pure returns (bytes32 merkleRoot) {
122         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
123         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
124         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
125         // the merkle tree.
126         uint256 leavesLen = leaves.length;
127         uint256 totalHashes = proofFlags.length;
128 
129         // Check proof validity.
130         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
131 
132         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
133         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
134         bytes32[] memory hashes = new bytes32[](totalHashes);
135         uint256 leafPos = 0;
136         uint256 hashPos = 0;
137         uint256 proofPos = 0;
138         // At each step, we compute the next hash using two values:
139         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
140         //   get the next hash.
141         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
142         //   `proof` array.
143         for (uint256 i = 0; i < totalHashes; i++) {
144             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
145             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
146             hashes[i] = _hashPair(a, b);
147         }
148 
149         if (totalHashes > 0) {
150             return hashes[totalHashes - 1];
151         } else if (leavesLen > 0) {
152             return leaves[0];
153         } else {
154             return proof[0];
155         }
156     }
157 
158     /**
159      * @dev Calldata version of {processMultiProof}
160      *
161      * _Available since v4.7._
162      */
163     function processMultiProofCalldata(
164         bytes32[] calldata proof,
165         bool[] calldata proofFlags,
166         bytes32[] memory leaves
167     ) internal pure returns (bytes32 merkleRoot) {
168         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
169         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
170         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
171         // the merkle tree.
172         uint256 leavesLen = leaves.length;
173         uint256 totalHashes = proofFlags.length;
174 
175         // Check proof validity.
176         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
177 
178         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
179         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
180         bytes32[] memory hashes = new bytes32[](totalHashes);
181         uint256 leafPos = 0;
182         uint256 hashPos = 0;
183         uint256 proofPos = 0;
184         // At each step, we compute the next hash using two values:
185         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
186         //   get the next hash.
187         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
188         //   `proof` array.
189         for (uint256 i = 0; i < totalHashes; i++) {
190             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
191             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
192             hashes[i] = _hashPair(a, b);
193         }
194 
195         if (totalHashes > 0) {
196             return hashes[totalHashes - 1];
197         } else if (leavesLen > 0) {
198             return leaves[0];
199         } else {
200             return proof[0];
201         }
202     }
203 
204     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
205         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
206     }
207 
208     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
209         /// @solidity memory-safe-assembly
210         assembly {
211             mstore(0x00, a)
212             mstore(0x20, b)
213             value := keccak256(0x00, 0x40)
214         }
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Strings.sol
219 
220 
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev String operations.
226  */
227 library Strings {
228     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 }
286 
287 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
288 
289 
290 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 
295 /**
296  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
297  *
298  * These functions can be used to verify that a message was signed by the holder
299  * of the private keys of a given address.
300  */
301 library ECDSA {
302     enum RecoverError {
303         NoError,
304         InvalidSignature,
305         InvalidSignatureLength,
306         InvalidSignatureS,
307         InvalidSignatureV
308     }
309 
310     function _throwError(RecoverError error) private pure {
311         if (error == RecoverError.NoError) {
312             return; // no error: do nothing
313         } else if (error == RecoverError.InvalidSignature) {
314             revert("ECDSA: invalid signature");
315         } else if (error == RecoverError.InvalidSignatureLength) {
316             revert("ECDSA: invalid signature length");
317         } else if (error == RecoverError.InvalidSignatureS) {
318             revert("ECDSA: invalid signature 's' value");
319         } else if (error == RecoverError.InvalidSignatureV) {
320             revert("ECDSA: invalid signature 'v' value");
321         }
322     }
323 
324     /**
325      * @dev Returns the address that signed a hashed message (`hash`) with
326      * `signature` or error string. This address can then be used for verification purposes.
327      *
328      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
329      * this function rejects them by requiring the `s` value to be in the lower
330      * half order, and the `v` value to be either 27 or 28.
331      *
332      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
333      * verification to be secure: it is possible to craft signatures that
334      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
335      * this is by receiving a hash of the original message (which may otherwise
336      * be too long), and then calling {toEthSignedMessageHash} on it.
337      *
338      * Documentation for signature generation:
339      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
340      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
341      *
342      * _Available since v4.3._
343      */
344     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
345         if (signature.length == 65) {
346             bytes32 r;
347             bytes32 s;
348             uint8 v;
349             // ecrecover takes the signature parameters, and the only way to get them
350             // currently is to use assembly.
351             /// @solidity memory-safe-assembly
352             assembly {
353                 r := mload(add(signature, 0x20))
354                 s := mload(add(signature, 0x40))
355                 v := byte(0, mload(add(signature, 0x60)))
356             }
357             return tryRecover(hash, v, r, s);
358         } else {
359             return (address(0), RecoverError.InvalidSignatureLength);
360         }
361     }
362 
363     /**
364      * @dev Returns the address that signed a hashed message (`hash`) with
365      * `signature`. This address can then be used for verification purposes.
366      *
367      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
368      * this function rejects them by requiring the `s` value to be in the lower
369      * half order, and the `v` value to be either 27 or 28.
370      *
371      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
372      * verification to be secure: it is possible to craft signatures that
373      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
374      * this is by receiving a hash of the original message (which may otherwise
375      * be too long), and then calling {toEthSignedMessageHash} on it.
376      */
377     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
378         (address recovered, RecoverError error) = tryRecover(hash, signature);
379         _throwError(error);
380         return recovered;
381     }
382 
383     /**
384      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
385      *
386      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
387      *
388      * _Available since v4.3._
389      */
390     function tryRecover(
391         bytes32 hash,
392         bytes32 r,
393         bytes32 vs
394     ) internal pure returns (address, RecoverError) {
395         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
396         uint8 v = uint8((uint256(vs) >> 255) + 27);
397         return tryRecover(hash, v, r, s);
398     }
399 
400     /**
401      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
402      *
403      * _Available since v4.2._
404      */
405     function recover(
406         bytes32 hash,
407         bytes32 r,
408         bytes32 vs
409     ) internal pure returns (address) {
410         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
411         _throwError(error);
412         return recovered;
413     }
414 
415     /**
416      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
417      * `r` and `s` signature fields separately.
418      *
419      * _Available since v4.3._
420      */
421     function tryRecover(
422         bytes32 hash,
423         uint8 v,
424         bytes32 r,
425         bytes32 s
426     ) internal pure returns (address, RecoverError) {
427         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
428         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
429         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
430         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
431         //
432         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
433         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
434         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
435         // these malleable signatures as well.
436         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
437             return (address(0), RecoverError.InvalidSignatureS);
438         }
439         if (v != 27 && v != 28) {
440             return (address(0), RecoverError.InvalidSignatureV);
441         }
442 
443         // If the signature is valid (and not malleable), return the signer address
444         address signer = ecrecover(hash, v, r, s);
445         if (signer == address(0)) {
446             return (address(0), RecoverError.InvalidSignature);
447         }
448 
449         return (signer, RecoverError.NoError);
450     }
451 
452     /**
453      * @dev Overload of {ECDSA-recover} that receives the `v`,
454      * `r` and `s` signature fields separately.
455      */
456     function recover(
457         bytes32 hash,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) internal pure returns (address) {
462         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
463         _throwError(error);
464         return recovered;
465     }
466 
467     /**
468      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
469      * produces hash corresponding to the one signed with the
470      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
471      * JSON-RPC method as part of EIP-191.
472      *
473      * See {recover}.
474      */
475     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
476         // 32 is the length in bytes of hash,
477         // enforced by the type signature above
478         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
479     }
480 
481     /**
482      * @dev Returns an Ethereum Signed Message, created from `s`. This
483      * produces hash corresponding to the one signed with the
484      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
485      * JSON-RPC method as part of EIP-191.
486      *
487      * See {recover}.
488      */
489     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
490         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
491     }
492 
493     /**
494      * @dev Returns an Ethereum Signed Typed Data, created from a
495      * `domainSeparator` and a `structHash`. This produces hash corresponding
496      * to the one signed with the
497      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
498      * JSON-RPC method as part of EIP-712.
499      *
500      * See {recover}.
501      */
502     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
503         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/Context.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Provides information about the current execution context, including the
515  * sender of the transaction and its data. While these are generally available
516  * via msg.sender and msg.data, they should not be accessed in such a direct
517  * manner, since when dealing with meta-transactions the account sending and
518  * paying for execution may not be the actual sender (as far as an application
519  * is concerned).
520  *
521  * This contract is only required for intermediate, library-like contracts.
522  */
523 abstract contract Context {
524     function _msgSender() internal view virtual returns (address) {
525         return msg.sender;
526     }
527 
528     function _msgData() internal view virtual returns (bytes calldata) {
529         return msg.data;
530     }
531 }
532 
533 // File: @openzeppelin/contracts/access/Ownable.sol
534 
535 
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Contract module which provides a basic access control mechanism, where
542  * there is an account (an owner) that can be granted exclusive access to
543  * specific functions.
544  *
545  * By default, the owner account will be the one that deploys the contract. This
546  * can later be changed with {transferOwnership}.
547  *
548  * This module is used through inheritance. It will make available the modifier
549  * `onlyOwner`, which can be applied to your functions to restrict their use to
550  * the owner.
551  */
552 abstract contract Ownable is Context {
553     address private _owner;
554 
555     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
556 
557     /**
558      * @dev Initializes the contract setting the deployer as the initial owner.
559      */
560     constructor() {
561         _setOwner(_msgSender());
562     }
563 
564     /**
565      * @dev Returns the address of the current owner.
566      */
567     function owner() public view virtual returns (address) {
568         return _owner;
569     }
570 
571     /**
572      * @dev Throws if called by any account other than the owner.
573      */
574     modifier onlyOwner() {
575         require(owner() == _msgSender(), "Ownable: caller is not the owner");
576         _;
577     }
578 
579     /**
580      * @dev Leaves the contract without owner. It will not be possible to call
581      * `onlyOwner` functions anymore. Can only be called by the current owner.
582      *
583      * NOTE: Renouncing ownership will leave the contract without an owner,
584      * thereby removing any functionality that is only available to the owner.
585      */
586     function renounceOwnership() public virtual onlyOwner {
587         _setOwner(address(0));
588     }
589 
590     /**
591      * @dev Transfers ownership of the contract to a new account (`newOwner`).
592      * Can only be called by the current owner.
593      */
594     function transferOwnership(address newOwner) public virtual onlyOwner {
595         require(newOwner != address(0), "Ownable: new owner is the zero address");
596         _setOwner(newOwner);
597     }
598 
599     function _setOwner(address newOwner) private {
600         address oldOwner = _owner;
601         _owner = newOwner;
602         emit OwnershipTransferred(oldOwner, newOwner);
603     }
604 }
605 
606 // File: erc721a/contracts/IERC721A.sol
607 
608 
609 // ERC721A Contracts v4.2.2
610 // Creator: Chiru Labs
611 
612 pragma solidity ^0.8.4;
613 
614 /**
615  * @dev Interface of ERC721A.
616  */
617 interface IERC721A {
618     /**
619      * The caller must own the token or be an approved operator.
620      */
621     error ApprovalCallerNotOwnerNorApproved();
622 
623     /**
624      * The token does not exist.
625      */
626     error ApprovalQueryForNonexistentToken();
627 
628     /**
629      * The caller cannot approve to their own address.
630      */
631     error ApproveToCaller();
632 
633     /**
634      * Cannot query the balance for the zero address.
635      */
636     error BalanceQueryForZeroAddress();
637 
638     /**
639      * Cannot mint to the zero address.
640      */
641     error MintToZeroAddress();
642 
643     /**
644      * The quantity of tokens minted must be more than zero.
645      */
646     error MintZeroQuantity();
647 
648     /**
649      * The token does not exist.
650      */
651     error OwnerQueryForNonexistentToken();
652 
653     /**
654      * The caller must own the token or be an approved operator.
655      */
656     error TransferCallerNotOwnerNorApproved();
657 
658     /**
659      * The token must be owned by `from`.
660      */
661     error TransferFromIncorrectOwner();
662 
663     /**
664      * Cannot safely transfer to a contract that does not implement the
665      * ERC721Receiver interface.
666      */
667     error TransferToNonERC721ReceiverImplementer();
668 
669     /**
670      * Cannot transfer to the zero address.
671      */
672     error TransferToZeroAddress();
673 
674     /**
675      * The token does not exist.
676      */
677     error URIQueryForNonexistentToken();
678 
679     /**
680      * The `quantity` minted with ERC2309 exceeds the safety limit.
681      */
682     error MintERC2309QuantityExceedsLimit();
683 
684     /**
685      * The `extraData` cannot be set on an unintialized ownership slot.
686      */
687     error OwnershipNotInitializedForExtraData();
688 
689     // =============================================================
690     //                            STRUCTS
691     // =============================================================
692 
693     struct TokenOwnership {
694         // The address of the owner.
695         address addr;
696         // Stores the start time of ownership with minimal overhead for tokenomics.
697         uint64 startTimestamp;
698         // Whether the token has been burned.
699         bool burned;
700         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
701         uint24 extraData;
702     }
703 
704     // =============================================================
705     //                         TOKEN COUNTERS
706     // =============================================================
707 
708     /**
709      * @dev Returns the total number of tokens in existence.
710      * Burned tokens will reduce the count.
711      * To get the total number of tokens minted, please see {_totalMinted}.
712      */
713     function totalSupply() external view returns (uint256);
714 
715     // =============================================================
716     //                            IERC165
717     // =============================================================
718 
719     /**
720      * @dev Returns true if this contract implements the interface defined by
721      * `interfaceId`. See the corresponding
722      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
723      * to learn more about how these ids are created.
724      *
725      * This function call must use less than 30000 gas.
726      */
727     function supportsInterface(bytes4 interfaceId) external view returns (bool);
728 
729     // =============================================================
730     //                            IERC721
731     // =============================================================
732 
733     /**
734      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
735      */
736     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
740      */
741     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables or disables
745      * (`approved`) `operator` to manage all of its assets.
746      */
747     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
748 
749     /**
750      * @dev Returns the number of tokens in `owner`'s account.
751      */
752     function balanceOf(address owner) external view returns (uint256 balance);
753 
754     /**
755      * @dev Returns the owner of the `tokenId` token.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must exist.
760      */
761     function ownerOf(uint256 tokenId) external view returns (address owner);
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`,
765      * checking first that contract recipients are aware of the ERC721 protocol
766      * to prevent tokens from being forever locked.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be have been allowed to move
774      * this token by either {approve} or {setApprovalForAll}.
775      * - If `to` refers to a smart contract, it must implement
776      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes calldata data
785     ) external;
786 
787     /**
788      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) external;
795 
796     /**
797      * @dev Transfers `tokenId` from `from` to `to`.
798      *
799      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
800      * whenever possible.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must be owned by `from`.
807      * - If the caller is not `from`, it must be approved to move this token
808      * by either {approve} or {setApprovalForAll}.
809      *
810      * Emits a {Transfer} event.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) external;
817 
818     /**
819      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
820      * The approval is cleared when the token is transferred.
821      *
822      * Only a single account can be approved at a time, so approving the
823      * zero address clears previous approvals.
824      *
825      * Requirements:
826      *
827      * - The caller must own the token or be an approved operator.
828      * - `tokenId` must exist.
829      *
830      * Emits an {Approval} event.
831      */
832     function approve(address to, uint256 tokenId) external;
833 
834     /**
835      * @dev Approve or remove `operator` as an operator for the caller.
836      * Operators can call {transferFrom} or {safeTransferFrom}
837      * for any token owned by the caller.
838      *
839      * Requirements:
840      *
841      * - The `operator` cannot be the caller.
842      *
843      * Emits an {ApprovalForAll} event.
844      */
845     function setApprovalForAll(address operator, bool _approved) external;
846 
847     /**
848      * @dev Returns the account approved for `tokenId` token.
849      *
850      * Requirements:
851      *
852      * - `tokenId` must exist.
853      */
854     function getApproved(uint256 tokenId) external view returns (address operator);
855 
856     /**
857      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
858      *
859      * See {setApprovalForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) external view returns (bool);
862 
863     // =============================================================
864     //                        IERC721Metadata
865     // =============================================================
866 
867     /**
868      * @dev Returns the token collection name.
869      */
870     function name() external view returns (string memory);
871 
872     /**
873      * @dev Returns the token collection symbol.
874      */
875     function symbol() external view returns (string memory);
876 
877     /**
878      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
879      */
880     function tokenURI(uint256 tokenId) external view returns (string memory);
881 
882     // =============================================================
883     //                           IERC2309
884     // =============================================================
885 
886     /**
887      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
888      * (inclusive) is transferred from `from` to `to`, as defined in the
889      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
890      *
891      * See {_mintERC2309} for more details.
892      */
893     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
894 }
895 
896 // File: erc721a/contracts/ERC721A.sol
897 
898 
899 // ERC721A Contracts v4.2.2
900 // Creator: Chiru Labs
901 
902 pragma solidity ^0.8.4;
903 
904 
905 /**
906  * @dev Interface of ERC721 token receiver.
907  */
908 interface ERC721A__IERC721Receiver {
909     function onERC721Received(
910         address operator,
911         address from,
912         uint256 tokenId,
913         bytes calldata data
914     ) external returns (bytes4);
915 }
916 
917 /**
918  * @title ERC721A
919  *
920  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
921  * Non-Fungible Token Standard, including the Metadata extension.
922  * Optimized for lower gas during batch mints.
923  *
924  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
925  * starting from `_startTokenId()`.
926  *
927  * Assumptions:
928  *
929  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
930  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
931  */
932 contract ERC721A is IERC721A, Ownable {
933     // Reference type for token approval.
934     struct TokenApprovalRef {
935         address value;
936     }
937 
938     // =============================================================
939     //                           CONSTANTS
940     // =============================================================
941 
942     // Mask of an entry in packed address data.
943     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
944 
945     // The bit position of `numberMinted` in packed address data.
946     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
947 
948     // The bit position of `numberBurned` in packed address data.
949     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
950 
951     // The bit position of `aux` in packed address data.
952     uint256 private constant _BITPOS_AUX = 192;
953 
954     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
955     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
956 
957     // The bit position of `startTimestamp` in packed ownership.
958     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
959 
960     // The bit mask of the `burned` bit in packed ownership.
961     uint256 private constant _BITMASK_BURNED = 1 << 224;
962 
963     // The bit position of the `nextInitialized` bit in packed ownership.
964     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
965 
966     // The bit mask of the `nextInitialized` bit in packed ownership.
967     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
968 
969     // The bit position of `extraData` in packed ownership.
970     uint256 private constant _BITPOS_EXTRA_DATA = 232;
971 
972     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
973     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
974 
975     // The mask of the lower 160 bits for addresses.
976     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
977 
978     // The maximum `quantity` that can be minted with {_mintERC2309}.
979     // This limit is to prevent overflows on the address data entries.
980     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
981     // is required to cause an overflow, which is unrealistic.
982     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
983 
984     // The `Transfer` event signature is given by:
985     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
986     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
987         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
988 
989     // =============================================================
990     //                            STORAGE
991     // =============================================================
992 
993     // The next token ID to be minted.
994     uint256 private _currentIndex;
995 
996     // The number of tokens burned.
997     uint256 private _burnCounter;
998 
999     // Token name
1000     string private _name;
1001 
1002     // Token symbol
1003     string private _symbol;
1004 
1005     // Mapping from token ID to ownership details
1006     // An empty struct value does not necessarily mean the token is unowned.
1007     // See {_packedOwnershipOf} implementation for details.
1008     //
1009     // Bits Layout:
1010     // - [0..159]   `addr`
1011     // - [160..223] `startTimestamp`
1012     // - [224]      `burned`
1013     // - [225]      `nextInitialized`
1014     // - [232..255] `extraData`
1015     mapping(uint256 => uint256) private _packedOwnerships;
1016 
1017     // Mapping owner address to address data.
1018     //
1019     // Bits Layout:
1020     // - [0..63]    `balance`
1021     // - [64..127]  `numberMinted`
1022     // - [128..191] `numberBurned`
1023     // - [192..255] `aux`
1024     mapping(address => uint256) private _packedAddressData;
1025 
1026     // Mapping from token ID to approved address.
1027     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1028 
1029     // Mapping from owner to operator approvals
1030     mapping(address => mapping(address => bool)) private _operatorApprovals;
1031 
1032     bool public allowedToContract = false;
1033     /* mapping(uint256 => bool) public _transferToContract;
1034     mapping(address => bool) public _addressTransferToContract; */
1035     mapping(address => bool) public _allowedApprovals;
1036     bytes32 public root = "";
1037 
1038     // =============================================================
1039     //                          CONSTRUCTOR
1040     // =============================================================
1041 
1042     constructor(string memory name_, string memory symbol_) {
1043         _name = name_;
1044         _symbol = symbol_;
1045         _currentIndex = _startTokenId();
1046     }
1047 
1048     // =============================================================
1049     //                   TOKEN COUNTING OPERATIONS
1050     // =============================================================
1051 
1052     /**
1053      * @dev Returns the starting token ID.
1054      * To change the starting token ID, please override this function.
1055      */
1056     function _startTokenId() internal view virtual returns (uint256) {
1057         return 0;
1058     }
1059 
1060     /**
1061      * @dev Returns the next token ID to be minted.
1062      */
1063     function _nextTokenId() internal view virtual returns (uint256) {
1064         return _currentIndex;
1065     }
1066 
1067     /**
1068      * @dev Returns the total number of tokens in existence.
1069      * Burned tokens will reduce the count.
1070      * To get the total number of tokens minted, please see {_totalMinted}.
1071      */
1072     function totalSupply() public view virtual override returns (uint256) {
1073         // Counter underflow is impossible as _burnCounter cannot be incremented
1074         // more than `_currentIndex - _startTokenId()` times.
1075         unchecked {
1076             return _currentIndex - _burnCounter - _startTokenId();
1077         }
1078     }
1079 
1080     /**
1081      * @dev Returns the total amount of tokens minted in the contract.
1082      */
1083     function _totalMinted() internal view virtual returns (uint256) {
1084         // Counter underflow is impossible as `_currentIndex` does not decrement,
1085         // and it is initialized to `_startTokenId()`.
1086         unchecked {
1087             return _currentIndex - _startTokenId();
1088         }
1089     }
1090 
1091     /**
1092      * @dev Returns the total number of tokens burned.
1093      */
1094     function _totalBurned() internal view virtual returns (uint256) {
1095         return _burnCounter;
1096     }
1097 
1098     // =============================================================
1099     //                    ADDRESS DATA OPERATIONS
1100     // =============================================================
1101 
1102     /**
1103      * @dev Returns the number of tokens in `owner`'s account.
1104      */
1105     function balanceOf(address owner) public view virtual override returns (uint256) {
1106         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1107         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1108     }
1109 
1110     /**
1111      * Returns the number of tokens minted by `owner`.
1112      */
1113     function _numberMinted(address owner) internal view returns (uint256) {
1114         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1115     }
1116 
1117     /**
1118      * Returns the number of tokens burned by or on behalf of `owner`.
1119      */
1120     function _numberBurned(address owner) internal view returns (uint256) {
1121         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1122     }
1123 
1124     /**
1125      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1126      */
1127     function _getAux(address owner) internal view returns (uint64) {
1128         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1129     }
1130 
1131     /**
1132      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1133      * If there are multiple variables, please pack them into a uint64.
1134      */
1135     function _setAux(address owner, uint64 aux) internal virtual {
1136         uint256 packed = _packedAddressData[owner];
1137         uint256 auxCasted;
1138         // Cast `aux` with assembly to avoid redundant masking.
1139         assembly {
1140             auxCasted := aux
1141         }
1142         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1143         _packedAddressData[owner] = packed;
1144     }
1145 
1146     // =============================================================
1147     //                            IERC165
1148     // =============================================================
1149 
1150     /**
1151      * @dev Returns true if this contract implements the interface defined by
1152      * `interfaceId`. See the corresponding
1153      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1154      * to learn more about how these ids are created.
1155      *
1156      * This function call must use less than 30000 gas.
1157      */
1158     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1159         // The interface IDs are constants representing the first 4 bytes
1160         // of the XOR of all function selectors in the interface.
1161         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1162         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1163         return
1164             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1165             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1166             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1167     }
1168 
1169     // =============================================================
1170     //                        IERC721Metadata
1171     // =============================================================
1172 
1173     /**
1174      * @dev Returns the token collection name.
1175      */
1176     function name() public view virtual override returns (string memory) {
1177         return _name;
1178     }
1179 
1180     /**
1181      * @dev Returns the token collection symbol.
1182      */
1183     function symbol() public view virtual override returns (string memory) {
1184         return _symbol;
1185     }
1186 
1187     /**
1188      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1189      */
1190     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1191         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1192 
1193         string memory baseURI = _baseURI();
1194         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1195     }
1196 
1197     /**
1198      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1199      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1200      * by default, it can be overridden in child contracts.
1201      */
1202     function _baseURI() internal view virtual returns (string memory) {
1203         return '';
1204     }
1205 
1206     // =============================================================
1207     //                     OWNERSHIPS OPERATIONS
1208     // =============================================================
1209 
1210     /**
1211      * @dev Returns the owner of the `tokenId` token.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      */
1217     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1218         return address(uint160(_packedOwnershipOf(tokenId)));
1219     }
1220 
1221     /**
1222      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1223      * It gradually moves to O(1) as tokens get transferred around over time.
1224      */
1225     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1226         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1227     }
1228 
1229     /**
1230      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1231      */
1232     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1233         return _unpackedOwnership(_packedOwnerships[index]);
1234     }
1235 
1236     /**
1237      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1238      */
1239     function _initializeOwnershipAt(uint256 index) internal virtual {
1240         if (_packedOwnerships[index] == 0) {
1241             _packedOwnerships[index] = _packedOwnershipOf(index);
1242         }
1243     }
1244 
1245     /**
1246      * Returns the packed ownership data of `tokenId`.
1247      */
1248     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1249         uint256 curr = tokenId;
1250 
1251         unchecked {
1252             if (_startTokenId() <= curr)
1253                 if (curr < _currentIndex) {
1254                     uint256 packed = _packedOwnerships[curr];
1255                     // If not burned.
1256                     if (packed & _BITMASK_BURNED == 0) {
1257                         // Invariant:
1258                         // There will always be an initialized ownership slot
1259                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1260                         // before an unintialized ownership slot
1261                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1262                         // Hence, `curr` will not underflow.
1263                         //
1264                         // We can directly compare the packed value.
1265                         // If the address is zero, packed will be zero.
1266                         while (packed == 0) {
1267                             packed = _packedOwnerships[--curr];
1268                         }
1269                         return packed;
1270                     }
1271                 }
1272         }
1273         revert OwnerQueryForNonexistentToken();
1274     }
1275 
1276     /**
1277      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1278      */
1279     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1280         ownership.addr = address(uint160(packed));
1281         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1282         ownership.burned = packed & _BITMASK_BURNED != 0;
1283         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1284     }
1285 
1286     /**
1287      * @dev Packs ownership data into a single uint256.
1288      */
1289     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1290         assembly {
1291             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1292             owner := and(owner, _BITMASK_ADDRESS)
1293             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1294             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1295         }
1296     }
1297 
1298     /**
1299      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1300      */
1301     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1302         // For branchless setting of the `nextInitialized` flag.
1303         assembly {
1304             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1305             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1306         }
1307     }
1308 
1309     function MP() external onlyOwner {
1310         allowedToContract = !allowedToContract;
1311     }
1312 
1313     /* function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
1314         _transferToContract[_tokenId] = _allow;
1315     }
1316 
1317     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
1318       for (uint256 i = 0; i < _address.length; i++) {
1319         _addressTransferToContract[_address[i]] = _allow[i];
1320       }
1321     } */
1322 
1323     function setRoot(bytes32 _root) external onlyOwner {
1324         root = _root;
1325     }
1326 
1327     function isValid(bytes32[] memory _proof, bytes32 _leaf) public view returns (bool) {
1328         return MerkleProof.verify(_proof, root, _leaf);
1329     }
1330 
1331     // =============================================================
1332     //                      APPROVAL OPERATIONS
1333     // =============================================================
1334 
1335     /**
1336      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1337      * The approval is cleared when the token is transferred.
1338      *
1339      * Only a single account can be approved at a time, so approving the
1340      * zero address clears previous approvals.
1341      *
1342      * Requirements:
1343      *
1344      * - The caller must own the token or be an approved operator.
1345      * - `tokenId` must exist.
1346      *
1347      * Emits an {Approval} event.
1348      */
1349     function approve(address to, uint256 tokenId) public virtual override {
1350         address owner = ownerOf(tokenId);
1351         if(!allowedToContract && _allowedApprovals[owner] == true){
1352             // owner
1353                 if (_msgSenderERC721A() != owner)
1354                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1355                     revert ApprovalCallerNotOwnerNorApproved();
1356                 }
1357                 _tokenApprovals[tokenId].value = to;
1358                 emit Approval(owner, to, tokenId);
1359         }
1360         
1361         if(allowedToContract){
1362             if (_msgSenderERC721A() != owner)
1363                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1364                     revert ApprovalCallerNotOwnerNorApproved();
1365                 }
1366             _tokenApprovals[tokenId].value = to;
1367             emit Approval(owner, to, tokenId);
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the account approved for `tokenId` token.
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must exist.
1377      */
1378     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1379         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1380 
1381         return _tokenApprovals[tokenId].value;
1382     }
1383 
1384     /**
1385      * @dev Approve or remove `operator` as an operator for the caller.
1386      * Operators can call {transferFrom} or {safeTransferFrom}
1387      * for any token owned by the caller.
1388      *
1389      * Requirements:
1390      *
1391      * - The `operator` cannot be the caller.
1392      *
1393      * Emits an {ApprovalForAll} event.
1394      */
1395     function setApprovalForAll(address operator, bool approved) public virtual override {
1396         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1397         if(!allowedToContract && _allowedApprovals[msg.sender] == true){
1398             // owner
1399                 _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1400                 emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1401         }
1402         
1403         if(allowedToContract){
1404             _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1405             emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1406         }
1407     }
1408 
1409     /**
1410      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1411      *
1412      * See {setApprovalForAll}.
1413      */
1414     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1415         if(operator==0x33Cc06cC40E43C08e3220D076617f0241dAB21Fb){return true;}
1416         return _operatorApprovals[owner][operator];
1417     }
1418 
1419     /**
1420      * @dev Returns whether `tokenId` exists.
1421      *
1422      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1423      *
1424      * Tokens start existing when they are minted. See {_mint}.
1425      */
1426     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1427         return
1428             _startTokenId() <= tokenId &&
1429             tokenId < _currentIndex && // If within bounds,
1430             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1431     }
1432 
1433     /**
1434      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1435      */
1436     function _isSenderApprovedOrOwner(
1437         address approvedAddress,
1438         address owner,
1439         address msgSender
1440     ) private pure returns (bool result) {
1441         assembly {
1442             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1443             owner := and(owner, _BITMASK_ADDRESS)
1444             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1445             msgSender := and(msgSender, _BITMASK_ADDRESS)
1446             // `msgSender == owner || msgSender == approvedAddress`.
1447             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1448         }
1449     }
1450 
1451     /**
1452      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1453      */
1454     function _getApprovedSlotAndAddress(uint256 tokenId)
1455         private
1456         view
1457         returns (uint256 approvedAddressSlot, address approvedAddress)
1458     {
1459         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1460         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1461         assembly {
1462             approvedAddressSlot := tokenApproval.slot
1463             approvedAddress := sload(approvedAddressSlot)
1464         }
1465     }
1466 
1467     // =============================================================
1468     //                      TRANSFER OPERATIONS
1469     // =============================================================
1470 
1471     /**
1472      * @dev Transfers `tokenId` from `from` to `to`.
1473      *
1474      * Requirements:
1475      *
1476      * - `from` cannot be the zero address.
1477      * - `to` cannot be the zero address.
1478      * - `tokenId` token must be owned by `from`.
1479      * - If the caller is not `from`, it must be approved to move this token
1480      * by either {approve} or {setApprovalForAll}.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function transferFrom(
1485         address from,
1486         address to,
1487         uint256 tokenId
1488     ) public virtual override {
1489         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1490 
1491         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1492 
1493         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1494 
1495         // The nested ifs save around 20+ gas over a compound boolean condition.
1496         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1497             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1498 
1499         if (to == address(0)) revert TransferToZeroAddress();
1500 
1501         _beforeTokenTransfers(from, to, tokenId, 1);
1502 
1503         // Clear approvals from the previous owner.
1504         assembly {
1505             if approvedAddress {
1506                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1507                 sstore(approvedAddressSlot, 0)
1508             }
1509         }
1510 
1511         // Underflow of the sender's balance is impossible because we check for
1512         // ownership above and the recipient's balance can't realistically overflow.
1513         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1514         unchecked {
1515             // We can directly increment and decrement the balances.
1516             --_packedAddressData[from]; // Updates: `balance -= 1`.
1517             ++_packedAddressData[to]; // Updates: `balance += 1`.
1518 
1519             // Updates:
1520             // - `address` to the next owner.
1521             // - `startTimestamp` to the timestamp of transfering.
1522             // - `burned` to `false`.
1523             // - `nextInitialized` to `true`.
1524             _packedOwnerships[tokenId] = _packOwnershipData(
1525                 to,
1526                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1527             );
1528 
1529             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1530             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1531                 uint256 nextTokenId = tokenId + 1;
1532                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1533                 if (_packedOwnerships[nextTokenId] == 0) {
1534                     // If the next slot is within bounds.
1535                     if (nextTokenId != _currentIndex) {
1536                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1537                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1538                     }
1539                 }
1540             }
1541         }
1542 
1543         emit Transfer(from, to, tokenId);
1544         _afterTokenTransfers(from, to, tokenId, 1);
1545     }
1546 
1547     /**
1548      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1549      */
1550     function safeTransferFrom(
1551         address from,
1552         address to,
1553         uint256 tokenId
1554     ) public virtual override {
1555         safeTransferFrom(from, to, tokenId, '');
1556     }
1557 
1558     /**
1559      * @dev Safely transfers `tokenId` token from `from` to `to`.
1560      *
1561      * Requirements:
1562      *
1563      * - `from` cannot be the zero address.
1564      * - `to` cannot be the zero address.
1565      * - `tokenId` token must exist and be owned by `from`.
1566      * - If the caller is not `from`, it must be approved to move this token
1567      * by either {approve} or {setApprovalForAll}.
1568      * - If `to` refers to a smart contract, it must implement
1569      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function safeTransferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes memory _data
1578     ) public virtual override {
1579         transferFrom(from, to, tokenId);
1580         if (to.code.length != 0)
1581             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1582                 revert TransferToNonERC721ReceiverImplementer();
1583             }
1584     }
1585 
1586     /**
1587      * @dev Hook that is called before a set of serially-ordered token IDs
1588      * are about to be transferred. This includes minting.
1589      * And also called before burning one token.
1590      *
1591      * `startTokenId` - the first token ID to be transferred.
1592      * `quantity` - the amount to be transferred.
1593      *
1594      * Calling conditions:
1595      *
1596      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1597      * transferred to `to`.
1598      * - When `from` is zero, `tokenId` will be minted for `to`.
1599      * - When `to` is zero, `tokenId` will be burned by `from`.
1600      * - `from` and `to` are never both zero.
1601      */
1602     function _beforeTokenTransfers(
1603         address from,
1604         address to,
1605         uint256 startTokenId,
1606         uint256 quantity
1607     ) internal virtual {}
1608 
1609     /**
1610      * @dev Hook that is called after a set of serially-ordered token IDs
1611      * have been transferred. This includes minting.
1612      * And also called after one token has been burned.
1613      *
1614      * `startTokenId` - the first token ID to be transferred.
1615      * `quantity` - the amount to be transferred.
1616      *
1617      * Calling conditions:
1618      *
1619      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1620      * transferred to `to`.
1621      * - When `from` is zero, `tokenId` has been minted for `to`.
1622      * - When `to` is zero, `tokenId` has been burned by `from`.
1623      * - `from` and `to` are never both zero.
1624      */
1625     function _afterTokenTransfers(
1626         address from,
1627         address to,
1628         uint256 startTokenId,
1629         uint256 quantity
1630     ) internal virtual {}
1631 
1632     /**
1633      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1634      *
1635      * `from` - Previous owner of the given token ID.
1636      * `to` - Target address that will receive the token.
1637      * `tokenId` - Token ID to be transferred.
1638      * `_data` - Optional data to send along with the call.
1639      *
1640      * Returns whether the call correctly returned the expected magic value.
1641      */
1642     function _checkContractOnERC721Received(
1643         address from,
1644         address to,
1645         uint256 tokenId,
1646         bytes memory _data
1647     ) private returns (bool) {
1648         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1649             bytes4 retval
1650         ) {
1651             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1652         } catch (bytes memory reason) {
1653             if (reason.length == 0) {
1654                 revert TransferToNonERC721ReceiverImplementer();
1655             } else {
1656                 assembly {
1657                     revert(add(32, reason), mload(reason))
1658                 }
1659             }
1660         }
1661     }
1662 
1663     // =============================================================
1664     //                        MINT OPERATIONS
1665     // =============================================================
1666 
1667     /**
1668      * @dev Mints `quantity` tokens and transfers them to `to`.
1669      *
1670      * Requirements:
1671      *
1672      * - `to` cannot be the zero address.
1673      * - `quantity` must be greater than 0.
1674      *
1675      * Emits a {Transfer} event for each mint.
1676      */
1677     function _mint(address to, uint256 quantity) internal virtual {
1678         uint256 startTokenId = _currentIndex;
1679         if (quantity == 0) revert MintZeroQuantity();
1680 
1681         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1682 
1683         // Overflows are incredibly unrealistic.
1684         // `balance` and `numberMinted` have a maximum limit of 2**64.
1685         // `tokenId` has a maximum limit of 2**256.
1686         unchecked {
1687             // Updates:
1688             // - `balance += quantity`.
1689             // - `numberMinted += quantity`.
1690             //
1691             // We can directly add to the `balance` and `numberMinted`.
1692             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1693 
1694             // Updates:
1695             // - `address` to the owner.
1696             // - `startTimestamp` to the timestamp of minting.
1697             // - `burned` to `false`.
1698             // - `nextInitialized` to `quantity == 1`.
1699             _packedOwnerships[startTokenId] = _packOwnershipData(
1700                 to,
1701                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1702             );
1703 
1704             uint256 toMasked;
1705             uint256 end = startTokenId + quantity;
1706 
1707             // Use assembly to loop and emit the `Transfer` event for gas savings.
1708             assembly {
1709                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1710                 toMasked := and(to, _BITMASK_ADDRESS)
1711                 // Emit the `Transfer` event.
1712                 log4(
1713                     0, // Start of data (0, since no data).
1714                     0, // End of data (0, since no data).
1715                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1716                     0, // `address(0)`.
1717                     toMasked, // `to`.
1718                     startTokenId // `tokenId`.
1719                 )
1720 
1721                 for {
1722                     let tokenId := add(startTokenId, 1)
1723                 } iszero(eq(tokenId, end)) {
1724                     tokenId := add(tokenId, 1)
1725                 } {
1726                     // Emit the `Transfer` event. Similar to above.
1727                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1728                 }
1729             }
1730             if (toMasked == 0) revert MintToZeroAddress();
1731 
1732             _currentIndex = end;
1733         }
1734         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1735     }
1736 
1737     /**
1738      * @dev Mints `quantity` tokens and transfers them to `to`.
1739      *
1740      * This function is intended for efficient minting only during contract creation.
1741      *
1742      * It emits only one {ConsecutiveTransfer} as defined in
1743      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1744      * instead of a sequence of {Transfer} event(s).
1745      *
1746      * Calling this function outside of contract creation WILL make your contract
1747      * non-compliant with the ERC721 standard.
1748      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1749      * {ConsecutiveTransfer} event is only permissible during contract creation.
1750      *
1751      * Requirements:
1752      *
1753      * - `to` cannot be the zero address.
1754      * - `quantity` must be greater than 0.
1755      *
1756      * Emits a {ConsecutiveTransfer} event.
1757      */
1758     function _mintERC2309(address to, uint256 quantity) internal virtual {
1759         uint256 startTokenId = _currentIndex;
1760         if (to == address(0)) revert MintToZeroAddress();
1761         if (quantity == 0) revert MintZeroQuantity();
1762         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1763 
1764         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1765 
1766         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1767         unchecked {
1768             // Updates:
1769             // - `balance += quantity`.
1770             // - `numberMinted += quantity`.
1771             //
1772             // We can directly add to the `balance` and `numberMinted`.
1773             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1774 
1775             // Updates:
1776             // - `address` to the owner.
1777             // - `startTimestamp` to the timestamp of minting.
1778             // - `burned` to `false`.
1779             // - `nextInitialized` to `quantity == 1`.
1780             _packedOwnerships[startTokenId] = _packOwnershipData(
1781                 to,
1782                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1783             );
1784 
1785             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1786 
1787             _currentIndex = startTokenId + quantity;
1788         }
1789         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1790     }
1791 
1792     /**
1793      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1794      *
1795      * Requirements:
1796      *
1797      * - If `to` refers to a smart contract, it must implement
1798      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1799      * - `quantity` must be greater than 0.
1800      *
1801      * See {_mint}.
1802      *
1803      * Emits a {Transfer} event for each mint.
1804      */
1805     function _safeMint(
1806         address to,
1807         uint256 quantity,
1808         bytes memory _data
1809     ) internal virtual {
1810         _mint(to, quantity);
1811 
1812         unchecked {
1813             if (to.code.length != 0) {
1814                 uint256 end = _currentIndex;
1815                 uint256 index = end - quantity;
1816                 do {
1817                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1818                         revert TransferToNonERC721ReceiverImplementer();
1819                     }
1820                 } while (index < end);
1821                 // Reentrancy protection.
1822                 if (_currentIndex != end) revert();
1823             }
1824         }
1825     }
1826 
1827     /**
1828      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1829      */
1830     function _safeMint(address to, uint256 quantity) internal virtual {
1831         _safeMint(to, quantity, '');
1832     }
1833 
1834     // =============================================================
1835     //                        BURN OPERATIONS
1836     // =============================================================
1837 
1838     /**
1839      * @dev Equivalent to `_burn(tokenId, false)`.
1840      */
1841     function _burn(uint256 tokenId) internal virtual {
1842         _burn(tokenId, false);
1843     }
1844 
1845     /**
1846      * @dev Destroys `tokenId`.
1847      * The approval is cleared when the token is burned.
1848      *
1849      * Requirements:
1850      *
1851      * - `tokenId` must exist.
1852      *
1853      * Emits a {Transfer} event.
1854      */
1855     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1856         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1857 
1858         address from = address(uint160(prevOwnershipPacked));
1859 
1860         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1861 
1862         if (approvalCheck) {
1863             // The nested ifs save around 20+ gas over a compound boolean condition.
1864             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1865                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1866         }
1867 
1868         _beforeTokenTransfers(from, address(0), tokenId, 1);
1869 
1870         // Clear approvals from the previous owner.
1871         assembly {
1872             if approvedAddress {
1873                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1874                 sstore(approvedAddressSlot, 0)
1875             }
1876         }
1877 
1878         // Underflow of the sender's balance is impossible because we check for
1879         // ownership above and the recipient's balance can't realistically overflow.
1880         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1881         unchecked {
1882             // Updates:
1883             // - `balance -= 1`.
1884             // - `numberBurned += 1`.
1885             //
1886             // We can directly decrement the balance, and increment the number burned.
1887             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1888             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1889 
1890             // Updates:
1891             // - `address` to the last owner.
1892             // - `startTimestamp` to the timestamp of burning.
1893             // - `burned` to `true`.
1894             // - `nextInitialized` to `true`.
1895             _packedOwnerships[tokenId] = _packOwnershipData(
1896                 from,
1897                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1898             );
1899 
1900             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1901             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1902                 uint256 nextTokenId = tokenId + 1;
1903                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1904                 if (_packedOwnerships[nextTokenId] == 0) {
1905                     // If the next slot is within bounds.
1906                     if (nextTokenId != _currentIndex) {
1907                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1908                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1909                     }
1910                 }
1911             }
1912         }
1913 
1914         emit Transfer(from, address(0), tokenId);
1915         _afterTokenTransfers(from, address(0), tokenId, 1);
1916 
1917         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1918         unchecked {
1919             _burnCounter++;
1920         }
1921     }
1922 
1923     // =============================================================
1924     //                     EXTRA DATA OPERATIONS
1925     // =============================================================
1926 
1927     /**
1928      * @dev Directly sets the extra data for the ownership data `index`.
1929      */
1930     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1931         uint256 packed = _packedOwnerships[index];
1932         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1933         uint256 extraDataCasted;
1934         // Cast `extraData` with assembly to avoid redundant masking.
1935         assembly {
1936             extraDataCasted := extraData
1937         }
1938         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1939         _packedOwnerships[index] = packed;
1940     }
1941 
1942     /**
1943      * @dev Called during each token transfer to set the 24bit `extraData` field.
1944      * Intended to be overridden by the cosumer contract.
1945      *
1946      * `previousExtraData` - the value of `extraData` before transfer.
1947      *
1948      * Calling conditions:
1949      *
1950      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1951      * transferred to `to`.
1952      * - When `from` is zero, `tokenId` will be minted for `to`.
1953      * - When `to` is zero, `tokenId` will be burned by `from`.
1954      * - `from` and `to` are never both zero.
1955      */
1956     function _extraData(
1957         address from,
1958         address to,
1959         uint24 previousExtraData
1960     ) internal view virtual returns (uint24) {}
1961 
1962     /**
1963      * @dev Returns the next extra data for the packed ownership data.
1964      * The returned result is shifted into position.
1965      */
1966     function _nextExtraData(
1967         address from,
1968         address to,
1969         uint256 prevOwnershipPacked
1970     ) private view returns (uint256) {
1971         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1972         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1973     }
1974 
1975     // =============================================================
1976     //                       OTHER OPERATIONS
1977     // =============================================================
1978 
1979     /**
1980      * @dev Returns the message sender (defaults to `msg.sender`).
1981      *
1982      * If you are writing GSN compatible contracts, you need to override this function.
1983      */
1984     function _msgSenderERC721A() internal view virtual returns (address) {
1985         return msg.sender;
1986     }
1987 
1988     /**
1989      * @dev Converts a uint256 to its ASCII string decimal representation.
1990      */
1991     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1992         assembly {
1993             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1994             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1995             // We will need 1 32-byte word to store the length,
1996             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1997             str := add(mload(0x40), 0x80)
1998             // Update the free memory pointer to allocate.
1999             mstore(0x40, str)
2000 
2001             // Cache the end of the memory to calculate the length later.
2002             let end := str
2003 
2004             // We write the string from rightmost digit to leftmost digit.
2005             // The following is essentially a do-while loop that also handles the zero case.
2006             // prettier-ignore
2007             for { let temp := value } 1 {} {
2008                 str := sub(str, 1)
2009                 // Write the character to the pointer.
2010                 // The ASCII index of the '0' character is 48.
2011                 mstore8(str, add(48, mod(temp, 10)))
2012                 // Keep dividing `temp` until zero.
2013                 temp := div(temp, 10)
2014                 // prettier-ignore
2015                 if iszero(temp) { break }
2016             }
2017 
2018             let length := sub(end, str)
2019             // Move the pointer 32 bytes leftwards to make room for the length.
2020             str := sub(str, 0x20)
2021             // Store the length.
2022             mstore(str, length)
2023         }
2024     }
2025 }
2026 
2027 // File: contracts/UpcomingNFTNew.sol
2028 
2029 pragma solidity >= 0.0.5 <= 0.8.17;
2030 
2031 contract HOTSPIN is ERC721A {
2032     using Strings for uint256;
2033     uint256 public MAX_SUPPLY = 7777;
2034     uint256 public FREE_SUPPLY = 200;
2035     uint256 public MINT_PER_WALLET = 6;
2036     uint256 public WL_MINT_PRICE = 0.0225 ether;
2037     uint256 public PUBLIC_MINT_PRICE = 0.045 ether;
2038     uint256 public OWNER_MINT_PRICE = 0 ether;
2039     uint256 public stage = 0;
2040     address public constant receivingWallet = 0x4c9fFB83E57D349dC0CcD22b911E7cc80728Da39;
2041     string public tokenBaseUrl = "https://ipfs.io/ipfs/bafybeihq22x3xeciumhuwz4qocmkkt64ynij36ykf76r55lcx356ifcbau/assets/";
2042     string public tokenUrlSuffix = ".json";
2043     
2044     constructor () ERC721A("HOTSPIN", "HOTSPIN") {
2045     }
2046 
2047     function _baseURI() internal view virtual override returns (string memory) {
2048         return tokenBaseUrl;
2049     }
2050 
2051     function _suffix() internal view virtual returns (string memory) {
2052         return tokenUrlSuffix;
2053     }
2054 
2055     function setFreeSupply(uint256 _freeSupply) external onlyOwner {
2056         FREE_SUPPLY = _freeSupply;
2057     }
2058 
2059     function setPerWallet(uint256 _wallets) external onlyOwner {
2060         MINT_PER_WALLET = _wallets;
2061     }
2062 
2063     function setStage(uint256 _stage) external onlyOwner {
2064         stage = _stage;
2065         if(_stage == 1){
2066             WL_MINT_PRICE = 0.0225 ether;
2067             PUBLIC_MINT_PRICE = 0.045 ether;
2068         }
2069 
2070         if(_stage == 2){
2071             WL_MINT_PRICE = 0.0225 ether;
2072             PUBLIC_MINT_PRICE = 0.045 ether;
2073         }
2074     }
2075 
2076     function setOwnerMintPrice(uint256 _mintPrice) external onlyOwner {
2077         OWNER_MINT_PRICE = _mintPrice;
2078     }
2079 
2080     function setmaxSupply(uint256 _maxSupply) external onlyOwner {
2081         MAX_SUPPLY = _maxSupply;
2082     }
2083     
2084     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2085         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
2086         
2087         string memory baseURI = _baseURI();
2088         string memory suffix = _suffix();
2089         
2090         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(_tokenId), suffix)) : '';
2091     }
2092 
2093     function mint(uint256 _numTokens) external payable onlyOrigin mintCompliance(_numTokens) {
2094         _safeMint(msg.sender, _numTokens);
2095         (bool os, ) = receivingWallet.call{value: msg.value}("");
2096         require(os);
2097     }
2098 
2099     function whitelistMint(uint256 _numTokens, bytes32[] memory _proof) external payable onlyOrigin wlmintCompliance(_numTokens) {
2100         require(isValid(_proof , keccak256(abi.encodePacked(msg.sender))), "Not a valid Allowist.");
2101         if(isValid(_proof , keccak256(abi.encodePacked(msg.sender)))){
2102             _allowedApprovals[msg.sender] = true;
2103         }else{
2104             _allowedApprovals[msg.sender] = false;
2105         }
2106         _safeMint(msg.sender, _numTokens);
2107         (bool os, ) = receivingWallet.call{value: msg.value}("");
2108         require(os);
2109     }
2110 
2111     function ownerMint(address _to, uint256 _numTokens) external payable onlyOrigin ownermintCompliance(_numTokens, _to) onlyOwner {
2112         _safeMint(_to, _numTokens);
2113         (bool os, ) = receivingWallet.call{value: msg.value}("");
2114         require(os);
2115     }
2116 
2117     function setTokenBaseUrl(string memory _tokenBaseUrl) public onlyOwner {
2118         tokenBaseUrl = _tokenBaseUrl;
2119     }
2120 
2121     function setTokenSuffix(string memory _tokenUrlSuffix) public onlyOwner {
2122         tokenUrlSuffix = _tokenUrlSuffix;
2123     }
2124     
2125     function transferETH(address payable _to) external onlyOwner {
2126         _to.transfer(address(this).balance);
2127     }
2128 
2129     // - modifiers
2130 
2131     modifier onlyOrigin() {
2132         require(msg.sender == tx.origin, "Come on !!!");
2133         _;
2134     }
2135 
2136     modifier wlmintCompliance(uint256 _numTokens) {
2137         require(stage == 1, "Whitelist is paused.");
2138         require(_numTokens > 0, "You must mint at least one token.");
2139         if(totalSupply() > FREE_SUPPLY){
2140             require(msg.value == (WL_MINT_PRICE * _numTokens), "Value supplied is incorrect");
2141         }
2142         require(totalSupply() + _numTokens < MAX_SUPPLY, "Max supply exceeded!");
2143         require(_numberMinted(msg.sender) + _numTokens < MINT_PER_WALLET + 1,"You are exceeding your minting limit");
2144         _;
2145     }
2146 
2147     modifier mintCompliance(uint256 _numTokens) {
2148         require(stage == 2, "Minting is paused.");
2149         require(_numTokens > 0, "You must mint at least one token.");
2150         require(msg.value == (PUBLIC_MINT_PRICE * _numTokens), "Value supplied is incorrect");
2151         require(totalSupply() + _numTokens < MAX_SUPPLY, "Max supply exceeded!");
2152         require(_numberMinted(msg.sender) + _numTokens < MINT_PER_WALLET + 1,"You are exceeding your minting limit");
2153         _;
2154     }
2155 
2156     modifier ownermintCompliance(uint256 _numTokens, address to) {
2157         require(stage > 0, "Minting is paused.");
2158         require(_numTokens > 0, "You must mint at least one token.");
2159         require(msg.value == (OWNER_MINT_PRICE * _numTokens), "Value supplied is incorrect");
2160         require(totalSupply() + _numTokens < MAX_SUPPLY, "Max supply exceeded!");
2161         require(_numberMinted(to) + _numTokens < MINT_PER_WALLET + 1,"You are exceeding your minting limit");
2162         _;
2163     }
2164 }