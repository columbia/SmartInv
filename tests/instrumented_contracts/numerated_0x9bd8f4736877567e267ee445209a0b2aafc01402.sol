1 pragma solidity ^0.4.15;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() {
25     owner = msg.sender;
26   }
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner {
39     require(newOwner != address(0));      
40     owner = newOwner;
41   }
42 }
43 library DateTime {
44         /*
45          *  Date and Time utilities for ethereum contracts
46          *
47          */
48         struct MyDateTime {
49                 uint16 year;
50                 uint8 month;
51                 uint8 day;
52                 uint8 hour;
53                 uint8 minute;
54                 uint8 second;
55                 uint8 weekday;
56         }
57         uint constant DAY_IN_SECONDS = 86400;
58         uint constant YEAR_IN_SECONDS = 31536000;
59         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
60         uint constant HOUR_IN_SECONDS = 3600;
61         uint constant MINUTE_IN_SECONDS = 60;
62         uint16 constant ORIGIN_YEAR = 1970;
63         function isLeapYear(uint16 year) constant returns (bool) {
64                 if (year % 4 != 0) {
65                         return false;
66                 }
67                 if (year % 100 != 0) {
68                         return true;
69                 }
70                 if (year % 400 != 0) {
71                         return false;
72                 }
73                 return true;
74         }
75         function leapYearsBefore(uint year) constant returns (uint) {
76                 year -= 1;
77                 return year / 4 - year / 100 + year / 400;
78         }
79         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
80                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
81                         return 31;
82                 }
83                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
84                         return 30;
85                 }
86                 else if (isLeapYear(year)) {
87                         return 29;
88                 }
89                 else {
90                         return 28;
91                 }
92         }
93         function parseTimestamp(uint timestamp) internal returns (MyDateTime dt) {
94                 uint secondsAccountedFor = 0;
95                 uint buf;
96                 uint8 i;
97                 // Year
98                 dt.year = getYear(timestamp);
99                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
100                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
101                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
102                 // Month
103                 uint secondsInMonth;
104                 for (i = 1; i <= 12; i++) {
105                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
106                         if (secondsInMonth + secondsAccountedFor > timestamp) {
107                                 dt.month = i;
108                                 break;
109                         }
110                         secondsAccountedFor += secondsInMonth;
111                 }
112                 // Day
113                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
114                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
115                                 dt.day = i;
116                                 break;
117                         }
118                         secondsAccountedFor += DAY_IN_SECONDS;
119                 }
120                 // Hour
121                 dt.hour = 0;//getHour(timestamp);
122                 // Minute
123                 dt.minute = 0;//getMinute(timestamp);
124                 // Second
125                 dt.second = 0;//getSecond(timestamp);
126                 // Day of week.
127                 dt.weekday = 0;//getWeekday(timestamp);
128         }
129         function getYear(uint timestamp) constant returns (uint16) {
130                 uint secondsAccountedFor = 0;
131                 uint16 year;
132                 uint numLeapYears;
133                 // Year
134                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
135                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
136                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
137                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
138                 while (secondsAccountedFor > timestamp) {
139                         if (isLeapYear(uint16(year - 1))) {
140                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
141                         }
142                         else {
143                                 secondsAccountedFor -= YEAR_IN_SECONDS;
144                         }
145                         year -= 1;
146                 }
147                 return year;
148         }
149         function getMonth(uint timestamp) constant returns (uint8) {
150                 return parseTimestamp(timestamp).month;
151         }
152         function getDay(uint timestamp) constant returns (uint8) {
153                 return parseTimestamp(timestamp).day;
154         }
155         function getHour(uint timestamp) constant returns (uint8) {
156                 return uint8((timestamp / 60 / 60) % 24);
157         }
158         function getMinute(uint timestamp) constant returns (uint8) {
159                 return uint8((timestamp / 60) % 60);
160         }
161         function getSecond(uint timestamp) constant returns (uint8) {
162                 return uint8(timestamp % 60);
163         }
164         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
165                 return toTimestamp(year, month, day, 0, 0, 0);
166         }
167         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
168                 uint16 i;
169                 // Year
170                 for (i = ORIGIN_YEAR; i < year; i++) {
171                         if (isLeapYear(i)) {
172                                 timestamp += LEAP_YEAR_IN_SECONDS;
173                         }
174                         else {
175                                 timestamp += YEAR_IN_SECONDS;
176                         }
177                 }
178                 // Month
179                 uint8[12] memory monthDayCounts;
180                 monthDayCounts[0] = 31;
181                 if (isLeapYear(year)) {
182                         monthDayCounts[1] = 29;
183                 }
184                 else {
185                         monthDayCounts[1] = 28;
186                 }
187                 monthDayCounts[2] = 31;
188                 monthDayCounts[3] = 30;
189                 monthDayCounts[4] = 31;
190                 monthDayCounts[5] = 30;
191                 monthDayCounts[6] = 31;
192                 monthDayCounts[7] = 31;
193                 monthDayCounts[8] = 30;
194                 monthDayCounts[9] = 31;
195                 monthDayCounts[10] = 30;
196                 monthDayCounts[11] = 31;
197                 for (i = 1; i < month; i++) {
198                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
199                 }
200                 // Day
201                 timestamp += DAY_IN_SECONDS * (day - 1);
202                 // Hour
203                 timestamp += HOUR_IN_SECONDS * (hour);
204                 // Minute
205                 timestamp += MINUTE_IN_SECONDS * (minute);
206                 // Second
207                 timestamp += second;
208                 return timestamp;
209         }
210 }
211 /**
212  * @title Claimable
213  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
214  * This allows the new owner to accept the transfer.
215  */
216 contract Claimable is Ownable {
217   address public pendingOwner;
218   /**
219    * @dev Modifier throws if called by any account other than the pendingOwner.
220    */
221   modifier onlyPendingOwner() {
222     require(msg.sender == pendingOwner);
223     _;
224   }
225   /**
226    * @dev Allows the current owner to set the pendingOwner address.
227    * @param newOwner The address to transfer ownership to.
228    */
229   function transferOwnership(address newOwner) onlyOwner {
230     pendingOwner = newOwner;
231   }
232   /**
233    * @dev Allows the pendingOwner address to finalize the transfer.
234    */
235   function claimOwnership() onlyPendingOwner {
236     owner = pendingOwner;
237     pendingOwner = 0x0;
238   }
239 }
240 contract Operational is Claimable {
241     address public operator;
242     function Operational(address _operator) {
243       operator = _operator;
244     }
245     modifier onlyOperator() {
246       require(msg.sender == operator);
247       _;
248     }
249     function transferOperator(address newOperator) onlyOwner {
250       require(newOperator != address(0));
251       operator = newOperator;
252     }
253 }
254 /**
255  * @title SafeMath
256  * @dev Math operations with safety checks that throw on error
257  */
258 library SafeMath {
259   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
260     uint256 c = a * b;
261     assert(a == 0 || c / a == b);
262     return c;
263   }
264   function div(uint256 a, uint256 b) internal constant returns (uint256) {
265     // assert(b > 0); // Solidity automatically throws when dividing by 0
266     uint256 c = a / b;
267     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
268     return c;
269   }
270   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
271     assert(b <= a);
272     return a - b;
273   }
274   function add(uint256 a, uint256 b) internal constant returns (uint256) {
275     uint256 c = a + b;
276     assert(c >= a);
277     return c;
278   }
279 }
280 /**
281  * @title Basic token
282  * @dev Basic version of StandardToken, with no allowances. 
283  */
284 contract BasicToken is ERC20Basic {
285   using SafeMath for uint256;
286   mapping(address => uint256) balances;
287   /**
288   * @dev transfer token for a specified address
289   * @param _to The address to transfer to.
290   * @param _value The amount to be transferred.
291   */
292   function transfer(address _to, uint256 _value) returns (bool) {
293     balances[msg.sender] = balances[msg.sender].sub(_value);
294     balances[_to] = balances[_to].add(_value);
295     Transfer(msg.sender, _to, _value);
296     return true;
297   }
298   /**
299   * @dev Gets the balance of the specified address.
300   * @param _owner The address to query the the balance of. 
301   * @return An uint256 representing the amount owned by the passed address.
302   */
303   function balanceOf(address _owner) constant returns (uint256 balance) {
304     return balances[_owner];
305   }
306 }
307 /**
308  * @title ERC20 interface
309  * @dev see https://github.com/ethereum/EIPs/issues/20
310  */
311 contract ERC20 is ERC20Basic {
312   function allowance(address owner, address spender) constant returns (uint256);
313   function transferFrom(address from, address to, uint256 value) returns (bool);
314   function approve(address spender, uint256 value) returns (bool);
315   event Approval(address indexed owner, address indexed spender, uint256 value);
316 }
317 /**
318  * @title Standard ERC20 token
319  *
320  * @dev Implementation of the basic standard token.
321  * @dev https://github.com/ethereum/EIPs/issues/20
322  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
323  */
324 contract StandardToken is ERC20, BasicToken {
325   mapping (address => mapping (address => uint256)) allowed;
326   /**
327    * @dev Transfer tokens from one address to another
328    * @param _from address The address which you want to send tokens from
329    * @param _to address The address which you want to transfer to
330    * @param _value uint256 the amout of tokens to be transfered
331    */
332   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
333     var _allowance = allowed[_from][msg.sender];
334     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
335     // require (_value <= _allowance);
336     balances[_to] = balances[_to].add(_value);
337     balances[_from] = balances[_from].sub(_value);
338     allowed[_from][msg.sender] = _allowance.sub(_value);
339     Transfer(_from, _to, _value);
340     return true;
341   }
342   /**
343    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
344    * @param _spender The address which will spend the funds.
345    * @param _value The amount of tokens to be spent.
346    */
347   function approve(address _spender, uint256 _value) returns (bool) {
348     // To change the approve amount you first have to reduce the addresses`
349     //  allowance to zero by calling `approve(_spender, 0)` if it is not
350     //  already 0 to mitigate the race condition described here:
351     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
353     allowed[msg.sender][_spender] = _value;
354     Approval(msg.sender, _spender, _value);
355     return true;
356   }
357   /**
358    * @dev Function to check the amount of tokens that an owner allowed to a spender.
359    * @param _owner address The address which owns the funds.
360    * @param _spender address The address which will spend the funds.
361    * @return A uint256 specifing the amount of tokens still available for the spender.
362    */
363   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
364     return allowed[_owner][_spender];
365   }
366 }
367 /**
368  * @title Helps contracts guard agains rentrancy attacks.
369  * @author Remco Bloemen <remco@2π.com>
370  * @notice If you mark a function `nonReentrant`, you should also
371  * mark it `external`.
372  */
373 contract ReentrancyGuard {
374   /**
375    * @dev We use a single lock for the whole contract.
376    */
377   bool private rentrancy_lock = false;
378   /**
379    * @dev Prevents a contract from calling itself, directly or indirectly.
380    * @notice If you mark a function `nonReentrant`, you should also
381    * mark it `external`. Calling one nonReentrant function from
382    * another is not supported. Instead, you can implement a
383    * `private` function doing the actual work, and a `external`
384    * wrapper marked as `nonReentrant`.
385    */
386   modifier nonReentrant() {
387     require(!rentrancy_lock);
388     rentrancy_lock = true;
389     _;
390     rentrancy_lock = false;
391   }
392 }
393 /**
394  * @title Burnable Token
395  * @dev Token that can be irreversibly burned (destroyed).
396  */
397 contract BurnableToken is StandardToken {
398     event Burn(address indexed burner, uint256 value);
399     /**
400      * @dev Burns a specific amount of tokens.
401      * @param _value The amount of token to be burned.
402      */
403     function burn(uint256 _value) public returns (bool) {
404         require(_value > 0);
405         require(_value <= balances[msg.sender]);
406         // no need to require value <= totalSupply, since that would imply the
407         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
408         address burner = msg.sender;
409         balances[burner] = balances[burner].sub(_value);
410         totalSupply = totalSupply.sub(_value);
411         Burn(burner, _value);
412         return true;
413     }
414 }
415 contract FrozenableToken is Operational, BurnableToken, ReentrancyGuard {
416     uint256 public createTime;
417     struct FrozenBalance {
418         address owner;
419         uint256 value;
420         uint256 unFrozenTime;
421     }
422     mapping (uint => FrozenBalance) public frozenBalances;
423     uint public frozenBalanceCount;
424     event Freeze(address indexed owner, uint256 value, uint256 releaseTime);
425     event FreezeForOwner(address indexed owner, uint256 value, uint256 releaseTime);
426     event Unfreeze(address indexed owner, uint256 value, uint256 releaseTime);
427     // freeze _value token to _unFrozenTime
428     function freeze(uint256 _value, uint256 _unFrozenTime) nonReentrant returns (bool) {
429         require(balances[msg.sender] >= _value);
430         require(_unFrozenTime > createTime);
431         require(_unFrozenTime > now);
432         balances[msg.sender] = balances[msg.sender].sub(_value);
433         frozenBalances[frozenBalanceCount] = FrozenBalance({owner: msg.sender, value: _value, unFrozenTime: _unFrozenTime});
434         frozenBalanceCount++;
435         Freeze(msg.sender, _value, _unFrozenTime);
436         return true;
437     }
438     function freezeForOwner(uint256 _value, uint256 _unFrozenTime) onlyOperator returns(bool) {
439         require(balances[owner] >= _value);
440         require(_unFrozenTime > createTime);
441         require(_unFrozenTime > now);
442         balances[owner] = balances[owner].sub(_value);
443         frozenBalances[frozenBalanceCount] = FrozenBalance({owner: owner, value: _value, unFrozenTime: _unFrozenTime});
444         frozenBalanceCount++;
445         FreezeForOwner(owner, _value, _unFrozenTime);
446         return true;
447     }
448     // get frozen balance
449     function frozenBalanceOf(address _owner) constant returns (uint256 value) {
450         for (uint i = 0; i < frozenBalanceCount; i++) {
451             FrozenBalance storage frozenBalance = frozenBalances[i];
452             if (_owner == frozenBalance.owner) {
453                 value = value.add(frozenBalance.value);
454             }
455         }
456         return value;
457     }
458     // unfreeze frozen amount
459     function unfreeze() returns (uint256 releaseAmount) {
460         uint index = 0;
461         while (index < frozenBalanceCount) {
462             if (now >= frozenBalances[index].unFrozenTime) {
463                 releaseAmount += frozenBalances[index].value;
464                 unFrozenBalanceByIndex(index);
465             } else {
466                 index++;
467             }
468         }
469         return releaseAmount;
470     }
471     function unFrozenBalanceByIndex(uint index) internal {
472         FrozenBalance storage frozenBalance = frozenBalances[index];
473         balances[frozenBalance.owner] = balances[frozenBalance.owner].add(frozenBalance.value);
474         Unfreeze(frozenBalance.owner, frozenBalance.value, frozenBalance.unFrozenTime);
475         frozenBalances[index] = frozenBalances[frozenBalanceCount - 1];
476         delete frozenBalances[frozenBalanceCount - 1];
477         frozenBalanceCount--;
478     }
479 }
480 contract DragonReleaseableToken is FrozenableToken {
481     using SafeMath for uint;
482     using DateTime for uint256;
483     uint256 standardDecimals = 100000000; // match decimals
484     uint256 public award = standardDecimals.mul(51200); // award per day
485     event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);
486     struct ReleaseRecord {
487         uint256 amount; // release amount
488         uint256 releasedTime; // release time
489     }
490     mapping (uint => ReleaseRecord) public releasedRecords;
491     uint public releasedRecordsCount = 0;
492     function DragonReleaseableToken(
493                     address operator
494                 ) Operational(operator) {
495         createTime = 1509580800;
496     }
497     function releaseSupply(uint256 timestamp) onlyOperator returns(uint256 _actualRelease) {
498         require(timestamp >= createTime && timestamp <= now);
499         require(!judgeReleaseRecordExist(timestamp));
500         updateAward(timestamp);
501         balances[owner] = balances[owner].add(award);
502         totalSupply = totalSupply.add(award);
503         releasedRecords[releasedRecordsCount] = ReleaseRecord(award, timestamp);
504         releasedRecordsCount++;
505         ReleaseSupply(owner, award, timestamp);
506         return award;
507     }
508     function judgeReleaseRecordExist(uint256 timestamp) internal returns(bool _exist) {
509         bool exist = false;
510         if (releasedRecordsCount > 0) {
511             for (uint index = 0; index < releasedRecordsCount; index++) {
512                 if ((releasedRecords[index].releasedTime.parseTimestamp().year == timestamp.parseTimestamp().year)
513                     && (releasedRecords[index].releasedTime.parseTimestamp().month == timestamp.parseTimestamp().month)
514                     && (releasedRecords[index].releasedTime.parseTimestamp().day == timestamp.parseTimestamp().day)) {
515                     exist = true;
516                 }
517             }
518         }
519         return exist;
520     }
521     function updateAward(uint256 timestamp) internal {
522         if (timestamp < createTime.add(1 years)) {
523             award = standardDecimals.mul(51200);
524         } else if (timestamp < createTime.add(2 years)) {
525             award = standardDecimals.mul(25600);
526         } else if (timestamp < createTime.add(3 years)) {
527             award = standardDecimals.mul(12800);
528         } else if (timestamp < createTime.add(4 years)) {
529             award = standardDecimals.mul(6400);
530         } else if (timestamp < createTime.add(5 years)) {
531             award = standardDecimals.mul(3200);
532         } else if (timestamp < createTime.add(6 years)) {
533             award = standardDecimals.mul(1600);
534         } else if (timestamp < createTime.add(7 years)) {
535             award = standardDecimals.mul(800);
536         } else if (timestamp < createTime.add(8 years)) {
537             award = standardDecimals.mul(400);
538         } else if (timestamp < createTime.add(9 years)) {
539             award = standardDecimals.mul(200);
540         } else if (timestamp < createTime.add(10 years)) {
541             award = standardDecimals.mul(100);
542         } else {
543             award = 0;
544         }
545     }
546 }
547 contract DragonToken is DragonReleaseableToken {
548     string public standard = '2017111504';
549     string public name = 'DragonToken';
550     string public symbol = 'DT';
551     uint8 public decimals = 8;
552     function DragonToken(
553                      address operator
554                      ) DragonReleaseableToken(operator) {}
555 }