1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "@openzeppelin/contracts/proxy/Clones.sol";
8 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
9 import "./OwnerPausableUpgradeable.sol";
10 import "./SwapUtils.sol";
11 import "./AmplificationUtils.sol";
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
30 contract Swap is OwnerPausableUpgradeable, ReentrancyGuardUpgradeable {
31     using SafeERC20 for IERC20;
32     using SafeMath for uint256;
33     using SwapUtils for SwapUtils.Swap;
34     using AmplificationUtils for SwapUtils.Swap;
35 
36     // Struct storing data responsible for automatic market maker functionalities. In order to
37     // access this data, this contract uses SwapUtils library. For more details, see SwapUtils.sol
38     SwapUtils.Swap public swapStorage;
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
107      * @param lpTokenTargetAddress the address of an existing LPToken contract to use as a target
108      */
109     function initialize(
110         IERC20[] memory _pooledTokens,
111         uint8[] memory decimals,
112         string memory lpTokenName,
113         string memory lpTokenSymbol,
114         uint256 _a,
115         uint256 _fee,
116         uint256 _adminFee,
117         address lpTokenTargetAddress
118     ) public payable virtual initializer {
119         __OwnerPausable_init();
120         __ReentrancyGuard_init();
121         // Check _pooledTokens and precisions parameter
122         require(_pooledTokens.length > 1, "_pooledTokens.length <= 1");
123         require(_pooledTokens.length <= 32, "_pooledTokens.length > 32");
124         require(
125             _pooledTokens.length == decimals.length,
126             "_pooledTokens decimals mismatch"
127         );
128 
129         uint256[] memory precisionMultipliers = new uint256[](decimals.length);
130 
131         for (uint8 i = 0; i < _pooledTokens.length; i++) {
132             if (i > 0) {
133                 // Check if index is already used. Check if 0th element is a duplicate.
134                 require(
135                     tokenIndexes[address(_pooledTokens[i])] == 0 &&
136                         _pooledTokens[0] != _pooledTokens[i],
137                     "Duplicate tokens"
138                 );
139             }
140             require(
141                 address(_pooledTokens[i]) != address(0),
142                 "The 0 address isn't an ERC-20"
143             );
144             require(
145                 decimals[i] <= SwapUtils.POOL_PRECISION_DECIMALS,
146                 "Token decimals exceeds max"
147             );
148             precisionMultipliers[i] =
149                 10 **
150                     uint256(SwapUtils.POOL_PRECISION_DECIMALS).sub(
151                         uint256(decimals[i])
152                     );
153             tokenIndexes[address(_pooledTokens[i])] = i;
154         }
155 
156         // Check _a, _fee, _adminFee, _withdrawFee parameters
157         require(_a < AmplificationUtils.MAX_A, "_a exceeds maximum");
158         require(_fee < SwapUtils.MAX_SWAP_FEE, "_fee exceeds maximum");
159         require(
160             _adminFee < SwapUtils.MAX_ADMIN_FEE,
161             "_adminFee exceeds maximum"
162         );
163 
164         // Clone and initialize a LPToken contract
165         LPToken lpToken = LPToken(Clones.clone(lpTokenTargetAddress));
166         require(
167             lpToken.initialize(lpTokenName, lpTokenSymbol),
168             "could not init lpToken clone"
169         );
170 
171         // Initialize swapStorage struct
172         swapStorage.lpToken = lpToken;
173         swapStorage.pooledTokens = _pooledTokens;
174         swapStorage.tokenPrecisionMultipliers = precisionMultipliers;
175         swapStorage.balances = new uint256[](_pooledTokens.length);
176         swapStorage.initialA = _a.mul(AmplificationUtils.A_PRECISION);
177         swapStorage.futureA = _a.mul(AmplificationUtils.A_PRECISION);
178         // swapStorage.initialATime = 0;
179         // swapStorage.futureATime = 0;
180         swapStorage.swapFee = _fee;
181         swapStorage.adminFee = _adminFee;
182     }
183 
184     /*** MODIFIERS ***/
185 
186     /**
187      * @notice Modifier to check deadline against current timestamp
188      * @param deadline latest timestamp to accept this transaction
189      */
190     modifier deadlineCheck(uint256 deadline) {
191         require(block.timestamp <= deadline, "Deadline not met");
192         _;
193     }
194 
195     /*** VIEW FUNCTIONS ***/
196 
197     /**
198      * @notice Return A, the amplification coefficient * n * (n - 1)
199      * @dev See the StableSwap paper for details
200      * @return A parameter
201      */
202     function getA() external view virtual returns (uint256) {
203         return swapStorage.getA();
204     }
205 
206     /**
207      * @notice Return A in its raw precision form
208      * @dev See the StableSwap paper for details
209      * @return A parameter in its raw precision form
210      */
211     function getAPrecise() external view virtual returns (uint256) {
212         return swapStorage.getAPrecise();
213     }
214 
215     /**
216      * @notice Return address of the pooled token at given index. Reverts if tokenIndex is out of range.
217      * @param index the index of the token
218      * @return address of the token at given index
219      */
220     function getToken(uint8 index) public view virtual returns (IERC20) {
221         require(index < swapStorage.pooledTokens.length, "Out of range");
222         return swapStorage.pooledTokens[index];
223     }
224 
225     /**
226      * @notice Return the index of the given token address. Reverts if no matching
227      * token is found.
228      * @param tokenAddress address of the token
229      * @return the index of the given token address
230      */
231     function getTokenIndex(address tokenAddress)
232         public
233         view
234         virtual
235         returns (uint8)
236     {
237         uint8 index = tokenIndexes[tokenAddress];
238         require(
239             address(getToken(index)) == tokenAddress,
240             "Token does not exist"
241         );
242         return index;
243     }
244 
245     /**
246      * @notice Return current balance of the pooled token at given index
247      * @param index the index of the token
248      * @return current balance of the pooled token at given index with token's native precision
249      */
250     function getTokenBalance(uint8 index)
251         external
252         view
253         virtual
254         returns (uint256)
255     {
256         require(index < swapStorage.pooledTokens.length, "Index out of range");
257         return swapStorage.balances[index];
258     }
259 
260     /**
261      * @notice Get the virtual price, to help calculate profit
262      * @return the virtual price, scaled to the POOL_PRECISION_DECIMALS
263      */
264     function getVirtualPrice() external view virtual returns (uint256) {
265         return swapStorage.getVirtualPrice();
266     }
267 
268     /**
269      * @notice Calculate amount of tokens you receive on swap
270      * @param tokenIndexFrom the token the user wants to sell
271      * @param tokenIndexTo the token the user wants to buy
272      * @param dx the amount of tokens the user wants to sell. If the token charges
273      * a fee on transfers, use the amount that gets transferred after the fee.
274      * @return amount of tokens the user will receive
275      */
276     function calculateSwap(
277         uint8 tokenIndexFrom,
278         uint8 tokenIndexTo,
279         uint256 dx
280     ) external view virtual returns (uint256) {
281         return swapStorage.calculateSwap(tokenIndexFrom, tokenIndexTo, dx);
282     }
283 
284     /**
285      * @notice A simple method to calculate prices from deposits or
286      * withdrawals, excluding fees but including slippage. This is
287      * helpful as an input into the various "min" parameters on calls
288      * to fight front-running
289      *
290      * @dev This shouldn't be used outside frontends for user estimates.
291      *
292      * @param amounts an array of token amounts to deposit or withdrawal,
293      * corresponding to pooledTokens. The amount should be in each
294      * pooled token's native precision. If a token charges a fee on transfers,
295      * use the amount that gets transferred after the fee.
296      * @param deposit whether this is a deposit or a withdrawal
297      * @return token amount the user will receive
298      */
299     function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
300         external
301         view
302         virtual
303         returns (uint256)
304     {
305         return swapStorage.calculateTokenAmount(amounts, deposit);
306     }
307 
308     /**
309      * @notice A simple method to calculate amount of each underlying
310      * tokens that is returned upon burning given amount of LP tokens
311      * @param amount the amount of LP tokens that would be burned on withdrawal
312      * @return array of token balances that the user will receive
313      */
314     function calculateRemoveLiquidity(uint256 amount)
315         external
316         view
317         virtual
318         returns (uint256[] memory)
319     {
320         return swapStorage.calculateRemoveLiquidity(amount);
321     }
322 
323     /**
324      * @notice Calculate the amount of underlying token available to withdraw
325      * when withdrawing via only single token
326      * @param tokenAmount the amount of LP token to burn
327      * @param tokenIndex index of which token will be withdrawn
328      * @return availableTokenAmount calculated amount of underlying token
329      * available to withdraw
330      */
331     function calculateRemoveLiquidityOneToken(
332         uint256 tokenAmount,
333         uint8 tokenIndex
334     ) external view virtual returns (uint256 availableTokenAmount) {
335         return swapStorage.calculateWithdrawOneToken(tokenAmount, tokenIndex);
336     }
337 
338     /**
339      * @notice This function reads the accumulated amount of admin fees of the token with given index
340      * @param index Index of the pooled token
341      * @return admin's token balance in the token's precision
342      */
343     function getAdminBalance(uint256 index)
344         external
345         view
346         virtual
347         returns (uint256)
348     {
349         return swapStorage.getAdminBalance(index);
350     }
351 
352     /*** STATE MODIFYING FUNCTIONS ***/
353 
354     /**
355      * @notice Swap two tokens using this pool
356      * @param tokenIndexFrom the token the user wants to swap from
357      * @param tokenIndexTo the token the user wants to swap to
358      * @param dx the amount of tokens the user wants to swap from
359      * @param minDy the min amount the user would like to receive, or revert.
360      * @param deadline latest timestamp to accept this transaction
361      */
362     function swap(
363         uint8 tokenIndexFrom,
364         uint8 tokenIndexTo,
365         uint256 dx,
366         uint256 minDy,
367         uint256 deadline
368     )
369         external
370         payable
371         virtual
372         nonReentrant
373         whenNotPaused
374         deadlineCheck(deadline)
375         returns (uint256)
376     {
377         return swapStorage.swap(tokenIndexFrom, tokenIndexTo, dx, minDy);
378     }
379 
380     /**
381      * @notice Add liquidity to the pool with the given amounts of tokens
382      * @param amounts the amounts of each token to add, in their native precision
383      * @param minToMint the minimum LP tokens adding this amount of liquidity
384      * should mint, otherwise revert. Handy for front-running mitigation
385      * @param deadline latest timestamp to accept this transaction
386      * @return amount of LP token user minted and received
387      */
388     function addLiquidity(
389         uint256[] calldata amounts,
390         uint256 minToMint,
391         uint256 deadline
392     )
393         external
394         payable
395         virtual
396         nonReentrant
397         whenNotPaused
398         deadlineCheck(deadline)
399         returns (uint256)
400     {
401         return swapStorage.addLiquidity(amounts, minToMint);
402     }
403 
404     /**
405      * @notice Burn LP tokens to remove liquidity from the pool. Withdraw fee that decays linearly
406      * over period of 4 weeks since last deposit will apply.
407      * @dev Liquidity can always be removed, even when the pool is paused.
408      * @param amount the amount of LP tokens to burn
409      * @param minAmounts the minimum amounts of each token in the pool
410      *        acceptable for this burn. Useful as a front-running mitigation
411      * @param deadline latest timestamp to accept this transaction
412      * @return amounts of tokens user received
413      */
414     function removeLiquidity(
415         uint256 amount,
416         uint256[] calldata minAmounts,
417         uint256 deadline
418     )
419         external
420         payable
421         virtual
422         nonReentrant
423         deadlineCheck(deadline)
424         returns (uint256[] memory)
425     {
426         return swapStorage.removeLiquidity(amount, minAmounts);
427     }
428 
429     /**
430      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
431      * over period of 4 weeks since last deposit will apply.
432      * @param tokenAmount the amount of the token you want to receive
433      * @param tokenIndex the index of the token you want to receive
434      * @param minAmount the minimum amount to withdraw, otherwise revert
435      * @param deadline latest timestamp to accept this transaction
436      * @return amount of chosen token user received
437      */
438     function removeLiquidityOneToken(
439         uint256 tokenAmount,
440         uint8 tokenIndex,
441         uint256 minAmount,
442         uint256 deadline
443     )
444         external
445         payable
446         virtual
447         nonReentrant
448         whenNotPaused
449         deadlineCheck(deadline)
450         returns (uint256)
451     {
452         return
453             swapStorage.removeLiquidityOneToken(
454                 tokenAmount,
455                 tokenIndex,
456                 minAmount
457             );
458     }
459 
460     /**
461      * @notice Remove liquidity from the pool, weighted differently than the
462      * pool's current balances. Withdraw fee that decays linearly
463      * over period of 4 weeks since last deposit will apply.
464      * @param amounts how much of each token to withdraw
465      * @param maxBurnAmount the max LP token provider is willing to pay to
466      * remove liquidity. Useful as a front-running mitigation.
467      * @param deadline latest timestamp to accept this transaction
468      * @return amount of LP tokens burned
469      */
470     function removeLiquidityImbalance(
471         uint256[] calldata amounts,
472         uint256 maxBurnAmount,
473         uint256 deadline
474     )
475         external
476         payable
477         virtual
478         nonReentrant
479         whenNotPaused
480         deadlineCheck(deadline)
481         returns (uint256)
482     {
483         return swapStorage.removeLiquidityImbalance(amounts, maxBurnAmount);
484     }
485 
486     /*** ADMIN FUNCTIONS ***/
487 
488     /**
489      * @notice Withdraw all admin fees to the contract owner
490      */
491     function withdrawAdminFees() external payable virtual onlyOwner {
492         swapStorage.withdrawAdminFees(owner());
493     }
494 
495     /**
496      * @notice Update the admin fee. Admin fee takes portion of the swap fee.
497      * @param newAdminFee new admin fee to be applied on future transactions
498      */
499     function setAdminFee(uint256 newAdminFee) external payable onlyOwner {
500         swapStorage.setAdminFee(newAdminFee);
501     }
502 
503     /**
504      * @notice Update the swap fee to be applied on swaps
505      * @param newSwapFee new swap fee to be applied on future transactions
506      */
507     function setSwapFee(uint256 newSwapFee) external payable onlyOwner {
508         swapStorage.setSwapFee(newSwapFee);
509     }
510 
511     /**
512      * @notice Start ramping up or down A parameter towards given futureA and futureTime
513      * Checks if the change is too rapid, and commits the new A value only when it falls under
514      * the limit range.
515      * @param futureA the new A to ramp towards
516      * @param futureTime timestamp when the new A should be reached
517      */
518     function rampA(uint256 futureA, uint256 futureTime)
519         external
520         payable
521         onlyOwner
522     {
523         swapStorage.rampA(futureA, futureTime);
524     }
525 
526     /**
527      * @notice Stop ramping A immediately. Reverts if ramp A is already stopped.
528      */
529     function stopRampA() external payable onlyOwner {
530         swapStorage.stopRampA();
531     }
532 }
