1 pragma solidity ^0.4.23;
2 
3 library SafeMathLib {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         assert(b > 0);
13         uint256 c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract DateTimeLib {
31 
32     struct _DateTime {
33         uint16 year;
34         uint8 month;
35         uint8 day;
36         uint8 hour;
37         uint8 minute;
38         uint8 second;
39         uint8 weekday;
40     }
41 
42     uint constant DAY_IN_SECONDS = 86400;
43     uint constant YEAR_IN_SECONDS = 31536000;
44     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
45 
46     uint constant HOUR_IN_SECONDS = 3600;
47     uint constant MINUTE_IN_SECONDS = 60;
48 
49     uint16 constant ORIGIN_YEAR = 1970;
50 
51     function isLeapYear(uint16 year) internal pure returns (bool) {
52         if (year % 4 != 0) {
53             return false;
54         }
55         if (year % 100 != 0) {
56             return true;
57         }
58         if (year % 400 != 0) {
59             return false;
60         }
61         return true;
62     }
63 
64     function leapYearsBefore(uint year) internal pure returns (uint) {
65         year -= 1;
66         return year / 4 - year / 100 + year / 400;
67     }
68 
69     function getDaysInMonth(uint8 month, uint16 year) internal pure returns (uint8) {
70         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
71             return 31;
72         }
73         else if (month == 4 || month == 6 || month == 9 || month == 11) {
74             return 30;
75         }
76         else if (isLeapYear(year)) {
77             return 29;
78         }
79         else {
80             return 28;
81         }
82     }
83 
84     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
85         uint secondsAccountedFor = 0;
86         uint buf;
87         uint8 i;
88 
89         dt.year = getYear(timestamp);
90         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
91         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
92         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
93 
94         uint secondsInMonth;
95         for (i = 1; i <= 12; i++) {
96             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
97             if (secondsInMonth + secondsAccountedFor > timestamp) {
98                 dt.month = i;
99                 break;
100             }
101             secondsAccountedFor += secondsInMonth;
102         }
103 
104         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
105             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
106                 dt.day = i;
107                 break;
108             }
109             secondsAccountedFor += DAY_IN_SECONDS;
110         }
111         dt.hour = getHour(timestamp);
112         dt.minute = getMinute(timestamp);
113         dt.second = getSecond(timestamp);
114         dt.weekday = getWeekday(timestamp);
115     }
116 
117     function getYear(uint timestamp) internal pure returns (uint16) {
118         uint secondsAccountedFor = 0;
119         uint16 year;
120         uint numLeapYears;
121 
122         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
123         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
124 
125         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
126         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
127 
128         while (secondsAccountedFor > timestamp) {
129             if (isLeapYear(uint16(year - 1))) {
130                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
131             }
132             else {
133                 secondsAccountedFor -= YEAR_IN_SECONDS;
134             }
135             year -= 1;
136         }
137         return year;
138     }
139 
140     function getMonth(uint timestamp) internal pure returns (uint8) {
141         return parseTimestamp(timestamp).month;
142     }
143 
144     function getDay(uint timestamp) internal pure returns (uint8) {
145         return parseTimestamp(timestamp).day;
146     }
147 
148     function getHour(uint timestamp) internal pure returns (uint8) {
149         return uint8((timestamp / 60 / 60) % 24);
150     }
151 
152     function getMinute(uint timestamp) internal pure returns (uint8) {
153         return uint8((timestamp / 60) % 60);
154     }
155 
156     function getSecond(uint timestamp) internal pure returns (uint8) {
157         return uint8(timestamp % 60);
158     }
159 
160     function getWeekday(uint timestamp) internal pure returns (uint8) {
161         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
162     }
163 
164     function toTimestamp(uint16 year, uint8 month, uint8 day) internal pure returns (uint timestamp) {
165         return toTimestamp(year, month, day, 0, 0, 0);
166     }
167 
168     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) internal pure returns (uint timestamp) {
169         return toTimestamp(year, month, day, hour, 0, 0);
170     }
171 
172     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) internal pure returns (uint timestamp) {
173         return toTimestamp(year, month, day, hour, minute, 0);
174     }
175 
176     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) internal pure returns (uint timestamp) {
177         uint16 i;
178         for (i = ORIGIN_YEAR; i < year; i++) {
179             if (isLeapYear(i)) {
180                 timestamp += LEAP_YEAR_IN_SECONDS;
181             }
182             else {
183                 timestamp += YEAR_IN_SECONDS;
184             }
185         }
186 
187         uint8[12] memory monthDayCounts;
188         monthDayCounts[0] = 31;
189         if (isLeapYear(year)) {
190             monthDayCounts[1] = 29;
191         }
192         else {
193             monthDayCounts[1] = 28;
194         }
195         monthDayCounts[2] = 31;
196         monthDayCounts[3] = 30;
197         monthDayCounts[4] = 31;
198         monthDayCounts[5] = 30;
199         monthDayCounts[6] = 31;
200         monthDayCounts[7] = 31;
201         monthDayCounts[8] = 30;
202         monthDayCounts[9] = 31;
203         monthDayCounts[10] = 30;
204         monthDayCounts[11] = 31;
205 
206         for (i = 1; i < month; i++) {
207             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
208         }
209 
210         timestamp += DAY_IN_SECONDS * (day - 1);
211         timestamp += HOUR_IN_SECONDS * (hour);
212         timestamp += MINUTE_IN_SECONDS * (minute);
213         timestamp += second;
214 
215         return timestamp;
216     }
217 }
218 
219 interface IERC20 {
220     
221     function totalSupply() external constant returns (uint256);
222     function balanceOf(address _owner) external constant returns (uint256 balance);
223     function transfer(address _to, uint256 _value) external returns (bool success);
224     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
225     function approve(address _spender, uint256 _value) external returns (bool success);
226     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
227 
228     event Transfer(address indexed _from, address indexed _to, uint256 _value);
229     event Approval(address indexed _owner, address _spender, uint256 _value);
230 }
231 
232 contract StandardToken is IERC20,DateTimeLib {
233 
234     using SafeMathLib for uint256;
235 
236     mapping(address => uint256) balances;
237 
238     mapping(address => mapping(address => uint256)) allowed;
239     
240     string public constant symbol = "NAMY";
241     
242     string public constant name = "NamyChain Token";
243     
244     uint _totalSupply = 1000000000 * 10 ** 8;
245     
246     uint8 public constant decimals = 8;
247     
248     function totalSupply() external constant returns (uint256) {
249         return _totalSupply;
250     }
251     
252     function balanceOf(address _owner) external constant returns (uint256 balance) {
253         return balances[_owner];
254     }
255     
256     function transfer(address _to, uint256 _value) public returns (bool success) {
257         return transferInternal(msg.sender, _to, _value);
258     }
259 
260     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
261         require(_value > 0 && balances[_from] >= _value);
262         balances[_from] = balances[_from].sub(_value);
263         balances[_to] = balances[_to].add(_value);
264         emit Transfer(_from, _to, _value);
265         return true;
266     }
267 
268     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
269         require(_value > 0 && allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
270         balances[_from] = balances[_from].sub(_value);
271         balances[_to] = balances[_to].add(_value);
272         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273         emit Transfer(_from, _to, _value);
274         return true;
275     }
276 
277     function approve(address _spender, uint256 _value) public returns (bool success) {
278         allowed[msg.sender][_spender] = _value;
279         emit Approval(msg.sender, _spender, _value);
280         return true;
281     }
282 
283     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
284         return allowed[_owner][_spender];
285     }
286 }
287 
288 contract LockableToken is StandardToken {
289     
290     address internal developerReservedAddress = 0xbECbC200EDe5FAC310FD0224dA88FB8eFE2cf10D;
291     
292     uint[4] internal developerReservedUnlockTimes;
293     
294     uint256[4] internal developerReservedBalanceLimits;
295     
296     mapping(address => uint256) internal balanceLocks;
297 
298     mapping(address => uint) internal timeLocks;
299     
300     function getLockInfo(address _address) public constant returns (uint timeLock, uint256 balanceLock) {
301         return (timeLocks[_address], balanceLocks[_address]);
302     }
303     
304     function getDeveloperReservedBalanceLimit() internal returns (uint256 balanceLimit) {
305         uint time = now;
306         for (uint index = 0; index < developerReservedUnlockTimes.length; index++) {
307             if (developerReservedUnlockTimes[index] == 0x0) {
308                 continue;
309             }
310             if (time > developerReservedUnlockTimes[index]) {
311                 developerReservedUnlockTimes[index] = 0x0;
312             } else {
313                 return developerReservedBalanceLimits[index];
314             }
315         }
316         return 0;
317     }
318     
319     function transfer(address _to, uint256 _value) public returns (bool success) {
320         return transferInternal(msg.sender, _to, _value);
321     }
322 
323     function transferInternal(address _from, address _to, uint256 _value) internal returns (bool success) {
324         require(_from != 0x0 && _to != 0x0 && _value > 0x0);
325         if (_from == developerReservedAddress) {
326             uint256 balanceLimit = getDeveloperReservedBalanceLimit();
327             require(balances[_from].sub(balanceLimit) >= _value);
328         }
329         var(timeLock, balanceLock) = getLockInfo(_from);
330         if (timeLock <= now && timeLock != 0x0) {
331             timeLock = 0x0;
332             timeLocks[_from] = 0x0;
333             balanceLocks[_from] = 0x0;
334             emit UnLock(_from, timeLock, balanceLock);
335             balanceLock = 0x0;
336         }
337         if (timeLock != 0x0 && balanceLock > 0x0) {
338             require(balances[_from].sub(balanceLock) >= _value);
339         }
340         return super.transferInternal(_from, _to, _value);
341     }
342     
343     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
344         require(_from != 0x0 && _to != 0x0 && _value > 0x0);
345         if (_from == developerReservedAddress) {
346             uint256 balanceLimit = getDeveloperReservedBalanceLimit();
347             require(balances[_from].sub(balanceLimit) >= _value);
348         }
349         var(timeLock, balanceLock) = getLockInfo(_from);
350         if (timeLock <= now && timeLock != 0x0) {
351             timeLock = 0x0;
352             timeLocks[_from] = 0x0;
353             balanceLocks[_from] = 0x0;
354             emit UnLock(_from, timeLock, balanceLock);
355             balanceLock = 0x0;
356         }
357         if (timeLock != 0x0 && balanceLock > 0x0) {
358             require(balances[_from].sub(balanceLock) >= _value);
359         }
360         return super.transferFrom(_from, _to, _value);
361     }
362     
363     event DeveloperReservedUnlockTimeChanged(uint index, uint unlockTime, uint newUnlockTime);
364     event DeveloperReservedLockInfo(address indexed publicOfferingAddress, uint index, uint unlockTime, uint256 balanceLimit);
365     event Lock(address indexed lockAddress, uint timeLock, uint256 balanceLock);
366     event UnLock(address indexed lockAddress, uint timeLock, uint256 balanceLock);
367 }
368 
369 contract TradeableToken is LockableToken {
370 
371     address internal publicOfferingAddress = 0xe5eEB1357C74543B475BaAf6fED35f2B0D9e8Ef7;
372 
373     uint256 public exchangeRate = 7500;
374 
375     function buy(address _beneficiary, uint256 _weiAmount) internal {
376         require(_beneficiary != 0x0);
377         require(publicOfferingAddress != 0x0);
378         require(exchangeRate > 0x0);
379         require(_weiAmount > 0x0);
380 
381         uint256 exchangeToken = _weiAmount.mul(exchangeRate);
382         exchangeToken = exchangeToken.div(1 * 10 ** 10);
383 
384         publicOfferingAddress.transfer(_weiAmount);
385         super.transferInternal(publicOfferingAddress, _beneficiary, exchangeToken);
386     }
387     
388     event ExchangeRateChanged(uint256 oldExchangeRate,uint256 newExchangeRate);
389 }
390 
391 contract OwnableToken is TradeableToken {
392     
393     address internal owner = 0xd07cA79B4Cb32c2A91F23E7eC49BED63706aD207;
394     
395     mapping(address => uint) administrators;
396     
397     modifier onlyOwner() {
398         require(msg.sender == owner);
399         _;
400     }
401     
402     modifier onlyAdministrator() {
403         require(msg.sender == owner || administrators[msg.sender] > 0x0);
404         _;
405     }
406     
407     function transferOwnership(address _newOwner) onlyOwner public returns (bool success) {
408         require(_newOwner != address(0));
409         owner = _newOwner;
410         emit OwnershipTransferred(owner, _newOwner);
411         return true;
412     }
413     
414     function addAdministrator(address _adminAddress) onlyOwner public returns (bool success) {
415         require(_adminAddress != address(0));
416         require(administrators[_adminAddress] <= 0x0);
417         administrators[_adminAddress] = 0x1;
418         emit AddAdministrator(_adminAddress);
419         return true;
420     }
421     
422     function removeAdministrator(address _adminAddress) onlyOwner public returns (bool success) {
423         require(_adminAddress != address(0));
424         require(administrators[_adminAddress] > 0x0);
425         administrators[_adminAddress] = 0x0;
426         emit RemoveAdministrator(_adminAddress);
427         return true;
428     }
429     
430     function isAdministrator(address _adminAddress) view public returns (bool success) {
431         require(_adminAddress != address(0));
432         return (administrators[_adminAddress] == 0x1 || _adminAddress == owner);
433     }
434     
435     function setExchangeRate(uint256 _exchangeRate) public onlyAdministrator returns (bool success) {
436         require(_exchangeRate > 0x0);
437         uint256 oldExchangeRate = exchangeRate;
438         exchangeRate = _exchangeRate;
439         emit ExchangeRateChanged(oldExchangeRate, exchangeRate);
440         return true;
441     }
442     
443     function changeUnlockTime(uint _index, uint _unlockTime) public onlyAdministrator returns (bool success) {
444         require(_index >= 0x0 && _index < developerReservedUnlockTimes.length && _unlockTime > 0x0);
445         if(_index > 0x0) {
446             uint beforeUnlockTime = developerReservedUnlockTimes[_index - 1];
447             require(beforeUnlockTime == 0x0 || beforeUnlockTime < _unlockTime);
448         }
449         if(_index < developerReservedUnlockTimes.length - 1) {
450             uint afterUnlockTime = developerReservedUnlockTimes[_index + 1];
451             require(afterUnlockTime == 0x0 || _unlockTime < afterUnlockTime);
452         }
453         uint oldUnlockTime = developerReservedUnlockTimes[_index];
454         developerReservedUnlockTimes[_index] = _unlockTime;
455         emit DeveloperReservedUnlockTimeChanged(_index,oldUnlockTime,_unlockTime);
456         return true;
457     }
458     
459     function getDeveloperReservedLockInfo(uint _index) public onlyAdministrator returns (uint, uint256) {
460         require(_index >= 0x0 && _index < developerReservedUnlockTimes.length && _index < developerReservedBalanceLimits.length);
461         emit DeveloperReservedLockInfo(developerReservedAddress,_index,developerReservedUnlockTimes[_index],developerReservedBalanceLimits[_index]);
462         return (developerReservedUnlockTimes[_index], developerReservedBalanceLimits[_index]);
463     }
464     
465     function lock(address _owner, uint _releaseTime, uint256 _value) public onlyAdministrator returns (uint releaseTime, uint256 limit) {
466         require(_owner != 0x0 && _value > 0x0 && _releaseTime >= now);
467         balanceLocks[_owner] = _value;
468         timeLocks[_owner] = _releaseTime;
469         emit Lock(_owner, _releaseTime, _value);
470         return (_releaseTime, _value);
471     }
472 
473     function unlock(address _owner) public onlyAdministrator returns (bool) {
474         require(_owner != 0x0);
475         uint _releaseTime = timeLocks[_owner];
476         uint256 _value = balanceLocks[_owner];
477         balanceLocks[_owner] = 0x0;
478         timeLocks[_owner] = 0x0;
479         emit UnLock(_owner, _releaseTime, _value);
480         return true;
481     }
482 
483     function transferAndLock(address _to, uint256 _value, uint _releaseTime) public onlyAdministrator returns (bool success) {
484         require(_to != 0x0);
485         require(_value > 0);
486         require(_releaseTime >= now);
487         require(_value <= balances[msg.sender]);
488 
489         lock(_to, _releaseTime, _value);
490         super.transfer(_to, _value);
491         return true;
492     }
493     
494     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
495     event AddAdministrator(address indexed adminAddress);
496     event RemoveAdministrator(address indexed adminAddress);
497 }
498 
499 contract NAMY is OwnableToken {
500     
501     constructor() public {
502         balances[owner] = 500000000 * 10 ** 8;
503         balances[publicOfferingAddress] = 300000000 * 10 ** 8;
504 
505         uint256 developerReservedBalance = 200000000 * 10 ** 8;
506         balances[developerReservedAddress] = developerReservedBalance;
507         developerReservedUnlockTimes =
508         [
509         DateTimeLib.toTimestamp(2019, 8, 1),
510         DateTimeLib.toTimestamp(2020, 8, 1),
511         DateTimeLib.toTimestamp(2021, 8, 1),
512         DateTimeLib.toTimestamp(2022, 8, 1)
513         ];
514         developerReservedBalanceLimits = 
515         [
516             developerReservedBalance,
517             developerReservedBalance - (developerReservedBalance / 4) * 1,
518             developerReservedBalance - (developerReservedBalance / 4) * 2,
519             developerReservedBalance - (developerReservedBalance / 4) * 3
520         ];
521     }
522     
523     function() public payable {
524         buy(msg.sender, msg.value);
525     }
526 }