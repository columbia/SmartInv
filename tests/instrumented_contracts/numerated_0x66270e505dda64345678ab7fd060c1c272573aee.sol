1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
82 
83 
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev These functions deal with verification of Merkle trees (hash trees),
89  */
90 library MerkleProof {
91     /**
92      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
93      * defined by `root`. For this, a `proof` must be provided, containing
94      * sibling hashes on the branch from the leaf to the root of the tree. Each
95      * pair of leaves and each pair of pre-images are assumed to be sorted.
96      */
97     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
98         bytes32 computedHash = leaf;
99 
100         for (uint256 i = 0; i < proof.length; i++) {
101             bytes32 proofElement = proof[i];
102 
103             if (computedHash <= proofElement) {
104                 // Hash(current computed hash + current element of the proof)
105                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
106             } else {
107                 // Hash(current element of the proof + current computed hash)
108                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
109             }
110         }
111 
112         // Check if the computed hash (root) is equal to the provided root
113         return computedHash == root;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/GSN/Context.sol
118 
119 
120 
121 pragma solidity ^0.6.0;
122 
123 /*
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with GSN meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address payable) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes memory) {
139         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 
148 pragma solidity ^0.6.0;
149 
150 /**
151  * @dev Contract module which provides a basic access control mechanism, where
152  * there is an account (an owner) that can be granted exclusive access to
153  * specific functions.
154  *
155  * By default, the owner account will be the one that deploys the contract. This
156  * can later be changed with {transferOwnership}.
157  *
158  * This module is used through inheritance. It will make available the modifier
159  * `onlyOwner`, which can be applied to your functions to restrict their use to
160  * the owner.
161  */
162 
163 contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     /**
169      * @dev Initializes the contract setting the deployer as the initial owner.
170      */
171     constructor () internal {
172         address msgSender = _msgSender();
173         _owner = msgSender;
174         emit OwnershipTransferred(address(0), msgSender);
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(_owner == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         emit OwnershipTransferred(_owner, address(0));
201         _owner = address(0);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Can only be called by the current owner.
207      */
208     function transferOwnership(address newOwner) public virtual onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         emit OwnershipTransferred(_owner, newOwner);
211         _owner = newOwner;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Pausable.sol
216 
217 
218 
219 pragma solidity ^0.6.0;
220 
221 
222 /**
223  * @dev Contract module which allows children to implement an emergency stop
224  * mechanism that can be triggered by an authorized account.
225  *
226  * This module is used through inheritance. It will make available the
227  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
228  * the functions of your contract. Note that they will not be pausable by
229  * simply including this module, only once the modifiers are put in place.
230  */
231 contract Pausable is Context {
232     /**
233      * @dev Emitted when the pause is triggered by `account`.
234      */
235     event Paused(address account);
236 
237     /**
238      * @dev Emitted when the pause is lifted by `account`.
239      */
240     event Unpaused(address account);
241 
242     bool private _paused;
243 
244     /**
245      * @dev Initializes the contract in unpaused state.
246      */
247     constructor () internal {
248         _paused = false;
249     }
250 
251     /**
252      * @dev Returns true if the contract is paused, and false otherwise.
253      */
254     function paused() public view returns (bool) {
255         return _paused;
256     }
257 
258     /**
259      * @dev Modifier to make a function callable only when the contract is not paused.
260      *
261      * Requirements:
262      *
263      * - The contract must not be paused.
264      */
265     modifier whenNotPaused() {
266         require(!_paused, "Pausable: paused");
267         _;
268     }
269 
270     /**
271      * @dev Modifier to make a function callable only when the contract is paused.
272      *
273      * Requirements:
274      *
275      * - The contract must be paused.
276      */
277     modifier whenPaused() {
278         require(_paused, "Pausable: not paused");
279         _;
280     }
281 
282     /**
283      * @dev Triggers stopped state.
284      *
285      * Requirements:
286      *
287      * - The contract must not be paused.
288      */
289     function _pause() internal virtual whenNotPaused {
290         _paused = true;
291         emit Paused(_msgSender());
292     }
293 
294     /**
295      * @dev Returns to normal state.
296      *
297      * Requirements:
298      *
299      * - The contract must be paused.
300      */
301     function _unpause() internal virtual whenPaused {
302         _paused = false;
303         emit Unpaused(_msgSender());
304     }
305 }
306 
307 // File: contracts/MerkleDistributor.sol
308 
309 // SPDX-License-Identifier: UNLICENSED
310 pragma solidity >=0.6.11;
311 
312 
313 
314 
315 
316 
317 
318 contract MerkleDistributor is Ownable, Pausable {
319     address public  token;
320     bytes32 public  merkleRoot;
321     uint256 public nonce;
322     // This is a packed array of booleans.
323     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
324 
325     // constructor(address token_, bytes32 merkleRoot_) public {
326     //     token = token_;
327     //     merkleRoot = merkleRoot_;
328     //     nonce ++;
329     // }
330 
331     function setToken(address token_) external onlyOwner {
332         token = token_;
333     }
334 
335     function setMerkleRoot (bytes32 merkleRoot_) external onlyOwner {
336         merkleRoot = merkleRoot_;
337         nonce ++;
338     }
339 
340     function setNonce(uint256 nonce_) external onlyOwner {
341         nonce = nonce_;
342     }
343 
344     function pause() external onlyOwner{
345         _pause();
346     }
347 
348     function unpause()external onlyOwner {
349         _unpause();
350     }
351 
352     function isClaimed(uint256 index) public view returns (bool) {
353         uint256 claimedWordIndex = index / 256;
354         uint256 claimedBitIndex = index % 256;
355         uint256 claimedWord = claimedBitMap[nonce][claimedWordIndex];
356         uint256 mask = (1 << claimedBitIndex);
357         return claimedWord & mask == mask;
358     }
359 
360     function _setClaimed(uint256 index) private {
361         uint256 claimedWordIndex = index / 256;
362         uint256 claimedBitIndex = index % 256;
363         claimedBitMap[nonce][claimedWordIndex] = claimedBitMap[nonce][claimedWordIndex] | (1 << claimedBitIndex);
364     }
365 
366     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external whenNotPaused {
367         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
368 
369         // Verify the merkle proof.
370         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
371         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
372 
373         // Mark it claimed and send the token.
374         _setClaimed(index);
375         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
376 
377         emit Claimed(index, account, amount);
378     }
379 
380      event Claimed(uint256 index, address account, uint256 amount);
381 }