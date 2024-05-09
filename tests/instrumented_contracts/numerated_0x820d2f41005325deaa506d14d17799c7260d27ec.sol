1 pragma solidity ^0.6.0;
2 
3 
4 // 
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
79 // 
80 /**
81  * @dev These functions deal with verification of Merkle trees (hash trees),
82  */
83 library MerkleProof {
84     /**
85      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
86      * defined by `root`. For this, a `proof` must be provided, containing
87      * sibling hashes on the branch from the leaf to the root of the tree. Each
88      * pair of leaves and each pair of pre-images are assumed to be sorted.
89      */
90     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
91         bytes32 computedHash = leaf;
92 
93         for (uint256 i = 0; i < proof.length; i++) {
94             bytes32 proofElement = proof[i];
95 
96             if (computedHash <= proofElement) {
97                 // Hash(current computed hash + current element of the proof)
98                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
99             } else {
100                 // Hash(current element of the proof + current computed hash)
101                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
102             }
103         }
104 
105         // Check if the computed hash (root) is equal to the provided root
106         return computedHash == root;
107     }
108 }
109 
110 // 
111 // Allows anyone to claim a token if they exist in a merkle root.
112 interface IMerkleDistributor {
113     // Returns the address of the token distributed by this contract.
114     function token() external view returns (address);
115     // Returns the merkle root of the merkle tree containing account balances available to claim.
116     function merkleRoot() external view returns (bytes32);
117     // Returns true if the index has been marked claimed.
118     function isClaimed(uint256 index) external view returns (bool);
119     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
120     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external payable;
121 
122     // This event is triggered whenever a call to #claim succeeds.
123     event Claimed(uint256 index, address account, uint256 amount);
124 }
125 
126 // 
127 contract MerkleDistributor is IMerkleDistributor {
128     address public immutable override token;
129     bytes32 public immutable override merkleRoot;
130 
131     // This is a packed array of booleans.
132     mapping(uint256 => uint256) private claimedBitMap;
133     address deployer;
134 
135     constructor(address token_, bytes32 merkleRoot_) public {
136         token = token_;
137         merkleRoot = merkleRoot_;
138         deployer = msg.sender;
139     }
140 
141     function isClaimed(uint256 index) public view override returns (bool) {
142         uint256 claimedWordIndex = index / 256;
143         uint256 claimedBitIndex = index % 256;
144         uint256 claimedWord = claimedBitMap[claimedWordIndex];
145         uint256 mask = (1 << claimedBitIndex);
146         return claimedWord & mask == mask;
147     }
148 
149     function _setClaimed(uint256 index) private {
150         uint256 claimedWordIndex = index / 256;
151         uint256 claimedBitIndex = index % 256;
152         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
153     }
154 
155     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override payable {
156         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
157 
158         // Verify the merkle proof.
159         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
160         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
161 
162         // Mark it claimed and send the token.
163         _setClaimed(index);
164         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
165 
166         uint256 tip = msg.value;
167         if (tip > 0) {
168             payable(deployer).transfer(tip);
169         }
170 
171         emit Claimed(index, account, amount);
172     }
173 
174     function collectDust(address _token, uint256 _amount) external {
175       require(msg.sender == deployer, "!deployer");
176       require(_token != token, "!token");
177       if (_token == address(0)) { // token address(0) = ETH
178         payable(deployer).transfer(_amount);
179       } else {
180         IERC20(_token).transfer(deployer, _amount);
181       }
182     }
183 }