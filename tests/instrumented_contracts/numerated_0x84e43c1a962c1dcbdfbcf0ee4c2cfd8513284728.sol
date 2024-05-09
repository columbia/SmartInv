1 // File: browser/UnipumpErc20Helper.sol
2 
3 pragma solidity ^0.7.0;
4 
5 
6 interface IUnipumpContest
7 {
8 }
9 // File: browser/IUnipumpStaking.sol
10 
11 
12 
13 
14 interface IUnipumpStaking
15 {
16     event Stake(address indexed _staker, uint256 _amount, uint256 _epochCount);
17     event Reward(address indexed _staker, uint256 _reward);
18     event RewardPotIncrease(uint256 _amount);
19 
20     function stakingRewardPot() external view returns (uint256);
21     function currentEpoch() external view returns (uint256);
22     function nextEpochTimestamp() external view returns (uint256);
23     function isActivated() external view returns (bool);
24     function secondsUntilCanActivate() external view returns (uint256);
25     function totalStaked() external view returns (uint256);
26     
27     function increaseRewardsPot() external;
28     function activate() external;
29     function claimRewardsAt(uint256 index) external;
30     function claimRewards() external;
31     function updateEpoch() external returns (bool);
32     function stakeForProfit(uint256 epochCount) external;
33 }
34 // File: browser/IUnipumpDrain.sol
35 
36 
37 
38 
39 interface IUnipumpDrain
40 {
41     function drain(address token) external;
42 }
43 // File: browser/IUnipumpEscrow.sol
44 
45 
46 
47 
48 
49 interface IUnipumpEscrow is IUnipumpDrain
50 {
51     function start() external;
52     function available() external view returns (uint256);
53 }
54 // File: browser/IUnipumpTradingGroup.sol
55 
56 
57 
58 
59 
60 
61 interface IUnipumpTradingGroup
62 {
63     function leader() external view returns (address);
64     function close() external;
65     function closeWithNonzeroTokenBalances() external;
66     function anyNonzeroTokenBalances() external view returns (bool);
67     function tokenList() external view returns (IUnipumpTokenList);
68     function maxSecondsRemaining() external view returns (uint256);
69     function group() external view returns (IUnipumpGroup);
70     function externalBalanceChanges(address token) external view returns (bool);
71 
72     function startTime() external view returns (uint256);
73     function endTime() external view returns (uint256);
74     function maxEndTime() external view returns (uint256);
75 
76     function startingWethBalance() external view returns (uint256);
77     function finalWethBalance() external view returns (uint256);
78     function leaderWethProfitPayout() external view returns (uint256);
79 
80     function swapExactTokensForTokens(
81         uint256 amountIn,
82         uint256 amountOutMin,
83         address[] calldata path,
84         uint256 deadline
85     ) 
86         external 
87         returns (uint256[] memory amounts);
88 
89     function swapTokensForExactTokens(
90         uint256 amountOut,
91         uint256 amountInMax,
92         address[] calldata path,
93         uint256 deadline
94     ) 
95         external 
96         returns (uint256[] memory amounts);
97         
98     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
99         uint256 amountIn,
100         uint256 amountOutMin,
101         address[] calldata path,
102         uint256 deadline
103     ) 
104         external;
105 
106     function withdraw(address token) external;
107 }
108 // File: browser/IUnipumpTokenList.sol
109 
110 
111 
112 
113 interface IUnipumpTokenList
114 {
115     function parentList() external view returns (IUnipumpTokenList);
116     function isLocked() external view returns (bool);
117     function tokens(uint256 index) external view returns (address);
118     function exists(address token) external view returns (bool);
119     function tokenCount() external view returns (uint256);
120 
121     function lock() external;
122     function add(address token) external;
123     function addMany(address[] calldata _tokens) external;
124     function remove(address token) external;    
125 }
126 // File: browser/IUnipumpGroup.sol
127 
128 
129 
130 
131 
132 
133 interface IUnipumpGroup 
134 {
135     function contribute() external payable;
136     function abort() external;
137     function startPumping() external;
138     function isActive() external view returns (bool);
139     function withdraw() external;
140     function leader() external view returns (address);
141     function tokenList() external view returns (IUnipumpTokenList);
142     function leaderUppCollateral() external view returns (uint256);
143     function requiredMemberUppFee() external view returns (uint256);
144     function minEthToJoin() external view returns (uint256);
145     function minEthToStart() external view returns (uint256);
146     function maxEthAcceptable() external view returns (uint256);
147     function maxRunTimeSeconds() external view returns (uint256);
148     function leaderProfitShareOutOf10000() external view returns (uint256);
149     function memberCount() external view returns (uint256);
150     function members(uint256 at) external view returns (address);
151     function contributions(address member) external view returns (uint256);
152     function totalContributions() external view returns (uint256);
153     function aborted() external view returns (bool);
154     function tradingGroup() external view returns (IUnipumpTradingGroup);
155 }
156 // File: browser/IUnipumpGroupFactory.sol
157 
158 
159 
160 
161 
162 
163 interface IUnipumpGroupFactory 
164 {
165     function createGroup(
166         address leader,
167         IUnipumpTokenList unipumpTokenList,
168         uint256 uppCollateral,
169         uint256 requiredMemberUppFee,
170         uint256 minEthToJoin,
171         uint256 minEthToStart,
172         uint256 startTimeout,
173         uint256 maxEthAcceptable,
174         uint256 maxRunTimeSeconds,
175         uint256 leaderProfitShareOutOf10000
176     ) 
177         external
178         returns (IUnipumpGroup unipumpGroup);
179 }
180 // File: browser/IUnipumpGroupManager.sol
181 
182 
183 
184 
185 
186 
187 
188 interface IUnipumpGroupManager
189 {
190     function groupLeaders(uint256 at) external view returns (address);
191     function groupLeaderCount() external view returns (uint256);
192     function groups(uint256 at) external view returns (IUnipumpGroup);
193     function groupCount() external view returns (uint256);
194     function groupCountByLeader(address leader) external view returns (uint256);
195     function groupsByLeader(address leader, uint256 at) external view returns (IUnipumpGroup);
196 
197     function createGroup(
198         IUnipumpTokenList tokenList,
199         uint256 uppCollateral,
200         uint256 requiredMemberUppFee,
201         uint256 minEthToJoin,
202         uint256 minEthToStart,
203         uint256 startTimeout,
204         uint256 maxEthAcceptable,
205         uint256 maxRunTimeSeconds,
206         uint256 leaderProfitShareOutOf10000
207     ) 
208         external
209         returns (IUnipumpGroup group);
210 }
211 // File: browser/openzeppelin/IERC20.sol
212 
213 
214 
215 
216 
217 /**
218  * @dev Interface of the ERC20 standard as defined in the EIP.
219  */
220 interface IERC20 {
221     /**
222      * @dev Returns the amount of tokens in existence.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns the amount of tokens owned by `account`.
228      */
229     function balanceOf(address account) external view returns (uint256);
230 
231     /**
232      * @dev Moves `amount` tokens from the caller's account to `recipient`.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transfer(address recipient, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Returns the remaining number of tokens that `spender` will be
242      * allowed to spend on behalf of `owner` through {transferFrom}. This is
243      * zero by default.
244      *
245      * This value changes when {approve} or {transferFrom} are called.
246      */
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     /**
250      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * IMPORTANT: Beware that changing an allowance with this method brings the risk
255      * that someone may use both the old and the new allowance by unfortunate
256      * transaction ordering. One possible solution to mitigate this race
257      * condition is to first reduce the spender's allowance to 0 and set the
258      * desired value afterwards:
259      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address spender, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Moves `amount` tokens from `sender` to `recipient` using the
267      * allowance mechanism. `amount` is then deducted from the caller's
268      * allowance.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Emitted when `value` tokens are moved from one account (`from`) to
278      * another (`to`).
279      *
280      * Note that `value` may be zero.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     /**
285      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
286      * a call to {approve}. `value` is the new allowance.
287      */
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 // File: browser/IUnipump.sol
292 
293 
294 
295 
296 
297 
298 
299 
300 
301 interface IUnipump is IERC20 {
302     event Sale(bool indexed _saleActive);
303     event LiquidityCrisis();
304 
305     function WETH() external view returns (address);
306     
307     function groupManager() external view returns (IUnipumpGroupManager);
308     function escrow() external view returns (IUnipumpEscrow);
309     function staking() external view returns (IUnipumpStaking);
310     function contest() external view returns (IUnipumpContest);
311 
312     function init(
313         IUnipumpEscrow _escrow,
314         IUnipumpStaking _staking) external;
315     function startUnipumpSale(uint256 _tokensPerEth, uint256 _maxSoldEth) external;
316     function start(
317         IUnipumpGroupManager _groupManager,
318         IUnipumpContest _contest) external;
319 
320     function isSaleActive() external view returns (bool);
321     function tokensPerEth() external view returns (uint256);
322     function maxSoldEth() external view returns (uint256);
323     function soldEth() external view returns (uint256);
324     
325     function buy() external payable;
326     
327     function minSecondsUntilLiquidityCrisis() external view returns (uint256);
328     function createLiquidityCrisis() external payable;
329 }
330 // File: browser/openzeppelin/SafeMath.sol
331 
332 
333 
334 
335 
336 abstract contract UnipumpErc20Helper
337 {
338     function transferMax(address token, address from, address to) 
339         internal
340         returns (uint256 amountTransferred)
341     {
342         uint256 balance = IERC20(token).balanceOf(from);
343         if (balance == 0) { return 0; }
344         uint256 allowed = IERC20(token).allowance(from, to);
345         amountTransferred = allowed > balance ? balance : allowed;
346         if (amountTransferred == 0) { return 0; }
347         require (IERC20(token).transferFrom(from, to, amountTransferred), "Transfer failed");
348     }
349 }
350 // File: browser/UnipumpDrain.sol
351 
352 
353 
354 
355 
356 
357 
358 abstract contract UnipumpDrain is IUnipumpDrain
359 {
360     address payable immutable drainTarget;
361 
362     constructor()
363     {
364         drainTarget = msg.sender;
365     }
366 
367     function drain(address token)
368         public
369         override
370     {
371         uint256 amount;
372         if (token == address(0))
373         {
374             require (address(this).balance > 0, "Nothing to send");
375             amount = _drainAmount(token, address(this).balance);
376             require (amount > 0, "Nothing allowed to send");
377             (bool success,) = drainTarget.call{ value: amount }("");
378             require (success, "Transfer failed");
379             return;
380         }
381         amount = IERC20(token).balanceOf(address(this));
382         require (amount > 0, "Nothing to send");
383         amount = _drainAmount(token, amount);
384         require (amount > 0, "Nothing allowed to send");
385         require (IERC20(token).transfer(drainTarget, amount), "Transfer failed");
386     }
387 
388     function _drainAmount(address token, uint256 available) internal virtual returns (uint256 amount);
389 }
390 // File: browser/IUnipumpContest.sol
391 
392 
393 
394 
395 
396 /**
397  * @dev Wrappers over Solidity's arithmetic operations with added overflow
398  * checks.
399  *
400  * Arithmetic operations in Solidity wrap on overflow. This can easily result
401  * in bugs, because programmers usually assume that an overflow raises an
402  * error, which is the standard behavior in high level programming languages.
403  * `SafeMath` restores this intuition by reverting the transaction when an
404  * operation overflows.
405  *
406  * Using this library instead of the unchecked operations eliminates an entire
407  * class of bugs, so it's recommended to use it always.
408  */
409 library SafeMath {
410     /**
411      * @dev Returns the addition of two unsigned integers, reverting on
412      * overflow.
413      *
414      * Counterpart to Solidity's `+` operator.
415      *
416      * Requirements:
417      *
418      * - Addition cannot overflow.
419      */
420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
421         uint256 c = a + b;
422         require(c >= a, "SafeMath: addition overflow");
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the subtraction of two unsigned integers, reverting on
429      * overflow (when the result is negative).
430      *
431      * Counterpart to Solidity's `-` operator.
432      *
433      * Requirements:
434      *
435      * - Subtraction cannot overflow.
436      */
437     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
438         return sub(a, b, "SafeMath: subtraction overflow");
439     }
440 
441     /**
442      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
443      * overflow (when the result is negative).
444      *
445      * Counterpart to Solidity's `-` operator.
446      *
447      * Requirements:
448      *
449      * - Subtraction cannot overflow.
450      */
451     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
452         require(b <= a, errorMessage);
453         uint256 c = a - b;
454 
455         return c;
456     }
457 
458     /**
459      * @dev Returns the multiplication of two unsigned integers, reverting on
460      * overflow.
461      *
462      * Counterpart to Solidity's `*` operator.
463      *
464      * Requirements:
465      *
466      * - Multiplication cannot overflow.
467      */
468     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
469         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
470         // benefit is lost if 'b' is also tested.
471         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
472         if (a == 0) {
473             return 0;
474         }
475 
476         uint256 c = a * b;
477         require(c / a == b, "SafeMath: multiplication overflow");
478 
479         return c;
480     }
481 
482     /**
483      * @dev Returns the integer division of two unsigned integers. Reverts on
484      * division by zero. The result is rounded towards zero.
485      *
486      * Counterpart to Solidity's `/` operator. Note: this function uses a
487      * `revert` opcode (which leaves remaining gas untouched) while Solidity
488      * uses an invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function div(uint256 a, uint256 b) internal pure returns (uint256) {
495         return div(a, b, "SafeMath: division by zero");
496     }
497 
498     /**
499      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
500      * division by zero. The result is rounded towards zero.
501      *
502      * Counterpart to Solidity's `/` operator. Note: this function uses a
503      * `revert` opcode (which leaves remaining gas untouched) while Solidity
504      * uses an invalid opcode to revert (consuming all remaining gas).
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b > 0, errorMessage);
512         uint256 c = a / b;
513         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
514 
515         return c;
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * Reverts when dividing by zero.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
531         return mod(a, b, "SafeMath: modulo by zero");
532     }
533 
534     /**
535      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
536      * Reverts with custom message when dividing by zero.
537      *
538      * Counterpart to Solidity's `%` operator. This function uses a `revert`
539      * opcode (which leaves remaining gas untouched) while Solidity uses an
540      * invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
547         require(b != 0, errorMessage);
548         return a % b;
549     }
550 }
551 
552 // File: browser/UnipumpStaking.sol
553 
554 
555 
556 
557 
558 
559 
560 
561 
562 contract UnipumpStaking is IUnipumpStaking, UnipumpDrain, UnipumpErc20Helper
563 {    
564     using SafeMath for uint256;
565     
566     struct StakedCoinInfo 
567     {
568         uint256 amount;
569         uint256 fractionalFirstEpochAmount;
570         uint256 stakeUntilEpoch;
571         uint256 stakingEpoch;
572         uint256 epochRewardsClaimed;
573     }
574     struct EpochRewardInfo 
575     {
576         uint256 totalReward;
577         uint256 totalStaked;
578     }
579 
580     IUnipump immutable unipump;
581 
582     mapping (address => StakedCoinInfo[]) stakedTokens;
583     uint256 public override currentEpoch;
584     uint256 public override nextEpochTimestamp;
585     uint256 constant epochSeconds = 60 * 60 * 24; // 1 day = 1 epoch
586     EpochRewardInfo[] epochRewards;
587     uint256 public override totalStaked;
588     uint256 totalStakedFractionalFirstEpoch;
589     uint256 public override stakingRewardPot;
590     uint256 minStakingActivationTime;
591 
592     constructor (
593         IUnipump _unipump,
594         uint256 _seconds
595     ) 
596     {
597         require (address(_unipump) != address(0));
598         unipump = _unipump;
599         minStakingActivationTime = block.timestamp + _seconds;
600     }
601 
602     receive()
603         external
604         payable
605     {
606     }
607 
608     modifier epochUpToDate() { while (!updateEpoch()) { } _; }
609     modifier stakingActivated() { require (nextEpochTimestamp != 0, "Staking is not yet available"); _; }
610 
611     function activate() 
612         public
613         override
614     {
615         require (nextEpochTimestamp == 0, "Staking is already activated");
616         require (minStakingActivationTime > 0 && block.timestamp >= minStakingActivationTime, "Staking is not yet available");
617         nextEpochTimestamp = block.timestamp + epochSeconds;
618     }
619 
620     function increaseRewardsPot() 
621         public
622         override
623     {
624         uint256 amount = transferMax(address(unipump), msg.sender, address(this));
625         stakingRewardPot += amount;
626         emit RewardPotIncrease(amount);
627     }
628 
629     function secondsUntilCanActivate()
630         public
631         view
632         override
633         returns (uint256)
634     {
635         uint256 min = minStakingActivationTime;
636         if (block.timestamp >= min) { return 0; }
637         return min - block.timestamp;
638     }
639 
640     function isActivated()
641         public
642         view
643         override
644         returns (bool)
645     {
646         return nextEpochTimestamp != 0;
647     }
648 
649     function updateEpoch() 
650         public 
651         override
652         stakingActivated()
653         returns (bool upToDate) 
654     {
655         uint256 next = nextEpochTimestamp;
656         if (block.timestamp < next) { return true; }
657         uint256 epoch = currentEpoch++;
658         next += epochSeconds;
659         nextEpochTimestamp = next;
660         uint256 pot = stakingRewardPot;
661         uint256 reward = 
662             epoch < 20 ? pot * 3 / 100 :
663             epoch < 40 ? pot * 2 / 100 :
664             pot / 100;
665         epochRewards.push();
666         epochRewards[epoch].totalReward = reward;
667         epochRewards[epoch].totalStaked = totalStakedFractionalFirstEpoch;
668         stakingRewardPot = pot - reward;
669         totalStakedFractionalFirstEpoch = totalStaked;
670         return block.timestamp < next;
671     }
672    
673     function stakeForProfit(uint256 epochCount) 
674         public
675         override
676         stakingActivated()
677         epochUpToDate()
678     {
679         require (epochCount > 0, "Tokens must be staked until at least the next epoch");
680         require (epochCount <= 3650, "Tokens cannot be staked this long");
681 
682         uint256 amount = transferMax(address(unipump), msg.sender, address(this));
683         require (amount > 0, "No UPP tokens have been authorized for transfer");
684         
685         uint256 len = stakedTokens[msg.sender].length;
686         uint256 epoch = currentEpoch;
687         uint256 fractional = amount.mul(nextEpochTimestamp - block.timestamp) / epochSeconds;
688         stakedTokens[msg.sender].push();
689         stakedTokens[msg.sender][len].amount = amount;
690         stakedTokens[msg.sender][len].fractionalFirstEpochAmount = fractional;
691         stakedTokens[msg.sender][len].stakeUntilEpoch = epoch + epochCount;
692         stakedTokens[msg.sender][len].stakingEpoch = epoch;
693         totalStaked += amount;
694         totalStakedFractionalFirstEpoch += fractional;
695 
696         emit Stake(msg.sender, amount, epochCount);
697     }
698     
699     // This is a backup in case claimRewards runs out of gas
700     function claimRewardsAt(uint256 index) 
701         public
702         override
703         epochUpToDate()
704     {
705         uint256 len = stakedTokens[msg.sender].length;
706         require (index < len, "There are no staked tokens");
707         
708         uint256 claimCount = stakedTokens[msg.sender][index].epochRewardsClaimed;
709         uint256 firstEpoch = stakedTokens[msg.sender][index].stakingEpoch;
710         uint256 epoch = currentEpoch;
711         uint256 claimingEpoch = firstEpoch + claimCount;
712         require (epoch > claimingEpoch, "Rewards are not available until the end of the epoch");
713 
714         uint256 amountStaked = stakedTokens[msg.sender][index].amount;
715         bool expired = epoch >= stakedTokens[msg.sender][index].stakeUntilEpoch;
716         uint256 reward = claimCount == 0 ? stakedTokens[msg.sender][index].fractionalFirstEpochAmount : amountStaked;
717         reward = reward.mul(epochRewards[claimingEpoch].totalReward) / epochRewards[claimingEpoch].totalStaked;
718         if (expired) {
719             reward += amountStaked;
720             if (len - 1 != index) {
721                 stakedTokens[msg.sender][index] = stakedTokens[msg.sender][len - 1];                
722             }
723             stakedTokens[msg.sender].pop();
724             totalStaked -= amountStaked;
725             totalStakedFractionalFirstEpoch -= amountStaked;
726         }
727         else {
728             stakedTokens[msg.sender][index].epochRewardsClaimed = claimCount + 1;
729         }
730 
731         unipump.transfer(msg.sender, reward);
732 
733         emit Reward(msg.sender, reward);
734     }
735 
736     function claimRewards()
737         public
738         override
739         epochUpToDate()
740     {
741         uint256 len = stakedTokens[msg.sender].length;
742         require (len > 0, "There are no staked tokens");
743         uint256 epoch = currentEpoch;
744         uint256 index = len;
745 
746         uint256 removed = 0;
747         uint256 totalReward = 0;
748 
749         while (index-- > 0)
750         {
751             uint256 claimCount = stakedTokens[msg.sender][index].epochRewardsClaimed;
752             uint256 firstEpoch = stakedTokens[msg.sender][index].stakingEpoch;
753             uint256 claimingEpoch = firstEpoch + claimCount;
754             if (claimingEpoch >= epoch) { continue; }
755             
756             uint256 amountStaked = stakedTokens[msg.sender][index].amount;
757             bool expired = epoch >= stakedTokens[msg.sender][index].stakeUntilEpoch;
758             
759             for (; claimingEpoch < epoch; ++claimingEpoch) {
760                 uint256 reward = claimCount++ == 0 ? stakedTokens[msg.sender][index].fractionalFirstEpochAmount : amountStaked;
761                 reward = reward.mul(epochRewards[claimingEpoch].totalReward) / epochRewards[claimingEpoch].totalStaked;
762                 if (expired) {
763                     reward += amountStaked;
764                     if (len - 1 != index) {
765                         stakedTokens[msg.sender][index] = stakedTokens[msg.sender][len - 1];                
766                     }
767                     stakedTokens[msg.sender].pop();
768                     removed += amountStaked;
769                     removed += amountStaked;
770                 }
771                 totalReward += reward;
772             }
773             if (!expired) { stakedTokens[msg.sender][index].epochRewardsClaimed = claimCount; }
774         }
775         totalStaked -= removed;
776         totalStakedFractionalFirstEpoch -= removed;
777 
778         unipump.transfer(msg.sender, totalReward);
779         emit Reward(msg.sender, totalReward);
780     }
781 
782     function _drainAmount(address token, uint256 available) 
783         internal 
784         override 
785         view
786         returns (uint256 amount) 
787     { 
788         // Unipump is for staking.  Anything else can be drained.
789         amount = token == address(unipump) ? 0 : available; 
790     }
791 }