1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 import "../SwapV2.sol";
6 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
7 import "./MetaSwapUtilsV1.sol";
8 
9 /**
10  * @title MetaSwap - A StableSwap implementation in solidity.
11  * @notice This contract is responsible for custody of closely pegged assets (eg. group of stablecoins)
12  * and automatic market making system. Users become an LP (Liquidity Provider) by depositing their tokens
13  * in desired ratios for an exchange of the pool token that represents their share of the pool.
14  * Users can burn pool tokens and withdraw their share of token(s).
15  *
16  * Each time a swap between the pooled tokens happens, a set fee incurs which effectively gets
17  * distributed to the LPs.
18  *
19  * In case of emergencies, admin can pause additional deposits, swaps, or single-asset withdraws - which
20  * stops the ratio of the tokens in the pool from changing.
21  * Users can always withdraw their tokens via multi-asset withdraws.
22  *
23  * MetaSwap is a modified version of Swap that allows Swap's LP token to be utilized in pooling with other tokens.
24  * As an example, if there is a Swap pool consisting of [DAI, USDC, USDT], then a MetaSwap pool can be created
25  * with [sUSD, BaseSwapLPToken] to allow trades between either the LP token or the underlying tokens and sUSD.
26  * Note that when interacting with MetaSwap, users cannot deposit or withdraw via underlying tokens. In that case,
27  * `MetaSwapDeposit.sol` can be additionally deployed to allow interacting with unwrapped representations of the tokens.
28  *
29  * @dev Most of the logic is stored as a library `MetaSwapUtils` for the sake of reducing contract's
30  * deployment size.
31  */
32 contract MetaSwapV1 is SwapV2 {
33     using MetaSwapUtilsV1 for SwapUtilsV2.Swap;
34     using SafeERC20 for IERC20; //TODO: is this needed? wont compile without it
35 
36     MetaSwapUtilsV1.MetaSwap public metaSwapStorage;
37 
38     uint256 constant MAX_UINT256 = 2**256 - 1;
39 
40     /*** EVENTS ***/
41 
42     // events replicated from SwapUtils to make the ABI easier for dumb
43     // clients
44     event TokenSwapUnderlying(
45         address indexed buyer,
46         uint256 tokensSold,
47         uint256 tokensBought,
48         uint128 soldId,
49         uint128 boughtId
50     );
51 
52     /**
53      * @notice Get the virtual price, to help calculate profit
54      * @return the virtual price, scaled to the POOL_PRECISION_DECIMALS
55      */
56     function getVirtualPrice()
57         external
58         view
59         virtual
60         override
61         returns (uint256)
62     {
63         return MetaSwapUtilsV1.getVirtualPrice(swapStorage, metaSwapStorage);
64     }
65 
66     /**
67      * @notice Calculate amount of tokens you receive on swap
68      * @param tokenIndexFrom the token the user wants to sell
69      * @param tokenIndexTo the token the user wants to buy
70      * @param dx the amount of tokens the user wants to sell. If the token charges
71      * a fee on transfers, use the amount that gets transferred after the fee.
72      * @return amount of tokens the user will receive
73      */
74     function calculateSwap(
75         uint8 tokenIndexFrom,
76         uint8 tokenIndexTo,
77         uint256 dx
78     ) external view virtual override returns (uint256) {
79         return
80             MetaSwapUtilsV1.calculateSwap(
81                 swapStorage,
82                 metaSwapStorage,
83                 tokenIndexFrom,
84                 tokenIndexTo,
85                 dx
86             );
87     }
88 
89     /**
90      * @notice Calculate amount of tokens you receive on swap. For this function,
91      * the token indices are flattened out so that underlying tokens are represented.
92      * @param tokenIndexFrom the token the user wants to sell
93      * @param tokenIndexTo the token the user wants to buy
94      * @param dx the amount of tokens the user wants to sell. If the token charges
95      * a fee on transfers, use the amount that gets transferred after the fee.
96      * @return amount of tokens the user will receive
97      */
98     function calculateSwapUnderlying(
99         uint8 tokenIndexFrom,
100         uint8 tokenIndexTo,
101         uint256 dx
102     ) external view virtual returns (uint256) {
103         return
104             MetaSwapUtilsV1.calculateSwapUnderlying(
105                 swapStorage,
106                 metaSwapStorage,
107                 tokenIndexFrom,
108                 tokenIndexTo,
109                 dx
110             );
111     }
112 
113     /**
114      * @notice A simple method to calculate prices from deposits or
115      * withdrawals, excluding fees but including slippage. This is
116      * helpful as an input into the various "min" parameters on calls
117      * to fight front-running
118      *
119      * @dev This shouldn't be used outside frontends for user estimates.
120      *
121      * @param amounts an array of token amounts to deposit or withdrawal,
122      * corresponding to pooledTokens. The amount should be in each
123      * pooled token's native precision. If a token charges a fee on transfers,
124      * use the amount that gets transferred after the fee.
125      * @param deposit whether this is a deposit or a withdrawal
126      * @return token amount the user will receive
127      */
128     function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
129         external
130         view
131         virtual
132         override
133         returns (uint256)
134     {
135         return
136             MetaSwapUtilsV1.calculateTokenAmount(
137                 swapStorage,
138                 metaSwapStorage,
139                 amounts,
140                 deposit
141             );
142     }
143 
144     /**
145      * @notice Calculate the amount of underlying token available to withdraw
146      * when withdrawing via only single token
147      * @param tokenAmount the amount of LP token to burn
148      * @param tokenIndex index of which token will be withdrawn
149      * @return availableTokenAmount calculated amount of underlying token
150      * available to withdraw
151      */
152     function calculateRemoveLiquidityOneToken(
153         uint256 tokenAmount,
154         uint8 tokenIndex
155     ) external view virtual override returns (uint256) {
156         return
157             MetaSwapUtilsV1.calculateWithdrawOneToken(
158                 swapStorage,
159                 metaSwapStorage,
160                 tokenAmount,
161                 tokenIndex
162             );
163     }
164 
165     /*** STATE MODIFYING FUNCTIONS ***/
166 
167     /**
168      * @notice This overrides Swap's initialize function to prevent initializing
169      * without the address of the base Swap contract.
170      *
171      * @param _pooledTokens an array of ERC20s this pool will accept
172      * @param decimals the decimals to use for each pooled token,
173      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
174      * @param lpTokenName the long-form name of the token to be deployed
175      * @param lpTokenSymbol the short symbol for the token to be deployed
176      * @param _a the amplification coefficient * n * (n - 1). See the
177      * StableSwap paper for details
178      * @param _fee default swap fee to be initialized with
179      * @param _adminFee default adminFee to be initialized with
180      */
181     function initialize(
182         IERC20[] memory _pooledTokens,
183         uint8[] memory decimals,
184         string memory lpTokenName,
185         string memory lpTokenSymbol,
186         uint256 _a,
187         uint256 _fee,
188         uint256 _adminFee,
189         address lpTokenTargetAddress
190     ) public payable virtual override initializer {
191         revert("use initializeMetaSwap() instead");
192     }
193 
194     /**
195      * @notice Initializes this MetaSwap contract with the given parameters.
196      * MetaSwap uses an existing Swap pool to expand the available liquidity.
197      * _pooledTokens array should contain the base Swap pool's LP token as
198      * the last element. For example, if there is a Swap pool consisting of
199      * [DAI, USDC, USDT]. Then a MetaSwap pool can be created with [sUSD, BaseSwapLPToken]
200      * as _pooledTokens.
201      *
202      * This will also deploy the LPToken that represents users'
203      * LP position. The owner of LPToken will be this contract - which means
204      * only this contract is allowed to mint new tokens.
205      *
206      * @param _pooledTokens an array of ERC20s this pool will accept. The last
207      * element must be an existing Swap pool's LP token's address.
208      * @param decimals the decimals to use for each pooled token,
209      * eg 8 for WBTC. Cannot be larger than POOL_PRECISION_DECIMALS
210      * @param lpTokenName the long-form name of the token to be deployed
211      * @param lpTokenSymbol the short symbol for the token to be deployed
212      * @param _a the amplification coefficient * n * (n - 1). See the
213      * StableSwap paper for details
214      * @param _fee default swap fee to be initialized with
215      * @param _adminFee default adminFee to be initialized with
216      */
217     function initializeMetaSwap(
218         IERC20[] memory _pooledTokens,
219         uint8[] memory decimals,
220         string memory lpTokenName,
221         string memory lpTokenSymbol,
222         uint256 _a,
223         uint256 _fee,
224         uint256 _adminFee,
225         address lpTokenTargetAddress,
226         ISwapV2 baseSwap
227     ) public payable virtual initializer {
228         __SwapV2_init(
229             _pooledTokens,
230             decimals,
231             lpTokenName,
232             lpTokenSymbol,
233             _a,
234             _fee,
235             _adminFee,
236             lpTokenTargetAddress
237         );
238 
239         // MetaSwap initializer
240         metaSwapStorage.baseSwap = baseSwap;
241         metaSwapStorage.baseVirtualPrice = baseSwap.getVirtualPrice();
242         metaSwapStorage.baseCacheLastUpdated = block.timestamp;
243 
244         // Read all tokens that belong to baseSwap
245         {
246             uint8 i;
247             for (; i < 32; i++) {
248                 try baseSwap.getToken(i) returns (IERC20 token) {
249                     metaSwapStorage.baseTokens.push(token);
250                     token.safeApprove(address(baseSwap), MAX_UINT256);
251                 } catch {
252                     break;
253                 }
254             }
255             require(i > 1, "baseSwap must pool at least 2 tokens");
256         }
257 
258         // Check the last element of _pooledTokens is owned by baseSwap
259         IERC20 baseLPToken = _pooledTokens[_pooledTokens.length - 1];
260         require(
261             LPTokenV2(address(baseLPToken)).owner() == address(baseSwap),
262             "baseLPToken is not owned by baseSwap"
263         );
264 
265         // Pre-approve the baseLPToken to be used by baseSwap
266         baseLPToken.safeApprove(address(baseSwap), MAX_UINT256);
267     }
268 
269     /**
270      * @notice Swap two tokens using this pool
271      * @param tokenIndexFrom the token the user wants to swap from
272      * @param tokenIndexTo the token the user wants to swap to
273      * @param dx the amount of tokens the user wants to swap from
274      * @param minDy the min amount the user would like to receive, or revert.
275      * @param deadline latest timestamp to accept this transaction
276      */
277     function swap(
278         uint8 tokenIndexFrom,
279         uint8 tokenIndexTo,
280         uint256 dx,
281         uint256 minDy,
282         uint256 deadline
283     )
284         external
285         payable
286         virtual
287         override
288         nonReentrant
289         whenNotPaused
290         deadlineCheck(deadline)
291         returns (uint256)
292     {
293         return
294             MetaSwapUtilsV1.swap(
295                 swapStorage,
296                 metaSwapStorage,
297                 tokenIndexFrom,
298                 tokenIndexTo,
299                 dx,
300                 minDy
301             );
302     }
303 
304     /**
305      * @notice Swap two tokens using this pool and the base pool.
306      * @param tokenIndexFrom the token the user wants to swap from
307      * @param tokenIndexTo the token the user wants to swap to
308      * @param dx the amount of tokens the user wants to swap from
309      * @param minDy the min amount the user would like to receive, or revert.
310      * @param deadline latest timestamp to accept this transaction
311      */
312     function swapUnderlying(
313         uint8 tokenIndexFrom,
314         uint8 tokenIndexTo,
315         uint256 dx,
316         uint256 minDy,
317         uint256 deadline
318     )
319         external
320         virtual
321         nonReentrant
322         whenNotPaused
323         deadlineCheck(deadline)
324         returns (uint256)
325     {
326         return
327             MetaSwapUtilsV1.swapUnderlying(
328                 swapStorage,
329                 metaSwapStorage,
330                 tokenIndexFrom,
331                 tokenIndexTo,
332                 dx,
333                 minDy
334             );
335     }
336 
337     /**
338      * @notice Add liquidity to the pool with the given amounts of tokens
339      * @param amounts the amounts of each token to add, in their native precision
340      * @param minToMint the minimum LP tokens adding this amount of liquidity
341      * should mint, otherwise revert. Handy for front-running mitigation
342      * @param deadline latest timestamp to accept this transaction
343      * @return amount of LP token user minted and received
344      */
345     function addLiquidity(
346         uint256[] calldata amounts,
347         uint256 minToMint,
348         uint256 deadline
349     )
350         external
351         payable
352         virtual
353         override
354         nonReentrant
355         whenNotPaused
356         deadlineCheck(deadline)
357         returns (uint256)
358     {
359         return
360             MetaSwapUtilsV1.addLiquidity(
361                 swapStorage,
362                 metaSwapStorage,
363                 amounts,
364                 minToMint
365             );
366     }
367 
368     /**
369      * @notice Remove liquidity from the pool all in one token. Withdraw fee that decays linearly
370      * over period of 4 weeks since last deposit will apply.
371      * @param tokenAmount the amount of the token you want to receive
372      * @param tokenIndex the index of the token you want to receive
373      * @param minAmount the minimum amount to withdraw, otherwise revert
374      * @param deadline latest timestamp to accept this transaction
375      * @return amount of chosen token user received
376      */
377     function removeLiquidityOneToken(
378         uint256 tokenAmount,
379         uint8 tokenIndex,
380         uint256 minAmount,
381         uint256 deadline
382     )
383         external
384         payable
385         virtual
386         override
387         nonReentrant
388         whenNotPaused
389         deadlineCheck(deadline)
390         returns (uint256)
391     {
392         return
393             MetaSwapUtilsV1.removeLiquidityOneToken(
394                 swapStorage,
395                 metaSwapStorage,
396                 tokenAmount,
397                 tokenIndex,
398                 minAmount
399             );
400     }
401 
402     /**
403      * @notice Remove liquidity from the pool, weighted differently than the
404      * pool's current balances. Withdraw fee that decays linearly
405      * over period of 4 weeks since last deposit will apply.
406      * @param amounts how much of each token to withdraw
407      * @param maxBurnAmount the max LP token provider is willing to pay to
408      * remove liquidity. Useful as a front-running mitigation.
409      * @param deadline latest timestamp to accept this transaction
410      * @return amount of LP tokens burned
411      */
412     function removeLiquidityImbalance(
413         uint256[] calldata amounts,
414         uint256 maxBurnAmount,
415         uint256 deadline
416     )
417         external
418         payable
419         virtual
420         override
421         nonReentrant
422         whenNotPaused
423         deadlineCheck(deadline)
424         returns (uint256)
425     {
426         return
427             MetaSwapUtilsV1.removeLiquidityImbalance(
428                 swapStorage,
429                 metaSwapStorage,
430                 amounts,
431                 maxBurnAmount
432             );
433     }
434 }
