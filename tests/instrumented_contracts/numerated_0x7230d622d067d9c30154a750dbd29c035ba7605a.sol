1 // The software and documentation available in this repository (the "Software") is protected by copyright law and accessible pursuant to the license set forth below. Copyright © 2020 MRTB Ltd. All rights reserved.
2 //
3 // Permission is hereby granted, free of charge, to any person or organization obtaining the Software (the “Licensee”) to privately study, review, and analyze the Software. Licensee shall not use the Software for any other purpose. Licensee shall not modify, transfer, assign, share, or sub-license the Software or any derivative works of the Software.
4 //
5 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE.
6 
7 pragma solidity 0.5.15;
8 pragma experimental ABIEncoderV2;
9 
10 
11 library LibMathSigned {
12     int256 private constant _WAD = 10 ** 18;
13     int256 private constant _INT256_MIN = -2 ** 255;
14 
15     uint8 private constant FIXED_DIGITS = 18;
16     int256 private constant FIXED_1 = 10 ** 18;
17     int256 private constant FIXED_E = 2718281828459045235;
18     uint8 private constant LONGER_DIGITS = 36;
19     int256 private constant LONGER_FIXED_LOG_E_1_5 = 405465108108164381978013115464349137;
20     int256 private constant LONGER_FIXED_1 = 10 ** 36;
21     int256 private constant LONGER_FIXED_LOG_E_10 = 2302585092994045684017991454684364208;
22 
23 
24     function WAD() internal pure returns (int256) {
25         return _WAD;
26     }
27 
28     // additive inverse
29     function neg(int256 a) internal pure returns (int256) {
30         return sub(int256(0), a);
31     }
32 
33     /**
34      * @dev Multiplies two signed integers, reverts on overflow
35      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L13
36      */
37     function mul(int256 a, int256 b) internal pure returns (int256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
41         if (a == 0) {
42             return 0;
43         }
44         require(!(a == -1 && b == _INT256_MIN), "wmultiplication overflow");
45 
46         int256 c = a * b;
47         require(c / a == b, "wmultiplication overflow");
48 
49         return c;
50     }
51 
52     /**
53      * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
54      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L32
55      */
56     function div(int256 a, int256 b) internal pure returns (int256) {
57         require(b != 0, "wdivision by zero");
58         require(!(b == -1 && a == _INT256_MIN), "wdivision overflow");
59 
60         int256 c = a / b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two signed integers, reverts on overflow.
67      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L44
68      */
69     function sub(int256 a, int256 b) internal pure returns (int256) {
70         int256 c = a - b;
71         require((b >= 0 && c <= a) || (b < 0 && c > a), "subtraction overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Adds two signed integers, reverts on overflow.
78      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SignedSafeMath.sol#L54
79      */
80     function add(int256 a, int256 b) internal pure returns (int256) {
81         int256 c = a + b;
82         require((b >= 0 && c >= a) || (b < 0 && c < a), "addition overflow");
83 
84         return c;
85     }
86 
87     function wmul(int256 x, int256 y) internal pure returns (int256 z) {
88         z = roundHalfUp(mul(x, y), _WAD) / _WAD;
89     }
90 
91     // solium-disable-next-line security/no-assign-params
92     function wdiv(int256 x, int256 y) internal pure returns (int256 z) {
93         if (y < 0) {
94             y = -y;
95             x = -x;
96         }
97         z = roundHalfUp(mul(x, _WAD), y) / y;
98     }
99 
100     // solium-disable-next-line security/no-assign-params
101     function wfrac(int256 x, int256 y, int256 z) internal pure returns (int256 r) {
102         int256 t = mul(x, y);
103         if (z < 0) {
104             z = neg(z);
105             t = neg(t);
106         }
107         r = roundHalfUp(t, z) / z;
108     }
109 
110     function min(int256 x, int256 y) internal pure returns (int256) {
111         return x <= y ? x : y;
112     }
113 
114     function max(int256 x, int256 y) internal pure returns (int256) {
115         return x >= y ? x : y;
116     }
117 
118     // see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/utils/SafeCast.sol#L103
119     function toUint256(int256 x) internal pure returns (uint256) {
120         require(x >= 0, "int overflow");
121         return uint256(x);
122     }
123 
124     // x ^ n
125     // NOTE: n is a normal integer, do not shift 18 decimals
126     // solium-disable-next-line security/no-assign-params
127     function wpowi(int256 x, int256 n) internal pure returns (int256 z) {
128         require(n >= 0, "wpowi only supports n >= 0");
129         z = n % 2 != 0 ? x : _WAD;
130 
131         for (n /= 2; n != 0; n /= 2) {
132             x = wmul(x, x);
133 
134             if (n % 2 != 0) {
135                 z = wmul(z, x);
136             }
137         }
138     }
139 
140     // ROUND_HALF_UP rule helper. You have to call roundHalfUp(x, y) / y to finish the rounding operation
141     // 0.5 ≈ 1, 0.4 ≈ 0, -0.5 ≈ -1, -0.4 ≈ 0
142     function roundHalfUp(int256 x, int256 y) internal pure returns (int256) {
143         require(y > 0, "roundHalfUp only supports y > 0");
144         if (x >= 0) {
145             return add(x, y / 2);
146         }
147         return sub(x, y / 2);
148     }
149 
150     // solium-disable-next-line security/no-assign-params
151     function wln(int256 x) internal pure returns (int256) {
152         require(x > 0, "logE of negative number");
153         require(x <= 10000000000000000000000000000000000000000, "logE only accepts v <= 1e22 * 1e18"); // in order to prevent using safe-math
154         int256 r = 0;
155         uint8 extraDigits = LONGER_DIGITS - FIXED_DIGITS;
156         int256 t = int256(uint256(10)**uint256(extraDigits));
157 
158         while (x <= FIXED_1 / 10) {
159             x = x * 10;
160             r -= LONGER_FIXED_LOG_E_10;
161         }
162         while (x >= 10 * FIXED_1) {
163             x = x / 10;
164             r += LONGER_FIXED_LOG_E_10;
165         }
166         while (x < FIXED_1) {
167             x = wmul(x, FIXED_E);
168             r -= LONGER_FIXED_1;
169         }
170         while (x > FIXED_E) {
171             x = wdiv(x, FIXED_E);
172             r += LONGER_FIXED_1;
173         }
174         if (x == FIXED_1) {
175             return roundHalfUp(r, t) / t;
176         }
177         if (x == FIXED_E) {
178             return FIXED_1 + roundHalfUp(r, t) / t;
179         }
180         x *= t;
181 
182         //               x^2   x^3   x^4
183         // Ln(1+x) = x - --- + --- - --- + ...
184         //                2     3     4
185         // when -1 < x < 1, O(x^n) < ε => when n = 36, 0 < x < 0.316
186         //
187         //                    2    x           2    x          2    x
188         // Ln(a+x) = Ln(a) + ---(------)^1  + ---(------)^3 + ---(------)^5 + ...
189         //                    1   2a+x         3   2a+x        5   2a+x
190         //
191         // Let x = v - a
192         //                  2   v-a         2   v-a        2   v-a
193         // Ln(v) = Ln(a) + ---(-----)^1  + ---(-----)^3 + ---(-----)^5 + ...
194         //                  1   v+a         3   v+a        5   v+a
195         // when n = 36, 1 < v < 3.423
196         r = r + LONGER_FIXED_LOG_E_1_5;
197         int256 a1_5 = (3 * LONGER_FIXED_1) / 2;
198         int256 m = (LONGER_FIXED_1 * (x - a1_5)) / (x + a1_5);
199         r = r + 2 * m;
200         int256 m2 = (m * m) / LONGER_FIXED_1;
201         uint8 i = 3;
202         while (true) {
203             m = (m * m2) / LONGER_FIXED_1;
204             r = r + (2 * m) / int256(i);
205             i += 2;
206             if (i >= 3 + 2 * FIXED_DIGITS) {
207                 break;
208             }
209         }
210         return roundHalfUp(r, t) / t;
211     }
212 
213     // Log(b, x)
214     function logBase(int256 base, int256 x) internal pure returns (int256) {
215         return wdiv(wln(x), wln(base));
216     }
217 
218     function ceil(int256 x, int256 m) internal pure returns (int256) {
219         require(x >= 0, "ceil need x >= 0");
220         require(m > 0, "ceil need m > 0");
221         return (sub(add(x, m), 1) / m) * m;
222     }
223 }
224 
225 library LibMathUnsigned {
226     uint256 private constant _WAD = 10**18;
227     uint256 private constant _POSITIVE_INT256_MAX = 2**255 - 1;
228 
229     function WAD() internal pure returns (uint256) {
230         return _WAD;
231     }
232 
233     /**
234      * @dev Returns the addition of two unsigned integers, reverting on overflow.
235      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L26
236      */
237     function add(uint256 a, uint256 b) internal pure returns (uint256) {
238         uint256 c = a + b;
239         require(c >= a, "Unaddition overflow");
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L55
248      */
249     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250         require(b <= a, "Unsubtraction overflow");
251         uint256 c = a - b;
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the multiplication of two unsigned integers, reverting on
258      * overflow.
259      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L71
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "Unmultiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L111
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         // Solidity only automatically asserts when dividing by 0
282         require(b > 0, "Undivision by zero");
283         uint256 c = a / b;
284         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285 
286         return c;
287     }
288 
289     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
290         z = add(mul(x, y), _WAD / 2) / _WAD;
291     }
292 
293     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
294         z = add(mul(x, _WAD), y / 2) / y;
295     }
296 
297     function wfrac(uint256 x, uint256 y, uint256 z) internal pure returns (uint256 r) {
298         r = mul(x, y) / z;
299     }
300 
301     function min(uint256 x, uint256 y) internal pure returns (uint256) {
302         return x <= y ? x : y;
303     }
304 
305     function max(uint256 x, uint256 y) internal pure returns (uint256) {
306         return x >= y ? x : y;
307     }
308 
309     function toInt256(uint256 x) internal pure returns (int256) {
310         require(x <= _POSITIVE_INT256_MAX, "uint256 overflow");
311         return int256(x);
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts with custom message when dividing by zero.
317      * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/math/SafeMath.sol#L146
318      */
319     function mod(uint256 x, uint256 m) internal pure returns (uint256) {
320         require(m != 0, "mod by zero");
321         return x % m;
322     }
323 
324     function ceil(uint256 x, uint256 m) internal pure returns (uint256) {
325         require(m > 0, "ceil need m > 0");
326         return (sub(add(x, m), 1) / m) * m;
327     }
328 }
329 
330 library LibTypes {
331     enum Side {FLAT, SHORT, LONG}
332 
333     enum Status {NORMAL, EMERGENCY, SETTLED}
334 
335     function counterSide(Side side) internal pure returns (Side) {
336         if (side == Side.LONG) {
337             return Side.SHORT;
338         } else if (side == Side.SHORT) {
339             return Side.LONG;
340         }
341         return side;
342     }
343 
344     //////////////////////////////////////////////////////////////////////////
345     // Perpetual
346     //////////////////////////////////////////////////////////////////////////
347     struct PerpGovernanceConfig {
348         uint256 initialMarginRate;
349         uint256 maintenanceMarginRate;
350         uint256 liquidationPenaltyRate;
351         uint256 penaltyFundRate;
352         int256 takerDevFeeRate;
353         int256 makerDevFeeRate;
354         uint256 lotSize;
355         uint256 tradingLotSize;
356     }
357 
358     struct MarginAccount {
359         LibTypes.Side side;
360         uint256 size;
361         uint256 entryValue;
362         int256 entrySocialLoss;
363         int256 entryFundingLoss;
364         int256 cashBalance;
365     }
366 
367     //////////////////////////////////////////////////////////////////////////
368     // AMM
369     //////////////////////////////////////////////////////////////////////////
370     struct AMMGovernanceConfig {
371         uint256 poolFeeRate;
372         uint256 poolDevFeeRate;
373         int256 emaAlpha;
374         uint256 updatePremiumPrize;
375         int256 markPremiumLimit;
376         int256 fundingDampener;
377     }
378 
379     struct FundingState {
380         uint256 lastFundingTime;
381         int256 lastPremium;
382         int256 lastEMAPremium;
383         uint256 lastIndexPrice;
384         int256 accumulatedFundingPerContract;
385     }
386 }
387 
388 interface IPriceFeeder {
389     function price() external view returns (uint256 lastPrice, uint256 lastTimestamp);
390 }
391 
392 interface IAMM {
393     function shareTokenAddress() external view returns (address);
394 
395     function indexPrice() external view returns (uint256 price, uint256 timestamp);
396 
397     function positionSize() external returns (uint256);
398 
399     function lastFundingState() external view returns (LibTypes.FundingState memory);
400 
401     function currentFundingRate() external returns (int256);
402 
403     function currentFundingState() external returns (LibTypes.FundingState memory);
404 
405     function lastFundingRate() external view returns (int256);
406 
407     function getGovernance() external view returns (LibTypes.AMMGovernanceConfig memory);
408 
409     function perpetualProxy() external view returns (IPerpetual);
410 
411     function currentMarkPrice() external returns (uint256);
412 
413     function currentAvailableMargin() external returns (uint256);
414 
415     function currentPremiumRate() external returns (int256);
416 
417     function currentFairPrice() external returns (uint256);
418 
419     function currentPremium() external returns (int256);
420 
421     function currentAccumulatedFundingPerContract() external returns (int256);
422 
423     function updateIndex() external;
424 
425     function createPool(uint256 amount) external;
426 
427     function settleShare(uint256 shareAmount) external;
428 
429     function buy(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
430 
431     function sell(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
432 
433     function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
434         external
435         returns (uint256);
436 
437     function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
438         external
439         returns (uint256);
440 
441     function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
442 
443     function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
444 
445     function depositAndBuy(
446         uint256 depositAmount,
447         uint256 tradeAmount,
448         uint256 limitPrice,
449         uint256 deadline
450     ) external payable;
451 
452     function depositAndSell(
453         uint256 depositAmount,
454         uint256 tradeAmount,
455         uint256 limitPrice,
456         uint256 deadline
457     ) external payable;
458 
459     function buyAndWithdraw(
460         uint256 tradeAmount,
461         uint256 limitPrice,
462         uint256 deadline,
463         uint256 withdrawAmount
464     ) external;
465 
466     function sellAndWithdraw(
467         uint256 tradeAmount,
468         uint256 limitPrice,
469         uint256 deadline,
470         uint256 withdrawAmount
471     ) external;
472 
473     function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) external payable;
474 }
475 
476 interface IPerpetual {
477     function devAddress() external view returns (address);
478 
479     function getMarginAccount(address trader) external view returns (LibTypes.MarginAccount memory);
480 
481     function getGovernance() external view returns (LibTypes.PerpGovernanceConfig memory);
482 
483     function status() external view returns (LibTypes.Status);
484 
485     function paused() external view returns (bool);
486 
487     function withdrawDisabled() external view returns (bool);
488 
489     function settlementPrice() external view returns (uint256);
490 
491     function globalConfig() external view returns (address);
492 
493     function collateral() external view returns (address);
494 
495     function amm() external view returns (IAMM);
496 
497     function totalSize(LibTypes.Side side) external view returns (uint256);
498 
499     function markPrice() external returns (uint256);
500 
501     function socialLossPerContract(LibTypes.Side side) external view returns (int256);
502 
503     function availableMargin(address trader) external returns (int256);
504 
505     function positionMargin(address trader) external view returns (uint256);
506 
507     function maintenanceMargin(address trader) external view returns (uint256);
508 
509     function isSafe(address trader) external returns (bool);
510 
511     function isSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);
512 
513     function isIMSafe(address trader) external returns (bool);
514 
515     function isIMSafeWithPrice(address trader, uint256 currentMarkPrice) external returns (bool);
516 
517     function tradePosition(
518         address taker,
519         address maker,
520         LibTypes.Side side,
521         uint256 price,
522         uint256 amount
523     ) external returns (uint256, uint256);
524 
525     function transferCashBalance(
526         address from,
527         address to,
528         uint256 amount
529     ) external;
530 
531     function depositFor(address trader, uint256 amount) external payable;
532 
533     function withdrawFor(address payable trader, uint256 amount) external;
534 
535     function liquidate(address trader, uint256 amount) external returns (uint256, uint256);
536 
537     function insuranceFundBalance() external view returns (int256);
538 
539     function beginGlobalSettlement(uint256 price) external;
540 
541     function endGlobalSettlement() external;
542 
543     function isValidLotSize(uint256 amount) external view returns (bool);
544 
545     function isValidTradingLotSize(uint256 amount) external view returns (bool);
546 }
547 
548 contract Context {
549     // Empty internal constructor, to prevent people from mistakenly deploying
550     // an instance of this contract, which should be used via inheritance.
551     constructor () internal { }
552     // solhint-disable-previous-line no-empty-blocks
553 
554     function _msgSender() internal view returns (address payable) {
555         return msg.sender;
556     }
557 
558     function _msgData() internal view returns (bytes memory) {
559         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
560         return msg.data;
561     }
562 }
563 
564 interface IERC20 {
565     /**
566      * @dev Returns the amount of tokens in existence.
567      */
568     function totalSupply() external view returns (uint256);
569 
570     /**
571      * @dev Returns the amount of tokens owned by `account`.
572      */
573     function balanceOf(address account) external view returns (uint256);
574 
575     /**
576      * @dev Moves `amount` tokens from the caller's account to `recipient`.
577      *
578      * Returns a boolean value indicating whether the operation succeeded.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transfer(address recipient, uint256 amount) external returns (bool);
583 
584     /**
585      * @dev Returns the remaining number of tokens that `spender` will be
586      * allowed to spend on behalf of `owner` through {transferFrom}. This is
587      * zero by default.
588      *
589      * This value changes when {approve} or {transferFrom} are called.
590      */
591     function allowance(address owner, address spender) external view returns (uint256);
592 
593     /**
594      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
595      *
596      * Returns a boolean value indicating whether the operation succeeded.
597      *
598      * IMPORTANT: Beware that changing an allowance with this method brings the risk
599      * that someone may use both the old and the new allowance by unfortunate
600      * transaction ordering. One possible solution to mitigate this race
601      * condition is to first reduce the spender's allowance to 0 and set the
602      * desired value afterwards:
603      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
604      *
605      * Emits an {Approval} event.
606      */
607     function approve(address spender, uint256 amount) external returns (bool);
608 
609     /**
610      * @dev Moves `amount` tokens from `sender` to `recipient` using the
611      * allowance mechanism. `amount` is then deducted from the caller's
612      * allowance.
613      *
614      * Returns a boolean value indicating whether the operation succeeded.
615      *
616      * Emits a {Transfer} event.
617      */
618     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
619 
620     /**
621      * @dev Emitted when `value` tokens are moved from one account (`from`) to
622      * another (`to`).
623      *
624      * Note that `value` may be zero.
625      */
626     event Transfer(address indexed from, address indexed to, uint256 value);
627 
628     /**
629      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
630      * a call to {approve}. `value` is the new allowance.
631      */
632     event Approval(address indexed owner, address indexed spender, uint256 value);
633 }
634 
635 library SafeMath {
636     /**
637      * @dev Returns the addition of two unsigned integers, reverting on
638      * overflow.
639      *
640      * Counterpart to Solidity's `+` operator.
641      *
642      * Requirements:
643      * - Addition cannot overflow.
644      */
645     function add(uint256 a, uint256 b) internal pure returns (uint256) {
646         uint256 c = a + b;
647         require(c >= a, "SafeMath: addition overflow");
648 
649         return c;
650     }
651 
652     /**
653      * @dev Returns the subtraction of two unsigned integers, reverting on
654      * overflow (when the result is negative).
655      *
656      * Counterpart to Solidity's `-` operator.
657      *
658      * Requirements:
659      * - Subtraction cannot overflow.
660      */
661     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
662         return sub(a, b, "SafeMath: subtraction overflow");
663     }
664 
665     /**
666      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
667      * overflow (when the result is negative).
668      *
669      * Counterpart to Solidity's `-` operator.
670      *
671      * Requirements:
672      * - Subtraction cannot overflow.
673      *
674      * _Available since v2.4.0._
675      */
676     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
677         require(b <= a, errorMessage);
678         uint256 c = a - b;
679 
680         return c;
681     }
682 
683     /**
684      * @dev Returns the multiplication of two unsigned integers, reverting on
685      * overflow.
686      *
687      * Counterpart to Solidity's `*` operator.
688      *
689      * Requirements:
690      * - Multiplication cannot overflow.
691      */
692     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
693         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
694         // benefit is lost if 'b' is also tested.
695         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
696         if (a == 0) {
697             return 0;
698         }
699 
700         uint256 c = a * b;
701         require(c / a == b, "SafeMath: multiplication overflow");
702 
703         return c;
704     }
705 
706     /**
707      * @dev Returns the integer division of two unsigned integers. Reverts on
708      * division by zero. The result is rounded towards zero.
709      *
710      * Counterpart to Solidity's `/` operator. Note: this function uses a
711      * `revert` opcode (which leaves remaining gas untouched) while Solidity
712      * uses an invalid opcode to revert (consuming all remaining gas).
713      *
714      * Requirements:
715      * - The divisor cannot be zero.
716      */
717     function div(uint256 a, uint256 b) internal pure returns (uint256) {
718         return div(a, b, "SafeMath: division by zero");
719     }
720 
721     /**
722      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
723      * division by zero. The result is rounded towards zero.
724      *
725      * Counterpart to Solidity's `/` operator. Note: this function uses a
726      * `revert` opcode (which leaves remaining gas untouched) while Solidity
727      * uses an invalid opcode to revert (consuming all remaining gas).
728      *
729      * Requirements:
730      * - The divisor cannot be zero.
731      *
732      * _Available since v2.4.0._
733      */
734     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
735         // Solidity only automatically asserts when dividing by 0
736         require(b > 0, errorMessage);
737         uint256 c = a / b;
738         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
739 
740         return c;
741     }
742 
743     /**
744      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
745      * Reverts when dividing by zero.
746      *
747      * Counterpart to Solidity's `%` operator. This function uses a `revert`
748      * opcode (which leaves remaining gas untouched) while Solidity uses an
749      * invalid opcode to revert (consuming all remaining gas).
750      *
751      * Requirements:
752      * - The divisor cannot be zero.
753      */
754     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
755         return mod(a, b, "SafeMath: modulo by zero");
756     }
757 
758     /**
759      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
760      * Reverts with custom message when dividing by zero.
761      *
762      * Counterpart to Solidity's `%` operator. This function uses a `revert`
763      * opcode (which leaves remaining gas untouched) while Solidity uses an
764      * invalid opcode to revert (consuming all remaining gas).
765      *
766      * Requirements:
767      * - The divisor cannot be zero.
768      *
769      * _Available since v2.4.0._
770      */
771     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
772         require(b != 0, errorMessage);
773         return a % b;
774     }
775 }
776 
777 contract ERC20 is Context, IERC20 {
778     using SafeMath for uint256;
779 
780     mapping (address => uint256) private _balances;
781 
782     mapping (address => mapping (address => uint256)) private _allowances;
783 
784     uint256 private _totalSupply;
785 
786     /**
787      * @dev See {IERC20-totalSupply}.
788      */
789     function totalSupply() public view returns (uint256) {
790         return _totalSupply;
791     }
792 
793     /**
794      * @dev See {IERC20-balanceOf}.
795      */
796     function balanceOf(address account) public view returns (uint256) {
797         return _balances[account];
798     }
799 
800     /**
801      * @dev See {IERC20-transfer}.
802      *
803      * Requirements:
804      *
805      * - `recipient` cannot be the zero address.
806      * - the caller must have a balance of at least `amount`.
807      */
808     function transfer(address recipient, uint256 amount) public returns (bool) {
809         _transfer(_msgSender(), recipient, amount);
810         return true;
811     }
812 
813     /**
814      * @dev See {IERC20-allowance}.
815      */
816     function allowance(address owner, address spender) public view returns (uint256) {
817         return _allowances[owner][spender];
818     }
819 
820     /**
821      * @dev See {IERC20-approve}.
822      *
823      * Requirements:
824      *
825      * - `spender` cannot be the zero address.
826      */
827     function approve(address spender, uint256 amount) public returns (bool) {
828         _approve(_msgSender(), spender, amount);
829         return true;
830     }
831 
832     /**
833      * @dev See {IERC20-transferFrom}.
834      *
835      * Emits an {Approval} event indicating the updated allowance. This is not
836      * required by the EIP. See the note at the beginning of {ERC20};
837      *
838      * Requirements:
839      * - `sender` and `recipient` cannot be the zero address.
840      * - `sender` must have a balance of at least `amount`.
841      * - the caller must have allowance for `sender`'s tokens of at least
842      * `amount`.
843      */
844     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
845         _transfer(sender, recipient, amount);
846         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
847         return true;
848     }
849 
850     /**
851      * @dev Atomically increases the allowance granted to `spender` by the caller.
852      *
853      * This is an alternative to {approve} that can be used as a mitigation for
854      * problems described in {IERC20-approve}.
855      *
856      * Emits an {Approval} event indicating the updated allowance.
857      *
858      * Requirements:
859      *
860      * - `spender` cannot be the zero address.
861      */
862     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
863         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
864         return true;
865     }
866 
867     /**
868      * @dev Atomically decreases the allowance granted to `spender` by the caller.
869      *
870      * This is an alternative to {approve} that can be used as a mitigation for
871      * problems described in {IERC20-approve}.
872      *
873      * Emits an {Approval} event indicating the updated allowance.
874      *
875      * Requirements:
876      *
877      * - `spender` cannot be the zero address.
878      * - `spender` must have allowance for the caller of at least
879      * `subtractedValue`.
880      */
881     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
882         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
883         return true;
884     }
885 
886     /**
887      * @dev Moves tokens `amount` from `sender` to `recipient`.
888      *
889      * This is internal function is equivalent to {transfer}, and can be used to
890      * e.g. implement automatic token fees, slashing mechanisms, etc.
891      *
892      * Emits a {Transfer} event.
893      *
894      * Requirements:
895      *
896      * - `sender` cannot be the zero address.
897      * - `recipient` cannot be the zero address.
898      * - `sender` must have a balance of at least `amount`.
899      */
900     function _transfer(address sender, address recipient, uint256 amount) internal {
901         require(sender != address(0), "ERC20: transfer from the zero address");
902         require(recipient != address(0), "ERC20: transfer to the zero address");
903 
904         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
905         _balances[recipient] = _balances[recipient].add(amount);
906         emit Transfer(sender, recipient, amount);
907     }
908 
909     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
910      * the total supply.
911      *
912      * Emits a {Transfer} event with `from` set to the zero address.
913      *
914      * Requirements
915      *
916      * - `to` cannot be the zero address.
917      */
918     function _mint(address account, uint256 amount) internal {
919         require(account != address(0), "ERC20: mint to the zero address");
920 
921         _totalSupply = _totalSupply.add(amount);
922         _balances[account] = _balances[account].add(amount);
923         emit Transfer(address(0), account, amount);
924     }
925 
926     /**
927      * @dev Destroys `amount` tokens from `account`, reducing the
928      * total supply.
929      *
930      * Emits a {Transfer} event with `to` set to the zero address.
931      *
932      * Requirements
933      *
934      * - `account` cannot be the zero address.
935      * - `account` must have at least `amount` tokens.
936      */
937     function _burn(address account, uint256 amount) internal {
938         require(account != address(0), "ERC20: burn from the zero address");
939 
940         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
941         _totalSupply = _totalSupply.sub(amount);
942         emit Transfer(account, address(0), amount);
943     }
944 
945     /**
946      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
947      *
948      * This is internal function is equivalent to `approve`, and can be used to
949      * e.g. set automatic allowances for certain subsystems, etc.
950      *
951      * Emits an {Approval} event.
952      *
953      * Requirements:
954      *
955      * - `owner` cannot be the zero address.
956      * - `spender` cannot be the zero address.
957      */
958     function _approve(address owner, address spender, uint256 amount) internal {
959         require(owner != address(0), "ERC20: approve from the zero address");
960         require(spender != address(0), "ERC20: approve to the zero address");
961 
962         _allowances[owner][spender] = amount;
963         emit Approval(owner, spender, amount);
964     }
965 
966     /**
967      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
968      * from the caller's allowance.
969      *
970      * See {_burn} and {_approve}.
971      */
972     function _burnFrom(address account, uint256 amount) internal {
973         _burn(account, amount);
974         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
975     }
976 }
977 
978 library Roles {
979     struct Role {
980         mapping (address => bool) bearer;
981     }
982 
983     /**
984      * @dev Give an account access to this role.
985      */
986     function add(Role storage role, address account) internal {
987         require(!has(role, account), "Roles: account already has role");
988         role.bearer[account] = true;
989     }
990 
991     /**
992      * @dev Remove an account's access to this role.
993      */
994     function remove(Role storage role, address account) internal {
995         require(has(role, account), "Roles: account does not have role");
996         role.bearer[account] = false;
997     }
998 
999     /**
1000      * @dev Check if an account has this role.
1001      * @return bool
1002      */
1003     function has(Role storage role, address account) internal view returns (bool) {
1004         require(account != address(0), "Roles: account is the zero address");
1005         return role.bearer[account];
1006     }
1007 }
1008 
1009 contract MinterRole is Context {
1010     using Roles for Roles.Role;
1011 
1012     event MinterAdded(address indexed account);
1013     event MinterRemoved(address indexed account);
1014 
1015     Roles.Role private _minters;
1016 
1017     constructor () internal {
1018         _addMinter(_msgSender());
1019     }
1020 
1021     modifier onlyMinter() {
1022         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1023         _;
1024     }
1025 
1026     function isMinter(address account) public view returns (bool) {
1027         return _minters.has(account);
1028     }
1029 
1030     function addMinter(address account) public onlyMinter {
1031         _addMinter(account);
1032     }
1033 
1034     function renounceMinter() public {
1035         _removeMinter(_msgSender());
1036     }
1037 
1038     function _addMinter(address account) internal {
1039         _minters.add(account);
1040         emit MinterAdded(account);
1041     }
1042 
1043     function _removeMinter(address account) internal {
1044         _minters.remove(account);
1045         emit MinterRemoved(account);
1046     }
1047 }
1048 
1049 contract ERC20Mintable is ERC20, MinterRole {
1050     /**
1051      * @dev See {ERC20-_mint}.
1052      *
1053      * Requirements:
1054      *
1055      * - the caller must have the {MinterRole}.
1056      */
1057     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1058         _mint(account, amount);
1059         return true;
1060     }
1061 }
1062 
1063 contract ERC20Detailed is IERC20 {
1064     string private _name;
1065     string private _symbol;
1066     uint8 private _decimals;
1067 
1068     /**
1069      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1070      * these values are immutable: they can only be set once during
1071      * construction.
1072      */
1073     constructor (string memory name, string memory symbol, uint8 decimals) public {
1074         _name = name;
1075         _symbol = symbol;
1076         _decimals = decimals;
1077     }
1078 
1079     /**
1080      * @dev Returns the name of the token.
1081      */
1082     function name() public view returns (string memory) {
1083         return _name;
1084     }
1085 
1086     /**
1087      * @dev Returns the symbol of the token, usually a shorter version of the
1088      * name.
1089      */
1090     function symbol() public view returns (string memory) {
1091         return _symbol;
1092     }
1093 
1094     /**
1095      * @dev Returns the number of decimals used to get its user representation.
1096      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1097      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1098      *
1099      * Tokens usually opt for a value of 18, imitating the relationship between
1100      * Ether and Wei.
1101      *
1102      * NOTE: This information is only used for _display_ purposes: it in
1103      * no way affects any of the arithmetic of the contract, including
1104      * {IERC20-balanceOf} and {IERC20-transfer}.
1105      */
1106     function decimals() public view returns (uint8) {
1107         return _decimals;
1108     }
1109 }
1110 
1111 contract ShareToken is ERC20Mintable, ERC20Detailed {
1112 
1113     constructor(string memory _name, string memory _symbol, uint8 _decimals)
1114         ERC20Detailed(_name, _symbol, _decimals)
1115         public
1116     {
1117     }
1118 
1119     function burn(address account, uint256 amount) public onlyMinter returns (bool) {
1120         _burn(account, amount);
1121         return true;
1122     }
1123 }
1124 
1125 library Address {
1126     /**
1127      * @dev Returns true if `account` is a contract.
1128      *
1129      * [IMPORTANT]
1130      * ====
1131      * It is unsafe to assume that an address for which this function returns
1132      * false is an externally-owned account (EOA) and not a contract.
1133      *
1134      * Among others, `isContract` will return false for the following 
1135      * types of addresses:
1136      *
1137      *  - an externally-owned account
1138      *  - a contract in construction
1139      *  - an address where a contract will be created
1140      *  - an address where a contract lived, but was destroyed
1141      * ====
1142      */
1143     function isContract(address account) internal view returns (bool) {
1144         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1145         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1146         // for accounts without code, i.e. `keccak256('')`
1147         bytes32 codehash;
1148         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1149         // solhint-disable-next-line no-inline-assembly
1150         assembly { codehash := extcodehash(account) }
1151         return (codehash != accountHash && codehash != 0x0);
1152     }
1153 
1154     /**
1155      * @dev Converts an `address` into `address payable`. Note that this is
1156      * simply a type cast: the actual underlying value is not changed.
1157      *
1158      * _Available since v2.4.0._
1159      */
1160     function toPayable(address account) internal pure returns (address payable) {
1161         return address(uint160(account));
1162     }
1163 
1164     /**
1165      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1166      * `recipient`, forwarding all available gas and reverting on errors.
1167      *
1168      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1169      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1170      * imposed by `transfer`, making them unable to receive funds via
1171      * `transfer`. {sendValue} removes this limitation.
1172      *
1173      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1174      *
1175      * IMPORTANT: because control is transferred to `recipient`, care must be
1176      * taken to not create reentrancy vulnerabilities. Consider using
1177      * {ReentrancyGuard} or the
1178      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1179      *
1180      * _Available since v2.4.0._
1181      */
1182     function sendValue(address payable recipient, uint256 amount) internal {
1183         require(address(this).balance >= amount, "Address: insufficient balance");
1184 
1185         // solhint-disable-next-line avoid-call-value
1186         (bool success, ) = recipient.call.value(amount)("");
1187         require(success, "Address: unable to send value, recipient may have reverted");
1188     }
1189 }
1190 
1191 interface IGlobalConfig {
1192 
1193     function owner() external view returns (address);
1194 
1195     function isOwner() external view returns (bool);
1196 
1197     function renounceOwnership() external;
1198 
1199     function transferOwnership(address newOwner) external;
1200 
1201     function brokers(address broker) external view returns (bool);
1202     
1203     function pauseControllers(address broker) external view returns (bool);
1204 
1205     function withdrawControllers(address broker) external view returns (bool);
1206 
1207     function addBroker() external;
1208 
1209     function removeBroker() external;
1210 
1211     function isComponent(address component) external view returns (bool);
1212 
1213     function addComponent(address perpetual, address component) external;
1214 
1215     function removeComponent(address perpetual, address component) external;
1216 
1217     function addPauseController(address controller) external;
1218 
1219     function removePauseController(address controller) external;
1220 
1221     function addWithdrawController(address controller) external;
1222 
1223     function removeWithdrawControllers(address controller) external;
1224 }
1225 
1226 contract AMMGovernance {
1227     using LibMathSigned for int256;
1228     using LibMathUnsigned for uint256;
1229 
1230     LibTypes.AMMGovernanceConfig internal governance;
1231     LibTypes.FundingState internal fundingState;
1232 
1233     // auto-set when calling setGovernanceParameter
1234     int256 public emaAlpha2; // 1 - emaAlpha
1235     int256 public emaAlpha2Ln; // ln(emaAlpha2)
1236 
1237     IPerpetual public perpetualProxy;
1238     IPriceFeeder public priceFeeder;
1239     IGlobalConfig public globalConfig;
1240 
1241     event UpdateGovernanceParameter(bytes32 indexed key, int256 value);
1242 
1243     constructor(address _globalConfig) public {
1244         require(_globalConfig != address(0), "invalid global config");
1245         globalConfig = IGlobalConfig(_globalConfig);
1246     }
1247 
1248     modifier onlyOwner() {
1249         require(globalConfig.owner() == msg.sender, "not owner");
1250         _;
1251     }
1252 
1253     modifier onlyAuthorized() {
1254         require(globalConfig.isComponent(msg.sender), "unauthorized caller");
1255         _;
1256     }
1257 
1258     /**
1259      * @dev Set governance parameters.
1260      *
1261      * @param key   Name of parameter.
1262      * @param value Value of parameter.
1263      */
1264     function setGovernanceParameter(bytes32 key, int256 value) public onlyOwner {
1265         if (key == "poolFeeRate") {
1266             governance.poolFeeRate = value.toUint256();
1267         } else if (key == "poolDevFeeRate") {
1268             governance.poolDevFeeRate = value.toUint256();
1269         } else if (key == "emaAlpha") {
1270             require(value > 0, "alpha should be > 0");
1271             require(value <= 10**18, "alpha should be <= 1");
1272             governance.emaAlpha = value;
1273             emaAlpha2 = 10**18 - governance.emaAlpha;
1274             emaAlpha2Ln = emaAlpha2.wln();
1275         } else if (key == "updatePremiumPrize") {
1276             governance.updatePremiumPrize = value.toUint256();
1277         } else if (key == "markPremiumLimit") {
1278             governance.markPremiumLimit = value;
1279         } else if (key == "fundingDampener") {
1280             governance.fundingDampener = value;
1281         } else if (key == "accumulatedFundingPerContract") {
1282             require(perpetualProxy.status() == LibTypes.Status.EMERGENCY, "wrong perpetual status");
1283             fundingState.accumulatedFundingPerContract = value;
1284         } else if (key == "priceFeeder") {
1285             require(Address.isContract(address(value)), "wrong address");
1286             priceFeeder = IPriceFeeder(value);
1287         } else {
1288             revert("key not exists");
1289         }
1290         emit UpdateGovernanceParameter(key, value);
1291     }
1292 
1293     // get governance data structure.
1294     function getGovernance() public view returns (LibTypes.AMMGovernanceConfig memory) {
1295         return governance;
1296     }
1297 }
1298 
1299 contract AMM is AMMGovernance {
1300     using LibMathSigned for int256;
1301     using LibMathUnsigned for uint256;
1302 
1303     int256 private constant FUNDING_PERIOD = 28800; // 8 * 3600;
1304 
1305     // ERC20 token
1306     ShareToken private shareToken;
1307 
1308     event CreateAMM();
1309     event UpdateFundingRate(LibTypes.FundingState fundingState);
1310 
1311     constructor(
1312         address _globalConfig,
1313         address _perpetualProxy,
1314         address _priceFeeder,
1315         address _shareToken
1316     )
1317         public
1318         AMMGovernance(_globalConfig)
1319     {
1320         priceFeeder = IPriceFeeder(_priceFeeder);
1321         perpetualProxy = IPerpetual(_perpetualProxy);
1322         shareToken = ShareToken(_shareToken);
1323 
1324         emit CreateAMM();
1325     }
1326 
1327     /**
1328      * @notice Share token's ERC20 address.
1329      */
1330     function shareTokenAddress() public view returns (address) {
1331         return address(shareToken);
1332     }
1333 
1334     /**
1335      * @notice Index price.
1336      *
1337      * Re-read the oracle price instead of the cached value.
1338      */
1339     function indexPrice() public view returns (uint256 price, uint256 timestamp) {
1340         (price, timestamp) = priceFeeder.price();
1341         require(price != 0, "dangerous index price");
1342     }
1343 
1344     /**
1345      * @notice Pool's position size (y).
1346      */
1347     function positionSize() public view returns (uint256) {
1348         return perpetualProxy.getMarginAccount(tradingAccount()).size;
1349     }
1350 
1351     /**
1352      * @notice FundingState.
1353      *
1354      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1355      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1356      */
1357     function lastFundingState() public view returns (LibTypes.FundingState memory) {
1358         return fundingState;
1359     }
1360 
1361     /**
1362      * @notice AvailableMargin (x).
1363      *
1364      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1365      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1366      */
1367     function lastAvailableMargin() internal view returns (uint256) {
1368         LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
1369         return availableMarginFromPoolAccount(account);
1370     }
1371 
1372     /**
1373      * @notice FairPrice.
1374      *
1375      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1376      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1377      */
1378     function lastFairPrice() internal view returns (uint256) {
1379         LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
1380         return fairPriceFromPoolAccount(account);
1381     }
1382 
1383     /**
1384      * @notice Premium.
1385      *
1386      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1387      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1388      */
1389     function lastPremium() internal view returns (int256) {
1390         LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
1391         return premiumFromPoolAccount(account);
1392     }
1393 
1394     /**
1395      * @notice EMAPremium.
1396      *
1397      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1398      *       on-chain fundingState. current* functions are calculated based on the current timestamp.
1399      */
1400     function lastEMAPremium() internal view returns (int256) {
1401         return fundingState.lastEMAPremium;
1402     }
1403 
1404     /**
1405      * @notice MarkPrice.
1406      *
1407      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1408      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1409      */
1410     function lastMarkPrice() internal view returns (uint256) {
1411         int256 index = fundingState.lastIndexPrice.toInt256();
1412         int256 limit = index.wmul(governance.markPremiumLimit);
1413         int256 p = index.add(lastEMAPremium());
1414         p = p.min(index.add(limit));
1415         p = p.max(index.sub(limit));
1416         return p.max(0).toUint256();
1417     }
1418 
1419     /**
1420      * @notice PremiumRate.
1421      *
1422      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1423      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1424      */
1425     function lastPremiumRate() internal view returns (int256) {
1426         int256 index = fundingState.lastIndexPrice.toInt256();
1427         int256 rate = lastMarkPrice().toInt256();
1428         rate = rate.sub(index).wdiv(index);
1429         return rate;
1430     }
1431 
1432     /**
1433      * @notice FundingRate.
1434      *
1435      * Note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1436      *       the on-chain fundingState. current* functions are calculated based on the current timestamp.
1437      */
1438     function lastFundingRate() public view returns (int256) {
1439         int256 rate = lastPremiumRate();
1440         return rate.max(governance.fundingDampener).add(rate.min(-governance.fundingDampener));
1441     }
1442 
1443     // Public functions
1444 
1445     /**
1446      * @notice FundingState.
1447      *
1448      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1449      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1450      */
1451     function currentFundingState() public returns (LibTypes.FundingState memory) {
1452         funding();
1453         return fundingState;
1454     }
1455 
1456     /**
1457      * @notice AvailableMargin (x).
1458      *
1459      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1460      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1461      */
1462     function currentAvailableMargin() public returns (uint256) {
1463         funding();
1464         return lastAvailableMargin();
1465     }
1466 
1467     /**
1468      * @notice FairPrice.
1469      *
1470      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1471      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1472      */
1473     function currentFairPrice() public returns (uint256) {
1474         funding();
1475         return lastFairPrice();
1476     }
1477 
1478     /**
1479      * @notice Premium.
1480      *
1481      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1482      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1483      */
1484     function currentPremium() public returns (int256) {
1485         funding();
1486         return lastPremium();
1487     }
1488 
1489     /**
1490      * @notice MarkPrice.
1491      *
1492      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1493      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1494      */
1495     function currentMarkPrice() public returns (uint256) {
1496         funding();
1497         return lastMarkPrice();
1498     }
1499 
1500     /**
1501      * @notice PremiumRate.
1502      *
1503      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1504      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1505      */
1506     function currentPremiumRate() public returns (int256) {
1507         funding();
1508         return lastPremiumRate();
1509     }
1510 
1511     /**
1512      * @notice FundingRate.
1513      *
1514      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1515      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1516      */
1517     function currentFundingRate() public returns (int256) {
1518         funding();
1519         return lastFundingRate();
1520     }
1521 
1522     /**
1523      * @notice AccumulatedFundingPerContract.
1524      *
1525      * Note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1526      *       the current timestamp. current* functions are calculated based on the on-chain fundingState.
1527      */
1528     function currentAccumulatedFundingPerContract() public returns (int256) {
1529         funding();
1530         return fundingState.accumulatedFundingPerContract;
1531     }
1532 
1533     /**
1534      * @notice The pool's margin account.
1535      */
1536     function tradingAccount() internal view returns (address) {
1537         return address(perpetualProxy);
1538     }
1539 
1540     /**
1541      * @notice The 1st addLiquidity.
1542      *
1543      * The semantics of this function is almost identical to addLiquidity except that the trading price
1544      * is not determined by fairPrice, but by indexPrice.
1545      *
1546      * Note: buy() and sell() will fail before this function is called.
1547      * @param amount Sell amount. Must be a multiple of lotSize.
1548      */
1549     function createPool(uint256 amount) public {
1550         require(amount > 0, "amount must be greater than zero");
1551         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1552         require(positionSize() == 0, "pool not empty");
1553 
1554         address trader = msg.sender;
1555         uint256 blockTime = getBlockTimestamp();
1556         uint256 newIndexPrice;
1557         uint256 newIndexTimestamp;
1558         (newIndexPrice, newIndexTimestamp) = indexPrice();
1559 
1560         initFunding(newIndexPrice, blockTime);
1561         perpetualProxy.transferCashBalance(trader, tradingAccount(), newIndexPrice.wmul(amount).mul(2));
1562         (uint256 opened, ) = perpetualProxy.tradePosition(
1563             trader,
1564             tradingAccount(),
1565             LibTypes.Side.SHORT,
1566             newIndexPrice,
1567             amount
1568         );
1569         mintShareTokenTo(trader, amount);
1570 
1571         forceFunding(); // x, y changed, so fair price changed. we need funding now
1572         mustSafe(trader, opened);
1573     }
1574 
1575     /**
1576      * @notice Price of buy/long.
1577      *
1578      * @param amount Buy amount.
1579      */
1580     function getBuyPrice(uint256 amount) internal returns (uint256 price) {
1581         uint256 x;
1582         uint256 y;
1583         (x, y) = currentXY();
1584         require(y != 0 && x != 0, "empty pool");
1585         return x.wdiv(y.sub(amount));
1586     }
1587 
1588     /**
1589      * @notice Real implementation of buy/long.
1590      *
1591      * @param trader The trader.
1592      * @param amount Buy amount. Must be a multiple of lotSize.
1593      * @param limitPrice Assert the trading price <= limitPrice.
1594      * @param deadline Assert the trading time <= deadline.
1595      */
1596     function buyFrom(
1597         address trader,
1598         uint256 amount,
1599         uint256 limitPrice,
1600         uint256 deadline
1601     )
1602         private
1603         returns (uint256) {
1604         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1605         require(perpetualProxy.isValidTradingLotSize(amount), "amount must be divisible by tradingLotSize");
1606 
1607         uint256 price = getBuyPrice(amount);
1608         require(limitPrice >= price, "price limited");
1609         require(getBlockTimestamp() <= deadline, "deadline exceeded");
1610         (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.LONG, price, amount);
1611 
1612         uint256 value = price.wmul(amount);
1613         uint256 fee = value.wmul(governance.poolFeeRate);
1614         uint256 devFee = value.wmul(governance.poolDevFeeRate);
1615         address devAddress = perpetualProxy.devAddress();
1616 
1617         perpetualProxy.transferCashBalance(trader, tradingAccount(), fee);
1618         perpetualProxy.transferCashBalance(trader, devAddress, devFee);
1619 
1620         forceFunding(); // x, y changed, so fair price changed. we need funding now
1621         mustSafe(trader, opened);
1622         return opened;
1623     }
1624 
1625     /**
1626      * @notice Buy/long with AMM if the trader comes from the whitelist.
1627      *
1628      * @param trader The trader.
1629      * @param amount Buy amount. Must be a multiple of lotSize.
1630      * @param limitPrice Assert the trading price <= limitPrice.
1631      * @param deadline Assert the trading time <= deadline.
1632      */
1633     function buyFromWhitelisted(
1634         address trader,
1635         uint256 amount,
1636         uint256 limitPrice,
1637         uint256 deadline
1638     )
1639         public
1640         onlyAuthorized
1641         returns (uint256)
1642     {
1643         return buyFrom(trader, amount, limitPrice, deadline);
1644     }
1645 
1646     /**
1647      * @notice Buy/long with AMM.
1648      *
1649      * @param amount Buy amount. Must be a multiple of lotSize.
1650      * @param limitPrice Assert the trading price <= limitPrice.
1651      * @param deadline Assert the trading time <= deadline.
1652      */
1653     function buy(
1654         uint256 amount,
1655         uint256 limitPrice,
1656         uint256 deadline
1657     ) public returns (uint256) {
1658         return buyFrom(msg.sender, amount, limitPrice, deadline);
1659     }
1660 
1661     /**
1662      * @notice Price of sell/short.
1663      *
1664      * @param amount Sell amount.
1665      */
1666     function getSellPrice(uint256 amount) internal returns (uint256 price) {
1667         uint256 x;
1668         uint256 y;
1669         (x, y) = currentXY();
1670         require(y != 0 && x != 0, "empty pool");
1671         return x.wdiv(y.add(amount));
1672     }
1673 
1674     /**
1675      * @notice Real implementation of sell/short.
1676      *
1677      * @param trader The trader.
1678      * @param amount Sell amount. Must be a multiple of lotSize.
1679      * @param limitPrice Assert the trading price >= limitPrice.
1680      * @param deadline Assert the trading time <= deadline.
1681      */
1682     function sellFrom(
1683         address trader,
1684         uint256 amount,
1685         uint256 limitPrice,
1686         uint256 deadline
1687     ) private returns (uint256) {
1688         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1689         require(perpetualProxy.isValidTradingLotSize(amount), "amount must be divisible by tradingLotSize");
1690 
1691         uint256 price = getSellPrice(amount);
1692         require(limitPrice <= price, "price limited");
1693         require(getBlockTimestamp() <= deadline, "deadline exceeded");
1694         (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.SHORT, price, amount);
1695 
1696         uint256 value = price.wmul(amount);
1697         uint256 fee = value.wmul(governance.poolFeeRate);
1698         uint256 devFee = value.wmul(governance.poolDevFeeRate);
1699         address devAddress = perpetualProxy.devAddress();
1700         perpetualProxy.transferCashBalance(trader, tradingAccount(), fee);
1701         perpetualProxy.transferCashBalance(trader, devAddress, devFee);
1702 
1703         forceFunding(); // x, y changed, so fair price changed. we need funding now
1704         mustSafe(trader, opened);
1705         return opened;
1706     }
1707 
1708     /**
1709      * @notice Sell/short with AMM if the trader comes from the whitelist.
1710      *
1711      * @param trader The trader.
1712      * @param amount Sell amount. Must be a multiple of lotSize.
1713      * @param limitPrice Assert the trading price >= limitPrice.
1714      * @param deadline Assert the trading time <= deadline.
1715      */
1716     function sellFromWhitelisted(
1717         address trader,
1718         uint256 amount,
1719         uint256 limitPrice,
1720         uint256 deadline
1721     )
1722         public
1723         onlyAuthorized
1724         returns (uint256)
1725     {
1726         return sellFrom(trader, amount, limitPrice, deadline);
1727     }
1728 
1729     /**
1730      * @notice Sell/short with AMM.
1731      *
1732      * @param amount Sell amount. Must be a multiple of lotSize.
1733      * @param limitPrice Assert the trading price >= limitPrice.
1734      * @param deadline Assert the trading time <= deadline.
1735      */
1736     function sell(
1737         uint256 amount,
1738         uint256 limitPrice,
1739         uint256 deadline
1740     ) public returns (uint256) {
1741         return sellFrom(msg.sender, amount, limitPrice, deadline);
1742     }
1743 
1744     /**
1745      * @notice Move collateral from the current liquidity provider's margin account into AMM and mint the Share token.
1746      *
1747      * After addLiquidity, the liquidity provider will:
1748      * 1. Pay (2 * amount * price) collateral.
1749      * 2. Get Share tokens to prove that there're some Long positions and collaterals in AMM that belongs to current liquidity provider.
1750      * 3. Get some Short positions.
1751      *
1752      * The number of short positions obtained is obviously the same as the number of long positions obtained in the pool.
1753      *
1754      * @param amount Sell amount. Must be a multiple of lotSize.
1755      */
1756     function addLiquidity(uint256 amount) public {
1757         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1758 
1759         uint256 oldAvailableMargin;
1760         uint256 oldPoolPositionSize;
1761         (oldAvailableMargin, oldPoolPositionSize) = currentXY();
1762         require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");
1763 
1764         address trader = msg.sender;
1765         uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);
1766 
1767         uint256 collateralAmount = amount.wmul(price).mul(2);
1768         perpetualProxy.transferCashBalance(trader, tradingAccount(), collateralAmount);
1769         (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.SHORT, price, amount);
1770 
1771         mintShareTokenTo(trader, shareToken.totalSupply().wmul(amount).wdiv(oldPoolPositionSize));
1772 
1773         forceFunding(); // x, y changed, so fair price changed. we need funding now
1774         mustSafe(trader, opened);
1775     }
1776 
1777     /**
1778      * @notice Burn Share tokens to remove the collateral attributed to the current liquidity provider
1779      *         from AMM into the liquidity provider's margin account.
1780      *
1781      * @param shareAmount The number of share tokens about to burn. The real trading amount will be
1782      *        automatically aligned to lotSize.
1783      */
1784     function removeLiquidity(uint256 shareAmount) public {
1785         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1786 
1787         address trader = msg.sender;
1788         uint256 oldAvailableMargin;
1789         uint256 oldPoolPositionSize;
1790         (oldAvailableMargin, oldPoolPositionSize) = currentXY();
1791         require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");
1792         require(shareToken.balanceOf(msg.sender) >= shareAmount, "shareBalance too low");
1793         uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);
1794         uint256 amount = shareAmount.wmul(oldPoolPositionSize).wdiv(shareToken.totalSupply());
1795         // align to lotSize
1796         uint256 lotSize = perpetualProxy.getGovernance().lotSize;
1797         amount = amount.sub(amount.mod(lotSize));
1798 
1799         perpetualProxy.transferCashBalance(tradingAccount(), trader, price.wmul(amount).mul(2));
1800         burnShareTokenFrom(trader, shareAmount);
1801         (uint256 opened, ) = perpetualProxy.tradePosition(trader, tradingAccount(), LibTypes.Side.LONG, price, amount);
1802 
1803         forceFunding(); // x, y changed, so fair price changed. we need funding now
1804         mustSafe(trader, opened);
1805     }
1806 
1807     /**
1808      * @notice In SETTLED status, burn Share tokens to remove the collateral attributed to the current liquidity provider
1809      *         from AMM to the liquidity provider's margin account.
1810      *
1811      * Also call perpetual.settle() to finally withdraw all collaterals after calling this function.
1812      */
1813     function settleShare() public {
1814         require(perpetualProxy.status() == LibTypes.Status.SETTLED, "wrong perpetual status");
1815 
1816         address trader = msg.sender;
1817         LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
1818         uint256 total = availableMarginFromPoolAccount(account);
1819         uint256 shareAmount = shareToken.balanceOf(trader);
1820         uint256 balance = shareAmount.wmul(total).wdiv(shareToken.totalSupply());
1821         perpetualProxy.transferCashBalance(tradingAccount(), trader, balance);
1822         burnShareTokenFrom(trader, shareAmount);
1823     }
1824 
1825     /**
1826      * @notice This is a composite function of perp.deposit + amm.buy.
1827      *
1828      * Composite functions accept amount = 0.
1829      *
1830      * @param depositAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
1831      * @param tradeAmount Buy amount.
1832      * @param limitPrice Assert the trading price <= limitPrice.
1833      * @param deadline Assert the trading time <= deadline.
1834      */
1835     function depositAndBuy(
1836         uint256 depositAmount,
1837         uint256 tradeAmount,
1838         uint256 limitPrice,
1839         uint256 deadline
1840     )
1841         public
1842         payable
1843     {
1844         if (depositAmount > 0) {
1845             perpetualProxy.depositFor.value(msg.value)(msg.sender, depositAmount);
1846         }
1847         if (tradeAmount > 0) {
1848             buy(tradeAmount, limitPrice, deadline);
1849         }
1850     }
1851 
1852     /**
1853      * @notice This is a composite function of perp.deposit + amm.sell.
1854      *
1855      * Composite functions accept amount = 0.
1856      *
1857      * @param depositAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
1858      * @param tradeAmount Sell amount.
1859      * @param limitPrice Assert the trading price >= limitPrice.
1860      * @param deadline Assert the trading time <= deadline.
1861      */
1862     function depositAndSell(
1863         uint256 depositAmount,
1864         uint256 tradeAmount,
1865         uint256 limitPrice,
1866         uint256 deadline
1867     )
1868         public
1869         payable
1870     {
1871         if (depositAmount > 0) {
1872             perpetualProxy.depositFor.value(msg.value)(msg.sender, depositAmount);
1873         }
1874         if (tradeAmount > 0) {
1875             sell(tradeAmount, limitPrice, deadline);
1876         }
1877     }
1878 
1879     /**
1880      * @notice This is a composite function of amm.buy + perp.withdraw.
1881      *
1882      * Composite functions accept amount = 0.
1883      *
1884      * @param tradeAmount Buy amount.
1885      * @param limitPrice Assert the trading price <= limitPrice.
1886      * @param deadline Assert the trading time <= deadline.
1887      * @param withdrawAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
1888      */
1889     function buyAndWithdraw(
1890         uint256 tradeAmount,
1891         uint256 limitPrice,
1892         uint256 deadline,
1893         uint256 withdrawAmount
1894     ) public {
1895         if (tradeAmount > 0) {
1896             buy(tradeAmount, limitPrice, deadline);
1897         }
1898         if (withdrawAmount > 0) {
1899             perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
1900         }
1901     }
1902 
1903     /**
1904      * @notice This is a composite function of amm.sell + perp.withdraw.
1905      *
1906      * Composite functions accept amount = 0.
1907      *
1908      * @param tradeAmount Sell amount.
1909      * @param limitPrice Assert the trading price >= limitPrice.
1910      * @param deadline Assert the trading time <= deadline.
1911      * @param withdrawAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
1912      */
1913     function sellAndWithdraw(
1914         uint256 tradeAmount,
1915         uint256 limitPrice,
1916         uint256 deadline,
1917         uint256 withdrawAmount
1918     ) public {
1919         if (tradeAmount > 0) {
1920             sell(tradeAmount, limitPrice, deadline);
1921         }
1922         if (withdrawAmount > 0) {
1923             perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
1924         }
1925     }
1926 
1927     /**
1928      * @notice This is a composite function of perp.deposit + amm.addLiquidity.
1929      *
1930      * Composite functions accept amount = 0.
1931      *
1932      * After depositAndAddLiquidity, the liquidity provider will:
1933      * 1. Deposit depositAmount collateral.
1934      * 2. Pay (2 * amount * price) collateral.
1935      * 3. Get Share tokens to prove that there're some Long positions and collaterals in AMM that belongs to current liquidity provider.
1936      * 4. Get some Short positions.
1937      *
1938      * The number of short positions obtained is obviously the same as the number of long positions obtained in the pool.
1939      *
1940      * @param depositAmount The collateral amount. Note: The actual token.decimals should be filled in and not necessarily 18.
1941      * @param amount Sell amount, pay (2 * amount * price) collateral.
1942      */
1943     function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) public payable {
1944         if (depositAmount > 0) {
1945             perpetualProxy.depositFor.value(msg.value)(msg.sender, depositAmount);
1946         }
1947         if (amount > 0) {
1948             addLiquidity(amount);
1949         }
1950     }
1951 
1952     /**
1953      * @notice Any ETH address can call this function to update the index price of this AMM and get some prize.
1954      */
1955     function updateIndex() public {
1956         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1957         uint256 oldIndexPrice = fundingState.lastIndexPrice;
1958         forceFunding();
1959         address devAddress = perpetualProxy.devAddress();
1960         if (oldIndexPrice != fundingState.lastIndexPrice) {
1961             perpetualProxy.transferCashBalance(devAddress, msg.sender, governance.updatePremiumPrize);
1962             require(perpetualProxy.isSafe(devAddress), "dev unsafe");
1963         }
1964     }
1965 
1966     // Internal helpers
1967 
1968     /**
1969      * @notice In order to mock the block.timestamp
1970      */
1971     function getBlockTimestamp() internal view returns (uint256) {
1972         // solium-disable-next-line security/no-block-members
1973         return block.timestamp;
1974     }
1975 
1976     /**
1977      * @notice a gas-optimized version of currentAvailableMargin() + positionSize(). almost all formulas require these two
1978      */
1979     function currentXY() internal returns (uint256 x, uint256 y) {
1980         funding();
1981         LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
1982         x = availableMarginFromPoolAccount(account);
1983         y = account.size;
1984     }
1985 
1986     /**
1987      * @notice a gas-optimized version of lastAvailableMargin()
1988      */
1989     function availableMarginFromPoolAccount(LibTypes.MarginAccount memory account) internal view returns (uint256) {
1990         int256 available = account.cashBalance;
1991         int256 socialLossPerContract = perpetualProxy.socialLossPerContract(account.side);
1992         available = available.sub(account.entryValue.toInt256());
1993         available = available.sub(socialLossPerContract.wmul(account.size.toInt256()).sub(account.entrySocialLoss));
1994         available = available.sub(
1995             fundingState.accumulatedFundingPerContract.wmul(account.size.toInt256()).sub(account.entryFundingLoss)
1996         );
1997         return available.max(0).toUint256();
1998     }
1999 
2000     /**
2001      * @notice a gas-optimized version of lastFairPrice
2002      */
2003     function fairPriceFromPoolAccount(LibTypes.MarginAccount memory account) internal view returns (uint256) {
2004         uint256 y = account.size;
2005         require(y > 0, "funding initialization required");
2006         uint256 x = availableMarginFromPoolAccount(account);
2007         return x.wdiv(y);
2008     }
2009 
2010     /**
2011      * @notice a gas-optimized version of lastPremium
2012      */
2013     function premiumFromPoolAccount(LibTypes.MarginAccount memory account) internal view returns (int256) {
2014         int256 p = fairPriceFromPoolAccount(account).toInt256();
2015         p = p.sub(fundingState.lastIndexPrice.toInt256());
2016         return p;
2017     }
2018 
2019     /**
2020      * @notice Assert that the given trader is safe.
2021      *
2022      * A trader must at least MM-safe. If the trader is opening positions, it also needs to be IM-safe.
2023      *
2024      * @param trader The trader.
2025      * @param opened Non zero if the trader is opening positions.
2026      */
2027     function mustSafe(address trader, uint256 opened) internal {
2028         // perpetual.markPrice is a little different from ours
2029         uint256 perpetualMarkPrice = perpetualProxy.markPrice();
2030         if (opened > 0) {
2031             require(perpetualProxy.isIMSafeWithPrice(trader, perpetualMarkPrice), "im unsafe");
2032         }
2033         require(perpetualProxy.isSafeWithPrice(trader, perpetualMarkPrice), "sender unsafe");
2034         require(perpetualProxy.isSafeWithPrice(tradingAccount(), perpetualMarkPrice), "amm unsafe");
2035     }
2036 
2037     /**
2038      * @notice Mint Share token to a given trader.
2039      *
2040      * @param trader The trader.
2041      * @param amount Tokens.
2042      */
2043     function mintShareTokenTo(address trader, uint256 amount) internal {
2044         require(shareToken.mint(trader, amount), "mint failed");
2045     }
2046 
2047     /**
2048      * @notice Burn Share token from a given trader.
2049      * @param trader The trader.
2050      * @param amount Tokens.
2051      */
2052     function burnShareTokenFrom(address trader, uint256 amount) internal {
2053         require(shareToken.burn(trader, amount), "burn failed");
2054     }
2055 
2056     /**
2057      * @notice Init the fundingState. This function should be called before a funding().
2058      *
2059      * @param newIndexPrice Index price.
2060      * @param blockTime Use this timestamp instead of the time that the index price is generated, because this is the first initialization.
2061      */
2062     function initFunding(uint256 newIndexPrice, uint256 blockTime) private {
2063         require(fundingState.lastFundingTime == 0, "already initialized");
2064         fundingState.lastFundingTime = blockTime;
2065         fundingState.lastIndexPrice = newIndexPrice;
2066         fundingState.lastPremium = 0;
2067         fundingState.lastEMAPremium = 0;
2068     }
2069 
2070     /**
2071      * @notice current* functions need a funding() before return our states.
2072      *
2073      * Note: Will skip funding() other than NORMAL
2074      *
2075      * There are serveral conditions for change the funding state:
2076      * Condition 1: time.
2077      * Condition 2: indexPrice.
2078      * Condition 3: fairPrice. This condition is not covered in this function. We hand over to forceFunding.
2079      */
2080     function funding() internal {
2081         if (perpetualProxy.status() != LibTypes.Status.NORMAL) {
2082             return;
2083         }
2084         uint256 blockTime = getBlockTimestamp();
2085         uint256 newIndexPrice;
2086         uint256 newIndexTimestamp;
2087         (newIndexPrice, newIndexTimestamp) = indexPrice();
2088         if (
2089             blockTime != fundingState.lastFundingTime || // condition 1
2090             newIndexPrice != fundingState.lastIndexPrice || // condition 2, especially when updateIndex and buy/sell are in the same block
2091             newIndexTimestamp > fundingState.lastFundingTime // condition 2
2092         ) {
2093             forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
2094         }
2095     }
2096 
2097     /**
2098      * @notice Update fundingState without checking whether the funding condition changes.
2099      *
2100      * This function also splits the funding process into 2 parts:
2101      * 1. funding from [lastFundingTime, lastIndexTimestamp)
2102      * 2. funding from [lastIndexTimestamp, blockTime)
2103      *
2104      */
2105     function forceFunding() internal {
2106         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
2107         uint256 blockTime = getBlockTimestamp();
2108         uint256 newIndexPrice;
2109         uint256 newIndexTimestamp;
2110         (newIndexPrice, newIndexTimestamp) = indexPrice();
2111         forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
2112     }
2113 
2114     /**
2115      * @notice Update fundingState without checking whether the funding condition changes.
2116      *
2117      * This function also splits the funding process into 2 parts:
2118      * 1. funding from [lastFundingTime, lastIndexTimestamp)
2119      * 2. funding from [lastIndexTimestamp, blockTime)
2120      *
2121      * @param blockTime The real end time.
2122      * @param newIndexPrice The latest index price.
2123      * @param newIndexTimestamp The timestamp of the latest index.
2124      */
2125     function forceFunding(uint256 blockTime, uint256 newIndexPrice, uint256 newIndexTimestamp) private {
2126         if (fundingState.lastFundingTime == 0) {
2127             // funding initialization required. but in this case, it's safe to just do nothing and return
2128             return;
2129         }
2130         LibTypes.MarginAccount memory account = perpetualProxy.getMarginAccount(tradingAccount());
2131         if (account.size == 0) {
2132             // empty pool. it's safe to just do nothing and return
2133             return;
2134         }
2135 
2136         if (newIndexTimestamp > fundingState.lastFundingTime) {
2137             // the 1st update
2138             nextStateWithTimespan(account, newIndexPrice, newIndexTimestamp);
2139         }
2140         // the 2nd update;
2141         nextStateWithTimespan(account, newIndexPrice, blockTime);
2142 
2143         emit UpdateFundingRate(fundingState);
2144     }
2145 
2146     /**
2147      * @notice Update fundingState from the lastFundingTime to the given time.
2148      *
2149      * This function also adds Acc / (8*3600) into accumulatedFundingPerContract, where Acc is accumulated
2150      * funding payment per position since lastFundingTime
2151      *
2152      * @param account The pool account.
2153      * @param newIndexPrice New index price.
2154      * @param endTimestamp The given end time.
2155      */
2156     function nextStateWithTimespan(
2157         LibTypes.MarginAccount memory account,
2158         uint256 newIndexPrice,
2159         uint256 endTimestamp
2160     ) private {
2161         require(fundingState.lastFundingTime != 0, "funding initialization required");
2162         require(endTimestamp >= fundingState.lastFundingTime, "time steps (n) must be positive");
2163 
2164         // update ema
2165         if (fundingState.lastFundingTime != endTimestamp) {
2166             int256 timeDelta = endTimestamp.sub(fundingState.lastFundingTime).toInt256();
2167             int256 acc;
2168             (fundingState.lastEMAPremium, acc) = getAccumulatedFunding(
2169                 timeDelta,
2170                 fundingState.lastEMAPremium,
2171                 fundingState.lastPremium,
2172                 fundingState.lastIndexPrice.toInt256() // ema is according to the old index
2173             );
2174             fundingState.accumulatedFundingPerContract = fundingState.accumulatedFundingPerContract.add(
2175                 acc.div(FUNDING_PERIOD)
2176             );
2177             fundingState.lastFundingTime = endTimestamp;
2178         }
2179 
2180         // always update
2181         fundingState.lastIndexPrice = newIndexPrice; // should update before premium()
2182         fundingState.lastPremium = premiumFromPoolAccount(account);
2183     }
2184 
2185     /**
2186      * @notice Solve t in emaPremium == y equation
2187      *
2188      * @param y Required function output.
2189      * @param v0 LastEMAPremium.
2190      * @param _lastPremium LastPremium.
2191      */
2192     function timeOnFundingCurve(
2193         int256 y,
2194         int256 v0,
2195         int256 _lastPremium
2196     )
2197         internal
2198         view
2199         returns (
2200             int256 t // normal int, not WAD
2201         )
2202     {
2203         require(y != _lastPremium, "no solution 1 on funding curve");
2204         t = y.sub(_lastPremium);
2205         t = t.wdiv(v0.sub(_lastPremium));
2206         require(t > 0, "no solution 2 on funding curve");
2207         require(t < LibMathSigned.WAD(), "no solution 3 on funding curve");
2208         t = t.wln();
2209         t = t.wdiv(emaAlpha2Ln);
2210         t = t.ceil(LibMathSigned.WAD()) / LibMathSigned.WAD();
2211     }
2212 
2213     /**
2214      * @notice Sum emaPremium curve between [x, y)
2215      *
2216      * @param x Begin time. normal int, not WAD.
2217      * @param y End time. normal int, not WAD.
2218      * @param v0 LastEMAPremium.
2219      * @param _lastPremium LastPremium.
2220      */
2221     function integrateOnFundingCurve(
2222         int256 x,
2223         int256 y,
2224         int256 v0,
2225         int256 _lastPremium
2226     ) internal view returns (int256 r) {
2227         require(x <= y, "integrate reversed");
2228         r = v0.sub(_lastPremium);
2229         r = r.wmul(emaAlpha2.wpowi(x).sub(emaAlpha2.wpowi(y)));
2230         r = r.wdiv(governance.emaAlpha);
2231         r = r.add(_lastPremium.mul(y.sub(x)));
2232     }
2233 
2234    /**
2235      * @notice The intermediate variables required by getAccumulatedFunding. This is only used to move stack
2236      *         variables to storage variables.
2237      */
2238     struct AccumulatedFundingCalculator {
2239         int256 vLimit;
2240         int256 vDampener;
2241         int256 t1; // normal int, not WAD
2242         int256 t2; // normal int, not WAD
2243         int256 t3; // normal int, not WAD
2244         int256 t4; // normal int, not WAD
2245     }
2246 
2247     /**
2248      * @notice Calculate the `Acc`. Sigma the funding rate curve while considering the limit and dampener. There are
2249      *         4 boundary points on the curve (-GovMarkPremiumLimit, -GovFundingDampener, +GovFundingDampener, +GovMarkPremiumLimit)
2250      *         which segment the curve into 5 parts, so that the calculation can be arranged into 5 * 5 = 25 cases.
2251      *         In order to reduce the amount of calculation, the code is expanded into 25 branches.
2252      *
2253      * @param n Time span. normal int, not WAD.
2254      * @param v0 LastEMAPremium.
2255      * @param _lastPremium LastPremium.
2256      * @param _lastIndexPrice LastIndexPrice.
2257      */
2258     function getAccumulatedFunding(
2259         int256 n,
2260         int256 v0,
2261         int256 _lastPremium,
2262         int256 _lastIndexPrice
2263     )
2264         internal
2265         view
2266         returns (
2267             int256 vt, // new LastEMAPremium
2268             int256 acc
2269         )
2270     {
2271         require(n > 0, "we can't go back in time");
2272         AccumulatedFundingCalculator memory ctx;
2273         vt = v0.sub(_lastPremium);
2274         vt = vt.wmul(emaAlpha2.wpowi(n));
2275         vt = vt.add(_lastPremium);
2276         ctx.vLimit = governance.markPremiumLimit.wmul(_lastIndexPrice);
2277         ctx.vDampener = governance.fundingDampener.wmul(_lastIndexPrice);
2278         if (v0 <= -ctx.vLimit) {
2279             // part A
2280             if (vt <= -ctx.vLimit) {
2281                 acc = (-ctx.vLimit).add(ctx.vDampener).mul(n);
2282             } else if (vt <= -ctx.vDampener) {
2283                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2284                 acc = (-ctx.vLimit).mul(ctx.t1);
2285                 acc = acc.add(integrateOnFundingCurve(ctx.t1, n, v0, _lastPremium));
2286                 acc = acc.add(ctx.vDampener.mul(n));
2287             } else if (vt <= ctx.vDampener) {
2288                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2289                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2290                 acc = (-ctx.vLimit).mul(ctx.t1);
2291                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2292                 acc = acc.add(ctx.vDampener.mul(ctx.t2));
2293             } else if (vt <= ctx.vLimit) {
2294                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2295                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2296                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2297                 acc = (-ctx.vLimit).mul(ctx.t1);
2298                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2299                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
2300                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
2301             } else {
2302                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2303                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2304                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2305                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2306                 acc = (-ctx.vLimit).mul(ctx.t1);
2307                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2308                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
2309                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
2310                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
2311             }
2312         } else if (v0 <= -ctx.vDampener) {
2313             // part B
2314             if (vt <= -ctx.vLimit) {
2315                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2316                 acc = integrateOnFundingCurve(0, ctx.t4, v0, _lastPremium);
2317                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
2318                 acc = acc.add(ctx.vDampener.mul(n));
2319             } else if (vt <= -ctx.vDampener) {
2320                 acc = integrateOnFundingCurve(0, n, v0, _lastPremium);
2321                 acc = acc.add(ctx.vDampener.mul(n));
2322             } else if (vt <= ctx.vDampener) {
2323                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2324                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2325                 acc = acc.add(ctx.vDampener.mul(ctx.t2));
2326             } else if (vt <= ctx.vLimit) {
2327                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2328                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2329                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2330                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
2331                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
2332             } else {
2333                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2334                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2335                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2336                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2337                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
2338                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
2339                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
2340             }
2341         } else if (v0 <= ctx.vDampener) {
2342             // part C
2343             if (vt <= -ctx.vLimit) {
2344                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2345                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2346                 acc = integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium);
2347                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
2348                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3)));
2349             } else if (vt <= -ctx.vDampener) {
2350                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2351                 acc = integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium);
2352                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3)));
2353             } else if (vt <= ctx.vDampener) {
2354                 acc = 0;
2355             } else if (vt <= ctx.vLimit) {
2356                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2357                 acc = integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium);
2358                 acc = acc.sub(ctx.vDampener.mul(n.sub(ctx.t3)));
2359             } else {
2360                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2361                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2362                 acc = integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium);
2363                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
2364                 acc = acc.sub(ctx.vDampener.mul(n.sub(ctx.t3)));
2365             }
2366         } else if (v0 <= ctx.vLimit) {
2367             // part D
2368             if (vt <= -ctx.vLimit) {
2369                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2370                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2371                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2372                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2373                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
2374                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
2375                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2376             } else if (vt <= -ctx.vDampener) {
2377                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2378                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2379                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2380                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
2381                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2382             } else if (vt <= ctx.vDampener) {
2383                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2384                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2385                 acc = acc.sub(ctx.vDampener.mul(ctx.t2));
2386             } else if (vt <= ctx.vLimit) {
2387                 acc = integrateOnFundingCurve(0, n, v0, _lastPremium);
2388                 acc = acc.sub(ctx.vDampener.mul(n));
2389             } else {
2390                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2391                 acc = integrateOnFundingCurve(0, ctx.t4, v0, _lastPremium);
2392                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
2393                 acc = acc.sub(ctx.vDampener.mul(n));
2394             }
2395         } else {
2396             // part E
2397             if (vt <= -ctx.vLimit) {
2398                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2399                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2400                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2401                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2402                 acc = ctx.vLimit.mul(ctx.t1);
2403                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2404                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
2405                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
2406                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2407             } else if (vt <= -ctx.vDampener) {
2408                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2409                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2410                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2411                 acc = ctx.vLimit.mul(ctx.t1);
2412                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2413                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
2414                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2415             } else if (vt <= ctx.vDampener) {
2416                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2417                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2418                 acc = ctx.vLimit.mul(ctx.t1);
2419                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2420                 acc = acc.add(ctx.vDampener.mul(-ctx.t2));
2421             } else if (vt <= ctx.vLimit) {
2422                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2423                 acc = ctx.vLimit.mul(ctx.t1);
2424                 acc = acc.add(integrateOnFundingCurve(ctx.t1, n, v0, _lastPremium));
2425                 acc = acc.sub(ctx.vDampener.mul(n));
2426             } else {
2427                 acc = ctx.vLimit.sub(ctx.vDampener).mul(n);
2428             }
2429         }
2430     } // getAccumulatedFunding
2431 }