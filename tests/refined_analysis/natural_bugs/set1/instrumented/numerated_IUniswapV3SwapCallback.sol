1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.5.0;
3 
4 /// @title Callback for IUniswapV3PoolActions#swap
5 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
6 interface IUniswapV3SwapCallback {
7     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
8     /// @dev In the implementation you must pay the pool tokens owed for the swap.
9     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
10     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
11     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
12     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
13     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
14     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
15     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
16     function uniswapV3SwapCallback(
17         int256 amount0Delta,
18         int256 amount1Delta,
19         bytes calldata data
20     ) external;
21 }
