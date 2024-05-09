1 /**
2 
3 ⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
4 ⣿⣷⣦⣄⣉⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
5 ⣿⡇⠀⠈⠙⠛⠷⣦⣤⣉⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
6 ⣿⣷⣦⣄⣀⠀⠀⠀⠈⠙⠻⢶⣤⣄⡉⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
7 ⣿⣿⣿⣿⣿⣿⣶⣦⣄⡀⠀⠀⠀⠉⠛⠋⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
8 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠶⠀⣀⣴⣾⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
9 ⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⢁⣤⣾⣿⣿⠟⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
10 ⣿⣿⣿⣿⣿⣿⠟⢁⣠⣾⣿⣿⠟⠋⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
11 ⣿⣿⣿⣿⣿⣿⣤⣄⡈⠙⠋⠁⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
12 ⣿⣿⣿⣿⣿⣿⠀⠉⠛⠛⠶⣦⣤⣈⠉⠛⠿⢿⣿⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿
13 ⣿⣿⣿⣿⣿⣿⣶⣤⣄⡀⠀⠀⠈⠙⠛⠷⣦⣤⣈⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿
14 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠈⠙⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿
15 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿
16 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢀⣀⣀⣤⣤⣴⣾⣿
17 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
18 
19 HarryPotterObamaPepe11Inu $TRON
20 
21 https://twitter.com/HPOP11i
22 https://t.me/HPOP11i
23 https://www.hpop11i.com/
24 https://www.instagram.com/hpop11i/
25 
26 
27 // SPDX-License-Identifier: MIT
28 
29 */
30 
31 
32 pragma solidity 0.8.20;
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 }
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         return c;
85     }
86 
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB) external returns (address pair);
117 }
118 
119 interface IUniswapV2Router02 {
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127     function factory() external pure returns (address);
128     function WETH() external pure returns (address);
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 }
138 
139 contract HPOP11i is Context, IERC20, Ownable {
140     using SafeMath for uint256;
141     mapping (address => uint256) private _balances;
142     mapping (address => mapping (address => uint256)) private _allowances;
143     mapping (address => bool) private _isExcludedFromFee;
144     address payable private _taxWallet;
145     uint256 firstBlock;
146 
147     uint256 private _initialBuyTax=15;
148     uint256 private _initialSellTax=30;
149     uint256 private _finalBuyTax=2;
150     uint256 private _finalSellTax=2;
151     uint256 private _reduceBuyTaxAt=30;
152     uint256 private _reduceSellTaxAt=35;
153     uint256 private _buyCount=0;
154 
155     uint8 private constant _decimals = 9;
156     uint256 private constant _tTotal = 100000000 * 10**_decimals;
157     string private constant _name = unicode"HarryPotterObamaPepe11Inu";
158     string private constant _symbol = unicode"TRON";
159     uint256 public _maxTxAmount =   1000000 * 10**_decimals;
160     uint256 public _maxWalletSize = 1000000 * 10**_decimals;
161     uint256 public _taxSwapThreshold= 250000 * 10**_decimals;
162     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
163 
164     IUniswapV2Router02 private uniswapV2Router;
165     address private uniswapV2Pair;
166     bool private tradingOpen;
167     bool private inSwap = false;
168     bool private swapEnabled = false;
169 
170     event MaxTxAmountUpdated(uint _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176 
177     constructor () {
178 
179         _taxWallet = payable(_msgSender());
180         _balances[_msgSender()] = _tTotal;
181         _isExcludedFromFee[owner()] = true;
182         _isExcludedFromFee[address(this)] = true;
183         _isExcludedFromFee[_taxWallet] = true;
184         
185         emit Transfer(address(0), _msgSender(), _tTotal);
186     }
187 
188     function name() public pure returns (string memory) {
189         return _name;
190     }
191 
192     function symbol() public pure returns (string memory) {
193         return _symbol;
194     }
195 
196     function decimals() public pure returns (uint8) {
197         return _decimals;
198     }
199 
200     function totalSupply() public pure override returns (uint256) {
201         return _tTotal;
202     }
203 
204     function balanceOf(address account) public view override returns (uint256) {
205         return _balances[account];
206     }
207 
208     function transfer(address recipient, uint256 amount) public override returns (bool) {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212 
213     function allowance(address owner, address spender) public view override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     function _transfer(address from, address to, uint256 amount) private {
236         require(from != address(0), "ERC20: transfer from the zero address");
237         require(to != address(0), "ERC20: transfer to the zero address");
238         require(amount > 0, "Transfer amount must be greater than zero");
239         uint256 taxAmount=0;
240         if (from != owner() && to != owner()) {
241             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246 
247                 if (firstBlock + 3  > block.number) {
248                     require(!isContract(to));
249                 }
250                 _buyCount++;
251             }
252 
253             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
254                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
255             }
256 
257             if(to == uniswapV2Pair && from!= address(this) ){
258                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
259             }
260 
261             uint256 contractTokenBalance = balanceOf(address(this));
262             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
263                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
264                 uint256 contractETHBalance = address(this).balance;
265                 if(contractETHBalance > 0) {
266                     sendETHToFee(address(this).balance);
267                 }
268             }
269         }
270 
271         if(taxAmount>0){
272           _balances[address(this)]=_balances[address(this)].add(taxAmount);
273           emit Transfer(from, address(this),taxAmount);
274         }
275         _balances[from]=_balances[from].sub(amount);
276         _balances[to]=_balances[to].add(amount.sub(taxAmount));
277         emit Transfer(from, to, amount.sub(taxAmount));
278     }
279 
280 
281     function min(uint256 a, uint256 b) private pure returns (uint256){
282       return (a>b)?b:a;
283     }
284 
285     function isContract(address account) private view returns (bool) {
286         uint256 size;
287         assembly {
288             size := extcodesize(account)
289         }
290         return size > 0;
291     }
292 
293     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = uniswapV2Router.WETH();
297         _approve(address(this), address(uniswapV2Router), tokenAmount);
298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp
304         );
305     }
306 
307     function removeLimits() external onlyOwner{
308         _maxTxAmount = _tTotal;
309         _maxWalletSize=_tTotal;
310         emit MaxTxAmountUpdated(_tTotal);
311     }
312 
313     function sendETHToFee(uint256 amount) private {
314         _taxWallet.transfer(amount);
315     }
316 
317     function openTrading() external onlyOwner() {
318         require(!tradingOpen,"trading is already open");
319         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
320         _approve(address(this), address(uniswapV2Router), _tTotal);
321         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
322         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
323         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
324         swapEnabled = true;
325         tradingOpen = true;
326         firstBlock = block.number;
327     }
328 
329     receive() external payable {}
330 }