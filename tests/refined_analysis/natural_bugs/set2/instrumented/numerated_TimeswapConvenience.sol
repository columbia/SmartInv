1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from './interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from './interfaces/IWETH.sol';
7 import {IDue} from './interfaces/IDue.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
10 import {ITimeswapMintCallback} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/callback/ITimeswapMintCallback.sol';
11 import {ITimeswapLendCallback} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/callback/ITimeswapLendCallback.sol';
12 import {ITimeswapBorrowCallback} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/callback/ITimeswapBorrowCallback.sol';
13 import {ITimeswapPayCallback} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/callback/ITimeswapPayCallback.sol';
14 import {Mint} from './libraries/Mint.sol';
15 import {Burn} from './libraries/Burn.sol';
16 import {Lend} from './libraries/Lend.sol';
17 import {Withdraw} from './libraries/Withdraw.sol';
18 import {Borrow} from './libraries/Borrow.sol';
19 import {Pay} from './libraries/Pay.sol';
20 import {DeployNative} from './libraries/DeployNative.sol';
21 import {SafeTransfer} from './libraries/SafeTransfer.sol';
22 
23 /// @title Timeswap Convenience
24 /// @author Timeswap Labs
25 /// @notice It is recommnded to use this contract to interact with Timeswap Core contract.
26 /// @notice All error messages are abbreviated and can be found in the documentation.
27 contract TimeswapConvenience is IConvenience {
28     using SafeTransfer for IERC20;
29     using Mint for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
30     using Burn for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
31     using Lend for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
32     using Withdraw for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
33     using Borrow for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
34     using Pay for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
35     using DeployNative for mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native)));
36 
37     /* ===== MODEL ===== */
38 
39     /// @inheritdoc IConvenience
40     IFactory public immutable override factory;
41     /// @inheritdoc IConvenience
42     IWETH public immutable override weth;
43 
44     /// @dev Stores the addresses of the Liquidty, Bond, Insurance, Collateralized Debt token contracts.
45     mapping(IERC20 => mapping(IERC20 => mapping(uint256 => Native))) private natives;
46 
47     /* ===== VIEW ===== */
48 
49     /// @inheritdoc IConvenience
50     function getNative(
51         IERC20 asset,
52         IERC20 collateral,
53         uint256 maturity
54     ) external view override returns (Native memory) {
55         return natives[asset][collateral][maturity];
56     }
57 
58     /* ===== INIT ===== */
59 
60     /// @dev Initializes the Convenience contract.
61     /// @param _factory The address of factory contract used by this contract.
62     /// @param _weth The address of the Wrapped ETH contract.
63     constructor(IFactory _factory, IWETH _weth) {
64         require(address(_factory) != address(0), 'E601');
65         require(address(_weth) != address(0), 'E601');
66         require(address(_factory) != address(_weth), 'E612');
67 
68         factory = _factory;
69         weth = _weth;
70     }
71 
72     /* ===== UPDATE ===== */
73 
74     receive() external payable {
75         require(msg.sender == address(weth));
76     }
77 
78     /// @inheritdoc IConvenience
79     function deployPair(DeployPair calldata params) external override {
80         factory.createPair(params.asset, params.collateral);
81     }
82 
83     /// @inheritdoc IConvenience
84     function deployNatives(DeployNatives calldata params) external override {
85         natives.deploy(this, factory, params);
86     }
87 
88     /// @inheritdoc IConvenience
89     function newLiquidity(NewLiquidity calldata params)
90         external
91         override
92         returns (
93             uint256 assetIn,
94             uint256 liquidityOut,
95             uint256 id,
96             IPair.Due memory dueOut
97         )
98     {
99         (assetIn, liquidityOut, id, dueOut) = natives.newLiquidity(this, factory, params);
100     }
101 
102     /// @inheritdoc IConvenience
103     function newLiquidityETHAsset(NewLiquidityETHAsset calldata params)
104         external
105         payable
106         override
107         returns (
108             uint256 assetIn,
109             uint256 liquidityOut,
110             uint256 id,
111             IPair.Due memory dueOut
112         )
113     {
114         (assetIn, liquidityOut, id, dueOut) = natives.newLiquidityETHAsset(this, factory, weth, params);
115     }
116 
117     /// @inheritdoc IConvenience
118     function newLiquidityETHCollateral(NewLiquidityETHCollateral calldata params)
119         external
120         payable
121         override
122         returns (
123             uint256 assetIn,
124             uint256 liquidityOut,
125             uint256 id,
126             IPair.Due memory dueOut
127         )
128     {
129         (assetIn, liquidityOut, id, dueOut) = natives.newLiquidityETHCollateral(this, factory, weth, params);
130     }
131 
132     /// @inheritdoc IConvenience
133     function liquidityGivenAsset(LiquidityGivenAsset calldata params)
134         external
135         override
136         returns (
137             uint256 assetIn,
138             uint256 liquidityOut,
139             uint256 id,
140             IPair.Due memory dueOut
141         )
142     {
143         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenAsset(this, factory, params);
144     }
145 
146     /// @inheritdoc IConvenience
147     function liquidityGivenAssetETHAsset(LiquidityGivenAssetETHAsset calldata params)
148         external
149         payable
150         override
151         returns (
152             uint256 assetIn,
153             uint256 liquidityOut,
154             uint256 id,
155             IPair.Due memory dueOut
156         )
157     {
158         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenAssetETHAsset(this, factory, weth, params);
159     }
160 
161     /// @inheritdoc IConvenience
162     function liquidityGivenAssetETHCollateral(LiquidityGivenAssetETHCollateral calldata params)
163         external
164         payable
165         override
166         returns (
167             uint256 assetIn,
168             uint256 liquidityOut,
169             uint256 id,
170             IPair.Due memory dueOut
171         )
172     {
173         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenAssetETHCollateral(this, factory, weth, params);
174     }
175 
176     /// @inheritdoc IConvenience
177     function liquidityGivenDebt(LiquidityGivenDebt calldata params)
178         external
179         override
180         returns (
181             uint256 assetIn,
182             uint256 liquidityOut,
183             uint256 id,
184             IPair.Due memory dueOut
185         )
186     {
187         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenDebt(this, factory, params);
188     }
189 
190     /// @inheritdoc IConvenience
191     function liquidityGivenDebtETHAsset(LiquidityGivenDebtETHAsset calldata params)
192         external
193         payable
194         override
195         returns (
196             uint256 assetIn,
197             uint256 liquidityOut,
198             uint256 id,
199             IPair.Due memory dueOut
200         )
201     {
202         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenDebtETHAsset(this, factory, weth, params);
203     }
204 
205     /// @inheritdoc IConvenience
206     function liquidityGivenDebtETHCollateral(LiquidityGivenDebtETHCollateral calldata params)
207         external
208         payable
209         override
210         returns (
211             uint256 assetIn,
212             uint256 liquidityOut,
213             uint256 id,
214             IPair.Due memory dueOut
215         )
216     {
217         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenDebtETHCollateral(this, factory, weth, params);
218     }
219 
220     /// @inheritdoc IConvenience
221     function liquidityGivenCollateral(LiquidityGivenCollateral calldata params)
222         external
223         override
224         returns (
225             uint256 assetIn,
226             uint256 liquidityOut,
227             uint256 id,
228             IPair.Due memory dueOut
229         )
230     {
231         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenCollateral(this, factory, params);
232     }
233 
234     /// @inheritdoc IConvenience
235     function liquidityGivenCollateralETHAsset(LiquidityGivenCollateralETHAsset calldata params)
236         external
237         payable
238         override
239         returns (
240             uint256 assetIn,
241             uint256 liquidityOut,
242             uint256 id,
243             IPair.Due memory dueOut
244         )
245     {
246         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenCollateralETHAsset(this, factory, weth, params);
247     }
248 
249     /// @inheritdoc IConvenience
250     function liquidityGivenCollateralETHCollateral(LiquidityGivenCollateralETHCollateral calldata params)
251         external
252         payable
253         override
254         returns (
255             uint256 assetIn,
256             uint256 liquidityOut,
257             uint256 id,
258             IPair.Due memory dueOut
259         )
260     {
261         (assetIn, liquidityOut, id, dueOut) = natives.liquidityGivenCollateralETHCollateral(
262             this,
263             factory,
264             weth,
265             params
266         );
267     }
268 
269     /// @inheritdoc IConvenience
270     function removeLiquidity(RemoveLiquidity calldata params)
271         external
272         override
273         returns (uint256 assetOut, uint128 collateralOut)
274     {
275         (assetOut, collateralOut) = natives.removeLiquidity(factory, params);
276     }
277 
278     /// @inheritdoc IConvenience
279     function removeLiquidityETHAsset(RemoveLiquidityETHAsset calldata params)
280         external
281         override
282         returns (uint256 assetOut, uint128 collateralOut)
283     {
284         (assetOut, collateralOut) = natives.removeLiquidityETHAsset(factory, weth, params);
285     }
286 
287     /// @inheritdoc IConvenience
288     function removeLiquidityETHCollateral(RemoveLiquidityETHCollateral calldata params)
289         external
290         override
291         returns (uint256 assetOut, uint128 collateralOut)
292     {
293         (assetOut, collateralOut) = natives.removeLiquidityETHCollateral(factory, weth, params);
294     }
295 
296     /// @inheritdoc IConvenience
297     function lendGivenBond(LendGivenBond calldata params)
298         external
299         override
300         returns (uint256 assetIn, IPair.Claims memory claimsOut)
301     {
302         (assetIn, claimsOut) = natives.lendGivenBond(this, factory, params);
303     }
304 
305     /// @inheritdoc IConvenience
306     function lendGivenBondETHAsset(LendGivenBondETHAsset calldata params)
307         external
308         payable
309         override
310         returns (uint256 assetIn, IPair.Claims memory claimsOut)
311     {
312         (assetIn, claimsOut) = natives.lendGivenBondETHAsset(this, factory, weth, params);
313     }
314 
315     /// @inheritdoc IConvenience
316     function lendGivenBondETHCollateral(LendGivenBondETHCollateral calldata params)
317         external
318         payable
319         override
320         returns (uint256 assetIn, IPair.Claims memory claimsOut)
321     {
322         (assetIn, claimsOut) = natives.lendGivenBondETHCollateral(this, factory, weth, params);
323     }
324 
325     /// @inheritdoc IConvenience
326     function lendGivenInsurance(LendGivenInsurance calldata params)
327         external
328         override
329         returns (uint256 assetIn, IPair.Claims memory claimsOut)
330     {
331         (assetIn, claimsOut) = natives.lendGivenInsurance(this, factory, params);
332     }
333 
334     /// @inheritdoc IConvenience
335     function lendGivenInsuranceETHAsset(LendGivenInsuranceETHAsset calldata params)
336         external
337         payable
338         override
339         returns (uint256 assetIn, IPair.Claims memory claimsOut)
340     {
341         (assetIn, claimsOut) = natives.lendGivenInsuranceETHAsset(this, factory, weth, params);
342     }
343 
344     /// @inheritdoc IConvenience
345     function lendGivenInsuranceETHCollateral(LendGivenInsuranceETHCollateral calldata params)
346         external
347         override
348         returns (uint256 assetIn, IPair.Claims memory claimsOut)
349     {
350         (assetIn, claimsOut) = natives.lendGivenInsuranceETHCollateral(this, factory, weth, params);
351     }
352 
353     /// @inheritdoc IConvenience
354     function lendGivenPercent(LendGivenPercent calldata params)
355         external
356         override
357         returns (uint256 assetIn, IPair.Claims memory claimsOut)
358     {
359         (assetIn, claimsOut) = natives.lendGivenPercent(this, factory, params);
360     }
361 
362     /// @inheritdoc IConvenience
363     function lendGivenPercentETHAsset(LendGivenPercentETHAsset calldata params)
364         external
365         payable
366         override
367         returns (uint256 assetIn, IPair.Claims memory claimsOut)
368     {
369         (assetIn, claimsOut) = natives.lendGivenPercentETHAsset(this, factory, weth, params);
370     }
371 
372     /// @inheritdoc IConvenience
373     function lendGivenPercentETHCollateral(LendGivenPercentETHCollateral calldata params)
374         external
375         override
376         returns (uint256 assetIn, IPair.Claims memory claimsOut)
377     {
378         (assetIn, claimsOut) = natives.lendGivenPercentETHCollateral(this, factory, weth, params);
379     }
380 
381     /// @inheritdoc IConvenience
382     function collect(Collect calldata params) external override returns (IPair.Tokens memory tokensOut) {
383         tokensOut = natives.collect(factory, params);
384     }
385 
386     /// @inheritdoc IConvenience
387     function collectETHAsset(CollectETHAsset calldata params)
388         external
389         override
390         returns (IPair.Tokens memory tokensOut)
391     {
392         tokensOut = natives.collectETHAsset(factory, weth, params);
393     }
394 
395     /// @inheritdoc IConvenience
396     function collectETHCollateral(CollectETHCollateral calldata params)
397         external
398         override
399         returns (IPair.Tokens memory tokensOut)
400     {
401         tokensOut = natives.collectETHCollateral(factory, weth, params);
402     }
403 
404     /// @inheritdoc IConvenience
405     function borrowGivenDebt(BorrowGivenDebt calldata params)
406         external
407         override
408         returns (
409             uint256 assetOut,
410             uint256 id,
411             IPair.Due memory dueOut
412         )
413     {
414         (assetOut, id, dueOut) = natives.borrowGivenDebt(this, factory, params);
415     }
416 
417     /// @inheritdoc IConvenience
418     function borrowGivenDebtETHAsset(BorrowGivenDebtETHAsset calldata params)
419         external
420         override
421         returns (
422             uint256 assetOut,
423             uint256 id,
424             IPair.Due memory dueOut
425         )
426     {
427         (assetOut, id, dueOut) = natives.borrowGivenDebtETHAsset(this, factory, weth, params);
428     }
429 
430     /// @inheritdoc IConvenience
431     function borrowGivenDebtETHCollateral(BorrowGivenDebtETHCollateral calldata params)
432         external
433         payable
434         override
435         returns (
436             uint256 assetOut,
437             uint256 id,
438             IPair.Due memory dueOut
439         )
440     {
441         (assetOut, id, dueOut) = natives.borrowGivenDebtETHCollateral(this, factory, weth, params);
442     }
443 
444     /// @inheritdoc IConvenience
445     function borrowGivenCollateral(BorrowGivenCollateral calldata params)
446         external
447         override
448         returns (
449             uint256 assetOut,
450             uint256 id,
451             IPair.Due memory dueOut
452         )
453     {
454         (assetOut, id, dueOut) = natives.borrowGivenCollateral(this, factory, params);
455     }
456 
457     /// @inheritdoc IConvenience
458     function borrowGivenCollateralETHAsset(BorrowGivenCollateralETHAsset calldata params)
459         external
460         override
461         returns (
462             uint256 assetOut,
463             uint256 id,
464             IPair.Due memory dueOut
465         )
466     {
467         (assetOut, id, dueOut) = natives.borrowGivenCollateralETHAsset(this, factory, weth, params);
468     }
469 
470     /// @inheritdoc IConvenience
471     function borrowGivenCollateralETHCollateral(BorrowGivenCollateralETHCollateral calldata params)
472         external
473         payable
474         override
475         returns (
476             uint256 assetOut,
477             uint256 id,
478             IPair.Due memory dueOut
479         )
480     {
481         (assetOut, id, dueOut) = natives.borrowGivenCollateralETHCollateral(this, factory, weth, params);
482     }
483 
484     /// @inheritdoc IConvenience
485     function borrowGivenPercent(BorrowGivenPercent calldata params)
486         external
487         override
488         returns (
489             uint256 assetOut,
490             uint256 id,
491             IPair.Due memory dueOut
492         )
493     {
494         (assetOut, id, dueOut) = natives.borrowGivenPercent(this, factory, params);
495     }
496 
497     /// @inheritdoc IConvenience
498     function borrowGivenPercentETHAsset(BorrowGivenPercentETHAsset calldata params)
499         external
500         override
501         returns (
502             uint256 assetOut,
503             uint256 id,
504             IPair.Due memory dueOut
505         )
506     {
507         (assetOut, id, dueOut) = natives.borrowGivenPercentETHAsset(this, factory, weth, params);
508     }
509 
510     /// @inheritdoc IConvenience
511     function borrowGivenPercentETHCollateral(BorrowGivenPercentETHCollateral calldata params)
512         external
513         payable
514         override
515         returns (
516             uint256 assetOut,
517             uint256 id,
518             IPair.Due memory dueOut
519         )
520     {
521         (assetOut, id, dueOut) = natives.borrowGivenPercentETHCollateral(this, factory, weth, params);
522     }
523 
524     /// @inheritdoc IConvenience
525     function repay(Repay memory params) external override returns (uint128 assetIn, uint128 collateralOut) {
526         (assetIn, collateralOut) = natives.pay(factory, params);
527     }
528 
529     /// @inheritdoc IConvenience
530     function repayETHAsset(RepayETHAsset memory params)
531         external
532         payable
533         override
534         returns (uint128 assetIn, uint128 collateralOut)
535     {
536         (assetIn, collateralOut) = natives.payETHAsset(factory, weth, params);
537     }
538 
539     /// @inheritdoc IConvenience
540     function repayETHCollateral(RepayETHCollateral memory params)
541         external
542         override
543         returns (uint128 assetIn, uint128 collateralOut)
544     {
545         (assetIn, collateralOut) = natives.payETHCollateral(factory, weth, params);
546     }
547 
548     /// @inheritdoc ITimeswapMintCallback
549     function timeswapMintCallback(
550         uint256 assetIn,
551         uint112 collateralIn,
552         bytes calldata data
553     ) external override {
554         (IERC20 asset, IERC20 collateral, address assetFrom, address collateralFrom) = abi.decode(
555             data,
556             (IERC20, IERC20, address, address)
557         );
558         IPair pair = factory.getPair(asset, collateral);
559 
560         require(msg.sender == address(pair), 'E701');
561 
562         IWETH _weth = weth;
563 
564         if (assetFrom == address(this)) {
565             _weth.deposit{value: assetIn}();
566             asset.safeTransfer(pair, assetIn);
567         } else {
568             asset.safeTransferFrom(assetFrom, pair, assetIn);
569         }
570 
571         if (collateralFrom == address(this)) {
572             _weth.deposit{value: collateralIn}();
573             collateral.safeTransfer(pair, collateralIn);
574         } else {
575             collateral.safeTransferFrom(collateralFrom, pair, collateralIn);
576         }
577     }
578 
579     /// @inheritdoc ITimeswapLendCallback
580     function timeswapLendCallback(uint256 assetIn, bytes calldata data) external override {
581         (IERC20 asset, IERC20 collateral, address from) = abi.decode(data, (IERC20, IERC20, address));
582         IPair pair = factory.getPair(asset, collateral);
583 
584         require(msg.sender == address(pair), 'E701');
585 
586         if (from == address(this)) {
587             weth.deposit{value: assetIn}();
588             asset.safeTransfer(pair, assetIn);
589         } else {
590             asset.safeTransferFrom(from, pair, assetIn);
591         }
592     }
593 
594     /// @inheritdoc ITimeswapBorrowCallback
595     function timeswapBorrowCallback(uint112 collateralIn, bytes calldata data) external override {
596         (IERC20 asset, IERC20 collateral, address from) = abi.decode(data, (IERC20, IERC20, address));
597         IPair pair = factory.getPair(asset, collateral);
598         require(msg.sender == address(pair), 'E701');
599         if (from == address(this)) {
600             weth.deposit{value: collateralIn}();
601             collateral.safeTransfer(pair, collateralIn);
602         } else {
603             collateral.safeTransferFrom(from, pair, collateralIn);
604         }
605     }
606 
607     /// @inheritdoc ITimeswapPayCallback
608     function timeswapPayCallback(uint128 assetIn, bytes calldata data) external override {
609         (IERC20 asset, IERC20 collateral, address from) = abi.decode(data, (IERC20, IERC20, address));
610 
611         IPair pair = factory.getPair(asset, collateral);
612         require(msg.sender == address(pair), 'E701');
613 
614         if (from == address(this)) {
615             weth.deposit{value: assetIn}();
616             asset.safeTransfer(pair, assetIn);
617         } else {
618             asset.safeTransferFrom(from, pair, assetIn);
619         }
620     }
621 }
