1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import {IPancakeRouter01} from "./IPancakeRouter01.sol";
6 
7 interface IPancakeRouter02 is IPancakeRouter01 {
8     function removeLiquidityETHSupportingFeeOnTransferTokens(
9         address token,
10         uint liquidity,
11         uint amountTokenMin,
12         uint amountETHMin,
13         address to,
14         uint deadline
15     ) external returns (uint amountETH);
16     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
17         address token,
18         uint liquidity,
19         uint amountTokenMin,
20         uint amountETHMin,
21         address to,
22         uint deadline,
23         bool approveMax, uint8 v, bytes32 r, bytes32 s
24     ) external returns (uint amountETH);
25 
26     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
27         uint amountIn,
28         uint amountOutMin,
29         address[] calldata path,
30         address to,
31         uint deadline
32     ) external;
33     function swapExactETHForTokensSupportingFeeOnTransferTokens(
34         uint amountOutMin,
35         address[] calldata path,
36         address to,
37         uint deadline
38     ) external payable;
39     function swapExactTokensForETHSupportingFeeOnTransferTokens(
40         uint amountIn,
41         uint amountOutMin,
42         address[] calldata path,
43         address to,
44         uint deadline
45     ) external;
46 }
