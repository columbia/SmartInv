1 pragma solidity ^0.8.0;
2 
3 
4 // 
5 /**
6  * @dev These functions deal with verification of Merkle Trees proofs.
7  *
8  * The proofs can be generated using the JavaScript library
9  * https://github.com/miguelmota/merkletreejs[merkletreejs].
10  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
11  *
12  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
13  */
14 library MerkleProof {
15     /**
16      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
17      * defined by `root`. For this, a `proof` must be provided, containing
18      * sibling hashes on the branch from the leaf to the root of the tree. Each
19      * pair of leaves and each pair of pre-images are assumed to be sorted.
20      */
21     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
22         bytes32 computedHash = leaf;
23 
24         for (uint256 i = 0; i < proof.length; i++) {
25             bytes32 proofElement = proof[i];
26 
27             if (computedHash <= proofElement) {
28                 // Hash(current computed hash + current element of the proof)
29                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
30             } else {
31                 // Hash(current element of the proof + current computed hash)
32                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
33             }
34         }
35 
36         // Check if the computed hash (root) is equal to the provided root
37         return computedHash == root;
38     }
39 }
40 
41 interface IERC721Mintable {
42 	function claim(
43 		address to, 
44 		uint256 tokenId, 
45 		uint256 universeId, 
46 		uint256 earthId,
47 		uint256 personId, 
48 		uint256 blockchainId,
49 		uint256 sattoshiId) external returns (bool);
50 }
51 
52 contract MerkleDistribution {
53 	bytes32 public root;
54 	IERC721Mintable  public token;
55 	mapping (bytes32=>bool) claimedMap;
56 	
57 	event Claim(address, uint256);
58 
59 	constructor(address _token, bytes32 _root) public{
60 		token = IERC721Mintable(_token);
61 		root = _root;
62 	} 
63 
64 	function isClaimed(
65 		address _addr, 
66 		uint256 _id,
67 		uint256 _universeId,
68 		uint256 _earthId,
69 		uint256 _personId,
70 		uint256 _blockchainId,
71 		uint256 _sattoshiId )
72 		public view returns(bool){
73 		bytes32 node = keccak256(abi.encodePacked(_id, _universeId, _earthId, _personId, _blockchainId, _sattoshiId, _addr));
74 		return claimedMap[node];
75 	}
76 
77 	function setClaimed(bytes32 _node) private {
78 		claimedMap[_node] = true;
79 	}
80 
81 	function claim(
82 		address _addr, 
83 		uint256 _id,
84 		uint256 _universeId,
85 		uint256 _earthId,
86 		uint256 _personId,
87 		uint256 _blockchainId,
88 		uint256 _sattoshiId,
89 		bytes32[] calldata merkleProof) external {
90 		bytes32 node = keccak256(abi.encodePacked(_id, _universeId, _earthId, _personId, _blockchainId, _sattoshiId, _addr));
91 		require(!claimedMap[node], "token id of this address is already claimed");
92 		require(MerkleProof.verify(merkleProof, root, node), "MerkleDistribution: Invalid Proof");
93 		setClaimed(node);
94 		require(token.claim(_addr, _id, _universeId, _earthId, _personId, _blockchainId, _sattoshiId), "MerkleDistribution: Mint Failed");
95 		emit Claim(_addr, _id);
96 	}
97 }