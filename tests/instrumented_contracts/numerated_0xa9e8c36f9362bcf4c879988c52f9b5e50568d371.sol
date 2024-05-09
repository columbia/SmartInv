1 // SPDX-License-Identifier: MIT
2 /*
3 
4         Sect Token (SECT)
5 
6         https://medium.com/@secttoken
7         https://t.me/SectToken 
8         https://twitter.com/SectToken
9 
10  */
11 pragma solidity 0.8.13;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount)
43         external
44         returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender)
54         external
55         view
56         returns (uint256);
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
156     function balanceOf(address account)
157         public
158         view
159         virtual
160         override
161         returns (uint256)
162     {
163         return _balances[account];
164     }
165 
166     function transfer(address recipient, uint256 amount)
167         public
168         virtual
169         override
170         returns (bool)
171     {
172         _transfer(_msgSender(), recipient, amount);
173         return true;
174     }
175 
176     function allowance(address owner, address spender)
177         public
178         view
179         virtual
180         override
181         returns (uint256)
182     {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount)
187         public
188         virtual
189         override
190         returns (bool)
191     {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) public virtual override returns (bool) {
201         _transfer(sender, recipient, amount);
202 
203         uint256 currentAllowance = _allowances[sender][_msgSender()];
204         require(
205             currentAllowance >= amount,
206             "ERC20: transfer amount exceeds allowance"
207         );
208         unchecked {
209             _approve(sender, _msgSender(), currentAllowance - amount);
210         }
211 
212         return true;
213     }
214 
215     function increaseAllowance(address spender, uint256 addedValue)
216         public
217         virtual
218         returns (bool)
219     {
220         _approve(
221             _msgSender(),
222             spender,
223             _allowances[_msgSender()][spender] + addedValue
224         );
225         return true;
226     }
227 
228     function decreaseAllowance(address spender, uint256 subtractedValue)
229         public
230         virtual
231         returns (bool)
232     {
233         uint256 currentAllowance = _allowances[_msgSender()][spender];
234         require(
235             currentAllowance >= subtractedValue,
236             "ERC20: decreased allowance below zero"
237         );
238         unchecked {
239             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
240         }
241 
242         return true;
243     }
244 
245     function _transfer(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) internal virtual {
250         require(sender != address(0), "ERC20: transfer from the zero address");
251         require(recipient != address(0), "ERC20: transfer to the zero address");
252 
253         uint256 senderBalance = _balances[sender];
254         require(
255             senderBalance >= amount,
256             "ERC20: transfer amount exceeds balance"
257         );
258         unchecked {
259             _balances[sender] = senderBalance - amount;
260         }
261         _balances[recipient] += amount;
262 
263         emit Transfer(sender, recipient, amount);
264     }
265 
266     function _createInitialSupply(address account, uint256 amount)
267         internal
268         virtual
269     {
270         require(account != address(0), "ERC20: mint to the zero address");
271 
272         _totalSupply += amount;
273         _balances[account] += amount;
274         emit Transfer(address(0), account, amount);
275     }
276 
277     function _approve(
278         address owner,
279         address spender,
280         uint256 amount
281     ) internal virtual {
282         require(owner != address(0), "ERC20: approve from the zero address");
283         require(spender != address(0), "ERC20: approve to the zero address");
284 
285         _allowances[owner][spender] = amount;
286         emit Approval(owner, spender, amount);
287     }
288 }
289 
290 contract Ownable is Context {
291     address private _owner;
292 
293     event OwnershipTransferred(
294         address indexed previousOwner,
295         address indexed newOwner
296     );
297 
298     constructor() {
299         address msgSender = _msgSender();
300         _owner = msgSender;
301         emit OwnershipTransferred(address(0), msgSender);
302     }
303 
304     function owner() public view returns (address) {
305         return _owner;
306     }
307 
308     modifier onlyOwner() {
309         require(_owner == _msgSender(), "Ownable: caller is not the owner");
310         _;
311     }
312 
313     function renounceOwnership(bool confirmRenounce)
314         external
315         virtual
316         onlyOwner
317     {
318         require(confirmRenounce, "Please confirm renounce!");
319         emit OwnershipTransferred(_owner, address(0));
320         _owner = address(0);
321     }
322 
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(
325             newOwner != address(0),
326             "Ownable: new owner is the zero address"
327         );
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332 
333 interface ILpPair {
334     function sync() external;
335 }
336 
337 interface IDexRouter {
338     function factory() external pure returns (address);
339 
340     function WETH() external pure returns (address);
341 
342     function swapExactTokensForETHSupportingFeeOnTransferTokens(
343         uint256 amountIn,
344         uint256 amountOutMin,
345         address[] calldata path,
346         address to,
347         uint256 deadline
348     ) external;
349 
350     function swapExactETHForTokensSupportingFeeOnTransferTokens(
351         uint256 amountOutMin,
352         address[] calldata path,
353         address to,
354         uint256 deadline
355     ) external payable;
356 
357     function addLiquidityETH(
358         address token,
359         uint256 amountTokenDesired,
360         uint256 amountTokenMin,
361         uint256 amountETHMin,
362         address to,
363         uint256 deadline
364     )
365         external
366         payable
367         returns (
368             uint256 amountToken,
369             uint256 amountETH,
370             uint256 liquidity
371         );
372 
373     function getAmountsOut(uint256 amountIn, address[] calldata path)
374         external
375         view
376         returns (uint256[] memory amounts);
377 
378     function removeLiquidityETH(
379         address token,
380         uint256 liquidity,
381         uint256 amountTokenMin,
382         uint256 amountETHMin,
383         address to,
384         uint256 deadline
385     ) external returns (uint256 amountToken, uint256 amountETH);
386 }
387 
388 interface IDexFactory {
389     function createPair(address tokenA, address tokenB)
390         external
391         returns (address pair);
392 }
393 
394 contract SectToken is ERC20, Ownable {
395     uint256 public maxBuyAmount;
396     uint256 public maxSellAmount;
397     uint256 public maxWallet;
398 
399     IDexRouter public dexRouter;
400     address public lpPair;
401 
402     bool private swapping;
403     uint256 public swapTokensAtAmount;
404 
405     address public operationsAddress1;
406     address public operationsAddress2;
407     address public lpReceiverAddress;
408 
409     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
410     uint256 public blockForPenaltyEnd;
411     mapping(address => bool) public boughtEarly;
412     address[] public earlyBuyers;
413     uint256 public botsCaught;
414 
415     bool public limitsInEffect = true;
416     bool public tradingActive = false;
417     bool public swapEnabled = false;
418     // MEV Bot prevention - cannot be turned off once enabled!!
419     bool public sellingEnabled = false;
420 
421     // Anti-bot and anti-whale mappings and variables
422     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
423     bool public transferDelayEnabled = true;
424 
425     uint256 public buyTotalFees;
426     uint256 public buyOperationsFee;
427     uint256 public buyLiquidityFee;
428 
429     uint256 private originalOperationsFee;
430     uint256 private originalLiquidityFee;
431 
432     uint256 public sellTotalFees;
433     uint256 public sellOperationsFee;
434     uint256 public sellLiquidityFee;
435 
436     uint256 public tokensForOperations;
437     uint256 public tokensForLiquidity;
438 
439     /******************/
440 
441     // exlcude from fees and max transaction amount
442     mapping(address => bool) private _isExcludedFromFees;
443     mapping(address => bool) public _isExcludedMaxTransactionAmount;
444 
445     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
446     // could be subject to a maximum transfer amount
447     mapping(address => bool) public automatedMarketMakerPairs;
448 
449     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
450     event EnabledTrading();
451     event EnabledSellingForever();
452     event ExcludeFromFees(address indexed account, bool isExcluded);
453     event UpdatedMaxBuyAmount(uint256 newAmount);
454     event UpdatedMaxSellAmount(uint256 newAmount);
455     event UpdatedMaxWalletAmount(uint256 newAmount);
456     event UpdatedOperationsAddress(address indexed newWallet1, address indexed newWallet2);
457     event MaxTransactionExclusion(address _address, bool excluded);
458     event OwnerForcedSwapBack(uint256 timestamp);
459     event CaughtEarlyBuyer(address sniper);
460     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
461     event TransferForeignToken(address token, uint256 amount);
462 
463     constructor() payable ERC20("Sect Token", "SECT") {
464         address newOwner = msg.sender;
465         
466         address _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
467         // initialize router
468         dexRouter = IDexRouter(_dexRouter);
469         // create pair
470         lpPair = IDexFactory(dexRouter.factory()).createPair(
471             address(this),
472             dexRouter.WETH()
473         );
474 
475         _excludeFromMaxTransaction(address(lpPair), true);
476         _setAutomatedMarketMakerPair(address(lpPair), true);
477 
478         uint256 totalSupply = 6666666666 * 1e18;
479 
480         maxBuyAmount = (totalSupply * 1) / 100; // 1%
481         maxSellAmount = (totalSupply * 1) / 100; // 1%
482         maxWallet = (totalSupply * 1) / 100; // 1%
483         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
484 
485         buyOperationsFee = 6;
486         buyLiquidityFee = 4;
487         buyTotalFees = buyOperationsFee + buyLiquidityFee;
488 
489         originalOperationsFee = 4;
490         originalLiquidityFee = 1;
491 
492         sellOperationsFee = 6;
493         sellLiquidityFee = 4;
494         sellTotalFees = sellOperationsFee + sellLiquidityFee;
495 
496         operationsAddress1 = address(0x0e070f3E1F38A8261cC455cEDeB3CB3e8aaAfBc4); //80%
497         operationsAddress2 = address(0x0D31a41c93e483a69E10D067e353A9C489962F67); //20%
498         lpReceiverAddress = address(0xA2cF6FeeE21e6A66B20ef8d36fEF3B537c84c1fe);
499 
500         _excludeFromMaxTransaction(newOwner, true);
501         _excludeFromMaxTransaction(address(this), true);
502         _excludeFromMaxTransaction(address(0xdead), true);
503         _excludeFromMaxTransaction(address(operationsAddress1), true);
504         _excludeFromMaxTransaction(address(operationsAddress2), true);
505         _excludeFromMaxTransaction(address(dexRouter), true);
506 
507         excludeFromFees(newOwner, true);
508         excludeFromFees(address(this), true);
509         excludeFromFees(address(0xdead), true);
510         excludeFromFees(address(operationsAddress1), true);
511         excludeFromFees(address(operationsAddress2), true);
512         excludeFromFees(address(dexRouter), true);
513 
514         _createInitialSupply(address(this), totalSupply); // Fair launch
515 
516         transferOwnership(newOwner);
517     }
518 
519     receive() external payable {}
520 
521     function getEarlyBuyers() external view returns (address[] memory) {
522         return earlyBuyers;
523     }
524 
525     function removeBoughtEarly(address wallet) external onlyOwner {
526         require(boughtEarly[wallet], "Wallet is already not flagged.");
527         boughtEarly[wallet] = false;
528     }
529 
530     function markBoughtEarly(address wallet) external onlyOwner {
531         require(!boughtEarly[wallet], "Wallet is already flagged.");
532         boughtEarly[wallet] = true;
533     }
534 
535     // disable Transfer delay - cannot be reenabled
536     function disableTransferDelay() external onlyOwner {
537         transferDelayEnabled = false;
538     }
539 
540     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
541         require(
542             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
543             "Cannot set max buy amount lower than 0.01%"
544         );
545         maxBuyAmount = newNum * (10**18);
546         emit UpdatedMaxBuyAmount(maxBuyAmount);
547     }
548 
549     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
550         require(
551             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
552             "Cannot set max sell amount lower than 0.01%"
553         );
554         maxSellAmount = newNum * (10**18);
555         emit UpdatedMaxSellAmount(maxSellAmount);
556     }
557 
558     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
559         require(
560             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
561             "Cannot set max sell amount lower than 0.5%"
562         );
563         maxWallet = newNum * (10**18);
564         emit UpdatedMaxWalletAmount(maxWallet);
565     }
566 
567     // change the minimum amount of tokens to sell from fees
568     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
569         require(
570             newAmount >= (totalSupply() * 1) / 100000,
571             "Swap amount cannot be lower than 0.001% total supply."
572         );
573         require(
574             newAmount <= (totalSupply() * 1) / 1000,
575             "Swap amount cannot be higher than 0.1% total supply."
576         );
577         swapTokensAtAmount = newAmount;
578     }
579 
580     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
581         private
582     {
583         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
584         emit MaxTransactionExclusion(updAds, isExcluded);
585     }
586 
587     function excludeFromMaxTransaction(address updAds, bool isEx)
588         external
589         onlyOwner
590     {
591         if (!isEx) {
592             require(
593                 updAds != lpPair,
594                 "Cannot remove uniswap pair from max txn"
595             );
596         }
597         _isExcludedMaxTransactionAmount[updAds] = isEx;
598     }
599 
600     function setAutomatedMarketMakerPair(address pair, bool value)
601         external
602         onlyOwner
603     {
604         require(
605             pair != lpPair,
606             "The pair cannot be removed from automatedMarketMakerPairs"
607         );
608         _setAutomatedMarketMakerPair(pair, value);
609         emit SetAutomatedMarketMakerPair(pair, value);
610     }
611 
612     function _setAutomatedMarketMakerPair(address pair, bool value) private {
613         automatedMarketMakerPairs[pair] = value;
614         _excludeFromMaxTransaction(pair, value);
615         emit SetAutomatedMarketMakerPair(pair, value);
616     }
617 
618     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
619         external
620         onlyOwner
621     {
622         buyOperationsFee = _operationsFee;
623         buyLiquidityFee = _liquidityFee;
624         buyTotalFees = buyOperationsFee + buyLiquidityFee;
625         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
626     }
627 
628     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
629         external
630         onlyOwner
631     {
632         sellOperationsFee = _operationsFee;
633         sellLiquidityFee = _liquidityFee;
634         sellTotalFees = sellOperationsFee + sellLiquidityFee;
635         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
636     }
637 
638     function excludeFromFees(address account, bool excluded) public onlyOwner {
639         _isExcludedFromFees[account] = excluded;
640         emit ExcludeFromFees(account, excluded);
641     }
642 
643     function _transfer(
644         address from,
645         address to,
646         uint256 amount
647     ) internal override {
648         require(from != address(0), "ERC20: transfer from the zero address");
649         require(to != address(0), "ERC20: transfer to the zero address");
650         require(amount > 0, "amount must be greater than 0");
651 
652         if (!tradingActive) {
653             require(
654                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
655                 "Trading is not active."
656             );
657         }
658 
659         if (!earlyBuyPenaltyInEffect() && tradingActive) {
660             require(
661                 !boughtEarly[from] || to == owner() || to == address(0xdead),
662                 "Bots cannot transfer tokens in or out except to owner or dead address."
663             );
664         }
665 
666         if (limitsInEffect) {
667             if (
668                 from != owner() &&
669                 to != owner() &&
670                 to != address(0xdead) &&
671                 !_isExcludedFromFees[from] &&
672                 !_isExcludedFromFees[to]
673             ) {
674                 if (transferDelayEnabled) {
675                     if (to != address(dexRouter) && to != address(lpPair)) {
676                         require(
677                             _holderLastTransferTimestamp[tx.origin] <
678                                 block.number - 2 &&
679                                 _holderLastTransferTimestamp[to] <
680                                 block.number - 2,
681                             "_transfer:: Transfer Delay enabled.  Try again later."
682                         );
683                         _holderLastTransferTimestamp[tx.origin] = block.number;
684                         _holderLastTransferTimestamp[to] = block.number;
685                     }
686                 }
687 
688                 //when buy
689                 if (
690                     automatedMarketMakerPairs[from] &&
691                     !_isExcludedMaxTransactionAmount[to]
692                 ) {
693                     require(
694                         amount <= maxBuyAmount,
695                         "Buy transfer amount exceeds the max buy."
696                     );
697                     require(
698                         amount + balanceOf(to) <= maxWallet,
699                         "Max Wallet Exceeded"
700                     );
701                 }
702                 //when sell
703                 else if (
704                     automatedMarketMakerPairs[to] &&
705                     !_isExcludedMaxTransactionAmount[from]
706                 ) {
707                     require(sellingEnabled, "Selling disabled");
708                     require(
709                         amount <= maxSellAmount,
710                         "Sell transfer amount exceeds the max sell."
711                     );
712                 } else if (!_isExcludedMaxTransactionAmount[to]) {
713                     require(
714                         amount + balanceOf(to) <= maxWallet,
715                         "Max Wallet Exceeded"
716                     );
717                 }
718             }
719         }
720 
721         uint256 contractTokenBalance = balanceOf(address(this));
722 
723         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
724 
725         if (
726             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
727         ) {
728             swapping = true;
729             swapBack();
730             swapping = false;
731         }
732 
733         bool takeFee = true;
734         // if any account belongs to _isExcludedFromFee account then remove the fee
735         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
736             takeFee = false;
737         }
738 
739         uint256 fees = 0;
740         // only take fees on buys/sells, do not take on wallet transfers
741         if (takeFee) {
742             // bot/sniper penalty.
743             if (
744                 (earlyBuyPenaltyInEffect() ||
745                     (amount >= maxBuyAmount - .9 ether &&
746                         blockForPenaltyEnd + 8 >= block.number)) &&
747                 automatedMarketMakerPairs[from] &&
748                 !automatedMarketMakerPairs[to] &&
749                 !_isExcludedFromFees[to] &&
750                 buyTotalFees > 0
751             ) {
752                 if (!earlyBuyPenaltyInEffect()) {
753                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
754                     maxBuyAmount -= 1;
755                 }
756 
757                 if (!boughtEarly[to]) {
758                     boughtEarly[to] = true;
759                     botsCaught += 1;
760                     earlyBuyers.push(to);
761                     emit CaughtEarlyBuyer(to);
762                 }
763 
764                 fees = (amount * 99) / 100;
765                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
766                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
767             }
768             // on sell
769             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
770                 fees = (amount * sellTotalFees) / 100;
771                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
772                 tokensForOperations +=
773                     (fees * sellOperationsFee) /
774                     sellTotalFees;
775             }
776             // on buy
777             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
778                 fees = (amount * buyTotalFees) / 100;
779                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
780                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
781             }
782 
783             if (fees > 0) {
784                 super._transfer(from, address(this), fees);
785             }
786 
787             amount -= fees;
788         }
789 
790         super._transfer(from, to, amount);
791     }
792 
793     function earlyBuyPenaltyInEffect() public view returns (bool) {
794         return block.number < blockForPenaltyEnd;
795     }
796 
797     function getLaunchedBlockNumber() public view returns (uint256) {
798         return tradingActiveBlock;
799     }
800 
801     function swapTokensForEth(uint256 tokenAmount) private {
802         // generate the uniswap pair path of token -> weth
803         address[] memory path = new address[](2);
804         path[0] = address(this);
805         path[1] = dexRouter.WETH();
806 
807         _approve(address(this), address(dexRouter), tokenAmount);
808 
809         // make the swap
810         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
811             tokenAmount,
812             0, // accept any amount of ETH
813             path,
814             address(this),
815             block.timestamp
816         );
817     }
818 
819     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
820         // approve token transfer to cover all possible scenarios
821         _approve(address(this), address(dexRouter), tokenAmount);
822 
823         // add the liquidity
824         dexRouter.addLiquidityETH{value: ethAmount}(
825             address(this),
826             tokenAmount,
827             0, // slippage is unavoidable
828             0, // slippage is unavoidable
829             lpReceiverAddress,
830             block.timestamp
831         );
832     }
833 
834     function removeLP(uint256 percent) external onlyOwner {
835         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
836 
837         require(lpBalance > 0, "No LP tokens in contract");
838 
839         uint256 lpAmount = (lpBalance * percent) / 10000;
840 
841         // approve token transfer to cover all possible scenarios
842         IERC20(lpPair).approve(address(dexRouter), lpAmount);
843 
844         // remove the liquidity
845         dexRouter.removeLiquidityETH(
846             address(this),
847             lpAmount,
848             1, // slippage is unavoidable
849             1, // slippage is unavoidable
850             msg.sender,
851             block.timestamp
852         );
853     }
854 
855     function swapBack() private {
856         uint256 contractBalance = balanceOf(address(this));
857         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
858 
859         if (contractBalance == 0 || totalTokensToSwap == 0) {
860             return;
861         }
862 
863         if (contractBalance > swapTokensAtAmount * 10) {
864             contractBalance = swapTokensAtAmount * 10;
865         }
866 
867         bool success;
868 
869         // Halve the amount of liquidity tokens
870         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
871             totalTokensToSwap /
872             2;
873 
874         swapTokensForEth(contractBalance - liquidityTokens);
875 
876         uint256 ethBalance = address(this).balance;
877         uint256 ethForLiquidity = ethBalance;
878 
879         uint256 ethForOperations = (ethBalance * tokensForOperations) /
880             (totalTokensToSwap - (tokensForLiquidity / 2));
881 
882         ethForLiquidity -= ethForOperations;
883 
884         tokensForLiquidity = 0;
885         tokensForOperations = 0;
886 
887         if (liquidityTokens > 0 && ethForLiquidity > 0) {
888             addLiquidity(liquidityTokens, ethForLiquidity);
889         }
890 
891         //Whatever balance left divide among 2 wallets 70/30
892         uint256 contractBal = address(this).balance;
893         (success, ) = address(operationsAddress1).call{
894             value: contractBal*80/100
895         }("");
896 
897         (success, ) = address(operationsAddress2).call{
898             value: contractBal*20/100
899         }("");
900 
901     }
902 
903     function transferForeignToken(address _token, address _to)
904         external
905         onlyOwner
906         returns (bool _sent)
907     {
908         require(_token != address(0), "_token address cannot be 0");
909         require(
910             _token != address(this) || !tradingActive,
911             "Can't withdraw native tokens while trading is active"
912         );
913         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
914         _sent = IERC20(_token).transfer(_to, _contractBalance);
915         emit TransferForeignToken(_token, _contractBalance);
916     }
917 
918     // withdraw ETH if stuck or someone sends to the address
919     function withdrawStuckETH() external onlyOwner {
920         bool success;
921         (success, ) = address(msg.sender).call{value: address(this).balance}(
922             ""
923         );
924     }
925 
926     function setOperationsAddress(address _operationsAddress1, address _operationsAddress2)
927         external
928         onlyOwner
929     {
930         require(
931             _operationsAddress1 != address(0) && _operationsAddress2 != address(0),
932             "_operationsAddress address cannot be 0"
933         );
934         operationsAddress1 = payable(_operationsAddress1);
935         operationsAddress2 = payable(_operationsAddress2);
936         emit UpdatedOperationsAddress(_operationsAddress1, _operationsAddress2);
937     }
938 
939     function setLPReceiverAddress(address _LPReceiverAddr)
940         external
941         onlyOwner
942     {
943         lpReceiverAddress = _LPReceiverAddr;
944     }
945 
946     // remove limits after token is stable
947     function removeLimits() external onlyOwner {
948         limitsInEffect = false;
949     }
950 
951     function restoreLimits() external onlyOwner {
952         limitsInEffect = true;
953     }
954 
955     // Enable selling - cannot be turned off!
956     function setSellingEnabled(bool confirmSellingEnabled) external onlyOwner {
957         require(confirmSellingEnabled, "Confirm selling enabled!");
958         require(!sellingEnabled, "Selling already enabled!");
959 
960         sellingEnabled = true;
961         emit EnabledSellingForever();
962     }
963 
964     function resetTaxes() external onlyOwner {
965         buyOperationsFee = originalOperationsFee;
966         buyLiquidityFee = originalLiquidityFee;
967         buyTotalFees = buyOperationsFee + buyLiquidityFee;
968 
969         sellOperationsFee = originalOperationsFee;
970         sellLiquidityFee = originalLiquidityFee;
971         sellTotalFees = sellOperationsFee + sellLiquidityFee;
972     }
973 
974     function instantiateLP() external onlyOwner {
975         require(!tradingActive, "Trading is already active, cannot relaunch.");
976 
977         // add the liquidity
978         require(
979             address(this).balance > 0,
980             "Must have ETH on contract to launch"
981         );
982         require(
983             balanceOf(address(this)) > 0,
984             "Must have Tokens on contract to launch"
985         );
986 
987         _approve(address(this), address(dexRouter), balanceOf(address(this)));
988 
989         dexRouter.addLiquidityETH{value: address(this).balance}(
990             address(this),
991             balanceOf(address(this)),
992             0, // slippage is unavoidable
993             0, // slippage is unavoidable
994             address(this),
995             block.timestamp
996         );
997     }
998 
999     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
1000         require(!tradingActive, "Cannot reenable trading");
1001         require(
1002             blocksForPenalty <= 10,
1003             "Cannot make penalty blocks more than 10"
1004         );
1005         tradingActive = true;
1006         swapEnabled = true;
1007         tradingActiveBlock = block.number;
1008         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1009         emit EnabledTrading();
1010     }
1011 }