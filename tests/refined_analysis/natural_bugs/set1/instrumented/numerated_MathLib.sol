1 //SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.4;
3 
4 import "../contracts/Exchange.sol";
5 
6 /**
7  * @title MathLib
8  * @author ElasticDAO
9  */
10 library MathLib {
11     struct InternalBalances {
12         // x*y=k - we track these internally to compare to actual balances of the ERC20's
13         // in order to calculate the "decay" or the amount of balances that are not
14         // participating in the pricing curve and adding additional liquidity to swap.
15         uint256 baseTokenReserveQty; // x
16         uint256 quoteTokenReserveQty; // y
17         uint256 kLast; // as of the last add / rem liquidity event
18     }
19 
20     // aids in avoiding stack too deep errors.
21     struct TokenQtys {
22         uint256 baseTokenQty;
23         uint256 quoteTokenQty;
24         uint256 liquidityTokenQty;
25         uint256 liquidityTokenFeeQty;
26     }
27 
28     uint256 public constant BASIS_POINTS = 10000;
29     uint256 public constant WAD = 10**18; // represent a decimal with 18 digits of precision
30 
31     /**
32      * @dev divides two float values, required since solidity does not handle
33      * floating point values.
34      *
35      * inspiration: https://github.com/dapphub/ds-math/blob/master/src/math.sol
36      *
37      * NOTE: this rounds to the nearest integer (up or down). For example .666666 would end up
38      * rounding to .66667.
39      *
40      * @return uint256 wad value (decimal with 18 digits of precision)
41      */
42     function wDiv(uint256 a, uint256 b) public pure returns (uint256) {
43         return ((a * WAD) + (b / 2)) / b;
44     }
45 
46     /**
47      * @dev rounds a integer (a) to the nearest n places.
48      * IE roundToNearest(123, 10) would round to the nearest 10th place (120).
49      */
50     function roundToNearest(uint256 a, uint256 n)
51         public
52         pure
53         returns (uint256)
54     {
55         return ((a + (n / 2)) / n) * n;
56     }
57 
58     /**
59      * @dev multiplies two float values, required since solidity does not handle
60      * floating point values
61      *
62      * inspiration: https://github.com/dapphub/ds-math/blob/master/src/math.sol
63      *
64      * @return uint256 wad value (decimal with 18 digits of precision)
65      */
66     function wMul(uint256 a, uint256 b) public pure returns (uint256) {
67         return ((a * b) + (WAD / 2)) / WAD;
68     }
69 
70     /**
71      * @dev calculates an absolute diff between two integers. Basically the solidity
72      * equivalent of Math.abs(a-b);
73      */
74     function diff(uint256 a, uint256 b) public pure returns (uint256) {
75         if (a >= b) {
76             return a - b;
77         }
78         return b - a;
79     }
80 
81     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
82     function sqrt(uint256 y) internal pure returns (uint256 z) {
83         if (y > 3) {
84             z = y;
85             uint256 x = y / 2 + 1;
86             while (x < z) {
87                 z = x;
88                 x = (y / x + x) / 2;
89             }
90         } else if (y != 0) {
91             z = 1;
92         }
93     }
94 
95     /**
96      * @dev defines the amount of decay needed in order for us to require a user to handle the
97      * decay prior to a double asset entry as the equivalent of 1 unit of quote token
98      */
99     function isSufficientDecayPresent(
100         uint256 _baseTokenReserveQty,
101         InternalBalances memory _internalBalances
102     ) public pure returns (bool) {
103         return (wDiv(
104             diff(_baseTokenReserveQty, _internalBalances.baseTokenReserveQty) *
105                 WAD,
106             wDiv(
107                 _internalBalances.baseTokenReserveQty,
108                 _internalBalances.quoteTokenReserveQty
109             )
110         ) >= WAD); // the amount of base token (a) decay is greater than 1 unit of quote token (token b)
111     }
112 
113     /**
114      * @dev used to calculate the qty of token a liquidity provider
115      * must add in order to maintain the current reserve ratios
116      * @param _tokenAQty base or quote token qty to be supplied by the liquidity provider
117      * @param _tokenAReserveQty current reserve qty of the base or quote token (same token as tokenA)
118      * @param _tokenBReserveQty current reserve qty of the other base or quote token (not tokenA)
119      */
120     function calculateQty(
121         uint256 _tokenAQty,
122         uint256 _tokenAReserveQty,
123         uint256 _tokenBReserveQty
124     ) public pure returns (uint256 tokenBQty) {
125         require(_tokenAQty > 0, "MathLib: INSUFFICIENT_QTY");
126         require(
127             _tokenAReserveQty > 0 && _tokenBReserveQty > 0,
128             "MathLib: INSUFFICIENT_LIQUIDITY"
129         );
130         tokenBQty = (_tokenAQty * _tokenBReserveQty) / _tokenAReserveQty;
131     }
132 
133     /**
134      * @dev used to calculate the qty of token a trader will receive (less fees)
135      * given the qty of token A they are providing
136      * @param _tokenASwapQty base or quote token qty to be swapped by the trader
137      * @param _tokenAReserveQty current reserve qty of the base or quote token (same token as tokenA)
138      * @param _tokenBReserveQty current reserve qty of the other base or quote token (not tokenA)
139      * @param _liquidityFeeInBasisPoints fee to liquidity providers represented in basis points
140      */
141     function calculateQtyToReturnAfterFees(
142         uint256 _tokenASwapQty,
143         uint256 _tokenAReserveQty,
144         uint256 _tokenBReserveQty,
145         uint256 _liquidityFeeInBasisPoints
146     ) public pure returns (uint256 qtyToReturn) {
147         uint256 tokenASwapQtyLessFee =
148             _tokenASwapQty * (BASIS_POINTS - _liquidityFeeInBasisPoints);
149         qtyToReturn =
150             (tokenASwapQtyLessFee * _tokenBReserveQty) /
151             ((_tokenAReserveQty * BASIS_POINTS) + tokenASwapQtyLessFee);
152     }
153 
154     /**
155      * @dev used to calculate the qty of liquidity tokens (deltaRo) we will be issued to a supplier
156      * of a single asset entry when decay is present.
157      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
158      * @param _tokenQtyAToAdd the amount of tokens being added by the caller to remove the current decay
159      * @param _internalTokenAReserveQty the internal balance (X or Y) of token A as a result of this transaction
160      * @param _tokenBDecayChange the change that will occur in the decay in the opposite token as a result of
161      * this transaction
162      * @param _tokenBDecay the amount of decay in tokenB
163      *
164      * @return liquidityTokenQty qty of liquidity tokens to be issued in exchange
165      */
166     function calculateLiquidityTokenQtyForSingleAssetEntry(
167         uint256 _totalSupplyOfLiquidityTokens,
168         uint256 _tokenQtyAToAdd,
169         uint256 _internalTokenAReserveQty,
170         uint256 _tokenBDecayChange,
171         uint256 _tokenBDecay
172     ) public pure returns (uint256 liquidityTokenQty) {
173         // gamma = deltaY / Y' / 2 * (deltaX / alphaDecay')
174         uint256 wGamma =
175             wDiv(
176                 (
177                     wMul(
178                         wDiv(_tokenQtyAToAdd, _internalTokenAReserveQty),
179                         _tokenBDecayChange * WAD
180                     )
181                 ),
182                 _tokenBDecay
183             ) /
184                 WAD /
185                 2;
186 
187         liquidityTokenQty =
188             wDiv(
189                 wMul(_totalSupplyOfLiquidityTokens * WAD, wGamma),
190                 WAD - wGamma
191             ) /
192             WAD;
193     }
194 
195     /**
196      * @dev used to calculate the qty of liquidity tokens (deltaRo) we will be issued to a supplier
197      * of a single asset entry when decay is present.
198      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
199      * @param _quoteTokenQty the amount of quote token the user it adding to the pool (deltaB or deltaY)
200      * @param _quoteTokenReserveBalance the total balance (external) of quote tokens in our pool (Beta)
201      *
202      * @return liquidityTokenQty qty of liquidity tokens to be issued in exchange
203      */
204     function calculateLiquidityTokenQtyForDoubleAssetEntry(
205         uint256 _totalSupplyOfLiquidityTokens,
206         uint256 _quoteTokenQty,
207         uint256 _quoteTokenReserveBalance
208     ) public pure returns (uint256 liquidityTokenQty) {
209         liquidityTokenQty =
210             (_quoteTokenQty * _totalSupplyOfLiquidityTokens) /
211             _quoteTokenReserveBalance;
212     }
213 
214     /**
215      * @dev used to calculate the qty of quote token required and liquidity tokens (deltaRo) to be issued
216      * in order to add liquidity and remove base token decay.
217      * @param _quoteTokenQtyDesired the amount of quote token the user wants to contribute
218      * @param _quoteTokenQtyMin the minimum amount of quote token the user wants to contribute (allows for slippage)
219      * @param _baseTokenReserveQty the external base token reserve qty prior to this transaction
220      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
221      * @param _internalBalances internal balances struct from our exchange's internal accounting
222      *
223      *
224      * @return quoteTokenQty qty of quote token the user must supply
225      * @return liquidityTokenQty qty of liquidity tokens to be issued in exchange
226      */
227     function calculateAddQuoteTokenLiquidityQuantities(
228         uint256 _quoteTokenQtyDesired,
229         uint256 _quoteTokenQtyMin,
230         uint256 _baseTokenReserveQty,
231         uint256 _totalSupplyOfLiquidityTokens,
232         InternalBalances storage _internalBalances
233     ) public returns (uint256 quoteTokenQty, uint256 liquidityTokenQty) {
234         uint256 baseTokenDecay =
235             _baseTokenReserveQty - _internalBalances.baseTokenReserveQty;
236 
237         // determine max amount of quote token that can be added to offset the current decay
238         uint256 wInternalBaseTokenToQuoteTokenRatio =
239             wDiv(
240                 _internalBalances.baseTokenReserveQty,
241                 _internalBalances.quoteTokenReserveQty
242             );
243 
244         // alphaDecay / omega (A/B)
245         uint256 maxQuoteTokenQty =
246             wDiv(baseTokenDecay, wInternalBaseTokenToQuoteTokenRatio);
247 
248         require(
249             _quoteTokenQtyMin < maxQuoteTokenQty,
250             "MathLib: INSUFFICIENT_DECAY"
251         );
252 
253         if (_quoteTokenQtyDesired > maxQuoteTokenQty) {
254             quoteTokenQty = maxQuoteTokenQty;
255         } else {
256             quoteTokenQty = _quoteTokenQtyDesired;
257         }
258 
259         uint256 baseTokenQtyDecayChange =
260             roundToNearest(
261                 (quoteTokenQty * wInternalBaseTokenToQuoteTokenRatio),
262                 WAD
263             ) / WAD;
264 
265         require(
266             baseTokenQtyDecayChange > 0,
267             "MathLib: INSUFFICIENT_CHANGE_IN_DECAY"
268         );
269         //x += alphaDecayChange
270         //y += deltaBeta
271         _internalBalances.baseTokenReserveQty += baseTokenQtyDecayChange;
272         _internalBalances.quoteTokenReserveQty += quoteTokenQty;
273 
274         // calculate the number of liquidity tokens to return to user using
275         liquidityTokenQty = calculateLiquidityTokenQtyForSingleAssetEntry(
276             _totalSupplyOfLiquidityTokens,
277             quoteTokenQty,
278             _internalBalances.quoteTokenReserveQty,
279             baseTokenQtyDecayChange,
280             baseTokenDecay
281         );
282         return (quoteTokenQty, liquidityTokenQty);
283     }
284 
285     /**
286      * @dev used to calculate the qty of base tokens required and liquidity tokens (deltaRo) to be issued
287      * in order to add liquidity and remove base token decay.
288      * @param _baseTokenQtyDesired the amount of base token the user wants to contribute
289      * @param _baseTokenQtyMin the minimum amount of base token the user wants to contribute (allows for slippage)
290      * @param _baseTokenReserveQty the external base token reserve qty prior to this transaction
291      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
292      * @param _internalBalances internal balances struct from our exchange's internal accounting
293      *
294      * @return baseTokenQty qty of base token the user must supply
295      * @return liquidityTokenQty qty of liquidity tokens to be issued in exchange
296      */
297     function calculateAddBaseTokenLiquidityQuantities(
298         uint256 _baseTokenQtyDesired,
299         uint256 _baseTokenQtyMin,
300         uint256 _baseTokenReserveQty,
301         uint256 _totalSupplyOfLiquidityTokens,
302         InternalBalances memory _internalBalances
303     ) public pure returns (uint256 baseTokenQty, uint256 liquidityTokenQty) {
304         uint256 maxBaseTokenQty =
305             _internalBalances.baseTokenReserveQty - _baseTokenReserveQty;
306         require(
307             _baseTokenQtyMin < maxBaseTokenQty,
308             "MathLib: INSUFFICIENT_DECAY"
309         );
310 
311         if (_baseTokenQtyDesired > maxBaseTokenQty) {
312             baseTokenQty = maxBaseTokenQty;
313         } else {
314             baseTokenQty = _baseTokenQtyDesired;
315         }
316 
317         // determine the quote token qty decay change quoted on our current ratios
318         uint256 wInternalQuoteToBaseTokenRatio =
319             wDiv(
320                 _internalBalances.quoteTokenReserveQty,
321                 _internalBalances.baseTokenReserveQty
322             );
323 
324         // NOTE we need this function to use the same
325         // rounding scheme as wDiv in order to avoid a case
326         // in which a user is trying to resolve decay in which
327         // quoteTokenQtyDecayChange ends up being 0 and we are stuck in
328         // a bad state.
329         uint256 quoteTokenQtyDecayChange =
330             roundToNearest(
331                 (baseTokenQty * wInternalQuoteToBaseTokenRatio),
332                 MathLib.WAD
333             ) / WAD;
334 
335         require(
336             quoteTokenQtyDecayChange > 0,
337             "MathLib: INSUFFICIENT_CHANGE_IN_DECAY"
338         );
339 
340         // we can now calculate the total amount of quote token decay
341         uint256 quoteTokenDecay =
342             (maxBaseTokenQty * wInternalQuoteToBaseTokenRatio) / WAD;
343 
344         // this may be redundant quoted on the above math, but will check to ensure the decay wasn't so small
345         // that it was <1 and rounded down to 0 saving the caller some gas
346         // also could fix a potential revert due to div by zero.
347         require(quoteTokenDecay > 0, "MathLib: NO_QUOTE_DECAY");
348 
349         // we are not changing anything about our internal accounting here. We are simply adding tokens
350         // to make our internal account "right"...or rather getting the external balances to match our internal
351         // quoteTokenReserveQty += quoteTokenQtyDecayChange;
352         // baseTokenReserveQty += baseTokenQty;
353 
354         // calculate the number of liquidity tokens to return to user using:
355         liquidityTokenQty = calculateLiquidityTokenQtyForSingleAssetEntry(
356             _totalSupplyOfLiquidityTokens,
357             baseTokenQty,
358             _internalBalances.baseTokenReserveQty,
359             quoteTokenQtyDecayChange,
360             quoteTokenDecay
361         );
362         return (baseTokenQty, liquidityTokenQty);
363     }
364 
365     /**
366      * @dev used to calculate the qty of tokens a user will need to contribute and be issued in order to add liquidity
367      * @param _baseTokenQtyDesired the amount of base token the user wants to contribute
368      * @param _quoteTokenQtyDesired the amount of quote token the user wants to contribute
369      * @param _baseTokenQtyMin the minimum amount of base token the user wants to contribute (allows for slippage)
370      * @param _quoteTokenQtyMin the minimum amount of quote token the user wants to contribute (allows for slippage)
371      * @param _baseTokenReserveQty the external base token reserve qty prior to this transaction
372      * @param _quoteTokenReserveQty the external quote token reserve qty prior to this transaction
373      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
374      * @param _internalBalances internal balances struct from our exchange's internal accounting
375      *
376      * @return tokenQtys qty of tokens needed to complete transaction 
377      */
378     function calculateAddLiquidityQuantities(
379         uint256 _baseTokenQtyDesired,
380         uint256 _quoteTokenQtyDesired,
381         uint256 _baseTokenQtyMin,
382         uint256 _quoteTokenQtyMin,
383         uint256 _baseTokenReserveQty,
384         uint256 _quoteTokenReserveQty,
385         uint256 _totalSupplyOfLiquidityTokens,
386         InternalBalances storage _internalBalances
387     ) public returns (TokenQtys memory tokenQtys) {
388         if (_totalSupplyOfLiquidityTokens > 0) {
389             // we have outstanding liquidity tokens present and an existing price curve
390 
391             tokenQtys.liquidityTokenFeeQty = calculateLiquidityTokenFees(
392                 _totalSupplyOfLiquidityTokens,
393                 _internalBalances
394             );
395 
396             // we need to take this amount (that will be minted) into account for below calculations
397             _totalSupplyOfLiquidityTokens += tokenQtys.liquidityTokenFeeQty;
398 
399             // confirm that we have no beta or alpha decay present
400             // if we do, we need to resolve that first
401             if (
402                 isSufficientDecayPresent(
403                     _baseTokenReserveQty,
404                     _internalBalances
405                 )
406             ) {
407                 // decay is present and needs to be dealt with by the caller.
408 
409                 uint256 baseTokenQtyFromDecay;
410                 uint256 quoteTokenQtyFromDecay;
411                 uint256 liquidityTokenQtyFromDecay;
412 
413                 if (
414                     _baseTokenReserveQty > _internalBalances.baseTokenReserveQty
415                 ) {
416                     // we have more base token than expected (base token decay) due to rebase up
417                     // we first need to handle this situation by requiring this user
418                     // to add quote tokens
419                     (
420                         quoteTokenQtyFromDecay,
421                         liquidityTokenQtyFromDecay
422                     ) = calculateAddQuoteTokenLiquidityQuantities(
423                         _quoteTokenQtyDesired,
424                         0, // there is no minimum for this particular call since we may use quote tokens later.
425                         _baseTokenReserveQty,
426                         _totalSupplyOfLiquidityTokens,
427                         _internalBalances
428                     );
429                 } else {
430                     // we have less base token than expected (quote token decay) due to a rebase down
431                     // we first need to handle this by adding base tokens to offset this.
432                     (
433                         baseTokenQtyFromDecay,
434                         liquidityTokenQtyFromDecay
435                     ) = calculateAddBaseTokenLiquidityQuantities(
436                         _baseTokenQtyDesired,
437                         0, // there is no minimum for this particular call since we may use base tokens later.
438                         _baseTokenReserveQty,
439                         _totalSupplyOfLiquidityTokens,
440                         _internalBalances
441                     );
442                 }
443 
444                 if (
445                     quoteTokenQtyFromDecay < _quoteTokenQtyDesired &&
446                     baseTokenQtyFromDecay < _baseTokenQtyDesired
447                 ) {
448                     // the user still has qty that they desire to contribute to the exchange for liquidity
449                     (
450                         tokenQtys.baseTokenQty,
451                         tokenQtys.quoteTokenQty,
452                         tokenQtys.liquidityTokenQty
453                     ) = calculateAddTokenPairLiquidityQuantities(
454                         _baseTokenQtyDesired - baseTokenQtyFromDecay, // safe from underflow quoted on above IF
455                         _quoteTokenQtyDesired - quoteTokenQtyFromDecay, // safe from underflow quoted on above IF
456                         0, // we will check minimums below
457                         0, // we will check minimums below
458                         _quoteTokenReserveQty + quoteTokenQtyFromDecay,
459                         _totalSupplyOfLiquidityTokens +
460                             liquidityTokenQtyFromDecay,
461                         _internalBalances // NOTE: these balances have already been updated when we did the decay math.
462                     );
463                 }
464                 tokenQtys.baseTokenQty += baseTokenQtyFromDecay;
465                 tokenQtys.quoteTokenQty += quoteTokenQtyFromDecay;
466                 tokenQtys.liquidityTokenQty += liquidityTokenQtyFromDecay;
467 
468                 require(
469                     tokenQtys.baseTokenQty >= _baseTokenQtyMin,
470                     "MathLib: INSUFFICIENT_BASE_QTY"
471                 );
472 
473                 require(
474                     tokenQtys.quoteTokenQty >= _quoteTokenQtyMin,
475                     "MathLib: INSUFFICIENT_QUOTE_QTY"
476                 );
477             } else {
478                 // the user is just doing a simple double asset entry / providing both base and quote.
479                 (
480                     tokenQtys.baseTokenQty,
481                     tokenQtys.quoteTokenQty,
482                     tokenQtys.liquidityTokenQty
483                 ) = calculateAddTokenPairLiquidityQuantities(
484                     _baseTokenQtyDesired,
485                     _quoteTokenQtyDesired,
486                     _baseTokenQtyMin,
487                     _quoteTokenQtyMin,
488                     _quoteTokenReserveQty,
489                     _totalSupplyOfLiquidityTokens,
490                     _internalBalances
491                 );
492             }
493         } else {
494             // this user will set the initial pricing curve
495             require(
496                 _baseTokenQtyDesired > 0,
497                 "MathLib: INSUFFICIENT_BASE_QTY_DESIRED"
498             );
499             require(
500                 _quoteTokenQtyDesired > 0,
501                 "MathLib: INSUFFICIENT_QUOTE_QTY_DESIRED"
502             );
503 
504             tokenQtys.baseTokenQty = _baseTokenQtyDesired;
505             tokenQtys.quoteTokenQty = _quoteTokenQtyDesired;
506             tokenQtys.liquidityTokenQty = sqrt(
507                 _baseTokenQtyDesired * _quoteTokenQtyDesired
508             );
509 
510             _internalBalances.baseTokenReserveQty += tokenQtys.baseTokenQty;
511             _internalBalances.quoteTokenReserveQty += tokenQtys.quoteTokenQty;
512         }
513     }
514 
515     /**
516      * @dev calculates the qty of base and quote tokens required and liquidity tokens (deltaRo) to be issued
517      * in order to add liquidity when no decay is present.
518      * @param _baseTokenQtyDesired the amount of base token the user wants to contribute
519      * @param _quoteTokenQtyDesired the amount of quote token the user wants to contribute
520      * @param _baseTokenQtyMin the minimum amount of base token the user wants to contribute (allows for slippage)
521      * @param _quoteTokenQtyMin the minimum amount of quote token the user wants to contribute (allows for slippage)
522      * @param _quoteTokenReserveQty the external quote token reserve qty prior to this transaction
523      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
524      * @param _internalBalances internal balances struct from our exchange's internal accounting
525      *
526      * @return baseTokenQty qty of base token the user must supply
527      * @return quoteTokenQty qty of quote token the user must supply
528      * @return liquidityTokenQty qty of liquidity tokens to be issued in exchange
529      */
530     function calculateAddTokenPairLiquidityQuantities(
531         uint256 _baseTokenQtyDesired,
532         uint256 _quoteTokenQtyDesired,
533         uint256 _baseTokenQtyMin,
534         uint256 _quoteTokenQtyMin,
535         uint256 _quoteTokenReserveQty,
536         uint256 _totalSupplyOfLiquidityTokens,
537         InternalBalances storage _internalBalances
538     )
539         public
540         returns (
541             uint256 baseTokenQty,
542             uint256 quoteTokenQty,
543             uint256 liquidityTokenQty
544         )
545     {
546         uint256 requiredQuoteTokenQty =
547             calculateQty(
548                 _baseTokenQtyDesired,
549                 _internalBalances.baseTokenReserveQty,
550                 _internalBalances.quoteTokenReserveQty
551             );
552 
553         if (requiredQuoteTokenQty <= _quoteTokenQtyDesired) {
554             // user has to provide less than their desired amount
555             require(
556                 requiredQuoteTokenQty >= _quoteTokenQtyMin,
557                 "MathLib: INSUFFICIENT_QUOTE_QTY"
558             );
559             baseTokenQty = _baseTokenQtyDesired;
560             quoteTokenQty = requiredQuoteTokenQty;
561         } else {
562             // we need to check the opposite way.
563             uint256 requiredBaseTokenQty =
564                 calculateQty(
565                     _quoteTokenQtyDesired,
566                     _internalBalances.quoteTokenReserveQty,
567                     _internalBalances.baseTokenReserveQty
568                 );
569 
570             require(
571                 requiredBaseTokenQty >= _baseTokenQtyMin,
572                 "MathLib: INSUFFICIENT_BASE_QTY"
573             );
574             baseTokenQty = requiredBaseTokenQty;
575             quoteTokenQty = _quoteTokenQtyDesired;
576         }
577 
578         liquidityTokenQty = calculateLiquidityTokenQtyForDoubleAssetEntry(
579             _totalSupplyOfLiquidityTokens,
580             quoteTokenQty,
581             _quoteTokenReserveQty
582         );
583 
584         _internalBalances.baseTokenReserveQty += baseTokenQty;
585         _internalBalances.quoteTokenReserveQty += quoteTokenQty;
586     }
587 
588     /**
589      * @dev calculates the qty of base tokens a user will receive for swapping their quote tokens (less fees)
590      * @param _quoteTokenQty the amount of quote tokens the user wants to swap
591      * @param _baseTokenQtyMin the minimum about of base tokens they are willing to receive in return (slippage)
592      * @param _baseTokenReserveQty the external base token reserve qty prior to this transaction
593      * @param _liquidityFeeInBasisPoints the current total liquidity fee represented as an integer of basis points
594      * @param _internalBalances internal balances struct from our exchange's internal accounting
595      *
596      * @return baseTokenQty qty of base token the user will receive back
597      */
598     function calculateBaseTokenQty(
599         uint256 _quoteTokenQty,
600         uint256 _baseTokenQtyMin,
601         uint256 _baseTokenReserveQty,
602         uint256 _liquidityFeeInBasisPoints,
603         InternalBalances storage _internalBalances
604     ) public returns (uint256 baseTokenQty) {
605         require(
606             _baseTokenReserveQty > 0 &&
607                 _internalBalances.baseTokenReserveQty > 0,
608             "MathLib: INSUFFICIENT_BASE_TOKEN_QTY"
609         );
610 
611         // check to see if we have experience quote token decay / a rebase down event
612         if (_baseTokenReserveQty < _internalBalances.baseTokenReserveQty) {
613             // we have less reserves than our current price curve will expect, we need to adjust the curve
614             uint256 wPricingRatio =
615                 wDiv(
616                     _internalBalances.baseTokenReserveQty,
617                     _internalBalances.quoteTokenReserveQty
618                 ); // omega
619 
620             uint256 impliedQuoteTokenQty =
621                 wDiv(_baseTokenReserveQty, wPricingRatio); // no need to divide by WAD, wPricingRatio is already a WAD.
622 
623             baseTokenQty = calculateQtyToReturnAfterFees(
624                 _quoteTokenQty,
625                 impliedQuoteTokenQty,
626                 _baseTokenReserveQty, // use the actual balance here since we adjusted the quote token to match ratio!
627                 _liquidityFeeInBasisPoints
628             );
629         } else {
630             // we have the same or more reserves, no need to alter the curve.
631             baseTokenQty = calculateQtyToReturnAfterFees(
632                 _quoteTokenQty,
633                 _internalBalances.quoteTokenReserveQty,
634                 _internalBalances.baseTokenReserveQty,
635                 _liquidityFeeInBasisPoints
636             );
637         }
638 
639         require(
640             baseTokenQty > _baseTokenQtyMin,
641             "MathLib: INSUFFICIENT_BASE_TOKEN_QTY"
642         );
643 
644         _internalBalances.baseTokenReserveQty -= baseTokenQty;
645         _internalBalances.quoteTokenReserveQty += _quoteTokenQty;
646     }
647 
648     /**
649      * @dev calculates the qty of quote tokens a user will receive for swapping their base tokens (less fees)
650      * @param _baseTokenQty the amount of bases tokens the user wants to swap
651      * @param _quoteTokenQtyMin the minimum about of quote tokens they are willing to receive in return (slippage)
652      * @param _liquidityFeeInBasisPoints the current total liquidity fee represented as an integer of basis points
653      * @param _internalBalances internal balances struct from our exchange's internal accounting
654      *
655      * @return quoteTokenQty qty of quote token the user will receive back
656      */
657     function calculateQuoteTokenQty(
658         uint256 _baseTokenQty,
659         uint256 _quoteTokenQtyMin,
660         uint256 _liquidityFeeInBasisPoints,
661         InternalBalances storage _internalBalances
662     ) public returns (uint256 quoteTokenQty) {
663         require(
664             _baseTokenQty > 0 && _quoteTokenQtyMin > 0,
665             "MathLib: INSUFFICIENT_TOKEN_QTY"
666         );
667 
668         quoteTokenQty = calculateQtyToReturnAfterFees(
669             _baseTokenQty,
670             _internalBalances.baseTokenReserveQty,
671             _internalBalances.quoteTokenReserveQty,
672             _liquidityFeeInBasisPoints
673         );
674 
675         require(
676             quoteTokenQty > _quoteTokenQtyMin,
677             "MathLib: INSUFFICIENT_QUOTE_TOKEN_QTY"
678         );
679 
680         _internalBalances.baseTokenReserveQty += _baseTokenQty;
681         _internalBalances.quoteTokenReserveQty -= quoteTokenQty;
682     }
683 
684     /**
685      * @dev calculates the qty of liquidity tokens that should be sent to the DAO due to the growth in K from trading.
686      * The DAO takes 1/6 of the total fees (30BP total fee, 25 BP to lps and 5 BP to the DAO)
687      * @param _totalSupplyOfLiquidityTokens the total supply of our exchange's liquidity tokens (aka Ro)
688      * @param _internalBalances internal balances struct from our exchange's internal accounting
689      *
690      * @return liquidityTokenFeeQty qty of tokens to be minted to the fee address for the growth in K
691      */
692     function calculateLiquidityTokenFees(
693         uint256 _totalSupplyOfLiquidityTokens,
694         InternalBalances memory _internalBalances
695     ) public pure returns (uint256 liquidityTokenFeeQty) {
696         uint256 rootK =
697             sqrt(
698                 _internalBalances.baseTokenReserveQty *
699                     _internalBalances.quoteTokenReserveQty
700             );
701         uint256 rootKLast = sqrt(_internalBalances.kLast);
702         if (rootK > rootKLast) {
703             uint256 numerator =
704                 _totalSupplyOfLiquidityTokens * (rootK - rootKLast);
705             uint256 denominator = (rootK * 5) + rootKLast;
706             liquidityTokenFeeQty = numerator / denominator;
707         }
708     }
709 }
