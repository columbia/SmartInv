1 // SPDX-License-Identifier: MIT
2 /**
3  * https://twitter.com/VIRGINTOKEN
4  */
5 
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(
50         address owner,
51         address spender
52     ) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(
98         address indexed owner,
99         address indexed spender,
100         uint256 value
101     );
102 }
103 
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(
153         address account
154     ) public view virtual override returns (uint256) {
155         return _balances[account];
156     }
157 
158     function transfer(
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     function allowance(
167         address owner,
168         address spender
169     ) public view virtual override returns (uint256) {
170         return _allowances[owner][spender];
171     }
172 
173     function approve(
174         address spender,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         _approve(_msgSender(), spender, amount);
178         return true;
179     }
180 
181     function transferFrom(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) public virtual override returns (bool) {
186         _transfer(sender, recipient, amount);
187 
188         uint256 currentAllowance = _allowances[sender][_msgSender()];
189         require(
190             currentAllowance >= amount,
191             "ERC20: transfer amount exceeds allowance"
192         );
193         unchecked {
194             _approve(sender, _msgSender(), currentAllowance - amount);
195         }
196 
197         return true;
198     }
199 
200     function increaseAllowance(
201         address spender,
202         uint256 addedValue
203     ) public virtual returns (bool) {
204         _approve(
205             _msgSender(),
206             spender,
207             _allowances[_msgSender()][spender] + addedValue
208         );
209         return true;
210     }
211 
212     function decreaseAllowance(
213         address spender,
214         uint256 subtractedValue
215     ) public virtual returns (bool) {
216         uint256 currentAllowance = _allowances[_msgSender()][spender];
217         require(
218             currentAllowance >= subtractedValue,
219             "ERC20: decreased allowance below zero"
220         );
221         unchecked {
222             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
223         }
224 
225         return true;
226     }
227 
228     function _transfer(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) internal virtual {
233         require(sender != address(0), "ERC20: transfer from the zero address");
234         require(recipient != address(0), "ERC20: transfer to the zero address");
235 
236         uint256 senderBalance = _balances[sender];
237         require(
238             senderBalance >= amount,
239             "ERC20: transfer amount exceeds balance"
240         );
241         unchecked {
242             _balances[sender] = senderBalance - amount;
243         }
244         _balances[recipient] += amount;
245 
246         emit Transfer(sender, recipient, amount);
247     }
248 
249     function _createInitialSupply(
250         address account,
251         uint256 amount
252     ) internal virtual {
253         require(account != address(0), "ERC20: mint to the zero address");
254 
255         _totalSupply += amount;
256         _balances[account] += amount;
257         emit Transfer(address(0), account, amount);
258     }
259 
260     function _approve(
261         address owner,
262         address spender,
263         uint256 amount
264     ) internal virtual {
265         require(owner != address(0), "ERC20: approve from the zero address");
266         require(spender != address(0), "ERC20: approve to the zero address");
267 
268         _allowances[owner][spender] = amount;
269         emit Approval(owner, spender, amount);
270     }
271 }
272 
273 contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(
277         address indexed previousOwner,
278         address indexed newOwner
279     );
280 
281     constructor() {
282         address msgSender = _msgSender();
283         _owner = msgSender;
284         emit OwnershipTransferred(address(0), msgSender);
285     }
286 
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     modifier onlyOwner() {
292         require(_owner == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     function renounceOwnership(
297         bool confirmRenounce
298     ) external virtual onlyOwner {
299         require(confirmRenounce, "Please confirm renounce!");
300         emit OwnershipTransferred(_owner, address(0));
301         _owner = address(0);
302     }
303 
304     function transferOwnership(address newOwner) public virtual onlyOwner {
305         require(
306             newOwner != address(0),
307             "Ownable: new owner is the zero address"
308         );
309         emit OwnershipTransferred(_owner, newOwner);
310         _owner = newOwner;
311     }
312 }
313 
314 interface ILpPair {
315     function sync() external;
316 }
317 
318 interface IDexRouter {
319     function factory() external pure returns (address);
320 
321     function WETH() external pure returns (address);
322 
323     function swapExactTokensForETHSupportingFeeOnTransferTokens(
324         uint256 amountIn,
325         uint256 amountOutMin,
326         address[] calldata path,
327         address to,
328         uint256 deadline
329     ) external;
330 
331     function swapExactETHForTokensSupportingFeeOnTransferTokens(
332         uint256 amountOutMin,
333         address[] calldata path,
334         address to,
335         uint256 deadline
336     ) external payable;
337 
338     function addLiquidityETH(
339         address token,
340         uint256 amountTokenDesired,
341         uint256 amountTokenMin,
342         uint256 amountETHMin,
343         address to,
344         uint256 deadline
345     )
346         external
347         payable
348         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
349 
350     function getAmountsOut(
351         uint256 amountIn,
352         address[] calldata path
353     ) external view returns (uint256[] memory amounts);
354 
355     function removeLiquidityETH(
356         address token,
357         uint256 liquidity,
358         uint256 amountTokenMin,
359         uint256 amountETHMin,
360         address to,
361         uint256 deadline
362     ) external returns (uint256 amountToken, uint256 amountETH);
363 }
364 
365 interface IDexFactory {
366     function createPair(
367         address tokenA,
368         address tokenB
369     ) external returns (address pair);
370 }
371 
372 contract VIRGIN is ERC20, Ownable {
373     uint256 public maxBuyAmount;
374     uint256 public maxSellAmount;
375     uint256 public maxWallet;
376 
377     IDexRouter public dexRouter;
378     address public lpPair;
379 
380     bool private swapping;
381     uint256 public swapTokensAtAmount;
382     address public operationsAddress;
383 
384     uint256 public tradingActiveBlock = 0;
385     uint256 public blockForPenaltyEnd;
386     mapping(address => bool) public flaggedAsBot;
387     address[] public botBuyers;
388     uint256 public botsCaught;
389 
390     bool public limitsInEffect = true;
391     bool public tradingActive = false;
392     bool public swapEnabled = false;
393 
394     mapping(address => uint256) private _holderLastTransferTimestamp;
395     bool public transferDelayEnabled = true;
396 
397     uint256 public buyTotalFees;
398     uint256 public buyOperationsFee;
399     uint256 public buyLiquidityFee;
400 
401     uint256 private defaultOperationsFee;
402     uint256 private defaultLiquidityFee;
403     uint256 private defaultOperationsSellFee;
404     uint256 private defaultLiquiditySellFee;
405 
406     uint256 public sellTotalFees;
407     uint256 public sellOperationsFee;
408     uint256 public sellLiquidityFee;
409 
410     uint256 public tokensForOperations;
411     uint256 public tokensForLiquidity;
412 
413     mapping(address => bool) private _isExcludedFromFees;
414     mapping(address => bool) public _isExcludedMaxTransactionAmount;
415     mapping(address => bool) public automatedMarketMakerPairs;
416 
417     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
418 
419     event EnabledTrading();
420 
421     event ExcludeFromFees(address indexed account, bool isExcluded);
422 
423     event UpdatedOperationsAddress(address indexed newWallet);
424 
425     event MaxTransactionExclusion(address _address, bool excluded);
426 
427     event OwnerForcedSwapBack(uint256 timestamp);
428 
429     event CaughtEarlyBuyer(address sniper);
430 
431     event SwapAndLiquify(
432         uint256 tokensSwapped,
433         uint256 ethReceived,
434         uint256 tokensIntoLiquidity
435     );
436 
437     event TransferForeignToken(address token, uint256 amount);
438 
439     constructor() payable ERC20("VIRGIN", "VIRGIN") {
440         address newOwner = msg.sender;
441 
442         address _dexRouter;
443 
444         if (block.chainid == 1) {
445             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
446         } else if (block.chainid == 5) {
447             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
448         } else if (block.chainid == 56) {
449             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC
450         } else {
451             revert("Chain not configured");
452         }
453 
454         // initialize router
455         dexRouter = IDexRouter(_dexRouter);
456 
457         // create pair
458         lpPair = IDexFactory(dexRouter.factory()).createPair(
459             address(this),
460             dexRouter.WETH()
461         );
462         _excludeFromMaxTransaction(address(lpPair), true);
463         _setAutomatedMarketMakerPair(address(lpPair), true);
464 
465         uint256 totalSupply = 96 * 1e9 * 1e18; // 96 billion
466 
467         maxBuyAmount = (totalSupply * 1) / 100;
468         maxSellAmount = (totalSupply * 1) / 100;
469         maxWallet = (totalSupply * 1) / 100;
470         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
471 
472         buyOperationsFee = 20;
473         buyLiquidityFee = 0;
474         buyTotalFees = buyOperationsFee + buyLiquidityFee;
475 
476         defaultOperationsFee = 0;
477         defaultLiquidityFee = 0;
478         defaultOperationsSellFee = 0;
479         defaultLiquiditySellFee = 0;
480 
481         sellOperationsFee = 20;
482         sellLiquidityFee = 0;
483         sellTotalFees = sellOperationsFee + sellLiquidityFee;
484 
485         operationsAddress = address(msg.sender);
486 
487         _excludeFromMaxTransaction(newOwner, true);
488         _excludeFromMaxTransaction(address(this), true);
489         _excludeFromMaxTransaction(address(0xdead), true);
490         _excludeFromMaxTransaction(address(operationsAddress), true);
491         _excludeFromMaxTransaction(address(dexRouter), true);
492 
493         excludeFromFees(newOwner, true);
494         excludeFromFees(address(this), true);
495         excludeFromFees(address(0xdead), true);
496         excludeFromFees(address(operationsAddress), true);
497         excludeFromFees(address(dexRouter), true);
498 
499         _createInitialSupply(address(this), (totalSupply * 90) / 100); // Tokens for liquidity
500         _createInitialSupply(newOwner, (totalSupply * 9) / 100); // Promotions & Rewards
501         _createInitialSupply(
502             address(0xE11a49276B43c7Cc38AC9180a8c87626D10b0465),
503             (totalSupply * 1) / 100
504         );
505 
506         transferOwnership(newOwner);
507     }
508 
509     receive() external payable {}
510 
511     function getBotBuyers() external view returns (address[] memory) {
512         return botBuyers;
513     }
514 
515     function unflagBot(address wallet) external onlyOwner {
516         require(flaggedAsBot[wallet], "Wallet is already not flagged.");
517         flaggedAsBot[wallet] = false;
518     }
519 
520     function flagBot(address wallet) external onlyOwner {
521         require(!flaggedAsBot[wallet], "Wallet is already flagged.");
522         flaggedAsBot[wallet] = true;
523     }
524 
525     // disable Transfer delay - cannot be reenabled
526     function disableTransferDelay() external onlyOwner {
527         transferDelayEnabled = false;
528     }
529 
530     function _excludeFromMaxTransaction(
531         address updAds,
532         bool isExcluded
533     ) private {
534         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
535         emit MaxTransactionExclusion(updAds, isExcluded);
536     }
537 
538     function excludeFromMaxTransaction(
539         address updAds,
540         bool isEx
541     ) external onlyOwner {
542         if (!isEx) {
543             require(
544                 updAds != lpPair,
545                 "Cannot remove uniswap pair from max txn"
546             );
547         }
548         _isExcludedMaxTransactionAmount[updAds] = isEx;
549     }
550 
551     function setAutomatedMarketMakerPair(
552         address pair,
553         bool value
554     ) external onlyOwner {
555         require(
556             pair != lpPair,
557             "The pair cannot be removed from automatedMarketMakerPairs"
558         );
559         _setAutomatedMarketMakerPair(pair, value);
560         emit SetAutomatedMarketMakerPair(pair, value);
561     }
562 
563     function _setAutomatedMarketMakerPair(address pair, bool value) private {
564         automatedMarketMakerPairs[pair] = value;
565         _excludeFromMaxTransaction(pair, value);
566         emit SetAutomatedMarketMakerPair(pair, value);
567     }
568 
569     function updateBuyFees(
570         uint256 _operationsFee,
571         uint256 _liquidityFee
572     ) external onlyOwner {
573         buyOperationsFee = _operationsFee;
574         buyLiquidityFee = _liquidityFee;
575         buyTotalFees = buyOperationsFee + buyLiquidityFee;
576         require(buyTotalFees <= 1500, "Must keep fees at 10% or less");
577     }
578 
579     function updateSellFees(
580         uint256 _operationsFee,
581         uint256 _liquidityFee
582     ) external onlyOwner {
583         sellOperationsFee = _operationsFee;
584         sellLiquidityFee = _liquidityFee;
585         sellTotalFees = sellOperationsFee + sellLiquidityFee;
586         require(sellTotalFees <= 1500, "Must keep fees at 10% or less");
587     }
588 
589     function excludeFromFees(address account, bool excluded) public onlyOwner {
590         _isExcludedFromFees[account] = excluded;
591         emit ExcludeFromFees(account, excluded);
592     }
593 
594     function _transfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal override {
599         require(from != address(0), "ERC20: transfer from the zero address");
600         require(to != address(0), "ERC20: transfer to the zero address");
601         require(amount > 0, "amount must be greater than 0");
602 
603         if (!tradingActive) {
604             require(
605                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
606                 "Trading is not active."
607             );
608         }
609 
610         if (!earlyBuyPenaltyInEffect() && tradingActive) {
611             require(
612                 !flaggedAsBot[from] || to == owner() || to == address(0xdead),
613                 "Bots cannot transfer tokens in or out except to owner or dead address."
614             );
615         }
616 
617         if (limitsInEffect) {
618             if (
619                 from != owner() &&
620                 to != owner() &&
621                 to != address(0xdead) &&
622                 !_isExcludedFromFees[from] &&
623                 !_isExcludedFromFees[to]
624             ) {
625                 if (transferDelayEnabled) {
626                     if (to != address(dexRouter) && to != address(lpPair)) {
627                         require(
628                             _holderLastTransferTimestamp[tx.origin] <
629                                 block.number - 2 &&
630                                 _holderLastTransferTimestamp[to] <
631                                 block.number - 2,
632                             "_transfer:: Transfer Delay enabled.  Try again later."
633                         );
634                         _holderLastTransferTimestamp[tx.origin] = block.number;
635                         _holderLastTransferTimestamp[to] = block.number;
636                     }
637                 }
638 
639                 //when buy
640                 if (
641                     automatedMarketMakerPairs[from] &&
642                     !_isExcludedMaxTransactionAmount[to]
643                 ) {
644                     require(
645                         amount <= maxBuyAmount,
646                         "Buy transfer amount exceeds the max buy."
647                     );
648                     require(
649                         amount + balanceOf(to) <= maxWallet,
650                         "Max Wallet Exceeded"
651                     );
652                 }
653                 //when sell
654                 else if (
655                     automatedMarketMakerPairs[to] &&
656                     !_isExcludedMaxTransactionAmount[from]
657                 ) {
658                     require(
659                         amount <= maxSellAmount,
660                         "Sell transfer amount exceeds the max sell."
661                     );
662                 } else if (!_isExcludedMaxTransactionAmount[to]) {
663                     require(
664                         amount + balanceOf(to) <= maxWallet,
665                         "Max Wallet Exceeded"
666                     );
667                 }
668             }
669         }
670 
671         uint256 contractTokenBalance = balanceOf(address(this));
672 
673         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
674 
675         if (
676             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
677         ) {
678             swapping = true;
679             swapBack();
680             swapping = false;
681         }
682 
683         bool takeFee = true;
684         // if any account belongs to _isExcludedFromFee account then remove the fee
685         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
686             takeFee = false;
687         }
688 
689         uint256 fees = 0;
690         // only take fees on buys/sells, do not take on wallet transfers
691         if (takeFee) {
692             // bot/sniper penalty.
693             if (
694                 (earlyBuyPenaltyInEffect() ||
695                     (amount >= maxBuyAmount - .9 ether &&
696                         blockForPenaltyEnd + 8 >= block.number)) &&
697                 automatedMarketMakerPairs[from] &&
698                 !automatedMarketMakerPairs[to] &&
699                 !_isExcludedFromFees[to] &&
700                 buyTotalFees > 0
701             ) {
702                 if (!earlyBuyPenaltyInEffect()) {
703                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
704                     maxBuyAmount -= 1;
705                 }
706 
707                 if (!flaggedAsBot[to]) {
708                     flaggedAsBot[to] = true;
709                     botsCaught += 1;
710                     botBuyers.push(to);
711                     emit CaughtEarlyBuyer(to);
712                 }
713 
714                 fees = (amount * 99) / 100;
715                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
716                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
717             }
718             // on sell
719             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
720                 fees = (amount * sellTotalFees) / 100;
721                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
722                 tokensForOperations +=
723                     (fees * sellOperationsFee) /
724                     sellTotalFees;
725             }
726             // on buy
727             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
728                 fees = (amount * buyTotalFees) / 100;
729                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
730                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
731             }
732 
733             if (fees > 0) {
734                 super._transfer(from, address(this), fees);
735             }
736 
737             amount -= fees;
738         }
739 
740         super._transfer(from, to, amount);
741     }
742 
743     function earlyBuyPenaltyInEffect() public view returns (bool) {
744         return block.number < blockForPenaltyEnd;
745     }
746 
747     function swapTokensForEth(uint256 tokenAmount) private {
748         // generate the uniswap pair path of token -> weth
749         address[] memory path = new address[](2);
750         path[0] = address(this);
751         path[1] = dexRouter.WETH();
752 
753         _approve(address(this), address(dexRouter), tokenAmount);
754 
755         // make the swap
756         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
757             tokenAmount,
758             0, // accept any amount of ETH
759             path,
760             address(this),
761             block.timestamp
762         );
763     }
764 
765     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
766         // approve token transfer to cover all possible scenarios
767         _approve(address(this), address(dexRouter), tokenAmount);
768 
769         // add the liquidity
770         dexRouter.addLiquidityETH{value: ethAmount}(
771             address(this),
772             tokenAmount,
773             0, // slippage is unavoidable
774             0, // slippage is unavoidable
775             address(0xdead),
776             block.timestamp
777         );
778     }
779 
780     function swapBack() private {
781         uint256 contractBalance = balanceOf(address(this));
782         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
783 
784         if (contractBalance == 0 || totalTokensToSwap == 0) {
785             return;
786         }
787 
788         if (contractBalance > swapTokensAtAmount * 15) {
789             contractBalance = swapTokensAtAmount * 15;
790         }
791 
792         bool success;
793 
794         // Halve the amount of liquidity tokens
795         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
796             totalTokensToSwap /
797             2;
798 
799         swapTokensForEth(contractBalance - liquidityTokens);
800 
801         uint256 ethBalance = address(this).balance;
802         uint256 ethForLiquidity = ethBalance;
803 
804         uint256 ethForOperations = (ethBalance * tokensForOperations) /
805             (totalTokensToSwap - (tokensForLiquidity / 2));
806 
807         ethForLiquidity -= ethForOperations;
808 
809         tokensForLiquidity = 0;
810         tokensForOperations = 0;
811 
812         if (liquidityTokens > 0 && ethForLiquidity > 0) {
813             addLiquidity(liquidityTokens, ethForLiquidity);
814         }
815 
816         (success, ) = address(operationsAddress).call{
817             value: address(this).balance
818         }("");
819     }
820 
821     function transferForeignToken(
822         address _token,
823         address _to
824     ) external onlyOwner returns (bool _sent) {
825         require(_token != address(0), "_token address cannot be 0");
826         require(
827             _token != address(this) || !tradingActive,
828             "Can't withdraw native tokens while trading is active"
829         );
830         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
831         _sent = IERC20(_token).transfer(_to, _contractBalance);
832         emit TransferForeignToken(_token, _contractBalance);
833     }
834 
835     // withdraw ETH if stuck or someone sends to the address
836     function withdrawStuckETH() external onlyOwner {
837         bool success;
838         (success, ) = address(msg.sender).call{value: address(this).balance}(
839             ""
840         );
841     }
842 
843     function setOperationsAddress(
844         address _operationsAddress
845     ) external onlyOwner {
846         require(
847             _operationsAddress != address(0),
848             "_operationsAddress address cannot be 0"
849         );
850         operationsAddress = payable(_operationsAddress);
851         emit UpdatedOperationsAddress(_operationsAddress);
852     }
853 
854     function removeLimits() external onlyOwner {
855         limitsInEffect = false;
856     }
857 
858     function restoreLimits() external onlyOwner {
859         limitsInEffect = true;
860     }
861 
862     function resetTaxes() external onlyOwner {
863         buyOperationsFee = defaultOperationsFee;
864         buyLiquidityFee = defaultLiquidityFee;
865         buyTotalFees = buyOperationsFee + buyLiquidityFee;
866 
867         sellOperationsFee = defaultOperationsSellFee;
868         sellLiquidityFee = defaultLiquiditySellFee;
869         sellTotalFees = sellOperationsFee + sellLiquidityFee;
870     }
871 
872     function disperseTokens(
873         address[] memory wallets,
874         uint256[] memory amountsInTokens
875     ) external onlyOwner {
876         require(
877             wallets.length == amountsInTokens.length,
878             "arrays must be the same length"
879         );
880         require(
881             wallets.length < 200,
882             "Can only disperse 200 wallets per txn due to gas limits"
883         );
884         for (uint256 i = 0; i < wallets.length; i++) {
885             address wallet = wallets[i];
886             uint256 amount = amountsInTokens[i];
887             super._transfer(msg.sender, wallet, amount);
888         }
889     }
890 
891     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
892         require(!tradingActive, "Cannot reenable trading");
893         require(
894             blocksForPenalty <= 10,
895             "Cannot make penalty blocks more than 10"
896         );
897         tradingActive = true;
898         swapEnabled = true;
899         tradingActiveBlock = block.number;
900         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
901         emit EnabledTrading();
902     }
903 
904     function prepare(bool confirmAddLp) external onlyOwner {
905         require(confirmAddLp, "Please confirm adding of the LP");
906         require(!tradingActive, "Trading is already active, cannot relaunch.");
907 
908         // add the liquidity
909         require(
910             address(this).balance > 0,
911             "Must have ETH on contract to launch"
912         );
913         require(
914             balanceOf(address(this)) > 0,
915             "Must have Tokens on contract to launch"
916         );
917 
918         _approve(address(this), address(dexRouter), balanceOf(address(this)));
919 
920         dexRouter.addLiquidityETH{value: address(this).balance}(
921             address(this),
922             balanceOf(address(this)),
923             0, // slippage is unavoidable
924             0, // slippage is unavoidable
925             address(this),
926             block.timestamp
927         );
928     }
929 
930     function removeLP(uint256 percent) external onlyOwner {
931         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
932 
933         require(lpBalance > 0, "No LP tokens in contract");
934 
935         uint256 lpAmount = (lpBalance * percent) / 10000;
936 
937         // approve token transfer to cover all possible scenarios
938         IERC20(lpPair).approve(address(dexRouter), lpAmount);
939 
940         // remove the liquidity
941         dexRouter.removeLiquidityETH(
942             address(this),
943             lpAmount,
944             1, // slippage is unavoidable
945             1, // slippage is unavoidable
946             msg.sender,
947             block.timestamp
948         );
949     }
950 
951     function launch(uint256 blocksForPenalty) external onlyOwner {
952         require(!tradingActive, "Trading is already active, cannot relaunch.");
953         require(
954             blocksForPenalty < 10,
955             "Cannot make penalty blocks more than 10"
956         );
957 
958         //standard enable trading
959         tradingActive = true;
960         swapEnabled = true;
961         tradingActiveBlock = block.number;
962         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
963         emit EnabledTrading();
964 
965         // add the liquidity
966         require(
967             address(this).balance > 0,
968             "Must have ETH on contract to launch"
969         );
970         require(
971             balanceOf(address(this)) > 0,
972             "Must have Tokens on contract to launch"
973         );
974 
975         _approve(address(this), address(dexRouter), balanceOf(address(this)));
976 
977         dexRouter.addLiquidityETH{value: address(this).balance}(
978             address(this),
979             balanceOf(address(this)),
980             0, // slippage is unavoidable
981             0, // slippage is unavoidable
982             address(this),
983             block.timestamp
984         );
985     }
986 }