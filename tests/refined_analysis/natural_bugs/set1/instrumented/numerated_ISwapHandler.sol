1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 interface ISwapHandler {
6     /// @notice Params for swaps using SwapHub contract and swap handlers
7     /// @param underlyingIn sold token address
8     /// @param underlyingOut bought token address
9     /// @param mode type of the swap: 0 for exact input, 1 for exact output
10     /// @param amountIn amount of token to sell. Exact value for exact input, maximum for exact output
11     /// @param amountOut amount of token to buy. Exact value for exact output, minimum for exact input
12     /// @param exactOutTolerance Maximum difference between requested amountOut and received tokens in exact output swap. Ignored for exact input
13     /// @param payload multi-purpose byte param. The usage depends on the swap handler implementation
14     struct SwapParams {
15         address underlyingIn;
16         address underlyingOut;
17         uint mode;                  // 0=exactIn  1=exactOut
18         uint amountIn;              // mode 0: exact,    mode 1: maximum
19         uint amountOut;             // mode 0: minimum,  mode 1: exact
20         uint exactOutTolerance;     // mode 0: ignored,  mode 1: downward tolerance on amountOut (fee-on-transfer etc.)
21         bytes payload;
22     }
23 
24     /// @notice Execute a trade on the swap handler
25     /// @param params struct defining the requested trade
26     function executeSwap(SwapParams calldata params) external;
27 }
