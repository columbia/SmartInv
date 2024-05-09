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
32     event StakeMigrated(address indexed staker, uint256 index);
33     event StakeFinishedByUser(address indexed staker, uint256 totalRecovered, uint256 index);
34     event StakeEnabledToBeFinished(address indexed staker, uint256 index);
35     event StakeRemoved(address indexed staker, uint256 totalRecovered, uint256 index);
36     event RewardsAccredited(address indexed staker, uint256 index, uint256 delta, uint256 total);
37     event StakeIncreased(address indexed staker, uint256 index, uint256 delta, uint256 total);
38     event RewardsWithdrawn(address indexed staker, uint256 index, uint256 total);
39     event TransferredToVestingAccount(uint256 total);
40 
41     /**************************************************** Vars and structs **************************************************************/
42     
43     address public owner;
44     IERC20 litionToken;
45     bool public paused = false;
46 
47     struct Stake {
48         uint256 createdOn;
49         uint256 totalStaked;
50         uint8 lockupPeriod;
51         bool compound;
52         uint256 rewards;
53         bool finished;
54     }
55     
56     address[] public stakers;
57     mapping (address => Stake[]) public stakeListBySender;
58 
59     /**************************************************** Admin **************************************************************/
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     constructor(IERC20 _litionToken) public {
67         owner = msg.sender;
68         litionToken = _litionToken;
69     }
70 
71     function _transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0), "New owner can't be the zero address");
73         owner = newOwner;
74     }
75     
76     function _switchPaused() public onlyOwner {
77         paused = !paused;
78     }
79 
80     function() external payable {
81         revert();
82     }
83 
84     /**************************************************** Public Interface for Stakers **************************************************************/
85 
86     function createNewStake(uint256 _amount, uint8 _lockupPeriod, bool _compound) public {
87         require(!paused, "New stakes are paused");
88         require(_isValidLockupPeriod(_lockupPeriod), "The lockup period is invalid");
89         require(_amount >= 5000000000000000000000, "You must stake at least 5000 LIT");
90         require(IERC20(litionToken).transferFrom(msg.sender, address(this), _amount), "Couldn't take the LIT from the sender");
91         
92         Stake memory stake = Stake({createdOn: now, 
93                                     totalStaked:_amount, 
94                                     lockupPeriod:_lockupPeriod, 
95                                     compound:_compound, 
96                                     rewards:0,
97                                     finished:false});
98                                     
99         Stake[] storage stakes = stakeListBySender[msg.sender];
100         stakes.push(stake);
101         _addStakerIfNotExist(msg.sender);
102         
103         emit NewStake(msg.sender, _amount, _lockupPeriod, _compound);
104     }
105     
106     function finishStake(uint256 _index) public {
107         require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");
108 
109         Stake memory stake = stakeListBySender[msg.sender][_index];
110 
111         require(stake.finished, "The stake is not finished yet");
112         
113         uint256 total = _closeStake(msg.sender, _index);
114         
115         emit StakeFinishedByUser(msg.sender, total, _index);
116     }
117     
118     function withdrawRewards(uint256 _index) public {
119         require(stakeListBySender[msg.sender].length > _index, "The stake doesn't exist");
120 
121         Stake storage stake = stakeListBySender[msg.sender][_index];
122 
123         require(stake.rewards > 0, "You don't have rewards to withdraw");
124         
125         uint256 total = stake.rewards;
126         stake.rewards = 0;
127 
128         require(litionToken.transfer(msg.sender, total));
129 
130         emit RewardsWithdrawn(msg.sender, _index, total);
131     }
132 
133     /**************************************************** Public Interface for Admin **************************************************************/
134 
135     function _accredit(address _staker, uint256 _index, uint256 _total) public onlyOwner {
136         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
137         require(IERC20(litionToken).transferFrom(msg.sender, address(this), _total), "Couldn't take the LIT from the sender");
138 
139         Stake storage stake = stakeListBySender[_staker][_index];
140         require(!stake.finished, "The stake is already finished");
141         
142         if (stake.compound) {
143             stake.totalStaked += _total;
144 
145             emit StakeIncreased(_staker, _index, _total, stake.totalStaked);
146         }
147         else {
148             stake.rewards += _total;
149 
150             emit RewardsAccredited(_staker, _index, _total, stake.rewards);
151         }
152         
153         if (_isLockupPeriodFinished(stake.createdOn, stake.lockupPeriod)) {
154             stake.finished = true;
155             
156             emit StakeEnabledToBeFinished(_staker, _index);
157         }
158     }
159     
160     function _forceFinishStake(address _staker, uint256 _index) public onlyOwner {
161         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
162         Stake storage stake = stakeListBySender[_staker][_index];
163         require(!stake.finished, "The stake is already finished");
164         stake.finished = true;
165         
166         emit StakeEnabledToBeFinished(_staker, _index);
167     }
168 
169     function _transferLITToVestingAccount(uint256 _total) public onlyOwner {
170         require(litionToken.transfer(msg.sender, _total));
171 
172         emit TransferredToVestingAccount(_total);
173     }
174     
175     function _extractLitSentByMistake(uint256 amount, address _sendTo) public onlyOwner {
176         require(litionToken.transfer(_sendTo, amount));
177     }
178 
179     function _removeStaker(address _staker, uint256 _index) public onlyOwner {
180         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
181         
182         uint256 total = _closeStake(_staker, _index);
183 
184         emit StakeRemoved(_staker, total, _index);
185     }
186 
187     /**************************************************** Pool Information **************************************************************/
188 
189     function getTotalInStake() public view returns (uint256) {
190         uint256 total = 0;
191         for (uint256 i = 0; i < stakers.length; i++) {
192             Stake[] memory stakes = stakeListBySender[stakers[i]];
193             for (uint256 j = 0; j < stakes.length; j++) {
194                 if (!stakes[j].finished) {
195                     total = total.add(stakes[j].totalStaked);
196                 }
197             }
198         }
199         return total;
200     }
201     
202     function getTotalStakes() public view returns (uint256) {
203         uint256 total = 0;
204         for (uint256 i = 0; i < stakers.length; i++) {
205             Stake[] memory stakes = stakeListBySender[stakers[i]];
206             for (uint256 j = 0; j < stakes.length; j++) {
207                 if (!stakes[j].finished) {
208                     total += 1;
209                 }
210             }
211         }
212         return total;
213     }
214     
215     function getTotalStakers() public view returns (uint256) {
216         return stakers.length;
217     }
218 
219     function getTotalStakesByStaker(address _staker) external view returns (uint256) {
220         return stakeListBySender[_staker].length;
221     }
222     
223     function getStake(address _staker, uint256 _index) external view returns (uint256 createdOn, uint256 totalStaked, uint8 lockupPeriod, bool compound, uint256 rewards, bool finished, uint256 lockupFinishes) {
224         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
225         Stake memory stake = stakeListBySender[_staker][_index];
226         createdOn = stake.createdOn;
227         totalStaked = stake.totalStaked;
228         lockupPeriod = stake.lockupPeriod;
229         compound = stake.compound;
230         rewards = stake.rewards;
231         finished = stake.finished;
232         lockupFinishes = getLockupFinishTimestamp(_staker, _index);
233     }
234 
235     function getLockupFinishTimestamp(address _staker, uint256 _index) public view returns (uint256) {
236         require(stakeListBySender[_staker].length > _index, "The stake doesn't exist");
237         Stake memory stake = stakeListBySender[_staker][_index];
238         return calculateFinishTimestamp(stake.createdOn, stake.lockupPeriod);
239     }
240 
241     /**************************************************** Internal Admin - Lockups **************************************************************/
242 
243     function calculateFinishTimestamp(uint256 _timestamp, uint8 _lockupPeriod) public pure returns (uint256) {
244         uint16 year = Date.getYear(_timestamp);
245         uint8 month = Date.getMonth(_timestamp);
246         month += _lockupPeriod;
247         if (month > 12) {
248             year += 1;
249             month = month % 12;
250         }
251         uint8 day = Date.getDay(_timestamp);
252         uint256 finishOn = Date.toTimestamp(year, month, day);
253         return finishOn;
254     }
255 
256     /**************************************************** Internal Admin - Stakes and Rewards **************************************************************/
257 
258     function _migrateStake(address _staker, uint256 _createdOn, uint256 _amount, uint8 _lockupPeriod, bool _compound, uint256 _rewards) public onlyOwner {
259         require(_isValidLockupPeriod(_lockupPeriod), "The lockup period is invalid");
260         
261         Stake memory stake = Stake({createdOn: _createdOn, 
262                                     totalStaked: _amount, 
263                                     lockupPeriod: _lockupPeriod, 
264                                     compound: _compound, 
265                                     rewards: _rewards,
266                                     finished: false});
267                                     
268         Stake[] storage stakes = stakeListBySender[_staker];
269         stakes.push(stake);
270         _addStakerIfNotExist(_staker);
271         
272         emit StakeMigrated(_staker, stakeListBySender[_staker].length - 1);
273     }
274     
275     function _closeStake(address _staker, uint256 _index) internal returns (uint256) {
276         uint256 totalStaked = stakeListBySender[_staker][_index].totalStaked;
277         uint256 total = totalStaked + stakeListBySender[_staker][_index].rewards;
278         
279         _removeStakeByIndex(_staker, _index);
280         if (stakeListBySender[_staker].length == 0) {
281             _removeStakerByValue(_staker);
282         }
283         
284         require(litionToken.transfer(_staker, total));
285 
286         return total;
287     }
288     
289     /**************************************************** Internal Admin - Validations **************************************************************/
290     
291     function _isValidLockupPeriod(uint8 n) internal pure returns (bool) {
292         if (n == 1) {
293             return true;
294         }
295         else if (n == 3) {
296             return true;
297         }
298         else if (n == 6) {
299             return true;
300         }
301         else if (n == 12) {
302             return true;
303         }
304         return false;
305     }
306 
307     function _isLockupPeriodFinished(uint256 _timestamp, uint8 _lockupPeriod) internal view returns (bool) {
308         return now > calculateFinishTimestamp(_timestamp, _lockupPeriod);
309     }
310 
311     /**************************************************** Internal Admin - Arrays **************************************************************/
312 
313     function _addStakerIfNotExist(address _staker) internal {
314         for (uint256 i = 0; i < stakers.length; i++) {
315             if (stakers[i] == _staker) {
316                 return;
317             }
318         }
319         stakers.push(_staker);
320     }
321 
322     function _findStaker(address _value) internal view returns(uint) {
323         uint i = 0;
324         while (stakers[i] != _value) {
325             i++;
326         }
327         return i;
328     }
329 
330     function _removeStakerByValue(address _value) internal {
331         uint i = _findStaker(_value);
332         _removeStakerByIndex(i);
333     }
334 
335     function _removeStakerByIndex(uint _i) internal {
336         while (_i<stakers.length-1) {
337             stakers[_i] = stakers[_i+1];
338             _i++;
339         }
340         stakers.length--;
341     }
342     
343     function _removeStakeByIndex(address _staker, uint _i) internal {
344         Stake[] storage stakes = stakeListBySender[_staker];
345         while (_i<stakes.length-1) {
346             stakes[_i] = stakes[_i+1];
347             _i++;
348         }
349         stakes.length--;
350     }
351 }
352 
353 library SafeMath {
354     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
355         c = a + b;
356         require(c >= a);
357         return c;
358     }
359 
360     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
361         if (a == 0) {
362             return 0;
363         }
364         c = a * b;
365         require(c / a == b);
366         return c;
367     }
368     
369     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
370         return sub(a, b, "SafeMath: subtraction overflow");
371     }
372     
373     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b <= a, errorMessage);
375         uint256 c = a - b;
376 
377         return c;
378     }
379     
380     function div(uint256 a, uint256 b) internal pure returns (uint256) {
381         return div(a, b, "SafeMath: division by zero");
382     }
383     
384     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
385         // Solidity only automatically asserts when dividing by 0
386         require(b > 0, errorMessage);
387         uint256 c = a / b;
388         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
389 
390         return c;
391     }
392 }
393 
394 library Date {
395     struct _Date {
396         uint16 year;
397         uint8 month;
398         uint8 day;
399     }
400 
401     uint constant DAY_IN_SECONDS = 86400;
402     uint constant YEAR_IN_SECONDS = 31536000;
403     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
404 
405     uint16 constant ORIGIN_YEAR = 1970;
406 
407     function isLeapYear(uint16 year) public pure returns (bool) {
408         if (year % 4 != 0) {
409                 return false;
410         }
411         if (year % 100 != 0) {
412                 return true;
413         }
414         if (year % 400 != 0) {
415                 return false;
416         }
417         return true;
418     }
419 
420     function leapYearsBefore(uint year) public pure returns (uint) {
421         year -= 1;
422         return year / 4 - year / 100 + year / 400;
423     }
424 
425     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
426         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
427                 return 31;
428         }
429         else if (month == 4 || month == 6 || month == 9 || month == 11) {
430                 return 30;
431         }
432         else if (isLeapYear(year)) {
433                 return 29;
434         }
435         else {
436                 return 28;
437         }
438     }
439 
440     function parseTimestamp(uint timestamp) internal pure returns (_Date memory dt) {
441         uint secondsAccountedFor = 0;
442         uint buf;
443         uint8 i;
444 
445         // Year
446         dt.year = getYear(timestamp);
447         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
448 
449         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
450         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
451 
452         // Month
453         uint secondsInMonth;
454         for (i = 1; i <= 12; i++) {
455                 secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
456                 if (secondsInMonth + secondsAccountedFor > timestamp) {
457                         dt.month = i;
458                         break;
459                 }
460                 secondsAccountedFor += secondsInMonth;
461         }
462 
463         // Day
464         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
465                 if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
466                         dt.day = i;
467                         break;
468                 }
469                 secondsAccountedFor += DAY_IN_SECONDS;
470         }
471     }
472 
473     function getYear(uint timestamp) public pure returns (uint16) {
474         uint secondsAccountedFor = 0;
475         uint16 year;
476         uint numLeapYears;
477 
478         // Year
479         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
480         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
481 
482         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
483         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
484 
485         while (secondsAccountedFor > timestamp) {
486                 if (isLeapYear(uint16(year - 1))) {
487                         secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
488                 }
489                 else {
490                         secondsAccountedFor -= YEAR_IN_SECONDS;
491                 }
492                 year -= 1;
493         }
494         return year;
495     }
496 
497     function getMonth(uint timestamp) public pure returns (uint8) {
498         return parseTimestamp(timestamp).month;
499     }
500 
501     function getDay(uint timestamp) public pure returns (uint8) {
502         return parseTimestamp(timestamp).day;
503     }
504 
505     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
506         uint16 i;
507 
508         // Year
509         for (i = ORIGIN_YEAR; i < year; i++) {
510                 if (isLeapYear(i)) {
511                         timestamp += LEAP_YEAR_IN_SECONDS;
512                 }
513                 else {
514                         timestamp += YEAR_IN_SECONDS;
515                 }
516         }
517 
518         // Month
519         uint8[12] memory monthDayCounts;
520         monthDayCounts[0] = 31;
521         if (isLeapYear(year)) {
522                 monthDayCounts[1] = 29;
523         }
524         else {
525                 monthDayCounts[1] = 28;
526         }
527         monthDayCounts[2] = 31;
528         monthDayCounts[3] = 30;
529         monthDayCounts[4] = 31;
530         monthDayCounts[5] = 30;
531         monthDayCounts[6] = 31;
532         monthDayCounts[7] = 31;
533         monthDayCounts[8] = 30;
534         monthDayCounts[9] = 31;
535         monthDayCounts[10] = 30;
536         monthDayCounts[11] = 31;
537 
538         for (i = 1; i < month; i++) {
539                 timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
540         }
541 
542         // Day
543         timestamp += DAY_IN_SECONDS * (day - 1);
544 
545         return timestamp;
546     }
547 }