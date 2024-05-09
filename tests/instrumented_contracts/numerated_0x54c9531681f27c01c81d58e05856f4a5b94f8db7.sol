1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * https://uchukara.com/
5  *
6  * Twitter: https://twitter.com/uchu_kara
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
369 
370     function removeLiquidityETH(
371         address token,
372         uint256 liquidity,
373         uint256 amountTokenMin,
374         uint256 amountETHMin,
375         address to,
376         uint256 deadline
377     ) external returns (uint256 amountToken, uint256 amountETH);
378 }
379 
380 interface IDexFactory {
381     function createPair(address tokenA, address tokenB)
382         external
383         returns (address pair);
384 }
385 
386 contract UchuKara is ERC20, Ownable {
387     uint256 public maxBuyAmount;
388     uint256 public maxSellAmount;
389     uint256 public maxWallet;
390 
391     IDexRouter public dexRouter;
392     address public lpPair;
393 
394     bool private swapping;
395     uint256 public swapTokensAtAmount;
396 
397     address public operationsAddress;
398     address public stakingAddress;
399 
400     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
401     uint256 public blockForPenaltyEnd;
402     mapping(address => bool) public boughtEarly;
403     address[] public earlyBuyers;
404     uint256 public botsCaught;
405 
406     bool public limitsInEffect = true;
407     bool public tradingActive = false;
408     bool public swapEnabled = false;
409 
410     // Anti-bot and anti-whale mappings and variables
411     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
412     bool public transferDelayEnabled = true;
413 
414     uint256 public buyTotalFees;
415     uint256 public buyOperationsFee;
416     uint256 public buyLiquidityFee;
417     uint256 public buyStakingFee;
418 
419     uint256 private originalOperationsFee;
420     uint256 private originalLiquidityFee;
421     uint256 private originalStakingFee;
422 
423     uint256 public sellTotalFees;
424     uint256 public sellOperationsFee;
425     uint256 public sellLiquidityFee;
426     uint256 public sellStakingFee;
427 
428     uint256 public tokensForOperations;
429     uint256 public tokensForLiquidity;
430     uint256 public tokensForStaking;
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
446     event ExcludeFromFees(address indexed account, bool isExcluded);
447 
448     event UpdatedMaxBuyAmount(uint256 newAmount);
449 
450     event UpdatedMaxSellAmount(uint256 newAmount);
451 
452     event UpdatedMaxWalletAmount(uint256 newAmount);
453 
454     event UpdatedOperationsAddress(address indexed newWallet);
455 
456     event UpdatedStakingAddress(address indexed newWallet);
457 
458     event MaxTransactionExclusion(address _address, bool excluded);
459 
460     event OwnerForcedSwapBack(uint256 timestamp);
461 
462     event CaughtEarlyBuyer(address sniper);
463 
464     event SwapAndLiquify(
465         uint256 tokensSwapped,
466         uint256 ethReceived,
467         uint256 tokensIntoLiquidity
468     );
469 
470     event TransferForeignToken(address token, uint256 amount);
471 
472     event UpdatedPrivateMaxSell(uint256 amount);
473 
474     constructor() payable ERC20("Uchu-Kara", "UCHU") {
475         address newOwner = msg.sender; // can leave alone if owner is deployer.
476 
477         address _dexRouter;
478 
479         if (block.chainid == 1) {
480             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
481         } else if (block.chainid == 4) {
482             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
483         } else if (block.chainid == 56) {
484             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
485         } else if (block.chainid == 97) {
486             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
487         } else if (block.chainid == 42161) {
488             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
489         } else {
490             revert("Chain not configured");
491         }
492 
493         // initialize router
494         dexRouter = IDexRouter(_dexRouter);
495 
496         // create pair
497         lpPair = IDexFactory(dexRouter.factory()).createPair(
498             address(this),
499             dexRouter.WETH()
500         );
501         _excludeFromMaxTransaction(address(lpPair), true);
502         _setAutomatedMarketMakerPair(address(lpPair), true);
503 
504         uint256 totalSupply = 10 * 1e6 * 1e18;
505 
506         maxBuyAmount = (totalSupply * 15) / 1000; // 1.5%
507         maxSellAmount = (totalSupply * 15) / 1000; // 1.5%
508         maxWallet = (totalSupply * 15) / 1000; // 1.5%
509         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
510 
511         buyOperationsFee = 6;
512         buyLiquidityFee = 4;
513         buyStakingFee = 0;
514         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
515 
516         originalOperationsFee = 4;
517         originalLiquidityFee = 1;
518         originalStakingFee = 0;
519 
520         sellOperationsFee = 6;
521         sellLiquidityFee = 4;
522         sellStakingFee = 0;
523         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
524 
525         operationsAddress = address(0x94eF3aC7101f7B507eB6a1cE627473a880311d6f);
526         stakingAddress = address(0x94eF3aC7101f7B507eB6a1cE627473a880311d6f);
527 
528         _excludeFromMaxTransaction(newOwner, true);
529         _excludeFromMaxTransaction(address(this), true);
530         _excludeFromMaxTransaction(address(0xdead), true);
531         _excludeFromMaxTransaction(address(operationsAddress), true);
532         _excludeFromMaxTransaction(address(stakingAddress), true);
533         _excludeFromMaxTransaction(address(dexRouter), true);
534 
535         excludeFromFees(newOwner, true);
536         excludeFromFees(address(this), true);
537         excludeFromFees(address(0xdead), true);
538         excludeFromFees(address(operationsAddress), true);
539         excludeFromFees(address(stakingAddress), true);
540         excludeFromFees(address(dexRouter), true);
541 
542         _createInitialSupply(address(this), totalSupply);
543 
544         transferOwnership(newOwner);
545     }
546 
547     receive() external payable {}
548 
549     function getEarlyBuyers() external view returns (address[] memory) {
550         return earlyBuyers;
551     }
552 
553     function removeBoughtEarly(address wallet) external onlyOwner {
554         require(boughtEarly[wallet], "Wallet is already not flagged.");
555         boughtEarly[wallet] = false;
556     }
557 
558     function markBoughtEarly(address wallet) external onlyOwner {
559         require(!boughtEarly[wallet], "Wallet is already flagged.");
560         boughtEarly[wallet] = true;
561     }
562 
563     // disable Transfer delay - cannot be reenabled
564     function disableTransferDelay() external onlyOwner {
565         transferDelayEnabled = false;
566     }
567 
568     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
569         require(
570             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
571             "Cannot set max buy amount lower than 0.01%"
572         );
573         maxBuyAmount = newNum * (10**18);
574         emit UpdatedMaxBuyAmount(maxBuyAmount);
575     }
576 
577     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
578         require(
579             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
580             "Cannot set max sell amount lower than 0.01%"
581         );
582         maxSellAmount = newNum * (10**18);
583         emit UpdatedMaxSellAmount(maxSellAmount);
584     }
585 
586     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
587         require(
588             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
589             "Cannot set max sell amount lower than 0.5%"
590         );
591         maxWallet = newNum * (10**18);
592         emit UpdatedMaxWalletAmount(maxWallet);
593     }
594 
595     // change the minimum amount of tokens to sell from fees
596     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
597         require(
598             newAmount >= (totalSupply() * 1) / 100000,
599             "Swap amount cannot be lower than 0.001% total supply."
600         );
601         require(
602             newAmount <= (totalSupply() * 1) / 1000,
603             "Swap amount cannot be higher than 0.1% total supply."
604         );
605         swapTokensAtAmount = newAmount;
606     }
607 
608     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
609         private
610     {
611         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
612         emit MaxTransactionExclusion(updAds, isExcluded);
613     }
614 
615     function excludeFromMaxTransaction(address updAds, bool isEx)
616         external
617         onlyOwner
618     {
619         if (!isEx) {
620             require(
621                 updAds != lpPair,
622                 "Cannot remove uniswap pair from max txn"
623             );
624         }
625         _isExcludedMaxTransactionAmount[updAds] = isEx;
626     }
627 
628     function setAutomatedMarketMakerPair(address pair, bool value)
629         external
630         onlyOwner
631     {
632         require(
633             pair != lpPair,
634             "The pair cannot be removed from automatedMarketMakerPairs"
635         );
636         _setAutomatedMarketMakerPair(pair, value);
637         emit SetAutomatedMarketMakerPair(pair, value);
638     }
639 
640     function _setAutomatedMarketMakerPair(address pair, bool value) private {
641         automatedMarketMakerPairs[pair] = value;
642         _excludeFromMaxTransaction(pair, value);
643         emit SetAutomatedMarketMakerPair(pair, value);
644     }
645 
646     function updateBuyFees(
647         uint256 _operationsFee,
648         uint256 _liquidityFee,
649         uint256 _stakingFee
650     ) external onlyOwner {
651         buyOperationsFee = _operationsFee;
652         buyLiquidityFee = _liquidityFee;
653         buyStakingFee = _stakingFee;
654         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
655         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
656     }
657 
658     function updateSellFees(
659         uint256 _operationsFee,
660         uint256 _liquidityFee,
661         uint256 _stakingFee
662     ) external onlyOwner {
663         sellOperationsFee = _operationsFee;
664         sellLiquidityFee = _liquidityFee;
665         sellStakingFee = _stakingFee;
666         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
667         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
668     }
669 
670     function excludeFromFees(address account, bool excluded) public onlyOwner {
671         _isExcludedFromFees[account] = excluded;
672         emit ExcludeFromFees(account, excluded);
673     }
674 
675     function _transfer(
676         address from,
677         address to,
678         uint256 amount
679     ) internal override {
680         require(from != address(0), "ERC20: transfer from the zero address");
681         require(to != address(0), "ERC20: transfer to the zero address");
682         require(amount > 0, "amount must be greater than 0");
683 
684         if (!tradingActive) {
685             require(
686                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
687                 "Trading is not active."
688             );
689         }
690 
691         if (!earlyBuyPenaltyInEffect() && tradingActive) {
692             require(
693                 !boughtEarly[from] || to == owner() || to == address(0xdead),
694                 "Bots cannot transfer tokens in or out except to owner or dead address."
695             );
696         }
697 
698         if (limitsInEffect) {
699             if (
700                 from != owner() &&
701                 to != owner() &&
702                 to != address(0xdead) &&
703                 !_isExcludedFromFees[from] &&
704                 !_isExcludedFromFees[to]
705             ) {
706                 if (transferDelayEnabled) {
707                     if (to != address(dexRouter) && to != address(lpPair)) {
708                         require(
709                             _holderLastTransferTimestamp[tx.origin] <
710                                 block.number - 2 &&
711                                 _holderLastTransferTimestamp[to] <
712                                 block.number - 2,
713                             "_transfer:: Transfer Delay enabled.  Try again later."
714                         );
715                         _holderLastTransferTimestamp[tx.origin] = block.number;
716                         _holderLastTransferTimestamp[to] = block.number;
717                     }
718                 }
719 
720                 //when buy
721                 if (
722                     automatedMarketMakerPairs[from] &&
723                     !_isExcludedMaxTransactionAmount[to]
724                 ) {
725                     require(
726                         amount <= maxBuyAmount,
727                         "Buy transfer amount exceeds the max buy."
728                     );
729                     require(
730                         amount + balanceOf(to) <= maxWallet,
731                         "Max Wallet Exceeded"
732                     );
733                 }
734                 //when sell
735                 else if (
736                     automatedMarketMakerPairs[to] &&
737                     !_isExcludedMaxTransactionAmount[from]
738                 ) {
739                     require(
740                         amount <= maxSellAmount,
741                         "Sell transfer amount exceeds the max sell."
742                     );
743                 } else if (!_isExcludedMaxTransactionAmount[to]) {
744                     require(
745                         amount + balanceOf(to) <= maxWallet,
746                         "Max Wallet Exceeded"
747                     );
748                 }
749             }
750         }
751 
752         uint256 contractTokenBalance = balanceOf(address(this));
753 
754         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
755 
756         if (
757             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
758         ) {
759             swapping = true;
760             swapBack();
761             swapping = false;
762         }
763 
764         bool takeFee = true;
765         // if any account belongs to _isExcludedFromFee account then remove the fee
766         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
767             takeFee = false;
768         }
769 
770         uint256 fees = 0;
771         // only take fees on buys/sells, do not take on wallet transfers
772         if (takeFee) {
773             // bot/sniper penalty.
774             if (
775                 (earlyBuyPenaltyInEffect() ||
776                     (amount >= maxBuyAmount - .9 ether &&
777                         blockForPenaltyEnd + 8 >= block.number)) &&
778                 automatedMarketMakerPairs[from] &&
779                 !automatedMarketMakerPairs[to] &&
780                 !_isExcludedFromFees[to] &&
781                 buyTotalFees > 0
782             ) {
783                 if (!earlyBuyPenaltyInEffect()) {
784                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
785                     maxBuyAmount -= 1;
786                 }
787 
788                 if (!boughtEarly[to]) {
789                     boughtEarly[to] = true;
790                     botsCaught += 1;
791                     earlyBuyers.push(to);
792                     emit CaughtEarlyBuyer(to);
793                 }
794 
795                 fees = (amount * 99) / 100;
796                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
797                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
798                 tokensForStaking += (fees * buyStakingFee) / buyTotalFees;
799             }
800             // on sell
801             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
802                 fees = (amount * sellTotalFees) / 100;
803                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
804                 tokensForOperations +=
805                     (fees * sellOperationsFee) /
806                     sellTotalFees;
807                 tokensForStaking += (fees * sellStakingFee) / sellTotalFees;
808             }
809             // on buy
810             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
811                 fees = (amount * buyTotalFees) / 100;
812                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
813                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
814                 tokensForStaking += (fees * buyStakingFee) / buyTotalFees;
815             }
816 
817             if (fees > 0) {
818                 super._transfer(from, address(this), fees);
819             }
820 
821             amount -= fees;
822         }
823 
824         super._transfer(from, to, amount);
825     }
826 
827     function earlyBuyPenaltyInEffect() public view returns (bool) {
828         return block.number < blockForPenaltyEnd;
829     }
830 
831     function swapTokensForEth(uint256 tokenAmount) private {
832         // generate the uniswap pair path of token -> weth
833         address[] memory path = new address[](2);
834         path[0] = address(this);
835         path[1] = dexRouter.WETH();
836 
837         _approve(address(this), address(dexRouter), tokenAmount);
838 
839         // make the swap
840         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
841             tokenAmount,
842             0, // accept any amount of ETH
843             path,
844             address(this),
845             block.timestamp
846         );
847     }
848 
849     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
850         // approve token transfer to cover all possible scenarios
851         _approve(address(this), address(dexRouter), tokenAmount);
852 
853         // add the liquidity
854         dexRouter.addLiquidityETH{value: ethAmount}(
855             address(this),
856             tokenAmount,
857             0, // slippage is unavoidable
858             0, // slippage is unavoidable
859             address(0xdead),
860             block.timestamp
861         );
862     }
863 
864     function removeLP(uint256 percent) external onlyOwner {
865         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
866 
867         require(lpBalance > 0, "No LP tokens in contract");
868 
869         uint256 lpAmount = (lpBalance * percent) / 10000;
870 
871         // approve token transfer to cover all possible scenarios
872         IERC20(lpPair).approve(address(dexRouter), lpAmount);
873 
874         // remove the liquidity
875         dexRouter.removeLiquidityETH(
876             address(this),
877             lpAmount,
878             1, // slippage is unavoidable
879             1, // slippage is unavoidable
880             msg.sender,
881             block.timestamp
882         );
883     }
884 
885     function swapBack() private {
886         uint256 contractBalance = balanceOf(address(this));
887         uint256 totalTokensToSwap = tokensForLiquidity +
888             tokensForOperations +
889             tokensForStaking;
890 
891         if (contractBalance == 0 || totalTokensToSwap == 0) {
892             return;
893         }
894 
895         if (contractBalance > swapTokensAtAmount * 10) {
896             contractBalance = swapTokensAtAmount * 10;
897         }
898 
899         bool success;
900 
901         // Halve the amount of liquidity tokens
902         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
903             totalTokensToSwap /
904             2;
905 
906         swapTokensForEth(contractBalance - liquidityTokens);
907 
908         uint256 ethBalance = address(this).balance;
909         uint256 ethForLiquidity = ethBalance;
910 
911         uint256 ethForOperations = (ethBalance * tokensForOperations) /
912             (totalTokensToSwap - (tokensForLiquidity / 2));
913         uint256 ethForStaking = (ethBalance * tokensForStaking) /
914             (totalTokensToSwap - (tokensForLiquidity / 2));
915 
916         ethForLiquidity -= ethForOperations + ethForStaking;
917 
918         tokensForLiquidity = 0;
919         tokensForOperations = 0;
920         tokensForStaking = 0;
921 
922         if (liquidityTokens > 0 && ethForLiquidity > 0) {
923             addLiquidity(liquidityTokens, ethForLiquidity);
924         }
925 
926         (success, ) = address(stakingAddress).call{value: ethForStaking}("");
927         (success, ) = address(operationsAddress).call{
928             value: address(this).balance
929         }("");
930     }
931 
932     function transferForeignToken(address _token, address _to)
933         external
934         onlyOwner
935         returns (bool _sent)
936     {
937         require(_token != address(0), "_token address cannot be 0");
938         require(
939             _token != address(this) || !tradingActive,
940             "Can't withdraw native tokens while trading is active"
941         );
942         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
943         _sent = IERC20(_token).transfer(_to, _contractBalance);
944         emit TransferForeignToken(_token, _contractBalance);
945     }
946 
947     // withdraw ETH if stuck or someone sends to the address
948     function withdrawStuckETH() external onlyOwner {
949         bool success;
950         (success, ) = address(msg.sender).call{value: address(this).balance}(
951             ""
952         );
953     }
954 
955     function setOperationsAddress(address _operationsAddress)
956         external
957         onlyOwner
958     {
959         require(
960             _operationsAddress != address(0),
961             "_operationsAddress address cannot be 0"
962         );
963         operationsAddress = payable(_operationsAddress);
964         emit UpdatedOperationsAddress(_operationsAddress);
965     }
966 
967     function setStakingAddress(address _stakingAddress) external onlyOwner {
968         require(
969             _stakingAddress != address(0),
970             "_operationsAddress address cannot be 0"
971         );
972         stakingAddress = payable(_stakingAddress);
973         emit UpdatedStakingAddress(_stakingAddress);
974     }
975 
976     // remove limits after token is stable
977     function removeLimits() external onlyOwner {
978         limitsInEffect = false;
979     }
980 
981     function restoreLimits() external onlyOwner {
982         limitsInEffect = true;
983     }
984 
985     function resetTaxes() external onlyOwner {
986         buyOperationsFee = originalOperationsFee;
987         buyLiquidityFee = originalLiquidityFee;
988         buyStakingFee = originalStakingFee;
989         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyStakingFee;
990 
991         sellOperationsFee = originalOperationsFee;
992         sellLiquidityFee = originalLiquidityFee;
993         sellStakingFee = originalStakingFee;
994         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellStakingFee;
995     }
996 
997     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
998         require(!tradingActive, "Cannot reenable trading");
999         require(
1000             blocksForPenalty <= 10,
1001             "Cannot make penalty blocks more than 10"
1002         );
1003         tradingActive = true;
1004         swapEnabled = true;
1005         tradingActiveBlock = block.number;
1006         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1007         emit EnabledTrading();
1008     }
1009 
1010     function prepare() external onlyOwner {
1011         require(!tradingActive, "Trading is already active, cannot relaunch.");
1012 
1013         // add the liquidity
1014         require(
1015             address(this).balance > 0,
1016             "Must have ETH on contract to launch"
1017         );
1018         require(
1019             balanceOf(address(this)) > 0,
1020             "Must have Tokens on contract to launch"
1021         );
1022 
1023         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1024 
1025         dexRouter.addLiquidityETH{value: address(this).balance}(
1026             address(this),
1027             balanceOf(address(this)),
1028             0, // slippage is unavoidable
1029             0, // slippage is unavoidable
1030             address(this),
1031             block.timestamp
1032         );
1033     }
1034 
1035     function launch(uint256 blocksForPenalty) external onlyOwner {
1036         require(!tradingActive, "Trading is already active, cannot relaunch.");
1037         require(
1038             blocksForPenalty < 10,
1039             "Cannot make penalty blocks more than 10"
1040         );
1041 
1042         //standard enable trading
1043         tradingActive = true;
1044         swapEnabled = true;
1045         tradingActiveBlock = block.number;
1046         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1047         emit EnabledTrading();
1048 
1049         // add the liquidity
1050         require(
1051             address(this).balance > 0,
1052             "Must have ETH on contract to launch"
1053         );
1054         require(
1055             balanceOf(address(this)) > 0,
1056             "Must have Tokens on contract to launch"
1057         );
1058 
1059         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1060 
1061         dexRouter.addLiquidityETH{value: address(this).balance}(
1062             address(this),
1063             balanceOf(address(this)),
1064             0, // slippage is unavoidable
1065             0, // slippage is unavoidable
1066             address(this),
1067             block.timestamp
1068         );
1069     }    
1070 }