1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-10
3 */
4 
5 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity =0.6.11;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * // importANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 // Dependency file: @openzeppelin/contracts/cryptography/MerkleProof.sol
87 // pragma solidity ^0.6.0;
88 
89 /**
90  * @dev These functions deal with verification of Merkle trees (hash trees),
91  */
92 library MerkleProof {
93     /**
94      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
95      * defined by `root`. For this, a `proof` must be provided, containing
96      * sibling hashes on the branch from the leaf to the root of the tree. Each
97      * pair of leaves and each pair of pre-images are assumed to be sorted.
98      */
99     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
100         bytes32 computedHash = leaf;
101 
102         for (uint256 i = 0; i < proof.length; i++) {
103             bytes32 proofElement = proof[i];
104 
105             if (computedHash <= proofElement) {
106                 // Hash(current computed hash + current element of the proof)
107                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
108             } else {
109                 // Hash(current element of the proof + current computed hash)
110                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
111             }
112         }
113 
114         // Check if the computed hash (root) is equal to the provided root
115         return computedHash == root;
116     }
117 }
118 
119 
120 // Dependency file: contracts/interfaces/IMerkleDistributor.sol
121 // pragma solidity >=0.5.0;
122 
123 // Allows anyone to claim a token if they exist in a merkle root.
124 interface IMerkleDistributor {
125     // Returns the address of the token distributed by this contract.
126     function token() external view returns (address);
127     // Returns the merkle root of the merkle tree containing account balances available to claim.
128     function merkleRoot() external view returns (bytes32);
129     // Returns true if the index has been marked claimed.
130     function isClaimed(uint256 index) external view returns (bool);
131     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
132     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
133 
134     // This event is triggered whenever a call to #claim succeeds.
135     event Claimed(uint256 index, address account, uint256 amount);
136 }
137 
138 // Root file: contracts/MerkleDistributor.sol
139 
140 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
141 // import "@openzeppelin/contracts/cryptography/MerkleProof.sol";
142 // import "contracts/interfaces/IMerkleDistributor.sol";
143 
144 contract MerkleDistributor is IMerkleDistributor {
145     address public immutable override token;
146     bytes32 public immutable override merkleRoot;
147 
148     // This is a packed array of booleans.
149     mapping(uint256 => uint256) private claimedBitMap;
150 
151     constructor(address token_, bytes32 merkleRoot_) public {
152         token = token_;
153         merkleRoot = merkleRoot_;
154     }
155 
156     function isClaimed(uint256 index) public view override returns (bool) {
157         uint256 claimedWordIndex = index / 256;
158         uint256 claimedBitIndex = index % 256;
159         uint256 claimedWord = claimedBitMap[claimedWordIndex];
160         uint256 mask = (1 << claimedBitIndex);
161         return claimedWord & mask == mask;
162     }
163 
164     function _setClaimed(uint256 index) private {
165         uint256 claimedWordIndex = index / 256;
166         uint256 claimedBitIndex = index % 256;
167         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
168     }
169 
170     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
171         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
172 
173         // Verify the merkle proof.
174         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
175         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
176 
177         // Mark it claimed and send the token.
178         _setClaimed(index);
179         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
180 
181         emit Claimed(index, account, amount);
182     }
183 }