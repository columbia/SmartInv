1 /**
2  *Submitted for verification at Etherscan.io on 2023-09-14
3 */
4 
5 // SHIB 2 ETH
6 
7 
8 //           /$$       /$$ /$$        /$$$$$$         /$$$$$$  /$$      /$$  /$$$$$$  /$$$$$$$  /$$$$$$$  /$$$$$$$$ /$$$$$$$ 
9 //          | $$      |__/| $$       /$$__  $$       /$$__  $$| $$  /$ | $$ /$$__  $$| $$__  $$| $$__  $$| $$_____/| $$__  $$
10 //  /$$$$$$$| $$$$$$$  /$$| $$$$$$$ |__/  \ $$      | $$  \__/| $$ /$$$| $$| $$  \ $$| $$  \ $$| $$  \ $$| $$      | $$  \ $$
11 // /$$_____/| $$__  $$| $$| $$__  $$  /$$$$$$/      |  $$$$$$ | $$/$$ $$ $$| $$$$$$$$| $$$$$$$/| $$$$$$$/| $$$$$   | $$$$$$$/
12 //|  $$$$$$ | $$  \ $$| $$| $$  \ $$ /$$____/        \____  $$| $$$$_  $$$$| $$__  $$| $$____/ | $$____/ | $$__/   | $$__  $$
13 // \____  $$| $$  | $$| $$| $$  | $$| $$             /$$  \ $$| $$$/ \  $$$| $$  | $$| $$      | $$      | $$      | $$  \ $$
14 // /$$$$$$$/| $$  | $$| $$| $$$$$$$/| $$$$$$$$      |  $$$$$$/| $$/   \  $$| $$  | $$| $$      | $$      | $$$$$$$$| $$  | $$
15 //|_______/ |__/  |__/|__/|_______/ |________/       \______/ |__/     \__/|__/  |__/|__/      |__/      |________/|__/  |__/
16                                                                                                                            
17 
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity ^0.8.4;
21 
22 abstract contract ReentrancyGuard {
23     uint256 private constant _NOT_ENTERED = 1;
24     uint256 private constant _ENTERED = 2;
25     uint256 private _status;
26     constructor () {
27         _status = _NOT_ENTERED;
28     }
29     modifier nonReentrant() {
30         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
31         _status = _ENTERED;
32         _;
33         _status = _NOT_ENTERED;
34     }
35 }
36 interface IPancakeRouter01 {
37     function factory() external pure returns (address);
38     function WBNB() external pure returns (address);
39     function addLiquidity(
40         address tokenA,
41         address tokenB,
42         uint amountADesired,
43         uint amountBDesired,
44         uint amountAMin,
45         uint amountBMin,
46         address to,
47         uint deadline
48     ) external returns (uint amountA, uint amountB, uint liquidity);
49     function addLiquidityETH(
50         address token,
51         uint amountTokenDesired,
52         uint amountTokenMin,
53         uint amountETHMin,
54         address to,
55         uint deadline
56     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
57     function removeLiquidity(
58         address tokenA,
59         address tokenB,
60         uint liquidity,
61         uint amountAMin,
62         uint amountBMin,
63         address to,
64         uint deadline
65     ) external returns (uint amountA, uint amountB);
66     function removeLiquidityETH(
67         address token,
68         uint liquidity,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline
73     ) external returns (uint amountToken, uint amountETH);
74     function removeLiquidityWithPermit(
75         address tokenA,
76         address tokenB,
77         uint liquidity,
78         uint amountAMin,
79         uint amountBMin,
80         address to,
81         uint deadline,
82         bool approveMax, uint8 v, bytes32 r, bytes32 s
83     ) external returns (uint amountA, uint amountB);
84     function removeLiquidityETHWithPermit(
85         address token,
86         uint liquidity,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline,
91         bool approveMax, uint8 v, bytes32 r, bytes32 s
92     ) external returns (uint amountToken, uint amountETH);
93     function swapExactTokensForTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external returns (uint[] memory amounts);
100     function swapTokensForExactTokens(
101         uint amountOut,
102         uint amountInMax,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external returns (uint[] memory amounts);
107     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
108         external
109         payable
110         returns (uint[] memory amounts);
111     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
112         external
113         returns (uint[] memory amounts);
114     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
115         external
116         returns (uint[] memory amounts);
117     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
118         external
119         payable
120         returns (uint[] memory amounts);
121     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
122     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
123     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
124     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
125     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
126 }
127 interface IPancakeRouter02 is IPancakeRouter01 {
128     function removeLiquidityETHSupportingFeeOnTransferTokens(
129         address token,
130         uint liquidity,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external returns (uint amountETH);
136     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountETH);
145 
146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153     function swapExactETHForTokensSupportingFeeOnTransferTokens(
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external payable;
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166 }
167 interface IBEP20 {
168     function totalSupply() external view returns (uint256);
169     function decimals() external view returns (uint8);
170     function symbol() external view returns (string memory);
171     function name() external view returns (string memory);
172     function getOwner() external view returns (address);
173     function balanceOf(address account) external view returns (uint256);
174     function transfer(address recipient, uint256 amount) external returns (bool);
175     function allowance(address _owner, address spender) external view returns (uint256);
176     function approve(address spender, uint256 amount) external returns (bool);
177     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
178     event Transfer(address indexed from, address indexed to, uint256 value);
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 contract SHIB2Swapper is ReentrancyGuard {
182     bool public swapperEnabled;
183     address public owner;
184     //
185     IPancakeRouter02 router;
186     address constant ETH =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
187     address constant SHIB2 = 0x2dE7B02Ae3b1f11d51Ca7b2495e9094874A064c0; // SHIB2 TOKEN
188     event TransferOwnership(address oldOwner,address newOwner);
189     event BoughtWithBnb(address);
190     event BoughtWithToken(address, address); //sender, token
191     constructor () {
192         owner=msg.sender;
193         router = IPancakeRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
194     }
195     receive() external payable {
196         require(swapperEnabled);
197         buyTokens(msg.value, msg.sender);
198     }
199     function transferOwnership(address newOwner) public {
200         require(msg.sender==owner);
201         address oldOwner=owner;
202         owner=newOwner;
203         emit TransferOwnership(oldOwner,owner);
204     }
205     function enableSwapper(bool enabled) public {
206         require(msg.sender==owner);
207         swapperEnabled=enabled;
208     }
209     function TeamWithdrawStrandedToken(address strandedToken) public {
210         require(msg.sender==owner);
211         IBEP20 token=IBEP20(strandedToken);
212         token.transfer(msg.sender, token.balanceOf(address(this)));
213     }
214     function getPath(address token0, address token1) internal pure returns (address[] memory) {
215         address[] memory path = new address[](2);
216         path[0] = token0;
217         path[1] = token1;
218         return path;
219     }
220     function buyTokens(uint amt, address to) internal {
221         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amt}(
222             0,
223             getPath(ETH, SHIB2),
224             to,
225             block.timestamp
226         );
227         emit BoughtWithBnb(to);
228     }
229     function buyWithToken(uint amt, IBEP20 token) external nonReentrant {
230         require(token.allowance(msg.sender, address(router)) >= amt);
231         try
232             router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
233                 amt,
234                 0,
235                 getPath(address(token), SHIB2),
236                 msg.sender,
237                 block.timestamp
238             ) {
239             emit BoughtWithToken(msg.sender, address(token));
240         }
241         catch {
242             revert("Error swapping to MSWAP.");
243         }
244     }
245 }