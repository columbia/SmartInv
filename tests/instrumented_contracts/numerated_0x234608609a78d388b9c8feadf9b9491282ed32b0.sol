1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-09
3 */
4 
5 // $MSWAP TEAM BUILDING FOR YEARS IN BLOCKCHAIN AND GAME DEV MODE 
6 
7 
8 // WANT YOUR OWN SWAPPER CONTACT US AT MARSWAP.EXCHANGE.COM
9 
10 
11 
12 
13 //| $$      /$$  /$$$$$$  /$$$$$$$   /$$$$$$  /$$      /$$  /$$$$$$  /$$$$$$$ 
14 //| $$$    /$$$ /$$__  $$| $$__  $$ /$$__  $$| $$  /$ | $$ /$$__  $$| $$__  $$
15 //| $$$$  /$$$$| $$  \ $$| $$  \ $$| $$  \__/| $$ /$$$| $$| $$  \ $$| $$  \ $$
16 //| $$ $$/$$ $$| $$$$$$$$| $$$$$$$/|  $$$$$$ | $$/$$ $$ $$| $$$$$$$$| $$$$$$$/
17 //| $$  $$$| $$| $$__  $$| $$__  $$ \____  $$| $$$$_  $$$$| $$__  $$| $$____/ 
18 //| $$\  $ | $$| $$  | $$| $$  \ $$ /$$  \ $$| $$$/ \  $$$| $$  | $$| $$      
19 //| $$ \/  | $$| $$  | $$| $$  | $$|  $$$$$$/| $$/   \  $$| $$  | $$| $$      
20 //|/       |/    |/  |/  |/    |/   \______/ |/        \/ |/    |/  |__/
21 
22 
23 
24 // SPDX-License-Identifier: MIT
25 pragma solidity ^0.8.4;
26 
27 abstract contract ReentrancyGuard {
28     uint256 private constant _NOT_ENTERED = 1;
29     uint256 private constant _ENTERED = 2;
30     uint256 private _status;
31     constructor () {
32         _status = _NOT_ENTERED;
33     }
34     modifier nonReentrant() {
35         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
36         _status = _ENTERED;
37         _;
38         _status = _NOT_ENTERED;
39     }
40 }
41 interface IPancakeRouter01 {
42     function factory() external pure returns (address);
43     function WBNB() external pure returns (address);
44     function addLiquidity(
45         address tokenA,
46         address tokenB,
47         uint amountADesired,
48         uint amountBDesired,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline
53     ) external returns (uint amountA, uint amountB, uint liquidity);
54     function addLiquidityETH(
55         address token,
56         uint amountTokenDesired,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline
61     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
62     function removeLiquidity(
63         address tokenA,
64         address tokenB,
65         uint liquidity,
66         uint amountAMin,
67         uint amountBMin,
68         address to,
69         uint deadline
70     ) external returns (uint amountA, uint amountB);
71     function removeLiquidityETH(
72         address token,
73         uint liquidity,
74         uint amountTokenMin,
75         uint amountETHMin,
76         address to,
77         uint deadline
78     ) external returns (uint amountToken, uint amountETH);
79     function removeLiquidityWithPermit(
80         address tokenA,
81         address tokenB,
82         uint liquidity,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline,
87         bool approveMax, uint8 v, bytes32 r, bytes32 s
88     ) external returns (uint amountA, uint amountB);
89     function removeLiquidityETHWithPermit(
90         address token,
91         uint liquidity,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline,
96         bool approveMax, uint8 v, bytes32 r, bytes32 s
97     ) external returns (uint amountToken, uint amountETH);
98     function swapExactTokensForTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external returns (uint[] memory amounts);
105     function swapTokensForExactTokens(
106         uint amountOut,
107         uint amountInMax,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external returns (uint[] memory amounts);
112     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
113         external
114         payable
115         returns (uint[] memory amounts);
116     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
117         external
118         returns (uint[] memory amounts);
119     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
120         external
121         returns (uint[] memory amounts);
122     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
123         external
124         payable
125         returns (uint[] memory amounts);
126     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
127     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
128     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
129     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
130     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
131 }
132 interface IPancakeRouter02 is IPancakeRouter01 {
133     function removeLiquidityETHSupportingFeeOnTransferTokens(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external returns (uint amountETH);
141     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
142         address token,
143         uint liquidity,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline,
148         bool approveMax, uint8 v, bytes32 r, bytes32 s
149     ) external returns (uint amountETH);
150 
151     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external payable;
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171 }
172 interface IBEP20 {
173     function totalSupply() external view returns (uint256);
174     function decimals() external view returns (uint8);
175     function symbol() external view returns (string memory);
176     function name() external view returns (string memory);
177     function getOwner() external view returns (address);
178     function balanceOf(address account) external view returns (uint256);
179     function transfer(address recipient, uint256 amount) external returns (bool);
180     function allowance(address _owner, address spender) external view returns (uint256);
181     function approve(address spender, uint256 amount) external returns (bool);
182     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
183     event Transfer(address indexed from, address indexed to, uint256 value);
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 contract PREMESwapper is ReentrancyGuard {
187     bool public swapperEnabled;
188     address public owner;
189     //
190     IPancakeRouter02 router;
191     address constant ETH =  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
192     address constant PREME = 0x7d0C49057c09501595A8ce23b773BB36A40b521F; // PREME TOKEN
193     event TransferOwnership(address oldOwner,address newOwner);
194     event BoughtWithBnb(address);
195     event BoughtWithToken(address, address); //sender, token
196     constructor () {
197         owner=msg.sender;
198         router = IPancakeRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
199     }
200     receive() external payable {
201         require(swapperEnabled);
202         buyTokens(msg.value, msg.sender);
203     }
204     function transferOwnership(address newOwner) public {
205         require(msg.sender==owner);
206         address oldOwner=owner;
207         owner=newOwner;
208         emit TransferOwnership(oldOwner,owner);
209     }
210     function enableSwapper(bool enabled) public {
211         require(msg.sender==owner);
212         swapperEnabled=enabled;
213     }
214     function TeamWithdrawStrandedToken(address strandedToken) public {
215         require(msg.sender==owner);
216         IBEP20 token=IBEP20(strandedToken);
217         token.transfer(msg.sender, token.balanceOf(address(this)));
218     }
219     function getPath(address token0, address token1) internal pure returns (address[] memory) {
220         address[] memory path = new address[](2);
221         path[0] = token0;
222         path[1] = token1;
223         return path;
224     }
225     function buyTokens(uint amt, address to) internal {
226         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amt}(
227             0,
228             getPath(ETH, PREME),
229             to,
230             block.timestamp
231         );
232         emit BoughtWithBnb(to);
233     }
234     function buyWithToken(uint amt, IBEP20 token) external nonReentrant {
235         require(token.allowance(msg.sender, address(router)) >= amt);
236         try
237             router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
238                 amt,
239                 0,
240                 getPath(address(token), PREME),
241                 msg.sender,
242                 block.timestamp
243             ) {
244             emit BoughtWithToken(msg.sender, address(token));
245         }
246         catch {
247             revert("Error swapping to MSWAP.");
248         }
249     }
250 }