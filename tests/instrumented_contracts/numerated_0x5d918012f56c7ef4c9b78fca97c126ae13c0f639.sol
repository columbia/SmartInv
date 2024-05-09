1 pragma solidity =0.6.11;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount)
25         external
26         returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender)
36         external
37         view
38         returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(
84         address indexed owner,
85         address indexed spender,
86         uint256 value
87     );
88 }
89 
90 /**
91  * @dev These functions deal with verification of Merkle trees (hash trees),
92  */
93 library MerkleProof {
94     /**
95      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
96      * defined by `root`. For this, a `proof` must be provided, containing
97      * sibling hashes on the branch from the leaf to the root of the tree. Each
98      * pair of leaves and each pair of pre-images are assumed to be sorted.
99      */
100     function verify(
101         bytes32[] memory proof,
102         bytes32 root,
103         bytes32 leaf
104     ) internal pure returns (bool) {
105         bytes32 computedHash = leaf;
106 
107         for (uint256 i = 0; i < proof.length; i++) {
108             bytes32 proofElement = proof[i];
109 
110             if (computedHash <= proofElement) {
111                 // Hash(current computed hash + current element of the proof)
112                 computedHash = keccak256(
113                     abi.encodePacked(computedHash, proofElement)
114                 );
115             } else {
116                 // Hash(current element of the proof + current computed hash)
117                 computedHash = keccak256(
118                     abi.encodePacked(proofElement, computedHash)
119                 );
120             }
121         }
122 
123         // Check if the computed hash (root) is equal to the provided root
124         return computedHash == root;
125     }
126 }
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
147     // This event is triggered whenever a call to #claim succeeds.
148     event Claimed(uint256 index, address account, uint256 amount);
149 }
150 
151 contract MerkleDistributor is IMerkleDistributor {
152     address public immutable override token;
153     bytes32 public immutable override merkleRoot;
154 
155     // This is a packed array of booleans.
156     mapping(uint256 => uint256) private claimedBitMap;
157 
158     constructor(address token_, bytes32 merkleRoot_) public {
159         token = token_;
160         merkleRoot = merkleRoot_;
161     }
162 
163     function isClaimed(uint256 index) public view override returns (bool) {
164         uint256 claimedWordIndex = index / 256;
165         uint256 claimedBitIndex = index % 256;
166         uint256 claimedWord = claimedBitMap[claimedWordIndex];
167         uint256 mask = (1 << claimedBitIndex);
168         return claimedWord & mask == mask;
169     }
170 
171     function _setClaimed(uint256 index) private {
172         uint256 claimedWordIndex = index / 256;
173         uint256 claimedBitIndex = index % 256;
174         claimedBitMap[claimedWordIndex] =
175             claimedBitMap[claimedWordIndex] |
176             (1 << claimedBitIndex);
177     }
178 
179     function claim(
180         uint256 index,
181         address account,
182         uint256 amount,
183         bytes32[] calldata merkleProof
184     ) external override {
185         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
186 
187         // Verify the merkle proof.
188         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
189         require(
190             MerkleProof.verify(merkleProof, merkleRoot, node),
191             "MerkleDistributor: Invalid proof."
192         );
193 
194         // Mark it claimed and send the token.
195         _setClaimed(index);
196         require(
197             IERC20(token).transfer(account, amount),
198             "MerkleDistributor: Transfer failed."
199         );
200 
201         emit Claimed(index, account, amount);
202     }
203 }