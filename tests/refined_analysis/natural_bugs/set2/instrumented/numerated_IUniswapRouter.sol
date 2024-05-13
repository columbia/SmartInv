1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.7.3;
3 
4 interface IUniswapRouter {
5     function swapExactTokensForTokens(
6     uint amountIn,
7     uint amountOutMin,
8     address[] calldata path,
9     address to,
10     uint deadline
11     ) external returns (uint[] memory amounts);
12 
13 }