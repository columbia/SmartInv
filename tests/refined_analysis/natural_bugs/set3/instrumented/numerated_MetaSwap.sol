1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "../Swap.sol";
6 import "./MetaSwapUtils.sol";
7 
8 /**
9  * @title MetaSwap - A StableSwap implementation in solidity.
10  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
11  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
12  * in desired ratios for an exchange of the pool token that represents their share of the pool.
13  * Users can burn pool tokens and withdraw their share of token(s).
14  *
15  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
16  * distributed to the LPs.
17  *
18  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
19  * stops the ratio of the tokens in the pool from changing.
20  * Users can always withdraw their tokens via multi-asset withdraws.
21  *
22  * MetaSwap is a modified version of Swap that allows Swap's LP token to be utilized in pooling with other tokens.
23  * As an example, if there is a Swap pool consisting of [DAI, USDC, USDT], then a MetaSwap pool can be created
24  * with [sUSD, BaseSwapLPToken] to allow trades between either the LP token or the underlying tokens and sUSD.
25  * Note that when interacting with MetaSwap, users cannot deposit or withdraw via underlying tokens. In that case,
26  * `MetaSwapDeposit.sol` can be additionally deployed to allow interacting with unwrapped representations of the tokens.
27  *
28  * @dev Most of the logic is stored as a library `MetaSwapUtils` for the sake of reducing contract's
29  * deployment size.
30  */
31 contract MetaSwap is Swap {
32     using MetaSwapUtils for SwapUtils.Swap;
33 
34     MetaSwapUtils.MetaSwap public metaSwapStorage;
35 
36     uint256 constant MAX_UINT256 = 2**256 - 1;
37 
38     /*** EVENTS ***/
39 
40     // events replicated from SwapUtils to make the ABI easier for dumb
41     // clients
42     event TokenSwapUnderlying(
43         address indexed buyer,
44         uint256 tokensSold,
45         uint256 tokensBought,
46         uint128 soldId,
47         uint128 boughtId
48     );
49 
50     /**
51      * @notice Get the virtual price, to help calculate profit
52      * @return the virtual price, scaled to the POOL_PRECISION_DECIMALS
53      */
54     function getVirtualPrice()
55         external
56         view
57         virtual
58         override
59         returns (uint256)
60     {
61         return MetaSwapUtils.getVirtualPrice(swapStorage, metaSwapStorage);
62     }
63 
64     /**
65      * @notice Calculate amount of tokens you receive on swap
66      * @param tokenIndexFrom the token the user wants to sell
67      * @param tokenIndexTo the token the user wants to buy
68      * @param dx the amount of tokens the user wants to sell. If the token charges
69      * a fee on transfers, use the amount that gets transferred after the fee.
70      * @return amount of tokens the user will receive
71      */
72     function calculateSwap(
73         uint8 tokenIndexFrom,
74         uint8 tokenIndexTo,
75         uint256 dx
76     ) external view virtual override returns (uint256) {
77         return
78             MetaSwapUtils.calculateSwap(
79                 swapStorage,
80                 metaSwapStorage,
81                 tokenIndexFrom,
82                 tokenIndexTo,
83                 dx
84             );
85     }
86 
87     /**
88      * @notice Calculate amount of tokens you receive on swap. For this function,
89      * the token indices are flattened out so that underlying tokens are represented.
90      * @param tokenIndexFrom the token the user wants to sell
91      * @param tokenIndexTo the token the user wants to buy
92      * @param dx the amount of tokens the user wants to sell. If the token charges
93      * a fee on transfers, use the amount that gets transferred after the fee.
94      * @return amount of tokens the user will receive
95      */
96     function calculateSwapUnderlying(
97         uint8 tokenIndexFrom,
98         uint8 tokenIndexTo,
99         uint256 dx
100     ) external view virtual returns (uint256) {
101         return
102             MetaSwapUtils.calculateSwapUnderlying(
103                 swapStorage,
104                 metaSwapStorage,
105                 tokenIndexFrom,
106                 tokenIndexTo,
107                 dx
108             );
109     }
110 
111     /**
112      * @notice A simple method to calculate prices from deposits or
113      * withdrawals, excluding fees but including slippage. This is
114      * helpful as an input into the various "min" parameters on calls
115      * to fight front-running
116      *
117      * @dev This shouldn't be used outside frontends for user estimates.
118      *
119      * @param amounts an array of token amounts to deposit or withdrawal,
120      * corresponding to pooledTokens. The amount should be in each
121      * pooled token's native precision. If a token charges a fee on transfers,
122      * use the amount that gets transferred after the fee.
123      * @param deposit whether this is a deposit or a withdrawal
124      * @return token amount the user will receive
125      */
126     function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
127         external
128         view
129         virtual
130         override
131         returns (uint256)
132     {
133         return
134             MetaSwapUtils.calculateTokenAmount(
135                 swapStorage,
136                 metaSwapStorage,
137                 amounts,
138                 deposit
139             );
140     }
141 
142     /**
143      * @notice Calculate the amount of underlying token available to withdraw
144      * when withdrawing via only single token
145      * @param tokenAmount the amount of LP token to burn
146      * @param tokenIndex index of which token will be withdrawn
147      * @return availableTokenAmount calculated amount of underlying token
148      * available to withdraw
149      */
150     function calculateRemoveLiquidityOneToken(
151         uint256 tokenAmount,
152         uint8 tokenIndex
153     ) external view virtual override returns (uint256) {
154         return
155             MetaSwapUtils.calculateWithdrawOneToken(
156                 swapStorage,
157                 metaSwapStorage,
158                 tokenAmount,
159                 tokenIndex
160             );
161     }
162 
163     /*** STATE MODIFYING FUNCTIONS ***/
164 
165     /**
166      * @notice This overrides Swap's initialize function to prevent initializing
167      * without the address of the base Swap contract.
168      *
169      * @param _pooledTokens an array of ERC20s this pool will accept
170      * @param decimals the decimals to use for each pooled token,
171      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
172      * @param lpTokenName the long-form name of the token to be deployed
173      * @param lpTokenSymbol the short symbol for the token to be deployed
174      * @param _a the amplification coefficient * n * (n - 1). See the
175      * StableSwap paper for details
176      * @param _fee default swap fee to be initialized with
177      * @param _adminFee default adminFee to be initialized with
178      */
179     function initialize(
180         IERC20[] memory _pooledTokens,
181         uint8[] memory decimals,
182         string memory lpTokenName,
183         string memory lpTokenSymbol,
184         uint256 _a,
185         uint256 _fee,
186         uint256 _adminFee,
187         address lpTokenTargetAddress
188     ) public payable virtual override initializer {
189         revert("use initializeMetaSwap() instead");
190     }
191 
192     /**
193      * @notice Initializes this MetaSwap contract with the given parameters.
194      * MetaSwap uses an existing Swap pool to expand the available liquidity.
195      * _pooledTokens array should contain the base Swap pool's LP token as
196      * the last element. For example, if there is a Swap pool consisting of
197      * [DAI, USDC, USDT]. Then a MetaSwap pool can be created with [sUSD, BaseSwapLPToken]
198      * as _pooledTokens.
199      *
200      * This will also deploy the LPToken that represents users'
201      * LP position. The owner of LPToken will be this contract - which means
202      * only this contract is allowed to mint new tokens.
203      *
204      * @param _pooledTokens an array of ERC20s this pool will accept. The last
205      * element must be an existing Swap pool's LP token's address.
206      * @param decimals the decimals to use for each pooled token,
207      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
208      * @param lpTokenName the long-form name of the token to be deployed
209      * @param lpTokenSymbol the short symbol for the token to be deployed
210      * @param _a the amplification coefficient * n * (n - 1). See the
211      * StableSwap paper for details
212      * @param _fee default swap fee to be initialized with
213      * @param _adminFee default adminFee to be initialized with
214      */
215     function initializeMetaSwap(
216         IERC20[] memory _pooledTokens,
217         uint8[] memory decimals,
218         string memory lpTokenName,
219         string memory lpTokenSymbol,
220         uint256 _a,
221         uint256 _fee,
222         uint256 _adminFee,
223         address lpTokenTargetAddress,
224         ISwap baseSwap
225     ) public payable virtual initializer {
226         Swap.initialize(
227             _pooledTokens,
228             decimals,
229             lpTokenName,
230             lpTokenSymbol,
231             _a,
232             _fee,
233             _adminFee,
234             lpTokenTargetAddress
235         );
236 
237         // MetaSwap initializer
238         metaSwapStorage.baseSwap = baseSwap;
239         metaSwapStorage.baseVirtualPrice = baseSwap.getVirtualPrice();
240         metaSwapStorage.baseCacheLastUpdated = block.timestamp;
241 
242         // Read all tokens that belong to baseSwap
243         {
244             uint8 i;
245             for (; i < 32; i++) {
246                 try baseSwap.getToken(i) returns (IERC20 token) {
247                     metaSwapStorage.baseTokens.push(token);
248                     token.safeApprove(address(baseSwap), MAX_UINT256);
249                 } catch {
250                     break;
251                 }
252             }
253             require(i > 1, "baseSwap must pool at least 2 tokens");
254         }
255 
256         // Check the last element of _pooledTokens is owned by baseSwap
257         IERC20 baseLPToken = _pooledTokens[_pooledTokens.length - 1];
258         require(
259             LPToken(address(baseLPToken)).owner() == address(baseSwap),
260             "baseLPToken is not owned by baseSwap"
261         );
262 
263         // Pre-approve the baseLPToken to be used by baseSwap
264         baseLPToken.safeApprove(address(baseSwap), MAX_UINT256);
265     }
266 
267     /**
268      * @notice Swap two tokens using this pool
269      * @param tokenIndexFrom the token the user wants to swap from
270      * @param tokenIndexTo the token the user wants to swap to
271      * @param dx the amount of tokens the user wants to swap from
272      * @param minDy the min amount the user would like to receive, or revert.
273      * @param deadline latest timestamp to accept this transaction
274      */
275     function swap(
276         uint8 tokenIndexFrom,
277         uint8 tokenIndexTo,
278         uint256 dx,
279         uint256 minDy,
280         uint256 deadline
281     )
282         external
283         payable
284         virtual
285         override
286         nonReentrant
287         whenNotPaused
288         deadlineCheck(deadline)
289         returns (uint256)
290     {
291         return
292             MetaSwapUtils.swap(
293                 swapStorage,
294                 metaSwapStorage,
295                 tokenIndexFrom,
296                 tokenIndexTo,
297                 dx,
298                 minDy
299             );
300     }
301 
302     /**
303      * @notice Swap two tokens using this pool and the base pool.
304      * @param tokenIndexFrom the token the user wants to swap from
305      * @param tokenIndexTo the token the user wants to swap to
306      * @param dx the amount of tokens the user wants to swap from
307      * @param minDy the min amount the user would like to receive, or revert.
308      * @param deadline latest timestamp to accept this transaction
309      */
310     function swapUnderlying(
311         uint8 tokenIndexFrom,
312         uint8 tokenIndexTo,
313         uint256 dx,
314         uint256 minDy,
315         uint256 deadline
316     )
317         external
318         virtual
319         nonReentrant
320         whenNotPaused
321         deadlineCheck(deadline)
322         returns (uint256)
323     {
324         return
325             MetaSwapUtils.swapUnderlying(
326                 swapStorage,
327                 metaSwapStorage,
328                 tokenIndexFrom,
329                 tokenIndexTo,
330                 dx,
331                 minDy
332             );
333     }
334 
335     /**
336      * @notice Add liquidity to the pool with the given amounts of tokens
337      * @param amounts the amounts of each token to add, in their native precision
338      * @param minToMint the minimum LP tokens adding this amount of liquidity
339      * should mint, otherwise revert. Handy for front-running mitigation
340      * @param deadline latest timestamp to accept this transaction
341      * @return amount of LP token user minted and received
342      */
343     function addLiquidity(
344         uint256[] calldata amounts,
345         uint256 minToMint,
346         uint256 deadline
347     )
348         external
349         payable
350         virtual
351         override
352         nonReentrant
353         whenNotPaused
354         deadlineCheck(deadline)
355         returns (uint256)
356     {
357         return
358             MetaSwapUtils.addLiquidity(
359                 swapStorage,
360                 metaSwapStorage,
361                 amounts,
362                 minToMint
363             );
364     }
365 
366     /**
367      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
368      * over period of 4 weeks since last deposit will apply.
369      * @param tokenAmount the amount of the token you want to receive
370      * @param tokenIndex the index of the token you want to receive
371      * @param minAmount the minimum amount to withdraw, otherwise revert
372      * @param deadline latest timestamp to accept this transaction
373      * @return amount of chosen token user received
374      */
375     function removeLiquidityOneToken(
376         uint256 tokenAmount,
377         uint8 tokenIndex,
378         uint256 minAmount,
379         uint256 deadline
380     )
381         external
382         payable
383         virtual
384         override
385         nonReentrant
386         whenNotPaused
387         deadlineCheck(deadline)
388         returns (uint256)
389     {
390         return
391             MetaSwapUtils.removeLiquidityOneToken(
392                 swapStorage,
393                 metaSwapStorage,
394                 tokenAmount,
395                 tokenIndex,
396                 minAmount
397             );
398     }
399 
400     /**
401      * @notice Remove liquidity from the pool, weighted differently than the
402      * pool's current balances. Withdraw fee that decays linearly
403      * over period of 4 weeks since last deposit will apply.
404      * @param amounts how much of each token to withdraw
405      * @param maxBurnAmount the max LP token provider is willing to pay to
406      * remove liquidity. Useful as a front-running mitigation.
407      * @param deadline latest timestamp to accept this transaction
408      * @return amount of LP tokens burned
409      */
410     function removeLiquidityImbalance(
411         uint256[] calldata amounts,
412         uint256 maxBurnAmount,
413         uint256 deadline
414     )
415         external
416         payable
417         virtual
418         override
419         nonReentrant
420         whenNotPaused
421         deadlineCheck(deadline)
422         returns (uint256)
423     {
424         return
425             MetaSwapUtils.removeLiquidityImbalance(
426                 swapStorage,
427                 metaSwapStorage,
428                 amounts,
429                 maxBurnAmount
430             );
431     }
432 }
