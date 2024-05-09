1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 pragma solidity 0.8.0;
231 
232 
233 interface IStaking {
234     function getEpochId(uint timestamp) external view returns (uint); // get epoch id
235     function getEpochUserBalance(address user, address token, uint128 epoch) external view returns(uint);
236     function getEpochPoolSize(address token, uint128 epoch) external view returns (uint);
237     function epoch1Start() external view returns (uint);
238     function epochDuration() external view returns (uint);
239     function hasReferrer(address addr) external view returns(bool);
240     function referrals(address addr) external view returns(address);
241     function firstReferrerRewardPercentage() external view returns(uint256);
242     function secondReferrerRewardPercentage() external view returns(uint256);
243     function isStakeFinished(address staker) external view returns (bool);
244     function stakeData(address staker) external view returns (uint256 startEpoch, uint256 endEpoch, bool active);
245     function stakeEndEpoch(address staker) external view returns (uint128);
246     function calcDurationBonusMultiplier(uint128 epochId, address staker) external view returns (uint256);
247 }
248 
249 interface Minter {
250     function mint(address to, uint256 amount) external;
251 }
252 
253 contract SwappYieldFarm {
254     // lib
255     using SafeMath for uint;
256     using SafeMath for uint128;
257 
258     // constants
259     uint public constant NR_OF_EPOCHS = 60;
260     uint256 constant private CALC_MULTIPLIER = 1000000;
261 
262     // addreses
263     address private _swappAddress = 0x8CB924583681cbFE487A62140a994A49F833c244;
264     address private _owner;
265     bool private _paused = false;
266     // contracts
267     IStaking private _staking;
268 	Minter private _minter;
269 
270     uint[] private epochs = new uint[](NR_OF_EPOCHS + 1);
271     uint128 public lastInitializedEpoch;
272     mapping(address => uint128) public lastEpochIdHarvested;
273     uint public epochDuration; // init from staking contract
274     uint public epochStart; // init from staking contract
275 
276     mapping(uint128 => uint256) public epochAmounts;
277     mapping(uint128 => uint256) public epochDurationBonus;
278     mapping(address => uint256) public collectedDurationBonus;
279     
280     modifier onlyStaking() {
281         require(msg.sender == address(_staking), "Only staking contract can perfrom this action");
282         _;
283     }
284     
285     modifier onlyOwner() {
286         require(msg.sender == _owner, "Only owner can perfrom this action");
287         _;
288     }
289     
290     modifier whenNotPaused() {
291         require(!paused(), "Contract is paused");
292         _;
293     }
294 
295     // events
296     event MassHarvest(address indexed user, uint256 epochsHarvested, uint256 totalValue);
297     event Harvest(address indexed user, uint128 indexed epochId, uint256 amount);
298     event ReferrerRewardCollected(address indexed staker, address indexed referrer, uint256 rewardAmount);
299     event Referrer2RewardCollected(address indexed staker, address indexed referrer, address indexed referrer2, uint256 rewardAmount);
300     event DurationBonusCollected(address indexed staker, uint128 indexed epochId, uint256 bonusAmount);
301     event DurationBonusDistributed(address indexed staker, uint128 indexed epochId, uint256 bonusAmount);
302     event DurationBonusLost(address indexed staker, uint128 indexed epochId, uint256 bonusAmount);
303 
304     // constructor
305     constructor() {
306         _staking = IStaking(0x60F4D3e409Ad2Bb6BF5edFBCC85691eE1977cf35);
307 		_minter = Minter(0xBC1f9993ea5eE2C77909bf43d7a960bB8dA8C9B9);
308 
309         epochDuration = _staking.epochDuration();
310         epochStart = _staking.epoch1Start();
311 
312         _owner = msg.sender;
313         
314         _initEpochReward();
315         _initDurationBonus();
316     }
317 
318     function setEpochAmount(uint128 epochId, uint256 amount) external onlyOwner {
319         require(epochId > 0 && epochId <= NR_OF_EPOCHS, "Minimum epoch number is 1 and Maximum number of epochs is 60");
320         require(epochId > _getEpochId(), "Only future epoch can be updated");
321         epochAmounts[epochId] = amount;
322     }
323     
324     function setEpochDurationBonus(uint128 epochId, uint256 amount) external onlyOwner {
325         require(epochId > 0 && epochId <= NR_OF_EPOCHS, "Minimum epoch number is 1 and Maximum number of epochs is 60");
326         require(epochId > _getEpochId(), "Only future epoch can be updated");
327         epochDurationBonus[epochId] = amount;
328     }
329 
330     function getTotalAmountPerEpoch(uint128 epoch) public view returns (uint) {
331         return epochAmounts[epoch].mul(10**18);
332     }
333     
334     function getDurationBonusPerEpoch(uint128 epoch) public view returns (uint) {
335         return epochDurationBonus[epoch].mul(10**18);
336     }
337     
338     function getCurrentEpochAmount() public view returns (uint) {
339         uint128 currentEpoch = _getEpochId();
340         if (currentEpoch <= 0 || currentEpoch > NR_OF_EPOCHS) {
341             return 0;
342         }
343 
344         return epochAmounts[currentEpoch];
345     }
346     
347     function getCurrentEpochDurationBonus() public view returns (uint) {
348         uint128 currentEpoch = _getEpochId();
349         if (currentEpoch <= 0 || currentEpoch > NR_OF_EPOCHS) {
350             return 0;
351         }
352 
353         return epochDurationBonus[currentEpoch];
354     }
355 
356     function getTotalDistributedAmount() external view returns(uint256) {
357         uint256 totalDistributed;
358         for (uint128 i = 1; i <= NR_OF_EPOCHS; i++) {
359             totalDistributed += epochAmounts[i];
360         }
361         return totalDistributed;
362     } 
363     
364     function getTotalDurationBonus() external view returns(uint256) {
365         uint256 totalBonus;
366         for (uint128 i = 1; i <= NR_OF_EPOCHS; i++) {
367             totalBonus += epochDurationBonus[i];
368         }
369         return totalBonus;
370     } 
371 
372     // public methods
373     // public method to harvest all the unharvested epochs until current epoch - 1
374     function massHarvest() external whenNotPaused returns (uint){
375         uint totalDistributedValue;
376         uint epochId = _getEpochId().sub(1); // fails in epoch 0
377         // force max number of epochs
378         if (epochId > NR_OF_EPOCHS) {
379             epochId = NR_OF_EPOCHS;
380         }
381 
382         for (uint128 i = lastEpochIdHarvested[msg.sender] + 1; i <= epochId; i++) {
383             // i = epochId
384             // compute distributed Value and do one single transfer at the end
385             totalDistributedValue += _harvest(i);
386             
387             uint256 durationBonus = _calcDurationBonus(i);
388             if (durationBonus > 0) {
389                 collectedDurationBonus[msg.sender] = collectedDurationBonus[msg.sender].add(durationBonus);
390                 emit DurationBonusCollected(msg.sender, i, durationBonus);
391             }
392         }
393 
394         emit MassHarvest(msg.sender, epochId - lastEpochIdHarvested[msg.sender], totalDistributedValue);
395 
396         uint256 totalDurationBonus = 0;
397         if (_staking.isStakeFinished(msg.sender) && collectedDurationBonus[msg.sender] > 0) {
398             totalDurationBonus = collectedDurationBonus[msg.sender];
399             collectedDurationBonus[msg.sender] = 0;
400             _minter.mint(msg.sender, totalDurationBonus);
401             emit DurationBonusDistributed(msg.sender, _getEpochId(), totalDurationBonus);
402         }
403 
404         if (totalDistributedValue > 0) {
405 			_minter.mint(msg.sender, totalDistributedValue);
406             //Referrer reward
407             distributeReferrerReward(totalDistributedValue.add(totalDurationBonus));
408         }
409 
410         return totalDistributedValue.add(totalDurationBonus);
411     }
412 
413     function harvest (uint128 epochId) external whenNotPaused returns (uint){
414         // checks for requested epoch
415         require (_getEpochId() > epochId, "This epoch is in the future");
416         require(epochId <= NR_OF_EPOCHS, "Maximum number of epochs is 60");
417         require (lastEpochIdHarvested[msg.sender].add(1) == epochId, "Harvest in order");
418         uint userReward = _harvest(epochId);
419         
420         uint256 durationBonus = _calcDurationBonus(epochId);
421         collectedDurationBonus[msg.sender] = collectedDurationBonus[msg.sender].add(_calcDurationBonus(epochId));
422         emit DurationBonusCollected(msg.sender, epochId, durationBonus);
423         
424         uint256 totalDurationBonus = 0;
425         if (_staking.isStakeFinished(msg.sender) && collectedDurationBonus[msg.sender] > 0) {
426             totalDurationBonus = collectedDurationBonus[msg.sender];
427             collectedDurationBonus[msg.sender] = 0;
428             _minter.mint(msg.sender, totalDurationBonus);
429             emit DurationBonusDistributed(msg.sender, epochId, totalDurationBonus);
430         }
431         
432         if (userReward > 0) {
433 			_minter.mint(msg.sender, userReward);
434             //Referrer reward
435             distributeReferrerReward(userReward.add(totalDurationBonus));
436         }
437         emit Harvest(msg.sender, epochId, userReward);
438         return userReward.add(totalDurationBonus);
439     }
440     
441     function distributeReferrerReward(uint256 stakerReward) internal {
442         if (_staking.hasReferrer(msg.sender)) {
443             address referrer = _staking.referrals(msg.sender);
444             uint256 ref1Reward = stakerReward.mul(_staking.firstReferrerRewardPercentage()).div(10000);
445             _minter.mint(referrer, ref1Reward);
446             emit ReferrerRewardCollected(msg.sender, referrer, ref1Reward);
447             
448             // second step referrer
449             if (_staking.hasReferrer(referrer)) {
450                 address referrer2 = _staking.referrals(referrer);
451                 uint256 ref2Reward = stakerReward.mul(_staking.secondReferrerRewardPercentage()).div(10000);
452             	_minter.mint(referrer2, ref2Reward);
453                 emit Referrer2RewardCollected(msg.sender, referrer, referrer2, ref2Reward);
454             }
455         }
456     }
457 
458     // views
459     // calls to the staking smart contract to retrieve the epoch total pool size
460     function getPoolSize(uint128 epochId) external view returns (uint) {
461         return _getPoolSize(epochId);
462     }
463 
464     function getCurrentEpoch() external view returns (uint) {
465         return _getEpochId();
466     }
467 
468     // calls to the staking smart contract to retrieve user balance for an epoch
469     function getEpochStake(address userAddress, uint128 epochId) external view returns (uint) {
470         return _getUserBalancePerEpoch(userAddress, epochId);
471     }
472 
473     function userLastEpochIdHarvested() external view returns (uint){
474         return lastEpochIdHarvested[msg.sender];
475     }
476     
477     function getUserLastEpochHarvested(address staker) external view returns (uint) {
478         return lastEpochIdHarvested[staker];
479     }
480     
481     function estimateDurationBonus (uint128 epochId) public view returns (uint) {
482         uint256 poolSize = _getPoolSize(epochId);
483         
484         // exit if there is no stake on the epoch
485         if (poolSize == 0) {
486             return 0;
487         }
488         
489         uint256 stakerMultiplier = stakerDurationMultiplier(msg.sender, epochId + 1);
490 
491         return getDurationBonusPerEpoch(epochId)
492         .mul(_getUserBalancePerEpoch(msg.sender, epochId))
493         .div(poolSize).mul(stakerMultiplier).div(CALC_MULTIPLIER);
494     }
495     
496     function stakerDurationMultiplier(address staker, uint128 epochId) public view returns (uint256) {
497         (uint256 startEpoch, uint256 endEpoch, bool active) = _staking.stakeData(staker);
498 
499         if (epochId > endEpoch || (epochId <= endEpoch && active == false) || epochId < startEpoch) {
500             return 0;
501         }
502         
503         uint256 stakerMultiplier = _staking.calcDurationBonusMultiplier(epochId, staker);
504         
505         return stakerMultiplier;
506     }
507     
508     function reduceDurationBonus(address staker, uint256 reduceMultiplier) public onlyStaking {
509         uint256 collected = collectedDurationBonus[staker];
510         if (collected > 0) {
511             collectedDurationBonus[staker] = collected.mul(reduceMultiplier).div(CALC_MULTIPLIER);
512             uint256 bonusLost = collected.sub(collectedDurationBonus[staker]);
513             DurationBonusLost(staker, _getEpochId(), bonusLost);
514         }
515     }
516     
517     function clearDurationBonus(address staker) public onlyStaking {
518         uint256 collected = collectedDurationBonus[staker];
519         if (collected > 0) {
520             collectedDurationBonus[staker] = 0;
521             DurationBonusLost(staker, _getEpochId(), collected);
522         }
523     }
524 
525     // internal methods
526 
527     function _initEpoch(uint128 epochId) internal {
528         require(lastInitializedEpoch.add(1) == epochId, "Epoch can be init only in order");
529         lastInitializedEpoch = epochId;
530         // call the staking smart contract to init the epoch
531         epochs[epochId] = _getPoolSize(epochId);
532     }
533 
534     function _harvest (uint128 epochId) internal returns (uint) {
535         // try to initialize an epoch. if it can't it fails
536         // if it fails either user either a Swapp account will init not init epochs
537         if (lastInitializedEpoch < epochId) {
538             _initEpoch(epochId);
539         }
540         // Set user state for last harvested
541         lastEpochIdHarvested[msg.sender] = epochId;
542         // compute and return user total reward. For optimization reasons the transfer have been moved to an upper layer (i.e. massHarvest needs to do a single transfer)
543 
544         // exit if there is no stake on the epoch
545         if (epochs[epochId] == 0) {
546             return 0;
547         }
548         
549         uint128 endEpoch = _staking.stakeEndEpoch(msg.sender);
550         if (epochId >= endEpoch) {
551             return 0;
552         }
553         
554         return getTotalAmountPerEpoch(epochId)
555         .mul(_getUserBalancePerEpoch(msg.sender, epochId))
556         .div(epochs[epochId]);
557     }
558     
559 
560     function _calcDurationBonus(uint128 epochId) internal view returns (uint) {
561         // exit if there is no stake on the epoch
562         if (epochs[epochId] == 0) {
563             return 0;
564         }
565         
566         uint256 stakerMultiplier = stakerDurationMultiplier(msg.sender, epochId + 1);
567 
568         return getDurationBonusPerEpoch(epochId)
569         .mul(_getUserBalancePerEpoch(msg.sender, epochId))
570         .div(epochs[epochId]).mul(stakerMultiplier).div(CALC_MULTIPLIER);
571     }
572 
573     function _getPoolSize(uint128 epochId) internal view returns (uint) {
574         // retrieve token balance
575         return _staking.getEpochPoolSize(_swappAddress, epochId);
576     }
577 
578     function _getUserBalancePerEpoch(address userAddress, uint128 epochId) internal view returns (uint){
579         // retrieve token balance per user per epoch
580         return _staking.getEpochUserBalance(userAddress, _swappAddress, epochId);
581     }
582 
583     // compute epoch id from blocktimestamp and epochstart date
584     function _getEpochId() internal view returns (uint128 epochId) {
585         if (block.timestamp < epochStart) {
586             return 0;
587         }
588         epochId = uint128(block.timestamp.sub(epochStart).div(epochDuration).add(1));
589     }
590     
591     function paused() public view returns (bool) {
592         return _paused;
593     }
594     
595     function pause() external onlyOwner {
596         _paused = true;
597     }
598     
599     function unpause() external onlyOwner {
600         _paused = false;
601     }
602     
603     function _initEpochReward() internal {
604         epochAmounts[1] = 5000000;
605         epochAmounts[2] = 2000000;
606         epochAmounts[3] = 2000000;
607         epochAmounts[4] = 2000000;
608         epochAmounts[5] = 2000000;
609         epochAmounts[6] = 2000000;
610         epochAmounts[7] = 1500000;
611         epochAmounts[8] = 1500000;
612         epochAmounts[9] = 1500000;
613         epochAmounts[10] = 1500000;
614         epochAmounts[11] = 1500000;
615         epochAmounts[12] = 1500000;
616         epochAmounts[13] = 500000;
617         epochAmounts[14] = 500000;
618         epochAmounts[15] = 500000;
619         epochAmounts[16] = 500000;
620         epochAmounts[17] = 500000;
621         epochAmounts[18] = 500000;
622         epochAmounts[19] = 500000;
623         epochAmounts[20] = 500000;
624         epochAmounts[21] = 500000;
625         epochAmounts[22] = 500000;
626         epochAmounts[23] = 500000;
627         epochAmounts[24] = 500000;
628         epochAmounts[25] = 400000;
629         epochAmounts[26] = 400000;
630         epochAmounts[27] = 400000;
631         epochAmounts[28] = 400000;
632         epochAmounts[29] = 400000;
633         epochAmounts[30] = 400000;
634         epochAmounts[31] = 400000;
635         epochAmounts[32] = 400000;
636         epochAmounts[33] = 400000;
637         epochAmounts[34] = 400000;
638         epochAmounts[35] = 400000;
639         epochAmounts[36] = 400000;
640         epochAmounts[37] = 250000;
641         epochAmounts[38] = 250000;
642         epochAmounts[39] = 250000;
643         epochAmounts[40] = 250000;
644         epochAmounts[41] = 250000;
645         epochAmounts[42] = 250000;
646         epochAmounts[43] = 250000;
647         epochAmounts[44] = 250000;
648         epochAmounts[45] = 250000;
649         epochAmounts[46] = 250000;
650         epochAmounts[47] = 250000;
651         epochAmounts[48] = 250000;
652         epochAmounts[49] = 250000;
653         epochAmounts[50] = 250000;
654         epochAmounts[51] = 250000;
655         epochAmounts[52] = 250000;
656         epochAmounts[53] = 250000;
657         epochAmounts[54] = 250000;
658         epochAmounts[55] = 250000;
659         epochAmounts[56] = 250000;
660         epochAmounts[57] = 250000;
661         epochAmounts[58] = 250000;
662         epochAmounts[59] = 250000;
663         epochAmounts[60] = 250000;
664     }
665     
666     function _initDurationBonus() internal {
667         epochDurationBonus[1] = 21450;
668         epochDurationBonus[2] = 23595;
669         epochDurationBonus[3] = 25954;
670         epochDurationBonus[4] = 28550;
671         epochDurationBonus[5] = 31405;
672         epochDurationBonus[6] = 34545;
673         epochDurationBonus[7] = 38000;
674         epochDurationBonus[8] = 41800;
675         epochDurationBonus[9] = 45980;
676         epochDurationBonus[10] = 50578;
677         epochDurationBonus[11] = 55635;
678         epochDurationBonus[12] = 61477;
679         epochDurationBonus[13] = 67932;
680         epochDurationBonus[14] = 75065;
681         epochDurationBonus[15] = 82947;
682         epochDurationBonus[16] = 91656;
683         epochDurationBonus[17] = 101280;
684         epochDurationBonus[18] = 111915;
685         epochDurationBonus[19] = 123666;
686         epochDurationBonus[20] = 136651;
687         epochDurationBonus[21] = 150999;
688         epochDurationBonus[22] = 166854;
689         epochDurationBonus[23] = 184374;
690         epochDurationBonus[24] = 204701;
691         epochDurationBonus[25] = 227269;
692         epochDurationBonus[26] = 252326;
693         epochDurationBonus[27] = 280145;
694         epochDurationBonus[28] = 311031;
695         epochDurationBonus[29] = 345322;
696         epochDurationBonus[30] = 383393;
697         epochDurationBonus[31] = 425662;
698         epochDurationBonus[32] = 472592;
699         epochDurationBonus[33] = 524695;
700         epochDurationBonus[34] = 582543;
701         epochDurationBonus[35] = 646768;
702         epochDurationBonus[36] = 721639;
703         epochDurationBonus[37] = 805178;
704         epochDurationBonus[38] = 898388;
705         epochDurationBonus[39] = 1002387;
706         epochDurationBonus[40] = 1118426;
707         epochDurationBonus[41] = 1247898;
708         epochDurationBonus[42] = 1392358;
709         epochDurationBonus[43] = 1553541;
710         epochDurationBonus[44] = 1733382;
711         epochDurationBonus[45] = 1934043;
712         epochDurationBonus[46] = 2157933;
713         epochDurationBonus[47] = 2407740;
714         epochDurationBonus[48] = 2700403;
715         epochDurationBonus[49] = 3028638;
716         epochDurationBonus[50] = 3396771;
717         epochDurationBonus[51] = 3809651;
718         epochDurationBonus[52] = 4272716;
719         epochDurationBonus[53] = 4792068;
720         epochDurationBonus[54] = 5374546;
721         epochDurationBonus[55] = 6027826;
722         epochDurationBonus[56] = 6760512;
723         epochDurationBonus[57] = 7582256;
724         epochDurationBonus[58] = 8503884;
725         epochDurationBonus[59] = 9537537;
726         epochDurationBonus[60] = 11000000;
727     }
728 }