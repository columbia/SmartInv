1 // SPDX-License-Identifier: MIT
2 /**
3 Twitter: https://twitter.com/botcoineth
4 Website: https://botcoin.africa/
5 Telegram bot: https://t.me/BOTCOINPORTAL
6 Discord: 
7 **/
8 
9 
10 pragma solidity 0.8.20;
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
117 contract EspressoToken is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private bots;
123     mapping(address => uint256) private _holderLastTransferTimestamp;
124     bool public transferDelayEnabled = true;
125     address payable private _taxWallet;
126 
127     uint256 private _initialBuyTax=3;
128     uint256 private _initialSellTax=3;
129     uint256 private _finalBuyTax=3;
130     uint256 private _finalSellTax=3;
131     uint256 private _reduceBuyTaxAt=25;
132     uint256 private _reduceSellTaxAt=30;
133     uint256 private _preventSwapBefore=25;
134     uint256 private _buyCount=0;
135 
136     uint8 private constant _decimals = 18;
137     uint256 private constant _tTotal = 888888888888 * 10**_decimals;
138     string private constant _name = unicode"UnibotEspressoAimBotTetrisLootBotChainGPTWagieBot";
139     string private constant _symbol = unicode"BOTCOIN";
140     uint256 public _maxTxAmount = 8888888888 * 10**_decimals;
141     uint256 public _maxWalletSize = 8888888888 * 10**_decimals;
142     uint256 public _taxSwapThreshold= 14000001 * 10**_decimals;
143     uint256 public _maxTaxSwap= 14000000 * 10**_decimals;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150 
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor () {
159         _taxWallet = payable(_msgSender());
160         _balances[_msgSender()] = _tTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_taxWallet] = true;
164 
165         emit Transfer(address(0), _msgSender(), _tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _balances[account];
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) private {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(from != address(0), "ERC20: transfer from the zero address");
217         require(to != address(0), "ERC20: transfer to the zero address");
218         require(amount > 0, "Transfer amount must be greater than zero");
219         uint256 taxAmount=0;
220         if (from != owner() && to != owner()) {
221             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
222 
223             if (transferDelayEnabled) {
224                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
225                       require(
226                           _holderLastTransferTimestamp[tx.origin] <
227                               block.number,
228                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
229                       );
230                       _holderLastTransferTimestamp[tx.origin] = block.number;
231                   }
232               }
233 
234             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237                 _buyCount++;
238             }
239 
240             if(to == uniswapV2Pair && from!= address(this) ){
241                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
242             }
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
246                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
247                 uint256 contractETHBalance = address(this).balance;
248                 if(contractETHBalance > 50000000000000000) {
249                     sendETHToFee(address(this).balance);
250                 }
251             }
252         }
253 
254         if(taxAmount>0){
255           _balances[address(this)]=_balances[address(this)].add(taxAmount);
256           emit Transfer(from, address(this),taxAmount);
257         }
258         _balances[from]=_balances[from].sub(amount);
259         _balances[to]=_balances[to].add(amount.sub(taxAmount));
260         emit Transfer(from, to, amount.sub(taxAmount));
261     }
262 
263 
264     function min(uint256 a, uint256 b) private pure returns (uint256){
265       return (a>b)?b:a;
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize=_tTotal;
285         transferDelayEnabled=false;
286         emit MaxTxAmountUpdated(_tTotal);
287     }
288 
289     function sendETHToFee(uint256 amount) private {
290         _taxWallet.transfer(amount);
291     }
292 
293 
294     function openTrading() external onlyOwner() {
295         require(!tradingOpen,"trading is already open");
296         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
297         _approve(address(this), address(uniswapV2Router), _tTotal);
298         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
299         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
300         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
301         swapEnabled = true;
302         tradingOpen = true;
303     }
304 
305     receive() external payable {}
306 
307     function manualSwap() external {
308         require(_msgSender()==_taxWallet);
309         uint256 tokenBalance=balanceOf(address(this));
310         if(tokenBalance>0){
311           swapTokensForEth(tokenBalance);
312         }
313         uint256 ethBalance=address(this).balance;
314         if(ethBalance>0){
315           sendETHToFee(ethBalance);
316         }
317     }
318 
319     function pair() public view returns (address) {
320         return uniswapV2Pair;
321     }
322 }