1 pragma solidity ^0.5.2;
2 pragma experimental ABIEncoderV2;
3 
4 
5 library LibMathSigned {
6     int256 private constant _WAD = 10**18;
7     int256 private constant _INT256_MIN = -2**255;
8 
9     function WAD() internal pure returns (int256) {
10         return _WAD;
11     }
12 
13     // additive inverse
14     function neg(int256 a) internal pure returns (int256) {
15         return sub(int256(0), a);
16     }
17 
18     /**
19      * @dev wmultiplies two signed integers, reverts on overflow.
20      */
21     function mul(int256 a, int256 b) internal pure returns (int256) {
22         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
23         // benefit is lost if 'b' is also tested.
24         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
25         if (a == 0) {
26             return 0;
27         }
28         require(!(a == -1 && b == _INT256_MIN), "wmultiplication overflow");
29 
30         int256 c = a * b;
31         require(c / a == b, "wmultiplication overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Integer wdivision of two signed integers truncating the quotient, reverts on wdivision by zero.
38      */
39     function div(int256 a, int256 b) internal pure returns (int256) {
40         require(b != 0, "wdivision by zero");
41         require(!(b == -1 && a == _INT256_MIN), "wdivision overflow");
42 
43         int256 c = a / b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Subtracts two signed integers, reverts on overflow.
50      */
51     function sub(int256 a, int256 b) internal pure returns (int256) {
52         int256 c = a - b;
53         require((b >= 0 && c <= a) || (b < 0 && c > a), "subtraction overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Adds two signed integers, reverts on overflow.
60      */
61     function add(int256 a, int256 b) internal pure returns (int256) {
62         int256 c = a + b;
63         require((b >= 0 && c >= a) || (b < 0 && c < a), "addition overflow");
64 
65         return c;
66     }
67 
68     function wmul(int256 x, int256 y) internal pure returns (int256 z) {
69         z = roundHalfUp(mul(x, y), _WAD) / _WAD;
70     }
71 
72     // solium-disable-next-line security/no-assign-params
73     function wdiv(int256 x, int256 y) internal pure returns (int256 z) {
74         if (y < 0) {
75             y = -y;
76             x = -x;
77         }
78         z = roundHalfUp(mul(x, _WAD), y) / y;
79     }
80 
81     // solium-disable-next-line security/no-assign-params
82     function wfrac(int256 x, int256 y, int256 z) internal pure returns (int256 r) {
83         int256 t = mul(x, y);
84         if (z < 0) {
85             z = -z;
86             t = -t;
87         }
88         r = roundHalfUp(t, z) / z;
89     }
90 
91     function min(int256 x, int256 y) internal pure returns (int256 z) {
92         return x <= y ? x : y;
93     }
94 
95     function max(int256 x, int256 y) internal pure returns (int256 z) {
96         return x >= y ? x : y;
97     }
98 
99     // quotient and remainder
100     function pwdiv(int256 x, int256 y) internal pure returns (int256 z, int256 m) {
101         z = wdiv(x, y);
102         m = sub(wmul(y, z), x);
103     }
104 
105     function toUint256(int256 x) internal pure returns (uint256) {
106         require(x >= 0, "int overflow");
107         return uint256(x);
108     }
109 
110     // x ^ n
111     // NOTE: n is a normal integer, do not shift 18 decimals
112     // solium-disable-next-line security/no-assign-params
113     function wpowi(int256 x, int256 n) internal pure returns (int256 z) {
114         z = n % 2 != 0 ? x : _WAD;
115 
116         for (n /= 2; n != 0; n /= 2) {
117             x = wmul(x, x);
118 
119             if (n % 2 != 0) {
120                 z = wmul(z, x);
121             }
122         }
123     }
124 
125     uint8 internal constant fixed_digits = 18;
126     int256 internal constant fixed_1 = 1000000000000000000;
127     int256 internal constant fixed_e = 2718281828459045235;
128     uint8 internal constant longer_digits = 36;
129     int256 internal constant longer_fixed_log_e_1_5 = 405465108108164381978013115464349137;
130     int256 internal constant longer_fixed_1 = 1000000000000000000000000000000000000;
131     int256 internal constant longer_fixed_log_e_10 = 2302585092994045684017991454684364208;
132 
133     // ROUND_HALF_UP rule helper. 0.5 ≈ 1, 0.4 ≈ 0, -0.5 ≈ -1, -0.4 ≈ 0
134     function roundHalfUp(int256 x, int256 y) internal pure returns (int256) {
135         require(y > 0, "roundHalfUp only supports y > 0");
136         if (x >= 0) {
137             return add(x, y / 2);
138         }
139         return sub(x, y / 2);
140     }
141 
142     // function roundFloor(int256 x, int256 y) internal pure returns (int256) {
143     //     require(y > 0, "roundHalfUp only supports y > 0");
144     //     if (x >= 0 || x % _WAD == 0) {
145     //         return x;
146     //     }
147     //     return sub(x, y);
148     // }
149 
150     // function roundCeil(int256 x, int256 y) internal pure returns (int256) {
151     //     require(y > 0, "roundHalfUp only supports y > 0");
152     //     if (x <= 0 || x % _WAD == 0) {
153     //         return x;
154     //     }
155     //     return add(x, y);
156     // }
157 
158     // Log(e, x)
159     // solium-disable-next-line security/no-assign-params
160     function wln(int256 x) internal pure returns (int256) {
161         require(x > 0, "logE of negative number");
162         require(x <= 10000000000000000000000000000000000000000, "logE only accepts v <= 1e22 * 1e18"); // in order to prevent using safe-math
163         int256 r = 0;
164         uint8 extra_digits = longer_digits - fixed_digits;
165         int256 t = int256(uint256(10)**uint256(extra_digits));
166 
167         while (x <= fixed_1 / 10) {
168             x = x * 10;
169             r -= longer_fixed_log_e_10;
170         }
171         while (x >= 10 * fixed_1) {
172             x = x / 10;
173             r += longer_fixed_log_e_10;
174         }
175         while (x < fixed_1) {
176             x = wmul(x, fixed_e);
177             r -= longer_fixed_1;
178         }
179         while (x > fixed_e) {
180             x = wdiv(x, fixed_e);
181             r += longer_fixed_1;
182         }
183         if (x == fixed_1) {
184             return roundHalfUp(r, t) / t;
185         }
186         if (x == fixed_e) {
187             return fixed_1 + roundHalfUp(r, t) / t;
188         }
189         x *= t;
190 
191         //               x^2   x^3   x^4
192         // Ln(1+x) = x - --- + --- - --- + ...
193         //                2     3     4
194         // when -1 < x < 1, O(x^n) < ε => when n = 36, 0 < x < 0.316
195         //
196         //                    2    x           2    x          2    x
197         // Ln(a+x) = Ln(a) + ---(------)^1  + ---(------)^3 + ---(------)^5 + ...
198         //                    1   2a+x         3   2a+x        5   2a+x
199         //
200         // Let x = v - a
201         //                  2   v-a         2   v-a        2   v-a
202         // Ln(v) = Ln(a) + ---(-----)^1  + ---(-----)^3 + ---(-----)^5 + ...
203         //                  1   v+a         3   v+a        5   v+a
204         // when n = 36, 1 < v < 3.423
205         r = r + longer_fixed_log_e_1_5;
206         int256 a1_5 = (3 * longer_fixed_1) / 2;
207         int256 m = (longer_fixed_1 * (x - a1_5)) / (x + a1_5);
208         r = r + 2 * m;
209         int256 m2 = (m * m) / longer_fixed_1;
210         uint8 i = 3;
211         while (true) {
212             m = (m * m2) / longer_fixed_1;
213             r = r + (2 * m) / int256(i);
214             i += 2;
215             if (i >= 3 + 2 * fixed_digits) {
216                 break;
217             }
218         }
219         return roundHalfUp(r, t) / t;
220     }
221 
222     // Log(b, x)
223     function logBase(int256 base, int256 x) internal pure returns (int256) {
224         return wdiv(wln(x), wln(base));
225     }
226 
227     function ceil(int256 x, int256 m) internal pure returns (int256) {
228         require(x >= 0, "ceil need x >= 0");
229         require(m > 0, "ceil need m > 0");
230         return (sub(add(x, m), 1) / m) * m;
231     }
232 }
233 
234 library LibMathUnsigned {
235     uint256 private constant _WAD = 10**18;
236     uint256 private constant _UINT256_MAX = 2**255 - 1;
237 
238     function WAD() internal pure returns (uint256) {
239         return _WAD;
240     }
241 
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a + b;
244         require(c >= a, "Unaddition overflow");
245 
246         return c;
247     }
248 
249     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
250         require(b <= a, "Unsubtraction overflow");
251         uint256 c = a - b;
252 
253         return c;
254     }
255 
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "Unmultiplication overflow");
266 
267         return c;
268     }
269 
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Solidity only automatically asserts when dividing by 0
272         require(b > 0, "Undivision by zero");
273         uint256 c = a / b;
274         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276         return c;
277     }
278 
279     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
280         z = add(mul(x, y), _WAD / 2) / _WAD;
281     }
282 
283     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
284         z = add(mul(x, _WAD), y / 2) / y;
285     }
286 
287     function wfrac(uint256 x, uint256 y, uint256 z) internal pure returns (uint256 r) {
288         r = mul(x, y) / z;
289     }
290 
291     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
292         return x <= y ? x : y;
293     }
294 
295     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
296         return x >= y ? x : y;
297     }
298 
299     // quotient and remainder
300     function pwdiv(uint256 x, uint256 y) internal pure returns (uint256 z, uint256 m) {
301         z = wdiv(x, y);
302         m = sub(wmul(y, z), x);
303     }
304 
305     function toInt256(uint256 x) internal pure returns (int256) {
306         require(x <= _UINT256_MAX, "uint256 overflow");
307         return int256(x);
308     }
309 
310     function mod(uint256 x, uint256 m) internal pure returns (uint256) {
311         require(m != 0, "mod by zero");
312         return x % m;
313     }
314 
315     function ceil(uint256 x, uint256 m) internal pure returns (uint256) {
316         require(m > 0, "ceil need m > 0");
317         return (sub(add(x, m), 1) / m) * m;
318     }
319 }
320 
321 library LibEIP712 {
322     string internal constant DOMAIN_NAME = "Mai Protocol";
323 
324     struct OrderSignature {
325         bytes32 config;
326         bytes32 r;
327         bytes32 s;
328     }
329 
330     /**
331      * Hash of the EIP712 Domain Separator Schema
332      */
333     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name)"));
334 
335     bytes32 private constant DOMAIN_SEPARATOR = keccak256(
336         abi.encodePacked(EIP712_DOMAIN_TYPEHASH, keccak256(bytes(DOMAIN_NAME)))
337     );
338 
339     /**
340      * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
341      *
342      * @param eip712hash The EIP712 hash struct.
343      * @return EIP712 hash applied to this EIP712 Domain.
344      */
345     function hashEIP712Message(bytes32 eip712hash) internal pure returns (bytes32) {
346         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
347     }
348 }
349 
350 library LibSignature {
351     enum SignatureMethod {ETH_SIGN, EIP712}
352 
353     struct OrderSignature {
354         bytes32 config;
355         bytes32 r;
356         bytes32 s;
357     }
358 
359     /**
360      * Validate a signature given a hash calculated from the order data, the signer, and the
361      * signature data passed in with the order.
362      *
363      * This function will revert the transaction if the signature method is invalid.
364      *
365      * @param signature The signature data passed along with the order to validate against
366      * @param hash Hash bytes calculated by taking the EIP712 hash of the passed order data
367      * @param signerAddress The address of the signer
368      * @return True if the calculated signature matches the order signature data, false otherwise.
369      */
370     function isValidSignature(OrderSignature memory signature, bytes32 hash, address signerAddress)
371         internal
372         pure
373         returns (bool)
374     {
375         uint8 method = uint8(signature.config[1]);
376         address recovered;
377         uint8 v = uint8(signature.config[0]);
378 
379         if (method == uint8(SignatureMethod.ETH_SIGN)) {
380             recovered = ecrecover(
381                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
382                 v,
383                 signature.r,
384                 signature.s
385             );
386         } else if (method == uint8(SignatureMethod.EIP712)) {
387             recovered = ecrecover(hash, v, signature.r, signature.s);
388         } else {
389             revert("invalid sign method");
390         }
391 
392         return signerAddress == recovered;
393     }
394 }
395 
396 library LibOrder {
397     using LibMathSigned for int256;
398     using LibMathUnsigned for uint256;
399 
400     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
401         abi.encodePacked(
402             "Order(address trader,address broker,address perpetual,uint256 amount,uint256 price,bytes32 data)"
403         )
404     );
405 
406     int256 public constant FEE_RATE_BASE = 100000;
407     uint256 public constant ONE = 1e18;
408 
409     struct Order {
410         address trader;
411         address broker;
412         address perpetual;
413         uint256 amount;
414         uint256 price;
415         /**
416          * Data contains the following values packed into 32 bytes
417          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
418          * ║                    │ length(bytes)   desc                                      ║
419          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
420          * ║ version            │ 1               order version                             ║
421          * ║ side               │ 1               0: buy (long), 1: sell (short)            ║
422          * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
423          * ║ expiredAt          │ 5               order expiration time in seconds          ║
424          * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
425          * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
426          * ║ (d) makerRebateRate│ 2               rebate rate for maker (base 100)          ║
427          * ║ salt               │ 8               salt                                      ║
428          * ║ isMakerOnly        │ 1               is maker only                             ║
429          * ║ isInversed         │ 1               is inversed contract                      ║
430          * ║                    │ 8               reserved                                  ║
431          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
432          */
433         bytes32 data;
434     }
435 
436     struct OrderParam {
437         address trader;
438         uint256 amount;
439         uint256 price;
440         bytes32 data;
441         LibSignature.OrderSignature signature;
442     }
443 
444     function getOrderHash(OrderParam memory orderParam, address perpetual, address broker)
445         internal
446         pure
447         returns (bytes32 orderHash)
448     {
449         Order memory order = getOrder(orderParam, perpetual, broker);
450         orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
451         return orderHash;
452     }
453 
454     function getOrderHash(Order memory order) internal pure returns (bytes32 orderHash) {
455         orderHash = LibEIP712.hashEIP712Message(hashOrder(order));
456         return orderHash;
457     }
458 
459     function getOrder(OrderParam memory orderParam, address perpetual, address broker)
460         internal
461         pure
462         returns (LibOrder.Order memory order)
463     {
464         order.trader = orderParam.trader;
465         order.broker = broker;
466         order.perpetual = perpetual;
467         order.amount = orderParam.amount;
468         order.price = orderParam.price;
469         order.data = orderParam.data;
470     }
471 
472     function hashOrder(Order memory order) internal pure returns (bytes32 result) {
473         bytes32 orderType = EIP712_ORDER_TYPE;
474         // solium-disable-next-line security/no-inline-assembly
475         assembly {
476             let start := sub(order, 32)
477             let tmp := mload(start)
478             mstore(start, orderType)
479             result := keccak256(start, 224)
480             mstore(start, tmp)
481         }
482         return result;
483     }
484 
485     function getOrderVersion(OrderParam memory orderParam) internal pure returns (uint256) {
486         return uint256(uint8(bytes1(orderParam.data)));
487     }
488 
489     function getExpiredAt(OrderParam memory orderParam) internal pure returns (uint256) {
490         return uint256(uint40(bytes5(orderParam.data << (8 * 3))));
491     }
492 
493     function isSell(OrderParam memory orderParam) internal pure returns (bool) {
494         bool sell = uint8(orderParam.data[1]) == 1;
495         return isInversed(orderParam) ? !sell : sell;
496     }
497 
498     function getPrice(OrderParam memory orderParam) internal pure returns (uint256) {
499         return isInversed(orderParam) ? ONE.wdiv(orderParam.price) : orderParam.price;
500     }
501 
502     function isMarketOrder(OrderParam memory orderParam) internal pure returns (bool) {
503         return uint8(orderParam.data[2]) == 1;
504     }
505 
506     function isMarketBuy(OrderParam memory orderParam) internal pure returns (bool) {
507         return !isSell(orderParam) && isMarketOrder(orderParam);
508     }
509 
510     function isMakerOnly(OrderParam memory orderParam) internal pure returns (bool) {
511         return uint8(orderParam.data[22]) == 1;
512     }
513 
514     function isInversed(OrderParam memory orderParam) internal pure returns (bool) {
515         return uint8(orderParam.data[23]) == 1;
516     }
517 
518     function side(OrderParam memory orderParam) internal pure returns (LibTypes.Side) {
519         return isSell(orderParam) ? LibTypes.Side.SHORT : LibTypes.Side.LONG;
520     }
521 
522     function makerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
523         return int256(int16(bytes2(orderParam.data << (8 * 8)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
524     }
525 
526     function takerFeeRate(OrderParam memory orderParam) internal pure returns (int256) {
527         return int256(int16(bytes2(orderParam.data << (8 * 10)))).mul(LibMathSigned.WAD()).div(FEE_RATE_BASE);
528     }
529 }
530 
531 library LibTypes {
532     enum Side {FLAT, SHORT, LONG}
533 
534     enum Status {NORMAL, SETTLING, SETTLED}
535 
536     function counterSide(Side side) internal pure returns (Side) {
537         if (side == Side.LONG) {
538             return Side.SHORT;
539         } else if (side == Side.SHORT) {
540             return Side.LONG;
541         }
542         return side;
543     }
544 
545     //////////////////////////////////////////////////////////////////////////
546     // Perpetual
547     //////////////////////////////////////////////////////////////////////////
548     struct PerpGovernanceConfig {
549         uint256 initialMarginRate;
550         uint256 maintenanceMarginRate;
551         uint256 liquidationPenaltyRate;
552         uint256 penaltyFundRate;
553         int256 takerDevFeeRate;
554         int256 makerDevFeeRate;
555         uint256 lotSize;
556         uint256 tradingLotSize;
557     }
558 
559     // CollateralAccount represents cash account of user
560     struct CollateralAccount {
561         // currernt deposited erc20 token amount, representing in decimals 18
562         int256 balance;
563         // the amount of withdrawal applied by user
564         // which allowed to withdraw in the future but not available in trading
565         int256 appliedBalance;
566         // applied balance will be appled only when the block height below is reached
567         uint256 appliedHeight;
568     }
569 
570     struct PositionAccount {
571         LibTypes.Side side;
572         uint256 size;
573         uint256 entryValue;
574         int256 entrySocialLoss;
575         int256 entryFundingLoss;
576     }
577 
578     struct BrokerRecord {
579         address broker;
580         uint256 appliedHeight;
581     }
582 
583     struct Broker {
584         BrokerRecord previous;
585         BrokerRecord current;
586     }
587 
588     //////////////////////////////////////////////////////////////////////////
589     // AMM
590     //////////////////////////////////////////////////////////////////////////
591     struct AMMGovernanceConfig {
592         uint256 poolFeeRate;
593         uint256 poolDevFeeRate;
594         int256 emaAlpha;
595         uint256 updatePremiumPrize;
596         int256 markPremiumLimit;
597         int256 fundingDampener;
598     }
599 
600     struct FundingState {
601         uint256 lastFundingTime;
602         int256 lastPremium;
603         int256 lastEMAPremium;
604         uint256 lastIndexPrice;
605         int256 accumulatedFundingPerContract;
606     }
607 }
608 
609 interface IPerpetualProxy {
610     // a gas-optimized version of position*
611     struct PoolAccount {
612         uint256 positionSize;
613         uint256 positionEntryValue;
614         int256 cashBalance;
615         int256 socialLossPerContract;
616         int256 positionEntrySocialLoss;
617         int256 positionEntryFundingLoss;
618     }
619 
620     function self() external view returns (address);
621 
622     function perpetual() external view returns (address);
623 
624     function devAddress() external view returns (address);
625 
626     function currentBroker(address guy) external view returns (address);
627 
628     function markPrice() external returns (uint256);
629 
630     function settlementPrice() external view returns (uint256);
631 
632     function availableMargin(address guy) external returns (int256);
633 
634     function getPoolAccount() external view returns (PoolAccount memory pool);
635 
636     function cashBalance() external view returns (int256);
637 
638     function positionSize() external view returns (uint256);
639 
640     function positionSide() external view returns (LibTypes.Side);
641 
642     function positionEntryValue() external view returns (uint256);
643 
644     function positionEntrySocialLoss() external view returns (int256);
645 
646     function positionEntryFundingLoss() external view returns (int256);
647 
648     // function isEmergency() external view returns (bool);
649 
650     // function isGlobalSettled() external view returns (bool);
651 
652     function status() external view returns (LibTypes.Status);
653 
654     function socialLossPerContract(LibTypes.Side side) external view returns (int256);
655 
656     function transferBalanceIn(address from, uint256 amount) external;
657 
658     function transferBalanceOut(address to, uint256 amount) external;
659 
660     function transferBalanceTo(address from, address to, uint256 amount) external;
661 
662     function trade(address guy, LibTypes.Side side, uint256 price, uint256 amount) external returns (uint256);
663 
664     function setBrokerFor(address guy, address broker) external;
665 
666     function depositFor(address guy, uint256 amount) external;
667 
668     function depositEtherFor(address guy) external payable;
669 
670     function withdrawFor(address payable guy, uint256 amount) external;
671 
672     function isSafe(address guy) external returns (bool);
673 
674     function isSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);
675 
676     function isProxySafe() external returns (bool);
677 
678     function isProxySafeWithPrice(uint256 currentMarkPrice) external returns (bool);
679 
680     function isIMSafe(address guy) external returns (bool);
681 
682     function isIMSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);
683 
684     function lotSize() external view returns (uint256);
685 
686     function tradingLotSize() external view returns (uint256);
687 }
688 
689 interface IAMM {
690     function shareTokenAddress() external view returns (address);
691 
692     function lastFundingState() external view returns (LibTypes.FundingState memory);
693 
694     function getGovernance() external view returns (LibTypes.AMMGovernanceConfig memory);
695 
696     function perpetualProxy() external view returns (IPerpetualProxy);
697 
698     function currentMarkPrice() external returns (uint256);
699 
700     function currentAvailableMargin() external returns (uint256);
701 
702     function currentFairPrice() external returns (uint256);
703 
704     function positionSize() external returns (uint256);
705 
706     function currentAccumulatedFundingPerContract() external returns (int256);
707 
708     function settleShare(uint256 shareAmount) external;
709 
710     function buy(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
711 
712     function sell(uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
713 
714     function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
715         external
716         returns (uint256);
717 
718     function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
719         external
720         returns (uint256);
721 
722     function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
723 
724     function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) external returns (uint256);
725 }
726 
727 interface IPerpetual {
728     function devAddress() external view returns (address);
729 
730     function getCashBalance(address guy) external view returns (LibTypes.CollateralAccount memory);
731 
732     function getPosition(address guy) external view returns (LibTypes.PositionAccount memory);
733 
734     function getBroker(address guy) external view returns (LibTypes.Broker memory);
735 
736     function getGovernance() external view returns (LibTypes.PerpGovernanceConfig memory);
737 
738     function status() external view returns (LibTypes.Status);
739 
740     function settlementPrice() external view returns (uint256);
741 
742     function globalConfig() external view returns (address);
743 
744     function collateral() external view returns (address);
745 
746     function isWhitelisted(address account) external view returns (bool);
747 
748     function currentBroker(address guy) external view returns (address);
749 
750     function amm() external view returns (IAMM);
751 
752     function totalSize(LibTypes.Side side) external view returns (uint256);
753 
754     function markPrice() external returns (uint256);
755 
756     function socialLossPerContract(LibTypes.Side side) external view returns (int256);
757 
758     function availableMargin(address guy) external returns (int256);
759 
760     function positionMargin(address guy) external view returns (uint256);
761 
762     function maintenanceMargin(address guy) external view returns (uint256);
763 
764     function isSafe(address guy) external returns (bool);
765 
766     function isSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);
767 
768     function isIMSafe(address guy) external returns (bool);
769 
770     function isIMSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);
771 
772     function tradePosition(address guy, LibTypes.Side side, uint256 price, uint256 amount) external returns (uint256);
773 
774     function transferCashBalance(address from, address to, uint256 amount) external;
775 
776     function setBrokerFor(address guy, address broker) external;
777 
778     function depositFor(address guy, uint256 amount) external;
779 
780     function depositEtherFor(address guy) external payable;
781 
782     function withdrawFor(address payable guy, uint256 amount) external;
783 
784     function liquidate(address guy, uint256 amount) external returns (uint256, uint256);
785 
786     function liquidateFrom(address from, address guy, uint256 amount) external returns (uint256, uint256);
787 
788     function insuranceFundBalance() external view returns (int256);
789 }
790 
791 contract Exchange {
792     using LibMathSigned for int256;
793     using LibMathUnsigned for uint256;
794     using LibOrder for LibOrder.Order;
795     using LibOrder for LibOrder.OrderParam;
796     using LibSignature for LibSignature.OrderSignature;
797 
798     uint256 public constant SUPPORTED_ORDER_VERSION = 2;
799 
800     enum OrderStatus {EXPIRED, CANCELLED, FILLABLE, FULLY_FILLED}
801 
802     mapping(bytes32 => uint256) public filled;
803     mapping(bytes32 => bool) public cancelled;
804 
805     event MatchWithOrders(
806         address perpetual,
807         LibOrder.OrderParam takerOrderParam,
808         LibOrder.OrderParam makerOrderParam,
809         uint256 amount
810     );
811     event MatchWithAMM(address perpetual, LibOrder.OrderParam takerOrderParam, uint256 amount);
812     event Cancel(bytes32 indexed orderHash);
813 
814     function matchOrders(
815         LibOrder.OrderParam memory takerOrderParam,
816         LibOrder.OrderParam[] memory makerOrderParams,
817         address _perpetual,
818         uint256[] memory amounts
819     ) public {
820         require(!takerOrderParam.isMakerOnly(), "taker order is maker only");
821 
822         IPerpetual perpetual = IPerpetual(_perpetual);
823         require(perpetual.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
824 
825         uint256 tradingLotSize = perpetual.getGovernance().tradingLotSize;
826         bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
827         uint256 takerFilledAmount = filled[takerOrderHash];
828         uint256 takerOpened;
829 
830         for (uint256 i = 0; i < makerOrderParams.length; i++) {
831             require(takerOrderParam.trader != makerOrderParams[i].trader, "self trade");
832             require(takerOrderParam.isInversed() == makerOrderParams[i].isInversed(), "invalid inversed pair");
833             require(takerOrderParam.isSell() != makerOrderParams[i].isSell(), "invalid side");
834             require(!makerOrderParams[i].isMarketOrder(), "market order cannot be maker");
835 
836             validatePrice(takerOrderParam, makerOrderParams[i]);
837 
838             bytes32 makerOrderHash = validateOrderParam(perpetual, makerOrderParams[i]);
839             uint256 makerFilledAmount = filled[makerOrderHash];
840 
841             require(amounts[i] <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");
842             require(amounts[i] <= makerOrderParams[i].amount.sub(makerFilledAmount), "maker overfilled");
843             require(amounts[i].mod(tradingLotSize) == 0, "invalid trading lot size");
844 
845             uint256 opened = fillOrder(perpetual, takerOrderParam, makerOrderParams[i], amounts[i]);
846 
847             takerOpened = takerOpened.add(opened);
848             filled[makerOrderHash] = makerFilledAmount.add(amounts[i]);
849             takerFilledAmount = takerFilledAmount.add(amounts[i]);
850         }
851 
852         // all trades done, check taker safe.
853         if (takerOpened > 0) {
854             require(perpetual.isIMSafe(takerOrderParam.trader), "taker margin");
855         } else {
856             require(perpetual.isSafe(takerOrderParam.trader), "maker unsafe");
857         }
858         require(perpetual.isSafe(msg.sender), "broker unsafe");
859 
860         filled[takerOrderHash] = takerFilledAmount;
861     }
862 
863     function fillOrder(
864         IPerpetual perpetual,
865         LibOrder.OrderParam memory takerOrderParam,
866         LibOrder.OrderParam memory makerOrderParam,
867         uint256 amount
868     ) internal returns (uint256) {
869         uint256 price = makerOrderParam.getPrice();
870         uint256 takerOpened = perpetual.tradePosition(takerOrderParam.trader, takerOrderParam.side(), price, amount);
871         uint256 makerOpened = perpetual.tradePosition(makerOrderParam.trader, makerOrderParam.side(), price, amount);
872 
873         // trading fee
874         int256 takerTradingFee = amount.wmul(price).toInt256().wmul(takerOrderParam.takerFeeRate());
875         claimTradingFee(perpetual, takerOrderParam.trader, takerTradingFee);
876         int256 makerTradingFee = amount.wmul(price).toInt256().wmul(makerOrderParam.makerFeeRate());
877         claimTradingFee(perpetual, makerOrderParam.trader, makerTradingFee);
878 
879         // dev fee
880         claimTakerDevFee(perpetual, takerOrderParam.trader, price, takerOpened, amount.sub(takerOpened));
881         claimMakerDevFee(perpetual, makerOrderParam.trader, price, makerOpened, amount.sub(makerOpened));
882         if (makerOpened > 0) {
883             require(perpetual.isIMSafe(makerOrderParam.trader), "maker margin");
884         } else {
885             require(perpetual.isSafe(makerOrderParam.trader), "maker unsafe");
886         }
887 
888         emit MatchWithOrders(address(perpetual), takerOrderParam, makerOrderParam, amount);
889 
890         return takerOpened;
891     }
892 
893     function matchOrderWithAMM(LibOrder.OrderParam memory takerOrderParam, address _perpetual, uint256 amount) public {
894         require(!takerOrderParam.isMakerOnly(), "taker order is maker only");
895 
896         IPerpetual perpetual = IPerpetual(_perpetual);
897         IAMM amm = IAMM(perpetual.amm());
898 
899         require(amount.mod(perpetual.getGovernance().tradingLotSize) == 0, "invalid trading lot size");
900 
901         bytes32 takerOrderHash = validateOrderParam(perpetual, takerOrderParam);
902         uint256 takerFilledAmount = filled[takerOrderHash];
903         require(amount <= takerOrderParam.amount.sub(takerFilledAmount), "taker overfilled");
904 
905         // trading with pool
906         uint256 takerOpened;
907         uint256 price = takerOrderParam.getPrice();
908         if (takerOrderParam.isSell()) {
909             takerOpened = amm.sellFromWhitelisted(
910                 takerOrderParam.trader,
911                 amount,
912                 price,
913                 takerOrderParam.getExpiredAt()
914             );
915         } else {
916             takerOpened = amm.buyFromWhitelisted(takerOrderParam.trader, amount, price, takerOrderParam.getExpiredAt());
917         }
918         filled[takerOrderHash] = filled[takerOrderHash].add(amount);
919 
920         emit MatchWithAMM(_perpetual, takerOrderParam, amount);
921     }
922 
923     function validatePrice(LibOrder.OrderParam memory takerOrderParam, LibOrder.OrderParam memory makerOrderParam)
924         internal
925         pure
926     {
927         if (takerOrderParam.isMarketOrder()) {
928             return;
929         }
930         uint256 takerPrice = takerOrderParam.getPrice();
931         uint256 makerPrice = makerOrderParam.getPrice();
932         require(takerOrderParam.isSell() ? takerPrice <= makerPrice : takerPrice >= makerPrice, "price not match");
933     }
934 
935     function validateOrderParam(IPerpetual perpetual, LibOrder.OrderParam memory orderParam)
936         internal
937         view
938         returns (bytes32)
939     {
940         address broker = perpetual.currentBroker(orderParam.trader);
941         require(broker == msg.sender, "invalid broker");
942         require(orderParam.getOrderVersion() == 2, "unsupported version");
943         require(orderParam.getExpiredAt() >= block.timestamp, "order expired");
944 
945         bytes32 orderHash = orderParam.getOrderHash(address(perpetual), broker);
946         require(orderParam.signature.isValidSignature(orderHash, orderParam.trader), "invalid signature");
947         require(filled[orderHash] < orderParam.amount, "fullfilled order");
948 
949         return orderHash;
950     }
951 
952     function claimTradingFee(IPerpetual perpetual, address trader, int256 fee) internal {
953         if (fee > 0) {
954             perpetual.transferCashBalance(trader, msg.sender, fee.toUint256());
955         } else if (fee < 0) {
956             perpetual.transferCashBalance(msg.sender, trader, fee.neg().toUint256());
957         }
958     }
959 
960     function cancelOrder(LibOrder.Order memory order) public {
961         require(msg.sender == order.trader || msg.sender == order.broker, "invalid caller");
962 
963         bytes32 orderHash = order.getOrderHash();
964         cancelled[orderHash] = true;
965 
966         emit Cancel(orderHash);
967     }
968 
969     function claimDevFee(
970         IPerpetual perpetual,
971         address guy,
972         uint256 price,
973         uint256 openedAmount,
974         uint256 closedAmount,
975         int256 feeRate
976     ) internal {
977         if (feeRate == 0) {
978             return;
979         }
980         int256 hard = price.wmul(openedAmount).toInt256().wmul(feeRate);
981         int256 soft = price.wmul(closedAmount).toInt256().wmul(feeRate);
982         int256 fee = hard.add(soft);
983         address devAddress = perpetual.devAddress();
984         if (fee > 0) {
985             int256 available = perpetual.availableMargin(guy);
986             require(available >= hard, "dev margin");
987             fee = fee.min(available);
988             perpetual.transferCashBalance(guy, devAddress, fee.toUint256());
989         } else if (fee < 0) {
990             perpetual.transferCashBalance(devAddress, guy, fee.neg().toUint256());
991             require(perpetual.isSafe(devAddress), "dev unsafe");
992         }
993     }
994 
995     function claimTakerDevFee(
996         IPerpetual perpetual,
997         address guy,
998         uint256 price,
999         uint256 openedAmount,
1000         uint256 closedAmount
1001     ) internal {
1002         int256 rate = perpetual.getGovernance().takerDevFeeRate;
1003         claimDevFee(perpetual, guy, price, openedAmount, closedAmount, rate);
1004     }
1005 
1006     function claimMakerDevFee(
1007         IPerpetual perpetual,
1008         address guy,
1009         uint256 price,
1010         uint256 openedAmount,
1011         uint256 closedAmount
1012     ) internal {
1013         int256 rate = perpetual.getGovernance().makerDevFeeRate;
1014         claimDevFee(perpetual, guy, price, openedAmount, closedAmount, rate);
1015     }
1016 }