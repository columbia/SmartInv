1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 interface Token {
5     function transfer(address recipient, uint256 amount) external returns (bool);
6 }
7 
8 // MerkleDistributor for ongoing EPS airdrop to veCRV holders
9 // Based on the EMN refund contract by banteg - https://github.com/banteg/your-eminence
10 contract MerkleDistributor {
11 
12     bytes32[] public merkleRoots;
13     bytes32 public pendingMerkleRoot;
14     uint256 public lastRoot;
15 
16     // admin address which can propose adding a new merkle root
17     address public proposalAuthority;
18     // admin address which approves or rejects a proposed merkle root
19     address public reviewAuthority;
20 
21     event Claimed(
22         uint256 merkleIndex,
23         uint256 index,
24         address account,
25         uint256 amount
26     );
27 
28     // This is a packed array of booleans.
29     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
30     Token public tokenContract;
31 
32     constructor(address _authority, Token _tokenContract) {
33         proposalAuthority = _authority;
34         reviewAuthority = _authority;
35         tokenContract = _tokenContract;
36     }
37 
38     function setProposalAuthority(address _account) public {
39         require(msg.sender == proposalAuthority);
40         proposalAuthority = _account;
41     }
42 
43     function setReviewAuthority(address _account) public {
44         require(msg.sender == reviewAuthority);
45         reviewAuthority = _account;
46     }
47 
48     // Each week, the proposal authority calls to submit the merkle root for a new airdrop.
49     function proposewMerkleRoot(bytes32 _merkleRoot) public {
50         require(msg.sender == proposalAuthority);
51         require(pendingMerkleRoot == 0x00);
52         require(merkleRoots.length < 52);
53         // require(block.timestamp > lastRoot + 604800);
54         pendingMerkleRoot = _merkleRoot;
55     }
56 
57     // After validating the correctness of the pending merkle root, the reviewing authority
58     // calls to confirm it and the distribution may begin.
59     function reviewPendingMerkleRoot(bool _approved) public {
60         require(msg.sender == reviewAuthority);
61         require(pendingMerkleRoot != 0x00);
62         if (_approved) {
63             merkleRoots.push(pendingMerkleRoot);
64             lastRoot = block.timestamp / 604800 * 604800;
65         }
66         delete pendingMerkleRoot;
67     }
68 
69     function isClaimed(uint256 merkleIndex, uint256 index) public view returns (bool) {
70         uint256 claimedWordIndex = index / 256;
71         uint256 claimedBitIndex = index % 256;
72         uint256 claimedWord = claimedBitMap[merkleIndex][claimedWordIndex];
73         uint256 mask = (1 << claimedBitIndex);
74         return claimedWord & mask == mask;
75     }
76 
77     function _setClaimed(uint256 merkleIndex, uint256 index) private {
78         uint256 claimedWordIndex = index / 256;
79         uint256 claimedBitIndex = index % 256;
80         claimedBitMap[merkleIndex][claimedWordIndex] = claimedBitMap[merkleIndex][claimedWordIndex] | (1 << claimedBitIndex);
81     }
82 
83     function claim(uint256 merkleIndex, uint256 index, uint256 amount, bytes32[] calldata merkleProof) external {
84         require(merkleIndex < merkleRoots.length, "MerkleDistributor: Invalid merkleIndex");
85         require(!isClaimed(merkleIndex, index), 'MerkleDistributor: Drop already claimed.');
86 
87         // Verify the merkle proof.
88         bytes32 node = keccak256(abi.encodePacked(index, msg.sender, amount));
89         require(verify(merkleProof, merkleRoots[merkleIndex], node), 'MerkleDistributor: Invalid proof.');
90 
91         // Mark it claimed and send the token.
92         _setClaimed(merkleIndex, index);
93         tokenContract.transfer(msg.sender, amount  * (10**18));
94 
95         emit Claimed(merkleIndex, index, msg.sender, amount);
96     }
97 
98     function verify(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
99         bytes32 computedHash = leaf;
100 
101         for (uint256 i = 0; i < proof.length; i++) {
102             bytes32 proofElement = proof[i];
103 
104             if (computedHash <= proofElement) {
105                 // Hash(current computed hash + current element of the proof)
106                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
107             } else {
108                 // Hash(current element of the proof + current computed hash)
109                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
110             }
111         }
112 
113         // Check if the computed hash (root) is equal to the provided root
114         return computedHash == root;
115     }
116 
117 }