1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 interface IBabyNormalRouter {
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
17 
18     function addLiquidityETH(
19         address token,
20         uint amountTokenDesired,
21         uint amountTokenMin,
22         uint amountETHMin,
23         address to,
24         uint deadline
25     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
26 
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36 
37     function removeLiquidityWithPermit(
38         address tokenA,
39         address tokenB,
40         uint liquidity,
41         uint amountAMin,
42         uint amountBMin,
43         address to,
44         uint deadline,
45         bool approveMax, uint8 v, bytes32 r, bytes32 s
46     ) external returns (uint amountA, uint amountB);
47 
48     function removeLiquidityETH(
49         address token,
50         uint liquidity,
51         uint amountTokenMin,
52         uint amountETHMin,
53         address to,
54         uint deadline
55     ) external returns (uint amountToken, uint amountETH);
56 
57     function removeLiquidityETHWithPermit(
58         address token,
59         uint liquidity,
60         uint amountTokenMin,
61         uint amountETHMin,
62         address to,
63         uint deadline,
64         bool approveMax, uint8 v, bytes32 r, bytes32 s
65     ) external returns (uint amountToken, uint amountETH);
66 
67     function removeLiquidityETHSupportingFeeOnTransferTokens(
68         address token,
69         uint liquidity,
70         uint amountTokenMin,
71         uint amountETHMin,
72         address to,
73         uint deadline
74     ) external returns (uint amountETH);
75 
76     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
77         address token,
78         uint liquidity,
79         uint amountTokenMin,
80         uint amountETHMin,
81         address to,
82         uint deadline,
83         bool approveMax, uint8 v, bytes32 r, bytes32 s
84     ) external returns (uint amountETH);
85 
86     function swapExactTokensForTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external returns (uint[] calldata amounts);
93 
94     function swapTokensForExactTokens(
95         uint amountOut,
96         uint amountInMax,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external returns (uint[] calldata amounts);
101 
102     function swapExactETHForTokens(
103         uint amountOutMin, 
104         address[] calldata path, 
105         address to, 
106         uint deadline
107     ) external payable returns (uint[] calldata amounts);
108 
109     function swapTokensForExactETH(
110         uint amountOut, 
111         uint amountInMax, 
112         address[] calldata path, 
113         address to, 
114         uint deadline
115     ) external returns (uint[] calldata amounts);
116 
117     function swapExactTokensForETH(
118         uint amountIn, 
119         uint amountOutMin, 
120         address[] calldata path, 
121         address to, 
122         uint deadline
123     ) external returns (uint[] calldata amounts);
124 
125     function swapETHForExactTokens(
126         uint amountOut, 
127         address[] calldata path, 
128         address to, 
129         uint deadline
130     ) external payable returns (uint[] calldata amounts);
131 
132     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 
140     function swapExactETHForTokensSupportingFeeOnTransferTokens(
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external payable;
146 
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154 
155     function quote(
156         uint amountA, 
157         uint reserveA, 
158         uint reserveB
159     ) external pure returns (uint amountB);
160 
161     function getAmountOut(
162         uint amountIn, 
163         uint reserveIn, 
164         uint reserveOut
165     ) external pure returns (uint amountOut);
166 
167     function getAmountIn(
168         uint amountOut, 
169         uint reserveIn, 
170         uint reserveOut
171     ) external pure returns (uint amountIn);
172 
173     function getAmountsOut(
174         uint amountIn, 
175         address[] calldata path
176     ) external view returns (uint[] calldata amounts);
177 
178     function getAmountsIn(
179         uint amountOut, 
180         address[] calldata path
181     ) external view returns (uint[] calldata amounts);
182 }
