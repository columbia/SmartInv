1 // SPDX-License-Identifier: MIT
2 
3 /**⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 Frenbot (MEF)
5 Telegram: https://t.me/frenbotTech
6 Website:  https://frenbot.tech
7 Twitter:  https://twitter.com/frenbotTech
8 **/
9 
10 pragma solidity 0.8.15;
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
41     function transfer(address recipient, uint256 amount)
42     external
43     returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender)
53     external
54     view
55     returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(
101         address indexed owner,
102         address indexed spender,
103         uint256 value
104     );
105 }
106 
107 interface IERC20Metadata is IERC20 {
108     /**
109      * @dev Returns the name of the token.
110      */
111     function name() external view returns (string memory);
112 
113     /**
114      * @dev Returns the symbol of the token.
115      */
116     function symbol() external view returns (string memory);
117 
118     /**
119      * @dev Returns the decimals places of the token.
120      */
121     function decimals() external view returns (uint8);
122 }
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     mapping(address => uint256) private _balances;
126 
127     mapping(address => mapping(address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string private _name;
132     string private _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account)
156     public
157     view
158     virtual
159     override
160     returns (uint256)
161     {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount)
166     public
167     virtual
168     override
169     returns (bool)
170     {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     function allowance(address owner, address spender)
176     public
177     view
178     virtual
179     override
180     returns (uint256)
181     {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount)
186     public
187     virtual
188     override
189     returns (bool)
190     {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) public virtual override returns (bool) {
200         _transfer(sender, recipient, amount);
201 
202         uint256 currentAllowance = _allowances[sender][_msgSender()];
203         require(
204             currentAllowance >= amount,
205             "ERC20: transfer amount exceeds allowance"
206         );
207         unchecked {
208             _approve(sender, _msgSender(), currentAllowance - amount);
209         }
210 
211         return true;
212     }
213 
214     function increaseAllowance(address spender, uint256 addedValue)
215     public
216     virtual
217     returns (bool)
218     {
219         _approve(
220             _msgSender(),
221             spender,
222             _allowances[_msgSender()][spender] + addedValue
223         );
224         return true;
225     }
226 
227     function decreaseAllowance(address spender, uint256 subtractedValue)
228     public
229     virtual
230     returns (bool)
231     {
232         uint256 currentAllowance = _allowances[_msgSender()][spender];
233         require(
234             currentAllowance >= subtractedValue,
235             "ERC20: decreased allowance below zero"
236         );
237         unchecked {
238             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
239         }
240 
241         return true;
242     }
243 
244     function _transfer(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) internal virtual {
249         require(sender != address(0), "ERC20: transfer from the zero address");
250         require(recipient != address(0), "ERC20: transfer to the zero address");
251 
252         uint256 senderBalance = _balances[sender];
253         require(
254             senderBalance >= amount,
255             "ERC20: transfer amount exceeds balance"
256         );
257         unchecked {
258             _balances[sender] = senderBalance - amount;
259         }
260         _balances[recipient] += amount;
261 
262         emit Transfer(sender, recipient, amount);
263     }
264 
265     function _createInitialSupply(address account, uint256 amount)
266     internal
267     virtual
268     {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _totalSupply += amount;
272         _balances[account] += amount;
273         emit Transfer(address(0), account, amount);
274     }
275 
276     function _burn(address account, uint256 amount) internal virtual {
277         require(account != address(0), "ERC20: burn from the zero address");
278         uint256 accountBalance = _balances[account];
279         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
280         unchecked {
281             _balances[account] = accountBalance - amount;
282         // Overflow not possible: amount <= accountBalance <= totalSupply.
283             _totalSupply -= amount;
284         }
285 
286         emit Transfer(account, address(0), amount);
287     }
288 
289     function _approve(
290         address owner,
291         address spender,
292         uint256 amount
293     ) internal virtual {
294         require(owner != address(0), "ERC20: approve from the zero address");
295         require(spender != address(0), "ERC20: approve to the zero address");
296 
297         _allowances[owner][spender] = amount;
298         emit Approval(owner, spender, amount);
299     }
300 }
301 
302 contract Ownable is Context {
303     address private _owner;
304 
305     event OwnershipTransferred(
306         address indexed previousOwner,
307         address indexed newOwner
308     );
309 
310     constructor() {
311         address msgSender = _msgSender();
312         _owner = msgSender;
313         emit OwnershipTransferred(address(0), msgSender);
314     }
315 
316     function owner() public view returns (address) {
317         return _owner;
318     }
319 
320     modifier onlyOwner() {
321         require(_owner == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324 
325     function renounceOwnership() external virtual onlyOwner {
326         emit OwnershipTransferred(_owner, address(0));
327         _owner = address(0);
328     }
329 
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(
332             newOwner != address(0),
333             "Ownable: new owner is the zero address"
334         );
335         emit OwnershipTransferred(_owner, newOwner);
336         _owner = newOwner;
337     }
338 }
339 
340 interface IDexRouter {
341     function factory() external pure returns (address);
342 
343     function WETH() external pure returns (address);
344 
345     function swapExactTokensForETHSupportingFeeOnTransferTokens(
346         uint256 amountIn,
347         uint256 amountOutMin,
348         address[] calldata path,
349         address to,
350         uint256 deadline
351     ) external;
352 
353     function swapExactETHForTokensSupportingFeeOnTransferTokens(
354         uint256 amountOutMin,
355         address[] calldata path,
356         address to,
357         uint256 deadline
358     ) external payable;
359 
360     function addLiquidityETH(
361         address token,
362         uint256 amountTokenDesired,
363         uint256 amountTokenMin,
364         uint256 amountETHMin,
365         address to,
366         uint256 deadline
367     )
368     external
369     payable
370     returns (
371         uint256 amountToken,
372         uint256 amountETH,
373         uint256 liquidity
374     );
375 }
376 
377 interface IDexFactory {
378     function createPair(address tokenA, address tokenB)
379     external
380     returns (address pair);
381 }
382 
383 contract Frenbot is ERC20, Ownable {
384     uint256 public maxBuyAmount;
385     uint256 public maxSellAmount;
386     uint256 public maxWalletAmount;
387 
388     address public lpPair;
389 
390     bool private swapping;
391     uint256 public swapTokensAtAmount;
392 
393     address operationsAddress;
394     address devAddress;
395 
396     bool public limitsInEffect = true;
397     bool public tradingActive = false;
398     bool public swapEnabled = false;
399 
400     uint256 public buyTotalFees;
401     uint256 public buyOperationsFee;
402     uint256 public buyLiquidityFee;
403     uint256 public buyDevFee;
404     uint256 public buyBurnFee;
405 
406     uint256 public sellTotalFees;
407     uint256 public sellOperationsFee;
408     uint256 public sellLiquidityFee;
409     uint256 public sellDevFee;
410     uint256 public sellBurnFee;
411 
412     uint256 public tokensForOperations;
413     uint256 public tokensForLiquidity;
414     uint256 public tokensForDev;
415     uint256 public tokensForBurn;
416 
417     mapping(address => bool) private _holderIsBot;
418     mapping(address => bool) private _isExcludedFromFees;
419     mapping(address => bool) private _isExcludedMaxTransactionAmount;
420     mapping(address => bool) private _isAutomatedMarketMakerPairs;
421 
422     IDexRouter private _dexRouter;
423 
424     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
425 
426     event EnabledTrading();
427 
428     event RemovedLimits();
429 
430     event ExcludeFromFees(address indexed account, bool isExcluded);
431 
432     event UpdatedMaxBuyAmount(uint256 newAmount);
433 
434     event UpdatedMaxSellAmount(uint256 newAmount);
435 
436     event UpdatedMaxWalletAmount(uint256 newAmount);
437 
438     event UpdatedOperationsAddress(address indexed newWallet);
439 
440     event MaxTransactionExclusion(address _address, bool excluded);
441 
442     event BuyBackTriggered(uint256 amount);
443 
444     event OwnerForcedSwapBack(uint256 timestamp);
445 
446     event CaughtEarlyBuyer(address sniper);
447 
448     event SwapAndLiquify(
449         uint256 tokensSwapped,
450         uint256 ethReceived,
451         uint256 tokensIntoLiquidity
452     );
453 
454     event TransferForeignToken(address token, uint256 amount);
455     constructor() ERC20("FRENBOT", "MEF") {
456         address newOwner = msg.sender;
457 
458         IDexRouter _dexrtr = IDexRouter(
459             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
460         );
461         _dexRouter = _dexrtr;
462 
463         lpPair = IDexFactory(_dexRouter.factory()).createPair(
464             address(this),
465             _dexRouter.WETH()
466         );
467 
468         _excludeFromMaxTransaction(address(lpPair), true);
469         _setAutomatedMarketMakerPair(address(lpPair), true);
470 
471         uint256 totalSupply = 10_000_000 ether;
472 
473         maxBuyAmount = (totalSupply * 2) / 100;
474         maxSellAmount = (totalSupply * 2) / 100;
475         maxWalletAmount = (totalSupply * 2) / 100;
476         swapTokensAtAmount = (totalSupply * 1) / 1000;
477 
478         buyOperationsFee = 20;
479         buyLiquidityFee = 0;
480         buyDevFee = 0;
481         buyBurnFee = 0;
482         buyTotalFees =
483             buyOperationsFee +
484             buyLiquidityFee +
485             buyDevFee +
486             buyBurnFee;
487 
488         sellOperationsFee = 30;
489         sellLiquidityFee = 0;
490         sellDevFee = 0;
491         sellBurnFee = 0;
492         sellTotalFees =
493             sellOperationsFee +
494             sellLiquidityFee +
495             sellDevFee +
496             sellBurnFee;
497 
498         _excludeFromMaxTransaction(newOwner, true);
499         _excludeFromMaxTransaction(address(this), true);
500         _excludeFromMaxTransaction(address(0xdead), true);
501 
502         excludeFromFees(newOwner, true);
503         excludeFromFees(address(this), true);
504         excludeFromFees(address(0xdead), true);
505 
506         operationsAddress = address(newOwner);
507         devAddress = address(newOwner);
508 
509         _createInitialSupply(newOwner, totalSupply);
510         transferOwnership(newOwner);
511     }
512 
513     receive() external payable {}
514 
515     function enableTrading() external onlyOwner {
516         require(!tradingActive, "Cannot reenable trading");
517         tradingActive = true;
518         swapEnabled = true;
519         emit EnabledTrading();
520     }
521 
522     function setSwapEnabled(bool isEnabled) external onlyOwner {
523         swapEnabled = isEnabled;
524     }
525 
526     function blacklistBot(address bot, bool isBot) external onlyOwner {
527         _holderIsBot[bot] = isBot;
528     }
529 
530     function blacklistBotBatch(address[] memory bots, bool isBot) external onlyOwner {
531         for (uint256 i = 0; i < bots.length; i++) {
532             _holderIsBot[bots[i]] = isBot;
533         }
534     }
535 
536     // remove limits after token is stable
537     function removeLimits() external onlyOwner {
538         limitsInEffect = false;
539         emit RemovedLimits();
540     }
541 
542     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
543         require(
544             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
545             "Cannot set max buy amount lower than 0.2%"
546         );
547         maxBuyAmount = newNum * (10**18);
548         emit UpdatedMaxBuyAmount(maxBuyAmount);
549     }
550 
551     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
552         require(
553             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
554             "Cannot set max sell amount lower than 0.2%"
555         );
556         maxSellAmount = newNum * (10**18);
557         emit UpdatedMaxSellAmount(maxSellAmount);
558     }
559 
560     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
561         require(
562             newNum >= ((totalSupply() * 3) / 1000) / 1e18,
563             "Cannot set max wallet amount lower than 0.3%"
564         );
565         maxWalletAmount = newNum * (10**18);
566         emit UpdatedMaxWalletAmount(maxWalletAmount);
567     }
568 
569     // change the minimum amount of tokens to sell from fees
570     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
571         require(
572             newAmount >= (totalSupply() * 1) / 100000,
573             "Swap amount cannot be lower than 0.001% total supply."
574         );
575         require(
576             newAmount <= (totalSupply() * 1) / 1000,
577             "Swap amount cannot be higher than 0.1% total supply."
578         );
579         swapTokensAtAmount = newAmount;
580     }
581 
582     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
583     private
584     {
585         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
586         emit MaxTransactionExclusion(updAds, isExcluded);
587     }
588 
589     function excludeFromMaxTransaction(address updAds, bool isEx)
590     external
591     onlyOwner
592     {
593         if (!isEx) {
594             require(
595                 updAds != lpPair,
596                 "Cannot remove uniswap pair from max txn"
597             );
598         }
599         _isExcludedMaxTransactionAmount[updAds] = isEx;
600     }
601 
602     function setAutomatedMarketMakerPair(address pair, bool value)
603     external
604     onlyOwner
605     {
606         require(
607             pair != lpPair,
608             "The pair cannot be removed from automatedMarketMakerPairs"
609         );
610 
611         _setAutomatedMarketMakerPair(pair, value);
612         emit SetAutomatedMarketMakerPair(pair, value);
613     }
614 
615     function _setAutomatedMarketMakerPair(address pair, bool value) private {
616         _isAutomatedMarketMakerPairs[pair] = value;
617 
618         _excludeFromMaxTransaction(pair, value);
619 
620         emit SetAutomatedMarketMakerPair(pair, value);
621     }
622 
623     function updateBuyFees(
624         uint256 _operationsFee,
625         uint256 _liquidityFee,
626         uint256 _devFee,
627         uint256 _burnFee
628     ) external onlyOwner {
629         buyOperationsFee = _operationsFee;
630         buyLiquidityFee = _liquidityFee;
631         buyDevFee = _devFee;
632         buyBurnFee = _burnFee;
633         buyTotalFees =
634             buyOperationsFee +
635             buyLiquidityFee +
636             buyDevFee +
637             buyBurnFee;
638         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
639     }
640 
641     function updateSellFees(
642         uint256 _operationsFee,
643         uint256 _liquidityFee,
644         uint256 _devFee,
645         uint256 _burnFee
646     ) external onlyOwner {
647         sellOperationsFee = _operationsFee;
648         sellLiquidityFee = _liquidityFee;
649         sellDevFee = _devFee;
650         sellBurnFee = _burnFee;
651         sellTotalFees =
652             sellOperationsFee +
653             sellLiquidityFee +
654             sellDevFee +
655             sellBurnFee;
656         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
657     }
658 
659     function returnToNormalTax() external onlyOwner {
660         sellOperationsFee = 1;
661         sellLiquidityFee = 0;
662         sellDevFee = 0;
663         sellBurnFee = 0;
664         sellTotalFees =
665             sellOperationsFee +
666             sellLiquidityFee +
667             sellDevFee +
668             sellBurnFee;
669         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
670 
671         buyOperationsFee = 1;
672         buyLiquidityFee = 0;
673         buyDevFee = 0;
674         buyBurnFee = 0;
675         buyTotalFees =
676             buyOperationsFee +
677             buyLiquidityFee +
678             buyDevFee +
679             buyBurnFee;
680         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
681     }
682 
683     function excludeFromFees(address account, bool excluded) public onlyOwner {
684         _isExcludedFromFees[account] = excluded;
685         emit ExcludeFromFees(account, excluded);
686     }
687 
688     function excludeFromFeesBatch(address[] memory accounts, bool excluded) public onlyOwner {
689         for (uint256 i = 0; i < accounts.length; i++) {
690             _isExcludedFromFees[accounts[i]] = excluded;
691             emit ExcludeFromFees(accounts[i], excluded);
692         }
693     }
694 
695     function _transfer(
696         address from,
697         address to,
698         uint256 amount
699     ) internal override {
700         require(from != address(0), "ERC20: transfer from the zero address");
701         require(to != address(0), "ERC20: transfer to the zero address");
702         require(amount > 0, "amount must be greater than 0");
703 
704         require(
705             !_holderIsBot[from] && !_holderIsBot[to],
706             "must not be flagged as bot"
707         );
708 
709         if (!tradingActive) {
710             require(
711                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
712                 "Trading is not active."
713             );
714         }
715 
716         if (limitsInEffect) {
717             if (
718                 from != owner() &&
719                 to != owner() &&
720                 to != address(0) &&
721                 to != address(0xdead) &&
722                 !_isExcludedFromFees[from] &&
723                 !_isExcludedFromFees[to]
724             ) {
725                 //when buy
726                 if (
727                     _isAutomatedMarketMakerPairs[from] &&
728                     !_isExcludedMaxTransactionAmount[to]
729                 ) {
730                     require(
731                         amount <= maxBuyAmount,
732                         "Buy transfer amount exceeds the max buy."
733                     );
734                     require(
735                         amount + balanceOf(to) <= maxWalletAmount,
736                         "Cannot Exceed max wallet"
737                     );
738                 }
739                     //when sell
740                 else if (
741                     _isAutomatedMarketMakerPairs[to] &&
742                     !_isExcludedMaxTransactionAmount[from]
743                 ) {
744                     require(
745                         amount <= maxSellAmount,
746                         "Sell transfer amount exceeds the max sell."
747                     );
748                 } else if (!_isExcludedMaxTransactionAmount[to]) {
749                     require(
750                         amount + balanceOf(to) <= maxWalletAmount,
751                         "Cannot Exceed max wallet"
752                     );
753                 }
754             }
755         }
756 
757         uint256 contractTokenBalance = balanceOf(address(this));
758         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
759 
760         if (
761             canSwap &&
762             swapEnabled &&
763             !swapping &&
764             !_isAutomatedMarketMakerPairs[from] &&
765             !_isExcludedFromFees[from] &&
766             !_isExcludedFromFees[to]
767         ) {
768             swapping = true;
769 
770             swapBack();
771 
772             swapping = false;
773         }
774 
775         bool takeFee = true;
776         // if any account belongs to _isExcludedFromFee account then remove the fee
777         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
778             takeFee = false;
779         }
780 
781         uint256 fees = 0;
782         // only take fees on buys/sells, do not take on wallet transfers
783         if (takeFee) {
784             // on sell
785             if (_isAutomatedMarketMakerPairs[to] && sellTotalFees > 0) {
786                 fees = (amount * sellTotalFees) / 100;
787                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
788                 tokensForOperations +=
789                     (fees * sellOperationsFee) /
790                     sellTotalFees;
791                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
792                 tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
793             }
794                 // on buy
795             else if (_isAutomatedMarketMakerPairs[from] && buyTotalFees > 0) {
796                 fees = (amount * buyTotalFees) / 100;
797                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
798                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
799                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
800                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
801             }
802 
803             if (fees > 0) {
804                 super._transfer(from, address(this), fees);
805             }
806 
807             amount -= fees;
808         }
809 
810         super._transfer(from, to, amount);
811     }
812 
813     function swapTokensForEth(uint256 tokenAmount) private {
814         // generate the uniswap pair path of token -> weth
815         address[] memory path = new address[](2);
816         path[0] = address(this);
817         path[1] = _dexRouter.WETH();
818 
819         _approve(address(this), address(_dexRouter), tokenAmount);
820 
821         // make the swap
822         _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
823             tokenAmount,
824             0, // accept any amount of ETH
825             path,
826             address(this),
827             block.timestamp
828         );
829     }
830 
831     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
832         // approve token transfer to cover all possible scenarios
833         _approve(address(this), address(_dexRouter), tokenAmount);
834 
835         // add the liquidity
836         _dexRouter.addLiquidityETH{value: ethAmount}(
837             address(this),
838             tokenAmount,
839             0, // slippage is unavoidable
840             0, // slippage is unavoidable
841             address(0xdead),
842             block.timestamp
843         );
844     }
845 
846     function swapBack() private {
847         if (tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
848             _burn(address(this), tokensForBurn);
849         }
850         tokensForBurn = 0;
851 
852         uint256 contractBalance = balanceOf(address(this));
853         uint256 totalTokensToSwap = tokensForLiquidity +
854                     tokensForOperations +
855                     tokensForDev;
856 
857         if (contractBalance == 0 || totalTokensToSwap == 0) {
858             return;
859         }
860 
861         if (contractBalance > swapTokensAtAmount * 20) {
862             contractBalance = swapTokensAtAmount * 20;
863         }
864 
865         bool success;
866 
867         // Halve the amount of liquidity tokens
868         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
869                     totalTokensToSwap /
870                     2;
871 
872         swapTokensForEth(contractBalance - liquidityTokens);
873 
874         uint256 ethBalance = address(this).balance;
875         uint256 ethForLiquidity = ethBalance;
876 
877         uint256 ethForOperations = (ethBalance * tokensForOperations) /
878             (totalTokensToSwap - (tokensForLiquidity / 2));
879         uint256 ethForDev = (ethBalance * tokensForDev) /
880             (totalTokensToSwap - (tokensForLiquidity / 2));
881 
882         ethForLiquidity -= ethForOperations + ethForDev;
883 
884         tokensForLiquidity = 0;
885         tokensForOperations = 0;
886         tokensForDev = 0;
887         tokensForBurn = 0;
888 
889         if (liquidityTokens > 0 && ethForLiquidity > 0) {
890             addLiquidity(liquidityTokens, ethForLiquidity);
891         }
892 
893         (success, ) = address(devAddress).call{value: ethForDev}("");
894 
895         (success, ) = address(operationsAddress).call{
896                 value: address(this).balance
897             }("");
898     }
899 
900     function transferForeignToken(address _token, address _to)
901     external
902     onlyOwner
903     returns (bool _sent)
904     {
905         require(_token != address(0), "_token address cannot be 0");
906         require(_token != address(this), "Can't withdraw native tokens");
907         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
908         _sent = IERC20(_token).transfer(_to, _contractBalance);
909         emit TransferForeignToken(_token, _contractBalance);
910     }
911 
912     // withdraw ETH from contract address
913     function withdrawStuckETH() external onlyOwner {
914         bool success;
915         (success, ) = address(msg.sender).call{value: address(this).balance}(
916             ""
917         );
918     }
919 
920     function setOperationsAddress(address _operationsAddress)
921     external
922     onlyOwner
923     {
924         require(
925             _operationsAddress != address(0),
926             "_operationsAddress address cannot be 0"
927         );
928         operationsAddress = payable(_operationsAddress);
929     }
930 
931     function setDevAddress(address _devAddress) external onlyOwner {
932         require(_devAddress != address(0), "_devAddress address cannot be 0");
933         devAddress = payable(_devAddress);
934     }
935 
936     // force Swap back if slippage issues.
937     function forceSwapBack() external onlyOwner {
938         require(
939             balanceOf(address(this)) >= swapTokensAtAmount,
940             "Can only swap when token amount is at or higher than restriction"
941         );
942         swapping = true;
943         swapBack();
944         swapping = false;
945         emit OwnerForcedSwapBack(block.timestamp);
946     }
947 
948     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
949     function buyBackTokens(uint256 amountInWei) external onlyOwner {
950         require(
951             amountInWei <= 10 ether,
952             "May not buy more than 10 ETH in a single buy to reduce sandwich attacks"
953         );
954 
955         address[] memory path = new address[](2);
956         path[0] = _dexRouter.WETH();
957         path[1] = address(this);
958 
959         _dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{
960                 value: amountInWei
961             }(
962             0, // accept any amount of Ethereum
963             path,
964             address(0xdead),
965             block.timestamp
966         );
967         emit BuyBackTriggered(amountInWei);
968     }
969 }