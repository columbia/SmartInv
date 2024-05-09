1 // SPDX-License-Identifier: MIT
2 /*
3    Telegram: https://t.me/ElongateERC
4 */
5 pragma solidity ^0.8.18;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address account) external view returns (uint256);
17 
18     function transfer(
19         address recipient,
20         uint256 amount
21     ) external returns (bool);
22 
23     function allowance(
24         address owner,
25         address spender
26     ) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(
38         address indexed owner,
39         address indexed spender,
40         uint256 value
41     );
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(
56         uint256 a,
57         uint256 b,
58         string memory errorMessage
59     ) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(
79         uint256 a,
80         uint256 b,
81         string memory errorMessage
82     ) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         return c;
86     }
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91     event OwnershipTransferred(
92         address indexed previousOwner,
93         address indexed newOwner
94     );
95 
96     constructor() {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101 
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     function renounceOwnership() public virtual onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 }
116 
117 interface IUniswapV2Factory {
118     function createPair(
119         address tokenA,
120         address tokenB
121     ) external returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external;
132 
133     function factory() external pure returns (address);
134 
135     function WETH() external pure returns (address);
136 
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     )
145         external
146         payable
147         returns (uint amountToken, uint amountETH, uint liquidity);
148 }
149 
150 contract ELONGATE is Context, IERC20, Ownable {
151     using SafeMath for uint256;
152     mapping(address => uint256) private _balances;
153     mapping(address => mapping(address => uint256)) private _allowances;
154     mapping(address => bool) private _isExcludedFromFee;
155     mapping(address => bool) private bots;
156     mapping(address => uint256) private _holderLastTransferTimestamp;
157     bool public transferDelayEnabled = true;
158     address payable private _taxWallet;
159 
160     uint256 private _initialBuyTax = 21;
161     uint256 private _initialSellTax = 21;
162     uint256 private _finalBuyTax = 0;
163     uint256 private _finalSellTax = 0;
164     uint256 private _reduceBuyTaxAt = 20;
165     uint256 private _reduceSellTaxAt = 20;
166     uint256 private _preventSwapBefore = 20;
167     uint256 private _buyCount = 0;
168 
169     uint8 private constant _decimals = 18;
170     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
171     string private constant _name = unicode"Elongate";
172     string private constant _symbol = unicode"ELONGATE";
173     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
174     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
175     uint256 public _taxSwapThreshold = 1000000 * 10 ** _decimals;
176     uint256 public _maxTaxSwap = 1000000 * 10 ** _decimals;
177 
178     IUniswapV2Router02 private uniswapV2Router;
179     address private uniswapV2Pair;
180     bool private tradingOpen;
181     bool private inSwap = false;
182     bool private swapEnabled = false;
183 
184     event MaxTxAmountUpdated(uint _maxTxAmount);
185     modifier lockTheSwap() {
186         inSwap = true;
187         _;
188         inSwap = false;
189     }
190 
191     constructor() {
192         _taxWallet = payable(_msgSender());
193         _balances[_msgSender()] = _tTotal;
194         _isExcludedFromFee[owner()] = true;
195         _isExcludedFromFee[address(this)] = true;
196         _isExcludedFromFee[_taxWallet] = true;
197 
198         emit Transfer(address(0), _msgSender(), _tTotal);
199     }
200 
201     function name() public pure returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public pure returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public pure returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public pure override returns (uint256) {
214         return _tTotal;
215     }
216 
217     function balanceOf(address account) public view override returns (uint256) {
218         return _balances[account];
219     }
220 
221     function transfer(
222         address recipient,
223         uint256 amount
224     ) public override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     function allowance(
230         address owner,
231         address spender
232     ) public view override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     function approve(
237         address spender,
238         uint256 amount
239     ) public override returns (bool) {
240         _approve(_msgSender(), spender, amount);
241         return true;
242     }
243 
244     function transferFrom(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) public override returns (bool) {
249         _transfer(sender, recipient, amount);
250         _approve(
251             sender,
252             _msgSender(),
253             _allowances[sender][_msgSender()].sub(
254                 amount,
255                 "ERC20: transfer amount exceeds allowance"
256             )
257         );
258         return true;
259     }
260 
261     function _approve(address owner, address spender, uint256 amount) private {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     function _transfer(address from, address to, uint256 amount) private {
269         require(from != address(0), "ERC20: transfer from the zero address");
270         require(to != address(0), "ERC20: transfer to the zero address");
271         require(amount > 0, "Transfer amount must be greater than zero");
272         uint256 taxAmount = 0;
273         if (from != owner() && to != owner()) {
274             taxAmount = amount
275                 .mul(
276                     (_buyCount > _reduceBuyTaxAt)
277                         ? _finalBuyTax
278                         : _initialBuyTax
279                 )
280                 .div(100);
281 
282             if (transferDelayEnabled) {
283                 if (
284                     to != address(uniswapV2Router) &&
285                     to != address(uniswapV2Pair)
286                 ) {
287                     require(
288                         _holderLastTransferTimestamp[tx.origin] < block.number,
289                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
290                     );
291                     _holderLastTransferTimestamp[tx.origin] = block.number;
292                 }
293             }
294 
295             if (
296                 from == uniswapV2Pair &&
297                 to != address(uniswapV2Router) &&
298                 !_isExcludedFromFee[to]
299             ) {
300                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
301                 require(
302                     balanceOf(to) + amount <= _maxWalletSize,
303                     "Exceeds the maxWalletSize."
304                 );
305                 _buyCount++;
306             }
307 
308             if (to == uniswapV2Pair && from != address(this)) {
309                 taxAmount = amount
310                     .mul(
311                         (_buyCount > _reduceSellTaxAt)
312                             ? _finalSellTax
313                             : _initialSellTax
314                     )
315                     .div(100);
316             }
317 
318             uint256 contractTokenBalance = balanceOf(address(this));
319             if (
320                 !inSwap &&
321                 to == uniswapV2Pair &&
322                 swapEnabled &&
323                 contractTokenBalance > _taxSwapThreshold &&
324                 _buyCount > _preventSwapBefore
325             ) {
326                 swapTokensForEth(
327                     min(amount, min(contractTokenBalance, _maxTaxSwap))
328                 );
329                 uint256 contractETHBalance = address(this).balance;
330                 if (contractETHBalance > 50000000000000000) {
331                     sendETHToFee(address(this).balance);
332                 }
333             }
334         }
335 
336         if (taxAmount > 0) {
337             _balances[address(this)] = _balances[address(this)].add(taxAmount);
338             emit Transfer(from, address(this), taxAmount);
339         }
340         _balances[from] = _balances[from].sub(amount);
341         _balances[to] = _balances[to].add(amount.sub(taxAmount));
342         emit Transfer(from, to, amount.sub(taxAmount));
343     }
344 
345     function min(uint256 a, uint256 b) private pure returns (uint256) {
346         return (a > b) ? b : a;
347     }
348 
349     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
350         address[] memory path = new address[](2);
351         path[0] = address(this);
352         path[1] = uniswapV2Router.WETH();
353         _approve(address(this), address(uniswapV2Router), tokenAmount);
354         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
355             tokenAmount,
356             0,
357             path,
358             address(this),
359             block.timestamp
360         );
361     }
362 
363     function removeLimits() external onlyOwner {
364         _maxTxAmount = _tTotal;
365         _maxWalletSize = _tTotal;
366         transferDelayEnabled = false;
367         emit MaxTxAmountUpdated(_tTotal);
368     }
369 
370     function sendETHToFee(uint256 amount) private {
371         _taxWallet.transfer(amount);
372     }
373 
374     function openTrading() external onlyOwner {
375         require(!tradingOpen, "trading is already open");
376         uniswapV2Router = IUniswapV2Router02(
377             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
378         );
379         _approve(address(this), address(uniswapV2Router), _tTotal);
380         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
381             address(this),
382             uniswapV2Router.WETH()
383         );
384         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
385             address(this),
386             balanceOf(address(this)),
387             0,
388             0,
389             owner(),
390             block.timestamp
391         );
392         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
393         swapEnabled = true;
394         tradingOpen = true;
395     }
396 
397     receive() external payable {}
398 
399     function manualSwap() external {
400         require(_msgSender() == _taxWallet);
401         uint256 tokenBalance = balanceOf(address(this));
402         if (tokenBalance > 0) {
403             swapTokensForEth(tokenBalance);
404         }
405         uint256 ethBalance = address(this).balance;
406         if (ethBalance > 0) {
407             sendETHToFee(ethBalance);
408         }
409     }
410 }