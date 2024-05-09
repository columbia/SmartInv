1 /**
2 
3 ⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣤⡀
4 ⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⠿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠿⠛⠉⠉⠉⠙⠿⣿⣿⣿⣦
5 ⠀⠀⠀⢀⣾⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀ ⠻⣿⣿⣦
6 ⠀⠀⢠⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⢻⣿⣿
7 ⠀⠀⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⣿⣿⣿
8 ⠀⣾⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⣿⣿⣿
9 ⠀⣿⣿⡏⠀⣀⣴⣾⣿⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀ ⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿
10 ⢸⣿⣿⣷⣿⣿⠿⠛⠋⠉⠉⠛⢿⣿⣿⣿   ⠀⠀⠀⠀⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿
11 ⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⡄⠀⠀⠀⠀⠀⠈⣿⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿
12 ⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣶⣤⣤⣤⣴⣾⣿⡿⢛⣿⣿
13 ⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⠿⣿⣿⡿⠿⠛⠁⠀⣸⣿⣿
14 ⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡿
15 ⢹⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿
16 ⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠃
17 ⠀⠻⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣶⣿⣿⡿
18 ⠀⠀⠙⣿⣿⣿⣷⣦⣤⣤⣤⣶⣿⣿⣿⡿  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣤⣤⣶⣿⣿⣿⣿
19 ⠀⠀⠀⠀⠙⠿⢿⣿⣿⣿⣿⣿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⠿⠿⠋
20 
21 https://t.me/PEPE0x696969
22 https://twitter.com/PEPE696969_
23 https://pepe69.rent/
24 
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 */
27 
28 // SPDX-License-Identifier: MIT
29 
30 
31 pragma solidity 0.8.20;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IUniswapV2Router02 {
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 }
137 
138 contract PEPE is Context, IERC20, Ownable {
139     using SafeMath for uint256;
140     mapping (address => uint256) private _balances;
141     mapping (address => mapping (address => uint256)) private _allowances;
142     mapping (address => bool) private _isExcludedFromFee;
143     mapping (address => bool) private bots;
144     mapping(address => uint256) private _holderLastTransferTimestamp;
145     bool public transferDelayEnabled = true;
146     address payable private _taxWallet;
147 
148     uint256 private _initialBuyTax=22;
149     uint256 private _initialSellTax=22;
150     uint256 private _finalBuyTax=1;
151     uint256 private _finalSellTax=1;
152     uint256 private _reduceBuyTaxAt=30;
153     uint256 private _reduceSellTaxAt=30;
154     uint256 private _preventSwapBefore=32;
155     uint256 private _buyCount=0;
156 
157     uint8 private constant _decimals = 9;
158     uint256 private constant _tTotal = 69696969696969 * 10**_decimals;
159     string private constant _name = unicode"0x69 $pepe";
160     string private constant _symbol = unicode"PEPE69";
161     uint256 public _maxTxAmount = 480909090909 * 10**_decimals;
162     uint256 public _maxWalletSize = 480909090909 * 10**_decimals;
163     uint256 public _taxSwapThreshold= 34090909090 * 10**_decimals;
164     uint256 public _maxTaxSwap= 580909090909 * 10**_decimals;
165 
166     IUniswapV2Router02 private uniswapV2Router;
167     address private uniswapV2Pair;
168     bool private tradingOpen;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
171 
172     event MaxTxAmountUpdated(uint _maxTxAmount);
173     modifier lockTheSwap {
174         inSwap = true;
175         _;
176         inSwap = false;
177     }
178 
179     constructor () {
180         _taxWallet = payable(_msgSender());
181         _balances[_msgSender()] = _tTotal;
182         _isExcludedFromFee[owner()] = true;
183         _isExcludedFromFee[address(this)] = true;
184         _isExcludedFromFee[_taxWallet] = true;
185 
186         emit Transfer(address(0), _msgSender(), _tTotal);
187     }
188 
189     function name() public pure returns (string memory) {
190         return _name;
191     }
192 
193     function symbol() public pure returns (string memory) {
194         return _symbol;
195     }
196 
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200 
201     function totalSupply() public pure override returns (uint256) {
202         return _tTotal;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(address owner, address spender) public view override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240         uint256 taxAmount=0;
241         if (from != owner() && to != owner()) {
242             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
243 
244             if (transferDelayEnabled) {
245                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
246                       require(
247                           _holderLastTransferTimestamp[tx.origin] <
248                               block.number,
249                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
250                       );
251                       _holderLastTransferTimestamp[tx.origin] = block.number;
252                   }
253               }
254 
255             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
256                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
257                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
258                 _buyCount++;
259             }
260 
261             if(to == uniswapV2Pair && from!= address(this) ){
262                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
263             }
264 
265             uint256 contractTokenBalance = balanceOf(address(this));
266             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
267                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
268                 uint256 contractETHBalance = address(this).balance;
269                 if(contractETHBalance > 50000000000000000) {
270                     sendETHToFee(address(this).balance);
271                 }
272             }
273         }
274 
275         if(taxAmount>0){
276           _balances[address(this)]=_balances[address(this)].add(taxAmount);
277           emit Transfer(from, address(this),taxAmount);
278         }
279         _balances[from]=_balances[from].sub(amount);
280         _balances[to]=_balances[to].add(amount.sub(taxAmount));
281         emit Transfer(from, to, amount.sub(taxAmount));
282     }
283 
284 
285     function min(uint256 a, uint256 b) private pure returns (uint256){
286       return (a>b)?b:a;
287     }
288 
289     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function removeLimits() external onlyOwner{
304         _maxTxAmount = _tTotal;
305         _maxWalletSize=_tTotal;
306         transferDelayEnabled=false;
307         emit MaxTxAmountUpdated(_tTotal);
308     }
309 
310     function sendETHToFee(uint256 amount) private {
311         _taxWallet.transfer(amount);
312     }
313 
314 
315     function openTrading() external onlyOwner() {
316         require(!tradingOpen,"trading is already open");
317         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
318         _approve(address(this), address(uniswapV2Router), _tTotal);
319         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
320         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
321         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
322         swapEnabled = true;
323         tradingOpen = true;
324     }
325 
326     receive() external payable {}
327 
328     function manualSwap() external {
329         require(_msgSender()==_taxWallet);
330         uint256 tokenBalance=balanceOf(address(this));
331         if(tokenBalance>0){
332           swapTokensForEth(tokenBalance);
333         }
334         uint256 ethBalance=address(this).balance;
335         if(ethBalance>0){
336           sendETHToFee(ethBalance);
337         }
338     }
339 }