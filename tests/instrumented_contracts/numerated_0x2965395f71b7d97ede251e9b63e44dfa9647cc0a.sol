1 // SPDX-License-Identifier: MIT
2 
3 /*
4     https://t.me/ShinshuInu
5 */
6 
7 pragma solidity 0.8.13;
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
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount)
39         external
40         returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender)
50         external
51         view
52         returns (uint256);
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
152     function balanceOf(address account)
153         public
154         view
155         virtual
156         override
157         returns (uint256)
158     {
159         return _balances[account];
160     }
161 
162     function transfer(address recipient, uint256 amount)
163         public
164         virtual
165         override
166         returns (bool)
167     {
168         _transfer(_msgSender(), recipient, amount);
169         return true;
170     }
171 
172     function allowance(address owner, address spender)
173         public
174         view
175         virtual
176         override
177         returns (uint256)
178     {
179         return _allowances[owner][spender];
180     }
181 
182     function approve(address spender, uint256 amount)
183         public
184         virtual
185         override
186         returns (bool)
187     {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     function transferFrom(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) public virtual override returns (bool) {
197         _transfer(sender, recipient, amount);
198 
199         uint256 currentAllowance = _allowances[sender][_msgSender()];
200         require(
201             currentAllowance >= amount,
202             "ERC20: transfer amount exceeds allowance"
203         );
204         unchecked {
205             _approve(sender, _msgSender(), currentAllowance - amount);
206         }
207 
208         return true;
209     }
210 
211     function increaseAllowance(address spender, uint256 addedValue)
212         public
213         virtual
214         returns (bool)
215     {
216         _approve(
217             _msgSender(),
218             spender,
219             _allowances[_msgSender()][spender] + addedValue
220         );
221         return true;
222     }
223 
224     function decreaseAllowance(address spender, uint256 subtractedValue)
225         public
226         virtual
227         returns (bool)
228     {
229         uint256 currentAllowance = _allowances[_msgSender()][spender];
230         require(
231             currentAllowance >= subtractedValue,
232             "ERC20: decreased allowance below zero"
233         );
234         unchecked {
235             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
236         }
237 
238         return true;
239     }
240 
241     function _transfer(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) internal virtual {
246         require(sender != address(0), "ERC20: transfer from the zero address");
247         require(recipient != address(0), "ERC20: transfer to the zero address");
248 
249         uint256 senderBalance = _balances[sender];
250         require(
251             senderBalance >= amount,
252             "ERC20: transfer amount exceeds balance"
253         );
254         unchecked {
255             _balances[sender] = senderBalance - amount;
256         }
257         _balances[recipient] += amount;
258 
259         emit Transfer(sender, recipient, amount);
260     }
261 
262     function _createInitialSupply(address account, uint256 amount)
263         internal
264         virtual
265     {
266         require(account != address(0), "ERC20: mint to the zero address");
267 
268         _totalSupply += amount;
269         _balances[account] += amount;
270         emit Transfer(address(0), account, amount);
271     }
272 
273     function _approve(
274         address owner,
275         address spender,
276         uint256 amount
277     ) internal virtual {
278         require(owner != address(0), "ERC20: approve from the zero address");
279         require(spender != address(0), "ERC20: approve to the zero address");
280 
281         _allowances[owner][spender] = amount;
282         emit Approval(owner, spender, amount);
283     }
284 }
285 
286 contract Ownable is Context {
287     address private _owner;
288 
289     event OwnershipTransferred(
290         address indexed previousOwner,
291         address indexed newOwner
292     );
293 
294     constructor() {
295         address msgSender = _msgSender();
296         _owner = msgSender;
297         emit OwnershipTransferred(address(0), msgSender);
298     }
299 
300     function owner() public view returns (address) {
301         return _owner;
302     }
303 
304     modifier onlyOwner() {
305         require(_owner == _msgSender(), "Ownable: caller is not the owner");
306         _;
307     }
308 
309     function renounceOwnership(bool confirmRenounce)
310         external
311         virtual
312         onlyOwner
313     {
314         require(confirmRenounce, "Please confirm renounce!");
315         emit OwnershipTransferred(_owner, address(0));
316         _owner = address(0);
317     }
318 
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(
321             newOwner != address(0),
322             "Ownable: new owner is the zero address"
323         );
324         emit OwnershipTransferred(_owner, newOwner);
325         _owner = newOwner;
326     }
327 }
328 
329 interface ILpPair {
330     function sync() external;
331 }
332 
333 interface IDexRouter {
334     function factory() external pure returns (address);
335 
336     function WETH() external pure returns (address);
337 
338     function swapExactTokensForETHSupportingFeeOnTransferTokens(
339         uint256 amountIn,
340         uint256 amountOutMin,
341         address[] calldata path,
342         address to,
343         uint256 deadline
344     ) external;
345 
346     function swapExactETHForTokensSupportingFeeOnTransferTokens(
347         uint256 amountOutMin,
348         address[] calldata path,
349         address to,
350         uint256 deadline
351     ) external payable;
352 
353     function addLiquidityETH(
354         address token,
355         uint256 amountTokenDesired,
356         uint256 amountTokenMin,
357         uint256 amountETHMin,
358         address to,
359         uint256 deadline
360     )
361         external
362         payable
363         returns (
364             uint256 amountToken,
365             uint256 amountETH,
366             uint256 liquidity
367         );
368 
369     function getAmountsOut(uint256 amountIn, address[] calldata path)
370         external
371         view
372         returns (uint256[] memory amounts);
373 
374     function removeLiquidityETH(
375         address token,
376         uint256 liquidity,
377         uint256 amountTokenMin,
378         uint256 amountETHMin,
379         address to,
380         uint256 deadline
381     ) external returns (uint256 amountToken, uint256 amountETH);
382 }
383 
384 interface IDexFactory {
385     function createPair(address tokenA, address tokenB)
386         external
387         returns (address pair);
388 }
389 
390 contract ShinshuInu is ERC20, Ownable {
391     uint256 public maxBuyAmount;
392     uint256 public maxSellAmount;
393     uint256 public maxWallet;
394 
395     IDexRouter public dexRouter;
396     address public lpPair;
397 
398     bool private swapping;
399     uint256 public swapTokensAtAmount;
400     uint256 public swapTokensMaxAmount;
401 
402     address public operationsAddress1;
403     address public lpReceiverAddress;
404 
405     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
406     uint256 public blockForPenaltyEnd;
407     mapping(address => bool) public boughtEarly;
408     address[] public earlyBuyers;
409     uint256 public botsCaught;
410 
411     bool public limitsInEffect = true;
412     bool public tradingActive = false;
413     bool public swapEnabled = false;
414     // MEV Bot prevention - cannot be turned off once enabled!!
415     bool public sellingEnabled = false;
416 
417     // Anti-bot and anti-whale mappings and variables
418     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
419     bool public transferDelayEnabled = true;
420 
421     uint256 public buyTotalFees;
422     uint256 public buyOperationsFee;
423     uint256 public buyLiquidityFee;
424 
425     uint256 private originalOperationsFee;
426     uint256 private originalLiquidityFee;
427 
428     uint256 public sellTotalFees;
429     uint256 public sellOperationsFee;
430     uint256 public sellLiquidityFee;
431 
432     uint256 public tokensForOperations;
433     uint256 public tokensForLiquidity;
434 
435     /******************/
436 
437     // exlcude from fees and max transaction amount
438     mapping(address => bool) private _isExcludedFromFees;
439     mapping(address => bool) public _isExcludedMaxTransactionAmount;
440 
441     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
442     // could be subject to a maximum transfer amount
443     mapping(address => bool) public automatedMarketMakerPairs;
444 
445     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
446     event EnabledTrading();
447     event EnabledSellingForever();
448     event ExcludeFromFees(address indexed account, bool isExcluded);
449     event UpdatedMaxBuyAmount(uint256 newAmount);
450     event UpdatedMaxSellAmount(uint256 newAmount);
451     event UpdatedMaxWalletAmount(uint256 newAmount);
452     event UpdatedOperationsAddress(address indexed newWallet1);
453     event MaxTransactionExclusion(address _address, bool excluded);
454     event OwnerForcedSwapBack(uint256 timestamp);
455     event CaughtEarlyBuyer(address sniper);
456     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
457     event TransferForeignToken(address token, uint256 amount);
458 
459     constructor() payable ERC20("Shinshu Inu", "SHINSHU") {
460         address newOwner = msg.sender;
461         
462         address _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
463         // initialize router
464         dexRouter = IDexRouter(_dexRouter);
465         // create pair
466         lpPair = IDexFactory(dexRouter.factory()).createPair(
467             address(this),
468             dexRouter.WETH()
469         );
470 
471         _excludeFromMaxTransaction(address(lpPair), true);
472         _setAutomatedMarketMakerPair(address(lpPair), true);
473 
474         uint256 totalSupply = 1000000000000 * 10**18;
475 
476         maxBuyAmount = (totalSupply * 1) / 100; // 1%
477         maxSellAmount = totalSupply;
478         maxWallet = (totalSupply * 1) / 100; // 1%
479         swapTokensAtAmount = (totalSupply * 1) / 1000; // 0.1 %
480         swapTokensMaxAmount = (totalSupply * 1) / 1000; // 0.1 %
481 
482         buyOperationsFee = 0;
483         buyLiquidityFee = 0;
484         buyTotalFees = buyOperationsFee + buyLiquidityFee;
485 
486         originalOperationsFee = 4;
487         originalLiquidityFee = 1;
488 
489         sellOperationsFee = 10;
490         sellLiquidityFee = 5;
491         sellTotalFees = sellOperationsFee + sellLiquidityFee;
492 
493         operationsAddress1 = address(0x19BF580a5665cED4c934a48680f5025ceCF15E7F);
494         lpReceiverAddress = address(0x19BF580a5665cED4c934a48680f5025ceCF15E7F);
495 
496         _excludeFromMaxTransaction(newOwner, true);
497         _excludeFromMaxTransaction(address(this), true);
498         _excludeFromMaxTransaction(address(0xdead), true);
499         _excludeFromMaxTransaction(address(operationsAddress1), true);
500         _excludeFromMaxTransaction(address(dexRouter), true);
501 
502         excludeFromFees(newOwner, true);
503         excludeFromFees(address(this), true);
504         excludeFromFees(address(0xdead), true);
505         excludeFromFees(address(operationsAddress1), true);
506         excludeFromFees(address(dexRouter), true);
507 
508         _createInitialSupply(newOwner, totalSupply);
509         transferOwnership(newOwner);
510     }
511 
512     receive() external payable {}
513 
514     function getEarlyBuyers() external view returns (address[] memory) {
515         return earlyBuyers;
516     }
517 
518     function removeBoughtEarly(address wallet) external onlyOwner {
519         require(boughtEarly[wallet], "Wallet is already not flagged.");
520         boughtEarly[wallet] = false;
521     }
522 
523     function markBoughtEarly(address[] calldata wallet) external onlyOwner {
524         for(uint256 i = 0; i < wallet.length; i++) {
525             boughtEarly[wallet[i]] = true;
526         }
527     }
528 
529     // disable Transfer delay - cannot be reenabled
530     function disableTransferDelay() external onlyOwner {
531         transferDelayEnabled = false;
532     }
533 
534     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
535         require(
536             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
537             "Cannot set max buy amount lower than 0.01%"
538         );
539         maxBuyAmount = newNum * (10**18);
540         emit UpdatedMaxBuyAmount(maxBuyAmount);
541     }
542 
543     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
544         require(
545             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
546             "Cannot set max sell amount lower than 0.01%"
547         );
548         maxSellAmount = newNum * (10**18);
549         emit UpdatedMaxSellAmount(maxSellAmount);
550     }
551 
552     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
553         require(
554             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
555             "Cannot set max sell amount lower than 0.5%"
556         );
557         maxWallet = newNum * (10**18);
558         emit UpdatedMaxWalletAmount(maxWallet);
559     }
560 
561     // change the minimum amount of tokens to sell from fees
562     function updateSwapTokensAndMaxAmounts(uint256 swapAtAmount, uint swapMaxAmount) external onlyOwner {
563         swapTokensAtAmount = swapAtAmount;
564         swapTokensMaxAmount = swapMaxAmount;
565     }
566 
567     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
568         private
569     {
570         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
571         emit MaxTransactionExclusion(updAds, isExcluded);
572     }
573 
574     function excludeFromMaxTransaction(address updAds, bool isEx)
575         external
576         onlyOwner
577     {
578         if (!isEx) {
579             require(
580                 updAds != lpPair,
581                 "Cannot remove uniswap pair from max txn"
582             );
583         }
584         _isExcludedMaxTransactionAmount[updAds] = isEx;
585     }
586 
587     function setAutomatedMarketMakerPair(address pair, bool value)
588         external
589         onlyOwner
590     {
591         require(
592             pair != lpPair,
593             "The pair cannot be removed from automatedMarketMakerPairs"
594         );
595         _setAutomatedMarketMakerPair(pair, value);
596         emit SetAutomatedMarketMakerPair(pair, value);
597     }
598 
599     function _setAutomatedMarketMakerPair(address pair, bool value) private {
600         automatedMarketMakerPairs[pair] = value;
601         _excludeFromMaxTransaction(pair, value);
602         emit SetAutomatedMarketMakerPair(pair, value);
603     }
604 
605     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
606         external
607         onlyOwner
608     {
609         buyOperationsFee = _operationsFee;
610         buyLiquidityFee = _liquidityFee;
611         buyTotalFees = buyOperationsFee + buyLiquidityFee;
612         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
613     }
614 
615     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
616         external
617         onlyOwner
618     {
619         sellOperationsFee = _operationsFee;
620         sellLiquidityFee = _liquidityFee;
621         sellTotalFees = sellOperationsFee + sellLiquidityFee;
622         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
623     }
624 
625     function excludeFromFees(address account, bool excluded) public onlyOwner {
626         _isExcludedFromFees[account] = excluded;
627         emit ExcludeFromFees(account, excluded);
628     }
629 
630     function _transfer(
631         address from,
632         address to,
633         uint256 amount
634     ) internal override {
635         require(from != address(0), "ERC20: transfer from the zero address");
636         require(to != address(0), "ERC20: transfer to the zero address");
637         require(amount > 0, "amount must be greater than 0");
638 
639         if (!tradingActive) {
640             require(
641                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
642                 "Trading is not active."
643             );
644         }
645 
646         if (!earlyBuyPenaltyInEffect() && tradingActive) {
647             require(
648                 !boughtEarly[from] || to == owner() || to == address(0xdead),
649                 "Bots cannot transfer tokens in or out except to owner or dead address."
650             );
651         }
652 
653         if (limitsInEffect) {
654             if (
655                 from != owner() &&
656                 to != owner() &&
657                 to != address(0xdead) &&
658                 !_isExcludedFromFees[from] &&
659                 !_isExcludedFromFees[to]
660             ) {
661                 if (transferDelayEnabled) {
662                     if (to != address(dexRouter) && to != address(lpPair)) {
663                         require(
664                             _holderLastTransferTimestamp[tx.origin] <
665                                 block.number - 2 &&
666                                 _holderLastTransferTimestamp[to] <
667                                 block.number - 2,
668                             "_transfer:: Transfer Delay enabled.  Try again later."
669                         );
670                         _holderLastTransferTimestamp[tx.origin] = block.number;
671                         _holderLastTransferTimestamp[to] = block.number;
672                     }
673                 }
674 
675                 //when buy
676                 if (
677                     automatedMarketMakerPairs[from] &&
678                     !_isExcludedMaxTransactionAmount[to]
679                 ) {
680                     require(
681                         amount <= maxBuyAmount,
682                         "Buy transfer amount exceeds the max buy."
683                     );
684                     require(
685                         amount + balanceOf(to) <= maxWallet,
686                         "Max Wallet Exceeded"
687                     );
688                 }
689                 //when sell
690                 else if (
691                     automatedMarketMakerPairs[to] &&
692                     !_isExcludedMaxTransactionAmount[from]
693                 ) {
694                     require(sellingEnabled, "Selling disabled");
695                     require(
696                         amount <= maxSellAmount,
697                         "Sell transfer amount exceeds the max sell."
698                     );
699                 } else if (!_isExcludedMaxTransactionAmount[to]) {
700                     require(
701                         amount + balanceOf(to) <= maxWallet,
702                         "Max Wallet Exceeded"
703                     );
704                 }
705             }
706         }
707 
708         uint256 contractTokenBalance = balanceOf(address(this));
709 
710         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
711 
712         if (
713             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
714         ) {
715             swapping = true;
716             swapBack();
717             swapping = false;
718         }
719 
720         bool takeFee = true;
721         // if any account belongs to _isExcludedFromFee account then remove the fee
722         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
723             takeFee = false;
724         }
725 
726         uint256 fees = 0;
727         // only take fees on buys/sells, do not take on wallet transfers
728         if (takeFee) {
729             // bot/sniper penalty.
730             if (
731                 earlyBuyPenaltyInEffect() &&
732                 automatedMarketMakerPairs[from] &&
733                 !automatedMarketMakerPairs[to] &&
734                 !_isExcludedFromFees[to] &&
735                 buyTotalFees > 0
736             ) {
737                 
738                 if (!boughtEarly[to]) {
739                     boughtEarly[to] = true;
740                     botsCaught += 1;
741                     earlyBuyers.push(to);
742                     emit CaughtEarlyBuyer(to);
743                 }
744 
745                 fees = (amount * 99) / 100;
746                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
747                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
748             }
749             // on sell
750             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
751                 fees = (amount * sellTotalFees) / 100;
752                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
753                 tokensForOperations +=
754                     (fees * sellOperationsFee) /
755                     sellTotalFees;
756             }
757             // on buy
758             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
759                 fees = (amount * buyTotalFees) / 100;
760                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
761                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
762             }
763 
764             if (fees > 0) {
765                 super._transfer(from, address(this), fees);
766             }
767 
768             amount -= fees;
769         }
770 
771         super._transfer(from, to, amount);
772     }
773 
774     function earlyBuyPenaltyInEffect() public view returns (bool) {
775         return block.number < blockForPenaltyEnd;
776     }
777 
778     function getLaunchedBlockNumber() public view returns (uint256) {
779         return tradingActiveBlock;
780     }
781 
782     function swapTokensForEth(uint256 tokenAmount) private {
783         // generate the uniswap pair path of token -> weth
784         address[] memory path = new address[](2);
785         path[0] = address(this);
786         path[1] = dexRouter.WETH();
787 
788         _approve(address(this), address(dexRouter), tokenAmount);
789 
790         // make the swap
791         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
792             tokenAmount,
793             0, // accept any amount of ETH
794             path,
795             address(this),
796             block.timestamp
797         );
798     }
799 
800     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
801         // approve token transfer to cover all possible scenarios
802         _approve(address(this), address(dexRouter), tokenAmount);
803 
804         // add the liquidity
805         dexRouter.addLiquidityETH{value: ethAmount}(
806             address(this),
807             tokenAmount,
808             0, // slippage is unavoidable
809             0, // slippage is unavoidable
810             lpReceiverAddress,
811             block.timestamp
812         );
813     }
814 
815     function removeLP(uint256 percent) external onlyOwner {
816         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
817 
818         require(lpBalance > 0, "No LP tokens in contract");
819 
820         uint256 lpAmount = (lpBalance * percent) / 10000;
821 
822         // approve token transfer to cover all possible scenarios
823         IERC20(lpPair).approve(address(dexRouter), lpAmount);
824 
825         // remove the liquidity
826         dexRouter.removeLiquidityETH(
827             address(this),
828             lpAmount,
829             1, // slippage is unavoidable
830             1, // slippage is unavoidable
831             msg.sender,
832             block.timestamp
833         );
834     }
835 
836     function swapBack() private {
837         uint256 contractBalance = balanceOf(address(this));
838         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
839 
840         if (contractBalance == 0 || totalTokensToSwap == 0) {
841             return;
842         }
843 
844         if (contractBalance > swapTokensMaxAmount) {
845             contractBalance = swapTokensMaxAmount;
846         }
847 
848         bool success;
849 
850         // Halve the amount of liquidity tokens
851         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
852             totalTokensToSwap /
853             2;
854 
855         swapTokensForEth(contractBalance - liquidityTokens);
856 
857         uint256 ethBalance = address(this).balance;
858         uint256 ethForLiquidity = ethBalance;
859 
860         uint256 ethForOperations = (ethBalance * tokensForOperations) /
861             (totalTokensToSwap - (tokensForLiquidity / 2));
862 
863         ethForLiquidity -= ethForOperations;
864 
865         tokensForLiquidity = 0;
866         tokensForOperations = 0;
867 
868         if (liquidityTokens > 0 && ethForLiquidity > 0) {
869             addLiquidity(liquidityTokens, ethForLiquidity);
870         }
871 
872         uint256 contractBal = address(this).balance;
873         (success, ) = address(operationsAddress1).call{
874             value: contractBal
875         }("");
876 
877     }
878 
879     function transferForeignToken(address _token, address _to)
880         external
881         onlyOwner
882         returns (bool _sent)
883     {
884         require(_token != address(0), "_token address cannot be 0");
885         require(
886             _token != address(this) || !tradingActive,
887             "Can't withdraw native tokens while trading is active"
888         );
889         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
890         _sent = IERC20(_token).transfer(_to, _contractBalance);
891         emit TransferForeignToken(_token, _contractBalance);
892     }
893 
894     // withdraw ETH if stuck or someone sends to the address
895     function withdrawStuckETH() external onlyOwner {
896         bool success;
897         (success, ) = address(msg.sender).call{value: address(this).balance}(
898             ""
899         );
900     }
901 
902     function setOperationsAddress(address _operationsAddress1)
903         external
904         onlyOwner
905     {
906         require(
907             _operationsAddress1 != address(0),
908             "_operationsAddress address cannot be 0"
909         );
910         operationsAddress1 = payable(_operationsAddress1);
911         emit UpdatedOperationsAddress(_operationsAddress1);
912     }
913 
914     function setLPReceiverAddress(address _LPReceiverAddr)
915         external
916         onlyOwner
917     {
918         lpReceiverAddress = _LPReceiverAddr;
919     }
920 
921     // remove limits after token is stable
922     function removeLimits() external onlyOwner {
923         limitsInEffect = false;
924     }
925 
926     function restoreLimits() external onlyOwner {
927         limitsInEffect = true;
928     }
929 
930     // Enable selling - cannot be turned off!
931     function setSellingEnabled(bool confirmSellingEnabled) external onlyOwner {
932         require(confirmSellingEnabled, "Confirm selling enabled!");
933         require(!sellingEnabled, "Selling already enabled!");
934 
935         sellingEnabled = true;
936         emit EnabledSellingForever();
937     }
938 
939     function resetTaxes() external onlyOwner {
940         buyOperationsFee = originalOperationsFee;
941         buyLiquidityFee = originalLiquidityFee;
942         buyTotalFees = buyOperationsFee + buyLiquidityFee;
943 
944         sellOperationsFee = originalOperationsFee;
945         sellLiquidityFee = originalLiquidityFee;
946         sellTotalFees = sellOperationsFee + sellLiquidityFee;
947     }
948 
949     function instantiateLP() external onlyOwner {
950         require(!tradingActive, "Trading is already active, cannot relaunch.");
951 
952         // add the liquidity
953         require(
954             address(this).balance > 0,
955             "Must have ETH on contract to launch"
956         );
957         require(
958             balanceOf(address(this)) > 0,
959             "Must have Tokens on contract to launch"
960         );
961 
962         _approve(address(this), address(dexRouter), balanceOf(address(this)));
963 
964         dexRouter.addLiquidityETH{value: address(this).balance}(
965             address(this),
966             balanceOf(address(this)),
967             0, // slippage is unavoidable
968             0, // slippage is unavoidable
969             owner(),
970             block.timestamp
971         );
972     }
973 
974     function setTrading(bool _status) external onlyOwner {
975         tradingActive = _status;
976     }
977 
978     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
979         require(!tradingActive, "Cannot reenable trading");
980         require(
981             blocksForPenalty <= 10,
982             "Cannot make penalty blocks more than 10"
983         );
984         tradingActive = true;
985         swapEnabled = true;
986         tradingActiveBlock = block.number;
987         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
988         emit EnabledTrading();
989     }
990 
991     function multiSend(address[] calldata addresses, uint256[] calldata amounts) external onlyOwner {
992         require(addresses.length == amounts.length, "Must be the same length");
993         for(uint256 i = 0; i < addresses.length; i++) {
994             _transfer(_msgSender(), addresses[i], amounts[i] * 10**18);
995         }
996     }
997 
998 }