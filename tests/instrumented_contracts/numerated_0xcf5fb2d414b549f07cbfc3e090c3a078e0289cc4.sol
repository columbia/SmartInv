1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-25
3 */
4 
5 /**
6  *Submitted for verification at polygonscan.com on 2021-11-08
7 */
8 
9 // SPDX-License-Identifier: UNLICENSED
10 
11 pragma solidity 0.7.6;
12 
13 interface IERC20 {
14   /**
15    * @dev Moves `amount` tokens from the caller's account to `recipient`.
16    *
17    * Returns a boolean value indicating whether the operation succeeded.
18    *
19    * Emits a {Transfer} event.
20    */
21   function transfer(address recipient, uint256 amount) external returns (bool);
22 }
23 
24 
25 contract MerkleDistributor {
26   bytes32[] public merkleRoots;
27   bytes32 public pendingMerkleRoot;
28   uint256 public lastRoot;
29 
30 
31   address public constant rewardToken =0x8Ab17e2cd4F894F8641A31f99F673a5762F53c8e;
32   // admin address which can propose adding a new merkle root
33   address public proposalAuthority;
34   // admin address which approves or rejects a proposed merkle root
35   address public reviewAuthority;
36 
37   event Claimed(
38     uint256 merkleIndex,
39     uint256 index,
40     address account,
41     uint256 amount
42   );
43 
44   // This is a packed array of booleans.
45   mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
46 
47   constructor(address _proposalAuthority, address _reviewAuthority) public {
48     proposalAuthority = _proposalAuthority;
49     reviewAuthority = _reviewAuthority;
50   }
51 
52   function setProposalAuthority(address _account) public {
53     require(msg.sender == proposalAuthority);
54     proposalAuthority = _account;
55   }
56 
57   function setReviewAuthority(address _account) public {
58     require(msg.sender == reviewAuthority);
59     reviewAuthority = _account;
60   }
61 
62   // we modify time between two merkle to10hrs
63   function proposeMerkleRoot(bytes32 _merkleRoot) public {
64     require(msg.sender == proposalAuthority);
65     require(pendingMerkleRoot == 0x00);
66     require(block.timestamp > lastRoot + 36000);
67     pendingMerkleRoot = _merkleRoot;
68   }
69 
70   // After validating the correctness of the pending merkle root, the reviewing authority
71   // calls to confirm it and the distribution may begin.
72   function reviewPendingMerkleRoot(bool _approved) public {
73     require(msg.sender == reviewAuthority);
74     require(pendingMerkleRoot != 0x00);
75     if (_approved) {
76       merkleRoots.push(pendingMerkleRoot);
77       lastRoot = block.timestamp;
78     }
79     delete pendingMerkleRoot;
80   }
81 
82   function isClaimed(uint256 merkleIndex, uint256 index)
83     public
84     view
85     returns (bool)
86   {
87     uint256 claimedWordIndex = index / 256;
88     uint256 claimedBitIndex = index % 256;
89     uint256 claimedWord = claimedBitMap[merkleIndex][claimedWordIndex];
90     uint256 mask = (1 << claimedBitIndex);
91     return claimedWord & mask == mask;
92   }
93 
94   function _setClaimed(uint256 merkleIndex, uint256 index) private {
95     uint256 claimedWordIndex = index / 256;
96     uint256 claimedBitIndex = index % 256;
97     claimedBitMap[merkleIndex][claimedWordIndex] =
98       claimedBitMap[merkleIndex][claimedWordIndex] |
99       (1 << claimedBitIndex);
100   }
101 
102   function claim(
103     uint256 merkleIndex,
104     uint256 index,
105     uint256 amount,
106     bytes32[] calldata merkleProof
107   ) external {
108     require(
109       merkleIndex < merkleRoots.length,
110       'MerkleDistributor: Invalid merkleIndex'
111     );
112     require(
113       !isClaimed(merkleIndex, index),
114       'MerkleDistributor: Drop already claimed.'
115     );
116 
117     // Verify the merkle proof.
118     bytes32 node = keccak256(abi.encodePacked(index, msg.sender, amount));
119     require(
120       verify(merkleProof, merkleRoots[merkleIndex], node),
121       'MerkleDistributor: Invalid proof.'
122     );
123 
124     // Mark it claimed and send the token.
125     _setClaimed(merkleIndex, index);
126     IERC20(rewardToken).transfer(msg.sender, amount);
127 
128     emit Claimed(merkleIndex, index, msg.sender, amount);
129   }
130 
131   function verify(
132     bytes32[] memory proof,
133     bytes32 root,
134     bytes32 leaf
135   ) internal pure returns (bool) {
136     bytes32 computedHash = leaf;
137 
138     for (uint256 i = 0; i < proof.length; i++) {
139       bytes32 proofElement = proof[i];
140 
141       if (computedHash <= proofElement) {
142         // Hash(current computed hash + current element of the proof)
143         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
144       } else {
145         // Hash(current element of the proof + current computed hash)
146         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
147       }
148     }
149 
150     // Check if the computed hash (root) is equal to the provided root
151     return computedHash == root;
152   }
153 
154   function recoverFunds(address _token,uint256 _amount) public {
155     require(msg.sender == reviewAuthority);
156     IERC20(_token).transfer(msg.sender,_amount);
157     
158     }
159 }