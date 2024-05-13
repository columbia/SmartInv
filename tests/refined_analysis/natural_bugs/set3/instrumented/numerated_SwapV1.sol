1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "@openzeppelin/contracts/proxy/Clones.sol";
8 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
9 import "./OwnerPausableUpgradeable.sol";
10 import "./SwapUtilsV1.sol";
11 import "./AmplificationUtilsV1.sol";
12 
13 /**
14  * @title Swap - A StableSwap implementation in solidity.
15  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
16  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
17  * in desired ratios for an exchange of the pool token that represents their share of the pool.
18  * Users can burn pool tokens and withdraw their share of token(s).
19  *
20  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
21  * distributed to the LPs.
22  *
23  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
24  * stops the ratio of the tokens in the pool from changing.
25  * Users can always withdraw their tokens via multi-asset withdraws.
26  *
27  * @dev Most of the logic is stored as a library `SwapUtils` for the sake of reducing contract's
28  * deployment size.
29  */
30 contract SwapV1 is OwnerPausableUpgradeable, ReentrancyGuardUpgradeable {
31     using SafeERC20 for IERC20;
32     using SafeMath for uint256;
33     using SwapUtilsV1 for SwapUtilsV1.Swap;
34     using AmplificationUtilsV1 for SwapUtilsV1.Swap;
35 
36     // Struct storing data responsible for automatic market maker functionalities. In order to
37     // access this data, this contract uses SwapUtils library. For more details, see SwapUtilsV1.sol
38     SwapUtilsV1.Swap public swapStorage;
39 
40     // Maps token address to an index in the pool. Used to prevent duplicate tokens in the pool.
41     // getTokenIndex function also relies on this mapping to retrieve token index.
42     mapping(address => uint8) private tokenIndexes;
43 
44     /*** EVENTS ***/
45 
46     // events replicated from SwapUtils to make the ABI easier for dumb
47     // clients
48     event TokenSwap(
49         address indexed buyer,
50         uint256 tokensSold,
51         uint256 tokensBought,
52         uint128 soldId,
53         uint128 boughtId
54     );
55     event AddLiquidity(
56         address indexed provider,
57         uint256[] tokenAmounts,
58         uint256[] fees,
59         uint256 invariant,
60         uint256 lpTokenSupply
61     );
62     event RemoveLiquidity(
63         address indexed provider,
64         uint256[] tokenAmounts,
65         uint256 lpTokenSupply
66     );
67     event RemoveLiquidityOne(
68         address indexed provider,
69         uint256 lpTokenAmount,
70         uint256 lpTokenSupply,
71         uint256 boughtId,
72         uint256 tokensBought
73     );
74     event RemoveLiquidityImbalance(
75         address indexed provider,
76         uint256[] tokenAmounts,
77         uint256[] fees,
78         uint256 invariant,
79         uint256 lpTokenSupply
80     );
81     event NewAdminFee(uint256 newAdminFee);
82     event NewSwapFee(uint256 newSwapFee);
83     event NewWithdrawFee(uint256 newWithdrawFee);
84     event RampA(
85         uint256 oldA,
86         uint256 newA,
87         uint256 initialTime,
88         uint256 futureTime
89     );
90     event StopRampA(uint256 currentA, uint256 time);
91 
92     /**
93      * @notice Initializes this Swap contract with the given parameters.
94      * This will also clone a LPToken contract that represents users'
95      * LP positions. The owner of LPToken will be this contract - which means
96      * only this contract is allowed to mint/burn tokens.
97      *
98      * @param _pooledTokens an array of ERC20s this pool will accept
99      * @param decimals the decimals to use for each pooled token,
100      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
101      * @param lpTokenName the long-form name of the token to be deployed
102      * @param lpTokenSymbol the short symbol for the token to be deployed
103      * @param _a the amplification coefficient * n * (n - 1). See the
104      * StableSwap paper for details
105      * @param _fee default swap fee to be initialized with
106      * @param _adminFee default adminFee to be initialized with
107      * @param _withdrawFee default withdrawFee to be initialized with
108      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
109      */
110     function initialize(
111         IERC20[] memory _pooledTokens,
112         uint8[] memory decimals,
113         string memory lpTokenName,
114         string memory lpTokenSymbol,
115         uint256 _a,
116         uint256 _fee,
117         uint256 _adminFee,
118         uint256 _withdrawFee,
119         address lpTokenTargetAddress
120     ) public virtual initializer {
121         __OwnerPausable_init();
122         __ReentrancyGuard_init();
123         // Check _pooledTokens and precisions parameter
124         require(_pooledTokens.length > 1, "_pooledTokens.length <= 1");
125         require(_pooledTokens.length <= 32, "_pooledTokens.length > 32");
126         require(
127             _pooledTokens.length == decimals.length,
128             "_pooledTokens decimals mismatch"
129         );
130 
131         uint256[] memory precisionMultipliers = new uint256[](decimals.length);
132 
133         for (uint8 i = 0; i < _pooledTokens.length; i++) {
134             if (i > 0) {
135                 // Check if index is already used. Check if 0th element is a duplicate.
136                 require(
137                     tokenIndexes[address(_pooledTokens[i])] == 0 &&
138                         _pooledTokens[0] != _pooledTokens[i],
139                     "Duplicate tokens"
140                 );
141             }
142             require(
143                 address(_pooledTokens[i]) != address(0),
144                 "The 0 address isn't an ERC-20"
145             );
146             require(
147                 decimals[i] <= SwapUtilsV1.POOL_PRECISION_DECIMALS,
148                 "Token decimals exceeds max"
149             );
150             precisionMultipliers[i] =
151                 10 **
152                     uint256(SwapUtilsV1.POOL_PRECISION_DECIMALS).sub(
153                         uint256(decimals[i])
154                     );
155             tokenIndexes[address(_pooledTokens[i])] = i;
156         }
157 
158         // Check _a, _fee, _adminFee, _withdrawFee parameters
159         require(_a < AmplificationUtilsV1.MAX_A, "_a exceeds maximum");
160         require(_fee < SwapUtilsV1.MAX_SWAP_FEE, "_fee exceeds maximum");
161         require(
162             _adminFee < SwapUtilsV1.MAX_ADMIN_FEE,
163             "_adminFee exceeds maximum"
164         );
165         require(
166             _withdrawFee < SwapUtilsV1.MAX_WITHDRAW_FEE,
167             "_withdrawFee exceeds maximum"
168         );
169 
170         // Clone and initialize a LPToken contract
171         LPToken lpToken = LPToken(Clones.clone(lpTokenTargetAddress));
172         require(
173             lpToken.initialize(lpTokenName, lpTokenSymbol),
174             "could not init lpToken clone"
175         );
176 
177         // Initialize swapStorage struct
178         swapStorage.lpToken = lpToken;
179         swapStorage.pooledTokens = _pooledTokens;
180         swapStorage.tokenPrecisionMultipliers = precisionMultipliers;
181         swapStorage.balances = new uint256[](_pooledTokens.length);
182         swapStorage.initialA = _a.mul(AmplificationUtilsV1.A_PRECISION);
183         swapStorage.futureA = _a.mul(AmplificationUtilsV1.A_PRECISION);
184         // swapStorage.initialATime = 0;
185         // swapStorage.futureATime = 0;
186         swapStorage.swapFee = _fee;
187         swapStorage.adminFee = _adminFee;
188         swapStorage.defaultWithdrawFee = _withdrawFee;
189     }
190 
191     /*** MODIFIERS ***/
192 
193     /**
194      * @notice Modifier to check deadline against current timestamp
195      * @param deadline latest timestamp to accept this transaction
196      */
197     modifier deadlineCheck(uint256 deadline) {
198         require(block.timestamp <= deadline, "Deadline not met");
199         _;
200     }
201 
202     /*** VIEW FUNCTIONS ***/
203 
204     /**
205      * @notice Return A, the amplification coefficient * n * (n - 1)
206      * @dev See the StableSwap paper for details
207      * @return A parameter
208      */
209     function getA() external view virtual returns (uint256) {
210         return swapStorage.getA();
211     }
212 
213     /**
214      * @notice Return A in its raw precision form
215      * @dev See the StableSwap paper for details
216      * @return A parameter in its raw precision form
217      */
218     function getAPrecise() external view virtual returns (uint256) {
219         return swapStorage.getAPrecise();
220     }
221 
222     /**
223      * @notice Return address of the pooled token at given index. Reverts if tokenIndex is out of range.
224      * @param index the index of the token
225      * @return address of the token at given index
226      */
227     function getToken(uint8 index) public view virtual returns (IERC20) {
228         require(index < swapStorage.pooledTokens.length, "Out of range");
229         return swapStorage.pooledTokens[index];
230     }
231 
232     /**
233      * @notice Return the index of the given token address. Reverts if no matching
234      * token is found.
235      * @param tokenAddress address of the token
236      * @return the index of the given token address
237      */
238     function getTokenIndex(address tokenAddress)
239         public
240         view
241         virtual
242         returns (uint8)
243     {
244         uint8 index = tokenIndexes[tokenAddress];
245         require(
246             address(getToken(index)) == tokenAddress,
247             "Token does not exist"
248         );
249         return index;
250     }
251 
252     /**
253      * @notice Return timestamp of last deposit of given address
254      * @return timestamp of the last deposit made by the given address
255      */
256     function getDepositTimestamp(address user)
257         external
258         view
259         virtual
260         returns (uint256)
261     {
262         return swapStorage.getDepositTimestamp(user);
263     }
264 
265     /**
266      * @notice Return current balance of the pooled token at given index
267      * @param index the index of the token
268      * @return current balance of the pooled token at given index with token's native precision
269      */
270     function getTokenBalance(uint8 index)
271         external
272         view
273         virtual
274         returns (uint256)
275     {
276         require(index < swapStorage.pooledTokens.length, "Index out of range");
277         return swapStorage.balances[index];
278     }
279 
280     /**
281      * @notice Get the virtual price, to help calculate profit
282      * @return the virtual price, scaled to the POOL_PRECISION_DECIMALS
283      */
284     function getVirtualPrice() external view virtual returns (uint256) {
285         return swapStorage.getVirtualPrice();
286     }
287 
288     /**
289      * @notice Calculate amount of tokens you receive on swap
290      * @param tokenIndexFrom the token the user wants to sell
291      * @param tokenIndexTo the token the user wants to buy
292      * @param dx the amount of tokens the user wants to sell. If the token charges
293      * a fee on transfers, use the amount that gets transferred after the fee.
294      * @return amount of tokens the user will receive
295      */
296     function calculateSwap(
297         uint8 tokenIndexFrom,
298         uint8 tokenIndexTo,
299         uint256 dx
300     ) external view virtual returns (uint256) {
301         return swapStorage.calculateSwap(tokenIndexFrom, tokenIndexTo, dx);
302     }
303 
304     /**
305      * @notice A simple method to calculate prices from deposits or
306      * withdrawals, excluding fees but including slippage. This is
307      * helpful as an input into the various "min" parameters on calls
308      * to fight front-running
309      *
310      * @dev This shouldn't be used outside frontends for user estimates.
311      *
312      * @param account address that is depositing or withdrawing tokens
313      * @param amounts an array of token amounts to deposit or withdrawal,
314      * corresponding to pooledTokens. The amount should be in each
315      * pooled token's native precision. If a token charges a fee on transfers,
316      * use the amount that gets transferred after the fee.
317      * @param deposit whether this is a deposit or a withdrawal
318      * @return token amount the user will receive
319      */
320     function calculateTokenAmount(
321         address account,
322         uint256[] calldata amounts,
323         bool deposit
324     ) external view virtual returns (uint256) {
325         return swapStorage.calculateTokenAmount(account, amounts, deposit);
326     }
327 
328     /**
329      * @notice A simple method to calculate amount of each underlying
330      * tokens that is returned upon burning given amount of LP tokens
331      * @param account the address that is withdrawing tokens
332      * @param amount the amount of LP tokens that would be burned on withdrawal
333      * @return array of token balances that the user will receive
334      */
335     function calculateRemoveLiquidity(address account, uint256 amount)
336         external
337         view
338         virtual
339         returns (uint256[] memory)
340     {
341         return swapStorage.calculateRemoveLiquidity(account, amount);
342     }
343 
344     /**
345      * @notice Calculate the amount of underlying token available to withdraw
346      * when withdrawing via only single token
347      * @param account the address that is withdrawing tokens
348      * @param tokenAmount the amount of LP token to burn
349      * @param tokenIndex index of which token will be withdrawn
350      * @return availableTokenAmount calculated amount of underlying token
351      * available to withdraw
352      */
353     function calculateRemoveLiquidityOneToken(
354         address account,
355         uint256 tokenAmount,
356         uint8 tokenIndex
357     ) external view virtual returns (uint256 availableTokenAmount) {
358         return
359             swapStorage.calculateWithdrawOneToken(
360                 account,
361                 tokenAmount,
362                 tokenIndex
363             );
364     }
365 
366     /**
367      * @notice Calculate the fee that is applied when the given user withdraws. The withdraw fee
368      * decays linearly over period of 4 weeks. For example, depositing and withdrawing right away
369      * will charge you the full amount of withdraw fee. But withdrawing after 4 weeks will charge you
370      * no additional fees.
371      * @dev returned value should be divided by FEE_DENOMINATOR to convert to correct decimals
372      * @param user address you want to calculate withdraw fee of
373      * @return current withdraw fee of the user
374      */
375     function calculateCurrentWithdrawFee(address user)
376         external
377         view
378         virtual
379         returns (uint256)
380     {
381         return swapStorage.calculateCurrentWithdrawFee(user);
382     }
383 
384     /**
385      * @notice This function reads the accumulated amount of admin fees of the token with given index
386      * @param index Index of the pooled token
387      * @return admin's token balance in the token's precision
388      */
389     function getAdminBalance(uint256 index)
390         external
391         view
392         virtual
393         returns (uint256)
394     {
395         return swapStorage.getAdminBalance(index);
396     }
397 
398     /*** STATE MODIFYING FUNCTIONS ***/
399 
400     /**
401      * @notice Swap two tokens using this pool
402      * @param tokenIndexFrom the token the user wants to swap from
403      * @param tokenIndexTo the token the user wants to swap to
404      * @param dx the amount of tokens the user wants to swap from
405      * @param minDy the min amount the user would like to receive, or revert.
406      * @param deadline latest timestamp to accept this transaction
407      */
408     function swap(
409         uint8 tokenIndexFrom,
410         uint8 tokenIndexTo,
411         uint256 dx,
412         uint256 minDy,
413         uint256 deadline
414     )
415         external
416         virtual
417         nonReentrant
418         whenNotPaused
419         deadlineCheck(deadline)
420         returns (uint256)
421     {
422         return swapStorage.swap(tokenIndexFrom, tokenIndexTo, dx, minDy);
423     }
424 
425     /**
426      * @notice Add liquidity to the pool with the given amounts of tokens
427      * @param amounts the amounts of each token to add, in their native precision
428      * @param minToMint the minimum LP tokens adding this amount of liquidity
429      * should mint, otherwise revert. Handy for front-running mitigation
430      * @param deadline latest timestamp to accept this transaction
431      * @return amount of LP token user minted and received
432      */
433     function addLiquidity(
434         uint256[] calldata amounts,
435         uint256 minToMint,
436         uint256 deadline
437     )
438         external
439         virtual
440         nonReentrant
441         whenNotPaused
442         deadlineCheck(deadline)
443         returns (uint256)
444     {
445         return swapStorage.addLiquidity(amounts, minToMint);
446     }
447 
448     /**
449      * @notice Burn LP tokens to remove liquidity from the pool. Withdraw fee that decays linearly
450      * over period of 4 weeks since last deposit will apply.
451      * @dev Liquidity can always be removed, even when the pool is paused.
452      * @param amount the amount of LP tokens to burn
453      * @param minAmounts the minimum amounts of each token in the pool
454      *        acceptable for this burn. Useful as a front-running mitigation
455      * @param deadline latest timestamp to accept this transaction
456      * @return amounts of tokens user received
457      */
458     function removeLiquidity(
459         uint256 amount,
460         uint256[] calldata minAmounts,
461         uint256 deadline
462     )
463         external
464         virtual
465         nonReentrant
466         deadlineCheck(deadline)
467         returns (uint256[] memory)
468     {
469         return swapStorage.removeLiquidity(amount, minAmounts);
470     }
471 
472     /**
473      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
474      * over period of 4 weeks since last deposit will apply.
475      * @param tokenAmount the amount of the token you want to receive
476      * @param tokenIndex the index of the token you want to receive
477      * @param minAmount the minimum amount to withdraw, otherwise revert
478      * @param deadline latest timestamp to accept this transaction
479      * @return amount of chosen token user received
480      */
481     function removeLiquidityOneToken(
482         uint256 tokenAmount,
483         uint8 tokenIndex,
484         uint256 minAmount,
485         uint256 deadline
486     )
487         external
488         virtual
489         nonReentrant
490         whenNotPaused
491         deadlineCheck(deadline)
492         returns (uint256)
493     {
494         return
495             swapStorage.removeLiquidityOneToken(
496                 tokenAmount,
497                 tokenIndex,
498                 minAmount
499             );
500     }
501 
502     /**
503      * @notice Remove liquidity from the pool, weighted differently than the
504      * pool's current balances. Withdraw fee that decays linearly
505      * over period of 4 weeks since last deposit will apply.
506      * @param amounts how much of each token to withdraw
507      * @param maxBurnAmount the max LP token provider is willing to pay to
508      * remove liquidity. Useful as a front-running mitigation.
509      * @param deadline latest timestamp to accept this transaction
510      * @return amount of LP tokens burned
511      */
512     function removeLiquidityImbalance(
513         uint256[] calldata amounts,
514         uint256 maxBurnAmount,
515         uint256 deadline
516     )
517         external
518         virtual
519         nonReentrant
520         whenNotPaused
521         deadlineCheck(deadline)
522         returns (uint256)
523     {
524         return swapStorage.removeLiquidityImbalance(amounts, maxBurnAmount);
525     }
526 
527     /*** ADMIN FUNCTIONS ***/
528 
529     /**
530      * @notice Updates the user withdraw fee. This function can only be called by
531      * the pool token. Should be used to update the withdraw fee on transfer of pool tokens.
532      * Transferring your pool token will reset the 4 weeks period. If the recipient is already
533      * holding some pool tokens, the withdraw fee will be discounted in respective amounts.
534      * @param recipient address of the recipient of pool token
535      * @param transferAmount amount of pool token to transfer
536      */
537     function updateUserWithdrawFee(address recipient, uint256 transferAmount)
538         external
539     {
540         require(
541             msg.sender == address(swapStorage.lpToken),
542             "Only callable by pool token"
543         );
544         swapStorage.updateUserWithdrawFee(recipient, transferAmount);
545     }
546 
547     /**
548      * @notice Withdraw all admin fees to the contract owner
549      */
550     function withdrawAdminFees() external onlyOwner {
551         swapStorage.withdrawAdminFees(owner());
552     }
553 
554     /**
555      * @notice Update the admin fee. Admin fee takes portion of the swap fee.
556      * @param newAdminFee new admin fee to be applied on future transactions
557      */
558     function setAdminFee(uint256 newAdminFee) external onlyOwner {
559         swapStorage.setAdminFee(newAdminFee);
560     }
561 
562     /**
563      * @notice Update the swap fee to be applied on swaps
564      * @param newSwapFee new swap fee to be applied on future transactions
565      */
566     function setSwapFee(uint256 newSwapFee) external onlyOwner {
567         swapStorage.setSwapFee(newSwapFee);
568     }
569 
570     /**
571      * @notice Update the withdraw fee. This fee decays linearly over 4 weeks since
572      * user's last deposit.
573      * @param newWithdrawFee new withdraw fee to be applied on future deposits
574      */
575     function setDefaultWithdrawFee(uint256 newWithdrawFee) external onlyOwner {
576         swapStorage.setDefaultWithdrawFee(newWithdrawFee);
577     }
578 
579     /**
580      * @notice Start ramping up or down A parameter towards given futureA and futureTime
581      * Checks if the change is too rapid, and commits the new A value only when it falls under
582      * the limit range.
583      * @param futureA the new A to ramp towards
584      * @param futureTime timestamp when the new A should be reached
585      */
586     function rampA(uint256 futureA, uint256 futureTime) external onlyOwner {
587         swapStorage.rampA(futureA, futureTime);
588     }
589 
590     /**
591      * @notice Stop ramping A immediately. Reverts if ramp A is already stopped.
592      */
593     function stopRampA() external onlyOwner {
594         swapStorage.stopRampA();
595     }
596 }
