1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity >=0.6.11;
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
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
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
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         uint256 c = a + b;
104         if (c < a) return (false, 0);
105         return (true, c);
106     }
107 
108     /**
109      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
110      *
111      * _Available since v3.4._
112      */
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         if (b > a) return (false, 0);
115         return (true, a - b);
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
127         if (a == 0) return (true, 0);
128         uint256 c = a * b;
129         if (c / a != b) return (false, 0);
130         return (true, c);
131     }
132 
133     /**
134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
135      *
136      * _Available since v3.4._
137      */
138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b == 0) return (false, 0);
140         return (true, a / b);
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b == 0) return (false, 0);
150         return (true, a % b);
151     }
152 
153     /**
154      * @dev Returns the addition of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `+` operator.
158      *
159      * Requirements:
160      *
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166         return c;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b <= a, "SafeMath: subtraction overflow");
181         return a - b;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         if (a == 0) return 0;
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b > 0, "SafeMath: division by zero");
215         return a / b;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b > 0, "SafeMath: modulo by zero");
232         return a % b;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {trySub}.
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         return a - b;
255     }
256 
257     /**
258      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
259      * division by zero. The result is rounded towards zero.
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {tryDiv}.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function div(
273         uint256 a,
274         uint256 b,
275         string memory errorMessage
276     ) internal pure returns (uint256) {
277         require(b > 0, errorMessage);
278         return a / b;
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * reverting with custom message when dividing by zero.
284      *
285      * CAUTION: This function is deprecated because it requires allocating memory for the error
286      * message unnecessarily. For custom revert reasons use {tryMod}.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         require(b > 0, errorMessage);
302         return a % b;
303     }
304 }
305 
306 /**
307  * @dev These functions deal with verification of Merkle trees (hash trees),
308  */
309 library MerkleProof {
310     /**
311      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
312      * defined by `root`. For this, a `proof` must be provided, containing
313      * sibling hashes on the branch from the leaf to the root of the tree. Each
314      * pair of leaves and each pair of pre-images are assumed to be sorted.
315      */
316     function verify(
317         bytes32[] memory proof,
318         bytes32 root,
319         bytes32 leaf
320     ) internal pure returns (bool) {
321         bytes32 computedHash = leaf;
322 
323         for (uint256 i = 0; i < proof.length; i++) {
324             bytes32 proofElement = proof[i];
325 
326             if (computedHash <= proofElement) {
327                 // Hash(current computed hash + current element of the proof)
328                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
329             } else {
330                 // Hash(current element of the proof + current computed hash)
331                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
332             }
333         }
334 
335         // Check if the computed hash (root) is equal to the provided root
336         return computedHash == root;
337     }
338 }
339 
340 // Allows anyone to claim a token if they exist in a merkle root.
341 interface IMerkleDistributor {
342     // Returns the address of the token distributed by this contract.
343     function token() external view returns (address);
344 
345     // Returns the merkle root of the merkle tree containing account balances available to claim.
346     function merkleRoot() external view returns (bytes32);
347 
348     // Returns true if the index has been marked claimed.
349     function isClaimed(uint256 index) external view returns (bool);
350 
351     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
352     function claim(
353         uint256 index,
354         address account,
355         uint256 amount,
356         bytes32[] calldata merkleProof
357     ) external;
358 
359     // This event is triggered whenever a call to #claim succeeds.
360     event Claimed(uint256 index, address account, uint256 amount);
361 }
362 
363 contract MerkleDistributor is IMerkleDistributor {
364     address public operator;
365     uint256 public startTime;
366 
367     address public immutable override token;
368     bytes32 public immutable override merkleRoot;
369 
370     // This is a packed array of booleans.
371     mapping(uint256 => uint256) private claimedBitMap;
372 
373     mapping(address => bool) public blacklisted; // if the snapshot is wrong we need to block the account to receive token
374     bool public paused;
375 
376     constructor(address token_, bytes32 merkleRoot_) public {
377         token = token_;
378         merkleRoot = merkleRoot_;
379         operator = msg.sender;
380         startTime = block.timestamp;
381     }
382 
383     modifier onlyOperator() {
384         require(operator == msg.sender, "caller is not the operator");
385         _;
386     }
387 
388     modifier notPaused() {
389         require(!paused, "distribution is paused");
390         _;
391     }
392 
393     function pause() external onlyOperator {
394         paused = true;
395     }
396 
397     function unpause() external onlyOperator {
398         paused = false;
399     }
400 
401     function setBlacklisted(address _account, bool _status) external onlyOperator {
402         blacklisted[_account] = _status;
403     }
404 
405     function isClaimed(uint256 index) public view override returns (bool) {
406         uint256 claimedWordIndex = index / 256;
407         uint256 claimedBitIndex = index % 256;
408         uint256 claimedWord = claimedBitMap[claimedWordIndex];
409         uint256 mask = (1 << claimedBitIndex);
410         return claimedWord & mask == mask;
411     }
412 
413     function _setClaimed(uint256 index) private {
414         uint256 claimedWordIndex = index / 256;
415         uint256 claimedBitIndex = index % 256;
416         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
417     }
418 
419     function claim(
420         uint256 index,
421         address account,
422         uint256 amount,
423         bytes32[] calldata merkleProof
424     ) external override notPaused {
425         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
426         require(!blacklisted[account], "MerkleDistributor: Account is blocked.");
427 
428         // Verify the merkle proof.
429         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
430         require(MerkleProof.verify(merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");
431 
432         // Mark it claimed and send the token.
433         _setClaimed(index);
434         require(IERC20(token).transfer(account, amount), "MerkleDistributor: Transfer failed.");
435 
436         emit Claimed(index, account, amount);
437     }
438 
439     function governanceRecoverUnsupported(address _token, uint256 _amount) external onlyOperator {
440         IERC20(_token).transfer(operator, _amount);
441     }
442 }