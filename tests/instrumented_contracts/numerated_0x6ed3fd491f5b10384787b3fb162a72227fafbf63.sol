1 // File: contracts/intf/IERC20.sol
2 
3 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
4 
5 pragma solidity 0.6.9;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     function decimals() external view returns (uint8);
17 
18     function name() external view returns (string memory);
19 
20     function symbol() external view returns (string memory);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 }
76 
77 // File: contracts/lib/SafeMath.sol
78 
79 
80 
81 
82 /**
83  * @title SafeMath
84  * @author DODO Breeder
85  *
86  * @notice Math operations with safety checks that revert on error
87  */
88 library SafeMath {
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "MUL_ERROR");
96 
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b > 0, "DIVIDING_ERROR");
102         return a / b;
103     }
104 
105     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 quotient = div(a, b);
107         uint256 remainder = a - quotient * b;
108         if (remainder > 0) {
109             return quotient + 1;
110         } else {
111             return quotient;
112         }
113     }
114 
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         require(b <= a, "SUB_ERROR");
117         return a - b;
118     }
119 
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "ADD_ERROR");
123         return c;
124     }
125 
126     function sqrt(uint256 x) internal pure returns (uint256 y) {
127         uint256 z = x / 2 + 1;
128         y = x;
129         while (z < y) {
130             y = z;
131             z = (x / z + z) / 2;
132         }
133     }
134 }
135 
136 // File: contracts/lib/SafeERC20.sol
137 
138 
139 
140 
141 
142 
143 /**
144  * @title SafeERC20
145  * @dev Wrappers around ERC20 operations that throw on failure (when the token
146  * contract returns false). Tokens that return no value (and instead revert or
147  * throw on failure) are also supported, non-reverting calls are assumed to be
148  * successful.
149  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
150  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
151  */
152 library SafeERC20 {
153     using SafeMath for uint256;
154 
155     function safeTransfer(
156         IERC20 token,
157         address to,
158         uint256 value
159     ) internal {
160         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
161     }
162 
163     function safeTransferFrom(
164         IERC20 token,
165         address from,
166         address to,
167         uint256 value
168     ) internal {
169         _callOptionalReturn(
170             token,
171             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
172         );
173     }
174 
175     function safeApprove(
176         IERC20 token,
177         address spender,
178         uint256 value
179     ) internal {
180         // safeApprove should only be called when setting an initial allowance,
181         // or when resetting it to zero. To increase and decrease it, use
182         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
183         // solhint-disable-next-line max-line-length
184         require(
185             (value == 0) || (token.allowance(address(this), spender) == 0),
186             "SafeERC20: approve from non-zero to non-zero allowance"
187         );
188         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
189     }
190 
191     /**
192      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
193      * on the return value: the return value is optional (but if data is returned, it must not be false).
194      * @param token The token targeted by the call.
195      * @param data The call data (encoded using abi.encode or one of its variants).
196      */
197     function _callOptionalReturn(IERC20 token, bytes memory data) private {
198         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
199         // we're implementing it ourselves.
200 
201         // A Solidity high level call has three parts:
202         //  1. The target address is checked to verify it contains contract code
203         //  2. The call itself is made, and success asserted
204         //  3. The return value is decoded, which in turn checks the size of the returned data.
205         // solhint-disable-next-line max-line-length
206 
207         // solhint-disable-next-line avoid-low-level-calls
208         (bool success, bytes memory returndata) = address(token).call(data);
209         require(success, "SafeERC20: low-level call failed");
210 
211         if (returndata.length > 0) {
212             // Return data is optional
213             // solhint-disable-next-line max-line-length
214             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
215         }
216     }
217 }
218 
219 // File: contracts/SmartRoute/lib/UniversalERC20.sol
220 
221 
222 
223 
224 
225 
226 library UniversalERC20 {
227     using SafeMath for uint256;
228     using SafeERC20 for IERC20;
229 
230     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
231 
232     function universalTransfer(
233         IERC20 token,
234         address payable to,
235         uint256 amount
236     ) internal {
237         if (amount > 0) {
238             if (isETH(token)) {
239                 to.transfer(amount);
240             } else {
241                 token.safeTransfer(to, amount);
242             }
243         }
244     }
245 
246     function universalApproveMax(
247         IERC20 token,
248         address to,
249         uint256 amount
250     ) internal {
251         uint256 allowance = token.allowance(address(this), to);
252         if (allowance < amount) {
253             if (allowance > 0) {
254                 token.safeApprove(to, 0);
255             }
256             token.safeApprove(to, uint256(-1));
257         }
258     }
259 
260     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
261         if (isETH(token)) {
262             return who.balance;
263         } else {
264             return token.balanceOf(who);
265         }
266     }
267 
268     function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {
269         return token.balanceOf(who);
270     }
271 
272     function isETH(IERC20 token) internal pure returns (bool) {
273         return token == ETH_ADDRESS;
274     }
275 }
276 
277 // File: contracts/SmartRoute/intf/IDODOV1.sol
278 
279 
280 
281 interface IDODOV1 {
282     function init(
283         address owner,
284         address supervisor,
285         address maintainer,
286         address baseToken,
287         address quoteToken,
288         address oracle,
289         uint256 lpFeeRate,
290         uint256 mtFeeRate,
291         uint256 k,
292         uint256 gasPriceLimit
293     ) external;
294 
295     function transferOwnership(address newOwner) external;
296 
297     function claimOwnership() external;
298 
299     function sellBaseToken(
300         uint256 amount,
301         uint256 minReceiveQuote,
302         bytes calldata data
303     ) external returns (uint256);
304 
305     function buyBaseToken(
306         uint256 amount,
307         uint256 maxPayQuote,
308         bytes calldata data
309     ) external returns (uint256);
310 
311     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
312 
313     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
314 
315     function depositBaseTo(address to, uint256 amount) external returns (uint256);
316 
317     function withdrawBase(uint256 amount) external returns (uint256);
318 
319     function withdrawAllBase() external returns (uint256);
320 
321     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
322 
323     function withdrawQuote(uint256 amount) external returns (uint256);
324 
325     function withdrawAllQuote() external returns (uint256);
326 
327     function _BASE_CAPITAL_TOKEN_() external returns (address);
328 
329     function _QUOTE_CAPITAL_TOKEN_() external returns (address);
330 
331     function _BASE_TOKEN_() external returns (address);
332 
333     function _QUOTE_TOKEN_() external returns (address);
334 
335     function _R_STATUS_() external view returns (uint8);
336 
337     function _QUOTE_BALANCE_() external view returns (uint256);
338 
339     function _BASE_BALANCE_() external view returns (uint256);
340 
341     function _K_() external view returns (uint256);
342 
343     function _MT_FEE_RATE_() external view returns (uint256);
344 
345     function _LP_FEE_RATE_() external view returns (uint256);
346 
347     function getExpectedTarget() external view returns (uint256 baseTarget, uint256 quoteTarget);
348 
349     function getOraclePrice() external view returns (uint256);
350 
351     function getMidPrice() external view returns (uint256 midPrice); 
352 }
353 
354 // File: contracts/lib/DecimalMath.sol
355 
356 
357 
358 
359 /**
360  * @title DecimalMath
361  * @author DODO Breeder
362  *
363  * @notice Functions for fixed point number with 18 decimals
364  */
365 library DecimalMath {
366     using SafeMath for uint256;
367 
368     uint256 internal constant ONE = 10**18;
369     uint256 internal constant ONE2 = 10**36;
370 
371     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
372         return target.mul(d) / (10**18);
373     }
374 
375     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
376         return target.mul(d).divCeil(10**18);
377     }
378 
379     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
380         return target.mul(10**18).div(d);
381     }
382 
383     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
384         return target.mul(10**18).divCeil(d);
385     }
386 
387     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
388         return uint256(10**36).div(target);
389     }
390 
391     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
392         return uint256(10**36).divCeil(target);
393     }
394 }
395 
396 // File: contracts/SmartRoute/helper/DODOSellHelper.sol
397 
398 
399 
400 
401 
402 
403 // import {DODOMath} from "../lib/DODOMath.sol";
404 
405 interface IDODOSellHelper {
406     function querySellQuoteToken(address dodo, uint256 amount) external view returns (uint256);
407     
408     function querySellBaseToken(address dodo, uint256 amount) external view returns (uint256);
409 }
410 
411 library DODOMath {
412     using SafeMath for uint256;
413 
414     /*
415         Integrate dodo curve fron V1 to V2
416         require V0>=V1>=V2>0
417         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
418         let V1-V2=delta
419         res = i*delta*(1-k+k(V0^2/V1/V2))
420     */
421     function _GeneralIntegrate(
422         uint256 V0,
423         uint256 V1,
424         uint256 V2,
425         uint256 i,
426         uint256 k
427     ) internal pure returns (uint256) {
428         uint256 fairAmount = DecimalMath.mulFloor(i, V1.sub(V2)); // i*delta
429         uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);
430         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
431         return DecimalMath.mulFloor(fairAmount, DecimalMath.ONE.sub(k).add(penalty));
432     }
433 
434     /*
435         The same with integration expression above, we have:
436         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
437         Given Q1 and deltaB, solve Q2
438         This is a quadratic function and the standard version is
439         aQ2^2 + bQ2 + c = 0, where
440         a=1-k
441         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
442         c=-kQ0^2
443         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
444         note: another root is negative, abondan
445         if deltaBSig=true, then Q2>Q1
446         if deltaBSig=false, then Q2<Q1
447     */
448     function _SolveQuadraticFunctionForTrade(
449         uint256 Q0,
450         uint256 Q1,
451         uint256 ideltaB,
452         bool deltaBSig,
453         uint256 k
454     ) internal pure returns (uint256) {
455         // calculate -b value and sig
456         // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB
457         uint256 kQ02Q1 = DecimalMath.mulFloor(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1
458         uint256 b = DecimalMath.mulFloor(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1
459         bool minusbSig = true;
460         if (deltaBSig) {
461             b = b.add(ideltaB); // (1-k)Q1+i*deltaB
462         } else {
463             kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1
464         }
465         if (b >= kQ02Q1) {
466             b = b.sub(kQ02Q1);
467             minusbSig = true;
468         } else {
469             b = kQ02Q1.sub(b);
470             minusbSig = false;
471         }
472 
473         // calculate sqrt
474         uint256 squareRoot = DecimalMath.mulFloor(
475             DecimalMath.ONE.sub(k).mul(4),
476             DecimalMath.mulFloor(k, Q0).mul(Q0)
477         ); // 4(1-k)kQ0^2
478         squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
479 
480         // final res
481         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
482         uint256 numerator;
483         if (minusbSig) {
484             numerator = b.add(squareRoot);
485         } else {
486             numerator = squareRoot.sub(b);
487         }
488 
489         if (deltaBSig) {
490             return DecimalMath.divFloor(numerator, denominator);
491         } else {
492             return DecimalMath.divCeil(numerator, denominator);
493         }
494     }
495 
496     /*
497         Start from the integration function
498         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
499         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
500         let fairAmount = i*deltaB
501     */
502     function _SolveQuadraticFunctionForTarget(
503         uint256 V1,
504         uint256 k,
505         uint256 fairAmount
506     ) internal pure returns (uint256 V0) {
507         // V0 = V1+V1*(sqrt-1)/2k
508         uint256 sqrt = DecimalMath.divCeil(DecimalMath.mulFloor(k, fairAmount).mul(4), V1);
509         sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();
510         uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));
511         // V0 is greater than or equal to V1 according to the solution
512         return DecimalMath.mulFloor(V1, DecimalMath.ONE.add(premium));
513     }
514 }
515 
516 contract DODOSellHelper {
517     using SafeMath for uint256;
518 
519     enum RStatus {ONE, ABOVE_ONE, BELOW_ONE}
520 
521     uint256 constant ONE = 10**18;
522 
523     struct DODOState {
524         uint256 oraclePrice;
525         uint256 K;
526         uint256 B;
527         uint256 Q;
528         uint256 baseTarget;
529         uint256 quoteTarget;
530         RStatus rStatus;
531     }
532 
533     function querySellBaseToken(address dodo, uint256 amount) public view returns (uint256) {
534         return IDODOV1(dodo).querySellBaseToken(amount);
535     }
536 
537     function querySellQuoteToken(address dodo, uint256 amount) public view returns (uint256) {
538         DODOState memory state;
539         (state.baseTarget, state.quoteTarget) = IDODOV1(dodo).getExpectedTarget();
540         state.rStatus = RStatus(IDODOV1(dodo)._R_STATUS_());
541         state.oraclePrice = IDODOV1(dodo).getOraclePrice();
542         state.Q = IDODOV1(dodo)._QUOTE_BALANCE_();
543         state.B = IDODOV1(dodo)._BASE_BALANCE_();
544         state.K = IDODOV1(dodo)._K_();
545 
546         uint256 boughtAmount;
547         // Determine the status (RStatus) and calculate the amount
548         // based on the state
549         if (state.rStatus == RStatus.ONE) {
550             boughtAmount = _ROneSellQuoteToken(amount, state);
551         } else if (state.rStatus == RStatus.ABOVE_ONE) {
552             boughtAmount = _RAboveSellQuoteToken(amount, state);
553         } else {
554             uint256 backOneBase = state.B.sub(state.baseTarget);
555             uint256 backOneQuote = state.quoteTarget.sub(state.Q);
556             if (amount <= backOneQuote) {
557                 boughtAmount = _RBelowSellQuoteToken(amount, state);
558             } else {
559                 boughtAmount = backOneBase.add(
560                     _ROneSellQuoteToken(amount.sub(backOneQuote), state)
561                 );
562             }
563         }
564         // Calculate fees
565         return
566             DecimalMath.divFloor(
567                 boughtAmount,
568                 DecimalMath.ONE.add(IDODOV1(dodo)._MT_FEE_RATE_()).add(
569                     IDODOV1(dodo)._LP_FEE_RATE_()
570                 )
571             );
572     }
573 
574     function _ROneSellQuoteToken(uint256 amount, DODOState memory state)
575         internal
576         pure
577         returns (uint256 receiveBaseToken)
578     {
579         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
580         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
581             state.baseTarget,
582             state.baseTarget,
583             DecimalMath.mulFloor(i, amount),
584             false,
585             state.K
586         );
587         return state.baseTarget.sub(B2);
588     }
589 
590     function _RAboveSellQuoteToken(uint256 amount, DODOState memory state)
591         internal
592         pure
593         returns (uint256 receieBaseToken)
594     {
595         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
596         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
597             state.baseTarget,
598             state.B,
599             DecimalMath.mulFloor(i, amount),
600             false,
601             state.K
602         );
603         return state.B.sub(B2);
604     }
605 
606     function _RBelowSellQuoteToken(uint256 amount, DODOState memory state)
607         internal
608         pure
609         returns (uint256 receiveBaseToken)
610     {
611         uint256 Q1 = state.Q.add(amount);
612         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
613         return DODOMath._GeneralIntegrate(state.quoteTarget, Q1, state.Q, i, state.K);
614     }
615 }
616 
617 // File: contracts/intf/IWETH.sol
618 
619 
620 
621 
622 interface IWETH {
623     function totalSupply() external view returns (uint256);
624 
625     function balanceOf(address account) external view returns (uint256);
626 
627     function transfer(address recipient, uint256 amount) external returns (bool);
628 
629     function allowance(address owner, address spender) external view returns (uint256);
630 
631     function approve(address spender, uint256 amount) external returns (bool);
632 
633     function transferFrom(
634         address src,
635         address dst,
636         uint256 wad
637     ) external returns (bool);
638 
639     function deposit() external payable;
640 
641     function withdraw(uint256 wad) external;
642 }
643 
644 // File: contracts/SmartRoute/intf/IChi.sol
645 
646 
647 
648 interface IChi {
649     function freeUpTo(uint256 value) external returns (uint256);
650 }
651 
652 // File: contracts/SmartRoute/intf/IUni.sol
653 
654 
655 
656 interface IUni {
657     function swapExactTokensForTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external returns (uint[] memory amounts);
664 }
665 
666 // File: contracts/intf/IDODOApprove.sol
667 
668 
669 
670 interface IDODOApprove {
671     function claimTokens(address token,address who,address dest,uint256 amount) external;
672     function getDODOProxy() external view returns (address);
673 }
674 
675 // File: contracts/SmartRoute/intf/IDODOV1Proxy02.sol
676 
677 
678 
679 interface IDODOV1Proxy02 {
680     function dodoSwapV1(
681         address fromToken,
682         address toToken,
683         uint256 fromTokenAmount,
684         uint256 minReturnAmount,
685         address[] memory dodoPairs,
686         uint256 directions,
687         uint256 deadLine
688     ) external payable returns (uint256 returnAmount);
689 
690     function externalSwap(
691         address fromToken,
692         address toToken,
693         address approveTarget,
694         address to,
695         uint256 fromTokenAmount,
696         uint256 minReturnAmount,
697         bytes memory callDataConcat,
698         uint256 deadLine
699     ) external payable returns (uint256 returnAmount);
700 
701     function mixSwapV1(
702         address fromToken,
703         address toToken,
704         uint256 fromTokenAmount,
705         uint256 minReturnAmount,
706         address[] memory mixPairs,
707         uint256[] memory directions,
708         address[] memory portionPath,
709         uint256 deadLine
710     ) external payable returns (uint256 returnAmount);
711 }
712 
713 // File: contracts/lib/InitializableOwnable.sol
714 
715 
716 
717 /**
718  * @title Ownable
719  * @author DODO Breeder
720  *
721  * @notice Ownership related functions
722  */
723 contract InitializableOwnable {
724     address public _OWNER_;
725     address public _NEW_OWNER_;
726     bool internal _INITIALIZED_;
727 
728     // ============ Events ============
729 
730     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     // ============ Modifiers ============
735 
736     modifier notInitialized() {
737         require(!_INITIALIZED_, "DODO_INITIALIZED");
738         _;
739     }
740 
741     modifier onlyOwner() {
742         require(msg.sender == _OWNER_, "NOT_OWNER");
743         _;
744     }
745 
746     // ============ Functions ============
747 
748     function initOwner(address newOwner) public notInitialized {
749         _INITIALIZED_ = true;
750         _OWNER_ = newOwner;
751     }
752 
753     function transferOwnership(address newOwner) public onlyOwner {
754         emit OwnershipTransferPrepared(_OWNER_, newOwner);
755         _NEW_OWNER_ = newOwner;
756     }
757 
758     function claimOwnership() public {
759         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
760         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
761         _OWNER_ = _NEW_OWNER_;
762         _NEW_OWNER_ = address(0);
763     }
764 }
765 
766 // File: contracts/SmartRoute/DODOV1Proxy02.sol
767 
768 
769 
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 /**
782  * @title DODOV1Proxy02
783  * @author DODO Breeder
784  *
785  * @notice Entrance of trading in DODO platform
786  */
787 contract DODOV1Proxy02 is IDODOV1Proxy02, InitializableOwnable {
788     using SafeMath for uint256;
789     using UniversalERC20 for IERC20;
790 
791     // ============ Storage ============
792 
793     address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
794     address public immutable _DODO_APPROVE_;
795     address public immutable _DODO_SELL_HELPER_;
796     address public immutable _WETH_;
797     address public immutable _CHI_TOKEN_;
798     uint256 public _GAS_DODO_MAX_RETURN_ = 0;
799     uint256 public _GAS_EXTERNAL_RETURN_ = 0;
800     mapping (address => bool) public isWhiteListed;
801 
802     // ============ Events ============
803 
804     event OrderHistory(
805         address indexed fromToken,
806         address indexed toToken,
807         address indexed sender,
808         uint256 fromAmount,
809         uint256 returnAmount
810     );
811 
812     // ============ Modifiers ============
813 
814     modifier judgeExpired(uint256 deadLine) {
815         require(deadLine >= block.timestamp, "DODOV1Proxy02: EXPIRED");
816         _;
817     }
818 
819     constructor(
820         address dodoApporve,
821         address dodoSellHelper,
822         address weth,
823         address chiToken
824     ) public {
825         _DODO_APPROVE_ = dodoApporve;
826         _DODO_SELL_HELPER_ = dodoSellHelper;
827         _WETH_ = weth;
828         _CHI_TOKEN_ = chiToken;
829     }
830 
831     fallback() external payable {}
832 
833     receive() external payable {}
834 
835     function updateGasReturn(uint256 newDodoGasReturn, uint256 newExternalGasReturn) public onlyOwner {
836         _GAS_DODO_MAX_RETURN_ = newDodoGasReturn;
837         _GAS_EXTERNAL_RETURN_ = newExternalGasReturn;
838     }
839 
840     function addWhiteList (address contractAddr) public onlyOwner {
841         isWhiteListed[contractAddr] = true;
842     }
843 
844     function removeWhiteList (address contractAddr) public onlyOwner {
845         isWhiteListed[contractAddr] = false;
846     }
847 
848     function dodoSwapV1(
849         address fromToken,
850         address toToken,
851         uint256 fromTokenAmount,
852         uint256 minReturnAmount,
853         address[] memory dodoPairs,
854         uint256 directions,
855         uint256 deadLine
856     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
857         require(dodoPairs.length > 0, "DODOV1Proxy02: PAIRS_EMPTY");
858         require(minReturnAmount > 0, "DODOV1Proxy02: RETURN_AMOUNT_ZERO");
859         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy02: NOT_SUPPORT_SELL_CHI");
860         uint256 originGas = gasleft();
861 
862         if (fromToken != _ETH_ADDRESS_) {
863             IDODOApprove(_DODO_APPROVE_).claimTokens(
864                 fromToken,
865                 msg.sender,
866                 address(this),
867                 fromTokenAmount
868             );
869         } else {
870             require(msg.value == fromTokenAmount, "DODOV1Proxy02: ETH_AMOUNT_NOT_MATCH");
871             IWETH(_WETH_).deposit{value: fromTokenAmount}();
872         }
873 
874         for (uint256 i = 0; i < dodoPairs.length; i++) {
875             address curDodoPair = dodoPairs[i];
876             if (directions & 1 == 0) {
877                 address curDodoBase = IDODOV1(curDodoPair)._BASE_TOKEN_();
878                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
879                 IERC20(curDodoBase).universalApproveMax(curDodoPair, curAmountIn);
880                 IDODOV1(curDodoPair).sellBaseToken(curAmountIn, 0, "");
881             } else {
882                 address curDodoQuote = IDODOV1(curDodoPair)._QUOTE_TOKEN_();
883                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
884                 IERC20(curDodoQuote).universalApproveMax(curDodoPair, curAmountIn);
885                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
886                     curDodoPair,
887                     curAmountIn
888                 );
889                 IDODOV1(curDodoPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
890             }
891             directions = directions >> 1;
892         }
893 
894         if (toToken == _ETH_ADDRESS_) {
895             returnAmount = IWETH(_WETH_).balanceOf(address(this));
896             IWETH(_WETH_).withdraw(returnAmount);
897         } else {
898             returnAmount = IERC20(toToken).tokenBalanceOf(address(this));
899         }
900         
901         require(returnAmount >= minReturnAmount, "DODOV1Proxy02: Return amount is not enough");
902         IERC20(toToken).universalTransfer(msg.sender, returnAmount);
903         
904         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
905         
906         uint256 _gasDodoMaxReturn = _GAS_DODO_MAX_RETURN_;
907         if(_gasDodoMaxReturn > 0) {
908             uint256 calcGasTokenBurn = originGas.sub(gasleft()) / 65000;
909             uint256 gasTokenBurn = calcGasTokenBurn > _gasDodoMaxReturn ? _gasDodoMaxReturn : calcGasTokenBurn;
910             if(gasleft() > 27710 + gasTokenBurn * 6080)
911                 IChi(_CHI_TOKEN_).freeUpTo(gasTokenBurn);
912         }
913     }
914 
915     function externalSwap(
916         address fromToken,
917         address toToken,
918         address approveTarget,
919         address swapTarget,
920         uint256 fromTokenAmount,
921         uint256 minReturnAmount,
922         bytes memory callDataConcat,
923         uint256 deadLine
924     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
925         require(minReturnAmount > 0, "DODOV1Proxy02: RETURN_AMOUNT_ZERO");
926         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy02: NOT_SUPPORT_SELL_CHI");
927         
928         address _fromToken = fromToken;
929         address _toToken = toToken;
930         
931         uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);
932 
933         if (_fromToken != _ETH_ADDRESS_) {
934             IDODOApprove(_DODO_APPROVE_).claimTokens(
935                 _fromToken,
936                 msg.sender,
937                 address(this),
938                 fromTokenAmount
939             );
940             IERC20(_fromToken).universalApproveMax(approveTarget, fromTokenAmount);
941         }
942 
943         require(isWhiteListed[swapTarget], "DODOV1Proxy02: Not Whitelist Contract");
944         (bool success, ) = swapTarget.call{value: _fromToken == _ETH_ADDRESS_ ? msg.value : 0}(callDataConcat);
945 
946         require(success, "DODOV1Proxy02: External Swap execution Failed");
947 
948         IERC20(_toToken).universalTransfer(
949             msg.sender,
950             IERC20(_toToken).universalBalanceOf(address(this))
951         );
952         returnAmount = IERC20(_toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
953         require(returnAmount >= minReturnAmount, "DODOV1Proxy02: Return amount is not enough");
954 
955         emit OrderHistory(_fromToken, _toToken, msg.sender, fromTokenAmount, returnAmount);
956         
957         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
958         if(_gasExternalReturn > 0) {
959             if(gasleft() > 27710 + _gasExternalReturn * 6080)
960                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
961         }
962     }
963 
964 
965     function mixSwapV1(
966         address fromToken,
967         address toToken,
968         uint256 fromTokenAmount,
969         uint256 minReturnAmount,
970         address[] memory mixPairs,
971         uint256[] memory directions,
972         address[] memory portionPath,
973         uint256 deadLine
974     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
975         require(mixPairs.length == directions.length, "DODOV1Proxy02: PARAMS_LENGTH_NOT_MATCH");
976         require(mixPairs.length > 0, "DODOV1Proxy02: PAIRS_EMPTY");
977         require(minReturnAmount > 0, "DODOV1Proxy02: RETURN_AMOUNT_ZERO");
978         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy02: NOT_SUPPORT_SELL_CHI");
979         
980         uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);
981 
982         if (fromToken != _ETH_ADDRESS_) {
983             IDODOApprove(_DODO_APPROVE_).claimTokens(
984                 fromToken,
985                 msg.sender,
986                 address(this),
987                 fromTokenAmount
988             );
989         } else {
990             require(msg.value == fromTokenAmount, "DODOV1Proxy02: ETH_AMOUNT_NOT_MATCH");
991             IWETH(_WETH_).deposit{value: fromTokenAmount}();
992         }
993 
994         for (uint256 i = 0; i < mixPairs.length; i++) {
995             address curPair = mixPairs[i];
996             if (directions[i] == 0) {
997                 address curDodoBase = IDODOV1(curPair)._BASE_TOKEN_();
998                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
999                 IERC20(curDodoBase).universalApproveMax(curPair, curAmountIn);
1000                 IDODOV1(curPair).sellBaseToken(curAmountIn, 0, "");
1001             } else if(directions[i] == 1){
1002                 address curDodoQuote = IDODOV1(curPair)._QUOTE_TOKEN_();
1003                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
1004                 IERC20(curDodoQuote).universalApproveMax(curPair, curAmountIn);
1005                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
1006                     curPair,
1007                     curAmountIn
1008                 );
1009                 IDODOV1(curPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
1010             } else {
1011                 uint256 curAmountIn = IERC20(portionPath[0]).balanceOf(address(this));
1012                 IERC20(portionPath[0]).universalApproveMax(curPair, curAmountIn);
1013                 IUni(curPair).swapExactTokensForTokens(curAmountIn,0,portionPath,address(this),deadLine);
1014             }
1015         }
1016 
1017         IERC20(toToken).universalTransfer(
1018             msg.sender,
1019             IERC20(toToken).universalBalanceOf(address(this))
1020         );
1021 
1022         returnAmount = IERC20(toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
1023         require(returnAmount >= minReturnAmount, "DODOV1Proxy02: Return amount is not enough");
1024 
1025         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
1026         
1027         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
1028         if(_gasExternalReturn > 0) {
1029             if(gasleft() > 27710 + _gasExternalReturn * 6080)
1030                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
1031         }
1032     }
1033 }