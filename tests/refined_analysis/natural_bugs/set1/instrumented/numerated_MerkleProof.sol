1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev These functions deal with verification of Merkle Trees proofs.
8  *
9  * The proofs can be generated using the JavaScript library
10  * https://github.com/miguelmota/merkletreejs[merkletreejs].
11  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
12  *
13  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
14  */
15 library MerkleProof {
16     /**
17      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
18      * defined by `root`. For this, a `proof` must be provided, containing
19      * sibling hashes on the branch from the leaf to the root of the tree. Each
20      * pair of leaves and each pair of pre-images are assumed to be sorted.
21      */
22     function verify(
23         bytes32[] memory proof,
24         bytes32 root,
25         bytes32 leaf
26     ) internal pure returns (bool) {
27         return processProof(proof, leaf) == root;
28     }
29 
30     /**
31      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
32      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
33      * hash matches the root of the tree. When processing the proof, the pairs
34      * of leafs & pre-images are assumed to be sorted.
35      *
36      * _Available since v4.4._
37      */
38     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
39         bytes32 computedHash = leaf;
40         for (uint256 i = 0; i < proof.length; i++) {
41             bytes32 proofElement = proof[i];
42             if (computedHash <= proofElement) {
43                 // Hash(current computed hash + current element of the proof)
44                 computedHash = _efficientHash(computedHash, proofElement);
45             } else {
46                 // Hash(current element of the proof + current computed hash)
47                 computedHash = _efficientHash(proofElement, computedHash);
48             }
49         }
50         return computedHash;
51     }
52 
53     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
54         assembly {
55             mstore(0x00, a)
56             mstore(0x20, b)
57             value := keccak256(0x00, 0x40)
58         }
59     }
60 }
