1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
5  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
6  */
7 pragma solidity ^0.8.0;
8 
9 /**
10  * Smart contract library of mathematical functions operating with signed
11  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
12  * basically a simple fraction whose numerator is signed 128-bit integer and
13  * denominator is 2^64.  As long as denominator is always the same, there is no
14  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
15  * represented by int128 type holding only the numerator.
16  */
17 library ABDKMath64x64 {
18     /*
19      * Minimum value signed 64.64-bit fixed point number may have.
20      */
21     int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
22 
23     /*
24      * Maximum value signed 64.64-bit fixed point number may have.
25      */
26     int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
27 
28     /**
29      * Convert signed 256-bit integer number into signed 64.64-bit fixed point
30      * number.  Revert on overflow.
31      *
32      * @param x signed 256-bit integer number
33      * @return signed 64.64-bit fixed point number
34      */
35     function fromInt(int256 x) internal pure returns (int128) {
36         unchecked {
37             require(x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
38             return int128(x << 64);
39         }
40     }
41 
42     /**
43      * Convert signed 64.64 fixed point number into signed 64-bit integer number
44      * rounding down.
45      *
46      * @param x signed 64.64-bit fixed point number
47      * @return signed 64-bit integer number
48      */
49     function toInt(int128 x) internal pure returns (int64) {
50         unchecked {
51             return int64(x >> 64);
52         }
53     }
54 
55     /**
56      * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
57      * number.  Revert on overflow.
58      *
59      * @param x unsigned 256-bit integer number
60      * @return signed 64.64-bit fixed point number
61      */
62     function fromUInt(uint256 x) internal pure returns (int128) {
63         unchecked {
64             require(x <= 0x7FFFFFFFFFFFFFFF);
65             return int128(int256(x << 64));
66         }
67     }
68 
69     /**
70      * Convert signed 64.64 fixed point number into unsigned 64-bit integer
71      * number rounding down.  Revert on underflow.
72      *
73      * @param x signed 64.64-bit fixed point number
74      * @return unsigned 64-bit integer number
75      */
76     function toUInt(int128 x) internal pure returns (uint64) {
77         unchecked {
78             require(x >= 0);
79             return uint64(uint128(x >> 64));
80         }
81     }
82 
83     /**
84      * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
85      * number rounding down.  Revert on overflow.
86      *
87      * @param x signed 128.128-bin fixed point number
88      * @return signed 64.64-bit fixed point number
89      */
90     function from128x128(int256 x) internal pure returns (int128) {
91         unchecked {
92             int256 result = x >> 64;
93             require(result >= MIN_64x64 && result <= MAX_64x64);
94             return int128(result);
95         }
96     }
97 
98     /**
99      * Convert signed 64.64 fixed point number into signed 128.128 fixed point
100      * number.
101      *
102      * @param x signed 64.64-bit fixed point number
103      * @return signed 128.128 fixed point number
104      */
105     function to128x128(int128 x) internal pure returns (int256) {
106         unchecked {
107             return int256(x) << 64;
108         }
109     }
110 
111     /**
112      * Calculate x + y.  Revert on overflow.
113      *
114      * @param x signed 64.64-bit fixed point number
115      * @param y signed 64.64-bit fixed point number
116      * @return signed 64.64-bit fixed point number
117      */
118     function add(int128 x, int128 y) internal pure returns (int128) {
119         unchecked {
120             int256 result = int256(x) + y;
121             require(result >= MIN_64x64 && result <= MAX_64x64);
122             return int128(result);
123         }
124     }
125 
126     /**
127      * Calculate x - y.  Revert on overflow.
128      *
129      * @param x signed 64.64-bit fixed point number
130      * @param y signed 64.64-bit fixed point number
131      * @return signed 64.64-bit fixed point number
132      */
133     function sub(int128 x, int128 y) internal pure returns (int128) {
134         unchecked {
135             int256 result = int256(x) - y;
136             require(result >= MIN_64x64 && result <= MAX_64x64);
137             return int128(result);
138         }
139     }
140 
141     /**
142      * Calculate x * y rounding down.  Revert on overflow.
143      *
144      * @param x signed 64.64-bit fixed point number
145      * @param y signed 64.64-bit fixed point number
146      * @return signed 64.64-bit fixed point number
147      */
148     function mul(int128 x, int128 y) internal pure returns (int128) {
149         unchecked {
150             int256 result = (int256(x) * y) >> 64;
151             require(result >= MIN_64x64 && result <= MAX_64x64);
152             return int128(result);
153         }
154     }
155 
156     /**
157      * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
158      * number and y is signed 256-bit integer number.  Revert on overflow.
159      *
160      * @param x signed 64.64 fixed point number
161      * @param y signed 256-bit integer number
162      * @return signed 256-bit integer number
163      */
164     function muli(int128 x, int256 y) internal pure returns (int256) {
165         unchecked {
166             if (x == MIN_64x64) {
167                 require(
168                     y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
169                         y <= 0x1000000000000000000000000000000000000000000000000
170                 );
171                 return -y << 63;
172             } else {
173                 bool negativeResult = false;
174                 if (x < 0) {
175                     x = -x;
176                     negativeResult = true;
177                 }
178                 if (y < 0) {
179                     y = -y; // We rely on overflow behavior here
180                     negativeResult = !negativeResult;
181                 }
182                 uint256 absoluteResult = mulu(x, uint256(y));
183                 if (negativeResult) {
184                     require(
185                         absoluteResult <=
186                             0x8000000000000000000000000000000000000000000000000000000000000000
187                     );
188                     return -int256(absoluteResult); // We rely on overflow behavior here
189                 } else {
190                     require(
191                         absoluteResult <=
192                             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
193                     );
194                     return int256(absoluteResult);
195                 }
196             }
197         }
198     }
199 
200     /**
201      * Calculate x * y rounding down, where x is signed 64.64 fixed point number
202      * and y is unsigned 256-bit integer number.  Revert on overflow.
203      *
204      * @param x signed 64.64 fixed point number
205      * @param y unsigned 256-bit integer number
206      * @return unsigned 256-bit integer number
207      */
208     function mulu(int128 x, uint256 y) internal pure returns (uint256) {
209         unchecked {
210             if (y == 0) return 0;
211 
212             require(x >= 0);
213 
214             uint256 lo = (uint256(int256(x)) *
215                 (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
216             uint256 hi = uint256(int256(x)) * (y >> 128);
217 
218             require(hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
219             hi <<= 64;
220 
221             require(
222                 hi <=
223                     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF -
224                         lo
225             );
226             return hi + lo;
227         }
228     }
229 
230     /**
231      * Calculate x / y rounding towards zero.  Revert on overflow or when y is
232      * zero.
233      *
234      * @param x signed 64.64-bit fixed point number
235      * @param y signed 64.64-bit fixed point number
236      * @return signed 64.64-bit fixed point number
237      */
238     function div(int128 x, int128 y) internal pure returns (int128) {
239         unchecked {
240             require(y != 0);
241             int256 result = (int256(x) << 64) / y;
242             require(result >= MIN_64x64 && result <= MAX_64x64);
243             return int128(result);
244         }
245     }
246 
247     /**
248      * Calculate x / y rounding towards zero, where x and y are signed 256-bit
249      * integer numbers.  Revert on overflow or when y is zero.
250      *
251      * @param x signed 256-bit integer number
252      * @param y signed 256-bit integer number
253      * @return signed 64.64-bit fixed point number
254      */
255     function divi(int256 x, int256 y) internal pure returns (int128) {
256         unchecked {
257             require(y != 0);
258 
259             bool negativeResult = false;
260             if (x < 0) {
261                 x = -x; // We rely on overflow behavior here
262                 negativeResult = true;
263             }
264             if (y < 0) {
265                 y = -y; // We rely on overflow behavior here
266                 negativeResult = !negativeResult;
267             }
268             uint128 absoluteResult = divuu(uint256(x), uint256(y));
269             if (negativeResult) {
270                 require(absoluteResult <= 0x80000000000000000000000000000000);
271                 return -int128(absoluteResult); // We rely on overflow behavior here
272             } else {
273                 require(absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
274                 return int128(absoluteResult); // We rely on overflow behavior here
275             }
276         }
277     }
278 
279     /**
280      * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
281      * integer numbers.  Revert on overflow or when y is zero.
282      *
283      * @param x unsigned 256-bit integer number
284      * @param y unsigned 256-bit integer number
285      * @return signed 64.64-bit fixed point number
286      */
287     function divu(uint256 x, uint256 y) internal pure returns (int128) {
288         unchecked {
289             require(y != 0);
290             uint128 result = divuu(x, y);
291             require(result <= uint128(MAX_64x64));
292             return int128(result);
293         }
294     }
295 
296     /**
297      * Calculate -x.  Revert on overflow.
298      *
299      * @param x signed 64.64-bit fixed point number
300      * @return signed 64.64-bit fixed point number
301      */
302     function neg(int128 x) internal pure returns (int128) {
303         unchecked {
304             require(x != MIN_64x64);
305             return -x;
306         }
307     }
308 
309     /**
310      * Calculate |x|.  Revert on overflow.
311      *
312      * @param x signed 64.64-bit fixed point number
313      * @return signed 64.64-bit fixed point number
314      */
315     function abs(int128 x) internal pure returns (int128) {
316         unchecked {
317             require(x != MIN_64x64);
318             return x < 0 ? -x : x;
319         }
320     }
321 
322     /**
323      * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
324      * zero.
325      *
326      * @param x signed 64.64-bit fixed point number
327      * @return signed 64.64-bit fixed point number
328      */
329     function inv(int128 x) internal pure returns (int128) {
330         unchecked {
331             require(x != 0);
332             int256 result = int256(0x100000000000000000000000000000000) / x;
333             require(result >= MIN_64x64 && result <= MAX_64x64);
334             return int128(result);
335         }
336     }
337 
338     /**
339      * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
340      *
341      * @param x signed 64.64-bit fixed point number
342      * @param y signed 64.64-bit fixed point number
343      * @return signed 64.64-bit fixed point number
344      */
345     function avg(int128 x, int128 y) internal pure returns (int128) {
346         unchecked {
347             return int128((int256(x) + int256(y)) >> 1);
348         }
349     }
350 
351     /**
352      * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
353      * Revert on overflow or in case x * y is negative.
354      *
355      * @param x signed 64.64-bit fixed point number
356      * @param y signed 64.64-bit fixed point number
357      * @return signed 64.64-bit fixed point number
358      */
359     function gavg(int128 x, int128 y) internal pure returns (int128) {
360         unchecked {
361             int256 m = int256(x) * int256(y);
362             require(m >= 0);
363             require(
364                 m <
365                     0x4000000000000000000000000000000000000000000000000000000000000000
366             );
367             return int128(sqrtu(uint256(m)));
368         }
369     }
370 
371     /**
372      * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
373      * and y is unsigned 256-bit integer number.  Revert on overflow.
374      *
375      * @param x signed 64.64-bit fixed point number
376      * @param y uint256 value
377      * @return signed 64.64-bit fixed point number
378      */
379     function pow(int128 x, uint256 y) internal pure returns (int128) {
380         unchecked {
381             bool negative = x < 0 && y & 1 == 1;
382 
383             uint256 absX = uint128(x < 0 ? -x : x);
384             uint256 absResult;
385             absResult = 0x100000000000000000000000000000000;
386 
387             if (absX <= 0x10000000000000000) {
388                 absX <<= 63;
389                 while (y != 0) {
390                     if (y & 0x1 != 0) {
391                         absResult = (absResult * absX) >> 127;
392                     }
393                     absX = (absX * absX) >> 127;
394 
395                     if (y & 0x2 != 0) {
396                         absResult = (absResult * absX) >> 127;
397                     }
398                     absX = (absX * absX) >> 127;
399 
400                     if (y & 0x4 != 0) {
401                         absResult = (absResult * absX) >> 127;
402                     }
403                     absX = (absX * absX) >> 127;
404 
405                     if (y & 0x8 != 0) {
406                         absResult = (absResult * absX) >> 127;
407                     }
408                     absX = (absX * absX) >> 127;
409 
410                     y >>= 4;
411                 }
412 
413                 absResult >>= 64;
414             } else {
415                 uint256 absXShift = 63;
416                 if (absX < 0x1000000000000000000000000) {
417                     absX <<= 32;
418                     absXShift -= 32;
419                 }
420                 if (absX < 0x10000000000000000000000000000) {
421                     absX <<= 16;
422                     absXShift -= 16;
423                 }
424                 if (absX < 0x1000000000000000000000000000000) {
425                     absX <<= 8;
426                     absXShift -= 8;
427                 }
428                 if (absX < 0x10000000000000000000000000000000) {
429                     absX <<= 4;
430                     absXShift -= 4;
431                 }
432                 if (absX < 0x40000000000000000000000000000000) {
433                     absX <<= 2;
434                     absXShift -= 2;
435                 }
436                 if (absX < 0x80000000000000000000000000000000) {
437                     absX <<= 1;
438                     absXShift -= 1;
439                 }
440 
441                 uint256 resultShift = 0;
442                 while (y != 0) {
443                     require(absXShift < 64);
444 
445                     if (y & 0x1 != 0) {
446                         absResult = (absResult * absX) >> 127;
447                         resultShift += absXShift;
448                         if (absResult > 0x100000000000000000000000000000000) {
449                             absResult >>= 1;
450                             resultShift += 1;
451                         }
452                     }
453                     absX = (absX * absX) >> 127;
454                     absXShift <<= 1;
455                     if (absX >= 0x100000000000000000000000000000000) {
456                         absX >>= 1;
457                         absXShift += 1;
458                     }
459 
460                     y >>= 1;
461                 }
462 
463                 require(resultShift < 64);
464                 absResult >>= 64 - resultShift;
465             }
466             int256 result = negative ? -int256(absResult) : int256(absResult);
467             require(result >= MIN_64x64 && result <= MAX_64x64);
468             return int128(result);
469         }
470     }
471 
472     /**
473      * Calculate sqrt (x) rounding down.  Revert if x < 0.
474      *
475      * @param x signed 64.64-bit fixed point number
476      * @return signed 64.64-bit fixed point number
477      */
478     function sqrt(int128 x) internal pure returns (int128) {
479         unchecked {
480             require(x >= 0);
481             return int128(sqrtu(uint256(int256(x)) << 64));
482         }
483     }
484 
485     /**
486      * Calculate binary logarithm of x.  Revert if x <= 0.
487      *
488      * @param x signed 64.64-bit fixed point number
489      * @return signed 64.64-bit fixed point number
490      */
491     function log_2(int128 x) internal pure returns (int128) {
492         unchecked {
493             require(x > 0);
494 
495             int256 msb = 0;
496             int256 xc = x;
497             if (xc >= 0x10000000000000000) {
498                 xc >>= 64;
499                 msb += 64;
500             }
501             if (xc >= 0x100000000) {
502                 xc >>= 32;
503                 msb += 32;
504             }
505             if (xc >= 0x10000) {
506                 xc >>= 16;
507                 msb += 16;
508             }
509             if (xc >= 0x100) {
510                 xc >>= 8;
511                 msb += 8;
512             }
513             if (xc >= 0x10) {
514                 xc >>= 4;
515                 msb += 4;
516             }
517             if (xc >= 0x4) {
518                 xc >>= 2;
519                 msb += 2;
520             }
521             if (xc >= 0x2) msb += 1; // No need to shift xc anymore
522 
523             int256 result = (msb - 64) << 64;
524             uint256 ux = uint256(int256(x)) << uint256(127 - msb);
525             for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
526                 ux *= ux;
527                 uint256 b = ux >> 255;
528                 ux >>= 127 + b;
529                 result += bit * int256(b);
530             }
531 
532             return int128(result);
533         }
534     }
535 
536     /**
537      * Calculate natural logarithm of x.  Revert if x <= 0.
538      *
539      * @param x signed 64.64-bit fixed point number
540      * @return signed 64.64-bit fixed point number
541      */
542     function ln(int128 x) internal pure returns (int128) {
543         unchecked {
544             require(x > 0);
545 
546             return
547                 int128(
548                     int256(
549                         (uint256(int256(log_2(x))) *
550                             0xB17217F7D1CF79ABC9E3B39803F2F6AF) >> 128
551                     )
552                 );
553         }
554     }
555 
556     /**
557      * Calculate binary exponent of x.  Revert on overflow.
558      *
559      * @param x signed 64.64-bit fixed point number
560      * @return signed 64.64-bit fixed point number
561      */
562     function exp_2(int128 x) internal pure returns (int128) {
563         unchecked {
564             require(x < 0x400000000000000000); // Overflow
565 
566             if (x < -0x400000000000000000) return 0; // Underflow
567 
568             uint256 result = 0x80000000000000000000000000000000;
569 
570             if (x & 0x8000000000000000 > 0)
571                 result = (result * 0x16A09E667F3BCC908B2FB1366EA957D3E) >> 128;
572             if (x & 0x4000000000000000 > 0)
573                 result = (result * 0x1306FE0A31B7152DE8D5A46305C85EDEC) >> 128;
574             if (x & 0x2000000000000000 > 0)
575                 result = (result * 0x1172B83C7D517ADCDF7C8C50EB14A791F) >> 128;
576             if (x & 0x1000000000000000 > 0)
577                 result = (result * 0x10B5586CF9890F6298B92B71842A98363) >> 128;
578             if (x & 0x800000000000000 > 0)
579                 result = (result * 0x1059B0D31585743AE7C548EB68CA417FD) >> 128;
580             if (x & 0x400000000000000 > 0)
581                 result = (result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8) >> 128;
582             if (x & 0x200000000000000 > 0)
583                 result = (result * 0x10163DA9FB33356D84A66AE336DCDFA3F) >> 128;
584             if (x & 0x100000000000000 > 0)
585                 result = (result * 0x100B1AFA5ABCBED6129AB13EC11DC9543) >> 128;
586             if (x & 0x80000000000000 > 0)
587                 result = (result * 0x10058C86DA1C09EA1FF19D294CF2F679B) >> 128;
588             if (x & 0x40000000000000 > 0)
589                 result = (result * 0x1002C605E2E8CEC506D21BFC89A23A00F) >> 128;
590             if (x & 0x20000000000000 > 0)
591                 result = (result * 0x100162F3904051FA128BCA9C55C31E5DF) >> 128;
592             if (x & 0x10000000000000 > 0)
593                 result = (result * 0x1000B175EFFDC76BA38E31671CA939725) >> 128;
594             if (x & 0x8000000000000 > 0)
595                 result = (result * 0x100058BA01FB9F96D6CACD4B180917C3D) >> 128;
596             if (x & 0x4000000000000 > 0)
597                 result = (result * 0x10002C5CC37DA9491D0985C348C68E7B3) >> 128;
598             if (x & 0x2000000000000 > 0)
599                 result = (result * 0x1000162E525EE054754457D5995292026) >> 128;
600             if (x & 0x1000000000000 > 0)
601                 result = (result * 0x10000B17255775C040618BF4A4ADE83FC) >> 128;
602             if (x & 0x800000000000 > 0)
603                 result = (result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB) >> 128;
604             if (x & 0x400000000000 > 0)
605                 result = (result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9) >> 128;
606             if (x & 0x200000000000 > 0)
607                 result = (result * 0x10000162E43F4F831060E02D839A9D16D) >> 128;
608             if (x & 0x100000000000 > 0)
609                 result = (result * 0x100000B1721BCFC99D9F890EA06911763) >> 128;
610             if (x & 0x80000000000 > 0)
611                 result = (result * 0x10000058B90CF1E6D97F9CA14DBCC1628) >> 128;
612             if (x & 0x40000000000 > 0)
613                 result = (result * 0x1000002C5C863B73F016468F6BAC5CA2B) >> 128;
614             if (x & 0x20000000000 > 0)
615                 result = (result * 0x100000162E430E5A18F6119E3C02282A5) >> 128;
616             if (x & 0x10000000000 > 0)
617                 result = (result * 0x1000000B1721835514B86E6D96EFD1BFE) >> 128;
618             if (x & 0x8000000000 > 0)
619                 result = (result * 0x100000058B90C0B48C6BE5DF846C5B2EF) >> 128;
620             if (x & 0x4000000000 > 0)
621                 result = (result * 0x10000002C5C8601CC6B9E94213C72737A) >> 128;
622             if (x & 0x2000000000 > 0)
623                 result = (result * 0x1000000162E42FFF037DF38AA2B219F06) >> 128;
624             if (x & 0x1000000000 > 0)
625                 result = (result * 0x10000000B17217FBA9C739AA5819F44F9) >> 128;
626             if (x & 0x800000000 > 0)
627                 result = (result * 0x1000000058B90BFCDEE5ACD3C1CEDC823) >> 128;
628             if (x & 0x400000000 > 0)
629                 result = (result * 0x100000002C5C85FE31F35A6A30DA1BE50) >> 128;
630             if (x & 0x200000000 > 0)
631                 result = (result * 0x10000000162E42FF0999CE3541B9FFFCF) >> 128;
632             if (x & 0x100000000 > 0)
633                 result = (result * 0x100000000B17217F80F4EF5AADDA45554) >> 128;
634             if (x & 0x80000000 > 0)
635                 result = (result * 0x10000000058B90BFBF8479BD5A81B51AD) >> 128;
636             if (x & 0x40000000 > 0)
637                 result = (result * 0x1000000002C5C85FDF84BD62AE30A74CC) >> 128;
638             if (x & 0x20000000 > 0)
639                 result = (result * 0x100000000162E42FEFB2FED257559BDAA) >> 128;
640             if (x & 0x10000000 > 0)
641                 result = (result * 0x1000000000B17217F7D5A7716BBA4A9AE) >> 128;
642             if (x & 0x8000000 > 0)
643                 result = (result * 0x100000000058B90BFBE9DDBAC5E109CCE) >> 128;
644             if (x & 0x4000000 > 0)
645                 result = (result * 0x10000000002C5C85FDF4B15DE6F17EB0D) >> 128;
646             if (x & 0x2000000 > 0)
647                 result = (result * 0x1000000000162E42FEFA494F1478FDE05) >> 128;
648             if (x & 0x1000000 > 0)
649                 result = (result * 0x10000000000B17217F7D20CF927C8E94C) >> 128;
650             if (x & 0x800000 > 0)
651                 result = (result * 0x1000000000058B90BFBE8F71CB4E4B33D) >> 128;
652             if (x & 0x400000 > 0)
653                 result = (result * 0x100000000002C5C85FDF477B662B26945) >> 128;
654             if (x & 0x200000 > 0)
655                 result = (result * 0x10000000000162E42FEFA3AE53369388C) >> 128;
656             if (x & 0x100000 > 0)
657                 result = (result * 0x100000000000B17217F7D1D351A389D40) >> 128;
658             if (x & 0x80000 > 0)
659                 result = (result * 0x10000000000058B90BFBE8E8B2D3D4EDE) >> 128;
660             if (x & 0x40000 > 0)
661                 result = (result * 0x1000000000002C5C85FDF4741BEA6E77E) >> 128;
662             if (x & 0x20000 > 0)
663                 result = (result * 0x100000000000162E42FEFA39FE95583C2) >> 128;
664             if (x & 0x10000 > 0)
665                 result = (result * 0x1000000000000B17217F7D1CFB72B45E1) >> 128;
666             if (x & 0x8000 > 0)
667                 result = (result * 0x100000000000058B90BFBE8E7CC35C3F0) >> 128;
668             if (x & 0x4000 > 0)
669                 result = (result * 0x10000000000002C5C85FDF473E242EA38) >> 128;
670             if (x & 0x2000 > 0)
671                 result = (result * 0x1000000000000162E42FEFA39F02B772C) >> 128;
672             if (x & 0x1000 > 0)
673                 result = (result * 0x10000000000000B17217F7D1CF7D83C1A) >> 128;
674             if (x & 0x800 > 0)
675                 result = (result * 0x1000000000000058B90BFBE8E7BDCBE2E) >> 128;
676             if (x & 0x400 > 0)
677                 result = (result * 0x100000000000002C5C85FDF473DEA871F) >> 128;
678             if (x & 0x200 > 0)
679                 result = (result * 0x10000000000000162E42FEFA39EF44D91) >> 128;
680             if (x & 0x100 > 0)
681                 result = (result * 0x100000000000000B17217F7D1CF79E949) >> 128;
682             if (x & 0x80 > 0)
683                 result = (result * 0x10000000000000058B90BFBE8E7BCE544) >> 128;
684             if (x & 0x40 > 0)
685                 result = (result * 0x1000000000000002C5C85FDF473DE6ECA) >> 128;
686             if (x & 0x20 > 0)
687                 result = (result * 0x100000000000000162E42FEFA39EF366F) >> 128;
688             if (x & 0x10 > 0)
689                 result = (result * 0x1000000000000000B17217F7D1CF79AFA) >> 128;
690             if (x & 0x8 > 0)
691                 result = (result * 0x100000000000000058B90BFBE8E7BCD6D) >> 128;
692             if (x & 0x4 > 0)
693                 result = (result * 0x10000000000000002C5C85FDF473DE6B2) >> 128;
694             if (x & 0x2 > 0)
695                 result = (result * 0x1000000000000000162E42FEFA39EF358) >> 128;
696             if (x & 0x1 > 0)
697                 result = (result * 0x10000000000000000B17217F7D1CF79AB) >> 128;
698 
699             result >>= uint256(int256(63 - (x >> 64)));
700             require(result <= uint256(int256(MAX_64x64)));
701 
702             return int128(int256(result));
703         }
704     }
705 
706     /**
707      * Calculate natural exponent of x.  Revert on overflow.
708      *
709      * @param x signed 64.64-bit fixed point number
710      * @return signed 64.64-bit fixed point number
711      */
712     function exp(int128 x) internal pure returns (int128) {
713         unchecked {
714             require(x < 0x400000000000000000); // Overflow
715 
716             if (x < -0x400000000000000000) return 0; // Underflow
717 
718             return
719                 exp_2(
720                     int128(
721                         (int256(x) * 0x171547652B82FE1777D0FFDA0D23A7D12) >> 128
722                     )
723                 );
724         }
725     }
726 
727     /**
728      * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
729      * integer numbers.  Revert on overflow or when y is zero.
730      *
731      * @param x unsigned 256-bit integer number
732      * @param y unsigned 256-bit integer number
733      * @return unsigned 64.64-bit fixed point number
734      */
735     function divuu(uint256 x, uint256 y) private pure returns (uint128) {
736         unchecked {
737             require(y != 0);
738 
739             uint256 result;
740 
741             if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
742                 result = (x << 64) / y;
743             else {
744                 uint256 msb = 192;
745                 uint256 xc = x >> 192;
746                 if (xc >= 0x100000000) {
747                     xc >>= 32;
748                     msb += 32;
749                 }
750                 if (xc >= 0x10000) {
751                     xc >>= 16;
752                     msb += 16;
753                 }
754                 if (xc >= 0x100) {
755                     xc >>= 8;
756                     msb += 8;
757                 }
758                 if (xc >= 0x10) {
759                     xc >>= 4;
760                     msb += 4;
761                 }
762                 if (xc >= 0x4) {
763                     xc >>= 2;
764                     msb += 2;
765                 }
766                 if (xc >= 0x2) msb += 1; // No need to shift xc anymore
767 
768                 result = (x << (255 - msb)) / (((y - 1) >> (msb - 191)) + 1);
769                 require(result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
770 
771                 uint256 hi = result * (y >> 128);
772                 uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
773 
774                 uint256 xh = x >> 192;
775                 uint256 xl = x << 64;
776 
777                 if (xl < lo) xh -= 1;
778                 xl -= lo; // We rely on overflow behavior here
779                 lo = hi << 128;
780                 if (xl < lo) xh -= 1;
781                 xl -= lo; // We rely on overflow behavior here
782 
783                 assert(xh == hi >> 128);
784 
785                 result += xl / y;
786             }
787 
788             require(result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
789             return uint128(result);
790         }
791     }
792 
793     /**
794      * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
795      * number.
796      *
797      * @param x unsigned 256-bit integer number
798      * @return unsigned 128-bit integer number
799      */
800     function sqrtu(uint256 x) private pure returns (uint128) {
801         unchecked {
802             if (x == 0) return 0;
803             else {
804                 uint256 xx = x;
805                 uint256 r = 1;
806                 if (xx >= 0x100000000000000000000000000000000) {
807                     xx >>= 128;
808                     r <<= 64;
809                 }
810                 if (xx >= 0x10000000000000000) {
811                     xx >>= 64;
812                     r <<= 32;
813                 }
814                 if (xx >= 0x100000000) {
815                     xx >>= 32;
816                     r <<= 16;
817                 }
818                 if (xx >= 0x10000) {
819                     xx >>= 16;
820                     r <<= 8;
821                 }
822                 if (xx >= 0x100) {
823                     xx >>= 8;
824                     r <<= 4;
825                 }
826                 if (xx >= 0x10) {
827                     xx >>= 4;
828                     r <<= 2;
829                 }
830                 if (xx >= 0x8) {
831                     r <<= 1;
832                 }
833                 r = (r + x / r) >> 1;
834                 r = (r + x / r) >> 1;
835                 r = (r + x / r) >> 1;
836                 r = (r + x / r) >> 1;
837                 r = (r + x / r) >> 1;
838                 r = (r + x / r) >> 1;
839                 r = (r + x / r) >> 1; // Seven iterations should be enough
840                 uint256 r1 = x / r;
841                 return uint128(r < r1 ? r : r1);
842             }
843         }
844     }
845 }
846 
847 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
848 
849 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Contract module that helps prevent reentrant calls to a function.
855  *
856  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
857  * available, which can be applied to functions to make sure there are no nested
858  * (reentrant) calls to them.
859  *
860  * Note that because there is a single `nonReentrant` guard, functions marked as
861  * `nonReentrant` may not call one another. This can be worked around by making
862  * those functions `private`, and then adding `external` `nonReentrant` entry
863  * points to them.
864  *
865  * TIP: If you would like to learn more about reentrancy and alternative ways
866  * to protect against it, check out our blog post
867  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
868  */
869 abstract contract ReentrancyGuard {
870     // Booleans are more expensive than uint256 or any type that takes up a full
871     // word because each write operation emits an extra SLOAD to first read the
872     // slot's contents, replace the bits taken up by the boolean, and then write
873     // back. This is the compiler's defense against contract upgrades and
874     // pointer aliasing, and it cannot be disabled.
875 
876     // The values being non-zero value makes deployment a bit more expensive,
877     // but in exchange the refund on every call to nonReentrant will be lower in
878     // amount. Since refunds are capped to a percentage of the total
879     // transaction's gas, it is best to keep them low in cases like this one, to
880     // increase the likelihood of the full refund coming into effect.
881     uint256 private constant _NOT_ENTERED = 1;
882     uint256 private constant _ENTERED = 2;
883 
884     uint256 private _status;
885 
886     constructor() {
887         _status = _NOT_ENTERED;
888     }
889 
890     /**
891      * @dev Prevents a contract from calling itself, directly or indirectly.
892      * Calling a `nonReentrant` function from another `nonReentrant`
893      * function is not supported. It is possible to prevent this from happening
894      * by making the `nonReentrant` function external, and making it call a
895      * `private` function that does the actual work.
896      */
897     modifier nonReentrant() {
898         _nonReentrantBefore();
899         _;
900         _nonReentrantAfter();
901     }
902 
903     function _nonReentrantBefore() private {
904         // On the first call to nonReentrant, _notEntered will be true
905         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
906 
907         // Any calls to nonReentrant after this point will fail
908         _status = _ENTERED;
909     }
910 
911     function _nonReentrantAfter() private {
912         // By storing the original value once again, a refund is triggered (see
913         // https://eips.ethereum.org/EIPS/eip-2200)
914         _status = _NOT_ENTERED;
915     }
916 }
917 
918 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
919 
920 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
921 
922 pragma solidity ^0.8.0;
923 
924 /**
925  * @dev Provides information about the current execution context, including the
926  * sender of the transaction and its data. While these are generally available
927  * via msg.sender and msg.data, they should not be accessed in such a direct
928  * manner, since when dealing with meta-transactions the account sending and
929  * paying for execution may not be the actual sender (as far as an application
930  * is concerned).
931  *
932  * This contract is only required for intermediate, library-like contracts.
933  */
934 abstract contract Context {
935     function _msgSender() internal view virtual returns (address) {
936         return msg.sender;
937     }
938 
939     function _msgData() internal view virtual returns (bytes calldata) {
940         return msg.data;
941     }
942 }
943 
944 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
945 
946 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
947 
948 pragma solidity ^0.8.0;
949 
950 /**
951  * @dev Contract module which provides a basic access control mechanism, where
952  * there is an account (an owner) that can be granted exclusive access to
953  * specific functions.
954  *
955  * By default, the owner account will be the one that deploys the contract. This
956  * can later be changed with {transferOwnership}.
957  *
958  * This module is used through inheritance. It will make available the modifier
959  * `onlyOwner`, which can be applied to your functions to restrict their use to
960  * the owner.
961  */
962 abstract contract Ownable is Context {
963     address private _owner;
964 
965     event OwnershipTransferred(
966         address indexed previousOwner,
967         address indexed newOwner
968     );
969 
970     /**
971      * @dev Initializes the contract setting the deployer as the initial owner.
972      */
973     constructor() {
974         _transferOwnership(_msgSender());
975     }
976 
977     /**
978      * @dev Throws if called by any account other than the owner.
979      */
980     modifier onlyOwner() {
981         _checkOwner();
982         _;
983     }
984 
985     /**
986      * @dev Returns the address of the current owner.
987      */
988     function owner() public view virtual returns (address) {
989         return _owner;
990     }
991 
992     /**
993      * @dev Throws if the sender is not the owner.
994      */
995     function _checkOwner() internal view virtual {
996         require(owner() == _msgSender(), "Ownable: caller is not the owner");
997     }
998 
999     /**
1000      * @dev Leaves the contract without owner. It will not be possible to call
1001      * `onlyOwner` functions anymore. Can only be called by the current owner.
1002      *
1003      * NOTE: Renouncing ownership will leave the contract without an owner,
1004      * thereby removing any functionality that is only available to the owner.
1005      */
1006     function renounceOwnership() public virtual onlyOwner {
1007         _transferOwnership(address(0));
1008     }
1009 
1010     /**
1011      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1012      * Can only be called by the current owner.
1013      */
1014     function transferOwnership(address newOwner) public virtual onlyOwner {
1015         require(
1016             newOwner != address(0),
1017             "Ownable: new owner is the zero address"
1018         );
1019         _transferOwnership(newOwner);
1020     }
1021 
1022     /**
1023      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1024      * Internal function without access restriction.
1025      */
1026     function _transferOwnership(address newOwner) internal virtual {
1027         address oldOwner = _owner;
1028         _owner = newOwner;
1029         emit OwnershipTransferred(oldOwner, newOwner);
1030     }
1031 }
1032 
1033 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
1034 
1035 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 // CAUTION
1040 // This version of SafeMath should only be used with Solidity 0.8 or later,
1041 // because it relies on the compiler's built in overflow checks.
1042 
1043 /**
1044  * @dev Wrappers over Solidity's arithmetic operations.
1045  *
1046  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1047  * now has built in overflow checking.
1048  */
1049 library SafeMath {
1050     /**
1051      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1052      *
1053      * _Available since v3.4._
1054      */
1055     function tryAdd(uint256 a, uint256 b)
1056         internal
1057         pure
1058         returns (bool, uint256)
1059     {
1060         unchecked {
1061             uint256 c = a + b;
1062             if (c < a) return (false, 0);
1063             return (true, c);
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1069      *
1070      * _Available since v3.4._
1071      */
1072     function trySub(uint256 a, uint256 b)
1073         internal
1074         pure
1075         returns (bool, uint256)
1076     {
1077         unchecked {
1078             if (b > a) return (false, 0);
1079             return (true, a - b);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1085      *
1086      * _Available since v3.4._
1087      */
1088     function tryMul(uint256 a, uint256 b)
1089         internal
1090         pure
1091         returns (bool, uint256)
1092     {
1093         unchecked {
1094             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1095             // benefit is lost if 'b' is also tested.
1096             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1097             if (a == 0) return (true, 0);
1098             uint256 c = a * b;
1099             if (c / a != b) return (false, 0);
1100             return (true, c);
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1106      *
1107      * _Available since v3.4._
1108      */
1109     function tryDiv(uint256 a, uint256 b)
1110         internal
1111         pure
1112         returns (bool, uint256)
1113     {
1114         unchecked {
1115             if (b == 0) return (false, 0);
1116             return (true, a / b);
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1122      *
1123      * _Available since v3.4._
1124      */
1125     function tryMod(uint256 a, uint256 b)
1126         internal
1127         pure
1128         returns (bool, uint256)
1129     {
1130         unchecked {
1131             if (b == 0) return (false, 0);
1132             return (true, a % b);
1133         }
1134     }
1135 
1136     /**
1137      * @dev Returns the addition of two unsigned integers, reverting on
1138      * overflow.
1139      *
1140      * Counterpart to Solidity's `+` operator.
1141      *
1142      * Requirements:
1143      *
1144      * - Addition cannot overflow.
1145      */
1146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1147         return a + b;
1148     }
1149 
1150     /**
1151      * @dev Returns the subtraction of two unsigned integers, reverting on
1152      * overflow (when the result is negative).
1153      *
1154      * Counterpart to Solidity's `-` operator.
1155      *
1156      * Requirements:
1157      *
1158      * - Subtraction cannot overflow.
1159      */
1160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1161         return a - b;
1162     }
1163 
1164     /**
1165      * @dev Returns the multiplication of two unsigned integers, reverting on
1166      * overflow.
1167      *
1168      * Counterpart to Solidity's `*` operator.
1169      *
1170      * Requirements:
1171      *
1172      * - Multiplication cannot overflow.
1173      */
1174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1175         return a * b;
1176     }
1177 
1178     /**
1179      * @dev Returns the integer division of two unsigned integers, reverting on
1180      * division by zero. The result is rounded towards zero.
1181      *
1182      * Counterpart to Solidity's `/` operator.
1183      *
1184      * Requirements:
1185      *
1186      * - The divisor cannot be zero.
1187      */
1188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1189         return a / b;
1190     }
1191 
1192     /**
1193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1194      * reverting when dividing by zero.
1195      *
1196      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1197      * opcode (which leaves remaining gas untouched) while Solidity uses an
1198      * invalid opcode to revert (consuming all remaining gas).
1199      *
1200      * Requirements:
1201      *
1202      * - The divisor cannot be zero.
1203      */
1204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1205         return a % b;
1206     }
1207 
1208     /**
1209      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1210      * overflow (when the result is negative).
1211      *
1212      * CAUTION: This function is deprecated because it requires allocating memory for the error
1213      * message unnecessarily. For custom revert reasons use {trySub}.
1214      *
1215      * Counterpart to Solidity's `-` operator.
1216      *
1217      * Requirements:
1218      *
1219      * - Subtraction cannot overflow.
1220      */
1221     function sub(
1222         uint256 a,
1223         uint256 b,
1224         string memory errorMessage
1225     ) internal pure returns (uint256) {
1226         unchecked {
1227             require(b <= a, errorMessage);
1228             return a - b;
1229         }
1230     }
1231 
1232     /**
1233      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1234      * division by zero. The result is rounded towards zero.
1235      *
1236      * Counterpart to Solidity's `/` operator. Note: this function uses a
1237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1238      * uses an invalid opcode to revert (consuming all remaining gas).
1239      *
1240      * Requirements:
1241      *
1242      * - The divisor cannot be zero.
1243      */
1244     function div(
1245         uint256 a,
1246         uint256 b,
1247         string memory errorMessage
1248     ) internal pure returns (uint256) {
1249         unchecked {
1250             require(b > 0, errorMessage);
1251             return a / b;
1252         }
1253     }
1254 
1255     /**
1256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1257      * reverting with custom message when dividing by zero.
1258      *
1259      * CAUTION: This function is deprecated because it requires allocating memory for the error
1260      * message unnecessarily. For custom revert reasons use {tryMod}.
1261      *
1262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1263      * opcode (which leaves remaining gas untouched) while Solidity uses an
1264      * invalid opcode to revert (consuming all remaining gas).
1265      *
1266      * Requirements:
1267      *
1268      * - The divisor cannot be zero.
1269      */
1270     function mod(
1271         uint256 a,
1272         uint256 b,
1273         string memory errorMessage
1274     ) internal pure returns (uint256) {
1275         unchecked {
1276             require(b > 0, errorMessage);
1277             return a % b;
1278         }
1279     }
1280 }
1281 
1282 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol
1283 
1284 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
1285 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 /**
1290  * @dev Library for managing
1291  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1292  * types.
1293  *
1294  * Sets have the following properties:
1295  *
1296  * - Elements are added, removed, and checked for existence in constant time
1297  * (O(1)).
1298  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1299  *
1300  * ```
1301  * contract Example {
1302  *     // Add the library methods
1303  *     using EnumerableSet for EnumerableSet.AddressSet;
1304  *
1305  *     // Declare a set state variable
1306  *     EnumerableSet.AddressSet private mySet;
1307  * }
1308  * ```
1309  *
1310  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1311  * and `uint256` (`UintSet`) are supported.
1312  *
1313  * [WARNING]
1314  * ====
1315  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1316  * unusable.
1317  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1318  *
1319  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1320  * array of EnumerableSet.
1321  * ====
1322  */
1323 library EnumerableSet {
1324     // To implement this library for multiple types with as little code
1325     // repetition as possible, we write it in terms of a generic Set type with
1326     // bytes32 values.
1327     // The Set implementation uses private functions, and user-facing
1328     // implementations (such as AddressSet) are just wrappers around the
1329     // underlying Set.
1330     // This means that we can only create new EnumerableSets for types that fit
1331     // in bytes32.
1332 
1333     struct Set {
1334         // Storage of set values
1335         bytes32[] _values;
1336         // Position of the value in the `values` array, plus 1 because index 0
1337         // means a value is not in the set.
1338         mapping(bytes32 => uint256) _indexes;
1339     }
1340 
1341     /**
1342      * @dev Add a value to a set. O(1).
1343      *
1344      * Returns true if the value was added to the set, that is if it was not
1345      * already present.
1346      */
1347     function _add(Set storage set, bytes32 value) private returns (bool) {
1348         if (!_contains(set, value)) {
1349             set._values.push(value);
1350             // The value is stored at length-1, but we add 1 to all indexes
1351             // and use 0 as a sentinel value
1352             set._indexes[value] = set._values.length;
1353             return true;
1354         } else {
1355             return false;
1356         }
1357     }
1358 
1359     /**
1360      * @dev Removes a value from a set. O(1).
1361      *
1362      * Returns true if the value was removed from the set, that is if it was
1363      * present.
1364      */
1365     function _remove(Set storage set, bytes32 value) private returns (bool) {
1366         // We read and store the value's index to prevent multiple reads from the same storage slot
1367         uint256 valueIndex = set._indexes[value];
1368 
1369         if (valueIndex != 0) {
1370             // Equivalent to contains(set, value)
1371             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1372             // the array, and then remove the last element (sometimes called as 'swap and pop').
1373             // This modifies the order of the array, as noted in {at}.
1374 
1375             uint256 toDeleteIndex = valueIndex - 1;
1376             uint256 lastIndex = set._values.length - 1;
1377 
1378             if (lastIndex != toDeleteIndex) {
1379                 bytes32 lastValue = set._values[lastIndex];
1380 
1381                 // Move the last value to the index where the value to delete is
1382                 set._values[toDeleteIndex] = lastValue;
1383                 // Update the index for the moved value
1384                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1385             }
1386 
1387             // Delete the slot where the moved value was stored
1388             set._values.pop();
1389 
1390             // Delete the index for the deleted slot
1391             delete set._indexes[value];
1392 
1393             return true;
1394         } else {
1395             return false;
1396         }
1397     }
1398 
1399     /**
1400      * @dev Returns true if the value is in the set. O(1).
1401      */
1402     function _contains(Set storage set, bytes32 value)
1403         private
1404         view
1405         returns (bool)
1406     {
1407         return set._indexes[value] != 0;
1408     }
1409 
1410     /**
1411      * @dev Returns the number of values on the set. O(1).
1412      */
1413     function _length(Set storage set) private view returns (uint256) {
1414         return set._values.length;
1415     }
1416 
1417     /**
1418      * @dev Returns the value stored at position `index` in the set. O(1).
1419      *
1420      * Note that there are no guarantees on the ordering of values inside the
1421      * array, and it may change when more values are added or removed.
1422      *
1423      * Requirements:
1424      *
1425      * - `index` must be strictly less than {length}.
1426      */
1427     function _at(Set storage set, uint256 index)
1428         private
1429         view
1430         returns (bytes32)
1431     {
1432         return set._values[index];
1433     }
1434 
1435     /**
1436      * @dev Return the entire set in an array
1437      *
1438      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1439      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1440      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1441      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1442      */
1443     function _values(Set storage set) private view returns (bytes32[] memory) {
1444         return set._values;
1445     }
1446 
1447     // Bytes32Set
1448 
1449     struct Bytes32Set {
1450         Set _inner;
1451     }
1452 
1453     /**
1454      * @dev Add a value to a set. O(1).
1455      *
1456      * Returns true if the value was added to the set, that is if it was not
1457      * already present.
1458      */
1459     function add(Bytes32Set storage set, bytes32 value)
1460         internal
1461         returns (bool)
1462     {
1463         return _add(set._inner, value);
1464     }
1465 
1466     /**
1467      * @dev Removes a value from a set. O(1).
1468      *
1469      * Returns true if the value was removed from the set, that is if it was
1470      * present.
1471      */
1472     function remove(Bytes32Set storage set, bytes32 value)
1473         internal
1474         returns (bool)
1475     {
1476         return _remove(set._inner, value);
1477     }
1478 
1479     /**
1480      * @dev Returns true if the value is in the set. O(1).
1481      */
1482     function contains(Bytes32Set storage set, bytes32 value)
1483         internal
1484         view
1485         returns (bool)
1486     {
1487         return _contains(set._inner, value);
1488     }
1489 
1490     /**
1491      * @dev Returns the number of values in the set. O(1).
1492      */
1493     function length(Bytes32Set storage set) internal view returns (uint256) {
1494         return _length(set._inner);
1495     }
1496 
1497     /**
1498      * @dev Returns the value stored at position `index` in the set. O(1).
1499      *
1500      * Note that there are no guarantees on the ordering of values inside the
1501      * array, and it may change when more values are added or removed.
1502      *
1503      * Requirements:
1504      *
1505      * - `index` must be strictly less than {length}.
1506      */
1507     function at(Bytes32Set storage set, uint256 index)
1508         internal
1509         view
1510         returns (bytes32)
1511     {
1512         return _at(set._inner, index);
1513     }
1514 
1515     /**
1516      * @dev Return the entire set in an array
1517      *
1518      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1519      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1520      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1521      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1522      */
1523     function values(Bytes32Set storage set)
1524         internal
1525         view
1526         returns (bytes32[] memory)
1527     {
1528         bytes32[] memory store = _values(set._inner);
1529         bytes32[] memory result;
1530 
1531         /// @solidity memory-safe-assembly
1532         assembly {
1533             result := store
1534         }
1535 
1536         return result;
1537     }
1538 
1539     // AddressSet
1540 
1541     struct AddressSet {
1542         Set _inner;
1543     }
1544 
1545     /**
1546      * @dev Add a value to a set. O(1).
1547      *
1548      * Returns true if the value was added to the set, that is if it was not
1549      * already present.
1550      */
1551     function add(AddressSet storage set, address value)
1552         internal
1553         returns (bool)
1554     {
1555         return _add(set._inner, bytes32(uint256(uint160(value))));
1556     }
1557 
1558     /**
1559      * @dev Removes a value from a set. O(1).
1560      *
1561      * Returns true if the value was removed from the set, that is if it was
1562      * present.
1563      */
1564     function remove(AddressSet storage set, address value)
1565         internal
1566         returns (bool)
1567     {
1568         return _remove(set._inner, bytes32(uint256(uint160(value))));
1569     }
1570 
1571     /**
1572      * @dev Returns true if the value is in the set. O(1).
1573      */
1574     function contains(AddressSet storage set, address value)
1575         internal
1576         view
1577         returns (bool)
1578     {
1579         return _contains(set._inner, bytes32(uint256(uint160(value))));
1580     }
1581 
1582     /**
1583      * @dev Returns the number of values in the set. O(1).
1584      */
1585     function length(AddressSet storage set) internal view returns (uint256) {
1586         return _length(set._inner);
1587     }
1588 
1589     /**
1590      * @dev Returns the value stored at position `index` in the set. O(1).
1591      *
1592      * Note that there are no guarantees on the ordering of values inside the
1593      * array, and it may change when more values are added or removed.
1594      *
1595      * Requirements:
1596      *
1597      * - `index` must be strictly less than {length}.
1598      */
1599     function at(AddressSet storage set, uint256 index)
1600         internal
1601         view
1602         returns (address)
1603     {
1604         return address(uint160(uint256(_at(set._inner, index))));
1605     }
1606 
1607     /**
1608      * @dev Return the entire set in an array
1609      *
1610      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1611      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1612      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1613      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1614      */
1615     function values(AddressSet storage set)
1616         internal
1617         view
1618         returns (address[] memory)
1619     {
1620         bytes32[] memory store = _values(set._inner);
1621         address[] memory result;
1622 
1623         /// @solidity memory-safe-assembly
1624         assembly {
1625             result := store
1626         }
1627 
1628         return result;
1629     }
1630 
1631     // UintSet
1632 
1633     struct UintSet {
1634         Set _inner;
1635     }
1636 
1637     /**
1638      * @dev Add a value to a set. O(1).
1639      *
1640      * Returns true if the value was added to the set, that is if it was not
1641      * already present.
1642      */
1643     function add(UintSet storage set, uint256 value) internal returns (bool) {
1644         return _add(set._inner, bytes32(value));
1645     }
1646 
1647     /**
1648      * @dev Removes a value from a set. O(1).
1649      *
1650      * Returns true if the value was removed from the set, that is if it was
1651      * present.
1652      */
1653     function remove(UintSet storage set, uint256 value)
1654         internal
1655         returns (bool)
1656     {
1657         return _remove(set._inner, bytes32(value));
1658     }
1659 
1660     /**
1661      * @dev Returns true if the value is in the set. O(1).
1662      */
1663     function contains(UintSet storage set, uint256 value)
1664         internal
1665         view
1666         returns (bool)
1667     {
1668         return _contains(set._inner, bytes32(value));
1669     }
1670 
1671     /**
1672      * @dev Returns the number of values in the set. O(1).
1673      */
1674     function length(UintSet storage set) internal view returns (uint256) {
1675         return _length(set._inner);
1676     }
1677 
1678     /**
1679      * @dev Returns the value stored at position `index` in the set. O(1).
1680      *
1681      * Note that there are no guarantees on the ordering of values inside the
1682      * array, and it may change when more values are added or removed.
1683      *
1684      * Requirements:
1685      *
1686      * - `index` must be strictly less than {length}.
1687      */
1688     function at(UintSet storage set, uint256 index)
1689         internal
1690         view
1691         returns (uint256)
1692     {
1693         return uint256(_at(set._inner, index));
1694     }
1695 
1696     /**
1697      * @dev Return the entire set in an array
1698      *
1699      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1700      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1701      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1702      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1703      */
1704     function values(UintSet storage set)
1705         internal
1706         view
1707         returns (uint256[] memory)
1708     {
1709         bytes32[] memory store = _values(set._inner);
1710         uint256[] memory result;
1711 
1712         /// @solidity memory-safe-assembly
1713         assembly {
1714             result := store
1715         }
1716 
1717         return result;
1718     }
1719 }
1720 
1721 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1722 
1723 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1724 
1725 pragma solidity ^0.8.1;
1726 
1727 /**
1728  * @dev Collection of functions related to the address type
1729  */
1730 library Address {
1731     /**
1732      * @dev Returns true if `account` is a contract.
1733      *
1734      * [IMPORTANT]
1735      * ====
1736      * It is unsafe to assume that an address for which this function returns
1737      * false is an externally-owned account (EOA) and not a contract.
1738      *
1739      * Among others, `isContract` will return false for the following
1740      * types of addresses:
1741      *
1742      *  - an externally-owned account
1743      *  - a contract in construction
1744      *  - an address where a contract will be created
1745      *  - an address where a contract lived, but was destroyed
1746      * ====
1747      *
1748      * [IMPORTANT]
1749      * ====
1750      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1751      *
1752      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1753      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1754      * constructor.
1755      * ====
1756      */
1757     function isContract(address account) internal view returns (bool) {
1758         // This method relies on extcodesize/address.code.length, which returns 0
1759         // for contracts in construction, since the code is only stored at the end
1760         // of the constructor execution.
1761 
1762         return account.code.length > 0;
1763     }
1764 
1765     /**
1766      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1767      * `recipient`, forwarding all available gas and reverting on errors.
1768      *
1769      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1770      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1771      * imposed by `transfer`, making them unable to receive funds via
1772      * `transfer`. {sendValue} removes this limitation.
1773      *
1774      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1775      *
1776      * IMPORTANT: because control is transferred to `recipient`, care must be
1777      * taken to not create reentrancy vulnerabilities. Consider using
1778      * {ReentrancyGuard} or the
1779      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1780      */
1781     function sendValue(address payable recipient, uint256 amount) internal {
1782         require(
1783             address(this).balance >= amount,
1784             "Address: insufficient balance"
1785         );
1786 
1787         (bool success, ) = recipient.call{value: amount}("");
1788         require(
1789             success,
1790             "Address: unable to send value, recipient may have reverted"
1791         );
1792     }
1793 
1794     /**
1795      * @dev Performs a Solidity function call using a low level `call`. A
1796      * plain `call` is an unsafe replacement for a function call: use this
1797      * function instead.
1798      *
1799      * If `target` reverts with a revert reason, it is bubbled up by this
1800      * function (like regular Solidity function calls).
1801      *
1802      * Returns the raw returned data. To convert to the expected return value,
1803      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1804      *
1805      * Requirements:
1806      *
1807      * - `target` must be a contract.
1808      * - calling `target` with `data` must not revert.
1809      *
1810      * _Available since v3.1._
1811      */
1812     function functionCall(address target, bytes memory data)
1813         internal
1814         returns (bytes memory)
1815     {
1816         return
1817             functionCallWithValue(
1818                 target,
1819                 data,
1820                 0,
1821                 "Address: low-level call failed"
1822             );
1823     }
1824 
1825     /**
1826      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1827      * `errorMessage` as a fallback revert reason when `target` reverts.
1828      *
1829      * _Available since v3.1._
1830      */
1831     function functionCall(
1832         address target,
1833         bytes memory data,
1834         string memory errorMessage
1835     ) internal returns (bytes memory) {
1836         return functionCallWithValue(target, data, 0, errorMessage);
1837     }
1838 
1839     /**
1840      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1841      * but also transferring `value` wei to `target`.
1842      *
1843      * Requirements:
1844      *
1845      * - the calling contract must have an ETH balance of at least `value`.
1846      * - the called Solidity function must be `payable`.
1847      *
1848      * _Available since v3.1._
1849      */
1850     function functionCallWithValue(
1851         address target,
1852         bytes memory data,
1853         uint256 value
1854     ) internal returns (bytes memory) {
1855         return
1856             functionCallWithValue(
1857                 target,
1858                 data,
1859                 value,
1860                 "Address: low-level call with value failed"
1861             );
1862     }
1863 
1864     /**
1865      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1866      * with `errorMessage` as a fallback revert reason when `target` reverts.
1867      *
1868      * _Available since v3.1._
1869      */
1870     function functionCallWithValue(
1871         address target,
1872         bytes memory data,
1873         uint256 value,
1874         string memory errorMessage
1875     ) internal returns (bytes memory) {
1876         require(
1877             address(this).balance >= value,
1878             "Address: insufficient balance for call"
1879         );
1880         (bool success, bytes memory returndata) = target.call{value: value}(
1881             data
1882         );
1883         return
1884             verifyCallResultFromTarget(
1885                 target,
1886                 success,
1887                 returndata,
1888                 errorMessage
1889             );
1890     }
1891 
1892     /**
1893      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1894      * but performing a static call.
1895      *
1896      * _Available since v3.3._
1897      */
1898     function functionStaticCall(address target, bytes memory data)
1899         internal
1900         view
1901         returns (bytes memory)
1902     {
1903         return
1904             functionStaticCall(
1905                 target,
1906                 data,
1907                 "Address: low-level static call failed"
1908             );
1909     }
1910 
1911     /**
1912      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1913      * but performing a static call.
1914      *
1915      * _Available since v3.3._
1916      */
1917     function functionStaticCall(
1918         address target,
1919         bytes memory data,
1920         string memory errorMessage
1921     ) internal view returns (bytes memory) {
1922         (bool success, bytes memory returndata) = target.staticcall(data);
1923         return
1924             verifyCallResultFromTarget(
1925                 target,
1926                 success,
1927                 returndata,
1928                 errorMessage
1929             );
1930     }
1931 
1932     /**
1933      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1934      * but performing a delegate call.
1935      *
1936      * _Available since v3.4._
1937      */
1938     function functionDelegateCall(address target, bytes memory data)
1939         internal
1940         returns (bytes memory)
1941     {
1942         return
1943             functionDelegateCall(
1944                 target,
1945                 data,
1946                 "Address: low-level delegate call failed"
1947             );
1948     }
1949 
1950     /**
1951      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1952      * but performing a delegate call.
1953      *
1954      * _Available since v3.4._
1955      */
1956     function functionDelegateCall(
1957         address target,
1958         bytes memory data,
1959         string memory errorMessage
1960     ) internal returns (bytes memory) {
1961         (bool success, bytes memory returndata) = target.delegatecall(data);
1962         return
1963             verifyCallResultFromTarget(
1964                 target,
1965                 success,
1966                 returndata,
1967                 errorMessage
1968             );
1969     }
1970 
1971     /**
1972      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1973      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1974      *
1975      * _Available since v4.8._
1976      */
1977     function verifyCallResultFromTarget(
1978         address target,
1979         bool success,
1980         bytes memory returndata,
1981         string memory errorMessage
1982     ) internal view returns (bytes memory) {
1983         if (success) {
1984             if (returndata.length == 0) {
1985                 // only check isContract if the call was successful and the return data is empty
1986                 // otherwise we already know that it was a contract
1987                 require(isContract(target), "Address: call to non-contract");
1988             }
1989             return returndata;
1990         } else {
1991             _revert(returndata, errorMessage);
1992         }
1993     }
1994 
1995     /**
1996      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1997      * revert reason or using the provided one.
1998      *
1999      * _Available since v4.3._
2000      */
2001     function verifyCallResult(
2002         bool success,
2003         bytes memory returndata,
2004         string memory errorMessage
2005     ) internal pure returns (bytes memory) {
2006         if (success) {
2007             return returndata;
2008         } else {
2009             _revert(returndata, errorMessage);
2010         }
2011     }
2012 
2013     function _revert(bytes memory returndata, string memory errorMessage)
2014         private
2015         pure
2016     {
2017         // Look for revert reason and bubble it up if present
2018         if (returndata.length > 0) {
2019             // The easiest way to bubble the revert reason is using memory via assembly
2020             /// @solidity memory-safe-assembly
2021             assembly {
2022                 let returndata_size := mload(returndata)
2023                 revert(add(32, returndata), returndata_size)
2024             }
2025         } else {
2026             revert(errorMessage);
2027         }
2028     }
2029 }
2030 
2031 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
2032 
2033 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
2034 
2035 pragma solidity ^0.8.0;
2036 
2037 /**
2038  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2039  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2040  *
2041  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2042  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2043  * need to send a transaction, and thus is not required to hold Ether at all.
2044  */
2045 interface IERC20Permit {
2046     /**
2047      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2048      * given ``owner``'s signed approval.
2049      *
2050      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2051      * ordering also apply here.
2052      *
2053      * Emits an {Approval} event.
2054      *
2055      * Requirements:
2056      *
2057      * - `spender` cannot be the zero address.
2058      * - `deadline` must be a timestamp in the future.
2059      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2060      * over the EIP712-formatted function arguments.
2061      * - the signature must use ``owner``'s current nonce (see {nonces}).
2062      *
2063      * For more information on the signature format, see the
2064      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2065      * section].
2066      */
2067     function permit(
2068         address owner,
2069         address spender,
2070         uint256 value,
2071         uint256 deadline,
2072         uint8 v,
2073         bytes32 r,
2074         bytes32 s
2075     ) external;
2076 
2077     /**
2078      * @dev Returns the current nonce for `owner`. This value must be
2079      * included whenever a signature is generated for {permit}.
2080      *
2081      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2082      * prevents a signature from being used multiple times.
2083      */
2084     function nonces(address owner) external view returns (uint256);
2085 
2086     /**
2087      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2088      */
2089     // solhint-disable-next-line func-name-mixedcase
2090     function DOMAIN_SEPARATOR() external view returns (bytes32);
2091 }
2092 
2093 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
2094 
2095 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2096 
2097 pragma solidity ^0.8.0;
2098 
2099 /**
2100  * @dev Interface of the ERC20 standard as defined in the EIP.
2101  */
2102 interface IERC20 {
2103     /**
2104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2105      * another (`to`).
2106      *
2107      * Note that `value` may be zero.
2108      */
2109     event Transfer(address indexed from, address indexed to, uint256 value);
2110 
2111     /**
2112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2113      * a call to {approve}. `value` is the new allowance.
2114      */
2115     event Approval(
2116         address indexed owner,
2117         address indexed spender,
2118         uint256 value
2119     );
2120 
2121     /**
2122      * @dev Returns the amount of tokens in existence.
2123      */
2124     function totalSupply() external view returns (uint256);
2125 
2126     /**
2127      * @dev Returns the amount of tokens owned by `account`.
2128      */
2129     function balanceOf(address account) external view returns (uint256);
2130 
2131     /**
2132      * @dev Moves `amount` tokens from the caller's account to `to`.
2133      *
2134      * Returns a boolean value indicating whether the operation succeeded.
2135      *
2136      * Emits a {Transfer} event.
2137      */
2138     function transfer(address to, uint256 amount) external returns (bool);
2139 
2140     /**
2141      * @dev Returns the remaining number of tokens that `spender` will be
2142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2143      * zero by default.
2144      *
2145      * This value changes when {approve} or {transferFrom} are called.
2146      */
2147     function allowance(address owner, address spender)
2148         external
2149         view
2150         returns (uint256);
2151 
2152     /**
2153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2154      *
2155      * Returns a boolean value indicating whether the operation succeeded.
2156      *
2157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2158      * that someone may use both the old and the new allowance by unfortunate
2159      * transaction ordering. One possible solution to mitigate this race
2160      * condition is to first reduce the spender's allowance to 0 and set the
2161      * desired value afterwards:
2162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2163      *
2164      * Emits an {Approval} event.
2165      */
2166     function approve(address spender, uint256 amount) external returns (bool);
2167 
2168     /**
2169      * @dev Moves `amount` tokens from `from` to `to` using the
2170      * allowance mechanism. `amount` is then deducted from the caller's
2171      * allowance.
2172      *
2173      * Returns a boolean value indicating whether the operation succeeded.
2174      *
2175      * Emits a {Transfer} event.
2176      */
2177     function transferFrom(
2178         address from,
2179         address to,
2180         uint256 amount
2181     ) external returns (bool);
2182 }
2183 
2184 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol
2185 
2186 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
2187 
2188 pragma solidity ^0.8.0;
2189 
2190 /**
2191  * @title SafeERC20
2192  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2193  * contract returns false). Tokens that return no value (and instead revert or
2194  * throw on failure) are also supported, non-reverting calls are assumed to be
2195  * successful.
2196  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2197  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2198  */
2199 library SafeERC20 {
2200     using Address for address;
2201 
2202     function safeTransfer(
2203         IERC20 token,
2204         address to,
2205         uint256 value
2206     ) internal {
2207         _callOptionalReturn(
2208             token,
2209             abi.encodeWithSelector(token.transfer.selector, to, value)
2210         );
2211     }
2212 
2213     function safeTransferFrom(
2214         IERC20 token,
2215         address from,
2216         address to,
2217         uint256 value
2218     ) internal {
2219         _callOptionalReturn(
2220             token,
2221             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
2222         );
2223     }
2224 
2225     /**
2226      * @dev Deprecated. This function has issues similar to the ones found in
2227      * {IERC20-approve}, and its usage is discouraged.
2228      *
2229      * Whenever possible, use {safeIncreaseAllowance} and
2230      * {safeDecreaseAllowance} instead.
2231      */
2232     function safeApprove(
2233         IERC20 token,
2234         address spender,
2235         uint256 value
2236     ) internal {
2237         // safeApprove should only be called when setting an initial allowance,
2238         // or when resetting it to zero. To increase and decrease it, use
2239         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2240         require(
2241             (value == 0) || (token.allowance(address(this), spender) == 0),
2242             "SafeERC20: approve from non-zero to non-zero allowance"
2243         );
2244         _callOptionalReturn(
2245             token,
2246             abi.encodeWithSelector(token.approve.selector, spender, value)
2247         );
2248     }
2249 
2250     function safeIncreaseAllowance(
2251         IERC20 token,
2252         address spender,
2253         uint256 value
2254     ) internal {
2255         uint256 newAllowance = token.allowance(address(this), spender) + value;
2256         _callOptionalReturn(
2257             token,
2258             abi.encodeWithSelector(
2259                 token.approve.selector,
2260                 spender,
2261                 newAllowance
2262             )
2263         );
2264     }
2265 
2266     function safeDecreaseAllowance(
2267         IERC20 token,
2268         address spender,
2269         uint256 value
2270     ) internal {
2271         unchecked {
2272             uint256 oldAllowance = token.allowance(address(this), spender);
2273             require(
2274                 oldAllowance >= value,
2275                 "SafeERC20: decreased allowance below zero"
2276             );
2277             uint256 newAllowance = oldAllowance - value;
2278             _callOptionalReturn(
2279                 token,
2280                 abi.encodeWithSelector(
2281                     token.approve.selector,
2282                     spender,
2283                     newAllowance
2284                 )
2285             );
2286         }
2287     }
2288 
2289     function safePermit(
2290         IERC20Permit token,
2291         address owner,
2292         address spender,
2293         uint256 value,
2294         uint256 deadline,
2295         uint8 v,
2296         bytes32 r,
2297         bytes32 s
2298     ) internal {
2299         uint256 nonceBefore = token.nonces(owner);
2300         token.permit(owner, spender, value, deadline, v, r, s);
2301         uint256 nonceAfter = token.nonces(owner);
2302         require(
2303             nonceAfter == nonceBefore + 1,
2304             "SafeERC20: permit did not succeed"
2305         );
2306     }
2307 
2308     /**
2309      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2310      * on the return value: the return value is optional (but if data is returned, it must not be false).
2311      * @param token The token targeted by the call.
2312      * @param data The call data (encoded using abi.encode or one of its variants).
2313      */
2314     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2315         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2316         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2317         // the target address contains contract code and also asserts for success in the low-level call.
2318 
2319         bytes memory returndata = address(token).functionCall(
2320             data,
2321             "SafeERC20: low-level call failed"
2322         );
2323         if (returndata.length > 0) {
2324             // Return data is optional
2325             require(
2326                 abi.decode(returndata, (bool)),
2327                 "SafeERC20: ERC20 operation did not succeed"
2328             );
2329         }
2330     }
2331 }
2332 
2333 // File: contracts/EggChef.sol
2334 
2335 pragma solidity ^0.8.0;
2336 
2337 interface IUniswapPair {
2338     event Sync(uint112 reserve0, uint112 reserve1);
2339 
2340     function sync() external;
2341 }
2342 
2343 interface IEggsToken {
2344     function mint(address to, uint256 amount) external;
2345 
2346     function rebase(
2347         uint256 epoch,
2348         uint256 indexDelta,
2349         bool positive
2350     ) external returns (uint256);
2351 
2352     function totalSupply() external view returns (uint256);
2353 
2354     function transferUnderlying(address to, uint256 value)
2355         external
2356         returns (bool);
2357 
2358     function fragmentToEggs(uint256 value) external view returns (uint256);
2359 
2360     function eggsToFragment(uint256 eggs) external view returns (uint256);
2361 
2362     function balanceOfUnderlying(address who) external view returns (uint256);
2363 }
2364 
2365 contract EggChef is Ownable, ReentrancyGuard {
2366     using SafeERC20 for IERC20;
2367     using Address for address;
2368 
2369     struct UserInfo {
2370         uint256 amount; // How many LP tokens the user has provided.
2371         uint256 rewardDebt; // Reward debt. See explanation below.
2372         uint256 lockEndedTimestamp;
2373         //
2374         //   pending reward = (user.amount * pool.accRewardPerShare) - user.rewardDebt
2375         //
2376         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
2377         //   1. The pool's `accRewardPerShare` (and `lastRewardBlock`) gets updated.
2378         //   2. User receives the pending reward sent to his/her address.
2379         //   3. User's `amount` gets updated.
2380         //   4. User's `rewardDebt` gets updated.
2381     }
2382 
2383     struct PoolInfo {
2384         IERC20 lpToken; // Address of LP token contract.
2385         uint256 allocPoint; // How many allocation points assigned to this pool. Rewards to distribute per block.
2386         uint256 lastRewardBlock; // Last block number that Rewards distribution occurs.
2387         uint256 accRewardPerShare; // Accumulated Rewards per share.
2388     }
2389 
2390     // EGGS
2391     IEggsToken public eggs;
2392     // EGGS LP address
2393     IUniswapPair public eggsLp;
2394     // EGGS tokens reward per block.
2395     uint256 public rewardPerBlock;
2396     // Compound ratio which is 0.001% (will be used to decrease supply)
2397     uint256 public compoundRatio = 1e13;
2398     // Start rebase from first Ethereum PoS block
2399     uint256 public lastBlock;
2400 
2401     // Info of each pool.
2402     PoolInfo[] public poolInfo;
2403     // Info of each user.
2404     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
2405     // user's withdrawable rewards
2406     mapping(uint256 => mapping(address => uint256)) private userRewards;
2407     // Lock duration in seconds
2408     mapping(uint256 => uint256) public lockDurations;
2409     // Total allocation points. Must be the sum of all allocation points in all pools.
2410     uint256 public totalAllocPoint = 0;
2411     // The block number when EGGS mining starts.
2412     uint256 public startBlock;
2413 
2414     // Events
2415     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2416     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2417     event RewardPaid(address indexed user, uint256 indexed pid, uint256 amount);
2418     event LogRewardPerBlock(uint256 amount);
2419     event LogPoolAddition(
2420         uint256 indexed pid,
2421         uint256 allocPoint,
2422         IERC20 indexed lpToken
2423     );
2424     event LogSetPool(uint256 indexed pid, uint256 allocPoint);
2425     event LogUpdatePool(
2426         uint256 indexed pid,
2427         uint256 lastRewardBlock,
2428         uint256 lpSupply,
2429         uint256 accRewardPerShare
2430     );
2431     event LogSetLockDuration(uint256 indexed pid, uint256 lockDuration);
2432 
2433     constructor(
2434         IEggsToken _eggs,
2435         IUniswapPair _eggsLp,
2436         uint256 _rewardPerBlock,
2437         uint256 _startBlock
2438     ) Ownable() ReentrancyGuard() {
2439         eggs = _eggs;
2440         eggsLp = _eggsLp;
2441         rewardPerBlock = _rewardPerBlock;
2442         startBlock = _startBlock;
2443         lastBlock = _startBlock;
2444     }
2445 
2446     function pow(int128 x, uint256 n) public pure returns (int128 r) {
2447         r = ABDKMath64x64.fromUInt(1);
2448         while (n > 0) {
2449             if (n % 2 == 1) {
2450                 r = ABDKMath64x64.mul(r, x);
2451                 n -= 1;
2452             } else {
2453                 x = ABDKMath64x64.mul(x, x);
2454                 n /= 2;
2455             }
2456         }
2457     }
2458 
2459     function compound(
2460         uint256 principal,
2461         uint256 ratio,
2462         uint256 n
2463     ) public pure returns (uint256) {
2464         return
2465             ABDKMath64x64.mulu(
2466                 pow(
2467                     ABDKMath64x64.add(
2468                         ABDKMath64x64.fromUInt(1),
2469                         ABDKMath64x64.divu(ratio, 10**18)
2470                     ),
2471                     n
2472                 ),
2473                 principal
2474             );
2475     }
2476 
2477     function poolLength() external view returns (uint256) {
2478         return poolInfo.length;
2479     }
2480 
2481     function setLockDuration(uint256 _pid, uint256 _lockDuration)
2482         external
2483         onlyOwner
2484     {
2485         lockDurations[_pid] = _lockDuration;
2486         emit LogSetLockDuration(_pid, _lockDuration);
2487     }
2488 
2489     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
2490         massUpdatePools();
2491         rewardPerBlock = _rewardPerBlock;
2492         emit LogRewardPerBlock(_rewardPerBlock);
2493     }
2494 
2495     // Add a new lp to the pool. Can only be called by the owner.
2496     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2497     function add(
2498         uint256 _allocPoint,
2499         IERC20 _lpToken,
2500         bool _withUpdate
2501     ) external onlyOwner {
2502         if (_withUpdate) {
2503             massUpdatePools();
2504         }
2505         uint256 lastRewardBlock = block.number > startBlock
2506             ? block.number
2507             : startBlock;
2508         totalAllocPoint = totalAllocPoint + _allocPoint;
2509         poolInfo.push(
2510             PoolInfo({
2511                 lpToken: _lpToken,
2512                 allocPoint: _allocPoint,
2513                 lastRewardBlock: lastRewardBlock,
2514                 accRewardPerShare: 0
2515             })
2516         );
2517 
2518         emit LogPoolAddition(poolInfo.length - 1, _allocPoint, _lpToken);
2519     }
2520 
2521     // Update the given pool's EGGS allocation point. Can only be called by the owner.
2522     function set(
2523         uint256 _pid,
2524         uint256 _allocPoint,
2525         bool _withUpdate
2526     ) external onlyOwner {
2527         if (_withUpdate) {
2528             massUpdatePools();
2529         }
2530         totalAllocPoint =
2531             totalAllocPoint -
2532             poolInfo[_pid].allocPoint +
2533             _allocPoint;
2534         poolInfo[_pid].allocPoint = _allocPoint;
2535         emit LogSetPool(_pid, _allocPoint);
2536     }
2537 
2538     // View function to see pending Eggs on frontend.
2539     function pendingReward(uint256 _pid, address _user)
2540         external
2541         view
2542         returns (uint256)
2543     {
2544         PoolInfo storage pool = poolInfo[_pid];
2545         UserInfo storage user = userInfo[_pid][_user];
2546         uint256 accRewardPerShare = pool.accRewardPerShare;
2547         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2548         if (address(pool.lpToken) == address(eggs)) {
2549             lpSupply = eggs.balanceOfUnderlying(address(this));
2550         }
2551         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
2552             uint256 eggsReward = ((block.number - pool.lastRewardBlock) *
2553                 rewardPerBlock *
2554                 pool.allocPoint) / totalAllocPoint;
2555             accRewardPerShare += (eggsReward * 1e12) / lpSupply;
2556         }
2557         return
2558             userRewards[_pid][_user] +
2559             (user.amount * accRewardPerShare) /
2560             1e12 -
2561             user.rewardDebt;
2562     }
2563 
2564     // Update reward vairables for all pools. Be careful of gas spending!
2565     function massUpdatePools() public {
2566         uint256 length = poolInfo.length;
2567         for (uint256 pid = 0; pid < length; ++pid) {
2568             updatePool(pid);
2569         }
2570     }
2571 
2572     // Update reward variables of the given pool to be up-to-date.
2573     function updatePool(uint256 _pid) public {
2574         PoolInfo storage pool = poolInfo[_pid];
2575         if (block.number <= pool.lastRewardBlock) {
2576             return;
2577         }
2578         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2579         if (address(pool.lpToken) == address(eggs)) {
2580             lpSupply = eggs.balanceOfUnderlying(address(this));
2581         }
2582         if (lpSupply == 0) {
2583             pool.lastRewardBlock = block.number;
2584             return;
2585         }
2586         uint256 eggsReward = ((block.number - pool.lastRewardBlock) *
2587             rewardPerBlock *
2588             pool.allocPoint) / totalAllocPoint;
2589         pool.accRewardPerShare += (eggsReward * 1e12) / lpSupply;
2590         pool.lastRewardBlock = block.number;
2591 
2592         emit LogUpdatePool(
2593             _pid,
2594             pool.lastRewardBlock,
2595             lpSupply,
2596             pool.accRewardPerShare
2597         );
2598     }
2599 
2600     // Deposit tokens to EggsChef for EGGS allocation.
2601     function deposit(uint256 _pid, uint256 _amount) external nonReentrant {
2602         require(_amount > 0, "invalid amount");
2603 
2604         PoolInfo storage pool = poolInfo[_pid];
2605         UserInfo storage user = userInfo[_pid][msg.sender];
2606         user.lockEndedTimestamp = block.timestamp + lockDurations[_pid];
2607         updatePool(_pid);
2608         queueRewards(_pid, msg.sender);
2609 
2610         pool.lpToken.safeTransferFrom(
2611             address(msg.sender),
2612             address(this),
2613             _amount
2614         );
2615 
2616         emit Deposit(msg.sender, _pid, _amount);
2617 
2618         if (address(pool.lpToken) == address(eggs)) {
2619             _amount = eggs.fragmentToEggs(_amount);
2620         }
2621 
2622         user.amount += _amount;
2623         user.rewardDebt = (user.amount * pool.accRewardPerShare) / 1e12;
2624     }
2625 
2626     // Withdraw tokens from EggChef.
2627     function withdraw(uint256 _pid, uint256 _amount) external nonReentrant {
2628         require(_amount > 0, "invalid amount");
2629 
2630         PoolInfo storage pool = poolInfo[_pid];
2631         UserInfo storage user = userInfo[_pid][msg.sender];
2632         require(user.lockEndedTimestamp <= block.timestamp, "still locked");
2633         require(user.amount >= _amount, "invalid amount");
2634 
2635         updatePool(_pid);
2636         queueRewards(_pid, msg.sender);
2637 
2638         user.amount -= _amount;
2639         user.rewardDebt = (user.amount * pool.accRewardPerShare) / 1e12;
2640         if (address(pool.lpToken) == address(eggs)) {
2641             _amount = eggs.eggsToFragment(_amount);
2642         }
2643         pool.lpToken.safeTransfer(address(msg.sender), _amount);
2644 
2645         emit Withdraw(msg.sender, _pid, _amount);
2646     }
2647 
2648     // Claim EGGS from EggChef
2649     function claim(uint256 _pid, address _account) external nonReentrant {
2650         updatePool(_pid);
2651         queueRewards(_pid, _account);
2652 
2653         uint256 pending = userRewards[_pid][_account];
2654         require(pending > 0, "no pending rewards");
2655 
2656         UserInfo storage user = userInfo[_pid][msg.sender];
2657         user.lockEndedTimestamp = block.timestamp + lockDurations[_pid];
2658 
2659         userRewards[_pid][_account] = 0;
2660         userInfo[_pid][_account].rewardDebt =
2661             (userInfo[_pid][_account].amount *
2662                 poolInfo[_pid].accRewardPerShare) /
2663             (1e12);
2664 
2665         eggs.mint(_account, pending);
2666         if (lastBlock != block.number) {
2667             eggs.rebase(
2668                 block.number,
2669                 compound(1e18, compoundRatio, block.number - lastBlock) - 1e18,
2670                 false
2671             );
2672             lastBlock = block.number;
2673             eggsLp.sync();
2674         }
2675         emit RewardPaid(_account, _pid, pending);
2676     }
2677 
2678     // Queue rewards - increase pending rewards
2679     function queueRewards(uint256 _pid, address _account) internal {
2680         UserInfo memory user = userInfo[_pid][_account];
2681         uint256 pending = (user.amount * poolInfo[_pid].accRewardPerShare) /
2682             (1e12) -
2683             user.rewardDebt;
2684         if (pending > 0) {
2685             userRewards[_pid][_account] += pending;
2686         }
2687     }
2688 }