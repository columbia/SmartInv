1 /**
2   ______      __    __       ___      .__   __. .___________.  ______   .______     ______   .___________.
3  /  __  \    |  |  |  |     /   \     |  \ |  | |           | /  __  \  |   _  \   /  __  \  |           |
4 |  |  |  |   |  |  |  |    /  ^  \    |   \|  | `---|  |----`|  |  |  | |  |_)  | |  |  |  | `---|  |----`
5 |  |  |  |   |  |  |  |   /  /_\  \   |  . `  |     |  |     |  |  |  | |   _  <  |  |  |  |     |  |     
6 |  `--'  '--.|  `--'  |  /  _____  \  |  |\   |     |  |     |  `--'  | |  |_)  | |  `--'  |     |  |     
7  \_____\_____\\______/  /__/     \__\ |__| \__|     |__|      \______/  |______/   \______/      |__|     
8                                                                                                           
9 
10 QuantoBot
11 Experience the next level of DEX trading. The ultimate bot offering unrivaled features and capabilities. 
12 
13 
14 New Pairs Scanner
15 Stay ahead of the market by receiving timely notifications when new trading pairs that meet specific criteria are identified. The bot function analyzes factors such as trading volume, price volatility, social media, liquidity, and market trends to provide comprehensive insights into the identified pairs.
16 
17 Listing Sniper
18 Once a liquidity adding transaction is detected, the function analyzes the transaction details to determine if it meets the desired criteria. For example, it might consider factors such as the token pair, liquidity amount, and deployer balance. Then it will proceed to buy desired token before everyone else.
19 
20 Token Elite Checker
21 Gain access to comprehensive token information, including market performance, honeypot checking, trading volume liquidity, and historical data. Our bot's advanced metrics and indicators assess token health and potential, incorporating factors like market capitalization, community engagement, and development activity.
22 
23 Mirror Frontrun Sniper
24 Copies the actions of specialized wallets. It is designed to replicate the trades and actions performed by specific targeted wallets. Monitors the targeted wallet's transactions in real-time and automatically executes identical trades or actions in the user's own wallet and front-running them.
25 
26 Pre-Sale Sniper
27 Once a presale is detected (e.g., on Pinksale), the function analyzes the details of the presale event and executes a purchase ahead of others. This analysis encompasses information such as the token being offered, the token price, allocation limits, presale duration, and any specific rules or requirements.
28 
29 Swap Limit Orders
30 Customize trading preferences by setting the desired token pair, target price, and order expiration time. The bot function constantly monitors the market, tracking price movements and executing the swap when the specified price conditions are met.
31 
32 AI Trading Strategies
33 You can access a wide range of pre-built AI trading strategies for DEX designed to maximize returns and minimize risks. The bot function continuously monitors market conditions, evaluates historical data, and adapts strategies in real-time to capitalize on emerging opportunities and mitigate potential losses.
34 
35 Call Groups Copytrade
36 The function is designed to enable copy trading from specified Telegram groups listed on a list. Copy trading allows users to automatically replicate the trades executed by experienced traders or groups, providing an opportunity to benefit from their expertise and potentially achieve similar trading outcomes.
37 
38 Portfolio Monitor
39 That function is a powerful tool that allows users to track and manage their cryptocurrency wallets in real-time. This function continuously monitors the user's assets on wallets, providing a comprehensive overview of their holdings and crypto portfolio performance including all tokens and native coins.
40 
41 
42 Website: https://quantobot.com
43 Docs: https://quantobot.gitbook.io/introduction
44 
45 Telegram: https://t.me/quantobotgroup
46 Twitter: https://twitter.com/quantobot
47 Medium: https://medium.com/@quantobot
48 
49 Enjoy the flexibility to trade on the chain that best suits your needs, unlocking a world of possibilities in the crypto market.
50 
51 **/
52 // SPDX-License-Identifier: MIT
53 
54 
55 pragma solidity 0.8.20;
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 }
62 
63 interface IERC20 {
64     function totalSupply() external view returns (uint256);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address recipient, uint256 amount) external returns (bool);
67     function allowance(address owner, address spender) external view returns (uint256);
68     function approve(address spender, uint256 amount) external returns (bool);
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 library SafeMath {
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath: addition overflow");
78         return c;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return sub(a, b, "SafeMath: subtraction overflow");
83     }
84 
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88         return c;
89     }
90 
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         return c;
108     }
109 
110 }
111 
112 contract Ownable is Context {
113     address private _owner;
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     constructor () {
117         address msgSender = _msgSender();
118         _owner = msgSender;
119         emit OwnershipTransferred(address(0), msgSender);
120     }
121 
122     function owner() public view returns (address) {
123         return _owner;
124     }
125 
126     modifier onlyOwner() {
127         require(_owner == _msgSender(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     function renounceOwnership() public virtual onlyOwner {
132         emit OwnershipTransferred(_owner, address(0));
133         _owner = address(0);
134     }
135 
136 }
137 
138 interface IUniswapV2Factory {
139     function createPair(address tokenA, address tokenB) external returns (address pair);
140 }
141 
142 interface IUniswapV2Router02 {
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150     function factory() external pure returns (address);
151     function WETH() external pure returns (address);
152     function addLiquidityETH(
153         address token,
154         uint amountTokenDesired,
155         uint amountTokenMin,
156         uint amountETHMin,
157         address to,
158         uint deadline
159     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
160 }
161 
162 contract QuantoBot is Context, IERC20, Ownable {
163     using SafeMath for uint256;
164     mapping (address => uint256) private _balances;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     mapping (address => bool) private _isExcludedFromFee;
167     address payable private _taxWallet;
168     uint256 firstBlock;
169 
170     uint256 private _initialBuyTax=16;
171     uint256 private _initialSellTax=16;
172     uint256 private _finalBuyTax=5;
173     uint256 private _finalSellTax=5;
174     uint256 private _reduceBuyTaxAt=15;
175     uint256 private _reduceSellTaxAt=15;
176     uint256 private _preventSwapBefore=24;
177     uint256 private _buyCount=0;
178 
179     uint8 private constant _decimals = 9;
180     uint256 private constant _tTotal = 100000000 * 10**_decimals;
181     string private constant _name = unicode"QuantoBot";
182     string private constant _symbol = unicode"QUANTO";
183     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
184     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
185     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
186     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
187 
188     IUniswapV2Router02 private uniswapV2Router;
189     address private uniswapV2Pair;
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = false;
193 
194     event MaxTxAmountUpdated(uint _maxTxAmount);
195     modifier lockTheSwap {
196         inSwap = true;
197         _;
198         inSwap = false;
199     }
200 
201     constructor () {
202 
203         _taxWallet = payable(_msgSender());
204         _balances[_msgSender()] = _tTotal;
205         _isExcludedFromFee[owner()] = true;
206         _isExcludedFromFee[address(this)] = true;
207         _isExcludedFromFee[_taxWallet] = true;
208         
209         emit Transfer(address(0), _msgSender(), _tTotal);
210     }
211 
212     function name() public pure returns (string memory) {
213         return _name;
214     }
215 
216     function symbol() public pure returns (string memory) {
217         return _symbol;
218     }
219 
220     function decimals() public pure returns (uint8) {
221         return _decimals;
222     }
223 
224     function totalSupply() public pure override returns (uint256) {
225         return _tTotal;
226     }
227 
228     function balanceOf(address account) public view override returns (uint256) {
229         return _balances[account];
230     }
231 
232     function transfer(address recipient, uint256 amount) public override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     function allowance(address owner, address spender) public view override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount) public override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
249         return true;
250     }
251 
252     function _approve(address owner, address spender, uint256 amount) private {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 
259     function _transfer(address from, address to, uint256 amount) private {
260         require(from != address(0), "ERC20: transfer from the zero address");
261         require(to != address(0), "ERC20: transfer to the zero address");
262         require(amount > 0, "Transfer amount must be greater than zero");
263         uint256 taxAmount=0;
264         if (from != owner() && to != owner()) {
265             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
266 
267             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
268                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
269                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
270 
271                 if (firstBlock + 3  > block.number) {
272                     require(!isContract(to));
273                 }
274                 _buyCount++;
275             }
276 
277             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
278                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
279             }
280 
281             if(to == uniswapV2Pair && from!= address(this) ){
282                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
283             }
284 
285             uint256 contractTokenBalance = balanceOf(address(this));
286             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
287                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
288                 uint256 contractETHBalance = address(this).balance;
289                 if(contractETHBalance > 0) {
290                     sendETHToFee(address(this).balance);
291                 }
292             }
293         }
294 
295         if(taxAmount>0){
296           _balances[address(this)]=_balances[address(this)].add(taxAmount);
297           emit Transfer(from, address(this),taxAmount);
298         }
299         _balances[from]=_balances[from].sub(amount);
300         _balances[to]=_balances[to].add(amount.sub(taxAmount));
301         emit Transfer(from, to, amount.sub(taxAmount));
302     }
303 
304 
305     function min(uint256 a, uint256 b) private pure returns (uint256){
306       return (a>b)?b:a;
307     }
308 
309     function isContract(address account) private view returns (bool) {
310         uint256 size;
311         assembly {
312             size := extcodesize(account)
313         }
314         return size > 0;
315     }
316 
317     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
318         address[] memory path = new address[](2);
319         path[0] = address(this);
320         path[1] = uniswapV2Router.WETH();
321         _approve(address(this), address(uniswapV2Router), tokenAmount);
322         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
323             tokenAmount,
324             0,
325             path,
326             address(this),
327             block.timestamp
328         );
329     }
330 
331     function removeLimits() external onlyOwner{
332         _maxTxAmount = _tTotal;
333         _maxWalletSize=_tTotal;
334         emit MaxTxAmountUpdated(_tTotal);
335     }
336 
337     function sendETHToFee(uint256 amount) private {
338         _taxWallet.transfer(amount);
339     }
340 
341     function openTrading() external onlyOwner() {
342         require(!tradingOpen,"trading is already open");
343         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
344         _approve(address(this), address(uniswapV2Router), _tTotal);
345         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
346         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
347         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
348         swapEnabled = true;
349         tradingOpen = true;
350         firstBlock = block.number;
351     }
352 
353     receive() external payable {}
354 }