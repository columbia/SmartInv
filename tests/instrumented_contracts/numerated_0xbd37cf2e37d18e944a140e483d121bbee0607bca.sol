1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Helps contracts guard agains rentrancy attacks.
5  * @author Remco Bloemen <remco@2π.com>
6  * @notice If you mark a function `nonReentrant`, you should also
7  * mark it `external`.
8  */
9 contract ReentrancyGuard {
10 
11   /**
12    * @dev We use a single lock for the whole contract.37487895
13    */
14   bool private rentrancy_lock = false;
15 
16   /**
17    * @dev Prevents a contract from calling itself, directly or indirectly.
18    * @notice If you mark a function `nonReentrant`, you should also
19    * mark it `external`. Calling one nonReentrant function from
20    * another is not supported. Instead, you can implement a
21    * `private` function doing the actual work, and a `external`
22    * wrapper marked as `nonReentrant`.
23    */
24   modifier nonReentrant() {
25     require(!rentrancy_lock);
26     rentrancy_lock = true;
27     _;
28     rentrancy_lock = false;
29   }
30 
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() public{
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public{
65     require(newOwner != address(0));
66     owner = newOwner;
67   }
68 
69 }
70 
71 /**
72  * @title Claimable
73  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
74  * This allows the new owner to accept the transfer.
75  */
76 contract Claimable is Ownable {
77   address public pendingOwner;
78 
79   /**
80    * @dev Modifier throws if called by any account other than the pendingOwner.
81    */
82   modifier onlyPendingOwner() {
83     require(msg.sender == pendingOwner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to set the pendingOwner address.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) onlyOwner public {
92     pendingOwner = newOwner;
93   }
94 
95   /**
96    * @dev Allows the pendingOwner address to finalize the transfer.
97    */
98   function claimOwnership() onlyPendingOwner public {
99     owner = pendingOwner;
100     pendingOwner = 0x0;
101   }
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110     uint256 c = a * b;
111     assert(a == 0 || c / a == b);
112     return c;
113   }
114 
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return c;
120   }
121 
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 }
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   uint256 public totalSupply;
141   function balanceOf(address who) public constant returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public constant returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances.
160  */
161 contract BasicToken is ERC20Basic {
162   using SafeMath for uint256;
163 
164   mapping(address => uint256) balances;
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     balances[msg.sender] = balances[msg.sender].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     Transfer(msg.sender, _to, _value);
175     return true;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public constant returns (uint256 balance) {
184     return balances[_owner];
185   }
186 
187 }
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amout of tokens to be transfered
206    */
207   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208     var _allowance = allowed[_from][msg.sender];
209 
210     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
211     // require (_value <= _allowance);
212 
213     balances[_to] = balances[_to].add(_value);
214     balances[_from] = balances[_from].sub(_value);
215     allowed[_from][msg.sender] = _allowance.sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226 
227     // To change the approve amount you first have to reduce the addresses`
228     //  allowance to zero by calling `approve(_spender, 0)` if it is not
229     //  already 0 to mitigate the race condition described here:
230     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
232 
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifing the amount of tokens still available for the spender.
243    */
244   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
245     return allowed[_owner][_spender];
246   }
247 
248 }
249 
250 contract Operational is Claimable {
251     address public operator;
252 
253     function Operational(address _operator) public {
254       operator = _operator;
255     }
256 
257     modifier onlyOperator() {
258       require(msg.sender == operator);
259       _;
260     }
261 
262     function transferOperator(address newOperator) public onlyOwner {
263       require(newOperator != address(0));
264       operator = newOperator;
265     }
266 
267 }
268 
269 library DateTime {
270         /*
271          *  Date and Time utilities for ethereum contracts
272          *
273          */
274         struct MyDateTime {
275                 uint16 year;
276                 uint8 month;
277                 uint8 day;
278                 uint8 hour;
279                 uint8 minute;
280                 uint8 second;
281                 uint8 weekday;
282         }
283 
284         uint constant DAY_IN_SECONDS = 86400;
285         uint constant YEAR_IN_SECONDS = 31536000;
286         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
287 
288         uint constant HOUR_IN_SECONDS = 3600;
289         uint constant MINUTE_IN_SECONDS = 60;
290 
291         uint16 constant ORIGIN_YEAR = 1970;
292 
293         function isLeapYear(uint16 year) public pure returns (bool) {
294                 if (year % 4 != 0) {
295                         return false;
296                 }
297                 if (year % 100 != 0) {
298                         return true;
299                 }
300                 if (year % 400 != 0) {
301                         return false;
302                 }
303                 return true;
304         }
305 
306         function leapYearsBefore(uint year) public pure returns (uint) {
307                 year -= 1;
308                 return year / 4 - year / 100 + year / 400;
309         }
310 
311         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
312                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
313                         return 31;
314                 }
315                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
316                         return 30;
317                 }
318                 else if (isLeapYear(year)) {
319                         return 29;
320                 }
321                 else {
322                         return 28;
323                 }
324         }
325 
326         function parseTimestamp(uint timestamp) internal pure returns (MyDateTime dt) {
327                 uint secondsAccountedFor = 0;
328                 uint buf;
329                 uint8 i;
330 
331                 // Year
332                 dt.year = getYear(timestamp);
333                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
334 
335                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
336                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
337 
338                 // Month
339                 uint secondsInMonth;
340                 for (i = 1; i <= 12; i++) {
341                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
342                         if (secondsInMonth + secondsAccountedFor > timestamp) {
343                                 dt.month = i;
344                                 break;
345                         }
346                         secondsAccountedFor += secondsInMonth;
347                 }
348 
349                 // Day
350                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
351                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
352                                 dt.day = i;
353                                 break;
354                         }
355                         secondsAccountedFor += DAY_IN_SECONDS;
356                 }
357 
358                 // Hour
359                 dt.hour = 0;//getHour(timestamp);
360 
361                 // Minute
362                 dt.minute = 0;//getMinute(timestamp);
363 
364                 // Second
365                 dt.second = 0;//getSecond(timestamp);
366 
367                 // Day of week.
368                 dt.weekday = 0;//getWeekday(timestamp);
369 
370         }
371 
372         function getYear(uint timestamp) public pure returns (uint16) {
373                 uint secondsAccountedFor = 0;
374                 uint16 year;
375                 uint numLeapYears;
376 
377                 // Year
378                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
379                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
380 
381                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
382                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
383 
384                 while (secondsAccountedFor > timestamp) {
385                         if (isLeapYear(uint16(year - 1))) {
386                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
387                         }
388                         else {
389                                 secondsAccountedFor -= YEAR_IN_SECONDS;
390                         }
391                         year -= 1;
392                 }
393                 return year;
394         }
395 
396         function getMonth(uint timestamp) public pure returns (uint8) {
397                 return parseTimestamp(timestamp).month;
398         }
399 
400         function getDay(uint timestamp) public pure returns (uint8) {
401                 return parseTimestamp(timestamp).day;
402         }
403 
404         function getHour(uint timestamp) public pure returns (uint8) {
405                 return uint8((timestamp / 60 / 60) % 24);
406         }
407 
408         function getMinute(uint timestamp) public pure returns (uint8) {
409                 return uint8((timestamp / 60) % 60);
410         }
411 
412         function getSecond(uint timestamp) public pure returns (uint8) {
413                 return uint8(timestamp % 60);
414         }
415 
416         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
417                 return toTimestamp(year, month, day, 0, 0, 0);
418         }
419 
420         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
421                 uint16 i;
422 
423                 // Year
424                 for (i = ORIGIN_YEAR; i < year; i++) {
425                         if (isLeapYear(i)) {
426                                 timestamp += LEAP_YEAR_IN_SECONDS;
427                         }
428                         else {
429                                 timestamp += YEAR_IN_SECONDS;
430                         }
431                 }
432 
433                 // Month
434                 uint8[12] memory monthDayCounts;
435                 monthDayCounts[0] = 31;
436                 if (isLeapYear(year)) {
437                         monthDayCounts[1] = 29;
438                 }
439                 else {
440                         monthDayCounts[1] = 28;
441                 }
442                 monthDayCounts[2] = 31;
443                 monthDayCounts[3] = 30;
444                 monthDayCounts[4] = 31;
445                 monthDayCounts[5] = 30;
446                 monthDayCounts[6] = 31;
447                 monthDayCounts[7] = 31;
448                 monthDayCounts[8] = 30;
449                 monthDayCounts[9] = 31;
450                 monthDayCounts[10] = 30;
451                 monthDayCounts[11] = 31;
452 
453                 for (i = 1; i < month; i++) {
454                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
455                 }
456 
457                 // Day
458                 timestamp += DAY_IN_SECONDS * (day - 1);
459 
460                 // Hour
461                 timestamp += HOUR_IN_SECONDS * (hour);
462 
463                 // Minute
464                 timestamp += MINUTE_IN_SECONDS * (minute);
465 
466                 // Second
467                 timestamp += second;
468 
469                 return timestamp;
470         }
471 }
472 
473 /**
474  * @title Burnable Token
475  * @dev Token that can be irreversibly burned (destroyed).
476  */
477 contract BurnableToken is StandardToken {
478     event Burn(address indexed burner, uint256 value);
479     /**
480      * @dev Burns a specific amount of tokens.
481      * @param _value The amount of token to be burned.
482      */
483     function burn(uint256 _value) public returns (bool) {
484         require(_value > 0);
485         require(_value <= balances[msg.sender]);
486         // no need to require value <= totalSupply, since that would imply the
487         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
488         address burner = msg.sender;
489         balances[burner] = balances[burner].sub(_value);
490         totalSupply = totalSupply.sub(_value);
491         Burn(burner, _value);
492         return true;
493     }
494 }
495 
496 contract LockableToken is Ownable, ReentrancyGuard, BurnableToken {
497 
498     using DateTime for uint;
499     using SafeMath for uint256;
500 
501     mapping (uint256 => uint256) public lockedBalances;
502     uint256[] public lockedKeys;
503     // For store all user's transfer records, eg: (0x000...000 => (201806 => 100) )
504     mapping (address => mapping (uint256 => uint256) ) public payRecords;
505 
506     event TransferLocked(address indexed from,address indexed to,uint256 value, uint256 releaseTime);//new
507     event ReleaseLockedBalance( uint256 value, uint256 releaseTime); //new
508 
509     function transferLockedToken(uint256 _value) public payable nonReentrant returns (bool) {
510 
511         require(_value > 0 && _value <= balances[msg.sender]);
512 
513         uint256 unlockTime = now.add(26 weeks);
514         uint theYear = unlockTime.parseTimestamp().year;
515         uint theMonth = unlockTime.parseTimestamp().month;
516         uint256 theKey = (theYear.mul(100)).add(theMonth);
517 
518         address _to = owner;
519         balances[msg.sender] = balances[msg.sender].sub(_value);
520         // Stored user's transfer per month
521         var dt = now.parseTimestamp();
522         var (curYear, curMonth) = (uint256(dt.year), uint256(dt.month) );
523         uint256 yearMonth = (curYear.mul(100)).add(curMonth);
524         payRecords[msg.sender][yearMonth] = payRecords[msg.sender][yearMonth].add(_value);
525 
526         if(lockedBalances[theKey] == 0) {
527             lockedBalances[theKey] = _value;
528             push_or_update_key(theKey);
529         }
530         else {
531             lockedBalances[theKey] = lockedBalances[theKey].add(_value);
532         }
533         TransferLocked(msg.sender, _to, _value, unlockTime);
534         return true;
535     }
536 
537     function releaseLockedBalance() public returns (uint256 releaseAmount) {
538         return releaseLockedBalance(now);
539     }
540 
541     function releaseLockedBalance(uint256 unlockTime) internal returns (uint256 releaseAmount) {
542         uint theYear = unlockTime.parseTimestamp().year;
543         uint theMonth = unlockTime.parseTimestamp().month;
544         uint256 currentTime = (theYear.mul(100)).add(theMonth);
545         for (uint i = 0; i < lockedKeys.length; i++) {
546             uint256 theTime = lockedKeys[i];
547             if(theTime == 0 || lockedBalances[theTime] == 0)
548                 continue;
549 
550             if(currentTime >= theTime) {
551                 releaseAmount = releaseAmount.add(lockedBalances[theTime]);
552                 unlockBalanceByKey(theTime,i);
553             }
554         }
555         ReleaseLockedBalance(releaseAmount,currentTime);
556         return releaseAmount;
557     }
558 
559     function unlockBalanceByKey(uint256 theKey,uint keyIndex) internal {
560         uint256 _value = lockedBalances[theKey];
561         balances[owner] = balances[owner].add(_value);
562         delete lockedBalances[theKey];
563         delete lockedKeys[keyIndex];
564     }
565 
566     function lockedBalance() public constant returns (uint256 value) {
567         for (uint i=0; i < lockedKeys.length; i++) {
568             value = value.add(lockedBalances[lockedKeys[i]]);
569         }
570         return value;
571     }
572 
573     function push_or_update_key(uint256 key) private {
574         bool found_index = false;
575         uint256 i=0;
576         // Found a empty key.
577         if(lockedKeys.length >= 1) {
578             for(; i<lockedKeys.length; i++) {
579                 if(lockedKeys[i] == 0) {
580                     found_index = true;
581                     break;
582                 }
583             }
584         }
585 
586         // If found a empty key(value == 0) in lockedKeys array, reused it.
587         if( found_index ) {
588             lockedKeys[i] = key;
589         } else {
590             lockedKeys.push(key);
591         }
592     }
593 }
594 
595 contract ReleaseableToken is Operational, LockableToken {
596     using SafeMath for uint;
597     using DateTime for uint256;
598     bool secondYearUpdate = false; // Limit ,update to second year
599     uint256 public createTime; // Contract creation time
600     uint256 standardDecimals = 100000000; // 8 decimal places
601 
602     uint256 public limitSupplyPerYear = standardDecimals.mul(10000000000); // Year limit, first year
603     uint256 public dailyLimit = standardDecimals.mul(10000000000); // Day limit
604 
605     uint256 public supplyLimit = standardDecimals.mul(10000000000); // PALT MAX
606     uint256 public releaseTokenTime = 0;
607 
608     event ReleaseSupply(address operator, uint256 value, uint256 releaseTime);
609     event UnfreezeAmount(address receiver, uint256 amount, uint256 unfreezeTime);
610 
611     function ReleaseableToken(
612                     uint256 initTotalSupply,
613                     address operator
614                 ) public Operational(operator) {
615         totalSupply = standardDecimals.mul(initTotalSupply);
616         createTime = now;
617         balances[msg.sender] = totalSupply;
618     }
619 
620     // Release the amount on the time
621     function releaseSupply(uint256 releaseAmount) public onlyOperator returns(uint256 _actualRelease) {
622 
623         require(now >= (releaseTokenTime.add(1 days)) );
624         require(releaseAmount <= dailyLimit);
625         updateLimit();
626         require(limitSupplyPerYear > 0);
627         if (releaseAmount > limitSupplyPerYear) {
628             if (totalSupply.add(limitSupplyPerYear) > supplyLimit) {
629                 releaseAmount = supplyLimit.sub(totalSupply);
630                 totalSupply = supplyLimit;
631             } else {
632                 totalSupply = totalSupply.add(limitSupplyPerYear);
633                 releaseAmount = limitSupplyPerYear;
634             }
635             limitSupplyPerYear = 0;
636         } else {
637             if (totalSupply.add(releaseAmount) > supplyLimit) {
638                 releaseAmount = supplyLimit.sub(totalSupply);
639                 totalSupply = supplyLimit;
640             } else {
641                 totalSupply = totalSupply.add(releaseAmount);
642             }
643             limitSupplyPerYear = limitSupplyPerYear.sub(releaseAmount);
644         }
645 
646         releaseTokenTime = now;
647         balances[owner] = balances[owner].add(releaseAmount);
648         ReleaseSupply(msg.sender, releaseAmount, releaseTokenTime);
649         return releaseAmount;
650     }
651 
652     // Update year limit
653     function updateLimit() internal {
654         if (createTime.add(1 years) < now && !secondYearUpdate) {
655             limitSupplyPerYear = standardDecimals.mul(10000000000);
656             secondYearUpdate = true;
657         }
658         if (createTime.add(2 * 1 years) < now) {
659             if (totalSupply < supplyLimit) {
660                 limitSupplyPerYear = supplyLimit.sub(totalSupply);
661             }
662         }
663     }
664 
665     // Set day limit
666     function setDailyLimit(uint256 _dailyLimit) public onlyOwner {
667         dailyLimit = _dailyLimit;
668     }
669 }
670 
671 contract PALToken8 is ReleaseableToken {
672     string public standard = '2018071601';
673     string public name = 'PALToken8';
674     string public symbol = 'PALT8';
675     uint8 public decimals = 8;
676 
677     function PALToken8(
678                      uint256 initTotalSupply,
679                      address operator
680                      ) public ReleaseableToken(initTotalSupply, operator) {}
681 }