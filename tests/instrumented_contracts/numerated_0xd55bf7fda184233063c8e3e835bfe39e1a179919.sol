1 // Borrowed MerkleDistributor for airdropped tokens used by Pickle for CORN and Uniswap for UNI
2 
3 // SPDX-License-Identifier: UNLICENSED
4 pragma solidity =0.6.6;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 
82 
83 
84 /**
85  * @dev These functions deal with verification of Merkle trees (hash trees),
86  */
87 library MerkleProof {
88     /**
89      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
90      * defined by `root`. For this, a `proof` must be provided, containing
91      * sibling hashes on the branch from the leaf to the root of the tree. Each
92      * pair of leaves and each pair of pre-images are assumed to be sorted.
93      */
94     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
95         bytes32 computedHash = leaf;
96 
97         for (uint256 i = 0; i < proof.length; i++) {
98             bytes32 proofElement = proof[i];
99 
100             if (computedHash <= proofElement) {
101                 // Hash(current computed hash + current element of the proof)
102                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
103             } else {
104                 // Hash(current element of the proof + current computed hash)
105                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
106             }
107         }
108 
109         // Check if the computed hash (root) is equal to the provided root
110         return computedHash == root;
111     }
112 }
113 
114 // Allows anyone to claim a token if they exist in a merkle root.
115 interface IMerkleDistributor {
116     // Returns the address of the token distributed by this contract.
117     function token() external view returns (address);
118     // Returns the merkle root of the merkle tree containing account balances available to claim.
119     function merkleRoot() external view returns (bytes32);
120     // Returns true if the index has been marked claimed.
121     function isClaimed(uint256 index) external view returns (bool);
122     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
123     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
124 
125     // This event is triggered whenever a call to #claim succeeds.
126     event Claimed(uint256 index, address account, uint256 amount);
127 }
128 
129 contract StabinolMerkleDistributor is IMerkleDistributor {
130     address public immutable override token;
131     bytes32 public immutable override merkleRoot;
132     uint256 public deployedTime;
133     address public governance;
134 
135     // This is a packed array of booleans.
136     mapping(uint256 => uint256) private claimedBitMap;
137 
138     constructor(address token_, bytes32 merkleRoot_) public {
139         token = token_;
140         merkleRoot = merkleRoot_;
141         governance = msg.sender;
142         deployedTime = now;
143     }
144 
145     function isClaimed(uint256 index) public view override returns (bool) {
146         uint256 claimedWordIndex = index / 256;
147         uint256 claimedBitIndex = index % 256;
148         uint256 claimedWord = claimedBitMap[claimedWordIndex];
149         uint256 mask = (1 << claimedBitIndex);
150         return claimedWord & mask == mask;
151     }
152 
153     function _setClaimed(uint256 index) private {
154         uint256 claimedWordIndex = index / 256;
155         uint256 claimedBitIndex = index % 256;
156         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
157     }
158 
159     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
160         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
161         require(IERC20(token).balanceOf(address(this)) > 0, "No tokens available for claim");
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
173     
174     function recoverLostTokens() external {
175         // This function is activated 30 days after contract is created and can be used by governance to retrieve tokens
176         require(msg.sender == governance, "Not governance");
177         require(now > deployedTime + 30 days, "Has not been at least 30 days before attempting to recover");
178         require(IERC20(token).transfer(governance, IERC20(token).balanceOf(address(this))), 'Transfer failed.');
179     }
180 }