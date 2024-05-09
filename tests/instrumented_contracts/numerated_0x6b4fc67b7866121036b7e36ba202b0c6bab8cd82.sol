1 // SPDX-License-Identifier: MIT
2 /* 
3 
4     ‘The past can’t hurt you anymore, 
5     not unless you let it…’
6 
7     Vi Veri Veniversum Vivus Vici
8 
9     https://medium.com/@VendettaDAO_/v%C4%93n%C4%AB-f1af74b031b3
10 
11  */
12 pragma solidity 0.8.13;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount)
44         external
45         returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender)
55         external
56         view
57         returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(
103         address indexed owner,
104         address indexed spender,
105         uint256 value
106     );
107 }
108 
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140 
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual override returns (uint8) {
150         return 18;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address account)
158         public
159         view
160         virtual
161         override
162         returns (uint256)
163     {
164         return _balances[account];
165     }
166 
167     function transfer(address recipient, uint256 amount)
168         public
169         virtual
170         override
171         returns (bool)
172     {
173         _transfer(_msgSender(), recipient, amount);
174         return true;
175     }
176 
177     function allowance(address owner, address spender)
178         public
179         view
180         virtual
181         override
182         returns (uint256)
183     {
184         return _allowances[owner][spender];
185     }
186 
187     function approve(address spender, uint256 amount)
188         public
189         virtual
190         override
191         returns (bool)
192     {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) public virtual override returns (bool) {
202         _transfer(sender, recipient, amount);
203 
204         uint256 currentAllowance = _allowances[sender][_msgSender()];
205         require(
206             currentAllowance >= amount,
207             "ERC20: transfer amount exceeds allowance"
208         );
209         unchecked {
210             _approve(sender, _msgSender(), currentAllowance - amount);
211         }
212 
213         return true;
214     }
215 
216     function increaseAllowance(address spender, uint256 addedValue)
217         public
218         virtual
219         returns (bool)
220     {
221         _approve(
222             _msgSender(),
223             spender,
224             _allowances[_msgSender()][spender] + addedValue
225         );
226         return true;
227     }
228 
229     function decreaseAllowance(address spender, uint256 subtractedValue)
230         public
231         virtual
232         returns (bool)
233     {
234         uint256 currentAllowance = _allowances[_msgSender()][spender];
235         require(
236             currentAllowance >= subtractedValue,
237             "ERC20: decreased allowance below zero"
238         );
239         unchecked {
240             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
241         }
242 
243         return true;
244     }
245 
246     function _transfer(
247         address sender,
248         address recipient,
249         uint256 amount
250     ) internal virtual {
251         require(sender != address(0), "ERC20: transfer from the zero address");
252         require(recipient != address(0), "ERC20: transfer to the zero address");
253 
254         uint256 senderBalance = _balances[sender];
255         require(
256             senderBalance >= amount,
257             "ERC20: transfer amount exceeds balance"
258         );
259         unchecked {
260             _balances[sender] = senderBalance - amount;
261         }
262         _balances[recipient] += amount;
263 
264         emit Transfer(sender, recipient, amount);
265     }
266 
267     function _createInitialSupply(address account, uint256 amount)
268         internal
269         virtual
270     {
271         require(account != address(0), "ERC20: mint to the zero address");
272 
273         _totalSupply += amount;
274         _balances[account] += amount;
275         emit Transfer(address(0), account, amount);
276     }
277 
278     function _approve(
279         address owner,
280         address spender,
281         uint256 amount
282     ) internal virtual {
283         require(owner != address(0), "ERC20: approve from the zero address");
284         require(spender != address(0), "ERC20: approve to the zero address");
285 
286         _allowances[owner][spender] = amount;
287         emit Approval(owner, spender, amount);
288     }
289 }
290 
291 contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(
295         address indexed previousOwner,
296         address indexed newOwner
297     );
298 
299     constructor() {
300         address msgSender = _msgSender();
301         _owner = msgSender;
302         emit OwnershipTransferred(address(0), msgSender);
303     }
304 
305     function owner() public view returns (address) {
306         return _owner;
307     }
308 
309     modifier onlyOwner() {
310         require(_owner == _msgSender(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     function renounceOwnership() external virtual onlyOwner {
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
373 }
374 
375 interface IDexFactory {
376     function createPair(address tokenA, address tokenB)
377         external
378         returns (address pair);
379 }
380 
381 contract VendettaDAO is ERC20, Ownable {
382     uint256 public maxBuyAmount;
383     uint256 public maxSellAmount;
384     uint256 public maxWallet;
385 
386     IDexRouter public dexRouter;
387     address public lpPair;
388 
389     bool private swapping;
390     uint256 public swapTokensAtAmount;
391 
392     address public operationsAddress;
393     address public treasuryAddress;
394 
395     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
396     uint256 public blockForPenaltyEnd;
397     mapping(address => bool) public boughtEarly;
398     address[] public earlyBuyers;
399     uint256 public botsCaught;
400 
401     bool public limitsInEffect = true;
402     bool public tradingActive = false;
403     bool public swapEnabled = false;
404 
405     // Anti-bot and anti-whale mappings and variables
406     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
407     bool public transferDelayEnabled = true;
408 
409     uint256 public buyTotalFees;
410     uint256 public buyOperationsFee;
411     uint256 public buyLiquidityFee;
412     uint256 public buyTreasuryFee;
413 
414     uint256 private originalSellOperationsFee;
415     uint256 private originalSellLiquidityFee;
416     uint256 private originalSellTreasuryFee;
417 
418     uint256 public sellTotalFees;
419     uint256 public sellOperationsFee;
420     uint256 public sellLiquidityFee;
421     uint256 public sellTreasuryFee;
422 
423     uint256 public tokensForOperations;
424     uint256 public tokensForLiquidity;
425     uint256 public tokensForTreasury;
426 
427     /******************/
428 
429     // exlcude from fees and max transaction amount
430     mapping(address => bool) private _isExcludedFromFees;
431     mapping(address => bool) public _isExcludedMaxTransactionAmount;
432 
433     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
434     // could be subject to a maximum transfer amount
435     mapping(address => bool) public automatedMarketMakerPairs;
436 
437     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
438 
439     event EnabledTrading();
440 
441     event ExcludeFromFees(address indexed account, bool isExcluded);
442 
443     event UpdatedMaxBuyAmount(uint256 newAmount);
444 
445     event UpdatedMaxSellAmount(uint256 newAmount);
446 
447     event UpdatedMaxWalletAmount(uint256 newAmount);
448 
449     event UpdatedOperationsAddress(address indexed newWallet);
450 
451     event UpdatedTreasuryAddress(address indexed newWallet);
452 
453     event MaxTransactionExclusion(address _address, bool excluded);
454 
455     event OwnerForcedSwapBack(uint256 timestamp);
456 
457     event CaughtEarlyBuyer(address sniper);
458 
459     event SwapAndLiquify(
460         uint256 tokensSwapped,
461         uint256 ethReceived,
462         uint256 tokensIntoLiquidity
463     );
464 
465     event TransferForeignToken(address token, uint256 amount);
466 
467     event UpdatedPrivateMaxSell(uint256 amount);
468 
469     constructor() payable ERC20("VendettaDAO", "V") {
470         address newOwner = msg.sender; // can leave alone if owner is deployer.
471 
472         // initialize router
473         IDexRouter _dexRouter = IDexRouter(
474             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
475         );
476         dexRouter = _dexRouter;
477 
478         // create pair
479         lpPair = IDexFactory(dexRouter.factory()).createPair(
480             address(this),
481             dexRouter.WETH()
482         );
483         _excludeFromMaxTransaction(address(lpPair), true);
484         _setAutomatedMarketMakerPair(address(lpPair), true);        
485 
486         uint256 totalSupply = 1 * 1e9 * 1e18; // 100 million
487 
488         maxBuyAmount = (totalSupply * 25) / 1000; // 2.5%
489         maxSellAmount = (totalSupply * 25) / 1000; // 2.5%
490         maxWallet = (totalSupply * 3) / 100; // 3%
491         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
492 
493         buyOperationsFee = 1;
494         buyLiquidityFee = 1;
495         buyTreasuryFee = 2;
496         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
497 
498         originalSellOperationsFee = 1;
499         originalSellLiquidityFee = 1;
500         originalSellTreasuryFee = 2;
501 
502         sellOperationsFee = 1;
503         sellLiquidityFee = 1;
504         sellTreasuryFee = 2;
505         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
506 
507         operationsAddress = address(0x53D24f2CE3Dda1217E4214349E748f4f57AB140D);
508         treasuryAddress = address(0xb70124D0C22e1f8d72D92DbAAB046556FFafF5F8);
509 
510         _excludeFromMaxTransaction(newOwner, true);
511         _excludeFromMaxTransaction(address(this), true);
512         _excludeFromMaxTransaction(address(0xdead), true);
513         _excludeFromMaxTransaction(address(operationsAddress), true);
514         _excludeFromMaxTransaction(address(treasuryAddress), true);
515 
516         excludeFromFees(newOwner, true);
517         excludeFromFees(address(this), true);
518         excludeFromFees(address(0xdead), true);
519         excludeFromFees(address(operationsAddress), true);
520         excludeFromFees(address(treasuryAddress), true);
521 
522         _createInitialSupply(address(0xdead), (totalSupply * 25) / 100); // Burn
523         _createInitialSupply(address(this), (totalSupply * 75) / 100); // Tokens for liquidity
524 
525         transferOwnership(newOwner);
526     }
527 
528     receive() external payable {}
529 
530     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
531         require(!tradingActive, "Cannot reenable trading");
532         require(
533             blocksForPenalty <= 10,
534             "Cannot make penalty blocks more than 10"
535         );
536         tradingActive = true;
537         swapEnabled = true;
538         tradingActiveBlock = block.number;
539         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
540         emit EnabledTrading();
541     }
542 
543     function getEarlyBuyers() external view returns (address[] memory) {
544         return earlyBuyers;
545     }
546 
547     function removeBoughtEarly(address wallet) external onlyOwner {
548         require(boughtEarly[wallet], "Wallet is already not flagged.");
549         boughtEarly[wallet] = false;
550     }
551 
552     function emergencyUpdateRouter(address router) external onlyOwner {
553         require(!tradingActive, "Cannot update after trading is functional");
554         dexRouter = IDexRouter(router);
555     }
556 
557     // disable Transfer delay - cannot be reenabled
558     function disableTransferDelay() external onlyOwner {
559         transferDelayEnabled = false;
560     }
561 
562     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
563         require(
564             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
565             "Cannot set max buy amount lower than 0.01%"
566         );
567         maxBuyAmount = newNum * (10**18);
568         emit UpdatedMaxBuyAmount(maxBuyAmount);
569     }
570 
571     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
572         require(
573             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
574             "Cannot set max sell amount lower than 0.01%"
575         );
576         maxSellAmount = newNum * (10**18);
577         emit UpdatedMaxSellAmount(maxSellAmount);
578     }
579 
580     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
581         require(
582             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
583             "Cannot set max sell amount lower than 0.5%"
584         );
585         maxWallet = newNum * (10**18);
586         emit UpdatedMaxWalletAmount(maxWallet);
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
630         _setAutomatedMarketMakerPair(pair, value);
631         emit SetAutomatedMarketMakerPair(pair, value);
632     }
633 
634     function _setAutomatedMarketMakerPair(address pair, bool value) private {
635         automatedMarketMakerPairs[pair] = value;
636         _excludeFromMaxTransaction(pair, value);
637         emit SetAutomatedMarketMakerPair(pair, value);
638     }
639 
640     function updateBuyFees(
641         uint256 _operationsFee,
642         uint256 _liquidityFee,
643         uint256 _treasuryFee
644     ) external onlyOwner {
645         buyOperationsFee = _operationsFee;
646         buyLiquidityFee = _liquidityFee;
647         buyTreasuryFee = _treasuryFee;
648         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
649         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
650     }
651 
652     function updateSellFees(
653         uint256 _operationsFee,
654         uint256 _liquidityFee,
655         uint256 _treasuryFee
656     ) external onlyOwner {
657         sellOperationsFee = _operationsFee;
658         sellLiquidityFee = _liquidityFee;
659         sellTreasuryFee = _treasuryFee;
660         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
661         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
662     }
663 
664     function restoreTaxes() external onlyOwner {
665         sellOperationsFee = originalSellOperationsFee;
666         sellLiquidityFee = originalSellLiquidityFee;
667         sellTreasuryFee = originalSellTreasuryFee;
668         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
669     }
670 
671     function excludeFromFees(address account, bool excluded) public onlyOwner {
672         _isExcludedFromFees[account] = excluded;
673         emit ExcludeFromFees(account, excluded);
674     }
675 
676     function _transfer(
677         address from,
678         address to,
679         uint256 amount
680     ) internal override {
681         require(from != address(0), "ERC20: transfer from the zero address");
682         require(to != address(0), "ERC20: transfer to the zero address");
683         require(amount > 0, "amount must be greater than 0");
684 
685         if (!tradingActive) {
686             require(
687                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
688                 "Trading is not active."
689             );
690         }
691 
692         if (!earlyBuyPenaltyInEffect() && tradingActive) {
693             require(
694                 !boughtEarly[from] || to == owner() || to == address(0xdead),
695                 "Bots cannot transfer tokens in or out except to owner or dead address."
696             );
697         }
698 
699         if (limitsInEffect) {
700             if (
701                 from != owner() &&
702                 to != owner() &&
703                 to != address(0xdead) &&
704                 !_isExcludedFromFees[from] &&
705                 !_isExcludedFromFees[to]
706             ) {
707                 if (transferDelayEnabled) {
708                     if (to != address(dexRouter) && to != address(lpPair)) {
709                         require(
710                             _holderLastTransferTimestamp[tx.origin] <
711                                 block.number - 2 &&
712                                 _holderLastTransferTimestamp[to] <
713                                 block.number - 2,
714                             "_transfer:: Transfer Delay enabled.  Try again later."
715                         );
716                         _holderLastTransferTimestamp[tx.origin] = block.number;
717                         _holderLastTransferTimestamp[to] = block.number;
718                     }
719                 }
720 
721                 //when buy
722                 if (
723                     automatedMarketMakerPairs[from] &&
724                     !_isExcludedMaxTransactionAmount[to]
725                 ) {
726                     require(
727                         amount <= maxBuyAmount,
728                         "Buy transfer amount exceeds the max buy."
729                     );
730                     require(
731                         amount + balanceOf(to) <= maxWallet,
732                         "Max Wallet Exceeded"
733                     );
734                 }
735                 //when sell
736                 else if (
737                     automatedMarketMakerPairs[to] &&
738                     !_isExcludedMaxTransactionAmount[from]
739                 ) {
740                     require(
741                         amount <= maxSellAmount,
742                         "Sell transfer amount exceeds the max sell."
743                     );
744                 } else if (!_isExcludedMaxTransactionAmount[to]) {
745                     require(
746                         amount + balanceOf(to) <= maxWallet,
747                         "Max Wallet Exceeded"
748                     );
749                 }
750             }
751         }
752 
753         uint256 contractTokenBalance = balanceOf(address(this));
754 
755         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
756 
757         if (
758             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
759         ) {
760             swapping = true;
761             swapBack();
762             swapping = false;
763         }
764 
765         bool takeFee = true;
766         // if any account belongs to _isExcludedFromFee account then remove the fee
767         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
768             takeFee = false;
769         }
770 
771         uint256 fees = 0;
772         // only take fees on buys/sells, do not take on wallet transfers
773         if (takeFee) {
774             // bot/sniper penalty.
775             if (
776                 (earlyBuyPenaltyInEffect() ||
777                     (amount >= maxBuyAmount - .9 ether &&
778                         blockForPenaltyEnd + 8 >= block.number)) &&
779                 automatedMarketMakerPairs[from] &&
780                 !automatedMarketMakerPairs[to] &&
781                 !_isExcludedFromFees[to] &&
782                 buyTotalFees > 0
783             ) {
784                 if (!earlyBuyPenaltyInEffect()) {
785                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
786                     maxBuyAmount -= 1;
787                 }
788 
789                 if (!boughtEarly[to]) {
790                     boughtEarly[to] = true;
791                     botsCaught += 1;
792                     earlyBuyers.push(to);
793                     emit CaughtEarlyBuyer(to);
794                 }
795 
796                 fees = (amount * 99) / 100; 
797                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
798                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
799                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
800             }
801             // on sell
802             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
803                 fees = (amount * sellTotalFees) / 100;
804                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
805                 tokensForOperations +=
806                     (fees * sellOperationsFee) /
807                     sellTotalFees;
808                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
809             }
810             // on buy
811             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
812                 fees = (amount * buyTotalFees) / 100;
813                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
814                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
815                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
816             }
817 
818             if (fees > 0) {
819                 super._transfer(from, address(this), fees);
820             }
821 
822             amount -= fees;
823         }
824 
825         super._transfer(from, to, amount);
826     }
827 
828     function earlyBuyPenaltyInEffect() public view returns (bool) {
829         return block.number < blockForPenaltyEnd;
830     }
831 
832     function swapTokensForEth(uint256 tokenAmount) private {
833         // generate the uniswap pair path of token -> weth
834         address[] memory path = new address[](2);
835         path[0] = address(this);
836         path[1] = dexRouter.WETH();
837 
838         _approve(address(this), address(dexRouter), tokenAmount);
839 
840         // make the swap
841         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
842             tokenAmount,
843             0, // accept any amount of ETH
844             path,
845             address(this),
846             block.timestamp
847         );
848     }
849 
850     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
851         // approve token transfer to cover all possible scenarios
852         _approve(address(this), address(dexRouter), tokenAmount);
853 
854         // add the liquidity
855         dexRouter.addLiquidityETH{value: ethAmount}(
856             address(this),
857             tokenAmount,
858             0, // slippage is unavoidable
859             0, // slippage is unavoidable
860             address(0xdead),
861             block.timestamp
862         );
863     }
864 
865     function swapBack() private {
866         uint256 contractBalance = balanceOf(address(this));
867         uint256 totalTokensToSwap = tokensForLiquidity +
868             tokensForOperations +
869             tokensForTreasury;
870 
871         if (contractBalance == 0 || totalTokensToSwap == 0) {
872             return;
873         }
874 
875         if (contractBalance > swapTokensAtAmount * 10) {
876             contractBalance = swapTokensAtAmount * 10;
877         }
878 
879         bool success;
880 
881         // Halve the amount of liquidity tokens
882         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
883             totalTokensToSwap /
884             2;
885 
886         swapTokensForEth(contractBalance - liquidityTokens);
887 
888         uint256 ethBalance = address(this).balance;
889         uint256 ethForLiquidity = ethBalance;
890 
891         uint256 ethForOperations = (ethBalance * tokensForOperations) /
892             (totalTokensToSwap - (tokensForLiquidity / 2));
893         uint256 ethForStaking = (ethBalance * tokensForTreasury) /
894             (totalTokensToSwap - (tokensForLiquidity / 2));
895 
896         ethForLiquidity -= ethForOperations + ethForStaking;
897 
898         tokensForLiquidity = 0;
899         tokensForOperations = 0;
900         tokensForTreasury = 0;
901 
902         if (liquidityTokens > 0 && ethForLiquidity > 0) {
903             addLiquidity(liquidityTokens, ethForLiquidity);
904         }
905 
906         (success, ) = address(treasuryAddress).call{value: ethForStaking}("");
907         (success, ) = address(operationsAddress).call{
908             value: address(this).balance
909         }("");
910     }
911 
912     function transferForeignToken(address _token, address _to)
913         external
914         onlyOwner
915         returns (bool _sent)
916     {
917         require(_token != address(0), "_token address cannot be 0");
918         require(
919             _token != address(this) || !tradingActive,
920             "Can't withdraw native tokens while trading is active"
921         );
922         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
923         _sent = IERC20(_token).transfer(_to, _contractBalance);
924         emit TransferForeignToken(_token, _contractBalance);
925     }
926 
927     // withdraw ETH if stuck or someone sends to the address
928     function withdrawStuckETH() external onlyOwner {
929         bool success;
930         (success, ) = address(msg.sender).call{value: address(this).balance}(
931             ""
932         );
933     }
934 
935     function setOperationsAddress(address _operationsAddress)
936         external
937         onlyOwner
938     {
939         require(
940             _operationsAddress != address(0),
941             "_operationsAddress address cannot be 0"
942         );
943         operationsAddress = payable(_operationsAddress);
944         emit UpdatedOperationsAddress(_operationsAddress);
945     }
946 
947     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
948         require(
949             _treasuryAddress != address(0),
950             "_operationsAddress address cannot be 0"
951         );
952         treasuryAddress = payable(_treasuryAddress);
953         emit UpdatedTreasuryAddress(_treasuryAddress);
954     }
955 
956     // force Swap back if slippage issues.
957     function forceSwapBack() external onlyOwner {
958         require(
959             balanceOf(address(this)) >= swapTokensAtAmount,
960             "Can only swap when token amount is at or higher than restriction"
961         );
962         swapping = true;
963         swapBack();
964         swapping = false;
965         emit OwnerForcedSwapBack(block.timestamp);
966     }
967 
968     // remove limits after token is stable
969     function removeLimits() external onlyOwner {
970         limitsInEffect = false;
971     }
972 
973     function restoreLimits() external onlyOwner {
974         limitsInEffect = true;
975     }
976 
977     function abeamus(uint256 blocksForPenalty) external onlyOwner {
978         require(!tradingActive, "Trading is already active, cannot relaunch.");
979         require(
980             blocksForPenalty < 10,
981             "Cannot make penalty blocks more than 10"
982         );
983 
984         //standard enable trading
985         tradingActive = true;
986         swapEnabled = true;
987         tradingActiveBlock = block.number;
988         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
989         emit EnabledTrading();
990 
991         // add the liquidity
992         require(
993             address(this).balance > 0,
994             "Must have ETH on contract to launch"
995         );
996         require(
997             balanceOf(address(this)) > 0,
998             "Must have Tokens on contract to launch"
999         );
1000 
1001         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1002 
1003         dexRouter.addLiquidityETH{value: address(this).balance}(
1004             address(this),
1005             balanceOf(address(this)),
1006             0, // slippage is unavoidable
1007             0, // slippage is unavoidable
1008             msg.sender,
1009             block.timestamp
1010         );
1011     }    
1012 }