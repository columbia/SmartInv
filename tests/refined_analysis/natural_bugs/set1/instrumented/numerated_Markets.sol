1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 import "../IRiskManager.sol";
7 import "../PToken.sol";
8 
9 
10 /// @notice Activating and querying markets, and maintaining entered markets lists
11 contract Markets is BaseLogic {
12     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__MARKETS, moduleGitCommit_) {}
13 
14     /// @notice Create an Euler pool and associated EToken and DToken addresses.
15     /// @param underlying The address of an ERC20-compliant token. There must be an initialised uniswap3 pool for the underlying/reference asset pair.
16     /// @return The created EToken, or the existing EToken if already activated.
17     function activateMarket(address underlying) external nonReentrant returns (address) {
18         require(pTokenLookup[underlying] == address(0), "e/markets/invalid-token");
19         return doActivateMarket(underlying);
20     }
21 
22     function doActivateMarket(address underlying) private returns (address) {
23         // Pre-existing
24 
25         if (underlyingLookup[underlying].eTokenAddress != address(0)) return underlyingLookup[underlying].eTokenAddress;
26 
27 
28         // Validation
29 
30         require(trustedSenders[underlying].moduleId == 0 && underlying != address(this), "e/markets/invalid-token");
31 
32         uint8 decimals = IERC20(underlying).decimals();
33         require(decimals <= 18, "e/too-many-decimals");
34 
35 
36         // Get risk manager parameters
37 
38         IRiskManager.NewMarketParameters memory params;
39 
40         {
41             bytes memory result = callInternalModule(MODULEID__RISK_MANAGER,
42                                                      abi.encodeWithSelector(IRiskManager.getNewMarketParameters.selector, underlying));
43             (params) = abi.decode(result, (IRiskManager.NewMarketParameters));
44         }
45 
46 
47         // Create proxies
48 
49         address childEToken = params.config.eTokenAddress = _createProxy(MODULEID__ETOKEN);
50         address childDToken = _createProxy(MODULEID__DTOKEN);
51 
52 
53         // Setup storage
54 
55         underlyingLookup[underlying] = params.config;
56 
57         dTokenLookup[childDToken] = childEToken;
58 
59         AssetStorage storage assetStorage = eTokenLookup[childEToken];
60 
61         assetStorage.underlying = underlying;
62         assetStorage.pricingType = params.pricingType;
63         assetStorage.pricingParameters = params.pricingParameters;
64 
65         assetStorage.dTokenAddress = childDToken;
66 
67         assetStorage.lastInterestAccumulatorUpdate = uint40(block.timestamp);
68         assetStorage.underlyingDecimals = decimals;
69         assetStorage.interestRateModel = uint32(MODULEID__IRM_DEFAULT);
70         assetStorage.reserveFee = type(uint32).max; // default
71 
72         {
73             assetStorage.reserveBalance = encodeSmallAmount(INITIAL_RESERVES);
74             assetStorage.totalBalances = encodeAmount(INITIAL_RESERVES);
75         }
76 
77         assetStorage.interestAccumulator = INITIAL_INTEREST_ACCUMULATOR;
78 
79 
80         emit MarketActivated(underlying, childEToken, childDToken);
81 
82         return childEToken;
83     }
84 
85     /// @notice Create a pToken and activate it on Euler. pTokens are protected wrappers around assets that prevent borrowing.
86     /// @param underlying The address of an ERC20-compliant token. There must already be an activated market on Euler for this underlying, and it must have a non-zero collateral factor.
87     /// @return The created pToken, or an existing one if already activated.
88     function activatePToken(address underlying) external nonReentrant returns (address) {
89         require(pTokenLookup[underlying] == address(0), "e/nested-ptoken");
90 
91         if (reversePTokenLookup[underlying] != address(0)) return reversePTokenLookup[underlying];
92 
93         {
94             AssetConfig memory config = resolveAssetConfig(underlying);
95             require(config.collateralFactor != 0, "e/ptoken/not-collateral");
96         }
97  
98         address pTokenAddr = address(new PToken(address(this), underlying));
99 
100         pTokenLookup[pTokenAddr] = underlying;
101         reversePTokenLookup[underlying] = pTokenAddr;
102 
103         emit PTokenActivated(underlying, pTokenAddr);
104 
105         doActivateMarket(pTokenAddr);
106 
107         return pTokenAddr;
108     }
109 
110 
111     // General market accessors
112 
113     /// @notice Given an underlying, lookup the associated EToken
114     /// @param underlying Token address
115     /// @return EToken address, or address(0) if not activated
116     function underlyingToEToken(address underlying) external view returns (address) {
117         return underlyingLookup[underlying].eTokenAddress;
118     }
119 
120     /// @notice Given an underlying, lookup the associated DToken
121     /// @param underlying Token address
122     /// @return DToken address, or address(0) if not activated
123     function underlyingToDToken(address underlying) external view returns (address) {
124         return eTokenLookup[underlyingLookup[underlying].eTokenAddress].dTokenAddress;
125     }
126 
127     /// @notice Given an underlying, lookup the associated PToken
128     /// @param underlying Token address
129     /// @return PToken address, or address(0) if it doesn't exist
130     function underlyingToPToken(address underlying) external view returns (address) {
131         return reversePTokenLookup[underlying];
132     }
133 
134     /// @notice Looks up the Euler-related configuration for a token, and resolves all default-value placeholders to their currently configured values.
135     /// @param underlying Token address
136     /// @return Configuration struct
137     function underlyingToAssetConfig(address underlying) external view returns (AssetConfig memory) {
138         return resolveAssetConfig(underlying);
139     }
140 
141     /// @notice Looks up the Euler-related configuration for a token, and returns it unresolved (with default-value placeholders)
142     /// @param underlying Token address
143     /// @return config Configuration struct
144     function underlyingToAssetConfigUnresolved(address underlying) external view returns (AssetConfig memory config) {
145         config = underlyingLookup[underlying];
146         require(config.eTokenAddress != address(0), "e/market-not-activated");
147     }
148 
149     /// @notice Given an EToken address, looks up the associated underlying
150     /// @param eToken EToken address
151     /// @return underlying Token address
152     function eTokenToUnderlying(address eToken) external view returns (address underlying) {
153         underlying = eTokenLookup[eToken].underlying;
154         require(underlying != address(0), "e/invalid-etoken");
155     }
156 
157     /// @notice Given a DToken address, looks up the associated underlying
158     /// @param dToken DToken address
159     /// @return underlying Token address
160     function dTokenToUnderlying(address dToken) external view returns (address underlying) {
161         address eToken = dTokenLookup[dToken];
162         require(eToken != address(0), "e/invalid-dtoken");
163         return eTokenLookup[eToken].underlying;
164     }
165 
166     /// @notice Given an EToken address, looks up the associated DToken
167     /// @param eToken EToken address
168     /// @return dTokenAddr DToken address
169     function eTokenToDToken(address eToken) external view returns (address dTokenAddr) {
170         dTokenAddr = eTokenLookup[eToken].dTokenAddress;
171         require(dTokenAddr != address(0), "e/invalid-etoken");
172     }
173 
174 
175     function getAssetStorage(address underlying) private view returns (AssetStorage storage) {
176         address eTokenAddr = underlyingLookup[underlying].eTokenAddress;
177         require(eTokenAddr != address(0), "e/market-not-activated");
178         return eTokenLookup[eTokenAddr];
179     }
180 
181     /// @notice Looks up an asset's currently configured interest rate model
182     /// @param underlying Token address
183     /// @return Module ID that represents the interest rate model (IRM)
184     function interestRateModel(address underlying) external view returns (uint) {
185         AssetStorage storage assetStorage = getAssetStorage(underlying);
186 
187         return assetStorage.interestRateModel;
188     }
189 
190     /// @notice Retrieves the current interest rate for an asset
191     /// @param underlying Token address
192     /// @return The interest rate in yield-per-second, scaled by 10**27
193     function interestRate(address underlying) external view returns (int96) {
194         AssetStorage storage assetStorage = getAssetStorage(underlying);
195 
196         return assetStorage.interestRate;
197     }
198 
199     /// @notice Retrieves the current interest rate accumulator for an asset
200     /// @param underlying Token address
201     /// @return An opaque accumulator that increases as interest is accrued
202     function interestAccumulator(address underlying) external view returns (uint) {
203         AssetStorage storage assetStorage = getAssetStorage(underlying);
204         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
205 
206         return assetCache.interestAccumulator;
207     }
208 
209     /// @notice Retrieves the reserve fee in effect for an asset
210     /// @param underlying Token address
211     /// @return Amount of interest that is redirected to the reserves, as a fraction scaled by RESERVE_FEE_SCALE (4e9)
212     function reserveFee(address underlying) external view returns (uint32) {
213         AssetStorage storage assetStorage = getAssetStorage(underlying);
214 
215         return assetStorage.reserveFee == type(uint32).max ? uint32(DEFAULT_RESERVE_FEE) : assetStorage.reserveFee;
216     }
217 
218     /// @notice Retrieves the pricing config for an asset
219     /// @param underlying Token address
220     /// @return pricingType (1=pegged, 2=uniswap3, 3=forwarded, 4=chainlink)
221     /// @return pricingParameters If uniswap3 pricingType then this represents the uniswap pool fee used, if chainlink pricing type this represents the fallback uniswap pool fee or 0 if none
222     /// @return pricingForwarded If forwarded pricingType then this is the address prices are forwarded to, otherwise address(0)
223     function getPricingConfig(address underlying) external view returns (uint16 pricingType, uint32 pricingParameters, address pricingForwarded) {
224         AssetStorage storage assetStorage = getAssetStorage(underlying);
225 
226         pricingType = assetStorage.pricingType;
227         pricingParameters = assetStorage.pricingParameters;
228 
229         pricingForwarded = pricingType == PRICINGTYPE__FORWARDED ? pTokenLookup[underlying] : address(0);
230     }
231 
232     /// @notice Retrieves the Chainlink price feed config for an asset
233     /// @param underlying Token address
234     /// @return chainlinkAggregator Chainlink aggregator proxy address
235     function getChainlinkPriceFeedConfig(address underlying) external view returns (address chainlinkAggregator) {
236         chainlinkAggregator = chainlinkPriceFeedLookup[underlying];
237     }
238 
239     
240     // Enter/exit markets
241 
242     /// @notice Retrieves the list of entered markets for an account (assets enabled for collateral or borrowing)
243     /// @param account User account
244     /// @return List of underlying token addresses
245     function getEnteredMarkets(address account) external view returns (address[] memory) {
246         return getEnteredMarketsArray(account);
247     }
248 
249     /// @notice Add an asset to the entered market list, or do nothing if already entered
250     /// @param subAccountId 0 for primary, 1-255 for a sub-account
251     /// @param newMarket Underlying token address
252     function enterMarket(uint subAccountId, address newMarket) external nonReentrant {
253         address msgSender = unpackTrailingParamMsgSender();
254         address account = getSubAccount(msgSender, subAccountId);
255 
256         require(underlyingLookup[newMarket].eTokenAddress != address(0), "e/market-not-activated");
257 
258         doEnterMarket(account, newMarket);
259     }
260 
261     /// @notice Remove an asset from the entered market list, or do nothing if not already present
262     /// @param subAccountId 0 for primary, 1-255 for a sub-account
263     /// @param oldMarket Underlying token address
264     function exitMarket(uint subAccountId, address oldMarket) external nonReentrant {
265         address msgSender = unpackTrailingParamMsgSender();
266         address account = getSubAccount(msgSender, subAccountId);
267 
268         AssetConfig memory config = resolveAssetConfig(oldMarket);
269         AssetStorage storage assetStorage = eTokenLookup[config.eTokenAddress];
270 
271         uint balance = assetStorage.users[account].balance;
272         uint owed = assetStorage.users[account].owed;
273 
274         require(owed == 0, "e/outstanding-borrow");
275 
276         doExitMarket(account, oldMarket);
277 
278         if (config.collateralFactor != 0 && balance != 0) {
279             checkLiquidity(account);
280         }
281     }
282 }
