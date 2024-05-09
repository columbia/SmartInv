1 /**
2 
3 Telegram:     https://t.me/RocketFellerETH
4 
5 Twitter:      https://twitter.com/RocketFellerETH
6  
7 Website/dApp: https://rocketfeller.tech/
8 
9 */
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.18;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     function allowance(
30         address owner,
31         address spender
32     ) external view returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(
62         uint256 a,
63         uint256 b,
64         string memory errorMessage
65     ) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68         return c;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         return c;
92     }
93 }
94 
95 contract Ownable is Context {
96     address private _owner;
97     event OwnershipTransferred(
98         address indexed previousOwner,
99         address indexed newOwner
100     );
101 
102     constructor() {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 }
122 
123 interface IUniswapV2Factory {
124     function createPair(
125         address tokenA,
126         address tokenB
127     ) external returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 
139     function factory() external pure returns (address);
140 
141     function WETH() external pure returns (address);
142 
143     function addLiquidityETH(
144         address token,
145         uint amountTokenDesired,
146         uint amountTokenMin,
147         uint amountETHMin,
148         address to,
149         uint deadline
150     )
151         external
152         payable
153         returns (uint amountToken, uint amountETH, uint liquidity);
154 }
155 
156 contract RocketFeller is Context, IERC20, Ownable {
157     using SafeMath for uint256;
158     mapping(address => uint256) private _balances;
159     mapping(address => mapping(address => uint256)) private _allowances;
160     mapping(address => bool) private _isExcludedFromFee;
161     mapping(address => bool) private bots;
162     mapping(address => uint256) private _holderLastTransferTimestamp;
163     bool public transferDelayEnabled = true;
164     address payable private _taxWallet;
165 
166     uint256 private _initialBuyTax = 20;
167     uint256 private _initialSellTax = 20;
168     uint256 private _finalBuyTax = 5;
169     uint256 private _finalSellTax = 5;
170     uint256 private _reduceBuyTaxAt = 25;
171     uint256 private _reduceSellTaxAt = 25;
172     uint256 private _preventSwapBefore = 25;
173     uint256 private _buyCount = 0;
174 
175     uint8 private constant _decimals = 9;
176     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
177     string private constant _name = unicode"RocketFeller";
178     string private constant _symbol = unicode"ROCKETFELLER";
179     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
180     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
181     uint256 public _taxSwapThreshold = 100000 * 10 ** _decimals;
182     uint256 public _maxTaxSwap = 1200000 * 10 ** _decimals;
183 
184     IUniswapV2Router02 private uniswapV2Router;
185     address private uniswapV2Pair;
186     bool private tradingOpen;
187     bool private inSwap = false;
188     bool private swapEnabled = false;
189 
190     event MaxTxAmountUpdated(uint _maxTxAmount);
191     modifier lockTheSwap() {
192         inSwap = true;
193         _;
194         inSwap = false;
195     }
196 
197     constructor() {
198         _taxWallet = payable(_msgSender());
199         _balances[_msgSender()] = _tTotal;
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202         _isExcludedFromFee[_taxWallet] = true;
203 
204         emit Transfer(address(0), _msgSender(), _tTotal);
205     }
206 
207     function name() public pure returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public pure returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public pure returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public pure override returns (uint256) {
220         return _tTotal;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(
228         address recipient,
229         uint256 amount
230     ) public override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     function allowance(
236         address owner,
237         address spender
238     ) public view override returns (uint256) {
239         return _allowances[owner][spender];
240     }
241 
242     function approve(
243         address spender,
244         uint256 amount
245     ) public override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     function transferFrom(
251         address sender,
252         address recipient,
253         uint256 amount
254     ) public override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(
257             sender,
258             _msgSender(),
259             _allowances[sender][_msgSender()].sub(
260                 amount,
261                 "ERC20: transfer amount exceeds allowance"
262             )
263         );
264         return true;
265     }
266 
267     function _approve(address owner, address spender, uint256 amount) private {
268         require(owner != address(0), "ERC20: approve from the zero address");
269         require(spender != address(0), "ERC20: approve to the zero address");
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function _transfer(address from, address to, uint256 amount) private {
275         require(from != address(0), "ERC20: transfer from the zero address");
276         require(to != address(0), "ERC20: transfer to the zero address");
277         require(amount > 0, "Transfer amount must be greater than zero");
278         uint256 taxAmount = 0;
279         if (from != owner() && to != owner()) {
280             taxAmount = amount
281                 .mul(
282                     (_buyCount > _reduceBuyTaxAt)
283                         ? _finalBuyTax
284                         : _initialBuyTax
285                 )
286                 .div(100);
287 
288             if (transferDelayEnabled) {
289                 if (
290                     to != address(uniswapV2Router) &&
291                     to != address(uniswapV2Pair)
292                 ) {
293                     require(
294                         _holderLastTransferTimestamp[tx.origin] < block.number,
295                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
296                     );
297                     _holderLastTransferTimestamp[tx.origin] = block.number;
298                 }
299             }
300 
301             if (
302                 from == uniswapV2Pair &&
303                 to != address(uniswapV2Router) &&
304                 !_isExcludedFromFee[to]
305             ) {
306                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
307                 require(
308                     balanceOf(to) + amount <= _maxWalletSize,
309                     "Exceeds the maxWalletSize."
310                 );
311                 _buyCount++;
312             }
313 
314             if (to == uniswapV2Pair && from != address(this)) {
315                 taxAmount = amount
316                     .mul(
317                         (_buyCount > _reduceSellTaxAt)
318                             ? _finalSellTax
319                             : _initialSellTax
320                     )
321                     .div(100);
322             }
323 
324             uint256 contractTokenBalance = balanceOf(address(this));
325             if (
326                 !inSwap &&
327                 to == uniswapV2Pair &&
328                 swapEnabled &&
329                 contractTokenBalance > _taxSwapThreshold &&
330                 _buyCount > _preventSwapBefore
331             ) {
332                 swapTokensForEth(
333                     min(amount, min(contractTokenBalance, _maxTaxSwap))
334                 );
335                 uint256 contractETHBalance = address(this).balance;
336                 if (contractETHBalance > 50000000000000000) {
337                     sendETHToFee(address(this).balance);
338                 }
339             }
340         }
341 
342         if (taxAmount > 0) {
343             _balances[address(this)] = _balances[address(this)].add(taxAmount);
344             emit Transfer(from, address(this), taxAmount);
345         }
346         _balances[from] = _balances[from].sub(amount);
347         _balances[to] = _balances[to].add(amount.sub(taxAmount));
348         emit Transfer(from, to, amount.sub(taxAmount));
349     }
350 
351     function min(uint256 a, uint256 b) private pure returns (uint256) {
352         return (a > b) ? b : a;
353     }
354 
355     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
356         address[] memory path = new address[](2);
357         path[0] = address(this);
358         path[1] = uniswapV2Router.WETH();
359         _approve(address(this), address(uniswapV2Router), tokenAmount);
360         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
361             tokenAmount,
362             0,
363             path,
364             address(this),
365             block.timestamp
366         );
367     }
368 
369     function removeLimits() external onlyOwner {
370         _maxTxAmount = _tTotal;
371         _maxWalletSize = _tTotal;
372         transferDelayEnabled = false;
373         emit MaxTxAmountUpdated(_tTotal);
374     }
375 
376     function sendETHToFee(uint256 amount) private {
377         _taxWallet.transfer(amount);
378     }
379 
380     function openTrading() external onlyOwner {
381         require(!tradingOpen, "trading is already open");
382         uniswapV2Router = IUniswapV2Router02(
383             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
384         );
385         _approve(address(this), address(uniswapV2Router), _tTotal);
386         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
387             address(this),
388             uniswapV2Router.WETH()
389         );
390         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
391             address(this),
392             balanceOf(address(this)),
393             0,
394             0,
395             owner(),
396             block.timestamp
397         );
398         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
399         swapEnabled = true;
400         tradingOpen = true;
401     }
402 
403     receive() external payable {}
404 
405     function manualSwap() external {
406         require(_msgSender() == _taxWallet);
407         uint256 tokenBalance = balanceOf(address(this));
408         if (tokenBalance > 0) {
409             swapTokensForEth(tokenBalance);
410         }
411         uint256 ethBalance = address(this).balance;
412         if (ethBalance > 0) {
413             sendETHToFee(ethBalance);
414         }
415     }
416 }