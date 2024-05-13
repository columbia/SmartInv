1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
8 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
9 import "../LPToken.sol";
10 import "../interfaces/ISwap.sol";
11 import "../interfaces/IMetaSwap.sol";
12 
13 /**
14  * @title MetaSwapDeposit
15  * @notice This contract flattens the LP token in a MetaSwap pool for easier user access. MetaSwap must be
16  * deployed before this contract can be initialized successfully.
17  *
18  * For example, suppose there exists a base Swap pool consisting of [DAI, USDC, USDT].
19  * Then a MetaSwap pool can be created with [sUSD, BaseSwapLPToken] to allow trades between either
20  * the LP token or the underlying tokens and sUSD.
21  *
22  * MetaSwapDeposit flattens the LP token and remaps them to a single array, allowing users
23  * to ignore the dependency on BaseSwapLPToken. Using the above example, MetaSwapDeposit can act
24  * as a Swap containing [sUSD, DAI, USDC, USDT] tokens.
25  */
26 contract MetaSwapDeposit is Initializable, ReentrancyGuardUpgradeable {
27     using SafeERC20 for IERC20;
28     using SafeMath for uint256;
29 
30     ISwap public baseSwap;
31     IMetaSwap public metaSwap;
32     IERC20[] public baseTokens;
33     IERC20[] public metaTokens;
34     IERC20[] public tokens;
35     IERC20 public metaLPToken;
36 
37     uint256 constant MAX_UINT256 = 2**256 - 1;
38 
39     struct RemoveLiquidityImbalanceInfo {
40         ISwap baseSwap;
41         IMetaSwap metaSwap;
42         IERC20 metaLPToken;
43         uint8 baseLPTokenIndex;
44         bool withdrawFromBase;
45         uint256 leftoverMetaLPTokenAmount;
46     }
47 
48     /**
49      * @notice Sets the address for the base Swap contract, MetaSwap contract, and the
50      * MetaSwap LP token contract.
51      * @param _baseSwap the address of the base Swap contract
52      * @param _metaSwap the address of the MetaSwap contract
53      * @param _metaLPToken the address of the MetaSwap LP token contract
54      */
55     function initialize(
56         ISwap _baseSwap,
57         IMetaSwap _metaSwap,
58         IERC20 _metaLPToken
59     ) external initializer {
60         __ReentrancyGuard_init();
61         // Check and approve base level tokens to be deposited to the base Swap contract
62         {
63             uint8 i;
64             for (; i < 32; i++) {
65                 try _baseSwap.getToken(i) returns (IERC20 token) {
66                     baseTokens.push(token);
67                     token.safeApprove(address(_baseSwap), MAX_UINT256);
68                     token.safeApprove(address(_metaSwap), MAX_UINT256);
69                 } catch {
70                     break;
71                 }
72             }
73             require(i > 1, "baseSwap must have at least 2 tokens");
74         }
75 
76         // Check and approve meta level tokens to be deposited to the MetaSwap contract
77         IERC20 baseLPToken;
78         {
79             uint8 i;
80             for (; i < 32; i++) {
81                 try _metaSwap.getToken(i) returns (IERC20 token) {
82                     baseLPToken = token;
83                     metaTokens.push(token);
84                     tokens.push(token);
85                     token.safeApprove(address(_metaSwap), MAX_UINT256);
86                 } catch {
87                     break;
88                 }
89             }
90             require(i > 1, "metaSwap must have at least 2 tokens");
91         }
92 
93         // Flatten baseTokens and append it to tokens array
94         tokens[tokens.length - 1] = baseTokens[0];
95         for (uint8 i = 1; i < baseTokens.length; i++) {
96             tokens.push(baseTokens[i]);
97         }
98 
99         // Approve base Swap LP token to be burned by the base Swap contract for withdrawing
100         baseLPToken.safeApprove(address(_baseSwap), MAX_UINT256);
101         // Approve MetaSwap LP token to be burned by the MetaSwap contract for withdrawing
102         _metaLPToken.safeApprove(address(_metaSwap), MAX_UINT256);
103 
104         // Initialize storage variables
105         baseSwap = _baseSwap;
106         metaSwap = _metaSwap;
107         metaLPToken = _metaLPToken;
108     }
109 
110     // Mutative functions
111 
112     /**
113      * @notice Swap two underlying tokens using the meta pool and the base pool
114      * @param tokenIndexFrom the token the user wants to swap from
115      * @param tokenIndexTo the token the user wants to swap to
116      * @param dx the amount of tokens the user wants to swap from
117      * @param minDy the min amount the user would like to receive, or revert.
118      * @param deadline latest timestamp to accept this transaction
119      */
120     function swap(
121         uint8 tokenIndexFrom,
122         uint8 tokenIndexTo,
123         uint256 dx,
124         uint256 minDy,
125         uint256 deadline
126     ) external nonReentrant returns (uint256) {
127         tokens[tokenIndexFrom].safeTransferFrom(msg.sender, address(this), dx);
128         uint256 tokenToAmount = metaSwap.swapUnderlying(
129             tokenIndexFrom,
130             tokenIndexTo,
131             dx,
132             minDy,
133             deadline
134         );
135         tokens[tokenIndexTo].safeTransfer(msg.sender, tokenToAmount);
136         return tokenToAmount;
137     }
138 
139     /**
140      * @notice Add liquidity to the pool with the given amounts of tokens
141      * @param amounts the amounts of each token to add, in their native precision
142      * @param minToMint the minimum LP tokens adding this amount of liquidity
143      * should mint, otherwise revert. Handy for front-running mitigation
144      * @param deadline latest timestamp to accept this transaction
145      * @return amount of LP token user minted and received
146      */
147     function addLiquidity(
148         uint256[] calldata amounts,
149         uint256 minToMint,
150         uint256 deadline
151     ) external nonReentrant returns (uint256) {
152         // Read to memory to save on gas
153         IERC20[] memory memBaseTokens = baseTokens;
154         IERC20[] memory memMetaTokens = metaTokens;
155         uint256 baseLPTokenIndex = memMetaTokens.length - 1;
156 
157         require(amounts.length == memBaseTokens.length + baseLPTokenIndex);
158 
159         uint256 baseLPTokenAmount;
160         {
161             // Transfer base tokens from the caller and deposit to the base Swap pool
162             uint256[] memory baseAmounts = new uint256[](memBaseTokens.length);
163             bool shouldDepositBaseTokens;
164             for (uint8 i = 0; i < memBaseTokens.length; i++) {
165                 IERC20 token = memBaseTokens[i];
166                 uint256 depositAmount = amounts[baseLPTokenIndex + i];
167                 if (depositAmount > 0) {
168                     token.safeTransferFrom(
169                         msg.sender,
170                         address(this),
171                         depositAmount
172                     );
173                     baseAmounts[i] = token.balanceOf(address(this)); // account for any fees on transfer
174                     // if there are any base Swap level tokens, flag it for deposits
175                     shouldDepositBaseTokens = true;
176                 }
177             }
178             if (shouldDepositBaseTokens) {
179                 // Deposit any base Swap level tokens and receive baseLPToken
180                 baseLPTokenAmount = baseSwap.addLiquidity(
181                     baseAmounts,
182                     0,
183                     deadline
184                 );
185             }
186         }
187 
188         uint256 metaLPTokenAmount;
189         {
190             // Transfer remaining meta level tokens from the caller
191             uint256[] memory metaAmounts = new uint256[](metaTokens.length);
192             for (uint8 i = 0; i < baseLPTokenIndex; i++) {
193                 IERC20 token = memMetaTokens[i];
194                 uint256 depositAmount = amounts[i];
195                 if (depositAmount > 0) {
196                     token.safeTransferFrom(
197                         msg.sender,
198                         address(this),
199                         depositAmount
200                     );
201                     metaAmounts[i] = token.balanceOf(address(this)); // account for any fees on transfer
202                 }
203             }
204             // Update the baseLPToken amount that will be deposited
205             metaAmounts[baseLPTokenIndex] = baseLPTokenAmount;
206 
207             // Deposit the meta level tokens and the baseLPToken
208             metaLPTokenAmount = metaSwap.addLiquidity(
209                 metaAmounts,
210                 minToMint,
211                 deadline
212             );
213         }
214 
215         // Transfer the meta lp token to the caller
216         metaLPToken.safeTransfer(msg.sender, metaLPTokenAmount);
217 
218         return metaLPTokenAmount;
219     }
220 
221     /**
222      * @notice Burn LP tokens to remove liquidity from the pool. Withdraw fee that decays linearly
223      * over period of 4 weeks since last deposit will apply.
224      * @dev Liquidity can always be removed, even when the pool is paused.
225      * @param amount the amount of LP tokens to burn
226      * @param minAmounts the minimum amounts of each token in the pool
227      *        acceptable for this burn. Useful as a front-running mitigation
228      * @param deadline latest timestamp to accept this transaction
229      * @return amounts of tokens user received
230      */
231     function removeLiquidity(
232         uint256 amount,
233         uint256[] calldata minAmounts,
234         uint256 deadline
235     ) external nonReentrant returns (uint256[] memory) {
236         IERC20[] memory memBaseTokens = baseTokens;
237         IERC20[] memory memMetaTokens = metaTokens;
238         uint256[] memory totalRemovedAmounts;
239 
240         {
241             uint256 numOfAllTokens = memBaseTokens.length +
242                 memMetaTokens.length -
243                 1;
244             require(minAmounts.length == numOfAllTokens, "out of range");
245             totalRemovedAmounts = new uint256[](numOfAllTokens);
246         }
247 
248         // Transfer meta lp token from the caller to this
249         metaLPToken.safeTransferFrom(msg.sender, address(this), amount);
250 
251         uint256 baseLPTokenAmount;
252         {
253             // Remove liquidity from the MetaSwap pool
254             uint256[] memory removedAmounts;
255             uint256 baseLPTokenIndex = memMetaTokens.length - 1;
256             {
257                 uint256[] memory metaMinAmounts = new uint256[](
258                     memMetaTokens.length
259                 );
260                 for (uint8 i = 0; i < baseLPTokenIndex; i++) {
261                     metaMinAmounts[i] = minAmounts[i];
262                 }
263                 removedAmounts = metaSwap.removeLiquidity(
264                     amount,
265                     metaMinAmounts,
266                     deadline
267                 );
268             }
269 
270             // Send the meta level tokens to the caller
271             for (uint8 i = 0; i < baseLPTokenIndex; i++) {
272                 totalRemovedAmounts[i] = removedAmounts[i];
273                 memMetaTokens[i].safeTransfer(msg.sender, removedAmounts[i]);
274             }
275             baseLPTokenAmount = removedAmounts[baseLPTokenIndex];
276 
277             // Remove liquidity from the base Swap pool
278             {
279                 uint256[] memory baseMinAmounts = new uint256[](
280                     memBaseTokens.length
281                 );
282                 for (uint8 i = 0; i < baseLPTokenIndex; i++) {
283                     baseMinAmounts[i] = minAmounts[baseLPTokenIndex + i];
284                 }
285                 removedAmounts = baseSwap.removeLiquidity(
286                     baseLPTokenAmount,
287                     baseMinAmounts,
288                     deadline
289                 );
290             }
291 
292             // Send the base level tokens to the caller
293             for (uint8 i = 0; i < memBaseTokens.length; i++) {
294                 totalRemovedAmounts[baseLPTokenIndex + i] = removedAmounts[i];
295                 memBaseTokens[i].safeTransfer(msg.sender, removedAmounts[i]);
296             }
297         }
298 
299         return totalRemovedAmounts;
300     }
301 
302     /**
303      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
304      * over period of 4 weeks since last deposit will apply.
305      * @param tokenAmount the amount of the token you want to receive
306      * @param tokenIndex the index of the token you want to receive
307      * @param minAmount the minimum amount to withdraw, otherwise revert
308      * @param deadline latest timestamp to accept this transaction
309      * @return amount of chosen token user received
310      */
311     function removeLiquidityOneToken(
312         uint256 tokenAmount,
313         uint8 tokenIndex,
314         uint256 minAmount,
315         uint256 deadline
316     ) external nonReentrant returns (uint256) {
317         uint8 baseLPTokenIndex = uint8(metaTokens.length - 1);
318         uint8 baseTokensLength = uint8(baseTokens.length);
319 
320         // Transfer metaLPToken from the caller
321         metaLPToken.safeTransferFrom(msg.sender, address(this), tokenAmount);
322 
323         IERC20 token;
324         if (tokenIndex < baseLPTokenIndex) {
325             // When the desired token is meta level token, we can just call `removeLiquidityOneToken` directly
326             metaSwap.removeLiquidityOneToken(
327                 tokenAmount,
328                 tokenIndex,
329                 minAmount,
330                 deadline
331             );
332             token = metaTokens[tokenIndex];
333         } else if (tokenIndex < baseLPTokenIndex + baseTokensLength) {
334             // When the desired token is a base level token, we need to first withdraw via baseLPToken, then withdraw
335             // the desired token from the base Swap contract.
336             uint256 removedBaseLPTokenAmount = metaSwap.removeLiquidityOneToken(
337                 tokenAmount,
338                 baseLPTokenIndex,
339                 0,
340                 deadline
341             );
342 
343             baseSwap.removeLiquidityOneToken(
344                 removedBaseLPTokenAmount,
345                 tokenIndex - baseLPTokenIndex,
346                 minAmount,
347                 deadline
348             );
349             token = baseTokens[tokenIndex - baseLPTokenIndex];
350         } else {
351             revert("out of range");
352         }
353 
354         uint256 amountWithdrawn = token.balanceOf(address(this));
355         token.safeTransfer(msg.sender, amountWithdrawn);
356         return amountWithdrawn;
357     }
358 
359     /**
360      * @notice Remove liquidity from the pool, weighted differently than the
361      * pool's current balances. Withdraw fee that decays linearly
362      * over period of 4 weeks since last deposit will apply.
363      * @param amounts how much of each token to withdraw
364      * @param maxBurnAmount the max LP token provider is willing to pay to
365      * remove liquidity. Useful as a front-running mitigation.
366      * @param deadline latest timestamp to accept this transaction
367      * @return amount of LP tokens burned
368      */
369     function removeLiquidityImbalance(
370         uint256[] calldata amounts,
371         uint256 maxBurnAmount,
372         uint256 deadline
373     ) external nonReentrant returns (uint256) {
374         IERC20[] memory memBaseTokens = baseTokens;
375         IERC20[] memory memMetaTokens = metaTokens;
376         uint256[] memory metaAmounts = new uint256[](memMetaTokens.length);
377         uint256[] memory baseAmounts = new uint256[](memBaseTokens.length);
378 
379         require(
380             amounts.length == memBaseTokens.length + memMetaTokens.length - 1,
381             "out of range"
382         );
383 
384         RemoveLiquidityImbalanceInfo memory v = RemoveLiquidityImbalanceInfo(
385             baseSwap,
386             metaSwap,
387             metaLPToken,
388             uint8(metaAmounts.length - 1),
389             false,
390             0
391         );
392 
393         for (uint8 i = 0; i < v.baseLPTokenIndex; i++) {
394             metaAmounts[i] = amounts[i];
395         }
396 
397         for (uint8 i = 0; i < baseAmounts.length; i++) {
398             baseAmounts[i] = amounts[v.baseLPTokenIndex + i];
399             if (baseAmounts[i] > 0) {
400                 v.withdrawFromBase = true;
401             }
402         }
403 
404         // Calculate how much base LP token we need to get the desired amount of underlying tokens
405         if (v.withdrawFromBase) {
406             metaAmounts[v.baseLPTokenIndex] = v
407                 .baseSwap
408                 .calculateTokenAmount(baseAmounts, false)
409                 .mul(10005)
410                 .div(10000);
411         }
412 
413         // Transfer MetaSwap LP token from the caller to this contract
414         v.metaLPToken.safeTransferFrom(
415             msg.sender,
416             address(this),
417             maxBurnAmount
418         );
419 
420         // Withdraw the paired meta level tokens and the base LP token from the MetaSwap pool
421         uint256 burnedMetaLPTokenAmount = v.metaSwap.removeLiquidityImbalance(
422             metaAmounts,
423             maxBurnAmount,
424             deadline
425         );
426         v.leftoverMetaLPTokenAmount = maxBurnAmount.sub(
427             burnedMetaLPTokenAmount
428         );
429 
430         // If underlying tokens are desired, withdraw them from the base Swap pool
431         if (v.withdrawFromBase) {
432             v.baseSwap.removeLiquidityImbalance(
433                 baseAmounts,
434                 metaAmounts[v.baseLPTokenIndex],
435                 deadline
436             );
437 
438             // Base Swap may require LESS base LP token than the amount we have
439             // In that case, deposit it to the MetaSwap pool.
440             uint256[] memory leftovers = new uint256[](metaAmounts.length);
441             IERC20 baseLPToken = memMetaTokens[v.baseLPTokenIndex];
442             uint256 leftoverBaseLPTokenAmount = baseLPToken.balanceOf(
443                 address(this)
444             );
445             if (leftoverBaseLPTokenAmount > 0) {
446                 leftovers[v.baseLPTokenIndex] = leftoverBaseLPTokenAmount;
447                 v.leftoverMetaLPTokenAmount = v.leftoverMetaLPTokenAmount.add(
448                     v.metaSwap.addLiquidity(leftovers, 0, deadline)
449                 );
450             }
451         }
452 
453         // Transfer all withdrawn tokens to the caller
454         for (uint8 i = 0; i < amounts.length; i++) {
455             IERC20 token;
456             if (i < v.baseLPTokenIndex) {
457                 token = memMetaTokens[i];
458             } else {
459                 token = memBaseTokens[i - v.baseLPTokenIndex];
460             }
461             if (amounts[i] > 0) {
462                 token.safeTransfer(msg.sender, amounts[i]);
463             }
464         }
465 
466         // If there were any extra meta lp token, transfer them back to the caller as well
467         if (v.leftoverMetaLPTokenAmount > 0) {
468             v.metaLPToken.safeTransfer(msg.sender, v.leftoverMetaLPTokenAmount);
469         }
470 
471         return maxBurnAmount - v.leftoverMetaLPTokenAmount;
472     }
473 
474     // VIEW FUNCTIONS
475 
476     /**
477      * @notice A simple method to calculate prices from deposits or
478      * withdrawals, excluding fees but including slippage. This is
479      * helpful as an input into the various "min" parameters on calls
480      * to fight front-running. When withdrawing from the base pool in imbalanced
481      * fashion, the recommended slippage setting is 0.2% or higher.
482      *
483      * @dev This shouldn't be used outside frontends for user estimates.
484      *
485      * @param amounts an array of token amounts to deposit or withdrawal,
486      * corresponding to pooledTokens. The amount should be in each
487      * pooled token's native precision. If a token charges a fee on transfers,
488      * use the amount that gets transferred after the fee.
489      * @param deposit whether this is a deposit or a withdrawal
490      * @return token amount the user will receive
491      */
492     function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
493         external
494         view
495         returns (uint256)
496     {
497         uint256[] memory metaAmounts = new uint256[](metaTokens.length);
498         uint256[] memory baseAmounts = new uint256[](baseTokens.length);
499         uint256 baseLPTokenIndex = metaAmounts.length - 1;
500 
501         for (uint8 i = 0; i < baseLPTokenIndex; i++) {
502             metaAmounts[i] = amounts[i];
503         }
504 
505         for (uint8 i = 0; i < baseAmounts.length; i++) {
506             baseAmounts[i] = amounts[baseLPTokenIndex + i];
507         }
508 
509         uint256 baseLPTokenAmount = baseSwap.calculateTokenAmount(
510             baseAmounts,
511             deposit
512         );
513         metaAmounts[baseLPTokenIndex] = baseLPTokenAmount;
514 
515         return metaSwap.calculateTokenAmount(metaAmounts, deposit);
516     }
517 
518     /**
519      * @notice A simple method to calculate amount of each underlying
520      * tokens that is returned upon burning given amount of LP tokens
521      * @param amount the amount of LP tokens that would be burned on withdrawal
522      * @return array of token balances that the user will receive
523      */
524     function calculateRemoveLiquidity(uint256 amount)
525         external
526         view
527         returns (uint256[] memory)
528     {
529         uint256[] memory metaAmounts = metaSwap.calculateRemoveLiquidity(
530             amount
531         );
532         uint8 baseLPTokenIndex = uint8(metaAmounts.length - 1);
533         uint256[] memory baseAmounts = baseSwap.calculateRemoveLiquidity(
534             metaAmounts[baseLPTokenIndex]
535         );
536 
537         uint256[] memory totalAmounts = new uint256[](
538             baseLPTokenIndex + baseAmounts.length
539         );
540         for (uint8 i = 0; i < baseLPTokenIndex; i++) {
541             totalAmounts[i] = metaAmounts[i];
542         }
543         for (uint8 i = 0; i < baseAmounts.length; i++) {
544             totalAmounts[baseLPTokenIndex + i] = baseAmounts[i];
545         }
546 
547         return totalAmounts;
548     }
549 
550     /**
551      * @notice Calculate the amount of underlying token available to withdraw
552      * when withdrawing via only single token
553      * @param tokenAmount the amount of LP token to burn
554      * @param tokenIndex index of which token will be withdrawn
555      * @return availableTokenAmount calculated amount of underlying token
556      * available to withdraw
557      */
558     function calculateRemoveLiquidityOneToken(
559         uint256 tokenAmount,
560         uint8 tokenIndex
561     ) external view returns (uint256) {
562         uint8 baseLPTokenIndex = uint8(metaTokens.length - 1);
563 
564         if (tokenIndex < baseLPTokenIndex) {
565             return
566                 metaSwap.calculateRemoveLiquidityOneToken(
567                     tokenAmount,
568                     tokenIndex
569                 );
570         } else {
571             uint256 baseLPTokenAmount = metaSwap
572                 .calculateRemoveLiquidityOneToken(
573                     tokenAmount,
574                     baseLPTokenIndex
575                 );
576             return
577                 baseSwap.calculateRemoveLiquidityOneToken(
578                     baseLPTokenAmount,
579                     tokenIndex - baseLPTokenIndex
580                 );
581         }
582     }
583 
584     /**
585      * @notice Returns the address of the pooled token at given index. Reverts if tokenIndex is out of range.
586      * This is a flattened representation of the pooled tokens.
587      * @param index the index of the token
588      * @return address of the token at given index
589      */
590     function getToken(uint8 index) external view returns (IERC20) {
591         require(index < tokens.length, "index out of range");
592         return tokens[index];
593     }
594 
595     /**
596      * @notice Calculate amount of tokens you receive on swap
597      * @param tokenIndexFrom the token the user wants to sell
598      * @param tokenIndexTo the token the user wants to buy
599      * @param dx the amount of tokens the user wants to sell. If the token charges
600      * a fee on transfers, use the amount that gets transferred after the fee.
601      * @return amount of tokens the user will receive
602      */
603     function calculateSwap(
604         uint8 tokenIndexFrom,
605         uint8 tokenIndexTo,
606         uint256 dx
607     ) external view returns (uint256) {
608         return
609             metaSwap.calculateSwapUnderlying(tokenIndexFrom, tokenIndexTo, dx);
610     }
611 }
