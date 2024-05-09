1 pragma solidity ^0.4.13;
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
199   /**
200    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) returns (bool) {
205 
206     // To change the approve amount you first have to reduce the addresses`
207     //  allowance to zero by calling `approve(_spender, 0)` if it is not
208     //  already 0 to mitigate the race condition described here:
209     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
211 
212     allowed[msg.sender][_spender] = _value;
213     Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifing the amount of tokens still available for the spender.
222    */
223   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
224     return allowed[_owner][_spender];
225   }
226 
227 }
228 
229 contract LockableToken is StandardToken, ReentrancyGuard {
230 
231     struct LockedBalance {
232         address owner;
233         uint256 value;
234         uint256 releaseTime;
235     }
236 
237     mapping (uint => LockedBalance) public lockedBalances;
238     uint public lockedBalanceCount;
239 
240     event TransferLockedToken(address indexed from, address indexed to, uint256 value, uint256 releaseTime);
241     event ReleaseLockedBalance(address indexed owner, uint256 value, uint256 releaseTime);
242 
243     // ç» _to è½¬ç§» _value ä¸ªéå®å° _releaseTime ç token
244     function transferLockedToken(address _to, uint256 _value, uint256 _releaseTime) nonReentrant returns (bool) {
245         require(_releaseTime > now);
246         require(_releaseTime.sub(1 years) < now);
247         balances[msg.sender] = balances[msg.sender].sub(_value);
248         lockedBalances[lockedBalanceCount] = LockedBalance({owner: _to, value: _value, releaseTime: _releaseTime});
249         lockedBalanceCount++;
250         TransferLockedToken(msg.sender, _to, _value, _releaseTime);
251         return true;
252     }
253 
254     // æ¥ address çéå®ä½é¢
255     function lockedBalanceOf(address _owner) constant returns (uint256 value) {
256         for (uint i = 0; i < lockedBalanceCount; i++) {
257             LockedBalance lockedBalance = lockedBalances[i];
258             if (_owner == lockedBalance.owner) {
259                 value = value.add(lockedBalance.value);
260             }
261         }
262         return value;
263     }
264 
265     // è§£éææå·²å°éå®æ¶é´ç token
266     function releaseLockedBalance () returns (uint256 releaseAmount) {
267         uint index = 0;
268         while (index < lockedBalanceCount) {
269             if (now >= lockedBalances[index].releaseTime) {
270                 releaseAmount += lockedBalances[index].value;
271                 unlockBalanceByIndex(index);
272             } else {
273                 index++;
274             }
275         }
276         return releaseAmount;
277     }
278 
279     function unlockBalanceByIndex (uint index) internal {
280         LockedBalance lockedBalance = lockedBalances[index];
281         balances[lockedBalance.owner] = balances[lockedBalance.owner].add(lockedBalance.value);
282         ReleaseLockedBalance(lockedBalance.owner, lockedBalance.value, lockedBalance.releaseTime);
283         lockedBalances[index] = lockedBalances[lockedBalanceCount - 1];
284         delete lockedBalances[lockedBalanceCount - 1];
285         lockedBalanceCount--;
286     }
287 
288 }
289 
290 library DateTime {
291         /*
292          *  Date and Time utilities for ethereum contracts
293          *
294          */
295         struct DateTime {
296                 uint16 year;
297                 uint8 month;
298                 uint8 day;
299                 uint8 hour;
300                 uint8 minute;
301                 uint8 second;
302                 uint8 weekday;
303         }
304 
305         uint constant DAY_IN_SECONDS = 86400;
306         uint constant YEAR_IN_SECONDS = 31536000;
307         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
308 
309         uint constant HOUR_IN_SECONDS = 3600;
310         uint constant MINUTE_IN_SECONDS = 60;
311 
312         uint16 constant ORIGIN_YEAR = 1970;
313 
314         function isLeapYear(uint16 year) constant returns (bool) {
315                 if (year % 4 != 0) {
316                         return false;
317                 }
318                 if (year % 100 != 0) {
319                         return true;
320                 }
321                 if (year % 400 != 0) {
322                         return false;
323                 }
324                 return true;
325         }
326 
327         function leapYearsBefore(uint year) constant returns (uint) {
328                 year -= 1;
329                 return year / 4 - year / 100 + year / 400;
330         }
331 
332         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
333                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
334                         return 31;
335                 }
336                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
337                         return 30;
338                 }
339                 else if (isLeapYear(year)) {
340                         return 29;
341                 }
342                 else {
343                         return 28;
344                 }
345         }
346 
347         function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
348                 uint secondsAccountedFor = 0;
349                 uint buf;
350                 uint8 i;
351 
352                 // Year
353                 dt.year = getYear(timestamp);
354                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
355 
356                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
357                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
358 
359                 // Month
360                 uint secondsInMonth;
361                 for (i = 1; i <= 12; i++) {
362                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
363                         if (secondsInMonth + secondsAccountedFor > timestamp) {
364                                 dt.month = i;
365                                 break;
366                         }
367                         secondsAccountedFor += secondsInMonth;
368                 }
369 
370                 // Day
371                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
372                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
373                                 dt.day = i;
374                                 break;
375                         }
376                         secondsAccountedFor += DAY_IN_SECONDS;
377                 }
378 
379                 // Hour
380                 dt.hour = 0;//getHour(timestamp);
381 
382                 // Minute
383                 dt.minute = 0;//getMinute(timestamp);
384 
385                 // Second
386                 dt.second = 0;//getSecond(timestamp);
387 
388                 // Day of week.
389                 dt.weekday = 0;//getWeekday(timestamp);
390 
391         }
392 
393         function getYear(uint timestamp) constant returns (uint16) {
394                 uint secondsAccountedFor = 0;
395                 uint16 year;
396                 uint numLeapYears;
397 
398                 // Year
399                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
400                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
401 
402                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
403                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
404 
405                 while (secondsAccountedFor > timestamp) {
406                         if (isLeapYear(uint16(year - 1))) {
407                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
408                         }
409                         else {
410                                 secondsAccountedFor -= YEAR_IN_SECONDS;
411                         }
412                         year -= 1;
413                 }
414                 return year;
415         }
416 
417         function getMonth(uint timestamp) constant returns (uint8) {
418                 return parseTimestamp(timestamp).month;
419         }
420 
421         function getDay(uint timestamp) constant returns (uint8) {
422                 return parseTimestamp(timestamp).day;
423         }
424 
425         function getHour(uint timestamp) constant returns (uint8) {
426                 return uint8((timestamp / 60 / 60) % 24);
427         }
428 
429         function getMinute(uint timestamp) constant returns (uint8) {
430                 return uint8((timestamp / 60) % 60);
431         }
432 
433         function getSecond(uint timestamp) constant returns (uint8) {
434                 return uint8(timestamp % 60);
435         }
436 
437         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
438                 return toTimestamp(year, month, day, 0, 0, 0);
439         }
440 
441         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
442                 uint16 i;
443 
444                 // Year
445                 for (i = ORIGIN_YEAR; i < year; i++) {
446                         if (isLeapYear(i)) {
447                                 timestamp += LEAP_YEAR_IN_SECONDS;
448                         }
449                         else {
450                                 timestamp += YEAR_IN_SECONDS;
451                         }
452                 }
453 
454                 // Month
455                 uint8[12] memory monthDayCounts;
456                 monthDayCounts[0] = 31;
457                 if (isLeapYear(year)) {
458                         monthDayCounts[1] = 29;
459                 }
460                 else {
461                         monthDayCounts[1] = 28;
462                 }
463                 monthDayCounts[2] = 31;
464                 monthDayCounts[3] = 30;
465                 monthDayCounts[4] = 31;
466                 monthDayCounts[5] = 30;
467                 monthDayCounts[6] = 31;
468                 monthDayCounts[7] = 31;
469                 monthDayCounts[8] = 30;
470                 monthDayCounts[9] = 31;
471                 monthDayCounts[10] = 30;
472                 monthDayCounts[11] = 31;
473 
474                 for (i = 1; i < month; i++) {
475                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
476                 }
477 
478                 // Day
479                 timestamp += DAY_IN_SECONDS * (day - 1);
480 
481                 // Hour
482                 timestamp += HOUR_IN_SECONDS * (hour);
483 
484                 // Minute
485                 timestamp += MINUTE_IN_SECONDS * (minute);
486 
487                 // Second
488                 timestamp += second;
489 
490                 return timestamp;
491         }
492 }
493 
494 contract ReleaseableToken is Operational, LockableToken {
495     using SafeMath for uint;
496     using DateTime for uint256;
497     bool secondYearUpdate = false; // Limit æ´æ°å°ç¬¬äºå¹´
498     uint256 public releasedSupply; // å·²éæ¾çæ°é
499     uint256 public createTime; // åçº¦åå»ºæ¶é´
500     uint256 standardDecimals = 100000000; // ç±äºæ8ä½å°æ°ï¼ä¼ è¿æ¥çåæ°é½æ¯ä¸å¸¦åé¢çå°æ°ï¼è¦æä¹100000000çæä½æè½ä¿è¯æ°éçº§ä¸è´
501     uint256 public totalSupply = standardDecimals.mul(1000000000); // æ»é10äº¿
502     uint256 public limitSupplyPerYear = standardDecimals.mul(60000000); // æ¯å¹´éæ¾çLLTçéé¢ï¼ç¬¬ä¸å¹´6000ä¸
503     uint256 public dailyLimit = standardDecimals.mul(1000000); // æ¯å¤©éæ¾çéé¢
504 
505     event ReleaseSupply(address receiver, uint256 value, uint256 releaseTime);
506     event UnfreezeAmount(address receiver, uint256 amount, uint256 unfreezeTime);
507 
508     struct FrozenRecord {
509         uint256 amount; // å»ç»çæ°é
510         uint256 unfreezeTime; // è§£å»çæ¶é´
511     }
512 
513     mapping (uint => FrozenRecord) public frozenRecords;
514     uint public frozenRecordsCount = 0;
515 
516     function ReleaseableToken(
517                     uint256 initialSupply,
518                     uint256 initReleasedSupply,
519                     address operator
520                 ) Operational(operator) {
521         totalSupply = initialSupply;
522         releasedSupply = initReleasedSupply;
523         createTime = now;
524         balances[msg.sender] = initReleasedSupply;
525     }
526 
527     // å¨ timestamp æ¶é´ç¹éæ¾ releaseAmount ç token
528     function releaseSupply(uint256 releaseAmount, uint256 timestamp) onlyOperator returns(uint256 _actualRelease) {
529         require(timestamp >= createTime && timestamp <= now);
530         require(!judgeReleaseRecordExist(timestamp));
531         require(releaseAmount <= dailyLimit);
532         updateLimit();
533         require(limitSupplyPerYear > 0);
534         if (releaseAmount > limitSupplyPerYear) {
535             if (releasedSupply.add(limitSupplyPerYear) > totalSupply) {
536                 releasedSupply = totalSupply;
537                 releaseAmount = totalSupply.sub(releasedSupply);
538             } else {
539                 releasedSupply = releasedSupply.add(limitSupplyPerYear);
540                 releaseAmount = limitSupplyPerYear;
541             }
542             limitSupplyPerYear = 0;
543         } else {
544             if (releasedSupply.add(releaseAmount) > totalSupply) {
545                 releasedSupply = totalSupply;
546                 releaseAmount = totalSupply.sub(releasedSupply);
547             } else {
548                 releasedSupply = releasedSupply.add(releaseAmount);
549             }
550             limitSupplyPerYear = limitSupplyPerYear.sub(releaseAmount);
551         }
552         frozenRecords[frozenRecordsCount] = FrozenRecord(releaseAmount, timestamp.add(26 * 1 weeks));
553         frozenRecordsCount++;
554         ReleaseSupply(msg.sender, releaseAmount, timestamp);
555         return releaseAmount;
556     }
557 
558     // å¤æ­ timestamp è¿ä¸å¤©ææ²¡æå·²ç»éæ¾çè®°å½
559     function judgeReleaseRecordExist(uint256 timestamp) internal returns(bool _exist) {
560         bool exist = false;
561         if (frozenRecordsCount > 0) {
562             for (uint index = 0; index < frozenRecordsCount; index++) {
563                 if ((frozenRecords[index].unfreezeTime.parseTimestamp().year == (timestamp.add(26 * 1 weeks)).parseTimestamp().year)
564                     && (frozenRecords[index].unfreezeTime.parseTimestamp().month == (timestamp.add(26 * 1 weeks)).parseTimestamp().month)
565                     && (frozenRecords[index].unfreezeTime.parseTimestamp().day == (timestamp.add(26 * 1 weeks)).parseTimestamp().day)) {
566                     exist = true;
567                 }
568             }
569         }
570         return exist;
571     }
572 
573     // æ´æ°æ¯å¹´éæ¾tokençéå¶æ°é
574     function updateLimit() internal {
575         if (createTime.add(1 years) < now && !secondYearUpdate) {
576             limitSupplyPerYear = standardDecimals.mul(120000000);
577             secondYearUpdate = true;
578         }
579         if (createTime.add(2 * 1 years) < now) {
580             if (releasedSupply < totalSupply) {
581                 limitSupplyPerYear = totalSupply.sub(releasedSupply);
582             }
583         }
584     }
585 
586     // è§£å» releaseSupply ä¸­éæ¾ç token
587     function unfreeze() onlyOperator returns(uint256 _unfreezeAmount) {
588         uint256 unfreezeAmount = 0;
589         uint index = 0;
590         while (index < frozenRecordsCount) {
591             if (frozenRecords[index].unfreezeTime < now) {
592                 unfreezeAmount += frozenRecords[index].amount;
593                 unfreezeByIndex(index);
594             } else {
595                 index++;
596             }
597         }
598         return unfreezeAmount;
599     }
600 
601     function unfreezeByIndex (uint index) internal {
602         FrozenRecord unfreezeRecord = frozenRecords[index];
603         balances[owner] = balances[owner].add(unfreezeRecord.amount);
604         UnfreezeAmount(owner, unfreezeRecord.amount, unfreezeRecord.unfreezeTime);
605         frozenRecords[index] = frozenRecords[frozenRecordsCount - 1];
606         delete frozenRecords[frozenRecordsCount - 1];
607         frozenRecordsCount--;
608     }
609 
610     // è®¾ç½®æ¯å¤©éæ¾ token çéé¢
611     function setDailyLimit(uint256 _dailyLimit) onlyOwner {
612         dailyLimit = _dailyLimit;
613     }
614 }
615 
616 contract LLToken is ReleaseableToken {
617     string public standard = '2017082602';
618     string public name = 'LLToken';
619     string public symbol = 'LLT';
620     uint8 public decimals = 8;
621 
622     function LLToken(
623                      uint256 initialSupply,
624                      uint256 initReleasedSupply,
625                      address operator
626                      ) ReleaseableToken(initialSupply, initReleasedSupply, operator) {}
627 }