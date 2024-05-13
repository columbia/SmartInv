1 pragma solidity >=0.6.2;
2 
3 interface IUniswapV2Router01 {
4     function factory() external pure returns (address);
5     function WETH() external pure returns (address);
6 
7     function addLiquidity(
8         address tokenA,
9         address tokenB,
10         uint amountADesired,
11         uint amountBDesired,
12         uint amountAMin,
13         uint amountBMin,
14         address to,
15         uint deadline
16     ) external returns (uint amountA, uint amountB, uint liquidity);
17     function addLiquidityETH(
18         address token,
19         uint amountTokenDesired,
20         uint amountTokenMin,
21         uint amountETHMin,
22         address to,
23         uint deadline
24     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
25     function removeLiquidity(
26         address tokenA,
27         address tokenB,
28         uint liquidity,
29         uint amountAMin,
30         uint amountBMin,
31         address to,
32         uint deadline
33     ) external returns (uint amountA, uint amountB);
34     function removeLiquidityETH(
35         address token,
36         uint liquidity,
37         uint amountTokenMin,
38         uint amountETHMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountToken, uint amountETH);
42     function removeLiquidityWithPermit(
43         address tokenA,
44         address tokenB,
45         uint liquidity,
46         uint amountAMin,
47         uint amountBMin,
48         address to,
49         uint deadline,
50         bool approveMax, uint8 v, bytes32 r, bytes32 s
51     ) external returns (uint amountA, uint amountB);
52     function removeLiquidityETHWithPermit(
53         address token,
54         uint liquidity,
55         uint amountTokenMin,
56         uint amountETHMin,
57         address to,
58         uint deadline,
59         bool approveMax, uint8 v, bytes32 r, bytes32 s
60     ) external returns (uint amountToken, uint amountETH);
61     function swapExactTokensForTokens(
62         uint amountIn,
63         uint amountOutMin,
64         address[] calldata path,
65         address to,
66         uint deadline
67     ) external returns (uint[] memory amounts);
68     function swapTokensForExactTokens(
69         uint amountOut,
70         uint amountInMax,
71         address[] calldata path,
72         address to,
73         uint deadline
74     ) external returns (uint[] memory amounts);
75     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
76         external
77         payable
78         returns (uint[] memory amounts);
79     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
80         external
81         returns (uint[] memory amounts);
82     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
83         external
84         returns (uint[] memory amounts);
85     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
86         external
87         payable
88         returns (uint[] memory amounts);
89 
90     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
91     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
92     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
93     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
94     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
95 }
