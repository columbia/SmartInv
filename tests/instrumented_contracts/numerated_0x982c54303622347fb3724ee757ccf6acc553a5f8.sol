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
260 // File: Staking.sol
261 
262 //Be name khoda
263 
264 
265 
266 pragma solidity 0.6.12;
267 
268 
269 
270 interface StakedToken {
271     function balanceOf(address account) external view returns (uint256);
272     function transfer(address recipient, uint256 amount) external returns (bool);
273     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
274 }
275 
276 interface RewardToken {
277     function balanceOf(address account) external view returns (uint256);
278     function transfer(address recipient, uint256 amount) external returns (bool);
279 }
280 
281 contract Staking is Ownable {
282 
283     struct User {
284         uint256 depositAmount;
285         uint256 paidReward;
286     }
287 
288     using SafeMath for uint256;
289 
290     mapping (address => User) public users;
291 
292     uint256 public rewardTillNowPerToken = 0;
293     uint256 public lastUpdatedBlock;
294     uint256 public rewardPerBlock;
295     uint256 public scale = 1e18;
296 
297     uint256 public daoShare;
298     address public daoWallet;
299 
300     StakedToken public stakedToken;
301     RewardToken public rewardToken;
302 
303     event Deposit(address user, uint256 amount);
304     event Withdraw(address user, uint256 amount);
305     event EmergencyWithdraw(address user, uint256 amount);
306     event RewardClaimed(address user, uint256 amount);
307     event RewardPerBlockChanged(uint256 oldValue, uint256 newValue);
308 
309     constructor (
310 		address _stakedToken,
311 		address _rewardToken,
312 		uint256 _rewardPerBlock,
313 		uint256 _daoShare,
314 		address _daoWallet) public {
315 			
316         stakedToken = StakedToken(_stakedToken);
317         rewardToken = RewardToken(_rewardToken);
318         rewardPerBlock = _rewardPerBlock;
319         daoShare = _daoShare;
320         lastUpdatedBlock = block.number;
321         daoWallet = _daoWallet;
322     }
323 
324     function setDaoWallet(address _daoWallet) public onlyOwner {
325         daoWallet = _daoWallet;
326     }
327 
328     function setDaoShare(uint256 _daoShare) public onlyOwner {
329         daoShare = _daoShare;
330     }
331 
332     function setRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {
333         update();
334         emit RewardPerBlockChanged(rewardPerBlock, _rewardPerBlock);
335         rewardPerBlock = _rewardPerBlock;
336     }
337 
338     // Update reward variables of the pool to be up-to-date.
339     function update() public {
340         if (block.number <= lastUpdatedBlock) {
341             return;
342         }
343         uint256 totalStakedToken = stakedToken.balanceOf(address(this));
344         uint256 rewardAmount = (block.number - lastUpdatedBlock).mul(rewardPerBlock);
345 
346         rewardTillNowPerToken = rewardTillNowPerToken.add(rewardAmount.mul(scale).div(totalStakedToken));
347         lastUpdatedBlock = block.number;
348     }
349 
350     // View function to see pending reward on frontend.
351     function pendingReward(address _user) external view returns (uint256) {
352         User storage user = users[_user];
353         uint256 accRewardPerToken = rewardTillNowPerToken;
354 
355         if (block.number > lastUpdatedBlock) {
356             uint256 totalStakedToken = stakedToken.balanceOf(address(this));
357             uint256 rewardAmount = (block.number - lastUpdatedBlock).mul(rewardPerBlock);
358             accRewardPerToken = accRewardPerToken.add(rewardAmount.mul(scale).div(totalStakedToken));
359         }
360         uint256 reward = user.depositAmount.mul(accRewardPerToken).div(scale).sub(user.paidReward);
361 		return reward.mul(daoShare).div(scale);
362     }
363 
364 	function deposit(uint256 amount) public {
365 		depositFor(msg.sender, amount);
366     }
367 
368     function depositFor(address _user, uint256 amount) public {
369         User storage user = users[_user];
370         update();
371 
372         if (user.depositAmount > 0) {
373             uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);			
374 			sendReward(_user, _pendingReward);
375         }
376 
377         user.depositAmount = user.depositAmount.add(amount);
378         user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);
379         stakedToken.transferFrom(address(msg.sender), address(this), amount);
380         emit Deposit(_user, amount);
381     }
382 
383 	function sendReward(address user, uint256 amount) private {
384 		uint256 _daoShare = amount.mul(daoShare).div(scale);
385         rewardToken.transfer(user, amount.sub(_daoShare));
386 		rewardToken.transfer(daoWallet, _daoShare);
387         emit RewardClaimed(user, amount);
388 	}
389 
390     function withdraw(uint256 amount) public {
391         User storage user = users[msg.sender];
392         require(user.depositAmount >= amount, "withdraw amount exceeds deposited amount");
393         update();
394 
395         uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);
396 		sendReward(msg.sender, _pendingReward);
397 
398         if (amount > 0) {
399             user.depositAmount = user.depositAmount.sub(amount);
400             stakedToken.transfer(address(msg.sender), amount);
401             emit Withdraw(msg.sender, amount);
402         }
403 
404         user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);
405     }
406 
407     // Withdraw without caring about rewards. EMERGENCY ONLY.
408     function emergencyWithdraw() public {
409         User storage user = users[msg.sender];
410 
411         stakedToken.transfer(msg.sender, user.depositAmount);
412 
413         emit EmergencyWithdraw(msg.sender, user.depositAmount);
414 
415         user.depositAmount = 0;
416         user.paidReward = 0;
417     }
418 
419 	function emergencyWithdrawFor(address _user) public onlyOwner{
420         User storage user = users[_user];
421 
422         stakedToken.transfer(_user, user.depositAmount);
423 
424         emit EmergencyWithdraw(_user, user.depositAmount);
425 
426         user.depositAmount = 0;
427         user.paidReward = 0;
428     }
429 
430     function withdrawRewardTokens(address to, uint256 amount) public onlyOwner {
431         rewardToken.transfer(to, amount);
432     }
433 
434 }
435 
436 
437 //Dar panah khoda