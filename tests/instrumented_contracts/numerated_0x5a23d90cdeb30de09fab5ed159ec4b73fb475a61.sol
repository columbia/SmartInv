1 pragma solidity ^0.6.6;
2 
3 contract ABDKMathQuad {
4 /*
5  * ABDK Math Quad Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
6  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
7  */
8 
9 /**
10  * Smart contract library of mathematical functions operating with IEEE 754
11  * quadruple-precision binary floating-point numbers (quadruple precision
12  * numbers).  As long as quadruple precision numbers are 16-bytes long, they are
13  * represented by bytes16 type.
14  */
15   /**
16    * 0.
17    */
18   bytes16 private constant POSITIVE_ZERO = 0x00000000000000000000000000000000;
19 
20   /**
21    * -0.
22    */
23   bytes16 private constant NEGATIVE_ZERO = 0x80000000000000000000000000000000;
24 
25   /**
26    * +Infinity.
27    */
28   bytes16 private constant POSITIVE_INFINITY = 0x7FFF0000000000000000000000000000;
29 
30   /**
31    * -Infinity.
32    */
33   bytes16 private constant NEGATIVE_INFINITY = 0xFFFF0000000000000000000000000000;
34 
35   /**
36    * Canonical NaN value.
37    */
38   bytes16 private constant NaN = 0x7FFF8000000000000000000000000000;
39 
40   /**
41    * Convert unsigned 256-bit integer number into quadruple precision number.
42    *
43    * @param x unsigned 256-bit integer number
44    * @return quadruple precision number
45    */
46   function fromUInt (uint256 x) internal pure returns (bytes16) {
47     if (x == 0) return bytes16 (0);
48     else {
49       uint256 result = x;
50 
51       uint256 msb = msb (result);
52       if (msb < 112) result <<= 112 - msb;
53       else if (msb > 112) result >>= msb - 112;
54 
55       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16383 + msb << 112;
56 
57       return bytes16 (uint128 (result));
58     }
59   }
60 
61   /**
62    * Convert quadruple precision number into unsigned 256-bit integer number
63    * rounding towards zero.  Revert on underflow.  Note, that negative floating
64    * point numbers in range (-1.0 .. 0.0) may be converted to unsigned integer
65    * without error, because they are rounded to zero.
66    *
67    * @param x quadruple precision number
68    * @return unsigned 256-bit integer number
69    */
70   function toUInt (bytes16 x) internal pure returns (uint256) {
71     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
72 
73     if (exponent < 16383) return 0; // Underflow
74 
75     require (uint128 (x) < 0x80000000000000000000000000000000); // Negative
76 
77     require (exponent <= 16638); // Overflow
78     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
79       0x10000000000000000000000000000;
80 
81     if (exponent < 16495) result >>= 16495 - exponent;
82     else if (exponent > 16495) result <<= exponent - 16495;
83 
84     return result;
85   }
86 
87   /**
88    * Calculate x + y.  Special values behave in the following way:
89    *
90    * NaN + x = NaN for any x.
91    * Infinity + x = Infinity for any finite x.
92    * -Infinity + x = -Infinity for any finite x.
93    * Infinity + Infinity = Infinity.
94    * -Infinity + -Infinity = -Infinity.
95    * Infinity + -Infinity = -Infinity + Infinity = NaN.
96    *
97    * @param x quadruple precision number
98    * @param y quadruple precision number
99    * @return quadruple precision number
100    */
101   function addABDK (bytes16 x, bytes16 y) internal pure returns (bytes16) {
102     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
103     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
104 
105     if (xExponent == 0x7FFF) {
106       if (yExponent == 0x7FFF) { 
107         if (x == y) return x;
108         else return NaN;
109       } else return x; 
110     } else if (yExponent == 0x7FFF) return y;
111     else {
112       bool xSign = uint128 (x) >= 0x80000000000000000000000000000000;
113       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
114       if (xExponent == 0) xExponent = 1;
115       else xSignifier |= 0x10000000000000000000000000000;
116 
117       bool ySign = uint128 (y) >= 0x80000000000000000000000000000000;
118       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
119       if (yExponent == 0) yExponent = 1;
120       else ySignifier |= 0x10000000000000000000000000000;
121 
122       if (xSignifier == 0) return y == NEGATIVE_ZERO ? POSITIVE_ZERO : y;
123       else if (ySignifier == 0) return x == NEGATIVE_ZERO ? POSITIVE_ZERO : x;
124       else {
125         int256 delta = int256 (xExponent) - int256 (yExponent);
126   
127         if (xSign == ySign) {
128           if (delta > 112) return x;
129           else if (delta > 0) ySignifier >>= delta;
130           else if (delta < -112) return y;
131           else if (delta < 0) {
132             xSignifier >>= -delta;
133             xExponent = yExponent;
134           }
135   
136           xSignifier += ySignifier;
137   
138           if (xSignifier >= 0x20000000000000000000000000000) {
139             xSignifier >>= 1;
140             xExponent += 1;
141           }
142   
143           if (xExponent == 0x7FFF)
144             return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
145           else {
146             if (xSignifier < 0x10000000000000000000000000000) xExponent = 0;
147             else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
148   
149             return bytes16 (uint128 (
150                 (xSign ? 0x80000000000000000000000000000000 : 0) |
151                 (xExponent << 112) |
152                 xSignifier)); 
153           }
154         } else {
155           if (delta > 0) {
156             xSignifier <<= 1;
157             xExponent -= 1;
158           } else if (delta < 0) {
159             ySignifier <<= 1;
160             xExponent = yExponent - 1;
161           }
162 
163           if (delta > 112) ySignifier = 1;
164           else if (delta > 1) ySignifier = (ySignifier - 1 >> delta - 1) + 1;
165           else if (delta < -112) xSignifier = 1;
166           else if (delta < -1) xSignifier = (xSignifier - 1 >> -delta - 1) + 1;
167 
168           if (xSignifier >= ySignifier) xSignifier -= ySignifier;
169           else {
170             xSignifier = ySignifier - xSignifier;
171             xSign = ySign;
172           }
173 
174           if (xSignifier == 0)
175             return POSITIVE_ZERO;
176 
177           uint256 msb = msb (xSignifier);
178 
179           if (msb == 113) {
180             xSignifier = xSignifier >> 1 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
181             xExponent += 1;
182           } else if (msb < 112) {
183             uint256 shift = 112 - msb;
184             if (xExponent > shift) {
185               xSignifier = xSignifier << shift & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
186               xExponent -= shift;
187             } else {
188               xSignifier <<= xExponent - 1;
189               xExponent = 0;
190             }
191           } else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
192 
193           if (xExponent == 0x7FFF)
194             return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
195           else return bytes16 (uint128 (
196               (xSign ? 0x80000000000000000000000000000000 : 0) |
197               (xExponent << 112) |
198               xSignifier));
199         }
200       }
201     }
202   }
203 
204   /**
205    * Calculate x - y.  Special values behave in the following way:
206    *
207    * NaN - x = NaN for any x.
208    * Infinity - x = Infinity for any finite x.
209    * -Infinity - x = -Infinity for any finite x.
210    * Infinity - -Infinity = Infinity.
211    * -Infinity - Infinity = -Infinity.
212    * Infinity - Infinity = -Infinity - -Infinity = NaN.
213    *
214    * @param x quadruple precision number
215    * @param y quadruple precision number
216    * @return quadruple precision number
217    */
218   function subABDK (bytes16 x, bytes16 y) internal pure returns (bytes16) {
219     return addABDK(x, y ^ 0x80000000000000000000000000000000);
220   }
221 
222   /**
223    * Calculate x * y.  Special values behave in the following way:
224    *
225    * NaN * x = NaN for any x.
226    * Infinity * x = Infinity for any finite positive x.
227    * Infinity * x = -Infinity for any finite negative x.
228    * -Infinity * x = -Infinity for any finite positive x.
229    * -Infinity * x = Infinity for any finite negative x.
230    * Infinity * 0 = NaN.
231    * -Infinity * 0 = NaN.
232    * Infinity * Infinity = Infinity.
233    * Infinity * -Infinity = -Infinity.
234    * -Infinity * Infinity = -Infinity.
235    * -Infinity * -Infinity = Infinity.
236    *
237    * @param x quadruple precision number
238    * @param y quadruple precision number
239    * @return quadruple precision number
240    */
241   function mulABDK (bytes16 x, bytes16 y) internal pure returns (bytes16) {
242     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
243     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
244 
245     if (xExponent == 0x7FFF) {
246       if (yExponent == 0x7FFF) {
247         if (x == y) return x ^ y & 0x80000000000000000000000000000000;
248         else if (x ^ y == 0x80000000000000000000000000000000) return x | y;
249         else return NaN;
250       } else {
251         if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
252         else return x ^ y & 0x80000000000000000000000000000000;
253       }
254     } else if (yExponent == 0x7FFF) {
255         if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
256         else return y ^ x & 0x80000000000000000000000000000000;
257     } else {
258       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
259       if (xExponent == 0) xExponent = 1;
260       else xSignifier |= 0x10000000000000000000000000000;
261 
262       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
263       if (yExponent == 0) yExponent = 1;
264       else ySignifier |= 0x10000000000000000000000000000;
265 
266       xSignifier *= ySignifier;
267       if (xSignifier == 0)
268         return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
269             NEGATIVE_ZERO : POSITIVE_ZERO;
270 
271       xExponent += yExponent;
272 
273       uint256 msb =
274         xSignifier >= 0x200000000000000000000000000000000000000000000000000000000 ? 225 :
275         xSignifier >= 0x100000000000000000000000000000000000000000000000000000000 ? 224 :
276         msb (xSignifier);
277 
278       if (xExponent + msb < 16496) { // Underflow
279         xExponent = 0;
280         xSignifier = 0;
281       } else if (xExponent + msb < 16608) { // Subnormal
282         if (xExponent < 16496)
283           xSignifier >>= 16496 - xExponent;
284         else if (xExponent > 16496)
285           xSignifier <<= xExponent - 16496;
286         xExponent = 0;
287       } else if (xExponent + msb > 49373) {
288         xExponent = 0x7FFF;
289         xSignifier = 0;
290       } else {
291         if (msb > 112)
292           xSignifier >>= msb - 112;
293         else if (msb < 112)
294           xSignifier <<= 112 - msb;
295 
296         xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
297 
298         xExponent = xExponent + msb - 16607;
299       }
300 
301       return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
302           xExponent << 112 | xSignifier));
303     }
304   }
305 
306   /**
307    * Calculate x / y.  Special values behave in the following way:
308    *
309    * NaN / x = NaN for any x.
310    * x / NaN = NaN for any x.
311    * Infinity / x = Infinity for any finite non-negative x.
312    * Infinity / x = -Infinity for any finite negative x including -0.
313    * -Infinity / x = -Infinity for any finite non-negative x.
314    * -Infinity / x = Infinity for any finite negative x including -0.
315    * x / Infinity = 0 for any finite non-negative x.
316    * x / -Infinity = -0 for any finite non-negative x.
317    * x / Infinity = -0 for any finite non-negative x including -0.
318    * x / -Infinity = 0 for any finite non-negative x including -0.
319    * 
320    * Infinity / Infinity = NaN.
321    * Infinity / -Infinity = -NaN.
322    * -Infinity / Infinity = -NaN.
323    * -Infinity / -Infinity = NaN.
324    *
325    * Division by zero behaves in the following way:
326    *
327    * x / 0 = Infinity for any finite positive x.
328    * x / -0 = -Infinity for any finite positive x.
329    * x / 0 = -Infinity for any finite negative x.
330    * x / -0 = Infinity for any finite negative x.
331    * 0 / 0 = NaN.
332    * 0 / -0 = NaN.
333    * -0 / 0 = NaN.
334    * -0 / -0 = NaN.
335    *
336    * @param x quadruple precision number
337    * @param y quadruple precision number
338    * @return quadruple precision number
339    */
340   function divABDK (bytes16 x, bytes16 y) internal pure returns (bytes16) {
341     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
342     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
343 
344     if (xExponent == 0x7FFF) {
345       if (yExponent == 0x7FFF) return NaN;
346       else return x ^ y & 0x80000000000000000000000000000000;
347     } else if (yExponent == 0x7FFF) {
348       if (y & 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF != 0) return NaN;
349       else return POSITIVE_ZERO | (x ^ y) & 0x80000000000000000000000000000000;
350     } else if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) {
351       if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
352       else return POSITIVE_INFINITY | (x ^ y) & 0x80000000000000000000000000000000;
353     } else {
354       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
355       if (yExponent == 0) yExponent = 1;
356       else ySignifier |= 0x10000000000000000000000000000;
357 
358       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
359       if (xExponent == 0) {
360         if (xSignifier != 0) {
361           uint shift = 226 - msb (xSignifier);
362 
363           xSignifier <<= shift;
364 
365           xExponent = 1;
366           yExponent += shift - 114;
367         }
368       }
369       else {
370         xSignifier = (xSignifier | 0x10000000000000000000000000000) << 114;
371       }
372 
373       xSignifier = xSignifier / ySignifier;
374       if (xSignifier == 0)
375         return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
376             NEGATIVE_ZERO : POSITIVE_ZERO;
377 
378       assert (xSignifier >= 0x1000000000000000000000000000);
379 
380       uint256 msb =
381         xSignifier >= 0x80000000000000000000000000000 ? msb (xSignifier) :
382         xSignifier >= 0x40000000000000000000000000000 ? 114 :
383         xSignifier >= 0x20000000000000000000000000000 ? 113 : 112;
384 
385       if (xExponent + msb > yExponent + 16497) { // Overflow
386         xExponent = 0x7FFF;
387         xSignifier = 0;
388       } else if (xExponent + msb + 16380  < yExponent) { // Underflow
389         xExponent = 0;
390         xSignifier = 0;
391       } else if (xExponent + msb + 16268  < yExponent) { // Subnormal
392         if (xExponent + 16380 > yExponent)
393           xSignifier <<= xExponent + 16380 - yExponent;
394         else if (xExponent + 16380 < yExponent)
395           xSignifier >>= yExponent - xExponent - 16380;
396 
397         xExponent = 0;
398       } else { // Normal
399         if (msb > 112)
400           xSignifier >>= msb - 112;
401 
402         xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
403 
404         xExponent = xExponent + msb + 16269 - yExponent;
405       }
406 
407       return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
408           xExponent << 112 | xSignifier));
409     }
410   }
411 
412   /**
413    * Calculate 2^x.
414    *
415    * @param x quadruple precision number
416    * @return quadruple precision number
417    */
418   function pow_2 (bytes16 x) internal pure returns (bytes16) {
419     bool xNegative = uint128 (x) > 0x80000000000000000000000000000000;
420     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
421     uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
422 
423     if (xExponent == 0x7FFF && xSignifier != 0) return NaN;
424     else if (xExponent > 16397)
425       return xNegative ? POSITIVE_ZERO : POSITIVE_INFINITY;
426     else if (xExponent < 16255)
427       return 0x3FFF0000000000000000000000000000;
428     else {
429       if (xExponent == 0) xExponent = 1;
430       else xSignifier |= 0x10000000000000000000000000000;
431 
432       if (xExponent > 16367)
433         xSignifier <<= xExponent - 16367;
434       else if (xExponent < 16367)
435         xSignifier >>= 16367 - xExponent;
436 
437       if (xNegative && xSignifier > 0x406E00000000000000000000000000000000)
438         return POSITIVE_ZERO;
439 
440       if (!xNegative && xSignifier > 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
441         return POSITIVE_INFINITY;
442 
443       uint256 resultExponent = xSignifier >> 128;
444       xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
445       if (xNegative && xSignifier != 0) {
446         xSignifier = ~xSignifier;
447         resultExponent += 1;
448       }
449 
450       uint256 resultSignifier = 0x80000000000000000000000000000000;
451       if (xSignifier & 0x80000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
452       if (xSignifier & 0x40000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
453       if (xSignifier & 0x20000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
454       if (xSignifier & 0x10000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
455       if (xSignifier & 0x8000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
456       if (xSignifier & 0x4000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
457       if (xSignifier & 0x2000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
458       if (xSignifier & 0x1000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
459       if (xSignifier & 0x800000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
460       if (xSignifier & 0x400000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
461       if (xSignifier & 0x200000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
462       if (xSignifier & 0x100000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
463       if (xSignifier & 0x80000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
464       if (xSignifier & 0x40000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
465       if (xSignifier & 0x20000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000162E525EE054754457D5995292026 >> 128;
466       if (xSignifier & 0x10000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
467       if (xSignifier & 0x8000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
468       if (xSignifier & 0x4000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
469       if (xSignifier & 0x2000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000162E43F4F831060E02D839A9D16D >> 128;
470       if (xSignifier & 0x1000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
471       if (xSignifier & 0x800000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
472       if (xSignifier & 0x400000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
473       if (xSignifier & 0x200000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
474       if (xSignifier & 0x100000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
475       if (xSignifier & 0x80000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
476       if (xSignifier & 0x40000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
477       if (xSignifier & 0x20000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
478       if (xSignifier & 0x10000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
479       if (xSignifier & 0x8000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
480       if (xSignifier & 0x4000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
481       if (xSignifier & 0x2000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
482       if (xSignifier & 0x1000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
483       if (xSignifier & 0x800000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
484       if (xSignifier & 0x400000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
485       if (xSignifier & 0x200000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000162E42FEFB2FED257559BDAA >> 128;
486       if (xSignifier & 0x100000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
487       if (xSignifier & 0x80000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
488       if (xSignifier & 0x40000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
489       if (xSignifier & 0x20000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
490       if (xSignifier & 0x10000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000B17217F7D20CF927C8E94C >> 128;
491       if (xSignifier & 0x8000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
492       if (xSignifier & 0x4000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000002C5C85FDF477B662B26945 >> 128;
493       if (xSignifier & 0x2000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000162E42FEFA3AE53369388C >> 128;
494       if (xSignifier & 0x1000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000B17217F7D1D351A389D40 >> 128;
495       if (xSignifier & 0x800000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
496       if (xSignifier & 0x400000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
497       if (xSignifier & 0x200000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000162E42FEFA39FE95583C2 >> 128;
498       if (xSignifier & 0x100000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
499       if (xSignifier & 0x80000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
500       if (xSignifier & 0x40000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000002C5C85FDF473E242EA38 >> 128;
501       if (xSignifier & 0x20000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000162E42FEFA39F02B772C >> 128;
502       if (xSignifier & 0x10000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
503       if (xSignifier & 0x8000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
504       if (xSignifier & 0x4000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000002C5C85FDF473DEA871F >> 128;
505       if (xSignifier & 0x2000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000162E42FEFA39EF44D91 >> 128;
506       if (xSignifier & 0x1000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000B17217F7D1CF79E949 >> 128;
507       if (xSignifier & 0x800000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
508       if (xSignifier & 0x400000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
509       if (xSignifier & 0x200000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000162E42FEFA39EF366F >> 128;
510       if (xSignifier & 0x100000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000B17217F7D1CF79AFA >> 128;
511       if (xSignifier & 0x80000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
512       if (xSignifier & 0x40000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
513       if (xSignifier & 0x20000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000162E42FEFA39EF358 >> 128;
514       if (xSignifier & 0x10000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000B17217F7D1CF79AB >> 128;
515       if (xSignifier & 0x8000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000058B90BFBE8E7BCD5 >> 128;
516       if (xSignifier & 0x4000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000002C5C85FDF473DE6A >> 128;
517       if (xSignifier & 0x2000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000162E42FEFA39EF34 >> 128;
518       if (xSignifier & 0x1000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000B17217F7D1CF799 >> 128;
519       if (xSignifier & 0x800000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000058B90BFBE8E7BCC >> 128;
520       if (xSignifier & 0x400000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000002C5C85FDF473DE5 >> 128;
521       if (xSignifier & 0x200000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000162E42FEFA39EF2 >> 128;
522       if (xSignifier & 0x100000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000B17217F7D1CF78 >> 128;
523       if (xSignifier & 0x80000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000058B90BFBE8E7BB >> 128;
524       if (xSignifier & 0x40000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000002C5C85FDF473DD >> 128;
525       if (xSignifier & 0x20000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000162E42FEFA39EE >> 128;
526       if (xSignifier & 0x10000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000B17217F7D1CF6 >> 128;
527       if (xSignifier & 0x8000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000058B90BFBE8E7A >> 128;
528       if (xSignifier & 0x4000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000002C5C85FDF473C >> 128;
529       if (xSignifier & 0x2000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000162E42FEFA39D >> 128;
530       if (xSignifier & 0x1000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000B17217F7D1CE >> 128;
531       if (xSignifier & 0x800000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000058B90BFBE8E6 >> 128;
532       if (xSignifier & 0x400000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000002C5C85FDF472 >> 128;
533       if (xSignifier & 0x200000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000162E42FEFA38 >> 128;
534       if (xSignifier & 0x100000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000B17217F7D1B >> 128;
535       if (xSignifier & 0x80000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000058B90BFBE8D >> 128;
536       if (xSignifier & 0x40000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000002C5C85FDF46 >> 128;
537       if (xSignifier & 0x20000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000162E42FEFA2 >> 128;
538       if (xSignifier & 0x10000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000B17217F7D0 >> 128;
539       if (xSignifier & 0x8000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000058B90BFBE7 >> 128;
540       if (xSignifier & 0x4000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000002C5C85FDF3 >> 128;
541       if (xSignifier & 0x2000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000162E42FEF9 >> 128;
542       if (xSignifier & 0x1000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000B17217F7C >> 128;
543       if (xSignifier & 0x800000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000058B90BFBD >> 128;
544       if (xSignifier & 0x400000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000002C5C85FDE >> 128;
545       if (xSignifier & 0x200000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000162E42FEE >> 128;
546       if (xSignifier & 0x100000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000B17217F6 >> 128;
547       if (xSignifier & 0x80000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000058B90BFA >> 128;
548       if (xSignifier & 0x40000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000002C5C85FC >> 128;
549       if (xSignifier & 0x20000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000162E42FD >> 128;
550       if (xSignifier & 0x10000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000B17217E >> 128;
551       if (xSignifier & 0x8000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000058B90BE >> 128;
552       if (xSignifier & 0x4000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000002C5C85E >> 128;
553       if (xSignifier & 0x2000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000162E42E >> 128;
554       if (xSignifier & 0x1000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000B17216 >> 128;
555       if (xSignifier & 0x800000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000058B90A >> 128;
556       if (xSignifier & 0x400000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000002C5C84 >> 128;
557       if (xSignifier & 0x200000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000162E41 >> 128;
558       if (xSignifier & 0x100000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000B1720 >> 128;
559       if (xSignifier & 0x80000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000058B8F >> 128;
560       if (xSignifier & 0x40000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000002C5C7 >> 128;
561       if (xSignifier & 0x20000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000162E3 >> 128;
562       if (xSignifier & 0x10000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000B171 >> 128;
563       if (xSignifier & 0x8000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000058B8 >> 128;
564       if (xSignifier & 0x4000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000002C5B >> 128;
565       if (xSignifier & 0x2000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000162D >> 128;
566       if (xSignifier & 0x1000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000B16 >> 128;
567       if (xSignifier & 0x800 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000058A >> 128;
568       if (xSignifier & 0x400 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000002C4 >> 128;
569       if (xSignifier & 0x200 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000161 >> 128;
570       if (xSignifier & 0x100 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000000B0 >> 128;
571       if (xSignifier & 0x80 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000057 >> 128;
572       if (xSignifier & 0x40 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000002B >> 128;
573       if (xSignifier & 0x20 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000015 >> 128;
574       if (xSignifier & 0x10 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000000A >> 128;
575       if (xSignifier & 0x8 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000004 >> 128;
576       if (xSignifier & 0x4 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000001 >> 128;
577 
578       if (!xNegative) {
579         resultSignifier = resultSignifier >> 15 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
580         resultExponent += 0x3FFF;
581       } else if (resultExponent <= 0x3FFE) {
582         resultSignifier = resultSignifier >> 15 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
583         resultExponent = 0x3FFF - resultExponent;
584       } else {
585         resultSignifier = resultSignifier >> resultExponent - 16367;
586         resultExponent = 0;
587       }
588 
589       return bytes16 (uint128 (resultExponent << 112 | resultSignifier));
590     }
591   }
592 
593   /**
594    * Calculate e^x.
595    *
596    * @param x quadruple precision number
597    * @return quadruple precision number
598    */
599   function exp (bytes16 x) internal pure returns (bytes16) {
600     return pow_2 (mulABDK (x, 0x3FFF71547652B82FE1777D0FFDA0D23A));
601   }
602   
603   function msb (uint256 x) private pure returns (uint256) {
604     require (x > 0);
605 
606     uint256 result = 0;
607 
608     if (x >= 0x100000000000000000000000000000000) { x >>= 128; result += 128; }
609     if (x >= 0x10000000000000000) { x >>= 64; result += 64; }
610     if (x >= 0x100000000) { x >>= 32; result += 32; }
611     if (x >= 0x10000) { x >>= 16; result += 16; }
612     if (x >= 0x100) { x >>= 8; result += 8; }
613     if (x >= 0x10) { x >>= 4; result += 4; }
614     if (x >= 0x4) { x >>= 2; result += 2; }
615     if (x >= 0x2) result += 1; // No need to shift x anymore
616 
617     return result;
618   }
619   
620   function totalSupplyAtTime (uint t) internal pure returns (bytes16 fin) {
621       bytes16 xQuad = fromUInt(t);
622       bytes16 xQuadSub = subABDK(xQuad, 0x4016e133800000000000000000000000);
623       bytes16 exponent = mulABDK(xQuadSub, 0xbfea0c6f7a0b5ed8d36b4c7f34938583);
624       bytes16 expExp = exp(exponent);
625       bytes16 bottom = addABDK(0x3fff0000000000000000000000000000, expExp);
626       bytes16 whole = divABDK(0x402a22db571485000000000000000000, bottom);
627       fin = addABDK(whole, 0x401f73b9fbd700000000000000000000);
628   }
629   
630 }
631 
632 contract SafeMath {
633     
634     function add(uint256 a, uint256 b) internal pure returns (uint256) {
635         uint256 c = a + b;
636         require(c >= a, "SafeMath: addition overflow");
637         return c;
638     }
639     
640     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
641         return sub(a, b, "SafeMath: subtraction overflow");
642     }
643     
644     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
645         require(b <= a, errorMessage);
646         uint256 c = a - b;
647         return c;
648     }
649     
650     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
651         if (a == 0) {
652             return 0;
653         }
654         uint256 c = a * b;
655         require(c / a == b, "SafeMath: multiplication overflow");
656         return c;
657     }
658     
659     function div(uint256 a, uint256 b) internal pure returns (uint256) {
660         return div(a, b, "SafeMath: division by zero");
661     }
662     
663     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
664         require(b > 0, errorMessage);
665         uint256 c = a / b;
666         return c;
667     }
668     
669     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
670         return mod(a, b, "SafeMath: modulo by zero");
671     }
672     
673     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
674         require(b != 0, errorMessage);
675         return a % b;
676     }
677     
678 }
679 
680 contract ERC20wRebase is SafeMath, ABDKMathQuad {
681 
682   string public name;
683   string public symbol;
684   uint8 public decimals;
685   address public _owner;
686   uint private supplyTotal;
687   uint private constant _decimals = 9;
688   uint private constant uintMax = ~uint256(0);
689   uint private constant tokensMax = 10**4 * 10**_decimals;
690   uint private tokensInitial = 10**1 * 10**_decimals;
691   uint internal unitsPerToken;
692   uint private unitsTotal = uintMax - (uintMax % tokensMax);
693   uint public tokensCurrent;
694 
695   mapping(address => uint) balances;
696   mapping(address => mapping(address => uint)) allowed;
697 
698   event Transfer(address indexed from, address indexed to, uint tokens);
699   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
700 
701   modifier onlyOwner() {
702     require(_owner == msg.sender, "Ownable: caller is not the owner");
703     _;
704   }
705 
706   constructor() public {
707     name = "Arsu";
708     symbol = "ARSU";
709     decimals = 9;
710     supplyTotal = tokensMax;
711     unitsPerToken = div(unitsTotal, supplyTotal);
712     uint unitsInitial =  mul(unitsPerToken, tokensInitial);
713     tokensCurrent = tokensInitial;
714     balances[msg.sender] = unitsInitial;
715     _owner = msg.sender;
716     emit Transfer(address(0), msg.sender, tokensInitial);
717   }
718 
719   function rebase(int supplyDelta) external onlyOwner returns (uint) {
720     if (supplyDelta == 0) {
721         emit RebaseEvent(supplyDelta);
722         return supplyTotal;
723     }
724     
725     if (supplyDelta < 0) {
726         tokensCurrent = sub(tokensCurrent, div(mul(uint(-supplyDelta), tokensCurrent), supplyTotal));
727         supplyTotal = sub(supplyTotal, uint(-supplyDelta));
728     }
729     
730     if (supplyDelta > 0) {
731         tokensCurrent = add(tokensCurrent, div(mul(uint(supplyDelta), tokensCurrent), supplyTotal));
732         supplyTotal = add(supplyTotal, uint(supplyDelta));
733     }
734 
735     unitsPerToken = div(unitsTotal, supplyTotal);
736 
737     emit RebaseEvent(supplyDelta);
738     return supplyTotal;
739   }
740 
741   function totalSupply() public view returns (uint) {
742     return tokensCurrent;
743   }
744   
745   function balanceOf(address who) public view returns (uint) {
746     return div(balances[who], unitsPerToken);
747   }
748 
749   function transfer(address to, uint value) public returns (bool) {
750     uint unitValue = mul(value, unitsPerToken);
751     balances[msg.sender] = sub(balances[msg.sender], unitValue);
752     balances[to] = add(balances[to], unitValue);
753     emit Transfer(msg.sender, to, value);
754     return true;
755   }
756 
757   function allowance(address owner_, address spender) public view returns (uint) {
758     return allowed[owner_][spender];
759   }
760 
761   function transferFrom(address from, address to, uint256 value) public returns (bool) {
762     allowed[from][msg.sender] = sub(allowed[from][msg.sender], value);
763 
764     uint unitValue = mul(value, unitsPerToken);
765     balances[from] = sub(balances[from], unitValue);
766     balances[to] = add(balances[to], unitValue);
767     emit Transfer(from, to, value);
768 
769     return true;
770   }
771 
772   function approve(address spender, uint value) public returns (bool) {
773     allowed[msg.sender][spender] = value;
774     emit Approval(msg.sender, spender, value);
775     return true;
776   }
777 
778   function increaseAllowance(address spender, uint addedValue) public returns (bool) {
779     allowed[msg.sender][spender] = add(allowed[msg.sender][spender], addedValue);
780     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
781     return true;
782   }
783 
784   function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
785     uint256 oldValue = allowed[msg.sender][spender];
786     if (subtractedValue >= oldValue) {
787       allowed[msg.sender][spender] = 0;
788     } else {
789       allowed[msg.sender][spender] = sub(oldValue, subtractedValue);
790     }
791     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
792     return true;
793   }
794 
795   event RebaseEvent(int supplyDelta);
796 
797 }
798 
799 abstract contract TwinContract {
800     
801     function totalBalanceOf(address _of) virtual public view returns (uint256 amount);
802     function mint(address unlocker, uint unlockAmount) virtual external returns (bool);
803     function getRewardsGiven() virtual public view returns(uint);
804     function rebase(int supplyDelta) virtual external returns (uint);
805     function getTokensCurrent() virtual public view returns(uint);
806     function getSupplyTotal() virtual public view returns (uint);
807     function setTokensCurrent(uint newTokens) virtual external returns(uint);
808     function getUnitsPerToken() virtual public view returns (uint);
809     
810 }
811 
812 abstract contract ThirdPartyContract {
813     
814     function transferFrom(address from, address to, uint256 value) virtual public returns (bool);
815     function transfer(address to, uint value) virtual public returns (bool);
816     
817 }
818 
819 contract Arsu is ERC20wRebase {
820   
821   uint public totalValueTPT;
822   uint public totalRewardsGivenTPT;
823   
824   address public twinAddress;
825   TwinContract private twinContract;
826   address public thirdPartyTokenAddress;
827   ThirdPartyContract private thirdPartyContract;
828   uint public lockingEnabledTime;
829   bool public lockEnabled = false;
830 
831   event Mint(address mintee, uint amount);
832   event Lock(address locker, uint lockAmount, uint duration);
833   event Unlock(address unlocker, uint unlockAmount);
834   event UpdatePosition(address updater, int amountDelta, int timeDelta);
835   event LockTPT(address locker, uint lockAmount, uint duration);
836   event UnlockTPT(address unlocker);
837   event UpdatePositionTPT(address updater, int amountDelta, int timeDelta);
838   event EnableLock();
839   event SetTwin(address twinAddress);
840   event SetTPT(address tptAddress);
841   event ChangeOwner(address newOwner);
842   
843   modifier onlyTwin() {
844     require(msg.sender == twinAddress, "Ownable: caller is not the owner");
845     _;
846   }
847   
848   function setTwin(address addr) external onlyOwner returns (bool) {
849     require(twinAddress == address(0), "TWIN_ALREADY_SET");
850     twinAddress = addr;
851     twinContract = TwinContract(addr);
852     emit SetTwin(addr);
853     return true;
854   }
855   
856   function setTPT(address addr) external onlyOwner returns (bool) {
857       thirdPartyTokenAddress = addr;
858       thirdPartyContract = ThirdPartyContract(addr);
859       emit SetTPT(addr);
860       return true;
861   }
862   
863   function changeOwner(address addr) external onlyOwner returns (bool) {
864     _owner = addr;
865     emit ChangeOwner(addr);
866     return true;
867   }
868 
869   mapping(address => lockStruct) public locked;
870   mapping(address => lockTPTStruct) public lockedTPT;
871   
872   struct lockStruct {
873     uint amount;
874     bytes16 percentSupplyLocked;
875     uint unlockTime;
876     bool punishmentFlag;
877     uint confirmedReward;
878     bytes16 supplyWhenLastModified;
879   }
880   
881   struct lockTPTStruct {
882     uint amount;
883     uint value;
884     uint unlockTime;
885     bool punishmentFlag;
886     uint confirmedReward;
887     bytes16 supplyWhenLastModified;
888   }
889   
890   function mint(address unlocker, uint unlockAmount) external onlyTwin returns (bool) {
891     uint addedTokens = unlockAmount;
892     uint addedUnits = mul(unitsPerToken, addedTokens);
893     tokensCurrent = add(tokensCurrent, addedTokens);
894     balances[unlocker] = add(balances[unlocker], addedUnits);
895     emit Mint(unlocker, unlockAmount);
896     return true;
897   }
898   
899   function enableLocking() external onlyOwner returns (bool) {
900     require(!lockEnabled, "LOCKING_ALREADY_ENABLED");
901     lockEnabled = true;
902     lockingEnabledTime = now;
903     emit EnableLock();
904     return lockEnabled;
905   }
906   
907   function lock(uint amount, uint duration) public returns (bool) {
908     require(locked[msg.sender].amount == 0, "POSITION_ALREADY_EXISTS");
909     require(amount > 0, "INVALID_AMOUNT");
910     require(duration > 0, "INVALID_DURATION");
911     require(lockEnabled, "LOCKING_NOT_ENABLED_YET");
912     uint unitAmount = mul(amount, unitsPerToken);
913     uint unitsCurrent = mul(tokensCurrent, unitsPerToken);
914     bytes16 percentSupplyLocked = divABDK(fromUInt(unitAmount), fromUInt(unitsCurrent));
915     uint unlockTime = add(now, duration);
916     locked[msg.sender] = lockStruct(unitAmount, percentSupplyLocked, unlockTime, false, 0, mulABDK(totalSupplyAtTime(sub(now, lockingEnabledTime)), 0x40d3c25c268497681c2650cb4be40d60));
917     transfer(address(this), amount);
918     emit Lock(msg.sender, amount, duration);
919     return true;
920   }
921   
922   function lockTPT(uint amount, uint duration) public returns (bool) {
923     require(lockedTPT[msg.sender].amount == 0, "POSITION_ALREADY_EXISTS");
924     require(amount > 0, "INVALID_AMOUNT");
925     require(duration > 0, "INVALID_DURATION");
926     require(lockEnabled, "LOCKING_NOT_ENABLED_YET");
927     uint value = mul(amount, mul(duration, duration));
928     totalValueTPT = add(totalValueTPT, value);
929     lockedTPT[msg.sender] = lockTPTStruct(amount, value, add(now, duration), false, 0, mulABDK(totalSupplyAtTime(sub(now, lockingEnabledTime)), 0x40d3c25c268497681c2650cb4be40d60));
930     thirdPartyContract.transferFrom(msg.sender, address(this), amount);
931     emit LockTPT(msg.sender, amount, duration);
932     return true;
933   }
934 
935   function calculateUnlockReward(address unlocker, uint unlockTime, bool includeConfirmed) private view returns (uint reward) {
936     bool pseudoFlag = false;
937     if (locked[unlocker].punishmentFlag || locked[unlocker].unlockTime > unlockTime) {
938       pseudoFlag = true;
939     }
940     int timeUnlockTimeDiff = int(unlockTime) - int(locked[unlocker].unlockTime);
941     if (timeUnlockTimeDiff < 0) {
942       timeUnlockTimeDiff = -timeUnlockTimeDiff;
943     }
944     uint minNowUnlockTime = (unlockTime + locked[unlocker].unlockTime) / 2 - uint(timeUnlockTimeDiff) / 2;
945     require(minNowUnlockTime == unlockTime || minNowUnlockTime == locked[unlocker].unlockTime, "MIN_ERROR");
946     reward = toUInt(mulABDK(subABDK(mulABDK(totalSupplyAtTime(sub(minNowUnlockTime, lockingEnabledTime)), 0x40d3c25c268497681c2650cb4be40d60), locked[unlocker].supplyWhenLastModified), locked[unlocker].percentSupplyLocked));
947     if (includeConfirmed) {
948         reward = add(reward, locked[unlocker].confirmedReward);
949     }
950     reward = div(reward, 3);
951     if (pseudoFlag) {
952       reward = div(reward, 2);
953     }
954   }
955   
956   function calculateUnlockRewardTPT(address unlocker, uint unlockTime, bool includeConfirmed) private view returns (uint reward) {
957     bool pseudoFlag = false;
958     if(lockedTPT[unlocker].punishmentFlag || lockedTPT[unlocker].unlockTime > unlockTime) {
959       pseudoFlag = true;
960     }
961     int timeUnlockTimeDiff = int(unlockTime) - int(lockedTPT[unlocker].unlockTime);
962     if (timeUnlockTimeDiff < 0) {
963       timeUnlockTimeDiff = -timeUnlockTimeDiff;
964     }
965     uint minNowUnlockTime = (unlockTime + lockedTPT[unlocker].unlockTime) / 2 - uint(timeUnlockTimeDiff) / 2;
966     require(minNowUnlockTime == unlockTime || minNowUnlockTime == lockedTPT[unlocker].unlockTime, "MIN_ERROR");
967     reward = toUInt(mulABDK(subABDK(mulABDK(totalSupplyAtTime(sub(minNowUnlockTime, lockingEnabledTime)), 0x40d3c25c268497681c2650cb4be40d60), lockedTPT[unlocker].supplyWhenLastModified), divABDK(fromUInt(lockedTPT[unlocker].value), fromUInt(totalValueTPT))));
968     if (includeConfirmed) {
969         reward = add(reward, lockedTPT[unlocker].confirmedReward);
970     }
971     reward = toUInt(mulABDK(fromUInt(reward), subABDK(0x3fff0000000000000000000000000000, divABDK(fromUInt(totalRewardsGivenTPT), mulABDK(subABDK(totalSupplyAtTime(sub(now, lockingEnabledTime)), 0x40202a05f20000000000000000000000), 0x40d3c25c268497681c2650cb4be40d60)))));
972     reward = toUInt(mulABDK(fromUInt(reward), 0x3ffe5555555555555555555555555555));
973     if (pseudoFlag) {
974       reward = div(reward, 2);
975     }      
976   }
977   
978   function updatePosition(int amountDelta, int durationDelta) public returns (bool) {
979     require(locked[msg.sender].amount > 0, "NO_POSITION");
980 
981     uint confirmedReward = calculateUnlockReward(msg.sender, now, false) * 2;
982     locked[msg.sender].confirmedReward = add(locked[msg.sender].confirmedReward, confirmedReward);
983 
984     uint unitsCurrent = mul(tokensCurrent, unitsPerToken);
985 
986     if (locked[msg.sender].unlockTime < now) {
987         require (durationDelta > 0, "DURATION_DELTA_OF_EXPIRED_POSITION_MUST_BE_POSITIVE");
988         require (amountDelta >= 0, "AMOUNT_DELTA_OF_EXPIRE_POSITION_MUST_BE_AT_LEAST_ZERO");
989         bytes16 percentSupplyLocked = divABDK(fromUInt(locked[msg.sender].amount), fromUInt(unitsCurrent));
990         locked[msg.sender].percentSupplyLocked = percentSupplyLocked;
991         locked[msg.sender].unlockTime = now;
992     }
993 
994     if (amountDelta > 0) {
995       uint unitDelta = mul(uint(amountDelta), unitsPerToken);
996       locked[msg.sender].amount = add(locked[msg.sender].amount, unitDelta);
997       bytes16 percentSupplyLocked = divABDK(fromUInt(unitDelta), fromUInt(unitsCurrent));
998       locked[msg.sender].percentSupplyLocked = addABDK(locked[msg.sender].percentSupplyLocked, percentSupplyLocked);
999       transfer(address(this), uint(amountDelta));
1000     }
1001     
1002     if (amountDelta < 0) {
1003       uint unitDelta = mul(uint(-amountDelta), unitsPerToken);
1004       locked[msg.sender].amount = sub(locked[msg.sender].amount, unitDelta);
1005       bytes16 percentSupplyLocked = divABDK(fromUInt(unitDelta), fromUInt(unitsCurrent));
1006       locked[msg.sender].percentSupplyLocked = subABDK(locked[msg.sender].percentSupplyLocked, percentSupplyLocked);
1007       locked[msg.sender].punishmentFlag = true;
1008       this.transfer(msg.sender, uint(-amountDelta));
1009     }
1010 
1011     if (durationDelta < 0) {
1012       locked[msg.sender].unlockTime = sub(locked[msg.sender].unlockTime, uint(-durationDelta));
1013       locked[msg.sender].punishmentFlag = true;
1014     }
1015 
1016     if (durationDelta > 0) {
1017       locked[msg.sender].unlockTime = add(locked[msg.sender].unlockTime, uint(durationDelta));
1018     }
1019     
1020     locked[msg.sender].supplyWhenLastModified = mulABDK(totalSupplyAtTime(sub(now, lockingEnabledTime)), 0x40d3c25c268497681c2650cb4be40d60);
1021 
1022     require(locked[msg.sender].amount > 0, "POSITION_AMOUNT_CANNOT_BE_NEGATIVE");
1023     require(locked[msg.sender].unlockTime > now, "UNLOCKTIME_MUST_BE_IN_FUTURE");
1024     
1025     emit UpdatePosition(msg.sender, amountDelta, durationDelta);
1026     return true;
1027   }
1028   
1029   function updatePositionTPT(int amountDelta, int durationDelta) public returns (bool) {
1030     require(lockedTPT[msg.sender].amount > 0, "NO_POSITION");
1031     
1032     uint confirmedReward = calculateUnlockRewardTPT(msg.sender, now, false) * 2;
1033     lockedTPT[msg.sender].confirmedReward = add(lockedTPT[msg.sender].confirmedReward, confirmedReward);
1034 
1035     if (lockedTPT[msg.sender].unlockTime < now) {
1036         require (durationDelta > 0, "DURATION_DELTA_OF_EXPIRED_POSITION_MUST_BE_POSITIVE");
1037         require (amountDelta >= 0, "AMOUNT_DELTA_OF_EXPIRE_POSITION_MUST_BE_AT_LEAST_ZERO");
1038         lockedTPT[msg.sender].unlockTime = now;
1039     }
1040 
1041     if (amountDelta > 0) {
1042       lockedTPT[msg.sender].amount = add(lockedTPT[msg.sender].amount, uint(amountDelta));
1043       uint timeUntilUnlock = sub(lockedTPT[msg.sender].unlockTime, now);
1044       uint value = mul(uint(amountDelta), mul(timeUntilUnlock, timeUntilUnlock));
1045       totalValueTPT = add(totalValueTPT, value);
1046       lockedTPT[msg.sender].value = add(lockedTPT[msg.sender].value, value);
1047       thirdPartyContract.transferFrom(msg.sender, address(this), uint(amountDelta));
1048     }
1049     
1050     if (amountDelta < 0) {
1051       lockedTPT[msg.sender].amount = sub(lockedTPT[msg.sender].amount, uint(-amountDelta));
1052       uint timeUntilUnlock = sub(lockedTPT[msg.sender].unlockTime, now);
1053       uint value = mul(uint(-amountDelta), mul(timeUntilUnlock, timeUntilUnlock));
1054       totalValueTPT = sub(totalValueTPT, value);
1055       lockedTPT[msg.sender].value = sub(lockedTPT[msg.sender].value, value);
1056       lockedTPT[msg.sender].punishmentFlag = true;
1057       thirdPartyContract.transfer(msg.sender, uint(-amountDelta));
1058     }
1059 
1060     if (durationDelta < 0) {
1061       lockedTPT[msg.sender].unlockTime = sub(lockedTPT[msg.sender].unlockTime, uint(-durationDelta));
1062       uint value = mul(lockedTPT[msg.sender].amount, mul(uint(-durationDelta), uint(-durationDelta)));
1063       totalValueTPT = sub(totalValueTPT, value);
1064       lockedTPT[msg.sender].value = sub(lockedTPT[msg.sender].value, value);
1065       lockedTPT[msg.sender].punishmentFlag = true;
1066     }
1067 
1068     if (durationDelta > 0) {
1069       lockedTPT[msg.sender].unlockTime = add(lockedTPT[msg.sender].unlockTime, uint(durationDelta));
1070       uint value = mul(lockedTPT[msg.sender].amount, mul(uint(durationDelta), uint(durationDelta)));
1071       totalValueTPT = add(totalValueTPT, value);
1072       lockedTPT[msg.sender].value = add(lockedTPT[msg.sender].value, value);
1073     }
1074     
1075     lockedTPT[msg.sender].supplyWhenLastModified = mulABDK(totalSupplyAtTime(sub(now, lockingEnabledTime)), 0x40d3c25c268497681c2650cb4be40d60);
1076     
1077     require(lockedTPT[msg.sender].amount > 0, "POSITION_AMOUNT_CANNOT_BE_NEGATIVE");
1078     require(lockedTPT[msg.sender].unlockTime > now, "UNLOCKTIME_MUST_BE_IN_FUTURE");
1079     
1080     emit UpdatePositionTPT(msg.sender, amountDelta, durationDelta);
1081     return true;
1082   }
1083   
1084   function unlock() public returns (bool success) {
1085     require(locked[msg.sender].amount > 0, "NO_POSITION");
1086     uint tokenAmount = div(locked[msg.sender].amount, unitsPerToken);
1087     this.transfer(msg.sender, tokenAmount);
1088     uint reward = calculateUnlockReward(msg.sender, now, true);
1089     uint rewardTokens = div(reward, twinContract.getUnitsPerToken());
1090     success = twinContract.mint(msg.sender, rewardTokens);
1091     locked[msg.sender] = lockStruct(0, bytes16(0), 0, false, 0, bytes16(0));
1092     require(success, "MINT_FAILED");
1093     emit UnlockTPT(msg.sender);
1094   }
1095   
1096   function unlockTPT() public returns (bool success) {
1097     require(lockedTPT[msg.sender].amount > 0, "NO_POSITION");
1098     thirdPartyContract.transfer(msg.sender, lockedTPT[msg.sender].amount);
1099     uint reward = calculateUnlockRewardTPT(msg.sender, now, true);
1100     totalRewardsGivenTPT = add(reward, totalRewardsGivenTPT);
1101     uint rewardTokens = div(reward, twinContract.getUnitsPerToken());
1102     success = twinContract.mint(msg.sender, rewardTokens);
1103     totalValueTPT = sub(totalValueTPT, lockedTPT[msg.sender].value);
1104     lockedTPT[msg.sender] = lockTPTStruct(0, 0, 0, false, 0, bytes16(0));
1105     require(success, "MINT_FAILED");
1106     emit UnlockTPT(msg.sender);
1107   }
1108   
1109   function getRewardTokens(address addr, uint time) public view returns (uint) {
1110     require(locked[addr].amount > 0, "NO_POSITION");
1111     return div(calculateUnlockReward(addr, time, true), twinContract.getUnitsPerToken());
1112   }
1113   
1114   function getLockedTokens(address addr) public view returns (uint) {
1115     require(locked[addr].amount > 0, "NO_POSITION");
1116     return div(locked[addr].amount, unitsPerToken);   
1117   }
1118   
1119   function getRewardTokensTPT(address addr, uint time) public view returns (uint) {
1120     require(lockedTPT[addr].amount > 0, "NO_POSITION");
1121     return div(calculateUnlockRewardTPT(addr, time, true), twinContract.getUnitsPerToken());
1122   }
1123   
1124   function getUnitsPerToken() public view returns (uint) {
1125       return unitsPerToken;
1126   }
1127 
1128 }