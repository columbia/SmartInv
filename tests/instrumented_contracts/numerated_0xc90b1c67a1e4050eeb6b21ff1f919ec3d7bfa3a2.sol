1 /*
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⡄⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣤⣤⣤⣤⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⢰⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡇⠀⠀⠀⢀⣤⡶⠟⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠶⣤⣀⠀⠀⠀⠈⣿⣿⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⢿⠀⢀⣠⡶⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠷⣤⡀⠀⣿⣿⣄⢻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣻⣿⣇⠸⣴⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⣿⣿⣿⣧⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⢋⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⢙⣿⣿⡎⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡏⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣷⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⣿⣿⢹⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡿⢻⣿⣴⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⣿⣿⠈⢿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠃⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢹⣿⠀⠈⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠇⠀⢸⣿⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠸⣿⡄⠀⠈⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠋⠀⠀⣾⡇⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡆⠀⢿⣷⠀⠀⠈⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠃⠀⠀⣸⣿⠁⢀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠈⣿⣧⠀⠀⠀⠻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡿⠁⠀⠀⣰⣿⠃⠀⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣧⠀⠘⢿⣧⡀⠀⠀⠙⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⣿⠏⠀⠀⠀⣰⣿⠃⠀⣼⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣧⠀⠈⢻⣷⡀⠀⠀⠀⠙⢿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⠟⠁⠀⠀⠀⣼⡿⠁⠀⣼⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣧⠀⠀⠹⣿⣆⠀⠀⠀⠀⠈⠛⠿⣶⣤⣄⣀⣀⣀⣠⣤⣴⣿⠟⠋⠀⠀⠀⠀⢠⣾⠟⠀⠀⣴⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣷⣄⡀⠈⠻⣷⣄⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⠛⠋⠉⠁⠀⠀⠀⠀⠀⣀⣴⡿⠃⠀⢠⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠈⠻⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⡟⠁⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡏⠙⣿⣿⣿⢿⣦⣀⠈⠙⠿⢿⣶⣦⣤⣀⣀⣀⣀⣀⣠⣤⣶⣿⠿⠛⠁⢀⣤⡶⢛⣿⣿⠟⢻⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡇⠀⠈⠻⣿⣧⣝⠻⣷⣦⣄⠀⠈⠉⠙⠛⠛⠛⠛⠛⠛⠉⠁⠀⣀⣤⣾⡿⢋⣴⣿⡿⠁⠀⢸⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡇⠀⠀⠀⠈⠻⣿⣷⣦⣉⣿⣿⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⢶⣿⣿⣯⣥⣾⣿⠿⠋⠀⠀⠀⢸⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡇⠀⠀⠀⠀⠀⠀⠀⣤⣾⣿⣿⣿⣿⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⢀⣤⣶⣶⣾⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⡏⠉⠛⠿⠿⠿⣶⣶⣦⣄⠀
26 ⣴⣿⠟⠋⠁⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⢹⣿⣿⣿⣿⣦⡁⢤⡀⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⣠⣾⣿⣿⣿⡏⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠉⢿⣧
27 ⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣦⡺⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⢀⣴⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛
28 ⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⢸⣿⣿⣿⣿⠻⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣷⣿⣿⣿⠟⣿⣿⣿⣿⡇⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 ⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⢸⣿⣿⣿⣿⠀⠈⠻⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⠟⠁⠀⣿⣿⣿⣿⡇⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡇⢸⣿⣿⣿⣿⠀⠀⠀⠈⠹⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⠀⣿⣿⣿⣿⡇⢸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
31 ⣠⣄⣀⣀⣀⣀⣀⣀⣀⣀⣸⣿⣿⣿⣿⣾⣿⣿⣿⣿⣄⣀⣀⣀⣀⣹⣷⣄⣀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣟⣁⣀⣀⣀⣀⣿⣿⣿⣿⣷⣿⣿⣿⣿⣇⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀
32 ⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⣿⣿⣿⠛⠛⢻⣿⣿⡟⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⢻⣿⣿⡟⠛⠛⣿⣿⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⡟⠀⠀⠘⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⠃⠀⠀⢻⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 
35 
36 
37 Telegram: https://t.me/PredatorSniperBoterc
38 Twitter: https://twitter.com/predator_sniper
39 Website: http://www.predatorsp.com
40 Sniper Bot: @PredatorSniperBot
41 */
42 
43 // SPDX-License-Identifier: MIT
44 pragma solidity 0.8.20;
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 }
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 library SafeMath {
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77         return c;
78     }
79 
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         if (a == 0) {
82             return 0;
83         }
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86         return c;
87     }
88 
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         return c;
97     }
98 
99 }
100 
101 contract Ownable is Context {
102     address private _owner;
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     constructor () {
106         address msgSender = _msgSender();
107         _owner = msgSender;
108         emit OwnershipTransferred(address(0), msgSender);
109     }
110 
111     function owner() public view returns (address) {
112         return _owner;
113     }
114 
115     modifier onlyOwner() {
116         require(_owner == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     function renounceOwnership() public virtual onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 
125 }
126 
127 interface IUniswapV2Factory {
128     function createPair(address tokenA, address tokenB) external returns (address pair);
129 }
130 
131 interface IUniswapV2Router02 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139     function factory() external pure returns (address);
140     function WETH() external pure returns (address);
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
149 }
150 
151 contract PRESBOT is Context, IERC20, Ownable {
152     using SafeMath for uint256;
153     mapping (address => uint256) private _balances;
154     mapping (address => mapping (address => uint256)) private _allowances;
155     mapping (address => bool) private _isExcludedFromFee;
156     mapping (address => bool) private bots;
157     mapping(address => uint256) private _holderLastTransferTimestamp;
158     bool public transferDelayEnabled = true;
159     address payable private _taxWallet;
160 
161     uint256 private _initialBuyTax=20;
162     uint256 private _initialSellTax=20;
163     uint256 private _finalBuyTax=3;
164     uint256 private _finalSellTax=3;
165     uint256 private _reduceBuyTaxAt=25;
166     uint256 private _reduceSellTaxAt=25;
167     uint256 private _preventSwapBefore=25;
168     uint256 private _buyCount=0;
169 
170     uint8 private constant _decimals = 9;
171     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
172     string private constant _name = unicode"Predator Sniper Bot";
173     string private constant _symbol = unicode"$PRESBOT";
174     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
175     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
176     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
177     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
178 
179     IUniswapV2Router02 private uniswapV2Router;
180     address private uniswapV2Pair;
181     bool private tradingOpen;
182     bool private inSwap = false;
183     bool private swapEnabled = false;
184 
185     event MaxTxAmountUpdated(uint _maxTxAmount);
186     modifier lockTheSwap {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192     constructor () {
193         _taxWallet = payable(_msgSender());
194         _balances[_msgSender()] = _tTotal;
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[_taxWallet] = true;
198 
199         emit Transfer(address(0), _msgSender(), _tTotal);
200     }
201 
202     function name() public pure returns (string memory) {
203         return _name;
204     }
205 
206     function symbol() public pure returns (string memory) {
207         return _symbol;
208     }
209 
210     function decimals() public pure returns (uint8) {
211         return _decimals;
212     }
213 
214     function totalSupply() public pure override returns (uint256) {
215         return _tTotal;
216     }
217 
218     function balanceOf(address account) public view override returns (uint256) {
219         return _balances[account];
220     }
221 
222     function transfer(address recipient, uint256 amount) public override returns (bool) {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     function allowance(address owner, address spender) public view override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     function approve(address spender, uint256 amount) public override returns (bool) {
232         _approve(_msgSender(), spender, amount);
233         return true;
234     }
235 
236     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
237         _transfer(sender, recipient, amount);
238         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
239         return true;
240     }
241 
242     function _approve(address owner, address spender, uint256 amount) private {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245         _allowances[owner][spender] = amount;
246         emit Approval(owner, spender, amount);
247     }
248 
249     function _transfer(address from, address to, uint256 amount) private {
250         require(from != address(0), "ERC20: transfer from the zero address");
251         require(to != address(0), "ERC20: transfer to the zero address");
252         require(amount > 0, "Transfer amount must be greater than zero");
253         uint256 taxAmount=0;
254         if (from != owner() && to != owner()) {
255             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
256 
257             if (transferDelayEnabled) {
258                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
259                       require(
260                           _holderLastTransferTimestamp[tx.origin] <
261                               block.number,
262                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
263                       );
264                       _holderLastTransferTimestamp[tx.origin] = block.number;
265                   }
266               }
267 
268             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
269                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
270                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
271                 _buyCount++;
272             }
273 
274             if(to == uniswapV2Pair && from!= address(this) ){
275                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
276             }
277 
278             uint256 contractTokenBalance = balanceOf(address(this));
279             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
280                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
281                 uint256 contractETHBalance = address(this).balance;
282                 if(contractETHBalance > 50000000000000000) {
283                     sendETHToFee(address(this).balance);
284                 }
285             }
286         }
287 
288         if(taxAmount>0){
289           _balances[address(this)]=_balances[address(this)].add(taxAmount);
290           emit Transfer(from, address(this),taxAmount);
291         }
292         _balances[from]=_balances[from].sub(amount);
293         _balances[to]=_balances[to].add(amount.sub(taxAmount));
294         emit Transfer(from, to, amount.sub(taxAmount));
295     }
296 
297 
298     function min(uint256 a, uint256 b) private pure returns (uint256){
299       return (a>b)?b:a;
300     }
301 
302     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
303         address[] memory path = new address[](2);
304         path[0] = address(this);
305         path[1] = uniswapV2Router.WETH();
306         _approve(address(this), address(uniswapV2Router), tokenAmount);
307         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
308             tokenAmount,
309             0,
310             path,
311             address(this),
312             block.timestamp
313         );
314     }
315 
316     function removeLimits() external onlyOwner{
317         _maxTxAmount = _tTotal;
318         _maxWalletSize=_tTotal;
319         transferDelayEnabled=false;
320         emit MaxTxAmountUpdated(_tTotal);
321     }
322 
323     function sendETHToFee(uint256 amount) private {
324         _taxWallet.transfer(amount);
325     }
326 
327 
328     function openTrading() external onlyOwner() {
329         require(!tradingOpen,"trading is already open");
330         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
331         _approve(address(this), address(uniswapV2Router), _tTotal);
332         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
333         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
334         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
335         swapEnabled = true;
336         tradingOpen = true;
337     }
338 
339     receive() external payable {}
340 
341     function manualSwap() external {
342         require(_msgSender()==_taxWallet);
343         uint256 tokenBalance=balanceOf(address(this));
344         if(tokenBalance>0){
345           swapTokensForEth(tokenBalance);
346         }
347         uint256 ethBalance=address(this).balance;
348         if(ethBalance>0){
349           sendETHToFee(ethBalance);
350         }
351     }
352 }