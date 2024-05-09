1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity 0.5.12;
15 pragma experimental ABIEncoderV2;
16 
17 pragma solidity ^0.5.0;
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations with added overflow
21  * checks.
22  *
23  * Arithmetic operations in Solidity wrap on overflow. This can easily result
24  * in bugs, because programmers usually assume that an overflow raises an
25  * error, which is the standard behavior in high level programming languages.
26  * `SafeMath` restores this intuition by reverting the transaction when an
27  * operation overflows.
28  *
29  * Using this library instead of the unchecked operations eliminates an entire
30  * class of bugs, so it's recommended to use it always.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      *
71      * _Available since v2.4.0._
72      */
73     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the multiplication of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `*` operator.
85      *
86      * Requirements:
87      * - Multiplication cannot overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b, "SafeMath: multiplication overflow");
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      *
129      * _Available since v2.4.0._
130      */
131     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         // Solidity only automatically asserts when dividing by 0
133         require(b > 0, errorMessage);
134         uint256 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         return mod(a, b, "SafeMath: modulo by zero");
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts with custom message when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      *
166      * _Available since v2.4.0._
167      */
168     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b != 0, errorMessage);
170         return a % b;
171     }
172 }
173 
174 /*
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with GSN meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 contract Context {
185     // Empty internal constructor, to prevent people from mistakenly deploying
186     // an instance of this contract, which should be used via inheritance.
187     constructor () internal { }
188     // solhint-disable-previous-line no-empty-blocks
189 
190     function _msgSender() internal view returns (address payable) {
191         return msg.sender;
192     }
193 
194     function _msgData() internal view returns (bytes memory) {
195         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
196         return msg.data;
197     }
198 }
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * This module is used through inheritance. It will make available the modifier
206  * `onlyOwner`, which can be applied to your functions to restrict their use to
207  * the owner.
208  */
209 contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214     /**
215      * @dev Initializes the contract setting the deployer as the initial owner.
216      */
217     constructor () internal {
218         address msgSender = _msgSender();
219         _owner = msgSender;
220         emit OwnershipTransferred(address(0), msgSender);
221     }
222 
223     /**
224      * @dev Returns the address of the current owner.
225      */
226     function owner() public view returns (address) {
227         return _owner;
228     }
229 
230     /**
231      * @dev Throws if called by any account other than the owner.
232      */
233     modifier onlyOwner() {
234         require(isOwner(), "Ownable: caller is not the owner");
235         _;
236     }
237 
238     /**
239      * @dev Returns true if the caller is the current owner.
240      */
241     function isOwner() public view returns (bool) {
242         return _msgSender() == _owner;
243     }
244 
245     /**
246      * @dev Leaves the contract without owner. It will not be possible to call
247      * `onlyOwner` functions anymore. Can only be called by the current owner.
248      *
249      * NOTE: Renouncing ownership will leave the contract without an owner,
250      * thereby removing any functionality that is only available to the owner.
251      */
252     function renounceOwnership() public onlyOwner {
253         emit OwnershipTransferred(_owner, address(0));
254         _owner = address(0);
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public onlyOwner {
262         _transferOwnership(newOwner);
263     }
264 
265     /**
266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
267      */
268     function _transferOwnership(address newOwner) internal {
269         require(newOwner != address(0), "Ownable: new owner is the zero address");
270         emit OwnershipTransferred(_owner, newOwner);
271         _owner = newOwner;
272     }
273 }
274 
275 interface PoolInterface {
276     function swapExactAmountIn(address, uint, address, uint, uint) external returns (uint, uint);
277     function swapExactAmountOut(address, uint, address, uint, uint) external returns (uint, uint);
278     function calcInGivenOut(uint, uint, uint, uint, uint, uint) external pure returns (uint);
279     function calcOutGivenIn(uint, uint, uint, uint, uint, uint) external pure returns (uint);
280     function getDenormalizedWeight(address) external view returns (uint);
281     function getBalance(address) external view returns (uint);
282     function getSwapFee() external view returns (uint);
283 }
284 
285 interface TokenInterface {
286     function balanceOf(address) external view returns (uint);
287     function allowance(address, address) external view returns (uint);
288     function approve(address, uint) external returns (bool);
289     function transfer(address, uint) external returns (bool);
290     function transferFrom(address, address, uint) external returns (bool);
291     function deposit() external payable;
292     function withdraw(uint) external;
293 }
294 
295 interface RegistryInterface {
296     function getBestPoolsWithLimit(address, address, uint) external view returns (address[] memory);
297 }
298 
299 contract ExchangeProxy is Ownable {
300 
301     using SafeMath for uint256;
302 
303     struct Pool {
304         address pool;
305         uint    tokenBalanceIn;
306         uint    tokenWeightIn;
307         uint    tokenBalanceOut;
308         uint    tokenWeightOut;
309         uint    swapFee;
310         uint    effectiveLiquidity;
311     }
312 
313     struct Swap {
314         address pool;
315         address tokenIn;
316         address tokenOut;
317         uint    swapAmount; // tokenInAmount / tokenOutAmount
318         uint    limitReturnAmount; // minAmountOut / maxAmountIn
319         uint    maxPrice;
320     }
321 
322     TokenInterface weth;
323     RegistryInterface registry;
324     address private constant ETH_ADDRESS = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
325     uint private constant BONE = 10**18;
326 
327     constructor(address _weth) public {
328         weth = TokenInterface(_weth);
329     }
330 
331     function setRegistry(address _registry) external onlyOwner {
332         registry = RegistryInterface(_registry);
333     }
334 
335     function batchSwapExactIn(
336         Swap[] memory swaps,
337         TokenInterface tokenIn,
338         TokenInterface tokenOut,
339         uint totalAmountIn,
340         uint minTotalAmountOut
341     )
342         public payable
343         returns (uint totalAmountOut)
344     {
345         transferFromAll(tokenIn, totalAmountIn);
346 
347         for (uint i = 0; i < swaps.length; i++) {
348             Swap memory swap = swaps[i];
349             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
350             PoolInterface pool = PoolInterface(swap.pool);
351 
352             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
353                 SwapTokenIn.approve(swap.pool, 0);
354             }
355             SwapTokenIn.approve(swap.pool, swap.swapAmount);
356 
357             (uint tokenAmountOut,) = pool.swapExactAmountIn(
358                                         swap.tokenIn,
359                                         swap.swapAmount,
360                                         swap.tokenOut,
361                                         swap.limitReturnAmount,
362                                         swap.maxPrice
363                                     );
364             totalAmountOut = tokenAmountOut.add(totalAmountOut);
365         }
366 
367         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
368 
369         transferAll(tokenOut, totalAmountOut);
370         transferAll(tokenIn, getBalance(tokenIn));
371     }
372 
373     function batchSwapExactOut(
374         Swap[] memory swaps,
375         TokenInterface tokenIn,
376         TokenInterface tokenOut,
377         uint maxTotalAmountIn
378     )
379         public payable
380         returns (uint totalAmountIn)
381     {
382         transferFromAll(tokenIn, maxTotalAmountIn);
383 
384         for (uint i = 0; i < swaps.length; i++) {
385             Swap memory swap = swaps[i];
386             TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
387             PoolInterface pool = PoolInterface(swap.pool);
388 
389             if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
390                 SwapTokenIn.approve(swap.pool, 0);
391             }
392             SwapTokenIn.approve(swap.pool, swap.limitReturnAmount);
393 
394             (uint tokenAmountIn,) = pool.swapExactAmountOut(
395                                         swap.tokenIn,
396                                         swap.limitReturnAmount,
397                                         swap.tokenOut,
398                                         swap.swapAmount,
399                                         swap.maxPrice
400                                     );
401             totalAmountIn = tokenAmountIn.add(totalAmountIn);
402         }
403         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
404 
405         transferAll(tokenOut, getBalance(tokenOut));
406         transferAll(tokenIn, getBalance(tokenIn));
407 
408     }
409 
410     function multihopBatchSwapExactIn(
411         Swap[][] memory swapSequences,
412         TokenInterface tokenIn,
413         TokenInterface tokenOut,
414         uint totalAmountIn,
415         uint minTotalAmountOut
416     )
417         public payable
418         returns (uint totalAmountOut)
419     {
420 
421         transferFromAll(tokenIn, totalAmountIn);
422 
423         for (uint i = 0; i < swapSequences.length; i++) {
424             uint tokenAmountOut;
425             for (uint k = 0; k < swapSequences[i].length; k++) {
426                 Swap memory swap = swapSequences[i][k];
427                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
428                 if (k == 1) {
429                     // Makes sure that on the second swap the output of the first was used
430                     // so there is not intermediate token leftover
431                     swap.swapAmount = tokenAmountOut;
432                 }
433 
434                 PoolInterface pool = PoolInterface(swap.pool);
435                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
436                     SwapTokenIn.approve(swap.pool, 0);
437                 }
438                 SwapTokenIn.approve(swap.pool, swap.swapAmount);
439                 (tokenAmountOut,) = pool.swapExactAmountIn(
440                                             swap.tokenIn,
441                                             swap.swapAmount,
442                                             swap.tokenOut,
443                                             swap.limitReturnAmount,
444                                             swap.maxPrice
445                                         );
446             }
447             // This takes the amountOut of the last swap
448             totalAmountOut = tokenAmountOut.add(totalAmountOut);
449         }
450 
451         require(totalAmountOut >= minTotalAmountOut, "ERR_LIMIT_OUT");
452 
453         transferAll(tokenOut, totalAmountOut);
454         transferAll(tokenIn, getBalance(tokenIn));
455 
456     }
457 
458     function multihopBatchSwapExactOut(
459         Swap[][] memory swapSequences,
460         TokenInterface tokenIn,
461         TokenInterface tokenOut,
462         uint maxTotalAmountIn
463     )
464         public payable
465         returns (uint totalAmountIn)
466     {
467 
468         transferFromAll(tokenIn, maxTotalAmountIn);
469 
470         for (uint i = 0; i < swapSequences.length; i++) {
471             uint tokenAmountInFirstSwap;
472             // Specific code for a simple swap and a multihop (2 swaps in sequence)
473             if (swapSequences[i].length == 1) {
474                 Swap memory swap = swapSequences[i][0];
475                 TokenInterface SwapTokenIn = TokenInterface(swap.tokenIn);
476 
477                 PoolInterface pool = PoolInterface(swap.pool);
478                 if (SwapTokenIn.allowance(address(this), swap.pool) > 0) {
479                     SwapTokenIn.approve(swap.pool, 0);
480                 }
481                 SwapTokenIn.approve(swap.pool, swap.limitReturnAmount);
482 
483                 (tokenAmountInFirstSwap,) = pool.swapExactAmountOut(
484                                         swap.tokenIn,
485                                         swap.limitReturnAmount,
486                                         swap.tokenOut,
487                                         swap.swapAmount,
488                                         swap.maxPrice
489                                     );
490             } else {
491                 // Consider we are swapping A -> B and B -> C. The goal is to buy a given amount
492                 // of token C. But first we need to buy B with A so we can then buy C with B
493                 // To get the exact amount of C we then first need to calculate how much B we'll need:
494                 uint intermediateTokenAmount; // This would be token B as described above
495                 Swap memory secondSwap = swapSequences[i][1];
496                 PoolInterface poolSecondSwap = PoolInterface(secondSwap.pool);
497                 intermediateTokenAmount = poolSecondSwap.calcInGivenOut(
498                                         poolSecondSwap.getBalance(secondSwap.tokenIn),
499                                         poolSecondSwap.getDenormalizedWeight(secondSwap.tokenIn),
500                                         poolSecondSwap.getBalance(secondSwap.tokenOut),
501                                         poolSecondSwap.getDenormalizedWeight(secondSwap.tokenOut),
502                                         secondSwap.swapAmount,
503                                         poolSecondSwap.getSwapFee()
504                                     );
505 
506                 //// Buy intermediateTokenAmount of token B with A in the first pool
507                 Swap memory firstSwap = swapSequences[i][0];
508                 TokenInterface FirstSwapTokenIn = TokenInterface(firstSwap.tokenIn);
509                 PoolInterface poolFirstSwap = PoolInterface(firstSwap.pool);
510                 if (FirstSwapTokenIn.allowance(address(this), firstSwap.pool) < uint(-1)) {
511                     FirstSwapTokenIn.approve(firstSwap.pool, uint(-1));
512                 }
513 
514                 (tokenAmountInFirstSwap,) = poolFirstSwap.swapExactAmountOut(
515                                         firstSwap.tokenIn,
516                                         firstSwap.limitReturnAmount,
517                                         firstSwap.tokenOut,
518                                         intermediateTokenAmount, // This is the amount of token B we need
519                                         firstSwap.maxPrice
520                                     );
521 
522                 //// Buy the final amount of token C desired
523                 TokenInterface SecondSwapTokenIn = TokenInterface(secondSwap.tokenIn);
524                 if (SecondSwapTokenIn.allowance(address(this), secondSwap.pool) < uint(-1)) {
525                     SecondSwapTokenIn.approve(secondSwap.pool, uint(-1));
526                 }
527 
528                 poolSecondSwap.swapExactAmountOut(
529                                         secondSwap.tokenIn,
530                                         secondSwap.limitReturnAmount,
531                                         secondSwap.tokenOut,
532                                         secondSwap.swapAmount,
533                                         secondSwap.maxPrice
534                                     );
535             }
536             totalAmountIn = tokenAmountInFirstSwap.add(totalAmountIn);
537         }
538 
539         require(totalAmountIn <= maxTotalAmountIn, "ERR_LIMIT_IN");
540 
541         transferAll(tokenOut, getBalance(tokenOut));
542         transferAll(tokenIn, getBalance(tokenIn));
543 
544     }
545 
546     function smartSwapExactIn(
547         TokenInterface tokenIn,
548         TokenInterface tokenOut,
549         uint totalAmountIn,
550         uint minTotalAmountOut,
551         uint nPools
552     )
553         public payable
554         returns (uint totalAmountOut)
555     {
556         Swap[] memory swaps;
557         if (isETH(tokenIn)) {
558           (swaps,) = viewSplitExactIn(address(weth), address(tokenOut), totalAmountIn, nPools);
559         } else if (isETH(tokenOut)){
560           (swaps,) = viewSplitExactIn(address(tokenIn), address(weth), totalAmountIn, nPools);
561         } else {
562           (swaps,) = viewSplitExactIn(address(tokenIn), address(tokenOut), totalAmountIn, nPools);
563         }
564 
565         totalAmountOut = batchSwapExactIn(swaps, tokenIn, tokenOut, totalAmountIn, minTotalAmountOut);
566     }
567 
568     function smartSwapExactOut(
569         TokenInterface tokenIn,
570         TokenInterface tokenOut,
571         uint totalAmountOut,
572         uint maxTotalAmountIn,
573         uint nPools
574     )
575         public payable
576         returns (uint totalAmountIn)
577     {
578         Swap[] memory swaps;
579         if (isETH(tokenIn)) {
580           (swaps,) = viewSplitExactOut(address(weth), address(tokenOut), totalAmountOut, nPools);
581         } else if (isETH(tokenOut)){
582           (swaps,) = viewSplitExactOut(address(tokenIn), address(weth), totalAmountOut, nPools);
583         } else {
584           (swaps,) = viewSplitExactOut(address(tokenIn), address(tokenOut), totalAmountOut, nPools);
585         }
586 
587         totalAmountIn = batchSwapExactOut(swaps, tokenIn, tokenOut, maxTotalAmountIn);
588     }
589 
590     function viewSplitExactIn(
591         address tokenIn,
592         address tokenOut,
593         uint swapAmount,
594         uint nPools
595     )
596         public view
597         returns (Swap[] memory swaps, uint totalOutput)
598     {
599         address[] memory poolAddresses = registry.getBestPoolsWithLimit(tokenIn, tokenOut, nPools);
600 
601         Pool[] memory pools = new Pool[](poolAddresses.length);
602         uint sumEffectiveLiquidity;
603         for (uint i = 0; i < poolAddresses.length; i++) {
604             pools[i] = getPoolData(tokenIn, tokenOut, poolAddresses[i]);
605             sumEffectiveLiquidity = sumEffectiveLiquidity.add(pools[i].effectiveLiquidity);
606         }
607 
608         uint[] memory bestInputAmounts = new uint[](pools.length);
609         uint totalInputAmount;
610         for (uint i = 0; i < pools.length; i++) {
611             bestInputAmounts[i] = swapAmount.mul(pools[i].effectiveLiquidity).div(sumEffectiveLiquidity);
612             totalInputAmount = totalInputAmount.add(bestInputAmounts[i]);
613         }
614 
615         if (totalInputAmount < swapAmount) {
616             bestInputAmounts[0] = bestInputAmounts[0].add(swapAmount.sub(totalInputAmount));
617         } else {
618             bestInputAmounts[0] = bestInputAmounts[0].sub(totalInputAmount.sub(swapAmount));
619         }
620 
621         swaps = new Swap[](pools.length);
622 
623         for (uint i = 0; i < pools.length; i++) {
624             swaps[i] = Swap({
625                         pool: pools[i].pool,
626                         tokenIn: tokenIn,
627                         tokenOut: tokenOut,
628                         swapAmount: bestInputAmounts[i],
629                         limitReturnAmount: 0,
630                         maxPrice: uint(-1)
631                     });
632         }
633 
634         totalOutput = calcTotalOutExactIn(bestInputAmounts, pools);
635 
636         return (swaps, totalOutput);
637     }
638 
639     function viewSplitExactOut(
640         address tokenIn,
641         address tokenOut,
642         uint swapAmount,
643         uint nPools
644     )
645         public view
646         returns (Swap[] memory swaps, uint totalOutput)
647     {
648         address[] memory poolAddresses = registry.getBestPoolsWithLimit(tokenIn, tokenOut, nPools);
649 
650         Pool[] memory pools = new Pool[](poolAddresses.length);
651         uint sumEffectiveLiquidity;
652         for (uint i = 0; i < poolAddresses.length; i++) {
653             pools[i] = getPoolData(tokenIn, tokenOut, poolAddresses[i]);
654             sumEffectiveLiquidity = sumEffectiveLiquidity.add(pools[i].effectiveLiquidity);
655         }
656 
657         uint[] memory bestInputAmounts = new uint[](pools.length);
658         uint totalInputAmount;
659         for (uint i = 0; i < pools.length; i++) {
660             bestInputAmounts[i] = swapAmount.mul(pools[i].effectiveLiquidity).div(sumEffectiveLiquidity);
661             totalInputAmount = totalInputAmount.add(bestInputAmounts[i]);
662         }
663         
664          if (totalInputAmount < swapAmount) {
665             bestInputAmounts[0] = bestInputAmounts[0].add(swapAmount.sub(totalInputAmount));
666         } else {
667             bestInputAmounts[0] = bestInputAmounts[0].sub(totalInputAmount.sub(swapAmount));
668         }
669 
670         swaps = new Swap[](pools.length);
671 
672         for (uint i = 0; i < pools.length; i++) {
673             swaps[i] = Swap({
674                         pool: pools[i].pool,
675                         tokenIn: tokenIn,
676                         tokenOut: tokenOut,
677                         swapAmount: bestInputAmounts[i],
678                         limitReturnAmount: uint(-1),
679                         maxPrice: uint(-1)
680                     });
681         }
682 
683         totalOutput = calcTotalOutExactOut(bestInputAmounts, pools);
684 
685         return (swaps, totalOutput);
686     }
687 
688     function getPoolData(
689         address tokenIn,
690         address tokenOut,
691         address poolAddress
692     )
693         internal view
694         returns (Pool memory)
695     {
696         PoolInterface pool = PoolInterface(poolAddress);
697         uint tokenBalanceIn = pool.getBalance(tokenIn);
698         uint tokenBalanceOut = pool.getBalance(tokenOut);
699         uint tokenWeightIn = pool.getDenormalizedWeight(tokenIn);
700         uint tokenWeightOut = pool.getDenormalizedWeight(tokenOut);
701         uint swapFee = pool.getSwapFee();
702 
703         uint effectiveLiquidity = calcEffectiveLiquidity(
704                                             tokenWeightIn,
705                                             tokenBalanceOut,
706                                             tokenWeightOut
707                                         );
708         Pool memory returnPool = Pool({
709             pool: poolAddress,
710             tokenBalanceIn: tokenBalanceIn,
711             tokenWeightIn: tokenWeightIn,
712             tokenBalanceOut: tokenBalanceOut,
713             tokenWeightOut: tokenWeightOut,
714             swapFee: swapFee,
715             effectiveLiquidity: effectiveLiquidity
716         });
717 
718         return returnPool;
719     }
720 
721     function calcEffectiveLiquidity(
722         uint tokenWeightIn,
723         uint tokenBalanceOut,
724         uint tokenWeightOut
725     )
726         internal pure
727         returns (uint effectiveLiquidity)
728     {
729 
730         // Bo * wi/(wi+wo)
731         effectiveLiquidity = 
732             tokenWeightIn.mul(BONE).div(
733                 tokenWeightOut.add(tokenWeightIn)
734             ).mul(tokenBalanceOut).div(BONE);
735 
736         return effectiveLiquidity;
737     }
738 
739     function calcTotalOutExactIn(
740         uint[] memory bestInputAmounts,
741         Pool[] memory bestPools
742     )
743         internal pure
744         returns (uint totalOutput)
745     {
746         totalOutput = 0;
747         for (uint i = 0; i < bestInputAmounts.length; i++) {
748             uint output = PoolInterface(bestPools[i].pool).calcOutGivenIn(
749                                 bestPools[i].tokenBalanceIn,
750                                 bestPools[i].tokenWeightIn,
751                                 bestPools[i].tokenBalanceOut,
752                                 bestPools[i].tokenWeightOut,
753                                 bestInputAmounts[i],
754                                 bestPools[i].swapFee
755                             );
756 
757             totalOutput = totalOutput.add(output);
758         }
759         return totalOutput;
760     }
761 
762     function calcTotalOutExactOut(
763         uint[] memory bestInputAmounts,
764         Pool[] memory bestPools
765     )
766         internal pure
767         returns (uint totalOutput)
768     {
769         totalOutput = 0;
770         for (uint i = 0; i < bestInputAmounts.length; i++) {
771             uint output = PoolInterface(bestPools[i].pool).calcInGivenOut(
772                                 bestPools[i].tokenBalanceIn,
773                                 bestPools[i].tokenWeightIn,
774                                 bestPools[i].tokenBalanceOut,
775                                 bestPools[i].tokenWeightOut,
776                                 bestInputAmounts[i],
777                                 bestPools[i].swapFee
778                             );
779 
780             totalOutput = totalOutput.add(output);
781         }
782         return totalOutput;
783     }
784 
785     function transferFromAll(TokenInterface token, uint amount) internal returns(bool) {
786         if (isETH(token)) {
787             weth.deposit.value(msg.value)();
788         } else {
789             require(token.transferFrom(msg.sender, address(this), amount), "ERR_TRANSFER_FAILED");
790         }
791     }
792 
793     function getBalance(TokenInterface token) internal view returns (uint) {
794         if (isETH(token)) {
795             return weth.balanceOf(address(this));
796         } else {
797             return token.balanceOf(address(this));
798         }
799     }
800 
801     function transferAll(TokenInterface token, uint amount) internal returns(bool) {
802         if (amount == 0) {
803             return true;
804         }
805 
806         if (isETH(token)) {
807             weth.withdraw(amount);
808             (bool xfer,) = msg.sender.call.value(amount)("");
809             require(xfer, "ERR_ETH_FAILED");
810         } else {
811             require(token.transfer(msg.sender, amount), "ERR_TRANSFER_FAILED");
812         }
813     }
814 
815     function isETH(TokenInterface token) internal pure returns(bool) {
816         return (address(token) == ETH_ADDRESS);
817     }
818 
819     function() external payable {}
820 }