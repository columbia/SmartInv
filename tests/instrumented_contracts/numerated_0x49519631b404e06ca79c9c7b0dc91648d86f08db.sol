1 // The contract is based on the Shell Protocol source code: https://github.com/cowri/shell-solidity-v1
2 
3 pragma solidity >0.4.13 >=0.4.23 >=0.5.0 <0.6.0 >=0.5.7 <0.6.0;
4 
5 ////// lib/abdk-libraries-solidity/src/ABDKMath64x64.sol
6 /*
7  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
8  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
9  */
10 
11 /**
12  * Smart contract library of mathematical functions operating with signed
13  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
14  * basically a simple fraction whose numerator is signed 128-bit integer and
15  * denominator is 2^64.  As long as denominator is always the same, there is no
16  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
17  * represented by int128 type holding only the numerator.
18  */
19 library ABDKMath64x64 {
20   /**
21    * Minimum value signed 64.64-bit fixed point number may have. 
22    */
23   int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
24 
25   /**
26    * Maximum value signed 64.64-bit fixed point number may have. 
27    */
28   int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
29 
30   /**
31    * Convert signed 256-bit integer number into signed 64.64-bit fixed point
32    * number.  Revert on overflow.
33    *
34    * @param x signed 256-bit integer number
35    * @return signed 64.64-bit fixed point number
36    */
37   function fromInt (int256 x) internal pure returns (int128) {
38     require (x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
39     return int128 (x << 64);
40   }
41 
42   /**
43    * Convert signed 64.64 fixed point number into signed 64-bit integer number
44    * rounding down.
45    *
46    * @param x signed 64.64-bit fixed point number
47    * @return signed 64-bit integer number
48    */
49   function toInt (int128 x) internal pure returns (int64) {
50     return int64 (x >> 64);
51   }
52 
53   /**
54    * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
55    * number.  Revert on overflow.
56    *
57    * @param x unsigned 256-bit integer number
58    * @return signed 64.64-bit fixed point number
59    */
60   function fromUInt (uint256 x) internal pure returns (int128) {
61     require (x <= 0x7FFFFFFFFFFFFFFF);
62     return int128 (x << 64);
63   }
64 
65   /**
66    * Convert signed 64.64 fixed point number into unsigned 64-bit integer
67    * number rounding down.  Revert on underflow.
68    *
69    * @param x signed 64.64-bit fixed point number
70    * @return unsigned 64-bit integer number
71    */
72   function toUInt (int128 x) internal pure returns (uint64) {
73     require (x >= 0);
74     return uint64 (x >> 64);
75   }
76 
77   /**
78    * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
79    * number rounding down.  Revert on overflow.
80    *
81    * @param x signed 128.128-bin fixed point number
82    * @return signed 64.64-bit fixed point number
83    */
84   function from128x128 (int256 x) internal pure returns (int128) {
85     int256 result = x >> 64;
86     require (result >= MIN_64x64 && result <= MAX_64x64);
87     return int128 (result);
88   }
89 
90   /**
91    * Convert signed 64.64 fixed point number into signed 128.128 fixed point
92    * number.
93    *
94    * @param x signed 64.64-bit fixed point number
95    * @return signed 128.128 fixed point number
96    */
97   function to128x128 (int128 x) internal pure returns (int256) {
98     return int256 (x) << 64;
99   }
100 
101   /**
102    * Calculate x + y.  Revert on overflow.
103    *
104    * @param x signed 64.64-bit fixed point number
105    * @param y signed 64.64-bit fixed point number
106    * @return signed 64.64-bit fixed point number
107    */
108   function add (int128 x, int128 y) internal pure returns (int128) {
109     int256 result = int256(x) + y;
110     require (result >= MIN_64x64 && result <= MAX_64x64);
111     return int128 (result);
112   }
113 
114   /**
115    * Calculate x - y.  Revert on overflow.
116    *
117    * @param x signed 64.64-bit fixed point number
118    * @param y signed 64.64-bit fixed point number
119    * @return signed 64.64-bit fixed point number
120    */
121   function sub (int128 x, int128 y) internal pure returns (int128) {
122     int256 result = int256(x) - y;
123     require (result >= MIN_64x64 && result <= MAX_64x64);
124     return int128 (result);
125   }
126 
127   /**
128    * Calculate x * y rounding down.  Revert on overflow.
129    *
130    * @param x signed 64.64-bit fixed point number
131    * @param y signed 64.64-bit fixed point number
132    * @return signed 64.64-bit fixed point number
133    */
134   function mul (int128 x, int128 y) internal pure returns (int128) {
135     int256 result = int256(x) * y >> 64;
136     require (result >= MIN_64x64 && result <= MAX_64x64);
137     return int128 (result);
138   }
139 
140   /**
141    * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
142    * number and y is signed 256-bit integer number.  Revert on overflow.
143    *
144    * @param x signed 64.64 fixed point number
145    * @param y signed 256-bit integer number
146    * @return signed 256-bit integer number
147    */
148   function muli (int128 x, int256 y) internal pure returns (int256) {
149     if (x == MIN_64x64) {
150       require (y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
151         y <= 0x1000000000000000000000000000000000000000000000000);
152       return -y << 63;
153     } else {
154       bool negativeResult = false;
155       if (x < 0) {
156         x = -x;
157         negativeResult = true;
158       }
159       if (y < 0) {
160         y = -y; // We rely on overflow behavior here
161         negativeResult = !negativeResult;
162       }
163       uint256 absoluteResult = mulu (x, uint256 (y));
164       if (negativeResult) {
165         require (absoluteResult <=
166           0x8000000000000000000000000000000000000000000000000000000000000000);
167         return -int256 (absoluteResult); // We rely on overflow behavior here
168       } else {
169         require (absoluteResult <=
170           0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
171         return int256 (absoluteResult);
172       }
173     }
174   }
175 
176   /**
177    * Calculate x * y rounding down, where x is signed 64.64 fixed point number
178    * and y is unsigned 256-bit integer number.  Revert on overflow.
179    *
180    * @param x signed 64.64 fixed point number
181    * @param y unsigned 256-bit integer number
182    * @return unsigned 256-bit integer number
183    */
184   function mulu (int128 x, uint256 y) internal pure returns (uint256) {
185     if (y == 0) return 0;
186 
187     require (x >= 0);
188 
189     uint256 lo = (uint256 (x) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
190     uint256 hi = uint256 (x) * (y >> 128);
191 
192     require (hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
193     hi <<= 64;
194 
195     require (hi <=
196       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
197     return hi + lo;
198   }
199 
200   /**
201    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
202    * zero.
203    *
204    * @param x signed 64.64-bit fixed point number
205    * @param y signed 64.64-bit fixed point number
206    * @return signed 64.64-bit fixed point number
207    */
208   function div (int128 x, int128 y) internal pure returns (int128) {
209     require (y != 0);
210     int256 result = (int256 (x) << 64) / y;
211     require (result >= MIN_64x64 && result <= MAX_64x64);
212     return int128 (result);
213   }
214 
215   /**
216    * Calculate x / y rounding towards zero, where x and y are signed 256-bit
217    * integer numbers.  Revert on overflow or when y is zero.
218    *
219    * @param x signed 256-bit integer number
220    * @param y signed 256-bit integer number
221    * @return signed 64.64-bit fixed point number
222    */
223   function divi (int256 x, int256 y) internal pure returns (int128) {
224     require (y != 0);
225 
226     bool negativeResult = false;
227     if (x < 0) {
228       x = -x; // We rely on overflow behavior here
229       negativeResult = true;
230     }
231     if (y < 0) {
232       y = -y; // We rely on overflow behavior here
233       negativeResult = !negativeResult;
234     }
235     uint128 absoluteResult = divuu (uint256 (x), uint256 (y));
236     if (negativeResult) {
237       require (absoluteResult <= 0x80000000000000000000000000000000);
238       return -int128 (absoluteResult); // We rely on overflow behavior here
239     } else {
240       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
241       return int128 (absoluteResult); // We rely on overflow behavior here
242     }
243   }
244 
245   /**
246    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
247    * integer numbers.  Revert on overflow or when y is zero.
248    *
249    * @param x unsigned 256-bit integer number
250    * @param y unsigned 256-bit integer number
251    * @return signed 64.64-bit fixed point number
252    */
253   function divu (uint256 x, uint256 y) internal pure returns (int128) {
254     require (y != 0);
255     uint128 result = divuu (x, y);
256     require (result <= uint128 (MAX_64x64));
257     return int128 (result);
258   }
259 
260   /**
261    * Calculate -x.  Revert on overflow.
262    *
263    * @param x signed 64.64-bit fixed point number
264    * @return signed 64.64-bit fixed point number
265    */
266   function neg (int128 x) internal pure returns (int128) {
267     require (x != MIN_64x64);
268     return -x;
269   }
270 
271   /**
272    * Calculate |x|.  Revert on overflow.
273    *
274    * @param x signed 64.64-bit fixed point number
275    * @return signed 64.64-bit fixed point number
276    */
277   function abs (int128 x) internal pure returns (int128) {
278     require (x != MIN_64x64);
279     return x < 0 ? -x : x;
280   }
281 
282   /**
283    * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
284    * zero.
285    *
286    * @param x signed 64.64-bit fixed point number
287    * @return signed 64.64-bit fixed point number
288    */
289   function inv (int128 x) internal pure returns (int128) {
290     require (x != 0);
291     int256 result = int256 (0x100000000000000000000000000000000) / x;
292     require (result >= MIN_64x64 && result <= MAX_64x64);
293     return int128 (result);
294   }
295 
296   /**
297    * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
298    *
299    * @param x signed 64.64-bit fixed point number
300    * @param y signed 64.64-bit fixed point number
301    * @return signed 64.64-bit fixed point number
302    */
303   function avg (int128 x, int128 y) internal pure returns (int128) {
304     return int128 ((int256 (x) + int256 (y)) >> 1);
305   }
306 
307   /**
308    * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
309    * Revert on overflow or in case x * y is negative.
310    *
311    * @param x signed 64.64-bit fixed point number
312    * @param y signed 64.64-bit fixed point number
313    * @return signed 64.64-bit fixed point number
314    */
315   function gavg (int128 x, int128 y) internal pure returns (int128) {
316     int256 m = int256 (x) * int256 (y);
317     require (m >= 0);
318     require (m <
319         0x4000000000000000000000000000000000000000000000000000000000000000);
320     return int128 (sqrtu (uint256 (m), uint256 (x) + uint256 (y) >> 1));
321   }
322 
323   /**
324    * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
325    * and y is unsigned 256-bit integer number.  Revert on overflow.
326    *
327    * @param x signed 64.64-bit fixed point number
328    * @param y uint256 value
329    * @return signed 64.64-bit fixed point number
330    */
331   function pow (int128 x, uint256 y) internal pure returns (int128) {
332     uint256 absoluteResult;
333     bool negativeResult = false;
334     if (x >= 0) {
335       absoluteResult = powu (uint256 (x) << 63, y);
336     } else {
337       // We rely on overflow behavior here
338       absoluteResult = powu (uint256 (uint128 (-x)) << 63, y);
339       negativeResult = y & 1 > 0;
340     }
341 
342     absoluteResult >>= 63;
343 
344     if (negativeResult) {
345       require (absoluteResult <= 0x80000000000000000000000000000000);
346       return -int128 (absoluteResult); // We rely on overflow behavior here
347     } else {
348       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
349       return int128 (absoluteResult); // We rely on overflow behavior here
350     }
351   }
352 
353   /**
354    * Calculate sqrt (x) rounding down.  Revert if x < 0.
355    *
356    * @param x signed 64.64-bit fixed point number
357    * @return signed 64.64-bit fixed point number
358    */
359   function sqrt (int128 x) internal pure returns (int128) {
360     require (x >= 0);
361     return int128 (sqrtu (uint256 (x) << 64, 0x10000000000000000));
362   }
363 
364   /**
365    * Calculate binary logarithm of x.  Revert if x <= 0.
366    *
367    * @param x signed 64.64-bit fixed point number
368    * @return signed 64.64-bit fixed point number
369    */
370   function log_2 (int128 x) internal pure returns (int128) {
371     require (x > 0);
372 
373     int256 msb = 0;
374     int256 xc = x;
375     if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
376     if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
377     if (xc >= 0x10000) { xc >>= 16; msb += 16; }
378     if (xc >= 0x100) { xc >>= 8; msb += 8; }
379     if (xc >= 0x10) { xc >>= 4; msb += 4; }
380     if (xc >= 0x4) { xc >>= 2; msb += 2; }
381     if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
382 
383     int256 result = msb - 64 << 64;
384     uint256 ux = uint256 (x) << 127 - msb;
385     for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
386       ux *= ux;
387       uint256 b = ux >> 255;
388       ux >>= 127 + b;
389       result += bit * int256 (b);
390     }
391 
392     return int128 (result);
393   }
394 
395   /**
396    * Calculate natural logarithm of x.  Revert if x <= 0.
397    *
398    * @param x signed 64.64-bit fixed point number
399    * @return signed 64.64-bit fixed point number
400    */
401   function ln (int128 x) internal pure returns (int128) {
402     require (x > 0);
403 
404     return int128 (
405         uint256 (log_2 (x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF >> 128);
406   }
407 
408   /**
409    * Calculate binary exponent of x.  Revert on overflow.
410    *
411    * @param x signed 64.64-bit fixed point number
412    * @return signed 64.64-bit fixed point number
413    */
414   function exp_2 (int128 x) internal pure returns (int128) {
415     require (x < 0x400000000000000000); // Overflow
416 
417     if (x < -0x400000000000000000) return 0; // Underflow
418 
419     uint256 result = 0x80000000000000000000000000000000;
420 
421     if (x & 0x8000000000000000 > 0)
422       result = result * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
423     if (x & 0x4000000000000000 > 0)
424       result = result * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
425     if (x & 0x2000000000000000 > 0)
426       result = result * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
427     if (x & 0x1000000000000000 > 0)
428       result = result * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
429     if (x & 0x800000000000000 > 0)
430       result = result * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
431     if (x & 0x400000000000000 > 0)
432       result = result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
433     if (x & 0x200000000000000 > 0)
434       result = result * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
435     if (x & 0x100000000000000 > 0)
436       result = result * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
437     if (x & 0x80000000000000 > 0)
438       result = result * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
439     if (x & 0x40000000000000 > 0)
440       result = result * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
441     if (x & 0x20000000000000 > 0)
442       result = result * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
443     if (x & 0x10000000000000 > 0)
444       result = result * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
445     if (x & 0x8000000000000 > 0)
446       result = result * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
447     if (x & 0x4000000000000 > 0)
448       result = result * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
449     if (x & 0x2000000000000 > 0)
450       result = result * 0x1000162E525EE054754457D5995292026 >> 128;
451     if (x & 0x1000000000000 > 0)
452       result = result * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
453     if (x & 0x800000000000 > 0)
454       result = result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
455     if (x & 0x400000000000 > 0)
456       result = result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
457     if (x & 0x200000000000 > 0)
458       result = result * 0x10000162E43F4F831060E02D839A9D16D >> 128;
459     if (x & 0x100000000000 > 0)
460       result = result * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
461     if (x & 0x80000000000 > 0)
462       result = result * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
463     if (x & 0x40000000000 > 0)
464       result = result * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
465     if (x & 0x20000000000 > 0)
466       result = result * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
467     if (x & 0x10000000000 > 0)
468       result = result * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
469     if (x & 0x8000000000 > 0)
470       result = result * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
471     if (x & 0x4000000000 > 0)
472       result = result * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
473     if (x & 0x2000000000 > 0)
474       result = result * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
475     if (x & 0x1000000000 > 0)
476       result = result * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
477     if (x & 0x800000000 > 0)
478       result = result * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
479     if (x & 0x400000000 > 0)
480       result = result * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
481     if (x & 0x200000000 > 0)
482       result = result * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
483     if (x & 0x100000000 > 0)
484       result = result * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
485     if (x & 0x80000000 > 0)
486       result = result * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
487     if (x & 0x40000000 > 0)
488       result = result * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
489     if (x & 0x20000000 > 0)
490       result = result * 0x100000000162E42FEFB2FED257559BDAA >> 128;
491     if (x & 0x10000000 > 0)
492       result = result * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
493     if (x & 0x8000000 > 0)
494       result = result * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
495     if (x & 0x4000000 > 0)
496       result = result * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
497     if (x & 0x2000000 > 0)
498       result = result * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
499     if (x & 0x1000000 > 0)
500       result = result * 0x10000000000B17217F7D20CF927C8E94C >> 128;
501     if (x & 0x800000 > 0)
502       result = result * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
503     if (x & 0x400000 > 0)
504       result = result * 0x100000000002C5C85FDF477B662B26945 >> 128;
505     if (x & 0x200000 > 0)
506       result = result * 0x10000000000162E42FEFA3AE53369388C >> 128;
507     if (x & 0x100000 > 0)
508       result = result * 0x100000000000B17217F7D1D351A389D40 >> 128;
509     if (x & 0x80000 > 0)
510       result = result * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
511     if (x & 0x40000 > 0)
512       result = result * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
513     if (x & 0x20000 > 0)
514       result = result * 0x100000000000162E42FEFA39FE95583C2 >> 128;
515     if (x & 0x10000 > 0)
516       result = result * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
517     if (x & 0x8000 > 0)
518       result = result * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
519     if (x & 0x4000 > 0)
520       result = result * 0x10000000000002C5C85FDF473E242EA38 >> 128;
521     if (x & 0x2000 > 0)
522       result = result * 0x1000000000000162E42FEFA39F02B772C >> 128;
523     if (x & 0x1000 > 0)
524       result = result * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
525     if (x & 0x800 > 0)
526       result = result * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
527     if (x & 0x400 > 0)
528       result = result * 0x100000000000002C5C85FDF473DEA871F >> 128;
529     if (x & 0x200 > 0)
530       result = result * 0x10000000000000162E42FEFA39EF44D91 >> 128;
531     if (x & 0x100 > 0)
532       result = result * 0x100000000000000B17217F7D1CF79E949 >> 128;
533     if (x & 0x80 > 0)
534       result = result * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
535     if (x & 0x40 > 0)
536       result = result * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
537     if (x & 0x20 > 0)
538       result = result * 0x100000000000000162E42FEFA39EF366F >> 128;
539     if (x & 0x10 > 0)
540       result = result * 0x1000000000000000B17217F7D1CF79AFA >> 128;
541     if (x & 0x8 > 0)
542       result = result * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
543     if (x & 0x4 > 0)
544       result = result * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
545     if (x & 0x2 > 0)
546       result = result * 0x1000000000000000162E42FEFA39EF358 >> 128;
547     if (x & 0x1 > 0)
548       result = result * 0x10000000000000000B17217F7D1CF79AB >> 128;
549 
550     result >>= 63 - (x >> 64);
551     require (result <= uint256 (MAX_64x64));
552 
553     return int128 (result);
554   }
555 
556   /**
557    * Calculate natural exponent of x.  Revert on overflow.
558    *
559    * @param x signed 64.64-bit fixed point number
560    * @return signed 64.64-bit fixed point number
561    */
562   function exp (int128 x) internal pure returns (int128) {
563     require (x < 0x400000000000000000); // Overflow
564 
565     if (x < -0x400000000000000000) return 0; // Underflow
566 
567     return exp_2 (
568         int128 (int256 (x) * 0x171547652B82FE1777D0FFDA0D23A7D12 >> 128));
569   }
570 
571   /**
572    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
573    * integer numbers.  Revert on overflow or when y is zero.
574    *
575    * @param x unsigned 256-bit integer number
576    * @param y unsigned 256-bit integer number
577    * @return unsigned 64.64-bit fixed point number
578    */
579   function divuu (uint256 x, uint256 y) private pure returns (uint128) {
580     require (y != 0);
581 
582     uint256 result;
583 
584     if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
585       result = (x << 64) / y;
586     else {
587       uint256 msb = 192;
588       uint256 xc = x >> 192;
589       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
590       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
591       if (xc >= 0x100) { xc >>= 8; msb += 8; }
592       if (xc >= 0x10) { xc >>= 4; msb += 4; }
593       if (xc >= 0x4) { xc >>= 2; msb += 2; }
594       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
595 
596       result = (x << 255 - msb) / ((y - 1 >> msb - 191) + 1);
597       require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
598 
599       uint256 hi = result * (y >> 128);
600       uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
601 
602       uint256 xh = x >> 192;
603       uint256 xl = x << 64;
604 
605       if (xl < lo) xh -= 1;
606       xl -= lo; // We rely on overflow behavior here
607       lo = hi << 128;
608       if (xl < lo) xh -= 1;
609       xl -= lo; // We rely on overflow behavior here
610 
611       assert (xh == hi >> 128);
612 
613       result += xl / y;
614     }
615 
616     require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
617     return uint128 (result);
618   }
619 
620   /**
621    * Calculate x^y assuming 0^0 is 1, where x is unsigned 129.127 fixed point
622    * number and y is unsigned 256-bit integer number.  Revert on overflow.
623    *
624    * @param x unsigned 129.127-bit fixed point number
625    * @param y uint256 value
626    * @return unsigned 129.127-bit fixed point number
627    */
628   function powu (uint256 x, uint256 y) private pure returns (uint256) {
629     if (y == 0) return 0x80000000000000000000000000000000;
630     else if (x == 0) return 0;
631     else {
632       int256 msb = 0;
633       uint256 xc = x;
634       if (xc >= 0x100000000000000000000000000000000) { xc >>= 128; msb += 128; }
635       if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
636       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
637       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
638       if (xc >= 0x100) { xc >>= 8; msb += 8; }
639       if (xc >= 0x10) { xc >>= 4; msb += 4; }
640       if (xc >= 0x4) { xc >>= 2; msb += 2; }
641       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
642 
643       int256 xe = msb - 127;
644       if (xe > 0) x >>= xe;
645       else x <<= -xe;
646 
647       uint256 result = 0x80000000000000000000000000000000;
648       int256 re = 0;
649 
650       while (y > 0) {
651         if (y & 1 > 0) {
652           result = result * x;
653           y -= 1;
654           re += xe;
655           if (result >=
656             0x8000000000000000000000000000000000000000000000000000000000000000) {
657             result >>= 128;
658             re += 1;
659           } else result >>= 127;
660           if (re < -127) return 0; // Underflow
661           require (re < 128); // Overflow
662         } else {
663           x = x * x;
664           y >>= 1;
665           xe <<= 1;
666           if (x >=
667             0x8000000000000000000000000000000000000000000000000000000000000000) {
668             x >>= 128;
669             xe += 1;
670           } else x >>= 127;
671           if (xe < -127) return 0; // Underflow
672           require (xe < 128); // Overflow
673         }
674       }
675 
676       if (re > 0) result <<= re;
677       else if (re < 0) result >>= -re;
678 
679       return result;
680     }
681   }
682 
683   /**
684    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
685    * number.
686    *
687    * @param x unsigned 256-bit integer number
688    * @return unsigned 128-bit integer number
689    */
690   function sqrtu (uint256 x, uint256 r) private pure returns (uint128) {
691     if (x == 0) return 0;
692     else {
693       require (r > 0);
694       while (true) {
695         uint256 rr = x / r;
696         if (r == rr || r + 1 == rr) return uint128 (r);
697         else if (r == rr + 1) return uint128 (rr);
698         r = r + rr + 1 >> 1;
699       }
700     }
701   }
702 }
703 
704 ////// src/interfaces/IAssimilator.sol
705 // This program is free software: you can redistribute it and/or modify
706 // it under the terms of the GNU General Public License as published by
707 // the Free Software Foundation, either version 3 of the License, or
708 // (at your option) any later version.
709 
710 // This program is distributed in the hope that it will be useful,
711 // but WITHOUT ANY WARRANTY; without even the implied warranty of
712 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
713 // GNU General Public License for more details.
714 
715 // You should have received a copy of the GNU General Public License
716 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
717 
718 interface IAssimilator {
719     function intakeRaw (uint256 amount) external returns (int128);
720     function intakeRawAndGetBalance (uint256 amount) external returns (int128, int128);
721     function intakeNumeraire (int128 amount) external returns (uint256);
722     function outputRaw (address dst, uint256 amount) external returns (int128);
723     function outputRawAndGetBalance (address dst, uint256 amount) external returns (int128, int128);
724     function outputNumeraire (address dst, int128 amount) external returns (uint256);
725     function viewRawAmount (int128) external view returns (uint256);
726     function viewNumeraireAmount (uint256) external view returns (int128);
727     function viewNumeraireBalance (address) external view returns (int128);
728     function viewNumeraireAmountAndBalance (address, uint256) external view returns (int128, int128);
729 }
730 ////// src/Assimilators.sol
731 // This program is free software: you can redistribute it and/or modify
732 // it under the terms of the GNU General Public License as published by
733 // the Free Software Foundation, either version 3 of the License, or
734 // (at your option) any later version.
735 
736 // This program is distributed in the hope that it will be useful,
737 // but WITHOUT ANY WARRANTY; without even the implied warranty of
738 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
739 // GNU General Public License for more details.
740 
741 // You should have received a copy of the GNU General Public License
742 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
743 
744 library Assimilators {
745 
746     using ABDKMath64x64 for int128;
747     IAssimilator constant iAsmltr = IAssimilator(address(0));
748 
749     function delegate(address _callee, bytes memory _data) internal returns (bytes memory) {
750 
751         (bool _success, bytes memory returnData_) = _callee.delegatecall(_data);
752 
753         assembly { if eq(_success, 0) { revert(add(returnData_, 0x20), returndatasize()) } }
754 
755         return returnData_;
756 
757     }
758 
759     function viewRawAmount (address _assim, int128 _amt) internal view returns (uint256 amount_) {
760 
761         amount_ = IAssimilator(_assim).viewRawAmount(_amt);
762 
763     }
764 
765     function viewNumeraireAmount (address _assim, uint256 _amt) internal view returns (int128 amt_) {
766 
767         amt_ = IAssimilator(_assim).viewNumeraireAmount(_amt);
768 
769     }
770 
771     function viewNumeraireAmountAndBalance (address _assim, uint256 _amt) internal view returns (int128 amt_, int128 bal_) {
772 
773         ( amt_, bal_ ) = IAssimilator(_assim).viewNumeraireAmountAndBalance(address(this), _amt);
774 
775     }
776 
777     function viewNumeraireBalance (address _assim) internal view returns (int128 bal_) {
778 
779         bal_ = IAssimilator(_assim).viewNumeraireBalance(address(this));
780 
781     }
782 
783     function intakeRaw (address _assim, uint256 _amt) internal returns (int128 amt_) {
784 
785         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRaw.selector, _amt);
786 
787         amt_ = abi.decode(delegate(_assim, data), (int128));
788 
789     }
790 
791     function intakeRawAndGetBalance (address _assim, uint256 _amt) internal returns (int128 amt_, int128 bal_) {
792 
793         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRawAndGetBalance.selector, _amt);
794 
795         ( amt_, bal_ ) = abi.decode(delegate(_assim, data), (int128,int128));
796 
797     }
798 
799     function intakeNumeraire (address _assim, int128 _amt) internal returns (uint256 amt_) {
800 
801         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeNumeraire.selector, _amt);
802 
803         amt_ = abi.decode(delegate(_assim, data), (uint256));
804 
805     }
806 
807     function outputRaw (address _assim, address _dst, uint256 _amt) internal returns (int128 amt_ ) {
808 
809         bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amt);
810 
811         amt_ = abi.decode(delegate(_assim, data), (int128));
812 
813         amt_ = amt_.neg();
814 
815     }
816 
817     function outputRawAndGetBalance (address _assim, address _dst, uint256 _amt) internal returns (int128 amt_, int128 bal_) {
818 
819         bytes memory data = abi.encodeWithSelector(iAsmltr.outputRawAndGetBalance.selector, _dst, _amt);
820 
821         ( amt_, bal_ ) = abi.decode(delegate(_assim, data), (int128,int128));
822 
823         amt_ = amt_.neg();
824 
825     }
826 
827     function outputNumeraire (address _assim, address _dst, int128 _amt) internal returns (uint256 amt_) {
828 
829         bytes memory data = abi.encodeWithSelector(iAsmltr.outputNumeraire.selector, _dst, _amt.abs());
830 
831         amt_ = abi.decode(delegate(_assim, data), (uint256));
832 
833     }
834 
835 }
836 
837 library UnsafeMath64x64 {
838 
839   /**
840    * Calculate x * y rounding down.
841    *
842    * @param x signed 64.64-bit fixed point number
843    * @param y signed 64.64-bit fixed point number
844    * @return signed 64.64-bit fixed point number
845    */
846 
847   function us_mul (int128 x, int128 y) internal pure returns (int128) {
848     int256 result = int256(x) * y >> 64;
849     return int128 (result);
850   }
851 
852   /**
853    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
854    * zero.
855    *
856    * @param x signed 64.64-bit fixed point number
857    * @param y signed 64.64-bit fixed point number
858    * @return signed 64.64-bit fixed point number
859    */
860 
861   function us_div (int128 x, int128 y) internal pure returns (int128) {
862     int256 result = (int256 (x) << 64) / y;
863     return int128 (result);
864   }
865 
866 }
867 
868 library PartitionedLiquidity {
869 
870     using ABDKMath64x64 for uint;
871     using ABDKMath64x64 for int128;
872     using UnsafeMath64x64 for int128;
873 
874     event PoolPartitioned(bool);
875 
876     event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);
877 
878     int128 constant ONE = 0x10000000000000000;
879 
880     function partition (
881         ComponentStorage.Component storage component,
882         mapping (address => ComponentStorage.PartitionTicket) storage partitionTickets
883     ) external {
884 
885         uint _length = component.assets.length;
886 
887         ComponentStorage.PartitionTicket storage totalSupplyTicket = partitionTickets[address(this)];
888 
889         totalSupplyTicket.initialized = true;
890 
891         for (uint i = 0; i < _length; i++) totalSupplyTicket.claims.push(component.totalSupply);
892 
893         emit PoolPartitioned(true);
894 
895     }
896 
897     function viewPartitionClaims (
898         ComponentStorage.Component storage component,
899         mapping (address => ComponentStorage.PartitionTicket) storage partitionTickets,
900         address _addr
901     ) external view returns (
902         uint[] memory claims_
903     ) {
904 
905         ComponentStorage.PartitionTicket storage ticket = partitionTickets[_addr];
906 
907         if (ticket.initialized) return ticket.claims;
908 
909         uint _length = component.assets.length;
910         claims_ = new uint[](_length);
911         uint _balance = component.balances[msg.sender];
912 
913         for (uint i = 0; i < _length; i++) claims_[i] = _balance;
914 
915         return claims_;
916 
917     }
918 
919     function partitionedWithdraw (
920         ComponentStorage.Component storage component,
921         mapping (address => ComponentStorage.PartitionTicket) storage partitionTickets,
922         address[] calldata _derivatives,
923         uint[] calldata _withdrawals
924     ) external returns (
925         uint[] memory
926     ) {
927 
928         uint _length = component.assets.length;
929         uint _balance = component.balances[msg.sender];
930 
931         ComponentStorage.PartitionTicket storage totalSuppliesTicket = partitionTickets[address(this)];
932         ComponentStorage.PartitionTicket storage ticket = partitionTickets[msg.sender];
933 
934         if (!ticket.initialized) {
935 
936             for (uint i = 0; i < _length; i++) ticket.claims.push(_balance);
937             ticket.initialized = true;
938 
939         }
940 
941         _length = _derivatives.length;
942 
943         uint[] memory withdrawals_ = new uint[](_length);
944 
945         for (uint i = 0; i < _length; i++) {
946 
947             ComponentStorage.Assimilator memory _assim = component.assimilators[_derivatives[i]];
948 
949             require(totalSuppliesTicket.claims[_assim.ix] >= _withdrawals[i], "Component/burn-exceeds-total-supply");
950 
951             require(ticket.claims[_assim.ix] >= _withdrawals[i], "Component/insufficient-balance");
952 
953             require(_assim.addr != address(0), "Component/unsupported-asset");
954 
955             int128 _reserveBalance = Assimilators.viewNumeraireBalance(_assim.addr);
956 
957             int128 _multiplier = _withdrawals[i].divu(1e18)
958                 .div(totalSuppliesTicket.claims[_assim.ix].divu(1e18));
959 
960             totalSuppliesTicket.claims[_assim.ix] = totalSuppliesTicket.claims[_assim.ix] - _withdrawals[i];
961 
962             ticket.claims[_assim.ix] = ticket.claims[_assim.ix] - _withdrawals[i];
963 
964             uint _withdrawal = Assimilators.outputNumeraire(
965                 _assim.addr,
966                 msg.sender,
967                 _reserveBalance.mul(_multiplier)
968             );
969 
970             withdrawals_[i] = _withdrawal;
971 
972             emit PartitionRedeemed(_derivatives[i], msg.sender, withdrawals_[i]);
973 
974         }
975 
976         return withdrawals_;
977 
978     }
979 
980 }
981 
982 library ProportionalLiquidity {
983 
984     using ABDKMath64x64 for uint;
985     using ABDKMath64x64 for int128;
986     using UnsafeMath64x64 for int128;
987 
988     event Transfer(address indexed from, address indexed to, uint256 value);
989 
990     int128 constant ONE = 0x10000000000000000;
991     int128 constant ONE_WEI = 0x12;
992 
993     function proportionalDeposit (
994         ComponentStorage.Component storage component,
995         uint256 _deposit
996     ) external returns (
997         uint256 components_,
998         uint[] memory
999     ) {
1000 
1001         int128 __deposit = _deposit.divu(1e18);
1002 
1003         uint _length = component.assets.length;
1004 
1005         uint[] memory deposits_ = new uint[](_length);
1006 
1007         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(component);
1008 
1009         if (_oGLiq == 0) {
1010 
1011             for (uint i = 0; i < _length; i++) {
1012 
1013                 deposits_[i] = Assimilators.intakeNumeraire(component.assets[i].addr, __deposit.mul(component.weights[i]));
1014 
1015             }
1016 
1017         } else {
1018 
1019             int128 _multiplier = __deposit.div(_oGLiq);
1020 
1021             for (uint i = 0; i < _length; i++) {
1022 
1023                 deposits_[i] = Assimilators.intakeNumeraire(component.assets[i].addr, _oBals[i].mul(_multiplier));
1024 
1025             }
1026 
1027         }
1028 
1029         int128 _totalComponents = component.totalSupply.divu(1e18);
1030 
1031         int128 _newComponents = _totalComponents > 0
1032             ? __deposit.div(_oGLiq).mul(_totalComponents)
1033             : __deposit;
1034 
1035         requireLiquidityInvariant(
1036             component,
1037           _totalComponents,
1038           _newComponents,
1039             _oGLiq,
1040             _oBals
1041         );
1042 
1043         mint(component, msg.sender, components_ = _newComponents.mulu(1e18));
1044 
1045         return (components_, deposits_);
1046 
1047     }
1048 
1049 
1050     function viewProportionalDeposit (
1051         ComponentStorage.Component storage component,
1052         uint256 _deposit
1053     ) external view returns (
1054         uint components_,
1055         uint[] memory
1056     ) {
1057 
1058         int128 __deposit = _deposit.divu(1e18);
1059 
1060         uint _length = component.assets.length;
1061 
1062         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(component);
1063 
1064         uint[] memory deposits_ = new uint[](_length);
1065 
1066         if (_oGLiq == 0) {
1067 
1068             for (uint i = 0; i < _length; i++) {
1069 
1070                 deposits_[i] = Assimilators.viewRawAmount(
1071                     component.assets[i].addr,
1072                     __deposit.mul(component.weights[i])
1073                 );
1074 
1075             }
1076 
1077         } else {
1078 
1079             int128 _multiplier = __deposit.div(_oGLiq);
1080 
1081             for (uint i = 0; i < _length; i++) {
1082 
1083                 deposits_[i] = Assimilators.viewRawAmount(
1084                     component.assets[i].addr,
1085                     _oBals[i].mul(_multiplier)
1086                 );
1087 
1088             }
1089 
1090         }
1091 
1092         int128 _totalComponents = component.totalSupply.divu(1e18);
1093 
1094         int128 _newComponents = _totalComponents > 0
1095             ? __deposit.div(_oGLiq).mul(_totalComponents)
1096             : __deposit;
1097 
1098         components_ = _newComponents.mulu(1e18);
1099 
1100         return (components_, deposits_ );
1101 
1102     }
1103 
1104     function proportionalWithdraw (
1105         ComponentStorage.Component storage component,
1106         uint256 _withdrawal
1107     ) external returns (
1108         uint[] memory
1109     ) {
1110 
1111         uint _length = component.assets.length;
1112 
1113         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(component);
1114 
1115         uint[] memory withdrawals_ = new uint[](_length);
1116 
1117         int128 _totalComponents = component.totalSupply.divu(1e18);
1118         int128 __withdrawal = _withdrawal.divu(1e18);
1119 
1120         int128 _multiplier = __withdrawal
1121             .mul(ONE - component.epsilon)
1122             .div(_totalComponents);
1123 
1124         for (uint i = 0; i < _length; i++) {
1125 
1126             withdrawals_[i] = Assimilators.outputNumeraire(
1127                 component.assets[i].addr,
1128                 msg.sender,
1129                 _oBals[i].mul(_multiplier)
1130             );
1131 
1132         }
1133 
1134         requireLiquidityInvariant(
1135             component,
1136           _totalComponents,
1137             __withdrawal.neg(),
1138             _oGLiq,
1139             _oBals
1140         );
1141 
1142         burn(component, msg.sender, _withdrawal);
1143 
1144         return withdrawals_;
1145 
1146     }
1147 
1148     function viewProportionalWithdraw (
1149         ComponentStorage.Component storage component,
1150         uint256 _withdrawal
1151     ) external view returns (
1152         uint[] memory
1153     ) {
1154 
1155         uint _length = component.assets.length;
1156 
1157         ( , int128[] memory _oBals ) = getGrossLiquidityAndBalances(component);
1158 
1159         uint[] memory withdrawals_ = new uint[](_length);
1160 
1161         int128 _multiplier = _withdrawal.divu(1e18)
1162             .mul(ONE - component.epsilon)
1163             .div(component.totalSupply.divu(1e18));
1164 
1165         for (uint i = 0; i < _length; i++) {
1166 
1167             withdrawals_[i] = Assimilators.viewRawAmount(component.assets[i].addr, _oBals[i].mul(_multiplier));
1168 
1169         }
1170 
1171         return withdrawals_;
1172 
1173     }
1174 
1175     function getGrossLiquidityAndBalances (
1176         ComponentStorage.Component storage component
1177     ) internal view returns (
1178         int128 grossLiquidity_,
1179         int128[] memory
1180     ) {
1181 
1182         uint _length = component.assets.length;
1183 
1184         int128[] memory balances_ = new int128[](_length);
1185 
1186         for (uint i = 0; i < _length; i++) {
1187 
1188             int128 _bal = Assimilators.viewNumeraireBalance(component.assets[i].addr);
1189 
1190             balances_[i] = _bal;
1191             grossLiquidity_ += _bal;
1192 
1193         }
1194 
1195         return (grossLiquidity_, balances_);
1196 
1197     }
1198 
1199     function requireLiquidityInvariant (
1200         ComponentStorage.Component storage component,
1201         int128 _components,
1202         int128 _newComponents,
1203         int128 _oGLiq,
1204         int128[] memory _oBals
1205     ) private view {
1206 
1207         ( int128 _nGLiq, int128[] memory _nBals ) = getGrossLiquidityAndBalances(component);
1208 
1209         int128 _beta = component.beta;
1210         int128 _delta = component.delta;
1211         int128[] memory _weights = component.weights;
1212 
1213         int128 _omega = ComponentMath.calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
1214 
1215         int128 _psi = ComponentMath.calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
1216 
1217         ComponentMath.enforceLiquidityInvariant(_components, _newComponents, _oGLiq, _nGLiq, _omega, _psi);
1218 
1219     }
1220 
1221     function burn (ComponentStorage.Component storage component, address account, uint256 amount) private {
1222 
1223         component.balances[account] = burn_sub(component.balances[account], amount);
1224 
1225         component.totalSupply = burn_sub(component.totalSupply, amount);
1226 
1227         emit Transfer(msg.sender, address(0), amount);
1228 
1229     }
1230 
1231     function mint (ComponentStorage.Component storage component, address account, uint256 amount) private {
1232 
1233         component.totalSupply = mint_add(component.totalSupply, amount);
1234 
1235         component.balances[account] = mint_add(component.balances[account], amount);
1236 
1237         emit Transfer(address(0), msg.sender, amount);
1238 
1239     }
1240 
1241     function mint_add(uint x, uint y) private pure returns (uint z) {
1242 
1243         require((z = x + y) >= x, "Component/mint-overflow");
1244 
1245     }
1246 
1247     function burn_sub(uint x, uint y) private pure returns (uint z) {
1248 
1249         require((z = x - y) <= x, "Component/burn-underflow");
1250 
1251     }
1252 
1253 
1254 }
1255 
1256 library SelectiveLiquidity {
1257 
1258     using ABDKMath64x64 for int128;
1259     using UnsafeMath64x64 for int128;
1260 
1261     event Transfer(address indexed from, address indexed to, uint256 value);
1262 
1263     int128 constant ONE = 0x10000000000000000;
1264 
1265     function selectiveDeposit (
1266         ComponentStorage.Component storage component,
1267         address[] calldata _derivatives,
1268         uint[] calldata _amounts,
1269         uint _minComponents
1270     ) external returns (
1271         uint components_
1272     ) {
1273 
1274         (   int128 _oGLiq,
1275             int128 _nGLiq,
1276             int128[] memory _oBals,
1277             int128[] memory _nBals ) = getLiquidityDepositData(component, _derivatives, _amounts);
1278 
1279         int128 _components = ComponentMath.calculateLiquidityMembrane(component, _oGLiq, _nGLiq, _oBals, _nBals);
1280 
1281         components_ = _components.mulu(1e18);
1282 
1283         require(_minComponents < components_, "Component/under-minimum-components");
1284 
1285         mint(component, msg.sender, components_);
1286 
1287     }
1288 
1289     function viewSelectiveDeposit (
1290         ComponentStorage.Component storage component,
1291         address[] calldata _derivatives,
1292         uint[] calldata _amounts
1293     ) external view returns (
1294         uint components_
1295     ) {
1296 
1297         (   int128 _oGLiq,
1298             int128 _nGLiq,
1299             int128[] memory _oBals,
1300             int128[] memory _nBals ) = viewLiquidityDepositData(component, _derivatives, _amounts);
1301 
1302         int128 _components = ComponentMath.calculateLiquidityMembrane(component, _oGLiq, _nGLiq, _oBals, _nBals);
1303 
1304         components_ = _components.mulu(1e18);
1305 
1306     }
1307 
1308     function selectiveWithdraw (
1309         ComponentStorage.Component storage component,
1310         address[] calldata _derivatives,
1311         uint[] calldata _amounts,
1312         uint _maxComponents
1313     ) external returns (
1314         uint256 components_
1315     ) {
1316 
1317         (   int128 _oGLiq,
1318             int128 _nGLiq,
1319             int128[] memory _oBals,
1320             int128[] memory _nBals ) = getLiquidityWithdrawData(component, _derivatives, msg.sender, _amounts);
1321 
1322         int128 _components = ComponentMath.calculateLiquidityMembrane(component, _oGLiq, _nGLiq, _oBals, _nBals);
1323 
1324         _components = _components.neg().us_mul(ONE + component.epsilon);
1325 
1326         components_ = _components.mulu(1e18);
1327 
1328         require(components_ < _maxComponents, "Component/above-maximum-components");
1329 
1330         burn(component, msg.sender, components_);
1331 
1332     }
1333 
1334     function viewSelectiveWithdraw (
1335         ComponentStorage.Component storage component,
1336         address[] calldata _derivatives,
1337         uint[] calldata _amounts
1338     ) external view returns (
1339         uint components_
1340     ) {
1341 
1342         (   int128 _oGLiq,
1343             int128 _nGLiq,
1344             int128[] memory _oBals,
1345             int128[] memory _nBals ) = viewLiquidityWithdrawData(component, _derivatives, _amounts);
1346 
1347         int128 _components = ComponentMath.calculateLiquidityMembrane(component, _oGLiq, _nGLiq, _oBals, _nBals);
1348 
1349         _components = _components.neg().us_mul(ONE + component.epsilon);
1350 
1351         components_ = _components.mulu(1e18);
1352 
1353     }
1354 
1355     function getLiquidityDepositData (
1356         ComponentStorage.Component storage component,
1357         address[] memory _derivatives,
1358         uint[] memory _amounts
1359     ) private returns (
1360         int128 oGLiq_,
1361         int128 nGLiq_,
1362         int128[] memory,
1363         int128[] memory
1364     ) {
1365 
1366         uint _length = component.weights.length;
1367         int128[] memory oBals_ = new int128[](_length);
1368         int128[] memory nBals_ = new int128[](_length);
1369 
1370         for (uint i = 0; i < _derivatives.length; i++) {
1371 
1372             ComponentStorage.Assimilator memory _assim = component.assimilators[_derivatives[i]];
1373 
1374             require(_assim.addr != address(0), "Component/unsupported-derivative");
1375 
1376             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1377 
1378                 ( int128 _amount, int128 _balance ) = Assimilators.intakeRawAndGetBalance(_assim.addr, _amounts[i]);
1379 
1380                 nBals_[_assim.ix] = _balance;
1381 
1382                 oBals_[_assim.ix] = _balance.sub(_amount);
1383 
1384             } else {
1385 
1386                 int128 _amount = Assimilators.intakeRaw(_assim.addr, _amounts[i]);
1387 
1388                 nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);
1389 
1390             }
1391 
1392         }
1393 
1394         return completeLiquidityData(component, oBals_, nBals_);
1395 
1396     }
1397 
1398     function getLiquidityWithdrawData (
1399         ComponentStorage.Component storage component,
1400         address[] memory _derivatives,
1401         address _rcpnt,
1402         uint[] memory _amounts
1403     ) private returns (
1404         int128 oGLiq_,
1405         int128 nGLiq_,
1406         int128[] memory,
1407         int128[] memory
1408     ) {
1409 
1410         uint _length = component.weights.length;
1411         int128[] memory oBals_ = new int128[](_length);
1412         int128[] memory nBals_ = new int128[](_length);
1413 
1414         for (uint i = 0; i < _derivatives.length; i++) {
1415 
1416             ComponentStorage.Assimilator memory _assim = component.assimilators[_derivatives[i]];
1417 
1418             require(_assim.addr != address(0), "Component/unsupported-derivative");
1419 
1420             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1421 
1422                 ( int128 _amount, int128 _balance ) = Assimilators.outputRawAndGetBalance(_assim.addr, _rcpnt, _amounts[i]);
1423 
1424                 nBals_[_assim.ix] = _balance;
1425                 oBals_[_assim.ix] = _balance.sub(_amount);
1426 
1427             } else {
1428 
1429                 int128 _amount = Assimilators.outputRaw(_assim.addr, _rcpnt, _amounts[i]);
1430 
1431                 nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);
1432 
1433             }
1434 
1435         }
1436 
1437         return completeLiquidityData(component, oBals_, nBals_);
1438 
1439     }
1440 
1441     function viewLiquidityDepositData (
1442         ComponentStorage.Component storage component,
1443         address[] memory _derivatives,
1444         uint[] memory _amounts
1445     ) private view returns (
1446         int128 oGLiq_,
1447         int128 nGLiq_,
1448         int128[] memory,
1449         int128[] memory
1450     ) {
1451 
1452         uint _length = component.assets.length;
1453         int128[] memory oBals_ = new int128[](_length);
1454         int128[] memory nBals_ = new int128[](_length);
1455 
1456         for (uint i = 0; i < _derivatives.length; i++) {
1457 
1458             ComponentStorage.Assimilator memory _assim = component.assimilators[_derivatives[i]];
1459 
1460             require(_assim.addr != address(0), "Component/unsupported-derivative");
1461 
1462             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1463 
1464                 ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amounts[i]);
1465 
1466                 nBals_[_assim.ix] = _balance.add(_amount);
1467 
1468                 oBals_[_assim.ix] = _balance;
1469 
1470             } else {
1471 
1472                 int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amounts[i]);
1473 
1474                 nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);
1475 
1476             }
1477 
1478         }
1479 
1480         return completeLiquidityData(component, oBals_, nBals_);
1481 
1482     }
1483 
1484     function viewLiquidityWithdrawData (
1485         ComponentStorage.Component storage component,
1486         address[] memory _derivatives,
1487         uint[] memory _amounts
1488     ) private view returns (
1489         int128 oGLiq_,
1490         int128 nGLiq_,
1491         int128[] memory,
1492         int128[] memory
1493     ) {
1494 
1495         uint _length = component.assets.length;
1496         int128[] memory oBals_ = new int128[](_length);
1497         int128[] memory nBals_ = new int128[](_length);
1498 
1499         for (uint i = 0; i < _derivatives.length; i++) {
1500 
1501             ComponentStorage.Assimilator memory _assim = component.assimilators[_derivatives[i]];
1502 
1503             require(_assim.addr != address(0), "Component/unsupported-derivative");
1504 
1505             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1506 
1507                 ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amounts[i]);
1508 
1509                 nBals_[_assim.ix] = _balance.sub(_amount);
1510 
1511                 oBals_[_assim.ix] = _balance;
1512 
1513             } else {
1514 
1515                 int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amounts[i]);
1516 
1517                 nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);
1518 
1519             }
1520 
1521         }
1522 
1523         return completeLiquidityData(component, oBals_, nBals_);
1524 
1525     }
1526 
1527     function completeLiquidityData (
1528         ComponentStorage.Component storage component,
1529         int128[] memory oBals_,
1530         int128[] memory nBals_
1531     ) private view returns (
1532         int128 oGLiq_,
1533         int128 nGLiq_,
1534         int128[] memory,
1535         int128[] memory
1536     ) {
1537 
1538         uint _length = oBals_.length;
1539 
1540         for (uint i = 0; i < _length; i++) {
1541 
1542             if (oBals_[i] == 0 && 0 == nBals_[i]) {
1543 
1544                 nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(component.assets[i].addr);
1545 
1546             }
1547 
1548             oGLiq_ += oBals_[i];
1549             nGLiq_ += nBals_[i];
1550 
1551         }
1552 
1553         return ( oGLiq_, nGLiq_, oBals_, nBals_ );
1554 
1555     }
1556 
1557     function burn (ComponentStorage.Component storage component, address account, uint256 amount) private {
1558 
1559         component.balances[account] = burn_sub(component.balances[account], amount);
1560 
1561         component.totalSupply = burn_sub(component.totalSupply, amount);
1562 
1563         emit Transfer(msg.sender, address(0), amount);
1564 
1565     }
1566 
1567     function mint (ComponentStorage.Component storage component, address account, uint256 amount) private {
1568 
1569         component.totalSupply = mint_add(component.totalSupply, amount);
1570 
1571         component.balances[account] = mint_add(component.balances[account], amount);
1572 
1573         emit Transfer(address(0), msg.sender, amount);
1574 
1575     }
1576 
1577     function mint_add(uint x, uint y) private pure returns (uint z) {
1578         require((z = x + y) >= x, "Component/mint-overflow");
1579     }
1580 
1581     function burn_sub(uint x, uint y) private pure returns (uint z) {
1582         require((z = x - y) <= x, "Component/burn-underflow");
1583     }
1584 
1585 }
1586 
1587 // This program is free software: you can redistribute it and/or modify
1588 // it under the terms of the GNU General Public License as published by
1589 // the Free Software Foundation, either version 3 of the License, or
1590 // (at your option) any later version.
1591 
1592 // This program is distributed in the hope that it will be useful,
1593 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1594 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1595 // GNU General Public License for more details.
1596 
1597 // You should have received a copy of the GNU General Public License
1598 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1599 
1600 library Components {
1601 
1602     using ABDKMath64x64 for int128;
1603 
1604     event Approval(address indexed _owner, address indexed spender, uint256 value);
1605     event Transfer(address indexed from, address indexed to, uint256 value);
1606 
1607     function add(uint x, uint y, string memory errorMessage) private pure returns (uint z) {
1608         require((z = x + y) >= x, errorMessage);
1609     }
1610 
1611     function sub(uint x, uint y, string memory errorMessage) private pure returns (uint z) {
1612         require((z = x - y) <= x, errorMessage);
1613     }
1614 
1615     /**
1616      * @dev See {IERC20-transfer}.
1617      *
1618      * Requirements:
1619      *
1620      * - `recipient` cannot be the zero address.
1621      * - the caller must have a balance of at least `amount`.
1622      */
1623     function transfer(ComponentStorage.Component storage component, address recipient, uint256 amount) external returns (bool) {
1624         _transfer(component, msg.sender, recipient, amount);
1625         return true;
1626     }
1627 
1628     /**
1629      * @dev See {IERC20-approve}.
1630      *
1631      * Requirements:
1632      *
1633      * - `spender` cannot be the zero address.
1634      */
1635     function approve(ComponentStorage.Component storage component, address spender, uint256 amount) external returns (bool) {
1636         _approve(component, msg.sender, spender, amount);
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
1649      * - the caller must have allowance for `sender`'s tokens of at least
1650      * `amount`
1651      */
1652     function transferFrom(ComponentStorage.Component storage component, address sender, address recipient, uint256 amount) external returns (bool) {
1653         _transfer(component, sender, recipient, amount);
1654         _approve(component, sender, msg.sender, sub(component.allowances[sender][msg.sender], amount, "Component/insufficient-allowance"));
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
1670     function increaseAllowance(ComponentStorage.Component storage component, address spender, uint256 addedValue) external returns (bool) {
1671         _approve(component, msg.sender, spender, add(component.allowances[msg.sender][spender], addedValue, "Component/approval-overflow"));
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
1689     function decreaseAllowance(ComponentStorage.Component storage component, address spender, uint256 subtractedValue) external returns (bool) {
1690         _approve(component, msg.sender, spender, sub(component.allowances[msg.sender][spender], subtractedValue, "Component/allowance-decrease-underflow"));
1691         return true;
1692     }
1693 
1694     /**
1695      * @dev Moves tokens `amount` from `sender` to `recipient`.
1696      *
1697      * This is public function is equivalent to {transfer}, and can be used to
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
1708     function _transfer(ComponentStorage.Component storage component, address sender, address recipient, uint256 amount) private {
1709         require(sender != address(0), "ERC20: transfer from the zero address");
1710         require(recipient != address(0), "ERC20: transfer to the zero address");
1711 
1712         component.balances[sender] = sub(component.balances[sender], amount, "Component/insufficient-balance");
1713         component.balances[recipient] = add(component.balances[recipient], amount, "Component/transfer-overflow");
1714         emit Transfer(sender, recipient, amount);
1715     }
1716 
1717 
1718     /**
1719      * @dev Sets `amount` as the allowance of `spender` over the `_owner`s tokens.
1720      *
1721      * This is public function is equivalent to `approve`, and can be used to
1722      * e.g. set automatic allowances for certain subsystems, etc.
1723      *
1724      * Emits an {Approval} event.
1725      *
1726      * Requirements:
1727      *
1728      * - `_owner` cannot be the zero address.
1729      * - `spender` cannot be the zero address.
1730      */
1731     function _approve(ComponentStorage.Component storage component, address _owner, address spender, uint256 amount) private {
1732         require(_owner != address(0), "ERC20: approve from the zero address");
1733         require(spender != address(0), "ERC20: approve to the zero address");
1734 
1735         component.allowances[_owner][spender] = amount;
1736         emit Approval(_owner, spender, amount);
1737     }
1738 
1739 }
1740 
1741 library Swaps {
1742 
1743     using ABDKMath64x64 for int128;
1744     using UnsafeMath64x64 for int128;
1745 
1746     event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
1747 
1748     int128 constant ONE = 0x10000000000000000;
1749 
1750     function getOriginAndTarget (
1751         ComponentStorage.Component storage component,
1752         address _o,
1753         address _t
1754     ) private view returns (
1755         ComponentStorage.Assimilator memory,
1756         ComponentStorage.Assimilator memory
1757     ) {
1758 
1759         ComponentStorage.Assimilator memory o_ = component.assimilators[_o];
1760         ComponentStorage.Assimilator memory t_ = component.assimilators[_t];
1761 
1762         require(o_.addr != address(0), "Component/origin-not-supported");
1763         require(t_.addr != address(0), "Component/target-not-supported");
1764 
1765         return ( o_, t_ );
1766 
1767     }
1768 
1769 
1770     function originSwap (
1771         ComponentStorage.Component storage component,
1772         address _origin,
1773         address _target,
1774         uint256 _originAmount,
1775         address _recipient
1776     ) external returns (
1777         uint256 tAmt_
1778     ) {
1779 
1780         (   ComponentStorage.Assimilator memory _o,
1781             ComponentStorage.Assimilator memory _t  ) = getOriginAndTarget(component, _origin, _target);
1782 
1783         if (_o.ix == _t.ix) return Assimilators.outputNumeraire(_t.addr, _recipient, Assimilators.intakeRaw(_o.addr, _originAmount));
1784 
1785         (   int128 _amt,
1786             int128 _oGLiq,
1787             int128 _nGLiq,
1788             int128[] memory _oBals,
1789             int128[] memory _nBals ) = getOriginSwapData(component, _o.ix, _t.ix, _o.addr, _originAmount);
1790 
1791         _amt = ComponentMath.calculateTrade(component, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);
1792 
1793         settleProtocolShare(component, _t.addr, _amt);
1794 
1795         _amt = _amt.us_mul(ONE - component.epsilon);
1796 
1797         tAmt_ = Assimilators.outputNumeraire(_t.addr, _recipient, _amt);
1798 
1799         emit Trade(msg.sender, _origin, _target, _originAmount, tAmt_);
1800 
1801     }
1802 
1803     function viewOriginSwap (
1804         ComponentStorage.Component storage component,
1805         address _origin,
1806         address _target,
1807         uint256 _originAmount
1808     ) external view returns (
1809         uint256 tAmt_
1810     ) {
1811 
1812         (   ComponentStorage.Assimilator memory _o,
1813             ComponentStorage.Assimilator memory _t  ) = getOriginAndTarget(component, _origin, _target);
1814 
1815         if (_o.ix == _t.ix) return Assimilators.viewRawAmount(_t.addr, Assimilators.viewNumeraireAmount(_o.addr, _originAmount));
1816 
1817         (   int128 _amt,
1818             int128 _oGLiq,
1819             int128 _nGLiq,
1820             int128[] memory _nBals,
1821             int128[] memory _oBals ) = viewOriginSwapData(component, _o.ix, _t.ix, _originAmount, _o.addr);
1822 
1823         _amt = ComponentMath.calculateTrade(component, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);
1824 
1825         _amt = _amt.us_mul(ONE - component.epsilon);
1826 
1827         tAmt_ = Assimilators.viewRawAmount(_t.addr, _amt.abs());
1828 
1829     }
1830 
1831     function targetSwap (
1832         ComponentStorage.Component storage component,
1833         address _origin,
1834         address _target,
1835         uint256 _targetAmount,
1836         address _recipient
1837     ) external returns (
1838         uint256 oAmt_
1839     ) {
1840 
1841         (   ComponentStorage.Assimilator memory _o,
1842             ComponentStorage.Assimilator memory _t  ) = getOriginAndTarget(component, _origin, _target);
1843 
1844         if (_o.ix == _t.ix) return Assimilators.intakeNumeraire(_o.addr, Assimilators.outputRaw(_t.addr, _recipient, _targetAmount));
1845 
1846         (   int128 _amt,
1847             int128 _oGLiq,
1848             int128 _nGLiq,
1849             int128[] memory _oBals,
1850             int128[] memory _nBals) = getTargetSwapData(component, _t.ix, _o.ix, _t.addr, _recipient, _targetAmount);
1851 
1852         _amt = ComponentMath.calculateTrade(component, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);
1853 
1854         int128 _amtWFee = _amt.us_mul(ONE + component.epsilon);
1855 
1856         oAmt_ = Assimilators.intakeNumeraire(_o.addr, _amtWFee);
1857 
1858         settleProtocolShare(component, _o.addr, _amt);
1859 
1860         emit Trade(msg.sender, _origin, _target, oAmt_, _targetAmount);
1861 
1862     }
1863 
1864     function viewTargetSwap (
1865         ComponentStorage.Component storage component,
1866         address _origin,
1867         address _target,
1868         uint256 _targetAmount
1869     ) external view returns (
1870         uint256 oAmt_
1871     ) {
1872 
1873         (   ComponentStorage.Assimilator memory _o,
1874             ComponentStorage.Assimilator memory _t  ) = getOriginAndTarget(component, _origin, _target);
1875 
1876         if (_o.ix == _t.ix) return Assimilators.viewRawAmount(_o.addr, Assimilators.viewNumeraireAmount(_t.addr, _targetAmount));
1877 
1878         (   int128 _amt,
1879             int128 _oGLiq,
1880             int128 _nGLiq,
1881             int128[] memory _nBals,
1882             int128[] memory _oBals ) = viewTargetSwapData(component, _t.ix, _o.ix, _targetAmount, _t.addr);
1883 
1884         _amt = ComponentMath.calculateTrade(component, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);
1885 
1886         _amt = _amt.us_mul(ONE + component.epsilon);
1887 
1888         oAmt_ = Assimilators.viewRawAmount(_o.addr, _amt);
1889 
1890     }
1891 
1892     function getOriginSwapData (
1893         ComponentStorage.Component storage component,
1894         uint _inputIx,
1895         uint _outputIx,
1896         address _assim,
1897         uint _amt
1898     ) private returns (
1899         int128 amt_,
1900         int128 oGLiq_,
1901         int128 nGLiq_,
1902         int128[] memory,
1903         int128[] memory
1904     ) {
1905 
1906         uint _length = component.assets.length;
1907 
1908         int128[] memory oBals_ = new int128[](_length);
1909         int128[] memory nBals_ = new int128[](_length);
1910         ComponentStorage.Assimilator[] memory _reserves = component.assets;
1911 
1912         for (uint i = 0; i < _length; i++) {
1913 
1914             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
1915             else {
1916 
1917                 int128 _bal;
1918                 ( amt_, _bal ) = Assimilators.intakeRawAndGetBalance(_assim, _amt);
1919 
1920                 oBals_[i] = _bal.sub(amt_);
1921                 nBals_[i] = _bal;
1922 
1923             }
1924 
1925             oGLiq_ += oBals_[i];
1926             nGLiq_ += nBals_[i];
1927 
1928         }
1929 
1930         nGLiq_ = nGLiq_.sub(amt_);
1931         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
1932 
1933         return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );
1934 
1935     }
1936 
1937     function getTargetSwapData (
1938         ComponentStorage.Component storage component,
1939         uint _inputIx,
1940         uint _outputIx,
1941         address _assim,
1942         address _recipient,
1943         uint _amt
1944     ) private returns (
1945         int128 amt_,
1946         int128 oGLiq_,
1947         int128 nGLiq_,
1948         int128[] memory,
1949         int128[] memory
1950     ) {
1951 
1952         uint _length = component.assets.length;
1953 
1954         int128[] memory oBals_ = new int128[](_length);
1955         int128[] memory nBals_ = new int128[](_length);
1956         ComponentStorage.Assimilator[] memory _reserves = component.assets;
1957 
1958         for (uint i = 0; i < _length; i++) {
1959 
1960             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
1961             else {
1962 
1963                 int128 _bal;
1964                 ( amt_, _bal ) = Assimilators.outputRawAndGetBalance(_assim, _recipient, _amt);
1965 
1966                 oBals_[i] = _bal.sub(amt_);
1967                 nBals_[i] = _bal;
1968 
1969             }
1970 
1971             oGLiq_ += oBals_[i];
1972             nGLiq_ += nBals_[i];
1973 
1974         }
1975 
1976         nGLiq_ = nGLiq_.sub(amt_);
1977         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
1978 
1979         return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );
1980 
1981     }
1982 
1983     function viewOriginSwapData (
1984         ComponentStorage.Component storage component,
1985         uint _inputIx,
1986         uint _outputIx,
1987         uint _amt,
1988         address _assim
1989     ) private view returns (
1990         int128 amt_,
1991         int128 oGLiq_,
1992         int128 nGLiq_,
1993         int128[] memory,
1994         int128[] memory
1995     ) {
1996 
1997         uint _length = component.assets.length;
1998         int128[] memory nBals_ = new int128[](_length);
1999         int128[] memory oBals_ = new int128[](_length);
2000 
2001         for (uint i = 0; i < _length; i++) {
2002 
2003             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(component.assets[i].addr);
2004             else {
2005 
2006                 int128 _bal;
2007                 ( amt_, _bal ) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
2008 
2009                 oBals_[i] = _bal;
2010                 nBals_[i] = _bal.add(amt_);
2011 
2012             }
2013 
2014             oGLiq_ += oBals_[i];
2015             nGLiq_ += nBals_[i];
2016 
2017         }
2018 
2019         nGLiq_ = nGLiq_.sub(amt_);
2020         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
2021 
2022         return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );
2023 
2024     }
2025 
2026     function viewTargetSwapData (
2027         ComponentStorage.Component storage component,
2028         uint _inputIx,
2029         uint _outputIx,
2030         uint _amt,
2031         address _assim
2032     ) private view returns (
2033         int128 amt_,
2034         int128 oGLiq_,
2035         int128 nGLiq_,
2036         int128[] memory,
2037         int128[] memory
2038     ) {
2039 
2040         uint _length = component.assets.length;
2041         int128[] memory nBals_ = new int128[](_length);
2042         int128[] memory oBals_ = new int128[](_length);
2043 
2044         for (uint i = 0; i < _length; i++) {
2045 
2046             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(component.assets[i].addr);
2047             else {
2048 
2049                 int128 _bal;
2050                 ( amt_, _bal ) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
2051                 amt_ = amt_.neg();
2052 
2053                 oBals_[i] = _bal;
2054                 nBals_[i] = _bal.add(amt_);
2055 
2056             }
2057 
2058             oGLiq_ += oBals_[i];
2059             nGLiq_ += nBals_[i];
2060 
2061         }
2062 
2063         nGLiq_ = nGLiq_.sub(amt_);
2064         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
2065 
2066 
2067         return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );
2068 
2069     }
2070 
2071   function settleProtocolShare(
2072     ComponentStorage.Component storage component,
2073     address _assim,
2074     int128 _amt
2075   ) internal {
2076 
2077     int128 _prtclShr = _amt.us_mul(component.epsilon.us_mul(component.sigma));
2078 
2079     if (_prtclShr.abs() > 0) {
2080 
2081       Assimilators.outputNumeraire(_assim, component.protocol, _prtclShr);
2082 
2083     }
2084 
2085   }
2086 
2087 }
2088 
2089 // This program is free software: you can redistribute it and/or modify
2090 // it under the terms of the GNU General Public License as published by
2091 // the Free Software Foundation, either version 3 of the License, or
2092 // (at your option) any later version.
2093 
2094 // This program is distributed in the hope that it will be useful,
2095 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2096 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2097 // GNU General Public License for more details.
2098 
2099 // You should have received a copy of the GNU General Public License
2100 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2101 
2102 library ViewLiquidity {
2103 
2104     using ABDKMath64x64 for int128;
2105 
2106     function viewLiquidity (
2107         ComponentStorage.Component storage component
2108     ) external view returns (
2109         uint total_,
2110         uint[] memory individual_
2111     ) {
2112 
2113         uint _length = component.assets.length;
2114 
2115         individual_ = new uint[](_length);
2116 
2117         for (uint i = 0; i < _length; i++) {
2118 
2119             uint _liquidity = Assimilators.viewNumeraireBalance(component.assets[i].addr).mulu(1e18);
2120 
2121             total_ += _liquidity;
2122             individual_[i] = _liquidity;
2123 
2124         }
2125 
2126     }
2127 
2128 }
2129 
2130 // This program is free software: you can redistribute it and/or modify
2131 // it under the terms of the GNU General Public License as published by
2132 // the Free Software Foundation, either version 3 of the License, or
2133 // (at your option) any later version.
2134 
2135 // This program is distributed in the hope that it will be useful,
2136 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2137 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2138 // GNU General Public License for more details.
2139 
2140 // You should have received a copy of the GNU General Public License
2141 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2142 
2143 contract ComponentStorage {
2144 
2145     address public owner;
2146 
2147     string  public constant name = "Component LP Token";
2148     string  public constant symbol = "CMP-LP";
2149     uint8   public constant decimals = 18;
2150 
2151     Component public component;
2152 
2153     struct Component {
2154         int128 alpha;
2155         int128 beta;
2156         int128 delta;
2157         int128 epsilon;
2158         int128 lambda;
2159         int128 sigma;
2160         int128[] weights;
2161         uint totalSupply;
2162         address protocol;
2163         Assimilator[] assets;
2164         mapping (address => Assimilator) assimilators;
2165         mapping (address => uint) balances;
2166         mapping (address => mapping (address => uint)) allowances;
2167     }
2168 
2169     struct Assimilator {
2170         address addr;
2171         uint8 ix;
2172     }
2173 
2174     mapping (address => PartitionTicket) public partitionTickets;
2175 
2176     struct PartitionTicket {
2177         uint[] claims;
2178         bool initialized;
2179     }
2180 
2181     address[] public derivatives;
2182     address[] public numeraires;
2183     address[] public reserves;
2184 
2185     bool public partitioned = false;
2186 
2187     bool public frozen = false;
2188 
2189     bool internal notEntered = true;
2190 
2191 }
2192 
2193 // This program is free software: you can redistribute it and/or modify
2194 // it under the terms of the GNU General Public License as published by
2195 // the Free Software Foundation, either version 3 of the License, or
2196 // (at your option) any later version.
2197 
2198 // This program is distributed in the hope that it will be useful,
2199 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2200 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2201 // GNU General Public License for more details.
2202 
2203 // You should have received a copy of the GNU General Public License
2204 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2205 
2206 library ComponentMath {
2207 
2208     int128 constant ONE = 0x10000000000000000;
2209     int128 constant MAX = 0x4000000000000000; // .25 in layman's terms
2210     int128 constant MAX_DIFF = -0x10C6F7A0B5EE;
2211     int128 constant ONE_WEI = 0x12;
2212 
2213     using ABDKMath64x64 for int128;
2214     using UnsafeMath64x64 for int128;
2215     using ABDKMath64x64 for uint256;
2216 
2217     function calculateFee (
2218         int128 _gLiq,
2219         int128[] memory _bals,
2220         int128 _beta,
2221         int128 _delta,
2222         int128[] memory _weights
2223     ) internal pure returns (int128 psi_) {
2224 
2225         uint _length = _bals.length;
2226 
2227         for (uint i = 0; i < _length; i++) {
2228 
2229             int128 _ideal = _gLiq.us_mul(_weights[i]);
2230 
2231             psi_ += calculateMicroFee(_bals[i], _ideal, _beta, _delta);
2232 
2233         }
2234 
2235     }
2236 
2237     function calculateMicroFee (
2238         int128 _bal,
2239         int128 _ideal,
2240         int128 _beta,
2241         int128 _delta
2242     ) private pure returns (int128 fee_) {
2243 
2244         if (_bal < _ideal) {
2245 
2246             int128 _threshold = _ideal.us_mul(ONE - _beta);
2247 
2248             if (_bal < _threshold) {
2249 
2250                 int128 _feeMargin = _threshold - _bal;
2251 
2252                 fee_ = _feeMargin.us_div(_ideal);
2253                 fee_ = fee_.us_mul(_delta);
2254 
2255                 if (fee_ > MAX) fee_ = MAX;
2256 
2257                 fee_ = fee_.us_mul(_feeMargin);
2258 
2259             } else fee_ = 0;
2260 
2261         } else {
2262 
2263             int128 _threshold = _ideal.us_mul(ONE + _beta);
2264 
2265             if (_bal > _threshold) {
2266 
2267                 int128 _feeMargin = _bal - _threshold;
2268 
2269                 fee_ = _feeMargin.us_div(_ideal);
2270                 fee_ = fee_.us_mul(_delta);
2271 
2272                 if (fee_ > MAX) fee_ = MAX;
2273 
2274                 fee_ = fee_.us_mul(_feeMargin);
2275 
2276             } else fee_ = 0;
2277 
2278         }
2279 
2280     }
2281 
2282     function calculateTrade (
2283         ComponentStorage.Component storage component,
2284         int128 _oGLiq,
2285         int128 _nGLiq,
2286         int128[] memory _oBals,
2287         int128[] memory _nBals,
2288         int128 _inputAmt,
2289         uint _outputIndex
2290     ) internal view returns (int128 outputAmt_) {
2291 
2292         outputAmt_ = - _inputAmt;
2293 
2294         int128 _lambda = component.lambda;
2295         int128 _beta = component.beta;
2296         int128 _delta = component.delta;
2297         int128[] memory _weights = component.weights;
2298 
2299         int128 _omega = calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
2300         int128 _psi;
2301 
2302         for (uint i = 0; i < 32; i++) {
2303 
2304             _psi = calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
2305 
2306             if (( outputAmt_ = _omega < _psi
2307                     ? - ( _inputAmt + _omega - _psi )
2308                     : - ( _inputAmt + _lambda.us_mul(_omega - _psi) )
2309                 ) / 1e13 == outputAmt_ / 1e13 ) {
2310 
2311                 _nGLiq = _oGLiq + _inputAmt + outputAmt_;
2312 
2313                 _nBals[_outputIndex] = _oBals[_outputIndex] + outputAmt_;
2314 
2315                 enforceHalts(component, _oGLiq, _nGLiq, _oBals, _nBals, _weights);
2316 
2317                 enforceSwapInvariant(_oGLiq, _omega, _nGLiq, _psi);
2318 
2319                 return outputAmt_;
2320 
2321             } else {
2322 
2323                 _nGLiq = _oGLiq + _inputAmt + outputAmt_;
2324 
2325                 _nBals[_outputIndex] = _oBals[_outputIndex].add(outputAmt_);
2326 
2327             }
2328 
2329         }
2330 
2331         revert("Component/swap-convergence-failed");
2332 
2333     }
2334 
2335     function enforceSwapInvariant (
2336         int128 _oGLiq,
2337         int128 _omega,
2338         int128 _nGLiq,
2339         int128 _psi
2340     ) private pure {
2341 
2342         int128 _nextUtil = _nGLiq - _psi;
2343 
2344         int128 _prevUtil = _oGLiq - _omega;
2345 
2346         int128 _diff = _nextUtil - _prevUtil;
2347 
2348         require(0 < _diff || _diff >= MAX_DIFF, "Component/swap-invariant-violation");
2349 
2350     }
2351 
2352     function calculateLiquidityMembrane (
2353         ComponentStorage.Component storage component,
2354         int128 _oGLiq,
2355         int128 _nGLiq,
2356         int128[] memory _oBals,
2357         int128[] memory _nBals
2358     ) internal view returns (int128 components_) {
2359 
2360         enforceHalts(component, _oGLiq, _nGLiq, _oBals, _nBals, component.weights);
2361 
2362         int128 _omega;
2363         int128 _psi;
2364 
2365         {
2366 
2367             int128 _beta = component.beta;
2368             int128 _delta = component.delta;
2369             int128[] memory _weights = component.weights;
2370 
2371             _omega = calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
2372             _psi = calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
2373 
2374         }
2375 
2376         int128 _feeDiff = _psi.sub(_omega);
2377         int128 _liqDiff = _nGLiq.sub(_oGLiq);
2378         int128 _oUtil = _oGLiq.sub(_omega);
2379         int128 _totalComponents = component.totalSupply.divu(1e18);
2380         int128 _componentMultiplier;
2381 
2382         if (_totalComponents == 0) {
2383 
2384             components_ = _nGLiq.sub(_psi);
2385 
2386         } else if (_feeDiff >= 0) {
2387 
2388             _componentMultiplier = _liqDiff.sub(_feeDiff).div(_oUtil);
2389 
2390         } else {
2391 
2392             _componentMultiplier = _liqDiff.sub(component.lambda.mul(_feeDiff));
2393 
2394             _componentMultiplier = _componentMultiplier.div(_oUtil);
2395 
2396         }
2397 
2398         if (_totalComponents != 0) {
2399 
2400             components_ = _totalComponents.us_mul(_componentMultiplier);
2401 
2402             enforceLiquidityInvariant(_totalComponents, components_, _oGLiq, _nGLiq, _omega, _psi);
2403 
2404         }
2405 
2406     }
2407 
2408     function enforceLiquidityInvariant (
2409         int128 _totalComponents,
2410         int128 _newComponents,
2411         int128 _oGLiq,
2412         int128 _nGLiq,
2413         int128 _omega,
2414         int128 _psi
2415     ) internal pure {
2416 
2417         if (_totalComponents == 0 || 0 == _totalComponents + _newComponents) return;
2418 
2419         int128 _prevUtilPerComponent = _oGLiq
2420             .sub(_omega)
2421             .div(_totalComponents);
2422 
2423         int128 _nextUtilPerComponent = _nGLiq
2424             .sub(_psi)
2425             .div(_totalComponents.add(_newComponents));
2426 
2427         int128 _diff = _nextUtilPerComponent - _prevUtilPerComponent;
2428 
2429         require(0 < _diff || _diff >= MAX_DIFF, "Component/liquidity-invariant-violation");
2430 
2431     }
2432 
2433     function enforceHalts (
2434         ComponentStorage.Component storage component,
2435         int128 _oGLiq,
2436         int128 _nGLiq,
2437         int128[] memory _oBals,
2438         int128[] memory _nBals,
2439         int128[] memory _weights
2440     ) private view {
2441 
2442         uint256 _length = _nBals.length;
2443         int128 _alpha = component.alpha;
2444 
2445         for (uint i = 0; i < _length; i++) {
2446 
2447             int128 _nIdeal = _nGLiq.us_mul(_weights[i]);
2448 
2449             if (_nBals[i] > _nIdeal) {
2450 
2451                 int128 _upperAlpha = ONE + _alpha;
2452 
2453                 int128 _nHalt = _nIdeal.us_mul(_upperAlpha);
2454 
2455                 if (_nBals[i] > _nHalt){
2456 
2457                     int128 _oHalt = _oGLiq.us_mul(_weights[i]).us_mul(_upperAlpha);
2458 
2459                     if (_oBals[i] < _oHalt) revert("Component/upper-halt");
2460                     if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("Component/upper-halt");
2461 
2462                 }
2463 
2464             } else {
2465 
2466                 int128 _lowerAlpha = ONE - _alpha;
2467 
2468                 int128 _nHalt = _nIdeal.us_mul(_lowerAlpha);
2469 
2470                 if (_nBals[i] < _nHalt){
2471 
2472                     int128 _oHalt = _oGLiq.us_mul(_weights[i]).us_mul(_lowerAlpha);
2473 
2474                     if (_oBals[i] > _oHalt) revert("Component/lower-halt");
2475                     if (_nHalt - _nBals[i] > _oHalt - _oBals[i]) revert("Component/lower-halt");
2476 
2477                 }
2478             }
2479         }
2480     }
2481 }
2482 ////// src/Orchestrator.sol
2483 // This program is free software: you can redistribute it and/or modify
2484 // it under the terms of the GNU General Public License as published by
2485 // the Free Software Foundation, either version 3 of the License, or
2486 // (at your option) any later version.
2487 
2488 // This program is distributed in the hope that it will be useful,
2489 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2490 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2491 // GNU General Public License for more details.
2492 
2493 // You should have received a copy of the GNU General Public License
2494 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2495 
2496 library Orchestrator {
2497 
2498     using ABDKMath64x64 for int128;
2499     using ABDKMath64x64 for uint256;
2500 
2501     int128 constant ONE_WEI = 0x12;
2502 
2503     event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);
2504 
2505     event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);
2506 
2507     event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);
2508 
2509     function setParams (
2510         ComponentStorage.Component storage component,
2511         uint256 _alpha,
2512         uint256 _beta,
2513         uint256 _feeAtHalt,
2514         uint256 _epsilon,
2515         uint256 _lambda,
2516         uint256 _sigma,
2517         address _protocol
2518     ) external {
2519 
2520         require(0 < _alpha && _alpha < 1e18, "Component/parameter-invalid-alpha");
2521 
2522         require(0 <= _beta && _beta < _alpha, "Component/parameter-invalid-beta");
2523 
2524         require(_feeAtHalt <= .5e18, "Component/parameter-invalid-max");
2525 
2526         require(0 <= _epsilon && _epsilon <= .02e18, "Component/parameter-invalid-epsilon");
2527 
2528         require(0 <= _lambda && _lambda <= 1e18, "Component/parameter-invalid-lambda");
2529 
2530         require(0 <= _sigma && _sigma <= .5e18, "Component/parameter-invalid-sigma");
2531 
2532         require(_protocol != address(0), "Component/parameter-invalid-protocol");
2533 
2534         int128 _omega = getFee(component);
2535 
2536         component.alpha = (_alpha + 1).divu(1e18);
2537 
2538         component.beta = (_beta + 1).divu(1e18);
2539 
2540         component.delta = ( _feeAtHalt ).divu(1e18).div(uint(2).fromUInt().mul(component.alpha.sub(component.beta))) + ONE_WEI;
2541 
2542         component.epsilon = (_epsilon + 1).divu(1e18);
2543 
2544         component.lambda = (_lambda + 1).divu(1e18);
2545 
2546         component.sigma = (_sigma + 1).divu(1e18);
2547 
2548         component.protocol = _protocol;
2549 
2550         int128 _psi = getFee(component);
2551 
2552         require(_omega >= _psi, "Component/parameters-increase-fee");
2553 
2554         emit ParametersSet(_alpha, _beta, component.delta.mulu(1e18), _epsilon, _lambda);
2555 
2556     }
2557 
2558     function getFee (
2559         ComponentStorage.Component storage component
2560     ) private view returns (
2561         int128 fee_
2562     ) {
2563 
2564         int128 _gLiq;
2565 
2566         int128[] memory _bals = new int128[](component.assets.length);
2567 
2568         for (uint i = 0; i < _bals.length; i++) {
2569 
2570             int128 _bal = Assimilators.viewNumeraireBalance(component.assets[i].addr);
2571 
2572             _bals[i] = _bal;
2573 
2574             _gLiq += _bal;
2575 
2576         }
2577 
2578         fee_ = ComponentMath.calculateFee(_gLiq, _bals, component.beta, component.delta, component.weights);
2579 
2580     }
2581 
2582 
2583     function initialize (
2584         ComponentStorage.Component storage component,
2585         address[] storage numeraires,
2586         address[] storage reserves,
2587         address[] storage derivatives,
2588         address[] calldata _assets,
2589         uint[] calldata _assetWeights,
2590         address[] calldata _derivativeAssimilators
2591     ) external {
2592 
2593         for (uint i = 0; i < _assetWeights.length; i++) {
2594 
2595             uint ix = i*5;
2596 
2597             numeraires.push(_assets[ix]);
2598             derivatives.push(_assets[ix]);
2599 
2600             reserves.push(_assets[2+ix]);
2601             if (_assets[ix] != _assets[2+ix]) derivatives.push(_assets[2+ix]);
2602 
2603             includeAsset(
2604                 component,
2605                 _assets[ix],   // numeraire
2606                 _assets[1+ix], // numeraire assimilator
2607                 _assets[2+ix], // reserve
2608                 _assets[3+ix], // reserve assimilator
2609                 _assets[4+ix], // reserve approve to
2610                 _assetWeights[i]
2611             );
2612 
2613         }
2614 
2615         for (uint i = 0; i < _derivativeAssimilators.length / 5; i++) {
2616 
2617             uint ix = i * 5;
2618 
2619             derivatives.push(_derivativeAssimilators[ix]);
2620 
2621             includeAssimilator(
2622                 component,
2623                 _derivativeAssimilators[ix],   // derivative
2624                 _derivativeAssimilators[1+ix], // numeraire
2625                 _derivativeAssimilators[2+ix], // reserve
2626                 _derivativeAssimilators[3+ix], // assimilator
2627                 _derivativeAssimilators[4+ix]  // derivative approve to
2628             );
2629 
2630         }
2631 
2632     }
2633 
2634     function includeAsset (
2635         ComponentStorage.Component storage component,
2636         address _numeraire,
2637         address _numeraireAssim,
2638         address _reserve,
2639         address _reserveAssim,
2640         address _reserveApproveTo,
2641         uint256 _weight
2642     ) private {
2643 
2644         require(_numeraire != address(0), "Component/numeraire-cannot-be-zeroth-adress");
2645 
2646         require(_numeraireAssim != address(0), "Component/numeraire-assimilator-cannot-be-zeroth-adress");
2647 
2648         require(_reserve != address(0), "Component/reserve-cannot-be-zeroth-adress");
2649 
2650         require(_reserveAssim != address(0), "Component/reserve-assimilator-cannot-be-zeroth-adress");
2651 
2652         require(_weight < 1e18, "Component/weight-must-be-less-than-one");
2653 
2654         if (_numeraire != _reserve) safeApprove(_numeraire, _reserveApproveTo, uint(-1));
2655 
2656         ComponentStorage.Assimilator storage _numeraireAssimilator = component.assimilators[_numeraire];
2657 
2658         _numeraireAssimilator.addr = _numeraireAssim;
2659 
2660         _numeraireAssimilator.ix = uint8(component.assets.length);
2661 
2662         ComponentStorage.Assimilator storage _reserveAssimilator = component.assimilators[_reserve];
2663 
2664         _reserveAssimilator.addr = _reserveAssim;
2665 
2666         _reserveAssimilator.ix = uint8(component.assets.length);
2667 
2668         int128 __weight = _weight.divu(1e18).add(uint256(1).divu(1e18));
2669 
2670         component.weights.push(__weight);
2671 
2672         component.assets.push(_numeraireAssimilator);
2673 
2674         emit AssetIncluded(_numeraire, _reserve, _weight);
2675 
2676         emit AssimilatorIncluded(_numeraire, _numeraire, _reserve, _numeraireAssim);
2677 
2678         if (_numeraireAssim != _reserveAssim) {
2679 
2680             emit AssimilatorIncluded(_reserve, _numeraire, _reserve, _reserveAssim);
2681 
2682         }
2683 
2684     }
2685 
2686     function includeAssimilator (
2687         ComponentStorage.Component storage component,
2688         address _derivative,
2689         address _numeraire,
2690         address _reserve,
2691         address _assimilator,
2692         address _derivativeApproveTo
2693     ) private {
2694 
2695         require(_derivative != address(0), "Component/derivative-cannot-be-zeroth-address");
2696 
2697         require(_numeraire != address(0), "Component/numeraire-cannot-be-zeroth-address");
2698 
2699         require(_reserve != address(0), "Component/numeraire-cannot-be-zeroth-address");
2700 
2701         require(_assimilator != address(0), "Component/assimilator-cannot-be-zeroth-address");
2702 
2703         safeApprove(_numeraire, _derivativeApproveTo, uint(-1));
2704 
2705         ComponentStorage.Assimilator storage _numeraireAssim = component.assimilators[_numeraire];
2706 
2707         component.assimilators[_derivative] = ComponentStorage.Assimilator(_assimilator, _numeraireAssim.ix);
2708 
2709         emit AssimilatorIncluded(_derivative, _numeraire, _reserve, _assimilator);
2710 
2711     }
2712 
2713     function safeApprove (
2714         address _token,
2715         address _spender,
2716         uint256 _value
2717     ) private {
2718 
2719         ( bool success, ) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
2720 
2721         require(success, "SafeERC20: low-level call failed");
2722 
2723     }
2724 
2725     function viewComponent(
2726         ComponentStorage.Component storage component
2727     ) external view returns (
2728         uint alpha_,
2729         uint beta_,
2730         uint delta_,
2731         uint epsilon_,
2732         uint lambda_
2733     ) {
2734 
2735         alpha_ = component.alpha.mulu(1e18);
2736 
2737         beta_ = component.beta.mulu(1e18);
2738 
2739         delta_ = component.delta.mulu(1e18);
2740 
2741         epsilon_ = component.epsilon.mulu(1e18);
2742 
2743         lambda_ = component.lambda.mulu(1e18);
2744 
2745     }
2746 
2747 }
2748 
2749 interface IFreeFromUpTo {
2750     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
2751 }
2752 
2753 // This program is free software: you can redistribute it and/or modify
2754 // it under the terms of the GNU General Public License as published by
2755 // the Free Software Foundation, either version 3 of the License, or
2756 // (at your option) any later version.
2757 
2758 // This program is distributed in the hope that it will be useful,
2759 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2760 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2761 // GNU General Public License for more details.
2762 
2763 // You should have received a copy of the GNU General Public License
2764 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2765 
2766 contract Component is ComponentStorage {
2767 
2768     event Approval(address indexed _owner, address indexed spender, uint256 value);
2769 
2770     event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);
2771 
2772     event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);
2773 
2774     event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);
2775 
2776     event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);
2777 
2778     event PoolPartitioned(bool partitioned);
2779 
2780     event OwnershipTransfered(address indexed previousOwner, address indexed newOwner);
2781 
2782     event FrozenSet(bool isFrozen);
2783 
2784     event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
2785 
2786     event Transfer(address indexed from, address indexed to, uint256 value);
2787 
2788     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
2789 
2790     modifier discountCHI {
2791         uint256 gasStart = gasleft();
2792         _;
2793         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
2794         chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
2795     }
2796 
2797     modifier onlyOwner() {
2798 
2799         require(msg.sender == owner, "Component/caller-is-not-owner");
2800         _;
2801 
2802     }
2803 
2804     modifier nonReentrant() {
2805 
2806         require(notEntered, "Component/re-entered");
2807         notEntered = false;
2808         _;
2809         notEntered = true;
2810 
2811     }
2812 
2813     modifier transactable () {
2814 
2815         require(!frozen, "Component/frozen-only-allowing-proportional-withdraw");
2816         _;
2817 
2818     }
2819 
2820     modifier unpartitioned () {
2821 
2822         require(!partitioned, "Component/pool-partitioned");
2823         _;
2824 
2825     }
2826 
2827     modifier isPartitioned () {
2828 
2829         require(partitioned, "Component/pool-not-partitioned");
2830         _;
2831 
2832     }
2833 
2834     modifier deadline (uint _deadline) {
2835 
2836         require(block.timestamp < _deadline, "Component/tx-deadline-passed");
2837         _;
2838 
2839     }
2840 
2841     constructor (
2842         address[] memory _assets,
2843         uint[] memory _assetWeights,
2844         address[] memory _derivativeAssimilators
2845     ) public {
2846 
2847         owner = msg.sender;
2848         emit OwnershipTransfered(address(0), msg.sender);
2849 
2850         Orchestrator.initialize(
2851             component,
2852             numeraires,
2853             reserves,
2854             derivatives,
2855             _assets,
2856             _assetWeights,
2857             _derivativeAssimilators
2858         );
2859 
2860     }
2861 
2862     /// @notice sets the parameters for the pool
2863     /// @param _alpha the value for alpha (halt threshold) must be less than or equal to 1 and greater than 0
2864     /// @param _beta the value for beta must be less than alpha and greater than 0
2865     /// @param _feeAtHalt the maximum value for the fee at the halt point
2866     /// @param _epsilon the base fee for the pool
2867     /// @param _lambda the value for lambda must be less than or equal to 1 and greater than zero
2868     /// @param _sigma the protocol fee for the pool
2869     /// @param _protocol the protocol fee distribution address
2870     function setParams (
2871         uint _alpha,
2872         uint _beta,
2873         uint _feeAtHalt,
2874         uint _epsilon,
2875         uint _lambda,
2876         uint _sigma,
2877         address _protocol
2878     ) external onlyOwner {
2879 
2880         Orchestrator.setParams(component, _alpha, _beta, _feeAtHalt, _epsilon, _lambda, _sigma, _protocol);
2881 
2882     }
2883 
2884     /// @notice excludes an assimilator from the component
2885     /// @param _derivative the address of the assimilator to exclude
2886     function excludeDerivative (
2887         address _derivative
2888     ) external onlyOwner {
2889 
2890         for (uint i = 0; i < numeraires.length; i++) {
2891 
2892             if (_derivative == numeraires[i]) revert("Component/cannot-delete-numeraire");
2893             if (_derivative == reserves[i]) revert("Component/cannot-delete-reserve");
2894 
2895         }
2896 
2897         delete component.assimilators[_derivative];
2898 
2899     }
2900 
2901     /// @notice view the current parameters of the component
2902     /// @return alpha_ the current alpha value
2903     /// @return beta_ the current beta value
2904     /// @return delta_ the current delta value
2905     /// @return epsilon_ the current epsilon value
2906     /// @return lambda_ the current lambda value
2907     /// @return omega_ the current omega value
2908     function viewComponent() external view returns (
2909         uint alpha_,
2910         uint beta_,
2911         uint delta_,
2912         uint epsilon_,
2913         uint lambda_
2914     ) {
2915 
2916         return Orchestrator.viewComponent(component);
2917 
2918     }
2919 
2920     function setFrozen (bool _toFreezeOrNotToFreeze) external onlyOwner {
2921 
2922         emit FrozenSet(_toFreezeOrNotToFreeze);
2923 
2924         frozen = _toFreezeOrNotToFreeze;
2925 
2926     }
2927 
2928     function transferOwnership (address _newOwner) external onlyOwner {
2929 
2930         emit OwnershipTransfered(owner, _newOwner);
2931 
2932         owner = _newOwner;
2933 
2934     }
2935 
2936     /// @author james foley http://github.com/realisation
2937     /// @notice swap a dynamic origin amount for a fixed target amount
2938     /// @param _origin the address of the origin
2939     /// @param _target the address of the target
2940     /// @param _originAmount the origin amount
2941     /// @param _minTargetAmount the minimum target amount
2942     /// @param _deadline deadline in block number after which the trade will not execute
2943     /// @return targetAmount_ the amount of target that has been swapped for the origin amount
2944     function originSwap (
2945         address _origin,
2946         address _target,
2947         uint _originAmount,
2948         uint _minTargetAmount,
2949         uint _deadline
2950     ) external deadline(_deadline) transactable nonReentrant returns (
2951         uint targetAmount_
2952     ) {
2953 
2954         targetAmount_ = Swaps.originSwap(component, _origin, _target, _originAmount, msg.sender);
2955 
2956         require(targetAmount_ > _minTargetAmount, "Component/below-min-target-amount");
2957 
2958     }
2959 
2960     function originSwapDiscountCHI (
2961         address _origin,
2962         address _target,
2963         uint _originAmount,
2964         uint _minTargetAmount,
2965         uint _deadline
2966     ) external deadline(_deadline) transactable nonReentrant discountCHI returns (
2967         uint targetAmount_
2968     ) {
2969 
2970         targetAmount_ = Swaps.originSwap(component, _origin, _target, _originAmount, msg.sender);
2971 
2972         require(targetAmount_ > _minTargetAmount, "Component/below-min-target-amount");
2973 
2974     }
2975 
2976     /// @author james foley http://github.com/realisation
2977     /// @notice view how much target amount a fixed origin amount will swap for
2978     /// @param _origin the address of the origin
2979     /// @param _target the address of the target
2980     /// @param _originAmount the origin amount
2981     /// @return targetAmount_ the target amount that would have been swapped for the origin amount
2982     function viewOriginSwap (
2983         address _origin,
2984         address _target,
2985         uint _originAmount
2986     ) external view transactable returns (
2987         uint targetAmount_
2988     ) {
2989 
2990         targetAmount_ = Swaps.viewOriginSwap(component, _origin, _target, _originAmount);
2991 
2992     }
2993 
2994     /// @author james foley http://github.com/realisation
2995     /// @notice swap a dynamic origin amount for a fixed target amount
2996     /// @param _origin the address of the origin
2997     /// @param _target the address of the target
2998     /// @param _maxOriginAmount the maximum origin amount
2999     /// @param _targetAmount the target amount
3000     /// @param _deadline deadline in block number after which the trade will not execute
3001     /// @return originAmount_ the amount of origin that has been swapped for the target
3002     function targetSwap (
3003         address _origin,
3004         address _target,
3005         uint _maxOriginAmount,
3006         uint _targetAmount,
3007         uint _deadline
3008     ) external deadline(_deadline) transactable nonReentrant returns (
3009         uint originAmount_
3010     ) {
3011 
3012         originAmount_ = Swaps.targetSwap(component, _origin, _target, _targetAmount, msg.sender);
3013 
3014         require(originAmount_ < _maxOriginAmount, "Component/above-max-origin-amount");
3015 
3016     }
3017 
3018     /// @author james foley http://github.com/realisation
3019     /// @notice view how much of the origin currency the target currency will take
3020     /// @param _origin the address of the origin
3021     /// @param _target the address of the target
3022     /// @param _targetAmount the target amount
3023     /// @return originAmount_ the amount of target that has been swapped for the origin
3024     function viewTargetSwap (
3025         address _origin,
3026         address _target,
3027         uint _targetAmount
3028     ) external view transactable returns (
3029         uint originAmount_
3030     ) {
3031 
3032         originAmount_ = Swaps.viewTargetSwap(component, _origin, _target, _targetAmount);
3033 
3034     }
3035 
3036     /// @author james foley http://github.com/realisation
3037     /// @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of component tokens
3038     /// @param _derivatives an array containing the addresses of the flavors being deposited into
3039     /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
3040     /// @param _minComponents minimum acceptable amount of components
3041     /// @param _deadline deadline for tx
3042     /// @return componentsToMint_ the amount of components to mint for the deposited stablecoin flavors
3043     function selectiveDeposit (
3044         address[] calldata _derivatives,
3045         uint[] calldata _amounts,
3046         uint _minComponents,
3047         uint _deadline
3048     ) external deadline(_deadline) transactable nonReentrant returns (
3049         uint componentsMinted_
3050     ) {
3051 
3052         componentsMinted_ = SelectiveLiquidity.selectiveDeposit(component, _derivatives, _amounts, _minComponents);
3053 
3054     }
3055 
3056     /// @author james folew http://github.com/realisation
3057     /// @notice view how many component tokens a deposit will mint
3058     /// @param _derivatives an array containing the addresses of the flavors being deposited into
3059     /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
3060     /// @return componentsToMint_ the amount of components to mint for the deposited stablecoin flavors
3061     function viewSelectiveDeposit (
3062         address[] calldata _derivatives,
3063         uint[] calldata _amounts
3064     ) external view transactable returns (
3065         uint componentsToMint_
3066     ) {
3067 
3068         componentsToMint_ = SelectiveLiquidity.viewSelectiveDeposit(component, _derivatives, _amounts);
3069 
3070     }
3071 
3072     /// @author james foley http://github.com/realisation
3073     /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
3074     /// @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
3075     /// @return componentsToMint_ the amount of components you receive in return for your deposit
3076     /// @return deposits_ the amount deposited for each numeraire
3077     function proportionalDeposit (
3078         uint _deposit,
3079         uint _deadline
3080     ) external deadline(_deadline) transactable nonReentrant returns (
3081         uint componentsMinted_,
3082         uint[] memory deposits_
3083     ) {
3084 
3085         return ProportionalLiquidity.proportionalDeposit(component, _deposit);
3086 
3087     }
3088 
3089     /// @author james foley http://github.com/realisation
3090     /// @notice view deposits and components minted a given deposit would return
3091     /// @param _deposit the full amount of stablecoins you want to deposit. Divided evenly according to the prevailing proportions of the numeraire assets of the pool
3092     /// @return componentsToMint_ the amount of components you receive in return for your deposit
3093     /// @return deposits_ the amount deposited for each numeraire
3094     function viewProportionalDeposit (
3095         uint _deposit
3096     ) external view transactable returns (
3097         uint componentsToMint_,
3098         uint[] memory depositsToMake_
3099     ) {
3100 
3101         return ProportionalLiquidity.viewProportionalDeposit(component, _deposit);
3102 
3103     }
3104 
3105     /// @author james foley http://github.com/realisation
3106     /// @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of component tokens
3107     /// @param _derivatives an array of flavors to withdraw from the reserves
3108     /// @param _amounts an array of amounts to withdraw that maps to _flavors
3109     /// @param _maxComponents the maximum amount of components you want to burn
3110     /// @param _deadline timestamp after which the transaction is no longer valid
3111     /// @return componentsBurned_ the corresponding amount of component tokens to withdraw the specified amount of specified flavors
3112     function selectiveWithdraw (
3113         address[] calldata _derivatives,
3114         uint[] calldata _amounts,
3115         uint _maxComponents,
3116         uint _deadline
3117     ) external deadline(_deadline) transactable nonReentrant returns (
3118         uint componentsBurned_
3119     ) {
3120 
3121         componentsBurned_ = SelectiveLiquidity.selectiveWithdraw(component, _derivatives, _amounts, _maxComponents);
3122 
3123     }
3124 
3125     /// @author james foley http://github.com/realisation
3126     /// @notice view how many component tokens a withdraw will consume
3127     /// @param _derivatives an array of flavors to withdraw from the reserves
3128     /// @param _amounts an array of amounts to withdraw that maps to _flavors
3129     /// @return componentsBurned_ the corresponding amount of component tokens to withdraw the specified amount of specified flavors
3130     function viewSelectiveWithdraw (
3131         address[] calldata _derivatives,
3132         uint[] calldata _amounts
3133     ) external view transactable returns (
3134         uint componentsToBurn_
3135     ) {
3136 
3137         componentsToBurn_ = SelectiveLiquidity.viewSelectiveWithdraw(component, _derivatives, _amounts);
3138 
3139     }
3140 
3141     /// @author  james foley http://github.com/realisation
3142     /// @notice  withdrawas amount of component tokens from the the pool equally from the numeraire assets of the pool with no slippage
3143     /// @param   _componentsToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
3144     /// @return withdrawals_ the amonts of numeraire assets withdrawn from the pool
3145     function proportionalWithdraw (
3146         uint _componentsToBurn,
3147         uint _deadline
3148     ) external deadline(_deadline) unpartitioned nonReentrant returns (
3149         uint[] memory withdrawals_
3150     ) {
3151 
3152         return ProportionalLiquidity.proportionalWithdraw(component, _componentsToBurn);
3153 
3154     }
3155 
3156     function supportsInterface (
3157         bytes4 _interface
3158     ) public pure returns (
3159         bool supports_
3160     ) {
3161 
3162         supports_ = this.supportsInterface.selector == _interface  // erc165
3163             || bytes4(0x7f5828d0) == _interface                   // eip173
3164             || bytes4(0x36372b07) == _interface;                 // erc20
3165 
3166     }
3167 
3168     /// @author  james foley http://github.com/realisation
3169     /// @notice  withdrawals amount of component tokens from the the pool equally from the numeraire assets of the pool with no slippage
3170     /// @param   _componentsToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
3171     /// @return withdrawalsToHappen_ the amonts of numeraire assets withdrawn from the pool
3172     function viewProportionalWithdraw (
3173         uint _componentsToBurn
3174     ) external view unpartitioned returns (
3175         uint[] memory withdrawalsToHappen_
3176     ) {
3177 
3178         return ProportionalLiquidity.viewProportionalWithdraw(component, _componentsToBurn);
3179 
3180     }
3181 
3182     function partition () external onlyOwner {
3183 
3184         require(frozen, "Component/must-be-frozen");
3185 
3186         PartitionedLiquidity.partition(component, partitionTickets);
3187 
3188         partitioned = true;
3189 
3190     }
3191 
3192     /// @author  james foley http://github.com/realisation
3193     /// @notice  withdraws amount of component tokens from the the pool equally from the numeraire assets of the pool with no slippage
3194     /// @param _tokens an array of the numeraire assets you will withdraw
3195     /// @param _amounts an array of the amounts in terms of partitioned shels you want to withdraw from that numeraire partition
3196     /// @return withdrawals_ the amounts of the numeraire assets withdrawn
3197     function partitionedWithdraw (
3198         address[] calldata _tokens,
3199         uint256[] calldata _amounts
3200     ) external isPartitioned returns (
3201         uint256[] memory withdrawals_
3202     ) {
3203 
3204         return PartitionedLiquidity.partitionedWithdraw(component, partitionTickets, _tokens, _amounts);
3205 
3206     }
3207 
3208     /// @author  james foley http://github.com/realisation
3209     /// @notice  views the balance of the users partition ticket
3210     /// @param _addr the address whose balances in partitioned components to be seen
3211     /// @return claims_ the remaining claims in terms of partitioned components the address has in its partition ticket
3212     function viewPartitionClaims (
3213         address _addr
3214     ) external view isPartitioned returns (
3215         uint[] memory claims_
3216     ) {
3217 
3218         return PartitionedLiquidity.viewPartitionClaims(component, partitionTickets, _addr);
3219 
3220     }
3221 
3222     /// @notice transfers component tokens
3223     /// @param _recipient the address of where to send the component tokens
3224     /// @param _amount the amount of component tokens to send
3225     /// @return success_ the success bool of the call
3226     function transfer (
3227         address _recipient,
3228         uint _amount
3229     ) public nonReentrant returns (
3230         bool success_
3231     ) {
3232 
3233         require(!partitionTickets[msg.sender].initialized, "Component/no-transfers-once-partitioned");
3234 
3235         success_ = Components.transfer(component, _recipient, _amount);
3236 
3237     }
3238 
3239     /// @notice transfers component tokens from one address to another address
3240     /// @param _sender the account from which the component tokens will be sent
3241     /// @param _recipient the account to which the component tokens will be sent
3242     /// @param _amount the amount of component tokens to transfer
3243     /// @return success_ the success bool of the call
3244     function transferFrom (
3245         address _sender,
3246         address _recipient,
3247         uint _amount
3248     ) public nonReentrant returns (
3249         bool success_
3250     ) {
3251 
3252         require(!partitionTickets[_sender].initialized, "Component/no-transfers-once-partitioned");
3253 
3254         success_ = Components.transferFrom(component, _sender, _recipient, _amount);
3255 
3256     }
3257 
3258     /// @notice approves a user to spend component tokens on their behalf
3259     /// @param _spender the account to allow to spend from msg.sender
3260     /// @param _amount the amount to specify the spender can spend
3261     /// @return success_ the success bool of this call
3262     function approve (address _spender, uint _amount) public nonReentrant returns (bool success_) {
3263 
3264         success_ = Components.approve(component, _spender, _amount);
3265 
3266     }
3267 
3268     /// @notice view the component token balance of a given account
3269     /// @param _account the account to view the balance of
3270     /// @return balance_ the component token ballance of the given account
3271     function balanceOf (
3272         address _account
3273     ) public view returns (
3274         uint balance_
3275     ) {
3276 
3277         balance_ = component.balances[_account];
3278 
3279     }
3280 
3281     /// @notice views the total component supply of the pool
3282     /// @return totalSupply_ the total supply of component tokens
3283     function totalSupply () public view returns (uint totalSupply_) {
3284 
3285         totalSupply_ = component.totalSupply;
3286 
3287     }
3288 
3289     /// @notice views the total allowance one address has to spend from another address
3290     /// @param _owner the address of the owner
3291     /// @param _spender the address of the spender
3292     /// @return allowance_ the amount the owner has allotted the spender
3293     function allowance (
3294         address _owner,
3295         address _spender
3296     ) public view returns (
3297         uint allowance_
3298     ) {
3299 
3300         allowance_ = component.allowances[_owner][_spender];
3301 
3302     }
3303 
3304     /// @notice views the total amount of liquidity in the component in numeraire value and format - 18 decimals
3305     /// @return total_ the total value in the component
3306     /// @return individual_ the individual values in the component
3307     function liquidity () public view returns (
3308         uint total_,
3309         uint[] memory individual_
3310     ) {
3311 
3312         return ViewLiquidity.viewLiquidity(component);
3313 
3314     }
3315 
3316     /// @notice view the assimilator address for a derivative
3317     /// @return assimilator_ the assimilator address
3318     function assimilator (
3319         address _derivative
3320     ) public view returns (
3321         address assimilator_
3322     ) {
3323 
3324         assimilator_ = component.assimilators[_derivative].addr;
3325 
3326     }
3327 
3328 }