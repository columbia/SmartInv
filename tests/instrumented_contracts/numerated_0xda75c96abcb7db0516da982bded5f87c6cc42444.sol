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
21 
22 library Date {
23     struct _Date {
24         uint16 year;
25         uint8 month;
26         uint8 day;
27     }
28 
29     uint constant DAY_IN_SECONDS = 86400;
30     uint constant YEAR_IN_SECONDS = 31536000;
31     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
32 
33     uint16 constant ORIGIN_YEAR = 1970;
34 
35     function isLeapYear(uint16 year) public pure returns (bool) {
36         if (year % 4 != 0) {
37                 return false;
38         }
39         if (year % 100 != 0) {
40                 return true;
41         }
42         if (year % 400 != 0) {
43                 return false;
44         }
45         return true;
46     }
47 
48     function leapYearsBefore(uint year) public pure returns (uint) {
49         year -= 1;
50         return year / 4 - year / 100 + year / 400;
51     }
52 
53     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
54         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
55                 return 31;
56         }
57         else if (month == 4 || month == 6 || month == 9 || month == 11) {
58                 return 30;
59         }
60         else if (isLeapYear(year)) {
61                 return 29;
62         }
63         else {
64                 return 28;
65         }
66     }
67 
68     function parseTimestamp(uint timestamp) internal pure returns (_Date memory dt) {
69         uint secondsAccountedFor = 0;
70         uint buf;
71         uint8 i;
72 
73         // Year
74         dt.year = getYear(timestamp);
75         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
76 
77         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
78         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
79 
80         // Month
81         uint secondsInMonth;
82         for (i = 1; i <= 12; i++) {
83                 secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
84                 if (secondsInMonth + secondsAccountedFor > timestamp) {
85                         dt.month = i;
86                         break;
87                 }
88                 secondsAccountedFor += secondsInMonth;
89         }
90 
91         // Day
92         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
93                 if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
94                         dt.day = i;
95                         break;
96                 }
97                 secondsAccountedFor += DAY_IN_SECONDS;
98         }
99     }
100 
101     function getYear(uint timestamp) public pure returns (uint16) {
102         uint secondsAccountedFor = 0;
103         uint16 year;
104         uint numLeapYears;
105 
106         // Year
107         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
108         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
109 
110         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
111         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
112 
113         while (secondsAccountedFor > timestamp) {
114                 if (isLeapYear(uint16(year - 1))) {
115                         secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
116                 }
117                 else {
118                         secondsAccountedFor -= YEAR_IN_SECONDS;
119                 }
120                 year -= 1;
121         }
122         return year;
123     }
124 
125     function getMonth(uint timestamp) public pure returns (uint8) {
126         return parseTimestamp(timestamp).month;
127     }
128 
129     function getDay(uint timestamp) public pure returns (uint8) {
130         return parseTimestamp(timestamp).day;
131     }
132 
133     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
134         uint16 i;
135 
136         // Year
137         for (i = ORIGIN_YEAR; i < year; i++) {
138                 if (isLeapYear(i)) {
139                         timestamp += LEAP_YEAR_IN_SECONDS;
140                 }
141                 else {
142                         timestamp += YEAR_IN_SECONDS;
143                 }
144         }
145 
146         // Month
147         uint8[12] memory monthDayCounts;
148         monthDayCounts[0] = 31;
149         if (isLeapYear(year)) {
150                 monthDayCounts[1] = 29;
151         }
152         else {
153                 monthDayCounts[1] = 28;
154         }
155         monthDayCounts[2] = 31;
156         monthDayCounts[3] = 30;
157         monthDayCounts[4] = 31;
158         monthDayCounts[5] = 30;
159         monthDayCounts[6] = 31;
160         monthDayCounts[7] = 31;
161         monthDayCounts[8] = 30;
162         monthDayCounts[9] = 31;
163         monthDayCounts[10] = 30;
164         monthDayCounts[11] = 31;
165 
166         for (i = 1; i < month; i++) {
167                 timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
168         }
169 
170         // Day
171         timestamp += DAY_IN_SECONDS * (day - 1);
172 
173         return timestamp;
174     }
175 }
176 
177 /**
178  * @title   Lition Pool Contract
179  * @author  Patricio Mosse
180  * @notice  This contract is used for staking LIT (ERC20) tokens to support a validator running in the Lition blockchain network and distribute rewards.
181  **/
182 contract LitionPool {
183     using SafeMath for uint256;
184 
185     /**************************************************** Events **************************************************************/
186     
187     event NewStake(address indexed staker, uint256 totalStaked, uint8 lockupPeriod, bool compound);
188     event StakeMigrated(address indexed staker, uint256 index);
189     event StakeFinishedByUser(address indexed staker, uint256 totalRecovered, uint256 index);
190     event StakeRestakedByUser(address indexed staker, uint256 totalStaked, uint8 lockupPeriod, bool compound);
191     event StakeEnabledToBeFinished(address indexed staker, uint256 index);
192     event StakeRemoved(address indexed staker, uint256 totalRecovered, uint256 index);
193     event RewardsAccredited(address indexed staker, uint256 index, uint256 delta, uint256 total);
194     event StakeIncreased(address indexed staker, uint256 index, uint256 delta, uint256 total);
195     event RewardsWithdrawn(address indexed staker, uint256 index, uint256 total);
196     event TransferredToVestingAccount(uint256 total);
197 
198     /**************************************************** Vars and structs **************************************************************/
199     
200     address public owner;
201     IERC20 litionToken;
202     bool public paused = false;
203 
204     struct Stake {
205         uint256 createdOn;
206         uint256 totalStaked;
207         uint8 lockupPeriod;
208         bool compound;
209         uint256 rewards;
210         bool finished;
211     }
212     
213     address[] public stakers;
214     mapping (address => Stake[]) public stakeListBySender;
215 
216     /**************************************************** Admin **************************************************************/
217 
218     modifier onlyOwner {
219         require(msg.sender == owner);
220         _;
221     }
222 
223     constructor(IERC20 _litionToken) public {
224         owner = msg.sender;
225         litionToken = _litionToken;
226     }
227 
228     function _transferOwnership(address newOwner) public onlyOwner {
229         require(newOwner != address(0), "New owner can't be the zero address");
230         owner = newOwner;
231     }
232     
233     function _switchPaused() public onlyOwner {
234         paused = !paused;
235     }
236 
237     function() external payable {
238         revert();
239     }
240 
241     /**************************************************** Public Interface for Stakers **************************************************************/
242 
243     function createNewStake(uint256 _amount, uint8 _lockupPeriod, bool _compound) public {
244         require(!paused, "New stakes are paused");
245         require(_isValidLockupPeriod(_lockupPeriod), "The lockup period is invalid");
246         require(_amount >= 5000000000000000000000, "You must stake at least 5000 LIT");
247         require(IERC20(litionToken).transferFrom(msg.sender, address(this), _amount), "Couldn't take the LIT from the sender");
248         
249         Stake memory stake = Stake({createdOn: now, 
250                                     totalStaked:_amount, 
251                                     lockupPeriod:_lockupPeriod, 
252                                     compound:_compound, 
253                                     rewards:0,
254                                     finished:false});
255                                     
256         Stake[] storage stakes = stakeListBySender[msg.sender];
257         stakes.push(stake);
258         _addStakerIfNotExist(msg.sender);
259         
260         emit NewStake(msg.sender, _amount, _lockupPeriod, _compound);
261     }
262     
263     function finishStake(uint256 _index) public {
264         require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");
265 
266         Stake memory stake = stakeListBySender[msg.sender][_index];
267 
268         require(stake.finished, "The stake is not finished yet");
269         
270         uint256 total = _closeStake(msg.sender, _index);
271         
272         emit StakeFinishedByUser(msg.sender, total, _index);
273     }
274     
275     function restake(uint256 _index) public {
276         require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");
277 
278         Stake storage stake = stakeListBySender[msg.sender][_index];
279 
280         require(stake.finished, "The stake is not finished yet");
281         
282         stake.totalStaked = stake.totalStaked.add(stake.rewards);
283         stake.rewards = 0;
284         stake.createdOn = now;
285         stake.finished = false;
286 
287         emit StakeRestakedByUser(msg.sender, stake.totalStaked, stake.lockupPeriod, stake.compound);
288     }
289     
290     function withdrawRewards(uint256 _index) public {
291         require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");
292 
293         Stake storage stake = stakeListBySender[msg.sender][_index];
294 
295         require(stake.rewards > 0, "You don't have rewards to withdraw");
296         
297         uint256 total = stake.rewards;
298         stake.rewards = 0;
299 
300         require(litionToken.transfer(msg.sender, total));
301 
302         emit RewardsWithdrawn(msg.sender, _index, total);
303     }
304 
305     /**************************************************** Public Interface for Admin **************************************************************/
306 
307     function _accredit(address _staker, uint256 _index, uint256 _total) public onlyOwner {
308         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
309         require(IERC20(litionToken).transferFrom(msg.sender, address(this), _total), "Couldn't take the LIT from the sender");
310 
311         Stake storage stake = stakeListBySender[_staker][_index];
312         require(!stake.finished, "The stake is already finished");
313         
314         if (stake.compound) {
315             stake.totalStaked += _total;
316 
317             emit StakeIncreased(_staker, _index, _total, stake.totalStaked);
318         }
319         else {
320             stake.rewards += _total;
321 
322             emit RewardsAccredited(_staker, _index, _total, stake.rewards);
323         }
324         
325         if (_isLockupPeriodFinished(stake.createdOn, stake.lockupPeriod)) {
326             stake.finished = true;
327             
328             emit StakeEnabledToBeFinished(_staker, _index);
329         }
330     }
331     
332     function _accreditMultiple(address _staker, uint256[] memory _totals) public onlyOwner {
333         require(stakeListBySender[_staker].length == _totals.length, "Invalid number of stakes");
334         
335         uint256 total = 0;
336         for (uint256 i = 0; i < _totals.length; i++) {
337             total = total.add(_totals[i]);
338         }
339         
340         require(IERC20(litionToken).transferFrom(msg.sender, address(this), total), "Couldn't take the LIT from the sender");
341 
342         for (uint256 index = 0; index < _totals.length; index++) {
343             Stake storage stake = stakeListBySender[_staker][index];
344             require(!stake.finished, "The stake is already finished");
345             
346             if (stake.compound) {
347                 stake.totalStaked += _totals[index];
348     
349                 emit StakeIncreased(_staker, index, _totals[index], stake.totalStaked);
350             }
351             else {
352                 stake.rewards += _totals[index];
353     
354                 emit RewardsAccredited(_staker, index, _totals[index], stake.rewards);
355             }
356             
357             if (_isLockupPeriodFinished(stake.createdOn, stake.lockupPeriod)) {
358                 stake.finished = true;
359                 
360                 emit StakeEnabledToBeFinished(_staker, index);
361             }
362         }
363     }
364     
365     function _forceFinishStake(address _staker, uint256 _index) public onlyOwner {
366         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
367         Stake storage stake = stakeListBySender[_staker][_index];
368         require(!stake.finished, "The stake is already finished");
369         stake.finished = true;
370         
371         emit StakeEnabledToBeFinished(_staker, _index);
372     }
373 
374     function _transferLITToVestingAccount(uint256 _total) public onlyOwner {
375         require(litionToken.transfer(msg.sender, _total));
376 
377         emit TransferredToVestingAccount(_total);
378     }
379     
380     function _extractLitSentByMistake(uint256 amount, address _sendTo) public onlyOwner {
381         require(litionToken.transfer(_sendTo, amount));
382     }
383 
384     function _removeStaker(address _staker, uint256 _index) public onlyOwner {
385         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
386         
387         uint256 total = _closeStake(_staker, _index);
388 
389         emit StakeRemoved(_staker, total, _index);
390     }
391 
392     /**************************************************** Pool Information **************************************************************/
393 
394     function getTotalInStake() public view returns (uint256) {
395         uint256 total = 0;
396         for (uint256 i = 0; i < stakers.length; i++) {
397             Stake[] memory stakes = stakeListBySender[stakers[i]];
398             for (uint256 j = 0; j < stakes.length; j++) {
399                 if (!stakes[j].finished) {
400                     total = total.add(stakes[j].totalStaked);
401                 }
402             }
403         }
404         return total;
405     }
406     
407     function getTotalStakes() public view returns (uint256) {
408         uint256 total = 0;
409         for (uint256 i = 0; i < stakers.length; i++) {
410             Stake[] memory stakes = stakeListBySender[stakers[i]];
411             for (uint256 j = 0; j < stakes.length; j++) {
412                 if (!stakes[j].finished) {
413                     total += 1;
414                 }
415             }
416         }
417         return total;
418     }
419     
420     function getTotalStakers() public view returns (uint256) {
421         return stakers.length;
422     }
423 
424     function getTotalStakesByStaker(address _staker) external view returns (uint256) {
425         return stakeListBySender[_staker].length;
426     }
427     
428     function getStake(address _staker, uint256 _index) external view returns (uint256 createdOn, uint256 totalStaked, uint8 lockupPeriod, bool compound, uint256 rewards, bool finished, uint256 lockupFinishes) {
429         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
430         Stake memory stake = stakeListBySender[_staker][_index];
431         createdOn = stake.createdOn;
432         totalStaked = stake.totalStaked;
433         lockupPeriod = stake.lockupPeriod;
434         compound = stake.compound;
435         rewards = stake.rewards;
436         finished = stake.finished;
437         lockupFinishes = getLockupFinishTimestamp(_staker, _index);
438     }
439 
440     function getLockupFinishTimestamp(address _staker, uint256 _index) public view returns (uint256) {
441         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
442         Stake memory stake = stakeListBySender[_staker][_index];
443         return calculateFinishTimestamp(stake.createdOn, stake.lockupPeriod);
444     }
445 
446     /**************************************************** Internal Admin - Lockups **************************************************************/
447 
448     function calculateFinishTimestamp(uint256 _timestamp, uint8 _lockupPeriod) public pure returns (uint256) {
449         uint16 year = Date.getYear(_timestamp);
450         uint8 month = Date.getMonth(_timestamp);
451         month += _lockupPeriod;
452         if (month > 12) {
453             year += 1;
454             month = month % 12;
455         }
456         uint8 day = Date.getDay(_timestamp);
457         uint256 finishOn = Date.toTimestamp(year, month, day);
458         return finishOn;
459     }
460 
461     /**************************************************** Internal Admin - Stakes and Rewards **************************************************************/
462 
463     function _closeStake(address _staker, uint256 _index) internal returns (uint256) {
464         uint256 totalStaked = stakeListBySender[_staker][_index].totalStaked;
465         uint256 total = totalStaked + stakeListBySender[_staker][_index].rewards;
466         
467         _removeStakeByIndex(_staker, _index);
468         if (stakeListBySender[_staker].length == 0) {
469             _removeStakerByValue(_staker);
470         }
471         
472         require(litionToken.transfer(_staker, total));
473 
474         return total;
475     }
476     
477     /**************************************************** Internal Admin - Validations **************************************************************/
478     
479     function _isValidLockupPeriod(uint8 n) internal pure returns (bool) {
480         if (n == 1) {
481             return true;
482         }
483         else if (n == 3) {
484             return true;
485         }
486         else if (n == 6) {
487             return true;
488         }
489         else if (n == 12) {
490             return true;
491         }
492         return false;
493     }
494 
495     function _isLockupPeriodFinished(uint256 _timestamp, uint8 _lockupPeriod) internal view returns (bool) {
496         return now > calculateFinishTimestamp(_timestamp, _lockupPeriod);
497     }
498 
499     /**************************************************** Internal Admin - Arrays **************************************************************/
500 
501     function _addStakerIfNotExist(address _staker) internal {
502         for (uint256 i = 0; i < stakers.length; i++) {
503             if (stakers[i] == _staker) {
504                 return;
505             }
506         }
507         stakers.push(_staker);
508     }
509 
510     function _findStaker(address _value) internal view returns(uint) {
511         uint i = 0;
512         while (stakers[i] != _value) {
513             i++;
514         }
515         return i;
516     }
517 
518     function _removeStakerByValue(address _value) internal {
519         uint i = _findStaker(_value);
520         _removeStakerByIndex(i);
521     }
522 
523     function _removeStakerByIndex(uint _i) internal {
524         while (_i<stakers.length-1) {
525             stakers[_i] = stakers[_i+1];
526             _i++;
527         }
528         stakers.length--;
529     }
530     
531     function _removeStakeByIndex(address _staker, uint _i) internal {
532         Stake[] storage stakes = stakeListBySender[_staker];
533         while (_i<stakes.length-1) {
534             stakes[_i] = stakes[_i+1];
535             _i++;
536         }
537         stakes.length--;
538     }
539 }
540 
541 library SafeMath {
542     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
543         c = a + b;
544         require(c >= a);
545         return c;
546     }
547 
548     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
549         if (a == 0) {
550             return 0;
551         }
552         c = a * b;
553         require(c / a == b);
554         return c;
555     }
556     
557     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
558         return sub(a, b, "SafeMath: subtraction overflow");
559     }
560     
561     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b <= a, errorMessage);
563         uint256 c = a - b;
564 
565         return c;
566     }
567     
568     function div(uint256 a, uint256 b) internal pure returns (uint256) {
569         return div(a, b, "SafeMath: division by zero");
570     }
571     
572     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
573         // Solidity only automatically asserts when dividing by 0
574         require(b > 0, errorMessage);
575         uint256 c = a / b;
576         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
577 
578         return c;
579     }
580 }