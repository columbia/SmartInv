1 /*
2  * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.16;
6 
7 /**
8  * ERC-20 standard token interface, as defined
9  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
10  */
11 contract Token {
12     /**
13      * Get total number of tokens in circulation.
14      *
15      * @return total number of tokens in circulation
16      */
17     function totalSupply () constant returns (uint256 supply);
18 
19     /**
20      * Get number of tokens currently belonging to given owner.
21      *
22      * @param _owner address to get number of tokens currently belonging to the
23      *        owner of
24      * @return number of tokens currently belonging to the owner of given address
25      */
26     function balanceOf (address _owner) constant returns (uint256 balance);
27 
28     /**
29      * Transfer given number of tokens from message sender to given recipient.
30      *
31      * @param _to address to transfer tokens to the owner of
32      * @param _value number of tokens to transfer to the owner of given address
33      * @return true if tokens were transferred successfully, false otherwise
34      */
35     function transfer (address _to, uint256 _value) returns (bool success);
36 
37     /**
38      * Transfer given number of tokens from given owner to given recipient.
39      *
40      * @param _from address to transfer tokens from the owner of
41      * @param _to address to transfer tokens to the owner of
42      * @param _value number of tokens to transfer from given owner to given
43      *        recipient
44      * @return true if tokens were transferred successfully, false otherwise
45      */
46     function transferFrom (address _from, address _to, uint256 _value)
47     returns (bool success);
48 
49     /**
50      * Allow given spender to transfer given number of tokens from message sender.
51      *
52      * @param _spender address to allow the owner of to transfer tokens from
53      *        message sender
54      * @param _value number of tokens to allow to transfer
55      * @return true if token transfer was successfully approved, false otherwise
56      */
57     function approve (address _spender, uint256 _value) returns (bool success);
58 
59     /**
60      * Tell how many tokens given spender is currently allowed to transfer from
61      * given owner.
62      *
63      * @param _owner address to get number of tokens allowed to be transferred
64      *        from the owner of
65      * @param _spender address to get number of tokens allowed to be transferred
66      *        by the owner of
67      * @return number of tokens given spender is currently allowed to transfer
68      *         from given owner
69      */
70     function allowance (address _owner, address _spender) constant
71     returns (uint256 remaining);
72 
73     /**
74      * Logged when tokens were transferred from one owner to another.
75      *
76      * @param _from address of the owner, tokens were transferred from
77      * @param _to address of the owner, tokens were transferred to
78      * @param _value number of tokens transferred
79      */
80     event Transfer (address indexed _from, address indexed _to, uint256 _value);
81 
82     /**
83      * Logged when owner approved his tokens to be transferred by some spender.
84      *
85      * @param _owner owner who approved his tokens to be transferred
86      * @param _spender spender who were allowed to transfer the tokens belonging
87      *        to the owner
88      * @param _value number of tokens belonging to the owner, approved to be
89      *        transferred by the spender
90      */
91     event Approval (
92         address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 /**
96  * Provides methods to safely add, subtract and multiply uint256 numbers.
97  */
98 contract SafeMath {
99     uint256 constant private MAX_UINT256 =
100     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
101 
102     /**
103      * Add two uint256 values, throw in case of overflow.
104      *
105      * @param x first value to add
106      * @param y second value to add
107      * @return x + y
108      */
109     function safeAdd (uint256 x, uint256 y)
110     constant internal
111     returns (uint256 z) {
112         assert (x <= MAX_UINT256 - y);
113         return x + y;
114     }
115 
116     /**
117      * Subtract one uint256 value from another, throw in case of underflow.
118      *
119      * @param x value to subtract from
120      * @param y value to subtract
121      * @return x - y
122      */
123     function safeSub (uint256 x, uint256 y)
124     constant internal
125     returns (uint256 z) {
126         assert (x >= y);
127         return x - y;
128     }
129 
130     /**
131      * Multiply two uint256 values, throw in case of overflow.
132      *
133      * @param x first value to multiply
134      * @param y second value to multiply
135      * @return x * y
136      */
137     function safeMul (uint256 x, uint256 y)
138     constant internal
139     returns (uint256 z) {
140         if (y == 0) return 0; // Prevent division by zero at the next line
141         assert (x <= MAX_UINT256 / y);
142         return x * y;
143     }
144 }
145 
146 /**
147  * Math Utilities smart contract.
148  */
149 contract Math is SafeMath {
150     /**
151      * 2^127.
152      */
153     uint128 internal constant TWO127 = 0x80000000000000000000000000000000;
154 
155     /**
156      * 2^128 - 1.
157      */
158     uint128 internal constant TWO128_1 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
159 
160     /**
161      * 2^128.
162      */
163     uint256 internal constant TWO128 = 0x100000000000000000000000000000000;
164 
165     /**
166      * 2^256 - 1.
167      */
168     uint256 internal constant TWO256_1 =
169     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
170 
171     /**
172      * 2^255.
173      */
174     uint256 internal constant TWO255 =
175     0x8000000000000000000000000000000000000000000000000000000000000000;
176 
177     /**
178      * -2^255.
179      */
180     int256 internal constant MINUS_TWO255 =
181     -0x8000000000000000000000000000000000000000000000000000000000000000;
182 
183     /**
184      * 2^255 - 1.
185      */
186     int256 internal constant TWO255_1 =
187     0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
188 
189     /**
190      * ln(2) * 2^128.
191      */
192     uint128 internal constant LN2 = 0xb17217f7d1cf79abc9e3b39803f2f6af;
193 
194     /**
195      * Return index of most significant non-zero bit in given non-zero 256-bit
196      * unsigned integer value.
197      *
198      * @param x value to get index of most significant non-zero bit in
199      * @return index of most significant non-zero bit in given number
200      */
201     function mostSignificantBit (uint256 x) pure internal returns (uint8) {
202         require (x > 0);
203 
204         uint8 l = 0;
205         uint8 h = 255;
206 
207         while (h > l) {
208             uint8 m = uint8 ((uint16 (l) + uint16 (h)) >> 1);
209             uint256 t = x >> m;
210             if (t == 0) h = m - 1;
211             else if (t > 1) l = m + 1;
212             else return m;
213         }
214 
215         return h;
216     }
217 
218     /**
219      * Calculate log_2 (x / 2^128) * 2^128.
220      *
221      * @param x parameter value
222      * @return log_2 (x / 2^128) * 2^128
223      */
224     function log_2 (uint256 x) pure internal returns (int256) {
225         require (x > 0);
226 
227         uint8 msb = mostSignificantBit (x);
228 
229         if (msb > 128) x >>= msb - 128;
230         else if (msb < 128) x <<= 128 - msb;
231 
232         x &= TWO128_1;
233 
234         int256 result = (int256 (msb) - 128) << 128; // Integer part of log_2
235 
236         int256 bit = TWO127;
237         for (uint8 i = 0; i < 128 && x > 0; i++) {
238             x = (x << 1) + ((x * x + TWO127) >> 128);
239             if (x > TWO128_1) {
240                 result |= bit;
241                 x = (x >> 1) - TWO127;
242             }
243             bit >>= 1;
244         }
245 
246         return result;
247     }
248 
249     /**
250      * Calculate ln (x / 2^128) * 2^128.
251      *
252      * @param x parameter value
253      * @return ln (x / 2^128) * 2^128
254      */
255     function ln (uint256 x) pure internal returns (int256) {
256         require (x > 0);
257 
258         int256 l2 = log_2 (x);
259         if (l2 == 0) return 0;
260         else {
261             uint256 al2 = uint256 (l2 > 0 ? l2 : -l2);
262             uint8 msb = mostSignificantBit (al2);
263             if (msb > 127) al2 >>= msb - 127;
264             al2 = (al2 * LN2 + TWO127) >> 128;
265             if (msb > 127) al2 <<= msb - 127;
266 
267             return int256 (l2 >= 0 ? al2 : -al2);
268         }
269     }
270 
271     /**
272      * Calculate x * y / 2^128.
273      *
274      * @param x parameter x
275      * @param y parameter y
276      * @return x * y / 2^128
277      */
278     function fpMul (uint256 x, uint256 y) pure internal returns (uint256) {
279         uint256 xh = x >> 128;
280         uint256 xl = x & TWO128_1;
281         uint256 yh = y >> 128;
282         uint256 yl = y & TWO128_1;
283 
284         uint256 result = xh * yh;
285         require (result <= TWO128_1);
286         result <<= 128;
287 
288         result = safeAdd (result, xh * yl);
289         result = safeAdd (result, xl * yh);
290         result = safeAdd (result, (xl * yl) >> 128);
291 
292         return result;
293     }
294 
295     /**
296      * Calculate x * y.
297      *
298      * @param x parameter x
299      * @param y parameter y
300      * @return high and low words of x * y
301      */
302     function longMul (uint256 x, uint256 y)
303     pure internal returns (uint256 h, uint256 l) {
304         uint256 xh = x >> 128;
305         uint256 xl = x & TWO128_1;
306         uint256 yh = y >> 128;
307         uint256 yl = y & TWO128_1;
308 
309         h = xh * yh;
310         l = xl * yl;
311 
312         uint256 m1 = xh * yl;
313         uint256 m2 = xl * yh;
314 
315         h += m1 >> 128;
316         h += m2 >> 128;
317 
318         m1 <<= 128;
319         m2 <<= 128;
320 
321         if (l > TWO256_1 - m1) h += 1;
322         l += m1;
323 
324         if (l > TWO256_1 - m2) h += 1;
325         l += m2;
326     }
327 
328     /**
329      * Calculate x * y / 2^128.
330      *
331      * @param x parameter x
332      * @param y parameter y
333      * @return x * y / 2^128
334      */
335     function fpMulI (int256 x, int256 y) pure internal returns (int256) {
336         bool negative = (x ^ y) < 0; // Whether result is negative
337 
338         uint256 result = fpMul (
339             x < 0 ? uint256 (-1 - x) + 1 : uint256 (x),
340             y < 0 ? uint256 (-1 - y) + 1 : uint256 (y));
341 
342         if (negative) {
343             require (result <= TWO255);
344             return result == 0 ? 0 : -1 - int256 (result - 1);
345         } else {
346             require (result < TWO255);
347             return int256 (result);
348         }
349     }
350 
351     /**
352      * Calculate x + y, throw in case of over-/underflow.
353      *
354      * @param x parameter x
355      * @param y parameter y
356      * @return x + y
357      */
358     function safeAddI (int256 x, int256 y) pure internal returns (int256) {
359         if (x < 0 && y < 0)
360             assert (x >= MINUS_TWO255 - y);
361 
362         if (x > 0 && y > 0)
363             assert (x <= TWO255_1 - y);
364 
365         return x + y;
366     }
367 
368     /**
369      * Calculate x / y * 2^128.
370      *
371      * @param x parameter x
372      * @param y parameter y
373      * @return  x / y * 2^128
374      */
375     function fpDiv (uint256 x, uint256 y) pure internal returns (uint256) {
376         require (y > 0); // Division by zero is forbidden
377 
378         uint8 maxShiftY = mostSignificantBit (y);
379         if (maxShiftY >= 128) maxShiftY -= 127;
380         else maxShiftY = 0;
381 
382         uint256 result = 0;
383 
384         while (true) {
385             uint256 rh = x >> 128;
386             uint256 rl = x << 128;
387 
388             uint256 ph;
389             uint256 pl;
390 
391             (ph, pl) = longMul (result, y);
392             if (rl < pl) {
393                 ph = safeAdd (ph, 1);
394             }
395 
396             rl -= pl;
397             rh -= ph;
398 
399             if (rh == 0) {
400                 result = safeAdd (result, rl / y);
401                 break;
402             } else {
403                 uint256 reminder = (rh << 128) + (rl >> 128);
404 
405                 // How many bits to shift reminder left
406                 uint8 shiftReminder = 255 - mostSignificantBit (reminder);
407                 if (shiftReminder > 128) shiftReminder = 128;
408 
409                 // How many bits to shift result left
410                 uint8 shiftResult = 128 - shiftReminder;
411 
412                 // How many bits to shift Y right
413                 uint8 shiftY = maxShiftY;
414                 if (shiftY > shiftResult) shiftY = shiftResult;
415 
416                 shiftResult -= shiftY;
417 
418                 uint256 r = (reminder << shiftReminder) / (((y - 1) >> shiftY) + 1);
419 
420                 uint8 msbR = mostSignificantBit (r);
421                 require (msbR <= 255 - shiftResult);
422 
423                 result = safeAdd (result, r << shiftResult);
424             }
425         }
426 
427         return result;
428     }
429 }
430 
431 
432 /**
433  * Continuous Sale Action for selling PAT tokens.
434  */
435 contract PATTokenSale is Math {
436     /**
437      * Time period when 15% bonus is in force.
438      */
439     uint256 private constant TRIPLE_BONUS = 1 hours;
440 
441     /**
442      * Time period when 10% bonus is in force.
443      */
444     uint256 private constant DOUBLE_BONUS = 1 days;
445 
446     /**
447      * Time period when 5% bonus is in force.
448      */
449     uint256 private constant SINGLE_BONUS = 1 weeks;
450 
451     /**
452      * Create PAT Token Sale smart contract with given sale start time, token
453      * contract and central bank address.
454      *
455      * @param _saleStartTime sale start time
456      * @param _saleDuration sale duration
457      * @param _token ERC20 smart contract managing tokens to be sold
458      * @param _centralBank central bank address to transfer tokens from
459      * @param _saleCap maximum amount of ether to collect (in Wei)
460      * @param _minimumInvestment minimum investment amount (in Wei)
461      * @param _a parameter a of price formula
462      * @param _b parameter b of price formula
463      * @param _c parameter c of price formula
464      */
465     function PATTokenSale (
466         uint256 _saleStartTime, uint256 _saleDuration,
467         Token _token, address _centralBank,
468         uint256 _saleCap, uint256 _minimumInvestment,
469         int256 _a, int256 _b, int256 _c) {
470         saleStartTime = _saleStartTime;
471         saleDuration = _saleDuration;
472         token = _token;
473         centralBank = _centralBank;
474         saleCap = _saleCap;
475         minimumInvestment = _minimumInvestment;
476         a = _a;
477         b = _b;
478         c = _c;
479     }
480 
481     /**
482      * Equivalent to buy().
483      */
484     function () payable public {
485         require (msg.data.length == 0);
486 
487         buy ();
488     }
489 
490     /**
491      * Buy tokens.
492      */
493     function buy () payable public {
494         require (!finished);
495         require (now >= saleStartTime);
496         require (now < safeAdd (saleStartTime, saleDuration));
497 
498         require (msg.value >= minimumInvestment);
499 
500         if (msg.value > 0) {
501             uint256 remainingCap = safeSub (saleCap, totalInvested);
502             uint256 toInvest;
503             uint256 toRefund;
504 
505             if (msg.value <= remainingCap) {
506                 toInvest = msg.value;
507                 toRefund = 0;
508             } else {
509                 toInvest = remainingCap;
510                 toRefund = safeSub (msg.value, toInvest);
511             }
512 
513             Investor storage investor = investors [msg.sender];
514             investor.amount = safeAdd (investor.amount, toInvest);
515             if (now < safeAdd (saleStartTime, TRIPLE_BONUS))
516                 investor.bonusAmount = safeAdd (
517                     investor.bonusAmount, safeMul (toInvest, 6));
518             else if (now < safeAdd (saleStartTime, DOUBLE_BONUS))
519                 investor.bonusAmount = safeAdd (
520                     investor.bonusAmount, safeMul (toInvest, 4));
521             else if (now < safeAdd (saleStartTime, SINGLE_BONUS))
522                 investor.bonusAmount = safeAdd (
523                     investor.bonusAmount, safeMul (toInvest, 2));
524 
525             Investment (msg.sender, toInvest);
526 
527             totalInvested = safeAdd (totalInvested, toInvest);
528             if (toInvest == remainingCap) {
529                 finished = true;
530                 finalPrice = price (now);
531 
532                 Finished (finalPrice);
533             }
534 
535             if (toRefund > 0)
536                 msg.sender.transfer (toRefund);
537         }
538     }
539 
540     /**
541      * Buy tokens providing referral code.
542      *
543      * @param _referralCode referral code, actually address of referee
544      */
545     function buyReferral (address _referralCode) payable public {
546         require (msg.sender != _referralCode);
547 
548         Investor storage referee = investors [_referralCode];
549 
550         // Make sure referee actually did invest something
551         require (referee.amount > 0);
552 
553         Investor storage referrer = investors [msg.sender];
554         uint256 oldAmount = referrer.amount;
555 
556         buy ();
557 
558         uint256 invested = safeSub (referrer.amount, oldAmount);
559 
560         // Make sure referrer actually did invest something
561         require (invested > 0);
562 
563         referee.investedByReferrers = safeAdd (
564             referee.investedByReferrers, invested);
565 
566         referrer.bonusAmount = safeAdd (
567             referrer.bonusAmount,
568             min (referee.amount, invested));
569     }
570 
571     /**
572      * Get number of tokens to be delivered to given investor.
573      *
574      * @param _investor address of the investor to get number of tokens to be
575      *        delivered to
576      * @return number of tokens to be delivered to given investor
577      */
578     function outstandingTokens (address _investor)
579     constant public returns (uint256) {
580         require (finished);
581         assert (finalPrice > 0);
582 
583         Investor storage investor = investors [_investor];
584         uint256 bonusAmount = investor.bonusAmount;
585         bonusAmount = safeAdd (
586             bonusAmount, min (investor.amount, investor.investedByReferrers));
587 
588         uint256 effectiveAmount = safeAdd (
589             investor.amount,
590             bonusAmount / 40);
591 
592         return fpDiv (effectiveAmount, finalPrice);
593     }
594 
595     /**
596      * Deliver purchased tokens to given investor.
597      *
598      * @param _investor investor to deliver purchased tokens to
599      */
600     function deliver (address _investor) public returns (bool) {
601         require (finished);
602 
603         Investor storage investor = investors [_investor];
604         require (investor.amount > 0);
605 
606         uint256 value = outstandingTokens (_investor);
607         if (value > 0) {
608             if (!token.transferFrom (centralBank, _investor, value)) return false;
609         }
610 
611         totalInvested = safeSub (totalInvested, investor.amount);
612         investor.amount = 0;
613         investor.bonusAmount = 0;
614         investor.investedByReferrers = 0;
615         return true;
616     }
617 
618     /**
619      * Collect sale revenue.
620      */
621     function collectRevenue () public {
622         require (msg.sender == centralBank);
623 
624         centralBank.transfer (this.balance);
625     }
626 
627     /**
628      * Return token price at given time in Wei per token natural unit.
629      *
630      * @param _time time to return price at
631      * @return price at given time as 128.128 fixed point number
632      */
633     function price (uint256 _time) constant public returns (uint256) {
634         require (_time >= saleStartTime);
635         require (_time <= safeAdd (saleStartTime, saleDuration));
636 
637         require (_time <= TWO128_1);
638         uint256 t = _time << 128;
639 
640         uint256 cPlusT = (c >= 0) ?
641         safeAdd (t, uint256 (c)) :
642         safeSub (t, uint256 (-1 - c) + 1);
643         int256 lnCPlusT = ln (cPlusT);
644         int256 bLnCPlusT = fpMulI (b, lnCPlusT);
645         int256 aPlusBLnCPlusT = safeAddI (a, bLnCPlusT);
646 
647         require (aPlusBLnCPlusT >= 0);
648         return uint256 (aPlusBLnCPlusT);
649     }
650 
651     /**
652      * Finish sale after sale period ended.
653      */
654     function finishSale () public {
655         require (msg.sender == centralBank);
656         require (!finished);
657         uint256 saleEndTime = safeAdd (saleStartTime, saleDuration);
658         require (now >= saleEndTime);
659 
660         finished = true;
661         finalPrice = price (saleEndTime);
662 
663         Finished (finalPrice);
664     }
665 
666     /**
667      * Destroy smart contract.
668      */
669     function destroy () public {
670         require (msg.sender == centralBank);
671         require (finished);
672         require (now >= safeAdd (saleStartTime, saleDuration));
673         require (totalInvested == 0);
674         require (this.balance == 0);
675 
676         selfdestruct (centralBank);
677     }
678 
679     /**
680      * Return minimum of two values.
681      *
682      * @param x first value
683      * @param y second value
684      * @return minimum of two values
685      */
686     function min (uint256 x, uint256 y) internal pure returns (uint256) {
687         return x < y ? x : y;
688     }
689 
690     /**
691      * Sale start time.
692      */
693     uint256 internal saleStartTime;
694 
695     /**
696      * Sale duration.
697      */
698     uint256 internal saleDuration;
699 
700     /**
701      * ERC20 token smart contract managing tokens to be sold.
702      */
703     Token internal token;
704 
705     /**
706      * Address of central bank to transfer tokens from.
707      */
708     address internal centralBank;
709 
710     /**
711      * Maximum number of Wei to collect.
712      */
713     uint256 internal saleCap;
714 
715     /**
716      * Minimum investment amount in Wei.
717      */
718     uint256 internal minimumInvestment;
719 
720     /**
721      * Price formula parameters.  Price at given time t is calculated as
722      * a / 2^128 + b * ln ((c + t) / 2^128) / 2^128.
723      */
724     int256 internal a;
725     int256 internal b;
726     int256 internal c;
727 
728     /**
729      * True is sale was finished successfully, false otherwise.
730      */
731     bool internal finished = false;
732 
733     /**
734      * Final price for finished sale.
735      */
736     uint256 internal finalPrice;
737 
738     /**
739      * Maps investor's address to corresponding Investor structure.
740      */
741     mapping (address => Investor) internal investors;
742 
743     /**
744      * Total amount invested in Wei.
745      */
746     uint256 internal totalInvested = 0;
747 
748     /**
749      * Encapsulates information about investor.
750      */
751     struct Investor {
752         /**
753          * Total amount invested in Wei.
754          */
755         uint256 amount;
756 
757         /**
758          * Bonus amount in Wei multiplied by 40.
759          */
760         uint256 bonusAmount;
761 
762         /**
763          * Total amount of ether invested by others while referring this address.
764          */
765         uint256 investedByReferrers;
766     }
767 
768     /**
769      * Logged when an investment was made.
770      *
771      * @param investor address of the investor who made the investment
772      * @param amount investment amount
773      */
774     event Investment (address indexed investor, uint256 amount);
775 
776     /**
777      * Logged when sale finished successfully.
778      *
779      * @param finalPrice final price of the sale in Wei per token natural unit as
780      *                   128.128 bit fixed point number.
781      */
782     event Finished (uint256 finalPrice);
783 }