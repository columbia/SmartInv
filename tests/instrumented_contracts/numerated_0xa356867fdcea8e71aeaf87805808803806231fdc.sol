1 // File: contracts/SmartRoute/intf/IDODOV2Proxy01.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 
12 
13 interface IDODOV2Proxy01 {
14     function dodoSwapV2ETHToToken(
15         address toToken,
16         uint256 minReturnAmount,
17         address[] memory dodoPairs,
18         uint256 directions,
19         bool isIncentive,
20         uint256 deadLine
21     ) external payable returns (uint256 returnAmount);
22 
23     function dodoSwapV2TokenToETH(
24         address fromToken,
25         uint256 fromTokenAmount,
26         uint256 minReturnAmount,
27         address[] memory dodoPairs,
28         uint256 directions,
29         bool isIncentive,
30         uint256 deadLine
31     ) external returns (uint256 returnAmount);
32 
33     function dodoSwapV2TokenToToken(
34         address fromToken,
35         address toToken,
36         uint256 fromTokenAmount,
37         uint256 minReturnAmount,
38         address[] memory dodoPairs,
39         uint256 directions,
40         bool isIncentive,
41         uint256 deadLine
42     ) external returns (uint256 returnAmount);
43 
44     function createDODOVendingMachine(
45         address baseToken,
46         address quoteToken,
47         uint256 baseInAmount,
48         uint256 quoteInAmount,
49         uint256 lpFeeRate,
50         uint256 i,
51         uint256 k,
52         bool isOpenTWAP,
53         uint256 deadLine
54     ) external payable returns (address newVendingMachine, uint256 shares);
55 
56     function addDVMLiquidity(
57         address dvmAddress,
58         uint256 baseInAmount,
59         uint256 quoteInAmount,
60         uint256 baseMinAmount,
61         uint256 quoteMinAmount,
62         uint8 flag, //  0 - ERC20, 1 - baseInETH, 2 - quoteInETH
63         uint256 deadLine
64     )
65         external
66         payable
67         returns (
68             uint256 shares,
69             uint256 baseAdjustedInAmount,
70             uint256 quoteAdjustedInAmount
71         );
72 
73     function createDODOPrivatePool(
74         address baseToken,
75         address quoteToken,
76         uint256 baseInAmount,
77         uint256 quoteInAmount,
78         uint256 lpFeeRate,
79         uint256 i,
80         uint256 k,
81         bool isOpenTwap,
82         uint256 deadLine
83     ) external payable returns (address newPrivatePool);
84 
85     function resetDODOPrivatePool(
86         address dppAddress,
87         uint256[] memory paramList,  //0 - newLpFeeRate, 1 - newI, 2 - newK
88         uint256[] memory amountList, //0 - baseInAmount, 1 - quoteInAmount, 2 - baseOutAmount, 3 - quoteOutAmount
89         uint8 flag, // 0 - ERC20, 1 - baseInETH, 2 - quoteInETH, 3 - baseOutETH, 4 - quoteOutETH
90         uint256 minBaseReserve,
91         uint256 minQuoteReserve,
92         uint256 deadLine
93     ) external payable;
94 
95     function createCrowdPooling(
96         address baseToken,
97         address quoteToken,
98         uint256 baseInAmount,
99         uint256[] memory timeLine,
100         uint256[] memory valueList,
101         bool isOpenTWAP,
102         uint256 deadLine
103     ) external payable returns (address payable newCrowdPooling);
104 
105     function bid(
106         address cpAddress,
107         uint256 quoteAmount,
108         uint8 flag, // 0 - ERC20, 1 - quoteInETH
109         uint256 deadLine
110     ) external payable;
111 
112     function addLiquidityToV1(
113         address pair,
114         uint256 baseAmount,
115         uint256 quoteAmount,
116         uint256 baseMinShares,
117         uint256 quoteMinShares,
118         uint8 flag, // 0 erc20 Out  1 baseInETH  2 quoteInETH 
119         uint256 deadLine
120     ) external payable returns(uint256, uint256);
121 
122     function dodoSwapV1(
123         address fromToken,
124         address toToken,
125         uint256 fromTokenAmount,
126         uint256 minReturnAmount,
127         address[] memory dodoPairs,
128         uint256 directions,
129         bool isIncentive,
130         uint256 deadLine
131     ) external payable returns (uint256 returnAmount);
132 
133     function externalSwap(
134         address fromToken,
135         address toToken,
136         address approveTarget,
137         address to,
138         uint256 fromTokenAmount,
139         uint256 minReturnAmount,
140         bytes memory callDataConcat,
141         bool isIncentive,
142         uint256 deadLine
143     ) external payable returns (uint256 returnAmount);
144 
145     function mixSwap(
146         address fromToken,
147         address toToken,
148         uint256 fromTokenAmount,
149         uint256 minReturnAmount,
150         address[] memory mixAdapters,
151         address[] memory mixPairs,
152         address[] memory assetTo,
153         uint256 directions,
154         bool isIncentive,
155         uint256 deadLine
156     ) external payable returns (uint256 returnAmount);
157 
158 }
159 
160 // File: contracts/SmartRoute/intf/IDODOV2.sol
161 
162 
163 interface IDODOV2 {
164 
165     //========== Common ==================
166 
167     function sellBase(address to) external returns (uint256 receiveQuoteAmount);
168 
169     function sellQuote(address to) external returns (uint256 receiveBaseAmount);
170 
171     function getVaultReserve() external view returns (uint256 baseReserve, uint256 quoteReserve);
172 
173     function _BASE_TOKEN_() external view returns (address);
174 
175     function _QUOTE_TOKEN_() external view returns (address);
176 
177     function getPMMStateForCall() external view returns (
178             uint256 i,
179             uint256 K,
180             uint256 B,
181             uint256 Q,
182             uint256 B0,
183             uint256 Q0,
184             uint256 R
185     );
186 
187     function getUserFeeRate(address user) external view returns (uint256 lpFeeRate, uint256 mtFeeRate);
188 
189     
190     function getDODOPoolBidirection(address token0, address token1) external view returns (address[] memory, address[] memory);
191 
192     //========== DODOVendingMachine ========
193     
194     function createDODOVendingMachine(
195         address baseToken,
196         address quoteToken,
197         uint256 lpFeeRate,
198         uint256 i,
199         uint256 k,
200         bool isOpenTWAP
201     ) external returns (address newVendingMachine);
202     
203     function buyShares(address to) external returns (uint256,uint256,uint256);
204 
205 
206     //========== DODOPrivatePool ===========
207 
208     function createDODOPrivatePool() external returns (address newPrivatePool);
209 
210     function initDODOPrivatePool(
211         address dppAddress,
212         address creator,
213         address baseToken,
214         address quoteToken,
215         uint256 lpFeeRate,
216         uint256 k,
217         uint256 i,
218         bool isOpenTwap
219     ) external;
220 
221     function reset(
222         address operator,
223         uint256 newLpFeeRate,
224         uint256 newI,
225         uint256 newK,
226         uint256 baseOutAmount,
227         uint256 quoteOutAmount,
228         uint256 minBaseReserve,
229         uint256 minQuoteReserve
230     ) external returns (bool); 
231 
232 
233     function _OWNER_() external returns (address);
234     
235     //========== CrowdPooling ===========
236 
237     function createCrowdPooling() external returns (address payable newCrowdPooling);
238 
239     function initCrowdPooling(
240         address cpAddress,
241         address creator,
242         address baseToken,
243         address quoteToken,
244         uint256[] memory timeLine,
245         uint256[] memory valueList,
246         bool isOpenTWAP
247     ) external;
248 
249     function bid(address to) external;
250 }
251 
252 // File: contracts/SmartRoute/intf/IDODOV1.sol
253 
254 
255 interface IDODOV1 {
256     function init(
257         address owner,
258         address supervisor,
259         address maintainer,
260         address baseToken,
261         address quoteToken,
262         address oracle,
263         uint256 lpFeeRate,
264         uint256 mtFeeRate,
265         uint256 k,
266         uint256 gasPriceLimit
267     ) external;
268 
269     function transferOwnership(address newOwner) external;
270 
271     function claimOwnership() external;
272 
273     function sellBaseToken(
274         uint256 amount,
275         uint256 minReceiveQuote,
276         bytes calldata data
277     ) external returns (uint256);
278 
279     function buyBaseToken(
280         uint256 amount,
281         uint256 maxPayQuote,
282         bytes calldata data
283     ) external returns (uint256);
284 
285     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
286 
287     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
288 
289     function depositBaseTo(address to, uint256 amount) external returns (uint256);
290 
291     function withdrawBase(uint256 amount) external returns (uint256);
292 
293     function withdrawAllBase() external returns (uint256);
294 
295     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
296 
297     function withdrawQuote(uint256 amount) external returns (uint256);
298 
299     function withdrawAllQuote() external returns (uint256);
300 
301     function _BASE_CAPITAL_TOKEN_() external returns (address);
302 
303     function _QUOTE_CAPITAL_TOKEN_() external returns (address);
304 
305     function _BASE_TOKEN_() external view returns (address);
306 
307     function _QUOTE_TOKEN_() external view returns (address);
308 
309     function _R_STATUS_() external view returns (uint8);
310 
311     function _QUOTE_BALANCE_() external view returns (uint256);
312 
313     function _BASE_BALANCE_() external view returns (uint256);
314 
315     function _K_() external view returns (uint256);
316 
317     function _MT_FEE_RATE_() external view returns (uint256);
318 
319     function _LP_FEE_RATE_() external view returns (uint256);
320 
321     function getExpectedTarget() external view returns (uint256 baseTarget, uint256 quoteTarget);
322 
323     function getOraclePrice() external view returns (uint256);
324 
325     function getMidPrice() external view returns (uint256 midPrice); 
326 }
327 
328 // File: contracts/intf/IDODOApprove.sol
329 
330 
331 interface IDODOApprove {
332     function claimTokens(address token,address who,address dest,uint256 amount) external;
333     function getDODOProxy() external view returns (address);
334 }
335 
336 // File: contracts/lib/InitializableOwnable.sol
337 
338 
339 /**
340  * @title Ownable
341  * @author DODO Breeder
342  *
343  * @notice Ownership related functions
344  */
345 contract InitializableOwnable {
346     address public _OWNER_;
347     address public _NEW_OWNER_;
348     bool internal _INITIALIZED_;
349 
350     // ============ Events ============
351 
352     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     // ============ Modifiers ============
357 
358     modifier notInitialized() {
359         require(!_INITIALIZED_, "DODO_INITIALIZED");
360         _;
361     }
362 
363     modifier onlyOwner() {
364         require(msg.sender == _OWNER_, "NOT_OWNER");
365         _;
366     }
367 
368     // ============ Functions ============
369 
370     function initOwner(address newOwner) public notInitialized {
371         _INITIALIZED_ = true;
372         _OWNER_ = newOwner;
373     }
374 
375     function transferOwnership(address newOwner) public onlyOwner {
376         emit OwnershipTransferPrepared(_OWNER_, newOwner);
377         _NEW_OWNER_ = newOwner;
378     }
379 
380     function claimOwnership() public {
381         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
382         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
383         _OWNER_ = _NEW_OWNER_;
384         _NEW_OWNER_ = address(0);
385     }
386 }
387 
388 // File: contracts/SmartRoute/DODOApproveProxy.sol
389 
390 
391 
392 
393 interface IDODOApproveProxy {
394     function isAllowedProxy(address _proxy) external view returns (bool);
395     function claimTokens(address token,address who,address dest,uint256 amount) external;
396 }
397 
398 /**
399  * @title DODOApproveProxy
400  * @author DODO Breeder
401  *
402  * @notice Allow different version dodoproxy to claim from DODOApprove
403  */
404 contract DODOApproveProxy is InitializableOwnable {
405     
406     // ============ Storage ============
407     uint256 private constant _TIMELOCK_DURATION_ = 3 days;
408     mapping (address => bool) public _IS_ALLOWED_PROXY_;
409     uint256 public _TIMELOCK_;
410     address public _PENDING_ADD_DODO_PROXY_;
411     address public immutable _DODO_APPROVE_;
412 
413     // ============ Modifiers ============
414     modifier notLocked() {
415         require(
416             _TIMELOCK_ <= block.timestamp,
417             "SetProxy is timelocked"
418         );
419         _;
420     }
421 
422     constructor(address dodoApporve) public {
423         _DODO_APPROVE_ = dodoApporve;
424     }
425 
426     function init(address owner, address[] memory proxies) external {
427         initOwner(owner);
428         for(uint i = 0; i < proxies.length; i++) 
429             _IS_ALLOWED_PROXY_[proxies[i]] = true;
430     }
431 
432     function unlockAddProxy(address newDodoProxy) public onlyOwner {
433         _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;
434         _PENDING_ADD_DODO_PROXY_ = newDodoProxy;
435     }
436 
437     function lockAddProxy() public onlyOwner {
438        _PENDING_ADD_DODO_PROXY_ = address(0);
439        _TIMELOCK_ = 0;
440     }
441 
442 
443     function addDODOProxy() external onlyOwner notLocked() {
444         _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;
445         lockAddProxy();
446     }
447 
448     function removeDODOProxy (address oldDodoProxy) public onlyOwner {
449         _IS_ALLOWED_PROXY_[oldDodoProxy] = false;
450     }
451     
452     function claimTokens(
453         address token,
454         address who,
455         address dest,
456         uint256 amount
457     ) external {
458         require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");
459         IDODOApprove(_DODO_APPROVE_).claimTokens(
460             token,
461             who,
462             dest,
463             amount
464         );
465     }
466 
467     function isAllowedProxy(address _proxy) external view returns (bool) {
468         return _IS_ALLOWED_PROXY_[_proxy];
469     }
470 }
471 
472 // File: contracts/lib/SafeMath.sol
473 
474 
475 
476 /**
477  * @title SafeMath
478  * @author DODO Breeder
479  *
480  * @notice Math operations with safety checks that revert on error
481  */
482 library SafeMath {
483     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
484         if (a == 0) {
485             return 0;
486         }
487 
488         uint256 c = a * b;
489         require(c / a == b, "MUL_ERROR");
490 
491         return c;
492     }
493 
494     function div(uint256 a, uint256 b) internal pure returns (uint256) {
495         require(b > 0, "DIVIDING_ERROR");
496         return a / b;
497     }
498 
499     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
500         uint256 quotient = div(a, b);
501         uint256 remainder = a - quotient * b;
502         if (remainder > 0) {
503             return quotient + 1;
504         } else {
505             return quotient;
506         }
507     }
508 
509     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
510         require(b <= a, "SUB_ERROR");
511         return a - b;
512     }
513 
514     function add(uint256 a, uint256 b) internal pure returns (uint256) {
515         uint256 c = a + b;
516         require(c >= a, "ADD_ERROR");
517         return c;
518     }
519 
520     function sqrt(uint256 x) internal pure returns (uint256 y) {
521         uint256 z = x / 2 + 1;
522         y = x;
523         while (z < y) {
524             y = z;
525             z = (x / z + z) / 2;
526         }
527     }
528 }
529 
530 // File: contracts/lib/DecimalMath.sol
531 
532 
533 
534 /**
535  * @title DecimalMath
536  * @author DODO Breeder
537  *
538  * @notice Functions for fixed point number with 18 decimals
539  */
540 library DecimalMath {
541     using SafeMath for uint256;
542 
543     uint256 internal constant ONE = 10**18;
544     uint256 internal constant ONE2 = 10**36;
545 
546     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
547         return target.mul(d) / (10**18);
548     }
549 
550     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
551         return target.mul(d).divCeil(10**18);
552     }
553 
554     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
555         return target.mul(10**18).div(d);
556     }
557 
558     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
559         return target.mul(10**18).divCeil(d);
560     }
561 
562     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
563         return uint256(10**36).div(target);
564     }
565 
566     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
567         return uint256(10**36).divCeil(target);
568     }
569 }
570 
571 // File: contracts/SmartRoute/helper/DODOSellHelper.sol
572 
573 
574 
575 
576 // import {DODOMath} from "../lib/DODOMath.sol";
577 
578 interface IDODOSellHelper {
579     function querySellQuoteToken(address dodo, uint256 amount) external view returns (uint256);
580     
581     function querySellBaseToken(address dodo, uint256 amount) external view returns (uint256);
582 }
583 
584 library DODOMath {
585     using SafeMath for uint256;
586 
587     /*
588         Integrate dodo curve fron V1 to V2
589         require V0>=V1>=V2>0
590         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
591         let V1-V2=delta
592         res = i*delta*(1-k+k(V0^2/V1/V2))
593     */
594     function _GeneralIntegrate(
595         uint256 V0,
596         uint256 V1,
597         uint256 V2,
598         uint256 i,
599         uint256 k
600     ) internal pure returns (uint256) {
601         uint256 fairAmount = DecimalMath.mulFloor(i, V1.sub(V2)); // i*delta
602         uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);
603         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
604         return DecimalMath.mulFloor(fairAmount, DecimalMath.ONE.sub(k).add(penalty));
605     }
606 
607     /*
608         The same with integration expression above, we have:
609         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
610         Given Q1 and deltaB, solve Q2
611         This is a quadratic function and the standard version is
612         aQ2^2 + bQ2 + c = 0, where
613         a=1-k
614         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
615         c=-kQ0^2
616         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
617         note: another root is negative, abondan
618         if deltaBSig=true, then Q2>Q1
619         if deltaBSig=false, then Q2<Q1
620     */
621     function _SolveQuadraticFunctionForTrade(
622         uint256 Q0,
623         uint256 Q1,
624         uint256 ideltaB,
625         bool deltaBSig,
626         uint256 k
627     ) internal pure returns (uint256) {
628         // calculate -b value and sig
629         // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB
630         uint256 kQ02Q1 = DecimalMath.mulFloor(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1
631         uint256 b = DecimalMath.mulFloor(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1
632         bool minusbSig = true;
633         if (deltaBSig) {
634             b = b.add(ideltaB); // (1-k)Q1+i*deltaB
635         } else {
636             kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1
637         }
638         if (b >= kQ02Q1) {
639             b = b.sub(kQ02Q1);
640             minusbSig = true;
641         } else {
642             b = kQ02Q1.sub(b);
643             minusbSig = false;
644         }
645 
646         // calculate sqrt
647         uint256 squareRoot = DecimalMath.mulFloor(
648             DecimalMath.ONE.sub(k).mul(4),
649             DecimalMath.mulFloor(k, Q0).mul(Q0)
650         ); // 4(1-k)kQ0^2
651         squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
652 
653         // final res
654         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
655         uint256 numerator;
656         if (minusbSig) {
657             numerator = b.add(squareRoot);
658         } else {
659             numerator = squareRoot.sub(b);
660         }
661 
662         if (deltaBSig) {
663             return DecimalMath.divFloor(numerator, denominator);
664         } else {
665             return DecimalMath.divCeil(numerator, denominator);
666         }
667     }
668 
669     /*
670         Start from the integration function
671         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
672         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
673         let fairAmount = i*deltaB
674     */
675     function _SolveQuadraticFunctionForTarget(
676         uint256 V1,
677         uint256 k,
678         uint256 fairAmount
679     ) internal pure returns (uint256 V0) {
680         // V0 = V1+V1*(sqrt-1)/2k
681         uint256 sqrt = DecimalMath.divCeil(DecimalMath.mulFloor(k, fairAmount).mul(4), V1);
682         sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();
683         uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));
684         // V0 is greater than or equal to V1 according to the solution
685         return DecimalMath.mulFloor(V1, DecimalMath.ONE.add(premium));
686     }
687 }
688 
689 contract DODOSellHelper {
690     using SafeMath for uint256;
691 
692     enum RStatus {ONE, ABOVE_ONE, BELOW_ONE}
693 
694     uint256 constant ONE = 10**18;
695 
696     struct DODOState {
697         uint256 oraclePrice;
698         uint256 K;
699         uint256 B;
700         uint256 Q;
701         uint256 baseTarget;
702         uint256 quoteTarget;
703         RStatus rStatus;
704     }
705 
706     function querySellBaseToken(address dodo, uint256 amount) public view returns (uint256) {
707         return IDODOV1(dodo).querySellBaseToken(amount);
708     }
709 
710     function querySellQuoteToken(address dodo, uint256 amount) public view returns (uint256) {
711         DODOState memory state;
712         (state.baseTarget, state.quoteTarget) = IDODOV1(dodo).getExpectedTarget();
713         state.rStatus = RStatus(IDODOV1(dodo)._R_STATUS_());
714         state.oraclePrice = IDODOV1(dodo).getOraclePrice();
715         state.Q = IDODOV1(dodo)._QUOTE_BALANCE_();
716         state.B = IDODOV1(dodo)._BASE_BALANCE_();
717         state.K = IDODOV1(dodo)._K_();
718 
719         uint256 boughtAmount;
720         // Determine the status (RStatus) and calculate the amount
721         // based on the state
722         if (state.rStatus == RStatus.ONE) {
723             boughtAmount = _ROneSellQuoteToken(amount, state);
724         } else if (state.rStatus == RStatus.ABOVE_ONE) {
725             boughtAmount = _RAboveSellQuoteToken(amount, state);
726         } else {
727             uint256 backOneBase = state.B.sub(state.baseTarget);
728             uint256 backOneQuote = state.quoteTarget.sub(state.Q);
729             if (amount <= backOneQuote) {
730                 boughtAmount = _RBelowSellQuoteToken(amount, state);
731             } else {
732                 boughtAmount = backOneBase.add(
733                     _ROneSellQuoteToken(amount.sub(backOneQuote), state)
734                 );
735             }
736         }
737         // Calculate fees
738         return
739             DecimalMath.divFloor(
740                 boughtAmount,
741                 DecimalMath.ONE.add(IDODOV1(dodo)._MT_FEE_RATE_()).add(
742                     IDODOV1(dodo)._LP_FEE_RATE_()
743                 )
744             );
745     }
746 
747     function _ROneSellQuoteToken(uint256 amount, DODOState memory state)
748         internal
749         pure
750         returns (uint256 receiveBaseToken)
751     {
752         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
753         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
754             state.baseTarget,
755             state.baseTarget,
756             DecimalMath.mulFloor(i, amount),
757             false,
758             state.K
759         );
760         return state.baseTarget.sub(B2);
761     }
762 
763     function _RAboveSellQuoteToken(uint256 amount, DODOState memory state)
764         internal
765         pure
766         returns (uint256 receieBaseToken)
767     {
768         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
769         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
770             state.baseTarget,
771             state.B,
772             DecimalMath.mulFloor(i, amount),
773             false,
774             state.K
775         );
776         return state.B.sub(B2);
777     }
778 
779     function _RBelowSellQuoteToken(uint256 amount, DODOState memory state)
780         internal
781         pure
782         returns (uint256 receiveBaseToken)
783     {
784         uint256 Q1 = state.Q.add(amount);
785         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
786         return DODOMath._GeneralIntegrate(state.quoteTarget, Q1, state.Q, i, state.K);
787     }
788 }
789 
790 // File: contracts/intf/IERC20.sol
791 
792 /**
793  * @dev Interface of the ERC20 standard as defined in the EIP.
794  */
795 interface IERC20 {
796     /**
797      * @dev Returns the amount of tokens in existence.
798      */
799     function totalSupply() external view returns (uint256);
800 
801     function decimals() external view returns (uint8);
802 
803     function name() external view returns (string memory);
804 
805     function symbol() external view returns (string memory);
806 
807     /**
808      * @dev Returns the amount of tokens owned by `account`.
809      */
810     function balanceOf(address account) external view returns (uint256);
811 
812     /**
813      * @dev Moves `amount` tokens from the caller's account to `recipient`.
814      *
815      * Returns a boolean value indicating whether the operation succeeded.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transfer(address recipient, uint256 amount) external returns (bool);
820 
821     /**
822      * @dev Returns the remaining number of tokens that `spender` will be
823      * allowed to spend on behalf of `owner` through {transferFrom}. This is
824      * zero by default.
825      *
826      * This value changes when {approve} or {transferFrom} are called.
827      */
828     function allowance(address owner, address spender) external view returns (uint256);
829 
830     /**
831      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
832      *
833      * Returns a boolean value indicating whether the operation succeeded.
834      *
835      * IMPORTANT: Beware that changing an allowance with this method brings the risk
836      * that someone may use both the old and the new allowance by unfortunate
837      * transaction ordering. One possible solution to mitigate this race
838      * condition is to first reduce the spender's allowance to 0 and set the
839      * desired value afterwards:
840      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
841      *
842      * Emits an {Approval} event.
843      */
844     function approve(address spender, uint256 amount) external returns (bool);
845 
846     /**
847      * @dev Moves `amount` tokens from `sender` to `recipient` using the
848      * allowance mechanism. `amount` is then deducted from the caller's
849      * allowance.
850      *
851      * Returns a boolean value indicating whether the operation succeeded.
852      *
853      * Emits a {Transfer} event.
854      */
855     function transferFrom(
856         address sender,
857         address recipient,
858         uint256 amount
859     ) external returns (bool);
860 }
861 
862 // File: contracts/intf/IWETH.sol
863 
864 
865 
866 interface IWETH {
867     function totalSupply() external view returns (uint256);
868 
869     function balanceOf(address account) external view returns (uint256);
870 
871     function transfer(address recipient, uint256 amount) external returns (bool);
872 
873     function allowance(address owner, address spender) external view returns (uint256);
874 
875     function approve(address spender, uint256 amount) external returns (bool);
876 
877     function transferFrom(
878         address src,
879         address dst,
880         uint256 wad
881     ) external returns (bool);
882 
883     function deposit() external payable;
884 
885     function withdraw(uint256 wad) external;
886 }
887 
888 // File: contracts/SmartRoute/intf/IUni.sol
889 
890 interface IUni {
891     function swapExactTokensForTokens(
892         uint amountIn,
893         uint amountOutMin,
894         address[] calldata path,
895         address to,
896         uint deadline
897     ) external returns (uint[] memory amounts);
898 
899     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
900 
901     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
902 
903     function token0() external view returns (address);
904     
905     function token1() external view returns (address);
906 }
907 
908 // File: contracts/SmartRoute/intf/IChi.sol
909 
910 
911 interface IChi {
912     function freeUpTo(uint256 value) external returns (uint256);
913 }
914 
915 // File: contracts/lib/SafeERC20.sol
916 
917 
918 
919 
920 /**
921  * @title SafeERC20
922  * @dev Wrappers around ERC20 operations that throw on failure (when the token
923  * contract returns false). Tokens that return no value (and instead revert or
924  * throw on failure) are also supported, non-reverting calls are assumed to be
925  * successful.
926  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
927  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
928  */
929 library SafeERC20 {
930     using SafeMath for uint256;
931 
932     function safeTransfer(
933         IERC20 token,
934         address to,
935         uint256 value
936     ) internal {
937         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
938     }
939 
940     function safeTransferFrom(
941         IERC20 token,
942         address from,
943         address to,
944         uint256 value
945     ) internal {
946         _callOptionalReturn(
947             token,
948             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
949         );
950     }
951 
952     function safeApprove(
953         IERC20 token,
954         address spender,
955         uint256 value
956     ) internal {
957         // safeApprove should only be called when setting an initial allowance,
958         // or when resetting it to zero. To increase and decrease it, use
959         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
960         // solhint-disable-next-line max-line-length
961         require(
962             (value == 0) || (token.allowance(address(this), spender) == 0),
963             "SafeERC20: approve from non-zero to non-zero allowance"
964         );
965         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
966     }
967 
968     /**
969      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
970      * on the return value: the return value is optional (but if data is returned, it must not be false).
971      * @param token The token targeted by the call.
972      * @param data The call data (encoded using abi.encode or one of its variants).
973      */
974     function _callOptionalReturn(IERC20 token, bytes memory data) private {
975         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
976         // we're implementing it ourselves.
977 
978         // A Solidity high level call has three parts:
979         //  1. The target address is checked to verify it contains contract code
980         //  2. The call itself is made, and success asserted
981         //  3. The return value is decoded, which in turn checks the size of the returned data.
982         // solhint-disable-next-line max-line-length
983 
984         // solhint-disable-next-line avoid-low-level-calls
985         (bool success, bytes memory returndata) = address(token).call(data);
986         require(success, "SafeERC20: low-level call failed");
987 
988         if (returndata.length > 0) {
989             // Return data is optional
990             // solhint-disable-next-line max-line-length
991             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
992         }
993     }
994 }
995 
996 // File: contracts/SmartRoute/lib/UniversalERC20.sol
997 
998 
999 
1000 
1001 
1002 library UniversalERC20 {
1003     using SafeMath for uint256;
1004     using SafeERC20 for IERC20;
1005 
1006     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1007 
1008     function universalTransfer(
1009         IERC20 token,
1010         address payable to,
1011         uint256 amount
1012     ) internal {
1013         if (amount > 0) {
1014             if (isETH(token)) {
1015                 to.transfer(amount);
1016             } else {
1017                 token.safeTransfer(to, amount);
1018             }
1019         }
1020     }
1021 
1022     function universalApproveMax(
1023         IERC20 token,
1024         address to,
1025         uint256 amount
1026     ) internal {
1027         uint256 allowance = token.allowance(address(this), to);
1028         if (allowance < amount) {
1029             if (allowance > 0) {
1030                 token.safeApprove(to, 0);
1031             }
1032             token.safeApprove(to, uint256(-1));
1033         }
1034     }
1035 
1036     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
1037         if (isETH(token)) {
1038             return who.balance;
1039         } else {
1040             return token.balanceOf(who);
1041         }
1042     }
1043 
1044     function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {
1045         return token.balanceOf(who);
1046     }
1047 
1048     function isETH(IERC20 token) internal pure returns (bool) {
1049         return token == ETH_ADDRESS;
1050     }
1051 }
1052 
1053 // File: contracts/lib/ReentrancyGuard.sol
1054 
1055 
1056 /**
1057  * @title ReentrancyGuard
1058  * @author DODO Breeder
1059  *
1060  * @notice Protect functions from Reentrancy Attack
1061  */
1062 contract ReentrancyGuard {
1063     // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
1064     // zero-state of _ENTERED_ is false
1065     bool private _ENTERED_;
1066 
1067     modifier preventReentrant() {
1068         require(!_ENTERED_, "REENTRANT");
1069         _ENTERED_ = true;
1070         _;
1071         _ENTERED_ = false;
1072     }
1073 }
1074 
1075 // File: contracts/DODOToken/DODOIncentive.sol
1076 
1077 
1078 
1079 
1080 interface IDODOIncentive {
1081     function triggerIncentive(
1082         address fromToken,
1083         address toToken,
1084         address assetTo
1085     ) external;
1086 }
1087 
1088 /**
1089  * @title DODOIncentive
1090  * @author DODO Breeder
1091  *
1092  * @notice Trade Incentive in DODO platform
1093  */
1094 contract DODOIncentive is InitializableOwnable {
1095     using SafeMath for uint256;
1096     using SafeERC20 for IERC20;
1097 
1098     // ============ Storage ============
1099     address public immutable _DODO_TOKEN_;
1100     address public _DODO_PROXY_;
1101     uint256 public dodoPerBlock;
1102     uint256 public defaultRate = 10;
1103     mapping(address => uint256) public boosts;
1104 
1105     uint32 public lastRewardBlock;
1106     uint112 public totalReward;
1107     uint112 public totalDistribution;
1108 
1109     // ============ Events ============
1110 
1111     event SetBoost(address token, uint256 boostRate);
1112     event SetNewProxy(address dodoProxy);
1113     event SetPerReward(uint256 dodoPerBlock);
1114     event SetDefaultRate(uint256 defaultRate);
1115     event Incentive(address user, uint256 reward);
1116 
1117     constructor(address _dodoToken) public {
1118         _DODO_TOKEN_ = _dodoToken;
1119     }
1120 
1121     // ============ Ownable ============
1122 
1123     function changeBoost(address _token, uint256 _boostRate) public onlyOwner {
1124         require(_token != address(0));
1125         require(_boostRate + defaultRate <= 1000);
1126         boosts[_token] = _boostRate;
1127         emit SetBoost(_token, _boostRate);
1128     }
1129 
1130     function changePerReward(uint256 _dodoPerBlock) public onlyOwner {
1131         _updateTotalReward();
1132         dodoPerBlock = _dodoPerBlock;
1133         emit SetPerReward(dodoPerBlock);
1134     }
1135 
1136     function changeDefaultRate(uint256 _defaultRate) public onlyOwner {
1137         defaultRate = _defaultRate;
1138         emit SetDefaultRate(defaultRate);
1139     }
1140 
1141     function changeDODOProxy(address _dodoProxy) public onlyOwner {
1142         _DODO_PROXY_ = _dodoProxy;
1143         emit SetNewProxy(_DODO_PROXY_);
1144     }
1145 
1146     function emptyReward(address assetTo) public onlyOwner {
1147         uint256 balance = IERC20(_DODO_TOKEN_).balanceOf(address(this));
1148         IERC20(_DODO_TOKEN_).transfer(assetTo, balance);
1149     }
1150 
1151     // ============ Incentive  function ============
1152 
1153     function triggerIncentive(
1154         address fromToken,
1155         address toToken,
1156         address assetTo
1157     ) external {
1158         require(msg.sender == _DODO_PROXY_, "DODOIncentive:Access restricted");
1159 
1160         uint256 curTotalDistribution = totalDistribution;
1161         uint256 fromRate = boosts[fromToken];
1162         uint256 toRate = boosts[toToken];
1163         uint256 rate = (fromRate >= toRate ? fromRate : toRate) + defaultRate;
1164         require(rate <= 1000, "RATE_INVALID");
1165         
1166         uint256 _totalReward = _getTotalReward();
1167         uint256 reward = ((_totalReward - curTotalDistribution) * rate) / 1000;
1168         uint256 _totalDistribution = curTotalDistribution + reward;
1169 
1170         _update(_totalReward, _totalDistribution);
1171         if (reward != 0) {
1172             IERC20(_DODO_TOKEN_).transfer(assetTo, reward);
1173             emit Incentive(assetTo, reward);
1174         }
1175     }
1176 
1177     function _updateTotalReward() internal {
1178         uint256 _totalReward = _getTotalReward();
1179         require(_totalReward < uint112(-1), "OVERFLOW");
1180         totalReward = uint112(_totalReward);
1181         lastRewardBlock = uint32(block.number);
1182     }
1183 
1184     function _update(uint256 _totalReward, uint256 _totalDistribution) internal {
1185         require(
1186             _totalReward < uint112(-1) && _totalDistribution < uint112(-1) && block.number < uint32(-1),
1187             "OVERFLOW"
1188         );
1189         lastRewardBlock = uint32(block.number);
1190         totalReward = uint112(_totalReward);
1191         totalDistribution = uint112(_totalDistribution);
1192     }
1193 
1194     function _getTotalReward() internal view returns (uint256) {
1195         if (lastRewardBlock == 0) {
1196             return totalReward;
1197         } else {
1198             return totalReward + (block.number - lastRewardBlock) * dodoPerBlock;
1199         }
1200     }
1201 
1202     // ============= Helper function ===============
1203 
1204     function incentiveStatus(address fromToken, address toToken)
1205         external
1206         view
1207         returns (
1208             uint256 reward,
1209             uint256 baseRate,
1210             uint256 totalRate,
1211             uint256 curTotalReward,
1212             uint256 perBlockReward
1213         )
1214     {
1215         baseRate = defaultRate;
1216         uint256 fromRate = boosts[fromToken];
1217         uint256 toRate = boosts[toToken];
1218         totalRate = (fromRate >= toRate ? fromRate : toRate) + defaultRate;
1219         uint256 _totalReward = _getTotalReward();
1220         reward = ((_totalReward - totalDistribution) * totalRate) / 1000;
1221         curTotalReward = _totalReward - totalDistribution;
1222         perBlockReward = dodoPerBlock;
1223     }
1224 }
1225 
1226 // File: contracts/SmartRoute/intf/IDODOAdapter.sol
1227 
1228 
1229 interface IDODOAdapter {
1230     
1231     function sellBase(address to, address pool) external;
1232 
1233     function sellQuote(address to, address pool) external;
1234 }
1235 
1236 // File: contracts/SmartRoute/DODOV2Proxy02.sol
1237 
1238 
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 
1253 /**
1254  * @title DODOV2Proxy02
1255  * @author DODO Breeder
1256  *
1257  * @notice Entrance of trading in DODO platform
1258  */
1259 contract DODOV2Proxy02 is IDODOV2Proxy01, ReentrancyGuard, InitializableOwnable {
1260     using SafeMath for uint256;
1261     using UniversalERC20 for IERC20;
1262 
1263     // ============ Storage ============
1264 
1265     address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1266     address public immutable _WETH_;
1267     address public immutable _DODO_APPROVE_PROXY_;
1268     address public immutable _DODO_SELL_HELPER_;
1269     address public immutable _DVM_FACTORY_;
1270     address public immutable _DPP_FACTORY_;
1271     address public immutable _CP_FACTORY_;
1272     address public immutable _DODO_INCENTIVE_;
1273     address public immutable _CHI_TOKEN_;
1274     uint256 public _GAS_DODO_MAX_RETURN_ = 0;
1275     uint256 public _GAS_EXTERNAL_RETURN_ = 0;
1276     mapping (address => bool) public isWhiteListed;
1277 
1278     // ============ Events ============
1279 
1280     event OrderHistory(
1281         address fromToken,
1282         address toToken,
1283         address sender,
1284         uint256 fromAmount,
1285         uint256 returnAmount
1286     );
1287 
1288     // ============ Modifiers ============
1289 
1290     modifier judgeExpired(uint256 deadLine) {
1291         require(deadLine >= block.timestamp, "DODOV2Proxy02: EXPIRED");
1292         _;
1293     }
1294 
1295     fallback() external payable {}
1296 
1297     receive() external payable {}
1298 
1299     constructor(
1300         address dvmFactory,
1301         address dppFactory,
1302         address cpFactory,
1303         address payable weth,
1304         address dodoApproveProxy,
1305         address dodoSellHelper,
1306         address chiToken,
1307         address dodoIncentive
1308     ) public {
1309         _DVM_FACTORY_ = dvmFactory;
1310         _DPP_FACTORY_ = dppFactory;
1311         _CP_FACTORY_ = cpFactory;
1312         _WETH_ = weth;
1313         _DODO_APPROVE_PROXY_ = dodoApproveProxy;
1314         _DODO_SELL_HELPER_ = dodoSellHelper;
1315         _CHI_TOKEN_ = chiToken;
1316         _DODO_INCENTIVE_ = dodoIncentive;
1317     }
1318 
1319     function addWhiteList (address contractAddr) public onlyOwner {
1320         isWhiteListed[contractAddr] = true;
1321     }
1322 
1323     function removeWhiteList (address contractAddr) public onlyOwner {
1324         isWhiteListed[contractAddr] = false;
1325     }
1326 
1327     function updateGasReturn(uint256 newDodoGasReturn, uint256 newExternalGasReturn) public onlyOwner {
1328         _GAS_DODO_MAX_RETURN_ = newDodoGasReturn;
1329         _GAS_EXTERNAL_RETURN_ = newExternalGasReturn;
1330     }
1331 
1332     // ============ DVM Functions (create & add liquidity) ============
1333 
1334     function createDODOVendingMachine(
1335         address baseToken,
1336         address quoteToken,
1337         uint256 baseInAmount,
1338         uint256 quoteInAmount,
1339         uint256 lpFeeRate,
1340         uint256 i,
1341         uint256 k,
1342         bool isOpenTWAP,
1343         uint256 deadLine
1344     )
1345         external
1346         override
1347         payable
1348         preventReentrant
1349         judgeExpired(deadLine)
1350         returns (address newVendingMachine, uint256 shares)
1351     {
1352         {
1353             address _baseToken = baseToken == _ETH_ADDRESS_ ? _WETH_ : baseToken;
1354             address _quoteToken = quoteToken == _ETH_ADDRESS_ ? _WETH_ : quoteToken;
1355             newVendingMachine = IDODOV2(_DVM_FACTORY_).createDODOVendingMachine(
1356                 _baseToken,
1357                 _quoteToken,
1358                 lpFeeRate,
1359                 i,
1360                 k,
1361                 isOpenTWAP
1362             );
1363         }
1364 
1365         {
1366             address _baseToken = baseToken;
1367             address _quoteToken = quoteToken;
1368             _deposit(
1369                 msg.sender,
1370                 newVendingMachine,
1371                 _baseToken,
1372                 baseInAmount,
1373                 _baseToken == _ETH_ADDRESS_
1374             );
1375             _deposit(
1376                 msg.sender,
1377                 newVendingMachine,
1378                 _quoteToken,
1379                 quoteInAmount,
1380                 _quoteToken == _ETH_ADDRESS_
1381             );
1382         }
1383 
1384         (shares, , ) = IDODOV2(newVendingMachine).buyShares(msg.sender);
1385     }
1386 
1387     function addDVMLiquidity(
1388         address dvmAddress,
1389         uint256 baseInAmount,
1390         uint256 quoteInAmount,
1391         uint256 baseMinAmount,
1392         uint256 quoteMinAmount,
1393         uint8 flag, // 0 - ERC20, 1 - baseInETH, 2 - quoteInETH
1394         uint256 deadLine
1395     )
1396         external
1397         override
1398         payable
1399         preventReentrant
1400         judgeExpired(deadLine)
1401         returns (
1402             uint256 shares,
1403             uint256 baseAdjustedInAmount,
1404             uint256 quoteAdjustedInAmount
1405         )
1406     {
1407         address _dvm = dvmAddress;
1408         (baseAdjustedInAmount, quoteAdjustedInAmount) = _addDVMLiquidity(
1409             _dvm,
1410             baseInAmount,
1411             quoteInAmount
1412         );
1413         require(
1414             baseAdjustedInAmount >= baseMinAmount && quoteAdjustedInAmount >= quoteMinAmount,
1415             "DODOV2Proxy02: deposit amount is not enough"
1416         );
1417 
1418         _deposit(msg.sender, _dvm, IDODOV2(_dvm)._BASE_TOKEN_(), baseAdjustedInAmount, flag == 1);
1419         _deposit(msg.sender, _dvm, IDODOV2(_dvm)._QUOTE_TOKEN_(), quoteAdjustedInAmount, flag == 2);
1420         
1421         (shares, , ) = IDODOV2(_dvm).buyShares(msg.sender);
1422         // refund dust eth
1423         if (flag == 1 && msg.value > baseAdjustedInAmount) msg.sender.transfer(msg.value - baseAdjustedInAmount);
1424         if (flag == 2 && msg.value > quoteAdjustedInAmount) msg.sender.transfer(msg.value - quoteAdjustedInAmount);
1425     }
1426 
1427     function _addDVMLiquidity(
1428         address dvmAddress,
1429         uint256 baseInAmount,
1430         uint256 quoteInAmount
1431     ) internal view returns (uint256 baseAdjustedInAmount, uint256 quoteAdjustedInAmount) {
1432         (uint256 baseReserve, uint256 quoteReserve) = IDODOV2(dvmAddress).getVaultReserve();
1433         if (quoteReserve == 0 && baseReserve == 0) {
1434             baseAdjustedInAmount = baseInAmount;
1435             quoteAdjustedInAmount = quoteInAmount;
1436         }
1437         if (quoteReserve == 0 && baseReserve > 0) {
1438             baseAdjustedInAmount = baseInAmount;
1439             quoteAdjustedInAmount = 0;
1440         }
1441         if (quoteReserve > 0 && baseReserve > 0) {
1442             uint256 baseIncreaseRatio = DecimalMath.divFloor(baseInAmount, baseReserve);
1443             uint256 quoteIncreaseRatio = DecimalMath.divFloor(quoteInAmount, quoteReserve);
1444             if (baseIncreaseRatio <= quoteIncreaseRatio) {
1445                 baseAdjustedInAmount = baseInAmount;
1446                 quoteAdjustedInAmount = DecimalMath.mulFloor(quoteReserve, baseIncreaseRatio);
1447             } else {
1448                 quoteAdjustedInAmount = quoteInAmount;
1449                 baseAdjustedInAmount = DecimalMath.mulFloor(baseReserve, quoteIncreaseRatio);
1450             }
1451         }
1452     }
1453 
1454     // ============ DPP Functions (create & reset) ============
1455 
1456     function createDODOPrivatePool(
1457         address baseToken,
1458         address quoteToken,
1459         uint256 baseInAmount,
1460         uint256 quoteInAmount,
1461         uint256 lpFeeRate,
1462         uint256 i,
1463         uint256 k,
1464         bool isOpenTwap,
1465         uint256 deadLine
1466     )
1467         external
1468         override
1469         payable
1470         preventReentrant
1471         judgeExpired(deadLine)
1472         returns (address newPrivatePool)
1473     {
1474         newPrivatePool = IDODOV2(_DPP_FACTORY_).createDODOPrivatePool();
1475 
1476         address _baseToken = baseToken;
1477         address _quoteToken = quoteToken;
1478         _deposit(msg.sender, newPrivatePool, _baseToken, baseInAmount, _baseToken == _ETH_ADDRESS_);
1479         _deposit(
1480             msg.sender,
1481             newPrivatePool,
1482             _quoteToken,
1483             quoteInAmount,
1484             _quoteToken == _ETH_ADDRESS_
1485         );
1486 
1487         if (_baseToken == _ETH_ADDRESS_) _baseToken = _WETH_;
1488         if (_quoteToken == _ETH_ADDRESS_) _quoteToken = _WETH_;
1489 
1490         IDODOV2(_DPP_FACTORY_).initDODOPrivatePool(
1491             newPrivatePool,
1492             msg.sender,
1493             _baseToken,
1494             _quoteToken,
1495             lpFeeRate,
1496             k,
1497             i,
1498             isOpenTwap
1499         );
1500     }
1501 
1502     function resetDODOPrivatePool(
1503         address dppAddress,
1504         uint256[] memory paramList,  //0 - newLpFeeRate, 1 - newI, 2 - newK
1505         uint256[] memory amountList, //0 - baseInAmount, 1 - quoteInAmount, 2 - baseOutAmount, 3- quoteOutAmount
1506         uint8 flag, // 0 - ERC20, 1 - baseInETH, 2 - quoteInETH, 3 - baseOutETH, 4 - quoteOutETH
1507         uint256 minBaseReserve,
1508         uint256 minQuoteReserve,
1509         uint256 deadLine
1510     ) external override payable preventReentrant judgeExpired(deadLine) {
1511         _deposit(
1512             msg.sender,
1513             dppAddress,
1514             IDODOV2(dppAddress)._BASE_TOKEN_(),
1515             amountList[0],
1516             flag == 1
1517         );
1518         _deposit(
1519             msg.sender,
1520             dppAddress,
1521             IDODOV2(dppAddress)._QUOTE_TOKEN_(),
1522             amountList[1],
1523             flag == 2
1524         );
1525 
1526         require(IDODOV2(IDODOV2(dppAddress)._OWNER_()).reset(
1527             msg.sender,
1528             paramList[0],
1529             paramList[1],
1530             paramList[2],
1531             amountList[2],
1532             amountList[3],
1533             minBaseReserve,
1534             minQuoteReserve
1535         ), "Reset Failed");
1536 
1537         _withdraw(msg.sender, IDODOV2(dppAddress)._BASE_TOKEN_(), amountList[2], flag == 3);
1538         _withdraw(msg.sender, IDODOV2(dppAddress)._QUOTE_TOKEN_(), amountList[3], flag == 4);
1539     }
1540 
1541     // ============ Swap ============
1542 
1543     function dodoSwapV2ETHToToken(
1544         address toToken,
1545         uint256 minReturnAmount,
1546         address[] memory dodoPairs,
1547         uint256 directions,
1548         bool isIncentive,
1549         uint256 deadLine
1550     )
1551         external
1552         override
1553         payable
1554         judgeExpired(deadLine)
1555         returns (uint256 returnAmount)
1556     {
1557         require(dodoPairs.length > 0, "DODOV2Proxy02: PAIRS_EMPTY");
1558         require(minReturnAmount > 0, "DODOV2Proxy02: RETURN_AMOUNT_ZERO");
1559         uint256 originGas = gasleft();
1560         
1561         uint256 originToTokenBalance = IERC20(toToken).balanceOf(msg.sender);
1562         IWETH(_WETH_).deposit{value: msg.value}();
1563         IWETH(_WETH_).transfer(dodoPairs[0], msg.value);
1564 
1565         for (uint256 i = 0; i < dodoPairs.length; i++) {
1566             if (i == dodoPairs.length - 1) {
1567                 if (directions & 1 == 0) {
1568                     IDODOV2(dodoPairs[i]).sellBase(msg.sender);
1569                 } else {
1570                     IDODOV2(dodoPairs[i]).sellQuote(msg.sender);
1571                 }
1572             } else {
1573                 if (directions & 1 == 0) {
1574                     IDODOV2(dodoPairs[i]).sellBase(dodoPairs[i + 1]);
1575                 } else {
1576                     IDODOV2(dodoPairs[i]).sellQuote(dodoPairs[i + 1]);
1577                 }
1578             }
1579             directions = directions >> 1;
1580         }
1581 
1582         returnAmount = IERC20(toToken).balanceOf(msg.sender).sub(originToTokenBalance);
1583         require(returnAmount >= minReturnAmount, "DODOV2Proxy02: Return amount is not enough");
1584 
1585         _dodoGasReturn(originGas);
1586 
1587         _execIncentive(isIncentive, _ETH_ADDRESS_, toToken);
1588 
1589         emit OrderHistory(
1590             _ETH_ADDRESS_,
1591             toToken,
1592             msg.sender,
1593             msg.value,
1594             returnAmount
1595         );
1596     }
1597 
1598     function dodoSwapV2TokenToETH(
1599         address fromToken,
1600         uint256 fromTokenAmount,
1601         uint256 minReturnAmount,
1602         address[] memory dodoPairs,
1603         uint256 directions,
1604         bool isIncentive,
1605         uint256 deadLine
1606     )
1607         external
1608         override
1609         judgeExpired(deadLine)
1610         returns (uint256 returnAmount)
1611     {
1612         require(dodoPairs.length > 0, "DODOV2Proxy02: PAIRS_EMPTY");
1613         require(minReturnAmount > 0, "DODOV2Proxy02: RETURN_AMOUNT_ZERO");
1614         uint256 originGas = gasleft();
1615         
1616         IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(fromToken, msg.sender, dodoPairs[0], fromTokenAmount);
1617 
1618         for (uint256 i = 0; i < dodoPairs.length; i++) {
1619             if (i == dodoPairs.length - 1) {
1620                 if (directions & 1 == 0) {
1621                     IDODOV2(dodoPairs[i]).sellBase(address(this));
1622                 } else {
1623                     IDODOV2(dodoPairs[i]).sellQuote(address(this));
1624                 }
1625             } else {
1626                 if (directions & 1 == 0) {
1627                     IDODOV2(dodoPairs[i]).sellBase(dodoPairs[i + 1]);
1628                 } else {
1629                     IDODOV2(dodoPairs[i]).sellQuote(dodoPairs[i + 1]);
1630                 }
1631             }
1632             directions = directions >> 1;
1633         }
1634         returnAmount = IWETH(_WETH_).balanceOf(address(this));
1635         require(returnAmount >= minReturnAmount, "DODOV2Proxy02: Return amount is not enough");
1636         IWETH(_WETH_).withdraw(returnAmount);
1637         msg.sender.transfer(returnAmount);
1638 
1639         _dodoGasReturn(originGas);
1640 
1641         _execIncentive(isIncentive, fromToken, _ETH_ADDRESS_);
1642 
1643         emit OrderHistory(
1644             fromToken,
1645             _ETH_ADDRESS_,
1646             msg.sender,
1647             fromTokenAmount,
1648             returnAmount
1649         );
1650     }
1651 
1652     function dodoSwapV2TokenToToken(
1653         address fromToken,
1654         address toToken,
1655         uint256 fromTokenAmount,
1656         uint256 minReturnAmount,
1657         address[] memory dodoPairs,
1658         uint256 directions,
1659         bool isIncentive,
1660         uint256 deadLine
1661     )
1662         external
1663         override
1664         judgeExpired(deadLine)
1665         returns (uint256 returnAmount)
1666     {
1667         require(dodoPairs.length > 0, "DODOV2Proxy02: PAIRS_EMPTY");
1668         require(minReturnAmount > 0, "DODOV2Proxy02: RETURN_AMOUNT_ZERO");
1669         uint256 originGas = gasleft();
1670 
1671         uint256 originToTokenBalance = IERC20(toToken).balanceOf(msg.sender);
1672         IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(fromToken, msg.sender, dodoPairs[0], fromTokenAmount);
1673 
1674         for (uint256 i = 0; i < dodoPairs.length; i++) {
1675             if (i == dodoPairs.length - 1) {
1676                 if (directions & 1 == 0) {
1677                     IDODOV2(dodoPairs[i]).sellBase(msg.sender);
1678                 } else {
1679                     IDODOV2(dodoPairs[i]).sellQuote(msg.sender);
1680                 }
1681             } else {
1682                 if (directions& 1 == 0) {
1683                     IDODOV2(dodoPairs[i]).sellBase(dodoPairs[i + 1]);
1684                 } else {
1685                     IDODOV2(dodoPairs[i]).sellQuote(dodoPairs[i + 1]);
1686                 }
1687             }
1688             directions = directions >> 1;
1689         }
1690         returnAmount = IERC20(toToken).balanceOf(msg.sender).sub(originToTokenBalance);
1691         require(returnAmount >= minReturnAmount, "DODOV2Proxy02: Return amount is not enough");
1692         
1693         _dodoGasReturn(originGas);
1694 
1695         _execIncentive(isIncentive, fromToken, toToken);
1696 
1697         emit OrderHistory(
1698             fromToken,
1699             toToken,
1700             msg.sender,
1701             fromTokenAmount,
1702             returnAmount
1703         );
1704     }
1705 
1706     function externalSwap(
1707         address fromToken,
1708         address toToken,
1709         address approveTarget,
1710         address swapTarget,
1711         uint256 fromTokenAmount,
1712         uint256 minReturnAmount,
1713         bytes memory callDataConcat,
1714         bool isIncentive,
1715         uint256 deadLine
1716     )
1717         external
1718         override
1719         payable
1720         judgeExpired(deadLine)
1721         returns (uint256 returnAmount)
1722     {
1723         require(minReturnAmount > 0, "DODOV2Proxy02: RETURN_AMOUNT_ZERO");
1724         require(fromToken != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_SELL_CHI");
1725         require(toToken != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_BUY_CHI");
1726         
1727         uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);
1728         if (fromToken != _ETH_ADDRESS_) {
1729             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
1730                 fromToken,
1731                 msg.sender,
1732                 address(this),
1733                 fromTokenAmount
1734             );
1735             IERC20(fromToken).universalApproveMax(approveTarget, fromTokenAmount);
1736         }
1737 
1738         require(isWhiteListed[swapTarget], "DODOV2Proxy02: Not Whitelist Contract");
1739         (bool success, ) = swapTarget.call{value: fromToken == _ETH_ADDRESS_ ? msg.value : 0}(callDataConcat);
1740 
1741         require(success, "DODOV2Proxy02: External Swap execution Failed");
1742 
1743         IERC20(toToken).universalTransfer(
1744             msg.sender,
1745             IERC20(toToken).universalBalanceOf(address(this))
1746         );
1747 
1748         returnAmount = IERC20(toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
1749         require(returnAmount >= minReturnAmount, "DODOV2Proxy02: Return amount is not enough");
1750 
1751         _externalGasReturn();
1752 
1753         _execIncentive(isIncentive, fromToken, toToken);
1754 
1755         emit OrderHistory(
1756             fromToken,
1757             toToken,
1758             msg.sender,
1759             fromTokenAmount,
1760             returnAmount
1761         );
1762     }
1763 
1764     function dodoSwapV1(
1765         address fromToken,
1766         address toToken,
1767         uint256 fromTokenAmount,
1768         uint256 minReturnAmount,
1769         address[] memory dodoPairs,
1770         uint256 directions,
1771         bool isIncentive,
1772         uint256 deadLine
1773     )
1774         external
1775         override
1776         payable
1777         judgeExpired(deadLine)
1778         returns (uint256 returnAmount)
1779     {
1780         require(dodoPairs.length > 0, "DODOV2Proxy02: PAIRS_EMPTY");
1781         require(minReturnAmount > 0, "DODOV2Proxy02: RETURN_AMOUNT_ZERO");
1782         require(fromToken != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_SELL_CHI");
1783         require(toToken != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_BUY_CHI");
1784         
1785         uint256 originGas = gasleft();
1786 
1787         address _fromToken = fromToken;
1788         address _toToken = toToken;
1789         
1790         _deposit(msg.sender, address(this), _fromToken, fromTokenAmount, _fromToken == _ETH_ADDRESS_);
1791 
1792         for (uint256 i = 0; i < dodoPairs.length; i++) {
1793             address curDodoPair = dodoPairs[i];
1794             if (directions & 1 == 0) {
1795                 address curDodoBase = IDODOV1(curDodoPair)._BASE_TOKEN_();
1796                 require(curDodoBase != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_CHI");
1797                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
1798                 IERC20(curDodoBase).universalApproveMax(curDodoPair, curAmountIn);
1799                 IDODOV1(curDodoPair).sellBaseToken(curAmountIn, 0, "");
1800             } else {
1801                 address curDodoQuote = IDODOV1(curDodoPair)._QUOTE_TOKEN_();
1802                 require(curDodoQuote != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_CHI");
1803                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
1804                 IERC20(curDodoQuote).universalApproveMax(curDodoPair, curAmountIn);
1805                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
1806                     curDodoPair,
1807                     curAmountIn
1808                 );
1809                 IDODOV1(curDodoPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
1810             }
1811             directions = directions >> 1;
1812         }
1813 
1814         
1815         if (_toToken == _ETH_ADDRESS_) {
1816             returnAmount = IWETH(_WETH_).balanceOf(address(this));
1817             IWETH(_WETH_).withdraw(returnAmount);
1818         } else {
1819             returnAmount = IERC20(_toToken).tokenBalanceOf(address(this));
1820         }
1821         
1822         require(returnAmount >= minReturnAmount, "DODOV2Proxy02: Return amount is not enough");
1823         IERC20(_toToken).universalTransfer(msg.sender, returnAmount);
1824 
1825         _dodoGasReturn(originGas);
1826 
1827         _execIncentive(isIncentive, _fromToken, _toToken);
1828 
1829         emit OrderHistory(_fromToken, _toToken, msg.sender, fromTokenAmount, returnAmount);
1830     }
1831 
1832 
1833     function mixSwap(
1834         address fromToken,
1835         address toToken,
1836         uint256 fromTokenAmount,
1837         uint256 minReturnAmount,
1838         address[] memory mixAdapters,
1839         address[] memory mixPairs,
1840         address[] memory assetTo,
1841         uint256 directions,
1842         bool isIncentive,
1843         uint256 deadLine
1844     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
1845         require(mixPairs.length > 0, "DODOV2Proxy02: PAIRS_EMPTY");
1846         require(mixPairs.length == mixAdapters.length, "DODOV2Proxy02: PAIR_ADAPTER_NOT_MATCH");
1847         require(mixPairs.length == assetTo.length - 1, "DODOV2Proxy02: PAIR_ASSETTO_NOT_MATCH");
1848         require(minReturnAmount > 0, "DODOV2Proxy02: RETURN_AMOUNT_ZERO");
1849 
1850         address _fromToken = fromToken;
1851         address _toToken = toToken;
1852         uint256 _fromTokenAmount = fromTokenAmount;
1853 
1854         require(_fromToken != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_SELL_CHI");
1855         require(_toToken != _CHI_TOKEN_, "DODOV2Proxy02: NOT_SUPPORT_BUY_CHI");
1856         
1857         uint256 originGas = gasleft();
1858         uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);
1859         
1860         _deposit(msg.sender, assetTo[0], _fromToken, _fromTokenAmount, _fromToken == _ETH_ADDRESS_);
1861 
1862         for (uint256 i = 0; i < mixPairs.length; i++) {
1863             if (directions & 1 == 0) {
1864                 IDODOAdapter(mixAdapters[i]).sellBase(assetTo[i + 1],mixPairs[i]);
1865             } else {
1866                 IDODOAdapter(mixAdapters[i]).sellQuote(assetTo[i + 1],mixPairs[i]);
1867             }
1868             directions = directions >> 1;
1869         }
1870 
1871         if(_toToken == _ETH_ADDRESS_) {
1872             returnAmount = IWETH(_WETH_).balanceOf(address(this));
1873             IWETH(_WETH_).withdraw(returnAmount);
1874             msg.sender.transfer(returnAmount);
1875         }else {
1876             returnAmount = IERC20(_toToken).tokenBalanceOf(msg.sender).sub(toTokenOriginBalance);
1877         }
1878 
1879         require(returnAmount >= minReturnAmount, "DODOV2Proxy02: Return amount is not enough");
1880         
1881         _dodoGasReturn(originGas);
1882 
1883         _execIncentive(isIncentive, _fromToken, _toToken);
1884 
1885         emit OrderHistory(
1886             _fromToken,
1887             _toToken,
1888             msg.sender,
1889             _fromTokenAmount,
1890             returnAmount
1891         );
1892     }
1893 
1894     //============ CrowdPooling Functions (create & bid) ============
1895 
1896     function createCrowdPooling(
1897         address baseToken,
1898         address quoteToken,
1899         uint256 baseInAmount,
1900         uint256[] memory timeLine,
1901         uint256[] memory valueList,
1902         bool isOpenTWAP,
1903         uint256 deadLine
1904     ) external override payable preventReentrant judgeExpired(deadLine) returns (address payable newCrowdPooling) {
1905         address _baseToken = baseToken;
1906         address _quoteToken = quoteToken == _ETH_ADDRESS_ ? _WETH_ : quoteToken;
1907         
1908         newCrowdPooling = IDODOV2(_CP_FACTORY_).createCrowdPooling();
1909 
1910         _deposit(
1911             msg.sender,
1912             newCrowdPooling,
1913             _baseToken,
1914             baseInAmount,
1915             false
1916         );
1917 
1918         newCrowdPooling.transfer(msg.value);
1919 
1920         IDODOV2(_CP_FACTORY_).initCrowdPooling(
1921             newCrowdPooling,
1922             msg.sender,
1923             _baseToken,
1924             _quoteToken,
1925             timeLine,
1926             valueList,
1927             isOpenTWAP
1928         );
1929     }
1930 
1931     function bid(
1932         address cpAddress,
1933         uint256 quoteAmount,
1934         uint8 flag, // 0 - ERC20, 1 - quoteInETH
1935         uint256 deadLine
1936     ) external override payable preventReentrant judgeExpired(deadLine) {
1937         _deposit(msg.sender, cpAddress, IDODOV2(cpAddress)._QUOTE_TOKEN_(), quoteAmount, flag == 1);
1938         IDODOV2(cpAddress).bid(msg.sender);
1939     }
1940 
1941 
1942     function addLiquidityToV1(
1943         address pair,
1944         uint256 baseAmount,
1945         uint256 quoteAmount,
1946         uint256 baseMinShares,
1947         uint256 quoteMinShares,
1948         uint8 flag, // 0 erc20 In  1 baseInETH  2 quoteIn ETH 
1949         uint256 deadLine
1950     ) external override payable preventReentrant judgeExpired(deadLine) returns(uint256 baseShares, uint256 quoteShares) {
1951         address _baseToken = IDODOV1(pair)._BASE_TOKEN_();
1952         address _quoteToken = IDODOV1(pair)._QUOTE_TOKEN_();
1953         
1954         _deposit(msg.sender, address(this), _baseToken, baseAmount, flag == 1);
1955         _deposit(msg.sender, address(this), _quoteToken, quoteAmount, flag == 2);
1956 
1957         
1958         if(baseAmount > 0) {
1959             IERC20(_baseToken).universalApproveMax(pair, baseAmount);
1960             baseShares = IDODOV1(pair).depositBaseTo(msg.sender, baseAmount);
1961         }
1962         if(quoteAmount > 0) {
1963             IERC20(_quoteToken).universalApproveMax(pair, quoteAmount);
1964             quoteShares = IDODOV1(pair).depositQuoteTo(msg.sender, quoteAmount);
1965         }
1966 
1967         require(baseShares >= baseMinShares && quoteShares >= quoteMinShares,"DODOV2Proxy02: Return DLP is not enough");
1968     }
1969     
1970 
1971     function _deposit(
1972         address from,
1973         address to,
1974         address token,
1975         uint256 amount,
1976         bool isETH
1977     ) internal {
1978         if (isETH) {
1979             if (amount > 0) {
1980                 IWETH(_WETH_).deposit{value: amount}();
1981                 if (to != address(this)) SafeERC20.safeTransfer(IERC20(_WETH_), to, amount);
1982             }
1983         } else {
1984             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(token, from, to, amount);
1985         }
1986     }
1987 
1988     function _withdraw(
1989         address payable to,
1990         address token,
1991         uint256 amount,
1992         bool isETH
1993     ) internal {
1994         if (isETH) {
1995             if (amount > 0) {
1996                 IWETH(_WETH_).withdraw(amount);
1997                 to.transfer(amount);
1998             }
1999         } else {
2000             if (amount > 0) {
2001                 SafeERC20.safeTransfer(IERC20(token), to, amount);
2002             }
2003         }
2004     }
2005 
2006     function _dodoGasReturn(uint256 originGas) internal {
2007         uint256 _gasDodoMaxReturn = _GAS_DODO_MAX_RETURN_;
2008         if(_gasDodoMaxReturn > 0) {
2009             uint256 calcGasTokenBurn = originGas.sub(gasleft()) / 65000;
2010             uint256 gasTokenBurn = calcGasTokenBurn > _gasDodoMaxReturn ? _gasDodoMaxReturn : calcGasTokenBurn;
2011             if(gasTokenBurn >= 3 && gasleft() > 27710 + gasTokenBurn * 6080)
2012                 IChi(_CHI_TOKEN_).freeUpTo(gasTokenBurn);
2013         }
2014     }
2015 
2016     function _externalGasReturn() internal {
2017         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
2018         if(_gasExternalReturn > 0) {
2019             if(gasleft() > 27710 + _gasExternalReturn * 6080)
2020                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
2021         }
2022     }
2023 
2024     function _execIncentive(bool isIncentive, address fromToken,address toToken) internal {
2025         if(isIncentive && gasleft() > 30000) {
2026             IDODOIncentive(_DODO_INCENTIVE_).triggerIncentive(fromToken, toToken, msg.sender);
2027         }
2028     }
2029 
2030 }