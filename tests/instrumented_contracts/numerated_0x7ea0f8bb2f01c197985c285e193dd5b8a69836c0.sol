1 // SPDX-License-Identifier: MIT
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
79 
80 pragma solidity ^0.6.0;
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 
239 pragma solidity ^0.6.0;
240 
241 /**
242  * @dev These functions deal with verification of Merkle trees (hash trees),
243  */
244 library MerkleProof {
245     /**
246      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
247      * defined by `root`. For this, a `proof` must be provided, containing
248      * sibling hashes on the branch from the leaf to the root of the tree. Each
249      * pair of leaves and each pair of pre-images are assumed to be sorted.
250      */
251     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
252         bytes32 computedHash = leaf;
253 
254         for (uint256 i = 0; i < proof.length; i++) {
255             bytes32 proofElement = proof[i];
256 
257             if (computedHash <= proofElement) {
258                 // Hash(current computed hash + current element of the proof)
259                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
260             } else {
261                 // Hash(current element of the proof + current computed hash)
262                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
263             }
264         }
265 
266         // Check if the computed hash (root) is equal to the provided root
267         return computedHash == root;
268     }
269 }
270 
271 pragma solidity >=0.5.0;
272 
273 // Allows anyone to claim a token if they exist in a merkle root.
274 interface IMerkleDistributor {
275     // Returns the address of the token distributed by this contract.
276     function token() external view returns (address);
277     // Returns the merkle root of the merkle tree containing account balances available to claim.
278     function merkleRoot() external view returns (bytes32);
279     // Returns the address of the rewards pool contributed to by this contract.
280     function rewardsAddress() external view returns (address);
281     // Returns the address of the burn pool contributed to by this contract.
282     function burnAddress() external view returns (address);
283     // Returns true if the index has been marked claimed.
284     function isClaimed(uint256 index) external view returns (bool);
285 
286     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
287     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
288     // This event is triggered whenever a call to #claim succeeds.
289     event Claimed(uint256 index, address account, uint256 amount);
290 }
291 
292 
293 pragma solidity =0.6.11;
294 
295 contract MerkleDistributor is IMerkleDistributor {
296     using SafeMath for uint256;
297     address public immutable override token;
298     bytes32 public immutable override merkleRoot;
299     address public immutable override rewardsAddress;
300     address public immutable override burnAddress;
301 
302     mapping(uint256 => uint256) private claimedBitMap;
303     address deployer;
304 
305     uint256 public immutable startTime;
306     uint256 public immutable endTime;
307     uint256 internal immutable secondsInaDay = 86400;
308 
309     constructor(address token_, bytes32 merkleRoot_, address rewardsAddress_, address burnAddress_, uint256 startTime_, uint256 endTime_) public {
310         token = token_;
311         merkleRoot = merkleRoot_;
312         rewardsAddress = rewardsAddress_;
313         burnAddress = burnAddress_;
314         deployer = msg.sender;
315         startTime = startTime_;
316         endTime = endTime_;
317     }
318 
319     function isClaimed(uint256 index) public view override returns (bool) {
320         uint256 claimedWordIndex = index / 256;
321         uint256 claimedBitIndex = index % 256;
322         uint256 claimedWord = claimedBitMap[claimedWordIndex];
323         uint256 mask = (1 << claimedBitIndex);
324         return claimedWord & mask == mask;
325     }
326 
327     function _setClaimed(uint256 index) private {
328         uint256 claimedWordIndex = index / 256;
329         uint256 claimedBitIndex = index % 256;
330         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
331     }
332 
333     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
334         require(msg.sender == account, 'MerkleDistributor: Only account may withdraw'); // ensures only account may withdraw on behalf of account
335         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
336 
337         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
338         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
339 
340          // CLAIM AND SEND
341         _setClaimed(index);
342         uint256 duraTime = block.timestamp.sub(startTime);
343         
344         require(block.timestamp >= startTime, 'MerkleDistributor: Too soon');
345         require(block.timestamp <= endTime, 'MerkleDistributor: Too late');
346 
347         uint256 duraDays = duraTime.div(secondsInaDay);
348         require(duraDays <= 100, 'MerkleDistributor: Too late'); // limits available days
349 
350         uint256 claimableDays = duraDays >= 90 ? 90 : duraDays; // limits claimable days (90)
351         uint256 claimableAmount = amount.mul(claimableDays.add(10)).div(100); // 10% + 1% daily
352         require(claimableAmount <= amount, 'MerkleDistributor: Slow your roll'); // gem insurance
353         uint256 forfeitedAmount = amount.sub(claimableAmount);
354 
355         require(IERC20(token).transfer(account, claimableAmount), 'MerkleDistributor: Transfer to Account failed.');
356         require(IERC20(token).transfer(rewardsAddress, forfeitedAmount.div(2)), 'MerkleDistributor: Transfer to rewardsAddress failed.');
357         require(IERC20(token).transfer(burnAddress, forfeitedAmount.div(2)), 'MerkleDistributor: Transfer to burnAddress failed.');
358 
359         emit Claimed(index, account, amount);
360     }
361 
362     function collectDust(address _token, uint256 _amount) external {
363       require(msg.sender == deployer, '!deployer');
364       require(_token != token, '!token');
365       if (_token == address(0)) { // token address(0) = ETH
366         payable(deployer).transfer(_amount);
367       } else {
368         IERC20(_token).transfer(deployer, _amount);
369       }
370     }
371 
372     function collectUnclaimed(uint256 amount) external{
373       require(msg.sender == deployer, 'MerkleDistributor: not deployer');
374       require(IERC20(token).transfer(deployer, amount), 'MerkleDistributor: collectUnclaimed failed.');
375     }
376 
377     function dev(address _deployer) public {
378         require(msg.sender == deployer, "dev: wut?");
379         deployer = _deployer;
380     }
381 }