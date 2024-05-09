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
331     function _BASE_TOKEN_() external view returns (address);
332 
333     function _QUOTE_TOKEN_() external view returns (address);
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
402 // import {DODOMath} from "../lib/DODOMath.sol";
403 
404 interface IDODOSellHelper {
405     function querySellQuoteToken(address dodo, uint256 amount) external view returns (uint256);
406     
407     function querySellBaseToken(address dodo, uint256 amount) external view returns (uint256);
408 }
409 
410 library DODOMath {
411     using SafeMath for uint256;
412 
413     /*
414         Integrate dodo curve fron V1 to V2
415         require V0>=V1>=V2>0
416         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
417         let V1-V2=delta
418         res = i*delta*(1-k+k(V0^2/V1/V2))
419     */
420     function _GeneralIntegrate(
421         uint256 V0,
422         uint256 V1,
423         uint256 V2,
424         uint256 i,
425         uint256 k
426     ) internal pure returns (uint256) {
427         uint256 fairAmount = DecimalMath.mulFloor(i, V1.sub(V2)); // i*delta
428         uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);
429         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
430         return DecimalMath.mulFloor(fairAmount, DecimalMath.ONE.sub(k).add(penalty));
431     }
432 
433     /*
434         The same with integration expression above, we have:
435         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
436         Given Q1 and deltaB, solve Q2
437         This is a quadratic function and the standard version is
438         aQ2^2 + bQ2 + c = 0, where
439         a=1-k
440         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
441         c=-kQ0^2
442         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
443         note: another root is negative, abondan
444         if deltaBSig=true, then Q2>Q1
445         if deltaBSig=false, then Q2<Q1
446     */
447     function _SolveQuadraticFunctionForTrade(
448         uint256 Q0,
449         uint256 Q1,
450         uint256 ideltaB,
451         bool deltaBSig,
452         uint256 k
453     ) internal pure returns (uint256) {
454         // calculate -b value and sig
455         // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB
456         uint256 kQ02Q1 = DecimalMath.mulFloor(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1
457         uint256 b = DecimalMath.mulFloor(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1
458         bool minusbSig = true;
459         if (deltaBSig) {
460             b = b.add(ideltaB); // (1-k)Q1+i*deltaB
461         } else {
462             kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1
463         }
464         if (b >= kQ02Q1) {
465             b = b.sub(kQ02Q1);
466             minusbSig = true;
467         } else {
468             b = kQ02Q1.sub(b);
469             minusbSig = false;
470         }
471 
472         // calculate sqrt
473         uint256 squareRoot = DecimalMath.mulFloor(
474             DecimalMath.ONE.sub(k).mul(4),
475             DecimalMath.mulFloor(k, Q0).mul(Q0)
476         ); // 4(1-k)kQ0^2
477         squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
478 
479         // final res
480         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
481         uint256 numerator;
482         if (minusbSig) {
483             numerator = b.add(squareRoot);
484         } else {
485             numerator = squareRoot.sub(b);
486         }
487 
488         if (deltaBSig) {
489             return DecimalMath.divFloor(numerator, denominator);
490         } else {
491             return DecimalMath.divCeil(numerator, denominator);
492         }
493     }
494 
495     /*
496         Start from the integration function
497         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
498         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
499         let fairAmount = i*deltaB
500     */
501     function _SolveQuadraticFunctionForTarget(
502         uint256 V1,
503         uint256 k,
504         uint256 fairAmount
505     ) internal pure returns (uint256 V0) {
506         // V0 = V1+V1*(sqrt-1)/2k
507         uint256 sqrt = DecimalMath.divCeil(DecimalMath.mulFloor(k, fairAmount).mul(4), V1);
508         sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();
509         uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));
510         // V0 is greater than or equal to V1 according to the solution
511         return DecimalMath.mulFloor(V1, DecimalMath.ONE.add(premium));
512     }
513 }
514 
515 contract DODOSellHelper {
516     using SafeMath for uint256;
517 
518     enum RStatus {ONE, ABOVE_ONE, BELOW_ONE}
519 
520     uint256 constant ONE = 10**18;
521 
522     struct DODOState {
523         uint256 oraclePrice;
524         uint256 K;
525         uint256 B;
526         uint256 Q;
527         uint256 baseTarget;
528         uint256 quoteTarget;
529         RStatus rStatus;
530     }
531 
532     function querySellBaseToken(address dodo, uint256 amount) public view returns (uint256) {
533         return IDODOV1(dodo).querySellBaseToken(amount);
534     }
535 
536     function querySellQuoteToken(address dodo, uint256 amount) public view returns (uint256) {
537         DODOState memory state;
538         (state.baseTarget, state.quoteTarget) = IDODOV1(dodo).getExpectedTarget();
539         state.rStatus = RStatus(IDODOV1(dodo)._R_STATUS_());
540         state.oraclePrice = IDODOV1(dodo).getOraclePrice();
541         state.Q = IDODOV1(dodo)._QUOTE_BALANCE_();
542         state.B = IDODOV1(dodo)._BASE_BALANCE_();
543         state.K = IDODOV1(dodo)._K_();
544 
545         uint256 boughtAmount;
546         // Determine the status (RStatus) and calculate the amount
547         // based on the state
548         if (state.rStatus == RStatus.ONE) {
549             boughtAmount = _ROneSellQuoteToken(amount, state);
550         } else if (state.rStatus == RStatus.ABOVE_ONE) {
551             boughtAmount = _RAboveSellQuoteToken(amount, state);
552         } else {
553             uint256 backOneBase = state.B.sub(state.baseTarget);
554             uint256 backOneQuote = state.quoteTarget.sub(state.Q);
555             if (amount <= backOneQuote) {
556                 boughtAmount = _RBelowSellQuoteToken(amount, state);
557             } else {
558                 boughtAmount = backOneBase.add(
559                     _ROneSellQuoteToken(amount.sub(backOneQuote), state)
560                 );
561             }
562         }
563         // Calculate fees
564         return
565             DecimalMath.divFloor(
566                 boughtAmount,
567                 DecimalMath.ONE.add(IDODOV1(dodo)._MT_FEE_RATE_()).add(
568                     IDODOV1(dodo)._LP_FEE_RATE_()
569                 )
570             );
571     }
572 
573     function _ROneSellQuoteToken(uint256 amount, DODOState memory state)
574         internal
575         pure
576         returns (uint256 receiveBaseToken)
577     {
578         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
579         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
580             state.baseTarget,
581             state.baseTarget,
582             DecimalMath.mulFloor(i, amount),
583             false,
584             state.K
585         );
586         return state.baseTarget.sub(B2);
587     }
588 
589     function _RAboveSellQuoteToken(uint256 amount, DODOState memory state)
590         internal
591         pure
592         returns (uint256 receieBaseToken)
593     {
594         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
595         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
596             state.baseTarget,
597             state.B,
598             DecimalMath.mulFloor(i, amount),
599             false,
600             state.K
601         );
602         return state.B.sub(B2);
603     }
604 
605     function _RBelowSellQuoteToken(uint256 amount, DODOState memory state)
606         internal
607         pure
608         returns (uint256 receiveBaseToken)
609     {
610         uint256 Q1 = state.Q.add(amount);
611         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
612         return DODOMath._GeneralIntegrate(state.quoteTarget, Q1, state.Q, i, state.K);
613     }
614 }
615 
616 // File: contracts/intf/IWETH.sol
617 
618 
619 
620 interface IWETH {
621     function totalSupply() external view returns (uint256);
622 
623     function balanceOf(address account) external view returns (uint256);
624 
625     function transfer(address recipient, uint256 amount) external returns (bool);
626 
627     function allowance(address owner, address spender) external view returns (uint256);
628 
629     function approve(address spender, uint256 amount) external returns (bool);
630 
631     function transferFrom(
632         address src,
633         address dst,
634         uint256 wad
635     ) external returns (bool);
636 
637     function deposit() external payable;
638 
639     function withdraw(uint256 wad) external;
640 }
641 
642 // File: contracts/SmartRoute/intf/IChi.sol
643 
644 
645 interface IChi {
646     function freeUpTo(uint256 value) external returns (uint256);
647 }
648 
649 // File: contracts/SmartRoute/intf/IUni.sol
650 
651 
652 interface IUni {
653     function swapExactTokensForTokens(
654         uint amountIn,
655         uint amountOutMin,
656         address[] calldata path,
657         address to,
658         uint deadline
659     ) external returns (uint[] memory amounts);
660 
661     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
662 
663     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
664 
665     function token0() external view returns (address);
666     
667     function token1() external view returns (address);
668 }
669 
670 // File: contracts/intf/IDODOApprove.sol
671 
672 
673 interface IDODOApprove {
674     function claimTokens(address token,address who,address dest,uint256 amount) external;
675     function getDODOProxy() external view returns (address);
676 }
677 
678 // File: contracts/SmartRoute/intf/IDODOV1Proxy02.sol
679 
680 
681 interface IDODOV1Proxy02 {
682     function dodoSwapV1(
683         address fromToken,
684         address toToken,
685         uint256 fromTokenAmount,
686         uint256 minReturnAmount,
687         address[] memory dodoPairs,
688         uint256 directions,
689         uint256 deadLine
690     ) external payable returns (uint256 returnAmount);
691 
692     function externalSwap(
693         address fromToken,
694         address toToken,
695         address approveTarget,
696         address to,
697         uint256 fromTokenAmount,
698         uint256 minReturnAmount,
699         bytes memory callDataConcat,
700         uint256 deadLine
701     ) external payable returns (uint256 returnAmount);
702 
703     function mixSwapV1(
704         address fromToken,
705         address toToken,
706         uint256 fromTokenAmount,
707         uint256 minReturnAmount,
708         address[] memory mixPairs,
709         uint256[] memory directions,
710         address[] memory portionPath,
711         uint256 deadLine
712     ) external payable returns (uint256 returnAmount);
713 }
714 
715 // File: contracts/lib/InitializableOwnable.sol
716 
717 
718 /**
719  * @title Ownable
720  * @author DODO Breeder
721  *
722  * @notice Ownership related functions
723  */
724 contract InitializableOwnable {
725     address public _OWNER_;
726     address public _NEW_OWNER_;
727     bool internal _INITIALIZED_;
728 
729     // ============ Events ============
730 
731     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
732 
733     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
734 
735     // ============ Modifiers ============
736 
737     modifier notInitialized() {
738         require(!_INITIALIZED_, "DODO_INITIALIZED");
739         _;
740     }
741 
742     modifier onlyOwner() {
743         require(msg.sender == _OWNER_, "NOT_OWNER");
744         _;
745     }
746 
747     // ============ Functions ============
748 
749     function initOwner(address newOwner) public notInitialized {
750         _INITIALIZED_ = true;
751         _OWNER_ = newOwner;
752     }
753 
754     function transferOwnership(address newOwner) public onlyOwner {
755         emit OwnershipTransferPrepared(_OWNER_, newOwner);
756         _NEW_OWNER_ = newOwner;
757     }
758 
759     function claimOwnership() public {
760         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
761         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
762         _OWNER_ = _NEW_OWNER_;
763         _NEW_OWNER_ = address(0);
764     }
765 }
766 
767 // File: contracts/SmartRoute/DODOV1Proxy03.sol
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
782  * @title DODOV1Proxy03
783  * @author DODO Breeder
784  *
785  * @notice Entrance of trading in DODO platform
786  */
787 contract DODOV1Proxy03 is IDODOV1Proxy02, InitializableOwnable {
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
798     uint256 public _GAS_DODO_MAX_RETURN_ = 10;
799     uint256 public _GAS_EXTERNAL_RETURN_ = 5;
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
815         require(deadLine >= block.timestamp, "DODOV1Proxy03: EXPIRED");
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
857         require(dodoPairs.length > 0, "DODOV1Proxy03: PAIRS_EMPTY");
858         require(minReturnAmount > 0, "DODOV1Proxy03: RETURN_AMOUNT_ZERO");
859         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_SELL_CHI");
860         require(toToken != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_BUY_CHI");
861 
862         uint256 originGas = gasleft();
863 
864         if (fromToken != _ETH_ADDRESS_) {
865             IDODOApprove(_DODO_APPROVE_).claimTokens(
866                 fromToken,
867                 msg.sender,
868                 address(this),
869                 fromTokenAmount
870             );
871         } else {
872             require(msg.value == fromTokenAmount, "DODOV1Proxy03: ETH_AMOUNT_NOT_MATCH");
873             IWETH(_WETH_).deposit{value: fromTokenAmount}();
874         }
875 
876         for (uint256 i = 0; i < dodoPairs.length; i++) {
877             address curDodoPair = dodoPairs[i];
878             if (directions & 1 == 0) {
879                 address curDodoBase = IDODOV1(curDodoPair)._BASE_TOKEN_();
880                 require(curDodoBase != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_CHI");
881                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
882                 IERC20(curDodoBase).universalApproveMax(curDodoPair, curAmountIn);
883                 IDODOV1(curDodoPair).sellBaseToken(curAmountIn, 0, "");
884             } else {
885                 address curDodoQuote = IDODOV1(curDodoPair)._QUOTE_TOKEN_();
886                 require(curDodoQuote != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_CHI");
887                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
888                 IERC20(curDodoQuote).universalApproveMax(curDodoPair, curAmountIn);
889                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
890                     curDodoPair,
891                     curAmountIn
892                 );
893                 IDODOV1(curDodoPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
894             }
895             directions = directions >> 1;
896         }
897 
898         if (toToken == _ETH_ADDRESS_) {
899             returnAmount = IWETH(_WETH_).balanceOf(address(this));
900             IWETH(_WETH_).withdraw(returnAmount);
901         } else {
902             returnAmount = IERC20(toToken).tokenBalanceOf(address(this));
903         }
904         
905         require(returnAmount >= minReturnAmount, "DODOV1Proxy03: Return amount is not enough");
906         IERC20(toToken).universalTransfer(msg.sender, returnAmount);
907         
908         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
909         
910         uint256 _gasDodoMaxReturn = _GAS_DODO_MAX_RETURN_;
911         if(_gasDodoMaxReturn > 0) {
912             uint256 calcGasTokenBurn = originGas.sub(gasleft()) / 65000;
913             uint256 gasTokenBurn = calcGasTokenBurn > _gasDodoMaxReturn ? _gasDodoMaxReturn : calcGasTokenBurn;
914             if(gasleft() > 27710 + gasTokenBurn * 6080)
915                 IChi(_CHI_TOKEN_).freeUpTo(gasTokenBurn);
916         }
917     }
918 
919     function externalSwap(
920         address fromToken,
921         address toToken,
922         address approveTarget,
923         address swapTarget,
924         uint256 fromTokenAmount,
925         uint256 minReturnAmount,
926         bytes memory callDataConcat,
927         uint256 deadLine
928     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
929         require(minReturnAmount > 0, "DODOV1Proxy03: RETURN_AMOUNT_ZERO");
930         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_SELL_CHI");
931         require(toToken != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_BUY_CHI");
932 
933         address _fromToken = fromToken;
934         address _toToken = toToken;
935         
936         uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);
937 
938         if (_fromToken != _ETH_ADDRESS_) {
939             IDODOApprove(_DODO_APPROVE_).claimTokens(
940                 _fromToken,
941                 msg.sender,
942                 address(this),
943                 fromTokenAmount
944             );
945             IERC20(_fromToken).universalApproveMax(approveTarget, fromTokenAmount);
946         }
947 
948         require(isWhiteListed[swapTarget], "DODOV1Proxy03: Not Whitelist Contract");
949         (bool success, ) = swapTarget.call{value: _fromToken == _ETH_ADDRESS_ ? msg.value : 0}(callDataConcat);
950 
951         require(success, "DODOV1Proxy03: External Swap execution Failed");
952 
953         IERC20(_toToken).universalTransfer(
954             msg.sender,
955             IERC20(_toToken).universalBalanceOf(address(this))
956         );
957         returnAmount = IERC20(_toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
958         require(returnAmount >= minReturnAmount, "DODOV1Proxy03: Return amount is not enough");
959 
960         emit OrderHistory(_fromToken, _toToken, msg.sender, fromTokenAmount, returnAmount);
961         
962         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
963         if(_gasExternalReturn > 0) {
964             if(gasleft() > 27710 + _gasExternalReturn * 6080)
965                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
966         }
967     }
968 
969 
970     function mixSwapV1(
971         address fromToken,
972         address toToken,
973         uint256 fromTokenAmount,
974         uint256 minReturnAmount,
975         address[] memory mixPairs,
976         uint256[] memory directions,
977         address[] memory portionPath,
978         uint256 deadLine
979     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
980         require(mixPairs.length == directions.length, "DODOV1Proxy03: PARAMS_LENGTH_NOT_MATCH");
981         require(mixPairs.length > 0, "DODOV1Proxy03: PAIRS_EMPTY");
982         require(minReturnAmount > 0, "DODOV1Proxy03: RETURN_AMOUNT_ZERO");
983         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_SELL_CHI");
984         require(toToken != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_BUY_CHI");
985 
986         uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);
987 
988         if (fromToken != _ETH_ADDRESS_) {
989             IDODOApprove(_DODO_APPROVE_).claimTokens(
990                 fromToken,
991                 msg.sender,
992                 address(this),
993                 fromTokenAmount
994             );
995         } else {
996             require(msg.value == fromTokenAmount, "DODOV1Proxy03: ETH_AMOUNT_NOT_MATCH");
997             IWETH(_WETH_).deposit{value: fromTokenAmount}();
998         }
999 
1000         for (uint256 i = 0; i < mixPairs.length; i++) {
1001             address curPair = mixPairs[i];
1002             if (directions[i] == 0) {
1003                 address curDodoBase = IDODOV1(curPair)._BASE_TOKEN_();
1004                 require(curDodoBase != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_CHI");
1005                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
1006                 IERC20(curDodoBase).universalApproveMax(curPair, curAmountIn);
1007                 IDODOV1(curPair).sellBaseToken(curAmountIn, 0, "");
1008             } else if(directions[i] == 1){
1009                 address curDodoQuote = IDODOV1(curPair)._QUOTE_TOKEN_();
1010                 require(curDodoQuote != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_CHI");
1011                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
1012                 IERC20(curDodoQuote).universalApproveMax(curPair, curAmountIn);
1013                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
1014                     curPair,
1015                     curAmountIn
1016                 );
1017                 IDODOV1(curPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
1018             } else {
1019                 require(portionPath[0] != _CHI_TOKEN_, "DODOV1Proxy03: NOT_SUPPORT_CHI");
1020                 uint256 curAmountIn = IERC20(portionPath[0]).balanceOf(address(this));
1021                 IERC20(portionPath[0]).universalApproveMax(curPair, curAmountIn);
1022                 IUni(curPair).swapExactTokensForTokens(curAmountIn,0,portionPath,address(this),deadLine);
1023             }
1024         }
1025 
1026         IERC20(toToken).universalTransfer(
1027             msg.sender,
1028             IERC20(toToken).universalBalanceOf(address(this))
1029         );
1030 
1031         returnAmount = IERC20(toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
1032         require(returnAmount >= minReturnAmount, "DODOV1Proxy03: Return amount is not enough");
1033 
1034         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
1035         
1036         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
1037         if(_gasExternalReturn > 0) {
1038             if(gasleft() > 27710 + _gasExternalReturn * 6080)
1039                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
1040         }
1041     }
1042 }