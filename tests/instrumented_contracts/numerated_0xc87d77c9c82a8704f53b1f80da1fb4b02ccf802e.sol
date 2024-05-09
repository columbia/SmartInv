1 // $MSWAP TEAM BUILDING FOR YEARS IN BLOCKCHAIN AND GAME DEV MODE 
2 
3 
4 // WANT YOUR OWN SWAPPER CONTACT US AT MARSWAP.EXCHANGE.COM
5 
6 
7 
8 
9 //| $$      /$$  /$$$$$$  /$$$$$$$   /$$$$$$  /$$      /$$  /$$$$$$  /$$$$$$$ 
10 //| $$$    /$$$ /$$__  $$| $$__  $$ /$$__  $$| $$  /$ | $$ /$$__  $$| $$__  $$
11 //| $$$$  /$$$$| $$  \ $$| $$  \ $$| $$  \__/| $$ /$$$| $$| $$  \ $$| $$  \ $$
12 //| $$ $$/$$ $$| $$$$$$$$| $$$$$$$/|  $$$$$$ | $$/$$ $$ $$| $$$$$$$$| $$$$$$$/
13 //| $$  $$$| $$| $$__  $$| $$__  $$ \____  $$| $$$$_  $$$$| $$__  $$| $$____/ 
14 //| $$\  $ | $$| $$  | $$| $$  \ $$ /$$  \ $$| $$$/ \  $$$| $$  | $$| $$      
15 //| $$ \/  | $$| $$  | $$| $$  | $$|  $$$$$$/| $$/   \  $$| $$  | $$| $$      
16 //|/       |/    |/  |/  |/    |/   \______/ |/        \/ |/    |/  |__/
17 
18 
19 
20 // SPDX-License-Identifier: MIT
21 pragma solidity ^0.8.4;
22 
23 abstract contract ReentrancyGuard {
24     uint256 private constant _NOT_ENTERED = 1;
25     uint256 private constant _ENTERED = 2;
26     uint256 private _status;
27     constructor () {
28         _status = _NOT_ENTERED;
29     }
30     modifier nonReentrant() {
31         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
32         _status = _ENTERED;
33         _;
34         _status = _NOT_ENTERED;
35     }
36 }
37 interface IPancakeRouter01 {
38     function factory() external pure returns (address);
39     function WBNB() external pure returns (address);
40     function addLiquidity(
41         address tokenA,
42         address tokenB,
43         uint amountADesired,
44         uint amountBDesired,
45         uint amountAMin,
46         uint amountBMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountA, uint amountB, uint liquidity);
50     function addLiquidityETH(
51         address token,
52         uint amountTokenDesired,
53         uint amountTokenMin,
54         uint amountETHMin,
55         address to,
56         uint deadline
57     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
58     function removeLiquidity(
59         address tokenA,
60         address tokenB,
61         uint liquidity,
62         uint amountAMin,
63         uint amountBMin,
64         address to,
65         uint deadline
66     ) external returns (uint amountA, uint amountB);
67     function removeLiquidityETH(
68         address token,
69         uint liquidity,
70         uint amountTokenMin,
71         uint amountETHMin,
72         address to,
73         uint deadline
74     ) external returns (uint amountToken, uint amountETH);
75     function removeLiquidityWithPermit(
76         address tokenA,
77         address tokenB,
78         uint liquidity,
79         uint amountAMin,
80         uint amountBMin,
81         address to,
82         uint deadline,
83         bool approveMax, uint8 v, bytes32 r, bytes32 s
84     ) external returns (uint amountA, uint amountB);
85     function removeLiquidityETHWithPermit(
86         address token,
87         uint liquidity,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline,
92         bool approveMax, uint8 v, bytes32 r, bytes32 s
93     ) external returns (uint amountToken, uint amountETH);
94     function swapExactTokensForTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external returns (uint[] memory amounts);
101     function swapTokensForExactTokens(
102         uint amountOut,
103         uint amountInMax,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external returns (uint[] memory amounts);
108     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
109         external
110         payable
111         returns (uint[] memory amounts);
112     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
113         external
114         returns (uint[] memory amounts);
115     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
116         external
117         returns (uint[] memory amounts);
118     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
119         external
120         payable
121         returns (uint[] memory amounts);
122     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
123     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
124     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
125     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
126     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
127 }
128 interface IPancakeRouter02 is IPancakeRouter01 {
129     function removeLiquidityETHSupportingFeeOnTransferTokens(
130         address token,
131         uint liquidity,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external returns (uint amountETH);
137     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
138         address token,
139         uint liquidity,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline,
144         bool approveMax, uint8 v, bytes32 r, bytes32 s
145     ) external returns (uint amountETH);
146 
147     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external;
154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external payable;
160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
161         uint amountIn,
162         uint amountOutMin,
163         address[] calldata path,
164         address to,
165         uint deadline
166     ) external;
167 }
168 interface IBEP20 {
169     function totalSupply() external view returns (uint256);
170     function decimals() external view returns (uint8);
171     function symbol() external view returns (string memory);
172     function name() external view returns (string memory);
173     function getOwner() external view returns (address);
174     function balanceOf(address account) external view returns (uint256);
175     function transfer(address recipient, uint256 amount) external returns (bool);
176     function allowance(address _owner, address spender) external view returns (uint256);
177     function approve(address spender, uint256 amount) external returns (bool);
178     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
179     event Transfer(address indexed from, address indexed to, uint256 value);
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 contract MSWAPSwapper is ReentrancyGuard {
183     bool public swapperEnabled;
184     address public owner;
185     //
186     IPancakeRouter02 router;
187     address constant ETH =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
188     address constant MSWAP = 0x4bE2b2C45b432BA362f198c08094017b61E3BDc6 ; // MSWAP TOKEN
189     event TransferOwnership(address oldOwner,address newOwner);
190     event BoughtWithBnb(address);
191     event BoughtWithToken(address, address); //sender, token
192     constructor () {
193         owner=msg.sender;
194         router = IPancakeRouter02(0x03f7724180AA6b939894B5Ca4314783B0b36b329);
195     }
196     receive() external payable {
197         require(swapperEnabled);
198         buyTokens(msg.value, msg.sender);
199     }
200     function transferOwnership(address newOwner) public {
201         require(msg.sender==owner);
202         address oldOwner=owner;
203         owner=newOwner;
204         emit TransferOwnership(oldOwner,owner);
205     }
206     function enableSwapper(bool enabled) public {
207         require(msg.sender==owner);
208         swapperEnabled=enabled;
209     }
210     function TeamWithdrawStrandedToken(address strandedToken) public {
211         require(msg.sender==owner);
212         IBEP20 token=IBEP20(strandedToken);
213         token.transfer(msg.sender, token.balanceOf(address(this)));
214     }
215     function getPath(address token0, address token1) internal pure returns (address[] memory) {
216         address[] memory path = new address[](2);
217         path[0] = token0;
218         path[1] = token1;
219         return path;
220     }
221     function buyTokens(uint amt, address to) internal {
222         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amt}(
223             0,
224             getPath(ETH, MSWAP),
225             to,
226             block.timestamp
227         );
228         emit BoughtWithBnb(to);
229     }
230     function buyWithToken(uint amt, IBEP20 token) external nonReentrant {
231         require(token.allowance(msg.sender, address(router)) >= amt);
232         try
233             router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
234                 amt,
235                 0,
236                 getPath(address(token), MSWAP),
237                 msg.sender,
238                 block.timestamp
239             ) {
240             emit BoughtWithToken(msg.sender, address(token));
241         }
242         catch {
243             revert("Error swapping to MSWAP.");
244         }
245     }
246 }