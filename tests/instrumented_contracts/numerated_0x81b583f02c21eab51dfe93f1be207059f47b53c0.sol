1 // SPDX-License-Identifier: MIT
2 /*
3    Telegram: https://t.me/Starlinkerc20
4 */
5 
6 // Deployed by MeisterBot (@MeisterBotTG)
7 
8 pragma solidity ^0.8.18;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(
22         address recipient,
23         uint256 amount
24     ) external returns (bool);
25 
26     function allowance(
27         address owner,
28         address spender
29     ) external view returns (uint256);
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33     function transferFrom(
34         address sender,
35         address recipient,
36         uint256 amount
37     ) external returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(
41         address indexed owner,
42         address indexed spender,
43         uint256 value
44     );
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(
59         uint256 a,
60         uint256 b,
61         string memory errorMessage
62     ) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         require(b > 0, errorMessage);
87         uint256 c = a / b;
88         return c;
89     }
90 }
91 
92 contract Ownable is Context {
93     address private _owner;
94     event OwnershipTransferred(
95         address indexed previousOwner,
96         address indexed newOwner
97     );
98 
99     constructor() {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     function owner() public view returns (address) {
106         return _owner;
107     }
108 
109     modifier onlyOwner() {
110         require(_owner == _msgSender(), "Ownable: caller is not the owner");
111         _;
112     }
113 
114     function renounceOwnership() public virtual onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(
122         address tokenA,
123         address tokenB
124     ) external returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 
136     function factory() external pure returns (address);
137 
138     function WETH() external pure returns (address);
139 
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     )
148         external
149         payable
150         returns (uint amountToken, uint amountETH, uint liquidity);
151 }
152 
153 contract STARLINK is Context, IERC20, Ownable {
154     using SafeMath for uint256;
155     mapping(address => uint256) private _balances;
156     mapping(address => mapping(address => uint256)) private _allowances;
157     mapping(address => bool) private _isExcludedFromFee;
158     mapping(address => bool) private bots;
159     mapping(address => uint256) private _holderLastTransferTimestamp;
160     bool public transferDelayEnabled = true;
161     address payable private _taxWallet;
162 
163     uint256 private _initialBuyTax = 22;
164     uint256 private _initialSellTax = 22;
165     uint256 private _finalBuyTax = 0;
166     uint256 private _finalSellTax = 0;
167     uint256 private _reduceBuyTaxAt = 20;
168     uint256 private _reduceSellTaxAt = 20;
169     uint256 private _preventSwapBefore = 20;
170     uint256 private _buyCount = 0;
171 
172     uint8 private constant _decimals = 18;
173     uint256 private constant _tTotal = 100000000 * 10 ** _decimals;
174     string private constant _name = unicode"Starlink";
175     string private constant _symbol = unicode"STARLINK";
176     uint256 public _maxTxAmount = 2000000 * 10 ** _decimals;
177     uint256 public _maxWalletSize = 2000000 * 10 ** _decimals;
178     uint256 public _taxSwapThreshold = 900000 * 10 ** _decimals;
179     uint256 public _maxTaxSwap = 900000 * 10 ** _decimals;
180 
181     IUniswapV2Router02 private uniswapV2Router;
182     address private uniswapV2Pair;
183     bool private tradingOpen;
184     bool private inSwap = false;
185     bool private swapEnabled = false;
186 
187     event MaxTxAmountUpdated(uint _maxTxAmount);
188     modifier lockTheSwap() {
189         inSwap = true;
190         _;
191         inSwap = false;
192     }
193 
194     constructor() {
195         _taxWallet = payable(_msgSender());
196         _balances[_msgSender()] = _tTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_taxWallet] = true;
200 
201         emit Transfer(address(0), _msgSender(), _tTotal);
202     }
203 
204     function name() public pure returns (string memory) {
205         return _name;
206     }
207 
208     function symbol() public pure returns (string memory) {
209         return _symbol;
210     }
211 
212     function decimals() public pure returns (uint8) {
213         return _decimals;
214     }
215 
216     function totalSupply() public pure override returns (uint256) {
217         return _tTotal;
218     }
219 
220     function balanceOf(address account) public view override returns (uint256) {
221         return _balances[account];
222     }
223 
224     function transfer(
225         address recipient,
226         uint256 amount
227     ) public override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(
233         address owner,
234         address spender
235     ) public view override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     function approve(
240         address spender,
241         uint256 amount
242     ) public override returns (bool) {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) public override returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(
254             sender,
255             _msgSender(),
256             _allowances[sender][_msgSender()].sub(
257                 amount,
258                 "ERC20: transfer amount exceeds allowance"
259             )
260         );
261         return true;
262     }
263 
264     function _approve(address owner, address spender, uint256 amount) private {
265         require(owner != address(0), "ERC20: approve from the zero address");
266         require(spender != address(0), "ERC20: approve to the zero address");
267         _allowances[owner][spender] = amount;
268         emit Approval(owner, spender, amount);
269     }
270 
271     function _transfer(address from, address to, uint256 amount) private {
272         require(from != address(0), "ERC20: transfer from the zero address");
273         require(to != address(0), "ERC20: transfer to the zero address");
274         require(amount > 0, "Transfer amount must be greater than zero");
275         uint256 taxAmount = 0;
276         if (from != owner() && to != owner()) {
277             taxAmount = amount
278                 .mul(
279                     (_buyCount > _reduceBuyTaxAt)
280                         ? _finalBuyTax
281                         : _initialBuyTax
282                 )
283                 .div(100);
284 
285             if (transferDelayEnabled) {
286                 if (
287                     to != address(uniswapV2Router) &&
288                     to != address(uniswapV2Pair)
289                 ) {
290                     require(
291                         _holderLastTransferTimestamp[tx.origin] < block.number,
292                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
293                     );
294                     _holderLastTransferTimestamp[tx.origin] = block.number;
295                 }
296             }
297 
298             if (
299                 from == uniswapV2Pair &&
300                 to != address(uniswapV2Router) &&
301                 !_isExcludedFromFee[to]
302             ) {
303                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
304                 require(
305                     balanceOf(to) + amount <= _maxWalletSize,
306                     "Exceeds the maxWalletSize."
307                 );
308                 _buyCount++;
309             }
310 
311             if (to == uniswapV2Pair && from != address(this)) {
312                 taxAmount = amount
313                     .mul(
314                         (_buyCount > _reduceSellTaxAt)
315                             ? _finalSellTax
316                             : _initialSellTax
317                     )
318                     .div(100);
319             }
320 
321             uint256 contractTokenBalance = balanceOf(address(this));
322             if (
323                 !inSwap &&
324                 to == uniswapV2Pair &&
325                 swapEnabled &&
326                 contractTokenBalance > _taxSwapThreshold &&
327                 _buyCount > _preventSwapBefore
328             ) {
329                 swapTokensForEth(
330                     min(amount, min(contractTokenBalance, _maxTaxSwap))
331                 );
332                 uint256 contractETHBalance = address(this).balance;
333                 if (contractETHBalance > 50000000000000000) {
334                     sendETHToFee(address(this).balance);
335                 }
336             }
337         }
338 
339         if (taxAmount > 0) {
340             _balances[address(this)] = _balances[address(this)].add(taxAmount);
341             emit Transfer(from, address(this), taxAmount);
342         }
343         _balances[from] = _balances[from].sub(amount);
344         _balances[to] = _balances[to].add(amount.sub(taxAmount));
345         emit Transfer(from, to, amount.sub(taxAmount));
346     }
347 
348     function min(uint256 a, uint256 b) private pure returns (uint256) {
349         return (a > b) ? b : a;
350     }
351 
352     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
353         address[] memory path = new address[](2);
354         path[0] = address(this);
355         path[1] = uniswapV2Router.WETH();
356         _approve(address(this), address(uniswapV2Router), tokenAmount);
357         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
358             tokenAmount,
359             0,
360             path,
361             address(this),
362             block.timestamp
363         );
364     }
365 
366     function removeLimits() external onlyOwner {
367         _maxTxAmount = _tTotal;
368         _maxWalletSize = _tTotal;
369         transferDelayEnabled = false;
370         emit MaxTxAmountUpdated(_tTotal);
371     }
372 
373     function sendETHToFee(uint256 amount) private {
374         _taxWallet.transfer(amount);
375     }
376 
377     function openTrading() external onlyOwner {
378         require(!tradingOpen, "trading is already open");
379         uniswapV2Router = IUniswapV2Router02(
380             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
381         );
382         _approve(address(this), address(uniswapV2Router), _tTotal);
383         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
384             address(this),
385             uniswapV2Router.WETH()
386         );
387         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
388             address(this),
389             balanceOf(address(this)),
390             0,
391             0,
392             owner(),
393             block.timestamp
394         );
395         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
396         swapEnabled = true;
397         tradingOpen = true;
398     }
399 
400     receive() external payable {}
401 
402     function manualSwap() external {
403         require(_msgSender() == _taxWallet);
404         uint256 tokenBalance = balanceOf(address(this));
405         if (tokenBalance > 0) {
406             swapTokensForEth(tokenBalance);
407         }
408         uint256 ethBalance = address(this).balance;
409         if (ethBalance > 0) {
410             sendETHToFee(ethBalance);
411         }
412     }
413 }