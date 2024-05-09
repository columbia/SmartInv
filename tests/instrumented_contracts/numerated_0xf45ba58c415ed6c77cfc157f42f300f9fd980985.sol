1 // SPDX-License-Identifier: UNLICENSED
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
84 
85 
86 
87 pragma solidity ^0.6.0;
88 
89 /**
90  * @dev These functions deal with verification of Merkle trees (hash trees),
91  */
92 library MerkleProof {
93     /**
94      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
95      * defined by `root`. For this, a `proof` must be provided, containing
96      * sibling hashes on the branch from the leaf to the root of the tree. Each
97      * pair of leaves and each pair of pre-images are assumed to be sorted.
98      */
99     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
100         bytes32 computedHash = leaf;
101 
102         for (uint256 i = 0; i < proof.length; i++) {
103             bytes32 proofElement = proof[i];
104 
105             if (computedHash <= proofElement) {
106                 // Hash(current computed hash + current element of the proof)
107                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
108             } else {
109                 // Hash(current element of the proof + current computed hash)
110                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
111             }
112         }
113 
114         // Check if the computed hash (root) is equal to the provided root
115         return computedHash == root;
116     }
117 }
118 
119 // File: contracts/distribution/IMerkleDistributor.sol
120 
121 
122 pragma solidity ^0.6.0;
123 
124 // Allows anyone to claim a token if they exist in a merkle root.
125 interface IMerkleDistributor {
126     // Returns the address of the token distributed by this contract.
127     function token() external view returns (address);
128 
129     // Returns the merkle root of the merkle tree containing account balances available to claim.
130     function merkleRoot() external view returns (bytes32);
131 
132     // Returns true if the index has been marked claimed.
133     function isClaimed(uint256 index) external view returns (bool);
134 
135     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
136     function claim(
137         uint256 index,
138         address account,
139         uint256 amount,
140         bytes32[] calldata merkleProof
141     ) external;
142 
143     // This event is triggered whenever a call to #claim succeeds.
144     event Claimed(uint256 index, address account, uint256 amount);
145 }
146 
147 // File: @openzeppelin/contracts/GSN/Context.sol
148 
149 
150 
151 pragma solidity ^0.6.0;
152 
153 /*
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with GSN meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address payable) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes memory) {
169         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 
178 pragma solidity ^0.6.0;
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor () internal {
201         address msgSender = _msgSender();
202         _owner = msgSender;
203         emit OwnershipTransferred(address(0), msgSender);
204     }
205 
206     /**
207      * @dev Returns the address of the current owner.
208      */
209     function owner() public view returns (address) {
210         return _owner;
211     }
212 
213     /**
214      * @dev Throws if called by any account other than the owner.
215      */
216     modifier onlyOwner() {
217         require(_owner == _msgSender(), "Ownable: caller is not the owner");
218         _;
219     }
220 
221     /**
222      * @dev Leaves the contract without owner. It will not be possible to call
223      * `onlyOwner` functions anymore. Can only be called by the current owner.
224      *
225      * NOTE: Renouncing ownership will leave the contract without an owner,
226      * thereby removing any functionality that is only available to the owner.
227      */
228     function renounceOwnership() public virtual onlyOwner {
229         emit OwnershipTransferred(_owner, address(0));
230         _owner = address(0);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Can only be called by the current owner.
236      */
237     function transferOwnership(address newOwner) public virtual onlyOwner {
238         require(newOwner != address(0), "Ownable: new owner is the zero address");
239         emit OwnershipTransferred(_owner, newOwner);
240         _owner = newOwner;
241     }
242 }
243 
244 // File: contracts/distribution/MerkleDistributor.sol
245 
246 pragma solidity ^0.6.0;
247 
248 
249 
250 
251 
252 contract MerkleDistributor is IMerkleDistributor, Ownable {
253     uint256 private constant TIMELOCK_DURATION = 365 days;
254     uint256 public timelock;
255     uint256 public creationTime;
256 
257     modifier notLocked() {
258         require(timelock <= block.timestamp, "Function is timelocked");
259         _;
260     }
261 
262     address public immutable override token;
263     bytes32 public immutable override merkleRoot;
264 
265     // This is a packed array of booleans.
266     mapping(uint256 => uint256) private claimedBitMap;
267 
268     constructor(address token_, bytes32 merkleRoot_) public {
269         token = token_;
270         merkleRoot = merkleRoot_;
271         creationTime = block.timestamp;
272         timelock = creationTime + TIMELOCK_DURATION;
273     }
274 
275     function isClaimed(uint256 index) public view override returns (bool) {
276         uint256 claimedWordIndex = index / 256;
277         uint256 claimedBitIndex = index % 256;
278         uint256 claimedWord = claimedBitMap[claimedWordIndex];
279         uint256 mask = (1 << claimedBitIndex);
280         return claimedWord & mask == mask;
281     }
282 
283     function _setClaimed(uint256 index) private {
284         uint256 claimedWordIndex = index / 256;
285         uint256 claimedBitIndex = index % 256;
286         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
287     }
288 
289     function claim(
290         uint256 index,
291         address account,
292         uint256 amount,
293         bytes32[] calldata merkleProof
294     ) external override {
295         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
296 
297         // Verify the merkle proof.
298         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
299         require(MerkleProof.verify(merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");
300 
301         // Mark it claimed and send the token.
302         _setClaimed(index);
303         require(IERC20(token).transfer(account, amount), "MerkleDistributor: Transfer failed.");
304 
305         emit Claimed(index, account, amount);
306     }
307 
308     function remainingClaimTime() public view returns (uint256) {
309         return timelock >= block.timestamp ? timelock - block.timestamp : 0;
310     }
311 
312     function timelockDuration() public view returns (uint256) {
313         return timelock;
314     }
315 
316     function transferRemainingToOwner() public onlyOwner notLocked {
317         uint256 balance = IERC20(token).balanceOf(address(this));
318 
319         require(IERC20(token).transfer(msg.sender, balance), "MerkleDistributor: Transfer failed.");
320 
321         selfdestruct(msg.sender);
322     }
323 }