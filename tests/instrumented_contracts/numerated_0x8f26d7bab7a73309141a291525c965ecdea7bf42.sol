1 // hevm: flattened sources of src/Shell.sol
2 pragma solidity >0.4.13 >=0.4.23 >=0.5.0 <0.6.0 >=0.5.7 <0.6.0;
3 
4 ////// lib/abdk-libraries-solidity/src/ABDKMath64x64.sol
5 /*
6  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
7  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
8  */
9 /* pragma solidity ^0.5.7; */
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
718 /* pragma solidity ^0.5.0; */
719 
720 interface IAssimilator {
721     function intakeRaw (uint256 amount) external returns (int128);
722     function intakeRawAndGetBalance (uint256 amount) external returns (int128, int128);
723     function intakeNumeraire (int128 amount) external returns (uint256);
724     function outputRaw (address dst, uint256 amount) external returns (int128);
725     function outputRawAndGetBalance (address dst, uint256 amount) external returns (int128, int128);
726     function outputNumeraire (address dst, int128 amount) external returns (uint256);
727     function viewRawAmount (int128) external view returns (uint256);
728     function viewNumeraireAmount (uint256) external view returns (int128);
729     function viewNumeraireBalance (address) external view returns (int128);
730     function viewNumeraireAmountAndBalance (address, uint256) external view returns (int128, int128);
731 }
732 ////// src/Assimilators.sol
733 // This program is free software: you can redistribute it and/or modify
734 // it under the terms of the GNU General Public License as published by
735 // the Free Software Foundation, either version 3 of the License, or
736 // (at your option) any later version.
737 
738 // This program is distributed in the hope that it will be useful,
739 // but WITHOUT ANY WARRANTY; without even the implied warranty of
740 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
741 // GNU General Public License for more details.
742 
743 // You should have received a copy of the GNU General Public License
744 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
745 
746 /* pragma solidity ^0.5.0; */
747 
748 /* import "./interfaces/IAssimilator.sol"; */
749 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
750 
751 library Assimilators {
752 
753     using ABDKMath64x64 for int128;
754     IAssimilator constant iAsmltr = IAssimilator(address(0));
755 
756     function delegate(address _callee, bytes memory _data) internal returns (bytes memory) {
757 
758         (bool _success, bytes memory returnData_) = _callee.delegatecall(_data);
759 
760         assembly { if eq(_success, 0) { revert(add(returnData_, 0x20), returndatasize()) } }
761 
762         return returnData_;
763 
764     }
765 
766     function viewRawAmount (address _assim, int128 _amt) internal view returns (uint256 amount_) {
767 
768         amount_ = IAssimilator(_assim).viewRawAmount(_amt);
769 
770     }
771 
772     function viewNumeraireAmount (address _assim, uint256 _amt) internal view returns (int128 amt_) {
773 
774         amt_ = IAssimilator(_assim).viewNumeraireAmount(_amt);
775 
776     }
777 
778     function viewNumeraireAmountAndBalance (address _assim, uint256 _amt) internal view returns (int128 amt_, int128 bal_) {
779 
780         ( amt_, bal_ ) = IAssimilator(_assim).viewNumeraireAmountAndBalance(address(this), _amt);
781 
782     }
783 
784     function viewNumeraireBalance (address _assim) internal view returns (int128 bal_) {
785 
786         bal_ = IAssimilator(_assim).viewNumeraireBalance(address(this));
787 
788     }
789 
790     function intakeRaw (address _assim, uint256 _amt) internal returns (int128 amt_) {
791 
792         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRaw.selector, _amt);
793 
794         amt_ = abi.decode(delegate(_assim, data), (int128));
795 
796     }
797 
798     function intakeRawAndGetBalance (address _assim, uint256 _amt) internal returns (int128 amt_, int128 bal_) {
799 
800         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRawAndGetBalance.selector, _amt);
801 
802         ( amt_, bal_ ) = abi.decode(delegate(_assim, data), (int128,int128));
803 
804     }
805 
806     function intakeNumeraire (address _assim, int128 _amt) internal returns (uint256 amt_) {
807 
808         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeNumeraire.selector, _amt);
809 
810         amt_ = abi.decode(delegate(_assim, data), (uint256));
811 
812     }
813 
814     function outputRaw (address _assim, address _dst, uint256 _amt) internal returns (int128 amt_ ) {
815 
816         bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amt);
817 
818         amt_ = abi.decode(delegate(_assim, data), (int128));
819 
820         amt_ = amt_.neg();
821 
822     }
823 
824     function outputRawAndGetBalance (address _assim, address _dst, uint256 _amt) internal returns (int128 amt_, int128 bal_) {
825 
826         bytes memory data = abi.encodeWithSelector(iAsmltr.outputRawAndGetBalance.selector, _dst, _amt);
827 
828         ( amt_, bal_ ) = abi.decode(delegate(_assim, data), (int128,int128));
829 
830         amt_ = amt_.neg();
831 
832     }
833 
834     function outputNumeraire (address _assim, address _dst, int128 _amt) internal returns (uint256 amt_) {
835 
836         bytes memory data = abi.encodeWithSelector(iAsmltr.outputNumeraire.selector, _dst, _amt.abs());
837 
838         amt_ = abi.decode(delegate(_assim, data), (uint256));
839 
840     }
841 
842 }
843 ////// src/UnsafeMath64x64.sol
844 /* pragma solidity ^0.5.0; */
845 
846 library UnsafeMath64x64 {
847 
848   /**
849    * Calculate x * y rounding down.
850    *
851    * @param x signed 64.64-bit fixed point number
852    * @param y signed 64.64-bit fixed point number
853    * @return signed 64.64-bit fixed point number
854    */
855 
856   function us_mul (int128 x, int128 y) internal pure returns (int128) {
857     int256 result = int256(x) * y >> 64;
858     return int128 (result);
859   }
860 
861   /**
862    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
863    * zero.
864    *
865    * @param x signed 64.64-bit fixed point number
866    * @param y signed 64.64-bit fixed point number
867    * @return signed 64.64-bit fixed point number
868    */
869 
870   function us_div (int128 x, int128 y) internal pure returns (int128) {
871     int256 result = (int256 (x) << 64) / y;
872     return int128 (result);
873   }
874 
875 }
876 
877 ////// src/PartitionedLiquidity.sol
878 /* pragma solidity ^0.5.0; */
879 
880 /* import "./Assimilators.sol"; */
881 
882 /* import "./ShellStorage.sol"; */
883 
884 /* import "./UnsafeMath64x64.sol"; */
885 
886 library PartitionedLiquidity {
887 
888     using ABDKMath64x64 for uint;
889     using ABDKMath64x64 for int128;
890     using UnsafeMath64x64 for int128;
891 
892     event PoolPartitioned(bool);
893 
894     event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);
895 
896     int128 constant ONE = 0x10000000000000000;
897 
898     function partition (
899         ShellStorage.Shell storage shell,
900         mapping (address => ShellStorage.PartitionTicket) storage partitionTickets
901     ) external {
902 
903         uint _length = shell.assets.length;
904 
905         ShellStorage.PartitionTicket storage totalSupplyTicket = partitionTickets[address(this)];
906 
907         totalSupplyTicket.initialized = true;
908 
909         for (uint i = 0; i < _length; i++) totalSupplyTicket.claims.push(shell.totalSupply);
910 
911         emit PoolPartitioned(true);
912 
913     }
914 
915     function viewPartitionClaims (
916         ShellStorage.Shell storage shell,
917         mapping (address => ShellStorage.PartitionTicket) storage partitionTickets,
918         address _addr
919     ) external view returns (
920         uint[] memory claims_
921     ) {
922 
923         ShellStorage.PartitionTicket storage ticket = partitionTickets[_addr];
924 
925         if (ticket.initialized) return ticket.claims;
926 
927         uint _length = shell.assets.length;
928         uint[] memory claims_ = new uint[](_length);
929         uint _balance = shell.balances[msg.sender];
930 
931         for (uint i = 0; i < _length; i++) claims_[i] = _balance;
932 
933         return claims_;
934 
935     }
936 
937     function partitionedWithdraw (
938         ShellStorage.Shell storage shell,
939         mapping (address => ShellStorage.PartitionTicket) storage partitionTickets,
940         address[] calldata _derivatives,
941         uint[] calldata _withdrawals
942     ) external returns (
943         uint[] memory
944     ) {
945 
946         uint _length = shell.assets.length;
947         uint _balance = shell.balances[msg.sender];
948 
949         ShellStorage.PartitionTicket storage totalSuppliesTicket = partitionTickets[address(this)];
950         ShellStorage.PartitionTicket storage ticket = partitionTickets[msg.sender];
951 
952         if (!ticket.initialized) {
953 
954             for (uint i = 0; i < _length; i++) ticket.claims.push(_balance);
955             ticket.initialized = true;
956 
957         }
958 
959         _length = _derivatives.length;
960 
961         uint[] memory withdrawals_ = new uint[](_length);
962 
963         for (uint i = 0; i < _length; i++) {
964 
965             ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];
966 
967             require(totalSuppliesTicket.claims[_assim.ix] >= _withdrawals[i], "Shell/burn-exceeds-total-supply");
968             
969             require(ticket.claims[_assim.ix] >= _withdrawals[i], "Shell/insufficient-balance");
970 
971             require(_assim.addr != address(0), "Shell/unsupported-asset");
972 
973             int128 _reserveBalance = Assimilators.viewNumeraireBalance(_assim.addr);
974 
975             int128 _multiplier = _withdrawals[i].divu(1e18)
976                 .div(totalSuppliesTicket.claims[_assim.ix].divu(1e18));
977 
978             totalSuppliesTicket.claims[_assim.ix] = totalSuppliesTicket.claims[_assim.ix] - _withdrawals[i];
979 
980             ticket.claims[_assim.ix] = ticket.claims[_assim.ix] - _withdrawals[i];
981 
982             uint _withdrawal = Assimilators.outputNumeraire(
983                 _assim.addr,
984                 msg.sender,
985                 _reserveBalance.mul(_multiplier)
986             );
987 
988             withdrawals_[i] = _withdrawal;
989 
990             emit PartitionRedeemed(_derivatives[i], msg.sender, withdrawals_[i]);
991 
992         }
993 
994         return withdrawals_;
995 
996     }
997 
998 }
999 ////// src/ProportionalLiquidity.sol
1000 /* pragma solidity ^0.5.0; */
1001 
1002 /* import "./Assimilators.sol"; */
1003 
1004 /* import "./ShellStorage.sol"; */
1005 
1006 /* import "./UnsafeMath64x64.sol"; */
1007 
1008 /* import "./ShellMath.sol"; */
1009 
1010 
1011 library ProportionalLiquidity {
1012 
1013     using ABDKMath64x64 for uint;
1014     using ABDKMath64x64 for int128;
1015     using UnsafeMath64x64 for int128;
1016 
1017     event Transfer(address indexed from, address indexed to, uint256 value);
1018 
1019     int128 constant ONE = 0x10000000000000000;
1020     int128 constant ONE_WEI = 0x12;
1021 
1022     function proportionalDeposit (
1023         ShellStorage.Shell storage shell,
1024         uint256 _deposit
1025     ) external returns (
1026         uint256 shells_,
1027         uint[] memory
1028     ) {
1029 
1030         int128 __deposit = _deposit.divu(1e18);
1031 
1032         uint _length = shell.assets.length;
1033 
1034         uint[] memory deposits_ = new uint[](_length);
1035         
1036         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);
1037 
1038         if (_oGLiq == 0) {
1039 
1040             for (uint i = 0; i < _length; i++) {
1041 
1042                 deposits_[i] = Assimilators.intakeNumeraire(shell.assets[i].addr, __deposit.mul(shell.weights[i]));
1043 
1044             }
1045 
1046         } else {
1047 
1048             int128 _multiplier = __deposit.div(_oGLiq);
1049 
1050             for (uint i = 0; i < _length; i++) {
1051 
1052                 deposits_[i] = Assimilators.intakeNumeraire(shell.assets[i].addr, _oBals[i].mul(_multiplier));
1053 
1054             }
1055 
1056         }
1057         
1058         int128 _totalShells = shell.totalSupply.divu(1e18);
1059         
1060         int128 _newShells = _totalShells > 0
1061             ? __deposit.div(_oGLiq).mul(_totalShells)
1062             : __deposit;
1063 
1064         requireLiquidityInvariant(
1065             shell, 
1066             _totalShells,
1067             _newShells, 
1068             _oGLiq, 
1069             _oBals
1070         );        
1071 
1072         mint(shell, msg.sender, shells_ = _newShells.mulu(1e18));
1073 
1074         return (shells_, deposits_);
1075 
1076     }
1077     
1078     
1079     function viewProportionalDeposit (
1080         ShellStorage.Shell storage shell,
1081         uint256 _deposit
1082     ) external view returns (
1083         uint shells_,
1084         uint[] memory
1085     ) {
1086 
1087         int128 __deposit = _deposit.divu(1e18);
1088 
1089         uint _length = shell.assets.length;
1090 
1091         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);
1092 
1093         uint[] memory deposits_ = new uint[](_length);
1094 
1095         if (_oGLiq == 0) {
1096 
1097             for (uint i = 0; i < _length; i++) {
1098 
1099                 deposits_[i] = Assimilators.viewRawAmount(
1100                     shell.assets[i].addr,
1101                     __deposit.mul(shell.weights[i])
1102                 );
1103 
1104             }
1105 
1106         } else {
1107 
1108             int128 _multiplier = __deposit.div(_oGLiq);
1109 
1110             for (uint i = 0; i < _length; i++) {
1111 
1112                 deposits_[i] = Assimilators.viewRawAmount(
1113                     shell.assets[i].addr,
1114                     _oBals[i].mul(_multiplier)
1115                 );
1116 
1117             }
1118 
1119         }
1120         
1121         int128 _totalShells = shell.totalSupply.divu(1e18);
1122         
1123         int128 _newShells = _totalShells > 0
1124             ? __deposit.div(_oGLiq).mul(_totalShells)
1125             : __deposit;
1126         
1127         shells_ = _newShells.mulu(1e18);
1128 
1129         return ( shells_, deposits_ );
1130 
1131     }
1132 
1133     function proportionalWithdraw (
1134         ShellStorage.Shell storage shell,
1135         uint256 _withdrawal
1136     ) external returns (
1137         uint[] memory
1138     ) {
1139 
1140         uint _length = shell.assets.length;
1141 
1142         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);
1143 
1144         uint[] memory withdrawals_ = new uint[](_length);
1145         
1146         int128 _totalShells = shell.totalSupply.divu(1e18);
1147         int128 __withdrawal = _withdrawal.divu(1e18);
1148 
1149         int128 _multiplier = __withdrawal
1150             .mul(ONE - shell.epsilon)
1151             .div(_totalShells);
1152 
1153         for (uint i = 0; i < _length; i++) {
1154 
1155             withdrawals_[i] = Assimilators.outputNumeraire(
1156                 shell.assets[i].addr,
1157                 msg.sender,
1158                 _oBals[i].mul(_multiplier)
1159             );
1160 
1161         }
1162 
1163         requireLiquidityInvariant(
1164             shell, 
1165             _totalShells, 
1166             __withdrawal.neg(), 
1167             _oGLiq, 
1168             _oBals
1169         );
1170         
1171         burn(shell, msg.sender, _withdrawal);
1172 
1173         return withdrawals_;
1174 
1175     }
1176     
1177     function viewProportionalWithdraw (
1178         ShellStorage.Shell storage shell,
1179         uint256 _withdrawal
1180     ) external view returns (
1181         uint[] memory
1182     ) {
1183 
1184         uint _length = shell.assets.length;
1185 
1186         ( int128 _oGLiq, int128[] memory _oBals ) = getGrossLiquidityAndBalances(shell);
1187 
1188         uint[] memory withdrawals_ = new uint[](_length);
1189 
1190         int128 _multiplier = _withdrawal.divu(1e18)
1191             .mul(ONE - shell.epsilon)
1192             .div(shell.totalSupply.divu(1e18));
1193 
1194         for (uint i = 0; i < _length; i++) {
1195 
1196             withdrawals_[i] = Assimilators.viewRawAmount(shell.assets[i].addr, _oBals[i].mul(_multiplier));
1197 
1198         }
1199 
1200         return withdrawals_;
1201 
1202     }
1203 
1204     function getGrossLiquidityAndBalances (
1205         ShellStorage.Shell storage shell
1206     ) internal view returns (
1207         int128 grossLiquidity_,
1208         int128[] memory
1209     ) {
1210         
1211         uint _length = shell.assets.length;
1212 
1213         int128[] memory balances_ = new int128[](_length);
1214         
1215         for (uint i = 0; i < _length; i++) {
1216 
1217             int128 _bal = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
1218             
1219             balances_[i] = _bal;
1220             grossLiquidity_ += _bal;
1221             
1222         }
1223         
1224         return (grossLiquidity_, balances_);
1225 
1226     }
1227     
1228     function requireLiquidityInvariant (
1229         ShellStorage.Shell storage shell,
1230         int128 _shells,
1231         int128 _newShells,
1232         int128 _oGLiq,
1233         int128[] memory _oBals
1234     ) private {
1235     
1236         ( int128 _nGLiq, int128[] memory _nBals ) = getGrossLiquidityAndBalances(shell);
1237         
1238         int128 _beta = shell.beta;
1239         int128 _delta = shell.delta;
1240         int128[] memory _weights = shell.weights;
1241         
1242         int128 _omega = ShellMath.calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
1243 
1244         int128 _psi = ShellMath.calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
1245 
1246         ShellMath.enforceLiquidityInvariant(_shells, _newShells, _oGLiq, _nGLiq, _omega, _psi);
1247         
1248     }
1249 
1250     function burn (ShellStorage.Shell storage shell, address account, uint256 amount) private {
1251 
1252         shell.balances[account] = burn_sub(shell.balances[account], amount);
1253 
1254         shell.totalSupply = burn_sub(shell.totalSupply, amount);
1255 
1256         emit Transfer(msg.sender, address(0), amount);
1257 
1258     }
1259 
1260     function mint (ShellStorage.Shell storage shell, address account, uint256 amount) private {
1261 
1262         shell.totalSupply = mint_add(shell.totalSupply, amount);
1263 
1264         shell.balances[account] = mint_add(shell.balances[account], amount);
1265 
1266         emit Transfer(address(0), msg.sender, amount);
1267 
1268     }
1269 
1270     function mint_add(uint x, uint y) private pure returns (uint z) {
1271 
1272         require((z = x + y) >= x, "Shell/mint-overflow");
1273 
1274     }
1275 
1276     function burn_sub(uint x, uint y) private pure returns (uint z) {
1277 
1278         require((z = x - y) <= x, "Shell/burn-underflow");
1279 
1280     }
1281 
1282 
1283 }
1284 ////// src/SelectiveLiquidity.sol
1285 /* pragma solidity ^0.5.0; */
1286 
1287 /* import "./Assimilators.sol"; */
1288 
1289 /* import "./ShellStorage.sol"; */
1290 
1291 /* import "./ShellMath.sol"; */
1292 
1293 /* import "./UnsafeMath64x64.sol"; */
1294 
1295 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
1296 
1297 
1298 library SelectiveLiquidity {
1299 
1300     using ABDKMath64x64 for int128;
1301     using UnsafeMath64x64 for int128;
1302 
1303     event Transfer(address indexed from, address indexed to, uint256 value);
1304 
1305     int128 constant ONE = 0x10000000000000000;
1306 
1307     function selectiveDeposit (
1308         ShellStorage.Shell storage shell,
1309         address[] calldata _derivatives,
1310         uint[] calldata _amounts,
1311         uint _minShells
1312     ) external returns (
1313         uint shells_
1314     ) {
1315 
1316         (   int128 _oGLiq,
1317             int128 _nGLiq,
1318             int128[] memory _oBals,
1319             int128[] memory _nBals ) = getLiquidityDepositData(shell, _derivatives, _amounts);
1320 
1321         int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);
1322 
1323         shells_ = _shells.mulu(1e18);
1324 
1325         require(_minShells < shells_, "Shell/under-minimum-shells");
1326 
1327         mint(shell, msg.sender, shells_);
1328 
1329     }
1330 
1331     function viewSelectiveDeposit (
1332         ShellStorage.Shell storage shell,
1333         address[] calldata _derivatives,
1334         uint[] calldata _amounts
1335     ) external view returns (
1336         uint shells_
1337     ) {
1338 
1339         (   int128 _oGLiq,
1340             int128 _nGLiq,
1341             int128[] memory _oBals,
1342             int128[] memory _nBals ) = viewLiquidityDepositData(shell, _derivatives, _amounts);
1343 
1344         int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);
1345 
1346         shells_ = _shells.mulu(1e18);
1347 
1348     }
1349 
1350     function selectiveWithdraw (
1351         ShellStorage.Shell storage shell,
1352         address[] calldata _derivatives,
1353         uint[] calldata _amounts,
1354         uint _maxShells
1355     ) external returns (
1356         uint256 shells_
1357     ) {
1358 
1359         (   int128 _oGLiq,
1360             int128 _nGLiq,
1361             int128[] memory _oBals,
1362             int128[] memory _nBals ) = getLiquidityWithdrawData(shell, _derivatives, msg.sender, _amounts);
1363 
1364         int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);
1365 
1366         _shells = _shells.neg().us_mul(ONE + shell.epsilon);
1367 
1368         shells_ = _shells.mulu(1e18);
1369 
1370         require(shells_ < _maxShells, "Shell/above-maximum-shells");
1371 
1372         burn(shell, msg.sender, shells_);
1373 
1374     }
1375 
1376     function viewSelectiveWithdraw (
1377         ShellStorage.Shell storage shell,
1378         address[] calldata _derivatives,
1379         uint[] calldata _amounts
1380     ) external view returns (
1381         uint shells_
1382     ) {
1383 
1384         (   int128 _oGLiq,
1385             int128 _nGLiq,
1386             int128[] memory _oBals,
1387             int128[] memory _nBals ) = viewLiquidityWithdrawData(shell, _derivatives, _amounts);
1388 
1389         int128 _shells = ShellMath.calculateLiquidityMembrane(shell, _oGLiq, _nGLiq, _oBals, _nBals);
1390 
1391         _shells = _shells.neg().us_mul(ONE + shell.epsilon);
1392 
1393         shells_ = _shells.mulu(1e18);
1394 
1395     }
1396 
1397     function getLiquidityDepositData (
1398         ShellStorage.Shell storage shell,
1399         address[] memory _derivatives,
1400         uint[] memory _amounts
1401     ) private returns (
1402         int128 oGLiq_,
1403         int128 nGLiq_,
1404         int128[] memory,
1405         int128[] memory
1406     ) {
1407 
1408         uint _length = shell.weights.length;
1409         int128[] memory oBals_ = new int128[](_length);
1410         int128[] memory nBals_ = new int128[](_length);
1411 
1412         for (uint i = 0; i < _derivatives.length; i++) {
1413 
1414             ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];
1415 
1416             require(_assim.addr != address(0), "Shell/unsupported-derivative");
1417 
1418             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1419 
1420                 ( int128 _amount, int128 _balance ) = Assimilators.intakeRawAndGetBalance(_assim.addr, _amounts[i]);
1421 
1422                 nBals_[_assim.ix] = _balance;
1423 
1424                 oBals_[_assim.ix] = _balance.sub(_amount);
1425 
1426             } else {
1427 
1428                 int128 _amount = Assimilators.intakeRaw(_assim.addr, _amounts[i]);
1429 
1430                 nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);
1431 
1432             }
1433 
1434         }
1435 
1436         return completeLiquidityData(shell, oBals_, nBals_);
1437 
1438     }
1439 
1440     function getLiquidityWithdrawData (
1441         ShellStorage.Shell storage shell,
1442         address[] memory _derivatives,
1443         address _rcpnt,
1444         uint[] memory _amounts
1445     ) private returns (
1446         int128 oGLiq_,
1447         int128 nGLiq_,
1448         int128[] memory,
1449         int128[] memory
1450     ) {
1451 
1452         uint _length = shell.weights.length;
1453         int128[] memory oBals_ = new int128[](_length);
1454         int128[] memory nBals_ = new int128[](_length);
1455 
1456         for (uint i = 0; i < _derivatives.length; i++) {
1457 
1458             ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];
1459 
1460             require(_assim.addr != address(0), "Shell/unsupported-derivative");
1461 
1462             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1463 
1464                 ( int128 _amount, int128 _balance ) = Assimilators.outputRawAndGetBalance(_assim.addr, _rcpnt, _amounts[i]);
1465 
1466                 nBals_[_assim.ix] = _balance;
1467                 oBals_[_assim.ix] = _balance.sub(_amount);
1468 
1469             } else {
1470 
1471                 int128 _amount = Assimilators.outputRaw(_assim.addr, _rcpnt, _amounts[i]);
1472 
1473                 nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);
1474 
1475             }
1476 
1477         }
1478 
1479         return completeLiquidityData(shell, oBals_, nBals_);
1480 
1481     }
1482 
1483     function viewLiquidityDepositData (
1484         ShellStorage.Shell storage shell,
1485         address[] memory _derivatives,
1486         uint[] memory _amounts
1487     ) private view returns (
1488         int128 oGLiq_,
1489         int128 nGLiq_,
1490         int128[] memory,
1491         int128[] memory
1492     ) {
1493 
1494         uint _length = shell.assets.length;
1495         int128[] memory oBals_ = new int128[](_length);
1496         int128[] memory nBals_ = new int128[](_length);
1497 
1498         for (uint i = 0; i < _derivatives.length; i++) {
1499 
1500             ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];
1501 
1502             require(_assim.addr != address(0), "Shell/unsupported-derivative");
1503 
1504             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1505 
1506                 ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amounts[i]);
1507 
1508                 nBals_[_assim.ix] = _balance.add(_amount);
1509 
1510                 oBals_[_assim.ix] = _balance;
1511 
1512             } else {
1513 
1514                 int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amounts[i]);
1515 
1516                 nBals_[_assim.ix] = nBals_[_assim.ix].add(_amount);
1517 
1518             }
1519 
1520         }
1521 
1522         return completeLiquidityData(shell, oBals_, nBals_);
1523 
1524     }
1525 
1526     function viewLiquidityWithdrawData (
1527         ShellStorage.Shell storage shell,
1528         address[] memory _derivatives,
1529         uint[] memory _amounts
1530     ) private view returns (
1531         int128 oGLiq_,
1532         int128 nGLiq_,
1533         int128[] memory,
1534         int128[] memory
1535     ) {
1536 
1537         uint _length = shell.assets.length;
1538         int128[] memory oBals_ = new int128[](_length);
1539         int128[] memory nBals_ = new int128[](_length);
1540 
1541         for (uint i = 0; i < _derivatives.length; i++) {
1542 
1543             ShellStorage.Assimilator memory _assim = shell.assimilators[_derivatives[i]];
1544 
1545             require(_assim.addr != address(0), "Shell/unsupported-derivative");
1546 
1547             if ( nBals_[_assim.ix] == 0 && 0 == oBals_[_assim.ix]) {
1548 
1549                 ( int128 _amount, int128 _balance ) = Assimilators.viewNumeraireAmountAndBalance(_assim.addr, _amounts[i]);
1550 
1551                 nBals_[_assim.ix] = _balance.sub(_amount);
1552 
1553                 oBals_[_assim.ix] = _balance;
1554 
1555             } else {
1556 
1557                 int128 _amount = Assimilators.viewNumeraireAmount(_assim.addr, _amounts[i]);
1558 
1559                 nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);
1560 
1561             }
1562 
1563         }
1564 
1565         return completeLiquidityData(shell, oBals_, nBals_);
1566 
1567     }
1568 
1569     function completeLiquidityData (
1570         ShellStorage.Shell storage shell,
1571         int128[] memory oBals_,
1572         int128[] memory nBals_
1573     ) private view returns (
1574         int128 oGLiq_,
1575         int128 nGLiq_,
1576         int128[] memory,
1577         int128[] memory
1578     ) {
1579 
1580         uint _length = oBals_.length;
1581 
1582         for (uint i = 0; i < _length; i++) {
1583 
1584             if (oBals_[i] == 0 && 0 == nBals_[i]) {
1585 
1586                 nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
1587                 
1588             }
1589 
1590             oGLiq_ += oBals_[i];
1591             nGLiq_ += nBals_[i];
1592 
1593         }
1594 
1595         return ( oGLiq_, nGLiq_, oBals_, nBals_ );
1596 
1597     }
1598 
1599     function burn (ShellStorage.Shell storage shell, address account, uint256 amount) private {
1600 
1601         shell.balances[account] = burn_sub(shell.balances[account], amount);
1602 
1603         shell.totalSupply = burn_sub(shell.totalSupply, amount);
1604 
1605         emit Transfer(msg.sender, address(0), amount);
1606 
1607     }
1608 
1609     function mint (ShellStorage.Shell storage shell, address account, uint256 amount) private {
1610 
1611         shell.totalSupply = mint_add(shell.totalSupply, amount);
1612 
1613         shell.balances[account] = mint_add(shell.balances[account], amount);
1614 
1615         emit Transfer(address(0), msg.sender, amount);
1616 
1617     }
1618 
1619     function mint_add(uint x, uint y) private pure returns (uint z) {
1620         require((z = x + y) >= x, "Shell/mint-overflow");
1621     }
1622 
1623     function burn_sub(uint x, uint y) private pure returns (uint z) {
1624         require((z = x - y) <= x, "Shell/burn-underflow");
1625     }
1626 
1627 }
1628 ////// src/Shells.sol
1629 // This program is free software: you can redistribute it and/or modify
1630 // it under the terms of the GNU General Public License as published by
1631 // the Free Software Foundation, either version 3 of the License, or
1632 // (at your option) any later version.
1633 
1634 // This program is distributed in the hope that it will be useful,
1635 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1636 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1637 // GNU General Public License for more details.
1638 
1639 // You should have received a copy of the GNU General Public License
1640 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1641 
1642 /* pragma solidity ^0.5.0; */
1643 
1644 /* import "./ShellStorage.sol"; */
1645 
1646 /* import "./Assimilators.sol"; */
1647 
1648 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
1649 
1650 library Shells {
1651 
1652     using ABDKMath64x64 for int128;
1653 
1654     event Approval(address indexed _owner, address indexed spender, uint256 value);
1655     event Transfer(address indexed from, address indexed to, uint256 value);
1656 
1657     function add(uint x, uint y, string memory errorMessage) private pure returns (uint z) {
1658         require((z = x + y) >= x, errorMessage);
1659     }
1660 
1661     function sub(uint x, uint y, string memory errorMessage) private pure returns (uint z) {
1662         require((z = x - y) <= x, errorMessage);
1663     }
1664 
1665     /**
1666      * @dev See {IERC20-transfer}.
1667      *
1668      * Requirements:
1669      *
1670      * - `recipient` cannot be the zero address.
1671      * - the caller must have a balance of at least `amount`.
1672      */
1673     function transfer(ShellStorage.Shell storage shell, address recipient, uint256 amount) external returns (bool) {
1674         _transfer(shell, msg.sender, recipient, amount);
1675         return true;
1676     }
1677 
1678     /**
1679      * @dev See {IERC20-approve}.
1680      *
1681      * Requirements:
1682      *
1683      * - `spender` cannot be the zero address.
1684      */
1685     function approve(ShellStorage.Shell storage shell, address spender, uint256 amount) external returns (bool) {
1686         _approve(shell, msg.sender, spender, amount);
1687         return true;
1688     }
1689 
1690     /**
1691      * @dev See {IERC20-transferFrom}.
1692      *
1693      * Emits an {Approval} event indicating the updated allowance. This is not
1694      * required by the EIP. See the note at the beginning of {ERC20};
1695      *
1696      * Requirements:
1697      * - `sender` and `recipient` cannot be the zero address.
1698      * - `sender` must have a balance of at least `amount`.
1699      * - the caller must have allowance for `sender`'s tokens of at least
1700      * `amount`
1701      */
1702     function transferFrom(ShellStorage.Shell storage shell, address sender, address recipient, uint256 amount) external returns (bool) {
1703         _transfer(shell, sender, recipient, amount);
1704         _approve(shell, sender, msg.sender, sub(shell.allowances[sender][msg.sender], amount, "Shell/insufficient-allowance"));
1705         return true;
1706     }
1707 
1708     /**
1709      * @dev Atomically increases the allowance granted to `spender` by the caller.
1710      *
1711      * This is an alternative to {approve} that can be used as a mitigation for
1712      * problems described in {IERC20-approve}.
1713      *
1714      * Emits an {Approval} event indicating the updated allowance.
1715      *
1716      * Requirements:
1717      *
1718      * - `spender` cannot be the zero address.
1719      */
1720     function increaseAllowance(ShellStorage.Shell storage shell, address spender, uint256 addedValue) external returns (bool) {
1721         _approve(shell, msg.sender, spender, add(shell.allowances[msg.sender][spender], addedValue, "Shell/approval-overflow"));
1722         return true;
1723     }
1724 
1725     /**
1726      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1727      *
1728      * This is an alternative to {approve} that can be used as a mitigation for
1729      * problems described in {IERC20-approve}.
1730      *
1731      * Emits an {Approval} event indicating the updated allowance.
1732      *
1733      * Requirements:
1734      *
1735      * - `spender` cannot be the zero address.
1736      * - `spender` must have allowance for the caller of at least
1737      * `subtractedValue`.
1738      */
1739     function decreaseAllowance(ShellStorage.Shell storage shell, address spender, uint256 subtractedValue) external returns (bool) {
1740         _approve(shell, msg.sender, spender, sub(shell.allowances[msg.sender][spender], subtractedValue, "Shell/allowance-decrease-underflow"));
1741         return true;
1742     }
1743 
1744     /**
1745      * @dev Moves tokens `amount` from `sender` to `recipient`.
1746      *
1747      * This is public function is equivalent to {transfer}, and can be used to
1748      * e.g. implement automatic token fees, slashing mechanisms, etc.
1749      *
1750      * Emits a {Transfer} event.
1751      *
1752      * Requirements:
1753      *
1754      * - `sender` cannot be the zero address.
1755      * - `recipient` cannot be the zero address.
1756      * - `sender` must have a balance of at least `amount`.
1757      */
1758     function _transfer(ShellStorage.Shell storage shell, address sender, address recipient, uint256 amount) private {
1759         require(sender != address(0), "ERC20: transfer from the zero address");
1760         require(recipient != address(0), "ERC20: transfer to the zero address");
1761 
1762         shell.balances[sender] = sub(shell.balances[sender], amount, "Shell/insufficient-balance");
1763         shell.balances[recipient] = add(shell.balances[recipient], amount, "Shell/transfer-overflow");
1764         emit Transfer(sender, recipient, amount);
1765     }
1766 
1767 
1768     /**
1769      * @dev Sets `amount` as the allowance of `spender` over the `_owner`s tokens.
1770      *
1771      * This is public function is equivalent to `approve`, and can be used to
1772      * e.g. set automatic allowances for certain subsystems, etc.
1773      *
1774      * Emits an {Approval} event.
1775      *
1776      * Requirements:
1777      *
1778      * - `_owner` cannot be the zero address.
1779      * - `spender` cannot be the zero address.
1780      */
1781     function _approve(ShellStorage.Shell storage shell, address _owner, address spender, uint256 amount) private {
1782         require(_owner != address(0), "ERC20: approve from the zero address");
1783         require(spender != address(0), "ERC20: approve to the zero address");
1784 
1785         shell.allowances[_owner][spender] = amount;
1786         emit Approval(_owner, spender, amount);
1787     }
1788 
1789 }
1790 ////// src/Swaps.sol
1791 /* pragma solidity ^0.5.0; */
1792 
1793 /* import "./Assimilators.sol"; */
1794 
1795 /* import "./ShellStorage.sol"; */
1796 
1797 /* import "./ShellMath.sol"; */
1798 
1799 /* import "./UnsafeMath64x64.sol"; */
1800 
1801 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
1802 
1803 library Swaps {
1804 
1805     using ABDKMath64x64 for int128;
1806     using UnsafeMath64x64 for int128;
1807 
1808     event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
1809 
1810     int128 constant ONE = 0x10000000000000000;
1811 
1812     function getOriginAndTarget (
1813         ShellStorage.Shell storage shell,
1814         address _o,
1815         address _t
1816     ) private view returns (
1817         ShellStorage.Assimilator memory,
1818         ShellStorage.Assimilator memory
1819     ) {
1820 
1821         ShellStorage.Assimilator memory o_ = shell.assimilators[_o];
1822         ShellStorage.Assimilator memory t_ = shell.assimilators[_t];
1823 
1824         require(o_.addr != address(0), "Shell/origin-not-supported");
1825         require(t_.addr != address(0), "Shell/target-not-supported");
1826 
1827         return ( o_, t_ );
1828 
1829     }
1830 
1831 
1832     function originSwap (
1833         ShellStorage.Shell storage shell,
1834         address _origin,
1835         address _target,
1836         uint256 _originAmount,
1837         address _recipient
1838     ) external returns (
1839         uint256 tAmt_
1840     ) {
1841 
1842         (   ShellStorage.Assimilator memory _o,
1843             ShellStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);
1844 
1845         if (_o.ix == _t.ix) return Assimilators.outputNumeraire(_t.addr, _recipient, Assimilators.intakeRaw(_o.addr, _originAmount));
1846 
1847         (   int128 _amt,
1848             int128 _oGLiq,
1849             int128 _nGLiq,
1850             int128[] memory _oBals,
1851             int128[] memory _nBals ) = getOriginSwapData(shell, _o.ix, _t.ix, _o.addr, _originAmount);
1852 
1853         _amt = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);
1854 
1855         _amt = _amt.us_mul(ONE - shell.epsilon);
1856 
1857         tAmt_ = Assimilators.outputNumeraire(_t.addr, _recipient, _amt);
1858 
1859         emit Trade(msg.sender, _origin, _target, _originAmount, tAmt_);
1860 
1861     }
1862 
1863     function viewOriginSwap (
1864         ShellStorage.Shell storage shell,
1865         address _origin,
1866         address _target,
1867         uint256 _originAmount
1868     ) external view returns (
1869         uint256 tAmt_
1870     ) {
1871 
1872         (   ShellStorage.Assimilator memory _o,
1873             ShellStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);
1874 
1875         if (_o.ix == _t.ix) return Assimilators.viewRawAmount(_t.addr, Assimilators.viewNumeraireAmount(_o.addr, _originAmount));
1876 
1877         (   int128 _amt,
1878             int128 _oGLiq,
1879             int128 _nGLiq,
1880             int128[] memory _nBals,
1881             int128[] memory _oBals ) = viewOriginSwapData(shell, _o.ix, _t.ix, _originAmount, _o.addr);
1882 
1883         _amt = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);
1884 
1885         _amt = _amt.us_mul(ONE - shell.epsilon);
1886 
1887         tAmt_ = Assimilators.viewRawAmount(_t.addr, _amt.abs());
1888 
1889     }
1890 
1891     function targetSwap (
1892         ShellStorage.Shell storage shell,
1893         address _origin,
1894         address _target,
1895         uint256 _targetAmount,
1896         address _recipient
1897     ) external returns (
1898         uint256 oAmt_
1899     ) {
1900 
1901         (   ShellStorage.Assimilator memory _o,
1902             ShellStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);
1903 
1904         if (_o.ix == _t.ix) return Assimilators.intakeNumeraire(_o.addr, Assimilators.outputRaw(_t.addr, _recipient, _targetAmount));
1905 
1906         (   int128 _amt,
1907             int128 _oGLiq,
1908             int128 _nGLiq,
1909             int128[] memory _oBals,
1910             int128[] memory _nBals) = getTargetSwapData(shell, _t.ix, _o.ix, _t.addr, _recipient, _targetAmount);
1911 
1912         _amt = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);
1913 
1914         _amt = _amt.us_mul(ONE + shell.epsilon);
1915 
1916         oAmt_ = Assimilators.intakeNumeraire(_o.addr, _amt);
1917 
1918         emit Trade(msg.sender, _origin, _target, oAmt_, _targetAmount);
1919 
1920     }
1921 
1922     function viewTargetSwap (
1923         ShellStorage.Shell storage shell,
1924         address _origin,
1925         address _target,
1926         uint256 _targetAmount
1927     ) external view returns (
1928         uint256 oAmt_
1929     ) {
1930 
1931         (   ShellStorage.Assimilator memory _o,
1932             ShellStorage.Assimilator memory _t  ) = getOriginAndTarget(shell, _origin, _target);
1933 
1934         if (_o.ix == _t.ix) return Assimilators.viewRawAmount(_o.addr, Assimilators.viewNumeraireAmount(_t.addr, _targetAmount));
1935 
1936         (   int128 _amt,
1937             int128 _oGLiq,
1938             int128 _nGLiq,
1939             int128[] memory _nBals,
1940             int128[] memory _oBals ) = viewTargetSwapData(shell, _t.ix, _o.ix, _targetAmount, _t.addr);
1941 
1942         _amt = ShellMath.calculateTrade(shell, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);
1943 
1944         _amt = _amt.us_mul(ONE + shell.epsilon);
1945 
1946         oAmt_ = Assimilators.viewRawAmount(_o.addr, _amt);
1947 
1948     }
1949 
1950     function getOriginSwapData (
1951         ShellStorage.Shell storage shell,
1952         uint _inputIx,
1953         uint _outputIx,
1954         address _assim,
1955         uint _amt
1956     ) private returns (
1957         int128 amt_,
1958         int128 oGLiq_,
1959         int128 nGLiq_,
1960         int128[] memory,
1961         int128[] memory
1962     ) {
1963 
1964         uint _length = shell.assets.length;
1965 
1966         int128[] memory oBals_ = new int128[](_length);
1967         int128[] memory nBals_ = new int128[](_length);
1968         ShellStorage.Assimilator[] memory _reserves = shell.assets;
1969 
1970         for (uint i = 0; i < _length; i++) {
1971 
1972             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
1973             else {
1974 
1975                 int128 _bal;
1976                 ( amt_, _bal ) = Assimilators.intakeRawAndGetBalance(_assim, _amt);
1977 
1978                 oBals_[i] = _bal.sub(amt_);
1979                 nBals_[i] = _bal;
1980 
1981             }
1982 
1983             oGLiq_ += oBals_[i];
1984             nGLiq_ += nBals_[i];
1985 
1986         }
1987 
1988         nGLiq_ = nGLiq_.sub(amt_);
1989         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
1990 
1991         return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );
1992 
1993     }
1994 
1995     function getTargetSwapData (
1996         ShellStorage.Shell storage shell,
1997         uint _inputIx,
1998         uint _outputIx,
1999         address _assim,
2000         address _recipient,
2001         uint _amt
2002     ) private returns (
2003         int128 amt_,
2004         int128 oGLiq_,
2005         int128 nGLiq_,
2006         int128[] memory,
2007         int128[] memory
2008     ) {
2009 
2010         uint _length = shell.assets.length;
2011 
2012         int128[] memory oBals_ = new int128[](_length);
2013         int128[] memory nBals_ = new int128[](_length);
2014         ShellStorage.Assimilator[] memory _reserves = shell.assets;
2015 
2016         for (uint i = 0; i < _length; i++) {
2017 
2018             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
2019             else {
2020 
2021                 int128 _bal;
2022                 ( amt_, _bal ) = Assimilators.outputRawAndGetBalance(_assim, _recipient, _amt);
2023 
2024                 oBals_[i] = _bal.sub(amt_);
2025                 nBals_[i] = _bal;
2026 
2027             }
2028 
2029             oGLiq_ += oBals_[i];
2030             nGLiq_ += nBals_[i];
2031 
2032         }
2033 
2034         nGLiq_ = nGLiq_.sub(amt_);
2035         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
2036 
2037         return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );
2038 
2039     }
2040 
2041     function viewOriginSwapData (
2042         ShellStorage.Shell storage shell,
2043         uint _inputIx,
2044         uint _outputIx,
2045         uint _amt,
2046         address _assim
2047     ) private view returns (
2048         int128 amt_,
2049         int128 oGLiq_,
2050         int128 nGLiq_,
2051         int128[] memory,
2052         int128[] memory
2053     ) {
2054 
2055         uint _length = shell.assets.length;
2056         int128[] memory nBals_ = new int128[](_length);
2057         int128[] memory oBals_ = new int128[](_length);
2058 
2059         for (uint i = 0; i < _length; i++) {
2060 
2061             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
2062             else {
2063 
2064                 int128 _bal;
2065                 ( amt_, _bal ) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
2066 
2067                 oBals_[i] = _bal;
2068                 nBals_[i] = _bal.add(amt_);
2069 
2070             }
2071 
2072             oGLiq_ += oBals_[i];
2073             nGLiq_ += nBals_[i];
2074 
2075         }
2076 
2077         nGLiq_ = nGLiq_.sub(amt_);
2078         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
2079 
2080         return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );
2081 
2082     }
2083 
2084     function viewTargetSwapData (
2085         ShellStorage.Shell storage shell,
2086         uint _inputIx,
2087         uint _outputIx,
2088         uint _amt,
2089         address _assim
2090     ) private view returns (
2091         int128 amt_,
2092         int128 oGLiq_,
2093         int128 nGLiq_,
2094         int128[] memory,
2095         int128[] memory
2096     ) {
2097 
2098         uint _length = shell.assets.length;
2099         int128[] memory nBals_ = new int128[](_length);
2100         int128[] memory oBals_ = new int128[](_length);
2101 
2102         for (uint i = 0; i < _length; i++) {
2103 
2104             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
2105             else {
2106 
2107                 int128 _bal;
2108                 ( amt_, _bal ) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
2109                 amt_ = amt_.neg();
2110 
2111                 oBals_[i] = _bal;
2112                 nBals_[i] = _bal.add(amt_);
2113 
2114             }
2115 
2116             oGLiq_ += oBals_[i];
2117             nGLiq_ += nBals_[i];
2118 
2119         }
2120 
2121         nGLiq_ = nGLiq_.sub(amt_);
2122         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
2123 
2124 
2125         return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );
2126 
2127     }
2128 
2129 }
2130 ////// src/ViewLiquidity.sol
2131 // This program is free software: you can redistribute it and/or modify
2132 // it under the terms of the GNU General Public License as published by
2133 // the Free Software Foundation, either version 3 of the License, or
2134 // (at your option) any later version.
2135 
2136 // This program is distributed in the hope that it will be useful,
2137 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2138 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2139 // GNU General Public License for more details.
2140 
2141 // You should have received a copy of the GNU General Public License
2142 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2143 
2144 
2145 /* pragma solidity ^0.5.0; */
2146 
2147 /* import "./ShellStorage.sol"; */
2148 
2149 /* import "./Assimilators.sol"; */
2150 
2151 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
2152 
2153 library ViewLiquidity {
2154 
2155     using ABDKMath64x64 for int128;
2156 
2157     function viewLiquidity (
2158         ShellStorage.Shell storage shell
2159     ) external view returns (
2160         uint total_,
2161         uint[] memory individual_
2162     ) {
2163 
2164         uint _length = shell.assets.length;
2165 
2166         uint[] memory individual_ = new uint[](_length);
2167         uint total_;
2168 
2169         for (uint i = 0; i < _length; i++) {
2170 
2171             uint _liquidity = Assimilators.viewNumeraireBalance(shell.assets[i].addr).mulu(1e18);
2172 
2173             total_ += _liquidity;
2174             individual_[i] = _liquidity;
2175 
2176         }
2177 
2178         return (total_, individual_);
2179 
2180     }
2181 
2182 }
2183 ////// src/ShellStorage.sol
2184 // This program is free software: you can redistribute it and/or modify
2185 // it under the terms of the GNU General Public License as published by
2186 // the Free Software Foundation, either version 3 of the License, or
2187 // (at your option) any later version.
2188 
2189 // This program is distributed in the hope that it will be useful,
2190 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2191 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2192 // GNU General Public License for more details.
2193 
2194 // You should have received a copy of the GNU General Public License
2195 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2196 
2197 /* pragma solidity ^0.5.0; */
2198 
2199 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
2200 
2201 /* import "./Orchestrator.sol"; */
2202 
2203 /* import "./PartitionedLiquidity.sol"; */
2204 
2205 /* import "./ProportionalLiquidity.sol"; */
2206 
2207 /* import "./SelectiveLiquidity.sol"; */
2208 
2209 /* import "./Shells.sol"; */
2210 
2211 /* import "./Swaps.sol"; */
2212 
2213 /* import "./ViewLiquidity.sol"; */
2214 
2215 contract ShellStorage {
2216 
2217     address public owner;
2218 
2219     string  public constant name = "Shells";
2220     string  public constant symbol = "SHL";
2221     uint8   public constant decimals = 18;
2222 
2223     Shell public shell;
2224 
2225     struct Shell {
2226         int128 alpha;
2227         int128 beta;
2228         int128 delta;
2229         int128 epsilon;
2230         int128 lambda;
2231         int128[] weights;
2232         uint totalSupply;
2233         Assimilator[] assets;
2234         mapping (address => Assimilator) assimilators;
2235         mapping (address => uint) balances;
2236         mapping (address => mapping (address => uint)) allowances;
2237     }
2238 
2239     struct Assimilator {
2240         address addr;
2241         uint8 ix;
2242     }
2243 
2244     mapping (address => PartitionTicket) public partitionTickets;
2245 
2246     struct PartitionTicket {
2247         uint[] claims;
2248         bool initialized;
2249     }
2250 
2251     address[] public derivatives;
2252     address[] public numeraires;
2253     address[] public reserves;
2254 
2255     bool public partitioned = false;
2256 
2257     bool public frozen = false;
2258 
2259     bool internal notEntered = true;
2260 
2261 }
2262 ////// src/ShellMath.sol
2263 // This program is free software: you can redistribute it and/or modify
2264 // it under the terms of the GNU General Public License as published by
2265 // the Free Software Foundation, either version 3 of the License, or
2266 // (at your option) any later version.
2267 
2268 // This program is distributed in the hope that it will be useful,
2269 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2270 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2271 // GNU General Public License for more details.
2272 
2273 // You should have received a copy of the GNU General Public License
2274 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2275 
2276 /* pragma solidity ^0.5.0; */
2277 
2278 /* import "./Assimilators.sol"; */
2279 
2280 /* import "./UnsafeMath64x64.sol"; */
2281 
2282 /* import "./ShellStorage.sol"; */
2283 
2284 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
2285 
2286 library ShellMath {
2287 
2288     int128 constant ONE = 0x10000000000000000;
2289     int128 constant MAX = 0x4000000000000000; // .25 in layman's terms
2290     int128 constant MAX_DIFF = -0x10C6F7A0B5EE;
2291     int128 constant ONE_WEI = 0x12;
2292 
2293     using ABDKMath64x64 for int128;
2294     using UnsafeMath64x64 for int128;
2295     using ABDKMath64x64 for uint256;
2296 
2297     function calculateFee (
2298         int128 _gLiq,
2299         int128[] memory _bals,
2300         int128 _beta,
2301         int128 _delta,
2302         int128[] memory _weights
2303     ) internal pure returns (int128 psi_) {
2304 
2305         uint _length = _bals.length;
2306 
2307         for (uint i = 0; i < _length; i++) {
2308 
2309             int128 _ideal = _gLiq.us_mul(_weights[i]);
2310 
2311             psi_ += calculateMicroFee(_bals[i], _ideal, _beta, _delta);
2312 
2313         }
2314 
2315     }
2316 
2317     function calculateMicroFee (
2318         int128 _bal,
2319         int128 _ideal,
2320         int128 _beta,
2321         int128 _delta
2322     ) private pure returns (int128 fee_) {
2323 
2324         if (_bal < _ideal) {
2325 
2326             int128 _threshold = _ideal.us_mul(ONE - _beta);
2327 
2328             if (_bal < _threshold) {
2329 
2330                 int128 _feeMargin = _threshold - _bal;
2331 
2332                 fee_ = _feeMargin.us_div(_ideal);
2333                 fee_ = fee_.us_mul(_delta);
2334 
2335                 if (fee_ > MAX) fee_ = MAX;
2336 
2337                 fee_ = fee_.us_mul(_feeMargin);
2338 
2339             } else fee_ = 0;
2340 
2341         } else {
2342 
2343             int128 _threshold = _ideal.us_mul(ONE + _beta);
2344 
2345             if (_bal > _threshold) {
2346 
2347                 int128 _feeMargin = _bal - _threshold;
2348 
2349                 fee_ = _feeMargin.us_div(_ideal);
2350                 fee_ = fee_.us_mul(_delta);
2351 
2352                 if (fee_ > MAX) fee_ = MAX;
2353 
2354                 fee_ = fee_.us_mul(_feeMargin);
2355 
2356             } else fee_ = 0;
2357 
2358         }
2359 
2360     }
2361 
2362     function calculateTrade (
2363         ShellStorage.Shell storage shell,
2364         int128 _oGLiq,
2365         int128 _nGLiq,
2366         int128[] memory _oBals,
2367         int128[] memory _nBals,
2368         int128 _inputAmt,
2369         uint _outputIndex
2370     ) internal view returns (int128 outputAmt_) {
2371 
2372         outputAmt_ = - _inputAmt;
2373 
2374         int128 _lambda = shell.lambda;
2375         int128 _beta = shell.beta;
2376         int128 _delta = shell.delta;
2377         int128[] memory _weights = shell.weights;
2378 
2379         int128 _omega = calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
2380         int128 _psi;
2381 
2382         for (uint i = 0; i < 32; i++) {
2383 
2384             _psi = calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
2385 
2386             if (( outputAmt_ = _omega < _psi
2387                     ? - ( _inputAmt + _omega - _psi )
2388                     : - ( _inputAmt + _lambda.us_mul(_omega - _psi) )
2389                 ) / 1e13 == outputAmt_ / 1e13 ) {
2390 
2391                 _nGLiq = _oGLiq + _inputAmt + outputAmt_;
2392 
2393                 _nBals[_outputIndex] = _oBals[_outputIndex] + outputAmt_;
2394 
2395                 enforceHalts(shell, _oGLiq, _nGLiq, _oBals, _nBals, _weights);
2396                 
2397                 enforceSwapInvariant(_oGLiq, _omega, _nGLiq, _psi);
2398 
2399                 return outputAmt_;
2400 
2401             } else {
2402 
2403                 _nGLiq = _oGLiq + _inputAmt + outputAmt_;
2404 
2405                 _nBals[_outputIndex] = _oBals[_outputIndex].add(outputAmt_);
2406 
2407             }
2408 
2409         }
2410 
2411         revert("Shell/swap-convergence-failed");
2412 
2413     }
2414     
2415     function enforceSwapInvariant (
2416         int128 _oGLiq,
2417         int128 _omega,
2418         int128 _nGLiq,
2419         int128 _psi
2420     ) private pure {
2421 
2422         int128 _nextUtil = _nGLiq - _psi;
2423 
2424         int128 _prevUtil = _oGLiq - _omega;
2425 
2426         int128 _diff = _nextUtil - _prevUtil;
2427 
2428         require(0 < _diff || _diff >= MAX_DIFF, "Shell/swap-invariant-violation");
2429         
2430     }
2431 
2432     function calculateLiquidityMembrane (
2433         ShellStorage.Shell storage shell,
2434         int128 _oGLiq,
2435         int128 _nGLiq,
2436         int128[] memory _oBals,
2437         int128[] memory _nBals
2438     ) internal view returns (int128 shells_) {
2439 
2440         enforceHalts(shell, _oGLiq, _nGLiq, _oBals, _nBals, shell.weights);
2441         
2442         int128 _omega;
2443         int128 _psi;
2444         
2445         {
2446             
2447             int128 _beta = shell.beta;
2448             int128 _delta = shell.delta;
2449             int128[] memory _weights = shell.weights;
2450 
2451             _omega = calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
2452             _psi = calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
2453 
2454         }
2455 
2456         int128 _feeDiff = _psi.sub(_omega);
2457         int128 _liqDiff = _nGLiq.sub(_oGLiq);
2458         int128 _oUtil = _oGLiq.sub(_omega);
2459         int128 _totalShells = shell.totalSupply.divu(1e18);
2460         int128 _shellMultiplier;
2461 
2462         if (_totalShells == 0) {
2463 
2464             shells_ = _nGLiq.sub(_psi);
2465 
2466         } else if (_feeDiff >= 0) {
2467 
2468             _shellMultiplier = _liqDiff.sub(_feeDiff).div(_oUtil);
2469 
2470         } else {
2471             
2472             _shellMultiplier = _liqDiff.sub(shell.lambda.mul(_feeDiff));
2473             
2474             _shellMultiplier = _shellMultiplier.div(_oUtil);
2475 
2476         }
2477 
2478         if (_totalShells != 0) {
2479 
2480             shells_ = _totalShells.us_mul(_shellMultiplier);
2481             
2482             enforceLiquidityInvariant(_totalShells, shells_, _oGLiq, _nGLiq, _omega, _psi);
2483 
2484         }
2485 
2486     }
2487     
2488     function enforceLiquidityInvariant (
2489         int128 _totalShells,
2490         int128 _newShells,
2491         int128 _oGLiq,
2492         int128 _nGLiq,
2493         int128 _omega,
2494         int128 _psi
2495     ) internal view {
2496         
2497         if (_totalShells == 0 || 0 == _totalShells + _newShells) return;
2498         
2499         int128 _prevUtilPerShell = _oGLiq
2500             .sub(_omega)
2501             .div(_totalShells);
2502             
2503         int128 _nextUtilPerShell = _nGLiq
2504             .sub(_psi)
2505             .div(_totalShells.add(_newShells));
2506 
2507         int128 _diff = _nextUtilPerShell - _prevUtilPerShell;
2508 
2509         require(0 < _diff || _diff >= MAX_DIFF, "Shell/liquidity-invariant-violation");
2510         
2511     }
2512 
2513     function enforceHalts (
2514         ShellStorage.Shell storage shell,
2515         int128 _oGLiq,
2516         int128 _nGLiq,
2517         int128[] memory _oBals,
2518         int128[] memory _nBals,
2519         int128[] memory _weights
2520     ) private view {
2521 
2522         uint256 _length = _nBals.length;
2523         int128 _alpha = shell.alpha;
2524 
2525         for (uint i = 0; i < _length; i++) {
2526 
2527             int128 _nIdeal = _nGLiq.us_mul(_weights[i]);
2528 
2529             if (_nBals[i] > _nIdeal) {
2530 
2531                 int128 _upperAlpha = ONE + _alpha;
2532 
2533                 int128 _nHalt = _nIdeal.us_mul(_upperAlpha);
2534 
2535                 if (_nBals[i] > _nHalt){
2536 
2537                     int128 _oHalt = _oGLiq.us_mul(_weights[i]).us_mul(_upperAlpha);
2538 
2539                     if (_oBals[i] < _oHalt) revert("Shell/upper-halt");
2540                     if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("Shell/upper-halt");
2541 
2542                 }
2543 
2544             } else {
2545 
2546                 int128 _lowerAlpha = ONE - _alpha;
2547 
2548                 int128 _nHalt = _nIdeal.us_mul(_lowerAlpha);
2549 
2550                 if (_nBals[i] < _nHalt){
2551 
2552                     int128 _oHalt = _oGLiq.us_mul(_weights[i]).us_mul(_lowerAlpha);
2553 
2554                     if (_oBals[i] > _oHalt) revert("Shell/lower-halt");
2555                     if (_nHalt - _nBals[i] > _oHalt - _oBals[i]) revert("Shell/lower-halt");
2556 
2557                 }
2558             }
2559         }
2560     }
2561 }
2562 ////// src/Orchestrator.sol
2563 // This program is free software: you can redistribute it and/or modify
2564 // it under the terms of the GNU General Public License as published by
2565 // the Free Software Foundation, either version 3 of the License, or
2566 // (at your option) any later version.
2567 
2568 // This program is distributed in the hope that it will be useful,
2569 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2570 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2571 // GNU General Public License for more details.
2572 
2573 // You should have received a copy of the GNU General Public License
2574 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2575 
2576 /* pragma solidity ^0.5.0; */
2577 
2578 /* import "./Assimilators.sol"; */
2579 
2580 /* import "./ShellMath.sol"; */
2581 
2582 /* import "./ShellStorage.sol"; */
2583 
2584 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
2585 
2586 library Orchestrator {
2587 
2588     using ABDKMath64x64 for int128;
2589     using ABDKMath64x64 for uint256;
2590 
2591     int128 constant ONE_WEI = 0x12;
2592 
2593     event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);
2594 
2595     event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);
2596 
2597     event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);
2598 
2599     function setParams (
2600         ShellStorage.Shell storage shell,
2601         uint256 _alpha,
2602         uint256 _beta,
2603         uint256 _feeAtHalt,
2604         uint256 _epsilon,
2605         uint256 _lambda
2606     ) external {
2607 
2608         require(0 < _alpha && _alpha < 1e18, "Shell/parameter-invalid-alpha");
2609 
2610         require(0 <= _beta && _beta < _alpha, "Shell/parameter-invalid-beta");
2611 
2612         require(_feeAtHalt <= .5e18, "Shell/parameter-invalid-max");
2613 
2614         require(0 <= _epsilon && _epsilon <= .01e18, "Shell/parameter-invalid-epsilon");
2615 
2616         require(0 <= _lambda && _lambda <= 1e18, "Shell/parameter-invalid-lambda");
2617 
2618         int128 _omega = getFee(shell);
2619 
2620         shell.alpha = (_alpha + 1).divu(1e18);
2621 
2622         shell.beta = (_beta + 1).divu(1e18);
2623 
2624         shell.delta = ( _feeAtHalt ).divu(1e18).div(uint(2).fromUInt().mul(shell.alpha.sub(shell.beta))) + ONE_WEI;
2625 
2626         shell.epsilon = (_epsilon + 1).divu(1e18);
2627 
2628         shell.lambda = (_lambda + 1).divu(1e18);
2629         
2630         int128 _psi = getFee(shell);
2631         
2632         require(_omega >= _psi, "Shell/parameters-increase-fee");
2633 
2634         emit ParametersSet(_alpha, _beta, shell.delta.mulu(1e18), _epsilon, _lambda);
2635 
2636     }
2637 
2638     function getFee (
2639         ShellStorage.Shell storage shell
2640     ) private view returns (
2641         int128 fee_
2642     ) {
2643 
2644         int128 _gLiq;
2645 
2646         int128[] memory _bals = new int128[](shell.assets.length);
2647 
2648         for (uint i = 0; i < _bals.length; i++) {
2649 
2650             int128 _bal = Assimilators.viewNumeraireBalance(shell.assets[i].addr);
2651 
2652             _bals[i] = _bal;
2653 
2654             _gLiq += _bal;
2655 
2656         }
2657 
2658         fee_ = ShellMath.calculateFee(_gLiq, _bals, shell.beta, shell.delta, shell.weights);
2659 
2660     }
2661     
2662  
2663     function initialize (
2664         ShellStorage.Shell storage shell,
2665         address[] storage numeraires,
2666         address[] storage reserves,
2667         address[] storage derivatives,
2668         address[] calldata _assets,
2669         uint[] calldata _assetWeights,
2670         address[] calldata _derivativeAssimilators
2671     ) external {
2672         
2673         for (uint i = 0; i < _assetWeights.length; i++) {
2674 
2675             uint ix = i*5;
2676         
2677             numeraires.push(_assets[ix]);
2678             derivatives.push(_assets[ix]);
2679 
2680             reserves.push(_assets[2+ix]);
2681             if (_assets[ix] != _assets[2+ix]) derivatives.push(_assets[2+ix]);
2682             
2683             includeAsset(
2684                 shell,
2685                 _assets[ix],   // numeraire
2686                 _assets[1+ix], // numeraire assimilator
2687                 _assets[2+ix], // reserve
2688                 _assets[3+ix], // reserve assimilator
2689                 _assets[4+ix], // reserve approve to
2690                 _assetWeights[i]
2691             );
2692             
2693         }
2694         
2695         for (uint i = 0; i < _derivativeAssimilators.length / 5; i++) {
2696             
2697             uint ix = i * 5;
2698 
2699             derivatives.push(_derivativeAssimilators[ix]);
2700 
2701             includeAssimilator(
2702                 shell,
2703                 _derivativeAssimilators[ix],   // derivative
2704                 _derivativeAssimilators[1+ix], // numeraire
2705                 _derivativeAssimilators[2+ix], // reserve
2706                 _derivativeAssimilators[3+ix], // assimilator
2707                 _derivativeAssimilators[4+ix]  // derivative approve to
2708             );
2709 
2710         }
2711 
2712     }
2713 
2714     function includeAsset (
2715         ShellStorage.Shell storage shell,
2716         address _numeraire,
2717         address _numeraireAssim,
2718         address _reserve,
2719         address _reserveAssim,
2720         address _reserveApproveTo,
2721         uint256 _weight
2722     ) private {
2723 
2724         require(_numeraire != address(0), "Shell/numeraire-cannot-be-zeroth-adress");
2725 
2726         require(_numeraireAssim != address(0), "Shell/numeraire-assimilator-cannot-be-zeroth-adress");
2727 
2728         require(_reserve != address(0), "Shell/reserve-cannot-be-zeroth-adress");
2729 
2730         require(_reserveAssim != address(0), "Shell/reserve-assimilator-cannot-be-zeroth-adress");
2731 
2732         require(_weight < 1e18, "Shell/weight-must-be-less-than-one");
2733 
2734         if (_numeraire != _reserve) safeApprove(_numeraire, _reserveApproveTo, uint(-1));
2735 
2736         ShellStorage.Assimilator storage _numeraireAssimilator = shell.assimilators[_numeraire];
2737 
2738         _numeraireAssimilator.addr = _numeraireAssim;
2739 
2740         _numeraireAssimilator.ix = uint8(shell.assets.length);
2741 
2742         ShellStorage.Assimilator storage _reserveAssimilator = shell.assimilators[_reserve];
2743 
2744         _reserveAssimilator.addr = _reserveAssim;
2745 
2746         _reserveAssimilator.ix = uint8(shell.assets.length);
2747 
2748         int128 __weight = _weight.divu(1e18).add(uint256(1).divu(1e18));
2749 
2750         shell.weights.push(__weight);
2751 
2752         shell.assets.push(_numeraireAssimilator);
2753 
2754         emit AssetIncluded(_numeraire, _reserve, _weight);
2755 
2756         emit AssimilatorIncluded(_numeraire, _numeraire, _reserve, _numeraireAssim);
2757 
2758         if (_numeraireAssim != _reserveAssim) {
2759 
2760             emit AssimilatorIncluded(_reserve, _numeraire, _reserve, _reserveAssim);
2761 
2762         }
2763 
2764     }
2765     
2766     function includeAssimilator (
2767         ShellStorage.Shell storage shell,
2768         address _derivative,
2769         address _numeraire,
2770         address _reserve,
2771         address _assimilator,
2772         address _derivativeApproveTo
2773     ) private {
2774 
2775         require(_derivative != address(0), "Shell/derivative-cannot-be-zeroth-address");
2776 
2777         require(_numeraire != address(0), "Shell/numeraire-cannot-be-zeroth-address");
2778 
2779         require(_reserve != address(0), "Shell/numeraire-cannot-be-zeroth-address");
2780 
2781         require(_assimilator != address(0), "Shell/assimilator-cannot-be-zeroth-address");
2782         
2783         safeApprove(_numeraire, _derivativeApproveTo, uint(-1));
2784 
2785         ShellStorage.Assimilator storage _numeraireAssim = shell.assimilators[_numeraire];
2786 
2787         shell.assimilators[_derivative] = ShellStorage.Assimilator(_assimilator, _numeraireAssim.ix);
2788 
2789         emit AssimilatorIncluded(_derivative, _numeraire, _reserve, _assimilator);
2790 
2791     }
2792 
2793     function safeApprove (
2794         address _token,
2795         address _spender,
2796         uint256 _value
2797     ) private {
2798 
2799         ( bool success, bytes memory returndata ) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
2800 
2801         require(success, "SafeERC20: low-level call failed");
2802 
2803     }
2804 
2805     function viewShell (
2806         ShellStorage.Shell storage shell
2807     ) external view returns (
2808         uint alpha_,
2809         uint beta_,
2810         uint delta_,
2811         uint epsilon_,
2812         uint lambda_
2813     ) {
2814 
2815         alpha_ = shell.alpha.mulu(1e18);
2816 
2817         beta_ = shell.beta.mulu(1e18);
2818 
2819         delta_ = shell.delta.mulu(1e18);
2820 
2821         epsilon_ = shell.epsilon.mulu(1e18);
2822 
2823         lambda_ = shell.lambda.mulu(1e18);
2824 
2825     }
2826 
2827 }
2828 ////// src/interfaces/IFreeFromUpTo.sol
2829 /* pragma solidity ^0.5.0; */
2830 
2831 interface IFreeFromUpTo {
2832     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
2833 }
2834 
2835 ////// src/Shell.sol
2836 // This program is free software: you can redistribute it and/or modify
2837 // it under the terms of the GNU General Public License as published by
2838 // the Free Software Foundation, either version 3 of the License, or
2839 // (at your option) any later version.
2840 
2841 // This program is distributed in the hope that it will be useful,
2842 // but WITHOUT ANY WARRANTY; without even the implied warranty of
2843 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2844 // GNU General Public License for more details.
2845 
2846 // You should have received a copy of the GNU General Public License
2847 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
2848 
2849 /* pragma solidity ^0.5.0; */
2850 
2851 /* import "abdk-libraries-solidity/ABDKMath64x64.sol"; */
2852 
2853 /* import "./Orchestrator.sol"; */
2854 
2855 /* import "./PartitionedLiquidity.sol"; */
2856 
2857 /* import "./ProportionalLiquidity.sol"; */
2858 
2859 /* import "./SelectiveLiquidity.sol"; */
2860 
2861 /* import "./Shells.sol"; */
2862 
2863 /* import "./Swaps.sol"; */
2864 
2865 /* import "./ViewLiquidity.sol"; */
2866 
2867 /* import "./ShellStorage.sol"; */
2868 
2869 /* import "./interfaces/IFreeFromUpTo.sol"; */
2870 
2871 contract Shell is ShellStorage {
2872 
2873     event Approval(address indexed _owner, address indexed spender, uint256 value);
2874 
2875     event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);
2876 
2877     event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);
2878 
2879     event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);
2880 
2881     event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);
2882 
2883     event PoolPartitioned(bool partitioned);
2884 
2885     event OwnershipTransfered(address indexed previousOwner, address indexed newOwner);
2886 
2887     event FrozenSet(bool isFrozen);
2888 
2889     event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);
2890 
2891     event Transfer(address indexed from, address indexed to, uint256 value);
2892 
2893     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
2894 
2895     modifier discountCHI {
2896         uint256 gasStart = gasleft();
2897         _;
2898         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
2899         chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
2900     }
2901 
2902     modifier onlyOwner() {
2903 
2904         require(msg.sender == owner, "Shell/caller-is-not-owner");
2905         _;
2906 
2907     }
2908 
2909     modifier nonReentrant() {
2910 
2911         require(notEntered, "Shell/re-entered");
2912         notEntered = false;
2913         _;
2914         notEntered = true;
2915 
2916     }
2917 
2918     modifier transactable () {
2919 
2920         require(!frozen, "Shell/frozen-only-allowing-proportional-withdraw");
2921         _;
2922 
2923     }
2924 
2925     modifier unpartitioned () {
2926 
2927         require(!partitioned, "Shell/pool-partitioned");
2928         _;
2929 
2930     }
2931 
2932     modifier isPartitioned () {
2933 
2934         require(partitioned, "Shell/pool-not-partitioned");
2935         _;
2936 
2937     }
2938 
2939     modifier deadline (uint _deadline) {
2940 
2941         require(block.timestamp < _deadline, "Shell/tx-deadline-passed");
2942         _;
2943 
2944     }
2945 
2946     constructor (
2947         address[] memory _assets,
2948         uint[] memory _assetWeights,
2949         address[] memory _derivativeAssimilators
2950     ) public {
2951         
2952         owner = msg.sender;
2953         emit OwnershipTransfered(address(0), msg.sender);
2954         
2955         Orchestrator.initialize(
2956             shell,
2957             numeraires,
2958             reserves,
2959             derivatives,
2960             _assets,
2961             _assetWeights,
2962             _derivativeAssimilators
2963         );
2964 
2965     }
2966 
2967     /// @notice sets the parameters for the pool
2968     /// @param _alpha the value for alpha (halt threshold) must be less than or equal to 1 and greater than 0
2969     /// @param _beta the value for beta must be less than alpha and greater than 0
2970     /// @param _feeAtHalt the maximum value for the fee at the halt point
2971     /// @param _epsilon the base fee for the pool
2972     /// @param _lambda the value for lambda must be less than or equal to 1 and greater than zero
2973     function setParams (
2974         uint _alpha,
2975         uint _beta, 
2976         uint _feeAtHalt,
2977         uint _epsilon,
2978         uint _lambda
2979     ) external onlyOwner {
2980 
2981         Orchestrator.setParams(shell, _alpha, _beta, _feeAtHalt, _epsilon, _lambda);
2982 
2983     }
2984 
2985     /// @notice excludes an assimilator from the shell
2986     /// @param _derivative the address of the assimilator to exclude
2987     function excludeDerivative (
2988         address _derivative
2989     ) external onlyOwner {
2990 
2991         uint _length = numeraires.length; 
2992 
2993         for (uint i = 0; i < numeraires.length; i++) {
2994             
2995             if (_derivative == numeraires[i]) revert("Shell/cannot-delete-numeraire");
2996             if (_derivative == reserves[i]) revert("Shell/cannot-delete-reserve");
2997             
2998         }
2999 
3000         delete shell.assimilators[_derivative];
3001 
3002     }
3003 
3004     /// @notice view the current parameters of the shell
3005     /// @return alpha_ the current alpha value
3006     /// @return beta_ the current beta value
3007     /// @return delta_ the current delta value
3008     /// @return epsilon_ the current epsilon value
3009     /// @return lambda_ the current lambda value
3010     /// @return omega_ the current omega value
3011     function viewShell () external view returns (
3012         uint alpha_,
3013         uint beta_,
3014         uint delta_,
3015         uint epsilon_,
3016         uint lambda_
3017     ) {
3018 
3019         return Orchestrator.viewShell(shell);
3020 
3021     }
3022 
3023     function setFrozen (bool _toFreezeOrNotToFreeze) external onlyOwner {
3024 
3025         emit FrozenSet(_toFreezeOrNotToFreeze);
3026 
3027         frozen = _toFreezeOrNotToFreeze;
3028 
3029     }
3030 
3031     function transferOwnership (address _newOwner) external onlyOwner {
3032 
3033         emit OwnershipTransfered(owner, _newOwner);
3034 
3035         owner = _newOwner;
3036 
3037     }
3038 
3039     /// @author james foley http://github.com/realisation
3040     /// @notice swap a dynamic origin amount for a fixed target amount
3041     /// @param _origin the address of the origin
3042     /// @param _target the address of the target
3043     /// @param _originAmount the origin amount
3044     /// @param _minTargetAmount the minimum target amount
3045     /// @param _deadline deadline in block number after which the trade will not execute
3046     /// @return targetAmount_ the amount of target that has been swapped for the origin amount
3047     function originSwap (
3048         address _origin,
3049         address _target,
3050         uint _originAmount,
3051         uint _minTargetAmount,
3052         uint _deadline
3053     ) external deadline(_deadline) transactable nonReentrant returns (
3054         uint targetAmount_
3055     ) {
3056 
3057         targetAmount_ = Swaps.originSwap(shell, _origin, _target, _originAmount, msg.sender);
3058 
3059         require(targetAmount_ > _minTargetAmount, "Shell/below-min-target-amount");
3060 
3061     }
3062 
3063     function originSwapDiscountCHI (
3064         address _origin,
3065         address _target,
3066         uint _originAmount,
3067         uint _minTargetAmount,
3068         uint _deadline
3069     ) external deadline(_deadline) transactable nonReentrant discountCHI returns (
3070         uint targetAmount_
3071     ) {
3072 
3073         targetAmount_ = Swaps.originSwap(shell, _origin, _target, _originAmount, msg.sender);
3074 
3075         require(targetAmount_ > _minTargetAmount, "Shell/below-min-target-amount");
3076 
3077     }
3078 
3079     /// @author james foley http://github.com/realisation
3080     /// @notice view how much target amount a fixed origin amount will swap for
3081     /// @param _origin the address of the origin
3082     /// @param _target the address of the target
3083     /// @param _originAmount the origin amount
3084     /// @return targetAmount_ the target amount that would have been swapped for the origin amount
3085     function viewOriginSwap (
3086         address _origin,
3087         address _target,
3088         uint _originAmount
3089     ) external view transactable returns (
3090         uint targetAmount_
3091     ) {
3092 
3093         targetAmount_ = Swaps.viewOriginSwap(shell, _origin, _target, _originAmount);
3094 
3095     }
3096 
3097     /// @author james foley http://github.com/realisation
3098     /// @notice swap a dynamic origin amount for a fixed target amount
3099     /// @param _origin the address of the origin
3100     /// @param _target the address of the target
3101     /// @param _maxOriginAmount the maximum origin amount
3102     /// @param _targetAmount the target amount
3103     /// @param _deadline deadline in block number after which the trade will not execute
3104     /// @return originAmount_ the amount of origin that has been swapped for the target
3105     function targetSwap (
3106         address _origin,
3107         address _target,
3108         uint _maxOriginAmount,
3109         uint _targetAmount,
3110         uint _deadline
3111     ) external deadline(_deadline) transactable nonReentrant returns (
3112         uint originAmount_
3113     ) {
3114 
3115         originAmount_ = Swaps.targetSwap(shell, _origin, _target, _targetAmount, msg.sender);
3116 
3117         require(originAmount_ < _maxOriginAmount, "Shell/above-max-origin-amount");
3118 
3119     }
3120 
3121     /// @author james foley http://github.com/realisation
3122     /// @notice view how much of the origin currency the target currency will take
3123     /// @param _origin the address of the origin
3124     /// @param _target the address of the target
3125     /// @param _targetAmount the target amount
3126     /// @return originAmount_ the amount of target that has been swapped for the origin
3127     function viewTargetSwap (
3128         address _origin,
3129         address _target,
3130         uint _targetAmount
3131     ) external view transactable returns (
3132         uint originAmount_
3133     ) {
3134 
3135         originAmount_ = Swaps.viewTargetSwap(shell, _origin, _target, _targetAmount);
3136 
3137     }
3138 
3139     /// @author james foley http://github.com/realisation
3140     /// @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
3141     /// @param _derivatives an array containing the addresses of the flavors being deposited into
3142     /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
3143     /// @param _minShells minimum acceptable amount of shells
3144     /// @param _deadline deadline for tx
3145     /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
3146     function selectiveDeposit (
3147         address[] calldata _derivatives,
3148         uint[] calldata _amounts,
3149         uint _minShells,
3150         uint _deadline
3151     ) external deadline(_deadline) transactable nonReentrant returns (
3152         uint shellsMinted_
3153     ) {
3154 
3155         shellsMinted_ = SelectiveLiquidity.selectiveDeposit(shell, _derivatives, _amounts, _minShells);
3156 
3157     }
3158 
3159     /// @author james folew http://github.com/realisation
3160     /// @notice view how many shell tokens a deposit will mint
3161     /// @param _derivatives an array containing the addresses of the flavors being deposited into
3162     /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
3163     /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
3164     function viewSelectiveDeposit (
3165         address[] calldata _derivatives,
3166         uint[] calldata _amounts
3167     ) external view transactable returns (
3168         uint shellsToMint_
3169     ) {
3170 
3171         shellsToMint_ = SelectiveLiquidity.viewSelectiveDeposit(shell, _derivatives, _amounts);
3172 
3173     }
3174 
3175     /// @author james foley http://github.com/realisation
3176     /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
3177     /// @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
3178     /// @return shellsToMint_ the amount of shells you receive in return for your deposit
3179     /// @return deposits_ the amount deposited for each numeraire
3180     function proportionalDeposit (
3181         uint _deposit,
3182         uint _deadline
3183     ) external deadline(_deadline) transactable nonReentrant returns (
3184         uint shellsMinted_,
3185         uint[] memory deposits_
3186     ) {
3187 
3188         return ProportionalLiquidity.proportionalDeposit(shell, _deposit);
3189 
3190     }
3191 
3192     /// @author james foley http://github.com/realisation
3193     /// @notice view deposits and shells minted a given deposit would return
3194     /// @param _deposit the full amount of stablecoins you want to deposit. Divided evenly according to the prevailing proportions of the numeraire assets of the pool
3195     /// @return shellsToMint_ the amount of shells you receive in return for your deposit
3196     /// @return deposits_ the amount deposited for each numeraire
3197     function viewProportionalDeposit (
3198         uint _deposit
3199     ) external view transactable returns (
3200         uint shellsToMint_,
3201         uint[] memory depositsToMake_
3202     ) {
3203 
3204         return ProportionalLiquidity.viewProportionalDeposit(shell, _deposit);
3205 
3206     }
3207 
3208     /// @author james foley http://github.com/realisation
3209     /// @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
3210     /// @param _derivatives an array of flavors to withdraw from the reserves
3211     /// @param _amounts an array of amounts to withdraw that maps to _flavors
3212     /// @param _maxShells the maximum amount of shells you want to burn
3213     /// @param _deadline timestamp after which the transaction is no longer valid
3214     /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
3215     function selectiveWithdraw (
3216         address[] calldata _derivatives,
3217         uint[] calldata _amounts,
3218         uint _maxShells,
3219         uint _deadline
3220     ) external deadline(_deadline) transactable nonReentrant returns (
3221         uint shellsBurned_
3222     ) {
3223 
3224         shellsBurned_ = SelectiveLiquidity.selectiveWithdraw(shell, _derivatives, _amounts, _maxShells);
3225 
3226     }
3227 
3228     /// @author james foley http://github.com/realisation
3229     /// @notice view how many shell tokens a withdraw will consume
3230     /// @param _derivatives an array of flavors to withdraw from the reserves
3231     /// @param _amounts an array of amounts to withdraw that maps to _flavors
3232     /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
3233     function viewSelectiveWithdraw (
3234         address[] calldata _derivatives,
3235         uint[] calldata _amounts
3236     ) external view transactable returns (
3237         uint shellsToBurn_
3238     ) {
3239 
3240         shellsToBurn_ = SelectiveLiquidity.viewSelectiveWithdraw(shell, _derivatives, _amounts);
3241 
3242     }
3243 
3244     /// @author  james foley http://github.com/realisation
3245     /// @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
3246     /// @param   _shellsToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
3247     /// @return withdrawals_ the amonts of numeraire assets withdrawn from the pool
3248     function proportionalWithdraw (
3249         uint _shellsToBurn,
3250         uint _deadline
3251     ) external deadline(_deadline) unpartitioned nonReentrant returns (
3252         uint[] memory withdrawals_
3253     ) {
3254 
3255         return ProportionalLiquidity.proportionalWithdraw(shell, _shellsToBurn);
3256 
3257     }
3258 
3259     function supportsInterface (
3260         bytes4 _interface
3261     ) public view returns (
3262         bool supports_
3263     ) { 
3264 
3265         supports_ = this.supportsInterface.selector == _interface  // erc165
3266             || bytes4(0x7f5828d0) == _interface                   // eip173
3267             || bytes4(0x36372b07) == _interface;                 // erc20
3268         
3269     }
3270 
3271     /// @author  james foley http://github.com/realisation
3272     /// @notice  withdrawals amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
3273     /// @param   _shellsToBurn the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
3274     /// @return withdrawalsToHappen_ the amonts of numeraire assets withdrawn from the pool
3275     function viewProportionalWithdraw (
3276         uint _shellsToBurn
3277     ) external view unpartitioned returns (
3278         uint[] memory withdrawalsToHappen_
3279     ) {
3280 
3281         return ProportionalLiquidity.viewProportionalWithdraw(shell, _shellsToBurn);
3282 
3283     }
3284 
3285     function partition () external onlyOwner {
3286 
3287         require(frozen, "Shell/must-be-frozen");
3288 
3289         PartitionedLiquidity.partition(shell, partitionTickets);
3290 
3291         partitioned = true;
3292 
3293     }
3294     
3295     /// @author  james foley http://github.com/realisation
3296     /// @notice  withdraws amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
3297     /// @param _tokens an array of the numeraire assets you will withdraw
3298     /// @param _amounts an array of the amounts in terms of partitioned shels you want to withdraw from that numeraire partition
3299     /// @return withdrawals_ the amounts of the numeraire assets withdrawn
3300     function partitionedWithdraw (
3301         address[] calldata _tokens,
3302         uint256[] calldata _amounts
3303     ) external isPartitioned returns (
3304         uint256[] memory withdrawals_
3305     ) {
3306 
3307         return PartitionedLiquidity.partitionedWithdraw(shell, partitionTickets, _tokens, _amounts);
3308 
3309     }
3310 
3311     /// @author  james foley http://github.com/realisation
3312     /// @notice  views the balance of the users partition ticket
3313     /// @param _addr the address whose balances in partitioned shells to be seen
3314     /// @return claims_ the remaining claims in terms of partitioned shells the address has in its partition ticket
3315     function viewPartitionClaims (
3316         address _addr
3317     ) external view isPartitioned returns (
3318         uint[] memory claims_
3319     ) {
3320 
3321         return PartitionedLiquidity.viewPartitionClaims(shell, partitionTickets, _addr);
3322 
3323     }
3324 
3325     /// @notice transfers shell tokens
3326     /// @param _recipient the address of where to send the shell tokens
3327     /// @param _amount the amount of shell tokens to send
3328     /// @return success_ the success bool of the call
3329     function transfer (
3330         address _recipient,
3331         uint _amount
3332     ) public nonReentrant returns (
3333         bool success_
3334     ) {
3335 
3336         require(!partitionTickets[msg.sender].initialized, "Shell/no-transfers-once-partitioned");
3337 
3338         success_ = Shells.transfer(shell, _recipient, _amount);
3339 
3340     }
3341 
3342     /// @notice transfers shell tokens from one address to another address
3343     /// @param _sender the account from which the shell tokens will be sent
3344     /// @param _recipient the account to which the shell tokens will be sent
3345     /// @param _amount the amount of shell tokens to transfer
3346     /// @return success_ the success bool of the call
3347     function transferFrom (
3348         address _sender,
3349         address _recipient,
3350         uint _amount
3351     ) public nonReentrant returns (
3352         bool success_
3353     ) {
3354 
3355         require(!partitionTickets[_sender].initialized, "Shell/no-transfers-once-partitioned");
3356 
3357         success_ = Shells.transferFrom(shell, _sender, _recipient, _amount);
3358 
3359     }
3360 
3361     /// @notice approves a user to spend shell tokens on their behalf
3362     /// @param _spender the account to allow to spend from msg.sender
3363     /// @param _amount the amount to specify the spender can spend
3364     /// @return success_ the success bool of this call
3365     function approve (address _spender, uint _amount) public nonReentrant returns (bool success_) {
3366 
3367         success_ = Shells.approve(shell, _spender, _amount);
3368 
3369     }
3370 
3371     /// @notice view the shell token balance of a given account
3372     /// @param _account the account to view the balance of  
3373     /// @return balance_ the shell token ballance of the given account
3374     function balanceOf (
3375         address _account
3376     ) public view returns (
3377         uint balance_
3378     ) {
3379 
3380         balance_ = shell.balances[_account];
3381 
3382     }
3383 
3384     /// @notice views the total shell supply of the pool
3385     /// @return totalSupply_ the total supply of shell tokens
3386     function totalSupply () public view returns (uint totalSupply_) {
3387 
3388         totalSupply_ = shell.totalSupply;
3389 
3390     }
3391 
3392     /// @notice views the total allowance one address has to spend from another address
3393     /// @param _owner the address of the owner 
3394     /// @param _spender the address of the spender
3395     /// @return allowance_ the amount the owner has allotted the spender
3396     function allowance (
3397         address _owner,
3398         address _spender
3399     ) public view returns (
3400         uint allowance_
3401     ) {
3402 
3403         allowance_ = shell.allowances[_owner][_spender];
3404 
3405     }
3406 
3407     /// @notice views the total amount of liquidity in the shell in numeraire value and format - 18 decimals
3408     /// @return total_ the total value in the shell
3409     /// @return individual_ the individual values in the shell
3410     function liquidity () public view returns (
3411         uint total_,
3412         uint[] memory individual_
3413     ) {
3414 
3415         return ViewLiquidity.viewLiquidity(shell);
3416 
3417     }
3418     
3419     /// @notice view the assimilator address for a derivative
3420     /// @return assimilator_ the assimilator address
3421     function assimilator (
3422         address _derivative
3423     ) public view returns (
3424         address assimilator_
3425     ) {
3426 
3427         assimilator_ = shell.assimilators[_derivative].addr;
3428 
3429     }
3430 
3431 }