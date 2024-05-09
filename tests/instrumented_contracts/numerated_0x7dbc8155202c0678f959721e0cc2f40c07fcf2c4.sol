1 // SPDX-License-Identifier: MIT
2 
3 // REBIRTH TOKEN
4 //
5 // Contract devs:
6 //
7 // @seanking52, @TrevorLaheyofficiaL, @JigsawOfficial
8 //
9 
10 pragma solidity 0.8.13;
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
42         external
43         returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender)
53         external
54         view
55         returns (uint256);
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
156         public
157         view
158         virtual
159         override
160         returns (uint256)
161     {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount)
166         public
167         virtual
168         override
169         returns (bool)
170     {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     function allowance(address owner, address spender)
176         public
177         view
178         virtual
179         override
180         returns (uint256)
181     {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount)
186         public
187         virtual
188         override
189         returns (bool)
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
215         public
216         virtual
217         returns (bool)
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
228         public
229         virtual
230         returns (bool)
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
266         internal
267         virtual
268     {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _totalSupply += amount;
272         _balances[account] += amount;
273         emit Transfer(address(0), account, amount);
274     }
275 
276     function _approve(
277         address owner,
278         address spender,
279         uint256 amount
280     ) internal virtual {
281         require(owner != address(0), "ERC20: approve from the zero address");
282         require(spender != address(0), "ERC20: approve to the zero address");
283 
284         _allowances[owner][spender] = amount;
285         emit Approval(owner, spender, amount);
286     }
287 }
288 
289 contract Ownable is Context {
290     address private _owner;
291 
292     event OwnershipTransferred(
293         address indexed previousOwner,
294         address indexed newOwner
295     );
296 
297     constructor() {
298         address msgSender = _msgSender();
299         _owner = msgSender;
300         emit OwnershipTransferred(address(0), msgSender);
301     }
302 
303     function owner() public view returns (address) {
304         return _owner;
305     }
306 
307     modifier onlyOwner() {
308         require(_owner == _msgSender(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     function renounceOwnership() external virtual onlyOwner {
313         emit OwnershipTransferred(_owner, address(0));
314         _owner = address(0);
315     }
316 
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(
319             newOwner != address(0),
320             "Ownable: new owner is the zero address"
321         );
322         emit OwnershipTransferred(_owner, newOwner);
323         _owner = newOwner;
324     }
325 }
326 
327 interface ILpPair {
328     function sync() external;
329 }
330 
331 interface IDexRouter {
332     function factory() external pure returns (address);
333 
334     function WETH() external pure returns (address);
335 
336     function swapExactTokensForETHSupportingFeeOnTransferTokens(
337         uint256 amountIn,
338         uint256 amountOutMin,
339         address[] calldata path,
340         address to,
341         uint256 deadline
342     ) external;
343 
344     function swapExactETHForTokensSupportingFeeOnTransferTokens(
345         uint256 amountOutMin,
346         address[] calldata path,
347         address to,
348         uint256 deadline
349     ) external payable;
350 
351     function addLiquidityETH(
352         address token,
353         uint256 amountTokenDesired,
354         uint256 amountTokenMin,
355         uint256 amountETHMin,
356         address to,
357         uint256 deadline
358     )
359         external
360         payable
361         returns (
362             uint256 amountToken,
363             uint256 amountETH,
364             uint256 liquidity
365         );
366 
367     function getAmountsOut(uint256 amountIn, address[] calldata path)
368         external
369         view
370         returns (uint256[] memory amounts);
371 }
372 
373 interface IDexFactory {
374     function createPair(address tokenA, address tokenB)
375         external
376         returns (address pair);
377 }
378 
379 contract Rebirth is ERC20, Ownable {
380     uint256 public maxBuyAmount;
381     uint256 public maxSellAmount;
382     uint256 public maxWallet;
383 
384     IDexRouter public dexRouter;
385     address public lpPair;
386 
387     bool private swapping;
388     uint256 public swapTokensAtAmount;
389 
390     address public operationsAddress;
391     address public treasuryAddress;
392 
393     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
394     uint256 public blockForPenaltyEnd;
395     mapping(address => bool) public boughtEarly;
396     address[] public earlyBuyers;
397     uint256 public botsCaught;
398 
399     bool public limitsInEffect = true;
400     bool public tradingActive = false;
401     bool public swapEnabled = false;
402     bool public privateSaleLimitsEnabled = true; 
403 
404     mapping(address => bool) public privateSaleWallets;
405     mapping(address => uint256) public nextPrivateWalletSellDate;
406     uint256 public maxPrivSaleSell = .50 ether;
407 
408     // Anti-bot and anti-whale mappings and variables
409     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
410     bool public transferDelayEnabled = true;
411 
412     uint256 public buyTotalFees;
413     uint256 public buyOperationsFee;
414     uint256 public buyLiquidityFee;
415     uint256 public buyTreasuryFee;
416 
417     uint256 private originalSellOperationsFee;
418     uint256 private originalSellLiquidityFee;
419     uint256 private originalSellTreasuryFee;
420 
421     uint256 public sellTotalFees;
422     uint256 public sellOperationsFee;
423     uint256 public sellLiquidityFee;
424     uint256 public sellTreasuryFee;
425 
426     uint256 public tokensForOperations;
427     uint256 public tokensForLiquidity;
428     uint256 public tokensForTreasury;
429 
430     /******************/
431 
432     // exlcude from fees and max transaction amount
433     mapping(address => bool) private _isExcludedFromFees;
434     mapping(address => bool) public _isExcludedMaxTransactionAmount;
435 
436     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
437     // could be subject to a maximum transfer amount
438     mapping(address => bool) public automatedMarketMakerPairs;
439 
440     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
441 
442     event EnabledTrading();
443 
444     event ExcludeFromFees(address indexed account, bool isExcluded);
445 
446     event UpdatedMaxBuyAmount(uint256 newAmount);
447 
448     event UpdatedMaxSellAmount(uint256 newAmount);
449 
450     event UpdatedMaxWalletAmount(uint256 newAmount);
451 
452     event UpdatedOperationsAddress(address indexed newWallet);
453 
454     event UpdatedTreasuryAddress(address indexed newWallet);
455 
456     event MaxTransactionExclusion(address _address, bool excluded);
457 
458     event OwnerForcedSwapBack(uint256 timestamp);
459 
460     event CaughtEarlyBuyer(address sniper);
461 
462     event SwapAndLiquify(
463         uint256 tokensSwapped,
464         uint256 ethReceived,
465         uint256 tokensIntoLiquidity
466     );
467 
468     event TransferForeignToken(address token, uint256 amount);
469 
470     event UpdatedPrivateMaxSell(uint256 amount);
471 
472     constructor() payable ERC20("Rebirth", "REBIRTH") {
473         address newOwner = msg.sender; // can leave alone if owner is deployer.
474 
475         // initialize router
476         IDexRouter _dexRouter = IDexRouter(
477             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
478         );
479         dexRouter = _dexRouter;
480 
481         uint256 totalSupply = 100 * 1e6 * 1e18; // 100 million
482 
483         // Reference: 1 ETH = 0.125%
484         maxBuyAmount = (totalSupply * 6) / 10000; // 0.06%
485         maxSellAmount = (totalSupply * 6) / 10000; // 0.06%
486         maxWallet = (totalSupply * 5) / 1000; // 0.5%
487         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
488 
489         buyOperationsFee = 4;
490         buyLiquidityFee = 1;
491         buyTreasuryFee = 3;
492         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
493 
494         originalSellOperationsFee = 4;
495         originalSellLiquidityFee = 1;
496         originalSellTreasuryFee = 3;
497 
498         sellOperationsFee = 4;
499         sellLiquidityFee = 1;
500         sellTreasuryFee = 3;
501         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
502 
503         operationsAddress = address(0xBeaf78AeF141B8A4c5e7649236a4d4a29A027D47);
504         treasuryAddress = address(0x043cBAE86Aba5c5f2ca0B71F0B10695a7CcbAffF);
505 
506         _excludeFromMaxTransaction(newOwner, true);
507         _excludeFromMaxTransaction(address(this), true);
508         _excludeFromMaxTransaction(address(0xdead), true);
509         _excludeFromMaxTransaction(address(operationsAddress), true);
510         _excludeFromMaxTransaction(address(treasuryAddress), true);
511         _excludeFromMaxTransaction(
512             0xD09E0d18d07eedF8c12A237EC4c70d0f810f03d2,
513             true
514         ); // Exchanges wallet
515 
516         excludeFromFees(newOwner, true);
517         excludeFromFees(address(this), true);
518         excludeFromFees(address(0xdead), true);
519         excludeFromFees(address(operationsAddress), true);
520         excludeFromFees(address(treasuryAddress), true);
521         excludeFromFees(0xD09E0d18d07eedF8c12A237EC4c70d0f810f03d2, true);
522 
523         _createInitialSupply(newOwner, (totalSupply * 42) / 1000); // Tokens for private salers
524         _createInitialSupply(
525             0xD09E0d18d07eedF8c12A237EC4c70d0f810f03d2,
526             (totalSupply * 5) / 100
527         ); // Exchanges wallet
528         _createInitialSupply(address(0xdead), (totalSupply * 878) / 1000); // Burn
529         _createInitialSupply(address(this), (totalSupply * 3) / 100); // Tokens for liquidity
530 
531         transferOwnership(newOwner);
532     }
533 
534     receive() external payable {}
535 
536     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
537         require(!tradingActive, "Cannot reenable trading");
538         require(
539             blocksForPenalty <= 10,
540             "Cannot make penalty blocks more than 10"
541         );
542         tradingActive = true;
543         swapEnabled = true;
544         tradingActiveBlock = block.number;
545         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
546         emit EnabledTrading();
547     }
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
558     function emergencyUpdateRouter(address router) external onlyOwner {
559         require(!tradingActive, "Cannot update after trading is functional");
560         dexRouter = IDexRouter(router);
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
615     function airdropToWallets(
616         address[] memory wallets,
617         uint256[] memory amountsInTokens
618     ) external onlyOwner {
619         require(
620             wallets.length == amountsInTokens.length,
621             "arrays must be the same length"
622         );
623         require(
624             wallets.length < 200,
625             "Can only airdrop 200 wallets per txn due to gas limits"
626         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
627         for (uint256 i = 0; i < wallets.length; i++) {
628             address wallet = wallets[i];
629             uint256 amount = amountsInTokens[i];
630             super._transfer(msg.sender, wallet, amount);
631         }
632     }
633 
634     function excludeFromMaxTransaction(address updAds, bool isEx)
635         external
636         onlyOwner
637     {
638         if (!isEx) {
639             require(
640                 updAds != lpPair,
641                 "Cannot remove uniswap pair from max txn"
642             );
643         }
644         _isExcludedMaxTransactionAmount[updAds] = isEx;
645     }
646 
647     function setAutomatedMarketMakerPair(address pair, bool value)
648         external
649         onlyOwner
650     {
651         require(
652             pair != lpPair,
653             "The pair cannot be removed from automatedMarketMakerPairs"
654         );
655         _setAutomatedMarketMakerPair(pair, value);
656         emit SetAutomatedMarketMakerPair(pair, value);
657     }
658 
659     function _setAutomatedMarketMakerPair(address pair, bool value) private {
660         automatedMarketMakerPairs[pair] = value;
661         _excludeFromMaxTransaction(pair, value);
662         emit SetAutomatedMarketMakerPair(pair, value);
663     }
664 
665     function updateBuyFees(
666         uint256 _operationsFee,
667         uint256 _liquidityFee,
668         uint256 _treasuryFee
669     ) external onlyOwner {
670         buyOperationsFee = _operationsFee;
671         buyLiquidityFee = _liquidityFee;
672         buyTreasuryFee = _treasuryFee;
673         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
674         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
675     }
676 
677     function updateSellFees(
678         uint256 _operationsFee,
679         uint256 _liquidityFee,
680         uint256 _treasuryFee
681     ) external onlyOwner {
682         sellOperationsFee = _operationsFee;
683         sellLiquidityFee = _liquidityFee;
684         sellTreasuryFee = _treasuryFee;
685         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
686         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
687     }
688 
689     function restoreTaxes() external onlyOwner {
690         sellOperationsFee = originalSellOperationsFee;
691         sellLiquidityFee = originalSellLiquidityFee;
692         sellTreasuryFee = originalSellTreasuryFee;
693         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
694     }
695 
696     function excludeFromFees(address account, bool excluded) public onlyOwner {
697         _isExcludedFromFees[account] = excluded;
698         emit ExcludeFromFees(account, excluded);
699     }
700 
701     function _transfer(
702         address from,
703         address to,
704         uint256 amount
705     ) internal override {
706         require(from != address(0), "ERC20: transfer from the zero address");
707         require(to != address(0), "ERC20: transfer to the zero address");
708         require(amount > 0, "amount must be greater than 0");
709 
710         if (!tradingActive) {
711             require(
712                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
713                 "Trading is not active."
714             );
715         }
716 
717         if (!earlyBuyPenaltyInEffect() && tradingActive) {
718             require(
719                 !boughtEarly[from] || to == owner() || to == address(0xdead),
720                 "Bots cannot transfer tokens in or out except to owner or dead address."
721             );
722         }
723         if (privateSaleLimitsEnabled) {
724             if (privateSaleWallets[from]) {
725                 if (automatedMarketMakerPairs[to]) {
726                     //enforce max sell restrictions.
727                     require(
728                         nextPrivateWalletSellDate[from] <= block.timestamp,
729                         "Cannot sell yet"
730                     );
731                     require(
732                         amount <= getPrivateSaleMaxSell(),
733                         "Attempting to sell over max sell amount.  Check max."
734                     );
735                     nextPrivateWalletSellDate[from] = block.timestamp + 24 hours;
736                 } else if (!_isExcludedFromFees[to]) {
737                     revert(
738                         "Private sale cannot transfer and must sell only or transfer to a whitelisted address."
739                     );
740                 }
741             }
742         }
743 
744         if (limitsInEffect) {
745             if (
746                 from != owner() &&
747                 to != owner() &&
748                 to != address(0xdead) &&
749                 !_isExcludedFromFees[from] &&
750                 !_isExcludedFromFees[to]
751             ) {
752                 if (transferDelayEnabled) {
753                     if (to != address(dexRouter) && to != address(lpPair)) {
754                         require(
755                             _holderLastTransferTimestamp[tx.origin] <
756                                 block.number - 2 &&
757                                 _holderLastTransferTimestamp[to] <
758                                 block.number - 2,
759                             "_transfer:: Transfer Delay enabled.  Try again later."
760                         );
761                         _holderLastTransferTimestamp[tx.origin] = block.number;
762                         _holderLastTransferTimestamp[to] = block.number;
763                     }
764                 }
765 
766                 //when buy
767                 if (
768                     automatedMarketMakerPairs[from] &&
769                     !_isExcludedMaxTransactionAmount[to]
770                 ) {
771                     require(
772                         amount <= maxBuyAmount,
773                         "Buy transfer amount exceeds the max buy."
774                     );
775                     require(
776                         amount + balanceOf(to) <= maxWallet,
777                         "Max Wallet Exceeded"
778                     );
779                 }
780                 //when sell
781                 else if (
782                     automatedMarketMakerPairs[to] &&
783                     !_isExcludedMaxTransactionAmount[from]
784                 ) {
785                     require(
786                         amount <= maxSellAmount,
787                         "Sell transfer amount exceeds the max sell."
788                     );
789                 } else if (!_isExcludedMaxTransactionAmount[to]) {
790                     require(
791                         amount + balanceOf(to) <= maxWallet,
792                         "Max Wallet Exceeded"
793                     );
794                 }
795             }
796         }
797 
798         uint256 contractTokenBalance = balanceOf(address(this));
799 
800         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
801 
802         if (
803             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
804         ) {
805             swapping = true;
806             swapBack();
807             swapping = false;
808         }
809 
810         bool takeFee = true;
811         // if any account belongs to _isExcludedFromFee account then remove the fee
812         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
813             takeFee = false;
814         }
815 
816         uint256 fees = 0;
817         // only take fees on buys/sells, do not take on wallet transfers
818         if (takeFee) {
819             // bot/sniper penalty.
820             if (
821                 (earlyBuyPenaltyInEffect() ||
822                     (amount >= maxBuyAmount - .9 ether &&
823                         blockForPenaltyEnd + 8 >= block.number)) &&
824                 automatedMarketMakerPairs[from] &&
825                 !automatedMarketMakerPairs[to] &&
826                 !_isExcludedFromFees[to] &&
827                 buyTotalFees > 0
828             ) {
829                 if (!earlyBuyPenaltyInEffect()) {
830                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
831                     maxBuyAmount -= 1;
832                 }
833 
834                 if (!boughtEarly[to]) {
835                     boughtEarly[to] = true;
836                     botsCaught += 1;
837                     earlyBuyers.push(to);
838                     emit CaughtEarlyBuyer(to);
839                 }
840 
841                 fees = (amount * 99) / 100; // tax bots with 99% :)
842                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
843                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
844                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
845             }
846             // on sell
847             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
848                 fees = (amount * sellTotalFees) / 100;
849                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
850                 tokensForOperations +=
851                     (fees * sellOperationsFee) /
852                     sellTotalFees;
853                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
854             }
855             // on buy
856             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
857                 fees = (amount * buyTotalFees) / 100;
858                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
859                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
860                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
861             }
862 
863             if (fees > 0) {
864                 super._transfer(from, address(this), fees);
865             }
866 
867             amount -= fees;
868         }
869 
870         super._transfer(from, to, amount);
871     }
872 
873     function earlyBuyPenaltyInEffect() public view returns (bool) {
874         return block.number < blockForPenaltyEnd;
875     }
876 
877     function swapTokensForEth(uint256 tokenAmount) private {
878         // generate the uniswap pair path of token -> weth
879         address[] memory path = new address[](2);
880         path[0] = address(this);
881         path[1] = dexRouter.WETH();
882 
883         _approve(address(this), address(dexRouter), tokenAmount);
884 
885         // make the swap
886         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
887             tokenAmount,
888             0, // accept any amount of ETH
889             path,
890             address(this),
891             block.timestamp
892         );
893     }
894 
895     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
896         // approve token transfer to cover all possible scenarios
897         _approve(address(this), address(dexRouter), tokenAmount);
898 
899         // add the liquidity
900         dexRouter.addLiquidityETH{value: ethAmount}(
901             address(this),
902             tokenAmount,
903             0, // slippage is unavoidable
904             0, // slippage is unavoidable
905             address(0xdead),
906             block.timestamp
907         );
908     }
909 
910     function swapBack() private {
911         uint256 contractBalance = balanceOf(address(this));
912         uint256 totalTokensToSwap = tokensForLiquidity +
913             tokensForOperations +
914             tokensForTreasury;
915 
916         if (contractBalance == 0 || totalTokensToSwap == 0) {
917             return;
918         }
919 
920         if (contractBalance > swapTokensAtAmount * 10) {
921             contractBalance = swapTokensAtAmount * 10;
922         }
923 
924         bool success;
925 
926         // Halve the amount of liquidity tokens
927         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
928             totalTokensToSwap /
929             2;
930 
931         swapTokensForEth(contractBalance - liquidityTokens);
932 
933         uint256 ethBalance = address(this).balance;
934         uint256 ethForLiquidity = ethBalance;
935 
936         uint256 ethForOperations = (ethBalance * tokensForOperations) /
937             (totalTokensToSwap - (tokensForLiquidity / 2));
938         uint256 ethForStaking = (ethBalance * tokensForTreasury) /
939             (totalTokensToSwap - (tokensForLiquidity / 2));
940 
941         ethForLiquidity -= ethForOperations + ethForStaking;
942 
943         tokensForLiquidity = 0;
944         tokensForOperations = 0;
945         tokensForTreasury = 0;
946 
947         if (liquidityTokens > 0 && ethForLiquidity > 0) {
948             addLiquidity(liquidityTokens, ethForLiquidity);
949         }
950 
951         (success, ) = address(treasuryAddress).call{value: ethForStaking}("");
952         (success, ) = address(operationsAddress).call{
953             value: address(this).balance
954         }("");
955     }
956 
957     function transferForeignToken(address _token, address _to)
958         external
959         onlyOwner
960         returns (bool _sent)
961     {
962         require(_token != address(0), "_token address cannot be 0");
963         require(
964             _token != address(this) || !tradingActive,
965             "Can't withdraw native tokens while trading is active"
966         );
967         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
968         _sent = IERC20(_token).transfer(_to, _contractBalance);
969         emit TransferForeignToken(_token, _contractBalance);
970     }
971 
972     // withdraw ETH if stuck or someone sends to the address
973     function withdrawStuckETH() external onlyOwner {
974         bool success;
975         (success, ) = address(msg.sender).call{value: address(this).balance}(
976             ""
977         );
978     }
979 
980     function setOperationsAddress(address _operationsAddress)
981         external
982         onlyOwner
983     {
984         require(
985             _operationsAddress != address(0),
986             "_operationsAddress address cannot be 0"
987         );
988         operationsAddress = payable(_operationsAddress);
989         emit UpdatedOperationsAddress(_operationsAddress);
990     }
991 
992     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
993         require(
994             _treasuryAddress != address(0),
995             "_operationsAddress address cannot be 0"
996         );
997         treasuryAddress = payable(_treasuryAddress);
998         emit UpdatedTreasuryAddress(_treasuryAddress);
999     }
1000 
1001     // force Swap back if slippage issues.
1002     function forceSwapBack() external onlyOwner {
1003         require(
1004             balanceOf(address(this)) >= swapTokensAtAmount,
1005             "Can only swap when token amount is at or higher than restriction"
1006         );
1007         swapping = true;
1008         swapBack();
1009         swapping = false;
1010         emit OwnerForcedSwapBack(block.timestamp);
1011     }
1012 
1013     function getPrivateSaleMaxSell() public view returns (uint256) {
1014         address[] memory path = new address[](2);
1015         path[0] = dexRouter.WETH();
1016         path[1] = address(this);
1017 
1018         uint256[] memory amounts = new uint256[](2);
1019         amounts = dexRouter.getAmountsOut(maxPrivSaleSell, path);
1020         return
1021             amounts[1] +
1022             (amounts[1] *
1023                 (sellLiquidityFee + sellOperationsFee + sellTreasuryFee)) /
1024             100;
1025     }
1026 
1027     function setPrivateSaleMaxSell(uint256 amount) external onlyOwner {
1028         require(
1029             amount >= 25 && amount <= 2500,
1030             "Must set between 0.25 and 25 ETH"
1031         );
1032         maxPrivSaleSell = amount * 1e16;
1033         emit UpdatedPrivateMaxSell(amount);
1034     }
1035 
1036     function emergencyTogglePrivateSaleLimits(bool _enabled) public onlyOwner {
1037         privateSaleLimitsEnabled = _enabled;
1038     }
1039 
1040     // remove limits after token is stable
1041     function removeLimits() external onlyOwner {
1042         limitsInEffect = false;
1043     }
1044 
1045     function restoreLimits() external onlyOwner {
1046         limitsInEffect = true;
1047     }
1048 
1049     function letsFuckingGo(
1050         address[] memory wallets,
1051         uint256[] memory amountsInTokens,
1052         uint256 blocksForPenalty
1053     ) external onlyOwner {
1054         require(!tradingActive, "Trading is already active, cannot relaunch.");
1055         require(
1056             blocksForPenalty < 10,
1057             "Cannot make penalty blocks more than 10"
1058         );
1059 
1060         require(
1061             wallets.length == amountsInTokens.length,
1062             "arrays must be the same length"
1063         );
1064         require(
1065             wallets.length < 200,
1066             "Can only airdrop 200 wallets per txn due to gas limits"
1067         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1068         for (uint256 i = 0; i < wallets.length; i++) {
1069             address wallet = wallets[i];
1070             privateSaleWallets[wallet] = true;
1071             nextPrivateWalletSellDate[wallet] = block.timestamp + 3 hours; // No sales in the first 6 hours after launch
1072             uint256 amount = amountsInTokens[i];
1073             super._transfer(msg.sender, wallet, amount);
1074         }
1075 
1076         //standard enable trading
1077         tradingActive = true;
1078         swapEnabled = true;
1079         tradingActiveBlock = block.number;
1080         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1081         emit EnabledTrading();
1082 
1083         // create pair
1084         lpPair = IDexFactory(dexRouter.factory()).createPair(
1085             address(this),
1086             dexRouter.WETH()
1087         );
1088         _excludeFromMaxTransaction(address(lpPair), true);
1089         _setAutomatedMarketMakerPair(address(lpPair), true);
1090 
1091         // add the liquidity
1092 
1093         require(
1094             address(this).balance > 0,
1095             "Must have ETH on contract to launch"
1096         );
1097 
1098         require(
1099             balanceOf(address(this)) > 0,
1100             "Must have Tokens on contract to launch"
1101         );
1102 
1103         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1104         dexRouter.addLiquidityETH{value: address(this).balance}(
1105             address(this),
1106             balanceOf(address(this)),
1107             0, // slippage is unavoidable
1108             0, // slippage is unavoidable
1109             address(msg.sender),
1110             block.timestamp
1111         );
1112     }
1113 }