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
167 
168         function toDay(uint256 timestamp) internal returns (uint256) {
169                 MyDateTime memory d = parseTimestamp(timestamp);
170                 return uint256(d.year) * 10000 + uint256(d.month) * 100 + uint256(d.day);
171         }
172         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
173                 uint16 i;
174                 // Year
175                 for (i = ORIGIN_YEAR; i < year; i++) {
176                         if (isLeapYear(i)) {
177                                 timestamp += LEAP_YEAR_IN_SECONDS;
178                         }
179                         else {
180                                 timestamp += YEAR_IN_SECONDS;
181                         }
182                 }
183                 // Month
184                 uint8[12] memory monthDayCounts;
185                 monthDayCounts[0] = 31;
186                 if (isLeapYear(year)) {
187                         monthDayCounts[1] = 29;
188                 }
189                 else {
190                         monthDayCounts[1] = 28;
191                 }
192                 monthDayCounts[2] = 31;
193                 monthDayCounts[3] = 30;
194                 monthDayCounts[4] = 31;
195                 monthDayCounts[5] = 30;
196                 monthDayCounts[6] = 31;
197                 monthDayCounts[7] = 31;
198                 monthDayCounts[8] = 30;
199                 monthDayCounts[9] = 31;
200                 monthDayCounts[10] = 30;
201                 monthDayCounts[11] = 31;
202                 for (i = 1; i < month; i++) {
203                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
204                 }
205                 // Day
206                 timestamp += DAY_IN_SECONDS * (day - 1);
207                 // Hour
208                 timestamp += HOUR_IN_SECONDS * (hour);
209                 // Minute
210                 timestamp += MINUTE_IN_SECONDS * (minute);
211                 // Second
212                 timestamp += second;
213                 return timestamp;
214         }
215 }
216 /**
217  * @title Claimable
218  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
219  * This allows the new owner to accept the transfer.
220  */
221 contract Claimable is Ownable {
222   address public pendingOwner;
223   /**
224    * @dev Modifier throws if called by any account other than the pendingOwner.
225    */
226   modifier onlyPendingOwner() {
227     require(msg.sender == pendingOwner);
228     _;
229   }
230   /**
231    * @dev Allows the current owner to set the pendingOwner address.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function transferOwnership(address newOwner) onlyOwner {
235     pendingOwner = newOwner;
236   }
237   /**
238    * @dev Allows the pendingOwner address to finalize the transfer.
239    */
240   function claimOwnership() onlyPendingOwner {
241     owner = pendingOwner;
242     pendingOwner = 0x0;
243   }
244 }
245 contract Operational is Claimable {
246     address public operator;
247     function Operational(address _operator) {
248       operator = _operator;
249     }
250     modifier onlyOperator() {
251       require(msg.sender == operator);
252       _;
253     }
254     function transferOperator(address newOperator) onlyOwner {
255       require(newOperator != address(0));
256       operator = newOperator;
257     }
258 }
259 /**
260  * @title SafeMath
261  * @dev Math operations with safety checks that throw on error
262  */
263 library SafeMath {
264   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
265     uint256 c = a * b;
266     assert(a == 0 || c / a == b);
267     return c;
268   }
269   function div(uint256 a, uint256 b) internal constant returns (uint256) {
270     // assert(b > 0); // Solidity automatically throws when dividing by 0
271     uint256 c = a / b;
272     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273     return c;
274   }
275   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
276     assert(b <= a);
277     return a - b;
278   }
279   function add(uint256 a, uint256 b) internal constant returns (uint256) {
280     uint256 c = a + b;
281     assert(c >= a);
282     return c;
283   }
284 }
285 /**
286  * @title Basic token
287  * @dev Basic version of StandardToken, with no allowances. 
288  */
289 contract BasicToken is ERC20Basic {
290   using SafeMath for uint256;
291   mapping(address => uint256) balances;
292   /**
293   * @dev transfer token for a specified address
294   * @param _to The address to transfer to.
295   * @param _value The amount to be transferred.
296   */
297   function transfer(address _to, uint256 _value) returns (bool) {
298     require(_to != address(0));
299     require(_value <= balances[msg.sender]);
300 
301     balances[msg.sender] = balances[msg.sender].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     Transfer(msg.sender, _to, _value);
304     return true;
305   }
306   /**
307   * @dev Gets the balance of the specified address.
308   * @param _owner The address to query the the balance of. 
309   * @return An uint256 representing the amount owned by the passed address.
310   */
311   function balanceOf(address _owner) constant returns (uint256 balance) {
312     return balances[_owner];
313   }
314 }
315 /**
316  * @title ERC20 interface
317  * @dev see https://github.com/ethereum/EIPs/issues/20
318  */
319 contract ERC20 is ERC20Basic {
320   function allowance(address owner, address spender) constant returns (uint256);
321   function transferFrom(address from, address to, uint256 value) returns (bool);
322   function approve(address spender, uint256 value) returns (bool);
323   event Approval(address indexed owner, address indexed spender, uint256 value);
324 }
325 /**
326  * @title Standard ERC20 token
327  *
328  * @dev Implementation of the basic standard token.
329  * @dev https://github.com/ethereum/EIPs/issues/20
330  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
331  */
332 contract StandardToken is ERC20, BasicToken {
333   mapping (address => mapping (address => uint256)) allowed;
334   /**
335    * @dev Transfer tokens from one address to another
336    * @param _from address The address which you want to send tokens from
337    * @param _to address The address which you want to transfer to
338    * @param _value uint256 the amout of tokens to be transfered
339    */
340   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
341     require(_to != address(0));
342     require(_value <= balances[_from]);
343     require(_value <= allowed[_from][msg.sender]);
344 
345     balances[_from] = balances[_from].sub(_value);
346     balances[_to] = balances[_to].add(_value);
347     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
348     Transfer(_from, _to, _value);
349     return true;
350   }
351   /**
352    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
353    * @param _spender The address which will spend the funds.
354    * @param _value The amount of tokens to be spent.
355    */
356   function approve(address _spender, uint256 _value) returns (bool) {
357     // To change the approve amount you first have to reduce the addresses`
358     //  allowance to zero by calling `approve(_spender, 0)` if it is not
359     //  already 0 to mitigate the race condition described here:
360     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
361     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
362     allowed[msg.sender][_spender] = _value;
363     Approval(msg.sender, _spender, _value);
364     return true;
365   }
366   /**
367    * @dev Function to check the amount of tokens that an owner allowed to a spender.
368    * @param _owner address The address which owns the funds.
369    * @param _spender address The address which will spend the funds.
370    * @return A uint256 specifing the amount of tokens still available for the spender.
371    */
372   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
373     return allowed[_owner][_spender];
374   }
375 }
376 /**
377  * @title Helps contracts guard agains rentrancy attacks.
378  * @author Remco Bloemen <remco@2π.com>
379  * @notice If you mark a function `nonReentrant`, you should also
380  * mark it `external`.
381  */
382 contract ReentrancyGuard {
383   /**
384    * @dev We use a single lock for the whole contract.
385    */
386   bool private rentrancy_lock = false;
387   /**
388    * @dev Prevents a contract from calling itself, directly or indirectly.
389    * @notice If you mark a function `nonReentrant`, you should also
390    * mark it `external`. Calling one nonReentrant function from
391    * another is not supported. Instead, you can implement a
392    * `private` function doing the actual work, and a `external`
393    * wrapper marked as `nonReentrant`.
394    */
395   modifier nonReentrant() {
396     require(!rentrancy_lock);
397     rentrancy_lock = true;
398     _;
399     rentrancy_lock = false;
400   }
401 }
402 /**
403  * @title Burnable Token
404  * @dev Token that can be irreversibly burned (destroyed).
405  */
406 contract BurnableToken is StandardToken {
407     event Burn(address indexed burner, uint256 value);
408     /**
409      * @dev Burns a specific amount of tokens.
410      * @param _value The amount of token to be burned.
411      */
412     function burn(uint256 _value) public returns (bool) {
413         require(_value > 0);
414         require(_value <= balances[msg.sender]);
415         // no need to require value <= totalSupply, since that would imply the
416         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
417         address burner = msg.sender;
418         balances[burner] = balances[burner].sub(_value);
419         totalSupply = totalSupply.sub(_value);
420         Burn(burner, _value);
421         return true;
422     }
423 }
424 contract FrozenableToken is Operational, BurnableToken, ReentrancyGuard {
425             using DateTime for uint256;
426     uint256 public createTime;
427     uint256 public frozenForever;
428     uint256 public frozenAnnually;
429 
430     struct FrozenRecord {
431         uint256 value;
432         uint256 day;
433     }
434     mapping (uint256 => FrozenRecord) public frozenBalances;
435 
436     event FreezeForOwner(address indexed owner, uint256 value, uint256 unFrozenTime);
437     event Unfreeze(address indexed owner, uint256 value);
438     // freeze _value token to _unFrozenTime
439 
440     function freezeForOwner(uint256 _value, uint256 _unFrozenTime) onlyOperator returns(bool) {
441         require(balances[owner] >= _value);
442         require(_unFrozenTime > createTime);
443         require(_unFrozenTime > now);  
444         if (_unFrozenTime.parseTimestamp().year - createTime.parseTimestamp().year > 10 ){
445                 balances[owner] = balances[owner].sub(_value);
446                 frozenForever = frozenForever.add(_value);
447                 FreezeForOwner(owner, _value, _unFrozenTime);
448         } else {
449                 uint256 day = _unFrozenTime.toDay();
450                 if (frozenBalances[day].day == day) {
451                         revert();
452                 }
453                 balances[owner] = balances[owner].sub(_value);
454                 frozenAnnually = frozenAnnually.add(_value);
455                 frozenBalances[day] = FrozenRecord( _value, day);
456                 FreezeForOwner(owner, _value, _unFrozenTime);
457         }
458 
459         return true;
460     }
461 
462     // unfreeze frozen amount
463     function unfreeze(uint256 _unFrozenTime) onlyOperator returns (bool) {
464         require(_unFrozenTime < block.timestamp);
465         uint256 day = _unFrozenTime.toDay();
466         uint256 _value = frozenBalances[day].value;
467         if (_value>0) {
468                 frozenBalances[day].value = 0;
469                 frozenAnnually = frozenAnnually.sub(_value);
470                 balances[owner] = balances[owner].add(_value);
471                 Unfreeze(owner, _value);
472         }
473         return true;
474     }
475 
476 }
477 contract DragonReleaseableToken is FrozenableToken {
478     using SafeMath for uint;
479     using DateTime for uint256;
480     uint256 standardDecimals = 100000000; // match decimals
481     uint256 public award = standardDecimals.mul(51200); // award per day
482     event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);
483     struct ReleaseRecord {
484         uint256 amount; // release amount
485         uint256 releasedDay;
486     }
487     mapping (uint256 => ReleaseRecord) public releasedRecords;
488     function DragonReleaseableToken(
489                     address operator
490                 ) Operational(operator) {
491         createTime = 1509580800;
492     }
493     function releaseSupply(uint256 timestamp) onlyOperator returns(uint256 _actualRelease) {
494         require(timestamp >= createTime && timestamp <= now);
495         require(!judgeReleaseRecordExist(timestamp));
496         updateAward(timestamp);
497         balances[owner] = balances[owner].add(award);
498         totalSupply = totalSupply.add(award);
499         uint256 releasedDay = timestamp.toDay();
500         releasedRecords[releasedDay] = ReleaseRecord(award, releasedDay);
501         ReleaseSupply(owner, award, timestamp);
502         return award;
503     }
504     function judgeReleaseRecordExist(uint256 timestamp) internal returns(bool _exist) {
505         bool exist = false;
506         uint256 day = timestamp.toDay();
507         if (releasedRecords[day].releasedDay == day){
508             exist = true;
509         }
510         return exist;
511     }
512     function updateAward(uint256 timestamp) internal {
513         if (timestamp < createTime.add(1 years)) {
514             award = standardDecimals.mul(51200);
515         } else if (timestamp < createTime.add(2 years)) {
516             award = standardDecimals.mul(25600);
517         } else if (timestamp < createTime.add(3 years)) {
518             award = standardDecimals.mul(12800);
519         } else if (timestamp < createTime.add(4 years)) {
520             award = standardDecimals.mul(6400);
521         } else if (timestamp < createTime.add(5 years)) {
522             award = standardDecimals.mul(3200);
523         } else if (timestamp < createTime.add(6 years)) {
524             award = standardDecimals.mul(1600);
525         } else if (timestamp < createTime.add(7 years)) {
526             award = standardDecimals.mul(800);
527         } else if (timestamp < createTime.add(8 years)) {
528             award = standardDecimals.mul(400);
529         } else if (timestamp < createTime.add(9 years)) {
530             award = standardDecimals.mul(200);
531         } else if (timestamp < createTime.add(10 years)) {
532             award = standardDecimals.mul(100);
533         } else {
534             award = 0;
535         }
536     }
537 }
538 contract DragonToken is DragonReleaseableToken {
539     string public standard = '2017111504';
540     string public name = 'DragonToken';
541     string public symbol = 'DT';
542     uint8 public decimals = 8;
543     function DragonToken(
544                      address operator
545                      ) DragonReleaseableToken(operator) {}
546 }