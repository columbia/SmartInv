1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 ___________      .__                   .___ ___________                .___ ___________           .__     
6 \_   _____/______|__| ____   ____    __| _/ \_   _____/_ __  ____    __| _/ \__    ___/___   ____ |  |__  
7  |    __) \_  __ \  |/ __ \ /    \  / __ |   |    __)|  |  \/    \  / __ |    |    |_/ __ \_/ ___\|  |  \ 
8  |     \   |  | \/  \  ___/|   |  \/ /_/ |   |     \ |  |  /   |  \/ /_/ |    |    |\  ___/\  \___|   Y  \
9  \___  /   |__|  |__|\___  >___|  /\____ |   \___  / |____/|___|  /\____ |    |____| \___  >\___  >___|  /
10      \/                  \/     \/      \/       \/             \/      \/               \/     \/     \/ 
11   Taxes: 5/5
12 
13   Telegram: https://t.me/friendfundtech
14   Twitter: https://twitter.com/friendtechfund
15   Website: https://friendfund.tech/
16   Docs: https://docs.friendfund.tech/
17 
18 */
19 
20 pragma solidity ^0.8.19;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address account) external view returns (uint256);
32 
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56 }
57 
58 library SafeMath {
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62         return c;
63     }
64 
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     function sub(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
76         return c;
77     }
78 
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         return c;
100     }
101 }
102 
103 contract Ownable is Context {
104     address private _owner;
105     event OwnershipTransferred(
106         address indexed previousOwner,
107         address indexed newOwner
108     );
109 
110     constructor() {
111         address msgSender = _msgSender();
112         _owner = msgSender;
113         emit OwnershipTransferred(address(0), msgSender);
114     }
115 
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     modifier onlyOwner() {
121         require(_owner == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     function renounceOwnership() public virtual onlyOwner {
126         emit OwnershipTransferred(_owner, address(0));
127         _owner = address(0);
128     }
129 }
130 
131 interface IUniswapV2Factory {
132     function createPair(address tokenA, address tokenB)
133         external
134         returns (address pair);
135 }
136 
137 interface IUniswapV2Router02 {
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint256 amountIn,
140         uint256 amountOutMin,
141         address[] calldata path,
142         address to,
143         uint256 deadline
144     ) external;
145 
146     function factory() external pure returns (address);
147 
148     function WETH() external pure returns (address);
149 
150     function addLiquidityETH(
151         address token,
152         uint256 amountTokenDesired,
153         uint256 amountTokenMin,
154         uint256 amountETHMin,
155         address to,
156         uint256 deadline
157     )
158         external
159         payable
160         returns (
161             uint256 amountToken,
162             uint256 amountETH,
163             uint256 liquidity
164         );
165 }
166 
167 contract FriendFundTech is Context, IERC20, Ownable {
168     using SafeMath for uint256;
169     mapping(address => uint256) private _balances;
170     mapping(address => mapping(address => uint256)) private _allowances;
171     mapping(address => bool) private _isExcludedFromFee;
172     mapping(address => bool) private bots;
173     mapping(address => uint256) private _holderLastTransferTimestamp;
174     bool public transferDelayEnabled = true;
175     address payable private _taxWallet;
176 
177     uint256 private _initialBuyTax;
178     uint256 private _initialSellTax;
179     uint256 private _midBuyTax;
180     uint256 private _midSellTax;
181     uint256 private _finalBuyTax;
182     uint256 private _finalSellTax;
183     uint256 private _reduceBuyTaxAt = 20;
184     uint256 private _reduceSellTaxAt = 20;
185     uint256 private _reduceFurtherBuyTaxAt = 35;
186     uint256 private _reduceFurtherSellTaxAt = 35;
187     uint256 private _preventSwapBefore = 25;
188     uint256 private _buyCount;
189 
190     uint8 private constant _decimals = 18;
191     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
192     string private constant _name =
193         unicode"Friend Fund Tech";
194     string private constant _symbol = unicode"FUND";
195     uint256 public _maxTxAmount = 10_000 * 10**_decimals;
196     uint256 public _maxWalletSize = 10_000 * 10**_decimals;
197     uint256 public _taxSwapThreshold = 5_000 * 10**_decimals;
198     uint256 public _maxTaxSwap = 5_000 * 10**_decimals;
199 
200     IUniswapV2Router02 private uniswapV2Router;
201     address private uniswapV2Pair;
202     bool private tradingOpen;
203     bool private inSwap = false;
204     bool private swapEnabled = false;
205 
206     event MaxTxAmountUpdated(uint256 _maxTxAmount);
207     modifier lockTheSwap() {
208         inSwap = true;
209         _;
210         inSwap = false;
211     }
212 
213     constructor() {
214         _taxWallet = payable(_msgSender());
215         _balances[_msgSender()] = _tTotal;
216         _isExcludedFromFee[owner()] = true;
217         _isExcludedFromFee[address(this)] = true;
218         _isExcludedFromFee[_taxWallet] = true;
219 
220         uniswapV2Router = IUniswapV2Router02(
221             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
222         );
223 
224         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
225             address(this),
226             uniswapV2Router.WETH()
227         );
228 
229         emit Transfer(address(0), _msgSender(), _tTotal);
230     }
231 
232     function name() public pure returns (string memory) {
233         return _name;
234     }
235 
236     function symbol() public pure returns (string memory) {
237         return _symbol;
238     }
239 
240     function decimals() public pure returns (uint8) {
241         return _decimals;
242     }
243 
244     function totalSupply() public pure override returns (uint256) {
245         return _tTotal;
246     }
247 
248     function balanceOf(address account) public view override returns (uint256) {
249         return _balances[account];
250     }
251 
252     function transfer(address recipient, uint256 amount)
253         public
254         override
255         returns (bool)
256     {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     function allowance(address owner, address spender)
262         public
263         view
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269 
270     function approve(address spender, uint256 amount)
271         public
272         override
273         returns (bool)
274     {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public override returns (bool) {
284         _transfer(sender, recipient, amount);
285         _approve(
286             sender,
287             _msgSender(),
288             _allowances[sender][_msgSender()].sub(
289                 amount,
290                 "ERC20: transfer amount exceeds allowance"
291             )
292         );
293         return true;
294     }
295 
296     function _approve(
297         address owner,
298         address spender,
299         uint256 amount
300     ) private {
301         require(owner != address(0), "ERC20: approve from the zero address");
302         require(spender != address(0), "ERC20: approve to the zero address");
303         _allowances[owner][spender] = amount;
304         emit Approval(owner, spender, amount);
305     }
306 
307     function _transfer(
308         address from,
309         address to,
310         uint256 amount
311     ) private {
312         require(from != address(0), "ERC20: transfer from the zero address");
313         require(to != address(0), "ERC20: transfer to the zero address");
314         require(amount > 0, "Transfer amount must be greater than zero");
315         uint256 taxAmount = 0;
316         if (from != owner() && to != owner()) {
317             if (transferDelayEnabled) {
318                 if (
319                     to != address(uniswapV2Router) &&
320                     to != address(uniswapV2Pair)
321                 ) {
322                     require(
323                         _holderLastTransferTimestamp[tx.origin] < block.number,
324                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
325                     );
326                     _holderLastTransferTimestamp[tx.origin] = block.number;
327                 }
328             }
329 
330             if (
331                 from == uniswapV2Pair &&
332                 to != address(uniswapV2Router) &&
333                 !_isExcludedFromFee[to]
334             ) {
335                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
336                 require(
337                     balanceOf(to) + amount <= _maxWalletSize,
338                     "Exceeds the maxWalletSize."
339                 );
340                 taxAmount = amount
341                     .mul(
342                         (_buyCount > _reduceBuyTaxAt)
343                             ? (
344                                 (_buyCount > _reduceFurtherBuyTaxAt)
345                                     ? _finalBuyTax
346                                     : _midBuyTax
347                             )
348                             : _initialBuyTax
349                     )
350                     .div(100);
351                 _buyCount++;
352             }
353 
354             if (to == uniswapV2Pair && from != address(this)) {
355                 taxAmount = amount
356                     .mul(
357                         (_buyCount > _reduceSellTaxAt)
358                             ? (
359                                 (_buyCount > _reduceFurtherSellTaxAt)
360                                     ? _finalSellTax
361                                     : _midSellTax
362                             )
363                             : _initialSellTax
364                     )
365                     .div(100);
366             }
367 
368             uint256 contractTokenBalance = balanceOf(address(this));
369             if (
370                 !inSwap &&
371                 to == uniswapV2Pair &&
372                 swapEnabled &&
373                 contractTokenBalance > _taxSwapThreshold &&
374                 _buyCount > _preventSwapBefore
375             ) {
376                 swapTokensForEth(
377                     min(amount, min(contractTokenBalance, _maxTaxSwap))
378                 );
379                 uint256 contractETHBalance = address(this).balance;
380                 if (contractETHBalance > 50000000000000000) {
381                     sendETHToFee(address(this).balance);
382                 }
383             }
384         }
385 
386         if (taxAmount > 0) {
387             _balances[address(this)] = _balances[address(this)].add(taxAmount);
388             emit Transfer(from, address(this), taxAmount);
389         }
390         _balances[from] = _balances[from].sub(amount);
391         _balances[to] = _balances[to].add(amount.sub(taxAmount));
392         emit Transfer(from, to, amount.sub(taxAmount));
393     }
394 
395     function min(uint256 a, uint256 b) private pure returns (uint256) {
396         return (a > b) ? b : a;
397     }
398 
399     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
400         address[] memory path = new address[](2);
401         path[0] = address(this);
402         path[1] = uniswapV2Router.WETH();
403         _approve(address(this), address(uniswapV2Router), tokenAmount);
404         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
405             tokenAmount,
406             0,
407             path,
408             address(this),
409             block.timestamp
410         );
411     }
412 
413     function removeLimits() external onlyOwner {
414         _maxTxAmount = _tTotal;
415         _maxWalletSize = _tTotal;
416         transferDelayEnabled = false;
417         emit MaxTxAmountUpdated(_tTotal);
418     }
419 
420     function sendETHToFee(uint256 amount) private {
421         _taxWallet.transfer(amount);
422     }
423 
424     function openTrading() external onlyOwner {
425         require(!tradingOpen, "trading is already open");
426         _approve(address(this), address(uniswapV2Router), _tTotal);
427         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
428             address(this),
429             balanceOf(address(this)),
430             0,
431             0,
432             owner(),
433             block.timestamp
434         );
435         IERC20(uniswapV2Pair).approve(
436             address(uniswapV2Router),
437             type(uint256).max
438         );
439         _initialBuyTax = 40;
440         _initialSellTax = 40;
441         _midBuyTax = 20;
442         _midSellTax = 20;
443         _finalBuyTax = 5;
444         _finalSellTax = 5;
445         swapEnabled = true;
446         tradingOpen = true;
447     }
448 
449     receive() external payable {}
450 
451     function manualSwap() external {
452         require(_msgSender() == _taxWallet);
453         uint256 tokenBalance = balanceOf(address(this));
454         if (tokenBalance > 0) {
455             swapTokensForEth(tokenBalance);
456         }
457         uint256 ethBalance = address(this).balance;
458         if (ethBalance > 0) {
459             sendETHToFee(ethBalance);
460         }
461     }
462 }