1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "../LPToken.sol";
8 import "../interfaces/ISwap.sol";
9 import "../MathUtils.sol";
10 import "../SwapUtils.sol";
11 
12 /**
13  * @title MetaSwapUtils library
14  * @notice A library to be used within MetaSwap.sol. Contains functions responsible for custody and AMM functionalities.
15  *
16  * MetaSwap is a modified version of Swap that allows Swap's LP token to be utilized in pooling with other tokens.
17  * As an example, if there is a Swap pool consisting of [DAI, USDC, USDT]. Then a MetaSwap pool can be created
18  * with [sUSD, BaseSwapLPToken] to allow trades between either the LP token or the underlying tokens and sUSD.
19  *
20  * @dev Contracts relying on this library must initialize SwapUtils.Swap struct then use this library
21  * for SwapUtils.Swap struct. Note that this library contains both functions called by users and admins.
22  * Admin functions should be protected within contracts using this library.
23  */
24 library MetaSwapUtils {
25     using SafeERC20 for IERC20;
26     using SafeMath for uint256;
27     using MathUtils for uint256;
28     using AmplificationUtils for SwapUtils.Swap;
29 
30     /*** EVENTS ***/
31 
32     event TokenSwap(
33         address indexed buyer,
34         uint256 tokensSold,
35         uint256 tokensBought,
36         uint128 soldId,
37         uint128 boughtId
38     );
39     event TokenSwapUnderlying(
40         address indexed buyer,
41         uint256 tokensSold,
42         uint256 tokensBought,
43         uint128 soldId,
44         uint128 boughtId
45     );
46     event AddLiquidity(
47         address indexed provider,
48         uint256[] tokenAmounts,
49         uint256[] fees,
50         uint256 invariant,
51         uint256 lpTokenSupply
52     );
53     event RemoveLiquidityOne(
54         address indexed provider,
55         uint256 lpTokenAmount,
56         uint256 lpTokenSupply,
57         uint256 boughtId,
58         uint256 tokensBought
59     );
60     event RemoveLiquidityImbalance(
61         address indexed provider,
62         uint256[] tokenAmounts,
63         uint256[] fees,
64         uint256 invariant,
65         uint256 lpTokenSupply
66     );
67     event NewAdminFee(uint256 newAdminFee);
68     event NewSwapFee(uint256 newSwapFee);
69     event NewWithdrawFee(uint256 newWithdrawFee);
70 
71     struct MetaSwap {
72         // Meta-Swap related parameters
73         ISwap baseSwap;
74         uint256 baseVirtualPrice;
75         uint256 baseCacheLastUpdated;
76         IERC20[] baseTokens;
77     }
78 
79     // Struct storing variables used in calculations in the
80     // calculateWithdrawOneTokenDY function to avoid stack too deep errors
81     struct CalculateWithdrawOneTokenDYInfo {
82         uint256 d0;
83         uint256 d1;
84         uint256 newY;
85         uint256 feePerToken;
86         uint256 preciseA;
87         uint256 xpi;
88     }
89 
90     // Struct storing variables used in calculation in removeLiquidityImbalance function
91     // to avoid stack too deep error
92     struct ManageLiquidityInfo {
93         uint256 d0;
94         uint256 d1;
95         uint256 d2;
96         LPToken lpToken;
97         uint256 totalSupply;
98         uint256 preciseA;
99         uint256 baseVirtualPrice;
100         uint256[] tokenPrecisionMultipliers;
101         uint256[] newBalances;
102     }
103 
104     struct SwapUnderlyingInfo {
105         uint256 x;
106         uint256 dx;
107         uint256 dy;
108         uint256[] tokenPrecisionMultipliers;
109         uint256[] oldBalances;
110         IERC20[] baseTokens;
111         IERC20 tokenFrom;
112         uint8 metaIndexFrom;
113         IERC20 tokenTo;
114         uint8 metaIndexTo;
115         uint256 baseVirtualPrice;
116     }
117 
118     struct CalculateSwapUnderlyingInfo {
119         uint256 baseVirtualPrice;
120         ISwap baseSwap;
121         uint8 baseLPTokenIndex;
122         uint8 baseTokensLength;
123         uint8 metaIndexTo;
124         uint256 x;
125         uint256 dy;
126     }
127 
128     // the denominator used to calculate admin and LP fees. For example, an
129     // LP fee might be something like tradeAmount.mul(fee).div(FEE_DENOMINATOR)
130     uint256 private constant FEE_DENOMINATOR = 10**10;
131 
132     // Cache expire time for the stored value of base Swap's virtual price
133     uint256 public constant BASE_CACHE_EXPIRE_TIME = 10 minutes;
134     uint256 public constant BASE_VIRTUAL_PRICE_PRECISION = 10**18;
135 
136     /*** VIEW & PURE FUNCTIONS ***/
137 
138     /**
139      * @notice Return the stored value of base Swap's virtual price. If
140      * value was updated past BASE_CACHE_EXPIRE_TIME, then read it directly
141      * from the base Swap contract.
142      * @param metaSwapStorage MetaSwap struct to read from
143      * @return base Swap's virtual price
144      */
145     function _getBaseVirtualPrice(MetaSwap storage metaSwapStorage)
146         internal
147         view
148         returns (uint256)
149     {
150         if (
151             block.timestamp >
152             metaSwapStorage.baseCacheLastUpdated + BASE_CACHE_EXPIRE_TIME
153         ) {
154             return metaSwapStorage.baseSwap.getVirtualPrice();
155         }
156         return metaSwapStorage.baseVirtualPrice;
157     }
158 
159     function _getBaseSwapFee(ISwap baseSwap)
160         internal
161         view
162         returns (uint256 swapFee)
163     {
164         (, , , , swapFee, , ) = baseSwap.swapStorage();
165     }
166 
167     /**
168      * @notice Calculate how much the user would receive when withdrawing via single token
169      * @param self Swap struct to read from
170      * @param metaSwapStorage MetaSwap struct to read from
171      * @param tokenAmount the amount to withdraw in the pool's precision
172      * @param tokenIndex which token will be withdrawn
173      * @return dy the amount of token user will receive
174      */
175     function calculateWithdrawOneToken(
176         SwapUtils.Swap storage self,
177         MetaSwap storage metaSwapStorage,
178         uint256 tokenAmount,
179         uint8 tokenIndex
180     ) external view returns (uint256 dy) {
181         (dy, ) = _calculateWithdrawOneToken(
182             self,
183             tokenAmount,
184             tokenIndex,
185             _getBaseVirtualPrice(metaSwapStorage),
186             self.lpToken.totalSupply()
187         );
188     }
189 
190     function _calculateWithdrawOneToken(
191         SwapUtils.Swap storage self,
192         uint256 tokenAmount,
193         uint8 tokenIndex,
194         uint256 baseVirtualPrice,
195         uint256 totalSupply
196     ) internal view returns (uint256, uint256) {
197         uint256 dy;
198         uint256 dySwapFee;
199 
200         {
201             uint256 currentY;
202             uint256 newY;
203 
204             // Calculate how much to withdraw
205             (dy, newY, currentY) = _calculateWithdrawOneTokenDY(
206                 self,
207                 tokenIndex,
208                 tokenAmount,
209                 baseVirtualPrice,
210                 totalSupply
211             );
212 
213             // Calculate the associated swap fee
214             dySwapFee = currentY
215                 .sub(newY)
216                 .div(self.tokenPrecisionMultipliers[tokenIndex])
217                 .sub(dy);
218         }
219 
220         return (dy, dySwapFee);
221     }
222 
223     /**
224      * @notice Calculate the dy of withdrawing in one token
225      * @param self Swap struct to read from
226      * @param tokenIndex which token will be withdrawn
227      * @param tokenAmount the amount to withdraw in the pools precision
228      * @param baseVirtualPrice the virtual price of the base swap's LP token
229      * @return the dy excluding swap fee, the new y after withdrawing one token, and current y
230      */
231     function _calculateWithdrawOneTokenDY(
232         SwapUtils.Swap storage self,
233         uint8 tokenIndex,
234         uint256 tokenAmount,
235         uint256 baseVirtualPrice,
236         uint256 totalSupply
237     )
238         internal
239         view
240         returns (
241             uint256,
242             uint256,
243             uint256
244         )
245     {
246         // Get the current D, then solve the stableswap invariant
247         // y_i for D - tokenAmount
248         uint256[] memory xp = _xp(self, baseVirtualPrice);
249         require(tokenIndex < xp.length, "Token index out of range");
250 
251         CalculateWithdrawOneTokenDYInfo
252             memory v = CalculateWithdrawOneTokenDYInfo(
253                 0,
254                 0,
255                 0,
256                 0,
257                 self._getAPrecise(),
258                 0
259             );
260         v.d0 = SwapUtils.getD(xp, v.preciseA);
261         v.d1 = v.d0.sub(tokenAmount.mul(v.d0).div(totalSupply));
262 
263         require(tokenAmount <= xp[tokenIndex], "Withdraw exceeds available");
264 
265         v.newY = SwapUtils.getYD(v.preciseA, tokenIndex, xp, v.d1);
266 
267         uint256[] memory xpReduced = new uint256[](xp.length);
268 
269         v.feePerToken = SwapUtils._feePerToken(self.swapFee, xp.length);
270         for (uint256 i = 0; i < xp.length; i++) {
271             v.xpi = xp[i];
272             // if i == tokenIndex, dxExpected = xp[i] * d1 / d0 - newY
273             // else dxExpected = xp[i] - (xp[i] * d1 / d0)
274             // xpReduced[i] -= dxExpected * fee / FEE_DENOMINATOR
275             xpReduced[i] = v.xpi.sub(
276                 (
277                     (i == tokenIndex)
278                         ? v.xpi.mul(v.d1).div(v.d0).sub(v.newY)
279                         : v.xpi.sub(v.xpi.mul(v.d1).div(v.d0))
280                 ).mul(v.feePerToken).div(FEE_DENOMINATOR)
281             );
282         }
283 
284         uint256 dy = xpReduced[tokenIndex].sub(
285             SwapUtils.getYD(v.preciseA, tokenIndex, xpReduced, v.d1)
286         );
287 
288         if (tokenIndex == xp.length.sub(1)) {
289             dy = dy.mul(BASE_VIRTUAL_PRICE_PRECISION).div(baseVirtualPrice);
290             v.newY = v.newY.mul(BASE_VIRTUAL_PRICE_PRECISION).div(
291                 baseVirtualPrice
292             );
293             xp[tokenIndex] = xp[tokenIndex]
294                 .mul(BASE_VIRTUAL_PRICE_PRECISION)
295                 .div(baseVirtualPrice);
296         }
297         dy = dy.sub(1).div(self.tokenPrecisionMultipliers[tokenIndex]);
298 
299         return (dy, v.newY, xp[tokenIndex]);
300     }
301 
302     /**
303      * @notice Given a set of balances and precision multipliers, return the
304      * precision-adjusted balances. The last element will also get scaled up by
305      * the given baseVirtualPrice.
306      *
307      * @param balances an array of token balances, in their native precisions.
308      * These should generally correspond with pooled tokens.
309      *
310      * @param precisionMultipliers an array of multipliers, corresponding to
311      * the amounts in the balances array. When multiplied together they
312      * should yield amounts at the pool's precision.
313      *
314      * @param baseVirtualPrice the base virtual price to scale the balance of the
315      * base Swap's LP token.
316      *
317      * @return an array of amounts "scaled" to the pool's precision
318      */
319     function _xp(
320         uint256[] memory balances,
321         uint256[] memory precisionMultipliers,
322         uint256 baseVirtualPrice
323     ) internal pure returns (uint256[] memory) {
324         uint256[] memory xp = SwapUtils._xp(balances, precisionMultipliers);
325         uint256 baseLPTokenIndex = balances.length.sub(1);
326         xp[baseLPTokenIndex] = xp[baseLPTokenIndex].mul(baseVirtualPrice).div(
327             BASE_VIRTUAL_PRICE_PRECISION
328         );
329         return xp;
330     }
331 
332     /**
333      * @notice Return the precision-adjusted balances of all tokens in the pool
334      * @param self Swap struct to read from
335      * @return the pool balances "scaled" to the pool's precision, allowing
336      * them to be more easily compared.
337      */
338     function _xp(SwapUtils.Swap storage self, uint256 baseVirtualPrice)
339         internal
340         view
341         returns (uint256[] memory)
342     {
343         return
344             _xp(
345                 self.balances,
346                 self.tokenPrecisionMultipliers,
347                 baseVirtualPrice
348             );
349     }
350 
351     /**
352      * @notice Get the virtual price, to help calculate profit
353      * @param self Swap struct to read from
354      * @param metaSwapStorage MetaSwap struct to read from
355      * @return the virtual price, scaled to precision of BASE_VIRTUAL_PRICE_PRECISION
356      */
357     function getVirtualPrice(
358         SwapUtils.Swap storage self,
359         MetaSwap storage metaSwapStorage
360     ) external view returns (uint256) {
361         uint256 d = SwapUtils.getD(
362             _xp(
363                 self.balances,
364                 self.tokenPrecisionMultipliers,
365                 _getBaseVirtualPrice(metaSwapStorage)
366             ),
367             self._getAPrecise()
368         );
369         uint256 supply = self.lpToken.totalSupply();
370         if (supply != 0) {
371             return d.mul(BASE_VIRTUAL_PRICE_PRECISION).div(supply);
372         }
373         return 0;
374     }
375 
376     /**
377      * @notice Externally calculates a swap between two tokens. The SwapUtils.Swap storage and
378      * MetaSwap storage should be from the same MetaSwap contract.
379      * @param self Swap struct to read from
380      * @param metaSwapStorage MetaSwap struct from the same contract
381      * @param tokenIndexFrom the token to sell
382      * @param tokenIndexTo the token to buy
383      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
384      * use the amount that gets transferred after the fee.
385      * @return dy the number of tokens the user will get
386      */
387     function calculateSwap(
388         SwapUtils.Swap storage self,
389         MetaSwap storage metaSwapStorage,
390         uint8 tokenIndexFrom,
391         uint8 tokenIndexTo,
392         uint256 dx
393     ) external view returns (uint256 dy) {
394         (dy, ) = _calculateSwap(
395             self,
396             tokenIndexFrom,
397             tokenIndexTo,
398             dx,
399             _getBaseVirtualPrice(metaSwapStorage)
400         );
401     }
402 
403     /**
404      * @notice Internally calculates a swap between two tokens.
405      *
406      * @dev The caller is expected to transfer the actual amounts (dx and dy)
407      * using the token contracts.
408      *
409      * @param self Swap struct to read from
410      * @param tokenIndexFrom the token to sell
411      * @param tokenIndexTo the token to buy
412      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
413      * use the amount that gets transferred after the fee.
414      * @param baseVirtualPrice the virtual price of the base LP token
415      * @return dy the number of tokens the user will get and dyFee the associated fee
416      */
417     function _calculateSwap(
418         SwapUtils.Swap storage self,
419         uint8 tokenIndexFrom,
420         uint8 tokenIndexTo,
421         uint256 dx,
422         uint256 baseVirtualPrice
423     ) internal view returns (uint256 dy, uint256 dyFee) {
424         uint256[] memory xp = _xp(self, baseVirtualPrice);
425         require(
426             tokenIndexFrom < xp.length && tokenIndexTo < xp.length,
427             "Token index out of range"
428         );
429         uint256 baseLPTokenIndex = xp.length.sub(1);
430 
431         uint256 x = dx.mul(self.tokenPrecisionMultipliers[tokenIndexFrom]);
432         if (tokenIndexFrom == baseLPTokenIndex) {
433             // When swapping from a base Swap token, scale up dx by its virtual price
434             x = x.mul(baseVirtualPrice).div(BASE_VIRTUAL_PRICE_PRECISION);
435         }
436         x = x.add(xp[tokenIndexFrom]);
437 
438         uint256 y = SwapUtils.getY(
439             self._getAPrecise(),
440             tokenIndexFrom,
441             tokenIndexTo,
442             x,
443             xp
444         );
445         dy = xp[tokenIndexTo].sub(y).sub(1);
446 
447         if (tokenIndexTo == baseLPTokenIndex) {
448             // When swapping to a base Swap token, scale down dy by its virtual price
449             dy = dy.mul(BASE_VIRTUAL_PRICE_PRECISION).div(baseVirtualPrice);
450         }
451 
452         dyFee = dy.mul(self.swapFee).div(FEE_DENOMINATOR);
453         dy = dy.sub(dyFee);
454 
455         dy = dy.div(self.tokenPrecisionMultipliers[tokenIndexTo]);
456     }
457 
458     /**
459      * @notice Calculates the expected return amount from swapping between
460      * the pooled tokens and the underlying tokens of the base Swap pool.
461      *
462      * @param self Swap struct to read from
463      * @param metaSwapStorage MetaSwap struct from the same contract
464      * @param tokenIndexFrom the token to sell
465      * @param tokenIndexTo the token to buy
466      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
467      * use the amount that gets transferred after the fee.
468      * @return dy the number of tokens the user will get
469      */
470     function calculateSwapUnderlying(
471         SwapUtils.Swap storage self,
472         MetaSwap storage metaSwapStorage,
473         uint8 tokenIndexFrom,
474         uint8 tokenIndexTo,
475         uint256 dx
476     ) external view returns (uint256) {
477         CalculateSwapUnderlyingInfo memory v = CalculateSwapUnderlyingInfo(
478             _getBaseVirtualPrice(metaSwapStorage),
479             metaSwapStorage.baseSwap,
480             0,
481             uint8(metaSwapStorage.baseTokens.length),
482             0,
483             0,
484             0
485         );
486 
487         uint256[] memory xp = _xp(self, v.baseVirtualPrice);
488         v.baseLPTokenIndex = uint8(xp.length.sub(1));
489         {
490             uint8 maxRange = v.baseLPTokenIndex + v.baseTokensLength;
491             require(
492                 tokenIndexFrom < maxRange && tokenIndexTo < maxRange,
493                 "Token index out of range"
494             );
495         }
496 
497         if (tokenIndexFrom < v.baseLPTokenIndex) {
498             // tokenFrom is from this pool
499             v.x = xp[tokenIndexFrom].add(
500                 dx.mul(self.tokenPrecisionMultipliers[tokenIndexFrom])
501             );
502         } else {
503             // tokenFrom is from the base pool
504             tokenIndexFrom = tokenIndexFrom - v.baseLPTokenIndex;
505             if (tokenIndexTo < v.baseLPTokenIndex) {
506                 uint256[] memory baseInputs = new uint256[](v.baseTokensLength);
507                 baseInputs[tokenIndexFrom] = dx;
508                 v.x = v
509                     .baseSwap
510                     .calculateTokenAmount(baseInputs, true)
511                     .mul(v.baseVirtualPrice)
512                     .div(BASE_VIRTUAL_PRICE_PRECISION);
513                 // when adding to the base pool,you pay approx 50% of the swap fee
514                 v.x = v
515                     .x
516                     .sub(
517                         v.x.mul(_getBaseSwapFee(metaSwapStorage.baseSwap)).div(
518                             FEE_DENOMINATOR.mul(2)
519                         )
520                     )
521                     .add(xp[v.baseLPTokenIndex]);
522             } else {
523                 // both from and to are from the base pool
524                 return
525                     v.baseSwap.calculateSwap(
526                         tokenIndexFrom,
527                         tokenIndexTo - v.baseLPTokenIndex,
528                         dx
529                     );
530             }
531             tokenIndexFrom = v.baseLPTokenIndex;
532         }
533 
534         v.metaIndexTo = v.baseLPTokenIndex;
535         if (tokenIndexTo < v.baseLPTokenIndex) {
536             v.metaIndexTo = tokenIndexTo;
537         }
538 
539         {
540             uint256 y = SwapUtils.getY(
541                 self._getAPrecise(),
542                 tokenIndexFrom,
543                 v.metaIndexTo,
544                 v.x,
545                 xp
546             );
547             v.dy = xp[v.metaIndexTo].sub(y).sub(1);
548             uint256 dyFee = v.dy.mul(self.swapFee).div(FEE_DENOMINATOR);
549             v.dy = v.dy.sub(dyFee);
550         }
551 
552         if (tokenIndexTo < v.baseLPTokenIndex) {
553             // tokenTo is from this pool
554             v.dy = v.dy.div(self.tokenPrecisionMultipliers[v.metaIndexTo]);
555         } else {
556             // tokenTo is from the base pool
557             v.dy = v.baseSwap.calculateRemoveLiquidityOneToken(
558                 v.dy.mul(BASE_VIRTUAL_PRICE_PRECISION).div(v.baseVirtualPrice),
559                 tokenIndexTo - v.baseLPTokenIndex
560             );
561         }
562 
563         return v.dy;
564     }
565 
566     /**
567      * @notice A simple method to calculate prices from deposits or
568      * withdrawals, excluding fees but including slippage. This is
569      * helpful as an input into the various "min" parameters on calls
570      * to fight front-running
571      *
572      * @dev This shouldn't be used outside frontends for user estimates.
573      *
574      * @param self Swap struct to read from
575      * @param metaSwapStorage MetaSwap struct to read from
576      * @param amounts an array of token amounts to deposit or withdrawal,
577      * corresponding to pooledTokens. The amount should be in each
578      * pooled token's native precision. If a token charges a fee on transfers,
579      * use the amount that gets transferred after the fee.
580      * @param deposit whether this is a deposit or a withdrawal
581      * @return if deposit was true, total amount of lp token that will be minted and if
582      * deposit was false, total amount of lp token that will be burned
583      */
584     function calculateTokenAmount(
585         SwapUtils.Swap storage self,
586         MetaSwap storage metaSwapStorage,
587         uint256[] calldata amounts,
588         bool deposit
589     ) external view returns (uint256) {
590         uint256 a = self._getAPrecise();
591         uint256 d0;
592         uint256 d1;
593         {
594             uint256 baseVirtualPrice = _getBaseVirtualPrice(metaSwapStorage);
595             uint256[] memory balances1 = self.balances;
596             uint256[] memory tokenPrecisionMultipliers = self
597                 .tokenPrecisionMultipliers;
598             uint256 numTokens = balances1.length;
599             d0 = SwapUtils.getD(
600                 _xp(balances1, tokenPrecisionMultipliers, baseVirtualPrice),
601                 a
602             );
603             for (uint256 i = 0; i < numTokens; i++) {
604                 if (deposit) {
605                     balances1[i] = balances1[i].add(amounts[i]);
606                 } else {
607                     balances1[i] = balances1[i].sub(
608                         amounts[i],
609                         "Cannot withdraw more than available"
610                     );
611                 }
612             }
613             d1 = SwapUtils.getD(
614                 _xp(balances1, tokenPrecisionMultipliers, baseVirtualPrice),
615                 a
616             );
617         }
618         uint256 totalSupply = self.lpToken.totalSupply();
619 
620         if (deposit) {
621             return d1.sub(d0).mul(totalSupply).div(d0);
622         } else {
623             return d0.sub(d1).mul(totalSupply).div(d0);
624         }
625     }
626 
627     /*** STATE MODIFYING FUNCTIONS ***/
628 
629     /**
630      * @notice swap two tokens in the pool
631      * @param self Swap struct to read from and write to
632      * @param metaSwapStorage MetaSwap struct to read from and write to
633      * @param tokenIndexFrom the token the user wants to sell
634      * @param tokenIndexTo the token the user wants to buy
635      * @param dx the amount of tokens the user wants to sell
636      * @param minDy the min amount the user would like to receive, or revert.
637      * @return amount of token user received on swap
638      */
639     function swap(
640         SwapUtils.Swap storage self,
641         MetaSwap storage metaSwapStorage,
642         uint8 tokenIndexFrom,
643         uint8 tokenIndexTo,
644         uint256 dx,
645         uint256 minDy
646     ) external returns (uint256) {
647         {
648             uint256 pooledTokensLength = self.pooledTokens.length;
649             require(
650                 tokenIndexFrom < pooledTokensLength &&
651                     tokenIndexTo < pooledTokensLength,
652                 "Token index is out of range"
653             );
654         }
655 
656         uint256 transferredDx;
657         {
658             IERC20 tokenFrom = self.pooledTokens[tokenIndexFrom];
659             require(
660                 dx <= tokenFrom.balanceOf(msg.sender),
661                 "Cannot swap more than you own"
662             );
663 
664             {
665                 // Transfer tokens first to see if a fee was charged on transfer
666                 uint256 beforeBalance = tokenFrom.balanceOf(address(this));
667                 tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
668 
669                 // Use the actual transferred amount for AMM math
670                 transferredDx = tokenFrom.balanceOf(address(this)).sub(
671                     beforeBalance
672                 );
673             }
674         }
675 
676         (uint256 dy, uint256 dyFee) = _calculateSwap(
677             self,
678             tokenIndexFrom,
679             tokenIndexTo,
680             transferredDx,
681             _updateBaseVirtualPrice(metaSwapStorage)
682         );
683         require(dy >= minDy, "Swap didn't result in min tokens");
684 
685         uint256 dyAdminFee = dyFee.mul(self.adminFee).div(FEE_DENOMINATOR).div(
686             self.tokenPrecisionMultipliers[tokenIndexTo]
687         );
688 
689         self.balances[tokenIndexFrom] = self.balances[tokenIndexFrom].add(
690             transferredDx
691         );
692         self.balances[tokenIndexTo] = self.balances[tokenIndexTo].sub(dy).sub(
693             dyAdminFee
694         );
695 
696         self.pooledTokens[tokenIndexTo].safeTransfer(msg.sender, dy);
697 
698         emit TokenSwap(
699             msg.sender,
700             transferredDx,
701             dy,
702             tokenIndexFrom,
703             tokenIndexTo
704         );
705 
706         return dy;
707     }
708 
709     /**
710      * @notice Swaps with the underlying tokens of the base Swap pool. For this function,
711      * the token indices are flattened out so that underlying tokens are represented
712      * in the indices.
713      * @dev Since this calls multiple external functions during the execution,
714      * it is recommended to protect any function that depends on this with reentrancy guards.
715      * @param self Swap struct to read from and write to
716      * @param metaSwapStorage MetaSwap struct to read from and write to
717      * @param tokenIndexFrom the token the user wants to sell
718      * @param tokenIndexTo the token the user wants to buy
719      * @param dx the amount of tokens the user wants to sell
720      * @param minDy the min amount the user would like to receive, or revert.
721      * @return amount of token user received on swap
722      */
723     function swapUnderlying(
724         SwapUtils.Swap storage self,
725         MetaSwap storage metaSwapStorage,
726         uint8 tokenIndexFrom,
727         uint8 tokenIndexTo,
728         uint256 dx,
729         uint256 minDy
730     ) external returns (uint256) {
731         SwapUnderlyingInfo memory v = SwapUnderlyingInfo(
732             0,
733             0,
734             0,
735             self.tokenPrecisionMultipliers,
736             self.balances,
737             metaSwapStorage.baseTokens,
738             IERC20(address(0)),
739             0,
740             IERC20(address(0)),
741             0,
742             _updateBaseVirtualPrice(metaSwapStorage)
743         );
744 
745         uint8 baseLPTokenIndex = uint8(v.oldBalances.length.sub(1));
746 
747         {
748             uint8 maxRange = uint8(baseLPTokenIndex + v.baseTokens.length);
749             require(
750                 tokenIndexFrom < maxRange && tokenIndexTo < maxRange,
751                 "Token index out of range"
752             );
753         }
754 
755         ISwap baseSwap = metaSwapStorage.baseSwap;
756 
757         // Find the address of the token swapping from and the index in MetaSwap's token list
758         if (tokenIndexFrom < baseLPTokenIndex) {
759             v.tokenFrom = self.pooledTokens[tokenIndexFrom];
760             v.metaIndexFrom = tokenIndexFrom;
761         } else {
762             v.tokenFrom = v.baseTokens[tokenIndexFrom - baseLPTokenIndex];
763             v.metaIndexFrom = baseLPTokenIndex;
764         }
765 
766         // Find the address of the token swapping to and the index in MetaSwap's token list
767         if (tokenIndexTo < baseLPTokenIndex) {
768             v.tokenTo = self.pooledTokens[tokenIndexTo];
769             v.metaIndexTo = tokenIndexTo;
770         } else {
771             v.tokenTo = v.baseTokens[tokenIndexTo - baseLPTokenIndex];
772             v.metaIndexTo = baseLPTokenIndex;
773         }
774 
775         // Check for possible fee on transfer
776         v.dx = v.tokenFrom.balanceOf(address(this));
777         v.tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
778         v.dx = v.tokenFrom.balanceOf(address(this)).sub(v.dx); // update dx in case of fee on transfer
779 
780         if (
781             tokenIndexFrom < baseLPTokenIndex || tokenIndexTo < baseLPTokenIndex
782         ) {
783             // Either one of the tokens belongs to the MetaSwap tokens list
784             uint256[] memory xp = _xp(
785                 v.oldBalances,
786                 v.tokenPrecisionMultipliers,
787                 v.baseVirtualPrice
788             );
789 
790             if (tokenIndexFrom < baseLPTokenIndex) {
791                 // Swapping from a MetaSwap token
792                 v.x = xp[tokenIndexFrom].add(
793                     dx.mul(v.tokenPrecisionMultipliers[tokenIndexFrom])
794                 );
795             } else {
796                 // Swapping from one of the tokens hosted in the base Swap
797                 // This case requires adding the underlying token to the base Swap, then
798                 // using the base LP token to swap to the desired token
799                 uint256[] memory baseAmounts = new uint256[](
800                     v.baseTokens.length
801                 );
802                 baseAmounts[tokenIndexFrom - baseLPTokenIndex] = v.dx;
803 
804                 // Add liquidity to the base Swap contract and receive base LP token
805                 v.dx = baseSwap.addLiquidity(baseAmounts, 0, block.timestamp);
806 
807                 // Calculate the value of total amount of baseLPToken we end up with
808                 v.x = v
809                     .dx
810                     .mul(v.baseVirtualPrice)
811                     .div(BASE_VIRTUAL_PRICE_PRECISION)
812                     .add(xp[baseLPTokenIndex]);
813             }
814 
815             // Calculate how much to withdraw in MetaSwap level and the the associated swap fee
816             uint256 dyFee;
817             {
818                 uint256 y = SwapUtils.getY(
819                     self._getAPrecise(),
820                     v.metaIndexFrom,
821                     v.metaIndexTo,
822                     v.x,
823                     xp
824                 );
825                 v.dy = xp[v.metaIndexTo].sub(y).sub(1);
826                 if (tokenIndexTo >= baseLPTokenIndex) {
827                     // When swapping to a base Swap token, scale down dy by its virtual price
828                     v.dy = v.dy.mul(BASE_VIRTUAL_PRICE_PRECISION).div(
829                         v.baseVirtualPrice
830                     );
831                 }
832                 dyFee = v.dy.mul(self.swapFee).div(FEE_DENOMINATOR);
833                 v.dy = v.dy.sub(dyFee).div(
834                     v.tokenPrecisionMultipliers[v.metaIndexTo]
835                 );
836             }
837 
838             // Update the balances array according to the calculated input and output amount
839             {
840                 uint256 dyAdminFee = dyFee.mul(self.adminFee).div(
841                     FEE_DENOMINATOR
842                 );
843                 dyAdminFee = dyAdminFee.div(
844                     v.tokenPrecisionMultipliers[v.metaIndexTo]
845                 );
846                 self.balances[v.metaIndexFrom] = v
847                     .oldBalances[v.metaIndexFrom]
848                     .add(v.dx);
849                 self.balances[v.metaIndexTo] = v
850                     .oldBalances[v.metaIndexTo]
851                     .sub(v.dy)
852                     .sub(dyAdminFee);
853             }
854 
855             if (tokenIndexTo >= baseLPTokenIndex) {
856                 // When swapping to a token that belongs to the base Swap, burn the LP token
857                 // and withdraw the desired token from the base pool
858                 uint256 oldBalance = v.tokenTo.balanceOf(address(this));
859                 baseSwap.removeLiquidityOneToken(
860                     v.dy,
861                     tokenIndexTo - baseLPTokenIndex,
862                     0,
863                     block.timestamp
864                 );
865                 v.dy = v.tokenTo.balanceOf(address(this)) - oldBalance;
866             }
867 
868             // Check the amount of token to send meets minDy
869             require(v.dy >= minDy, "Swap didn't result in min tokens");
870         } else {
871             // Both tokens are from the base Swap pool
872             // Do a swap through the base Swap
873             v.dy = v.tokenTo.balanceOf(address(this));
874             baseSwap.swap(
875                 tokenIndexFrom - baseLPTokenIndex,
876                 tokenIndexTo - baseLPTokenIndex,
877                 v.dx,
878                 minDy,
879                 block.timestamp
880             );
881             v.dy = v.tokenTo.balanceOf(address(this)).sub(v.dy);
882         }
883 
884         // Send the desired token to the caller
885         v.tokenTo.safeTransfer(msg.sender, v.dy);
886 
887         emit TokenSwapUnderlying(
888             msg.sender,
889             dx,
890             v.dy,
891             tokenIndexFrom,
892             tokenIndexTo
893         );
894 
895         return v.dy;
896     }
897 
898     /**
899      * @notice Add liquidity to the pool
900      * @param self Swap struct to read from and write to
901      * @param metaSwapStorage MetaSwap struct to read from and write to
902      * @param amounts the amounts of each token to add, in their native precision
903      * @param minToMint the minimum LP tokens adding this amount of liquidity
904      * should mint, otherwise revert. Handy for front-running mitigation
905      * allowed addresses. If the pool is not in the guarded launch phase, this parameter will be ignored.
906      * @return amount of LP token user received
907      */
908     function addLiquidity(
909         SwapUtils.Swap storage self,
910         MetaSwap storage metaSwapStorage,
911         uint256[] memory amounts,
912         uint256 minToMint
913     ) external returns (uint256) {
914         IERC20[] memory pooledTokens = self.pooledTokens;
915         require(
916             amounts.length == pooledTokens.length,
917             "Amounts must match pooled tokens"
918         );
919 
920         uint256[] memory fees = new uint256[](pooledTokens.length);
921 
922         // current state
923         ManageLiquidityInfo memory v = ManageLiquidityInfo(
924             0,
925             0,
926             0,
927             self.lpToken,
928             0,
929             self._getAPrecise(),
930             _updateBaseVirtualPrice(metaSwapStorage),
931             self.tokenPrecisionMultipliers,
932             self.balances
933         );
934         v.totalSupply = v.lpToken.totalSupply();
935 
936         if (v.totalSupply != 0) {
937             v.d0 = SwapUtils.getD(
938                 _xp(
939                     v.newBalances,
940                     v.tokenPrecisionMultipliers,
941                     v.baseVirtualPrice
942                 ),
943                 v.preciseA
944             );
945         }
946 
947         for (uint256 i = 0; i < pooledTokens.length; i++) {
948             require(
949                 v.totalSupply != 0 || amounts[i] > 0,
950                 "Must supply all tokens in pool"
951             );
952 
953             // Transfer tokens first to see if a fee was charged on transfer
954             if (amounts[i] != 0) {
955                 uint256 beforeBalance = pooledTokens[i].balanceOf(
956                     address(this)
957                 );
958                 pooledTokens[i].safeTransferFrom(
959                     msg.sender,
960                     address(this),
961                     amounts[i]
962                 );
963 
964                 // Update the amounts[] with actual transfer amount
965                 amounts[i] = pooledTokens[i].balanceOf(address(this)).sub(
966                     beforeBalance
967                 );
968             }
969 
970             v.newBalances[i] = v.newBalances[i].add(amounts[i]);
971         }
972 
973         // invariant after change
974         v.d1 = SwapUtils.getD(
975             _xp(v.newBalances, v.tokenPrecisionMultipliers, v.baseVirtualPrice),
976             v.preciseA
977         );
978         require(v.d1 > v.d0, "D should increase");
979 
980         // updated to reflect fees and calculate the user's LP tokens
981         v.d2 = v.d1;
982         uint256 toMint;
983 
984         if (v.totalSupply != 0) {
985             uint256 feePerToken = SwapUtils._feePerToken(
986                 self.swapFee,
987                 pooledTokens.length
988             );
989             for (uint256 i = 0; i < pooledTokens.length; i++) {
990                 uint256 idealBalance = v.d1.mul(self.balances[i]).div(v.d0);
991                 fees[i] = feePerToken
992                     .mul(idealBalance.difference(v.newBalances[i]))
993                     .div(FEE_DENOMINATOR);
994                 self.balances[i] = v.newBalances[i].sub(
995                     fees[i].mul(self.adminFee).div(FEE_DENOMINATOR)
996                 );
997                 v.newBalances[i] = v.newBalances[i].sub(fees[i]);
998             }
999             v.d2 = SwapUtils.getD(
1000                 _xp(
1001                     v.newBalances,
1002                     v.tokenPrecisionMultipliers,
1003                     v.baseVirtualPrice
1004                 ),
1005                 v.preciseA
1006             );
1007             toMint = v.d2.sub(v.d0).mul(v.totalSupply).div(v.d0);
1008         } else {
1009             // the initial depositor doesn't pay fees
1010             self.balances = v.newBalances;
1011             toMint = v.d1;
1012         }
1013 
1014         require(toMint >= minToMint, "Couldn't mint min requested");
1015 
1016         // mint the user's LP tokens
1017         self.lpToken.mint(msg.sender, toMint);
1018 
1019         emit AddLiquidity(
1020             msg.sender,
1021             amounts,
1022             fees,
1023             v.d1,
1024             v.totalSupply.add(toMint)
1025         );
1026 
1027         return toMint;
1028     }
1029 
1030     /**
1031      * @notice Remove liquidity from the pool all in one token.
1032      * @param self Swap struct to read from and write to
1033      * @param metaSwapStorage MetaSwap struct to read from and write to
1034      * @param tokenAmount the amount of the lp tokens to burn
1035      * @param tokenIndex the index of the token you want to receive
1036      * @param minAmount the minimum amount to withdraw, otherwise revert
1037      * @return amount chosen token that user received
1038      */
1039     function removeLiquidityOneToken(
1040         SwapUtils.Swap storage self,
1041         MetaSwap storage metaSwapStorage,
1042         uint256 tokenAmount,
1043         uint8 tokenIndex,
1044         uint256 minAmount
1045     ) external returns (uint256) {
1046         LPToken lpToken = self.lpToken;
1047         uint256 totalSupply = lpToken.totalSupply();
1048         uint256 numTokens = self.pooledTokens.length;
1049         require(tokenAmount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
1050         require(tokenIndex < numTokens, "Token not found");
1051 
1052         uint256 dyFee;
1053         uint256 dy;
1054 
1055         (dy, dyFee) = _calculateWithdrawOneToken(
1056             self,
1057             tokenAmount,
1058             tokenIndex,
1059             _updateBaseVirtualPrice(metaSwapStorage),
1060             totalSupply
1061         );
1062 
1063         require(dy >= minAmount, "dy < minAmount");
1064 
1065         // Update balances array
1066         self.balances[tokenIndex] = self.balances[tokenIndex].sub(
1067             dy.add(dyFee.mul(self.adminFee).div(FEE_DENOMINATOR))
1068         );
1069 
1070         // Burn the associated LP token from the caller and send the desired token
1071         lpToken.burnFrom(msg.sender, tokenAmount);
1072         self.pooledTokens[tokenIndex].safeTransfer(msg.sender, dy);
1073 
1074         emit RemoveLiquidityOne(
1075             msg.sender,
1076             tokenAmount,
1077             totalSupply,
1078             tokenIndex,
1079             dy
1080         );
1081 
1082         return dy;
1083     }
1084 
1085     /**
1086      * @notice Remove liquidity from the pool, weighted differently than the
1087      * pool's current balances.
1088      *
1089      * @param self Swap struct to read from and write to
1090      * @param metaSwapStorage MetaSwap struct to read from and write to
1091      * @param amounts how much of each token to withdraw
1092      * @param maxBurnAmount the max LP token provider is willing to pay to
1093      * remove liquidity. Useful as a front-running mitigation.
1094      * @return actual amount of LP tokens burned in the withdrawal
1095      */
1096     function removeLiquidityImbalance(
1097         SwapUtils.Swap storage self,
1098         MetaSwap storage metaSwapStorage,
1099         uint256[] memory amounts,
1100         uint256 maxBurnAmount
1101     ) public returns (uint256) {
1102         // Using this struct to avoid stack too deep error
1103         ManageLiquidityInfo memory v = ManageLiquidityInfo(
1104             0,
1105             0,
1106             0,
1107             self.lpToken,
1108             0,
1109             self._getAPrecise(),
1110             _updateBaseVirtualPrice(metaSwapStorage),
1111             self.tokenPrecisionMultipliers,
1112             self.balances
1113         );
1114         v.totalSupply = v.lpToken.totalSupply();
1115 
1116         require(
1117             amounts.length == v.newBalances.length,
1118             "Amounts should match pool tokens"
1119         );
1120         require(maxBurnAmount != 0, "Must burn more than 0");
1121 
1122         uint256 feePerToken = SwapUtils._feePerToken(
1123             self.swapFee,
1124             v.newBalances.length
1125         );
1126 
1127         // Calculate how much LPToken should be burned
1128         uint256[] memory fees = new uint256[](v.newBalances.length);
1129         {
1130             uint256[] memory balances1 = new uint256[](v.newBalances.length);
1131 
1132             v.d0 = SwapUtils.getD(
1133                 _xp(
1134                     v.newBalances,
1135                     v.tokenPrecisionMultipliers,
1136                     v.baseVirtualPrice
1137                 ),
1138                 v.preciseA
1139             );
1140             for (uint256 i = 0; i < v.newBalances.length; i++) {
1141                 balances1[i] = v.newBalances[i].sub(
1142                     amounts[i],
1143                     "Cannot withdraw more than available"
1144                 );
1145             }
1146             v.d1 = SwapUtils.getD(
1147                 _xp(balances1, v.tokenPrecisionMultipliers, v.baseVirtualPrice),
1148                 v.preciseA
1149             );
1150 
1151             for (uint256 i = 0; i < v.newBalances.length; i++) {
1152                 uint256 idealBalance = v.d1.mul(v.newBalances[i]).div(v.d0);
1153                 uint256 difference = idealBalance.difference(balances1[i]);
1154                 fees[i] = feePerToken.mul(difference).div(FEE_DENOMINATOR);
1155                 self.balances[i] = balances1[i].sub(
1156                     fees[i].mul(self.adminFee).div(FEE_DENOMINATOR)
1157                 );
1158                 balances1[i] = balances1[i].sub(fees[i]);
1159             }
1160 
1161             v.d2 = SwapUtils.getD(
1162                 _xp(balances1, v.tokenPrecisionMultipliers, v.baseVirtualPrice),
1163                 v.preciseA
1164             );
1165         }
1166 
1167         uint256 tokenAmount = v.d0.sub(v.d2).mul(v.totalSupply).div(v.d0);
1168         require(tokenAmount != 0, "Burnt amount cannot be zero");
1169 
1170         // Scale up by withdraw fee
1171         tokenAmount = tokenAmount.add(1);
1172 
1173         // Check for max burn amount
1174         require(tokenAmount <= maxBurnAmount, "tokenAmount > maxBurnAmount");
1175 
1176         // Burn the calculated amount of LPToken from the caller and send the desired tokens
1177         v.lpToken.burnFrom(msg.sender, tokenAmount);
1178         for (uint256 i = 0; i < v.newBalances.length; i++) {
1179             self.pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
1180         }
1181 
1182         emit RemoveLiquidityImbalance(
1183             msg.sender,
1184             amounts,
1185             fees,
1186             v.d1,
1187             v.totalSupply.sub(tokenAmount)
1188         );
1189 
1190         return tokenAmount;
1191     }
1192 
1193     /**
1194      * @notice Determines if the stored value of base Swap's virtual price is expired.
1195      * If the last update was past the BASE_CACHE_EXPIRE_TIME, then update the stored value.
1196      *
1197      * @param metaSwapStorage MetaSwap struct to read from and write to
1198      * @return base Swap's virtual price
1199      */
1200     function _updateBaseVirtualPrice(MetaSwap storage metaSwapStorage)
1201         internal
1202         returns (uint256)
1203     {
1204         if (
1205             block.timestamp >
1206             metaSwapStorage.baseCacheLastUpdated + BASE_CACHE_EXPIRE_TIME
1207         ) {
1208             // When the cache is expired, update it
1209             uint256 baseVirtualPrice = ISwap(metaSwapStorage.baseSwap)
1210                 .getVirtualPrice();
1211             metaSwapStorage.baseVirtualPrice = baseVirtualPrice;
1212             metaSwapStorage.baseCacheLastUpdated = block.timestamp;
1213             return baseVirtualPrice;
1214         } else {
1215             return metaSwapStorage.baseVirtualPrice;
1216         }
1217     }
1218 }
