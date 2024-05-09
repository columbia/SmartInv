1 // File: contracts/intf/IERC20.sol
2 
3 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity 0.6.9;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     function decimals() external view returns (uint8);
18 
19     function name() external view returns (string memory);
20 
21     function symbol() external view returns (string memory);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 }
77 
78 // File: contracts/lib/SafeMath.sol
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
141 /**
142  * @title SafeERC20
143  * @dev Wrappers around ERC20 operations that throw on failure (when the token
144  * contract returns false). Tokens that return no value (and instead revert or
145  * throw on failure) are also supported, non-reverting calls are assumed to be
146  * successful.
147  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
148  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
149  */
150 library SafeERC20 {
151     using SafeMath for uint256;
152 
153     function safeTransfer(
154         IERC20 token,
155         address to,
156         uint256 value
157     ) internal {
158         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
159     }
160 
161     function safeTransferFrom(
162         IERC20 token,
163         address from,
164         address to,
165         uint256 value
166     ) internal {
167         _callOptionalReturn(
168             token,
169             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
170         );
171     }
172 
173     function safeApprove(
174         IERC20 token,
175         address spender,
176         uint256 value
177     ) internal {
178         // safeApprove should only be called when setting an initial allowance,
179         // or when resetting it to zero. To increase and decrease it, use
180         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
181         // solhint-disable-next-line max-line-length
182         require(
183             (value == 0) || (token.allowance(address(this), spender) == 0),
184             "SafeERC20: approve from non-zero to non-zero allowance"
185         );
186         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
187     }
188 
189     /**
190      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
191      * on the return value: the return value is optional (but if data is returned, it must not be false).
192      * @param token The token targeted by the call.
193      * @param data The call data (encoded using abi.encode or one of its variants).
194      */
195     function _callOptionalReturn(IERC20 token, bytes memory data) private {
196         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
197         // we're implementing it ourselves.
198 
199         // A Solidity high level call has three parts:
200         //  1. The target address is checked to verify it contains contract code
201         //  2. The call itself is made, and success asserted
202         //  3. The return value is decoded, which in turn checks the size of the returned data.
203         // solhint-disable-next-line max-line-length
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = address(token).call(data);
207         require(success, "SafeERC20: low-level call failed");
208 
209         if (returndata.length > 0) {
210             // Return data is optional
211             // solhint-disable-next-line max-line-length
212             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
213         }
214     }
215 }
216 
217 // File: contracts/SmartRoute/lib/UniversalERC20.sol
218 
219 
220 
221 library UniversalERC20 {
222     using SafeMath for uint256;
223     using SafeERC20 for IERC20;
224 
225     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
226 
227     function universalTransfer(
228         IERC20 token,
229         address payable to,
230         uint256 amount
231     ) internal {
232         if (amount > 0) {
233             if (isETH(token)) {
234                 to.transfer(amount);
235             } else {
236                 token.safeTransfer(to, amount);
237             }
238         }
239     }
240 
241     function universalApproveMax(
242         IERC20 token,
243         address to,
244         uint256 amount
245     ) internal {
246         uint256 allowance = token.allowance(address(this), to);
247         if (allowance < amount) {
248             if (allowance > 0) {
249                 token.safeApprove(to, 0);
250             }
251             token.safeApprove(to, uint256(-1));
252         }
253     }
254 
255     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
256         if (isETH(token)) {
257             return who.balance;
258         } else {
259             return token.balanceOf(who);
260         }
261     }
262 
263     function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {
264         return token.balanceOf(who);
265     }
266 
267     function isETH(IERC20 token) internal pure returns (bool) {
268         return token == ETH_ADDRESS;
269     }
270 }
271 
272 // File: contracts/SmartRoute/intf/IDODOV1.sol
273 
274 
275 interface IDODOV1 {
276     function init(
277         address owner,
278         address supervisor,
279         address maintainer,
280         address baseToken,
281         address quoteToken,
282         address oracle,
283         uint256 lpFeeRate,
284         uint256 mtFeeRate,
285         uint256 k,
286         uint256 gasPriceLimit
287     ) external;
288 
289     function transferOwnership(address newOwner) external;
290 
291     function claimOwnership() external;
292 
293     function sellBaseToken(
294         uint256 amount,
295         uint256 minReceiveQuote,
296         bytes calldata data
297     ) external returns (uint256);
298 
299     function buyBaseToken(
300         uint256 amount,
301         uint256 maxPayQuote,
302         bytes calldata data
303     ) external returns (uint256);
304 
305     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
306 
307     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
308 
309     function depositBaseTo(address to, uint256 amount) external returns (uint256);
310 
311     function withdrawBase(uint256 amount) external returns (uint256);
312 
313     function withdrawAllBase() external returns (uint256);
314 
315     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
316 
317     function withdrawQuote(uint256 amount) external returns (uint256);
318 
319     function withdrawAllQuote() external returns (uint256);
320 
321     function _BASE_CAPITAL_TOKEN_() external returns (address);
322 
323     function _QUOTE_CAPITAL_TOKEN_() external returns (address);
324 
325     function _BASE_TOKEN_() external view returns (address);
326 
327     function _QUOTE_TOKEN_() external view returns (address);
328 
329     function _R_STATUS_() external view returns (uint8);
330 
331     function _QUOTE_BALANCE_() external view returns (uint256);
332 
333     function _BASE_BALANCE_() external view returns (uint256);
334 
335     function _K_() external view returns (uint256);
336 
337     function _MT_FEE_RATE_() external view returns (uint256);
338 
339     function _LP_FEE_RATE_() external view returns (uint256);
340 
341     function getExpectedTarget() external view returns (uint256 baseTarget, uint256 quoteTarget);
342 
343     function getOraclePrice() external view returns (uint256);
344 
345     function getMidPrice() external view returns (uint256 midPrice); 
346 }
347 
348 // File: contracts/lib/DecimalMath.sol
349 
350 
351 /**
352  * @title DecimalMath
353  * @author DODO Breeder
354  *
355  * @notice Functions for fixed point number with 18 decimals
356  */
357 library DecimalMath {
358     using SafeMath for uint256;
359 
360     uint256 internal constant ONE = 10**18;
361     uint256 internal constant ONE2 = 10**36;
362 
363     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
364         return target.mul(d) / (10**18);
365     }
366 
367     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
368         return target.mul(d).divCeil(10**18);
369     }
370 
371     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
372         return target.mul(10**18).div(d);
373     }
374 
375     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
376         return target.mul(10**18).divCeil(d);
377     }
378 
379     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
380         return uint256(10**36).div(target);
381     }
382 
383     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
384         return uint256(10**36).divCeil(target);
385     }
386 }
387 
388 // File: contracts/SmartRoute/helper/DODOSellHelper.sol
389 
390 
391 
392 
393 // import {DODOMath} from "../lib/DODOMath.sol";
394 
395 interface IDODOSellHelper {
396     function querySellQuoteToken(address dodo, uint256 amount) external view returns (uint256);
397     
398     function querySellBaseToken(address dodo, uint256 amount) external view returns (uint256);
399 }
400 
401 library DODOMath {
402     using SafeMath for uint256;
403 
404     /*
405         Integrate dodo curve fron V1 to V2
406         require V0>=V1>=V2>0
407         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
408         let V1-V2=delta
409         res = i*delta*(1-k+k(V0^2/V1/V2))
410     */
411     function _GeneralIntegrate(
412         uint256 V0,
413         uint256 V1,
414         uint256 V2,
415         uint256 i,
416         uint256 k
417     ) internal pure returns (uint256) {
418         uint256 fairAmount = DecimalMath.mulFloor(i, V1.sub(V2)); // i*delta
419         uint256 V0V0V1V2 = DecimalMath.divCeil(V0.mul(V0).div(V1), V2);
420         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
421         return DecimalMath.mulFloor(fairAmount, DecimalMath.ONE.sub(k).add(penalty));
422     }
423 
424     /*
425         The same with integration expression above, we have:
426         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
427         Given Q1 and deltaB, solve Q2
428         This is a quadratic function and the standard version is
429         aQ2^2 + bQ2 + c = 0, where
430         a=1-k
431         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
432         c=-kQ0^2
433         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
434         note: another root is negative, abondan
435         if deltaBSig=true, then Q2>Q1
436         if deltaBSig=false, then Q2<Q1
437     */
438     function _SolveQuadraticFunctionForTrade(
439         uint256 Q0,
440         uint256 Q1,
441         uint256 ideltaB,
442         bool deltaBSig,
443         uint256 k
444     ) internal pure returns (uint256) {
445         // calculate -b value and sig
446         // -b = (1-k)Q1-kQ0^2/Q1+i*deltaB
447         uint256 kQ02Q1 = DecimalMath.mulFloor(k, Q0).mul(Q0).div(Q1); // kQ0^2/Q1
448         uint256 b = DecimalMath.mulFloor(DecimalMath.ONE.sub(k), Q1); // (1-k)Q1
449         bool minusbSig = true;
450         if (deltaBSig) {
451             b = b.add(ideltaB); // (1-k)Q1+i*deltaB
452         } else {
453             kQ02Q1 = kQ02Q1.add(ideltaB); // i*deltaB+kQ0^2/Q1
454         }
455         if (b >= kQ02Q1) {
456             b = b.sub(kQ02Q1);
457             minusbSig = true;
458         } else {
459             b = kQ02Q1.sub(b);
460             minusbSig = false;
461         }
462 
463         // calculate sqrt
464         uint256 squareRoot = DecimalMath.mulFloor(
465             DecimalMath.ONE.sub(k).mul(4),
466             DecimalMath.mulFloor(k, Q0).mul(Q0)
467         ); // 4(1-k)kQ0^2
468         squareRoot = b.mul(b).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
469 
470         // final res
471         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
472         uint256 numerator;
473         if (minusbSig) {
474             numerator = b.add(squareRoot);
475         } else {
476             numerator = squareRoot.sub(b);
477         }
478 
479         if (deltaBSig) {
480             return DecimalMath.divFloor(numerator, denominator);
481         } else {
482             return DecimalMath.divCeil(numerator, denominator);
483         }
484     }
485 
486     /*
487         Start from the integration function
488         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
489         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
490         let fairAmount = i*deltaB
491     */
492     function _SolveQuadraticFunctionForTarget(
493         uint256 V1,
494         uint256 k,
495         uint256 fairAmount
496     ) internal pure returns (uint256 V0) {
497         // V0 = V1+V1*(sqrt-1)/2k
498         uint256 sqrt = DecimalMath.divCeil(DecimalMath.mulFloor(k, fairAmount).mul(4), V1);
499         sqrt = sqrt.add(DecimalMath.ONE).mul(DecimalMath.ONE).sqrt();
500         uint256 premium = DecimalMath.divCeil(sqrt.sub(DecimalMath.ONE), k.mul(2));
501         // V0 is greater than or equal to V1 according to the solution
502         return DecimalMath.mulFloor(V1, DecimalMath.ONE.add(premium));
503     }
504 }
505 
506 contract DODOSellHelper {
507     using SafeMath for uint256;
508 
509     enum RStatus {ONE, ABOVE_ONE, BELOW_ONE}
510 
511     uint256 constant ONE = 10**18;
512 
513     struct DODOState {
514         uint256 oraclePrice;
515         uint256 K;
516         uint256 B;
517         uint256 Q;
518         uint256 baseTarget;
519         uint256 quoteTarget;
520         RStatus rStatus;
521     }
522 
523     function querySellBaseToken(address dodo, uint256 amount) public view returns (uint256) {
524         return IDODOV1(dodo).querySellBaseToken(amount);
525     }
526 
527     function querySellQuoteToken(address dodo, uint256 amount) public view returns (uint256) {
528         DODOState memory state;
529         (state.baseTarget, state.quoteTarget) = IDODOV1(dodo).getExpectedTarget();
530         state.rStatus = RStatus(IDODOV1(dodo)._R_STATUS_());
531         state.oraclePrice = IDODOV1(dodo).getOraclePrice();
532         state.Q = IDODOV1(dodo)._QUOTE_BALANCE_();
533         state.B = IDODOV1(dodo)._BASE_BALANCE_();
534         state.K = IDODOV1(dodo)._K_();
535 
536         uint256 boughtAmount;
537         // Determine the status (RStatus) and calculate the amount
538         // based on the state
539         if (state.rStatus == RStatus.ONE) {
540             boughtAmount = _ROneSellQuoteToken(amount, state);
541         } else if (state.rStatus == RStatus.ABOVE_ONE) {
542             boughtAmount = _RAboveSellQuoteToken(amount, state);
543         } else {
544             uint256 backOneBase = state.B.sub(state.baseTarget);
545             uint256 backOneQuote = state.quoteTarget.sub(state.Q);
546             if (amount <= backOneQuote) {
547                 boughtAmount = _RBelowSellQuoteToken(amount, state);
548             } else {
549                 boughtAmount = backOneBase.add(
550                     _ROneSellQuoteToken(amount.sub(backOneQuote), state)
551                 );
552             }
553         }
554         // Calculate fees
555         return
556             DecimalMath.divFloor(
557                 boughtAmount,
558                 DecimalMath.ONE.add(IDODOV1(dodo)._MT_FEE_RATE_()).add(
559                     IDODOV1(dodo)._LP_FEE_RATE_()
560                 )
561             );
562     }
563 
564     function _ROneSellQuoteToken(uint256 amount, DODOState memory state)
565         internal
566         pure
567         returns (uint256 receiveBaseToken)
568     {
569         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
570         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
571             state.baseTarget,
572             state.baseTarget,
573             DecimalMath.mulFloor(i, amount),
574             false,
575             state.K
576         );
577         return state.baseTarget.sub(B2);
578     }
579 
580     function _RAboveSellQuoteToken(uint256 amount, DODOState memory state)
581         internal
582         pure
583         returns (uint256 receieBaseToken)
584     {
585         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
586         uint256 B2 = DODOMath._SolveQuadraticFunctionForTrade(
587             state.baseTarget,
588             state.B,
589             DecimalMath.mulFloor(i, amount),
590             false,
591             state.K
592         );
593         return state.B.sub(B2);
594     }
595 
596     function _RBelowSellQuoteToken(uint256 amount, DODOState memory state)
597         internal
598         pure
599         returns (uint256 receiveBaseToken)
600     {
601         uint256 Q1 = state.Q.add(amount);
602         uint256 i = DecimalMath.divFloor(ONE, state.oraclePrice);
603         return DODOMath._GeneralIntegrate(state.quoteTarget, Q1, state.Q, i, state.K);
604     }
605 }
606 
607 // File: contracts/intf/IWETH.sol
608 
609 
610 
611 interface IWETH {
612     function totalSupply() external view returns (uint256);
613 
614     function balanceOf(address account) external view returns (uint256);
615 
616     function transfer(address recipient, uint256 amount) external returns (bool);
617 
618     function allowance(address owner, address spender) external view returns (uint256);
619 
620     function approve(address spender, uint256 amount) external returns (bool);
621 
622     function transferFrom(
623         address src,
624         address dst,
625         uint256 wad
626     ) external returns (bool);
627 
628     function deposit() external payable;
629 
630     function withdraw(uint256 wad) external;
631 }
632 
633 // File: contracts/SmartRoute/intf/IChi.sol
634 
635 
636 interface IChi {
637     function freeUpTo(uint256 value) external returns (uint256);
638 }
639 
640 // File: contracts/SmartRoute/intf/IUni.sol
641 
642 
643 interface IUni {
644     function swapExactTokensForTokens(
645         uint amountIn,
646         uint amountOutMin,
647         address[] calldata path,
648         address to,
649         uint deadline
650     ) external returns (uint[] memory amounts);
651 
652     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
653 
654     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
655 
656     function token0() external view returns (address);
657     
658     function token1() external view returns (address);
659 }
660 
661 // File: contracts/intf/IDODOApprove.sol
662 
663 interface IDODOApprove {
664     function claimTokens(address token,address who,address dest,uint256 amount) external;
665     function getDODOProxy() external view returns (address);
666 }
667 
668 // File: contracts/lib/InitializableOwnable.sol
669 
670 
671 /**
672  * @title Ownable
673  * @author DODO Breeder
674  *
675  * @notice Ownership related functions
676  */
677 contract InitializableOwnable {
678     address public _OWNER_;
679     address public _NEW_OWNER_;
680     bool internal _INITIALIZED_;
681 
682     // ============ Events ============
683 
684     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
685 
686     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
687 
688     // ============ Modifiers ============
689 
690     modifier notInitialized() {
691         require(!_INITIALIZED_, "DODO_INITIALIZED");
692         _;
693     }
694 
695     modifier onlyOwner() {
696         require(msg.sender == _OWNER_, "NOT_OWNER");
697         _;
698     }
699 
700     // ============ Functions ============
701 
702     function initOwner(address newOwner) public notInitialized {
703         _INITIALIZED_ = true;
704         _OWNER_ = newOwner;
705     }
706 
707     function transferOwnership(address newOwner) public onlyOwner {
708         emit OwnershipTransferPrepared(_OWNER_, newOwner);
709         _NEW_OWNER_ = newOwner;
710     }
711 
712     function claimOwnership() public {
713         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
714         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
715         _OWNER_ = _NEW_OWNER_;
716         _NEW_OWNER_ = address(0);
717     }
718 }
719 
720 // File: contracts/SmartRoute/DODOApproveProxy.sol
721 
722 
723 
724 interface IDODOApproveProxy {
725     function isAllowedProxy(address _proxy) external view returns (bool);
726     function claimTokens(address token,address who,address dest,uint256 amount) external;
727 }
728 
729 /**
730  * @title DODOApproveProxy
731  * @author DODO Breeder
732  *
733  * @notice Allow different version dodoproxy to claim from DODOApprove
734  */
735 contract DODOApproveProxy is InitializableOwnable {
736     
737     // ============ Storage ============
738     uint256 private constant _TIMELOCK_DURATION_ = 3 days;
739     mapping (address => bool) public _IS_ALLOWED_PROXY_;
740     uint256 public _TIMELOCK_;
741     address public _PENDING_ADD_DODO_PROXY_;
742     address public immutable _DODO_APPROVE_;
743 
744     // ============ Modifiers ============
745     modifier notLocked() {
746         require(
747             _TIMELOCK_ <= block.timestamp,
748             "SetProxy is timelocked"
749         );
750         _;
751     }
752 
753     constructor(address dodoApporve) public {
754         _DODO_APPROVE_ = dodoApporve;
755     }
756 
757     function init(address owner, address[] memory proxies) external {
758         initOwner(owner);
759         for(uint i = 0; i < proxies.length; i++) 
760             _IS_ALLOWED_PROXY_[proxies[i]] = true;
761     }
762 
763     function unlockAddProxy(address newDodoProxy) public onlyOwner {
764         _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;
765         _PENDING_ADD_DODO_PROXY_ = newDodoProxy;
766     }
767 
768     function lockAddProxy() public onlyOwner {
769        _PENDING_ADD_DODO_PROXY_ = address(0);
770        _TIMELOCK_ = 0;
771     }
772 
773 
774     function addDODOProxy() external onlyOwner notLocked() {
775         _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;
776         lockAddProxy();
777     }
778 
779     function removeDODOProxy (address oldDodoProxy) public onlyOwner {
780         _IS_ALLOWED_PROXY_[oldDodoProxy] = false;
781     }
782     
783     function claimTokens(
784         address token,
785         address who,
786         address dest,
787         uint256 amount
788     ) external {
789         require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");
790         IDODOApprove(_DODO_APPROVE_).claimTokens(
791             token,
792             who,
793             dest,
794             amount
795         );
796     }
797 
798     function isAllowedProxy(address _proxy) external view returns (bool) {
799         return _IS_ALLOWED_PROXY_[_proxy];
800     }
801 }
802 
803 // File: contracts/SmartRoute/intf/IDODOV1Proxy02.sol
804 
805 
806 interface IDODOV1Proxy02 {
807     function dodoSwapV1(
808         address fromToken,
809         address toToken,
810         uint256 fromTokenAmount,
811         uint256 minReturnAmount,
812         address[] memory dodoPairs,
813         uint256 directions,
814         uint256 deadLine
815     ) external payable returns (uint256 returnAmount);
816 
817     function externalSwap(
818         address fromToken,
819         address toToken,
820         address approveTarget,
821         address to,
822         uint256 fromTokenAmount,
823         uint256 minReturnAmount,
824         bytes memory callDataConcat,
825         uint256 deadLine
826     ) external payable returns (uint256 returnAmount);
827 
828     function mixSwapV1(
829         address fromToken,
830         address toToken,
831         uint256 fromTokenAmount,
832         uint256 minReturnAmount,
833         address[] memory mixPairs,
834         uint256[] memory directions,
835         address[] memory portionPath,
836         uint256 deadLine
837     ) external payable returns (uint256 returnAmount);
838 }
839 
840 // File: contracts/SmartRoute/DODOV1Proxy04.sol
841 
842 
843 
844 
845 
846 
847 
848 
849 
850 
851 
852 
853 /**
854  * @title DODOV1Proxy04
855  * @author DODO Breeder
856  *
857  * @notice Entrance of trading in DODO platform
858  */
859 contract DODOV1Proxy04 is IDODOV1Proxy02, InitializableOwnable {
860     using SafeMath for uint256;
861     using UniversalERC20 for IERC20;
862 
863     // ============ Storage ============
864 
865     address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
866     address public immutable _DODO_APPROVE_PROXY_;
867     address public immutable _DODO_SELL_HELPER_;
868     address public immutable _WETH_;
869     address public immutable _CHI_TOKEN_;
870     uint256 public _GAS_DODO_MAX_RETURN_ = 10;
871     uint256 public _GAS_EXTERNAL_RETURN_ = 5;
872     mapping (address => bool) public isWhiteListed;
873 
874     // ============ Events ============
875 
876     event OrderHistory(
877         address indexed fromToken,
878         address indexed toToken,
879         address indexed sender,
880         uint256 fromAmount,
881         uint256 returnAmount
882     );
883 
884     // ============ Modifiers ============
885 
886     modifier judgeExpired(uint256 deadLine) {
887         require(deadLine >= block.timestamp, "DODOV1Proxy04: EXPIRED");
888         _;
889     }
890 
891     constructor(
892         address dodoApproveProxy,
893         address dodoSellHelper,
894         address weth,
895         address chiToken
896     ) public {
897         _DODO_APPROVE_PROXY_ = dodoApproveProxy;
898         _DODO_SELL_HELPER_ = dodoSellHelper;
899         _WETH_ = weth;
900         _CHI_TOKEN_ = chiToken;
901     }
902 
903     fallback() external payable {}
904 
905     receive() external payable {}
906 
907     function updateGasReturn(uint256 newDodoGasReturn, uint256 newExternalGasReturn) public onlyOwner {
908         _GAS_DODO_MAX_RETURN_ = newDodoGasReturn;
909         _GAS_EXTERNAL_RETURN_ = newExternalGasReturn;
910     }
911 
912     function addWhiteList (address contractAddr) public onlyOwner {
913         isWhiteListed[contractAddr] = true;
914     }
915 
916     function removeWhiteList (address contractAddr) public onlyOwner {
917         isWhiteListed[contractAddr] = false;
918     }
919 
920     function dodoSwapV1(
921         address fromToken,
922         address toToken,
923         uint256 fromTokenAmount,
924         uint256 minReturnAmount,
925         address[] memory dodoPairs,
926         uint256 directions,
927         uint256 deadLine
928     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
929         require(dodoPairs.length > 0, "DODOV1Proxy04: PAIRS_EMPTY");
930         require(minReturnAmount > 0, "DODOV1Proxy04: RETURN_AMOUNT_ZERO");
931         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_SELL_CHI");
932         require(toToken != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_BUY_CHI");
933 
934         uint256 originGas = gasleft();
935 
936         if (fromToken != _ETH_ADDRESS_) {
937             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
938                 fromToken,
939                 msg.sender,
940                 address(this),
941                 fromTokenAmount
942             );
943         } else {
944             require(msg.value == fromTokenAmount, "DODOV1Proxy04: ETH_AMOUNT_NOT_MATCH");
945             IWETH(_WETH_).deposit{value: fromTokenAmount}();
946         }
947 
948         for (uint256 i = 0; i < dodoPairs.length; i++) {
949             address curDodoPair = dodoPairs[i];
950             if (directions & 1 == 0) {
951                 address curDodoBase = IDODOV1(curDodoPair)._BASE_TOKEN_();
952                 require(curDodoBase != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_CHI");
953                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
954                 IERC20(curDodoBase).universalApproveMax(curDodoPair, curAmountIn);
955                 IDODOV1(curDodoPair).sellBaseToken(curAmountIn, 0, "");
956             } else {
957                 address curDodoQuote = IDODOV1(curDodoPair)._QUOTE_TOKEN_();
958                 require(curDodoQuote != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_CHI");
959                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
960                 IERC20(curDodoQuote).universalApproveMax(curDodoPair, curAmountIn);
961                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
962                     curDodoPair,
963                     curAmountIn
964                 );
965                 IDODOV1(curDodoPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
966             }
967             directions = directions >> 1;
968         }
969 
970         if (toToken == _ETH_ADDRESS_) {
971             returnAmount = IWETH(_WETH_).balanceOf(address(this));
972             IWETH(_WETH_).withdraw(returnAmount);
973         } else {
974             returnAmount = IERC20(toToken).tokenBalanceOf(address(this));
975         }
976         
977         require(returnAmount >= minReturnAmount, "DODOV1Proxy04: Return amount is not enough");
978         IERC20(toToken).universalTransfer(msg.sender, returnAmount);
979         
980         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
981         
982         uint256 _gasDodoMaxReturn = _GAS_DODO_MAX_RETURN_;
983         if(_gasDodoMaxReturn > 0) {
984             uint256 calcGasTokenBurn = originGas.sub(gasleft()) / 65000;
985             uint256 gasTokenBurn = calcGasTokenBurn > _gasDodoMaxReturn ? _gasDodoMaxReturn : calcGasTokenBurn;
986             if(gasleft() > 27710 + gasTokenBurn * 6080)
987                 IChi(_CHI_TOKEN_).freeUpTo(gasTokenBurn);
988         }
989     }
990 
991     function externalSwap(
992         address fromToken,
993         address toToken,
994         address approveTarget,
995         address swapTarget,
996         uint256 fromTokenAmount,
997         uint256 minReturnAmount,
998         bytes memory callDataConcat,
999         uint256 deadLine
1000     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
1001         require(minReturnAmount > 0, "DODOV1Proxy04: RETURN_AMOUNT_ZERO");
1002         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_SELL_CHI");
1003         require(toToken != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_BUY_CHI");
1004 
1005         address _fromToken = fromToken;
1006         address _toToken = toToken;
1007         
1008         uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);
1009 
1010         if (_fromToken != _ETH_ADDRESS_) {
1011             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
1012                 _fromToken,
1013                 msg.sender,
1014                 address(this),
1015                 fromTokenAmount
1016             );
1017             IERC20(_fromToken).universalApproveMax(approveTarget, fromTokenAmount);
1018         }
1019 
1020         require(isWhiteListed[swapTarget], "DODOV1Proxy04: Not Whitelist Contract");
1021         (bool success, ) = swapTarget.call{value: _fromToken == _ETH_ADDRESS_ ? msg.value : 0}(callDataConcat);
1022 
1023         require(success, "DODOV1Proxy04: External Swap execution Failed");
1024 
1025         IERC20(_toToken).universalTransfer(
1026             msg.sender,
1027             IERC20(_toToken).universalBalanceOf(address(this))
1028         );
1029         returnAmount = IERC20(_toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
1030         require(returnAmount >= minReturnAmount, "DODOV1Proxy04: Return amount is not enough");
1031 
1032         emit OrderHistory(_fromToken, _toToken, msg.sender, fromTokenAmount, returnAmount);
1033         
1034         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
1035         if(_gasExternalReturn > 0) {
1036             if(gasleft() > 27710 + _gasExternalReturn * 6080)
1037                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
1038         }
1039     }
1040 
1041 
1042     function mixSwapV1(
1043         address fromToken,
1044         address toToken,
1045         uint256 fromTokenAmount,
1046         uint256 minReturnAmount,
1047         address[] memory mixPairs,
1048         uint256[] memory directions,
1049         address[] memory portionPath,
1050         uint256 deadLine
1051     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
1052         require(mixPairs.length == directions.length, "DODOV1Proxy04: PARAMS_LENGTH_NOT_MATCH");
1053         require(mixPairs.length > 0, "DODOV1Proxy04: PAIRS_EMPTY");
1054         require(minReturnAmount > 0, "DODOV1Proxy04: RETURN_AMOUNT_ZERO");
1055         require(fromToken != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_SELL_CHI");
1056         require(toToken != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_BUY_CHI");
1057 
1058         uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);
1059 
1060         if (fromToken != _ETH_ADDRESS_) {
1061             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
1062                 fromToken,
1063                 msg.sender,
1064                 address(this),
1065                 fromTokenAmount
1066             );
1067         } else {
1068             require(msg.value == fromTokenAmount, "DODOV1Proxy04: ETH_AMOUNT_NOT_MATCH");
1069             IWETH(_WETH_).deposit{value: fromTokenAmount}();
1070         }
1071 
1072         for (uint256 i = 0; i < mixPairs.length; i++) {
1073             address curPair = mixPairs[i];
1074             if (directions[i] == 0) {
1075                 address curDodoBase = IDODOV1(curPair)._BASE_TOKEN_();
1076                 require(curDodoBase != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_CHI");
1077                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
1078                 IERC20(curDodoBase).universalApproveMax(curPair, curAmountIn);
1079                 IDODOV1(curPair).sellBaseToken(curAmountIn, 0, "");
1080             } else if(directions[i] == 1){
1081                 address curDodoQuote = IDODOV1(curPair)._QUOTE_TOKEN_();
1082                 require(curDodoQuote != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_CHI");
1083                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
1084                 IERC20(curDodoQuote).universalApproveMax(curPair, curAmountIn);
1085                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
1086                     curPair,
1087                     curAmountIn
1088                 );
1089                 IDODOV1(curPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
1090             } else {
1091                 require(portionPath[0] != _CHI_TOKEN_, "DODOV1Proxy04: NOT_SUPPORT_CHI");
1092                 uint256 curAmountIn = IERC20(portionPath[0]).balanceOf(address(this));
1093                 IERC20(portionPath[0]).universalApproveMax(curPair, curAmountIn);
1094                 IUni(curPair).swapExactTokensForTokens(curAmountIn,0,portionPath,address(this),deadLine);
1095             }
1096         }
1097 
1098         IERC20(toToken).universalTransfer(
1099             msg.sender,
1100             IERC20(toToken).universalBalanceOf(address(this))
1101         );
1102 
1103         returnAmount = IERC20(toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
1104         require(returnAmount >= minReturnAmount, "DODOV1Proxy04: Return amount is not enough");
1105 
1106         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
1107         
1108         uint256 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
1109         if(_gasExternalReturn > 0) {
1110             if(gasleft() > 27710 + _gasExternalReturn * 6080)
1111                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
1112         }
1113     }
1114 }