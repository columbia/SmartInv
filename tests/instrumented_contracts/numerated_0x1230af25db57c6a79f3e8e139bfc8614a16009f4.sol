1 /*
2 ~~Domdomdom yesyesyes dance with Yasin.~~    
3 
4 //  https://t.me/domdomyesyeseth
5 
6 //  https://twitter.com/domdomyesyeseth
7 
8 //  https://dddyyy.xyz
9 
10 */
11 
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
121 contract DOMDOMDOMYESYESYES is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = true;
128     address payable private _taxWallet;
129     uint256 private _initialBuyFee = 20;
130     uint256 private _initialSellFee = 20;
131     uint256 private _reduceBuyTaxAt = 25;
132 
133     uint256 private _initialBuyTax2Time = 15;
134     uint256 private _initialSellTax2Time = 15;
135     uint256 private _reduceBuyTaxAt2Time = 35;
136 
137     uint256 private _finalBuyTax = 1;
138     uint256 private _finalSellTax = 1;
139     uint256 private _reduceSellTaxAt = 20;
140 
141     uint256 private _preventSwapBefore = 25;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _tTotal = 100_000_000_000 * 10**_decimals;
146     string private constant _name = unicode"DOMDOMDOMYESYESYES";
147     string private constant _symbol = unicode"DDDYYY";
148 
149     uint256 public _maxTxAmount =  2 * (_tTotal/100);
150     uint256 public _maxWalletSize =  2 * (_tTotal/100);
151     uint256 public _taxSwapThreshold=  1 * (_tTotal/1000);
152     uint256 public _maxTaxSwap=  12 * (_tTotal/1000);
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
168         _taxWallet = payable(_msgSender());
169         _balances[_msgSender()] = _tTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_taxWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             taxAmount = amount.mul(_taxBuy()).div(100);
231 
232             if (transferDelayEnabled) {
233                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
234                       require(
235                           _holderLastTransferTimestamp[tx.origin] <
236                               block.number,
237                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
238                       );
239                       _holderLastTransferTimestamp[tx.origin] = block.number;
240                   }
241               }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249             if(to == uniswapV2Pair && from!= address(this) ){
250                 taxAmount = amount.mul(_taxSell()).div(100);
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 50000000000000000) {
258                     sendETHToFee(address(this).balance);
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
274             return _initialBuyFee;
275         }
276         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
277             return _initialBuyTax2Time;
278         }
279          return _finalBuyTax;
280     }
281 
282     function _taxSell() private view returns (uint256) {
283         if(_buyCount <= _reduceBuyTaxAt){
284             return _initialSellFee;
285         }
286         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
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
321 
322     function openTrading() external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         _approve(address(this), address(uniswapV2Router), _tTotal);
326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
328         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
329         swapEnabled = true;
330         tradingOpen = true;
331     }
332 
333     receive() external payable {}
334 
335     function manualSwap() external {
336         require(_msgSender()==_taxWallet);
337         uint256 tokenBalance=balanceOf(address(this));
338         if(tokenBalance>0){
339           swapTokensForEth(tokenBalance);
340         }
341         uint256 ethBalance=address(this).balance;
342         if(ethBalance>0){
343           sendETHToFee(ethBalance);
344         }
345     }
346 }