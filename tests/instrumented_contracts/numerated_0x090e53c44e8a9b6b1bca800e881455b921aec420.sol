1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-16
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity =0.6.11;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @dev These functions deal with verification of Merkle trees (hash trees),
84  */
85 library MerkleProof {
86     /**
87      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
88      * defined by `root`. For this, a `proof` must be provided, containing
89      * sibling hashes on the branch from the leaf to the root of the tree. Each
90      * pair of leaves and each pair of pre-images are assumed to be sorted.
91      */
92     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
93         bytes32 computedHash = leaf;
94 
95         for (uint256 i = 0; i < proof.length; i++) {
96             bytes32 proofElement = proof[i];
97 
98             if (computedHash <= proofElement) {
99                 // Hash(current computed hash + current element of the proof)
100                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
101             } else {
102                 // Hash(current element of the proof + current computed hash)
103                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
104             }
105         }
106 
107         // Check if the computed hash (root) is equal to the provided root
108         return computedHash == root;
109     }
110 }
111 
112 // Allows anyone to claim a token if they exist in a merkle root.
113 interface IMerkleDistributor {
114     // Returns the address of the token distributed by this contract.
115     function token() external view returns (address);
116     // Returns the merkle root of the merkle tree containing account balances available to claim.
117     function merkleRoot() external view returns (bytes32);
118     // Returns true if the index has been marked claimed.
119     function isClaimed(uint256 index) external view returns (bool);
120     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
121     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
122 
123     // This event is triggered whenever a call to #claim succeeds.
124     event Claimed(uint256 index, address account, uint256 amount);
125 }
126 
127 contract MerkleDistributor is IMerkleDistributor {
128     address public immutable override token;
129     bytes32 public immutable override merkleRoot;
130 
131     // This is a packed array of booleans.
132     mapping(uint256 => uint256) private claimedBitMap;
133 
134     constructor(address token_, bytes32 merkleRoot_) public {
135         token = token_;
136         merkleRoot = merkleRoot_;
137     }
138 
139     function isClaimed(uint256 index) public view override returns (bool) {
140         uint256 claimedWordIndex = index / 256;
141         uint256 claimedBitIndex = index % 256;
142         uint256 claimedWord = claimedBitMap[claimedWordIndex];
143         uint256 mask = (1 << claimedBitIndex);
144         return claimedWord & mask == mask;
145     }
146 
147     function _setClaimed(uint256 index) private {
148         uint256 claimedWordIndex = index / 256;
149         uint256 claimedBitIndex = index % 256;
150         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
151     }
152 
153     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
154         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
155 
156         // Verify the merkle proof.
157         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
158         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
159 
160         // Mark it claimed and send the token.
161         _setClaimed(index);
162         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
163 
164         emit Claimed(index, account, amount);
165     }
166 }