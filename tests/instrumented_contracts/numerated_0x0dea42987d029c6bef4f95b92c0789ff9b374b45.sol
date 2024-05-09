1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      *
58      * _Available since v2.4.0._
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      * - The divisor cannot be zero.
115      *
116      * _Available since v2.4.0._
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         // Solidity only automatically asserts when dividing by 0
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      *
153      * _Available since v2.4.0._
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 interface PoolInterface {
162     function swapExactAmountIn(address, uint, address, uint, uint) external returns (uint, uint);
163     function swapExactAmountOut(address, uint, address, uint, uint) external returns (uint, uint);
164     function calcInGivenOut(uint, uint, uint, uint, uint, uint) external pure returns (uint);
165     function calcOutGivenIn(uint, uint, uint, uint, uint, uint) external pure returns (uint);
166     function getDenormalizedWeight(address) external view returns (uint);
167     function getBalance(address) external view returns (uint);
168     function swapFee() external view returns (uint);
169 }
170 
171 interface TokenInterface {
172     function balanceOf(address) external view returns (uint);
173     function allowance(address, address) external view returns (uint);
174     function approve(address, uint) external returns (bool);
175     function transfer(address, uint) external returns (bool);
176     function transferFrom(address, address, uint) external returns (bool);
177     function deposit() external payable;
178     function withdraw(uint) external;
179 }
180 
181 interface RegistryInterface {
182     function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
183 }
184 
185 interface IFreeFromUpTo {
186     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
187 }
188 
189 contract ExchangeProxy {
190     using SafeMath for uint256;
191 
192     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
193 
194     modifier discountCHI(uint8 flag) {
195         if ((flag & 0x1) == 0) {
196             _;
197         } else {
198             uint256 gasStart = gasleft();
199             _;
200             uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
201             chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
202         }
203     }
204 
205     struct Pool {
206         address pool;
207         uint    tokenBalanceIn;
208         uint    tokenWeightIn;
209         uint    tokenBalanceOut;
210         uint    tokenWeightOut;
211         uint    swapFee;
212         uint    effectiveLiquidity;
213     }
214 
215     struct Swap {
216         address pool;
217         address tokenIn;
218         address tokenOut;
219         uint    swapAmount; // tokenInAmount / tokenOutAmount
220         uint    limitReturnAmount; // minAmountOut / maxAmountIn
221         uint    maxPrice;
222     }
223 
224     TokenInterface weth;
225     RegistryInterface registry;
226     address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
227     uint private constant BONE = 10**18;
228 
229     address public governance;
230 
231     constructor(address _weth) public {
232         weth = TokenInterface(_weth);
233         governance = tx.origin;
234     }
235 
236     function setGovernance(address _governance) external {
237         require(msg.sender == governance, "!governance");
238         governance = _governance;
239     }
240 
241     function setRegistry(address _registry) external {
242         require(msg.sender == governance, "!governance");
243         registry = RegistryInterface(_registry);
244     }
245 
246     function batchSwapExactIn(
247         Swap[] memory swaps,
248         TokenInterface tokenIn,
249         TokenInterface tokenOut,
250         uint totalAmountIn,
251         uint minTotalAmountOut,
252         uint8 flag
253     )
254     public payable discountCHI(flag)
255     returns (uint totalAmountOut)
256     {
257         transferFromAll(tokenIn, totalAmountIn);
258 
259         for (uint i = 0; i < swaps.length; i++) {
260             Swap memory swap = swaps[i];
261             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
262             PoolInterface pool = PoolInterface(swap.pool);
263 
264             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
265                 SwapTokenIn.approve(swap.pool, 0);
266             }
267             SwapTokenIn.approve(swap.pool, swap.swapAmount);
268 
269             (uint tokenAmountOut,) = pool.swapExactAmountIn(
270                 swap.tokenIn,
271                 swap.swapAmount,
272                 swap.tokenOut,
273                 swap.limitReturnAmount,
274                 swap.maxPrice
275             );
276             totalAmountOut = tokenAmountOut.add(totalAmountOut);
277         }
278 
279         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
280 
281         transferAll(tokenOut, totalAmountOut);
282         transferAll(tokenIn, getBalance(tokenIn));
283     }
284 
285     function batchSwapExactOut(
286         Swap[] memory swaps,
287         TokenInterface tokenIn,
288         TokenInterface tokenOut,
289         uint maxTotalAmountIn,
290         uint8 flag
291     )
292     public payable discountCHI(flag)
293     returns (uint totalAmountIn)
294     {
295         transferFromAll(tokenIn, maxTotalAmountIn);
296 
297         for (uint i = 0; i < swaps.length; i++) {
298             Swap memory swap = swaps[i];
299             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
300             PoolInterface pool = PoolInterface(swap.pool);
301 
302             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
303                 SwapTokenIn.approve(swap.pool, 0);
304             }
305             SwapTokenIn.approve(swap.pool, swap.limitReturnAmount);
306 
307             (uint tokenAmountIn,) = pool.swapExactAmountOut(
308                 swap.tokenIn,
309                 swap.limitReturnAmount,
310                 swap.tokenOut,
311                 swap.swapAmount,
312                 swap.maxPrice
313             );
314             totalAmountIn = tokenAmountIn.add(totalAmountIn);
315         }
316         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
317 
318         transferAll(tokenOut, getBalance(tokenOut));
319         transferAll(tokenIn, getBalance(tokenIn));
320 
321     }
322 
323     function multihopBatchSwapExactIn(
324         Swap[][] memory swapSequences,
325         TokenInterface tokenIn,
326         TokenInterface tokenOut,
327         uint totalAmountIn,
328         uint minTotalAmountOut,
329         uint8 flag
330     )
331     public payable discountCHI(flag)
332     returns (uint totalAmountOut)
333     {
334 
335         transferFromAll(tokenIn, totalAmountIn);
336 
337         for (uint i = 0; i < swapSequences.length; i++) {
338             uint tokenAmountOut;
339             for (uint k = 0; k < swapSequences[i].length; k++) {
340                 Swap memory swap = swapSequences[i][k];
341                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
342                 if (k == 1) {
343                     // Makes sure that on the second swap the output of the first was used
344                     // so there is not intermediate token leftover
345                     swap.swapAmount = tokenAmountOut;
346                 }
347 
348                 PoolInterface pool = PoolInterface(swap.pool);
349                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
350                     SwapTokenIn.approve(swap.pool, 0);
351                 }
352                 SwapTokenIn.approve(swap.pool, swap.swapAmount);
353                 (tokenAmountOut,) = pool.swapExactAmountIn(
354                     swap.tokenIn,
355                     swap.swapAmount,
356                     swap.tokenOut,
357                     swap.limitReturnAmount,
358                     swap.maxPrice
359                 );
360             }
361             // This takes the amountOut of the last swap
362             totalAmountOut = tokenAmountOut.add(totalAmountOut);
363         }
364 
365         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
366 
367         transferAll(tokenOut, totalAmountOut);
368         transferAll(tokenIn, getBalance(tokenIn));
369 
370     }
371 
372     function multihopBatchSwapExactOut(
373         Swap[][] memory swapSequences,
374         TokenInterface tokenIn,
375         TokenInterface tokenOut,
376         uint maxTotalAmountIn,
377         uint8 flag
378     )
379     public payable discountCHI(flag)
380     returns (uint totalAmountIn)
381     {
382 
383         transferFromAll(tokenIn, maxTotalAmountIn);
384 
385         for (uint i = 0; i < swapSequences.length; i++) {
386             uint tokenAmountInFirstSwap;
387             // Specific code for a simple swap and a multihop (2 swaps in sequence)
388             if (swapSequences[i].length == 1) {
389                 Swap memory swap = swapSequences[i][0];
390                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
391 
392                 PoolInterface pool = PoolInterface(swap.pool);
393                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
394                     SwapTokenIn.approve(swap.pool, 0);
395                 }
396                 SwapTokenIn.approve(swap.pool, swap.limitReturnAmount);
397 
398                 (tokenAmountInFirstSwap,) = pool.swapExactAmountOut(
399                     swap.tokenIn,
400                     swap.limitReturnAmount,
401                     swap.tokenOut,
402                     swap.swapAmount,
403                     swap.maxPrice
404                 );
405             } else {
406                 // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
407                 // of token C. But first we need to buy B with A so we can then buy C with B
408                 // To get the exact amount of C we then first need to calculate how much B we'll need:
409                 uint intermediateTokenAmount; // This would be token B as described above
410                 Swap memory secondSwap = swapSequences[i][1];
411                 PoolInterface poolSecondSwap = PoolInterface(secondSwap.pool);
412                 intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
413                     poolSecondSwap.getBalance(secondSwap.tokenIn),
414                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
415                     poolSecondSwap.getBalance(secondSwap.tokenOut),
416                     poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
417                     secondSwap.swapAmount,
418                     poolSecondSwap.swapFee()
419                 );
420 
421                 //// Buy intermediateTokenAmount of token B with A in the first pool
422                 Swap memory firstSwap = swapSequences[i][0];
423                 TokenInterface FirstSwapTokenIn = TokenInterface(firstSwap.tokenIn);
424                 PoolInterface poolFirstSwap = PoolInterface(firstSwap.pool);
425                 if (FirstSwapTokenIn.allowance(address(this), firstSwap.pool) < uint(-1)) {
426                     FirstSwapTokenIn.approve(firstSwap.pool, uint(-1));
427                 }
428 
429                 (tokenAmountInFirstSwap,) = poolFirstSwap.swapExactAmountOut(
430                     firstSwap.tokenIn,
431                     firstSwap.limitReturnAmount,
432                     firstSwap.tokenOut,
433                     intermediateTokenAmount, // This is the amount of token B we need
434                     firstSwap.maxPrice
435                 );
436 
437                 //// Buy the final amount of token C desired
438                 TokenInterface SecondSwapTokenIn = TokenInterface(secondSwap.tokenIn);
439                 if (SecondSwapTokenIn.allowance(address(this), secondSwap.pool) < uint(-1)) {
440                     SecondSwapTokenIn.approve(secondSwap.pool, uint(-1));
441                 }
442 
443                 poolSecondSwap.swapExactAmountOut(
444                     secondSwap.tokenIn,
445                     secondSwap.limitReturnAmount,
446                     secondSwap.tokenOut,
447                     secondSwap.swapAmount,
448                     secondSwap.maxPrice
449                 );
450             }
451             totalAmountIn = tokenAmountInFirstSwap.add(totalAmountIn);
452         }
453 
454         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
455 
456         transferAll(tokenOut, getBalance(tokenOut));
457         transferAll(tokenIn, getBalance(tokenIn));
458 
459     }
460 
461     function smartSwapExactIn(
462         TokenInterface tokenIn,
463         TokenInterface tokenOut,
464         uint totalAmountIn,
465         uint minTotalAmountOut,
466         uint nPools,
467         uint8 flag
468     )
469     public payable discountCHI(flag)
470     returns (uint totalAmountOut)
471     {
472         Swap[] memory swaps;
473         if (isETH(tokenIn)) {
474             (swaps,) = viewSplitExactIn(address(weth), address(tokenOut), totalAmountIn, nPools);
475         } else if (isETH(tokenOut)){
476             (swaps,) = viewSplitExactIn(address(tokenIn), address(weth), totalAmountIn, nPools);
477         } else {
478             (swaps,) = viewSplitExactIn(address(tokenIn), address(tokenOut), totalAmountIn, nPools);
479         }
480 
481         totalAmountOut = batchSwapExactIn(swaps, tokenIn, tokenOut, totalAmountIn, minTotalAmountOut, 0x0);
482     }
483 
484     function smartSwapExactOut(
485         TokenInterface tokenIn,
486         TokenInterface tokenOut,
487         uint totalAmountOut,
488         uint maxTotalAmountIn,
489         uint nPools,
490         uint8 flag
491     )
492     public payable discountCHI(flag)
493     returns (uint totalAmountIn)
494     {
495         Swap[] memory swaps;
496         if (isETH(tokenIn)) {
497             (swaps,) = viewSplitExactOut(address(weth), address(tokenOut), totalAmountOut, nPools);
498         } else if (isETH(tokenOut)){
499             (swaps,) = viewSplitExactOut(address(tokenIn), address(weth), totalAmountOut, nPools);
500         } else {
501             (swaps,) = viewSplitExactOut(address(tokenIn), address(tokenOut), totalAmountOut, nPools);
502         }
503 
504         totalAmountIn = batchSwapExactOut(swaps, tokenIn, tokenOut, maxTotalAmountIn, 0x0);
505     }
506 
507     function viewSplitExactIn(
508         address tokenIn,
509         address tokenOut,
510         uint swapAmount,
511         uint nPools
512     )
513     public view
514     returns (Swap[] memory swaps, uint totalOutput)
515     {
516         address[] memory poolAddresses = registry.getBestPoolsWithLimit(tokenIn, tokenOut, nPools);
517 
518         Pool[] memory pools = new Pool[](poolAddresses.length);
519         uint sumEffectiveLiquidity;
520         for (uint i = 0; i < poolAddresses.length; i++) {
521             pools[i] = getPoolData(tokenIn, tokenOut, poolAddresses[i]);
522             sumEffectiveLiquidity = sumEffectiveLiquidity.add(pools[i].effectiveLiquidity);
523         }
524 
525         uint[] memory bestInputAmounts = new uint[](pools.length);
526         uint totalInputAmount;
527         for (uint i = 0; i < pools.length; i++) {
528             bestInputAmounts[i] = swapAmount.mul(pools[i].effectiveLiquidity).div(sumEffectiveLiquidity);
529             totalInputAmount = totalInputAmount.add(bestInputAmounts[i]);
530         }
531 
532         if (totalInputAmount < swapAmount) {
533             bestInputAmounts[0] = bestInputAmounts[0].add(swapAmount.sub(totalInputAmount));
534         } else {
535             bestInputAmounts[0] = bestInputAmounts[0].sub(totalInputAmount.sub(swapAmount));
536         }
537 
538         swaps = new Swap[](pools.length);
539 
540         for (uint i = 0; i < pools.length; i++) {
541             swaps[i] = Swap({
542             pool: pools[i].pool,
543             tokenIn: tokenIn,
544             tokenOut: tokenOut,
545             swapAmount: bestInputAmounts[i],
546             limitReturnAmount: 0,
547             maxPrice: uint(-1)
548             });
549         }
550 
551         totalOutput = calcTotalOutExactIn(bestInputAmounts, pools);
552 
553         return (swaps, totalOutput);
554     }
555 
556     function viewSplitExactOut(
557         address tokenIn,
558         address tokenOut,
559         uint swapAmount,
560         uint nPools
561     )
562     public view
563     returns (Swap[] memory swaps, uint totalOutput)
564     {
565         address[] memory poolAddresses = registry.getBestPoolsWithLimit(tokenIn, tokenOut, nPools);
566 
567         Pool[] memory pools = new Pool[](poolAddresses.length);
568         uint sumEffectiveLiquidity;
569         for (uint i = 0; i < poolAddresses.length; i++) {
570             pools[i] = getPoolData(tokenIn, tokenOut, poolAddresses[i]);
571             sumEffectiveLiquidity = sumEffectiveLiquidity.add(pools[i].effectiveLiquidity);
572         }
573 
574         uint[] memory bestInputAmounts = new uint[](pools.length);
575         uint totalInputAmount;
576         for (uint i = 0; i < pools.length; i++) {
577             bestInputAmounts[i] = swapAmount.mul(pools[i].effectiveLiquidity).div(sumEffectiveLiquidity);
578             totalInputAmount = totalInputAmount.add(bestInputAmounts[i]);
579         }
580 
581         if (totalInputAmount < swapAmount) {
582             bestInputAmounts[0] = bestInputAmounts[0].add(swapAmount.sub(totalInputAmount));
583         } else {
584             bestInputAmounts[0] = bestInputAmounts[0].sub(totalInputAmount.sub(swapAmount));
585         }
586 
587         swaps = new Swap[](pools.length);
588 
589         for (uint i = 0; i < pools.length; i++) {
590             swaps[i] = Swap({
591             pool: pools[i].pool,
592             tokenIn: tokenIn,
593             tokenOut: tokenOut,
594             swapAmount: bestInputAmounts[i],
595             limitReturnAmount: uint(-1),
596             maxPrice: uint(-1)
597             });
598         }
599 
600         totalOutput = calcTotalOutExactOut(bestInputAmounts, pools);
601 
602         return (swaps, totalOutput);
603     }
604 
605     function getPoolData(
606         address tokenIn,
607         address tokenOut,
608         address poolAddress
609     )
610     internal view
611     returns (Pool memory)
612     {
613         PoolInterface pool = PoolInterface(poolAddress);
614         uint tokenBalanceIn = pool.getBalance(tokenIn);
615         uint tokenBalanceOut = pool.getBalance(tokenOut);
616         uint tokenWeightIn = pool.getDenormalizedWeight(tokenIn);
617         uint tokenWeightOut = pool.getDenormalizedWeight(tokenOut);
618         uint swapFee = pool.swapFee();
619 
620         uint effectiveLiquidity = calcEffectiveLiquidity(
621             tokenWeightIn,
622             tokenBalanceOut,
623             tokenWeightOut
624         );
625         Pool memory returnPool = Pool({
626         pool: poolAddress,
627         tokenBalanceIn: tokenBalanceIn,
628         tokenWeightIn: tokenWeightIn,
629         tokenBalanceOut: tokenBalanceOut,
630         tokenWeightOut: tokenWeightOut,
631         swapFee: swapFee,
632         effectiveLiquidity: effectiveLiquidity
633         });
634 
635         return returnPool;
636     }
637 
638     function calcEffectiveLiquidity(
639         uint tokenWeightIn,
640         uint tokenBalanceOut,
641         uint tokenWeightOut
642     )
643     internal pure
644     returns (uint effectiveLiquidity)
645     {
646 
647         // Bo * wi/(wi+wo)
648         effectiveLiquidity =
649         tokenWeightIn.mul(BONE).div(
650             tokenWeightOut.add(tokenWeightIn)
651         ).mul(tokenBalanceOut).div(BONE);
652 
653         return effectiveLiquidity;
654     }
655 
656     function calcTotalOutExactIn(
657         uint[] memory bestInputAmounts,
658         Pool[] memory bestPools
659     )
660     internal pure
661     returns (uint totalOutput)
662     {
663         totalOutput = 0;
664         for (uint i = 0; i < bestInputAmounts.length; i++) {
665             uint output = PoolInterface(bestPools[i].pool).calcOutGivenIn(
666                 bestPools[i].tokenBalanceIn,
667                 bestPools[i].tokenWeightIn,
668                 bestPools[i].tokenBalanceOut,
669                 bestPools[i].tokenWeightOut,
670                 bestInputAmounts[i],
671                 bestPools[i].swapFee
672             );
673 
674             totalOutput = totalOutput.add(output);
675         }
676         return totalOutput;
677     }
678 
679     function calcTotalOutExactOut(
680         uint[] memory bestInputAmounts,
681         Pool[] memory bestPools
682     )
683     internal pure
684     returns (uint totalOutput)
685     {
686         totalOutput = 0;
687         for (uint i = 0; i < bestInputAmounts.length; i++) {
688             uint output = PoolInterface(bestPools[i].pool).calcInGivenOut(
689                 bestPools[i].tokenBalanceIn,
690                 bestPools[i].tokenWeightIn,
691                 bestPools[i].tokenBalanceOut,
692                 bestPools[i].tokenWeightOut,
693                 bestInputAmounts[i],
694                 bestPools[i].swapFee
695             );
696 
697             totalOutput = totalOutput.add(output);
698         }
699         return totalOutput;
700     }
701 
702     function transferFromAll(TokenInterface token, uint amount) internal returns(bool) {
703         if (isETH(token)) {
704             weth.deposit{value : msg.value}();
705         } else {
706             require(token.transferFrom(msg.sender, address(this), amount), "ERR_TRANSFER_FAILED");
707         }
708     }
709 
710     function getBalance(TokenInterface token) internal view returns (uint) {
711         if (isETH(token)) {
712             return weth.balanceOf(address(this));
713         } else {
714             return token.balanceOf(address(this));
715         }
716     }
717 
718     function transferAll(TokenInterface token, uint amount) internal returns(bool) {
719         if (amount == 0) {
720             return true;
721         }
722 
723         if (isETH(token)) {
724             weth.withdraw(amount);
725             (bool xfer,) = msg.sender.call{value : amount}("");
726             require(xfer, "ERR_ETH_FAILED");
727         } else {
728             require(token.transfer(msg.sender, amount), "ERR_TRANSFER_FAILED");
729         }
730     }
731 
732     function isETH(TokenInterface token) internal pure returns(bool) {
733         return (address(token) == ETH_ADDRESS);
734     }
735 
736     /**
737      * This function allows governance to take unsupported tokens out of the contract.
738      * This is in an effort to make someone whole, should they seriously mess up.
739      * There is no guarantee governance will vote to return these.
740      * It also allows for removal of airdropped tokens.
741      */
742     function governanceRecoverUnsupported(TokenInterface _token, uint _amount, address _to) external {
743         require(msg.sender == governance, "!governance");
744         if (isETH(_token)) {
745             (bool xfer,) = _to.call{value : _amount}("");
746             require(xfer, "ERR_ETH_FAILED");
747         } else {
748             require(_token.transfer(_to, _amount), "ERR_TRANSFER_FAILED");
749         }
750     }
751 
752     receive() external payable {}
753 }