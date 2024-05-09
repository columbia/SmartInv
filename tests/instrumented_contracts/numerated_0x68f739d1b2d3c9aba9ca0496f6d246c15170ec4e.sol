1 pragma solidity ^0.4.11;
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
33         function isLeapYear(uint16 year) constant returns (bool) {
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
45         function leapYearsBefore(uint year) constant returns (uint) {
46                 year -= 1;
47                 return year / 4 - year / 100 + year / 400;
48         }
49         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
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
63         function parseTimestamp(uint timestamp) internal returns (MyDateTime dt) {
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
99         function getYear(uint timestamp) constant returns (uint16) {
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
119         function getMonth(uint timestamp) constant returns (uint8) {
120                 return parseTimestamp(timestamp).month;
121         }
122         function getDay(uint timestamp) constant returns (uint8) {
123                 return parseTimestamp(timestamp).day;
124         }
125         function getHour(uint timestamp) constant returns (uint8) {
126                 return uint8((timestamp / 60 / 60) % 24);
127         }
128         function getMinute(uint timestamp) constant returns (uint8) {
129                 return uint8((timestamp / 60) % 60);
130         }
131         function getSecond(uint timestamp) constant returns (uint8) {
132                 return uint8(timestamp % 60);
133         }
134         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
135                 return toTimestamp(year, month, day, 0, 0, 0);
136         }
137         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
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
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   function Ownable() {
193     owner = msg.sender;
194   }
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) onlyOwner {
207     require(newOwner != address(0));
208     owner = newOwner;
209   }
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
415 contract BonusToken is BurnableToken, Operational {
416     using SafeMath for uint;
417     using DateTime for uint256;
418     uint256 public createTime;
419     uint256 standardDecimals = 100000000;
420     uint256 minMakeBonusAmount = standardDecimals.mul(10);
421     function BonusToken(
422                      address operator
423                      ) Operational(operator) {}
424     function makeBonus(address[] _to, uint256[] _bonus) onlyOperator returns(bool) {
425         for(uint i = 0; i < _to.length; i++){
426             require(transfer(_to[i], _bonus[i]));
427         }
428         return true;
429     }
430 }
431 contract KuaiMintableToken is BonusToken {
432     uint256 public standardDailyLimit; // maximum amount of token can mint per day
433     uint256 public dailyLimitLeft = standardDecimals.mul(1000000); // daily limit left
434     uint256 public lastMintTime = 0;
435     event Mint(address indexed operator, uint256 value, uint256 mintTime);
436     event SetDailyLimit(address indexed operator, uint256 time);
437     function KuaiMintableToken(
438                     address operator,
439                     uint256 _dailyLimit
440                 ) BonusToken(operator) {
441         totalSupply = 0;
442         createTime = now;
443         lastMintTime = createTime;
444         standardDailyLimit = standardDecimals.mul(_dailyLimit);
445         dailyLimitLeft = standardDailyLimit;
446     }
447     // mint mintAmount token
448     function mint(uint256 mintAmount) onlyOperator returns(uint256 _actualRelease) {
449         uint256 timestamp = now;
450         require(!judgeIsReachDailyLimit(mintAmount, timestamp));
451         balances[owner] = balances[owner].add(mintAmount);
452         totalSupply = totalSupply.add(mintAmount);
453         Mint(msg.sender, mintAmount, timestamp);
454         return mintAmount;
455     }
456     function judgeIsReachDailyLimit(uint256 mintAmount, uint256 timestamp) internal returns(bool _exist) {
457         bool reached = false;
458         if (dailyLimitLeft > 0) {
459             if ((timestamp.parseTimestamp().year == lastMintTime.parseTimestamp().year)
460                 && (timestamp.parseTimestamp().month == lastMintTime.parseTimestamp().month)
461                 && (timestamp.parseTimestamp().day == lastMintTime.parseTimestamp().day)) {
462                 if (dailyLimitLeft < mintAmount) {
463                     reached = true;
464                 } else {
465                     dailyLimitLeft = dailyLimitLeft.sub(mintAmount);
466                     lastMintTime = timestamp;
467                 }
468             } else {
469                 dailyLimitLeft = standardDailyLimit;
470                 lastMintTime = timestamp;
471                 if (dailyLimitLeft < mintAmount) {
472                     reached = true;
473                 } else {
474                     dailyLimitLeft = dailyLimitLeft.sub(mintAmount);
475                 }
476             }
477         } else {
478             reached = true;
479         }
480         return reached;
481     }
482     // set standard daily limit
483     function setDailyLimit(uint256 _dailyLimit) onlyOwner returns(bool){
484         standardDailyLimit = _dailyLimit;
485         SetDailyLimit(msg.sender, now);
486         return true;
487     }
488 }
489 contract KuaiToken is KuaiMintableToken {
490     string public standard = '2018010901';
491     string public name = 'KuaiToken';
492     string public symbol = 'KT';
493     uint8 public decimals = 8;
494     function KuaiToken(
495                     address operator,
496                     uint256 dailyLimit
497                      ) KuaiMintableToken(operator, dailyLimit) {}
498 }