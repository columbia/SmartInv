1 // SPDX-License-Identifier: BSD-4-Clause
2 /*
3  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 pragma solidity ^0.7.0;
7 
8 /**
9  * Smart contract library of mathematical functions operating with signed
10  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
11  * basically a simple fraction whose numerator is signed 128-bit integer and
12  * denominator is 2^64.  As long as denominator is always the same, there is no
13  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
14  * represented by int128 type holding only the numerator.
15  */
16 library ABDKMath64x64 {
17   /*
18    * Minimum value signed 64.64-bit fixed point number may have. 
19    */
20   int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
21 
22   /*
23    * Maximum value signed 64.64-bit fixed point number may have. 
24    */
25   int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
26 
27   /**
28    * Convert signed 256-bit integer number into signed 64.64-bit fixed point
29    * number.  Revert on overflow.
30    *
31    * @param x signed 256-bit integer number
32    * @return signed 64.64-bit fixed point number
33    */
34   function fromInt (int256 x) internal pure returns (int128) {
35     require (x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
36     return int128 (x << 64);
37   }
38 
39   /**
40    * Convert signed 64.64 fixed point number into signed 64-bit integer number
41    * rounding down.
42    *
43    * @param x signed 64.64-bit fixed point number
44    * @return signed 64-bit integer number
45    */
46   function toInt (int128 x) internal pure returns (int64) {
47     return int64 (x >> 64);
48   }
49 
50   /**
51    * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
52    * number.  Revert on overflow.
53    *
54    * @param x unsigned 256-bit integer number
55    * @return signed 64.64-bit fixed point number
56    */
57   function fromUInt (uint256 x) internal pure returns (int128) {
58     require (x <= 0x7FFFFFFFFFFFFFFF);
59     return int128 (x << 64);
60   }
61 
62   /**
63    * Convert signed 64.64 fixed point number into unsigned 64-bit integer
64    * number rounding down.  Revert on underflow.
65    *
66    * @param x signed 64.64-bit fixed point number
67    * @return unsigned 64-bit integer number
68    */
69   function toUInt (int128 x) internal pure returns (uint64) {
70     require (x >= 0);
71     return uint64 (x >> 64);
72   }
73 
74   /**
75    * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
76    * number rounding down.  Revert on overflow.
77    *
78    * @param x signed 128.128-bin fixed point number
79    * @return signed 64.64-bit fixed point number
80    */
81   function from128x128 (int256 x) internal pure returns (int128) {
82     int256 result = x >> 64;
83     require (result >= MIN_64x64 && result <= MAX_64x64);
84     return int128 (result);
85   }
86 
87   /**
88    * Convert signed 64.64 fixed point number into signed 128.128 fixed point
89    * number.
90    *
91    * @param x signed 64.64-bit fixed point number
92    * @return signed 128.128 fixed point number
93    */
94   function to128x128 (int128 x) internal pure returns (int256) {
95     return int256 (x) << 64;
96   }
97 
98   /**
99    * Calculate x + y.  Revert on overflow.
100    *
101    * @param x signed 64.64-bit fixed point number
102    * @param y signed 64.64-bit fixed point number
103    * @return signed 64.64-bit fixed point number
104    */
105   function add (int128 x, int128 y) internal pure returns (int128) {
106     int256 result = int256(x) + y;
107     require (result >= MIN_64x64 && result <= MAX_64x64);
108     return int128 (result);
109   }
110 
111   /**
112    * Calculate x - y.  Revert on overflow.
113    *
114    * @param x signed 64.64-bit fixed point number
115    * @param y signed 64.64-bit fixed point number
116    * @return signed 64.64-bit fixed point number
117    */
118   function sub (int128 x, int128 y) internal pure returns (int128) {
119     int256 result = int256(x) - y;
120     require (result >= MIN_64x64 && result <= MAX_64x64);
121     return int128 (result);
122   }
123 
124   /**
125    * Calculate x * y rounding down.  Revert on overflow.
126    *
127    * @param x signed 64.64-bit fixed point number
128    * @param y signed 64.64-bit fixed point number
129    * @return signed 64.64-bit fixed point number
130    */
131   function mul (int128 x, int128 y) internal pure returns (int128) {
132     int256 result = int256(x) * y >> 64;
133     require (result >= MIN_64x64 && result <= MAX_64x64);
134     return int128 (result);
135   }
136 
137   /**
138    * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
139    * number and y is signed 256-bit integer number.  Revert on overflow.
140    *
141    * @param x signed 64.64 fixed point number
142    * @param y signed 256-bit integer number
143    * @return signed 256-bit integer number
144    */
145   function muli (int128 x, int256 y) internal pure returns (int256) {
146     if (x == MIN_64x64) {
147       require (y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
148         y <= 0x1000000000000000000000000000000000000000000000000);
149       return -y << 63;
150     } else {
151       bool negativeResult = false;
152       if (x < 0) {
153         x = -x;
154         negativeResult = true;
155       }
156       if (y < 0) {
157         y = -y; // We rely on overflow behavior here
158         negativeResult = !negativeResult;
159       }
160       uint256 absoluteResult = mulu (x, uint256 (y));
161       if (negativeResult) {
162         require (absoluteResult <=
163           0x8000000000000000000000000000000000000000000000000000000000000000);
164         return -int256 (absoluteResult); // We rely on overflow behavior here
165       } else {
166         require (absoluteResult <=
167           0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
168         return int256 (absoluteResult);
169       }
170     }
171   }
172 
173   /**
174    * Calculate x * y rounding down, where x is signed 64.64 fixed point number
175    * and y is unsigned 256-bit integer number.  Revert on overflow.
176    *
177    * @param x signed 64.64 fixed point number
178    * @param y unsigned 256-bit integer number
179    * @return unsigned 256-bit integer number
180    */
181   function mulu (int128 x, uint256 y) internal pure returns (uint256) {
182     if (y == 0) return 0;
183 
184     require (x >= 0);
185 
186     uint256 lo = (uint256 (x) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
187     uint256 hi = uint256 (x) * (y >> 128);
188 
189     require (hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
190     hi <<= 64;
191 
192     require (hi <=
193       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
194     return hi + lo;
195   }
196 
197   /**
198    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
199    * zero.
200    *
201    * @param x signed 64.64-bit fixed point number
202    * @param y signed 64.64-bit fixed point number
203    * @return signed 64.64-bit fixed point number
204    */
205   function div (int128 x, int128 y) internal pure returns (int128) {
206     require (y != 0);
207     int256 result = (int256 (x) << 64) / y;
208     require (result >= MIN_64x64 && result <= MAX_64x64);
209     return int128 (result);
210   }
211 
212   /**
213    * Calculate x / y rounding towards zero, where x and y are signed 256-bit
214    * integer numbers.  Revert on overflow or when y is zero.
215    *
216    * @param x signed 256-bit integer number
217    * @param y signed 256-bit integer number
218    * @return signed 64.64-bit fixed point number
219    */
220   function divi (int256 x, int256 y) internal pure returns (int128) {
221     require (y != 0);
222 
223     bool negativeResult = false;
224     if (x < 0) {
225       x = -x; // We rely on overflow behavior here
226       negativeResult = true;
227     }
228     if (y < 0) {
229       y = -y; // We rely on overflow behavior here
230       negativeResult = !negativeResult;
231     }
232     uint128 absoluteResult = divuu (uint256 (x), uint256 (y));
233     if (negativeResult) {
234       require (absoluteResult <= 0x80000000000000000000000000000000);
235       return -int128 (absoluteResult); // We rely on overflow behavior here
236     } else {
237       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
238       return int128 (absoluteResult); // We rely on overflow behavior here
239     }
240   }
241 
242   /**
243    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
244    * integer numbers.  Revert on overflow or when y is zero.
245    *
246    * @param x unsigned 256-bit integer number
247    * @param y unsigned 256-bit integer number
248    * @return signed 64.64-bit fixed point number
249    */
250   function divu (uint256 x, uint256 y) internal pure returns (int128) {
251     require (y != 0);
252     uint128 result = divuu (x, y);
253     require (result <= uint128 (MAX_64x64));
254     return int128 (result);
255   }
256 
257   /**
258    * Calculate -x.  Revert on overflow.
259    *
260    * @param x signed 64.64-bit fixed point number
261    * @return signed 64.64-bit fixed point number
262    */
263   function neg (int128 x) internal pure returns (int128) {
264     require (x != MIN_64x64);
265     return -x;
266   }
267 
268   /**
269    * Calculate |x|.  Revert on overflow.
270    *
271    * @param x signed 64.64-bit fixed point number
272    * @return signed 64.64-bit fixed point number
273    */
274   function abs (int128 x) internal pure returns (int128) {
275     require (x != MIN_64x64);
276     return x < 0 ? -x : x;
277   }
278 
279   /**
280    * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
281    * zero.
282    *
283    * @param x signed 64.64-bit fixed point number
284    * @return signed 64.64-bit fixed point number
285    */
286   function inv (int128 x) internal pure returns (int128) {
287     require (x != 0);
288     int256 result = int256 (0x100000000000000000000000000000000) / x;
289     require (result >= MIN_64x64 && result <= MAX_64x64);
290     return int128 (result);
291   }
292 
293   /**
294    * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
295    *
296    * @param x signed 64.64-bit fixed point number
297    * @param y signed 64.64-bit fixed point number
298    * @return signed 64.64-bit fixed point number
299    */
300   function avg (int128 x, int128 y) internal pure returns (int128) {
301     return int128 ((int256 (x) + int256 (y)) >> 1);
302   }
303 
304   /**
305    * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
306    * Revert on overflow or in case x * y is negative.
307    *
308    * @param x signed 64.64-bit fixed point number
309    * @param y signed 64.64-bit fixed point number
310    * @return signed 64.64-bit fixed point number
311    */
312   function gavg (int128 x, int128 y) internal pure returns (int128) {
313     int256 m = int256 (x) * int256 (y);
314     require (m >= 0);
315     require (m <
316         0x4000000000000000000000000000000000000000000000000000000000000000);
317     return int128 (sqrtu (uint256 (m)));
318   }
319 
320   /**
321    * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
322    * and y is unsigned 256-bit integer number.  Revert on overflow.
323    *
324    * @param x signed 64.64-bit fixed point number
325    * @param y uint256 value
326    * @return signed 64.64-bit fixed point number
327    */
328   function pow (int128 x, uint256 y) internal pure returns (int128) {
329     uint256 absoluteResult;
330     bool negativeResult = false;
331     if (x >= 0) {
332       absoluteResult = powu (uint256 (x) << 63, y);
333     } else {
334       // We rely on overflow behavior here
335       absoluteResult = powu (uint256 (uint128 (-x)) << 63, y);
336       negativeResult = y & 1 > 0;
337     }
338 
339     absoluteResult >>= 63;
340 
341     if (negativeResult) {
342       require (absoluteResult <= 0x80000000000000000000000000000000);
343       return -int128 (absoluteResult); // We rely on overflow behavior here
344     } else {
345       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
346       return int128 (absoluteResult); // We rely on overflow behavior here
347     }
348   }
349 
350   /**
351    * Calculate sqrt (x) rounding down.  Revert if x < 0.
352    *
353    * @param x signed 64.64-bit fixed point number
354    * @return signed 64.64-bit fixed point number
355    */
356   function sqrt (int128 x) internal pure returns (int128) {
357     require (x >= 0);
358     return int128 (sqrtu (uint256 (x) << 64));
359   }
360 
361   /**
362    * Calculate binary logarithm of x.  Revert if x <= 0.
363    *
364    * @param x signed 64.64-bit fixed point number
365    * @return signed 64.64-bit fixed point number
366    */
367   function log_2 (int128 x) internal pure returns (int128) {
368     require (x > 0);
369 
370     int256 msb = 0;
371     int256 xc = x;
372     if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
373     if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
374     if (xc >= 0x10000) { xc >>= 16; msb += 16; }
375     if (xc >= 0x100) { xc >>= 8; msb += 8; }
376     if (xc >= 0x10) { xc >>= 4; msb += 4; }
377     if (xc >= 0x4) { xc >>= 2; msb += 2; }
378     if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
379 
380     int256 result = msb - 64 << 64;
381     uint256 ux = uint256 (x) << uint256 (127 - msb);
382     for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
383       ux *= ux;
384       uint256 b = ux >> 255;
385       ux >>= 127 + b;
386       result += bit * int256 (b);
387     }
388 
389     return int128 (result);
390   }
391 
392   /**
393    * Calculate natural logarithm of x.  Revert if x <= 0.
394    *
395    * @param x signed 64.64-bit fixed point number
396    * @return signed 64.64-bit fixed point number
397    */
398   function ln (int128 x) internal pure returns (int128) {
399     require (x > 0);
400 
401     return int128 (
402         uint256 (log_2 (x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF >> 128);
403   }
404 
405   /**
406    * Calculate binary exponent of x.  Revert on overflow.
407    *
408    * @param x signed 64.64-bit fixed point number
409    * @return signed 64.64-bit fixed point number
410    */
411   function exp_2 (int128 x) internal pure returns (int128) {
412     require (x < 0x400000000000000000); // Overflow
413 
414     if (x < -0x400000000000000000) return 0; // Underflow
415 
416     uint256 result = 0x80000000000000000000000000000000;
417 
418     if (x & 0x8000000000000000 > 0)
419       result = result * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
420     if (x & 0x4000000000000000 > 0)
421       result = result * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
422     if (x & 0x2000000000000000 > 0)
423       result = result * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
424     if (x & 0x1000000000000000 > 0)
425       result = result * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
426     if (x & 0x800000000000000 > 0)
427       result = result * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
428     if (x & 0x400000000000000 > 0)
429       result = result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
430     if (x & 0x200000000000000 > 0)
431       result = result * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
432     if (x & 0x100000000000000 > 0)
433       result = result * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
434     if (x & 0x80000000000000 > 0)
435       result = result * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
436     if (x & 0x40000000000000 > 0)
437       result = result * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
438     if (x & 0x20000000000000 > 0)
439       result = result * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
440     if (x & 0x10000000000000 > 0)
441       result = result * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
442     if (x & 0x8000000000000 > 0)
443       result = result * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
444     if (x & 0x4000000000000 > 0)
445       result = result * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
446     if (x & 0x2000000000000 > 0)
447       result = result * 0x1000162E525EE054754457D5995292026 >> 128;
448     if (x & 0x1000000000000 > 0)
449       result = result * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
450     if (x & 0x800000000000 > 0)
451       result = result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
452     if (x & 0x400000000000 > 0)
453       result = result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
454     if (x & 0x200000000000 > 0)
455       result = result * 0x10000162E43F4F831060E02D839A9D16D >> 128;
456     if (x & 0x100000000000 > 0)
457       result = result * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
458     if (x & 0x80000000000 > 0)
459       result = result * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
460     if (x & 0x40000000000 > 0)
461       result = result * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
462     if (x & 0x20000000000 > 0)
463       result = result * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
464     if (x & 0x10000000000 > 0)
465       result = result * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
466     if (x & 0x8000000000 > 0)
467       result = result * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
468     if (x & 0x4000000000 > 0)
469       result = result * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
470     if (x & 0x2000000000 > 0)
471       result = result * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
472     if (x & 0x1000000000 > 0)
473       result = result * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
474     if (x & 0x800000000 > 0)
475       result = result * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
476     if (x & 0x400000000 > 0)
477       result = result * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
478     if (x & 0x200000000 > 0)
479       result = result * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
480     if (x & 0x100000000 > 0)
481       result = result * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
482     if (x & 0x80000000 > 0)
483       result = result * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
484     if (x & 0x40000000 > 0)
485       result = result * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
486     if (x & 0x20000000 > 0)
487       result = result * 0x100000000162E42FEFB2FED257559BDAA >> 128;
488     if (x & 0x10000000 > 0)
489       result = result * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
490     if (x & 0x8000000 > 0)
491       result = result * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
492     if (x & 0x4000000 > 0)
493       result = result * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
494     if (x & 0x2000000 > 0)
495       result = result * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
496     if (x & 0x1000000 > 0)
497       result = result * 0x10000000000B17217F7D20CF927C8E94C >> 128;
498     if (x & 0x800000 > 0)
499       result = result * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
500     if (x & 0x400000 > 0)
501       result = result * 0x100000000002C5C85FDF477B662B26945 >> 128;
502     if (x & 0x200000 > 0)
503       result = result * 0x10000000000162E42FEFA3AE53369388C >> 128;
504     if (x & 0x100000 > 0)
505       result = result * 0x100000000000B17217F7D1D351A389D40 >> 128;
506     if (x & 0x80000 > 0)
507       result = result * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
508     if (x & 0x40000 > 0)
509       result = result * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
510     if (x & 0x20000 > 0)
511       result = result * 0x100000000000162E42FEFA39FE95583C2 >> 128;
512     if (x & 0x10000 > 0)
513       result = result * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
514     if (x & 0x8000 > 0)
515       result = result * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
516     if (x & 0x4000 > 0)
517       result = result * 0x10000000000002C5C85FDF473E242EA38 >> 128;
518     if (x & 0x2000 > 0)
519       result = result * 0x1000000000000162E42FEFA39F02B772C >> 128;
520     if (x & 0x1000 > 0)
521       result = result * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
522     if (x & 0x800 > 0)
523       result = result * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
524     if (x & 0x400 > 0)
525       result = result * 0x100000000000002C5C85FDF473DEA871F >> 128;
526     if (x & 0x200 > 0)
527       result = result * 0x10000000000000162E42FEFA39EF44D91 >> 128;
528     if (x & 0x100 > 0)
529       result = result * 0x100000000000000B17217F7D1CF79E949 >> 128;
530     if (x & 0x80 > 0)
531       result = result * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
532     if (x & 0x40 > 0)
533       result = result * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
534     if (x & 0x20 > 0)
535       result = result * 0x100000000000000162E42FEFA39EF366F >> 128;
536     if (x & 0x10 > 0)
537       result = result * 0x1000000000000000B17217F7D1CF79AFA >> 128;
538     if (x & 0x8 > 0)
539       result = result * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
540     if (x & 0x4 > 0)
541       result = result * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
542     if (x & 0x2 > 0)
543       result = result * 0x1000000000000000162E42FEFA39EF358 >> 128;
544     if (x & 0x1 > 0)
545       result = result * 0x10000000000000000B17217F7D1CF79AB >> 128;
546 
547     result >>= uint256 (63 - (x >> 64));
548     require (result <= uint256 (MAX_64x64));
549 
550     return int128 (result);
551   }
552 
553   /**
554    * Calculate natural exponent of x.  Revert on overflow.
555    *
556    * @param x signed 64.64-bit fixed point number
557    * @return signed 64.64-bit fixed point number
558    */
559   function exp (int128 x) internal pure returns (int128) {
560     require (x < 0x400000000000000000); // Overflow
561 
562     if (x < -0x400000000000000000) return 0; // Underflow
563 
564     return exp_2 (
565         int128 (int256 (x) * 0x171547652B82FE1777D0FFDA0D23A7D12 >> 128));
566   }
567 
568   /**
569    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
570    * integer numbers.  Revert on overflow or when y is zero.
571    *
572    * @param x unsigned 256-bit integer number
573    * @param y unsigned 256-bit integer number
574    * @return unsigned 64.64-bit fixed point number
575    */
576   function divuu (uint256 x, uint256 y) private pure returns (uint128) {
577     require (y != 0);
578 
579     uint256 result;
580 
581     if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
582       result = (x << 64) / y;
583     else {
584       uint256 msb = 192;
585       uint256 xc = x >> 192;
586       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
587       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
588       if (xc >= 0x100) { xc >>= 8; msb += 8; }
589       if (xc >= 0x10) { xc >>= 4; msb += 4; }
590       if (xc >= 0x4) { xc >>= 2; msb += 2; }
591       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
592 
593       result = (x << 255 - msb) / ((y - 1 >> msb - 191) + 1);
594       require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
595 
596       uint256 hi = result * (y >> 128);
597       uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
598 
599       uint256 xh = x >> 192;
600       uint256 xl = x << 64;
601 
602       if (xl < lo) xh -= 1;
603       xl -= lo; // We rely on overflow behavior here
604       lo = hi << 128;
605       if (xl < lo) xh -= 1;
606       xl -= lo; // We rely on overflow behavior here
607 
608       assert (xh == hi >> 128);
609 
610       result += xl / y;
611     }
612 
613     require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
614     return uint128 (result);
615   }
616 
617   /**
618    * Calculate x^y assuming 0^0 is 1, where x is unsigned 129.127 fixed point
619    * number and y is unsigned 256-bit integer number.  Revert on overflow.
620    *
621    * @param x unsigned 129.127-bit fixed point number
622    * @param y uint256 value
623    * @return unsigned 129.127-bit fixed point number
624    */
625   function powu (uint256 x, uint256 y) private pure returns (uint256) {
626     if (y == 0) return 0x80000000000000000000000000000000;
627     else if (x == 0) return 0;
628     else {
629       int256 msb = 0;
630       uint256 xc = x;
631       if (xc >= 0x100000000000000000000000000000000) { xc >>= 128; msb += 128; }
632       if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
633       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
634       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
635       if (xc >= 0x100) { xc >>= 8; msb += 8; }
636       if (xc >= 0x10) { xc >>= 4; msb += 4; }
637       if (xc >= 0x4) { xc >>= 2; msb += 2; }
638       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
639 
640       int256 xe = msb - 127;
641       if (xe > 0) x >>= uint256 (xe);
642       else x <<= uint256 (-xe);
643 
644       uint256 result = 0x80000000000000000000000000000000;
645       int256 re = 0;
646 
647       while (y > 0) {
648         if (y & 1 > 0) {
649           result = result * x;
650           y -= 1;
651           re += xe;
652           if (result >=
653             0x8000000000000000000000000000000000000000000000000000000000000000) {
654             result >>= 128;
655             re += 1;
656           } else result >>= 127;
657           if (re < -127) return 0; // Underflow
658           require (re < 128); // Overflow
659         } else {
660           x = x * x;
661           y >>= 1;
662           xe <<= 1;
663           if (x >=
664             0x8000000000000000000000000000000000000000000000000000000000000000) {
665             x >>= 128;
666             xe += 1;
667           } else x >>= 127;
668           if (xe < -127) return 0; // Underflow
669           require (xe < 128); // Overflow
670         }
671       }
672 
673       if (re > 0) result <<= uint256 (re);
674       else if (re < 0) result >>= uint256 (-re);
675 
676       return result;
677     }
678   }
679 
680   /**
681    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
682    * number.
683    *
684    * @param x unsigned 256-bit integer number
685    * @return unsigned 128-bit integer number
686    */
687   function sqrtu (uint256 x) private pure returns (uint128) {
688     if (x == 0) return 0;
689     else {
690       uint256 xx = x;
691       uint256 r = 1;
692       if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
693       if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
694       if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
695       if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
696       if (xx >= 0x100) { xx >>= 8; r <<= 4; }
697       if (xx >= 0x10) { xx >>= 4; r <<= 2; }
698       if (xx >= 0x8) { r <<= 1; }
699       r = (r + x / r) >> 1;
700       r = (r + x / r) >> 1;
701       r = (r + x / r) >> 1;
702       r = (r + x / r) >> 1;
703       r = (r + x / r) >> 1;
704       r = (r + x / r) >> 1;
705       r = (r + x / r) >> 1; // Seven iterations should be enough
706       uint256 r1 = x / r;
707       return uint128 (r < r1 ? r : r1);
708     }
709   }
710 }