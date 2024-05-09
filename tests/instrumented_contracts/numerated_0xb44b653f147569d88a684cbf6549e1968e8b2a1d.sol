1 /**
2  * 2DAI.io
3  * Telegram: https://t.me/Token2dAI
4  * Ready to unleash your creativity with the power of AI? Let's generate the visuals of your dreams.
5  * Total Supply: 1 Billion Tokens
6  * Initial Max Wallet: 2% (>20000000 Tokens)
7  * Set slippage to 3-4% : 1% to LP, 2% tax for Marketing & Hosting costs.
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.12;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this;
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IERC20Metadata is IERC20 {
40     function name() external view returns (string memory);
41     function symbol() external view returns (string memory);
42     function decimals() external view returns (uint8);
43 }
44 
45 contract ERC20 is Context, IERC20, IERC20Metadata {
46     mapping(address => uint256) private _balances;
47     mapping(address => mapping(address => uint256)) private _allowances;
48     uint256 private _totalSupply;
49     string private _name;
50     string private _symbol;
51 
52     constructor(string memory name_, string memory symbol_) {
53         _name = name_;
54         _symbol = symbol_;
55     }
56 
57     function name() public view virtual override returns (string memory) {
58         return _name;
59     }
60 
61     function symbol() public view virtual override returns (string memory) {
62         return _symbol;
63     }
64 
65     function decimals() public view virtual override returns (uint8) {
66         return 18;
67     }
68 
69     function totalSupply() public view virtual override returns (uint256) {
70         return _totalSupply;
71     }
72 
73     function balanceOf(address account) public view virtual override returns (uint256) {
74         return _balances[account];
75     }
76 
77     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
78         _transfer(_msgSender(), recipient, amount);
79         return true;
80     }
81 
82     function allowance(address owner, address spender) public view virtual override returns (uint256) {
83         return _allowances[owner][spender];
84     }
85 
86     function approve(address spender, uint256 amount) public virtual override returns (bool) {
87         _approve(_msgSender(), spender, amount);
88         return true;
89     }
90 
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) public virtual override returns (bool) {
96         _transfer(sender, recipient, amount);
97 
98         uint256 currentAllowance = _allowances[sender][_msgSender()];
99         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
100     unchecked {
101         _approve(sender, _msgSender(), currentAllowance - amount);
102     }
103 
104         return true;
105     }
106 
107     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
108         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
109         return true;
110     }
111 
112     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
113         uint256 currentAllowance = _allowances[_msgSender()][spender];
114         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
115     unchecked {
116         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
117     }
118 
119         return true;
120     }
121 
122     function _transfer(
123         address sender,
124         address recipient,
125         uint256 amount
126     ) internal virtual {
127         require(sender != address(0), "ERC20: transfer from the zero address");
128         require(recipient != address(0), "ERC20: transfer to the zero address");
129 
130         uint256 senderBalance = _balances[sender];
131         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
132     unchecked {
133         _balances[sender] = senderBalance - amount;
134     }
135         _balances[recipient] += amount;
136 
137         emit Transfer(sender, recipient, amount);
138     }
139 
140     function _createInitialSupply(address account, uint256 amount) internal virtual {
141         require(account != address(0), "ERC20: mint to the zero address");
142 
143         _totalSupply += amount;
144         _balances[account] += amount;
145         emit Transfer(address(0), account, amount);
146     }
147 
148     function _approve(
149         address owner,
150         address spender,
151         uint256 amount
152     ) internal virtual {
153         require(owner != address(0), "ERC20: approve from the zero address");
154         require(spender != address(0), "ERC20: approve to the zero address");
155 
156         _allowances[owner][spender] = amount;
157         emit Approval(owner, spender, amount);
158     }
159 }
160 
161 contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     constructor () {
167         address msgSender = _msgSender();
168         _owner = msgSender;
169         emit OwnershipTransferred(address(0), msgSender);
170     }
171 
172     function owner() public view returns (address) {
173         return _owner;
174     }
175 
176     modifier onlyOwner() {
177         require(_owner == _msgSender(), "Ownable: caller is not the owner");
178         _;
179     }
180 
181     function renounceOwnership() external virtual onlyOwner {
182         emit OwnershipTransferred(_owner, address(0));
183         _owner = address(0);
184     }
185 
186     function transferOwnership(address newOwner) public virtual onlyOwner {
187         require(newOwner != address(0), "Ownable: new owner is the zero address");
188         emit OwnershipTransferred(_owner, newOwner);
189         _owner = newOwner;
190     }
191 }
192 
193 interface IDexRouter {
194     function factory() external pure returns (address);
195     function WETH() external pure returns (address);
196 
197     function swapExactTokensForETHSupportingFeeOnTransferTokens(
198         uint amountIn,
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external;
204 
205     function addLiquidityETH(
206         address token,
207         uint256 amountTokenDesired,
208         uint256 amountTokenMin,
209         uint256 amountETHMin,
210         address to,
211         uint256 deadline
212     )
213     external
214     payable
215     returns (
216         uint256 amountToken,
217         uint256 amountETH,
218         uint256 liquidity
219     );
220 }
221 
222 interface IDexFactory {
223     function createPair(address tokenA, address tokenB)
224     external
225     returns (address pair);
226 }
227 
228 contract io2DAIToken is ERC20, Ownable {
229 
230     uint256 public maxBuyAmount;
231     uint256 public maxSellAmount;
232     uint256 public maxWalletAmount;
233 
234     IDexRouter public immutable uniswapV2Router;
235     address public immutable uniswapV2Pair;
236 
237     bool private swapping;
238     uint256 public swapTokensAtAmount;
239 
240     address public TreasuryAddress;
241 
242     bool public limitsInEffect = true;
243     bool public tradingActive = false;
244     bool public swapEnabled = false;
245 
246     uint256 public buyTotalFees;
247     uint256 public buyTreasuryFee;
248     uint256 public buyLiquidityFee;
249 
250     uint256 public sellTotalFees;
251     uint256 public sellTreasuryFee;
252     uint256 public sellLiquidityFee;
253 
254     uint256 public tokensForTreasury;
255     uint256 public tokensForLiquidity;
256 
257     // exlcude from fees and max transaction amount
258     mapping (address => bool) private _isExcludedFromFees;
259     mapping (address => bool) public _isExcludedMaxTransactionAmount;
260 
261     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
262     // could be subject to a maximum transfer amount
263     mapping (address => bool) public automatedMarketMakerPairs;
264 
265     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
266     event EnabledTrading(bool tradingActive);
267     event RemovedLimits();
268     event ExcludeFromFees(address indexed account, bool isExcluded);
269     event UpdatedMaxBuyAmount(uint256 newAmount);
270     event UpdatedMaxSellAmount(uint256 newAmount);
271     event UpdatedMaxWalletAmount(uint256 newAmount);
272     event UpdatedTreasuryAddress(address indexed newWallet);
273     event UpdatedRewardsAddress(address indexed newWallet);
274     event MaxTransactionExclusion(address _address, bool excluded);
275     event SwapAndLiquify(
276         uint256 tokensSwapped,
277         uint256 ethReceived,
278         uint256 tokensIntoLiquidity
279     );
280 
281     constructor() ERC20("2DAI.io", "2DAI") {
282 
283         address newOwner = msg.sender; 
284 
285         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
286 
287         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
288         uniswapV2Router = _uniswapV2Router;
289 
290         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
291         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
292 
293         uint256 totalSupply = 1000000000 * 1e18;
294 
295         maxBuyAmount = totalSupply *  20 / 1000;
296         maxSellAmount = totalSupply *  20 / 1000;
297         maxWalletAmount = totalSupply * 20 / 1000;
298         swapTokensAtAmount = totalSupply * 50 / 100000; 
299 
300         buyTreasuryFee = 2;
301         buyLiquidityFee = 1;
302         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
303 
304         sellTreasuryFee = 2;
305         sellLiquidityFee = 1;
306         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
307 
308         _excludeFromMaxTransaction(newOwner, true);
309         _excludeFromMaxTransaction(address(this), true);
310         _excludeFromMaxTransaction(address(0xdead), true);
311 
312         TreasuryAddress = address(0x7cDEfde9fb25b015220c27d69d04b9362912AE6a);
313 
314         excludeFromFees(newOwner, true);
315         excludeFromFees(address(this), true);
316         excludeFromFees(address(0xdead), true);
317 
318         _createInitialSupply(newOwner, totalSupply);
319         transferOwnership(newOwner);
320     }
321 
322     receive() external payable {}
323 
324     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
325         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
326         maxBuyAmount = newNum * (10**18);
327         emit UpdatedMaxBuyAmount(maxBuyAmount);
328     }
329 
330     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
331         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
332         maxSellAmount = newNum * (10**18);
333         emit UpdatedMaxSellAmount(maxSellAmount);
334     }
335 
336     // remove limits after token is stable
337     function removeLimits() external onlyOwner {
338         limitsInEffect = false;
339         emit RemovedLimits();
340     }
341 
342     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
343         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
344         emit MaxTransactionExclusion(updAds, isExcluded);
345     }
346 
347     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
348         if(!isEx){
349             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
350         }
351         _isExcludedMaxTransactionAmount[updAds] = isEx;
352     }
353 
354     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
355         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
356         maxWalletAmount = newNum * (10**18);
357         emit UpdatedMaxWalletAmount(maxWalletAmount);
358     }
359 
360     // change the minimum amount of tokens to sell from fees
361     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
362         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
363         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
364         swapTokensAtAmount = newAmount;
365     }
366 
367     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
368         buyTreasuryFee = _treasuryFee;
369         buyLiquidityFee = _liquidityFee;
370         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
371         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
372     }
373 
374     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
375         sellTreasuryFee = _treasuryFee;
376         sellLiquidityFee = _liquidityFee;
377         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
378         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
379     }
380 
381     function excludeFromFees(address account, bool excluded) public onlyOwner {
382         _isExcludedFromFees[account] = excluded;
383         emit ExcludeFromFees(account, excluded);
384     }
385 
386     function _transfer(address from, address to, uint256 amount) internal override {
387 
388         require(from != address(0), "ERC20: transfer from the zero address");
389         require(to != address(0), "ERC20: transfer to the zero address");
390         require(amount > 0, "amount must be greater than 0");
391 
392         if(limitsInEffect){
393             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
394                 if(!tradingActive){
395                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
396                     require(from == owner(), "Trading is enabled");
397                 }
398 
399                 //when buy
400                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
401                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
402                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
403                 }
404                 //when sell
405                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
406                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
407                 }
408                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
409                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
410                 }
411             }
412         }
413 
414         uint256 contractTokenBalance = balanceOf(address(this));
415 
416         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
417 
418         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
419             swapping = true;
420             swapBack();
421             swapping = false;
422         }
423 
424         bool takeFee = true;
425         // if any account belongs to _isExcludedFromFee account then remove the fee
426         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
427             takeFee = false;
428         }
429 
430         uint256 fees = 0;
431         // only take fees on Trades, not on wallet transfers
432 
433         if(takeFee){
434             // on sell
435             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
436                 fees = amount * sellTotalFees /100;
437                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
438                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
439             }
440             // on buy
441             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
442                 fees = amount * buyTotalFees / 100;
443                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
444                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
445             }
446 
447             if(fees > 0){
448                 super._transfer(from, address(this), fees);
449             }
450 
451             amount -= fees;
452         }
453 
454         super._transfer(from, to, amount);
455     }
456 
457     function swapTokensForEth(uint256 tokenAmount) private {
458 
459         // generate the uniswap pair path of token -> weth
460         address[] memory path = new address[](2);
461         path[0] = address(this);
462         path[1] = uniswapV2Router.WETH();
463 
464         _approve(address(this), address(uniswapV2Router), tokenAmount);
465 
466         // make the swap
467         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
468             tokenAmount,
469             0, // accept any amount of ETH
470             path,
471             address(this),
472             block.timestamp
473         );
474     }
475 
476     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
477         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
478 
479         _setAutomatedMarketMakerPair(pair, value);
480     }
481 
482     function _setAutomatedMarketMakerPair(address pair, bool value) private {
483         automatedMarketMakerPairs[pair] = value;
484 
485         _excludeFromMaxTransaction(pair, value);
486 
487         emit SetAutomatedMarketMakerPair(pair, value);
488     }
489 
490     // once enabled, can never be turned off
491     function enableTrading(bool _status) external onlyOwner {
492         require(!tradingActive, "Cannot re enable trading");
493         tradingActive = _status;
494         swapEnabled = true;
495         emit EnabledTrading(tradingActive);
496     }
497 
498     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
499         // approve token transfer to cover all possible scenarios
500         _approve(address(this), address(uniswapV2Router), tokenAmount);
501 
502         // add the liquidity
503         uniswapV2Router.addLiquidityETH{value: ethAmount}(
504             address(this),
505             tokenAmount,
506             0, // slippage is unavoidable
507             0, // slippage is unavoidable
508             address(owner()),
509             block.timestamp
510         );
511     }
512 
513     function multiSend(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
514 
515         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
516         require(addresses.length == tokens.length,"Mismatch between Address and token count");
517 
518         uint256 SCCC = 0;
519 
520         for(uint i=0; i < addresses.length; i++){
521             SCCC = SCCC + (tokens[i] * 10**decimals());
522         }
523 
524         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
525 
526         for(uint i=0; i < addresses.length; i++){
527             _transfer(msg.sender,addresses[i],(tokens[i] * 10**decimals()));
528         }
529     }
530 
531     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
532         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
533         TreasuryAddress = payable(_TreasuryAddress);
534         emit UpdatedTreasuryAddress(_TreasuryAddress);
535     }
536 
537    
538     function swapBack() private {
539         uint256 contractBalance = balanceOf(address(this));
540         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
541 
542         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
543 
544         if(contractBalance > swapTokensAtAmount * 10){
545             contractBalance = swapTokensAtAmount * 10;
546         }
547 
548         bool success;
549 
550         // Halve the amount of liquidity tokens
551         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
552 
553         swapTokensForEth(contractBalance - liquidityTokens);
554 
555         uint256 ethBalance = address(this).balance;
556         uint256 ethForLiquidity = ethBalance;
557 
558         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
559 
560         ethForLiquidity -= ethForTreasury;
561 
562         tokensForLiquidity = 0;
563         tokensForTreasury = 0;
564 
565         if(liquidityTokens > 0 && ethForLiquidity > 0){
566             addLiquidity(liquidityTokens, ethForLiquidity);
567         }
568 
569         (success,) = address(TreasuryAddress).call{value: address(this).balance}("");
570     }
571 
572     function claimStuckTokens(address _token) external onlyOwner {
573         if (_token == address(0x0)) {
574             payable(owner()).transfer(address(this).balance);
575             return;
576         }
577         IERC20 erc20token = IERC20(_token);
578         uint256 balance = erc20token.balanceOf(address(this));
579         erc20token.transfer(owner(), balance);
580     }
581     
582 }