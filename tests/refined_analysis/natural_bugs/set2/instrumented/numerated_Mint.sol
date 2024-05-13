1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from '../interfaces/IWETH.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {IMint} from '../interfaces/IMint.sol';
10 import {MintMath} from './MintMath.sol';
11 import {Deploy} from './Deploy.sol';
12 import {MsgValue} from './MsgValue.sol';
13 import {ETH} from './ETH.sol';
14 
15 library Mint {
16     using MintMath for IPair;
17     using Deploy for IConvenience.Native;
18 
19     function newLiquidity(
20         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
21         IConvenience convenience,
22         IFactory factory,
23         IMint.NewLiquidity calldata params
24     )
25         external
26         returns (
27             uint256 assetIn,
28             uint256 liquidityOut,
29             uint256 id,
30             IPair.Due memory dueOut
31         )
32     {
33         (assetIn, liquidityOut, id, dueOut) = _newLiquidity(
34             natives,
35             IMint._NewLiquidity(
36                 convenience,
37                 factory,
38                 params.asset,
39                 params.collateral,
40                 params.maturity,
41                 msg.sender,
42                 msg.sender,
43                 params.liquidityTo,
44                 params.dueTo,
45                 params.assetIn,
46                 params.debtIn,
47                 params.collateralIn,
48                 params.deadline
49             )
50         );
51     }
52 
53     function newLiquidityETHAsset(
54         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
55         IConvenience convenience,
56         IFactory factory,
57         IWETH weth,
58         IMint.NewLiquidityETHAsset calldata params
59     )
60         external
61         returns (
62             uint256 assetIn,
63             uint256 liquidityOut,
64             uint256 id,
65             IPair.Due memory dueOut
66         )
67     {
68         uint112 assetInETH = MsgValue.getUint112();
69 
70         (assetIn, liquidityOut, id, dueOut) = _newLiquidity(
71             natives,
72             IMint._NewLiquidity(
73                 convenience,
74                 factory,
75                 weth,
76                 params.collateral,
77                 params.maturity,
78                 address(this),
79                 msg.sender,
80                 params.liquidityTo,
81                 params.dueTo,
82                 assetInETH,
83                 params.debtIn,
84                 params.collateralIn,
85                 params.deadline
86             )
87         );
88     }
89 
90     function newLiquidityETHCollateral(
91         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
92         IConvenience convenience,
93         IFactory factory,
94         IWETH weth,
95         IMint.NewLiquidityETHCollateral calldata params
96     )
97         external
98         returns (
99             uint256 assetIn,
100             uint256 liquidityOut,
101             uint256 id,
102             IPair.Due memory dueOut
103         )
104     {
105         uint112 collateralIn = MsgValue.getUint112();
106 
107         (assetIn, liquidityOut, id, dueOut) = _newLiquidity(
108             natives,
109             IMint._NewLiquidity(
110                 convenience,
111                 factory,
112                 params.asset,
113                 weth,
114                 params.maturity,
115                 msg.sender,
116                 address(this),
117                 params.liquidityTo,
118                 params.dueTo,
119                 params.assetIn,
120                 params.debtIn,
121                 collateralIn,
122                 params.deadline
123             )
124         );
125     }
126 
127     function liquidityGivenAsset(
128         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
129         IConvenience convenience,
130         IFactory factory,
131         IMint.LiquidityGivenAsset calldata params
132     )
133         external
134         returns (
135             uint256 assetIn,
136             uint256 liquidityOut,
137             uint256 id,
138             IPair.Due memory dueOut
139         )
140     {
141         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenAsset(
142             natives,
143             IMint._LiquidityGivenAsset(
144                 convenience,
145                 factory,
146                 params.asset,
147                 params.collateral,
148                 params.maturity,
149                 msg.sender,
150                 msg.sender,
151                 params.liquidityTo,
152                 params.dueTo,
153                 params.assetIn,
154                 params.minLiquidity,
155                 params.maxDebt,
156                 params.maxCollateral,
157                 params.deadline
158             )
159         );
160     }
161 
162     function liquidityGivenAssetETHAsset(
163         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
164         IConvenience convenience,
165         IFactory factory,
166         IWETH weth,
167         IMint.LiquidityGivenAssetETHAsset calldata params
168     )
169         external
170         returns (
171             uint256 assetIn,
172             uint256 liquidityOut,
173             uint256 id,
174             IPair.Due memory dueOut
175         )
176     {
177         uint112 assetInETH = MsgValue.getUint112();
178 
179         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenAsset(
180             natives,
181             IMint._LiquidityGivenAsset(
182                 convenience,
183                 factory,
184                 weth,
185                 params.collateral,
186                 params.maturity,
187                 address(this),
188                 msg.sender,
189                 params.liquidityTo,
190                 params.dueTo,
191                 assetInETH,
192                 params.minLiquidity,
193                 params.maxDebt,
194                 params.maxCollateral,
195                 params.deadline
196             )
197         );
198     }
199 
200     function liquidityGivenAssetETHCollateral(
201         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
202         IConvenience convenience,
203         IFactory factory,
204         IWETH weth,
205         IMint.LiquidityGivenAssetETHCollateral calldata params
206     )
207         external
208         returns (
209             uint256 assetIn,
210             uint256 liquidityOut,
211             uint256 id,
212             IPair.Due memory dueOut
213         )
214     {
215         uint112 maxCollateral = MsgValue.getUint112();
216 
217         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenAsset(
218             natives,
219             IMint._LiquidityGivenAsset(
220                 convenience,
221                 factory,
222                 params.asset,
223                 weth,
224                 params.maturity,
225                 msg.sender,
226                 address(this),
227                 params.liquidityTo,
228                 params.dueTo,
229                 params.assetIn,
230                 params.minLiquidity,
231                 params.maxDebt,
232                 maxCollateral,
233                 params.deadline
234             )
235         );
236 
237         if (maxCollateral > dueOut.collateral) {
238             uint256 excess = maxCollateral;
239             unchecked {
240                 excess -= dueOut.collateral;
241             }
242             ETH.transfer(payable(msg.sender), excess);
243         }
244     }
245 
246     function liquidityGivenDebt(
247         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
248         IConvenience convenience,
249         IFactory factory,
250         IMint.LiquidityGivenDebt memory params
251     )
252         external
253         returns (
254             uint256 assetIn,
255             uint256 liquidityOut,
256             uint256 id,
257             IPair.Due memory dueOut
258         )
259     {
260         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenDebt(
261             natives,
262             IMint._LiquidityGivenDebt(
263                 convenience,
264                 factory,
265                 params.asset,
266                 params.collateral,
267                 params.maturity,
268                 msg.sender,
269                 msg.sender,
270                 params.liquidityTo,
271                 params.dueTo,
272                 params.debtIn,
273                 params.minLiquidity,
274                 params.maxAsset,
275                 params.maxCollateral,
276                 params.deadline
277             )
278         );
279     }
280 
281     function liquidityGivenDebtETHAsset(
282         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
283         IConvenience convenience,
284         IFactory factory,
285         IWETH weth,
286         IMint.LiquidityGivenDebtETHAsset memory params
287     )
288         external
289         returns (
290             uint256 assetIn,
291             uint256 liquidityOut,
292             uint256 id,
293             IPair.Due memory dueOut
294         )
295     {
296         uint112 maxAsset = MsgValue.getUint112();
297 
298         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenDebt(
299             natives,
300             IMint._LiquidityGivenDebt(
301                 convenience,
302                 factory,
303                 weth,
304                 params.collateral,
305                 params.maturity,
306                 msg.sender,
307                 msg.sender,
308                 params.liquidityTo,
309                 params.dueTo,
310                 params.debtIn,
311                 params.minLiquidity,
312                 maxAsset,
313                 params.maxCollateral,
314                 params.deadline
315             )
316         );
317 
318         if (maxAsset > assetIn) {
319             uint256 excess = maxAsset;
320             unchecked {
321                 excess -= assetIn;
322             }
323             ETH.transfer(payable(msg.sender), excess);
324         }
325     }
326 
327     function liquidityGivenDebtETHCollateral(
328         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
329         IConvenience convenience,
330         IFactory factory,
331         IWETH weth,
332         IMint.LiquidityGivenDebtETHCollateral memory params
333     )
334         external
335         returns (
336             uint256 assetIn,
337             uint256 liquidityOut,
338             uint256 id,
339             IPair.Due memory dueOut
340         )
341     {
342         uint112 maxCollateral = MsgValue.getUint112();
343 
344         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenDebt(
345             natives,
346             IMint._LiquidityGivenDebt(
347                 convenience,
348                 factory,
349                 params.asset,
350                 weth,
351                 params.maturity,
352                 msg.sender,
353                 msg.sender,
354                 params.liquidityTo,
355                 params.dueTo,
356                 params.debtIn,
357                 params.minLiquidity,
358                 params.maxAsset,
359                 maxCollateral,
360                 params.deadline
361             )
362         );
363 
364         if (maxCollateral > dueOut.collateral) {
365             uint256 excess = maxCollateral;
366             unchecked {
367                 excess -= dueOut.collateral;
368             }
369             ETH.transfer(payable(msg.sender), excess);
370         }
371     }
372 
373     function liquidityGivenCollateral(
374         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
375         IConvenience convenience,
376         IFactory factory,
377         IMint.LiquidityGivenCollateral memory params
378     )
379         external
380         returns (
381             uint256 assetIn,
382             uint256 liquidityOut,
383             uint256 id,
384             IPair.Due memory dueOut
385         )
386     {
387         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenCollateral(
388             natives,
389             IMint._LiquidityGivenCollateral(
390                 convenience,
391                 factory,
392                 params.asset,
393                 params.collateral,
394                 params.maturity,
395                 msg.sender,
396                 msg.sender,
397                 params.liquidityTo,
398                 params.dueTo,
399                 params.collateralIn,
400                 params.minLiquidity,
401                 params.maxAsset,
402                 params.maxDebt,
403                 params.deadline
404             )
405         );
406     }
407 
408     function liquidityGivenCollateralETHAsset(
409         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
410         IConvenience convenience,
411         IFactory factory,
412         IWETH weth,
413         IMint.LiquidityGivenCollateralETHAsset memory params
414     )
415         external
416         returns (
417             uint256 assetIn,
418             uint256 liquidityOut,
419             uint256 id,
420             IPair.Due memory dueOut
421         )
422     {
423         uint112 maxAsset = MsgValue.getUint112();
424 
425         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenCollateral(
426             natives,
427             IMint._LiquidityGivenCollateral(
428                 convenience,
429                 factory,
430                 weth,
431                 params.collateral,
432                 params.maturity,
433                 msg.sender,
434                 msg.sender,
435                 params.liquidityTo,
436                 params.dueTo,
437                 params.collateralIn,
438                 params.minLiquidity,
439                 maxAsset,
440                 params.maxDebt,
441                 params.deadline
442             )
443         );
444 
445         if (maxAsset > assetIn) {
446             uint256 excess = maxAsset;
447             unchecked {
448                 excess -= assetIn;
449             }
450             ETH.transfer(payable(msg.sender), excess);
451         }
452     }
453 
454     function liquidityGivenCollateralETHCollateral(
455         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
456         IConvenience convenience,
457         IFactory factory,
458         IWETH weth,
459         IMint.LiquidityGivenCollateralETHCollateral memory params
460     )
461         external
462         returns (
463             uint256 assetIn,
464             uint256 liquidityOut,
465             uint256 id,
466             IPair.Due memory dueOut
467         )
468     {
469         uint112 collateralIn = MsgValue.getUint112();
470 
471         (assetIn, liquidityOut, id, dueOut) = _liquidityGivenCollateral(
472             natives,
473             IMint._LiquidityGivenCollateral(
474                 convenience,
475                 factory,
476                 params.asset,
477                 weth,
478                 params.maturity,
479                 msg.sender,
480                 msg.sender,
481                 params.liquidityTo,
482                 params.dueTo,
483                 collateralIn,
484                 params.minLiquidity,
485                 params.maxAsset,
486                 params.maxDebt,
487                 params.deadline
488             )
489         );
490     }
491 
492     function _newLiquidity(
493         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
494         IMint._NewLiquidity memory params
495     )
496         private
497         returns (
498             uint256 assetIn,
499             uint256 liquidityOut,
500             uint256 id,
501             IPair.Due memory dueOut
502         )
503     {
504         require(params.debtIn > params.assetIn, 'E516');
505         require(params.maturity > block.timestamp, 'E508');
506         IPair pair = params.factory.getPair(params.asset, params.collateral);
507         if (address(pair) == address(0)) pair = params.factory.createPair(params.asset, params.collateral);
508 
509         require(pair.totalLiquidity(params.maturity) == 0, 'E506');
510 
511         (uint112 xIncrease, uint112 yIncrease, uint112 zIncrease) = MintMath.givenNew(
512             params.maturity,
513             params.assetIn,
514             params.debtIn,
515             params.collateralIn
516         );
517 
518         (assetIn, liquidityOut, id, dueOut) = _mint(
519             natives,
520             IMint._Mint(
521                 params.convenience,
522                 pair,
523                 params.asset,
524                 params.collateral,
525                 params.maturity,
526                 params.assetFrom,
527                 params.collateralFrom,
528                 params.liquidityTo,
529                 params.dueTo,
530                 xIncrease,
531                 yIncrease,
532                 zIncrease,
533                 params.deadline
534             )
535         );
536     }
537 
538     function _liquidityGivenAsset(
539         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
540         IMint._LiquidityGivenAsset memory params
541     )
542         private
543         returns (
544             uint256 assetIn,
545             uint256 liquidityOut,
546             uint256 id,
547             IPair.Due memory dueOut
548         )
549     {
550         IPair pair = params.factory.getPair(params.asset, params.collateral);
551         if(address(pair)==address(0)){pair=params.factory.createPair(params.asset,params.collateral);}
552         require(pair.totalLiquidity(params.maturity) != 0, 'E507');
553 
554         (uint112 xIncrease, uint112 yIncrease, uint112 zIncrease) = pair.givenAsset(params.maturity, params.assetIn);
555 
556         (assetIn, liquidityOut, id, dueOut) = _mint(
557             natives,
558             IMint._Mint(
559                 params.convenience,
560                 pair,
561                 params.asset,
562                 params.collateral,
563                 params.maturity,
564                 params.assetFrom,
565                 params.collateralFrom,
566                 params.liquidityTo,
567                 params.dueTo,
568                 xIncrease,
569                 yIncrease,
570                 zIncrease,
571                 params.deadline
572             )
573         );
574 
575         require(liquidityOut >= params.minLiquidity, 'E511');
576         require(dueOut.debt <= params.maxDebt, 'E512');
577         require(dueOut.collateral <= params.maxCollateral, 'E513');
578     }
579 
580     function _liquidityGivenDebt(
581         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
582         IMint._LiquidityGivenDebt memory params
583     )
584         private
585         returns (
586             uint256 assetIn,
587             uint256 liquidityOut,
588             uint256 id,
589             IPair.Due memory dueOut
590         )
591     {
592         IPair pair = params.factory.getPair(params.asset, params.collateral);
593         require(address(pair) != address(0), 'E501');
594         require(pair.totalLiquidity(params.maturity) != 0, 'E507');
595 
596         (uint112 xIncrease, uint112 yIncrease, uint112 zIncrease) = pair.givenDebt(params.maturity, params.debtIn);
597 
598         (assetIn, liquidityOut, id, dueOut) = _mint(
599             natives,
600             IMint._Mint(
601                 params.convenience,
602                 pair,
603                 params.asset,
604                 params.collateral,
605                 params.maturity,
606                 params.assetFrom,
607                 params.collateralFrom,
608                 params.liquidityTo,
609                 params.dueTo,
610                 xIncrease,
611                 yIncrease,
612                 zIncrease,
613                 params.deadline
614             )
615         );
616 
617         require(liquidityOut >= params.minLiquidity, 'E511');
618         require(xIncrease <= params.maxAsset, 'E519');
619         require(dueOut.collateral <= params.maxCollateral, 'E513');
620     }
621 
622     function _liquidityGivenCollateral(
623         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
624         IMint._LiquidityGivenCollateral memory params
625     )
626         private
627         returns (
628             uint256 assetIn,
629             uint256 liquidityOut,
630             uint256 id,
631             IPair.Due memory dueOut
632         )
633     {
634         IPair pair = params.factory.getPair(params.asset, params.collateral);
635         require(address(pair) != address(0), 'E501');
636         require(pair.totalLiquidity(params.maturity) != 0, 'E507');
637 
638         (uint112 xIncrease, uint112 yIncrease, uint112 zIncrease) = pair.givenCollateral(
639             params.maturity,
640             params.collateralIn
641         );
642         (assetIn, liquidityOut, id, dueOut) = _mint(
643             natives,
644             IMint._Mint(
645                 params.convenience,
646                 pair,
647                 params.asset,
648                 params.collateral,
649                 params.maturity,
650                 params.assetFrom,
651                 params.collateralFrom,
652                 params.liquidityTo,
653                 params.dueTo,
654                 xIncrease,
655                 yIncrease,
656                 zIncrease,
657                 params.deadline
658             )
659         );
660         require(liquidityOut >= params.minLiquidity, 'E511');
661         require(xIncrease <= params.maxAsset, 'E519');
662         require(dueOut.debt <= params.maxDebt, 'E512');
663     }
664 
665     function _mint(
666         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
667         IMint._Mint memory params
668     )
669         private
670         returns (
671             uint256 assetIn,
672             uint256 liquidityOut,
673             uint256 id,
674             IPair.Due memory dueOut
675         )
676     {
677         require(params.deadline >= block.timestamp, 'E504');
678         require(params.maturity > block.timestamp, 'E508');
679         IConvenience.Native storage native = natives[params.asset][params.collateral][params.maturity];
680         if (address(native.liquidity) == address(0))
681             native.deploy(params.convenience, params.pair, params.asset, params.collateral, params.maturity);
682         (assetIn, liquidityOut, id, dueOut) = params.pair.mint(
683             IPair.MintParam(
684                 params.maturity,
685                 address(this),
686                 address(this),
687                 params.xIncrease,
688                 params.yIncrease,
689                 params.zIncrease,
690                 bytes(abi.encode(params.asset, params.collateral, params.assetFrom, params.collateralFrom))
691             )
692         );
693         native.liquidity.mint(params.liquidityTo, liquidityOut);
694         native.collateralizedDebt.mint(params.dueTo, id);
695  
696     }
697 }
