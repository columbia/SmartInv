1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /// @notice Functions for swapping tokens via Uniswap V3
5 interface IUniswapV3RouterArbi {
6  
7     struct ExactInputSingleParams {
8         address tokenIn;
9         address tokenOut;
10         uint24 fee;
11         address recipient;
12         uint256 amountIn;
13         uint256 amountOutMinimum;
14         uint160 sqrtPriceLimitX96;
15     }
16 
17     /// @notice Swaps `amountIn` of one token for as much as possible of another token
18     /// @dev Setting `amountIn` to 0 will cause the contract to look up its own balance,
19     /// and swap the entire amount, enabling contracts to send tokens before calling this function.
20     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
21     /// @return amountOut The amount of the received token
22     function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
23 }