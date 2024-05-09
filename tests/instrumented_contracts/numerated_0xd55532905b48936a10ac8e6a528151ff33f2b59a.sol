1 // SPDX-License-Identifier: MIT
2 // File: contracts/interfaces/IMerkleDistributor.sol
3 
4 pragma solidity ^0.8.0;
5 
6 // Allows anyone to claim a token if they exist in a merkle root.
7 interface IMerkleDistributor {
8     // Returns the address of the token distributed by this contract.
9     function token() external view returns (address);
10     // Returns the merkle root of the merkle tree containing account balances available to claim.
11     function merkleRoot() external view returns (bytes32);
12     // Returns true if the index has been marked claimed.
13     function isClaimed(uint256 index) external view returns (bool);
14     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
15     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
16 
17     // This event is triggered whenever a call to #claim succeeds.
18     event Claimed(uint256 index, address account, uint256 amount);
19 }
20 // File: contracts/libs/MerkleProof.sol
21 
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev These functions deal with verification of Merkle Trees proofs.
27  *
28  * The proofs can be generated using the JavaScript library
29  * https://github.com/miguelmota/merkletreejs[merkletreejs].
30  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
31  *
32  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
33  */
34 library MerkleProof {
35     /**
36      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
37      * defined by `root`. For this, a `proof` must be provided, containing
38      * sibling hashes on the branch from the leaf to the root of the tree. Each
39      * pair of leaves and each pair of pre-images are assumed to be sorted.
40      */
41     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
42         bytes32 computedHash = leaf;
43 
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46 
47             if (computedHash <= proofElement) {
48                 // Hash(current computed hash + current element of the proof)
49                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
53             }
54         }
55 
56         // Check if the computed hash (root) is equal to the provided root
57         return computedHash == root;
58     }
59 }
60 // File: contracts/interfaces/IERC20.sol
61 
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Interface of the ERC20 standard as defined in the EIP.
67  */
68 interface IERC20 {
69     /**
70      * @dev Returns the amount of tokens in existence.
71      */
72     function totalSupply() external view returns (uint256);
73 
74     /**
75      * @dev Returns the amount of tokens owned by `account`.
76      */
77     function balanceOf(address account) external view returns (uint256);
78 
79     /**
80      * @dev Moves `amount` tokens from the caller's account to `recipient`.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transfer(address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Returns the remaining number of tokens that `spender` will be
90      * allowed to spend on behalf of `owner` through {transferFrom}. This is
91      * zero by default.
92      *
93      * This value changes when {approve} or {transferFrom} are called.
94      */
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     /**
98      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * IMPORTANT: Beware that changing an allowance with this method brings the risk
103      * that someone may use both the old and the new allowance by unfortunate
104      * transaction ordering. One possible solution to mitigate this race
105      * condition is to first reduce the spender's allowance to 0 and set the
106      * desired value afterwards:
107      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address spender, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Moves `amount` tokens from `sender` to `recipient` using the
115      * allowance mechanism. `amount` is then deducted from the caller's
116      * allowance.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 // File: contracts/MetisTokenDistributor.sol
139 
140 pragma solidity ^0.8.0;
141 
142 
143 
144 
145 contract MetisTokenDistributor is IMerkleDistributor {
146     address public immutable override token;
147     bytes32 public immutable override merkleRoot;
148 
149     // This is a packed array of booleans.
150     mapping(uint256 => uint256) private claimedBitMap;
151 
152     constructor(address token_, bytes32 merkleRoot_) {
153         token = token_;
154         merkleRoot = merkleRoot_;
155     }
156 
157     function isClaimed(uint256 index) public view override returns (bool) {
158         uint256 claimedWordIndex = index / 256;
159         uint256 claimedBitIndex = index % 256;
160         uint256 claimedWord = claimedBitMap[claimedWordIndex];
161         uint256 mask = (1 << claimedBitIndex);
162         return claimedWord & mask == mask;
163     }
164 
165     function _setClaimed(uint256 index) private {
166         uint256 claimedWordIndex = index / 256;
167         uint256 claimedBitIndex = index % 256;
168         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
169     }
170 
171     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
172         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
173 
174         // Verify the merkle proof.
175         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
176         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
177 
178         // Mark it claimed and send the token.
179         _setClaimed(index);
180         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
181 
182         emit Claimed(index, account, amount);
183     }
184 }