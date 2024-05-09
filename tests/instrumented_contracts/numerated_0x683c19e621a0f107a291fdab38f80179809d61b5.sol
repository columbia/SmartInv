1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
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
81 pragma solidity ^0.6.0;
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
113 // File: contracts/AudiusClaimDistributor.sol
114 // TODO - update license
115 pragma solidity =0.6.11;
116 
117 
118 
119 /**
120  * Slightly modified version of: https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol
121  * Changes include:
122  * - remove "./interfaces/IMerkleDistributor.sol" inheritance
123  * - Contract name and require statement message string changes
124  * - add withdrawBlock and withdrawAddress state variables and withdraw() method
125  *
126  * - ...TODO...
127  */
128 contract AudiusClaimDistributor {
129     address public token;
130     bytes32 public merkleRoot;
131     uint256 public withdrawBlock;
132     address public withdrawAddress;
133 
134     // This is a packed array of booleans.
135     mapping(uint256 => uint256) private claimedBitMap;
136 
137     // This event is triggered whenever a call to #claim succeeds.
138     event Claimed(uint256 index, address account, uint256 amount);
139 
140     constructor(address _token, bytes32 _merkleRoot, uint256 _withdrawBlock, address _withdrawAddress) public {
141         token = _token;
142         merkleRoot = _merkleRoot;
143         withdrawBlock = _withdrawBlock;
144         withdrawAddress = _withdrawAddress;
145     }
146 
147     function isClaimed(uint256 index) public view returns (bool) {
148         uint256 claimedWordIndex = index / 256;
149         uint256 claimedBitIndex = index % 256;
150         uint256 claimedWord = claimedBitMap[claimedWordIndex];
151         uint256 mask = (1 << claimedBitIndex);
152         return claimedWord & mask == mask;
153     }
154 
155     function _setClaimed(uint256 index) private {
156         uint256 claimedWordIndex = index / 256;
157         uint256 claimedBitIndex = index % 256;
158         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
159     }
160 
161     /**
162      * No caller permissioning needed since token is transfered to account argument,
163      *    and there is no incentive to call function for another account.
164      * Can only submit claim for full claimable amount, otherwise proof verification will fail.
165      */
166     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external {
167         require(!isClaimed(index), 'AudiusClaimDistributor: Drop already claimed.');
168 
169         // Verify the merkle proof.
170         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
171         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'AudiusClaimDistributor: Invalid proof.');
172 
173         // Mark it claimed and send the token.
174         _setClaimed(index);
175         require(IERC20(token).transfer(account, amount), 'AudiusClaimDistributor: Transfer failed.');
176 
177         emit Claimed(index, account, amount);
178     }
179 
180     function withdraw() external {
181         require(
182             block.number >= withdrawBlock,
183             'AudiusClaimDistributor: Withdraw failed, cannot claim until after validBlocks diff'
184         );
185         require(
186             IERC20(token).transfer(withdrawAddress, IERC20(token).balanceOf(address(this))),
187             'AudiusClaimDistributor: Withdraw transfer failed.'
188         );
189     }
190 }