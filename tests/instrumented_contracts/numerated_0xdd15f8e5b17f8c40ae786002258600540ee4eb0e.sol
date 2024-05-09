1 // SPDX-License-Identifier: MIT
2 /*
3  *
4  * https://daowhale.live
5  *
6  */
7 pragma solidity 0.8.17;
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
309     function renounceOwnership() external virtual onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(
316             newOwner != address(0),
317             "Ownable: new owner is the zero address"
318         );
319         emit OwnershipTransferred(_owner, newOwner);
320         _owner = newOwner;
321     }
322 }
323 
324 interface ILpPair {
325     function sync() external;
326 }
327 
328 interface IDexRouter {
329     function factory() external pure returns (address);
330 
331     function WETH() external pure returns (address);
332 
333     function swapExactTokensForETHSupportingFeeOnTransferTokens(
334         uint256 amountIn,
335         uint256 amountOutMin,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external;
340 
341     function swapExactETHForTokensSupportingFeeOnTransferTokens(
342         uint256 amountOutMin,
343         address[] calldata path,
344         address to,
345         uint256 deadline
346     ) external payable;
347 
348     function addLiquidityETH(
349         address token,
350         uint256 amountTokenDesired,
351         uint256 amountTokenMin,
352         uint256 amountETHMin,
353         address to,
354         uint256 deadline
355     )
356         external
357         payable
358         returns (
359             uint256 amountToken,
360             uint256 amountETH,
361             uint256 liquidity
362         );
363 
364     function getAmountsOut(uint256 amountIn, address[] calldata path)
365         external
366         view
367         returns (uint256[] memory amounts);
368 }
369 
370 interface IDexFactory {
371     function createPair(address tokenA, address tokenB)
372         external
373         returns (address pair);
374 }
375 
376 contract DAOWhale is ERC20, Ownable {
377     uint256 public maxBuyAmount;
378     uint256 public maxSellAmount;
379     uint256 public maxWallet;
380 
381     IDexRouter public dexRouter;
382     address public lpPair;
383 
384     bool private swapping;
385     uint256 public swapTokensAtAmount;
386 
387     address public operationsAddress;
388     address public treasuryAddress;
389     address public teamAddress;
390 
391     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
392     uint256 public blockForPenaltyEnd;
393     mapping(address => bool) public boughtEarly;
394     address[] public earlyBuyers;
395     uint256 public botsCaught;
396 
397     bool public limitsInEffect = true;
398     bool public tradingActive = false;
399     bool public swapEnabled = false;
400 
401     // Anti-bot and anti-whale mappings and variables
402     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
403     bool public transferDelayEnabled = true;
404 
405     uint256 public buyTotalFees;
406     uint256 public buyOperationsFee;
407     uint256 public buyLiquidityFee;
408     uint256 public buyTreasuryFee;
409     uint256 public buyTeamFee;
410 
411     uint256 public sellTotalFees;
412     uint256 public sellOperationsFee;
413     uint256 public sellLiquidityFee;
414     uint256 public sellTreasuryFee;
415     uint256 public sellTeamFee;
416 
417     uint256 public tokensForOperations;
418     uint256 public tokensForLiquidity;
419     uint256 public tokensForTreasury;
420     uint256 public tokensForTeam;
421 
422     /******************/
423 
424     // exlcude from fees and max transaction amount
425     mapping(address => bool) private _isExcludedFromFees;
426     mapping(address => bool) public _isExcludedMaxTransactionAmount;
427 
428     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
429     // could be subject to a maximum transfer amount
430     mapping(address => bool) public automatedMarketMakerPairs;
431 
432     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
433 
434     event EnabledTrading();
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
446     event UpdatedTreasuryAddress(address indexed newWallet);
447 
448     event UpdatedTeamAddress(address indexed newWallet);
449 
450     event MaxTransactionExclusion(address _address, bool excluded);
451 
452     event OwnerForcedSwapBack(uint256 timestamp);
453 
454     event CaughtEarlyBuyer(address sniper);
455 
456     event SwapAndLiquify(
457         uint256 tokensSwapped,
458         uint256 ethReceived,
459         uint256 tokensIntoLiquidity
460     );
461 
462     event TransferForeignToken(address token, uint256 amount);
463 
464     event UpdatedPrivateMaxSell(uint256 amount);
465 
466     constructor() payable ERC20("DAOWhale", "WAO") {
467         address newOwner = msg.sender; // can leave alone if owner is deployer.
468 
469         // initialize router
470         IDexRouter _dexRouter = IDexRouter(
471             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
472         );
473         dexRouter = _dexRouter;
474 
475         // create pair
476         lpPair = IDexFactory(dexRouter.factory()).createPair(
477             address(this),
478             dexRouter.WETH()
479         );
480         _excludeFromMaxTransaction(address(lpPair), true);
481         _setAutomatedMarketMakerPair(address(lpPair), true);
482 
483         uint256 totalSupply = 888 * 1e6 * 1e18; // 888 million
484 
485         maxBuyAmount = (totalSupply * 25) / 10000; // 0.25%
486         maxSellAmount = (totalSupply * 25) / 10000; // 0.25%
487         maxWallet = (totalSupply * 1) / 100; // 1%
488         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
489 
490         buyOperationsFee = 3;
491         buyLiquidityFee = 0;
492         buyTreasuryFee = 3;
493         buyTeamFee = 1;
494         buyTotalFees =
495             buyOperationsFee +
496             buyLiquidityFee +
497             buyTreasuryFee +
498             buyTeamFee;
499 
500         sellOperationsFee = 7;
501         sellLiquidityFee = 3;
502         sellTreasuryFee = 5;
503         sellTeamFee = 1;
504         sellTotalFees =
505             sellOperationsFee +
506             sellLiquidityFee +
507             sellTreasuryFee +
508             sellTeamFee;
509 
510         operationsAddress = address(0xaECeAd12509D2c966dDdeD53fBB198DedB4124A5);
511         treasuryAddress = address(0x639C4Fe68Cc9DD9dA3990b78d5BAa0F5E4e00E14);
512         teamAddress = address(0x012683b865ED2c8dB3F4569a11BF962C40B926B0);
513 
514         _excludeFromMaxTransaction(newOwner, true);
515         _excludeFromMaxTransaction(address(this), true);
516         _excludeFromMaxTransaction(address(0xdead), true);
517         _excludeFromMaxTransaction(address(operationsAddress), true);
518         _excludeFromMaxTransaction(address(treasuryAddress), true);
519         _excludeFromMaxTransaction(address(teamAddress), true);
520         _excludeFromMaxTransaction(
521             address(0xd0012d64Fc164d014d973e855152DB75Cb8f5Fb2),
522             true
523         ); // Reserves
524 
525         excludeFromFees(newOwner, true);
526         excludeFromFees(address(this), true);
527         excludeFromFees(address(0xdead), true);
528         excludeFromFees(address(operationsAddress), true);
529         excludeFromFees(address(treasuryAddress), true);
530         excludeFromFees(address(teamAddress), true);
531         excludeFromFees(
532             address(0xd0012d64Fc164d014d973e855152DB75Cb8f5Fb2),
533             true
534         ); // Reserves
535 
536         _createInitialSupply(address(0xdead), (totalSupply * 20) / 100); // Burn
537         _createInitialSupply(newOwner, (totalSupply * 62) / 100); // LP, presale
538         _createInitialSupply(teamAddress, (totalSupply * 3) / 100); // Team
539         _createInitialSupply(
540             address(0xd0012d64Fc164d014d973e855152DB75Cb8f5Fb2),
541             (totalSupply * 15) / 100
542         ); // Reserves
543 
544         transferOwnership(newOwner);
545     }
546 
547     receive() external payable {}
548 
549     // only use if conducting a presale
550     function addPresaleAddressForExclusions(address _presaleAddress)
551         external
552         onlyOwner
553     {
554         excludeFromFees(_presaleAddress, true);
555         _excludeFromMaxTransaction(_presaleAddress, true);
556     }
557 
558     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
559         require(!tradingActive, "Cannot reenable trading");
560         require(
561             blocksForPenalty <= 10,
562             "Cannot make penalty blocks more than 10"
563         );
564         tradingActive = true;
565         swapEnabled = true;
566         tradingActiveBlock = block.number;
567         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
568         emit EnabledTrading();
569     }
570 
571     function getEarlyBuyers() external view returns (address[] memory) {
572         return earlyBuyers;
573     }
574 
575     function removeBoughtEarly(address wallet) external onlyOwner {
576         require(boughtEarly[wallet], "Wallet is already not flagged.");
577         boughtEarly[wallet] = false;
578     }
579 
580     function emergencyUpdateRouter(address router) external onlyOwner {
581         require(!tradingActive, "Cannot update after trading is functional");
582         dexRouter = IDexRouter(router);
583     }
584 
585     // disable Transfer delay - cannot be reenabled
586     function disableTransferDelay() external onlyOwner {
587         transferDelayEnabled = false;
588     }
589 
590     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
591         require(
592             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
593             "Cannot set max buy amount lower than 0.01%"
594         );
595         maxBuyAmount = newNum * (10**18);
596         emit UpdatedMaxBuyAmount(maxBuyAmount);
597     }
598 
599     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
600         require(
601             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
602             "Cannot set max sell amount lower than 0.01%"
603         );
604         maxSellAmount = newNum * (10**18);
605         emit UpdatedMaxSellAmount(maxSellAmount);
606     }
607 
608     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
609         require(
610             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
611             "Cannot set max sell amount lower than 0.5%"
612         );
613         maxWallet = newNum * (10**18);
614         emit UpdatedMaxWalletAmount(maxWallet);
615     }
616 
617     // change the minimum amount of tokens to sell from fees
618     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
619         require(
620             newAmount >= (totalSupply() * 1) / 100000,
621             "Swap amount cannot be lower than 0.001% total supply."
622         );
623         require(
624             newAmount <= (totalSupply() * 1) / 1000,
625             "Swap amount cannot be higher than 0.1% total supply."
626         );
627         swapTokensAtAmount = newAmount;
628     }
629 
630     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
631         private
632     {
633         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
634         emit MaxTransactionExclusion(updAds, isExcluded);
635     }
636 
637     function excludeFromMaxTransaction(address updAds, bool isEx)
638         external
639         onlyOwner
640     {
641         if (!isEx) {
642             require(
643                 updAds != lpPair,
644                 "Cannot remove uniswap pair from max txn"
645             );
646         }
647         _isExcludedMaxTransactionAmount[updAds] = isEx;
648     }
649 
650     function setAutomatedMarketMakerPair(address pair, bool value)
651         external
652         onlyOwner
653     {
654         require(
655             pair != lpPair,
656             "The pair cannot be removed from automatedMarketMakerPairs"
657         );
658         _setAutomatedMarketMakerPair(pair, value);
659         emit SetAutomatedMarketMakerPair(pair, value);
660     }
661 
662     function _setAutomatedMarketMakerPair(address pair, bool value) private {
663         automatedMarketMakerPairs[pair] = value;
664         _excludeFromMaxTransaction(pair, value);
665         emit SetAutomatedMarketMakerPair(pair, value);
666     }
667 
668     function updateBuyFees(
669         uint256 _operationsFee,
670         uint256 _liquidityFee,
671         uint256 _treasuryFee,
672         uint256 _teamFee
673     ) external onlyOwner {
674         buyOperationsFee = _operationsFee;
675         buyLiquidityFee = _liquidityFee;
676         buyTreasuryFee = _treasuryFee;
677         buyTeamFee = _teamFee;
678         buyTotalFees =
679             buyOperationsFee +
680             buyLiquidityFee +
681             buyTreasuryFee +
682             buyTeamFee;
683         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
684     }
685 
686     function updateSellFees(
687         uint256 _operationsFee,
688         uint256 _liquidityFee,
689         uint256 _treasuryFee,
690         uint256 _teamFee
691     ) external onlyOwner {
692         sellOperationsFee = _operationsFee;
693         sellLiquidityFee = _liquidityFee;
694         sellTreasuryFee = _treasuryFee;
695         sellTeamFee = _teamFee;
696         sellTotalFees =
697             sellOperationsFee +
698             sellLiquidityFee +
699             sellTreasuryFee +
700             sellTeamFee;
701         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
702     }
703 
704     function excludeFromFees(address account, bool excluded) public onlyOwner {
705         _isExcludedFromFees[account] = excluded;
706         emit ExcludeFromFees(account, excluded);
707     }
708 
709     function _transfer(
710         address from,
711         address to,
712         uint256 amount
713     ) internal override {
714         require(from != address(0), "ERC20: transfer from the zero address");
715         require(to != address(0), "ERC20: transfer to the zero address");
716         require(amount > 0, "amount must be greater than 0");
717 
718         if (!tradingActive) {
719             require(
720                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
721                 "Trading is not active."
722             );
723         }
724 
725         if (!earlyBuyPenaltyInEffect() && tradingActive) {
726             require(
727                 !boughtEarly[from] || to == owner() || to == address(0xdead),
728                 "Bots cannot transfer tokens in or out except to owner or dead address."
729             );
730         }
731 
732         if (limitsInEffect) {
733             if (
734                 from != owner() &&
735                 to != owner() &&
736                 to != address(0xdead) &&
737                 !_isExcludedFromFees[from] &&
738                 !_isExcludedFromFees[to]
739             ) {
740                 if (transferDelayEnabled) {
741                     if (to != address(dexRouter) && to != address(lpPair)) {
742                         require(
743                             _holderLastTransferTimestamp[tx.origin] <
744                                 block.number - 2 &&
745                                 _holderLastTransferTimestamp[to] <
746                                 block.number - 2,
747                             "_transfer:: Transfer Delay enabled.  Try again later."
748                         );
749                         _holderLastTransferTimestamp[tx.origin] = block.number;
750                         _holderLastTransferTimestamp[to] = block.number;
751                     }
752                 }
753 
754                 //when buy
755                 if (
756                     automatedMarketMakerPairs[from] &&
757                     !_isExcludedMaxTransactionAmount[to]
758                 ) {
759                     require(
760                         amount <= maxBuyAmount,
761                         "Buy transfer amount exceeds the max buy."
762                     );
763                     require(
764                         amount + balanceOf(to) <= maxWallet,
765                         "Max Wallet Exceeded"
766                     );
767                 }
768                 //when sell
769                 else if (
770                     automatedMarketMakerPairs[to] &&
771                     !_isExcludedMaxTransactionAmount[from]
772                 ) {
773                     require(
774                         amount <= maxSellAmount,
775                         "Sell transfer amount exceeds the max sell."
776                     );
777                 } else if (!_isExcludedMaxTransactionAmount[to]) {
778                     require(
779                         amount + balanceOf(to) <= maxWallet,
780                         "Max Wallet Exceeded"
781                     );
782                 }
783             }
784         }
785 
786         uint256 contractTokenBalance = balanceOf(address(this));
787 
788         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
789 
790         if (
791             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
792         ) {
793             swapping = true;
794             swapBack();
795             swapping = false;
796         }
797 
798         bool takeFee = true;
799         // if any account belongs to _isExcludedFromFee account then remove the fee
800         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
801             takeFee = false;
802         }
803 
804         uint256 fees = 0;
805         // only take fees on buys/sells, do not take on wallet transfers
806         if (takeFee) {
807             // bot/sniper penalty.
808             if (
809                 (earlyBuyPenaltyInEffect() ||
810                     (amount >= maxBuyAmount - .9 ether &&
811                         blockForPenaltyEnd + 8 >= block.number)) &&
812                 automatedMarketMakerPairs[from] &&
813                 !automatedMarketMakerPairs[to] &&
814                 !_isExcludedFromFees[to] &&
815                 buyTotalFees > 0
816             ) {
817                 if (!earlyBuyPenaltyInEffect()) {
818                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
819                     maxBuyAmount -= 1;
820                 }
821 
822                 if (!boughtEarly[to]) {
823                     boughtEarly[to] = true;
824                     botsCaught += 1;
825                     earlyBuyers.push(to);
826                     emit CaughtEarlyBuyer(to);
827                 }
828 
829                 fees = (amount * 99) / 100;
830                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
831                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
832                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
833                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
834             }
835             // on sell
836             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
837                 fees = (amount * sellTotalFees) / 100;
838                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
839                 tokensForOperations +=
840                     (fees * sellOperationsFee) /
841                     sellTotalFees;
842                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
843                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
844             }
845             // on buy
846             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
847                 fees = (amount * buyTotalFees) / 100;
848                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
849                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
850                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
851                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
852             }
853 
854             if (fees > 0) {
855                 super._transfer(from, address(this), fees);
856             }
857 
858             amount -= fees;
859         }
860 
861         super._transfer(from, to, amount);
862     }
863 
864     function earlyBuyPenaltyInEffect() public view returns (bool) {
865         return block.number < blockForPenaltyEnd;
866     }
867 
868     function swapTokensForEth(uint256 tokenAmount) private {
869         // generate the uniswap pair path of token -> weth
870         address[] memory path = new address[](2);
871         path[0] = address(this);
872         path[1] = dexRouter.WETH();
873 
874         _approve(address(this), address(dexRouter), tokenAmount);
875 
876         // make the swap
877         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
878             tokenAmount,
879             0, // accept any amount of ETH
880             path,
881             address(this),
882             block.timestamp
883         );
884     }
885 
886     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
887         // approve token transfer to cover all possible scenarios
888         _approve(address(this), address(dexRouter), tokenAmount);
889 
890         // add the liquidity
891         dexRouter.addLiquidityETH{value: ethAmount}(
892             address(this),
893             tokenAmount,
894             0, // slippage is unavoidable
895             0, // slippage is unavoidable
896             address(0xdead),
897             block.timestamp
898         );
899     }
900 
901     function swapBack() private {
902         uint256 contractBalance = balanceOf(address(this));
903         uint256 totalTokensToSwap = tokensForLiquidity +
904             tokensForOperations +
905             tokensForTreasury +
906             tokensForTeam;
907 
908         if (contractBalance == 0 || totalTokensToSwap == 0) {
909             return;
910         }
911 
912         if (contractBalance > swapTokensAtAmount * 10) {
913             contractBalance = swapTokensAtAmount * 10;
914         }
915 
916         bool success;
917 
918         // Halve the amount of liquidity tokens
919         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
920             totalTokensToSwap /
921             2;
922 
923         swapTokensForEth(contractBalance - liquidityTokens);
924 
925         uint256 ethBalance = address(this).balance;
926         uint256 ethForLiquidity = ethBalance;
927 
928         uint256 ethForOperations = (ethBalance * tokensForOperations) /
929             (totalTokensToSwap - (tokensForLiquidity / 2));
930         uint256 ethForTreasury = (ethBalance * tokensForTreasury) /
931             (totalTokensToSwap - (tokensForLiquidity / 2));
932         uint256 ethForTeam = (ethBalance * tokensForTeam) /
933             (totalTokensToSwap - (tokensForLiquidity / 2));
934 
935         ethForLiquidity -= ethForOperations + ethForTreasury + ethForTeam;
936 
937         tokensForLiquidity = 0;
938         tokensForOperations = 0;
939         tokensForTreasury = 0;
940         tokensForTeam = 0;
941 
942         if (liquidityTokens > 0 && ethForLiquidity > 0) {
943             addLiquidity(liquidityTokens, ethForLiquidity);
944         }
945 
946         (success, ) = address(treasuryAddress).call{value: ethForTreasury}("");
947         (success, ) = address(teamAddress).call{value: ethForTeam}("");
948         (success, ) = address(operationsAddress).call{
949             value: address(this).balance
950         }("");
951     }
952 
953     function transferForeignToken(address _token, address _to)
954         external
955         onlyOwner
956         returns (bool _sent)
957     {
958         require(_token != address(0), "_token address cannot be 0");
959         require(
960             _token != address(this) || !tradingActive,
961             "Can't withdraw native tokens while trading is active"
962         );
963         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
964         _sent = IERC20(_token).transfer(_to, _contractBalance);
965         emit TransferForeignToken(_token, _contractBalance);
966     }
967 
968     // withdraw ETH if stuck or someone sends to the address
969     function withdrawStuckETH() external onlyOwner {
970         bool success;
971         (success, ) = address(msg.sender).call{value: address(this).balance}(
972             ""
973         );
974     }
975 
976     function setOperationsAddress(address _operationsAddress)
977         external
978         onlyOwner
979     {
980         require(
981             _operationsAddress != address(0),
982             "_operationsAddress address cannot be 0"
983         );
984         operationsAddress = payable(_operationsAddress);
985         emit UpdatedOperationsAddress(_operationsAddress);
986     }
987 
988     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
989         require(
990             _treasuryAddress != address(0),
991             "_operationsAddress address cannot be 0"
992         );
993         treasuryAddress = payable(_treasuryAddress);
994         emit UpdatedTreasuryAddress(_treasuryAddress);
995     }
996 
997     function setTeamAddress(address _teamAddress) external onlyOwner {
998         require(_teamAddress != address(0), "_teamAddress address cannot be 0");
999         teamAddress = payable(_teamAddress);
1000         emit UpdatedTeamAddress(_teamAddress);
1001     }
1002 
1003     // force Swap back if slippage issues.
1004     function forceSwapBack() external onlyOwner {
1005         require(
1006             balanceOf(address(this)) >= swapTokensAtAmount,
1007             "Can only swap when token amount is at or higher than restriction"
1008         );
1009         swapping = true;
1010         swapBack();
1011         swapping = false;
1012         emit OwnerForcedSwapBack(block.timestamp);
1013     }
1014 
1015     // remove limits after token is stable
1016     function removeLimits() external onlyOwner {
1017         limitsInEffect = false;
1018     }
1019 
1020     function restoreLimits() external onlyOwner {
1021         limitsInEffect = true;
1022     }
1023 
1024     // 24-48 hours
1025     function sellTaxToTwelvePercent() external onlyOwner {
1026         sellOperationsFee = 5;
1027         sellLiquidityFee = 3;
1028         sellTreasuryFee = 3;
1029         sellTeamFee = 1;
1030         sellTotalFees =
1031             sellOperationsFee +
1032             sellLiquidityFee +
1033             sellTreasuryFee +
1034             sellTeamFee;
1035     }
1036 
1037     // Reset to normal sell tax - after 48 hours
1038     function sellTaxToNormal() external onlyOwner {
1039         sellOperationsFee = 3;
1040         sellLiquidityFee = 0;
1041         sellTreasuryFee = 3;
1042         sellTeamFee = 1;
1043         sellTotalFees =
1044             sellOperationsFee +
1045             sellLiquidityFee +
1046             sellTreasuryFee +
1047             sellTeamFee;
1048     }
1049 
1050     function airdropToWallets(
1051         address[] memory wallets,
1052         uint256[] memory amountsInTokens
1053     ) external onlyOwner {
1054         require(
1055             wallets.length == amountsInTokens.length,
1056             "arrays must be the same length"
1057         );
1058         require(
1059             wallets.length < 200,
1060             "Can only airdrop 200 wallets per txn due to gas limits"
1061         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1062         for (uint256 i = 0; i < wallets.length; i++) {
1063             address wallet = wallets[i];
1064             uint256 amount = amountsInTokens[i];
1065             super._transfer(msg.sender, wallet, amount);
1066         }
1067     }
1068 }