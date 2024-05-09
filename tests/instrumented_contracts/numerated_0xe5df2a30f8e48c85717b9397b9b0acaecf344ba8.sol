1 pragma solidity >=0.5.12;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 /**
22  * @title   Lition Pool Contract
23  * @author  Patricio Mosse
24  * @notice  This contract is used for staking LIT (ERC20) tokens to support a validator running in the Lition blockchain network and distribute rewards.
25  **/
26 contract LitionPool {
27     using SafeMath for uint256;
28 
29     /**************************************************** Events **************************************************************/
30     
31     event NewStake(address indexed staker, uint256 totalStaked, uint8 lockupPeriod, bool compound);
32     event StakeFinishedByUser(address indexed staker, uint256 totalRecovered, uint256 index);
33     event StakeRemoved(address indexed staker, uint256 totalRecovered, uint256 index);
34     event RewardsToBeAccreditedDistributed(uint256 total);
35     event RewardsToBeAccreditedUpdated(address indexed staker, uint256 total, uint256 delta);
36     event RewardsAccredited(uint256 total);
37     event RewardsAccreditedToStaker(address indexed staker, uint256 total);
38     event CompoundChanged(address indexed staker, uint256 index);
39     event RewardsWithdrawn(address indexed staker, uint256 total);
40     event StakeDeclaredAsFinished(address indexed staker, uint256 index);
41     event StakeIncreased(address indexed staker, uint256 index, uint256 total, uint256 delta);
42     event TransferredToVestingAccount(uint256 total);
43 
44     /**************************************************** Vars and structs **************************************************************/
45     
46     address public owner;
47     IERC20 litionToken;
48     uint256 public lastMiningRewardBlock = 0;
49     uint256 public lastNewStakeBlock = 0;
50     bool public paused = false;
51 
52     struct StakeList {
53         Stake[] stakes;
54         uint256 rewards;
55         uint256 rewardsToBeAccredited;
56     }
57     
58     struct Stake {
59         uint256 createdOn;
60         uint256 totalStaked;
61         uint8 lockupPeriod;
62         bool compound;
63         bool isFinished;
64     }
65     
66     address[] public stakers;
67     mapping (address => StakeList) public stakeListBySender;
68 
69     /**************************************************** Admin **************************************************************/
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     constructor(IERC20 _litionToken) public {
77         owner = msg.sender;
78         litionToken = _litionToken;
79     }
80 
81     function _transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0), "New owner can't be the zero address");
83         owner = newOwner;
84     }
85     
86     function _switchPaused() public onlyOwner {
87         paused = !paused;
88     }
89 
90     function() external payable {
91         revert();
92     }
93 
94     /**************************************************** Public Interface for Stakers **************************************************************/
95 
96     function createNewStake(uint256 _amount, uint8 _lockupPeriod, bool _compound) public {
97         require(!paused, "New stakes are paused");
98         require(_isValidLockupPeriod(_lockupPeriod), "The lockup period is invalid");
99         require(_amount >= 5000000000000000000000, "You must stake at least 5000 LIT");
100         require(_canStakeToday(), "You can't start a stake until the first day of next month");
101         require(IERC20(litionToken).transferFrom(msg.sender, address(this), _amount), "Couldn't take the LIT from the sender");
102         
103         Stake memory stake = Stake({createdOn: now, 
104                                     totalStaked:_amount, 
105                                     lockupPeriod:_lockupPeriod, 
106                                     compound:_compound, 
107                                     isFinished:false});
108                                     
109         Stake[] storage stakes = stakeListBySender[msg.sender].stakes;
110         stakes.push(stake);
111         _addStakerIfNotExist(msg.sender);
112         
113         emit NewStake(msg.sender, _amount, _lockupPeriod, _compound);
114     }
115     
116     function switchCompound(uint256 _index) public {
117         require(stakeListBySender[msg.sender].stakes.length > _index, "The stake doesn't exist");
118         stakeListBySender[msg.sender].stakes[_index].compound = !stakeListBySender[msg.sender].stakes[_index].compound;
119         
120         emit CompoundChanged(msg.sender, _index);
121     }
122     
123     function finishStake(uint256 _index) public {
124         require(stakeListBySender[msg.sender].stakes.length > _index, "The stake doesn't exist");
125         Stake memory stake = stakeListBySender[msg.sender].stakes[_index];
126         require (stake.isFinished, "The stake is not finished yet");
127         uint256 total = _closeStake(msg.sender, _index);
128         
129         emit StakeFinishedByUser(msg.sender, total, _index);
130     }
131     
132      function withdrawRewards() public {
133         require(stakeListBySender[msg.sender].rewards > 0, "You don't have rewards to withdraw");
134         
135         uint256 total = stakeListBySender[msg.sender].rewards;
136         stakeListBySender[msg.sender].rewards = 0;
137 
138         require(litionToken.transfer(msg.sender, total));
139 
140         emit RewardsWithdrawn(msg.sender, total);
141     }
142 
143     /**************************************************** Public Interface for Admin **************************************************************/
144 
145     // Will be called monthly, at the end of each month
146     function _accreditRewards() public onlyOwner {
147         uint256 totalToAccredit = getTotalRewardsToBeAccredited();
148         require(IERC20(litionToken).transferFrom(msg.sender, address(this), totalToAccredit), "Couldn't take the LIT from the sender");
149 
150         for (uint256 i = 0; i < stakers.length; i++) {
151             StakeList storage stakeList = stakeListBySender[stakers[i]];
152             uint256 rewardsToBeAccredited = stakeList.rewardsToBeAccredited;
153             if (rewardsToBeAccredited > 0) {
154                 stakeList.rewardsToBeAccredited = 0;
155                 stakeList.rewards += rewardsToBeAccredited;
156                 
157                 emit RewardsAccreditedToStaker(stakers[i], rewardsToBeAccredited);
158             }
159         }
160         
161         emit RewardsAccredited(totalToAccredit);
162     }
163 
164     // Will be called monthly, at the end of each month
165     function _declareFinishers() public onlyOwner {
166         uint256 totalForClosers = getTotalAmountsForClosers();
167         require(totalForClosers > 0, "There are no finishers");
168         require(IERC20(litionToken).transferFrom(msg.sender, address(this), totalForClosers), "Couldn't take the LIT from the sender");
169 
170         for (uint256 i = 0; i < stakers.length; i++) {
171             Stake[] storage stakes = stakeListBySender[stakers[i]].stakes;
172             for (uint256 j = 0; j < stakes.length; j++) {
173                 if (!stakes[j].isFinished && _isLockupPeriodFinished(stakes[j].createdOn, stakes[j].lockupPeriod)) {
174                     stakes[j].isFinished = true;
175                     
176                     emit StakeDeclaredAsFinished(stakers[i], j);
177                 }
178             }
179         }
180     }
181 
182     // Will be called every day to distribute the accumulated new MiningReward events coming from LitionRegistry
183     function _updateRewardsToBeAccredited(uint256 _fromMiningRewardBlock, uint256 _toMiningRewardBlock, uint256 _amount) public onlyOwner {
184         require(_fromMiningRewardBlock < _toMiningRewardBlock, "Invalid params");
185         require(_fromMiningRewardBlock > lastMiningRewardBlock, "Rewards already distributed");
186         
187         lastMiningRewardBlock = _toMiningRewardBlock;
188         
189         //Won't consider any stake marked as isFinished
190         
191         uint256 fees = _amount.mul(5) / 100; // Amount the validator will keep for himself
192         uint256 totalParts = _calculateParts();
193 
194         _distributeBetweenStakers(totalParts, _amount.sub(fees));
195 
196         emit RewardsToBeAccreditedDistributed(_amount);
197     }
198 
199     function _transferLITToVestingAccount(uint256 _fromNewStakeBlock, uint256 _toNewStakeBlock, uint256 _total) public onlyOwner {
200         require(_fromNewStakeBlock < _toNewStakeBlock, "Invalid params");
201         require(_fromNewStakeBlock > lastNewStakeBlock, "Stakes already transferred");
202         
203         lastNewStakeBlock = _toNewStakeBlock;
204         
205         require(litionToken.transfer(msg.sender, _total));
206         emit TransferredToVestingAccount(_total);
207     }
208 
209     function _extractRemainingLitSentByMistake(address _sendTo) public onlyOwner {
210         require(stakers.length == 0, "There are still stakers in the contract");
211         uint256 totalBalance = litionToken.balanceOf(address(this));
212         require(litionToken.transfer(_sendTo, totalBalance));
213     }
214     
215     function _extractCertainLitSentByMistake(uint256 amount, address _sendTo) public onlyOwner {
216         require(litionToken.transfer(_sendTo, amount));
217     }
218 
219     function _removeStaker(address _staker, uint256 _index) public onlyOwner {
220         require(stakeListBySender[_staker].stakes.length > _index, "The stake doesn't exist");
221         uint256 total = _closeStake(_staker, _index);
222 
223         emit StakeRemoved(_staker, total, _index);
224     }
225 
226     /**************************************************** Pool Information **************************************************************/
227 
228 	function getTotalRewardsToBeAccredited() public view returns (uint256) {
229         uint256 total = 0;
230         for (uint256 i = 0; i < stakers.length; i++) {
231             total += stakeListBySender[stakers[i]].rewardsToBeAccredited;
232         }
233         return total;
234     }
235     
236     function getTotalAmountsForClosers() public view returns (uint256) {
237         uint256 total = 0;
238         for (uint256 i = 0; i < stakers.length; i++) {
239             Stake[] memory stakes = stakeListBySender[stakers[i]].stakes;
240             for (uint256 j = 0; j < stakes.length; j++) {
241                 if (!stakes[j].isFinished && _isLockupPeriodFinished(stakes[j].createdOn, stakes[j].lockupPeriod)) {
242                     total = total.add(stakes[j].totalStaked);
243                 }
244             }
245         }
246         return total;
247     }
248 
249 	function areThereFinishers() public view returns(bool) {
250         for (uint256 i = 0; i < stakers.length; i++) {
251             Stake[] storage stakes = stakeListBySender[stakers[i]].stakes;
252             for (uint256 j = 0; j < stakes.length; j++) {
253                 if (!stakes[j].isFinished && _isLockupPeriodFinished(stakes[j].createdOn, stakes[j].lockupPeriod)) {
254                     return true;
255                 }
256             }
257         }
258         return false;
259     }
260     
261     function getTotalInStakeIncludingFinished() public view returns (uint256) {
262         uint256 total = 0;
263         for (uint256 i = 0; i < stakers.length; i++) {
264             Stake[] memory stakes = stakeListBySender[stakers[i]].stakes;
265             for (uint256 j = 0; j < stakes.length; j++) {
266                 total = total.add(stakes[j].totalStaked);
267             }
268         }
269         return total;
270     }
271     
272     function getTotalInStake() public view returns (uint256) {
273         uint256 total = 0;
274         for (uint256 i = 0; i < stakers.length; i++) {
275             Stake[] memory stakes = stakeListBySender[stakers[i]].stakes;
276             for (uint256 j = 0; j < stakes.length; j++) {
277                 if (!stakes[j].isFinished) {
278                     total = total.add(stakes[j].totalStaked);
279                 }
280             }
281         }
282         return total;
283     }
284     
285     function getTotalStakes() public view returns (uint256) {
286         uint256 total = 0;
287         for (uint256 i = 0; i < stakers.length; i++) {
288             Stake[] memory stakes = stakeListBySender[stakers[i]].stakes;
289             for (uint256 j = 0; j < stakes.length; j++) {
290                 if (!stakes[j].isFinished) {
291                     total += 1;
292                 }
293             }
294         }
295         return total;
296     }
297     
298     function getTotalStakers() public view returns (uint256) {
299         return stakers.length;
300     }
301 
302     function getStaker(address _staker) external view returns (uint256 rewards, uint256 rewardsToBeAccredited, uint256 totalStakes) {
303         StakeList memory stakeList = stakeListBySender[_staker];
304         rewards = stakeList.rewards;
305         rewardsToBeAccredited = stakeList.rewardsToBeAccredited;
306         totalStakes = stakeList.stakes.length;
307     }
308     
309     function getStake(address _staker, uint256 _index) external view returns (uint256 createdOn, uint256 totalStaked, uint8 lockupPeriod, bool compound, bool isFinished, uint256 lockupFinishes) {
310         require(stakeListBySender[_staker].stakes.length > _index, "The stake doesn't exist");
311         Stake memory stake = stakeListBySender[_staker].stakes[_index];
312         createdOn = stake.createdOn;
313         totalStaked = stake.totalStaked;
314         lockupPeriod = stake.lockupPeriod;
315         compound = stake.compound;
316         isFinished = stake.isFinished;
317         lockupFinishes = getLockupFinishTimestamp(_staker, _index);
318     }
319 
320     function getLockupFinishTimestamp(address _staker, uint256 _index) public view returns (uint256) {
321         require(stakeListBySender[_staker].stakes.length > _index, "The stake doesn't exist");
322         Stake memory stake = stakeListBySender[_staker].stakes[_index];
323         return calculateFinishTimestamp(stake.createdOn, stake.lockupPeriod);
324     }
325 
326     /**************************************************** Internal Admin - Lockups **************************************************************/
327     
328     function calculateFinishTimestamp(uint256 _timestamp, uint8 _lockupPeriod) public pure returns (uint256) {
329         uint16 year = Date.getYear(_timestamp);
330         uint8 month = Date.getMonth(_timestamp);
331         month += _lockupPeriod;
332         if (month > 12) {
333             year += 1;
334             month = month % 12;
335         }
336         uint8 newDay = Date.getDaysInMonth(month, year);
337         return Date.toTimestamp(year, month, newDay);
338     }
339 
340     /**************************************************** Internal Admin - Stakes and Rewards **************************************************************/
341 
342     function _closeStake(address _staker, uint256 _index) internal returns (uint256) {
343         uint256 total = stakeListBySender[_staker].stakes[_index].totalStaked;
344 
345         _removeStakeByIndex(_staker, _index);
346         if (stakeListBySender[msg.sender].stakes.length == 0) {
347             _removeStakerByValue(_staker);
348         }
349         
350         require(litionToken.transfer(_staker, total));
351 
352         return total;
353     }
354 
355     function _distributeBetweenStakers(uint256 _totalParts, uint256 _amountMinusFees) internal {
356         uint256 totalTransferred = 0;
357 
358         for (uint256 i = 0; i < stakers.length; i++) {
359             StakeList storage stakeList = stakeListBySender[stakers[i]];
360             
361             for (uint256 j = 0; j < stakeList.stakes.length; j++) {
362             
363                 if (!_isValidAndNotFinished(stakers[i], j)) {
364                     continue;
365                 }
366                 
367                 Stake storage stake = stakeList.stakes[j];
368                 
369                 uint256 amountToTransfer = _getAmountToTransfer(_totalParts, _amountMinusFees, stake.lockupPeriod, stake.totalStaked);
370                 totalTransferred = totalTransferred.add(amountToTransfer);
371                 
372                 if (stake.compound) {
373                     stake.totalStaked = stake.totalStaked.add(amountToTransfer);
374 
375                     emit StakeIncreased(stakers[i], j, stake.totalStaked, amountToTransfer);
376                 }
377                 else {
378                     stakeList.rewardsToBeAccredited = stakeList.rewardsToBeAccredited.add(amountToTransfer);
379                     
380                     emit RewardsToBeAccreditedUpdated(stakers[i], stakeList.rewardsToBeAccredited, amountToTransfer);
381                 }
382             }
383         }
384     }
385 
386     function _calculateParts() internal view returns (uint256) {
387         uint256 divideInParts = 0;
388         
389         for (uint256 i = 0; i < stakers.length; i++) {
390             StakeList memory stakeList = stakeListBySender[stakers[i]];
391             
392             for (uint256 j = 0; j < stakeList.stakes.length; j++) {
393                 if (!_isValidAndNotFinished(stakers[i], j)) {
394                     continue;
395                 }
396                 
397                 Stake memory stake = stakeList.stakes[j];
398                 if (stake.lockupPeriod == 1) {
399                     divideInParts = divideInParts.add(stake.totalStaked.mul(12));
400                 }
401                 else if (stake.lockupPeriod == 3) {
402                     divideInParts = divideInParts.add(stake.totalStaked.mul(14));
403                 }
404                 else if (stake.lockupPeriod == 6) {
405                     divideInParts = divideInParts.add(stake.totalStaked.mul(16));
406                 }
407                 else if (stake.lockupPeriod == 12) {
408                     divideInParts = divideInParts.add(stake.totalStaked.mul(18));
409                 }
410             }
411         }
412         
413         return divideInParts;
414     }
415 
416     function _getAmountToTransfer(uint256 _totalParts,  uint256 _amount, uint8 _lockupPeriod, uint256 _rewards) internal pure returns (uint256) {
417         uint256 factor;
418         
419         if (_lockupPeriod == 1) {
420             factor = 12;
421         }
422         else if (_lockupPeriod == 3) {
423             factor = 14;
424         }
425         else if (_lockupPeriod == 6) {
426             factor = 16;
427         }
428         else if (_lockupPeriod == 12) {
429             factor = 18;
430         }
431 
432         return _amount.mul(factor).mul(_rewards).div(_totalParts);
433     }
434     
435     /**************************************************** Internal Admin - Validations **************************************************************/
436     
437     function _isValidLockupPeriod(uint8 n) internal pure returns (bool) {
438         if (n == 1) {
439             return true;
440         }
441         else if (n == 3) {
442             return true;
443         }
444         else if (n == 6) {
445             return true;
446         }
447         else if (n == 12) {
448             return true;
449         }
450         return false;
451     }
452 
453     function _isLockupPeriodFinished(uint256 _timestamp, uint8 _lockupPeriod) internal view returns (bool) {
454         return now > calculateFinishTimestamp(_timestamp, _lockupPeriod);
455     }
456     
457     function _isValidAndNotFinished(address _staker, uint256 _index) internal view returns (bool) {
458         if (stakeListBySender[_staker].stakes.length <= _index) {
459             return false;
460         }
461         return !stakeListBySender[_staker].stakes[_index].isFinished;
462     }
463 
464     function _canStakeToday() internal view returns (bool) {
465         uint8 currentDay = Date.getDay(now);
466         uint16 year = Date.getYear(now);
467         uint8 month = Date.getMonth(now);
468         uint8 totalDays = Date.getDaysInMonth(month, year);
469         return totalDays - 8 > currentDay;
470     }
471 
472     /**************************************************** Internal Admin - Arrays **************************************************************/
473 
474     function _addStakerIfNotExist(address _staker) internal {
475         for (uint256 i = 0; i < stakers.length; i++) {
476             if (stakers[i] == _staker) {
477                 return;
478             }
479         }
480         stakers.push(_staker);
481     }
482 
483     function _findStaker(address _value) internal view returns(uint) {
484         uint i = 0;
485         while (stakers[i] != _value) {
486             i++;
487         }
488         return i;
489     }
490 
491     function _removeStakerByValue(address _value) internal {
492         uint i = _findStaker(_value);
493         _removeStakerByIndex(i);
494     }
495 
496     function _removeStakerByIndex(uint _i) internal {
497         while (_i<stakers.length-1) {
498             stakers[_i] = stakers[_i+1];
499             _i++;
500         }
501         stakers.length--;
502     }
503     
504     function _removeStakeByIndex(address _staker, uint _i) internal {
505         Stake[] storage stakes = stakeListBySender[_staker].stakes;
506         while (_i<stakes.length-1) {
507             stakes[_i] = stakes[_i+1];
508             _i++;
509         }
510         stakes.length--;
511     }
512 }
513 
514 library SafeMath {
515     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
516         c = a + b;
517         require(c >= a);
518         return c;
519     }
520 
521     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
522         if (a == 0) {
523             return 0;
524         }
525         c = a * b;
526         require(c / a == b);
527         return c;
528     }
529     
530     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
531         return sub(a, b, "SafeMath: subtraction overflow");
532     }
533     
534     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
535         require(b <= a, errorMessage);
536         uint256 c = a - b;
537 
538         return c;
539     }
540     
541     function div(uint256 a, uint256 b) internal pure returns (uint256) {
542         return div(a, b, "SafeMath: division by zero");
543     }
544     
545     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
546         // Solidity only automatically asserts when dividing by 0
547         require(b > 0, errorMessage);
548         uint256 c = a / b;
549         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
550 
551         return c;
552     }
553 }
554 
555 library Date {
556     struct _Date {
557         uint16 year;
558         uint8 month;
559         uint8 day;
560     }
561 
562     uint constant DAY_IN_SECONDS = 86400;
563     uint constant YEAR_IN_SECONDS = 31536000;
564     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
565 
566     uint16 constant ORIGIN_YEAR = 1970;
567 
568     function isLeapYear(uint16 year) public pure returns (bool) {
569         if (year % 4 != 0) {
570                 return false;
571         }
572         if (year % 100 != 0) {
573                 return true;
574         }
575         if (year % 400 != 0) {
576                 return false;
577         }
578         return true;
579     }
580 
581     function leapYearsBefore(uint year) public pure returns (uint) {
582         year -= 1;
583         return year / 4 - year / 100 + year / 400;
584     }
585 
586     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
587         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
588                 return 31;
589         }
590         else if (month == 4 || month == 6 || month == 9 || month == 11) {
591                 return 30;
592         }
593         else if (isLeapYear(year)) {
594                 return 29;
595         }
596         else {
597                 return 28;
598         }
599     }
600 
601     function parseTimestamp(uint timestamp) internal pure returns (_Date memory dt) {
602         uint secondsAccountedFor = 0;
603         uint buf;
604         uint8 i;
605 
606         // Year
607         dt.year = getYear(timestamp);
608         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
609 
610         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
611         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
612 
613         // Month
614         uint secondsInMonth;
615         for (i = 1; i <= 12; i++) {
616                 secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
617                 if (secondsInMonth + secondsAccountedFor > timestamp) {
618                         dt.month = i;
619                         break;
620                 }
621                 secondsAccountedFor += secondsInMonth;
622         }
623 
624         // Day
625         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
626                 if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
627                         dt.day = i;
628                         break;
629                 }
630                 secondsAccountedFor += DAY_IN_SECONDS;
631         }
632     }
633 
634     function getYear(uint timestamp) public pure returns (uint16) {
635         uint secondsAccountedFor = 0;
636         uint16 year;
637         uint numLeapYears;
638 
639         // Year
640         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
641         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
642 
643         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
644         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
645 
646         while (secondsAccountedFor > timestamp) {
647                 if (isLeapYear(uint16(year - 1))) {
648                         secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
649                 }
650                 else {
651                         secondsAccountedFor -= YEAR_IN_SECONDS;
652                 }
653                 year -= 1;
654         }
655         return year;
656     }
657 
658     function getMonth(uint timestamp) public pure returns (uint8) {
659         return parseTimestamp(timestamp).month;
660     }
661 
662     function getDay(uint timestamp) public pure returns (uint8) {
663         return parseTimestamp(timestamp).day;
664     }
665 
666     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
667         uint16 i;
668 
669         // Year
670         for (i = ORIGIN_YEAR; i < year; i++) {
671                 if (isLeapYear(i)) {
672                         timestamp += LEAP_YEAR_IN_SECONDS;
673                 }
674                 else {
675                         timestamp += YEAR_IN_SECONDS;
676                 }
677         }
678 
679         // Month
680         uint8[12] memory monthDayCounts;
681         monthDayCounts[0] = 31;
682         if (isLeapYear(year)) {
683                 monthDayCounts[1] = 29;
684         }
685         else {
686                 monthDayCounts[1] = 28;
687         }
688         monthDayCounts[2] = 31;
689         monthDayCounts[3] = 30;
690         monthDayCounts[4] = 31;
691         monthDayCounts[5] = 30;
692         monthDayCounts[6] = 31;
693         monthDayCounts[7] = 31;
694         monthDayCounts[8] = 30;
695         monthDayCounts[9] = 31;
696         monthDayCounts[10] = 30;
697         monthDayCounts[11] = 31;
698 
699         for (i = 1; i < month; i++) {
700                 timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
701         }
702 
703         // Day
704         timestamp += DAY_IN_SECONDS * (day - 1);
705 
706         return timestamp;
707     }
708 }