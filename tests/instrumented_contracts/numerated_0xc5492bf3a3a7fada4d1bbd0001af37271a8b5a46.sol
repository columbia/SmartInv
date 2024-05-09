1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: IMintableAirdrop
8 
9 interface IMintableAirdrop {
10 
11   function mintAirdrops(
12     address _owner,
13     uint256 _amount,
14     uint256 _upfront,
15     uint256 _start,
16     uint256 _end) external returns(uint256);
17 }
18 
19 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/MerkleProof
20 
21 /**
22  * @dev These functions deal with verification of Merkle trees (hash trees),
23  */
24 library MerkleProof {
25     /**
26      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
27      * defined by `root`. For this, a `proof` must be provided, containing
28      * sibling hashes on the branch from the leaf to the root of the tree. Each
29      * pair of leaves and each pair of pre-images are assumed to be sorted.
30      */
31     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
32         bytes32 computedHash = leaf;
33 
34         for (uint256 i = 0; i < proof.length; i++) {
35             bytes32 proofElement = proof[i];
36 
37             if (computedHash <= proofElement) {
38                 // Hash(current computed hash + current element of the proof)
39                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
40             } else {
41                 // Hash(current element of the proof + current computed hash)
42                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
43             }
44         }
45 
46         // Check if the computed hash (root) is equal to the provided root
47         return computedHash == root;
48     }
49 }
50 
51 // File: MerkleMinter.sol
52 
53 contract MerkleMinter {
54   using MerkleProof for bytes32[];
55 
56   IMintableAirdrop public toAirdrop;
57 
58   bytes32 public merkleRoot;
59   mapping(uint256 => uint256) public claimedBitMap;
60   uint256 public start;
61   uint256 public end;
62   uint256 upfrontDivisor;
63 
64 
65   event Claimed(uint256 index, address account, uint256 amount);
66 
67   constructor(address _toAirdrop, bytes32 _root, uint256 _start, uint256 _end, uint _upfrontDivisor) public {
68     toAirdrop = IMintableAirdrop(_toAirdrop);
69     merkleRoot = _root;
70     start = _start;
71     end = _end;
72     upfrontDivisor = _upfrontDivisor;
73   }
74 
75 
76   function isClaimed(uint256 _index) public view returns(bool) {
77     uint256 wordIndex = _index / 256;
78     uint256 bitIndex = _index % 256;
79     uint256 word = claimedBitMap[wordIndex];
80     uint256 bitMask = 1 << bitIndex;
81     return word & bitMask == bitMask;
82   }
83 
84   function _setClaimed(uint256 _index) internal {
85     uint256 wordIndex = _index / 256;
86     uint256 bitIndex = _index % 256;
87     claimedBitMap[wordIndex] |= 1 << bitIndex;
88   }
89 
90   function claim(address account, uint256 _index, uint256 _amount, bytes32[] memory _proof) external {
91     require(!isClaimed(_index), "Claimed already");
92 
93     bytes32 node = keccak256(abi.encodePacked(_index, account, _amount));
94     require(_proof.verify(merkleRoot, node), "Wrong proof");
95 
96     _setClaimed(_index);
97     uint256 upfront = _amount / upfrontDivisor;
98     uint256 adjustedAmount = _amount - upfront;
99 
100     toAirdrop.mintAirdrops(account, adjustedAmount, upfront, start, end);
101     emit Claimed(_index, account, _amount);
102   }
103 }
