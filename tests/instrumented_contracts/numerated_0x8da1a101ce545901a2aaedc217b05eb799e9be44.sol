1 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
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
18     function _msgSender() internal virtual view returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal virtual view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
29 
30 // pragma solidity ^0.6.0;
31 
32 // import "@openzeppelin/contracts/GSN/Context.sol";
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
98 
99 // pragma solidity ^0.6.0;
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // Root file: contracts/TempusStake.sol
270 
271 pragma solidity ^0.6.10;
272 
273 // import "@openzeppelin/contracts/access/Ownable.sol";
274 // import "@openzeppelin/contracts/math/SafeMath.sol";
275 
276 interface ITempusToken {
277     function totalSupply() external view returns (uint256);
278 
279     function balanceOf(address account) external view returns (uint256);
280 
281     function transfer(address recipient, uint256 amount) external returns (bool);
282 
283     function allowance(address owner, address spender) external view returns (uint256);
284 
285     function approve(address spender, uint256 amount) external returns (bool);
286 
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) external returns (bool);
292 
293     function burn(uint256 amount) external;
294 
295     function transferReward(address to, uint256 amount) external;
296 
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     event Approval(address indexed owner, address indexed spender, uint256 value);
300 }
301 
302 interface IUniswapV2Pair {
303     function sync() external;
304 }
305 
306 contract TempusStake is Ownable {
307     using SafeMath for uint256;
308 
309     ITempusToken private tempusToken;
310     address private uniswapPool;
311 
312     bool public allowStaking = false;
313     uint256 public unstakeTax = 7;
314 
315     uint256 public constant BURN_RATE = 2;
316     uint256 public constant BURN_REWARD = 2;
317     uint256 public constant POOL_REWARD = 48;
318     uint256 public rewardPool;
319     uint256 public lastBurnTime;
320     uint256 public totalBurned;
321 
322     uint256 public totalStakedTokens;
323     uint256 public totalStakedTokenTime;
324     uint256 public rewardShareClaimed;
325     uint256 private lastAccountingTimestamp;
326 
327     struct UserTotals {
328         uint256 stakedTokens;
329         uint256 totalStakedTokenTime;
330         uint256 lastAccountingTimestamp;
331         uint256 lastRewardClaimedTimestamp;
332     }
333 
334     mapping(address => UserTotals) private _userTotals;
335 
336     modifier stakingEnabled {
337         require(allowStaking, "TempusStake: Staking is not enabled.");
338         _;
339     }
340 
341     event Stake(address addr, uint256 amount, uint256 totalStaked);
342     event Unstake(address addr, uint256 withdrawAmount, uint256 tax);
343     event SanitisePool(
344         address caller,
345         uint256 burnAmount,
346         uint256 userReward,
347         uint256 poolReward,
348         uint256 tempusSupply,
349         uint256 uniswapBalance
350     );
351     event ClaimReward(address addr, uint256 rewardAmount, uint256 rewardPool);
352 
353     constructor(ITempusToken _tempusToken, address _uniswapPool) public Ownable() {
354         tempusToken = _tempusToken;
355         uniswapPool = _uniswapPool;
356     }
357 
358     function info(address value)
359         external
360         view
361         returns (
362             uint256,
363             uint256,
364             uint256,
365             uint256,
366             uint256,
367             uint256,
368             uint256,
369             uint256
370         )
371     {
372         return (
373             _userTotals[value].stakedTokens,
374             _userTotals[value].totalStakedTokenTime,
375             _userTotals[value].lastAccountingTimestamp,
376             _userTotals[value].lastRewardClaimedTimestamp,
377             totalStakedTokens,
378             totalStakedTokenTime,
379             rewardPool,
380             lastAccountingTimestamp
381         );
382     }
383 
384     function updateGlobalStakedTokenTime() internal {
385         if (lastAccountingTimestamp == 0) {
386             lastAccountingTimestamp = now;
387         }
388         uint256 newStakedTokenTime = now.sub(lastAccountingTimestamp).mul(totalStakedTokens);
389         totalStakedTokenTime = totalStakedTokenTime.add(newStakedTokenTime);
390         lastAccountingTimestamp = now;
391     }
392 
393     function updateUserStakedTokenTime(UserTotals storage totals) internal {
394         uint256 currentStakedTokenTime = now.sub(totals.lastAccountingTimestamp).mul(totals.stakedTokens);
395         totals.totalStakedTokenTime = currentStakedTokenTime.add(totals.totalStakedTokenTime);
396         totals.lastAccountingTimestamp = now;
397     }
398 
399     function stake(uint256 amount) external stakingEnabled {
400         require(amount >= 1e18, "TempusStake: minimum stake amount is 1");
401         require(tempusToken.balanceOf(msg.sender) >= amount, "TempusStake: amount is greater than senders balance");
402 
403         UserTotals storage totals = _userTotals[msg.sender];
404 
405         updateGlobalStakedTokenTime();
406         updateUserStakedTokenTime(totals);
407 
408         totals.stakedTokens = totals.stakedTokens.add(amount);
409 
410         totalStakedTokens = totalStakedTokens.add(amount);
411 
412         tempusToken.transferFrom(msg.sender, address(this), amount);
413 
414         emit Stake(msg.sender, amount, totals.stakedTokens);
415     }
416 
417     function unstake() external stakingEnabled {
418         UserTotals storage totals = _userTotals[msg.sender];
419 
420         updateGlobalStakedTokenTime();
421         updateUserStakedTokenTime(totals);
422 
423         uint256 withdrawAmount = totals.stakedTokens;
424         uint256 tax = withdrawAmount.mul(unstakeTax).div(100);
425 
426         rewardPool = rewardPool.add(tax);
427         totalStakedTokens = totalStakedTokens.sub(withdrawAmount);
428 
429         totalStakedTokenTime = totalStakedTokenTime.sub(totals.totalStakedTokenTime);
430         totals.stakedTokens = 0;
431         totals.lastAccountingTimestamp = 0;
432         totals.lastRewardClaimedTimestamp = 0;
433         totals.totalStakedTokenTime = 0;
434 
435         tempusToken.transfer(msg.sender, withdrawAmount.sub(tax));
436 
437         emit Unstake(msg.sender, withdrawAmount, tax);
438     }
439 
440     function sanitisePool() external stakingEnabled {
441         uint256 timeSinceLastBurn = now - lastBurnTime;
442         require(timeSinceLastBurn >= 6 hours, "TempusStake: only 1 burn every 6 hours");
443 
444         uint256 burnAmount = getBurnAmount();
445         require(burnAmount >= 1 * 1e18, "TempusStake: min burn amount not reached.");
446 
447         // Reset last burn time
448         lastBurnTime = now;
449 
450         uint256 userReward = burnAmount.mul(BURN_REWARD).div(100);
451         uint256 poolReward = burnAmount.mul(POOL_REWARD).div(100);
452         uint256 finalBurn = burnAmount.sub(userReward).sub(poolReward);
453 
454         tempusToken.burn(finalBurn);
455 
456         totalBurned = totalBurned.add(finalBurn);
457         rewardPool = rewardPool.add(poolReward);
458         rewardShareClaimed = 0;
459 
460         tempusToken.transferReward(msg.sender, userReward);
461         tempusToken.transferReward(address(this), poolReward);
462 
463         IUniswapV2Pair(uniswapPool).sync();
464 
465         uint256 tempusSupply = tempusToken.totalSupply();
466         uint256 uniswapBalance = tempusToken.balanceOf(uniswapPool);
467 
468         emit SanitisePool(msg.sender, finalBurn, userReward, poolReward, tempusSupply, uniswapBalance);
469     }
470 
471     function getBurnAmount() public view stakingEnabled returns (uint256) {
472         uint256 tokensInUniswapPool = tempusToken.balanceOf(uniswapPool);
473         return tokensInUniswapPool.mul(BURN_RATE).div(100);
474     }
475 
476     function claimReward() external {
477         require(rewardPool > 1e18, "TempusStake: reward pool is too small.");
478 
479         UserTotals storage totals = _userTotals[msg.sender];
480 
481         require(totals.stakedTokens > 0, "TempusStake: user is not staked.");
482         require(userCanClaim(totals), "TempusStake: reward from this burn already claimed.");
483 
484         updateGlobalStakedTokenTime();
485         updateUserStakedTokenTime(totals);
486 
487         uint256 rewardShare = rewardShare(totals.totalStakedTokenTime);
488 
489         uint256 rewardAmount = rewardPool.mul(rewardShare).div(10000);
490         totals.stakedTokens = totals.stakedTokens.add(rewardAmount);
491         totals.lastRewardClaimedTimestamp = now;
492 
493         totalStakedTokens = totalStakedTokens.add(rewardAmount);
494         rewardPool = rewardPool.sub(rewardAmount);
495         rewardShareClaimed = rewardShareClaimed.add(rewardShare);
496 
497         emit ClaimReward(msg.sender, rewardAmount, rewardPool);
498     }
499 
500     function setAllowStaking(bool value) external onlyOwner {
501         allowStaking = value;
502         lastBurnTime = now;
503     }
504 
505     function userCanClaim(UserTotals memory totals) internal view returns (bool) {
506         uint256 timeSinceLastBurn = now - lastBurnTime;
507         uint256 timeSinceLastClaim = now - totals.lastRewardClaimedTimestamp;
508         return (totals.lastRewardClaimedTimestamp == 0 || timeSinceLastClaim > timeSinceLastBurn);
509     }
510 
511     function rewardShare(uint256 userTokenTime) internal view returns (uint256) {
512         uint256 max = 10000;
513         uint256 shareLeft = max.sub(rewardShareClaimed);
514         uint256 globalTokenTime = totalStakedTokenTime.mul(shareLeft).div(max);
515         uint256 dec = 10**uint256(18);
516         uint256 prec = 10000 * dec;
517         uint256 gtt = globalTokenTime * dec;
518         uint256 utt = userTokenTime * dec;
519         uint256 share = utt.mul(dec).div(gtt);
520         return share.mul(prec).div(dec) / dec;
521     }
522 }