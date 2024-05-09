1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 library Types {
12     enum RStatus {ONE, ABOVE_ONE, BELOW_ONE}
13 }
14 
15 // File: contracts/intf/IERC20.sol
16 
17 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     function decimals() external view returns (uint8);
29 
30     function name() external view returns (string memory);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // File: contracts/lib/InitializableOwnable.sol
88 
89 /*
90 
91     Copyright 2020 DODO ZOO.
92 
93 */
94 
95 /**
96  * @title Ownable
97  * @author DODO Breeder
98  *
99  * @notice Ownership related functions
100  */
101 contract InitializableOwnable {
102     address public _OWNER_;
103     address public _NEW_OWNER_;
104 
105     // ============ Events ============
106 
107     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
108 
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     // ============ Modifiers ============
112 
113     modifier onlyOwner() {
114         require(msg.sender == _OWNER_, "NOT_OWNER");
115         _;
116     }
117 
118     // ============ Functions ============
119 
120     function transferOwnership(address newOwner) external onlyOwner {
121         require(newOwner != address(0), "INVALID_OWNER");
122         emit OwnershipTransferPrepared(_OWNER_, newOwner);
123         _NEW_OWNER_ = newOwner;
124     }
125 
126     function claimOwnership() external {
127         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
128         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
129         _OWNER_ = _NEW_OWNER_;
130         _NEW_OWNER_ = address(0);
131     }
132 }
133 
134 // File: contracts/lib/SafeMath.sol
135 
136 /*
137 
138     Copyright 2020 DODO ZOO.
139 
140 */
141 
142 /**
143  * @title SafeMath
144  * @author DODO Breeder
145  *
146  * @notice Math operations with safety checks that revert on error
147  */
148 library SafeMath {
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "MUL_ERROR");
156 
157         return c;
158     }
159 
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b > 0, "DIVIDING_ERROR");
162         return a / b;
163     }
164 
165     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 quotient = div(a, b);
167         uint256 remainder = a - quotient * b;
168         if (remainder > 0) {
169             return quotient + 1;
170         } else {
171             return quotient;
172         }
173     }
174 
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         require(b <= a, "SUB_ERROR");
177         return a - b;
178     }
179 
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         require(c >= a, "ADD_ERROR");
183         return c;
184     }
185 
186     function sqrt(uint256 x) internal pure returns (uint256 y) {
187         uint256 z = x / 2 + 1;
188         y = x;
189         while (z < y) {
190             y = z;
191             z = (x / z + z) / 2;
192         }
193     }
194 }
195 
196 // File: contracts/lib/DecimalMath.sol
197 
198 /*
199 
200     Copyright 2020 DODO ZOO.
201 
202 */
203 
204 /**
205  * @title DecimalMath
206  * @author DODO Breeder
207  *
208  * @notice Functions for fixed point number with 18 decimals
209  */
210 library DecimalMath {
211     using SafeMath for uint256;
212 
213     uint256 constant ONE = 10**18;
214 
215     function mul(uint256 target, uint256 d) internal pure returns (uint256) {
216         return target.mul(d) / ONE;
217     }
218 
219     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
220         return target.mul(ONE).div(d);
221     }
222 
223     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
224         return target.mul(ONE).divCeil(d);
225     }
226 }
227 
228 // File: contracts/lib/ReentrancyGuard.sol
229 
230 /*
231 
232     Copyright 2020 DODO ZOO.
233 
234 */
235 
236 /**
237  * @title ReentrancyGuard
238  * @author DODO Breeder
239  *
240  * @notice Protect functions from Reentrancy Attack
241  */
242 contract ReentrancyGuard {
243     // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
244     // zero-state of _ENTERED_ is false
245     bool private _ENTERED_;
246 
247     modifier preventReentrant() {
248         require(!_ENTERED_, "REENTRANT");
249         _ENTERED_ = true;
250         _;
251         _ENTERED_ = false;
252     }
253 }
254 
255 // File: contracts/intf/IOracle.sol
256 
257 /*
258 
259     Copyright 2020 DODO ZOO.
260 
261 */
262 
263 interface IOracle {
264     function getPrice() external view returns (uint256);
265 }
266 
267 // File: contracts/intf/IDODOLpToken.sol
268 
269 /*
270 
271     Copyright 2020 DODO ZOO.
272 
273 */
274 
275 interface IDODOLpToken {
276     function mint(address user, uint256 value) external;
277 
278     function burn(address user, uint256 value) external;
279 
280     function balanceOf(address owner) external view returns (uint256);
281 
282     function totalSupply() external view returns (uint256);
283 }
284 
285 // File: contracts/impl/Storage.sol
286 
287 /*
288 
289     Copyright 2020 DODO ZOO.
290 
291 */
292 
293 /**
294  * @title Storage
295  * @author DODO Breeder
296  *
297  * @notice Local Variables
298  */
299 contract Storage is InitializableOwnable, ReentrancyGuard {
300     using SafeMath for uint256;
301 
302     // ============ Variables for Control ============
303 
304     bool internal _INITIALIZED_;
305     bool public _CLOSED_;
306     bool public _DEPOSIT_QUOTE_ALLOWED_;
307     bool public _DEPOSIT_BASE_ALLOWED_;
308     bool public _TRADE_ALLOWED_;
309     uint256 public _GAS_PRICE_LIMIT_;
310 
311     // ============ Core Address ============
312 
313     address public _SUPERVISOR_; // could freeze system in emergency
314     address public _MAINTAINER_; // collect maintainer fee to buy food for DODO
315 
316     address public _BASE_TOKEN_;
317     address public _QUOTE_TOKEN_;
318     address public _ORACLE_;
319 
320     // ============ Variables for PMM Algorithm ============
321 
322     uint256 public _LP_FEE_RATE_;
323     uint256 public _MT_FEE_RATE_;
324     uint256 public _K_;
325 
326     Types.RStatus public _R_STATUS_;
327     uint256 public _TARGET_BASE_TOKEN_AMOUNT_;
328     uint256 public _TARGET_QUOTE_TOKEN_AMOUNT_;
329     uint256 public _BASE_BALANCE_;
330     uint256 public _QUOTE_BALANCE_;
331 
332     address public _BASE_CAPITAL_TOKEN_;
333     address public _QUOTE_CAPITAL_TOKEN_;
334 
335     // ============ Variables for Final Settlement ============
336 
337     uint256 public _BASE_CAPITAL_RECEIVE_QUOTE_;
338     uint256 public _QUOTE_CAPITAL_RECEIVE_BASE_;
339     mapping(address => bool) public _CLAIMED_;
340 
341     // ============ Modifiers ============
342 
343     modifier onlySupervisorOrOwner() {
344         require(msg.sender == _SUPERVISOR_ || msg.sender == _OWNER_, "NOT_SUPERVISOR_OR_OWNER");
345         _;
346     }
347 
348     modifier notClosed() {
349         require(!_CLOSED_, "DODO_CLOSED");
350         _;
351     }
352 
353     // ============ Helper Functions ============
354 
355     function _checkDODOParameters() internal view returns (uint256) {
356         require(_K_ < DecimalMath.ONE, "K>=1");
357         require(_K_ > 0, "K=0");
358         require(_LP_FEE_RATE_.add(_MT_FEE_RATE_) < DecimalMath.ONE, "FEE_RATE>=1");
359     }
360 
361     function getOraclePrice() public view returns (uint256) {
362         return IOracle(_ORACLE_).getPrice();
363     }
364 
365     function getBaseCapitalBalanceOf(address lp) public view returns (uint256) {
366         return IDODOLpToken(_BASE_CAPITAL_TOKEN_).balanceOf(lp);
367     }
368 
369     function getTotalBaseCapital() public view returns (uint256) {
370         return IDODOLpToken(_BASE_CAPITAL_TOKEN_).totalSupply();
371     }
372 
373     function getQuoteCapitalBalanceOf(address lp) public view returns (uint256) {
374         return IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).balanceOf(lp);
375     }
376 
377     function getTotalQuoteCapital() public view returns (uint256) {
378         return IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).totalSupply();
379     }
380 
381     // ============ Version Control ============
382     function version() external pure returns (uint256) {
383         return 100; // 1.0.0
384     }
385 }
386 
387 // File: contracts/intf/IDODOCallee.sol
388 
389 /*
390 
391     Copyright 2020 DODO ZOO.
392 
393 */
394 
395 interface IDODOCallee {
396     function dodoCall(
397         bool isBuyBaseToken,
398         uint256 baseAmount,
399         uint256 quoteAmount,
400         bytes calldata data
401     ) external;
402 }
403 
404 // File: contracts/lib/DODOMath.sol
405 
406 /*
407 
408     Copyright 2020 DODO ZOO.
409 
410 */
411 
412 /**
413  * @title DODOMath
414  * @author DODO Breeder
415  *
416  * @notice Functions for complex calculating. Including ONE Integration and TWO Quadratic solutions
417  */
418 library DODOMath {
419     using SafeMath for uint256;
420 
421     /*
422         Integrate dodo curve fron V1 to V2
423         require V0>=V1>=V2>0
424         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
425         let V1-V2=delta
426         res = i*delta*(1-k+k(V0^2/V1/V2))
427     */
428     function _GeneralIntegrate(
429         uint256 V0,
430         uint256 V1,
431         uint256 V2,
432         uint256 i,
433         uint256 k
434     ) internal pure returns (uint256) {
435         uint256 fairAmount = DecimalMath.mul(i, V1.sub(V2)); // i*delta
436         uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);
437         uint256 penalty = DecimalMath.mul(k, V0V0V1V2); // k(V0^2/V1/V2)
438         return DecimalMath.mul(fairAmount, DecimalMath.ONE.sub(k).add(penalty));
439     }
440 
441     /*
442         The same with integration expression above, we have:
443         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
444         Given Q1 and deltaB, solve Q2
445         This is a quadratic function and the standard version is
446         aQ2^2 + bQ2 + c = 0, where
447         a=1-k
448         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
449         c=-kQ0^2
450         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
451         note: another root is negative, abondan
452         if deltaBSig=true, then Q2>Q1
453         if deltaBSig=false, then Q2<Q1
454     */
455     function _SolveQuadraticFunctionForTrade(
456         uint256 Q0,
457         uint256 Q1,
458         uint256 ideltaB,
459         bool deltaBSig,
460         uint256 k
461     ) internal pure returns (uint256) {
462         // calculate -b value and sig
463         // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB
464         uint256 kQ02Q1 = DecimalMath.mul(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1
465         uint256 b = DecimalMath.mul(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1
466         bool minusbSig = true;
467         if (deltaBSig) {
468             b = b.add(ideltaB); // (1-k)Q1+i*deltaB
469         } else {
470             kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1
471         }
472         if (b >= kQ02Q1) {
473             b = b.sub(kQ02Q1);
474             minusbSig = true;
475         } else {
476             b = kQ02Q1.sub(b);
477             minusbSig = false;
478         }
479 
480         // calculate sqrt
481         uint256 squareRoot = DecimalMath.mul(
482             DecimalMath.ONE.sub(k).mul(4),
483             DecimalMath.mul(k, Q0).mul(Q0)
484         ); // 4(1-k)kQ0^2
485         squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
486 
487         // final res
488         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
489         uint256 numerator;
490         if (minusbSig) {
491             numerator = b.add(squareRoot);
492         } else {
493             numerator = squareRoot.sub(b);
494         }
495 
496         if (deltaBSig) {
497             return DecimalMath.divFloor(numerator, denominator);
498         } else {
499             return DecimalMath.divCeil(numerator, denominator);
500         }
501     }
502 
503     /*
504         Start from the integration function
505         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
506         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
507         let fairAmount = i*deltaB
508     */
509     function _SolveQuadraticFunctionForTarget(
510         uint256 V1,
511         uint256 k,
512         uint256 fairAmount
513     ) internal pure returns (uint256 V0) {
514         // V0 = V1+V1*(sqrt-1)/2k
515         uint256 sqrt = DecimalMath.divCeil(DecimalMath.mul(k, fairAmount).mul(4), V1);
516         sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();
517         uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));
518         // V0 is greater than or equal to V1 according to the solution
519         return DecimalMath.mul(V1, DecimalMath.ONE.add(premium));
520     }
521 }
522 
523 // File: contracts/impl/Pricing.sol
524 
525 /*
526 
527     Copyright 2020 DODO ZOO.
528 
529 */
530 
531 /**
532  * @title Pricing
533  * @author DODO Breeder
534  *
535  * @notice DODO Pricing model
536  */
537 contract Pricing is Storage {
538     using SafeMath for uint256;
539 
540     // ============ R = 1 cases ============
541 
542     function _ROneSellBaseToken(uint256 amount, uint256 targetQuoteTokenAmount)
543         internal
544         view
545         returns (uint256 receiveQuoteToken)
546     {
547         uint256 i = getOraclePrice();
548         uint256 Q2 = DODOMath._SolveQuadraticFunctionForTrade(
549             targetQuoteTokenAmount,
550             targetQuoteTokenAmount,
551             DecimalMath.mul(i, amount),
552             false,
553             _K_
554         );
555         // in theory Q2 <= targetQuoteTokenAmount
556         // however when amount is close to 0, precision problems may cause Q2 > targetQuoteTokenAmount
557         return targetQuoteTokenAmount.sub(Q2);
558     }
559 
560     function _ROneBuyBaseToken(uint256 amount, uint256 targetBaseTokenAmount)
561         internal
562         view
563         returns (uint256 payQuoteToken)
564     {
565         require(amount < targetBaseTokenAmount, "DODO_BASE_BALANCE_NOT_ENOUGH");
566         uint256 B2 = targetBaseTokenAmount.sub(amount);
567         payQuoteToken = _RAboveIntegrate(targetBaseTokenAmount, targetBaseTokenAmount, B2);
568         return payQuoteToken;
569     }
570 
571     // ============ R < 1 cases ============
572 
573     function _RBelowSellBaseToken(
574         uint256 amount,
575         uint256 quoteBalance,
576         uint256 targetQuoteAmount
577     ) internal view returns (uint256 receieQuoteToken) {
578         uint256 i = getOraclePrice();
579         uint256 Q2 = DODOMath._SolveQuadraticFunctionForTrade(
580             targetQuoteAmount,
581             quoteBalance,
582             DecimalMath.mul(i, amount),
583             false,
584             _K_
585         );
586         return quoteBalance.sub(Q2);
587     }
588 
589     function _RBelowBuyBaseToken(
590         uint256 amount,
591         uint256 quoteBalance,
592         uint256 targetQuoteAmount
593     ) internal view returns (uint256 payQuoteToken) {
594         // Here we don't require amount less than some value
595         // Because it is limited at upper function
596         // See Trader.queryBuyBaseToken
597         uint256 i = getOraclePrice();
598         uint256 Q2 = DODOMath._SolveQuadraticFunctionForTrade(
599             targetQuoteAmount,
600             quoteBalance,
601             DecimalMath.mul(i, amount),
602             true,
603             _K_
604         );
605         return Q2.sub(quoteBalance);
606     }
607 
608     function _RBelowBackToOne() internal view returns (uint256 payQuoteToken) {
609         // important: carefully design the system to make sure spareBase always greater than or equal to 0
610         uint256 spareBase = _BASE_BALANCE_.sub(_TARGET_BASE_TOKEN_AMOUNT_);
611         uint256 price = getOraclePrice();
612         uint256 fairAmount = DecimalMath.mul(spareBase, price);
613         uint256 newTargetQuote = DODOMath._SolveQuadraticFunctionForTarget(
614             _QUOTE_BALANCE_,
615             _K_,
616             fairAmount
617         );
618         return newTargetQuote.sub(_QUOTE_BALANCE_);
619     }
620 
621     // ============ R > 1 cases ============
622 
623     function _RAboveBuyBaseToken(
624         uint256 amount,
625         uint256 baseBalance,
626         uint256 targetBaseAmount
627     ) internal view returns (uint256 payQuoteToken) {
628         require(amount < baseBalance, "DODO_BASE_BALANCE_NOT_ENOUGH");
629         uint256 B2 = baseBalance.sub(amount);
630         return _RAboveIntegrate(targetBaseAmount, baseBalance, B2);
631     }
632 
633     function _RAboveSellBaseToken(
634         uint256 amount,
635         uint256 baseBalance,
636         uint256 targetBaseAmount
637     ) internal view returns (uint256 receiveQuoteToken) {
638         // here we don't require B1 <= targetBaseAmount
639         // Because it is limited at upper function
640         // See Trader.querySellBaseToken
641         uint256 B1 = baseBalance.add(amount);
642         return _RAboveIntegrate(targetBaseAmount, B1, baseBalance);
643     }
644 
645     function _RAboveBackToOne() internal view returns (uint256 payBaseToken) {
646         // important: carefully design the system to make sure spareBase always greater than or equal to 0
647         uint256 spareQuote = _QUOTE_BALANCE_.sub(_TARGET_QUOTE_TOKEN_AMOUNT_);
648         uint256 price = getOraclePrice();
649         uint256 fairAmount = DecimalMath.divFloor(spareQuote, price);
650         uint256 newTargetBase = DODOMath._SolveQuadraticFunctionForTarget(
651             _BASE_BALANCE_,
652             _K_,
653             fairAmount
654         );
655         return newTargetBase.sub(_BASE_BALANCE_);
656     }
657 
658     // ============ Helper functions ============
659 
660     function getExpectedTarget() public view returns (uint256 baseTarget, uint256 quoteTarget) {
661         uint256 Q = _QUOTE_BALANCE_;
662         uint256 B = _BASE_BALANCE_;
663         if (_R_STATUS_ == Types.RStatus.ONE) {
664             return (_TARGET_BASE_TOKEN_AMOUNT_, _TARGET_QUOTE_TOKEN_AMOUNT_);
665         } else if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
666             uint256 payQuoteToken = _RBelowBackToOne();
667             return (_TARGET_BASE_TOKEN_AMOUNT_, Q.add(payQuoteToken));
668         } else if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
669             uint256 payBaseToken = _RAboveBackToOne();
670             return (B.add(payBaseToken), _TARGET_QUOTE_TOKEN_AMOUNT_);
671         }
672     }
673 
674     function getMidPrice() public view returns (uint256 midPrice) {
675         (uint256 baseTarget, uint256 quoteTarget) = getExpectedTarget();
676         if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
677             uint256 R = DecimalMath.divFloor(
678                 quoteTarget.mul(quoteTarget).div(_QUOTE_BALANCE_),
679                 _QUOTE_BALANCE_
680             );
681             R = DecimalMath.ONE.sub(_K_).add(DecimalMath.mul(_K_, R));
682             return DecimalMath.divFloor(getOraclePrice(), R);
683         } else {
684             uint256 R = DecimalMath.divFloor(
685                 baseTarget.mul(baseTarget).div(_BASE_BALANCE_),
686                 _BASE_BALANCE_
687             );
688             R = DecimalMath.ONE.sub(_K_).add(DecimalMath.mul(_K_, R));
689             return DecimalMath.mul(getOraclePrice(), R);
690         }
691     }
692 
693     function _RAboveIntegrate(
694         uint256 B0,
695         uint256 B1,
696         uint256 B2
697     ) internal view returns (uint256) {
698         uint256 i = getOraclePrice();
699         return DODOMath._GeneralIntegrate(B0, B1, B2, i, _K_);
700     }
701 
702     // function _RBelowIntegrate(
703     //     uint256 Q0,
704     //     uint256 Q1,
705     //     uint256 Q2
706     // ) internal view returns (uint256) {
707     //     uint256 i = getOraclePrice();
708     //     i = DecimalMath.divFloor(DecimalMath.ONE, i); // 1/i
709     //     return DODOMath._GeneralIntegrate(Q0, Q1, Q2, i, _K_);
710     // }
711 }
712 
713 // File: contracts/lib/SafeERC20.sol
714 
715 /*
716 
717     Copyright 2020 DODO ZOO.
718     This is a simplified version of OpenZepplin's SafeERC20 library
719 
720 */
721 
722 /**
723  * @title SafeERC20
724  * @dev Wrappers around ERC20 operations that throw on failure (when the token
725  * contract returns false). Tokens that return no value (and instead revert or
726  * throw on failure) are also supported, non-reverting calls are assumed to be
727  * successful.
728  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
729  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
730  */
731 library SafeERC20 {
732     using SafeMath for uint256;
733 
734     function safeTransfer(
735         IERC20 token,
736         address to,
737         uint256 value
738     ) internal {
739         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
740     }
741 
742     function safeTransferFrom(
743         IERC20 token,
744         address from,
745         address to,
746         uint256 value
747     ) internal {
748         _callOptionalReturn(
749             token,
750             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
751         );
752     }
753 
754     /**
755      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
756      * on the return value: the return value is optional (but if data is returned, it must not be false).
757      * @param token The token targeted by the call.
758      * @param data The call data (encoded using abi.encode or one of its variants).
759      */
760     function _callOptionalReturn(IERC20 token, bytes memory data) private {
761         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
762         // we're implementing it ourselves.
763 
764         // A Solidity high level call has three parts:
765         //  1. The target address is checked to verify it contains contract code
766         //  2. The call itself is made, and success asserted
767         //  3. The return value is decoded, which in turn checks the size of the returned data.
768         // solhint-disable-next-line max-line-length
769 
770         // solhint-disable-next-line avoid-low-level-calls
771         (bool success, bytes memory returndata) = address(token).call(data);
772         require(success, "SafeERC20: low-level call failed");
773 
774         if (returndata.length > 0) {
775             // Return data is optional
776             // solhint-disable-next-line max-line-length
777             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
778         }
779     }
780 }
781 
782 // File: contracts/impl/Settlement.sol
783 
784 /*
785 
786     Copyright 2020 DODO ZOO.
787 
788 */
789 
790 /**
791  * @title Settlement
792  * @author DODO Breeder
793  *
794  * @notice Functions for assets settlement
795  */
796 contract Settlement is Storage {
797     using SafeMath for uint256;
798     using SafeERC20 for IERC20;
799 
800     // ============ Events ============
801 
802     event Donate(uint256 amount, bool isBaseToken);
803 
804     event ClaimAssets(address indexed user, uint256 baseTokenAmount, uint256 quoteTokenAmount);
805 
806     // ============ Assets IN/OUT Functions ============
807 
808     function _baseTokenTransferIn(address from, uint256 amount) internal {
809         IERC20(_BASE_TOKEN_).safeTransferFrom(from, address(this), amount);
810         _BASE_BALANCE_ = _BASE_BALANCE_.add(amount);
811     }
812 
813     function _quoteTokenTransferIn(address from, uint256 amount) internal {
814         IERC20(_QUOTE_TOKEN_).safeTransferFrom(from, address(this), amount);
815         _QUOTE_BALANCE_ = _QUOTE_BALANCE_.add(amount);
816     }
817 
818     function _baseTokenTransferOut(address to, uint256 amount) internal {
819         IERC20(_BASE_TOKEN_).safeTransfer(to, amount);
820         _BASE_BALANCE_ = _BASE_BALANCE_.sub(amount);
821     }
822 
823     function _quoteTokenTransferOut(address to, uint256 amount) internal {
824         IERC20(_QUOTE_TOKEN_).safeTransfer(to, amount);
825         _QUOTE_BALANCE_ = _QUOTE_BALANCE_.sub(amount);
826     }
827 
828     // ============ Donate to Liquidity Pool Functions ============
829 
830     function _donateBaseToken(uint256 amount) internal {
831         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.add(amount);
832         emit Donate(amount, true);
833     }
834 
835     function _donateQuoteToken(uint256 amount) internal {
836         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.add(amount);
837         emit Donate(amount, false);
838     }
839 
840     function donateBaseToken(uint256 amount) external preventReentrant {
841         _baseTokenTransferIn(msg.sender, amount);
842         _donateBaseToken(amount);
843     }
844 
845     function donateQuoteToken(uint256 amount) external preventReentrant {
846         _quoteTokenTransferIn(msg.sender, amount);
847         _donateQuoteToken(amount);
848     }
849 
850     // ============ Final Settlement Functions ============
851 
852     // last step to shut down dodo
853     function finalSettlement() external onlyOwner notClosed {
854         _CLOSED_ = true;
855         _DEPOSIT_QUOTE_ALLOWED_ = false;
856         _DEPOSIT_BASE_ALLOWED_ = false;
857         _TRADE_ALLOWED_ = false;
858         uint256 totalBaseCapital = getTotalBaseCapital();
859         uint256 totalQuoteCapital = getTotalQuoteCapital();
860 
861         if (_QUOTE_BALANCE_ > _TARGET_QUOTE_TOKEN_AMOUNT_) {
862             uint256 spareQuote = _QUOTE_BALANCE_.sub(_TARGET_QUOTE_TOKEN_AMOUNT_);
863             _BASE_CAPITAL_RECEIVE_QUOTE_ = DecimalMath.divFloor(spareQuote, totalBaseCapital);
864         } else {
865             _TARGET_QUOTE_TOKEN_AMOUNT_ = _QUOTE_BALANCE_;
866         }
867 
868         if (_BASE_BALANCE_ > _TARGET_BASE_TOKEN_AMOUNT_) {
869             uint256 spareBase = _BASE_BALANCE_.sub(_TARGET_BASE_TOKEN_AMOUNT_);
870             _QUOTE_CAPITAL_RECEIVE_BASE_ = DecimalMath.divFloor(spareBase, totalQuoteCapital);
871         } else {
872             _TARGET_BASE_TOKEN_AMOUNT_ = _BASE_BALANCE_;
873         }
874 
875         _R_STATUS_ = Types.RStatus.ONE;
876     }
877 
878     // claim remaining assets after final settlement
879     function claimAssets() external preventReentrant {
880         require(_CLOSED_, "DODO_NOT_CLOSED");
881         require(!_CLAIMED_[msg.sender], "ALREADY_CLAIMED");
882         _CLAIMED_[msg.sender] = true;
883         uint256 quoteAmount = DecimalMath.mul(
884             getBaseCapitalBalanceOf(msg.sender),
885             _BASE_CAPITAL_RECEIVE_QUOTE_
886         );
887         uint256 baseAmount = DecimalMath.mul(
888             getQuoteCapitalBalanceOf(msg.sender),
889             _QUOTE_CAPITAL_RECEIVE_BASE_
890         );
891         _baseTokenTransferOut(msg.sender, baseAmount);
892         _quoteTokenTransferOut(msg.sender, quoteAmount);
893         emit ClaimAssets(msg.sender, baseAmount, quoteAmount);
894         return;
895     }
896 
897     // in case someone transfer to contract directly
898     function retrieve(address token, uint256 amount) external onlyOwner {
899         if (token == _BASE_TOKEN_) {
900             require(
901                 IERC20(_BASE_TOKEN_).balanceOf(address(this)) >= _BASE_BALANCE_.add(amount),
902                 "DODO_BASE_BALANCE_NOT_ENOUGH"
903             );
904         }
905         if (token == _QUOTE_TOKEN_) {
906             require(
907                 IERC20(_QUOTE_TOKEN_).balanceOf(address(this)) >= _QUOTE_BALANCE_.add(amount),
908                 "DODO_QUOTE_BALANCE_NOT_ENOUGH"
909             );
910         }
911         IERC20(token).safeTransfer(msg.sender, amount);
912     }
913 }
914 
915 // File: contracts/impl/Trader.sol
916 
917 /*
918 
919     Copyright 2020 DODO ZOO.
920 
921 */
922 
923 /**
924  * @title Trader
925  * @author DODO Breeder
926  *
927  * @notice Functions for trader operations
928  */
929 contract Trader is Storage, Pricing, Settlement {
930     using SafeMath for uint256;
931 
932     // ============ Events ============
933 
934     event SellBaseToken(address indexed seller, uint256 payBase, uint256 receiveQuote);
935 
936     event BuyBaseToken(address indexed buyer, uint256 receiveBase, uint256 payQuote);
937 
938     event ChargeMaintainerFee(address indexed maintainer, bool isBaseToken, uint256 amount);
939 
940     // ============ Modifiers ============
941 
942     modifier tradeAllowed() {
943         require(_TRADE_ALLOWED_, "TRADE_NOT_ALLOWED");
944         _;
945     }
946 
947     modifier gasPriceLimit() {
948         require(tx.gasprice <= _GAS_PRICE_LIMIT_, "GAS_PRICE_EXCEED");
949         _;
950     }
951 
952     // ============ Trade Functions ============
953 
954     function sellBaseToken(
955         uint256 amount,
956         uint256 minReceiveQuote,
957         bytes calldata data
958     ) external tradeAllowed gasPriceLimit preventReentrant returns (uint256) {
959         // query price
960         (
961             uint256 receiveQuote,
962             uint256 lpFeeQuote,
963             uint256 mtFeeQuote,
964             Types.RStatus newRStatus,
965             uint256 newQuoteTarget,
966             uint256 newBaseTarget
967         ) = _querySellBaseToken(amount);
968         require(receiveQuote >= minReceiveQuote, "SELL_BASE_RECEIVE_NOT_ENOUGH");
969 
970         // settle assets
971         _quoteTokenTransferOut(msg.sender, receiveQuote);
972         if (data.length > 0) {
973             IDODOCallee(msg.sender).dodoCall(false, amount, receiveQuote, data);
974         }
975         _baseTokenTransferIn(msg.sender, amount);
976         if (mtFeeQuote != 0) {
977             _quoteTokenTransferOut(_MAINTAINER_, mtFeeQuote);
978             emit ChargeMaintainerFee(_MAINTAINER_, false, mtFeeQuote);
979         }
980 
981         // update TARGET
982         if (_TARGET_QUOTE_TOKEN_AMOUNT_ != newQuoteTarget) {
983             _TARGET_QUOTE_TOKEN_AMOUNT_ = newQuoteTarget;
984         }
985         if (_TARGET_BASE_TOKEN_AMOUNT_ != newBaseTarget) {
986             _TARGET_BASE_TOKEN_AMOUNT_ = newBaseTarget;
987         }
988         if (_R_STATUS_ != newRStatus) {
989             _R_STATUS_ = newRStatus;
990         }
991 
992         _donateQuoteToken(lpFeeQuote);
993         emit SellBaseToken(msg.sender, amount, receiveQuote);
994 
995         return receiveQuote;
996     }
997 
998     function buyBaseToken(
999         uint256 amount,
1000         uint256 maxPayQuote,
1001         bytes calldata data
1002     ) external tradeAllowed gasPriceLimit preventReentrant returns (uint256) {
1003         // query price
1004         (
1005             uint256 payQuote,
1006             uint256 lpFeeBase,
1007             uint256 mtFeeBase,
1008             Types.RStatus newRStatus,
1009             uint256 newQuoteTarget,
1010             uint256 newBaseTarget
1011         ) = _queryBuyBaseToken(amount);
1012         require(payQuote <= maxPayQuote, "BUY_BASE_COST_TOO_MUCH");
1013 
1014         // settle assets
1015         _baseTokenTransferOut(msg.sender, amount);
1016         if (data.length > 0) {
1017             IDODOCallee(msg.sender).dodoCall(true, amount, payQuote, data);
1018         }
1019         _quoteTokenTransferIn(msg.sender, payQuote);
1020         if (mtFeeBase != 0) {
1021             _baseTokenTransferOut(_MAINTAINER_, mtFeeBase);
1022             emit ChargeMaintainerFee(_MAINTAINER_, true, mtFeeBase);
1023         }
1024 
1025         // update TARGET
1026         if (_TARGET_QUOTE_TOKEN_AMOUNT_ != newQuoteTarget) {
1027             _TARGET_QUOTE_TOKEN_AMOUNT_ = newQuoteTarget;
1028         }
1029         if (_TARGET_BASE_TOKEN_AMOUNT_ != newBaseTarget) {
1030             _TARGET_BASE_TOKEN_AMOUNT_ = newBaseTarget;
1031         }
1032         if (_R_STATUS_ != newRStatus) {
1033             _R_STATUS_ = newRStatus;
1034         }
1035 
1036         _donateBaseToken(lpFeeBase);
1037         emit BuyBaseToken(msg.sender, amount, payQuote);
1038 
1039         return payQuote;
1040     }
1041 
1042     // ============ Query Functions ============
1043 
1044     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote) {
1045         (receiveQuote, , , , , ) = _querySellBaseToken(amount);
1046         return receiveQuote;
1047     }
1048 
1049     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote) {
1050         (payQuote, , , , , ) = _queryBuyBaseToken(amount);
1051         return payQuote;
1052     }
1053 
1054     function _querySellBaseToken(uint256 amount)
1055         internal
1056         view
1057         returns (
1058             uint256 receiveQuote,
1059             uint256 lpFeeQuote,
1060             uint256 mtFeeQuote,
1061             Types.RStatus newRStatus,
1062             uint256 newQuoteTarget,
1063             uint256 newBaseTarget
1064         )
1065     {
1066         (newBaseTarget, newQuoteTarget) = getExpectedTarget();
1067 
1068         uint256 sellBaseAmount = amount;
1069 
1070         if (_R_STATUS_ == Types.RStatus.ONE) {
1071             // case 1: R=1
1072             // R falls below one
1073             receiveQuote = _ROneSellBaseToken(sellBaseAmount, newQuoteTarget);
1074             newRStatus = Types.RStatus.BELOW_ONE;
1075         } else if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
1076             uint256 backToOnePayBase = newBaseTarget.sub(_BASE_BALANCE_);
1077             uint256 backToOneReceiveQuote = _QUOTE_BALANCE_.sub(newQuoteTarget);
1078             // case 2: R>1
1079             // complex case, R status depends on trading amount
1080             if (sellBaseAmount < backToOnePayBase) {
1081                 // case 2.1: R status do not change
1082                 receiveQuote = _RAboveSellBaseToken(sellBaseAmount, _BASE_BALANCE_, newBaseTarget);
1083                 newRStatus = Types.RStatus.ABOVE_ONE;
1084                 if (receiveQuote > backToOneReceiveQuote) {
1085                     // [Important corner case!] may enter this branch when some precision problem happens. And consequently contribute to negative spare quote amount
1086                     // to make sure spare quote>=0, mannually set receiveQuote=backToOneReceiveQuote
1087                     receiveQuote = backToOneReceiveQuote;
1088                 }
1089             } else if (sellBaseAmount == backToOnePayBase) {
1090                 // case 2.2: R status changes to ONE
1091                 receiveQuote = backToOneReceiveQuote;
1092                 newRStatus = Types.RStatus.ONE;
1093             } else {
1094                 // case 2.3: R status changes to BELOW_ONE
1095                 receiveQuote = backToOneReceiveQuote.add(
1096                     _ROneSellBaseToken(sellBaseAmount.sub(backToOnePayBase), newQuoteTarget)
1097                 );
1098                 newRStatus = Types.RStatus.BELOW_ONE;
1099             }
1100         } else {
1101             // _R_STATUS_ == Types.RStatus.BELOW_ONE
1102             // case 3: R<1
1103             receiveQuote = _RBelowSellBaseToken(sellBaseAmount, _QUOTE_BALANCE_, newQuoteTarget);
1104             newRStatus = Types.RStatus.BELOW_ONE;
1105         }
1106 
1107         // count fees
1108         lpFeeQuote = DecimalMath.mul(receiveQuote, _LP_FEE_RATE_);
1109         mtFeeQuote = DecimalMath.mul(receiveQuote, _MT_FEE_RATE_);
1110         receiveQuote = receiveQuote.sub(lpFeeQuote).sub(mtFeeQuote);
1111 
1112         return (receiveQuote, lpFeeQuote, mtFeeQuote, newRStatus, newQuoteTarget, newBaseTarget);
1113     }
1114 
1115     function _queryBuyBaseToken(uint256 amount)
1116         internal
1117         view
1118         returns (
1119             uint256 payQuote,
1120             uint256 lpFeeBase,
1121             uint256 mtFeeBase,
1122             Types.RStatus newRStatus,
1123             uint256 newQuoteTarget,
1124             uint256 newBaseTarget
1125         )
1126     {
1127         (newBaseTarget, newQuoteTarget) = getExpectedTarget();
1128 
1129         // charge fee from user receive amount
1130         lpFeeBase = DecimalMath.mul(amount, _LP_FEE_RATE_);
1131         mtFeeBase = DecimalMath.mul(amount, _MT_FEE_RATE_);
1132         uint256 buyBaseAmount = amount.add(lpFeeBase).add(mtFeeBase);
1133 
1134         if (_R_STATUS_ == Types.RStatus.ONE) {
1135             // case 1: R=1
1136             payQuote = _ROneBuyBaseToken(buyBaseAmount, newBaseTarget);
1137             newRStatus = Types.RStatus.ABOVE_ONE;
1138         } else if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
1139             // case 2: R>1
1140             payQuote = _RAboveBuyBaseToken(buyBaseAmount, _BASE_BALANCE_, newBaseTarget);
1141             newRStatus = Types.RStatus.ABOVE_ONE;
1142         } else if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
1143             uint256 backToOnePayQuote = newQuoteTarget.sub(_QUOTE_BALANCE_);
1144             uint256 backToOneReceiveBase = _BASE_BALANCE_.sub(newBaseTarget);
1145             // case 3: R<1
1146             // complex case, R status may change
1147             if (buyBaseAmount < backToOneReceiveBase) {
1148                 // case 3.1: R status do not change
1149                 // no need to check payQuote because spare base token must be greater than zero
1150                 payQuote = _RBelowBuyBaseToken(buyBaseAmount, _QUOTE_BALANCE_, newQuoteTarget);
1151                 newRStatus = Types.RStatus.BELOW_ONE;
1152             } else if (buyBaseAmount == backToOneReceiveBase) {
1153                 // case 3.2: R status changes to ONE
1154                 payQuote = backToOnePayQuote;
1155                 newRStatus = Types.RStatus.ONE;
1156             } else {
1157                 // case 3.3: R status changes to ABOVE_ONE
1158                 payQuote = backToOnePayQuote.add(
1159                     _ROneBuyBaseToken(buyBaseAmount.sub(backToOneReceiveBase), newBaseTarget)
1160                 );
1161                 newRStatus = Types.RStatus.ABOVE_ONE;
1162             }
1163         }
1164 
1165         return (payQuote, lpFeeBase, mtFeeBase, newRStatus, newQuoteTarget, newBaseTarget);
1166     }
1167 }
1168 
1169 // File: contracts/impl/LiquidityProvider.sol
1170 
1171 /*
1172 
1173     Copyright 2020 DODO ZOO.
1174 
1175 */
1176 
1177 /**
1178  * @title LiquidityProvider
1179  * @author DODO Breeder
1180  *
1181  * @notice Functions for liquidity provider operations
1182  */
1183 contract LiquidityProvider is Storage, Pricing, Settlement {
1184     using SafeMath for uint256;
1185 
1186     // ============ Events ============
1187 
1188     event Deposit(
1189         address indexed payer,
1190         address indexed receiver,
1191         bool isBaseToken,
1192         uint256 amount,
1193         uint256 lpTokenAmount
1194     );
1195 
1196     event Withdraw(
1197         address indexed payer,
1198         address indexed receiver,
1199         bool isBaseToken,
1200         uint256 amount,
1201         uint256 lpTokenAmount
1202     );
1203 
1204     event ChargePenalty(address indexed payer, bool isBaseToken, uint256 amount);
1205 
1206     // ============ Modifiers ============
1207 
1208     modifier depositQuoteAllowed() {
1209         require(_DEPOSIT_QUOTE_ALLOWED_, "DEPOSIT_QUOTE_NOT_ALLOWED");
1210         _;
1211     }
1212 
1213     modifier depositBaseAllowed() {
1214         require(_DEPOSIT_BASE_ALLOWED_, "DEPOSIT_BASE_NOT_ALLOWED");
1215         _;
1216     }
1217 
1218     // ============ Routine Functions ============
1219 
1220     function withdrawBase(uint256 amount) external returns (uint256) {
1221         return withdrawBaseTo(msg.sender, amount);
1222     }
1223 
1224     function depositBase(uint256 amount) external returns (uint256) {
1225         return depositBaseTo(msg.sender, amount);
1226     }
1227 
1228     function withdrawQuote(uint256 amount) external returns (uint256) {
1229         return withdrawQuoteTo(msg.sender, amount);
1230     }
1231 
1232     function depositQuote(uint256 amount) external returns (uint256) {
1233         return depositQuoteTo(msg.sender, amount);
1234     }
1235 
1236     function withdrawAllBase() external returns (uint256) {
1237         return withdrawAllBaseTo(msg.sender);
1238     }
1239 
1240     function withdrawAllQuote() external returns (uint256) {
1241         return withdrawAllQuoteTo(msg.sender);
1242     }
1243 
1244     // ============ Deposit Functions ============
1245 
1246     function depositQuoteTo(address to, uint256 amount)
1247         public
1248         preventReentrant
1249         depositQuoteAllowed
1250         returns (uint256)
1251     {
1252         (, uint256 quoteTarget) = getExpectedTarget();
1253         uint256 totalQuoteCapital = getTotalQuoteCapital();
1254         uint256 capital = amount;
1255         if (totalQuoteCapital == 0) {
1256             // give remaining quote token to lp as a gift
1257             capital = amount.add(quoteTarget);
1258         } else if (quoteTarget > 0) {
1259             capital = amount.mul(totalQuoteCapital).div(quoteTarget);
1260         }
1261 
1262         // settlement
1263         _quoteTokenTransferIn(msg.sender, amount);
1264         _mintQuoteCapital(to, capital);
1265         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.add(amount);
1266 
1267         emit Deposit(msg.sender, to, false, amount, capital);
1268         return capital;
1269     }
1270 
1271     function depositBaseTo(address to, uint256 amount)
1272         public
1273         preventReentrant
1274         depositBaseAllowed
1275         returns (uint256)
1276     {
1277         (uint256 baseTarget, ) = getExpectedTarget();
1278         uint256 totalBaseCapital = getTotalBaseCapital();
1279         uint256 capital = amount;
1280         if (totalBaseCapital == 0) {
1281             // give remaining base token to lp as a gift
1282             capital = amount.add(baseTarget);
1283         } else if (baseTarget > 0) {
1284             capital = amount.mul(totalBaseCapital).div(baseTarget);
1285         }
1286 
1287         // settlement
1288         _baseTokenTransferIn(msg.sender, amount);
1289         _mintBaseCapital(to, capital);
1290         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.add(amount);
1291 
1292         emit Deposit(msg.sender, to, true, amount, capital);
1293         return capital;
1294     }
1295 
1296     // ============ Withdraw Functions ============
1297 
1298     function withdrawQuoteTo(address to, uint256 amount) public preventReentrant returns (uint256) {
1299         // calculate capital
1300         (, uint256 quoteTarget) = getExpectedTarget();
1301         uint256 totalQuoteCapital = getTotalQuoteCapital();
1302         require(totalQuoteCapital > 0, "NO_QUOTE_LP");
1303 
1304         uint256 requireQuoteCapital = amount.mul(totalQuoteCapital).divCeil(quoteTarget);
1305         require(
1306             requireQuoteCapital <= getQuoteCapitalBalanceOf(msg.sender),
1307             "LP_QUOTE_CAPITAL_BALANCE_NOT_ENOUGH"
1308         );
1309 
1310         // handle penalty, penalty may exceed amount
1311         uint256 penalty = getWithdrawQuotePenalty(amount);
1312         require(penalty < amount, "PENALTY_EXCEED");
1313 
1314         // settlement
1315         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.sub(amount);
1316         _burnQuoteCapital(msg.sender, requireQuoteCapital);
1317         _quoteTokenTransferOut(to, amount.sub(penalty));
1318         _donateQuoteToken(penalty);
1319 
1320         emit Withdraw(msg.sender, to, false, amount.sub(penalty), requireQuoteCapital);
1321         emit ChargePenalty(msg.sender, false, penalty);
1322 
1323         return amount.sub(penalty);
1324     }
1325 
1326     function withdrawBaseTo(address to, uint256 amount) public preventReentrant returns (uint256) {
1327         // calculate capital
1328         (uint256 baseTarget, ) = getExpectedTarget();
1329         uint256 totalBaseCapital = getTotalBaseCapital();
1330         require(totalBaseCapital > 0, "NO_BASE_LP");
1331 
1332         uint256 requireBaseCapital = amount.mul(totalBaseCapital).divCeil(baseTarget);
1333         require(
1334             requireBaseCapital <= getBaseCapitalBalanceOf(msg.sender),
1335             "LP_BASE_CAPITAL_BALANCE_NOT_ENOUGH"
1336         );
1337 
1338         // handle penalty, penalty may exceed amount
1339         uint256 penalty = getWithdrawBasePenalty(amount);
1340         require(penalty <= amount, "PENALTY_EXCEED");
1341 
1342         // settlement
1343         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.sub(amount);
1344         _burnBaseCapital(msg.sender, requireBaseCapital);
1345         _baseTokenTransferOut(to, amount.sub(penalty));
1346         _donateBaseToken(penalty);
1347 
1348         emit Withdraw(msg.sender, to, true, amount.sub(penalty), requireBaseCapital);
1349         emit ChargePenalty(msg.sender, true, penalty);
1350 
1351         return amount.sub(penalty);
1352     }
1353 
1354     // ============ Withdraw all Functions ============
1355 
1356     function withdrawAllQuoteTo(address to) public preventReentrant returns (uint256) {
1357         uint256 withdrawAmount = getLpQuoteBalance(msg.sender);
1358         uint256 capital = getQuoteCapitalBalanceOf(msg.sender);
1359 
1360         // handle penalty, penalty may exceed amount
1361         uint256 penalty = getWithdrawQuotePenalty(withdrawAmount);
1362         require(penalty <= withdrawAmount, "PENALTY_EXCEED");
1363 
1364         // settlement
1365         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.sub(withdrawAmount);
1366         _burnQuoteCapital(msg.sender, capital);
1367         _quoteTokenTransferOut(to, withdrawAmount.sub(penalty));
1368         _donateQuoteToken(penalty);
1369 
1370         emit Withdraw(msg.sender, to, false, withdrawAmount, capital);
1371         emit ChargePenalty(msg.sender, false, penalty);
1372 
1373         return withdrawAmount.sub(penalty);
1374     }
1375 
1376     function withdrawAllBaseTo(address to) public preventReentrant returns (uint256) {
1377         uint256 withdrawAmount = getLpBaseBalance(msg.sender);
1378         uint256 capital = getBaseCapitalBalanceOf(msg.sender);
1379 
1380         // handle penalty, penalty may exceed amount
1381         uint256 penalty = getWithdrawBasePenalty(withdrawAmount);
1382         require(penalty <= withdrawAmount, "PENALTY_EXCEED");
1383 
1384         // settlement
1385         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.sub(withdrawAmount);
1386         _burnBaseCapital(msg.sender, capital);
1387         _baseTokenTransferOut(to, withdrawAmount.sub(penalty));
1388         _donateBaseToken(penalty);
1389 
1390         emit Withdraw(msg.sender, to, true, withdrawAmount, capital);
1391         emit ChargePenalty(msg.sender, true, penalty);
1392 
1393         return withdrawAmount.sub(penalty);
1394     }
1395 
1396     // ============ Helper Functions ============
1397 
1398     function _mintBaseCapital(address user, uint256 amount) internal {
1399         IDODOLpToken(_BASE_CAPITAL_TOKEN_).mint(user, amount);
1400     }
1401 
1402     function _mintQuoteCapital(address user, uint256 amount) internal {
1403         IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).mint(user, amount);
1404     }
1405 
1406     function _burnBaseCapital(address user, uint256 amount) internal {
1407         IDODOLpToken(_BASE_CAPITAL_TOKEN_).burn(user, amount);
1408     }
1409 
1410     function _burnQuoteCapital(address user, uint256 amount) internal {
1411         IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).burn(user, amount);
1412     }
1413 
1414     // ============ Getter Functions ============
1415 
1416     function getLpBaseBalance(address lp) public view returns (uint256 lpBalance) {
1417         uint256 totalBaseCapital = getTotalBaseCapital();
1418         (uint256 baseTarget, ) = getExpectedTarget();
1419         if (totalBaseCapital == 0) {
1420             return 0;
1421         }
1422         lpBalance = getBaseCapitalBalanceOf(lp).mul(baseTarget).div(totalBaseCapital);
1423         return lpBalance;
1424     }
1425 
1426     function getLpQuoteBalance(address lp) public view returns (uint256 lpBalance) {
1427         uint256 totalQuoteCapital = getTotalQuoteCapital();
1428         (, uint256 quoteTarget) = getExpectedTarget();
1429         if (totalQuoteCapital == 0) {
1430             return 0;
1431         }
1432         lpBalance = getQuoteCapitalBalanceOf(lp).mul(quoteTarget).div(totalQuoteCapital);
1433         return lpBalance;
1434     }
1435 
1436     function getWithdrawQuotePenalty(uint256 amount) public view returns (uint256 penalty) {
1437         require(amount <= _QUOTE_BALANCE_, "DODO_QUOTE_BALANCE_NOT_ENOUGH");
1438         if (_R_STATUS_ == Types.RStatus.BELOW_ONE) {
1439             uint256 spareBase = _BASE_BALANCE_.sub(_TARGET_BASE_TOKEN_AMOUNT_);
1440             uint256 price = getOraclePrice();
1441             uint256 fairAmount = DecimalMath.mul(spareBase, price);
1442             uint256 targetQuote = DODOMath._SolveQuadraticFunctionForTarget(
1443                 _QUOTE_BALANCE_,
1444                 _K_,
1445                 fairAmount
1446             );
1447             // if amount = _QUOTE_BALANCE_, div error
1448             uint256 targetQuoteWithWithdraw = DODOMath._SolveQuadraticFunctionForTarget(
1449                 _QUOTE_BALANCE_.sub(amount),
1450                 _K_,
1451                 fairAmount
1452             );
1453             return targetQuote.sub(targetQuoteWithWithdraw.add(amount));
1454         } else {
1455             return 0;
1456         }
1457     }
1458 
1459     function getWithdrawBasePenalty(uint256 amount) public view returns (uint256 penalty) {
1460         require(amount <= _BASE_BALANCE_, "DODO_BASE_BALANCE_NOT_ENOUGH");
1461         if (_R_STATUS_ == Types.RStatus.ABOVE_ONE) {
1462             uint256 spareQuote = _QUOTE_BALANCE_.sub(_TARGET_QUOTE_TOKEN_AMOUNT_);
1463             uint256 price = getOraclePrice();
1464             uint256 fairAmount = DecimalMath.divFloor(spareQuote, price);
1465             uint256 targetBase = DODOMath._SolveQuadraticFunctionForTarget(
1466                 _BASE_BALANCE_,
1467                 _K_,
1468                 fairAmount
1469             );
1470             // if amount = _BASE_BALANCE_, div error
1471             uint256 targetBaseWithWithdraw = DODOMath._SolveQuadraticFunctionForTarget(
1472                 _BASE_BALANCE_.sub(amount),
1473                 _K_,
1474                 fairAmount
1475             );
1476             return targetBase.sub(targetBaseWithWithdraw.add(amount));
1477         } else {
1478             return 0;
1479         }
1480     }
1481 }
1482 
1483 // File: contracts/impl/Admin.sol
1484 
1485 /*
1486 
1487     Copyright 2020 DODO ZOO.
1488 
1489 */
1490 
1491 /**
1492  * @title Admin
1493  * @author DODO Breeder
1494  *
1495  * @notice Functions for admin operations
1496  */
1497 contract Admin is Storage {
1498     // ============ Events ============
1499 
1500     event UpdateGasPriceLimit(uint256 oldGasPriceLimit, uint256 newGasPriceLimit);
1501 
1502     event UpdateLiquidityProviderFeeRate(
1503         uint256 oldLiquidityProviderFeeRate,
1504         uint256 newLiquidityProviderFeeRate
1505     );
1506 
1507     event UpdateMaintainerFeeRate(uint256 oldMaintainerFeeRate, uint256 newMaintainerFeeRate);
1508 
1509     event UpdateK(uint256 oldK, uint256 newK);
1510 
1511     // ============ Params Setting Functions ============
1512 
1513     function setOracle(address newOracle) external onlyOwner {
1514         _ORACLE_ = newOracle;
1515     }
1516 
1517     function setSupervisor(address newSupervisor) external onlyOwner {
1518         _SUPERVISOR_ = newSupervisor;
1519     }
1520 
1521     function setMaintainer(address newMaintainer) external onlyOwner {
1522         _MAINTAINER_ = newMaintainer;
1523     }
1524 
1525     function setLiquidityProviderFeeRate(uint256 newLiquidityPorviderFeeRate) external onlyOwner {
1526         emit UpdateLiquidityProviderFeeRate(_LP_FEE_RATE_, newLiquidityPorviderFeeRate);
1527         _LP_FEE_RATE_ = newLiquidityPorviderFeeRate;
1528         _checkDODOParameters();
1529     }
1530 
1531     function setMaintainerFeeRate(uint256 newMaintainerFeeRate) external onlyOwner {
1532         emit UpdateMaintainerFeeRate(_MT_FEE_RATE_, newMaintainerFeeRate);
1533         _MT_FEE_RATE_ = newMaintainerFeeRate;
1534         _checkDODOParameters();
1535     }
1536 
1537     function setK(uint256 newK) external onlyOwner {
1538         emit UpdateK(_K_, newK);
1539         _K_ = newK;
1540         _checkDODOParameters();
1541     }
1542 
1543     function setGasPriceLimit(uint256 newGasPriceLimit) external onlySupervisorOrOwner {
1544         emit UpdateGasPriceLimit(_GAS_PRICE_LIMIT_, newGasPriceLimit);
1545         _GAS_PRICE_LIMIT_ = newGasPriceLimit;
1546     }
1547 
1548     // ============ System Control Functions ============
1549 
1550     function disableTrading() external onlySupervisorOrOwner {
1551         _TRADE_ALLOWED_ = false;
1552     }
1553 
1554     function enableTrading() external onlyOwner notClosed {
1555         _TRADE_ALLOWED_ = true;
1556     }
1557 
1558     function disableQuoteDeposit() external onlySupervisorOrOwner {
1559         _DEPOSIT_QUOTE_ALLOWED_ = false;
1560     }
1561 
1562     function enableQuoteDeposit() external onlyOwner notClosed {
1563         _DEPOSIT_QUOTE_ALLOWED_ = true;
1564     }
1565 
1566     function disableBaseDeposit() external onlySupervisorOrOwner {
1567         _DEPOSIT_BASE_ALLOWED_ = false;
1568     }
1569 
1570     function enableBaseDeposit() external onlyOwner notClosed {
1571         _DEPOSIT_BASE_ALLOWED_ = true;
1572     }
1573 }
1574 
1575 // File: contracts/lib/Ownable.sol
1576 
1577 /*
1578 
1579     Copyright 2020 DODO ZOO.
1580 
1581 */
1582 
1583 /**
1584  * @title Ownable
1585  * @author DODO Breeder
1586  *
1587  * @notice Ownership related functions
1588  */
1589 contract Ownable {
1590     address public _OWNER_;
1591     address public _NEW_OWNER_;
1592 
1593     // ============ Events ============
1594 
1595     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
1596 
1597     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1598 
1599     // ============ Modifiers ============
1600 
1601     modifier onlyOwner() {
1602         require(msg.sender == _OWNER_, "NOT_OWNER");
1603         _;
1604     }
1605 
1606     // ============ Functions ============
1607 
1608     constructor() internal {
1609         _OWNER_ = msg.sender;
1610         emit OwnershipTransferred(address(0), _OWNER_);
1611     }
1612 
1613     function transferOwnership(address newOwner) external onlyOwner {
1614         require(newOwner != address(0), "INVALID_OWNER");
1615         emit OwnershipTransferPrepared(_OWNER_, newOwner);
1616         _NEW_OWNER_ = newOwner;
1617     }
1618 
1619     function claimOwnership() external {
1620         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
1621         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
1622         _OWNER_ = _NEW_OWNER_;
1623         _NEW_OWNER_ = address(0);
1624     }
1625 }
1626 
1627 // File: contracts/impl/DODOLpToken.sol
1628 
1629 /*
1630 
1631     Copyright 2020 DODO ZOO.
1632 
1633 */
1634 
1635 /**
1636  * @title DODOLpToken
1637  * @author DODO Breeder
1638  *
1639  * @notice Tokenize liquidity pool assets. An ordinary ERC20 contract with mint and burn functions
1640  */
1641 contract DODOLpToken is Ownable {
1642     using SafeMath for uint256;
1643 
1644     string public symbol = "DLP";
1645     address public originToken;
1646 
1647     uint256 public totalSupply;
1648     mapping(address => uint256) internal balances;
1649     mapping(address => mapping(address => uint256)) internal allowed;
1650 
1651     // ============ Events ============
1652 
1653     event Transfer(address indexed from, address indexed to, uint256 amount);
1654 
1655     event Approval(address indexed owner, address indexed spender, uint256 amount);
1656 
1657     event Mint(address indexed user, uint256 value);
1658 
1659     event Burn(address indexed user, uint256 value);
1660 
1661     // ============ Functions ============
1662 
1663     constructor(address _originToken) public {
1664         originToken = _originToken;
1665     }
1666 
1667     function name() public view returns (string memory) {
1668         string memory lpTokenSuffix = "_DODO_LP_TOKEN_";
1669         return string(abi.encodePacked(IERC20(originToken).name(), lpTokenSuffix));
1670     }
1671 
1672     function decimals() public view returns (uint8) {
1673         return IERC20(originToken).decimals();
1674     }
1675 
1676     /**
1677      * @dev transfer token for a specified address
1678      * @param to The address to transfer to.
1679      * @param amount The amount to be transferred.
1680      */
1681     function transfer(address to, uint256 amount) public returns (bool) {
1682         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
1683 
1684         balances[msg.sender] = balances[msg.sender].sub(amount);
1685         balances[to] = balances[to].add(amount);
1686         emit Transfer(msg.sender, to, amount);
1687         return true;
1688     }
1689 
1690     /**
1691      * @dev Gets the balance of the specified address.
1692      * @param owner The address to query the the balance of.
1693      * @return balance An uint256 representing the amount owned by the passed address.
1694      */
1695     function balanceOf(address owner) external view returns (uint256 balance) {
1696         return balances[owner];
1697     }
1698 
1699     /**
1700      * @dev Transfer tokens from one address to another
1701      * @param from address The address which you want to send tokens from
1702      * @param to address The address which you want to transfer to
1703      * @param amount uint256 the amount of tokens to be transferred
1704      */
1705     function transferFrom(
1706         address from,
1707         address to,
1708         uint256 amount
1709     ) public returns (bool) {
1710         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
1711         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
1712 
1713         balances[from] = balances[from].sub(amount);
1714         balances[to] = balances[to].add(amount);
1715         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
1716         emit Transfer(from, to, amount);
1717         return true;
1718     }
1719 
1720     /**
1721      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1722      * @param spender The address which will spend the funds.
1723      * @param amount The amount of tokens to be spent.
1724      */
1725     function approve(address spender, uint256 amount) public returns (bool) {
1726         allowed[msg.sender][spender] = amount;
1727         emit Approval(msg.sender, spender, amount);
1728         return true;
1729     }
1730 
1731     /**
1732      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1733      * @param owner address The address which owns the funds.
1734      * @param spender address The address which will spend the funds.
1735      * @return A uint256 specifying the amount of tokens still available for the spender.
1736      */
1737     function allowance(address owner, address spender) public view returns (uint256) {
1738         return allowed[owner][spender];
1739     }
1740 
1741     function mint(address user, uint256 value) external onlyOwner {
1742         balances[user] = balances[user].add(value);
1743         totalSupply = totalSupply.add(value);
1744         emit Mint(user, value);
1745         emit Transfer(address(0), user, value);
1746     }
1747 
1748     function burn(address user, uint256 value) external onlyOwner {
1749         balances[user] = balances[user].sub(value);
1750         totalSupply = totalSupply.sub(value);
1751         emit Burn(user, value);
1752         emit Transfer(user, address(0), value);
1753     }
1754 }
1755 
1756 // File: contracts/dodo.sol
1757 
1758 /*
1759 
1760     Copyright 2020 DODO ZOO.
1761 
1762 */
1763 
1764 /**
1765  * @title DODO
1766  * @author DODO Breeder
1767  *
1768  * @notice Entrance for users
1769  */
1770 contract DODO is Admin, Trader, LiquidityProvider {
1771     function init(
1772         address owner,
1773         address supervisor,
1774         address maintainer,
1775         address baseToken,
1776         address quoteToken,
1777         address oracle,
1778         uint256 lpFeeRate,
1779         uint256 mtFeeRate,
1780         uint256 k,
1781         uint256 gasPriceLimit
1782     ) external {
1783         require(!_INITIALIZED_, "DODO_INITIALIZED");
1784         _INITIALIZED_ = true;
1785 
1786         // constructor
1787         _OWNER_ = owner;
1788         emit OwnershipTransferred(address(0), _OWNER_);
1789 
1790         _SUPERVISOR_ = supervisor;
1791         _MAINTAINER_ = maintainer;
1792         _BASE_TOKEN_ = baseToken;
1793         _QUOTE_TOKEN_ = quoteToken;
1794         _ORACLE_ = oracle;
1795 
1796         _DEPOSIT_BASE_ALLOWED_ = true;
1797         _DEPOSIT_QUOTE_ALLOWED_ = true;
1798         _TRADE_ALLOWED_ = true;
1799         _GAS_PRICE_LIMIT_ = gasPriceLimit;
1800 
1801         _LP_FEE_RATE_ = lpFeeRate;
1802         _MT_FEE_RATE_ = mtFeeRate;
1803         _K_ = k;
1804         _R_STATUS_ = Types.RStatus.ONE;
1805 
1806         _BASE_CAPITAL_TOKEN_ = address(new DODOLpToken(_BASE_TOKEN_));
1807         _QUOTE_CAPITAL_TOKEN_ = address(new DODOLpToken(_QUOTE_TOKEN_));
1808 
1809         _checkDODOParameters();
1810     }
1811 }