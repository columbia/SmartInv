1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/math/SafeMath.sol
99 
100 
101 
102 pragma solidity >=0.6.0 <0.8.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: Staking(BPT).sol
261 
262 //Be name khoda
263 
264 
265 
266 
267 pragma solidity 0.6.12;
268 
269 
270 
271 interface StakedToken {
272     function balanceOf(address account) external view returns (uint256);
273     function transfer(address recipient, uint256 amount) external returns (bool);
274     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
275 }
276 
277 interface RewardToken {
278     function balanceOf(address account) external view returns (uint256);
279     function transfer(address recipient, uint256 amount) external returns (bool);
280 }
281 
282 contract Staking is Ownable {
283 
284     struct User {
285         uint256 depositAmount;
286         uint256 paidReward;
287     }
288 
289     using SafeMath for uint256;
290 
291     mapping (address => User) public users;
292 
293     uint256 public rewardTillNowPerToken = 0;
294     uint256 public lastUpdatedBlock;
295     uint256 public rewardPerBlock;
296     uint256 public scale = 1e18;
297 
298     uint256 public daoShare;
299     address public daoWallet;
300 
301     StakedToken public stakedToken;
302     RewardToken public rewardToken;
303 
304     event Deposit(address user, uint256 amount);
305     event Withdraw(address user, uint256 amount);
306     event EmergencyWithdraw(address user, uint256 amount);
307     event RewardClaimed(address user, uint256 amount);
308     event RewardPerBlockChanged(uint256 oldValue, uint256 newValue);
309 
310     constructor (
311 		address _stakedToken,
312 		address _rewardToken,
313 		uint256 _rewardPerBlock,
314 		uint256 _daoShare,
315 		address _daoWallet) public {
316 			
317         stakedToken = StakedToken(_stakedToken);
318         rewardToken = RewardToken(_rewardToken);
319         rewardPerBlock = _rewardPerBlock;
320         daoShare = _daoShare;
321         lastUpdatedBlock = block.number;
322         daoWallet = _daoWallet;
323     }
324 
325     function setDaoWallet(address _daoWallet) public onlyOwner {
326         daoWallet = _daoWallet;
327     }
328 
329     function setDaoShare(uint256 _daoShare) public onlyOwner {
330         daoShare = _daoShare;
331     }
332 
333     function setRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {
334         update();
335         emit RewardPerBlockChanged(rewardPerBlock, _rewardPerBlock);
336         rewardPerBlock = _rewardPerBlock;
337     }
338 
339     // Update reward variables of the pool to be up-to-date.
340     function update() public {
341         if (block.number <= lastUpdatedBlock) {
342             return;
343         }
344         uint256 totalStakedToken = stakedToken.balanceOf(address(this));
345         uint256 rewardAmount = (block.number - lastUpdatedBlock).mul(rewardPerBlock);
346 
347         rewardTillNowPerToken = rewardTillNowPerToken.add(rewardAmount.mul(scale).div(totalStakedToken));
348         lastUpdatedBlock = block.number;
349     }
350 
351     // View function to see pending reward on frontend.
352     function pendingReward(address _user) external view returns (uint256) {
353         User storage user = users[_user];
354         uint256 accRewardPerToken = rewardTillNowPerToken;
355 
356         if (block.number > lastUpdatedBlock) {
357             uint256 totalStakedToken = stakedToken.balanceOf(address(this));
358             uint256 rewardAmount = (block.number - lastUpdatedBlock).mul(rewardPerBlock);
359             accRewardPerToken = accRewardPerToken.add(rewardAmount.mul(scale).div(totalStakedToken));
360         }
361         uint256 reward = user.depositAmount.mul(accRewardPerToken).div(scale).sub(user.paidReward);
362 		return reward.mul(daoShare).div(scale);
363     }
364 
365 	function deposit(uint256 amount) public {
366 		depositFor(msg.sender, amount);
367     }
368 
369     function depositFor(address _user, uint256 amount) public {
370         User storage user = users[_user];
371         update();
372 
373         if (user.depositAmount > 0) {
374             uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);			
375 			sendReward(_user, _pendingReward);
376         }
377 
378         user.depositAmount = user.depositAmount.add(amount);
379         user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);
380         stakedToken.transferFrom(address(msg.sender), address(this), amount);
381         emit Deposit(_user, amount);
382     }
383 
384 	function sendReward(address user, uint256 amount) private {
385 		uint256 _daoShare = amount.mul(daoShare).div(scale);
386         rewardToken.transfer(user, amount.sub(_daoShare));
387 		rewardToken.transfer(daoWallet, _daoShare);
388         emit RewardClaimed(user, amount);
389 	}
390 
391     function withdraw(uint256 amount) public {
392         User storage user = users[msg.sender];
393         require(user.depositAmount >= amount, "withdraw amount exceeds deposited amount");
394         update();
395 
396         uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);
397 		sendReward(msg.sender, _pendingReward);
398 
399         if (amount > 0) {
400             user.depositAmount = user.depositAmount.sub(amount);
401             stakedToken.transfer(address(msg.sender), amount);
402             emit Withdraw(msg.sender, amount);
403         }
404 
405         user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);
406     }
407 
408     // Withdraw without caring about rewards. EMERGENCY ONLY.
409     function emergencyWithdraw() public {
410         User storage user = users[msg.sender];
411 
412         stakedToken.transfer(msg.sender, user.depositAmount);
413 
414         emit EmergencyWithdraw(msg.sender, user.depositAmount);
415 
416         user.depositAmount = 0;
417         user.paidReward = 0;
418     }
419 
420 	function emergencyWithdrawFor(address _user) public onlyOwner{
421         User storage user = users[_user];
422 
423         stakedToken.transfer(_user, user.depositAmount);
424 
425         emit EmergencyWithdraw(_user, user.depositAmount);
426 
427         user.depositAmount = 0;
428         user.paidReward = 0;
429     }
430 
431     function withdrawRewardTokens(address to, uint256 amount) public onlyOwner {
432         rewardToken.transfer(to, amount);
433     }
434 
435 	// Add temporary withdrawal functionality for owner(DAO) to transfer all tokens to a safe place.
436     // Contract ownership will transfer to address(0x) after full auditing of codes.
437     function withdrawAllStakedtokens(address to) public onlyOwner {
438         uint256 totalStakedTokens = stakedToken.balanceOf(address(this));
439         stakedToken.transfer(to, totalStakedTokens);
440     }
441 
442 }
443 
444 
445 //Dar panah khoda