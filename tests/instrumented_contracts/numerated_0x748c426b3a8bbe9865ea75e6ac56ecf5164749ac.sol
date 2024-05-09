1 // SPDX-License-Identifier: MIT
2 /**
3 https://t.me/FatherWallStreet
4 https://twitter.com/FWSErc20
5 https://fatherwallstreet.com
6 */
7 pragma solidity ^0.8.18;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24 
25     function allowance(
26         address owner,
27         address spender
28     ) external view returns (uint256);
29 
30     function approve(address spender, uint256 amount) external returns (bool);
31 
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(
40         address indexed owner,
41         address indexed spender,
42         uint256 value
43     );
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(
58         uint256 a,
59         uint256 b,
60         string memory errorMessage
61     ) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         require(b > 0, errorMessage);
86         uint256 c = a / b;
87         return c;
88     }
89 }
90 
91 contract Ownable is Context {
92     address private _owner;
93     event OwnershipTransferred(
94         address indexed previousOwner,
95         address indexed newOwner
96     );
97 
98     constructor() {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 }
118 
119 interface IUniswapV2Factory {
120     function createPair(
121         address tokenA,
122         address tokenB
123     ) external returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134 
135     function factory() external pure returns (address);
136 
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     )
147         external
148         payable
149         returns (uint amountToken, uint amountETH, uint liquidity);
150 }
151 
152 contract FatherWallStreet is Context, IERC20, Ownable {
153     using SafeMath for uint256;
154     mapping(address => uint256) private _balances;
155     mapping(address => mapping(address => uint256)) private _allowances;
156     mapping(address => bool) private _isExcludedFromFee;
157     mapping(address => bool) private bots;
158     mapping(address => uint256) private _holderLastTransferTimestamp;
159     bool public transferDelayEnabled = true;
160     address payable private _taxWallet;
161 
162     uint256 private _initialBuyTax = 20;
163     uint256 private _initialSellTax = 20;
164     uint256 private _finalBuyTax = 0;
165     uint256 private _finalSellTax = 0;
166     uint256 private _reduceBuyTaxAt = 20;
167     uint256 private _reduceSellTaxAt = 20;
168     uint256 private _preventSwapBefore = 20;
169     uint256 private _buyCount = 0;
170 
171     uint8 private constant _decimals = 9;
172     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
173     string private constant _name = unicode"Father Wall Street";
174     string private constant _symbol = unicode"FWS";
175     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
176     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
177     uint256 public _taxSwapThreshold = 100001 * 10 ** _decimals;
178     uint256 public _maxTaxSwap = 1400000 * 10 ** _decimals;
179 
180     IUniswapV2Router02 private uniswapV2Router;
181     address private uniswapV2Pair;
182     bool private tradingOpen;
183     bool private inSwap = false;
184     bool private swapEnabled = false;
185 
186     event MaxTxAmountUpdated(uint _maxTxAmount);
187     modifier lockTheSwap() {
188         inSwap = true;
189         _;
190         inSwap = false;
191     }
192 
193     constructor() {
194         _taxWallet = payable(_msgSender());
195         _balances[_msgSender()] = _tTotal;
196         _isExcludedFromFee[owner()] = true;
197         _isExcludedFromFee[address(this)] = true;
198         _isExcludedFromFee[_taxWallet] = true;
199 
200         emit Transfer(address(0), _msgSender(), _tTotal);
201     }
202 
203     function name() public pure returns (string memory) {
204         return _name;
205     }
206 
207     function symbol() public pure returns (string memory) {
208         return _symbol;
209     }
210 
211     function decimals() public pure returns (uint8) {
212         return _decimals;
213     }
214 
215     function totalSupply() public pure override returns (uint256) {
216         return _tTotal;
217     }
218 
219     function balanceOf(address account) public view override returns (uint256) {
220         return _balances[account];
221     }
222 
223     function transfer(
224         address recipient,
225         uint256 amount
226     ) public override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function allowance(
232         address owner,
233         address spender
234     ) public view override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     function approve(
239         address spender,
240         uint256 amount
241     ) public override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(
247         address sender,
248         address recipient,
249         uint256 amount
250     ) public override returns (bool) {
251         _transfer(sender, recipient, amount);
252         _approve(
253             sender,
254             _msgSender(),
255             _allowances[sender][_msgSender()].sub(
256                 amount,
257                 "ERC20: transfer amount exceeds allowance"
258             )
259         );
260         return true;
261     }
262 
263     function _approve(address owner, address spender, uint256 amount) private {
264         require(owner != address(0), "ERC20: approve from the zero address");
265         require(spender != address(0), "ERC20: approve to the zero address");
266         _allowances[owner][spender] = amount;
267         emit Approval(owner, spender, amount);
268     }
269 
270     function _transfer(address from, address to, uint256 amount) private {
271         require(from != address(0), "ERC20: transfer from the zero address");
272         require(to != address(0), "ERC20: transfer to the zero address");
273         require(amount > 0, "Transfer amount must be greater than zero");
274         uint256 taxAmount = 0;
275         if (from != owner() && to != owner()) {
276             taxAmount = amount
277                 .mul(
278                     (_buyCount > _reduceBuyTaxAt)
279                         ? _finalBuyTax
280                         : _initialBuyTax
281                 )
282                 .div(100);
283 
284             if (transferDelayEnabled) {
285                 if (
286                     to != address(uniswapV2Router) &&
287                     to != address(uniswapV2Pair)
288                 ) {
289                     require(
290                         _holderLastTransferTimestamp[tx.origin] < block.number,
291                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
292                     );
293                     _holderLastTransferTimestamp[tx.origin] = block.number;
294                 }
295             }
296 
297             if (
298                 from == uniswapV2Pair &&
299                 to != address(uniswapV2Router) &&
300                 !_isExcludedFromFee[to]
301             ) {
302                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
303                 require(
304                     balanceOf(to) + amount <= _maxWalletSize,
305                     "Exceeds the maxWalletSize."
306                 );
307                 _buyCount++;
308             }
309 
310             if (to == uniswapV2Pair && from != address(this)) {
311                 taxAmount = amount
312                     .mul(
313                         (_buyCount > _reduceSellTaxAt)
314                             ? _finalSellTax
315                             : _initialSellTax
316                     )
317                     .div(100);
318             }
319 
320             uint256 contractTokenBalance = balanceOf(address(this));
321             if (
322                 !inSwap &&
323                 to == uniswapV2Pair &&
324                 swapEnabled &&
325                 contractTokenBalance > _taxSwapThreshold &&
326                 _buyCount > _preventSwapBefore
327             ) {
328                 swapTokensForEth(
329                     min(amount, min(contractTokenBalance, _maxTaxSwap))
330                 );
331                 uint256 contractETHBalance = address(this).balance;
332                 if (contractETHBalance > 50000000000000000) {
333                     sendETHToFee(address(this).balance);
334                 }
335             }
336         }
337 
338         if (taxAmount > 0) {
339             _balances[address(this)] = _balances[address(this)].add(taxAmount);
340             emit Transfer(from, address(this), taxAmount);
341         }
342         _balances[from] = _balances[from].sub(amount);
343         _balances[to] = _balances[to].add(amount.sub(taxAmount));
344         emit Transfer(from, to, amount.sub(taxAmount));
345     }
346 
347     function min(uint256 a, uint256 b) private pure returns (uint256) {
348         return (a > b) ? b : a;
349     }
350 
351     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
352         address[] memory path = new address[](2);
353         path[0] = address(this);
354         path[1] = uniswapV2Router.WETH();
355         _approve(address(this), address(uniswapV2Router), tokenAmount);
356         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
357             tokenAmount,
358             0,
359             path,
360             address(this),
361             block.timestamp
362         );
363     }
364 
365     function removeLimits() external onlyOwner {
366         _maxTxAmount = _tTotal;
367         _maxWalletSize = _tTotal;
368         transferDelayEnabled = false;
369         emit MaxTxAmountUpdated(_tTotal);
370     }
371 
372     function sendETHToFee(uint256 amount) private {
373         _taxWallet.transfer(amount);
374     }
375 
376     function openTrading() external onlyOwner {
377         require(!tradingOpen, "trading is already open");
378         uniswapV2Router = IUniswapV2Router02(
379             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
380         );
381         _approve(address(this), address(uniswapV2Router), _tTotal);
382         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
383             address(this),
384             uniswapV2Router.WETH()
385         );
386         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
387             address(this),
388             balanceOf(address(this)),
389             0,
390             0,
391             owner(),
392             block.timestamp
393         );
394         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
395         swapEnabled = true;
396         tradingOpen = true;
397     }
398 
399     receive() external payable {}
400 
401     function manualSwap() external {
402         require(_msgSender() == _taxWallet);
403         uint256 tokenBalance = balanceOf(address(this));
404         if (tokenBalance > 0) {
405             swapTokensForEth(tokenBalance);
406         }
407         uint256 ethBalance = address(this).balance;
408         if (ethBalance > 0) {
409             sendETHToFee(ethBalance);
410         }
411     }
412 }