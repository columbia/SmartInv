1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.7.5;
3 pragma abicoder v2;
4 
5 import './IUniswapV3SwapCallback.sol';
6 
7 /// @title Router token swapping functionality
8 /// @notice Functions for swapping tokens via Uniswap V3
9 interface ISwapRouterV3 is IUniswapV3SwapCallback {
10     struct ExactInputSingleParams {
11         address tokenIn;
12         address tokenOut;
13         uint24 fee;
14         address recipient;
15         uint256 deadline;
16         uint256 amountIn;
17         uint256 amountOutMinimum;
18         uint160 sqrtPriceLimitX96;
19     }
20 
21     /// @notice Swaps `amountIn` of one token for as much as possible of another token
22     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
23     /// @return amountOut The amount of the received token
24     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
25 
26     struct ExactInputParams {
27         bytes path;
28         address recipient;
29         uint256 deadline;
30         uint256 amountIn;
31         uint256 amountOutMinimum;
32     }
33 
34     /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
35     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
36     /// @return amountOut The amount of the received token
37     function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);
38 
39     struct ExactOutputSingleParams {
40         address tokenIn;
41         address tokenOut;
42         uint24 fee;
43         address recipient;
44         uint256 deadline;
45         uint256 amountOut;
46         uint256 amountInMaximum;
47         uint160 sqrtPriceLimitX96;
48     }
49 
50     /// @notice Swaps as little as possible of one token for `amountOut` of another token
51     /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
52     /// @return amountIn The amount of the input token
53     function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);
54 
55     struct ExactOutputParams {
56         bytes path;
57         address recipient;
58         uint256 deadline;
59         uint256 amountOut;
60         uint256 amountInMaximum;
61     }
62 
63     /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
64     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
65     /// @return amountIn The amount of the input token
66     function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
67 }
