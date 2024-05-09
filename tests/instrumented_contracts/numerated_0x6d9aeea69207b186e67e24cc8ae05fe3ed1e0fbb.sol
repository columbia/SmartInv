1 pragma solidity ^0.4.2;
2 contract DateTime {
3         /*
4          *  Date and Time utilities for ethereum contracts
5          *
6          */
7         struct DateTime {
8                 uint16 year;
9                 uint8 month;
10                 uint8 day;
11                 uint8 hour;
12                 uint8 minute;
13                 uint8 second;
14                 uint8 weekday;
15         }
16 
17         uint constant DAY_IN_SECONDS = 86400;
18         uint constant YEAR_IN_SECONDS = 31536000;
19         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
20 
21         uint constant HOUR_IN_SECONDS = 3600;
22         uint constant MINUTE_IN_SECONDS = 60;
23 
24         uint16 constant ORIGIN_YEAR = 1970;
25 
26         function isLeapYear(uint16 year) constant returns (bool) {
27                 if (year % 4 != 0) {
28                         return false;
29                 }
30                 if (year % 100 != 0) {
31                         return true;
32                 }
33                 if (year % 400 != 0) {
34                         return false;
35                 }
36                 return true;
37         }
38 
39         function leapYearsBefore(uint year) constant returns (uint) {
40                 year -= 1;
41                 return year / 4 - year / 100 + year / 400;
42         }
43 
44         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
45                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
46                         return 31;
47                 }
48                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
49                         return 30;
50                 }
51                 else if (isLeapYear(year)) {
52                         return 29;
53                 }
54                 else {
55                         return 28;
56                 }
57         }
58 
59         function parseTimestamp(uint timestamp) internal  returns (DateTime dt) {
60                 uint secondsAccountedFor = 0;
61                 uint buf;
62                 uint8 i;
63 
64                 // Year
65                 dt.year = getYear(timestamp);
66                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
67 
68                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
69                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
70 
71                 // Month
72                 uint secondsInMonth;
73                 for (i = 1; i <= 12; i++) {
74                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
75                         if (secondsInMonth + secondsAccountedFor > timestamp) {
76                                 dt.month = i;
77                                 break;
78                         }
79                         secondsAccountedFor += secondsInMonth;
80                 }
81 
82                 // Day
83                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
84                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
85                                 dt.day = i;
86                                 break;
87                         }
88                         secondsAccountedFor += DAY_IN_SECONDS;
89                 }
90 
91                 // Hour
92                 dt.hour = getHour(timestamp);
93 
94                 // Minute
95                 dt.minute = getMinute(timestamp);
96 
97                 // Second
98                 dt.second = getSecond(timestamp);
99 
100                 // Day of week.
101                 dt.weekday = getWeekday(timestamp);
102         }
103 
104         function getYear(uint timestamp) constant returns (uint16) {
105                 uint secondsAccountedFor = 0;
106                 uint16 year;
107                 uint numLeapYears;
108 
109                 // Year
110                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
111                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
112 
113                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
114                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
115 
116                 while (secondsAccountedFor > timestamp) {
117                         if (isLeapYear(uint16(year - 1))) {
118                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
119                         }
120                         else {
121                                 secondsAccountedFor -= YEAR_IN_SECONDS;
122                         }
123                         year -= 1;
124                 }
125                 return year;
126         }
127 
128         function getMonth(uint timestamp) constant returns (uint8) {
129                 return parseTimestamp(timestamp).month;
130         }
131 
132         function getDay(uint timestamp) constant returns (uint8) {
133                 return parseTimestamp(timestamp).day;
134         }
135 
136         function getHour(uint timestamp) constant returns (uint8) {
137                 return uint8((timestamp / 60 / 60) % 24);
138         }
139 
140         function getMinute(uint timestamp) constant returns (uint8) {
141                 return uint8((timestamp / 60) % 60);
142         }
143 
144         function getSecond(uint timestamp) constant returns (uint8) {
145                 return uint8(timestamp % 60);
146         }
147 
148         function getWeekday(uint timestamp) constant returns (uint8) {
149                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
150         }
151 
152         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
153                 return toTimestamp(year, month, day, 0, 0, 0);
154         }
155 
156         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp) {
157                 return toTimestamp(year, month, day, hour, 0, 0);
158         }
159 
160         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp) {
161                 return toTimestamp(year, month, day, hour, minute, 0);
162         }
163 
164         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
165             uint16 i;
166 
167             // Year
168             for (i = ORIGIN_YEAR; i < year; i++) {
169                     if (isLeapYear(i)) {
170                             timestamp += LEAP_YEAR_IN_SECONDS;
171                     }
172                     else {
173                             timestamp += YEAR_IN_SECONDS;
174                     }
175             }
176 
177             // Month
178             uint8[12] memory monthDayCounts;
179             monthDayCounts[0] = 31;
180             if (isLeapYear(year)) {
181                     monthDayCounts[1] = 29;
182             }
183             else {
184                     monthDayCounts[1] = 28;
185             }
186             monthDayCounts[2] = 31;
187             monthDayCounts[3] = 30;
188             monthDayCounts[4] = 31;
189             monthDayCounts[5] = 30;
190             monthDayCounts[6] = 31;
191             monthDayCounts[7] = 31;
192             monthDayCounts[8] = 30;
193             monthDayCounts[9] = 31;
194             monthDayCounts[10] = 30;
195             monthDayCounts[11] = 31;
196 
197             for (i = 1; i < month; i++) {
198                     timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
199             }
200 
201             // Day
202             timestamp += DAY_IN_SECONDS * (day - 1);
203 
204             // Hour
205             timestamp += HOUR_IN_SECONDS * (hour);
206 
207             // Minute
208             timestamp += MINUTE_IN_SECONDS * (minute);
209 
210             // Second
211             timestamp += second;
212 
213             return timestamp;
214     }
215 }
216 
217 // Copyrobo contract for notarization
218 contract ProofOfExistence {
219     
220     
221     function uintToBytes(uint v) constant returns (bytes32 ret) {
222         if (v == 0) {
223             ret = '0';
224         }
225         else {
226             while (v > 0) {
227                 ret = bytes32(uint(ret) / (2 ** 8));
228                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
229                 v /= 10;
230             }
231         }
232         return ret;
233     }
234     
235     function bytes32ToString(bytes32 x) constant returns (string) {
236         bytes memory bytesString = new bytes(32);
237         uint charCount = 0;
238         for (uint j = 0; j < 32; j++) {
239             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
240             if (char != 0) {
241                 bytesString[charCount] = char;
242                 charCount++;
243             }
244         }
245         bytes memory bytesStringTrimmed = new bytes(charCount);
246         for (j = 0; j < charCount; j++) {
247             bytesStringTrimmed[j] = bytesString[j];
248         }
249         return string(bytesStringTrimmed);
250     }
251     
252     function uintToString(uint16 x) constant returns (string) {
253         bytes32 a = uintToBytes(x);
254         return bytes32ToString(a);
255     }
256     
257 function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
258     bytes memory _ba = bytes(_a);
259     bytes memory _bb = bytes(_b);
260     bytes memory _bc = bytes(_c);
261     bytes memory _bd = bytes(_d);
262     bytes memory _be = bytes(_e);
263     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
264     bytes memory babcde = bytes(abcde);
265     uint k = 0;
266     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
267     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
268     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
269     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
270     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
271     return string(babcde);
272 }
273 
274 function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
275     return strConcat(_a, _b, _c, _d, "");
276 }
277 
278 function strConcat(string _a, string _b, string _c) internal returns (string) {
279     return strConcat(_a, _b, _c, "", "");
280 }
281 
282 function strConcat(string _a, string _b) internal returns (string) {
283     return strConcat(_a, _b, "", "", "");
284 }
285    
286   // string: sha256 of document
287   // unit : timestamp 
288   mapping (string => uint) private proofs;
289 
290   function notarize(string sha256) {
291     // validate it has 64 characters
292     
293     if ( bytes(sha256).length == 64 ){
294       // check if it is existing, don't save it
295       if ( proofs[sha256] == 0 ){
296         proofs[sha256] = block.timestamp;
297       }
298     }
299   }
300   
301   // Input sha256 hash string to check
302   function verify(string sha256) constant returns (uint16,uint16,uint16,uint16,uint16,uint16) {
303     var timestamp =  proofs[sha256];
304     if ( timestamp == 0 ){
305         return (0,0,0,0,0,0);
306     }else{
307         DateTime dt = DateTime(msg.sender);
308         
309         uint16 year = dt.getYear(timestamp);
310         uint16 month = dt.getMonth(timestamp);
311         uint16 day = dt.getDay(timestamp);
312         uint16 hour = dt.getHour(timestamp);
313         uint16 minute = dt.getMinute(timestamp);
314         uint16 second = dt.getSecond(timestamp);
315         return  (year, month,day,hour,minute,second);
316         
317         // string  memory result = strConcat(bytes32ToString(year) , "-" , bytes32ToString(month),"-",bytes32ToString(day));
318         // result = strConcat(result," ");
319         // result = strConcat( bytes32ToString(hour) , ":" , bytes32ToString(minute),":",bytes32ToString(second));
320         // result = strConcat(result," UTC") ;
321         
322         
323         
324         
325 
326 
327         // //UTC Format: 2013-10-26 14:37:48 UTC
328 
329         // return result;
330     }
331   }
332   
333 }