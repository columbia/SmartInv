1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IERC20Metadata is IERC20 {
31     function name() external view returns (string memory);
32     function symbol() external view returns (string memory);
33     function decimals() external view returns (uint8);
34 }
35 
36 contract ERC20 is Context, IERC20, IERC20Metadata {
37     mapping(address => uint256) private _balances;
38     mapping(address => mapping(address => uint256)) private _allowances;
39     uint256 private _totalSupply;
40     string private _name;
41     string private _symbol;
42 
43     constructor(string memory name_, string memory symbol_) {
44         _name = name_;
45         _symbol = symbol_;
46     }
47 
48     function name() public view virtual override returns (string memory) {
49         return _name;
50     }
51 
52     function symbol() public view virtual override returns (string memory) {
53         return _symbol;
54     }
55 
56     function decimals() public view virtual override returns (uint8) {
57         return 18;
58     }
59 
60     function totalSupply() public view virtual override returns (uint256) {
61         return _totalSupply;
62     }
63 
64     function balanceOf(address account) public view virtual override returns (uint256) {
65         return _balances[account];
66     }
67 
68     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
69         _transfer(_msgSender(), recipient, amount);
70         return true;
71     }
72 
73     function allowance(address owner, address spender) public view virtual override returns (uint256) {
74         return _allowances[owner][spender];
75     }
76 
77     function approve(address spender, uint256 amount) public virtual override returns (bool) {
78         _approve(_msgSender(), spender, amount);
79         return true;
80     }
81 
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) public virtual override returns (bool) {
87         _transfer(sender, recipient, amount);
88 
89         uint256 currentAllowance = _allowances[sender][_msgSender()];
90         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
91     unchecked {
92         _approve(sender, _msgSender(), currentAllowance - amount);
93     }
94 
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
104         uint256 currentAllowance = _allowances[_msgSender()][spender];
105         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
106     unchecked {
107         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
108     }
109 
110         return true;
111     }
112 
113     function _transfer(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) internal virtual {
118         require(sender != address(0), "ERC20: transfer from the zero address");
119         require(recipient != address(0), "ERC20: transfer to the zero address");
120 
121         uint256 senderBalance = _balances[sender];
122         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
123     unchecked {
124         _balances[sender] = senderBalance - amount;
125     }
126         _balances[recipient] += amount;
127 
128         emit Transfer(sender, recipient, amount);
129     }
130 
131     function _createInitialSupply(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _totalSupply += amount;
135         _balances[account] += amount;
136         emit Transfer(address(0), account, amount);
137     }
138 
139     function _approve(
140         address owner,
141         address spender,
142         uint256 amount
143     ) internal virtual {
144         require(owner != address(0), "ERC20: approve from the zero address");
145         require(spender != address(0), "ERC20: approve to the zero address");
146 
147         _allowances[owner][spender] = amount;
148         emit Approval(owner, spender, amount);
149     }
150 }
151 
152 contract Ownable is Context {
153     address private _owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     constructor () {
158         address msgSender = _msgSender();
159         _owner = msgSender;
160         emit OwnershipTransferred(address(0), msgSender);
161     }
162 
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     modifier onlyOwner() {
168         require(_owner == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171 
172     function renounceOwnership() external virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 interface IDexRouter {
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187 
188     function swapExactTokensForETHSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195 
196     function addLiquidityETH(
197         address token,
198         uint256 amountTokenDesired,
199         uint256 amountTokenMin,
200         uint256 amountETHMin,
201         address to,
202         uint256 deadline
203     )
204     external
205     payable
206     returns (
207         uint256 amountToken,
208         uint256 amountETH,
209         uint256 liquidity
210     );
211 }
212 
213 interface IDexFactory {
214     function createPair(address tokenA, address tokenB)
215     external
216     returns (address pair);
217 }
218 
219 contract SmartPaws is ERC20, Ownable {
220 
221     uint256 public maxBuyAmount;
222     uint256 public maxSellAmount;
223     uint256 public maxWalletAmount;
224 
225     IDexRouter public immutable uniswapV2Router;
226     address public immutable uniswapV2Pair;
227 
228     bool private swapping;
229     uint256 public swapTokensAtAmount;
230 
231     address public TreasuryAddress;
232     address public RewardsAddress;
233 
234     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
235     uint256 public deadBlocks = 2;
236 
237     bool public limitsInEffect = true;
238     bool public tradingActive = false;
239     bool public swapEnabled = false;
240 
241     uint256 public buyTotalFees;
242     uint256 public buyTreasuryFee;
243     uint256 public buyLiquidityFee;
244     uint256 public buyRewardsFee;
245 
246     uint256 public sellTotalFees;
247     uint256 public sellTreasuryFee;
248     uint256 public sellLiquidityFee;
249     uint256 public sellRewardsFee;
250 
251     uint256 public tokensForTreasury;
252     uint256 public tokensForLiquidity;
253     uint256 public tokensForRewards;
254 
255 
256     // exlcude from fees and max transaction amount
257     mapping (address => bool) private _isExcludedFromFees;
258     mapping (address => bool) public _isExcludedMaxTransactionAmount;
259 
260     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
261     // could be subject to a maximum transfer amount
262     mapping (address => bool) public automatedMarketMakerPairs;
263     mapping (address => bool) private _isSniper;
264 
265     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
266 
267     event EnabledTrading(bool tradingActive, uint256 deadBlocks);
268     event RemovedLimits();
269 
270     event ExcludeFromFees(address indexed account, bool isExcluded);
271 
272     event UpdatedMaxBuyAmount(uint256 newAmount);
273 
274     event UpdatedMaxSellAmount(uint256 newAmount);
275 
276     event UpdatedMaxWalletAmount(uint256 newAmount);
277 
278     event UpdatedTreasuryAddress(address indexed newWallet);
279 
280     event UpdatedRewardsAddress(address indexed newWallet);
281 
282     event MaxTransactionExclusion(address _address, bool excluded);
283 
284     event SwapAndLiquify(
285         uint256 tokensSwapped,
286         uint256 ethReceived,
287         uint256 tokensIntoLiquidity
288     );
289 
290     event TransferForeignToken(address token, uint256 amount);
291 
292 
293     constructor() ERC20("Smart Paws", "SPAW") {
294 
295         address newOwner = msg.sender; 
296 
297         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298 
299         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
300         uniswapV2Router = _uniswapV2Router;
301 
302         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
303         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
304 
305         uint256 totalSupply = 500000000 * 1e18;
306 
307         maxBuyAmount = totalSupply *  5 / 1000;
308         maxSellAmount = totalSupply *  5 / 1000;
309         maxWalletAmount = totalSupply * 5 / 1000;
310         swapTokensAtAmount = totalSupply * 50 / 100000; 
311 
312         buyTreasuryFee = 18;
313         buyLiquidityFee = 2;
314         buyRewardsFee = 0;
315         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
316 
317         sellTreasuryFee = 30;
318         sellLiquidityFee = 10;
319         sellRewardsFee = 0;
320         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
321 
322         TreasuryAddress = address(0xB5B2673487ba33354CB84E1F6027F35544BDf57f);
323         RewardsAddress = address(0xB5B2673487ba33354CB84E1F6027F35544BDf57f);
324 
325         excludeFromFees(newOwner, true);
326         excludeFromFees(address(this), true);
327         excludeFromFees(address(0xdead), true);
328 
329         _excludeFromMaxTransaction(newOwner, true);
330         _excludeFromMaxTransaction(address(this), true);
331         _excludeFromMaxTransaction(address(0xdead), true);
332 
333         _createInitialSupply(newOwner, totalSupply);
334         transferOwnership(newOwner);
335     }
336 
337     receive() external payable {}
338 
339     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
340         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
341         maxBuyAmount = newNum * (10**18);
342         emit UpdatedMaxBuyAmount(maxBuyAmount);
343     }
344 
345     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
346         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
347         maxSellAmount = newNum * (10**18);
348         emit UpdatedMaxSellAmount(maxSellAmount);
349     }
350 
351     
352     // remove limits after token is stable
353     function removeLimits() external onlyOwner {
354         limitsInEffect = false;
355         emit RemovedLimits();
356     }
357 
358 
359     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
360         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
361         emit MaxTransactionExclusion(updAds, isExcluded);
362     }
363 
364     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
365         if(!isEx){
366             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
367         }
368         _isExcludedMaxTransactionAmount[updAds] = isEx;
369     }
370 
371     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
372         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
373         maxWalletAmount = newNum * (10**18);
374         emit UpdatedMaxWalletAmount(maxWalletAmount);
375     }
376 
377     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
378        swapTokensAtAmount = newAmount;
379     }
380 
381     function excludeFromFees(address account, bool excluded) public onlyOwner {
382         _isExcludedFromFees[account] = excluded;
383         emit ExcludeFromFees(account, excluded);
384     }
385 
386 
387     function _transfer(address from, address to, uint256 amount) internal override {
388 
389         require(from != address(0), "ERC20: transfer from the zero address");
390         require(to != address(0), "ERC20: transfer to the zero address");
391         require(amount > 0, "amount must be greater than 0");
392         require(!_isSniper[from], "You are a sniper, get life!");
393         require(!_isSniper[to], "You are a sniper, get life!");
394 
395         if(limitsInEffect){
396             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
397                 if(!tradingActive){
398                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
399                     require(from == owner(), "Trading is enabled");
400                 }
401 
402                 if (tradingActiveBlock > 0 && block.number < (tradingActiveBlock + deadBlocks) ) {
403                     _isSniper[to] = true;
404                 }
405 
406                 //when buy
407                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
408                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
409                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
410                 }
411                 //when sell
412                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
413                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
414                 }
415                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
416                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
417                 }
418             }
419         }
420 
421         uint256 contractTokenBalance = balanceOf(address(this));
422 
423         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
424 
425         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
426             swapping = true;
427 
428             swapBack();
429 
430             swapping = false;
431         }
432 
433         bool takeFee = true;
434         // if any account belongs to _isExcludedFromFee account then remove the fee
435         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
436             takeFee = false;
437         }
438 
439         uint256 fees = 0;
440         uint256 penaltyAmount = 0;
441         // only take fees on Trades, not on wallet transfers
442 
443         if(takeFee){
444             // bot/sniper penalty.  Tokens get transferred to Treasury wallet and ETH to liquidity.
445             if(tradingActiveBlock>0 && (tradingActiveBlock + 6) > block.number){
446                 penaltyAmount = amount * 98 / 100;
447                 super._transfer(from, TreasuryAddress, penaltyAmount);
448             }
449             // on sell
450             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
451                 fees = amount * sellTotalFees /100;
452                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
453                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
454                 tokensForRewards += fees * sellRewardsFee / sellTotalFees;
455             }
456             // on buy
457             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
458                 fees = amount * buyTotalFees / 100;
459                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
460                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
461                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
462             }
463 
464             if(fees > 0){
465                 super._transfer(from, address(this), fees);
466             }
467 
468             amount -= fees + penaltyAmount;
469         }
470 
471         super._transfer(from, to, amount);
472     }
473 
474   
475     // once enabled, can never be turned off
476     function enableTrading(bool _status, uint256 _deadBlocks) external onlyOwner {
477         require(!tradingActive, "Cannot re enable trading");
478         tradingActive = _status;
479         swapEnabled = true;
480         emit EnabledTrading(tradingActive, _deadBlocks);
481 
482         if (tradingActive && tradingActiveBlock == 0) {
483             tradingActiveBlock = block.number;
484             deadBlocks = _deadBlocks;
485         }
486     }
487 
488     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
489         // approve token transfer to cover all possible scenarios
490         _approve(address(this), address(uniswapV2Router), tokenAmount);
491 
492         // add the liquidity
493         uniswapV2Router.addLiquidityETH{value: ethAmount}(
494             address(this),
495             tokenAmount,
496             0, // slippage is unavoidable
497             0, // slippage is unavoidable
498             address(owner()),
499             block.timestamp
500         );
501     }
502 
503       function swapTokensForEth(uint256 tokenAmount) private {
504 
505         // generate the uniswap pair path of token -> weth
506         address[] memory path = new address[](2);
507         path[0] = address(this);
508         path[1] = uniswapV2Router.WETH();
509 
510         _approve(address(this), address(uniswapV2Router), tokenAmount);
511 
512         // make the swap
513         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
514             tokenAmount,
515             0, // accept any amount of ETH
516             path,
517             address(this),
518             block.timestamp
519         );
520     }
521 
522     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
523         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
524 
525         _setAutomatedMarketMakerPair(pair, value);
526     }
527 
528     function _setAutomatedMarketMakerPair(address pair, bool value) private {
529         automatedMarketMakerPairs[pair] = value;
530 
531         _excludeFromMaxTransaction(pair, value);
532 
533         emit SetAutomatedMarketMakerPair(pair, value);
534     }
535 
536     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
537         buyTreasuryFee = _treasuryFee;
538         buyLiquidityFee = _liquidityFee;
539         buyRewardsFee = _rewardsFee;
540         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
541         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
542     }
543 
544     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
545         sellTreasuryFee = _treasuryFee;
546         sellLiquidityFee = _liquidityFee;
547         sellRewardsFee = _rewardsFee;
548         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
549         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
550     }
551      
552     function multiSend(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
553 
554         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
555         require(addresses.length == tokens.length,"Mismatch between Address and token count");
556 
557         uint256 SCCC = 0;
558 
559         for(uint i=0; i < addresses.length; i++){
560             SCCC = SCCC + (tokens[i] * 10**decimals());
561         }
562 
563         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
564 
565         for(uint i=0; i < addresses.length; i++){
566             _transfer(msg.sender,addresses[i],(tokens[i] * 10**decimals()));
567         }
568     }
569 
570 
571     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
572         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
573         TreasuryAddress = payable(_TreasuryAddress);
574         emit UpdatedTreasuryAddress(_TreasuryAddress);
575     }
576 
577     function setRewardsAddress(address _RewardsAddress) external onlyOwner {
578         require(_RewardsAddress != address(0), "_RewardsAddress address cannot be 0");
579         RewardsAddress = payable(_RewardsAddress);
580         emit UpdatedRewardsAddress(_RewardsAddress);
581     }
582 
583 
584     function manage_Sniper(address sniper_address, bool status) external onlyOwner {
585         require(_isSniper[sniper_address] != status, "Account is already in the said state");
586         _isSniper[sniper_address] = status;
587     }
588 
589     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
590         for (uint256 i; i < addresses.length; ++i) {
591                 _isSniper[addresses[i]] = status;
592         }
593     }
594 
595     function isSniper(address account) public view returns (bool) {
596         return _isSniper[account];
597     }
598 
599    
600     function swapBack() private {
601         uint256 contractBalance = balanceOf(address(this));
602         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForRewards;
603 
604         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
605 
606         if(contractBalance > swapTokensAtAmount * 10){
607             contractBalance = swapTokensAtAmount * 10;
608         }
609 
610         bool success;
611 
612         // Halve the amount of liquidity tokens
613         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
614 
615         swapTokensForEth(contractBalance - liquidityTokens);
616 
617         uint256 ethBalance = address(this).balance;
618         uint256 ethForLiquidity = ethBalance;
619 
620         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
621         uint256 ethForRewards = ethBalance * tokensForRewards / (totalTokensToSwap - (tokensForLiquidity/2));
622 
623         ethForLiquidity -= ethForTreasury + ethForRewards;
624 
625         tokensForLiquidity = 0;
626         tokensForTreasury = 0;
627         tokensForRewards = 0;
628 
629         if(liquidityTokens > 0 && ethForLiquidity > 0){
630             addLiquidity(liquidityTokens, ethForLiquidity);
631         }
632 
633         (success,) = address(RewardsAddress).call{value: ethForRewards}("");
634 
635         (success,) = address(TreasuryAddress).call{value: address(this).balance}("");
636     }
637 
638     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
639         require(_token != address(0), "_token address cannot be 0");
640         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
641         _sent = IERC20(_token).transfer(_to, _contractBalance);
642         emit TransferForeignToken(_token, _contractBalance);
643     }
644 
645     // withdraw ETH if stuck or someone sends to the address
646     function withdrawStuckETH() external onlyOwner {
647         bool success;
648         (success,) = address(msg.sender).call{value: address(this).balance}("");
649     }
650 
651 }