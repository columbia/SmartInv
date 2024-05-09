1 // SPDX-License-Identifier: MIT
2 /*
3  *  https://the-people.io/
4  *
5  *  TG: https://t.me/ThePeopleProtocol
6  *  TW: https://twitter.com/PeopleProtocol
7  *  RD: https://www.reddit.com/user/PeopleProtocol
8  */
9 pragma solidity 0.8.13;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount)
41         external
42         returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender)
52         external
53         view
54         returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(
100         address indexed owner,
101         address indexed spender,
102         uint256 value
103     );
104 }
105 
106 interface IERC20Metadata is IERC20 {
107     /**
108      * @dev Returns the name of the token.
109      */
110     function name() external view returns (string memory);
111 
112     /**
113      * @dev Returns the symbol of the token.
114      */
115     function symbol() external view returns (string memory);
116 
117     /**
118      * @dev Returns the decimals places of the token.
119      */
120     function decimals() external view returns (uint8);
121 }
122 
123 contract ERC20 is Context, IERC20, IERC20Metadata {
124     mapping(address => uint256) private _balances;
125 
126     mapping(address => mapping(address => uint256)) private _allowances;
127 
128     uint256 private _totalSupply;
129 
130     string private _name;
131     string private _symbol;
132 
133     constructor(string memory name_, string memory symbol_) {
134         _name = name_;
135         _symbol = symbol_;
136     }
137 
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141 
142     function symbol() public view virtual override returns (string memory) {
143         return _symbol;
144     }
145 
146     function decimals() public view virtual override returns (uint8) {
147         return 18;
148     }
149 
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     function balanceOf(address account)
155         public
156         view
157         virtual
158         override
159         returns (uint256)
160     {
161         return _balances[account];
162     }
163 
164     function transfer(address recipient, uint256 amount)
165         public
166         virtual
167         override
168         returns (bool)
169     {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     function allowance(address owner, address spender)
175         public
176         view
177         virtual
178         override
179         returns (uint256)
180     {
181         return _allowances[owner][spender];
182     }
183 
184     function approve(address spender, uint256 amount)
185         public
186         virtual
187         override
188         returns (bool)
189     {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) public virtual override returns (bool) {
199         _transfer(sender, recipient, amount);
200 
201         uint256 currentAllowance = _allowances[sender][_msgSender()];
202         require(
203             currentAllowance >= amount,
204             "ERC20: transfer amount exceeds allowance"
205         );
206         unchecked {
207             _approve(sender, _msgSender(), currentAllowance - amount);
208         }
209 
210         return true;
211     }
212 
213     function increaseAllowance(address spender, uint256 addedValue)
214         public
215         virtual
216         returns (bool)
217     {
218         _approve(
219             _msgSender(),
220             spender,
221             _allowances[_msgSender()][spender] + addedValue
222         );
223         return true;
224     }
225 
226     function decreaseAllowance(address spender, uint256 subtractedValue)
227         public
228         virtual
229         returns (bool)
230     {
231         uint256 currentAllowance = _allowances[_msgSender()][spender];
232         require(
233             currentAllowance >= subtractedValue,
234             "ERC20: decreased allowance below zero"
235         );
236         unchecked {
237             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
238         }
239 
240         return true;
241     }
242 
243     function _transfer(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) internal virtual {
248         require(sender != address(0), "ERC20: transfer from the zero address");
249         require(recipient != address(0), "ERC20: transfer to the zero address");
250 
251         uint256 senderBalance = _balances[sender];
252         require(
253             senderBalance >= amount,
254             "ERC20: transfer amount exceeds balance"
255         );
256         unchecked {
257             _balances[sender] = senderBalance - amount;
258         }
259         _balances[recipient] += amount;
260 
261         emit Transfer(sender, recipient, amount);
262     }
263 
264     function _createInitialSupply(address account, uint256 amount)
265         internal
266         virtual
267     {
268         require(account != address(0), "ERC20: mint to the zero address");
269 
270         _totalSupply += amount;
271         _balances[account] += amount;
272         emit Transfer(address(0), account, amount);
273     }
274 
275     function _approve(
276         address owner,
277         address spender,
278         uint256 amount
279     ) internal virtual {
280         require(owner != address(0), "ERC20: approve from the zero address");
281         require(spender != address(0), "ERC20: approve to the zero address");
282 
283         _allowances[owner][spender] = amount;
284         emit Approval(owner, spender, amount);
285     }
286 }
287 
288 contract Ownable is Context {
289     address private _owner;
290 
291     event OwnershipTransferred(
292         address indexed previousOwner,
293         address indexed newOwner
294     );
295 
296     constructor() {
297         address msgSender = _msgSender();
298         _owner = msgSender;
299         emit OwnershipTransferred(address(0), msgSender);
300     }
301 
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     modifier onlyOwner() {
307         require(_owner == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     function renounceOwnership() external virtual onlyOwner {
312         emit OwnershipTransferred(_owner, address(0));
313         _owner = address(0);
314     }
315 
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(
318             newOwner != address(0),
319             "Ownable: new owner is the zero address"
320         );
321         emit OwnershipTransferred(_owner, newOwner);
322         _owner = newOwner;
323     }
324 }
325 
326 interface ILpPair {
327     function sync() external;
328 }
329 
330 interface IDexRouter {
331     function factory() external pure returns (address);
332 
333     function WETH() external pure returns (address);
334 
335     function swapExactTokensForETHSupportingFeeOnTransferTokens(
336         uint256 amountIn,
337         uint256 amountOutMin,
338         address[] calldata path,
339         address to,
340         uint256 deadline
341     ) external;
342 
343     function swapExactETHForTokensSupportingFeeOnTransferTokens(
344         uint256 amountOutMin,
345         address[] calldata path,
346         address to,
347         uint256 deadline
348     ) external payable;
349 
350     function addLiquidityETH(
351         address token,
352         uint256 amountTokenDesired,
353         uint256 amountTokenMin,
354         uint256 amountETHMin,
355         address to,
356         uint256 deadline
357     )
358         external
359         payable
360         returns (
361             uint256 amountToken,
362             uint256 amountETH,
363             uint256 liquidity
364         );
365 
366     function getAmountsOut(uint256 amountIn, address[] calldata path)
367         external
368         view
369         returns (uint256[] memory amounts);
370 
371     function removeLiquidityETH(
372         address token,
373         uint256 liquidity,
374         uint256 amountTokenMin,
375         uint256 amountETHMin,
376         address to,
377         uint256 deadline
378     ) external returns (uint256 amountToken, uint256 amountETH);
379 }
380 
381 interface IDexFactory {
382     function createPair(address tokenA, address tokenB)
383         external
384         returns (address pair);
385 }
386 
387 contract Peoples is ERC20, Ownable {
388     uint256 public maxBuyAmount;
389     uint256 public maxSellAmount;
390     uint256 public maxWallet;
391 
392     IDexRouter public dexRouter;
393     address public lpPair;
394 
395     bool private swapping;
396     uint256 public swapTokensAtAmount;
397 
398     address public operationsAddress;
399     address public treasuryAddress;
400 
401     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
402     uint256 public blockForPenaltyEnd;
403     mapping(address => bool) public boughtEarly;
404     address[] public earlyBuyers;
405     uint256 public botsCaught;
406 
407     bool public limitsInEffect = true;
408     bool public tradingActive = false;
409     bool public swapEnabled = false;
410 
411     // Anti-bot and anti-whale mappings and variables
412     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
413     bool public transferDelayEnabled = true;
414 
415     uint256 public buyTotalFees;
416     uint256 public buyOperationsFee;
417     uint256 public buyLiquidityFee;
418     uint256 public buyTreasuryFee;
419 
420     uint256 private originalSellOperationsFee;
421     uint256 private originalSellLiquidityFee;
422     uint256 private originalSellTreasuryFee;
423 
424     uint256 public sellTotalFees;
425     uint256 public sellOperationsFee;
426     uint256 public sellLiquidityFee;
427     uint256 public sellTreasuryFee;
428 
429     uint256 public tokensForOperations;
430     uint256 public tokensForLiquidity;
431     uint256 public tokensForTreasury;
432     bool public sellingEnabled = false;
433 
434     /******************/
435 
436     // exlcude from fees and max transaction amount
437     mapping(address => bool) private _isExcludedFromFees;
438     mapping(address => bool) public _isExcludedMaxTransactionAmount;
439 
440     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
441     // could be subject to a maximum transfer amount
442     mapping(address => bool) public automatedMarketMakerPairs;
443 
444     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
445 
446     event EnabledTrading();
447 
448     event ExcludeFromFees(address indexed account, bool isExcluded);
449 
450     event UpdatedMaxBuyAmount(uint256 newAmount);
451 
452     event UpdatedMaxSellAmount(uint256 newAmount);
453 
454     event UpdatedMaxWalletAmount(uint256 newAmount);
455 
456     event UpdatedOperationsAddress(address indexed newWallet);
457 
458     event UpdatedTreasuryAddress(address indexed newWallet);
459 
460     event MaxTransactionExclusion(address _address, bool excluded);
461 
462     event OwnerForcedSwapBack(uint256 timestamp);
463 
464     event CaughtEarlyBuyer(address sniper);
465 
466     event SwapAndLiquify(
467         uint256 tokensSwapped,
468         uint256 ethReceived,
469         uint256 tokensIntoLiquidity
470     );
471 
472     event TransferForeignToken(address token, uint256 amount);
473 
474     event UpdatedPrivateMaxSell(uint256 amount);
475 
476     event EnabledSelling();
477 
478     constructor() payable ERC20("The People Protocol", "PEOPLES") {
479         address newOwner = msg.sender; // can leave alone if owner is deployer.
480 
481         address _dexRouter;
482 
483         if (block.chainid == 1) {
484             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
485         } else if (block.chainid == 4) {
486             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Rinkeby
487         } else {
488             revert("Chain not configured");
489         }
490 
491         // initialize router
492         dexRouter = IDexRouter(_dexRouter);
493 
494         // create pair
495         lpPair = IDexFactory(dexRouter.factory()).createPair(
496             address(this),
497             dexRouter.WETH()
498         );
499         _excludeFromMaxTransaction(address(lpPair), true);
500         _setAutomatedMarketMakerPair(address(lpPair), true);
501 
502         uint256 totalSupply = 7982424384 * 1e18; // world population
503 
504         maxBuyAmount = (totalSupply * 1) / 100; // 1%
505         maxSellAmount = (totalSupply * 1) / 100; // 1%
506         maxWallet = (totalSupply * 2) / 100; // 2%
507         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
508 
509         buyOperationsFee = 2;
510         buyLiquidityFee = 1;
511         buyTreasuryFee = 3;
512         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
513 
514         originalSellOperationsFee = 2;
515         originalSellLiquidityFee = 1;
516         originalSellTreasuryFee = 3;
517 
518         sellOperationsFee = 9;
519         sellLiquidityFee = 3;
520         sellTreasuryFee = 0;
521         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
522 
523         operationsAddress = address(0xcbA766cF7C455ab3dB08220cbAe4be25F30eaf47);
524         treasuryAddress = address(0x66403cf4fA97bE8023DbCE861FecC5de37f1426a);
525 
526         _excludeFromMaxTransaction(newOwner, true);
527         _excludeFromMaxTransaction(address(this), true);
528         _excludeFromMaxTransaction(address(0xdead), true);
529         _excludeFromMaxTransaction(address(operationsAddress), true);
530         _excludeFromMaxTransaction(address(treasuryAddress), true);
531         _excludeFromMaxTransaction(address(dexRouter), true);
532 
533         excludeFromFees(newOwner, true);
534         excludeFromFees(address(this), true);
535         excludeFromFees(address(0xdead), true);
536         excludeFromFees(address(operationsAddress), true);
537         excludeFromFees(address(treasuryAddress), true);
538         excludeFromFees(address(dexRouter), true);
539 
540         _createInitialSupply(address(0xdead), (totalSupply * 25) / 100); // Burn
541         _createInitialSupply(address(this), (totalSupply * 40) / 100); // Tokens for liquidity
542         _createInitialSupply(newOwner, (totalSupply * 35) / 100); // Lock
543 
544         transferOwnership(newOwner);
545     }
546 
547     receive() external payable {}
548 
549     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
550         require(!tradingActive, "Cannot reenable trading");
551         require(
552             blocksForPenalty <= 10,
553             "Cannot make penalty blocks more than 10"
554         );
555         tradingActive = true;
556         swapEnabled = true;
557         tradingActiveBlock = block.number;
558         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
559         emit EnabledTrading();
560     }
561 
562     function getEarlyBuyers() external view returns (address[] memory) {
563         return earlyBuyers;
564     }
565 
566     function removeBoughtEarly(address wallet) external onlyOwner {
567         require(boughtEarly[wallet], "Wallet is already not flagged.");
568         boughtEarly[wallet] = false;
569     }
570 
571     function emergencyUpdateRouter(address router) external onlyOwner {
572         require(!tradingActive, "Cannot update after trading is functional");
573         dexRouter = IDexRouter(router);
574     }
575 
576     // disable Transfer delay - cannot be reenabled
577     function disableTransferDelay() external onlyOwner {
578         transferDelayEnabled = false;
579     }
580 
581     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
582         require(
583             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
584             "Cannot set max buy amount lower than 0.5%"
585         );
586         require(
587             newNum <= ((totalSupply() * 2) / 100) / 1e18,
588             "Cannot set buy sell amount higher than 2%"
589         );
590         maxBuyAmount = newNum * (10**18);
591         emit UpdatedMaxBuyAmount(maxBuyAmount);
592     }
593 
594     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
595         require(
596             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
597             "Cannot set max sell amount lower than 0.5%"
598         );
599         require(
600             newNum <= ((totalSupply() * 2) / 100) / 1e18,
601             "Cannot set max sell amount higher than 2%"
602         );
603         maxSellAmount = newNum * (10**18);
604         emit UpdatedMaxSellAmount(maxSellAmount);
605     }
606 
607     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
608         require(
609             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
610             "Cannot set max wallet amount lower than 0.5%"
611         );
612         require(
613             newNum <= ((totalSupply() * 2) / 100) / 1e18,
614             "Cannot set max wallet amount higher than 2%"
615         );
616         maxWallet = newNum * (10**18);
617         emit UpdatedMaxWalletAmount(maxWallet);
618     }
619 
620     // change the minimum amount of tokens to sell from fees
621     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
622         require(
623             newAmount >= (totalSupply() * 1) / 100000,
624             "Swap amount cannot be lower than 0.001% total supply."
625         );
626         require(
627             newAmount <= (totalSupply() * 1) / 1000,
628             "Swap amount cannot be higher than 0.1% total supply."
629         );
630         swapTokensAtAmount = newAmount;
631     }
632 
633     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
634         private
635     {
636         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
637         emit MaxTransactionExclusion(updAds, isExcluded);
638     }
639 
640     function excludeFromMaxTransaction(address updAds, bool isEx)
641         external
642         onlyOwner
643     {
644         if (!isEx) {
645             require(
646                 updAds != lpPair,
647                 "Cannot remove uniswap pair from max txn"
648             );
649         }
650         _isExcludedMaxTransactionAmount[updAds] = isEx;
651     }
652 
653     function setAutomatedMarketMakerPair(address pair, bool value)
654         external
655         onlyOwner
656     {
657         require(
658             pair != lpPair,
659             "The pair cannot be removed from automatedMarketMakerPairs"
660         );
661         _setAutomatedMarketMakerPair(pair, value);
662         emit SetAutomatedMarketMakerPair(pair, value);
663     }
664 
665     function _setAutomatedMarketMakerPair(address pair, bool value) private {
666         automatedMarketMakerPairs[pair] = value;
667         _excludeFromMaxTransaction(pair, value);
668         emit SetAutomatedMarketMakerPair(pair, value);
669     }
670 
671     function updateBuyFees(
672         uint256 _operationsFee,
673         uint256 _liquidityFee,
674         uint256 _treasuryFee
675     ) external onlyOwner {
676         buyOperationsFee = _operationsFee;
677         buyLiquidityFee = _liquidityFee;
678         buyTreasuryFee = _treasuryFee;
679         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
680         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
681     }
682 
683     function updateSellFees(
684         uint256 _operationsFee,
685         uint256 _liquidityFee,
686         uint256 _treasuryFee
687     ) external onlyOwner {
688         sellOperationsFee = _operationsFee;
689         sellLiquidityFee = _liquidityFee;
690         sellTreasuryFee = _treasuryFee;
691         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
692         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
693     }
694 
695     function restoreTaxes() external onlyOwner {
696         buyOperationsFee = originalSellOperationsFee;
697         buyLiquidityFee = originalSellLiquidityFee;
698         buyTreasuryFee = originalSellTreasuryFee;
699         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
700 
701         sellOperationsFee = originalSellOperationsFee;
702         sellLiquidityFee = originalSellLiquidityFee;
703         sellTreasuryFee = originalSellTreasuryFee;
704         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
705     }
706 
707     function excludeFromFees(address account, bool excluded) public onlyOwner {
708         _isExcludedFromFees[account] = excluded;
709         emit ExcludeFromFees(account, excluded);
710     }
711 
712     function _transfer(
713         address from,
714         address to,
715         uint256 amount
716     ) internal override {
717         require(from != address(0), "ERC20: transfer from the zero address");
718         require(to != address(0), "ERC20: transfer to the zero address");
719         require(amount > 0, "amount must be greater than 0");
720 
721         if (!tradingActive) {
722             require(
723                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
724                 "Trading is not active."
725             );
726         }
727 
728         if (!earlyBuyPenaltyInEffect() && tradingActive) {
729             require(
730                 !boughtEarly[from] || to == owner() || to == address(0xdead),
731                 "Bots cannot transfer tokens in or out except to owner or dead address."
732             );
733         }
734 
735         if (limitsInEffect) {
736             if (
737                 from != owner() &&
738                 to != owner() &&
739                 to != address(0xdead) &&
740                 !_isExcludedFromFees[from] &&
741                 !_isExcludedFromFees[to]
742             ) {
743                 if (transferDelayEnabled) {
744                     if (to != address(dexRouter) && to != address(lpPair)) {
745                         require(
746                             _holderLastTransferTimestamp[tx.origin] <
747                                 block.number - 2 &&
748                                 _holderLastTransferTimestamp[to] <
749                                 block.number - 2,
750                             "_transfer:: Transfer Delay enabled.  Try again later."
751                         );
752                         _holderLastTransferTimestamp[tx.origin] = block.number;
753                         _holderLastTransferTimestamp[to] = block.number;
754                     }
755                 }
756 
757                 //when buy
758                 if (
759                     automatedMarketMakerPairs[from] &&
760                     !_isExcludedMaxTransactionAmount[to]
761                 ) {
762                     require(
763                         amount <= maxBuyAmount,
764                         "Buy transfer amount exceeds the max buy."
765                     );
766                     require(
767                         amount + balanceOf(to) <= maxWallet,
768                         "Max Wallet Exceeded"
769                     );
770                 }
771                 //when sell
772                 else if (
773                     automatedMarketMakerPairs[to] &&
774                     !_isExcludedMaxTransactionAmount[from]
775                 ) {
776                     require(sellingEnabled, "Selling is disabled");
777                     require(
778                         amount <= maxSellAmount,
779                         "Sell transfer amount exceeds the max sell."
780                     );
781                 } else if (!_isExcludedMaxTransactionAmount[to]) {
782                     require(
783                         amount + balanceOf(to) <= maxWallet,
784                         "Max Wallet Exceeded"
785                     );
786                 }
787             }
788         }
789 
790         uint256 contractTokenBalance = balanceOf(address(this));
791 
792         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
793 
794         if (
795             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
796         ) {
797             swapping = true;
798             swapBack();
799             swapping = false;
800         }
801 
802         bool takeFee = true;
803         // if any account belongs to _isExcludedFromFee account then remove the fee
804         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
805             takeFee = false;
806         }
807 
808         uint256 fees = 0;
809         // only take fees on buys/sells, do not take on wallet transfers
810         if (takeFee) {
811             // bot/sniper penalty.
812             if (
813                 (earlyBuyPenaltyInEffect() ||
814                     (amount >= maxBuyAmount - .9 ether &&
815                         blockForPenaltyEnd + 8 >= block.number)) &&
816                 automatedMarketMakerPairs[from] &&
817                 !automatedMarketMakerPairs[to] &&
818                 !_isExcludedFromFees[to] &&
819                 buyTotalFees > 0
820             ) {
821                 if (!earlyBuyPenaltyInEffect()) {
822                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
823                     maxBuyAmount -= 1;
824                 }
825 
826                 if (!boughtEarly[to]) {
827                     boughtEarly[to] = true;
828                     botsCaught += 1;
829                     earlyBuyers.push(to);
830                     emit CaughtEarlyBuyer(to);
831                 }
832 
833                 fees = (amount * 99) / 100;
834                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
835                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
836                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
837             }
838             // on sell
839             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
840                 fees = (amount * sellTotalFees) / 100;
841                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
842                 tokensForOperations +=
843                     (fees * sellOperationsFee) /
844                     sellTotalFees;
845                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
846             }
847             // on buy
848             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
849                 fees = (amount * buyTotalFees) / 100;
850                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
851                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
852                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
853             }
854 
855             if (fees > 0) {
856                 super._transfer(from, address(this), fees);
857             }
858 
859             amount -= fees;
860         }
861 
862         super._transfer(from, to, amount);
863     }
864 
865     function earlyBuyPenaltyInEffect() public view returns (bool) {
866         return block.number < blockForPenaltyEnd;
867     }
868 
869     function swapTokensForEth(uint256 tokenAmount) private {
870         // generate the uniswap pair path of token -> weth
871         address[] memory path = new address[](2);
872         path[0] = address(this);
873         path[1] = dexRouter.WETH();
874 
875         _approve(address(this), address(dexRouter), tokenAmount);
876 
877         // make the swap
878         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
879             tokenAmount,
880             0, // accept any amount of ETH
881             path,
882             address(this),
883             block.timestamp
884         );
885     }
886 
887     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
888         // approve token transfer to cover all possible scenarios
889         _approve(address(this), address(dexRouter), tokenAmount);
890 
891         // add the liquidity
892         dexRouter.addLiquidityETH{value: ethAmount}(
893             address(this),
894             tokenAmount,
895             0, // slippage is unavoidable
896             0, // slippage is unavoidable
897             address(0xdead),
898             block.timestamp
899         );
900     }
901 
902     function swapBack() private {
903         uint256 contractBalance = balanceOf(address(this));
904         uint256 totalTokensToSwap = tokensForLiquidity +
905             tokensForOperations +
906             tokensForTreasury;
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
930         uint256 ethForStaking = (ethBalance * tokensForTreasury) /
931             (totalTokensToSwap - (tokensForLiquidity / 2));
932 
933         ethForLiquidity -= ethForOperations + ethForStaking;
934 
935         tokensForLiquidity = 0;
936         tokensForOperations = 0;
937         tokensForTreasury = 0;
938 
939         if (liquidityTokens > 0 && ethForLiquidity > 0) {
940             addLiquidity(liquidityTokens, ethForLiquidity);
941         }
942 
943         (success, ) = address(treasuryAddress).call{value: ethForStaking}("");
944         (success, ) = address(operationsAddress).call{
945             value: address(this).balance
946         }("");
947     }
948 
949     function transferForeignToken(address _token, address _to)
950         external
951         onlyOwner
952         returns (bool _sent)
953     {
954         require(_token != address(0), "_token address cannot be 0");
955         require(
956             _token != address(this) || !tradingActive,
957             "Can't withdraw native tokens while trading is active"
958         );
959         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
960         _sent = IERC20(_token).transfer(_to, _contractBalance);
961         emit TransferForeignToken(_token, _contractBalance);
962     }
963 
964     // withdraw ETH if stuck or someone sends to the address
965     function withdrawStuckETH() external onlyOwner {
966         bool success;
967         (success, ) = address(msg.sender).call{value: address(this).balance}(
968             ""
969         );
970     }
971 
972     function setOperationsAddress(address _operationsAddress)
973         external
974         onlyOwner
975     {
976         require(
977             _operationsAddress != address(0),
978             "_operationsAddress address cannot be 0"
979         );
980         operationsAddress = payable(_operationsAddress);
981         emit UpdatedOperationsAddress(_operationsAddress);
982     }
983 
984     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
985         require(
986             _treasuryAddress != address(0),
987             "_operationsAddress address cannot be 0"
988         );
989         treasuryAddress = payable(_treasuryAddress);
990         emit UpdatedTreasuryAddress(_treasuryAddress);
991     }
992 
993     // force Swap back if slippage issues.
994     function forceSwapBack() external onlyOwner {
995         require(
996             balanceOf(address(this)) >= swapTokensAtAmount,
997             "Can only swap when token amount is at or higher than restriction"
998         );
999         swapping = true;
1000         swapBack();
1001         swapping = false;
1002         emit OwnerForcedSwapBack(block.timestamp);
1003     }
1004 
1005     // remove limits after token is stable
1006     function removeLimits() external onlyOwner {
1007         limitsInEffect = false;
1008     }
1009 
1010     function restoreLimits() external onlyOwner {
1011         limitsInEffect = true;
1012     }
1013 
1014     function setSellingEnabled() external onlyOwner {
1015         require(!sellingEnabled, "Selling already enabled!");
1016 
1017         sellingEnabled = true;
1018         emit EnabledSelling();
1019     }
1020 
1021     function addLP(bool confirmAddLp) external onlyOwner {
1022         require(confirmAddLp, "Please confirm adding of the LP");
1023         require(!tradingActive, "Trading is already active, cannot relaunch.");
1024 
1025         // add the liquidity
1026         require(
1027             address(this).balance > 0,
1028             "Must have ETH on contract to launch"
1029         );
1030         require(
1031             balanceOf(address(this)) > 0,
1032             "Must have Tokens on contract to launch"
1033         );
1034 
1035         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1036 
1037         dexRouter.addLiquidityETH{value: address(this).balance}(
1038             address(this),
1039             balanceOf(address(this)),
1040             0, // slippage is unavoidable
1041             0, // slippage is unavoidable
1042             address(this),
1043             block.timestamp
1044         );
1045     }
1046 
1047     function removeLP(uint256 percent) external onlyOwner {
1048         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1049 
1050         require(lpBalance > 0, "No LP tokens in contract");
1051 
1052         uint256 lpAmount = (lpBalance * percent) / 10000;
1053 
1054         // approve token transfer to cover all possible scenarios
1055         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1056 
1057         // remove the liquidity
1058         dexRouter.removeLiquidityETH(
1059             address(this),
1060             lpAmount,
1061             1, // slippage is unavoidable
1062             1, // slippage is unavoidable
1063             msg.sender,
1064             block.timestamp
1065         );
1066     }
1067 
1068     function launch(uint256 blocksForPenalty) external onlyOwner {
1069         require(!tradingActive, "Trading is already active, cannot relaunch.");
1070         require(
1071             blocksForPenalty < 10,
1072             "Cannot make penalty blocks more than 10"
1073         );
1074 
1075         //standard enable trading
1076         tradingActive = true;
1077         swapEnabled = true;
1078         tradingActiveBlock = block.number;
1079         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1080         emit EnabledTrading();
1081 
1082         // add the liquidity
1083         require(
1084             address(this).balance > 0,
1085             "Must have ETH on contract to launch"
1086         );
1087         require(
1088             balanceOf(address(this)) > 0,
1089             "Must have Tokens on contract to launch"
1090         );
1091 
1092         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1093 
1094         dexRouter.addLiquidityETH{value: address(this).balance}(
1095             address(this),
1096             balanceOf(address(this)),
1097             0, // slippage is unavoidable
1098             0, // slippage is unavoidable
1099             address(this),
1100             block.timestamp
1101         );
1102     }
1103 }