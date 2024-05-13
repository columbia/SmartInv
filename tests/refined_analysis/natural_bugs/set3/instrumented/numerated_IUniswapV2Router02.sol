1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.2;
3 
4 import './IUniswapV2Router01.sol';
5 
6 interface IUniswapV2Router02 is IUniswapV2Router01 {
7     function removeLiquidityETHSupportingFeeOnTransferTokens(
8         address token,
9         uint liquidity,
10         uint amountTokenMin,
11         uint amountETHMin,
12         address to,
13         uint deadline
14     ) external returns (uint amountETH);
15     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
16         address token,
17         uint liquidity,
18         uint amountTokenMin,
19         uint amountETHMin,
20         address to,
21         uint deadline,
22         bool approveMax, uint8 v, bytes32 r, bytes32 s
23     ) external returns (uint amountETH);
24 
25     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
26         uint amountIn,
27         uint amountOutMin,
28         address[] calldata path,
29         address to,
30         uint deadline
31     ) external;
32     function swapExactETHForTokensSupportingFeeOnTransferTokens(
33         uint amountOutMin,
34         address[] calldata path,
35         address to,
36         uint deadline
37     ) external payable;
38     function swapExactTokensForETHSupportingFeeOnTransferTokens(
39         uint amountIn,
40         uint amountOutMin,
41         address[] calldata path,
42         address to,
43         uint deadline
44     ) external;
45 }
