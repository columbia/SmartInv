1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 import "../../interfaces/vendor/ICurveSwap.sol";
8 import "../../interfaces/vendor/UniswapRouter02.sol";
9 import "../../interfaces/ISwapper.sol";
10 import "../../libraries/Errors.sol";
11 import "../../libraries/ScaledMath.sol";
12 
13 contract Swapper3Crv is ISwapper {
14     using ScaledMath for uint256;
15     using SafeERC20 for IERC20;
16 
17     // Dex contracts
18     address public constant UNISWAP = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
19     address public constant SUSHISWAP = address(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
20 
21     // Dex factories
22     address public constant UNISWAP_FACTORY = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
23     address public constant SUSHISWAP_FACTORY = address(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
24 
25     // ERC20 tokens
26     address public constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
27     address public constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
28     address public constant USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
29     address public constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
30     address public constant TRI_CRV = address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
31 
32     // Curve pool
33     address public constant CURVE_POOL = address(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
34 
35     mapping(address => int128) public triPoolIndex; // dev: 3Pool is immutable so these won't change
36     mapping(address => mapping(address => address)) public lpTokens;
37 
38     constructor() {
39         triPoolIndex[DAI] = int128(0);
40         triPoolIndex[USDC] = int128(1);
41         triPoolIndex[USDT] = int128(2);
42 
43         IERC20(DAI).safeApprove(SUSHISWAP, type(uint256).max);
44         IERC20(USDC).safeApprove(SUSHISWAP, type(uint256).max);
45         IERC20(USDT).safeApprove(SUSHISWAP, type(uint256).max);
46 
47         IERC20(DAI).safeApprove(UNISWAP, type(uint256).max);
48         IERC20(USDC).safeApprove(UNISWAP, type(uint256).max);
49         IERC20(USDT).safeApprove(UNISWAP, type(uint256).max);
50     }
51 
52     function swap(
53         address fromToken,
54         address toToken,
55         uint256 swapAmount,
56         uint256 minAmount
57     ) external override returns (uint256) {
58         require(
59             fromToken == TRI_CRV && ((toToken == DAI) || (toToken == USDC) || (toToken == USDT)),
60             "Token pair not swappable"
61         );
62         IERC20(fromToken).transferFrom(msg.sender, address(this), swapAmount);
63         (address dex, address token) = _getBestTokenToWithdraw(swapAmount, toToken);
64         ICurveSwap(CURVE_POOL).remove_liquidity_one_coin(swapAmount, triPoolIndex[token], 0);
65         uint256 amountReceived = _swapAll(token, toToken, dex);
66 
67         require(amountReceived >= minAmount, Error.INSUFFICIENT_FUNDS_RECEIVED);
68         return amountReceived;
69     }
70 
71     /**
72      * @notice Calculate the exchange rate for the token pair.
73      */
74     function getRate(address fromToken, address toToken) external view override returns (uint256) {
75         require(
76             fromToken == TRI_CRV && ((toToken == DAI) || (toToken == USDC) || (toToken == USDT)),
77             "Token pair not swappable"
78         );
79         if (toToken == DAI) return ICurveSwap(CURVE_POOL).get_virtual_price();
80         return ICurveSwap(CURVE_POOL).get_virtual_price() / 1e12;
81     }
82 
83     /**
84      * @dev Swaps the contracts full balance of tokenIn for tokenOut.
85      * @param tokenIn Token to swap for tokenOut.
86      * @param tokenOut Target token to receive in swap.
87      * @return The amount of tokenOut received.
88      */
89     function _swapAll(
90         address tokenIn,
91         address tokenOut,
92         address dex
93     ) internal returns (uint256) {
94         uint256 amountIn = IERC20(tokenIn).balanceOf(address(this));
95         if (tokenIn == tokenOut) {
96             IERC20(tokenOut).safeTransfer(msg.sender, amountIn);
97             return amountIn;
98         }
99         if (amountIn == 0) return 0;
100         address[] memory path = new address[](3);
101         path[0] = tokenIn;
102         path[1] = WETH;
103         path[2] = tokenOut;
104         return
105             UniswapRouter02(dex).swapExactTokensForTokens(
106                 amountIn,
107                 0,
108                 path,
109                 msg.sender,
110                 block.timestamp
111             )[2];
112     }
113 
114     /**
115      * @dev Gets the best token to withdraw from Curve Pool for swapping.
116      * @param amount Amount of 3CRV to withdraw and swap.
117      * @param tokenOut Target token to receive in swap.
118      * @return The best token to withdraw from Curve Pool for swapping.
119      */
120     function _getBestTokenToWithdraw(uint256 amount, address tokenOut)
121         internal
122         view
123         returns (address, address)
124     {
125         (address daiDex, uint256 daiOutput) = _getAmountOut(amount, DAI, tokenOut);
126         (address usdcDex, uint256 usdcOutput) = _getAmountOut(amount, USDC, tokenOut);
127         (address usdtDex, uint256 usdtOutput) = _getAmountOut(amount, USDT, tokenOut);
128         if (daiOutput > usdcOutput && daiOutput > usdtOutput) {
129             return (daiDex, DAI);
130         } else if (usdcOutput > usdtOutput) {
131             return (usdcDex, USDC);
132         } else {
133             return (usdtDex, USDT);
134         }
135     }
136 
137     /**
138      * @dev Gets the amount of tokenOut received if swapping 3CRV via tokenIn.
139      * @param amountIn The amount of 3CRV to withdraw and swap.
140      * @param tokenIn Token to withdraw liquidity in from Curve Pool and to swap with tokenOut.
141      * @param tokenOut Target token out.
142      * @return The amount of tokenOut received.
143      */
144     function _getAmountOut(
145         uint256 amountIn,
146         address tokenIn,
147         address tokenOut
148     ) internal view returns (address, uint256) {
149         uint256 coinReceived = ICurveSwap(CURVE_POOL).calc_withdraw_one_coin(
150             amountIn,
151             triPoolIndex[tokenIn]
152         );
153         if (tokenIn == tokenOut) return (address(0), coinReceived);
154         (address dex, uint256 amountOut) = _getBestDex(tokenIn, tokenOut, coinReceived);
155         return (dex, amountOut);
156     }
157 
158     /**
159      * @dev Gets the best DEX to use for swapping token.
160      *      Compares the amount out for Uniswap and Sushiswap.
161      * @param fromToken Token to swap from.
162      * @param toToken Token to swap to.
163      * @param amount Amount of fromToken to swap.
164      * @return bestDex The address of the best DEX to use.
165      * @return amountOut The amount of toToken received from swapping.
166      */
167     function _getBestDex(
168         address fromToken,
169         address toToken,
170         uint256 amount
171     ) internal view returns (address bestDex, uint256 amountOut) {
172         address uniswap_ = UNISWAP;
173         address sushiSwap_ = UNISWAP;
174         uint256 amountOutUniswap = _tokenAmountOut(fromToken, toToken, amount, uniswap_);
175         uint256 amountOutSushiSwap = _tokenAmountOut(fromToken, toToken, amount, sushiSwap_);
176         return
177             amountOutUniswap >= amountOutSushiSwap
178                 ? (uniswap_, amountOutUniswap)
179                 : (sushiSwap_, amountOutSushiSwap);
180     }
181 
182     /**
183      * @notice Gets the amount of tokenOut that would be received by selling the tokenIn for underlying
184      * @return tokenOut amount that would be received
185      */
186     function _tokenAmountOut(
187         address tokenIn,
188         address tokenOut,
189         uint256 amountIn,
190         address dex
191     ) internal view returns (uint256) {
192         address[] memory path = new address[](3);
193         path[0] = tokenIn;
194         path[1] = WETH;
195         path[2] = tokenOut;
196         return UniswapRouter02(dex).getAmountsOut(amountIn, path)[2];
197     }
198 }
