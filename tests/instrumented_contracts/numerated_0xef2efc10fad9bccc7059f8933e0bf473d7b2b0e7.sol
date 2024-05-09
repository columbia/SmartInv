1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
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
81 // File: @openzeppelin/contracts/GSN/Context.sol
82 
83 pragma solidity ^0.6.0;
84 
85 /*
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with GSN meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address payable) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes memory) {
101         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/access/Ownable.sol
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor () internal {
131         address msgSender = _msgSender();
132         _owner = msgSender;
133         emit OwnershipTransferred(address(0), msgSender);
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(_owner == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/math/SafeMath.sol
175 
176 pragma solidity ^0.6.0;
177 
178 /**
179  * @dev Wrappers over Solidity's arithmetic operations with added overflow
180  * checks.
181  *
182  * Arithmetic operations in Solidity wrap on overflow. This can easily result
183  * in bugs, because programmers usually assume that an overflow raises an
184  * error, which is the standard behavior in high level programming languages.
185  * `SafeMath` restores this intuition by reverting the transaction when an
186  * operation overflows.
187  *
188  * Using this library instead of the unchecked operations eliminates an entire
189  * class of bugs, so it's recommended to use it always.
190  */
191 library SafeMath {
192     /**
193      * @dev Returns the addition of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `+` operator.
197      *
198      * Requirements:
199      *
200      * - Addition cannot overflow.
201      */
202     function add(uint256 a, uint256 b) internal pure returns (uint256) {
203         uint256 c = a + b;
204         require(c >= a, "SafeMath: addition overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the subtraction of two unsigned integers, reverting on
211      * overflow (when the result is negative).
212      *
213      * Counterpart to Solidity's `-` operator.
214      *
215      * Requirements:
216      *
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220         return sub(a, b, "SafeMath: subtraction overflow");
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      *
231      * - Subtraction cannot overflow.
232      */
233     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b <= a, errorMessage);
235         uint256 c = a - b;
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the multiplication of two unsigned integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `*` operator.
245      *
246      * Requirements:
247      *
248      * - Multiplication cannot overflow.
249      */
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
252         // benefit is lost if 'b' is also tested.
253         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
254         if (a == 0) {
255             return 0;
256         }
257 
258         uint256 c = a * b;
259         require(c / a == b, "SafeMath: multiplication overflow");
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers. Reverts on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator. Note: this function uses a
269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
270      * uses an invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return div(a, b, "SafeMath: division by zero");
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         uint256 c = a / b;
295         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
313         return mod(a, b, "SafeMath: modulo by zero");
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts with custom message when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         require(b != 0, errorMessage);
330         return a % b;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
335 
336 pragma solidity ^0.6.0;
337 
338 /**
339  * @dev These functions deal with verification of Merkle trees (hash trees),
340  */
341 library MerkleProof {
342     /**
343      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
344      * defined by `root`. For this, a `proof` must be provided, containing
345      * sibling hashes on the branch from the leaf to the root of the tree. Each
346      * pair of leaves and each pair of pre-images are assumed to be sorted.
347      */
348     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
349         bytes32 computedHash = leaf;
350 
351         for (uint256 i = 0; i < proof.length; i++) {
352             bytes32 proofElement = proof[i];
353 
354             if (computedHash <= proofElement) {
355                 // Hash(current computed hash + current element of the proof)
356                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
357             } else {
358                 // Hash(current element of the proof + current computed hash)
359                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
360             }
361         }
362 
363         // Check if the computed hash (root) is equal to the provided root
364         return computedHash == root;
365     }
366 }
367 
368 // File: contracts/CryptoComDefiSwapReward.sol
369 
370 pragma solidity ^0.6.12;
371 
372 
373 
374 
375 
376 contract CryptoComDefiSwapReward is Ownable {
377     using SafeMath for uint256;
378 
379     struct RewardInfo {
380         uint256 claimedReward;
381         uint256 lastClaimTimestamp;
382     }
383 
384     IERC20 public immutable token;
385     bytes32 public merkleRoot;
386     mapping (address => RewardInfo) public rewardInfo;
387 
388     event UpdatedMerkleRoot(bytes32 newMerkleRoot);
389     event Claim(address indexed user, uint256 amount);
390 
391     constructor(
392         IERC20 _tokenAddress
393     ) public {
394         token = _tokenAddress;
395     }
396 
397     function claim(
398         address _address,
399         uint256 _totalReward,
400         bytes32[] calldata _merkleProof
401     ) external {
402         RewardInfo storage reward = rewardInfo[_address];
403 
404         // Verify the merkle proof.
405         bytes32 node = keccak256(abi.encodePacked(_address, _totalReward));
406         require(MerkleProof.verify(_merkleProof, merkleRoot, node), "CryptoComDefiSwapReward: Invalid proof!");
407 
408         uint256 pendingReward = _totalReward.sub(reward.claimedReward);
409         require(pendingReward > 0, "CryptoComDefiSwapReward: No reward at this moment!");
410 
411         reward.claimedReward = _totalReward;
412         reward.lastClaimTimestamp = block.timestamp;
413         require(token.transfer(_address, pendingReward), "CryptoComDefiSwapReward: Transfer failed. Please try later!");
414         emit Claim(_address, pendingReward);
415     }
416 
417     function setMerkleRoot(
418         bytes32 _merkleRoot
419     ) external onlyOwner {
420         merkleRoot = _merkleRoot;
421         emit UpdatedMerkleRoot(_merkleRoot);
422     }
423 }