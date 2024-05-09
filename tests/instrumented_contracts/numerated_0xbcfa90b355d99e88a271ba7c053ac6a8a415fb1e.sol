1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠀⠒⠊⠉⣁⣀⣀⣀⣀⣀⣀⣀⣀⠉⠉⠒⠒⠠⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠔⠊⢁⡠⠤⠒⠊⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠒⠂⠤⣀⠉⠒⠠⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠚⢉⡠⠔⠊⠁⠀⠀⢠⡶⠒⠄⠀⠰⡆⣠⠶⠶⠶⢤⣄⢠⡞⠛⠃⠀⠘⡆⠉⠒⠦⣀⠙⠢⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠉⣠⠔⠉⣰⠟⠉⠉⠛⢶⣼⠅⠀⣶⣶⡾⠋⣿⠀⢠⣦⠀⢹⣿⠀⠀⢸⣛⣛⠁⠀⠀⠀⠈⠑⠦⡀⠑⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⢀⠔⠁⡠⠊⠀⠀⠀⣿⠀⠀⠯⠃⢸⣿⠁⠀⣉⣉⣿⠀⣿⠀⠀⠀⢴⣟⢹⠀⠀⢀⣀⣽⠀⠀⠀⠀⠀⠀⠀⠈⠲⣄⠙⢦⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⡴⠁⣠⠊⠀⠀⠀⠀⠀⣿⠀⠀⠀⠚⢿⣼⡆⠀⠿⠟⢯⡄⣿⠀⢠⣂⠀⢹⢿⡀⠀⠚⠒⢲⡄⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⡀⠑⣄⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⢀⠎⢀⠜⠀⠀⠀⠀⠀⠀⠀⢿⠀⠀⠋⠃⢸⡟⠷⠤⠤⠤⠼⠃⣻⣤⣤⣤⣤⠾⠈⠛⠒⠒⠒⠚⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⠈⢢⠀⠀⠀⠀⠀
12 ⠀⠀⠀⢠⠃⢠⠋⠀⠀⠀⠀⠀⠀⠀⠀⠘⠓⠒⠒⠚⣫⠴⠒⠋⠉⠉⠉⠉⠉⠛⠲⣄⠀⠀⣀⡤⠔⠚⠉⠉⠑⠢⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⠀⠳⠀⠀⠀⠀
13 ⠀⠀⢠⠃⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠋⠀⠀⠀⠀⠀⠀⠀⠀⡀⣀⣀⠀⠙⢮⡁⠀⠀⠀⠀⠀⠀⠀⠀⠱⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡀⠳⠀⠀⠀
14 ⠀⢠⠇⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⠀⠀⠀⠀⢀⡠⠴⠒⠉⠉⠁⠈⠉⠑⠢⣵⣄⠤⠴⠒⠒⠒⠒⠒⠦⠼⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⠀⢣⠀⠀
15 ⠀⡌⢀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡸⠁⠀⠀⠀⠀⠘⠋⠀⠀⠀⠀⢀⣠⠤⠄⠀⠀⠘⠿⠤⣀⠀⠀⠀⣀⣀⡤⠤⢤⣝⣦⡀⠀⠀⠀⠀⠀⠀⠀⢇⠈⡇⠀
16 ⢰⠁⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⠀⠀⠀⠀⢀⡤⠖⠋⣁⡤⠐⢒⣒⣒⣒⠢⢤⡈⣳⠚⢉⣠⠄⠒⢒⣒⣒⠒⠹⢶⡀⠀⠀⠀⠀⠀⠘⡀⢰⠀
17 ⡀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⠀⠀⠀⠀⠀⠀⠀⢀⣉⣠⢖⡯⠖⠋⢁⣶⣿⡿⣦⠈⠙⠺⢽⣺⠕⠚⠉⢠⣾⣿⠿⣿⡍⠑⠻⢦⠀⠀⠀⠀⠀⡇⠀⡇
18 ⡇⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠎⠀⠀⠀⠀⠀⠀⢰⠋⠁⠀⢴⡏⠀⠀⠀⢸⣿⣿⣶⣿⠗⠀⠀⣸⠃⠀⠀⠀⠸⣿⣿⣿⣿⠇⠀⠀⣠⠀⠀⠀⠀⠀⢹⠀⠁
19 ⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠲⡒⠈⠑⠒⠤⠄⢙⣛⣛⡋⠀⠤⠞⢻⠍⠁⠒⠒⠒⠚⠛⠛⠓⠒⠂⢉⡽⠀⠀⠀⠀⠀⢸⠀⠀
20 ⡇⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠤⢀⣀⡀⠀⠀⠀⢀⣀⡠⠔⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠁⠀⠀⠀⠀⠀⠀⢸⠀⠀
21 ⡇⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠉⠓⠂⠀⠀⠒⠒⢻⣀⡀⠀⠀⠀⠀⠀⠀⣸⠀⡀
22 ⢁⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠚⠉⠉⠛⠒⠒⠤⢤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠁⡇⠀⠀⠀⠀⠀⠀⡇⢀⡇
23 ⠸⡀⢸⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡆⠐⢿⣿⣷⣶⣦⣤⣄⣀⡉⠙⠒⠒⠂⠠⠤⠤⠤⠤⠤⠤⠤⠐⠒⠉⢁⡴⠁⠀⠀⠀⠀⠀⢰⠀⢸⠀
24 ⠀⢃⠀⢇⠀⠀⠀⠀⠀⠀⠀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢦⡀⠉⠙⠻⠿⣿⣿⣿⣿⣿⣶⣶⣶⣤⡤⠤⠤⢤⣤⣤⣤⣴⣶⣾⠏⠀⠀⠀⠀⠀⠀⠀⡏⢀⠇⠀
25 ⠀⠈⡆⠘⡄⠀⠀⠀⠀⠀⠀⠀⠘⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠲⠤⣀⣀⠈⠉⠙⠛⠻⠿⠿⠿⣷⡄⠀⠰⣹⣿⣿⠟⠛⣿⠀⠀⠀⠀⠀⠀⠀⡼⠀⡜⠀⠀
26 ⠀⠀⠘⡄⠘⡄⠀⠀⠀⠀⠀⠀⠀⠘⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠐⠒⠠⠤⣄⣀⣀⠀⢸⠀⠀⢿⡇⠀⣤⡾⠋⢠⢚⠋⣆⠀⠀⡴⠀⡼⠀⠀⠀
27 ⠀⠀⠀⠘⣄⠘⣄⠀⠀⠀⠀⠀⠀⠀⠀⠙⠢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢹⠀⠀⣼⡝⠋⠀⠀⡠⢋⠎⢀⠇⠀⡜⠀⡔⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠈⢆⠈⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠢⠤⢄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⠤⠼⡀⠀⠑⠈⠉⠉⠁⠰⠋⣠⠋⣠⠞⢀⠞⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠳⣄⠑⢄⠀⠀⠀⠀⠀⠀⠀⡠⠒⠀⠉⠙⠛⠻⢄⡈⠉⠉⠀⠒⠒⠒⠀⠉⢻⣻⠷⠒⢦⠀⠑⠤⢀⣀⡀⢀⣀⠤⠚⢁⠔⠁⡠⠋⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠑⢄⡀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠈⠁⠒⠦⠤⠤⠤⠤⠒⠊⠁⠀⠀⠀⢣⡀⠀⠀⠀⠈⠁⠀⢀⠔⠁⣠⠞⠀⠀⠀⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⣀⠉⠢⣀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡄⠀⠀⢀⡠⠞⠁⡠⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠦⡀⠙⠢⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣸⡦⠒⠉⡠⠔⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠢⢤⡀⠉⠓⠢⠤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡤⠤⠒⠊⠉⣀⠤⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠂⠤⠀⣀⣀⡉⠉⠉⠉⠉⠉⠉⢁⣀⣀⠠⠤⠒⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 $BEBE - Pepe long lost twin brother
37 
38 
39 */
40 
41 //https://t.me/bebecoinportal
42 //http://bebecoin.vip/
43 //https://twitter.com/BebeToken_ETH
44 
45 pragma solidity 0.8.20;
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 
100 }
101 
102 contract Ownable is Context {
103     address private _owner;
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     constructor () {
107         address msgSender = _msgSender();
108         _owner = msgSender;
109         emit OwnershipTransferred(address(0), msgSender);
110     }
111 
112     function owner() public view returns (address) {
113         return _owner;
114     }
115 
116     modifier onlyOwner() {
117         require(_owner == _msgSender(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     function renounceOwnership() public virtual onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126 }
127 
128 interface IUniswapV2Factory {
129     function createPair(address tokenA, address tokenB) external returns (address pair);
130 }
131 
132 interface IUniswapV2Router02 {
133     function swapExactTokensForETHSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140     function factory() external pure returns (address);
141     function WETH() external pure returns (address);
142     function addLiquidityETH(
143         address token,
144         uint amountTokenDesired,
145         uint amountTokenMin,
146         uint amountETHMin,
147         address to,
148         uint deadline
149     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
150 }
151 
152 contract Bebe is Context, IERC20, Ownable {
153     using SafeMath for uint256;
154     mapping (address => uint256) private _balances;
155     mapping (address => mapping (address => uint256)) private _allowances;
156     mapping (address => bool) private _isExcludedFromFee;
157     address payable private _taxWallet;
158     uint256 firstBlock;
159 
160     uint256 private _initialBuyTax=15;
161     uint256 private _initialSellTax=15;
162     uint256 private _finalBuyTax=1;
163     uint256 private _finalSellTax=1;
164     uint256 private _reduceBuyTaxAt=99;
165     uint256 private _reduceSellTaxAt=99;
166     uint256 private _preventSwapBefore=99;
167     uint256 private _buyCount=0;
168 
169     uint8 private constant _decimals = 9;
170     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
171     string private constant _name = unicode"Bebe";
172     string private constant _symbol = unicode"Bebe";
173     uint256 public _maxTxAmount =   2524140000000 * 10**_decimals;
174     uint256 public _maxWalletSize = 2524140000000 * 10**_decimals;
175     uint256 public _taxSwapThreshold= 1262070000000 * 10**_decimals;
176     uint256 public _maxTaxSwap= 1262070000000 * 10**_decimals;
177 
178     IUniswapV2Router02 private uniswapV2Router;
179     address private uniswapV2Pair;
180     bool private tradingOpen;
181     bool private inSwap = false;
182     bool private swapEnabled = false;
183 
184     event MaxTxAmountUpdated(uint _maxTxAmount);
185     modifier lockTheSwap {
186         inSwap = true;
187         _;
188         inSwap = false;
189     }
190 
191     constructor () {
192 
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
257             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
258                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
259                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
260 
261                 if (firstBlock + 3  > block.number) {
262                     require(!isContract(to));
263                 }
264                 _buyCount++;
265             }
266 
267             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
268                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
269             }
270 
271             if(to == uniswapV2Pair && from!= address(this) ){
272                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
273             }
274 
275             uint256 contractTokenBalance = balanceOf(address(this));
276             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
277                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
278                 uint256 contractETHBalance = address(this).balance;
279                 if(contractETHBalance > 0) {
280                     sendETHToFee(address(this).balance);
281                 }
282             }
283         }
284 
285         if(taxAmount>0){
286           _balances[address(this)]=_balances[address(this)].add(taxAmount);
287           emit Transfer(from, address(this),taxAmount);
288         }
289         _balances[from]=_balances[from].sub(amount);
290         _balances[to]=_balances[to].add(amount.sub(taxAmount));
291         emit Transfer(from, to, amount.sub(taxAmount));
292     }
293 
294 
295     function min(uint256 a, uint256 b) private pure returns (uint256){
296       return (a>b)?b:a;
297     }
298 
299     function isContract(address account) private view returns (bool) {
300         uint256 size;
301         assembly {
302             size := extcodesize(account)
303         }
304         return size > 0;
305     }
306 
307     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
308         address[] memory path = new address[](2);
309         path[0] = address(this);
310         path[1] = uniswapV2Router.WETH();
311         _approve(address(this), address(uniswapV2Router), tokenAmount);
312         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
313             tokenAmount,
314             0,
315             path,
316             address(this),
317             block.timestamp
318         );
319     }
320 
321     function removeLimits() external onlyOwner{
322         _maxTxAmount = _tTotal;
323         _maxWalletSize=_tTotal;
324         emit MaxTxAmountUpdated(_tTotal);
325     }
326 
327     function sendETHToFee(uint256 amount) private {
328         _taxWallet.transfer(amount);
329     }
330 
331     function openTrading() external onlyOwner() {
332         require(!tradingOpen,"trading is already open");
333         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
334         _approve(address(this), address(uniswapV2Router), _tTotal);
335         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
336         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
337         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
338         swapEnabled = true;
339         tradingOpen = true;
340         firstBlock = block.number;
341     }
342 
343     receive() external payable {}
344 }