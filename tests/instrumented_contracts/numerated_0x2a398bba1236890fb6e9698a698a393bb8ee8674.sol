1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 pragma solidity ^0.7.0;
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
80 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
81 
82 
83 pragma solidity ^0.7.0;
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
115 // File: contracts/interfaces/IMerkleDistributor.sol
116 
117 pragma solidity ^0.7.4;
118 
119 // Allows anyone to claim a token if they exist in a merkle root.
120 interface IMerkleDistributor {
121     // Returns the address of the token distributed by this contract.
122     function token() external view returns (address);
123 
124     // Returns the merkle root of the merkle tree containing account balances available to claim.
125     function merkleRoot() external view returns (bytes32);
126 
127     // Returns the start time of distribution
128     function startTime() external view returns (uint256);
129 
130     // Returns true if the index has been marked claimed.
131     function isClaimed(uint256 index) external view returns (bool);
132 
133     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
134     function claim(
135         uint256 index,
136         address account,
137         uint256 amount,
138         bytes32[] calldata merkleProof
139     ) external;
140 
141     // This event is triggered whenever a call to #claim succeeds.
142     event Claimed(uint256 index, address account, uint256 amount);
143 }
144 
145 // File: contracts/distributor/MerkleDistributor.sol
146 
147 pragma solidity ^0.7.4;
148 
149 
150 
151 
152 contract MerkleDistributor is IMerkleDistributor {
153     address public immutable override token;
154     bytes32 public immutable override merkleRoot;
155     uint256 public immutable override startTime;
156 
157     // This is a packed array of booleans.
158     mapping(uint256 => uint256) private claimedBitMap;
159 
160     constructor(address token_, bytes32 merkleRoot_, uint256 startTime_) {
161         token = token_;
162         merkleRoot = merkleRoot_;
163         startTime = startTime_;
164     }
165 
166     function isClaimed(uint256 index) public override view returns (bool) {
167         uint256 claimedWordIndex = index / 256;
168         uint256 claimedBitIndex = index % 256;
169         uint256 claimedWord = claimedBitMap[claimedWordIndex];
170         uint256 mask = (1 << claimedBitIndex);
171         return claimedWord & mask == mask;
172     }
173 
174     function _setClaimed(uint256 index) private {
175         uint256 claimedWordIndex = index / 256;
176         uint256 claimedBitIndex = index % 256;
177         claimedBitMap[claimedWordIndex] =
178             claimedBitMap[claimedWordIndex] |
179             (1 << claimedBitIndex);
180     }
181 
182     function claim(
183         uint256 index,
184         address account,
185         uint256 amount,
186         bytes32[] calldata merkleProof
187     ) external override {
188         require(block.timestamp >= startTime, "MerkleDistributor: Distribution not started yet");
189         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
190 
191         // Verify the merkle proof.
192         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
193         require(
194             MerkleProof.verify(merkleProof, merkleRoot, node),
195             "MerkleDistributor: Invalid proof."
196         );
197 
198         // Mark it claimed and send the token.
199         _setClaimed(index);
200         require(
201             IERC20(token).transfer(account, amount),
202             "MerkleDistributor: Transfer failed."
203         );
204 
205         emit Claimed(index, account, amount);
206     }
207 }