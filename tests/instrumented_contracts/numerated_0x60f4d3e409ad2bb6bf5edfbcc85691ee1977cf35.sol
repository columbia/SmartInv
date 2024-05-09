1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
86 
87 pragma solidity ^0.8.0;
88 
89 // CAUTION
90 // This version of SafeMath should only be used with Solidity 0.8 or later,
91 // because it relies on the compiler's built in overflow checks.
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations.
95  *
96  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
97  * now has built in overflow checking.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         unchecked {
107             uint256 c = a + b;
108             if (c < a) return (false, 0);
109             return (true, c);
110         }
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         unchecked {
120             if (b > a) return (false, 0);
121             return (true, a - b);
122         }
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         unchecked {
132             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133             // benefit is lost if 'b' is also tested.
134             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135             if (a == 0) return (true, 0);
136             uint256 c = a * b;
137             if (c / a != b) return (false, 0);
138             return (true, c);
139         }
140     }
141 
142     /**
143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
144      *
145      * _Available since v3.4._
146      */
147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         unchecked {
149             if (b == 0) return (false, 0);
150             return (true, a / b);
151         }
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         unchecked {
161             if (b == 0) return (false, 0);
162             return (true, a % b);
163         }
164     }
165 
166     /**
167      * @dev Returns the addition of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `+` operator.
171      *
172      * Requirements:
173      *
174      * - Addition cannot overflow.
175      */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a + b;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a - b;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      *
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a * b;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator.
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a / b;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * reverting when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a % b;
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * CAUTION: This function is deprecated because it requires allocating memory for the error
243      * message unnecessarily. For custom revert reasons use {trySub}.
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         unchecked {
257             require(b <= a, errorMessage);
258             return a - b;
259         }
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b > 0, errorMessage);
281             return a / b;
282         }
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * reverting with custom message when dividing by zero.
288      *
289      * CAUTION: This function is deprecated because it requires allocating memory for the error
290      * message unnecessarily. For custom revert reasons use {tryMod}.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(
301         uint256 a,
302         uint256 b,
303         string memory errorMessage
304     ) internal pure returns (uint256) {
305         unchecked {
306             require(b > 0, errorMessage);
307             return a % b;
308         }
309     }
310 }
311 
312 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Contract module that helps prevent reentrant calls to a function.
318  *
319  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
320  * available, which can be applied to functions to make sure there are no nested
321  * (reentrant) calls to them.
322  *
323  * Note that because there is a single `nonReentrant` guard, functions marked as
324  * `nonReentrant` may not call one another. This can be worked around by making
325  * those functions `private`, and then adding `external` `nonReentrant` entry
326  * points to them.
327  *
328  * TIP: If you would like to learn more about reentrancy and alternative ways
329  * to protect against it, check out our blog post
330  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
331  */
332 abstract contract ReentrancyGuard {
333     // Booleans are more expensive than uint256 or any type that takes up a full
334     // word because each write operation emits an extra SLOAD to first read the
335     // slot's contents, replace the bits taken up by the boolean, and then write
336     // back. This is the compiler's defense against contract upgrades and
337     // pointer aliasing, and it cannot be disabled.
338 
339     // The values being non-zero value makes deployment a bit more expensive,
340     // but in exchange the refund on every call to nonReentrant will be lower in
341     // amount. Since refunds are capped to a percentage of the total
342     // transaction's gas, it is best to keep them low in cases like this one, to
343     // increase the likelihood of the full refund coming into effect.
344     uint256 private constant _NOT_ENTERED = 1;
345     uint256 private constant _ENTERED = 2;
346 
347     uint256 private _status;
348 
349     constructor() {
350         _status = _NOT_ENTERED;
351     }
352 
353     /**
354      * @dev Prevents a contract from calling itself, directly or indirectly.
355      * Calling a `nonReentrant` function from another `nonReentrant`
356      * function is not supported. It is possible to prevent this from happening
357      * by making the `nonReentrant` function external, and make it call a
358      * `private` function that does the actual work.
359      */
360     modifier nonReentrant() {
361         // On the first call to nonReentrant, _notEntered will be true
362         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
363 
364         // Any calls to nonReentrant after this point will fail
365         _status = _ENTERED;
366 
367         _;
368 
369         // By storing the original value once again, a refund is triggered (see
370         // https://eips.ethereum.org/EIPS/eip-2200)
371         _status = _NOT_ENTERED;
372     }
373 }
374 
375 pragma solidity 0.8.0;
376 
377 interface TokenInterface is IERC20 {
378     function mintSupply(address _investorAddress, uint256 _amount) external;
379 	function burn(uint256 amount) external;
380 }
381 
382 interface Minter {
383     function mint(address to, uint256 amount) external;
384 }
385 
386 interface SwappYieldFarm {
387     function clearDurationBonus(address staker) external;
388     function reduceDurationBonus(address staker, uint256 reduceMultiplier) external;
389     function getUserLastEpochHarvested(address staker) external returns (uint);
390 }
391 
392 interface Staking {
393     function referrals(address staker) external returns (address);
394 }
395 
396 contract SwappStaking is ReentrancyGuard {
397     using SafeMath for uint256;
398     using SafeMath for uint128;
399 
400     uint128 constant private BASE_MULTIPLIER = uint128(1 * 10 ** 18);
401     uint256 constant private CALC_MULTIPLIER = 1000000;
402 
403     // timestamp for the epoch 1
404     // everything before that is considered epoch 0 which won't have a reward but allows for the initial stake
405     uint256 public epoch1Start;
406 
407     // duration of each epoch
408     uint256 public epochDuration;
409 
410     // holds the current balance of the user for each token
411     mapping(address => mapping(address => uint256)) private balances;
412     
413     address constant private swapp = 0x8CB924583681cbFE487A62140a994A49F833c244;
414 	address constant private minter = 0xBC1f9993ea5eE2C77909bf43d7a960bB8dA8C9B9;
415     address constant private staking = 0x245a551ee0F55005e510B239c917fA34b41B3461;
416 	address public farm;
417     
418     struct Pool {
419         uint256 size;
420         bool set;
421     }
422 
423     // for each token, we store the total pool size
424     mapping(address => mapping(uint256 => Pool)) private poolSize;
425 
426     // a checkpoint of the valid balance of a user for an epoch
427     struct Checkpoint {
428         uint128 epochId;
429         uint128 multiplier;
430         uint256 startBalance;
431         uint256 newDeposits;
432     }
433 
434     // balanceCheckpoints[user][token][]
435     mapping(address => mapping(address => Checkpoint[])) private balanceCheckpoints;
436 
437     mapping(address => uint128) private lastWithdrawEpochId;
438 
439 
440     //referrals
441     uint256 public firstReferrerRewardPercentage;
442     uint256 public secondReferrerRewardPercentage;
443 
444     struct Referrer {
445         // uint256 totalReward;
446         uint256 referralsCount;
447         mapping(uint256 => address) referrals;
448     }
449 
450     // staker to referrer
451     mapping(address => address) public referrals;
452     // referrer data
453     mapping(address => Referrer) public referrers;
454 
455 	uint256 constant public NR_OF_EPOCHS = 60;
456 	
457 	struct Topup {
458 	    uint256 totalTopups;
459         mapping(uint256 => uint128) epochs;
460         mapping(uint256 => uint256) amounts;
461     }
462 	
463 	struct Stake {
464 		uint128 startEpoch;
465 		uint256 startTimestamp;
466 		uint128 endEpoch;
467 		uint128 duration;
468 		bool active;
469 	}
470 	
471 	mapping(address => Stake) public stakes;
472     mapping(address => Topup) public topups;
473 	uint256 public stakedSwapp;
474 	
475 	modifier onlyOwner() {
476         require(msg.sender == _owner, "Only owner can perfrom this action");
477         _;
478     }
479     
480     modifier whenNotPaused() {
481         require(!paused(), "Staking: contract is paused");
482         _;
483     }
484 
485     event Deposit(address indexed user, address indexed tokenAddress, uint256 amount, uint256 endEpoch);
486     event Withdraw(address indexed user, address indexed tokenAddress, uint256 amount, uint256 penalty);
487     event ManualEpochInit(address indexed caller, uint128 indexed epochId, address[] tokens);
488     event EmergencyWithdraw(address indexed user, address indexed tokenAddress, uint256 amount);
489     event RegisteredReferer(address indexed referral, address indexed referrer, uint256 amount);
490     event Penalty(address indexed staker, uint128 indexed epochId, uint256 amount);
491     event PrepareMigration(address indexed staker, uint256 balance);
492 
493     address public _owner;
494     address private _migration;
495     bool private _paused = false;
496     bool emergencyWithdrawAllowed = false;
497 
498     constructor () {
499         epoch1Start = 1626652800;
500         epochDuration = 2419200; // 28 days
501 
502         _owner = msg.sender;
503 
504         firstReferrerRewardPercentage = 1000;
505         secondReferrerRewardPercentage = 500;
506     }
507 
508     /*
509      * Stores `amount` of `tokenAddress` tokens for the `user` into the vault
510      */
511     function deposit(address tokenAddress, uint256 amount, address referrer, uint128 endEpoch) public nonReentrant whenNotPaused {
512         require(amount > 0, "Staking: Amount must be > 0");
513 		require(tokenAddress == swapp, "This pool accepts only Swapp token");
514         require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= amount, "Staking: Token allowance too small");
515 		
516 		uint128 currentEpoch = getCurrentEpoch();
517         require(endEpoch > currentEpoch && endEpoch <= NR_OF_EPOCHS.add(1), "Staking: not acceptable end of stake");
518         
519         IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
520         TokenInterface(tokenAddress).burn(amount);
521         stakedSwapp = stakedSwapp.add(amount);
522 
523         if (referrer != address(0)) {
524             processReferrals(referrer, amount);
525         }
526 
527         balances[msg.sender][tokenAddress] = balances[msg.sender][tokenAddress].add(amount);
528         
529         handleStakeDuration(endEpoch, amount);
530 
531         // epoch logic
532         uint128 currentMultiplier = currentEpochMultiplier();
533 
534         if (!epochIsInitialized(tokenAddress, currentEpoch)) {
535             address[] memory tokens = new address[](1);
536             tokens[0] = tokenAddress;
537             manualEpochInit(tokens, currentEpoch);
538         }
539 
540         // update the next epoch pool size
541         Pool storage pNextEpoch = poolSize[tokenAddress][currentEpoch + 1];
542         
543         pNextEpoch.size = stakedSwapp;
544         pNextEpoch.set = true;
545 
546         Checkpoint[] storage checkpoints = balanceCheckpoints[msg.sender][tokenAddress];
547 
548         uint256 balanceBefore = getEpochUserBalance(msg.sender, tokenAddress, currentEpoch);
549 
550         // if there's no checkpoint yet, it means the user didn't have any activity
551         // we want to store checkpoints both for the current epoch and next epoch because
552         // if a user does a withdraw, the current epoch can also be modified and
553         // we don't want to insert another checkpoint in the middle of the array as that could be expensive
554         if (checkpoints.length == 0) {
555             checkpoints.push(Checkpoint(currentEpoch, currentMultiplier, 0, amount));
556 
557             // next epoch => multiplier is 1, epoch deposits is 0
558             checkpoints.push(Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, amount, 0));
559         } else {
560             uint256 last = checkpoints.length - 1;
561 
562             // the last action happened in an older epoch (e.g. a deposit in epoch 3, current epoch is >=5)
563             if (checkpoints[last].epochId < currentEpoch) {
564                 uint128 multiplier = computeNewMultiplier(
565                     getCheckpointBalance(checkpoints[last]),
566                     BASE_MULTIPLIER,
567                     amount,
568                     currentMultiplier
569                 );
570                 checkpoints.push(Checkpoint(currentEpoch, multiplier, getCheckpointBalance(checkpoints[last]), amount));
571                 checkpoints.push(Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, balances[msg.sender][tokenAddress], 0));
572             }
573             // the last action happened in the previous epoch
574             else if (checkpoints[last].epochId == currentEpoch) {
575                 checkpoints[last].multiplier = computeNewMultiplier(
576                     getCheckpointBalance(checkpoints[last]),
577                     checkpoints[last].multiplier,
578                     amount,
579                     currentMultiplier
580                 );
581                 checkpoints[last].newDeposits = checkpoints[last].newDeposits.add(amount);
582 
583                 checkpoints.push(Checkpoint(currentEpoch + 1, BASE_MULTIPLIER, balances[msg.sender][tokenAddress], 0));
584             }
585             // the last action happened in the current epoch
586             else {
587                 if (last >= 1 && checkpoints[last - 1].epochId == currentEpoch) {
588                     checkpoints[last - 1].multiplier = computeNewMultiplier(
589                         getCheckpointBalance(checkpoints[last - 1]),
590                         checkpoints[last - 1].multiplier,
591                         amount,
592                         currentMultiplier
593                     );
594                     checkpoints[last - 1].newDeposits = checkpoints[last - 1].newDeposits.add(amount);
595                 }
596 
597                 checkpoints[last].startBalance = balances[msg.sender][tokenAddress];
598             }
599         }
600 
601         uint256 balanceAfter = getEpochUserBalance(msg.sender, tokenAddress, currentEpoch);
602 
603         poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][currentEpoch].size.add(balanceAfter.sub(balanceBefore));
604 
605         emit Deposit(msg.sender, tokenAddress, amount, endEpoch);
606     }
607     
608     function handleStakeDuration(uint128 endEpoch, uint256 amount) internal {
609         Stake storage stake = stakes[msg.sender];
610         uint128 currentEpoch = getCurrentEpoch();
611         
612 		if (!stake.active) {
613 			stake.startEpoch = currentEpoch;
614 			stake.startTimestamp = block.timestamp;
615 			stake.endEpoch = endEpoch;
616 			stake.duration = endEpoch - currentEpoch;
617 			stake.active = true;
618 		}
619 
620         Topup storage topupData = topups[msg.sender];
621 
622         uint256 currentTopup = topupData.totalTopups + 1;
623         topupData.totalTopups = currentTopup;
624         topupData.epochs[currentTopup] = currentEpoch;
625         topupData.amounts[currentTopup] = amount;
626     }
627     
628     function getTopupById(address staker, uint256 id) public view returns (uint128 epochId, uint256 amount) {
629         return (topups[staker].epochs[id], topups[staker].amounts[id]);
630     }
631     
632     function calcDurationBonusMultiplier(uint128 epochId, address staker) external view returns (uint256) {
633         Topup storage topupData = topups[staker];
634         // only if there were topups
635         if (topupData.totalTopups > 0) {
636             uint256 dividend = 0;
637             uint256 divider = 0;
638             for (uint256 i = 1; i <= topupData.totalTopups; i++) {
639                 // Topup storage topup = topups[staker];
640                 uint128 startEpoch = topupData.epochs[i];
641                 uint256 amount = topupData.amounts[i];
642                 // correct multiplier only for epoch from topup starts
643                 if (epochId < startEpoch) {
644                     continue;
645                 }
646                 // correct multiplier only for epoch from current stake starts
647                 if (epochId < stakes[msg.sender].startEpoch) {
648                     continue;
649                 }
650                 
651                 dividend += epochId.sub(startEpoch).mul(CALC_MULTIPLIER).div(epochId) * amount;
652                 divider += amount;
653             }
654 
655             if (divider > 0) {
656                 return dividend.div(divider);
657             }
658         }
659         return 0;
660     }
661     
662     function stakeData(address staker) external view returns (uint256 startEpoch, uint256 endEpoch, bool active) {
663         Stake memory stake = stakes[staker];
664         return (stake.startEpoch, stake.endEpoch, stake.active);
665     }
666     
667     function setFarm(address _farm) external onlyOwner {
668         farm = _farm;
669     }
670 
671     // must be in bases point ( 1,5% = 150 bp)
672     function updateReferrersPercentage(uint256 first, uint256 second) external onlyOwner {
673         firstReferrerRewardPercentage = first;
674         secondReferrerRewardPercentage = second;
675     }
676     
677     function allowEmergencyWithdraw() external onlyOwner{
678         emergencyWithdrawAllowed = true;
679     }
680     
681     function disallowEmergencyWithdraw() external onlyOwner{
682         emergencyWithdrawAllowed = false;
683     }
684 
685     function processReferrals(address referrer, uint256 amount) internal {
686         //get referrer from first staking pool
687         address firstReferrer = Staking(staking).referrals(msg.sender);
688         if(firstReferrer != address(0)) {
689             referrer = firstReferrer;
690         }
691         
692         //Return if sender has referrer alredy or referrer is contract or self ref
693         if (hasReferrer(msg.sender) || !notContract(referrer) || referrer == msg.sender) {
694             return;
695         }
696 
697         //check cross refs 
698         if (referrals[referrer] == msg.sender || referrals[referrals[referrer]] == msg.sender) {
699             return;
700         }
701         
702         //check if already has stake, do not add referrer if has
703         if (balanceOf(msg.sender, swapp) > 0) {
704             return;
705         }
706 
707         referrals[msg.sender] = referrer;
708 
709         Referrer storage refData = referrers[referrer];
710 
711         refData.referralsCount = refData.referralsCount.add(1);
712         refData.referrals[refData.referralsCount] = msg.sender;
713         emit RegisteredReferer(msg.sender, referrer, amount);
714     }
715 
716     function hasReferrer(address addr) public view returns(bool) {
717         return referrals[addr] != address(0);
718     }
719 
720     function getReferralById(address referrer, uint256 id) public view returns (address) {
721         return referrers[referrer].referrals[id];
722     }
723     
724     /*
725      * Removes the deposit of the user and sends the amount of `tokenAddress` back to the `user`
726      */
727     function withdraw(address tokenAddress, uint256 amount) public nonReentrant whenNotPaused {
728         require(balances[msg.sender][tokenAddress] >= amount, "Staking: balance too small");
729         uint128 currentEpoch = getCurrentEpoch();
730         Stake storage stake = stakes[msg.sender];
731         require(currentEpoch > stake.startEpoch, "Staking: withdraw is not allowed on stake start epoch");
732         
733         if (currentEpoch < stake.endEpoch) {
734             uint256 userLastEpochHarvested = SwappYieldFarm(farm).getUserLastEpochHarvested(msg.sender);
735             require(userLastEpochHarvested == currentEpoch.sub(1), "Staking: withdraw allowed only after all epoch before current epoch are harvested");
736         }
737         
738         balances[msg.sender][tokenAddress] = balances[msg.sender][tokenAddress].sub(amount);
739         
740         if (balances[msg.sender][tokenAddress] == 0) {
741     		if (stake.active) {
742     			stake.active = false;
743     		}
744     		
745     		if (currentEpoch < stake.endEpoch) {
746     		    SwappYieldFarm(farm).clearDurationBonus(msg.sender);
747     		}
748         } else {
749             if (currentEpoch < stake.endEpoch) {
750                 uint256 balanceBefore = balances[msg.sender][tokenAddress].add(amount);
751                 uint256 reduceMultiplier = balances[msg.sender][tokenAddress].mul(CALC_MULTIPLIER).div(balanceBefore);
752     		    SwappYieldFarm(farm).reduceDurationBonus(msg.sender, reduceMultiplier);
753     		}
754         }
755         
756         uint256 penalty = calcPenalty(amount);
757         uint256 amountToMint = amount.sub(penalty);
758         stakedSwapp = stakedSwapp.sub(amount);
759         
760         if (penalty > 0) {
761             emit Penalty(msg.sender, currentEpoch, penalty);
762         }
763         
764         if (amountToMint > 0) {
765 		    Minter(minter).mint(msg.sender, amountToMint);
766         }
767         
768         // epoch logic
769         
770         lastWithdrawEpochId[tokenAddress] = currentEpoch;
771 
772         if (!epochIsInitialized(tokenAddress, currentEpoch)) {
773             address[] memory tokens = new address[](1);
774             tokens[0] = tokenAddress;
775             manualEpochInit(tokens, currentEpoch);
776         }
777 
778         // update the pool size of the next epoch to its current balance
779         Pool storage pNextEpoch = poolSize[tokenAddress][currentEpoch + 1];
780         
781         pNextEpoch.size = stakedSwapp;
782         pNextEpoch.set = true;
783 
784         Checkpoint[] storage checkpoints = balanceCheckpoints[msg.sender][tokenAddress];
785         uint256 last = checkpoints.length - 1;
786 
787         // note: it's impossible to have a withdraw and no checkpoints because the balance would be 0 and revert
788 
789         // there was a deposit in an older epoch (more than 1 behind [eg: previous 0, now 5]) but no other action since then
790         if (checkpoints[last].epochId < currentEpoch) {
791             checkpoints.push(Checkpoint(currentEpoch, BASE_MULTIPLIER, balances[msg.sender][tokenAddress], 0));
792 
793             poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][currentEpoch].size.sub(amount);
794         }
795         // there was a deposit in the `epochId - 1` epoch => we have a checkpoint for the current epoch
796         else if (checkpoints[last].epochId == currentEpoch) {
797             checkpoints[last].startBalance = balances[msg.sender][tokenAddress];
798             checkpoints[last].newDeposits = 0;
799             checkpoints[last].multiplier = BASE_MULTIPLIER;
800 
801             poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][currentEpoch].size.sub(amount);
802         }
803         // there was a deposit in the current epoch
804         else {
805             Checkpoint storage currentEpochCheckpoint = checkpoints[last - 1];
806 
807             uint256 balanceBefore = getCheckpointEffectiveBalance(currentEpochCheckpoint);
808 
809             // in case of withdraw, we have 2 branches:
810             // 1. the user withdraws less than he added in the current epoch
811             // 2. the user withdraws more than he added in the current epoch (including 0)
812             if (amount < currentEpochCheckpoint.newDeposits) {
813                 uint128 avgDepositMultiplier = uint128(
814                     balanceBefore.sub(currentEpochCheckpoint.startBalance).mul(BASE_MULTIPLIER).div(currentEpochCheckpoint.newDeposits)
815                 );
816 
817                 currentEpochCheckpoint.newDeposits = currentEpochCheckpoint.newDeposits.sub(amount);
818 
819                 currentEpochCheckpoint.multiplier = computeNewMultiplier(
820                     currentEpochCheckpoint.startBalance,
821                     BASE_MULTIPLIER,
822                     currentEpochCheckpoint.newDeposits,
823                     avgDepositMultiplier
824                 );
825             } else {
826                 currentEpochCheckpoint.startBalance = currentEpochCheckpoint.startBalance.sub(
827                     amount.sub(currentEpochCheckpoint.newDeposits)
828                 );
829                 currentEpochCheckpoint.newDeposits = 0;
830                 currentEpochCheckpoint.multiplier = BASE_MULTIPLIER;
831             }
832 
833             uint256 balanceAfter = getCheckpointEffectiveBalance(currentEpochCheckpoint);
834 
835             poolSize[tokenAddress][currentEpoch].size = poolSize[tokenAddress][currentEpoch].size.sub(balanceBefore.sub(balanceAfter));
836 
837             checkpoints[last].startBalance = balances[msg.sender][tokenAddress];
838         }
839 
840         emit Withdraw(msg.sender, tokenAddress, amount, penalty);
841     }
842     
843     function calcPenalty(uint256 amount) public view returns (uint256) {
844         Stake memory stake = stakes[msg.sender];
845         uint256 currentEpoch = getCurrentEpoch();
846         if (currentEpoch >= stake.endEpoch) {
847             return 0;
848         } else {
849             uint256 staked = currentEpoch - stake.startEpoch;
850             uint256 promised = stake.duration;
851             uint256 k = 10000 - staked * 10000 / promised; 
852             return amount * k / 10000;
853         }
854     }
855     
856     function isStakeFinished(address staker) public view returns (bool) {
857         Stake memory stake = stakes[staker];
858         uint256 currentEpoch = getCurrentEpoch();
859         
860         return currentEpoch >= stake.endEpoch;
861     }
862     
863     function stakeEndEpoch(address staker) external view returns (uint128) {
864         return stakes[staker].endEpoch;
865     }
866 
867     /*
868      * manualEpochInit can be used by anyone to initialize an epoch based on the previous one
869      * This is only applicable if there was no action (deposit/withdraw) in the current epoch.
870      * Any deposit and withdraw will automatically initialize the current and next epoch.
871      */
872     function manualEpochInit(address[] memory tokens, uint128 epochId) public {
873         require(epochId <= getCurrentEpoch(), "can't init a future epoch");
874 
875         for (uint i = 0; i < tokens.length; i++) {
876             Pool storage p = poolSize[tokens[i]][epochId];
877 
878             if (epochId == 0) {
879                 p.size = uint256(0);
880                 p.set = true;
881             } else {
882                 require(!epochIsInitialized(tokens[i], epochId), "Staking: epoch already initialized");
883                 require(epochIsInitialized(tokens[i], epochId - 1), "Staking: previous epoch not initialized");
884 
885                 p.size = poolSize[tokens[i]][epochId - 1].size;
886                 p.set = true;
887             }
888         }
889 
890         emit ManualEpochInit(msg.sender, epochId, tokens);
891     }
892 
893     function emergencyWithdraw(address tokenAddress) public {
894         require(emergencyWithdrawAllowed == true, "Emergency withdrawal not allowed");
895         require((getCurrentEpoch() - lastWithdrawEpochId[tokenAddress]) >= 10, "At least 10 epochs must pass without success");
896 
897         uint256 totalUserBalance = balances[msg.sender][tokenAddress];
898         require(totalUserBalance > 0, "Amount must be > 0");
899 
900         balances[msg.sender][tokenAddress] = 0;
901         stakedSwapp = stakedSwapp - totalUserBalance;
902         
903 		Minter(minter).mint(msg.sender, totalUserBalance);
904 
905         emit EmergencyWithdraw(msg.sender, tokenAddress, totalUserBalance);
906     }
907 
908     /*
909      * Returns the valid balance of a user that was taken into consideration in the total pool size for the epoch
910      * A deposit will only change the next epoch balance.
911      * A withdraw will decrease the current epoch (and subsequent) balance.
912      */
913     function getEpochUserBalance(address user, address token, uint128 epochId) public view returns (uint256) {
914         Checkpoint[] storage checkpoints = balanceCheckpoints[user][token];
915 
916         // if there are no checkpoints, it means the user never deposited any tokens, so the balance is 0
917         if (checkpoints.length == 0 || epochId < checkpoints[0].epochId) {
918             return 0;
919         }
920 
921         uint min = 0;
922         uint max = checkpoints.length - 1;
923 
924         // shortcut for blocks newer than the latest checkpoint == current balance
925         if (epochId >= checkpoints[max].epochId) {
926             return getCheckpointEffectiveBalance(checkpoints[max]);
927         }
928 
929         // binary search of the value in the array
930         while (max > min) {
931             uint mid = (max + min + 1) / 2;
932             if (checkpoints[mid].epochId <= epochId) {
933                 min = mid;
934             } else {
935                 max = mid - 1;
936             }
937         }
938 
939         return getCheckpointEffectiveBalance(checkpoints[min]);
940     }
941 
942     /*
943      * Returns the amount of `token` that the `user` has currently staked
944      */
945     function balanceOf(address user, address token) public view returns (uint256) {
946         return balances[user][token];
947     }
948 
949     /*
950      * Returns the id of the current epoch derived from block.timestamp
951      */
952     function getCurrentEpoch() public view returns (uint128) {
953         if (block.timestamp < epoch1Start) {
954             return 0;
955         }
956 
957         return uint128((block.timestamp - epoch1Start) / epochDuration + 1);
958     }
959 
960     /*
961      * Returns the total amount of `tokenAddress` that was locked from beginning to end of epoch identified by `epochId`
962      */
963     function getEpochPoolSize(address tokenAddress, uint128 epochId) public view returns (uint256) {
964         // Premises:
965         // 1. it's impossible to have gaps of uninitialized epochs
966         // - any deposit or withdraw initialize the current epoch which requires the previous one to be initialized
967         if (epochIsInitialized(tokenAddress, epochId)) {
968             return poolSize[tokenAddress][epochId].size;
969         }
970 
971         // epochId not initialized and epoch 0 not initialized => there was never any action on this pool
972         if (!epochIsInitialized(tokenAddress, 0)) {
973             return 0;
974         }
975 
976         // epoch 0 is initialized => there was an action at some point but none that initialized the epochId
977         // which means the current pool size is equal to the current balance of token held by the staking contract
978         return stakedSwapp;
979     }
980 
981     /*
982      * Returns the percentage of time left in the current epoch
983      */
984     function currentEpochMultiplier() public view returns (uint128) {
985         uint128 currentEpoch = getCurrentEpoch();
986         uint256 currentEpochEnd = epoch1Start + currentEpoch * epochDuration;
987         uint256 timeLeft = currentEpochEnd - block.timestamp;
988         uint128 multiplier = uint128(timeLeft * BASE_MULTIPLIER / epochDuration);
989 
990         return multiplier;
991     }
992 
993     function computeNewMultiplier(uint256 prevBalance, uint128 prevMultiplier, uint256 amount, uint128 currentMultiplier) public pure returns (uint128) {
994         uint256 prevAmount = prevBalance.mul(prevMultiplier).div(BASE_MULTIPLIER);
995         uint256 addAmount = amount.mul(currentMultiplier).div(BASE_MULTIPLIER);
996         uint128 newMultiplier = uint128(prevAmount.add(addAmount).mul(BASE_MULTIPLIER).div(prevBalance.add(amount)));
997 
998         return newMultiplier;
999     }
1000 
1001     /*
1002      * Checks if an epoch is initialized, meaning we have a pool size set for it
1003      */
1004     function epochIsInitialized(address token, uint128 epochId) public view returns (bool) {
1005         return poolSize[token][epochId].set;
1006     }
1007 
1008     function getCheckpointBalance(Checkpoint memory c) internal pure returns (uint256) {
1009         return c.startBalance.add(c.newDeposits);
1010     }
1011 
1012     function getCheckpointEffectiveBalance(Checkpoint memory c) internal pure returns (uint256) {
1013         return getCheckpointBalance(c).mul(c.multiplier).div(BASE_MULTIPLIER);
1014     }
1015 
1016     function notContract(address _addr) internal view returns (bool) {
1017         uint32 size;
1018         assembly { size := extcodesize(_addr) }
1019         return (size == 0);
1020     }
1021     
1022     function paused() public view returns (bool) {
1023         return _paused;
1024     }
1025     
1026     function pause() external onlyOwner {
1027         _paused = true;
1028     }
1029     
1030     function unpause() external onlyOwner {
1031         _paused = false;
1032     }
1033     
1034     function setMigration(address migration) external onlyOwner{
1035         _migration = migration;
1036     }
1037     
1038     function prepareMigration(address staker) public returns (uint256 balance) {
1039         require(_migration != address(0), "Migration is not initialised");
1040         require(msg.sender == _migration, "Only migration contract can perform this action");
1041         require(balances[staker][swapp] > 0, "Balance too small");
1042         
1043         uint256 _balance = balances[staker][swapp];
1044         balances[staker][swapp] = 0;
1045         stakedSwapp = stakedSwapp.sub(_balance);
1046         
1047         Stake storage stake = stakes[staker];
1048         stake.active = false;
1049         stake.endEpoch = getCurrentEpoch();
1050         
1051         emit PrepareMigration(staker, _balance);
1052         
1053         return _balance;
1054     }
1055 }