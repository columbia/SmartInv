1 // Dependency file: contracts/interfaces/IMerkleDistributor.sol
2 
3 
4 
5 // pragma solidity ^0.6.10;
6 
7 // Allows anyone to claim a token if they exist in a merkle root.
8 interface IMerkleDistributor {
9     // Returns the address of the token distributed by this contract.
10     function token() external view returns (address);
11     // Returns the merkle root of the merkle tree containing account balances available to claim.
12     function merkleRoot() external view returns (bytes32);
13     // Returns true if the index has been marked claimed.
14     function isClaimed(uint256 index) external view returns (bool);
15     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
16     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
17 
18     // This event is triggered whenever a call to #claim succeeds.
19     event Claimed(uint256 index, address account, uint256 amount);
20 }
21 // Dependency file: @openzeppelin/contracts/cryptography/MerkleProof.sol
22 
23 
24 
25 // pragma solidity ^0.6.0;
26 
27 /**
28  * @dev These functions deal with verification of Merkle trees (hash trees),
29  */
30 library MerkleProof {
31     /**
32      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
33      * defined by `root`. For this, a `proof` must be provided, containing
34      * sibling hashes on the branch from the leaf to the root of the tree. Each
35      * pair of leaves and each pair of pre-images are assumed to be sorted.
36      */
37     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
38         bytes32 computedHash = leaf;
39 
40         for (uint256 i = 0; i < proof.length; i++) {
41             bytes32 proofElement = proof[i];
42 
43             if (computedHash <= proofElement) {
44                 // Hash(current computed hash + current element of the proof)
45                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
46             } else {
47                 // Hash(current element of the proof + current computed hash)
48                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
49             }
50         }
51 
52         // Check if the computed hash (root) is equal to the provided root
53         return computedHash == root;
54     }
55 }
56 
57 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
58 
59 
60 
61 // pragma solidity ^0.6.0;
62 
63 /**
64  * @dev Interface of the ERC20 standard as defined in the EIP.
65  */
66 interface IERC20 {
67     /**
68      * @dev Returns the amount of tokens in existence.
69      */
70     function totalSupply() external view returns (uint256);
71 
72     /**
73      * @dev Returns the amount of tokens owned by `account`.
74      */
75     function balanceOf(address account) external view returns (uint256);
76 
77     /**
78      * @dev Moves `amount` tokens from the caller's account to `recipient`.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transfer(address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Returns the remaining number of tokens that `spender` will be
88      * allowed to spend on behalf of `owner` through {transferFrom}. This is
89      * zero by default.
90      *
91      * This value changes when {approve} or {transferFrom} are called.
92      */
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     /**
96      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * // importANT: Beware that changing an allowance with this method brings the risk
101      * that someone may use both the old and the new allowance by unfortunate
102      * transaction ordering. One possible solution to mitigate this race
103      * condition is to first reduce the spender's allowance to 0 and set the
104      * desired value afterwards:
105      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106      *
107      * Emits an {Approval} event.
108      */
109     function approve(address spender, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Moves `amount` tokens from `sender` to `recipient` using the
113      * allowance mechanism. `amount` is then deducted from the caller's
114      * allowance.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a {Transfer} event.
119      */
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 pragma solidity ^0.6.10;
139 
140 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
141 // import { MerkleProof } from "@openzeppelin/contracts/cryptography/MerkleProof.sol";
142 // import { IMerkleDistributor } from "../interfaces/IMerkleDistributor.sol";
143 
144 contract MerkleDistributor is IMerkleDistributor {
145     address public immutable override token;
146     bytes32 public immutable override merkleRoot;
147 
148     // This is a packed array of booleans.
149     mapping(uint256 => uint256) private claimedBitMap;
150 
151     constructor(address token_, bytes32 merkleRoot_) public {
152         token = token_;
153         merkleRoot = merkleRoot_;
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
167         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
168     }
169 
170     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
171         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
172 
173         // Verify the merkle proof.
174         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
175         require(MerkleProof.verify(merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");
176 
177         // Mark it claimed and send the token.
178         _setClaimed(index);
179         require(IERC20(token).transfer(account, amount), "MerkleDistributor: Transfer failed.");
180 
181         emit Claimed(index, account, amount);
182     }
183 }