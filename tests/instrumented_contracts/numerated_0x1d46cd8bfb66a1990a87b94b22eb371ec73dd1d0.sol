1 /*
2 INTRODUCING $SPERMY
3 
4 TG: https://t.me/spermyeth
5 
6 Twitter: https://twitter.com/spermyeth?s=21&t=9dSmGorXF-s-QuHhQpI8Pg
7 
8 Website: http://spermy.site/
9 
10 Our Swap Link (Free Utility) spermyswap.tech
11 */
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.20;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract spermyeth is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = true;
128     address payable private _taxWallet;
129 
130     uint256 private _initialBuyTax = 1;
131     uint256 private _initialSellTax = 20;
132     uint256 private _reduceBuyTaxAt = 1;
133 
134     uint256 private _initialBuyTax2Time = 1;
135     uint256 private _initialSellTax2Time = 1;
136     uint256 private _reduceBuyTaxAt2Time = 1;
137 
138     uint256 private _finalBuyTax = 1;
139     uint256 private _finalSellTax = 1;
140     uint256 private _reduceSellTaxAt = 1;
141 
142     uint256 private _preventSwapBefore=10;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 9;
146     uint256 private constant _tTotal = 100000000 * 10**_decimals;
147     string private constant _name = unicode"Spermy";
148     string private constant _symbol = unicode"SPERMY";
149 
150     uint256 public _maxTxAmount =  2 * (_tTotal/100);
151     uint256 public _maxWalletSize =  2 * (_tTotal/100);
152     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
153     uint256 public _maxTaxSwap=  18 * (_tTotal/1000);
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160 
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor () {
169         _taxWallet = payable(0xa88827f487C3898734f8B85397B9DcF2d9972D9e);
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174 
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         uint256 taxAmount=0;
230         if (from != owner() && to != owner()) {
231             taxAmount = amount.mul(_taxBuy()).div(100);
232 
233             if (transferDelayEnabled) {
234                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
235                       require(
236                           _holderLastTransferTimestamp[tx.origin] <
237                               block.number,
238                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
239                       );
240                       _holderLastTransferTimestamp[tx.origin] = block.number;
241                   }
242               }
243 
244             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
247                 _buyCount++;
248             }
249 
250             if(to == uniswapV2Pair && from!= address(this) ){
251                 taxAmount = amount.mul(_taxSell()).div(100);
252             }
253 
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
256                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
257                 uint256 contractETHBalance = address(this).balance;
258                 if(contractETHBalance > 30000000000000000) {
259                     sendETHToFee(address(this).balance);
260                 }
261             }
262         }
263 
264         if(taxAmount>0){
265           _balances[address(this)]=_balances[address(this)].add(taxAmount);
266           emit Transfer(from, address(this),taxAmount);
267         }
268         _balances[from]=_balances[from].sub(amount);
269         _balances[to]=_balances[to].add(amount.sub(taxAmount));
270         emit Transfer(from, to, amount.sub(taxAmount));
271     }
272 
273     function _taxBuy() private view returns (uint256) {
274         if(_buyCount <= _reduceBuyTaxAt){
275             return _initialBuyTax;
276         }
277         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
278             return _initialBuyTax2Time;
279         }
280          return _finalBuyTax;
281     }
282 
283     function _taxSell() private view returns (uint256) {
284         if(_buyCount <= _reduceBuyTaxAt){
285             return _initialSellTax;
286         }
287         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
288             return _initialSellTax2Time;
289         }
290          return _finalBuyTax;
291     }
292 
293     function min(uint256 a, uint256 b) private pure returns (uint256){
294       return (a>b)?b:a;
295     }
296 
297     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
298         address[] memory path = new address[](2);
299         path[0] = address(this);
300         path[1] = uniswapV2Router.WETH();
301         _approve(address(this), address(uniswapV2Router), tokenAmount);
302         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
303             tokenAmount,
304             0,
305             path,
306             address(this),
307             block.timestamp
308         );
309     }
310 
311     function removeLimits() external onlyOwner{
312         _maxTxAmount = _tTotal;
313         _maxWalletSize=_tTotal;
314         transferDelayEnabled=false;
315         emit MaxTxAmountUpdated(_tTotal);
316     }
317 
318     function sendETHToFee(uint256 amount) private {
319         _taxWallet.transfer(amount);
320     }
321 
322 
323     function openTrading() external onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         _approve(address(this), address(uniswapV2Router), _tTotal);
327         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
328         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330         swapEnabled = true;
331         tradingOpen = true;
332     }
333 
334     receive() external payable {}
335 
336     function manualSwap() external {
337         require(_msgSender()==_taxWallet);
338         uint256 tokenBalance=balanceOf(address(this));
339         if(tokenBalance>0){
340           swapTokensForEth(tokenBalance);
341         }
342         uint256 ethBalance=address(this).balance;
343         if(ethBalance>0){
344           sendETHToFee(ethBalance);
345         }
346     }
347 
348      function manualSend() external {
349         uint256 ethBalance=address(this).balance;
350         if(ethBalance>0){
351           sendETHToFee(ethBalance);
352         }
353     }
354 }