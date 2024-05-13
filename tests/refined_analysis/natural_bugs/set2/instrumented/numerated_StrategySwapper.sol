1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 import "../../interfaces/IAddressProvider.sol";
8 import "../access/Authorization.sol";
9 import "./IStrategySwapper.sol";
10 import "../../interfaces/vendor/UniswapRouter02.sol";
11 import "../../interfaces/vendor/ICurveSwapEth.sol";
12 import "../../libraries/ScaledMath.sol";
13 import "../../libraries/AddressProviderHelpers.sol";
14 import "../../interfaces/IERC20Full.sol";
15 import "../../interfaces/vendor/IWETH.sol";
16 
17 contract StrategySwapper is IStrategySwapper, Authorization {
18     using ScaledMath for uint256;
19     using SafeERC20 for IERC20;
20     using AddressProviderHelpers for IAddressProvider;
21 
22     IWETH internal constant _WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // WETH
23     UniswapRouter02 internal constant _SUSHISWAP =
24         UniswapRouter02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); // Sushiswap Router for swaps
25     UniswapRouter02 internal constant _UNISWAP =
26         UniswapRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Uniswap Router for swaps
27 
28     IAddressProvider internal immutable _addressProvider; // Address provider used for getting oracle provider
29 
30     uint256 public slippageTolerance; // The amount of slippage to allow from the oracle price of an asset
31     mapping(address => ICurveSwapEth) public curvePools; // Curve Pool to use for swaps to ETH (if any)
32     mapping(address => bool) public swapViaUniswap; // If Uniswap should be used over Sushiswap for swaps
33 
34     event SetSlippageTolerance(uint256 value); // Emitted after a succuessful setting of slippage tolerance
35     event SetCurvePool(address token, address curvePool); // Emitted after a succuessful setting of a Curve Pool
36     event SetSwapViaUniswap(address token, bool swapViaUniswap); // Emitted after a succuessful setting of swap via Uniswap
37 
38     constructor(address addressProvider_, uint256 slippageTolerance_)
39         Authorization(IAddressProvider(addressProvider_).getRoleManager())
40     {
41         _addressProvider = IAddressProvider(addressProvider_);
42         slippageTolerance = slippageTolerance_;
43     }
44 
45     receive() external payable {}
46 
47     /**
48      * @notice Swaps all the balance of a token for WETH.
49      * @param token_ Address of the token to swap for WETH.
50      */
51     function swapAllForWeth(address token_) external override {
52         return swapForWeth(token_, IERC20(token_).balanceOf(msg.sender));
53     }
54 
55     /**
56      * @notice Swaps all available WETH for underlying.
57      * @param token_ Address of the token to swap WETH to.
58      */
59     function swapAllWethForToken(address token_) external override {
60         IWETH weth_ = _WETH;
61         uint256 wethBalance_ = weth_.balanceOf(msg.sender);
62         if (wethBalance_ == 0) return;
63         weth_.transferFrom(msg.sender, address(this), wethBalance_);
64 
65         if (token_ == address(0)) {
66             weth_.withdraw(wethBalance_);
67             // solhint-disable-next-line avoid-low-level-calls
68             (bool sent, ) = payable(msg.sender).call{value: wethBalance_}("");
69             require(sent, "failed to send eth");
70             return;
71         }
72 
73         // Handling Curve Pool swaps
74         ICurveSwapEth curvePool_ = curvePools[token_];
75         if (address(curvePool_) != address(0)) {
76             _approve(address(weth_), address(curvePool_));
77             (uint256 wethIndex_, uint256 tokenIndex_) = _getIndices(curvePool_, token_);
78             curvePool_.exchange(
79                 wethIndex_,
80                 tokenIndex_,
81                 wethBalance_,
82                 _minTokenAmountOut(wethBalance_, token_)
83             );
84             IERC20(token_).safeTransfer(msg.sender, IERC20(token_).balanceOf(address(this)));
85             return;
86         }
87 
88         // Handling Uniswap or Sushiswap swaps
89         address[] memory path_ = new address[](2);
90         path_[0] = address(weth_);
91         path_[1] = token_;
92         UniswapRouter02 dex_ = _getDex(token_);
93         _approve(address(weth_), address(dex_));
94         uint256 amountOut_ = dex_.swapExactTokensForTokens(
95             wethBalance_,
96             _minTokenAmountOut(wethBalance_, token_),
97             path_,
98             address(this),
99             block.timestamp
100         )[1];
101         IERC20(token_).safeTransfer(msg.sender, amountOut_);
102     }
103 
104     /**
105      * @notice Set slippage tolerance for swaps.
106      * @dev Stored as a multiplier, e.g. 2% would be set as 0.98.
107      * @param slippageTolerance_ New slippage tolerance.
108      */
109     function setSlippageTolerance(uint256 slippageTolerance_) external override onlyGovernance {
110         require(slippageTolerance_ <= ScaledMath.ONE, Error.INVALID_SLIPPAGE_TOLERANCE);
111         require(slippageTolerance_ > 0.8e18, Error.INVALID_SLIPPAGE_TOLERANCE);
112         slippageTolerance = slippageTolerance_;
113         emit SetSlippageTolerance(slippageTolerance_);
114     }
115 
116     /**
117      * @notice Sets the Curve Pool to use for swapping a token with WETH.
118      * @dev To use Uniswap or Sushiswap instead, set the Curve Pool to the zero address.
119      * @param token_ The token to set the Curve Pool for.
120      * @param curvePool_ The address of the Curve Pool.
121      */
122     function setCurvePool(address token_, address curvePool_) external override onlyGovernance {
123         require(token_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
124         require(curvePool_ != address(curvePools[token_]), Error.SAME_ADDRESS_NOT_ALLOWED);
125         curvePools[token_] = ICurveSwapEth(curvePool_);
126         emit SetCurvePool(token_, curvePool_);
127     }
128 
129     /**
130      * @notice Sets if swaps should go via Uniswap for the given token_.
131      * @param token_ The token to set the swapViaUniswap for.
132      * @param swapViaUniswap_ If Sushiswap should be use for swaps for token_.
133      */
134     function setSwapViaUniswap(address token_, bool swapViaUniswap_)
135         external
136         override
137         onlyGovernance
138     {
139         require(token_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
140         swapViaUniswap[token_] = swapViaUniswap_;
141         emit SetSwapViaUniswap(token_, swapViaUniswap_);
142     }
143 
144     /**
145      * @notice Gets the amount of tokenOut_ that would be received by swapping amountIn_ of tokenIn_.
146      * @param tokenIn_ The token to swap in.
147      * @param tokenOut_ The token to get out.
148      * @param amountIn_ The amount to swap in.
149      * @return The amount of tokenOut_ that would be received by swapping amountIn_ of tokenIn_.
150      */
151     function amountOut(
152         address tokenIn_,
153         address tokenOut_,
154         uint256 amountIn_
155     ) external view override returns (uint256) {
156         if (amountIn_ == 0) return 0;
157         uint256 wethOut_ = _tokenToWethAmountOut(tokenIn_, amountIn_);
158         return _wethToTokenAmountOut(tokenOut_, wethOut_);
159     }
160 
161     /**
162      * @notice Swaps a token for WETH.
163      * @param token_ Address of the token to swap for WETH.
164      * @param amount_ Amount of the token to swap for WETH.
165      */
166     function swapForWeth(address token_, uint256 amount_) public override {
167         if (amount_ == 0) return;
168         IERC20(token_).safeTransferFrom(msg.sender, address(this), amount_);
169 
170         // Handling Curve Pool swaps
171         ICurveSwapEth curvePool_ = curvePools[token_];
172         IWETH weth_ = _WETH;
173         if (address(curvePool_) != address(0)) {
174             _approve(token_, address(curvePool_));
175             (uint256 wethIndex_, uint256 tokenIndex_) = _getIndices(curvePool_, token_);
176             curvePool_.exchange(
177                 tokenIndex_,
178                 wethIndex_,
179                 amount_,
180                 _minWethAmountOut(amount_, token_)
181             );
182             IERC20(weth_).safeTransfer(msg.sender, weth_.balanceOf(address(this)));
183             return;
184         }
185 
186         // Handling Uniswap or Sushiswap swaps
187         address[] memory path_ = new address[](2);
188         path_[0] = token_;
189         path_[1] = address(weth_);
190         UniswapRouter02 dex_ = _getDex(token_);
191         _approve(token_, address(dex_));
192         uint256 amountOut_ = dex_.swapExactTokensForTokens(
193             amount_,
194             _minWethAmountOut(amount_, token_),
195             path_,
196             address(this),
197             block.timestamp
198         )[1];
199         IERC20(weth_).safeTransfer(msg.sender, amountOut_);
200     }
201 
202     /**
203      * @dev Approves infinite spending for the given spender.
204      * @param token_ The token to approve for.
205      * @param spender_ The spender to approve.
206      */
207     function _approve(address token_, address spender_) internal {
208         if (IERC20(token_).allowance(address(this), spender_) > 0) return;
209         IERC20(token_).safeApprove(spender_, type(uint256).max);
210     }
211 
212     /**
213      * @dev Gets the dex to use for swapping a given token.
214      * @param token_ The token to get the dex for.
215      * @return The dex to use for swapping a given token.
216      */
217     function _getDex(address token_) internal view returns (UniswapRouter02) {
218         return swapViaUniswap[token_] ? _UNISWAP : _SUSHISWAP;
219     }
220 
221     /**
222      * @dev Returns the amount of WETH received by swapping amount_ of token_.
223      * @param token_ The token to get the amount for swapping to WETH.
224      * @param amount_ The amount of token_ that is being swapped to WETH.
225      * @return The amount of WETH received by swapping amount_ of token_.
226      */
227     function _tokenToWethAmountOut(address token_, uint256 amount_)
228         internal
229         view
230         returns (uint256)
231     {
232         if (amount_ == 0) return 0;
233         IWETH weth_ = _WETH;
234         if (token_ == address(weth_)) return amount_;
235         if (token_ == address(0)) return amount_;
236 
237         // Getting amount via Curve Pool if set
238         ICurveSwapEth curvePool_ = curvePools[token_];
239         if (address(curvePool_) != address(0)) {
240             (uint256 wethIndex_, uint256 tokenIndex_) = _getIndices(curvePool_, token_);
241             return curvePool_.get_dy(tokenIndex_, wethIndex_, amount_);
242         }
243 
244         // Getting amount via Uniswap or Sushiswap
245         address[] memory path_ = new address[](2);
246         path_[0] = token_;
247         path_[1] = address(weth_);
248         return _getDex(token_).getAmountsOut(amount_, path_)[1];
249     }
250 
251     /**
252      * @dev Returns the amount of token_ received by swapping amount_ of WETH.
253      * @param token_ The token to get the amount for swapping from WETH.
254      * @param amount_ The amount of WETH that is being swapped to token_.
255      * @return The amount of token_ received by swapping amount_ of WETH.
256      */
257     function _wethToTokenAmountOut(address token_, uint256 amount_)
258         internal
259         view
260         returns (uint256)
261     {
262         if (amount_ == 0) return 0;
263         IWETH weth_ = _WETH;
264         if (token_ == address(weth_)) return amount_;
265         if (token_ == address(0)) return amount_;
266 
267         // Getting amount via Curve Pool if set
268         ICurveSwapEth curvePool_ = curvePools[token_];
269         if (address(curvePool_) != address(0)) {
270             (uint256 wethIndex_, uint256 tokenIndex_) = _getIndices(curvePool_, token_);
271             return curvePool_.get_dy(wethIndex_, tokenIndex_, amount_);
272         }
273 
274         // Getting amount via Uniswap or Sushiswap
275         address[] memory path_ = new address[](2);
276         path_[0] = address(weth_);
277         path_[1] = token_;
278         return _getDex(token_).getAmountsOut(amount_, path_)[1];
279     }
280 
281     /**
282      * @dev Returns the multiplier for converting a token_ amount to the same decimals as WETH.
283      *   For example, USDC (which has decimals of 6) would have a multiplier of 12e18.
284      * @param token_ The token to get the decimal multiplier for.
285      * @return the multiplier for converting a token_ amount to the same decimals as WETH.
286      */
287     function _decimalMultiplier(address token_) internal view returns (uint256) {
288         return 10**(18 - IERC20Full(token_).decimals());
289     }
290 
291     /**
292      * @dev Returns the Curve Pool coin indicies for a given Token.
293      * @param curvePool_ The Curve Pool to return the indicies for.
294      * @param token_ The Token to get the indicies for.
295      * @return wethIndex_ The coin index for WETH.
296      * @return tokenIndex_ The coin index for the Token.
297      */
298     function _getIndices(ICurveSwapEth curvePool_, address token_)
299         internal
300         view
301         returns (uint256 wethIndex_, uint256 tokenIndex_)
302     {
303         return curvePool_.coins(1) == token_ ? (0, 1) : (1, 0);
304     }
305 
306     /**
307      * @dev Returns the minimum amount of Token to recieve from swap.
308      * @param wethAmount_ The amount of WETH being swapped.
309      * @param token_ The Token the WETH is being swapped to.
310      * @return minAmountOut The minimum amount of Token to recieve from swap.
311      */
312     function _minTokenAmountOut(uint256 wethAmount_, address token_)
313         internal
314         view
315         returns (uint256 minAmountOut)
316     {
317         return
318             wethAmount_
319                 .scaledDiv(_addressProvider.getOracleProvider().getPriceETH(token_))
320                 .scaledMul(slippageTolerance) / _decimalMultiplier(token_);
321     }
322 
323     /**
324      * @dev Returns the minimum amount of WETH to recieve from swap.
325      * @param tokenAmount_ The amount of Token being swapped.
326      * @param token_ The Token that is being swapped for WETH.
327      * @return minAmountOut The minimum amount of WETH to recieve from swap.
328      */
329     function _minWethAmountOut(uint256 tokenAmount_, address token_)
330         internal
331         view
332         returns (uint256 minAmountOut)
333     {
334         return
335             tokenAmount_
336                 .scaledMul(_addressProvider.getOracleProvider().getPriceETH(token_))
337                 .scaledMul(slippageTolerance) * _decimalMultiplier(token_);
338     }
339 }
