1 pragma solidity ^0.4.11;
2 
3 library DateTimeLib {
4     /*
5      *  Date and Time utilities for ethereum contracts
6      *
7      */
8     struct _DateTime {
9         uint16 year;
10         uint8 month;
11         uint8 day;
12         uint8 hour;
13         uint8 minute;
14         uint8 second;
15         uint8 weekday;
16     }
17 
18     uint constant DAY_IN_SECONDS = 86400;
19     uint constant YEAR_IN_SECONDS = 31536000;
20     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
21 
22     uint constant HOUR_IN_SECONDS = 3600;
23     uint constant MINUTE_IN_SECONDS = 60;
24 
25     uint16 constant ORIGIN_YEAR = 1970;
26 
27     function isLeapYear(uint16 year) public pure returns (bool) {
28         if (year % 4 != 0) {
29             return false;
30         }
31         if (year % 100 != 0) {
32             return true;
33         }
34         if (year % 400 != 0) {
35             return false;
36         }
37         return true;
38     }
39 
40     function leapYearsBefore(uint year) public pure returns (uint) {
41         year -= 1;
42         return year / 4 - year / 100 + year / 400;
43     }
44 
45     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
46         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
47             return 31;
48         }
49         else if (month == 4 || month == 6 || month == 9 || month == 11) {
50             return 30;
51         }
52         else if (isLeapYear(year)) {
53             return 29;
54         }
55         else {
56             return 28;
57         }
58     }
59 
60     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
61         uint secondsAccountedFor = 0;
62         uint buf;
63         uint8 i;
64 
65         // Year
66         dt.year = getYear(timestamp);
67         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
68 
69         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
70         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
71 
72         // Month
73         uint secondsInMonth;
74         for (i = 1; i <= 12; i++) {
75             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
76             if (secondsInMonth + secondsAccountedFor > timestamp) {
77                 dt.month = i;
78                 break;
79             }
80             secondsAccountedFor += secondsInMonth;
81         }
82 
83         // Day
84         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
85             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
86                 dt.day = i;
87                 break;
88             }
89             secondsAccountedFor += DAY_IN_SECONDS;
90         }
91 
92         // Hour
93         dt.hour = getHour(timestamp);
94 
95         // Minute
96         dt.minute = getMinute(timestamp);
97 
98         // Second
99         dt.second = getSecond(timestamp);
100 
101         // Day of week.
102         dt.weekday = getWeekday(timestamp);
103     }
104 
105     function getYear(uint timestamp) public pure returns (uint16) {
106         uint secondsAccountedFor = 0;
107         uint16 year;
108         uint numLeapYears;
109 
110         // Year
111         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
112         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
113 
114         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
115         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
116 
117         while (secondsAccountedFor > timestamp) {
118             if (isLeapYear(uint16(year - 1))) {
119                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
120             }
121             else {
122                 secondsAccountedFor -= YEAR_IN_SECONDS;
123             }
124             year -= 1;
125         }
126         return year;
127     }
128 
129     function getMonth(uint timestamp) public pure returns (uint8) {
130         return parseTimestamp(timestamp).month;
131     }
132 
133     function getDay(uint timestamp) public pure returns (uint8) {
134         return parseTimestamp(timestamp).day;
135     }
136 
137     function getHour(uint timestamp) public pure returns (uint8) {
138         return uint8((timestamp / 60 / 60) % 24);
139     }
140 
141     function getMinute(uint timestamp) public pure returns (uint8) {
142         return uint8((timestamp / 60) % 60);
143     }
144 
145     function getSecond(uint timestamp) public pure returns (uint8) {
146         return uint8(timestamp % 60);
147     }
148 
149     function getWeekday(uint timestamp) public pure returns (uint8) {
150         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
151     }
152 
153     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
154         return toTimestamp(year, month, day, 0, 0, 0);
155     }
156 
157     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
158         return toTimestamp(year, month, day, hour, 0, 0);
159     }
160 
161     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
162         return toTimestamp(year, month, day, hour, minute, 0);
163     }
164 
165     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
166         uint16 i;
167 
168         // Year
169         for (i = ORIGIN_YEAR; i < year; i++) {
170             if (isLeapYear(i)) {
171                 timestamp += LEAP_YEAR_IN_SECONDS;
172             }
173             else {
174                 timestamp += YEAR_IN_SECONDS;
175             }
176         }
177 
178         // Month
179         uint8[12] memory monthDayCounts;
180         monthDayCounts[0] = 31;
181         if (isLeapYear(year)) {
182             monthDayCounts[1] = 29;
183         }
184         else {
185             monthDayCounts[1] = 28;
186         }
187         monthDayCounts[2] = 31;
188         monthDayCounts[3] = 30;
189         monthDayCounts[4] = 31;
190         monthDayCounts[5] = 30;
191         monthDayCounts[6] = 31;
192         monthDayCounts[7] = 31;
193         monthDayCounts[8] = 30;
194         monthDayCounts[9] = 31;
195         monthDayCounts[10] = 30;
196         monthDayCounts[11] = 31;
197 
198         for (i = 1; i < month; i++) {
199             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
200         }
201 
202         // Day
203         timestamp += DAY_IN_SECONDS * (day - 1);
204 
205         // Hour
206         timestamp += HOUR_IN_SECONDS * (hour);
207 
208         // Minute
209         timestamp += MINUTE_IN_SECONDS * (minute);
210 
211         // Second
212         timestamp += second;
213 
214         return timestamp;
215     }
216 }
217 
218 library SafeMathLib {
219 
220     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221         uint256 c = a * b;
222         assert(a == 0 || c / a == b);
223         return c;
224     }
225 
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         // assert(b > 0); // Solidity automatically throws when dividing by 0
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230         return c;
231     }
232 
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         assert(b <= a);
235         return a - b;
236     }
237 
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         uint256 c = a + b;
240         assert(c >= a);
241         return c;
242     }
243 }
244 
245 interface IERC20 {
246     //function totalSupply() public constant returns (uint256 totalSupply);
247     function balanceOf(address _owner) public constant returns (uint256 balance);
248 
249     function transfer(address _to, uint256 _value) public returns (bool success);
250 
251     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
252 
253     function approve(address _spender, uint256 _value) public returns (bool success);
254 
255     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
256 
257     event Transfer(address indexed _from, address indexed _to, uint256 _value);
258     event Approval(address indexed _owner, address _spender, uint256 _value);
259 }
260 
261 contract StandardToken is IERC20 {
262 
263     using SafeMathLib for uint256;
264 
265     mapping(address => uint256) balances;
266 
267     mapping(address => mapping(address => uint256)) allowed;
268 
269     function StandardToken() public payable {
270 
271     }
272 
273     function balanceOf(address _owner) public constant returns (uint256 balance) {
274         return balances[_owner];
275     }
276 
277     function transfer(address _to, uint256 _value) public returns (bool success) {
278         return transferInternal(msg.sender, _to, _value);
279     }
280 
281     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
282         require(_value > 0 && balances[_from] >= _value);
283         balances[_from] = balances[_from].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         Transfer(_from, _to, _value);
286         return true;
287     }
288 
289     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
290         require(_value > 0 && allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
291         balances[_from] = balances[_from].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
294         Transfer(_from, _to, _value);
295         return true;
296     }
297 
298     function approve(address _spender, uint256 _value) public returns (bool success) {
299         allowed[msg.sender][_spender] = _value;
300         Approval(msg.sender, _spender, _value);
301         return true;
302     }
303 
304     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
305         return allowed[_owner][_spender];
306     }
307 
308     event Transfer(address indexed _from, address indexed _to, uint256 _value);
309     event Approval(address indexed _owner, address _spender, uint256 _value);
310 }
311 
312 contract LockableToken is StandardToken {
313 
314     mapping(address => uint256) internal lockedBalance;
315 
316     mapping(address => uint) internal timeRelease;
317 
318     address internal teamReservedHolder;
319 
320     uint256 internal teamReservedBalance;
321 
322     uint [8] internal teamReservedFrozenDates;
323 
324     uint256 [8] internal teamReservedFrozenLimits;
325 
326     function LockableToken() public payable {
327 
328     }
329 
330     function lockInfo(address _address) public constant returns (uint timeLimit, uint256 balanceLimit) {
331         return (timeRelease[_address], lockedBalance[_address]);
332     }
333 
334     function teamReservedLimit() internal returns (uint256 balanceLimit) {
335         uint time = now;
336         for (uint index = 0; index < teamReservedFrozenDates.length; index++) {
337             if (teamReservedFrozenDates[index] == 0x0) {
338                 continue;
339             }
340             if (time > teamReservedFrozenDates[index]) {
341                 teamReservedFrozenDates[index] = 0x0;
342             } else {
343                 return teamReservedFrozenLimits[index];
344             }
345         }
346         return 0;
347     }
348 
349     function transfer(address _to, uint256 _value) public returns (bool success) {
350         return transferInternal(msg.sender, _to, _value);
351     }
352 
353     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
354         require(_to != 0x0 && _value > 0x0);
355         if (_from == teamReservedHolder) {
356             uint256 reservedLimit = teamReservedLimit();
357             require(balances[_from].sub(reservedLimit) >= _value);
358         }
359         var (timeLimit, lockLimit) = lockInfo(_from);
360         if (timeLimit <= now && timeLimit != 0x0) {
361             timeLimit = 0x0;
362             timeRelease[_from] = 0x0;
363             lockedBalance[_from] = 0x0;
364             UnLock(_from, lockLimit);
365             lockLimit = 0x0;
366         }
367         if (timeLimit != 0x0 && lockLimit > 0x0) {
368             require(balances[_from].sub(lockLimit) >= _value);
369         }
370         return super.transferInternal(_from, _to, _value);
371     }
372 
373     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
374         return transferFromInternal(_from, _to, _value);
375     }
376 
377     function transferFromInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
378         require(_to != 0x0 && _value > 0x0);
379         if (_from == teamReservedHolder) {
380             uint256 reservedLimit = teamReservedLimit();
381             require(balances[_from].sub(reservedLimit) >= _value);
382         }
383         var (timeLimit, lockLimit) = lockInfo(_from);
384         if (timeLimit <= now && timeLimit != 0x0) {
385             timeLimit = 0x0;
386             timeRelease[_from] = 0x0;
387             lockedBalance[_from] = 0x0;
388             UnLock(_from, lockLimit);
389             lockLimit = 0x0;
390         }
391         if (timeLimit != 0x0 && lockLimit > 0x0) {
392             require(balances[_from].sub(lockLimit) >= _value);
393         }
394         return super.transferFrom(_from, _to, _value);
395     }
396 
397     event Lock(address indexed owner, uint256 value, uint releaseTime);
398     event UnLock(address indexed owner, uint256 value);
399 }
400 
401 contract TradeableToken is LockableToken {
402 
403     address public publicOfferingHolder;
404 
405     uint256 internal baseExchangeRate;
406 
407     uint256 internal earlyExchangeRate;
408 
409     uint internal earlyEndTime;
410 
411     function TradeableToken() public payable {
412 
413     }
414 
415     function buy(address _beneficiary, uint256 _weiAmount) internal {
416         require(_beneficiary != 0x0);
417         require(publicOfferingHolder != 0x0);
418         require(earlyEndTime != 0x0 && baseExchangeRate != 0x0 && earlyExchangeRate != 0x0);
419         require(_weiAmount != 0x0);
420 
421         uint256 rate = baseExchangeRate;
422         if (now <= earlyEndTime) {
423             rate = earlyExchangeRate;
424         }
425         uint256 exchangeToken = _weiAmount.mul(rate);
426         exchangeToken = exchangeToken.div(1 * 10 ** 10);
427 
428         publicOfferingHolder.transfer(_weiAmount);
429         super.transferInternal(publicOfferingHolder, _beneficiary, exchangeToken);
430     }
431 }
432 
433 contract OwnableToken is TradeableToken {
434 
435     address internal owner;
436 
437     uint internal _totalSupply = 1500000000 * 10 ** 8;
438 
439     function OwnableToken() public payable {
440 
441     }
442 
443     /*
444      *  Modifiers
445      */
446     modifier onlyOwner() {
447         require(msg.sender == owner);
448         _;
449     }
450 
451     function transferOwnership(address _newOwner) onlyOwner public {
452         require(_newOwner != address(0));
453         owner = _newOwner;
454         OwnershipTransferred(owner, _newOwner);
455     }
456 
457     function lock(address _owner, uint256 _value, uint _releaseTime) public payable onlyOwner returns (uint releaseTime, uint256 limit) {
458         require(_owner != 0x0 && _value > 0x0 && _releaseTime >= now);
459         _value = lockedBalance[_owner].add(_value);
460         _releaseTime = _releaseTime >= timeRelease[_owner] ? _releaseTime : timeRelease[_owner];
461         lockedBalance[_owner] = _value;
462         timeRelease[_owner] = _releaseTime;
463         Lock(_owner, _value, _releaseTime);
464         return (_releaseTime, _value);
465     }
466 
467     function unlock(address _owner) public payable onlyOwner returns (bool) {
468         require(_owner != 0x0);
469         uint256 _value = lockedBalance[_owner];
470         lockedBalance[_owner] = 0x0;
471         timeRelease[_owner] = 0x0;
472         UnLock(_owner, _value);
473         return true;
474     }
475 
476     function transferAndLock(address _to, uint256 _value, uint _releaseTime) public payable onlyOwner returns (bool success) {
477         require(_to != 0x0);
478         require(_value > 0);
479         require(_releaseTime >= now);
480         require(_value <= balances[msg.sender]);
481 
482         super.transfer(_to, _value);
483         lock(_to, _value, _releaseTime);
484         return true;
485     }
486 
487     function setBaseExchangeRate(uint256 _baseExchangeRate) public payable onlyOwner returns (bool success) {
488         require(_baseExchangeRate > 0x0);
489         baseExchangeRate = _baseExchangeRate;
490         BaseExchangeRateChanged(baseExchangeRate);
491         return true;
492     }
493 
494     function setEarlyExchangeRate(uint256 _earlyExchangeRate) public payable onlyOwner returns (bool success) {
495         require(_earlyExchangeRate > 0x0);
496         earlyExchangeRate = _earlyExchangeRate;
497         EarlyExchangeRateChanged(earlyExchangeRate);
498         return true;
499     }
500 
501     function setEarlyEndTime(uint256 _earlyEndTime) public payable onlyOwner returns (bool success) {
502         require(_earlyEndTime > 0x0);
503         earlyEndTime = _earlyEndTime;
504         EarlyEndTimeChanged(earlyEndTime);
505         return true;
506     }
507 
508     function burn(uint256 _value) public payable onlyOwner returns (bool success) {
509         require(_value > 0x0);
510         require(_value <= balances[msg.sender]);
511 
512         balances[msg.sender] = balances[msg.sender].sub(_value);
513         _totalSupply = _totalSupply.sub(_value);
514         Burned(_value);
515         return true;
516     }
517 
518     function setPublicOfferingHolder(address _publicOfferingHolder) public payable onlyOwner returns (bool success) {
519         require(_publicOfferingHolder != 0x0);
520         publicOfferingHolder = _publicOfferingHolder;
521         return true;
522     }
523 
524     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
525     event BaseExchangeRateChanged(uint256 baseExchangeRate);
526     event EarlyExchangeRateChanged(uint256 earlyExchangeRate);
527     event EarlyEndTimeChanged(uint256 earlyEndTime);
528     event Burned(uint256 value);
529 }
530 
531 contract TenYunToken is OwnableToken {
532 
533     string public constant symbol = "TYC";
534 
535     string public constant name = "TenYun Coin";
536 
537     uint8 public constant decimals = 8;
538 
539     function TenYunToken() public payable {
540         owner = 0x593841e27b7122ef48F7854c7E7E1d5A374f8BB3;
541         balances[owner] = 1500000000 * 10 ** 8;
542 
543         publicOfferingHolder = 0x0B83ED7C57c335dCA9C978f78819A739AC67fD5D;
544         balances[publicOfferingHolder] = 0x0;
545         baseExchangeRate = 8500;
546         earlyExchangeRate = 9445;
547         earlyEndTime = 1516291200;
548 
549         teamReservedHolder = 0x6e4890764AA2Bba346459e2D6b811e26C9691704;
550         teamReservedBalance = 300000000 * 10 ** 8;
551         balances[teamReservedHolder] = 0x0;
552         teamReservedFrozenDates =
553         [
554         DateTimeLib.toTimestamp(2018, 4, 25),
555         DateTimeLib.toTimestamp(2018, 7, 25),
556         DateTimeLib.toTimestamp(2018, 10, 25),
557         DateTimeLib.toTimestamp(2019, 1, 25),
558         DateTimeLib.toTimestamp(2019, 4, 25),
559         DateTimeLib.toTimestamp(2019, 7, 25),
560         DateTimeLib.toTimestamp(2019, 10, 25),
561         DateTimeLib.toTimestamp(2020, 1, 25)
562         ];
563         teamReservedFrozenLimits =
564         [
565         teamReservedBalance,
566         teamReservedBalance - (teamReservedBalance / 8) * 1,
567         teamReservedBalance - (teamReservedBalance / 8) * 2,
568         teamReservedBalance - (teamReservedBalance / 8) * 3,
569         teamReservedBalance - (teamReservedBalance / 8) * 4,
570         teamReservedBalance - (teamReservedBalance / 8) * 5,
571         teamReservedBalance - (teamReservedBalance / 8) * 6,
572         teamReservedBalance - (teamReservedBalance / 8) * 7
573         ];
574     }
575 
576     // fallback function can be used to buy tokens
577     function() public payable {
578         buy(msg.sender, msg.value);
579     }
580 
581     function ethBalanceOf(address _owner) public constant returns (uint256){
582         return _owner.balance;
583     }
584 
585     function totalSupply() public constant returns (uint256 totalSupply) {
586         return _totalSupply;
587     }
588 }