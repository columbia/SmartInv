1 /*
2 Socials:
3 Telegram: https://t.me/BoysClubErc
4 Twitter: https://twitter.com/BoysClubErc
5 Website: https://boyscluberc.com/
6                             
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.21;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract BOYSCLUB is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping(address => uint256) private _holderLastTransferTimestamp;
123     bool public transferDelayEnabled = true;
124     address payable private _taxWallet;
125 
126     uint256 private _initialBuyTax = 20;  
127     uint256 private _initialSellTax = 20;
128     uint256 private _reduceBuyTaxAt = 15;
129     uint256 private _reduceSellTaxAt = 15;
130 
131     uint256 private _initialBuyTax2Time = 10;
132     uint256 private _initialSellTax2Time = 10;
133     uint256 private _reduceBuyTaxAt2Time = 25;
134 
135     uint256 private _finalBuyTax = 1;
136     uint256 private _finalSellTax = 1;
137     
138     uint256 private _preventSwapBefore = 10;
139     uint256 private _buyCount = 0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
143     string private constant _name = unicode"Boy's Club";
144     string private constant _symbol = unicode"BOYSCLUB";
145 
146     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
147     uint256 public _maxWalletSize =  2 * (_tTotal/100);
148     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
149     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
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
166         _balances[address(this)] = _tTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), address(this), _tTotal);
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
230                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
231                     require(
232                         _holderLastTransferTimestamp[tx.origin] < block.number,
233                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
234                     );
235                     _holderLastTransferTimestamp[tx.origin] = block.number;
236                 }
237             }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242                 _buyCount++;
243                 if (_buyCount > _preventSwapBefore) {
244                     transferDelayEnabled = false;
245                 }
246             }
247 
248             if(to == uniswapV2Pair && from!= address(this) ){
249                 taxAmount = amount.mul(_taxSell()).div(100);
250             }
251 
252             uint256 contractTokenBalance = balanceOf(address(this));
253             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
254                 uint256 initialETH = address(this).balance;
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
257                 if(ethForTransfer > 0) {
258                     sendETHToFee(ethForTransfer);
259                 }
260             }
261         }
262 
263         if(taxAmount>0){
264           _balances[address(this)]=_balances[address(this)].add(taxAmount);
265           emit Transfer(from, address(this),taxAmount);
266         }
267         _balances[from]=_balances[from].sub(amount);
268         _balances[to]=_balances[to].add(amount.sub(taxAmount));
269         emit Transfer(from, to, amount.sub(taxAmount));
270     }
271 
272     function _taxBuy() private view returns (uint256) {
273         if(_buyCount <= _reduceBuyTaxAt){
274             return _initialBuyTax;
275         }
276         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
277             return _initialBuyTax2Time;
278         }
279          return _finalBuyTax;
280     }
281 
282     function _taxSell() private view returns (uint256) {
283         if(_buyCount <= _reduceBuyTaxAt){
284             return _initialSellTax;
285         }
286         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
287             return _initialSellTax2Time;
288         }
289          return _finalBuyTax;
290     }
291 
292     function min(uint256 a, uint256 b) private pure returns (uint256){
293       return (a>b)?b:a;
294     }
295 
296     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = uniswapV2Router.WETH();
300         _approve(address(this), address(uniswapV2Router), tokenAmount);
301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp
307         );
308     }
309 
310     function removeLimits() external onlyOwner{
311         _maxTxAmount = _tTotal;
312         _maxWalletSize=_tTotal;
313         transferDelayEnabled=false;
314         emit MaxTxAmountUpdated(_tTotal);
315     }
316 
317     function sendETHToFee(uint256 amount) private {
318         _taxWallet.transfer(amount);
319     }
320 
321     function openTrading() external onlyOwner() {
322         require(!tradingOpen,"trading is already open");
323         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324         _approve(address(this), address(uniswapV2Router), _tTotal);
325         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)),0, 0, owner(), block.timestamp);
327         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
328         swapEnabled = true;
329         tradingOpen = true;
330     }
331 
332     receive() external payable {}
333 
334     function ManualSwap() external {
335         require(_msgSender()==_taxWallet);
336         uint256 tokenBalance=balanceOf(address(this));
337         if(tokenBalance>0){
338           swapTokensForEth(tokenBalance);
339         }
340         uint256 ethBalance=address(this).balance;
341         if(ethBalance>0){
342           sendETHToFee(ethBalance);
343         }
344     }
345 }