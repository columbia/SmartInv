1 // File: contracts/lib/InitializableOwnable.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 /**
14  * @title Ownable
15  * @author DODO Breeder
16  *
17  * @notice Ownership related functions
18  */
19 contract InitializableOwnable {
20     address public _OWNER_;
21     address public _NEW_OWNER_;
22     bool internal _INITIALIZED_;
23 
24     // ============ Events ============
25 
26     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     // ============ Modifiers ============
31 
32     modifier notInitialized() {
33         require(!_INITIALIZED_, "DODO_INITIALIZED");
34         _;
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == _OWNER_, "NOT_OWNER");
39         _;
40     }
41 
42     // ============ Functions ============
43 
44     function initOwner(address newOwner) public notInitialized {
45         _INITIALIZED_ = true;
46         _OWNER_ = newOwner;
47     }
48 
49     function transferOwnership(address newOwner) public onlyOwner {
50         emit OwnershipTransferPrepared(_OWNER_, newOwner);
51         _NEW_OWNER_ = newOwner;
52     }
53 
54     function claimOwnership() public {
55         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
56         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
57         _OWNER_ = _NEW_OWNER_;
58         _NEW_OWNER_ = address(0);
59     }
60 }
61 
62 // File: contracts/lib/FeeRateModel.sol
63 
64 
65 interface IFeeRateImpl {
66     function getFeeRate(address pool, address trader) external view returns (uint256);
67 }
68 
69 interface IFeeRateModel {
70     function getFeeRate(address trader) external view returns (uint256);
71 }
72 
73 contract FeeRateModel is InitializableOwnable {
74     address public feeRateImpl;
75 
76     function setFeeProxy(address _feeRateImpl) public onlyOwner {
77         feeRateImpl = _feeRateImpl;
78     }
79     
80     function getFeeRate(address trader) external view returns (uint256) {
81         if(feeRateImpl == address(0))
82             return 0;
83         return IFeeRateImpl(feeRateImpl).getFeeRate(msg.sender,trader);
84     }
85 }
86 
87 // File: contracts/intf/IERC20.sol
88 
89 
90 /**
91  * @dev Interface of the ERC20 standard as defined in the EIP.
92  */
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     function decimals() external view returns (uint8);
100 
101     function name() external view returns (string memory);
102 
103     function symbol() external view returns (string memory);
104 
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109 
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `recipient`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transaction ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) external returns (bool);
158 }
159 
160 // File: contracts/lib/SafeMath.sol
161 
162 /**
163  * @title SafeMath
164  * @author DODO Breeder
165  *
166  * @notice Math operations with safety checks that revert on error
167  */
168 library SafeMath {
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "MUL_ERROR");
176 
177         return c;
178     }
179 
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b > 0, "DIVIDING_ERROR");
182         return a / b;
183     }
184 
185     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 quotient = div(a, b);
187         uint256 remainder = a - quotient * b;
188         if (remainder > 0) {
189             return quotient + 1;
190         } else {
191             return quotient;
192         }
193     }
194 
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a, "SUB_ERROR");
197         return a - b;
198     }
199 
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a, "ADD_ERROR");
203         return c;
204     }
205 
206     function sqrt(uint256 x) internal pure returns (uint256 y) {
207         uint256 z = x / 2 + 1;
208         y = x;
209         while (z < y) {
210             y = z;
211             z = (x / z + z) / 2;
212         }
213     }
214 }
215 
216 // File: contracts/lib/DecimalMath.sol
217 
218 /**
219  * @title DecimalMath
220  * @author DODO Breeder
221  *
222  * @notice Functions for fixed point number with 18 decimals
223  */
224 library DecimalMath {
225     using SafeMath for uint256;
226 
227     uint256 internal constant ONE = 10**18;
228     uint256 internal constant ONE2 = 10**36;
229 
230     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
231         return target.mul(d) / (10**18);
232     }
233 
234     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
235         return target.mul(d).divCeil(10**18);
236     }
237 
238     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
239         return target.mul(10**18).div(d);
240     }
241 
242     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
243         return target.mul(10**18).divCeil(d);
244     }
245 
246     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
247         return uint256(10**36).div(target);
248     }
249 
250     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
251         return uint256(10**36).divCeil(target);
252     }
253 }
254 
255 // File: contracts/lib/SafeERC20.sol
256 
257 
258 /**
259  * @title SafeERC20
260  * @dev Wrappers around ERC20 operations that throw on failure (when the token
261  * contract returns false). Tokens that return no value (and instead revert or
262  * throw on failure) are also supported, non-reverting calls are assumed to be
263  * successful.
264  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
265  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
266  */
267 library SafeERC20 {
268     using SafeMath for uint256;
269 
270     function safeTransfer(
271         IERC20 token,
272         address to,
273         uint256 value
274     ) internal {
275         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
276     }
277 
278     function safeTransferFrom(
279         IERC20 token,
280         address from,
281         address to,
282         uint256 value
283     ) internal {
284         _callOptionalReturn(
285             token,
286             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
287         );
288     }
289 
290     function safeApprove(
291         IERC20 token,
292         address spender,
293         uint256 value
294     ) internal {
295         // safeApprove should only be called when setting an initial allowance,
296         // or when resetting it to zero. To increase and decrease it, use
297         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
298         // solhint-disable-next-line max-line-length
299         require(
300             (value == 0) || (token.allowance(address(this), spender) == 0),
301             "SafeERC20: approve from non-zero to non-zero allowance"
302         );
303         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
304     }
305 
306     /**
307      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
308      * on the return value: the return value is optional (but if data is returned, it must not be false).
309      * @param token The token targeted by the call.
310      * @param data The call data (encoded using abi.encode or one of its variants).
311      */
312     function _callOptionalReturn(IERC20 token, bytes memory data) private {
313         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
314         // we're implementing it ourselves.
315 
316         // A Solidity high level call has three parts:
317         //  1. The target address is checked to verify it contains contract code
318         //  2. The call itself is made, and success asserted
319         //  3. The return value is decoded, which in turn checks the size of the returned data.
320         // solhint-disable-next-line max-line-length
321 
322         // solhint-disable-next-line avoid-low-level-calls
323         (bool success, bytes memory returndata) = address(token).call(data);
324         require(success, "SafeERC20: low-level call failed");
325 
326         if (returndata.length > 0) {
327             // Return data is optional
328             // solhint-disable-next-line max-line-length
329             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
330         }
331     }
332 }
333 
334 // File: contracts/lib/ReentrancyGuard.sol
335 
336 
337 /**
338  * @title ReentrancyGuard
339  * @author DODO Breeder
340  *
341  * @notice Protect functions from Reentrancy Attack
342  */
343 contract ReentrancyGuard {
344     // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
345     // zero-state of _ENTERED_ is false
346     bool private _ENTERED_;
347 
348     modifier preventReentrant() {
349         require(!_ENTERED_, "REENTRANT");
350         _ENTERED_ = true;
351         _;
352         _ENTERED_ = false;
353     }
354 }
355 
356 // File: contracts/lib/DODOMath.sol
357 
358 
359 /**
360  * @title DODOMath
361  * @author DODO Breeder
362  *
363  * @notice Functions for complex calculating. Including ONE Integration and TWO Quadratic solutions
364  */
365 library DODOMath {
366     using SafeMath for uint256;
367 
368     /*
369         Integrate dodo curve from V1 to V2
370         require V0>=V1>=V2>0
371         res = (1-k)i(V1-V2)+ikV0*V0(1/V2-1/V1)
372         let V1-V2=delta
373         res = i*delta*(1-k+k(V0^2/V1/V2))
374 
375         i is the price of V-res trading pair
376 
377         support k=1 & k=0 case
378 
379         [round down]
380     */
381     function _GeneralIntegrate(
382         uint256 V0,
383         uint256 V1,
384         uint256 V2,
385         uint256 i,
386         uint256 k
387     ) internal pure returns (uint256) {
388         require(V0 > 0, "TARGET_IS_ZERO");
389         uint256 fairAmount = i.mul(V1.sub(V2)); // i*delta
390         if (k == 0) {
391             return fairAmount.div(DecimalMath.ONE);
392         }
393         uint256 V0V0V1V2 = DecimalMath.divFloor(V0.mul(V0).div(V1), V2);
394         uint256 penalty = DecimalMath.mulFloor(k, V0V0V1V2); // k(V0^2/V1/V2)
395         return DecimalMath.ONE.sub(k).add(penalty).mul(fairAmount).div(DecimalMath.ONE2);
396     }
397 
398     /*
399         Follow the integration function above
400         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
401         Assume Q2=Q0, Given Q1 and deltaB, solve Q0
402 
403         i is the price of delta-V trading pair
404         give out target of V
405 
406         support k=1 & k=0 case
407 
408         [round down]
409     */
410     function _SolveQuadraticFunctionForTarget(
411         uint256 V1,
412         uint256 delta,
413         uint256 i,
414         uint256 k
415     ) internal pure returns (uint256) {
416         if (V1 == 0) {
417             return 0;
418         }
419         if (k == 0) {
420             return V1.add(DecimalMath.mulFloor(i, delta));
421         }
422         // V0 = V1*(1+(sqrt-1)/2k)
423         // sqrt = √(1+4kidelta/V1)
424         // premium = 1+(sqrt-1)/2k
425         // uint256 sqrt = (4 * k).mul(i).mul(delta).div(V1).add(DecimalMath.ONE2).sqrt();
426         uint256 sqrt;
427         uint256 ki = (4 * k).mul(i);
428         if (ki == 0) {
429             sqrt = DecimalMath.ONE;
430         } else if ((ki * delta) / ki == delta) {
431             sqrt = (ki * delta).div(V1).add(DecimalMath.ONE2).sqrt();
432         } else {
433             sqrt = ki.div(V1).mul(delta).add(DecimalMath.ONE2).sqrt();
434         }
435         uint256 premium =
436             DecimalMath.divFloor(sqrt.sub(DecimalMath.ONE), k * 2).add(DecimalMath.ONE);
437         // V0 is greater than or equal to V1 according to the solution
438         return DecimalMath.mulFloor(V1, premium);
439     }
440 
441     /*
442         Follow the integration expression above, we have:
443         i*deltaB = (Q2-Q1)*(1-k+kQ0^2/Q1/Q2)
444         Given Q1 and deltaB, solve Q2
445         This is a quadratic function and the standard version is
446         aQ2^2 + bQ2 + c = 0, where
447         a=1-k
448         -b=(1-k)Q1-kQ0^2/Q1+i*deltaB
449         c=-kQ0^2 
450         and Q2=(-b+sqrt(b^2+4(1-k)kQ0^2))/2(1-k)
451         note: another root is negative, abondan
452 
453         if deltaBSig=true, then Q2>Q1, user sell Q and receive B
454         if deltaBSig=false, then Q2<Q1, user sell B and receive Q
455         return |Q1-Q2|
456 
457         as we only support sell amount as delta, the deltaB is always negative
458         the input ideltaB is actually -ideltaB in the equation
459 
460         i is the price of delta-V trading pair
461 
462         support k=1 & k=0 case
463 
464         [round down]
465     */
466     function _SolveQuadraticFunctionForTrade(
467         uint256 V0,
468         uint256 V1,
469         uint256 delta,
470         uint256 i,
471         uint256 k
472     ) internal pure returns (uint256) {
473         require(V0 > 0, "TARGET_IS_ZERO");
474         if (delta == 0) {
475             return 0;
476         }
477 
478         if (k == 0) {
479             return DecimalMath.mulFloor(i, delta) > V1 ? V1 : DecimalMath.mulFloor(i, delta);
480         }
481 
482         if (k == DecimalMath.ONE) {
483             // if k==1
484             // Q2=Q1/(1+ideltaBQ1/Q0/Q0)
485             // temp = ideltaBQ1/Q0/Q0
486             // Q2 = Q1/(1+temp)
487             // Q1-Q2 = Q1*(1-1/(1+temp)) = Q1*(temp/(1+temp))
488             // uint256 temp = i.mul(delta).mul(V1).div(V0.mul(V0));
489             uint256 temp;
490             uint256 idelta = i.mul(delta);
491             if (idelta == 0) {
492                 temp = 0;
493             } else if ((idelta * V1) / idelta == V1) {
494                 temp = (idelta * V1).div(V0.mul(V0));
495             } else {
496                 temp = delta.mul(V1).div(V0).mul(i).div(V0);
497             }
498             return V1.mul(temp).div(temp.add(DecimalMath.ONE));
499         }
500 
501         // calculate -b value and sig
502         // b = kQ0^2/Q1-i*deltaB-(1-k)Q1
503         // part1 = (1-k)Q1 >=0
504         // part2 = kQ0^2/Q1-i*deltaB >=0
505         // bAbs = abs(part1-part2)
506         // if part1>part2 => b is negative => bSig is false
507         // if part2>part1 => b is positive => bSig is true
508         uint256 part2 = k.mul(V0).div(V1).mul(V0).add(i.mul(delta)); // kQ0^2/Q1-i*deltaB
509         uint256 bAbs = DecimalMath.ONE.sub(k).mul(V1); // (1-k)Q1
510 
511         bool bSig;
512         if (bAbs >= part2) {
513             bAbs = bAbs - part2;
514             bSig = false;
515         } else {
516             bAbs = part2 - bAbs;
517             bSig = true;
518         }
519         bAbs = bAbs.div(DecimalMath.ONE);
520 
521         // calculate sqrt
522         uint256 squareRoot =
523             DecimalMath.mulFloor(
524                 DecimalMath.ONE.sub(k).mul(4),
525                 DecimalMath.mulFloor(k, V0).mul(V0)
526             ); // 4(1-k)kQ0^2
527         squareRoot = bAbs.mul(bAbs).add(squareRoot).sqrt(); // sqrt(b*b+4(1-k)kQ0*Q0)
528 
529         // final res
530         uint256 denominator = DecimalMath.ONE.sub(k).mul(2); // 2(1-k)
531         uint256 numerator;
532         if (bSig) {
533             numerator = squareRoot.sub(bAbs);
534         } else {
535             numerator = bAbs.add(squareRoot);
536         }
537 
538         uint256 V2 = DecimalMath.divCeil(numerator, denominator);
539         if (V2 > V1) {
540             return 0;
541         } else {
542             return V1 - V2;
543         }
544     }
545 }
546 
547 // File: contracts/lib/PMMPricing.sol
548 
549 
550 /**
551  * @title Pricing
552  * @author DODO Breeder
553  *
554  * @notice DODO Pricing model
555  */
556 
557 library PMMPricing {
558     using SafeMath for uint256;
559 
560     enum RState {ONE, ABOVE_ONE, BELOW_ONE}
561 
562     struct PMMState {
563         uint256 i;
564         uint256 K;
565         uint256 B;
566         uint256 Q;
567         uint256 B0;
568         uint256 Q0;
569         RState R;
570     }
571 
572     // ============ buy & sell ============
573 
574     function sellBaseToken(PMMState memory state, uint256 payBaseAmount)
575         internal
576         pure
577         returns (uint256 receiveQuoteAmount, RState newR)
578     {
579         if (state.R == RState.ONE) {
580             // case 1: R=1
581             // R falls below one
582             receiveQuoteAmount = _ROneSellBaseToken(state, payBaseAmount);
583             newR = RState.BELOW_ONE;
584         } else if (state.R == RState.ABOVE_ONE) {
585             uint256 backToOnePayBase = state.B0.sub(state.B);
586             uint256 backToOneReceiveQuote = state.Q.sub(state.Q0);
587             // case 2: R>1
588             // complex case, R status depends on trading amount
589             if (payBaseAmount < backToOnePayBase) {
590                 // case 2.1: R status do not change
591                 receiveQuoteAmount = _RAboveSellBaseToken(state, payBaseAmount);
592                 newR = RState.ABOVE_ONE;
593                 if (receiveQuoteAmount > backToOneReceiveQuote) {
594                     // [Important corner case!] may enter this branch when some precision problem happens. And consequently contribute to negative spare quote amount
595                     // to make sure spare quote>=0, mannually set receiveQuote=backToOneReceiveQuote
596                     receiveQuoteAmount = backToOneReceiveQuote;
597                 }
598             } else if (payBaseAmount == backToOnePayBase) {
599                 // case 2.2: R status changes to ONE
600                 receiveQuoteAmount = backToOneReceiveQuote;
601                 newR = RState.ONE;
602             } else {
603                 // case 2.3: R status changes to BELOW_ONE
604                 receiveQuoteAmount = backToOneReceiveQuote.add(
605                     _ROneSellBaseToken(state, payBaseAmount.sub(backToOnePayBase))
606                 );
607                 newR = RState.BELOW_ONE;
608             }
609         } else {
610             // state.R == RState.BELOW_ONE
611             // case 3: R<1
612             receiveQuoteAmount = _RBelowSellBaseToken(state, payBaseAmount);
613             newR = RState.BELOW_ONE;
614         }
615     }
616 
617     function sellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
618         internal
619         pure
620         returns (uint256 receiveBaseAmount, RState newR)
621     {
622         if (state.R == RState.ONE) {
623             receiveBaseAmount = _ROneSellQuoteToken(state, payQuoteAmount);
624             newR = RState.ABOVE_ONE;
625         } else if (state.R == RState.ABOVE_ONE) {
626             receiveBaseAmount = _RAboveSellQuoteToken(state, payQuoteAmount);
627             newR = RState.ABOVE_ONE;
628         } else {
629             uint256 backToOnePayQuote = state.Q0.sub(state.Q);
630             uint256 backToOneReceiveBase = state.B.sub(state.B0);
631             if (payQuoteAmount < backToOnePayQuote) {
632                 receiveBaseAmount = _RBelowSellQuoteToken(state, payQuoteAmount);
633                 newR = RState.BELOW_ONE;
634                 if (receiveBaseAmount > backToOneReceiveBase) {
635                     receiveBaseAmount = backToOneReceiveBase;
636                 }
637             } else if (payQuoteAmount == backToOnePayQuote) {
638                 receiveBaseAmount = backToOneReceiveBase;
639                 newR = RState.ONE;
640             } else {
641                 receiveBaseAmount = backToOneReceiveBase.add(
642                     _ROneSellQuoteToken(state, payQuoteAmount.sub(backToOnePayQuote))
643                 );
644                 newR = RState.ABOVE_ONE;
645             }
646         }
647     }
648 
649     // ============ R = 1 cases ============
650 
651     function _ROneSellBaseToken(PMMState memory state, uint256 payBaseAmount)
652         internal
653         pure
654         returns (
655             uint256 // receiveQuoteToken
656         )
657     {
658         // in theory Q2 <= targetQuoteTokenAmount
659         // however when amount is close to 0, precision problems may cause Q2 > targetQuoteTokenAmount
660         return
661             DODOMath._SolveQuadraticFunctionForTrade(
662                 state.Q0,
663                 state.Q0,
664                 payBaseAmount,
665                 state.i,
666                 state.K
667             );
668     }
669 
670     function _ROneSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
671         internal
672         pure
673         returns (
674             uint256 // receiveBaseToken
675         )
676     {
677         return
678             DODOMath._SolveQuadraticFunctionForTrade(
679                 state.B0,
680                 state.B0,
681                 payQuoteAmount,
682                 DecimalMath.reciprocalFloor(state.i),
683                 state.K
684             );
685     }
686 
687     // ============ R < 1 cases ============
688 
689     function _RBelowSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
690         internal
691         pure
692         returns (
693             uint256 // receiveBaseToken
694         )
695     {
696         return
697             DODOMath._GeneralIntegrate(
698                 state.Q0,
699                 state.Q.add(payQuoteAmount),
700                 state.Q,
701                 DecimalMath.reciprocalFloor(state.i),
702                 state.K
703             );
704     }
705 
706     function _RBelowSellBaseToken(PMMState memory state, uint256 payBaseAmount)
707         internal
708         pure
709         returns (
710             uint256 // receiveQuoteToken
711         )
712     {
713         return
714             DODOMath._SolveQuadraticFunctionForTrade(
715                 state.Q0,
716                 state.Q,
717                 payBaseAmount,
718                 state.i,
719                 state.K
720             );
721     }
722 
723     // ============ R > 1 cases ============
724 
725     function _RAboveSellBaseToken(PMMState memory state, uint256 payBaseAmount)
726         internal
727         pure
728         returns (
729             uint256 // receiveQuoteToken
730         )
731     {
732         return
733             DODOMath._GeneralIntegrate(
734                 state.B0,
735                 state.B.add(payBaseAmount),
736                 state.B,
737                 state.i,
738                 state.K
739             );
740     }
741 
742     function _RAboveSellQuoteToken(PMMState memory state, uint256 payQuoteAmount)
743         internal
744         pure
745         returns (
746             uint256 // receiveBaseToken
747         )
748     {
749         return
750             DODOMath._SolveQuadraticFunctionForTrade(
751                 state.B0,
752                 state.B,
753                 payQuoteAmount,
754                 DecimalMath.reciprocalFloor(state.i),
755                 state.K
756             );
757     }
758 
759     // ============ Helper functions ============
760 
761     function adjustedTarget(PMMState memory state) internal pure {
762         if (state.R == RState.BELOW_ONE) {
763             state.Q0 = DODOMath._SolveQuadraticFunctionForTarget(
764                 state.Q,
765                 state.B.sub(state.B0),
766                 state.i,
767                 state.K
768             );
769         } else if (state.R == RState.ABOVE_ONE) {
770             state.B0 = DODOMath._SolveQuadraticFunctionForTarget(
771                 state.B,
772                 state.Q.sub(state.Q0),
773                 DecimalMath.reciprocalFloor(state.i),
774                 state.K
775             );
776         }
777     }
778 
779     function getMidPrice(PMMState memory state) internal pure returns (uint256) {
780         if (state.R == RState.BELOW_ONE) {
781             uint256 R = DecimalMath.divFloor(state.Q0.mul(state.Q0).div(state.Q), state.Q);
782             R = DecimalMath.ONE.sub(state.K).add(DecimalMath.mulFloor(state.K, R));
783             return DecimalMath.divFloor(state.i, R);
784         } else {
785             uint256 R = DecimalMath.divFloor(state.B0.mul(state.B0).div(state.B), state.B);
786             R = DecimalMath.ONE.sub(state.K).add(DecimalMath.mulFloor(state.K, R));
787             return DecimalMath.mulFloor(state.i, R);
788         }
789     }
790 }
791 
792 // File: contracts/DODOVendingMachine/impl/DVMStorage.sol
793 
794 
795 contract DVMStorage is ReentrancyGuard {
796     using SafeMath for uint256;
797 
798     bool public _IS_OPEN_TWAP_ = false;
799 
800     bool internal _DVM_INITIALIZED_;
801 
802     // ============ Core Address ============
803 
804     address public _MAINTAINER_;
805 
806     IERC20 public _BASE_TOKEN_;
807     IERC20 public _QUOTE_TOKEN_;
808 
809     uint112 public _BASE_RESERVE_;
810     uint112 public _QUOTE_RESERVE_;
811     uint32 public _BLOCK_TIMESTAMP_LAST_;
812 
813     uint256 public _BASE_PRICE_CUMULATIVE_LAST_;
814 
815     // ============ Shares (ERC20) ============
816 
817     string public symbol;
818     uint8 public decimals;
819     string public name;
820 
821     uint256 public totalSupply;
822     mapping(address => uint256) internal _SHARES_;
823     mapping(address => mapping(address => uint256)) internal _ALLOWED_;
824 
825     // ================= Permit ======================
826 
827     bytes32 public DOMAIN_SEPARATOR;
828     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
829     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
830     mapping(address => uint256) public nonces;
831 
832     // ============ Variables for Pricing ============
833 
834     uint256 public _LP_FEE_RATE_;
835     IFeeRateModel public _MT_FEE_RATE_MODEL_;
836     uint256 public _K_;
837     uint256 public _I_;
838 
839 
840     // ============ Helper Functions ============
841 
842     function getPMMState() public view returns (PMMPricing.PMMState memory state) {
843         state.i = _I_;
844         state.K = _K_;
845         state.B = _BASE_RESERVE_;
846         state.Q = _QUOTE_RESERVE_;
847         state.B0 = 0; // will be calculated in adjustedTarget
848         state.Q0 = 0;
849         state.R = PMMPricing.RState.ABOVE_ONE;
850         PMMPricing.adjustedTarget(state);
851     }
852 
853     function getPMMStateForCall() 
854         external 
855         view 
856         returns (
857             uint256 i,
858             uint256 K,
859             uint256 B,
860             uint256 Q,
861             uint256 B0,
862             uint256 Q0,
863             uint256 R
864         )
865     {
866         PMMPricing.PMMState memory state = getPMMState();
867         i = state.i;
868         K = state.K;
869         B = state.B;
870         Q = state.Q;
871         B0 = state.B0;
872         Q0 = state.Q0;
873         R = uint256(state.R);
874     }
875 
876     function getMidPrice() public view returns (uint256 midPrice) {
877         return PMMPricing.getMidPrice(getPMMState());
878     }
879 }
880 
881 // File: contracts/DODOVendingMachine/impl/DVMVault.sol
882 
883 
884 contract DVMVault is DVMStorage {
885     using SafeMath for uint256;
886     using SafeERC20 for IERC20;
887 
888     // ============ Events ============
889 
890     event Transfer(address indexed from, address indexed to, uint256 amount);
891 
892     event Approval(address indexed owner, address indexed spender, uint256 amount);
893 
894     event Mint(address indexed user, uint256 value);
895 
896     event Burn(address indexed user, uint256 value);
897 
898     // ============ View Functions ============
899 
900     function getVaultReserve() external view returns (uint256 baseReserve, uint256 quoteReserve) {
901         baseReserve = _BASE_RESERVE_;
902         quoteReserve = _QUOTE_RESERVE_;
903     }
904 
905     function getUserFeeRate(address user) external view returns (uint256 lpFeeRate, uint256 mtFeeRate) {
906         lpFeeRate = _LP_FEE_RATE_;
907         mtFeeRate = _MT_FEE_RATE_MODEL_.getFeeRate(user);
908     }
909 
910     // ============ Asset In ============
911 
912     function getBaseInput() public view returns (uint256 input) {
913         return _BASE_TOKEN_.balanceOf(address(this)).sub(uint256(_BASE_RESERVE_));
914     }
915 
916     function getQuoteInput() public view returns (uint256 input) {
917         return _QUOTE_TOKEN_.balanceOf(address(this)).sub(uint256(_QUOTE_RESERVE_));
918     }
919 
920     // ============ TWAP UPDATE ===========
921     
922     function _twapUpdate() internal {
923         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
924         uint32 timeElapsed = blockTimestamp - _BLOCK_TIMESTAMP_LAST_;
925         if (timeElapsed > 0 && _BASE_RESERVE_ != 0 && _QUOTE_RESERVE_ != 0) {
926             _BASE_PRICE_CUMULATIVE_LAST_ += getMidPrice() * timeElapsed;
927         }
928         _BLOCK_TIMESTAMP_LAST_ = blockTimestamp;
929     }
930 
931     // ============ Set States ============
932 
933     function _setReserve(uint256 baseReserve, uint256 quoteReserve) internal {
934         require(baseReserve <= uint112(-1) && quoteReserve <= uint112(-1), "OVERFLOW");
935         _BASE_RESERVE_ = uint112(baseReserve);
936         _QUOTE_RESERVE_ = uint112(quoteReserve);
937 
938         if(_IS_OPEN_TWAP_) _twapUpdate();
939     }
940 
941     function _sync() internal {
942         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));
943         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
944         require(baseBalance <= uint112(-1) && quoteBalance <= uint112(-1), "OVERFLOW");
945         if (baseBalance != _BASE_RESERVE_) {
946             _BASE_RESERVE_ = uint112(baseBalance);
947         }
948         if (quoteBalance != _QUOTE_RESERVE_) {
949             _QUOTE_RESERVE_ = uint112(quoteBalance);
950         }
951 
952         if(_IS_OPEN_TWAP_) _twapUpdate();
953     }
954 
955 
956     function sync() external preventReentrant {
957         _sync();
958     }
959 
960     // ============ Asset Out ============
961 
962     function _transferBaseOut(address to, uint256 amount) internal {
963         if (amount > 0) {
964             _BASE_TOKEN_.safeTransfer(to, amount);
965         }
966     }
967 
968     function _transferQuoteOut(address to, uint256 amount) internal {
969         if (amount > 0) {
970             _QUOTE_TOKEN_.safeTransfer(to, amount);
971         }
972     }
973 
974     // ============ Shares (ERC20) ============
975 
976     /**
977      * @dev transfer token for a specified address
978      * @param to The address to transfer to.
979      * @param amount The amount to be transferred.
980      */
981     function transfer(address to, uint256 amount) public returns (bool) {
982         require(amount <= _SHARES_[msg.sender], "BALANCE_NOT_ENOUGH");
983 
984         _SHARES_[msg.sender] = _SHARES_[msg.sender].sub(amount);
985         _SHARES_[to] = _SHARES_[to].add(amount);
986         emit Transfer(msg.sender, to, amount);
987         return true;
988     }
989 
990     /**
991      * @dev Gets the balance of the specified address.
992      * @param owner The address to query the the balance of.
993      * @return balance An uint256 representing the amount owned by the passed address.
994      */
995     function balanceOf(address owner) external view returns (uint256 balance) {
996         return _SHARES_[owner];
997     }
998 
999     /**
1000      * @dev Transfer tokens from one address to another
1001      * @param from address The address which you want to send tokens from
1002      * @param to address The address which you want to transfer to
1003      * @param amount uint256 the amount of tokens to be transferred
1004      */
1005     function transferFrom(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) public returns (bool) {
1010         require(amount <= _SHARES_[from], "BALANCE_NOT_ENOUGH");
1011         require(amount <= _ALLOWED_[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
1012 
1013         _SHARES_[from] = _SHARES_[from].sub(amount);
1014         _SHARES_[to] = _SHARES_[to].add(amount);
1015         _ALLOWED_[from][msg.sender] = _ALLOWED_[from][msg.sender].sub(amount);
1016         emit Transfer(from, to, amount);
1017         return true;
1018     }
1019 
1020     /**
1021      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1022      * @param spender The address which will spend the funds.
1023      * @param amount The amount of tokens to be spent.
1024      */
1025     function approve(address spender, uint256 amount) public returns (bool) {
1026         _approve(msg.sender, spender, amount);
1027         return true;
1028     }
1029 
1030     function _approve(
1031         address owner,
1032         address spender,
1033         uint256 amount
1034     ) private {
1035         _ALLOWED_[owner][spender] = amount;
1036         emit Approval(owner, spender, amount);
1037     }
1038 
1039     /**
1040      * @dev Function to check the amount of tokens that an owner _ALLOWED_ to a spender.
1041      * @param owner address The address which owns the funds.
1042      * @param spender address The address which will spend the funds.
1043      * @return A uint256 specifying the amount of tokens still available for the spender.
1044      */
1045     function allowance(address owner, address spender) public view returns (uint256) {
1046         return _ALLOWED_[owner][spender];
1047     }
1048 
1049     function _mint(address user, uint256 value) internal {
1050         require(value > 1000, "MINT_INVALID");
1051         _SHARES_[user] = _SHARES_[user].add(value);
1052         totalSupply = totalSupply.add(value);
1053         emit Mint(user, value);
1054         emit Transfer(address(0), user, value);
1055     }
1056 
1057     function _burn(address user, uint256 value) internal {
1058         _SHARES_[user] = _SHARES_[user].sub(value);
1059         totalSupply = totalSupply.sub(value);
1060         emit Burn(user, value);
1061         emit Transfer(user, address(0), value);
1062     }
1063 
1064     // ============================ Permit ======================================
1065     
1066     function permit(
1067         address owner,
1068         address spender,
1069         uint256 value,
1070         uint256 deadline,
1071         uint8 v,
1072         bytes32 r,
1073         bytes32 s
1074     ) external {
1075         require(deadline >= block.timestamp, "DODO_DVM_LP: EXPIRED");
1076         bytes32 digest = keccak256(
1077             abi.encodePacked(
1078                 "\x19\x01",
1079                 DOMAIN_SEPARATOR,
1080                 keccak256(
1081                     abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)
1082                 )
1083             )
1084         );
1085         address recoveredAddress = ecrecover(digest, v, r, s);
1086         require(
1087             recoveredAddress != address(0) && recoveredAddress == owner,
1088             "DODO_DVM_LP: INVALID_SIGNATURE"
1089         );
1090         _approve(owner, spender, value);
1091     }
1092 }
1093 
1094 // File: contracts/intf/IDODOCallee.sol
1095 
1096 
1097 interface IDODOCallee {
1098     function DVMSellShareCall(
1099         address sender,
1100         uint256 burnShareAmount,
1101         uint256 baseAmount,
1102         uint256 quoteAmount,
1103         bytes calldata data
1104     ) external;
1105 
1106     function DVMFlashLoanCall(
1107         address sender,
1108         uint256 baseAmount,
1109         uint256 quoteAmount,
1110         bytes calldata data
1111     ) external;
1112 
1113     function DPPFlashLoanCall(
1114         address sender,
1115         uint256 baseAmount,
1116         uint256 quoteAmount,
1117         bytes calldata data
1118     ) external;
1119 
1120     function CPCancelCall(
1121         address sender,
1122         uint256 amount,
1123         bytes calldata data
1124     ) external;
1125 
1126 	function CPClaimBidCall(
1127         address sender,
1128         uint256 baseAmount,
1129         uint256 quoteAmount,
1130         bytes calldata data
1131     ) external;
1132 }
1133 
1134 // File: contracts/DODOVendingMachine/impl/DVMTrader.sol
1135 
1136 
1137 
1138 contract DVMTrader is DVMVault {
1139     using SafeMath for uint256;
1140 
1141     // ============ Events ============
1142 
1143     event DODOSwap(
1144         address fromToken,
1145         address toToken,
1146         uint256 fromAmount,
1147         uint256 toAmount,
1148         address trader,
1149         address receiver
1150     );
1151 
1152     event DODOFlashLoan(
1153         address borrower,
1154         address assetTo,
1155         uint256 baseAmount,
1156         uint256 quoteAmount
1157     );
1158 
1159     // ============ Trade Functions ============
1160 
1161     function sellBase(address to)
1162         external
1163         preventReentrant
1164         returns (uint256 receiveQuoteAmount)
1165     {
1166         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));
1167         uint256 baseInput = baseBalance.sub(uint256(_BASE_RESERVE_));
1168         uint256 mtFee;
1169         (receiveQuoteAmount, mtFee) = querySellBase(tx.origin, baseInput);
1170 
1171         _transferQuoteOut(to, receiveQuoteAmount);
1172         _transferQuoteOut(_MAINTAINER_, mtFee);
1173         _setReserve(baseBalance, _QUOTE_TOKEN_.balanceOf(address(this)));
1174 
1175         emit DODOSwap(
1176             address(_BASE_TOKEN_),
1177             address(_QUOTE_TOKEN_),
1178             baseInput,
1179             receiveQuoteAmount,
1180             msg.sender,
1181             to
1182         );
1183     }
1184 
1185     function sellQuote(address to)
1186         external
1187         preventReentrant
1188         returns (uint256 receiveBaseAmount)
1189     {
1190         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
1191         uint256 quoteInput = quoteBalance.sub(uint256(_QUOTE_RESERVE_));
1192         uint256 mtFee;
1193         (receiveBaseAmount, mtFee) = querySellQuote(tx.origin, quoteInput);
1194 
1195         _transferBaseOut(to, receiveBaseAmount);
1196         _transferBaseOut(_MAINTAINER_, mtFee);
1197         _setReserve(_BASE_TOKEN_.balanceOf(address(this)), quoteBalance);
1198 
1199         emit DODOSwap(
1200             address(_QUOTE_TOKEN_),
1201             address(_BASE_TOKEN_),
1202             quoteInput,
1203             receiveBaseAmount,
1204             msg.sender,
1205             to
1206         );
1207     }
1208 
1209     function flashLoan(
1210         uint256 baseAmount,
1211         uint256 quoteAmount,
1212         address assetTo,
1213         bytes calldata data
1214     ) external preventReentrant {
1215         _transferBaseOut(assetTo, baseAmount);
1216         _transferQuoteOut(assetTo, quoteAmount);
1217 
1218         if (data.length > 0)
1219             IDODOCallee(assetTo).DVMFlashLoanCall(msg.sender, baseAmount, quoteAmount, data);
1220 
1221         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));
1222         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
1223         
1224         // no input -> pure loss
1225         require(
1226             baseBalance >= _BASE_RESERVE_ || quoteBalance >= _QUOTE_RESERVE_,
1227             "FLASH_LOAN_FAILED"
1228         );
1229 
1230         // sell quote
1231         if (baseBalance < _BASE_RESERVE_) {
1232             uint256 quoteInput = quoteBalance.sub(uint256(_QUOTE_RESERVE_));
1233             (uint256 receiveBaseAmount, uint256 mtFee) = querySellQuote(tx.origin, quoteInput);
1234             require(uint256(_BASE_RESERVE_).sub(baseBalance) <= receiveBaseAmount, "FLASH_LOAN_FAILED");
1235 
1236             _transferBaseOut(_MAINTAINER_, mtFee);
1237             emit DODOSwap(
1238                 address(_QUOTE_TOKEN_),
1239                 address(_BASE_TOKEN_),
1240                 quoteInput,
1241                 receiveBaseAmount,
1242                 msg.sender,
1243                 assetTo
1244             );
1245         }
1246 
1247         // sell base
1248         if (quoteBalance < _QUOTE_RESERVE_) {
1249             uint256 baseInput = baseBalance.sub(uint256(_BASE_RESERVE_));
1250             (uint256 receiveQuoteAmount, uint256 mtFee) = querySellBase(tx.origin, baseInput);
1251             require(uint256(_QUOTE_RESERVE_).sub(quoteBalance) <= receiveQuoteAmount, "FLASH_LOAN_FAILED");
1252 
1253             _transferQuoteOut(_MAINTAINER_, mtFee);
1254             emit DODOSwap(
1255                 address(_BASE_TOKEN_),
1256                 address(_QUOTE_TOKEN_),
1257                 baseInput,
1258                 receiveQuoteAmount,
1259                 msg.sender,
1260                 assetTo
1261             );
1262         }
1263 
1264         _sync();
1265         
1266         emit DODOFlashLoan(msg.sender, assetTo, baseAmount, quoteAmount);
1267     }
1268 
1269     // ============ Query Functions ============
1270 
1271     function querySellBase(address trader, uint256 payBaseAmount)
1272         public
1273         view
1274         returns (uint256 receiveQuoteAmount, uint256 mtFee)
1275     {
1276         (receiveQuoteAmount, ) = PMMPricing.sellBaseToken(getPMMState(), payBaseAmount);
1277 
1278         uint256 lpFeeRate = _LP_FEE_RATE_;
1279         uint256 mtFeeRate = _MT_FEE_RATE_MODEL_.getFeeRate(trader);
1280         mtFee = DecimalMath.mulFloor(receiveQuoteAmount, mtFeeRate);
1281         receiveQuoteAmount = receiveQuoteAmount
1282             .sub(DecimalMath.mulFloor(receiveQuoteAmount, lpFeeRate))
1283             .sub(mtFee);
1284     }
1285 
1286     function querySellQuote(address trader, uint256 payQuoteAmount)
1287         public
1288         view
1289         returns (uint256 receiveBaseAmount, uint256 mtFee)
1290     {
1291         (receiveBaseAmount, ) = PMMPricing.sellQuoteToken(getPMMState(), payQuoteAmount);
1292 
1293         uint256 lpFeeRate = _LP_FEE_RATE_;
1294         uint256 mtFeeRate = _MT_FEE_RATE_MODEL_.getFeeRate(trader);
1295         mtFee = DecimalMath.mulFloor(receiveBaseAmount, mtFeeRate);
1296         receiveBaseAmount = receiveBaseAmount
1297             .sub(DecimalMath.mulFloor(receiveBaseAmount, lpFeeRate))
1298             .sub(mtFee);
1299     }
1300 }
1301 
1302 // File: contracts/DODOVendingMachine/impl/DVMFunding.sol
1303 
1304 
1305 contract DVMFunding is DVMVault {
1306     // ============ Events ============
1307 
1308     event BuyShares(address to, uint256 increaseShares, uint256 totalShares);
1309 
1310     event SellShares(address payer, address to, uint256 decreaseShares, uint256 totalShares);
1311 
1312     // ============ Buy & Sell Shares ============
1313 
1314     // buy shares [round down]
1315     function buyShares(address to)
1316         external
1317         preventReentrant
1318         returns (
1319             uint256 shares,
1320             uint256 baseInput,
1321             uint256 quoteInput
1322         )
1323     {
1324         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));
1325         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
1326         uint256 baseReserve = _BASE_RESERVE_;
1327         uint256 quoteReserve = _QUOTE_RESERVE_;
1328 
1329         baseInput = baseBalance.sub(baseReserve);
1330         quoteInput = quoteBalance.sub(quoteReserve);
1331         require(baseInput > 0, "NO_BASE_INPUT");
1332 
1333         // Round down when withdrawing. Therefore, never be a situation occuring balance is 0 but totalsupply is not 0
1334         // But May Happen，reserve >0 But totalSupply = 0
1335         if (totalSupply == 0) {
1336             // case 1. initial supply
1337             require(baseBalance >= 10**3, "INSUFFICIENT_LIQUIDITY_MINED");
1338             shares = baseBalance; // 以免出现balance很大但shares很小的情况
1339         } else if (baseReserve > 0 && quoteReserve == 0) {
1340             // case 2. supply when quote reserve is 0
1341             shares = baseInput.mul(totalSupply).div(baseReserve);
1342         } else if (baseReserve > 0 && quoteReserve > 0) {
1343             // case 3. normal case
1344             uint256 baseInputRatio = DecimalMath.divFloor(baseInput, baseReserve);
1345             uint256 quoteInputRatio = DecimalMath.divFloor(quoteInput, quoteReserve);
1346             uint256 mintRatio = quoteInputRatio < baseInputRatio ? quoteInputRatio : baseInputRatio;
1347             shares = DecimalMath.mulFloor(totalSupply, mintRatio);
1348         }
1349         _mint(to, shares);
1350         _setReserve(baseBalance, quoteBalance);
1351         emit BuyShares(to, shares, _SHARES_[to]);
1352     }
1353 
1354     // sell shares [round down]
1355     function sellShares(
1356         uint256 shareAmount,
1357         address to,
1358         uint256 baseMinAmount,
1359         uint256 quoteMinAmount,
1360         bytes calldata data,
1361         uint256 deadline
1362     ) external preventReentrant returns (uint256 baseAmount, uint256 quoteAmount) {
1363         require(deadline >= block.timestamp, "TIME_EXPIRED");
1364         require(shareAmount <= _SHARES_[msg.sender], "DLP_NOT_ENOUGH");
1365         uint256 baseBalance = _BASE_TOKEN_.balanceOf(address(this));
1366         uint256 quoteBalance = _QUOTE_TOKEN_.balanceOf(address(this));
1367         uint256 totalShares = totalSupply;
1368 
1369         baseAmount = baseBalance.mul(shareAmount).div(totalShares);
1370         quoteAmount = quoteBalance.mul(shareAmount).div(totalShares);
1371 
1372         require(
1373             baseAmount >= baseMinAmount && quoteAmount >= quoteMinAmount,
1374             "WITHDRAW_NOT_ENOUGH"
1375         );
1376 
1377         _burn(msg.sender, shareAmount);
1378         _transferBaseOut(to, baseAmount);
1379         _transferQuoteOut(to, quoteAmount);
1380         _sync();
1381 
1382         if (data.length > 0) {
1383             IDODOCallee(to).DVMSellShareCall(
1384                 msg.sender,
1385                 shareAmount,
1386                 baseAmount,
1387                 quoteAmount,
1388                 data
1389             );
1390         }
1391 
1392         emit SellShares(msg.sender, to, shareAmount, _SHARES_[msg.sender]);
1393     }
1394 }
1395 
1396 // File: contracts/DODOVendingMachine/impl/DVM.sol
1397 
1398 
1399 
1400 /**
1401  * @title DODO VendingMachine
1402  * @author DODO Breeder
1403  *
1404  * @notice DODOVendingMachine initialization
1405  */
1406 contract DVM is DVMTrader, DVMFunding {
1407     function init(
1408         address maintainer,
1409         address baseTokenAddress,
1410         address quoteTokenAddress,
1411         uint256 lpFeeRate,
1412         address mtFeeRateModel,
1413         uint256 i,
1414         uint256 k,
1415         bool isOpenTWAP
1416     ) external {
1417         require(!_DVM_INITIALIZED_, "DVM_INITIALIZED");
1418         _DVM_INITIALIZED_ = true;
1419         
1420         require(baseTokenAddress != quoteTokenAddress, "BASE_QUOTE_CAN_NOT_BE_SAME");
1421         _BASE_TOKEN_ = IERC20(baseTokenAddress);
1422         _QUOTE_TOKEN_ = IERC20(quoteTokenAddress);
1423 
1424         require(i > 0 && i <= 10**36);
1425         _I_ = i;
1426 
1427         require(k <= 10**18);
1428         _K_ = k;
1429 
1430         _LP_FEE_RATE_ = lpFeeRate;
1431         _MT_FEE_RATE_MODEL_ = IFeeRateModel(mtFeeRateModel);
1432         _MAINTAINER_ = maintainer;
1433 
1434         _IS_OPEN_TWAP_ = isOpenTWAP;
1435         if(isOpenTWAP) _BLOCK_TIMESTAMP_LAST_ = uint32(block.timestamp % 2**32);
1436 
1437         string memory connect = "_";
1438         string memory suffix = "DLP";
1439 
1440         name = string(abi.encodePacked(suffix, connect, addressToShortString(address(this))));
1441         symbol = "DLP";
1442         decimals = _BASE_TOKEN_.decimals();
1443 
1444         // ============================== Permit ====================================
1445         uint256 chainId;
1446         assembly {
1447             chainId := chainid()
1448         }
1449         DOMAIN_SEPARATOR = keccak256(
1450             abi.encode(
1451                 // keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
1452                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
1453                 keccak256(bytes(name)),
1454                 keccak256(bytes("1")),
1455                 chainId,
1456                 address(this)
1457             )
1458         );
1459         // ==========================================================================
1460     }
1461 
1462     function addressToShortString(address _addr) public pure returns (string memory) {
1463         bytes32 value = bytes32(uint256(_addr));
1464         bytes memory alphabet = "0123456789abcdef";
1465 
1466         bytes memory str = new bytes(8);
1467         for (uint256 i = 0; i < 4; i++) {
1468             str[i * 2] = alphabet[uint8(value[i + 12] >> 4)];
1469             str[1 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
1470         }
1471         return string(str);
1472     }
1473 
1474     // ============ Version Control ============
1475     
1476     function version() external pure returns (string memory) {
1477         return "DVM 1.0.2";
1478     }
1479 }