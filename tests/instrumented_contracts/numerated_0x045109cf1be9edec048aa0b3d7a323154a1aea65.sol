1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-31
3 */
4 
5 // SPDX-License-Identifier: MIT                                                                               
6                                                     
7 pragma solidity 0.8.17;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     function name() external view returns (string memory);
28     function symbol() external view returns (string memory);
29     function decimals() external view returns (uint8);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 contract ERC20 is Context, IERC20 {
36     mapping(address => uint256) private _balances;
37     mapping(address => mapping(address => uint256)) private _allowances;
38     uint256 private _totalSupply;
39     string private _name;
40     string private _symbol;
41 
42     constructor(string memory name_, string memory symbol_) {
43         _name = name_;
44         _symbol = symbol_;
45     }
46 
47     function name() public view virtual override returns (string memory) {
48         return _name;
49     }
50 
51     function symbol() public view virtual override returns (string memory) {
52         return _symbol;
53     }
54 
55     function decimals() public view virtual override returns (uint8) {
56         return 18;
57     }
58 
59     function totalSupply() public view virtual override returns (uint256) {
60         return _totalSupply;
61     }
62 
63     function balanceOf(address account) public view virtual override returns (uint256) {
64         return _balances[account];
65     }
66 
67     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
68         _transfer(_msgSender(), recipient, amount);
69         return true;
70     }
71 
72     function allowance(address owner, address spender) public view virtual override returns (uint256) {
73         return _allowances[owner][spender];
74     }
75 
76     function approve(address spender, uint256 amount) public virtual override returns (bool) {
77         _approve(_msgSender(), spender, amount);
78         return true;
79     }
80 
81     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
82         _transfer(sender, recipient, amount);
83 
84         uint256 currentAllowance = _allowances[sender][_msgSender()];
85         if(currentAllowance != type(uint256).max){
86             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
87             unchecked {
88                 _approve(sender, _msgSender(), currentAllowance - amount);
89             }
90         }
91 
92         return true;
93     }
94 
95     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
96         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
97         return true;
98     }
99 
100     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
101         uint256 currentAllowance = _allowances[_msgSender()][spender];
102         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
103         unchecked {
104             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
105         }
106 
107         return true;
108     }
109 
110     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
111         require(sender != address(0), "ERC20: transfer from the zero address");
112         require(recipient != address(0), "ERC20: transfer to the zero address");
113 
114         uint256 senderBalance = _balances[sender];
115         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
116         unchecked {
117             _balances[sender] = senderBalance - amount;
118         }
119         _balances[recipient] += amount;
120 
121         emit Transfer(sender, recipient, amount);
122     }
123 
124     function _createInitialSupply(address account, uint256 amount) internal virtual {
125         require(account != address(0), "ERC20: mint to the zero address");
126 
127         _totalSupply += amount;
128         _balances[account] += amount;
129         emit Transfer(address(0), account, amount);
130     }
131 
132     function _approve(address owner, address spender, uint256 amount) internal virtual {
133         require(owner != address(0), "ERC20: approve from the zero address");
134         require(spender != address(0), "ERC20: approve to the zero address");
135 
136         _allowances[owner][spender] = amount;
137         emit Approval(owner, spender, amount);
138     }
139 }
140 
141 contract Ownable is Context {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145     
146     constructor () {
147         address msgSender = _msgSender();
148         _owner = msgSender;
149         emit OwnershipTransferred(address(0), msgSender);
150     }
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }
155 
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     function renounceOwnership() external virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 }
172 
173 interface IDexRouter {
174     function factory() external pure returns (address);
175     function WETH() external pure returns (address);
176     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
177     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
178     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
179     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
180     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
181     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
182 }
183 
184 interface IDexFactory {
185     function createPair(address tokenA, address tokenB) external returns (address pair);
186 }
187 
188 contract Elevate is ERC20, Ownable {
189 
190     uint256 public maxTxnAmount;
191 
192     IDexRouter public immutable dexRouter;
193     address public immutable lpPairEth;
194 
195     bool private swapping;
196     uint256 public swapTokensAtAmount;
197 
198     address public impactAddress;
199     address public crfAddress;
200     address public operationsAddress;
201     address public liquidityAddress;
202     address public treasuryAddress;
203 
204     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
205     mapping (address => bool) public restrictedWallets;
206 
207     bool public limitsInEffect = true;
208     bool public tradingActive = false;
209     bool public swapEnabled = false;
210     
211     uint256 public buyTotalFees;
212     uint256 public buyLiquidityFee;
213     uint256 public buyImpactFee;
214     uint256 public buyCRFFee;
215     uint256 public buyOperationsFee;
216     uint256 public buyTreasuryFee;
217 
218     uint256 public sellTotalFees;
219     uint256 public sellImpactFee;
220     uint256 public sellLiquidityFee;
221     uint256 public sellCRFFee;
222     uint256 public sellOperationsFee;
223     uint256 public sellTreasuryFee;
224 
225     uint256 constant FEE_DIVISOR = 10000;
226 
227     uint256 public tokensForImpact;
228     uint256 public tokensForLiquidity;
229     uint256 public tokensForCRF;
230     uint256 public tokensForOperations;
231     uint256 public tokensForTreasury;
232     
233     mapping (address => bool) private _isExcludedFromFees;
234     mapping (address => bool) public _isExcludedMaxTransactionAmount;
235 
236     mapping (address => bool) public automatedMarketMakerPairs;
237 
238     // Events
239 
240     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
241     event EnabledTrading();
242     event RemovedLimits();
243     event ExcludeFromFees(address indexed account, bool isExcluded);
244     event UpdatedMaxTxnAmount(uint256 newAmount);
245     event UpdatedBuyFee(uint256 newAmount);
246     event UpdatedSellFee(uint256 newAmount);
247     event UpdatedImpactAddress(address indexed newWallet);
248     event UpdatedLiquidityAddress(address indexed newWallet);
249     event UpdatedCRFAddress(address indexed newWallet);
250     event UpdatedOperationsAddress(address indexed newWallet);
251     event UpdatedTreasuryAddress(address indexed newWallet);
252     event MaxTransactionExclusion(address _address, bool excluded);
253     event OwnerForcedSwapBack(uint256 timestamp);
254     event TransferForeignToken(address token, uint256 amount);
255 
256     constructor() ERC20("Elevate", "ELEV") {
257 
258         address _dexRouter;
259 
260         // automatically detect router/desired stablecoin
261         if(block.chainid == 1){
262             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
263         } else if(block.chainid == 5){
264             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Goerli ETH: Uniswap V2
265         } else if(block.chainid == 97){
266             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
267         } else {
268             revert("Chain not configured");
269         }
270 
271         address newOwner = msg.sender; // can leave alone if owner is deployer.
272 
273         dexRouter = IDexRouter(_dexRouter);
274 
275         // create pair
276 
277         lpPairEth = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
278         setAutomatedMarketMakerPair(address(lpPairEth), true);
279 
280         uint256 totalSupply = 5 * 1e9 * 1e18;
281         
282         maxTxnAmount = totalSupply * 25 / 10000;
283         swapTokensAtAmount = totalSupply * 25 / 100000;
284 
285         buyImpactFee = 0;
286         buyLiquidityFee = 100;
287         buyCRFFee = 100;
288         buyOperationsFee = 100;
289         buyTreasuryFee = 100;
290         buyTotalFees = buyImpactFee + buyLiquidityFee + buyCRFFee + buyOperationsFee + buyTreasuryFee;
291 
292 
293         sellImpactFee = 0;
294         sellLiquidityFee = 100;
295         sellCRFFee = 100;
296         sellOperationsFee = 100;
297         sellTreasuryFee = 100;
298         sellTotalFees = sellImpactFee + sellLiquidityFee + sellCRFFee + sellOperationsFee + sellTreasuryFee;
299 
300         // update these!
301         impactAddress = address(newOwner);
302         liquidityAddress = address(newOwner);
303         operationsAddress = address(newOwner);
304         crfAddress = address(newOwner);
305         treasuryAddress = address(newOwner);
306 
307         _excludeFromMaxTransaction(newOwner, true);
308         _excludeFromMaxTransaction(address(this), true);
309         _excludeFromMaxTransaction(address(0xdead), true);
310         _excludeFromMaxTransaction(address(impactAddress), true);
311         _excludeFromMaxTransaction(address(liquidityAddress), true);
312         _excludeFromMaxTransaction(address(operationsAddress), true);
313         _excludeFromMaxTransaction(address(crfAddress), true);
314         _excludeFromMaxTransaction(address(dexRouter), true);
315 
316         excludeFromFees(newOwner, true);
317         excludeFromFees(address(this), true);
318         excludeFromFees(address(0xdead), true);
319         excludeFromFees(address(impactAddress), true);
320         excludeFromFees(address(liquidityAddress), true);
321         excludeFromFees(address(operationsAddress), true);
322         excludeFromFees(address(crfAddress), true);
323         excludeFromFees(address(dexRouter), true);
324 
325         _createInitialSupply(address(newOwner), totalSupply);
326         transferOwnership(newOwner);
327 
328         _approve(address(this), address(dexRouter), type(uint256).max);
329         _approve(address(newOwner), address(dexRouter), totalSupply);
330     }
331 
332     receive() external payable {}
333 
334     // Owner Functions
335 
336     function enableTrading() external onlyOwner {
337         require(tradingActiveBlock == 0, "enableTrading already called");
338         tradingActive = true;
339         swapEnabled = true;
340         tradingActiveBlock = block.number;
341         emit EnabledTrading();
342     }
343 
344     function pauseTrading() external onlyOwner {
345         require(tradingActiveBlock > 0, "enableTrading first");
346         require(tradingActive, "Trading paused");
347         tradingActive = false;
348     }
349 
350     function unpauseTrading() external onlyOwner {
351         require(tradingActiveBlock > 0, "enableTrading first");
352         require(!tradingActive, "Trading unpaused");
353         tradingActive = true;
354     }
355 
356     function manageRestrictedWallets(address[] calldata wallets,  bool restricted) external onlyOwner {
357         for(uint256 i = 0; i < wallets.length; i++){
358             restrictedWallets[wallets[i]] = restricted;
359         }
360     }
361     
362     function removeLimits() external onlyOwner {
363         limitsInEffect = false;
364         maxTxnAmount = totalSupply();
365         emit RemovedLimits();
366     }
367 
368     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
369         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "too low");
370         maxTxnAmount = newNum * (10**18);
371         emit UpdatedMaxTxnAmount(maxTxnAmount);
372     }
373 
374     // change the minimum amount of tokens to sell from fees
375     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
376   	    require(newAmount >= totalSupply() * 1 / 1000000, "too low");
377   	    require(newAmount <= totalSupply() * 1 / 1000, "too high");
378   	    swapTokensAtAmount = newAmount;
379   	}
380     
381     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
382         require(_token != address(0), "zero address");
383         require(_token != address(this), "Can't withdraw native tokens");
384         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
385         _sent = IERC20(_token).transfer(_to, _contractBalance);
386         emit TransferForeignToken(_token, _contractBalance);
387     }
388 
389     // withdraw ETH if stuck or someone sends to the address
390     function withdrawStuckETH() external onlyOwner {
391         bool success;
392         (success,) = address(msg.sender).call{value: address(this).balance}("");
393     }
394 
395     function setImpactAddress(address _impactAddress) external onlyOwner {
396         require(_impactAddress != address(0), "zero address");
397         impactAddress = payable(_impactAddress);
398         emit UpdatedImpactAddress(_impactAddress);
399     }
400 
401     function setCRFAddress(address _crfAddress) external onlyOwner {
402         require(_crfAddress != address(0), "zero address");
403         crfAddress = payable(_crfAddress);
404         emit UpdatedCRFAddress(_crfAddress);
405     }
406     
407     function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
408         require(_liquidityAddress != address(0), "zero address");
409         liquidityAddress = payable(_liquidityAddress);
410         emit UpdatedLiquidityAddress(_liquidityAddress);
411     }
412 
413     function setOperationsAddress(address _operationsAddress) external onlyOwner {
414         require(_operationsAddress != address(0), "zero address");
415         operationsAddress = payable(_operationsAddress);
416         emit UpdatedOperationsAddress(_operationsAddress);
417     }
418 
419     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
420         require(_treasuryAddress != address(0), "zero address");
421         treasuryAddress = payable(_treasuryAddress);
422         emit UpdatedTreasuryAddress(_treasuryAddress);
423     }
424 
425     function forceSwapBack() external onlyOwner {
426         require(balanceOf(address(this)) >= swapTokensAtAmount, "Amount not high enough");
427         swapping = true;
428         swapBackEth();
429         swapping = false;
430         emit OwnerForcedSwapBack(block.timestamp);
431     }
432     
433     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
434         require(wallets.length == amountsInTokens.length, "length mismatch");
435         require(wallets.length < 600, "600 max");
436         for(uint256 i = 0; i < wallets.length; i++){
437             address wallet = wallets[i];
438             uint256 amount = amountsInTokens[i];
439             super._transfer(msg.sender, wallet, amount);
440         }
441     }
442     
443     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
444         if(!isEx){
445             require(updAds != lpPairEth, "pair cannot be removed");
446         }
447         _isExcludedMaxTransactionAmount[updAds] = isEx;
448     }
449 
450     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
451         require(pair != lpPairEth || value, "pair cannot be removed");
452         automatedMarketMakerPairs[pair] = value;
453         _excludeFromMaxTransaction(pair, value);
454         emit SetAutomatedMarketMakerPair(pair, value);
455     }
456 
457     function updateBuyFees(uint256 _impactFee, uint256 _liquidityFee, uint256 _crfFee, uint256 _operationsFee, uint256 _treasuryFee) external onlyOwner {
458         buyImpactFee = _impactFee;
459         buyLiquidityFee = _liquidityFee;
460         buyCRFFee = _crfFee;
461         buyOperationsFee = _operationsFee;
462         buyTreasuryFee = _treasuryFee;
463         buyTotalFees = buyImpactFee + buyLiquidityFee + buyCRFFee + buyOperationsFee + buyTreasuryFee;
464         require(buyTotalFees <= 1000, "Fees too high");
465         emit UpdatedBuyFee(buyTotalFees);
466     }
467 
468     function updateSellFees(uint256 _impactFee, uint256 _liquidityFee, uint256 _crfFee, uint256 _operationsFee, uint256 _treasuryFee) external onlyOwner {
469         sellImpactFee = _impactFee;
470         sellLiquidityFee = _liquidityFee;
471         sellCRFFee = _crfFee;
472         sellOperationsFee = _operationsFee;
473         sellTreasuryFee = _treasuryFee;
474         sellTotalFees = sellImpactFee + sellLiquidityFee + sellCRFFee + sellOperationsFee + sellTreasuryFee;
475         require(sellTotalFees <= 1000, "Fees too high");
476         emit UpdatedSellFee(sellTotalFees);
477     }
478 
479     function excludeFromFees(address account, bool excluded) public onlyOwner {
480         _isExcludedFromFees[account] = excluded;
481         emit ExcludeFromFees(account, excluded);
482     }
483 
484     // private / internal functions
485 
486     function _transfer(address from, address to, uint256 amount) internal override {
487 
488         require(from != address(0), "ERC20: transfer from the zero address");
489         require(to != address(0), "ERC20: transfer to the zero address");
490         // transfer of 0 is allowed, but triggers no logic.  In case of staking where a staking pool is paying out 0 rewards.
491         if(amount == 0){
492             super._transfer(from, to, 0);
493             return;
494         }
495 
496         require(!restrictedWallets[from] && !restrictedWallets[to], "blocked address");
497         
498         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
499             super._transfer(from, to, amount);
500             return;
501         }
502         
503         require(tradingActive, "Trading is not active.");
504 
505         
506 
507         if(limitsInEffect){
508             //on buy or sell
509             if ((automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) || (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from])) {
510                 require(amount <= maxTxnAmount, "max tx exceeded");
511             }
512         }
513 
514         if(balanceOf(address(this)) >= swapTokensAtAmount && swapEnabled && !swapping && automatedMarketMakerPairs[to]) {
515             swapping = true;
516             swapBackEth();
517             swapping = false;
518         }
519 
520         uint256 fees = 0;
521 
522         // only take fees on buys/sells, do not take on wallet transfers
523         // on sell
524         if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
525             fees = amount * sellTotalFees / FEE_DIVISOR;
526             tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
527             tokensForImpact += fees * sellImpactFee / sellTotalFees;
528             tokensForCRF += fees * sellCRFFee / sellTotalFees;
529             tokensForOperations += fees * sellOperationsFee / sellTotalFees;
530             tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
531         }
532 
533         // on buy
534         else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
535             fees = amount * buyTotalFees / FEE_DIVISOR;
536             tokensForImpact += fees * buyImpactFee / buyTotalFees;
537             tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
538             tokensForCRF += fees * buyCRFFee / buyTotalFees;
539             tokensForOperations += fees * buyOperationsFee / buyTotalFees;
540             tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
541         }
542         
543         if(fees > 0){    
544             super._transfer(from, address(this), fees);
545         }
546         
547         amount -= fees;
548 
549         super._transfer(from, to, amount);
550     }
551 
552     function swapBackEth() private {
553         bool success;
554 
555         uint256 contractBalance = balanceOf(address(this));
556         uint256 totalTokensToSwap = tokensForLiquidity + tokensForImpact + tokensForCRF + tokensForOperations + tokensForTreasury;
557         
558         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
559 
560         if(contractBalance > swapTokensAtAmount * 10){
561             contractBalance = swapTokensAtAmount * 10;
562         }
563         
564         // Halve the amount of liquidity tokens
565         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
566         
567         swapTokensForEth(contractBalance - liquidityTokens);
568         
569         uint256 ethBalance = address(this).balance;
570         uint256 ethForLiquidity = ethBalance;
571 
572         uint256 ethForImpact = ethBalance * tokensForImpact / (totalTokensToSwap - (tokensForLiquidity/2));
573         uint256 ethForCRF = ethBalance * tokensForCRF / (totalTokensToSwap - (tokensForLiquidity/2));
574         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
575         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
576 
577         ethForLiquidity -= ethForImpact + ethForCRF + ethForOperations + ethForTreasury;
578             
579         tokensForLiquidity = 0;
580         tokensForImpact = 0;
581         tokensForCRF = 0;
582         tokensForOperations = 0;
583         tokensForTreasury = 0;
584         
585         if(liquidityTokens > 0 && ethForLiquidity > 0){
586             addLiquidityEth(liquidityTokens, ethForLiquidity);
587         }
588 
589         if(ethForCRF > 0){
590             (success, ) = crfAddress.call{value: ethForCRF}("");
591         }
592 
593         if(ethForOperations > 0){
594             (success, ) = operationsAddress.call{value: ethForOperations}("");
595         }
596 
597          if(ethForTreasury > 0){
598             (success, ) = treasuryAddress.call{value: ethForTreasury}("");
599         }
600 
601         if(address(this).balance > 0){
602             (success, ) = impactAddress.call{value: address(this).balance}("");
603         }
604     }
605 
606     function addLiquidityEth(uint256 tokenAmount, uint256 ethAmount) private {
607         // add the liquidity
608         dexRouter.addLiquidityETH{value: ethAmount}(address(this), tokenAmount, 0, 0, address(liquidityAddress), block.timestamp);
609     }
610 
611     function swapTokensForEth(uint256 tokenAmount) private {
612 
613         // generate the uniswap pair path of token -> weth
614         address[] memory path = new address[](2);
615         path[0] = address(this);
616         path[1] = dexRouter.WETH();
617 
618         // make the swap
619         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
620     }
621 
622     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
623         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
624         emit MaxTransactionExclusion(updAds, isExcluded);
625     }
626 
627     //views
628 
629     function getTier(address account) external view returns (uint256){
630         uint256 accountBalance = balanceOf(account);
631         uint256 supply = totalSupply();
632         if(accountBalance * 1e18 / supply >= 0.00075 ether){
633             return 5;
634         }
635         if(accountBalance * 1e18 / supply >= 0.00060 ether){
636             return 4;
637         }
638         if(accountBalance * 1e18 / supply >= 0.00045 ether){
639             return 3;
640         }
641         if(accountBalance * 1e18 / supply >= 0.00030 ether){
642             return 2;
643         }
644         if(accountBalance * 1e18 / supply >= 0.00015 ether){
645             return 1;
646         }
647         return 0;
648     }
649 }