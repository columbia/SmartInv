1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.7.5;
3 pragma abicoder v2;
4 
5 /// @title Quoter Interface
6 /// @notice Supports quoting the calculated amounts from exact input or exact output swaps
7 /// @dev These functions are not marked view because they rely on calling non-view functions and reverting
8 /// to compute the result. They are also not gas efficient and should not be called on-chain.
9 interface IQuoter {
10     /// @notice Returns the amount out received for a given exact input swap without executing the swap
11     /// @param path The path of the swap, i.e. each token pair and the pool fee
12     /// @param amountIn The amount of the first token to swap
13     /// @return amountOut The amount of the last token that would be received
14     function quoteExactInput(bytes memory path, uint256 amountIn) external returns (uint256 amountOut);
15 
16     /// @notice Returns the amount out received for a given exact input but for a swap of a single pool
17     /// @param tokenIn The token being swapped in
18     /// @param tokenOut The token being swapped out
19     /// @param fee The fee of the token pool to consider for the pair
20     /// @param amountIn The desired input amount
21     /// @param sqrtPriceLimitX96 The price limit of the pool that cannot be exceeded by the swap
22     /// @return amountOut The amount of `tokenOut` that would be received
23     function quoteExactInputSingle(
24         address tokenIn,
25         address tokenOut,
26         uint24 fee,
27         uint256 amountIn,
28         uint160 sqrtPriceLimitX96
29     ) external returns (uint256 amountOut);
30 
31     /// @notice Returns the amount in required for a given exact output swap without executing the swap
32     /// @param path The path of the swap, i.e. each token pair and the pool fee. Path must be provided in reverse order
33     /// @param amountOut The amount of the last token to receive
34     /// @return amountIn The amount of first token required to be paid
35     function quoteExactOutput(bytes memory path, uint256 amountOut) external returns (uint256 amountIn);
36 
37     /// @notice Returns the amount in required to receive the given exact output amount but for a swap of a single pool
38     /// @param tokenIn The token being swapped in
39     /// @param tokenOut The token being swapped out
40     /// @param fee The fee of the token pool to consider for the pair
41     /// @param amountOut The desired output amount
42     /// @param sqrtPriceLimitX96 The price limit of the pool that cannot be exceeded by the swap
43     /// @return amountIn The amount required as the input for the swap in order to receive `amountOut`
44     function quoteExactOutputSingle(
45         address tokenIn,
46         address tokenOut,
47         uint24 fee,
48         uint256 amountOut,
49         uint160 sqrtPriceLimitX96
50     ) external returns (uint256 amountIn);
51 }