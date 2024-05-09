1 // SPDX-License-Identifier: MIT
2 /***
3 ███████╗██╗███╗   ███╗██████╗ ███████╗ █████╗ ██╗    
4 ██╔════╝██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██║    
5 ███████╗██║██╔████╔██║██████╔╝███████╗███████║██║    
6 ╚════██║██║██║╚██╔╝██║██╔═══╝ ╚════██║██╔══██║██║    
7 ███████║██║██║ ╚═╝ ██║██║     ███████║██║  ██║██║    
8 ╚══════╝╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝
9 
10 * ██░▄▄▄░█▄░▄██░▄▀▄░██░▄▄░██░▄▄▄░█░▄▄▀█▄░▄
11 * ██▄▄▄▀▀██░███░█░█░██░▀▀░██▄▄▄▀▀█░▀▀░██░█
12 * ██░▀▀▀░█▀░▀██░███░██░█████░▀▀▀░█░██░█▀░▀
13 *
14 *
15 * SIMPS AI : You dream about her? Create her!
16 * 
17 * We aim to create virtual love experiences driven by AI & AR
18 * This is the start of the Fair Pleasure movement
19 *
20 * Telegram: https://t.me/simpsai_official
21 * Twitter: twitter.com/simps_AI
22 * Home: https://simpsAI.com
23 *
24 * Total Supply: 690 Million
25 * Set slippage to 5-6% : 1% LP | 4% Marketing & Hosting
26 * 69% Liq | 6% Team | 25% CEX & other
27 **/
28 pragma solidity 0.8.12;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         this;
37         return msg.data;
38     }
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(
48         address sender,
49         address recipient,
50         uint256 amount
51     ) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 interface IERC20Metadata is IERC20 {
57     function name() external view returns (string memory);
58     function symbol() external view returns (string memory);
59     function decimals() external view returns (uint8);
60 }
61 
62 contract ERC20 is Context, IERC20, IERC20Metadata {
63     mapping(address => uint256) private _balances;
64     mapping(address => mapping(address => uint256)) private _allowances;
65     uint256 private _totalSupply;
66     string private _name;
67     string private _symbol;
68 
69     constructor(string memory name_, string memory symbol_) {
70         _name = name_;
71         _symbol = symbol_;
72     }
73 
74     function name() public view virtual override returns (string memory) {
75         return _name;
76     }
77 
78     function symbol() public view virtual override returns (string memory) {
79         return _symbol;
80     }
81 
82     function decimals() public view virtual override returns (uint8) {
83         return 18;
84     }
85 
86     function totalSupply() public view virtual override returns (uint256) {
87         return _totalSupply;
88     }
89 
90     function balanceOf(address account) public view virtual override returns (uint256) {
91         return _balances[account];
92     }
93 
94     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
95         _transfer(_msgSender(), recipient, amount);
96         return true;
97     }
98 
99     function allowance(address owner, address spender) public view virtual override returns (uint256) {
100         return _allowances[owner][spender];
101     }
102 
103     function approve(address spender, uint256 amount) public virtual override returns (bool) {
104         _approve(_msgSender(), spender, amount);
105         return true;
106     }
107 
108     function transferFrom(
109         address sender,
110         address recipient,
111         uint256 amount
112     ) public virtual override returns (bool) {
113         _transfer(sender, recipient, amount);
114 
115         uint256 currentAllowance = _allowances[sender][_msgSender()];
116         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
117     unchecked {
118         _approve(sender, _msgSender(), currentAllowance - amount);
119     }
120 
121         return true;
122     }
123 
124     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
125         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
126         return true;
127     }
128 
129     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
130         uint256 currentAllowance = _allowances[_msgSender()][spender];
131         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
132     unchecked {
133         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
134     }
135 
136         return true;
137     }
138 
139     function _transfer(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) internal virtual {
144         require(sender != address(0), "ERC20: transfer from the zero address");
145         require(recipient != address(0), "ERC20: transfer to the zero address");
146 
147         uint256 senderBalance = _balances[sender];
148         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
149     unchecked {
150         _balances[sender] = senderBalance - amount;
151     }
152         _balances[recipient] += amount;
153 
154         emit Transfer(sender, recipient, amount);
155     }
156 
157     function _createInitialSupply(address account, uint256 amount) internal virtual {
158         require(account != address(0), "ERC20: mint to the zero address");
159 
160         _totalSupply += amount;
161         _balances[account] += amount;
162         emit Transfer(address(0), account, amount);
163     }
164 
165     function _approve(
166         address owner,
167         address spender,
168         uint256 amount
169     ) internal virtual {
170         require(owner != address(0), "ERC20: approve from the zero address");
171         require(spender != address(0), "ERC20: approve to the zero address");
172 
173         _allowances[owner][spender] = amount;
174         emit Approval(owner, spender, amount);
175     }
176 }
177 
178 contract Ownable is Context {
179     address private _owner;
180 
181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183     constructor () {
184         address msgSender = _msgSender();
185         _owner = msgSender;
186         emit OwnershipTransferred(address(0), msgSender);
187     }
188 
189     function owner() public view returns (address) {
190         return _owner;
191     }
192 
193     modifier onlyOwner() {
194         require(_owner == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197 
198     function renounceOwnership() external virtual onlyOwner {
199         emit OwnershipTransferred(_owner, address(0));
200         _owner = address(0);
201     }
202 
203     function transferOwnership(address newOwner) public virtual onlyOwner {
204         require(newOwner != address(0), "Ownable: new owner is the zero address");
205         emit OwnershipTransferred(_owner, newOwner);
206         _owner = newOwner;
207     }
208 }
209 
210 interface IDexRouter {
211     function factory() external pure returns (address);
212     function WETH() external pure returns (address);
213 
214     function swapExactTokensForETHSupportingFeeOnTransferTokens(
215         uint amountIn,
216         uint amountOutMin,
217         address[] calldata path,
218         address to,
219         uint deadline
220     ) external;
221 
222     function addLiquidityETH(
223         address token,
224         uint256 amountTokenDesired,
225         uint256 amountTokenMin,
226         uint256 amountETHMin,
227         address to,
228         uint256 deadline
229     )
230     external
231     payable
232     returns (
233         uint256 amountToken,
234         uint256 amountETH,
235         uint256 liquidity
236     );
237 }
238 
239 interface IDexFactory {
240     function createPair(address tokenA, address tokenB)
241     external
242     returns (address pair);
243 }
244 
245 contract SimpsAI is ERC20, Ownable {
246 
247     uint256 public maxBuyAmount;
248     uint256 public maxSellAmount;
249     uint256 public maxWalletAmount;
250 
251     IDexRouter public immutable uniswapV2Router;
252     address public immutable uniswapV2Pair;
253 
254     bool private swapping;
255     uint256 public swapTokensAtAmount;
256 
257     address public TreasuryAddress;
258     address public RewardsAddress;
259 
260     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
261     uint256 public deadBlocks = 2;
262 
263     bool public limitsInEffect = true;
264     bool public tradingActive = false;
265     bool public swapEnabled = false;
266 
267     uint256 public buyTotalFees;
268     uint256 public buyTreasuryFee;
269     uint256 public buyLiquidityFee;
270     uint256 public buyRewardsFee;
271 
272     uint256 public sellTotalFees;
273     uint256 public sellTreasuryFee;
274     uint256 public sellLiquidityFee;
275     uint256 public sellRewardsFee;
276 
277     uint256 public tokensForTreasury;
278     uint256 public tokensForLiquidity;
279     uint256 public tokensForRewards;
280 
281 
282     // exlcude from fees and max transaction amount
283     mapping (address => bool) private _isExcludedFromFees;
284     mapping (address => bool) public _isExcludedMaxTransactionAmount;
285 
286     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
287     // could be subject to a maximum transfer amount
288     mapping (address => bool) public automatedMarketMakerPairs;
289     mapping (address => bool) private _isSniper;
290 
291     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
292 
293     event EnabledTrading(bool tradingActive, uint256 deadBlocks);
294     event RemovedLimits();
295 
296     event ExcludeFromFees(address indexed account, bool isExcluded);
297 
298     event UpdatedMaxBuyAmount(uint256 newAmount);
299 
300     event UpdatedMaxSellAmount(uint256 newAmount);
301 
302     event UpdatedMaxWalletAmount(uint256 newAmount);
303 
304     event UpdatedTreasuryAddress(address indexed newWallet);
305 
306     event UpdatedRewardsAddress(address indexed newWallet);
307 
308     event MaxTransactionExclusion(address _address, bool excluded);
309 
310     event SwapAndLiquify(
311         uint256 tokensSwapped,
312         uint256 ethReceived,
313         uint256 tokensIntoLiquidity
314     );
315 
316     event TransferForeignToken(address token, uint256 amount);
317 
318 
319     constructor() ERC20("Simps AI", "SIMPAI") {
320 
321         address newOwner = msg.sender; 
322 
323         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324 
325         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
326         uniswapV2Router = _uniswapV2Router;
327 
328         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
329         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
330 
331         uint256 totalSupply = 690000000 * 1e18;
332 
333         maxBuyAmount = totalSupply *  10 / 1000;
334         maxSellAmount = totalSupply *  5 / 1000;
335         maxWalletAmount = totalSupply * 10 / 1000;
336         swapTokensAtAmount = totalSupply * 50 / 100000; 
337 
338         buyTreasuryFee = 8;
339         buyLiquidityFee = 2;
340         buyRewardsFee = 0;
341         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
342 
343         sellTreasuryFee = 30;
344         sellLiquidityFee = 10;
345         sellRewardsFee = 0;
346         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
347 
348         _excludeFromMaxTransaction(newOwner, true);
349         _excludeFromMaxTransaction(address(this), true);
350         _excludeFromMaxTransaction(address(0xdead), true);
351 
352         TreasuryAddress = address(0xF39970822fdf7D768C6880CD93246178665E341C);
353         RewardsAddress = address(0xF39970822fdf7D768C6880CD93246178665E341C);
354 
355         excludeFromFees(newOwner, true);
356         excludeFromFees(address(this), true);
357         excludeFromFees(address(0xdead), true);
358 
359         _createInitialSupply(newOwner, totalSupply);
360         transferOwnership(newOwner);
361     }
362 
363     receive() external payable {}
364 
365     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
366         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
367         maxBuyAmount = newNum * (10**18);
368         emit UpdatedMaxBuyAmount(maxBuyAmount);
369     }
370 
371     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
372         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
373         maxSellAmount = newNum * (10**18);
374         emit UpdatedMaxSellAmount(maxSellAmount);
375     }
376 
377     
378     // remove limits after token is stable
379     function removeLimits() external onlyOwner {
380         limitsInEffect = false;
381         emit RemovedLimits();
382     }
383 
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
397     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
398         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
399         maxWalletAmount = newNum * (10**18);
400         emit UpdatedMaxWalletAmount(maxWalletAmount);
401     }
402 
403     // change the minimum amount of tokens to sell from fees
404     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
405         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
406         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
407         swapTokensAtAmount = newAmount;
408     }
409 
410     
411 
412     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
413         buyTreasuryFee = _treasuryFee;
414         buyLiquidityFee = _liquidityFee;
415         buyRewardsFee = _rewardsFee;
416         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyRewardsFee;
417         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
418     }
419 
420     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
421         sellTreasuryFee = _treasuryFee;
422         sellLiquidityFee = _liquidityFee;
423         sellRewardsFee = _rewardsFee;
424         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellRewardsFee;
425         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
426     }
427 
428     function excludeFromFees(address account, bool excluded) public onlyOwner {
429         _isExcludedFromFees[account] = excluded;
430         emit ExcludeFromFees(account, excluded);
431     }
432 
433 
434     function _transfer(address from, address to, uint256 amount) internal override {
435 
436         require(from != address(0), "ERC20: transfer from the zero address");
437         require(to != address(0), "ERC20: transfer to the zero address");
438         require(amount > 0, "amount must be greater than 0");
439         require(!_isSniper[from], "You are a sniper, get life!");
440         require(!_isSniper[to], "You are a sniper, get life!");
441 
442 
443         if(limitsInEffect){
444             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
445                 if(!tradingActive){
446                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
447                     require(from == owner(), "Trading is enabled");
448                 }
449 
450                 if (tradingActiveBlock > 0 && block.number < (tradingActiveBlock + deadBlocks) ) {
451                     _isSniper[to] = true;
452                 }
453 
454                 //when buy
455                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
456                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
457                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
458                 }
459                 //when sell
460                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
461                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
462                 }
463                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
464                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
465                 }
466             }
467         }
468 
469         uint256 contractTokenBalance = balanceOf(address(this));
470 
471         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
472 
473         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
474             swapping = true;
475 
476             swapBack();
477 
478             swapping = false;
479         }
480 
481         bool takeFee = true;
482         // if any account belongs to _isExcludedFromFee account then remove the fee
483         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
484             takeFee = false;
485         }
486 
487         uint256 fees = 0;
488         uint256 penaltyAmount = 0;
489         // only take fees on Trades, not on wallet transfers
490 
491         if(takeFee){
492             // bot/sniper penalty.  Tokens get transferred to Treasury wallet and ETH to liquidity.
493             if(tradingActiveBlock>0 && (tradingActiveBlock + 6) > block.number){
494                 penaltyAmount = amount * 98 / 100;
495                 super._transfer(from, TreasuryAddress, penaltyAmount);
496             }
497             // on sell
498             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
499                 fees = amount * sellTotalFees /100;
500                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
501                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
502                 tokensForRewards += fees * sellRewardsFee / sellTotalFees;
503             }
504             // on buy
505             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
506                 fees = amount * buyTotalFees / 100;
507                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
508                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
509                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
510             }
511 
512             if(fees > 0){
513                 super._transfer(from, address(this), fees);
514             }
515 
516             amount -= fees + penaltyAmount;
517         }
518 
519         super._transfer(from, to, amount);
520     }
521 
522     function swapTokensForEth(uint256 tokenAmount) private {
523 
524         // generate the uniswap pair path of token -> weth
525         address[] memory path = new address[](2);
526         path[0] = address(this);
527         path[1] = uniswapV2Router.WETH();
528 
529         _approve(address(this), address(uniswapV2Router), tokenAmount);
530 
531         // make the swap
532         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
533             tokenAmount,
534             0, // accept any amount of ETH
535             path,
536             address(this),
537             block.timestamp
538         );
539     }
540 
541     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
542         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
543 
544         _setAutomatedMarketMakerPair(pair, value);
545     }
546 
547     function _setAutomatedMarketMakerPair(address pair, bool value) private {
548         automatedMarketMakerPairs[pair] = value;
549 
550         _excludeFromMaxTransaction(pair, value);
551 
552         emit SetAutomatedMarketMakerPair(pair, value);
553     }
554 
555 
556     // once enabled, can never be turned off
557     function enableTrading(bool _status, uint256 _deadBlocks) external onlyOwner {
558         require(!tradingActive, "Cannot re enable trading");
559         tradingActive = _status;
560         swapEnabled = true;
561         emit EnabledTrading(tradingActive, _deadBlocks);
562 
563         if (tradingActive && tradingActiveBlock == 0) {
564             tradingActiveBlock = block.number;
565             deadBlocks = _deadBlocks;
566         }
567     }
568 
569     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
570         // approve token transfer to cover all possible scenarios
571         _approve(address(this), address(uniswapV2Router), tokenAmount);
572 
573         // add the liquidity
574         uniswapV2Router.addLiquidityETH{value: ethAmount}(
575             address(this),
576             tokenAmount,
577             0, // slippage is unavoidable
578             0, // slippage is unavoidable
579             address(owner()),
580             block.timestamp
581         );
582     }
583 
584      
585     function multiSend(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
586 
587         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
588         require(addresses.length == tokens.length,"Mismatch between Address and token count");
589 
590         uint256 SCCC = 0;
591 
592         for(uint i=0; i < addresses.length; i++){
593             SCCC = SCCC + (tokens[i] * 10**decimals());
594         }
595 
596         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
597 
598         for(uint i=0; i < addresses.length; i++){
599             _transfer(msg.sender,addresses[i],(tokens[i] * 10**decimals()));
600         }
601     }
602 
603 
604     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
605         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
606         TreasuryAddress = payable(_TreasuryAddress);
607         emit UpdatedTreasuryAddress(_TreasuryAddress);
608     }
609 
610     function setRewardsAddress(address _RewardsAddress) external onlyOwner {
611         require(_RewardsAddress != address(0), "_RewardsAddress address cannot be 0");
612         RewardsAddress = payable(_RewardsAddress);
613         emit UpdatedRewardsAddress(_RewardsAddress);
614     }
615 
616 
617     function manage_Sniper(address sniper_address, bool status) external onlyOwner {
618         require(_isSniper[sniper_address] != status, "Account is already in the said state");
619         _isSniper[sniper_address] = status;
620     }
621 
622     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
623         for (uint256 i; i < addresses.length; ++i) {
624                 _isSniper[addresses[i]] = status;
625         }
626     }
627 
628     function isSniper(address account) public view returns (bool) {
629         return _isSniper[account];
630     }
631 
632    
633     function swapBack() private {
634         uint256 contractBalance = balanceOf(address(this));
635         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForRewards;
636 
637         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
638 
639         if(contractBalance > swapTokensAtAmount * 10){
640             contractBalance = swapTokensAtAmount * 10;
641         }
642 
643         bool success;
644 
645         // Halve the amount of liquidity tokens
646         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
647 
648         swapTokensForEth(contractBalance - liquidityTokens);
649 
650         uint256 ethBalance = address(this).balance;
651         uint256 ethForLiquidity = ethBalance;
652 
653         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
654         uint256 ethForRewards = ethBalance * tokensForRewards / (totalTokensToSwap - (tokensForLiquidity/2));
655 
656         ethForLiquidity -= ethForTreasury + ethForRewards;
657 
658         tokensForLiquidity = 0;
659         tokensForTreasury = 0;
660         tokensForRewards = 0;
661 
662         if(liquidityTokens > 0 && ethForLiquidity > 0){
663             addLiquidity(liquidityTokens, ethForLiquidity);
664         }
665 
666         (success,) = address(RewardsAddress).call{value: ethForRewards}("");
667 
668         (success,) = address(TreasuryAddress).call{value: address(this).balance}("");
669     }
670 
671     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
672         require(_token != address(0), "_token address cannot be 0");
673         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
674         _sent = IERC20(_token).transfer(_to, _contractBalance);
675         emit TransferForeignToken(_token, _contractBalance);
676     }
677 
678     // withdraw ETH if stuck or someone sends to the address
679     function withdrawStuckETH() external onlyOwner {
680         bool success;
681         (success,) = address(msg.sender).call{value: address(this).balance}("");
682     }
683 
684 }