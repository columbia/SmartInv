1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./SwapHandlerBase.sol";
6 import "../vendor/ISwapRouterV3.sol";
7 
8 /// @notice Swap handler executing trades on UniswapV3 through SwapRouter
9 contract SwapHandlerUniswapV3 is SwapHandlerBase {
10     address immutable public uniSwapRouterV3;
11 
12     constructor(address uniSwapRouterV3_) {
13         uniSwapRouterV3 = uniSwapRouterV3_;
14     }
15 
16     function executeSwap(SwapParams calldata params) override external {
17         require(params.mode <= 1, "SwapHandlerUniswapV3: invalid mode");
18 
19         setMaxAllowance(params.underlyingIn, params.amountIn, uniSwapRouterV3);
20 
21         // The payload in SwapParams has double use. For single pool swaps, the price limit and a pool fee are abi-encoded as 2 uints, where bytes length is 64.
22         // For multi-pool swaps, the payload represents a swap path. A valid path is a packed encoding of tokenIn, pool fee and tokenOut.
23         // The valid path lengths are therefore: 20 + n*(3 + 20), where n >= 1, and no valid path can be 64 bytes long.
24         if (params.payload.length == 64) {
25             (uint sqrtPriceLimitX96, uint fee) = abi.decode(params.payload, (uint, uint));
26             if (params.mode == 0)
27                 exactInputSingle(params, sqrtPriceLimitX96, fee);
28             else
29                 exactOutputSingle(params, sqrtPriceLimitX96, fee);
30         } else {
31             if (params.mode == 0)
32                 exactInput(params, params.payload);
33             else
34                 exactOutput(params, params.payload);
35         }
36 
37         if (params.mode == 1) transferBack(params.underlyingIn);
38     }
39 
40     function exactInputSingle(SwapParams memory params, uint sqrtPriceLimitX96, uint fee) private {
41         ISwapRouterV3(uniSwapRouterV3).exactInputSingle(
42             ISwapRouterV3.ExactInputSingleParams({
43                 tokenIn: params.underlyingIn,
44                 tokenOut: params.underlyingOut,
45                 fee: uint24(fee),
46                 recipient: msg.sender,
47                 deadline: block.timestamp,
48                 amountIn: params.amountIn,
49                 amountOutMinimum: params.amountOut,
50                 sqrtPriceLimitX96: uint160(sqrtPriceLimitX96)
51             })
52         );
53     }
54 
55     function exactInput(SwapParams memory params, bytes memory path) private {
56         ISwapRouterV3(uniSwapRouterV3).exactInput(
57             ISwapRouterV3.ExactInputParams({
58                 path: path,
59                 recipient: msg.sender,
60                 deadline: block.timestamp,
61                 amountIn: params.amountIn,
62                 amountOutMinimum: params.amountOut
63             })
64         );
65     }
66 
67     function exactOutputSingle(SwapParams memory params, uint sqrtPriceLimitX96, uint fee) private {
68         ISwapRouterV3(uniSwapRouterV3).exactOutputSingle(
69             ISwapRouterV3.ExactOutputSingleParams({
70                 tokenIn: params.underlyingIn,
71                 tokenOut: params.underlyingOut,
72                 fee: uint24(fee),
73                 recipient: msg.sender,
74                 deadline: block.timestamp,
75                 amountOut: params.amountOut,
76                 amountInMaximum: params.amountIn,
77                 sqrtPriceLimitX96: uint160(sqrtPriceLimitX96)
78             })
79         );
80     }
81 
82     function exactOutput(SwapParams memory params, bytes memory path) private {
83         ISwapRouterV3(uniSwapRouterV3).exactOutput(
84             ISwapRouterV3.ExactOutputParams({
85                 path: path,
86                 recipient: msg.sender,
87                 deadline: block.timestamp,
88                 amountOut: params.amountOut,
89                 amountInMaximum: params.amountIn
90             })
91         );
92     }
93 }
