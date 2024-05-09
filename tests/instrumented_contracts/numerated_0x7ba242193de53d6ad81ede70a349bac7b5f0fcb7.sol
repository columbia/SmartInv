1 /**
2 
3   Telegram: https://t.me/TurboBot_TG
4   Twitter:  https://twitter.com/TurboBot_TG
5   Website:  https://turbobase.tech
6 
7 */
8 // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.20;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function transfer(
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26 
27     function allowance(
28         address owner,
29         address spender
30     ) external view returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(
60         uint256 a,
61         uint256 b,
62         string memory errorMessage
63     ) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 }
92 
93 contract Ownable is Context {
94     address private _owner;
95     event OwnershipTransferred(
96         address indexed previousOwner,
97         address indexed newOwner
98     );
99 
100     constructor() {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 }
120 
121 interface IUniswapV2Factory {
122     function createPair(
123         address tokenA,
124         address tokenB
125     ) external returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     )
149         external
150         payable
151         returns (uint amountToken, uint amountETH, uint liquidity);
152 }
153 
154 contract TurboBot is Context, IERC20, Ownable {
155     using SafeMath for uint256;
156     mapping(address => uint256) private _balances;
157     mapping(address => mapping(address => uint256)) private _allowances;
158     mapping(address => bool) private _isExcludedFromFee;
159     mapping(address => bool) private bots;
160     mapping(address => uint256) private _holderLastTransferTimestamp;
161     bool public transferDelayEnabled = true;
162     address payable private _taxWallet;
163 
164     uint256 private _initialBuyTax = 18;
165     uint256 private _initialSellTax = 18;
166     uint256 private _finalBuyTax = 5;
167     uint256 private _finalSellTax = 5;
168     uint256 private _reduceBuyTaxAt = 20;
169     uint256 private _reduceSellTaxAt = 20;
170     uint256 private _preventSwapBefore = 20;
171     uint256 private _buyCount = 0;
172 
173     uint8 private constant _decimals = 9;
174     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
175     string private constant _name = unicode"TurboBot";
176     string private constant _symbol = unicode"TBOT";
177     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
178     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
179     uint256 public _taxSwapThreshold = 100000 * 10 ** _decimals;
180     uint256 public _maxTaxSwap = 1200000 * 10 ** _decimals;
181 
182     IUniswapV2Router02 private uniswapV2Router;
183     address private uniswapV2Pair;
184     bool private tradingOpen;
185     bool private inSwap = false;
186     bool private swapEnabled = false;
187 
188     event MaxTxAmountUpdated(uint _maxTxAmount);
189     modifier lockTheSwap() {
190         inSwap = true;
191         _;
192         inSwap = false;
193     }
194 
195     constructor() {
196         _taxWallet = payable(_msgSender());
197         _balances[_msgSender()] = _tTotal;
198         _isExcludedFromFee[owner()] = true;
199         _isExcludedFromFee[address(this)] = true;
200         _isExcludedFromFee[_taxWallet] = true;
201 
202         emit Transfer(address(0), _msgSender(), _tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216 
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220 
221     function balanceOf(address account) public view override returns (uint256) {
222         return _balances[account];
223     }
224 
225     function transfer(
226         address recipient,
227         uint256 amount
228     ) public override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(
234         address owner,
235         address spender
236     ) public view override returns (uint256) {
237         return _allowances[owner][spender];
238     }
239 
240     function approve(
241         address spender,
242         uint256 amount
243     ) public override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(
249         address sender,
250         address recipient,
251         uint256 amount
252     ) public override returns (bool) {
253         _transfer(sender, recipient, amount);
254         _approve(
255             sender,
256             _msgSender(),
257             _allowances[sender][_msgSender()].sub(
258                 amount,
259                 "ERC20: transfer amount exceeds allowance"
260             )
261         );
262         return true;
263     }
264 
265     function _approve(address owner, address spender, uint256 amount) private {
266         require(owner != address(0), "ERC20: approve from the zero address");
267         require(spender != address(0), "ERC20: approve to the zero address");
268         _allowances[owner][spender] = amount;
269         emit Approval(owner, spender, amount);
270     }
271 
272     function _transfer(address from, address to, uint256 amount) private {
273         require(from != address(0), "ERC20: transfer from the zero address");
274         require(to != address(0), "ERC20: transfer to the zero address");
275         require(amount > 0, "Transfer amount must be greater than zero");
276         uint256 taxAmount = 0;
277         if (from != owner() && to != owner()) {
278             taxAmount = amount
279                 .mul(
280                     (_buyCount > _reduceBuyTaxAt)
281                         ? _finalBuyTax
282                         : _initialBuyTax
283                 )
284                 .div(100);
285 
286             if (transferDelayEnabled) {
287                 if (
288                     to != address(uniswapV2Router) &&
289                     to != address(uniswapV2Pair)
290                 ) {
291                     require(
292                         _holderLastTransferTimestamp[tx.origin] < block.number,
293                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
294                     );
295                     _holderLastTransferTimestamp[tx.origin] = block.number;
296                 }
297             }
298 
299             if (
300                 from == uniswapV2Pair &&
301                 to != address(uniswapV2Router) &&
302                 !_isExcludedFromFee[to]
303             ) {
304                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
305                 require(
306                     balanceOf(to) + amount <= _maxWalletSize,
307                     "Exceeds the maxWalletSize."
308                 );
309                 _buyCount++;
310             }
311 
312             if (to == uniswapV2Pair && from != address(this)) {
313                 taxAmount = amount
314                     .mul(
315                         (_buyCount > _reduceSellTaxAt)
316                             ? _finalSellTax
317                             : _initialSellTax
318                     )
319                     .div(100);
320             }
321 
322             uint256 contractTokenBalance = balanceOf(address(this));
323             if (
324                 !inSwap &&
325                 to == uniswapV2Pair &&
326                 swapEnabled &&
327                 contractTokenBalance > _taxSwapThreshold &&
328                 _buyCount > _preventSwapBefore
329             ) {
330                 swapTokensForEth(
331                     min(amount, min(contractTokenBalance, _maxTaxSwap))
332                 );
333                 uint256 contractETHBalance = address(this).balance;
334                 if (contractETHBalance > 50000000000000000) {
335                     sendETHToFee(address(this).balance);
336                 }
337             }
338         }
339 
340         if (taxAmount > 0) {
341             _balances[address(this)] = _balances[address(this)].add(taxAmount);
342             emit Transfer(from, address(this), taxAmount);
343         }
344         _balances[from] = _balances[from].sub(amount);
345         _balances[to] = _balances[to].add(amount.sub(taxAmount));
346         emit Transfer(from, to, amount.sub(taxAmount));
347     }
348 
349     function min(uint256 a, uint256 b) private pure returns (uint256) {
350         return (a > b) ? b : a;
351     }
352 
353     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
354         address[] memory path = new address[](2);
355         path[0] = address(this);
356         path[1] = uniswapV2Router.WETH();
357         _approve(address(this), address(uniswapV2Router), tokenAmount);
358         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
359             tokenAmount,
360             0,
361             path,
362             address(this),
363             block.timestamp
364         );
365     }
366 
367     function removeLimits() external onlyOwner {
368         _maxTxAmount = _tTotal;
369         _maxWalletSize = _tTotal;
370         transferDelayEnabled = false;
371         emit MaxTxAmountUpdated(_tTotal);
372     }
373 
374     function sendETHToFee(uint256 amount) private {
375         _taxWallet.transfer(amount);
376     }
377 
378     function openTrading() external onlyOwner {
379         require(!tradingOpen, "trading is already open");
380         uniswapV2Router = IUniswapV2Router02(
381             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
382         );
383         _approve(address(this), address(uniswapV2Router), _tTotal);
384         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
385             address(this),
386             uniswapV2Router.WETH()
387         );
388         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
389             address(this),
390             balanceOf(address(this)),
391             0,
392             0,
393             owner(),
394             block.timestamp
395         );
396         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
397         swapEnabled = true;
398         tradingOpen = true;
399     }
400 
401     receive() external payable {}
402 
403     function manualSwap() external {
404         require(_msgSender() == _taxWallet);
405         uint256 tokenBalance = balanceOf(address(this));
406         if (tokenBalance > 0) {
407             swapTokensForEth(tokenBalance);
408         }
409         uint256 ethBalance = address(this).balance;
410         if (ethBalance > 0) {
411             sendETHToFee(ethBalance);
412         }
413     }
414 }