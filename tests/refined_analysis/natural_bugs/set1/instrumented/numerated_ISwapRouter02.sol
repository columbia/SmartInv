1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.7.5;
3 pragma abicoder v2;
4 
5 import './IUniswapV3SwapCallback.sol';
6 
7 
8 /// @title Router token swapping functionality
9 /// @notice Functions for swapping tokens via Uniswap V2
10 interface IV2SwapRouter {
11     /// @notice Swaps `amountIn` of one token for as much as possible of another token
12     /// @dev Setting `amountIn` to 0 will cause the contract to look up its own balance,
13     /// and swap the entire amount, enabling contracts to send tokens before calling this function.
14     /// @param amountIn The amount of token to swap
15     /// @param amountOutMin The minimum amount of output that must be received
16     /// @param path The ordered list of tokens to swap through
17     /// @param to The recipient address
18     /// @return amountOut The amount of the received token
19     function swapExactTokensForTokens(
20         uint256 amountIn,
21         uint256 amountOutMin,
22         address[] calldata path,
23         address to
24     ) external payable returns (uint256 amountOut);
25 
26     /// @notice Swaps as little as possible of one token for an exact amount of another token
27     /// @param amountOut The amount of token to swap for
28     /// @param amountInMax The maximum amount of input that the caller will pay
29     /// @param path The ordered list of tokens to swap through
30     /// @param to The recipient address
31     /// @return amountIn The amount of token to pay
32     function swapTokensForExactTokens(
33         uint256 amountOut,
34         uint256 amountInMax,
35         address[] calldata path,
36         address to
37     ) external payable returns (uint256 amountIn);
38 }
39 
40 
41 /// @title Router token swapping functionality
42 /// @notice Functions for swapping tokens via Uniswap V3
43 interface IV3SwapRouter is IUniswapV3SwapCallback {
44     struct ExactInputSingleParams {
45         address tokenIn;
46         address tokenOut;
47         uint24 fee;
48         address recipient;
49         uint256 amountIn;
50         uint256 amountOutMinimum;
51         uint160 sqrtPriceLimitX96;
52     }
53 
54     /// @notice Swaps `amountIn` of one token for as much as possible of another token
55     /// @dev Setting `amountIn` to 0 will cause the contract to look up its own balance,
56     /// and swap the entire amount, enabling contracts to send tokens before calling this function.
57     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
58     /// @return amountOut The amount of the received token
59     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
60 
61     struct ExactInputParams {
62         bytes path;
63         address recipient;
64         uint256 amountIn;
65         uint256 amountOutMinimum;
66     }
67 
68     /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
69     /// @dev Setting `amountIn` to 0 will cause the contract to look up its own balance,
70     /// and swap the entire amount, enabling contracts to send tokens before calling this function.
71     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
72     /// @return amountOut The amount of the received token
73     function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);
74 
75     struct ExactOutputSingleParams {
76         address tokenIn;
77         address tokenOut;
78         uint24 fee;
79         address recipient;
80         uint256 amountOut;
81         uint256 amountInMaximum;
82         uint160 sqrtPriceLimitX96;
83     }
84 
85     /// @notice Swaps as little as possible of one token for `amountOut` of another token
86     /// that may remain in the router after the swap.
87     /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
88     /// @return amountIn The amount of the input token
89     function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);
90 
91     struct ExactOutputParams {
92         bytes path;
93         address recipient;
94         uint256 amountOut;
95         uint256 amountInMaximum;
96     }
97 
98     /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
99     /// that may remain in the router after the swap.
100     /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
101     /// @return amountIn The amount of the input token
102     function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
103 }
104 
105 /// @title Router token swapping functionality
106 interface ISwapRouter02 is IV2SwapRouter, IV3SwapRouter {
107 
108 }