1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 import "../vendor/ISwapRouterV3.sol";
7 
8 /// @notice Trading assets on Uniswap V3 and 1Inch V4 DEXs
9 contract Swap is BaseLogic {
10     address immutable public uniswapRouter;
11     address immutable public oneInch;
12 
13     /// @notice Params for Uniswap V3 exact input trade on a single pool
14     /// @param subAccountIdIn subaccount id to trade from
15     /// @param subAccountIdOut subaccount id to trade to
16     /// @param underlyingIn sold token address
17     /// @param underlyingOut bought token address
18     /// @param amountIn amount of token to sell
19     /// @param amountOutMinimum minimum amount of bought token
20     /// @param deadline trade must complete before this timestamp
21     /// @param fee uniswap pool fee to use
22     /// @param sqrtPriceLimitX96 maximum acceptable price
23     struct SwapUniExactInputSingleParams {
24         uint subAccountIdIn;
25         uint subAccountIdOut;
26         address underlyingIn;
27         address underlyingOut;
28         uint amountIn;
29         uint amountOutMinimum;
30         uint deadline;
31         uint24 fee;
32         uint160 sqrtPriceLimitX96;
33     }
34 
35     /// @notice Params for Uniswap V3 exact input trade routed through multiple pools
36     /// @param subAccountIdIn subaccount id to trade from
37     /// @param subAccountIdOut subaccount id to trade to
38     /// @param underlyingIn sold token address
39     /// @param underlyingOut bought token address
40     /// @param amountIn amount of token to sell
41     /// @param amountOutMinimum minimum amount of bought token
42     /// @param deadline trade must complete before this timestamp
43     /// @param path list of pools to use for the trade
44     struct SwapUniExactInputParams {
45         uint subAccountIdIn;
46         uint subAccountIdOut;
47         uint amountIn;
48         uint amountOutMinimum;
49         uint deadline;
50         bytes path; // list of pools to hop - constructed with uni SDK 
51     }
52 
53     /// @notice Params for Uniswap V3 exact output trade on a single pool
54     /// @param subAccountIdIn subaccount id to trade from
55     /// @param subAccountIdOut subaccount id to trade to
56     /// @param underlyingIn sold token address
57     /// @param underlyingOut bought token address
58     /// @param amountOut amount of token to buy
59     /// @param amountInMaximum maximum amount of sold token
60     /// @param deadline trade must complete before this timestamp
61     /// @param fee uniswap pool fee to use
62     /// @param sqrtPriceLimitX96 maximum acceptable price
63     struct SwapUniExactOutputSingleParams {
64         uint subAccountIdIn;
65         uint subAccountIdOut;
66         address underlyingIn;
67         address underlyingOut;
68         uint amountOut;
69         uint amountInMaximum;
70         uint deadline;
71         uint24 fee;
72         uint160 sqrtPriceLimitX96;
73     }
74 
75     /// @notice Params for Uniswap V3 exact output trade routed through multiple pools
76     /// @param subAccountIdIn subaccount id to trade from
77     /// @param subAccountIdOut subaccount id to trade to
78     /// @param underlyingIn sold token address
79     /// @param underlyingOut bought token address
80     /// @param amountOut amount of token to buy
81     /// @param amountInMaximum maximum amount of sold token
82     /// @param deadline trade must complete before this timestamp
83     /// @param path list of pools to use for the trade
84     struct SwapUniExactOutputParams {
85         uint subAccountIdIn;
86         uint subAccountIdOut;
87         uint amountOut;
88         uint amountInMaximum;
89         uint deadline;
90         bytes path;
91     }
92 
93     /// @notice Params for 1Inch trade
94     /// @param subAccountIdIn subaccount id to trade from
95     /// @param subAccountIdOut subaccount id to trade to
96     /// @param underlyingIn sold token address
97     /// @param underlyingOut bought token address
98     /// @param amount amount of token to sell
99     /// @param amountOutMinimum minimum amount of bought token
100     /// @param payload call data passed to 1Inch contract
101     struct Swap1InchParams {
102         uint subAccountIdIn;
103         uint subAccountIdOut;
104         address underlyingIn;
105         address underlyingOut;
106         uint amount;
107         uint amountOutMinimum;
108         bytes payload;
109     }
110 
111     struct SwapCache {
112         address accountIn;
113         address accountOut;
114         address eTokenIn;
115         address eTokenOut;
116         AssetCache assetCacheIn;
117         AssetCache assetCacheOut;
118         uint balanceIn;
119         uint balanceOut;
120         uint amountIn;
121         uint amountOut;
122         uint amountInternalIn;
123     }
124 
125     constructor(bytes32 moduleGitCommit_, address uniswapRouter_, address oneInch_) BaseLogic(MODULEID__SWAP, moduleGitCommit_) {
126         uniswapRouter = uniswapRouter_;
127         oneInch = oneInch_;
128     }
129 
130     /// @notice Execute Uniswap V3 exact input trade on a single pool
131     /// @param params struct defining trade parameters
132     function swapUniExactInputSingle(SwapUniExactInputSingleParams memory params) external nonReentrant {
133         SwapCache memory swap = initSwap(
134             params.underlyingIn,
135             params.underlyingOut,
136             params.amountIn,
137             params.subAccountIdIn,
138             params.subAccountIdOut,
139             SWAP_TYPE__UNI_EXACT_INPUT_SINGLE
140         );
141 
142         setWithdrawAmounts(swap, params.amountIn);
143 
144         Utils.safeApprove(params.underlyingIn, uniswapRouter, swap.amountIn);
145 
146         swap.amountOut = ISwapRouterV3(uniswapRouter).exactInputSingle(
147             ISwapRouterV3.ExactInputSingleParams({
148                 tokenIn: params.underlyingIn,
149                 tokenOut: params.underlyingOut,
150                 fee: params.fee,
151                 recipient: address(this),
152                 deadline: params.deadline > 0 ? params.deadline : block.timestamp,
153                 amountIn: swap.amountIn,
154                 amountOutMinimum: params.amountOutMinimum,
155                 sqrtPriceLimitX96: params.sqrtPriceLimitX96
156             })
157         );
158 
159         finalizeSwap(swap);
160     }
161 
162     /// @notice Execute Uniswap V3 exact input trade routed through multiple pools
163     /// @param params struct defining trade parameters
164     function swapUniExactInput(SwapUniExactInputParams memory params) external nonReentrant {
165         (address underlyingIn, address underlyingOut) = decodeUniPath(params.path, false);
166 
167         SwapCache memory swap = initSwap(
168             underlyingIn,
169             underlyingOut,
170             params.amountIn,
171             params.subAccountIdIn,
172             params.subAccountIdOut,
173             SWAP_TYPE__UNI_EXACT_INPUT
174         );
175 
176         setWithdrawAmounts(swap, params.amountIn);
177 
178         Utils.safeApprove(underlyingIn, uniswapRouter, swap.amountIn);
179 
180         swap.amountOut = ISwapRouterV3(uniswapRouter).exactInput(
181             ISwapRouterV3.ExactInputParams({
182                 path: params.path,
183                 recipient: address(this),
184                 deadline: params.deadline > 0 ? params.deadline : block.timestamp,
185                 amountIn: swap.amountIn,
186                 amountOutMinimum: params.amountOutMinimum
187             })
188         );
189 
190         finalizeSwap(swap);
191     }
192 
193     /// @notice Execute Uniswap V3 exact output trade on a single pool
194     /// @param params struct defining trade parameters
195     function swapUniExactOutputSingle(SwapUniExactOutputSingleParams memory params) external nonReentrant {
196         SwapCache memory swap = initSwap(
197             params.underlyingIn,
198             params.underlyingOut,
199             params.amountOut,
200             params.subAccountIdIn,
201             params.subAccountIdOut,
202             SWAP_TYPE__UNI_EXACT_OUTPUT_SINGLE
203         );
204 
205         swap.amountOut = params.amountOut;
206 
207         doSwapUniExactOutputSingle(swap, params);
208 
209         finalizeSwap(swap);
210     }
211 
212     /// @notice Execute Uniswap V3 exact output trade routed through multiple pools
213     /// @param params struct defining trade parameters
214     function swapUniExactOutput(SwapUniExactOutputParams memory params) external nonReentrant {
215         (address underlyingIn, address underlyingOut) = decodeUniPath(params.path, true);
216 
217         SwapCache memory swap = initSwap(
218             underlyingIn,
219             underlyingOut,
220             params.amountOut,
221             params.subAccountIdIn,
222             params.subAccountIdOut,
223             SWAP_TYPE__UNI_EXACT_OUTPUT
224         );
225 
226         swap.amountOut = params.amountOut;
227 
228         doSwapUniExactOutput(swap, params, underlyingIn);
229 
230         finalizeSwap(swap);
231     }
232 
233     /// @notice Trade on Uniswap V3 single pool and repay debt with bought asset
234     /// @param params struct defining trade parameters (amountOut is ignored)
235     /// @param targetDebt amount of debt that is expected to remain after trade and repay (0 to repay full debt)
236     function swapAndRepayUniSingle(SwapUniExactOutputSingleParams memory params, uint targetDebt) external nonReentrant {
237         SwapCache memory swap = initSwap(
238             params.underlyingIn,
239             params.underlyingOut,
240             targetDebt,
241             params.subAccountIdIn,
242             params.subAccountIdOut,
243             SWAP_TYPE__UNI_EXACT_OUTPUT_SINGLE_REPAY
244         );
245 
246         swap.amountOut = getRepayAmount(swap, targetDebt);
247 
248         doSwapUniExactOutputSingle(swap, params);
249 
250         finalizeSwapAndRepay(swap);
251     }
252 
253     /// @notice Trade on Uniswap V3 through multiple pools pool and repay debt with bought asset
254     /// @param params struct defining trade parameters (amountOut is ignored)
255     /// @param targetDebt amount of debt that is expected to remain after trade and repay (0 to repay full debt)
256     function swapAndRepayUni(SwapUniExactOutputParams memory params, uint targetDebt) external nonReentrant {
257         (address underlyingIn, address underlyingOut) = decodeUniPath(params.path, true);
258 
259         SwapCache memory swap = initSwap(
260             underlyingIn,
261             underlyingOut,
262             targetDebt,
263             params.subAccountIdIn,
264             params.subAccountIdOut,
265             SWAP_TYPE__UNI_EXACT_OUTPUT_REPAY
266         );
267 
268         swap.amountOut = getRepayAmount(swap, targetDebt);
269 
270         doSwapUniExactOutput(swap, params, underlyingIn);
271 
272         finalizeSwapAndRepay(swap);
273     }
274 
275     /// @notice Execute 1Inch V4 trade
276     /// @param params struct defining trade parameters
277     function swap1Inch(Swap1InchParams memory params) external nonReentrant {
278         SwapCache memory swap = initSwap(
279             params.underlyingIn,
280             params.underlyingOut,
281             params.amount,
282             params.subAccountIdIn,
283             params.subAccountIdOut,
284             SWAP_TYPE__1INCH
285         );
286 
287         setWithdrawAmounts(swap, params.amount);
288 
289         Utils.safeApprove(params.underlyingIn, oneInch, swap.amountIn);
290 
291         (bool success, bytes memory result) = oneInch.call(params.payload);
292         if (!success) revertBytes(result);
293 
294         swap.amountOut = abi.decode(result, (uint));
295         require(swap.amountOut >= params.amountOutMinimum, "e/swap/min-amount-out");
296 
297         finalizeSwap(swap);
298     }
299 
300     function initSwap(
301         address underlyingIn,
302         address underlyingOut,
303         uint amount,
304         uint subAccountIdIn,
305         uint subAccountIdOut,
306         uint swapType
307     ) private returns (SwapCache memory swap) {
308         require(underlyingIn != underlyingOut, "e/swap/same");
309 
310         address msgSender = unpackTrailingParamMsgSender();
311         swap.accountIn = getSubAccount(msgSender, subAccountIdIn);
312         swap.accountOut = getSubAccount(msgSender, subAccountIdOut);
313 
314         updateAverageLiquidity(swap.accountIn);
315         if (swap.accountIn != swap.accountOut)
316             updateAverageLiquidity(swap.accountOut);
317 
318         emit RequestSwap(
319             swap.accountIn,
320             swap.accountOut,
321             underlyingIn,
322             underlyingOut,
323             amount,
324             swapType
325         );
326 
327         swap.eTokenIn = underlyingLookup[underlyingIn].eTokenAddress;
328         swap.eTokenOut = underlyingLookup[underlyingOut].eTokenAddress;
329 
330         AssetStorage storage assetStorageIn = eTokenLookup[swap.eTokenIn];
331         AssetStorage storage assetStorageOut = eTokenLookup[swap.eTokenOut];
332 
333         require(swap.eTokenIn != address(0), "e/swap/in-market-not-activated");
334         require(swap.eTokenOut != address(0), "e/swap/out-market-not-activated");
335 
336         swap.assetCacheIn = loadAssetCache(underlyingIn, assetStorageIn);
337         swap.assetCacheOut = loadAssetCache(underlyingOut, assetStorageOut);
338 
339         swap.balanceIn = callBalanceOf(swap.assetCacheIn, address(this)) ;
340         swap.balanceOut = callBalanceOf(swap.assetCacheOut, address(this));
341     }
342 
343     function doSwapUniExactOutputSingle(SwapCache memory swap, SwapUniExactOutputSingleParams memory params) private {
344         Utils.safeApprove(params.underlyingIn, uniswapRouter, params.amountInMaximum);
345 
346         uint pulledAmountIn = ISwapRouterV3(uniswapRouter).exactOutputSingle(
347             ISwapRouterV3.ExactOutputSingleParams({
348                 tokenIn: params.underlyingIn,
349                 tokenOut: params.underlyingOut,
350                 fee: params.fee,
351                 recipient: address(this),
352                 deadline: params.deadline > 0 ? params.deadline : block.timestamp,
353                 amountOut: swap.amountOut,
354                 amountInMaximum: params.amountInMaximum,
355                 sqrtPriceLimitX96: params.sqrtPriceLimitX96
356             })
357         );
358         require(pulledAmountIn != type(uint).max, "e/swap/exact-out-amount-in");
359 
360         setWithdrawAmounts(swap, pulledAmountIn);
361 
362         if (swap.amountIn < params.amountInMaximum) {
363             Utils.safeApprove(params.underlyingIn, uniswapRouter, 0);
364         }
365     }
366 
367     function doSwapUniExactOutput(SwapCache memory swap, SwapUniExactOutputParams memory params, address underlyingIn) private {
368         Utils.safeApprove(underlyingIn, uniswapRouter, params.amountInMaximum);
369 
370         uint pulledAmountIn = ISwapRouterV3(uniswapRouter).exactOutput(
371             ISwapRouterV3.ExactOutputParams({
372                 path: params.path,
373                 recipient: address(this),
374                 deadline: params.deadline > 0 ? params.deadline : block.timestamp,
375                 amountOut: swap.amountOut,
376                 amountInMaximum: params.amountInMaximum
377             })
378         );
379         require(pulledAmountIn != type(uint).max, "e/swap/exact-out-amount-in");
380 
381         setWithdrawAmounts(swap, pulledAmountIn);
382 
383         if (swap.amountIn < params.amountInMaximum) {
384             Utils.safeApprove(underlyingIn, uniswapRouter, 0);
385         }
386     }
387 
388     function setWithdrawAmounts(SwapCache memory swap, uint amount) private view {
389         (amount, swap.amountInternalIn) = withdrawAmounts(eTokenLookup[swap.eTokenIn], swap.assetCacheIn, swap.accountIn, amount);
390         require(swap.assetCacheIn.poolSize >= amount, "e/swap/insufficient-pool-size");
391 
392         swap.amountIn = amount / swap.assetCacheIn.underlyingDecimalsScaler;
393     }
394 
395     function finalizeSwap(SwapCache memory swap) private {
396         uint balanceIn = checkBalances(swap);
397 
398         processWithdraw(eTokenLookup[swap.eTokenIn], swap.assetCacheIn, swap.eTokenIn, swap.accountIn, swap.amountInternalIn, balanceIn);
399 
400         processDeposit(eTokenLookup[swap.eTokenOut], swap.assetCacheOut, swap.eTokenOut, swap.accountOut, swap.amountOut);
401 
402         checkLiquidity(swap.accountIn);
403     }
404 
405     function finalizeSwapAndRepay(SwapCache memory swap) private {
406         uint balanceIn = checkBalances(swap);
407 
408         processWithdraw(eTokenLookup[swap.eTokenIn], swap.assetCacheIn, swap.eTokenIn, swap.accountIn, swap.amountInternalIn, balanceIn);
409 
410         processRepay(eTokenLookup[swap.eTokenOut], swap.assetCacheOut, swap.accountOut, swap.amountOut);
411 
412         // only checking outgoing account, repay can't lower health score
413         checkLiquidity(swap.accountIn);
414     }
415 
416     function processWithdraw(AssetStorage storage assetStorage, AssetCache memory assetCache, address eTokenAddress, address account, uint amountInternal, uint balanceIn) private {
417         assetCache.poolSize = decodeExternalAmount(assetCache, balanceIn);
418 
419         decreaseBalance(assetStorage, assetCache, eTokenAddress, account, amountInternal);
420 
421         logAssetStatus(assetCache);
422     }
423 
424     function processDeposit(AssetStorage storage assetStorage, AssetCache memory assetCache, address eTokenAddress, address account, uint amount) private {
425         uint amountDecoded = decodeExternalAmount(assetCache, amount);
426         uint amountInternal = underlyingAmountToBalance(assetCache, amountDecoded);
427 
428         assetCache.poolSize += amountDecoded;
429 
430         increaseBalance(assetStorage, assetCache, eTokenAddress, account, amountInternal);
431 
432         // Depositing a token to an account with pre-existing debt in that token creates a self-collateralized loan
433         // which may result in borrow isolation violation if other tokens are also borrowed on the account
434         if (assetStorage.users[account].owed != 0) checkLiquidity(account);
435 
436         logAssetStatus(assetCache);
437     }
438 
439     function processRepay(AssetStorage storage assetStorage, AssetCache memory assetCache, address account, uint amount) private {
440         decreaseBorrow(assetStorage, assetCache, assetStorage.dTokenAddress, account, decodeExternalAmount(assetCache, amount));
441 
442         logAssetStatus(assetCache);
443     }
444 
445     function checkBalances(SwapCache memory swap) private view returns (uint) {
446         uint balanceIn = callBalanceOf(swap.assetCacheIn, address(this));
447 
448         require(balanceIn == swap.balanceIn - swap.amountIn, "e/swap/balance-in");
449         require(callBalanceOf(swap.assetCacheOut, address(this)) == swap.balanceOut + swap.amountOut, "e/swap/balance-out");
450 
451         return balanceIn;
452     }
453 
454     function decodeUniPath(bytes memory path, bool isExactOutput) private pure returns (address, address) {
455         require(path.length >= 20 + 3 + 20, "e/swap/uni-path-length");
456         require((path.length - 20) % 23 == 0, "e/swap/uni-path-format");
457 
458         address token0 = toAddress(path, 0);
459         address token1 = toAddress(path, path.length - 20);
460 
461         return isExactOutput ? (token1, token0) : (token0, token1);
462     }
463 
464     function getRepayAmount(SwapCache memory swap, uint targetDebt) private view returns (uint) {
465         uint owed = getCurrentOwed(eTokenLookup[swap.eTokenOut], swap.assetCacheOut, swap.accountOut) / swap.assetCacheOut.underlyingDecimalsScaler;
466         require (owed > targetDebt, "e/swap/target-debt");
467         return owed - targetDebt;
468     }
469 
470     function toAddress(bytes memory data, uint start) private pure returns (address result) {
471         // assuming data length is already validated
472         assembly {
473             // borrowed from BytesLib https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
474             result := div(mload(add(add(data, 0x20), start)), 0x1000000000000000000000000)
475         }
476     }
477 }
