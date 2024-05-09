1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-15
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /** 
7 Twitter: https://twitter.com/espressoTG
8 Website: https://espressobot.xyz
9 Telegram bot: https://t.me/espressoTGbot
10 Gitbook: https://espressobot.gitbook.io/espressobot-docs/
11 **/
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
121 contract Espresso is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping(address => uint256) private _holderLastTransferTimestamp;
128     bool public transferDelayEnabled = true;
129     address payable private _taxWallet;
130 
131     uint256 private _initialBuyTax=5;
132     uint256 private _initialSellTax=5;
133     uint256 private _finalBuyTax=5;
134     uint256 private _finalSellTax=5;
135     uint256 private _reduceBuyTaxAt=25;
136     uint256 private _reduceSellTaxAt=30;
137     uint256 private _preventSwapBefore=25;
138     uint256 private _buyCount=0;
139 
140     uint8 private constant _decimals = 9;
141     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
142     string private constant _name = unicode"Espresso";
143     string private constant _symbol = unicode"ESPR";
144     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
145     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
146     uint256 public _taxSwapThreshold= 14000001 * 10**_decimals;
147     uint256 public _maxTaxSwap= 14000000 * 10**_decimals;
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
225             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
226 
227             if (transferDelayEnabled) {
228                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
229                       require(
230                           _holderLastTransferTimestamp[tx.origin] <
231                               block.number,
232                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
233                       );
234                       _holderLastTransferTimestamp[tx.origin] = block.number;
235                   }
236               }
237 
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241                 _buyCount++;
242             }
243 
244             if(to == uniswapV2Pair && from!= address(this) ){
245                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
246             }
247 
248             uint256 contractTokenBalance = balanceOf(address(this));
249             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
250                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
251                 uint256 contractETHBalance = address(this).balance;
252                 if(contractETHBalance > 50000000000000000) {
253                     sendETHToFee(address(this).balance);
254                 }
255             }
256         }
257 
258         if(taxAmount>0){
259           _balances[address(this)]=_balances[address(this)].add(taxAmount);
260           emit Transfer(from, address(this),taxAmount);
261         }
262         _balances[from]=_balances[from].sub(amount);
263         _balances[to]=_balances[to].add(amount.sub(taxAmount));
264         emit Transfer(from, to, amount.sub(taxAmount));
265     }
266 
267 
268     function min(uint256 a, uint256 b) private pure returns (uint256){
269       return (a>b)?b:a;
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285 
286     function removeLimits() external onlyOwner{
287         _maxTxAmount = _tTotal;
288         _maxWalletSize=_tTotal;
289         transferDelayEnabled=false;
290         emit MaxTxAmountUpdated(_tTotal);
291     }
292 
293     function sendETHToFee(uint256 amount) private {
294         _taxWallet.transfer(amount);
295     }
296 
297 
298     function openTrading() external onlyOwner() {
299         require(!tradingOpen,"trading is already open");
300         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         _approve(address(this), address(uniswapV2Router), _tTotal);
302         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
303         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
304         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
305         swapEnabled = true;
306         tradingOpen = true;
307     }
308 
309     receive() external payable {}
310 
311     function manualSwap() external {
312         require(_msgSender()==_taxWallet);
313         uint256 tokenBalance=balanceOf(address(this));
314         if(tokenBalance>0){
315           swapTokensForEth(tokenBalance);
316         }
317         uint256 ethBalance=address(this).balance;
318         if(ethBalance>0){
319           sendETHToFee(ethBalance);
320         }
321     }
322 }