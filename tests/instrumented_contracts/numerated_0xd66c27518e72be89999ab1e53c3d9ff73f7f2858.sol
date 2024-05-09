1 /**⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
2     HermioneGrangerClintonAmberAmyRose9Inu (TETHER)
3     is a community-focused, decentralized cryptocurrency
4     with instant rewards for holders.
5 
6     Website:  https://hgcaar9i.com/
7 **/
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.19;
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23 
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27         return c;
28     }
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42 
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 
49     function min(uint256 a, uint256 b) internal pure returns (uint256) {
50         return (a > b) ? b : a;
51     }
52 }
53 
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor() {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 }
84 
85 interface IERC20 {
86     function totalSupply() external view returns (uint256);
87 
88     function balanceOf(address account) external view returns (uint256);
89 
90     function transfer(address recipient, uint256 amount) external returns (bool);
91 
92     function allowance(address owner, address spender) external view returns (uint256);
93 
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     event Transfer(address indexed from, address indexed to, uint256 value);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114 
115     function factory() external pure returns (address);
116 
117     function WETH() external pure returns (address);
118 
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 }
128 
129 contract Tether is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131 
132     mapping(address => uint256) private _balances; // Balances
133     mapping(address => mapping(address => uint256)) private _allowances; // Allowances
134     mapping(address => bool) private _isExcludedFromFee; // Excluded from fees
135     mapping(address => bool) private _bots; // Bots
136     mapping(address => uint256) private _holderLastTransferTimestamp; // Used to prevent bots
137 
138     bool public transferDelayEnabled; // Delay transfers to prevent bots
139     address payable private _taxWallet; // Marketing wallet
140 
141     address private constant _UNISWAP_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // UniSwap Router V2 (mainnet)
142 
143     uint256 private _initialBuyTax; // Buy tax is always lower than sell tax
144     uint256 private _initialSellTax; // Sell tax is always higher than buy tax
145     uint256 private _finalBuyTax; // Buy tax is always lower than sell tax
146     uint256 private _finalSellTax; // Sell tax is always higher than buy tax
147     uint256 public _reduceBuyTaxAt; // Number of buys before tax is reduced
148     uint256 public _reduceSellTaxAt; // Number of buys before tax is reduced
149     uint256 private _preventSwapBefore; // Number of buys before swap is enabled
150     uint256 private _buyCount; // Number of buys since last sell
151 
152     uint8 private constant _decimals = 8;
153     uint256 private constant _tTotal = 999999999999 * 10 ** _decimals; // Total supply
154     string private constant _name = unicode"HermioneGrangerClintonAmberAmyRose9Inu";
155     string private constant _symbol = unicode"TETHER";
156     uint256 public _maxTxAmount = _tTotal; // Max transaction amount
157     uint256 public _maxWalletSize = _tTotal; // Max wallet size
158     uint256 public _taxSwapThreshold = 10000 * 10 ** _decimals; // Swap tokens for ETH when this many tokens are in contract
159     uint256 public _maxTaxSwap = _tTotal; // Max tokens to swap for ETH
160 
161     IUniswapV2Router02 private uniswapV2Router; // Uniswap V2 router
162     address private uniswapV2Pair; // Uniswap V2 pair
163     bool private tradingOpen; // Trading is enabled after launch
164     bool private inSwap; // Prevents swapping before liquidity is added
165     bool private swapEnabled; // Swap enabled
166 
167     // events for setters
168     event MaxTxAmountUpdated(uint _maxTxAmount);
169     event MaxWalletSizeUpdated(uint _maxWalletSize);
170     event TaxSwapThresholdUpdated(uint _taxSwapThreshold);
171     event MaxTaxSwapUpdated(uint _maxTaxSwap);
172     event TaxWalletUpdated(address _taxWallet);
173     event InitialBuyTaxUpdated(uint _initialBuyTax);
174     event InitialSellTaxUpdated(uint _initialSellTax);
175     event FinalBuyTaxUpdated(uint _finalBuyTax);
176     event FinalSellTaxUpdated(uint _finalSellTax);
177     event ReduceBuyTaxAtUpdated(uint _reduceBuyTaxAt);
178     event ReduceSellTaxAtUpdated(uint _reduceSellTaxAt);
179     event PreventSwapBeforeUpdated(uint _preventSwapBefore);
180     event TransferDelayEnabledUpdated(bool _enabled);
181     event SwapAndLiquifyEnabledUpdated(bool _enabled);
182     event MinTokensBeforeSwapUpdated(uint _minTokensBeforeSwap);
183     event BuybackMultiplierActive(uint256 duration);
184     event BuybackMultiplierRemoved();
185 
186     event ExcludeFromFee(address indexed account);
187     event IncludeInFee(address indexed account);
188 
189     constructor() {
190         _taxWallet = payable(_msgSender());
191         _balances[_msgSender()] = _tTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[_taxWallet] = true;
195 
196         emit Transfer(address(0), _msgSender(), _tTotal);
197     }
198 
199     receive() external payable {}
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
221     function transfer(address recipient, uint256 amount) public override returns (bool) {
222         _transfer(_msgSender(), recipient, amount);
223         return true;
224     }
225 
226     function allowance(address owner, address spender) public view override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     function approve(address spender, uint256 amount) public override returns (bool) {
231         _approve(_msgSender(), spender, amount);
232         return true;
233     }
234 
235     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
236         _transfer(sender, recipient, amount);
237         _approve(
238             sender,
239             _msgSender(),
240             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
241         );
242         return true;
243     }
244 
245     function removeLimits() external onlyOwner {
246         _maxTxAmount = _tTotal;
247         _maxWalletSize = _tTotal;
248         transferDelayEnabled = false;
249         _reduceSellTaxAt = 20;
250         _reduceBuyTaxAt = 20;
251         emit MaxTxAmountUpdated(_tTotal);
252     }
253 
254     // Setters
255     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
256         _maxTxAmount = maxTxAmount;
257         emit MaxTxAmountUpdated(maxTxAmount);
258     }
259 
260     function setMaxWalletSize(uint256 maxWalletSize) external onlyOwner {
261         _maxWalletSize = maxWalletSize;
262         emit MaxWalletSizeUpdated(maxWalletSize);
263     }
264 
265     function setTaxSwapThreshold(uint256 taxSwapThreshold) external onlyOwner {
266         _taxSwapThreshold = taxSwapThreshold;
267         emit TaxSwapThresholdUpdated(taxSwapThreshold);
268     }
269 
270     function setMaxTaxSwap(uint256 maxTaxSwap) external onlyOwner {
271         _maxTaxSwap = maxTaxSwap;
272         emit MaxTaxSwapUpdated(maxTaxSwap);
273     }
274 
275     function setTaxWallet(address payable taxWallet) external onlyOwner {
276         _taxWallet = taxWallet;
277         _isExcludedFromFee[taxWallet] = true;
278         emit TaxWalletUpdated(taxWallet);
279     }
280 
281     function setInitialBuyTax(uint256 initialBuyTax) external onlyOwner {
282         _initialBuyTax = initialBuyTax;
283         emit InitialBuyTaxUpdated(initialBuyTax);
284     }
285 
286     function setInitialSellTax(uint256 initialSellTax) external onlyOwner {
287         _initialSellTax = initialSellTax;
288         emit InitialSellTaxUpdated(initialSellTax);
289     }
290 
291     function setFinalBuyTax(uint256 finalBuyTax) external onlyOwner {
292         _finalBuyTax = finalBuyTax;
293         emit FinalBuyTaxUpdated(finalBuyTax);
294     }
295 
296     function setFinalSellTax(uint256 finalSellTax) external onlyOwner {
297         _finalSellTax = finalSellTax;
298         emit FinalSellTaxUpdated(finalSellTax);
299     }
300 
301     function setReduceBuyTaxAt(uint256 reduceBuyTaxAt) external onlyOwner {
302         _reduceBuyTaxAt = reduceBuyTaxAt;
303         emit ReduceBuyTaxAtUpdated(reduceBuyTaxAt);
304     }
305 
306     function setReduceSellTaxAt(uint256 reduceSellTaxAt) external onlyOwner {
307         _reduceSellTaxAt = reduceSellTaxAt;
308         emit ReduceSellTaxAtUpdated(reduceSellTaxAt);
309     }
310 
311     function setPreventSwapBefore(uint256 preventSwapBefore) external onlyOwner {
312         _preventSwapBefore = preventSwapBefore;
313         emit PreventSwapBeforeUpdated(preventSwapBefore);
314     }
315 
316     function setTransferDelayEnabled(bool _enabled) external onlyOwner {
317         transferDelayEnabled = _enabled;
318         emit TransferDelayEnabledUpdated(_enabled);
319     }
320 
321     // functions exclude/include from fee
322     function excludeFromFee(address account) external onlyOwner {
323         _isExcludedFromFee[account] = true;
324         emit ExcludeFromFee(account);
325     }
326 
327     function includeInFee(address account) external onlyOwner {
328         _isExcludedFromFee[account] = false;
329         emit IncludeInFee(account);
330     }
331 
332     function gottagofast() external onlyOwner {
333         require(!tradingOpen, "trading is already open");
334         uniswapV2Router = IUniswapV2Router02(_UNISWAP_ROUTER);
335         _approve(address(this), address(uniswapV2Router), _tTotal);
336         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
337         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
338             address(this),
339             balanceOf(address(this)),
340             0,
341             0,
342             owner(),
343             block.timestamp
344         );
345         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
346         swapEnabled = true;
347         tradingOpen = true;
348     }
349 
350     function manualSwap() external {
351         require(_msgSender() == _taxWallet);
352         uint256 tokenBalance = balanceOf(address(this));
353         if (tokenBalance > 0) {
354             _swapTokensForEth(tokenBalance);
355         }
356         uint256 ethBalance = address(this).balance;
357         if (ethBalance > 0) {
358             _sendETHToFee(ethBalance);
359         }
360     }
361 
362     function addBots(address[] calldata bots_) external onlyOwner {
363         for (uint256 i; i < bots_.length; ) {
364             _bots[bots_[i]] = true;
365             unchecked {
366                 ++i;
367             }
368         }
369     }
370 
371     function delBots(address[] calldata notbot) external onlyOwner {
372         for (uint256 i; i < notbot.length; ) {
373             _bots[notbot[i]] = false;
374             unchecked {
375                 ++i;
376             }
377         }
378     }
379 
380     function isBot(address a) public view returns (bool) {
381         return _bots[a];
382     }
383 
384     function _approve(address owner, address spender, uint256 amount) private {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387         _allowances[owner][spender] = amount;
388         emit Approval(owner, spender, amount);
389     }
390 
391     function _transfer(address from, address to, uint256 amount) private {
392         require(from != address(0), "ERC20: transfer from the zero address");
393         require(to != address(0), "ERC20: transfer to the zero address");
394         require(amount > 0, "Transfer amount must be greater than zero");
395         uint256 taxAmount = 0;
396         if (from != owner() && to != owner()) {
397             require(!_bots[from] && !_bots[to]);
398 
399             if (transferDelayEnabled) {
400                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
401                     require(
402                         _holderLastTransferTimestamp[tx.origin] < block.number,
403                         "Only one transfer per block allowed."
404                     );
405                     _holderLastTransferTimestamp[tx.origin] = block.number;
406                 }
407             }
408 
409             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
410                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
411                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
412                 _buyCount++;
413             }
414 
415             taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
416             if (to == uniswapV2Pair && from != address(this)) {
417                 taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
418             }
419 
420             uint256 contractTokenBalance = balanceOf(address(this));
421             if (
422                 !inSwap &&
423             to == uniswapV2Pair &&
424             swapEnabled &&
425             contractTokenBalance > _taxSwapThreshold &&
426             _buyCount > _preventSwapBefore
427             ) {
428                 _swapTokensForEth(SafeMath.min(amount, SafeMath.min(contractTokenBalance, _maxTaxSwap)));
429                 uint256 contractETHBalance = address(this).balance;
430                 if (contractETHBalance > 0) {
431                     _sendETHToFee(address(this).balance);
432                 }
433             }
434         }
435         if (taxAmount > 0) {
436             _balances[address(this)] = _balances[address(this)].add(taxAmount);
437             emit Transfer(from, address(this), taxAmount);
438         }
439         _balances[from] = _balances[from].sub(amount);
440         _balances[to] = _balances[to].add(amount.sub(taxAmount));
441         emit Transfer(from, to, amount.sub(taxAmount));
442     }
443 
444     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
445         if (tokenAmount == 0) {
446             return;
447         }
448         if (!tradingOpen) {
449             return;
450         }
451         address[] memory path = new address[](2);
452         path[0] = address(this);
453         path[1] = uniswapV2Router.WETH();
454         _approve(address(this), address(uniswapV2Router), tokenAmount);
455         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
456             tokenAmount,
457             0,
458             path,
459             address(this),
460             block.timestamp
461         );
462     }
463 
464     function _sendETHToFee(uint256 amount) private {
465         _taxWallet.transfer(amount);
466     }
467 
468     modifier lockTheSwap() {
469         inSwap = true;
470         _;
471         inSwap = false;
472     }
473 }