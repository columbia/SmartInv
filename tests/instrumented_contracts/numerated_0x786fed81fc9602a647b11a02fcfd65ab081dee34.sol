1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin\contracts\cryptography\MerkleProof.sol
82 
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev These functions deal with verification of Merkle trees (hash trees),
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
96         bytes32 computedHash = leaf;
97 
98         for (uint256 i = 0; i < proof.length; i++) {
99             bytes32 proofElement = proof[i];
100 
101             if (computedHash <= proofElement) {
102                 // Hash(current computed hash + current element of the proof)
103                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
104             } else {
105                 // Hash(current element of the proof + current computed hash)
106                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
107             }
108         }
109 
110         // Check if the computed hash (root) is equal to the provided root
111         return computedHash == root;
112     }
113 }
114 
115 // File: contracts\interfaces\IMerkleDistributor.sol
116 
117 pragma solidity >=0.5.0;
118 
119 // Allows anyone to claim a token if they exist in a merkle root.
120 interface IMerkleDistributor {
121     // Returns the address of the token distributed by this contract.
122     function token() external view returns (address);
123     // Returns the merkle root of the merkle tree containing account balances available to claim.
124     function merkleRoot() external view returns (bytes32);
125     // Returns true if the index has been marked claimed.
126     function isClaimed(uint256 index) external view returns (bool);
127     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
128     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
129 
130     // This event is triggered whenever a call to #claim succeeds.
131     event Claimed(uint256 index, address account, uint256 amount);
132 }
133 
134 // File: contracts\MerkleDistributor.sol
135 
136 pragma solidity 0.6.12;
137 
138 contract MerkleDistributor is IMerkleDistributor {
139     address public immutable override token;
140     bytes32 public immutable override merkleRoot;
141 
142     // This is a packed array of booleans.
143     mapping(uint256 => uint256) private claimedBitMap;
144 
145     constructor(address token_, bytes32 merkleRoot_) public {
146         token = token_;
147         merkleRoot = merkleRoot_;
148     }
149 
150     function isClaimed(uint256 index) public view override returns (bool) {
151         uint256 claimedWordIndex = index / 256;
152         uint256 claimedBitIndex = index % 256;
153         uint256 claimedWord = claimedBitMap[claimedWordIndex];
154         uint256 mask = (1 << claimedBitIndex);
155         return claimedWord & mask == mask;
156     }
157 
158     function _setClaimed(uint256 index) private {
159         uint256 claimedWordIndex = index / 256;
160         uint256 claimedBitIndex = index % 256;
161         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
162     }
163 
164     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
165         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
166 
167         // Verify the merkle proof.
168         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
169         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
170 
171         // Mark it claimed and send the token.
172         _setClaimed(index);
173         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
174 
175         emit Claimed(index, account, amount);
176     }
177 }