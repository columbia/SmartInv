1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 import "../IRiskManager.sol";
7 import "../vendor/TickMath.sol";
8 import "../vendor/FullMath.sol";
9 
10 
11 
12 interface IUniswapV3Factory {
13     function getPool(address tokenA, address tokenB, uint24 fee) external view returns (address pool);
14 }
15 
16 interface IUniswapV3Pool {
17     function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked);
18     function liquidity() external view returns (uint128);
19     function observe(uint32[] calldata secondsAgos) external view returns (int56[] memory tickCumulatives, uint160[] memory liquidityCumulatives);
20     function observations(uint256 index) external view returns (uint32 blockTimestamp, int56 tickCumulative, uint160 liquidityCumulative, bool initialized);
21     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
22 }
23 
24 interface IChainlinkAggregatorV2V3 {
25     function latestAnswer() external view returns (int256);
26 }
27 
28 contract RiskManager is IRiskManager, BaseLogic {
29     // Construction
30 
31     address immutable referenceAsset; // Token must have 18 decimals
32     address immutable uniswapFactory;
33     bytes32 immutable uniswapPoolInitCodeHash;
34 
35     struct RiskManagerSettings {
36         address referenceAsset;
37         address uniswapFactory;
38         bytes32 uniswapPoolInitCodeHash;
39     }
40 
41     constructor(bytes32 moduleGitCommit_, RiskManagerSettings memory settings) BaseLogic(MODULEID__RISK_MANAGER, moduleGitCommit_) {
42         referenceAsset = settings.referenceAsset;
43         uniswapFactory = settings.uniswapFactory;
44         uniswapPoolInitCodeHash = settings.uniswapPoolInitCodeHash;
45     }
46 
47 
48     // Default market parameters
49 
50     function getNewMarketParameters(address underlying) external override returns (NewMarketParameters memory p) {
51         p.config.borrowIsolated = true;
52         p.config.collateralFactor = uint32(0);
53         p.config.borrowFactor = type(uint32).max;
54         p.config.twapWindow = type(uint24).max;
55 
56         if (underlying == referenceAsset) {
57             // 1:1 peg
58 
59             p.pricingType = PRICINGTYPE__PEGGED;
60             p.pricingParameters = uint32(0);
61         } else if (pTokenLookup[underlying] != address(0)) {
62             p.pricingType = PRICINGTYPE__FORWARDED;
63             p.pricingParameters = uint32(0);
64 
65             p.config.collateralFactor = underlyingLookup[pTokenLookup[underlying]].collateralFactor;
66         } else {
67             // Uniswap3 TWAP
68 
69             // The uniswap pool (fee-level) with the highest in-range liquidity is used by default.
70             // This is a heuristic and can easily be manipulated by the activator, so users should
71             // verify the selection is suitable before using the pool. Otherwise, governance will
72             // need to change the pricing config for the market.
73 
74             address pool = address(0);
75             uint24 fee = 0;
76 
77             {
78                 uint24[4] memory fees = [uint24(3000), 10000, 500, 100];
79                 uint128 bestLiquidity = 0;
80 
81                 for (uint i = 0; i < fees.length; ++i) {
82                     address candidatePool = IUniswapV3Factory(uniswapFactory).getPool(underlying, referenceAsset, fees[i]);
83                     if (candidatePool == address(0)) continue;
84 
85                     uint128 liquidity = IUniswapV3Pool(candidatePool).liquidity();
86 
87                     if (pool == address(0) || liquidity > bestLiquidity) {
88                         pool = candidatePool;
89                         fee = fees[i];
90                         bestLiquidity = liquidity;
91                     }
92                 }
93             }
94 
95             require(pool != address(0), "e/no-uniswap-pool-avail");
96             require(computeUniswapPoolAddress(underlying, fee) == pool, "e/bad-uniswap-pool-addr");
97 
98             p.pricingType = PRICINGTYPE__UNISWAP3_TWAP;
99             p.pricingParameters = uint32(fee);
100 
101             try IUniswapV3Pool(pool).increaseObservationCardinalityNext(MIN_UNISWAP3_OBSERVATION_CARDINALITY) {
102                 // Success
103             } catch Error(string memory err) {
104                 if (keccak256(bytes(err)) == keccak256("LOK")) revert("e/risk/uniswap-pool-not-inited");
105                 revert(string(abi.encodePacked("e/risk/uniswap/", err)));
106             } catch (bytes memory returnData) {
107                 revertBytes(returnData);
108             }
109         }
110     }
111 
112 
113 
114     // Pricing
115 
116     function computeUniswapPoolAddress(address underlying, uint24 fee) private view returns (address) {
117         address tokenA = underlying;
118         address tokenB = referenceAsset;
119         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
120 
121         return address(uint160(uint256(keccak256(abi.encodePacked(
122                    hex'ff',
123                    uniswapFactory,
124                    keccak256(abi.encode(tokenA, tokenB, fee)),
125                    uniswapPoolInitCodeHash
126                )))));
127     }
128 
129 
130     function decodeSqrtPriceX96(address underlying, uint underlyingDecimalsScaler, uint sqrtPriceX96) private view returns (uint price) {
131         if (uint160(underlying) < uint160(referenceAsset)) {
132             price = FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, uint(2**(96*2)) / 1e18) / underlyingDecimalsScaler;
133         } else {
134             price = FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, uint(2**(96*2)) / (1e18 * underlyingDecimalsScaler));
135             if (price == 0) return 1e36;
136             price = 1e36 / price;
137         }
138 
139         if (price > 1e36) price = 1e36;
140         else if (price == 0) price = 1;
141     }
142 
143     function callUniswapObserve(address underlying, uint underlyingDecimalsScaler, address pool, uint ago) private view returns (uint, uint) {
144         uint32[] memory secondsAgos = new uint32[](2);
145 
146         secondsAgos[0] = uint32(ago);
147         secondsAgos[1] = 0;
148 
149         (bool success, bytes memory data) = pool.staticcall(abi.encodeWithSelector(IUniswapV3Pool.observe.selector, secondsAgos));
150 
151         if (!success) {
152             if (keccak256(data) != keccak256(abi.encodeWithSignature("Error(string)", "OLD"))) revertBytes(data);
153 
154             // The oldest available observation in the ring buffer is the index following the current (accounting for wrapping),
155             // since this is the one that will be overwritten next.
156 
157             (,, uint16 index, uint16 cardinality,,,) = IUniswapV3Pool(pool).slot0();
158 
159             (uint32 oldestAvailableAge,,,bool initialized) = IUniswapV3Pool(pool).observations((index + 1) % cardinality);
160 
161             // If the following observation in a ring buffer of our current cardinality is uninitialized, then all the
162             // observations at higher indices are also uninitialized, so we wrap back to index 0, which we now know
163             // to be the oldest available observation.
164 
165             if (!initialized) (oldestAvailableAge,,,) = IUniswapV3Pool(pool).observations(0);
166 
167             // Call observe() again to get the oldest available
168 
169             ago = block.timestamp - oldestAvailableAge;
170             secondsAgos[0] = uint32(ago);
171 
172             (success, data) = pool.staticcall(abi.encodeWithSelector(IUniswapV3Pool.observe.selector, secondsAgos));
173             if (!success) revertBytes(data);
174         }
175 
176         // If uniswap pool doesn't exist, then data will be empty and this decode will throw:
177 
178         int56[] memory tickCumulatives = abi.decode(data, (int56[])); // don't bother decoding the liquidityCumulatives array
179 
180         int24 tick = int24((tickCumulatives[1] - tickCumulatives[0]) / int56(int(ago)));
181 
182         uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(tick);
183 
184         return (decodeSqrtPriceX96(underlying, underlyingDecimalsScaler, sqrtPriceX96), ago);
185     }
186 
187     function callChainlinkLatestAnswer(address chainlinkAggregator) private view returns (uint price) {
188         // IMPORTANT as per H-03 item from August 2022 WatchPug audit:
189         // if Chainlink starts using shorter heartbeats and/or before deploying to the sidechain/L2,
190         // the latestAnswer call should be replaced by latestRoundData and updatedTime should be checked 
191         // to detect staleness of the oracle
192         (bool success, bytes memory data) = chainlinkAggregator.staticcall(abi.encodeWithSelector(IChainlinkAggregatorV2V3.latestAnswer.selector));
193 
194         if (!success) {
195             return 0;
196         }
197 
198         int256 answer = abi.decode(data, (int256));
199         if (answer <= 0) {
200             return 0;
201         }
202 
203         price = uint(answer);
204         if (price > 1e36) price = 1e36;
205     }
206 
207     function resolvePricingConfig(AssetCache memory assetCache, AssetConfig memory config) private view returns (address underlying, uint16 pricingType, uint32 pricingParameters, uint24 twapWindow, uint underlyingDecimalsScaler) {
208         if (assetCache.pricingType == PRICINGTYPE__FORWARDED) {
209             underlying = pTokenLookup[assetCache.underlying];
210 
211             AssetConfig memory newConfig = resolveAssetConfig(underlying);
212             twapWindow = newConfig.twapWindow;
213 
214             AssetStorage storage newAssetStorage = eTokenLookup[newConfig.eTokenAddress];
215             pricingType = newAssetStorage.pricingType;
216             pricingParameters = newAssetStorage.pricingParameters;
217             underlyingDecimalsScaler = 10**(18 - newAssetStorage.underlyingDecimals);
218 
219             require(pricingType != PRICINGTYPE__FORWARDED, "e/nested-price-forwarding");
220         } else {
221             underlying = assetCache.underlying;
222             pricingType = assetCache.pricingType;
223             pricingParameters = assetCache.pricingParameters;
224             twapWindow = config.twapWindow;
225             underlyingDecimalsScaler = assetCache.underlyingDecimalsScaler;
226         }
227     }
228 
229     function getPriceInternal(AssetCache memory assetCache, AssetConfig memory config) public view FREEMEM returns (uint twap, uint twapPeriod) {
230         (address underlying, uint16 pricingType, uint32 pricingParameters, uint24 twapWindow, uint underlyingDecimalsScaler) = resolvePricingConfig(assetCache, config);
231 
232         if (pricingType == PRICINGTYPE__PEGGED) {
233             twap = 1e18;
234             twapPeriod = twapWindow;
235         } else if (pricingType == PRICINGTYPE__UNISWAP3_TWAP) {
236             address pool = computeUniswapPoolAddress(underlying, uint24(pricingParameters));
237             (twap, twapPeriod) = callUniswapObserve(underlying, underlyingDecimalsScaler, pool, twapWindow);
238         } else if (pricingType == PRICINGTYPE__CHAINLINK) {
239             twap = callChainlinkLatestAnswer(chainlinkPriceFeedLookup[underlying]);
240             twapPeriod = 0;
241 
242             // if price invalid and uniswap fallback pool configured get the price from uniswap
243             if (twap == 0 && uint24(pricingParameters) != 0) {
244                 address pool = computeUniswapPoolAddress(underlying, uint24(pricingParameters));
245                 (twap, twapPeriod) = callUniswapObserve(underlying, underlyingDecimalsScaler, pool, twapWindow);
246             }
247 
248             require(twap != 0, "e/unable-to-get-the-price");
249         } else {
250             revert("e/unknown-pricing-type");
251         }
252     }
253 
254     function getPrice(address underlying) external view override returns (uint twap, uint twapPeriod) {
255         AssetConfig memory config = resolveAssetConfig(underlying);
256         AssetStorage storage assetStorage = eTokenLookup[config.eTokenAddress];
257         AssetCache memory assetCache = internalLoadAssetCacheRO(underlying, assetStorage);
258 
259         (twap, twapPeriod) = getPriceInternal(assetCache, config);
260     }
261 
262     // This function is only meant to be called from a view so it doesn't need to be optimised.
263     // The Euler protocol itself doesn't ever use currPrice as returned by this function.
264 
265     function getPriceFull(address underlying) external view override returns (uint twap, uint twapPeriod, uint currPrice) {
266         AssetConfig memory config = resolveAssetConfig(underlying);
267         AssetStorage storage assetStorage = eTokenLookup[config.eTokenAddress];
268         AssetCache memory assetCache = internalLoadAssetCacheRO(underlying, assetStorage);
269 
270         (twap, twapPeriod) = getPriceInternal(assetCache, config);
271 
272         (address newUnderlying, uint16 pricingType, uint32 pricingParameters, , uint underlyingDecimalsScaler) = resolvePricingConfig(assetCache, config);
273 
274         if (pricingType == PRICINGTYPE__PEGGED) {
275             currPrice = 1e18;
276         } else if (pricingType == PRICINGTYPE__UNISWAP3_TWAP || pricingType == PRICINGTYPE__FORWARDED) {
277             address pool = computeUniswapPoolAddress(newUnderlying, uint24(pricingParameters));
278             (uint160 sqrtPriceX96,,,,,,) = IUniswapV3Pool(pool).slot0();
279             currPrice = decodeSqrtPriceX96(newUnderlying, underlyingDecimalsScaler, sqrtPriceX96);
280         } else if (pricingType == PRICINGTYPE__CHAINLINK) {
281             currPrice = twap;
282         } else {
283             revert("e/unknown-pricing-type");
284         }
285     }
286 
287 
288     // Liquidity
289 
290     function computeLiquidityRaw(address account, address[] memory underlyings) private view returns (LiquidityStatus memory status) {
291         status.collateralValue = 0;
292         status.liabilityValue = 0;
293         status.numBorrows = 0;
294         status.borrowIsolated = false;
295 
296         AssetConfig memory config;
297         AssetStorage storage assetStorage;
298         AssetCache memory assetCache;
299 
300         for (uint i = 0; i < underlyings.length; ++i) {
301             address underlying = underlyings[i];
302 
303             config = resolveAssetConfig(underlying);
304             assetStorage = eTokenLookup[config.eTokenAddress];
305 
306             uint balance = assetStorage.users[account].balance;
307             uint owed = assetStorage.users[account].owed;
308 
309             if (owed != 0) {
310                 initAssetCache(underlying, assetStorage, assetCache);
311                 (uint price,) = getPriceInternal(assetCache, config);
312 
313                 status.numBorrows++;
314                 if (config.borrowIsolated) status.borrowIsolated = true;
315 
316                 uint assetLiability = getCurrentOwed(assetStorage, assetCache, account);
317 
318                 if (balance != 0) { // self-collateralisation
319                     uint balanceInUnderlying = balanceToUnderlyingAmount(assetCache, balance);
320 
321                     uint selfAmount = assetLiability;
322                     uint selfAmountAdjusted = assetLiability * CONFIG_FACTOR_SCALE / SELF_COLLATERAL_FACTOR;
323 
324                     if (selfAmountAdjusted > balanceInUnderlying) {
325                         selfAmount = balanceInUnderlying * SELF_COLLATERAL_FACTOR / CONFIG_FACTOR_SCALE;
326                         selfAmountAdjusted = balanceInUnderlying;
327                     }
328 
329                     {
330                         uint assetCollateral = (balanceInUnderlying - selfAmountAdjusted) * config.collateralFactor / CONFIG_FACTOR_SCALE;
331                         assetCollateral += selfAmount;
332                         status.collateralValue += assetCollateral * price / 1e18;
333                     }
334 
335                     assetLiability -= selfAmount;
336                     status.liabilityValue += selfAmount * price / 1e18;
337                     status.borrowIsolated = true; // self-collateralised loans are always isolated
338                 }
339 
340                 assetLiability = assetLiability * price / 1e18;
341                 assetLiability = config.borrowFactor != 0 ? assetLiability * CONFIG_FACTOR_SCALE / config.borrowFactor : MAX_SANE_DEBT_AMOUNT;
342                 status.liabilityValue += assetLiability;
343             } else if (balance != 0 && config.collateralFactor != 0) {
344                 initAssetCache(underlying, assetStorage, assetCache);
345                 (uint price,) = getPriceInternal(assetCache, config);
346 
347                 uint balanceInUnderlying = balanceToUnderlyingAmount(assetCache, balance);
348                 uint assetCollateral = balanceInUnderlying * price / 1e18;
349                 assetCollateral = assetCollateral * config.collateralFactor / CONFIG_FACTOR_SCALE;
350                 status.collateralValue += assetCollateral;
351             }
352         }
353     }
354 
355     function computeLiquidity(address account) public view override returns (LiquidityStatus memory) {
356         return computeLiquidityRaw(account, getEnteredMarketsArray(account));
357     }
358 
359     function computeAssetLiquidities(address account) external view override returns (AssetLiquidity[] memory) {
360         address[] memory underlyings = getEnteredMarketsArray(account);
361 
362         AssetLiquidity[] memory output = new AssetLiquidity[](underlyings.length);
363 
364         address[] memory singleUnderlying = new address[](1);
365 
366         for (uint i = 0; i < underlyings.length; ++i) {
367             output[i].underlying = singleUnderlying[0] = underlyings[i];
368             output[i].status = computeLiquidityRaw(account, singleUnderlying);
369         }
370 
371         return output;
372     }
373 
374     function requireLiquidity(address account) external view override {
375         LiquidityStatus memory status = computeLiquidity(account);
376 
377         require(!status.borrowIsolated || status.numBorrows == 1, "e/borrow-isolation-violation");
378         require(status.collateralValue >= status.liabilityValue, "e/collateral-violation");
379     }
380 }
