1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     // uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return a / b;
20   }
21 
22   /**
23   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24   */
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   /**
31   * @dev Adds two numbers, throws on overflow.
32   */
33   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 library DateTime {
41         /*
42          *  Date and Time utilities for ethereum contracts
43          *
44          */
45         struct MyDateTime {
46                 uint16 year;
47                 uint8 month;
48                 uint8 day;
49                 uint8 hour;
50                 uint8 minute;
51                 uint8 second;
52                 uint8 weekday;
53         }
54         uint constant DAY_IN_SECONDS = 86400;
55         uint constant YEAR_IN_SECONDS = 31536000;
56         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
57         uint constant HOUR_IN_SECONDS = 3600;
58         uint constant MINUTE_IN_SECONDS = 60;
59         uint16 constant ORIGIN_YEAR = 1970;
60         function isLeapYear(uint16 year) constant returns (bool) {
61                 if (year % 4 != 0) {
62                         return false;
63                 }
64                 if (year % 100 != 0) {
65                         return true;
66                 }
67                 if (year % 400 != 0) {
68                         return false;
69                 }
70                 return true;
71         }
72         function leapYearsBefore(uint year) constant returns (uint) {
73                 year -= 1;
74                 return year / 4 - year / 100 + year / 400;
75         }
76         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
77                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
78                         return 31;
79                 }
80                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
81                         return 30;
82                 }
83                 else if (isLeapYear(year)) {
84                         return 29;
85                 }
86                 else {
87                         return 28;
88                 }
89         }
90         function parseTimestamp(uint timestamp) internal returns (MyDateTime dt) {
91                 uint secondsAccountedFor = 0;
92                 uint buf;
93                 uint8 i;
94                 // Year
95                 dt.year = getYear(timestamp);
96                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
97                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
98                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
99                 // Month
100                 uint secondsInMonth;
101                 for (i = 1; i <= 12; i++) {
102                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
103                         if (secondsInMonth + secondsAccountedFor > timestamp) {
104                                 dt.month = i;
105                                 break;
106                         }
107                         secondsAccountedFor += secondsInMonth;
108                 }
109                 // Day
110                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
111                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
112                                 dt.day = i;
113                                 break;
114                         }
115                         secondsAccountedFor += DAY_IN_SECONDS;
116                 }
117                 // Hour
118                 dt.hour = 0;//getHour(timestamp);
119                 // Minute
120                 dt.minute = 0;//getMinute(timestamp);
121                 // Second
122                 dt.second = 0;//getSecond(timestamp);
123                 // Day of week.
124                 dt.weekday = 0;//getWeekday(timestamp);
125         }
126         function getYear(uint timestamp) constant returns (uint16) {
127                 uint secondsAccountedFor = 0;
128                 uint16 year;
129                 uint numLeapYears;
130                 // Year
131                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
132                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
133                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
134                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
135                 while (secondsAccountedFor > timestamp) {
136                         if (isLeapYear(uint16(year - 1))) {
137                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
138                         }
139                         else {
140                                 secondsAccountedFor -= YEAR_IN_SECONDS;
141                         }
142                         year -= 1;
143                 }
144                 return year;
145         }
146         function getMonth(uint timestamp) constant returns (uint8) {
147                 return parseTimestamp(timestamp).month;
148         }
149         function getDay(uint timestamp) constant returns (uint8) {
150                 return parseTimestamp(timestamp).day;
151         }
152         function getHour(uint timestamp) constant returns (uint8) {
153                 return uint8((timestamp / 60 / 60) % 24);
154         }
155         function getMinute(uint timestamp) constant returns (uint8) {
156                 return uint8((timestamp / 60) % 60);
157         }
158         function getSecond(uint timestamp) constant returns (uint8) {
159                 return uint8(timestamp % 60);
160         }
161         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
162                 return toTimestamp(year, month, day, 0, 0, 0);
163         }
164         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
165                 uint16 i;
166                 // Year
167                 for (i = ORIGIN_YEAR; i < year; i++) {
168                         if (isLeapYear(i)) {
169                                 timestamp += LEAP_YEAR_IN_SECONDS;
170                         }
171                         else {
172                                 timestamp += YEAR_IN_SECONDS;
173                         }
174                 }
175                 // Month
176                 uint8[12] memory monthDayCounts;
177                 monthDayCounts[0] = 31;
178                 if (isLeapYear(year)) {
179                         monthDayCounts[1] = 29;
180                 }
181                 else {
182                         monthDayCounts[1] = 28;
183                 }
184                 monthDayCounts[2] = 31;
185                 monthDayCounts[3] = 30;
186                 monthDayCounts[4] = 31;
187                 monthDayCounts[5] = 30;
188                 monthDayCounts[6] = 31;
189                 monthDayCounts[7] = 31;
190                 monthDayCounts[8] = 30;
191                 monthDayCounts[9] = 31;
192                 monthDayCounts[10] = 30;
193                 monthDayCounts[11] = 31;
194                 for (i = 1; i < month; i++) {
195                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
196                 }
197                 // Day
198                 timestamp += DAY_IN_SECONDS * (day - 1);
199                 // Hour
200                 timestamp += HOUR_IN_SECONDS * (hour);
201                 // Minute
202                 timestamp += MINUTE_IN_SECONDS * (minute);
203                 // Second
204                 timestamp += second;
205                 return timestamp;
206         }
207 }
208 
209 contract ERC20Basic {
210   function totalSupply() public view returns (uint256);
211   function balanceOf(address who) public view returns (uint256);
212   function transfer(address to, uint256 value) public returns (bool);
213   event Transfer(address indexed from, address indexed to, uint256 value);
214 }
215 
216 contract ERC20 is ERC20Basic {
217   function allowance(address owner, address spender) public view returns (uint256);
218   function transferFrom(address from, address to, uint256 value) public returns (bool);
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 contract BasicToken is ERC20Basic {
224   using SafeMath for uint256;
225 
226   mapping(address => uint256) balances;
227 
228     uint8 public decimals = 18;
229     uint public allSupply = 54000000 ;    // 90000000 * 0.6
230     uint public freezeSupply = 36000000  * 10 ** uint256(decimals);   // 90000000 * 0.4
231     uint256 totalSupply_ = freezeSupply;  //  初始时 供应量为冻结量
232 
233   constructor() public {
234       balances[msg.sender] = 0;
235       //  冻结的货币量
236       balances[0x0] = freezeSupply;
237   }
238 
239 
240   function totalSupply() public view returns (uint256) {
241     return totalSupply_;
242   }
243 
244 
245   function transfer(address _to, uint256 _value) public returns (bool) {
246     require(_to != address(0));
247     require(_value <= balances[msg.sender]);
248 
249     balances[msg.sender] = balances[msg.sender].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     emit Transfer(msg.sender, _to, _value);
252     return true;
253   }
254 
255 
256   function balanceOf(address _owner) public view returns (uint256) {
257     return balances[_owner];
258   }
259 
260 }
261 
262 contract NBToken is ERC20, BasicToken {
263 
264   using DateTime for uint256;
265 
266   string public name = "NineBlock";
267   string public symbol = "NB";
268 
269   address owner;
270 
271   event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);
272 
273   uint256 public createTime;
274 
275   struct ReleaseRecord {
276       uint256 amount; // release amount
277       uint256 releasedTime; // release time
278   }
279 
280   mapping (uint => ReleaseRecord) public releasedRecords;
281   uint public releasedRecordsCount = 0;
282 
283     constructor() public {
284       owner = msg.sender;
285       createTime = now;
286     }
287 
288   modifier onlyOwner {
289     require(msg.sender == owner);
290     _;
291   }
292 
293 
294 
295   function transferOwnership(address newOwner) onlyOwner {
296     require(newOwner != address(0));
297     owner = newOwner;
298   }
299 
300 
301   mapping (address => mapping (address => uint256)) internal allowed;
302 
303   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
304     require(_to != address(0));
305     require(_value <= balances[_from]);
306     require(_value <= allowed[_from][msg.sender]);
307 
308     balances[_from] = balances[_from].sub(_value);
309     balances[_to] = balances[_to].add(_value);
310     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
311     emit Transfer(_from, _to, _value);
312     return true;
313   }
314 
315 
316   function approve(address _spender, uint256 _value) public returns (bool) {
317     allowed[msg.sender][_spender] = _value;
318     emit Approval(msg.sender, _spender, _value);
319     return true;
320   }
321 
322 
323   function allowance(address _owner, address _spender) public view returns (uint256) {
324     return allowed[_owner][_spender];
325   }
326 
327 
328   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
329     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
330     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334 
335   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
336     uint oldValue = allowed[msg.sender][_spender];
337     if (_subtractedValue > oldValue) {
338       allowed[msg.sender][_spender] = 0;
339     } else {
340       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
341     }
342     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346   // 每天释放调用这个方法
347   function releaseToday() public onlyOwner returns(uint256 _actualRelease) {
348     return releaseSupply(now);
349   }
350 
351   // 如果有哪天遗漏了，可以调用这个方法
352   function releaseSupply(uint256 timestamp) public onlyOwner returns(uint256 _actualRelease) {
353       require(timestamp >= createTime && timestamp <= now);
354       require(!judgeReleaseRecordExist(timestamp));
355 
356       uint award = updateAward(timestamp);
357 
358       balances[owner] = balances[owner].add(award);
359       totalSupply_ = totalSupply_.add(award);
360       releasedRecords[releasedRecordsCount] = ReleaseRecord(award, timestamp);
361       releasedRecordsCount++;
362       emit ReleaseSupply(owner, award, timestamp);
363       emit Transfer(0, owner, award);
364       return award;
365   }
366 
367   function judgeReleaseRecordExist(uint256 timestamp) internal returns(bool _exist) {
368       bool exist = false;
369       if (releasedRecordsCount > 0) {
370           for (uint index = 0; index < releasedRecordsCount; index++) {
371               if ((releasedRecords[index].releasedTime.parseTimestamp().year == timestamp.parseTimestamp().year)
372                   && (releasedRecords[index].releasedTime.parseTimestamp().month == timestamp.parseTimestamp().month)
373                   && (releasedRecords[index].releasedTime.parseTimestamp().day == timestamp.parseTimestamp().day)) {
374                   exist = true;
375               }
376           }
377       }
378       return exist;
379   }
380 
381   function updateAward(uint256 timestamp) internal returns(uint256 ) {
382 
383       uint passMonth  = now.sub(createTime) / 30 days + 1;
384 
385       if (passMonth == 1) {
386           return 270000 * 10 ** uint256(decimals);
387       } else if (passMonth == 2) {
388           return 252000 * 10 ** uint256(decimals);
389       } else if (passMonth == 3) {
390           return 234000 * 10 ** uint256(decimals);
391       } else if (passMonth == 4) {
392           return 216000 * 10 ** uint256(decimals);
393       } else if (passMonth == 5) {
394           return 198000 * 10 ** uint256(decimals);
395       } else if (passMonth == 6) {
396           return 180000 * 10 ** uint256(decimals);
397       } else if (passMonth == 7) {
398           return 162000 * 10 ** uint256(decimals);
399       } else if (passMonth == 8) {
400           return 144000 * 10 ** uint256(decimals);
401       } else if (passMonth == 9) {
402           return 144000 * 10 ** uint256(decimals);
403       }
404       return 0;
405 
406   }
407 
408 }