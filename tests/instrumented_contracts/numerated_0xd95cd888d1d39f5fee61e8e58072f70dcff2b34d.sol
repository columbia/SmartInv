1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: MIT
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 /*
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with GSN meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address payable) {
160         return msg.sender;
161     }
162 
163     function _msgData() internal view virtual returns (bytes memory) {
164         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
165         return msg.data;
166     }
167 }
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor () internal {
191         address msgSender = _msgSender();
192         _owner = msgSender;
193         emit OwnershipTransferred(address(0), msgSender);
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(_owner == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         emit OwnershipTransferred(_owner, address(0));
220         _owner = address(0);
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(newOwner != address(0), "Ownable: new owner is the zero address");
229         emit OwnershipTransferred(_owner, newOwner);
230         _owner = newOwner;
231     }
232 }
233 
234 interface StandardToken {
235     function transfer(address recipient, uint256 amount) external returns (bool);
236     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
237     function balanceOf(address account) external view returns (uint256);
238 }
239 
240 interface IController {
241     function withdrawETH(uint256 amount) external;
242     function depositForStrategy(uint256 amount, address addr) external;
243     function buyForStrategy(
244         uint256 amount,
245         address rewardToken,
246         address recipient
247     ) external;
248 
249     function sendExitToken(
250         address user,
251         uint256 amount
252     ) external;
253 
254     function getStrategy(address vault) external view returns (address);
255 }
256 
257 interface IStrategy {
258     function getNextEpochTime() external view returns(uint256);
259 }
260 
261 interface StakeAndYieldV1 {
262     function users(address user) external view returns (
263         uint256 balance,
264         uint256 stakeType,
265         uint256 paidReward,
266         uint256 yieldPaidReward,
267         uint256 paidRewardPerToken,
268         uint256 yieldPaidRewardPerToken,
269         uint256 withdrawable,
270         uint256 withdrawableExit,
271         uint256 withdrawTime,
272         bool exit,
273         uint256 exitStartTime,
274         uint256 exitAmountTillNow,
275         uint256 lastClaimTime
276     );
277 
278     function userInfo(address account) external view returns(
279         uint256[15] memory numbers,
280 
281         address rewardTokenAddress,
282         address stakedTokenAddress,
283         address controllerAddress,
284         address strategyAddress,
285         bool exit
286     );
287 }
288 
289 contract StakeAndYieldV2 is Ownable {
290     uint256 constant STAKE = 1;
291     uint256 constant YIELD = 2;
292     uint256 constant BOTH = 3;
293 
294     uint256 public PERIOD = 7 days;
295 
296     uint256 public EPOCH_PERIOD = 24 hours;
297 
298     uint256 public EXIT_PERIOD = 75 days;
299 
300     uint256 public lastUpdateTime;
301     uint256 public rewardRate;
302     uint256 public rewardRateYield;
303 
304     uint256 public rewardTillNowPerToken = 0;
305     uint256 public yieldRewardTillNowPerToken = 0;
306 
307     uint256 public _totalSupply = 27107222074668847534350;
308     uint256 public _totalSupplyYield = 24018522600167288546949;
309 
310     uint256 public _totalYieldWithdrawed = 7614108146077065784600;
311     uint256 public _totalExit = 0;
312 
313     // false: withdraw from YEARN and then pay the user
314     // true: pay the user before withdrawing from YEARN
315     bool public allowEmergencyWithdraw = false;
316 
317     uint256 public exitRewardDenominator = 2;
318 
319     IController public controller;
320 
321     address public operator;
322 
323     struct User {
324         uint256 balance;
325         uint256 stakeType;
326 
327         uint256 paidReward;
328         uint256 yieldPaidReward;
329 
330         uint256 paidRewardPerToken;
331         uint256 yieldPaidRewardPerToken;
332 
333         uint256 withdrawable;
334         uint256 withdrawableExit;
335         uint256 withdrawTime;
336 
337         bool exit;
338 
339         uint256 exitStartTime;
340         uint256 exitAmountTillNow;
341 
342         uint256 lastClaimTime;
343     }
344 
345     mapping (address => uint256) pendingEarneds;
346     mapping (address => uint256) pendingEarnedYields;
347 
348     using SafeMath for uint256;
349 
350     mapping (address => User) public users;
351 
352     uint256 public lastUpdatedBlock;
353 
354     uint256 public periodFinish = 1621529382;
355 
356     uint256 public birthDate;
357 
358     uint256 public daoShare;
359     address public daoWallet;
360 
361     bool public exitable;
362 
363     StandardToken public stakedToken;
364     StandardToken public rewardToken;
365     StandardToken public yieldRewardToken;
366 
367     address public oldContract;
368 
369     uint256 public totalExitRewards;
370     uint256 public totalExitRewardsYield;
371 
372     event Deposit(address user, uint256 amount, uint256 stakeType);
373     event Withdraw(address user, uint256 amount, uint256 stakeType);
374     event Exit(address user, uint256 amount, uint256 stakeType);
375     event Unfreeze(address user, uint256 amount, uint256 stakeType);
376     event EmergencyWithdraw(address user, uint256 amount);
377     event RewardClaimed(address user, uint256 amount, uint256 yieldAmount);
378 
379     //event Int(uint256 i);
380 
381     constructor (
382         address _stakedToken,
383         address _rewardToken,
384         address _yieldRewardToken,
385         uint256 _daoShare,
386         address _daoWallet,
387         address _controller,
388         bool _exitable,
389         address _oldContract
390     ) public {
391         stakedToken = StandardToken(_stakedToken);
392         rewardToken = StandardToken(_rewardToken);
393         yieldRewardToken = StandardToken(_yieldRewardToken);
394         controller = IController(_controller);
395         daoShare = _daoShare;
396         daoWallet = _daoWallet;
397         exitable = _exitable;
398 
399         operator = msg.sender;
400         oldContract = _oldContract;
401         birthDate = now;
402     }
403 
404     modifier onlyOwnerOrController(){
405         require(msg.sender == owner() ||
406             msg.sender == address(controller) ||
407             msg.sender == operator,
408             "!ownerOrController"
409         );
410         _;
411     }
412 
413     // imports the user from old contract if
414     // its not imported yet
415     modifier importUser(address account){
416         if(oldContract != address(0)){
417             if(users[account].stakeType==0){
418                 uint256 oldStakeType;
419                 bool oldExit;
420                 uint256[] memory ints = new uint256[](3);
421                 (
422                     ,
423                     oldStakeType,
424                     ,,,,,,ints[2],oldExit,ints[0],,ints[1]
425                 ) = StakeAndYieldV1(oldContract).users(account);
426                 if(oldStakeType > 0){
427                     //lastClaimTime should be < birthdate of new contract
428                     require(ints[1] <= birthDate, "lastClaimTime > birthDate");
429                     users[account].exit = oldExit;
430                     users[account].exitStartTime = ints[0];
431                     users[account].lastClaimTime = ints[1];
432                     users[account].withdrawTime = ints[2];
433                     loadOldUser(account);
434                 }
435             }
436         }
437         _;
438     }
439 
440     modifier updateReward(address account, uint256 stakeType) {
441         
442         if(users[account].balance > 0 || users[account].withdrawable > 0
443             || users[account].withdrawableExit > 0
444         ){
445             stakeType = users[account].stakeType;
446         }
447         
448         if (account != address(0)) {
449             uint256 stakeEarned;
450             uint256 stakeSubtract;
451 
452             (stakeEarned, stakeSubtract) = earned(account, STAKE);
453 
454             uint256 yieldEarned;
455             uint256 yieldSubtract;
456 
457             (yieldEarned, yieldSubtract) = earned(account, YIELD);
458 
459             // sendReward(
460             //     account,
461             //     stakeEarned, stakeSubtract,
462             //     yieldEarned, yieldSubtract
463             // );
464 
465             if(yieldEarned > 0){
466                 pendingEarnedYields[account] = yieldEarned;
467                 totalExitRewardsYield += yieldSubtract;
468             }
469             if(stakeEarned > 0){
470                 pendingEarneds[account] = stakeEarned;
471                 totalExitRewards += stakeSubtract;
472             }
473         }
474         
475         rewardTillNowPerToken = rewardPerToken(STAKE);
476         yieldRewardTillNowPerToken = rewardPerToken(YIELD);
477         lastUpdateTime = lastTimeRewardApplicable();
478         if (account != address(0)) {
479             users[account].paidRewardPerToken = rewardTillNowPerToken;
480             users[account].yieldPaidRewardPerToken = yieldRewardTillNowPerToken;
481         }
482         _;
483     }
484 
485     function loadOldUser(address account) private{
486             (
487                 users[account].balance,
488                 users[account].stakeType,
489                 , //paidReward,
490                 users[account].yieldPaidReward,
491                 ,//paidRewardPerToken,
492                 users[account].yieldPaidRewardPerToken,
493                 users[account].withdrawable,
494                 ,//withdrawableExit,
495                 ,//withdrawTime,
496                 ,//exit,
497                 ,//exitStartTime,
498                 ,//exitAmountTillNow,
499                 //lastClaimTime
500             ) = StakeAndYieldV1(oldContract).users(account);
501     }
502 
503     function setDaoWallet(address _daoWallet) public onlyOwner {
504         daoWallet = _daoWallet;
505     }
506 
507     function setDaoShare(uint256 _daoShare) public onlyOwner {
508         daoShare = _daoShare;
509     }
510 
511     function setExitPeriod(uint256 period) public onlyOwner {
512         EXIT_PERIOD = period;
513     }
514 
515     function setOperator(address _addr) public onlyOwner{
516         operator = _addr;
517     }
518 
519     function setPeriods(uint256 period, uint256 epochPeriod, uint256 _birthDate) public onlyOwner{
520         PERIOD = period;
521         EPOCH_PERIOD = epochPeriod;
522         birthDate = _birthDate;
523     }
524 
525     function setRewardInfo(
526         uint256 _lastUpdateTime,
527         uint256 _rewardRate,
528         uint256 _rewardRateYield,
529 
530         uint256 _rewardTillNowPerToken,
531         uint256 _yieldRewardTillNowPerToken
532     ) public onlyOwner{
533         lastUpdateTime = _lastUpdateTime;
534         rewardRate = _rewardRate;
535         rewardRateYield = _rewardRateYield;
536 
537         rewardTillNowPerToken = _rewardTillNowPerToken;
538         yieldRewardTillNowPerToken = _yieldRewardTillNowPerToken;
539     }
540 
541     function withdrawToBurn() public onlyOwner{
542         stakedToken.transfer(
543             msg.sender,
544             _totalExit
545         );
546         _totalExit = 0;
547     }
548 
549     function earned(address account, uint256 stakeType) public view returns(uint256, uint256) {
550         User storage user = users[account];
551 
552         uint256 paidPerToken = stakeType == STAKE ? 
553             user.paidRewardPerToken : user.yieldPaidRewardPerToken;
554 
555         uint256 amount = balanceOf(account, stakeType).mul(
556             rewardPerToken(stakeType).
557             sub(paidPerToken)
558         ).div(1e18);
559 
560         uint256 substract = 0;
561         if(user.exit){
562             uint256 startDate = user.exitStartTime;
563             if(user.lastClaimTime > startDate){
564                 startDate = user.lastClaimTime;
565             }
566             uint256 daysIn = (block.timestamp - startDate) / 1 days;
567             uint256 exitPeriodDays = EXIT_PERIOD/1 days;
568             if(daysIn > exitPeriodDays){
569                 daysIn = exitPeriodDays;
570             }
571             substract = daysIn.mul(amount).div(exitPeriodDays).div(
572                 exitRewardDenominator
573             );
574         }
575         uint256 pending = stakeType == STAKE ? 
576             pendingEarneds[account] : pendingEarnedYields[account];
577         return (amount.sub(substract) + pending, substract);
578     }
579 
580     function earned(address account) public view returns(uint256){
581         uint256 stakeEarned;
582         uint256 yieldEarned;
583         uint256 tmp;
584         (stakeEarned, tmp) = earned(account, STAKE);
585         (yieldEarned, tmp) = earned(account, YIELD);
586 
587         return stakeEarned + yieldEarned;
588     }
589 
590     function deposit(uint256 amount, uint256 stakeType, bool _exit) public {
591         depositFor(msg.sender, amount, stakeType, _exit);
592     }
593 
594     function depositFor(address _user, uint256 amount, uint256 stakeType, bool _exit)
595         
596         importUser(_user)
597 
598         updateReward(_user, stakeType)
599         public {
600         
601         require(stakeType==STAKE || stakeType ==YIELD || stakeType==BOTH, "Invalid stakeType");
602  
603         User storage user = users[_user];
604         require((user.balance == 0 && user.withdrawable==0 && user.withdrawableExit == 0)|| user.stakeType==stakeType, "Invalid Stake Type");
605 
606         if(user.exit || (user.balance == 0 && _exit)){
607             updateExit(_user);
608         }else if(user.balance == 0 && !_exit){
609             user.exit = false;
610         }
611 
612         stakedToken.transferFrom(address(msg.sender), address(this), amount);
613 
614         user.stakeType = stakeType;
615         user.balance = user.balance.add(amount);
616 
617         if(stakeType == STAKE){
618             _totalSupply = _totalSupply.add(amount);
619         }else if(stakeType == YIELD){
620             _totalSupplyYield = _totalSupplyYield.add(amount);
621         }else{
622             _totalSupplyYield = _totalSupplyYield.add(amount);
623             _totalSupply = _totalSupply.add(amount);
624         }
625         
626         emit Deposit(_user, amount, stakeType);
627     }
628 
629     function updateExit(address _user) private{
630         require(exitable, "Not exitable");
631         User storage user = users[_user];
632         user.exit = true;
633         user.exitAmountTillNow = exitBalance(_user);
634         user.exitStartTime = block.timestamp;
635     }
636 
637     function sendReward(address userAddress, 
638         uint256 stakeEarned, uint256 stakeSubtract, 
639         uint256 yieldEarned, uint256 yieldSubtract
640     ) private {
641         User storage user = users[userAddress];
642         uint256 _daoShare = stakeEarned.mul(daoShare).div(1 ether);
643         uint256 _yieldDaoShare = yieldEarned.mul(daoShare).div(1 ether);
644 
645         if(stakeEarned > 0){
646             rewardToken.transfer(userAddress, stakeEarned.sub(_daoShare));
647             if(_daoShare > 0)
648                 rewardToken.transfer(daoWallet, _daoShare);
649             user.paidReward = user.paidReward.add(
650                 stakeEarned
651             );
652         }
653 
654         if(yieldEarned > 0){
655             yieldRewardToken.transfer(userAddress, yieldEarned.sub(_yieldDaoShare));
656             
657             if(_yieldDaoShare > 0)
658                 yieldRewardToken.transfer(daoWallet, _yieldDaoShare);   
659             
660             user.yieldPaidReward = user.yieldPaidReward.add(
661                 yieldEarned
662             );
663         }
664         
665         if(yieldEarned > 0 || stakeEarned > 0){
666             emit RewardClaimed(userAddress, stakeEarned, yieldEarned);
667         }
668 
669         if(stakeSubtract > 0){
670             //notifyRewardAmountInternal(stakeSubtract, STAKE);
671             totalExitRewards += stakeSubtract;
672         }
673         if(yieldSubtract > 0){
674             //notifyRewardAmountInternal(yieldSubtract, YIELD);
675             totalExitRewardsYield += yieldSubtract;
676         }
677         user.lastClaimTime = block.timestamp;
678         pendingEarneds[userAddress] = 0;
679         pendingEarnedYields[userAddress] = 0;
680     }
681 
682     function sendExitToken(address _user, uint256 amount) private {
683         controller.sendExitToken(
684             _user,
685             amount
686         );
687     }
688 
689     function claim() 
690         importUser(msg.sender)
691         updateReward(msg.sender, 0) public {
692         
693         claimInternal();
694     }
695 
696     function claimInternal() private{
697         uint256 stakeEarned;
698         uint256 stakeSubtract;
699 
700         (stakeEarned, stakeSubtract) = earned(msg.sender, STAKE);
701 
702         uint256 yieldEarned;
703         uint256 yieldSubtract;
704 
705         (yieldEarned, yieldSubtract) = earned(msg.sender, YIELD);
706 
707         sendReward(
708             msg.sender,
709             stakeEarned, stakeSubtract,
710             yieldEarned, yieldSubtract
711         );
712     }
713 
714     function setExit(bool _val) 
715         importUser(msg.sender) 
716         updateReward(msg.sender, 0) public{
717         
718         User storage user = users[msg.sender];
719         require(user.exit != _val, "same exit status");
720         require(user.balance > 0, "0 balance");
721 
722         user.exit = _val;
723         user.exitStartTime = now;
724         user.exitAmountTillNow = 0;
725     }
726 
727     function unfreezeAllAndClaim() public{
728         unfreeze(users[msg.sender].balance);
729         claimInternal();
730     }
731 
732     function unfreeze(uint256 amount) 
733         importUser(msg.sender) 
734         updateReward(msg.sender, 0) public {
735         User storage user = users[msg.sender];
736         uint256 stakeType = user.stakeType;
737 
738         require(
739             user.balance >= amount,
740             "withdraw > deposit");
741 
742         if (amount > 0) {
743             uint256 exitAmount = exitBalance(msg.sender);
744             uint256 remainingExit = 0;
745             if(exitAmount > amount){
746                 remainingExit = exitAmount.sub(amount);
747                 exitAmount = amount;
748             }
749 
750             if(user.exit){
751                 user.exitAmountTillNow = remainingExit;
752                 user.exitStartTime = now;
753             }
754 
755             uint256 tokenAmount = amount.sub(exitAmount);
756             user.balance = user.balance.sub(amount);
757             if(stakeType == STAKE){
758                 _totalSupply = _totalSupply.sub(amount);
759             }else if (stakeType == YIELD){
760                 _totalSupplyYield = _totalSupplyYield.sub(amount);
761             }else{
762                 _totalSupply = _totalSupply.sub(amount);
763                 _totalSupplyYield = _totalSupplyYield.sub(amount);
764             }
765 
766             if(allowEmergencyWithdraw || stakeType==STAKE){
767                 if(tokenAmount > 0){
768                     stakedToken.transfer(address(msg.sender), tokenAmount);
769                     emit Withdraw(msg.sender, tokenAmount, stakeType);
770                 }
771                 if(exitAmount > 0){
772                     sendExitToken(msg.sender, exitAmount);
773                     emit Exit(msg.sender, exitAmount, stakeType);
774                 }
775             }else{
776                 user.withdrawable += tokenAmount;
777                 user.withdrawableExit += exitAmount;
778 
779                 user.withdrawTime = now;
780 
781                 _totalYieldWithdrawed += amount;
782                 emit Unfreeze(msg.sender, amount, stakeType);
783             }
784             _totalExit += exitAmount;
785         }
786     }
787 
788     function withdrawUnfreezed() 
789         importUser(msg.sender) 
790         public{
791         User storage user = users[msg.sender];
792         require(user.withdrawable > 0 || user.withdrawableExit > 0, 
793             "amount is 0");
794         
795         uint256 nextEpochTime = IStrategy(
796             controller.getStrategy(address(this))
797         ).getNextEpochTime();
798 
799         require(nextEpochTime.sub(PERIOD).sub(EPOCH_PERIOD) >=  user.withdrawTime ||
800             allowEmergencyWithdraw, "not withdrawable yet");
801 
802         if(user.withdrawable > 0){
803             stakedToken.transfer(address(msg.sender), user.withdrawable);
804             emit Withdraw(msg.sender, user.withdrawable, YIELD);
805             user.withdrawable = 0;
806         }
807 
808         if(user.withdrawableExit > 0){
809             sendExitToken(msg.sender, user.withdrawableExit);
810             emit Exit(msg.sender, user.withdrawableExit, YIELD);
811             user.withdrawableExit = 0;    
812         }
813     }
814 
815     function notifyRewardAmount(uint256 reward, uint256 stakeType) public onlyOwnerOrController{
816         notifyRewardAmountInternal(reward, stakeType);
817     }
818 
819     // just Controller and admin should be able to call this
820     function notifyRewardAmountInternal(uint256 reward, uint256 stakeType) private  updateReward(address(0), stakeType){
821         if (block.timestamp >= periodFinish) {
822             if(stakeType == STAKE){
823                 rewardRate = reward.div(PERIOD);    
824             }else{
825                 rewardRateYield = reward.div(PERIOD);
826             }
827         } else {
828             uint256 remaining = periodFinish.sub(block.timestamp);
829             if(stakeType == STAKE){
830                 uint256 leftover = remaining.mul(rewardRate);
831                 rewardRate = reward.add(leftover).div(PERIOD);    
832             }else{
833                 uint256 leftover = remaining.mul(rewardRateYield);
834                 rewardRateYield = reward.add(leftover).div(PERIOD);
835             }
836             
837         }
838         lastUpdateTime = block.timestamp;
839         periodFinish = block.timestamp.add(PERIOD);
840     }
841 
842     function balanceOf(address account, uint256 stakeType) public view returns(uint256) {
843         User storage user = users[account];
844         if(user.stakeType == BOTH || user.stakeType==stakeType)
845             return user.balance;
846         return 0;
847     }
848 
849     function exitBalance(address account) public view returns(uint256){
850         User storage user = users[account];
851         if(!user.exit || user.balance==0){
852             return 0;
853         }
854         uint256 portion = (block.timestamp - user.exitStartTime).mul(1 ether).div(EXIT_PERIOD);
855         portion = portion >= 1 ether ? 1 ether : portion;
856 
857         uint256 notExitedBalance = user.balance.sub(user.exitAmountTillNow);
858         
859         uint256 balance = user.exitAmountTillNow.add(notExitedBalance.mul(portion).div(1 ether));
860         return balance > user.balance ? user.balance : balance;
861     }
862 
863     function totalYieldWithdrawed() public view returns(uint256) {
864         return _totalYieldWithdrawed;
865     }
866 
867     function totalExit() public view returns(uint256) {
868         return _totalExit;
869     }
870 
871     function totalSupply(uint256 stakeType) public view returns(uint256) {
872         return stakeType == STAKE ? _totalSupply : _totalSupplyYield;
873     }
874 
875     function lastTimeRewardApplicable() public view returns(uint256) {
876         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
877     }
878 
879     function rewardPerToken(uint256 stakeType) public view returns(uint256) {
880         uint256 supply = stakeType == STAKE ? _totalSupply : _totalSupplyYield;        
881         if (supply == 0) {
882             return stakeType == STAKE ? rewardTillNowPerToken : yieldRewardTillNowPerToken;
883         }
884         if(stakeType == STAKE){
885             return rewardTillNowPerToken.add(
886                 lastTimeRewardApplicable().sub(lastUpdateTime)
887                 .mul(rewardRate).mul(1e18).div(_totalSupply)
888             );
889         }else{
890             return yieldRewardTillNowPerToken.add(
891                 lastTimeRewardApplicable().sub(lastUpdateTime).
892                 mul(rewardRateYield).mul(1e18).div(_totalSupplyYield)
893             );
894         }
895     }
896 
897     function getRewardToken() public view returns(address){
898         return address(rewardToken);
899     }
900 
901     function userInfo(address account) public view returns(
902         uint256[15] memory numbers,
903 
904         address rewardTokenAddress,
905         address stakedTokenAddress,
906         address controllerAddress,
907         address strategyAddress,
908         bool exit
909     ){
910         User storage user = users[account];
911         numbers[0] = user.balance;
912         numbers[1] = user.stakeType;
913         numbers[2] = user.withdrawTime;
914         numbers[3] = user.withdrawable;
915         numbers[4] = _totalSupply;
916         numbers[5] = _totalSupplyYield;
917         numbers[6] = stakedToken.balanceOf(address(this));
918         
919         numbers[7] = rewardPerToken(STAKE);
920         numbers[8] = rewardPerToken(YIELD);
921         
922         numbers[9] = earned(account);
923 
924         numbers[10] = user.exitStartTime;
925         numbers[11] = exitBalance(account);
926 
927         numbers[12] = user.withdrawable;
928         numbers[13] = user.withdrawableExit;
929 
930         rewardTokenAddress = address(rewardToken);
931         stakedTokenAddress = address(stakedToken);
932         controllerAddress = address(controller);
933 
934         exit = user.exit;
935 
936         strategyAddress = controller.getStrategy(address(this));
937         numbers[14] = IStrategy(
938             controller.getStrategy(address(this))
939         ).getNextEpochTime();
940     }
941 
942     function setController(address _controller) public onlyOwner{
943         if(_controller != address(0)){
944             controller = IController(_controller);
945         }
946     }
947 
948     function emergencyWithdrawFor(address _user) public onlyOwner{
949         User storage user = users[_user];
950 
951         uint256 amount = user.balance;
952 
953         stakedToken.transfer(_user, amount);
954 
955         emit EmergencyWithdraw(_user, amount);
956 
957         //add other fields
958         user.balance = 0;
959         user.paidReward = 0;
960         user.yieldPaidReward = 0;
961     }
962 
963     function setAllowEmergencyWithdraw(bool _val) public onlyOwner{
964         allowEmergencyWithdraw = _val;
965     }
966 
967     function setExitable(bool _val) public onlyOwner{
968         exitable = _val;
969     }
970 
971     function setExitRewardDenominator(uint256 _val) public onlyOwner{
972         exitRewardDenominator = _val;
973     }
974 
975     function emergencyWithdrawETH(uint256 amount, address addr) public onlyOwner{
976         require(addr != address(0));
977         payable(addr).transfer(amount);
978     }
979 
980     function emergencyWithdrawERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
981         StandardToken(_tokenAddr).transfer(_to, _amount);
982     }
983 }
984 
985 
986 //Dar panah khoda