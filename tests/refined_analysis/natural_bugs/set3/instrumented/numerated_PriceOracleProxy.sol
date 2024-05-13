1 pragma solidity ^0.5.16;
2 
3 import "./Denominations.sol";
4 import "./PriceOracle.sol";
5 import "./interfaces/CurveTokenInterface.sol";
6 import "./interfaces/FeedRegistryInterface.sol";
7 import "./interfaces/UniswapV2Interface.sol";
8 import "./interfaces/V1PriceOracleInterface.sol";
9 import "./interfaces/XSushiExchangeRateInterface.sol";
10 import "./interfaces/YVaultTokenInterface.sol";
11 import "../CErc20.sol";
12 import "../CToken.sol";
13 import "../Exponential.sol";
14 import "../EIP20Interface.sol";
15 
16 contract PriceOracleProxy is PriceOracle, Exponential, Denominations {
17     /// @notice Yvault token version, currently support v1 and v2
18     enum YvTokenVersion {
19         V1,
20         V2
21     }
22 
23     /// @notice Curve token version, currently support v1, v2 and v3
24     enum CurveTokenVersion {
25         V1,
26         V2,
27         V3
28     }
29 
30     /// @notice Curve pool type, currently support ETH and USD base
31     enum CurvePoolType {
32         ETH,
33         USD
34     }
35 
36     struct YvTokenInfo {
37         /// @notice Check if this token is a Yvault token
38         bool isYvToken;
39         /// @notice The version of Yvault
40         YvTokenVersion version;
41     }
42 
43     struct CrvTokenInfo {
44         /// @notice Check if this token is a curve pool token
45         bool isCrvToken;
46         /// @notice The curve pool type
47         CurvePoolType poolType;
48         /// @notice The curve swap contract address
49         address curveSwap;
50     }
51 
52     struct AggregatorInfo {
53         /// @notice The base
54         address base;
55         /// @notice The quote denomination
56         address quote;
57         /// @notice It's being used or not
58         bool isUsed;
59     }
60 
61     /// @notice Admin address
62     address public admin;
63 
64     /// @notice Guardian address
65     address public guardian;
66 
67     /// @notice Indicator that this is a PriceOracle contract (for inspection)
68     bool public constant isPriceOracle = true;
69 
70     /// @notice The v1 price oracle, which will continue to serve prices for v1 assets
71     V1PriceOracleInterface public v1PriceOracle;
72 
73     /// @notice The ChainLink registry address
74     FeedRegistryInterface public registry;
75 
76     /// @notice ChainLink quotes
77     mapping(address => AggregatorInfo) public aggregators;
78 
79     /// @notice Check if the underlying address is Uniswap or SushiSwap LP
80     mapping(address => bool) public isUnderlyingLP;
81 
82     /// @notice Yvault token data
83     mapping(address => YvTokenInfo) public yvTokens;
84 
85     /// @notice Curve pool token data
86     mapping(address => CrvTokenInfo) public crvTokens;
87 
88     /// @notice BTC related addresses. All these underlying we use `Denominations.BTC` as the aggregator base.
89     address[6] public btcAddresses = [
90         0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, // WBTC
91         0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D, // renBTC
92         0x9BE89D2a4cd102D8Fecc6BF9dA793be995C22541, // BBTC
93         0x8dAEBADE922dF735c38C80C7eBD708Af50815fAa, // tBTC
94         0x0316EB71485b0Ab14103307bf65a021042c6d380, // HBTC
95         0xc4E15973E6fF2A35cC804c2CF9D2a1b817a8b40F // ibBTC
96     ];
97 
98     address public cEthAddress;
99 
100     address public constant usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
101     address public constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
102     address public constant sushiAddress = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;
103     address public constant xSushiExRateAddress = 0x851a040fC0Dcbb13a272EBC272F2bC2Ce1e11C4d;
104     address public constant crXSushiAddress = 0x228619CCa194Fbe3Ebeb2f835eC1eA5080DaFbb2;
105 
106     /**
107      * @param admin_ The address of admin to set aggregators, LPs, curve tokens, or Yvault tokens
108      * @param v1PriceOracle_ The address of the v1 price oracle, which will continue to operate and hold prices for collateral assets
109      * @param cEthAddress_ The address of cETH, which will return a constant 1e18, since all prices relative to ether
110      * @param registry_ The address of ChainLink registry
111      */
112     constructor(
113         address admin_,
114         address v1PriceOracle_,
115         address cEthAddress_,
116         address registry_
117     ) public {
118         admin = admin_;
119         v1PriceOracle = V1PriceOracleInterface(v1PriceOracle_);
120         cEthAddress = cEthAddress_;
121         registry = FeedRegistryInterface(registry_);
122     }
123 
124     /**
125      * @notice Get the underlying price of a listed cToken asset
126      * @param cToken The cToken to get the underlying price of
127      * @return The underlying asset price mantissa (scaled by 1e18)
128      */
129     function getUnderlyingPrice(CToken cToken) public view returns (uint256) {
130         address cTokenAddress = address(cToken);
131         if (cTokenAddress == cEthAddress) {
132             // ether always worth 1
133             return 1e18;
134         } else if (cTokenAddress == crXSushiAddress) {
135             // Handle xSUSHI.
136             uint256 exchangeRate = XSushiExchangeRateInterface(xSushiExRateAddress).getExchangeRate();
137             return mul_(getTokenPrice(sushiAddress), Exp({mantissa: exchangeRate}));
138         }
139 
140         address underlying = CErc20(cTokenAddress).underlying();
141 
142         // Handle LP tokens.
143         if (isUnderlyingLP[underlying]) {
144             return getLPFairPrice(underlying);
145         }
146 
147         // Handle Yvault tokens.
148         if (yvTokens[underlying].isYvToken) {
149             return getYvTokenPrice(underlying);
150         }
151 
152         // Handle curve pool tokens.
153         if (crvTokens[underlying].isCrvToken) {
154             return getCrvTokenPrice(underlying);
155         }
156 
157         return getTokenPrice(underlying);
158     }
159 
160     /*** Internal fucntions ***/
161 
162     /**
163      * @notice Get the price of a specific token. Return 1e18 is it's WETH.
164      * @param token The token to get the price of
165      * @return The price
166      */
167     function getTokenPrice(address token) internal view returns (uint256) {
168         if (token == wethAddress) {
169             // weth always worth 1
170             return 1e18;
171         }
172 
173         AggregatorInfo memory aggregatorInfo = aggregators[token];
174         if (aggregatorInfo.isUsed) {
175             uint256 price = getPriceFromChainlink(aggregatorInfo.base, aggregatorInfo.quote);
176             if (aggregatorInfo.quote == Denominations.USD) {
177                 // Convert the price to ETH based if it's USD based.
178                 price = mul_(price, Exp({mantissa: getUsdcEthPrice()}));
179             }
180             uint256 underlyingDecimals = EIP20Interface(token).decimals();
181             return mul_(price, 10**(18 - underlyingDecimals));
182         }
183         return getPriceFromV1(token);
184     }
185 
186     /**
187      * @notice Get price from ChainLink
188      * @param base The base token that ChainLink aggregator gets the price of
189      * @param quote The quote token, currenlty support ETH and USD
190      * @return The price, scaled by 1e18
191      */
192     function getPriceFromChainlink(address base, address quote) internal view returns (uint256) {
193         (, int256 price, , , ) = registry.latestRoundData(base, quote);
194         require(price > 0, "invalid price");
195 
196         // Extend the decimals to 1e18.
197         return mul_(uint256(price), 10**(18 - uint256(registry.decimals(base, quote))));
198     }
199 
200     /**
201      * @notice Get the fair price of a LP. We use the mechanism from Alpha Finance.
202      *         Ref: https://blog.alphafinance.io/fair-lp-token-pricing/
203      * @param pair The pair of AMM (Uniswap or SushiSwap)
204      * @return The price
205      */
206     function getLPFairPrice(address pair) internal view returns (uint256) {
207         address token0 = IUniswapV2Pair(pair).token0();
208         address token1 = IUniswapV2Pair(pair).token1();
209         uint256 totalSupply = IUniswapV2Pair(pair).totalSupply();
210         (uint256 r0, uint256 r1, ) = IUniswapV2Pair(pair).getReserves();
211         uint256 sqrtR = sqrt(mul_(r0, r1));
212         uint256 p0 = getTokenPrice(token0);
213         uint256 p1 = getTokenPrice(token1);
214         uint256 sqrtP = sqrt(mul_(p0, p1));
215         return div_(mul_(2, mul_(sqrtR, sqrtP)), totalSupply);
216     }
217 
218     /**
219      * @notice Get price for Yvault tokens
220      * @param token The Yvault token
221      * @return The price
222      */
223     function getYvTokenPrice(address token) internal view returns (uint256) {
224         YvTokenInfo memory yvTokenInfo = yvTokens[token];
225         require(yvTokenInfo.isYvToken, "not a Yvault token");
226 
227         uint256 pricePerShare;
228         address underlying;
229         if (yvTokenInfo.version == YvTokenVersion.V1) {
230             pricePerShare = YVaultV1Interface(token).getPricePerFullShare();
231             underlying = YVaultV1Interface(token).token();
232         } else {
233             pricePerShare = YVaultV2Interface(token).pricePerShare();
234             underlying = YVaultV2Interface(token).token();
235         }
236 
237         uint256 underlyingPrice;
238         if (crvTokens[underlying].isCrvToken) {
239             underlyingPrice = getCrvTokenPrice(underlying);
240         } else {
241             underlyingPrice = getTokenPrice(underlying);
242         }
243         return mul_(underlyingPrice, Exp({mantissa: pricePerShare}));
244     }
245 
246     /**
247      * @notice Get price for curve pool tokens
248      * @param token The curve pool token
249      * @return The price
250      */
251     function getCrvTokenPrice(address token) internal view returns (uint256) {
252         CrvTokenInfo memory crvTokenInfo = crvTokens[token];
253         require(crvTokenInfo.isCrvToken, "not a curve pool token");
254 
255         uint256 virtualPrice = CurveSwapInterface(crvTokenInfo.curveSwap).get_virtual_price();
256         if (crvTokenInfo.poolType == CurvePoolType.ETH) {
257             return virtualPrice;
258         }
259 
260         // We treat USDC as USD and convert the price to ETH base.
261         return mul_(getUsdcEthPrice(), Exp({mantissa: virtualPrice}));
262     }
263 
264     /**
265      * @notice Get USDC price
266      * @dev We treat USDC as USD for convenience
267      * @return The USDC price
268      */
269     function getUsdcEthPrice() internal view returns (uint256) {
270         return getTokenPrice(usdcAddress) / 1e12;
271     }
272 
273     /**
274      * @notice Get price from v1 price oracle
275      * @param token The token to get the price of
276      * @return The price
277      */
278     function getPriceFromV1(address token) internal view returns (uint256) {
279         return v1PriceOracle.assetPrices(token);
280     }
281 
282     /*** Admin or guardian functions ***/
283 
284     event AggregatorUpdated(address tokenAddress, address base, address quote, bool isUsed);
285     event IsLPUpdated(address tokenAddress, bool isLP);
286     event SetYVaultToken(address token, YvTokenVersion version);
287     event SetCurveToken(address token, CurvePoolType poolType, address swap);
288     event SetGuardian(address guardian);
289     event SetAdmin(address admin);
290 
291     /**
292      * @notice Set ChainLink aggregators for multiple tokens
293      * @param tokenAddresses The list of underlying tokens
294      * @param bases The list of ChainLink aggregator bases
295      * @param quotes The list of ChainLink aggregator quotes, currently support 'ETH' and 'USD'
296      */
297     function _setAggregators(
298         address[] calldata tokenAddresses,
299         address[] calldata bases,
300         address[] calldata quotes
301     ) external {
302         require(msg.sender == admin || msg.sender == guardian, "only the admin or guardian may set the aggregators");
303         require(tokenAddresses.length == bases.length && tokenAddresses.length == quotes.length, "mismatched data");
304         for (uint256 i = 0; i < tokenAddresses.length; i++) {
305             bool isUsed;
306             if (bases[i] != address(0)) {
307                 require(msg.sender == admin, "guardian may only clear the aggregator");
308                 require(quotes[i] == Denominations.ETH || quotes[i] == Denominations.USD, "unsupported denomination");
309                 isUsed = true;
310 
311                 // Make sure the aggregator exists.
312                 address aggregator = registry.getFeed(bases[i], quotes[i]);
313                 require(registry.isFeedEnabled(aggregator), "aggregator not enabled");
314             }
315             aggregators[tokenAddresses[i]] = AggregatorInfo({base: bases[i], quote: quotes[i], isUsed: isUsed});
316             emit AggregatorUpdated(tokenAddresses[i], bases[i], quotes[i], isUsed);
317         }
318     }
319 
320     /**
321      * @notice See assets as LP tokens for multiple tokens
322      * @param tokenAddresses The list of tokens
323      * @param isLP The list of cToken properties (it's LP or not)
324      */
325     function _setLPs(address[] calldata tokenAddresses, bool[] calldata isLP) external {
326         require(msg.sender == admin, "only the admin may set LPs");
327         require(tokenAddresses.length == isLP.length, "mismatched data");
328         for (uint256 i = 0; i < tokenAddresses.length; i++) {
329             isUnderlyingLP[tokenAddresses[i]] = isLP[i];
330             if (isLP[i]) {
331                 // Sanity check to make sure the token is LP.
332                 IUniswapV2Pair(tokenAddresses[i]).token0();
333                 IUniswapV2Pair(tokenAddresses[i]).token1();
334             }
335             emit IsLPUpdated(tokenAddresses[i], isLP[i]);
336         }
337     }
338 
339     /**
340      * @notice See assets as Yvault tokens for multiple tokens
341      * @param tokenAddresses The list of tokens
342      * @param version The list of vault version
343      */
344     function _setYVaultTokens(address[] calldata tokenAddresses, YvTokenVersion[] calldata version) external {
345         require(msg.sender == admin, "only the admin may set Yvault tokens");
346         require(tokenAddresses.length == version.length, "mismatched data");
347         for (uint256 i = 0; i < tokenAddresses.length; i++) {
348             // Sanity check to make sure version is right.
349             if (version[i] == YvTokenVersion.V1) {
350                 YVaultV1Interface(tokenAddresses[i]).getPricePerFullShare();
351             } else {
352                 YVaultV2Interface(tokenAddresses[i]).pricePerShare();
353             }
354 
355             yvTokens[tokenAddresses[i]] = YvTokenInfo({isYvToken: true, version: version[i]});
356             emit SetYVaultToken(tokenAddresses[i], version[i]);
357         }
358     }
359 
360     /**
361      * @notice See assets as curve pool tokens for multiple tokens
362      * @param tokenAddresses The list of tokens
363      * @param poolType The list of curve pool type (ETH or USD base only)
364      * @param swap The list of curve swap address
365      */
366     function _setCurveTokens(
367         address[] calldata tokenAddresses,
368         CurveTokenVersion[] calldata version,
369         CurvePoolType[] calldata poolType,
370         address[] calldata swap
371     ) external {
372         require(msg.sender == admin, "only the admin may set curve pool tokens");
373         require(
374             tokenAddresses.length == version.length &&
375                 tokenAddresses.length == poolType.length &&
376                 tokenAddresses.length == swap.length,
377             "mismatched data"
378         );
379         for (uint256 i = 0; i < tokenAddresses.length; i++) {
380             if (version[i] == CurveTokenVersion.V3) {
381                 // Sanity check to make sure the token minter is right.
382                 require(CurveTokenV3Interface(tokenAddresses[i]).minter() == swap[i], "incorrect pool");
383             }
384 
385             crvTokens[tokenAddresses[i]] = CrvTokenInfo({isCrvToken: true, poolType: poolType[i], curveSwap: swap[i]});
386             emit SetCurveToken(tokenAddresses[i], poolType[i], swap[i]);
387         }
388     }
389 
390     /**
391      * @notice Set guardian for price oracle proxy
392      * @param _guardian The new guardian
393      */
394     function _setGuardian(address _guardian) external {
395         require(msg.sender == admin, "only the admin may set new guardian");
396         guardian = _guardian;
397         emit SetGuardian(guardian);
398     }
399 
400     /**
401      * @notice Set admin for price oracle proxy
402      * @param _admin The new admin
403      */
404     function _setAdmin(address _admin) external {
405         require(msg.sender == admin, "only the admin may set new admin");
406         admin = _admin;
407         emit SetAdmin(admin);
408     }
409 }
