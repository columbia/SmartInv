1 /*
2 Telegram: https://t.me/HPOC1M
3 Twitter: https://twitter.com/HPOC1M
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.21;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract XRP is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping(address => uint256) private _holderLastTransferTimestamp;
120     bool public transferDelayEnabled = true;
121     address payable private _taxWallet;
122 
123     uint256 private _initialBuyTax = 20;  
124     uint256 private _initialSellTax = 20;
125     uint256 private _reduceBuyTaxAt = 15;
126     uint256 private _reduceSellTaxAt = 15;
127 
128     uint256 private _initialBuyTax2Time = 10;
129     uint256 private _initialSellTax2Time = 10;
130     uint256 private _reduceBuyTaxAt2Time = 25;
131 
132     uint256 private _finalBuyTax = 1;
133     uint256 private _finalSellTax = 1;
134     
135     uint256 private _preventSwapBefore = 10;
136     uint256 private _buyCount = 0;
137 
138     uint8 private constant _decimals = 9;
139     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
140     string private constant _name = unicode"HarryPotterObamaChrisLarsen1Meme";
141     string private constant _symbol = unicode"XRP";
142 
143     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
144     uint256 public _maxWalletSize =  2 * (_tTotal/100);
145     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
146     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
147 
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153 
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162         _taxWallet = payable(_msgSender());
163         _balances[address(this)] = _tTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_taxWallet] = true;
167 
168         emit Transfer(address(0), address(this), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _transfer(address from, address to, uint256 amount) private {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221         require(amount > 0, "Transfer amount must be greater than zero");
222         uint256 taxAmount=0;
223         if (from != owner() && to != owner()) {
224             taxAmount = amount.mul(_taxBuy()).div(100);
225 
226             if (transferDelayEnabled) {
227                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
228                     require(
229                         _holderLastTransferTimestamp[tx.origin] < block.number,
230                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
231                     );
232                     _holderLastTransferTimestamp[tx.origin] = block.number;
233                 }
234             }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 _buyCount++;
240                 if (_buyCount > _preventSwapBefore) {
241                     transferDelayEnabled = false;
242                 }
243             }
244 
245             if(to == uniswapV2Pair && from!= address(this) ){
246                 taxAmount = amount.mul(_taxSell()).div(100);
247             }
248 
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
251                 uint256 initialETH = address(this).balance;
252                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
253                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
254                 if(ethForTransfer > 0) {
255                     sendETHToFee(ethForTransfer);
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
273         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
274             return _initialBuyTax2Time;
275         }
276          return _finalBuyTax;
277     }
278 
279     function _taxSell() private view returns (uint256) {
280         if(_buyCount <= _reduceBuyTaxAt){
281             return _initialSellTax;
282         }
283         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
284             return _initialSellTax2Time;
285         }
286          return _finalBuyTax;
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
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         _approve(address(this), address(uniswapV2Router), _tTotal);
322         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)),0, 0, owner(), block.timestamp);
324         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
325         swapEnabled = true;
326         tradingOpen = true;
327     }
328 
329     receive() external payable {}
330 
331     function ManualSwap() external {
332         require(_msgSender()==_taxWallet);
333         uint256 tokenBalance=balanceOf(address(this));
334         if(tokenBalance>0){
335           swapTokensForEth(tokenBalance);
336         }
337         uint256 ethBalance=address(this).balance;
338         if(ethBalance>0){
339           sendETHToFee(ethBalance);
340         }
341     }
342 }