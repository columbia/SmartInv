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
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev These functions deal with verification of Merkle trees (hash trees),
79  */
80 library MerkleProof {
81     /**
82      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
83      * defined by `root`. For this, a `proof` must be provided, containing
84      * sibling hashes on the branch from the leaf to the root of the tree. Each
85      * pair of leaves and each pair of pre-images are assumed to be sorted.
86      */
87     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
88         bytes32 computedHash = leaf;
89 
90         for (uint256 i = 0; i < proof.length; i++) {
91             bytes32 proofElement = proof[i];
92 
93             if (computedHash <= proofElement) {
94                 // Hash(current computed hash + current element of the proof)
95                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
96             } else {
97                 // Hash(current element of the proof + current computed hash)
98                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
99             }
100         }
101 
102         // Check if the computed hash (root) is equal to the provided root
103         return computedHash == root;
104     }
105 }
106 
107 // Allows anyone to claim a token if they exist in a merkle root.
108 interface IMerkleDistributor {
109     // Returns the address of the token distributed by this contract.
110     function token() external view returns (address);
111     // Returns the merkle root of the merkle tree containing account balances available to claim.
112     function merkleRoot() external view returns (bytes32);
113     // Returns true if the index has been marked claimed.
114     function isClaimed(uint256 index) external view returns (bool);
115     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
116     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
117 
118     // This event is triggered whenever a call to #claim succeeds.
119     event Claimed(uint256 index, address account, uint256 amount);
120 }
121 
122 contract MerkleDistributor is IMerkleDistributor {
123     address public immutable override token;
124     bytes32 public immutable override merkleRoot;
125 
126     // This is a packed array of booleans.
127     mapping(uint256 => uint256) private claimedBitMap;
128 
129     constructor(address token_, bytes32 merkleRoot_) public {
130         token = token_;
131         merkleRoot = merkleRoot_;
132     }
133 
134     function isClaimed(uint256 index) public view override returns (bool) {
135         uint256 claimedWordIndex = index / 256;
136         uint256 claimedBitIndex = index % 256;
137         uint256 claimedWord = claimedBitMap[claimedWordIndex];
138         uint256 mask = (1 << claimedBitIndex);
139         return claimedWord & mask == mask;
140     }
141 
142     function _setClaimed(uint256 index) private {
143         uint256 claimedWordIndex = index / 256;
144         uint256 claimedBitIndex = index % 256;
145         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
146     }
147 
148     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
149         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
150 
151         // Verify the merkle proof.
152         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
153         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
154 
155         // Mark it claimed and send the token.
156         _setClaimed(index);
157         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
158 
159         emit Claimed(index, account, amount);
160     }
161 }