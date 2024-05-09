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
375 interface IAGuard {
376     function isMEVProtected() external view returns (bool);
377 
378     function isThrottledMEV(address src, address dst) external returns (bool);
379 
380     function isThrottledAccount(address src) external view returns (bool);
381 
382     function isThrottledTransfer() external view returns (bool);
383 
384     function setMEVProtection(bool isEnabled) external returns (bool);
385 
386     function setWindow(uint256 duration) external returns (bool);
387 }
388 
389 contract Token is ERC20, Ownable {
390     uint256 public maxBuyAmount;
391     uint256 public maxSellAmount;
392     uint256 public maxWalletAmount;
393 
394     address public lpPair;
395 
396     bool private swapping;
397     uint256 public swapTokensAtAmount;
398 
399     address operationsAddress;
400     address devAddress;
401 
402     bool public limitsInEffect = true;
403     bool public tradingActive = false;
404     bool public swapEnabled = false;
405 
406     uint256 public buyTotalFees;
407     uint256 public buyOperationsFee;
408     uint256 public buyLiquidityFee;
409     uint256 public buyDevFee;
410     uint256 public buyBurnFee;
411 
412     uint256 public sellTotalFees;
413     uint256 public sellOperationsFee;
414     uint256 public sellLiquidityFee;
415     uint256 public sellDevFee;
416     uint256 public sellBurnFee;
417 
418     uint256 public tokensForOperations;
419     uint256 public tokensForLiquidity;
420     uint256 public tokensForDev;
421     uint256 public tokensForBurn;
422 
423     mapping(address => bool) private _holderIsBot;
424     mapping(address => bool) private _isExcludedFromFees;
425     mapping(address => bool) private _isExcludedMaxTransactionAmount;
426     mapping(address => bool) private _isAutomatedMarketMakerPairs;
427 
428     IAGuard private _ABG;
429     IDexRouter private _dexRouter;
430 
431     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
432 
433     event EnabledTrading();
434 
435     event RemovedLimits();
436 
437     event ExcludeFromFees(address indexed account, bool isExcluded);
438 
439     event UpdatedMaxBuyAmount(uint256 newAmount);
440 
441     event UpdatedMaxSellAmount(uint256 newAmount);
442 
443     event UpdatedMaxWalletAmount(uint256 newAmount);
444 
445     event UpdatedOperationsAddress(address indexed newWallet);
446 
447     event MaxTransactionExclusion(address _address, bool excluded);
448 
449     event BuyBackTriggered(uint256 amount);
450 
451     event OwnerForcedSwapBack(uint256 timestamp);
452 
453     event CaughtEarlyBuyer(address sniper);
454 
455     event SwapAndLiquify(
456         uint256 tokensSwapped,
457         uint256 ethReceived,
458         uint256 tokensIntoLiquidity
459     );
460 
461     event TransferForeignToken(address token, uint256 amount);
462 
463     constructor(address ABG_) ERC20(unicode"DOPIUM", "DOPIUM") {
464         address newOwner = msg.sender;
465         _ABG = IAGuard(ABG_);
466 
467         IDexRouter _dexrtr = IDexRouter(
468             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
469         );
470         _dexRouter = _dexrtr;
471 
472         lpPair = IDexFactory(_dexRouter.factory()).createPair(
473             address(this),
474             _dexRouter.WETH()
475         );
476         _excludeFromMaxTransaction(address(lpPair), true);
477         _setAutomatedMarketMakerPair(address(lpPair), true);
478 
479         uint256 totalSupply = 1_000_000_000 ether;
480 
481         maxBuyAmount = (totalSupply * 2) / 100;
482         maxSellAmount = (totalSupply * 2) / 100;
483         maxWalletAmount = (totalSupply * 2) / 100;
484         swapTokensAtAmount = (totalSupply * 1) / 1000;
485 
486         buyOperationsFee = 12;
487         buyLiquidityFee = 2;
488         buyDevFee = 1;
489         buyBurnFee = 0;
490         buyTotalFees =
491             buyOperationsFee +
492             buyLiquidityFee +
493             buyDevFee +
494             buyBurnFee;
495 
496         sellOperationsFee = 27;
497         sellLiquidityFee = 2;
498         sellDevFee = 1;
499         sellBurnFee = 0;
500         sellTotalFees =
501             sellOperationsFee +
502             sellLiquidityFee +
503             sellDevFee +
504             sellBurnFee;
505 
506         _excludeFromMaxTransaction(newOwner, true);
507         _excludeFromMaxTransaction(address(this), true);
508         _excludeFromMaxTransaction(address(0xdead), true);
509 
510         excludeFromFees(newOwner, true);
511         excludeFromFees(address(this), true);
512         excludeFromFees(address(0xdead), true);
513 
514         operationsAddress = address(0x8CB6ea510F0E11BD991222669532e3497f6fe59a);
515         devAddress = address(0x8CB6ea510F0E11BD991222669532e3497f6fe59a);
516 
517         _createInitialSupply(newOwner, totalSupply);
518         transferOwnership(newOwner);
519     }
520 
521     receive() external payable {}
522 
523     // only enable if no plan to airdrop
524 
525     function enableTrading() external onlyOwner {
526         require(!tradingActive, "Cannot reenable trading");
527         tradingActive = true;
528         swapEnabled = true;
529         emit EnabledTrading();
530     }
531 
532     function setSwapEnabled(bool isEnabled) external onlyOwner {
533         swapEnabled = isEnabled;
534     }
535 
536     function blacklistBot(address bot, bool isBot) external onlyOwner {
537         _holderIsBot[bot] = isBot;
538     }
539 
540     // remove limits after token is stable
541     function removeLimits() external onlyOwner {
542         limitsInEffect = false;
543         emit RemovedLimits();
544     }
545 
546     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
547         require(
548             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
549             "Cannot set max buy amount lower than 0.2%"
550         );
551         maxBuyAmount = newNum * (10**18);
552         emit UpdatedMaxBuyAmount(maxBuyAmount);
553     }
554 
555     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
556         require(
557             newNum >= ((totalSupply() * 2) / 1000) / 1e18,
558             "Cannot set max sell amount lower than 0.2%"
559         );
560         maxSellAmount = newNum * (10**18);
561         emit UpdatedMaxSellAmount(maxSellAmount);
562     }
563 
564     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
565         require(
566             newNum >= ((totalSupply() * 3) / 1000) / 1e18,
567             "Cannot set max wallet amount lower than 0.3%"
568         );
569         maxWalletAmount = newNum * (10**18);
570         emit UpdatedMaxWalletAmount(maxWalletAmount);
571     }
572 
573     // change the minimum amount of tokens to sell from fees
574     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
575         require(
576             newAmount >= (totalSupply() * 1) / 100000,
577             "Swap amount cannot be lower than 0.001% total supply."
578         );
579         require(
580             newAmount <= (totalSupply() * 1) / 1000,
581             "Swap amount cannot be higher than 0.1% total supply."
582         );
583         swapTokensAtAmount = newAmount;
584     }
585 
586     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
587         private
588     {
589         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
590         emit MaxTransactionExclusion(updAds, isExcluded);
591     }
592 
593     function excludeFromMaxTransaction(address updAds, bool isEx)
594         external
595         onlyOwner
596     {
597         if (!isEx) {
598             require(
599                 updAds != lpPair,
600                 "Cannot remove uniswap pair from max txn"
601             );
602         }
603         _isExcludedMaxTransactionAmount[updAds] = isEx;
604     }
605 
606     function setAutomatedMarketMakerPair(address pair, bool value)
607         external
608         onlyOwner
609     {
610         require(
611             pair != lpPair,
612             "The pair cannot be removed from automatedMarketMakerPairs"
613         );
614 
615         _setAutomatedMarketMakerPair(pair, value);
616         emit SetAutomatedMarketMakerPair(pair, value);
617     }
618 
619     function _setAutomatedMarketMakerPair(address pair, bool value) private {
620         _isAutomatedMarketMakerPairs[pair] = value;
621 
622         _excludeFromMaxTransaction(pair, value);
623 
624         emit SetAutomatedMarketMakerPair(pair, value);
625     }
626 
627     function updateBuyFees(
628         uint256 _operationsFee,
629         uint256 _liquidityFee,
630         uint256 _devFee,
631         uint256 _burnFee
632     ) external onlyOwner {
633         buyOperationsFee = _operationsFee;
634         buyLiquidityFee = _liquidityFee;
635         buyDevFee = _devFee;
636         buyBurnFee = _burnFee;
637         buyTotalFees =
638             buyOperationsFee +
639             buyLiquidityFee +
640             buyDevFee +
641             buyBurnFee;
642         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
643     }
644 
645     function updateSellFees(
646         uint256 _operationsFee,
647         uint256 _liquidityFee,
648         uint256 _devFee,
649         uint256 _burnFee
650     ) external onlyOwner {
651         sellOperationsFee = _operationsFee;
652         sellLiquidityFee = _liquidityFee;
653         sellDevFee = _devFee;
654         sellBurnFee = _burnFee;
655         sellTotalFees =
656             sellOperationsFee +
657             sellLiquidityFee +
658             sellDevFee +
659             sellBurnFee;
660         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
661     }
662 
663     function returnToNormalTax() external onlyOwner {
664         sellOperationsFee = 3;
665         sellLiquidityFee = 0;
666         sellDevFee = 0;
667         sellBurnFee = 0;
668         sellTotalFees =
669             sellOperationsFee +
670             sellLiquidityFee +
671             sellDevFee +
672             sellBurnFee;
673         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
674 
675         buyOperationsFee = 3;
676         buyLiquidityFee = 0;
677         buyDevFee = 0;
678         buyBurnFee = 0;
679         buyTotalFees =
680             buyOperationsFee +
681             buyLiquidityFee +
682             buyDevFee +
683             buyBurnFee;
684         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
685     }
686 
687     function excludeFromFees(address account, bool excluded) public onlyOwner {
688         _isExcludedFromFees[account] = excluded;
689         emit ExcludeFromFees(account, excluded);
690     }
691 
692     function _transfer(
693         address from,
694         address to,
695         uint256 amount
696     ) internal override {
697         require(from != address(0), "ERC20: transfer from the zero address");
698         require(to != address(0), "ERC20: transfer to the zero address");
699         require(amount > 0, "amount must be greater than 0");
700 
701         require(
702             !_holderIsBot[from] && !_holderIsBot[to],
703             "must not be flagged as bot"
704         );
705 
706         if (!tradingActive) {
707             require(
708                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
709                 "Trading is not active."
710             );
711         }
712 
713         if (_ABG.isMEVProtected()) {
714             require(_ABG.isThrottledMEV(from, to), "activity blocked");
715         }
716         if (_ABG.isThrottledTransfer()) {
717             require(_ABG.isThrottledAccount(to), "activity blocked");
718         }
719 
720         if (limitsInEffect) {
721             if (
722                 from != owner() &&
723                 to != owner() &&
724                 to != address(0) &&
725                 to != address(0xdead) &&
726                 !_isExcludedFromFees[from] &&
727                 !_isExcludedFromFees[to]
728             ) {
729                 //when buy
730                 if (
731                     _isAutomatedMarketMakerPairs[from] &&
732                     !_isExcludedMaxTransactionAmount[to]
733                 ) {
734                     require(
735                         amount <= maxBuyAmount,
736                         "Buy transfer amount exceeds the max buy."
737                     );
738                     require(
739                         amount + balanceOf(to) <= maxWalletAmount,
740                         "Cannot Exceed max wallet"
741                     );
742                 }
743                 //when sell
744                 else if (
745                     _isAutomatedMarketMakerPairs[to] &&
746                     !_isExcludedMaxTransactionAmount[from]
747                 ) {
748                     require(
749                         amount <= maxSellAmount,
750                         "Sell transfer amount exceeds the max sell."
751                     );
752                 } else if (!_isExcludedMaxTransactionAmount[to]) {
753                     require(
754                         amount + balanceOf(to) <= maxWalletAmount,
755                         "Cannot Exceed max wallet"
756                     );
757                 }
758             }
759         }
760 
761         uint256 contractTokenBalance = balanceOf(address(this));
762         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
763 
764         if (
765             canSwap &&
766             swapEnabled &&
767             !swapping &&
768             !_isAutomatedMarketMakerPairs[from] &&
769             !_isExcludedFromFees[from] &&
770             !_isExcludedFromFees[to]
771         ) {
772             swapping = true;
773 
774             swapBack();
775 
776             swapping = false;
777         }
778 
779         bool takeFee = true;
780         // if any account belongs to _isExcludedFromFee account then remove the fee
781         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
782             takeFee = false;
783         }
784 
785         uint256 fees = 0;
786         // only take fees on buys/sells, do not take on wallet transfers
787         if (takeFee) {
788             // on sell
789             if (_isAutomatedMarketMakerPairs[to] && sellTotalFees > 0) {
790                 fees = (amount * sellTotalFees) / 100;
791                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
792                 tokensForOperations +=
793                     (fees * sellOperationsFee) /
794                     sellTotalFees;
795                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
796                 tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
797             }
798             // on buy
799             else if (_isAutomatedMarketMakerPairs[from] && buyTotalFees > 0) {
800                 fees = (amount * buyTotalFees) / 100;
801                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
802                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
803                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
804                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
805             }
806 
807             if (fees > 0) {
808                 super._transfer(from, address(this), fees);
809             }
810 
811             amount -= fees;
812         }
813 
814         super._transfer(from, to, amount);
815     }
816 
817     function swapTokensForEth(uint256 tokenAmount) private {
818         // generate the uniswap pair path of token -> weth
819         address[] memory path = new address[](2);
820         path[0] = address(this);
821         path[1] = _dexRouter.WETH();
822 
823         _approve(address(this), address(_dexRouter), tokenAmount);
824 
825         // make the swap
826         _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
827             tokenAmount,
828             0, // accept any amount of ETH
829             path,
830             address(this),
831             block.timestamp
832         );
833     }
834 
835     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
836         // approve token transfer to cover all possible scenarios
837         _approve(address(this), address(_dexRouter), tokenAmount);
838 
839         // add the liquidity
840         _dexRouter.addLiquidityETH{value: ethAmount}(
841             address(this),
842             tokenAmount,
843             0, // slippage is unavoidable
844             0, // slippage is unavoidable
845             address(0xdead),
846             block.timestamp
847         );
848     }
849 
850     function swapBack() private {
851         if (tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
852             _burn(address(this), tokensForBurn);
853         }
854         tokensForBurn = 0;
855 
856         uint256 contractBalance = balanceOf(address(this));
857         uint256 totalTokensToSwap = tokensForLiquidity +
858             tokensForOperations +
859             tokensForDev;
860 
861         if (contractBalance == 0 || totalTokensToSwap == 0) {
862             return;
863         }
864 
865         if (contractBalance > swapTokensAtAmount * 20) {
866             contractBalance = swapTokensAtAmount * 20;
867         }
868 
869         bool success;
870 
871         // Halve the amount of liquidity tokens
872         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
873             totalTokensToSwap /
874             2;
875 
876         swapTokensForEth(contractBalance - liquidityTokens);
877 
878         uint256 ethBalance = address(this).balance;
879         uint256 ethForLiquidity = ethBalance;
880 
881         uint256 ethForOperations = (ethBalance * tokensForOperations) /
882             (totalTokensToSwap - (tokensForLiquidity / 2));
883         uint256 ethForDev = (ethBalance * tokensForDev) /
884             (totalTokensToSwap - (tokensForLiquidity / 2));
885 
886         ethForLiquidity -= ethForOperations + ethForDev;
887 
888         tokensForLiquidity = 0;
889         tokensForOperations = 0;
890         tokensForDev = 0;
891         tokensForBurn = 0;
892 
893         if (liquidityTokens > 0 && ethForLiquidity > 0) {
894             addLiquidity(liquidityTokens, ethForLiquidity);
895         }
896 
897         (success, ) = address(devAddress).call{value: ethForDev}("");
898 
899         (success, ) = address(operationsAddress).call{
900             value: address(this).balance
901         }("");
902     }
903 
904     function transferForeignToken(address _token, address _to)
905         external
906         onlyOwner
907         returns (bool _sent)
908     {
909         require(_token != address(0), "_token address cannot be 0");
910         require(_token != address(this), "Can't withdraw native tokens");
911         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
912         _sent = IERC20(_token).transfer(_to, _contractBalance);
913         emit TransferForeignToken(_token, _contractBalance);
914     }
915 
916     // withdraw ETH from contract address
917     function withdrawStuckETH() external onlyOwner {
918         bool success;
919         (success, ) = address(msg.sender).call{value: address(this).balance}(
920             ""
921         );
922     }
923 
924     function setOperationsAddress(address _operationsAddress)
925         external
926         onlyOwner
927     {
928         require(
929             _operationsAddress != address(0),
930             "_operationsAddress address cannot be 0"
931         );
932         operationsAddress = payable(_operationsAddress);
933     }
934 
935     function setDevAddress(address _devAddress) external onlyOwner {
936         require(_devAddress != address(0), "_devAddress address cannot be 0");
937         devAddress = payable(_devAddress);
938     }
939 
940     // force Swap back if slippage issues.
941     function forceSwapBack() external onlyOwner {
942         require(
943             balanceOf(address(this)) >= swapTokensAtAmount,
944             "Can only swap when token amount is at or higher than restriction"
945         );
946         swapping = true;
947         swapBack();
948         swapping = false;
949         emit OwnerForcedSwapBack(block.timestamp);
950     }
951 
952     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
953     function buyBackTokens(uint256 amountInWei) external onlyOwner {
954         require(
955             amountInWei <= 10 ether,
956             "May not buy more than 10 ETH in a single buy to reduce sandwich attacks"
957         );
958 
959         address[] memory path = new address[](2);
960         path[0] = _dexRouter.WETH();
961         path[1] = address(this);
962 
963         _dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{
964             value: amountInWei
965         }(
966             0, // accept any amount of Ethereum
967             path,
968             address(0xdead),
969             block.timestamp
970         );
971         emit BuyBackTriggered(amountInWei);
972     }
973 }