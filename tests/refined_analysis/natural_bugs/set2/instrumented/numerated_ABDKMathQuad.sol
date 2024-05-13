1 // SPDX-License-Identifier: BSD-4-Clause
2 /*
3  * ABDK Math Quad Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
4  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
5  */
6 pragma solidity ^0.7.0;
7 
8 /**
9  * Smart contract library of mathematical functions operating with IEEE 754
10  * quadruple-precision binary floating-point numbers (quadruple precision
11  * numbers).  As long as quadruple precision numbers are 16-bytes long, they are
12  * represented by bytes16 type.
13  */
14 library ABDKMathQuad {
15   /*
16    * 0.
17    */
18   bytes16 private constant POSITIVE_ZERO = 0x00000000000000000000000000000000;
19 
20   /*
21    * -0.
22    */
23   bytes16 private constant NEGATIVE_ZERO = 0x80000000000000000000000000000000;
24 
25   /*
26    * +Infinity.
27    */
28   bytes16 private constant POSITIVE_INFINITY = 0x7FFF0000000000000000000000000000;
29 
30   /*
31    * -Infinity.
32    */
33   bytes16 private constant NEGATIVE_INFINITY = 0xFFFF0000000000000000000000000000;
34 
35   /*
36    * Canonical NaN value.
37    */
38   bytes16 private constant NaN = 0x7FFF8000000000000000000000000000;
39 
40   /**
41    * Convert signed 256-bit integer number into quadruple precision number.
42    *
43    * @param x signed 256-bit integer number
44    * @return quadruple precision number
45    */
46   function fromInt (int256 x) internal pure returns (bytes16) {
47     if (x == 0) return bytes16 (0);
48     else {
49       // We rely on overflow behavior here
50       uint256 result = uint256 (x > 0 ? x : -x);
51 
52       uint256 msb = msb (result);
53       if (msb < 112) result <<= 112 - msb;
54       else if (msb > 112) result >>= msb - 112;
55 
56       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16383 + msb << 112;
57       if (x < 0) result |= 0x80000000000000000000000000000000;
58 
59       return bytes16 (uint128 (result));
60     }
61   }
62 
63   /**
64    * Convert quadruple precision number into signed 256-bit integer number
65    * rounding towards zero.  Revert on overflow.
66    *
67    * @param x quadruple precision number
68    * @return signed 256-bit integer number
69    */
70   function toInt (bytes16 x) internal pure returns (int256) {
71     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
72 
73     require (exponent <= 16638); // Overflow
74     if (exponent < 16383) return 0; // Underflow
75 
76     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
77       0x10000000000000000000000000000;
78 
79     if (exponent < 16495) result >>= 16495 - exponent;
80     else if (exponent > 16495) result <<= exponent - 16495;
81 
82     if (uint128 (x) >= 0x80000000000000000000000000000000) { // Negative
83       require (result <= 0x8000000000000000000000000000000000000000000000000000000000000000);
84       return -int256 (result); // We rely on overflow behavior here
85     } else {
86       require (result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
87       return int256 (result);
88     }
89   }
90 
91   /**
92    * Convert unsigned 256-bit integer number into quadruple precision number.
93    *
94    * @param x unsigned 256-bit integer number
95    * @return quadruple precision number
96    */
97   function fromUInt (uint256 x) internal pure returns (bytes16) {
98     if (x == 0) return bytes16 (0);
99     else {
100       uint256 result = x;
101 
102       uint256 msb = msb (result);
103       if (msb < 112) result <<= 112 - msb;
104       else if (msb > 112) result >>= msb - 112;
105 
106       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16383 + msb << 112;
107 
108       return bytes16 (uint128 (result));
109     }
110   }
111 
112   /**
113    * Convert quadruple precision number into unsigned 256-bit integer number
114    * rounding towards zero.  Revert on underflow.  Note, that negative floating
115    * point numbers in range (-1.0 .. 0.0) may be converted to unsigned integer
116    * without error, because they are rounded to zero.
117    *
118    * @param x quadruple precision number
119    * @return unsigned 256-bit integer number
120    */
121   function toUInt (bytes16 x) internal pure returns (uint256) {
122     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
123 
124     if (exponent < 16383) return 0; // Underflow
125 
126     require (uint128 (x) < 0x80000000000000000000000000000000); // Negative
127 
128     require (exponent <= 16638); // Overflow
129     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
130       0x10000000000000000000000000000;
131 
132     if (exponent < 16495) result >>= 16495 - exponent;
133     else if (exponent > 16495) result <<= exponent - 16495;
134 
135     return result;
136   }
137 
138   /**
139    * Convert signed 128.128 bit fixed point number into quadruple precision
140    * number.
141    *
142    * @param x signed 128.128 bit fixed point number
143    * @return quadruple precision number
144    */
145   function from128x128 (int256 x) internal pure returns (bytes16) {
146     if (x == 0) return bytes16 (0);
147     else {
148       // We rely on overflow behavior here
149       uint256 result = uint256 (x > 0 ? x : -x);
150 
151       uint256 msb = msb (result);
152       if (msb < 112) result <<= 112 - msb;
153       else if (msb > 112) result >>= msb - 112;
154 
155       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16255 + msb << 112;
156       if (x < 0) result |= 0x80000000000000000000000000000000;
157 
158       return bytes16 (uint128 (result));
159     }
160   }
161 
162   /**
163    * Convert quadruple precision number into signed 128.128 bit fixed point
164    * number.  Revert on overflow.
165    *
166    * @param x quadruple precision number
167    * @return signed 128.128 bit fixed point number
168    */
169   function to128x128 (bytes16 x) internal pure returns (int256) {
170     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
171 
172     require (exponent <= 16510); // Overflow
173     if (exponent < 16255) return 0; // Underflow
174 
175     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
176       0x10000000000000000000000000000;
177 
178     if (exponent < 16367) result >>= 16367 - exponent;
179     else if (exponent > 16367) result <<= exponent - 16367;
180 
181     if (uint128 (x) >= 0x80000000000000000000000000000000) { // Negative
182       require (result <= 0x8000000000000000000000000000000000000000000000000000000000000000);
183       return -int256 (result); // We rely on overflow behavior here
184     } else {
185       require (result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
186       return int256 (result);
187     }
188   }
189 
190   /**
191    * Convert signed 64.64 bit fixed point number into quadruple precision
192    * number.
193    *
194    * @param x signed 64.64 bit fixed point number
195    * @return quadruple precision number
196    */
197   function from64x64 (int128 x) internal pure returns (bytes16) {
198     if (x == 0) return bytes16 (0);
199     else {
200       // We rely on overflow behavior here
201       uint256 result = uint128 (x > 0 ? x : -x);
202 
203       uint256 msb = msb (result);
204       if (msb < 112) result <<= 112 - msb;
205       else if (msb > 112) result >>= msb - 112;
206 
207       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16319 + msb << 112;
208       if (x < 0) result |= 0x80000000000000000000000000000000;
209 
210       return bytes16 (uint128 (result));
211     }
212   }
213 
214   /**
215    * Convert quadruple precision number into signed 64.64 bit fixed point
216    * number.  Revert on overflow.
217    *
218    * @param x quadruple precision number
219    * @return signed 64.64 bit fixed point number
220    */
221   function to64x64 (bytes16 x) internal pure returns (int128) {
222     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
223 
224     require (exponent <= 16446); // Overflow
225     if (exponent < 16319) return 0; // Underflow
226 
227     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
228       0x10000000000000000000000000000;
229 
230     if (exponent < 16431) result >>= 16431 - exponent;
231     else if (exponent > 16431) result <<= exponent - 16431;
232 
233     if (uint128 (x) >= 0x80000000000000000000000000000000) { // Negative
234       require (result <= 0x80000000000000000000000000000000);
235       return -int128 (result); // We rely on overflow behavior here
236     } else {
237       require (result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
238       return int128 (result);
239     }
240   }
241 
242   /**
243    * Convert octuple precision number into quadruple precision number.
244    *
245    * @param x octuple precision number
246    * @return quadruple precision number
247    */
248   function fromOctuple (bytes32 x) internal pure returns (bytes16) {
249     bool negative = x & 0x8000000000000000000000000000000000000000000000000000000000000000 > 0;
250 
251     uint256 exponent = uint256 (x) >> 236 & 0x7FFFF;
252     uint256 significand = uint256 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
253 
254     if (exponent == 0x7FFFF) {
255       if (significand > 0) return NaN;
256       else return negative ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
257     }
258 
259     if (exponent > 278526)
260       return negative ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
261     else if (exponent < 245649)
262       return negative ? NEGATIVE_ZERO : POSITIVE_ZERO;
263     else if (exponent < 245761) {
264       significand = (significand | 0x100000000000000000000000000000000000000000000000000000000000) >> 245885 - exponent;
265       exponent = 0;
266     } else {
267       significand >>= 124;
268       exponent -= 245760;
269     }
270 
271     uint128 result = uint128 (significand | exponent << 112);
272     if (negative) result |= 0x80000000000000000000000000000000;
273 
274     return bytes16 (result);
275   }
276 
277   /**
278    * Convert quadruple precision number into octuple precision number.
279    *
280    * @param x quadruple precision number
281    * @return octuple precision number
282    */
283   function toOctuple (bytes16 x) internal pure returns (bytes32) {
284     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
285 
286     uint256 result = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
287 
288     if (exponent == 0x7FFF) exponent = 0x7FFFF; // Infinity or NaN
289     else if (exponent == 0) {
290       if (result > 0) {
291         uint256 msb = msb (result);
292         result = result << 236 - msb & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
293         exponent = 245649 + msb;
294       }
295     } else {
296       result <<= 124;
297       exponent += 245760;
298     }
299 
300     result |= exponent << 236;
301     if (uint128 (x) >= 0x80000000000000000000000000000000)
302       result |= 0x8000000000000000000000000000000000000000000000000000000000000000;
303 
304     return bytes32 (result);
305   }
306 
307   /**
308    * Convert double precision number into quadruple precision number.
309    *
310    * @param x double precision number
311    * @return quadruple precision number
312    */
313   function fromDouble (bytes8 x) internal pure returns (bytes16) {
314     uint256 exponent = uint64 (x) >> 52 & 0x7FF;
315 
316     uint256 result = uint64 (x) & 0xFFFFFFFFFFFFF;
317 
318     if (exponent == 0x7FF) exponent = 0x7FFF; // Infinity or NaN
319     else if (exponent == 0) {
320       if (result > 0) {
321         uint256 msb = msb (result);
322         result = result << 112 - msb & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
323         exponent = 15309 + msb;
324       }
325     } else {
326       result <<= 60;
327       exponent += 15360;
328     }
329 
330     result |= exponent << 112;
331     if (x & 0x8000000000000000 > 0)
332       result |= 0x80000000000000000000000000000000;
333 
334     return bytes16 (uint128 (result));
335   }
336 
337   /**
338    * Convert quadruple precision number into double precision number.
339    *
340    * @param x quadruple precision number
341    * @return double precision number
342    */
343   function toDouble (bytes16 x) internal pure returns (bytes8) {
344     bool negative = uint128 (x) >= 0x80000000000000000000000000000000;
345 
346     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
347     uint256 significand = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
348 
349     if (exponent == 0x7FFF) {
350       if (significand > 0) return 0x7FF8000000000000; // NaN
351       else return negative ?
352           bytes8 (0xFFF0000000000000) : // -Infinity
353           bytes8 (0x7FF0000000000000); // Infinity
354     }
355 
356     if (exponent > 17406)
357       return negative ?
358           bytes8 (0xFFF0000000000000) : // -Infinity
359           bytes8 (0x7FF0000000000000); // Infinity
360     else if (exponent < 15309)
361       return negative ?
362           bytes8 (0x8000000000000000) : // -0
363           bytes8 (0x0000000000000000); // 0
364     else if (exponent < 15361) {
365       significand = (significand | 0x10000000000000000000000000000) >> 15421 - exponent;
366       exponent = 0;
367     } else {
368       significand >>= 60;
369       exponent -= 15360;
370     }
371 
372     uint64 result = uint64 (significand | exponent << 52);
373     if (negative) result |= 0x8000000000000000;
374 
375     return bytes8 (result);
376   }
377 
378   /**
379    * Test whether given quadruple precision number is NaN.
380    *
381    * @param x quadruple precision number
382    * @return true if x is NaN, false otherwise
383    */
384   function isNaN (bytes16 x) internal pure returns (bool) {
385     return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF >
386       0x7FFF0000000000000000000000000000;
387   }
388 
389   /**
390    * Test whether given quadruple precision number is positive or negative
391    * infinity.
392    *
393    * @param x quadruple precision number
394    * @return true if x is positive or negative infinity, false otherwise
395    */
396   function isInfinity (bytes16 x) internal pure returns (bool) {
397     return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ==
398       0x7FFF0000000000000000000000000000;
399   }
400 
401   /**
402    * Calculate sign of x, i.e. -1 if x is negative, 0 if x if zero, and 1 if x
403    * is positive.  Note that sign (-0) is zero.  Revert if x is NaN. 
404    *
405    * @param x quadruple precision number
406    * @return sign of x
407    */
408   function sign (bytes16 x) internal pure returns (int8) {
409     uint128 absoluteX = uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
410 
411     require (absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN
412 
413     if (absoluteX == 0) return 0;
414     else if (uint128 (x) >= 0x80000000000000000000000000000000) return -1;
415     else return 1;
416   }
417 
418   /**
419    * Calculate sign (x - y).  Revert if either argument is NaN, or both
420    * arguments are infinities of the same sign. 
421    *
422    * @param x quadruple precision number
423    * @param y quadruple precision number
424    * @return sign (x - y)
425    */
426   function cmp (bytes16 x, bytes16 y) internal pure returns (int8) {
427     uint128 absoluteX = uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
428 
429     require (absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN
430 
431     uint128 absoluteY = uint128 (y) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
432 
433     require (absoluteY <= 0x7FFF0000000000000000000000000000); // Not NaN
434 
435     // Not infinities of the same sign
436     require (x != y || absoluteX < 0x7FFF0000000000000000000000000000);
437 
438     if (x == y) return 0;
439     else {
440       bool negativeX = uint128 (x) >= 0x80000000000000000000000000000000;
441       bool negativeY = uint128 (y) >= 0x80000000000000000000000000000000;
442 
443       if (negativeX) {
444         if (negativeY) return absoluteX > absoluteY ? -1 : int8 (1);
445         else return -1; 
446       } else {
447         if (negativeY) return 1;
448         else return absoluteX > absoluteY ? int8 (1) : -1;
449       }
450     }
451   }
452 
453   /**
454    * Test whether x equals y.  NaN, infinity, and -infinity are not equal to
455    * anything. 
456    *
457    * @param x quadruple precision number
458    * @param y quadruple precision number
459    * @return true if x equals to y, false otherwise
460    */
461   function eq (bytes16 x, bytes16 y) internal pure returns (bool) {
462     if (x == y) {
463       return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF <
464         0x7FFF0000000000000000000000000000;
465     } else return false;
466   }
467 
468   /**
469    * Calculate x + y.  Special values behave in the following way:
470    *
471    * NaN + x = NaN for any x.
472    * Infinity + x = Infinity for any finite x.
473    * -Infinity + x = -Infinity for any finite x.
474    * Infinity + Infinity = Infinity.
475    * -Infinity + -Infinity = -Infinity.
476    * Infinity + -Infinity = -Infinity + Infinity = NaN.
477    *
478    * @param x quadruple precision number
479    * @param y quadruple precision number
480    * @return quadruple precision number
481    */
482   function add (bytes16 x, bytes16 y) internal pure returns (bytes16) {
483     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
484     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
485 
486     if (xExponent == 0x7FFF) {
487       if (yExponent == 0x7FFF) { 
488         if (x == y) return x;
489         else return NaN;
490       } else return x; 
491     } else if (yExponent == 0x7FFF) return y;
492     else {
493       bool xSign = uint128 (x) >= 0x80000000000000000000000000000000;
494       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
495       if (xExponent == 0) xExponent = 1;
496       else xSignifier |= 0x10000000000000000000000000000;
497 
498       bool ySign = uint128 (y) >= 0x80000000000000000000000000000000;
499       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
500       if (yExponent == 0) yExponent = 1;
501       else ySignifier |= 0x10000000000000000000000000000;
502 
503       if (xSignifier == 0) return y == NEGATIVE_ZERO ? POSITIVE_ZERO : y;
504       else if (ySignifier == 0) return x == NEGATIVE_ZERO ? POSITIVE_ZERO : x;
505       else {
506         int256 delta = int256 (xExponent) - int256 (yExponent);
507   
508         if (xSign == ySign) {
509           if (delta > 112) return x;
510           else if (delta > 0) ySignifier >>= uint256 (delta);
511           else if (delta < -112) return y;
512           else if (delta < 0) {
513             xSignifier >>= uint256 (-delta);
514             xExponent = yExponent;
515           }
516   
517           xSignifier += ySignifier;
518   
519           if (xSignifier >= 0x20000000000000000000000000000) {
520             xSignifier >>= 1;
521             xExponent += 1;
522           }
523   
524           if (xExponent == 0x7FFF)
525             return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
526           else {
527             if (xSignifier < 0x10000000000000000000000000000) xExponent = 0;
528             else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
529   
530             return bytes16 (uint128 (
531                 (xSign ? 0x80000000000000000000000000000000 : 0) |
532                 (xExponent << 112) |
533                 xSignifier)); 
534           }
535         } else {
536           if (delta > 0) {
537             xSignifier <<= 1;
538             xExponent -= 1;
539           } else if (delta < 0) {
540             ySignifier <<= 1;
541             xExponent = yExponent - 1;
542           }
543 
544           if (delta > 112) ySignifier = 1;
545           else if (delta > 1) ySignifier = (ySignifier - 1 >> uint256 (delta - 1)) + 1;
546           else if (delta < -112) xSignifier = 1;
547           else if (delta < -1) xSignifier = (xSignifier - 1 >> uint256 (-delta - 1)) + 1;
548 
549           if (xSignifier >= ySignifier) xSignifier -= ySignifier;
550           else {
551             xSignifier = ySignifier - xSignifier;
552             xSign = ySign;
553           }
554 
555           if (xSignifier == 0)
556             return POSITIVE_ZERO;
557 
558           uint256 msb = msb (xSignifier);
559 
560           if (msb == 113) {
561             xSignifier = xSignifier >> 1 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
562             xExponent += 1;
563           } else if (msb < 112) {
564             uint256 shift = 112 - msb;
565             if (xExponent > shift) {
566               xSignifier = xSignifier << shift & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
567               xExponent -= shift;
568             } else {
569               xSignifier <<= xExponent - 1;
570               xExponent = 0;
571             }
572           } else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
573 
574           if (xExponent == 0x7FFF)
575             return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
576           else return bytes16 (uint128 (
577               (xSign ? 0x80000000000000000000000000000000 : 0) |
578               (xExponent << 112) |
579               xSignifier));
580         }
581       }
582     }
583   }
584 
585   /**
586    * Calculate x - y.  Special values behave in the following way:
587    *
588    * NaN - x = NaN for any x.
589    * Infinity - x = Infinity for any finite x.
590    * -Infinity - x = -Infinity for any finite x.
591    * Infinity - -Infinity = Infinity.
592    * -Infinity - Infinity = -Infinity.
593    * Infinity - Infinity = -Infinity - -Infinity = NaN.
594    *
595    * @param x quadruple precision number
596    * @param y quadruple precision number
597    * @return quadruple precision number
598    */
599   function sub (bytes16 x, bytes16 y) internal pure returns (bytes16) {
600     return add (x, y ^ 0x80000000000000000000000000000000);
601   }
602 
603   /**
604    * Calculate x * y.  Special values behave in the following way:
605    *
606    * NaN * x = NaN for any x.
607    * Infinity * x = Infinity for any finite positive x.
608    * Infinity * x = -Infinity for any finite negative x.
609    * -Infinity * x = -Infinity for any finite positive x.
610    * -Infinity * x = Infinity for any finite negative x.
611    * Infinity * 0 = NaN.
612    * -Infinity * 0 = NaN.
613    * Infinity * Infinity = Infinity.
614    * Infinity * -Infinity = -Infinity.
615    * -Infinity * Infinity = -Infinity.
616    * -Infinity * -Infinity = Infinity.
617    *
618    * @param x quadruple precision number
619    * @param y quadruple precision number
620    * @return quadruple precision number
621    */
622   function mul (bytes16 x, bytes16 y) internal pure returns (bytes16) {
623     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
624     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
625 
626     if (xExponent == 0x7FFF) {
627       if (yExponent == 0x7FFF) {
628         if (x == y) return x ^ y & 0x80000000000000000000000000000000;
629         else if (x ^ y == 0x80000000000000000000000000000000) return x | y;
630         else return NaN;
631       } else {
632         if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
633         else return x ^ y & 0x80000000000000000000000000000000;
634       }
635     } else if (yExponent == 0x7FFF) {
636         if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
637         else return y ^ x & 0x80000000000000000000000000000000;
638     } else {
639       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
640       if (xExponent == 0) xExponent = 1;
641       else xSignifier |= 0x10000000000000000000000000000;
642 
643       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
644       if (yExponent == 0) yExponent = 1;
645       else ySignifier |= 0x10000000000000000000000000000;
646 
647       xSignifier *= ySignifier;
648       if (xSignifier == 0)
649         return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
650             NEGATIVE_ZERO : POSITIVE_ZERO;
651 
652       xExponent += yExponent;
653 
654       uint256 msb =
655         xSignifier >= 0x200000000000000000000000000000000000000000000000000000000 ? 225 :
656         xSignifier >= 0x100000000000000000000000000000000000000000000000000000000 ? 224 :
657         msb (xSignifier);
658 
659       if (xExponent + msb < 16496) { // Underflow
660         xExponent = 0;
661         xSignifier = 0;
662       } else if (xExponent + msb < 16608) { // Subnormal
663         if (xExponent < 16496)
664           xSignifier >>= 16496 - xExponent;
665         else if (xExponent > 16496)
666           xSignifier <<= xExponent - 16496;
667         xExponent = 0;
668       } else if (xExponent + msb > 49373) {
669         xExponent = 0x7FFF;
670         xSignifier = 0;
671       } else {
672         if (msb > 112)
673           xSignifier >>= msb - 112;
674         else if (msb < 112)
675           xSignifier <<= 112 - msb;
676 
677         xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
678 
679         xExponent = xExponent + msb - 16607;
680       }
681 
682       return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
683           xExponent << 112 | xSignifier));
684     }
685   }
686 
687   /**
688    * Calculate x / y.  Special values behave in the following way:
689    *
690    * NaN / x = NaN for any x.
691    * x / NaN = NaN for any x.
692    * Infinity / x = Infinity for any finite non-negative x.
693    * Infinity / x = -Infinity for any finite negative x including -0.
694    * -Infinity / x = -Infinity for any finite non-negative x.
695    * -Infinity / x = Infinity for any finite negative x including -0.
696    * x / Infinity = 0 for any finite non-negative x.
697    * x / -Infinity = -0 for any finite non-negative x.
698    * x / Infinity = -0 for any finite non-negative x including -0.
699    * x / -Infinity = 0 for any finite non-negative x including -0.
700    * 
701    * Infinity / Infinity = NaN.
702    * Infinity / -Infinity = -NaN.
703    * -Infinity / Infinity = -NaN.
704    * -Infinity / -Infinity = NaN.
705    *
706    * Division by zero behaves in the following way:
707    *
708    * x / 0 = Infinity for any finite positive x.
709    * x / -0 = -Infinity for any finite positive x.
710    * x / 0 = -Infinity for any finite negative x.
711    * x / -0 = Infinity for any finite negative x.
712    * 0 / 0 = NaN.
713    * 0 / -0 = NaN.
714    * -0 / 0 = NaN.
715    * -0 / -0 = NaN.
716    *
717    * @param x quadruple precision number
718    * @param y quadruple precision number
719    * @return quadruple precision number
720    */
721   function div (bytes16 x, bytes16 y) internal pure returns (bytes16) {
722     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
723     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
724 
725     if (xExponent == 0x7FFF) {
726       if (yExponent == 0x7FFF) return NaN;
727       else return x ^ y & 0x80000000000000000000000000000000;
728     } else if (yExponent == 0x7FFF) {
729       if (y & 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF != 0) return NaN;
730       else return POSITIVE_ZERO | (x ^ y) & 0x80000000000000000000000000000000;
731     } else if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) {
732       if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
733       else return POSITIVE_INFINITY | (x ^ y) & 0x80000000000000000000000000000000;
734     } else {
735       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
736       if (yExponent == 0) yExponent = 1;
737       else ySignifier |= 0x10000000000000000000000000000;
738 
739       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
740       if (xExponent == 0) {
741         if (xSignifier != 0) {
742           uint shift = 226 - msb (xSignifier);
743 
744           xSignifier <<= shift;
745 
746           xExponent = 1;
747           yExponent += shift - 114;
748         }
749       }
750       else {
751         xSignifier = (xSignifier | 0x10000000000000000000000000000) << 114;
752       }
753 
754       xSignifier = xSignifier / ySignifier;
755       if (xSignifier == 0)
756         return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
757             NEGATIVE_ZERO : POSITIVE_ZERO;
758 
759       assert (xSignifier >= 0x1000000000000000000000000000);
760 
761       uint256 msb =
762         xSignifier >= 0x80000000000000000000000000000 ? msb (xSignifier) :
763         xSignifier >= 0x40000000000000000000000000000 ? 114 :
764         xSignifier >= 0x20000000000000000000000000000 ? 113 : 112;
765 
766       if (xExponent + msb > yExponent + 16497) { // Overflow
767         xExponent = 0x7FFF;
768         xSignifier = 0;
769       } else if (xExponent + msb + 16380  < yExponent) { // Underflow
770         xExponent = 0;
771         xSignifier = 0;
772       } else if (xExponent + msb + 16268  < yExponent) { // Subnormal
773         if (xExponent + 16380 > yExponent)
774           xSignifier <<= xExponent + 16380 - yExponent;
775         else if (xExponent + 16380 < yExponent)
776           xSignifier >>= yExponent - xExponent - 16380;
777 
778         xExponent = 0;
779       } else { // Normal
780         if (msb > 112)
781           xSignifier >>= msb - 112;
782 
783         xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
784 
785         xExponent = xExponent + msb + 16269 - yExponent;
786       }
787 
788       return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
789           xExponent << 112 | xSignifier));
790     }
791   }
792 
793   /**
794    * Calculate -x.
795    *
796    * @param x quadruple precision number
797    * @return quadruple precision number
798    */
799   function neg (bytes16 x) internal pure returns (bytes16) {
800     return x ^ 0x80000000000000000000000000000000;
801   }
802 
803   /**
804    * Calculate |x|.
805    *
806    * @param x quadruple precision number
807    * @return quadruple precision number
808    */
809   function abs (bytes16 x) internal pure returns (bytes16) {
810     return x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
811   }
812 
813   /**
814    * Calculate square root of x.  Return NaN on negative x excluding -0.
815    *
816    * @param x quadruple precision number
817    * @return quadruple precision number
818    */
819   function sqrt (bytes16 x) internal pure returns (bytes16) {
820     if (uint128 (x) >  0x80000000000000000000000000000000) return NaN;
821     else {
822       uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
823       if (xExponent == 0x7FFF) return x;
824       else {
825         uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
826         if (xExponent == 0) xExponent = 1;
827         else xSignifier |= 0x10000000000000000000000000000;
828 
829         if (xSignifier == 0) return POSITIVE_ZERO;
830 
831         bool oddExponent = xExponent & 0x1 == 0;
832         xExponent = xExponent + 16383 >> 1;
833 
834         if (oddExponent) {
835           if (xSignifier >= 0x10000000000000000000000000000)
836             xSignifier <<= 113;
837           else {
838             uint256 msb = msb (xSignifier);
839             uint256 shift = (226 - msb) & 0xFE;
840             xSignifier <<= shift;
841             xExponent -= shift - 112 >> 1;
842           }
843         } else {
844           if (xSignifier >= 0x10000000000000000000000000000)
845             xSignifier <<= 112;
846           else {
847             uint256 msb = msb (xSignifier);
848             uint256 shift = (225 - msb) & 0xFE;
849             xSignifier <<= shift;
850             xExponent -= shift - 112 >> 1;
851           }
852         }
853 
854         uint256 r = 0x10000000000000000000000000000;
855         r = (r + xSignifier / r) >> 1;
856         r = (r + xSignifier / r) >> 1;
857         r = (r + xSignifier / r) >> 1;
858         r = (r + xSignifier / r) >> 1;
859         r = (r + xSignifier / r) >> 1;
860         r = (r + xSignifier / r) >> 1;
861         r = (r + xSignifier / r) >> 1; // Seven iterations should be enough
862         uint256 r1 = xSignifier / r;
863         if (r1 < r) r = r1;
864 
865         return bytes16 (uint128 (xExponent << 112 | r & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
866       }
867     }
868   }
869 
870   /**
871    * Calculate binary logarithm of x.  Return NaN on negative x excluding -0.
872    *
873    * @param x quadruple precision number
874    * @return quadruple precision number
875    */
876   function log_2 (bytes16 x) internal pure returns (bytes16) {
877     if (uint128 (x) > 0x80000000000000000000000000000000) return NaN;
878     else if (x == 0x3FFF0000000000000000000000000000) return POSITIVE_ZERO; 
879     else {
880       uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
881       if (xExponent == 0x7FFF) return x;
882       else {
883         uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
884         if (xExponent == 0) xExponent = 1;
885         else xSignifier |= 0x10000000000000000000000000000;
886 
887         if (xSignifier == 0) return NEGATIVE_INFINITY;
888 
889         bool resultNegative;
890         uint256 resultExponent = 16495;
891         uint256 resultSignifier;
892 
893         if (xExponent >= 0x3FFF) {
894           resultNegative = false;
895           resultSignifier = xExponent - 0x3FFF;
896           xSignifier <<= 15;
897         } else {
898           resultNegative = true;
899           if (xSignifier >= 0x10000000000000000000000000000) {
900             resultSignifier = 0x3FFE - xExponent;
901             xSignifier <<= 15;
902           } else {
903             uint256 msb = msb (xSignifier);
904             resultSignifier = 16493 - msb;
905             xSignifier <<= 127 - msb;
906           }
907         }
908 
909         if (xSignifier == 0x80000000000000000000000000000000) {
910           if (resultNegative) resultSignifier += 1;
911           uint256 shift = 112 - msb (resultSignifier);
912           resultSignifier <<= shift;
913           resultExponent -= shift;
914         } else {
915           uint256 bb = resultNegative ? 1 : 0;
916           while (resultSignifier < 0x10000000000000000000000000000) {
917             resultSignifier <<= 1;
918             resultExponent -= 1;
919   
920             xSignifier *= xSignifier;
921             uint256 b = xSignifier >> 255;
922             resultSignifier += b ^ bb;
923             xSignifier >>= 127 + b;
924           }
925         }
926 
927         return bytes16 (uint128 ((resultNegative ? 0x80000000000000000000000000000000 : 0) |
928             resultExponent << 112 | resultSignifier & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
929       }
930     }
931   }
932 
933   /**
934    * Calculate natural logarithm of x.  Return NaN on negative x excluding -0.
935    *
936    * @param x quadruple precision number
937    * @return quadruple precision number
938    */
939   function ln (bytes16 x) internal pure returns (bytes16) {
940     return mul (log_2 (x), 0x3FFE62E42FEFA39EF35793C7673007E5);
941   }
942 
943   /**
944    * Calculate 2^x.
945    *
946    * @param x quadruple precision number
947    * @return quadruple precision number
948    */
949   function pow_2 (bytes16 x) internal pure returns (bytes16) {
950     bool xNegative = uint128 (x) > 0x80000000000000000000000000000000;
951     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
952     uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
953 
954     if (xExponent == 0x7FFF && xSignifier != 0) return NaN;
955     else if (xExponent > 16397)
956       return xNegative ? POSITIVE_ZERO : POSITIVE_INFINITY;
957     else if (xExponent < 16255)
958       return 0x3FFF0000000000000000000000000000;
959     else {
960       if (xExponent == 0) xExponent = 1;
961       else xSignifier |= 0x10000000000000000000000000000;
962 
963       if (xExponent > 16367)
964         xSignifier <<= xExponent - 16367;
965       else if (xExponent < 16367)
966         xSignifier >>= 16367 - xExponent;
967 
968       if (xNegative && xSignifier > 0x406E00000000000000000000000000000000)
969         return POSITIVE_ZERO;
970 
971       if (!xNegative && xSignifier > 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
972         return POSITIVE_INFINITY;
973 
974       uint256 resultExponent = xSignifier >> 128;
975       xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
976       if (xNegative && xSignifier != 0) {
977         xSignifier = ~xSignifier;
978         resultExponent += 1;
979       }
980 
981       uint256 resultSignifier = 0x80000000000000000000000000000000;
982       if (xSignifier & 0x80000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
983       if (xSignifier & 0x40000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
984       if (xSignifier & 0x20000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
985       if (xSignifier & 0x10000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
986       if (xSignifier & 0x8000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
987       if (xSignifier & 0x4000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
988       if (xSignifier & 0x2000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
989       if (xSignifier & 0x1000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
990       if (xSignifier & 0x800000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
991       if (xSignifier & 0x400000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
992       if (xSignifier & 0x200000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
993       if (xSignifier & 0x100000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
994       if (xSignifier & 0x80000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
995       if (xSignifier & 0x40000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
996       if (xSignifier & 0x20000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000162E525EE054754457D5995292026 >> 128;
997       if (xSignifier & 0x10000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
998       if (xSignifier & 0x8000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
999       if (xSignifier & 0x4000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
1000       if (xSignifier & 0x2000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000162E43F4F831060E02D839A9D16D >> 128;
1001       if (xSignifier & 0x1000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
1002       if (xSignifier & 0x800000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
1003       if (xSignifier & 0x400000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
1004       if (xSignifier & 0x200000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
1005       if (xSignifier & 0x100000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
1006       if (xSignifier & 0x80000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
1007       if (xSignifier & 0x40000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
1008       if (xSignifier & 0x20000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
1009       if (xSignifier & 0x10000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
1010       if (xSignifier & 0x8000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
1011       if (xSignifier & 0x4000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
1012       if (xSignifier & 0x2000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
1013       if (xSignifier & 0x1000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
1014       if (xSignifier & 0x800000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
1015       if (xSignifier & 0x400000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
1016       if (xSignifier & 0x200000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000162E42FEFB2FED257559BDAA >> 128;
1017       if (xSignifier & 0x100000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
1018       if (xSignifier & 0x80000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
1019       if (xSignifier & 0x40000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
1020       if (xSignifier & 0x20000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
1021       if (xSignifier & 0x10000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000B17217F7D20CF927C8E94C >> 128;
1022       if (xSignifier & 0x8000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
1023       if (xSignifier & 0x4000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000002C5C85FDF477B662B26945 >> 128;
1024       if (xSignifier & 0x2000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000162E42FEFA3AE53369388C >> 128;
1025       if (xSignifier & 0x1000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000B17217F7D1D351A389D40 >> 128;
1026       if (xSignifier & 0x800000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
1027       if (xSignifier & 0x400000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
1028       if (xSignifier & 0x200000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000162E42FEFA39FE95583C2 >> 128;
1029       if (xSignifier & 0x100000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
1030       if (xSignifier & 0x80000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
1031       if (xSignifier & 0x40000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000002C5C85FDF473E242EA38 >> 128;
1032       if (xSignifier & 0x20000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000162E42FEFA39F02B772C >> 128;
1033       if (xSignifier & 0x10000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
1034       if (xSignifier & 0x8000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
1035       if (xSignifier & 0x4000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000002C5C85FDF473DEA871F >> 128;
1036       if (xSignifier & 0x2000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000162E42FEFA39EF44D91 >> 128;
1037       if (xSignifier & 0x1000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000B17217F7D1CF79E949 >> 128;
1038       if (xSignifier & 0x800000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
1039       if (xSignifier & 0x400000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
1040       if (xSignifier & 0x200000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000162E42FEFA39EF366F >> 128;
1041       if (xSignifier & 0x100000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000B17217F7D1CF79AFA >> 128;
1042       if (xSignifier & 0x80000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
1043       if (xSignifier & 0x40000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
1044       if (xSignifier & 0x20000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000162E42FEFA39EF358 >> 128;
1045       if (xSignifier & 0x10000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000B17217F7D1CF79AB >> 128;
1046       if (xSignifier & 0x8000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000058B90BFBE8E7BCD5 >> 128;
1047       if (xSignifier & 0x4000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000002C5C85FDF473DE6A >> 128;
1048       if (xSignifier & 0x2000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000162E42FEFA39EF34 >> 128;
1049       if (xSignifier & 0x1000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000B17217F7D1CF799 >> 128;
1050       if (xSignifier & 0x800000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000058B90BFBE8E7BCC >> 128;
1051       if (xSignifier & 0x400000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000002C5C85FDF473DE5 >> 128;
1052       if (xSignifier & 0x200000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000162E42FEFA39EF2 >> 128;
1053       if (xSignifier & 0x100000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000B17217F7D1CF78 >> 128;
1054       if (xSignifier & 0x80000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000058B90BFBE8E7BB >> 128;
1055       if (xSignifier & 0x40000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000002C5C85FDF473DD >> 128;
1056       if (xSignifier & 0x20000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000162E42FEFA39EE >> 128;
1057       if (xSignifier & 0x10000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000B17217F7D1CF6 >> 128;
1058       if (xSignifier & 0x8000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000058B90BFBE8E7A >> 128;
1059       if (xSignifier & 0x4000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000002C5C85FDF473C >> 128;
1060       if (xSignifier & 0x2000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000162E42FEFA39D >> 128;
1061       if (xSignifier & 0x1000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000B17217F7D1CE >> 128;
1062       if (xSignifier & 0x800000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000058B90BFBE8E6 >> 128;
1063       if (xSignifier & 0x400000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000002C5C85FDF472 >> 128;
1064       if (xSignifier & 0x200000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000162E42FEFA38 >> 128;
1065       if (xSignifier & 0x100000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000B17217F7D1B >> 128;
1066       if (xSignifier & 0x80000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000058B90BFBE8D >> 128;
1067       if (xSignifier & 0x40000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000002C5C85FDF46 >> 128;
1068       if (xSignifier & 0x20000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000162E42FEFA2 >> 128;
1069       if (xSignifier & 0x10000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000B17217F7D0 >> 128;
1070       if (xSignifier & 0x8000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000058B90BFBE7 >> 128;
1071       if (xSignifier & 0x4000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000002C5C85FDF3 >> 128;
1072       if (xSignifier & 0x2000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000162E42FEF9 >> 128;
1073       if (xSignifier & 0x1000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000B17217F7C >> 128;
1074       if (xSignifier & 0x800000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000058B90BFBD >> 128;
1075       if (xSignifier & 0x400000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000002C5C85FDE >> 128;
1076       if (xSignifier & 0x200000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000162E42FEE >> 128;
1077       if (xSignifier & 0x100000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000B17217F6 >> 128;
1078       if (xSignifier & 0x80000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000058B90BFA >> 128;
1079       if (xSignifier & 0x40000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000002C5C85FC >> 128;
1080       if (xSignifier & 0x20000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000162E42FD >> 128;
1081       if (xSignifier & 0x10000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000B17217E >> 128;
1082       if (xSignifier & 0x8000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000058B90BE >> 128;
1083       if (xSignifier & 0x4000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000002C5C85E >> 128;
1084       if (xSignifier & 0x2000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000162E42E >> 128;
1085       if (xSignifier & 0x1000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000B17216 >> 128;
1086       if (xSignifier & 0x800000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000058B90A >> 128;
1087       if (xSignifier & 0x400000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000002C5C84 >> 128;
1088       if (xSignifier & 0x200000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000162E41 >> 128;
1089       if (xSignifier & 0x100000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000B1720 >> 128;
1090       if (xSignifier & 0x80000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000058B8F >> 128;
1091       if (xSignifier & 0x40000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000002C5C7 >> 128;
1092       if (xSignifier & 0x20000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000162E3 >> 128;
1093       if (xSignifier & 0x10000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000B171 >> 128;
1094       if (xSignifier & 0x8000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000058B8 >> 128;
1095       if (xSignifier & 0x4000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000002C5B >> 128;
1096       if (xSignifier & 0x2000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000162D >> 128;
1097       if (xSignifier & 0x1000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000B16 >> 128;
1098       if (xSignifier & 0x800 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000058A >> 128;
1099       if (xSignifier & 0x400 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000002C4 >> 128;
1100       if (xSignifier & 0x200 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000161 >> 128;
1101       if (xSignifier & 0x100 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000000B0 >> 128;
1102       if (xSignifier & 0x80 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000057 >> 128;
1103       if (xSignifier & 0x40 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000002B >> 128;
1104       if (xSignifier & 0x20 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000015 >> 128;
1105       if (xSignifier & 0x10 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000000A >> 128;
1106       if (xSignifier & 0x8 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000004 >> 128;
1107       if (xSignifier & 0x4 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000001 >> 128;
1108 
1109       if (!xNegative) {
1110         resultSignifier = resultSignifier >> 15 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1111         resultExponent += 0x3FFF;
1112       } else if (resultExponent <= 0x3FFE) {
1113         resultSignifier = resultSignifier >> 15 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
1114         resultExponent = 0x3FFF - resultExponent;
1115       } else {
1116         resultSignifier = resultSignifier >> resultExponent - 16367;
1117         resultExponent = 0;
1118       }
1119 
1120       return bytes16 (uint128 (resultExponent << 112 | resultSignifier));
1121     }
1122   }
1123 
1124   /**
1125    * Calculate e^x.
1126    *
1127    * @param x quadruple precision number
1128    * @return quadruple precision number
1129    */
1130   function exp (bytes16 x) internal pure returns (bytes16) {
1131     return pow_2 (mul (x, 0x3FFF71547652B82FE1777D0FFDA0D23A));
1132   }
1133 
1134   /**
1135    * Get index of the most significant non-zero bit in binary representation of
1136    * x.  Reverts if x is zero.
1137    *
1138    * @return index of the most significant non-zero bit in binary representation
1139    *         of x
1140    */
1141   function msb (uint256 x) private pure returns (uint256) {
1142     require (x > 0);
1143 
1144     uint256 result = 0;
1145 
1146     if (x >= 0x100000000000000000000000000000000) { x >>= 128; result += 128; }
1147     if (x >= 0x10000000000000000) { x >>= 64; result += 64; }
1148     if (x >= 0x100000000) { x >>= 32; result += 32; }
1149     if (x >= 0x10000) { x >>= 16; result += 16; }
1150     if (x >= 0x100) { x >>= 8; result += 8; }
1151     if (x >= 0x10) { x >>= 4; result += 4; }
1152     if (x >= 0x4) { x >>= 2; result += 2; }
1153     if (x >= 0x2) result += 1; // No need to shift x anymore
1154 
1155     return result;
1156   }
1157 }