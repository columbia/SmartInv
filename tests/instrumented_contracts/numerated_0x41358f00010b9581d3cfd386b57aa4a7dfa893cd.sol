1 // SPDX-License-Identifier: MIT
2 /*
3     XMAS ETH
4 
5     Tax: 1/1
6 
7     Contract renounced
8 
9     TG: https://t.me/XmasETH
10     TW: https://twitter.com/Xmas_ETH
11     WEB: xmaseth.com
12  */
13 pragma solidity 0.8.17;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount)
45         external
46         returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender)
56         external
57         view
58         returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     mapping(address => uint256) private _balances;
129 
130     mapping(address => mapping(address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134     string private _name;
135     string private _symbol;
136 
137     constructor(string memory name_, string memory symbol_) {
138         _name = name_;
139         _symbol = symbol_;
140     }
141 
142     function name() public view virtual override returns (string memory) {
143         return _name;
144     }
145 
146     function symbol() public view virtual override returns (string memory) {
147         return _symbol;
148     }
149 
150     function decimals() public view virtual override returns (uint8) {
151         return 18;
152     }
153 
154     function totalSupply() public view virtual override returns (uint256) {
155         return _totalSupply;
156     }
157 
158     function balanceOf(address account)
159         public
160         view
161         virtual
162         override
163         returns (uint256)
164     {
165         return _balances[account];
166     }
167 
168     function transfer(address recipient, uint256 amount)
169         public
170         virtual
171         override
172         returns (bool)
173     {
174         _transfer(_msgSender(), recipient, amount);
175         return true;
176     }
177 
178     function allowance(address owner, address spender)
179         public
180         view
181         virtual
182         override
183         returns (uint256)
184     {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount)
189         public
190         virtual
191         override
192         returns (bool)
193     {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) public virtual override returns (bool) {
203         _transfer(sender, recipient, amount);
204 
205         uint256 currentAllowance = _allowances[sender][_msgSender()];
206         require(
207             currentAllowance >= amount,
208             "ERC20: transfer amount exceeds allowance"
209         );
210         unchecked {
211             _approve(sender, _msgSender(), currentAllowance - amount);
212         }
213 
214         return true;
215     }
216 
217     function increaseAllowance(address spender, uint256 addedValue)
218         public
219         virtual
220         returns (bool)
221     {
222         _approve(
223             _msgSender(),
224             spender,
225             _allowances[_msgSender()][spender] + addedValue
226         );
227         return true;
228     }
229 
230     function decreaseAllowance(address spender, uint256 subtractedValue)
231         public
232         virtual
233         returns (bool)
234     {
235         uint256 currentAllowance = _allowances[_msgSender()][spender];
236         require(
237             currentAllowance >= subtractedValue,
238             "ERC20: decreased allowance below zero"
239         );
240         unchecked {
241             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
242         }
243 
244         return true;
245     }
246 
247     function _transfer(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) internal virtual {
252         require(sender != address(0), "ERC20: transfer from the zero address");
253         require(recipient != address(0), "ERC20: transfer to the zero address");
254 
255         uint256 senderBalance = _balances[sender];
256         require(
257             senderBalance >= amount,
258             "ERC20: transfer amount exceeds balance"
259         );
260         unchecked {
261             _balances[sender] = senderBalance - amount;
262         }
263         _balances[recipient] += amount;
264 
265         emit Transfer(sender, recipient, amount);
266     }
267 
268     function _createInitialSupply(address account, uint256 amount)
269         internal
270         virtual
271     {
272         require(account != address(0), "ERC20: mint to the zero address");
273 
274         _totalSupply += amount;
275         _balances[account] += amount;
276         emit Transfer(address(0), account, amount);
277     }
278 
279     function _burn(address account, uint256 amount) internal virtual {
280         require(account != address(0), "ERC20: burn from the zero address");
281         uint256 accountBalance = _balances[account];
282         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
283         unchecked {
284             _balances[account] = accountBalance - amount;
285             // Overflow not possible: amount <= accountBalance <= totalSupply.
286             _totalSupply -= amount;
287         }
288 
289         emit Transfer(account, address(0), amount);
290     }
291 
292     function _approve(
293         address owner,
294         address spender,
295         uint256 amount
296     ) internal virtual {
297         require(owner != address(0), "ERC20: approve from the zero address");
298         require(spender != address(0), "ERC20: approve to the zero address");
299 
300         _allowances[owner][spender] = amount;
301         emit Approval(owner, spender, amount);
302     }
303 }
304 
305 contract Ownable is Context {
306     address private _owner;
307 
308     event OwnershipTransferred(
309         address indexed previousOwner,
310         address indexed newOwner
311     );
312 
313     constructor() {
314         address msgSender = _msgSender();
315         _owner = msgSender;
316         emit OwnershipTransferred(address(0), msgSender);
317     }
318 
319     function owner() public view returns (address) {
320         return _owner;
321     }
322 
323     modifier onlyOwner() {
324         require(_owner == _msgSender(), "Ownable: caller is not the owner");
325         _;
326     }
327 
328     function renounceOwnership() external virtual onlyOwner {
329         emit OwnershipTransferred(_owner, address(0));
330         _owner = address(0);
331     }
332 
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(
335             newOwner != address(0),
336             "Ownable: new owner is the zero address"
337         );
338         emit OwnershipTransferred(_owner, newOwner);
339         _owner = newOwner;
340     }
341 }
342 
343 interface IDexRouter {
344     function factory() external pure returns (address);
345 
346     function WETH() external pure returns (address);
347 
348     function swapExactTokensForETHSupportingFeeOnTransferTokens(
349         uint256 amountIn,
350         uint256 amountOutMin,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external;
355 
356     function swapExactETHForTokensSupportingFeeOnTransferTokens(
357         uint256 amountOutMin,
358         address[] calldata path,
359         address to,
360         uint256 deadline
361     ) external payable;
362 
363     function addLiquidityETH(
364         address token,
365         uint256 amountTokenDesired,
366         uint256 amountTokenMin,
367         uint256 amountETHMin,
368         address to,
369         uint256 deadline
370     )
371         external
372         payable
373         returns (
374             uint256 amountToken,
375             uint256 amountETH,
376             uint256 liquidity
377         );
378 
379     function removeLiquidityETH(
380         address token,
381         uint256 liquidity,
382         uint256 amountTokenMin,
383         uint256 amountETHMin,
384         address to,
385         uint256 deadline
386     ) external returns (uint256 amountToken, uint256 amountETH);
387 }
388 
389 interface IDexFactory {
390     function createPair(address tokenA, address tokenB)
391         external
392         returns (address pair);
393 }
394 
395 contract XMAS is ERC20, Ownable {
396     uint256 public maxTxnAmount;
397     uint256 public maxWallet;
398 
399     IDexRouter public dexRouter;
400     address public lpPair;
401 
402     bool private swapping;
403     uint256 public swapTokensAtAmount;
404 
405     address operationsAddress;
406 
407     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
408     uint256 public blockForPenaltyEnd;
409     mapping(address => bool) public boughtEarly;
410     uint256 public botsCaught;
411 
412     bool public limitsInEffect = true;
413     bool public tradingActive = false;
414     bool public swapEnabled = false;
415 
416     // Anti-bot and anti-whale mappings and variables
417     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
418     bool public transferDelayEnabled = true;
419 
420     uint256 public buyTotalFees;
421     uint256 public buyOperationsFee;
422     uint256 public buyLiquidityFee;
423     uint256 public buyBurnFee;
424 
425     uint256 public sellTotalFees;
426     uint256 public sellOperationsFee;
427     uint256 public sellLiquidityFee;
428     uint256 public sellBurnFee;
429 
430     uint256 public constant FEE_DIVISOR = 10000;
431 
432     /******************/
433 
434     // exlcude from fees and max transaction amount
435     mapping(address => bool) private _isExcludedFromFees;
436     mapping(address => bool) public _isExcludedMaxTransactionAmount;
437 
438     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
439     // could be subject to a maximum transfer amount
440     mapping(address => bool) public automatedMarketMakerPairs;
441 
442     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
443 
444     event EnabledTrading();
445 
446     event RemovedLimits();
447 
448     event ExcludeFromFees(address indexed account, bool isExcluded);
449 
450     event UpdatedMaxTxnAmount(uint256 newAmount);
451     event UpdatedMaxWallet(uint256 newAmount);
452 
453     event UpdatedOperationsAddress(address indexed newWallet);
454 
455     event MaxTransactionExclusion(address _address, bool excluded);
456 
457     event OwnerForcedSwapBack(uint256 timestamp);
458 
459     event CaughtEarlyBuyer(address sniper);
460 
461     event SwapAndLiquify(
462         uint256 tokensSwapped,
463         uint256 ethReceived,
464         uint256 tokensIntoLiquidity
465     );
466 
467     event TransferForeignToken(address token, uint256 amount);
468 
469     constructor() payable ERC20("XMAS ETH", "XMAS") {
470         address newOwner = msg.sender; // can leave alone if owner is deployer.
471 
472         address _dexRouter;
473 
474         if (block.chainid == 1) {
475             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
476         } else if (block.chainid == 5) {
477             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
478         } else {
479             revert("Chain not configured");
480         }
481 
482         // initialize router
483         dexRouter = IDexRouter(_dexRouter);
484 
485         // create pair
486         lpPair = IDexFactory(dexRouter.factory()).createPair(
487             address(this),
488             dexRouter.WETH()
489         );
490         _excludeFromMaxTransaction(address(lpPair), true);
491         _setAutomatedMarketMakerPair(address(lpPair), true);
492 
493         uint256 totalSupply = 1 * 1e9 * 1e18;
494 
495         maxTxnAmount = (totalSupply * 1) / 100; // 1%
496         maxWallet = (totalSupply * 2) / 100; // 2%
497         swapTokensAtAmount = (totalSupply * 1) / 10000; // 0.01%
498 
499         buyOperationsFee = 0;
500         buyLiquidityFee = 100;
501         buyBurnFee = 0;
502         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyBurnFee;
503 
504         sellOperationsFee = 0;
505         sellLiquidityFee = 100;
506         sellBurnFee = 0;
507         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellBurnFee;
508 
509         _excludeFromMaxTransaction(newOwner, true);
510         _excludeFromMaxTransaction(address(this), true);
511         _excludeFromMaxTransaction(address(0xdead), true);
512         _excludeFromMaxTransaction(address(dexRouter), true);
513 
514         excludeFromFees(newOwner, true);
515         excludeFromFees(address(this), true);
516         excludeFromFees(address(0xdead), true);
517         excludeFromFees(address(dexRouter), true);
518 
519         operationsAddress = address(msg.sender);
520 
521         _createInitialSupply(address(this), totalSupply);
522         transferOwnership(newOwner);
523     }
524 
525     receive() external payable {}
526 
527     // only enable if no plan to airdrop
528 
529     function enableTrading(uint256 deadBlocks) external onlyOwner {
530         require(!tradingActive, "Cannot reenable trading");
531         tradingActive = true;
532         swapEnabled = true;
533         tradingActiveBlock = block.number;
534         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
535         emit EnabledTrading();
536     }
537 
538     function emergencyToggleSwapEnabled(bool enabled) external onlyOwner {
539         swapEnabled = enabled;
540     }
541 
542     // remove limits after token is stable
543     function removeLimits() external onlyOwner {
544         limitsInEffect = false;
545         transferDelayEnabled = false;
546         emit RemovedLimits();
547     }
548 
549     function restoreLimits() external onlyOwner {
550         limitsInEffect = true;
551     }
552 
553     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
554         boughtEarly[wallet] = flag;
555     }
556 
557     function massManageBoughtEarly(address[] calldata wallets, bool flag)
558         external
559         onlyOwner
560     {
561         for (uint256 i = 0; i < wallets.length; i++) {
562             boughtEarly[wallets[i]] = flag;
563         }
564     }
565 
566     // disable Transfer delay - cannot be reenabled
567     function disableTransferDelay() external onlyOwner {
568         transferDelayEnabled = false;
569     }
570 
571     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
572         require(
573             newNum >= ((totalSupply() * 2) / 1000) / (10**decimals()),
574             "Cannot set max buy amount lower than 0.2%"
575         );
576         maxTxnAmount = newNum * (10**decimals());
577         emit UpdatedMaxTxnAmount(maxTxnAmount);
578     }
579 
580     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
581         require(
582             newNum >= ((totalSupply() * 1) / 100) / (10**decimals()),
583             "Cannot set max buy amount lower than 0.2%"
584         );
585         maxWallet = newNum * (10**decimals());
586         emit UpdatedMaxWallet(maxWallet);
587     }
588 
589     // change the minimum amount of tokens to sell from fees
590     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
591         require(
592             newAmount >= (totalSupply() * 1) / 100000,
593             "Swap amount cannot be lower than 0.001% total supply."
594         );
595         require(
596             newAmount <= (totalSupply() * 1) / 1000,
597             "Swap amount cannot be higher than 0.1% total supply."
598         );
599         swapTokensAtAmount = newAmount;
600     }
601 
602     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
603         private
604     {
605         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
606         emit MaxTransactionExclusion(updAds, isExcluded);
607     }
608 
609     function excludeFromMaxTransaction(address updAds, bool isEx)
610         external
611         onlyOwner
612     {
613         if (!isEx) {
614             require(
615                 updAds != lpPair,
616                 "Cannot remove uniswap pair from max txn"
617             );
618         }
619         _isExcludedMaxTransactionAmount[updAds] = isEx;
620     }
621 
622     function setAutomatedMarketMakerPair(address pair, bool value)
623         external
624         onlyOwner
625     {
626         require(
627             pair != lpPair,
628             "The pair cannot be removed from automatedMarketMakerPairs"
629         );
630 
631         _setAutomatedMarketMakerPair(pair, value);
632         emit SetAutomatedMarketMakerPair(pair, value);
633     }
634 
635     function _setAutomatedMarketMakerPair(address pair, bool value) private {
636         automatedMarketMakerPairs[pair] = value;
637 
638         _excludeFromMaxTransaction(pair, value);
639 
640         emit SetAutomatedMarketMakerPair(pair, value);
641     }
642 
643     /**
644      * Buy tax cannot be greater than 1
645      */
646     function updateBuyFees(
647         uint256 _operationsFee,
648         uint256 _liquidityFee,
649         uint256 _burnFee
650     ) external onlyOwner {
651         buyOperationsFee = _operationsFee;
652         buyLiquidityFee = _liquidityFee;
653         buyBurnFee = _burnFee;
654         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyBurnFee;
655         require(buyTotalFees <= 100, "Must keep fees at 1% or less");
656     }
657 
658     /**
659      * Sell tax cannot be greater than 1
660      */
661     function updateSellFees(
662         uint256 _operationsFee,
663         uint256 _liquidityFee,
664         uint256 _burnFee
665     ) external onlyOwner {
666         sellOperationsFee = _operationsFee;
667         sellLiquidityFee = _liquidityFee;
668         sellBurnFee = _burnFee;
669         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellBurnFee;
670         require(sellTotalFees <= 100, "Must keep fees at 1% or less");
671     }
672 
673     function excludeFromFees(address account, bool excluded) public onlyOwner {
674         _isExcludedFromFees[account] = excluded;
675         emit ExcludeFromFees(account, excluded);
676     }
677 
678     function _transfer(
679         address from,
680         address to,
681         uint256 amount
682     ) internal override {
683         require(from != address(0), "ERC20: transfer from the zero address");
684         require(to != address(0), "ERC20: transfer to the zero address");
685         require(amount > 0, "amount must be greater than 0");
686 
687         if (!tradingActive) {
688             require(
689                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
690                 "Trading is not active."
691             );
692         }
693 
694         if (blockForPenaltyEnd > 0) {
695             require(
696                 !boughtEarly[from] || to == owner() || to == address(0xdead),
697                 "Bots cannot transfer tokens in or out except to owner or dead address."
698             );
699         }
700 
701         if (limitsInEffect) {
702             if (
703                 from != owner() &&
704                 to != owner() &&
705                 to != address(0) &&
706                 to != address(0xdead) &&
707                 !_isExcludedFromFees[from] &&
708                 !_isExcludedFromFees[to]
709             ) {
710                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
711                 if (transferDelayEnabled) {
712                     if (to != address(dexRouter) && to != address(lpPair)) {
713                         require(
714                             _holderLastTransferTimestamp[tx.origin] <
715                                 block.number - 2 &&
716                                 _holderLastTransferTimestamp[to] <
717                                 block.number - 2,
718                             "_transfer:: Transfer Delay enabled.  Try again later."
719                         );
720                         _holderLastTransferTimestamp[tx.origin] = block.number;
721                         _holderLastTransferTimestamp[to] = block.number;
722                     }
723                 }
724 
725                 //when buy
726                 if (
727                     automatedMarketMakerPairs[from] &&
728                     !_isExcludedMaxTransactionAmount[to]
729                 ) {
730                     require(
731                         amount <= maxTxnAmount,
732                         "Buy transfer amount exceeds the max txn."
733                     );
734                     require(
735                         balanceOf(to) + amount <= maxWallet,
736                         "Max Wallet Exceeded"
737                     );
738                 }
739                 //when sell
740                 else if (
741                     automatedMarketMakerPairs[to] &&
742                     !_isExcludedMaxTransactionAmount[from]
743                 ) {
744                     require(
745                         amount <= maxTxnAmount,
746                         "Sell transfer amount exceeds the max txn."
747                     );
748                 } else if (!_isExcludedMaxTransactionAmount[to]) {
749                     require(
750                         balanceOf(to) + amount <= maxWallet,
751                         "Max Wallet Exceeded"
752                     );
753                 }
754             }
755         }
756 
757         uint256 contractTokenBalance = balanceOf(address(this));
758 
759         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
760 
761         if (
762             canSwap &&
763             swapEnabled &&
764             !swapping &&
765             !automatedMarketMakerPairs[from] &&
766             !_isExcludedFromFees[from] &&
767             !_isExcludedFromFees[to]
768         ) {
769             swapping = true;
770 
771             if (contractTokenBalance > swapTokensAtAmount * 20) {
772                 contractTokenBalance = swapTokensAtAmount * 20;
773             }
774 
775             swapTokensForEthAndSend(contractTokenBalance);
776 
777             swapping = false;
778         }
779 
780         bool takeFee = true;
781         // if any account belongs to _isExcludedFromFee account then remove the fee
782         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
783             takeFee = false;
784         }
785 
786         uint256 fees = 0;
787         uint256 burnTokens = 0;
788         uint256 liquidityTokens = 0;
789         address currentLiquidityAddress;
790         // only take fees on buys/sells, do not take on wallet transfers
791 
792         if (takeFee) {
793             // bot/sniper penalty.
794             if (
795                 earlyBuyPenaltyInEffect() &&
796                 automatedMarketMakerPairs[from] &&
797                 !automatedMarketMakerPairs[to] &&
798                 buyTotalFees > 0
799             ) {
800                 if (!boughtEarly[to]) {
801                     boughtEarly[to] = true;
802                     botsCaught += 1;
803                     emit CaughtEarlyBuyer(to);
804                 }
805                 currentLiquidityAddress = from;
806                 fees = (amount * 99) / 100;
807                 liquidityTokens = (fees * buyLiquidityFee) / buyTotalFees;
808                 burnTokens = (fees * buyBurnFee) / buyTotalFees;
809             }
810             // on sell
811             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
812                 currentLiquidityAddress = to;
813                 fees = (amount * sellTotalFees) / FEE_DIVISOR;
814                 liquidityTokens = (fees * sellLiquidityFee) / sellTotalFees;
815                 burnTokens = (fees * sellBurnFee) / sellTotalFees;
816             }
817             // on buy
818             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
819                 currentLiquidityAddress = from;
820                 fees = (amount * buyTotalFees) / FEE_DIVISOR;
821                 liquidityTokens = (fees * buyLiquidityFee) / buyTotalFees;
822                 burnTokens = (fees * buyBurnFee) / buyTotalFees;
823             }
824 
825             if (fees > 0) {
826                 super._transfer(from, address(this), fees);
827                 if (burnTokens > 0) {
828                     _burn(address(this), burnTokens);
829                 }
830                 if (liquidityTokens > 0) {
831                     super._transfer(
832                         address(this),
833                         currentLiquidityAddress,
834                         liquidityTokens
835                     );
836                 }
837             }
838             amount -= fees;
839         }
840 
841         super._transfer(from, to, amount);
842     }
843 
844     function earlyBuyPenaltyInEffect() public view returns (bool) {
845         return block.number < blockForPenaltyEnd;
846     }
847 
848     function swapTokensForEthAndSend(uint256 tokenAmount) private {
849         // generate the uniswap pair path of token -> weth
850         address[] memory path = new address[](2);
851         path[0] = address(this);
852         path[1] = dexRouter.WETH();
853 
854         _approve(address(this), address(dexRouter), tokenAmount);
855 
856         // make the swap
857         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
858             tokenAmount,
859             0, // accept any amount of ETH
860             path,
861             address(operationsAddress),
862             block.timestamp
863         );
864     }
865 
866     function transferForeignToken(address _token, address _to)
867         external
868         onlyOwner
869         returns (bool _sent)
870     {
871         require(_token != address(0), "_token address cannot be 0");
872         require(_token != address(this), "Can't withdraw native tokens");
873         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
874         _sent = IERC20(_token).transfer(_to, _contractBalance);
875         emit TransferForeignToken(_token, _contractBalance);
876     }
877 
878     function withdrawStuckETH() external onlyOwner {
879         bool success;
880         (success, ) = address(msg.sender).call{value: address(this).balance}(
881             ""
882         );
883     }
884 
885     function setOperationsAddress(address _operationsAddress)
886         external
887         onlyOwner
888     {
889         require(
890             _operationsAddress != address(0),
891             "_operationsAddress address cannot be 0"
892         );
893         operationsAddress = payable(_operationsAddress);
894     }
895 
896     function resetTaxes() external onlyOwner {
897         buyOperationsFee = 0;
898         buyLiquidityFee = 100;
899         buyBurnFee = 0;
900         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyBurnFee;
901 
902         sellOperationsFee = 0;
903         sellLiquidityFee = 100;
904         sellBurnFee = 0;
905         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellBurnFee;
906     }
907 
908     function prepare(bool confirmAddLp, uint256 percent) external onlyOwner {
909         require(confirmAddLp, "Please confirm adding of the LP");
910         require(!tradingActive, "Trading is already active, cannot relaunch.");
911         require(
912             percent > 5000,
913             "A minimum of 50% of the tokens should be added to the LP"
914         );
915 
916         // add the liquidity
917         require(
918             address(this).balance > 0,
919             "Must have ETH on contract to launch"
920         );
921         require(
922             balanceOf(address(this)) > 0,
923             "Must have Tokens on contract to launch"
924         );
925 
926         uint256 tokenBalance = balanceOf(address(this));
927         uint256 lpTokenAmount = (tokenBalance * percent) / 10000;
928 
929         _approve(address(this), address(dexRouter), balanceOf(address(this)));
930 
931         dexRouter.addLiquidityETH{value: address(this).balance}(
932             address(this),
933             lpTokenAmount,
934             0, // slippage is unavoidable
935             0, // slippage is unavoidable
936             msg.sender,
937             block.timestamp
938         );
939     }
940 }