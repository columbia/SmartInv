1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: ABDKMath64x64
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
18   /*
19    * Minimum value signed 64.64-bit fixed point number may have. 
20    */
21   int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
22 
23   /*
24    * Maximum value signed 64.64-bit fixed point number may have. 
25    */
26   int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
27 
28   /**
29    * Convert signed 256-bit integer number into signed 64.64-bit fixed point
30    * number.  Revert on overflow.
31    *
32    * @param x signed 256-bit integer number
33    * @return signed 64.64-bit fixed point number
34    */
35   function fromInt (int256 x) internal pure returns (int128) {
36     require (x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
37     return int128 (x << 64);
38   }
39 
40   /**
41    * Convert signed 64.64 fixed point number into signed 64-bit integer number
42    * rounding down.
43    *
44    * @param x signed 64.64-bit fixed point number
45    * @return signed 64-bit integer number
46    */
47   function toInt (int128 x) internal pure returns (int64) {
48     return int64 (x >> 64);
49   }
50 
51   /**
52    * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
53    * number.  Revert on overflow.
54    *
55    * @param x unsigned 256-bit integer number
56    * @return signed 64.64-bit fixed point number
57    */
58   function fromUInt (uint256 x) internal pure returns (int128) {
59     require (x <= 0x7FFFFFFFFFFFFFFF);
60     return int128 (x << 64);
61   }
62 
63   /**
64    * Convert signed 64.64 fixed point number into unsigned 64-bit integer
65    * number rounding down.  Revert on underflow.
66    *
67    * @param x signed 64.64-bit fixed point number
68    * @return unsigned 64-bit integer number
69    */
70   function toUInt (int128 x) internal pure returns (uint64) {
71     require (x >= 0);
72     return uint64 (x >> 64);
73   }
74 
75   /**
76    * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
77    * number rounding down.  Revert on overflow.
78    *
79    * @param x signed 128.128-bin fixed point number
80    * @return signed 64.64-bit fixed point number
81    */
82   function from128x128 (int256 x) internal pure returns (int128) {
83     int256 result = x >> 64;
84     require (result >= MIN_64x64 && result <= MAX_64x64);
85     return int128 (result);
86   }
87 
88   /**
89    * Convert signed 64.64 fixed point number into signed 128.128 fixed point
90    * number.
91    *
92    * @param x signed 64.64-bit fixed point number
93    * @return signed 128.128 fixed point number
94    */
95   function to128x128 (int128 x) internal pure returns (int256) {
96     return int256 (x) << 64;
97   }
98 
99   /**
100    * Calculate x + y.  Revert on overflow.
101    *
102    * @param x signed 64.64-bit fixed point number
103    * @param y signed 64.64-bit fixed point number
104    * @return signed 64.64-bit fixed point number
105    */
106   function add (int128 x, int128 y) internal pure returns (int128) {
107     int256 result = int256(x) + y;
108     require (result >= MIN_64x64 && result <= MAX_64x64);
109     return int128 (result);
110   }
111 
112   /**
113    * Calculate x - y.  Revert on overflow.
114    *
115    * @param x signed 64.64-bit fixed point number
116    * @param y signed 64.64-bit fixed point number
117    * @return signed 64.64-bit fixed point number
118    */
119   function sub (int128 x, int128 y) internal pure returns (int128) {
120     int256 result = int256(x) - y;
121     require (result >= MIN_64x64 && result <= MAX_64x64);
122     return int128 (result);
123   }
124 
125   /**
126    * Calculate x * y rounding down.  Revert on overflow.
127    *
128    * @param x signed 64.64-bit fixed point number
129    * @param y signed 64.64-bit fixed point number
130    * @return signed 64.64-bit fixed point number
131    */
132   function mul (int128 x, int128 y) internal pure returns (int128) {
133     int256 result = int256(x) * y >> 64;
134     require (result >= MIN_64x64 && result <= MAX_64x64);
135     return int128 (result);
136   }
137 
138   /**
139    * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
140    * number and y is signed 256-bit integer number.  Revert on overflow.
141    *
142    * @param x signed 64.64 fixed point number
143    * @param y signed 256-bit integer number
144    * @return signed 256-bit integer number
145    */
146   function muli (int128 x, int256 y) internal pure returns (int256) {
147     if (x == MIN_64x64) {
148       require (y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
149         y <= 0x1000000000000000000000000000000000000000000000000);
150       return -y << 63;
151     } else {
152       bool negativeResult = false;
153       if (x < 0) {
154         x = -x;
155         negativeResult = true;
156       }
157       if (y < 0) {
158         y = -y; // We rely on overflow behavior here
159         negativeResult = !negativeResult;
160       }
161       uint256 absoluteResult = mulu (x, uint256 (y));
162       if (negativeResult) {
163         require (absoluteResult <=
164           0x8000000000000000000000000000000000000000000000000000000000000000);
165         return -int256 (absoluteResult); // We rely on overflow behavior here
166       } else {
167         require (absoluteResult <=
168           0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
169         return int256 (absoluteResult);
170       }
171     }
172   }
173 
174   /**
175    * Calculate x * y rounding down, where x is signed 64.64 fixed point number
176    * and y is unsigned 256-bit integer number.  Revert on overflow.
177    *
178    * @param x signed 64.64 fixed point number
179    * @param y unsigned 256-bit integer number
180    * @return unsigned 256-bit integer number
181    */
182   function mulu (int128 x, uint256 y) internal pure returns (uint256) {
183     if (y == 0) return 0;
184 
185     require (x >= 0);
186 
187     uint256 lo = (uint256 (x) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
188     uint256 hi = uint256 (x) * (y >> 128);
189 
190     require (hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
191     hi <<= 64;
192 
193     require (hi <=
194       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
195     return hi + lo;
196   }
197 
198   /**
199    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
200    * zero.
201    *
202    * @param x signed 64.64-bit fixed point number
203    * @param y signed 64.64-bit fixed point number
204    * @return signed 64.64-bit fixed point number
205    */
206   function div (int128 x, int128 y) internal pure returns (int128) {
207     require (y != 0);
208     int256 result = (int256 (x) << 64) / y;
209     require (result >= MIN_64x64 && result <= MAX_64x64);
210     return int128 (result);
211   }
212 
213   /**
214    * Calculate x / y rounding towards zero, where x and y are signed 256-bit
215    * integer numbers.  Revert on overflow or when y is zero.
216    *
217    * @param x signed 256-bit integer number
218    * @param y signed 256-bit integer number
219    * @return signed 64.64-bit fixed point number
220    */
221   function divi (int256 x, int256 y) internal pure returns (int128) {
222     require (y != 0);
223 
224     bool negativeResult = false;
225     if (x < 0) {
226       x = -x; // We rely on overflow behavior here
227       negativeResult = true;
228     }
229     if (y < 0) {
230       y = -y; // We rely on overflow behavior here
231       negativeResult = !negativeResult;
232     }
233     uint128 absoluteResult = divuu (uint256 (x), uint256 (y));
234     if (negativeResult) {
235       require (absoluteResult <= 0x80000000000000000000000000000000);
236       return -int128 (absoluteResult); // We rely on overflow behavior here
237     } else {
238       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
239       return int128 (absoluteResult); // We rely on overflow behavior here
240     }
241   }
242 
243   /**
244    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
245    * integer numbers.  Revert on overflow or when y is zero.
246    *
247    * @param x unsigned 256-bit integer number
248    * @param y unsigned 256-bit integer number
249    * @return signed 64.64-bit fixed point number
250    */
251   function divu (uint256 x, uint256 y) internal pure returns (int128) {
252     require (y != 0);
253     uint128 result = divuu (x, y);
254     require (result <= uint128 (MAX_64x64));
255     return int128 (result);
256   }
257 
258   /**
259    * Calculate -x.  Revert on overflow.
260    *
261    * @param x signed 64.64-bit fixed point number
262    * @return signed 64.64-bit fixed point number
263    */
264   function neg (int128 x) internal pure returns (int128) {
265     require (x != MIN_64x64);
266     return -x;
267   }
268 
269   /**
270    * Calculate |x|.  Revert on overflow.
271    *
272    * @param x signed 64.64-bit fixed point number
273    * @return signed 64.64-bit fixed point number
274    */
275   function abs (int128 x) internal pure returns (int128) {
276     require (x != MIN_64x64);
277     return x < 0 ? -x : x;
278   }
279 
280   /**
281    * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
282    * zero.
283    *
284    * @param x signed 64.64-bit fixed point number
285    * @return signed 64.64-bit fixed point number
286    */
287   function inv (int128 x) internal pure returns (int128) {
288     require (x != 0);
289     int256 result = int256 (0x100000000000000000000000000000000) / x;
290     require (result >= MIN_64x64 && result <= MAX_64x64);
291     return int128 (result);
292   }
293 
294   /**
295    * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
296    *
297    * @param x signed 64.64-bit fixed point number
298    * @param y signed 64.64-bit fixed point number
299    * @return signed 64.64-bit fixed point number
300    */
301   function avg (int128 x, int128 y) internal pure returns (int128) {
302     return int128 ((int256 (x) + int256 (y)) >> 1);
303   }
304 
305   /**
306    * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
307    * Revert on overflow or in case x * y is negative.
308    *
309    * @param x signed 64.64-bit fixed point number
310    * @param y signed 64.64-bit fixed point number
311    * @return signed 64.64-bit fixed point number
312    */
313   function gavg (int128 x, int128 y) internal pure returns (int128) {
314     int256 m = int256 (x) * int256 (y);
315     require (m >= 0);
316     require (m <
317         0x4000000000000000000000000000000000000000000000000000000000000000);
318     return int128 (sqrtu (uint256 (m)));
319   }
320 
321   /**
322    * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
323    * and y is unsigned 256-bit integer number.  Revert on overflow.
324    *
325    * @param x signed 64.64-bit fixed point number
326    * @param y uint256 value
327    * @return signed 64.64-bit fixed point number
328    */
329   function pow (int128 x, uint256 y) internal pure returns (int128) {
330     uint256 absoluteResult;
331     bool negativeResult = false;
332     if (x >= 0) {
333       absoluteResult = powu (uint256 (x) << 63, y);
334     } else {
335       // We rely on overflow behavior here
336       absoluteResult = powu (uint256 (uint128 (-x)) << 63, y);
337       negativeResult = y & 1 > 0;
338     }
339 
340     absoluteResult >>= 63;
341 
342     if (negativeResult) {
343       require (absoluteResult <= 0x80000000000000000000000000000000);
344       return -int128 (absoluteResult); // We rely on overflow behavior here
345     } else {
346       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
347       return int128 (absoluteResult); // We rely on overflow behavior here
348     }
349   }
350 
351   /**
352    * Calculate sqrt (x) rounding down.  Revert if x < 0.
353    *
354    * @param x signed 64.64-bit fixed point number
355    * @return signed 64.64-bit fixed point number
356    */
357   function sqrt (int128 x) internal pure returns (int128) {
358     require (x >= 0);
359     return int128 (sqrtu (uint256 (x) << 64));
360   }
361 
362   /**
363    * Calculate binary logarithm of x.  Revert if x <= 0.
364    *
365    * @param x signed 64.64-bit fixed point number
366    * @return signed 64.64-bit fixed point number
367    */
368   function log_2 (int128 x) internal pure returns (int128) {
369     require (x > 0);
370 
371     int256 msb = 0;
372     int256 xc = x;
373     if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
374     if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
375     if (xc >= 0x10000) { xc >>= 16; msb += 16; }
376     if (xc >= 0x100) { xc >>= 8; msb += 8; }
377     if (xc >= 0x10) { xc >>= 4; msb += 4; }
378     if (xc >= 0x4) { xc >>= 2; msb += 2; }
379     if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
380 
381     int256 result = msb - 64 << 64;
382     uint256 ux = uint256 (x) << uint256 (127 - msb);
383     for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
384       ux *= ux;
385       uint256 b = ux >> 255;
386       ux >>= 127 + b;
387       result += bit * int256 (b);
388     }
389 
390     return int128 (result);
391   }
392 
393   /**
394    * Calculate natural logarithm of x.  Revert if x <= 0.
395    *
396    * @param x signed 64.64-bit fixed point number
397    * @return signed 64.64-bit fixed point number
398    */
399   function ln (int128 x) internal pure returns (int128) {
400     require (x > 0);
401 
402     return int128 (
403         uint256 (log_2 (x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF >> 128);
404   }
405 
406   /**
407    * Calculate binary exponent of x.  Revert on overflow.
408    *
409    * @param x signed 64.64-bit fixed point number
410    * @return signed 64.64-bit fixed point number
411    */
412   function exp_2 (int128 x) internal pure returns (int128) {
413     require (x < 0x400000000000000000); // Overflow
414 
415     if (x < -0x400000000000000000) return 0; // Underflow
416 
417     uint256 result = 0x80000000000000000000000000000000;
418 
419     if (x & 0x8000000000000000 > 0)
420       result = result * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
421     if (x & 0x4000000000000000 > 0)
422       result = result * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
423     if (x & 0x2000000000000000 > 0)
424       result = result * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
425     if (x & 0x1000000000000000 > 0)
426       result = result * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
427     if (x & 0x800000000000000 > 0)
428       result = result * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
429     if (x & 0x400000000000000 > 0)
430       result = result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
431     if (x & 0x200000000000000 > 0)
432       result = result * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
433     if (x & 0x100000000000000 > 0)
434       result = result * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
435     if (x & 0x80000000000000 > 0)
436       result = result * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
437     if (x & 0x40000000000000 > 0)
438       result = result * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
439     if (x & 0x20000000000000 > 0)
440       result = result * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
441     if (x & 0x10000000000000 > 0)
442       result = result * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
443     if (x & 0x8000000000000 > 0)
444       result = result * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
445     if (x & 0x4000000000000 > 0)
446       result = result * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
447     if (x & 0x2000000000000 > 0)
448       result = result * 0x1000162E525EE054754457D5995292026 >> 128;
449     if (x & 0x1000000000000 > 0)
450       result = result * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
451     if (x & 0x800000000000 > 0)
452       result = result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
453     if (x & 0x400000000000 > 0)
454       result = result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
455     if (x & 0x200000000000 > 0)
456       result = result * 0x10000162E43F4F831060E02D839A9D16D >> 128;
457     if (x & 0x100000000000 > 0)
458       result = result * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
459     if (x & 0x80000000000 > 0)
460       result = result * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
461     if (x & 0x40000000000 > 0)
462       result = result * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
463     if (x & 0x20000000000 > 0)
464       result = result * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
465     if (x & 0x10000000000 > 0)
466       result = result * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
467     if (x & 0x8000000000 > 0)
468       result = result * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
469     if (x & 0x4000000000 > 0)
470       result = result * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
471     if (x & 0x2000000000 > 0)
472       result = result * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
473     if (x & 0x1000000000 > 0)
474       result = result * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
475     if (x & 0x800000000 > 0)
476       result = result * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
477     if (x & 0x400000000 > 0)
478       result = result * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
479     if (x & 0x200000000 > 0)
480       result = result * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
481     if (x & 0x100000000 > 0)
482       result = result * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
483     if (x & 0x80000000 > 0)
484       result = result * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
485     if (x & 0x40000000 > 0)
486       result = result * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
487     if (x & 0x20000000 > 0)
488       result = result * 0x100000000162E42FEFB2FED257559BDAA >> 128;
489     if (x & 0x10000000 > 0)
490       result = result * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
491     if (x & 0x8000000 > 0)
492       result = result * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
493     if (x & 0x4000000 > 0)
494       result = result * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
495     if (x & 0x2000000 > 0)
496       result = result * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
497     if (x & 0x1000000 > 0)
498       result = result * 0x10000000000B17217F7D20CF927C8E94C >> 128;
499     if (x & 0x800000 > 0)
500       result = result * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
501     if (x & 0x400000 > 0)
502       result = result * 0x100000000002C5C85FDF477B662B26945 >> 128;
503     if (x & 0x200000 > 0)
504       result = result * 0x10000000000162E42FEFA3AE53369388C >> 128;
505     if (x & 0x100000 > 0)
506       result = result * 0x100000000000B17217F7D1D351A389D40 >> 128;
507     if (x & 0x80000 > 0)
508       result = result * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
509     if (x & 0x40000 > 0)
510       result = result * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
511     if (x & 0x20000 > 0)
512       result = result * 0x100000000000162E42FEFA39FE95583C2 >> 128;
513     if (x & 0x10000 > 0)
514       result = result * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
515     if (x & 0x8000 > 0)
516       result = result * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
517     if (x & 0x4000 > 0)
518       result = result * 0x10000000000002C5C85FDF473E242EA38 >> 128;
519     if (x & 0x2000 > 0)
520       result = result * 0x1000000000000162E42FEFA39F02B772C >> 128;
521     if (x & 0x1000 > 0)
522       result = result * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
523     if (x & 0x800 > 0)
524       result = result * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
525     if (x & 0x400 > 0)
526       result = result * 0x100000000000002C5C85FDF473DEA871F >> 128;
527     if (x & 0x200 > 0)
528       result = result * 0x10000000000000162E42FEFA39EF44D91 >> 128;
529     if (x & 0x100 > 0)
530       result = result * 0x100000000000000B17217F7D1CF79E949 >> 128;
531     if (x & 0x80 > 0)
532       result = result * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
533     if (x & 0x40 > 0)
534       result = result * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
535     if (x & 0x20 > 0)
536       result = result * 0x100000000000000162E42FEFA39EF366F >> 128;
537     if (x & 0x10 > 0)
538       result = result * 0x1000000000000000B17217F7D1CF79AFA >> 128;
539     if (x & 0x8 > 0)
540       result = result * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
541     if (x & 0x4 > 0)
542       result = result * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
543     if (x & 0x2 > 0)
544       result = result * 0x1000000000000000162E42FEFA39EF358 >> 128;
545     if (x & 0x1 > 0)
546       result = result * 0x10000000000000000B17217F7D1CF79AB >> 128;
547 
548     result >>= uint256 (63 - (x >> 64));
549     require (result <= uint256 (MAX_64x64));
550 
551     return int128 (result);
552   }
553 
554   /**
555    * Calculate natural exponent of x.  Revert on overflow.
556    *
557    * @param x signed 64.64-bit fixed point number
558    * @return signed 64.64-bit fixed point number
559    */
560   function exp (int128 x) internal pure returns (int128) {
561     require (x < 0x400000000000000000); // Overflow
562 
563     if (x < -0x400000000000000000) return 0; // Underflow
564 
565     return exp_2 (
566         int128 (int256 (x) * 0x171547652B82FE1777D0FFDA0D23A7D12 >> 128));
567   }
568 
569   /**
570    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
571    * integer numbers.  Revert on overflow or when y is zero.
572    *
573    * @param x unsigned 256-bit integer number
574    * @param y unsigned 256-bit integer number
575    * @return unsigned 64.64-bit fixed point number
576    */
577   function divuu (uint256 x, uint256 y) private pure returns (uint128) {
578     require (y != 0);
579 
580     uint256 result;
581 
582     if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
583       result = (x << 64) / y;
584     else {
585       uint256 msb = 192;
586       uint256 xc = x >> 192;
587       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
588       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
589       if (xc >= 0x100) { xc >>= 8; msb += 8; }
590       if (xc >= 0x10) { xc >>= 4; msb += 4; }
591       if (xc >= 0x4) { xc >>= 2; msb += 2; }
592       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
593 
594       result = (x << 255 - msb) / ((y - 1 >> msb - 191) + 1);
595       require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
596 
597       uint256 hi = result * (y >> 128);
598       uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
599 
600       uint256 xh = x >> 192;
601       uint256 xl = x << 64;
602 
603       if (xl < lo) xh -= 1;
604       xl -= lo; // We rely on overflow behavior here
605       lo = hi << 128;
606       if (xl < lo) xh -= 1;
607       xl -= lo; // We rely on overflow behavior here
608 
609       assert (xh == hi >> 128);
610 
611       result += xl / y;
612     }
613 
614     require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
615     return uint128 (result);
616   }
617 
618   /**
619    * Calculate x^y assuming 0^0 is 1, where x is unsigned 129.127 fixed point
620    * number and y is unsigned 256-bit integer number.  Revert on overflow.
621    *
622    * @param x unsigned 129.127-bit fixed point number
623    * @param y uint256 value
624    * @return unsigned 129.127-bit fixed point number
625    */
626   function powu (uint256 x, uint256 y) private pure returns (uint256) {
627     if (y == 0) return 0x80000000000000000000000000000000;
628     else if (x == 0) return 0;
629     else {
630       int256 msb = 0;
631       uint256 xc = x;
632       if (xc >= 0x100000000000000000000000000000000) { xc >>= 128; msb += 128; }
633       if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
634       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
635       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
636       if (xc >= 0x100) { xc >>= 8; msb += 8; }
637       if (xc >= 0x10) { xc >>= 4; msb += 4; }
638       if (xc >= 0x4) { xc >>= 2; msb += 2; }
639       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
640 
641       int256 xe = msb - 127;
642       if (xe > 0) x >>= uint256 (xe);
643       else x <<= uint256 (-xe);
644 
645       uint256 result = 0x80000000000000000000000000000000;
646       int256 re = 0;
647 
648       while (y > 0) {
649         if (y & 1 > 0) {
650           result = result * x;
651           y -= 1;
652           re += xe;
653           if (result >=
654             0x8000000000000000000000000000000000000000000000000000000000000000) {
655             result >>= 128;
656             re += 1;
657           } else result >>= 127;
658           if (re < -127) return 0; // Underflow
659           require (re < 128); // Overflow
660         } else {
661           x = x * x;
662           y >>= 1;
663           xe <<= 1;
664           if (x >=
665             0x8000000000000000000000000000000000000000000000000000000000000000) {
666             x >>= 128;
667             xe += 1;
668           } else x >>= 127;
669           if (xe < -127) return 0; // Underflow
670           require (xe < 128); // Overflow
671         }
672       }
673 
674       if (re > 0) result <<= uint256 (re);
675       else if (re < 0) result >>= uint256 (-re);
676 
677       return result;
678     }
679   }
680 
681   /**
682    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
683    * number.
684    *
685    * @param x unsigned 256-bit integer number
686    * @return unsigned 128-bit integer number
687    */
688   function sqrtu (uint256 x) private pure returns (uint128) {
689     if (x == 0) return 0;
690     else {
691       uint256 xx = x;
692       uint256 r = 1;
693       if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
694       if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
695       if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
696       if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
697       if (xx >= 0x100) { xx >>= 8; r <<= 4; }
698       if (xx >= 0x10) { xx >>= 4; r <<= 2; }
699       if (xx >= 0x8) { r <<= 1; }
700       r = (r + x / r) >> 1;
701       r = (r + x / r) >> 1;
702       r = (r + x / r) >> 1;
703       r = (r + x / r) >> 1;
704       r = (r + x / r) >> 1;
705       r = (r + x / r) >> 1;
706       r = (r + x / r) >> 1; // Seven iterations should be enough
707       uint256 r1 = x / r;
708       return uint128 (r < r1 ? r : r1);
709     }
710   }
711 }
712 
713 // Part: IOracle
714 
715 interface IOracle {
716     function getPrice() external view returns (uint256);
717 }
718 
719 // Part: Initializable
720 
721 /**
722  * @title Initializable
723  *
724  * @dev Helper contract to support initializer functions. To use it, replace
725  * the constructor with a function that has the `initializer` modifier.
726  * WARNING: Unlike constructors, initializer functions must be manually
727  * invoked. This applies both to deploying an Initializable contract, as well
728  * as extending an Initializable contract via inheritance.
729  * WARNING: When used with inheritance, manual care must be taken to not invoke
730  * a parent initializer twice, or ensure that all initializers are idempotent,
731  * because this is not dealt with automatically as with constructors.
732  */
733 contract Initializable {
734 
735   /**
736    * @dev Indicates that the contract has been initialized.
737    */
738   bool private initialized;
739 
740   /**
741    * @dev Indicates that the contract is in the process of being initialized.
742    */
743   bool private initializing;
744 
745   /**
746    * @dev Modifier to use in the initializer function of a contract.
747    */
748   modifier initializer() {
749     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
750 
751     bool isTopLevelCall = !initializing;
752     if (isTopLevelCall) {
753       initializing = true;
754       initialized = true;
755     }
756 
757     _;
758 
759     if (isTopLevelCall) {
760       initializing = false;
761     }
762   }
763 
764   /// @dev Returns true if and only if the function is running in the constructor
765   function isConstructor() private view returns (bool) {
766     // extcodesize checks the size of the code stored in an address, and
767     // address returns the current address. Since the code is still not
768     // deployed when running a constructor, any checks on its code size will
769     // yield zero, making it an effective way to detect if a contract is
770     // under construction or not.
771     address self = address(this);
772     uint256 cs;
773     assembly { cs := extcodesize(self) }
774     return cs == 0;
775   }
776 
777   // Reserved storage space to allow for layout changes in the future.
778   uint256[50] private ______gap;
779 }
780 
781 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
782 
783 /**
784  * @dev Collection of functions related to the address type
785  */
786 library Address {
787     /**
788      * @dev Returns true if `account` is a contract.
789      *
790      * [IMPORTANT]
791      * ====
792      * It is unsafe to assume that an address for which this function returns
793      * false is an externally-owned account (EOA) and not a contract.
794      *
795      * Among others, `isContract` will return false for the following
796      * types of addresses:
797      *
798      *  - an externally-owned account
799      *  - a contract in construction
800      *  - an address where a contract will be created
801      *  - an address where a contract lived, but was destroyed
802      * ====
803      */
804     function isContract(address account) internal view returns (bool) {
805         // This method relies in extcodesize, which returns 0 for contracts in
806         // construction, since the code is only stored at the end of the
807         // constructor execution.
808 
809         uint256 size;
810         // solhint-disable-next-line no-inline-assembly
811         assembly { size := extcodesize(account) }
812         return size > 0;
813     }
814 
815     /**
816      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
817      * `recipient`, forwarding all available gas and reverting on errors.
818      *
819      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
820      * of certain opcodes, possibly making contracts go over the 2300 gas limit
821      * imposed by `transfer`, making them unable to receive funds via
822      * `transfer`. {sendValue} removes this limitation.
823      *
824      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
825      *
826      * IMPORTANT: because control is transferred to `recipient`, care must be
827      * taken to not create reentrancy vulnerabilities. Consider using
828      * {ReentrancyGuard} or the
829      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
830      */
831     function sendValue(address payable recipient, uint256 amount) internal {
832         require(address(this).balance >= amount, "Address: insufficient balance");
833 
834         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
835         (bool success, ) = recipient.call{ value: amount }("");
836         require(success, "Address: unable to send value, recipient may have reverted");
837     }
838 
839     /**
840      * @dev Performs a Solidity function call using a low level `call`. A
841      * plain`call` is an unsafe replacement for a function call: use this
842      * function instead.
843      *
844      * If `target` reverts with a revert reason, it is bubbled up by this
845      * function (like regular Solidity function calls).
846      *
847      * Returns the raw returned data. To convert to the expected return value,
848      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
849      *
850      * Requirements:
851      *
852      * - `target` must be a contract.
853      * - calling `target` with `data` must not revert.
854      *
855      * _Available since v3.1._
856      */
857     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
858       return functionCall(target, data, "Address: low-level call failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
863      * `errorMessage` as a fallback revert reason when `target` reverts.
864      *
865      * _Available since v3.1._
866      */
867     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
868         return _functionCallWithValue(target, data, 0, errorMessage);
869     }
870 
871     /**
872      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
873      * but also transferring `value` wei to `target`.
874      *
875      * Requirements:
876      *
877      * - the calling contract must have an ETH balance of at least `value`.
878      * - the called Solidity function must be `payable`.
879      *
880      * _Available since v3.1._
881      */
882     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
883         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
888      * with `errorMessage` as a fallback revert reason when `target` reverts.
889      *
890      * _Available since v3.1._
891      */
892     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
893         require(address(this).balance >= value, "Address: insufficient balance for call");
894         return _functionCallWithValue(target, data, value, errorMessage);
895     }
896 
897     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
898         require(isContract(target), "Address: call to non-contract");
899 
900         // solhint-disable-next-line avoid-low-level-calls
901         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
902         if (success) {
903             return returndata;
904         } else {
905             // Look for revert reason and bubble it up if present
906             if (returndata.length > 0) {
907                 // The easiest way to bubble the revert reason is using memory via assembly
908 
909                 // solhint-disable-next-line no-inline-assembly
910                 assembly {
911                     let returndata_size := mload(returndata)
912                     revert(add(32, returndata), returndata_size)
913                 }
914             } else {
915                 revert(errorMessage);
916             }
917         }
918     }
919 }
920 
921 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
922 
923 /**
924  * @dev Interface of the ERC20 standard as defined in the EIP.
925  */
926 interface IERC20 {
927     /**
928      * @dev Returns the amount of tokens in existence.
929      */
930     function totalSupply() external view returns (uint256);
931 
932     /**
933      * @dev Returns the amount of tokens owned by `account`.
934      */
935     function balanceOf(address account) external view returns (uint256);
936 
937     /**
938      * @dev Moves `amount` tokens from the caller's account to `recipient`.
939      *
940      * Returns a boolean value indicating whether the operation succeeded.
941      *
942      * Emits a {Transfer} event.
943      */
944     function transfer(address recipient, uint256 amount) external returns (bool);
945 
946     /**
947      * @dev Returns the remaining number of tokens that `spender` will be
948      * allowed to spend on behalf of `owner` through {transferFrom}. This is
949      * zero by default.
950      *
951      * This value changes when {approve} or {transferFrom} are called.
952      */
953     function allowance(address owner, address spender) external view returns (uint256);
954 
955     /**
956      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
957      *
958      * Returns a boolean value indicating whether the operation succeeded.
959      *
960      * IMPORTANT: Beware that changing an allowance with this method brings the risk
961      * that someone may use both the old and the new allowance by unfortunate
962      * transaction ordering. One possible solution to mitigate this race
963      * condition is to first reduce the spender's allowance to 0 and set the
964      * desired value afterwards:
965      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
966      *
967      * Emits an {Approval} event.
968      */
969     function approve(address spender, uint256 amount) external returns (bool);
970 
971     /**
972      * @dev Moves `amount` tokens from `sender` to `recipient` using the
973      * allowance mechanism. `amount` is then deducted from the caller's
974      * allowance.
975      *
976      * Returns a boolean value indicating whether the operation succeeded.
977      *
978      * Emits a {Transfer} event.
979      */
980     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
981 
982     /**
983      * @dev Emitted when `value` tokens are moved from one account (`from`) to
984      * another (`to`).
985      *
986      * Note that `value` may be zero.
987      */
988     event Transfer(address indexed from, address indexed to, uint256 value);
989 
990     /**
991      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
992      * a call to {approve}. `value` is the new allowance.
993      */
994     event Approval(address indexed owner, address indexed spender, uint256 value);
995 }
996 
997 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Math
998 
999 /**
1000  * @dev Standard math utilities missing in the Solidity language.
1001  */
1002 library Math {
1003     /**
1004      * @dev Returns the largest of two numbers.
1005      */
1006     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1007         return a >= b ? a : b;
1008     }
1009 
1010     /**
1011      * @dev Returns the smallest of two numbers.
1012      */
1013     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1014         return a < b ? a : b;
1015     }
1016 
1017     /**
1018      * @dev Returns the average of two numbers. The result is rounded towards
1019      * zero.
1020      */
1021     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1022         // (a + b) / 2 can overflow, so we distribute
1023         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1024     }
1025 }
1026 
1027 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
1028 
1029 /**
1030  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1031  * checks.
1032  *
1033  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1034  * in bugs, because programmers usually assume that an overflow raises an
1035  * error, which is the standard behavior in high level programming languages.
1036  * `SafeMath` restores this intuition by reverting the transaction when an
1037  * operation overflows.
1038  *
1039  * Using this library instead of the unchecked operations eliminates an entire
1040  * class of bugs, so it's recommended to use it always.
1041  */
1042 library SafeMath {
1043     /**
1044      * @dev Returns the addition of two unsigned integers, reverting on
1045      * overflow.
1046      *
1047      * Counterpart to Solidity's `+` operator.
1048      *
1049      * Requirements:
1050      *
1051      * - Addition cannot overflow.
1052      */
1053     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1054         uint256 c = a + b;
1055         require(c >= a, "SafeMath: addition overflow");
1056 
1057         return c;
1058     }
1059 
1060     /**
1061      * @dev Returns the subtraction of two unsigned integers, reverting on
1062      * overflow (when the result is negative).
1063      *
1064      * Counterpart to Solidity's `-` operator.
1065      *
1066      * Requirements:
1067      *
1068      * - Subtraction cannot overflow.
1069      */
1070     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1071         return sub(a, b, "SafeMath: subtraction overflow");
1072     }
1073 
1074     /**
1075      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1076      * overflow (when the result is negative).
1077      *
1078      * Counterpart to Solidity's `-` operator.
1079      *
1080      * Requirements:
1081      *
1082      * - Subtraction cannot overflow.
1083      */
1084     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1085         require(b <= a, errorMessage);
1086         uint256 c = a - b;
1087 
1088         return c;
1089     }
1090 
1091     /**
1092      * @dev Returns the multiplication of two unsigned integers, reverting on
1093      * overflow.
1094      *
1095      * Counterpart to Solidity's `*` operator.
1096      *
1097      * Requirements:
1098      *
1099      * - Multiplication cannot overflow.
1100      */
1101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1103         // benefit is lost if 'b' is also tested.
1104         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1105         if (a == 0) {
1106             return 0;
1107         }
1108 
1109         uint256 c = a * b;
1110         require(c / a == b, "SafeMath: multiplication overflow");
1111 
1112         return c;
1113     }
1114 
1115     /**
1116      * @dev Returns the integer division of two unsigned integers. Reverts on
1117      * division by zero. The result is rounded towards zero.
1118      *
1119      * Counterpart to Solidity's `/` operator. Note: this function uses a
1120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1121      * uses an invalid opcode to revert (consuming all remaining gas).
1122      *
1123      * Requirements:
1124      *
1125      * - The divisor cannot be zero.
1126      */
1127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1128         return div(a, b, "SafeMath: division by zero");
1129     }
1130 
1131     /**
1132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1133      * division by zero. The result is rounded towards zero.
1134      *
1135      * Counterpart to Solidity's `/` operator. Note: this function uses a
1136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1137      * uses an invalid opcode to revert (consuming all remaining gas).
1138      *
1139      * Requirements:
1140      *
1141      * - The divisor cannot be zero.
1142      */
1143     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1144         require(b > 0, errorMessage);
1145         uint256 c = a / b;
1146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1147 
1148         return c;
1149     }
1150 
1151     /**
1152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1153      * Reverts when dividing by zero.
1154      *
1155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1156      * opcode (which leaves remaining gas untouched) while Solidity uses an
1157      * invalid opcode to revert (consuming all remaining gas).
1158      *
1159      * Requirements:
1160      *
1161      * - The divisor cannot be zero.
1162      */
1163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1164         return mod(a, b, "SafeMath: modulo by zero");
1165     }
1166 
1167     /**
1168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1169      * Reverts with custom message when dividing by zero.
1170      *
1171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1172      * opcode (which leaves remaining gas untouched) while Solidity uses an
1173      * invalid opcode to revert (consuming all remaining gas).
1174      *
1175      * Requirements:
1176      *
1177      * - The divisor cannot be zero.
1178      */
1179     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1180         require(b != 0, errorMessage);
1181         return a % b;
1182     }
1183 }
1184 
1185 // Part: ContextUpgradeSafe
1186 
1187 /*
1188  * @dev Provides information about the current execution context, including the
1189  * sender of the transaction and its data. While these are generally available
1190  * via msg.sender and msg.data, they should not be accessed in such a direct
1191  * manner, since when dealing with GSN meta-transactions the account sending and
1192  * paying for execution may not be the actual sender (as far as an application
1193  * is concerned).
1194  *
1195  * This contract is only required for intermediate, library-like contracts.
1196  */
1197 contract ContextUpgradeSafe is Initializable {
1198     // Empty internal constructor, to prevent people from mistakenly deploying
1199     // an instance of this contract, which should be used via inheritance.
1200 
1201     function __Context_init() internal initializer {
1202         __Context_init_unchained();
1203     }
1204 
1205     function __Context_init_unchained() internal initializer {
1206 
1207 
1208     }
1209 
1210 
1211     function _msgSender() internal view virtual returns (address payable) {
1212         return msg.sender;
1213     }
1214 
1215     function _msgData() internal view virtual returns (bytes memory) {
1216         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1217         return msg.data;
1218     }
1219 
1220     uint256[50] private __gap;
1221 }
1222 
1223 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeERC20
1224 
1225 /**
1226  * @title SafeERC20
1227  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1228  * contract returns false). Tokens that return no value (and instead revert or
1229  * throw on failure) are also supported, non-reverting calls are assumed to be
1230  * successful.
1231  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1232  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1233  */
1234 library SafeERC20 {
1235     using SafeMath for uint256;
1236     using Address for address;
1237 
1238     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1239         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1240     }
1241 
1242     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1243         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1244     }
1245 
1246     /**
1247      * @dev Deprecated. This function has issues similar to the ones found in
1248      * {IERC20-approve}, and its usage is discouraged.
1249      *
1250      * Whenever possible, use {safeIncreaseAllowance} and
1251      * {safeDecreaseAllowance} instead.
1252      */
1253     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1254         // safeApprove should only be called when setting an initial allowance,
1255         // or when resetting it to zero. To increase and decrease it, use
1256         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1257         // solhint-disable-next-line max-line-length
1258         require((value == 0) || (token.allowance(address(this), spender) == 0),
1259             "SafeERC20: approve from non-zero to non-zero allowance"
1260         );
1261         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1262     }
1263 
1264     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1265         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1266         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1267     }
1268 
1269     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1270         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1271         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1272     }
1273 
1274     /**
1275      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1276      * on the return value: the return value is optional (but if data is returned, it must not be false).
1277      * @param token The token targeted by the call.
1278      * @param data The call data (encoded using abi.encode or one of its variants).
1279      */
1280     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1281         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1282         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1283         // the target address contains contract code and also asserts for success in the low-level call.
1284 
1285         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1286         if (returndata.length > 0) { // Return data is optional
1287             // solhint-disable-next-line max-line-length
1288             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1289         }
1290     }
1291 }
1292 
1293 // Part: OptionMath
1294 
1295 library OptionMath {
1296     using SafeMath for uint256;
1297 
1298     uint256 public constant SCALE = 1e18;
1299 
1300     /**
1301      * Converts total supplies of options into the tokenized payoff quantities used
1302      * by the LMSR
1303      *
1304      * For puts, multiply by strike price since option quantity is in terms of the
1305      * underlying, but lmsr quantities should be in terms of the strike currency
1306      */
1307     function calcQuantities(
1308         uint256[] memory strikePrices,
1309         bool isPut,
1310         uint256[] memory longSupplies,
1311         uint256[] memory shortSupplies
1312     ) internal pure returns (uint256[] memory) {
1313         uint256 n = strikePrices.length;
1314         require(longSupplies.length == n, "Lengths do not match");
1315         require(shortSupplies.length == n, "Lengths do not match");
1316 
1317         // this mutates the method arguments, but costs less gas
1318         if (isPut) {
1319             for (uint256 i = 0; i < n; i++) {
1320                 longSupplies[i] = longSupplies[i].mul(strikePrices[i]).div(SCALE);
1321                 shortSupplies[i] = shortSupplies[i].mul(strikePrices[i]).div(SCALE);
1322             }
1323         }
1324 
1325         // swap shortSupplies and longSupplies for puts
1326         uint256[] memory leftSupplies = isPut ? shortSupplies : longSupplies;
1327         uint256[] memory rightSupplies = isPut ? longSupplies : shortSupplies;
1328 
1329         uint256[] memory quantities = new uint256[](n + 1);
1330 
1331         // set quantities[0] = sum(rightSupplies)
1332         for (uint256 i = 0; i < n; i++) {
1333             quantities[0] = quantities[0].add(rightSupplies[i]);
1334         }
1335 
1336         // set quantities[i] = leftSupplies[:i] + rightSupplies[i:]
1337         for (uint256 i = 0; i < n; i++) {
1338             quantities[i + 1] = quantities[i].add(leftSupplies[i]).sub(rightSupplies[i]);
1339         }
1340         return quantities;
1341     }
1342 
1343     /**
1344      * Calculates the LMSR cost function
1345      *
1346      *   C(q_1, ..., q_n) = b * log(exp(q_1 / b) + ... + exp(q_n / b))
1347      *
1348      * where
1349      *
1350      *   q_i = total supply of ith tokenized payoff
1351      *   b = liquidity parameter
1352      *
1353      * An equivalent expression for C is used to avoid overflow when calculating exponentials
1354      *
1355      *   C(q_1, ..., q_n) = m + b * log(exp((q_1 - m) / b) + ... + exp((q_n - m) / b))
1356      *
1357      * where
1358      *
1359      *   m = max(q_1, ..., q_n)
1360      */
1361     function calcLmsrCost(uint256[] memory quantities, uint256 b) internal pure returns (uint256) {
1362         uint256 maxQuantity = quantities[0];
1363         for (uint256 i = 1; i < quantities.length; i++) {
1364             maxQuantity = Math.max(maxQuantity, quantities[i]);
1365         }
1366 
1367         // cost converges to max(q) as b tends to 0
1368         if (b == 0) {
1369             return maxQuantity;
1370         }
1371 
1372         int128 sumExp;
1373         for (uint256 i = 0; i < quantities.length; i++) {
1374             // max(q) - q_i
1375             uint256 diff = maxQuantity.sub(quantities[i]);
1376 
1377             // (max(q) - q_i) / b
1378             int128 div = ABDKMath64x64.divu(diff, b);
1379 
1380             // exp((q_i - max(q)) / b)
1381             int128 exp = ABDKMath64x64.exp(ABDKMath64x64.neg(div));
1382             sumExp = ABDKMath64x64.add(sumExp, exp);
1383         }
1384 
1385         // log(sumExp)
1386         int128 log = ABDKMath64x64.ln(sumExp);
1387 
1388         // b * log(sumExp) + max(q)
1389         return ABDKMath64x64.mulu(log, b).add(maxQuantity);
1390     }
1391 
1392     /**
1393      * Calculate total payoff of all outstanding options
1394      *
1395      * This value will decrease as options are redeemed
1396      *
1397      * For calls, divide by expiry price since payoff should be in terms of the
1398      * `baseToken`
1399      */
1400     function calcPayoff(
1401         uint256[] memory strikePrices,
1402         uint256 expiryPrice,
1403         bool isPut,
1404         uint256[] memory longSupplies,
1405         uint256[] memory shortSupplies
1406     ) internal pure returns (uint256) {
1407         require(longSupplies.length == strikePrices.length, "Lengths do not match");
1408         require(shortSupplies.length == strikePrices.length, "Lengths do not match");
1409 
1410         if (expiryPrice == 0) {
1411             return 0;
1412         }
1413 
1414         uint256 payoff;
1415         for (uint256 i = 0; i < strikePrices.length; i++) {
1416             uint256 strikePrice = strikePrices[i];
1417 
1418             if (isPut && expiryPrice < strikePrice) {
1419                 // put payoff = max(K - S, 0)
1420                 payoff = payoff.add(longSupplies[i].mul(strikePrice.sub(expiryPrice)));
1421             } else if (!isPut && expiryPrice > strikePrice) {
1422                 // call payoff = max(S - K, 0)
1423                 payoff = payoff.add(longSupplies[i].mul(expiryPrice.sub(strikePrice)));
1424             }
1425 
1426             // short payoff = min(S, K)
1427             payoff = payoff.add(shortSupplies[i].mul(Math.min(expiryPrice, strikePrice)));
1428         }
1429         return payoff.div(isPut ? SCALE : expiryPrice);
1430     }
1431 }
1432 
1433 // Part: ReentrancyGuardUpgradeSafe
1434 
1435 /**
1436  * @dev Contract module that helps prevent reentrant calls to a function.
1437  *
1438  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1439  * available, which can be applied to functions to make sure there are no nested
1440  * (reentrant) calls to them.
1441  *
1442  * Note that because there is a single `nonReentrant` guard, functions marked as
1443  * `nonReentrant` may not call one another. This can be worked around by making
1444  * those functions `private`, and then adding `external` `nonReentrant` entry
1445  * points to them.
1446  *
1447  * TIP: If you would like to learn more about reentrancy and alternative ways
1448  * to protect against it, check out our blog post
1449  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1450  */
1451 contract ReentrancyGuardUpgradeSafe is Initializable {
1452     bool private _notEntered;
1453 
1454 
1455     function __ReentrancyGuard_init() internal initializer {
1456         __ReentrancyGuard_init_unchained();
1457     }
1458 
1459     function __ReentrancyGuard_init_unchained() internal initializer {
1460 
1461 
1462         // Storing an initial non-zero value makes deployment a bit more
1463         // expensive, but in exchange the refund on every call to nonReentrant
1464         // will be lower in amount. Since refunds are capped to a percetange of
1465         // the total transaction's gas, it is best to keep them low in cases
1466         // like this one, to increase the likelihood of the full refund coming
1467         // into effect.
1468         _notEntered = true;
1469 
1470     }
1471 
1472 
1473     /**
1474      * @dev Prevents a contract from calling itself, directly or indirectly.
1475      * Calling a `nonReentrant` function from another `nonReentrant`
1476      * function is not supported. It is possible to prevent this from happening
1477      * by making the `nonReentrant` function external, and make it call a
1478      * `private` function that does the actual work.
1479      */
1480     modifier nonReentrant() {
1481         // On the first call to nonReentrant, _notEntered will be true
1482         require(_notEntered, "ReentrancyGuard: reentrant call");
1483 
1484         // Any calls to nonReentrant after this point will fail
1485         _notEntered = false;
1486 
1487         _;
1488 
1489         // By storing the original value once again, a refund is triggered (see
1490         // https://eips.ethereum.org/EIPS/eip-2200)
1491         _notEntered = true;
1492     }
1493 
1494     uint256[49] private __gap;
1495 }
1496 
1497 // Part: ERC20UpgradeSafe
1498 
1499 /**
1500  * @dev Implementation of the {IERC20} interface.
1501  *
1502  * This implementation is agnostic to the way tokens are created. This means
1503  * that a supply mechanism has to be added in a derived contract using {_mint}.
1504  * For a generic mechanism see {ERC20MinterPauser}.
1505  *
1506  * TIP: For a detailed writeup see our guide
1507  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1508  * to implement supply mechanisms].
1509  *
1510  * We have followed general OpenZeppelin guidelines: functions revert instead
1511  * of returning `false` on failure. This behavior is nonetheless conventional
1512  * and does not conflict with the expectations of ERC20 applications.
1513  *
1514  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1515  * This allows applications to reconstruct the allowance for all accounts just
1516  * by listening to said events. Other implementations of the EIP may not emit
1517  * these events, as it isn't required by the specification.
1518  *
1519  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1520  * functions have been added to mitigate the well-known issues around setting
1521  * allowances. See {IERC20-approve}.
1522  */
1523 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
1524     using SafeMath for uint256;
1525     using Address for address;
1526 
1527     mapping (address => uint256) private _balances;
1528 
1529     mapping (address => mapping (address => uint256)) private _allowances;
1530 
1531     uint256 private _totalSupply;
1532 
1533     string private _name;
1534     string private _symbol;
1535     uint8 private _decimals;
1536 
1537     /**
1538      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1539      * a default value of 18.
1540      *
1541      * To select a different value for {decimals}, use {_setupDecimals}.
1542      *
1543      * All three of these values are immutable: they can only be set once during
1544      * construction.
1545      */
1546 
1547     function __ERC20_init(string memory name, string memory symbol) internal initializer {
1548         __Context_init_unchained();
1549         __ERC20_init_unchained(name, symbol);
1550     }
1551 
1552     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
1553 
1554 
1555         _name = name;
1556         _symbol = symbol;
1557         _decimals = 18;
1558 
1559     }
1560 
1561 
1562     /**
1563      * @dev Returns the name of the token.
1564      */
1565     function name() public view returns (string memory) {
1566         return _name;
1567     }
1568 
1569     /**
1570      * @dev Returns the symbol of the token, usually a shorter version of the
1571      * name.
1572      */
1573     function symbol() public view returns (string memory) {
1574         return _symbol;
1575     }
1576 
1577     /**
1578      * @dev Returns the number of decimals used to get its user representation.
1579      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1580      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1581      *
1582      * Tokens usually opt for a value of 18, imitating the relationship between
1583      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1584      * called.
1585      *
1586      * NOTE: This information is only used for _display_ purposes: it in
1587      * no way affects any of the arithmetic of the contract, including
1588      * {IERC20-balanceOf} and {IERC20-transfer}.
1589      */
1590     function decimals() public view returns (uint8) {
1591         return _decimals;
1592     }
1593 
1594     /**
1595      * @dev See {IERC20-totalSupply}.
1596      */
1597     function totalSupply() public view override returns (uint256) {
1598         return _totalSupply;
1599     }
1600 
1601     /**
1602      * @dev See {IERC20-balanceOf}.
1603      */
1604     function balanceOf(address account) public view override returns (uint256) {
1605         return _balances[account];
1606     }
1607 
1608     /**
1609      * @dev See {IERC20-transfer}.
1610      *
1611      * Requirements:
1612      *
1613      * - `recipient` cannot be the zero address.
1614      * - the caller must have a balance of at least `amount`.
1615      */
1616     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1617         _transfer(_msgSender(), recipient, amount);
1618         return true;
1619     }
1620 
1621     /**
1622      * @dev See {IERC20-allowance}.
1623      */
1624     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1625         return _allowances[owner][spender];
1626     }
1627 
1628     /**
1629      * @dev See {IERC20-approve}.
1630      *
1631      * Requirements:
1632      *
1633      * - `spender` cannot be the zero address.
1634      */
1635     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1636         _approve(_msgSender(), spender, amount);
1637         return true;
1638     }
1639 
1640     /**
1641      * @dev See {IERC20-transferFrom}.
1642      *
1643      * Emits an {Approval} event indicating the updated allowance. This is not
1644      * required by the EIP. See the note at the beginning of {ERC20};
1645      *
1646      * Requirements:
1647      * - `sender` and `recipient` cannot be the zero address.
1648      * - `sender` must have a balance of at least `amount`.
1649      * - the caller must have allowance for ``sender``'s tokens of at least
1650      * `amount`.
1651      */
1652     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1653         _transfer(sender, recipient, amount);
1654         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1655         return true;
1656     }
1657 
1658     /**
1659      * @dev Atomically increases the allowance granted to `spender` by the caller.
1660      *
1661      * This is an alternative to {approve} that can be used as a mitigation for
1662      * problems described in {IERC20-approve}.
1663      *
1664      * Emits an {Approval} event indicating the updated allowance.
1665      *
1666      * Requirements:
1667      *
1668      * - `spender` cannot be the zero address.
1669      */
1670     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1671         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1672         return true;
1673     }
1674 
1675     /**
1676      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1677      *
1678      * This is an alternative to {approve} that can be used as a mitigation for
1679      * problems described in {IERC20-approve}.
1680      *
1681      * Emits an {Approval} event indicating the updated allowance.
1682      *
1683      * Requirements:
1684      *
1685      * - `spender` cannot be the zero address.
1686      * - `spender` must have allowance for the caller of at least
1687      * `subtractedValue`.
1688      */
1689     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1690         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1691         return true;
1692     }
1693 
1694     /**
1695      * @dev Moves tokens `amount` from `sender` to `recipient`.
1696      *
1697      * This is internal function is equivalent to {transfer}, and can be used to
1698      * e.g. implement automatic token fees, slashing mechanisms, etc.
1699      *
1700      * Emits a {Transfer} event.
1701      *
1702      * Requirements:
1703      *
1704      * - `sender` cannot be the zero address.
1705      * - `recipient` cannot be the zero address.
1706      * - `sender` must have a balance of at least `amount`.
1707      */
1708     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1709         require(sender != address(0), "ERC20: transfer from the zero address");
1710         require(recipient != address(0), "ERC20: transfer to the zero address");
1711 
1712         _beforeTokenTransfer(sender, recipient, amount);
1713 
1714         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1715         _balances[recipient] = _balances[recipient].add(amount);
1716         emit Transfer(sender, recipient, amount);
1717     }
1718 
1719     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1720      * the total supply.
1721      *
1722      * Emits a {Transfer} event with `from` set to the zero address.
1723      *
1724      * Requirements
1725      *
1726      * - `to` cannot be the zero address.
1727      */
1728     function _mint(address account, uint256 amount) internal virtual {
1729         require(account != address(0), "ERC20: mint to the zero address");
1730 
1731         _beforeTokenTransfer(address(0), account, amount);
1732 
1733         _totalSupply = _totalSupply.add(amount);
1734         _balances[account] = _balances[account].add(amount);
1735         emit Transfer(address(0), account, amount);
1736     }
1737 
1738     /**
1739      * @dev Destroys `amount` tokens from `account`, reducing the
1740      * total supply.
1741      *
1742      * Emits a {Transfer} event with `to` set to the zero address.
1743      *
1744      * Requirements
1745      *
1746      * - `account` cannot be the zero address.
1747      * - `account` must have at least `amount` tokens.
1748      */
1749     function _burn(address account, uint256 amount) internal virtual {
1750         require(account != address(0), "ERC20: burn from the zero address");
1751 
1752         _beforeTokenTransfer(account, address(0), amount);
1753 
1754         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1755         _totalSupply = _totalSupply.sub(amount);
1756         emit Transfer(account, address(0), amount);
1757     }
1758 
1759     /**
1760      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1761      *
1762      * This is internal function is equivalent to `approve`, and can be used to
1763      * e.g. set automatic allowances for certain subsystems, etc.
1764      *
1765      * Emits an {Approval} event.
1766      *
1767      * Requirements:
1768      *
1769      * - `owner` cannot be the zero address.
1770      * - `spender` cannot be the zero address.
1771      */
1772     function _approve(address owner, address spender, uint256 amount) internal virtual {
1773         require(owner != address(0), "ERC20: approve from the zero address");
1774         require(spender != address(0), "ERC20: approve to the zero address");
1775 
1776         _allowances[owner][spender] = amount;
1777         emit Approval(owner, spender, amount);
1778     }
1779 
1780     /**
1781      * @dev Sets {decimals} to a value other than the default one of 18.
1782      *
1783      * WARNING: This function should only be called from the constructor. Most
1784      * applications that interact with token contracts will not expect
1785      * {decimals} to ever change, and may work incorrectly if it does.
1786      */
1787     function _setupDecimals(uint8 decimals_) internal {
1788         _decimals = decimals_;
1789     }
1790 
1791     /**
1792      * @dev Hook that is called before any transfer of tokens. This includes
1793      * minting and burning.
1794      *
1795      * Calling conditions:
1796      *
1797      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1798      * will be to transferred to `to`.
1799      * - when `from` is zero, `amount` tokens will be minted for `to`.
1800      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1801      * - `from` and `to` are never both zero.
1802      *
1803      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1804      */
1805     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1806 
1807     uint256[44] private __gap;
1808 }
1809 
1810 // Part: OwnableUpgradeSafe
1811 
1812 /**
1813  * @dev Contract module which provides a basic access control mechanism, where
1814  * there is an account (an owner) that can be granted exclusive access to
1815  * specific functions.
1816  *
1817  * By default, the owner account will be the one that deploys the contract. This
1818  * can later be changed with {transferOwnership}.
1819  *
1820  * This module is used through inheritance. It will make available the modifier
1821  * `onlyOwner`, which can be applied to your functions to restrict their use to
1822  * the owner.
1823  */
1824 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
1825     address private _owner;
1826 
1827     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1828 
1829     /**
1830      * @dev Initializes the contract setting the deployer as the initial owner.
1831      */
1832 
1833     function __Ownable_init() internal initializer {
1834         __Context_init_unchained();
1835         __Ownable_init_unchained();
1836     }
1837 
1838     function __Ownable_init_unchained() internal initializer {
1839 
1840 
1841         address msgSender = _msgSender();
1842         _owner = msgSender;
1843         emit OwnershipTransferred(address(0), msgSender);
1844 
1845     }
1846 
1847 
1848     /**
1849      * @dev Returns the address of the current owner.
1850      */
1851     function owner() public view returns (address) {
1852         return _owner;
1853     }
1854 
1855     /**
1856      * @dev Throws if called by any account other than the owner.
1857      */
1858     modifier onlyOwner() {
1859         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1860         _;
1861     }
1862 
1863     /**
1864      * @dev Leaves the contract without owner. It will not be possible to call
1865      * `onlyOwner` functions anymore. Can only be called by the current owner.
1866      *
1867      * NOTE: Renouncing ownership will leave the contract without an owner,
1868      * thereby removing any functionality that is only available to the owner.
1869      */
1870     function renounceOwnership() public virtual onlyOwner {
1871         emit OwnershipTransferred(_owner, address(0));
1872         _owner = address(0);
1873     }
1874 
1875     /**
1876      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1877      * Can only be called by the current owner.
1878      */
1879     function transferOwnership(address newOwner) public virtual onlyOwner {
1880         require(newOwner != address(0), "Ownable: new owner is the zero address");
1881         emit OwnershipTransferred(_owner, newOwner);
1882         _owner = newOwner;
1883     }
1884 
1885     uint256[49] private __gap;
1886 }
1887 
1888 // Part: UniERC20
1889 
1890 library UniERC20 {
1891     using SafeMath for uint256;
1892     using SafeERC20 for IERC20;
1893 
1894     function isETH(IERC20 token) internal pure returns (bool) {
1895         return (address(token) == address(0));
1896     }
1897 
1898     function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
1899         if (isETH(token)) {
1900             return account.balance;
1901         } else {
1902             return token.balanceOf(account);
1903         }
1904     }
1905 
1906     function uniTransfer(
1907         IERC20 token,
1908         address payable to,
1909         uint256 amount
1910     ) internal {
1911         if (amount > 0) {
1912             if (isETH(token)) {
1913                 (bool success, ) = to.call{value: amount}("");
1914                 require(success, "Transfer failed");
1915             } else {
1916                 token.safeTransfer(to, amount);
1917             }
1918         }
1919     }
1920 
1921     function uniTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
1922         if (amount > 0) {
1923             if (isETH(token)) {
1924                 require(msg.value >= amount, "UniERC20: not enough value");
1925                 if (msg.value > amount) {
1926                     // Return remainder if exist
1927                     uint256 refundAmount = msg.value.sub(amount);
1928                     (bool success, ) = msg.sender.call{value: refundAmount}("");
1929                     require(success, "Transfer failed");
1930                 }
1931             } else {
1932                 token.safeTransferFrom(msg.sender, address(this), amount);
1933             }
1934         }
1935     }
1936 
1937     function uniSymbol(IERC20 token) internal view returns (string memory) {
1938         if (isETH(token)) {
1939             return "ETH";
1940         }
1941 
1942         (bool success, bytes memory data) = address(token).staticcall{gas: 20000}(abi.encodeWithSignature("symbol()"));
1943         if (!success) {
1944             (success, data) = address(token).staticcall{gas: 20000}(abi.encodeWithSignature("SYMBOL()"));
1945         }
1946 
1947         if (success && data.length >= 96) {
1948             (uint256 offset, uint256 len) = abi.decode(data, (uint256, uint256));
1949             if (offset == 0x20 && len > 0 && len <= 256) {
1950                 return string(abi.decode(data, (bytes)));
1951             }
1952         }
1953 
1954         if (success && data.length == 32) {
1955             uint256 len = 0;
1956             while (len < data.length && data[len] >= 0x20 && data[len] <= 0x7E) {
1957                 len++;
1958             }
1959 
1960             if (len > 0) {
1961                 bytes memory result = new bytes(len);
1962                 for (uint256 i = 0; i < len; i++) {
1963                     result[i] = data[i];
1964                 }
1965                 return string(result);
1966             }
1967         }
1968 
1969         return _toHex(address(token));
1970     }
1971 
1972     function _toHex(address account) private pure returns (string memory) {
1973         return _toHex(abi.encodePacked(account));
1974     }
1975 
1976     function _toHex(bytes memory data) private pure returns (string memory) {
1977         bytes memory str = new bytes(2 + data.length * 2);
1978         str[0] = "0";
1979         str[1] = "x";
1980         uint256 j = 2;
1981         for (uint256 i = 0; i < data.length; i++) {
1982             uint256 a = uint8(data[i]) >> 4;
1983             uint256 b = uint8(data[i]) & 0x0f;
1984             str[j++] = bytes1(uint8(a + 48 + (a / 10) * 39));
1985             str[j++] = bytes1(uint8(b + 48 + (b / 10) * 39));
1986         }
1987 
1988         return string(str);
1989     }
1990 }
1991 
1992 // Part: OptionToken
1993 
1994 /**
1995  * ERC20 token representing a long or short option position. It is intended to be
1996  * used by `OptionMarket`, which mints/burns these tokens when users buy/sell options
1997  *
1998  * Note that `decimals` should match the decimals of the `baseToken` in `OptionMarket`
1999  */
2000 contract OptionToken is ERC20UpgradeSafe {
2001     using Address for address;
2002     using SafeERC20 for IERC20;
2003     using SafeMath for uint256;
2004 
2005     address public market;
2006 
2007     function initialize(
2008         address _market,
2009         string memory name,
2010         string memory symbol,
2011         uint8 decimals
2012     ) public initializer {
2013         __ERC20_init(name, symbol);
2014         _setupDecimals(decimals);
2015         market = _market;
2016     }
2017 
2018     function mint(address account, uint256 amount) external {
2019         require(msg.sender == market, "!market");
2020         _mint(account, amount);
2021     }
2022 
2023     function burn(address account, uint256 amount) external {
2024         require(msg.sender == market, "!market");
2025         _burn(account, amount);
2026     }
2027 }
2028 
2029 // File: OptionMarket.sol
2030 
2031 /**
2032  * Automated market-maker for options
2033  *
2034  * This contract allows an asset to be split up into tokenized payoffs such that
2035  * different combinations of payoffs sum up to different call/put option payoffs.
2036  * An LMSR (Hanson's market-maker) is used to provide liquidity for the tokenized
2037  * payoffs.
2038  *
2039  * The parameter `b` in the LMSR represents the market depth. `b` is increased when
2040  * users provide liquidity by depositing funds and it is decreased when they withdraw
2041  * liquidity. Trading fees are distributed proportionally to liquidity providers
2042  * at the time of the trade.
2043  *
2044  * Call and put option with any of the supported strikes are provided. Short options
2045  * (equivalent to owning 1 underlying + sell 1 option) are provided, which let users
2046  * take on short option exposure
2047  *
2048  * `buy`, `sell`, `deposit` and `withdraw` are the main methods used to interact with
2049  * this contract.
2050  *
2051  * After expiration, `settle` can be called to fetch the expiry price from a
2052  * price oracle. `buy` and `deposit` cannot be called after expiration, but `sell`
2053  * can be called to redeem options for their corresponding payouts and `withdraw`
2054  * can be called to redeem LP tokens for a stake of the remaining funds left
2055  * in the contract.
2056  *
2057  * Methods to calculate the LMSR cost and option payoffs can be found in `OptionMath`.
2058  * `OptionToken` is an ERC20 token representing a long or short option position
2059  * that's minted or burned when users buy or sell options.
2060  *
2061  * This contract is also an ERC20 token itself representing shares in the liquidity
2062  * pool.
2063  *
2064  * The intended way to deploy this contract is to call `createMarket` in `OptionFactory`
2065  * Then liquidity has to be provided using `deposit` before trades can occur.
2066  *
2067  * Please note that the deployer of this contract is highly privileged and has
2068  * permissions such as withdrawing all funds from the contract, being able to pause
2069  * trading, modify the market parameters and override the settlement price. These
2070  * permissions will be removed in future versions.
2071  */
2072 contract OptionMarket is ERC20UpgradeSafe, ReentrancyGuardUpgradeSafe, OwnableUpgradeSafe {
2073     using Address for address;
2074     using SafeERC20 for IERC20;
2075     using UniERC20 for IERC20;
2076     using SafeMath for uint256;
2077 
2078     event Buy(
2079         address indexed account,
2080         bool isLongToken,
2081         uint256 strikeIndex,
2082         uint256 optionsOut,
2083         uint256 amountIn,
2084         uint256 newSupply
2085     );
2086 
2087     event Sell(
2088         address indexed account,
2089         bool isLongToken,
2090         uint256 strikeIndex,
2091         uint256 optionsIn,
2092         uint256 amountOut,
2093         uint256 newSupply,
2094         bool isSettled
2095     );
2096 
2097     event Deposit(address indexed account, uint256 sharesOut, uint256 amountIn, uint256 newSupply);
2098     event Withdraw(address indexed account, uint256 sharesIn, uint256 amountOut, uint256 newSupply, bool isSettled);
2099     event Settle(uint256 expiryPrice);
2100 
2101     uint256 public constant SCALE = 1e18;
2102     uint256 public constant SCALE_SCALE = 1e36;
2103 
2104     IERC20 public baseToken;
2105     IOracle public oracle;
2106     OptionToken[] public longTokens;
2107     OptionToken[] public shortTokens;
2108     uint256[] public strikePrices;
2109     uint256 public expiryTime;
2110     bool public isPut;
2111     uint256 public tradingFee;
2112     uint256 public balanceCap;
2113     uint256 public totalSupplyCap;
2114     uint256 public disputePeriod;
2115 
2116     bool public isPaused;
2117     bool public isSettled;
2118     uint256 public expiryPrice;
2119 
2120     // cache getCurrentCost and getCurrentPayoff between trades to save gas
2121     uint256 public lastCost;
2122     uint256 public lastPayoff;
2123 
2124     // total value of fees owed to LPs
2125     uint256 public poolValue;
2126 
2127     /**
2128      * @param _baseToken        Underlying asset if call. Strike currency if put
2129      *                          Represents ETH if equal to 0x0
2130      * @param _oracle           Oracle from which settlement price is obtained
2131      * @param _longTokens       Tokens representing long calls/puts
2132      * @param _shortTokens      Tokens representing short calls/puts
2133      * @param _strikePrices     Strike prices expressed in wei. Must be in increasing order
2134      * @param _expiryTime       Expiration time as a unix timestamp
2135      * @param _isPut            Whether this market provides calls or puts
2136      * @param _tradingFee       Trading fee as fraction of underlying expressed in wei
2137      * @param _symbol           Name and symbol of LP tokens
2138      */
2139     function initialize(
2140         address _baseToken,
2141         address _oracle,
2142         address[] memory _longTokens,
2143         address[] memory _shortTokens,
2144         uint256[] memory _strikePrices,
2145         uint256 _expiryTime,
2146         bool _isPut,
2147         uint256 _tradingFee,
2148         string memory _symbol
2149     ) public payable initializer {
2150         // this contract is also an ERC20 token, representing shares in the liquidity pool
2151         __ERC20_init(_symbol, _symbol);
2152         __ReentrancyGuard_init();
2153         __Ownable_init();
2154 
2155         // use same decimals as base token
2156         uint8 decimals = IERC20(_baseToken).isETH() ? 18 : ERC20UpgradeSafe(_baseToken).decimals();
2157         _setupDecimals(decimals);
2158 
2159         require(_longTokens.length == _strikePrices.length, "Lengths do not match");
2160         require(_shortTokens.length == _strikePrices.length, "Lengths do not match");
2161 
2162         require(_strikePrices.length > 0, "Strike prices must not be empty");
2163         require(_strikePrices[0] > 0, "Strike prices must be > 0");
2164 
2165         // check strike prices are increasing
2166         for (uint256 i = 0; i < _strikePrices.length - 1; i++) {
2167             require(_strikePrices[i] < _strikePrices[i + 1], "Strike prices must be increasing");
2168         }
2169 
2170         // check trading fee is less than 100%
2171         // note trading fee can be 0
2172         require(_tradingFee < SCALE, "Trading fee must be < 1");
2173 
2174         baseToken = IERC20(_baseToken);
2175         oracle = IOracle(_oracle);
2176         strikePrices = _strikePrices;
2177         expiryTime = _expiryTime;
2178         isPut = _isPut;
2179         tradingFee = _tradingFee;
2180 
2181         for (uint256 i = 0; i < _strikePrices.length; i++) {
2182             longTokens.push(OptionToken(_longTokens[i]));
2183             shortTokens.push(OptionToken(_shortTokens[i]));
2184         }
2185 
2186         require(!isExpired(), "Already expired");
2187     }
2188 
2189     /**
2190      * Buy options
2191      *
2192      * The option bought is specified by `isLongToken` and `strikeIndex` and the
2193      * amount by `optionsOut`
2194      *
2195      * This method reverts if the resulting cost is greater than `maxAmountIn`
2196      */
2197     function buy(
2198         bool isLongToken,
2199         uint256 strikeIndex,
2200         uint256 optionsOut,
2201         uint256 maxAmountIn
2202     ) external payable nonReentrant returns (uint256 amountIn) {
2203         require(totalSupply() > 0, "No liquidity");
2204         require(!isExpired(), "Already expired");
2205         require(msg.sender == owner() || !isPaused, "Paused");
2206         require(strikeIndex < strikePrices.length, "Index too large");
2207         require(optionsOut > 0, "Options out must be > 0");
2208 
2209         // mint options to user
2210         OptionToken option = isLongToken ? longTokens[strikeIndex] : shortTokens[strikeIndex];
2211         option.mint(msg.sender, optionsOut);
2212 
2213         // calculate trading fee and allocate it to the LP pool
2214         // like LMSR cost, fees have to be multiplied by strike price
2215         uint256 fee = optionsOut.mul(tradingFee);
2216         fee = isPut ? fee.mul(strikePrices[strikeIndex]).div(SCALE_SCALE) : fee.div(SCALE);
2217         poolValue = poolValue.add(fee);
2218 
2219         // calculate amount that needs to be paid by user to buy these options
2220         // it's equal to the increase in LMSR cost after minting the options
2221         uint256 costAfter = getCurrentCost();
2222         amountIn = costAfter.sub(lastCost).add(fee); // do sub first as a check since should not fail
2223         lastCost = costAfter;
2224         require(amountIn > 0, "Amount in must be > 0");
2225         require(amountIn <= maxAmountIn, "Max slippage exceeded");
2226 
2227         // transfer in amount from user
2228         _transferIn(amountIn);
2229         emit Buy(msg.sender, isLongToken, strikeIndex, optionsOut, amountIn, option.totalSupply());
2230     }
2231 
2232     /**
2233      * Sell options
2234      *
2235      * The option sold is specified by `isLongToken` and `strikeIndex` and the
2236      * amount by `optionsIn`
2237      *
2238      * This method reverts if the resulting amount returned is less than `minAmountOut`
2239      */
2240     function sell(
2241         bool isLongToken,
2242         uint256 strikeIndex,
2243         uint256 optionsIn,
2244         uint256 minAmountOut
2245     ) external nonReentrant returns (uint256 amountOut) {
2246         require(!isExpired() || isSettled, "Must be called before expiry or after settlement");
2247         require(!isDisputePeriod(), "Dispute period");
2248         require(msg.sender == owner() || !isPaused, "Paused");
2249         require(strikeIndex < strikePrices.length, "Index too large");
2250         require(optionsIn > 0, "Options in must be > 0");
2251 
2252         // burn user's options
2253         OptionToken option = isLongToken ? longTokens[strikeIndex] : shortTokens[strikeIndex];
2254         option.burn(msg.sender, optionsIn);
2255 
2256         // calculate amount that needs to be returned to user
2257         if (isSettled) {
2258             // if after settlement, amount is the option payoff
2259             uint256 payoffAfter = getCurrentPayoff();
2260             amountOut = lastPayoff.sub(payoffAfter);
2261             lastPayoff = payoffAfter;
2262         } else {
2263             // if before expiry, amount is the decrease in LMSR cost after burning the options
2264             uint256 costAfter = getCurrentCost();
2265             amountOut = lastCost.sub(costAfter);
2266             lastCost = costAfter;
2267         }
2268         require(amountOut > 0, "Amount out must be > 0");
2269         require(amountOut >= minAmountOut, "Max slippage exceeded");
2270 
2271         // transfer amount to user
2272         baseToken.uniTransfer(msg.sender, amountOut);
2273         emit Sell(msg.sender, isLongToken, strikeIndex, optionsIn, amountOut, option.totalSupply(), isSettled);
2274     }
2275 
2276     /**
2277      * Deposit liquidity
2278      *
2279      * `sharesOut` is the intended increase in the parameter `b`
2280      *
2281      * This method reverts if the resulting cost is greater than `maxAmountIn`
2282      */
2283     function deposit(uint256 sharesOut, uint256 maxAmountIn) external payable nonReentrant returns (uint256 amountIn) {
2284         require(!isExpired(), "Already expired");
2285         require(msg.sender == owner() || !isPaused, "Paused");
2286         require(sharesOut > 0, "Shares out must be > 0");
2287 
2288         // user needs to contribute proportional amount of fees to pool, which
2289         // ensures they are only earning fees generated after they have deposited
2290         if (totalSupply() > 0) {
2291             // add 1 to round up
2292             amountIn = poolValue.mul(sharesOut).div(totalSupply()).add(1);
2293             poolValue = poolValue.add(amountIn);
2294         }
2295         _mint(msg.sender, sharesOut);
2296         require(totalSupplyCap == 0 || totalSupply() <= totalSupplyCap, "Total supply cap exceeded");
2297 
2298         // need to add increase in LMSR cost after increasing b
2299         uint256 costAfter = getCurrentCost();
2300         amountIn = costAfter.sub(lastCost).add(amountIn); // do sub first as a check since should not fail
2301         lastCost = costAfter;
2302         require(amountIn > 0, "Amount in must be > 0");
2303         require(amountIn <= maxAmountIn, "Max slippage exceeded");
2304 
2305         // transfer in amount from user
2306         _transferIn(amountIn);
2307         emit Deposit(msg.sender, sharesOut, amountIn, totalSupply());
2308     }
2309 
2310     /**
2311      * Withdraw liquidity
2312      *
2313      * `sharesIn` is the intended decrease in the parameter `b`
2314      *
2315      * This method reverts if the resulting amount returned is less than `minAmountOut`
2316      */
2317     function withdraw(uint256 sharesIn, uint256 minAmountOut) external nonReentrant returns (uint256 amountOut) {
2318         require(!isExpired() || isSettled, "Must be called before expiry or after settlement");
2319         require(!isDisputePeriod(), "Dispute period");
2320         require(msg.sender == owner() || !isPaused, "Paused");
2321         require(sharesIn > 0, "Shares in must be > 0");
2322 
2323         // calculate cut of fees earned by user
2324         amountOut = poolValue.mul(sharesIn).div(totalSupply());
2325         poolValue = poolValue.sub(amountOut);
2326         _burn(msg.sender, sharesIn);
2327 
2328         // if before expiry, add decrease in LMSR cost after decreasing b
2329         if (!isSettled) {
2330             uint256 costAfter = getCurrentCost();
2331             amountOut = lastCost.sub(costAfter).add(amountOut); // do sub first as a check since should not fail
2332             lastCost = costAfter;
2333         }
2334         require(amountOut > 0, "Amount out must be > 0");
2335         require(amountOut >= minAmountOut, "Max slippage exceeded");
2336 
2337         // return amount to user
2338         baseToken.uniTransfer(msg.sender, amountOut);
2339         emit Withdraw(msg.sender, sharesIn, amountOut, totalSupply(), isSettled);
2340     }
2341 
2342     /**
2343      * Retrieve and store the underlying price from the oracle
2344      *
2345      * This method can be called by anyone after expiration but cannot be called
2346      * more than once. In practice it should be called as soon as possible after the
2347      * expiration time.
2348      */
2349     function settle() external nonReentrant {
2350         require(isExpired(), "Cannot be called before expiry");
2351         require(!isSettled, "Already settled");
2352 
2353         // fetch expiry price from oracle
2354         isSettled = true;
2355         expiryPrice = oracle.getPrice();
2356         require(expiryPrice > 0, "Price from oracle must be > 0");
2357 
2358         // update cached payoff and pool value
2359         lastPayoff = getCurrentPayoff();
2360         poolValue = baseToken.uniBalanceOf(address(this)).sub(lastPayoff);
2361         emit Settle(expiryPrice);
2362     }
2363 
2364     /**
2365      * Calculate LMSR cost
2366      *
2367      * Represents total amount locked in the LMSR
2368      *
2369      * This value will increase as options are bought and decrease as options
2370      * are sold. The change in value corresponds to the total cost of a purchase
2371      * or the amount returned from a sale.
2372      *
2373      * This method is only used before expiry. Before expiry, the `baseToken`
2374      * balance of this contract is always at least current cost + pool value.
2375      * Current cost is maximum possible amount that needs to be paid out to
2376      * option holders. Pool value is the fees earned by LPs.
2377      */
2378     function getCurrentCost() public view returns (uint256) {
2379         uint256[] memory longSupplies = getTotalSupplies(longTokens);
2380         uint256[] memory shortSupplies = getTotalSupplies(shortTokens);
2381         uint256[] memory quantities = OptionMath.calcQuantities(strikePrices, isPut, longSupplies, shortSupplies);
2382         return OptionMath.calcLmsrCost(quantities, totalSupply());
2383     }
2384 
2385     /**
2386      * Calculate option payoff
2387      *
2388      * Represents total payoff to option holders
2389      *
2390      * This value will decrease as options are redeemed. The change in value
2391      * corresponds to the payoff returned from a redemption.
2392      *
2393      * This method is only used after expiry. After expiry, the `baseToken` balance
2394      * of this contract is always at least current payoff + pool value. Current
2395      * payoff is the amount owed to option holders and pool value is the amount
2396      * owed to LPs.
2397      */
2398     function getCurrentPayoff() public view returns (uint256) {
2399         uint256[] memory longSupplies = getTotalSupplies(longTokens);
2400         uint256[] memory shortSupplies = getTotalSupplies(shortTokens);
2401         return OptionMath.calcPayoff(strikePrices, expiryPrice, isPut, longSupplies, shortSupplies);
2402     }
2403 
2404     function getTotalSupplies(OptionToken[] memory optionTokens) public view returns (uint256[] memory totalSupplies) {
2405         totalSupplies = new uint256[](optionTokens.length);
2406         for (uint256 i = 0; i < optionTokens.length; i++) {
2407             totalSupplies[i] = optionTokens[i].totalSupply();
2408         }
2409     }
2410 
2411     function isExpired() public view returns (bool) {
2412         return block.timestamp >= expiryTime;
2413     }
2414 
2415     function isDisputePeriod() public view returns (bool) {
2416         return block.timestamp >= expiryTime && block.timestamp < expiryTime.add(disputePeriod);
2417     }
2418 
2419     function numStrikes() external view returns (uint256) {
2420         return strikePrices.length;
2421     }
2422 
2423     /**
2424      * Transfer amount from sender and do additional checks
2425      */
2426     function _transferIn(uint256 amountIn) private {
2427         // save gas
2428         IERC20 _baseToken = baseToken;
2429         uint256 balanceBefore = _baseToken.uniBalanceOf(address(this));
2430         _baseToken.uniTransferFromSenderToThis(amountIn);
2431         uint256 balanceAfter = _baseToken.uniBalanceOf(address(this));
2432         require(_baseToken.isETH() || balanceAfter.sub(balanceBefore) == amountIn, "Deflationary tokens not supported");
2433         require(balanceCap == 0 || _baseToken.uniBalanceOf(address(this)) <= balanceCap, "Balance cap exceeded");
2434     }
2435 
2436     // used for guarded launch
2437     function setBalanceCap(uint256 _balanceCap) external onlyOwner {
2438         balanceCap = _balanceCap;
2439     }
2440 
2441     // used for guarded launch
2442     function setTotalSupplyCap(uint256 _totalSupplyCap) external onlyOwner {
2443         totalSupplyCap = _totalSupplyCap;
2444     }
2445 
2446     // emergency use only. to be removed in future versions
2447     function pause() external onlyOwner {
2448         isPaused = true;
2449     }
2450 
2451     // emergency use only. to be removed in future versions
2452     function unpause() external onlyOwner {
2453         isPaused = false;
2454     }
2455 
2456     // emergency use only. to be removed in future versions
2457     function setOracle(IOracle _oracle) external onlyOwner {
2458         oracle = _oracle;
2459     }
2460 
2461     // emergency use only. to be removed in future versions
2462     function setExpiryTime(uint256 _expiryTime) external onlyOwner {
2463         expiryTime = _expiryTime;
2464     }
2465 
2466     // emergency use only. to be removed in future versions
2467     function setDisputePeriod(uint256 _disputePeriod) external onlyOwner {
2468         disputePeriod = _disputePeriod;
2469     }
2470 
2471     // emergency use only. to be removed in future versions
2472     function disputeExpiryPrice(uint256 _expiryPrice) external onlyOwner {
2473         require(isDisputePeriod(), "Not dispute period");
2474         require(isSettled, "Cannot be called before settlement");
2475         expiryPrice = _expiryPrice;
2476 
2477         // update cached payoff and pool value
2478         lastPayoff = getCurrentPayoff();
2479         poolValue = baseToken.uniBalanceOf(address(this)).sub(lastPayoff);
2480         emit Settle(_expiryPrice);
2481     }
2482 
2483     // emergency use only. to be removed in future versions
2484     function emergencyWithdraw() external onlyOwner {
2485         baseToken.uniTransfer(msg.sender, baseToken.uniBalanceOf(address(this)));
2486     }
2487 }
