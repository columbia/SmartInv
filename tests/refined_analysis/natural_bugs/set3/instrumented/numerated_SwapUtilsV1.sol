1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "./AmplificationUtilsV1.sol";
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
18 library SwapUtilsV1 {
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
60     event NewWithdrawFee(uint256 newWithdrawFee);
61 
62     struct Swap {
63         // variables around the ramp management of A,
64         // the amplification coefficient * n * (n - 1)
65         // see https://www.curve.fi/stableswap-paper.pdf for details
66         uint256 initialA;
67         uint256 futureA;
68         uint256 initialATime;
69         uint256 futureATime;
70         // fee calculation
71         uint256 swapFee;
72         uint256 adminFee;
73         uint256 defaultWithdrawFee;
74         LPToken lpToken;
75         // contract references for all tokens being pooled
76         IERC20[] pooledTokens;
77         // multipliers for each pooled token's precision to get to POOL_PRECISION_DECIMALS
78         // for example, TBTC has 18 decimals, so the multiplier should be 1. WBTC
79         // has 8, so the multiplier should be 10 ** 18 / 10 ** 8 => 10 ** 10
80         uint256[] tokenPrecisionMultipliers;
81         // the pool balance of each token, in the token's precision
82         // the contract's actual token balance might differ
83         uint256[] balances;
84         mapping(address => uint256) depositTimestamp;
85         mapping(address => uint256) withdrawFeeMultiplier;
86     }
87 
88     // Struct storing variables used in calculations in the
89     // calculateWithdrawOneTokenDY function to avoid stack too deep errors
90     struct CalculateWithdrawOneTokenDYInfo {
91         uint256 d0;
92         uint256 d1;
93         uint256 newY;
94         uint256 feePerToken;
95         uint256 preciseA;
96     }
97 
98     // Struct storing variables used in calculations in the
99     // {add,remove}Liquidity functions to avoid stack too deep errors
100     struct ManageLiquidityInfo {
101         uint256 d0;
102         uint256 d1;
103         uint256 d2;
104         uint256 preciseA;
105         LPToken lpToken;
106         uint256 totalSupply;
107         uint256[] balances;
108         uint256[] multipliers;
109     }
110 
111     // the precision all pools tokens will be converted to
112     uint8 public constant POOL_PRECISION_DECIMALS = 18;
113 
114     // the denominator used to calculate admin and LP fees. For example, an
115     // LP fee might be something like tradeAmount.mul(fee).div(FEE_DENOMINATOR)
116     uint256 private constant FEE_DENOMINATOR = 10**10;
117 
118     // Max swap fee is 1% or 100bps of each swap
119     uint256 public constant MAX_SWAP_FEE = 10**8;
120 
121     // Max adminFee is 100% of the swapFee
122     // adminFee does not add additional fee on top of swapFee
123     // Instead it takes a certain % of the swapFee. Therefore it has no impact on the
124     // users but only on the earnings of LPs
125     uint256 public constant MAX_ADMIN_FEE = 10**10;
126 
127     // Max withdrawFee is 1% of the value withdrawn
128     // Fee will be redistributed to the LPs in the pool, rewarding
129     // long term providers.
130     uint256 public constant MAX_WITHDRAW_FEE = 10**8;
131 
132     // Constant value used as max loop limit
133     uint256 private constant MAX_LOOP_LIMIT = 256;
134 
135     // Time that it should take for the withdraw fee to fully decay to 0
136     uint256 public constant WITHDRAW_FEE_DECAY_TIME = 4 weeks;
137 
138     /*** VIEW & PURE FUNCTIONS ***/
139 
140     /**
141      * @notice Retrieves the timestamp of last deposit made by the given address
142      * @param self Swap struct to read from
143      * @return timestamp of last deposit
144      */
145     function getDepositTimestamp(Swap storage self, address user)
146         external
147         view
148         returns (uint256)
149     {
150         return self.depositTimestamp[user];
151     }
152 
153     function _getAPrecise(Swap storage self) internal view returns (uint256) {
154         return AmplificationUtilsV1._getAPrecise(self);
155     }
156 
157     /**
158      * @notice Calculate the dy, the amount of selected token that user receives and
159      * the fee of withdrawing in one token
160      * @param account the address that is withdrawing
161      * @param tokenAmount the amount to withdraw in the pool's precision
162      * @param tokenIndex which token will be withdrawn
163      * @param self Swap struct to read from
164      * @return the amount of token user will receive
165      */
166     function calculateWithdrawOneToken(
167         Swap storage self,
168         address account,
169         uint256 tokenAmount,
170         uint8 tokenIndex
171     ) external view returns (uint256) {
172         (uint256 availableTokenAmount, ) = _calculateWithdrawOneToken(
173             self,
174             account,
175             tokenAmount,
176             tokenIndex,
177             self.lpToken.totalSupply()
178         );
179         return availableTokenAmount;
180     }
181 
182     function _calculateWithdrawOneToken(
183         Swap storage self,
184         address account,
185         uint256 tokenAmount,
186         uint8 tokenIndex,
187         uint256 totalSupply
188     ) internal view returns (uint256, uint256) {
189         uint256 dy;
190         uint256 newY;
191         uint256 currentY;
192 
193         (dy, newY, currentY) = calculateWithdrawOneTokenDY(
194             self,
195             tokenIndex,
196             tokenAmount,
197             totalSupply
198         );
199 
200         // dy_0 (without fees)
201         // dy, dy_0 - dy
202 
203         uint256 dySwapFee = currentY
204             .sub(newY)
205             .div(self.tokenPrecisionMultipliers[tokenIndex])
206             .sub(dy);
207 
208         dy = dy
209             .mul(
210                 FEE_DENOMINATOR.sub(_calculateCurrentWithdrawFee(self, account))
211             )
212             .div(FEE_DENOMINATOR);
213 
214         return (dy, dySwapFee);
215     }
216 
217     /**
218      * @notice Calculate the dy of withdrawing in one token
219      * @param self Swap struct to read from
220      * @param tokenIndex which token will be withdrawn
221      * @param tokenAmount the amount to withdraw in the pools precision
222      * @return the d and the new y after withdrawing one token
223      */
224     function calculateWithdrawOneTokenDY(
225         Swap storage self,
226         uint8 tokenIndex,
227         uint256 tokenAmount,
228         uint256 totalSupply
229     )
230         internal
231         view
232         returns (
233             uint256,
234             uint256,
235             uint256
236         )
237     {
238         // Get the current D, then solve the stableswap invariant
239         // y_i for D - tokenAmount
240         uint256[] memory xp = _xp(self);
241 
242         require(tokenIndex < xp.length, "Token index out of range");
243 
244         CalculateWithdrawOneTokenDYInfo
245             memory v = CalculateWithdrawOneTokenDYInfo(0, 0, 0, 0, 0);
246         v.preciseA = _getAPrecise(self);
247         v.d0 = getD(xp, v.preciseA);
248         v.d1 = v.d0.sub(tokenAmount.mul(v.d0).div(totalSupply));
249 
250         require(tokenAmount <= xp[tokenIndex], "Withdraw exceeds available");
251 
252         v.newY = getYD(v.preciseA, tokenIndex, xp, v.d1);
253 
254         uint256[] memory xpReduced = new uint256[](xp.length);
255 
256         v.feePerToken = _feePerToken(self.swapFee, xp.length);
257         for (uint256 i = 0; i < xp.length; i++) {
258             uint256 xpi = xp[i];
259             // if i == tokenIndex, dxExpected = xp[i] * d1 / d0 - newY
260             // else dxExpected = xp[i] - (xp[i] * d1 / d0)
261             // xpReduced[i] -= dxExpected * fee / FEE_DENOMINATOR
262             xpReduced[i] = xpi.sub(
263                 (
264                     (i == tokenIndex)
265                         ? xpi.mul(v.d1).div(v.d0).sub(v.newY)
266                         : xpi.sub(xpi.mul(v.d1).div(v.d0))
267                 ).mul(v.feePerToken).div(FEE_DENOMINATOR)
268             );
269         }
270 
271         uint256 dy = xpReduced[tokenIndex].sub(
272             getYD(v.preciseA, tokenIndex, xpReduced, v.d1)
273         );
274         dy = dy.sub(1).div(self.tokenPrecisionMultipliers[tokenIndex]);
275 
276         return (dy, v.newY, xp[tokenIndex]);
277     }
278 
279     /**
280      * @notice Calculate the price of a token in the pool with given
281      * precision-adjusted balances and a particular D.
282      *
283      * @dev This is accomplished via solving the invariant iteratively.
284      * See the StableSwap paper and Curve.fi implementation for further details.
285      *
286      * x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
287      * x_1**2 + b*x_1 = c
288      * x_1 = (x_1**2 + c) / (2*x_1 + b)
289      *
290      * @param a the amplification coefficient * n * (n - 1). See the StableSwap paper for details.
291      * @param tokenIndex Index of token we are calculating for.
292      * @param xp a precision-adjusted set of pool balances. Array should be
293      * the same cardinality as the pool.
294      * @param d the stableswap invariant
295      * @return the price of the token, in the same precision as in xp
296      */
297     function getYD(
298         uint256 a,
299         uint8 tokenIndex,
300         uint256[] memory xp,
301         uint256 d
302     ) internal pure returns (uint256) {
303         uint256 numTokens = xp.length;
304         require(tokenIndex < numTokens, "Token not found");
305 
306         uint256 c = d;
307         uint256 s;
308         uint256 nA = a.mul(numTokens);
309 
310         for (uint256 i = 0; i < numTokens; i++) {
311             if (i != tokenIndex) {
312                 s = s.add(xp[i]);
313                 c = c.mul(d).div(xp[i].mul(numTokens));
314                 // If we were to protect the division loss we would have to keep the denominator separate
315                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
316                 // c = c * D * D * D * ... overflow!
317             }
318         }
319         c = c.mul(d).mul(AmplificationUtilsV1.A_PRECISION).div(
320             nA.mul(numTokens)
321         );
322 
323         uint256 b = s.add(d.mul(AmplificationUtilsV1.A_PRECISION).div(nA));
324         uint256 yPrev;
325         uint256 y = d;
326         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
327             yPrev = y;
328             y = y.mul(y).add(c).div(y.mul(2).add(b).sub(d));
329             if (y.within1(yPrev)) {
330                 return y;
331             }
332         }
333         revert("Approximation did not converge");
334     }
335 
336     /**
337      * @notice Get D, the StableSwap invariant, based on a set of balances and a particular A.
338      * @param xp a precision-adjusted set of pool balances. Array should be the same cardinality
339      * as the pool.
340      * @param a the amplification coefficient * n * (n - 1) in A_PRECISION.
341      * See the StableSwap paper for details
342      * @return the invariant, at the precision of the pool
343      */
344     function getD(uint256[] memory xp, uint256 a)
345         internal
346         pure
347         returns (uint256)
348     {
349         uint256 numTokens = xp.length;
350         uint256 s;
351         for (uint256 i = 0; i < numTokens; i++) {
352             s = s.add(xp[i]);
353         }
354         if (s == 0) {
355             return 0;
356         }
357 
358         uint256 prevD;
359         uint256 d = s;
360         uint256 nA = a.mul(numTokens);
361 
362         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
363             uint256 dP = d;
364             for (uint256 j = 0; j < numTokens; j++) {
365                 dP = dP.mul(d).div(xp[j].mul(numTokens));
366                 // If we were to protect the division loss we would have to keep the denominator separate
367                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
368                 // dP = dP * D * D * D * ... overflow!
369             }
370             prevD = d;
371             d = nA
372                 .mul(s)
373                 .div(AmplificationUtilsV1.A_PRECISION)
374                 .add(dP.mul(numTokens))
375                 .mul(d)
376                 .div(
377                     nA
378                         .sub(AmplificationUtilsV1.A_PRECISION)
379                         .mul(d)
380                         .div(AmplificationUtilsV1.A_PRECISION)
381                         .add(numTokens.add(1).mul(dP))
382                 );
383             if (d.within1(prevD)) {
384                 return d;
385             }
386         }
387 
388         // Convergence should occur in 4 loops or less. If this is reached, there may be something wrong
389         // with the pool. If this were to occur repeatedly, LPs should withdraw via `removeLiquidity()`
390         // function which does not rely on D.
391         revert("D does not converge");
392     }
393 
394     /**
395      * @notice Given a set of balances and precision multipliers, return the
396      * precision-adjusted balances.
397      *
398      * @param balances an array of token balances, in their native precisions.
399      * These should generally correspond with pooled tokens.
400      *
401      * @param precisionMultipliers an array of multipliers, corresponding to
402      * the amounts in the balances array. When multiplied together they
403      * should yield amounts at the pool's precision.
404      *
405      * @return an array of amounts "scaled" to the pool's precision
406      */
407     function _xp(
408         uint256[] memory balances,
409         uint256[] memory precisionMultipliers
410     ) internal pure returns (uint256[] memory) {
411         uint256 numTokens = balances.length;
412         require(
413             numTokens == precisionMultipliers.length,
414             "Balances must match multipliers"
415         );
416         uint256[] memory xp = new uint256[](numTokens);
417         for (uint256 i = 0; i < numTokens; i++) {
418             xp[i] = balances[i].mul(precisionMultipliers[i]);
419         }
420         return xp;
421     }
422 
423     /**
424      * @notice Return the precision-adjusted balances of all tokens in the pool
425      * @param self Swap struct to read from
426      * @return the pool balances "scaled" to the pool's precision, allowing
427      * them to be more easily compared.
428      */
429     function _xp(Swap storage self) internal view returns (uint256[] memory) {
430         return _xp(self.balances, self.tokenPrecisionMultipliers);
431     }
432 
433     /**
434      * @notice Get the virtual price, to help calculate profit
435      * @param self Swap struct to read from
436      * @return the virtual price, scaled to precision of POOL_PRECISION_DECIMALS
437      */
438     function getVirtualPrice(Swap storage self)
439         external
440         view
441         returns (uint256)
442     {
443         uint256 d = getD(_xp(self), _getAPrecise(self));
444         LPToken lpToken = self.lpToken;
445         uint256 supply = lpToken.totalSupply();
446         if (supply > 0) {
447             return d.mul(10**uint256(POOL_PRECISION_DECIMALS)).div(supply);
448         }
449         return 0;
450     }
451 
452     /**
453      * @notice Calculate the new balances of the tokens given the indexes of the token
454      * that is swapped from (FROM) and the token that is swapped to (TO).
455      * This function is used as a helper function to calculate how much TO token
456      * the user should receive on swap.
457      *
458      * @param preciseA precise form of amplification coefficient
459      * @param tokenIndexFrom index of FROM token
460      * @param tokenIndexTo index of TO token
461      * @param x the new total amount of FROM token
462      * @param xp balances of the tokens in the pool
463      * @return the amount of TO token that should remain in the pool
464      */
465     function getY(
466         uint256 preciseA,
467         uint8 tokenIndexFrom,
468         uint8 tokenIndexTo,
469         uint256 x,
470         uint256[] memory xp
471     ) internal pure returns (uint256) {
472         uint256 numTokens = xp.length;
473         require(
474             tokenIndexFrom != tokenIndexTo,
475             "Can't compare token to itself"
476         );
477         require(
478             tokenIndexFrom < numTokens && tokenIndexTo < numTokens,
479             "Tokens must be in pool"
480         );
481 
482         uint256 d = getD(xp, preciseA);
483         uint256 c = d;
484         uint256 s;
485         uint256 nA = numTokens.mul(preciseA);
486 
487         uint256 _x;
488         for (uint256 i = 0; i < numTokens; i++) {
489             if (i == tokenIndexFrom) {
490                 _x = x;
491             } else if (i != tokenIndexTo) {
492                 _x = xp[i];
493             } else {
494                 continue;
495             }
496             s = s.add(_x);
497             c = c.mul(d).div(_x.mul(numTokens));
498             // If we were to protect the division loss we would have to keep the denominator separate
499             // and divide at the end. However this leads to overflow with large numTokens or/and D.
500             // c = c * D * D * D * ... overflow!
501         }
502         c = c.mul(d).mul(AmplificationUtilsV1.A_PRECISION).div(
503             nA.mul(numTokens)
504         );
505         uint256 b = s.add(d.mul(AmplificationUtilsV1.A_PRECISION).div(nA));
506         uint256 yPrev;
507         uint256 y = d;
508 
509         // iterative approximation
510         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
511             yPrev = y;
512             y = y.mul(y).add(c).div(y.mul(2).add(b).sub(d));
513             if (y.within1(yPrev)) {
514                 return y;
515             }
516         }
517         revert("Approximation did not converge");
518     }
519 
520     /**
521      * @notice Externally calculates a swap between two tokens.
522      * @param self Swap struct to read from
523      * @param tokenIndexFrom the token to sell
524      * @param tokenIndexTo the token to buy
525      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
526      * use the amount that gets transferred after the fee.
527      * @return dy the number of tokens the user will get
528      */
529     function calculateSwap(
530         Swap storage self,
531         uint8 tokenIndexFrom,
532         uint8 tokenIndexTo,
533         uint256 dx
534     ) external view returns (uint256 dy) {
535         (dy, ) = _calculateSwap(
536             self,
537             tokenIndexFrom,
538             tokenIndexTo,
539             dx,
540             self.balances
541         );
542     }
543 
544     /**
545      * @notice Internally calculates a swap between two tokens.
546      *
547      * @dev The caller is expected to transfer the actual amounts (dx and dy)
548      * using the token contracts.
549      *
550      * @param self Swap struct to read from
551      * @param tokenIndexFrom the token to sell
552      * @param tokenIndexTo the token to buy
553      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
554      * use the amount that gets transferred after the fee.
555      * @return dy the number of tokens the user will get
556      * @return dyFee the associated fee
557      */
558     function _calculateSwap(
559         Swap storage self,
560         uint8 tokenIndexFrom,
561         uint8 tokenIndexTo,
562         uint256 dx,
563         uint256[] memory balances
564     ) internal view returns (uint256 dy, uint256 dyFee) {
565         uint256[] memory multipliers = self.tokenPrecisionMultipliers;
566         uint256[] memory xp = _xp(balances, multipliers);
567         require(
568             tokenIndexFrom < xp.length && tokenIndexTo < xp.length,
569             "Token index out of range"
570         );
571         uint256 x = dx.mul(multipliers[tokenIndexFrom]).add(xp[tokenIndexFrom]);
572         uint256 y = getY(
573             _getAPrecise(self),
574             tokenIndexFrom,
575             tokenIndexTo,
576             x,
577             xp
578         );
579         dy = xp[tokenIndexTo].sub(y).sub(1);
580         dyFee = dy.mul(self.swapFee).div(FEE_DENOMINATOR);
581         dy = dy.sub(dyFee).div(multipliers[tokenIndexTo]);
582     }
583 
584     /**
585      * @notice A simple method to calculate amount of each underlying
586      * tokens that is returned upon burning given amount of
587      * LP tokens
588      *
589      * @param account the address that is removing liquidity. required for withdraw fee calculation
590      * @param amount the amount of LP tokens that would to be burned on
591      * withdrawal
592      * @return array of amounts of tokens user will receive
593      */
594     function calculateRemoveLiquidity(
595         Swap storage self,
596         address account,
597         uint256 amount
598     ) external view returns (uint256[] memory) {
599         return
600             _calculateRemoveLiquidity(
601                 self,
602                 self.balances,
603                 account,
604                 amount,
605                 self.lpToken.totalSupply()
606             );
607     }
608 
609     function _calculateRemoveLiquidity(
610         Swap storage self,
611         uint256[] memory balances,
612         address account,
613         uint256 amount,
614         uint256 totalSupply
615     ) internal view returns (uint256[] memory) {
616         require(amount <= totalSupply, "Cannot exceed total supply");
617 
618         uint256 feeAdjustedAmount = amount
619             .mul(
620                 FEE_DENOMINATOR.sub(_calculateCurrentWithdrawFee(self, account))
621             )
622             .div(FEE_DENOMINATOR);
623 
624         uint256[] memory amounts = new uint256[](balances.length);
625 
626         for (uint256 i = 0; i < balances.length; i++) {
627             amounts[i] = balances[i].mul(feeAdjustedAmount).div(totalSupply);
628         }
629         return amounts;
630     }
631 
632     /**
633      * @notice Calculate the fee that is applied when the given user withdraws.
634      * Withdraw fee decays linearly over WITHDRAW_FEE_DECAY_TIME.
635      * @param user address you want to calculate withdraw fee of
636      * @return current withdraw fee of the user
637      */
638     function calculateCurrentWithdrawFee(Swap storage self, address user)
639         external
640         view
641         returns (uint256)
642     {
643         return _calculateCurrentWithdrawFee(self, user);
644     }
645 
646     function _calculateCurrentWithdrawFee(Swap storage self, address user)
647         internal
648         view
649         returns (uint256)
650     {
651         uint256 endTime = self.depositTimestamp[user].add(
652             WITHDRAW_FEE_DECAY_TIME
653         );
654         if (endTime > block.timestamp) {
655             uint256 timeLeftover = endTime.sub(block.timestamp);
656             return
657                 self
658                     .defaultWithdrawFee
659                     .mul(self.withdrawFeeMultiplier[user])
660                     .mul(timeLeftover)
661                     .div(WITHDRAW_FEE_DECAY_TIME)
662                     .div(FEE_DENOMINATOR);
663         }
664         return 0;
665     }
666 
667     /**
668      * @notice A simple method to calculate prices from deposits or
669      * withdrawals, excluding fees but including slippage. This is
670      * helpful as an input into the various "min" parameters on calls
671      * to fight front-running
672      *
673      * @dev This shouldn't be used outside frontends for user estimates.
674      *
675      * @param self Swap struct to read from
676      * @param account address of the account depositing or withdrawing tokens
677      * @param amounts an array of token amounts to deposit or withdrawal,
678      * corresponding to pooledTokens. The amount should be in each
679      * pooled token's native precision. If a token charges a fee on transfers,
680      * use the amount that gets transferred after the fee.
681      * @param deposit whether this is a deposit or a withdrawal
682      * @return if deposit was true, total amount of lp token that will be minted and if
683      * deposit was false, total amount of lp token that will be burned
684      */
685     function calculateTokenAmount(
686         Swap storage self,
687         address account,
688         uint256[] calldata amounts,
689         bool deposit
690     ) external view returns (uint256) {
691         uint256 a = _getAPrecise(self);
692         uint256[] memory balances = self.balances;
693         uint256[] memory multipliers = self.tokenPrecisionMultipliers;
694 
695         uint256 d0 = getD(_xp(balances, multipliers), a);
696         for (uint256 i = 0; i < balances.length; i++) {
697             if (deposit) {
698                 balances[i] = balances[i].add(amounts[i]);
699             } else {
700                 balances[i] = balances[i].sub(
701                     amounts[i],
702                     "Cannot withdraw more than available"
703                 );
704             }
705         }
706         uint256 d1 = getD(_xp(balances, multipliers), a);
707         uint256 totalSupply = self.lpToken.totalSupply();
708 
709         if (deposit) {
710             return d1.sub(d0).mul(totalSupply).div(d0);
711         } else {
712             return
713                 d0.sub(d1).mul(totalSupply).div(d0).mul(FEE_DENOMINATOR).div(
714                     FEE_DENOMINATOR.sub(
715                         _calculateCurrentWithdrawFee(self, account)
716                     )
717                 );
718         }
719     }
720 
721     /**
722      * @notice return accumulated amount of admin fees of the token with given index
723      * @param self Swap struct to read from
724      * @param index Index of the pooled token
725      * @return admin balance in the token's precision
726      */
727     function getAdminBalance(Swap storage self, uint256 index)
728         external
729         view
730         returns (uint256)
731     {
732         require(index < self.pooledTokens.length, "Token index out of range");
733         return
734             self.pooledTokens[index].balanceOf(address(this)).sub(
735                 self.balances[index]
736             );
737     }
738 
739     /**
740      * @notice internal helper function to calculate fee per token multiplier used in
741      * swap fee calculations
742      * @param swapFee swap fee for the tokens
743      * @param numTokens number of tokens pooled
744      */
745     function _feePerToken(uint256 swapFee, uint256 numTokens)
746         internal
747         pure
748         returns (uint256)
749     {
750         return swapFee.mul(numTokens).div(numTokens.sub(1).mul(4));
751     }
752 
753     /*** STATE MODIFYING FUNCTIONS ***/
754 
755     /**
756      * @notice swap two tokens in the pool
757      * @param self Swap struct to read from and write to
758      * @param tokenIndexFrom the token the user wants to sell
759      * @param tokenIndexTo the token the user wants to buy
760      * @param dx the amount of tokens the user wants to sell
761      * @param minDy the min amount the user would like to receive, or revert.
762      * @return amount of token user received on swap
763      */
764     function swap(
765         Swap storage self,
766         uint8 tokenIndexFrom,
767         uint8 tokenIndexTo,
768         uint256 dx,
769         uint256 minDy
770     ) external returns (uint256) {
771         {
772             IERC20 tokenFrom = self.pooledTokens[tokenIndexFrom];
773             require(
774                 dx <= tokenFrom.balanceOf(msg.sender),
775                 "Cannot swap more than you own"
776             );
777             // Transfer tokens first to see if a fee was charged on transfer
778             uint256 beforeBalance = tokenFrom.balanceOf(address(this));
779             tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
780 
781             // Use the actual transferred amount for AMM math
782             dx = tokenFrom.balanceOf(address(this)).sub(beforeBalance);
783         }
784 
785         uint256 dy;
786         uint256 dyFee;
787         uint256[] memory balances = self.balances;
788         (dy, dyFee) = _calculateSwap(
789             self,
790             tokenIndexFrom,
791             tokenIndexTo,
792             dx,
793             balances
794         );
795         require(dy >= minDy, "Swap didn't result in min tokens");
796 
797         uint256 dyAdminFee = dyFee.mul(self.adminFee).div(FEE_DENOMINATOR).div(
798             self.tokenPrecisionMultipliers[tokenIndexTo]
799         );
800 
801         self.balances[tokenIndexFrom] = balances[tokenIndexFrom].add(dx);
802         self.balances[tokenIndexTo] = balances[tokenIndexTo].sub(dy).sub(
803             dyAdminFee
804         );
805 
806         self.pooledTokens[tokenIndexTo].safeTransfer(msg.sender, dy);
807 
808         emit TokenSwap(msg.sender, dx, dy, tokenIndexFrom, tokenIndexTo);
809 
810         return dy;
811     }
812 
813     /**
814      * @notice Add liquidity to the pool
815      * @param self Swap struct to read from and write to
816      * @param amounts the amounts of each token to add, in their native precision
817      * @param minToMint the minimum LP tokens adding this amount of liquidity
818      * should mint, otherwise revert. Handy for front-running mitigation
819      * allowed addresses. If the pool is not in the guarded launch phase, this parameter will be ignored.
820      * @return amount of LP token user received
821      */
822     function addLiquidity(
823         Swap storage self,
824         uint256[] memory amounts,
825         uint256 minToMint
826     ) external returns (uint256) {
827         IERC20[] memory pooledTokens = self.pooledTokens;
828         require(
829             amounts.length == pooledTokens.length,
830             "Amounts must match pooled tokens"
831         );
832 
833         // current state
834         ManageLiquidityInfo memory v = ManageLiquidityInfo(
835             0,
836             0,
837             0,
838             _getAPrecise(self),
839             self.lpToken,
840             0,
841             self.balances,
842             self.tokenPrecisionMultipliers
843         );
844         v.totalSupply = v.lpToken.totalSupply();
845 
846         if (v.totalSupply != 0) {
847             v.d0 = getD(_xp(v.balances, v.multipliers), v.preciseA);
848         }
849 
850         uint256[] memory newBalances = new uint256[](pooledTokens.length);
851 
852         for (uint256 i = 0; i < pooledTokens.length; i++) {
853             require(
854                 v.totalSupply != 0 || amounts[i] > 0,
855                 "Must supply all tokens in pool"
856             );
857 
858             // Transfer tokens first to see if a fee was charged on transfer
859             if (amounts[i] != 0) {
860                 uint256 beforeBalance = pooledTokens[i].balanceOf(
861                     address(this)
862                 );
863                 pooledTokens[i].safeTransferFrom(
864                     msg.sender,
865                     address(this),
866                     amounts[i]
867                 );
868 
869                 // Update the amounts[] with actual transfer amount
870                 amounts[i] = pooledTokens[i].balanceOf(address(this)).sub(
871                     beforeBalance
872                 );
873             }
874 
875             newBalances[i] = v.balances[i].add(amounts[i]);
876         }
877 
878         // invariant after change
879         v.d1 = getD(_xp(newBalances, v.multipliers), v.preciseA);
880         require(v.d1 > v.d0, "D should increase");
881 
882         // updated to reflect fees and calculate the user's LP tokens
883         v.d2 = v.d1;
884         uint256[] memory fees = new uint256[](pooledTokens.length);
885 
886         if (v.totalSupply != 0) {
887             uint256 feePerToken = _feePerToken(
888                 self.swapFee,
889                 pooledTokens.length
890             );
891             for (uint256 i = 0; i < pooledTokens.length; i++) {
892                 uint256 idealBalance = v.d1.mul(v.balances[i]).div(v.d0);
893                 fees[i] = feePerToken
894                     .mul(idealBalance.difference(newBalances[i]))
895                     .div(FEE_DENOMINATOR);
896                 self.balances[i] = newBalances[i].sub(
897                     fees[i].mul(self.adminFee).div(FEE_DENOMINATOR)
898                 );
899                 newBalances[i] = newBalances[i].sub(fees[i]);
900             }
901             v.d2 = getD(_xp(newBalances, v.multipliers), v.preciseA);
902         } else {
903             // the initial depositor doesn't pay fees
904             self.balances = newBalances;
905         }
906 
907         uint256 toMint;
908         if (v.totalSupply == 0) {
909             toMint = v.d1;
910         } else {
911             toMint = v.d2.sub(v.d0).mul(v.totalSupply).div(v.d0);
912         }
913 
914         require(toMint >= minToMint, "Couldn't mint min requested");
915 
916         // mint the user's LP tokens
917         v.lpToken.mint(msg.sender, toMint);
918 
919         emit AddLiquidity(
920             msg.sender,
921             amounts,
922             fees,
923             v.d1,
924             v.totalSupply.add(toMint)
925         );
926 
927         return toMint;
928     }
929 
930     /**
931      * @notice Update the withdraw fee for `user`. If the user is currently
932      * not providing liquidity in the pool, sets to default value. If not, recalculate
933      * the starting withdraw fee based on the last deposit's time & amount relative
934      * to the new deposit.
935      *
936      * @param self Swap struct to read from and write to
937      * @param user address of the user depositing tokens
938      * @param toMint amount of pool tokens to be minted
939      */
940     function updateUserWithdrawFee(
941         Swap storage self,
942         address user,
943         uint256 toMint
944     ) public {
945         // If token is transferred to address 0 (or burned), don't update the fee.
946         if (user == address(0)) {
947             return;
948         }
949         if (self.defaultWithdrawFee == 0) {
950             // If current fee is set to 0%, set multiplier to FEE_DENOMINATOR
951             self.withdrawFeeMultiplier[user] = FEE_DENOMINATOR;
952         } else {
953             // Otherwise, calculate appropriate discount based on last deposit amount
954             uint256 currentFee = _calculateCurrentWithdrawFee(self, user);
955             uint256 currentBalance = self.lpToken.balanceOf(user);
956 
957             // ((currentBalance * currentFee) + (toMint * defaultWithdrawFee)) * FEE_DENOMINATOR /
958             // ((toMint + currentBalance) * defaultWithdrawFee)
959             self.withdrawFeeMultiplier[user] = currentBalance
960                 .mul(currentFee)
961                 .add(toMint.mul(self.defaultWithdrawFee))
962                 .mul(FEE_DENOMINATOR)
963                 .div(toMint.add(currentBalance).mul(self.defaultWithdrawFee));
964         }
965         self.depositTimestamp[user] = block.timestamp;
966     }
967 
968     /**
969      * @notice Burn LP tokens to remove liquidity from the pool.
970      * @dev Liquidity can always be removed, even when the pool is paused.
971      * @param self Swap struct to read from and write to
972      * @param amount the amount of LP tokens to burn
973      * @param minAmounts the minimum amounts of each token in the pool
974      * acceptable for this burn. Useful as a front-running mitigation
975      * @return amounts of tokens the user received
976      */
977     function removeLiquidity(
978         Swap storage self,
979         uint256 amount,
980         uint256[] calldata minAmounts
981     ) external returns (uint256[] memory) {
982         LPToken lpToken = self.lpToken;
983         IERC20[] memory pooledTokens = self.pooledTokens;
984         require(amount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
985         require(
986             minAmounts.length == pooledTokens.length,
987             "minAmounts must match poolTokens"
988         );
989 
990         uint256[] memory balances = self.balances;
991         uint256 totalSupply = lpToken.totalSupply();
992 
993         uint256[] memory amounts = _calculateRemoveLiquidity(
994             self,
995             balances,
996             msg.sender,
997             amount,
998             totalSupply
999         );
1000 
1001         for (uint256 i = 0; i < amounts.length; i++) {
1002             require(amounts[i] >= minAmounts[i], "amounts[i] < minAmounts[i]");
1003             self.balances[i] = balances[i].sub(amounts[i]);
1004             pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
1005         }
1006 
1007         lpToken.burnFrom(msg.sender, amount);
1008 
1009         emit RemoveLiquidity(msg.sender, amounts, totalSupply.sub(amount));
1010 
1011         return amounts;
1012     }
1013 
1014     /**
1015      * @notice Remove liquidity from the pool all in one token.
1016      * @param self Swap struct to read from and write to
1017      * @param tokenAmount the amount of the lp tokens to burn
1018      * @param tokenIndex the index of the token you want to receive
1019      * @param minAmount the minimum amount to withdraw, otherwise revert
1020      * @return amount chosen token that user received
1021      */
1022     function removeLiquidityOneToken(
1023         Swap storage self,
1024         uint256 tokenAmount,
1025         uint8 tokenIndex,
1026         uint256 minAmount
1027     ) external returns (uint256) {
1028         LPToken lpToken = self.lpToken;
1029         IERC20[] memory pooledTokens = self.pooledTokens;
1030 
1031         require(tokenAmount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
1032         require(tokenIndex < pooledTokens.length, "Token not found");
1033 
1034         uint256 totalSupply = lpToken.totalSupply();
1035 
1036         (uint256 dy, uint256 dyFee) = _calculateWithdrawOneToken(
1037             self,
1038             msg.sender,
1039             tokenAmount,
1040             tokenIndex,
1041             totalSupply
1042         );
1043 
1044         require(dy >= minAmount, "dy < minAmount");
1045 
1046         self.balances[tokenIndex] = self.balances[tokenIndex].sub(
1047             dy.add(dyFee.mul(self.adminFee).div(FEE_DENOMINATOR))
1048         );
1049         lpToken.burnFrom(msg.sender, tokenAmount);
1050         pooledTokens[tokenIndex].safeTransfer(msg.sender, dy);
1051 
1052         emit RemoveLiquidityOne(
1053             msg.sender,
1054             tokenAmount,
1055             totalSupply,
1056             tokenIndex,
1057             dy
1058         );
1059 
1060         return dy;
1061     }
1062 
1063     /**
1064      * @notice Remove liquidity from the pool, weighted differently than the
1065      * pool's current balances.
1066      *
1067      * @param self Swap struct to read from and write to
1068      * @param amounts how much of each token to withdraw
1069      * @param maxBurnAmount the max LP token provider is willing to pay to
1070      * remove liquidity. Useful as a front-running mitigation.
1071      * @return actual amount of LP tokens burned in the withdrawal
1072      */
1073     function removeLiquidityImbalance(
1074         Swap storage self,
1075         uint256[] memory amounts,
1076         uint256 maxBurnAmount
1077     ) public returns (uint256) {
1078         ManageLiquidityInfo memory v = ManageLiquidityInfo(
1079             0,
1080             0,
1081             0,
1082             _getAPrecise(self),
1083             self.lpToken,
1084             0,
1085             self.balances,
1086             self.tokenPrecisionMultipliers
1087         );
1088         v.totalSupply = v.lpToken.totalSupply();
1089 
1090         IERC20[] memory pooledTokens = self.pooledTokens;
1091 
1092         require(
1093             amounts.length == pooledTokens.length,
1094             "Amounts should match pool tokens"
1095         );
1096 
1097         require(
1098             maxBurnAmount <= v.lpToken.balanceOf(msg.sender) &&
1099                 maxBurnAmount != 0,
1100             ">LP.balanceOf"
1101         );
1102 
1103         uint256 feePerToken = _feePerToken(self.swapFee, pooledTokens.length);
1104         uint256[] memory fees = new uint256[](pooledTokens.length);
1105         {
1106             uint256[] memory balances1 = new uint256[](pooledTokens.length);
1107             v.d0 = getD(_xp(v.balances, v.multipliers), v.preciseA);
1108             for (uint256 i = 0; i < pooledTokens.length; i++) {
1109                 balances1[i] = v.balances[i].sub(
1110                     amounts[i],
1111                     "Cannot withdraw more than available"
1112                 );
1113             }
1114             v.d1 = getD(_xp(balances1, v.multipliers), v.preciseA);
1115 
1116             for (uint256 i = 0; i < pooledTokens.length; i++) {
1117                 uint256 idealBalance = v.d1.mul(v.balances[i]).div(v.d0);
1118                 uint256 difference = idealBalance.difference(balances1[i]);
1119                 fees[i] = feePerToken.mul(difference).div(FEE_DENOMINATOR);
1120                 self.balances[i] = balances1[i].sub(
1121                     fees[i].mul(self.adminFee).div(FEE_DENOMINATOR)
1122                 );
1123                 balances1[i] = balances1[i].sub(fees[i]);
1124             }
1125 
1126             v.d2 = getD(_xp(balances1, v.multipliers), v.preciseA);
1127         }
1128         uint256 tokenAmount = v.d0.sub(v.d2).mul(v.totalSupply).div(v.d0);
1129         require(tokenAmount != 0, "Burnt amount cannot be zero");
1130         tokenAmount = tokenAmount.add(1).mul(FEE_DENOMINATOR).div(
1131             FEE_DENOMINATOR.sub(_calculateCurrentWithdrawFee(self, msg.sender))
1132         );
1133 
1134         require(tokenAmount <= maxBurnAmount, "tokenAmount > maxBurnAmount");
1135 
1136         v.lpToken.burnFrom(msg.sender, tokenAmount);
1137 
1138         for (uint256 i = 0; i < pooledTokens.length; i++) {
1139             pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
1140         }
1141 
1142         emit RemoveLiquidityImbalance(
1143             msg.sender,
1144             amounts,
1145             fees,
1146             v.d1,
1147             v.totalSupply.sub(tokenAmount)
1148         );
1149 
1150         return tokenAmount;
1151     }
1152 
1153     /**
1154      * @notice withdraw all admin fees to a given address
1155      * @param self Swap struct to withdraw fees from
1156      * @param to Address to send the fees to
1157      */
1158     function withdrawAdminFees(Swap storage self, address to) external {
1159         IERC20[] memory pooledTokens = self.pooledTokens;
1160         for (uint256 i = 0; i < pooledTokens.length; i++) {
1161             IERC20 token = pooledTokens[i];
1162             uint256 balance = token.balanceOf(address(this)).sub(
1163                 self.balances[i]
1164             );
1165             if (balance != 0) {
1166                 token.safeTransfer(to, balance);
1167             }
1168         }
1169     }
1170 
1171     /**
1172      * @notice Sets the admin fee
1173      * @dev adminFee cannot be higher than 100% of the swap fee
1174      * @param self Swap struct to update
1175      * @param newAdminFee new admin fee to be applied on future transactions
1176      */
1177     function setAdminFee(Swap storage self, uint256 newAdminFee) external {
1178         require(newAdminFee <= MAX_ADMIN_FEE, "Fee is too high");
1179         self.adminFee = newAdminFee;
1180 
1181         emit NewAdminFee(newAdminFee);
1182     }
1183 
1184     /**
1185      * @notice update the swap fee
1186      * @dev fee cannot be higher than 1% of each swap
1187      * @param self Swap struct to update
1188      * @param newSwapFee new swap fee to be applied on future transactions
1189      */
1190     function setSwapFee(Swap storage self, uint256 newSwapFee) external {
1191         require(newSwapFee <= MAX_SWAP_FEE, "Fee is too high");
1192         self.swapFee = newSwapFee;
1193 
1194         emit NewSwapFee(newSwapFee);
1195     }
1196 
1197     /**
1198      * @notice update the default withdraw fee. This also affects deposits made in the past as well.
1199      * @param self Swap struct to update
1200      * @param newWithdrawFee new withdraw fee to be applied
1201      */
1202     function setDefaultWithdrawFee(Swap storage self, uint256 newWithdrawFee)
1203         external
1204     {
1205         require(newWithdrawFee <= MAX_WITHDRAW_FEE, "Fee is too high");
1206         self.defaultWithdrawFee = newWithdrawFee;
1207 
1208         emit NewWithdrawFee(newWithdrawFee);
1209     }
1210 }
