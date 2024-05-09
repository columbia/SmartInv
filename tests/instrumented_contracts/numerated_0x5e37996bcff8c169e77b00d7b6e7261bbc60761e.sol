1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.6.11;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev These functions deal with verification of Merkle trees (hash trees),
80  */
81 library MerkleProof {
82     /**
83      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
84      * defined by `root`. For this, a `proof` must be provided, containing
85      * sibling hashes on the branch from the leaf to the root of the tree. Each
86      * pair of leaves and each pair of pre-images are assumed to be sorted.
87      */
88     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
89         bytes32 computedHash = leaf;
90 
91         for (uint256 i = 0; i < proof.length; i++) {
92             bytes32 proofElement = proof[i];
93 
94             if (computedHash <= proofElement) {
95                 // Hash(current computed hash + current element of the proof)
96                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
97             } else {
98                 // Hash(current element of the proof + current computed hash)
99                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
100             }
101         }
102 
103         // Check if the computed hash (root) is equal to the provided root
104         return computedHash == root;
105     }
106 }
107 
108 // Allows anyone to claim a token if they exist in a merkle root.
109 interface IMerkleDistributor {
110     // Returns the address of the token distributed by this contract.
111     function token() external view returns (address);
112     // Returns the merkle root of the merkle tree containing account balances available to claim.
113     function merkleRoot() external view returns (bytes32);
114     // Returns true if the index has been marked claimed.
115     function isClaimed(uint256 index) external view returns (bool);
116     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
117     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof, uint256 tipBips) external;
118 
119     // This event is triggered whenever a call to #claim succeeds.
120     event Claimed(uint256 index, address account, uint256 amount);
121 }
122 
123 contract MerkleDistributor is IMerkleDistributor {
124     address public immutable override token;
125     bytes32 public immutable override merkleRoot;
126 
127     // This is a packed array of booleans.
128     mapping(uint256 => uint256) private claimedBitMap;
129     address deployer;
130 
131     constructor(address token_, bytes32 merkleRoot_) public {
132         token = token_;
133         merkleRoot = merkleRoot_;
134         deployer = msg.sender;
135     }
136 
137     function isClaimed(uint256 index) public view override returns (bool) {
138         uint256 claimedWordIndex = index / 256;
139         uint256 claimedBitIndex = index % 256;
140         uint256 claimedWord = claimedBitMap[claimedWordIndex];
141         uint256 mask = (1 << claimedBitIndex);
142         return claimedWord & mask == mask;
143     }
144 
145     function _setClaimed(uint256 index) private {
146         uint256 claimedWordIndex = index / 256;
147         uint256 claimedBitIndex = index % 256;
148         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
149     }
150 
151     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof, uint256 tipBips) external override {
152         require(tipBips <= 10000);
153         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
154 
155         // Verify the merkle proof.
156         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
157         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
158 
159         // Mark it claimed and send the token.
160         _setClaimed(index);
161         uint256 tip = account == msg.sender ? amount * tipBips / 10000 : 0;
162         require(IERC20(token).transfer(account, amount - tip), 'MerkleDistributor: Transfer failed.');
163         if (tip > 0) require(IERC20(token).transfer(deployer, tip));
164 
165         emit Claimed(index, account, amount);
166     }
167 
168     function collectDust(address _token, uint256 _amount) external {
169       require(msg.sender == deployer, "!deployer");
170       require(_token != token, "!token");
171       if (_token == address(0)) { // token address(0) = ETH
172         payable(deployer).transfer(_amount);
173       } else {
174         IERC20(_token).transfer(deployer, _amount);
175       }
176     }
177 }