1 /**
2  *Submitted for verification at Arbiscan on 2022-11-29
3 */
4 
5 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/cryptography/MerkleProof.sol
6 
7 
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev These functions deal with verification of Merkle trees (hash trees),
13  */
14 library MerkleProof {
15     /**
16      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
17      * defined by `root`. For this, a `proof` must be provided, containing
18      * sibling hashes on the branch from the leaf to the root of the tree. Each
19      * pair of leaves and each pair of pre-images are assumed to be sorted.
20      */
21     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
22         bytes32 computedHash = leaf;
23 
24         for (uint256 i = 0; i < proof.length; i++) {
25             bytes32 proofElement = proof[i];
26 
27             if (computedHash <= proofElement) {
28                 // Hash(current computed hash + current element of the proof)
29                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
30             } else {
31                 // Hash(current element of the proof + current computed hash)
32                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
33             }
34         }
35 
36         // Check if the computed hash (root) is equal to the provided root
37         return computedHash == root;
38     }
39 }
40 
41 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/IERC20.sol
42 
43 
44 
45 pragma solidity ^0.6.0;
46 
47 /**
48  * @dev Interface of the ERC20 standard as defined in the EIP.
49  */
50 interface IERC20 {
51     /**
52      * @dev Returns the amount of tokens in existence.
53      */
54     function totalSupply() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens owned by `account`.
58      */
59     function balanceOf(address account) external view returns (uint256);
60 
61     /**
62      * @dev Moves `amount` tokens from the caller's account to `recipient`.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Returns the remaining number of tokens that `spender` will be
72      * allowed to spend on behalf of `owner` through {transferFrom}. This is
73      * zero by default.
74      *
75      * This value changes when {approve} or {transferFrom} are called.
76      */
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     /**
80      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * IMPORTANT: Beware that changing an allowance with this method brings the risk
85      * that someone may use both the old and the new allowance by unfortunate
86      * transaction ordering. One possible solution to mitigate this race
87      * condition is to first reduce the spender's allowance to 0 and set the
88      * desired value afterwards:
89      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90      *
91      * Emits an {Approval} event.
92      */
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Moves `amount` tokens from `sender` to `recipient` using the
97      * allowance mechanism. `amount` is then deducted from the caller's
98      * allowance.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Emitted when `value` tokens are moved from one account (`from`) to
108      * another (`to`).
109      *
110      * Note that `value` may be zero.
111      */
112     event Transfer(address indexed from, address indexed to, uint256 value);
113 
114     /**
115      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
116      * a call to {approve}. `value` is the new allowance.
117      */
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 // File: contracts/Merkle.sol
122 
123 
124 pragma solidity =0.6.11;
125 
126 
127 
128 // Allows anyone to claim a token if they exist in a merkle root.
129 interface IMerkleDistributor {
130     // Returns the address of the token distributed by this contract.
131     function token() external view returns (address);
132 
133     // Returns the merkle root of the merkle tree containing account balances available to claim.
134     function merkleRoot() external view returns (bytes32);
135 
136     // Returns true if the index has been marked claimed.
137     function isClaimed(uint256 index) external view returns (bool);
138 
139     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
140     function claim(
141         uint256 index,
142         address account,
143         uint256 amount,
144         bytes32[] calldata merkleProof
145     ) external;
146 
147     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
148     function claimFor(
149         uint256 index,
150         address account,
151         uint256 amount,
152         bytes32[] calldata merkleProof,
153         address recipient
154     ) external;
155 
156     // This event is triggered whenever a call to #claim succeeds.
157     event Claimed(uint256 index, address account, uint256 amount);
158 }
159 
160 
161 interface IVe {
162     function split(uint256 tokenId, uint256 sendAmount)
163         external
164         returns (uint256);
165 
166     function transferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 }
172 
173 contract MerkleDistributor is IMerkleDistributor {
174     address public immutable override token;
175     bytes32 public immutable override merkleRoot;
176 
177     // This is a packed array of booleans.
178     mapping(uint256 => uint256) private claimedBitMap;
179     address public governance;
180 
181     constructor(address token_, bytes32 merkleRoot_) public {
182         token = token_;
183         merkleRoot = merkleRoot_;
184         governance = msg.sender;
185     }
186 
187     function isClaimed(uint256 index) public view override returns (bool) {
188         uint256 claimedWordIndex = index / 256;
189         uint256 claimedBitIndex = index % 256;
190         uint256 claimedWord = claimedBitMap[claimedWordIndex];
191         uint256 mask = (1 << claimedBitIndex);
192         return claimedWord & mask == mask;
193     }
194 
195     function _setClaimed(uint256 index) private {
196         uint256 claimedWordIndex = index / 256;
197         uint256 claimedBitIndex = index % 256;
198         claimedBitMap[claimedWordIndex] =
199             claimedBitMap[claimedWordIndex] |
200             (1 << claimedBitIndex);
201     }
202 
203     function claim(
204         uint256 index,
205         address account,
206         uint256 amount,
207         bytes32[] calldata merkleProof
208     ) external override {
209         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
210         require(msg.sender == account, "!account");
211 
212         // Verify the merkle proof.
213         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
214         require(
215             MerkleProof.verify(merkleProof, merkleRoot, node),
216             "MerkleDistributor: Invalid proof."
217         );
218 
219         // Mark it claimed and send the token.
220         _setClaimed(index);
221         require(
222             IERC20(token).transfer(account, amount),
223             "MerkleDistributor: Transfer failed."
224         );
225 
226         emit Claimed(index, account, amount);
227     }
228 
229     function claimFor(
230         uint256 index,
231         address account,
232         uint256 amount,
233         bytes32[] calldata merkleProof,
234         address recipient
235     ) external override {
236         require(msg.sender == governance, "!governance");
237         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
238 
239         // Verify the merkle proof.
240         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
241         require(
242             MerkleProof.verify(merkleProof, merkleRoot, node),
243             "MerkleDistributor: Invalid proof."
244         );
245 
246         // Mark it claimed and send the token.
247         _setClaimed(index);
248         require(
249             IERC20(token).transfer(recipient, amount),
250             "MerkleDistributor: Transfer failed."
251         );
252 
253         emit Claimed(index, account, amount);
254     }
255 
256     function transferGovernance(address governance_) external {
257         require(msg.sender == governance, "!governance");
258         governance = governance_;
259     }
260 
261     function collectDust(address _token, uint256 _amount) external {
262         require(msg.sender == governance, "!governance");
263         require(_token != token, "!token");
264         if (_token == address(0)) {
265             // token address(0) = ETH
266             payable(governance).transfer(_amount);
267         } else {
268             IERC20(_token).transfer(governance, _amount);
269         }
270     }
271 }