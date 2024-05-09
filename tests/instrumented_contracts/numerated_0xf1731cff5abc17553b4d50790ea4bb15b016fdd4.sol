1 /*
2 
3 Orca Tank
4 
5 The shark tank for memecoins.
6 The 1st ever group incubator for memecoins.
7 
8 https://orcaeth.com
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
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
71 
72 contract Ownable is Context {
73     address private _owner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }
97 
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 
124 contract Orca is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = false;
132     address payable private _taxWallet;
133 
134     uint256 private _initialBuyTax=12;
135     uint256 private _initialSellTax=22;
136     uint256 private _finalBuyTax=2;
137     uint256 private _finalSellTax=2;
138     uint256 private _reduceBuyTaxAt=12;
139     uint256 private _reduceSellTaxAt=22;
140     uint256 private _preventSwapBefore=22;
141     uint256 private _buyCount=0;
142 
143     uint8 private constant _decimals = 10;
144     uint256 private constant _tTotal = 424242424242424 * 10**_decimals;
145     string private constant _name = unicode"Orca Tank";
146     string private constant _symbol = unicode"ORCA";
147     uint256 public _maxTxAmount = 12727272727272 * 10**_decimals;
148     uint256 public _maxWalletSize = 12727272727272 * 10**_decimals;
149     uint256 public _taxSwapThreshold= 4242424242424 * 10**_decimals;
150     uint256 public _maxTaxSwap= 4242424242424 * 10**_decimals;
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
165 
166     constructor () {
167         _taxWallet = payable(_msgSender());
168         _balances[_msgSender()] = _tTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_taxWallet] = true;
172 
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
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
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         uint256 taxAmount=0;
230         if (from != owner() && to != owner()) {
231             require(!bots[from] && !bots[to]);
232 
233             if (transferDelayEnabled) {
234                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
235                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
236                   _holderLastTransferTimestamp[tx.origin] = block.number;
237                 }
238             }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 if(_buyCount<_preventSwapBefore){
244                   require(!isContract(to));
245                 }
246                 _buyCount++;
247             }
248 
249 
250             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
251             if(to == uniswapV2Pair && from!= address(this) ){
252                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
253                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
254             }
255 
256             uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
258                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
259                 uint256 contractETHBalance = address(this).balance;
260                 if(contractETHBalance > 0) {
261                     sendETHToFee(address(this).balance);
262                 }
263             }
264         }
265 
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270         _balances[from]=_balances[from].sub(amount);
271         _balances[to]=_balances[to].add(amount.sub(taxAmount));
272         emit Transfer(from, to, amount.sub(taxAmount));
273     }
274 
275 
276     function min(uint256 a, uint256 b) private pure returns (uint256){
277       return (a>b)?b:a;
278     }
279 
280     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
281         if(tokenAmount==0){return;}
282         if(!tradingOpen){return;}
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = uniswapV2Router.WETH();
286         _approve(address(this), address(uniswapV2Router), tokenAmount);
287         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
288             tokenAmount,
289             0,
290             path,
291             address(this),
292             block.timestamp
293         );
294     }
295 
296     function removeLimits() external onlyOwner{
297         _maxTxAmount = _tTotal;
298         _maxWalletSize=_tTotal;
299         transferDelayEnabled=false;
300         emit MaxTxAmountUpdated(_tTotal);
301     }
302 
303     function sendETHToFee(uint256 amount) private {
304         _taxWallet.transfer(amount);
305     }
306 
307     function isBot(address a) public view returns (bool){
308       return bots[a];
309     }
310 
311     function openTrading() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         _approve(address(this), address(uniswapV2Router), _tTotal);
315         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
316         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
317         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
318         swapEnabled = true;
319         tradingOpen = true;
320     }
321 
322 
323     receive() external payable {}
324 
325     function isContract(address account) private view returns (bool) {
326         uint256 size;
327         assembly {
328             size := extcodesize(account)
329         }
330         return size > 0;
331     }
332 
333     function manualSwap() external {
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
344 
345     
346     
347     
348 }