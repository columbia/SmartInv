1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "./AmplificationUtils.sol";
8 import "./LPToken.sol";
9 import "./MathUtils.sol";
10 
11 /**
12  * @title SwapUtils library
13  * @notice A library to be used within Swap.sol. Contains functions responsible for custody and AMM functionalities.
14  * @dev Contracts relying on this library must initialize SwapUtils.Swap struct then use this library
15  * for SwapUtils.Swap struct. Note that this library contains both functions called by users and admins.
16  * Admin functions should be protected within contracts using this library.
17  */
18 library SwapUtils {
19     using SafeERC20 for IERC20;
20     using SafeMath for uint256;
21     using MathUtils for uint256;
22 
23     /*** EVENTS ***/
24 
25     event TokenSwap(
26         address indexed buyer,
27         uint256 tokensSold,
28         uint256 tokensBought,
29         uint128 soldId,
30         uint128 boughtId
31     );
32     event AddLiquidity(
33         address indexed provider,
34         uint256[] tokenAmounts,
35         uint256[] fees,
36         uint256 invariant,
37         uint256 lpTokenSupply
38     );
39     event RemoveLiquidity(
40         address indexed provider,
41         uint256[] tokenAmounts,
42         uint256 lpTokenSupply
43     );
44     event RemoveLiquidityOne(
45         address indexed provider,
46         uint256 lpTokenAmount,
47         uint256 lpTokenSupply,
48         uint256 boughtId,
49         uint256 tokensBought
50     );
51     event RemoveLiquidityImbalance(
52         address indexed provider,
53         uint256[] tokenAmounts,
54         uint256[] fees,
55         uint256 invariant,
56         uint256 lpTokenSupply
57     );
58     event NewAdminFee(uint256 newAdminFee);
59     event NewSwapFee(uint256 newSwapFee);
60 
61     struct Swap {
62         // variables around the ramp management of A,
63         // the amplification coefficient * n * (n - 1)
64         // see https://www.curve.fi/stableswap-paper.pdf for details
65         uint256 initialA;
66         uint256 futureA;
67         uint256 initialATime;
68         uint256 futureATime;
69         // fee calculation
70         uint256 swapFee;
71         uint256 adminFee;
72         LPToken lpToken;
73         // contract references for all tokens being pooled
74         IERC20[] pooledTokens;
75         // multipliers for each pooled token's precision to get to POOL_PRECISION_DECIMALS
76         // for example, TBTC has 18 decimals, so the multiplier should be 1. WBTC
77         // has 8, so the multiplier should be 10 ** 18 / 10 ** 8 => 10 ** 10
78         uint256[] tokenPrecisionMultipliers;
79         // the pool balance of each token, in the token's precision
80         // the contract's actual token balance might differ
81         uint256[] balances;
82     }
83 
84     // Struct storing variables used in calculations in the
85     // calculateWithdrawOneTokenDY function to avoid stack too deep errors
86     struct CalculateWithdrawOneTokenDYInfo {
87         uint256 d0;
88         uint256 d1;
89         uint256 newY;
90         uint256 feePerToken;
91         uint256 preciseA;
92     }
93 
94     // Struct storing variables used in calculations in the
95     // {add,remove}Liquidity functions to avoid stack too deep errors
96     struct ManageLiquidityInfo {
97         uint256 d0;
98         uint256 d1;
99         uint256 d2;
100         uint256 preciseA;
101         LPToken lpToken;
102         uint256 totalSupply;
103         uint256[] balances;
104         uint256[] multipliers;
105     }
106 
107     // the precision all pools tokens will be converted to
108     uint8 public constant POOL_PRECISION_DECIMALS = 18;
109 
110     // the denominator used to calculate admin and LP fees. For example, an
111     // LP fee might be something like tradeAmount.mul(fee).div(FEE_DENOMINATOR)
112     uint256 private constant FEE_DENOMINATOR = 10**10;
113 
114     // Max swap fee is 1% or 100bps of each swap
115     uint256 public constant MAX_SWAP_FEE = 10**8;
116 
117     // Max adminFee is 100% of the swapFee
118     // adminFee does not add additional fee on top of swapFee
119     // Instead it takes a certain % of the swapFee. Therefore it has no impact on the
120     // users but only on the earnings of LPs
121     uint256 public constant MAX_ADMIN_FEE = 10**10;
122 
123     // Constant value used as max loop limit
124     uint256 private constant MAX_LOOP_LIMIT = 256;
125 
126     /*** VIEW & PURE FUNCTIONS ***/
127 
128     function _getAPrecise(Swap storage self) internal view returns (uint256) {
129         return AmplificationUtils._getAPrecise(self);
130     }
131 
132     /**
133      * @notice Calculate the dy, the amount of selected token that user receives and
134      * the fee of withdrawing in one token
135      * @param tokenAmount the amount to withdraw in the pool's precision
136      * @param tokenIndex which token will be withdrawn
137      * @param self Swap struct to read from
138      * @return the amount of token user will receive
139      */
140     function calculateWithdrawOneToken(
141         Swap storage self,
142         uint256 tokenAmount,
143         uint8 tokenIndex
144     ) external view returns (uint256) {
145         (uint256 availableTokenAmount, ) = _calculateWithdrawOneToken(
146             self,
147             tokenAmount,
148             tokenIndex,
149             self.lpToken.totalSupply()
150         );
151         return availableTokenAmount;
152     }
153 
154     function _calculateWithdrawOneToken(
155         Swap storage self,
156         uint256 tokenAmount,
157         uint8 tokenIndex,
158         uint256 totalSupply
159     ) internal view returns (uint256, uint256) {
160         uint256 dy;
161         uint256 newY;
162         uint256 currentY;
163 
164         (dy, newY, currentY) = calculateWithdrawOneTokenDY(
165             self,
166             tokenIndex,
167             tokenAmount,
168             totalSupply
169         );
170 
171         // dy_0 (without fees)
172         // dy, dy_0 - dy
173 
174         uint256 dySwapFee = currentY
175             .sub(newY)
176             .div(self.tokenPrecisionMultipliers[tokenIndex])
177             .sub(dy);
178 
179         return (dy, dySwapFee);
180     }
181 
182     /**
183      * @notice Calculate the dy of withdrawing in one token
184      * @param self Swap struct to read from
185      * @param tokenIndex which token will be withdrawn
186      * @param tokenAmount the amount to withdraw in the pools precision
187      * @return the d and the new y after withdrawing one token
188      */
189     function calculateWithdrawOneTokenDY(
190         Swap storage self,
191         uint8 tokenIndex,
192         uint256 tokenAmount,
193         uint256 totalSupply
194     )
195         internal
196         view
197         returns (
198             uint256,
199             uint256,
200             uint256
201         )
202     {
203         // Get the current D, then solve the stableswap invariant
204         // y_i for D - tokenAmount
205         uint256[] memory xp = _xp(self);
206 
207         require(tokenIndex < xp.length, "Token index out of range");
208 
209         CalculateWithdrawOneTokenDYInfo
210             memory v = CalculateWithdrawOneTokenDYInfo(0, 0, 0, 0, 0);
211         v.preciseA = _getAPrecise(self);
212         v.d0 = getD(xp, v.preciseA);
213         v.d1 = v.d0.sub(tokenAmount.mul(v.d0).div(totalSupply));
214 
215         require(tokenAmount <= xp[tokenIndex], "Withdraw exceeds available");
216 
217         v.newY = getYD(v.preciseA, tokenIndex, xp, v.d1);
218 
219         uint256[] memory xpReduced = new uint256[](xp.length);
220 
221         v.feePerToken = _feePerToken(self.swapFee, xp.length);
222         for (uint256 i = 0; i < xp.length; i++) {
223             uint256 xpi = xp[i];
224             // if i == tokenIndex, dxExpected = xp[i] * d1 / d0 - newY
225             // else dxExpected = xp[i] - (xp[i] * d1 / d0)
226             // xpReduced[i] -= dxExpected * fee / FEE_DENOMINATOR
227             xpReduced[i] = xpi.sub(
228                 (
229                     (i == tokenIndex)
230                         ? xpi.mul(v.d1).div(v.d0).sub(v.newY)
231                         : xpi.sub(xpi.mul(v.d1).div(v.d0))
232                 ).mul(v.feePerToken).div(FEE_DENOMINATOR)
233             );
234         }
235 
236         uint256 dy = xpReduced[tokenIndex].sub(
237             getYD(v.preciseA, tokenIndex, xpReduced, v.d1)
238         );
239         dy = dy.sub(1).div(self.tokenPrecisionMultipliers[tokenIndex]);
240 
241         return (dy, v.newY, xp[tokenIndex]);
242     }
243 
244     /**
245      * @notice Calculate the price of a token in the pool with given
246      * precision-adjusted balances and a particular D.
247      *
248      * @dev This is accomplished via solving the invariant iteratively.
249      * See the StableSwap paper and Curve.fi implementation for further details.
250      *
251      * x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
252      * x_1**2 + b*x_1 = c
253      * x_1 = (x_1**2 + c) / (2*x_1 + b)
254      *
255      * @param a the amplification coefficient * n * (n - 1). See the StableSwap paper for details.
256      * @param tokenIndex Index of token we are calculating for.
257      * @param xp a precision-adjusted set of pool balances. Array should be
258      * the same cardinality as the pool.
259      * @param d the stableswap invariant
260      * @return the price of the token, in the same precision as in xp
261      */
262     function getYD(
263         uint256 a,
264         uint8 tokenIndex,
265         uint256[] memory xp,
266         uint256 d
267     ) internal pure returns (uint256) {
268         uint256 numTokens = xp.length;
269         require(tokenIndex < numTokens, "Token not found");
270 
271         uint256 c = d;
272         uint256 s;
273         uint256 nA = a.mul(numTokens);
274 
275         for (uint256 i = 0; i < numTokens; i++) {
276             if (i != tokenIndex) {
277                 s = s.add(xp[i]);
278                 c = c.mul(d).div(xp[i].mul(numTokens));
279                 // If we were to protect the division loss we would have to keep the denominator separate
280                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
281                 // c = c * D * D * D * ... overflow!
282             }
283         }
284         c = c.mul(d).mul(AmplificationUtils.A_PRECISION).div(nA.mul(numTokens));
285 
286         uint256 b = s.add(d.mul(AmplificationUtils.A_PRECISION).div(nA));
287         uint256 yPrev;
288         uint256 y = d;
289         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
290             yPrev = y;
291             y = y.mul(y).add(c).div(y.mul(2).add(b).sub(d));
292             if (y.within1(yPrev)) {
293                 return y;
294             }
295         }
296         revert("Approximation did not converge");
297     }
298 
299     /**
300      * @notice Get D, the StableSwap invariant, based on a set of balances and a particular A.
301      * @param xp a precision-adjusted set of pool balances. Array should be the same cardinality
302      * as the pool.
303      * @param a the amplification coefficient * n * (n - 1) in A_PRECISION.
304      * See the StableSwap paper for details
305      * @return the invariant, at the precision of the pool
306      */
307     function getD(uint256[] memory xp, uint256 a)
308         internal
309         pure
310         returns (uint256)
311     {
312         uint256 numTokens = xp.length;
313         uint256 s;
314         for (uint256 i = 0; i < numTokens; i++) {
315             s = s.add(xp[i]);
316         }
317         if (s == 0) {
318             return 0;
319         }
320 
321         uint256 prevD;
322         uint256 d = s;
323         uint256 nA = a.mul(numTokens);
324 
325         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
326             uint256 dP = d;
327             for (uint256 j = 0; j < numTokens; j++) {
328                 dP = dP.mul(d).div(xp[j].mul(numTokens));
329                 // If we were to protect the division loss we would have to keep the denominator separate
330                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
331                 // dP = dP * D * D * D * ... overflow!
332             }
333             prevD = d;
334             d = nA
335                 .mul(s)
336                 .div(AmplificationUtils.A_PRECISION)
337                 .add(dP.mul(numTokens))
338                 .mul(d)
339                 .div(
340                     nA
341                         .sub(AmplificationUtils.A_PRECISION)
342                         .mul(d)
343                         .div(AmplificationUtils.A_PRECISION)
344                         .add(numTokens.add(1).mul(dP))
345                 );
346             if (d.within1(prevD)) {
347                 return d;
348             }
349         }
350 
351         // Convergence should occur in 4 loops or less. If this is reached, there may be something wrong
352         // with the pool. If this were to occur repeatedly, LPs should withdraw via `removeLiquidity()`
353         // function which does not rely on D.
354         revert("D does not converge");
355     }
356 
357     /**
358      * @notice Given a set of balances and precision multipliers, return the
359      * precision-adjusted balances.
360      *
361      * @param balances an array of token balances, in their native precisions.
362      * These should generally correspond with pooled tokens.
363      *
364      * @param precisionMultipliers an array of multipliers, corresponding to
365      * the amounts in the balances array. When multiplied together they
366      * should yield amounts at the pool's precision.
367      *
368      * @return an array of amounts "scaled" to the pool's precision
369      */
370     function _xp(
371         uint256[] memory balances,
372         uint256[] memory precisionMultipliers
373     ) internal pure returns (uint256[] memory) {
374         uint256 numTokens = balances.length;
375         require(
376             numTokens == precisionMultipliers.length,
377             "Balances must match multipliers"
378         );
379         uint256[] memory xp = new uint256[](numTokens);
380         for (uint256 i = 0; i < numTokens; i++) {
381             xp[i] = balances[i].mul(precisionMultipliers[i]);
382         }
383         return xp;
384     }
385 
386     /**
387      * @notice Return the precision-adjusted balances of all tokens in the pool
388      * @param self Swap struct to read from
389      * @return the pool balances "scaled" to the pool's precision, allowing
390      * them to be more easily compared.
391      */
392     function _xp(Swap storage self) internal view returns (uint256[] memory) {
393         return _xp(self.balances, self.tokenPrecisionMultipliers);
394     }
395 
396     /**
397      * @notice Get the virtual price, to help calculate profit
398      * @param self Swap struct to read from
399      * @return the virtual price, scaled to precision of POOL_PRECISION_DECIMALS
400      */
401     function getVirtualPrice(Swap storage self)
402         external
403         view
404         returns (uint256)
405     {
406         uint256 d = getD(_xp(self), _getAPrecise(self));
407         LPToken lpToken = self.lpToken;
408         uint256 supply = lpToken.totalSupply();
409         if (supply > 0) {
410             return d.mul(10**uint256(POOL_PRECISION_DECIMALS)).div(supply);
411         }
412         return 0;
413     }
414 
415     /**
416      * @notice Calculate the new balances of the tokens given the indexes of the token
417      * that is swapped from (FROM) and the token that is swapped to (TO).
418      * This function is used as a helper function to calculate how much TO token
419      * the user should receive on swap.
420      *
421      * @param preciseA precise form of amplification coefficient
422      * @param tokenIndexFrom index of FROM token
423      * @param tokenIndexTo index of TO token
424      * @param x the new total amount of FROM token
425      * @param xp balances of the tokens in the pool
426      * @return the amount of TO token that should remain in the pool
427      */
428     function getY(
429         uint256 preciseA,
430         uint8 tokenIndexFrom,
431         uint8 tokenIndexTo,
432         uint256 x,
433         uint256[] memory xp
434     ) internal pure returns (uint256) {
435         uint256 numTokens = xp.length;
436         require(
437             tokenIndexFrom != tokenIndexTo,
438             "Can't compare token to itself"
439         );
440         require(
441             tokenIndexFrom < numTokens && tokenIndexTo < numTokens,
442             "Tokens must be in pool"
443         );
444 
445         uint256 d = getD(xp, preciseA);
446         uint256 c = d;
447         uint256 s;
448         uint256 nA = numTokens.mul(preciseA);
449 
450         uint256 _x;
451         for (uint256 i = 0; i < numTokens; i++) {
452             if (i == tokenIndexFrom) {
453                 _x = x;
454             } else if (i != tokenIndexTo) {
455                 _x = xp[i];
456             } else {
457                 continue;
458             }
459             s = s.add(_x);
460             c = c.mul(d).div(_x.mul(numTokens));
461             // If we were to protect the division loss we would have to keep the denominator separate
462             // and divide at the end. However this leads to overflow with large numTokens or/and D.
463             // c = c * D * D * D * ... overflow!
464         }
465         c = c.mul(d).mul(AmplificationUtils.A_PRECISION).div(nA.mul(numTokens));
466         uint256 b = s.add(d.mul(AmplificationUtils.A_PRECISION).div(nA));
467         uint256 yPrev;
468         uint256 y = d;
469 
470         // iterative approximation
471         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
472             yPrev = y;
473             y = y.mul(y).add(c).div(y.mul(2).add(b).sub(d));
474             if (y.within1(yPrev)) {
475                 return y;
476             }
477         }
478         revert("Approximation did not converge");
479     }
480 
481     /**
482      * @notice Externally calculates a swap between two tokens.
483      * @param self Swap struct to read from
484      * @param tokenIndexFrom the token to sell
485      * @param tokenIndexTo the token to buy
486      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
487      * use the amount that gets transferred after the fee.
488      * @return dy the number of tokens the user will get
489      */
490     function calculateSwap(
491         Swap storage self,
492         uint8 tokenIndexFrom,
493         uint8 tokenIndexTo,
494         uint256 dx
495     ) external view returns (uint256 dy) {
496         (dy, ) = _calculateSwap(
497             self,
498             tokenIndexFrom,
499             tokenIndexTo,
500             dx,
501             self.balances
502         );
503     }
504 
505     /**
506      * @notice Internally calculates a swap between two tokens.
507      *
508      * @dev The caller is expected to transfer the actual amounts (dx and dy)
509      * using the token contracts.
510      *
511      * @param self Swap struct to read from
512      * @param tokenIndexFrom the token to sell
513      * @param tokenIndexTo the token to buy
514      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
515      * use the amount that gets transferred after the fee.
516      * @return dy the number of tokens the user will get
517      * @return dyFee the associated fee
518      */
519     function _calculateSwap(
520         Swap storage self,
521         uint8 tokenIndexFrom,
522         uint8 tokenIndexTo,
523         uint256 dx,
524         uint256[] memory balances
525     ) internal view returns (uint256 dy, uint256 dyFee) {
526         uint256[] memory multipliers = self.tokenPrecisionMultipliers;
527         uint256[] memory xp = _xp(balances, multipliers);
528         require(
529             tokenIndexFrom < xp.length && tokenIndexTo < xp.length,
530             "Token index out of range"
531         );
532         uint256 x = dx.mul(multipliers[tokenIndexFrom]).add(xp[tokenIndexFrom]);
533         uint256 y = getY(
534             _getAPrecise(self),
535             tokenIndexFrom,
536             tokenIndexTo,
537             x,
538             xp
539         );
540         dy = xp[tokenIndexTo].sub(y).sub(1);
541         dyFee = dy.mul(self.swapFee).div(FEE_DENOMINATOR);
542         dy = dy.sub(dyFee).div(multipliers[tokenIndexTo]);
543     }
544 
545     /**
546      * @notice A simple method to calculate amount of each underlying
547      * tokens that is returned upon burning given amount of
548      * LP tokens
549      *
550      * @param amount the amount of LP tokens that would to be burned on
551      * withdrawal
552      * @return array of amounts of tokens user will receive
553      */
554     function calculateRemoveLiquidity(Swap storage self, uint256 amount)
555         external
556         view
557         returns (uint256[] memory)
558     {
559         return
560             _calculateRemoveLiquidity(
561                 self.balances,
562                 amount,
563                 self.lpToken.totalSupply()
564             );
565     }
566 
567     function _calculateRemoveLiquidity(
568         uint256[] memory balances,
569         uint256 amount,
570         uint256 totalSupply
571     ) internal pure returns (uint256[] memory) {
572         require(amount <= totalSupply, "Cannot exceed total supply");
573 
574         uint256[] memory amounts = new uint256[](balances.length);
575 
576         for (uint256 i = 0; i < balances.length; i++) {
577             amounts[i] = balances[i].mul(amount).div(totalSupply);
578         }
579         return amounts;
580     }
581 
582     /**
583      * @notice A simple method to calculate prices from deposits or
584      * withdrawals, excluding fees but including slippage. This is
585      * helpful as an input into the various "min" parameters on calls
586      * to fight front-running
587      *
588      * @dev This shouldn't be used outside frontends for user estimates.
589      *
590      * @param self Swap struct to read from
591      * @param amounts an array of token amounts to deposit or withdrawal,
592      * corresponding to pooledTokens. The amount should be in each
593      * pooled token's native precision. If a token charges a fee on transfers,
594      * use the amount that gets transferred after the fee.
595      * @param deposit whether this is a deposit or a withdrawal
596      * @return if deposit was true, total amount of lp token that will be minted and if
597      * deposit was false, total amount of lp token that will be burned
598      */
599     function calculateTokenAmount(
600         Swap storage self,
601         uint256[] calldata amounts,
602         bool deposit
603     ) external view returns (uint256) {
604         uint256 a = _getAPrecise(self);
605         uint256[] memory balances = self.balances;
606         uint256[] memory multipliers = self.tokenPrecisionMultipliers;
607 
608         uint256 d0 = getD(_xp(balances, multipliers), a);
609         for (uint256 i = 0; i < balances.length; i++) {
610             if (deposit) {
611                 balances[i] = balances[i].add(amounts[i]);
612             } else {
613                 balances[i] = balances[i].sub(
614                     amounts[i],
615                     "Cannot withdraw more than available"
616                 );
617             }
618         }
619         uint256 d1 = getD(_xp(balances, multipliers), a);
620         uint256 totalSupply = self.lpToken.totalSupply();
621 
622         if (deposit) {
623             return d1.sub(d0).mul(totalSupply).div(d0);
624         } else {
625             return d0.sub(d1).mul(totalSupply).div(d0);
626         }
627     }
628 
629     /**
630      * @notice return accumulated amount of admin fees of the token with given index
631      * @param self Swap struct to read from
632      * @param index Index of the pooled token
633      * @return admin balance in the token's precision
634      */
635     function getAdminBalance(Swap storage self, uint256 index)
636         external
637         view
638         returns (uint256)
639     {
640         require(index < self.pooledTokens.length, "Token index out of range");
641         return
642             self.pooledTokens[index].balanceOf(address(this)).sub(
643                 self.balances[index]
644             );
645     }
646 
647     /**
648      * @notice internal helper function to calculate fee per token multiplier used in
649      * swap fee calculations
650      * @param swapFee swap fee for the tokens
651      * @param numTokens number of tokens pooled
652      */
653     function _feePerToken(uint256 swapFee, uint256 numTokens)
654         internal
655         pure
656         returns (uint256)
657     {
658         return swapFee.mul(numTokens).div(numTokens.sub(1).mul(4));
659     }
660 
661     /*** STATE MODIFYING FUNCTIONS ***/
662 
663     /**
664      * @notice swap two tokens in the pool
665      * @param self Swap struct to read from and write to
666      * @param tokenIndexFrom the token the user wants to sell
667      * @param tokenIndexTo the token the user wants to buy
668      * @param dx the amount of tokens the user wants to sell
669      * @param minDy the min amount the user would like to receive, or revert.
670      * @return amount of token user received on swap
671      */
672     function swap(
673         Swap storage self,
674         uint8 tokenIndexFrom,
675         uint8 tokenIndexTo,
676         uint256 dx,
677         uint256 minDy
678     ) external returns (uint256) {
679         {
680             IERC20 tokenFrom = self.pooledTokens[tokenIndexFrom];
681             require(
682                 dx <= tokenFrom.balanceOf(msg.sender),
683                 "Cannot swap more than you own"
684             );
685             // Transfer tokens first to see if a fee was charged on transfer
686             uint256 beforeBalance = tokenFrom.balanceOf(address(this));
687             tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
688 
689             // Use the actual transferred amount for AMM math
690             dx = tokenFrom.balanceOf(address(this)).sub(beforeBalance);
691         }
692 
693         uint256 dy;
694         uint256 dyFee;
695         uint256[] memory balances = self.balances;
696         (dy, dyFee) = _calculateSwap(
697             self,
698             tokenIndexFrom,
699             tokenIndexTo,
700             dx,
701             balances
702         );
703         require(dy >= minDy, "Swap didn't result in min tokens");
704 
705         uint256 dyAdminFee = dyFee.mul(self.adminFee).div(FEE_DENOMINATOR).div(
706             self.tokenPrecisionMultipliers[tokenIndexTo]
707         );
708 
709         self.balances[tokenIndexFrom] = balances[tokenIndexFrom].add(dx);
710         self.balances[tokenIndexTo] = balances[tokenIndexTo].sub(dy).sub(
711             dyAdminFee
712         );
713 
714         self.pooledTokens[tokenIndexTo].safeTransfer(msg.sender, dy);
715 
716         emit TokenSwap(msg.sender, dx, dy, tokenIndexFrom, tokenIndexTo);
717 
718         return dy;
719     }
720 
721     /**
722      * @notice Add liquidity to the pool
723      * @param self Swap struct to read from and write to
724      * @param amounts the amounts of each token to add, in their native precision
725      * @param minToMint the minimum LP tokens adding this amount of liquidity
726      * should mint, otherwise revert. Handy for front-running mitigation
727      * allowed addresses. If the pool is not in the guarded launch phase, this parameter will be ignored.
728      * @return amount of LP token user received
729      */
730     function addLiquidity(
731         Swap storage self,
732         uint256[] memory amounts,
733         uint256 minToMint
734     ) external returns (uint256) {
735         IERC20[] memory pooledTokens = self.pooledTokens;
736         require(
737             amounts.length == pooledTokens.length,
738             "Amounts must match pooled tokens"
739         );
740 
741         // current state
742         ManageLiquidityInfo memory v = ManageLiquidityInfo(
743             0,
744             0,
745             0,
746             _getAPrecise(self),
747             self.lpToken,
748             0,
749             self.balances,
750             self.tokenPrecisionMultipliers
751         );
752         v.totalSupply = v.lpToken.totalSupply();
753 
754         if (v.totalSupply != 0) {
755             v.d0 = getD(_xp(v.balances, v.multipliers), v.preciseA);
756         }
757 
758         uint256[] memory newBalances = new uint256[](pooledTokens.length);
759 
760         for (uint256 i = 0; i < pooledTokens.length; i++) {
761             require(
762                 v.totalSupply != 0 || amounts[i] > 0,
763                 "Must supply all tokens in pool"
764             );
765 
766             // Transfer tokens first to see if a fee was charged on transfer
767             if (amounts[i] != 0) {
768                 uint256 beforeBalance = pooledTokens[i].balanceOf(
769                     address(this)
770                 );
771                 pooledTokens[i].safeTransferFrom(
772                     msg.sender,
773                     address(this),
774                     amounts[i]
775                 );
776 
777                 // Update the amounts[] with actual transfer amount
778                 amounts[i] = pooledTokens[i].balanceOf(address(this)).sub(
779                     beforeBalance
780                 );
781             }
782 
783             newBalances[i] = v.balances[i].add(amounts[i]);
784         }
785 
786         // invariant after change
787         v.d1 = getD(_xp(newBalances, v.multipliers), v.preciseA);
788         require(v.d1 > v.d0, "D should increase");
789 
790         // updated to reflect fees and calculate the user's LP tokens
791         v.d2 = v.d1;
792         uint256[] memory fees = new uint256[](pooledTokens.length);
793 
794         if (v.totalSupply != 0) {
795             uint256 feePerToken = _feePerToken(
796                 self.swapFee,
797                 pooledTokens.length
798             );
799             for (uint256 i = 0; i < pooledTokens.length; i++) {
800                 uint256 idealBalance = v.d1.mul(v.balances[i]).div(v.d0);
801                 fees[i] = feePerToken
802                     .mul(idealBalance.difference(newBalances[i]))
803                     .div(FEE_DENOMINATOR);
804                 self.balances[i] = newBalances[i].sub(
805                     fees[i].mul(self.adminFee).div(FEE_DENOMINATOR)
806                 );
807                 newBalances[i] = newBalances[i].sub(fees[i]);
808             }
809             v.d2 = getD(_xp(newBalances, v.multipliers), v.preciseA);
810         } else {
811             // the initial depositor doesn't pay fees
812             self.balances = newBalances;
813         }
814 
815         uint256 toMint;
816         if (v.totalSupply == 0) {
817             toMint = v.d1;
818         } else {
819             toMint = v.d2.sub(v.d0).mul(v.totalSupply).div(v.d0);
820         }
821 
822         require(toMint >= minToMint, "Couldn't mint min requested");
823 
824         // mint the user's LP tokens
825         v.lpToken.mint(msg.sender, toMint);
826 
827         emit AddLiquidity(
828             msg.sender,
829             amounts,
830             fees,
831             v.d1,
832             v.totalSupply.add(toMint)
833         );
834 
835         return toMint;
836     }
837 
838     /**
839      * @notice Burn LP tokens to remove liquidity from the pool.
840      * @dev Liquidity can always be removed, even when the pool is paused.
841      * @param self Swap struct to read from and write to
842      * @param amount the amount of LP tokens to burn
843      * @param minAmounts the minimum amounts of each token in the pool
844      * acceptable for this burn. Useful as a front-running mitigation
845      * @return amounts of tokens the user received
846      */
847     function removeLiquidity(
848         Swap storage self,
849         uint256 amount,
850         uint256[] calldata minAmounts
851     ) external returns (uint256[] memory) {
852         LPToken lpToken = self.lpToken;
853         IERC20[] memory pooledTokens = self.pooledTokens;
854         require(amount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
855         require(
856             minAmounts.length == pooledTokens.length,
857             "minAmounts must match poolTokens"
858         );
859 
860         uint256[] memory balances = self.balances;
861         uint256 totalSupply = lpToken.totalSupply();
862 
863         uint256[] memory amounts = _calculateRemoveLiquidity(
864             balances,
865             amount,
866             totalSupply
867         );
868 
869         for (uint256 i = 0; i < amounts.length; i++) {
870             require(amounts[i] >= minAmounts[i], "amounts[i] < minAmounts[i]");
871             self.balances[i] = balances[i].sub(amounts[i]);
872             pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
873         }
874 
875         lpToken.burnFrom(msg.sender, amount);
876 
877         emit RemoveLiquidity(msg.sender, amounts, totalSupply.sub(amount));
878 
879         return amounts;
880     }
881 
882     /**
883      * @notice Remove liquidity from the pool all in one token.
884      * @param self Swap struct to read from and write to
885      * @param tokenAmount the amount of the lp tokens to burn
886      * @param tokenIndex the index of the token you want to receive
887      * @param minAmount the minimum amount to withdraw, otherwise revert
888      * @return amount chosen token that user received
889      */
890     function removeLiquidityOneToken(
891         Swap storage self,
892         uint256 tokenAmount,
893         uint8 tokenIndex,
894         uint256 minAmount
895     ) external returns (uint256) {
896         LPToken lpToken = self.lpToken;
897         IERC20[] memory pooledTokens = self.pooledTokens;
898 
899         require(tokenAmount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
900         require(tokenIndex < pooledTokens.length, "Token not found");
901 
902         uint256 totalSupply = lpToken.totalSupply();
903 
904         (uint256 dy, uint256 dyFee) = _calculateWithdrawOneToken(
905             self,
906             tokenAmount,
907             tokenIndex,
908             totalSupply
909         );
910 
911         require(dy >= minAmount, "dy < minAmount");
912 
913         self.balances[tokenIndex] = self.balances[tokenIndex].sub(
914             dy.add(dyFee.mul(self.adminFee).div(FEE_DENOMINATOR))
915         );
916         lpToken.burnFrom(msg.sender, tokenAmount);
917         pooledTokens[tokenIndex].safeTransfer(msg.sender, dy);
918 
919         emit RemoveLiquidityOne(
920             msg.sender,
921             tokenAmount,
922             totalSupply,
923             tokenIndex,
924             dy
925         );
926 
927         return dy;
928     }
929 
930     /**
931      * @notice Remove liquidity from the pool, weighted differently than the
932      * pool's current balances.
933      *
934      * @param self Swap struct to read from and write to
935      * @param amounts how much of each token to withdraw
936      * @param maxBurnAmount the max LP token provider is willing to pay to
937      * remove liquidity. Useful as a front-running mitigation.
938      * @return actual amount of LP tokens burned in the withdrawal
939      */
940     function removeLiquidityImbalance(
941         Swap storage self,
942         uint256[] memory amounts,
943         uint256 maxBurnAmount
944     ) public returns (uint256) {
945         ManageLiquidityInfo memory v = ManageLiquidityInfo(
946             0,
947             0,
948             0,
949             _getAPrecise(self),
950             self.lpToken,
951             0,
952             self.balances,
953             self.tokenPrecisionMultipliers
954         );
955         v.totalSupply = v.lpToken.totalSupply();
956 
957         IERC20[] memory pooledTokens = self.pooledTokens;
958 
959         require(
960             amounts.length == pooledTokens.length,
961             "Amounts should match pool tokens"
962         );
963 
964         require(
965             maxBurnAmount <= v.lpToken.balanceOf(msg.sender) &&
966                 maxBurnAmount != 0,
967             ">LP.balanceOf"
968         );
969 
970         uint256 feePerToken = _feePerToken(self.swapFee, pooledTokens.length);
971         uint256[] memory fees = new uint256[](pooledTokens.length);
972         {
973             uint256[] memory balances1 = new uint256[](pooledTokens.length);
974             v.d0 = getD(_xp(v.balances, v.multipliers), v.preciseA);
975             for (uint256 i = 0; i < pooledTokens.length; i++) {
976                 balances1[i] = v.balances[i].sub(
977                     amounts[i],
978                     "Cannot withdraw more than available"
979                 );
980             }
981             v.d1 = getD(_xp(balances1, v.multipliers), v.preciseA);
982 
983             for (uint256 i = 0; i < pooledTokens.length; i++) {
984                 uint256 idealBalance = v.d1.mul(v.balances[i]).div(v.d0);
985                 uint256 difference = idealBalance.difference(balances1[i]);
986                 fees[i] = feePerToken.mul(difference).div(FEE_DENOMINATOR);
987                 self.balances[i] = balances1[i].sub(
988                     fees[i].mul(self.adminFee).div(FEE_DENOMINATOR)
989                 );
990                 balances1[i] = balances1[i].sub(fees[i]);
991             }
992 
993             v.d2 = getD(_xp(balances1, v.multipliers), v.preciseA);
994         }
995         uint256 tokenAmount = v.d0.sub(v.d2).mul(v.totalSupply).div(v.d0);
996         require(tokenAmount != 0, "Burnt amount cannot be zero");
997         tokenAmount = tokenAmount.add(1);
998 
999         require(tokenAmount <= maxBurnAmount, "tokenAmount > maxBurnAmount");
1000 
1001         v.lpToken.burnFrom(msg.sender, tokenAmount);
1002 
1003         for (uint256 i = 0; i < pooledTokens.length; i++) {
1004             pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
1005         }
1006 
1007         emit RemoveLiquidityImbalance(
1008             msg.sender,
1009             amounts,
1010             fees,
1011             v.d1,
1012             v.totalSupply.sub(tokenAmount)
1013         );
1014 
1015         return tokenAmount;
1016     }
1017 
1018     /**
1019      * @notice withdraw all admin fees to a given address
1020      * @param self Swap struct to withdraw fees from
1021      * @param to Address to send the fees to
1022      */
1023     function withdrawAdminFees(Swap storage self, address to) external {
1024         IERC20[] memory pooledTokens = self.pooledTokens;
1025         for (uint256 i = 0; i < pooledTokens.length; i++) {
1026             IERC20 token = pooledTokens[i];
1027             uint256 balance = token.balanceOf(address(this)).sub(
1028                 self.balances[i]
1029             );
1030             if (balance != 0) {
1031                 token.safeTransfer(to, balance);
1032             }
1033         }
1034     }
1035 
1036     /**
1037      * @notice Sets the admin fee
1038      * @dev adminFee cannot be higher than 100% of the swap fee
1039      * @param self Swap struct to update
1040      * @param newAdminFee new admin fee to be applied on future transactions
1041      */
1042     function setAdminFee(Swap storage self, uint256 newAdminFee) external {
1043         require(newAdminFee <= MAX_ADMIN_FEE, "Fee is too high");
1044         self.adminFee = newAdminFee;
1045 
1046         emit NewAdminFee(newAdminFee);
1047     }
1048 
1049     /**
1050      * @notice update the swap fee
1051      * @dev fee cannot be higher than 1% of each swap
1052      * @param self Swap struct to update
1053      * @param newSwapFee new swap fee to be applied on future transactions
1054      */
1055     function setSwapFee(Swap storage self, uint256 newSwapFee) external {
1056         require(newSwapFee <= MAX_SWAP_FEE, "Fee is too high");
1057         self.swapFee = newSwapFee;
1058 
1059         emit NewSwapFee(newSwapFee);
1060     }
1061 }
