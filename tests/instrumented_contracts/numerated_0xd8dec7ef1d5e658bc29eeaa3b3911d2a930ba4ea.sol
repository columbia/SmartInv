1 // SPDX-License-Identifier: MIT
2 /*
3 
4     https://t.me/ThisWillFuckinSend
5     https://twitter.com/ThisWillFknSend
6     https://sendingcoin.vip/
7     https://medium.com/@ThisWillFuckinSend
8 
9  */
10 pragma solidity 0.8.19;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(
54         address owner,
55         address spender
56     ) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(
102         address indexed owner,
103         address indexed spender,
104         uint256 value
105     );
106 }
107 
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string private _name;
133     string private _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(
157         address account
158     ) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161 
162     function transfer(
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(
171         address owner,
172         address spender
173     ) public view virtual override returns (uint256) {
174         return _allowances[owner][spender];
175     }
176 
177     function approve(
178         address spender,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _approve(_msgSender(), spender, amount);
182         return true;
183     }
184 
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) public virtual override returns (bool) {
190         _transfer(sender, recipient, amount);
191 
192         uint256 currentAllowance = _allowances[sender][_msgSender()];
193         require(
194             currentAllowance >= amount,
195             "ERC20: transfer amount exceeds allowance"
196         );
197         unchecked {
198             _approve(sender, _msgSender(), currentAllowance - amount);
199         }
200 
201         return true;
202     }
203 
204     function increaseAllowance(
205         address spender,
206         uint256 addedValue
207     ) public virtual returns (bool) {
208         _approve(
209             _msgSender(),
210             spender,
211             _allowances[_msgSender()][spender] + addedValue
212         );
213         return true;
214     }
215 
216     function decreaseAllowance(
217         address spender,
218         uint256 subtractedValue
219     ) public virtual returns (bool) {
220         uint256 currentAllowance = _allowances[_msgSender()][spender];
221         require(
222             currentAllowance >= subtractedValue,
223             "ERC20: decreased allowance below zero"
224         );
225         unchecked {
226             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
227         }
228 
229         return true;
230     }
231 
232     function _transfer(
233         address sender,
234         address recipient,
235         uint256 amount
236     ) internal virtual {
237         require(sender != address(0), "ERC20: transfer from the zero address");
238         require(recipient != address(0), "ERC20: transfer to the zero address");
239 
240         uint256 senderBalance = _balances[sender];
241         require(
242             senderBalance >= amount,
243             "ERC20: transfer amount exceeds balance"
244         );
245         unchecked {
246             _balances[sender] = senderBalance - amount;
247         }
248         _balances[recipient] += amount;
249 
250         emit Transfer(sender, recipient, amount);
251     }
252 
253     function _createInitialSupply(
254         address account,
255         uint256 amount
256     ) internal virtual {
257         require(account != address(0), "ERC20: mint to the zero address");
258 
259         _totalSupply += amount;
260         _balances[account] += amount;
261         emit Transfer(address(0), account, amount);
262     }
263 
264     function _approve(
265         address owner,
266         address spender,
267         uint256 amount
268     ) internal virtual {
269         require(owner != address(0), "ERC20: approve from the zero address");
270         require(spender != address(0), "ERC20: approve to the zero address");
271 
272         _allowances[owner][spender] = amount;
273         emit Approval(owner, spender, amount);
274     }
275 }
276 
277 contract Ownable is Context {
278     address private _owner;
279 
280     event OwnershipTransferred(
281         address indexed previousOwner,
282         address indexed newOwner
283     );
284 
285     constructor() {
286         address msgSender = _msgSender();
287         _owner = msgSender;
288         emit OwnershipTransferred(address(0), msgSender);
289     }
290 
291     function owner() public view returns (address) {
292         return _owner;
293     }
294 
295     modifier onlyOwner() {
296         require(_owner == _msgSender(), "Ownable: caller is not the owner");
297         _;
298     }
299 
300     function renounceOwnership(
301         bool confirmRenounce
302     ) external virtual onlyOwner {
303         require(confirmRenounce, "Please confirm renounce!");
304         emit OwnershipTransferred(_owner, address(0));
305         _owner = address(0);
306     }
307 
308     function transferOwnership(address newOwner) public virtual onlyOwner {
309         require(
310             newOwner != address(0),
311             "Ownable: new owner is the zero address"
312         );
313         emit OwnershipTransferred(_owner, newOwner);
314         _owner = newOwner;
315     }
316 }
317 
318 interface ILpPair {
319     function sync() external;
320 }
321 
322 interface IDexRouter {
323     function factory() external pure returns (address);
324 
325     function WETH() external pure returns (address);
326 
327     function swapExactTokensForETHSupportingFeeOnTransferTokens(
328         uint256 amountIn,
329         uint256 amountOutMin,
330         address[] calldata path,
331         address to,
332         uint256 deadline
333     ) external;
334 
335     function swapExactETHForTokensSupportingFeeOnTransferTokens(
336         uint256 amountOutMin,
337         address[] calldata path,
338         address to,
339         uint256 deadline
340     ) external payable;
341 
342     function addLiquidityETH(
343         address token,
344         uint256 amountTokenDesired,
345         uint256 amountTokenMin,
346         uint256 amountETHMin,
347         address to,
348         uint256 deadline
349     )
350         external
351         payable
352         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
353 
354     function getAmountsOut(
355         uint256 amountIn,
356         address[] calldata path
357     ) external view returns (uint256[] memory amounts);
358 
359     function removeLiquidityETH(
360         address token,
361         uint256 liquidity,
362         uint256 amountTokenMin,
363         uint256 amountETHMin,
364         address to,
365         uint256 deadline
366     ) external returns (uint256 amountToken, uint256 amountETH);
367 }
368 
369 interface IDexFactory {
370     function createPair(
371         address tokenA,
372         address tokenB
373     ) external returns (address pair);
374 }
375 
376 contract SENDING is ERC20, Ownable {
377     uint256 public maxBuyAmount;
378     uint256 public maxSellAmount;
379     uint256 public maxWallet;
380 
381     IDexRouter public dexRouter;
382     address public lpPair;
383 
384     bool private swapping;
385     uint256 public swapTokensAtAmount;
386     address public operationsAddress;
387 
388     uint256 public tradingActiveBlock = 0;
389     uint256 public blockForPenaltyEnd;
390     mapping(address => bool) public flaggedAsBot;
391     address[] public botBuyers;
392     uint256 public botsCaught;
393 
394     bool public limitsInEffect = true;
395     bool public tradingActive = false;
396     bool public swapEnabled = false;
397 
398     mapping(address => uint256) private _holderLastTransferTimestamp;
399     bool public transferDelayEnabled = true;
400 
401     uint256 public buyTotalFees;
402     uint256 public buyOperationsFee;
403     uint256 public buyLiquidityFee;
404 
405     uint256 private defaultOperationsFee;
406     uint256 private defaultLiquidityFee;
407     uint256 private defaultOperationsSellFee;
408     uint256 private defaultLiquiditySellFee;
409 
410     uint256 public sellTotalFees;
411     uint256 public sellOperationsFee;
412     uint256 public sellLiquidityFee;
413 
414     uint256 public tokensForOperations;
415     uint256 public tokensForLiquidity;
416 
417     mapping(address => bool) private _isExcludedFromFees;
418     mapping(address => bool) public _isExcludedMaxTransactionAmount;
419     mapping(address => bool) public automatedMarketMakerPairs;
420 
421     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
422 
423     event EnabledTrading();
424 
425     event ExcludeFromFees(address indexed account, bool isExcluded);
426 
427     event UpdatedOperationsAddress(address indexed newWallet);
428 
429     event MaxTransactionExclusion(address _address, bool excluded);
430 
431     event OwnerForcedSwapBack(uint256 timestamp);
432 
433     event CaughtEarlyBuyer(address sniper);
434 
435     event SwapAndLiquify(
436         uint256 tokensSwapped,
437         uint256 ethReceived,
438         uint256 tokensIntoLiquidity
439     );
440 
441     event TransferForeignToken(address token, uint256 amount);
442 
443     constructor() payable ERC20("ThisWillFuckingSend", "SENDING") {
444         address newOwner = msg.sender;  
445 
446         uint256 totalSupply = 69 * 1e9 * 1e18; // 69b
447 
448         maxBuyAmount = (totalSupply * 15) / 1000;
449         maxSellAmount = (totalSupply * 15) / 1000;
450         maxWallet = (totalSupply * 2) / 100;
451         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
452 
453         buyOperationsFee = 25;
454         buyLiquidityFee = 0;
455         buyTotalFees = buyOperationsFee + buyLiquidityFee;
456 
457         defaultOperationsFee = 1;
458         defaultLiquidityFee = 0;
459         defaultOperationsSellFee = 1;
460         defaultLiquiditySellFee = 0;
461 
462         sellOperationsFee = 25;
463         sellLiquidityFee = 0;
464         sellTotalFees = sellOperationsFee + sellLiquidityFee;
465 
466         operationsAddress = address(0xEa71E696C5F47BB1859433353d3893a04eF1F51a);
467 
468         _excludeFromMaxTransaction(newOwner, true);
469         _excludeFromMaxTransaction(address(this), true);
470         _excludeFromMaxTransaction(address(0xdead), true);
471         _excludeFromMaxTransaction(address(operationsAddress), true);
472         // _excludeFromMaxTransaction(address(dexRouter), true);
473 
474         excludeFromFees(newOwner, true);
475         excludeFromFees(address(this), true);
476         excludeFromFees(address(0xdead), true);
477         excludeFromFees(address(operationsAddress), true);
478         // excludeFromFees(address(dexRouter), true);
479 
480         _createInitialSupply(address(this), (totalSupply * 9) / 100);
481         _createInitialSupply(newOwner, (totalSupply * 91) / 100);
482 
483         transferOwnership(newOwner);
484     }
485 
486     receive() external payable {}
487 
488     function getBotBuyers() external view returns (address[] memory) {
489         return botBuyers;
490     }
491 
492     function unflagBot(address wallet) external onlyOwner {
493         require(flaggedAsBot[wallet], "Wallet is already not flagged.");
494         flaggedAsBot[wallet] = false;
495     }
496 
497     function flagBot(address wallet) external onlyOwner {
498         require(!flaggedAsBot[wallet], "Wallet is already flagged.");
499         flaggedAsBot[wallet] = true;
500     }
501 
502     // disable Transfer delay - cannot be reenabled
503     function disableTransferDelay() external onlyOwner {
504         transferDelayEnabled = false;
505     }
506 
507     function _excludeFromMaxTransaction(
508         address updAds,
509         bool isExcluded
510     ) private {
511         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
512         emit MaxTransactionExclusion(updAds, isExcluded);
513     }
514 
515     function excludeFromMaxTransaction(
516         address updAds,
517         bool isEx
518     ) external onlyOwner {
519         if (!isEx) {
520             require(
521                 updAds != lpPair,
522                 "Cannot remove uniswap pair from max txn"
523             );
524         }
525         _isExcludedMaxTransactionAmount[updAds] = isEx;
526     }
527 
528     function setAutomatedMarketMakerPair(
529         address pair,
530         bool value
531     ) external onlyOwner {
532         require(
533             pair != lpPair,
534             "The pair cannot be removed from automatedMarketMakerPairs"
535         );
536         _setAutomatedMarketMakerPair(pair, value);
537         emit SetAutomatedMarketMakerPair(pair, value);
538     }
539 
540     function _setAutomatedMarketMakerPair(address pair, bool value) private {
541         automatedMarketMakerPairs[pair] = value;
542         _excludeFromMaxTransaction(pair, value);
543         emit SetAutomatedMarketMakerPair(pair, value);
544     }
545 
546     function updateBuyFees(
547         uint256 _operationsFee,
548         uint256 _liquidityFee
549     ) external onlyOwner {
550         buyOperationsFee = _operationsFee;
551         buyLiquidityFee = _liquidityFee;
552         buyTotalFees = buyOperationsFee + buyLiquidityFee;
553         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
554     }
555 
556     function updateSellFees(
557         uint256 _operationsFee,
558         uint256 _liquidityFee
559     ) external onlyOwner {
560         sellOperationsFee = _operationsFee;
561         sellLiquidityFee = _liquidityFee;
562         sellTotalFees = sellOperationsFee + sellLiquidityFee;
563         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
564     }
565 
566     function excludeFromFees(address account, bool excluded) public onlyOwner {
567         _isExcludedFromFees[account] = excluded;
568         emit ExcludeFromFees(account, excluded);
569     }
570 
571     function _transfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal override {
576         require(from != address(0), "ERC20: transfer from the zero address");
577         require(to != address(0), "ERC20: transfer to the zero address");
578         require(amount > 0, "amount must be greater than 0");
579 
580         if (!tradingActive) {
581             require(
582                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
583                 "Trading is not active."
584             );
585         }
586 
587         if (!earlyBuyPenaltyInEffect() && tradingActive) {
588             require(
589                 !flaggedAsBot[from] || to == owner() || to == address(0xdead),
590                 "Bots cannot transfer tokens in or out except to owner or dead address."
591             );
592         }
593 
594         if (limitsInEffect) {
595             if (
596                 from != owner() &&
597                 to != owner() &&
598                 to != address(0xdead) &&
599                 !_isExcludedFromFees[from] &&
600                 !_isExcludedFromFees[to]
601             ) {
602                 if (transferDelayEnabled) {
603                     if (to != address(dexRouter) && to != address(lpPair)) {
604                         require(
605                             _holderLastTransferTimestamp[tx.origin] <
606                                 block.number - 2 &&
607                                 _holderLastTransferTimestamp[to] <
608                                 block.number - 2,
609                             "_transfer:: Transfer Delay enabled.  Try again later."
610                         );
611                         _holderLastTransferTimestamp[tx.origin] = block.number;
612                         _holderLastTransferTimestamp[to] = block.number;
613                     }
614                 }
615 
616                 //when buy
617                 if (
618                     automatedMarketMakerPairs[from] &&
619                     !_isExcludedMaxTransactionAmount[to]
620                 ) {
621                     require(
622                         amount <= maxBuyAmount,
623                         "Buy transfer amount exceeds the max buy."
624                     );
625                     require(
626                         amount + balanceOf(to) <= maxWallet,
627                         "Max Wallet Exceeded"
628                     );
629                 }
630                 //when sell
631                 else if (
632                     automatedMarketMakerPairs[to] &&
633                     !_isExcludedMaxTransactionAmount[from]
634                 ) {
635                     require(
636                         amount <= maxSellAmount,
637                         "Sell transfer amount exceeds the max sell."
638                     );
639                 } else if (!_isExcludedMaxTransactionAmount[to]) {
640                     require(
641                         amount + balanceOf(to) <= maxWallet,
642                         "Max Wallet Exceeded"
643                     );
644                 }
645             }
646         }
647 
648         uint256 contractTokenBalance = balanceOf(address(this));
649 
650         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
651 
652         if (
653             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
654         ) {
655             swapping = true;
656             swapBack();
657             swapping = false;
658         }
659 
660         bool takeFee = true;
661         // if any account belongs to _isExcludedFromFee account then remove the fee
662         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
663             takeFee = false;
664         }
665 
666         uint256 fees = 0;
667         // only take fees on buys/sells, do not take on wallet transfers
668         if (takeFee) {
669             // bot/sniper penalty.
670             if (
671                 (earlyBuyPenaltyInEffect() ||
672                     (amount >= maxBuyAmount - .9 ether &&
673                         blockForPenaltyEnd + 8 >= block.number)) &&
674                 automatedMarketMakerPairs[from] &&
675                 !automatedMarketMakerPairs[to] &&
676                 !_isExcludedFromFees[to] &&
677                 buyTotalFees > 0
678             ) {
679                 if (!earlyBuyPenaltyInEffect()) {
680                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
681                     maxBuyAmount -= 1;
682                 }
683 
684                 if (!flaggedAsBot[to]) {
685                     flaggedAsBot[to] = true;
686                     botsCaught += 1;
687                     botBuyers.push(to);
688                     emit CaughtEarlyBuyer(to);
689                 }
690 
691                 fees = (amount * 99) / 100;
692                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
693                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
694             }
695             // on sell
696             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
697                 fees = (amount * sellTotalFees) / 100;
698                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
699                 tokensForOperations +=
700                     (fees * sellOperationsFee) /
701                     sellTotalFees;
702             }
703             // on buy
704             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
705                 fees = (amount * buyTotalFees) / 100;
706                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
707                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
708             }
709 
710             if (fees > 0) {
711                 super._transfer(from, address(this), fees);
712             }
713 
714             amount -= fees;
715         }
716 
717         super._transfer(from, to, amount);
718     }
719 
720     function earlyBuyPenaltyInEffect() public view returns (bool) {
721         return block.number < blockForPenaltyEnd;
722     }
723 
724     function swapTokensForEth(uint256 tokenAmount) private {
725         // generate the uniswap pair path of token -> weth
726         address[] memory path = new address[](2);
727         path[0] = address(this);
728         path[1] = dexRouter.WETH();
729 
730         _approve(address(this), address(dexRouter), tokenAmount);
731 
732         // make the swap
733         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
734             tokenAmount,
735             0, // accept any amount of ETH
736             path,
737             address(this),
738             block.timestamp
739         );
740     }
741 
742     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
743         // approve token transfer to cover all possible scenarios
744         _approve(address(this), address(dexRouter), tokenAmount);
745 
746         // add the liquidity
747         dexRouter.addLiquidityETH{value: ethAmount}(
748             address(this),
749             tokenAmount,
750             0, // slippage is unavoidable
751             0, // slippage is unavoidable
752             address(0xdead),
753             block.timestamp
754         );
755     }
756 
757     function swapBack() private {
758         uint256 contractBalance = balanceOf(address(this));
759         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
760 
761         if (contractBalance == 0 || totalTokensToSwap == 0) {
762             return;
763         }
764 
765         if (contractBalance > swapTokensAtAmount * 15) {
766             contractBalance = swapTokensAtAmount * 15;
767         }
768 
769         bool success;
770 
771         // Halve the amount of liquidity tokens
772         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
773             totalTokensToSwap /
774             2;
775 
776         swapTokensForEth(contractBalance - liquidityTokens);
777 
778         uint256 ethBalance = address(this).balance;
779         uint256 ethForLiquidity = ethBalance;
780 
781         uint256 ethForOperations = (ethBalance * tokensForOperations) /
782             (totalTokensToSwap - (tokensForLiquidity / 2));
783 
784         ethForLiquidity -= ethForOperations;
785 
786         tokensForLiquidity = 0;
787         tokensForOperations = 0;
788 
789         if (liquidityTokens > 0 && ethForLiquidity > 0) {
790             addLiquidity(liquidityTokens, ethForLiquidity);
791         }
792 
793         (success, ) = address(operationsAddress).call{
794             value: address(this).balance
795         }("");
796     }
797 
798     function transferForeignToken(
799         address _token,
800         address _to
801     ) external onlyOwner returns (bool _sent) {
802         require(_token != address(0), "_token address cannot be 0");
803         require(
804             _token != address(this) || !tradingActive,
805             "Can't withdraw native tokens while trading is active"
806         );
807         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
808         _sent = IERC20(_token).transfer(_to, _contractBalance);
809         emit TransferForeignToken(_token, _contractBalance);
810     }
811 
812     // withdraw ETH if stuck or someone sends to the address
813     function withdrawStuckETH() external onlyOwner {
814         bool success;
815         (success, ) = address(msg.sender).call{value: address(this).balance}(
816             ""
817         );
818     }
819 
820     function setOperationsAddress(
821         address _operationsAddress
822     ) external onlyOwner {
823         require(
824             _operationsAddress != address(0),
825             "_operationsAddress address cannot be 0"
826         );
827         operationsAddress = payable(_operationsAddress);
828         emit UpdatedOperationsAddress(_operationsAddress);
829     }
830 
831     function removeLimits() external onlyOwner {
832         limitsInEffect = false;
833     }
834 
835     function restoreLimits() external onlyOwner {
836         limitsInEffect = true;
837     }
838 
839     function resetTaxes() external onlyOwner {
840         buyOperationsFee = defaultOperationsFee;
841         buyLiquidityFee = defaultLiquidityFee;
842         buyTotalFees = buyOperationsFee + buyLiquidityFee;
843 
844         sellOperationsFee = defaultOperationsSellFee;
845         sellLiquidityFee = defaultLiquiditySellFee;
846         sellTotalFees = sellOperationsFee + sellLiquidityFee;
847     }
848 
849     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
850         require(!tradingActive, "Cannot reenable trading");
851         require(
852             blocksForPenalty <= 10,
853             "Cannot make penalty blocks more than 10"
854         );
855         tradingActive = true;
856         swapEnabled = true;
857         tradingActiveBlock = block.number;
858         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
859         emit EnabledTrading();
860     }
861 
862     function addLP(bool confirmAddLp) external onlyOwner {
863         require(confirmAddLp, "Please confirm adding of the LP");
864         require(!tradingActive, "Trading is already active, cannot relaunch.");
865 
866         // add the liquidity
867         require(
868             address(this).balance > 0,
869             "Must have ETH on contract to launch"
870         );
871         require(
872             balanceOf(address(this)) > 0,
873             "Must have Tokens on contract to launch"
874         );
875 
876         _approve(address(this), address(dexRouter), balanceOf(address(this)));
877 
878         dexRouter.addLiquidityETH{value: address(this).balance}(
879             address(this),
880             balanceOf(address(this)),
881             0, // slippage is unavoidable
882             0, // slippage is unavoidable
883             address(this),
884             block.timestamp
885         );
886     }
887 
888     function removeLP(uint256 percent) external onlyOwner {
889         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
890 
891         require(lpBalance > 0, "No LP tokens in contract");
892 
893         uint256 lpAmount = (lpBalance * percent) / 10000;
894 
895         // approve token transfer to cover all possible scenarios
896         IERC20(lpPair).approve(address(dexRouter), lpAmount);
897 
898         // remove the liquidity
899         dexRouter.removeLiquidityETH(
900             address(this),
901             lpAmount,
902             1, // slippage is unavoidable
903             1, // slippage is unavoidable
904             msg.sender,
905             block.timestamp
906         );
907     }
908 
909     function airdropToWallets(
910         address[] memory wallets,
911         uint256[] memory amountsInTokens
912     ) external onlyOwner {
913         require(
914             wallets.length == amountsInTokens.length,
915             "arrays must be the same length"
916         );
917         require(
918             wallets.length < 200,
919             "Can only airdrop 200 wallets per txn due to gas limits"
920         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
921         for (uint256 i = 0; i < wallets.length; i++) {
922             address wallet = wallets[i];
923             uint256 amount = amountsInTokens[i];
924             super._transfer(msg.sender, wallet, amount);
925         }
926     }
927 
928  function launchToken(uint256 blocksForPenalty) external onlyOwner {
929         require(!tradingActive, "Trading is already active, cannot relaunch.");
930         require(
931             blocksForPenalty < 10,
932             "Cannot make penalty blocks more than 10"
933         );
934 
935         //standard enable trading
936         tradingActive = true;
937         swapEnabled = true;
938         tradingActiveBlock = block.number;
939         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
940         emit EnabledTrading();
941 
942         address _dexRouter;
943 
944         if (block.chainid == 1) {
945             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
946         } else if (block.chainid == 5) {
947             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
948         } else {
949             revert("Chain not configured");
950         }
951 
952         // initialize router
953         dexRouter = IDexRouter(_dexRouter);
954         
955         // create pair
956         lpPair = IDexFactory(dexRouter.factory()).createPair(
957             address(this),
958             dexRouter.WETH()
959         );
960 
961         _excludeFromMaxTransaction(address(lpPair), true);
962         _setAutomatedMarketMakerPair(address(lpPair), true);        
963 
964         _excludeFromMaxTransaction(address(dexRouter), true);
965         excludeFromFees(address(dexRouter), true);                      
966 
967         // add the liquidity
968 
969         require(
970             address(this).balance > 0,
971             "Must have ETH on contract to launch"
972         );
973 
974         require(
975             balanceOf(address(this)) > 0,
976             "Must have Tokens on contract to launch"
977         );
978 
979         _approve(address(this), address(dexRouter), balanceOf(address(this)));
980 
981         dexRouter.addLiquidityETH{value: address(this).balance}(
982             address(this),
983             balanceOf(address(this)),
984             0, // slippage is unavoidable
985             0, // slippage is unavoidable
986             address(this),
987             block.timestamp
988         );
989     }    
990 }