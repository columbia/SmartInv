1 pragma solidity ^0.4.21;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 library DateTime {
14         /*
15          *  Date and Time utilities for ethereum contracts
16          *
17          */
18         struct MyDateTime {
19                 uint16 year;
20                 uint8 month;
21                 uint8 day;
22                 uint8 hour;
23                 uint8 minute;
24                 uint8 second;
25                 uint8 weekday;
26         }
27         uint constant DAY_IN_SECONDS = 86400;
28         uint constant YEAR_IN_SECONDS = 31536000;
29         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
30         uint constant HOUR_IN_SECONDS = 3600;
31         uint constant MINUTE_IN_SECONDS = 60;
32         uint16 constant ORIGIN_YEAR = 1970;
33         function isLeapYear(uint16 year) internal pure returns (bool) {
34                 if (year % 4 != 0) {
35                         return false;
36                 }
37                 if (year % 100 != 0) {
38                         return true;
39                 }
40                 if (year % 400 != 0) {
41                         return false;
42                 }
43                 return true;
44         }
45         function leapYearsBefore(uint year) internal pure returns (uint) {
46                 year -= 1;
47                 return year / 4 - year / 100 + year / 400;
48         }
49         function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
50                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
51                         return 31;
52                 }
53                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
54                         return 30;
55                 }
56                 else if (isLeapYear(year)) {
57                         return 29;
58                 }
59                 else {
60                         return 28;
61                 }
62         }
63         function parseTimestamp(uint timestamp) internal pure returns (MyDateTime dt) {
64                 uint secondsAccountedFor = 0;
65                 uint buf;
66                 uint8 i;
67                 // Year
68                 dt.year = getYear(timestamp);
69                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
70                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
71                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
72                 // Month
73                 uint secondsInMonth;
74                 for (i = 1; i <= 12; i++) {
75                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
76                         if (secondsInMonth + secondsAccountedFor > timestamp) {
77                                 dt.month = i;
78                                 break;
79                         }
80                         secondsAccountedFor += secondsInMonth;
81                 }
82                 // Day
83                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
84                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
85                                 dt.day = i;
86                                 break;
87                         }
88                         secondsAccountedFor += DAY_IN_SECONDS;
89                 }
90                 // Hour
91                 dt.hour = 0;//getHour(timestamp);
92                 // Minute
93                 dt.minute = 0;//getMinute(timestamp);
94                 // Second
95                 dt.second = 0;//getSecond(timestamp);
96                 // Day of week.
97                 dt.weekday = 0;//getWeekday(timestamp);
98         }
99         function getYear(uint timestamp) internal pure returns (uint16) {
100                 uint secondsAccountedFor = 0;
101                 uint16 year;
102                 uint numLeapYears;
103                 // Year
104                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
105                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
106                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
107                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
108                 while (secondsAccountedFor > timestamp) {
109                         if (isLeapYear(uint16(year - 1))) {
110                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
111                         }
112                         else {
113                                 secondsAccountedFor -= YEAR_IN_SECONDS;
114                         }
115                         year -= 1;
116                 }
117                 return year;
118         }
119         function getMonth(uint timestamp) internal pure returns (uint8) {
120                 return parseTimestamp(timestamp).month;
121         }
122         function getDay(uint timestamp) internal pure returns (uint8) {
123                 return parseTimestamp(timestamp).day;
124         }
125         function getHour(uint timestamp) internal pure returns (uint8) {
126                 return uint8((timestamp / 60 / 60) % 24);
127         }
128         function getMinute(uint timestamp) internal pure returns (uint8) {
129                 return uint8((timestamp / 60) % 60);
130         }
131         function getSecond(uint timestamp) internal pure returns (uint8) {
132                 return uint8(timestamp % 60);
133         }
134         function toTimestamp(uint16 year, uint8 month, uint8 day) internal pure returns (uint timestamp) {
135                 return toTimestamp(year, month, day, 0, 0, 0);
136         }
137         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) internal pure returns (uint timestamp) {
138                 uint16 i;
139                 // Year
140                 for (i = ORIGIN_YEAR; i < year; i++) {
141                         if (isLeapYear(i)) {
142                                 timestamp += LEAP_YEAR_IN_SECONDS;
143                         }
144                         else {
145                                 timestamp += YEAR_IN_SECONDS;
146                         }
147                 }
148                 // Month
149                 uint8[12] memory monthDayCounts;
150                 monthDayCounts[0] = 31;
151                 if (isLeapYear(year)) {
152                         monthDayCounts[1] = 29;
153                 }
154                 else {
155                         monthDayCounts[1] = 28;
156                 }
157                 monthDayCounts[2] = 31;
158                 monthDayCounts[3] = 30;
159                 monthDayCounts[4] = 31;
160                 monthDayCounts[5] = 30;
161                 monthDayCounts[6] = 31;
162                 monthDayCounts[7] = 31;
163                 monthDayCounts[8] = 30;
164                 monthDayCounts[9] = 31;
165                 monthDayCounts[10] = 30;
166                 monthDayCounts[11] = 31;
167                 for (i = 1; i < month; i++) {
168                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
169                 }
170                 // Day
171                 timestamp += DAY_IN_SECONDS * (day - 1);
172                 // Hour
173                 timestamp += HOUR_IN_SECONDS * (hour);
174                 // Minute
175                 timestamp += MINUTE_IN_SECONDS * (minute);
176                 // Second
177                 timestamp += second;
178                 return timestamp;
179         }
180 }
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187   address public owner;
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(msg.sender == owner);
201     _;
202   }
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     emit OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
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
238     emit OwnershipTransferred(owner, pendingOwner);
239     owner = pendingOwner;
240     pendingOwner = address(0);
241   }
242 }
243 /**
244  * @title SafeMath
245  * @dev Math operations with safety checks that throw on error
246  */
247 library SafeMath {
248   /**
249   * @dev Multiplies two numbers, throws on overflow.
250   */
251   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
252     if (a == 0) {
253       return 0;
254     }
255     c = a * b;
256     assert(c / a == b);
257     return c;
258   }
259   /**
260   * @dev Integer division of two numbers, truncating the quotient.
261   */
262   function div(uint256 a, uint256 b) internal pure returns (uint256) {
263     // assert(b > 0); // Solidity automatically throws when dividing by 0
264     // uint256 c = a / b;
265     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266     return a / b;
267   }
268   /**
269   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
270   */
271   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272     assert(b <= a);
273     return a - b;
274   }
275   /**
276   * @dev Adds two numbers, throws on overflow.
277   */
278   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
279     c = a + b;
280     assert(c >= a);
281     return c;
282   }
283 }
284 /**
285  * @title Basic token
286  * @dev Basic version of StandardToken, with no allowances.
287  */
288 contract BasicToken is ERC20Basic {
289   using SafeMath for uint256;
290   mapping(address => uint256) balances;
291   uint256 totalSupply_;
292   /**
293   * @dev total number of tokens in existence
294   */
295   function totalSupply() public view returns (uint256) {
296     return totalSupply_;
297   }
298   /**
299   * @dev transfer token for a specified address
300   * @param _to The address to transfer to.
301   * @param _value The amount to be transferred.
302   */
303   function transfer(address _to, uint256 _value) public returns (bool) {
304     require(_to != address(0));
305     require(_value <= balances[msg.sender]);
306     balances[msg.sender] = balances[msg.sender].sub(_value);
307     balances[_to] = balances[_to].add(_value);
308     emit Transfer(msg.sender, _to, _value);
309     return true;
310   }
311   /**
312   * @dev Gets the balance of the specified address.
313   * @param _owner The address to query the the balance of.
314   * @return An uint256 representing the amount owned by the passed address.
315   */
316   function balanceOf(address _owner) public view returns (uint256) {
317     return balances[_owner];
318   }
319 }
320 /**
321  * @title ERC20 interface
322  * @dev see https://github.com/ethereum/EIPs/issues/20
323  */
324 contract ERC20 is ERC20Basic {
325   function allowance(address owner, address spender) public view returns (uint256);
326   function transferFrom(address from, address to, uint256 value) public returns (bool);
327   function approve(address spender, uint256 value) public returns (bool);
328   event Approval(address indexed owner, address indexed spender, uint256 value);
329 }
330 /**
331  * @title Standard ERC20 token
332  *
333  * @dev Implementation of the basic standard token.
334  * @dev https://github.com/ethereum/EIPs/issues/20
335  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
336  */
337 contract StandardToken is ERC20, BasicToken {
338   mapping (address => mapping (address => uint256)) internal allowed;
339   /**
340    * @dev Transfer tokens from one address to another
341    * @param _from address The address which you want to send tokens from
342    * @param _to address The address which you want to transfer to
343    * @param _value uint256 the amount of tokens to be transferred
344    */
345   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
346     require(_to != address(0));
347     require(_value <= balances[_from]);
348     require(_value <= allowed[_from][msg.sender]);
349     balances[_from] = balances[_from].sub(_value);
350     balances[_to] = balances[_to].add(_value);
351     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
352     emit Transfer(_from, _to, _value);
353     return true;
354   }
355   /**
356    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
357    *
358    * Beware that changing an allowance with this method brings the risk that someone may use both the old
359    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
360    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
361    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362    * @param _spender The address which will spend the funds.
363    * @param _value The amount of tokens to be spent.
364    */
365   function approve(address _spender, uint256 _value) public returns (bool) {
366     allowed[msg.sender][_spender] = _value;
367     emit Approval(msg.sender, _spender, _value);
368     return true;
369   }
370   /**
371    * @dev Function to check the amount of tokens that an owner allowed to a spender.
372    * @param _owner address The address which owns the funds.
373    * @param _spender address The address which will spend the funds.
374    * @return A uint256 specifying the amount of tokens still available for the spender.
375    */
376   function allowance(address _owner, address _spender) public view returns (uint256) {
377     return allowed[_owner][_spender];
378   }
379   /**
380    * @dev Increase the amount of tokens that an owner allowed to a spender.
381    *
382    * approve should be called when allowed[_spender] == 0. To increment
383    * allowed value is better to use this function to avoid 2 calls (and wait until
384    * the first transaction is mined)
385    * From MonolithDAO Token.sol
386    * @param _spender The address which will spend the funds.
387    * @param _addedValue The amount of tokens to increase the allowance by.
388    */
389   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
390     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
391     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392     return true;
393   }
394   /**
395    * @dev Decrease the amount of tokens that an owner allowed to a spender.
396    *
397    * approve should be called when allowed[_spender] == 0. To decrement
398    * allowed value is better to use this function to avoid 2 calls (and wait until
399    * the first transaction is mined)
400    * From MonolithDAO Token.sol
401    * @param _spender The address which will spend the funds.
402    * @param _subtractedValue The amount of tokens to decrease the allowance by.
403    */
404   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
405     uint oldValue = allowed[msg.sender][_spender];
406     if (_subtractedValue > oldValue) {
407       allowed[msg.sender][_spender] = 0;
408     } else {
409       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
410     }
411     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
412     return true;
413   }
414 }
415 /**
416  * @title Helps contracts guard agains reentrancy attacks.
417  * @author Remco Bloemen <remco@2π.com>
418  * @notice If you mark a function `nonReentrant`, you should also
419  * mark it `external`.
420  */
421 contract ReentrancyGuard {
422   /**
423    * @dev We use a single lock for the whole contract.
424    */
425   bool private reentrancyLock = false;
426   /**
427    * @dev Prevents a contract from calling itself, directly or indirectly.
428    * @notice If you mark a function `nonReentrant`, you should also
429    * mark it `external`. Calling one nonReentrant function from
430    * another is not supported. Instead, you can implement a
431    * `private` function doing the actual work, and a `external`
432    * wrapper marked as `nonReentrant`.
433    */
434   modifier nonReentrant() {
435     require(!reentrancyLock);
436     reentrancyLock = true;
437     _;
438     reentrancyLock = false;
439   }
440 }
441 /**
442  * @title Burnable Token
443  * @dev Token that can be irreversibly burned (destroyed).
444  */
445 contract StandardBurnableToken is StandardToken {
446     event Burn(address indexed burner, uint256 value);
447     /**
448      * @dev Burns a specific amount of tokens.
449      * @param _value The amount of token to be burned.
450      */
451     function burn(uint256 _value) public returns (bool) {
452         require(_value <= balances[msg.sender]);
453         // no need to require value <= totalSupply, since that would imply the
454         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
455         address burner = msg.sender;
456         balances[burner] = balances[burner].sub(_value);
457         totalSupply_ = totalSupply_.sub(_value);
458         emit Burn(burner, _value);
459         return true;
460     }
461 }
462 contract Operational is Claimable {
463     address public operator;
464     function Operational(address _operator) public {
465       operator = _operator;
466     }
467     modifier onlyOperator() {
468       require(msg.sender == operator);
469       _;
470     }
471     function transferOperator(address newOperator) public onlyOwner {
472       require(newOperator != address(0));
473       operator = newOperator;
474     }
475 }
476 contract Frozenable is Operational, StandardBurnableToken, ReentrancyGuard {
477     using DateTime for uint256;
478     struct FrozenRecord {
479         uint256 value;
480         uint256 unfreezeIndex;
481     }
482     uint256 public frozenBalance;
483     mapping (uint256 => FrozenRecord) public frozenRecords;
484     uint256 mulDecimals = 100000000; // match decimals
485     event SystemFreeze(address indexed owner, uint256 value, uint256 unfreezeIndex);
486     event Unfreeze(address indexed owner, uint256 value, uint256 unfreezeTime);
487     function Frozenable(address _operator) Operational(_operator) public {}
488     // freeze system' balance
489     function systemFreeze(uint256 _value, uint256 _unfreezeTime) internal {
490         uint256 unfreezeIndex = uint256(_unfreezeTime.parseTimestamp().year) * 10000 + uint256(_unfreezeTime.parseTimestamp().month) * 100 + uint256(_unfreezeTime.parseTimestamp().day);
491         balances[owner] = balances[owner].sub(_value);
492         frozenRecords[unfreezeIndex] = FrozenRecord({value: _value, unfreezeIndex: unfreezeIndex});
493         frozenBalance = frozenBalance.add(_value);
494         emit SystemFreeze(owner, _value, _unfreezeTime);
495     }
496     // unfreeze frozen amount
497     // everyone can call this function to unfreeze balance
498     function unfreeze(uint256 timestamp) public returns (uint256 unfreezeAmount) {
499         require(timestamp <= block.timestamp);
500         uint256 unfreezeIndex = uint256(timestamp.parseTimestamp().year) * 10000 + uint256(timestamp.parseTimestamp().month) * 100 + uint256(timestamp.parseTimestamp().day);
501         frozenBalance = frozenBalance.sub(frozenRecords[unfreezeIndex].value);
502         balances[owner] = balances[owner].add(frozenRecords[unfreezeIndex].value);
503         unfreezeAmount = frozenRecords[unfreezeIndex].value;
504         emit Unfreeze(owner, unfreezeAmount, timestamp);
505         frozenRecords[unfreezeIndex].value = 0;
506         return unfreezeAmount;
507     }
508 }
509 contract Releaseable is Frozenable {
510     using SafeMath for uint;
511     uint256 public createTime;
512     uint256 public standardReleaseAmount = mulDecimals.mul(512000); //
513     uint256 public releaseAmountPerDay = mulDecimals.mul(512000);
514     uint256 public releasedSupply = 0;
515     event Release(address indexed receiver, uint256 value, uint256 sysAmount, uint256 releaseTime);
516     struct ReleaseRecord {
517         uint256 amount; // release amount
518         uint256 releaseIndex; // release time
519     }
520     mapping (uint256 => ReleaseRecord) public releaseRecords;
521     function Releaseable(
522                     address _operator, uint256 _initialSupply
523                 ) Frozenable(_operator) public {
524         createTime = 1529078400;
525         releasedSupply = _initialSupply;
526         balances[owner] = _initialSupply;
527         totalSupply_ = mulDecimals.mul(187140000);
528     }
529     function release(uint256 timestamp, uint256 sysAmount) public onlyOperator returns(uint256 _actualRelease) {
530         require(timestamp >= createTime && timestamp <= block.timestamp);
531         require(!checkIsReleaseRecordExist(timestamp));
532         updateReleaseAmount(timestamp);
533         require(sysAmount <= releaseAmountPerDay.mul(4).div(5));
534         require(totalSupply_ >= releasedSupply.add(releaseAmountPerDay));
535         balances[owner] = balances[owner].add(releaseAmountPerDay);
536         releasedSupply = releasedSupply.add(releaseAmountPerDay);
537         uint256 _releaseIndex = uint256(timestamp.parseTimestamp().year) * 10000 + uint256(timestamp.parseTimestamp().month) * 100 + uint256(timestamp.parseTimestamp().day);
538         releaseRecords[_releaseIndex] = ReleaseRecord(releaseAmountPerDay, _releaseIndex);
539         emit Release(owner, releaseAmountPerDay, sysAmount, timestamp);
540         systemFreeze(sysAmount.div(5), timestamp.add(180 days));
541         systemFreeze(sysAmount.mul(6).div(10), timestamp.add(200 years));
542         return releaseAmountPerDay;
543     }
544     // check is release record existed
545     // if existed return true, else return false
546     function checkIsReleaseRecordExist(uint256 timestamp) internal view returns(bool _exist) {
547         bool exist = false;
548         uint256 releaseIndex = uint256(timestamp.parseTimestamp().year) * 10000 + uint256(timestamp.parseTimestamp().month) * 100 + uint256(timestamp.parseTimestamp().day);
549         if (releaseRecords[releaseIndex].releaseIndex == releaseIndex){
550             exist = true;
551         }
552         return exist;
553     }
554     // update release amount for single day
555     // according to dividend rule in https://coincoolotc.com
556     function updateReleaseAmount(uint256 timestamp) internal {
557         uint256 timeElapse = timestamp.sub(createTime);
558         uint256 cycles = timeElapse.div(180 days);
559         if (cycles > 0) {
560             if (cycles <= 10) {
561                 releaseAmountPerDay = standardReleaseAmount;
562                 for (uint index = 0; index < cycles; index++) {
563                     releaseAmountPerDay = releaseAmountPerDay.div(2);
564                 }
565             } else {
566                 releaseAmountPerDay = 0;
567             }
568         }
569     }
570 }
571 contract CoinCool is Releaseable {
572     string public standard = '2018061610';
573     string public name = 'CoinCoolToken';
574     string public symbol = 'CCT';
575     uint8 public decimals = 8;
576     function CoinCool() Releaseable(0xe8358AfA9Bc309c4A106dc41782340b91817BC64, mulDecimals.mul(3000000)) public {}
577 }