1 // SPDX-License-Identifier: MIT
2 
3 /*
4   PokeBets
5 
6   Telegram: https://t.me/pokebetserc
7   Twitter: http://Twitter.com/pbetstoken
8   Website: https://www.pokebets.io
9 
10 
11   Taxes: 5/5
12 */
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
24 
25     function balanceOf(address account) external view returns (uint256);
26 
27     function transfer(
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     function allowance(
33         address owner,
34         address spender
35     ) external view returns (uint256);
36 
37     function approve(address spender, uint256 amount) external returns (bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns (bool);
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51 }
52 
53 library SafeMath {
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(
65         uint256 a,
66         uint256 b,
67         string memory errorMessage
68     ) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71         return c;
72     }
73 
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b > 0, errorMessage);
93         uint256 c = a / b;
94         return c;
95     }
96 }
97 
98 contract Ownable is Context {
99     address private _owner;
100     event OwnershipTransferred(
101         address indexed previousOwner,
102         address indexed newOwner
103     );
104 
105     constructor() {
106         address msgSender = _msgSender();
107         _owner = msgSender;
108         emit OwnershipTransferred(address(0), msgSender);
109     }
110 
111     function owner() public view returns (address) {
112         return _owner;
113     }
114 
115     modifier onlyOwner() {
116         require(_owner == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     function renounceOwnership() public virtual onlyOwner {
121         emit OwnershipTransferred(_owner, address(0));
122         _owner = address(0);
123     }
124 }
125 
126 interface IUniswapV2Factory {
127     function createPair(
128         address tokenA,
129         address tokenB
130     ) external returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint amountIn,
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external;
141 
142     function factory() external pure returns (address);
143 
144     function WETH() external pure returns (address);
145 
146     function addLiquidityETH(
147         address token,
148         uint amountTokenDesired,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     )
154         external
155         payable
156         returns (uint amountToken, uint amountETH, uint liquidity);
157 }
158 
159 contract Pokebets is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161     mapping(address => uint256) private _balances;
162     mapping(address => mapping(address => uint256)) private _allowances;
163     mapping(address => bool) private _isExcludedFromFee;
164     mapping(address => bool) private bots;
165     mapping(address => uint256) private _holderLastTransferTimestamp;
166     bool public transferDelayEnabled = true;
167     address payable private _taxWallet;
168 
169     uint256 private _initialBuyTax;
170     uint256 private _initialSellTax;
171     uint256 private _finalBuyTax;
172     uint256 private _finalSellTax;
173     uint256 private _reduceBuyTaxAt = 25;
174     uint256 private _reduceSellTaxAt = 25;
175     uint256 private _preventSwapBefore = 25;
176     uint256 private _buyCount = 0;
177 
178     uint8 private constant _decimals = 9;
179     uint256 private constant _tTotal = 100_000_000 * 10 ** _decimals;
180     string private constant _name = unicode"Pokebets";
181     string private constant _symbol = unicode"PBETS";
182     uint256 public _maxTxAmount = 2_000_000 * 10 ** _decimals;
183     uint256 public _maxWalletSize = 2_000_000 * 10 ** _decimals;
184     uint256 public _taxSwapThreshold = 500_000 * 10 ** _decimals;
185     uint256 public _maxTaxSwap = 500_000 * 10 ** _decimals;
186 
187     IUniswapV2Router02 private uniswapV2Router;
188     address private uniswapV2Pair;
189     bool private tradingOpen;
190     bool private inSwap = false;
191     bool private swapEnabled = false;
192 
193     event MaxTxAmountUpdated(uint _maxTxAmount);
194     modifier lockTheSwap() {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199 
200     constructor() {
201         _taxWallet = payable(_msgSender());
202         _balances[_msgSender()] = _tTotal;
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[_taxWallet] = true;
206 
207         uniswapV2Router = IUniswapV2Router02(
208             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
209         );
210         
211         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
212             address(this),
213             uniswapV2Router.WETH()
214         );
215 
216         emit Transfer(address(0), _msgSender(), _tTotal);
217     }
218 
219     function name() public pure returns (string memory) {
220         return _name;
221     }
222 
223     function symbol() public pure returns (string memory) {
224         return _symbol;
225     }
226 
227     function decimals() public pure returns (uint8) {
228         return _decimals;
229     }
230 
231     function totalSupply() public pure override returns (uint256) {
232         return _tTotal;
233     }
234 
235     function balanceOf(address account) public view override returns (uint256) {
236         return _balances[account];
237     }
238 
239     function transfer(
240         address recipient,
241         uint256 amount
242     ) public override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     function allowance(
248         address owner,
249         address spender
250     ) public view override returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     function approve(
255         address spender,
256         uint256 amount
257     ) public override returns (bool) {
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261 
262     function transferFrom(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) public override returns (bool) {
267         _transfer(sender, recipient, amount);
268         _approve(
269             sender,
270             _msgSender(),
271             _allowances[sender][_msgSender()].sub(
272                 amount,
273                 "ERC20: transfer amount exceeds allowance"
274             )
275         );
276         return true;
277     }
278 
279     function _approve(address owner, address spender, uint256 amount) private {
280         require(owner != address(0), "ERC20: approve from the zero address");
281         require(spender != address(0), "ERC20: approve to the zero address");
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 
286     function _transfer(address from, address to, uint256 amount) private {
287         require(from != address(0), "ERC20: transfer from the zero address");
288         require(to != address(0), "ERC20: transfer to the zero address");
289         require(amount > 0, "Transfer amount must be greater than zero");
290         uint256 taxAmount = 0;
291         if (from != owner() && to != owner()) {
292             taxAmount = amount
293                 .mul(
294                     (_buyCount > _reduceBuyTaxAt)
295                         ? _finalBuyTax
296                         : _initialBuyTax
297                 )
298                 .div(100);
299 
300             if (transferDelayEnabled) {
301                 if (
302                     to != address(uniswapV2Router) &&
303                     to != address(uniswapV2Pair)
304                 ) {
305                     require(
306                         _holderLastTransferTimestamp[tx.origin] < block.number,
307                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
308                     );
309                     _holderLastTransferTimestamp[tx.origin] = block.number;
310                 }
311             }
312 
313             if (
314                 from == uniswapV2Pair &&
315                 to != address(uniswapV2Router) &&
316                 !_isExcludedFromFee[to]
317             ) {
318                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
319                 require(
320                     balanceOf(to) + amount <= _maxWalletSize,
321                     "Exceeds the maxWalletSize."
322                 );
323                 _buyCount++;
324             }
325 
326             if (to == uniswapV2Pair && from != address(this)) {
327                 taxAmount = amount
328                     .mul(
329                         (_buyCount > _reduceSellTaxAt)
330                             ? _finalSellTax
331                             : _initialSellTax
332                     )
333                     .div(100);
334             }
335 
336             uint256 contractTokenBalance = balanceOf(address(this));
337             if (
338                 !inSwap &&
339                 to == uniswapV2Pair &&
340                 swapEnabled &&
341                 contractTokenBalance > _taxSwapThreshold &&
342                 _buyCount > _preventSwapBefore
343             ) {
344                 swapTokensForEth(
345                     min(amount, min(contractTokenBalance, _maxTaxSwap))
346                 );
347                 uint256 contractETHBalance = address(this).balance;
348                 if (contractETHBalance > 50000000000000000) {
349                     sendETHToFee(address(this).balance);
350                 }
351             }
352         }
353 
354         if (taxAmount > 0) {
355             _balances[address(this)] = _balances[address(this)].add(taxAmount);
356             emit Transfer(from, address(this), taxAmount);
357         }
358         _balances[from] = _balances[from].sub(amount);
359         _balances[to] = _balances[to].add(amount.sub(taxAmount));
360         emit Transfer(from, to, amount.sub(taxAmount));
361     }
362 
363     function min(uint256 a, uint256 b) private pure returns (uint256) {
364         return (a > b) ? b : a;
365     }
366 
367     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
368         address[] memory path = new address[](2);
369         path[0] = address(this);
370         path[1] = uniswapV2Router.WETH();
371         _approve(address(this), address(uniswapV2Router), tokenAmount);
372         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
373             tokenAmount,
374             0,
375             path,
376             address(this),
377             block.timestamp
378         );
379     }
380 
381     function removeLimits() external onlyOwner {
382         _maxTxAmount = _tTotal;
383         _maxWalletSize = _tTotal;
384         transferDelayEnabled = false;
385         emit MaxTxAmountUpdated(_tTotal);
386     }
387 
388     function sendETHToFee(uint256 amount) private {
389         _taxWallet.transfer(amount);
390     }
391 
392     function openTrading() external onlyOwner {
393         require(!tradingOpen, "trading is already open");
394         _approve(address(this), address(uniswapV2Router), _tTotal);
395         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
396             address(this),
397             balanceOf(address(this)),
398             0,
399             0,
400             owner(),
401             block.timestamp
402         );
403         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
404         _initialBuyTax = 25;
405         _initialSellTax = 25;
406         _finalBuyTax = 5;
407         _finalSellTax = 5;
408         swapEnabled = true;
409         tradingOpen = true;
410         
411     }
412 
413     receive() external payable {}
414 
415     function manualSwap() external {
416         require(_msgSender() == _taxWallet);
417         uint256 tokenBalance = balanceOf(address(this));
418         if (tokenBalance > 0) {
419             swapTokensForEth(tokenBalance);
420         }
421         uint256 ethBalance = address(this).balance;
422         if (ethBalance > 0) {
423             sendETHToFee(ethBalance);
424         }
425     }
426 }