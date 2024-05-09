1 // SPDX-License-Identifier: MIT
2 
3 /**
4 🐸 $1PEPE Official Links 🐸
5 
6 telegram: https://t.me/Pepe1Erc
7 
8 **/
9 pragma solidity 0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract The1Pepe is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     address payable _taxWallet = payable(0xf42A8bF807B09930a1b2305d766Dc47C81389403);
122 
123     uint256 private _initialBuyTax=50;
124     uint256 private _initialSellTax=25;
125     uint256 public _finalBuyTax=0;
126     uint256 public _finalSellTax=0;
127     uint256 private _reduceBuyTaxAt=10;
128     uint256 private _reduceSellTaxAt=10;
129     uint256 private _preventSwapBefore=20;
130     uint256 public _buyCount=0;
131 
132     uint8 private constant _decimals = 18;
133     uint256 private constant _tTotal = 1 * 10**_decimals;
134     string private constant _name = "1Pepe";
135     string private constant _symbol = "1Pepe";
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address public uniswapV2Pair;
139     bool private tradingOpen;
140 
141     constructor () {
142         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
143         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
144             .createPair(address(this), _uniswapV2Router.WETH());
145         uniswapV2Router = _uniswapV2Router;
146 
147         _balances[_msgSender()] = _tTotal;
148         _isExcludedFromFee[owner()] = true;
149         _isExcludedFromFee[address(this)] = true;
150         _isExcludedFromFee[_taxWallet] = true;
151 
152         emit Transfer(address(0), _msgSender(), _tTotal);
153     }
154 
155     function name() public pure returns (string memory) {
156         return _name;
157     }
158 
159     function symbol() public pure returns (string memory) {
160         return _symbol;
161     }
162 
163     function decimals() public pure returns (uint8) {
164         return _decimals;
165     }
166 
167     function totalSupply() public pure override returns (uint256) {
168         return _tTotal;
169     }
170 
171     function balanceOf(address account) public view override returns (uint256) {
172         return _balances[account];
173     }
174 
175     function transfer(address recipient, uint256 amount) public override returns (bool) {
176         _transfer(_msgSender(), recipient, amount);
177         return true;
178     }
179 
180     function allowance(address owner, address spender) public view override returns (uint256) {
181         return _allowances[owner][spender];
182     }
183 
184     function approve(address spender, uint256 amount) public override returns (bool) {
185         _approve(_msgSender(), spender, amount);
186         return true;
187     }
188 
189     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
190         _transfer(sender, recipient, amount);
191         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
192         return true;
193     }
194 
195     function setfinalbuytax(uint256 finalbuytax) external onlyOwner() {
196         _finalBuyTax = finalbuytax;
197         require(_finalBuyTax<=10, "less than 10%");
198     }
199 
200     function setfinalselltax(uint256 finalselltax) external onlyOwner() {
201         _finalSellTax = finalselltax;
202         require(_finalSellTax<=10, "less than 10%");
203     }
204 
205     function setTaxWallet(address payable taxWallet) external onlyOwner() {
206         _taxWallet = taxWallet;
207     }
208 
209     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
210         _isExcludedFromFee[account] = newValue;
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224 
225         require(tradingOpen || _isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not open");
226 
227         uint256 taxAmount=0;
228         if (!_isExcludedFromFee[from]&& !_isExcludedFromFee[to]) {
229             if (from == uniswapV2Pair && to != address(uniswapV2Router)  ) {
230                 _buyCount++;
231                 taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
232             }
233 
234             if(to == uniswapV2Pair && from!= address(this)){
235                 _buyCount++;
236                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
237             }
238         }
239 
240         if(taxAmount>0){
241           _balances[_taxWallet]=_balances[_taxWallet].add(taxAmount);
242           emit Transfer(from, _taxWallet,taxAmount);
243         }
244         _balances[from]=_balances[from].sub(amount);
245         _balances[to]=_balances[to].add(amount.sub(taxAmount));
246         emit Transfer(from, to, amount.sub(taxAmount));
247     }
248 
249 
250     function min(uint256 a, uint256 b) private pure returns (uint256){
251       return (a>b)?b:a;
252     }
253 
254     function sendETHToFee(uint256 amount) private {
255         _taxWallet.transfer(amount);
256     }
257 
258     function openTrading() external onlyOwner() {
259         require(!tradingOpen,"trading is already open");
260         tradingOpen = true;
261     }
262 
263     receive() external payable {}
264 }