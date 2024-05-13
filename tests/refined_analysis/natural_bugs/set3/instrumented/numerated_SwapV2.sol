1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts-4.7.3/proxy/Clones.sol";
7 import "@openzeppelin/contracts-upgradeable-4.7.3/security/ReentrancyGuardUpgradeable.sol";
8 import "./OwnerPausableUpgradeableV1.sol";
9 import "./SwapUtilsV2.sol";
10 import "./AmplificationUtilsV2.sol";
11 
12 /**
13  * @title Swap - A StableSwap implementation in solidity.
14  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
15  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
16  * in desired ratios for an exchange of the pool token that represents their share of the pool.
17  * Users can burn pool tokens and withdraw their share of token(s).
18  *
19  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
20  * distributed to the LPs.
21  *
22  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
23  * stops the ratio of the tokens in the pool from changing.
24  * Users can always withdraw their tokens via multi-asset withdraws.
25  *
26  * @dev Most of the logic is stored as a library `SwapUtils` for the sake of reducing contract's
27  * deployment size.
28  */
29 contract SwapV2 is OwnerPausableUpgradeableV1, ReentrancyGuardUpgradeable {
30     using SafeERC20 for IERC20;
31     using SwapUtilsV2 for SwapUtilsV2.Swap;
32     using AmplificationUtilsV2 for SwapUtilsV2.Swap;
33 
34     // Struct storing data responsible for automatic market maker functionalities. In order to
35     // access this data, this contract uses SwapUtils library. For more details, see SwapUtils.sol
36     SwapUtilsV2.Swap public swapStorage;
37 
38     // Maps token address to an index in the pool. Used to prevent duplicate tokens in the pool.
39     // getTokenIndex function also relies on this mapping to retrieve token index.
40     mapping(address => uint8) private tokenIndexes;
41 
42     /*** EVENTS ***/
43 
44     // events replicated from SwapUtils to make the ABI easier for dumb
45     // clients
46     event TokenSwap(
47         address indexed buyer,
48         uint256 tokensSold,
49         uint256 tokensBought,
50         uint128 soldId,
51         uint128 boughtId
52     );
53     event AddLiquidity(
54         address indexed provider,
55         uint256[] tokenAmounts,
56         uint256[] fees,
57         uint256 invariant,
58         uint256 lpTokenSupply
59     );
60     event RemoveLiquidity(
61         address indexed provider,
62         uint256[] tokenAmounts,
63         uint256 lpTokenSupply
64     );
65     event RemoveLiquidityOne(
66         address indexed provider,
67         uint256 lpTokenAmount,
68         uint256 lpTokenSupply,
69         uint256 boughtId,
70         uint256 tokensBought
71     );
72     event RemoveLiquidityImbalance(
73         address indexed provider,
74         uint256[] tokenAmounts,
75         uint256[] fees,
76         uint256 invariant,
77         uint256 lpTokenSupply
78     );
79     event NewAdminFee(uint256 newAdminFee);
80     event NewSwapFee(uint256 newSwapFee);
81     event NewWithdrawFee(uint256 newWithdrawFee);
82     event RampA(
83         uint256 oldA,
84         uint256 newA,
85         uint256 initialTime,
86         uint256 futureTime
87     );
88     event StopRampA(uint256 currentA, uint256 time);
89 
90     /**
91      * @notice Initializes this Swap contract with the given parameters.
92      * This will also clone a LPToken contract that represents users'
93      * LP positions. The owner of LPToken will be this contract - which means
94      * only this contract is allowed to mint/burn tokens.
95      *
96      * @param _pooledTokens an array of ERC20s this pool will accept
97      * @param decimals the decimals to use for each pooled token,
98      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
99      * @param lpTokenName the long-form name of the token to be deployed
100      * @param lpTokenSymbol the short symbol for the token to be deployed
101      * @param _a the amplification coefficient * n * (n - 1). See the
102      * StableSwap paper for details
103      * @param _fee default swap fee to be initialized with
104      * @param _adminFee default adminFee to be initialized with
105      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
106      */
107     function initialize(
108         IERC20[] memory _pooledTokens,
109         uint8[] memory decimals,
110         string memory lpTokenName,
111         string memory lpTokenSymbol,
112         uint256 _a,
113         uint256 _fee,
114         uint256 _adminFee,
115         address lpTokenTargetAddress
116     ) public payable virtual initializer {
117         __SwapV2_init(
118             _pooledTokens,
119             decimals,
120             lpTokenName,
121             lpTokenSymbol,
122             _a,
123             _fee,
124             _adminFee,
125             lpTokenTargetAddress
126         );
127     }
128 
129     /**
130      * @notice Initializes this Swap contract with the given parameters.
131      * This will also clone a LPToken contract that represents users'
132      * LP positions. The owner of LPToken will be this contract - which means
133      * only this contract is allowed to mint/burn tokens.
134      *
135      * @param _pooledTokens an array of ERC20s this pool will accept
136      * @param decimals the decimals to use for each pooled token,
137      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
138      * @param lpTokenName the long-form name of the token to be deployed
139      * @param lpTokenSymbol the short symbol for the token to be deployed
140      * @param _a the amplification coefficient * n * (n - 1). See the
141      * StableSwap paper for details
142      * @param _fee default swap fee to be initialized with
143      * @param _adminFee default adminFee to be initialized with
144      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
145      */
146     function __SwapV2_init(
147         IERC20[] memory _pooledTokens,
148         uint8[] memory decimals,
149         string memory lpTokenName,
150         string memory lpTokenSymbol,
151         uint256 _a,
152         uint256 _fee,
153         uint256 _adminFee,
154         address lpTokenTargetAddress
155     ) internal virtual onlyInitializing {
156         __OwnerPausable_init();
157         __ReentrancyGuard_init();
158         // Check _pooledTokens and precisions parameter
159         require(_pooledTokens.length > 1, "_pooledTokens.length <= 1");
160         require(_pooledTokens.length <= 32, "_pooledTokens.length > 32");
161         require(
162             _pooledTokens.length == decimals.length,
163             "_pooledTokens decimals mismatch"
164         );
165 
166         uint256[] memory precisionMultipliers = new uint256[](decimals.length);
167 
168         for (uint8 i = 0; i < _pooledTokens.length; i++) {
169             if (i > 0) {
170                 // Check if index is already used. Check if 0th element is a duplicate.
171                 require(
172                     tokenIndexes[address(_pooledTokens[i])] == 0 &&
173                         _pooledTokens[0] != _pooledTokens[i],
174                     "Duplicate tokens"
175                 );
176             }
177             require(
178                 address(_pooledTokens[i]) != address(0),
179                 "The 0 address isn't an ERC-20"
180             );
181             require(
182                 decimals[i] <= SwapUtilsV2.POOL_PRECISION_DECIMALS,
183                 "Token decimals exceeds max"
184             );
185             precisionMultipliers[i] =
186                 10 **
187                     (uint256(SwapUtilsV2.POOL_PRECISION_DECIMALS) -
188                         uint256(decimals[i]));
189             tokenIndexes[address(_pooledTokens[i])] = i;
190         }
191 
192         // Check _a, _fee, _adminFee, _withdrawFee parameters
193         require(_a < AmplificationUtilsV2.MAX_A, "_a exceeds maximum");
194         require(_fee < SwapUtilsV2.MAX_SWAP_FEE, "_fee exceeds maximum");
195         require(
196             _adminFee < SwapUtilsV2.MAX_ADMIN_FEE,
197             "_adminFee exceeds maximum"
198         );
199 
200         // Clone and initialize a LPToken contract
201         LPTokenV2 lpToken = LPTokenV2(Clones.clone(lpTokenTargetAddress));
202         require(
203             lpToken.initialize(lpTokenName, lpTokenSymbol),
204             "could not init lpToken clone"
205         );
206 
207         // Initialize swapStorage struct
208         swapStorage.lpToken = lpToken;
209         swapStorage.pooledTokens = _pooledTokens;
210         swapStorage.tokenPrecisionMultipliers = precisionMultipliers;
211         swapStorage.balances = new uint256[](_pooledTokens.length);
212         swapStorage.initialA = _a * AmplificationUtilsV2.A_PRECISION;
213         swapStorage.futureA = _a * AmplificationUtilsV2.A_PRECISION;
214         // swapStorage.initialATime = 0;
215         // swapStorage.futureATime = 0;
216         swapStorage.swapFee = _fee;
217         swapStorage.adminFee = _adminFee;
218     }
219 
220     /*** MODIFIERS ***/
221 
222     /**
223      * @notice Modifier to check deadline against current timestamp
224      * @param deadline latest timestamp to accept this transaction
225      */
226     modifier deadlineCheck(uint256 deadline) {
227         require(block.timestamp <= deadline, "Deadline not met");
228         _;
229     }
230 
231     /*** VIEW FUNCTIONS ***/
232 
233     /**
234      * @notice Return A, the amplification coefficient * n * (n - 1)
235      * @dev See the StableSwap paper for details
236      * @return A parameter
237      */
238     function getA() external view virtual returns (uint256) {
239         return swapStorage.getA();
240     }
241 
242     /**
243      * @notice Return A in its raw precision form
244      * @dev See the StableSwap paper for details
245      * @return A parameter in its raw precision form
246      */
247     function getAPrecise() external view virtual returns (uint256) {
248         return swapStorage.getAPrecise();
249     }
250 
251     /**
252      * @notice Return address of the pooled token at given index. Reverts if tokenIndex is out of range.
253      * @param index the index of the token
254      * @return address of the token at given index
255      */
256     function getToken(uint8 index) public view virtual returns (IERC20) {
257         require(index < swapStorage.pooledTokens.length, "Out of range");
258         return swapStorage.pooledTokens[index];
259     }
260 
261     /**
262      * @notice Return the index of the given token address. Reverts if no matching
263      * token is found.
264      * @param tokenAddress address of the token
265      * @return the index of the given token address
266      */
267     function getTokenIndex(address tokenAddress)
268         public
269         view
270         virtual
271         returns (uint8)
272     {
273         uint8 index = tokenIndexes[tokenAddress];
274         require(
275             address(getToken(index)) == tokenAddress,
276             "Token does not exist"
277         );
278         return index;
279     }
280 
281     /**
282      * @notice Return current balance of the pooled token at given index
283      * @param index the index of the token
284      * @return current balance of the pooled token at given index with token's native precision
285      */
286     function getTokenBalance(uint8 index)
287         external
288         view
289         virtual
290         returns (uint256)
291     {
292         require(index < swapStorage.pooledTokens.length, "Index out of range");
293         return swapStorage.balances[index];
294     }
295 
296     /**
297      * @notice Get the virtual price, to help calculate profit
298      * @return the virtual price, scaled to the POOL_PRECISION_DECIMALS
299      */
300     function getVirtualPrice() external view virtual returns (uint256) {
301         return swapStorage.getVirtualPrice();
302     }
303 
304     /**
305      * @notice Calculate amount of tokens you receive on swap
306      * @param tokenIndexFrom the token the user wants to sell
307      * @param tokenIndexTo the token the user wants to buy
308      * @param dx the amount of tokens the user wants to sell. If the token charges
309      * a fee on transfers, use the amount that gets transferred after the fee.
310      * @return amount of tokens the user will receive
311      */
312     function calculateSwap(
313         uint8 tokenIndexFrom,
314         uint8 tokenIndexTo,
315         uint256 dx
316     ) external view virtual returns (uint256) {
317         return swapStorage.calculateSwap(tokenIndexFrom, tokenIndexTo, dx);
318     }
319 
320     /**
321      * @notice A simple method to calculate prices from deposits or
322      * withdrawals, excluding fees but including slippage. This is
323      * helpful as an input into the various "min" parameters on calls
324      * to fight front-running
325      *
326      * @dev This shouldn't be used outside frontends for user estimates.
327      *
328      * @param amounts an array of token amounts to deposit or withdrawal,
329      * corresponding to pooledTokens. The amount should be in each
330      * pooled token's native precision. If a token charges a fee on transfers,
331      * use the amount that gets transferred after the fee.
332      * @param deposit whether this is a deposit or a withdrawal
333      * @return token amount the user will receive
334      */
335     function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
336         external
337         view
338         virtual
339         returns (uint256)
340     {
341         return swapStorage.calculateTokenAmount(amounts, deposit);
342     }
343 
344     /**
345      * @notice A simple method to calculate amount of each underlying
346      * tokens that is returned upon burning given amount of LP tokens
347      * @param amount the amount of LP tokens that would be burned on withdrawal
348      * @return array of token balances that the user will receive
349      */
350     function calculateRemoveLiquidity(uint256 amount)
351         external
352         view
353         virtual
354         returns (uint256[] memory)
355     {
356         return swapStorage.calculateRemoveLiquidity(amount);
357     }
358 
359     /**
360      * @notice Calculate the amount of underlying token available to withdraw
361      * when withdrawing via only single token
362      * @param tokenAmount the amount of LP token to burn
363      * @param tokenIndex index of which token will be withdrawn
364      * @return availableTokenAmount calculated amount of underlying token
365      * available to withdraw
366      */
367     function calculateRemoveLiquidityOneToken(
368         uint256 tokenAmount,
369         uint8 tokenIndex
370     ) external view virtual returns (uint256 availableTokenAmount) {
371         return swapStorage.calculateWithdrawOneToken(tokenAmount, tokenIndex);
372     }
373 
374     /**
375      * @notice This function reads the accumulated amount of admin fees of the token with given index
376      * @param index Index of the pooled token
377      * @return admin's token balance in the token's precision
378      */
379     function getAdminBalance(uint256 index)
380         external
381         view
382         virtual
383         returns (uint256)
384     {
385         return swapStorage.getAdminBalance(index);
386     }
387 
388     /*** STATE MODIFYING FUNCTIONS ***/
389 
390     /**
391      * @notice Swap two tokens using this pool
392      * @param tokenIndexFrom the token the user wants to swap from
393      * @param tokenIndexTo the token the user wants to swap to
394      * @param dx the amount of tokens the user wants to swap from
395      * @param minDy the min amount the user would like to receive, or revert.
396      * @param deadline latest timestamp to accept this transaction
397      */
398     function swap(
399         uint8 tokenIndexFrom,
400         uint8 tokenIndexTo,
401         uint256 dx,
402         uint256 minDy,
403         uint256 deadline
404     )
405         external
406         payable
407         virtual
408         nonReentrant
409         whenNotPaused
410         deadlineCheck(deadline)
411         returns (uint256)
412     {
413         return swapStorage.swap(tokenIndexFrom, tokenIndexTo, dx, minDy);
414     }
415 
416     /**
417      * @notice Add liquidity to the pool with the given amounts of tokens
418      * @param amounts the amounts of each token to add, in their native precision
419      * @param minToMint the minimum LP tokens adding this amount of liquidity
420      * should mint, otherwise revert. Handy for front-running mitigation
421      * @param deadline latest timestamp to accept this transaction
422      * @return amount of LP token user minted and received
423      */
424     function addLiquidity(
425         uint256[] calldata amounts,
426         uint256 minToMint,
427         uint256 deadline
428     )
429         external
430         payable
431         virtual
432         nonReentrant
433         whenNotPaused
434         deadlineCheck(deadline)
435         returns (uint256)
436     {
437         return swapStorage.addLiquidity(amounts, minToMint);
438     }
439 
440     /**
441      * @notice Burn LP tokens to remove liquidity from the pool. Withdraw fee that decays linearly
442      * over period of 4 weeks since last deposit will apply.
443      * @dev Liquidity can always be removed, even when the pool is paused.
444      * @param amount the amount of LP tokens to burn
445      * @param minAmounts the minimum amounts of each token in the pool
446      *        acceptable for this burn. Useful as a front-running mitigation
447      * @param deadline latest timestamp to accept this transaction
448      * @return amounts of tokens user received
449      */
450     function removeLiquidity(
451         uint256 amount,
452         uint256[] calldata minAmounts,
453         uint256 deadline
454     )
455         external
456         payable
457         virtual
458         nonReentrant
459         deadlineCheck(deadline)
460         returns (uint256[] memory)
461     {
462         return swapStorage.removeLiquidity(amount, minAmounts);
463     }
464 
465     /**
466      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
467      * over period of 4 weeks since last deposit will apply.
468      * @param tokenAmount the amount of the token you want to receive
469      * @param tokenIndex the index of the token you want to receive
470      * @param minAmount the minimum amount to withdraw, otherwise revert
471      * @param deadline latest timestamp to accept this transaction
472      * @return amount of chosen token user received
473      */
474     function removeLiquidityOneToken(
475         uint256 tokenAmount,
476         uint8 tokenIndex,
477         uint256 minAmount,
478         uint256 deadline
479     )
480         external
481         payable
482         virtual
483         nonReentrant
484         whenNotPaused
485         deadlineCheck(deadline)
486         returns (uint256)
487     {
488         return
489             swapStorage.removeLiquidityOneToken(
490                 tokenAmount,
491                 tokenIndex,
492                 minAmount
493             );
494     }
495 
496     /**
497      * @notice Remove liquidity from the pool, weighted differently than the
498      * pool's current balances. Withdraw fee that decays linearly
499      * over period of 4 weeks since last deposit will apply.
500      * @param amounts how much of each token to withdraw
501      * @param maxBurnAmount the max LP token provider is willing to pay to
502      * remove liquidity. Useful as a front-running mitigation.
503      * @param deadline latest timestamp to accept this transaction
504      * @return amount of LP tokens burned
505      */
506     function removeLiquidityImbalance(
507         uint256[] calldata amounts,
508         uint256 maxBurnAmount,
509         uint256 deadline
510     )
511         external
512         payable
513         virtual
514         nonReentrant
515         whenNotPaused
516         deadlineCheck(deadline)
517         returns (uint256)
518     {
519         return swapStorage.removeLiquidityImbalance(amounts, maxBurnAmount);
520     }
521 
522     /*** ADMIN FUNCTIONS ***/
523 
524     /**
525      * @notice Withdraw all admin fees to the contract owner
526      */
527     function withdrawAdminFees() external payable virtual onlyOwner {
528         swapStorage.withdrawAdminFees(owner());
529     }
530 
531     /**
532      * @notice Update the admin fee. Admin fee takes portion of the swap fee.
533      * @param newAdminFee new admin fee to be applied on future transactions
534      */
535     function setAdminFee(uint256 newAdminFee) external payable onlyOwner {
536         swapStorage.setAdminFee(newAdminFee);
537     }
538 
539     /**
540      * @notice Update the swap fee to be applied on swaps
541      * @param newSwapFee new swap fee to be applied on future transactions
542      */
543     function setSwapFee(uint256 newSwapFee) external payable onlyOwner {
544         swapStorage.setSwapFee(newSwapFee);
545     }
546 
547     /**
548      * @notice Start ramping up or down A parameter towards given futureA and futureTime
549      * Checks if the change is too rapid, and commits the new A value only when it falls under
550      * the limit range.
551      * @param futureA the new A to ramp towards
552      * @param futureTime timestamp when the new A should be reached
553      */
554     function rampA(uint256 futureA, uint256 futureTime)
555         external
556         payable
557         onlyOwner
558     {
559         swapStorage.rampA(futureA, futureTime);
560     }
561 
562     /**
563      * @notice Stop ramping A immediately. Reverts if ramp A is already stopped.
564      */
565     function stopRampA() external payable onlyOwner {
566         swapStorage.stopRampA();
567     }
568 }
