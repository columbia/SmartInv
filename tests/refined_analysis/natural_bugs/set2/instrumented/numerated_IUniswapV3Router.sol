1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 pragma abicoder v2;
4 
5 interface IUniswapV3Router {
6     struct ExactInputSingleParams {
7         address tokenIn;
8         address tokenOut;
9         uint24 fee;
10         address recipient;
11         uint256 deadline;
12         uint256 amountIn;
13         uint256 amountOutMinimum;
14         uint160 sqrtPriceLimitX96;
15     
16     }
17    
18     /// @notice Swaps `amountIn` of one token for as much as possible of another token
19     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
20     /// @return amountOut The amount of the received token
21     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
22 }