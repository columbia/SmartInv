1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.2;
4 
5 interface IBabyRouter01 {
6     function factory() external view returns (address);
7     function WETH() external view returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
