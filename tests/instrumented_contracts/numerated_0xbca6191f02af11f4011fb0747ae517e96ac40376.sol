1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(
34         address recipient,
35         uint256 amount
36     ) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(
46         address owner,
47         address spender
48     ) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(
94         address indexed owner,
95         address indexed spender,
96         uint256 value
97     );
98 }
99 
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 contract ERC20 is Context, IERC20, IERC20Metadata {
118     mapping(address => uint256) private _balances;
119 
120     mapping(address => mapping(address => uint256)) private _allowances;
121 
122     uint256 private _totalSupply;
123 
124     string private _name;
125     string private _symbol;
126 
127     constructor(string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130     }
131 
132     function name() public view virtual override returns (string memory) {
133         return _name;
134     }
135 
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     function decimals() public view virtual override returns (uint8) {
141         return 18;
142     }
143 
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147 
148     function balanceOf(
149         address account
150     ) public view virtual override returns (uint256) {
151         return _balances[account];
152     }
153 
154     function transfer(
155         address recipient,
156         uint256 amount
157     ) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(
163         address owner,
164         address spender
165     ) public view virtual override returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function approve(
170         address spender,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _approve(_msgSender(), spender, amount);
174         return true;
175     }
176 
177     function transferFrom(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) public virtual override returns (bool) {
182         _transfer(sender, recipient, amount);
183 
184         uint256 currentAllowance = _allowances[sender][_msgSender()];
185         require(
186             currentAllowance >= amount,
187             "ERC20: transfer amount exceeds allowance"
188         );
189         unchecked {
190             _approve(sender, _msgSender(), currentAllowance - amount);
191         }
192 
193         return true;
194     }
195 
196     function increaseAllowance(
197         address spender,
198         uint256 addedValue
199     ) public virtual returns (bool) {
200         _approve(
201             _msgSender(),
202             spender,
203             _allowances[_msgSender()][spender] + addedValue
204         );
205         return true;
206     }
207 
208     function decreaseAllowance(
209         address spender,
210         uint256 subtractedValue
211     ) public virtual returns (bool) {
212         uint256 currentAllowance = _allowances[_msgSender()][spender];
213         require(
214             currentAllowance >= subtractedValue,
215             "ERC20: decreased allowance below zero"
216         );
217         unchecked {
218             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
219         }
220 
221         return true;
222     }
223 
224     function _transfer(
225         address sender,
226         address recipient,
227         uint256 amount
228     ) internal virtual {
229         require(sender != address(0), "ERC20: transfer from the zero address");
230         require(recipient != address(0), "ERC20: transfer to the zero address");
231 
232         uint256 senderBalance = _balances[sender];
233         require(
234             senderBalance >= amount,
235             "ERC20: transfer amount exceeds balance"
236         );
237         unchecked {
238             _balances[sender] = senderBalance - amount;
239         }
240         _balances[recipient] += amount;
241 
242         emit Transfer(sender, recipient, amount);
243     }
244 
245     function _createInitialSupply(
246         address account,
247         uint256 amount
248     ) internal virtual {
249         require(account != address(0), "ERC20: mint to the zero address");
250 
251         _totalSupply += amount;
252         _balances[account] += amount;
253         emit Transfer(address(0), account, amount);
254     }
255 
256     function _approve(
257         address owner,
258         address spender,
259         uint256 amount
260     ) internal virtual {
261         require(owner != address(0), "ERC20: approve from the zero address");
262         require(spender != address(0), "ERC20: approve to the zero address");
263 
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 }
268 
269 contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(
273         address indexed previousOwner,
274         address indexed newOwner
275     );
276 
277     constructor() {
278         address msgSender = _msgSender();
279         _owner = msgSender;
280         emit OwnershipTransferred(address(0), msgSender);
281     }
282 
283     function owner() public view returns (address) {
284         return _owner;
285     }
286 
287     modifier onlyOwner() {
288         require(_owner == _msgSender(), "Ownable: caller is not the owner");
289         _;
290     }
291 
292     function renounceOwnership(
293         bool confirmRenounce
294     ) external virtual onlyOwner {
295         require(confirmRenounce, "Please confirm renounce!");
296         emit OwnershipTransferred(_owner, address(0));
297         _owner = address(0);
298     }
299 
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(
302             newOwner != address(0),
303             "Ownable: new owner is the zero address"
304         );
305         emit OwnershipTransferred(_owner, newOwner);
306         _owner = newOwner;
307     }
308 }
309 
310 interface ILpPair {
311     function sync() external;
312 }
313 
314 interface IDexRouter {
315     function factory() external pure returns (address);
316 
317     function WETH() external pure returns (address);
318 
319     function swapExactTokensForETHSupportingFeeOnTransferTokens(
320         uint256 amountIn,
321         uint256 amountOutMin,
322         address[] calldata path,
323         address to,
324         uint256 deadline
325     ) external;
326 
327     function swapExactETHForTokensSupportingFeeOnTransferTokens(
328         uint256 amountOutMin,
329         address[] calldata path,
330         address to,
331         uint256 deadline
332     ) external payable;
333 
334     function addLiquidityETH(
335         address token,
336         uint256 amountTokenDesired,
337         uint256 amountTokenMin,
338         uint256 amountETHMin,
339         address to,
340         uint256 deadline
341     )
342         external
343         payable
344         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
345 
346     function getAmountsOut(
347         uint256 amountIn,
348         address[] calldata path
349     ) external view returns (uint256[] memory amounts);
350 
351     function removeLiquidityETH(
352         address token,
353         uint256 liquidity,
354         uint256 amountTokenMin,
355         uint256 amountETHMin,
356         address to,
357         uint256 deadline
358     ) external returns (uint256 amountToken, uint256 amountETH);
359 }
360 
361 interface IDexFactory {
362     function createPair(
363         address tokenA,
364         address tokenB
365     ) external returns (address pair);
366 }
367 
368 contract KAT is ERC20, Ownable {
369     uint256 public maxBuyAmount;
370     uint256 public maxSellAmount;
371     uint256 public maxWallet;
372 
373     IDexRouter public dexRouter;
374     address public lpPair;
375 
376     bool private swapping;
377     uint256 public swapTokensAtAmount;
378     address public operationsAddress;
379 
380     uint256 public tradingActiveBlock = 0;
381     uint256 public blockForPenaltyEnd;
382     mapping(address => bool) public flaggedAsBot;
383     address[] public botBuyers;
384     uint256 public botsCaught;
385 
386     bool public limitsInEffect = true;
387     bool public tradingActive = false;
388     bool public swapEnabled = false;
389 
390     mapping(address => uint256) private _holderLastTransferTimestamp;
391     bool public transferDelayEnabled = true;
392 
393     uint256 public buyTotalFees;
394     uint256 public buyOperationsFee;
395     uint256 public buyLiquidityFee;
396 
397     uint256 private defaultOperationsFee;
398     uint256 private defaultLiquidityFee;
399     uint256 private defaultOperationsSellFee;
400     uint256 private defaultLiquiditySellFee;
401 
402     uint256 public sellTotalFees;
403     uint256 public sellOperationsFee;
404     uint256 public sellLiquidityFee;
405 
406     uint256 public tokensForOperations;
407     uint256 public tokensForLiquidity;
408 
409     mapping(address => bool) private _isExcludedFromFees;
410     mapping(address => bool) public _isExcludedMaxTransactionAmount;
411     mapping(address => bool) public automatedMarketMakerPairs;
412 
413     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
414 
415     event EnabledTrading();
416 
417     event ExcludeFromFees(address indexed account, bool isExcluded);
418 
419     event UpdatedOperationsAddress(address indexed newWallet);
420 
421     event MaxTransactionExclusion(address _address, bool excluded);
422 
423     event OwnerForcedSwapBack(uint256 timestamp);
424 
425     event CaughtEarlyBuyer(address sniper);
426 
427     event SwapAndLiquify(
428         uint256 tokensSwapped,
429         uint256 ethReceived,
430         uint256 tokensIntoLiquidity
431     );
432 
433     event TransferForeignToken(address token, uint256 amount);
434 
435     constructor() payable ERC20("Katcoin", "KAT") {
436         address newOwner = msg.sender;
437 
438         address _dexRouter;
439 
440         if (block.chainid == 1) {
441             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
442         } else if (block.chainid == 5) {
443             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
444         } else if (block.chainid == 56) {
445             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC
446         } else {
447             revert("Chain not configured");
448         }
449 
450         // initialize router
451         dexRouter = IDexRouter(_dexRouter);
452 
453         // create pair
454         lpPair = IDexFactory(dexRouter.factory()).createPair(
455             address(this),
456             dexRouter.WETH()
457         );
458         _excludeFromMaxTransaction(address(lpPair), true);
459         _setAutomatedMarketMakerPair(address(lpPair), true);
460 
461         uint256 totalSupply = 20 * 1e12 * 1e18;
462 
463         maxBuyAmount = (totalSupply * 15) / 1000; // 1.5%
464         maxSellAmount = (totalSupply * 15) / 1000; // 1.5%
465         maxWallet = (totalSupply * 3) / 100; // 3%
466         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
467 
468         buyOperationsFee = 15;
469         buyLiquidityFee = 0;
470         buyTotalFees = buyOperationsFee + buyLiquidityFee;
471 
472         defaultOperationsFee = 4;
473         defaultLiquidityFee = 1;
474         defaultOperationsSellFee = 4;
475         defaultLiquiditySellFee = 1;
476 
477         sellOperationsFee = 20;
478         sellLiquidityFee = 0;
479         sellTotalFees = sellOperationsFee + sellLiquidityFee;
480 
481         operationsAddress = address(msg.sender);
482 
483         _excludeFromMaxTransaction(newOwner, true);
484         _excludeFromMaxTransaction(address(this), true);
485         _excludeFromMaxTransaction(address(0xdead), true);
486         _excludeFromMaxTransaction(address(operationsAddress), true);
487         _excludeFromMaxTransaction(address(dexRouter), true);
488 
489         excludeFromFees(newOwner, true);
490         excludeFromFees(address(this), true);
491         excludeFromFees(address(0xdead), true);
492         excludeFromFees(address(operationsAddress), true);
493         excludeFromFees(address(dexRouter), true);
494 
495         _createInitialSupply(newOwner, totalSupply);
496 
497         transferOwnership(newOwner);
498     }
499 
500     receive() external payable {}
501 
502     // only use if conducting a presale
503     function addPresaleAddressForExclusions(
504         address _presaleAddress
505     ) external onlyOwner {
506         excludeFromFees(_presaleAddress, true);
507         _excludeFromMaxTransaction(_presaleAddress, true);
508     }
509 
510     function getBotBuyers() external view returns (address[] memory) {
511         return botBuyers;
512     }
513 
514     function unflagBot(address wallet) external onlyOwner {
515         require(flaggedAsBot[wallet], "Wallet is already not flagged.");
516         flaggedAsBot[wallet] = false;
517     }
518 
519     // disable Transfer delay - cannot be reenabled
520     function disableTransferDelay() external onlyOwner {
521         transferDelayEnabled = false;
522     }
523 
524     function _excludeFromMaxTransaction(
525         address updAds,
526         bool isExcluded
527     ) private {
528         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
529         emit MaxTransactionExclusion(updAds, isExcluded);
530     }
531 
532     function excludeFromMaxTransaction(
533         address updAds,
534         bool isEx
535     ) external onlyOwner {
536         if (!isEx) {
537             require(
538                 updAds != lpPair,
539                 "Cannot remove uniswap pair from max txn"
540             );
541         }
542         _isExcludedMaxTransactionAmount[updAds] = isEx;
543     }
544 
545     function setAutomatedMarketMakerPair(
546         address pair,
547         bool value
548     ) external onlyOwner {
549         require(
550             pair != lpPair,
551             "The pair cannot be removed from automatedMarketMakerPairs"
552         );
553         _setAutomatedMarketMakerPair(pair, value);
554         emit SetAutomatedMarketMakerPair(pair, value);
555     }
556 
557     function _setAutomatedMarketMakerPair(address pair, bool value) private {
558         automatedMarketMakerPairs[pair] = value;
559         _excludeFromMaxTransaction(pair, value);
560         emit SetAutomatedMarketMakerPair(pair, value);
561     }
562 
563     function updateBuyFees(
564         uint256 _operationsFee,
565         uint256 _liquidityFee
566     ) external onlyOwner {
567         buyOperationsFee = _operationsFee;
568         buyLiquidityFee = _liquidityFee;
569         buyTotalFees = buyOperationsFee + buyLiquidityFee;
570         require(buyTotalFees <= 15, "Must keep fees at 10% or less");
571     }
572 
573     function updateSellFees(
574         uint256 _operationsFee,
575         uint256 _liquidityFee
576     ) external onlyOwner {
577         sellOperationsFee = _operationsFee;
578         sellLiquidityFee = _liquidityFee;
579         sellTotalFees = sellOperationsFee + sellLiquidityFee;
580         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
581     }
582 
583     function excludeFromFees(address account, bool excluded) public onlyOwner {
584         _isExcludedFromFees[account] = excluded;
585         emit ExcludeFromFees(account, excluded);
586     }
587 
588     function _transfer(
589         address from,
590         address to,
591         uint256 amount
592     ) internal override {
593         require(from != address(0), "ERC20: transfer from the zero address");
594         require(to != address(0), "ERC20: transfer to the zero address");
595         require(amount > 0, "amount must be greater than 0");
596 
597         if (!tradingActive) {
598             require(
599                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
600                 "Trading is not active."
601             );
602         }
603 
604         if (!earlyBuyPenaltyInEffect() && tradingActive) {
605             require(
606                 !flaggedAsBot[from] || to == owner() || to == address(0xdead),
607                 "Bots cannot transfer tokens in or out except to owner or dead address."
608             );
609         }
610 
611         if (limitsInEffect) {
612             if (
613                 from != owner() &&
614                 to != owner() &&
615                 to != address(0xdead) &&
616                 !_isExcludedFromFees[from] &&
617                 !_isExcludedFromFees[to]
618             ) {
619                 if (transferDelayEnabled) {
620                     if (to != address(dexRouter) && to != address(lpPair)) {
621                         require(
622                             _holderLastTransferTimestamp[tx.origin] <
623                                 block.number - 2 &&
624                                 _holderLastTransferTimestamp[to] <
625                                 block.number - 2,
626                             "_transfer:: Transfer Delay enabled.  Try again later."
627                         );
628                         _holderLastTransferTimestamp[tx.origin] = block.number;
629                         _holderLastTransferTimestamp[to] = block.number;
630                     }
631                 }
632 
633                 //when buy
634                 if (
635                     automatedMarketMakerPairs[from] &&
636                     !_isExcludedMaxTransactionAmount[to]
637                 ) {
638                     require(
639                         amount <= maxBuyAmount,
640                         "Buy transfer amount exceeds the max buy."
641                     );
642                     require(
643                         amount + balanceOf(to) <= maxWallet,
644                         "Max Wallet Exceeded"
645                     );
646                 }
647                 //when sell
648                 else if (
649                     automatedMarketMakerPairs[to] &&
650                     !_isExcludedMaxTransactionAmount[from]
651                 ) {
652                     require(
653                         amount <= maxSellAmount,
654                         "Sell transfer amount exceeds the max sell."
655                     );
656                 } else if (!_isExcludedMaxTransactionAmount[to]) {
657                     require(
658                         amount + balanceOf(to) <= maxWallet,
659                         "Max Wallet Exceeded"
660                     );
661                 }
662             }
663         }
664 
665         uint256 contractTokenBalance = balanceOf(address(this));
666 
667         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
668 
669         if (
670             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
671         ) {
672             swapping = true;
673             swapBack();
674             swapping = false;
675         }
676 
677         bool takeFee = true;
678         // if any account belongs to _isExcludedFromFee account then remove the fee
679         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
680             takeFee = false;
681         }
682 
683         uint256 fees = 0;
684         // only take fees on buys/sells, do not take on wallet transfers
685         if (takeFee) {
686             // bot/sniper penalty.
687             if (
688                 (earlyBuyPenaltyInEffect() ||
689                     (amount >= maxBuyAmount - .9 ether &&
690                         blockForPenaltyEnd + 8 >= block.number)) &&
691                 automatedMarketMakerPairs[from] &&
692                 !automatedMarketMakerPairs[to] &&
693                 !_isExcludedFromFees[to] &&
694                 buyTotalFees > 0
695             ) {
696                 if (!earlyBuyPenaltyInEffect()) {
697                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
698                     maxBuyAmount -= 1;
699                 }
700 
701                 if (!flaggedAsBot[to]) {
702                     flaggedAsBot[to] = true;
703                     botsCaught += 1;
704                     botBuyers.push(to);
705                     emit CaughtEarlyBuyer(to);
706                 }
707 
708                 fees = (amount * 99) / 100;
709                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
710                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
711             }
712             // on sell
713             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
714                 fees = (amount * sellTotalFees) / 100;
715                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
716                 tokensForOperations +=
717                     (fees * sellOperationsFee) /
718                     sellTotalFees;
719             }
720             // on buy
721             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
722                 fees = (amount * buyTotalFees) / 100;
723                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
724                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
725             }
726 
727             if (fees > 0) {
728                 super._transfer(from, address(this), fees);
729             }
730 
731             amount -= fees;
732         }
733 
734         super._transfer(from, to, amount);
735     }
736 
737     function earlyBuyPenaltyInEffect() public view returns (bool) {
738         return block.number < blockForPenaltyEnd;
739     }
740 
741     function swapTokensForEth(uint256 tokenAmount) private {
742         // generate the uniswap pair path of token -> weth
743         address[] memory path = new address[](2);
744         path[0] = address(this);
745         path[1] = dexRouter.WETH();
746 
747         _approve(address(this), address(dexRouter), tokenAmount);
748 
749         // make the swap
750         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
751             tokenAmount,
752             0, // accept any amount of ETH
753             path,
754             address(this),
755             block.timestamp
756         );
757     }
758 
759     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
760         // approve token transfer to cover all possible scenarios
761         _approve(address(this), address(dexRouter), tokenAmount);
762 
763         // add the liquidity
764         dexRouter.addLiquidityETH{value: ethAmount}(
765             address(this),
766             tokenAmount,
767             0, // slippage is unavoidable
768             0, // slippage is unavoidable
769             address(0xdead),
770             block.timestamp
771         );
772     }
773 
774     function swapBack() private {
775         uint256 contractBalance = balanceOf(address(this));
776         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
777 
778         if (contractBalance == 0 || totalTokensToSwap == 0) {
779             return;
780         }
781 
782         if (contractBalance > swapTokensAtAmount * 15) {
783             contractBalance = swapTokensAtAmount * 15;
784         }
785 
786         bool success;
787 
788         // Halve the amount of liquidity tokens
789         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
790             totalTokensToSwap /
791             2;
792 
793         swapTokensForEth(contractBalance - liquidityTokens);
794 
795         uint256 ethBalance = address(this).balance;
796         uint256 ethForLiquidity = ethBalance;
797 
798         uint256 ethForOperations = (ethBalance * tokensForOperations) /
799             (totalTokensToSwap - (tokensForLiquidity / 2));
800 
801         ethForLiquidity -= ethForOperations;
802 
803         tokensForLiquidity = 0;
804         tokensForOperations = 0;
805 
806         if (liquidityTokens > 0 && ethForLiquidity > 0) {
807             addLiquidity(liquidityTokens, ethForLiquidity);
808         }
809 
810         (success, ) = address(operationsAddress).call{
811             value: address(this).balance
812         }("");
813     }
814 
815     function transferForeignToken(
816         address _token,
817         address _to
818     ) external onlyOwner returns (bool _sent) {
819         require(_token != address(0), "_token address cannot be 0");
820         require(
821             _token != address(this) || !tradingActive,
822             "Can't withdraw native tokens while trading is active"
823         );
824         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
825         _sent = IERC20(_token).transfer(_to, _contractBalance);
826         emit TransferForeignToken(_token, _contractBalance);
827     }
828 
829     // withdraw ETH if stuck or someone sends to the address
830     function withdrawStuckETH() external onlyOwner {
831         bool success;
832         (success, ) = address(msg.sender).call{value: address(this).balance}(
833             ""
834         );
835     }
836 
837     function setOperationsAddress(
838         address _operationsAddress
839     ) external onlyOwner {
840         require(
841             _operationsAddress != address(0),
842             "_operationsAddress address cannot be 0"
843         );
844         operationsAddress = payable(_operationsAddress);
845         emit UpdatedOperationsAddress(_operationsAddress);
846     }
847 
848     function removeLimits() external onlyOwner {
849         limitsInEffect = false;
850     }
851 
852     function restoreLimits() external onlyOwner {
853         limitsInEffect = true;
854     }
855 
856     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
857         require(!tradingActive, "Cannot reenable trading");
858         require(
859             blocksForPenalty <= 10,
860             "Cannot make penalty blocks more than 10"
861         );
862         tradingActive = true;
863         swapEnabled = true;
864         tradingActiveBlock = block.number;
865         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
866         emit EnabledTrading();
867     }
868 }