1 // SPDX-License-Identifier: MIT
2 /*
3  *
4  *   https://shib-mania.com/
5  *
6  */
7 
8 pragma solidity 0.8.18;
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
386 contract SHIBMA is ERC20, Ownable {
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
397     address private operationsAddress;
398     address private aiBuyBackAddress;
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
409     bool public launchTaxModeEnabled = true;
410 
411     // Anti-bot and anti-whale mappings and variables
412     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
413     bool public transferDelayEnabled = true;
414 
415     uint256 public buyTotalFees;
416     uint256 public buyOperationsFee;
417     uint256 public buyLiquidityFee;
418     uint256 public buyAiBuyBackFee;
419 
420     uint256 private originalSellOperationsFee;
421     uint256 private originalSellLiquidityFee;
422     uint256 private originalSellAiBuyBackFee;
423 
424     uint256 public sellTotalFees;
425     uint256 public sellOperationsFee;
426     uint256 public sellLiquidityFee;
427     uint256 public sellAiBuyBackFee;
428 
429     uint256 public tokensForOperations;
430     uint256 public tokensForLiquidity;
431     uint256 public tokensForAiBuyBack;
432 
433     /******************/
434 
435     // exlcude from fees and max transaction amount
436     mapping(address => bool) private _isExcludedFromFees;
437     mapping(address => bool) public _isExcludedMaxTransactionAmount;
438 
439     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
440     // could be subject to a maximum transfer amount
441     mapping(address => bool) public automatedMarketMakerPairs;
442 
443     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
444 
445     event EnabledTrading();
446 
447     event ExcludeFromFees(address indexed account, bool isExcluded);
448 
449     event UpdatedMaxBuyAmount(uint256 newAmount);
450 
451     event UpdatedMaxSellAmount(uint256 newAmount);
452 
453     event UpdatedMaxWalletAmount(uint256 newAmount);
454 
455     event UpdatedOperationsAddress(address indexed newWallet);
456 
457     event UpdatedAiBuyBackAddress(address indexed newWallet);
458 
459     event MaxTransactionExclusion(address _address, bool excluded);
460 
461     event OwnerForcedSwapBack(uint256 timestamp);
462 
463     event CaughtEarlyBuyer(address sniper);
464 
465     event SwapAndLiquify(
466         uint256 tokensSwapped,
467         uint256 ethReceived,
468         uint256 tokensIntoLiquidity
469     );
470 
471     event TransferForeignToken(address token, uint256 amount);
472 
473     event DisabledLaunchTaxModeForever();
474 
475     constructor() payable ERC20("Shibmania", "SHIBMA") {
476         address newOwner = msg.sender; // can leave alone if owner is deployer.
477 
478         address _dexRouter;
479 
480         if (block.chainid == 1) {
481             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
482         } else if (block.chainid == 5) {
483             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: GOERLI
484         } else {
485             revert("Chain not configured");
486         }
487 
488         // initialize router
489         dexRouter = IDexRouter(_dexRouter);
490 
491         // create pair
492         lpPair = IDexFactory(dexRouter.factory()).createPair(
493             address(this),
494             dexRouter.WETH()
495         );
496         _excludeFromMaxTransaction(address(lpPair), true);
497         _setAutomatedMarketMakerPair(address(lpPair), true);
498 
499         uint256 totalSupply = 1 * 1e9 * 1e18;
500 
501         maxBuyAmount = (totalSupply * 1) / 100; // 1%
502         maxSellAmount = (totalSupply * 2) / 100; // 2%
503         maxWallet = (totalSupply * 2) / 100; // 2%
504         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
505 
506         buyOperationsFee = 30;
507         buyLiquidityFee = 0;
508         buyAiBuyBackFee = 0;
509         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyAiBuyBackFee;
510 
511         originalSellOperationsFee = 4;
512         originalSellLiquidityFee = 1;
513         originalSellAiBuyBackFee = 2;
514 
515         sellOperationsFee = 40;
516         sellLiquidityFee = 0;
517         sellAiBuyBackFee = 0;
518         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellAiBuyBackFee;
519 
520         operationsAddress = address(0x839ce32AEDDD469f8cCEb7f6CE98807aC4DCFE0B);
521         aiBuyBackAddress = address(0x895F842EE61c55fF34061D2fe2e89E1738ef29D6);
522 
523         _excludeFromMaxTransaction(newOwner, true);
524         _excludeFromMaxTransaction(address(this), true);
525         _excludeFromMaxTransaction(address(0xdead), true);
526         _excludeFromMaxTransaction(address(operationsAddress), true);
527         _excludeFromMaxTransaction(address(aiBuyBackAddress), true);
528         _excludeFromMaxTransaction(address(dexRouter), true);
529 
530         excludeFromFees(newOwner, true);
531         excludeFromFees(address(this), true);
532         excludeFromFees(address(0xdead), true);
533         excludeFromFees(address(operationsAddress), true);
534         excludeFromFees(address(aiBuyBackAddress), true);
535         excludeFromFees(address(dexRouter), true);
536 
537         _createInitialSupply(address(this), (totalSupply * 18) / 100); // Tokens for liquidity
538         _createInitialSupply(address(0xdead), (totalSupply * 32) / 100); // Burn
539         _createInitialSupply(newOwner, (totalSupply * 495) / 1000); // Spare
540         _createInitialSupply(
541             address(0xb72ce64D6b66b7246767A033511a686dD91F1390),
542             (totalSupply * 5) / 1000
543         ); // Dev
544 
545         transferOwnership(newOwner);
546     }
547 
548     receive() external payable {}
549 
550     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
551         require(!tradingActive, "Cannot reenable trading");
552         require(
553             blocksForPenalty <= 10,
554             "Cannot make penalty blocks more than 10"
555         );
556         tradingActive = true;
557         swapEnabled = true;
558         tradingActiveBlock = block.number;
559         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
560         emit EnabledTrading();
561     }
562 
563     function getEarlyBuyers() external view returns (address[] memory) {
564         return earlyBuyers;
565     }
566 
567     function addBoughtEarly(address wallet) external onlyOwner {
568         require(!boughtEarly[wallet], "Wallet is already flagged.");
569         boughtEarly[wallet] = true;
570     }
571 
572     function removeBoughtEarly(address wallet) external onlyOwner {
573         require(boughtEarly[wallet], "Wallet is already not flagged.");
574         boughtEarly[wallet] = false;
575     }
576 
577     function emergencyUpdateRouter(address router) external onlyOwner {
578         require(!tradingActive, "Cannot update after trading is functional");
579         dexRouter = IDexRouter(router);
580     }
581 
582     // disable Transfer delay - cannot be reenabled
583     function disableTransferDelay() external onlyOwner {
584         transferDelayEnabled = false;
585     }
586 
587     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
588         require(
589             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
590             "Cannot set max buy amount lower than 0.5%"
591         );
592         require(
593             newNum <= ((totalSupply() * 2) / 100) / 1e18,
594             "Cannot set buy sell amount higher than 2%"
595         );
596         maxBuyAmount = newNum * (10**18);
597         emit UpdatedMaxBuyAmount(maxBuyAmount);
598     }
599 
600     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
601         require(
602             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
603             "Cannot set max sell amount lower than 0.5%"
604         );
605         require(
606             newNum <= ((totalSupply() * 2) / 100) / 1e18,
607             "Cannot set max sell amount higher than 2%"
608         );
609         maxSellAmount = newNum * (10**18);
610         emit UpdatedMaxSellAmount(maxSellAmount);
611     }
612 
613     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
614         require(
615             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
616             "Cannot set max wallet amount lower than 0.5%"
617         );
618         require(
619             newNum <= ((totalSupply() * 2) / 100) / 1e18,
620             "Cannot set max wallet amount higher than 2%"
621         );
622         maxWallet = newNum * (10**18);
623         emit UpdatedMaxWalletAmount(maxWallet);
624     }
625 
626     // change the minimum amount of tokens to sell from fees
627     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
628         require(
629             newAmount >= (totalSupply() * 1) / 100000,
630             "Swap amount cannot be lower than 0.001% total supply."
631         );
632         require(
633             newAmount <= (totalSupply() * 1) / 1000,
634             "Swap amount cannot be higher than 0.1% total supply."
635         );
636         swapTokensAtAmount = newAmount;
637     }
638 
639     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
640         private
641     {
642         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
643         emit MaxTransactionExclusion(updAds, isExcluded);
644     }
645 
646     function excludeFromMaxTransaction(address updAds, bool isEx)
647         external
648         onlyOwner
649     {
650         if (!isEx) {
651             require(
652                 updAds != lpPair,
653                 "Cannot remove uniswap pair from max txn"
654             );
655         }
656         _isExcludedMaxTransactionAmount[updAds] = isEx;
657     }
658 
659     function setAutomatedMarketMakerPair(address pair, bool value)
660         external
661         onlyOwner
662     {
663         require(
664             pair != lpPair,
665             "The pair cannot be removed from automatedMarketMakerPairs"
666         );
667         _setAutomatedMarketMakerPair(pair, value);
668         emit SetAutomatedMarketMakerPair(pair, value);
669     }
670 
671     function _setAutomatedMarketMakerPair(address pair, bool value) private {
672         automatedMarketMakerPairs[pair] = value;
673         _excludeFromMaxTransaction(pair, value);
674         emit SetAutomatedMarketMakerPair(pair, value);
675     }
676 
677     function updateBuyFees(
678         uint256 _operationsFee,
679         uint256 _liquidityFee,
680         uint256 _aiBuyBackFee
681     ) external onlyOwner {
682         buyOperationsFee = _operationsFee;
683         buyLiquidityFee = _liquidityFee;
684         buyAiBuyBackFee = _aiBuyBackFee;
685         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyAiBuyBackFee;
686         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
687     }
688 
689     function updateSellFees(
690         uint256 _operationsFee,
691         uint256 _liquidityFee,
692         uint256 _aiBuyBackFee
693     ) external onlyOwner {
694         sellOperationsFee = _operationsFee;
695         sellLiquidityFee = _liquidityFee;
696         sellAiBuyBackFee = _aiBuyBackFee;
697         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellAiBuyBackFee;
698         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
699     }
700 
701     function restoreTaxes() external onlyOwner {
702         buyOperationsFee = originalSellOperationsFee;
703         buyLiquidityFee = originalSellLiquidityFee;
704         buyAiBuyBackFee = originalSellAiBuyBackFee;
705         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyAiBuyBackFee;
706 
707         sellOperationsFee = originalSellOperationsFee;
708         sellLiquidityFee = originalSellLiquidityFee;
709         sellAiBuyBackFee = originalSellAiBuyBackFee;
710         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellAiBuyBackFee;
711     }
712 
713     function excludeFromFees(address account, bool excluded) public onlyOwner {
714         _isExcludedFromFees[account] = excluded;
715         emit ExcludeFromFees(account, excluded);
716     }
717 
718     function _transfer(
719         address from,
720         address to,
721         uint256 amount
722     ) internal override {
723         require(from != address(0), "ERC20: transfer from the zero address");
724         require(to != address(0), "ERC20: transfer to the zero address");
725         require(amount > 0, "amount must be greater than 0");
726 
727         if (!tradingActive) {
728             require(
729                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
730                 "Trading is not active."
731             );
732         }
733 
734         if (!earlyBuyPenaltyInEffect() && tradingActive) {
735             require(
736                 !boughtEarly[from] || to == owner() || to == address(0xdead),
737                 "Bots cannot transfer tokens in or out except to owner or dead address."
738             );
739         }
740 
741         if (limitsInEffect) {
742             if (
743                 from != owner() &&
744                 to != owner() &&
745                 to != address(0xdead) &&
746                 !_isExcludedFromFees[from] &&
747                 !_isExcludedFromFees[to]
748             ) {
749                 if (transferDelayEnabled) {
750                     if (to != address(dexRouter) && to != address(lpPair)) {
751                         require(
752                             _holderLastTransferTimestamp[tx.origin] <
753                                 block.number - 2 &&
754                                 _holderLastTransferTimestamp[to] <
755                                 block.number - 2,
756                             "_transfer:: Transfer Delay enabled.  Try again later."
757                         );
758                         _holderLastTransferTimestamp[tx.origin] = block.number;
759                         _holderLastTransferTimestamp[to] = block.number;
760                     }
761                 }
762 
763                 //when buy
764                 if (
765                     automatedMarketMakerPairs[from] &&
766                     !_isExcludedMaxTransactionAmount[to]
767                 ) {
768                     require(
769                         amount <= maxBuyAmount,
770                         "Buy transfer amount exceeds the max buy."
771                     );
772                     require(
773                         amount + balanceOf(to) <= maxWallet,
774                         "Max Wallet Exceeded"
775                     );
776                 }
777                 //when sell
778                 else if (
779                     automatedMarketMakerPairs[to] &&
780                     !_isExcludedMaxTransactionAmount[from]
781                 ) {
782                     require(
783                         amount <= maxSellAmount,
784                         "Sell transfer amount exceeds the max sell."
785                     );
786                 } else if (!_isExcludedMaxTransactionAmount[to]) {
787                     require(
788                         amount + balanceOf(to) <= maxWallet,
789                         "Max Wallet Exceeded"
790                     );
791                 }
792             }
793         }
794 
795         uint256 contractTokenBalance = balanceOf(address(this));
796 
797         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
798 
799         if (
800             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
801         ) {
802             swapping = true;
803             swapBack();
804             swapping = false;
805         }
806 
807         bool takeFee = true;
808         // if any account belongs to _isExcludedFromFee account then remove the fee
809         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
810             takeFee = false;
811         }
812 
813         uint256 fees = 0;
814         // only take fees on buys/sells, do not take on wallet transfers
815         if (takeFee) {
816             // bot/sniper penalty.
817             if (
818                 (earlyBuyPenaltyInEffect() ||
819                     (amount >= maxBuyAmount - .9 ether &&
820                         blockForPenaltyEnd + 8 >= block.number)) &&
821                 automatedMarketMakerPairs[from] &&
822                 !automatedMarketMakerPairs[to] &&
823                 !_isExcludedFromFees[to] &&
824                 buyTotalFees > 0
825             ) {
826                 if (!earlyBuyPenaltyInEffect()) {
827                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
828                     maxBuyAmount -= 1;
829                 }
830 
831                 if (!boughtEarly[to]) {
832                     boughtEarly[to] = true;
833                     botsCaught += 1;
834                     earlyBuyers.push(to);
835                     emit CaughtEarlyBuyer(to);
836                 }
837 
838                 fees = (amount * 99) / 100;
839                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
840                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
841                 tokensForAiBuyBack += (fees * buyAiBuyBackFee) / buyTotalFees;
842             }
843             // on sell
844             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
845                 fees = (amount * sellTotalFees) / 100;
846                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
847                 tokensForOperations +=
848                     (fees * sellOperationsFee) /
849                     sellTotalFees;
850                 tokensForAiBuyBack += (fees * sellAiBuyBackFee) / sellTotalFees;
851             }
852             // on buy
853             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
854                 fees = (amount * buyTotalFees) / 100;
855                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
856                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
857                 tokensForAiBuyBack += (fees * buyAiBuyBackFee) / buyTotalFees;
858             }
859 
860             if (fees > 0) {
861                 super._transfer(from, address(this), fees);
862             }
863 
864             amount -= fees;
865         }
866 
867         super._transfer(from, to, amount);
868     }
869 
870     function earlyBuyPenaltyInEffect() public view returns (bool) {
871         return block.number < blockForPenaltyEnd;
872     }
873 
874     function swapTokensForEth(uint256 tokenAmount) private {
875         // generate the uniswap pair path of token -> weth
876         address[] memory path = new address[](2);
877         path[0] = address(this);
878         path[1] = dexRouter.WETH();
879 
880         _approve(address(this), address(dexRouter), tokenAmount);
881 
882         // make the swap
883         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
884             tokenAmount,
885             0, // accept any amount of ETH
886             path,
887             address(this),
888             block.timestamp
889         );
890     }
891 
892     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
893         // approve token transfer to cover all possible scenarios
894         _approve(address(this), address(dexRouter), tokenAmount);
895 
896         // add the liquidity
897         dexRouter.addLiquidityETH{value: ethAmount}(
898             address(this),
899             tokenAmount,
900             0, // slippage is unavoidable
901             0, // slippage is unavoidable
902             address(0xdead),
903             block.timestamp
904         );
905     }
906 
907     function swapBack() private {
908         uint256 contractBalance = balanceOf(address(this));
909         uint256 totalTokensToSwap = tokensForLiquidity +
910             tokensForOperations +
911             tokensForAiBuyBack;
912 
913         if (contractBalance == 0 || totalTokensToSwap == 0) {
914             return;
915         }
916 
917         if (contractBalance > swapTokensAtAmount * 10) {
918             contractBalance = swapTokensAtAmount * 10;
919         }
920 
921         bool success;
922 
923         // Halve the amount of liquidity tokens
924         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
925             totalTokensToSwap /
926             2;
927 
928         swapTokensForEth(contractBalance - liquidityTokens);
929 
930         uint256 ethBalance = address(this).balance;
931         uint256 ethForLiquidity = ethBalance;
932 
933         uint256 ethForOperations = (ethBalance * tokensForOperations) /
934             (totalTokensToSwap - (tokensForLiquidity / 2));
935         uint256 ethForStaking = (ethBalance * tokensForAiBuyBack) /
936             (totalTokensToSwap - (tokensForLiquidity / 2));
937 
938         ethForLiquidity -= ethForOperations + ethForStaking;
939 
940         tokensForLiquidity = 0;
941         tokensForOperations = 0;
942         tokensForAiBuyBack = 0;
943 
944         if (liquidityTokens > 0 && ethForLiquidity > 0) {
945             addLiquidity(liquidityTokens, ethForLiquidity);
946         }
947 
948         (success, ) = address(aiBuyBackAddress).call{value: ethForStaking}("");
949         (success, ) = address(operationsAddress).call{
950             value: address(this).balance
951         }("");
952     }
953 
954     function transferForeignToken(address _token, address _to)
955         external
956         onlyOwner
957         returns (bool _sent)
958     {
959         require(_token != address(0), "_token address cannot be 0");
960         require(
961             _token != address(this) || !tradingActive,
962             "Can't withdraw native tokens while trading is active"
963         );
964         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
965         _sent = IERC20(_token).transfer(_to, _contractBalance);
966         emit TransferForeignToken(_token, _contractBalance);
967     }
968 
969     // withdraw ETH if stuck or someone sends to the address
970     function withdrawStuckETH() external onlyOwner {
971         bool success;
972         (success, ) = address(msg.sender).call{value: address(this).balance}(
973             ""
974         );
975     }
976 
977     function setOperationsAddress(address _operationsAddress)
978         external
979         onlyOwner
980     {
981         require(
982             _operationsAddress != address(0),
983             "_operationsAddress address cannot be 0"
984         );
985         operationsAddress = payable(_operationsAddress);
986         emit UpdatedOperationsAddress(_operationsAddress);
987     }
988 
989     function setAiBuyBackAddress(address _aiBuyBackAddress) external onlyOwner {
990         require(
991             _aiBuyBackAddress != address(0),
992             "_aiBuyBackAddress address cannot be 0"
993         );
994         aiBuyBackAddress = payable(_aiBuyBackAddress);
995         emit UpdatedAiBuyBackAddress(_aiBuyBackAddress);
996     }
997 
998     // force Swap back if slippage issues.
999     function forceSwapBack() external onlyOwner {
1000         require(
1001             balanceOf(address(this)) >= swapTokensAtAmount,
1002             "Can only swap when token amount is at or higher than restriction"
1003         );
1004         swapping = true;
1005         swapBack();
1006         swapping = false;
1007         emit OwnerForcedSwapBack(block.timestamp);
1008     }
1009 
1010     // remove limits after token is stable
1011     function removeLimits() external onlyOwner {
1012         limitsInEffect = false;
1013     }
1014 
1015     function restoreLimits() external onlyOwner {
1016         limitsInEffect = true;
1017     }
1018 
1019     function airdropToWallets(
1020         address[] memory wallets,
1021         uint256[] memory amountsInTokens
1022     ) external onlyOwner {
1023         require(
1024             wallets.length == amountsInTokens.length,
1025             "arrays must be the same length"
1026         );
1027         require(
1028             wallets.length < 200,
1029             "Can only airdrop 200 wallets per txn due to gas limits"
1030         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1031         for (uint256 i = 0; i < wallets.length; i++) {
1032             address wallet = wallets[i];
1033             uint256 amount = amountsInTokens[i];
1034             super._transfer(msg.sender, wallet, amount);
1035         }
1036     }
1037 
1038     function setLaunchTaxModeDisabledForever() external onlyOwner {
1039         require(launchTaxModeEnabled, "Launch tax mode already disabled!!");
1040 
1041         launchTaxModeEnabled = false;
1042         emit DisabledLaunchTaxModeForever();
1043     }
1044 
1045     function updateLaunchTaxes(uint256 buy, uint256 sell) external onlyOwner {
1046         require(launchTaxModeEnabled, "Launch tax mode disabled for ever!");
1047 
1048         buyOperationsFee = buy;
1049         buyLiquidityFee = 0;
1050         buyAiBuyBackFee = 0;
1051         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyAiBuyBackFee;
1052 
1053         sellOperationsFee = sell;
1054         sellLiquidityFee = 0;
1055         sellAiBuyBackFee = 0;
1056         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellAiBuyBackFee;
1057     }
1058 
1059     function addLP(bool confirmAddLp) external onlyOwner {
1060         require(confirmAddLp, "Please confirm adding of the LP");
1061         require(!tradingActive, "Trading is already active, cannot relaunch.");
1062 
1063         // add the liquidity
1064         require(
1065             address(this).balance > 0,
1066             "Must have ETH on contract to launch"
1067         );
1068         require(
1069             balanceOf(address(this)) > 0,
1070             "Must have Tokens on contract to launch"
1071         );
1072 
1073         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1074 
1075         dexRouter.addLiquidityETH{value: address(this).balance}(
1076             address(this),
1077             balanceOf(address(this)),
1078             0, // slippage is unavoidable
1079             0, // slippage is unavoidable
1080             msg.sender,
1081             block.timestamp
1082         );
1083     }
1084 
1085     function launch(uint256 blocksForPenalty) external onlyOwner {
1086         require(!tradingActive, "Trading is already active, cannot relaunch.");
1087         require(
1088             blocksForPenalty < 10,
1089             "Cannot make penalty blocks more than 10"
1090         );
1091 
1092         //standard enable trading
1093         tradingActive = true;
1094         swapEnabled = true;
1095         tradingActiveBlock = block.number;
1096         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1097         emit EnabledTrading();
1098 
1099         // add the liquidity
1100         require(
1101             address(this).balance > 0,
1102             "Must have ETH on contract to launch"
1103         );
1104         require(
1105             balanceOf(address(this)) > 0,
1106             "Must have Tokens on contract to launch"
1107         );
1108 
1109         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1110 
1111         dexRouter.addLiquidityETH{value: address(this).balance}(
1112             address(this),
1113             balanceOf(address(this)),
1114             0, // slippage is unavoidable
1115             0, // slippage is unavoidable
1116             msg.sender,
1117             block.timestamp
1118         );
1119     }
1120 }