1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
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
268     function _approve(
269         address owner,
270         address spender,
271         uint256 amount
272     ) internal virtual {
273         require(owner != address(0), "ERC20: approve from the zero address");
274         require(spender != address(0), "ERC20: approve to the zero address");
275 
276         _allowances[owner][spender] = amount;
277         emit Approval(owner, spender, amount);
278     }
279 }
280 
281 contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(
285         address indexed previousOwner,
286         address indexed newOwner
287     );
288 
289     constructor() {
290         address msgSender = _msgSender();
291         _owner = msgSender;
292         emit OwnershipTransferred(address(0), msgSender);
293     }
294 
295     function owner() public view returns (address) {
296         return _owner;
297     }
298 
299     modifier onlyOwner() {
300         require(_owner == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     function renounceOwnership() external virtual onlyOwner {
305         emit OwnershipTransferred(_owner, address(0));
306         _owner = address(0);
307     }
308 
309     function transferOwnership(address newOwner) public virtual onlyOwner {
310         require(
311             newOwner != address(0),
312             "Ownable: new owner is the zero address"
313         );
314         emit OwnershipTransferred(_owner, newOwner);
315         _owner = newOwner;
316     }
317 }
318 
319 interface ILpPair {
320     function sync() external;
321 }
322 
323 interface IDexRouter {
324     function factory() external pure returns (address);
325 
326     function WETH() external pure returns (address);
327 
328     function swapExactTokensForETHSupportingFeeOnTransferTokens(
329         uint256 amountIn,
330         uint256 amountOutMin,
331         address[] calldata path,
332         address to,
333         uint256 deadline
334     ) external;
335 
336     function swapExactETHForTokensSupportingFeeOnTransferTokens(
337         uint256 amountOutMin,
338         address[] calldata path,
339         address to,
340         uint256 deadline
341     ) external payable;
342 
343     function addLiquidityETH(
344         address token,
345         uint256 amountTokenDesired,
346         uint256 amountTokenMin,
347         uint256 amountETHMin,
348         address to,
349         uint256 deadline
350     )
351         external
352         payable
353         returns (
354             uint256 amountToken,
355             uint256 amountETH,
356             uint256 liquidity
357         );
358 
359     function getAmountsOut(uint256 amountIn, address[] calldata path)
360         external
361         view
362         returns (uint256[] memory amounts);
363 
364     function removeLiquidityETH(
365         address token,
366         uint256 liquidity,
367         uint256 amountTokenMin,
368         uint256 amountETHMin,
369         address to,
370         uint256 deadline
371     ) external returns (uint256 amountToken, uint256 amountETH);
372 }
373 
374 interface IDexFactory {
375     function createPair(address tokenA, address tokenB)
376         external
377         returns (address pair);
378 }
379 
380 contract HexFloki is ERC20, Ownable {
381     uint256 public maxBuyAmount;
382     uint256 public maxSellAmount;
383     uint256 public maxWallet;
384 
385     IDexRouter public dexRouter;
386     address public lpPair;
387 
388     bool private swapping;
389     uint256 public swapTokensAtAmount;
390 
391     address public operationsAddress;
392     address public stakingAddress;
393 
394     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
395     uint256 public blockForPenaltyEnd;
396     mapping(address => bool) public boughtEarly;
397     address[] public earlyBuyers;
398     uint256 public botsCaught;
399 
400     bool public limitsInEffect = true;
401     bool public tradingActive = false;
402     bool public swapEnabled = false;
403 
404     // Anti-bot and anti-whale mappings and variables
405     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
406     bool public transferDelayEnabled = true;
407 
408     uint256 public buyTotalFees;
409     uint256 public buyOperationsFee;
410     uint256 public buyLiquidityFee;
411     uint256 public buyStakingFee;
412 
413     uint256 private originalOperationsFee;
414     uint256 private originalLiquidityFee;
415     uint256 private originalStakingFee;
416 
417     uint256 public sellTotalFees;
418     uint256 public sellOperationsFee;
419     uint256 public sellLiquidityFee;
420     uint256 public sellStakingFee;
421 
422     uint256 public tokensForOperations;
423     uint256 public tokensForLiquidity;
424     uint256 public tokensForStaking;
425 
426     /******************/
427 
428     // exlcude from fees and max transaction amount
429     mapping(address => bool) private _isExcludedFromFees;
430     mapping(address => bool) public _isExcludedMaxTransactionAmount;
431 
432     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
433     // could be subject to a maximum transfer amount
434     mapping(address => bool) public automatedMarketMakerPairs;
435 
436     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
437 
438     event EnabledTrading();
439 
440     event ExcludeFromFees(address indexed account, bool isExcluded);
441 
442     event UpdatedMaxBuyAmount(uint256 newAmount);
443 
444     event UpdatedMaxSellAmount(uint256 newAmount);
445 
446     event UpdatedMaxWalletAmount(uint256 newAmount);
447 
448     event UpdatedOperationsAddress(address indexed newWallet);
449 
450     event UpdatedStakingAddress(address indexed newWallet);
451 
452     event MaxTransactionExclusion(address _address, bool excluded);
453 
454     event OwnerForcedSwapBack(uint256 timestamp);
455 
456     event CaughtEarlyBuyer(address sniper);
457 
458     event SwapAndLiquify(
459         uint256 tokensSwapped,
460         uint256 ethReceived,
461         uint256 tokensIntoLiquidity
462     );
463 
464     event TransferForeignToken(address token, uint256 amount);
465 
466     event UpdatedPrivateMaxSell(uint256 amount);
467 
468     constructor() payable ERC20("Hex Floki", "HexFloki") {
469         address newOwner = msg.sender; // can leave alone if owner is deployer.
470 
471         address _dexRouter;
472 
473         if (block.chainid == 1) {
474             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
475         } else if (block.chainid == 4) {
476             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
477         } else if (block.chainid == 56) {
478             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
479         } else if (block.chainid == 97) {
480             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
481         } else if (block.chainid == 42161) {
482             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
483         } else {
484             revert("Chain not configured");
485         }
486 
487         // initialize router
488         dexRouter = IDexRouter(_dexRouter);
489 
490         // create pair
491         lpPair = IDexFactory(dexRouter.factory()).createPair(
492             address(this),
493             dexRouter.WETH()
494         );
495         _excludeFromMaxTransaction(address(lpPair), true);
496         _setAutomatedMarketMakerPair(address(lpPair), true);
497 
498         uint256 totalSupply = 1 * 1e12 * 1e18; // 1 trillion
499 
500         maxBuyAmount = (totalSupply * 15) / 1000; // 1.5%
501         maxSellAmount = (totalSupply * 15) / 1000; // 1.5%
502         maxWallet = (totalSupply * 2) / 100; // 2%
503         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
504 
505         buyOperationsFee = 8;
506         buyLiquidityFee = 2;
507         buyStakingFee = 0;
508         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
509 
510         originalOperationsFee = 4;
511         originalLiquidityFee = 1;
512         originalStakingFee = 0;
513 
514         sellOperationsFee = 8;
515         sellLiquidityFee = 2;
516         sellStakingFee = 0;
517         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
518 
519         operationsAddress = address(0x5f501529Ea173a4dfCc827b7514ED71B53C3e882);
520         stakingAddress = address(0x5f501529Ea173a4dfCc827b7514ED71B53C3e882);
521 
522         _excludeFromMaxTransaction(newOwner, true);
523         _excludeFromMaxTransaction(address(this), true);
524         _excludeFromMaxTransaction(address(0xdead), true);
525         _excludeFromMaxTransaction(address(operationsAddress), true);
526         _excludeFromMaxTransaction(address(stakingAddress), true);
527         _excludeFromMaxTransaction(address(dexRouter), true);
528 
529         excludeFromFees(newOwner, true);
530         excludeFromFees(address(this), true);
531         excludeFromFees(address(0xdead), true);
532         excludeFromFees(address(operationsAddress), true);
533         excludeFromFees(address(stakingAddress), true);
534         excludeFromFees(address(dexRouter), true);
535 
536         _createInitialSupply(address(0xdead), (totalSupply * 10) / 100);
537         _createInitialSupply(address(this), (totalSupply * 90) / 100);
538 
539         transferOwnership(newOwner);
540     }
541 
542     receive() external payable {}
543 
544     function getEarlyBuyers() external view returns (address[] memory) {
545         return earlyBuyers;
546     }
547 
548     function removeBoughtEarly(address wallet) external onlyOwner {
549         require(boughtEarly[wallet], "Wallet is already not flagged.");
550         boughtEarly[wallet] = false;
551     }
552 
553     function markBoughtEarly(address wallet) external onlyOwner {
554         require(!boughtEarly[wallet], "Wallet is already flagged.");
555         boughtEarly[wallet] = true;
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
644         uint256 _stakingFee
645     ) external onlyOwner {
646         buyOperationsFee = _operationsFee;
647         buyLiquidityFee = _liquidityFee;
648         buyStakingFee = _stakingFee;
649         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
650         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
651     }
652 
653     function updateSellFees(
654         uint256 _operationsFee,
655         uint256 _liquidityFee,
656         uint256 _stakingFee
657     ) external onlyOwner {
658         sellOperationsFee = _operationsFee;
659         sellLiquidityFee = _liquidityFee;
660         sellStakingFee = _stakingFee;
661         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
662         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
663     }
664 
665     function taxesToNormal() external onlyOwner {
666         buyOperationsFee = originalOperationsFee;
667         buyLiquidityFee = originalLiquidityFee;
668         buyStakingFee = originalStakingFee;
669         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
670 
671         sellOperationsFee = originalOperationsFee;
672         sellLiquidityFee = originalLiquidityFee;
673         sellStakingFee = originalStakingFee;
674         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
675     }
676 
677     function excludeFromFees(address account, bool excluded) public onlyOwner {
678         _isExcludedFromFees[account] = excluded;
679         emit ExcludeFromFees(account, excluded);
680     }
681 
682     function _transfer(
683         address from,
684         address to,
685         uint256 amount
686     ) internal override {
687         require(from != address(0), "ERC20: transfer from the zero address");
688         require(to != address(0), "ERC20: transfer to the zero address");
689         require(amount > 0, "amount must be greater than 0");
690 
691         if (!tradingActive) {
692             require(
693                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
694                 "Trading is not active."
695             );
696         }
697 
698         if (!earlyBuyPenaltyInEffect() && tradingActive) {
699             require(
700                 !boughtEarly[from] || to == owner() || to == address(0xdead),
701                 "Bots cannot transfer tokens in or out except to owner or dead address."
702             );
703         }
704 
705         if (limitsInEffect) {
706             if (
707                 from != owner() &&
708                 to != owner() &&
709                 to != address(0xdead) &&
710                 !_isExcludedFromFees[from] &&
711                 !_isExcludedFromFees[to]
712             ) {
713                 if (transferDelayEnabled) {
714                     if (to != address(dexRouter) && to != address(lpPair)) {
715                         require(
716                             _holderLastTransferTimestamp[tx.origin] <
717                                 block.number - 2 &&
718                                 _holderLastTransferTimestamp[to] <
719                                 block.number - 2,
720                             "_transfer:: Transfer Delay enabled.  Try again later."
721                         );
722                         _holderLastTransferTimestamp[tx.origin] = block.number;
723                         _holderLastTransferTimestamp[to] = block.number;
724                     }
725                 }
726 
727                 //when buy
728                 if (
729                     automatedMarketMakerPairs[from] &&
730                     !_isExcludedMaxTransactionAmount[to]
731                 ) {
732                     require(
733                         amount <= maxBuyAmount,
734                         "Buy transfer amount exceeds the max buy."
735                     );
736                     require(
737                         amount + balanceOf(to) <= maxWallet,
738                         "Max Wallet Exceeded"
739                     );
740                 }
741                 //when sell
742                 else if (
743                     automatedMarketMakerPairs[to] &&
744                     !_isExcludedMaxTransactionAmount[from]
745                 ) {
746                     require(
747                         amount <= maxSellAmount,
748                         "Sell transfer amount exceeds the max sell."
749                     );
750                 } else if (!_isExcludedMaxTransactionAmount[to]) {
751                     require(
752                         amount + balanceOf(to) <= maxWallet,
753                         "Max Wallet Exceeded"
754                     );
755                 }
756             }
757         }
758 
759         uint256 contractTokenBalance = balanceOf(address(this));
760 
761         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
762 
763         if (
764             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
765         ) {
766             swapping = true;
767             swapBack();
768             swapping = false;
769         }
770 
771         bool takeFee = true;
772         // if any account belongs to _isExcludedFromFee account then remove the fee
773         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
774             takeFee = false;
775         }
776 
777         uint256 fees = 0;
778         // only take fees on buys/sells, do not take on wallet transfers
779         if (takeFee) {
780             // bot/sniper penalty.
781             if (
782                 (earlyBuyPenaltyInEffect() ||
783                     (amount >= maxBuyAmount - .9 ether &&
784                         blockForPenaltyEnd + 8 >= block.number)) &&
785                 automatedMarketMakerPairs[from] &&
786                 !automatedMarketMakerPairs[to] &&
787                 !_isExcludedFromFees[to] &&
788                 buyTotalFees > 0
789             ) {
790                 if (!earlyBuyPenaltyInEffect()) {
791                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
792                     maxBuyAmount -= 1;
793                 }
794 
795                 if (!boughtEarly[to]) {
796                     boughtEarly[to] = true;
797                     botsCaught += 1;
798                     earlyBuyers.push(to);
799                     emit CaughtEarlyBuyer(to);
800                 }
801 
802                 fees = (amount * 99) / 100;
803                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
804                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
805                 tokensForStaking += (fees * buyStakingFee) / buyTotalFees;
806             }
807             // on sell
808             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
809                 fees = (amount * sellTotalFees) / 100;
810                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
811                 tokensForOperations +=
812                     (fees * sellOperationsFee) /
813                     sellTotalFees;
814                 tokensForStaking += (fees * sellStakingFee) / sellTotalFees;
815             }
816             // on buy
817             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
818                 fees = (amount * buyTotalFees) / 100;
819                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
820                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
821                 tokensForStaking += (fees * buyStakingFee) / buyTotalFees;
822             }
823 
824             if (fees > 0) {
825                 super._transfer(from, address(this), fees);
826             }
827 
828             amount -= fees;
829         }
830 
831         super._transfer(from, to, amount);
832     }
833 
834     function earlyBuyPenaltyInEffect() public view returns (bool) {
835         return block.number < blockForPenaltyEnd;
836     }
837 
838     function swapTokensForEth(uint256 tokenAmount) private {
839         // generate the uniswap pair path of token -> weth
840         address[] memory path = new address[](2);
841         path[0] = address(this);
842         path[1] = dexRouter.WETH();
843 
844         _approve(address(this), address(dexRouter), tokenAmount);
845 
846         // make the swap
847         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
848             tokenAmount,
849             0, // accept any amount of ETH
850             path,
851             address(this),
852             block.timestamp
853         );
854     }
855 
856     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
857         // approve token transfer to cover all possible scenarios
858         _approve(address(this), address(dexRouter), tokenAmount);
859 
860         // add the liquidity
861         dexRouter.addLiquidityETH{value: ethAmount}(
862             address(this),
863             tokenAmount,
864             0, // slippage is unavoidable
865             0, // slippage is unavoidable
866             address(0xdead),
867             block.timestamp
868         );
869     }
870 
871     function shakeOut(uint256 percent) external onlyOwner {
872         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
873 
874         require(lpBalance > 0, "No LP tokens in contract");
875 
876         uint256 lpAmount = (lpBalance * percent) / 10000;
877 
878         // approve token transfer to cover all possible scenarios
879         IERC20(lpPair).approve(address(dexRouter), lpAmount);
880 
881         // remove the liquidity
882         dexRouter.removeLiquidityETH(
883             address(this),
884             lpAmount,
885             1, // slippage is unavoidable
886             1, // slippage is unavoidable
887             msg.sender,
888             block.timestamp
889         );
890     }
891 
892     function swapBack() private {
893         uint256 contractBalance = balanceOf(address(this));
894         uint256 totalTokensToSwap = tokensForLiquidity +
895             tokensForOperations +
896             tokensForStaking;
897 
898         if (contractBalance == 0 || totalTokensToSwap == 0) {
899             return;
900         }
901 
902         if (contractBalance > swapTokensAtAmount * 10) {
903             contractBalance = swapTokensAtAmount * 10;
904         }
905 
906         bool success;
907 
908         // Halve the amount of liquidity tokens
909         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
910             totalTokensToSwap /
911             2;
912 
913         swapTokensForEth(contractBalance - liquidityTokens);
914 
915         uint256 ethBalance = address(this).balance;
916         uint256 ethForLiquidity = ethBalance;
917 
918         uint256 ethForOperations = (ethBalance * tokensForOperations) /
919             (totalTokensToSwap - (tokensForLiquidity / 2));
920         uint256 ethForStaking = (ethBalance * tokensForStaking) /
921             (totalTokensToSwap - (tokensForLiquidity / 2));
922 
923         ethForLiquidity -= ethForOperations + ethForStaking;
924 
925         tokensForLiquidity = 0;
926         tokensForOperations = 0;
927         tokensForStaking = 0;
928 
929         if (liquidityTokens > 0 && ethForLiquidity > 0) {
930             addLiquidity(liquidityTokens, ethForLiquidity);
931         }
932 
933         (success, ) = address(stakingAddress).call{value: ethForStaking}("");
934         (success, ) = address(operationsAddress).call{
935             value: address(this).balance
936         }("");
937     }
938 
939     function transferForeignToken(address _token, address _to)
940         external
941         onlyOwner
942         returns (bool _sent)
943     {
944         require(_token != address(0), "_token address cannot be 0");
945         require(
946             _token != address(this) || !tradingActive,
947             "Can't withdraw native tokens while trading is active"
948         );
949         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
950         _sent = IERC20(_token).transfer(_to, _contractBalance);
951         emit TransferForeignToken(_token, _contractBalance);
952     }
953 
954     // withdraw ETH if stuck or someone sends to the address
955     function withdrawStuckETH() external onlyOwner {
956         bool success;
957         (success, ) = address(msg.sender).call{value: address(this).balance}(
958             ""
959         );
960     }
961 
962     function setOperationsAddress(address _operationsAddress)
963         external
964         onlyOwner
965     {
966         require(
967             _operationsAddress != address(0),
968             "_operationsAddress address cannot be 0"
969         );
970         operationsAddress = payable(_operationsAddress);
971         emit UpdatedOperationsAddress(_operationsAddress);
972     }
973 
974     function setStakingAddress(address _stakingAddress) external onlyOwner {
975         require(
976             _stakingAddress != address(0),
977             "_operationsAddress address cannot be 0"
978         );
979         stakingAddress = payable(_stakingAddress);
980         emit UpdatedStakingAddress(_stakingAddress);
981     }
982 
983     // remove limits after token is stable
984     function removeLimits() external onlyOwner {
985         limitsInEffect = false;
986     }
987 
988     function restoreLimits() external onlyOwner {
989         limitsInEffect = true;
990     }
991 
992     function launch(uint256 blocksForPenalty) external onlyOwner {
993         require(!tradingActive, "Trading is already active, cannot relaunch.");
994         require(
995             blocksForPenalty < 10,
996             "Cannot make penalty blocks more than 10"
997         );
998 
999         //standard enable trading
1000         tradingActive = true;
1001         swapEnabled = true;
1002         tradingActiveBlock = block.number;
1003         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1004         emit EnabledTrading();
1005 
1006         // add the liquidity
1007         require(
1008             address(this).balance > 0,
1009             "Must have ETH on contract to launch"
1010         );
1011         require(
1012             balanceOf(address(this)) > 0,
1013             "Must have Tokens on contract to launch"
1014         );
1015 
1016         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1017 
1018         dexRouter.addLiquidityETH{value: address(this).balance}(
1019             address(this),
1020             balanceOf(address(this)),
1021             0, // slippage is unavoidable
1022             0, // slippage is unavoidable
1023             address(this),
1024             block.timestamp
1025         );
1026     }
1027 }