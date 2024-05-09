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
609 library Roles {
610     struct Role {
611         mapping (address => bool) bearer;
612     }
613 
614     /**
615      * @dev Give an account access to this role.
616      */
617     function add(Role storage role, address account) internal {
618         require(!has(role, account), "Roles: account already has role");
619         role.bearer[account] = true;
620     }
621 
622     /**
623      * @dev Remove an account's access to this role.
624      */
625     function remove(Role storage role, address account) internal {
626         require(has(role, account), "Roles: account does not have role");
627         role.bearer[account] = false;
628     }
629 
630     /**
631      * @dev Check if an account has this role.
632      * @return bool
633      */
634     function has(Role storage role, address account) internal view returns (bool) {
635         require(account != address(0), "Roles: account is the zero address");
636         return role.bearer[account];
637     }
638 }
639 
640 contract WhitelistAdminRole {
641     using Roles for Roles.Role;
642 
643     event WhitelistAdminAdded(address indexed account);
644     event WhitelistAdminRemoved(address indexed account);
645 
646     Roles.Role private _whitelistAdmins;
647 
648     constructor () internal {
649         _addWhitelistAdmin(msg.sender);
650     }
651 
652     modifier onlyWhitelistAdmin() {
653         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
654         _;
655     }
656 
657     function isWhitelistAdmin(address account) public view returns (bool) {
658         return _whitelistAdmins.has(account);
659     }
660 
661     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
662         _addWhitelistAdmin(account);
663     }
664 
665     function renounceWhitelistAdmin() public {
666         _removeWhitelistAdmin(msg.sender);
667     }
668 
669     function _addWhitelistAdmin(address account) internal {
670         _whitelistAdmins.add(account);
671         emit WhitelistAdminAdded(account);
672     }
673 
674     function _removeWhitelistAdmin(address account) internal {
675         _whitelistAdmins.remove(account);
676         emit WhitelistAdminRemoved(account);
677     }
678 }
679 
680 contract WhitelistedRole is WhitelistAdminRole {
681     using Roles for Roles.Role;
682 
683     event WhitelistedAdded(address indexed account);
684     event WhitelistedRemoved(address indexed account);
685 
686     Roles.Role private _whitelisteds;
687 
688     modifier onlyWhitelisted() {
689         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
690         _;
691     }
692 
693     function isWhitelisted(address account) public view returns (bool) {
694         return _whitelisteds.has(account);
695     }
696 
697     function addWhitelisted(address account) public onlyWhitelistAdmin {
698         _addWhitelisted(account);
699     }
700 
701     function removeWhitelisted(address account) public onlyWhitelistAdmin {
702         _removeWhitelisted(account);
703     }
704 
705     function renounceWhitelisted() public {
706         _removeWhitelisted(msg.sender);
707     }
708 
709     function _addWhitelisted(address account) internal {
710         _whitelisteds.add(account);
711         emit WhitelistedAdded(account);
712     }
713 
714     function _removeWhitelisted(address account) internal {
715         _whitelisteds.remove(account);
716         emit WhitelistedRemoved(account);
717     }
718 }
719 
720 contract AMMGovernance is WhitelistedRole {
721     using LibMathSigned for int256;
722     using LibMathUnsigned for uint256;
723 
724     LibTypes.AMMGovernanceConfig internal governance;
725 
726     // auto-set when calling setGovernanceParameter
727     int256 public emaAlpha2; // 1 - emaAlpha
728     int256 public emaAlpha2Ln; // ln(emaAlpha2)
729 
730     event UpdateGovernanceParameter(bytes32 indexed key, int256 value);
731 
732     function setGovernanceParameter(bytes32 key, int256 value) public onlyWhitelistAdmin {
733         if (key == "poolFeeRate") {
734             governance.poolFeeRate = value.toUint256();
735         } else if (key == "poolDevFeeRate") {
736             governance.poolDevFeeRate = value.toUint256();
737         } else if (key == "emaAlpha") {
738             require(value > 0, "alpha should be > 0");
739             governance.emaAlpha = value;
740             emaAlpha2 = 10**18 - governance.emaAlpha;
741             emaAlpha2Ln = emaAlpha2.wln();
742         } else if (key == "updatePremiumPrize") {
743             governance.updatePremiumPrize = value.toUint256();
744         } else if (key == "markPremiumLimit") {
745             governance.markPremiumLimit = value;
746         } else if (key == "fundingDampener") {
747             governance.fundingDampener = value;
748         } else {
749             revert("key not exists");
750         }
751         emit UpdateGovernanceParameter(key, value);
752     }
753 
754     function getGovernance() public view returns (LibTypes.AMMGovernanceConfig memory) {
755         return governance;
756     }
757 }
758 
759 interface IPriceFeeder {
760     function price() external view returns (uint256 lastPrice, uint256 lastTimestamp);
761 }
762 
763 interface IPerpetualProxy {
764     // a gas-optimized version of position*
765     struct PoolAccount {
766         uint256 positionSize;
767         uint256 positionEntryValue;
768         int256 cashBalance;
769         int256 socialLossPerContract;
770         int256 positionEntrySocialLoss;
771         int256 positionEntryFundingLoss;
772     }
773 
774     function self() external view returns (address);
775 
776     function perpetual() external view returns (address);
777 
778     function devAddress() external view returns (address);
779 
780     function currentBroker(address guy) external view returns (address);
781 
782     function markPrice() external returns (uint256);
783 
784     function settlementPrice() external view returns (uint256);
785 
786     function availableMargin(address guy) external returns (int256);
787 
788     function getPoolAccount() external view returns (PoolAccount memory pool);
789 
790     function cashBalance() external view returns (int256);
791 
792     function positionSize() external view returns (uint256);
793 
794     function positionSide() external view returns (LibTypes.Side);
795 
796     function positionEntryValue() external view returns (uint256);
797 
798     function positionEntrySocialLoss() external view returns (int256);
799 
800     function positionEntryFundingLoss() external view returns (int256);
801 
802     // function isEmergency() external view returns (bool);
803 
804     // function isGlobalSettled() external view returns (bool);
805 
806     function status() external view returns (LibTypes.Status);
807 
808     function socialLossPerContract(LibTypes.Side side) external view returns (int256);
809 
810     function transferBalanceIn(address from, uint256 amount) external;
811 
812     function transferBalanceOut(address to, uint256 amount) external;
813 
814     function transferBalanceTo(address from, address to, uint256 amount) external;
815 
816     function trade(address guy, LibTypes.Side side, uint256 price, uint256 amount) external returns (uint256);
817 
818     function setBrokerFor(address guy, address broker) external;
819 
820     function depositFor(address guy, uint256 amount) external;
821 
822     function depositEtherFor(address guy) external payable;
823 
824     function withdrawFor(address payable guy, uint256 amount) external;
825 
826     function isSafe(address guy) external returns (bool);
827 
828     function isSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);
829 
830     function isProxySafe() external returns (bool);
831 
832     function isProxySafeWithPrice(uint256 currentMarkPrice) external returns (bool);
833 
834     function isIMSafe(address guy) external returns (bool);
835 
836     function isIMSafeWithPrice(address guy, uint256 currentMarkPrice) external returns (bool);
837 
838     function lotSize() external view returns (uint256);
839 
840     function tradingLotSize() external view returns (uint256);
841 }
842 
843 interface IERC20 {
844     /**
845      * @dev Returns the amount of tokens in existence.
846      */
847     function totalSupply() external view returns (uint256);
848 
849     /**
850      * @dev Returns the amount of tokens owned by `account`.
851      */
852     function balanceOf(address account) external view returns (uint256);
853 
854     /**
855      * @dev Moves `amount` tokens from the caller's account to `recipient`.
856      *
857      * Returns a boolean value indicating whether the operation succeeded.
858      *
859      * Emits a `Transfer` event.
860      */
861     function transfer(address recipient, uint256 amount) external returns (bool);
862 
863     /**
864      * @dev Returns the remaining number of tokens that `spender` will be
865      * allowed to spend on behalf of `owner` through `transferFrom`. This is
866      * zero by default.
867      *
868      * This value changes when `approve` or `transferFrom` are called.
869      */
870     function allowance(address owner, address spender) external view returns (uint256);
871 
872     /**
873      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
874      *
875      * Returns a boolean value indicating whether the operation succeeded.
876      *
877      * > Beware that changing an allowance with this method brings the risk
878      * that someone may use both the old and the new allowance by unfortunate
879      * transaction ordering. One possible solution to mitigate this race
880      * condition is to first reduce the spender's allowance to 0 and set the
881      * desired value afterwards:
882      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
883      *
884      * Emits an `Approval` event.
885      */
886     function approve(address spender, uint256 amount) external returns (bool);
887 
888     /**
889      * @dev Moves `amount` tokens from `sender` to `recipient` using the
890      * allowance mechanism. `amount` is then deducted from the caller's
891      * allowance.
892      *
893      * Returns a boolean value indicating whether the operation succeeded.
894      *
895      * Emits a `Transfer` event.
896      */
897     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
898 
899     /**
900      * @dev Emitted when `value` tokens are moved from one account (`from`) to
901      * another (`to`).
902      *
903      * Note that `value` may be zero.
904      */
905     event Transfer(address indexed from, address indexed to, uint256 value);
906 
907     /**
908      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
909      * a call to `approve`. `value` is the new allowance.
910      */
911     event Approval(address indexed owner, address indexed spender, uint256 value);
912 }
913 
914 library SafeMath {
915     /**
916      * @dev Returns the addition of two unsigned integers, reverting on
917      * overflow.
918      *
919      * Counterpart to Solidity's `+` operator.
920      *
921      * Requirements:
922      * - Addition cannot overflow.
923      */
924     function add(uint256 a, uint256 b) internal pure returns (uint256) {
925         uint256 c = a + b;
926         require(c >= a, "SafeMath: addition overflow");
927 
928         return c;
929     }
930 
931     /**
932      * @dev Returns the subtraction of two unsigned integers, reverting on
933      * overflow (when the result is negative).
934      *
935      * Counterpart to Solidity's `-` operator.
936      *
937      * Requirements:
938      * - Subtraction cannot overflow.
939      */
940     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
941         require(b <= a, "SafeMath: subtraction overflow");
942         uint256 c = a - b;
943 
944         return c;
945     }
946 
947     /**
948      * @dev Returns the multiplication of two unsigned integers, reverting on
949      * overflow.
950      *
951      * Counterpart to Solidity's `*` operator.
952      *
953      * Requirements:
954      * - Multiplication cannot overflow.
955      */
956     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
957         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
958         // benefit is lost if 'b' is also tested.
959         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
960         if (a == 0) {
961             return 0;
962         }
963 
964         uint256 c = a * b;
965         require(c / a == b, "SafeMath: multiplication overflow");
966 
967         return c;
968     }
969 
970     /**
971      * @dev Returns the integer division of two unsigned integers. Reverts on
972      * division by zero. The result is rounded towards zero.
973      *
974      * Counterpart to Solidity's `/` operator. Note: this function uses a
975      * `revert` opcode (which leaves remaining gas untouched) while Solidity
976      * uses an invalid opcode to revert (consuming all remaining gas).
977      *
978      * Requirements:
979      * - The divisor cannot be zero.
980      */
981     function div(uint256 a, uint256 b) internal pure returns (uint256) {
982         // Solidity only automatically asserts when dividing by 0
983         require(b > 0, "SafeMath: division by zero");
984         uint256 c = a / b;
985         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
986 
987         return c;
988     }
989 
990     /**
991      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
992      * Reverts when dividing by zero.
993      *
994      * Counterpart to Solidity's `%` operator. This function uses a `revert`
995      * opcode (which leaves remaining gas untouched) while Solidity uses an
996      * invalid opcode to revert (consuming all remaining gas).
997      *
998      * Requirements:
999      * - The divisor cannot be zero.
1000      */
1001     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1002         require(b != 0, "SafeMath: modulo by zero");
1003         return a % b;
1004     }
1005 }
1006 
1007 contract ERC20 is IERC20 {
1008     using SafeMath for uint256;
1009 
1010     mapping (address => uint256) private _balances;
1011 
1012     mapping (address => mapping (address => uint256)) private _allowances;
1013 
1014     uint256 private _totalSupply;
1015 
1016     /**
1017      * @dev See `IERC20.totalSupply`.
1018      */
1019     function totalSupply() public view returns (uint256) {
1020         return _totalSupply;
1021     }
1022 
1023     /**
1024      * @dev See `IERC20.balanceOf`.
1025      */
1026     function balanceOf(address account) public view returns (uint256) {
1027         return _balances[account];
1028     }
1029 
1030     /**
1031      * @dev See `IERC20.transfer`.
1032      *
1033      * Requirements:
1034      *
1035      * - `recipient` cannot be the zero address.
1036      * - the caller must have a balance of at least `amount`.
1037      */
1038     function transfer(address recipient, uint256 amount) public returns (bool) {
1039         _transfer(msg.sender, recipient, amount);
1040         return true;
1041     }
1042 
1043     /**
1044      * @dev See `IERC20.allowance`.
1045      */
1046     function allowance(address owner, address spender) public view returns (uint256) {
1047         return _allowances[owner][spender];
1048     }
1049 
1050     /**
1051      * @dev See `IERC20.approve`.
1052      *
1053      * Requirements:
1054      *
1055      * - `spender` cannot be the zero address.
1056      */
1057     function approve(address spender, uint256 value) public returns (bool) {
1058         _approve(msg.sender, spender, value);
1059         return true;
1060     }
1061 
1062     /**
1063      * @dev See `IERC20.transferFrom`.
1064      *
1065      * Emits an `Approval` event indicating the updated allowance. This is not
1066      * required by the EIP. See the note at the beginning of `ERC20`;
1067      *
1068      * Requirements:
1069      * - `sender` and `recipient` cannot be the zero address.
1070      * - `sender` must have a balance of at least `value`.
1071      * - the caller must have allowance for `sender`'s tokens of at least
1072      * `amount`.
1073      */
1074     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1075         _transfer(sender, recipient, amount);
1076         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
1077         return true;
1078     }
1079 
1080     /**
1081      * @dev Atomically increases the allowance granted to `spender` by the caller.
1082      *
1083      * This is an alternative to `approve` that can be used as a mitigation for
1084      * problems described in `IERC20.approve`.
1085      *
1086      * Emits an `Approval` event indicating the updated allowance.
1087      *
1088      * Requirements:
1089      *
1090      * - `spender` cannot be the zero address.
1091      */
1092     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1093         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
1094         return true;
1095     }
1096 
1097     /**
1098      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1099      *
1100      * This is an alternative to `approve` that can be used as a mitigation for
1101      * problems described in `IERC20.approve`.
1102      *
1103      * Emits an `Approval` event indicating the updated allowance.
1104      *
1105      * Requirements:
1106      *
1107      * - `spender` cannot be the zero address.
1108      * - `spender` must have allowance for the caller of at least
1109      * `subtractedValue`.
1110      */
1111     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1112         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
1113         return true;
1114     }
1115 
1116     /**
1117      * @dev Moves tokens `amount` from `sender` to `recipient`.
1118      *
1119      * This is internal function is equivalent to `transfer`, and can be used to
1120      * e.g. implement automatic token fees, slashing mechanisms, etc.
1121      *
1122      * Emits a `Transfer` event.
1123      *
1124      * Requirements:
1125      *
1126      * - `sender` cannot be the zero address.
1127      * - `recipient` cannot be the zero address.
1128      * - `sender` must have a balance of at least `amount`.
1129      */
1130     function _transfer(address sender, address recipient, uint256 amount) internal {
1131         require(sender != address(0), "ERC20: transfer from the zero address");
1132         require(recipient != address(0), "ERC20: transfer to the zero address");
1133 
1134         _balances[sender] = _balances[sender].sub(amount);
1135         _balances[recipient] = _balances[recipient].add(amount);
1136         emit Transfer(sender, recipient, amount);
1137     }
1138 
1139     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1140      * the total supply.
1141      *
1142      * Emits a `Transfer` event with `from` set to the zero address.
1143      *
1144      * Requirements
1145      *
1146      * - `to` cannot be the zero address.
1147      */
1148     function _mint(address account, uint256 amount) internal {
1149         require(account != address(0), "ERC20: mint to the zero address");
1150 
1151         _totalSupply = _totalSupply.add(amount);
1152         _balances[account] = _balances[account].add(amount);
1153         emit Transfer(address(0), account, amount);
1154     }
1155 
1156      /**
1157      * @dev Destoys `amount` tokens from `account`, reducing the
1158      * total supply.
1159      *
1160      * Emits a `Transfer` event with `to` set to the zero address.
1161      *
1162      * Requirements
1163      *
1164      * - `account` cannot be the zero address.
1165      * - `account` must have at least `amount` tokens.
1166      */
1167     function _burn(address account, uint256 value) internal {
1168         require(account != address(0), "ERC20: burn from the zero address");
1169 
1170         _totalSupply = _totalSupply.sub(value);
1171         _balances[account] = _balances[account].sub(value);
1172         emit Transfer(account, address(0), value);
1173     }
1174 
1175     /**
1176      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1177      *
1178      * This is internal function is equivalent to `approve`, and can be used to
1179      * e.g. set automatic allowances for certain subsystems, etc.
1180      *
1181      * Emits an `Approval` event.
1182      *
1183      * Requirements:
1184      *
1185      * - `owner` cannot be the zero address.
1186      * - `spender` cannot be the zero address.
1187      */
1188     function _approve(address owner, address spender, uint256 value) internal {
1189         require(owner != address(0), "ERC20: approve from the zero address");
1190         require(spender != address(0), "ERC20: approve to the zero address");
1191 
1192         _allowances[owner][spender] = value;
1193         emit Approval(owner, spender, value);
1194     }
1195 
1196     /**
1197      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
1198      * from the caller's allowance.
1199      *
1200      * See `_burn` and `_approve`.
1201      */
1202     function _burnFrom(address account, uint256 amount) internal {
1203         _burn(account, amount);
1204         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
1205     }
1206 }
1207 
1208 contract MinterRole {
1209     using Roles for Roles.Role;
1210 
1211     event MinterAdded(address indexed account);
1212     event MinterRemoved(address indexed account);
1213 
1214     Roles.Role private _minters;
1215 
1216     constructor () internal {
1217         _addMinter(msg.sender);
1218     }
1219 
1220     modifier onlyMinter() {
1221         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
1222         _;
1223     }
1224 
1225     function isMinter(address account) public view returns (bool) {
1226         return _minters.has(account);
1227     }
1228 
1229     function addMinter(address account) public onlyMinter {
1230         _addMinter(account);
1231     }
1232 
1233     function renounceMinter() public {
1234         _removeMinter(msg.sender);
1235     }
1236 
1237     function _addMinter(address account) internal {
1238         _minters.add(account);
1239         emit MinterAdded(account);
1240     }
1241 
1242     function _removeMinter(address account) internal {
1243         _minters.remove(account);
1244         emit MinterRemoved(account);
1245     }
1246 }
1247 
1248 contract ERC20Mintable is ERC20, MinterRole {
1249     /**
1250      * @dev See `ERC20._mint`.
1251      *
1252      * Requirements:
1253      *
1254      * - the caller must have the `MinterRole`.
1255      */
1256     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1257         _mint(account, amount);
1258         return true;
1259     }
1260 }
1261 
1262 contract ERC20Burnable is ERC20 {
1263     /**
1264      * @dev Destoys `amount` tokens from the caller.
1265      *
1266      * See `ERC20._burn`.
1267      */
1268     function burn(uint256 amount) public {
1269         _burn(msg.sender, amount);
1270     }
1271 
1272     /**
1273      * @dev See `ERC20._burnFrom`.
1274      */
1275     function burnFrom(address account, uint256 amount) public {
1276         _burnFrom(account, amount);
1277     }
1278 }
1279 
1280 contract ShareToken is ERC20Mintable {
1281     uint256 public decimals;
1282     string public name;
1283     string public symbol;
1284 
1285     constructor(string memory _name, string memory _symbol, uint256 _decimals) public {
1286         name = _name;
1287         symbol = _symbol;
1288         decimals = _decimals;
1289     }
1290 
1291     function burn(address account, uint256 amount) public onlyMinter {
1292         _burn(account, amount);
1293     }
1294 }
1295 
1296 contract AMM is AMMGovernance {
1297     using LibMathSigned for int256;
1298     using LibMathUnsigned for uint256;
1299 
1300     uint256 private constant ONE_WAD_U = 10**18;
1301     int256 private constant ONE_WAD_S = 10**18;
1302 
1303     // interfaces
1304     ShareToken private shareToken;
1305     IPerpetualProxy public perpetualProxy;
1306     IPriceFeeder public priceFeeder;
1307 
1308     // funding
1309     LibTypes.FundingState internal fundingState;
1310 
1311     event CreateAMM();
1312     event UpdateFundingRate(LibTypes.FundingState fundingState);
1313 
1314     modifier onlyBroker() {
1315         require(perpetualProxy.currentBroker(msg.sender) == authorizedBroker(), "invalid broker");
1316         _;
1317     }
1318 
1319     constructor(address _perpetualProxy, address _priceFeeder, address _shareToken) public {
1320         priceFeeder = IPriceFeeder(_priceFeeder);
1321         perpetualProxy = IPerpetualProxy(_perpetualProxy);
1322         shareToken = ShareToken(_shareToken);
1323 
1324         emit CreateAMM();
1325     }
1326 
1327     // view functions
1328     function authorizedBroker() internal view returns (address) {
1329         return address(perpetualProxy);
1330     }
1331 
1332     function shareTokenAddress() public view returns (address) {
1333         return address(shareToken);
1334     }
1335 
1336     function indexPrice() public view returns (uint256 price, uint256 timestamp) {
1337         (price, timestamp) = priceFeeder.price();
1338         require(price != 0, "dangerous index price");
1339     }
1340 
1341     function positionSize() public view returns (uint256) {
1342         return perpetualProxy.positionSize();
1343     }
1344 
1345     // note: last* functions (lastFundingState, lastAvailableMargin, lastFairPrice, etc.) are calculated based on
1346     //       the on-chain fundingState. current* functions are calculated based on the current timestamp
1347 
1348     function lastFundingState() public view returns (LibTypes.FundingState memory) {
1349         return fundingState;
1350     }
1351 
1352     function lastAvailableMargin() internal view returns (uint256) {
1353         IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
1354         return availableMarginFromPoolAccount(pool);
1355     }
1356 
1357     function lastFairPrice() internal view returns (uint256) {
1358         IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
1359         return fairPriceFromPoolAccount(pool);
1360     }
1361 
1362     function lastPremium() internal view returns (int256) {
1363         IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
1364         return premiumFromPoolAccount(pool);
1365     }
1366 
1367     function lastEMAPremium() internal view returns (int256) {
1368         return fundingState.lastEMAPremium;
1369     }
1370 
1371     function lastMarkPrice() internal view returns (uint256) {
1372         int256 index = fundingState.lastIndexPrice.toInt256();
1373         int256 limit = index.wmul(governance.markPremiumLimit);
1374         int256 p = index.add(lastEMAPremium());
1375         p = p.min(index.add(limit));
1376         p = p.max(index.sub(limit));
1377         return p.max(0).toUint256();
1378     }
1379 
1380     function lastPremiumRate() internal view returns (int256) {
1381         int256 index = fundingState.lastIndexPrice.toInt256();
1382         int256 rate = lastMarkPrice().toInt256();
1383         rate = rate.sub(index).wdiv(index);
1384         return rate;
1385     }
1386 
1387     function lastFundingRate() public view returns (int256) {
1388         int256 rate = lastPremiumRate();
1389         return rate.max(governance.fundingDampener).add(rate.min(-governance.fundingDampener));
1390     }
1391 
1392     // Public functions
1393     // note: current* functions (currentFundingState, currentAvailableMargin, currentFairPrice, etc.) are calculated based on
1394     //       the current timestamp. current* functions are calculated based on the on-chain fundingState
1395 
1396     function currentFundingState() public returns (LibTypes.FundingState memory) {
1397         funding();
1398         return fundingState;
1399     }
1400 
1401     function currentAvailableMargin() public returns (uint256) {
1402         funding();
1403         return lastAvailableMargin();
1404     }
1405 
1406     function currentFairPrice() public returns (uint256) {
1407         funding();
1408         return lastFairPrice();
1409     }
1410 
1411     function currentPremium() public returns (int256) {
1412         funding();
1413         return lastPremium();
1414     }
1415 
1416     function currentMarkPrice() public returns (uint256) {
1417         funding();
1418         return lastMarkPrice();
1419     }
1420 
1421     function currentPremiumRate() public returns (int256) {
1422         funding();
1423         return lastPremiumRate();
1424     }
1425 
1426     function currentFundingRate() public returns (int256) {
1427         funding();
1428         return lastFundingRate();
1429     }
1430 
1431     function currentAccumulatedFundingPerContract() public returns (int256) {
1432         funding();
1433         return fundingState.accumulatedFundingPerContract;
1434     }
1435 
1436     function createPool(uint256 amount) public {
1437         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1438         require(positionSize() == 0, "pool not empty");
1439         require(amount.mod(perpetualProxy.lotSize()) == 0, "invalid lot size");
1440 
1441         address trader = msg.sender;
1442         uint256 blockTime = getBlockTimestamp();
1443         uint256 newIndexPrice;
1444         uint256 newIndexTimestamp;
1445         (newIndexPrice, newIndexTimestamp) = indexPrice();
1446 
1447         initFunding(newIndexPrice, blockTime);
1448         perpetualProxy.transferBalanceIn(trader, newIndexPrice.wmul(amount).mul(2));
1449         uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.SHORT, newIndexPrice, amount);
1450         mintShareTokenTo(trader, amount);
1451 
1452         forceFunding(); // x, y changed, so fair price changed. we need funding now
1453         mustSafe(trader, opened);
1454     }
1455 
1456     function getBuyPrice(uint256 amount) internal returns (uint256 price) {
1457         uint256 x;
1458         uint256 y;
1459         (x, y) = currentXY();
1460         require(y != 0 && x != 0, "empty pool");
1461         return x.wdiv(y.sub(amount));
1462     }
1463 
1464     function buyFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) private returns (uint256) {
1465         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1466         require(amount.mod(perpetualProxy.tradingLotSize()) == 0, "invalid trading lot size");
1467 
1468         uint256 price = getBuyPrice(amount);
1469         require(limitPrice >= price, "price limited");
1470         require(getBlockTimestamp() <= deadline, "deadline exceeded");
1471         uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.LONG, price, amount);
1472 
1473         uint256 value = price.wmul(amount);
1474         uint256 fee = value.wmul(governance.poolFeeRate);
1475         uint256 devFee = value.wmul(governance.poolDevFeeRate);
1476         address devAddress = perpetualProxy.devAddress();
1477 
1478         perpetualProxy.transferBalanceIn(trader, fee);
1479         perpetualProxy.transferBalanceTo(trader, devAddress, devFee);
1480 
1481         forceFunding(); // x, y changed, so fair price changed. we need funding now
1482         mustSafe(trader, opened);
1483         return opened;
1484     }
1485 
1486     function buyFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
1487         public
1488         onlyWhitelisted
1489         returns (uint256)
1490     {
1491         return buyFrom(trader, amount, limitPrice, deadline);
1492     }
1493 
1494     function buy(uint256 amount, uint256 limitPrice, uint256 deadline) public onlyBroker returns (uint256) {
1495         return buyFrom(msg.sender, amount, limitPrice, deadline);
1496     }
1497 
1498     function getSellPrice(uint256 amount) internal returns (uint256 price) {
1499         uint256 x;
1500         uint256 y;
1501         (x, y) = currentXY();
1502         require(y != 0 && x != 0, "empty pool");
1503         return x.wdiv(y.add(amount));
1504     }
1505 
1506     function sellFrom(address trader, uint256 amount, uint256 limitPrice, uint256 deadline) private returns (uint256) {
1507         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1508         require(amount.mod(perpetualProxy.tradingLotSize()) == 0, "invalid trading lot size");
1509 
1510         uint256 price = getSellPrice(amount);
1511         require(limitPrice <= price, "price limited");
1512         require(getBlockTimestamp() <= deadline, "deadline exceeded");
1513         uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.SHORT, price, amount);
1514 
1515         uint256 value = price.wmul(amount);
1516         uint256 fee = value.wmul(governance.poolFeeRate);
1517         uint256 devFee = value.wmul(governance.poolDevFeeRate);
1518         address devAddress = perpetualProxy.devAddress();
1519         perpetualProxy.transferBalanceIn(trader, fee);
1520         perpetualProxy.transferBalanceTo(trader, devAddress, devFee);
1521 
1522         forceFunding(); // x, y changed, so fair price changed. we need funding now
1523         mustSafe(trader, opened);
1524         return opened;
1525     }
1526 
1527     function sellFromWhitelisted(address trader, uint256 amount, uint256 limitPrice, uint256 deadline)
1528         public
1529         onlyWhitelisted
1530         returns (uint256)
1531     {
1532         return sellFrom(trader, amount, limitPrice, deadline);
1533     }
1534 
1535     function sell(uint256 amount, uint256 limitPrice, uint256 deadline) public onlyBroker returns (uint256) {
1536         return sellFrom(msg.sender, amount, limitPrice, deadline);
1537     }
1538 
1539     // sell amount, pay 2 * amount * price collateral
1540     function addLiquidity(uint256 amount) public onlyBroker {
1541         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1542         require(amount.mod(perpetualProxy.lotSize()) == 0, "invalid lot size");
1543 
1544         uint256 oldAvailableMargin;
1545         uint256 oldPoolPositionSize;
1546         (oldAvailableMargin, oldPoolPositionSize) = currentXY();
1547         require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");
1548 
1549         address trader = msg.sender;
1550         uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);
1551 
1552         uint256 collateralAmount = amount.wmul(price).mul(2);
1553         perpetualProxy.transferBalanceIn(trader, collateralAmount);
1554         uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.SHORT, price, amount);
1555 
1556         mintShareTokenTo(trader, shareToken.totalSupply().wmul(amount).wdiv(oldPoolPositionSize));
1557 
1558         forceFunding(); // x, y changed, so fair price changed. we need funding now
1559         mustSafe(trader, opened);
1560     }
1561 
1562     function removeLiquidity(uint256 shareAmount) public onlyBroker {
1563         require(perpetualProxy.status() == LibTypes.Status.NORMAL, "wrong perpetual status");
1564 
1565         address trader = msg.sender;
1566         uint256 oldAvailableMargin;
1567         uint256 oldPoolPositionSize;
1568         (oldAvailableMargin, oldPoolPositionSize) = currentXY();
1569         require(oldPoolPositionSize != 0 && oldAvailableMargin != 0, "empty pool");
1570         require(shareToken.balanceOf(msg.sender) >= shareAmount, "shareBalance limited");
1571         uint256 price = oldAvailableMargin.wdiv(oldPoolPositionSize);
1572         uint256 amount = shareAmount.wmul(oldPoolPositionSize).wdiv(shareToken.totalSupply());
1573         amount = amount.sub(amount.mod(perpetualProxy.lotSize()));
1574 
1575         perpetualProxy.transferBalanceOut(trader, price.wmul(amount).mul(2));
1576         burnShareTokenFrom(trader, shareAmount);
1577         uint256 opened = perpetualProxy.trade(trader, LibTypes.Side.LONG, price, amount);
1578 
1579         forceFunding(); // x, y changed, so fair price changed. we need funding now
1580         mustSafe(trader, opened);
1581     }
1582 
1583     function settleShare() public {
1584         require(perpetualProxy.status() == LibTypes.Status.SETTLED, "wrong perpetual status");
1585 
1586         address trader = msg.sender;
1587         IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
1588         uint256 total = availableMarginFromPoolAccount(pool);
1589         uint256 shareAmount = shareToken.balanceOf(trader);
1590         uint256 balance = shareAmount.wmul(total).wdiv(shareToken.totalSupply());
1591         perpetualProxy.transferBalanceOut(trader, balance);
1592         burnShareTokenFrom(trader, shareAmount);
1593     }
1594 
1595     // this is a composite function of perp.setBroker + perp.deposit + amm.buy
1596     // composite functions accept amount = 0
1597     function depositAndBuy(uint256 depositAmount, uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public {
1598         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1599         if (depositAmount > 0) {
1600             perpetualProxy.depositFor(msg.sender, depositAmount);
1601         }
1602         if (tradeAmount > 0) {
1603             buy(tradeAmount, limitPrice, deadline);
1604         }
1605     }
1606 
1607     // this is a composite function of perp.setBroker + perp.depositEther + amm.buy
1608     // composite functions accept amount = 0
1609     function depositEtherAndBuy(uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public payable {
1610         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1611         if (msg.value > 0) {
1612             perpetualProxy.depositEtherFor.value(msg.value)(msg.sender);
1613         }
1614         if (tradeAmount > 0) {
1615             buy(tradeAmount, limitPrice, deadline);
1616         }
1617     }
1618 
1619     // this is a composite function of perp.setBroker + perp.deposit + amm.sell
1620     // composite functions accept amount = 0
1621     function depositAndSell(uint256 depositAmount, uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public {
1622         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1623         if (depositAmount > 0) {
1624             perpetualProxy.depositFor(msg.sender, depositAmount);
1625         }
1626         if (tradeAmount > 0) {
1627             sell(tradeAmount, limitPrice, deadline);
1628         }
1629     }
1630 
1631     // this is a composite function of perp.setBroker + perp.depositEther + amm.sell
1632     // composite functions accept amount = 0
1633     function depositEtherAndSell(uint256 tradeAmount, uint256 limitPrice, uint256 deadline) public payable {
1634         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1635         if (msg.value > 0) {
1636             perpetualProxy.depositEtherFor.value(msg.value)(msg.sender);
1637         }
1638         if (tradeAmount > 0) {
1639             sell(tradeAmount, limitPrice, deadline);
1640         }
1641     }
1642 
1643     // this is a composite function of perp.setBroker + amm.buy + perp.withdraw
1644     // composite functions accept amount = 0
1645     function buyAndWithdraw(uint256 tradeAmount, uint256 limitPrice, uint256 deadline, uint256 withdrawAmount) public {
1646         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1647         if (tradeAmount > 0) {
1648             buy(tradeAmount, limitPrice, deadline);
1649         }
1650         if (withdrawAmount > 0) {
1651             perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
1652         }
1653     }
1654 
1655     // this is a composite function of perp.setBroker + amm.sell + perp.withdraw
1656     // composite functions accept amount = 0
1657     function sellAndWithdraw(uint256 tradeAmount, uint256 limitPrice, uint256 deadline, uint256 withdrawAmount) public {
1658         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1659         if (tradeAmount > 0) {
1660             sell(tradeAmount, limitPrice, deadline);
1661         }
1662         if (withdrawAmount > 0) {
1663             perpetualProxy.withdrawFor(msg.sender, withdrawAmount);
1664         }
1665     }
1666 
1667     // this is a composite function of perp.deposit + perp.setBroker + amm.addLiquidity
1668     // composite functions accept amount = 0
1669     function depositAndAddLiquidity(uint256 depositAmount, uint256 amount) public {
1670         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1671         if (depositAmount > 0) {
1672             perpetualProxy.depositFor(msg.sender, depositAmount);
1673         }
1674         if (amount > 0) {
1675             addLiquidity(amount);
1676         }
1677     }
1678 
1679     // this is a composite function of perp.deposit + perp.setBroker + amm.addLiquidity
1680     // composite functions accept amount = 0
1681     function depositEtherAndAddLiquidity(uint256 amount) public payable {
1682         perpetualProxy.setBrokerFor(msg.sender, authorizedBroker());
1683         if (msg.value > 0) {
1684             perpetualProxy.depositEtherFor.value(msg.value)(msg.sender);
1685         }
1686         if (amount > 0) {
1687             addLiquidity(amount);
1688         }
1689     }
1690 
1691     function updateIndex() public {
1692         uint256 oldIndexPrice = fundingState.lastIndexPrice;
1693         forceFunding();
1694         address devAddress = perpetualProxy.devAddress();
1695         if (oldIndexPrice != fundingState.lastIndexPrice) {
1696             perpetualProxy.transferBalanceTo(devAddress, msg.sender, governance.updatePremiumPrize);
1697             require(perpetualProxy.isSafe(devAddress), "dev unsafe");
1698         }
1699     }
1700 
1701     function initFunding(uint256 newIndexPrice, uint256 blockTime) private {
1702         require(fundingState.lastFundingTime == 0, "initalready initialized");
1703         fundingState.lastFundingTime = blockTime;
1704         fundingState.lastIndexPrice = newIndexPrice;
1705         fundingState.lastPremium = 0;
1706         fundingState.lastEMAPremium = 0;
1707     }
1708 
1709     // changing conditions for funding:
1710     // condition 1: time
1711     // condition 2: indexPrice
1712     // condition 3: fairPrice - hand over to forceFunding
1713     function funding() public {
1714         uint256 blockTime = getBlockTimestamp();
1715         uint256 newIndexPrice;
1716         uint256 newIndexTimestamp;
1717         (newIndexPrice, newIndexTimestamp) = indexPrice();
1718         if (
1719             blockTime != fundingState.lastFundingTime || // condition 1
1720             newIndexPrice != fundingState.lastIndexPrice || // condition 2, especially when updateIndex and buy/sell are in the same block
1721             newIndexTimestamp > fundingState.lastFundingTime // condition 2
1722         ) {
1723             forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
1724         }
1725     }
1726 
1727     // Internal helpers
1728 
1729     // in order to mock the block.timestamp
1730     function getBlockTimestamp() internal view returns (uint256) {
1731         // solium-disable-next-line security/no-block-members
1732         return block.timestamp;
1733     }
1734 
1735     // a gas-optimized version of currentAvailableMargin() + positionSize(). almost all formulas require these two
1736     function currentXY() internal returns (uint256 x, uint256 y) {
1737         funding();
1738         IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
1739         x = availableMarginFromPoolAccount(pool);
1740         y = pool.positionSize;
1741     }
1742 
1743     // a gas-optimized version of lastAvailableMargin()
1744     function availableMarginFromPoolAccount(IPerpetualProxy.PoolAccount memory pool) internal view returns (uint256) {
1745         int256 available = pool.cashBalance;
1746         available = available.sub(pool.positionEntryValue.toInt256());
1747         available = available.sub(
1748             pool.socialLossPerContract.wmul(pool.positionSize.toInt256()).sub(pool.positionEntrySocialLoss)
1749         );
1750         available = available.sub(
1751             fundingState.accumulatedFundingPerContract.wmul(pool.positionSize.toInt256()).sub(
1752                 pool.positionEntryFundingLoss
1753             )
1754         );
1755         return available.max(0).toUint256();
1756     }
1757 
1758     // a gas-optimized version of lastFairPrice
1759     function fairPriceFromPoolAccount(IPerpetualProxy.PoolAccount memory pool) internal view returns (uint256) {
1760         uint256 y = pool.positionSize;
1761         require(y > 0, "funding initialization required");
1762         uint256 x = availableMarginFromPoolAccount(pool);
1763         return x.wdiv(y);
1764     }
1765 
1766     // a gas-optimized version of lastPremium
1767     function premiumFromPoolAccount(IPerpetualProxy.PoolAccount memory pool) internal view returns (int256) {
1768         int256 p = fairPriceFromPoolAccount(pool).toInt256();
1769         p = p.sub(fundingState.lastIndexPrice.toInt256());
1770         return p;
1771     }
1772 
1773     function mustSafe(address trader, uint256 opened) internal {
1774         // perpetual.markPrice is a little different from ours
1775         uint256 perpetualMarkPrice = perpetualProxy.markPrice();
1776         if (opened > 0) {
1777             require(perpetualProxy.isIMSafeWithPrice(trader, perpetualMarkPrice), "im unsafe");
1778         }
1779         require(perpetualProxy.isSafeWithPrice(trader, perpetualMarkPrice), "sender unsafe");
1780         require(perpetualProxy.isProxySafeWithPrice(perpetualMarkPrice), "amm unsafe");
1781     }
1782 
1783     function mintShareTokenTo(address guy, uint256 amount) internal {
1784         shareToken.mint(guy, amount);
1785     }
1786 
1787     function burnShareTokenFrom(address guy, uint256 amount) internal {
1788         shareToken.burn(guy, amount);
1789     }
1790 
1791     function forceFunding() internal {
1792         uint256 blockTime = getBlockTimestamp();
1793         uint256 newIndexPrice;
1794         uint256 newIndexTimestamp;
1795         (newIndexPrice, newIndexTimestamp) = indexPrice();
1796         forceFunding(blockTime, newIndexPrice, newIndexTimestamp);
1797     }
1798 
1799     function forceFunding(uint256 blockTime, uint256 newIndexPrice, uint256 newIndexTimestamp) internal {
1800         if (fundingState.lastFundingTime == 0) {
1801             // funding initialization required. but in this case, it's safe to just do nothing and return
1802             return;
1803         }
1804         IPerpetualProxy.PoolAccount memory pool = perpetualProxy.getPoolAccount();
1805         if (pool.positionSize == 0) {
1806             // empty pool. it's safe to just do nothing and return
1807             return;
1808         }
1809 
1810         if (newIndexTimestamp > fundingState.lastFundingTime) {
1811             // the 1st update
1812             nextStateWithTimespan(pool, newIndexPrice, newIndexTimestamp);
1813         }
1814         // the 2nd update;
1815         nextStateWithTimespan(pool, newIndexPrice, blockTime);
1816 
1817         emit UpdateFundingRate(fundingState);
1818     }
1819 
1820     function nextStateWithTimespan(IPerpetualProxy.PoolAccount memory pool, uint256 newIndexPrice, uint256 endTimestamp)
1821         private
1822     {
1823         require(fundingState.lastFundingTime != 0, "funding initialization required");
1824         require(endTimestamp >= fundingState.lastFundingTime, "we can't go back in time");
1825 
1826         // update ema
1827         if (fundingState.lastFundingTime != endTimestamp) {
1828             int256 timeDelta = endTimestamp.sub(fundingState.lastFundingTime).toInt256();
1829             int256 acc;
1830             (fundingState.lastEMAPremium, acc) = getAccumulatedFunding(
1831                 timeDelta,
1832                 fundingState.lastEMAPremium,
1833                 fundingState.lastPremium,
1834                 fundingState.lastIndexPrice.toInt256() // ema is according to the old index
1835             );
1836             fundingState.accumulatedFundingPerContract = fundingState.accumulatedFundingPerContract.add(
1837                 acc.div(8 * 3600)
1838             ); // ema is according to the old index
1839             fundingState.lastFundingTime = endTimestamp;
1840         }
1841 
1842         // always update
1843         fundingState.lastIndexPrice = newIndexPrice; // should update before premium()
1844         fundingState.lastPremium = premiumFromPoolAccount(pool);
1845     }
1846 
1847     // solve t in emaPremium == y equation
1848     function timeOnFundingCurve(
1849         int256 y,
1850         int256 v0, // lastEMAPremium
1851         int256 _lastPremium
1852     )
1853         internal
1854         view
1855         returns (
1856             int256 t // normal int, not WAD
1857         )
1858     {
1859         require(y != _lastPremium, "no solution 1 on funding curve");
1860         t = y.sub(_lastPremium);
1861         t = t.wdiv(v0.sub(_lastPremium));
1862         require(t > 0, "no solution 2 on funding curve");
1863         require(t < ONE_WAD_S, "no solution 3 on funding curve");
1864         t = t.wln();
1865         t = t.wdiv(emaAlpha2Ln);
1866         t = t.ceil(ONE_WAD_S) / ONE_WAD_S;
1867     }
1868 
1869     // sum emaPremium curve between [x, y)
1870     function integrateOnFundingCurve(
1871         int256 x, // normal int, not WAD
1872         int256 y, // normal int, not WAD
1873         int256 v0, // lastEMAPremium
1874         int256 _lastPremium
1875     ) internal view returns (int256 r) {
1876         require(x <= y, "integrate reversed");
1877         r = v0.sub(_lastPremium);
1878         r = r.wmul(emaAlpha2.wpowi(x).sub(emaAlpha2.wpowi(y)));
1879         r = r.wdiv(governance.emaAlpha);
1880         r = r.add(_lastPremium.mul(y.sub(x)));
1881     }
1882 
1883     struct AccumulatedFundingCalculator {
1884         int256 vLimit;
1885         int256 vDampener;
1886         int256 t1; // normal int, not WAD
1887         int256 t2; // normal int, not WAD
1888         int256 t3; // normal int, not WAD
1889         int256 t4; // normal int, not WAD
1890     }
1891 
1892     function getAccumulatedFunding(
1893         int256 n, // time span. normal int, not WAD
1894         int256 v0, // lastEMAPremium
1895         int256 _lastPremium,
1896         int256 _lastIndexPrice
1897     )
1898         internal
1899         view
1900         returns (
1901             int256 vt, // new LastEMAPremium
1902             int256 acc
1903         )
1904     {
1905         require(n > 0, "we can't go back in time");
1906         AccumulatedFundingCalculator memory ctx;
1907         vt = v0.sub(_lastPremium);
1908         vt = vt.wmul(emaAlpha2.wpowi(n));
1909         vt = vt.add(_lastPremium);
1910         ctx.vLimit = governance.markPremiumLimit.wmul(_lastIndexPrice);
1911         ctx.vDampener = governance.fundingDampener.wmul(_lastIndexPrice);
1912         if (v0 <= -ctx.vLimit) {
1913             // part A
1914             if (vt <= -ctx.vLimit) {
1915                 acc = (-ctx.vLimit).add(ctx.vDampener).mul(n);
1916             } else if (vt <= -ctx.vDampener) {
1917                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
1918                 acc = (-ctx.vLimit).mul(ctx.t1);
1919                 acc = acc.add(integrateOnFundingCurve(ctx.t1, n, v0, _lastPremium));
1920                 acc = acc.add(ctx.vDampener.mul(n));
1921             } else if (vt <= ctx.vDampener) {
1922                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
1923                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1924                 acc = (-ctx.vLimit).mul(ctx.t1);
1925                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
1926                 acc = acc.add(ctx.vDampener.mul(ctx.t2));
1927             } else if (vt <= ctx.vLimit) {
1928                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
1929                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1930                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
1931                 acc = (-ctx.vLimit).mul(ctx.t1);
1932                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
1933                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
1934                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
1935             } else {
1936                 ctx.t1 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
1937                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1938                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
1939                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
1940                 acc = (-ctx.vLimit).mul(ctx.t1);
1941                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
1942                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
1943                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
1944                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
1945             }
1946         } else if (v0 <= -ctx.vDampener) {
1947             // part B
1948             if (vt <= -ctx.vLimit) {
1949                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
1950                 acc = integrateOnFundingCurve(0, ctx.t4, v0, _lastPremium);
1951                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
1952                 acc = acc.add(ctx.vDampener.mul(n));
1953             } else if (vt <= -ctx.vDampener) {
1954                 acc = integrateOnFundingCurve(0, n, v0, _lastPremium);
1955                 acc = acc.add(ctx.vDampener.mul(n));
1956             } else if (vt <= ctx.vDampener) {
1957                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1958                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
1959                 acc = acc.add(ctx.vDampener.mul(ctx.t2));
1960             } else if (vt <= ctx.vLimit) {
1961                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1962                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
1963                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
1964                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
1965                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
1966             } else {
1967                 ctx.t2 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1968                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
1969                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
1970                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
1971                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
1972                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
1973                 acc = acc.add(ctx.vDampener.mul(ctx.t2.sub(n).add(ctx.t3)));
1974             }
1975         } else if (v0 <= ctx.vDampener) {
1976             // part C
1977             if (vt <= -ctx.vLimit) {
1978                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1979                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
1980                 acc = integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium);
1981                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
1982                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3)));
1983             } else if (vt <= -ctx.vDampener) {
1984                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
1985                 acc = integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium);
1986                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3)));
1987             } else if (vt <= ctx.vDampener) {
1988                 acc = 0;
1989             } else if (vt <= ctx.vLimit) {
1990                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
1991                 acc = integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium);
1992                 acc = acc.sub(ctx.vDampener.mul(n.sub(ctx.t3)));
1993             } else {
1994                 ctx.t3 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
1995                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
1996                 acc = integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium);
1997                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
1998                 acc = acc.sub(ctx.vDampener.mul(n.sub(ctx.t3)));
1999             }
2000         } else if (v0 <= ctx.vLimit) {
2001             // part D
2002             if (vt <= -ctx.vLimit) {
2003                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2004                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2005                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2006                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2007                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
2008                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
2009                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2010             } else if (vt <= -ctx.vDampener) {
2011                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2012                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2013                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2014                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
2015                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2016             } else if (vt <= ctx.vDampener) {
2017                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2018                 acc = integrateOnFundingCurve(0, ctx.t2, v0, _lastPremium);
2019                 acc = acc.sub(ctx.vDampener.mul(ctx.t2));
2020             } else if (vt <= ctx.vLimit) {
2021                 acc = integrateOnFundingCurve(0, n, v0, _lastPremium);
2022                 acc = acc.sub(ctx.vDampener.mul(n));
2023             } else {
2024                 ctx.t4 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2025                 acc = integrateOnFundingCurve(0, ctx.t4, v0, _lastPremium);
2026                 acc = acc.add(ctx.vLimit.mul(n.sub(ctx.t4)));
2027                 acc = acc.sub(ctx.vDampener.mul(n));
2028             }
2029         } else {
2030             // part E
2031             if (vt <= -ctx.vLimit) {
2032                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2033                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2034                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2035                 ctx.t4 = timeOnFundingCurve(-ctx.vLimit, v0, _lastPremium);
2036                 acc = ctx.vLimit.mul(ctx.t1);
2037                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2038                 acc = acc.add(integrateOnFundingCurve(ctx.t3, ctx.t4, v0, _lastPremium));
2039                 acc = acc.add((-ctx.vLimit).mul(n.sub(ctx.t4)));
2040                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2041             } else if (vt <= -ctx.vDampener) {
2042                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2043                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2044                 ctx.t3 = timeOnFundingCurve(-ctx.vDampener, v0, _lastPremium);
2045                 acc = ctx.vLimit.mul(ctx.t1);
2046                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2047                 acc = acc.add(integrateOnFundingCurve(ctx.t3, n, v0, _lastPremium));
2048                 acc = acc.add(ctx.vDampener.mul(n.sub(ctx.t3).sub(ctx.t2)));
2049             } else if (vt <= ctx.vDampener) {
2050                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2051                 ctx.t2 = timeOnFundingCurve(ctx.vDampener, v0, _lastPremium);
2052                 acc = ctx.vLimit.mul(ctx.t1);
2053                 acc = acc.add(integrateOnFundingCurve(ctx.t1, ctx.t2, v0, _lastPremium));
2054                 acc = acc.add(ctx.vDampener.mul(-ctx.t2));
2055             } else if (vt <= ctx.vLimit) {
2056                 ctx.t1 = timeOnFundingCurve(ctx.vLimit, v0, _lastPremium);
2057                 acc = ctx.vLimit.mul(ctx.t1);
2058                 acc = acc.add(integrateOnFundingCurve(ctx.t1, n, v0, _lastPremium));
2059                 acc = acc.sub(ctx.vDampener.mul(n));
2060             } else {
2061                 acc = ctx.vLimit.sub(ctx.vDampener).mul(n);
2062             }
2063         }
2064     } // getAccumulatedFunding
2065 }