1 /*
2 https://t.me/WrappedHPOP8I
3 https://twitter.com/WrappedHPOP8I
4 https://wrappedhpop8i.com
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.20;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 
115 contract WXRP is Context, IERC20, Ownable {
116     using SafeMath for uint256;
117     mapping (address => uint256) private _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) private _isExcludedFromFee;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = true;
122     address payable private _taxWallet;
123 
124     uint256 private _initialBuyTax = 20;
125     uint256 private _initialSellTax = 20;
126     uint256 private _reduceBuyTaxAt = 15;
127     uint256 private _reduceSellTaxAt = 15;
128 
129     uint256 private _initialBuyTax2Time = 10;
130     uint256 private _initialSellTax2Time = 10;
131     uint256 private _reduceBuyTaxAt2Time = 25;
132 
133     uint256 private _finalBuyTax = 1;
134     uint256 private _finalSellTax = 1;
135     
136     uint256 private _preventSwapBefore = 25;
137     uint256 private _buyCount = 0;
138 
139     uint8 private constant _decimals = 9;
140     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
141     string private constant _name = unicode"WrappedHarryPotterObamaPacMan8Inu";
142     string private constant _symbol = unicode"WXRP";
143 
144     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
145     uint256 public _maxWalletSize =  2 * (_tTotal/100);
146     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
147     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154 
155     event MaxTxAmountUpdated(uint _maxTxAmount);
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161 
162     constructor () {
163         _taxWallet = payable(_msgSender());
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_taxWallet] = true;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return _balances[account];
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         uint256 taxAmount=0;
224         if (from != owner() && to != owner()) {
225             taxAmount = amount.mul(_taxBuy()).div(100);
226 
227             if (transferDelayEnabled) {
228                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
229                     require(
230                         _holderLastTransferTimestamp[tx.origin] < block.number,
231                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
232                     );
233                     _holderLastTransferTimestamp[tx.origin] = block.number;
234                 }
235             }
236 
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
238                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240                 _buyCount++;
241                 if (_buyCount > _preventSwapBefore) {
242                     transferDelayEnabled = false;
243                 }
244             }
245 
246             if(to == uniswapV2Pair && from!= address(this) ){
247                 taxAmount = amount.mul(_taxSell()).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
252                 uint256 initialETH = address(this).balance;
253                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
255                 if(ethForTransfer > 0) {
256                     sendETHToFee(ethForTransfer);
257                 }
258             }
259         }
260 
261         if(taxAmount>0){
262           _balances[address(this)]=_balances[address(this)].add(taxAmount);
263           emit Transfer(from, address(this),taxAmount);
264         }
265         _balances[from]=_balances[from].sub(amount);
266         _balances[to]=_balances[to].add(amount.sub(taxAmount));
267         emit Transfer(from, to, amount.sub(taxAmount));
268     }
269 
270     function _taxBuy() private view returns (uint256) {
271         if(_buyCount <= _reduceBuyTaxAt){
272             return _initialBuyTax;
273         }
274         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
275             return _initialBuyTax2Time;
276         }
277          return _finalBuyTax;
278     }
279 
280     function _taxSell() private view returns (uint256) {
281         if(_buyCount <= _reduceBuyTaxAt){
282             return _initialSellTax;
283         }
284         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
285             return _initialSellTax2Time;
286         }
287          return _finalBuyTax;
288     }
289 
290     function min(uint256 a, uint256 b) private pure returns (uint256){
291       return (a>b)?b:a;
292     }
293 
294     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
295         address[] memory path = new address[](2);
296         path[0] = address(this);
297         path[1] = uniswapV2Router.WETH();
298         _approve(address(this), address(uniswapV2Router), tokenAmount);
299         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
300             tokenAmount,
301             0,
302             path,
303             address(this),
304             block.timestamp
305         );
306     }
307 
308     function removeLimits() external onlyOwner{
309         _maxTxAmount = _tTotal;
310         _maxWalletSize=_tTotal;
311         transferDelayEnabled=false;
312         emit MaxTxAmountUpdated(_tTotal);
313     }
314 
315     function sendETHToFee(uint256 amount) private {
316         _taxWallet.transfer(amount);
317     }
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
332     function ManualSwap() external {
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