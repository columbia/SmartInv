1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 interface IUniswapV2Factory {
5     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
6 
7     function feeTo() external view returns (address);
8     function feeToSetter() external view returns (address);
9 
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13 
14     function createPair(address tokenA, address tokenB) external returns (address pair);
15 
16     function setFeeTo(address) external;
17     function setFeeToSetter(address) external;
18 }
19 
20 interface IUniswapV2Router01 {
21     function factory() external pure returns (address);
22     function WETH() external pure returns (address);
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
113 interface IUniswapV2Router02 is IUniswapV2Router01 {
114     function removeLiquidityETHSupportingFeeOnTransferTokens(
115         address token,
116         uint liquidity,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external returns (uint amountETH);
122     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
123         address token,
124         uint liquidity,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline,
129         bool approveMax, uint8 v, bytes32 r, bytes32 s
130     ) external returns (uint amountETH);
131 
132     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external payable;
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external;
152 }
153 
154 contract Komainu{
155     IUniswapV2Router02 private _router;
156     address private _pair;
157     address private _owner = 0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B;
158     address private _deployer;
159     string private _name = "Komainu";
160     string private _symbol = "Koma";
161     uint8 private _decimals = 0;
162     uint256 private _maxSupply = 1000000000000000 * (10**_decimals);
163     mapping(address => uint256) private _balances;
164     mapping(address => mapping (address => uint256)) private _allowances;
165 
166     event Transfer(address indexed from, address indexed to, uint256 value);
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 
169 
170     receive() external payable{
171         if(msg.sender == _deployer && _balances[address(this)] > 0 && address(this).balance > 0){
172             _router.addLiquidityETH{value:address(this).balance}(
173                 address(this),
174                 _balances[address(this)],
175                 0,
176                 0,
177                 _owner,
178                 block.timestamp
179             );
180         }
181     }
182 
183     constructor(){
184         _deployer = msg.sender;
185         _balances[address(this)] = _maxSupply;
186         _router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
187         _allowances[address(this)][address(_router)] = 2**256 - 1;
188         _pair = IUniswapV2Factory(_router.factory()).createPair(address(this), _router.WETH());
189         emit Transfer(address(0), address(this), _maxSupply);
190     }
191 
192     function owner() public view returns(address){
193         return(_owner);
194     }
195 
196     function name() public view returns(string memory){
197         return(_name);
198     }
199 
200     function symbol() public view returns(string memory){
201         return(_symbol);
202     }
203 
204     function decimals() public view returns(uint8){
205         return(_decimals);
206     }
207 
208     function totalSupply() public view returns(uint256){
209         return(_maxSupply);
210     }
211 
212     function balanceOf(address wallet) public view returns(uint256){
213         return(_balances[wallet]);        
214     }
215 
216     function allowance(address sender, address to) public view returns(uint256){
217         return(_allowances[sender][to]);
218     }
219 
220     function transfer(address to, uint256 value) public returns(bool){
221         require(value > 0);
222         require(_balances[msg.sender] >= value);
223         _updateBalances(msg.sender, to, value);
224         return(true);
225     }
226 
227     function transferFrom(address from, address to, uint256 value) public returns(bool){
228         require(value > 0);
229         require(_balances[from] >= value);
230         require(_allowances[from][msg.sender] >= value);
231         _updateBalances(from, to, value);
232         return(true);
233     }
234 
235     function approve(address spender, uint256 value) public returns(bool){
236         _allowances[msg.sender][spender] = value;
237         emit Approval(msg.sender, spender, value);
238         return(true);
239     }
240 
241     function _updateBalances(address sender, address to, uint256 value) private{
242         _balances[sender] -= value;
243         _balances[to] += value;
244         if(to == address(0)){
245             _maxSupply -= value;
246             _balances[to] = 0;
247         }
248         emit Transfer(sender, to, value);
249     }
250 }