1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.2;
3 
4 interface IPancakeRouter01 {
5     function factory() external pure returns (address);
6     function WETH() external pure returns (address);
7 
8     function addLiquidity(
9         address tokenA,
10         address tokenB,
11         uint amountADesired,
12         uint amountBDesired,
13         uint amountAMin,
14         uint amountBMin,
15         address to,
16         uint deadline
17     ) external returns (uint amountA, uint amountB, uint liquidity);
18     function addLiquidityETH(
19         address token,
20         uint amountTokenDesired,
21         uint amountTokenMin,
22         uint amountETHMin,
23         address to,
24         uint deadline
25     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
26     function removeLiquidity(
27         address tokenA,
28         address tokenB,
29         uint liquidity,
30         uint amountAMin,
31         uint amountBMin,
32         address to,
33         uint deadline
34     ) external returns (uint amountA, uint amountB);
35     function removeLiquidityETH(
36         address token,
37         uint liquidity,
38         uint amountTokenMin,
39         uint amountETHMin,
40         address to,
41         uint deadline
42     ) external returns (uint amountToken, uint amountETH);
43     function removeLiquidityWithPermit(
44         address tokenA,
45         address tokenB,
46         uint liquidity,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline,
51         bool approveMax, uint8 v, bytes32 r, bytes32 s
52     ) external returns (uint amountA, uint amountB);
53     function removeLiquidityETHWithPermit(
54         address token,
55         uint liquidity,
56         uint amountTokenMin,
57         uint amountETHMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountToken, uint amountETH);
62     function swapExactTokensForTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external returns (uint[] memory amounts);
69     function swapTokensForExactTokens(
70         uint amountOut,
71         uint amountInMax,
72         address[] calldata path,
73         address to,
74         uint deadline
75     ) external returns (uint[] memory amounts);
76     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
77     external
78     payable
79     returns (uint[] memory amounts);
80     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
81     external
82     returns (uint[] memory amounts);
83     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
84     external
85     returns (uint[] memory amounts);
86     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
87     external
88     payable
89     returns (uint[] memory amounts);
90 
91     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
92     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
93     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
94     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
95     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
96 }
