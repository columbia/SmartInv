1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.7.4;
4 
5 
6 
7 // Part: IMerkleDistributor
8 
9 // Allows anyone to claim a token if they exist in a merkle root.
10 interface IMerkleDistributor {
11     // Returns the address of the token distributed by this contract.
12     function token() external view returns (address);
13     // Returns the merkle root of the merkle tree containing account balances available to claim.
14     function merkleRoot() external view returns (bytes32);
15     // Returns true if the index has been marked claimed.
16     function isClaimed(uint256 index) external view returns (bool);
17     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
18     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
19 
20     // This event is triggered whenever a call to #claim succeeds.
21     event Claimed(uint256 index, address account, uint256 amount);
22 }
23 
24 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC20
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/MerkleProof
101 
102 /**
103  * @dev These functions deal with verification of Merkle trees (hash trees),
104  */
105 library MerkleProof {
106     /**
107      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
108      * defined by `root`. For this, a `proof` must be provided, containing
109      * sibling hashes on the branch from the leaf to the root of the tree. Each
110      * pair of leaves and each pair of pre-images are assumed to be sorted.
111      */
112     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
113         bytes32 computedHash = leaf;
114 
115         for (uint256 i = 0; i < proof.length; i++) {
116             bytes32 proofElement = proof[i];
117 
118             if (computedHash <= proofElement) {
119                 // Hash(current computed hash + current element of the proof)
120                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
121             } else {
122                 // Hash(current element of the proof + current computed hash)
123                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
124             }
125         }
126 
127         // Check if the computed hash (root) is equal to the provided root
128         return computedHash == root;
129     }
130 }
131 
132 // File: MerkleDistributor.sol
133 
134 contract MerkleDistributor is IMerkleDistributor {
135     address public immutable override token;
136     bytes32 public immutable override merkleRoot;
137 
138     // This is a packed array of booleans.
139     mapping(uint256 => uint256) private claimedBitMap;
140 
141     constructor(address token_, bytes32 merkleRoot_) public {
142         token = token_;
143         merkleRoot = merkleRoot_;
144     }
145 
146     function isClaimed(uint256 index) public view override returns (bool) {
147         uint256 claimedWordIndex = index / 256;
148         uint256 claimedBitIndex = index % 256;
149         uint256 claimedWord = claimedBitMap[claimedWordIndex];
150         uint256 mask = (1 << claimedBitIndex);
151         return claimedWord & mask == mask;
152     }
153 
154     function _setClaimed(uint256 index) private {
155         uint256 claimedWordIndex = index / 256;
156         uint256 claimedBitIndex = index % 256;
157         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
158     }
159 
160     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
161         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
162 
163         // Verify the merkle proof.
164         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
165         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
166 
167         // Mark it claimed and send the token.
168         _setClaimed(index);
169         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
170 
171         emit Claimed(index, account, amount);
172     }
173 }
