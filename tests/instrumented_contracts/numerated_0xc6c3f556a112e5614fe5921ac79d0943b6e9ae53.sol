1 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev These functions deal with verification of Merkle trees (hash trees),
7  */
8 library MerkleProof {
9   /**
10    * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
11    * defined by `root`. For this, a `proof` must be provided, containing
12    * sibling hashes on the branch from the leaf to the root of the tree. Each
13    * pair of leaves and each pair of pre-images are assumed to be sorted.
14    */
15   function verify(
16     bytes32[] memory proof,
17     bytes32 root,
18     bytes32 leaf
19   ) internal pure returns (bool) {
20     bytes32 computedHash = leaf;
21 
22     for (uint256 i = 0; i < proof.length; i++) {
23       bytes32 proofElement = proof[i];
24 
25       if (computedHash <= proofElement) {
26         // Hash(current computed hash + current element of the proof)
27         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
28       } else {
29         // Hash(current element of the proof + current computed hash)
30         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
31       }
32     }
33 
34     // Check if the computed hash (root) is equal to the provided root
35     return computedHash == root;
36   }
37 }
38 
39 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
40 
41 pragma solidity ^0.6.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47   /**
48    * @dev Returns the amount of tokens in existence.
49    */
50   function totalSupply() external view returns (uint256);
51 
52   /**
53    * @dev Returns the amount of tokens owned by `account`.
54    */
55   function balanceOf(address account) external view returns (uint256);
56 
57   /**
58    * @dev Moves `amount` tokens from the caller's account to `recipient`.
59    *
60    * Returns a boolean value indicating whether the operation succeeded.
61    *
62    * Emits a {Transfer} event.
63    */
64   function transfer(address recipient, uint256 amount) external returns (bool);
65 
66   /**
67    * @dev Returns the remaining number of tokens that `spender` will be
68    * allowed to spend on behalf of `owner` through {transferFrom}. This is
69    * zero by default.
70    *
71    * This value changes when {approve} or {transferFrom} are called.
72    */
73   function allowance(address owner, address spender)
74     external
75     view
76     returns (uint256);
77 
78   /**
79    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80    *
81    * Returns a boolean value indicating whether the operation succeeded.
82    *
83    * IMPORTANT: Beware that changing an allowance with this method brings the risk
84    * that someone may use both the old and the new allowance by unfortunate
85    * transaction ordering. One possible solution to mitigate this race
86    * condition is to first reduce the spender's allowance to 0 and set the
87    * desired value afterwards:
88    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89    *
90    * Emits an {Approval} event.
91    */
92   function approve(address spender, uint256 amount) external returns (bool);
93 
94   /**
95    * @dev Moves `amount` tokens from `sender` to `recipient` using the
96    * allowance mechanism. `amount` is then deducted from the caller's
97    * allowance.
98    *
99    * Returns a boolean value indicating whether the operation succeeded.
100    *
101    * Emits a {Transfer} event.
102    */
103   function transferFrom(
104     address sender,
105     address recipient,
106     uint256 amount
107   ) external returns (bool);
108 
109   /**
110    * @dev Emitted when `value` tokens are moved from one account (`from`) to
111    * another (`to`).
112    *
113    * Note that `value` may be zero.
114    */
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 
117   /**
118    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119    * a call to {approve}. `value` is the new allowance.
120    */
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: @openzeppelin/contracts/GSN/Context.sol
125 
126 pragma solidity ^0.6.0;
127 
128 /*
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with GSN meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139   function _msgSender() internal virtual view returns (address payable) {
140     return msg.sender;
141   }
142 
143   function _msgData() internal virtual view returns (bytes memory) {
144     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
145     return msg.data;
146   }
147 }
148 
149 // File: @openzeppelin/contracts/access/Ownable.sol
150 
151 pragma solidity ^0.6.0;
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 contract Ownable is Context {
166   address private _owner;
167 
168   event OwnershipTransferred(
169     address indexed previousOwner,
170     address indexed newOwner
171   );
172 
173   /**
174    * @dev Initializes the contract setting the deployer as the initial owner.
175    */
176   constructor() internal {
177     address msgSender = _msgSender();
178     _owner = msgSender;
179     emit OwnershipTransferred(address(0), msgSender);
180   }
181 
182   /**
183    * @dev Returns the address of the current owner.
184    */
185   function owner() public view returns (address) {
186     return _owner;
187   }
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
194     _;
195   }
196 
197   /**
198    * @dev Leaves the contract without owner. It will not be possible to call
199    * `onlyOwner` functions anymore. Can only be called by the current owner.
200    *
201    * NOTE: Renouncing ownership will leave the contract without an owner,
202    * thereby removing any functionality that is only available to the owner.
203    */
204   function renounceOwnership() public virtual onlyOwner {
205     emit OwnershipTransferred(_owner, address(0));
206     _owner = address(0);
207   }
208 
209   /**
210    * @dev Transfers ownership of the contract to a new account (`newOwner`).
211    * Can only be called by the current owner.
212    */
213   function transferOwnership(address newOwner) public virtual onlyOwner {
214     require(newOwner != address(0), 'Ownable: new owner is the zero address');
215     emit OwnershipTransferred(_owner, newOwner);
216     _owner = newOwner;
217   }
218 }
219 
220 // File: contracts/StonkMerkleDropper.sol
221 
222 pragma solidity >=0.6.11;
223 
224 interface IStonkMerkleDropper {
225   // Returns the merkle root of the merkle tree containing account balances available to claim.
226   function merkleRoots(uint256 airdropId) external view returns (bytes32);
227 
228   // Returns true if the index has been marked claimed.
229   function isClaimed(uint256 airdropId, uint256 index)
230     external
231     view
232     returns (bool);
233 
234   // Claim the given amount of the stonk to the given address. Reverts if the inputs are invalid.
235   function claim(
236     uint256 airdropId,
237     uint256 index,
238     address account,
239     uint256 amount,
240     bytes32[] calldata merkleProof
241   ) external;
242 
243   // This event is triggered whenever a call to #claim succeeds.
244   event Claimed(
245     uint256 airdropId,
246     uint256 index,
247     address account,
248     uint256 amount
249   );
250 }
251 
252 contract StonkMerkleDropper is IStonkMerkleDropper, Ownable {
253   IERC20 public immutable stonk;
254 
255   // Mapping of airdropIds to merkle roots
256   mapping(uint256 => bytes32) public override merkleRoots;
257 
258   // Mapping of airdropIds to packed array of booleans
259   mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMaps;
260 
261   constructor(IERC20 _stonk) public {
262     stonk = _stonk;
263   }
264 
265   function addMerkleRoot(uint256 airdropId, bytes32 merkleRoot)
266     public
267     onlyOwner
268   {
269     merkleRoots[airdropId] = merkleRoot;
270   }
271 
272   function isClaimed(uint256 airdropId, uint256 index)
273     public
274     override
275     view
276     returns (bool)
277   {
278     mapping(uint256 => uint256) storage claimed = claimedBitMaps[airdropId];
279 
280     uint256 claimedWordIndex = index / 256;
281     uint256 claimedBitIndex = index % 256;
282     uint256 claimedWord = claimed[claimedWordIndex];
283     uint256 mask = (1 << claimedBitIndex);
284 
285     return claimedWord & mask == mask;
286   }
287 
288   function _setClaimed(uint256 airdropId, uint256 index) private {
289     mapping(uint256 => uint256) storage claimed = claimedBitMaps[airdropId];
290 
291     uint256 claimedWordIndex = index / 256;
292     uint256 claimedBitIndex = index % 256;
293 
294     claimed[claimedWordIndex] =
295       claimed[claimedWordIndex] |
296       (1 << claimedBitIndex);
297   }
298 
299   function claim(
300     uint256 airdropId,
301     uint256 index,
302     address account,
303     uint256 amount,
304     bytes32[] calldata merkleProof
305   ) external override {
306     require(
307       !isClaimed(airdropId, index),
308       'StonkMerkleDropper: Drop already claimed.'
309     );
310 
311     // Verify the merkle proof.
312     bytes32 node = keccak256(abi.encodePacked(index, account, amount));
313 
314     require(
315       MerkleProof.verify(merkleProof, merkleRoots[airdropId], node),
316       'StonkMerkleDropper: Invalid proof.'
317     );
318 
319     // Mark it claimed and send the STONK.
320     _setClaimed(airdropId, index);
321 
322     require(
323       stonk.transfer(account, amount),
324       'StonkMerkleDropper: Transfer failed.'
325     );
326 
327     emit Claimed(airdropId, index, account, amount);
328   }
329 }