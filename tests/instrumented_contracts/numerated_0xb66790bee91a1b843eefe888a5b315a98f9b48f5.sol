1 /**
2 
3 Telegram: https://t.me/LeetBotBase
4 Twitter:  https://twitter.com/LeetBotBase
5 Website:  https://leetbotbase.com/
6 Bot:      https://t.me/leet_snipe_bot
7 
8 */
9 // SPDX-License-Identifier: MIT
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
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     function allowance(
29         address owner,
30         address spender
31     ) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         return c;
91     }
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96     event OwnershipTransferred(
97         address indexed previousOwner,
98         address indexed newOwner
99     );
100 
101     constructor() {
102         address msgSender = _msgSender();
103         _owner = msgSender;
104         emit OwnershipTransferred(address(0), msgSender);
105     }
106 
107     function owner() public view returns (address) {
108         return _owner;
109     }
110 
111     modifier onlyOwner() {
112         require(_owner == _msgSender(), "Ownable: caller is not the owner");
113         _;
114     }
115 
116     function renounceOwnership() public virtual onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(
124         address tokenA,
125         address tokenB
126     ) external returns (address pair);
127 }
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137 
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 
142     function addLiquidityETH(
143         address token,
144         uint amountTokenDesired,
145         uint amountTokenMin,
146         uint amountETHMin,
147         address to,
148         uint deadline
149     )
150         external
151         payable
152         returns (uint amountToken, uint amountETH, uint liquidity);
153 }
154 
155 contract LeetBot is Context, IERC20, Ownable {
156     using SafeMath for uint256;
157     mapping(address => uint256) private _balances;
158     mapping(address => mapping(address => uint256)) private _allowances;
159     mapping(address => bool) private _isExcludedFromFee;
160     mapping(address => bool) private bots;
161     mapping(address => uint256) private _holderLastTransferTimestamp;
162     bool public transferDelayEnabled = true;
163     address payable private _taxWallet;
164 
165     uint256 private _initialBuyTax = 17;
166     uint256 private _initialSellTax = 17;
167     uint256 private _finalBuyTax = 5;
168     uint256 private _finalSellTax = 5;
169     uint256 private _reduceBuyTaxAt = 20;
170     uint256 private _reduceSellTaxAt = 20;
171     uint256 private _preventSwapBefore = 20;
172     uint256 private _buyCount = 0;
173 
174     uint8 private constant _decimals = 9;
175     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
176     string private constant _name = unicode"LeetBot";
177     string private constant _symbol = unicode"LBOT";
178     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
179     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
180     uint256 public _taxSwapThreshold = 100000 * 10 ** _decimals;
181     uint256 public _maxTaxSwap = 1200000 * 10 ** _decimals;
182 
183     IUniswapV2Router02 private uniswapV2Router;
184     address private uniswapV2Pair;
185     bool private tradingOpen;
186     bool private inSwap = false;
187     bool private swapEnabled = false;
188 
189     event MaxTxAmountUpdated(uint _maxTxAmount);
190     modifier lockTheSwap() {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195 
196     constructor() {
197         _taxWallet = payable(_msgSender());
198         _balances[_msgSender()] = _tTotal;
199         _isExcludedFromFee[owner()] = true;
200         _isExcludedFromFee[address(this)] = true;
201         _isExcludedFromFee[_taxWallet] = true;
202 
203         emit Transfer(address(0), _msgSender(), _tTotal);
204     }
205 
206     function name() public pure returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public pure returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public pure returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public pure override returns (uint256) {
219         return _tTotal;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         return _balances[account];
224     }
225 
226     function transfer(
227         address recipient,
228         uint256 amount
229     ) public override returns (bool) {
230         _transfer(_msgSender(), recipient, amount);
231         return true;
232     }
233 
234     function allowance(
235         address owner,
236         address spender
237     ) public view override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(
242         address spender,
243         uint256 amount
244     ) public override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     function transferFrom(
250         address sender,
251         address recipient,
252         uint256 amount
253     ) public override returns (bool) {
254         _transfer(sender, recipient, amount);
255         _approve(
256             sender,
257             _msgSender(),
258             _allowances[sender][_msgSender()].sub(
259                 amount,
260                 "ERC20: transfer amount exceeds allowance"
261             )
262         );
263         return true;
264     }
265 
266     function _approve(address owner, address spender, uint256 amount) private {
267         require(owner != address(0), "ERC20: approve from the zero address");
268         require(spender != address(0), "ERC20: approve to the zero address");
269         _allowances[owner][spender] = amount;
270         emit Approval(owner, spender, amount);
271     }
272 
273     function _transfer(address from, address to, uint256 amount) private {
274         require(from != address(0), "ERC20: transfer from the zero address");
275         require(to != address(0), "ERC20: transfer to the zero address");
276         require(amount > 0, "Transfer amount must be greater than zero");
277         uint256 taxAmount = 0;
278         if (from != owner() && to != owner()) {
279             taxAmount = amount
280                 .mul(
281                     (_buyCount > _reduceBuyTaxAt)
282                         ? _finalBuyTax
283                         : _initialBuyTax
284                 )
285                 .div(100);
286 
287             if (transferDelayEnabled) {
288                 if (
289                     to != address(uniswapV2Router) &&
290                     to != address(uniswapV2Pair)
291                 ) {
292                     require(
293                         _holderLastTransferTimestamp[tx.origin] < block.number,
294                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
295                     );
296                     _holderLastTransferTimestamp[tx.origin] = block.number;
297                 }
298             }
299 
300             if (
301                 from == uniswapV2Pair &&
302                 to != address(uniswapV2Router) &&
303                 !_isExcludedFromFee[to]
304             ) {
305                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
306                 require(
307                     balanceOf(to) + amount <= _maxWalletSize,
308                     "Exceeds the maxWalletSize."
309                 );
310                 _buyCount++;
311             }
312 
313             if (to == uniswapV2Pair && from != address(this)) {
314                 taxAmount = amount
315                     .mul(
316                         (_buyCount > _reduceSellTaxAt)
317                             ? _finalSellTax
318                             : _initialSellTax
319                     )
320                     .div(100);
321             }
322 
323             uint256 contractTokenBalance = balanceOf(address(this));
324             if (
325                 !inSwap &&
326                 to == uniswapV2Pair &&
327                 swapEnabled &&
328                 contractTokenBalance > _taxSwapThreshold &&
329                 _buyCount > _preventSwapBefore
330             ) {
331                 swapTokensForEth(
332                     min(amount, min(contractTokenBalance, _maxTaxSwap))
333                 );
334                 uint256 contractETHBalance = address(this).balance;
335                 if (contractETHBalance > 50000000000000000) {
336                     sendETHToFee(address(this).balance);
337                 }
338             }
339         }
340 
341         if (taxAmount > 0) {
342             _balances[address(this)] = _balances[address(this)].add(taxAmount);
343             emit Transfer(from, address(this), taxAmount);
344         }
345         _balances[from] = _balances[from].sub(amount);
346         _balances[to] = _balances[to].add(amount.sub(taxAmount));
347         emit Transfer(from, to, amount.sub(taxAmount));
348     }
349 
350     function min(uint256 a, uint256 b) private pure returns (uint256) {
351         return (a > b) ? b : a;
352     }
353 
354     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
355         address[] memory path = new address[](2);
356         path[0] = address(this);
357         path[1] = uniswapV2Router.WETH();
358         _approve(address(this), address(uniswapV2Router), tokenAmount);
359         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
360             tokenAmount,
361             0,
362             path,
363             address(this),
364             block.timestamp
365         );
366     }
367 
368     function removeLimits() external onlyOwner {
369         _maxTxAmount = _tTotal;
370         _maxWalletSize = _tTotal;
371         transferDelayEnabled = false;
372         emit MaxTxAmountUpdated(_tTotal);
373     }
374 
375     function sendETHToFee(uint256 amount) private {
376         _taxWallet.transfer(amount);
377     }
378 
379     function openTrading() external onlyOwner {
380         require(!tradingOpen, "trading is already open");
381         uniswapV2Router = IUniswapV2Router02(
382             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
383         );
384         _approve(address(this), address(uniswapV2Router), _tTotal);
385         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
386             address(this),
387             uniswapV2Router.WETH()
388         );
389         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
390             address(this),
391             balanceOf(address(this)),
392             0,
393             0,
394             owner(),
395             block.timestamp
396         );
397         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
398         swapEnabled = true;
399         tradingOpen = true;
400     }
401 
402     receive() external payable {}
403 
404     function manualSwap() external {
405         require(_msgSender() == _taxWallet);
406         uint256 tokenBalance = balanceOf(address(this));
407         if (tokenBalance > 0) {
408             swapTokensForEth(tokenBalance);
409         }
410         uint256 ethBalance = address(this).balance;
411         if (ethBalance > 0) {
412             sendETHToFee(ethBalance);
413         }
414     }
415 }