1 pragma solidity ^0.4.2;
2 
3 contract DateTime {
4         /*
5          *  Date and Time utilities for ethereum contracts
6          *
7          */
8         struct DateTime {
9                 uint16 year;
10                 uint8 month;
11                 uint8 day;
12                 uint8 hour;
13                 uint8 minute;
14                 uint8 second;
15                 uint8 weekday;
16         }
17 
18         uint constant DAY_IN_SECONDS = 86400;
19         uint constant YEAR_IN_SECONDS = 31536000;
20         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
21 
22         uint constant HOUR_IN_SECONDS = 3600;
23         uint constant MINUTE_IN_SECONDS = 60;
24 
25         uint16 constant ORIGIN_YEAR = 1970;
26 
27         function isLeapYear(uint16 year) constant returns (bool) {
28                 if (year % 4 != 0) {
29                         return false;
30                 }
31                 if (year % 100 != 0) {
32                         return true;
33                 }
34                 if (year % 400 != 0) {
35                         return false;
36                 }
37                 return true;
38         }
39 
40         function leapYearsBefore(uint year) constant returns (uint) {
41                 year -= 1;
42                 return year / 4 - year / 100 + year / 400;
43         }
44 
45         function getDaysInMonth(uint8 month, uint16 year) constant returns (uint8) {
46                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
47                         return 31;
48                 }
49                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
50                         return 30;
51                 }
52                 else if (isLeapYear(year)) {
53                         return 29;
54                 }
55                 else {
56                         return 28;
57                 }
58         }
59 
60         function parseTimestamp(uint timestamp) internal  returns (DateTime dt) {
61                 uint secondsAccountedFor = 0;
62                 uint buf;
63                 uint8 i;
64 
65                 // Year
66                 dt.year = getYear(timestamp);
67                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
68 
69                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
70                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
71 
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
82 
83                 // Day
84                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
85                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
86                                 dt.day = i;
87                                 break;
88                         }
89                         secondsAccountedFor += DAY_IN_SECONDS;
90                 }
91 
92                 // Hour
93                 dt.hour = getHour(timestamp);
94 
95                 // Minute
96                 dt.minute = getMinute(timestamp);
97 
98                 // Second
99                 dt.second = getSecond(timestamp);
100 
101                 // Day of week.
102                 dt.weekday = getWeekday(timestamp);
103         }
104 
105         function getYear(uint timestamp) constant returns (uint16) {
106                 uint secondsAccountedFor = 0;
107                 uint16 year;
108                 uint numLeapYears;
109 
110                 // Year
111                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
112                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
113 
114                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
115                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
116 
117                 while (secondsAccountedFor > timestamp) {
118                         if (isLeapYear(uint16(year - 1))) {
119                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
120                         }
121                         else {
122                                 secondsAccountedFor -= YEAR_IN_SECONDS;
123                         }
124                         year -= 1;
125                 }
126                 return year;
127         }
128 
129         function getMonth(uint timestamp) constant returns (uint8) {
130                 return parseTimestamp(timestamp).month;
131         }
132 
133         function getDay(uint timestamp) constant returns (uint8) {
134                 return parseTimestamp(timestamp).day;
135         }
136 
137         function getHour(uint timestamp) constant returns (uint8) {
138                 return uint8((timestamp / 60 / 60) % 24);
139         }
140 
141         function getMinute(uint timestamp) constant returns (uint8) {
142                 return uint8((timestamp / 60) % 60);
143         }
144 
145         function getSecond(uint timestamp) constant returns (uint8) {
146                 return uint8(timestamp % 60);
147         }
148 
149         function getWeekday(uint timestamp) constant returns (uint8) {
150                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
151         }
152 
153         function toTimestamp(uint16 year, uint8 month, uint8 day) constant returns (uint timestamp) {
154                 return toTimestamp(year, month, day, 0, 0, 0);
155         }
156 
157         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) constant returns (uint timestamp) {
158                 return toTimestamp(year, month, day, hour, 0, 0);
159         }
160 
161         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp) {
162                 return toTimestamp(year, month, day, hour, minute, 0);
163         }
164 
165         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) constant returns (uint timestamp) {
166             uint16 i;
167 
168             // Year
169             for (i = ORIGIN_YEAR; i < year; i++) {
170                     if (isLeapYear(i)) {
171                             timestamp += LEAP_YEAR_IN_SECONDS;
172                     }
173                     else {
174                             timestamp += YEAR_IN_SECONDS;
175                     }
176             }
177 
178             // Month
179             uint8[12] memory monthDayCounts;
180             monthDayCounts[0] = 31;
181             if (isLeapYear(year)) {
182                     monthDayCounts[1] = 29;
183             }
184             else {
185                     monthDayCounts[1] = 28;
186             }
187             monthDayCounts[2] = 31;
188             monthDayCounts[3] = 30;
189             monthDayCounts[4] = 31;
190             monthDayCounts[5] = 30;
191             monthDayCounts[6] = 31;
192             monthDayCounts[7] = 31;
193             monthDayCounts[8] = 30;
194             monthDayCounts[9] = 31;
195             monthDayCounts[10] = 30;
196             monthDayCounts[11] = 31;
197 
198             for (i = 1; i < month; i++) {
199                     timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
200             }
201 
202             // Day
203             timestamp += DAY_IN_SECONDS * (day - 1);
204 
205             // Hour
206             timestamp += HOUR_IN_SECONDS * (hour);
207 
208             // Minute
209             timestamp += MINUTE_IN_SECONDS * (minute);
210 
211             // Second
212             timestamp += second;
213 
214             return timestamp;
215     }
216 }
217 
218 // Copyrobo contract for notarization
219 contract ProofOfExistence {
220     
221     string public result;
222 
223     function uintToString(uint v) constant returns (string str) {
224         uint maxlength = 100;
225         bytes memory reversed = new bytes(maxlength);
226         uint i = 0;
227         while (v != 0) {
228             uint remainder = v % 10;
229             v = v / 10;
230             reversed[i++] = byte(48 + remainder);
231         }
232         bytes memory s = new bytes(i + 1);
233         for (uint j = 0; j <= i; j++) {
234             s[j] = reversed[i - j];
235         }
236         str = string(s);
237         
238     }
239     
240 function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
241     bytes memory _ba = bytes(_a);
242     bytes memory _bb = bytes(_b);
243     bytes memory _bc = bytes(_c);
244     bytes memory _bd = bytes(_d);
245     bytes memory _be = bytes(_e);
246     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
247     bytes memory babcde = bytes(abcde);
248     uint k = 0;
249     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
250     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
251     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
252     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
253     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
254     return string(babcde);
255 }
256 
257 function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
258     return strConcat(_a, _b, _c, _d, "");
259 }
260 
261 function strConcat(string _a, string _b, string _c) internal returns (string) {
262     return strConcat(_a, _b, _c, "", "");
263 }
264 
265 function strConcat(string _a, string _b) internal returns (string) {
266     return strConcat(_a, _b, "", "", "");
267 }
268    
269   // string: sha256 of document
270   // unit : timestamp 
271   mapping (string => uint) private proofs;
272 
273   function notarize(string sha256) {
274     // validate it has 64 characters
275     
276     if ( bytes(sha256).length == 64 ){
277       // check if it is existing, don't save it
278       if ( proofs[sha256] == 0 ){
279         proofs[sha256] = block.timestamp;
280       }
281     }
282   }
283   
284   // Input sha256 hash string to check
285   function verify(string sha256) constant returns (string) {
286     var timestamp =  proofs[sha256];
287     if ( timestamp == 0 ){
288         return "No data found";
289     }else{
290         DateTime dt = DateTime(msg.sender);
291         
292         uint year = dt.getYear(timestamp);
293         uint month = dt.getMonth(timestamp);
294         uint day = dt.getDay(timestamp);
295         uint hour = dt.getHour(timestamp);
296         uint minute = dt.getMinute(timestamp);
297         uint second = dt.getSecond(timestamp);
298         
299         result = strConcat(uintToString(year) , "-" , uintToString(month),"-",uintToString(day));
300         result = strConcat(result," ");
301         result = strConcat( uintToString(hour) , ":" , uintToString(minute),":",uintToString(second));
302         result = strConcat(result," UTC");
303         
304 
305 
306         //UTC Format: 2013-10-26 14:37:48 UTC
307 
308         return result;
309     }
310   }
311   
312 }