1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract ReentrancyGuard {
18 
19   /**
20    * @dev We use a single lock for the whole contract.
21    */
22   bool private rentrancy_lock = false;
23 
24   /**
25    * @dev Prevents a contract from calling itself, directly or indirectly.
26    * @notice If you mark a function `nonReentrant`, you should also
27    * mark it `external`. Calling one nonReentrant function from
28    * another is not supported. Instead, you can implement a
29    * `private` function doing the actual work, and a `external`
30    * wrapper marked as `nonReentrant`.
31    */
32   modifier nonReentrant() {
33     require(!rentrancy_lock);
34     rentrancy_lock = true;
35     _;
36     rentrancy_lock = false;
37   }
38 
39 }
40 
41 contract Ownable {
42   address public owner;
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner {
68     require(newOwner != address(0));
69     owner = newOwner;
70   }
71 
72 }
73 
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() onlyPendingOwner {
97     owner = pendingOwner;
98     pendingOwner = 0x0;
99   }
100 }
101 
102 contract Operational is Claimable {
103     address public operator;
104 
105     function Operational(address _operator) {
106       operator = _operator;
107     }
108 
109     modifier onlyOperator() {
110       require(msg.sender == operator);
111       _;
112     }
113 
114     function transferOperator(address newOperator) onlyOwner {
115       require(newOperator != address(0));
116       operator = newOperator;
117     }
118 
119 }
120 
121 library SafeMath {
122   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
123     uint256 c = a * b;
124     assert(a == 0 || c / a == b);
125     return c;
126   }
127 
128   function div(uint256 a, uint256 b) internal constant returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   function add(uint256 a, uint256 b) internal constant returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
146 
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) returns (bool) {
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) constant returns (uint256 balance) {
170     return balances[_owner];
171   }
172 
173 }
174 
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amout of tokens to be transfered
185    */
186   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
187     var _allowance = allowed[_from][msg.sender];
188 
189     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190     // require (_value <= _allowance);
191 
192     balances[_to] = balances[_to].add(_value);
193     balances[_from] = balances[_from].sub(_value);
194     allowed[_from][msg.sender] = _allowance.sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   function batchTransfer(address[] _to, uint256[] _bonus) returns(bool) {
200         for(uint i = 0; i < _to.length; i++){
201             require(transfer(_to[i], _bonus[i]));
202         }
203         return true;
204   }
205 
206   /**
207    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) returns (bool) {
212 
213     // To change the approve amount you first have to reduce the addresses`
214     //  allowance to zero by calling `approve(_spender, 0)` if it is not
215     //  already 0 to mitigate the race condition described here:
216     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
218 
219     allowed[msg.sender][_spender] = _value;
220     Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifing the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
231     return allowed[_owner][_spender];
232   }
233 
234 }
235 
236 contract LockableToken is StandardToken, ReentrancyGuard {
237 
238     struct LockedBalance {
239         address owner;
240         uint256 value;
241         uint256 releaseTime;
242     }
243 
244     mapping (uint => LockedBalance) public lockedBalances;
245     uint public lockedBalanceCount;
246 
247     event TransferLockedToken(address indexed from, address indexed to, uint256 value, uint256 releaseTime);
248     event ReleaseLockedBalance(address indexed owner, uint256 value, uint256 releaseTime);
249 
250     
251     function transferLockedToken(address _to, uint256 _value, uint256 _releaseTime) nonReentrant returns (bool) {
252         require(_releaseTime > now);
253         require(_releaseTime.sub(1 years) < now);
254         balances[msg.sender] = balances[msg.sender].sub(_value);
255         lockedBalances[lockedBalanceCount] = LockedBalance({owner: _to, value: _value, releaseTime: _releaseTime});
256         lockedBalanceCount++;
257         TransferLockedToken(msg.sender, _to, _value, _releaseTime);
258         return true;
259     }
260 
261     
262     function lockedBalanceOf(address _owner) constant returns (uint256 value) {
263         for (uint i = 0; i < lockedBalanceCount; i++) {
264             LockedBalance lockedBalance = lockedBalances[i];
265             if (_owner == lockedBalance.owner) {
266                 value = value.add(lockedBalance.value);
267             }
268         }
269         return value;
270     }
271 
272     
273     function releaseLockedBalance () returns (uint256 releaseAmount) {
274         uint index = 0;
275         while (index < lockedBalanceCount) {
276             if (now >= lockedBalances[index].releaseTime) {
277                 releaseAmount += lockedBalances[index].value;
278                 unlockBalanceByIndex(index);
279             } else {
280                 index++;
281             }
282         }
283         return releaseAmount;
284     }
285 
286     function unlockBalanceByIndex (uint index) internal {
287         LockedBalance lockedBalance = lockedBalances[index];
288         balances[lockedBalance.owner] = balances[lockedBalance.owner].add(lockedBalance.value);
289         ReleaseLockedBalance(lockedBalance.owner, lockedBalance.value, lockedBalance.releaseTime);
290         lockedBalances[index] = lockedBalances[lockedBalanceCount - 1];
291         delete lockedBalances[lockedBalanceCount - 1];
292         lockedBalanceCount--;
293     }
294 
295 }
296 
297 library DateTime {
298         /*
299          *  Date and Time utilities for ethereum contracts
300          *
301          */
302         struct DateTime {
303                 uint16 year;
304                 uint8 month;
305                 uint8 day;
306                 uint8 hour;
307                 uint8 minute;
308                 uint8 second;
309                 uint8 weekday;
310         }
311 
312         uint constant DAY_IN_SECONDS = 86400;
313         uint constant YEAR_IN_SECONDS = 31536000;
314         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
315 
316         uint constant HOUR_IN_SECONDS = 3600;
317         uint constant MINUTE_IN_SECONDS = 60;
318 
319         uint16 constant ORIGIN_YEAR = 1970;
320 
321         function isLeapYear(uint16 year) constant returns (bool) {
322                 if (year % 4 != 0) {
323                         return false;
324                 }
325                 if (year % 100 != 0) {
326                         return true;
327                 }
328                 if (year % 400 != 0) {
329                         return false;
330                 }
331                 return true;
332         }
333 
334         function leapYearsBefore(uint year) constant returns (uint) {
335                 year -= 1;
336                 return year / 4 - year / 100 + year / 400;
337         }
338 
339         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
340                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
341                         return 31;
342                 }
343                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
344                         return 30;
345                 }
346                 else if (isLeapYear(year)) {
347                         return 29;
348                 }
349                 else {
350                         return 28;
351                 }
352         }
353 
354         function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
355                 uint secondsAccountedFor = 0;
356                 uint buf;
357                 uint8 i;
358 
359                 // Year
360                 dt.year = getYear(timestamp);
361                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
362 
363                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
364                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
365 
366                 // Month
367                 uint secondsInMonth;
368                 for (i = 1; i <= 12; i++) {
369                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
370                         if (secondsInMonth + secondsAccountedFor > timestamp) {
371                                 dt.month = i;
372                                 break;
373                         }
374                         secondsAccountedFor += secondsInMonth;
375                 }
376 
377                 // Day
378                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
379                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
380                                 dt.day = i;
381                                 break;
382                         }
383                         secondsAccountedFor += DAY_IN_SECONDS;
384                 }
385 
386                 // Hour
387                 dt.hour = 0;//getHour(timestamp);
388 
389                 // Minute
390                 dt.minute = 0;//getMinute(timestamp);
391 
392                 // Second
393                 dt.second = 0;//getSecond(timestamp);
394 
395                 // Day of week.
396                 dt.weekday = 0;//getWeekday(timestamp);
397 
398         }
399 
400         function getYear(uint timestamp) constant returns (uint16) {
401                 uint secondsAccountedFor = 0;
402                 uint16 year;
403                 uint numLeapYears;
404 
405                 // Year
406                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
407                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
408 
409                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
410                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
411 
412                 while (secondsAccountedFor > timestamp) {
413                         if (isLeapYear(uint16(year - 1))) {
414                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
415                         }
416                         else {
417                                 secondsAccountedFor -= YEAR_IN_SECONDS;
418                         }
419                         year -= 1;
420                 }
421                 return year;
422         }
423 
424         function getMonth(uint timestamp) constant returns (uint8) {
425                 return parseTimestamp(timestamp).month;
426         }
427 
428         function getDay(uint timestamp) constant returns (uint8) {
429                 return parseTimestamp(timestamp).day;
430         }
431 
432         function getHour(uint timestamp) constant returns (uint8) {
433                 return uint8((timestamp / 60 / 60) % 24);
434         }
435 
436         function getMinute(uint timestamp) constant returns (uint8) {
437                 return uint8((timestamp / 60) % 60);
438         }
439 
440         function getSecond(uint timestamp) constant returns (uint8) {
441                 return uint8(timestamp % 60);
442         }
443 
444         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
445                 return toTimestamp(year, month, day, 0, 0, 0);
446         }
447 
448         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
449                 uint16 i;
450 
451                 // Year
452                 for (i = ORIGIN_YEAR; i < year; i++) {
453                         if (isLeapYear(i)) {
454                                 timestamp += LEAP_YEAR_IN_SECONDS;
455                         }
456                         else {
457                                 timestamp += YEAR_IN_SECONDS;
458                         }
459                 }
460 
461                 // Month
462                 uint8[12] memory monthDayCounts;
463                 monthDayCounts[0] = 31;
464                 if (isLeapYear(year)) {
465                         monthDayCounts[1] = 29;
466                 }
467                 else {
468                         monthDayCounts[1] = 28;
469                 }
470                 monthDayCounts[2] = 31;
471                 monthDayCounts[3] = 30;
472                 monthDayCounts[4] = 31;
473                 monthDayCounts[5] = 30;
474                 monthDayCounts[6] = 31;
475                 monthDayCounts[7] = 31;
476                 monthDayCounts[8] = 30;
477                 monthDayCounts[9] = 31;
478                 monthDayCounts[10] = 30;
479                 monthDayCounts[11] = 31;
480 
481                 for (i = 1; i < month; i++) {
482                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
483                 }
484 
485                 // Day
486                 timestamp += DAY_IN_SECONDS * (day - 1);
487 
488                 // Hour
489                 timestamp += HOUR_IN_SECONDS * (hour);
490 
491                 // Minute
492                 timestamp += MINUTE_IN_SECONDS * (minute);
493 
494                 // Second
495                 timestamp += second;
496 
497                 return timestamp;
498         }
499 }
500 
501 contract ReleaseableToken is Operational, LockableToken {
502     using SafeMath for uint;
503     using DateTime for uint256;
504     bool secondYearUpdate = false; 
505     uint256 public releasedSupply; 
506     uint256 public createTime; 
507     uint256 standardDecimals = 100000000; 
508     uint256 public totalSupply = standardDecimals.mul(1000000000);
509     uint256 public limitSupplyPerYear = standardDecimals.mul(60000000);
510     uint256 public dailyLimit = standardDecimals.mul(1000000);
511 
512     event ReleaseSupply(address receiver, uint256 value, uint256 releaseTime);
513     event UnfreezeAmount(address receiver, uint256 amount, uint256 unfreezeTime);
514 
515     struct FrozenRecord {
516         uint256 amount; 
517         uint256 unfreezeTime; 
518     }
519 
520     mapping (uint => FrozenRecord) public frozenRecords;
521     uint public frozenRecordsCount = 0;
522 
523     function ReleaseableToken(
524                     uint256 initialSupply,
525                     uint256 initReleasedSupply,
526                     address operator
527                 ) Operational(operator) {
528         totalSupply = initialSupply;
529         releasedSupply = initReleasedSupply;
530         createTime = now;
531         balances[msg.sender] = initReleasedSupply;
532     }
533 
534     
535     function releaseSupply(uint256 releaseAmount, uint256 timestamp) onlyOperator returns(uint256 _actualRelease) {
536         require(timestamp >= createTime && timestamp <= now);
537         require(!judgeReleaseRecordExist(timestamp));
538         require(releaseAmount <= dailyLimit);
539         updateLimit();
540         require(limitSupplyPerYear > 0);
541         if (releaseAmount > limitSupplyPerYear) {
542             if (releasedSupply.add(limitSupplyPerYear) > totalSupply) {
543                 releasedSupply = totalSupply;
544                 releaseAmount = totalSupply.sub(releasedSupply);
545             } else {
546                 releasedSupply = releasedSupply.add(limitSupplyPerYear);
547                 releaseAmount = limitSupplyPerYear;
548             }
549             limitSupplyPerYear = 0;
550         } else {
551             if (releasedSupply.add(releaseAmount) > totalSupply) {
552                 releasedSupply = totalSupply;
553                 releaseAmount = totalSupply.sub(releasedSupply);
554             } else {
555                 releasedSupply = releasedSupply.add(releaseAmount);
556             }
557             limitSupplyPerYear = limitSupplyPerYear.sub(releaseAmount);
558         }
559         frozenRecords[frozenRecordsCount] = FrozenRecord(releaseAmount, timestamp.add(26 * 1 weeks));
560         frozenRecordsCount++;
561         ReleaseSupply(msg.sender, releaseAmount, timestamp);
562         return releaseAmount;
563     }
564 
565     
566     function judgeReleaseRecordExist(uint256 timestamp) internal returns(bool _exist) {
567         bool exist = false;
568         if (frozenRecordsCount > 0) {
569             for (uint index = 0; index < frozenRecordsCount; index++) {
570                 if ((frozenRecords[index].unfreezeTime.parseTimestamp().year == (timestamp.add(26 * 1 weeks)).parseTimestamp().year)
571                     && (frozenRecords[index].unfreezeTime.parseTimestamp().month == (timestamp.add(26 * 1 weeks)).parseTimestamp().month)
572                     && (frozenRecords[index].unfreezeTime.parseTimestamp().day == (timestamp.add(26 * 1 weeks)).parseTimestamp().day)) {
573                     exist = true;
574                 }
575             }
576         }
577         return exist;
578     }
579 
580     
581     function updateLimit() internal {
582         if (createTime.add(1 years) < now && !secondYearUpdate) {
583             limitSupplyPerYear = standardDecimals.mul(120000000);
584             secondYearUpdate = true;
585         }
586         if (createTime.add(2 * 1 years) < now) {
587             if (releasedSupply < totalSupply) {
588                 limitSupplyPerYear = totalSupply.sub(releasedSupply);
589             }
590         }
591     }
592 
593     
594     function unfreeze() onlyOperator returns(uint256 _unfreezeAmount) {
595         uint256 unfreezeAmount = 0;
596         uint index = 0;
597         while (index < frozenRecordsCount) {
598             if (frozenRecords[index].unfreezeTime < now) {
599                 unfreezeAmount += frozenRecords[index].amount;
600                 unfreezeByIndex(index);
601             } else {
602                 index++;
603             }
604         }
605         return unfreezeAmount;
606     }
607 
608     function unfreezeByIndex (uint index) internal {
609         FrozenRecord unfreezeRecord = frozenRecords[index];
610         balances[owner] = balances[owner].add(unfreezeRecord.amount);
611         UnfreezeAmount(owner, unfreezeRecord.amount, unfreezeRecord.unfreezeTime);
612         frozenRecords[index] = frozenRecords[frozenRecordsCount - 1];
613         delete frozenRecords[frozenRecordsCount - 1];
614         frozenRecordsCount--;
615     }
616 
617     
618     function setDailyLimit(uint256 _dailyLimit) onlyOwner {
619         dailyLimit = _dailyLimit;
620     }
621 }
622 
623 contract Snetwork is ReleaseableToken {
624     string public standard = '2018011701';
625     string public name = 'Snetwork';
626     string public symbol = 'SNET';
627     uint8 public decimals = 8;
628 
629     function Snetwork(
630                      uint256 initialSupply,
631                      uint256 initReleasedSupply,
632                      address operator
633                      ) ReleaseableToken(initialSupply, initReleasedSupply, operator) {}
634 }