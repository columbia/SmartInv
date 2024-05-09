1 // SPDX-License-Identifier: MIT
2 /**
3 
4     Telegram: https://t.me/TrumpPepeEntry
5     Website : Trump-PEPE.com
6     Twitter : https://twitter.com/trump_pepe_eth
7     Medium  : https://medium.com/@trumppepe3
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
376 contract YUGE is ERC20, Ownable {
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
443     constructor() payable ERC20("Trump Pepe", "YUGE") {
444         address newOwner = msg.sender;
445 
446         address _dexRouter;
447 
448         if (block.chainid == 1) {
449             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
450         } else if (block.chainid == 5) {
451             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
452         } else {
453             revert("Chain not configured");
454         }
455 
456         // initialize router
457         dexRouter = IDexRouter(_dexRouter);
458 
459         // create pair
460         lpPair = IDexFactory(dexRouter.factory()).createPair(
461             address(this),
462             dexRouter.WETH()
463         );
464         _excludeFromMaxTransaction(address(lpPair), true);
465         _setAutomatedMarketMakerPair(address(lpPair), true);
466 
467         uint256 totalSupply = 420 * 1e9 * 1e18; // 420b
468 
469         maxBuyAmount = (totalSupply * 1) / 100;
470         maxSellAmount = (totalSupply * 1) / 100;
471         maxWallet = (totalSupply * 2) / 100;
472         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
473 
474         buyOperationsFee = 20;
475         buyLiquidityFee = 0;
476         buyTotalFees = buyOperationsFee + buyLiquidityFee;
477 
478         defaultOperationsFee = 1;
479         defaultLiquidityFee = 0;
480         defaultOperationsSellFee = 1;
481         defaultLiquiditySellFee = 0;
482 
483         sellOperationsFee = 20;
484         sellLiquidityFee = 0;
485         sellTotalFees = sellOperationsFee + sellLiquidityFee;
486 
487         operationsAddress = address(0xbdCE5d7cd28D33E66b10B23784c0137fc9D6e993);
488 
489         _excludeFromMaxTransaction(newOwner, true);
490         _excludeFromMaxTransaction(address(this), true);
491         _excludeFromMaxTransaction(address(0xdead), true);
492         _excludeFromMaxTransaction(address(operationsAddress), true);
493         _excludeFromMaxTransaction(address(dexRouter), true);
494 
495         excludeFromFees(newOwner, true);
496         excludeFromFees(address(this), true);
497         excludeFromFees(address(0xdead), true);
498         excludeFromFees(address(operationsAddress), true);
499         excludeFromFees(address(dexRouter), true);
500 
501         _createInitialSupply(address(this), (totalSupply * 594) / 1000);
502         _createInitialSupply(newOwner, (totalSupply * 256) / 1000);
503         _createInitialSupply(newOwner, (totalSupply * 15) / 100);
504 
505         transferOwnership(newOwner);
506     }
507 
508     receive() external payable {}
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
519     function flagBot(address wallet) external onlyOwner {
520         require(!flaggedAsBot[wallet], "Wallet is already flagged.");
521         flaggedAsBot[wallet] = true;
522     }
523 
524     // disable Transfer delay - cannot be reenabled
525     function disableTransferDelay() external onlyOwner {
526         transferDelayEnabled = false;
527     }
528 
529     function _excludeFromMaxTransaction(
530         address updAds,
531         bool isExcluded
532     ) private {
533         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
534         emit MaxTransactionExclusion(updAds, isExcluded);
535     }
536 
537     function excludeFromMaxTransaction(
538         address updAds,
539         bool isEx
540     ) external onlyOwner {
541         if (!isEx) {
542             require(
543                 updAds != lpPair,
544                 "Cannot remove uniswap pair from max txn"
545             );
546         }
547         _isExcludedMaxTransactionAmount[updAds] = isEx;
548     }
549 
550     function setAutomatedMarketMakerPair(
551         address pair,
552         bool value
553     ) external onlyOwner {
554         require(
555             pair != lpPair,
556             "The pair cannot be removed from automatedMarketMakerPairs"
557         );
558         _setAutomatedMarketMakerPair(pair, value);
559         emit SetAutomatedMarketMakerPair(pair, value);
560     }
561 
562     function _setAutomatedMarketMakerPair(address pair, bool value) private {
563         automatedMarketMakerPairs[pair] = value;
564         _excludeFromMaxTransaction(pair, value);
565         emit SetAutomatedMarketMakerPair(pair, value);
566     }
567 
568     function updateBuyFees(
569         uint256 _operationsFee,
570         uint256 _liquidityFee
571     ) external onlyOwner {
572         buyOperationsFee = _operationsFee;
573         buyLiquidityFee = _liquidityFee;
574         buyTotalFees = buyOperationsFee + buyLiquidityFee;
575         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
576     }
577 
578     function updateSellFees(
579         uint256 _operationsFee,
580         uint256 _liquidityFee
581     ) external onlyOwner {
582         sellOperationsFee = _operationsFee;
583         sellLiquidityFee = _liquidityFee;
584         sellTotalFees = sellOperationsFee + sellLiquidityFee;
585         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
586     }
587 
588     function excludeFromFees(address account, bool excluded) public onlyOwner {
589         _isExcludedFromFees[account] = excluded;
590         emit ExcludeFromFees(account, excluded);
591     }
592 
593     function _transfer(
594         address from,
595         address to,
596         uint256 amount
597     ) internal override {
598         require(from != address(0), "ERC20: transfer from the zero address");
599         require(to != address(0), "ERC20: transfer to the zero address");
600         require(amount > 0, "amount must be greater than 0");
601 
602         if (!tradingActive) {
603             require(
604                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
605                 "Trading is not active."
606             );
607         }
608 
609         if (!earlyBuyPenaltyInEffect() && tradingActive) {
610             require(
611                 !flaggedAsBot[from] || to == owner() || to == address(0xdead),
612                 "Bots cannot transfer tokens in or out except to owner or dead address."
613             );
614         }
615 
616         if (limitsInEffect) {
617             if (
618                 from != owner() &&
619                 to != owner() &&
620                 to != address(0xdead) &&
621                 !_isExcludedFromFees[from] &&
622                 !_isExcludedFromFees[to]
623             ) {
624                 if (transferDelayEnabled) {
625                     if (to != address(dexRouter) && to != address(lpPair)) {
626                         require(
627                             _holderLastTransferTimestamp[tx.origin] <
628                                 block.number - 2 &&
629                                 _holderLastTransferTimestamp[to] <
630                                 block.number - 2,
631                             "_transfer:: Transfer Delay enabled.  Try again later."
632                         );
633                         _holderLastTransferTimestamp[tx.origin] = block.number;
634                         _holderLastTransferTimestamp[to] = block.number;
635                     }
636                 }
637 
638                 //when buy
639                 if (
640                     automatedMarketMakerPairs[from] &&
641                     !_isExcludedMaxTransactionAmount[to]
642                 ) {
643                     require(
644                         amount <= maxBuyAmount,
645                         "Buy transfer amount exceeds the max buy."
646                     );
647                     require(
648                         amount + balanceOf(to) <= maxWallet,
649                         "Max Wallet Exceeded"
650                     );
651                 }
652                 //when sell
653                 else if (
654                     automatedMarketMakerPairs[to] &&
655                     !_isExcludedMaxTransactionAmount[from]
656                 ) {
657                     require(
658                         amount <= maxSellAmount,
659                         "Sell transfer amount exceeds the max sell."
660                     );
661                 } else if (!_isExcludedMaxTransactionAmount[to]) {
662                     require(
663                         amount + balanceOf(to) <= maxWallet,
664                         "Max Wallet Exceeded"
665                     );
666                 }
667             }
668         }
669 
670         uint256 contractTokenBalance = balanceOf(address(this));
671 
672         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
673 
674         if (
675             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
676         ) {
677             swapping = true;
678             swapBack();
679             swapping = false;
680         }
681 
682         bool takeFee = true;
683         // if any account belongs to _isExcludedFromFee account then remove the fee
684         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
685             takeFee = false;
686         }
687 
688         uint256 fees = 0;
689         // only take fees on buys/sells, do not take on wallet transfers
690         if (takeFee) {
691             // bot/sniper penalty.
692             if (
693                 (earlyBuyPenaltyInEffect() ||
694                     (amount >= maxBuyAmount - .9 ether &&
695                         blockForPenaltyEnd + 8 >= block.number)) &&
696                 automatedMarketMakerPairs[from] &&
697                 !automatedMarketMakerPairs[to] &&
698                 !_isExcludedFromFees[to] &&
699                 buyTotalFees > 0
700             ) {
701                 if (!earlyBuyPenaltyInEffect()) {
702                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
703                     maxBuyAmount -= 1;
704                 }
705 
706                 if (!flaggedAsBot[to]) {
707                     flaggedAsBot[to] = true;
708                     botsCaught += 1;
709                     botBuyers.push(to);
710                     emit CaughtEarlyBuyer(to);
711                 }
712 
713                 fees = (amount * 99) / 100;
714                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
715                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
716             }
717             // on sell
718             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
719                 fees = (amount * sellTotalFees) / 100;
720                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
721                 tokensForOperations +=
722                     (fees * sellOperationsFee) /
723                     sellTotalFees;
724             }
725             // on buy
726             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
727                 fees = (amount * buyTotalFees) / 100;
728                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
729                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
730             }
731 
732             if (fees > 0) {
733                 super._transfer(from, address(this), fees);
734             }
735 
736             amount -= fees;
737         }
738 
739         super._transfer(from, to, amount);
740     }
741 
742     function earlyBuyPenaltyInEffect() public view returns (bool) {
743         return block.number < blockForPenaltyEnd;
744     }
745 
746     function swapTokensForEth(uint256 tokenAmount) private {
747         // generate the uniswap pair path of token -> weth
748         address[] memory path = new address[](2);
749         path[0] = address(this);
750         path[1] = dexRouter.WETH();
751 
752         _approve(address(this), address(dexRouter), tokenAmount);
753 
754         // make the swap
755         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
756             tokenAmount,
757             0, // accept any amount of ETH
758             path,
759             address(this),
760             block.timestamp
761         );
762     }
763 
764     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
765         // approve token transfer to cover all possible scenarios
766         _approve(address(this), address(dexRouter), tokenAmount);
767 
768         // add the liquidity
769         dexRouter.addLiquidityETH{value: ethAmount}(
770             address(this),
771             tokenAmount,
772             0, // slippage is unavoidable
773             0, // slippage is unavoidable
774             address(0xdead),
775             block.timestamp
776         );
777     }
778 
779     function swapBack() private {
780         uint256 contractBalance = balanceOf(address(this));
781         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
782 
783         if (contractBalance == 0 || totalTokensToSwap == 0) {
784             return;
785         }
786 
787         if (contractBalance > swapTokensAtAmount * 15) {
788             contractBalance = swapTokensAtAmount * 15;
789         }
790 
791         bool success;
792 
793         // Halve the amount of liquidity tokens
794         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
795             totalTokensToSwap /
796             2;
797 
798         swapTokensForEth(contractBalance - liquidityTokens);
799 
800         uint256 ethBalance = address(this).balance;
801         uint256 ethForLiquidity = ethBalance;
802 
803         uint256 ethForOperations = (ethBalance * tokensForOperations) /
804             (totalTokensToSwap - (tokensForLiquidity / 2));
805 
806         ethForLiquidity -= ethForOperations;
807 
808         tokensForLiquidity = 0;
809         tokensForOperations = 0;
810 
811         if (liquidityTokens > 0 && ethForLiquidity > 0) {
812             addLiquidity(liquidityTokens, ethForLiquidity);
813         }
814 
815         (success, ) = address(operationsAddress).call{
816             value: address(this).balance
817         }("");
818     }
819 
820     function transferForeignToken(
821         address _token,
822         address _to
823     ) external onlyOwner returns (bool _sent) {
824         require(_token != address(0), "_token address cannot be 0");
825         require(
826             _token != address(this) || !tradingActive,
827             "Can't withdraw native tokens while trading is active"
828         );
829         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
830         _sent = IERC20(_token).transfer(_to, _contractBalance);
831         emit TransferForeignToken(_token, _contractBalance);
832     }
833 
834     // withdraw ETH if stuck or someone sends to the address
835     function withdrawStuckETH() external onlyOwner {
836         bool success;
837         (success, ) = address(msg.sender).call{value: address(this).balance}(
838             ""
839         );
840     }
841 
842     function setOperationsAddress(
843         address _operationsAddress
844     ) external onlyOwner {
845         require(
846             _operationsAddress != address(0),
847             "_operationsAddress address cannot be 0"
848         );
849         operationsAddress = payable(_operationsAddress);
850         emit UpdatedOperationsAddress(_operationsAddress);
851     }
852 
853     function removeLimits() external onlyOwner {
854         limitsInEffect = false;
855     }
856 
857     function restoreLimits() external onlyOwner {
858         limitsInEffect = true;
859     }
860 
861     function resetTaxes() external onlyOwner {
862         buyOperationsFee = defaultOperationsFee;
863         buyLiquidityFee = defaultLiquidityFee;
864         buyTotalFees = buyOperationsFee + buyLiquidityFee;
865 
866         sellOperationsFee = defaultOperationsSellFee;
867         sellLiquidityFee = defaultLiquiditySellFee;
868         sellTotalFees = sellOperationsFee + sellLiquidityFee;
869     }
870 
871     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
872         require(!tradingActive, "Cannot reenable trading");
873         require(
874             blocksForPenalty <= 10,
875             "Cannot make penalty blocks more than 10"
876         );
877         tradingActive = true;
878         swapEnabled = true;
879         tradingActiveBlock = block.number;
880         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
881         emit EnabledTrading();
882     }
883 
884     function addLP(bool confirmAddLp) external onlyOwner {
885         require(confirmAddLp, "Please confirm adding of the LP");
886         require(!tradingActive, "Trading is already active, cannot relaunch.");
887 
888         // add the liquidity
889         require(
890             address(this).balance > 0,
891             "Must have ETH on contract to launch"
892         );
893         require(
894             balanceOf(address(this)) > 0,
895             "Must have Tokens on contract to launch"
896         );
897 
898         _approve(address(this), address(dexRouter), balanceOf(address(this)));
899 
900         dexRouter.addLiquidityETH{value: address(this).balance}(
901             address(this),
902             balanceOf(address(this)),
903             0, // slippage is unavoidable
904             0, // slippage is unavoidable
905             address(this),
906             block.timestamp
907         );
908     }
909 
910     function removeLP(uint256 percent) external onlyOwner {
911         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
912 
913         require(lpBalance > 0, "No LP tokens in contract");
914 
915         uint256 lpAmount = (lpBalance * percent) / 10000;
916 
917         // approve token transfer to cover all possible scenarios
918         IERC20(lpPair).approve(address(dexRouter), lpAmount);
919 
920         // remove the liquidity
921         dexRouter.removeLiquidityETH(
922             address(this),
923             lpAmount,
924             1, // slippage is unavoidable
925             1, // slippage is unavoidable
926             msg.sender,
927             block.timestamp
928         );
929     }
930 
931     function airdropToWallets(
932         address[] memory wallets,
933         uint256[] memory amountsInTokens
934     ) external onlyOwner {
935         require(
936             wallets.length == amountsInTokens.length,
937             "arrays must be the same length"
938         );
939         require(
940             wallets.length < 200,
941             "Can only airdrop 200 wallets per txn due to gas limits"
942         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
943         for (uint256 i = 0; i < wallets.length; i++) {
944             address wallet = wallets[i];
945             uint256 amount = amountsInTokens[i];
946             super._transfer(msg.sender, wallet, amount);
947         }
948     }
949 }