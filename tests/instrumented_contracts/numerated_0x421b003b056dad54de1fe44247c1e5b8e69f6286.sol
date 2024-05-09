1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
80 
81 pragma solidity >=0.6.0 <0.8.0;
82 
83 /**
84  * @dev These functions deal with verification of Merkle trees (hash trees),
85  */
86 library MerkleProof {
87     /**
88      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
89      * defined by `root`. For this, a `proof` must be provided, containing
90      * sibling hashes on the branch from the leaf to the root of the tree. Each
91      * pair of leaves and each pair of pre-images are assumed to be sorted.
92      */
93     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
94         bytes32 computedHash = leaf;
95 
96         for (uint256 i = 0; i < proof.length; i++) {
97             bytes32 proofElement = proof[i];
98 
99             if (computedHash <= proofElement) {
100                 // Hash(current computed hash + current element of the proof)
101                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
102             } else {
103                 // Hash(current element of the proof + current computed hash)
104                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
105             }
106         }
107 
108         // Check if the computed hash (root) is equal to the provided root
109         return computedHash == root;
110     }
111 }
112 
113 // File: contracts/interfaces/IMerkleDistributor.sol
114 
115 // SPDX-License-Identifier: UNLICENSED
116 pragma solidity >=0.5.0;
117 
118 // Allows anyone to claim a token if they exist in a merkle root.
119 interface IMerkleDistributor {
120     // Returns the address of the token distributed by this contract.
121     function token() external view returns (address);
122     // Returns the merkle root of the merkle tree containing account balances available to claim.
123     function merkleRoot() external view returns (bytes32);
124     // Returns true if the index has been marked claimed.
125     function isClaimed(uint256 index) external view returns (bool);
126     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
127     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
128 
129     // This event is triggered whenever a call to #claim succeeds.
130     event Claimed(uint256 index, address account, uint256 amount);
131 }
132 
133 // File: contracts/MerkleDistributor.sol
134 
135 pragma solidity =0.6.11;
136 
137 
138 
139 
140 contract MerkleDistributor is IMerkleDistributor {
141     address public immutable override token;
142     bytes32 public immutable override merkleRoot;
143     uint256 public immutable startDate;
144 
145     // This is a packed array of booleans.
146     mapping(uint256 => uint256) private claimedBitMap;
147     address deployer;
148 
149     constructor(address token_, bytes32 merkleRoot_, uint256 _startDate) public {
150         token = token_;
151         merkleRoot = merkleRoot_;
152         deployer = msg.sender;
153         startDate = _startDate;
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
167         claimedBitMap[claimedWordIndex] =
168             claimedBitMap[claimedWordIndex] |
169             (1 << claimedBitIndex);
170     }
171 
172     function claim(
173         uint256 index,
174         address account,
175         uint256 amount,
176         bytes32[] calldata merkleProof
177     ) external override {
178         require(block.timestamp >= startDate, "The vesting hasn't started");
179         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
180 
181         // Verify the merkle proof.
182         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
183         require(
184             MerkleProof.verify(merkleProof, merkleRoot, node),
185             "MerkleDistributor: Invalid proof."
186         );
187 
188         // Mark it claimed and send the token.
189         _setClaimed(index);
190         require(
191             IERC20(token).transfer(account, amount),
192             "MerkleDistributor: Transfer failed."
193         );
194 
195         emit Claimed(index, account, amount);
196     }
197 
198     function collectDust(address _token, uint256 _amount) external {
199         require(msg.sender == deployer, "!deployer");
200         require(_token != token, "!token");
201         if (_token == address(0)) {
202             // token address(0) = ETH
203             payable(deployer).transfer(_amount);
204         } else {
205             IERC20(_token).transfer(deployer, _amount);
206         }
207     }
208 }