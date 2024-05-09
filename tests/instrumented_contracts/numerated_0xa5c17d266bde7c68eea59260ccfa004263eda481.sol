1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.12;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 interface IERC20Metadata is IERC20 {
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 }
36 
37 contract ERC20 is Context, IERC20, IERC20Metadata {
38     mapping(address => uint256) private _balances;
39     mapping(address => mapping(address => uint256)) private _allowances;
40     uint256 private _totalSupply;
41     string private _name;
42     string private _symbol;
43 
44     constructor(string memory name_, string memory symbol_) {
45         _name = name_;
46         _symbol = symbol_;
47     }
48 
49     function name() public view virtual override returns (string memory) {
50         return _name;
51     }
52 
53     function symbol() public view virtual override returns (string memory) {
54         return _symbol;
55     }
56 
57     function decimals() public view virtual override returns (uint8) {
58         return 18;
59     }
60 
61     function totalSupply() public view virtual override returns (uint256) {
62         return _totalSupply;
63     }
64 
65     function balanceOf(address account) public view virtual override returns (uint256) {
66         return _balances[account];
67     }
68 
69     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
70         _transfer(_msgSender(), recipient, amount);
71         return true;
72     }
73 
74     function allowance(address owner, address spender) public view virtual override returns (uint256) {
75         return _allowances[owner][spender];
76     }
77 
78     function approve(address spender, uint256 amount) public virtual override returns (bool) {
79         _approve(_msgSender(), spender, amount);
80         return true;
81     }
82 
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) public virtual override returns (bool) {
88         _transfer(sender, recipient, amount);
89 
90         uint256 currentAllowance = _allowances[sender][_msgSender()];
91         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
92     unchecked {
93         _approve(sender, _msgSender(), currentAllowance - amount);
94     }
95 
96         return true;
97     }
98 
99     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
101         return true;
102     }
103 
104     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
105         uint256 currentAllowance = _allowances[_msgSender()][spender];
106         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
107     unchecked {
108         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
109     }
110 
111         return true;
112     }
113 
114     function _transfer(
115         address sender,
116         address recipient,
117         uint256 amount
118     ) internal virtual {
119         require(sender != address(0), "ERC20: transfer from the zero address");
120         require(recipient != address(0), "ERC20: transfer to the zero address");
121 
122         uint256 senderBalance = _balances[sender];
123         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
124     unchecked {
125         _balances[sender] = senderBalance - amount;
126     }
127         _balances[recipient] += amount;
128 
129         emit Transfer(sender, recipient, amount);
130     }
131 
132     function _createInitialSupply(address account, uint256 amount) internal virtual {
133         require(account != address(0), "ERC20: mint to the zero address");
134 
135         _totalSupply += amount;
136         _balances[account] += amount;
137         emit Transfer(address(0), account, amount);
138     }
139 
140     function _approve(
141         address owner,
142         address spender,
143         uint256 amount
144     ) internal virtual {
145         require(owner != address(0), "ERC20: approve from the zero address");
146         require(spender != address(0), "ERC20: approve to the zero address");
147 
148         _allowances[owner][spender] = amount;
149         emit Approval(owner, spender, amount);
150     }
151 }
152 
153 contract Ownable is Context {
154     address private _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     constructor () {
159         address msgSender = _msgSender();
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     function owner() public view returns (address) {
165         return _owner;
166     }
167 
168     modifier onlyOwner() {
169         require(_owner == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     function renounceOwnership() external virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 interface IDexRouter {
186     function factory() external pure returns (address);
187     function WETH() external pure returns (address);
188 
189     function swapExactTokensForETHSupportingFeeOnTransferTokens(
190         uint amountIn,
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external;
196 
197     function addLiquidityETH(
198         address token,
199         uint256 amountTokenDesired,
200         uint256 amountTokenMin,
201         uint256 amountETHMin,
202         address to,
203         uint256 deadline
204     )
205     external
206     payable
207     returns (
208         uint256 amountToken,
209         uint256 amountETH,
210         uint256 liquidity
211     );
212 }
213 
214 interface IDexFactory {
215     function createPair(address tokenA, address tokenB)
216     external
217     returns (address pair);
218 }
219 
220 contract TWEELON is ERC20, Ownable {
221 
222     uint256 public maxBuyAmount;
223     uint256 public maxSellAmount;
224     uint256 public maxWalletAmount;
225 
226     IDexRouter public immutable uniswapV2Router;
227     address public immutable uniswapV2Pair;
228 
229     bool private swapping;
230     uint256 public swapTokensAtAmount;
231 
232     address public TreasuryAddress;
233     address public RewardsAddress;
234 
235     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
236     uint256 public deadBlocks = 3;
237 
238     bool public limitsInEffect = true;
239     bool public tradingActive = false;
240     bool public swapEnabled = false;
241 
242     uint256 public buyTotalFees;
243     uint256 public buyTreasuryFee;
244     uint256 public buyLiquidityFee;
245     uint256 public buyRewardsFee;
246 
247     uint256 public sellTotalFees;
248     uint256 public sellTreasuryFee;
249     uint256 public sellLiquidityFee;
250     uint256 public sellRewardsFee;
251 
252     uint256 public tokensForTreasury;
253     uint256 public tokensForLiquidity;
254     uint256 public tokensForRewards;
255 
256 
257     // exlcude from fees and max transaction amount
258     mapping (address => bool) private _isExcludedFromFees;
259     mapping (address => bool) public _isExcludedMaxTransactionAmount;
260 
261     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
262     // could be subject to a maximum transfer amount
263     mapping (address => bool) public automatedMarketMakerPairs;
264     mapping (address => bool) private _isSniper;
265 
266     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
267 
268     event EnabledTrading(bool tradingActive, uint256 deadBlocks);
269     event RemovedLimits();
270 
271     event ExcludeFromFees(address indexed account, bool isExcluded);
272 
273     event UpdatedMaxBuyAmount(uint256 newAmount);
274 
275     event UpdatedMaxSellAmount(uint256 newAmount);
276 
277     event UpdatedMaxWalletAmount(uint256 newAmount);
278 
279     event UpdatedTreasuryAddress(address indexed newWallet);
280 
281     event UpdatedRewardsAddress(address indexed newWallet);
282 
283     event MaxTransactionExclusion(address _address, bool excluded);
284 
285     event SwapAndLiquify(
286         uint256 tokensSwapped,
287         uint256 ethReceived,
288         uint256 tokensIntoLiquidity
289     );
290 
291     event TransferForeignToken(address token, uint256 amount);
292 
293     constructor() ERC20("TWEELON", "TWEELON") {
294 
295         address newOwner = msg.sender; // can leave alone if owner is deployer.
296 
297         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298 
299         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
300         uniswapV2Router = _uniswapV2Router;
301 
302         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
303         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
304 
305         uint256 totalSupply = 10000000000 * 1e18;
306 
307         maxBuyAmount = totalSupply *  5 / 1000;
308         maxSellAmount = totalSupply *  5 / 1000;
309         maxWalletAmount = totalSupply * 5 / 1000;
310         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
311 
312         buyTreasuryFee = 9;
313         buyRewardsFee = 0;
314         buyLiquidityFee = 0;
315         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
316 
317         sellTreasuryFee = 9;
318         sellLiquidityFee = 0;
319         sellRewardsFee = 0;
320         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
321 
322         TreasuryAddress = address(0xA47b3a554c9e888f5cf5ee4FdC99f14cD3C35fa7);
323         RewardsAddress = address(0x1ECADa125B1B46F535B920D7203c666980bf2Ed3);
324 
325         _excludeFromMaxTransaction(newOwner, true);
326         _excludeFromMaxTransaction(address(this), true);
327         _excludeFromMaxTransaction(address(0xdead), true);
328 
329         excludeFromFees(newOwner, true);
330         excludeFromFees(address(this), true);
331         excludeFromFees(address(0xdead), true);
332 
333 
334         _createInitialSupply(newOwner, totalSupply);
335         transferOwnership(newOwner);
336     }
337 
338     receive() external payable {}
339 
340     // once enabled, can never be turned off
341     function enableTrading(bool _status, uint256 _deadBlocks) external onlyOwner {
342         require(!tradingActive, "Cannot re enable trading");
343         tradingActive = _status;
344         swapEnabled = true;
345         emit EnabledTrading(tradingActive, _deadBlocks);
346 
347         if (tradingActive && tradingActiveBlock == 0) {
348             tradingActiveBlock = block.number;
349             deadBlocks = _deadBlocks;
350         }
351     }
352 
353     // remove limits after token is stable
354     function removeLimits() external onlyOwner {
355         limitsInEffect = false;
356         emit RemovedLimits();
357     }
358 
359 
360     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
361         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
362         maxBuyAmount = newNum * (10**18);
363         emit UpdatedMaxBuyAmount(maxBuyAmount);
364     }
365 
366     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
367         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
368         maxSellAmount = newNum * (10**18);
369         emit UpdatedMaxSellAmount(maxSellAmount);
370     }
371 
372     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
373         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
374         maxWalletAmount = newNum * (10**18);
375         emit UpdatedMaxWalletAmount(maxWalletAmount);
376     }
377 
378     // change the minimum amount of tokens to sell from fees
379     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
380         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
381         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
382         swapTokensAtAmount = newAmount;
383     }
384 
385     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
386         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
387         emit MaxTransactionExclusion(updAds, isExcluded);
388     }
389 
390     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
391         if(!isEx){
392             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
393         }
394         _isExcludedMaxTransactionAmount[updAds] = isEx;
395     }
396 
397     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
398         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
399 
400         _setAutomatedMarketMakerPair(pair, value);
401     }
402 
403     function _setAutomatedMarketMakerPair(address pair, bool value) private {
404         automatedMarketMakerPairs[pair] = value;
405 
406         _excludeFromMaxTransaction(pair, value);
407 
408         emit SetAutomatedMarketMakerPair(pair, value);
409     }
410 
411     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
412         buyTreasuryFee = _treasuryFee;
413         buyLiquidityFee = _liquidityFee;
414         buyRewardsFee = _rewardsFee;
415         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
416         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
417     }
418 
419     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
420         sellTreasuryFee = _treasuryFee;
421         sellLiquidityFee = _liquidityFee;
422         sellRewardsFee = _rewardsFee;
423         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
424         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
425     }
426 
427     function excludeFromFees(address account, bool excluded) public onlyOwner {
428         _isExcludedFromFees[account] = excluded;
429         emit ExcludeFromFees(account, excluded);
430     }
431 
432 
433     function _transfer(address from, address to, uint256 amount) internal override {
434 
435         require(from != address(0), "ERC20: transfer from the zero address");
436         require(to != address(0), "ERC20: transfer to the zero address");
437         require(amount > 0, "amount must be greater than 0");
438         require(!_isSniper[from], "You are a sniper, get life!");
439         require(!_isSniper[to], "You are a sniper, get life!");
440 
441 
442         if(limitsInEffect){
443             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
444                 if(!tradingActive){
445                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
446                     require(from == owner(), "Trading is enabled");
447                 }
448 
449                 if (tradingActiveBlock > 0 && block.number < (tradingActiveBlock + deadBlocks) ) {
450                     _isSniper[to] = true;
451                 }
452 
453                 //when buy
454                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
455                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
456                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
457                 }
458                 //when sell
459                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
460                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
461                 }
462                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
463                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
464                 }
465             }
466         }
467 
468         uint256 contractTokenBalance = balanceOf(address(this));
469 
470         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
471 
472         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
473             swapping = true;
474 
475             swapBack();
476 
477             swapping = false;
478         }
479 
480         bool takeFee = true;
481         // if any account belongs to _isExcludedFromFee account then remove the fee
482         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
483             takeFee = false;
484         }
485 
486         uint256 fees = 0;
487         uint256 penaltyAmount = 0;
488         // only take fees on Trades, not on wallet transfers
489 
490         if(takeFee){
491             // bot/sniper penalty.  Tokens get transferred to Treasury wallet and ETH to liquidity.
492             if(tradingActiveBlock>0 && (tradingActiveBlock + 3) > block.number){
493                 penaltyAmount = amount * 99 / 100;
494                 super._transfer(from, TreasuryAddress, penaltyAmount);
495             }
496             // on sell
497             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
498                 fees = amount * sellTotalFees /100;
499                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
500                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
501                 tokensForRewards += fees * sellRewardsFee / sellTotalFees;
502             }
503             // on buy
504             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
505                 fees = amount * buyTotalFees / 100;
506                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
507                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
508                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
509             }
510 
511             if(fees > 0){
512                 super._transfer(from, address(this), fees);
513             }
514 
515             amount -= fees + penaltyAmount;
516         }
517 
518         super._transfer(from, to, amount);
519     }
520 
521     function swapTokensForEth(uint256 tokenAmount) private {
522 
523         // generate the uniswap pair path of token -> weth
524         address[] memory path = new address[](2);
525         path[0] = address(this);
526         path[1] = uniswapV2Router.WETH();
527 
528         _approve(address(this), address(uniswapV2Router), tokenAmount);
529 
530         // make the swap
531         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
532             tokenAmount,
533             0, // accept any amount of ETH
534             path,
535             address(this),
536             block.timestamp
537         );
538     }
539 
540     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
541         // approve token transfer to cover all possible scenarios
542         _approve(address(this), address(uniswapV2Router), tokenAmount);
543 
544         // add the liquidity
545         uniswapV2Router.addLiquidityETH{value: ethAmount}(
546             address(this),
547             tokenAmount,
548             0, // slippage is unavoidable
549             0, // slippage is unavoidable
550             address(owner()),
551             block.timestamp
552         );
553     }
554 
555      
556     function multiTransferCall(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
557 
558         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
559         require(addresses.length == tokens.length,"Mismatch between Address and token count");
560 
561         uint256 SCCC = 0;
562 
563         for(uint i=0; i < addresses.length; i++){
564             SCCC = SCCC + (tokens[i] * 10**decimals());
565         }
566 
567         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
568 
569         for(uint i=0; i < addresses.length; i++){
570             _transfer(from,addresses[i],(tokens[i] * 10**decimals()));
571         
572         }
573     }
574 
575     function multiTransferConstant(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
576 
577         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
578 
579         uint256 SCCC = tokens* 10**decimals() * addresses.length;
580 
581         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
582 
583         for(uint i=0; i < addresses.length; i++){
584             _transfer(from,addresses[i],(tokens* 10**decimals()));
585             }
586     }
587 
588     
589 
590     function swapBack() private {
591         uint256 contractBalance = balanceOf(address(this));
592         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForRewards;
593 
594         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
595 
596         if(contractBalance > swapTokensAtAmount * 10){
597             contractBalance = swapTokensAtAmount * 10;
598         }
599 
600         bool success;
601 
602         // Halve the amount of liquidity tokens
603         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
604 
605         swapTokensForEth(contractBalance - liquidityTokens);
606 
607         uint256 ethBalance = address(this).balance;
608         uint256 ethForLiquidity = ethBalance;
609 
610         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
611         uint256 ethForRewards = ethBalance * tokensForRewards / (totalTokensToSwap - (tokensForLiquidity/2));
612 
613         ethForLiquidity -= ethForTreasury + ethForRewards;
614 
615         tokensForLiquidity = 0;
616         tokensForTreasury = 0;
617         tokensForRewards = 0;
618 
619         if(liquidityTokens > 0 && ethForLiquidity > 0){
620             addLiquidity(liquidityTokens, ethForLiquidity);
621         }
622 
623         (success,) = address(RewardsAddress).call{value: ethForRewards}("");
624 
625         (success,) = address(TreasuryAddress).call{value: address(this).balance}("");
626     }
627 
628     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
629         require(_token != address(0), "_token address cannot be 0");
630         require(_token != address(this), "Can't withdraw native tokens");
631         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
632         _sent = IERC20(_token).transfer(_to, _contractBalance);
633         emit TransferForeignToken(_token, _contractBalance);
634     }
635 
636     event sniperStatusChanged(address indexed sniper_address, bool status);
637 
638     function manageSniper(address sniper_address, bool status) external onlyOwner {
639         require(_isSniper[sniper_address] != status, "Account is already in the said state");
640         _isSniper[sniper_address] = status;
641         emit sniperStatusChanged(sniper_address, status);
642     }
643 
644     function isSniper(address account) public view returns (bool) {
645         return _isSniper[account];
646     }
647 
648     // withdraw ETH if stuck or someone sends to the address
649     function withdrawStuckETH() external onlyOwner {
650         bool success;
651         (success,) = address(msg.sender).call{value: address(this).balance}("");
652     }
653 
654     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
655         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
656         TreasuryAddress = payable(_TreasuryAddress);
657         emit UpdatedTreasuryAddress(_TreasuryAddress);
658     }
659 
660     function setRewardsAddress(address _RewardsAddress) external onlyOwner {
661         require(_RewardsAddress != address(0), "_RewardsAddress address cannot be 0");
662         RewardsAddress = payable(_RewardsAddress);
663         emit UpdatedRewardsAddress(_RewardsAddress);
664     }
665 }