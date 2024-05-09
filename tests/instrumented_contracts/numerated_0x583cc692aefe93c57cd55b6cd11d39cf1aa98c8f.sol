1 /**
2  * https://ncatethtoken.fun
3  * Telegram: https://t.me/NCATOfficial
4  * Twitter: https://twitter.com/NCATEthToken
5  * Total Supply: 10 Billion Tokens
6  * Initial Max Wallet: 1%
7  * Initial Max Tx: 0.5%
8  * Set slippage to 3-4% : 1% to LP, 2% tax for Marketing
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity 0.8.12;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this;
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 interface IERC20Metadata is IERC20 {
41     function name() external view returns (string memory);
42     function symbol() external view returns (string memory);
43     function decimals() external view returns (uint8);
44 }
45 
46 contract ERC20 is Context, IERC20, IERC20Metadata {
47     mapping(address => uint256) private _balances;
48     mapping(address => mapping(address => uint256)) private _allowances;
49     uint256 private _totalSupply;
50     string private _name;
51     string private _symbol;
52 
53     constructor(string memory name_, string memory symbol_) {
54         _name = name_;
55         _symbol = symbol_;
56     }
57 
58     function name() public view virtual override returns (string memory) {
59         return _name;
60     }
61 
62     function symbol() public view virtual override returns (string memory) {
63         return _symbol;
64     }
65 
66     function decimals() public view virtual override returns (uint8) {
67         return 18;
68     }
69 
70     function totalSupply() public view virtual override returns (uint256) {
71         return _totalSupply;
72     }
73 
74     function balanceOf(address account) public view virtual override returns (uint256) {
75         return _balances[account];
76     }
77 
78     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
79         _transfer(_msgSender(), recipient, amount);
80         return true;
81     }
82 
83     function allowance(address owner, address spender) public view virtual override returns (uint256) {
84         return _allowances[owner][spender];
85     }
86 
87     function approve(address spender, uint256 amount) public virtual override returns (bool) {
88         _approve(_msgSender(), spender, amount);
89         return true;
90     }
91 
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) public virtual override returns (bool) {
97         _transfer(sender, recipient, amount);
98 
99         uint256 currentAllowance = _allowances[sender][_msgSender()];
100         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
101     unchecked {
102         _approve(sender, _msgSender(), currentAllowance - amount);
103     }
104 
105         return true;
106     }
107 
108     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
109         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
110         return true;
111     }
112 
113     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
114         uint256 currentAllowance = _allowances[_msgSender()][spender];
115         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
116     unchecked {
117         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
118     }
119 
120         return true;
121     }
122 
123     function _transfer(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) internal virtual {
128         require(sender != address(0), "ERC20: transfer from the zero address");
129         require(recipient != address(0), "ERC20: transfer to the zero address");
130 
131         uint256 senderBalance = _balances[sender];
132         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
133     unchecked {
134         _balances[sender] = senderBalance - amount;
135     }
136         _balances[recipient] += amount;
137 
138         emit Transfer(sender, recipient, amount);
139     }
140 
141     function _createInitialSupply(address account, uint256 amount) internal virtual {
142         require(account != address(0), "ERC20: mint to the zero address");
143 
144         _totalSupply += amount;
145         _balances[account] += amount;
146         emit Transfer(address(0), account, amount);
147     }
148 
149     function _approve(
150         address owner,
151         address spender,
152         uint256 amount
153     ) internal virtual {
154         require(owner != address(0), "ERC20: approve from the zero address");
155         require(spender != address(0), "ERC20: approve to the zero address");
156 
157         _allowances[owner][spender] = amount;
158         emit Approval(owner, spender, amount);
159     }
160 }
161 
162 contract Ownable is Context {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     constructor () {
168         address msgSender = _msgSender();
169         _owner = msgSender;
170         emit OwnershipTransferred(address(0), msgSender);
171     }
172 
173     function owner() public view returns (address) {
174         return _owner;
175     }
176 
177     modifier onlyOwner() {
178         require(_owner == _msgSender(), "Ownable: caller is not the owner");
179         _;
180     }
181 
182     function renounceOwnership() external virtual onlyOwner {
183         emit OwnershipTransferred(_owner, address(0));
184         _owner = address(0);
185     }
186 
187     function transferOwnership(address newOwner) public virtual onlyOwner {
188         require(newOwner != address(0), "Ownable: new owner is the zero address");
189         emit OwnershipTransferred(_owner, newOwner);
190         _owner = newOwner;
191     }
192 }
193 
194 interface IDexRouter {
195     function factory() external pure returns (address);
196     function WETH() external pure returns (address);
197 
198     function swapExactTokensForETHSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205 
206     function addLiquidityETH(
207         address token,
208         uint256 amountTokenDesired,
209         uint256 amountTokenMin,
210         uint256 amountETHMin,
211         address to,
212         uint256 deadline
213     )
214     external
215     payable
216     returns (
217         uint256 amountToken,
218         uint256 amountETH,
219         uint256 liquidity
220     );
221 }
222 
223 interface IDexFactory {
224     function createPair(address tokenA, address tokenB)
225     external
226     returns (address pair);
227 }
228 
229 contract NCAT is ERC20, Ownable {
230 
231     uint256 public maxBuyAmount;
232     uint256 public maxSellAmount;
233     uint256 public maxWalletAmount;
234 
235     IDexRouter public immutable uniswapV2Router;
236     address public immutable uniswapV2Pair;
237 
238     bool private swapping;
239     uint256 public swapTokensAtAmount;
240 
241     address public MarketingAddress;
242 
243     bool public limitsInEffect = true;
244     bool public tradingActive = false;
245     bool public swapEnabled = false;
246 
247     uint256 public buyTotalFees;
248     uint256 public buyMarketingFee;
249     uint256 public buyLiquidityFee;
250 
251     uint256 public sellTotalFees;
252     uint256 public sellMarketingFee;
253     uint256 public sellLiquidityFee;
254 
255     uint256 public tokensForTreasury;
256     uint256 public tokensForLiquidity;
257 
258     // exlcude from fees and max transaction amount
259     mapping (address => bool) private _isExcludedFromFees;
260     mapping (address => bool) public _isExcludedMaxTransactionAmount;
261 
262     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
263     // could be subject to a maximum transfer amount
264     mapping (address => bool) public automatedMarketMakerPairs;
265 
266     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
267     event EnabledTrading(bool tradingActive);
268     event RemovedLimits();
269     event ExcludeFromFees(address indexed account, bool isExcluded);
270     event UpdatedMaxBuyAmount(uint256 newAmount);
271     event UpdatedMaxSellAmount(uint256 newAmount);
272     event UpdatedMaxWalletAmount(uint256 newAmount);
273     event UpdatedMarketingAddress(address indexed newWallet);
274     event UpdatedRewardsAddress(address indexed newWallet);
275     event MaxTransactionExclusion(address _address, bool excluded);
276     event SwapAndLiquify(
277         uint256 tokensSwapped,
278         uint256 ethReceived,
279         uint256 tokensIntoLiquidity
280     );
281 
282     constructor() ERC20("NCAT", "NCAT") {
283 
284         address newOwner = msg.sender; 
285 
286         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
287 
288         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
289         uniswapV2Router = _uniswapV2Router;
290 
291         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
292         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
293 
294         uint256 totalSupply = 10000000000 * 1e18;
295 
296         maxBuyAmount = totalSupply *  5 / 1000;
297         maxSellAmount = totalSupply *  5 / 1000;
298         maxWalletAmount = totalSupply * 10 / 1000;
299         swapTokensAtAmount = totalSupply * 500 / 100000; 
300 
301         buyMarketingFee = 2;
302         buyLiquidityFee = 1;
303         buyTotalFees = buyMarketingFee + buyLiquidityFee;
304 
305         sellMarketingFee = 2;
306         sellLiquidityFee = 1;
307         sellTotalFees = sellMarketingFee + sellLiquidityFee;
308 
309         _excludeFromMaxTransaction(newOwner, true);
310         _excludeFromMaxTransaction(address(this), true);
311         _excludeFromMaxTransaction(address(0xdead), true);
312 
313         MarketingAddress = address(0x488d789771a78213047c056355Ca44e8A90484d3);
314 
315         excludeFromFees(newOwner, true);
316         excludeFromFees(address(this), true);
317         excludeFromFees(address(0xdead), true);
318 
319         _createInitialSupply(newOwner, totalSupply);
320         transferOwnership(newOwner);
321     }
322 
323     receive() external payable {}
324 
325     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
326         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
327         maxBuyAmount = newNum * (10**18);
328         emit UpdatedMaxBuyAmount(maxBuyAmount);
329     }
330 
331     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
332         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
333         maxSellAmount = newNum * (10**18);
334         emit UpdatedMaxSellAmount(maxSellAmount);
335     }
336 
337     // remove limits after token is stable
338     function removeLimits() external onlyOwner {
339         limitsInEffect = false;
340         emit RemovedLimits();
341     }
342 
343     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
344         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
345         emit MaxTransactionExclusion(updAds, isExcluded);
346     }
347 
348     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
349         if(!isEx){
350             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
351         }
352         _isExcludedMaxTransactionAmount[updAds] = isEx;
353     }
354 
355     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
356         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
357         maxWalletAmount = newNum * (10**18);
358         emit UpdatedMaxWalletAmount(maxWalletAmount);
359     }
360 
361     // change the minimum amount of tokens to sell from fees
362     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
363         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
364         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
365         swapTokensAtAmount = newAmount;
366     }
367 
368     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
369         buyMarketingFee = _treasuryFee;
370         buyLiquidityFee = _liquidityFee;
371         buyTotalFees = buyMarketingFee + buyLiquidityFee;
372     }
373 
374     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
375         sellMarketingFee = _treasuryFee;
376         sellLiquidityFee = _liquidityFee;
377         sellTotalFees = sellMarketingFee + sellLiquidityFee;
378     }
379 
380     function excludeFromFees(address account, bool excluded) public onlyOwner {
381         _isExcludedFromFees[account] = excluded;
382         emit ExcludeFromFees(account, excluded);
383     }
384 
385     function _transfer(address from, address to, uint256 amount) internal override {
386 
387         require(from != address(0), "ERC20: transfer from the zero address");
388         require(to != address(0), "ERC20: transfer to the zero address");
389         require(amount > 0, "amount must be greater than 0");
390 
391         if(limitsInEffect){
392             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
393                 if(!tradingActive){
394                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
395                     require(from == owner(), "Trading is enabled");
396                 }
397 
398                 //when buy
399                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
400                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
401                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
402                 }
403                 //when sell
404                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
405                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
406                 }
407                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
408                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
409                 }
410             }
411         }
412 
413         uint256 contractTokenBalance = balanceOf(address(this));
414 
415         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
416 
417         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
418             swapping = true;
419             swapBack();
420             swapping = false;
421         }
422 
423         bool takeFee = true;
424         // if any account belongs to _isExcludedFromFee account then remove the fee
425         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
426             takeFee = false;
427         }
428 
429         uint256 fees = 0;
430         // only take fees on Trades, not on wallet transfers
431 
432         if(takeFee){
433             // on sell
434             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
435                 fees = amount * sellTotalFees /100;
436                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
437                 tokensForTreasury += fees * sellMarketingFee / sellTotalFees;
438             }
439             // on buy
440             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
441                 fees = amount * buyTotalFees / 100;
442                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
443                 tokensForTreasury += fees * buyMarketingFee / buyTotalFees;
444             }
445 
446             if(fees > 0){
447                 super._transfer(from, address(this), fees);
448             }
449 
450             amount -= fees;
451         }
452 
453         super._transfer(from, to, amount);
454     }
455 
456     function swapTokensForEth(uint256 tokenAmount) private {
457 
458         // generate the uniswap pair path of token -> weth
459         address[] memory path = new address[](2);
460         path[0] = address(this);
461         path[1] = uniswapV2Router.WETH();
462 
463         _approve(address(this), address(uniswapV2Router), tokenAmount);
464 
465         // make the swap
466         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
467             tokenAmount,
468             0, // accept any amount of ETH
469             path,
470             address(this),
471             block.timestamp
472         );
473     }
474 
475     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
476         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
477 
478         _setAutomatedMarketMakerPair(pair, value);
479     }
480 
481     function _setAutomatedMarketMakerPair(address pair, bool value) private {
482         automatedMarketMakerPairs[pair] = value;
483 
484         _excludeFromMaxTransaction(pair, value);
485 
486         emit SetAutomatedMarketMakerPair(pair, value);
487     }
488 
489     // once enabled, can never be turned off
490     function enableTrading(bool _status) external onlyOwner {
491         require(!tradingActive, "Cannot re enable trading");
492         tradingActive = _status;
493         swapEnabled = true;
494         emit EnabledTrading(tradingActive);
495     }
496 
497     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
498         // approve token transfer to cover all possible scenarios
499         _approve(address(this), address(uniswapV2Router), tokenAmount);
500 
501         // add the liquidity
502         uniswapV2Router.addLiquidityETH{value: ethAmount}(
503             address(this),
504             tokenAmount,
505             0, // slippage is unavoidable
506             0, // slippage is unavoidable
507             address(owner()),
508             block.timestamp
509         );
510     }
511 
512     function setMarketingAddress(address _MarketingAddress) external onlyOwner {
513         require(_MarketingAddress != address(0), "_MarketingAddress address cannot be 0");
514         MarketingAddress = payable(_MarketingAddress);
515         emit UpdatedMarketingAddress(_MarketingAddress);
516     }
517 
518    
519     function swapBack() private {
520         uint256 contractBalance = balanceOf(address(this));
521         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
522 
523         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
524 
525         if(contractBalance > swapTokensAtAmount * 10){
526             contractBalance = swapTokensAtAmount * 10;
527         }
528 
529         bool success;
530 
531         // Halve the amount of liquidity tokens
532         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
533 
534         swapTokensForEth(contractBalance - liquidityTokens);
535 
536         uint256 ethBalance = address(this).balance;
537         uint256 ethForLiquidity = ethBalance;
538 
539         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
540 
541         ethForLiquidity -= ethForTreasury;
542 
543         tokensForLiquidity = 0;
544         tokensForTreasury = 0;
545 
546         if(liquidityTokens > 0 && ethForLiquidity > 0){
547             addLiquidity(liquidityTokens, ethForLiquidity);
548         }
549 
550         (success,) = address(MarketingAddress).call{value: address(this).balance}("");
551     }
552 
553     function claimStuckTokens(address _token) external onlyOwner {
554         if (_token == address(0x0)) {
555             payable(owner()).transfer(address(this).balance);
556             return;
557         }
558         IERC20 erc20token = IERC20(_token);
559         uint256 balance = erc20token.balanceOf(address(this));
560         erc20token.transfer(owner(), balance);
561     }
562     
563 }