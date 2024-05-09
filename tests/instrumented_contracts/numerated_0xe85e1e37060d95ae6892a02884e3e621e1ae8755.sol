1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
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
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev These functions deal with verification of Merkle trees (hash trees),
94  */
95 library MerkleProof {
96     /**
97      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
98      * defined by `root`. For this, a `proof` must be provided, containing
99      * sibling hashes on the branch from the leaf to the root of the tree. Each
100      * pair of leaves and each pair of pre-images are assumed to be sorted.
101      */
102     function verify(
103         bytes32[] memory proof,
104         bytes32 root,
105         bytes32 leaf
106     ) internal pure returns (bool) {
107         bytes32 computedHash = leaf;
108 
109         for (uint256 i = 0; i < proof.length; i++) {
110             bytes32 proofElement = proof[i];
111 
112             if (computedHash <= proofElement) {
113                 // Hash(current computed hash + current element of the proof)
114                 computedHash = keccak256(
115                     abi.encodePacked(computedHash, proofElement)
116                 );
117             } else {
118                 // Hash(current element of the proof + current computed hash)
119                 computedHash = keccak256(
120                     abi.encodePacked(proofElement, computedHash)
121                 );
122             }
123         }
124 
125         // Check if the computed hash (root) is equal to the provided root
126         return computedHash == root;
127     }
128 }
129 
130 // Allows anyone to claim a token if they exist in a merkle root.
131 interface IMerkleDistributor {
132     // Returns the address of the token distributed by this contract.
133     function token() external view returns (address);
134 
135     // Returns the merkle root of the merkle tree containing account balances available to claim.
136     function merkleRoot() external view returns (bytes32);
137 
138     // Returns true if the index has been marked claimed.
139     function isClaimed(uint256 index) external view returns (bool);
140 
141     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
142     function claim(
143         uint256 index,
144         address account,
145         uint256 amount,
146         bytes32[] calldata merkleProof
147     ) external;
148 
149     // This event is triggered whenever a call to #claim succeeds.
150     event Claimed(uint256 index, address account, uint256 amount);
151 }
152 
153 contract MerkleDistributor is IMerkleDistributor {
154     address public immutable override token;
155     bytes32 public immutable override merkleRoot;
156 
157     // This is a packed array of booleans.
158     mapping(uint256 => uint256) private claimedBitMap;
159 
160     address public governance;
161 
162     constructor(address token_, bytes32 merkleRoot_) public {
163         token = token_;
164         merkleRoot = merkleRoot_;
165         governance = msg.sender;
166     }
167 
168     function isClaimed(uint256 index) public view override returns (bool) {
169         uint256 claimedWordIndex = index / 256;
170         uint256 claimedBitIndex = index % 256;
171         uint256 claimedWord = claimedBitMap[claimedWordIndex];
172         uint256 mask = (1 << claimedBitIndex);
173         return claimedWord & mask == mask;
174     }
175 
176     function _setClaimed(uint256 index) private {
177         uint256 claimedWordIndex = index / 256;
178         uint256 claimedBitIndex = index % 256;
179         claimedBitMap[claimedWordIndex] =
180             claimedBitMap[claimedWordIndex] |
181             (1 << claimedBitIndex);
182     }
183 
184     function claim(
185         uint256 index,
186         address account,
187         uint256 amount,
188         bytes32[] calldata merkleProof
189     ) external override {
190         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
191 
192         // Verify the merkle proof.
193         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
194         require(
195             MerkleProof.verify(merkleProof, merkleRoot, node),
196             "MerkleDistributor: Invalid proof."
197         );
198 
199         // Mark it claimed and send the token.
200         _setClaimed(index);
201         require(
202             IERC20(token).transfer(account, amount),
203             "MerkleDistributor: Transfer failed."
204         );
205 
206         emit Claimed(index, account, amount);
207     }
208 
209     /**
210      * This function allows governance to take unsupported tokens out of the contract. This is in an effort to make someone whole, should they seriously mess up.
211      * There is no guarantee governance will vote to return these. It also allows for removal of airdropped tokens.
212      */
213     function governanceRecoverUnsupported(
214         IERC20 _token,
215         uint256 _amount,
216         address _to
217     ) external {
218         require(msg.sender == governance, "!governance");
219         _token.transfer(_to, _amount);
220     }
221 }