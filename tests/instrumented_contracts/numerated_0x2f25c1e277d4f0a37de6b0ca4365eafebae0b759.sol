1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         // uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return a / b;
20     }
21 
22     /**
23     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
24     */
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     /**
31     * @dev Adds two numbers, throws on overflow.
32     */
33     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34         c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 library DateTime {
41     /*
42      *  Date and Time utilities for ethereum contracts
43      *
44      */
45     struct MyDateTime {
46         uint16 year;
47         uint8 month;
48         uint8 day;
49         uint8 hour;
50         uint8 minute;
51         uint8 second;
52         uint8 weekday;
53     }
54 
55     uint constant DAY_IN_SECONDS = 86400;
56     uint constant YEAR_IN_SECONDS = 31536000;
57     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
58     uint constant HOUR_IN_SECONDS = 3600;
59     uint constant MINUTE_IN_SECONDS = 60;
60     uint16 constant ORIGIN_YEAR = 1970;
61 
62     function isLeapYear(uint16 year) constant returns (bool) {
63         if (year % 4 != 0) {
64             return false;
65         }
66         if (year % 100 != 0) {
67             return true;
68         }
69         if (year % 400 != 0) {
70             return false;
71         }
72         return true;
73     }
74 
75     function leapYearsBefore(uint year) constant returns (uint) {
76         year -= 1;
77         return year / 4 - year / 100 + year / 400;
78     }
79 
80     function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
81         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
82             return 31;
83         }
84         else if (month == 4 || month == 6 || month == 9 || month == 11) {
85             return 30;
86         }
87         else if (isLeapYear(year)) {
88             return 29;
89         }
90         else {
91             return 28;
92         }
93     }
94 
95     function parseTimestamp(uint timestamp) internal returns (MyDateTime dt) {
96         uint secondsAccountedFor = 0;
97         uint buf;
98         uint8 i;
99         // Year
100         dt.year = getYear(timestamp);
101         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
102         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
103         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
104         // Month
105         uint secondsInMonth;
106         for (i = 1; i <= 12; i++) {
107             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
108             if (secondsInMonth + secondsAccountedFor > timestamp) {
109                 dt.month = i;
110                 break;
111             }
112             secondsAccountedFor += secondsInMonth;
113         }
114         // Day
115         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
116             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
117                 dt.day = i;
118                 break;
119             }
120             secondsAccountedFor += DAY_IN_SECONDS;
121         }
122         // Hour
123         dt.hour = 0;
124         //getHour(timestamp);
125         // Minute
126         dt.minute = 0;
127         //getMinute(timestamp);
128         // Second
129         dt.second = 0;
130         //getSecond(timestamp);
131         // Day of week.
132         dt.weekday = 0;
133         //getWeekday(timestamp);
134     }
135 
136     function getYear(uint timestamp) constant returns (uint16) {
137         uint secondsAccountedFor = 0;
138         uint16 year;
139         uint numLeapYears;
140         // Year
141         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
142         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
143         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
144         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
145         while (secondsAccountedFor > timestamp) {
146             if (isLeapYear(uint16(year - 1))) {
147                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
148             }
149             else {
150                 secondsAccountedFor -= YEAR_IN_SECONDS;
151             }
152             year -= 1;
153         }
154         return year;
155     }
156 
157     function getMonth(uint timestamp) constant returns (uint8) {
158         return parseTimestamp(timestamp).month;
159     }
160 
161     function getDay(uint timestamp) constant returns (uint8) {
162         return parseTimestamp(timestamp).day;
163     }
164 
165     function getHour(uint timestamp) constant returns (uint8) {
166         return uint8((timestamp / 60 / 60) % 24);
167     }
168 
169     function getMinute(uint timestamp) constant returns (uint8) {
170         return uint8((timestamp / 60) % 60);
171     }
172 
173     function getSecond(uint timestamp) constant returns (uint8) {
174         return uint8(timestamp % 60);
175     }
176 
177     function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
178         return toTimestamp(year, month, day, 0, 0, 0);
179     }
180 
181     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
182         uint16 i;
183         // Year
184         for (i = ORIGIN_YEAR; i < year; i++) {
185             if (isLeapYear(i)) {
186                 timestamp += LEAP_YEAR_IN_SECONDS;
187             }
188             else {
189                 timestamp += YEAR_IN_SECONDS;
190             }
191         }
192         // Month
193         uint8[12] memory monthDayCounts;
194         monthDayCounts[0] = 31;
195         if (isLeapYear(year)) {
196             monthDayCounts[1] = 29;
197         }
198         else {
199             monthDayCounts[1] = 28;
200         }
201         monthDayCounts[2] = 31;
202         monthDayCounts[3] = 30;
203         monthDayCounts[4] = 31;
204         monthDayCounts[5] = 30;
205         monthDayCounts[6] = 31;
206         monthDayCounts[7] = 31;
207         monthDayCounts[8] = 30;
208         monthDayCounts[9] = 31;
209         monthDayCounts[10] = 30;
210         monthDayCounts[11] = 31;
211         for (i = 1; i < month; i++) {
212             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
213         }
214         // Day
215         timestamp += DAY_IN_SECONDS * (day - 1);
216         // Hour
217         timestamp += HOUR_IN_SECONDS * (hour);
218         // Minute
219         timestamp += MINUTE_IN_SECONDS * (minute);
220         // Second
221         timestamp += second;
222         return timestamp;
223     }
224 }
225 
226 contract ERC20Basic {
227     function totalSupply() public view returns (uint256);
228 
229     function balanceOf(address who) public view returns (uint256);
230 
231     function transfer(address to, uint256 value) public returns (bool);
232 
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 }
235 
236 contract ERC20 is ERC20Basic {
237     function allowance(address owner, address spender) public view returns (uint256);
238 
239     function transferFrom(address from, address to, uint256 value) public returns (bool);
240 
241     function approve(address spender, uint256 value) public returns (bool);
242 
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 contract BasicToken is ERC20Basic {
247     using SafeMath for uint256;
248 
249     mapping(address => uint256) balances;
250 
251     uint8 public decimals = 18;
252     uint public allSupply = 12600000; // 21000000 * 0.6
253     uint public freezeSupply = 8400000 * 10 ** uint256(decimals);   // 21000000 * 0.4
254     uint256 totalSupply_ = freezeSupply; 
255 
256     constructor() public {
257         balances[msg.sender] = 0;
258         balances[0x0] = freezeSupply;
259     }
260 
261 
262     function totalSupply() public view returns (uint256) {
263         return totalSupply_;
264     }
265 
266 
267     function transfer(address _to, uint256 _value) public returns (bool) {
268         require(_to != address(0));
269         require(_value <= balances[msg.sender]);
270 
271         balances[msg.sender] = balances[msg.sender].sub(_value);
272         balances[_to] = balances[_to].add(_value);
273         emit Transfer(msg.sender, _to, _value);
274         return true;
275     }
276 
277 
278     function balanceOf(address _owner) public view returns (uint256) {
279         return balances[_owner];
280     }
281 
282 }
283 
284 contract FBToken is ERC20, BasicToken {
285 
286     using DateTime for uint256;
287 
288     string public name = "FABI";
289     string public symbol = "FB";
290 
291     address owner;
292 
293 
294     uint public lastRelease = 15 * 10000000;   
295     uint public lastMonth = 1;                
296     uint public divBase = 100 * 10000000;
297     uint256 public award = 0;    
298 
299     event ReleaseSupply(address indexed receiver, uint256 value, uint256 releaseTime);
300 
301     uint256 public createTime;
302 
303     struct ReleaseRecord {
304         uint256 amount; // release amount
305         uint256 releasedTime; // release time
306     }
307 
308     mapping(uint => ReleaseRecord) public releasedRecords;
309     uint public releasedRecordsCount = 0;
310 
311     constructor() public {
312         owner = msg.sender;
313         createTime = now;
314     }
315 
316     modifier onlyOwner {
317         require(msg.sender == owner);
318         _;
319     }
320 
321 
322 
323     function transferOwnership(address newOwner) onlyOwner {
324         require(newOwner != address(0));
325         owner = newOwner;
326     }
327 
328 
329     mapping(address => mapping(address => uint256)) internal allowed;
330 
331     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
332         require(_to != address(0));
333         require(_value <= balances[_from]);
334         require(_value <= allowed[_from][msg.sender]);
335 
336         balances[_from] = balances[_from].sub(_value);
337         balances[_to] = balances[_to].add(_value);
338         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
339         emit Transfer(_from, _to, _value);
340         return true;
341     }
342 
343 
344     function approve(address _spender, uint256 _value) public returns (bool) {
345         allowed[msg.sender][_spender] = _value;
346         emit Approval(msg.sender, _spender, _value);
347         return true;
348     }
349 
350 
351     function allowance(address _owner, address _spender) public view returns (uint256) {
352         return allowed[_owner][_spender];
353     }
354 
355 
356     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
357         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
358         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
359         return true;
360     }
361 
362 
363     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
364         uint oldValue = allowed[msg.sender][_spender];
365         if (_subtractedValue > oldValue) {
366             allowed[msg.sender][_spender] = 0;
367         } else {
368             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
369         }
370         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
371         return true;
372     }
373     
374     function releaseToday() public onlyOwner returns (uint256 _actualRelease) {
375         return releaseSupply(now);
376     }
377     
378     function releaseSupply(uint256 timestamp) public onlyOwner returns (uint256 _actualRelease) {
379         require(timestamp >= createTime && timestamp <= now);
380         require(!judgeReleaseRecordExist(timestamp));
381 
382         updateAward(timestamp);
383 
384         balances[owner] = balances[owner].add(award);
385         totalSupply_ = totalSupply_.add(award);
386         releasedRecords[releasedRecordsCount] = ReleaseRecord(award, timestamp);
387         releasedRecordsCount++;
388         emit ReleaseSupply(owner, award, timestamp);
389         return award;
390     }
391 
392     function judgeReleaseRecordExist(uint256 timestamp) internal returns (bool _exist) {
393         bool exist = false;
394         if (releasedRecordsCount > 0) {
395             for (uint index = 0; index < releasedRecordsCount; index++) {
396                 if ((releasedRecords[index].releasedTime.parseTimestamp().year == timestamp.parseTimestamp().year)
397                 && (releasedRecords[index].releasedTime.parseTimestamp().month == timestamp.parseTimestamp().month)
398                     && (releasedRecords[index].releasedTime.parseTimestamp().day == timestamp.parseTimestamp().day)) {
399                     exist = true;
400                 }
401             }
402         }
403         return exist;
404     }
405 
406     function updateAward(uint256 timestamp) internal {
407         uint passMonth = now.sub(createTime) / 30 days + 1;
408         if (passMonth == lastMonth + 1) {
409             lastRelease = lastRelease - lastRelease.mul(10).div(100);
410             lastMonth = passMonth;
411         }
412         award = lastRelease.mul(10 ** uint256(decimals)).mul(allSupply).div(30).div(divBase);
413 
414     }
415 
416 }