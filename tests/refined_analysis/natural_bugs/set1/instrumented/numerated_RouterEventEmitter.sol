1 pragma solidity =0.6.6;
2 
3 import '../interfaces/IUniswapV2Router01.sol';
4 
5 contract RouterEventEmitter {
6     event Amounts(uint[] amounts);
7 
8     receive() external payable {}
9 
10     function swapExactTokensForTokens(
11         address router,
12         uint amountIn,
13         uint amountOutMin,
14         address[] calldata path,
15         address to,
16         uint deadline
17     ) external {
18         (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
19             IUniswapV2Router01(router).swapExactTokensForTokens.selector, amountIn, amountOutMin, path, to, deadline
20         ));
21         assert(success);
22         emit Amounts(abi.decode(returnData, (uint[])));
23     }
24 
25     function swapTokensForExactTokens(
26         address router,
27         uint amountOut,
28         uint amountInMax,
29         address[] calldata path,
30         address to,
31         uint deadline
32     ) external {
33         (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
34             IUniswapV2Router01(router).swapTokensForExactTokens.selector, amountOut, amountInMax, path, to, deadline
35         ));
36         assert(success);
37         emit Amounts(abi.decode(returnData, (uint[])));
38     }
39 
40     function swapExactETHForTokens(
41         address router,
42         uint amountOutMin,
43         address[] calldata path,
44         address to,
45         uint deadline
46     ) external payable {
47         (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
48             IUniswapV2Router01(router).swapExactETHForTokens.selector, amountOutMin, path, to, deadline
49         ));
50         assert(success);
51         emit Amounts(abi.decode(returnData, (uint[])));
52     }
53 
54     function swapTokensForExactETH(
55         address router,
56         uint amountOut,
57         uint amountInMax,
58         address[] calldata path,
59         address to,
60         uint deadline
61     ) external {
62         (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
63             IUniswapV2Router01(router).swapTokensForExactETH.selector, amountOut, amountInMax, path, to, deadline
64         ));
65         assert(success);
66         emit Amounts(abi.decode(returnData, (uint[])));
67     }
68 
69     function swapExactTokensForETH(
70         address router,
71         uint amountIn,
72         uint amountOutMin,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external {
77         (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
78             IUniswapV2Router01(router).swapExactTokensForETH.selector, amountIn, amountOutMin, path, to, deadline
79         ));
80         assert(success);
81         emit Amounts(abi.decode(returnData, (uint[])));
82     }
83 
84     function swapETHForExactTokens(
85         address router,
86         uint amountOut,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external payable {
91         (bool success, bytes memory returnData) = router.delegatecall(abi.encodeWithSelector(
92             IUniswapV2Router01(router).swapETHForExactTokens.selector, amountOut, path, to, deadline
93         ));
94         assert(success);
95         emit Amounts(abi.decode(returnData, (uint[])));
96     }
97 }
