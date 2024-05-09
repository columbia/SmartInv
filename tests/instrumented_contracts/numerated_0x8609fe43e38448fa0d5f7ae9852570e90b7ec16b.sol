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
125     bool public paused;
126 
127     // This is a packed array of booleans.
128     mapping(uint256 => uint256) private claimedBitMap;
129     address public deployer;
130 
131     constructor(address token_, bytes32 merkleRoot_) public {
132         token = token_;
133         merkleRoot = merkleRoot_;
134         deployer = msg.sender;
135         paused = false;
136     }
137 
138     modifier whenNotPaused() {
139       require(!paused, "contract is currently paused");
140       _;
141     }
142 
143     function isClaimed(uint256 index) public view override returns (bool) {
144         uint256 claimedWordIndex = index / 256;
145         uint256 claimedBitIndex = index % 256;
146         uint256 claimedWord = claimedBitMap[claimedWordIndex];
147         uint256 mask = (1 << claimedBitIndex);
148         return claimedWord & mask == mask;
149     }
150 
151     function _setClaimed(uint256 index) private {
152         uint256 claimedWordIndex = index / 256;
153         uint256 claimedBitIndex = index % 256;
154         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
155     }
156 
157     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override whenNotPaused {
158         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
159         require(account != address(0x56d35962C76d706D9330842712a8220c62f0fCd0), "This particular user already gone through a special claiming process");
160         /** 
161           The user (0x56d3) had his private key exposed to an unknown hacker. 
162           We will be sending his funds directly to his new wallet thus it would not be claimable through this contract
163         */
164 
165         // Verify the merkle proof.
166         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
167         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
168 
169         // Mark it claimed and send the token.
170         _setClaimed(index);
171         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
172 
173         emit Claimed(index, account, amount);
174     }
175 
176     // Also allowing the deployer to reclaim tokens in case anything is wrong.
177     function collectDust(address _token, uint256 _amount) external {
178       require(msg.sender == deployer, "!deployer");
179       
180       if (_token == address(0)) { // token address(0) = ETH
181         payable(deployer).transfer(_amount);
182       } else {
183         IERC20(_token).transfer(deployer, _amount);
184       }
185     }
186 
187     function setPaused(bool _paused) external {
188       require(msg.sender == deployer, "!deployer");
189       paused = _paused;
190     }
191 }