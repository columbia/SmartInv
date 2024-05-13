1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.7.5;
3 pragma abicoder v2;
4 
5 /// @title Router token swapping functionality
6 /// @notice Functions for swapping tokens via Uniswap V3
7 interface ISwapRouter {
8     struct ExactInputSingleParams {
9         address tokenIn;
10         address tokenOut;
11         uint24 fee;
12         address recipient;
13         uint256 deadline;
14         uint256 amountIn;
15         uint256 amountOutMinimum;
16         uint160 sqrtPriceLimitX96;
17     }
18 
19     /// @notice Swaps `amountIn` of one token for as much as possible of another token
20     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
21     /// @return amountOut The amount of the received token
22     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
23 
24     struct ExactInputParams {
25         bytes path;
26         address recipient;
27         uint256 deadline;
28         uint256 amountIn;
29         uint256 amountOutMinimum;
30     }
31 }