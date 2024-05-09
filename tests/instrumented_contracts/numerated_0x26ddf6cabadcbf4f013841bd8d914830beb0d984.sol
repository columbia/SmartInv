1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 library DateTime {
18         /*
19          *  Date and Time utilities for ethereum contracts
20          *
21          */
22         struct _DateTime {
23                 uint16 year;
24                 uint8 month;
25                 uint8 day;
26                 uint8 hour;
27                 uint8 minute;
28                 uint8 second;
29                 uint8 weekday;
30         }
31 
32         uint constant DAY_IN_SECONDS = 86400;
33         uint constant YEAR_IN_SECONDS = 31536000;
34         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
35 
36         uint constant HOUR_IN_SECONDS = 3600;
37         uint constant MINUTE_IN_SECONDS = 60;
38 
39         uint16 constant ORIGIN_YEAR = 1970;
40 
41         function isLeapYear(uint16 year) public pure returns (bool) {
42                 if (year % 4 != 0) {
43                         return false;
44                 }
45                 if (year % 100 != 0) {
46                         return true;
47                 }
48                 if (year % 400 != 0) {
49                         return false;
50                 }
51                 return true;
52         }
53 
54         function leapYearsBefore(uint year) public pure returns (uint) {
55                 year -= 1;
56                 return year / 4 - year / 100 + year / 400;
57         }
58 
59         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
60                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
61                         return 31;
62                 }
63                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
64                         return 30;
65                 }
66                 else if (isLeapYear(year)) {
67                         return 29;
68                 }
69                 else {
70                         return 28;
71                 }
72         }
73 
74         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
75                 uint secondsAccountedFor = 0;
76                 uint buf;
77                 uint8 i;
78 
79                 // Year
80                 dt.year = getYear(timestamp);
81                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
82 
83                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
84                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
85 
86                 // Month
87                 uint secondsInMonth;
88                 for (i = 1; i <= 12; i++) {
89                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
90                         if (secondsInMonth + secondsAccountedFor > timestamp) {
91                                 dt.month = i;
92                                 break;
93                         }
94                         secondsAccountedFor += secondsInMonth;
95                 }
96 
97                 // Day
98                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
99                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
100                                 dt.day = i;
101                                 break;
102                         }
103                         secondsAccountedFor += DAY_IN_SECONDS;
104                 }
105 
106                 // Hour
107                 dt.hour = getHour(timestamp);
108 
109                 // Minute
110                 dt.minute = getMinute(timestamp);
111 
112                 // Second
113                 dt.second = getSecond(timestamp);
114 
115                 // Day of week.
116                 dt.weekday = getWeekday(timestamp);
117         }
118 
119         function getYear(uint timestamp) public pure returns (uint16) {
120                 uint secondsAccountedFor = 0;
121                 uint16 year;
122                 uint numLeapYears;
123 
124                 // Year
125                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
126                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
127 
128                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
129                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
130 
131                 while (secondsAccountedFor > timestamp) {
132                         if (isLeapYear(uint16(year - 1))) {
133                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
134                         }
135                         else {
136                                 secondsAccountedFor -= YEAR_IN_SECONDS;
137                         }
138                         year -= 1;
139                 }
140                 return year;
141         }
142 
143         function getMonth(uint timestamp) public pure returns (uint8) {
144                 return parseTimestamp(timestamp).month;
145         }
146 
147         function getDay(uint timestamp) public pure returns (uint8) {
148                 return parseTimestamp(timestamp).day;
149         }
150 
151         function getHour(uint timestamp) public pure returns (uint8) {
152                 return uint8((timestamp / 60 / 60) % 24);
153         }
154 
155         function getMinute(uint timestamp) public pure returns (uint8) {
156                 return uint8((timestamp / 60) % 60);
157         }
158 
159         function getSecond(uint timestamp) public pure returns (uint8) {
160                 return uint8(timestamp % 60);
161         }
162 
163         function getWeekday(uint timestamp) public pure returns (uint8) {
164                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
165         }
166 
167         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
168                 return toTimestamp(year, month, day, 0, 0, 0);
169         }
170 
171         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
172                 return toTimestamp(year, month, day, hour, 0, 0);
173         }
174 
175         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
176                 return toTimestamp(year, month, day, hour, minute, 0);
177         }
178 
179         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
180                 uint16 i;
181 
182                 // Year
183                 for (i = ORIGIN_YEAR; i < year; i++) {
184                         if (isLeapYear(i)) {
185                                 timestamp += LEAP_YEAR_IN_SECONDS;
186                         }
187                         else {
188                                 timestamp += YEAR_IN_SECONDS;
189                         }
190                 }
191 
192                 // Month
193                 uint8[12] memory monthDayCounts;
194                 monthDayCounts[0] = 31;
195                 if (isLeapYear(year)) {
196                         monthDayCounts[1] = 29;
197                 }
198                 else {
199                         monthDayCounts[1] = 28;
200                 }
201                 monthDayCounts[2] = 31;
202                 monthDayCounts[3] = 30;
203                 monthDayCounts[4] = 31;
204                 monthDayCounts[5] = 30;
205                 monthDayCounts[6] = 31;
206                 monthDayCounts[7] = 31;
207                 monthDayCounts[8] = 30;
208                 monthDayCounts[9] = 31;
209                 monthDayCounts[10] = 30;
210                 monthDayCounts[11] = 31;
211 
212                 for (i = 1; i < month; i++) {
213                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
214                 }
215 
216                 // Day
217                 timestamp += DAY_IN_SECONDS * (day - 1);
218 
219                 // Hour
220                 timestamp += HOUR_IN_SECONDS * (hour);
221 
222                 // Minute
223                 timestamp += MINUTE_IN_SECONDS * (minute);
224 
225                 // Second
226                 timestamp += second;
227 
228                 return timestamp;
229         }
230 }
231 
232 
233 
234 /**
235  * @title Ownable
236  * @dev The Ownable contract has an owner address, and provides basic authorization control
237  * functions, this simplifies the implementation of "user permissions".
238  */
239 contract Ownable {
240   address public owner;
241 
242 
243   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245 
246   /**
247    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
248    * account.
249    */
250   function Ownable() public {
251     owner = msg.sender;
252   }
253 
254   /**
255    * @dev Throws if called by any account other than the owner.
256    */
257   modifier onlyOwner() {
258     require(msg.sender == owner);
259     _;
260   }
261 
262   /**
263    * @dev Allows the current owner to transfer control of the contract to a newOwner.
264    * @param newOwner The address to transfer ownership to.
265    */
266   function transferOwnership(address newOwner) public onlyOwner {
267     require(newOwner != address(0));
268     emit OwnershipTransferred(owner, newOwner);
269     owner = newOwner;
270   }
271 
272 }
273 
274 
275 
276 
277 
278 
279 contract Operational is Ownable {
280     address public operator;
281 
282     function Operational(address _operator) public {
283       operator = _operator;
284     }
285 
286     modifier onlyOperator() {
287       require(msg.sender == operator);
288       _;
289     }
290 
291     function transferOperator(address newOperator) public onlyOwner {
292       require(newOperator != address(0));
293       operator = newOperator;
294     }
295 
296 }
297 
298 
299 
300 
301 
302 
303 
304 
305 
306 /**
307  * @title Claimable
308  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
309  * This allows the new owner to accept the transfer.
310  */
311 contract Claimable is Ownable {
312   address public pendingOwner;
313 
314   /**
315    * @dev Modifier throws if called by any account other than the pendingOwner.
316    */
317   modifier onlyPendingOwner() {
318     require(msg.sender == pendingOwner);
319     _;
320   }
321 
322   /**
323    * @dev Allows the current owner to set the pendingOwner address.
324    * @param newOwner The address to transfer ownership to.
325    */
326   function transferOwnership(address newOwner) onlyOwner public {
327     pendingOwner = newOwner;
328   }
329 
330   /**
331    * @dev Allows the pendingOwner address to finalize the transfer.
332    */
333   function claimOwnership() onlyPendingOwner public {
334     emit OwnershipTransferred(owner, pendingOwner);
335     owner = pendingOwner;
336     pendingOwner = address(0);
337   }
338 }
339 
340 
341 
342 
343 /**
344  * @title SafeMath
345  * @dev Math operations with safety checks that throw on error
346  */
347 library SafeMath {
348 
349   /**
350   * @dev Multiplies two numbers, throws on overflow.
351   */
352   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
353     if (a == 0) {
354       return 0;
355     }
356     c = a * b;
357     assert(c / a == b);
358     return c;
359   }
360 
361   /**
362   * @dev Integer division of two numbers, truncating the quotient.
363   */
364   function div(uint256 a, uint256 b) internal pure returns (uint256) {
365     // assert(b > 0); // Solidity automatically throws when dividing by 0
366     // uint256 c = a / b;
367     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
368     return a / b;
369   }
370 
371   /**
372   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
373   */
374   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375     assert(b <= a);
376     return a - b;
377   }
378 
379   /**
380   * @dev Adds two numbers, throws on overflow.
381   */
382   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
383     c = a + b;
384     assert(c >= a);
385     return c;
386   }
387 }
388 
389 
390 
391 
392 
393 
394 
395 
396 
397 
398 
399 
400 /**
401  * @title Basic token
402  * @dev Basic version of StandardToken, with no allowances.
403  */
404 contract BasicToken is ERC20Basic {
405   using SafeMath for uint256;
406 
407   mapping(address => uint256) balances;
408 
409   uint256 totalSupply_;
410 
411   /**
412   * @dev total number of tokens in existence
413   */
414   function totalSupply() public view returns (uint256) {
415     return totalSupply_;
416   }
417 
418   /**
419   * @dev transfer token for a specified address
420   * @param _to The address to transfer to.
421   * @param _value The amount to be transferred.
422   */
423   function transfer(address _to, uint256 _value) public returns (bool) {
424     require(_to != address(0));
425     require(_value <= balances[msg.sender]);
426 
427     balances[msg.sender] = balances[msg.sender].sub(_value);
428     balances[_to] = balances[_to].add(_value);
429     emit Transfer(msg.sender, _to, _value);
430     return true;
431   }
432 
433   /**
434   * @dev Gets the balance of the specified address.
435   * @param _owner The address to query the the balance of.
436   * @return An uint256 representing the amount owned by the passed address.
437   */
438   function balanceOf(address _owner) public view returns (uint256) {
439     return balances[_owner];
440   }
441 
442 }
443 
444 
445 
446 
447 
448 
449 /**
450  * @title ERC20 interface
451  * @dev see https://github.com/ethereum/EIPs/issues/20
452  */
453 contract ERC20 is ERC20Basic {
454   function allowance(address owner, address spender) public view returns (uint256);
455   function transferFrom(address from, address to, uint256 value) public returns (bool);
456   function approve(address spender, uint256 value) public returns (bool);
457   event Approval(address indexed owner, address indexed spender, uint256 value);
458 }
459 
460 
461 
462 /**
463  * @title Standard ERC20 token
464  *
465  * @dev Implementation of the basic standard token.
466  * @dev https://github.com/ethereum/EIPs/issues/20
467  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
468  */
469 contract StandardToken is ERC20, BasicToken {
470 
471   mapping (address => mapping (address => uint256)) internal allowed;
472 
473 
474   /**
475    * @dev Transfer tokens from one address to another
476    * @param _from address The address which you want to send tokens from
477    * @param _to address The address which you want to transfer to
478    * @param _value uint256 the amount of tokens to be transferred
479    */
480   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
481     require(_to != address(0));
482     require(_value <= balances[_from]);
483     require(_value <= allowed[_from][msg.sender]);
484 
485     balances[_from] = balances[_from].sub(_value);
486     balances[_to] = balances[_to].add(_value);
487     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
488     emit Transfer(_from, _to, _value);
489     return true;
490   }
491 
492   /**
493    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
494    *
495    * Beware that changing an allowance with this method brings the risk that someone may use both the old
496    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
497    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
498    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
499    * @param _spender The address which will spend the funds.
500    * @param _value The amount of tokens to be spent.
501    */
502   function approve(address _spender, uint256 _value) public returns (bool) {
503     allowed[msg.sender][_spender] = _value;
504     emit Approval(msg.sender, _spender, _value);
505     return true;
506   }
507 
508   /**
509    * @dev Function to check the amount of tokens that an owner allowed to a spender.
510    * @param _owner address The address which owns the funds.
511    * @param _spender address The address which will spend the funds.
512    * @return A uint256 specifying the amount of tokens still available for the spender.
513    */
514   function allowance(address _owner, address _spender) public view returns (uint256) {
515     return allowed[_owner][_spender];
516   }
517 
518   /**
519    * @dev Increase the amount of tokens that an owner allowed to a spender.
520    *
521    * approve should be called when allowed[_spender] == 0. To increment
522    * allowed value is better to use this function to avoid 2 calls (and wait until
523    * the first transaction is mined)
524    * From MonolithDAO Token.sol
525    * @param _spender The address which will spend the funds.
526    * @param _addedValue The amount of tokens to increase the allowance by.
527    */
528   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
529     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
530     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
531     return true;
532   }
533 
534   /**
535    * @dev Decrease the amount of tokens that an owner allowed to a spender.
536    *
537    * approve should be called when allowed[_spender] == 0. To decrement
538    * allowed value is better to use this function to avoid 2 calls (and wait until
539    * the first transaction is mined)
540    * From MonolithDAO Token.sol
541    * @param _spender The address which will spend the funds.
542    * @param _subtractedValue The amount of tokens to decrease the allowance by.
543    */
544   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
545     uint oldValue = allowed[msg.sender][_spender];
546     if (_subtractedValue > oldValue) {
547       allowed[msg.sender][_spender] = 0;
548     } else {
549       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
550     }
551     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
552     return true;
553   }
554 
555 }
556 
557 
558 
559 
560 /**
561  * @title Helps contracts guard agains reentrancy attacks.
562  * @author Remco Bloemen <remco@2π.com>
563  * @notice If you mark a function `nonReentrant`, you should also
564  * mark it `external`.
565  */
566 contract ReentrancyGuard {
567 
568   /**
569    * @dev We use a single lock for the whole contract.
570    */
571   bool private reentrancyLock = false;
572 
573   /**
574    * @dev Prevents a contract from calling itself, directly or indirectly.
575    * @notice If you mark a function `nonReentrant`, you should also
576    * mark it `external`. Calling one nonReentrant function from
577    * another is not supported. Instead, you can implement a
578    * `private` function doing the actual work, and a `external`
579    * wrapper marked as `nonReentrant`.
580    */
581   modifier nonReentrant() {
582     require(!reentrancyLock);
583     reentrancyLock = true;
584     _;
585     reentrancyLock = false;
586   }
587 
588 }
589 
590 
591 
592 
593 
594 
595 /**
596  * @title Burnable Token
597  * @dev Token that can be irreversibly burned (destroyed).
598  */
599 contract BurnableToken is BasicToken {
600 
601   event Burn(address indexed burner, uint256 value);
602 
603   /**
604    * @dev Burns a specific amount of tokens.
605    * @param _value The amount of token to be burned.
606    */
607   function burn(uint256 _value) public {
608     _burn(msg.sender, _value);
609   }
610 
611   function _burn(address _who, uint256 _value) internal {
612     require(_value <= balances[_who]);
613     // no need to require value <= totalSupply, since that would imply the
614     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
615 
616     balances[_who] = balances[_who].sub(_value);
617     totalSupply_ = totalSupply_.sub(_value);
618     emit Burn(_who, _value);
619     emit Transfer(_who, address(0), _value);
620   }
621 }
622 
623 
624 
625 
626 
627 contract BonusToken is BurnableToken, Operational, StandardToken {
628     using SafeMath for uint;
629     using DateTime for uint256;
630 
631     uint256 public createTime;
632     uint256 standardDecimals = 100000000;
633     uint256 minMakeBonusAmount = standardDecimals.mul(10);
634 
635     function BonusToken() public Operational(msg.sender) {}
636 
637     function makeBonus(address[] _to, uint256[] _bonus) public returns(bool) {
638         for(uint i = 0; i < _to.length; i++){
639             require(transfer(_to[i], _bonus[i]));
640         }
641         return true;
642     }
643 
644 }
645 
646 
647 contract KuaiMintableToken is BonusToken {
648 
649 
650     uint256 public standardDailyLimit; // maximum amount of token can mint per day
651     uint256 public dailyLimitLeft = standardDecimals.mul(1000000); // daily limit left
652     uint256 public lastMintTime = 0;
653 
654     event Mint(address indexed operator, uint256 value, uint256 mintTime);
655     event SetDailyLimit(address indexed operator, uint256 time);
656 
657     function KuaiMintableToken(
658                     address _owner,
659                     uint256 _dailyLimit
660                 ) public BonusToken() {
661         totalSupply_ = 0;
662         createTime = block.timestamp;
663         lastMintTime = createTime;
664         owner = _owner;
665         standardDailyLimit = standardDecimals.mul(_dailyLimit);
666         dailyLimitLeft = standardDailyLimit;
667     }
668 
669     // mint mintAmount token
670     function mint(uint256 mintAmount) public onlyOperator returns(uint256 _actualRelease) {
671         uint256 timestamp = block.timestamp;
672         require(!judgeIsReachDailyLimit(mintAmount, timestamp));
673         balances[owner] = balances[owner].add(mintAmount);
674         totalSupply_ = totalSupply_.add(mintAmount);
675         emit Mint(msg.sender, mintAmount, timestamp);
676         emit Transfer(address(0), owner, mintAmount);
677         return mintAmount;
678     }
679 
680     function judgeIsReachDailyLimit(uint256 mintAmount, uint256 timestamp) internal returns(bool _exist) {
681         bool reached = false;
682         if ((timestamp.parseTimestamp().year == lastMintTime.parseTimestamp().year)
683             && (timestamp.parseTimestamp().month == lastMintTime.parseTimestamp().month)
684             && (timestamp.parseTimestamp().day == lastMintTime.parseTimestamp().day)) {
685             if (dailyLimitLeft < mintAmount) {
686                 reached = true;
687             } else {
688                 dailyLimitLeft = dailyLimitLeft.sub(mintAmount);
689                 lastMintTime = timestamp;
690             }
691         } else {
692             dailyLimitLeft = standardDailyLimit;
693             lastMintTime = timestamp;
694             if (dailyLimitLeft < mintAmount) {
695                 reached = true;
696             } else {
697                 dailyLimitLeft = dailyLimitLeft.sub(mintAmount);
698             }
699         }
700         return reached;
701     }
702 
703 
704     // set standard daily limit
705     function setDailyLimit(uint256 _dailyLimit) public onlyOwner returns(bool){
706         standardDailyLimit = _dailyLimit;
707         emit SetDailyLimit(msg.sender, block.timestamp);
708         return true;
709     }
710 }
711 
712 
713 contract KuaiToken is KuaiMintableToken {
714     string public standard = '20180609';
715     string public name = 'KuaiToken';
716     string public symbol = 'KT';
717     uint8 public decimals = 8;
718 
719     function KuaiToken(
720                     address _owner,
721                     uint256 dailyLimit
722                      ) public KuaiMintableToken(_owner, dailyLimit) {}
723 
724 }