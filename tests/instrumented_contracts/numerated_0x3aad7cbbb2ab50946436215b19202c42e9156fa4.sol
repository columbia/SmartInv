1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.15;
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
33     function transfer(address recipient, uint256 amount)
34         external
35         returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender)
45         external
46         view
47         returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(
93         address indexed owner,
94         address indexed spender,
95         uint256 value
96     );
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account)
148         public
149         view
150         virtual
151         override
152         returns (uint256)
153     {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount)
158         public
159         virtual
160         override
161         returns (bool)
162     {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166 
167     function allowance(address owner, address spender)
168         public
169         view
170         virtual
171         override
172         returns (uint256)
173     {
174         return _allowances[owner][spender];
175     }
176 
177     function approve(address spender, uint256 amount)
178         public
179         virtual
180         override
181         returns (bool)
182     {
183         _approve(_msgSender(), spender, amount);
184         return true;
185     }
186 
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) public virtual override returns (bool) {
192         _transfer(sender, recipient, amount);
193 
194         uint256 currentAllowance = _allowances[sender][_msgSender()];
195         require(
196             currentAllowance >= amount,
197             "ERC20: transfer amount exceeds allowance"
198         );
199         unchecked {
200             _approve(sender, _msgSender(), currentAllowance - amount);
201         }
202 
203         return true;
204     }
205 
206     function increaseAllowance(address spender, uint256 addedValue)
207         public
208         virtual
209         returns (bool)
210     {
211         _approve(
212             _msgSender(),
213             spender,
214             _allowances[_msgSender()][spender] + addedValue
215         );
216         return true;
217     }
218 
219     function decreaseAllowance(address spender, uint256 subtractedValue)
220         public
221         virtual
222         returns (bool)
223     {
224         uint256 currentAllowance = _allowances[_msgSender()][spender];
225         require(
226             currentAllowance >= subtractedValue,
227             "ERC20: decreased allowance below zero"
228         );
229         unchecked {
230             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
231         }
232 
233         return true;
234     }
235 
236     function _transfer(
237         address sender,
238         address recipient,
239         uint256 amount
240     ) internal virtual {
241         require(sender != address(0), "ERC20: transfer from the zero address");
242         require(recipient != address(0), "ERC20: transfer to the zero address");
243 
244         uint256 senderBalance = _balances[sender];
245         require(
246             senderBalance >= amount,
247             "ERC20: transfer amount exceeds balance"
248         );
249         unchecked {
250             _balances[sender] = senderBalance - amount;
251         }
252         _balances[recipient] += amount;
253 
254         emit Transfer(sender, recipient, amount);
255     }
256 
257     function _createInitialSupply(address account, uint256 amount)
258         internal
259         virtual
260     {
261         require(account != address(0), "ERC20: mint to the zero address");
262 
263         _totalSupply += amount;
264         _balances[account] += amount;
265         emit Transfer(address(0), account, amount);
266     }
267 
268     function _burn(address account, uint256 amount) internal virtual {
269         require(account != address(0), "ERC20: burn from the zero address");
270         uint256 accountBalance = _balances[account];
271         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
272         unchecked {
273             _balances[account] = accountBalance - amount;
274             // Overflow not possible: amount <= accountBalance <= totalSupply.
275             _totalSupply -= amount;
276         }
277 
278         emit Transfer(account, address(0), amount);
279     }
280 
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288 
289         _allowances[owner][spender] = amount;
290         emit Approval(owner, spender, amount);
291     }
292 }
293 
294 contract Ownable is Context {
295     address private _owner;
296 
297     event OwnershipTransferred(
298         address indexed previousOwner,
299         address indexed newOwner
300     );
301 
302     constructor() {
303         address msgSender = _msgSender();
304         _owner = msgSender;
305         emit OwnershipTransferred(address(0), msgSender);
306     }
307 
308     function owner() public view returns (address) {
309         return _owner;
310     }
311 
312     modifier onlyOwner() {
313         require(_owner == _msgSender(), "Ownable: caller is not the owner");
314         _;
315     }
316 
317     function renounceOwnership() external virtual onlyOwner {
318         emit OwnershipTransferred(_owner, address(0));
319         _owner = address(0);
320     }
321 
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(
324             newOwner != address(0),
325             "Ownable: new owner is the zero address"
326         );
327         emit OwnershipTransferred(_owner, newOwner);
328         _owner = newOwner;
329     }
330 }
331 
332 interface IDexRouter {
333     function factory() external pure returns (address);
334 
335     function WETH() external pure returns (address);
336 
337     function swapExactTokensForETHSupportingFeeOnTransferTokens(
338         uint256 amountIn,
339         uint256 amountOutMin,
340         address[] calldata path,
341         address to,
342         uint256 deadline
343     ) external;
344 
345     function swapExactETHForTokensSupportingFeeOnTransferTokens(
346         uint256 amountOutMin,
347         address[] calldata path,
348         address to,
349         uint256 deadline
350     ) external payable;
351 
352     function addLiquidityETH(
353         address token,
354         uint256 amountTokenDesired,
355         uint256 amountTokenMin,
356         uint256 amountETHMin,
357         address to,
358         uint256 deadline
359     )
360         external
361         payable
362         returns (
363             uint256 amountToken,
364             uint256 amountETH,
365             uint256 liquidity
366         );
367 }
368 
369 interface IDexFactory {
370     function createPair(address tokenA, address tokenB)
371         external
372         returns (address pair);
373 }
374 
375 contract Meow is ERC20, Ownable {
376     uint256 public maxBuyAmount;
377     uint256 public maxSellAmount;
378     uint256 public maxWalletAmount;
379 
380     IDexRouter public dexRouter;
381     address public lpPair;
382 
383     bool private swapping;
384     uint256 public swapTokensAtAmount;
385 
386     address operationsAddress;
387     address devAddress;
388 
389     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
390     uint256 public blockForPenaltyEnd;
391     mapping(address => bool) public boughtEarly;
392     uint256 public botsCaught;
393 
394     bool public limitsInEffect = true;
395     bool public tradingActive = false;
396     bool public swapEnabled = false;
397 
398     // Anti-bot and anti-whale mappings and variables
399     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
400     mapping(address => bool) private _holderIsBot;
401     bool public transferDelayEnabled = true;
402 
403     uint256 public buyTotalFees;
404     uint256 public buyOperationsFee;
405     uint256 public buyLiquidityFee;
406     uint256 public buyDevFee;
407     uint256 public buyBurnFee;
408 
409     uint256 public sellTotalFees;
410     uint256 public sellOperationsFee;
411     uint256 public sellLiquidityFee;
412     uint256 public sellDevFee;
413     uint256 public sellBurnFee;
414 
415     uint256 public tokensForOperations;
416     uint256 public tokensForLiquidity;
417     uint256 public tokensForDev;
418     uint256 public tokensForBurn;
419 
420     /******************/
421 
422     // exlcude from fees and max transaction amount
423     mapping(address => bool) private _isExcludedFromFees;
424     mapping(address => bool) public _isExcludedMaxTransactionAmount;
425 
426     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
427     // could be subject to a maximum transfer amount
428     mapping(address => bool) public automatedMarketMakerPairs;
429 
430     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
431 
432     event EnabledTrading();
433 
434     event RemovedLimits();
435 
436     event ExcludeFromFees(address indexed account, bool isExcluded);
437 
438     event UpdatedMaxBuyAmount(uint256 newAmount);
439 
440     event UpdatedMaxSellAmount(uint256 newAmount);
441 
442     event UpdatedMaxWalletAmount(uint256 newAmount);
443 
444     event UpdatedOperationsAddress(address indexed newWallet);
445 
446     event MaxTransactionExclusion(address _address, bool excluded);
447 
448     event BuyBackTriggered(uint256 amount);
449 
450     event OwnerForcedSwapBack(uint256 timestamp);
451 
452     event CaughtEarlyBuyer(address sniper);
453 
454     event SwapAndLiquify(
455         uint256 tokensSwapped,
456         uint256 ethReceived,
457         uint256 tokensIntoLiquidity
458     );
459 
460     event TransferForeignToken(address token, uint256 amount);
461 
462     constructor() ERC20("MEOW", "MEOW") {
463         address newOwner = msg.sender; // can leave alone if owner is deployer.
464 
465         IDexRouter _dexRouter = IDexRouter(
466             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
467         );
468         dexRouter = _dexRouter;
469 
470         // create pair
471         lpPair = IDexFactory(_dexRouter.factory()).createPair(
472             address(this),
473             _dexRouter.WETH()
474         );
475         _excludeFromMaxTransaction(address(lpPair), true);
476         _setAutomatedMarketMakerPair(address(lpPair), true);
477 
478         uint256 totalSupply = 9_000_000_000 ether;
479 
480         maxBuyAmount = (totalSupply * 1) / 100;
481         maxSellAmount = (totalSupply * 1) / 100;
482         maxWalletAmount = (totalSupply * 1) / 100;
483         swapTokensAtAmount = (totalSupply * 1) / 1000;
484 
485         buyOperationsFee = 9;
486         buyLiquidityFee = 2;
487         buyDevFee = 9;
488         buyBurnFee = 0;
489         buyTotalFees =
490             buyOperationsFee +
491             buyLiquidityFee +
492             buyDevFee +
493             buyBurnFee;
494 
495         sellOperationsFee = 14;
496         sellLiquidityFee = 2;
497         sellDevFee = 14;
498         sellBurnFee = 0;
499         sellTotalFees =
500             sellOperationsFee +
501             sellLiquidityFee +
502             sellDevFee +
503             sellBurnFee;
504 
505         _excludeFromMaxTransaction(newOwner, true);
506         _excludeFromMaxTransaction(address(this), true);
507         _excludeFromMaxTransaction(address(0xdead), true);
508 
509         excludeFromFees(newOwner, true);
510         excludeFromFees(address(this), true);
511         excludeFromFees(address(0xdead), true);
512 
513         operationsAddress = address(0x2158A4575492B5625a528929ea0048Cf3227317f);
514         devAddress = address(newOwner);
515 
516         _createInitialSupply(newOwner, totalSupply);
517         transferOwnership(newOwner);
518     }
519 
520     receive() external payable {}
521 
522     // only enable if no plan to airdrop
523 
524     function enableTrading(uint256 deadBlocks) external onlyOwner {
525         require(!tradingActive, "Cannot reenable trading");
526         tradingActive = true;
527         swapEnabled = true;
528         tradingActiveBlock = block.number;
529         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
530         emit EnabledTrading();
531     }
532 
533     function setSwapEnabled(bool isEnabled) external onlyOwner {
534         swapEnabled = isEnabled;
535     }
536 
537     function blacklistBot(address bot, bool isBot) external onlyOwner {
538         _holderIsBot[bot] = isBot;
539     }
540 
541     // remove limits after token is stable
542     function removeLimits() external onlyOwner {
543         limitsInEffect = false;
544         transferDelayEnabled = false;
545         emit RemovedLimits();
546     }
547 
548     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
549         boughtEarly[wallet] = flag;
550     }
551 
552     function massManageBoughtEarly(address[] calldata wallets, bool flag)
553         external
554         onlyOwner
555     {
556         for (uint256 i = 0; i < wallets.length; i++) {
557             boughtEarly[wallets[i]] = flag;
558         }
559     }
560 
561     // disable Transfer delay - cannot be reenabled
562     function disableTransferDelay() external onlyOwner {
563         transferDelayEnabled = false;
564     }
565 
566     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
567         require(
568             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
569             "Cannot set max buy amount lower than 0.2%"
570         );
571         maxBuyAmount = newNum * (10**18);
572         emit UpdatedMaxBuyAmount(maxBuyAmount);
573     }
574 
575     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
576         require(
577             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
578             "Cannot set max sell amount lower than 0.2%"
579         );
580         maxSellAmount = newNum * (10**18);
581         emit UpdatedMaxSellAmount(maxSellAmount);
582     }
583 
584     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
585         require(
586             newNum >= ((totalSupply() * 3) / 1000) / 1e18,
587             "Cannot set max wallet amount lower than 0.3%"
588         );
589         maxWalletAmount = newNum * (10**18);
590         emit UpdatedMaxWalletAmount(maxWalletAmount);
591     }
592 
593     // change the minimum amount of tokens to sell from fees
594     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
595         require(
596             newAmount >= (totalSupply() * 1) / 100000,
597             "Swap amount cannot be lower than 0.001% total supply."
598         );
599         require(
600             newAmount <= (totalSupply() * 1) / 1000,
601             "Swap amount cannot be higher than 0.1% total supply."
602         );
603         swapTokensAtAmount = newAmount;
604     }
605 
606     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
607         private
608     {
609         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
610         emit MaxTransactionExclusion(updAds, isExcluded);
611     }
612 
613     function excludeFromMaxTransaction(address updAds, bool isEx)
614         external
615         onlyOwner
616     {
617         if (!isEx) {
618             require(
619                 updAds != lpPair,
620                 "Cannot remove uniswap pair from max txn"
621             );
622         }
623         _isExcludedMaxTransactionAmount[updAds] = isEx;
624     }
625 
626     function setAutomatedMarketMakerPair(address pair, bool value)
627         external
628         onlyOwner
629     {
630         require(
631             pair != lpPair,
632             "The pair cannot be removed from automatedMarketMakerPairs"
633         );
634 
635         _setAutomatedMarketMakerPair(pair, value);
636         emit SetAutomatedMarketMakerPair(pair, value);
637     }
638 
639     function _setAutomatedMarketMakerPair(address pair, bool value) private {
640         automatedMarketMakerPairs[pair] = value;
641 
642         _excludeFromMaxTransaction(pair, value);
643 
644         emit SetAutomatedMarketMakerPair(pair, value);
645     }
646 
647     function updateBuyFees(
648         uint256 _operationsFee,
649         uint256 _liquidityFee,
650         uint256 _devFee,
651         uint256 _burnFee
652     ) external onlyOwner {
653         buyOperationsFee = _operationsFee;
654         buyLiquidityFee = _liquidityFee;
655         buyDevFee = _devFee;
656         buyBurnFee = _burnFee;
657         buyTotalFees =
658             buyOperationsFee +
659             buyLiquidityFee +
660             buyDevFee +
661             buyBurnFee;
662         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
663     }
664 
665     function updateSellFees(
666         uint256 _operationsFee,
667         uint256 _liquidityFee,
668         uint256 _devFee,
669         uint256 _burnFee
670     ) external onlyOwner {
671         sellOperationsFee = _operationsFee;
672         sellLiquidityFee = _liquidityFee;
673         sellDevFee = _devFee;
674         sellBurnFee = _burnFee;
675         sellTotalFees =
676             sellOperationsFee +
677             sellLiquidityFee +
678             sellDevFee +
679             sellBurnFee;
680         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
681     }
682 
683     function returnToNormalTax() external onlyOwner {
684         sellOperationsFee = 3;
685         sellLiquidityFee = 0;
686         sellDevFee = 0;
687         sellBurnFee = 0;
688         sellTotalFees =
689             sellOperationsFee +
690             sellLiquidityFee +
691             sellDevFee +
692             sellBurnFee;
693         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
694 
695         buyOperationsFee = 3;
696         buyLiquidityFee = 0;
697         buyDevFee = 0;
698         buyBurnFee = 0;
699         buyTotalFees =
700             buyOperationsFee +
701             buyLiquidityFee +
702             buyDevFee +
703             buyBurnFee;
704         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
705     }
706 
707     function excludeFromFees(address account, bool excluded) public onlyOwner {
708         _isExcludedFromFees[account] = excluded;
709         emit ExcludeFromFees(account, excluded);
710     }
711 
712     function _transfer(
713         address from,
714         address to,
715         uint256 amount
716     ) internal override {
717         require(from != address(0), "ERC20: transfer from the zero address");
718         require(to != address(0), "ERC20: transfer to the zero address");
719         require(amount > 0, "amount must be greater than 0");
720 
721         require(
722             !_holderIsBot[from] && !_holderIsBot[to],
723             "must not be flagged as bot"
724         );
725 
726         if (!tradingActive) {
727             require(
728                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
729                 "Trading is not active."
730             );
731         }
732 
733         if (blockForPenaltyEnd > 0) {
734             require(
735                 !boughtEarly[from] || to == owner() || to == address(0xdead),
736                 "Bots cannot transfer tokens in or out except to owner or dead address."
737             );
738         }
739 
740         if (limitsInEffect) {
741             if (
742                 from != owner() &&
743                 to != owner() &&
744                 to != address(0) &&
745                 to != address(0xdead) &&
746                 !_isExcludedFromFees[from] &&
747                 !_isExcludedFromFees[to]
748             ) {
749                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
750                 if (transferDelayEnabled) {
751                     if (to != address(dexRouter) && to != address(lpPair)) {
752                         require(
753                             _holderLastTransferTimestamp[tx.origin] <
754                                 block.number - 2 &&
755                                 _holderLastTransferTimestamp[to] <
756                                 block.number - 2,
757                             "_transfer:: Transfer Delay enabled.  Try again later."
758                         );
759                         _holderLastTransferTimestamp[tx.origin] = block.number;
760                         _holderLastTransferTimestamp[to] = block.number;
761                     }
762                 }
763 
764                 //when buy
765                 if (
766                     automatedMarketMakerPairs[from] &&
767                     !_isExcludedMaxTransactionAmount[to]
768                 ) {
769                     require(
770                         amount <= maxBuyAmount,
771                         "Buy transfer amount exceeds the max buy."
772                     );
773                     require(
774                         amount + balanceOf(to) <= maxWalletAmount,
775                         "Cannot Exceed max wallet"
776                     );
777                 }
778                 //when sell
779                 else if (
780                     automatedMarketMakerPairs[to] &&
781                     !_isExcludedMaxTransactionAmount[from]
782                 ) {
783                     require(
784                         amount <= maxSellAmount,
785                         "Sell transfer amount exceeds the max sell."
786                     );
787                 } else if (!_isExcludedMaxTransactionAmount[to]) {
788                     require(
789                         amount + balanceOf(to) <= maxWalletAmount,
790                         "Cannot Exceed max wallet"
791                     );
792                 }
793             }
794         }
795 
796         uint256 contractTokenBalance = balanceOf(address(this));
797 
798         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
799 
800         if (
801             canSwap &&
802             swapEnabled &&
803             !swapping &&
804             !automatedMarketMakerPairs[from] &&
805             !_isExcludedFromFees[from] &&
806             !_isExcludedFromFees[to]
807         ) {
808             swapping = true;
809 
810             swapBack();
811 
812             swapping = false;
813         }
814 
815         bool takeFee = true;
816         // if any account belongs to _isExcludedFromFee account then remove the fee
817         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
818             takeFee = false;
819         }
820 
821         uint256 fees = 0;
822         // only take fees on buys/sells, do not take on wallet transfers
823         if (takeFee) {
824             // bot/sniper penalty.
825             if (
826                 earlyBuyPenaltyInEffect() &&
827                 automatedMarketMakerPairs[from] &&
828                 !automatedMarketMakerPairs[to] &&
829                 buyTotalFees > 0
830             ) {
831                 if (!boughtEarly[to]) {
832                     boughtEarly[to] = true;
833                     botsCaught += 1;
834                     emit CaughtEarlyBuyer(to);
835                 }
836 
837                 fees = (amount * 99) / 100;
838                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
839                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
840                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
841                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
842             }
843             // on sell
844             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
845                 fees = (amount * sellTotalFees) / 100;
846                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
847                 tokensForOperations +=
848                     (fees * sellOperationsFee) /
849                     sellTotalFees;
850                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
851                 tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
852             }
853             // on buy
854             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
855                 fees = (amount * buyTotalFees) / 100;
856                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
857                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
858                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
859                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
860             }
861 
862             if (fees > 0) {
863                 super._transfer(from, address(this), fees);
864             }
865 
866             amount -= fees;
867         }
868 
869         super._transfer(from, to, amount);
870     }
871 
872     function earlyBuyPenaltyInEffect() public view returns (bool) {
873         return block.number < blockForPenaltyEnd;
874     }
875 
876     function swapTokensForEth(uint256 tokenAmount) private {
877         // generate the uniswap pair path of token -> weth
878         address[] memory path = new address[](2);
879         path[0] = address(this);
880         path[1] = dexRouter.WETH();
881 
882         _approve(address(this), address(dexRouter), tokenAmount);
883 
884         // make the swap
885         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
886             tokenAmount,
887             0, // accept any amount of ETH
888             path,
889             address(this),
890             block.timestamp
891         );
892     }
893 
894     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
895         // approve token transfer to cover all possible scenarios
896         _approve(address(this), address(dexRouter), tokenAmount);
897 
898         // add the liquidity
899         dexRouter.addLiquidityETH{value: ethAmount}(
900             address(this),
901             tokenAmount,
902             0, // slippage is unavoidable
903             0, // slippage is unavoidable
904             address(0xdead),
905             block.timestamp
906         );
907     }
908 
909     function swapBack() private {
910         if (tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
911             _burn(address(this), tokensForBurn);
912         }
913         tokensForBurn = 0;
914 
915         uint256 contractBalance = balanceOf(address(this));
916         uint256 totalTokensToSwap = tokensForLiquidity +
917             tokensForOperations +
918             tokensForDev;
919 
920         if (contractBalance == 0 || totalTokensToSwap == 0) {
921             return;
922         }
923 
924         if (contractBalance > swapTokensAtAmount * 20) {
925             contractBalance = swapTokensAtAmount * 20;
926         }
927 
928         bool success;
929 
930         // Halve the amount of liquidity tokens
931         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
932             totalTokensToSwap /
933             2;
934 
935         swapTokensForEth(contractBalance - liquidityTokens);
936 
937         uint256 ethBalance = address(this).balance;
938         uint256 ethForLiquidity = ethBalance;
939 
940         uint256 ethForOperations = (ethBalance * tokensForOperations) /
941             (totalTokensToSwap - (tokensForLiquidity / 2));
942         uint256 ethForDev = (ethBalance * tokensForDev) /
943             (totalTokensToSwap - (tokensForLiquidity / 2));
944 
945         ethForLiquidity -= ethForOperations + ethForDev;
946 
947         tokensForLiquidity = 0;
948         tokensForOperations = 0;
949         tokensForDev = 0;
950         tokensForBurn = 0;
951 
952         if (liquidityTokens > 0 && ethForLiquidity > 0) {
953             addLiquidity(liquidityTokens, ethForLiquidity);
954         }
955 
956         (success, ) = address(devAddress).call{value: ethForDev}("");
957 
958         (success, ) = address(operationsAddress).call{
959             value: address(this).balance
960         }("");
961     }
962 
963     function transferForeignToken(address _token, address _to)
964         external
965         onlyOwner
966         returns (bool _sent)
967     {
968         require(_token != address(0), "_token address cannot be 0");
969         require(_token != address(this), "Can't withdraw native tokens");
970         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
971         _sent = IERC20(_token).transfer(_to, _contractBalance);
972         emit TransferForeignToken(_token, _contractBalance);
973     }
974 
975     // withdraw ETH from contract address
976     function withdrawStuckETH() external onlyOwner {
977         bool success;
978         (success, ) = address(msg.sender).call{value: address(this).balance}(
979             ""
980         );
981     }
982 
983     function setOperationsAddress(address _operationsAddress)
984         external
985         onlyOwner
986     {
987         require(
988             _operationsAddress != address(0),
989             "_operationsAddress address cannot be 0"
990         );
991         operationsAddress = payable(_operationsAddress);
992     }
993 
994     function setDevAddress(address _devAddress) external onlyOwner {
995         require(_devAddress != address(0), "_devAddress address cannot be 0");
996         devAddress = payable(_devAddress);
997     }
998 
999     // force Swap back if slippage issues.
1000     function forceSwapBack() external onlyOwner {
1001         require(
1002             balanceOf(address(this)) >= swapTokensAtAmount,
1003             "Can only swap when token amount is at or higher than restriction"
1004         );
1005         swapping = true;
1006         swapBack();
1007         swapping = false;
1008         emit OwnerForcedSwapBack(block.timestamp);
1009     }
1010 
1011     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
1012     function buyBackTokens(uint256 amountInWei) external onlyOwner {
1013         require(
1014             amountInWei <= 10 ether,
1015             "May not buy more than 10 ETH in a single buy to reduce sandwich attacks"
1016         );
1017 
1018         address[] memory path = new address[](2);
1019         path[0] = dexRouter.WETH();
1020         path[1] = address(this);
1021 
1022         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{
1023             value: amountInWei
1024         }(
1025             0, // accept any amount of Ethereum
1026             path,
1027             address(0xdead),
1028             block.timestamp
1029         );
1030         emit BuyBackTriggered(amountInWei);
1031     }
1032 }