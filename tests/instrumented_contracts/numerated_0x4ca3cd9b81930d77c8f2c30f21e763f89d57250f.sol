1 /*
2 Dede the Pepe Killer - It's about fucking time!
3 
4 Socials:
5 Telegram: https://t.me/DedeCommunityEntry
6 Twitter: https://twitter.com/DedeCommunity_
7                             
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.21;
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
118 contract Dede is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping(address => uint256) private _holderLastTransferTimestamp;
124     bool public transferDelayEnabled = true;
125     address payable private _taxWallet;
126 
127     uint256 private _initialBuyTax = 20;  
128     uint256 private _initialSellTax = 20;
129     uint256 private _reduceBuyTaxAt = 15;
130     uint256 private _reduceSellTaxAt = 15;
131 
132     uint256 private _initialBuyTax2Time = 10;
133     uint256 private _initialSellTax2Time = 10;
134     uint256 private _reduceBuyTaxAt2Time = 25;
135 
136     uint256 private _finalBuyTax = 1;
137     uint256 private _finalSellTax = 1;
138     
139     uint256 private _preventSwapBefore = 10;
140     uint256 private _buyCount = 0;
141 
142     uint8 private constant _decimals = 9;
143     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
144     string private constant _name = unicode"Dede";
145     string private constant _symbol = unicode"DEDE";
146 
147     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
148     uint256 public _maxWalletSize =  2 * (_tTotal/100);
149     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
150     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
151 
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = false;
157 
158     event MaxTxAmountUpdated(uint _maxTxAmount);
159     modifier lockTheSwap {
160         inSwap = true;
161         _;
162         inSwap = false;
163     }
164 
165     constructor () {
166         _taxWallet = payable(_msgSender());
167         _balances[address(this)] = _tTotal;
168         _isExcludedFromFee[owner()] = true;
169         _isExcludedFromFee[address(this)] = true;
170         _isExcludedFromFee[_taxWallet] = true;
171 
172         emit Transfer(address(0), address(this), _tTotal);
173     }
174 
175     function name() public pure returns (string memory) {
176         return _name;
177     }
178 
179     function symbol() public pure returns (string memory) {
180         return _symbol;
181     }
182 
183     function decimals() public pure returns (uint8) {
184         return _decimals;
185     }
186 
187     function totalSupply() public pure override returns (uint256) {
188         return _tTotal;
189     }
190 
191     function balanceOf(address account) public view override returns (uint256) {
192         return _balances[account];
193     }
194 
195     function transfer(address recipient, uint256 amount) public override returns (bool) {
196         _transfer(_msgSender(), recipient, amount);
197         return true;
198     }
199 
200     function allowance(address owner, address spender) public view override returns (uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount) public override returns (bool) {
205         _approve(_msgSender(), spender, amount);
206         return true;
207     }
208 
209     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
210         _transfer(sender, recipient, amount);
211         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
212         return true;
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226         uint256 taxAmount=0;
227         if (from != owner() && to != owner()) {
228             taxAmount = amount.mul(_taxBuy()).div(100);
229 
230             if (transferDelayEnabled) {
231                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
232                     require(
233                         _holderLastTransferTimestamp[tx.origin] < block.number,
234                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
235                     );
236                     _holderLastTransferTimestamp[tx.origin] = block.number;
237                 }
238             }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 _buyCount++;
244                 if (_buyCount > _preventSwapBefore) {
245                     transferDelayEnabled = false;
246                 }
247             }
248 
249             if(to == uniswapV2Pair && from!= address(this) ){
250                 taxAmount = amount.mul(_taxSell()).div(100);
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
255                 uint256 initialETH = address(this).balance;
256                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
257                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
258                 if(ethForTransfer > 0) {
259                     sendETHToFee(ethForTransfer);
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
287         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
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
322     function openTrading() external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         _approve(address(this), address(uniswapV2Router), _tTotal);
326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)),0, 0, owner(), block.timestamp);
328         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
329         swapEnabled = true;
330         tradingOpen = true;
331     }
332 
333     receive() external payable {}
334 
335     function ManualSwap() external {
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