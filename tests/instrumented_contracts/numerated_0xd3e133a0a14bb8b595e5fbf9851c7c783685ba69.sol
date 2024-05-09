1 // SPDX-License-Identifier: MIT
2 /*
3  *     __    ____  ________ __ __________
4  *    / /   / __ \/ ____/ //_// ____/ __ \
5  *   / /   / / / / /   / ,<  / __/ / /_/ /
6  *  / /___/ /_/ / /___/ /| |/ /___/ _, _/
7  * /_____/\____/\____/_/ |_/_____/_/ |_|
8  *
9  *
10  * TG:  https://t.me/lockertoken_public
11  * WEB: https://locker-token.com
12  * TW:  https://twitter.com/lockertoken
13  *
14  * LOCKER migration from: 0x1cc29ee9dd8d9ed4148f6600ba5ec84d7ee85d12
15  *
16  * CONTRACT DEV: @seanking52
17  * 
18  */
19 pragma solidity 0.8.17;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount)
51         external
52         returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender)
62         external
63         view
64         returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(
110         address indexed owner,
111         address indexed spender,
112         uint256 value
113     );
114 }
115 
116 interface IERC20Metadata is IERC20 {
117     /**
118      * @dev Returns the name of the token.
119      */
120     function name() external view returns (string memory);
121 
122     /**
123      * @dev Returns the symbol of the token.
124      */
125     function symbol() external view returns (string memory);
126 
127     /**
128      * @dev Returns the decimals places of the token.
129      */
130     function decimals() external view returns (uint8);
131 }
132 
133 contract ERC20 is Context, IERC20, IERC20Metadata {
134     mapping(address => uint256) private _balances;
135 
136     mapping(address => mapping(address => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142 
143     constructor(string memory name_, string memory symbol_) {
144         _name = name_;
145         _symbol = symbol_;
146     }
147 
148     function name() public view virtual override returns (string memory) {
149         return _name;
150     }
151 
152     function symbol() public view virtual override returns (string memory) {
153         return _symbol;
154     }
155 
156     function decimals() public view virtual override returns (uint8) {
157         return 18;
158     }
159 
160     function totalSupply() public view virtual override returns (uint256) {
161         return _totalSupply;
162     }
163 
164     function balanceOf(address account)
165         public
166         view
167         virtual
168         override
169         returns (uint256)
170     {
171         return _balances[account];
172     }
173 
174     function transfer(address recipient, uint256 amount)
175         public
176         virtual
177         override
178         returns (bool)
179     {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender)
185         public
186         view
187         virtual
188         override
189         returns (uint256)
190     {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount)
195         public
196         virtual
197         override
198         returns (bool)
199     {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) public virtual override returns (bool) {
209         _transfer(sender, recipient, amount);
210 
211         uint256 currentAllowance = _allowances[sender][_msgSender()];
212         require(
213             currentAllowance >= amount,
214             "ERC20: transfer amount exceeds allowance"
215         );
216         unchecked {
217             _approve(sender, _msgSender(), currentAllowance - amount);
218         }
219 
220         return true;
221     }
222 
223     function increaseAllowance(address spender, uint256 addedValue)
224         public
225         virtual
226         returns (bool)
227     {
228         _approve(
229             _msgSender(),
230             spender,
231             _allowances[_msgSender()][spender] + addedValue
232         );
233         return true;
234     }
235 
236     function decreaseAllowance(address spender, uint256 subtractedValue)
237         public
238         virtual
239         returns (bool)
240     {
241         uint256 currentAllowance = _allowances[_msgSender()][spender];
242         require(
243             currentAllowance >= subtractedValue,
244             "ERC20: decreased allowance below zero"
245         );
246         unchecked {
247             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
248         }
249 
250         return true;
251     }
252 
253     function _transfer(
254         address sender,
255         address recipient,
256         uint256 amount
257     ) internal virtual {
258         require(sender != address(0), "ERC20: transfer from the zero address");
259         require(recipient != address(0), "ERC20: transfer to the zero address");
260 
261         uint256 senderBalance = _balances[sender];
262         require(
263             senderBalance >= amount,
264             "ERC20: transfer amount exceeds balance"
265         );
266         unchecked {
267             _balances[sender] = senderBalance - amount;
268         }
269         _balances[recipient] += amount;
270 
271         emit Transfer(sender, recipient, amount);
272     }
273 
274     function _createInitialSupply(address account, uint256 amount)
275         internal
276         virtual
277     {
278         require(account != address(0), "ERC20: mint to the zero address");
279 
280         _totalSupply += amount;
281         _balances[account] += amount;
282         emit Transfer(address(0), account, amount);
283     }
284 
285     function _approve(
286         address owner,
287         address spender,
288         uint256 amount
289     ) internal virtual {
290         require(owner != address(0), "ERC20: approve from the zero address");
291         require(spender != address(0), "ERC20: approve to the zero address");
292 
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 }
297 
298 contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(
302         address indexed previousOwner,
303         address indexed newOwner
304     );
305 
306     constructor() {
307         address msgSender = _msgSender();
308         _owner = msgSender;
309         emit OwnershipTransferred(address(0), msgSender);
310     }
311 
312     function owner() public view returns (address) {
313         return _owner;
314     }
315 
316     modifier onlyOwner() {
317         require(_owner == _msgSender(), "Ownable: caller is not the owner");
318         _;
319     }
320 
321     function renounceOwnership(bool confirmRenounce)
322         external
323         virtual
324         onlyOwner
325     {
326         require(confirmRenounce, "Please confirm renounce!");
327         emit OwnershipTransferred(_owner, address(0));
328         _owner = address(0);
329     }
330 
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(
333             newOwner != address(0),
334             "Ownable: new owner is the zero address"
335         );
336         emit OwnershipTransferred(_owner, newOwner);
337         _owner = newOwner;
338     }
339 }
340 
341 interface ILpPair {
342     function sync() external;
343 }
344 
345 interface IDexRouter {
346     function factory() external pure returns (address);
347 
348     function WETH() external pure returns (address);
349 
350     function swapExactTokensForETHSupportingFeeOnTransferTokens(
351         uint256 amountIn,
352         uint256 amountOutMin,
353         address[] calldata path,
354         address to,
355         uint256 deadline
356     ) external;
357 
358     function swapExactETHForTokensSupportingFeeOnTransferTokens(
359         uint256 amountOutMin,
360         address[] calldata path,
361         address to,
362         uint256 deadline
363     ) external payable;
364 
365     function addLiquidityETH(
366         address token,
367         uint256 amountTokenDesired,
368         uint256 amountTokenMin,
369         uint256 amountETHMin,
370         address to,
371         uint256 deadline
372     )
373         external
374         payable
375         returns (
376             uint256 amountToken,
377             uint256 amountETH,
378             uint256 liquidity
379         );
380 
381     function getAmountsOut(uint256 amountIn, address[] calldata path)
382         external
383         view
384         returns (uint256[] memory amounts);
385 
386     function removeLiquidityETH(
387         address token,
388         uint256 liquidity,
389         uint256 amountTokenMin,
390         uint256 amountETHMin,
391         address to,
392         uint256 deadline
393     ) external returns (uint256 amountToken, uint256 amountETH);
394 }
395 
396 interface IDexFactory {
397     function createPair(address tokenA, address tokenB)
398         external
399         returns (address pair);
400 }
401 
402 contract LKT is ERC20, Ownable {
403     uint256 public maxBuyAmount;
404     uint256 public maxSellAmount;
405     uint256 public maxWallet;
406 
407     IDexRouter public dexRouter;
408     address public lpPair;
409 
410     bool private swapping;
411     uint256 public swapTokensAtAmount;
412 
413     address public operationsAddress;
414 
415     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
416     uint256 public blockForPenaltyEnd;
417     mapping(address => bool) public boughtEarly;
418     address[] public earlyBuyers;
419     uint256 public botsCaught;
420 
421     bool public limitsInEffect = true;
422     bool public tradingActive = false;
423     bool public swapEnabled = false;
424     bool public earlyBuyerAdditionEnabled = true; // Can only be disabled!
425 
426     // Anti-bot and anti-whale mappings and variables
427     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
428     bool public transferDelayEnabled = true;
429 
430     uint256 public buyTotalFees;
431     uint256 public buyOperationsFee;
432     uint256 public buyLiquidityFee;
433 
434     uint256 private originalSellOperationsFee;
435     uint256 private originalSellLiquidityFee;
436 
437     uint256 public sellTotalFees;
438     uint256 public sellOperationsFee;
439     uint256 public sellLiquidityFee;
440 
441     uint256 public tokensForOperations;
442     uint256 public tokensForLiquidity;
443 
444     /******************/
445 
446     // exlcude from fees and max transaction amount
447     mapping(address => bool) private _isExcludedFromFees;
448     mapping(address => bool) public _isExcludedMaxTransactionAmount;
449 
450     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
451     // could be subject to a maximum transfer amount
452     mapping(address => bool) public automatedMarketMakerPairs;
453 
454     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
455 
456     event EnabledTrading();
457 
458     event ExcludeFromFees(address indexed account, bool isExcluded);
459 
460     event UpdatedMaxBuyAmount(uint256 newAmount);
461 
462     event UpdatedMaxSellAmount(uint256 newAmount);
463 
464     event UpdatedMaxWalletAmount(uint256 newAmount);
465 
466     event UpdatedOperationsAddress(address indexed newWallet);
467 
468     event MaxTransactionExclusion(address _address, bool excluded);
469 
470     event OwnerForcedSwapBack(uint256 timestamp);
471 
472     event CaughtEarlyBuyer(address sniper);
473 
474     event SwapAndLiquify(
475         uint256 tokensSwapped,
476         uint256 ethReceived,
477         uint256 tokensIntoLiquidity
478     );
479 
480     event TransferForeignToken(address token, uint256 amount);
481 
482     event DisabledAddingEarlyBuyersForever();
483 
484     constructor() payable ERC20("Locker Token", "LKT") {
485         address newOwner = msg.sender; // can leave alone if owner is deployer.
486 
487         address _dexRouter;
488 
489         if (block.chainid == 1) {
490             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
491         } else if (block.chainid == 5) {
492             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
493         } else {
494             revert("Chain not configured");
495         }
496 
497         // initialize router
498         dexRouter = IDexRouter(_dexRouter);
499 
500         // create pair
501         lpPair = IDexFactory(dexRouter.factory()).createPair(
502             address(this),
503             dexRouter.WETH()
504         );
505         _excludeFromMaxTransaction(address(lpPair), true);
506         _setAutomatedMarketMakerPair(address(lpPair), true);
507 
508         uint256 totalSupply = 1 * 1e9 * 1e18;
509 
510         maxBuyAmount = (totalSupply * 25) / 10000; // 0.25%
511         maxSellAmount = (totalSupply * 25) / 10000; // 0.25%
512         maxWallet = (totalSupply * 15) / 1000; // 1.5%
513         swapTokensAtAmount = (totalSupply * 2) / 10000; // 0.02 %
514 
515         buyOperationsFee = 7;
516         buyLiquidityFee = 2;
517         buyTotalFees = buyOperationsFee + buyLiquidityFee;
518 
519         originalSellOperationsFee = 7;
520         originalSellLiquidityFee = 2;
521 
522         sellOperationsFee = 12; // increased sell tax at launch
523         sellLiquidityFee = 3;
524         sellTotalFees = sellOperationsFee + sellLiquidityFee;
525 
526         operationsAddress = address(0x258cb94167f233D2E6cf1C868873164321064664);
527 
528         _excludeFromMaxTransaction(newOwner, true);
529         _excludeFromMaxTransaction(address(this), true);
530         _excludeFromMaxTransaction(address(0xdead), true);
531         _excludeFromMaxTransaction(address(operationsAddress), true);
532         _excludeFromMaxTransaction(address(dexRouter), true);
533 
534         excludeFromFees(newOwner, true);
535         excludeFromFees(address(this), true);
536         excludeFromFees(address(0xdead), true);
537         excludeFromFees(address(operationsAddress), true);
538         excludeFromFees(address(dexRouter), true);
539 
540         _createInitialSupply(
541             address(0x258cb94167f233D2E6cf1C868873164321064664),
542             (totalSupply * 83) / 100
543         ); // Tokens for exchanges, additional liq, etc.
544         _createInitialSupply(address(this), (totalSupply * 2) / 100); // Tokens for liquidity
545         _createInitialSupply(newOwner, (totalSupply * 15) / 100); // Airdrop old holders
546 
547         transferOwnership(newOwner);
548     }
549 
550     receive() external payable {}
551 
552     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
553         require(!tradingActive, "Cannot reenable trading");
554         require(
555             blocksForPenalty <= 10,
556             "Cannot make penalty blocks more than 10"
557         );
558         tradingActive = true;
559         swapEnabled = true;
560         tradingActiveBlock = block.number;
561         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
562         emit EnabledTrading();
563     }
564 
565     function getEarlyBuyers() external view returns (address[] memory) {
566         return earlyBuyers;
567     }
568 
569     function addBoughtEarly(address wallet) external onlyOwner {
570         require(
571             earlyBuyerAdditionEnabled,
572             "Early buyer addition has been disabled forever!!"
573         );
574         require(!boughtEarly[wallet], "Wallet is already flagged.");
575         boughtEarly[wallet] = true;
576     }
577 
578     function removeBoughtEarly(address wallet) external onlyOwner {
579         require(boughtEarly[wallet], "Wallet is already not flagged.");
580         boughtEarly[wallet] = false;
581     }
582 
583     function emergencyUpdateRouter(address router) external onlyOwner {
584         require(!tradingActive, "Cannot update after trading is functional");
585         dexRouter = IDexRouter(router);
586     }
587 
588     // disable Transfer delay - cannot be reenabled
589     function disableTransferDelay() external onlyOwner {
590         transferDelayEnabled = false;
591     }
592 
593     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
594         require(
595             newNum >= ((totalSupply() * 25) / 10000) / 1e18,
596             "Cannot set max buy amount lower than 0.25%"
597         );
598         require(
599             newNum <= ((totalSupply() * 2) / 100) / 1e18,
600             "Cannot set buy sell amount higher than 2%"
601         );
602         maxBuyAmount = newNum * (10**18);
603         emit UpdatedMaxBuyAmount(maxBuyAmount);
604     }
605 
606     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
607         require(
608             newNum >= ((totalSupply() * 25) / 10000) / 1e18,
609             "Cannot set max buy amount lower than 0.25%"
610         );
611         require(
612             newNum <= ((totalSupply() * 2) / 100) / 1e18,
613             "Cannot set max sell amount higher than 2%"
614         );
615         maxSellAmount = newNum * (10**18);
616         emit UpdatedMaxSellAmount(maxSellAmount);
617     }
618 
619     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
620         require(
621             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
622             "Cannot set max wallet amount lower than 0.5%"
623         );
624         require(
625             newNum <= ((totalSupply() * 2) / 100) / 1e18,
626             "Cannot set max wallet amount higher than 2%"
627         );
628         maxWallet = newNum * (10**18);
629         emit UpdatedMaxWalletAmount(maxWallet);
630     }
631 
632     // change the minimum amount of tokens to sell from fees
633     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
634         require(
635             newAmount >= (totalSupply() * 1) / 100000,
636             "Swap amount cannot be lower than 0.001% total supply."
637         );
638         require(
639             newAmount <= (totalSupply() * 1) / 1000,
640             "Swap amount cannot be higher than 0.1% total supply."
641         );
642         swapTokensAtAmount = newAmount;
643     }
644 
645     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
646         private
647     {
648         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
649         emit MaxTransactionExclusion(updAds, isExcluded);
650     }
651 
652     function excludeFromMaxTransaction(address updAds, bool isEx)
653         external
654         onlyOwner
655     {
656         if (!isEx) {
657             require(
658                 updAds != lpPair,
659                 "Cannot remove uniswap pair from max txn"
660             );
661         }
662         _isExcludedMaxTransactionAmount[updAds] = isEx;
663     }
664 
665     function setAutomatedMarketMakerPair(address pair, bool value)
666         external
667         onlyOwner
668     {
669         require(
670             pair != lpPair,
671             "The pair cannot be removed from automatedMarketMakerPairs"
672         );
673         _setAutomatedMarketMakerPair(pair, value);
674         emit SetAutomatedMarketMakerPair(pair, value);
675     }
676 
677     function _setAutomatedMarketMakerPair(address pair, bool value) private {
678         automatedMarketMakerPairs[pair] = value;
679         _excludeFromMaxTransaction(pair, value);
680         emit SetAutomatedMarketMakerPair(pair, value);
681     }
682 
683     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
684         external
685         onlyOwner
686     {
687         buyOperationsFee = _operationsFee;
688         buyLiquidityFee = _liquidityFee;
689         buyTotalFees = buyOperationsFee + buyLiquidityFee;
690         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
691     }
692 
693     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
694         external
695         onlyOwner
696     {
697         sellOperationsFee = _operationsFee;
698         sellLiquidityFee = _liquidityFee;
699         sellTotalFees = sellOperationsFee + sellLiquidityFee;
700         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
701     }
702 
703     function restoreTaxes() external onlyOwner {
704         buyOperationsFee = originalSellOperationsFee;
705         buyLiquidityFee = originalSellLiquidityFee;
706         buyTotalFees = buyOperationsFee + buyLiquidityFee;
707 
708         sellOperationsFee = originalSellOperationsFee;
709         sellLiquidityFee = originalSellLiquidityFee;
710         sellTotalFees = sellOperationsFee + sellLiquidityFee;
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
841             }
842             // on sell
843             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
844                 fees = (amount * sellTotalFees) / 100;
845                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
846                 tokensForOperations +=
847                     (fees * sellOperationsFee) /
848                     sellTotalFees;
849             }
850             // on buy
851             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
852                 fees = (amount * buyTotalFees) / 100;
853                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
854                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
855             }
856 
857             if (fees > 0) {
858                 super._transfer(from, address(this), fees);
859             }
860 
861             amount -= fees;
862         }
863 
864         super._transfer(from, to, amount);
865     }
866 
867     function earlyBuyPenaltyInEffect() public view returns (bool) {
868         return block.number < blockForPenaltyEnd;
869     }
870 
871     function swapTokensForEth(uint256 tokenAmount) private {
872         // generate the uniswap pair path of token -> weth
873         address[] memory path = new address[](2);
874         path[0] = address(this);
875         path[1] = dexRouter.WETH();
876 
877         _approve(address(this), address(dexRouter), tokenAmount);
878 
879         // make the swap
880         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
881             tokenAmount,
882             0, // accept any amount of ETH
883             path,
884             address(this),
885             block.timestamp
886         );
887     }
888 
889     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
890         // approve token transfer to cover all possible scenarios
891         _approve(address(this), address(dexRouter), tokenAmount);
892 
893         // add the liquidity
894         dexRouter.addLiquidityETH{value: ethAmount}(
895             address(this),
896             tokenAmount,
897             0, // slippage is unavoidable
898             0, // slippage is unavoidable
899             address(0xdead),
900             block.timestamp
901         );
902     }
903 
904     function swapBack() private {
905         uint256 contractBalance = balanceOf(address(this));
906         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
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
930 
931         ethForLiquidity -= ethForOperations;
932 
933         tokensForLiquidity = 0;
934         tokensForOperations = 0;
935 
936         if (liquidityTokens > 0 && ethForLiquidity > 0) {
937             addLiquidity(liquidityTokens, ethForLiquidity);
938         }
939 
940         (success, ) = address(operationsAddress).call{
941             value: address(this).balance
942         }("");
943     }
944 
945     function transferForeignToken(address _token, address _to)
946         external
947         onlyOwner
948         returns (bool _sent)
949     {
950         require(_token != address(0), "_token address cannot be 0");
951         require(
952             _token != address(this) || !tradingActive,
953             "Can't withdraw native tokens while trading is active"
954         );
955         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
956         _sent = IERC20(_token).transfer(_to, _contractBalance);
957         emit TransferForeignToken(_token, _contractBalance);
958     }
959 
960     // withdraw ETH if stuck or someone sends to the address
961     function withdrawStuckETH() external onlyOwner {
962         bool success;
963         (success, ) = address(msg.sender).call{value: address(this).balance}(
964             ""
965         );
966     }
967 
968     function setOperationsAddress(address _operationsAddress)
969         external
970         onlyOwner
971     {
972         require(
973             _operationsAddress != address(0),
974             "_operationsAddress address cannot be 0"
975         );
976         operationsAddress = payable(_operationsAddress);
977         emit UpdatedOperationsAddress(_operationsAddress);
978     }
979 
980     // force Swap back if slippage issues.
981     function forceSwapBack() external onlyOwner {
982         require(
983             balanceOf(address(this)) >= swapTokensAtAmount,
984             "Can only swap when token amount is at or higher than restriction"
985         );
986         swapping = true;
987         swapBack();
988         swapping = false;
989         emit OwnerForcedSwapBack(block.timestamp);
990     }
991 
992     // remove limits after token is stable
993     function removeLimits() external onlyOwner {
994         limitsInEffect = false;
995     }
996 
997     function restoreLimits() external onlyOwner {
998         limitsInEffect = true;
999     }
1000 
1001     function addLP(bool confirmAddLp) external onlyOwner {
1002         require(confirmAddLp, "Please confirm adding of the LP");
1003         require(!tradingActive, "Trading is already active, cannot relaunch.");
1004 
1005         // add the liquidity
1006         require(
1007             address(this).balance > 0,
1008             "Must have ETH on contract to launch"
1009         );
1010         require(
1011             balanceOf(address(this)) > 0,
1012             "Must have Tokens on contract to launch"
1013         );
1014 
1015         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1016 
1017         dexRouter.addLiquidityETH{value: address(this).balance}(
1018             address(this),
1019             balanceOf(address(this)),
1020             0, // slippage is unavoidable
1021             0, // slippage is unavoidable
1022             msg.sender,
1023             block.timestamp
1024         );
1025     }
1026 
1027     function launch(uint256 blocksForPenalty) external onlyOwner {
1028         require(!tradingActive, "Trading is already active, cannot relaunch.");
1029         require(
1030             blocksForPenalty < 10,
1031             "Cannot make penalty blocks more than 10"
1032         );
1033 
1034         //standard enable trading
1035         tradingActive = true;
1036         swapEnabled = true;
1037         tradingActiveBlock = block.number;
1038         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1039         emit EnabledTrading();
1040 
1041         // add the liquidity
1042         require(
1043             address(this).balance > 0,
1044             "Must have ETH on contract to launch"
1045         );
1046         require(
1047             balanceOf(address(this)) > 0,
1048             "Must have Tokens on contract to launch"
1049         );
1050 
1051         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1052 
1053         dexRouter.addLiquidityETH{value: address(this).balance}(
1054             address(this),
1055             balanceOf(address(this)),
1056             0, // slippage is unavoidable
1057             0, // slippage is unavoidable
1058             msg.sender,
1059             block.timestamp
1060         );
1061     }
1062 
1063     function airdropToWallets(
1064         address[] memory wallets,
1065         uint256[] memory amountsInTokens
1066     ) external onlyOwner {
1067         require(
1068             wallets.length == amountsInTokens.length,
1069             "arrays must be the same length"
1070         );
1071         require(
1072             wallets.length < 200,
1073             "Can only airdrop 200 wallets per txn due to gas limits"
1074         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1075         for (uint256 i = 0; i < wallets.length; i++) {
1076             address wallet = wallets[i];
1077             uint256 amount = amountsInTokens[i];
1078             super._transfer(msg.sender, wallet, amount);
1079         }
1080     }
1081 
1082     /**
1083      * This function will disable the possibility to add early buyers FOREVER
1084      */
1085     function disableAddingEarlyBuyersForever(bool confirmDisableFeatureForever)
1086         external
1087         onlyOwner
1088     {
1089         require(confirmDisableFeatureForever, "Please confirm");
1090         require(earlyBuyerAdditionEnabled, "Already disabled forever!");
1091         earlyBuyerAdditionEnabled = false;
1092         emit DisabledAddingEarlyBuyersForever();
1093     }
1094 }