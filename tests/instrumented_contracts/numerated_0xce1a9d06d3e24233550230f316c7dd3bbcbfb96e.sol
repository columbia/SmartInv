1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: contracts/LeAnime2Simplified_RELEASEDAY/Merkle_1_Multiple.sol
57 
58 
59 pragma solidity ^0.8.10;
60 
61 
62 interface IWrapper {
63     function mintSpirits(address account, uint256[] calldata tokenId) external;
64 }
65 
66 contract Spirits_MerkleClaim {  // Merkle Root Final = 0x14e17a04e8f074c2ed318767ec9a6a75acbdceecb41d66db1802ce2bf99c16e2
67     address immutable public wrapperContract;
68     bytes32 immutable public merkleRoot;
69 
70     constructor(address contractAddress, bytes32 root) {
71         wrapperContract = contractAddress;
72         merkleRoot = root;
73     }
74 
75     function claimSpirit(address account, uint256[] calldata tokenId, bytes32[] calldata proof)
76     external
77     {
78         
79         require(_verify(_leaf(account, tokenId), proof), "Invalid merkle proof");
80 
81         IWrapper(wrapperContract).mintSpirits(account, tokenId);
82         
83     }
84 
85     function _leaf(address account, uint256[] calldata tokenId)
86     internal pure returns (bytes32)
87     {
88         return keccak256(abi.encodePacked(tokenId, account));
89     }
90 
91     function _verify(bytes32 leaf, bytes32[] memory proof)
92     internal view returns (bool)
93     {
94         return MerkleProof.verify(proof, merkleRoot, leaf);
95     }
96 
97 
98 }