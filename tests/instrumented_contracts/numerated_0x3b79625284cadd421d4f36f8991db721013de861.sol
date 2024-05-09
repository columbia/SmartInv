1 /*
2 
3 Telegram: https://t.me/BlackXETH
4 Twitter: https://twitter.com/BlackXCoin
5 Website: https://blackxerc20.com
6 
7 */
8 
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.20;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract BLACKX is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping(address => uint256) private _holderLastTransferTimestamp;
124     bool public transferDelayEnabled = true;
125     address payable private _taxWallet;
126     uint256 private _initialBuyTax = 22;
127     uint256 private _initialSellTax = 22;
128     uint256 private _reduceBuyTaxAt = 25;
129 
130     uint256 private _initialBuyTax2Time = 15;
131     uint256 private _initialSellTax2Time = 15;
132     uint256 private _reduceTaxAt2Time = 35;
133 
134     uint256 private _finalBuyTax = 1;
135     uint256 private _finalSellTax = 1;
136     uint256 private _reduceSellTaxAt = 20;
137 
138     uint256 private _preventSwapBefore = 25;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 100_000_000 * 10**_decimals;
143     string private constant _name = unicode"BlackX";
144     string private constant _symbol = unicode"BLACKX";
145 
146     uint256 public _maxTxAmount =  2 * (_tTotal/100);
147     uint256 public _maxWalletSize =  2 * (_tTotal/100);
148     uint256 public _taxSwapThreshold=  1 * (_tTotal/1000);
149     uint256 public _maxTaxSwap=  14 * (_tTotal/1000);
150 
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156 
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         _taxWallet = payable(_msgSender());
166         _balances[_msgSender()] = _tTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         uint256 taxAmount=0;
226         if (from != owner() && to != owner()) {
227             taxAmount = amount.mul(_taxBuy()).div(100);
228 
229             if (transferDelayEnabled) {
230                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
231                       require(
232                           _holderLastTransferTimestamp[tx.origin] <
233                               block.number,
234                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
235                       );
236                       _holderLastTransferTimestamp[tx.origin] = block.number;
237                   }
238               }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 _buyCount++;
244             }
245 
246             if(to == uniswapV2Pair && from!= address(this) ){
247                 taxAmount = amount.mul(_taxSell()).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
252                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
253                 uint256 contractETHBalance = address(this).balance;
254                 if(contractETHBalance > 50000000000000000) {
255                     sendETHToFee(address(this).balance);
256                 }
257             }
258         }
259 
260         if(taxAmount>0){
261           _balances[address(this)]=_balances[address(this)].add(taxAmount);
262           emit Transfer(from, address(this),taxAmount);
263         }
264         _balances[from]=_balances[from].sub(amount);
265         _balances[to]=_balances[to].add(amount.sub(taxAmount));
266         emit Transfer(from, to, amount.sub(taxAmount));
267     }
268 
269     function _taxBuy() private view returns (uint256) {
270         if(_buyCount <= _reduceBuyTaxAt){
271             return _initialBuyTax;
272         }
273         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceTaxAt2Time){
274             return _initialBuyTax2Time;
275         }
276          return _finalBuyTax;
277     }
278 
279     function _taxSell() private view returns (uint256) {
280         if(_buyCount <= _reduceBuyTaxAt){
281             return _initialSellTax;
282         }
283         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceTaxAt2Time){
284             return _initialSellTax2Time;
285         }
286          return _finalSellTax;
287     }
288 
289     function min(uint256 a, uint256 b) private pure returns (uint256){
290       return (a>b)?b:a;
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
310         transferDelayEnabled=false;
311         emit MaxTxAmountUpdated(_tTotal);
312     }
313 
314     function sendETHToFee(uint256 amount) private {
315         _taxWallet.transfer(amount);
316     }
317 
318 
319     function openTrading() external onlyOwner() {
320         require(!tradingOpen,"trading is already open");
321         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
322         _approve(address(this), address(uniswapV2Router), _tTotal);
323         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
324         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
325         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
326         swapEnabled = true;
327         tradingOpen = true;
328     }
329 
330     receive() external payable {}
331 
332     function manualSwap() external {
333         require(_msgSender()==_taxWallet);
334         uint256 tokenBalance=balanceOf(address(this));
335         if(tokenBalance>0){
336           swapTokensForEth(tokenBalance);
337         }
338         uint256 ethBalance=address(this).balance;
339         if(ethBalance>0){
340           sendETHToFee(ethBalance);
341         }
342     }
343 }