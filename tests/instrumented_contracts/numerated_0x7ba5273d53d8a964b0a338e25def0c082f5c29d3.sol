1 /**
2 
3 The most asked question in the universe is WEN?
4 
5 Website: https://wen.army/
6 Twitter: https://twitter.com/WentokenWen
7 TG: https://t.me/wenjoinus
8 
9 
10 **/
11 // SPDX-License-Identifier: MIT
12 
13 
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
121 contract WEN is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private _buyerMap;
127     mapping (address => bool) private bots;
128     mapping(address => uint256) private _holderLastTransferTimestamp;
129     bool public transferDelayEnabled = false;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=20;
133     uint256 private _initialSellTax=20;
134     uint256 private _finalBuyTax=2;
135     uint256 private _finalSellTax=2;
136     uint256 private _reduceBuyTaxAt=25;
137     uint256 private _reduceSellTaxAt=25;
138     uint256 private _preventSwapBefore=10;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 8;
142     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
143     string private constant _name = unicode"wen";
144     string private constant _symbol = unicode"WEN";
145     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
146     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
147     uint256 public _taxSwapThreshold=10000000 * 10**_decimals;
148     uint256 public _maxTaxSwap=10000000 * 10**_decimals;
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
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
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
226             require(!bots[from] && !bots[to]);
227 
228             if (transferDelayEnabled) {
229                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
230                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
231                   _holderLastTransferTimestamp[tx.origin] = block.number;
232                 }
233             }
234 
235             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
236                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
237                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
238                 if(_buyCount<_preventSwapBefore){
239                   require(!isContract(to));
240                 }
241                 _buyCount++;
242                 _buyerMap[to]=true;
243             }
244 
245 
246             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
250                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
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
272 
273     function min(uint256 a, uint256 b) private pure returns (uint256){
274       return (a>b)?b:a;
275     }
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         if(tokenAmount==0){return;}
279         if(!tradingOpen){return;}
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = uniswapV2Router.WETH();
283         _approve(address(this), address(uniswapV2Router), tokenAmount);
284         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291     }
292 
293     function removeLimits() external onlyOwner{
294         _maxTxAmount = _tTotal;
295         _maxWalletSize=_tTotal;
296         transferDelayEnabled=false;
297         emit MaxTxAmountUpdated(_tTotal);
298     }
299 
300     function sendETHToFee(uint256 amount) private {
301         _taxWallet.transfer(amount);
302     }
303 
304     function isBot(address a) public view returns (bool){
305       return bots[a];
306     }
307 
308     function openTradingWEN() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
311         _approve(address(this), address(uniswapV2Router), _tTotal);
312         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
313         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315         swapEnabled = true;
316         tradingOpen = true;
317     }
318 
319     receive() external payable {}
320 
321     function isContract(address account) private view returns (bool) {
322         uint256 size;
323         assembly {
324             size := extcodesize(account)
325         }
326         return size > 0;
327     }
328 
329     function manualSwap() external {
330         require(_msgSender()==_taxWallet);
331         uint256 tokenBalance=balanceOf(address(this));
332         if(tokenBalance>0){
333           swapTokensForEth(tokenBalance);
334         }
335         uint256 ethBalance=address(this).balance;
336         if(ethBalance>0){
337           sendETHToFee(ethBalance);
338         }
339     }
340 
341     
342     
343     
344 }