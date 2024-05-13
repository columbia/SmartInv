1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IUniswapV2Router {
5 
6     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
7 }