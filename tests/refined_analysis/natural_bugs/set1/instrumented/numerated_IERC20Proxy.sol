1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IERC20Proxy {
5     function transferFrom(
6         address tokenAddress,
7         address from,
8         address to,
9         uint256 amount
10     ) external;
11 }
