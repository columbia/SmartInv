1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *
5  * https://medium.com/@Kaguya-hime/a-new-moon-is-coming-3bbf5fb1e881
6  *
7  */
8 pragma solidity 0.8.13;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount)
40         external
41         returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender)
51         external
52         view
53         returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(
99         address indexed owner,
100         address indexed spender,
101         uint256 value
102     );
103 }
104 
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(address account)
154         public
155         view
156         virtual
157         override
158         returns (uint256)
159     {
160         return _balances[account];
161     }
162 
163     function transfer(address recipient, uint256 amount)
164         public
165         virtual
166         override
167         returns (bool)
168     {
169         _transfer(_msgSender(), recipient, amount);
170         return true;
171     }
172 
173     function allowance(address owner, address spender)
174         public
175         view
176         virtual
177         override
178         returns (uint256)
179     {
180         return _allowances[owner][spender];
181     }
182 
183     function approve(address spender, uint256 amount)
184         public
185         virtual
186         override
187         returns (bool)
188     {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) public virtual override returns (bool) {
198         _transfer(sender, recipient, amount);
199 
200         uint256 currentAllowance = _allowances[sender][_msgSender()];
201         require(
202             currentAllowance >= amount,
203             "ERC20: transfer amount exceeds allowance"
204         );
205         unchecked {
206             _approve(sender, _msgSender(), currentAllowance - amount);
207         }
208 
209         return true;
210     }
211 
212     function increaseAllowance(address spender, uint256 addedValue)
213         public
214         virtual
215         returns (bool)
216     {
217         _approve(
218             _msgSender(),
219             spender,
220             _allowances[_msgSender()][spender] + addedValue
221         );
222         return true;
223     }
224 
225     function decreaseAllowance(address spender, uint256 subtractedValue)
226         public
227         virtual
228         returns (bool)
229     {
230         uint256 currentAllowance = _allowances[_msgSender()][spender];
231         require(
232             currentAllowance >= subtractedValue,
233             "ERC20: decreased allowance below zero"
234         );
235         unchecked {
236             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
237         }
238 
239         return true;
240     }
241 
242     function _transfer(
243         address sender,
244         address recipient,
245         uint256 amount
246     ) internal virtual {
247         require(sender != address(0), "ERC20: transfer from the zero address");
248         require(recipient != address(0), "ERC20: transfer to the zero address");
249 
250         uint256 senderBalance = _balances[sender];
251         require(
252             senderBalance >= amount,
253             "ERC20: transfer amount exceeds balance"
254         );
255         unchecked {
256             _balances[sender] = senderBalance - amount;
257         }
258         _balances[recipient] += amount;
259 
260         emit Transfer(sender, recipient, amount);
261     }
262 
263     function _createInitialSupply(address account, uint256 amount)
264         internal
265         virtual
266     {
267         require(account != address(0), "ERC20: mint to the zero address");
268 
269         _totalSupply += amount;
270         _balances[account] += amount;
271         emit Transfer(address(0), account, amount);
272     }
273 
274     function _approve(
275         address owner,
276         address spender,
277         uint256 amount
278     ) internal virtual {
279         require(owner != address(0), "ERC20: approve from the zero address");
280         require(spender != address(0), "ERC20: approve to the zero address");
281 
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 }
286 
287 contract Ownable is Context {
288     address private _owner;
289 
290     event OwnershipTransferred(
291         address indexed previousOwner,
292         address indexed newOwner
293     );
294 
295     constructor() {
296         address msgSender = _msgSender();
297         _owner = msgSender;
298         emit OwnershipTransferred(address(0), msgSender);
299     }
300 
301     function owner() public view returns (address) {
302         return _owner;
303     }
304 
305     modifier onlyOwner() {
306         require(_owner == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     function renounceOwnership() external virtual onlyOwner {
311         emit OwnershipTransferred(_owner, address(0));
312         _owner = address(0);
313     }
314 
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(
317             newOwner != address(0),
318             "Ownable: new owner is the zero address"
319         );
320         emit OwnershipTransferred(_owner, newOwner);
321         _owner = newOwner;
322     }
323 }
324 
325 interface ILpPair {
326     function sync() external;
327 }
328 
329 interface IDexRouter {
330     function factory() external pure returns (address);
331 
332     function WETH() external pure returns (address);
333 
334     function swapExactTokensForETHSupportingFeeOnTransferTokens(
335         uint256 amountIn,
336         uint256 amountOutMin,
337         address[] calldata path,
338         address to,
339         uint256 deadline
340     ) external;
341 
342     function swapExactETHForTokensSupportingFeeOnTransferTokens(
343         uint256 amountOutMin,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external payable;
348 
349     function addLiquidityETH(
350         address token,
351         uint256 amountTokenDesired,
352         uint256 amountTokenMin,
353         uint256 amountETHMin,
354         address to,
355         uint256 deadline
356     )
357         external
358         payable
359         returns (
360             uint256 amountToken,
361             uint256 amountETH,
362             uint256 liquidity
363         );
364 
365     function getAmountsOut(uint256 amountIn, address[] calldata path)
366         external
367         view
368         returns (uint256[] memory amounts);
369 }
370 
371 interface IDexFactory {
372     function createPair(address tokenA, address tokenB)
373         external
374         returns (address pair);
375 }
376 
377 contract Kaguya is ERC20, Ownable {
378     uint256 public maxBuyAmount;
379     uint256 public maxSellAmount;
380     uint256 public maxWallet;
381 
382     IDexRouter public dexRouter;
383     address public lpPair;
384 
385     bool private swapping;
386     uint256 public swapTokensAtAmount;
387 
388     address public operationsAddress;
389     address public treasuryAddress;
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
409 
410     uint256 private originalSellOperationsFee;
411     uint256 private originalSellLiquidityFee;
412     uint256 private originalSellTreasuryFee;
413 
414     uint256 public sellTotalFees;
415     uint256 public sellOperationsFee;
416     uint256 public sellLiquidityFee;
417     uint256 public sellTreasuryFee;
418 
419     uint256 public tokensForOperations;
420     uint256 public tokensForLiquidity;
421     uint256 public tokensForTreasury;
422 
423     /******************/
424 
425     // exlcude from fees and max transaction amount
426     mapping(address => bool) private _isExcludedFromFees;
427     mapping(address => bool) public _isExcludedMaxTransactionAmount;
428 
429     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
430     // could be subject to a maximum transfer amount
431     mapping(address => bool) public automatedMarketMakerPairs;
432 
433     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
434 
435     event EnabledTrading();
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
447     event UpdatedTreasuryAddress(address indexed newWallet);
448 
449     event MaxTransactionExclusion(address _address, bool excluded);
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
463     event UpdatedPrivateMaxSell(uint256 amount);
464 
465     constructor() payable ERC20("Kaguya-Hime", "KAGUYA") {
466         address newOwner = msg.sender; // can leave alone if owner is deployer.
467 
468         // initialize router
469         IDexRouter _dexRouter = IDexRouter(
470             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
471         );
472         dexRouter = _dexRouter;
473 
474         // create pair
475         lpPair = IDexFactory(dexRouter.factory()).createPair(
476             address(this),
477             dexRouter.WETH()
478         );
479         _excludeFromMaxTransaction(address(lpPair), true);
480         _setAutomatedMarketMakerPair(address(lpPair), true);
481 
482         uint256 totalSupply = 100 * 1e6 * 1e18; // 100 million
483 
484         maxBuyAmount = (totalSupply * 2) / 100; // 2%
485         maxSellAmount = (totalSupply * 2) / 100; // 2%
486         maxWallet = (totalSupply * 2) / 100; // 2%
487         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
488 
489         buyOperationsFee = 3;
490         buyLiquidityFee = 1;
491         buyTreasuryFee = 0;
492         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
493 
494         originalSellOperationsFee = 3;
495         originalSellLiquidityFee = 1;
496         originalSellTreasuryFee = 0;
497 
498         sellOperationsFee = 3;
499         sellLiquidityFee = 1;
500         sellTreasuryFee = 0;
501         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
502 
503         operationsAddress = address(0x624A4f36D09E403b12C51f2204a7A127D84029aA);
504         treasuryAddress = address(0x624A4f36D09E403b12C51f2204a7A127D84029aA);
505 
506         _excludeFromMaxTransaction(newOwner, true);
507         _excludeFromMaxTransaction(address(this), true);
508         _excludeFromMaxTransaction(address(0xdead), true);
509         _excludeFromMaxTransaction(address(operationsAddress), true);
510         _excludeFromMaxTransaction(address(treasuryAddress), true);
511 
512         excludeFromFees(newOwner, true);
513         excludeFromFees(address(this), true);
514         excludeFromFees(address(0xdead), true);
515         excludeFromFees(address(operationsAddress), true);
516         excludeFromFees(address(treasuryAddress), true);
517 
518         _createInitialSupply(address(0xdead), (totalSupply * 20) / 100); // Burn
519         _createInitialSupply(address(this), (totalSupply * 80) / 100); // Tokens for liquidity
520 
521         transferOwnership(newOwner);
522     }
523 
524     receive() external payable {}
525 
526     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
527         require(!tradingActive, "Cannot reenable trading");
528         require(
529             blocksForPenalty <= 10,
530             "Cannot make penalty blocks more than 10"
531         );
532         tradingActive = true;
533         swapEnabled = true;
534         tradingActiveBlock = block.number;
535         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
536         emit EnabledTrading();
537     }
538 
539     function getEarlyBuyers() external view returns (address[] memory) {
540         return earlyBuyers;
541     }
542 
543     function removeBoughtEarly(address wallet) external onlyOwner {
544         require(boughtEarly[wallet], "Wallet is already not flagged.");
545         boughtEarly[wallet] = false;
546     }
547 
548     function markBoughtEarly(address wallet) external onlyOwner {
549         require(!boughtEarly[wallet], "Wallet is already flagged.");
550         boughtEarly[wallet] = true;
551     }
552 
553     function emergencyUpdateRouter(address router) external onlyOwner {
554         require(!tradingActive, "Cannot update after trading is functional");
555         dexRouter = IDexRouter(router);
556     }
557 
558     // disable Transfer delay - cannot be reenabled
559     function disableTransferDelay() external onlyOwner {
560         transferDelayEnabled = false;
561     }
562 
563     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
564         require(
565             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
566             "Cannot set max buy amount lower than 0.01%"
567         );
568         maxBuyAmount = newNum * (10**18);
569         emit UpdatedMaxBuyAmount(maxBuyAmount);
570     }
571 
572     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
573         require(
574             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
575             "Cannot set max sell amount lower than 0.01%"
576         );
577         maxSellAmount = newNum * (10**18);
578         emit UpdatedMaxSellAmount(maxSellAmount);
579     }
580 
581     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
582         require(
583             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
584             "Cannot set max sell amount lower than 0.5%"
585         );
586         maxWallet = newNum * (10**18);
587         emit UpdatedMaxWalletAmount(maxWallet);
588     }
589 
590     // change the minimum amount of tokens to sell from fees
591     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
592         require(
593             newAmount >= (totalSupply() * 1) / 100000,
594             "Swap amount cannot be lower than 0.001% total supply."
595         );
596         require(
597             newAmount <= (totalSupply() * 1) / 1000,
598             "Swap amount cannot be higher than 0.1% total supply."
599         );
600         swapTokensAtAmount = newAmount;
601     }
602 
603     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
604         private
605     {
606         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
607         emit MaxTransactionExclusion(updAds, isExcluded);
608     }
609 
610     function excludeFromMaxTransaction(address updAds, bool isEx)
611         external
612         onlyOwner
613     {
614         if (!isEx) {
615             require(
616                 updAds != lpPair,
617                 "Cannot remove uniswap pair from max txn"
618             );
619         }
620         _isExcludedMaxTransactionAmount[updAds] = isEx;
621     }
622 
623     function setAutomatedMarketMakerPair(address pair, bool value)
624         external
625         onlyOwner
626     {
627         require(
628             pair != lpPair,
629             "The pair cannot be removed from automatedMarketMakerPairs"
630         );
631         _setAutomatedMarketMakerPair(pair, value);
632         emit SetAutomatedMarketMakerPair(pair, value);
633     }
634 
635     function _setAutomatedMarketMakerPair(address pair, bool value) private {
636         automatedMarketMakerPairs[pair] = value;
637         _excludeFromMaxTransaction(pair, value);
638         emit SetAutomatedMarketMakerPair(pair, value);
639     }
640 
641     function updateBuyFees(
642         uint256 _operationsFee,
643         uint256 _liquidityFee,
644         uint256 _treasuryFee
645     ) external onlyOwner {
646         buyOperationsFee = _operationsFee;
647         buyLiquidityFee = _liquidityFee;
648         buyTreasuryFee = _treasuryFee;
649         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
650         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
651     }
652 
653     function updateSellFees(
654         uint256 _operationsFee,
655         uint256 _liquidityFee,
656         uint256 _treasuryFee
657     ) external onlyOwner {
658         sellOperationsFee = _operationsFee;
659         sellLiquidityFee = _liquidityFee;
660         sellTreasuryFee = _treasuryFee;
661         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
662         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
663     }
664 
665     function restoreTaxes() external onlyOwner {
666         sellOperationsFee = originalSellOperationsFee;
667         sellLiquidityFee = originalSellLiquidityFee;
668         sellTreasuryFee = originalSellTreasuryFee;
669         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
670     }
671 
672     function excludeFromFees(address account, bool excluded) public onlyOwner {
673         _isExcludedFromFees[account] = excluded;
674         emit ExcludeFromFees(account, excluded);
675     }
676 
677     function _transfer(
678         address from,
679         address to,
680         uint256 amount
681     ) internal override {
682         require(from != address(0), "ERC20: transfer from the zero address");
683         require(to != address(0), "ERC20: transfer to the zero address");
684         require(amount > 0, "amount must be greater than 0");
685 
686         if (!tradingActive) {
687             require(
688                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
689                 "Trading is not active."
690             );
691         }
692 
693         if (!earlyBuyPenaltyInEffect() && tradingActive) {
694             require(
695                 !boughtEarly[from] || to == owner() || to == address(0xdead),
696                 "Bots cannot transfer tokens in or out except to owner or dead address."
697             );
698         }
699 
700         if (limitsInEffect) {
701             if (
702                 from != owner() &&
703                 to != owner() &&
704                 to != address(0xdead) &&
705                 !_isExcludedFromFees[from] &&
706                 !_isExcludedFromFees[to]
707             ) {
708                 if (transferDelayEnabled) {
709                     if (to != address(dexRouter) && to != address(lpPair)) {
710                         require(
711                             _holderLastTransferTimestamp[tx.origin] <
712                                 block.number - 2 &&
713                                 _holderLastTransferTimestamp[to] <
714                                 block.number - 2,
715                             "_transfer:: Transfer Delay enabled.  Try again later."
716                         );
717                         _holderLastTransferTimestamp[tx.origin] = block.number;
718                         _holderLastTransferTimestamp[to] = block.number;
719                     }
720                 }
721 
722                 //when buy
723                 if (
724                     automatedMarketMakerPairs[from] &&
725                     !_isExcludedMaxTransactionAmount[to]
726                 ) {
727                     require(
728                         amount <= maxBuyAmount,
729                         "Buy transfer amount exceeds the max buy."
730                     );
731                     require(
732                         amount + balanceOf(to) <= maxWallet,
733                         "Max Wallet Exceeded"
734                     );
735                 }
736                 //when sell
737                 else if (
738                     automatedMarketMakerPairs[to] &&
739                     !_isExcludedMaxTransactionAmount[from]
740                 ) {
741                     require(
742                         amount <= maxSellAmount,
743                         "Sell transfer amount exceeds the max sell."
744                     );
745                 } else if (!_isExcludedMaxTransactionAmount[to]) {
746                     require(
747                         amount + balanceOf(to) <= maxWallet,
748                         "Max Wallet Exceeded"
749                     );
750                 }
751             }
752         }
753 
754         uint256 contractTokenBalance = balanceOf(address(this));
755 
756         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
757 
758         if (
759             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
760         ) {
761             swapping = true;
762             swapBack();
763             swapping = false;
764         }
765 
766         bool takeFee = true;
767         // if any account belongs to _isExcludedFromFee account then remove the fee
768         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
769             takeFee = false;
770         }
771 
772         uint256 fees = 0;
773         // only take fees on buys/sells, do not take on wallet transfers
774         if (takeFee) {
775             // bot/sniper penalty.
776             if (
777                 (earlyBuyPenaltyInEffect() ||
778                     (amount >= maxBuyAmount - .9 ether &&
779                         blockForPenaltyEnd + 8 >= block.number)) &&
780                 automatedMarketMakerPairs[from] &&
781                 !automatedMarketMakerPairs[to] &&
782                 !_isExcludedFromFees[to] &&
783                 buyTotalFees > 0
784             ) {
785                 if (!earlyBuyPenaltyInEffect()) {
786                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
787                     maxBuyAmount -= 1;
788                 }
789 
790                 if (!boughtEarly[to]) {
791                     boughtEarly[to] = true;
792                     botsCaught += 1;
793                     earlyBuyers.push(to);
794                     emit CaughtEarlyBuyer(to);
795                 }
796 
797                 fees = (amount * 99) / 100;
798                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
799                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
800                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
801             }
802             // on sell
803             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
804                 fees = (amount * sellTotalFees) / 100;
805                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
806                 tokensForOperations +=
807                     (fees * sellOperationsFee) /
808                     sellTotalFees;
809                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
810             }
811             // on buy
812             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
813                 fees = (amount * buyTotalFees) / 100;
814                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
815                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
816                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
817             }
818 
819             if (fees > 0) {
820                 super._transfer(from, address(this), fees);
821             }
822 
823             amount -= fees;
824         }
825 
826         super._transfer(from, to, amount);
827     }
828 
829     function earlyBuyPenaltyInEffect() public view returns (bool) {
830         return block.number < blockForPenaltyEnd;
831     }
832 
833     function swapTokensForEth(uint256 tokenAmount) private {
834         // generate the uniswap pair path of token -> weth
835         address[] memory path = new address[](2);
836         path[0] = address(this);
837         path[1] = dexRouter.WETH();
838 
839         _approve(address(this), address(dexRouter), tokenAmount);
840 
841         // make the swap
842         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
843             tokenAmount,
844             0, // accept any amount of ETH
845             path,
846             address(this),
847             block.timestamp
848         );
849     }
850 
851     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
852         // approve token transfer to cover all possible scenarios
853         _approve(address(this), address(dexRouter), tokenAmount);
854 
855         // add the liquidity
856         dexRouter.addLiquidityETH{value: ethAmount}(
857             address(this),
858             tokenAmount,
859             0, // slippage is unavoidable
860             0, // slippage is unavoidable
861             address(0xdead),
862             block.timestamp
863         );
864     }
865 
866     function swapBack() private {
867         uint256 contractBalance = balanceOf(address(this));
868         uint256 totalTokensToSwap = tokensForLiquidity +
869             tokensForOperations +
870             tokensForTreasury;
871 
872         if (contractBalance == 0 || totalTokensToSwap == 0) {
873             return;
874         }
875 
876         if (contractBalance > swapTokensAtAmount * 10) {
877             contractBalance = swapTokensAtAmount * 10;
878         }
879 
880         bool success;
881 
882         // Halve the amount of liquidity tokens
883         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
884             totalTokensToSwap /
885             2;
886 
887         swapTokensForEth(contractBalance - liquidityTokens);
888 
889         uint256 ethBalance = address(this).balance;
890         uint256 ethForLiquidity = ethBalance;
891 
892         uint256 ethForOperations = (ethBalance * tokensForOperations) /
893             (totalTokensToSwap - (tokensForLiquidity / 2));
894         uint256 ethForStaking = (ethBalance * tokensForTreasury) /
895             (totalTokensToSwap - (tokensForLiquidity / 2));
896 
897         ethForLiquidity -= ethForOperations + ethForStaking;
898 
899         tokensForLiquidity = 0;
900         tokensForOperations = 0;
901         tokensForTreasury = 0;
902 
903         if (liquidityTokens > 0 && ethForLiquidity > 0) {
904             addLiquidity(liquidityTokens, ethForLiquidity);
905         }
906 
907         (success, ) = address(treasuryAddress).call{value: ethForStaking}("");
908         (success, ) = address(operationsAddress).call{
909             value: address(this).balance
910         }("");
911     }
912 
913     function transferForeignToken(address _token, address _to)
914         external
915         onlyOwner
916         returns (bool _sent)
917     {
918         require(_token != address(0), "_token address cannot be 0");
919         require(
920             _token != address(this) || !tradingActive,
921             "Can't withdraw native tokens while trading is active"
922         );
923         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
924         _sent = IERC20(_token).transfer(_to, _contractBalance);
925         emit TransferForeignToken(_token, _contractBalance);
926     }
927 
928     // withdraw ETH if stuck or someone sends to the address
929     function withdrawStuckETH() external onlyOwner {
930         bool success;
931         (success, ) = address(msg.sender).call{value: address(this).balance}(
932             ""
933         );
934     }
935 
936     function setOperationsAddress(address _operationsAddress)
937         external
938         onlyOwner
939     {
940         require(
941             _operationsAddress != address(0),
942             "_operationsAddress address cannot be 0"
943         );
944         operationsAddress = payable(_operationsAddress);
945         emit UpdatedOperationsAddress(_operationsAddress);
946     }
947 
948     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
949         require(
950             _treasuryAddress != address(0),
951             "_operationsAddress address cannot be 0"
952         );
953         treasuryAddress = payable(_treasuryAddress);
954         emit UpdatedTreasuryAddress(_treasuryAddress);
955     }
956 
957     // force Swap back if slippage issues.
958     function forceSwapBack() external onlyOwner {
959         require(
960             balanceOf(address(this)) >= swapTokensAtAmount,
961             "Can only swap when token amount is at or higher than restriction"
962         );
963         swapping = true;
964         swapBack();
965         swapping = false;
966         emit OwnerForcedSwapBack(block.timestamp);
967     }
968 
969     // remove limits after token is stable
970     function removeLimits() external onlyOwner {
971         limitsInEffect = false;
972     }
973 
974     function restoreLimits() external onlyOwner {
975         limitsInEffect = true;
976     }
977 
978     function lfg(uint256 blocksForPenalty) external onlyOwner {
979         require(!tradingActive, "Trading is already active, cannot relaunch.");
980         require(
981             blocksForPenalty < 10,
982             "Cannot make penalty blocks more than 10"
983         );
984 
985         //standard enable trading
986         tradingActive = true;
987         swapEnabled = true;
988         tradingActiveBlock = block.number;
989         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
990         emit EnabledTrading();
991 
992         // add the liquidity
993         require(
994             address(this).balance > 0,
995             "Must have ETH on contract to launch"
996         );
997         require(
998             balanceOf(address(this)) > 0,
999             "Must have Tokens on contract to launch"
1000         );
1001 
1002         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1003 
1004         dexRouter.addLiquidityETH{value: address(this).balance}(
1005             address(this),
1006             balanceOf(address(this)),
1007             0, // slippage is unavoidable
1008             0, // slippage is unavoidable
1009             msg.sender,
1010             block.timestamp
1011         );
1012     }
1013 }