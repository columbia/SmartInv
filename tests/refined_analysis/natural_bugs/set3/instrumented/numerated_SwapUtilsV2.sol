1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 import "./AmplificationUtilsV2.sol";
7 import "./LPTokenV2.sol";
8 import "./MathUtilsV1.sol";
9 
10 /**
11  * @title SwapUtils library
12  * @notice A library to be used within Swap.sol. Contains functions responsible for custody and AMM functionalities.
13  * @dev Contracts relying on this library must initialize SwapUtils.Swap struct then use this library
14  * for SwapUtils.Swap struct. Note that this library contains both functions called by users and admins.
15  * Admin functions should be protected within contracts using this library.
16  */
17 library SwapUtilsV2 {
18     using SafeERC20 for IERC20;
19     using MathUtilsV1 for uint256;
20 
21     /*** EVENTS ***/
22 
23     event TokenSwap(
24         address indexed buyer,
25         uint256 tokensSold,
26         uint256 tokensBought,
27         uint128 soldId,
28         uint128 boughtId
29     );
30     event AddLiquidity(
31         address indexed provider,
32         uint256[] tokenAmounts,
33         uint256[] fees,
34         uint256 invariant,
35         uint256 lpTokenSupply
36     );
37     event RemoveLiquidity(
38         address indexed provider,
39         uint256[] tokenAmounts,
40         uint256 lpTokenSupply
41     );
42     event RemoveLiquidityOne(
43         address indexed provider,
44         uint256 lpTokenAmount,
45         uint256 lpTokenSupply,
46         uint256 boughtId,
47         uint256 tokensBought
48     );
49     event RemoveLiquidityImbalance(
50         address indexed provider,
51         uint256[] tokenAmounts,
52         uint256[] fees,
53         uint256 invariant,
54         uint256 lpTokenSupply
55     );
56     event NewAdminFee(uint256 newAdminFee);
57     event NewSwapFee(uint256 newSwapFee);
58 
59     struct Swap {
60         // variables around the ramp management of A,
61         // the amplification coefficient * n * (n - 1)
62         // see https://www.curve.fi/stableswap-paper.pdf for details
63         uint256 initialA;
64         uint256 futureA;
65         uint256 initialATime;
66         uint256 futureATime;
67         // fee calculation
68         uint256 swapFee;
69         uint256 adminFee;
70         LPTokenV2 lpToken;
71         // contract references for all tokens being pooled
72         IERC20[] pooledTokens;
73         // multipliers for each pooled token's precision to get to POOL_PRECISION_DECIMALS
74         // for example, TBTC has 18 decimals, so the multiplier should be 1. WBTC
75         // has 8, so the multiplier should be 10 ** 18 / 10 ** 8 => 10 ** 10
76         uint256[] tokenPrecisionMultipliers;
77         // the pool balance of each token, in the token's precision
78         // the contract's actual token balance might differ
79         uint256[] balances;
80     }
81 
82     // Struct storing variables used in calculations in the
83     // calculateWithdrawOneTokenDY function to avoid stack too deep errors
84     struct CalculateWithdrawOneTokenDYInfo {
85         uint256 d0;
86         uint256 d1;
87         uint256 newY;
88         uint256 feePerToken;
89         uint256 preciseA;
90     }
91 
92     // Struct storing variables used in calculations in the
93     // {add,remove}Liquidity functions to avoid stack too deep errors
94     struct ManageLiquidityInfo {
95         uint256 d0;
96         uint256 d1;
97         uint256 d2;
98         uint256 preciseA;
99         LPTokenV2 lpToken;
100         uint256 totalSupply;
101         uint256[] balances;
102         uint256[] multipliers;
103     }
104 
105     // the precision all pools tokens will be converted to
106     uint8 public constant POOL_PRECISION_DECIMALS = 18;
107 
108     // the denominator used to calculate admin and LP fees. For example, an
109     // LP fee might be something like tradeAmount * (fee) / (FEE_DENOMINATOR)
110     uint256 private constant FEE_DENOMINATOR = 10**10;
111 
112     // Max swap fee is 1% or 100bps of each swap
113     uint256 public constant MAX_SWAP_FEE = 10**8;
114 
115     // Max adminFee is 100% of the swapFee
116     // adminFee does not add additional fee on top of swapFee
117     // Instead it takes a certain % of the swapFee. Therefore it has no impact on the
118     // users but only on the earnings of LPs
119     uint256 public constant MAX_ADMIN_FEE = 10**10;
120 
121     // Constant value used as max loop limit
122     uint256 private constant MAX_LOOP_LIMIT = 256;
123 
124     /*** VIEW & PURE FUNCTIONS ***/
125 
126     function _getAPrecise(Swap storage self) internal view returns (uint256) {
127         return AmplificationUtilsV2._getAPrecise(self);
128     }
129 
130     /**
131      * @notice Calculate the dy, the amount of selected token that user receives and
132      * the fee of withdrawing in one token
133      * @param tokenAmount the amount to withdraw in the pool's precision
134      * @param tokenIndex which token will be withdrawn
135      * @param self Swap struct to read from
136      * @return the amount of token user will receive
137      */
138     function calculateWithdrawOneToken(
139         Swap storage self,
140         uint256 tokenAmount,
141         uint8 tokenIndex
142     ) external view returns (uint256) {
143         (uint256 availableTokenAmount, ) = _calculateWithdrawOneToken(
144             self,
145             tokenAmount,
146             tokenIndex,
147             self.lpToken.totalSupply()
148         );
149         return availableTokenAmount;
150     }
151 
152     function _calculateWithdrawOneToken(
153         Swap storage self,
154         uint256 tokenAmount,
155         uint8 tokenIndex,
156         uint256 totalSupply
157     ) internal view returns (uint256, uint256) {
158         uint256 dy;
159         uint256 newY;
160         uint256 currentY;
161 
162         (dy, newY, currentY) = calculateWithdrawOneTokenDY(
163             self,
164             tokenIndex,
165             tokenAmount,
166             totalSupply
167         );
168 
169         // dy_0 (without fees)
170         // dy, dy_0 - dy
171 
172         uint256 dySwapFee = ((currentY - newY) /
173             self.tokenPrecisionMultipliers[tokenIndex]) - dy;
174 
175         return (dy, dySwapFee);
176     }
177 
178     /**
179      * @notice Calculate the dy of withdrawing in one token
180      * @param self Swap struct to read from
181      * @param tokenIndex which token will be withdrawn
182      * @param tokenAmount the amount to withdraw in the pools precision
183      * @return the d and the new y after withdrawing one token
184      */
185     function calculateWithdrawOneTokenDY(
186         Swap storage self,
187         uint8 tokenIndex,
188         uint256 tokenAmount,
189         uint256 totalSupply
190     )
191         internal
192         view
193         returns (
194             uint256,
195             uint256,
196             uint256
197         )
198     {
199         // Get the current D, then solve the stableswap invariant
200         // y_i for D - tokenAmount
201         uint256[] memory xp = _xp(self);
202 
203         require(tokenIndex < xp.length, "Token index out of range");
204 
205         CalculateWithdrawOneTokenDYInfo
206             memory v = CalculateWithdrawOneTokenDYInfo(0, 0, 0, 0, 0);
207         v.preciseA = _getAPrecise(self);
208         v.d0 = getD(xp, v.preciseA);
209         v.d1 = v.d0 - ((tokenAmount * v.d0) / totalSupply);
210 
211         require(tokenAmount <= xp[tokenIndex], "Withdraw exceeds available");
212 
213         v.newY = getYD(v.preciseA, tokenIndex, xp, v.d1);
214 
215         uint256[] memory xpReduced = new uint256[](xp.length);
216 
217         v.feePerToken = _feePerToken(self.swapFee, xp.length);
218         for (uint256 i = 0; i < xp.length; i++) {
219             uint256 xpi = xp[i];
220             // if i == tokenIndex, dxExpected = xp[i] * d1 / d0 - newY
221             // else dxExpected = xp[i] - (xp[i] * d1 / d0)
222             // xpReduced[i] -= dxExpected * fee / FEE_DENOMINATOR
223             xpReduced[i] =
224                 xpi -
225                 (((
226                     (i == tokenIndex)
227                         ? ((xpi * v.d1) / v.d0) - v.newY
228                         : xpi - ((xpi * v.d1) / v.d0)
229                 ) * v.feePerToken) / FEE_DENOMINATOR);
230         }
231 
232         uint256 dy = xpReduced[tokenIndex] -
233             (getYD(v.preciseA, tokenIndex, xpReduced, v.d1));
234         dy = (dy - 1) / self.tokenPrecisionMultipliers[tokenIndex];
235 
236         return (dy, v.newY, xp[tokenIndex]);
237     }
238 
239     /**
240      * @notice Calculate the price of a token in the pool with given
241      * precision-adjusted balances and a particular D.
242      *
243      * @dev This is accomplished via solving the invariant iteratively.
244      * See the StableSwap paper and Curve.fi implementation for further details.
245      *
246      * x_1**2 + x1 * (sum' - (A*n**n - 1) * D / (A * n**n)) = D ** (n + 1) / (n ** (2 * n) * prod' * A)
247      * x_1**2 + b*x_1 = c
248      * x_1 = (x_1**2 + c) / (2*x_1 + b)
249      *
250      * @param a the amplification coefficient * n * (n - 1). See the StableSwap paper for details.
251      * @param tokenIndex Index of token we are calculating for.
252      * @param xp a precision-adjusted set of pool balances. Array should be
253      * the same cardinality as the pool.
254      * @param d the stableswap invariant
255      * @return the price of the token, in the same precision as in xp
256      */
257     function getYD(
258         uint256 a,
259         uint8 tokenIndex,
260         uint256[] memory xp,
261         uint256 d
262     ) internal pure returns (uint256) {
263         uint256 numTokens = xp.length;
264         require(tokenIndex < numTokens, "Token not found");
265 
266         uint256 c = d;
267         uint256 s;
268         uint256 nA = a * (numTokens);
269 
270         for (uint256 i = 0; i < numTokens; i++) {
271             if (i != tokenIndex) {
272                 s = s + xp[i];
273                 c = (c * d) / (xp[i] * (numTokens));
274                 // If we were to protect the division loss we would have to keep the denominator separate
275                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
276                 // c = c * D * D * D * ... overflow!
277             }
278         }
279         c = (c * d * AmplificationUtilsV2.A_PRECISION) / (nA * numTokens);
280 
281         uint256 b = s + ((d * AmplificationUtilsV2.A_PRECISION) / nA);
282         uint256 yPrev;
283         uint256 y = d;
284         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
285             yPrev = y;
286             y = ((y * y) + c) / ((y * 2) + b - d);
287             if (y.within1(yPrev)) {
288                 return y;
289             }
290         }
291         revert("Approximation did not converge");
292     }
293 
294     /**
295      * @notice Get D, the StableSwap invariant, based on a set of balances and a particular A.
296      * @param xp a precision-adjusted set of pool balances. Array should be the same cardinality
297      * as the pool.
298      * @param a the amplification coefficient * n * (n - 1) in A_PRECISION.
299      * See the StableSwap paper for details
300      * @return the invariant, at the precision of the pool
301      */
302     function getD(uint256[] memory xp, uint256 a)
303         internal
304         pure
305         returns (uint256)
306     {
307         uint256 numTokens = xp.length;
308         uint256 s;
309         for (uint256 i = 0; i < numTokens; i++) {
310             s = s + xp[i];
311         }
312         if (s == 0) {
313             return 0;
314         }
315 
316         uint256 prevD;
317         uint256 d = s;
318         uint256 nA = a * numTokens;
319 
320         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
321             uint256 dP = d;
322             for (uint256 j = 0; j < numTokens; j++) {
323                 dP = (dP * d) / (xp[j] * numTokens);
324                 // If we were to protect the division loss we would have to keep the denominator separate
325                 // and divide at the end. However this leads to overflow with large numTokens or/and D.
326                 // dP = dP * D * D * D * ... overflow!
327             }
328             prevD = d;
329             d =
330                 ((((nA * s) / AmplificationUtilsV2.A_PRECISION) +
331                     (dP * numTokens)) * d) /
332                 ((((nA - AmplificationUtilsV2.A_PRECISION) * d) /
333                     AmplificationUtilsV2.A_PRECISION) + ((numTokens + 1) * dP));
334             if (d.within1(prevD)) {
335                 return d;
336             }
337         }
338 
339         // Convergence should occur in 4 loops or less. If this is reached, there may be something wrong
340         // with the pool. If this were to occur repeatedly, LPs should withdraw via `removeLiquidity()`
341         // function which does not rely on D.
342         revert("D does not converge");
343     }
344 
345     /**
346      * @notice Given a set of balances and precision multipliers, return the
347      * precision-adjusted balances.
348      *
349      * @param balances an array of token balances, in their native precisions.
350      * These should generally correspond with pooled tokens.
351      *
352      * @param precisionMultipliers an array of multipliers, corresponding to
353      * the amounts in the balances array. When multiplied together they
354      * should yield amounts at the pool's precision.
355      *
356      * @return an array of amounts "scaled" to the pool's precision
357      */
358     function _xp(
359         uint256[] memory balances,
360         uint256[] memory precisionMultipliers
361     ) internal pure returns (uint256[] memory) {
362         uint256 numTokens = balances.length;
363         require(
364             numTokens == precisionMultipliers.length,
365             "Balances must match multipliers"
366         );
367         uint256[] memory xp = new uint256[](numTokens);
368         for (uint256 i = 0; i < numTokens; i++) {
369             xp[i] = balances[i] * precisionMultipliers[i];
370         }
371         return xp;
372     }
373 
374     /**
375      * @notice Return the precision-adjusted balances of all tokens in the pool
376      * @param self Swap struct to read from
377      * @return the pool balances "scaled" to the pool's precision, allowing
378      * them to be more easily compared.
379      */
380     function _xp(Swap storage self) internal view returns (uint256[] memory) {
381         return _xp(self.balances, self.tokenPrecisionMultipliers);
382     }
383 
384     /**
385      * @notice Get the virtual price, to help calculate profit
386      * @param self Swap struct to read from
387      * @return the virtual price, scaled to precision of POOL_PRECISION_DECIMALS
388      */
389     function getVirtualPrice(Swap storage self)
390         external
391         view
392         returns (uint256)
393     {
394         uint256 d = getD(_xp(self), _getAPrecise(self));
395         LPTokenV2 lpToken = self.lpToken;
396         uint256 supply = lpToken.totalSupply();
397         if (supply > 0) {
398             return (d * (10**uint256(POOL_PRECISION_DECIMALS))) / supply;
399         }
400         return 0;
401     }
402 
403     /**
404      * @notice Calculate the new balances of the tokens given the indexes of the token
405      * that is swapped from (FROM) and the token that is swapped to (TO).
406      * This function is used as a helper function to calculate how much TO token
407      * the user should receive on swap.
408      *
409      * @param preciseA precise form of amplification coefficient
410      * @param tokenIndexFrom index of FROM token
411      * @param tokenIndexTo index of TO token
412      * @param x the new total amount of FROM token
413      * @param xp balances of the tokens in the pool
414      * @return the amount of TO token that should remain in the pool
415      */
416     function getY(
417         uint256 preciseA,
418         uint8 tokenIndexFrom,
419         uint8 tokenIndexTo,
420         uint256 x,
421         uint256[] memory xp
422     ) internal pure returns (uint256) {
423         uint256 numTokens = xp.length;
424         require(
425             tokenIndexFrom != tokenIndexTo,
426             "Can't compare token to itself"
427         );
428         require(
429             tokenIndexFrom < numTokens && tokenIndexTo < numTokens,
430             "Tokens must be in pool"
431         );
432 
433         uint256 d = getD(xp, preciseA);
434         uint256 c = d;
435         uint256 s;
436         uint256 nA = numTokens * preciseA;
437 
438         uint256 _x;
439         for (uint256 i = 0; i < numTokens; i++) {
440             if (i == tokenIndexFrom) {
441                 _x = x;
442             } else if (i != tokenIndexTo) {
443                 _x = xp[i];
444             } else {
445                 continue;
446             }
447             s = s + _x;
448             c = (c * d) / (_x * numTokens);
449             // If we were to protect the division loss we would have to keep the denominator separate
450             // and divide at the end. However this leads to overflow with large numTokens or/and D.
451             // c = c * D * D * D * ... overflow!
452         }
453         c = (c * d * AmplificationUtilsV2.A_PRECISION) / (nA * numTokens);
454         uint256 b = s + ((d * AmplificationUtilsV2.A_PRECISION) / nA);
455         uint256 yPrev;
456         uint256 y = d;
457 
458         // iterative approximation
459         for (uint256 i = 0; i < MAX_LOOP_LIMIT; i++) {
460             yPrev = y;
461             y = (y * y + c) / (y * 2 + b - d);
462             if (y.within1(yPrev)) {
463                 return y;
464             }
465         }
466         revert("Approximation did not converge");
467     }
468 
469     /**
470      * @notice Externally calculates a swap between two tokens.
471      * @param self Swap struct to read from
472      * @param tokenIndexFrom the token to sell
473      * @param tokenIndexTo the token to buy
474      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
475      * use the amount that gets transferred after the fee.
476      * @return dy the number of tokens the user will get
477      */
478     function calculateSwap(
479         Swap storage self,
480         uint8 tokenIndexFrom,
481         uint8 tokenIndexTo,
482         uint256 dx
483     ) external view returns (uint256 dy) {
484         (dy, ) = _calculateSwap(
485             self,
486             tokenIndexFrom,
487             tokenIndexTo,
488             dx,
489             self.balances
490         );
491     }
492 
493     /**
494      * @notice Internally calculates a swap between two tokens.
495      *
496      * @dev The caller is expected to transfer the actual amounts (dx and dy)
497      * using the token contracts.
498      *
499      * @param self Swap struct to read from
500      * @param tokenIndexFrom the token to sell
501      * @param tokenIndexTo the token to buy
502      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
503      * use the amount that gets transferred after the fee.
504      * @return dy the number of tokens the user will get
505      * @return dyFee the associated fee
506      */
507     function _calculateSwap(
508         Swap storage self,
509         uint8 tokenIndexFrom,
510         uint8 tokenIndexTo,
511         uint256 dx,
512         uint256[] memory balances
513     ) internal view returns (uint256 dy, uint256 dyFee) {
514         uint256[] memory multipliers = self.tokenPrecisionMultipliers;
515         uint256[] memory xp = _xp(balances, multipliers);
516         require(
517             tokenIndexFrom < xp.length && tokenIndexTo < xp.length,
518             "Token index out of range"
519         );
520         uint256 x = dx * multipliers[tokenIndexFrom] + xp[tokenIndexFrom];
521         uint256 y = getY(
522             _getAPrecise(self),
523             tokenIndexFrom,
524             tokenIndexTo,
525             x,
526             xp
527         );
528         dy = xp[tokenIndexTo] - y - 1;
529         dyFee = (dy * self.swapFee) / FEE_DENOMINATOR;
530         dy = (dy - dyFee) / multipliers[tokenIndexTo];
531     }
532 
533     /**
534      * @notice A simple method to calculate amount of each underlying
535      * tokens that is returned upon burning given amount of
536      * LP tokens
537      *
538      * @param amount the amount of LP tokens that would to be burned on
539      * withdrawal
540      * @return array of amounts of tokens user will receive
541      */
542     function calculateRemoveLiquidity(Swap storage self, uint256 amount)
543         external
544         view
545         returns (uint256[] memory)
546     {
547         return
548             _calculateRemoveLiquidity(
549                 self.balances,
550                 amount,
551                 self.lpToken.totalSupply()
552             );
553     }
554 
555     function _calculateRemoveLiquidity(
556         uint256[] memory balances,
557         uint256 amount,
558         uint256 totalSupply
559     ) internal pure returns (uint256[] memory) {
560         require(amount <= totalSupply, "Cannot exceed total supply");
561 
562         uint256[] memory amounts = new uint256[](balances.length);
563 
564         for (uint256 i = 0; i < balances.length; i++) {
565             amounts[i] = (balances[i] * amount) / totalSupply;
566         }
567         return amounts;
568     }
569 
570     /**
571      * @notice A simple method to calculate prices from deposits or
572      * withdrawals, excluding fees but including slippage. This is
573      * helpful as an input into the various "min" parameters on calls
574      * to fight front-running
575      *
576      * @dev This shouldn't be used outside frontends for user estimates.
577      *
578      * @param self Swap struct to read from
579      * @param amounts an array of token amounts to deposit or withdrawal,
580      * corresponding to pooledTokens. The amount should be in each
581      * pooled token's native precision. If a token charges a fee on transfers,
582      * use the amount that gets transferred after the fee.
583      * @param deposit whether this is a deposit or a withdrawal
584      * @return if deposit was true, total amount of lp token that will be minted and if
585      * deposit was false, total amount of lp token that will be burned
586      */
587     function calculateTokenAmount(
588         Swap storage self,
589         uint256[] calldata amounts,
590         bool deposit
591     ) external view returns (uint256) {
592         uint256 a = _getAPrecise(self);
593         uint256[] memory balances = self.balances;
594         uint256[] memory multipliers = self.tokenPrecisionMultipliers;
595 
596         uint256 d0 = getD(_xp(balances, multipliers), a);
597         for (uint256 i = 0; i < balances.length; i++) {
598             if (deposit) {
599                 balances[i] = balances[i] + amounts[i];
600             } else {
601                 if (amounts[i] > balances[i]) {
602                     revert("Cannot withdraw more than available");
603                 } else {
604                     unchecked {
605                         balances[i] = balances[i] - amounts[i];
606                     }
607                 }
608             }
609         }
610         uint256 d1 = getD(_xp(balances, multipliers), a);
611         uint256 totalSupply = self.lpToken.totalSupply();
612 
613         if (deposit) {
614             return (((d1 - d0) * totalSupply) / d0);
615         } else {
616             return (((d0 - d1) * totalSupply) / d0);
617         }
618     }
619 
620     /**
621      * @notice return accumulated amount of admin fees of the token with given index
622      * @param self Swap struct to read from
623      * @param index Index of the pooled token
624      * @return admin balance in the token's precision
625      */
626     function getAdminBalance(Swap storage self, uint256 index)
627         external
628         view
629         returns (uint256)
630     {
631         require(index < self.pooledTokens.length, "Token index out of range");
632         return
633             self.pooledTokens[index].balanceOf(address(this)) -
634             self.balances[index];
635     }
636 
637     /**
638      * @notice internal helper function to calculate fee per token multiplier used in
639      * swap fee calculations
640      * @param swapFee swap fee for the tokens
641      * @param numTokens number of tokens pooled
642      */
643     function _feePerToken(uint256 swapFee, uint256 numTokens)
644         internal
645         pure
646         returns (uint256)
647     {
648         return ((swapFee * numTokens) / ((numTokens - 1) * 4));
649     }
650 
651     /*** STATE MODIFYING FUNCTIONS ***/
652 
653     /**
654      * @notice swap two tokens in the pool
655      * @param self Swap struct to read from and write to
656      * @param tokenIndexFrom the token the user wants to sell
657      * @param tokenIndexTo the token the user wants to buy
658      * @param dx the amount of tokens the user wants to sell
659      * @param minDy the min amount the user would like to receive, or revert.
660      * @return amount of token user received on swap
661      */
662     function swap(
663         Swap storage self,
664         uint8 tokenIndexFrom,
665         uint8 tokenIndexTo,
666         uint256 dx,
667         uint256 minDy
668     ) external returns (uint256) {
669         {
670             IERC20 tokenFrom = self.pooledTokens[tokenIndexFrom];
671             require(
672                 dx <= tokenFrom.balanceOf(msg.sender),
673                 "Cannot swap more than you own"
674             );
675             // Transfer tokens first to see if a fee was charged on transfer
676             uint256 beforeBalance = tokenFrom.balanceOf(address(this));
677             tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
678 
679             // Use the actual transferred amount for AMM math
680             dx = tokenFrom.balanceOf(address(this)) - beforeBalance;
681         }
682 
683         uint256 dy;
684         uint256 dyFee;
685         uint256[] memory balances = self.balances;
686         (dy, dyFee) = _calculateSwap(
687             self,
688             tokenIndexFrom,
689             tokenIndexTo,
690             dx,
691             balances
692         );
693         require(dy >= minDy, "Swap didn't result in min tokens");
694 
695         uint256 dyAdminFee = (((dyFee * self.adminFee) / FEE_DENOMINATOR) /
696             self.tokenPrecisionMultipliers[tokenIndexTo]);
697 
698         self.balances[tokenIndexFrom] = balances[tokenIndexFrom] + dx;
699         self.balances[tokenIndexTo] = balances[tokenIndexTo] - dy - dyAdminFee;
700 
701         self.pooledTokens[tokenIndexTo].safeTransfer(msg.sender, dy);
702 
703         emit TokenSwap(msg.sender, dx, dy, tokenIndexFrom, tokenIndexTo);
704 
705         return dy;
706     }
707 
708     /**
709      * @notice Add liquidity to the pool
710      * @param self Swap struct to read from and write to
711      * @param amounts the amounts of each token to add, in their native precision
712      * @param minToMint the minimum LP tokens adding this amount of liquidity
713      * should mint, otherwise revert. Handy for front-running mitigation
714      * allowed addresses. If the pool is not in the guarded launch phase, this parameter will be ignored.
715      * @return amount of LP token user received
716      */
717     function addLiquidity(
718         Swap storage self,
719         uint256[] memory amounts,
720         uint256 minToMint
721     ) external returns (uint256) {
722         IERC20[] memory pooledTokens = self.pooledTokens;
723         require(
724             amounts.length == pooledTokens.length,
725             "Amounts must match pooled tokens"
726         );
727 
728         // current state
729         ManageLiquidityInfo memory v = ManageLiquidityInfo(
730             0,
731             0,
732             0,
733             _getAPrecise(self),
734             self.lpToken,
735             0,
736             self.balances,
737             self.tokenPrecisionMultipliers
738         );
739         v.totalSupply = v.lpToken.totalSupply();
740 
741         if (v.totalSupply != 0) {
742             v.d0 = getD(_xp(v.balances, v.multipliers), v.preciseA);
743         }
744 
745         uint256[] memory newBalances = new uint256[](pooledTokens.length);
746 
747         for (uint256 i = 0; i < pooledTokens.length; i++) {
748             require(
749                 v.totalSupply != 0 || amounts[i] > 0,
750                 "Must supply all tokens in pool"
751             );
752 
753             // Transfer tokens first to see if a fee was charged on transfer
754             if (amounts[i] != 0) {
755                 uint256 beforeBalance = pooledTokens[i].balanceOf(
756                     address(this)
757                 );
758                 pooledTokens[i].safeTransferFrom(
759                     msg.sender,
760                     address(this),
761                     amounts[i]
762                 );
763 
764                 // Update the amounts[] with actual transfer amount
765                 amounts[i] =
766                     pooledTokens[i].balanceOf(address(this)) -
767                     beforeBalance;
768             }
769 
770             newBalances[i] = v.balances[i] + amounts[i];
771         }
772         // invariant after change
773         v.d1 = getD(_xp(newBalances, v.multipliers), v.preciseA);
774         require(v.d1 > v.d0, "D should increase");
775         // updated to reflect fees and calculate the user's LP tokens
776         v.d2 = v.d1;
777         uint256[] memory fees = new uint256[](pooledTokens.length);
778 
779         if (v.totalSupply != 0) {
780             uint256 feePerToken = _feePerToken(
781                 self.swapFee,
782                 pooledTokens.length
783             );
784             for (uint256 i = 0; i < pooledTokens.length; i++) {
785                 uint256 idealBalance = (v.d1 * v.balances[i]) / v.d0;
786                 fees[i] =
787                     (feePerToken * idealBalance.difference(newBalances[i])) /
788                     FEE_DENOMINATOR;
789                 self.balances[i] =
790                     newBalances[i] -
791                     ((fees[i] * self.adminFee) / FEE_DENOMINATOR);
792                 newBalances[i] = newBalances[i] - fees[i];
793             }
794             v.d2 = getD(_xp(newBalances, v.multipliers), v.preciseA);
795         } else {
796             // the initial depositor doesn't pay fees
797             self.balances = newBalances;
798         }
799 
800         uint256 toMint;
801         if (v.totalSupply == 0) {
802             toMint = v.d1;
803         } else {
804             toMint = ((v.d2 - v.d0) * v.totalSupply) / v.d0;
805         }
806 
807         require(toMint >= minToMint, "Couldn't mint min requested");
808 
809         // mint the user's LP tokens
810         v.lpToken.mint(msg.sender, toMint);
811 
812         emit AddLiquidity(
813             msg.sender,
814             amounts,
815             fees,
816             v.d1,
817             v.totalSupply + toMint
818         );
819 
820         return toMint;
821     }
822 
823     /**
824      * @notice Burn LP tokens to remove liquidity from the pool.
825      * @dev Liquidity can always be removed, even when the pool is paused.
826      * @param self Swap struct to read from and write to
827      * @param amount the amount of LP tokens to burn
828      * @param minAmounts the minimum amounts of each token in the pool
829      * acceptable for this burn. Useful as a front-running mitigation
830      * @return amounts of tokens the user received
831      */
832     function removeLiquidity(
833         Swap storage self,
834         uint256 amount,
835         uint256[] calldata minAmounts
836     ) external returns (uint256[] memory) {
837         LPTokenV2 lpToken = self.lpToken;
838         IERC20[] memory pooledTokens = self.pooledTokens;
839         require(amount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
840         require(
841             minAmounts.length == pooledTokens.length,
842             "minAmounts must match poolTokens"
843         );
844 
845         uint256[] memory balances = self.balances;
846         uint256 totalSupply = lpToken.totalSupply();
847 
848         uint256[] memory amounts = _calculateRemoveLiquidity(
849             balances,
850             amount,
851             totalSupply
852         );
853 
854         for (uint256 i = 0; i < amounts.length; i++) {
855             require(amounts[i] >= minAmounts[i], "amounts[i] < minAmounts[i]");
856             self.balances[i] = balances[i] - amounts[i];
857             pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
858         }
859 
860         lpToken.burnFrom(msg.sender, amount);
861 
862         emit RemoveLiquidity(msg.sender, amounts, totalSupply - amount);
863 
864         return amounts;
865     }
866 
867     /**
868      * @notice Remove liquidity from the pool all in one token.
869      * @param self Swap struct to read from and write to
870      * @param tokenAmount the amount of the lp tokens to burn
871      * @param tokenIndex the index of the token you want to receive
872      * @param minAmount the minimum amount to withdraw, otherwise revert
873      * @return amount chosen token that user received
874      */
875     function removeLiquidityOneToken(
876         Swap storage self,
877         uint256 tokenAmount,
878         uint8 tokenIndex,
879         uint256 minAmount
880     ) external returns (uint256) {
881         LPTokenV2 lpToken = self.lpToken;
882         IERC20[] memory pooledTokens = self.pooledTokens;
883 
884         require(tokenAmount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
885         require(tokenIndex < pooledTokens.length, "Token not found");
886 
887         uint256 totalSupply = lpToken.totalSupply();
888 
889         (uint256 dy, uint256 dyFee) = _calculateWithdrawOneToken(
890             self,
891             tokenAmount,
892             tokenIndex,
893             totalSupply
894         );
895 
896         require(dy >= minAmount, "dy < minAmount");
897 
898         self.balances[tokenIndex] =
899             self.balances[tokenIndex] -
900             (dy + ((dyFee * self.adminFee) / FEE_DENOMINATOR));
901         lpToken.burnFrom(msg.sender, tokenAmount);
902         pooledTokens[tokenIndex].safeTransfer(msg.sender, dy);
903 
904         emit RemoveLiquidityOne(
905             msg.sender,
906             tokenAmount,
907             totalSupply,
908             tokenIndex,
909             dy
910         );
911 
912         return dy;
913     }
914 
915     /**
916      * @notice Remove liquidity from the pool, weighted differently than the
917      * pool's current balances.
918      *
919      * @param self Swap struct to read from and write to
920      * @param amounts how much of each token to withdraw
921      * @param maxBurnAmount the max LP token provider is willing to pay to
922      * remove liquidity. Useful as a front-running mitigation.
923      * @return actual amount of LP tokens burned in the withdrawal
924      */
925     function removeLiquidityImbalance(
926         Swap storage self,
927         uint256[] memory amounts,
928         uint256 maxBurnAmount
929     ) public returns (uint256) {
930         ManageLiquidityInfo memory v = ManageLiquidityInfo(
931             0,
932             0,
933             0,
934             _getAPrecise(self),
935             self.lpToken,
936             0,
937             self.balances,
938             self.tokenPrecisionMultipliers
939         );
940         v.totalSupply = v.lpToken.totalSupply();
941 
942         IERC20[] memory pooledTokens = self.pooledTokens;
943 
944         require(
945             amounts.length == pooledTokens.length,
946             "Amounts should match pool tokens"
947         );
948 
949         require(
950             maxBurnAmount <= v.lpToken.balanceOf(msg.sender) &&
951                 maxBurnAmount != 0,
952             ">LP.balanceOf"
953         );
954 
955         uint256 feePerToken = _feePerToken(self.swapFee, pooledTokens.length);
956         uint256[] memory fees = new uint256[](pooledTokens.length);
957         {
958             uint256[] memory balances1 = new uint256[](pooledTokens.length);
959             v.d0 = getD(_xp(v.balances, v.multipliers), v.preciseA);
960             for (uint256 i = 0; i < pooledTokens.length; i++) {
961                 if (amounts[i] > v.balances[i]) {
962                     revert("Cannot withdraw more than available");
963                 } else {
964                     unchecked {
965                         balances1[i] = v.balances[i] - amounts[i];
966                     }
967                 }
968             }
969             v.d1 = getD(_xp(balances1, v.multipliers), v.preciseA);
970 
971             for (uint256 i = 0; i < pooledTokens.length; i++) {
972                 uint256 idealBalance = (v.d1 * v.balances[i]) / v.d0;
973                 uint256 difference = idealBalance.difference(balances1[i]);
974                 fees[i] = (feePerToken * difference) / FEE_DENOMINATOR;
975                 self.balances[i] =
976                     balances1[i] -
977                     ((fees[i] * self.adminFee) / FEE_DENOMINATOR);
978                 balances1[i] = balances1[i] - fees[i];
979             }
980 
981             v.d2 = getD(_xp(balances1, v.multipliers), v.preciseA);
982         }
983         uint256 tokenAmount = ((v.d0 - v.d2) * v.totalSupply) / v.d0;
984         require(tokenAmount != 0, "Burnt amount cannot be zero");
985         tokenAmount = tokenAmount + 1;
986 
987         require(tokenAmount <= maxBurnAmount, "tokenAmount > maxBurnAmount");
988 
989         v.lpToken.burnFrom(msg.sender, tokenAmount);
990 
991         for (uint256 i = 0; i < pooledTokens.length; i++) {
992             pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
993         }
994 
995         emit RemoveLiquidityImbalance(
996             msg.sender,
997             amounts,
998             fees,
999             v.d1,
1000             v.totalSupply - tokenAmount
1001         );
1002 
1003         return tokenAmount;
1004     }
1005 
1006     /**
1007      * @notice withdraw all admin fees to a given address
1008      * @param self Swap struct to withdraw fees from
1009      * @param to Address to send the fees to
1010      */
1011     function withdrawAdminFees(Swap storage self, address to) external {
1012         IERC20[] memory pooledTokens = self.pooledTokens;
1013         for (uint256 i = 0; i < pooledTokens.length; i++) {
1014             IERC20 token = pooledTokens[i];
1015             uint256 balance = token.balanceOf(address(this)) - self.balances[i];
1016             if (balance != 0) {
1017                 token.safeTransfer(to, balance);
1018             }
1019         }
1020     }
1021 
1022     /**
1023      * @notice Sets the admin fee
1024      * @dev adminFee cannot be higher than 100% of the swap fee
1025      * @param self Swap struct to update
1026      * @param newAdminFee new admin fee to be applied on future transactions
1027      */
1028     function setAdminFee(Swap storage self, uint256 newAdminFee) external {
1029         require(newAdminFee <= MAX_ADMIN_FEE, "Fee is too high");
1030         self.adminFee = newAdminFee;
1031 
1032         emit NewAdminFee(newAdminFee);
1033     }
1034 
1035     /**
1036      * @notice update the swap fee
1037      * @dev fee cannot be higher than 1% of each swap
1038      * @param self Swap struct to update
1039      * @param newSwapFee new swap fee to be applied on future transactions
1040      */
1041     function setSwapFee(Swap storage self, uint256 newSwapFee) external {
1042         require(newSwapFee <= MAX_SWAP_FEE, "Fee is too high");
1043         self.swapFee = newSwapFee;
1044 
1045         emit NewSwapFee(newSwapFee);
1046     }
1047 }
