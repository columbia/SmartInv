1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // ----------------------------------------------------------------------------
5 // BokkyPooBah's DateTime Library v1.01
6 //
7 // A gas-efficient Solidity date and time library
8 //
9 // https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
10 //
11 // Tested date range 1970/01/01 to 2345/12/31
12 //
13 // Conventions:
14 // Unit      | Range         | Notes
15 // :-------- |:-------------:|:-----
16 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
17 // year      | 1970 ... 2345 |
18 // month     | 1 ... 12      |
19 // day       | 1 ... 31      |
20 // hour      | 0 ... 23      |
21 // minute    | 0 ... 59      |
22 // second    | 0 ... 59      |
23 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
24 //
25 //
26 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
27 // ----------------------------------------------------------------------------
28 
29 library DateTime {
30     uint256 constant SECONDS_PER_DAY = 86400;
31     uint256 constant SECONDS_PER_HOUR = 3600;
32     uint256 constant SECONDS_PER_MINUTE = 60;
33     int256 constant OFFSET19700101 = 2440588;
34 
35     uint256 constant DOW_MON = 1;
36     uint256 constant DOW_TUE = 2;
37     uint256 constant DOW_WED = 3;
38     uint256 constant DOW_THU = 4;
39     uint256 constant DOW_FRI = 5;
40     uint256 constant DOW_SAT = 6;
41     uint256 constant DOW_SUN = 7;
42 
43     // ------------------------------------------------------------------------
44     // Calculate the number of days from 1970/01/01 to year/month/day using
45     // the date conversion algorithm from
46     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
47     // and subtracting the offset 2440588 so that 1970/01/01 is day 0
48     //
49     // days = day
50     //      - 32075
51     //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
52     //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
53     //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
54     //      - offset
55     // ------------------------------------------------------------------------
56     function _daysFromDate(
57         uint256 year,
58         uint256 month,
59         uint256 day
60     ) internal pure returns (uint256 _days) {
61         require(year >= 1970);
62         int256 _year = int256(year);
63         int256 _month = int256(month);
64         int256 _day = int256(day);
65 
66         int256 __days = _day -
67             32075 +
68             (1461 * (_year + 4800 + (_month - 14) / 12)) /
69             4 +
70             (367 * (_month - 2 - ((_month - 14) / 12) * 12)) /
71             12 -
72             (3 * ((_year + 4900 + (_month - 14) / 12) / 100)) /
73             4 -
74             OFFSET19700101;
75 
76         _days = uint256(__days);
77     }
78 
79     // ------------------------------------------------------------------------
80     // Calculate year/month/day from the number of days since 1970/01/01 using
81     // the date conversion algorithm from
82     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
83     // and adding the offset 2440588 so that 1970/01/01 is day 0
84     //
85     // int L = days + 68569 + offset
86     // int N = 4 * L / 146097
87     // L = L - (146097 * N + 3) / 4
88     // year = 4000 * (L + 1) / 1461001
89     // L = L - 1461 * year / 4 + 31
90     // month = 80 * L / 2447
91     // dd = L - 2447 * month / 80
92     // L = month / 11
93     // month = month + 2 - 12 * L
94     // year = 100 * (N - 49) + year + L
95     // ------------------------------------------------------------------------
96     function _daysToDate(uint256 _days)
97         internal
98         pure
99         returns (
100             uint256 year,
101             uint256 month,
102             uint256 day
103         )
104     {
105         int256 __days = int256(_days);
106 
107         int256 L = __days + 68569 + OFFSET19700101;
108         int256 N = (4 * L) / 146097;
109         L = L - (146097 * N + 3) / 4;
110         int256 _year = (4000 * (L + 1)) / 1461001;
111         L = L - (1461 * _year) / 4 + 31;
112         int256 _month = (80 * L) / 2447;
113         int256 _day = L - (2447 * _month) / 80;
114         L = _month / 11;
115         _month = _month + 2 - 12 * L;
116         _year = 100 * (N - 49) + _year + L;
117 
118         year = uint256(_year);
119         month = uint256(_month);
120         day = uint256(_day);
121     }
122 
123     function timestampFromDate(
124         uint256 year,
125         uint256 month,
126         uint256 day
127     ) internal pure returns (uint256 timestamp) {
128         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
129     }
130 
131     function timestampFromDateTime(
132         uint256 year,
133         uint256 month,
134         uint256 day,
135         uint256 hour,
136         uint256 minute,
137         uint256 second
138     ) internal pure returns (uint256 timestamp) {
139         timestamp =
140             _daysFromDate(year, month, day) *
141             SECONDS_PER_DAY +
142             hour *
143             SECONDS_PER_HOUR +
144             minute *
145             SECONDS_PER_MINUTE +
146             second;
147     }
148 
149     function timestampToDate(uint256 timestamp)
150         internal
151         pure
152         returns (
153             uint256 year,
154             uint256 month,
155             uint256 day
156         )
157     {
158         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
159     }
160 
161     function timestampToDateTime(uint256 timestamp)
162         internal
163         pure
164         returns (
165             uint256 year,
166             uint256 month,
167             uint256 day,
168             uint256 hour,
169             uint256 minute,
170             uint256 second
171         )
172     {
173         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
174         uint256 secs = timestamp % SECONDS_PER_DAY;
175         hour = secs / SECONDS_PER_HOUR;
176         secs = secs % SECONDS_PER_HOUR;
177         minute = secs / SECONDS_PER_MINUTE;
178         second = secs % SECONDS_PER_MINUTE;
179     }
180 
181     function isValidDate(
182         uint256 year,
183         uint256 month,
184         uint256 day
185     ) internal pure returns (bool valid) {
186         if (year >= 1970 && month != 0 && month <= 12) {
187             if (day != 0 && day <= _getDaysInMonth(year, month)) {
188                 valid = true;
189             }
190         }
191     }
192 
193     function isValidDateTime(
194         uint256 year,
195         uint256 month,
196         uint256 day,
197         uint256 hour,
198         uint256 minute,
199         uint256 second
200     ) internal pure returns (bool valid) {
201         if (isValidDate(year, month, day)) {
202             if (hour < 24 && minute < 60 && second < 60) {
203                 valid = true;
204             }
205         }
206     }
207 
208     function isLeapYear(uint256 timestamp) internal pure returns (bool leapYear) {
209         (uint256 year, , ) = _daysToDate(timestamp / SECONDS_PER_DAY);
210         leapYear = _isLeapYear(year);
211     }
212 
213     function _isLeapYear(uint256 year) internal pure returns (bool leapYear) {
214         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
215     }
216 
217     function isWeekDay(uint256 timestamp) internal pure returns (bool weekDay) {
218         weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
219     }
220 
221     function isWeekEnd(uint256 timestamp) internal pure returns (bool weekEnd) {
222         weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
223     }
224 
225     function getDaysInMonth(uint256 timestamp) internal pure returns (uint256 daysInMonth) {
226         (uint256 year, uint256 month, ) = _daysToDate(timestamp / SECONDS_PER_DAY);
227         daysInMonth = _getDaysInMonth(year, month);
228     }
229 
230     function _getDaysInMonth(uint256 year, uint256 month) internal pure returns (uint256 daysInMonth) {
231         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
232             daysInMonth = 31;
233         } else if (month != 2) {
234             daysInMonth = 30;
235         } else {
236             daysInMonth = _isLeapYear(year) ? 29 : 28;
237         }
238     }
239 
240     // 1 = Monday, 7 = Sunday
241     function getDayOfWeek(uint256 timestamp) internal pure returns (uint256 dayOfWeek) {
242         uint256 _days = timestamp / SECONDS_PER_DAY;
243         dayOfWeek = ((_days + 3) % 7) + 1;
244     }
245 
246     function getYear(uint256 timestamp) internal pure returns (uint256 year) {
247         (year, , ) = _daysToDate(timestamp / SECONDS_PER_DAY);
248     }
249 
250     function getMonth(uint256 timestamp) internal pure returns (uint256 month) {
251         (, month, ) = _daysToDate(timestamp / SECONDS_PER_DAY);
252     }
253 
254     function getDay(uint256 timestamp) internal pure returns (uint256 day) {
255         (, , day) = _daysToDate(timestamp / SECONDS_PER_DAY);
256     }
257 
258     function getHour(uint256 timestamp) internal pure returns (uint256 hour) {
259         uint256 secs = timestamp % SECONDS_PER_DAY;
260         hour = secs / SECONDS_PER_HOUR;
261     }
262 
263     function getMinute(uint256 timestamp) internal pure returns (uint256 minute) {
264         uint256 secs = timestamp % SECONDS_PER_HOUR;
265         minute = secs / SECONDS_PER_MINUTE;
266     }
267 
268     function getSecond(uint256 timestamp) internal pure returns (uint256 second) {
269         second = timestamp % SECONDS_PER_MINUTE;
270     }
271 
272     function addYears(uint256 timestamp, uint256 _years) internal pure returns (uint256 newTimestamp) {
273         (uint256 year, uint256 month, uint256 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
274         year += _years;
275         uint256 daysInMonth = _getDaysInMonth(year, month);
276         if (day > daysInMonth) {
277             day = daysInMonth;
278         }
279         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + (timestamp % SECONDS_PER_DAY);
280         require(newTimestamp >= timestamp);
281     }
282 
283     function addMonths(uint256 timestamp, uint256 _months) internal pure returns (uint256 newTimestamp) {
284         (uint256 year, uint256 month, uint256 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
285         month += _months;
286         year += (month - 1) / 12;
287         month = ((month - 1) % 12) + 1;
288         uint256 daysInMonth = _getDaysInMonth(year, month);
289         if (day > daysInMonth) {
290             day = daysInMonth;
291         }
292         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + (timestamp % SECONDS_PER_DAY);
293         require(newTimestamp >= timestamp);
294     }
295 
296     function addDays(uint256 timestamp, uint256 _days) internal pure returns (uint256 newTimestamp) {
297         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
298         require(newTimestamp >= timestamp);
299     }
300 
301     function addHours(uint256 timestamp, uint256 _hours) internal pure returns (uint256 newTimestamp) {
302         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
303         require(newTimestamp >= timestamp);
304     }
305 
306     function addMinutes(uint256 timestamp, uint256 _minutes) internal pure returns (uint256 newTimestamp) {
307         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
308         require(newTimestamp >= timestamp);
309     }
310 
311     function addSeconds(uint256 timestamp, uint256 _seconds) internal pure returns (uint256 newTimestamp) {
312         newTimestamp = timestamp + _seconds;
313         require(newTimestamp >= timestamp);
314     }
315 
316     function subYears(uint256 timestamp, uint256 _years) internal pure returns (uint256 newTimestamp) {
317         (uint256 year, uint256 month, uint256 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
318         year -= _years;
319         uint256 daysInMonth = _getDaysInMonth(year, month);
320         if (day > daysInMonth) {
321             day = daysInMonth;
322         }
323         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + (timestamp % SECONDS_PER_DAY);
324         require(newTimestamp <= timestamp);
325     }
326 
327     function subMonths(uint256 timestamp, uint256 _months) internal pure returns (uint256 newTimestamp) {
328         (uint256 year, uint256 month, uint256 day) = _daysToDate(timestamp / SECONDS_PER_DAY);
329         uint256 yearMonth = year * 12 + (month - 1) - _months;
330         year = yearMonth / 12;
331         month = (yearMonth % 12) + 1;
332         uint256 daysInMonth = _getDaysInMonth(year, month);
333         if (day > daysInMonth) {
334             day = daysInMonth;
335         }
336         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + (timestamp % SECONDS_PER_DAY);
337         require(newTimestamp <= timestamp);
338     }
339 
340     function subDays(uint256 timestamp, uint256 _days) internal pure returns (uint256 newTimestamp) {
341         newTimestamp = timestamp - _days * SECONDS_PER_DAY;
342         require(newTimestamp <= timestamp);
343     }
344 
345     function subHours(uint256 timestamp, uint256 _hours) internal pure returns (uint256 newTimestamp) {
346         newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
347         require(newTimestamp <= timestamp);
348     }
349 
350     function subMinutes(uint256 timestamp, uint256 _minutes) internal pure returns (uint256 newTimestamp) {
351         newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
352         require(newTimestamp <= timestamp);
353     }
354 
355     function subSeconds(uint256 timestamp, uint256 _seconds) internal pure returns (uint256 newTimestamp) {
356         newTimestamp = timestamp - _seconds;
357         require(newTimestamp <= timestamp);
358     }
359 
360     function diffYears(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 _years) {
361         require(fromTimestamp <= toTimestamp);
362         (uint256 fromYear, , ) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
363         (uint256 toYear, , ) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
364         _years = toYear - fromYear;
365     }
366 
367     function diffMonths(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 _months) {
368         require(fromTimestamp <= toTimestamp);
369         (uint256 fromYear, uint256 fromMonth, ) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
370         (uint256 toYear, uint256 toMonth, ) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
371         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
372     }
373 
374     function diffDays(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 _days) {
375         require(fromTimestamp <= toTimestamp);
376         _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
377     }
378 
379     function diffHours(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 _hours) {
380         require(fromTimestamp <= toTimestamp);
381         _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
382     }
383 
384     function diffMinutes(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 _minutes) {
385         require(fromTimestamp <= toTimestamp);
386         _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
387     }
388 
389     function diffSeconds(uint256 fromTimestamp, uint256 toTimestamp) internal pure returns (uint256 _seconds) {
390         require(fromTimestamp <= toTimestamp);
391         _seconds = toTimestamp - fromTimestamp;
392     }
393 }
