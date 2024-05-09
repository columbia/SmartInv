1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-25
3 */
4 
5 pragma solidity 0.5.16;
6 
7 contract Context {
8     constructor () internal { }
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; 
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 }
79 
80 library ABDKMathQuad {
81   bytes16 private constant POSITIVE_ZERO = 0x00000000000000000000000000000000;
82 
83   bytes16 private constant NEGATIVE_ZERO = 0x80000000000000000000000000000000;
84 
85   bytes16 private constant POSITIVE_INFINITY = 0x7FFF0000000000000000000000000000;
86 
87   bytes16 private constant NEGATIVE_INFINITY = 0xFFFF0000000000000000000000000000;
88 
89   bytes16 private constant NaN = 0x7FFF8000000000000000000000000000;
90 
91   function fromInt (int256 x) internal pure returns (bytes16) {
92     if (x == 0) return bytes16 (0);
93     else {
94       // We rely on overflow behavior here
95       uint256 result = uint256 (x > 0 ? x : -x);
96 
97       uint256 msb = msb (result);
98       if (msb < 112) result <<= 112 - msb;
99       else if (msb > 112) result >>= msb - 112;
100 
101       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16383 + msb << 112;
102       if (x < 0) result |= 0x80000000000000000000000000000000;
103 
104       return bytes16 (uint128 (result));
105     }
106   }
107 
108   function toInt (bytes16 x) internal pure returns (int256) {
109     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
110 
111     require (exponent <= 16638); // Overflow
112     if (exponent < 16383) return 0; // Underflow
113 
114     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
115       0x10000000000000000000000000000;
116 
117     if (exponent < 16495) result >>= 16495 - exponent;
118     else if (exponent > 16495) result <<= exponent - 16495;
119 
120     if (uint128 (x) >= 0x80000000000000000000000000000000) { // Negative
121       require (result <= 0x8000000000000000000000000000000000000000000000000000000000000000);
122       return -int256 (result); // We rely on overflow behavior here
123     } else {
124       require (result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
125       return int256 (result);
126     }
127   }
128 
129   function fromUInt (uint256 x) internal pure returns (bytes16) {
130     if (x == 0) return bytes16 (0);
131     else {
132       uint256 result = x;
133 
134       uint256 msb = msb (result);
135       if (msb < 112) result <<= 112 - msb;
136       else if (msb > 112) result >>= msb - 112;
137 
138       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16383 + msb << 112;
139 
140       return bytes16 (uint128 (result));
141     }
142   }
143 
144   function toUInt (bytes16 x) internal pure returns (uint256) {
145     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
146 
147     if (exponent < 16383) return 0; // Underflow
148 
149     require (uint128 (x) < 0x80000000000000000000000000000000); // Negative
150 
151     require (exponent <= 16638); // Overflow
152     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
153       0x10000000000000000000000000000;
154 
155     if (exponent < 16495) result >>= 16495 - exponent;
156     else if (exponent > 16495) result <<= exponent - 16495;
157 
158     return result;
159   }
160 
161   function from128x128 (int256 x) internal pure returns (bytes16) {
162     if (x == 0) return bytes16 (0);
163     else {
164       // We rely on overflow behavior here
165       uint256 result = uint256 (x > 0 ? x : -x);
166 
167       uint256 msb = msb (result);
168       if (msb < 112) result <<= 112 - msb;
169       else if (msb > 112) result >>= msb - 112;
170 
171       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16255 + msb << 112;
172       if (x < 0) result |= 0x80000000000000000000000000000000;
173 
174       return bytes16 (uint128 (result));
175     }
176   }
177 
178   function to128x128 (bytes16 x) internal pure returns (int256) {
179     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
180 
181     require (exponent <= 16510); // Overflow
182     if (exponent < 16255) return 0; // Underflow
183 
184     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
185       0x10000000000000000000000000000;
186 
187     if (exponent < 16367) result >>= 16367 - exponent;
188     else if (exponent > 16367) result <<= exponent - 16367;
189 
190     if (uint128 (x) >= 0x80000000000000000000000000000000) { // Negative
191       require (result <= 0x8000000000000000000000000000000000000000000000000000000000000000);
192       return -int256 (result); // We rely on overflow behavior here
193     } else {
194       require (result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
195       return int256 (result);
196     }
197   }
198 
199   function from64x64 (int128 x) internal pure returns (bytes16) {
200     if (x == 0) return bytes16 (0);
201     else {
202       // We rely on overflow behavior here
203       uint256 result = uint128 (x > 0 ? x : -x);
204 
205       uint256 msb = msb (result);
206       if (msb < 112) result <<= 112 - msb;
207       else if (msb > 112) result >>= msb - 112;
208 
209       result = result & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF | 16319 + msb << 112;
210       if (x < 0) result |= 0x80000000000000000000000000000000;
211 
212       return bytes16 (uint128 (result));
213     }
214   }
215 
216   function to64x64 (bytes16 x) internal pure returns (int128) {
217     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
218 
219     require (exponent <= 16446); // Overflow
220     if (exponent < 16319) return 0; // Underflow
221 
222     uint256 result = uint256 (uint128 (x)) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF |
223       0x10000000000000000000000000000;
224 
225     if (exponent < 16431) result >>= 16431 - exponent;
226     else if (exponent > 16431) result <<= exponent - 16431;
227 
228     if (uint128 (x) >= 0x80000000000000000000000000000000) { // Negative
229       require (result <= 0x80000000000000000000000000000000);
230       return -int128 (result); // We rely on overflow behavior here
231     } else {
232       require (result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
233       return int128 (result);
234     }
235   }
236 
237   function fromOctuple (bytes32 x) internal pure returns (bytes16) {
238     bool negative = x & 0x8000000000000000000000000000000000000000000000000000000000000000 > 0;
239 
240     uint256 exponent = uint256 (x) >> 236 & 0x7FFFF;
241     uint256 significand = uint256 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
242 
243     if (exponent == 0x7FFFF) {
244       if (significand > 0) return NaN;
245       else return negative ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
246     }
247 
248     if (exponent > 278526)
249       return negative ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
250     else if (exponent < 245649)
251       return negative ? NEGATIVE_ZERO : POSITIVE_ZERO;
252     else if (exponent < 245761) {
253       significand = (significand | 0x100000000000000000000000000000000000000000000000000000000000) >> 245885 - exponent;
254       exponent = 0;
255     } else {
256       significand >>= 124;
257       exponent -= 245760;
258     }
259 
260     uint128 result = uint128 (significand | exponent << 112);
261     if (negative) result |= 0x80000000000000000000000000000000;
262 
263     return bytes16 (result);
264   }
265 
266   function toOctuple (bytes16 x) internal pure returns (bytes32) {
267     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
268 
269     uint256 result = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
270 
271     if (exponent == 0x7FFF) exponent = 0x7FFFF; // Infinity or NaN
272     else if (exponent == 0) {
273       if (result > 0) {
274         uint256 msb = msb (result);
275         result = result << 236 - msb & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
276         exponent = 245649 + msb;
277       }
278     } else {
279       result <<= 124;
280       exponent += 245760;
281     }
282 
283     result |= exponent << 236;
284     if (uint128 (x) >= 0x80000000000000000000000000000000)
285       result |= 0x8000000000000000000000000000000000000000000000000000000000000000;
286 
287     return bytes32 (result);
288   }
289 
290   function fromDouble (bytes8 x) internal pure returns (bytes16) {
291     uint256 exponent = uint64 (x) >> 52 & 0x7FF;
292 
293     uint256 result = uint64 (x) & 0xFFFFFFFFFFFFF;
294 
295     if (exponent == 0x7FF) exponent = 0x7FFF; // Infinity or NaN
296     else if (exponent == 0) {
297       if (result > 0) {
298         uint256 msb = msb (result);
299         result = result << 112 - msb & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
300         exponent = 15309 + msb;
301       }
302     } else {
303       result <<= 60;
304       exponent += 15360;
305     }
306 
307     result |= exponent << 112;
308     if (x & 0x8000000000000000 > 0)
309       result |= 0x80000000000000000000000000000000;
310 
311     return bytes16 (uint128 (result));
312   }
313 
314   function toDouble (bytes16 x) internal pure returns (bytes8) {
315     bool negative = uint128 (x) >= 0x80000000000000000000000000000000;
316 
317     uint256 exponent = uint128 (x) >> 112 & 0x7FFF;
318     uint256 significand = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
319 
320     if (exponent == 0x7FFF) {
321       if (significand > 0) return 0x7FF8000000000000; // NaN
322       else return negative ?
323           bytes8 (0xFFF0000000000000) : // -Infinity
324           bytes8 (0x7FF0000000000000); // Infinity
325     }
326 
327     if (exponent > 17406)
328       return negative ?
329           bytes8 (0xFFF0000000000000) : // -Infinity
330           bytes8 (0x7FF0000000000000); // Infinity
331     else if (exponent < 15309)
332       return negative ?
333           bytes8 (0x8000000000000000) : // -0
334           bytes8 (0x0000000000000000); // 0
335     else if (exponent < 15361) {
336       significand = (significand | 0x10000000000000000000000000000) >> 15421 - exponent;
337       exponent = 0;
338     } else {
339       significand >>= 60;
340       exponent -= 15360;
341     }
342 
343     uint64 result = uint64 (significand | exponent << 52);
344     if (negative) result |= 0x8000000000000000;
345 
346     return bytes8 (result);
347   }
348 
349   function isNaN (bytes16 x) internal pure returns (bool) {
350     return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF >
351       0x7FFF0000000000000000000000000000;
352   }
353 
354   function isInfinity (bytes16 x) internal pure returns (bool) {
355     return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ==
356       0x7FFF0000000000000000000000000000;
357   }
358 
359   function sign (bytes16 x) internal pure returns (int8) {
360     uint128 absoluteX = uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
361 
362     require (absoluteX <= 0x7FFF0000000000000000000000000000); // Not NaN
363 
364     if (absoluteX == 0) return 0;
365     else if (uint128 (x) >= 0x80000000000000000000000000000000) return -1;
366     else return 1;
367   }
368 
369   function cmp (bytes16 x, bytes16 y) internal pure returns (int8) {
370     uint128 absoluteX = uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
371 
372     require (absoluteX <= 0x7FFF0000000000000000000000000000); 
373 
374     uint128 absoluteY = uint128 (y) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
375 
376     require (absoluteY <= 0x7FFF0000000000000000000000000000); 
377 
378     require (x != y || absoluteX < 0x7FFF0000000000000000000000000000);
379 
380     if (x == y) return 0;
381     else {
382       bool negativeX = uint128 (x) >= 0x80000000000000000000000000000000;
383       bool negativeY = uint128 (y) >= 0x80000000000000000000000000000000;
384 
385       if (negativeX) {
386         if (negativeY) return absoluteX > absoluteY ? -1 : int8 (1);
387         else return -1; 
388       } else {
389         if (negativeY) return 1;
390         else return absoluteX > absoluteY ? int8 (1) : -1;
391       }
392     }
393   }
394 
395   function eq (bytes16 x, bytes16 y) internal pure returns (bool) {
396     if (x == y) {
397       return uint128 (x) & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF <
398         0x7FFF0000000000000000000000000000;
399     } else return false;
400   }
401 
402   function add (bytes16 x, bytes16 y) internal pure returns (bytes16) {
403     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
404     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
405 
406     if (xExponent == 0x7FFF) {
407       if (yExponent == 0x7FFF) { 
408         if (x == y) return x;
409         else return NaN;
410       } else return x; 
411     } else if (yExponent == 0x7FFF) return y;
412     else {
413       bool xSign = uint128 (x) >= 0x80000000000000000000000000000000;
414       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
415       if (xExponent == 0) xExponent = 1;
416       else xSignifier |= 0x10000000000000000000000000000;
417 
418       bool ySign = uint128 (y) >= 0x80000000000000000000000000000000;
419       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
420       if (yExponent == 0) yExponent = 1;
421       else ySignifier |= 0x10000000000000000000000000000;
422 
423       if (xSignifier == 0) return y == NEGATIVE_ZERO ? POSITIVE_ZERO : y;
424       else if (ySignifier == 0) return x == NEGATIVE_ZERO ? POSITIVE_ZERO : x;
425       else {
426         int256 delta = int256 (xExponent) - int256 (yExponent);
427   
428         if (xSign == ySign) {
429           if (delta > 112) return x;
430           else if (delta > 0) ySignifier >>= delta;
431           else if (delta < -112) return y;
432           else if (delta < 0) {
433             xSignifier >>= -delta;
434             xExponent = yExponent;
435           }
436   
437           xSignifier += ySignifier;
438   
439           if (xSignifier >= 0x20000000000000000000000000000) {
440             xSignifier >>= 1;
441             xExponent += 1;
442           }
443   
444           if (xExponent == 0x7FFF)
445             return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
446           else {
447             if (xSignifier < 0x10000000000000000000000000000) xExponent = 0;
448             else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
449   
450             return bytes16 (uint128 (
451                 (xSign ? 0x80000000000000000000000000000000 : 0) |
452                 (xExponent << 112) |
453                 xSignifier)); 
454           }
455         } else {
456           if (delta > 0) {
457             xSignifier <<= 1;
458             xExponent -= 1;
459           } else if (delta < 0) {
460             ySignifier <<= 1;
461             xExponent = yExponent - 1;
462           }
463 
464           if (delta > 112) ySignifier = 1;
465           else if (delta > 1) ySignifier = (ySignifier - 1 >> delta - 1) + 1;
466           else if (delta < -112) xSignifier = 1;
467           else if (delta < -1) xSignifier = (xSignifier - 1 >> -delta - 1) + 1;
468 
469           if (xSignifier >= ySignifier) xSignifier -= ySignifier;
470           else {
471             xSignifier = ySignifier - xSignifier;
472             xSign = ySign;
473           }
474 
475           if (xSignifier == 0)
476             return POSITIVE_ZERO;
477 
478           uint256 msb = msb (xSignifier);
479 
480           if (msb == 113) {
481             xSignifier = xSignifier >> 1 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
482             xExponent += 1;
483           } else if (msb < 112) {
484             uint256 shift = 112 - msb;
485             if (xExponent > shift) {
486               xSignifier = xSignifier << shift & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
487               xExponent -= shift;
488             } else {
489               xSignifier <<= xExponent - 1;
490               xExponent = 0;
491             }
492           } else xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
493 
494           if (xExponent == 0x7FFF)
495             return xSign ? NEGATIVE_INFINITY : POSITIVE_INFINITY;
496           else return bytes16 (uint128 (
497               (xSign ? 0x80000000000000000000000000000000 : 0) |
498               (xExponent << 112) |
499               xSignifier));
500         }
501       }
502     }
503   }
504 
505   function sub (bytes16 x, bytes16 y) internal pure returns (bytes16) {
506     return add (x, y ^ 0x80000000000000000000000000000000);
507   }
508 
509   function mul (bytes16 x, bytes16 y) internal pure returns (bytes16) {
510     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
511     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
512 
513     if (xExponent == 0x7FFF) {
514       if (yExponent == 0x7FFF) {
515         if (x == y) return x ^ y & 0x80000000000000000000000000000000;
516         else if (x ^ y == 0x80000000000000000000000000000000) return x | y;
517         else return NaN;
518       } else {
519         if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
520         else return x ^ y & 0x80000000000000000000000000000000;
521       }
522     } else if (yExponent == 0x7FFF) {
523         if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
524         else return y ^ x & 0x80000000000000000000000000000000;
525     } else {
526       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
527       if (xExponent == 0) xExponent = 1;
528       else xSignifier |= 0x10000000000000000000000000000;
529 
530       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
531       if (yExponent == 0) yExponent = 1;
532       else ySignifier |= 0x10000000000000000000000000000;
533 
534       xSignifier *= ySignifier;
535       if (xSignifier == 0)
536         return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
537             NEGATIVE_ZERO : POSITIVE_ZERO;
538 
539       xExponent += yExponent;
540 
541       uint256 msb =
542         xSignifier >= 0x200000000000000000000000000000000000000000000000000000000 ? 225 :
543         xSignifier >= 0x100000000000000000000000000000000000000000000000000000000 ? 224 :
544         msb (xSignifier);
545 
546       if (xExponent + msb < 16496) { // Underflow
547         xExponent = 0;
548         xSignifier = 0;
549       } else if (xExponent + msb < 16608) { // Subnormal
550         if (xExponent < 16496)
551           xSignifier >>= 16496 - xExponent;
552         else if (xExponent > 16496)
553           xSignifier <<= xExponent - 16496;
554         xExponent = 0;
555       } else if (xExponent + msb > 49373) {
556         xExponent = 0x7FFF;
557         xSignifier = 0;
558       } else {
559         if (msb > 112)
560           xSignifier >>= msb - 112;
561         else if (msb < 112)
562           xSignifier <<= 112 - msb;
563 
564         xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
565 
566         xExponent = xExponent + msb - 16607;
567       }
568 
569       return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
570           xExponent << 112 | xSignifier));
571     }
572   }
573 
574   function div (bytes16 x, bytes16 y) internal pure returns (bytes16) {
575     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
576     uint256 yExponent = uint128 (y) >> 112 & 0x7FFF;
577 
578     if (xExponent == 0x7FFF) {
579       if (yExponent == 0x7FFF) return NaN;
580       else return x ^ y & 0x80000000000000000000000000000000;
581     } else if (yExponent == 0x7FFF) {
582       if (y & 0x0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF != 0) return NaN;
583       else return POSITIVE_ZERO | (x ^ y) & 0x80000000000000000000000000000000;
584     } else if (y & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) {
585       if (x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0) return NaN;
586       else return POSITIVE_INFINITY | (x ^ y) & 0x80000000000000000000000000000000;
587     } else {
588       uint256 ySignifier = uint128 (y) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
589       if (yExponent == 0) yExponent = 1;
590       else ySignifier |= 0x10000000000000000000000000000;
591 
592       uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
593       if (xExponent == 0) {
594         if (xSignifier != 0) {
595           uint shift = 226 - msb (xSignifier);
596 
597           xSignifier <<= shift;
598 
599           xExponent = 1;
600           yExponent += shift - 114;
601         }
602       }
603       else {
604         xSignifier = (xSignifier | 0x10000000000000000000000000000) << 114;
605       }
606 
607       xSignifier = xSignifier / ySignifier;
608       if (xSignifier == 0)
609         return (x ^ y) & 0x80000000000000000000000000000000 > 0 ?
610             NEGATIVE_ZERO : POSITIVE_ZERO;
611 
612       assert (xSignifier >= 0x1000000000000000000000000000);
613 
614       uint256 msb =
615         xSignifier >= 0x80000000000000000000000000000 ? msb (xSignifier) :
616         xSignifier >= 0x40000000000000000000000000000 ? 114 :
617         xSignifier >= 0x20000000000000000000000000000 ? 113 : 112;
618 
619       if (xExponent + msb > yExponent + 16497) { // Overflow
620         xExponent = 0x7FFF;
621         xSignifier = 0;
622       } else if (xExponent + msb + 16380  < yExponent) { // Underflow
623         xExponent = 0;
624         xSignifier = 0;
625       } else if (xExponent + msb + 16268  < yExponent) { // Subnormal
626         if (xExponent + 16380 > yExponent)
627           xSignifier <<= xExponent + 16380 - yExponent;
628         else if (xExponent + 16380 < yExponent)
629           xSignifier >>= yExponent - xExponent - 16380;
630 
631         xExponent = 0;
632       } else { // Normal
633         if (msb > 112)
634           xSignifier >>= msb - 112;
635 
636         xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
637 
638         xExponent = xExponent + msb + 16269 - yExponent;
639       }
640 
641       return bytes16 (uint128 (uint128 ((x ^ y) & 0x80000000000000000000000000000000) |
642           xExponent << 112 | xSignifier));
643     }
644   }
645 
646   function neg (bytes16 x) internal pure returns (bytes16) {
647     return x ^ 0x80000000000000000000000000000000;
648   }
649 
650   function abs (bytes16 x) internal pure returns (bytes16) {
651     return x & 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
652   }
653 
654   function sqrt (bytes16 x) internal pure returns (bytes16) {
655     if (uint128 (x) >  0x80000000000000000000000000000000) return NaN;
656     else {
657       uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
658       if (xExponent == 0x7FFF) return x;
659       else {
660         uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
661         if (xExponent == 0) xExponent = 1;
662         else xSignifier |= 0x10000000000000000000000000000;
663 
664         if (xSignifier == 0) return POSITIVE_ZERO;
665 
666         bool oddExponent = xExponent & 0x1 == 0;
667         xExponent = xExponent + 16383 >> 1;
668 
669         if (oddExponent) {
670           if (xSignifier >= 0x10000000000000000000000000000)
671             xSignifier <<= 113;
672           else {
673             uint256 msb = msb (xSignifier);
674             uint256 shift = (226 - msb) & 0xFE;
675             xSignifier <<= shift;
676             xExponent -= shift - 112 >> 1;
677           }
678         } else {
679           if (xSignifier >= 0x10000000000000000000000000000)
680             xSignifier <<= 112;
681           else {
682             uint256 msb = msb (xSignifier);
683             uint256 shift = (225 - msb) & 0xFE;
684             xSignifier <<= shift;
685             xExponent -= shift - 112 >> 1;
686           }
687         }
688 
689         uint256 r = 0x10000000000000000000000000000;
690         while (true) {
691           uint256 rr = xSignifier / r;
692           if (r == rr || r + 1 == rr) break;
693           else if (r == rr + 1) {
694             r = rr;
695             break;
696           }
697           r = r + rr + 1 >> 1;
698         }
699 
700         return bytes16 (uint128 (xExponent << 112 | r & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
701       }
702     }
703   }
704 
705   function log_2 (bytes16 x) internal pure returns (bytes16) {
706     if (uint128 (x) > 0x80000000000000000000000000000000) return NaN;
707     else if (x == 0x3FFF0000000000000000000000000000) return POSITIVE_ZERO; 
708     else {
709       uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
710       if (xExponent == 0x7FFF) return x;
711       else {
712         uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
713         if (xExponent == 0) xExponent = 1;
714         else xSignifier |= 0x10000000000000000000000000000;
715 
716         if (xSignifier == 0) return NEGATIVE_INFINITY;
717 
718         bool resultNegative;
719         uint256 resultExponent = 16495;
720         uint256 resultSignifier;
721 
722         if (xExponent >= 0x3FFF) {
723           resultNegative = false;
724           resultSignifier = xExponent - 0x3FFF;
725           xSignifier <<= 15;
726         } else {
727           resultNegative = true;
728           if (xSignifier >= 0x10000000000000000000000000000) {
729             resultSignifier = 0x3FFE - xExponent;
730             xSignifier <<= 15;
731           } else {
732             uint256 msb = msb (xSignifier);
733             resultSignifier = 16493 - msb;
734             xSignifier <<= 127 - msb;
735           }
736         }
737 
738         if (xSignifier == 0x80000000000000000000000000000000) {
739           if (resultNegative) resultSignifier += 1;
740           uint256 shift = 112 - msb (resultSignifier);
741           resultSignifier <<= shift;
742           resultExponent -= shift;
743         } else {
744           uint256 bb = resultNegative ? 1 : 0;
745           while (resultSignifier < 0x10000000000000000000000000000) {
746             resultSignifier <<= 1;
747             resultExponent -= 1;
748   
749             xSignifier *= xSignifier;
750             uint256 b = xSignifier >> 255;
751             resultSignifier += b ^ bb;
752             xSignifier >>= 127 + b;
753           }
754         }
755 
756         return bytes16 (uint128 ((resultNegative ? 0x80000000000000000000000000000000 : 0) |
757             resultExponent << 112 | resultSignifier & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF));
758       }
759     }
760   }
761 
762   function ln (bytes16 x) internal pure returns (bytes16) {
763     return mul (log_2 (x), 0x3FFE62E42FEFA39EF35793C7673007E5);
764   }
765 
766   function pow_2 (bytes16 x) internal pure returns (bytes16) {
767     bool xNegative = uint128 (x) > 0x80000000000000000000000000000000;
768     uint256 xExponent = uint128 (x) >> 112 & 0x7FFF;
769     uint256 xSignifier = uint128 (x) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
770 
771     if (xExponent == 0x7FFF && xSignifier != 0) return NaN;
772     else if (xExponent > 16397)
773       return xNegative ? POSITIVE_ZERO : POSITIVE_INFINITY;
774     else if (xExponent < 16255)
775       return 0x3FFF0000000000000000000000000000;
776     else {
777       if (xExponent == 0) xExponent = 1;
778       else xSignifier |= 0x10000000000000000000000000000;
779 
780       if (xExponent > 16367)
781         xSignifier <<= xExponent - 16367;
782       else if (xExponent < 16367)
783         xSignifier >>= 16367 - xExponent;
784 
785       if (xNegative && xSignifier > 0x406E00000000000000000000000000000000)
786         return POSITIVE_ZERO;
787 
788       if (!xNegative && xSignifier > 0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
789         return POSITIVE_INFINITY;
790 
791       uint256 resultExponent = xSignifier >> 128;
792       xSignifier &= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
793       if (xNegative && xSignifier != 0) {
794         xSignifier = ~xSignifier;
795         resultExponent += 1;
796       }
797 
798       uint256 resultSignifier = 0x80000000000000000000000000000000;
799       if (xSignifier & 0x80000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
800       if (xSignifier & 0x40000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
801       if (xSignifier & 0x20000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
802       if (xSignifier & 0x10000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
803       if (xSignifier & 0x8000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
804       if (xSignifier & 0x4000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
805       if (xSignifier & 0x2000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
806       if (xSignifier & 0x1000000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
807       if (xSignifier & 0x800000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
808       if (xSignifier & 0x400000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
809       if (xSignifier & 0x200000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
810       if (xSignifier & 0x100000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
811       if (xSignifier & 0x80000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
812       if (xSignifier & 0x40000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
813       if (xSignifier & 0x20000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000162E525EE054754457D5995292026 >> 128;
814       if (xSignifier & 0x10000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
815       if (xSignifier & 0x8000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
816       if (xSignifier & 0x4000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
817       if (xSignifier & 0x2000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000162E43F4F831060E02D839A9D16D >> 128;
818       if (xSignifier & 0x1000000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
819       if (xSignifier & 0x800000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
820       if (xSignifier & 0x400000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
821       if (xSignifier & 0x200000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
822       if (xSignifier & 0x100000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
823       if (xSignifier & 0x80000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
824       if (xSignifier & 0x40000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
825       if (xSignifier & 0x20000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
826       if (xSignifier & 0x10000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
827       if (xSignifier & 0x8000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
828       if (xSignifier & 0x4000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
829       if (xSignifier & 0x2000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
830       if (xSignifier & 0x1000000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
831       if (xSignifier & 0x800000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
832       if (xSignifier & 0x400000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
833       if (xSignifier & 0x200000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000162E42FEFB2FED257559BDAA >> 128;
834       if (xSignifier & 0x100000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
835       if (xSignifier & 0x80000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
836       if (xSignifier & 0x40000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
837       if (xSignifier & 0x20000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
838       if (xSignifier & 0x10000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000B17217F7D20CF927C8E94C >> 128;
839       if (xSignifier & 0x8000000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
840       if (xSignifier & 0x4000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000002C5C85FDF477B662B26945 >> 128;
841       if (xSignifier & 0x2000000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000162E42FEFA3AE53369388C >> 128;
842       if (xSignifier & 0x1000000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000B17217F7D1D351A389D40 >> 128;
843       if (xSignifier & 0x800000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
844       if (xSignifier & 0x400000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
845       if (xSignifier & 0x200000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000162E42FEFA39FE95583C2 >> 128;
846       if (xSignifier & 0x100000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
847       if (xSignifier & 0x80000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
848       if (xSignifier & 0x40000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000002C5C85FDF473E242EA38 >> 128;
849       if (xSignifier & 0x20000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000162E42FEFA39F02B772C >> 128;
850       if (xSignifier & 0x10000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
851       if (xSignifier & 0x8000000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
852       if (xSignifier & 0x4000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000002C5C85FDF473DEA871F >> 128;
853       if (xSignifier & 0x2000000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000162E42FEFA39EF44D91 >> 128;
854       if (xSignifier & 0x1000000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000B17217F7D1CF79E949 >> 128;
855       if (xSignifier & 0x800000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
856       if (xSignifier & 0x400000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
857       if (xSignifier & 0x200000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000162E42FEFA39EF366F >> 128;
858       if (xSignifier & 0x100000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000B17217F7D1CF79AFA >> 128;
859       if (xSignifier & 0x80000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
860       if (xSignifier & 0x40000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
861       if (xSignifier & 0x20000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000162E42FEFA39EF358 >> 128;
862       if (xSignifier & 0x10000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000B17217F7D1CF79AB >> 128;
863       if (xSignifier & 0x8000000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000058B90BFBE8E7BCD5 >> 128;
864       if (xSignifier & 0x4000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000002C5C85FDF473DE6A >> 128;
865       if (xSignifier & 0x2000000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000162E42FEFA39EF34 >> 128;
866       if (xSignifier & 0x1000000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000B17217F7D1CF799 >> 128;
867       if (xSignifier & 0x800000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000058B90BFBE8E7BCC >> 128;
868       if (xSignifier & 0x400000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000002C5C85FDF473DE5 >> 128;
869       if (xSignifier & 0x200000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000162E42FEFA39EF2 >> 128;
870       if (xSignifier & 0x100000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000B17217F7D1CF78 >> 128;
871       if (xSignifier & 0x80000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000058B90BFBE8E7BB >> 128;
872       if (xSignifier & 0x40000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000002C5C85FDF473DD >> 128;
873       if (xSignifier & 0x20000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000162E42FEFA39EE >> 128;
874       if (xSignifier & 0x10000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000B17217F7D1CF6 >> 128;
875       if (xSignifier & 0x8000000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000058B90BFBE8E7A >> 128;
876       if (xSignifier & 0x4000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000002C5C85FDF473C >> 128;
877       if (xSignifier & 0x2000000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000162E42FEFA39D >> 128;
878       if (xSignifier & 0x1000000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000B17217F7D1CE >> 128;
879       if (xSignifier & 0x800000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000058B90BFBE8E6 >> 128;
880       if (xSignifier & 0x400000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000002C5C85FDF472 >> 128;
881       if (xSignifier & 0x200000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000162E42FEFA38 >> 128;
882       if (xSignifier & 0x100000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000B17217F7D1B >> 128;
883       if (xSignifier & 0x80000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000058B90BFBE8D >> 128;
884       if (xSignifier & 0x40000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000002C5C85FDF46 >> 128;
885       if (xSignifier & 0x20000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000162E42FEFA2 >> 128;
886       if (xSignifier & 0x10000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000B17217F7D0 >> 128;
887       if (xSignifier & 0x8000000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000058B90BFBE7 >> 128;
888       if (xSignifier & 0x4000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000002C5C85FDF3 >> 128;
889       if (xSignifier & 0x2000000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000162E42FEF9 >> 128;
890       if (xSignifier & 0x1000000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000B17217F7C >> 128;
891       if (xSignifier & 0x800000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000058B90BFBD >> 128;
892       if (xSignifier & 0x400000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000002C5C85FDE >> 128;
893       if (xSignifier & 0x200000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000162E42FEE >> 128;
894       if (xSignifier & 0x100000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000B17217F6 >> 128;
895       if (xSignifier & 0x80000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000058B90BFA >> 128;
896       if (xSignifier & 0x40000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000002C5C85FC >> 128;
897       if (xSignifier & 0x20000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000162E42FD >> 128;
898       if (xSignifier & 0x10000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000B17217E >> 128;
899       if (xSignifier & 0x8000000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000058B90BE >> 128;
900       if (xSignifier & 0x4000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000002C5C85E >> 128;
901       if (xSignifier & 0x2000000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000162E42E >> 128;
902       if (xSignifier & 0x1000000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000B17216 >> 128;
903       if (xSignifier & 0x800000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000058B90A >> 128;
904       if (xSignifier & 0x400000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000002C5C84 >> 128;
905       if (xSignifier & 0x200000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000162E41 >> 128;
906       if (xSignifier & 0x100000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000B1720 >> 128;
907       if (xSignifier & 0x80000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000058B8F >> 128;
908       if (xSignifier & 0x40000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000002C5C7 >> 128;
909       if (xSignifier & 0x20000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000162E3 >> 128;
910       if (xSignifier & 0x10000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000B171 >> 128;
911       if (xSignifier & 0x8000 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000058B8 >> 128;
912       if (xSignifier & 0x4000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000002C5B >> 128;
913       if (xSignifier & 0x2000 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000162D >> 128;
914       if (xSignifier & 0x1000 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000B16 >> 128;
915       if (xSignifier & 0x800 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000058A >> 128;
916       if (xSignifier & 0x400 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000002C4 >> 128;
917       if (xSignifier & 0x200 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000161 >> 128;
918       if (xSignifier & 0x100 > 0) resultSignifier = resultSignifier * 0x1000000000000000000000000000000B0 >> 128;
919       if (xSignifier & 0x80 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000057 >> 128;
920       if (xSignifier & 0x40 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000002B >> 128;
921       if (xSignifier & 0x20 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000015 >> 128;
922       if (xSignifier & 0x10 > 0) resultSignifier = resultSignifier * 0x10000000000000000000000000000000A >> 128;
923       if (xSignifier & 0x8 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000004 >> 128;
924       if (xSignifier & 0x4 > 0) resultSignifier = resultSignifier * 0x100000000000000000000000000000001 >> 128;
925 
926       if (!xNegative) {
927         resultSignifier = resultSignifier >> 15 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
928         resultExponent += 0x3FFF;
929       } else if (resultExponent <= 0x3FFE) {
930         resultSignifier = resultSignifier >> 15 & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
931         resultExponent = 0x3FFF - resultExponent;
932       } else {
933         resultSignifier = resultSignifier >> resultExponent - 16367;
934         resultExponent = 0;
935       }
936 
937       return bytes16 (uint128 (resultExponent << 112 | resultSignifier));
938     }
939   }
940 
941   function exp (bytes16 x) internal pure returns (bytes16) {
942     return pow_2 (mul (x, 0x3FFF71547652B82FE1777D0FFDA0D23A));
943   }
944 
945   function msb (uint256 x) private pure returns (uint256) {
946     require (x > 0);
947 
948     uint256 result = 0;
949 
950     if (x >= 0x100000000000000000000000000000000) { x >>= 128; result += 128; }
951     if (x >= 0x10000000000000000) { x >>= 64; result += 64; }
952     if (x >= 0x100000000) { x >>= 32; result += 32; }
953     if (x >= 0x10000) { x >>= 16; result += 16; }
954     if (x >= 0x100) { x >>= 8; result += 8; }
955     if (x >= 0x10) { x >>= 4; result += 4; }
956     if (x >= 0x4) { x >>= 2; result += 2; }
957     if (x >= 0x2) result += 1; // No need to shift x anymore
958 
959     return result;
960   }
961 }
962 
963 contract ERC20 is Context, IERC20 {
964     using SafeMath for uint256;
965 
966     mapping (address => uint256) private _balances;
967 
968     mapping (address => mapping (address => uint256)) private _allowances;
969 
970     uint256 private _totalSupply; 
971 
972     constructor() public {
973         _balances[msg.sender] = _totalSupply;
974     }
975  
976     function totalSupply() external view returns (uint256) {
977         return _totalSupply;
978     }
979 
980     function balanceOf(address account) external view returns (uint256) {
981         return _balances[account];
982     }
983 
984     function transfer(address recipient, uint256 amount) external returns (bool) {
985         _transfer(_msgSender(), recipient, amount);
986         return true;
987     }
988 
989     function allowance(address owner, address spender) external view returns (uint256) {
990         return _allowances[owner][spender];
991     }
992 
993     function approve(address spender, uint256 amount) external returns (bool) {
994         _approve(_msgSender(), spender, amount);
995         return true;
996     }
997 
998     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
999         _transfer(sender, recipient, amount);
1000         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1001         return true;
1002     }
1003 
1004     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1005         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1006         return true;
1007     }
1008 
1009     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1010         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1011         return true;
1012     }
1013 
1014     function _transfer(address sender, address recipient, uint256 amount) internal {
1015         require(sender != address(0), "ERC20: transfer from the zero address");
1016         require(recipient != address(0), "ERC20: transfer to the zero address");
1017 
1018         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1019         _balances[recipient] = _balances[recipient].add(amount);
1020         emit Transfer(sender, recipient, amount);
1021     }
1022 
1023     function _mint(address account, uint256 amount) internal {
1024         require(account != address(0), "ERC20: mint to the zero address");
1025 
1026         _totalSupply = _totalSupply.add(amount);
1027         _balances[account] = _balances[account].add(amount);
1028         emit Transfer(address(0), account, amount);
1029     }
1030 
1031     function _burn(address account, uint256 amount) internal {
1032         require(account != address(0), "ERC20: burn from the zero address");
1033 
1034         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1035         _totalSupply = _totalSupply.sub(amount);
1036         emit Transfer(account, address(0), amount);
1037     }
1038 
1039     function _approve(address owner, address spender, uint256 amount) internal {
1040         require(owner != address(0), "ERC20: approve from the zero address");
1041         require(spender != address(0), "ERC20: approve to the zero address");
1042 
1043         _allowances[owner][spender] = amount;
1044         emit Approval(owner, spender, amount);
1045     }
1046 
1047     function _burnFrom(address account, uint256 amount) internal {
1048         _burn(account, amount);
1049         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1050     }
1051 }
1052 
1053 contract Ownable {
1054    address internal admin;
1055    address internal owner;
1056 
1057   constructor() internal {
1058     owner = msg.sender;
1059     admin = msg.sender;
1060   }
1061 
1062   modifier onlyOwner() {
1063     require(msg.sender == owner, "Ownable: msg.sender not owner");
1064     _;
1065   }
1066 
1067   function transferOwnership(address newOwner) external onlyOwner {
1068     require(newOwner != address(0), "Ownable: owner is zero address");      
1069     owner = newOwner;
1070   }
1071 
1072   function transferAdmin(address newAdmin) external onlyOwner {
1073     require(newAdmin != address(0), "Ownable: admin is zero address");      
1074     admin = newAdmin;
1075   }
1076 
1077   
1078 
1079  
1080 }
1081 
1082 
1083 contract PositiveToken is ERC20,Ownable  {
1084   /* ERC20 constants */
1085   string internal _name; 
1086   string internal _symbol;
1087   uint8 internal _decimals;
1088 
1089   bytes16 internal _price;
1090   uint256 private _bank = 0; 
1091   uint256 private _tokens;
1092 
1093   bytes16 internal PRICE_DECIMALS; 
1094 
1095   uint256 internal _C; 
1096   uint256 internal _Cr; 
1097   uint256 internal _Ca; 
1098   uint256 internal _Cg;
1099 
1100   uint256 internal _buyFee;
1101   uint256 internal _sellFee;
1102 
1103 
1104 uint256 internal _adminCommission;
1105   uint256 internal _refCommission;
1106 
1107 uint256 internal _adminSellCommisionBalance;
1108   bool private Initialize = false; 
1109   bool private isPresaleFinished = false; 
1110 
1111   mapping (address=>address) private registred;
1112   mapping (address=>address) private reff;
1113   uint256 private _userInContract;
1114 
1115   event Price(uint256 totalSupply,uint256 value);
1116   event Diff(uint256 diff);
1117 
1118   function name() external view returns(string memory){
1119     return _name;
1120   }
1121   function symbol() external view returns(string memory){
1122     return _symbol;
1123   }
1124   function decimals() external view returns(uint8){
1125     return _decimals;
1126   }
1127 
1128   function bank() external view returns(uint256){
1129     return _bank;
1130   }
1131 
1132   function price() external view returns(uint256) {
1133     bytes16 uint_price = ABDKMathQuad.mul(_price,PRICE_DECIMALS); // float price * 10**18
1134     return(ABDKMathQuad.toUInt(uint_price)); // return uint price 
1135   }
1136 
1137   function getCommission() external view returns (uint256, uint256, uint256, uint256){
1138     return(_C,_Cr,_Ca,_Cg);
1139   }
1140 
1141   function getCommissionTotal() external view returns(uint256){
1142     return _C;
1143   }
1144 
1145   function getCommissionRef() external view returns(uint256){
1146     return _Cr;
1147   }
1148 
1149   function getCommissionAdmin() external view returns(uint256){
1150     return _Ca;
1151   }
1152 
1153   function getCommissionCost() external view returns(uint256){
1154     return _Cg;
1155   }
1156 
1157 
1158     function getBuyFee() external view returns(uint256){
1159     return _buyFee;
1160   }
1161 
1162   function getSellFee() external view returns(uint256){
1163     return _sellFee;
1164   }
1165 
1166 
1167 
1168 
1169 
1170     function getAdminCommission() external view returns(uint256){
1171     return _adminCommission;
1172   }
1173 
1174   function getRefCommission() external view returns(uint256){
1175     return _refCommission;
1176   }
1177 
1178 
1179 
1180 
1181   function setSellFee(uint256 _fee) external onlyOwner {
1182       _sellFee = _fee;
1183   }
1184 
1185 
1186 
1187   function setBuyFee(uint256 _fee) external onlyOwner {
1188       _buyFee = _fee;
1189   }
1190 
1191 
1192 
1193  function withdrawAdminSellCommissionBalance() external onlyOwner payable{
1194         msg.sender.transfer(_adminSellCommisionBalance);
1195   }
1196 
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205   function isRegisterd(address addr) external view returns(bool) {
1206     if(registred[addr] == address(0)) {
1207       return false;
1208     }
1209     return true;
1210   }    
1211 
1212   function isInitialize() external view returns(bool){
1213     return Initialize;
1214   }
1215 
1216   function getRef(address addr) external view returns(address) {
1217     return reff[addr];
1218   }
1219 
1220   function getUserInContract() external view returns(uint256) {
1221     return _userInContract;
1222   }
1223 
1224   function init() external payable onlyOwner returns(bool) {
1225     require(Initialize == false, "Baln: Initialize is true");
1226     require(msg.value > 10**15, "Baln: eth value < 10^15 Wei"); // init price 0.001 Eth = 10**15 Wei
1227     bytes16 _adm_add_tmp = ABDKMathQuad.div( ABDKMathQuad.fromUInt(msg.value), _price);
1228     uint256 _adm_add = ABDKMathQuad.toUInt(_adm_add_tmp);
1229     _mint(msg.sender, _adm_add);
1230     _tokens = _tokens.add(_adm_add);
1231 
1232     _bank = _bank.add(msg.value);
1233 
1234     _price = ABDKMathQuad.div( ABDKMathQuad.fromUInt(_bank),ABDKMathQuad.fromUInt(_tokens));
1235     bytes16 uint_price = ABDKMathQuad.mul(_price,PRICE_DECIMALS); // float price * 10**18
1236 
1237     emit Price(_tokens,ABDKMathQuad.toUInt(uint_price));
1238 
1239     Initialize = true;
1240     registred[address(0)] = admin;
1241     registred[msg.sender] = admin;
1242     reff[msg.sender] = admin;
1243     return Initialize;
1244   }
1245 
1246 
1247 
1248 
1249 
1250 
1251   function allocatePresaleTokens(address newOwner) external onlyOwner {
1252      require(Initialize == true, "BALN: Initialize is true");
1253         require(isPresaleFinished == false, "BALN: Presale has finished");
1254        
1255         uint256 _adm_add =10000*10**18;
1256         
1257         _mint(msg.sender, _adm_add);
1258         _tokens = _tokens.add(_adm_add);
1259      
1260         isPresaleFinished = true;
1261       
1262   }
1263 
1264 
1265 
1266   function buytoken(address _refferer) external payable {
1267     require(Initialize == true, "Baln: Initialize is false");
1268     require(_refferer != msg.sender, "Baln: self-refferer");
1269     require(msg.value > 14**14, "Baln: eth value < 10^15 Wei"); // init price 0.0014
1270         
1271     _refferer = registred[_refferer];
1272       // by default 0
1273     if(_refferer == address(0)) {
1274       _refferer = admin;
1275     }
1276 
1277     
1278     uint256 _100_precent = 100;
1279 
1280     uint256 _part_virtual = _100_precent.sub(_Cg);
1281     uint256 _part_us = _100_precent.add(_Ca).add(_Cr);
1282 
1283     bytes16 _pre_virtual_tokens = ABDKMathQuad.div( ABDKMathQuad.fromUInt(msg.value), _price);
1284     uint256 _pre_virtual_tokens_int = ABDKMathQuad.toUInt(_pre_virtual_tokens);
1285     
1286     uint256 _feeOnTokens = _pre_virtual_tokens_int.mul(_buyFee).div(100);
1287 
1288     uint256 _buyersTokens = _pre_virtual_tokens_int.sub(_feeOnTokens);
1289 
1290     uint256 _adminTokens = _feeOnTokens.mul(_adminCommission).div(100);
1291     uint256 _refTokens = _feeOnTokens.mul(_refCommission).div(100);
1292 
1293 
1294     //Buyers codes
1295     _mint(msg.sender,_buyersTokens);
1296     _tokens = _tokens.add(_buyersTokens);
1297 
1298     _mint(_refferer,_refTokens);
1299     _tokens = _tokens.add(_refTokens);
1300 
1301     _mint(admin,_adminTokens);
1302     _tokens = _tokens.add(_adminTokens);
1303 
1304     _bank = _bank.add(msg.value);
1305 
1306     _price = ABDKMathQuad.div( ABDKMathQuad.fromUInt(_bank),ABDKMathQuad.fromUInt(_tokens));
1307     bytes16 uint_price = ABDKMathQuad.mul(_price,PRICE_DECIMALS); 
1308 
1309     emit Price(_tokens,ABDKMathQuad.toUInt(uint_price));
1310 
1311     if(registred[msg.sender] == address(0)) {
1312       registred[msg.sender] = msg.sender;
1313       _userInContract = _userInContract.add(1);
1314     }
1315     reff[msg.sender] = _refferer;
1316   }
1317 
1318   function sell(uint256 selltokens) external payable{
1319     require(Initialize == true, "Baln: Initialize is false");
1320     require(selltokens > 0, "Baln: sell tokens is zero");
1321     require(selltokens < 100*10**18, "Baln: sell tokens is more than 100");
1322 
1323     _burn(msg.sender, selltokens);
1324 
1325     uint256 _100_precent = 100;
1326 
1327     bytes16 _worth_mul_us = ABDKMathQuad.div( ABDKMathQuad.fromUInt(_100_precent),
1328     ABDKMathQuad.fromUInt(100) ); 
1329 
1330     bytes16 _worth_sub_tmp = ABDKMathQuad.mul(_worth_mul_us,ABDKMathQuad.fromUInt(selltokens));
1331     bytes16 _worth_sub = ABDKMathQuad.mul(_worth_sub_tmp,_price);
1332     uint256 _worth =  ABDKMathQuad.toUInt(_worth_sub);
1333 
1334 
1335     uint256 _feeOnTokens = _worth.mul(_sellFee).div(100);
1336     uint256 sellerBalance =  _worth.sub(_feeOnTokens);
1337     uint256 _adminCommissionOnSale =  _feeOnTokens.mul(_adminCommission).div(100);
1338 
1339 
1340 
1341 
1342 
1343 
1344     uint256 _withdraw = sellerBalance.add(_adminCommissionOnSale);
1345 
1346     _adminSellCommisionBalance = _adminSellCommisionBalance.add(_adminCommissionOnSale); 
1347 
1348     
1349     _bank = _bank.sub(_withdraw);
1350     _tokens = _tokens.sub(selltokens);
1351 
1352     _price = ABDKMathQuad.div( ABDKMathQuad.fromUInt(_bank),ABDKMathQuad.fromUInt(_tokens));
1353     bytes16 uint_price = ABDKMathQuad.mul(_price,PRICE_DECIMALS); // float price * 10**18  
1354 
1355     emit Price(_tokens,ABDKMathQuad.toUInt(uint_price));
1356 
1357     msg.sender.transfer(sellerBalance);
1358   }
1359 
1360 }
1361 
1362 contract Baln is PositiveToken {
1363   constructor()
1364     public {
1365       _name = "Baln Token";
1366       _symbol = "Baln";
1367       _decimals = 18;
1368       _price = ABDKMathQuad.div ( ABDKMathQuad.fromUInt(14), ABDKMathQuad.fromUInt(10000) ); // 0.001
1369       _C  = 20; 
1370       _Cr = 5; 
1371       _Ca = 5; 
1372       _Cg = _C.sub(_Cr.add(_Ca));
1373       _Cg = _Cg.div(2);
1374        _adminCommission = 20; // commission on fee
1375        _refCommission=20;// commission on fee
1376       _buyFee=5;
1377       _sellFee=5;
1378 
1379       uint256 t = 10**18;
1380       PRICE_DECIMALS = ABDKMathQuad.fromUInt(t);
1381   }
1382 
1383   function() external payable {}
1384 }