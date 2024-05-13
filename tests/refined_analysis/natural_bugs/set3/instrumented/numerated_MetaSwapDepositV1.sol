1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts-upgradeable-4.7.3/proxy/utils/Initializable.sol";
7 import "@openzeppelin/contracts-upgradeable-4.7.3/security/ReentrancyGuardUpgradeable.sol";
8 import "../LPTokenV2.sol";
9 import "../interfaces/ISwapV2.sol";
10 import "../interfaces/IMetaSwapV1.sol";
11 
12 /**
13  * @title MetaSwapDeposit
14  * @notice This contract flattens the LP token in a MetaSwap pool for easier user access. MetaSwap must be
15  * deployed before this contract can be initialized successfully.
16  *
17  * For example, suppose there exists a base Swap pool consisting of [DAI, USDC, USDT].
18  * Then a MetaSwap pool can be created with [sUSD, BaseSwapLPToken] to allow trades between either
19  * the LP token or the underlying tokens and sUSD.
20  *
21  * MetaSwapDeposit flattens the LP token and remaps them to a single array, allowing users
22  * to ignore the dependency on BaseSwapLPToken. Using the above example, MetaSwapDeposit can act
23  * as a Swap containing [sUSD, DAI, USDC, USDT] tokens.
24  */
25 contract MetaSwapDepositV1 is Initializable, ReentrancyGuardUpgradeable {
26     using SafeERC20 for IERC20;
27 
28     ISwapV2 public baseSwap;
29     IMetaSwapV1 public metaSwap;
30     IERC20[] public baseTokens;
31     IERC20[] public metaTokens;
32     IERC20[] public tokens;
33     IERC20 public metaLPToken;
34 
35     uint256 constant MAX_UINT256 = 2**256 - 1;
36 
37     struct RemoveLiquidityImbalanceInfo {
38         ISwapV2 baseSwap;
39         IMetaSwapV1 metaSwap;
40         IERC20 metaLPToken;
41         uint8 baseLPTokenIndex;
42         bool withdrawFromBase;
43         uint256 leftoverMetaLPTokenAmount;
44     }
45 
46     /**
47      * @notice Sets the address for the base Swap contract, MetaSwap contract, and the
48      * MetaSwap LP token contract.
49      * @param _baseSwap the address of the base Swap contract
50      * @param _metaSwap the address of the MetaSwap contract
51      * @param _metaLPToken the address of the MetaSwap LP token contract
52      */
53     function initialize(
54         ISwapV2 _baseSwap,
55         IMetaSwapV1 _metaSwap,
56         IERC20 _metaLPToken
57     ) external initializer {
58         __ReentrancyGuard_init();
59         // Check and approve base level tokens to be deposited to the base Swap contract
60         {
61             uint8 i;
62             for (; i < 32; i++) {
63                 try _baseSwap.getToken(i) returns (IERC20 token) {
64                     baseTokens.push(token);
65                     token.safeApprove(address(_baseSwap), MAX_UINT256);
66                     token.safeApprove(address(_metaSwap), MAX_UINT256);
67                 } catch {
68                     break;
69                 }
70             }
71             require(i > 1, "baseSwap must have at least 2 tokens");
72         }
73 
74         // Check and approve meta level tokens to be deposited to the MetaSwap contract
75         IERC20 baseLPToken;
76         {
77             uint8 i;
78             for (; i < 32; i++) {
79                 try _metaSwap.getToken(i) returns (IERC20 token) {
80                     baseLPToken = token;
81                     metaTokens.push(token);
82                     tokens.push(token);
83                     token.safeApprove(address(_metaSwap), MAX_UINT256);
84                 } catch {
85                     break;
86                 }
87             }
88             require(i > 1, "metaSwap must have at least 2 tokens");
89         }
90 
91         // Flatten baseTokens and append it to tokens array
92         tokens[tokens.length - 1] = baseTokens[0];
93         for (uint8 i = 1; i < baseTokens.length; i++) {
94             tokens.push(baseTokens[i]);
95         }
96 
97         // Approve base Swap LP token to be burned by the base Swap contract for withdrawing
98         baseLPToken.safeApprove(address(_baseSwap), MAX_UINT256);
99         // Approve MetaSwap LP token to be burned by the MetaSwap contract for withdrawing
100         _metaLPToken.safeApprove(address(_metaSwap), MAX_UINT256);
101 
102         // Initialize storage variables
103         baseSwap = _baseSwap;
104         metaSwap = _metaSwap;
105         metaLPToken = _metaLPToken;
106     }
107 
108     // Mutative functions
109 
110     /**
111      * @notice Swap two underlying tokens using the meta pool and the base pool
112      * @param tokenIndexFrom the token the user wants to swap from
113      * @param tokenIndexTo the token the user wants to swap to
114      * @param dx the amount of tokens the user wants to swap from
115      * @param minDy the min amount the user would like to receive, or revert.
116      * @param deadline latest timestamp to accept this transaction
117      */
118     function swap(
119         uint8 tokenIndexFrom,
120         uint8 tokenIndexTo,
121         uint256 dx,
122         uint256 minDy,
123         uint256 deadline
124     ) external nonReentrant returns (uint256) {
125         tokens[tokenIndexFrom].safeTransferFrom(msg.sender, address(this), dx);
126         uint256 tokenToAmount = metaSwap.swapUnderlying(
127             tokenIndexFrom,
128             tokenIndexTo,
129             dx,
130             minDy,
131             deadline
132         );
133         tokens[tokenIndexTo].safeTransfer(msg.sender, tokenToAmount);
134         return tokenToAmount;
135     }
136 
137     /**
138      * @notice Add liquidity to the pool with the given amounts of tokens
139      * @param amounts the amounts of each token to add, in their native precision
140      * @param minToMint the minimum LP tokens adding this amount of liquidity
141      * should mint, otherwise revert. Handy for front-running mitigation
142      * @param deadline latest timestamp to accept this transaction
143      * @return amount of LP token user minted and received
144      */
145     function addLiquidity(
146         uint256[] calldata amounts,
147         uint256 minToMint,
148         uint256 deadline
149     ) external nonReentrant returns (uint256) {
150         // Read to memory to save on gas
151         IERC20[] memory memBaseTokens = baseTokens;
152         IERC20[] memory memMetaTokens = metaTokens;
153         uint256 baseLPTokenIndex = memMetaTokens.length - 1;
154 
155         require(amounts.length == memBaseTokens.length + baseLPTokenIndex);
156 
157         uint256 baseLPTokenAmount;
158         {
159             // Transfer base tokens from the caller and deposit to the base Swap pool
160             uint256[] memory baseAmounts = new uint256[](memBaseTokens.length);
161             bool shouldDepositBaseTokens;
162             for (uint8 i = 0; i < memBaseTokens.length; i++) {
163                 IERC20 token = memBaseTokens[i];
164                 uint256 depositAmount = amounts[baseLPTokenIndex + i];
165                 if (depositAmount > 0) {
166                     token.safeTransferFrom(
167                         msg.sender,
168                         address(this),
169                         depositAmount
170                     );
171                     baseAmounts[i] = token.balanceOf(address(this)); // account for any fees on transfer
172                     // if there are any base Swap level tokens, flag it for deposits
173                     shouldDepositBaseTokens = true;
174                 }
175             }
176             if (shouldDepositBaseTokens) {
177                 // Deposit any base Swap level tokens and receive baseLPToken
178                 baseLPTokenAmount = baseSwap.addLiquidity(
179                     baseAmounts,
180                     0,
181                     deadline
182                 );
183             }
184         }
185 
186         uint256 metaLPTokenAmount;
187         {
188             // Transfer remaining meta level tokens from the caller
189             uint256[] memory metaAmounts = new uint256[](metaTokens.length);
190             for (uint8 i = 0; i < baseLPTokenIndex; i++) {
191                 IERC20 token = memMetaTokens[i];
192                 uint256 depositAmount = amounts[i];
193                 if (depositAmount > 0) {
194                     token.safeTransferFrom(
195                         msg.sender,
196                         address(this),
197                         depositAmount
198                     );
199                     metaAmounts[i] = token.balanceOf(address(this)); // account for any fees on transfer
200                 }
201             }
202             // Update the baseLPToken amount that will be deposited
203             metaAmounts[baseLPTokenIndex] = baseLPTokenAmount;
204 
205             // Deposit the meta level tokens and the baseLPToken
206             metaLPTokenAmount = metaSwap.addLiquidity(
207                 metaAmounts,
208                 minToMint,
209                 deadline
210             );
211         }
212 
213         // Transfer the meta lp token to the caller
214         metaLPToken.safeTransfer(msg.sender, metaLPTokenAmount);
215 
216         return metaLPTokenAmount;
217     }
218 
219     /**
220      * @notice Burn LP tokens to remove liquidity from the pool. Withdraw fee that decays linearly
221      * over period of 4 weeks since last deposit will apply.
222      * @dev Liquidity can always be removed, even when the pool is paused.
223      * @param amount the amount of LP tokens to burn
224      * @param minAmounts the minimum amounts of each token in the pool
225      *        acceptable for this burn. Useful as a front-running mitigation
226      * @param deadline latest timestamp to accept this transaction
227      * @return amounts of tokens user received
228      */
229     function removeLiquidity(
230         uint256 amount,
231         uint256[] calldata minAmounts,
232         uint256 deadline
233     ) external nonReentrant returns (uint256[] memory) {
234         IERC20[] memory memBaseTokens = baseTokens;
235         IERC20[] memory memMetaTokens = metaTokens;
236         uint256[] memory totalRemovedAmounts;
237 
238         {
239             uint256 numOfAllTokens = memBaseTokens.length +
240                 memMetaTokens.length -
241                 1;
242             require(minAmounts.length == numOfAllTokens, "out of range");
243             totalRemovedAmounts = new uint256[](numOfAllTokens);
244         }
245 
246         // Transfer meta lp token from the caller to this
247         metaLPToken.safeTransferFrom(msg.sender, address(this), amount);
248 
249         uint256 baseLPTokenAmount;
250         {
251             // Remove liquidity from the MetaSwap pool
252             uint256[] memory removedAmounts;
253             uint256 baseLPTokenIndex = memMetaTokens.length - 1;
254             {
255                 uint256[] memory metaMinAmounts = new uint256[](
256                     memMetaTokens.length
257                 );
258                 for (uint8 i = 0; i < baseLPTokenIndex; i++) {
259                     metaMinAmounts[i] = minAmounts[i];
260                 }
261                 removedAmounts = metaSwap.removeLiquidity(
262                     amount,
263                     metaMinAmounts,
264                     deadline
265                 );
266             }
267 
268             // Send the meta level tokens to the caller
269             for (uint8 i = 0; i < baseLPTokenIndex; i++) {
270                 totalRemovedAmounts[i] = removedAmounts[i];
271                 memMetaTokens[i].safeTransfer(msg.sender, removedAmounts[i]);
272             }
273             baseLPTokenAmount = removedAmounts[baseLPTokenIndex];
274 
275             // Remove liquidity from the base Swap pool
276             {
277                 uint256[] memory baseMinAmounts = new uint256[](
278                     memBaseTokens.length
279                 );
280                 for (uint8 i = 0; i < baseLPTokenIndex; i++) {
281                     baseMinAmounts[i] = minAmounts[baseLPTokenIndex + i];
282                 }
283                 removedAmounts = baseSwap.removeLiquidity(
284                     baseLPTokenAmount,
285                     baseMinAmounts,
286                     deadline
287                 );
288             }
289 
290             // Send the base level tokens to the caller
291             for (uint8 i = 0; i < memBaseTokens.length; i++) {
292                 totalRemovedAmounts[baseLPTokenIndex + i] = removedAmounts[i];
293                 memBaseTokens[i].safeTransfer(msg.sender, removedAmounts[i]);
294             }
295         }
296 
297         return totalRemovedAmounts;
298     }
299 
300     /**
301      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
302      * over period of 4 weeks since last deposit will apply.
303      * @param tokenAmount the amount of the token you want to receive
304      * @param tokenIndex the index of the token you want to receive
305      * @param minAmount the minimum amount to withdraw, otherwise revert
306      * @param deadline latest timestamp to accept this transaction
307      * @return amount of chosen token user received
308      */
309     function removeLiquidityOneToken(
310         uint256 tokenAmount,
311         uint8 tokenIndex,
312         uint256 minAmount,
313         uint256 deadline
314     ) external nonReentrant returns (uint256) {
315         uint8 baseLPTokenIndex = uint8(metaTokens.length - 1);
316         uint8 baseTokensLength = uint8(baseTokens.length);
317 
318         // Transfer metaLPToken from the caller
319         metaLPToken.safeTransferFrom(msg.sender, address(this), tokenAmount);
320 
321         IERC20 token;
322         if (tokenIndex < baseLPTokenIndex) {
323             // When the desired token is meta level token, we can just call `removeLiquidityOneToken` directly
324             metaSwap.removeLiquidityOneToken(
325                 tokenAmount,
326                 tokenIndex,
327                 minAmount,
328                 deadline
329             );
330             token = metaTokens[tokenIndex];
331         } else if (tokenIndex < baseLPTokenIndex + baseTokensLength) {
332             // When the desired token is a base level token, we need to first withdraw via baseLPToken, then withdraw
333             // the desired token from the base Swap contract.
334             uint256 removedBaseLPTokenAmount = metaSwap.removeLiquidityOneToken(
335                 tokenAmount,
336                 baseLPTokenIndex,
337                 0,
338                 deadline
339             );
340 
341             baseSwap.removeLiquidityOneToken(
342                 removedBaseLPTokenAmount,
343                 tokenIndex - baseLPTokenIndex,
344                 minAmount,
345                 deadline
346             );
347             token = baseTokens[tokenIndex - baseLPTokenIndex];
348         } else {
349             revert("out of range");
350         }
351 
352         uint256 amountWithdrawn = token.balanceOf(address(this));
353         token.safeTransfer(msg.sender, amountWithdrawn);
354         return amountWithdrawn;
355     }
356 
357     /**
358      * @notice Remove liquidity from the pool, weighted differently than the
359      * pool's current balances. Withdraw fee that decays linearly
360      * over period of 4 weeks since last deposit will apply.
361      * @param amounts how much of each token to withdraw
362      * @param maxBurnAmount the max LP token provider is willing to pay to
363      * remove liquidity. Useful as a front-running mitigation.
364      * @param deadline latest timestamp to accept this transaction
365      * @return amount of LP tokens burned
366      */
367     function removeLiquidityImbalance(
368         uint256[] calldata amounts,
369         uint256 maxBurnAmount,
370         uint256 deadline
371     ) external nonReentrant returns (uint256) {
372         IERC20[] memory memBaseTokens = baseTokens;
373         IERC20[] memory memMetaTokens = metaTokens;
374         uint256[] memory metaAmounts = new uint256[](memMetaTokens.length);
375         uint256[] memory baseAmounts = new uint256[](memBaseTokens.length);
376 
377         require(
378             amounts.length == memBaseTokens.length + memMetaTokens.length - 1,
379             "out of range"
380         );
381 
382         RemoveLiquidityImbalanceInfo memory v = RemoveLiquidityImbalanceInfo(
383             baseSwap,
384             metaSwap,
385             metaLPToken,
386             uint8(metaAmounts.length - 1),
387             false,
388             0
389         );
390 
391         for (uint8 i = 0; i < v.baseLPTokenIndex; i++) {
392             metaAmounts[i] = amounts[i];
393         }
394 
395         for (uint8 i = 0; i < baseAmounts.length; i++) {
396             baseAmounts[i] = amounts[v.baseLPTokenIndex + i];
397             if (baseAmounts[i] > 0) {
398                 v.withdrawFromBase = true;
399             }
400         }
401 
402         // Calculate how much base LP token we need to get the desired amount of underlying tokens
403         if (v.withdrawFromBase) {
404             metaAmounts[v.baseLPTokenIndex] =
405                 (v.baseSwap.calculateTokenAmount(baseAmounts, false) * 10005) /
406                 10000;
407         }
408 
409         // Transfer MetaSwap LP token from the caller to this contract
410         v.metaLPToken.safeTransferFrom(
411             msg.sender,
412             address(this),
413             maxBurnAmount
414         );
415 
416         // Withdraw the paired meta level tokens and the base LP token from the MetaSwap pool
417         uint256 burnedMetaLPTokenAmount = v.metaSwap.removeLiquidityImbalance(
418             metaAmounts,
419             maxBurnAmount,
420             deadline
421         );
422         v.leftoverMetaLPTokenAmount = maxBurnAmount - burnedMetaLPTokenAmount;
423 
424         // If underlying tokens are desired, withdraw them from the base Swap pool
425         if (v.withdrawFromBase) {
426             v.baseSwap.removeLiquidityImbalance(
427                 baseAmounts,
428                 metaAmounts[v.baseLPTokenIndex],
429                 deadline
430             );
431 
432             // Base Swap may require LESS base LP token than the amount we have
433             // In that case, deposit it to the MetaSwap pool.
434             uint256[] memory leftovers = new uint256[](metaAmounts.length);
435             IERC20 baseLPToken = memMetaTokens[v.baseLPTokenIndex];
436             uint256 leftoverBaseLPTokenAmount = baseLPToken.balanceOf(
437                 address(this)
438             );
439             if (leftoverBaseLPTokenAmount > 0) {
440                 leftovers[v.baseLPTokenIndex] = leftoverBaseLPTokenAmount;
441                 v.leftoverMetaLPTokenAmount =
442                     v.leftoverMetaLPTokenAmount +
443                     v.metaSwap.addLiquidity(leftovers, 0, deadline);
444             }
445         }
446 
447         // Transfer all withdrawn tokens to the caller
448         for (uint8 i = 0; i < amounts.length; i++) {
449             IERC20 token;
450             if (i < v.baseLPTokenIndex) {
451                 token = memMetaTokens[i];
452             } else {
453                 token = memBaseTokens[i - v.baseLPTokenIndex];
454             }
455             if (amounts[i] > 0) {
456                 token.safeTransfer(msg.sender, amounts[i]);
457             }
458         }
459 
460         // If there were any extra meta lp token, transfer them back to the caller as well
461         if (v.leftoverMetaLPTokenAmount > 0) {
462             v.metaLPToken.safeTransfer(msg.sender, v.leftoverMetaLPTokenAmount);
463         }
464 
465         return maxBurnAmount - v.leftoverMetaLPTokenAmount;
466     }
467 
468     // VIEW FUNCTIONS
469 
470     /**
471      * @notice A simple method to calculate prices from deposits or
472      * withdrawals, excluding fees but including slippage. This is
473      * helpful as an input into the various "min" parameters on calls
474      * to fight front-running. When withdrawing from the base pool in imbalanced
475      * fashion, the recommended slippage setting is 0.2% or higher.
476      *
477      * @dev This shouldn't be used outside frontends for user estimates.
478      *
479      * @param amounts an array of token amounts to deposit or withdrawal,
480      * corresponding to pooledTokens. The amount should be in each
481      * pooled token's native precision. If a token charges a fee on transfers,
482      * use the amount that gets transferred after the fee.
483      * @param deposit whether this is a deposit or a withdrawal
484      * @return token amount the user will receive
485      */
486     function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
487         external
488         view
489         returns (uint256)
490     {
491         uint256[] memory metaAmounts = new uint256[](metaTokens.length);
492         uint256[] memory baseAmounts = new uint256[](baseTokens.length);
493         uint256 baseLPTokenIndex = metaAmounts.length - 1;
494 
495         for (uint8 i = 0; i < baseLPTokenIndex; i++) {
496             metaAmounts[i] = amounts[i];
497         }
498 
499         for (uint8 i = 0; i < baseAmounts.length; i++) {
500             baseAmounts[i] = amounts[baseLPTokenIndex + i];
501         }
502 
503         uint256 baseLPTokenAmount = baseSwap.calculateTokenAmount(
504             baseAmounts,
505             deposit
506         );
507         metaAmounts[baseLPTokenIndex] = baseLPTokenAmount;
508 
509         return metaSwap.calculateTokenAmount(metaAmounts, deposit);
510     }
511 
512     /**
513      * @notice A simple method to calculate amount of each underlying
514      * tokens that is returned upon burning given amount of LP tokens
515      * @param amount the amount of LP tokens that would be burned on withdrawal
516      * @return array of token balances that the user will receive
517      */
518     function calculateRemoveLiquidity(uint256 amount)
519         external
520         view
521         returns (uint256[] memory)
522     {
523         uint256[] memory metaAmounts = metaSwap.calculateRemoveLiquidity(
524             amount
525         );
526         uint8 baseLPTokenIndex = uint8(metaAmounts.length - 1);
527         uint256[] memory baseAmounts = baseSwap.calculateRemoveLiquidity(
528             metaAmounts[baseLPTokenIndex]
529         );
530 
531         uint256[] memory totalAmounts = new uint256[](
532             baseLPTokenIndex + baseAmounts.length
533         );
534         for (uint8 i = 0; i < baseLPTokenIndex; i++) {
535             totalAmounts[i] = metaAmounts[i];
536         }
537         for (uint8 i = 0; i < baseAmounts.length; i++) {
538             totalAmounts[baseLPTokenIndex + i] = baseAmounts[i];
539         }
540 
541         return totalAmounts;
542     }
543 
544     /**
545      * @notice Calculate the amount of underlying token available to withdraw
546      * when withdrawing via only single token
547      * @param tokenAmount the amount of LP token to burn
548      * @param tokenIndex index of which token will be withdrawn
549      * @return availableTokenAmount calculated amount of underlying token
550      * available to withdraw
551      */
552     function calculateRemoveLiquidityOneToken(
553         uint256 tokenAmount,
554         uint8 tokenIndex
555     ) external view returns (uint256) {
556         uint8 baseLPTokenIndex = uint8(metaTokens.length - 1);
557 
558         if (tokenIndex < baseLPTokenIndex) {
559             return
560                 metaSwap.calculateRemoveLiquidityOneToken(
561                     tokenAmount,
562                     tokenIndex
563                 );
564         } else {
565             uint256 baseLPTokenAmount = metaSwap
566                 .calculateRemoveLiquidityOneToken(
567                     tokenAmount,
568                     baseLPTokenIndex
569                 );
570             return
571                 baseSwap.calculateRemoveLiquidityOneToken(
572                     baseLPTokenAmount,
573                     tokenIndex - baseLPTokenIndex
574                 );
575         }
576     }
577 
578     /**
579      * @notice Returns the address of the pooled token at given index. Reverts if tokenIndex is out of range.
580      * This is a flattened representation of the pooled tokens.
581      * @param index the index of the token
582      * @return address of the token at given index
583      */
584     function getToken(uint8 index) external view returns (IERC20) {
585         require(index < tokens.length, "index out of range");
586         return tokens[index];
587     }
588 
589     /**
590      * @notice Calculate amount of tokens you receive on swap
591      * @param tokenIndexFrom the token the user wants to sell
592      * @param tokenIndexTo the token the user wants to buy
593      * @param dx the amount of tokens the user wants to sell. If the token charges
594      * a fee on transfers, use the amount that gets transferred after the fee.
595      * @return amount of tokens the user will receive
596      */
597     function calculateSwap(
598         uint8 tokenIndexFrom,
599         uint8 tokenIndexTo,
600         uint256 dx
601     ) external view returns (uint256) {
602         return
603             metaSwap.calculateSwapUnderlying(tokenIndexFrom, tokenIndexTo, dx);
604     }
605 }
