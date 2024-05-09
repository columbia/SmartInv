1 /*
2 * Copyright (c) 2020 DeFiat.net
3 *
4 * Permission is hereby granted, free of charge, to any person obtaining a copy
5 * of this software and associated documentation files (the "Software"), to deal
6 * in the Software without restriction, including without limitation the rights
7 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8 * copies of the Software, and to permit persons to whom the Software is
9 * furnished to do so, subject to the following conditions:
10 *
11 * The above copyright notice and this permission notice shall be included in all
12 * copies or substantial portions of the Software.
13 *
14 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
18 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
20 */
21 
22 // File: @openzeppelin/contracts/math/Math.sol
23 //
24 
25 // File: @openzeppelin/contracts/math/SafeMath.sol
26 pragma solidity ^0.6.0;
27 /**
28  * @dev Wrappers over Solidity's arithmetic operations with added overflow
29  * checks.
30  *
31  * Arithmetic operations in Solidity wrap on overflow. This can easily result
32  * in bugs, because programmers usually assume that an overflow raises an
33  * error, which is the standard behavior in high level programming languages.
34  * `SafeMath` restores this intuition by reverting the transaction when an
35  * operation overflows.
36  *
37  * Using this library instead of the unchecked operations eliminates an entire
38  * class of bugs, so it's recommended to use it always.
39  */
40 library SafeMath{
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `+` operator.
46      *
47      * Requirements:
48      * - Addition cannot overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      * - Subtraction cannot overflow.
78      *
79      * _Available since v2.4.0._
80      */
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      * - Multiplication cannot overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99         // benefit is lost if 'b' is also tested.
100         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      *
137      * _Available since v2.4.0._
138      */
139     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         // Solidity only automatically asserts when dividing by 0
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return mod(a, b, "SafeMath: modulo by zero");
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts with custom message when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      *
174      * _Available since v2.4.0._
175      */
176     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b != 0, errorMessage);
178         return a % b;
179     }
180     
181         /**
182      * @dev Returns the largest of two numbers.
183      */
184     function max(uint256 a, uint256 b) internal pure returns (uint256) {
185         return a >= b ? a : b;
186     }
187 
188     /**
189      * @dev Returns the smallest of two numbers.
190      */
191     function min(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a < b ? a : b;
193     }
194 
195     /**
196      * @dev Returns the average of two numbers. The result is rounded towards
197      * zero.
198      */
199     function average(uint256 a, uint256 b) internal pure returns (uint256) {
200         // (a + b) / 2 can overflow, so we distribute
201         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
202     }
203 }
204 
205 // File: @openzeppelin/contracts/GSN/Context.sol
206 /*
207  * @dev Provides information about the current execution context, including the
208  * sender of the transaction and its data. While these are generally available
209  * via msg.sender and msg.data, they should not be accessed in such a direct
210  * manner, since when dealing with GSN meta-transactions the account sending and
211  * paying for execution may not be the actual sender (as far as an application
212  * is concerned).
213  *
214  * This contract is only required for intermediate, library-like contracts.
215  */
216 contract Context {
217     // Empty internal constructor, to prevent people from mistakenly deploying
218     // an instance of this contract, which should be used via inheritance.
219     constructor () internal { }
220     // solhint-disable-previous-line no-empty-blocks
221 
222     function _msgSender() internal view returns (address payable) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view returns (bytes memory) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/ownership/Ownable.sol
233 /**
234  * @dev Contract module which provides a basic access control mechanism, where
235  * there is an account (an owner) that can be granted exclusive access to
236  * specific functions.
237  *
238  * This module is used through inheritance. It will make available the modifier
239  * `onlyOwner`, which can be applied to your functions to restrict their use to
240  * the owner.
241  */
242 contract Ownable is Context {
243     address private _owner;
244 
245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
246 
247     /**
248      * @dev Initializes the contract setting the deployer as the initial owner.
249      */
250     constructor () internal {
251         _owner = _msgSender();
252         emit OwnershipTransferred(address(0), _owner);
253     }
254 
255     /**
256      * @dev Returns the address of the current owner.
257      */
258     function owner() public view returns (address) {
259         return _owner;
260     }
261 
262     /**
263      * @dev Throws if called by any account other than the owner.
264      */
265     modifier onlyOwner() {
266         require(isOwner(), "Ownable: caller is not the owner");
267         _;
268     }
269 
270 
271     /**
272      * @dev Returns true if the caller is the current owner.
273      */
274     function isOwner() public view returns (bool) {
275         return _msgSender() == _owner;
276     }
277 
278     /**
279      * @dev Leaves the contract without owner. It will not be possible to call
280      * `onlyOwner` functions anymore. Can only be called by the current owner.
281      *
282      * NOTE: Renouncing ownership will leave the contract without an owner,
283      * thereby removing any functionality that is only available to the owner.
284      */
285     function renounceOwnership() public onlyOwner {
286         emit OwnershipTransferred(_owner, address(0));
287         _owner = address(0);
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public onlyOwner {
295         _transferOwnership(newOwner);
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      */
301     function _transferOwnership(address newOwner) internal {
302         require(newOwner != address(0), "Ownable: new owner is the zero address");
303         emit OwnershipTransferred(_owner, newOwner);
304         _owner = newOwner;
305     }
306 } //adding ALLOWED method
307 
308 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
309 /**
310  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
311  * the optional functions; to access them see {ERC20Detailed}.
312  */
313 interface IERC20 {
314     function totalSupply() external view returns (uint256);
315     function balanceOf(address account) external view returns (uint256);
316     function transfer(address recipient, uint256 amount) external returns (bool);
317     function allowance(address owner, address spender) external view returns (uint256);
318     function approve(address spender, uint256 amount) external returns (bool);
319     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
320     event Transfer(address indexed from, address indexed to, uint256 value);
321     event Approval(address indexed owner, address indexed spender, uint256 value);
322 }
323 
324 // File: @openzeppelin/contracts/utils/Address.sol
325 /**
326  * @dev Collection of functions related to the address type
327  */
328 library Address {
329     /**
330      * @dev Returns true if `account` is a contract.
331      *
332      * This test is non-exhaustive, and there may be false-negatives: during the
333      * execution of a contract's constructor, its address will be reported as
334      * not containing a contract.
335      *
336      * IMPORTANT: It is unsafe to assume that an address for which this
337      * function returns false is an externally-owned account (EOA) and not a
338      * contract.
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies in extcodesize, which returns 0 for contracts in
342         // construction, since the code is only stored at the end of the
343         // constructor execution.
344 
345         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
346         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
347         // for accounts without code, i.e. `keccak256('')`
348         bytes32 codehash;
349         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
350         // solhint-disable-next-line no-inline-assembly
351         assembly { codehash := extcodehash(account) }
352         return (codehash != 0x0 && codehash != accountHash);
353     }
354 
355     /**
356      * @dev Converts an `address` into `address payable`. Note that this is
357      * simply a type cast: the actual underlying value is not changed.
358      *
359      * _Available since v2.4.0._
360      */
361     function toPayable(address account) internal pure returns (address payable) {
362         return address(uint160(account));
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      *
381      * _Available since v2.4.0._
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(address(this).balance >= amount, "Address: insufficient balance");
385 
386         // solhint-disable-next-line avoid-call-value
387         (bool success, ) = recipient.call.value(amount)("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 }
391 
392 
393 //========
394 
395 
396 contract DeFiat_Farming_v15 {
397     using SafeMath for uint256;
398 
399     //Structs
400     struct PoolMetrics {
401         address stakedToken;
402         uint256 staked;             // sum of tokens staked in the contract
403         uint256 stakingFee;         // entry fee
404         
405         uint256 stakingPoints;
406 
407         address rewardToken;
408         uint256 rewards;        // current rewards in the pool
409 
410         uint256 startTime;      // when the pool opens
411         uint256 closingTime;    // when the pool closes. 
412         uint256 duration;       // duration of the staking
413         uint256 lastEvent;   // last time metrics were updated.
414         
415         uint256  ratePerToken;      // CALCULATED pool reward Rate per Token (calculated based on total stake and time)
416     }
417     PoolMetrics public poolMetrics;
418 
419     struct UserMetrics {
420             uint256 stake;          // native token stake (balanceOf)
421             uint256 stakingPoints;  // staking points at lastEvent
422             uint256 poolPoints;     // pool point at lastEvent
423             uint256 lastEvent;
424 
425             uint256 rewardAccrued;  // accrued rewards over time based on staking points
426             uint256 rewardsPaid;    // for information only
427 
428             uint256 lastTxBlock;    // latest transaction from the user (antiSpam)
429     }
430     mapping(address => UserMetrics) public userMetrics;
431 
432 //== constructor 
433     constructor(address _stakedToken, address _rewardToken, uint256 _feeBase1000, uint256 _durationHours, uint256 _delayStartHours) public {
434     poolOperator = msg.sender;
435     
436     poolMetrics.stakedToken = address(_stakedToken);
437     poolMetrics.rewardToken = address(_rewardToken);
438     poolMetrics.stakingFee = _feeBase1000; //10 = 1%
439     
440     poolMetrics.duration = _durationHours.mul(3600); //
441     poolMetrics.startTime = block.timestamp + _delayStartHours.mul(3600);
442     poolMetrics.closingTime = poolMetrics.startTime + poolMetrics.duration; //corrected following report
443     
444     poolMetrics.stakingPoints = 1; //avoids div by 0 at start
445     FullRewards = true;
446     }
447 
448 //==Events
449     event PoolInitalized(uint256 amountAdded, string  _desc);
450     event RewardTaken(address indexed user, uint256 reward, string  _desc);
451 
452     event userStaking(address indexed user, uint256 amount, string  _desc);
453     event userWithdrawal(address indexed user, uint256 amount, string  _desc);
454 
455     modifier poolLive() {
456         require(block.timestamp >= poolMetrics.startTime,"Pool not started Yet"); //good for delayed starts.
457         require(block.timestamp <= poolMetrics.closingTime,"Pool closed"); //good for delayed starts.
458         _;
459     }
460     modifier poolStarted() {
461         require(block.timestamp >= poolMetrics.startTime,"Pool not started Yet"); //good for delayed starts.
462         _;
463     }
464     modifier poolEnded() {
465         require(block.timestamp > poolMetrics.closingTime,"Pool not ended Yet"); //good for delayed starts.
466         _;
467     }
468     modifier antiSpam(uint256 _blocks) {
469         require(block.number > userMetrics[msg.sender].lastTxBlock.add(_blocks), "Wait X BLOCKS between Transactions");
470         userMetrics[msg.sender].lastTxBlock = block.number; //update
471         _;
472     } 
473     
474 //==Basics 
475     function currentTime() public view returns (uint256) {
476         return SafeMath.min(block.timestamp, poolMetrics.closingTime); //allows expiration
477     } // SafeMath.min(now, endTime)
478     
479 //==Points locking    
480     function viewPoolPoints() public view returns(uint256) {
481             uint256 _previousPoints = poolMetrics.stakingPoints;    // previous points shapshot 
482             uint256 _previousStake = poolMetrics.staked;             // previous stake snapshot
483             
484             uint256 _timeHeld = currentTime().sub(
485                         SafeMath.max(poolMetrics.lastEvent, poolMetrics.startTime)
486                                                  );                 // time held with _previous Event
487                                                  
488             return  _previousPoints.add(_previousStake.mul(_timeHeld));    //generated points since event
489     }
490     function lockPoolPoints() internal returns (uint256) { //ON STAKE/UNSTAKE EVENT
491             poolMetrics.stakingPoints = viewPoolPoints();
492             poolMetrics.lastEvent = currentTime();   // update lastStakingEvent
493             return poolMetrics.stakingPoints;
494         } 
495     
496     function viewPointsOf(address _address) public view returns(uint256) {
497             uint256 _previousPoints = userMetrics[_address].stakingPoints;    // snapshot
498             uint256 _previousStake = userMetrics[_address].stake;             // stake before event
499         
500             uint256 _timeHeld = currentTime().sub(
501                         SafeMath.max(userMetrics[_address].lastEvent, poolMetrics.startTime)
502                                                  );                          // time held since lastEvent (take RWD, STK, unSTK)
503             
504             uint256 _result = _previousPoints.add(_previousStake.mul(_timeHeld));   
505             
506             if(_result > poolMetrics.stakingPoints){_result = poolMetrics.stakingPoints;}
507             return _result;
508     }
509     function lockPointsOf(address _address) internal returns (uint256) {
510             userMetrics[_address].poolPoints = viewPoolPoints();  // snapshot of pool points at lockEvent
511             userMetrics[_address].stakingPoints = viewPointsOf(_address); 
512             userMetrics[_address].lastEvent = currentTime(); 
513 
514             return userMetrics[_address].stakingPoints;
515     }
516     function pointsSnapshot(address _address) public returns (bool) {
517         lockPointsOf(_address);lockPoolPoints();
518         return true;
519     }
520     
521 //==Rewards
522     function viewTrancheReward(uint256 _period) internal view returns(uint256) {
523         //uint256 _poolRewards = poolMetrics.rewards; //tokens in the pool. Note: This can be setup to a fixed amount (totalRewards)
524         uint256 _poolRewards = totalRewards; 
525         
526         if(FullRewards == false){ _poolRewards = SafeMath.min(poolMetrics.staked, _poolRewards);} 
527         // baseline is the min( staked, rewards); avoids ultra_farming > staking pool - EXPERIMENTAL
528         
529         uint256 _timeRate = _period.mul(1e18).div(poolMetrics.duration);
530         return _poolRewards.mul(_timeRate).div(1e18); //tranche of rewards on period
531     }
532     
533     function userRateOnPeriod(address _address) public view returns (uint256){
534         //calculates the delta of pool points and user points since last Event
535         uint256 _deltaUser = viewPointsOf(_address).sub(userMetrics[_address].stakingPoints); // points generated since lastEvent
536         uint256 _deltaPool = viewPoolPoints().sub(userMetrics[_address].poolPoints);          // pool points generated since lastEvent
537         uint256 _rate = 0;
538         if(_deltaUser == 0 || _deltaPool == 0 ){_rate = 0;} //rounding
539         else {_rate = _deltaUser.mul(1e18).div(_deltaPool);}
540         return _rate;
541         
542     }
543     
544     function viewAdditionalRewardOf(address _address) public view returns(uint256) { // rewards generated since last Event
545         require(poolMetrics.rewards > 0, "No Rewards in the Pool");
546         
547   
548         // user weighted average share of Pool since lastEvent
549         uint256 _userRateOnPeriod = userRateOnPeriod(_address); //can drop if pool size increases within period -> slows rewards generation
550         
551         // Pool Yield Rate 
552         uint256 _period = currentTime().sub(
553                             SafeMath.max(userMetrics[_address].lastEvent, poolMetrics.startTime)  
554                             );        // time elapsed since last reward or pool started (if never taken rewards)
555 
556         // Calculate reward
557         uint256 _reward = viewTrancheReward(_period).mul(_userRateOnPeriod).div(1e18);  //user rate on pool rewards' tranche
558 
559         return _reward;
560     }
561     
562     function lockRewardOf(address _address) public returns(uint256) {
563         uint256 _additional = viewAdditionalRewardOf(_address); //stakeShare(sinceLastEvent) * poolRewards(sinceLastEvent)
564         userMetrics[_address].rewardAccrued = userMetrics[_address].rewardAccrued.add(_additional); //snapshot rewards.
565         
566         pointsSnapshot(_address); //updates lastEvent and points
567         return userMetrics[_address].rewardAccrued;
568     }  
569     
570     function takeRewards() public poolStarted antiSpam(1) { //1 blocks between rewards
571         require(poolMetrics.rewards > 0, "No Rewards in the Pool");
572         
573         uint256 _reward = lockRewardOf(msg.sender); //returns already accrued + additional (also resets time counters)
574 
575         userMetrics[msg.sender].rewardsPaid = _reward;   // update user paid rewards
576         
577         userMetrics[msg.sender].rewardAccrued = 0; //flush previously accrued rewards.
578         
579         poolMetrics.rewards = poolMetrics.rewards.sub(_reward);           // update pool rewards
580             
581         IERC20(poolMetrics.rewardToken).transfer(msg.sender, _reward);  // transfer
582             
583         pointsSnapshot(msg.sender); //updates lastEvent
584         //lockRewardOf(msg.sender);
585             
586         emit RewardTaken(msg.sender, _reward, "Rewards Sent");          
587     }
588     
589 //==staking & unstaking
590 
591     modifier antiWhale(address _address) {
592         require(myStakeShare(_address) < 20000, "User stake% share too high. Leave some for the smaller guys ;-)"); //max 20%
593         _;
594     } 
595     // avoids stakes being deposited once a user reached 20%. 
596     // Simplistic implementation as if we calculate "futureStake" value very 1st stakers will not be able to deposit.
597     
598     function stake(uint256 _amount) public poolLive antiSpam(1) antiWhale(msg.sender){
599         require(_amount > 0, "Cannot stake 0");
600         
601         //initialize
602         userMetrics[msg.sender].rewardAccrued = lockRewardOf(msg.sender); //Locks previous eligible rewards based on lastRewardEvent and lastStakingEvent
603         pointsSnapshot(msg.sender);
604 
605         //receive staked
606         uint256 _balanceNow = IERC20(address(poolMetrics.stakedToken)).balanceOf(address(this));
607         IERC20(poolMetrics.stakedToken).transferFrom(msg.sender, address(this), _amount); //will require allowance
608         uint256 amount = IERC20(address(poolMetrics.stakedToken)).balanceOf(address(this)).sub(_balanceNow); //actually received
609         
610         //update pool and user based on stake and fee
611         uint256 _fee = amount.mul(poolMetrics.stakingFee).div(1000);
612         amount = amount.sub(_fee);
613         
614         if(poolMetrics.stakedToken == poolMetrics.rewardToken){poolMetrics.rewards = poolMetrics.rewards.add(_fee);}
615         poolMetrics.staked = poolMetrics.staked.add(amount);
616         userMetrics[msg.sender].stake = userMetrics[msg.sender].stake.add(amount);
617 
618         //finalize
619         pointsSnapshot(msg.sender); //updates lastEvent
620         emit userStaking(msg.sender, amount, "Staking... ... ");
621         
622     } 
623     
624     function unStake(uint256 _amount) public poolStarted antiSpam(1) { 
625         require(_amount > 0, "Cannot withdraw 0");
626         require(_amount <= userMetrics[msg.sender].stake, "Cannot withdraw more than stake");
627 
628         //initialize
629         userMetrics[msg.sender].rewardAccrued = lockRewardOf(msg.sender); //snapshot of  previous eligible rewards based on lastStakingEvent
630         pointsSnapshot(msg.sender);
631 
632         // update metrics
633         userMetrics[msg.sender].stake = userMetrics[msg.sender].stake.sub(_amount);
634         poolMetrics.staked = poolMetrics.staked.sub(_amount);
635 
636         // transfer _amount. Put at the end of the function to avoid reentrancy.
637         IERC20(poolMetrics.stakedToken).transfer(msg.sender, _amount);
638         
639         //finalize
640         emit userWithdrawal(msg.sender, _amount, "Widhtdrawal");
641     }
642 
643     function myStake(address _address) public view returns(uint256) {
644         return userMetrics[_address].stake;
645     }
646     function myStakeShare(address _address) public view returns(uint256) {
647         if(poolMetrics.staked == 0){return 0;}
648         else {
649         return (userMetrics[_address].stake).mul(100000).div(poolMetrics.staked);}
650     } //base 100,000
651     function myPointsShare(address _address) public view returns(uint256) {  //weighted average of your stake over time vs the pool
652         return viewPointsOf(_address).mul(100000).div(viewPoolPoints());
653     } //base 100,000. Drops when taking rewards.=> Refills after (favors strong hands)
654     function myRewards(address _address) public view returns(uint256) {
655         //delayed start obfuscation (avoids disturbances in the force...)
656         if(block.timestamp <= poolMetrics.startTime || poolMetrics.rewards == 0){return 0;}
657         else { return userMetrics[_address].rewardAccrued.add(viewAdditionalRewardOf(_address));} //previousLock + time based extra
658     }
659 
660 //== OPERATOR FUNCTIONS ==
661 
662     address public poolOperator;
663     
664     function setPoolOperator(address _address) public onlyPoolOperator {
665         poolOperator = _address;
666     }
667     modifier onlyPoolOperator() {
668         require(msg.sender == poolOperator, "msg.sender is not allowed to operate Pool");
669         _;
670     }
671     
672     bool public FullRewards;
673     uint256 totalRewards;
674     
675     function setFullRewards(bool _bool) public onlyPoolOperator {
676         FullRewards = _bool;
677     }
678     function loadRewards(uint256 _amount, uint256 _preStake) public onlyPoolOperator { //load tokens in the rewards pool.
679         
680         uint256 _balanceNow = IERC20(address(poolMetrics.rewardToken)).balanceOf(address(this));
681         IERC20(address(poolMetrics.rewardToken)).transferFrom( msg.sender,  address(this),  _amount);
682         uint256 amount = IERC20(address(poolMetrics.rewardToken)).balanceOf(address(this)).sub(_balanceNow); //actually received
683         
684 
685         if(poolMetrics.rewards == 0){                                   // initialization
686         poolMetrics.staked = SafeMath.add(poolMetrics.staked,_preStake);}  // creates baseline for pool. Avoids massive movements on rewards
687         
688         poolMetrics.rewards = SafeMath.add(poolMetrics.rewards,amount);
689         totalRewards = totalRewards.add(_amount);
690     }    
691     function setFee(uint256 _fee) public onlyPoolOperator {
692         poolMetrics.stakingFee = _fee;
693     }
694     
695     function flushPool(address _recipient, address _ERC20address) external onlyPoolOperator poolEnded { // poolEnded { // poolEnded returns(bool) {
696             uint256 _amount = IERC20(_ERC20address).balanceOf(address(this));
697             IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer
698             //return true;
699         } //get tokens sent by error to contract
700     function killPool() public onlyPoolOperator poolEnded returns(bool) {
701             selfdestruct(msg.sender);
702         } //frees space on the ETH chain
703 
704 }