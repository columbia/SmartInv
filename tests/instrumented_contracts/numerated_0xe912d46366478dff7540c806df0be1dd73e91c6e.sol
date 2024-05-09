1 /*
2 Telegram: https://t.me/hposaga10i
3 Twitter: https://twitter.com/hposaga10i
4 Web: https://Hposaga10i.xyz
5                             
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.21;
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
116 contract XRPSAGA is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping(address => uint256) private _holderLastTransferTimestamp;
122     bool public transferDelayEnabled = true;
123     address payable private _taxWallet;
124 
125     uint256 private _initialBuyTax = 20;  
126     uint256 private _initialSellTax = 20;
127     uint256 private _reduceBuyTaxAt = 15;
128     uint256 private _reduceSellTaxAt = 15;
129 
130     uint256 private _initialBuyTax2Time = 10;
131     uint256 private _initialSellTax2Time = 10;
132     uint256 private _reduceBuyTaxAt2Time = 25;
133 
134     uint256 private _finalBuyTax = 1;
135     uint256 private _finalSellTax = 1;
136     
137     uint256 private _preventSwapBefore = 10;
138     uint256 private _buyCount = 0;
139 
140     uint8 private constant _decimals = 9;
141     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
142     string private constant _name = unicode"HarryPotterObamaSaga10Inu";
143     string private constant _symbol = unicode"XRPSAGA";
144 
145     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
146     uint256 public _maxWalletSize =  2 * (_tTotal/100);
147     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
148     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _balances[address(this)] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169 
170         emit Transfer(address(0), address(this), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return _balances[account];
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
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
224         uint256 taxAmount=0;
225         if (from != owner() && to != owner()) {
226             taxAmount = amount.mul(_taxBuy()).div(100);
227 
228             if (transferDelayEnabled) {
229                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
230                     require(
231                         _holderLastTransferTimestamp[tx.origin] < block.number,
232                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
233                     );
234                     _holderLastTransferTimestamp[tx.origin] = block.number;
235                 }
236             }
237 
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241                 _buyCount++;
242                 if (_buyCount > _preventSwapBefore) {
243                     transferDelayEnabled = false;
244                 }
245             }
246 
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 taxAmount = amount.mul(_taxSell()).div(100);
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
253                 uint256 initialETH = address(this).balance;
254                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
255                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
256                 if(ethForTransfer > 0) {
257                     sendETHToFee(ethForTransfer);
258                 }
259             }
260         }
261 
262         if(taxAmount>0){
263           _balances[address(this)]=_balances[address(this)].add(taxAmount);
264           emit Transfer(from, address(this),taxAmount);
265         }
266         _balances[from]=_balances[from].sub(amount);
267         _balances[to]=_balances[to].add(amount.sub(taxAmount));
268         emit Transfer(from, to, amount.sub(taxAmount));
269     }
270 
271     function _taxBuy() private view returns (uint256) {
272         if(_buyCount <= _reduceBuyTaxAt){
273             return _initialBuyTax;
274         }
275         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
276             return _initialBuyTax2Time;
277         }
278          return _finalBuyTax;
279     }
280 
281     function _taxSell() private view returns (uint256) {
282         if(_buyCount <= _reduceBuyTaxAt){
283             return _initialSellTax;
284         }
285         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
286             return _initialSellTax2Time;
287         }
288          return _finalBuyTax;
289     }
290 
291     function min(uint256 a, uint256 b) private pure returns (uint256){
292       return (a>b)?b:a;
293     }
294 
295     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
296         address[] memory path = new address[](2);
297         path[0] = address(this);
298         path[1] = uniswapV2Router.WETH();
299         _approve(address(this), address(uniswapV2Router), tokenAmount);
300         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
301             tokenAmount,
302             0,
303             path,
304             address(this),
305             block.timestamp
306         );
307     }
308 
309     function removeLimits() external onlyOwner{
310         _maxTxAmount = _tTotal;
311         _maxWalletSize=_tTotal;
312         transferDelayEnabled=false;
313         emit MaxTxAmountUpdated(_tTotal);
314     }
315 
316     function sendETHToFee(uint256 amount) private {
317         _taxWallet.transfer(amount);
318     }
319 
320     function openTrading() external onlyOwner() {
321         require(!tradingOpen,"trading is already open");
322         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
323         _approve(address(this), address(uniswapV2Router), _tTotal);
324         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
325         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)),0, 0, owner(), block.timestamp);
326         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
327         swapEnabled = true;
328         tradingOpen = true;
329     }
330 
331     receive() external payable {}
332 
333     function ManualSwap() external {
334         require(_msgSender()==_taxWallet);
335         uint256 tokenBalance=balanceOf(address(this));
336         if(tokenBalance>0){
337           swapTokensForEth(tokenBalance);
338         }
339         uint256 ethBalance=address(this).balance;
340         if(ethBalance>0){
341           sendETHToFee(ethBalance);
342         }
343     }
344 }