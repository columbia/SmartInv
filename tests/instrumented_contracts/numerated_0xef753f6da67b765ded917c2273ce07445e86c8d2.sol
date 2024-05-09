1 //Be name KHODA
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
30 
31 
32 pragma solidity ^0.6.0;
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
46 contract Ownable is Context {
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
98 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
99 
100 
101 pragma solidity ^0.6.0;
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 // File: browser/Staking.sol
260 
261 //Be name khoda
262 
263 pragma solidity ^0.6.12;
264 
265 
266 
267 interface StakedToken {
268     function balanceOf(address account) external view returns (uint256);
269     function transfer(address recipient, uint256 amount) external returns (bool);
270     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
271 }
272 
273 interface RewardToken {
274     function balanceOf(address account) external view returns (uint256);
275     function transfer(address recipient, uint256 amount) external returns (bool);
276 
277 }
278 
279 contract Staking is Ownable {
280 
281     struct User {
282         uint256 depositAmount;
283         uint256 paidReward;
284     }
285 
286     using SafeMath for uint256;
287 
288     mapping (address => User) public users;
289 
290     uint256 public rewardTillNowPerToken = 0;
291     uint256 public lastUpdatedBlock;
292     uint256 public rewardPerBlock;
293     uint256 public scale = 1e18;
294 
295     uint256 public particleCollector = 0;
296     uint256 public daoShare;
297     uint256 public earlyFoundersShare;
298     address public daoWallet;
299     address public earlyFoundersWallet;
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
310     constructor (address _stakedToken, address _rewardToken, uint256 _rewardPerBlock, uint256 _daoShare, uint256 _earlyFoundersShare) public {
311         stakedToken = StakedToken(_stakedToken);
312         rewardToken = RewardToken(_rewardToken);
313         rewardPerBlock = _rewardPerBlock;
314         daoShare = _daoShare;
315         earlyFoundersShare = _earlyFoundersShare;
316         lastUpdatedBlock = block.number;
317         daoWallet = msg.sender;
318         earlyFoundersWallet = msg.sender;
319     }
320 
321     function setWallets(address _daoWallet, address _earlyFoundersWallet) public onlyOwner {
322         daoWallet = _daoWallet;
323         earlyFoundersWallet = _earlyFoundersWallet;
324     }
325 
326     function setShares(uint256 _daoShare, uint256 _earlyFoundersShare) public onlyOwner {
327         withdrawParticleCollector();
328         daoShare = _daoShare;
329         earlyFoundersShare = _earlyFoundersShare;
330     }
331 
332     function setRewardPerBlock(uint256 _rewardPerBlock) public onlyOwner {
333         update();
334         rewardPerBlock = _rewardPerBlock;
335         emit RewardPerBlockChanged(rewardPerBlock, _rewardPerBlock);
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
360         return user.depositAmount.mul(accRewardPerToken).div(scale).sub(user.paidReward);
361     }
362 
363     function deposit(uint256 amount) public {
364         User storage user = users[msg.sender];
365         update();
366 
367         if (user.depositAmount > 0) {
368             uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);
369             rewardToken.transfer(msg.sender, _pendingReward);
370             emit RewardClaimed(msg.sender, _pendingReward);
371         }
372 
373         user.depositAmount = user.depositAmount.add(amount);
374         user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);
375 
376         stakedToken.transferFrom(address(msg.sender), address(this), amount);
377         emit Deposit(msg.sender, amount);
378     }
379 
380     function withdraw(uint256 amount) public {
381         User storage user = users[msg.sender];
382         require(user.depositAmount >= amount, "withdraw amount exceeds deposited amount");
383         update();
384 
385         uint256 _pendingReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale).sub(user.paidReward);
386         rewardToken.transfer(msg.sender, _pendingReward);
387         emit RewardClaimed(msg.sender, _pendingReward);
388 
389         uint256 particleCollectorShare = _pendingReward.mul(daoShare.add(earlyFoundersShare)).div(scale);
390         particleCollector = particleCollector.add(particleCollectorShare);
391 
392         if (amount > 0) {
393             user.depositAmount = user.depositAmount.sub(amount);
394             stakedToken.transfer(address(msg.sender), amount);
395             emit Withdraw(msg.sender, amount);
396         }
397 
398         user.paidReward = user.depositAmount.mul(rewardTillNowPerToken).div(scale);
399     }
400 
401     function withdrawParticleCollector() public {
402         uint256 _daoShare = particleCollector.mul(daoShare).div(daoShare.add(earlyFoundersShare));
403         rewardToken.transfer(daoWallet, _daoShare);
404 
405         uint256 _earlyFoundersShare = particleCollector.mul(earlyFoundersShare).div(daoShare.add(earlyFoundersShare));
406         rewardToken.transfer(earlyFoundersWallet, _earlyFoundersShare);
407 
408         particleCollector = 0;
409     }
410 
411     // Withdraw without caring about rewards. EMERGENCY ONLY.
412     function emergencyWithdraw() public {
413         User storage user = users[msg.sender];
414 
415         stakedToken.transfer(msg.sender, user.depositAmount);
416 
417         emit EmergencyWithdraw(msg.sender, user.depositAmount);
418 
419         user.depositAmount = 0;
420         user.paidReward = 0;
421     }
422 
423 
424     // Add temporary withdrawal functionality for owner(DAO) to transfer all tokens to a safe place.
425     // Contract ownership will transfer to address(0x) after full auditing of codes.
426     function withdrawAllRewardTokens(address to) public onlyOwner {
427         uint256 totalRewardTokens = rewardToken.balanceOf(address(this));
428         rewardToken.transfer(to, totalRewardTokens);
429     }
430 
431     // Add temporary withdrawal functionality for owner(DAO) to transfer all tokens to a safe place.
432     // Contract ownership will transfer to address(0x) after full auditing of codes.
433     function withdrawAllStakedtokens(address to) public onlyOwner {
434         uint256 totalStakedTokens = stakedToken.balanceOf(address(this));
435         stakedToken.transfer(to, totalStakedTokens);
436     }
437 
438 }
439 
440 
441 //Dar panah khoda