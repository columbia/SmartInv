1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 import "../LPTokenV2.sol";
7 import "../interfaces/ISwapV2.sol";
8 import "../MathUtilsV1.sol";
9 import "../SwapUtilsV2.sol";
10 
11 /**
12  * @title MetaSwapUtils library
13  * @notice A library to be used within MetaSwap.sol. Contains functions responsible for custody and AMM functionalities.
14  *
15  * MetaSwap is a modified version of Swap that allows Swap's LP token to be utilized in pooling with other tokens.
16  * As an example, if there is a Swap pool consisting of [DAI, USDC, USDT]. Then a MetaSwap pool can be created
17  * with [sUSD, BaseSwapLPToken] to allow trades between either the LP token or the underlying tokens and sUSD.
18  *
19  * @dev Contracts relying on this library must initialize SwapUtils.Swap struct then use this library
20  * for SwapUtils.Swap struct. Note that this library contains both functions called by users and admins.
21  * Admin functions should be protected within contracts using this library.
22  */
23 library MetaSwapUtilsV1 {
24     using SafeERC20 for IERC20;
25     using MathUtilsV1 for uint256;
26     using AmplificationUtilsV2 for SwapUtilsV2.Swap;
27 
28     /*** EVENTS ***/
29 
30     event TokenSwap(
31         address indexed buyer,
32         uint256 tokensSold,
33         uint256 tokensBought,
34         uint128 soldId,
35         uint128 boughtId
36     );
37     event TokenSwapUnderlying(
38         address indexed buyer,
39         uint256 tokensSold,
40         uint256 tokensBought,
41         uint128 soldId,
42         uint128 boughtId
43     );
44     event AddLiquidity(
45         address indexed provider,
46         uint256[] tokenAmounts,
47         uint256[] fees,
48         uint256 invariant,
49         uint256 lpTokenSupply
50     );
51     event RemoveLiquidityOne(
52         address indexed provider,
53         uint256 lpTokenAmount,
54         uint256 lpTokenSupply,
55         uint256 boughtId,
56         uint256 tokensBought
57     );
58     event RemoveLiquidityImbalance(
59         address indexed provider,
60         uint256[] tokenAmounts,
61         uint256[] fees,
62         uint256 invariant,
63         uint256 lpTokenSupply
64     );
65     event NewAdminFee(uint256 newAdminFee);
66     event NewSwapFee(uint256 newSwapFee);
67     event NewWithdrawFee(uint256 newWithdrawFee);
68 
69     struct MetaSwap {
70         // Meta-Swap related parameters
71         ISwapV2 baseSwap;
72         uint256 baseVirtualPrice;
73         uint256 baseCacheLastUpdated;
74         IERC20[] baseTokens;
75     }
76 
77     // Struct storing variables used in calculations in the
78     // calculateWithdrawOneTokenDY function to avoid stack too deep errors
79     struct CalculateWithdrawOneTokenDYInfo {
80         uint256 d0;
81         uint256 d1;
82         uint256 newY;
83         uint256 feePerToken;
84         uint256 preciseA;
85         uint256 xpi;
86     }
87 
88     // Struct storing variables used in calculation in removeLiquidityImbalance function
89     // to avoid stack too deep error
90     struct ManageLiquidityInfo {
91         uint256 d0;
92         uint256 d1;
93         uint256 d2;
94         LPTokenV2 lpToken;
95         uint256 totalSupply;
96         uint256 preciseA;
97         uint256 baseVirtualPrice;
98         uint256[] tokenPrecisionMultipliers;
99         uint256[] newBalances;
100     }
101 
102     struct SwapUnderlyingInfo {
103         uint256 x;
104         uint256 dx;
105         uint256 dy;
106         uint256[] tokenPrecisionMultipliers;
107         uint256[] oldBalances;
108         IERC20[] baseTokens;
109         IERC20 tokenFrom;
110         uint8 metaIndexFrom;
111         IERC20 tokenTo;
112         uint8 metaIndexTo;
113         uint256 baseVirtualPrice;
114     }
115 
116     struct CalculateSwapUnderlyingInfo {
117         uint256 baseVirtualPrice;
118         ISwapV2 baseSwap;
119         uint8 baseLPTokenIndex;
120         uint8 baseTokensLength;
121         uint8 metaIndexTo;
122         uint256 x;
123         uint256 dy;
124     }
125 
126     // the denominator used to calculate admin and LP fees. For example, an
127     // LP fee might be something like tradeAmount.mul(fee).div(FEE_DENOMINATOR)
128     uint256 private constant FEE_DENOMINATOR = 10**10;
129 
130     // Cache expire time for the stored value of base Swap's virtual price
131     uint256 public constant BASE_CACHE_EXPIRE_TIME = 10 minutes;
132     uint256 public constant BASE_VIRTUAL_PRICE_PRECISION = 10**18;
133 
134     /*** VIEW & PURE FUNCTIONS ***/
135 
136     /**
137      * @notice Return the stored value of base Swap's virtual price. If
138      * value was updated past BASE_CACHE_EXPIRE_TIME, then read it directly
139      * from the base Swap contract.
140      * @param metaSwapStorage MetaSwap struct to read from
141      * @return base Swap's virtual price
142      */
143     function _getBaseVirtualPrice(MetaSwap storage metaSwapStorage)
144         internal
145         view
146         returns (uint256)
147     {
148         if (
149             block.timestamp >
150             metaSwapStorage.baseCacheLastUpdated + BASE_CACHE_EXPIRE_TIME
151         ) {
152             return metaSwapStorage.baseSwap.getVirtualPrice();
153         }
154         return metaSwapStorage.baseVirtualPrice;
155     }
156 
157     function _getBaseSwapFee(ISwapV2 baseSwap)
158         internal
159         view
160         returns (uint256 swapFee)
161     {
162         (, , , , swapFee, , ) = baseSwap.swapStorage();
163     }
164 
165     /**
166      * @notice Calculate how much the user would receive when withdrawing via single token
167      * @param self Swap struct to read from
168      * @param metaSwapStorage MetaSwap struct to read from
169      * @param tokenAmount the amount to withdraw in the pool's precision
170      * @param tokenIndex which token will be withdrawn
171      * @return dy the amount of token user will receive
172      */
173     function calculateWithdrawOneToken(
174         SwapUtilsV2.Swap storage self,
175         MetaSwap storage metaSwapStorage,
176         uint256 tokenAmount,
177         uint8 tokenIndex
178     ) external view returns (uint256 dy) {
179         (dy, ) = _calculateWithdrawOneToken(
180             self,
181             tokenAmount,
182             tokenIndex,
183             _getBaseVirtualPrice(metaSwapStorage),
184             self.lpToken.totalSupply()
185         );
186     }
187 
188     function _calculateWithdrawOneToken(
189         SwapUtilsV2.Swap storage self,
190         uint256 tokenAmount,
191         uint8 tokenIndex,
192         uint256 baseVirtualPrice,
193         uint256 totalSupply
194     ) internal view returns (uint256, uint256) {
195         uint256 dy;
196         uint256 dySwapFee;
197 
198         {
199             uint256 currentY;
200             uint256 newY;
201 
202             // Calculate how much to withdraw
203             (dy, newY, currentY) = _calculateWithdrawOneTokenDY(
204                 self,
205                 tokenIndex,
206                 tokenAmount,
207                 baseVirtualPrice,
208                 totalSupply
209             );
210 
211             // Calculate the associated swap fee
212             dySwapFee =
213                 ((currentY - newY) /
214                     self.tokenPrecisionMultipliers[tokenIndex]) -
215                 dy;
216         }
217 
218         return (dy, dySwapFee);
219     }
220 
221     /**
222      * @notice Calculate the dy of withdrawing in one token
223      * @param self Swap struct to read from
224      * @param tokenIndex which token will be withdrawn
225      * @param tokenAmount the amount to withdraw in the pools precision
226      * @param baseVirtualPrice the virtual price of the base swap's LP token
227      * @return the dy excluding swap fee, the new y after withdrawing one token, and current y
228      */
229     function _calculateWithdrawOneTokenDY(
230         SwapUtilsV2.Swap storage self,
231         uint8 tokenIndex,
232         uint256 tokenAmount,
233         uint256 baseVirtualPrice,
234         uint256 totalSupply
235     )
236         internal
237         view
238         returns (
239             uint256,
240             uint256,
241             uint256
242         )
243     {
244         // Get the current D, then solve the stableswap invariant
245         // y_i for D - tokenAmount
246         uint256[] memory xp = _xp(self, baseVirtualPrice);
247         require(tokenIndex < xp.length, "Token index out of range");
248 
249         CalculateWithdrawOneTokenDYInfo
250             memory v = CalculateWithdrawOneTokenDYInfo(
251                 0,
252                 0,
253                 0,
254                 0,
255                 self._getAPrecise(),
256                 0
257             );
258         v.d0 = SwapUtilsV2.getD(xp, v.preciseA);
259         v.d1 = v.d0 - ((tokenAmount * v.d0) / totalSupply);
260 
261         require(tokenAmount <= xp[tokenIndex], "Withdraw exceeds available");
262 
263         v.newY = SwapUtilsV2.getYD(v.preciseA, tokenIndex, xp, v.d1);
264 
265         uint256[] memory xpReduced = new uint256[](xp.length);
266 
267         v.feePerToken = SwapUtilsV2._feePerToken(self.swapFee, xp.length);
268         for (uint256 i = 0; i < xp.length; i++) {
269             v.xpi = xp[i];
270             // if i == tokenIndex, dxExpected = xp[i] * d1 / d0 - newY
271             // else dxExpected = xp[i] - (xp[i] * d1 / d0)
272             // xpReduced[i] -= dxExpected * fee / FEE_DENOMINATOR
273             xpReduced[i] =
274                 v.xpi -
275                 (((
276                     (i == tokenIndex)
277                         ? (v.xpi * v.d1) / v.d0 - v.newY
278                         : v.xpi - ((v.xpi * v.d1) / v.d0)
279                 ) * v.feePerToken) / FEE_DENOMINATOR);
280         }
281 
282         uint256 dy = xpReduced[tokenIndex] -
283             SwapUtilsV2.getYD(v.preciseA, tokenIndex, xpReduced, v.d1);
284 
285         if (tokenIndex == xp.length - 1) {
286             dy = (dy * BASE_VIRTUAL_PRICE_PRECISION) / baseVirtualPrice;
287             v.newY = (v.newY * BASE_VIRTUAL_PRICE_PRECISION) / baseVirtualPrice;
288             xp[tokenIndex] =
289                 (xp[tokenIndex] * BASE_VIRTUAL_PRICE_PRECISION) /
290                 baseVirtualPrice;
291         }
292         dy = (dy - 1) / self.tokenPrecisionMultipliers[tokenIndex];
293 
294         return (dy, v.newY, xp[tokenIndex]);
295     }
296 
297     /**
298      * @notice Given a set of balances and precision multipliers, return the
299      * precision-adjusted balances. The last element will also get scaled up by
300      * the given baseVirtualPrice.
301      *
302      * @param balances an array of token balances, in their native precisions.
303      * These should generally correspond with pooled tokens.
304      *
305      * @param precisionMultipliers an array of multipliers, corresponding to
306      * the amounts in the balances array. When multiplied together they
307      * should yield amounts at the pool's precision.
308      *
309      * @param baseVirtualPrice the base virtual price to scale the balance of the
310      * base Swap's LP token.
311      *
312      * @return an array of amounts "scaled" to the pool's precision
313      */
314     function _xp(
315         uint256[] memory balances,
316         uint256[] memory precisionMultipliers,
317         uint256 baseVirtualPrice
318     ) internal pure returns (uint256[] memory) {
319         uint256[] memory xp = SwapUtilsV2._xp(balances, precisionMultipliers);
320         uint256 baseLPTokenIndex = balances.length - 1;
321         xp[baseLPTokenIndex] =
322             (xp[baseLPTokenIndex] * baseVirtualPrice) /
323             BASE_VIRTUAL_PRICE_PRECISION;
324         return xp;
325     }
326 
327     /**
328      * @notice Return the precision-adjusted balances of all tokens in the pool
329      * @param self Swap struct to read from
330      * @return the pool balances "scaled" to the pool's precision, allowing
331      * them to be more easily compared.
332      */
333     function _xp(SwapUtilsV2.Swap storage self, uint256 baseVirtualPrice)
334         internal
335         view
336         returns (uint256[] memory)
337     {
338         return
339             _xp(
340                 self.balances,
341                 self.tokenPrecisionMultipliers,
342                 baseVirtualPrice
343             );
344     }
345 
346     /**
347      * @notice Get the virtual price, to help calculate profit
348      * @param self Swap struct to read from
349      * @param metaSwapStorage MetaSwap struct to read from
350      * @return the virtual price, scaled to precision of BASE_VIRTUAL_PRICE_PRECISION
351      */
352     function getVirtualPrice(
353         SwapUtilsV2.Swap storage self,
354         MetaSwap storage metaSwapStorage
355     ) external view returns (uint256) {
356         uint256 d = SwapUtilsV2.getD(
357             _xp(
358                 self.balances,
359                 self.tokenPrecisionMultipliers,
360                 _getBaseVirtualPrice(metaSwapStorage)
361             ),
362             self._getAPrecise()
363         );
364         uint256 supply = self.lpToken.totalSupply();
365         if (supply != 0) {
366             return (d * BASE_VIRTUAL_PRICE_PRECISION) / supply;
367         }
368         return 0;
369     }
370 
371     /**
372      * @notice Externally calculates a swap between two tokens. The SwapUtils.Swap storage and
373      * MetaSwap storage should be from the same MetaSwap contract.
374      * @param self Swap struct to read from
375      * @param metaSwapStorage MetaSwap struct from the same contract
376      * @param tokenIndexFrom the token to sell
377      * @param tokenIndexTo the token to buy
378      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
379      * use the amount that gets transferred after the fee.
380      * @return dy the number of tokens the user will get
381      */
382     function calculateSwap(
383         SwapUtilsV2.Swap storage self,
384         MetaSwap storage metaSwapStorage,
385         uint8 tokenIndexFrom,
386         uint8 tokenIndexTo,
387         uint256 dx
388     ) external view returns (uint256 dy) {
389         (dy, ) = _calculateSwap(
390             self,
391             tokenIndexFrom,
392             tokenIndexTo,
393             dx,
394             _getBaseVirtualPrice(metaSwapStorage)
395         );
396     }
397 
398     /**
399      * @notice Internally calculates a swap between two tokens.
400      *
401      * @dev The caller is expected to transfer the actual amounts (dx and dy)
402      * using the token contracts.
403      *
404      * @param self Swap struct to read from
405      * @param tokenIndexFrom the token to sell
406      * @param tokenIndexTo the token to buy
407      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
408      * use the amount that gets transferred after the fee.
409      * @param baseVirtualPrice the virtual price of the base LP token
410      * @return dy the number of tokens the user will get and dyFee the associated fee
411      */
412     function _calculateSwap(
413         SwapUtilsV2.Swap storage self,
414         uint8 tokenIndexFrom,
415         uint8 tokenIndexTo,
416         uint256 dx,
417         uint256 baseVirtualPrice
418     ) internal view returns (uint256 dy, uint256 dyFee) {
419         uint256[] memory xp = _xp(self, baseVirtualPrice);
420         require(
421             tokenIndexFrom < xp.length && tokenIndexTo < xp.length,
422             "Token index out of range"
423         );
424         uint256 baseLPTokenIndex = xp.length - 1;
425 
426         uint256 x = dx * self.tokenPrecisionMultipliers[tokenIndexFrom];
427         if (tokenIndexFrom == baseLPTokenIndex) {
428             // When swapping from a base Swap token, scale up dx by its virtual price
429             x = (x * baseVirtualPrice) / BASE_VIRTUAL_PRICE_PRECISION;
430         }
431         x = x + xp[tokenIndexFrom];
432 
433         uint256 y = SwapUtilsV2.getY(
434             self._getAPrecise(),
435             tokenIndexFrom,
436             tokenIndexTo,
437             x,
438             xp
439         );
440         dy = xp[tokenIndexTo] - y - 1;
441 
442         if (tokenIndexTo == baseLPTokenIndex) {
443             // When swapping to a base Swap token, scale down dy by its virtual price
444             dy = (dy * BASE_VIRTUAL_PRICE_PRECISION) / baseVirtualPrice;
445         }
446 
447         dyFee = (dy * self.swapFee) / FEE_DENOMINATOR;
448         dy = dy - dyFee;
449 
450         dy = dy / self.tokenPrecisionMultipliers[tokenIndexTo];
451     }
452 
453     /**
454      * @notice Calculates the expected return amount from swapping between
455      * the pooled tokens and the underlying tokens of the base Swap pool.
456      *
457      * @param self Swap struct to read from
458      * @param metaSwapStorage MetaSwap struct from the same contract
459      * @param tokenIndexFrom the token to sell
460      * @param tokenIndexTo the token to buy
461      * @param dx the number of tokens to sell. If the token charges a fee on transfers,
462      * use the amount that gets transferred after the fee.
463      * @return dy the number of tokens the user will get
464      */
465     function calculateSwapUnderlying(
466         SwapUtilsV2.Swap storage self,
467         MetaSwap storage metaSwapStorage,
468         uint8 tokenIndexFrom,
469         uint8 tokenIndexTo,
470         uint256 dx
471     ) external view returns (uint256) {
472         CalculateSwapUnderlyingInfo memory v = CalculateSwapUnderlyingInfo(
473             _getBaseVirtualPrice(metaSwapStorage),
474             metaSwapStorage.baseSwap,
475             0,
476             uint8(metaSwapStorage.baseTokens.length),
477             0,
478             0,
479             0
480         );
481 
482         uint256[] memory xp = _xp(self, v.baseVirtualPrice);
483         v.baseLPTokenIndex = uint8(xp.length - 1);
484         {
485             uint8 maxRange = v.baseLPTokenIndex + v.baseTokensLength;
486             require(
487                 tokenIndexFrom < maxRange && tokenIndexTo < maxRange,
488                 "Token index out of range"
489             );
490         }
491 
492         if (tokenIndexFrom < v.baseLPTokenIndex) {
493             // tokenFrom is from this pool
494             v.x =
495                 xp[tokenIndexFrom] +
496                 (dx * self.tokenPrecisionMultipliers[tokenIndexFrom]);
497         } else {
498             // tokenFrom is from the base pool
499             tokenIndexFrom = tokenIndexFrom - v.baseLPTokenIndex;
500             if (tokenIndexTo < v.baseLPTokenIndex) {
501                 uint256[] memory baseInputs = new uint256[](v.baseTokensLength);
502                 baseInputs[tokenIndexFrom] = dx;
503                 v.x =
504                     (v.baseSwap.calculateTokenAmount(baseInputs, true) *
505                         v.baseVirtualPrice) /
506                     BASE_VIRTUAL_PRICE_PRECISION;
507                 // when adding to the base pool,you pay approx 50% of the swap fee
508                 v.x =
509                     v.x -
510                     ((v.x * _getBaseSwapFee(metaSwapStorage.baseSwap)) /
511                         (FEE_DENOMINATOR * 2)) +
512                     xp[v.baseLPTokenIndex];
513             } else {
514                 // both from and to are from the base pool
515                 return
516                     v.baseSwap.calculateSwap(
517                         tokenIndexFrom,
518                         tokenIndexTo - v.baseLPTokenIndex,
519                         dx
520                     );
521             }
522             tokenIndexFrom = v.baseLPTokenIndex;
523         }
524 
525         v.metaIndexTo = v.baseLPTokenIndex;
526         if (tokenIndexTo < v.baseLPTokenIndex) {
527             v.metaIndexTo = tokenIndexTo;
528         }
529 
530         {
531             uint256 y = SwapUtilsV2.getY(
532                 self._getAPrecise(),
533                 tokenIndexFrom,
534                 v.metaIndexTo,
535                 v.x,
536                 xp
537             );
538             v.dy = xp[v.metaIndexTo] - y - 1;
539             uint256 dyFee = (v.dy * self.swapFee) / FEE_DENOMINATOR;
540             v.dy = v.dy - dyFee;
541         }
542 
543         if (tokenIndexTo < v.baseLPTokenIndex) {
544             // tokenTo is from this pool
545             v.dy = v.dy / self.tokenPrecisionMultipliers[v.metaIndexTo];
546         } else {
547             // tokenTo is from the base pool
548             v.dy = v.baseSwap.calculateRemoveLiquidityOneToken(
549                 (v.dy * BASE_VIRTUAL_PRICE_PRECISION) / v.baseVirtualPrice,
550                 tokenIndexTo - v.baseLPTokenIndex
551             );
552         }
553 
554         return v.dy;
555     }
556 
557     /**
558      * @notice A simple method to calculate prices from deposits or
559      * withdrawals, excluding fees but including slippage. This is
560      * helpful as an input into the various "min" parameters on calls
561      * to fight front-running
562      *
563      * @dev This shouldn't be used outside frontends for user estimates.
564      *
565      * @param self Swap struct to read from
566      * @param metaSwapStorage MetaSwap struct to read from
567      * @param amounts an array of token amounts to deposit or withdrawal,
568      * corresponding to pooledTokens. The amount should be in each
569      * pooled token's native precision. If a token charges a fee on transfers,
570      * use the amount that gets transferred after the fee.
571      * @param deposit whether this is a deposit or a withdrawal
572      * @return if deposit was true, total amount of lp token that will be minted and if
573      * deposit was false, total amount of lp token that will be burned
574      */
575     function calculateTokenAmount(
576         SwapUtilsV2.Swap storage self,
577         MetaSwap storage metaSwapStorage,
578         uint256[] calldata amounts,
579         bool deposit
580     ) external view returns (uint256) {
581         uint256 a = self._getAPrecise();
582         uint256 d0;
583         uint256 d1;
584         {
585             uint256 baseVirtualPrice = _getBaseVirtualPrice(metaSwapStorage);
586             uint256[] memory balances1 = self.balances;
587             uint256[] memory tokenPrecisionMultipliers = self
588                 .tokenPrecisionMultipliers;
589             uint256 numTokens = balances1.length;
590             d0 = SwapUtilsV2.getD(
591                 _xp(balances1, tokenPrecisionMultipliers, baseVirtualPrice),
592                 a
593             );
594             for (uint256 i = 0; i < numTokens; i++) {
595                 if (deposit) {
596                     balances1[i] = balances1[i] + amounts[i];
597                 } else {
598                     if (amounts[i] > balances1[i]) {
599                         revert("Cannot withdraw more than available");
600                     } else {
601                         unchecked {
602                             balances1[i] = balances1[i] - amounts[i];
603                         }
604                     }
605                 }
606             }
607             d1 = SwapUtilsV2.getD(
608                 _xp(balances1, tokenPrecisionMultipliers, baseVirtualPrice),
609                 a
610             );
611         }
612         uint256 totalSupply = self.lpToken.totalSupply();
613 
614         if (deposit) {
615             return ((d1 - d0) * totalSupply) / d0;
616         } else {
617             return ((d0 - d1) * totalSupply) / d0;
618         }
619     }
620 
621     /*** STATE MODIFYING FUNCTIONS ***/
622 
623     /**
624      * @notice swap two tokens in the pool
625      * @param self Swap struct to read from and write to
626      * @param metaSwapStorage MetaSwap struct to read from and write to
627      * @param tokenIndexFrom the token the user wants to sell
628      * @param tokenIndexTo the token the user wants to buy
629      * @param dx the amount of tokens the user wants to sell
630      * @param minDy the min amount the user would like to receive, or revert.
631      * @return amount of token user received on swap
632      */
633     function swap(
634         SwapUtilsV2.Swap storage self,
635         MetaSwap storage metaSwapStorage,
636         uint8 tokenIndexFrom,
637         uint8 tokenIndexTo,
638         uint256 dx,
639         uint256 minDy
640     ) external returns (uint256) {
641         {
642             uint256 pooledTokensLength = self.pooledTokens.length;
643             require(
644                 tokenIndexFrom < pooledTokensLength &&
645                     tokenIndexTo < pooledTokensLength,
646                 "Token index is out of range"
647             );
648         }
649 
650         uint256 transferredDx;
651         {
652             IERC20 tokenFrom = self.pooledTokens[tokenIndexFrom];
653             require(
654                 dx <= tokenFrom.balanceOf(msg.sender),
655                 "Cannot swap more than you own"
656             );
657 
658             {
659                 // Transfer tokens first to see if a fee was charged on transfer
660                 uint256 beforeBalance = tokenFrom.balanceOf(address(this));
661                 tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
662 
663                 // Use the actual transferred amount for AMM math
664                 transferredDx =
665                     tokenFrom.balanceOf(address(this)) -
666                     beforeBalance;
667             }
668         }
669 
670         (uint256 dy, uint256 dyFee) = _calculateSwap(
671             self,
672             tokenIndexFrom,
673             tokenIndexTo,
674             transferredDx,
675             _updateBaseVirtualPrice(metaSwapStorage)
676         );
677         require(dy >= minDy, "Swap didn't result in min tokens");
678 
679         uint256 dyAdminFee = (dyFee * self.adminFee) /
680             FEE_DENOMINATOR /
681             self.tokenPrecisionMultipliers[tokenIndexTo];
682 
683         self.balances[tokenIndexFrom] =
684             self.balances[tokenIndexFrom] +
685             transferredDx;
686         self.balances[tokenIndexTo] =
687             self.balances[tokenIndexTo] -
688             dy -
689             dyAdminFee;
690 
691         self.pooledTokens[tokenIndexTo].safeTransfer(msg.sender, dy);
692 
693         emit TokenSwap(
694             msg.sender,
695             transferredDx,
696             dy,
697             tokenIndexFrom,
698             tokenIndexTo
699         );
700 
701         return dy;
702     }
703 
704     /**
705      * @notice Swaps with the underlying tokens of the base Swap pool. For this function,
706      * the token indices are flattened out so that underlying tokens are represented
707      * in the indices.
708      * @dev Since this calls multiple external functions during the execution,
709      * it is recommended to protect any function that depends on this with reentrancy guards.
710      * @param self Swap struct to read from and write to
711      * @param metaSwapStorage MetaSwap struct to read from and write to
712      * @param tokenIndexFrom the token the user wants to sell
713      * @param tokenIndexTo the token the user wants to buy
714      * @param dx the amount of tokens the user wants to sell
715      * @param minDy the min amount the user would like to receive, or revert.
716      * @return amount of token user received on swap
717      */
718     function swapUnderlying(
719         SwapUtilsV2.Swap storage self,
720         MetaSwap storage metaSwapStorage,
721         uint8 tokenIndexFrom,
722         uint8 tokenIndexTo,
723         uint256 dx,
724         uint256 minDy
725     ) external returns (uint256) {
726         SwapUnderlyingInfo memory v = SwapUnderlyingInfo(
727             0,
728             0,
729             0,
730             self.tokenPrecisionMultipliers,
731             self.balances,
732             metaSwapStorage.baseTokens,
733             IERC20(address(0)),
734             0,
735             IERC20(address(0)),
736             0,
737             _updateBaseVirtualPrice(metaSwapStorage)
738         );
739 
740         uint8 baseLPTokenIndex = uint8(v.oldBalances.length - 1);
741 
742         {
743             uint8 maxRange = uint8(baseLPTokenIndex + v.baseTokens.length);
744             require(
745                 tokenIndexFrom < maxRange && tokenIndexTo < maxRange,
746                 "Token index out of range"
747             );
748         }
749 
750         ISwapV2 baseSwap = metaSwapStorage.baseSwap;
751 
752         // Find the address of the token swapping from and the index in MetaSwap's token list
753         if (tokenIndexFrom < baseLPTokenIndex) {
754             v.tokenFrom = self.pooledTokens[tokenIndexFrom];
755             v.metaIndexFrom = tokenIndexFrom;
756         } else {
757             v.tokenFrom = v.baseTokens[tokenIndexFrom - baseLPTokenIndex];
758             v.metaIndexFrom = baseLPTokenIndex;
759         }
760 
761         // Find the address of the token swapping to and the index in MetaSwap's token list
762         if (tokenIndexTo < baseLPTokenIndex) {
763             v.tokenTo = self.pooledTokens[tokenIndexTo];
764             v.metaIndexTo = tokenIndexTo;
765         } else {
766             v.tokenTo = v.baseTokens[tokenIndexTo - baseLPTokenIndex];
767             v.metaIndexTo = baseLPTokenIndex;
768         }
769 
770         // Check for possible fee on transfer
771         v.dx = v.tokenFrom.balanceOf(address(this));
772         v.tokenFrom.safeTransferFrom(msg.sender, address(this), dx);
773         v.dx = v.tokenFrom.balanceOf(address(this)) - v.dx; // update dx in case of fee on transfer
774 
775         if (
776             tokenIndexFrom < baseLPTokenIndex || tokenIndexTo < baseLPTokenIndex
777         ) {
778             // Either one of the tokens belongs to the MetaSwap tokens list
779             uint256[] memory xp = _xp(
780                 v.oldBalances,
781                 v.tokenPrecisionMultipliers,
782                 v.baseVirtualPrice
783             );
784 
785             if (tokenIndexFrom < baseLPTokenIndex) {
786                 // Swapping from a MetaSwap token
787                 v.x =
788                     xp[tokenIndexFrom] +
789                     (dx * v.tokenPrecisionMultipliers[tokenIndexFrom]);
790             } else {
791                 // Swapping from one of the tokens hosted in the base Swap
792                 // This case requires adding the underlying token to the base Swap, then
793                 // using the base LP token to swap to the desired token
794                 uint256[] memory baseAmounts = new uint256[](
795                     v.baseTokens.length
796                 );
797                 baseAmounts[tokenIndexFrom - baseLPTokenIndex] = v.dx;
798 
799                 // Add liquidity to the base Swap contract and receive base LP token
800                 v.dx = baseSwap.addLiquidity(baseAmounts, 0, block.timestamp);
801 
802                 // Calculate the value of total amount of baseLPToken we end up with
803                 v.x =
804                     ((v.dx * v.baseVirtualPrice) /
805                         BASE_VIRTUAL_PRICE_PRECISION) +
806                     xp[baseLPTokenIndex];
807             }
808 
809             // Calculate how much to withdraw in MetaSwap level and the the associated swap fee
810             uint256 dyFee;
811             {
812                 uint256 y = SwapUtilsV2.getY(
813                     self._getAPrecise(),
814                     v.metaIndexFrom,
815                     v.metaIndexTo,
816                     v.x,
817                     xp
818                 );
819                 v.dy = xp[v.metaIndexTo] - y - 1;
820                 if (tokenIndexTo >= baseLPTokenIndex) {
821                     // When swapping to a base Swap token, scale down dy by its virtual price
822                     v.dy =
823                         (v.dy * BASE_VIRTUAL_PRICE_PRECISION) /
824                         v.baseVirtualPrice;
825                 }
826                 dyFee = (v.dy * self.swapFee) / FEE_DENOMINATOR;
827                 v.dy =
828                     (v.dy - dyFee) /
829                     v.tokenPrecisionMultipliers[v.metaIndexTo];
830             }
831 
832             // Update the balances array according to the calculated input and output amount
833             {
834                 uint256 dyAdminFee = (dyFee * self.adminFee) / FEE_DENOMINATOR;
835                 dyAdminFee =
836                     dyAdminFee /
837                     v.tokenPrecisionMultipliers[v.metaIndexTo];
838                 self.balances[v.metaIndexFrom] =
839                     v.oldBalances[v.metaIndexFrom] +
840                     v.dx;
841                 self.balances[v.metaIndexTo] =
842                     v.oldBalances[v.metaIndexTo] -
843                     v.dy -
844                     dyAdminFee;
845             }
846 
847             if (tokenIndexTo >= baseLPTokenIndex) {
848                 // When swapping to a token that belongs to the base Swap, burn the LP token
849                 // and withdraw the desired token from the base pool
850                 uint256 oldBalance = v.tokenTo.balanceOf(address(this));
851                 baseSwap.removeLiquidityOneToken(
852                     v.dy,
853                     tokenIndexTo - baseLPTokenIndex,
854                     0,
855                     block.timestamp
856                 );
857                 v.dy = v.tokenTo.balanceOf(address(this)) - oldBalance;
858             }
859 
860             // Check the amount of token to send meets minDy
861             require(v.dy >= minDy, "Swap didn't result in min tokens");
862         } else {
863             // Both tokens are from the base Swap pool
864             // Do a swap through the base Swap
865             v.dy = v.tokenTo.balanceOf(address(this));
866             baseSwap.swap(
867                 tokenIndexFrom - baseLPTokenIndex,
868                 tokenIndexTo - baseLPTokenIndex,
869                 v.dx,
870                 minDy,
871                 block.timestamp
872             );
873             v.dy = v.tokenTo.balanceOf(address(this)) - v.dy;
874         }
875 
876         // Send the desired token to the caller
877         v.tokenTo.safeTransfer(msg.sender, v.dy);
878 
879         emit TokenSwapUnderlying(
880             msg.sender,
881             dx,
882             v.dy,
883             tokenIndexFrom,
884             tokenIndexTo
885         );
886 
887         return v.dy;
888     }
889 
890     /**
891      * @notice Add liquidity to the pool
892      * @param self Swap struct to read from and write to
893      * @param metaSwapStorage MetaSwap struct to read from and write to
894      * @param amounts the amounts of each token to add, in their native precision
895      * @param minToMint the minimum LP tokens adding this amount of liquidity
896      * should mint, otherwise revert. Handy for front-running mitigation
897      * allowed addresses. If the pool is not in the guarded launch phase, this parameter will be ignored.
898      * @return amount of LP token user received
899      */
900     function addLiquidity(
901         SwapUtilsV2.Swap storage self,
902         MetaSwap storage metaSwapStorage,
903         uint256[] memory amounts,
904         uint256 minToMint
905     ) external returns (uint256) {
906         IERC20[] memory pooledTokens = self.pooledTokens;
907         require(
908             amounts.length == pooledTokens.length,
909             "Amounts must match pooled tokens"
910         );
911 
912         uint256[] memory fees = new uint256[](pooledTokens.length);
913 
914         // current state
915         ManageLiquidityInfo memory v = ManageLiquidityInfo(
916             0,
917             0,
918             0,
919             self.lpToken,
920             0,
921             self._getAPrecise(),
922             _updateBaseVirtualPrice(metaSwapStorage),
923             self.tokenPrecisionMultipliers,
924             self.balances
925         );
926         v.totalSupply = v.lpToken.totalSupply();
927 
928         if (v.totalSupply != 0) {
929             v.d0 = SwapUtilsV2.getD(
930                 _xp(
931                     v.newBalances,
932                     v.tokenPrecisionMultipliers,
933                     v.baseVirtualPrice
934                 ),
935                 v.preciseA
936             );
937         }
938 
939         for (uint256 i = 0; i < pooledTokens.length; i++) {
940             require(
941                 v.totalSupply != 0 || amounts[i] > 0,
942                 "Must supply all tokens in pool"
943             );
944 
945             // Transfer tokens first to see if a fee was charged on transfer
946             if (amounts[i] != 0) {
947                 uint256 beforeBalance = pooledTokens[i].balanceOf(
948                     address(this)
949                 );
950                 pooledTokens[i].safeTransferFrom(
951                     msg.sender,
952                     address(this),
953                     amounts[i]
954                 );
955 
956                 // Update the amounts[] with actual transfer amount
957                 amounts[i] =
958                     pooledTokens[i].balanceOf(address(this)) -
959                     beforeBalance;
960             }
961 
962             v.newBalances[i] = v.newBalances[i] + amounts[i];
963         }
964 
965         // invariant after change
966         v.d1 = SwapUtilsV2.getD(
967             _xp(v.newBalances, v.tokenPrecisionMultipliers, v.baseVirtualPrice),
968             v.preciseA
969         );
970         require(v.d1 > v.d0, "D should increase");
971 
972         // updated to reflect fees and calculate the user's LP tokens
973         v.d2 = v.d1;
974         uint256 toMint;
975 
976         if (v.totalSupply != 0) {
977             uint256 feePerToken = SwapUtilsV2._feePerToken(
978                 self.swapFee,
979                 pooledTokens.length
980             );
981             for (uint256 i = 0; i < pooledTokens.length; i++) {
982                 uint256 idealBalance = (v.d1 * self.balances[i]) / v.d0;
983                 fees[i] =
984                     (feePerToken *
985                         (idealBalance.difference(v.newBalances[i]))) /
986                     FEE_DENOMINATOR;
987                 self.balances[i] =
988                     v.newBalances[i] -
989                     ((fees[i] * self.adminFee) / FEE_DENOMINATOR);
990                 v.newBalances[i] = v.newBalances[i] - fees[i];
991             }
992             v.d2 = SwapUtilsV2.getD(
993                 _xp(
994                     v.newBalances,
995                     v.tokenPrecisionMultipliers,
996                     v.baseVirtualPrice
997                 ),
998                 v.preciseA
999             );
1000             toMint = ((v.d2 - v.d0) * v.totalSupply) / v.d0;
1001         } else {
1002             // the initial depositor doesn't pay fees
1003             self.balances = v.newBalances;
1004             toMint = v.d1;
1005         }
1006 
1007         require(toMint >= minToMint, "Couldn't mint min requested");
1008 
1009         // mint the user's LP tokens
1010         self.lpToken.mint(msg.sender, toMint);
1011 
1012         emit AddLiquidity(
1013             msg.sender,
1014             amounts,
1015             fees,
1016             v.d1,
1017             v.totalSupply + toMint
1018         );
1019 
1020         return toMint;
1021     }
1022 
1023     /**
1024      * @notice Remove liquidity from the pool all in one token.
1025      * @param self Swap struct to read from and write to
1026      * @param metaSwapStorage MetaSwap struct to read from and write to
1027      * @param tokenAmount the amount of the lp tokens to burn
1028      * @param tokenIndex the index of the token you want to receive
1029      * @param minAmount the minimum amount to withdraw, otherwise revert
1030      * @return amount chosen token that user received
1031      */
1032     function removeLiquidityOneToken(
1033         SwapUtilsV2.Swap storage self,
1034         MetaSwap storage metaSwapStorage,
1035         uint256 tokenAmount,
1036         uint8 tokenIndex,
1037         uint256 minAmount
1038     ) external returns (uint256) {
1039         LPTokenV2 lpToken = self.lpToken;
1040         uint256 totalSupply = lpToken.totalSupply();
1041         uint256 numTokens = self.pooledTokens.length;
1042         require(tokenAmount <= lpToken.balanceOf(msg.sender), ">LP.balanceOf");
1043         require(tokenIndex < numTokens, "Token not found");
1044 
1045         uint256 dyFee;
1046         uint256 dy;
1047 
1048         (dy, dyFee) = _calculateWithdrawOneToken(
1049             self,
1050             tokenAmount,
1051             tokenIndex,
1052             _updateBaseVirtualPrice(metaSwapStorage),
1053             totalSupply
1054         );
1055 
1056         require(dy >= minAmount, "dy < minAmount");
1057 
1058         // Update balances array
1059         self.balances[tokenIndex] =
1060             self.balances[tokenIndex] -
1061             (dy + ((dyFee * self.adminFee) / FEE_DENOMINATOR));
1062 
1063         // Burn the associated LP token from the caller and send the desired token
1064         lpToken.burnFrom(msg.sender, tokenAmount);
1065         self.pooledTokens[tokenIndex].safeTransfer(msg.sender, dy);
1066 
1067         emit RemoveLiquidityOne(
1068             msg.sender,
1069             tokenAmount,
1070             totalSupply,
1071             tokenIndex,
1072             dy
1073         );
1074 
1075         return dy;
1076     }
1077 
1078     /**
1079      * @notice Remove liquidity from the pool, weighted differently than the
1080      * pool's current balances.
1081      *
1082      * @param self Swap struct to read from and write to
1083      * @param metaSwapStorage MetaSwap struct to read from and write to
1084      * @param amounts how much of each token to withdraw
1085      * @param maxBurnAmount the max LP token provider is willing to pay to
1086      * remove liquidity. Useful as a front-running mitigation.
1087      * @return actual amount of LP tokens burned in the withdrawal
1088      */
1089     function removeLiquidityImbalance(
1090         SwapUtilsV2.Swap storage self,
1091         MetaSwap storage metaSwapStorage,
1092         uint256[] memory amounts,
1093         uint256 maxBurnAmount
1094     ) public returns (uint256) {
1095         // Using this struct to avoid stack too deep error
1096         ManageLiquidityInfo memory v = ManageLiquidityInfo(
1097             0,
1098             0,
1099             0,
1100             self.lpToken,
1101             0,
1102             self._getAPrecise(),
1103             _updateBaseVirtualPrice(metaSwapStorage),
1104             self.tokenPrecisionMultipliers,
1105             self.balances
1106         );
1107         v.totalSupply = v.lpToken.totalSupply();
1108 
1109         require(
1110             amounts.length == v.newBalances.length,
1111             "Amounts should match pool tokens"
1112         );
1113         require(maxBurnAmount != 0, "Must burn more than 0");
1114 
1115         uint256 feePerToken = SwapUtilsV2._feePerToken(
1116             self.swapFee,
1117             v.newBalances.length
1118         );
1119 
1120         // Calculate how much LPToken should be burned
1121         uint256[] memory fees = new uint256[](v.newBalances.length);
1122         {
1123             uint256[] memory balances1 = new uint256[](v.newBalances.length);
1124 
1125             v.d0 = SwapUtilsV2.getD(
1126                 _xp(
1127                     v.newBalances,
1128                     v.tokenPrecisionMultipliers,
1129                     v.baseVirtualPrice
1130                 ),
1131                 v.preciseA
1132             );
1133             for (uint256 i = 0; i < v.newBalances.length; i++) {
1134                 if (amounts[i] > v.newBalances[i]) {
1135                     revert("Cannot withdraw more than available");
1136                 } else {
1137                     unchecked {
1138                         balances1[i] = v.newBalances[i] - amounts[i];
1139                     }
1140                 }
1141             }
1142             v.d1 = SwapUtilsV2.getD(
1143                 _xp(balances1, v.tokenPrecisionMultipliers, v.baseVirtualPrice),
1144                 v.preciseA
1145             );
1146 
1147             for (uint256 i = 0; i < v.newBalances.length; i++) {
1148                 uint256 idealBalance = (v.d1 * v.newBalances[i]) / v.d0;
1149                 uint256 difference = idealBalance.difference(balances1[i]);
1150                 fees[i] = (feePerToken * difference) / FEE_DENOMINATOR;
1151                 self.balances[i] =
1152                     balances1[i] -
1153                     ((fees[i] * self.adminFee) / FEE_DENOMINATOR);
1154                 balances1[i] = balances1[i] - fees[i];
1155             }
1156 
1157             v.d2 = SwapUtilsV2.getD(
1158                 _xp(balances1, v.tokenPrecisionMultipliers, v.baseVirtualPrice),
1159                 v.preciseA
1160             );
1161         }
1162 
1163         uint256 tokenAmount = ((v.d0 - v.d2) * v.totalSupply) / v.d0;
1164         require(tokenAmount != 0, "Burnt amount cannot be zero");
1165 
1166         // Scale up by withdraw fee
1167         tokenAmount = tokenAmount + 1;
1168 
1169         // Check for max burn amount
1170         require(tokenAmount <= maxBurnAmount, "tokenAmount > maxBurnAmount");
1171 
1172         // Burn the calculated amount of LPToken from the caller and send the desired tokens
1173         v.lpToken.burnFrom(msg.sender, tokenAmount);
1174         for (uint256 i = 0; i < v.newBalances.length; i++) {
1175             self.pooledTokens[i].safeTransfer(msg.sender, amounts[i]);
1176         }
1177 
1178         emit RemoveLiquidityImbalance(
1179             msg.sender,
1180             amounts,
1181             fees,
1182             v.d1,
1183             v.totalSupply - tokenAmount
1184         );
1185 
1186         return tokenAmount;
1187     }
1188 
1189     /**
1190      * @notice Determines if the stored value of base Swap's virtual price is expired.
1191      * If the last update was past the BASE_CACHE_EXPIRE_TIME, then update the stored value.
1192      *
1193      * @param metaSwapStorage MetaSwap struct to read from and write to
1194      * @return base Swap's virtual price
1195      */
1196     function _updateBaseVirtualPrice(MetaSwap storage metaSwapStorage)
1197         internal
1198         returns (uint256)
1199     {
1200         if (
1201             block.timestamp >
1202             metaSwapStorage.baseCacheLastUpdated + BASE_CACHE_EXPIRE_TIME
1203         ) {
1204             // When the cache is expired, update it
1205             uint256 baseVirtualPrice = ISwapV2(metaSwapStorage.baseSwap)
1206                 .getVirtualPrice();
1207             metaSwapStorage.baseVirtualPrice = baseVirtualPrice;
1208             metaSwapStorage.baseCacheLastUpdated = block.timestamp;
1209             return baseVirtualPrice;
1210         } else {
1211             return metaSwapStorage.baseVirtualPrice;
1212         }
1213     }
1214 }
