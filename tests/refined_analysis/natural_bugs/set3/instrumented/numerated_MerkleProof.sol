1 // SPDX-License-Identifier: MIT
2 // Taken from https://github.com/ensdomains/governance/blob/master/contracts/MerkleProof.sol
3 
4 pragma solidity 0.8.10;
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
21      * the returned `index` is not the leaf order index, it's more like a unique identifier
22      * for that leaf
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool, uint256) {
29         bytes32 computedHash = leaf;
30         uint256 index = 0;
31 
32         for (uint256 i = 0; i < proof.length; i++) {
33             index *= 2;
34             bytes32 proofElement = proof[i];
35 
36             if (computedHash <= proofElement) {
37                 // Hash(current computed hash + current element of the proof)
38                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
39             } else {
40                 // Hash(current element of the proof + current computed hash)
41                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
42                 index += 1;
43             }
44         }
45 
46         // Check if the computed hash (root) is equal to the provided root
47         return (computedHash == root, index);
48     }
49 }
