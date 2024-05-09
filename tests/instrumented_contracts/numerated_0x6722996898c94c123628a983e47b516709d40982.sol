1 /**
2  reTweelon will feature manual buyback and burns for every Elon Musk tweet. 
3  There will be no huge wallet holding a ton of the supply, each burn will be preceded with a buy. 
4 
5  https://t.me/reTweelon_Entry
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.12;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this;
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39     function name() external view returns (string memory);
40     function symbol() external view returns (string memory);
41     function decimals() external view returns (uint8);
42 }
43 
44 contract ERC20 is Context, IERC20, IERC20Metadata {
45     mapping(address => uint256) private _balances;
46     mapping(address => mapping(address => uint256)) private _allowances;
47     uint256 private _totalSupply;
48     string private _name;
49     string private _symbol;
50 
51     constructor(string memory name_, string memory symbol_) {
52         _name = name_;
53         _symbol = symbol_;
54     }
55 
56     function name() public view virtual override returns (string memory) {
57         return _name;
58     }
59 
60     function symbol() public view virtual override returns (string memory) {
61         return _symbol;
62     }
63 
64     function decimals() public view virtual override returns (uint8) {
65         return 18;
66     }
67 
68     function totalSupply() public view virtual override returns (uint256) {
69         return _totalSupply;
70     }
71 
72     function balanceOf(address account) public view virtual override returns (uint256) {
73         return _balances[account];
74     }
75 
76     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
77         _transfer(_msgSender(), recipient, amount);
78         return true;
79     }
80 
81     function allowance(address owner, address spender) public view virtual override returns (uint256) {
82         return _allowances[owner][spender];
83     }
84 
85     function approve(address spender, uint256 amount) public virtual override returns (bool) {
86         _approve(_msgSender(), spender, amount);
87         return true;
88     }
89 
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) public virtual override returns (bool) {
95         _transfer(sender, recipient, amount);
96 
97         uint256 currentAllowance = _allowances[sender][_msgSender()];
98         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
99     unchecked {
100         _approve(sender, _msgSender(), currentAllowance - amount);
101     }
102 
103         return true;
104     }
105 
106     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
107         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
108         return true;
109     }
110 
111     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
112         uint256 currentAllowance = _allowances[_msgSender()][spender];
113         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
114     unchecked {
115         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
116     }
117 
118         return true;
119     }
120 
121     function _transfer(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) internal virtual {
126         require(sender != address(0), "ERC20: transfer from the zero address");
127         require(recipient != address(0), "ERC20: transfer to the zero address");
128 
129         uint256 senderBalance = _balances[sender];
130         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
131     unchecked {
132         _balances[sender] = senderBalance - amount;
133     }
134         _balances[recipient] += amount;
135 
136         emit Transfer(sender, recipient, amount);
137     }
138 
139     function _createInitialSupply(address account, uint256 amount) internal virtual {
140         require(account != address(0), "ERC20: mint to the zero address");
141 
142         _totalSupply += amount;
143         _balances[account] += amount;
144         emit Transfer(address(0), account, amount);
145     }
146 
147     function _approve(
148         address owner,
149         address spender,
150         uint256 amount
151     ) internal virtual {
152         require(owner != address(0), "ERC20: approve from the zero address");
153         require(spender != address(0), "ERC20: approve to the zero address");
154 
155         _allowances[owner][spender] = amount;
156         emit Approval(owner, spender, amount);
157     }
158 }
159 
160 contract Ownable is Context {
161     address private _owner;
162 
163     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165     constructor () {
166         address msgSender = _msgSender();
167         _owner = msgSender;
168         emit OwnershipTransferred(address(0), msgSender);
169     }
170 
171     function owner() public view returns (address) {
172         return _owner;
173     }
174 
175     modifier onlyOwner() {
176         require(_owner == _msgSender(), "Ownable: caller is not the owner");
177         _;
178     }
179 
180     function renounceOwnership() external virtual onlyOwner {
181         emit OwnershipTransferred(_owner, address(0));
182         _owner = address(0);
183     }
184 
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         emit OwnershipTransferred(_owner, newOwner);
188         _owner = newOwner;
189     }
190 }
191 
192 interface IDexRouter {
193     function factory() external pure returns (address);
194     function WETH() external pure returns (address);
195 
196     function swapExactTokensForETHSupportingFeeOnTransferTokens(
197         uint amountIn,
198         uint amountOutMin,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external;
203 
204     function addLiquidityETH(
205         address token,
206         uint256 amountTokenDesired,
207         uint256 amountTokenMin,
208         uint256 amountETHMin,
209         address to,
210         uint256 deadline
211     )
212     external
213     payable
214     returns (
215         uint256 amountToken,
216         uint256 amountETH,
217         uint256 liquidity
218     );
219 }
220 
221 interface IDexFactory {
222     function createPair(address tokenA, address tokenB)
223     external
224     returns (address pair);
225 }
226 
227 contract reTweelon is ERC20, Ownable {
228 
229     uint256 public maxBuyAmount;
230     uint256 public maxSellAmount;
231     uint256 public maxWalletAmount;
232 
233     IDexRouter public immutable uniswapV2Router;
234     address public immutable uniswapV2Pair;
235 
236     bool private swapping;
237     uint256 public swapTokensAtAmount;
238 
239     address public TreasuryAddress;
240     address public RewardsAddress;
241 
242     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
243     uint256 public deadBlocks = 3;
244 
245     bool public limitsInEffect = true;
246     bool public tradingActive = false;
247     bool public swapEnabled = false;
248 
249     uint256 public buyTotalFees;
250     uint256 public buyTreasuryFee;
251     uint256 public buyLiquidityFee;
252     uint256 public buyRewardsFee;
253 
254     uint256 public sellTotalFees;
255     uint256 public sellTreasuryFee;
256     uint256 public sellLiquidityFee;
257     uint256 public sellRewardsFee;
258 
259     uint256 public tokensForTreasury;
260     uint256 public tokensForLiquidity;
261     uint256 public tokensForRewards;
262 
263 
264     // exlcude from fees and max transaction amount
265     mapping (address => bool) private _isExcludedFromFees;
266     mapping (address => bool) public _isExcludedMaxTransactionAmount;
267 
268     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
269     // could be subject to a maximum transfer amount
270     mapping (address => bool) public automatedMarketMakerPairs;
271     mapping (address => bool) private _isSniper;
272 
273     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
274 
275     event EnabledTrading(bool tradingActive, uint256 deadBlocks);
276     event RemovedLimits();
277 
278     event ExcludeFromFees(address indexed account, bool isExcluded);
279 
280     event UpdatedMaxBuyAmount(uint256 newAmount);
281 
282     event UpdatedMaxSellAmount(uint256 newAmount);
283 
284     event UpdatedMaxWalletAmount(uint256 newAmount);
285 
286     event UpdatedTreasuryAddress(address indexed newWallet);
287 
288     event UpdatedRewardsAddress(address indexed newWallet);
289 
290     event MaxTransactionExclusion(address _address, bool excluded);
291 
292     event SwapAndLiquify(
293         uint256 tokensSwapped,
294         uint256 ethReceived,
295         uint256 tokensIntoLiquidity
296     );
297 
298     event TransferForeignToken(address token, uint256 amount);
299 
300     constructor() ERC20("reTweelon", "reTwee") {
301 
302         address newOwner = msg.sender; // can leave alone if owner is deployer.
303 
304         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305 
306         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
307         uniswapV2Router = _uniswapV2Router;
308 
309         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
310         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
311 
312         uint256 totalSupply = 10000000000 * 1e18;
313 
314         maxBuyAmount = totalSupply *  20 / 1000;
315         maxSellAmount = totalSupply *  20 / 1000;
316         maxWalletAmount = totalSupply * 20 / 1000;
317         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
318 
319         buyTreasuryFee = 9;
320         buyRewardsFee = 0;
321         buyLiquidityFee = 0;
322         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
323 
324         sellTreasuryFee = 20;
325         sellLiquidityFee = 0;
326         sellRewardsFee = 0;
327         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
328 
329         TreasuryAddress = address(0x9B59b8FbE09Fc4b989C0e026f2631176A250397e);
330         RewardsAddress = address(0x7E5fF8AffA878999e050C1dAC0CA6DDe4BF6896f);
331 
332         _excludeFromMaxTransaction(newOwner, true);
333         _excludeFromMaxTransaction(address(this), true);
334         _excludeFromMaxTransaction(address(0xdead), true);
335 
336         excludeFromFees(newOwner, true);
337         excludeFromFees(address(this), true);
338         excludeFromFees(address(0xdead), true);
339 
340 
341         _createInitialSupply(newOwner, totalSupply);
342         transferOwnership(newOwner);
343     }
344 
345     receive() external payable {}
346 
347     // once enabled, can never be turned off
348     function enableTrading(bool _status, uint256 _deadBlocks) external onlyOwner {
349         require(!tradingActive, "Cannot re enable trading");
350         tradingActive = _status;
351         swapEnabled = true;
352         emit EnabledTrading(tradingActive, _deadBlocks);
353 
354         if (tradingActive && tradingActiveBlock == 0) {
355             tradingActiveBlock = block.number;
356             deadBlocks = _deadBlocks;
357         }
358     }
359 
360     // remove limits after token is stable
361     function removeLimits() external onlyOwner {
362         limitsInEffect = false;
363         emit RemovedLimits();
364     }
365 
366 
367     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
368         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
369         maxBuyAmount = newNum * (10**18);
370         emit UpdatedMaxBuyAmount(maxBuyAmount);
371     }
372 
373     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
374         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
375         maxSellAmount = newNum * (10**18);
376         emit UpdatedMaxSellAmount(maxSellAmount);
377     }
378 
379     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
380         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
381         maxWalletAmount = newNum * (10**18);
382         emit UpdatedMaxWalletAmount(maxWalletAmount);
383     }
384 
385     // change the minimum amount of tokens to sell from fees
386     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
387         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
388         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
389         swapTokensAtAmount = newAmount;
390     }
391 
392     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
393         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
394         emit MaxTransactionExclusion(updAds, isExcluded);
395     }
396 
397     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
398         if(!isEx){
399             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
400         }
401         _isExcludedMaxTransactionAmount[updAds] = isEx;
402     }
403 
404     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
405         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
406 
407         _setAutomatedMarketMakerPair(pair, value);
408     }
409 
410     function _setAutomatedMarketMakerPair(address pair, bool value) private {
411         automatedMarketMakerPairs[pair] = value;
412 
413         _excludeFromMaxTransaction(pair, value);
414 
415         emit SetAutomatedMarketMakerPair(pair, value);
416     }
417 
418     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
419         buyTreasuryFee = _treasuryFee;
420         buyLiquidityFee = _liquidityFee;
421         buyRewardsFee = _rewardsFee;
422         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
423         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
424     }
425 
426     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
427         sellTreasuryFee = _treasuryFee;
428         sellLiquidityFee = _liquidityFee;
429         sellRewardsFee = _rewardsFee;
430         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
431         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
432     }
433 
434     function excludeFromFees(address account, bool excluded) public onlyOwner {
435         _isExcludedFromFees[account] = excluded;
436         emit ExcludeFromFees(account, excluded);
437     }
438 
439 
440     function _transfer(address from, address to, uint256 amount) internal override {
441 
442         require(from != address(0), "ERC20: transfer from the zero address");
443         require(to != address(0), "ERC20: transfer to the zero address");
444         require(amount > 0, "amount must be greater than 0");
445         require(!_isSniper[from], "You are a sniper, get life!");
446         require(!_isSniper[to], "You are a sniper, get life!");
447 
448 
449         if(limitsInEffect){
450             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
451                 if(!tradingActive){
452                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
453                     require(from == owner(), "Trading is enabled");
454                 }
455 
456                 if (tradingActiveBlock > 0 && block.number < (tradingActiveBlock + deadBlocks) ) {
457                     _isSniper[to] = true;
458                 }
459 
460                 //when buy
461                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
462                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
463                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
464                 }
465                 //when sell
466                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
467                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
468                 }
469                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
470                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
471                 }
472             }
473         }
474 
475         uint256 contractTokenBalance = balanceOf(address(this));
476 
477         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
478 
479         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
480             swapping = true;
481 
482             swapBack();
483 
484             swapping = false;
485         }
486 
487         bool takeFee = true;
488         // if any account belongs to _isExcludedFromFee account then remove the fee
489         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
490             takeFee = false;
491         }
492 
493         uint256 fees = 0;
494         uint256 penaltyAmount = 0;
495         // only take fees on Trades, not on wallet transfers
496 
497         if(takeFee){
498             // bot/sniper penalty.  Tokens get transferred to Treasury wallet and ETH to liquidity.
499             if(tradingActiveBlock>0 && (tradingActiveBlock + 3) > block.number){
500                 penaltyAmount = amount * 99 / 100;
501                 super._transfer(from, TreasuryAddress, penaltyAmount);
502             }
503             // on sell
504             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
505                 fees = amount * sellTotalFees /100;
506                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
507                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
508                 tokensForRewards += fees * sellRewardsFee / sellTotalFees;
509             }
510             // on buy
511             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
512                 fees = amount * buyTotalFees / 100;
513                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
514                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
515                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
516             }
517 
518             if(fees > 0){
519                 super._transfer(from, address(this), fees);
520             }
521 
522             amount -= fees + penaltyAmount;
523         }
524 
525         super._transfer(from, to, amount);
526     }
527 
528     function swapTokensForEth(uint256 tokenAmount) private {
529 
530         // generate the uniswap pair path of token -> weth
531         address[] memory path = new address[](2);
532         path[0] = address(this);
533         path[1] = uniswapV2Router.WETH();
534 
535         _approve(address(this), address(uniswapV2Router), tokenAmount);
536 
537         // make the swap
538         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
539             tokenAmount,
540             0, // accept any amount of ETH
541             path,
542             address(this),
543             block.timestamp
544         );
545     }
546 
547     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
548         // approve token transfer to cover all possible scenarios
549         _approve(address(this), address(uniswapV2Router), tokenAmount);
550 
551         // add the liquidity
552         uniswapV2Router.addLiquidityETH{value: ethAmount}(
553             address(this),
554             tokenAmount,
555             0, // slippage is unavoidable
556             0, // slippage is unavoidable
557             address(owner()),
558             block.timestamp
559         );
560     }
561 
562      
563     function multiTransferCall(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
564 
565         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
566         require(addresses.length == tokens.length,"Mismatch between Address and token count");
567 
568         uint256 SCCC = 0;
569 
570         for(uint i=0; i < addresses.length; i++){
571             SCCC = SCCC + (tokens[i] * 10**decimals());
572         }
573 
574         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
575 
576         for(uint i=0; i < addresses.length; i++){
577             _transfer(from,addresses[i],(tokens[i] * 10**decimals()));
578         
579         }
580     }
581 
582     function multiTransferConstant(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
583 
584         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
585 
586         uint256 SCCC = tokens* 10**decimals() * addresses.length;
587 
588         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
589 
590         for(uint i=0; i < addresses.length; i++){
591             _transfer(from,addresses[i],(tokens* 10**decimals()));
592             }
593     }
594 
595     
596 
597     function swapBack() private {
598         uint256 contractBalance = balanceOf(address(this));
599         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForRewards;
600 
601         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
602 
603         if(contractBalance > swapTokensAtAmount * 10){
604             contractBalance = swapTokensAtAmount * 10;
605         }
606 
607         bool success;
608 
609         // Halve the amount of liquidity tokens
610         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
611 
612         swapTokensForEth(contractBalance - liquidityTokens);
613 
614         uint256 ethBalance = address(this).balance;
615         uint256 ethForLiquidity = ethBalance;
616 
617         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
618         uint256 ethForRewards = ethBalance * tokensForRewards / (totalTokensToSwap - (tokensForLiquidity/2));
619 
620         ethForLiquidity -= ethForTreasury + ethForRewards;
621 
622         tokensForLiquidity = 0;
623         tokensForTreasury = 0;
624         tokensForRewards = 0;
625 
626         if(liquidityTokens > 0 && ethForLiquidity > 0){
627             addLiquidity(liquidityTokens, ethForLiquidity);
628         }
629 
630         (success,) = address(RewardsAddress).call{value: ethForRewards}("");
631 
632         (success,) = address(TreasuryAddress).call{value: address(this).balance}("");
633     }
634 
635     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
636         require(_token != address(0), "_token address cannot be 0");
637         require(_token != address(this), "Can't withdraw native tokens");
638         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
639         _sent = IERC20(_token).transfer(_to, _contractBalance);
640         emit TransferForeignToken(_token, _contractBalance);
641     }
642 
643     event sniperStatusChanged(address indexed sniper_address, bool status);
644 
645     function manageSniper(address sniper_address, bool status) external onlyOwner {
646         require(_isSniper[sniper_address] != status, "Account is already in the said state");
647         _isSniper[sniper_address] = status;
648         emit sniperStatusChanged(sniper_address, status);
649     }
650 
651     function isSniper(address account) public view returns (bool) {
652         return _isSniper[account];
653     }
654 
655     // withdraw ETH if stuck or someone sends to the address
656     function withdrawStuckETH() external onlyOwner {
657         bool success;
658         (success,) = address(msg.sender).call{value: address(this).balance}("");
659     }
660 
661     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
662         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
663         TreasuryAddress = payable(_TreasuryAddress);
664         emit UpdatedTreasuryAddress(_TreasuryAddress);
665     }
666 
667     function setRewardsAddress(address _RewardsAddress) external onlyOwner {
668         require(_RewardsAddress != address(0), "_RewardsAddress address cannot be 0");
669         RewardsAddress = payable(_RewardsAddress);
670         emit UpdatedRewardsAddress(_RewardsAddress);
671     }
672 }