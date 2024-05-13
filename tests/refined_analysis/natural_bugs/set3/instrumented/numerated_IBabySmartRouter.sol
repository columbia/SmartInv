1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 interface IBabySmartRouter {
6 
7     function swapExactTokensForTokens(
8         uint amountIn,
9         uint amountOutMin,
10         address[] calldata path,
11         address[] calldata factories,
12         uint[] calldata fees,
13         address to,
14         uint deadline
15     ) external  returns (uint[] calldata amounts);
16 
17     function swapTokensForExactTokens(
18         uint amountOut,
19         uint amountInMax,
20         address[] calldata path,
21         address[] calldata factories,
22         uint[] calldata fees,
23         address to,
24         uint deadline
25     ) external  returns (uint[] calldata amounts);
26 
27     function swapExactETHForTokens(
28         uint amountOutMin, 
29         address[] calldata path, 
30         address[] calldata factories, 
31         uint[] calldata fees, 
32         address to, 
33         uint deadline
34     ) external  payable returns (uint[] calldata amounts);
35 
36     function swapTokensForExactETH(
37         uint amountOut, 
38         uint amountInMax, 
39         address[] calldata path, 
40         address[] calldata factories, 
41         uint[] calldata fees, 
42         address to, 
43         uint deadline
44     ) external  returns (uint[] calldata amounts);
45 
46     function swapExactTokensForETH(
47         uint amountIn, 
48         uint amountOutMin, 
49         address[] calldata path, 
50         address[] calldata factories, 
51         uint[] calldata fees, 
52         address to, 
53         uint deadline
54     ) external  returns (uint[] calldata amounts);
55 
56     function swapETHForExactTokens(
57         uint amountOut, 
58         address[] calldata path, 
59         address[] calldata factories, 
60         uint[] calldata fees, 
61         address to, 
62         uint deadline
63     ) external  payable returns (uint[] calldata amounts);
64 
65     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
66         uint amountIn,
67         uint amountOutMin,
68         address[] calldata path,
69         address[] calldata factories,
70         uint[] calldata fees,
71         address to,
72         uint deadline
73     ) external ;
74 
75     function swapExactETHForTokensSupportingFeeOnTransferTokens(
76         uint amountOutMin,
77         address[] calldata path,
78         address[] calldata factories,
79         uint[] calldata fees,
80         address to,
81         uint deadline
82     ) external  payable;
83 
84     function swapExactTokensForETHSupportingFeeOnTransferTokens(
85         uint amountIn,
86         uint amountOutMin,
87         address[] calldata path,
88         address[] calldata factories,
89         uint[] calldata fees,
90         address to,
91         uint deadline
92     ) external ;
93 
94 }
