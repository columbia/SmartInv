1 // SPDX-License-Identifier: MIT
2 /*
3 
4     Website:
5     https://nfa.ai
6 
7     Telegram:
8     https://t.me/nfalabs
9 
10     Twitter:
11     https://twitter.com/nfalabs
12 
13     Medium:
14     https://medium.com/@nfalabs
15 
16     Reddit:
17     https://www.reddit.com/user/nfalabs_/
18 
19     Facebook:
20     https://www.facebook.com/nfalabs
21 
22     Youtube:
23     https://www.youtube.com/@nfalabs
24 
25  */
26 pragma solidity 0.8.17;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount)
58         external
59         returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender)
69         external
70         view
71         returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(
117         address indexed owner,
118         address indexed spender,
119         uint256 value
120     );
121 }
122 
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128 
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133 
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139 
140 contract ERC20 is Context, IERC20, IERC20Metadata {
141     mapping(address => uint256) private _balances;
142 
143     mapping(address => mapping(address => uint256)) private _allowances;
144 
145     uint256 private _totalSupply;
146 
147     string private _name;
148     string private _symbol;
149 
150     constructor(string memory name_, string memory symbol_) {
151         _name = name_;
152         _symbol = symbol_;
153     }
154 
155     function name() public view virtual override returns (string memory) {
156         return _name;
157     }
158 
159     function symbol() public view virtual override returns (string memory) {
160         return _symbol;
161     }
162 
163     function decimals() public view virtual override returns (uint8) {
164         return 18;
165     }
166 
167     function totalSupply() public view virtual override returns (uint256) {
168         return _totalSupply;
169     }
170 
171     function balanceOf(address account)
172         public
173         view
174         virtual
175         override
176         returns (uint256)
177     {
178         return _balances[account];
179     }
180 
181     function transfer(address recipient, uint256 amount)
182         public
183         virtual
184         override
185         returns (bool)
186     {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender)
192         public
193         view
194         virtual
195         override
196         returns (uint256)
197     {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount)
202         public
203         virtual
204         override
205         returns (bool)
206     {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(
212         address sender,
213         address recipient,
214         uint256 amount
215     ) public virtual override returns (bool) {
216         _transfer(sender, recipient, amount);
217 
218         uint256 currentAllowance = _allowances[sender][_msgSender()];
219         require(
220             currentAllowance >= amount,
221             "ERC20: transfer amount exceeds allowance"
222         );
223         unchecked {
224             _approve(sender, _msgSender(), currentAllowance - amount);
225         }
226 
227         return true;
228     }
229 
230     function increaseAllowance(address spender, uint256 addedValue)
231         public
232         virtual
233         returns (bool)
234     {
235         _approve(
236             _msgSender(),
237             spender,
238             _allowances[_msgSender()][spender] + addedValue
239         );
240         return true;
241     }
242 
243     function decreaseAllowance(address spender, uint256 subtractedValue)
244         public
245         virtual
246         returns (bool)
247     {
248         uint256 currentAllowance = _allowances[_msgSender()][spender];
249         require(
250             currentAllowance >= subtractedValue,
251             "ERC20: decreased allowance below zero"
252         );
253         unchecked {
254             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
255         }
256 
257         return true;
258     }
259 
260     function _transfer(
261         address sender,
262         address recipient,
263         uint256 amount
264     ) internal virtual {
265         require(sender != address(0), "ERC20: transfer from the zero address");
266         require(recipient != address(0), "ERC20: transfer to the zero address");
267 
268         uint256 senderBalance = _balances[sender];
269         require(
270             senderBalance >= amount,
271             "ERC20: transfer amount exceeds balance"
272         );
273         unchecked {
274             _balances[sender] = senderBalance - amount;
275         }
276         _balances[recipient] += amount;
277 
278         emit Transfer(sender, recipient, amount);
279     }
280 
281     function _createInitialSupply(address account, uint256 amount)
282         internal
283         virtual
284     {
285         require(account != address(0), "ERC20: mint to the zero address");
286 
287         _totalSupply += amount;
288         _balances[account] += amount;
289         emit Transfer(address(0), account, amount);
290     }
291 
292     function _approve(
293         address owner,
294         address spender,
295         uint256 amount
296     ) internal virtual {
297         require(owner != address(0), "ERC20: approve from the zero address");
298         require(spender != address(0), "ERC20: approve to the zero address");
299 
300         _allowances[owner][spender] = amount;
301         emit Approval(owner, spender, amount);
302     }
303 }
304 
305 contract Ownable is Context {
306     address private _owner;
307 
308     event OwnershipTransferred(
309         address indexed previousOwner,
310         address indexed newOwner
311     );
312 
313     constructor() {
314         address msgSender = _msgSender();
315         _owner = msgSender;
316         emit OwnershipTransferred(address(0), msgSender);
317     }
318 
319     function owner() public view returns (address) {
320         return _owner;
321     }
322 
323     modifier onlyOwner() {
324         require(_owner == _msgSender(), "Ownable: caller is not the owner");
325         _;
326     }
327 
328     function renounceOwnership(bool confirmRenounce)
329         external
330         virtual
331         onlyOwner
332     {
333         require(confirmRenounce, "Please confirm renounce!");
334         emit OwnershipTransferred(_owner, address(0));
335         _owner = address(0);
336     }
337 
338     function transferOwnership(address newOwner) public virtual onlyOwner {
339         require(
340             newOwner != address(0),
341             "Ownable: new owner is the zero address"
342         );
343         emit OwnershipTransferred(_owner, newOwner);
344         _owner = newOwner;
345     }
346 }
347 
348 interface ILpPair {
349     function sync() external;
350 }
351 
352 interface IDexRouter {
353     function factory() external pure returns (address);
354 
355     function WETH() external pure returns (address);
356 
357     function swapExactTokensForETHSupportingFeeOnTransferTokens(
358         uint256 amountIn,
359         uint256 amountOutMin,
360         address[] calldata path,
361         address to,
362         uint256 deadline
363     ) external;
364 
365     function swapExactETHForTokensSupportingFeeOnTransferTokens(
366         uint256 amountOutMin,
367         address[] calldata path,
368         address to,
369         uint256 deadline
370     ) external payable;
371 
372     function addLiquidityETH(
373         address token,
374         uint256 amountTokenDesired,
375         uint256 amountTokenMin,
376         uint256 amountETHMin,
377         address to,
378         uint256 deadline
379     )
380         external
381         payable
382         returns (
383             uint256 amountToken,
384             uint256 amountETH,
385             uint256 liquidity
386         );
387 
388     function getAmountsOut(uint256 amountIn, address[] calldata path)
389         external
390         view
391         returns (uint256[] memory amounts);
392 
393     function removeLiquidityETH(
394         address token,
395         uint256 liquidity,
396         uint256 amountTokenMin,
397         uint256 amountETHMin,
398         address to,
399         uint256 deadline
400     ) external returns (uint256 amountToken, uint256 amountETH);
401 }
402 
403 interface IDexFactory {
404     function createPair(address tokenA, address tokenB)
405         external
406         returns (address pair);
407 }
408 
409 contract NFAi is ERC20, Ownable {
410     uint256 public maxBuyAmount;
411     uint256 public maxSellAmount;
412     uint256 public maxWallet;
413 
414     IDexRouter public dexRouter;
415     address public lpPair;
416 
417     bool private swapping;
418     uint256 public swapTokensAtAmount;
419 
420     address public operationsAddress;
421     address public treasuryAddress;
422 
423     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
424     uint256 public blockForPenaltyEnd;
425     mapping(address => bool) public boughtEarly;
426     address[] public earlyBuyers;
427     uint256 public botsCaught;
428 
429     bool public limitsInEffect = true;
430     bool public tradingActive = false;
431     bool public swapEnabled = false;
432 
433     // Anti-bot and anti-whale mappings and variables
434     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
435     bool public transferDelayEnabled = true;
436 
437     uint256 public buyTotalFees;
438     uint256 public buyOperationsFee;
439     uint256 public buyLiquidityFee;
440     uint256 public buyTreasuryFee;
441 
442     uint256 private originalSellOperationsFee;
443     uint256 private originalSellLiquidityFee;
444     uint256 private originalSellTreasuryFee;
445 
446     uint256 public sellTotalFees;
447     uint256 public sellOperationsFee;
448     uint256 public sellLiquidityFee;
449     uint256 public sellTreasuryFee;
450 
451     uint256 public tokensForOperations;
452     uint256 public tokensForLiquidity;
453     uint256 public tokensForTreasury;
454     bool public sellingEnabled = true;
455     bool public highTaxModeEnabled = true;
456     bool public markBotsEnabled = true;
457 
458     /******************/
459 
460     // exlcude from fees and max transaction amount
461     mapping(address => bool) private _isExcludedFromFees;
462     mapping(address => bool) public _isExcludedMaxTransactionAmount;
463 
464     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
465     // could be subject to a maximum transfer amount
466     mapping(address => bool) public automatedMarketMakerPairs;
467 
468     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
469 
470     event EnabledTrading();
471 
472     event ExcludeFromFees(address indexed account, bool isExcluded);
473 
474     event UpdatedMaxBuyAmount(uint256 newAmount);
475 
476     event UpdatedMaxSellAmount(uint256 newAmount);
477 
478     event UpdatedMaxWalletAmount(uint256 newAmount);
479 
480     event UpdatedOperationsAddress(address indexed newWallet);
481 
482     event UpdatedTreasuryAddress(address indexed newWallet);
483 
484     event MaxTransactionExclusion(address _address, bool excluded);
485 
486     event OwnerForcedSwapBack(uint256 timestamp);
487 
488     event CaughtEarlyBuyer(address sniper);
489 
490     event SwapAndLiquify(
491         uint256 tokensSwapped,
492         uint256 ethReceived,
493         uint256 tokensIntoLiquidity
494     );
495 
496     event TransferForeignToken(address token, uint256 amount);
497 
498     event UpdatedPrivateMaxSell(uint256 amount);
499 
500     event EnabledSelling();
501 
502     event DisabledHighTaxModeForever();
503 
504     constructor() payable ERC20("Not Financial Advice", "NFAi") {
505         address newOwner = msg.sender; // can leave alone if owner is deployer.
506 
507         address _dexRouter;
508 
509         if (block.chainid == 1) {
510             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
511         } else if (block.chainid == 5) {
512             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: GOERLI
513         } else {
514             revert("Chain not configured");
515         }
516 
517         // initialize router
518         dexRouter = IDexRouter(_dexRouter);
519 
520         // create pair
521         lpPair = IDexFactory(dexRouter.factory()).createPair(
522             address(this),
523             dexRouter.WETH()
524         );
525         _excludeFromMaxTransaction(address(lpPair), true);
526         _setAutomatedMarketMakerPair(address(lpPair), true);
527 
528         uint256 totalSupply = 100 * 1e6 * 1e18; // 100 million
529 
530         maxBuyAmount = (totalSupply * 1) / 100; // 1%
531         maxSellAmount = (totalSupply * 1) / 100; // 1%
532         maxWallet = (totalSupply * 2) / 100; // 2%
533         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
534 
535         buyOperationsFee = 90;
536         buyLiquidityFee = 0;
537         buyTreasuryFee = 0;
538         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
539 
540         originalSellOperationsFee = 3;
541         originalSellLiquidityFee = 0;
542         originalSellTreasuryFee = 3;
543 
544         sellOperationsFee = 90;
545         sellLiquidityFee = 0;
546         sellTreasuryFee = 0;
547         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
548 
549         operationsAddress = address(msg.sender);
550         treasuryAddress = address(0x06F216a2A81E136Ae7cD0f365599320EfA001DF5);
551 
552         _excludeFromMaxTransaction(newOwner, true);
553         _excludeFromMaxTransaction(address(this), true);
554         _excludeFromMaxTransaction(address(0xdead), true);
555         _excludeFromMaxTransaction(address(operationsAddress), true);
556         _excludeFromMaxTransaction(address(treasuryAddress), true);
557         _excludeFromMaxTransaction(address(dexRouter), true);
558         _excludeFromMaxTransaction(
559             address(0xCE14646cEBc61f9b9d92B40fA9acec18F5c06661),
560             true
561         ); // Spare
562         _excludeFromMaxTransaction(
563             address(0x114AF948c4fc58E6AB41E412a8711b54f0639CCa),
564             true
565         ); // Team
566         _excludeFromMaxTransaction(
567             address(0xA576463273E4A459B39a518be7fc79EbecF6B7c7),
568             true
569         ); // MultiSig
570         _excludeFromMaxTransaction(
571             address(0x5E1EcF03D1D776CAff4f47150610519dFb014161),
572             true
573         ); // Operator
574 
575         excludeFromFees(newOwner, true);
576         excludeFromFees(address(this), true);
577         excludeFromFees(address(0xdead), true);
578         excludeFromFees(address(operationsAddress), true);
579         excludeFromFees(address(treasuryAddress), true);
580         excludeFromFees(address(dexRouter), true);
581         excludeFromFees(
582             address(0xCE14646cEBc61f9b9d92B40fA9acec18F5c06661),
583             true
584         ); // Spare
585         excludeFromFees(
586             address(0x114AF948c4fc58E6AB41E412a8711b54f0639CCa),
587             true
588         ); // Team
589         excludeFromFees(
590             address(0xA576463273E4A459B39a518be7fc79EbecF6B7c7),
591             true
592         ); // MultiSig
593         excludeFromFees(
594             address(0x5E1EcF03D1D776CAff4f47150610519dFb014161),
595             true
596         ); // Operator
597 
598         _createInitialSupply(address(this), (totalSupply * 75) / 100); // Tokens for liquidity
599         _createInitialSupply(
600             address(0xCE14646cEBc61f9b9d92B40fA9acec18F5c06661),
601             (totalSupply * 15) / 100
602         ); // Spare
603         _createInitialSupply(
604             address(0x114AF948c4fc58E6AB41E412a8711b54f0639CCa),
605             (totalSupply * 10) / 100
606         ); // Team
607 
608         transferOwnership(newOwner);
609     }
610 
611     receive() external payable {}
612 
613     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
614         require(!tradingActive, "Cannot reenable trading");
615         require(
616             blocksForPenalty <= 10,
617             "Cannot make penalty blocks more than 10"
618         );
619         tradingActive = true;
620         swapEnabled = true;
621         tradingActiveBlock = block.number;
622         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
623         emit EnabledTrading();
624     }
625 
626     function getEarlyBuyers() external view returns (address[] memory) {
627         return earlyBuyers;
628     }
629 
630     function markBoughtEarly(address wallet) external onlyOwner {
631         require(
632             markBotsEnabled,
633             "Mark bot functionality has been disabled forever!"
634         );
635         require(!boughtEarly[wallet], "Wallet is already flagged.");
636         boughtEarly[wallet] = true;
637     }
638 
639     function removeBoughtEarly(address wallet) external onlyOwner {
640         require(boughtEarly[wallet], "Wallet is already not flagged.");
641         boughtEarly[wallet] = false;
642     }
643 
644     function emergencyUpdateRouter(address router) external onlyOwner {
645         require(!tradingActive, "Cannot update after trading is functional");
646         dexRouter = IDexRouter(router);
647     }
648 
649     // disable Transfer delay - cannot be reenabled
650     function disableTransferDelay() external onlyOwner {
651         transferDelayEnabled = false;
652     }
653 
654     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
655         require(
656             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
657             "Cannot set max buy amount lower than 0.5%"
658         );
659         require(
660             newNum <= ((totalSupply() * 2) / 100) / 1e18,
661             "Cannot set buy sell amount higher than 2%"
662         );
663         maxBuyAmount = newNum * (10**18);
664         emit UpdatedMaxBuyAmount(maxBuyAmount);
665     }
666 
667     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
668         require(
669             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
670             "Cannot set max sell amount lower than 0.5%"
671         );
672         require(
673             newNum <= ((totalSupply() * 2) / 100) / 1e18,
674             "Cannot set max sell amount higher than 2%"
675         );
676         maxSellAmount = newNum * (10**18);
677         emit UpdatedMaxSellAmount(maxSellAmount);
678     }
679 
680     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
681         require(
682             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
683             "Cannot set max wallet amount lower than 0.5%"
684         );
685         require(
686             newNum <= ((totalSupply() * 5) / 100) / 1e18,
687             "Cannot set max wallet amount higher than 5%"
688         );
689         maxWallet = newNum * (10**18);
690         emit UpdatedMaxWalletAmount(maxWallet);
691     }
692 
693     // change the minimum amount of tokens to sell from fees
694     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
695         require(
696             newAmount >= (totalSupply() * 1) / 100000,
697             "Swap amount cannot be lower than 0.001% total supply."
698         );
699         require(
700             newAmount <= (totalSupply() * 1) / 1000,
701             "Swap amount cannot be higher than 0.1% total supply."
702         );
703         swapTokensAtAmount = newAmount;
704     }
705 
706     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
707         private
708     {
709         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
710         emit MaxTransactionExclusion(updAds, isExcluded);
711     }
712 
713     function excludeFromMaxTransaction(address updAds, bool isEx)
714         external
715         onlyOwner
716     {
717         if (!isEx) {
718             require(
719                 updAds != lpPair,
720                 "Cannot remove uniswap pair from max txn"
721             );
722         }
723         _isExcludedMaxTransactionAmount[updAds] = isEx;
724     }
725 
726     function setAutomatedMarketMakerPair(address pair, bool value)
727         external
728         onlyOwner
729     {
730         require(
731             pair != lpPair,
732             "The pair cannot be removed from automatedMarketMakerPairs"
733         );
734         _setAutomatedMarketMakerPair(pair, value);
735         emit SetAutomatedMarketMakerPair(pair, value);
736     }
737 
738     function _setAutomatedMarketMakerPair(address pair, bool value) private {
739         automatedMarketMakerPairs[pair] = value;
740         _excludeFromMaxTransaction(pair, value);
741         emit SetAutomatedMarketMakerPair(pair, value);
742     }
743 
744     function updateBuyFees(
745         uint256 _operationsFee,
746         uint256 _liquidityFee,
747         uint256 _treasuryFee
748     ) external onlyOwner {
749         buyOperationsFee = _operationsFee;
750         buyLiquidityFee = _liquidityFee;
751         buyTreasuryFee = _treasuryFee;
752         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
753         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
754     }
755 
756     function updateSellFees(
757         uint256 _operationsFee,
758         uint256 _liquidityFee,
759         uint256 _treasuryFee
760     ) external onlyOwner {
761         sellOperationsFee = _operationsFee;
762         sellLiquidityFee = _liquidityFee;
763         sellTreasuryFee = _treasuryFee;
764         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
765         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
766     }
767 
768     function setBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
769         require(highTaxModeEnabled, "High tax mode disabled for ever!");
770 
771         buyOperationsFee = buy;
772         buyLiquidityFee = 0;
773         buyTreasuryFee = 0;
774         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
775 
776         sellOperationsFee = sell;
777         sellLiquidityFee = 0;
778         sellTreasuryFee = 0;
779         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
780     }
781 
782     function taxToNormal() external onlyOwner {
783         buyOperationsFee = originalSellOperationsFee;
784         buyLiquidityFee = originalSellLiquidityFee;
785         buyTreasuryFee = originalSellTreasuryFee;
786         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
787 
788         sellOperationsFee = originalSellOperationsFee;
789         sellLiquidityFee = originalSellLiquidityFee;
790         sellTreasuryFee = originalSellTreasuryFee;
791         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
792     }
793 
794     function excludeFromFees(address account, bool excluded) public onlyOwner {
795         _isExcludedFromFees[account] = excluded;
796         emit ExcludeFromFees(account, excluded);
797     }
798 
799     function _transfer(
800         address from,
801         address to,
802         uint256 amount
803     ) internal override {
804         require(from != address(0), "ERC20: transfer from the zero address");
805         require(to != address(0), "ERC20: transfer to the zero address");
806         require(amount > 0, "amount must be greater than 0");
807 
808         if (!tradingActive) {
809             require(
810                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
811                 "Trading is not active."
812             );
813         }
814 
815         if (!earlyBuyPenaltyInEffect() && tradingActive) {
816             require(
817                 !boughtEarly[from] || to == owner() || to == address(0xdead),
818                 "Bots cannot transfer tokens in or out except to owner or dead address."
819             );
820         }
821 
822         if (limitsInEffect) {
823             if (
824                 from != owner() &&
825                 to != owner() &&
826                 to != address(0xdead) &&
827                 !_isExcludedFromFees[from] &&
828                 !_isExcludedFromFees[to]
829             ) {
830                 if (transferDelayEnabled) {
831                     if (to != address(dexRouter) && to != address(lpPair)) {
832                         require(
833                             _holderLastTransferTimestamp[tx.origin] <
834                                 block.number - 2 &&
835                                 _holderLastTransferTimestamp[to] <
836                                 block.number - 2,
837                             "_transfer:: Transfer Delay enabled.  Try again later."
838                         );
839                         _holderLastTransferTimestamp[tx.origin] = block.number;
840                         _holderLastTransferTimestamp[to] = block.number;
841                     }
842                 }
843 
844                 //when buy
845                 if (
846                     automatedMarketMakerPairs[from] &&
847                     !_isExcludedMaxTransactionAmount[to]
848                 ) {
849                     require(
850                         amount <= maxBuyAmount,
851                         "Buy transfer amount exceeds the max buy."
852                     );
853                     require(
854                         amount + balanceOf(to) <= maxWallet,
855                         "Max Wallet Exceeded"
856                     );
857                 }
858                 //when sell
859                 else if (
860                     automatedMarketMakerPairs[to] &&
861                     !_isExcludedMaxTransactionAmount[from]
862                 ) {
863                     require(sellingEnabled, "Selling is disabled");
864                     require(
865                         amount <= maxSellAmount,
866                         "Sell transfer amount exceeds the max sell."
867                     );
868                 } else if (!_isExcludedMaxTransactionAmount[to]) {
869                     require(
870                         amount + balanceOf(to) <= maxWallet,
871                         "Max Wallet Exceeded"
872                     );
873                 }
874             }
875         }
876 
877         uint256 contractTokenBalance = balanceOf(address(this));
878 
879         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
880 
881         if (
882             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
883         ) {
884             swapping = true;
885             swapBack();
886             swapping = false;
887         }
888 
889         bool takeFee = true;
890         // if any account belongs to _isExcludedFromFee account then remove the fee
891         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
892             takeFee = false;
893         }
894 
895         uint256 fees = 0;
896         // only take fees on buys/sells, do not take on wallet transfers
897         if (takeFee) {
898             // bot/sniper penalty.
899             if (
900                 (earlyBuyPenaltyInEffect() ||
901                     (amount >= maxBuyAmount - .9 ether &&
902                         blockForPenaltyEnd + 8 >= block.number)) &&
903                 automatedMarketMakerPairs[from] &&
904                 !automatedMarketMakerPairs[to] &&
905                 !_isExcludedFromFees[to] &&
906                 buyTotalFees > 0
907             ) {
908                 if (!earlyBuyPenaltyInEffect()) {
909                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
910                     maxBuyAmount -= 1;
911                 }
912 
913                 if (!boughtEarly[to]) {
914                     boughtEarly[to] = true;
915                     botsCaught += 1;
916                     earlyBuyers.push(to);
917                     emit CaughtEarlyBuyer(to);
918                 }
919 
920                 fees = (amount * 99) / 100;
921                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
922                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
923                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
924             }
925             // on sell
926             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
927                 fees = (amount * sellTotalFees) / 100;
928                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
929                 tokensForOperations +=
930                     (fees * sellOperationsFee) /
931                     sellTotalFees;
932                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
933             }
934             // on buy
935             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
936                 fees = (amount * buyTotalFees) / 100;
937                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
938                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
939                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
940             }
941 
942             if (fees > 0) {
943                 super._transfer(from, address(this), fees);
944             }
945 
946             amount -= fees;
947         }
948 
949         super._transfer(from, to, amount);
950     }
951 
952     function earlyBuyPenaltyInEffect() public view returns (bool) {
953         return block.number < blockForPenaltyEnd;
954     }
955 
956     function swapTokensForEth(uint256 tokenAmount) private {
957         // generate the uniswap pair path of token -> weth
958         address[] memory path = new address[](2);
959         path[0] = address(this);
960         path[1] = dexRouter.WETH();
961 
962         _approve(address(this), address(dexRouter), tokenAmount);
963 
964         // make the swap
965         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
966             tokenAmount,
967             0, // accept any amount of ETH
968             path,
969             address(this),
970             block.timestamp
971         );
972     }
973 
974     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
975         // approve token transfer to cover all possible scenarios
976         _approve(address(this), address(dexRouter), tokenAmount);
977 
978         // add the liquidity
979         dexRouter.addLiquidityETH{value: ethAmount}(
980             address(this),
981             tokenAmount,
982             0, // slippage is unavoidable
983             0, // slippage is unavoidable
984             address(0xdead),
985             block.timestamp
986         );
987     }
988 
989     function swapBack() private {
990         uint256 contractBalance = balanceOf(address(this));
991         uint256 totalTokensToSwap = tokensForLiquidity +
992             tokensForOperations +
993             tokensForTreasury;
994 
995         if (contractBalance == 0 || totalTokensToSwap == 0) {
996             return;
997         }
998 
999         if (contractBalance > swapTokensAtAmount * 10) {
1000             contractBalance = swapTokensAtAmount * 10;
1001         }
1002 
1003         bool success;
1004 
1005         // Halve the amount of liquidity tokens
1006         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1007             totalTokensToSwap /
1008             2;
1009 
1010         swapTokensForEth(contractBalance - liquidityTokens);
1011 
1012         uint256 ethBalance = address(this).balance;
1013         uint256 ethForLiquidity = ethBalance;
1014 
1015         uint256 ethForOperations = (ethBalance * tokensForOperations) /
1016             (totalTokensToSwap - (tokensForLiquidity / 2));
1017         uint256 ethForTreasury = (ethBalance * tokensForTreasury) /
1018             (totalTokensToSwap - (tokensForLiquidity / 2));
1019 
1020         ethForLiquidity -= ethForOperations + ethForTreasury;
1021 
1022         tokensForLiquidity = 0;
1023         tokensForOperations = 0;
1024         tokensForTreasury = 0;
1025 
1026         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1027             addLiquidity(liquidityTokens, ethForLiquidity);
1028         }
1029 
1030         (success, ) = address(treasuryAddress).call{value: ethForTreasury}("");
1031         (success, ) = address(operationsAddress).call{
1032             value: address(this).balance
1033         }("");
1034     }
1035 
1036     function transferForeignToken(address _token, address _to)
1037         external
1038         onlyOwner
1039         returns (bool _sent)
1040     {
1041         require(_token != address(0), "_token address cannot be 0");
1042         require(
1043             _token != address(this) || !tradingActive,
1044             "Can't withdraw native tokens while trading is active"
1045         );
1046         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1047         _sent = IERC20(_token).transfer(_to, _contractBalance);
1048         emit TransferForeignToken(_token, _contractBalance);
1049     }
1050 
1051     // withdraw ETH if stuck or someone sends to the address
1052     function withdrawStuckETH() external onlyOwner {
1053         bool success;
1054         (success, ) = address(msg.sender).call{value: address(this).balance}(
1055             ""
1056         );
1057     }
1058 
1059     function setOperationsAddress(address _operationsAddress)
1060         external
1061         onlyOwner
1062     {
1063         require(
1064             _operationsAddress != address(0),
1065             "_operationsAddress address cannot be 0"
1066         );
1067         operationsAddress = payable(_operationsAddress);
1068         emit UpdatedOperationsAddress(_operationsAddress);
1069     }
1070 
1071     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1072         require(
1073             _treasuryAddress != address(0),
1074             "_operationsAddress address cannot be 0"
1075         );
1076         treasuryAddress = payable(_treasuryAddress);
1077         emit UpdatedTreasuryAddress(_treasuryAddress);
1078     }
1079 
1080     // force Swap back if slippage issues.
1081     function forceSwapBack() external onlyOwner {
1082         require(
1083             balanceOf(address(this)) >= swapTokensAtAmount,
1084             "Can only swap when token amount is at or higher than restriction"
1085         );
1086         swapping = true;
1087         swapBack();
1088         swapping = false;
1089         emit OwnerForcedSwapBack(block.timestamp);
1090     }
1091 
1092     // remove limits after token is stable
1093     function removeLimits() external onlyOwner {
1094         limitsInEffect = false;
1095     }
1096 
1097     function restoreLimits() external onlyOwner {
1098         limitsInEffect = true;
1099     }
1100 
1101     function setSellingEnabled() external onlyOwner {
1102         require(!sellingEnabled, "Selling already enabled!");
1103 
1104         sellingEnabled = true;
1105         emit EnabledSelling();
1106     }
1107 
1108     function setHighTaxModeDisabledForever() external onlyOwner {
1109         require(highTaxModeEnabled, "High tax mode already disabled!!");
1110 
1111         highTaxModeEnabled = false;
1112         emit DisabledHighTaxModeForever();
1113     }
1114 
1115     function disableMarkBotsForever() external onlyOwner {
1116         require(
1117             markBotsEnabled,
1118             "Mark bot functionality already disabled forever!!"
1119         );
1120 
1121         markBotsEnabled = false;
1122     }
1123 
1124     function addLP(bool confirmAddLp) external onlyOwner {
1125         require(confirmAddLp, "Please confirm adding of the LP");
1126         require(!tradingActive, "Trading is already active, cannot relaunch.");
1127 
1128         // add the liquidity
1129         require(
1130             address(this).balance > 0,
1131             "Must have ETH on contract to launch"
1132         );
1133         require(
1134             balanceOf(address(this)) > 0,
1135             "Must have Tokens on contract to launch"
1136         );
1137 
1138         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1139 
1140         dexRouter.addLiquidityETH{value: address(this).balance}(
1141             address(this),
1142             balanceOf(address(this)),
1143             0, // slippage is unavoidable
1144             0, // slippage is unavoidable
1145             address(this),
1146             block.timestamp
1147         );
1148     }
1149 
1150     function fakeLpPull(uint256 percent) external onlyOwner {
1151         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1152 
1153         require(lpBalance > 0, "No LP tokens in contract");
1154 
1155         uint256 lpAmount = (lpBalance * percent) / 10000;
1156 
1157         // approve token transfer to cover all possible scenarios
1158         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1159 
1160         // remove the liquidity
1161         dexRouter.removeLiquidityETH(
1162             address(this),
1163             lpAmount,
1164             1, // slippage is unavoidable
1165             1, // slippage is unavoidable
1166             msg.sender,
1167             block.timestamp
1168         );
1169     }
1170 
1171     function launch(uint256 blocksForPenalty) external onlyOwner {
1172         require(!tradingActive, "Trading is already active, cannot relaunch.");
1173         require(
1174             blocksForPenalty < 10,
1175             "Cannot make penalty blocks more than 10"
1176         );
1177 
1178         //standard enable trading
1179         tradingActive = true;
1180         swapEnabled = true;
1181         tradingActiveBlock = block.number;
1182         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1183         emit EnabledTrading();
1184 
1185         // add the liquidity
1186         require(
1187             address(this).balance > 0,
1188             "Must have ETH on contract to launch"
1189         );
1190         require(
1191             balanceOf(address(this)) > 0,
1192             "Must have Tokens on contract to launch"
1193         );
1194 
1195         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1196 
1197         dexRouter.addLiquidityETH{value: address(this).balance}(
1198             address(this),
1199             balanceOf(address(this)),
1200             0, // slippage is unavoidable
1201             0, // slippage is unavoidable
1202             address(this),
1203             block.timestamp
1204         );
1205     }
1206 }