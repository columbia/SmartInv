1 pragma solidity ^0.4.18;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 library DateTime {
46         /*
47          *  Date and Time utilities for ethereum contracts
48          *
49          */
50         struct MyDateTime {
51                 uint16 year;
52                 uint8 month;
53                 uint8 day;
54                 uint8 hour;
55                 uint8 minute;
56                 uint8 second;
57                 uint8 weekday;
58         }
59         uint constant DAY_IN_SECONDS = 86400;
60         uint constant YEAR_IN_SECONDS = 31536000;
61         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
62         uint constant HOUR_IN_SECONDS = 3600;
63         uint constant MINUTE_IN_SECONDS = 60;
64         uint16 constant ORIGIN_YEAR = 1970;
65         function isLeapYear(uint16 year) internal pure returns (bool) {
66                 if (year % 4 != 0) {
67                         return false;
68                 }
69                 if (year % 100 != 0) {
70                         return true;
71                 }
72                 if (year % 400 != 0) {
73                         return false;
74                 }
75                 return true;
76         }
77         function leapYearsBefore(uint year) internal pure returns (uint) {
78                 year -= 1;
79                 return year / 4 - year / 100 + year / 400;
80         }
81         function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
82                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
83                         return 31;
84                 }
85                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
86                         return 30;
87                 }
88                 else if (isLeapYear(year)) {
89                         return 29;
90                 }
91                 else {
92                         return 28;
93                 }
94         }
95         function parseTimestamp(uint timestamp) internal pure returns (MyDateTime dt) {
96                 uint secondsAccountedFor = 0;
97                 uint buf;
98                 uint8 i;
99                 // Year
100                 dt.year = getYear(timestamp);
101                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
102                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
103                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
104                 // Month
105                 uint secondsInMonth;
106                 for (i = 1; i <= 12; i++) {
107                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
108                         if (secondsInMonth + secondsAccountedFor > timestamp) {
109                                 dt.month = i;
110                                 break;
111                         }
112                         secondsAccountedFor += secondsInMonth;
113                 }
114                 // Day
115                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
116                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
117                                 dt.day = i;
118                                 break;
119                         }
120                         secondsAccountedFor += DAY_IN_SECONDS;
121                 }
122                 // Hour
123                 dt.hour = 0;//getHour(timestamp);
124                 // Minute
125                 dt.minute = 0;//getMinute(timestamp);
126                 // Second
127                 dt.second = 0;//getSecond(timestamp);
128                 // Day of week.
129                 dt.weekday = 0;//getWeekday(timestamp);
130         }
131         function getYear(uint timestamp) internal pure returns (uint16) {
132                 uint secondsAccountedFor = 0;
133                 uint16 year;
134                 uint numLeapYears;
135                 // Year
136                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
137                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
138                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
139                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
140                 while (secondsAccountedFor > timestamp) {
141                         if (isLeapYear(uint16(year - 1))) {
142                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
143                         }
144                         else {
145                                 secondsAccountedFor -= YEAR_IN_SECONDS;
146                         }
147                         year -= 1;
148                 }
149                 return year;
150         }
151         function getMonth(uint timestamp) internal pure returns (uint8) {
152                 return parseTimestamp(timestamp).month;
153         }
154         function getDay(uint timestamp) internal pure returns (uint8) {
155                 return parseTimestamp(timestamp).day;
156         }
157         function getHour(uint timestamp) internal pure returns (uint8) {
158                 return uint8((timestamp / 60 / 60) % 24);
159         }
160         function getMinute(uint timestamp) internal pure returns (uint8) {
161                 return uint8((timestamp / 60) % 60);
162         }
163         function getSecond(uint timestamp) internal pure returns (uint8) {
164                 return uint8(timestamp % 60);
165         }
166         function toTimestamp(uint16 year, uint8 month, uint8 day) internal pure returns (uint timestamp) {
167                 return toTimestamp(year, month, day, 0, 0, 0);
168         }
169         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) internal pure returns (uint timestamp) {
170                 uint16 i;
171                 // Year
172                 for (i = ORIGIN_YEAR; i < year; i++) {
173                         if (isLeapYear(i)) {
174                                 timestamp += LEAP_YEAR_IN_SECONDS;
175                         }
176                         else {
177                                 timestamp += YEAR_IN_SECONDS;
178                         }
179                 }
180                 // Month
181                 uint8[12] memory monthDayCounts;
182                 monthDayCounts[0] = 31;
183                 if (isLeapYear(year)) {
184                         monthDayCounts[1] = 29;
185                 }
186                 else {
187                         monthDayCounts[1] = 28;
188                 }
189                 monthDayCounts[2] = 31;
190                 monthDayCounts[3] = 30;
191                 monthDayCounts[4] = 31;
192                 monthDayCounts[5] = 30;
193                 monthDayCounts[6] = 31;
194                 monthDayCounts[7] = 31;
195                 monthDayCounts[8] = 30;
196                 monthDayCounts[9] = 31;
197                 monthDayCounts[10] = 30;
198                 monthDayCounts[11] = 31;
199                 for (i = 1; i < month; i++) {
200                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
201                 }
202                 // Day
203                 timestamp += DAY_IN_SECONDS * (day - 1);
204                 // Hour
205                 timestamp += HOUR_IN_SECONDS * (hour);
206                 // Minute
207                 timestamp += MINUTE_IN_SECONDS * (minute);
208                 // Second
209                 timestamp += second;
210                 return timestamp;
211         }
212 }
213 /**
214  * @title Claimable
215  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
216  * This allows the new owner to accept the transfer.
217  */
218 contract Claimable is Ownable {
219   address public pendingOwner;
220   /**
221    * @dev Modifier throws if called by any account other than the pendingOwner.
222    */
223   modifier onlyPendingOwner() {
224     require(msg.sender == pendingOwner);
225     _;
226   }
227   /**
228    * @dev Allows the current owner to set the pendingOwner address.
229    * @param newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address newOwner) onlyOwner public {
232     pendingOwner = newOwner;
233   }
234   /**
235    * @dev Allows the pendingOwner address to finalize the transfer.
236    */
237   function claimOwnership() onlyPendingOwner public {
238     OwnershipTransferred(owner, pendingOwner);
239     owner = pendingOwner;
240     pendingOwner = address(0);
241   }
242 }
243 /**
244  * @title SafeMath
245  * @dev Math operations with safety checks that throw on error
246  */
247 library SafeMath {
248   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249     if (a == 0) {
250       return 0;
251     }
252     uint256 c = a * b;
253     assert(c / a == b);
254     return c;
255   }
256   function div(uint256 a, uint256 b) internal pure returns (uint256) {
257     // assert(b > 0); // Solidity automatically throws when dividing by 0
258     uint256 c = a / b;
259     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260     return c;
261   }
262   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263     assert(b <= a);
264     return a - b;
265   }
266   function add(uint256 a, uint256 b) internal pure returns (uint256) {
267     uint256 c = a + b;
268     assert(c >= a);
269     return c;
270   }
271 }
272 /**
273  * @title Basic token
274  * @dev Basic version of StandardToken, with no allowances.
275  */
276 contract BasicToken is ERC20Basic {
277   using SafeMath for uint256;
278   mapping(address => uint256) balances;
279   /**
280   * @dev transfer token for a specified address
281   * @param _to The address to transfer to.
282   * @param _value The amount to be transferred.
283   */
284   function transfer(address _to, uint256 _value) public returns (bool) {
285     require(_to != address(0));
286     require(_value <= balances[msg.sender]);
287     // SafeMath.sub will throw if there is not enough balance.
288     balances[msg.sender] = balances[msg.sender].sub(_value);
289     balances[_to] = balances[_to].add(_value);
290     Transfer(msg.sender, _to, _value);
291     return true;
292   }
293   /**
294   * @dev Gets the balance of the specified address.
295   * @param _owner The address to query the the balance of.
296   * @return An uint256 representing the amount owned by the passed address.
297   */
298   function balanceOf(address _owner) public view returns (uint256 balance) {
299     return balances[_owner];
300   }
301 }
302 /**
303  * @title ERC20 interface
304  * @dev see https://github.com/ethereum/EIPs/issues/20
305  */
306 contract ERC20 is ERC20Basic {
307   function allowance(address owner, address spender) public view returns (uint256);
308   function transferFrom(address from, address to, uint256 value) public returns (bool);
309   function approve(address spender, uint256 value) public returns (bool);
310   event Approval(address indexed owner, address indexed spender, uint256 value);
311 }
312 /**
313  * @title Standard ERC20 token
314  *
315  * @dev Implementation of the basic standard token.
316  * @dev https://github.com/ethereum/EIPs/issues/20
317  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
318  */
319 contract StandardToken is ERC20, BasicToken {
320   mapping (address => mapping (address => uint256)) internal allowed;
321   /**
322    * @dev Transfer tokens from one address to another
323    * @param _from address The address which you want to send tokens from
324    * @param _to address The address which you want to transfer to
325    * @param _value uint256 the amount of tokens to be transferred
326    */
327   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
328     require(_to != address(0));
329     require(_value <= balances[_from]);
330     require(_value <= allowed[_from][msg.sender]);
331     balances[_from] = balances[_from].sub(_value);
332     balances[_to] = balances[_to].add(_value);
333     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
334     Transfer(_from, _to, _value);
335     return true;
336   }
337   /**
338    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
339    *
340    * Beware that changing an allowance with this method brings the risk that someone may use both the old
341    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
342    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
343    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344    * @param _spender The address which will spend the funds.
345    * @param _value The amount of tokens to be spent.
346    */
347   function approve(address _spender, uint256 _value) public returns (bool) {
348     allowed[msg.sender][_spender] = _value;
349     Approval(msg.sender, _spender, _value);
350     return true;
351   }
352   /**
353    * @dev Function to check the amount of tokens that an owner allowed to a spender.
354    * @param _owner address The address which owns the funds.
355    * @param _spender address The address which will spend the funds.
356    * @return A uint256 specifying the amount of tokens still available for the spender.
357    */
358   function allowance(address _owner, address _spender) public view returns (uint256) {
359     return allowed[_owner][_spender];
360   }
361   /**
362    * @dev Increase the amount of tokens that an owner allowed to a spender.
363    *
364    * approve should be called when allowed[_spender] == 0. To increment
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _addedValue The amount of tokens to increase the allowance by.
370    */
371   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
372     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
373     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374     return true;
375   }
376   /**
377    * @dev Decrease the amount of tokens that an owner allowed to a spender.
378    *
379    * approve should be called when allowed[_spender] == 0. To decrement
380    * allowed value is better to use this function to avoid 2 calls (and wait until
381    * the first transaction is mined)
382    * From MonolithDAO Token.sol
383    * @param _spender The address which will spend the funds.
384    * @param _subtractedValue The amount of tokens to decrease the allowance by.
385    */
386   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
387     uint oldValue = allowed[msg.sender][_spender];
388     if (_subtractedValue > oldValue) {
389       allowed[msg.sender][_spender] = 0;
390     } else {
391       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
392     }
393     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
394     return true;
395   }
396 }
397 /**
398  * @title Helps contracts guard agains reentrancy attacks.
399  * @author Remco Bloemen <remco@2π.com>
400  * @notice If you mark a function `nonReentrant`, you should also
401  * mark it `external`.
402  */
403 contract ReentrancyGuard {
404   /**
405    * @dev We use a single lock for the whole contract.
406    */
407   bool private reentrancy_lock = false;
408   /**
409    * @dev Prevents a contract from calling itself, directly or indirectly.
410    * @notice If you mark a function `nonReentrant`, you should also
411    * mark it `external`. Calling one nonReentrant function from
412    * another is not supported. Instead, you can implement a
413    * `private` function doing the actual work, and a `external`
414    * wrapper marked as `nonReentrant`.
415    */
416   modifier nonReentrant() {
417     require(!reentrancy_lock);
418     reentrancy_lock = true;
419     _;
420     reentrancy_lock = false;
421   }
422 }
423 /**
424  * @title Burnable Token
425  * @dev Token that can be irreversibly burned (destroyed).
426  */
427 contract StandardBurnableToken is StandardToken {
428     event Burn(address indexed burner, uint256 value);
429     /**
430      * @dev Burns a specific amount of tokens.
431      * @param _value The amount of token to be burned.
432      */
433     function burn(uint256 _value) public returns (bool) {
434         require(_value <= balances[msg.sender]);
435         // no need to require value <= totalSupply, since that would imply the
436         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
437         address burner = msg.sender;
438         balances[burner] = balances[burner].sub(_value);
439         totalSupply = totalSupply.sub(_value);
440         Burn(burner, _value);
441         return true;
442     }
443 }
444 contract Operational is Claimable {
445     address public operator;
446     function Operational(address _operator) public {
447       operator = _operator;
448     }
449     modifier onlyOperator() {
450       require(msg.sender == operator);
451       _;
452     }
453     function transferOperator(address newOperator) public onlyOwner {
454       require(newOperator != address(0));
455       operator = newOperator;
456     }
457 }
458 contract Frozenable is Operational, StandardBurnableToken, ReentrancyGuard {
459     struct FrozenBalance {
460         address owner;
461         uint256 value;
462         uint256 unfreezeTime;
463     }
464     mapping (uint => FrozenBalance) public frozenBalances;
465     uint public frozenBalanceCount;
466     uint256 mulDecimals = 100000000; // match decimals
467     event SystemFreeze(address indexed owner, uint256 value, uint256 unfreezeTime);
468     event Unfreeze(address indexed owner, uint256 value, uint256 unfreezeTime);
469     event TransferSystemFreeze(address indexed owner, uint256 value, uint256 time);
470     function Frozenable(address _operator) Operational(_operator) public {}
471     // freeze system' balance
472     function systemFreeze(uint256 _value, uint256 _unfreezeTime) internal {
473         balances[owner] = balances[owner].sub(_value);
474         frozenBalances[frozenBalanceCount] = FrozenBalance({owner: owner, value: _value, unfreezeTime: _unfreezeTime});
475         frozenBalanceCount++;
476         SystemFreeze(owner, _value, _unfreezeTime);
477     }
478     // get frozen balance
479     function frozenBalanceOf(address _owner) public constant returns (uint256 value) {
480         for (uint i = 0; i < frozenBalanceCount; i++) {
481             FrozenBalance storage frozenBalance = frozenBalances[i];
482             if (_owner == frozenBalance.owner) {
483                 value = value.add(frozenBalance.value);
484             }
485         }
486         return value;
487     }
488     // unfreeze frozen amount
489     // everyone can call this function to unfreeze balance
490     function unfreeze() public returns (uint256 releaseAmount) {
491         uint index = 0;
492         while (index < frozenBalanceCount) {
493             if (now >= frozenBalances[index].unfreezeTime) {
494                 releaseAmount += frozenBalances[index].value;
495                 unfreezeBalanceByIndex(index);
496             } else {
497                 index++;
498             }
499         }
500         return releaseAmount;
501     }
502     function unfreezeBalanceByIndex(uint index) internal {
503         FrozenBalance storage frozenBalance = frozenBalances[index];
504         balances[frozenBalance.owner] = balances[frozenBalance.owner].add(frozenBalance.value);
505         Unfreeze(frozenBalance.owner, frozenBalance.value, frozenBalance.unfreezeTime);
506         frozenBalances[index] = frozenBalances[frozenBalanceCount - 1];
507         delete frozenBalances[frozenBalanceCount - 1];
508         frozenBalanceCount--;
509     }
510     function transferSystemFreeze() internal {
511         uint256 totalTransferSysFreezeAmount = 0;
512         for (uint i = 0; i < frozenBalanceCount; i++) {
513             frozenBalances[i].owner = owner;
514             totalTransferSysFreezeAmount += frozenBalances[i].value;
515         }
516         TransferSystemFreeze(owner, totalTransferSysFreezeAmount, now);
517     }
518 }
519 contract Releaseable is Frozenable {
520     using SafeMath for uint;
521     using DateTime for uint256;
522     uint256 public createTime;
523     uint256 public standardReleaseAmount = mulDecimals.mul(1024000); //
524     uint256 public releaseAmountPerDay = mulDecimals.mul(1024000);
525     uint256 public releasedSupply = 0;
526     event Release(address indexed receiver, uint256 value, uint256 sysAmount, uint256 releaseTime);
527     struct ReleaseRecord {
528         uint256 amount; // release amount
529         uint256 releaseTime; // release time
530     }
531     mapping (uint => ReleaseRecord) public releaseRecords;
532     uint public releaseRecordsCount = 0;
533     function Releaseable(
534                     address _operator, uint256 _initialSupply
535                 ) Frozenable(_operator) public {
536         createTime = 1514563200;
537         releasedSupply = _initialSupply;
538         balances[owner] = _initialSupply;
539         totalSupply = mulDecimals.mul(369280000);
540     }
541     function release(uint256 timestamp, uint256 sysAmount) public onlyOperator returns(uint256 _actualRelease) {
542         require(timestamp >= createTime && timestamp <= now);
543         require(!checkIsReleaseRecordExist(timestamp));
544         updateReleaseAmount(timestamp);
545         require(sysAmount <= releaseAmountPerDay.mul(4).div(5));
546         require(totalSupply >= releasedSupply.add(releaseAmountPerDay));
547         balances[owner] = balances[owner].add(releaseAmountPerDay);
548         releasedSupply = releasedSupply.add(releaseAmountPerDay);
549         releaseRecords[releaseRecordsCount] = ReleaseRecord(releaseAmountPerDay, timestamp);
550         releaseRecordsCount++;
551         Release(owner, releaseAmountPerDay, sysAmount, timestamp);
552         systemFreeze(sysAmount.div(5), timestamp.add(180 days));
553         systemFreeze(sysAmount.mul(7).div(10), timestamp.add(70 years));
554         return releaseAmountPerDay;
555     }
556     // check is release record existed
557     // if existed return true, else return false
558     function checkIsReleaseRecordExist(uint256 timestamp) internal view returns(bool _exist) {
559         bool exist = false;
560         if (releaseRecordsCount > 0) {
561             for (uint index = 0; index < releaseRecordsCount; index++) {
562                 if ((releaseRecords[index].releaseTime.parseTimestamp().year == timestamp.parseTimestamp().year)
563                     && (releaseRecords[index].releaseTime.parseTimestamp().month == timestamp.parseTimestamp().month)
564                     && (releaseRecords[index].releaseTime.parseTimestamp().day == timestamp.parseTimestamp().day)) {
565                     exist = true;
566                 }
567             }
568         }
569         return exist;
570     }
571     // update release amount for single day
572     // according to dividend rule in https://coinhot.com
573     function updateReleaseAmount(uint256 timestamp) internal {
574         uint256 timeElapse = timestamp.sub(createTime);
575         uint256 cycles = timeElapse.div(180 days);
576         if (cycles > 0) {
577             if (cycles <= 10) {
578                 releaseAmountPerDay = standardReleaseAmount;
579                 for (uint index = 0; index < cycles; index++) {
580                     releaseAmountPerDay = releaseAmountPerDay.div(2);
581                 }
582             } else {
583                 releaseAmountPerDay = 0;
584             }
585         }
586     }
587     function claimOwnership() onlyPendingOwner public {
588         OwnershipTransferred(owner, pendingOwner);
589         owner = pendingOwner;
590         pendingOwner = address(0);
591         transferSystemFreeze();
592     }
593 }
594 contract CoinHot is Releaseable {
595     string public standard = '2018011603';
596     string public name = 'CoinHot';
597     string public symbol = 'CHT';
598     uint8 public decimals = 8;
599     function CoinHot(
600                      address _operator, uint256 _initialSupply
601                      ) Releaseable(_operator, _initialSupply) public {}
602 }