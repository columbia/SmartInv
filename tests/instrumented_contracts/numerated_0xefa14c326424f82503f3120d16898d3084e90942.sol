1 // SPDX-License-Identifier: SEE LICENSE IN LICENSE
2 
3 pragma solidity >=0.7.6;
4 pragma abicoder v2;
5 
6 interface IValueLiquidFactory {
7     event PairCreated(address indexed token0, address indexed token1, address pair, uint32 tokenWeight0, uint32 swapFee, uint256);
8 
9     function feeTo() external view returns (address);
10 
11     function formula() external view returns (address);
12 
13     function protocolFee() external view returns (uint256);
14 
15     function feeToSetter() external view returns (address);
16 
17     function getPair(
18         address tokenA,
19         address tokenB,
20         uint32 tokenWeightA,
21         uint32 swapFee
22     ) external view returns (address pair);
23 
24     function allPairs(uint256) external view returns (address pair);
25 
26     function isPair(address) external view returns (bool);
27 
28     function allPairsLength() external view returns (uint256);
29 
30     function createPair(
31         address tokenA,
32         address tokenB,
33         uint32 tokenWeightA,
34         uint32 swapFee
35     ) external returns (address pair);
36 
37     function getWeightsAndSwapFee(address pair)
38         external
39         view
40         returns (
41             uint32 tokenWeight0,
42             uint32 tokenWeight1,
43             uint32 swapFee
44         );
45 
46     function setFeeTo(address) external;
47 
48     function setFeeToSetter(address) external;
49 
50     function setProtocolFee(uint256) external;
51 }
52 
53 /*
54     Bancor Formula interface
55 */
56 interface IValueLiquidFormula {
57     function getReserveAndWeights(address pair, address tokenA)
58         external
59         view
60         returns (
61             address tokenB,
62             uint256 reserveA,
63             uint256 reserveB,
64             uint32 tokenWeightA,
65             uint32 tokenWeightB,
66             uint32 swapFee
67         );
68 
69     function getFactoryReserveAndWeights(
70         address factory,
71         address pair,
72         address tokenA
73     )
74         external
75         view
76         returns (
77             address tokenB,
78             uint256 reserveA,
79             uint256 reserveB,
80             uint32 tokenWeightA,
81             uint32 tokenWeightB,
82             uint32 swapFee
83         );
84 
85     function getAmountIn(
86         uint256 amountOut,
87         uint256 reserveIn,
88         uint256 reserveOut,
89         uint32 tokenWeightIn,
90         uint32 tokenWeightOut,
91         uint32 swapFee
92     ) external view returns (uint256 amountIn);
93 
94     function getPairAmountIn(
95         address pair,
96         address tokenIn,
97         uint256 amountOut
98     ) external view returns (uint256 amountIn);
99 
100     function getAmountOut(
101         uint256 amountIn,
102         uint256 reserveIn,
103         uint256 reserveOut,
104         uint32 tokenWeightIn,
105         uint32 tokenWeightOut,
106         uint32 swapFee
107     ) external view returns (uint256 amountOut);
108 
109     function getPairAmountOut(
110         address pair,
111         address tokenIn,
112         uint256 amountIn
113     ) external view returns (uint256 amountOut);
114 
115     function getAmountsIn(
116         address tokenIn,
117         address tokenOut,
118         uint256 amountOut,
119         address[] calldata path
120     ) external view returns (uint256[] memory amounts);
121 
122     function getFactoryAmountsIn(
123         address factory,
124         address tokenIn,
125         address tokenOut,
126         uint256 amountOut,
127         address[] calldata path
128     ) external view returns (uint256[] memory amounts);
129 
130     function getAmountsOut(
131         address tokenIn,
132         address tokenOut,
133         uint256 amountIn,
134         address[] calldata path
135     ) external view returns (uint256[] memory amounts);
136 
137     function getFactoryAmountsOut(
138         address factory,
139         address tokenIn,
140         address tokenOut,
141         uint256 amountIn,
142         address[] calldata path
143     ) external view returns (uint256[] memory amounts);
144 
145     function ensureConstantValue(
146         uint256 reserve0,
147         uint256 reserve1,
148         uint256 balance0Adjusted,
149         uint256 balance1Adjusted,
150         uint32 tokenWeight0
151     ) external view returns (bool);
152 
153     function getReserves(
154         address pair,
155         address tokenA,
156         address tokenB
157     ) external view returns (uint256 reserveA, uint256 reserveB);
158 
159     function getOtherToken(address pair, address tokenA) external view returns (address tokenB);
160 
161     function quote(
162         uint256 amountA,
163         uint256 reserveA,
164         uint256 reserveB
165     ) external pure returns (uint256 amountB);
166 
167     function sortTokens(address tokenA, address tokenB) external pure returns (address token0, address token1);
168 
169     function mintLiquidityFee(
170         uint256 totalLiquidity,
171         uint112 reserve0,
172         uint112 reserve1,
173         uint32 tokenWeight0,
174         uint32 tokenWeight1,
175         uint112 collectedFee0,
176         uint112 collectedFee1
177     ) external view returns (uint256 amount);
178 }
179 
180 interface IValueLiquidPair {
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     function name() external view returns (string memory);
185 
186     function symbol() external view returns (string memory);
187 
188     function decimals() external pure returns (uint8);
189 
190     function totalSupply() external view returns (uint256);
191 
192     function balanceOf(address owner) external view returns (uint256);
193 
194     function allowance(address owner, address spender) external view returns (uint256);
195 
196     function approve(address spender, uint256 value) external returns (bool);
197 
198     function transfer(address to, uint256 value) external returns (bool);
199 
200     function transferFrom(
201         address from,
202         address to,
203         uint256 value
204     ) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207 
208     function PERMIT_TYPEHASH() external pure returns (bytes32);
209 
210     function nonces(address owner) external view returns (uint256);
211 
212     function permit(
213         address owner,
214         address spender,
215         uint256 value,
216         uint256 deadline,
217         uint8 v,
218         bytes32 r,
219         bytes32 s
220     ) external;
221 
222     event PaidProtocolFee(uint112 collectedFee0, uint112 collectedFee1);
223     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
224     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
225     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
226     event Sync(uint112 reserve0, uint112 reserve1);
227 
228     function MINIMUM_LIQUIDITY() external pure returns (uint256);
229 
230     function factory() external view returns (address);
231 
232     function token0() external view returns (address);
233 
234     function token1() external view returns (address);
235 
236     function getReserves()
237         external
238         view
239         returns (
240             uint112 reserve0,
241             uint112 reserve1,
242             uint32 blockTimestampLast
243         );
244 
245     function getCollectedFees() external view returns (uint112 _collectedFee0, uint112 _collectedFee1);
246 
247     function getTokenWeights() external view returns (uint32 tokenWeight0, uint32 tokenWeight1);
248 
249     function getSwapFee() external view returns (uint32);
250 
251     function price0CumulativeLast() external view returns (uint256);
252 
253     function price1CumulativeLast() external view returns (uint256);
254 
255     function mint(address to) external returns (uint256 liquidity);
256 
257     function burn(address to) external returns (uint256 amount0, uint256 amount1);
258 
259     function swap(
260         uint256 amount0Out,
261         uint256 amount1Out,
262         address to,
263         bytes calldata data
264     ) external;
265 
266     function skim(address to) external;
267 
268     function sync() external;
269 
270     function initialize(
271         address,
272         address,
273         uint32,
274         uint32
275     ) external;
276 }
277 
278 interface IStakePool {
279     event Deposit(address indexed account, uint256 amount);
280     event AddRewardPool(uint256 indexed poolId);
281     event UpdateRewardPool(uint256 indexed poolId, uint256 endRewardBlock, uint256 rewardPerBlock);
282     event PayRewardPool(
283         uint256 indexed poolId,
284         address indexed rewardToken,
285         address indexed account,
286         uint256 pendingReward,
287         uint256 rebaseAmount,
288         uint256 paidReward
289     );
290     event UpdateRewardRebaser(uint256 indexed poolId, address rewardRebaser);
291     event UpdateRewardMultiplier(uint256 indexed poolId, address rewardMultiplier);
292     event Withdraw(address indexed account, uint256 amount);
293 
294     function version() external returns (uint256);
295 
296     function pair() external returns (address);
297 
298     function initialize(
299         address _pair,
300         uint256 _unstakingFrozenTime,
301         address _rewardFund,
302         address _timelock
303     ) external;
304 
305     function stake(uint256) external;
306 
307     function stakeFor(address _account) external;
308 
309     function withdraw(uint256) external;
310 
311     function getReward(uint8 _pid, address _account) external;
312 
313     function getAllRewards(address _account) external;
314 
315     function pendingReward(uint8 _pid, address _account) external view returns (uint256);
316 
317     function getEndRewardBlock(uint8 _pid) external view returns (address, uint256);
318 
319     function getRewardPerBlock(uint8 pid) external view returns (uint256);
320 
321     function rewardPoolInfoLength() external view returns (uint256);
322 
323     function unfrozenStakeTime(address _account) external view returns (uint256);
324 
325     function emergencyWithdraw() external;
326 
327     function updateReward() external;
328 
329     function updateReward(uint8 _pid) external;
330 
331     function updateRewardPool(
332         uint8 _pid,
333         uint256 _endRewardBlock,
334         uint256 _rewardPerBlock
335     ) external;
336 
337     function getRewardMultiplier(
338         uint8 _pid,
339         uint256 _from,
340         uint256 _to,
341         uint256 _rewardPerBlock
342     ) external view returns (uint256);
343 
344     function getRewardRebase(
345         uint8 _pid,
346         address _rewardToken,
347         uint256 _pendingReward
348     ) external view returns (uint256);
349 
350     function updateRewardRebaser(uint8 _pid, address _rewardRebaser) external;
351 
352     function updateRewardMultiplier(uint8 _pid, address _rewardMultiplier) external;
353 
354     function getUserInfo(uint8 _pid, address _account)
355         external
356         view
357         returns (
358             uint256 amount,
359             uint256 rewardDebt,
360             uint256 accumulatedEarned,
361             uint256 lockReward,
362             uint256 lockRewardReleased
363         );
364 
365     function addRewardPool(
366         address _rewardToken,
367         address _rewardRebaser,
368         address _rewardMultiplier,
369         uint256 _startBlock,
370         uint256 _endRewardBlock,
371         uint256 _rewardPerBlock,
372         uint256 _lockRewardPercent,
373         uint256 _startVestingBlock,
374         uint256 _endVestingBlock
375     ) external;
376 
377     function removeLiquidity(
378         address provider,
379         address tokenA,
380         address tokenB,
381         uint256 liquidity,
382         uint256 amountAMin,
383         uint256 amountBMin,
384         address to,
385         uint256 deadline
386     ) external returns (uint256 amountA, uint256 amountB);
387 
388     function removeLiquidityETH(
389         address provider,
390         address token,
391         uint256 liquidity,
392         uint256 amountTokenMin,
393         uint256 amountETHMin,
394         address to,
395         uint256 deadline
396     ) external returns (uint256 amountToken, uint256 amountETH);
397 
398     function removeLiquidityETHSupportingFeeOnTransferTokens(
399         address provider,
400         address token,
401         uint256 liquidity,
402         uint256 amountTokenMin,
403         uint256 amountETHMin,
404         address to,
405         uint256 deadline
406     ) external returns (uint256 amountETH);
407 }
408 
409 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
410 library TransferHelper {
411     function safeApprove(
412         address token,
413         address to,
414         uint256 value
415     ) internal {
416         // bytes4(keccak256(bytes('approve(address,uint256)')));
417         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
418         require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: APPROVE_FAILED");
419     }
420 
421     function safeTransfer(
422         address token,
423         address to,
424         uint256 value
425     ) internal {
426         // bytes4(keccak256(bytes('transfer(address,uint256)')));
427         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
428         require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FAILED");
429     }
430 
431     function safeTransferFrom(
432         address token,
433         address from,
434         address to,
435         uint256 value
436     ) internal {
437         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
438         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
439         require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferHelper: TRANSFER_FROM_FAILED");
440     }
441 
442     function safeTransferETH(address to, uint256 value) internal {
443         (bool success, ) = to.call{value: value}(new bytes(0));
444         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
445     }
446 }
447 
448 interface IValueLiquidRouter {
449     struct Swap {
450         address pool;
451         address tokenIn;
452         address tokenOut;
453         uint256 swapAmount; // tokenInAmount / tokenOutAmount
454         uint256 limitReturnAmount; // minAmountOut / maxAmountIn
455         uint256 maxPrice;
456         bool isBPool;
457     }
458 
459     function factory() external view returns (address);
460 
461     function controller() external view returns (address);
462 
463     function formula() external view returns (address);
464 
465     function WETH() external view returns (address);
466 
467     function addLiquidity(
468         address pair,
469         address tokenA,
470         address tokenB,
471         uint256 amountADesired,
472         uint256 amountBDesired,
473         uint256 amountAMin,
474         uint256 amountBMin,
475         address to,
476         uint256 deadline
477     )
478         external
479         returns (
480             uint256 amountA,
481             uint256 amountB,
482             uint256 liquidity
483         );
484 
485     function addLiquidityETH(
486         address pair,
487         address token,
488         uint256 amountTokenDesired,
489         uint256 amountTokenMin,
490         uint256 amountETHMin,
491         address to,
492         uint256 deadline
493     )
494         external
495         payable
496         returns (
497             uint256 amountToken,
498             uint256 amountETH,
499             uint256 liquidity
500         );
501 
502     function swapExactTokensForTokens(
503         address tokenIn,
504         address tokenOut,
505         uint256 amountIn,
506         uint256 amountOutMin,
507         address[] calldata path,
508         address to,
509         uint256 deadline,
510         uint8 flag
511     ) external returns (uint256[] memory amounts);
512 
513     function swapTokensForExactTokens(
514         address tokenIn,
515         address tokenOut,
516         uint256 amountOut,
517         uint256 amountInMax,
518         address[] calldata path,
519         address to,
520         uint256 deadline,
521         uint8 flag
522     ) external returns (uint256[] memory amounts);
523 
524     function swapExactETHForTokens(
525         address tokenOut,
526         uint256 amountOutMin,
527         address[] calldata path,
528         address to,
529         uint256 deadline,
530         uint8 flag
531     ) external payable returns (uint256[] memory amounts);
532 
533     function swapTokensForExactETH(
534         address tokenIn,
535         uint256 amountOut,
536         uint256 amountInMax,
537         address[] calldata path,
538         address to,
539         uint256 deadline,
540         uint8 flag
541     ) external returns (uint256[] memory amounts);
542 
543     function swapExactTokensForETH(
544         address tokenIn,
545         uint256 amountIn,
546         uint256 amountOutMin,
547         address[] calldata path,
548         address to,
549         uint256 deadline,
550         uint8 flag
551     ) external returns (uint256[] memory amounts);
552 
553     function swapETHForExactTokens(
554         address tokenOut,
555         uint256 amountOut,
556         address[] calldata path,
557         address to,
558         uint256 deadline,
559         uint8 flag
560     ) external payable returns (uint256[] memory amounts);
561 
562     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
563         address tokenIn,
564         address tokenOut,
565         uint256 amountIn,
566         uint256 amountOutMin,
567         address[] calldata path,
568         address to,
569         uint256 deadline,
570         uint8 flag
571     ) external;
572 
573     function swapExactETHForTokensSupportingFeeOnTransferTokens(
574         address tokenOut,
575         uint256 amountOutMin,
576         address[] calldata path,
577         address to,
578         uint256 deadline,
579         uint8 flag
580     ) external payable;
581 
582     function swapExactTokensForETHSupportingFeeOnTransferTokens(
583         address tokenIn,
584         uint256 amountIn,
585         uint256 amountOutMin,
586         address[] calldata path,
587         address to,
588         uint256 deadline,
589         uint8 flag
590     ) external;
591 
592     function addStakeLiquidity(
593         address stakePool,
594         address tokenA,
595         address tokenB,
596         uint256 amountADesired,
597         uint256 amountBDesired,
598         uint256 amountAMin,
599         uint256 amountBMin,
600         uint256 deadline
601     )
602         external
603         returns (
604             uint256 amountA,
605             uint256 amountB,
606             uint256 liquidity
607         );
608 
609     function addStakeLiquidityETH(
610         address stakePool,
611         address token,
612         uint256 amountTokenDesired,
613         uint256 amountTokenMin,
614         uint256 amountETHMin,
615         uint256 deadline
616     )
617         external
618         payable
619         returns (
620             uint256 amountToken,
621             uint256 amountETH,
622             uint256 liquidity
623         );
624 
625     function multihopBatchSwapExactIn(
626         Swap[][] memory swapSequences,
627         address tokenIn,
628         address tokenOut,
629         uint256 totalAmountIn,
630         uint256 minTotalAmountOut,
631         uint256 deadline,
632         uint8 flag
633     ) external payable returns (uint256 totalAmountOut);
634 
635     function multihopBatchSwapExactOut(
636         Swap[][] memory swapSequences,
637         address tokenIn,
638         address tokenOut,
639         uint256 maxTotalAmountIn,
640         uint256 deadline,
641         uint8 flag
642     ) external payable returns (uint256 totalAmountIn);
643 }
644 
645 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
646 library SafeMath {
647     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
648         require((z = x + y) >= x, "ds-math-add-overflow");
649     }
650 
651     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
652         require((z = x - y) <= x, "ds-math-sub-underflow");
653     }
654 
655     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
656         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
657     }
658 
659     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
660         require(b > 0, "ds-math-division-by-zero");
661         c = a / b;
662     }
663 }
664 
665 interface IWETH {
666     function deposit() external payable;
667 
668     function transfer(address to, uint256 value) external returns (bool);
669 
670     function withdraw(uint256) external;
671 
672     function balanceOf(address account) external view returns (uint256);
673 }
674 
675 interface IERC20 {
676     event Approval(address indexed owner, address indexed spender, uint256 value);
677     event Transfer(address indexed from, address indexed to, uint256 value);
678 
679     function name() external view returns (string memory);
680 
681     function symbol() external view returns (string memory);
682 
683     function decimals() external view returns (uint8);
684 
685     function totalSupply() external view returns (uint256);
686 
687     function balanceOf(address owner) external view returns (uint256);
688 
689     function allowance(address owner, address spender) external view returns (uint256);
690 
691     function approve(address spender, uint256 value) external returns (bool);
692 
693     function transfer(address to, uint256 value) external returns (bool);
694 
695     function transferFrom(
696         address from,
697         address to,
698         uint256 value
699     ) external returns (bool);
700 }
701 
702 interface IBPool is IERC20 {
703     function version() external view returns (uint256);
704 
705     function swapExactAmountIn(
706         address,
707         uint256,
708         address,
709         uint256,
710         uint256
711     ) external returns (uint256, uint256);
712 
713     function swapExactAmountOut(
714         address,
715         uint256,
716         address,
717         uint256,
718         uint256
719     ) external returns (uint256, uint256);
720 
721     function calcInGivenOut(
722         uint256,
723         uint256,
724         uint256,
725         uint256,
726         uint256,
727         uint256
728     ) external pure returns (uint256);
729 
730     function calcOutGivenIn(
731         uint256,
732         uint256,
733         uint256,
734         uint256,
735         uint256,
736         uint256
737     ) external pure returns (uint256);
738 
739     function getDenormalizedWeight(address) external view returns (uint256);
740 
741     function swapFee() external view returns (uint256);
742 
743     function setSwapFee(uint256 _swapFee) external;
744 
745     function bind(
746         address token,
747         uint256 balance,
748         uint256 denorm
749     ) external;
750 
751     function rebind(
752         address token,
753         uint256 balance,
754         uint256 denorm
755     ) external;
756 
757     function finalize(
758         uint256 _swapFee,
759         uint256 _initPoolSupply,
760         address[] calldata _bindTokens,
761         uint256[] calldata _bindDenorms
762     ) external;
763 
764     function setPublicSwap(bool _publicSwap) external;
765 
766     function setController(address _controller) external;
767 
768     function setExchangeProxy(address _exchangeProxy) external;
769 
770     function getFinalTokens() external view returns (address[] memory tokens);
771 
772     function getTotalDenormalizedWeight() external view returns (uint256);
773 
774     function getBalance(address token) external view returns (uint256);
775 
776     function joinPool(uint256 poolAmountOut, uint256[] calldata maxAmountsIn) external;
777 
778     function joinPoolFor(
779         address account,
780         uint256 rewardAmountOut,
781         uint256[] calldata maxAmountsIn
782     ) external;
783 
784     function joinswapPoolAmountOut(
785         address tokenIn,
786         uint256 poolAmountOut,
787         uint256 maxAmountIn
788     ) external returns (uint256 tokenAmountIn);
789 
790     function exitPool(uint256 poolAmountIn, uint256[] calldata minAmountsOut) external;
791 
792     function exitswapPoolAmountIn(
793         address tokenOut,
794         uint256 poolAmountIn,
795         uint256 minAmountOut
796     ) external returns (uint256 tokenAmountOut);
797 
798     function exitswapExternAmountOut(
799         address tokenOut,
800         uint256 tokenAmountOut,
801         uint256 maxPoolAmountIn
802     ) external returns (uint256 poolAmountIn);
803 
804     function joinswapExternAmountIn(
805         address tokenIn,
806         uint256 tokenAmountIn,
807         uint256 minPoolAmountOut
808     ) external returns (uint256 poolAmountOut);
809 
810     function finalizeRewardFundInfo(address _rewardFund, uint256 _unstakingFrozenTime) external;
811 
812     function addRewardPool(
813         IERC20 _rewardToken,
814         uint256 _startBlock,
815         uint256 _endRewardBlock,
816         uint256 _rewardPerBlock,
817         uint256 _lockRewardPercent,
818         uint256 _startVestingBlock,
819         uint256 _endVestingBlock
820     ) external;
821 
822     function isBound(address t) external view returns (bool);
823 
824     function getSpotPrice(address tokenIn, address tokenOut) external view returns (uint256 spotPrice);
825 }
826 
827 interface IFreeFromUpTo {
828     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
829 }
830 
831 interface IStakePoolController {
832     event MasterCreated(address indexed farm, address indexed pair, uint256 version, address timelock, address stakePoolRewardFund, uint256 totalStakePool);
833     event SetWhitelistStakingFor(address indexed contractAddress, bool value);
834     event SetWhitelistStakePool(address indexed contractAddress, int8 value);
835     event SetStakePoolCreator(address indexed contractAddress, uint256 verion);
836     event SetWhitelistRewardRebaser(address indexed contractAddress, bool value);
837     event SetWhitelistRewardMultiplier(address indexed contractAddress, bool value);
838     event SetStakePoolVerifier(address indexed contractAddress, bool value);
839     event ChangeGovernance(address indexed governance);
840     event SetFeeCollector(address indexed feeCollector);
841     event SetFeeToken(address indexed token);
842     event SetFeeAmount(uint256 indexed amount);
843 
844     struct PoolRewardInfo {
845         address rewardToken;
846         address rewardRebaser;
847         address rewardMultiplier;
848         uint256 startBlock;
849         uint256 endRewardBlock;
850         uint256 rewardPerBlock;
851         uint256 lockRewardPercent;
852         uint256 startVestingBlock;
853         uint256 endVestingBlock;
854         uint256 unstakingFrozenTime;
855         uint256 rewardFundAmount;
856     }
857 
858     function allStakePools(uint256) external view returns (address stakePool);
859 
860     function isStakePool(address contractAddress) external view returns (bool);
861 
862     function isStakePoolVerifier(address contractAddress) external view returns (bool);
863 
864     function isWhitelistStakingFor(address contractAddress) external view returns (bool);
865 
866     function isWhitelistStakePool(address contractAddress) external view returns (int8);
867 
868     function setStakePoolVerifier(address contractAddress, bool state) external;
869 
870     function setWhitelistStakingFor(address contractAddress, bool state) external;
871 
872     function setWhitelistStakePool(address contractAddress, int8 state) external;
873 
874     function addStakePoolCreator(address contractAddress) external;
875 
876     function isWhitelistRewardRebaser(address contractAddress) external view returns (bool);
877 
878     function setWhitelistRewardRebaser(address contractAddress, bool state) external;
879 
880     function isWhitelistRewardMultiplier(address contractAddress) external view returns (bool);
881 
882     function setWhitelistRewardMultiplier(address contractAddress, bool state) external;
883 
884     function allStakePoolsLength() external view returns (uint256);
885 
886     function create(
887         uint256 version,
888         address pair,
889         uint256 delayTimeLock,
890         PoolRewardInfo calldata poolRewardInfo,
891         uint8 flag
892     ) external returns (address);
893 
894     function createPair(
895         uint256 version,
896         address tokenA,
897         address tokenB,
898         uint32 tokenWeightA,
899         uint32 swapFee,
900         uint256 delayTimeLock,
901         PoolRewardInfo calldata poolRewardInfo,
902         uint8 flag
903     ) external returns (address);
904 
905     function setGovernance(address) external;
906 
907     function setFeeCollector(address _address) external;
908 
909     function setFeeToken(address _token) external;
910 
911     function setFeeAmount(uint256 _token) external;
912 }
913 
914 contract ValueLiquidRouter is IValueLiquidRouter {
915     using SafeMath for uint256;
916     address public immutable override factory;
917     address public immutable override controller;
918     address public immutable override formula;
919     address public immutable override WETH;
920     address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
921 
922     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
923     modifier ensure(uint256 deadline) {
924         require(deadline >= block.timestamp, "Router: EXPIRED");
925         _;
926     }
927     modifier discountCHI(uint8 flag) {
928         uint256 gasStart = gasleft();
929         _;
930         if ((flag & 0x1) == 1) {
931             uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
932             chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
933         }
934     }
935 
936     constructor(
937         address _factory,
938         address _controller,
939         address _WETH
940     ) {
941         factory = _factory;
942         controller = _controller;
943         formula = IValueLiquidFactory(_factory).formula();
944         WETH = _WETH;
945     }
946 
947     receive() external payable {
948         assert(msg.sender == WETH);
949         // only accept ETH via fallback from the WETH contract
950     }
951 
952     // **** ADD LIQUIDITY ****
953     function _addLiquidity(
954         address pair,
955         address tokenA,
956         address tokenB,
957         uint256 amountADesired,
958         uint256 amountBDesired,
959         uint256 amountAMin,
960         uint256 amountBMin
961     ) internal virtual returns (uint256 amountA, uint256 amountB) {
962         require(IValueLiquidFactory(factory).isPair(pair), "Router: Invalid pair");
963         (uint256 reserveA, uint256 reserveB) = IValueLiquidFormula(formula).getReserves(pair, tokenA, tokenB);
964         if (reserveA == 0 && reserveB == 0) {
965             (amountA, amountB) = (amountADesired, amountBDesired);
966         } else {
967             uint256 amountBOptimal = IValueLiquidFormula(formula).quote(amountADesired, reserveA, reserveB);
968             if (amountBOptimal <= amountBDesired) {
969                 require(amountBOptimal >= amountBMin, "Router: INSUFFICIENT_B_AMOUNT");
970                 (amountA, amountB) = (amountADesired, amountBOptimal);
971             } else {
972                 uint256 amountAOptimal = IValueLiquidFormula(formula).quote(amountBDesired, reserveB, reserveA);
973                 assert(amountAOptimal <= amountADesired);
974                 require(amountAOptimal >= amountAMin, "Router: INSUFFICIENT_A_AMOUNT");
975                 (amountA, amountB) = (amountAOptimal, amountBDesired);
976             }
977         }
978     }
979 
980     function _addLiquidityToken(
981         address pair,
982         address tokenA,
983         address tokenB,
984         uint256 amountADesired,
985         uint256 amountBDesired,
986         uint256 amountAMin,
987         uint256 amountBMin
988     ) internal returns (uint256 amountA, uint256 amountB) {
989         (amountA, amountB) = _addLiquidity(pair, tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
990         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
991         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
992     }
993 
994     function addLiquidity(
995         address pair,
996         address tokenA,
997         address tokenB,
998         uint256 amountADesired,
999         uint256 amountBDesired,
1000         uint256 amountAMin,
1001         uint256 amountBMin,
1002         address to,
1003         uint256 deadline
1004     )
1005         external
1006         virtual
1007         override
1008         ensure(deadline)
1009         returns (
1010             uint256 amountA,
1011             uint256 amountB,
1012             uint256 liquidity
1013         )
1014     {
1015         (amountA, amountB) = _addLiquidityToken(pair, tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
1016         liquidity = IValueLiquidPair(pair).mint(to);
1017     }
1018 
1019     function addStakeLiquidity(
1020         address stakePool,
1021         address tokenA,
1022         address tokenB,
1023         uint256 amountADesired,
1024         uint256 amountBDesired,
1025         uint256 amountAMin,
1026         uint256 amountBMin,
1027         uint256 deadline
1028     )
1029         external
1030         virtual
1031         override
1032         ensure(deadline)
1033         returns (
1034             uint256 amountA,
1035             uint256 amountB,
1036             uint256 liquidity
1037         )
1038     {
1039         require(IStakePoolController(controller).isStakePool(stakePool), "Router: Invalid stakePool");
1040         address pair = IStakePool(stakePool).pair();
1041         (amountA, amountB) = _addLiquidityToken(pair, tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
1042         liquidity = IValueLiquidPair(pair).mint(stakePool);
1043         IStakePool(stakePool).stakeFor(msg.sender);
1044     }
1045 
1046     function addStakeLiquidityETH(
1047         address stakePool,
1048         address token,
1049         uint256 amountTokenDesired,
1050         uint256 amountTokenMin,
1051         uint256 amountETHMin,
1052         uint256 deadline
1053     )
1054         external
1055         payable
1056         virtual
1057         override
1058         ensure(deadline)
1059         returns (
1060             uint256 amountToken,
1061             uint256 amountETH,
1062             uint256 liquidity
1063         )
1064     {
1065         require(IStakePoolController(controller).isStakePool(stakePool), "Router: Invalid stakePool");
1066         (amountToken, amountETH, liquidity) = _addLiquidityETH(
1067             IStakePool(stakePool).pair(),
1068             token,
1069             amountTokenDesired,
1070             amountTokenMin,
1071             amountETHMin,
1072             stakePool
1073         );
1074         IStakePool(stakePool).stakeFor(msg.sender);
1075     }
1076 
1077     function _addLiquidityETH(
1078         address pair,
1079         address token,
1080         uint256 amountTokenDesired,
1081         uint256 amountTokenMin,
1082         uint256 amountETHMin,
1083         address to
1084     )
1085         internal
1086         returns (
1087             uint256 amountToken,
1088             uint256 amountETH,
1089             uint256 liquidity
1090         )
1091     {
1092         (amountToken, amountETH) = _addLiquidity(pair, token, WETH, amountTokenDesired, msg.value, amountTokenMin, amountETHMin);
1093         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
1094         transferETHTo(amountETH, pair);
1095         liquidity = IValueLiquidPair(pair).mint(to);
1096         // refund dust eth, if any
1097         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
1098     }
1099 
1100     function addLiquidityETH(
1101         address pair,
1102         address token,
1103         uint256 amountTokenDesired,
1104         uint256 amountTokenMin,
1105         uint256 amountETHMin,
1106         address to,
1107         uint256 deadline
1108     )
1109         public
1110         payable
1111         virtual
1112         override
1113         ensure(deadline)
1114         returns (
1115             uint256 amountToken,
1116             uint256 amountETH,
1117             uint256 liquidity
1118         )
1119     {
1120         (amountToken, amountETH, liquidity) = _addLiquidityETH(pair, token, amountTokenDesired, amountTokenMin, amountETHMin, to);
1121     }
1122 
1123     // **** SWAP ****
1124     // requires the initial amount to have already been sent to the first pair
1125     function _swap(
1126         address tokenIn,
1127         uint256[] memory amounts,
1128         address[] memory path,
1129         address _to
1130     ) internal virtual {
1131         address input = tokenIn;
1132         for (uint256 i = 0; i < path.length; i++) {
1133             IValueLiquidPair pairV2 = IValueLiquidPair(path[i]);
1134             address token0 = pairV2.token0();
1135             uint256 amountOut = amounts[i + 1];
1136             (uint256 amount0Out, uint256 amount1Out, address output) =
1137                 input == token0 ? (uint256(0), amountOut, pairV2.token1()) : (amountOut, uint256(0), token0);
1138             address to = i < path.length - 1 ? path[i + 1] : _to;
1139             pairV2.swap(amount0Out, amount1Out, to, new bytes(0));
1140             input = output;
1141         }
1142     }
1143 
1144     function swapExactTokensForTokens(
1145         address tokenIn,
1146         address tokenOut,
1147         uint256 amountIn,
1148         uint256 amountOutMin,
1149         address[] memory path,
1150         address to,
1151         uint256 deadline,
1152         uint8 flag
1153     ) public virtual override discountCHI(flag) ensure(deadline) returns (uint256[] memory amounts) {
1154         amounts = IValueLiquidFormula(formula).getFactoryAmountsOut(factory, tokenIn, tokenOut, amountIn, path);
1155         require(amounts[amounts.length - 1] >= amountOutMin, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1156 
1157         TransferHelper.safeTransferFrom(tokenIn, msg.sender, path[0], amounts[0]);
1158         _swap(tokenIn, amounts, path, to);
1159     }
1160 
1161     function swapTokensForExactTokens(
1162         address tokenIn,
1163         address tokenOut,
1164         uint256 amountOut,
1165         uint256 amountInMax,
1166         address[] calldata path,
1167         address to,
1168         uint256 deadline,
1169         uint8 flag
1170     ) external virtual override discountCHI(flag) ensure(deadline) returns (uint256[] memory amounts) {
1171         amounts = IValueLiquidFormula(formula).getFactoryAmountsIn(factory, tokenIn, tokenOut, amountOut, path);
1172         require(amounts[0] <= amountInMax, "Router: EXCESSIVE_INPUT_AMOUNT");
1173         TransferHelper.safeTransferFrom(tokenIn, msg.sender, path[0], amounts[0]);
1174         _swap(tokenIn, amounts, path, to);
1175     }
1176 
1177     function swapExactETHForTokens(
1178         address tokenOut,
1179         uint256 amountOutMin,
1180         address[] calldata path,
1181         address to,
1182         uint256 deadline,
1183         uint8 flag
1184     ) external payable virtual override discountCHI(flag) ensure(deadline) returns (uint256[] memory amounts) {
1185         amounts = IValueLiquidFormula(formula).getFactoryAmountsOut(factory, WETH, tokenOut, msg.value, path);
1186         require(amounts[amounts.length - 1] >= amountOutMin, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1187         transferETHTo(amounts[0], path[0]);
1188         _swap(WETH, amounts, path, to);
1189     }
1190 
1191     function swapTokensForExactETH(
1192         address tokenIn,
1193         uint256 amountOut,
1194         uint256 amountInMax,
1195         address[] calldata path,
1196         address to,
1197         uint256 deadline,
1198         uint8 flag
1199     ) external virtual override discountCHI(flag) ensure(deadline) returns (uint256[] memory amounts) {
1200         amounts = IValueLiquidFormula(formula).getFactoryAmountsIn(factory, tokenIn, WETH, amountOut, path);
1201         require(amounts[0] <= amountInMax, "Router: EXCESSIVE_INPUT_AMOUNT");
1202         TransferHelper.safeTransferFrom(tokenIn, msg.sender, path[0], amounts[0]);
1203         _swap(tokenIn, amounts, path, address(this));
1204         transferAll(ETH_ADDRESS, to, amounts[amounts.length - 1]);
1205     }
1206 
1207     function swapExactTokensForETH(
1208         address tokenIn,
1209         uint256 amountIn,
1210         uint256 amountOutMin,
1211         address[] calldata path,
1212         address to,
1213         uint256 deadline,
1214         uint8 flag
1215     ) external virtual override discountCHI(flag) ensure(deadline) returns (uint256[] memory amounts) {
1216         amounts = IValueLiquidFormula(formula).getFactoryAmountsOut(factory, tokenIn, WETH, amountIn, path);
1217         require(amounts[amounts.length - 1] >= amountOutMin, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1218         TransferHelper.safeTransferFrom(tokenIn, msg.sender, path[0], amounts[0]);
1219         _swap(tokenIn, amounts, path, address(this));
1220         transferAll(ETH_ADDRESS, to, amounts[amounts.length - 1]);
1221     }
1222 
1223     function swapETHForExactTokens(
1224         address tokenOut,
1225         uint256 amountOut,
1226         address[] calldata path,
1227         address to,
1228         uint256 deadline,
1229         uint8 flag
1230     ) external payable virtual override discountCHI(flag) ensure(deadline) returns (uint256[] memory amounts) {
1231         amounts = IValueLiquidFormula(formula).getFactoryAmountsIn(factory, WETH, tokenOut, amountOut, path);
1232         require(amounts[0] <= msg.value, "Router: EXCESSIVE_INPUT_AMOUNT");
1233         transferETHTo(amounts[0], path[0]);
1234         _swap(WETH, amounts, path, to);
1235         // refund dust eth, if any
1236         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
1237     }
1238 
1239     // **** SWAP (supporting fee-on-transfer tokens) ****
1240     // requires the initial amount to have already been sent to the first pair
1241     function _swapSupportingFeeOnTransferTokens(
1242         address tokenIn,
1243         address[] memory path,
1244         address _to
1245     ) internal virtual {
1246         address input = tokenIn;
1247         for (uint256 i; i < path.length; i++) {
1248             IValueLiquidPair pair = IValueLiquidPair(path[i]);
1249 
1250             uint256 amountInput;
1251             uint256 amountOutput;
1252             address currentOutput;
1253             {
1254                 (address output, uint256 reserveInput, uint256 reserveOutput, uint32 tokenWeightInput, uint32 tokenWeightOutput, uint32 swapFee) =
1255                     IValueLiquidFormula(formula).getFactoryReserveAndWeights(factory, address(pair), input);
1256                 amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
1257                 amountOutput = IValueLiquidFormula(formula).getAmountOut(
1258                     amountInput,
1259                     reserveInput,
1260                     reserveOutput,
1261                     tokenWeightInput,
1262                     tokenWeightOutput,
1263                     swapFee
1264                 );
1265                 currentOutput = output;
1266             }
1267             (uint256 amount0Out, uint256 amount1Out) = input == pair.token0() ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
1268             address to = i < path.length - 1 ? path[i + 1] : _to;
1269             pair.swap(amount0Out, amount1Out, to, new bytes(0));
1270             input = currentOutput;
1271         }
1272     }
1273 
1274     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1275         address tokenIn,
1276         address tokenOut,
1277         uint256 amountIn,
1278         uint256 amountOutMin,
1279         address[] calldata path,
1280         address to,
1281         uint256 deadline,
1282         uint8 flag
1283     ) external virtual override discountCHI(flag) ensure(deadline) {
1284         TransferHelper.safeTransferFrom(tokenIn, msg.sender, path[0], amountIn);
1285         uint256 balanceBefore = IERC20(tokenOut).balanceOf(to);
1286         _swapSupportingFeeOnTransferTokens(tokenIn, path, to);
1287         require(IERC20(tokenOut).balanceOf(to).sub(balanceBefore) >= amountOutMin, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1288     }
1289 
1290     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1291         address tokenOut,
1292         uint256 amountOutMin,
1293         address[] calldata path,
1294         address to,
1295         uint256 deadline,
1296         uint8 flag
1297     ) external payable virtual override discountCHI(flag) ensure(deadline) {
1298         //            require(path[0] == WETH, 'Router: INVALID_PATH');
1299         uint256 amountIn = msg.value;
1300         IWETH(WETH).deposit{value: amountIn}();
1301         assert(IWETH(WETH).transfer(path[0], amountIn));
1302         uint256 balanceBefore = IERC20(tokenOut).balanceOf(to);
1303         _swapSupportingFeeOnTransferTokens(WETH, path, to);
1304         require(IERC20(tokenOut).balanceOf(to).sub(balanceBefore) >= amountOutMin, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1305     }
1306 
1307     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1308         address tokenIn,
1309         uint256 amountIn,
1310         uint256 amountOutMin,
1311         address[] calldata path,
1312         address to,
1313         uint256 deadline,
1314         uint8 flag
1315     ) external virtual override discountCHI(flag) ensure(deadline) {
1316         TransferHelper.safeTransferFrom(tokenIn, msg.sender, path[0], amountIn);
1317         _swapSupportingFeeOnTransferTokens(tokenIn, path, address(this));
1318         uint256 amountOut = IERC20(WETH).balanceOf(address(this));
1319         require(amountOut >= amountOutMin, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1320         transferAll(ETH_ADDRESS, to, amountOut);
1321     }
1322 
1323     function multihopBatchSwapExactIn(
1324         Swap[][] memory swapSequences,
1325         address tokenIn,
1326         address tokenOut,
1327         uint256 totalAmountIn,
1328         uint256 minTotalAmountOut,
1329         uint256 deadline,
1330         uint8 flag
1331     ) public payable virtual override discountCHI(flag) ensure(deadline) returns (uint256 totalAmountOut) {
1332         transferFromAll(tokenIn, totalAmountIn);
1333         uint256 balanceBefore;
1334         if (!isETH(tokenOut)) {
1335             balanceBefore = IERC20(tokenOut).balanceOf(msg.sender);
1336         }
1337 
1338         for (uint256 i = 0; i < swapSequences.length; i++) {
1339             uint256 tokenAmountOut;
1340             for (uint256 k = 0; k < swapSequences[i].length; k++) {
1341                 Swap memory swap = swapSequences[i][k];
1342                 if (k == 1) {
1343                     // Makes sure that on the second swap the output of the first was used
1344                     // so there is not intermediate token leftover
1345                     swap.swapAmount = tokenAmountOut;
1346                 }
1347 
1348                 if (swap.isBPool) {
1349                     TransferHelper.safeApprove(swap.tokenIn, swap.pool, swap.swapAmount);
1350 
1351                     (tokenAmountOut, ) = IBPool(swap.pool).swapExactAmountIn(
1352                         swap.tokenIn,
1353                         swap.swapAmount,
1354                         swap.tokenOut,
1355                         swap.limitReturnAmount,
1356                         swap.maxPrice
1357                     );
1358                 } else {
1359                     tokenAmountOut = _swapSingleSupportFeeOnTransferTokens(swap.tokenIn, swap.tokenOut, swap.pool, swap.swapAmount, swap.limitReturnAmount);
1360                 }
1361             }
1362 
1363             // This takes the amountOut of the last swap
1364             totalAmountOut = tokenAmountOut.add(totalAmountOut);
1365         }
1366 
1367         transferAll(tokenOut, msg.sender, totalAmountOut);
1368         transferAll(tokenIn, msg.sender, getBalance(tokenIn));
1369 
1370         if (isETH(tokenOut)) {
1371             require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
1372         } else {
1373             require(IERC20(tokenOut).balanceOf(msg.sender).sub(balanceBefore) >= minTotalAmountOut, "<minTotalAmountOut");
1374         }
1375     }
1376 
1377     function multihopBatchSwapExactOut(
1378         Swap[][] memory swapSequences,
1379         address tokenIn,
1380         address tokenOut,
1381         uint256 maxTotalAmountIn,
1382         uint256 deadline,
1383         uint8 flag
1384     ) public payable virtual override discountCHI(flag) ensure(deadline) returns (uint256 totalAmountIn) {
1385         transferFromAll(tokenIn, maxTotalAmountIn);
1386 
1387         for (uint256 i = 0; i < swapSequences.length; i++) {
1388             uint256 tokenAmountInFirstSwap;
1389             // Specific code for a simple swap and a multihop (2 swaps in sequence)
1390             if (swapSequences[i].length == 1) {
1391                 Swap memory swap = swapSequences[i][0];
1392                 tokenAmountInFirstSwap = _swapSingleMixOut(
1393                     swap.tokenIn,
1394                     swap.tokenOut,
1395                     swap.pool,
1396                     swap.swapAmount,
1397                     swap.limitReturnAmount,
1398                     swap.maxPrice,
1399                     swap.isBPool
1400                 );
1401             } else {
1402                 // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
1403                 // of token C. But first we need to buy B with A so we can then buy C with B
1404                 // To get the exact amount of C we then first need to calculate how much B we'll need:
1405                 uint256 intermediateTokenAmount;
1406                 // This would be token B as described above
1407                 Swap memory secondSwap = swapSequences[i][1];
1408                 if (secondSwap.isBPool) {
1409                     IBPool poolSecondSwap = IBPool(secondSwap.pool);
1410                     intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
1411                         poolSecondSwap.getBalance(secondSwap.tokenIn),
1412                         poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
1413                         poolSecondSwap.getBalance(secondSwap.tokenOut),
1414                         poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
1415                         secondSwap.swapAmount,
1416                         poolSecondSwap.swapFee()
1417                     );
1418                 } else {
1419                     address[] memory paths = new address[](1);
1420                     paths[0] = secondSwap.pool;
1421                     uint256[] memory amounts =
1422                         IValueLiquidFormula(formula).getFactoryAmountsIn(factory, secondSwap.tokenIn, secondSwap.tokenOut, secondSwap.swapAmount, paths);
1423                     intermediateTokenAmount = amounts[0];
1424                     require(intermediateTokenAmount <= secondSwap.limitReturnAmount, "Router: EXCESSIVE_INPUT_AMOUNT");
1425                 }
1426 
1427                 //// Buy intermediateTokenAmount of token B with A in the first pool
1428                 Swap memory firstSwap = swapSequences[i][0];
1429                 tokenAmountInFirstSwap = _swapSingleMixOut(
1430                     firstSwap.tokenIn,
1431                     firstSwap.tokenOut,
1432                     firstSwap.pool,
1433                     intermediateTokenAmount,
1434                     firstSwap.limitReturnAmount,
1435                     firstSwap.maxPrice,
1436                     firstSwap.isBPool
1437                 );
1438 
1439                 //// Buy the final amount of token C desired
1440                 if (secondSwap.isBPool) {
1441                     _swapPBoolOut(
1442                         secondSwap.tokenIn,
1443                         secondSwap.tokenOut,
1444                         secondSwap.pool,
1445                         secondSwap.swapAmount,
1446                         secondSwap.limitReturnAmount,
1447                         secondSwap.maxPrice
1448                     );
1449                 } else {
1450                     _swapSingle(secondSwap.tokenIn, secondSwap.pool, intermediateTokenAmount, secondSwap.swapAmount);
1451                 }
1452             }
1453 
1454             totalAmountIn = tokenAmountInFirstSwap.add(totalAmountIn);
1455         }
1456 
1457         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
1458 
1459         transferAll(tokenOut, msg.sender, getBalance(tokenOut));
1460         transferAll(tokenIn, msg.sender, getBalance(tokenIn));
1461     }
1462 
1463     function transferFromAll(address token, uint256 amount) internal returns (bool) {
1464         if (isETH(token)) {
1465             IWETH(WETH).deposit{value: msg.value}();
1466         } else {
1467             TransferHelper.safeTransferFrom(token, msg.sender, address(this), amount);
1468         }
1469         return true;
1470     }
1471 
1472     function getBalance(address token) internal view returns (uint256) {
1473         if (isETH(token)) {
1474             return IWETH(WETH).balanceOf(address(this));
1475         } else {
1476             return IERC20(token).balanceOf(address(this));
1477         }
1478     }
1479 
1480     function _swapSingleMixOut(
1481         address tokenIn,
1482         address tokenOut,
1483         address pool,
1484         uint256 swapAmount,
1485         uint256 limitReturnAmount,
1486         uint256 maxPrice,
1487         bool isBPool
1488     ) internal returns (uint256 tokenAmountIn) {
1489         if (isBPool) {
1490             return _swapPBoolOut(tokenIn, tokenOut, pool, swapAmount, limitReturnAmount, maxPrice);
1491         } else {
1492             address[] memory paths = new address[](1);
1493             paths[0] = pool;
1494             uint256[] memory amounts = IValueLiquidFormula(formula).getFactoryAmountsIn(factory, tokenIn, tokenOut, swapAmount, paths);
1495             tokenAmountIn = amounts[0];
1496             require(tokenAmountIn <= limitReturnAmount, "Router: EXCESSIVE_INPUT_AMOUNT");
1497 
1498             _swapSingle(tokenIn, pool, tokenAmountIn, amounts[1]);
1499         }
1500     }
1501 
1502     function _swapPBoolOut(
1503         address tokenIn,
1504         address tokenOut,
1505         address pool,
1506         uint256 swapAmount,
1507         uint256 limitReturnAmount,
1508         uint256 maxPrice
1509     ) internal returns (uint256 tokenAmountIn) {
1510         TransferHelper.safeApprove(tokenIn, pool, limitReturnAmount);
1511 
1512         (tokenAmountIn, ) = IBPool(pool).swapExactAmountOut(tokenIn, limitReturnAmount, tokenOut, swapAmount, maxPrice);
1513     }
1514 
1515     function _swapSingle(
1516         address tokenIn,
1517         address pair,
1518         uint256 targetSwapAmount,
1519         uint256 targetOutAmount
1520     ) internal {
1521         TransferHelper.safeTransfer(tokenIn, pair, targetSwapAmount);
1522         (uint256 amount0Out, uint256 amount1Out) = tokenIn == IValueLiquidPair(pair).token0() ? (uint256(0), targetOutAmount) : (targetOutAmount, uint256(0));
1523 
1524         IValueLiquidPair(pair).swap(amount0Out, amount1Out, address(this), new bytes(0));
1525     }
1526 
1527     function _swapSingleSupportFeeOnTransferTokens(
1528         address tokenIn,
1529         address tokenOut,
1530         address pool,
1531         uint256 swapAmount,
1532         uint256 limitReturnAmount
1533     ) internal returns (uint256 tokenAmountOut) {
1534         TransferHelper.safeTransfer(tokenIn, pool, swapAmount);
1535 
1536         uint256 amountOutput;
1537         {
1538             (, uint256 reserveInput, uint256 reserveOutput, uint32 tokenWeightInput, uint32 tokenWeightOutput, uint32 swapFee) =
1539                 IValueLiquidFormula(formula).getFactoryReserveAndWeights(factory, pool, tokenIn);
1540             uint256 amountInput = IERC20(tokenIn).balanceOf(pool).sub(reserveInput);
1541             amountOutput = IValueLiquidFormula(formula).getAmountOut(amountInput, reserveInput, reserveOutput, tokenWeightInput, tokenWeightOutput, swapFee);
1542         }
1543         uint256 balanceBefore = IERC20(tokenOut).balanceOf(address(this));
1544         (uint256 amount0Out, uint256 amount1Out) = tokenIn == IValueLiquidPair(pool).token0() ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
1545         IValueLiquidPair(pool).swap(amount0Out, amount1Out, address(this), new bytes(0));
1546 
1547         tokenAmountOut = IERC20(tokenOut).balanceOf(address(this)).sub(balanceBefore);
1548         require(tokenAmountOut >= limitReturnAmount, "Router: INSUFFICIENT_OUTPUT_AMOUNT");
1549     }
1550 
1551     function transferETHTo(uint256 amount, address to) internal {
1552         IWETH(WETH).deposit{value: amount}();
1553         assert(IWETH(WETH).transfer(to, amount));
1554     }
1555 
1556     function transferAll(
1557         address token,
1558         address to,
1559         uint256 amount
1560     ) internal returns (bool) {
1561         if (amount == 0) {
1562             return true;
1563         }
1564 
1565         if (isETH(token)) {
1566             IWETH(WETH).withdraw(amount);
1567             TransferHelper.safeTransferETH(to, amount);
1568         } else {
1569             TransferHelper.safeTransfer(token, to, amount);
1570         }
1571         return true;
1572     }
1573 
1574     function isETH(address token) internal pure returns (bool) {
1575         return (token == ETH_ADDRESS);
1576     }
1577 }