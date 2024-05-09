1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 interface IERC20{
35     function totalSupply() constant returns (uint256 totalSupply);
36     function balanceOf(address _owner) constant returns (uint256 balance);
37     function transfer(address _to, uint256 _value) returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
39     function approve(address _spender, uint256 _value) returns (bool success);
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 contract DateTime {
47         /*
48          *  Date and Time utilities for ethereum contracts
49          *
50          */
51         struct _DateTime {
52                 uint16 year;
53                 uint8 month;
54                 uint8 day;
55                 uint8 hour;
56                 uint8 minute;
57                 uint8 second;
58                 uint8 weekday;
59         }
60 
61         uint constant DAY_IN_SECONDS = 86400;
62         uint constant YEAR_IN_SECONDS = 31536000;
63         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
64 
65         uint constant HOUR_IN_SECONDS = 3600;
66         uint constant MINUTE_IN_SECONDS = 60;
67 
68         uint16 constant ORIGIN_YEAR = 1970;
69 
70         function isLeapYear(uint16 year) public pure returns (bool) {
71                 if (year % 4 != 0) {
72                         return false;
73                 }
74                 if (year % 100 != 0) {
75                         return true;
76                 }
77                 if (year % 400 != 0) {
78                         return false;
79                 }
80                 return true;
81         }
82 
83         function leapYearsBefore(uint year) public pure returns (uint) {
84                 year -= 1;
85                 return year / 4 - year / 100 + year / 400;
86         }
87 
88         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
89                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
90                         return 31;
91                 }
92                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
93                         return 30;
94                 }
95                 else if (isLeapYear(year)) {
96                         return 29;
97                 }
98                 else {
99                         return 28;
100                 }
101         }
102 
103         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
104                 uint secondsAccountedFor = 0;
105                 uint buf;
106                 uint8 i;
107 
108                 // Year
109                 dt.year = getYear(timestamp);
110                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
111 
112                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
113                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
114 
115                 // Month
116                 uint secondsInMonth;
117                 for (i = 1; i <= 12; i++) {
118                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
119                         if (secondsInMonth + secondsAccountedFor > timestamp) {
120                                 dt.month = i;
121                                 break;
122                         }
123                         secondsAccountedFor += secondsInMonth;
124                 }
125 
126                 // Day
127                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
128                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
129                                 dt.day = i;
130                                 break;
131                         }
132                         secondsAccountedFor += DAY_IN_SECONDS;
133                 }
134 
135                 // Hour
136                 dt.hour = getHour(timestamp);
137 
138                 // Minute
139                 dt.minute = getMinute(timestamp);
140 
141                 // Second
142                 dt.second = getSecond(timestamp);
143 
144                 // Day of week.
145                 dt.weekday = getWeekday(timestamp);
146         }
147 
148         function getYear(uint timestamp) public pure returns (uint16) {
149                 uint secondsAccountedFor = 0;
150                 uint16 year;
151                 uint numLeapYears;
152 
153                 // Year
154                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
155                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
156 
157                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
158                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
159 
160                 while (secondsAccountedFor > timestamp) {
161                         if (isLeapYear(uint16(year - 1))) {
162                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
163                         }
164                         else {
165                                 secondsAccountedFor -= YEAR_IN_SECONDS;
166                         }
167                         year -= 1;
168                 }
169                 return year;
170         }
171 
172         function getMonth(uint timestamp) public pure returns (uint8) {
173                 return parseTimestamp(timestamp).month;
174         }
175 
176         function getDay(uint timestamp) public pure returns (uint8) {
177                 return parseTimestamp(timestamp).day;
178         }
179 
180         function getHour(uint timestamp) public pure returns (uint8) {
181                 return uint8((timestamp / 60 / 60) % 24);
182         }
183 
184         function getMinute(uint timestamp) public pure returns (uint8) {
185                 return uint8((timestamp / 60) % 60);
186         }
187 
188         function getSecond(uint timestamp) public pure returns (uint8) {
189                 return uint8(timestamp % 60);
190         }
191 
192         function getWeekday(uint timestamp) public pure returns (uint8) {
193                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
194         }
195 
196         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
197                 return toTimestamp(year, month, day, 0, 0, 0);
198         }
199 
200         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
201                 return toTimestamp(year, month, day, hour, 0, 0);
202         }
203 
204         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
205                 return toTimestamp(year, month, day, hour, minute, 0);
206         }
207 
208         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
209                 uint16 i;
210 
211                 // Year
212                 for (i = ORIGIN_YEAR; i < year; i++) {
213                         if (isLeapYear(i)) {
214                                 timestamp += LEAP_YEAR_IN_SECONDS;
215                         }
216                         else {
217                                 timestamp += YEAR_IN_SECONDS;
218                         }
219                 }
220 
221                 // Month
222                 uint8[12] memory monthDayCounts;
223                 monthDayCounts[0] = 31;
224                 if (isLeapYear(year)) {
225                         monthDayCounts[1] = 29;
226                 }
227                 else {
228                         monthDayCounts[1] = 28;
229                 }
230                 monthDayCounts[2] = 31;
231                 monthDayCounts[3] = 30;
232                 monthDayCounts[4] = 31;
233                 monthDayCounts[5] = 30;
234                 monthDayCounts[6] = 31;
235                 monthDayCounts[7] = 31;
236                 monthDayCounts[8] = 30;
237                 monthDayCounts[9] = 31;
238                 monthDayCounts[10] = 30;
239                 monthDayCounts[11] = 31;
240 
241                 for (i = 1; i < month; i++) {
242                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
243                 }
244 
245                 // Day
246                 timestamp += DAY_IN_SECONDS * (day - 1);
247 
248                 // Hour
249                 timestamp += HOUR_IN_SECONDS * (hour);
250 
251                 // Minute
252                 timestamp += MINUTE_IN_SECONDS * (minute);
253 
254                 // Second
255                 timestamp += second;
256 
257                 return timestamp;
258         }
259 }
260 
261 contract ySignToken is IERC20{
262     
263     using SafeMath for uint256;
264     uint constant MINUTE_IN_SECONDS = 60;
265     uint constant HOUR_IN_SECONDS = 3600;
266     uint constant DAY_IN_SECONDS = 86400;
267     
268     uint public  _totalSupply = 18400000000000000000000000;
269     uint public constant Max = 80000000000000000000000000;
270     
271     uint256 public startTime ;
272     
273     string public constant symbol = "YSN";
274     string public constant name = "ySignToken";
275     uint8 public constant decimals = 18; 
276    
277     uint256 public  RATE;
278     uint256 public  Check = 0;
279     
280     address public owner;
281     
282     mapping(address => uint256) balances;
283     mapping(address => mapping(address => uint256)) allowed;
284     
285     function() payable{
286         createToken();
287     }
288     
289     
290     function ySignToken(){
291        balances[msg.sender] = _totalSupply;
292        owner = msg.sender;
293        startTime = now;
294     }
295     
296     function createToken() payable{
297        uint256 tokenss = msg.value;
298          if(now < startTime + (7 * DAY_IN_SECONDS + 6 * HOUR_IN_SECONDS)){
299            RATE = 5556;
300            if(_totalSupply <= 28400000000000000000000000){
301                Check = 1;
302            }
303        }
304 	   else  if(now < startTime + (14 * DAY_IN_SECONDS)){
305            RATE = 2778;
306            if(_totalSupply <= 38400000000000000000000000){
307                Check = 1;
308            }
309        }
310 	   else  if(now < startTime + (21 * DAY_IN_SECONDS)){
311            RATE = 1852;
312            if(_totalSupply <= 48400000000000000000000000){
313                Check = 1;
314            }
315        }
316 	   else  if(now < startTime + (28 * DAY_IN_SECONDS)){
317            RATE = 1389;
318             if(_totalSupply <= 58400000000000000000000000){
319                Check = 1;
320            }
321        }
322        else RATE = 1191; 
323         require(
324         msg.value > 0    
325         && _totalSupply.add(msg.value.mul(RATE)) <= Max
326         && Check > 0
327         );
328         
329         uint256 tokens = msg.value.mul(RATE);
330         balances[msg.sender] = balances[msg.sender].add(tokens);
331         _totalSupply = _totalSupply.add(tokens);
332         owner.transfer(msg.value);
333         Check = 0;
334     }
335     
336      function totalSupply() constant returns (uint256 totalSupply){
337         return _totalSupply;
338      }
339      
340     function balanceOf(address _owner) constant returns (uint256 balance){
341         return balances[_owner];
342     }
343     
344     function transfer(address _to, uint256 _value) returns (bool success){
345         require(
346           balances[msg.sender] >= _value
347           && _value > 0
348         );
349         balances[msg.sender] = balances[msg.sender].sub(_value);
350         balances[_to] = balances[_to].add(_value);
351         Transfer(msg.sender, _to,_value);
352         return true;
353     }
354     
355     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
356         require(
357             allowed[_from][msg.sender]  >= _value
358             && balances[_from] >= _value
359             && _value > 0
360         );
361         balances[_from] = balances[_from].sub(_value);
362         balances[_to] = balances[_to].add(_value);
363         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
364         Transfer(_from, _to, _value);
365         return true;
366     }
367     
368     function approve(address _spender, uint256 _value) returns (bool success){
369         allowed[msg.sender][_spender] = _value;   
370         Approval(msg.sender,_spender,_value);
371         return true;
372     }
373     
374     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
375         return allowed[_owner][_spender];
376     }
377     
378     event Transfer(address indexed _from, address indexed _to, uint256 _value);
379     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
380     
381        
382 }