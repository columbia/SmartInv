1 pragma solidity ^0.5.0;
2 
3 import './IUniswapV2Router01.sol';
4 
5 contract IUniswapV2Router02 is IUniswapV2Router01 {
6     function removeLiquidityETHSupportingFeeOnTransferTokens(
7         address token,
8         uint liquidity,
9         uint amountTokenMin,
10         uint amountETHMin,
11         address to,
12         uint deadline
13     ) external returns (uint amountETH);
14     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
15         address token,
16         uint liquidity,
17         uint amountTokenMin,
18         uint amountETHMin,
19         address to,
20         uint deadline,
21         bool approveMax, uint8 v, bytes32 r, bytes32 s
22     ) external returns (uint amountETH);
23 
24     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
25         uint amountIn,
26         uint amountOutMin,
27         address[] calldata path,
28         address to,
29         uint deadline
30     ) external;
31     function swapExactETHForTokensSupportingFeeOnTransferTokens(
32         uint amountOutMin,
33         address[] calldata path,
34         address to,
35         uint deadline
36     ) external payable;
37     function swapExactTokensForETHSupportingFeeOnTransferTokens(
38         uint amountIn,
39         uint amountOutMin,
40         address[] calldata path,
41         address to,
42         uint deadline
43     ) external;
44 }