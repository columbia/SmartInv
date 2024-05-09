1 pragma solidity =0.6.6;
2 
3 interface IUniswapV2Migrator {
4     function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external;
5 }
6 
7 interface IUniswapV1Factory {
8     function getExchange(address) external view returns (address);
9 }
10 
11 interface IUniswapV1Exchange {
12     function balanceOf(address owner) external view returns (uint);
13     function transferFrom(address from, address to, uint value) external returns (bool);
14     function removeLiquidity(uint, uint, uint, uint) external returns (uint, uint);
15     function tokenToEthSwapInput(uint, uint, uint) external returns (uint);
16     function ethToTokenSwapInput(uint, uint) external payable returns (uint);
17 }
18 
19 interface IUniswapV2Router01 {
20     function factory() external pure returns (address);
21     function WETH() external pure returns (address);
22 
23     function addLiquidity(
24         address tokenA,
25         address tokenB,
26         uint amountADesired,
27         uint amountBDesired,
28         uint amountAMin,
29         uint amountBMin,
30         address to,
31         uint deadline
32     ) external returns (uint amountA, uint amountB, uint liquidity);
33     function addLiquidityETH(
34         address token,
35         uint amountTokenDesired,
36         uint amountTokenMin,
37         uint amountETHMin,
38         address to,
39         uint deadline
40     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
41     function removeLiquidity(
42         address tokenA,
43         address tokenB,
44         uint liquidity,
45         uint amountAMin,
46         uint amountBMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountA, uint amountB);
50     function removeLiquidityETH(
51         address token,
52         uint liquidity,
53         uint amountTokenMin,
54         uint amountETHMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountToken, uint amountETH);
58     function removeLiquidityWithPermit(
59         address tokenA,
60         address tokenB,
61         uint liquidity,
62         uint amountAMin,
63         uint amountBMin,
64         address to,
65         uint deadline,
66         bool approveMax, uint8 v, bytes32 r, bytes32 s
67     ) external returns (uint amountA, uint amountB);
68     function removeLiquidityETHWithPermit(
69         address token,
70         uint liquidity,
71         uint amountTokenMin,
72         uint amountETHMin,
73         address to,
74         uint deadline,
75         bool approveMax, uint8 v, bytes32 r, bytes32 s
76     ) external returns (uint amountToken, uint amountETH);
77     function swapExactTokensForTokens(
78         uint amountIn,
79         uint amountOutMin,
80         address[] calldata path,
81         address to,
82         uint deadline
83     ) external returns (uint[] memory amounts);
84     function swapTokensForExactTokens(
85         uint amountOut,
86         uint amountInMax,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external returns (uint[] memory amounts);
91     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
92         external
93         payable
94         returns (uint[] memory amounts);
95     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
96         external
97         returns (uint[] memory amounts);
98     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
99         external
100         returns (uint[] memory amounts);
101     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
102         external
103         payable
104         returns (uint[] memory amounts);
105 
106     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
107     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
108     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
109     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
110     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
111 }
112 
113 interface IERC20 {
114     event Approval(address indexed owner, address indexed spender, uint value);
115     event Transfer(address indexed from, address indexed to, uint value);
116 
117     function name() external view returns (string memory);
118     function symbol() external view returns (string memory);
119     function decimals() external view returns (uint8);
120     function totalSupply() external view returns (uint);
121     function balanceOf(address owner) external view returns (uint);
122     function allowance(address owner, address spender) external view returns (uint);
123 
124     function approve(address spender, uint value) external returns (bool);
125     function transfer(address to, uint value) external returns (bool);
126     function transferFrom(address from, address to, uint value) external returns (bool);
127 }
128 
129 contract UniswapV2Migrator is IUniswapV2Migrator {
130     IUniswapV1Factory immutable factoryV1;
131     IUniswapV2Router01 immutable router;
132 
133     constructor(address _factoryV1, address _router) public {
134         factoryV1 = IUniswapV1Factory(_factoryV1);
135         router = IUniswapV2Router01(_router);
136     }
137 
138     // needs to accept ETH from any v1 exchange and the router. ideally this could be enforced, as in the router,
139     // but it's not possible because it requires a call to the v1 factory, which takes too much gas
140     receive() external payable {}
141 
142     function migrate(address token, uint amountTokenMin, uint amountETHMin, address to, uint deadline)
143         external
144         override
145     {
146         IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(token));
147         uint liquidityV1 = exchangeV1.balanceOf(msg.sender);
148         require(exchangeV1.transferFrom(msg.sender, address(this), liquidityV1), 'TRANSFER_FROM_FAILED');
149         (uint amountETHV1, uint amountTokenV1) = exchangeV1.removeLiquidity(liquidityV1, 1, 1, uint(-1));
150         TransferHelper.safeApprove(token, address(router), amountTokenV1);
151         (uint amountTokenV2, uint amountETHV2,) = router.addLiquidityETH{value: amountETHV1}(
152             token,
153             amountTokenV1,
154             amountTokenMin,
155             amountETHMin,
156             to,
157             deadline
158         );
159         if (amountTokenV1 > amountTokenV2) {
160             TransferHelper.safeApprove(token, address(router), 0); // be a good blockchain citizen, reset allowance to 0
161             TransferHelper.safeTransfer(token, msg.sender, amountTokenV1 - amountTokenV2);
162         } else if (amountETHV1 > amountETHV2) {
163             // addLiquidityETH guarantees that all of amountETHV1 or amountTokenV1 will be used, hence this else is safe
164             TransferHelper.safeTransferETH(msg.sender, amountETHV1 - amountETHV2);
165         }
166     }
167 }
168 
169 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
170 library TransferHelper {
171     function safeApprove(address token, address to, uint value) internal {
172         // bytes4(keccak256(bytes('approve(address,uint256)')));
173         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
174         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
175     }
176 
177     function safeTransfer(address token, address to, uint value) internal {
178         // bytes4(keccak256(bytes('transfer(address,uint256)')));
179         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
180         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
181     }
182 
183     function safeTransferFrom(address token, address from, address to, uint value) internal {
184         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
185         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
186         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
187     }
188 
189     function safeTransferETH(address to, uint value) internal {
190         (bool success,) = to.call{value:value}(new bytes(0));
191         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
192     }
193 }