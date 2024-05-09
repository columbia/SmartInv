1 /**
2 
3 https://medium.com/@HadesUnderworld/hades-has-awoken-18bfe636da49
4 
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity 0.8.15;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address payable) {
12         return payable(msg.sender);
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(
25         address indexed previousOwner,
26         address indexed newOwner
27     );
28 
29     constructor() {
30         address msgSender = _msgSender();
31         _owner = msgSender;
32         emit OwnershipTransferred(address(0), msgSender);
33     }
34 
35     function owner() public view returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(_owner == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         emit OwnershipTransferred(_owner, address(0));
46         _owner = address(0);
47     }
48 
49     function transferOwnership(address newOwner) public virtual onlyOwner {
50         require(
51             newOwner != address(0),
52             "Ownable: new owner is the zero address"
53         );
54         emit OwnershipTransferred(_owner, newOwner);
55         _owner = newOwner;
56     }
57 }
58 
59 interface IDexRouter {
60     function factory() external pure returns (address);
61 
62     function WETH() external pure returns (address);
63 
64     function swapExactTokensForETHSupportingFeeOnTransferTokens(
65         uint256 amountIn,
66         uint256 amountOutMin,
67         address[] calldata path,
68         address to,
69         uint256 deadline
70     ) external;
71 
72     function swapExactETHForTokensSupportingFeeOnTransferTokens(
73         uint256 amountOutMin,
74         address[] calldata path,
75         address to,
76         uint256 deadline
77     ) external payable;
78 
79     function addLiquidityETH(
80         address token,
81         uint256 amountTokenDesired,
82         uint256 amountTokenMin,
83         uint256 amountETHMin,
84         address to,
85         uint256 deadline
86     )
87         external
88         payable
89         returns (
90             uint256 amountToken,
91             uint256 amountETH,
92             uint256 liquidity
93         );
94 
95     function removeLiquidityETH(
96         address token,
97         uint256 liquidity,
98         uint256 amountTokenMin,
99         uint256 amountETHMin,
100         address to,
101         uint256 deadline
102     ) external returns (uint256 amountToken, uint256 amountETH);
103 
104     function getAmountsOut(uint256 amountIn, address[] calldata path)
105         external
106         view
107         returns (uint256[] memory amounts);
108 }
109 
110 interface IDexFactory {
111     function getPair(address tokenA, address tokenB)
112         external
113         view
114         returns (address pair);
115 
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120 
121 interface IERC20 {
122     function totalSupply() external view returns (uint256);
123 
124     function balanceOf(address account) external view returns (uint256);
125 
126     function transfer(address recipient, uint256 amount)
127         external
128         returns (bool);
129 
130     function allowance(address owner, address spender)
131         external
132         view
133         returns (uint256);
134 
135     function approve(address spender, uint256 amount) external returns (bool);
136 
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) external returns (bool);
142 
143     event Transfer(address indexed from, address indexed to, uint256 value);
144     event Approval(
145         address indexed owner,
146         address indexed spender,
147         uint256 value
148     );
149 }
150 
151 contract Hades is Context, IERC20, Ownable {
152     string private constant _name = "Underworld";
153     string private constant _symbol = "Hades";
154     uint8 private constant _decimals = 18;
155 
156     address payable public marketingWalletAddress =
157         payable(0x6f9753730fF956D2cdf66A6Bd69145f7a9fb633F);
158     address payable private constant initialLpReceiver =
159         payable(0x1D6eE36D23012660DfFd470e9142736E7d3F3C77);
160 
161     mapping(address => uint256) private balances;
162     mapping(address => mapping(address => uint256)) private allowances;
163 
164     mapping(address => bool) public isExcludedFromFee;
165     mapping(address => bool) public isMarketPair;
166     mapping(address => bool) public isEarlyBuyer;
167     mapping(address => bool) public isTxLimitExempt;
168     mapping(address => bool) public isWalletLimitExempt;
169 
170     uint256 public buyTax = 666;
171     uint256 public sellTax = 666;
172 
173     uint256 public lpShare = 200;
174     uint256 public marketingShare = 366;
175     uint256 public autoBurnShare = 100;
176 
177     uint256 private constant _totalSupply = 6666666 * 10**_decimals;
178     uint256 public swapThreshold = 1000 * 10**_decimals;
179     uint256 public maxTxAmount = 33333 * 10**_decimals;
180     uint256 public walletMax = 66666 * 10**_decimals;
181 
182     IDexRouter public immutable dexRouter;
183     address public lpPair;
184 
185     bool private isInSwap;
186     bool public swapEnabled = true;
187     bool public swapByLimitOnly = false;
188     bool public launched = false;
189     bool public checkWalletLimit = true;
190     bool public snipeBlockExpired = false;
191 
192     uint256 public launchBlock = 0;
193     uint256 public snipeBlockAmount = 0;
194     uint256 public sellBlockAmount = 0;
195 
196     event SwapSettingsUpdated(
197         bool swapEnabled_,
198         uint256 swapThreshold_,
199         bool swapByLimitOnly_
200     );
201     event SwapTokensForETH(uint256 amountIn, address[] path);
202     event AccountWhitelisted(
203         address account,
204         bool feeExempt,
205         bool walletLimitExempt,
206         bool txLimitExempt
207     );
208     event RouterVersionChanged(address newRouterAddress);
209     event TaxesChanged(uint256 newBuyTax, uint256 newSellTax);
210     event TaxDistributionChanged(
211         uint256 newLpShare,
212         uint256 newMarketingShare,
213         uint256 newAutoBurnShare
214     );
215     event MarketingWalletChanged(address marketingWalletAddress_);
216     event EarlyBuyerUpdated(address account, bool isEarlyBuyer_);
217     event MarketPairUpdated(address account, bool isMarketPair_);
218     event WalletLimitChanged(uint256 walletMax_);
219     event MaxTxAmountChanged(uint256 maxTxAmount_);
220     event MaxWalletCheckChanged(bool checkWalletLimit_);
221 
222     modifier lockTheSwap() {
223         isInSwap = true;
224         _;
225         isInSwap = false;
226     }
227 
228     constructor() payable {
229         dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
230         
231         isExcludedFromFee[owner()] = true;
232         isExcludedFromFee[address(this)] = true;
233         isExcludedFromFee[address(marketingWalletAddress)] = true;
234         isExcludedFromFee[address(initialLpReceiver)] = true;
235         isExcludedFromFee[address(dexRouter)] = true;
236 
237         isTxLimitExempt[owner()] = true;
238         isTxLimitExempt[address(this)] = true;
239         isTxLimitExempt[address(marketingWalletAddress)] = true;
240         isTxLimitExempt[address(initialLpReceiver)] = true;
241         isTxLimitExempt[address(dexRouter)] = true;
242 
243         isWalletLimitExempt[owner()] = true;
244         isWalletLimitExempt[address(this)] = true;
245         isWalletLimitExempt[address(marketingWalletAddress)] = true;
246         isWalletLimitExempt[address(initialLpReceiver)] = true;
247         isWalletLimitExempt[address(dexRouter)] = true;
248 
249         allowances[address(this)][address(dexRouter)] = _totalSupply;
250         balances[address(this)] = 4889333 * (10 ** decimals());
251         emit Transfer(address(0), address(this), balanceOf(address(this)));
252         balances[initialLpReceiver] = _totalSupply - balanceOf(address(this));
253         emit Transfer(address(0), initialLpReceiver, balanceOf(initialLpReceiver));
254     }
255 
256     //to receive ETH from dexRouter when swapping
257     receive() external payable {}
258 
259     function name() public pure returns (string memory) {
260         return _name;
261     }
262 
263     function symbol() public pure returns (string memory) {
264         return _symbol;
265     }
266 
267     function decimals() public pure returns (uint8) {
268         return _decimals;
269     }
270 
271     function totalSupply() public pure override returns (uint256) {
272         return _totalSupply;
273     }
274 
275     function getCirculatingSupply() public view returns (uint256) {
276         return _totalSupply - balanceOf(address(0xdead));
277     }
278 
279     function balanceOf(address account) public view override returns (uint256) {
280         return balances[account];
281     }
282 
283     function allowance(address owner_, address spender)
284         public
285         view
286         override
287         returns (uint256)
288     {
289         return allowances[owner_][spender];
290     }
291 
292     function increaseAllowance(address spender, uint256 addedValue)
293         public
294         virtual
295         returns (bool)
296     {
297         _approve(
298             _msgSender(),
299             spender,
300             allowances[_msgSender()][spender] + addedValue
301         );
302         return true;
303     }
304 
305     function decreaseAllowance(address spender, uint256 subtractedValue)
306         public
307         virtual
308         returns (bool)
309     {
310         _approve(
311             _msgSender(),
312             spender,
313             allowances[_msgSender()][spender] - subtractedValue
314         );
315         return true;
316     }
317 
318     function approve(address spender, uint256 amount)
319         public
320         override
321         returns (bool)
322     {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326 
327     function _approve(
328         address owner_,
329         address spender,
330         uint256 amount
331     ) private {
332         require(owner_ != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334 
335         allowances[owner_][spender] = amount;
336         emit Approval(owner_, spender, amount);
337     }
338 
339     function transfer(address recipient, uint256 amount)
340         public
341         override
342         returns (bool)
343     {
344         _transfer(_msgSender(), recipient, amount);
345         return true;
346     }
347 
348     function transferFrom(
349         address sender,
350         address recipient,
351         uint256 amount
352     ) public override returns (bool) {
353         _transfer(sender, recipient, amount);
354         _approve(
355             sender,
356             _msgSender(),
357             allowances[sender][_msgSender()] - amount
358         );
359         return true;
360     }
361 
362     function setIsEarlyBuyer(address account, bool isEarlyBuyer_)
363         public
364         onlyOwner
365     {
366         isEarlyBuyer[account] = isEarlyBuyer_;
367         emit EarlyBuyerUpdated(account, isEarlyBuyer_);
368     }
369 
370     function massSetIsEarlyBuyer(address[] calldata accounts, bool isEarlyBuyer_)
371         public
372         onlyOwner
373     {
374         for(uint256 i = 0; i < accounts.length; i++){
375             isEarlyBuyer[accounts[i]] = isEarlyBuyer_;
376             emit EarlyBuyerUpdated(accounts[i], isEarlyBuyer_);
377         }
378     }
379 
380     function setMarketPairStatus(address account, bool isMarketPair_)
381         public
382         onlyOwner
383     {
384         isMarketPair[account] = isMarketPair_;
385         emit MarketPairUpdated(account, isMarketPair_);
386     }
387 
388     function setTaxes(uint256 newBuyTax, uint256 newSellTax)
389         external
390         onlyOwner
391     {
392         require(newBuyTax <= 3000, "Cannot exceed 30%");
393         require(newSellTax <= 3000, "Cannot exceed 30%");
394         buyTax = newBuyTax;
395         sellTax = newSellTax;
396         emit TaxesChanged(newBuyTax, newSellTax);
397     }
398 
399     function setTaxDistribution(
400         uint256 newLpShare,
401         uint256 newMarketingShare,
402         uint256 newAutoBurnShare
403     ) external onlyOwner {
404         lpShare = newLpShare;
405         marketingShare = newMarketingShare;
406         autoBurnShare = newAutoBurnShare;
407         emit TaxDistributionChanged(
408             newLpShare,
409             newMarketingShare,
410             newAutoBurnShare
411         );
412     }
413 
414     function setMaxTxAmount(uint256 maxTxAmount_) external onlyOwner {
415         require(maxTxAmount_ >= totalSupply() * 5 / 1000);
416         maxTxAmount = maxTxAmount_;
417         emit MaxTxAmountChanged(maxTxAmount_);
418     }
419 
420     function setWalletLimit(uint256 walletMax_) external onlyOwner {
421         require(walletMax_ >= totalSupply() * 1 / 100);
422         walletMax = walletMax_;
423         emit WalletLimitChanged(walletMax_);
424     }
425 
426     function enableDisableWalletLimit(bool checkWalletLimit_)
427         external
428         onlyOwner
429     {
430         checkWalletLimit = checkWalletLimit_;
431         emit MaxWalletCheckChanged(checkWalletLimit_);
432     }
433 
434     function whitelistAccount(
435         address account,
436         bool feeExempt,
437         bool walletLimitExempt,
438         bool txLimitExempt
439     ) public onlyOwner {
440         isExcludedFromFee[account] = feeExempt;
441         isWalletLimitExempt[account] = walletLimitExempt;
442         isTxLimitExempt[account] = txLimitExempt;
443         emit AccountWhitelisted(
444             account,
445             feeExempt,
446             walletLimitExempt,
447             txLimitExempt
448         );
449     }
450 
451     function updateSwapSettings(
452         bool swapEnabled_,
453         uint256 swapThreshold_,
454         bool swapByLimitOnly_
455     ) public onlyOwner {
456         swapEnabled = swapEnabled_;
457         swapThreshold = swapThreshold_;
458         swapByLimitOnly = swapByLimitOnly_;
459         emit SwapSettingsUpdated(
460             swapEnabled_,
461             swapThreshold_,
462             swapByLimitOnly_
463         );
464     }
465 
466     function setMarketingWalletAddress(address marketingWalletAddress_)
467         external
468         onlyOwner
469     {
470         require(
471             marketingWalletAddress_ != address(0),
472             "New address cannot be zero address"
473         );
474         marketingWalletAddress = payable(marketingWalletAddress_);
475         emit MarketingWalletChanged(marketingWalletAddress_);
476     }
477 
478     function transferToAddressETH(address payable recipient, uint256 amount)
479         private
480     {
481         bool success;
482         (success, ) = address(recipient).call{value: amount}("");
483     }
484 
485     function _transfer(
486         address sender,
487         address recipient,
488         uint256 amount
489     ) private returns (bool) {
490         if (isInSwap) {
491             return _basicTransfer(sender, recipient, amount);
492         } else {
493             require(
494                 sender != address(0),
495                 "ERC20: transfer from the zero address"
496             );
497             require(
498                 recipient != address(0),
499                 "ERC20: transfer to the zero address"
500             );
501             require(
502                 !isEarlyBuyer[sender] && !isEarlyBuyer[recipient],
503                 "To/from address is blacklisted!"
504             );
505 
506             if (!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
507                 require(launched, "Not Launched.");
508                 if (isMarketPair[sender] || isMarketPair[recipient]) {
509                     require(
510                         amount <= maxTxAmount,
511                         "Transfer amount exceeds the maxTxAmount."
512                     );
513                 }
514                 if (!snipeBlockExpired) {
515                     checkIfBot(sender, recipient);
516                 }
517             }
518 
519             bool isTaxFree = ((!isMarketPair[sender] &&
520                 !isMarketPair[recipient]) ||
521                 isExcludedFromFee[sender] ||
522                 isExcludedFromFee[recipient]);
523 
524             if (
525                 !isTaxFree && !isMarketPair[sender] && swapEnabled && !isInSwap
526             ) {
527                 uint256 contractTokenBalance = balanceOf(address(this));
528                 bool overMinimumTokenBalance = contractTokenBalance >=
529                     swapThreshold;
530                 if (overMinimumTokenBalance) {
531                     if (swapByLimitOnly) contractTokenBalance = swapThreshold;
532                     if(contractTokenBalance > swapThreshold * 20) contractTokenBalance = swapThreshold * 20;
533                     swapAndLiquify(contractTokenBalance);
534                 }
535             }
536 
537             balances[sender] = balances[sender] - amount;
538 
539             uint256 finalAmount = isTaxFree
540                 ? amount
541                 : takeFee(sender, recipient, amount);
542 
543             if (checkWalletLimit && !isWalletLimitExempt[recipient])
544                 require((balanceOf(recipient) + finalAmount) <= walletMax);
545 
546             balances[recipient] = balances[recipient] + finalAmount;
547 
548             emit Transfer(sender, recipient, finalAmount);
549             return true;
550         }
551     }
552 
553     function checkIfBot(address sender, address recipient) private {
554         if ((block.number - launchBlock) > snipeBlockAmount) {
555             snipeBlockExpired = true;
556         } else if (sender != owner() && recipient != owner()) {
557             if (!isMarketPair[sender] && sender != address(this)) {
558                 isEarlyBuyer[sender] = true;
559             }
560             if (!isMarketPair[recipient] && recipient != address(this)) {
561                 isEarlyBuyer[recipient] = true;
562             }
563         }
564     }
565 
566     function _basicTransfer(
567         address sender,
568         address recipient,
569         uint256 amount
570     ) internal returns (bool) {
571         balances[sender] = balances[sender] - amount;
572         balances[recipient] = balances[recipient] + amount;
573         emit Transfer(sender, recipient, amount);
574         return true;
575     }
576 
577     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
578         uint256 totalShares = lpShare + marketingShare + autoBurnShare;
579         uint256 tokensForBurn = (tAmount * autoBurnShare) / totalShares;
580         uint256 tokensForLP = ((tAmount * lpShare) / totalShares) / 2;
581         uint256 tokensForSwap = tAmount - tokensForLP - tokensForBurn;
582 
583         swapTokensForEth(tokensForSwap);
584 
585         uint256 amountReceived = address(this).balance;
586 
587         uint256 bnbShares = totalShares - autoBurnShare - (lpShare / 2);
588 
589         uint256 bnbForLiquidity = ((amountReceived * lpShare) / bnbShares) / 2;
590         uint256 bnbForMarketing = amountReceived - bnbForLiquidity;
591 
592         if (bnbForMarketing > 0) {
593             transferToAddressETH(marketingWalletAddress, bnbForMarketing);
594         }
595 
596         if (autoBurnShare > 0) {
597             _basicTransfer(address(this), address(0xdead), tokensForBurn);
598         }
599 
600         if (bnbForLiquidity > 0 && tokensForLP > 0) {
601             addLiquidity(tokensForLP, bnbForLiquidity);
602         }
603     }
604 
605     function swapTokensForEth(uint256 tokenAmount) private {
606         // generate the uniswap pair path of token -> weth
607         address[] memory path = new address[](2);
608         path[0] = address(this);
609         path[1] = dexRouter.WETH();
610 
611         _approve(address(this), address(dexRouter), tokenAmount);
612 
613         // make the swap
614         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
615             tokenAmount,
616             0, // accept any amount of ETH
617             path,
618             address(this), // The contract
619             block.timestamp
620         );
621 
622         emit SwapTokensForETH(tokenAmount, path);
623     }
624 
625     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
626         // approve token transfer to cover all possible scenarios
627         _approve(address(this), address(dexRouter), tokenAmount);
628 
629         // add the liquidity
630         dexRouter.addLiquidityETH{value: ethAmount}(
631             address(this),
632             tokenAmount,
633             0, // slippage is unavoidable
634             0, // slippage is unavoidable
635             address(0xdead),
636             block.timestamp
637         );
638     }
639 
640     function takeFee(
641         address sender,
642         address recipient,
643         uint256 amount
644     ) internal returns (uint256) {
645         uint256 feeAmount = (amount * buyTax) / 10000;
646         address feeReceiver = address(this);
647 
648         if (isEarlyBuyer[sender] || isEarlyBuyer[recipient]) {
649             feeAmount = (amount * 9900) / 10000;
650         } 
651         else if (isMarketPair[recipient]) {
652             // Early seller penalty
653             if(launchBlock + sellBlockAmount > block.number){
654                 feeAmount = (amount * 9900) / 10000;
655             } else {
656                 feeAmount = (amount * sellTax) / 10000;
657             }
658         }
659 
660         if (feeAmount > 0) {
661             balances[feeReceiver] = balances[feeReceiver] + feeAmount;
662             emit Transfer(sender, feeReceiver, feeAmount);
663         }
664 
665         return amount - feeAmount;
666     }
667 
668     function launch(uint256 _snipePenaltyBlocks, uint256 _sellPenaltyBlocks) external onlyOwner {
669         require(!launched, "Trading is already active, cannot relaunch.");
670 
671         // create pair
672         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this),dexRouter.WETH());
673         isMarketPair[address(lpPair)] = true;
674         isWalletLimitExempt[address(lpPair)] = true;
675 
676         // add the liquidity
677 
678         require(address(this).balance > 0, "Must have ETH on contract to launch");
679 
680         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
681 
682         _approve(address(this), address(dexRouter), balanceOf(address(this)));
683         dexRouter.addLiquidityETH{value: address(this).balance}(
684             address(this),
685             balanceOf(address(this)),
686             0, // slippage is unavoidable
687             0, // slippage is unavoidable
688             address(initialLpReceiver),
689             block.timestamp
690         );
691 
692         launched = true;
693         launchBlock = block.number;
694         snipeBlockAmount = _snipePenaltyBlocks;
695         sellBlockAmount = _sellPenaltyBlocks;
696     }
697 
698     // withdraw ETH if stuck or someone sends to the address
699     function withdrawStuckETH() external onlyOwner {
700         bool success;
701         (success,) = address(msg.sender).call{value: address(this).balance}("");
702     }
703 
704     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
705         require(_token != address(0), "_token address cannot be 0");
706         require(_token != address(this) || !launched, "Can't withdraw native tokens while trading is active");
707         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
708         _sent = IERC20(_token).transfer(_to, _contractBalance);
709     }
710 }