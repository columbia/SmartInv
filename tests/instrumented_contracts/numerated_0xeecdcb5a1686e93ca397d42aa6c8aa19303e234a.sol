1 // File: contracts/whazzza.sol
2 
3 ////////////////////////////////////////////////////////////////////////////////////////////////
4 ////////////////////////////////////////////////////////////////////////////////////////////////
5 //////////////////////////////////////         /////////////////////////////////////////////////
6 ///////////////////////////////////             /////////////////////////////////////////////////
7 /////////////////////////////////                 ///////////////////////////////////////////////
8 ///////////////////////////////                     /////////////////////////////////////////////
9 /////////////////////////////       ///    //        ////////////////////////////////////////////
10 ///////////////////////////     //////    ////        ///////////////////////////////////////////
11 //////////////////////////      ////      /////        //////////////////////////////////////////
12 //////////////////////////                 /////       //////////////////////////////////////////
13 ///////////////////////////        ///      ////       //////////////////////////////////////////
14 ////////////////////////////     /////                 //////////////////////////////////////////
15 /////////////////////////////                        /////////////////////////////////////////////  
16 //////////////////////////////    //////         /////////////////////////////////////////////////
17 //////////////////////////////  ////////      ////////////////////////////////////////////////////
18 ////////////////////////////   ///////      //////////////////////////////////////////////////////
19 ////////////////////////////  ///////     ////////////////////////////////////////////////////////
20 ////////////////////////////  //////     //////////////////////////////////////////////////////////
21 ////////////////////////////  /////    ///////////////////////////////////////////////////////////
22 ////////////////////////////  ////    ////////////////////////////////////////////////////////////
23 ////////////////////////////  ///   ///////////////////////////////////////////////////////////////
24 ////////////////////////////  ///  ///////////////////////////////////////////////////////////////
25 /////////////////////////////……………////////////////////////////////////////////////////////////////
26 //////////////////////////////////////////////////////////////////////////////////////////////////
27 //////////////////////////////////////////////////////////////////////////////////////////////////
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev String operations.
34  */
35 library Strings {
36     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
40      */
41     function toString(uint256 value) internal pure returns (string memory) {
42         // Inspired by OraclizeAPI's implementation - MIT licence
43         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
44 
45         if (value == 0) {
46             return "0";
47         }
48         uint256 temp = value;
49         uint256 digits;
50         while (temp != 0) {
51             digits++;
52             temp /= 10;
53         }
54         bytes memory buffer = new bytes(digits);
55         while (value != 0) {
56             digits -= 1;
57             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
58             value /= 10;
59         }
60         return string(buffer);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
65      */
66     function toHexString(uint256 value) internal pure returns (string memory) {
67         if (value == 0) {
68             return "0x00";
69         }
70         uint256 temp = value;
71         uint256 length = 0;
72         while (temp != 0) {
73             length++;
74             temp >>= 8;
75         }
76         return toHexString(value, length);
77     }
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
81      */
82     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 // File: ECDSA.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
104  *
105  * These functions can be used to verify that a message was signed by the holder
106  * of the private keys of a given address.
107  */
108 library ECDSA {
109     enum RecoverError {
110         NoError,
111         InvalidSignature,
112         InvalidSignatureLength,
113         InvalidSignatureS,
114         InvalidSignatureV
115     }
116 
117     function _throwError(RecoverError error) private pure {
118         if (error == RecoverError.NoError) {
119             return; // no error: do nothing
120         } else if (error == RecoverError.InvalidSignature) {
121             revert("ECDSA: invalid signature");
122         } else if (error == RecoverError.InvalidSignatureLength) {
123             revert("ECDSA: invalid signature length");
124         } else if (error == RecoverError.InvalidSignatureS) {
125             revert("ECDSA: invalid signature 's' value");
126         } else if (error == RecoverError.InvalidSignatureV) {
127             revert("ECDSA: invalid signature 'v' value");
128         }
129     }
130 
131     /**
132      * @dev Returns the address that signed a hashed message (`hash`) with
133      * `signature` or error string. This address can then be used for verification purposes.
134      *
135      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
136      * this function rejects them by requiring the `s` value to be in the lower
137      * half order, and the `v` value to be either 27 or 28.
138      *
139      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
140      * verification to be secure: it is possible to craft signatures that
141      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
142      * this is by receiving a hash of the original message (which may otherwise
143      * be too long), and then calling {toEthSignedMessageHash} on it.
144      *
145      * Documentation for signature generation:
146      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
147      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
148      *
149      * _Available since v4.3._
150      */
151     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
152         // Check the signature length
153         // - case 65: r,s,v signature (standard)
154         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
155         if (signature.length == 65) {
156             bytes32 r;
157             bytes32 s;
158             uint8 v;
159             // ecrecover takes the signature parameters, and the only way to get them
160             // currently is to use assembly.
161             assembly {
162                 r := mload(add(signature, 0x20))
163                 s := mload(add(signature, 0x40))
164                 v := byte(0, mload(add(signature, 0x60)))
165             }
166             return tryRecover(hash, v, r, s);
167         } else if (signature.length == 64) {
168             bytes32 r;
169             bytes32 vs;
170             // ecrecover takes the signature parameters, and the only way to get them
171             // currently is to use assembly.
172             assembly {
173                 r := mload(add(signature, 0x20))
174                 vs := mload(add(signature, 0x40))
175             }
176             return tryRecover(hash, r, vs);
177         } else {
178             return (address(0), RecoverError.InvalidSignatureLength);
179         }
180     }
181 
182     /**
183      * @dev Returns the address that signed a hashed message (`hash`) with
184      * `signature`. This address can then be used for verification purposes.
185      *
186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
187      * this function rejects them by requiring the `s` value to be in the lower
188      * half order, and the `v` value to be either 27 or 28.
189      *
190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
191      * verification to be secure: it is possible to craft signatures that
192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
193      * this is by receiving a hash of the original message (which may otherwise
194      * be too long), and then calling {toEthSignedMessageHash} on it.
195      */
196     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
197         (address recovered, RecoverError error) = tryRecover(hash, signature);
198         _throwError(error);
199         return recovered;
200     }
201 
202     /**
203      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
204      *
205      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
206      *
207      * _Available since v4.3._
208      */
209     function tryRecover(
210         bytes32 hash,
211         bytes32 r,
212         bytes32 vs
213     ) internal pure returns (address, RecoverError) {
214         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
215         uint8 v = uint8((uint256(vs) >> 255) + 27);
216         return tryRecover(hash, v, r, s);
217     }
218 
219     /**
220      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
221      *
222      * _Available since v4.2._
223      */
224     function recover(
225         bytes32 hash,
226         bytes32 r,
227         bytes32 vs
228     ) internal pure returns (address) {
229         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
230         _throwError(error);
231         return recovered;
232     }
233 
234     /**
235      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
236      * `r` and `s` signature fields separately.
237      *
238      * _Available since v4.3._
239      */
240     function tryRecover(
241         bytes32 hash,
242         uint8 v,
243         bytes32 r,
244         bytes32 s
245     ) internal pure returns (address, RecoverError) {
246         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
247         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
248         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
249         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
250         //
251         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
252         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
253         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
254         // these malleable signatures as well.
255         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
256             return (address(0), RecoverError.InvalidSignatureS);
257         }
258         if (v != 27 && v != 28) {
259             return (address(0), RecoverError.InvalidSignatureV);
260         }
261 
262         // If the signature is valid (and not malleable), return the signer address
263         address signer = ecrecover(hash, v, r, s);
264         if (signer == address(0)) {
265             return (address(0), RecoverError.InvalidSignature);
266         }
267 
268         return (signer, RecoverError.NoError);
269     }
270 
271     /**
272      * @dev Overload of {ECDSA-recover} that receives the `v`,
273      * `r` and `s` signature fields separately.
274      */
275     function recover(
276         bytes32 hash,
277         uint8 v,
278         bytes32 r,
279         bytes32 s
280     ) internal pure returns (address) {
281         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
282         _throwError(error);
283         return recovered;
284     }
285 
286     /**
287      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
288      * produces hash corresponding to the one signed with the
289      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
290      * JSON-RPC method as part of EIP-191.
291      *
292      * See {recover}.
293      */
294     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
295         // 32 is the length in bytes of hash,
296         // enforced by the type signature above
297         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
298     }
299 
300     /**
301      * @dev Returns an Ethereum Signed Message, created from `s`. This
302      * produces hash corresponding to the one signed with the
303      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
304      * JSON-RPC method as part of EIP-191.
305      *
306      * See {recover}.
307      */
308     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
309         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
310     }
311 
312     /**
313      * @dev Returns an Ethereum Signed Typed Data, created from a
314      * `domainSeparator` and a `structHash`. This produces hash corresponding
315      * to the one signed with the
316      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
317      * JSON-RPC method as part of EIP-712.
318      *
319      * See {recover}.
320      */
321     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
322         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
323     }
324 }
325 
326 
327 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev These functions deal with verification of Merkle Tree proofs.
333  *
334  * The proofs can be generated using the JavaScript library
335  * https://github.com/miguelmota/merkletreejs[merkletreejs].
336  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
337  *
338  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
339  *
340  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
341  * hashing, or use a hash function other than keccak256 for hashing leaves.
342  * This is because the concatenation of a sorted pair of internal nodes in
343  * the merkle tree could be reinterpreted as a leaf value.
344  */
345 library MerkleProof {
346     /**
347      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
348      * defined by `root`. For this, a `proof` must be provided, containing
349      * sibling hashes on the branch from the leaf to the root of the tree. Each
350      * pair of leaves and each pair of pre-images are assumed to be sorted.
351      */
352     function verify(
353         bytes32[] memory proof,
354         bytes32 root,
355         bytes32 leaf
356     ) internal pure returns (bool) {
357         return processProof(proof, leaf) == root;
358     }
359 
360     /**
361      * @dev Calldata version of {verify}
362      *
363      * _Available since v4.7._
364      */
365     function verifyCalldata(
366         bytes32[] calldata proof,
367         bytes32 root,
368         bytes32 leaf
369     ) internal pure returns (bool) {
370         return processProofCalldata(proof, leaf) == root;
371     }
372 
373     /**
374      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
375      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
376      * hash matches the root of the tree. When processing the proof, the pairs
377      * of leafs & pre-images are assumed to be sorted.
378      *
379      * _Available since v4.4._
380      */
381     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
382         bytes32 computedHash = leaf;
383         for (uint256 i = 0; i < proof.length; i++) {
384             computedHash = _hashPair(computedHash, proof[i]);
385         }
386         return computedHash;
387     }
388 
389     /**
390      * @dev Calldata version of {processProof}
391      *
392      * _Available since v4.7._
393      */
394     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
395         bytes32 computedHash = leaf;
396         for (uint256 i = 0; i < proof.length; i++) {
397             computedHash = _hashPair(computedHash, proof[i]);
398         }
399         return computedHash;
400     }
401 
402     /**
403      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
404      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
405      *
406      * _Available since v4.7._
407      */
408     function multiProofVerify(
409         bytes32[] memory proof,
410         bool[] memory proofFlags,
411         bytes32 root,
412         bytes32[] memory leaves
413     ) internal pure returns (bool) {
414         return processMultiProof(proof, proofFlags, leaves) == root;
415     }
416 
417     /**
418      * @dev Calldata version of {multiProofVerify}
419      *
420      * _Available since v4.7._
421      */
422     function multiProofVerifyCalldata(
423         bytes32[] calldata proof,
424         bool[] calldata proofFlags,
425         bytes32 root,
426         bytes32[] memory leaves
427     ) internal pure returns (bool) {
428         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
429     }
430 
431     /**
432      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
433      * consuming from one or the other at each step according to the instructions given by
434      * `proofFlags`.
435      *
436      * _Available since v4.7._
437      */
438     function processMultiProof(
439         bytes32[] memory proof,
440         bool[] memory proofFlags,
441         bytes32[] memory leaves
442     ) internal pure returns (bytes32 merkleRoot) {
443         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
444         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
445         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
446         // the merkle tree.
447         uint256 leavesLen = leaves.length;
448         uint256 totalHashes = proofFlags.length;
449 
450         // Check proof validity.
451         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
452 
453         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
454         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
455         bytes32[] memory hashes = new bytes32[](totalHashes);
456         uint256 leafPos = 0;
457         uint256 hashPos = 0;
458         uint256 proofPos = 0;
459         // At each step, we compute the next hash using two values:
460         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
461         //   get the next hash.
462         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
463         //   `proof` array.
464         for (uint256 i = 0; i < totalHashes; i++) {
465             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
466             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
467             hashes[i] = _hashPair(a, b);
468         }
469 
470         if (totalHashes > 0) {
471             return hashes[totalHashes - 1];
472         } else if (leavesLen > 0) {
473             return leaves[0];
474         } else {
475             return proof[0];
476         }
477     }
478 
479     /**
480      * @dev Calldata version of {processMultiProof}
481      *
482      * _Available since v4.7._
483      */
484     function processMultiProofCalldata(
485         bytes32[] calldata proof,
486         bool[] calldata proofFlags,
487         bytes32[] memory leaves
488     ) internal pure returns (bytes32 merkleRoot) {
489         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
490         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
491         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
492         // the merkle tree.
493         uint256 leavesLen = leaves.length;
494         uint256 totalHashes = proofFlags.length;
495 
496         // Check proof validity.
497         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
498 
499         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
500         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
501         bytes32[] memory hashes = new bytes32[](totalHashes);
502         uint256 leafPos = 0;
503         uint256 hashPos = 0;
504         uint256 proofPos = 0;
505         // At each step, we compute the next hash using two values:
506         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
507         //   get the next hash.
508         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
509         //   `proof` array.
510         for (uint256 i = 0; i < totalHashes; i++) {
511             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
512             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
513             hashes[i] = _hashPair(a, b);
514         }
515 
516         if (totalHashes > 0) {
517             return hashes[totalHashes - 1];
518         } else if (leavesLen > 0) {
519             return leaves[0];
520         } else {
521             return proof[0];
522         }
523     }
524 
525     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
526         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
527     }
528 
529     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
530         /// @solidity memory-safe-assembly
531         assembly {
532             mstore(0x00, a)
533             mstore(0x20, b)
534             value := keccak256(0x00, 0x40)
535         }
536     }
537 }
538 
539 
540 // File: Context.sol
541 
542 
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev Provides information about the current execution context, including the
548  * sender of the transaction and its data. While these are generally available
549  * via msg.sender and msg.data, they should not be accessed in such a direct
550  * manner, since when dealing with meta-transactions the account sending and
551  * paying for execution may not be the actual sender (as far as an application
552  * is concerned).
553  *
554  * This contract is only required for intermediate, library-like contracts.
555  */
556 abstract contract Context {
557     function _msgSender() internal view virtual returns (address) {
558         return msg.sender;
559     }
560 
561     function _msgData() internal view virtual returns (bytes calldata) {
562         return msg.data;
563     }
564 }
565 // File: Ownable.sol
566 
567 
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Contract module which provides a basic access control mechanism, where
574  * there is an account (an owner) that can be granted exclusive access to
575  * specific functions.
576  *
577  * By default, the owner account will be the one that deploys the contract. This
578  * can later be changed with {transferOwnership}.
579  *
580  * This module is used through inheritance. It will make available the modifier
581  * `onlyOwner`, which can be applied to your functions to restrict their use to
582  * the owner.
583  */
584 abstract contract Ownable is Context {
585     address private _owner;
586 
587     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
588 
589     /**
590      * @dev Initializes the contract setting the deployer as the initial owner.
591      */
592     constructor() {
593         _setOwner(_msgSender());
594     }
595 
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view virtual returns (address) {
600         return _owner;
601     }
602 
603     /**
604      * @dev Throws if called by any account other than the owner.
605      */
606     modifier onlyOwner() {
607         require(owner() == _msgSender(), "Ownable: caller is not the owner");
608         _;
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         _setOwner(address(0));
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public virtual onlyOwner {
627         require(newOwner != address(0), "Ownable: new owner is the zero address");
628         _setOwner(newOwner);
629     }
630 
631     function _setOwner(address newOwner) private {
632         address oldOwner = _owner;
633         _owner = newOwner;
634         emit OwnershipTransferred(oldOwner, newOwner);
635     }
636 }
637 // File: Address.sol
638 
639 
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Collection of functions related to the address type
645  */
646 library Address {
647     /**
648      * @dev Returns true if `account` is a contract.
649      *
650      * [IMPORTANT]
651      * ====
652      * It is unsafe to assume that an address for which this function returns
653      * false is an externally-owned account (EOA) and not a contract.
654      *
655      * Among others, `isContract` will return false for the following
656      * types of addresses:
657      *
658      *  - an externally-owned account
659      *  - a contract in construction
660      *  - an address where a contract will be created
661      *  - an address where a contract lived, but was destroyed
662      * ====
663      */
664     function isContract(address account) internal view returns (bool) {
665         // This method relies on extcodesize, which returns 0 for contracts in
666         // construction, since the code is only stored at the end of the
667         // constructor execution.
668 
669         uint256 size;
670         assembly {
671             size := extcodesize(account)
672         }
673         return size > 0;
674     }
675 
676     /**
677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
678      * `recipient`, forwarding all available gas and reverting on errors.
679      *
680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
682      * imposed by `transfer`, making them unable to receive funds via
683      * `transfer`. {sendValue} removes this limitation.
684      *
685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
686      *
687      * IMPORTANT: because control is transferred to `recipient`, care must be
688      * taken to not create reentrancy vulnerabilities. Consider using
689      * {ReentrancyGuard} or the
690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
691      */
692     function sendValue(address payable recipient, uint256 amount) internal {
693         require(address(this).balance >= amount, "Address: insufficient balance");
694 
695         (bool success, ) = recipient.call{value: amount}("");
696         require(success, "Address: unable to send value, recipient may have reverted");
697     }
698 
699     /**
700      * @dev Performs a Solidity function call using a low level `call`. A
701      * plain `call` is an unsafe replacement for a function call: use this
702      * function instead.
703      *
704      * If `target` reverts with a revert reason, it is bubbled up by this
705      * function (like regular Solidity function calls).
706      *
707      * Returns the raw returned data. To convert to the expected return value,
708      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
709      *
710      * Requirements:
711      *
712      * - `target` must be a contract.
713      * - calling `target` with `data` must not revert.
714      *
715      * _Available since v3.1._
716      */
717     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
718         return functionCall(target, data, "Address: low-level call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
723      * `errorMessage` as a fallback revert reason when `target` reverts.
724      *
725      * _Available since v3.1._
726      */
727     function functionCall(
728         address target,
729         bytes memory data,
730         string memory errorMessage
731     ) internal returns (bytes memory) {
732         return functionCallWithValue(target, data, 0, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but also transferring `value` wei to `target`.
738      *
739      * Requirements:
740      *
741      * - the calling contract must have an ETH balance of at least `value`.
742      * - the called Solidity function must be `payable`.
743      *
744      * _Available since v3.1._
745      */
746     function functionCallWithValue(
747         address target,
748         bytes memory data,
749         uint256 value
750     ) internal returns (bytes memory) {
751         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
756      * with `errorMessage` as a fallback revert reason when `target` reverts.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(
761         address target,
762         bytes memory data,
763         uint256 value,
764         string memory errorMessage
765     ) internal returns (bytes memory) {
766         require(address(this).balance >= value, "Address: insufficient balance for call");
767         require(isContract(target), "Address: call to non-contract");
768 
769         (bool success, bytes memory returndata) = target.call{value: value}(data);
770         return _verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
780         return functionStaticCall(target, data, "Address: low-level static call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a static call.
786      *
787      * _Available since v3.3._
788      */
789     function functionStaticCall(
790         address target,
791         bytes memory data,
792         string memory errorMessage
793     ) internal view returns (bytes memory) {
794         require(isContract(target), "Address: static call to non-contract");
795 
796         (bool success, bytes memory returndata) = target.staticcall(data);
797         return _verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
807         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
812      * but performing a delegate call.
813      *
814      * _Available since v3.4._
815      */
816     function functionDelegateCall(
817         address target,
818         bytes memory data,
819         string memory errorMessage
820     ) internal returns (bytes memory) {
821         require(isContract(target), "Address: delegate call to non-contract");
822 
823         (bool success, bytes memory returndata) = target.delegatecall(data);
824         return _verifyCallResult(success, returndata, errorMessage);
825     }
826 
827     function _verifyCallResult(
828         bool success,
829         bytes memory returndata,
830         string memory errorMessage
831     ) private pure returns (bytes memory) {
832         if (success) {
833             return returndata;
834         } else {
835             // Look for revert reason and bubble it up if present
836             if (returndata.length > 0) {
837                 // The easiest way to bubble the revert reason is using memory via assembly
838 
839                 assembly {
840                     let returndata_size := mload(returndata)
841                     revert(add(32, returndata), returndata_size)
842                 }
843             } else {
844                 revert(errorMessage);
845             }
846         }
847     }
848 }
849 // File: Payment.sol
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 
857 
858 /**
859  * @title PaymentSplitter
860  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
861  * that the Ether will be split in this way, since it is handled transparently by the contract.
862  *
863  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
864  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
865  * an amount proportional to the percentage of total shares they were assigned.
866  *
867  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
868  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
869  * function.
870  *
871  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
872  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
873  * to run tests before sending real value to this contract.
874  */
875 contract Payment is Context {
876     event PayeeAdded(address account, uint256 shares);
877     event PaymentReleased(address to, uint256 amount);
878     event PaymentReceived(address from, uint256 amount);
879 
880     uint256 private _totalShares;
881     uint256 private _totalReleased;
882 
883     mapping(address => uint256) private _shares;
884     mapping(address => uint256) private _released;
885     address[] private _payees;
886 
887     /**
888      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
889      * the matching position in the `shares` array.
890      *
891      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
892      * duplicates in `payees`.
893      */
894     constructor(address[] memory payees, uint256[] memory shares_) payable {
895         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
896         require(payees.length > 0, "PaymentSplitter: no payees");
897 
898         for (uint256 i = 0; i < payees.length; i++) {
899             _addPayee(payees[i], shares_[i]);
900         }
901     }
902 
903     /**
904      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
905      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
906      * reliability of the events, and not the actual splitting of Ether.
907      *
908      * To learn more about this see the Solidity documentation for
909      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
910      * functions].
911      */
912     receive() external payable virtual {
913         emit PaymentReceived(_msgSender(), msg.value);
914     }
915 
916     /**
917      * @dev Getter for the total shares held by payees.
918      */
919     function totalShares() public view returns (uint256) {
920         return _totalShares;
921     }
922 
923     /**
924      * @dev Getter for the total amount of Ether already released.
925      */
926     function totalReleased() public view returns (uint256) {
927         return _totalReleased;
928     }
929 
930 
931     /**
932      * @dev Getter for the amount of shares held by an account.
933      */
934     function shares(address account) public view returns (uint256) {
935         return _shares[account];
936     }
937 
938     /**
939      * @dev Getter for the amount of Ether already released to a payee.
940      */
941     function released(address account) public view returns (uint256) {
942         return _released[account];
943     }
944 
945 
946     /**
947      * @dev Getter for the address of the payee number `index`.
948      */
949     function payee(uint256 index) public view returns (address) {
950         return _payees[index];
951     }
952 
953     /**
954      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
955      * total shares and their previous withdrawals.
956      */
957     function release(address payable account) public virtual {
958         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
959 
960         uint256 totalReceived = address(this).balance + totalReleased();
961         uint256 payment = _pendingPayment(account, totalReceived, released(account));
962 
963         require(payment != 0, "PaymentSplitter: account is not due payment");
964 
965         _released[account] += payment;
966         _totalReleased += payment;
967 
968         Address.sendValue(account, payment);
969         emit PaymentReleased(account, payment);
970     }
971 
972 
973     /**
974      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
975      * already released amounts.
976      */
977     function _pendingPayment(
978         address account,
979         uint256 totalReceived,
980         uint256 alreadyReleased
981     ) private view returns (uint256) {
982         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
983     }
984 
985     /**
986      * @dev Add a new payee to the contract.
987      * @param account The address of the payee to add.
988      * @param shares_ The number of shares owned by the payee.
989      */
990     function _addPayee(address account, uint256 shares_) private {
991         require(account != address(0), "PaymentSplitter: account is the zero address");
992         require(shares_ > 0, "PaymentSplitter: shares are 0");
993         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
994 
995         _payees.push(account);
996         _shares[account] = shares_;
997         _totalShares = _totalShares + shares_;
998         emit PayeeAdded(account, shares_);
999     }
1000 }
1001 // File: IERC721Receiver.sol
1002 
1003 
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 /**
1008  * @title ERC721 token receiver interface
1009  * @dev Interface for any contract that wants to support safeTransfers
1010  * from ERC721 asset contracts.
1011  */
1012 interface IERC721Receiver {
1013     /**
1014      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1015      * by `operator` from `from`, this function is called.
1016      *
1017      * It must return its Solidity selector to confirm the token transfer.
1018      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1019      *
1020      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1021      */
1022     function onERC721Received(
1023         address operator,
1024         address from,
1025         uint256 tokenId,
1026         bytes calldata data
1027     ) external returns (bytes4);
1028 }
1029 // File: IERC165.sol
1030 
1031 
1032 
1033 pragma solidity ^0.8.0;
1034 
1035 /**
1036  * @dev Interface of the ERC165 standard, as defined in the
1037  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1038  *
1039  * Implementers can declare support of contract interfaces, which can then be
1040  * queried by others ({ERC165Checker}).
1041  *
1042  * For an implementation, see {ERC165}.
1043  */
1044 interface IERC165 {
1045     /**
1046      * @dev Returns true if this contract implements the interface defined by
1047      * `interfaceId`. See the corresponding
1048      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1049      * to learn more about how these ids are created.
1050      *
1051      * This function call must use less than 30 000 gas.
1052      */
1053     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1054 }
1055 // File: ERC165.sol
1056 
1057 
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 
1062 /**
1063  * @dev Implementation of the {IERC165} interface.
1064  *
1065  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1066  * for the additional interface id that will be supported. For example:
1067  *
1068  * ```solidity
1069  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1070  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1071  * }
1072  * ```
1073  *
1074  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1075  */
1076 abstract contract ERC165 is IERC165 {
1077     /**
1078      * @dev See {IERC165-supportsInterface}.
1079      */
1080     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1081         return interfaceId == type(IERC165).interfaceId;
1082     }
1083 }
1084 // File: IERC721.sol
1085 
1086 
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 
1091 /**
1092  * @dev Required interface of an ERC721 compliant contract.
1093  */
1094 interface IERC721 is IERC165 {
1095     /**
1096      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1097      */
1098     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1099 
1100     /**
1101      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1102      */
1103     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1104 
1105     /**
1106      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1107      */
1108     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1109 
1110     /**
1111      * @dev Returns the number of tokens in ``owner``'s account.
1112      */
1113     function balanceOf(address owner) external view returns (uint256 balance);
1114 
1115     /**
1116      * @dev Returns the owner of the `tokenId` token.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      */
1122     function ownerOf(uint256 tokenId) external view returns (address owner);
1123 
1124     /**
1125      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1126      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1127      *
1128      * Requirements:
1129      *
1130      * - `from` cannot be the zero address.
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must exist and be owned by `from`.
1133      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1134      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function safeTransferFrom(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) external;
1143 
1144     /**
1145      * @dev Transfers `tokenId` token from `from` to `to`.
1146      *
1147      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1148      *
1149      * Requirements:
1150      *
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function transferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) external;
1163 
1164     /**
1165      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1166      * The approval is cleared when the token is transferred.
1167      *
1168      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1169      *
1170      * Requirements:
1171      *
1172      * - The caller must own the token or be an approved operator.
1173      * - `tokenId` must exist.
1174      *
1175      * Emits an {Approval} event.
1176      */
1177     function approve(address to, uint256 tokenId) external;
1178 
1179     /**
1180      * @dev Returns the account approved for `tokenId` token.
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must exist.
1185      */
1186     function getApproved(uint256 tokenId) external view returns (address operator);
1187 
1188     /**
1189      * @dev Approve or remove `operator` as an operator for the caller.
1190      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1191      *
1192      * Requirements:
1193      *
1194      * - The `operator` cannot be the caller.
1195      *
1196      * Emits an {ApprovalForAll} event.
1197      */
1198     function setApprovalForAll(address operator, bool _approved) external;
1199 
1200     /**
1201      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1202      *
1203      * See {setApprovalForAll}
1204      */
1205     function isApprovedForAll(address owner, address operator) external view returns (bool);
1206 
1207     /**
1208      * @dev Safely transfers `tokenId` token from `from` to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - `from` cannot be the zero address.
1213      * - `to` cannot be the zero address.
1214      * - `tokenId` token must exist and be owned by `from`.
1215      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function safeTransferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId,
1224         bytes calldata data
1225     ) external;
1226 
1227   //  function _burn(uint256 tokenId) external;
1228 
1229   //  function _isApprovedOrOwner(address spender, uint256 tokenId) external view  returns (bool); 
1230 }
1231 // File: IERC721Enumerable.sol
1232 
1233 
1234 
1235 pragma solidity ^0.8.0;
1236 
1237 
1238 /**
1239  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1240  * @dev See https://eips.ethereum.org/EIPS/eip-721
1241  */
1242 interface IERC721Enumerable is IERC721 {
1243     /**
1244      * @dev Returns the total amount of tokens stored by the contract.
1245      */
1246     function totalSupply() external view returns (uint256);
1247 
1248     /**
1249      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1250      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1251      */
1252     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1253 
1254     /**
1255      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1256      * Use along with {totalSupply} to enumerate all tokens.
1257      */
1258     function tokenByIndex(uint256 index) external view returns (uint256);
1259 }
1260 // File: IERC721Metadata.sol
1261 
1262 
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 
1267 /**
1268  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1269  * @dev See https://eips.ethereum.org/EIPS/eip-721
1270  */
1271 interface IERC721Metadata is IERC721 {
1272     /**
1273      * @dev Returns the token collection name.
1274      */
1275     function name() external view returns (string memory);
1276 
1277     /**
1278      * @dev Returns the token collection symbol.
1279      */
1280     function symbol() external view returns (string memory);
1281 
1282     /**
1283      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1284      */
1285     function tokenURI(uint256 tokenId) external view returns (string memory);
1286 }
1287 // File: ERC721A.sol
1288 
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 
1293 
1294 
1295 
1296 
1297 
1298 
1299 
1300 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
1301     using Address for address;
1302     using Strings for uint256;
1303 
1304     struct TokenOwnership {
1305         address addr;
1306         uint64 startTimestamp;
1307     }
1308 
1309     struct AddressData {
1310         uint128 balance;
1311         uint128 numberMinted;
1312     }
1313 
1314     uint256 internal currentIndex;
1315 
1316     // Token name
1317     string private _name;
1318 
1319     // Token symbol
1320     string private _symbol;
1321 
1322     // Mapping from token ID to ownership details
1323     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1324     mapping(uint256 => TokenOwnership) internal _ownerships;
1325 
1326     // Mapping owner address to address data
1327     mapping(address => AddressData) private _addressData;
1328 
1329     // Mapping from token ID to approved address
1330     mapping(uint256 => address) private _tokenApprovals;
1331 
1332     // Mapping from owner to operator approvals
1333     mapping(address => mapping(address => bool)) private _operatorApprovals;
1334 
1335     constructor(string memory name_, string memory symbol_) {
1336         _name = name_;
1337         _symbol = symbol_;
1338     }
1339 
1340     /**
1341      * @dev See {IERC721Enumerable-totalSupply}.
1342      */
1343     function totalSupply() public view override returns (uint256) {
1344         return currentIndex;
1345     }
1346 
1347     /**
1348      * @dev See {IERC721Enumerable-tokenByIndex}.
1349      */
1350     function tokenByIndex(uint256 index) public view override returns (uint256) {
1351         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1352         return index;
1353     }
1354 
1355     /**
1356      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1357      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1358      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1359      */
1360     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1361         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1362         uint256 numMintedSoFar = totalSupply();
1363         uint256 tokenIdsIdx;
1364         address currOwnershipAddr;
1365 
1366         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1367         unchecked {
1368             for (uint256 i; i < numMintedSoFar; i++) {
1369                 TokenOwnership memory ownership = _ownerships[i];
1370                 if (ownership.addr != address(0)) {
1371                     currOwnershipAddr = ownership.addr;
1372                 }
1373                 if (currOwnershipAddr == owner) {
1374                     if (tokenIdsIdx == index) {
1375                         return i;
1376                     }
1377                     tokenIdsIdx++;
1378                 }
1379             }
1380         }
1381 
1382         revert('ERC721A: unable to get token of owner by index');
1383     }
1384 
1385     /**
1386      * @dev See {IERC165-supportsInterface}.
1387      */
1388     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1389         return
1390             interfaceId == type(IERC721).interfaceId ||
1391             interfaceId == type(IERC721Metadata).interfaceId ||
1392             interfaceId == type(IERC721Enumerable).interfaceId ||
1393             super.supportsInterface(interfaceId);
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-balanceOf}.
1398      */
1399     function balanceOf(address owner) public view override returns (uint256) {
1400         require(owner != address(0), 'ERC721A: balance query for the zero address');
1401         return uint256(_addressData[owner].balance);
1402     }
1403 
1404     function _numberMinted(address owner) internal view returns (uint256) {
1405         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1406         return uint256(_addressData[owner].numberMinted);
1407     }
1408 
1409     /**
1410      * Gas spent here starts off proportional to the maximum mint batch size.
1411      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1412      */
1413     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1414         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1415 
1416         unchecked {
1417             for (uint256 curr = tokenId; curr >= 0; curr--) {
1418                 TokenOwnership memory ownership = _ownerships[curr];
1419                 if (ownership.addr != address(0)) {
1420                     return ownership;
1421                 }
1422             }
1423         }
1424 
1425         revert('ERC721A: unable to determine the owner of token');
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-ownerOf}.
1430      */
1431     function ownerOf(uint256 tokenId) public view override returns (address) {
1432         return ownershipOf(tokenId).addr;
1433     }
1434 
1435     /**
1436      * @dev See {IERC721Metadata-name}.
1437      */
1438     function name() public view virtual override returns (string memory) {
1439         return _name;
1440     }
1441 
1442     /**
1443      * @dev See {IERC721Metadata-symbol}.
1444      */
1445     function symbol() public view virtual override returns (string memory) {
1446         return _symbol;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Metadata-tokenURI}.
1451      */
1452     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1453         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1454 
1455         string memory baseURI = _baseURI();
1456 
1457         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1458     }
1459 
1460 
1461     /**
1462      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1463      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1464      * by default, can be overriden in child contracts.
1465      */
1466     function _baseURI() internal view virtual returns (string memory) {
1467         return '';
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-approve}.
1472      */
1473     function approve(address to, uint256 tokenId) public override {
1474         address owner = ERC721A.ownerOf(tokenId);
1475         require(to != owner, 'ERC721A: approval to current owner');
1476 
1477         require(
1478             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1479             'ERC721A: approve caller is not owner nor approved for all'
1480         );
1481 
1482         _approve(to, tokenId, owner);
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-getApproved}.
1487      */
1488     function getApproved(uint256 tokenId) public view override returns (address) {
1489         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1490 
1491         return _tokenApprovals[tokenId];
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-setApprovalForAll}.
1496      */
1497     function setApprovalForAll(address operator, bool approved) public override {
1498         require(operator != _msgSender(), 'ERC721A: approve to caller');
1499 
1500         _operatorApprovals[_msgSender()][operator] = approved;
1501         emit ApprovalForAll(_msgSender(), operator, approved);
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-isApprovedForAll}.
1506      */
1507     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1508         return _operatorApprovals[owner][operator];
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-transferFrom}.
1513      */
1514     function transferFrom(
1515         address from,
1516         address to,
1517         uint256 tokenId
1518     ) public override {
1519         _transfer(from, to, tokenId);
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-safeTransferFrom}.
1524      */
1525     function safeTransferFrom(
1526         address from,
1527         address to,
1528         uint256 tokenId
1529     ) public override {
1530         safeTransferFrom(from, to, tokenId, '');
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-safeTransferFrom}.
1535      */
1536     function safeTransferFrom(
1537         address from,
1538         address to,
1539         uint256 tokenId,
1540         bytes memory _data
1541     ) public override {
1542         _transfer(from, to, tokenId);
1543         require(
1544             _checkOnERC721Received(from, to, tokenId, _data),
1545             'ERC721A: transfer to non ERC721Receiver implementer'
1546         );
1547     }
1548 
1549     /**
1550      * @dev Returns whether `tokenId` exists.
1551      *
1552      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1553      *
1554      * Tokens start existing when they are minted (`_mint`),
1555      */
1556     function _exists(uint256 tokenId) internal view returns (bool) {
1557         return tokenId < currentIndex;
1558     }
1559 
1560     function _safeMint(address to, uint256 quantity) internal {
1561         _safeMint(to, quantity, '');
1562     }
1563 
1564     /**
1565      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1566      *
1567      * Requirements:
1568      *
1569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1570      * - `quantity` must be greater than 0.
1571      *
1572      * Emits a {Transfer} event.
1573      */
1574     function _safeMint(
1575         address to,
1576         uint256 quantity,
1577         bytes memory _data
1578     ) internal {
1579         _mint(to, quantity, _data, true);
1580     }
1581 
1582     /**
1583      * @dev Mints `quantity` tokens and transfers them to `to`.
1584      *
1585      * Requirements:
1586      *
1587      * - `to` cannot be the zero address.
1588      * - `quantity` must be greater than 0.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function _mint(
1593         address to,
1594         uint256 quantity,
1595         bytes memory _data,
1596         bool safe
1597     ) internal {
1598         uint256 startTokenId = currentIndex;
1599         require(to != address(0), 'ERC721A: mint to the zero address');
1600         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1601 
1602         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1603 
1604         // Overflows are incredibly unrealistic.
1605         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1606         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1607         unchecked {
1608             _addressData[to].balance += uint128(quantity);
1609             _addressData[to].numberMinted += uint128(quantity);
1610 
1611             _ownerships[startTokenId].addr = to;
1612             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1613 
1614             uint256 updatedIndex = startTokenId;
1615 
1616             for (uint256 i; i < quantity; i++) {
1617                 emit Transfer(address(0), to, updatedIndex);
1618                 if (safe) {
1619                     require(
1620                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1621                         'ERC721A: transfer to non ERC721Receiver implementer'
1622                     );
1623                 }
1624 
1625                 updatedIndex++;
1626             }
1627 
1628             currentIndex = updatedIndex;
1629         }
1630 
1631         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1632     }
1633 
1634     /**
1635      * @dev Transfers `tokenId` from `from` to `to`.
1636      *
1637      * Requirements:
1638      *
1639      * - `to` cannot be the zero address.
1640      * - `tokenId` token must be owned by `from`.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function _transfer(
1645         address from,
1646         address to,
1647         uint256 tokenId
1648     ) private {
1649         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1650 
1651         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1652             getApproved(tokenId) == _msgSender() ||
1653             isApprovedForAll(prevOwnership.addr, _msgSender()));
1654 
1655         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1656 
1657         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1658         require(to != address(0), 'ERC721A: transfer to the zero address');
1659 
1660         _beforeTokenTransfers(from, to, tokenId, 1);
1661 
1662         // Clear approvals from the previous owner
1663         _approve(address(0), tokenId, prevOwnership.addr);
1664 
1665         // Underflow of the sender's balance is impossible because we check for
1666         // ownership above and the recipient's balance can't realistically overflow.
1667         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1668         unchecked {
1669             _addressData[from].balance -= 1;
1670             _addressData[to].balance += 1;
1671 
1672             _ownerships[tokenId].addr = to;
1673             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1674 
1675             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1676             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1677             uint256 nextTokenId = tokenId + 1;
1678             if (_ownerships[nextTokenId].addr == address(0)) {
1679                 if (_exists(nextTokenId)) {
1680                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1681                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1682                 }
1683             }
1684         }
1685 
1686         emit Transfer(from, to, tokenId);
1687         _afterTokenTransfers(from, to, tokenId, 1);
1688     }
1689 
1690     /**
1691      * @dev Approve `to` to operate on `tokenId`
1692      *
1693      * Emits a {Approval} event.
1694      */
1695     function _approve(
1696         address to,
1697         uint256 tokenId,
1698         address owner
1699     ) private {
1700         _tokenApprovals[tokenId] = to;
1701         emit Approval(owner, to, tokenId);
1702     }
1703 
1704     /**
1705      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1706      * The call is not executed if the target address is not a contract.
1707      *
1708      * @param from address representing the previous owner of the given token ID
1709      * @param to target address that will receive the tokens
1710      * @param tokenId uint256 ID of the token to be transferred
1711      * @param _data bytes optional data to send along with the call
1712      * @return bool whether the call correctly returned the expected magic value
1713      */
1714     function _checkOnERC721Received(
1715         address from,
1716         address to,
1717         uint256 tokenId,
1718         bytes memory _data
1719     ) private returns (bool) {
1720         if (to.isContract()) {
1721             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1722                 return retval == IERC721Receiver(to).onERC721Received.selector;
1723             } catch (bytes memory reason) {
1724                 if (reason.length == 0) {
1725                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1726                 } else {
1727                     assembly {
1728                         revert(add(32, reason), mload(reason))
1729                     }
1730                 }
1731             }
1732         } else {
1733             return true;
1734         }
1735     }
1736 
1737     /**
1738      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1739      *
1740      * startTokenId - the first token id to be transferred
1741      * quantity - the amount to be transferred
1742      *
1743      * Calling conditions:
1744      *
1745      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1746      * transferred to `to`.
1747      * - When `from` is zero, `tokenId` will be minted for `to`.
1748      */
1749     function _beforeTokenTransfers(
1750         address from,
1751         address to,
1752         uint256 startTokenId,
1753         uint256 quantity
1754     ) internal virtual {}
1755 
1756     /**
1757      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1758      * minting.
1759      *
1760      * startTokenId - the first token id to be transferred
1761      * quantity - the amount to be transferred
1762      *
1763      * Calling conditions:
1764      *
1765      * - when `from` and `to` are both non-zero.
1766      * - `from` and `to` are never both zero.
1767      */
1768     function _afterTokenTransfers(
1769         address from,
1770         address to,
1771         uint256 startTokenId,
1772         uint256 quantity
1773     ) internal virtual {}
1774 
1775     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1776         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1777         address owner = ERC721A.ownerOf(tokenId);
1778         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1779     }
1780 
1781     function _burn(uint256 tokenId) internal virtual {
1782         address owner = ownerOf(tokenId);
1783 
1784         _beforeTokenTransfers(owner, address(0), tokenId, 1);
1785 
1786         // Clear approvals
1787         _approve(address(0), tokenId, owner);
1788 
1789         // _balances[owner] -= 1; // ERC721
1790         // delete _owners[tokenId];  // ERC721
1791         _addressData[owner].balance -= 1;
1792         
1793         _ownerships[tokenId].addr = address(0);
1794         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1795         
1796         delete  _ownerships[tokenId];
1797 
1798         emit Transfer(owner, address(0), tokenId);
1799     }
1800 }
1801 
1802 
1803 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1804 
1805 pragma solidity ^0.8.0;
1806 
1807 
1808 
1809 /**
1810  * @title ERC721 Burnable Token
1811  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1812  */
1813 
1814  /*
1815 abstract contract ERC721Burnable is Context, ERC721A {
1816     /**
1817      * @dev Burns `tokenId`. See {ERC721-_burn}.
1818      *
1819      * Requirements:
1820      *
1821      * - T*
1822 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1823 
1824 pragma solidity ^0.8.0;
1825 
1826 /**
1827  * @dev Contract module that helps prevent reentrant calls to a function.
1828  *
1829  * Inhezriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1830  * available, which can be applied to functions to make sure there are no nested
1831  * (reentrant) calls to them.
1832  *
1833  * Note that because there is a single `nonReentrant` guard, functions marked as
1834  * `nonReentrant` may not call one another. This can be worked around by making
1835  * those functions `private`, and then adding `external` `nonReentrant` entry
1836  * points to them.
1837  *
1838  * TIP: If you would like to learn more about reentrancy and alternative ways
1839  * to protect against it, check out our blog post
1840  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1841  */
1842 
1843 
1844 abstract contract ReentrancyGuard {
1845     // Booleans are more expensive than uint256 or any type that takes up a full
1846     // word because each write operation emits an extra SLOAD to first read the
1847     // slot's contents, replace the bits taken up by the boolean, and then write
1848     // back. This is the compiler's defense against contract upgrades and
1849     // pointer aliasing, and it cannot be disabled.
1850 
1851     // The values being non-zero value makes deployment a bit more expensive,
1852     // but in exchange the refund on every call to nonReentrant will be lower in
1853     // amount. Since refunds are capped to a percentage of the total
1854     // transaction's gas, it is best to keep them low in cases like this one, to
1855     // increase the likelihood of the full refund coming into effect.
1856     uint256 private constant _NOT_ENTERED = 1;
1857     uint256 private constant _ENTERED = 2;
1858 
1859     uint256 private _status;
1860 
1861     constructor() {
1862         _status = _NOT_ENTERED;
1863     }
1864 
1865     /**
1866      * @dev Prevents a contract from calling itself, directly or indirectly.
1867      * Calling a `nonReentrant` function from another `nonReentrant`
1868      * function is not supported. It is possible to prevent this from happening
1869      * by making the `nonReentrant` function external, and making it call a
1870      * `private` function that does the actual work.
1871      */
1872     modifier nonReentrant() {
1873         // On the first call to nonReentrant, _notEntered will be true
1874         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1875 
1876         // Any calls to nonReentrant after this point will fail
1877         _status = _ENTERED;
1878 
1879         _;
1880 
1881         // By storing the original value once again, a refund is triggered (see
1882         // https://eips.ethereum.org/EIPS/eip-2200)
1883         _status = _NOT_ENTERED;
1884     }
1885 }
1886 
1887 pragma solidity ^0.8.0;
1888 
1889 contract AccessControl {
1890     mapping(bytes32 => mapping(address => bool)) public roles; 
1891 
1892     bytes32 internal constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
1893     // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
1894     bytes32 internal constant TEAM = keccak256(abi.encodePacked("TEAM"));
1895     // 0x9b82d2f38fbdf13006bfa741767f793d917e063392737837b580c1c2b1e0bab3
1896 
1897     modifier onlyRole(bytes32 _role) {
1898         require(roles[_role][msg.sender], " not authorized");
1899         _;
1900     }
1901 
1902     constructor(){
1903         _grantRole(ADMIN, msg.sender);
1904     }
1905 
1906     function _grantRole(bytes32 _role, address _account) internal {
1907         roles[_role][_account] = true;
1908     }
1909 
1910     function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN){
1911         _grantRole(_role, _account);
1912     }
1913 
1914     function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN){
1915          roles[_role][_account] = false;
1916     }
1917 
1918 
1919 }
1920 
1921 pragma solidity ^0.8.2;
1922 
1923 contract wazzup is ERC721A,  ReentrancyGuard, AccessControl {  
1924     using Strings for uint256;
1925     string public _partslink;
1926     string public _goldlink;
1927     string public _diamondlink;
1928     string public unrevealedTokenUri;
1929     address treasury = 0x1405A3B36E7dc20c53541F4078Da28652Bf2A3Ad;
1930     bool public isOpen = false;
1931     bool public isOpen1 = false;
1932     bool public isOpen5 = false;
1933     bool public isRevealed = false;
1934     uint256 public maxSupply = 2222;
1935     uint256 public newmaxSupply = 3222;
1936     uint256 public maxToMint = 3;
1937     uint256 public maxForList5 = 5;
1938     uint256 public price = 0.10 ether;
1939     mapping(address => uint256) public howmany;
1940     mapping(address => uint256) public howmanyList1;
1941     mapping(address => uint256) public howmanyList5;
1942     mapping(address => uint256) public howmanyNew;
1943     mapping(uint256 => bool) public isGold;
1944     mapping(uint256 => bool) public isDiamond;      
1945 
1946     bytes32 public root1;
1947     bytes32 public root5;
1948    
1949 	constructor() ERC721A("wazzzup.wtf", "WAZA") {
1950         unrevealedTokenUri = "ar://icjZER6w3kMqmtX3jqQ6JiE4kCfpzvUSYMRnyNRQKSc";
1951     }
1952 
1953     function _baseURI() internal view virtual override returns (string memory) {
1954         return _partslink;
1955     }
1956 
1957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1958         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1959 
1960         string memory baseURI;
1961         baseURI = _partslink;
1962         
1963         if (isGold[tokenId]) {
1964             baseURI = _goldlink;
1965         }
1966         if (isDiamond[tokenId]) {
1967             baseURI = _diamondlink;
1968         }
1969         if (isRevealed) {
1970         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : '';
1971         }
1972         else {
1973             return unrevealedTokenUri;
1974         }
1975     }
1976 
1977     function isWhiteListed5(address account, bytes32[] calldata proof) internal view returns(bool) {
1978         return _verify5(_leaf(account), proof);
1979     }
1980 
1981     function isWhiteListed1(address account, bytes32[] calldata proof) internal view returns(bool) {
1982         return _verify1(_leaf(account), proof);
1983     }
1984 
1985     function mintList5(uint256 _amount, bytes32[] calldata proof) external payable {
1986         require(isOpen5,"whitelist mint not open");
1987         require(isWhiteListed5(msg.sender, proof), "Not on the whitelist");
1988         uint256 totSupply = totalSupply();
1989         require(totSupply + _amount <= maxSupply);
1990         require(msg.sender == tx.origin);
1991     	require(howmanyList5[msg.sender] + _amount <= maxForList5,"mint limit reach");
1992         _safeMint(msg.sender, _amount);
1993         howmanyList5[msg.sender] += _amount;
1994     }
1995 
1996     function mintList1(uint256 _amount, bytes32[] calldata proof) external payable {
1997         require(isOpen1,"whitelist mint not open");
1998         require(isWhiteListed1(msg.sender, proof), "Not on the whitelist");
1999         uint256 totSupply = totalSupply();
2000         require(totSupply + _amount <= maxSupply);
2001         require(msg.sender == tx.origin);
2002     	require(howmanyList1[msg.sender] + _amount <= 1,"mint limit reach");
2003         _safeMint(msg.sender, _amount);
2004         howmanyList1[msg.sender] += _amount;
2005     }
2006 
2007     function setRoot5(bytes32 _root) external onlyOwner {
2008         root5 = _root;
2009     }
2010 
2011      function setRoot1(bytes32 _root) external onlyOwner {
2012         root1 = _root;
2013     }
2014 
2015     function _leaf(address account) internal pure returns(bytes32) {
2016         return keccak256(abi.encodePacked(account));
2017     }
2018 
2019     function _verify5(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
2020         return MerkleProof.verify(proof, root5, leaf);
2021     }
2022 
2023     function _verify1(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
2024         return MerkleProof.verify(proof, root1, leaf);
2025     }
2026 
2027  	function mintWazza(uint256 _amount) external nonReentrant {
2028   	    uint256 totSupply = totalSupply();
2029         require(isOpen,"mint not open");
2030         require(totSupply + _amount <= maxSupply,"sold out");
2031         require(msg.sender == tx.origin);
2032     	require(howmany[msg.sender] + _amount <= maxToMint,"mint limit reach");
2033         _safeMint(msg.sender, _amount);
2034         howmany[msg.sender] += _amount;
2035     }
2036 
2037  	function makeItFly(address happyfew, uint256 _amount) public onlyOwner {
2038   	    uint256 totSupply = totalSupply();
2039 	    require(totSupply + _amount <= maxSupply);
2040         _safeMint(happyfew, _amount);
2041     }
2042 
2043     function mintNewOnes(uint256 _amount) external payable nonReentrant {
2044         uint256 totSupply = totalSupply();
2045         require(isOpen, "mint not open");
2046         require(totSupply + _amount > maxSupply);
2047         require(totSupply + _amount <= newmaxSupply,"sold out");
2048         require(price * _amount <= msg.value,"not enough eth sent");
2049         require(msg.sender == tx.origin);
2050         require(howmanyNew[msg.sender] + _amount <= maxToMint,"mint limit reach");
2051         _safeMint(msg.sender, _amount);
2052         howmanyNew[msg.sender] += _amount;
2053     }
2054 
2055     function setMaxSupply(uint256 _max) external onlyOwner {
2056         maxSupply = _max;  
2057     }
2058 
2059     function setNewSupply(uint256 _max) external onlyOwner {
2060         newmaxSupply = _max;  
2061     }
2062 
2063     function setMaxForList5(uint256 _max) external onlyOwner {
2064         maxForList5 = _max;  
2065     }
2066 
2067     function addToGoldList(uint256 _id) external onlyRole(TEAM) {
2068         isGold[_id] = true;
2069     }
2070 
2071     function addToDiamondList(uint256 _id) external onlyRole(TEAM) {
2072         isDiamond[_id] = true;
2073     }
2074 
2075     function cancelfromGoldList(uint256 _id) external onlyRole(TEAM) {
2076         isGold[_id] = false;
2077     }
2078 
2079     function cancelfromDiamondList(uint256 _id) external onlyRole(TEAM) {
2080         isDiamond[_id] = false;
2081     }
2082 
2083     function toggleOpen() external onlyOwner {
2084         isOpen = !isOpen;
2085     }
2086 
2087     function toggleOpen1() external onlyOwner {
2088         isOpen1 = !isOpen1;
2089     }
2090 
2091     function toggleOpen5() external onlyOwner {
2092         isOpen5 = !isOpen5;
2093     }
2094 
2095     function togglereveal() external onlyOwner {
2096         isRevealed = !isRevealed;
2097     }
2098 
2099     function increaseMintLimit(uint256 _limit) external onlyOwner {
2100         maxToMint = _limit;
2101     }
2102 
2103     function setMintPriceinCents(uint256 _pricecents) external onlyOwner {
2104         price = _pricecents * 1e16;
2105     }
2106 
2107     function seturi(string memory uri_) external onlyOwner {
2108         _partslink = uri_;
2109     }
2110 
2111     function setGolduri(string memory uri_) external onlyOwner {
2112         _goldlink = uri_;
2113     }
2114 
2115     function setDiamonduri(string memory uri_) external onlyOwner {
2116         _diamondlink = uri_;
2117     }
2118 
2119     function setUnrevealuri(string memory uri_) external onlyOwner {
2120         unrevealedTokenUri = uri_;
2121     }
2122 
2123     function setTreasury(address _addr) external onlyOwner {
2124         treasury = _addr;
2125     }
2126 
2127     function getfundsToOwner() public payable onlyOwner {
2128 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2129 		require(success);
2130 	}
2131 
2132     function withdraw() external  {
2133         require(address(this).balance > 0, "0 balance");
2134         uint256 balance = address(this).balance;
2135         Address.sendValue(payable(treasury), balance);
2136     }
2137 
2138 
2139     function burn(uint256 tokenId) public virtual onlyOwner {
2140         //solhint-disable-next-line max-line-length
2141       //  require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2142         _burn(tokenId);
2143     }
2144 }