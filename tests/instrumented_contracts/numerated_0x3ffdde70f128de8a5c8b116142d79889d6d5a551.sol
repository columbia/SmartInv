1 /**
2  
3 */
4 
5 /*
6 
7 ⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⣿⣿⣿⣿⣿⣶⣤⣄⣀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣿⣿⣿⣿⣿⡿⠛⣿⣿⡿⢻⣿⡿⠿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⣹⣿⣟⣸⣟⣀⠠⠿⣥⣤⣾⣿⡀⠀⠈⢻⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢻⣿⣿⡋⠀⣠⣴⣾⣿⣯⣁⠈⠻⣷⣤⡀⣉⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢿⣿⣿⡆⠈⠙⠿⣿⠓⠛⠃⠀⢹⡿⢫⠾⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣻⠃⠀⠀⠀⠈⠀⠀⠀⠀⠈⠁⣻⣷⣽⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⡶⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⠏⠌⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⡥⠤⢄⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⠐⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣿⣿⣷⡀⠀⠀⠀⠀⢀⣴⣿⣿⠟⠸⢿⠀⢠⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣧⣀⣀⣠⣶⣿⣿⣿⡏⠀⠀⢸⣴⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⢬⣿⣶⣦⣀⡀⢀⣀⠸⢷⡶⢦⣴⣶⣿⣷⣿⣿⣿⣿⣿⡟⠿⣿⣿⣿⣿⣿⣿⣿⢻⡇⠀⠀⣞⢿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣾⣿⣷⣿⣶⣍⢈⢻⣿⡿⣌⠙⠻⣕⠈⠐⠌⠻⢿⣿⣿⣿⠇⢸⡇⠀⠀⣿⣷⣍⠢⣀⣀⣀⡠⡇⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠰⠾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠷⡈⠳⣄⠈⠳⣤⡀⠀⠀⠙⣿⣿⣆⢸⡇⢀⠀⣿⣿⣿⣷⣌⢆⡑⠤⣌⣉⠁⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⣠⣤⣿⣿⣿⣿⡿⠛⠉⠙⠻⢿⣿⣿⣶⣄⠀⠀⠀⠈⠳⣦⡈⢻⡂⡀⠀⠘⠿⣿⣿⣇⣸⣾⣿⣿⣿⣿⣿⣧⡹⣦⠘⢿⣧⡀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠐⣲⣽⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠈⠉⠙⠛⢷⣤⡀⠀⠀⠀⠘⢿⡄⠹⣮⡢⡀⠀⠈⠻⣿⣿⠉⠉⠉⠉⠙⠻⣿⣷⡸⣧⠈⢤⡑⠌⠙⠓⣾⡀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⣽⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⢛⣿⣠⠀⠀⠀⠈⢷⠀⠸⡟⢌⢀⠀⠀⠈⢿⠋⠁⠀⠀⠀⠀⢼⣿⣇⠹⡄⠀⠙⠂⠸⢝⡋⢿⢆⠀⠀⠀⠀
25 ⠀⠀⢼⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⡀⠀⠀⠀⠀⠀⢉⣿⣿⠀⠀⠀⠀⠈⠀⠀⢳⠀⠣⡠⠀⠀⢀⢳⠀⠀⠀⠀⠀⠀⢹⣿⡄⠷⠀⠀⠀⠀⢠⣵⠈⠎⢆⠀⠀⠀
26 ⠀⠘⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣠⣾⣧⠀⠀⠀⠀⠀⣰⣿⠃⠀⠀⠀⠀⠀⠀⡄⠀⣷⡀⠱⡡⠀⠀⢀⢡⠀⠀⠀⠀⠀⠀⢿⣇⠰⠀⠀⠀⢻⡌⢿⡄⠀⠘⡆⠀⠀
27 ⠀⢀⣴⣿⣿⣿⣿⣿⡿⠻⢿⣿⣿⣿⣿⣦⣤⣀⣤⣾⣿⣯⣤⣤⡀⠀⠀⢀⣤⣷⠀⠸⣷⠀⢣⠱⡀⠀⢃⢣⠄⠀⠀⠀⠀⣸⣿⠀⡇⠀⠀⠀⢻⣾⢷⣄⠀⣷⡀⠀
28 ⣶⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⢀⣿⣿⠇⠀⠀⢿⡇⠘⣧⠰⠀⠀⢂⢧⠀⠀⠀⠙⣿⣿⠀⢸⠀⠀⠀⠀⢿⣿⣿⣇⡿⢷⡀
29 ⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠈⣿⢿⣿⣿⣿⣿⣿⣿⣿⡿⠃⢀⣀⣴⣿⣿⠏⠀⠀⠀⢸⡇⠀⢻⢁⢡⠀⠈⠌⢆⠀⢀⣴⣿⣿⡇⠘⡀⠀⠀⠀⠘⣿⣿⣿⡇⠀⢳
30 ⢠⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⢼⠁⠀⠘⠀⠂⢂⠀⠈⡘⣾⣿⣿⣿⣿⡇⠀⡇⠀⠀⢸⣤⣿⣿⣿⣇⠀⠈
31 ⢸⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⣀⠀⢰⣿⡿⢿⢿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠁⠀⠀⠀⡆⠘⠈⡄⠀⠰⠹⣿⣿⣿⣿⠇⠀⠃⠀⠀⢸⣿⡟⡟⠙⣿⠀⠀
32 ⠀⣿⣿⣿⣿⣿⣷⣠⣶⠀⠀⠰⣿⣤⣿⡿⠁⠀⣾⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠃⠰⠀⠀⢁⢹⣿⣿⣿⠀⠀⢰⣤⣴⣾⣿⡇⢃⠀⠈⠀⠀
33 ⢀⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢀⣿⣿⡿⠁⠀⢰⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⡇⠀⠸⠀⠆⠀⠈⡄⢻⣿⡿⠀⠀⠊⣿⣿⣿⣿⣿⠸⠀⠀⠀⠀
34 ⢸⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢸⣿⣿⠁⠀⡄⣾⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⢀⣴⡇⠀⠀⡇⠀⠀⠃⠘⠀⠀⢰⠸⣿⡇⠀⠀⣤⣿⣿⣿⣿⣿⣧⣇⠀⢀⡀
35 ⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢸⣿⣿⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣄⣀⣠⣴⣿⡿⠀⠀⠀⣷⠀⠀⢸⠀⡆⠀⠀⡆⡿⠀⠀⢸⣿⣿⡿⠋⠉⢿⣿⣿⣶⣾⣇
36 ⢻⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⣿⠀⠀⠀⡆⠡⠀⠀⣱⠇⠀⠀⣾⣿⡇⠀⠀⠀⠈⣿⣿⣿⣿⣿
37 
38 HarryPotterOhtaniStreetFighter2CultInu (XLM)
39 https://www.hposf2ci.xyz
40 https://t.me/hposf2ciXLM
41 https://twitter.com/hposf2ciXLM
42 
43 */
44 
45 // SPDX-License-Identifier: MIT
46 
47 pragma solidity 0.8.20;
48 
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) {
51         return msg.sender;
52     }
53 }
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval (address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 library SafeMath {
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a, "SafeMath: addition overflow");
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         return c;
100     }
101 
102 }
103 
104 contract Ownable is Context {
105     address private _owner;
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     constructor () {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(_owner == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 
128 }
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB) external returns (address pair);
132 }
133 
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142     function factory() external pure returns (address);
143     function WETH() external pure returns (address);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152 }
153 
154 contract HarryPotterOhtaniStreetFighter2CultInu is Context, IERC20, Ownable {
155     using SafeMath for uint256;
156     mapping (address => uint256) private _balances;
157     mapping (address => mapping (address => uint256)) private _allowances;
158     mapping (address => bool) private _isExcludedFromFee;
159     mapping (address => bool) private bots;
160     address payable private _taxWallet;
161     uint256 firstBlock;
162 
163     uint256 private _initialBuyTax=25;
164     uint256 private _initialSellTax=30;
165     uint256 private _finalBuyTax=2;
166     uint256 private _finalSellTax=2;
167     uint256 private _reduceBuyTaxAt=20;
168     uint256 private _reduceSellTaxAt=35;
169     uint256 private _preventSwapBefore=25;
170     uint256 private _buyCount=0;
171 
172     uint8 private constant _decimals = 9;
173     uint256 private constant _tTotal = 1000000 * 10**_decimals;
174     string private constant _name = unicode"HarryPotterOhtaniStreetFighter2CultInu";
175     string private constant _symbol = unicode"XLM";
176     uint256 public _maxTxAmount =   20000 * 10**_decimals;
177     uint256 public _maxWalletSize = 20000 * 10**_decimals;
178     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
179     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
180 
181     IUniswapV2Router02 private uniswapV2Router;
182     address private uniswapV2Pair;
183     bool private tradingOpen;
184     bool private inSwap = false;
185     bool private swapEnabled = false;
186 
187     event MaxTxAmountUpdated(uint _maxTxAmount);
188     modifier lockTheSwap {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193 
194     constructor () {
195 
196         _taxWallet = payable(_msgSender());
197         _balances[_msgSender()] = _tTotal;
198         _isExcludedFromFee[owner()] = true;
199         _isExcludedFromFee[address(this)] = true;
200         _isExcludedFromFee[_taxWallet] = true;
201 
202         emit Transfer(address(0), _msgSender(), _tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216 
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220 
221     function balanceOf(address account) public view override returns (uint256) {
222         return _balances[account];
223     }
224 
225     function transfer(address recipient, uint256 amount) public override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     function allowance(address owner, address spender) public view override returns (uint256) {
231         return _allowances[owner][spender];
232     }
233 
234     function approve(address spender, uint256 amount) public override returns (bool) {
235         _approve(_msgSender(), spender, amount);
236         return true;
237     }
238 
239     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
240         _transfer(sender, recipient, amount);
241         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
242         return true;
243     }
244 
245     function _approve(address owner, address spender, uint256 amount) private {
246         require(owner != address(0), "ERC20: approve from the zero address");
247         require(spender != address(0), "ERC20: approve to the zero address");
248         _allowances[owner][spender] = amount;
249         emit Approval(owner, spender, amount);
250     }
251 
252     function _transfer(address from, address to, uint256 amount) private {
253         require(from != address(0), "ERC20: transfer from the zero address");
254         require(to != address(0), "ERC20: transfer to the zero address");
255         require(amount > 0, "Transfer amount must be greater than zero");
256         uint256 taxAmount=0;
257         if (from != owner() && to != owner()) {
258             require(!bots[from] && !bots[to]);
259             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
260 
261             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
262                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
263                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
264 
265                 if (firstBlock + 3  > block.number) {
266                     require(!isContract(to));
267                 }
268                 _buyCount++;
269             }
270 
271             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
272                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
273             }
274 
275             if(to == uniswapV2Pair && from!= address(this) ){
276                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
277             }
278 
279             uint256 contractTokenBalance = balanceOf(address(this));
280             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
281                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
282                 uint256 contractETHBalance = address(this).balance;
283                 if(contractETHBalance > 0) {
284                     sendETHToFee(address(this).balance);
285                 }
286             }
287         }
288 
289         if(taxAmount>0){
290           _balances[address(this)]=_balances[address(this)].add(taxAmount);
291           emit Transfer(from, address(this),taxAmount);
292         }
293         _balances[from]=_balances[from].sub(amount);
294         _balances[to]=_balances[to].add(amount.sub(taxAmount));
295         emit Transfer(from, to, amount.sub(taxAmount));
296     }
297 
298 
299     function min(uint256 a, uint256 b) private pure returns (uint256){
300       return (a>b)?b:a;
301     }
302 
303     function isContract(address account) private view returns (bool) {
304         uint256 size;
305         assembly {
306             size := extcodesize(account)
307         }
308         return size > 0;
309     }
310 
311     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
312         address[] memory path = new address[](2);
313         path[0] = address(this);
314         path[1] = uniswapV2Router.WETH();
315         _approve(address(this), address(uniswapV2Router), tokenAmount);
316         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
317             tokenAmount,
318             0,
319             path,
320             address(this),
321             block.timestamp
322         );
323     }
324 
325     function removeLimits() external onlyOwner{
326         _maxTxAmount = _tTotal;
327         _maxWalletSize=_tTotal;
328         emit MaxTxAmountUpdated(_tTotal);
329     }
330 
331     function sendETHToFee(uint256 amount) private {
332         _taxWallet.transfer(amount);
333     }
334 
335     function addBots(address[] memory bots_) public onlyOwner {
336         for (uint i = 0; i < bots_.length; i++) {
337             bots[bots_[i]] = true;
338         }
339     }
340 
341     function delBots(address[] memory notbot) public onlyOwner {
342       for (uint i = 0; i < notbot.length; i++) {
343           bots[notbot[i]] = false;
344       }
345     }
346 
347     function isBot(address a) public view returns (bool){
348       return bots[a];
349     }
350 
351     function openTrading() external onlyOwner() {
352         require(!tradingOpen,"trading is already open");
353         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
354         _approve(address(this), address(uniswapV2Router), _tTotal);
355         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
356         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
357         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
358         swapEnabled = true;
359         tradingOpen = true;
360         firstBlock = block.number;
361     }
362 
363     receive() external payable {}
364 
365 }