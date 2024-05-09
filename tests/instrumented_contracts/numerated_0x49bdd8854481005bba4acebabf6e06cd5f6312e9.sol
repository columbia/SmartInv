1 // File: contracts/sol6/utils/zeppelin/SafeMath.sol
2 
3 pragma solidity 0.6.6;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 
153     /**
154      * @dev Returns the smallest of two numbers.
155      */
156     function min(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a < b ? a : b;
158     }
159 }
160 
161 // File: contracts/sol6/Dao/IEpochUtils.sol
162 
163 pragma solidity 0.6.6;
164 
165 interface IEpochUtils {
166     function epochPeriodInSeconds() external view returns (uint256);
167 
168     function firstEpochStartTimestamp() external view returns (uint256);
169 
170     function getCurrentEpochNumber() external view returns (uint256);
171 
172     function getEpochNumber(uint256 timestamp) external view returns (uint256);
173 }
174 
175 // File: contracts/sol6/Dao/EpochUtils.sol
176 
177 pragma solidity 0.6.6;
178 
179 
180 
181 contract EpochUtils is IEpochUtils {
182     using SafeMath for uint256;
183 
184     uint256 public override epochPeriodInSeconds;
185     uint256 public override firstEpochStartTimestamp;
186 
187     function getCurrentEpochNumber() public view override returns (uint256) {
188         return getEpochNumber(now);
189     }
190 
191     function getEpochNumber(uint256 timestamp) public view override returns (uint256) {
192         if (timestamp < firstEpochStartTimestamp || epochPeriodInSeconds == 0) {
193             return 0;
194         }
195         // ((timestamp - firstEpochStartTimestamp) / epochPeriodInSeconds) + 1;
196         return ((timestamp.sub(firstEpochStartTimestamp)).div(epochPeriodInSeconds)).add(1);
197     }
198 }
199 
200 // File: contracts/sol6/Dao/DaoOperator.sol
201 
202 pragma solidity 0.6.6;
203 
204 
205 contract DaoOperator {
206     address public daoOperator;
207 
208     constructor(address _daoOperator) public {
209         require(_daoOperator != address(0), "daoOperator is 0");
210         daoOperator = _daoOperator;
211     }
212 
213     modifier onlyDaoOperator() {
214         require(msg.sender == daoOperator, "only daoOperator");
215         _;
216     }
217 }
218 
219 // File: contracts/sol6/IERC20.sol
220 
221 pragma solidity 0.6.6;
222 
223 
224 interface IERC20 {
225     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
226 
227     function approve(address _spender, uint256 _value) external returns (bool success);
228 
229     function transfer(address _to, uint256 _value) external returns (bool success);
230 
231     function transferFrom(
232         address _from,
233         address _to,
234         uint256 _value
235     ) external returns (bool success);
236 
237     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
238 
239     function balanceOf(address _owner) external view returns (uint256 balance);
240 
241     function decimals() external view returns (uint8 digits);
242 
243     function totalSupply() external view returns (uint256 supply);
244 }
245 
246 
247 // to support backward compatible contract name -- so function signature remains same
248 abstract contract ERC20 is IERC20 {
249 
250 }
251 
252 // File: contracts/sol6/utils/zeppelin/ReentrancyGuard.sol
253 
254 pragma solidity 0.6.6;
255 
256 /**
257  * @dev Contract module that helps prevent reentrant calls to a function.
258  *
259  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
260  * available, which can be applied to functions to make sure there are no nested
261  * (reentrant) calls to them.
262  *
263  * Note that because there is a single `nonReentrant` guard, functions marked as
264  * `nonReentrant` may not call one another. This can be worked around by making
265  * those functions `private`, and then adding `external` `nonReentrant` entry
266  * points to them.
267  *
268  * TIP: If you would like to learn more about reentrancy and alternative ways
269  * to protect against it, check out our blog post
270  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
271  */
272 contract ReentrancyGuard {
273     bool private _notEntered;
274 
275     constructor () internal {
276         // Storing an initial non-zero value makes deployment a bit more
277         // expensive, but in exchange the refund on every call to nonReentrant
278         // will be lower in amount. Since refunds are capped to a percetange of
279         // the total transaction's gas, it is best to keep them low in cases
280         // like this one, to increase the likelihood of the full refund coming
281         // into effect.
282         _notEntered = true;
283     }
284 
285     /**
286      * @dev Prevents a contract from calling itself, directly or indirectly.
287      * Calling a `nonReentrant` function from another `nonReentrant`
288      * function is not supported. It is possible to prevent this from happening
289      * by making the `nonReentrant` function external, and make it call a
290      * `private` function that does the actual work.
291      */
292     modifier nonReentrant() {
293         // On the first call to nonReentrant, _notEntered will be true
294         require(_notEntered, "ReentrancyGuard: reentrant call");
295 
296         // Any calls to nonReentrant after this point will fail
297         _notEntered = false;
298 
299         _;
300 
301         // By storing the original value once again, a refund is triggered (see
302         // https://eips.ethereum.org/EIPS/eip-2200)
303         _notEntered = true;
304     }
305 }
306 
307 // File: contracts/sol6/Dao/IKyberStaking.sol
308 
309 pragma solidity 0.6.6;
310 
311 
312 
313 interface IKyberStaking is IEpochUtils {
314     event Delegated(
315         address indexed staker,
316         address indexed representative,
317         uint256 indexed epoch,
318         bool isDelegated
319     );
320     event Deposited(uint256 curEpoch, address indexed staker, uint256 amount);
321     event Withdraw(uint256 indexed curEpoch, address indexed staker, uint256 amount);
322 
323     function initAndReturnStakerDataForCurrentEpoch(address staker)
324         external
325         returns (
326             uint256 stake,
327             uint256 delegatedStake,
328             address representative
329         );
330 
331     function deposit(uint256 amount) external;
332 
333     function delegate(address dAddr) external;
334 
335     function withdraw(uint256 amount) external;
336 
337     /**
338      * @notice return combine data (stake, delegatedStake, representative) of a staker
339      * @dev allow to get staker data up to current epoch + 1
340      */
341     function getStakerData(address staker, uint256 epoch)
342         external
343         view
344         returns (
345             uint256 stake,
346             uint256 delegatedStake,
347             address representative
348         );
349 
350     function getLatestStakerData(address staker)
351         external
352         view
353         returns (
354             uint256 stake,
355             uint256 delegatedStake,
356             address representative
357         );
358 
359     /**
360      * @notice return raw data of a staker for an epoch
361      *         WARN: should be used only for initialized data
362      *          if data has not been initialized, it will return all 0
363      *          pool master shouldn't use this function to compute/distribute rewards of pool members
364      */
365     function getStakerRawData(address staker, uint256 epoch)
366         external
367         view
368         returns (
369             uint256 stake,
370             uint256 delegatedStake,
371             address representative
372         );
373 }
374 
375 // File: contracts/sol6/IKyberDao.sol
376 
377 pragma solidity 0.6.6;
378 
379 
380 
381 interface IKyberDao is IEpochUtils {
382     event Voted(address indexed staker, uint indexed epoch, uint indexed campaignID, uint option);
383 
384     function getLatestNetworkFeeDataWithCache()
385         external
386         returns (uint256 feeInBps, uint256 expiryTimestamp);
387 
388     function getLatestBRRDataWithCache()
389         external
390         returns (
391             uint256 burnInBps,
392             uint256 rewardInBps,
393             uint256 rebateInBps,
394             uint256 epoch,
395             uint256 expiryTimestamp
396         );
397 
398     function handleWithdrawal(address staker, uint256 penaltyAmount) external;
399 
400     function vote(uint256 campaignID, uint256 option) external;
401 
402     function getLatestNetworkFeeData()
403         external
404         view
405         returns (uint256 feeInBps, uint256 expiryTimestamp);
406 
407     function shouldBurnRewardForEpoch(uint256 epoch) external view returns (bool);
408 
409     /**
410      * @dev  return staker's reward percentage in precision for a past epoch only
411      *       fee handler should call this function when a staker wants to claim reward
412      *       return 0 if staker has no votes or stakes
413      */
414     function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
415         external
416         view
417         returns (uint256);
418 
419     /**
420      * @dev  return staker's reward percentage in precision for the current epoch
421      *       reward percentage is not finalized until the current epoch is ended
422      */
423     function getCurrentEpochRewardPercentageInPrecision(address staker)
424         external
425         view
426         returns (uint256);
427 }
428 
429 // File: contracts/sol6/Dao/KyberStaking.sol
430 
431 pragma solidity 0.6.6;
432 
433 
434 
435 
436 
437 
438 
439 /**
440  * @notice   This contract is using SafeMath for uint, which is inherited from EpochUtils
441  *           Some events are moved to interface, easier for public uses
442  *           Staking contract will be deployed by KyberDao's contract
443  */
444 contract KyberStaking is IKyberStaking, EpochUtils, ReentrancyGuard {
445     struct StakerData {
446         uint256 stake;
447         uint256 delegatedStake;
448         address representative;
449     }
450 
451     IERC20 public immutable kncToken;
452     IKyberDao public immutable kyberDao;
453 
454     // staker data per epoch, including stake, delegated stake and representative
455     mapping(uint256 => mapping(address => StakerData)) internal stakerPerEpochData;
456     // latest data of a staker, including stake, delegated stake, representative
457     mapping(address => StakerData) internal stakerLatestData;
458     // true/false: if data has been initialized at an epoch for a staker
459     mapping(uint256 => mapping(address => bool)) internal hasInited;
460 
461     // event is fired if something is wrong with withdrawal
462     // even though the withdrawal is still successful
463     event WithdrawDataUpdateFailed(uint256 curEpoch, address staker, uint256 amount);
464 
465     constructor(
466         IERC20 _kncToken,
467         uint256 _epochPeriod,
468         uint256 _startTimestamp,
469         IKyberDao _kyberDao
470     ) public {
471         require(_epochPeriod > 0, "ctor: epoch period is 0");
472         require(_startTimestamp >= now, "ctor: start in the past");
473         require(_kncToken != IERC20(0), "ctor: kncToken 0");
474         require(_kyberDao != IKyberDao(0), "ctor: kyberDao 0");
475 
476         epochPeriodInSeconds = _epochPeriod;
477         firstEpochStartTimestamp = _startTimestamp;
478         kncToken = _kncToken;
479         kyberDao = _kyberDao;
480     }
481 
482     /**
483      * @dev calls to set delegation for msg.sender, will take effect from the next epoch
484      * @param newRepresentative address to delegate to
485      */
486     function delegate(address newRepresentative) external override {
487         require(newRepresentative != address(0), "delegate: representative 0");
488         address staker = msg.sender;
489         uint256 curEpoch = getCurrentEpochNumber();
490 
491         initDataIfNeeded(staker, curEpoch);
492 
493         address curRepresentative = stakerPerEpochData[curEpoch + 1][staker].representative;
494         // nothing changes here
495         if (newRepresentative == curRepresentative) {
496             return;
497         }
498 
499         uint256 updatedStake = stakerPerEpochData[curEpoch + 1][staker].stake;
500 
501         // reduce delegatedStake for curRepresentative if needed
502         if (curRepresentative != staker) {
503             initDataIfNeeded(curRepresentative, curEpoch);
504 
505             stakerPerEpochData[curEpoch + 1][curRepresentative].delegatedStake =
506                 stakerPerEpochData[curEpoch + 1][curRepresentative].delegatedStake.sub(updatedStake);
507             stakerLatestData[curRepresentative].delegatedStake =
508                 stakerLatestData[curRepresentative].delegatedStake.sub(updatedStake);
509 
510             emit Delegated(staker, curRepresentative, curEpoch, false);
511         }
512 
513         stakerLatestData[staker].representative = newRepresentative;
514         stakerPerEpochData[curEpoch + 1][staker].representative = newRepresentative;
515 
516         // ignore if staker is delegating back to himself
517         if (newRepresentative != staker) {
518             initDataIfNeeded(newRepresentative, curEpoch);
519             stakerPerEpochData[curEpoch + 1][newRepresentative].delegatedStake =
520                 stakerPerEpochData[curEpoch + 1][newRepresentative].delegatedStake.add(updatedStake);
521             stakerLatestData[newRepresentative].delegatedStake =
522                 stakerLatestData[newRepresentative].delegatedStake.add(updatedStake);
523             emit Delegated(staker, newRepresentative, curEpoch, true);
524         }
525     }
526 
527     /**
528      * @dev call to stake more KNC for msg.sender
529      * @param amount amount of KNC to stake
530      */
531     function deposit(uint256 amount) external override {
532         require(amount > 0, "deposit: amount is 0");
533 
534         uint256 curEpoch = getCurrentEpochNumber();
535         address staker = msg.sender;
536 
537         // collect KNC token from staker
538         require(
539             kncToken.transferFrom(staker, address(this), amount),
540             "deposit: can not get token"
541         );
542 
543         initDataIfNeeded(staker, curEpoch);
544 
545         stakerPerEpochData[curEpoch + 1][staker].stake =
546             stakerPerEpochData[curEpoch + 1][staker].stake.add(amount);
547         stakerLatestData[staker].stake =
548             stakerLatestData[staker].stake.add(amount);
549 
550         // increase delegated stake for address that staker has delegated to (if it is not staker)
551         address representative = stakerPerEpochData[curEpoch + 1][staker].representative;
552         if (representative != staker) {
553             initDataIfNeeded(representative, curEpoch);
554             stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
555                 stakerPerEpochData[curEpoch + 1][representative].delegatedStake.add(amount);
556             stakerLatestData[representative].delegatedStake =
557                 stakerLatestData[representative].delegatedStake.add(amount);
558         }
559 
560         emit Deposited(curEpoch, staker, amount);
561     }
562 
563     /**
564      * @dev call to withdraw KNC from staking, it could affect reward when calling KyberDao handleWithdrawal
565      * @param amount amount of KNC to withdraw
566      */
567     function withdraw(uint256 amount) external override nonReentrant {
568         require(amount > 0, "withdraw: amount is 0");
569 
570         uint256 curEpoch = getCurrentEpochNumber();
571         address staker = msg.sender;
572 
573         require(
574             stakerLatestData[staker].stake >= amount,
575             "withdraw: latest amount staked < withdrawal amount"
576         );
577 
578         (bool success, ) = address(this).call(
579             abi.encodeWithSignature(
580                 "handleWithdrawal(address,uint256,uint256)",
581                 staker,
582                 amount,
583                 curEpoch
584             )
585         );
586         if (!success) {
587             // Note: should catch this event to check if something went wrong
588             emit WithdrawDataUpdateFailed(curEpoch, staker, amount);
589         }
590 
591         stakerLatestData[staker].stake = stakerLatestData[staker].stake.sub(amount);
592 
593         // transfer KNC back to staker
594         require(kncToken.transfer(staker, amount), "withdraw: can not transfer knc");
595         emit Withdraw(curEpoch, staker, amount);
596     }
597 
598     /**
599      * @dev initialize data if needed, then return staker's data for current epoch
600      * @dev for safe, only allow calling this func from KyberDao address
601      * @param staker - staker's address to initialize and get data for
602      */
603     function initAndReturnStakerDataForCurrentEpoch(address staker)
604         external
605         override
606         returns (
607             uint256 stake,
608             uint256 delegatedStake,
609             address representative
610         )
611     {
612         require(
613             msg.sender == address(kyberDao),
614             "initAndReturnData: only kyberDao"
615         );
616 
617         uint256 curEpoch = getCurrentEpochNumber();
618         initDataIfNeeded(staker, curEpoch);
619 
620         StakerData memory stakerData = stakerPerEpochData[curEpoch][staker];
621         stake = stakerData.stake;
622         delegatedStake = stakerData.delegatedStake;
623         representative = stakerData.representative;
624     }
625 
626     /**
627      * @notice return raw data of a staker for an epoch
628      *         WARN: should be used only for initialized data
629      *          if data has not been initialized, it will return all 0
630      *          pool master shouldn't use this function to compute/distribute rewards of pool members
631      * @dev  in KyberDao contract, if staker wants to claim reward for past epoch,
632      *       we must know the staker's data for that epoch
633      *       if the data has not been initialized, it means staker hasn't done any action -> no reward
634      */
635     function getStakerRawData(address staker, uint256 epoch)
636         external
637         view
638         override
639         returns (
640             uint256 stake,
641             uint256 delegatedStake,
642             address representative
643         )
644     {
645         StakerData memory stakerData = stakerPerEpochData[epoch][staker];
646         stake = stakerData.stake;
647         delegatedStake = stakerData.delegatedStake;
648         representative = stakerData.representative;
649     }
650 
651     /**
652      * @dev allow to get data up to current epoch + 1
653      */
654     function getStake(address staker, uint256 epoch) external view returns (uint256) {
655         uint256 curEpoch = getCurrentEpochNumber();
656         if (epoch > curEpoch + 1) {
657             return 0;
658         }
659         uint256 i = epoch;
660         while (true) {
661             if (hasInited[i][staker]) {
662                 return stakerPerEpochData[i][staker].stake;
663             }
664             if (i == 0) {
665                 break;
666             }
667             i--;
668         }
669         return 0;
670     }
671 
672     /**
673      * @dev allow to get data up to current epoch + 1
674      */
675     function getDelegatedStake(address staker, uint256 epoch) external view returns (uint256) {
676         uint256 curEpoch = getCurrentEpochNumber();
677         if (epoch > curEpoch + 1) {
678             return 0;
679         }
680         uint256 i = epoch;
681         while (true) {
682             if (hasInited[i][staker]) {
683                 return stakerPerEpochData[i][staker].delegatedStake;
684             }
685             if (i == 0) {
686                 break;
687             }
688             i--;
689         }
690         return 0;
691     }
692 
693     /**
694      * @dev allow to get data up to current epoch + 1
695      */
696     function getRepresentative(address staker, uint256 epoch) external view returns (address) {
697         uint256 curEpoch = getCurrentEpochNumber();
698         if (epoch > curEpoch + 1) {
699             return address(0);
700         }
701         uint256 i = epoch;
702         while (true) {
703             if (hasInited[i][staker]) {
704                 return stakerPerEpochData[i][staker].representative;
705             }
706             if (i == 0) {
707                 break;
708             }
709             i--;
710         }
711         // not delegated to anyone, default to yourself
712         return staker;
713     }
714 
715     /**
716      * @notice return combine data (stake, delegatedStake, representative) of a staker
717      * @dev allow to get staker data up to current epoch + 1
718      */
719     function getStakerData(address staker, uint256 epoch)
720         external view override
721         returns (
722             uint256 stake,
723             uint256 delegatedStake,
724             address representative
725         )
726     {
727         stake = 0;
728         delegatedStake = 0;
729         representative = address(0);
730 
731         uint256 curEpoch = getCurrentEpochNumber();
732         if (epoch > curEpoch + 1) {
733             return (stake, delegatedStake, representative);
734         }
735         uint256 i = epoch;
736         while (true) {
737             if (hasInited[i][staker]) {
738                 stake = stakerPerEpochData[i][staker].stake;
739                 delegatedStake = stakerPerEpochData[i][staker].delegatedStake;
740                 representative = stakerPerEpochData[i][staker].representative;
741                 return (stake, delegatedStake, representative);
742             }
743             if (i == 0) {
744                 break;
745             }
746             i--;
747         }
748         // not delegated to anyone, default to yourself
749         representative = staker;
750     }
751 
752     function getLatestRepresentative(address staker) external view returns (address) {
753         return
754             stakerLatestData[staker].representative == address(0)
755                 ? staker
756                 : stakerLatestData[staker].representative;
757     }
758 
759     function getLatestDelegatedStake(address staker) external view returns (uint256) {
760         return stakerLatestData[staker].delegatedStake;
761     }
762 
763     function getLatestStakeBalance(address staker) external view returns (uint256) {
764         return stakerLatestData[staker].stake;
765     }
766 
767     function getLatestStakerData(address staker)
768         external view override
769         returns (
770             uint256 stake,
771             uint256 delegatedStake,
772             address representative
773         )
774     {
775         stake = stakerLatestData[staker].stake;
776         delegatedStake = stakerLatestData[staker].delegatedStake;
777         representative = stakerLatestData[staker].representative == address(0)
778                 ? staker
779                 : stakerLatestData[staker].representative;
780     }
781 
782     /**
783     * @dev  separate logics from withdraw, so staker can withdraw as long as amount <= staker's deposit amount
784             calling this function from withdraw function, ignore reverting
785     * @param staker staker that is withdrawing
786     * @param amount amount to withdraw
787     * @param curEpoch current epoch
788     */
789     function handleWithdrawal(
790         address staker,
791         uint256 amount,
792         uint256 curEpoch
793     ) external {
794         require(msg.sender == address(this), "only staking contract");
795         initDataIfNeeded(staker, curEpoch);
796         // Note: update latest stake will be done after this function
797         // update staker's data for next epoch
798         stakerPerEpochData[curEpoch + 1][staker].stake =
799             stakerPerEpochData[curEpoch + 1][staker].stake.sub(amount);
800 
801         address representative = stakerPerEpochData[curEpoch][staker].representative;
802         uint256 curStake = stakerPerEpochData[curEpoch][staker].stake;
803         uint256 lStakeBal = stakerLatestData[staker].stake.sub(amount);
804         uint256 newStake = curStake.min(lStakeBal);
805         uint256 reduceAmount = curStake.sub(newStake); // newStake is always <= curStake
806 
807         if (reduceAmount > 0) {
808             if (representative != staker) {
809                 initDataIfNeeded(representative, curEpoch);
810                 // staker has delegated to representative, withdraw will affect representative's delegated stakes
811                 stakerPerEpochData[curEpoch][representative].delegatedStake =
812                     stakerPerEpochData[curEpoch][representative].delegatedStake.sub(reduceAmount);
813             }
814             stakerPerEpochData[curEpoch][staker].stake = newStake;
815             // call KyberDao to reduce reward, if staker has delegated, then pass his representative
816             if (address(kyberDao) != address(0)) {
817                 // don't revert if KyberDao revert so data will be updated correctly
818                 (bool success, ) = address(kyberDao).call(
819                     abi.encodeWithSignature(
820                         "handleWithdrawal(address,uint256)",
821                         representative,
822                         reduceAmount
823                     )
824                 );
825                 if (!success) {
826                     emit WithdrawDataUpdateFailed(curEpoch, staker, amount);
827                 }
828             }
829         }
830         representative = stakerPerEpochData[curEpoch + 1][staker].representative;
831         if (representative != staker) {
832             initDataIfNeeded(representative, curEpoch);
833             stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
834                 stakerPerEpochData[curEpoch + 1][representative].delegatedStake.sub(amount);
835             stakerLatestData[representative].delegatedStake =
836                 stakerLatestData[representative].delegatedStake.sub(amount);
837         }
838     }
839 
840     /**
841      * @dev initialize data if it has not been initialized yet
842      * @param staker staker's address to initialize
843      * @param epoch should be current epoch
844      */
845     function initDataIfNeeded(address staker, uint256 epoch) internal {
846         address representative = stakerLatestData[staker].representative;
847         if (representative == address(0)) {
848             // not delegate to anyone, consider as delegate to yourself
849             stakerLatestData[staker].representative = staker;
850             representative = staker;
851         }
852 
853         uint256 ldStake = stakerLatestData[staker].delegatedStake;
854         uint256 lStakeBal = stakerLatestData[staker].stake;
855 
856         if (!hasInited[epoch][staker]) {
857             hasInited[epoch][staker] = true;
858             StakerData storage stakerData = stakerPerEpochData[epoch][staker];
859             stakerData.representative = representative;
860             stakerData.delegatedStake = ldStake;
861             stakerData.stake = lStakeBal;
862         }
863 
864         // whenever stakers deposit/withdraw/delegate, the current and next epoch data need to be updated
865         // as the result, we will also initialize data for staker at the next epoch
866         if (!hasInited[epoch + 1][staker]) {
867             hasInited[epoch + 1][staker] = true;
868             StakerData storage nextEpochStakerData = stakerPerEpochData[epoch + 1][staker];
869             nextEpochStakerData.representative = representative;
870             nextEpochStakerData.delegatedStake = ldStake;
871             nextEpochStakerData.stake = lStakeBal;
872         }
873     }
874 }
875 
876 // File: contracts/sol6/utils/Utils5.sol
877 
878 pragma solidity 0.6.6;
879 
880 
881 
882 /**
883  * @title Kyber utility file
884  * mostly shared constants and rate calculation helpers
885  * inherited by most of kyber contracts.
886  * previous utils implementations are for previous solidity versions.
887  */
888 contract Utils5 {
889     IERC20 internal constant ETH_TOKEN_ADDRESS = IERC20(
890         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
891     );
892     uint256 internal constant PRECISION = (10**18);
893     uint256 internal constant MAX_QTY = (10**28); // 10B tokens
894     uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
895     uint256 internal constant MAX_DECIMALS = 18;
896     uint256 internal constant ETH_DECIMALS = 18;
897     uint256 constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
898     uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite
899 
900     mapping(IERC20 => uint256) internal decimals;
901 
902     function getUpdateDecimals(IERC20 token) internal returns (uint256) {
903         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
904         uint256 tokenDecimals = decimals[token];
905         // moreover, very possible that old tokens have decimals 0
906         // these tokens will just have higher gas fees.
907         if (tokenDecimals == 0) {
908             tokenDecimals = token.decimals();
909             decimals[token] = tokenDecimals;
910         }
911 
912         return tokenDecimals;
913     }
914 
915     function setDecimals(IERC20 token) internal {
916         if (decimals[token] != 0) return; //already set
917 
918         if (token == ETH_TOKEN_ADDRESS) {
919             decimals[token] = ETH_DECIMALS;
920         } else {
921             decimals[token] = token.decimals();
922         }
923     }
924 
925     /// @dev get the balance of a user.
926     /// @param token The token type
927     /// @return The balance
928     function getBalance(IERC20 token, address user) internal view returns (uint256) {
929         if (token == ETH_TOKEN_ADDRESS) {
930             return user.balance;
931         } else {
932             return token.balanceOf(user);
933         }
934     }
935 
936     function getDecimals(IERC20 token) internal view returns (uint256) {
937         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
938         uint256 tokenDecimals = decimals[token];
939         // moreover, very possible that old tokens have decimals 0
940         // these tokens will just have higher gas fees.
941         if (tokenDecimals == 0) return token.decimals();
942 
943         return tokenDecimals;
944     }
945 
946     function calcDestAmount(
947         IERC20 src,
948         IERC20 dest,
949         uint256 srcAmount,
950         uint256 rate
951     ) internal view returns (uint256) {
952         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
953     }
954 
955     function calcSrcAmount(
956         IERC20 src,
957         IERC20 dest,
958         uint256 destAmount,
959         uint256 rate
960     ) internal view returns (uint256) {
961         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
962     }
963 
964     function calcDstQty(
965         uint256 srcQty,
966         uint256 srcDecimals,
967         uint256 dstDecimals,
968         uint256 rate
969     ) internal pure returns (uint256) {
970         require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
971         require(rate <= MAX_RATE, "rate > MAX_RATE");
972 
973         if (dstDecimals >= srcDecimals) {
974             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
975             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
976         } else {
977             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
978             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
979         }
980     }
981 
982     function calcSrcQty(
983         uint256 dstQty,
984         uint256 srcDecimals,
985         uint256 dstDecimals,
986         uint256 rate
987     ) internal pure returns (uint256) {
988         require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
989         require(rate <= MAX_RATE, "rate > MAX_RATE");
990 
991         //source quantity is rounded up. to avoid dest quantity being too low.
992         uint256 numerator;
993         uint256 denominator;
994         if (srcDecimals >= dstDecimals) {
995             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
996             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
997             denominator = rate;
998         } else {
999             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
1000             numerator = (PRECISION * dstQty);
1001             denominator = (rate * (10**(dstDecimals - srcDecimals)));
1002         }
1003         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
1004     }
1005 
1006     function calcRateFromQty(
1007         uint256 srcAmount,
1008         uint256 destAmount,
1009         uint256 srcDecimals,
1010         uint256 dstDecimals
1011     ) internal pure returns (uint256) {
1012         require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
1013         require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");
1014 
1015         if (dstDecimals >= srcDecimals) {
1016             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
1017             return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
1018         } else {
1019             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
1020             return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
1021         }
1022     }
1023 
1024     function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
1025         return x > y ? y : x;
1026     }
1027 }
1028 
1029 // File: contracts/sol6/Dao/KyberDao.sol
1030 
1031 pragma solidity 0.6.6;
1032 
1033 
1034 
1035 
1036 
1037 
1038 
1039 
1040 /**
1041  * @notice  This contract is using SafeMath for uint, which is inherited from EpochUtils
1042             Some events are moved to interface, easier for public uses
1043  * @dev Network fee campaign: options are fee in bps
1044  *      BRR fee handler campaign: options are combined of rebate (left most 128 bits) + reward (right most 128 bits)
1045  *      General campaign: options are from 1 to num_options
1046  */
1047 contract KyberDao is IKyberDao, EpochUtils, ReentrancyGuard, Utils5, DaoOperator {
1048     // max number of campaigns for each epoch
1049     uint256 public   constant MAX_EPOCH_CAMPAIGNS = 10;
1050     // max number of options for each campaign
1051     uint256 public   constant MAX_CAMPAIGN_OPTIONS = 8;
1052     uint256 internal constant POWER_128 = 2**128;
1053 
1054     enum CampaignType {General, NetworkFee, FeeHandlerBRR}
1055 
1056     struct FormulaData {
1057         uint256 minPercentageInPrecision;
1058         uint256 cInPrecision;
1059         uint256 tInPrecision;
1060     }
1061 
1062     struct CampaignVoteData {
1063         uint256 totalVotes;
1064         uint256[] votePerOption;
1065     }
1066 
1067     struct Campaign {
1068         CampaignType campaignType;
1069         bool campaignExists;
1070         uint256 startTimestamp;
1071         uint256 endTimestamp;
1072         uint256 totalKNCSupply; // total KNC supply at the time campaign was created
1073         FormulaData formulaData; // formula params for concluding campaign result
1074         bytes link; // link to KIP, explaination of options, etc.
1075         uint256[] options; // data of options
1076         CampaignVoteData campaignVoteData; // campaign vote data: total votes + vote per option
1077     }
1078 
1079     struct BRRData {
1080         uint256 rewardInBps;
1081         uint256 rebateInBps;
1082     }
1083 
1084     uint256 public minCampaignDurationInSeconds = 4 days;
1085     IERC20 public immutable kncToken;
1086     IKyberStaking public immutable staking;
1087 
1088     // use to generate increasing campaign ID
1089     uint256 public numberCampaigns = 0;
1090     mapping(uint256 => Campaign) internal campaignData;
1091 
1092     // epochCampaigns[epoch]: list campaign IDs for an epoch (epoch => campaign IDs)
1093     mapping(uint256 => uint256[]) internal epochCampaigns;
1094     // totalEpochPoints[epoch]: total points for an epoch (epoch => total points)
1095     mapping(uint256 => uint256) internal totalEpochPoints;
1096     // numberVotes[staker][epoch]: number of campaigns that the staker has voted in an epoch
1097     mapping(address => mapping(uint256 => uint256)) public numberVotes;
1098     // stakerVotedOption[staker][campaignID]: staker's voted option ID for a campaign
1099     mapping(address => mapping(uint256 => uint256)) public stakerVotedOption;
1100 
1101     uint256 internal latestNetworkFeeResult;
1102     // epoch => campaignID for network fee campaigns
1103     mapping(uint256 => uint256) public networkFeeCampaigns;
1104     // latest BRR data (reward and rebate in bps)
1105     BRRData internal latestBrrData;
1106     // epoch => campaignID for brr campaigns
1107     mapping(uint256 => uint256) public brrCampaigns;
1108 
1109     event NewCampaignCreated(
1110         CampaignType campaignType,
1111         uint256 indexed campaignID,
1112         uint256 startTimestamp,
1113         uint256 endTimestamp,
1114         uint256 minPercentageInPrecision,
1115         uint256 cInPrecision,
1116         uint256 tInPrecision,
1117         uint256[] options,
1118         bytes link
1119     );
1120 
1121     event CancelledCampaign(uint256 indexed campaignID);
1122 
1123     constructor(
1124         uint256 _epochPeriod,
1125         uint256 _startTimestamp,
1126         IERC20 _knc,
1127         uint256 _defaultNetworkFeeBps,
1128         uint256 _defaultRewardBps,
1129         uint256 _defaultRebateBps,
1130         address _daoOperator
1131     ) public DaoOperator(_daoOperator) {
1132         require(_epochPeriod > 0, "ctor: epoch period is 0");
1133         require(_startTimestamp >= now, "ctor: start in the past");
1134         require(_knc != IERC20(0), "ctor: knc token 0");
1135         // in Network, maximum fee that can be taken from 1 tx is (platform fee + 2 * network fee)
1136         // so network fee should be less than 50%
1137         require(_defaultNetworkFeeBps < BPS / 2, "ctor: network fee high");
1138         require(_defaultRewardBps.add(_defaultRebateBps) <= BPS, "reward plus rebate high");
1139 
1140         epochPeriodInSeconds = _epochPeriod;
1141         firstEpochStartTimestamp = _startTimestamp;
1142         kncToken = _knc;
1143 
1144         latestNetworkFeeResult = _defaultNetworkFeeBps;
1145         latestBrrData = BRRData({
1146             rewardInBps: _defaultRewardBps,
1147             rebateInBps: _defaultRebateBps
1148         });
1149 
1150         // deploy staking contract 
1151         staking = new KyberStaking({
1152             _kncToken: _knc,
1153             _epochPeriod: _epochPeriod,
1154             _startTimestamp: _startTimestamp,
1155             _kyberDao: IKyberDao(this)
1156         });
1157     }
1158 
1159     modifier onlyStakingContract {
1160         require(msg.sender == address(staking), "only staking contract");
1161         _;
1162     }
1163 
1164     /**
1165      * @dev called by staking contract when staker wanted to withdraw
1166      * @param staker address of staker to reduce reward
1167      * @param reduceAmount amount voting power to be reduced for each campaign staker has voted at this epoch
1168      */
1169     function handleWithdrawal(address staker, uint256 reduceAmount) external override onlyStakingContract {
1170         // staking shouldn't call this func with reduce amount = 0
1171         if (reduceAmount == 0) {
1172             return;
1173         }
1174         uint256 curEpoch = getCurrentEpochNumber();
1175 
1176         uint256 numVotes = numberVotes[staker][curEpoch];
1177         // staker has not participated in any campaigns at the current epoch
1178         if (numVotes == 0) {
1179             return;
1180         }
1181 
1182         // update total points for current epoch
1183         totalEpochPoints[curEpoch] = totalEpochPoints[curEpoch].sub(numVotes.mul(reduceAmount));
1184 
1185         // update voted count for each campaign staker has voted
1186         uint256[] memory campaignIDs = epochCampaigns[curEpoch];
1187 
1188         for (uint256 i = 0; i < campaignIDs.length; i++) {
1189             uint256 campaignID = campaignIDs[i];
1190 
1191             uint256 votedOption = stakerVotedOption[staker][campaignID];
1192             if (votedOption == 0) {
1193                 continue;
1194             } // staker has not voted yet
1195 
1196             Campaign storage campaign = campaignData[campaignID];
1197             if (campaign.endTimestamp >= now) {
1198                 // the staker has voted for this campaign and the campaign has not ended yet
1199                 // reduce total votes and vote count of staker's voted option
1200                 campaign.campaignVoteData.totalVotes =
1201                     campaign.campaignVoteData.totalVotes.sub(reduceAmount);
1202                 campaign.campaignVoteData.votePerOption[votedOption - 1] =
1203                     campaign.campaignVoteData.votePerOption[votedOption - 1].sub(reduceAmount);
1204             }
1205         }
1206     }
1207 
1208     /**
1209      * @dev create new campaign, only called by daoOperator
1210      * @param campaignType type of campaign (General, NetworkFee, FeeHandlerBRR)
1211      * @param startTimestamp timestamp to start running the campaign
1212      * @param endTimestamp timestamp to end this campaign
1213      * @param minPercentageInPrecision min percentage (in precision) for formula to conclude campaign
1214      * @param cInPrecision c value (in precision) for formula to conclude campaign
1215      * @param tInPrecision t value (in precision) for formula to conclude campaign
1216      * @param options list values of options to vote for this campaign
1217      * @param link additional data for this campaign
1218      */
1219     function submitNewCampaign(
1220         CampaignType campaignType,
1221         uint256 startTimestamp,
1222         uint256 endTimestamp,
1223         uint256 minPercentageInPrecision,
1224         uint256 cInPrecision,
1225         uint256 tInPrecision,
1226         uint256[] calldata options,
1227         bytes calldata link
1228     ) external onlyDaoOperator returns (uint256 campaignID) {
1229         // campaign epoch could be different from current epoch
1230         // as we allow to create campaign of next epoch as well
1231         uint256 campaignEpoch = getEpochNumber(startTimestamp);
1232 
1233         validateCampaignParams(
1234             campaignType,
1235             startTimestamp,
1236             endTimestamp,
1237             minPercentageInPrecision,
1238             cInPrecision,
1239             tInPrecision,
1240             options
1241         );
1242 
1243         numberCampaigns = numberCampaigns.add(1);
1244         campaignID = numberCampaigns;
1245 
1246         // add campaignID into the list campaign IDs
1247         epochCampaigns[campaignEpoch].push(campaignID);
1248         // update network fee or fee handler brr campaigns
1249         if (campaignType == CampaignType.NetworkFee) {
1250             networkFeeCampaigns[campaignEpoch] = campaignID;
1251         } else if (campaignType == CampaignType.FeeHandlerBRR) {
1252             brrCampaigns[campaignEpoch] = campaignID;
1253         }
1254 
1255         FormulaData memory formulaData = FormulaData({
1256             minPercentageInPrecision: minPercentageInPrecision,
1257             cInPrecision: cInPrecision,
1258             tInPrecision: tInPrecision
1259         });
1260         CampaignVoteData memory campaignVoteData = CampaignVoteData({
1261             totalVotes: 0,
1262             votePerOption: new uint256[](options.length)
1263         });
1264 
1265         campaignData[campaignID] = Campaign({
1266             campaignExists: true,
1267             campaignType: campaignType,
1268             startTimestamp: startTimestamp,
1269             endTimestamp: endTimestamp,
1270             totalKNCSupply: kncToken.totalSupply(),
1271             link: link,
1272             formulaData: formulaData,
1273             options: options,
1274             campaignVoteData: campaignVoteData
1275         });
1276 
1277         emit NewCampaignCreated(
1278             campaignType,
1279             campaignID,
1280             startTimestamp,
1281             endTimestamp,
1282             minPercentageInPrecision,
1283             cInPrecision,
1284             tInPrecision,
1285             options,
1286             link
1287         );
1288     }
1289 
1290     /**
1291      * @dev  cancel a campaign with given id, called by daoOperator only
1292      *       only can cancel campaigns that have not started yet
1293      * @param campaignID id of the campaign to cancel
1294      */
1295     function cancelCampaign(uint256 campaignID) external onlyDaoOperator {
1296         Campaign storage campaign = campaignData[campaignID];
1297         require(campaign.campaignExists, "cancelCampaign: campaignID doesn't exist");
1298 
1299         require(campaign.startTimestamp > now, "cancelCampaign: campaign already started");
1300 
1301         uint256 epoch = getEpochNumber(campaign.startTimestamp);
1302 
1303         if (campaign.campaignType == CampaignType.NetworkFee) {
1304             delete networkFeeCampaigns[epoch];
1305         } else if (campaign.campaignType == CampaignType.FeeHandlerBRR) {
1306             delete brrCampaigns[epoch];
1307         }
1308 
1309         delete campaignData[campaignID];
1310 
1311         uint256[] storage campaignIDs = epochCampaigns[epoch];
1312         for (uint256 i = 0; i < campaignIDs.length; i++) {
1313             if (campaignIDs[i] == campaignID) {
1314                 // remove this campaign id out of list
1315                 campaignIDs[i] = campaignIDs[campaignIDs.length - 1];
1316                 campaignIDs.pop();
1317                 break;
1318             }
1319         }
1320 
1321         emit CancelledCampaign(campaignID);
1322     }
1323 
1324     /**
1325      * @dev  vote for an option of a campaign
1326      *       options are indexed from 1 to number of options
1327      * @param campaignID id of campaign to vote for
1328      * @param option id of options to vote for
1329      */
1330     function vote(uint256 campaignID, uint256 option) external override {
1331         validateVoteOption(campaignID, option);
1332         address staker = msg.sender;
1333 
1334         uint256 curEpoch = getCurrentEpochNumber();
1335         (uint256 stake, uint256 dStake, address representative) =
1336             staking.initAndReturnStakerDataForCurrentEpoch(staker);
1337 
1338         uint256 totalStake = representative == staker ? stake.add(dStake) : dStake;
1339         uint256 lastVotedOption = stakerVotedOption[staker][campaignID];
1340 
1341         CampaignVoteData storage voteData = campaignData[campaignID].campaignVoteData;
1342 
1343         if (lastVotedOption == 0) {
1344             // increase number campaigns that the staker has voted at the current epoch
1345             numberVotes[staker][curEpoch]++;
1346 
1347             totalEpochPoints[curEpoch] = totalEpochPoints[curEpoch].add(totalStake);
1348             // increase voted count for this option
1349             voteData.votePerOption[option - 1] =
1350                 voteData.votePerOption[option - 1].add(totalStake);
1351             // increase total votes
1352             voteData.totalVotes = voteData.totalVotes.add(totalStake);
1353         } else if (lastVotedOption != option) {
1354             // deduce previous option voted count
1355             voteData.votePerOption[lastVotedOption - 1] =
1356                 voteData.votePerOption[lastVotedOption - 1].sub(totalStake);
1357             // increase new option voted count
1358             voteData.votePerOption[option - 1] =
1359                 voteData.votePerOption[option - 1].add(totalStake);
1360         }
1361 
1362         stakerVotedOption[staker][campaignID] = option;
1363 
1364         emit Voted(staker, curEpoch, campaignID, option);
1365     }
1366 
1367     /**
1368      * @dev get latest network fee data + expiry timestamp
1369      *    conclude network fee campaign if needed and caching latest result in KyberDao
1370      */
1371     function getLatestNetworkFeeDataWithCache()
1372         external
1373         override
1374         returns (uint256 feeInBps, uint256 expiryTimestamp)
1375     {
1376         (feeInBps, expiryTimestamp) = getLatestNetworkFeeData();
1377         // cache latest data
1378         latestNetworkFeeResult = feeInBps;
1379     }
1380 
1381     /**
1382      * @dev return latest burn/reward/rebate data, also affecting epoch + expiry timestamp
1383      *      conclude brr campaign if needed and caching latest result in KyberDao
1384      */
1385     function getLatestBRRDataWithCache()
1386         external
1387         override
1388         returns (
1389             uint256 burnInBps,
1390             uint256 rewardInBps,
1391             uint256 rebateInBps,
1392             uint256 epoch,
1393             uint256 expiryTimestamp
1394         )
1395     {
1396         (burnInBps, rewardInBps, rebateInBps, epoch, expiryTimestamp) = getLatestBRRData();
1397         latestBrrData.rewardInBps = rewardInBps;
1398         latestBrrData.rebateInBps = rebateInBps;
1399     }
1400 
1401     /**
1402      * @dev some epochs have reward but no one can claim, for example: epoch 0
1403      *      return true if should burn all that reward
1404      * @param epoch epoch to check for burning reward
1405      */
1406     function shouldBurnRewardForEpoch(uint256 epoch) external view override returns (bool) {
1407         uint256 curEpoch = getCurrentEpochNumber();
1408         if (epoch >= curEpoch) {
1409             return false;
1410         }
1411         return totalEpochPoints[epoch] == 0;
1412     }
1413 
1414     // return list campaign ids for epoch, excluding non-existed ones
1415     function getListCampaignIDs(uint256 epoch) external view returns (uint256[] memory campaignIDs) {
1416         campaignIDs = epochCampaigns[epoch];
1417     }
1418 
1419     // return total points for an epoch
1420     function getTotalEpochPoints(uint256 epoch) external view returns (uint256) {
1421         return totalEpochPoints[epoch];
1422     }
1423 
1424     function getCampaignDetails(uint256 campaignID)
1425         external
1426         view
1427         returns (
1428             CampaignType campaignType,
1429             uint256 startTimestamp,
1430             uint256 endTimestamp,
1431             uint256 totalKNCSupply,
1432             uint256 minPercentageInPrecision,
1433             uint256 cInPrecision,
1434             uint256 tInPrecision,
1435             bytes memory link,
1436             uint256[] memory options
1437         )
1438     {
1439         Campaign storage campaign = campaignData[campaignID];
1440         campaignType = campaign.campaignType;
1441         startTimestamp = campaign.startTimestamp;
1442         endTimestamp = campaign.endTimestamp;
1443         totalKNCSupply = campaign.totalKNCSupply;
1444         minPercentageInPrecision = campaign.formulaData.minPercentageInPrecision;
1445         cInPrecision = campaign.formulaData.cInPrecision;
1446         tInPrecision = campaign.formulaData.tInPrecision;
1447         link = campaign.link;
1448         options = campaign.options;
1449     }
1450 
1451     function getCampaignVoteCountData(uint256 campaignID)
1452         external
1453         view
1454         returns (uint256[] memory voteCounts, uint256 totalVoteCount)
1455     {
1456         CampaignVoteData memory voteData = campaignData[campaignID].campaignVoteData;
1457         totalVoteCount = voteData.totalVotes;
1458         voteCounts = voteData.votePerOption;
1459     }
1460 
1461     /**
1462      * @dev  return staker's reward percentage in precision for a past epoch only
1463      *       fee handler should call this function when a staker wants to claim reward
1464      *       return 0 if staker has no votes or stakes
1465      */
1466     function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
1467         external
1468         view
1469         override
1470         returns (uint256)
1471     {
1472         // return 0 if epoch is not past epoch
1473         uint256 curEpoch = getCurrentEpochNumber();
1474         if (epoch >= curEpoch) {
1475             return 0;
1476         }
1477 
1478         return getRewardPercentageInPrecision(staker, epoch);
1479     }
1480 
1481     /**
1482      * @dev  return staker's reward percentage in precision for the current epoch
1483      */
1484     function getCurrentEpochRewardPercentageInPrecision(address staker)
1485         external
1486         view
1487         override
1488         returns (uint256)
1489     {
1490         uint256 curEpoch = getCurrentEpochNumber();
1491         return getRewardPercentageInPrecision(staker, curEpoch);
1492     }
1493 
1494     /**
1495      * @dev return campaign winning option and its value
1496      *      return (0, 0) if campaign does not exist
1497      *      return (0, 0) if campaign has not ended yet
1498      *      return (0, 0) if campaign has no winning option based on the formula
1499      * @param campaignID id of campaign to get result
1500      */
1501     function getCampaignWinningOptionAndValue(uint256 campaignID)
1502         public
1503         view
1504         returns (uint256 optionID, uint256 value)
1505     {
1506         Campaign storage campaign = campaignData[campaignID];
1507         if (!campaign.campaignExists) {
1508             return (0, 0);
1509         } // not exist
1510 
1511         // campaign has not ended yet, return 0 as winning option
1512         if (campaign.endTimestamp > now) {
1513             return (0, 0);
1514         }
1515 
1516         uint256 totalSupply = campaign.totalKNCSupply;
1517         // something is wrong here, total KNC supply shouldn't be 0
1518         if (totalSupply == 0) {
1519             return (0, 0);
1520         }
1521 
1522         uint256 totalVotes = campaign.campaignVoteData.totalVotes;
1523         uint256[] memory voteCounts = campaign.campaignVoteData.votePerOption;
1524 
1525         // Finding option with most votes
1526         uint256 winningOption = 0;
1527         uint256 maxVotedCount = 0;
1528         for (uint256 i = 0; i < voteCounts.length; i++) {
1529             if (voteCounts[i] > maxVotedCount) {
1530                 winningOption = i + 1;
1531                 maxVotedCount = voteCounts[i];
1532             } else if (voteCounts[i] == maxVotedCount) {
1533                 winningOption = 0;
1534             }
1535         }
1536 
1537         // more than 1 options have same vote count
1538         if (winningOption == 0) {
1539             return (0, 0);
1540         }
1541 
1542         FormulaData memory formulaData = campaign.formulaData;
1543 
1544         // compute voted percentage (in precision)
1545         uint256 votedPercentage = totalVotes.mul(PRECISION).div(campaign.totalKNCSupply);
1546 
1547         // total voted percentage is below min acceptable percentage, no winning option
1548         if (formulaData.minPercentageInPrecision > votedPercentage) {
1549             return (0, 0);
1550         }
1551 
1552         // as we already limit value for c & t, no need to check for overflow here
1553         uint256 x = formulaData.tInPrecision.mul(votedPercentage).div(PRECISION);
1554         if (x <= formulaData.cInPrecision) {
1555             // threshold is not negative, need to compare with voted count
1556             uint256 y = formulaData.cInPrecision.sub(x);
1557             // (most voted option count / total votes) is below threshold, no winining option
1558             if (maxVotedCount.mul(PRECISION) < y.mul(totalVotes)) {
1559                 return (0, 0);
1560             }
1561         }
1562 
1563         optionID = winningOption;
1564         value = campaign.options[optionID - 1];
1565     }
1566 
1567     /**
1568      * @dev return latest network fee and expiry timestamp
1569      */
1570     function getLatestNetworkFeeData()
1571         public
1572         view
1573         override
1574         returns (uint256 feeInBps, uint256 expiryTimestamp)
1575     {
1576         uint256 curEpoch = getCurrentEpochNumber();
1577         feeInBps = latestNetworkFeeResult;
1578         // expiryTimestamp = firstEpochStartTimestamp + curEpoch * epochPeriodInSeconds - 1;
1579         expiryTimestamp = firstEpochStartTimestamp.add(curEpoch.mul(epochPeriodInSeconds)).sub(1);
1580         if (curEpoch == 0) {
1581             return (feeInBps, expiryTimestamp);
1582         }
1583         uint256 campaignID = networkFeeCampaigns[curEpoch.sub(1)];
1584         if (campaignID == 0) {
1585             // don't have network fee campaign, return latest result
1586             return (feeInBps, expiryTimestamp);
1587         }
1588 
1589         uint256 winningOption;
1590         (winningOption, feeInBps) = getCampaignWinningOptionAndValue(campaignID);
1591         if (winningOption == 0) {
1592             // fallback to previous result
1593             feeInBps = latestNetworkFeeResult;
1594         }
1595         return (feeInBps, expiryTimestamp);
1596     }
1597 
1598     /**
1599      * @dev return latest brr result, conclude brr campaign if needed
1600      */
1601     function getLatestBRRData()
1602         public
1603         view
1604         returns (
1605             uint256 burnInBps,
1606             uint256 rewardInBps,
1607             uint256 rebateInBps,
1608             uint256 epoch,
1609             uint256 expiryTimestamp
1610         )
1611     {
1612         epoch = getCurrentEpochNumber();
1613         // expiryTimestamp = firstEpochStartTimestamp + epoch * epochPeriodInSeconds - 1;
1614         expiryTimestamp = firstEpochStartTimestamp.add(epoch.mul(epochPeriodInSeconds)).sub(1);
1615         rewardInBps = latestBrrData.rewardInBps;
1616         rebateInBps = latestBrrData.rebateInBps;
1617 
1618         if (epoch > 0) {
1619             uint256 campaignID = brrCampaigns[epoch.sub(1)];
1620             if (campaignID != 0) {
1621                 uint256 winningOption;
1622                 uint256 brrData;
1623                 (winningOption, brrData) = getCampaignWinningOptionAndValue(campaignID);
1624                 if (winningOption > 0) {
1625                     // has winning option, update reward and rebate value
1626                     (rebateInBps, rewardInBps) = getRebateAndRewardFromData(brrData);
1627                 }
1628             }
1629         }
1630 
1631         burnInBps = BPS.sub(rebateInBps).sub(rewardInBps);
1632     }
1633 
1634     // Helper functions for squeezing data
1635     function getRebateAndRewardFromData(uint256 data)
1636         public
1637         pure
1638         returns (uint256 rebateInBps, uint256 rewardInBps)
1639     {
1640         rewardInBps = data & (POWER_128.sub(1));
1641         rebateInBps = (data.div(POWER_128)) & (POWER_128.sub(1));
1642     }
1643 
1644     /**
1645      * @dev  helper func to get encoded reward and rebate
1646      *       revert if validation failed
1647      */
1648     function getDataFromRewardAndRebateWithValidation(uint256 rewardInBps, uint256 rebateInBps)
1649         public
1650         pure
1651         returns (uint256 data)
1652     {
1653         require(rewardInBps.add(rebateInBps) <= BPS, "reward plus rebate high");
1654         data = (rebateInBps.mul(POWER_128)).add(rewardInBps);
1655     }
1656 
1657     /**
1658      * @dev options are indexed from 1
1659      */
1660     function validateVoteOption(uint256 campaignID, uint256 option) internal view {
1661         Campaign storage campaign = campaignData[campaignID];
1662         require(campaign.campaignExists, "vote: campaign doesn't exist");
1663 
1664         require(campaign.startTimestamp <= now, "vote: campaign not started");
1665         require(campaign.endTimestamp >= now, "vote: campaign already ended");
1666 
1667         // option is indexed from 1 to options.length
1668         require(option > 0, "vote: option is 0");
1669         require(option <= campaign.options.length, "vote: option is not in range");
1670     }
1671 
1672     /**
1673      * @dev Validate params to check if we could submit a new campaign with these params
1674      */
1675     function validateCampaignParams(
1676         CampaignType campaignType,
1677         uint256 startTimestamp,
1678         uint256 endTimestamp,
1679         uint256 minPercentageInPrecision,
1680         uint256 cInPrecision,
1681         uint256 tInPrecision,
1682         uint256[] memory options
1683     ) internal view {
1684         // now <= start timestamp < end timestamp
1685         require(startTimestamp >= now, "validateParams: start in the past");
1686         // campaign duration must be at least min campaign duration
1687         // endTimestamp - startTimestamp + 1 >= minCampaignDurationInSeconds,
1688         require(
1689             endTimestamp.add(1) >= startTimestamp.add(minCampaignDurationInSeconds),
1690             "validateParams: campaign duration is low"
1691         );
1692 
1693         uint256 startEpoch = getEpochNumber(startTimestamp);
1694         uint256 endEpoch = getEpochNumber(endTimestamp);
1695 
1696         require(
1697             epochCampaigns[startEpoch].length < MAX_EPOCH_CAMPAIGNS,
1698             "validateParams: too many campaigns"
1699         );
1700 
1701         // start timestamp and end timestamp must be in the same epoch
1702         require(startEpoch == endEpoch, "validateParams: start & end not same epoch");
1703 
1704         uint256 currentEpoch = getCurrentEpochNumber();
1705         require(
1706             startEpoch <= currentEpoch.add(1),
1707             "validateParams: only for current or next epochs"
1708         );
1709 
1710         // verify number of options
1711         uint256 numOptions = options.length;
1712         require(
1713             numOptions > 1 && numOptions <= MAX_CAMPAIGN_OPTIONS,
1714             "validateParams: invalid number of options"
1715         );
1716 
1717         // Validate option values based on campaign type
1718         if (campaignType == CampaignType.General) {
1719             // option must be positive number
1720             for (uint256 i = 0; i < options.length; i++) {
1721                 require(options[i] > 0, "validateParams: general campaign option is 0");
1722             }
1723         } else if (campaignType == CampaignType.NetworkFee) {
1724             require(
1725                 networkFeeCampaigns[startEpoch] == 0,
1726                 "validateParams: already had network fee campaign for this epoch"
1727             );
1728             // network fee campaign, option must be fee in bps
1729             for (uint256 i = 0; i < options.length; i++) {
1730                 // in Network, maximum fee that can be taken from 1 tx is (platform fee + 2 * network fee)
1731                 // so network fee should be less than 50%
1732                 require(
1733                     options[i] < BPS / 2,
1734                     "validateParams: network fee must be smaller then BPS / 2"
1735                 );
1736             }
1737         } else {
1738             require(
1739                 brrCampaigns[startEpoch] == 0,
1740                 "validateParams: already had brr campaign for this epoch"
1741             );
1742             // brr fee handler campaign, option must be combined for reward + rebate %
1743             for (uint256 i = 0; i < options.length; i++) {
1744                 // rebate (left most 128 bits) + reward (right most 128 bits)
1745                 (uint256 rebateInBps, uint256 rewardInBps) =
1746                     getRebateAndRewardFromData(options[i]);
1747                 require(
1748                     rewardInBps.add(rebateInBps) <= BPS,
1749                     "validateParams: rebate + reward can't be bigger than BPS"
1750                 );
1751             }
1752         }
1753 
1754         // percentage should be smaller than or equal 100%
1755         require(minPercentageInPrecision <= PRECISION, "validateParams: min percentage is high");
1756 
1757         // limit value of c and t to avoid overflow
1758         require(cInPrecision < POWER_128, "validateParams: c is high");
1759 
1760         require(tInPrecision < POWER_128, "validateParams: t is high");
1761     }
1762 
1763     /**
1764      * @dev  return staker's reward percentage in precision for an epoch
1765      *       return 0 if staker has no votes or stakes
1766      *       called by 2 functions in KyberDao
1767      */
1768     function getRewardPercentageInPrecision(address staker, uint256 epoch)
1769         internal
1770         view
1771         returns (uint256)
1772     {
1773         uint256 numVotes = numberVotes[staker][epoch];
1774         // no votes, no rewards
1775         if (numVotes == 0) {
1776             return 0;
1777         }
1778 
1779         (uint256 stake, uint256 delegatedStake, address representative) =
1780             staking.getStakerRawData(staker, epoch);
1781 
1782         uint256 totalStake = representative == staker ? stake.add(delegatedStake) : delegatedStake;
1783         if (totalStake == 0) {
1784             return 0;
1785         }
1786 
1787         uint256 points = numVotes.mul(totalStake);
1788         uint256 totalPts = totalEpochPoints[epoch];
1789 
1790         // staker's reward percentage should be <= 100%
1791         assert(points <= totalPts);
1792 
1793         return points.mul(PRECISION).div(totalPts);
1794     }
1795 }