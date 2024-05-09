1 /**
2  *Submitted for verification at BscScan.com on 2021-07-11
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity =0.7.6;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         uint256 c = a + b;
30         if (c < a) return (false, 0);
31         return (true, c);
32     }
33 
34     /**
35      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         if (b > a) return (false, 0);
41         return (true, a - b);
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53         if (a == 0) return (true, 0);
54         uint256 c = a * b;
55         if (c / a != b) return (false, 0);
56         return (true, c);
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         if (b == 0) return (false, 0);
76         return (true, a % b);
77     }
78 
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      *
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b <= a, "SafeMath: subtraction overflow");
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         if (a == 0) return 0;
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b > 0, "SafeMath: division by zero");
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0, "SafeMath: modulo by zero");
158         return a % b;
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {trySub}.
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * CAUTION: This function is deprecated because it requires allocating memory for the error
184      * message unnecessarily. For custom revert reasons use {tryDiv}.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         return a / b;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * reverting with custom message when dividing by zero.
202      *
203      * CAUTION: This function is deprecated because it requires allocating memory for the error
204      * message unnecessarily. For custom revert reasons use {tryMod}.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 /**
221  * @dev Interface of the ERC20 standard as defined in the EIP.
222  */
223 interface IERC20 {
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `recipient`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `sender` to `recipient` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 /*
295  * @dev Provides information about the current execution context, including the
296  * sender of the transaction and its data. While these are generally available
297  * via msg.sender and msg.data, they should not be accessed in such a direct
298  * manner, since when dealing with GSN meta-transactions the account sending and
299  * paying for execution may not be the actual sender (as far as an application
300  * is concerned).
301  *
302  * This contract is only required for intermediate, library-like contracts.
303  */
304 abstract contract Context {
305     function _msgSender() internal view virtual returns (address payable) {
306         return msg.sender;
307     }
308 
309     function _msgData() internal view virtual returns (bytes memory) {
310         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
311         return msg.data;
312     }
313 }
314 
315 /**
316  * @dev Contract module which provides a basic access control mechanism, where
317  * there is an account (an owner) that can be granted exclusive access to
318  * specific functions.
319  *
320  * By default, the owner account will be the one that deploys the contract. This
321  * can later be changed with {transferOwnership}.
322  *
323  * This module is used through inheritance. It will make available the modifier
324  * `onlyOwner`, which can be applied to your functions to restrict their use to
325  * the owner.
326  */
327 abstract contract Ownable is Context {
328     address private _owner;
329 
330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
331 
332     /**
333      * @dev Initializes the contract setting the deployer as the initial owner.
334      */
335     constructor () internal {
336         address msgSender = _msgSender();
337         _owner = msgSender;
338         emit OwnershipTransferred(address(0), msgSender);
339     }
340 
341     /**
342      * @dev Returns the address of the current owner.
343      */
344     function owner() public view virtual returns (address) {
345         return _owner;
346     }
347 
348     /**
349      * @dev Throws if called by any account other than the owner.
350      */
351     modifier onlyOwner() {
352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
353         _;
354     }
355 
356     /**
357      * @dev Leaves the contract without owner. It will not be possible to call
358      * `onlyOwner` functions anymore. Can only be called by the current owner.
359      *
360      * NOTE: Renouncing ownership will leave the contract without an owner,
361      * thereby removing any functionality that is only available to the owner.
362      */
363     function renounceOwnership() public virtual onlyOwner {
364         emit OwnershipTransferred(_owner, address(0));
365         _owner = address(0);
366     }
367 
368     /**
369      * @dev Transfers ownership of the contract to a new account (`newOwner`).
370      * Can only be called by the current owner.
371      */
372     function transferOwnership(address newOwner) public virtual onlyOwner {
373         require(newOwner != address(0), "Ownable: new owner is the zero address");
374         emit OwnershipTransferred(_owner, newOwner);
375         _owner = newOwner;
376     }
377 }
378 
379 /* users could create staking-reward model with this contract at single mode */
380 
381 contract SimpleStaking is Ownable {
382     using SafeMath for uint;
383 
384     uint constant doubleScale = 10 ** 36;
385 
386     // stake token
387     IERC20 public stakeToken;
388 
389     // reward token
390     IERC20 public rewardToken;
391 
392     // the number of reward token distribution for each block
393     uint public rewardSpeed;
394 
395     // user deposit
396     mapping(address => uint) public userCollateral;
397     uint public totalCollateral;
398 
399     // use index to distribute reward token
400     // index is compound exponential
401     mapping(address => uint) public userIndex;
402     uint public index;
403 
404     mapping(address => uint) public userAccrued;
405 
406     // record latest block height of reward token distributed
407     uint public lastDistributedBlock;
408 
409     /* event */
410     event Deposit(address user, uint amount);
411     event Withdraw(address user, uint amount);
412     event RewardSpeedUpdated(uint oldSpeed, uint newSpeed);
413     event RewardDistributed(address indexed user, uint delta, uint index);
414 
415     constructor(IERC20 _stakeToken, IERC20 _rewardToken) Ownable(){
416         stakeToken = _stakeToken;
417         rewardToken = _rewardToken;
418         index = doubleScale;
419     }
420 
421     function deposit(uint amount) public {
422         updateIndex();
423         distributeReward(msg.sender);
424         require(stakeToken.transferFrom(msg.sender, address(this), amount), "transferFrom failed");
425         userCollateral[msg.sender] = userCollateral[msg.sender].add(amount);
426         totalCollateral = totalCollateral.add(amount);
427         emit Deposit(msg.sender, amount);
428     }
429 
430     function withdraw(uint amount) public {
431         updateIndex();
432         distributeReward(msg.sender);
433         require(stakeToken.transfer(msg.sender, amount), "transfer failed");
434         userCollateral[msg.sender] = userCollateral[msg.sender].sub(amount);
435         totalCollateral = totalCollateral.sub(amount);
436         emit Withdraw(msg.sender, amount);
437     }
438 
439     function setRewardSpeed(uint speed) public onlyOwner {
440         updateIndex();
441         uint oldSpeed = rewardSpeed;
442         rewardSpeed = speed;
443         emit RewardSpeedUpdated(oldSpeed, speed);
444     }
445 
446     function updateIndex() private {
447         uint blockDelta = block.number.sub(lastDistributedBlock);
448         if (blockDelta == 0) {
449             return;
450         }
451         uint rewardAccrued = blockDelta.mul(rewardSpeed);
452         if (totalCollateral > 0) {
453             uint indexDelta = rewardAccrued.mul(doubleScale).div(totalCollateral);
454             index = index.add(indexDelta);
455         }
456         lastDistributedBlock = block.number;
457     }
458 
459     function distributeReward(address user) private {
460         if (userIndex[user] == 0 && index > 0) {
461             userIndex[user] = doubleScale;
462         }
463         uint indexDelta = index - userIndex[user];
464         userIndex[user] = index;
465         uint rewardDelta = indexDelta.mul(userCollateral[user]).div(doubleScale);
466         userAccrued[user] = userAccrued[user].add(rewardDelta);
467         if (rewardToken.balanceOf(address(this)) >= userAccrued[user] && userAccrued[user] > 0) {
468             if (rewardToken.transfer(user, userAccrued[user])) {
469                 userAccrued[user] = 0;
470             }
471         }
472         emit RewardDistributed(user, rewardDelta, index);
473     }
474 
475     function claimReward(address[] memory user) public {
476         updateIndex();
477         for (uint i = 0; i < user.length; i++) {
478             distributeReward(user[i]);
479         }
480     }
481 
482     function withdrawRemainReward() public onlyOwner {
483         uint amount = rewardToken.balanceOf(address(this));
484         if (rewardToken == stakeToken) {
485             amount = amount.sub(totalCollateral);
486         }
487         rewardToken.transfer(owner(), amount);
488     }
489 
490     function pendingReward(address user) public view returns (uint){
491         uint blockDelta = block.number.sub(lastDistributedBlock);
492         uint rewardAccrued = blockDelta.mul(rewardSpeed);
493         if (totalCollateral == 0) {
494             return userAccrued[user];
495         }
496         uint ratio = rewardAccrued.mul(doubleScale).div(totalCollateral);
497         uint currentIndex = index.add(ratio);
498         uint uIndex = userIndex[user] == 0 && index > 0 ? doubleScale : userIndex[user];
499         uint indexDelta = currentIndex - uIndex;
500         uint rewardDelta = indexDelta.mul(userCollateral[user]).div(doubleScale);
501         return rewardDelta + userAccrued[user];
502     }
503 }