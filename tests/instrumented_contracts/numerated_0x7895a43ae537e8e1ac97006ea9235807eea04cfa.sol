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
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 library DateTime {
60         /*
61          *  Date and Time utilities for ethereum contracts
62          *
63          */
64         struct _DateTime {
65                 uint16 year;
66                 uint8 month;
67                 uint8 day;
68                 uint8 hour;
69                 uint8 minute;
70                 uint8 second;
71                 uint8 weekday;
72         }
73 
74         uint constant DAY_IN_SECONDS = 86400;
75         uint constant YEAR_IN_SECONDS = 31536000;
76         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
77 
78         uint constant HOUR_IN_SECONDS = 3600;
79         uint constant MINUTE_IN_SECONDS = 60;
80 
81         uint16 constant ORIGIN_YEAR = 1970;
82 
83         function isLeapYear(uint16 year) public pure returns (bool) {
84                 if (year % 4 != 0) {
85                         return false;
86                 }
87                 if (year % 100 != 0) {
88                         return true;
89                 }
90                 if (year % 400 != 0) {
91                         return false;
92                 }
93                 return true;
94         }
95 
96         function leapYearsBefore(uint year) public pure returns (uint) {
97                 year -= 1;
98                 return year / 4 - year / 100 + year / 400;
99         }
100 
101         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
102                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
103                         return 31;
104                 }
105                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
106                         return 30;
107                 }
108                 else if (isLeapYear(year)) {
109                         return 29;
110                 }
111                 else {
112                         return 28;
113                 }
114         }
115 
116         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
117                 uint secondsAccountedFor = 0;
118                 uint buf;
119                 uint8 i;
120 
121                 // Year
122                 dt.year = getYear(timestamp);
123                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
124 
125                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
126                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
127 
128                 // Month
129                 uint secondsInMonth;
130                 for (i = 1; i <= 12; i++) {
131                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
132                         if (secondsInMonth + secondsAccountedFor > timestamp) {
133                                 dt.month = i;
134                                 break;
135                         }
136                         secondsAccountedFor += secondsInMonth;
137                 }
138 
139                 // Day
140                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
141                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
142                                 dt.day = i;
143                                 break;
144                         }
145                         secondsAccountedFor += DAY_IN_SECONDS;
146                 }
147 
148                 // Hour
149                 dt.hour = getHour(timestamp);
150 
151                 // Minute
152                 dt.minute = getMinute(timestamp);
153 
154                 // Second
155                 dt.second = getSecond(timestamp);
156 
157                 // Day of week.
158                 dt.weekday = getWeekday(timestamp);
159         }
160 
161         function getYear(uint timestamp) public pure returns (uint16) {
162                 uint secondsAccountedFor = 0;
163                 uint16 year;
164                 uint numLeapYears;
165 
166                 // Year
167                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
168                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
169 
170                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
171                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
172 
173                 while (secondsAccountedFor > timestamp) {
174                         if (isLeapYear(uint16(year - 1))) {
175                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
176                         }
177                         else {
178                                 secondsAccountedFor -= YEAR_IN_SECONDS;
179                         }
180                         year -= 1;
181                 }
182                 return year;
183         }
184 
185         function getMonth(uint timestamp) public pure returns (uint8) {
186                 return parseTimestamp(timestamp).month;
187         }
188 
189         function getDay(uint timestamp) public pure returns (uint8) {
190                 return parseTimestamp(timestamp).day;
191         }
192 
193         function getHour(uint timestamp) public pure returns (uint8) {
194                 return uint8((timestamp / 60 / 60) % 24);
195         }
196 
197         function getMinute(uint timestamp) public pure returns (uint8) {
198                 return uint8((timestamp / 60) % 60);
199         }
200 
201         function getSecond(uint timestamp) public pure returns (uint8) {
202                 return uint8(timestamp % 60);
203         }
204 
205         function getWeekday(uint timestamp) public pure returns (uint8) {
206                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
207         }
208 
209         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
210                 return toTimestamp(year, month, day, 0, 0, 0);
211         }
212 
213         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
214                 return toTimestamp(year, month, day, hour, 0, 0);
215         }
216 
217         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
218                 return toTimestamp(year, month, day, hour, minute, 0);
219         }
220 
221         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
222                 uint16 i;
223 
224                 // Year
225                 for (i = ORIGIN_YEAR; i < year; i++) {
226                         if (isLeapYear(i)) {
227                                 timestamp += LEAP_YEAR_IN_SECONDS;
228                         }
229                         else {
230                                 timestamp += YEAR_IN_SECONDS;
231                         }
232                 }
233 
234                 // Month
235                 uint8[12] memory monthDayCounts;
236                 monthDayCounts[0] = 31;
237                 if (isLeapYear(year)) {
238                         monthDayCounts[1] = 29;
239                 }
240                 else {
241                         monthDayCounts[1] = 28;
242                 }
243                 monthDayCounts[2] = 31;
244                 monthDayCounts[3] = 30;
245                 monthDayCounts[4] = 31;
246                 monthDayCounts[5] = 30;
247                 monthDayCounts[6] = 31;
248                 monthDayCounts[7] = 31;
249                 monthDayCounts[8] = 30;
250                 monthDayCounts[9] = 31;
251                 monthDayCounts[10] = 30;
252                 monthDayCounts[11] = 31;
253 
254                 for (i = 1; i < month; i++) {
255                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
256                 }
257 
258                 // Day
259                 timestamp += DAY_IN_SECONDS * (day - 1);
260 
261                 // Hour
262                 timestamp += HOUR_IN_SECONDS * (hour);
263 
264                 // Minute
265                 timestamp += MINUTE_IN_SECONDS * (minute);
266 
267                 // Second
268                 timestamp += second;
269 
270                 return timestamp;
271         }
272 }
273 
274 
275 
276 
277 
278 
279 
280 
281 
282 
283 
284 
285 
286 /**
287  * @title SafeMath
288  * @dev Math operations with safety checks that throw on error
289  */
290 library SafeMath {
291 
292   /**
293   * @dev Multiplies two numbers, throws on overflow.
294   */
295   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
296     if (a == 0) {
297       return 0;
298     }
299     c = a * b;
300     assert(c / a == b);
301     return c;
302   }
303 
304   /**
305   * @dev Integer division of two numbers, truncating the quotient.
306   */
307   function div(uint256 a, uint256 b) internal pure returns (uint256) {
308     // assert(b > 0); // Solidity automatically throws when dividing by 0
309     // uint256 c = a / b;
310     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
311     return a / b;
312   }
313 
314   /**
315   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
316   */
317   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318     assert(b <= a);
319     return a - b;
320   }
321 
322   /**
323   * @dev Adds two numbers, throws on overflow.
324   */
325   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
326     c = a + b;
327     assert(c >= a);
328     return c;
329   }
330 }
331 
332 
333 
334 /**
335  * @title Basic token
336  * @dev Basic version of StandardToken, with no allowances.
337  */
338 contract BasicToken is ERC20Basic {
339   using SafeMath for uint256;
340 
341   mapping(address => uint256) balances;
342 
343   uint256 totalSupply_;
344 
345   /**
346   * @dev total number of tokens in existence
347   */
348   function totalSupply() public view returns (uint256) {
349     return totalSupply_;
350   }
351 
352   /**
353   * @dev transfer token for a specified address
354   * @param _to The address to transfer to.
355   * @param _value The amount to be transferred.
356   */
357   function transfer(address _to, uint256 _value) public returns (bool) {
358     require(_to != address(0));
359     require(_value <= balances[msg.sender]);
360 
361     balances[msg.sender] = balances[msg.sender].sub(_value);
362     balances[_to] = balances[_to].add(_value);
363     emit Transfer(msg.sender, _to, _value);
364     return true;
365   }
366 
367   /**
368   * @dev Gets the balance of the specified address.
369   * @param _owner The address to query the the balance of.
370   * @return An uint256 representing the amount owned by the passed address.
371   */
372   function balanceOf(address _owner) public view returns (uint256) {
373     return balances[_owner];
374   }
375 
376 }
377 
378 
379 
380 
381 
382 
383 /**
384  * @title ERC20 interface
385  * @dev see https://github.com/ethereum/EIPs/issues/20
386  */
387 contract ERC20 is ERC20Basic {
388   function allowance(address owner, address spender) public view returns (uint256);
389   function transferFrom(address from, address to, uint256 value) public returns (bool);
390   function approve(address spender, uint256 value) public returns (bool);
391   event Approval(address indexed owner, address indexed spender, uint256 value);
392 }
393 
394 
395 
396 /**
397  * @title Standard ERC20 token
398  *
399  * @dev Implementation of the basic standard token.
400  * @dev https://github.com/ethereum/EIPs/issues/20
401  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
402  */
403 contract StandardToken is ERC20, BasicToken {
404 
405   mapping (address => mapping (address => uint256)) internal allowed;
406 
407 
408   /**
409    * @dev Transfer tokens from one address to another
410    * @param _from address The address which you want to send tokens from
411    * @param _to address The address which you want to transfer to
412    * @param _value uint256 the amount of tokens to be transferred
413    */
414   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
415     require(_to != address(0));
416     require(_value <= balances[_from]);
417     require(_value <= allowed[_from][msg.sender]);
418 
419     balances[_from] = balances[_from].sub(_value);
420     balances[_to] = balances[_to].add(_value);
421     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
422     emit Transfer(_from, _to, _value);
423     return true;
424   }
425 
426   /**
427    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
428    *
429    * Beware that changing an allowance with this method brings the risk that someone may use both the old
430    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
431    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
432    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
433    * @param _spender The address which will spend the funds.
434    * @param _value The amount of tokens to be spent.
435    */
436   function approve(address _spender, uint256 _value) public returns (bool) {
437     allowed[msg.sender][_spender] = _value;
438     emit Approval(msg.sender, _spender, _value);
439     return true;
440   }
441 
442   /**
443    * @dev Function to check the amount of tokens that an owner allowed to a spender.
444    * @param _owner address The address which owns the funds.
445    * @param _spender address The address which will spend the funds.
446    * @return A uint256 specifying the amount of tokens still available for the spender.
447    */
448   function allowance(address _owner, address _spender) public view returns (uint256) {
449     return allowed[_owner][_spender];
450   }
451 
452   /**
453    * @dev Increase the amount of tokens that an owner allowed to a spender.
454    *
455    * approve should be called when allowed[_spender] == 0. To increment
456    * allowed value is better to use this function to avoid 2 calls (and wait until
457    * the first transaction is mined)
458    * From MonolithDAO Token.sol
459    * @param _spender The address which will spend the funds.
460    * @param _addedValue The amount of tokens to increase the allowance by.
461    */
462   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
463     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
464     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
465     return true;
466   }
467 
468   /**
469    * @dev Decrease the amount of tokens that an owner allowed to a spender.
470    *
471    * approve should be called when allowed[_spender] == 0. To decrement
472    * allowed value is better to use this function to avoid 2 calls (and wait until
473    * the first transaction is mined)
474    * From MonolithDAO Token.sol
475    * @param _spender The address which will spend the funds.
476    * @param _subtractedValue The amount of tokens to decrease the allowance by.
477    */
478   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
479     uint oldValue = allowed[msg.sender][_spender];
480     if (_subtractedValue > oldValue) {
481       allowed[msg.sender][_spender] = 0;
482     } else {
483       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
484     }
485     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
486     return true;
487   }
488 
489 }
490 
491 
492 
493 
494 
495 
496 /**
497  * @title Burnable Token
498  * @dev Token that can be irreversibly burned (destroyed).
499  */
500 contract BurnableToken is BasicToken {
501 
502   event Burn(address indexed burner, uint256 value);
503 
504   /**
505    * @dev Burns a specific amount of tokens.
506    * @param _value The amount of token to be burned.
507    */
508   function burn(uint256 _value) public returns (bool) {
509     _burn(msg.sender, _value);
510     return true;
511   }
512 
513   function _burn(address _who, uint256 _value) internal {
514     require(_value <= balances[_who]);
515     // no need to require value <= totalSupply, since that would imply the
516     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
517 
518     balances[_who] = balances[_who].sub(_value);
519     totalSupply_ = totalSupply_.sub(_value);
520     emit Burn(_who, _value);
521     emit Transfer(_who, address(0), _value);
522   }
523 }
524 
525 
526 
527 
528 /**
529  * @title Helps contracts guard agains reentrancy attacks.
530  * @author Remco Bloemen <remco@2π.com>
531  * @notice If you mark a function `nonReentrant`, you should also
532  * mark it `external`.
533  */
534 contract ReentrancyGuard {
535 
536   /**
537    * @dev We use a single lock for the whole contract.
538    */
539   bool private reentrancyLock = false;
540 
541   /**
542    * @dev Prevents a contract from calling itself, directly or indirectly.
543    * @notice If you mark a function `nonReentrant`, you should also
544    * mark it `external`. Calling one nonReentrant function from
545    * another is not supported. Instead, you can implement a
546    * `private` function doing the actual work, and a `external`
547    * wrapper marked as `nonReentrant`.
548    */
549   modifier nonReentrant() {
550     require(!reentrancyLock);
551     reentrancyLock = true;
552     _;
553     reentrancyLock = false;
554   }
555 
556 }
557 
558 
559 
560 
561 
562 
563 
564 /**
565  * @title Claimable
566  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
567  * This allows the new owner to accept the transfer.
568  */
569 contract Claimable is Ownable {
570   address public pendingOwner;
571 
572   /**
573    * @dev Modifier throws if called by any account other than the pendingOwner.
574    */
575   modifier onlyPendingOwner() {
576     require(msg.sender == pendingOwner);
577     _;
578   }
579 
580   /**
581    * @dev Allows the current owner to set the pendingOwner address.
582    * @param newOwner The address to transfer ownership to.
583    */
584   function transferOwnership(address newOwner) onlyOwner public {
585     pendingOwner = newOwner;
586   }
587 
588   /**
589    * @dev Allows the pendingOwner address to finalize the transfer.
590    */
591   function claimOwnership() onlyPendingOwner public {
592     emit OwnershipTransferred(owner, pendingOwner);
593     owner = pendingOwner;
594     pendingOwner = address(0);
595   }
596 }
597 
598 
599 
600 
601 contract Operational is Claimable {
602     address public operator;
603 
604     function Operational(address _operator) public {
605       operator = _operator;
606     }
607 
608     modifier onlyOperator() {
609       require(msg.sender == operator);
610       _;
611     }
612 
613     function transferOperator(address newOperator) public onlyOwner {
614       require(newOperator != address(0));
615       operator = newOperator;
616     }
617 
618 }
619 
620 
621 contract YunMint is Operational, ReentrancyGuard, BurnableToken, StandardToken {
622     using SafeMath for uint;
623     using SafeMath for uint256;
624     using DateTime for uint256;
625 
626 
627     event Release(address operator, uint256 value, uint256 releaseTime);
628     event Burn(address indexed burner, uint256 value);
629     event Freeze(address indexed owner, uint256 value, uint256 releaseTime);
630     event Unfreeze(address indexed owner, uint256 value, uint256 releaseTime);
631 
632     struct FrozenBalance {address owner; uint256 value; uint256 unFrozenTime;}
633     mapping (uint => FrozenBalance) public frozenBalances;
634     uint public frozenBalanceCount = 0;
635 
636     //init 303000000
637     uint256 constant valueTotal = 303000000 * (10 ** 8);
638     /* uint256 public totalSupply = 0; */
639 
640 
641     uint256 public releasedSupply;
642     uint    public releasedCount = 0;
643     uint    public cycleCount = 0;
644     uint256 public firstReleaseAmount;
645     uint256 public curReleaseAmount;
646 
647     uint256 public createTime = 0;
648     uint256 public lastReleaseTime = 0;
649 
650     modifier validAddress(address _address) {
651         assert(0x0 != _address);
652         _;
653     }
654 
655     function YunMint(address _operator) public validAddress(_operator) Operational(_operator) {
656         createTime = block.timestamp;
657         totalSupply_ = valueTotal;
658         firstReleaseAmount = 200000 * (10 ** 8);
659     }
660 
661     function batchTransfer(address[] _to, uint256[] _amount) public returns(bool success) {
662         for(uint i = 0; i < _to.length; i++){
663             require(transfer(_to[i], _amount[i]));
664         }
665         return true;
666     }
667 
668     function release(uint256 timestamp) public onlyOperator returns(bool) {
669         require(timestamp <= block.timestamp);
670         if(lastReleaseTime > 0){
671             require(timestamp > lastReleaseTime);
672         }
673         require(!hasItBeenReleased(timestamp));
674 
675         cycleCount = releasedCount.div(30);
676         require(cycleCount < 100);
677         require(releasedSupply < valueTotal);
678 
679         curReleaseAmount = firstReleaseAmount - (cycleCount * 2000 * (10 ** 8));
680         balances[owner] = balances[owner].add(curReleaseAmount);
681         releasedSupply = releasedSupply.add(curReleaseAmount);
682 
683 
684         lastReleaseTime = timestamp;
685         releasedCount = releasedCount + 1;
686         emit Release(msg.sender, curReleaseAmount, lastReleaseTime);
687         emit Transfer(address(0), owner, curReleaseAmount);
688         return true;
689     }
690 
691 
692     function hasItBeenReleased(uint256 timestamp) internal view returns(bool _exist) {
693         bool exist = false;
694         if ((lastReleaseTime.parseTimestamp().year == timestamp.parseTimestamp().year)
695             && (lastReleaseTime.parseTimestamp().month == timestamp.parseTimestamp().month)
696             && (lastReleaseTime.parseTimestamp().day == timestamp.parseTimestamp().day)) {
697             exist = true;
698         }
699         return exist;
700     }
701 
702 
703 
704     function freeze(uint256 _value, uint256 _unFrozenTime) nonReentrant public returns (bool) {
705         require(balances[msg.sender] >= _value);
706         require(_unFrozenTime > createTime);
707         require(_unFrozenTime > block.timestamp);
708 
709         balances[msg.sender] = balances[msg.sender].sub(_value);
710         frozenBalances[frozenBalanceCount] = FrozenBalance({owner: msg.sender, value: _value, unFrozenTime: _unFrozenTime});
711         frozenBalanceCount++;
712         emit Freeze(msg.sender, _value, _unFrozenTime);
713         return true;
714     }
715 
716 
717     function frozenBalanceOf(address _owner) constant public returns (uint256 value) {
718         for (uint i = 0; i < frozenBalanceCount; i++) {
719             FrozenBalance storage frozenBalance = frozenBalances[i];
720             if (_owner == frozenBalance.owner) {
721                 value = value.add(frozenBalance.value);
722             }
723         }
724         return value;
725     }
726 
727 
728     function unfreeze() public returns (uint256 releaseAmount) {
729         uint index = 0;
730         while (index < frozenBalanceCount) {
731             if (now >= frozenBalances[index].unFrozenTime) {
732                 releaseAmount += frozenBalances[index].value;
733                 unFrozenBalanceByIndex(index);
734             } else {
735                 index++;
736             }
737         }
738         return releaseAmount;
739     }
740 
741     function unFrozenBalanceByIndex(uint index) internal {
742         FrozenBalance storage frozenBalance = frozenBalances[index];
743         balances[frozenBalance.owner] = balances[frozenBalance.owner].add(frozenBalance.value);
744         emit Unfreeze(frozenBalance.owner, frozenBalance.value, frozenBalance.unFrozenTime);
745         frozenBalances[index] = frozenBalances[frozenBalanceCount - 1];
746         delete frozenBalances[frozenBalanceCount - 1];
747         frozenBalanceCount--;
748     }
749 }
750 
751 
752 contract YunToken is YunMint {
753     string public standard = '2018062301';
754     string public name = 'YunToken';
755     string public symbol = 'YUN';
756     uint8 public decimals = 8;
757     function YunToken(address _operator) YunMint(_operator) public {}
758 }