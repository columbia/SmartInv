1 // File: contracts/sol6/IERC20.sol
2 
3 pragma solidity 0.6.6;
4 
5 
6 interface IERC20 {
7     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8 
9     function approve(address _spender, uint256 _value) external returns (bool success);
10 
11     function transfer(address _to, uint256 _value) external returns (bool success);
12 
13     function transferFrom(
14         address _from,
15         address _to,
16         uint256 _value
17     ) external returns (bool success);
18 
19     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
20 
21     function balanceOf(address _owner) external view returns (uint256 balance);
22 
23     function decimals() external view returns (uint8 digits);
24 
25     function totalSupply() external view returns (uint256 supply);
26 }
27 
28 
29 // to support backward compatible contract name -- so function signature remains same
30 abstract contract ERC20 is IERC20 {
31 
32 }
33 
34 // File: contracts/sol6/utils/zeppelin/ReentrancyGuard.sol
35 
36 pragma solidity 0.6.6;
37 
38 /**
39  * @dev Contract module that helps prevent reentrant calls to a function.
40  *
41  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
42  * available, which can be applied to functions to make sure there are no nested
43  * (reentrant) calls to them.
44  *
45  * Note that because there is a single `nonReentrant` guard, functions marked as
46  * `nonReentrant` may not call one another. This can be worked around by making
47  * those functions `private`, and then adding `external` `nonReentrant` entry
48  * points to them.
49  *
50  * TIP: If you would like to learn more about reentrancy and alternative ways
51  * to protect against it, check out our blog post
52  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
53  */
54 contract ReentrancyGuard {
55     bool private _notEntered;
56 
57     constructor () internal {
58         // Storing an initial non-zero value makes deployment a bit more
59         // expensive, but in exchange the refund on every call to nonReentrant
60         // will be lower in amount. Since refunds are capped to a percetange of
61         // the total transaction's gas, it is best to keep them low in cases
62         // like this one, to increase the likelihood of the full refund coming
63         // into effect.
64         _notEntered = true;
65     }
66 
67     /**
68      * @dev Prevents a contract from calling itself, directly or indirectly.
69      * Calling a `nonReentrant` function from another `nonReentrant`
70      * function is not supported. It is possible to prevent this from happening
71      * by making the `nonReentrant` function external, and make it call a
72      * `private` function that does the actual work.
73      */
74     modifier nonReentrant() {
75         // On the first call to nonReentrant, _notEntered will be true
76         require(_notEntered, "ReentrancyGuard: reentrant call");
77 
78         // Any calls to nonReentrant after this point will fail
79         _notEntered = false;
80 
81         _;
82 
83         // By storing the original value once again, a refund is triggered (see
84         // https://eips.ethereum.org/EIPS/eip-2200)
85         _notEntered = true;
86     }
87 }
88 
89 // File: contracts/sol6/Dao/IEpochUtils.sol
90 
91 pragma solidity 0.6.6;
92 
93 interface IEpochUtils {
94     function epochPeriodInSeconds() external view returns (uint256);
95 
96     function firstEpochStartTimestamp() external view returns (uint256);
97 
98     function getCurrentEpochNumber() external view returns (uint256);
99 
100     function getEpochNumber(uint256 timestamp) external view returns (uint256);
101 }
102 
103 // File: contracts/sol6/Dao/IKyberStaking.sol
104 
105 pragma solidity 0.6.6;
106 
107 
108 
109 interface IKyberStaking is IEpochUtils {
110     event Delegated(
111         address indexed staker,
112         address indexed representative,
113         uint256 indexed epoch,
114         bool isDelegated
115     );
116     event Deposited(uint256 curEpoch, address indexed staker, uint256 amount);
117     event Withdraw(uint256 indexed curEpoch, address indexed staker, uint256 amount);
118 
119     function initAndReturnStakerDataForCurrentEpoch(address staker)
120         external
121         returns (
122             uint256 stake,
123             uint256 delegatedStake,
124             address representative
125         );
126 
127     function deposit(uint256 amount) external;
128 
129     function delegate(address dAddr) external;
130 
131     function withdraw(uint256 amount) external;
132 
133     /**
134      * @notice return combine data (stake, delegatedStake, representative) of a staker
135      * @dev allow to get staker data up to current epoch + 1
136      */
137     function getStakerData(address staker, uint256 epoch)
138         external
139         view
140         returns (
141             uint256 stake,
142             uint256 delegatedStake,
143             address representative
144         );
145 
146     function getLatestStakerData(address staker)
147         external
148         view
149         returns (
150             uint256 stake,
151             uint256 delegatedStake,
152             address representative
153         );
154 
155     /**
156      * @notice return raw data of a staker for an epoch
157      *         WARN: should be used only for initialized data
158      *          if data has not been initialized, it will return all 0
159      *          pool master shouldn't use this function to compute/distribute rewards of pool members
160      */
161     function getStakerRawData(address staker, uint256 epoch)
162         external
163         view
164         returns (
165             uint256 stake,
166             uint256 delegatedStake,
167             address representative
168         );
169 }
170 
171 // File: contracts/sol6/IKyberDao.sol
172 
173 pragma solidity 0.6.6;
174 
175 
176 
177 interface IKyberDao is IEpochUtils {
178     event Voted(address indexed staker, uint indexed epoch, uint indexed campaignID, uint option);
179 
180     function getLatestNetworkFeeDataWithCache()
181         external
182         returns (uint256 feeInBps, uint256 expiryTimestamp);
183 
184     function getLatestBRRDataWithCache()
185         external
186         returns (
187             uint256 burnInBps,
188             uint256 rewardInBps,
189             uint256 rebateInBps,
190             uint256 epoch,
191             uint256 expiryTimestamp
192         );
193 
194     function handleWithdrawal(address staker, uint256 penaltyAmount) external;
195 
196     function vote(uint256 campaignID, uint256 option) external;
197 
198     function getLatestNetworkFeeData()
199         external
200         view
201         returns (uint256 feeInBps, uint256 expiryTimestamp);
202 
203     function shouldBurnRewardForEpoch(uint256 epoch) external view returns (bool);
204 
205     /**
206      * @dev  return staker's reward percentage in precision for a past epoch only
207      *       fee handler should call this function when a staker wants to claim reward
208      *       return 0 if staker has no votes or stakes
209      */
210     function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
211         external
212         view
213         returns (uint256);
214 
215     /**
216      * @dev  return staker's reward percentage in precision for the current epoch
217      *       reward percentage is not finalized until the current epoch is ended
218      */
219     function getCurrentEpochRewardPercentageInPrecision(address staker)
220         external
221         view
222         returns (uint256);
223 }
224 
225 // File: contracts/sol6/utils/zeppelin/SafeMath.sol
226 
227 pragma solidity 0.6.6;
228 
229 /**
230  * @dev Wrappers over Solidity's arithmetic operations with added overflow
231  * checks.
232  *
233  * Arithmetic operations in Solidity wrap on overflow. This can easily result
234  * in bugs, because programmers usually assume that an overflow raises an
235  * error, which is the standard behavior in high level programming languages.
236  * `SafeMath` restores this intuition by reverting the transaction when an
237  * operation overflows.
238  *
239  * Using this library instead of the unchecked operations eliminates an entire
240  * class of bugs, so it's recommended to use it always.
241  */
242 library SafeMath {
243     /**
244      * @dev Returns the addition of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `+` operator.
248      *
249      * Requirements:
250      * - Addition cannot overflow.
251      */
252     function add(uint256 a, uint256 b) internal pure returns (uint256) {
253         uint256 c = a + b;
254         require(c >= a, "SafeMath: addition overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      * - Subtraction cannot overflow.
267      */
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         return sub(a, b, "SafeMath: subtraction overflow");
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274      * overflow (when the result is negative).
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      * - Subtraction cannot overflow.
280      */
281     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b <= a, errorMessage);
283         uint256 c = a - b;
284 
285         return c;
286     }
287 
288     /**
289      * @dev Returns the multiplication of two unsigned integers, reverting on
290      * overflow.
291      *
292      * Counterpart to Solidity's `*` operator.
293      *
294      * Requirements:
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299         // benefit is lost if 'b' is also tested.
300         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
301         if (a == 0) {
302             return 0;
303         }
304 
305         uint256 c = a * b;
306         require(c / a == b, "SafeMath: multiplication overflow");
307 
308         return c;
309     }
310 
311     /**
312      * @dev Returns the integer division of two unsigned integers. Reverts on
313      * division by zero. The result is rounded towards zero.
314      *
315      * Counterpart to Solidity's `/` operator. Note: this function uses a
316      * `revert` opcode (which leaves remaining gas untouched) while Solidity
317      * uses an invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      * - The divisor cannot be zero.
321      */
322     function div(uint256 a, uint256 b) internal pure returns (uint256) {
323         return div(a, b, "SafeMath: division by zero");
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
328      * division by zero. The result is rounded towards zero.
329      *
330      * Counterpart to Solidity's `/` operator. Note: this function uses a
331      * `revert` opcode (which leaves remaining gas untouched) while Solidity
332      * uses an invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         // Solidity only automatically asserts when dividing by 0
339         require(b > 0, errorMessage);
340         uint256 c = a / b;
341         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
342 
343         return c;
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * Reverts when dividing by zero.
349      *
350      * Counterpart to Solidity's `%` operator. This function uses a `revert`
351      * opcode (which leaves remaining gas untouched) while Solidity uses an
352      * invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      * - The divisor cannot be zero.
356      */
357     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
358         return mod(a, b, "SafeMath: modulo by zero");
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * Reverts with custom message when dividing by zero.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      * - The divisor cannot be zero.
371      */
372     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
373         require(b != 0, errorMessage);
374         return a % b;
375     }
376 
377     /**
378      * @dev Returns the smallest of two numbers.
379      */
380     function min(uint256 a, uint256 b) internal pure returns (uint256) {
381         return a < b ? a : b;
382     }
383 }
384 
385 // File: contracts/sol6/Dao/EpochUtils.sol
386 
387 pragma solidity 0.6.6;
388 
389 
390 
391 contract EpochUtils is IEpochUtils {
392     using SafeMath for uint256;
393 
394     uint256 public override epochPeriodInSeconds;
395     uint256 public override firstEpochStartTimestamp;
396 
397     function getCurrentEpochNumber() public view override returns (uint256) {
398         return getEpochNumber(now);
399     }
400 
401     function getEpochNumber(uint256 timestamp) public view override returns (uint256) {
402         if (timestamp < firstEpochStartTimestamp || epochPeriodInSeconds == 0) {
403             return 0;
404         }
405         // ((timestamp - firstEpochStartTimestamp) / epochPeriodInSeconds) + 1;
406         return ((timestamp.sub(firstEpochStartTimestamp)).div(epochPeriodInSeconds)).add(1);
407     }
408 }
409 
410 // File: contracts/sol6/Dao/KyberStaking.sol
411 
412 pragma solidity 0.6.6;
413 
414 
415 
416 
417 
418 
419 
420 /**
421  * @notice   This contract is using SafeMath for uint, which is inherited from EpochUtils
422  *           Some events are moved to interface, easier for public uses
423  *           Staking contract will be deployed by KyberDao's contract
424  */
425 contract KyberStaking is IKyberStaking, EpochUtils, ReentrancyGuard {
426     struct StakerData {
427         uint256 stake;
428         uint256 delegatedStake;
429         address representative;
430     }
431 
432     IERC20 public immutable kncToken;
433     IKyberDao public immutable kyberDao;
434 
435     // staker data per epoch, including stake, delegated stake and representative
436     mapping(uint256 => mapping(address => StakerData)) internal stakerPerEpochData;
437     // latest data of a staker, including stake, delegated stake, representative
438     mapping(address => StakerData) internal stakerLatestData;
439     // true/false: if data has been initialized at an epoch for a staker
440     mapping(uint256 => mapping(address => bool)) internal hasInited;
441 
442     // event is fired if something is wrong with withdrawal
443     // even though the withdrawal is still successful
444     event WithdrawDataUpdateFailed(uint256 curEpoch, address staker, uint256 amount);
445 
446     constructor(
447         IERC20 _kncToken,
448         uint256 _epochPeriod,
449         uint256 _startTimestamp,
450         IKyberDao _kyberDao
451     ) public {
452         require(_epochPeriod > 0, "ctor: epoch period is 0");
453         require(_startTimestamp >= now, "ctor: start in the past");
454         require(_kncToken != IERC20(0), "ctor: kncToken 0");
455         require(_kyberDao != IKyberDao(0), "ctor: kyberDao 0");
456 
457         epochPeriodInSeconds = _epochPeriod;
458         firstEpochStartTimestamp = _startTimestamp;
459         kncToken = _kncToken;
460         kyberDao = _kyberDao;
461     }
462 
463     /**
464      * @dev calls to set delegation for msg.sender, will take effect from the next epoch
465      * @param newRepresentative address to delegate to
466      */
467     function delegate(address newRepresentative) external override {
468         require(newRepresentative != address(0), "delegate: representative 0");
469         address staker = msg.sender;
470         uint256 curEpoch = getCurrentEpochNumber();
471 
472         initDataIfNeeded(staker, curEpoch);
473 
474         address curRepresentative = stakerPerEpochData[curEpoch + 1][staker].representative;
475         // nothing changes here
476         if (newRepresentative == curRepresentative) {
477             return;
478         }
479 
480         uint256 updatedStake = stakerPerEpochData[curEpoch + 1][staker].stake;
481 
482         // reduce delegatedStake for curRepresentative if needed
483         if (curRepresentative != staker) {
484             initDataIfNeeded(curRepresentative, curEpoch);
485 
486             stakerPerEpochData[curEpoch + 1][curRepresentative].delegatedStake =
487                 stakerPerEpochData[curEpoch + 1][curRepresentative].delegatedStake.sub(updatedStake);
488             stakerLatestData[curRepresentative].delegatedStake =
489                 stakerLatestData[curRepresentative].delegatedStake.sub(updatedStake);
490 
491             emit Delegated(staker, curRepresentative, curEpoch, false);
492         }
493 
494         stakerLatestData[staker].representative = newRepresentative;
495         stakerPerEpochData[curEpoch + 1][staker].representative = newRepresentative;
496 
497         // ignore if staker is delegating back to himself
498         if (newRepresentative != staker) {
499             initDataIfNeeded(newRepresentative, curEpoch);
500             stakerPerEpochData[curEpoch + 1][newRepresentative].delegatedStake =
501                 stakerPerEpochData[curEpoch + 1][newRepresentative].delegatedStake.add(updatedStake);
502             stakerLatestData[newRepresentative].delegatedStake =
503                 stakerLatestData[newRepresentative].delegatedStake.add(updatedStake);
504             emit Delegated(staker, newRepresentative, curEpoch, true);
505         }
506     }
507 
508     /**
509      * @dev call to stake more KNC for msg.sender
510      * @param amount amount of KNC to stake
511      */
512     function deposit(uint256 amount) external override {
513         require(amount > 0, "deposit: amount is 0");
514 
515         uint256 curEpoch = getCurrentEpochNumber();
516         address staker = msg.sender;
517 
518         // collect KNC token from staker
519         require(
520             kncToken.transferFrom(staker, address(this), amount),
521             "deposit: can not get token"
522         );
523 
524         initDataIfNeeded(staker, curEpoch);
525 
526         stakerPerEpochData[curEpoch + 1][staker].stake =
527             stakerPerEpochData[curEpoch + 1][staker].stake.add(amount);
528         stakerLatestData[staker].stake =
529             stakerLatestData[staker].stake.add(amount);
530 
531         // increase delegated stake for address that staker has delegated to (if it is not staker)
532         address representative = stakerPerEpochData[curEpoch + 1][staker].representative;
533         if (representative != staker) {
534             initDataIfNeeded(representative, curEpoch);
535             stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
536                 stakerPerEpochData[curEpoch + 1][representative].delegatedStake.add(amount);
537             stakerLatestData[representative].delegatedStake =
538                 stakerLatestData[representative].delegatedStake.add(amount);
539         }
540 
541         emit Deposited(curEpoch, staker, amount);
542     }
543 
544     /**
545      * @dev call to withdraw KNC from staking, it could affect reward when calling KyberDao handleWithdrawal
546      * @param amount amount of KNC to withdraw
547      */
548     function withdraw(uint256 amount) external override nonReentrant {
549         require(amount > 0, "withdraw: amount is 0");
550 
551         uint256 curEpoch = getCurrentEpochNumber();
552         address staker = msg.sender;
553 
554         require(
555             stakerLatestData[staker].stake >= amount,
556             "withdraw: latest amount staked < withdrawal amount"
557         );
558 
559         (bool success, ) = address(this).call(
560             abi.encodeWithSignature(
561                 "handleWithdrawal(address,uint256,uint256)",
562                 staker,
563                 amount,
564                 curEpoch
565             )
566         );
567         if (!success) {
568             // Note: should catch this event to check if something went wrong
569             emit WithdrawDataUpdateFailed(curEpoch, staker, amount);
570         }
571 
572         stakerLatestData[staker].stake = stakerLatestData[staker].stake.sub(amount);
573 
574         // transfer KNC back to staker
575         require(kncToken.transfer(staker, amount), "withdraw: can not transfer knc");
576         emit Withdraw(curEpoch, staker, amount);
577     }
578 
579     /**
580      * @dev initialize data if needed, then return staker's data for current epoch
581      * @dev for safe, only allow calling this func from KyberDao address
582      * @param staker - staker's address to initialize and get data for
583      */
584     function initAndReturnStakerDataForCurrentEpoch(address staker)
585         external
586         override
587         returns (
588             uint256 stake,
589             uint256 delegatedStake,
590             address representative
591         )
592     {
593         require(
594             msg.sender == address(kyberDao),
595             "initAndReturnData: only kyberDao"
596         );
597 
598         uint256 curEpoch = getCurrentEpochNumber();
599         initDataIfNeeded(staker, curEpoch);
600 
601         StakerData memory stakerData = stakerPerEpochData[curEpoch][staker];
602         stake = stakerData.stake;
603         delegatedStake = stakerData.delegatedStake;
604         representative = stakerData.representative;
605     }
606 
607     /**
608      * @notice return raw data of a staker for an epoch
609      *         WARN: should be used only for initialized data
610      *          if data has not been initialized, it will return all 0
611      *          pool master shouldn't use this function to compute/distribute rewards of pool members
612      * @dev  in KyberDao contract, if staker wants to claim reward for past epoch,
613      *       we must know the staker's data for that epoch
614      *       if the data has not been initialized, it means staker hasn't done any action -> no reward
615      */
616     function getStakerRawData(address staker, uint256 epoch)
617         external
618         view
619         override
620         returns (
621             uint256 stake,
622             uint256 delegatedStake,
623             address representative
624         )
625     {
626         StakerData memory stakerData = stakerPerEpochData[epoch][staker];
627         stake = stakerData.stake;
628         delegatedStake = stakerData.delegatedStake;
629         representative = stakerData.representative;
630     }
631 
632     /**
633      * @dev allow to get data up to current epoch + 1
634      */
635     function getStake(address staker, uint256 epoch) external view returns (uint256) {
636         uint256 curEpoch = getCurrentEpochNumber();
637         if (epoch > curEpoch + 1) {
638             return 0;
639         }
640         uint256 i = epoch;
641         while (true) {
642             if (hasInited[i][staker]) {
643                 return stakerPerEpochData[i][staker].stake;
644             }
645             if (i == 0) {
646                 break;
647             }
648             i--;
649         }
650         return 0;
651     }
652 
653     /**
654      * @dev allow to get data up to current epoch + 1
655      */
656     function getDelegatedStake(address staker, uint256 epoch) external view returns (uint256) {
657         uint256 curEpoch = getCurrentEpochNumber();
658         if (epoch > curEpoch + 1) {
659             return 0;
660         }
661         uint256 i = epoch;
662         while (true) {
663             if (hasInited[i][staker]) {
664                 return stakerPerEpochData[i][staker].delegatedStake;
665             }
666             if (i == 0) {
667                 break;
668             }
669             i--;
670         }
671         return 0;
672     }
673 
674     /**
675      * @dev allow to get data up to current epoch + 1
676      */
677     function getRepresentative(address staker, uint256 epoch) external view returns (address) {
678         uint256 curEpoch = getCurrentEpochNumber();
679         if (epoch > curEpoch + 1) {
680             return address(0);
681         }
682         uint256 i = epoch;
683         while (true) {
684             if (hasInited[i][staker]) {
685                 return stakerPerEpochData[i][staker].representative;
686             }
687             if (i == 0) {
688                 break;
689             }
690             i--;
691         }
692         // not delegated to anyone, default to yourself
693         return staker;
694     }
695 
696     /**
697      * @notice return combine data (stake, delegatedStake, representative) of a staker
698      * @dev allow to get staker data up to current epoch + 1
699      */
700     function getStakerData(address staker, uint256 epoch)
701         external view override
702         returns (
703             uint256 stake,
704             uint256 delegatedStake,
705             address representative
706         )
707     {
708         stake = 0;
709         delegatedStake = 0;
710         representative = address(0);
711 
712         uint256 curEpoch = getCurrentEpochNumber();
713         if (epoch > curEpoch + 1) {
714             return (stake, delegatedStake, representative);
715         }
716         uint256 i = epoch;
717         while (true) {
718             if (hasInited[i][staker]) {
719                 stake = stakerPerEpochData[i][staker].stake;
720                 delegatedStake = stakerPerEpochData[i][staker].delegatedStake;
721                 representative = stakerPerEpochData[i][staker].representative;
722                 return (stake, delegatedStake, representative);
723             }
724             if (i == 0) {
725                 break;
726             }
727             i--;
728         }
729         // not delegated to anyone, default to yourself
730         representative = staker;
731     }
732 
733     function getLatestRepresentative(address staker) external view returns (address) {
734         return
735             stakerLatestData[staker].representative == address(0)
736                 ? staker
737                 : stakerLatestData[staker].representative;
738     }
739 
740     function getLatestDelegatedStake(address staker) external view returns (uint256) {
741         return stakerLatestData[staker].delegatedStake;
742     }
743 
744     function getLatestStakeBalance(address staker) external view returns (uint256) {
745         return stakerLatestData[staker].stake;
746     }
747 
748     function getLatestStakerData(address staker)
749         external view override
750         returns (
751             uint256 stake,
752             uint256 delegatedStake,
753             address representative
754         )
755     {
756         stake = stakerLatestData[staker].stake;
757         delegatedStake = stakerLatestData[staker].delegatedStake;
758         representative = stakerLatestData[staker].representative == address(0)
759                 ? staker
760                 : stakerLatestData[staker].representative;
761     }
762 
763     /**
764     * @dev  separate logics from withdraw, so staker can withdraw as long as amount <= staker's deposit amount
765             calling this function from withdraw function, ignore reverting
766     * @param staker staker that is withdrawing
767     * @param amount amount to withdraw
768     * @param curEpoch current epoch
769     */
770     function handleWithdrawal(
771         address staker,
772         uint256 amount,
773         uint256 curEpoch
774     ) external {
775         require(msg.sender == address(this), "only staking contract");
776         initDataIfNeeded(staker, curEpoch);
777         // Note: update latest stake will be done after this function
778         // update staker's data for next epoch
779         stakerPerEpochData[curEpoch + 1][staker].stake =
780             stakerPerEpochData[curEpoch + 1][staker].stake.sub(amount);
781 
782         address representative = stakerPerEpochData[curEpoch][staker].representative;
783         uint256 curStake = stakerPerEpochData[curEpoch][staker].stake;
784         uint256 lStakeBal = stakerLatestData[staker].stake.sub(amount);
785         uint256 newStake = curStake.min(lStakeBal);
786         uint256 reduceAmount = curStake.sub(newStake); // newStake is always <= curStake
787 
788         if (reduceAmount > 0) {
789             if (representative != staker) {
790                 initDataIfNeeded(representative, curEpoch);
791                 // staker has delegated to representative, withdraw will affect representative's delegated stakes
792                 stakerPerEpochData[curEpoch][representative].delegatedStake =
793                     stakerPerEpochData[curEpoch][representative].delegatedStake.sub(reduceAmount);
794             }
795             stakerPerEpochData[curEpoch][staker].stake = newStake;
796             // call KyberDao to reduce reward, if staker has delegated, then pass his representative
797             if (address(kyberDao) != address(0)) {
798                 // don't revert if KyberDao revert so data will be updated correctly
799                 (bool success, ) = address(kyberDao).call(
800                     abi.encodeWithSignature(
801                         "handleWithdrawal(address,uint256)",
802                         representative,
803                         reduceAmount
804                     )
805                 );
806                 if (!success) {
807                     emit WithdrawDataUpdateFailed(curEpoch, staker, amount);
808                 }
809             }
810         }
811         representative = stakerPerEpochData[curEpoch + 1][staker].representative;
812         if (representative != staker) {
813             initDataIfNeeded(representative, curEpoch);
814             stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
815                 stakerPerEpochData[curEpoch + 1][representative].delegatedStake.sub(amount);
816             stakerLatestData[representative].delegatedStake =
817                 stakerLatestData[representative].delegatedStake.sub(amount);
818         }
819     }
820 
821     /**
822      * @dev initialize data if it has not been initialized yet
823      * @param staker staker's address to initialize
824      * @param epoch should be current epoch
825      */
826     function initDataIfNeeded(address staker, uint256 epoch) internal {
827         address representative = stakerLatestData[staker].representative;
828         if (representative == address(0)) {
829             // not delegate to anyone, consider as delegate to yourself
830             stakerLatestData[staker].representative = staker;
831             representative = staker;
832         }
833 
834         uint256 ldStake = stakerLatestData[staker].delegatedStake;
835         uint256 lStakeBal = stakerLatestData[staker].stake;
836 
837         if (!hasInited[epoch][staker]) {
838             hasInited[epoch][staker] = true;
839             StakerData storage stakerData = stakerPerEpochData[epoch][staker];
840             stakerData.representative = representative;
841             stakerData.delegatedStake = ldStake;
842             stakerData.stake = lStakeBal;
843         }
844 
845         // whenever stakers deposit/withdraw/delegate, the current and next epoch data need to be updated
846         // as the result, we will also initialize data for staker at the next epoch
847         if (!hasInited[epoch + 1][staker]) {
848             hasInited[epoch + 1][staker] = true;
849             StakerData storage nextEpochStakerData = stakerPerEpochData[epoch + 1][staker];
850             nextEpochStakerData.representative = representative;
851             nextEpochStakerData.delegatedStake = ldStake;
852             nextEpochStakerData.stake = lStakeBal;
853         }
854     }
855 }