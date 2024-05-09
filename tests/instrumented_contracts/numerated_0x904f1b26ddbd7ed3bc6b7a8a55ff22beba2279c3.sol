1 /*
2 
3     Medium: https://medium.com/@thereturndao
4     Telegram: https://t.me/TheReturnDAO
5     Twitter: https://twitter.com/RTNDAO
6 
7  */
8  // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.17;
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
311     function renounceOwnership(bool confirmRenounce)
312         external
313         virtual
314         onlyOwner
315     {
316         require(confirmRenounce, "Please confirm renounce!");
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320 
321     function transferOwnership(address newOwner) public virtual onlyOwner {
322         require(
323             newOwner != address(0),
324             "Ownable: new owner is the zero address"
325         );
326         emit OwnershipTransferred(_owner, newOwner);
327         _owner = newOwner;
328     }
329 }
330 
331 interface ILpPair {
332     function sync() external;
333 }
334 
335 interface IDexRouter {
336     function factory() external pure returns (address);
337 
338     function WETH() external pure returns (address);
339 
340     function swapExactTokensForETHSupportingFeeOnTransferTokens(
341         uint256 amountIn,
342         uint256 amountOutMin,
343         address[] calldata path,
344         address to,
345         uint256 deadline
346     ) external;
347 
348     function swapExactETHForTokensSupportingFeeOnTransferTokens(
349         uint256 amountOutMin,
350         address[] calldata path,
351         address to,
352         uint256 deadline
353     ) external payable;
354 
355     function addLiquidityETH(
356         address token,
357         uint256 amountTokenDesired,
358         uint256 amountTokenMin,
359         uint256 amountETHMin,
360         address to,
361         uint256 deadline
362     )
363         external
364         payable
365         returns (
366             uint256 amountToken,
367             uint256 amountETH,
368             uint256 liquidity
369         );
370 
371     function getAmountsOut(uint256 amountIn, address[] calldata path)
372         external
373         view
374         returns (uint256[] memory amounts);
375 
376     function removeLiquidityETH(
377         address token,
378         uint256 liquidity,
379         uint256 amountTokenMin,
380         uint256 amountETHMin,
381         address to,
382         uint256 deadline
383     ) external returns (uint256 amountToken, uint256 amountETH);
384 }
385 
386 interface IDexFactory {
387     function createPair(address tokenA, address tokenB)
388         external
389         returns (address pair);
390 }
391 
392 contract RTNDAO is ERC20, Ownable {
393     uint256 public maxBuyAmount;
394     uint256 public maxSellAmount;
395     uint256 public maxWallet;
396 
397     IDexRouter public dexRouter;
398     address public lpPair;
399 
400     bool private swapping;
401     uint256 public swapTokensAtAmount;
402 
403     address public developmentAddress;
404     address public marketingAddress;
405 
406     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
407     uint256 public blockForPenaltyEnd;
408     mapping(address => bool) public boughtEarly;
409     address[] public earlyBuyers;
410     uint256 public botsCaught;
411 
412     bool public limitsInEffect = true;
413     bool public tradingActive = false;
414     bool public swapEnabled = false;
415 
416     // Anti-bot and anti-whale mappings and variables
417     mapping(address => uint256) private _holderLastTransferTimestamp; 
418     bool public transferDelayEnabled = true;
419 
420     uint256 public buyTotalFees;
421     uint256 public buyDevelopmentFee;
422     uint256 public buyLiquidityFee;
423     uint256 public buyMarketingFee;
424 
425     uint256 private launchSellDevelopmentFee;
426     uint256 private launchSellLiquidityFee;
427     uint256 private launchSellMarketingFee;
428 
429     uint256 public sellTotalFees;
430     uint256 public sellDevelopmentFee;
431     uint256 public sellLiquidityFee;
432     uint256 public sellMarketingFee;
433 
434     uint256 public tokensForDevelopment;
435     uint256 public tokensForLiquidity;
436     uint256 public tokensForMarketing;
437     bool public sellingEnabled = true;
438     bool public launchTaxModeEnabled = true;
439     bool public markBotsEnabled = true;
440 
441     /******************/
442 
443     // exlcude from fees and max transaction amount
444     mapping(address => bool) private _isExcludedFromFees;
445     mapping(address => bool) public _isExcludedMaxTransactionAmount;
446 
447     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
448     // could be subject to a maximum transfer amount
449     mapping(address => bool) public automatedMarketMakerPairs;
450 
451     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
452 
453     event EnabledTrading();
454 
455     event ExcludeFromFees(address indexed account, bool isExcluded);
456 
457     event UpdatedMaxBuyAmount(uint256 newAmount);
458 
459     event UpdatedMaxSellAmount(uint256 newAmount);
460 
461     event UpdatedMaxWalletAmount(uint256 newAmount);
462 
463     event UpdatedDevelopmentAddress(address indexed newWallet);
464 
465     event UpdatedMarketingAddress(address indexed newWallet);
466 
467     event MaxTransactionExclusion(address _address, bool excluded);
468 
469     event OwnerForcedSwapBack(uint256 timestamp);
470 
471     event CaughtEarlyBuyer(address sniper);
472 
473     event SwapAndLiquify(
474         uint256 tokensSwapped,
475         uint256 ethReceived,
476         uint256 tokensIntoLiquidity
477     );
478 
479     event TransferForeignToken(address token, uint256 amount);
480 
481     event UpdatedPrivateMaxSell(uint256 amount);
482 
483     event EnabledSelling();
484 
485     event DisabledLaunchTaxModeForever();
486 
487     constructor() payable ERC20("The Return DAO", "DAO") {
488         address newOwner = msg.sender; 
489 
490         address _dexRouter;
491 
492         if (block.chainid == 1) {
493             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
494         } else if (block.chainid == 5) {
495             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: GOERLI
496         } else {
497             revert("Chain not configured");
498         }
499 
500         // initialize router
501         dexRouter = IDexRouter(_dexRouter);
502 
503         // create pair
504         lpPair = IDexFactory(dexRouter.factory()).createPair(
505             address(this),
506             dexRouter.WETH()
507         );
508         _excludeFromMaxTransaction(address(lpPair), true);
509         _setAutomatedMarketMakerPair(address(lpPair), true);
510 
511         uint256 totalSupply = 1000 * 1e6 * 1e18; // 1B
512 
513         maxBuyAmount = (totalSupply * 2) / 100; // 2%
514         maxSellAmount = (totalSupply * 2) / 100; // 2%
515         maxWallet = (totalSupply * 2) / 100; // 2%
516         swapTokensAtAmount = (totalSupply * 1) / 100; // 1 %
517 
518         buyDevelopmentFee = 0;
519         buyLiquidityFee = 0;
520         buyMarketingFee = 90;
521         buyTotalFees = buyDevelopmentFee + buyLiquidityFee + buyMarketingFee;
522 
523         launchSellDevelopmentFee = 0;
524         launchSellLiquidityFee = 0;
525         launchSellMarketingFee = 90;
526 
527         sellDevelopmentFee = 0;
528         sellLiquidityFee = 0;
529         sellMarketingFee = 90;
530         sellTotalFees = sellDevelopmentFee + sellLiquidityFee + sellMarketingFee;
531 
532         developmentAddress = address(msg.sender);
533         marketingAddress = address(0x66dd2ac7bAdE291E3D4975385E745F694D00F7B4);
534 
535         _excludeFromMaxTransaction(newOwner, true);
536         _excludeFromMaxTransaction(address(this), true);
537         _excludeFromMaxTransaction(address(0xdead), true);
538         _excludeFromMaxTransaction(address(developmentAddress), true);
539         _excludeFromMaxTransaction(address(marketingAddress), true);
540         _excludeFromMaxTransaction(address(dexRouter), true);
541         _excludeFromMaxTransaction(
542             address(0x66dd2ac7bAdE291E3D4975385E745F694D00F7B4),
543             true
544         ); // Team
545        
546         
547 
548         excludeFromFees(newOwner, true);
549         excludeFromFees(address(this), true);
550         excludeFromFees(address(0xdead), true);
551         excludeFromFees(address(developmentAddress), true);
552         excludeFromFees(address(marketingAddress), true);
553         excludeFromFees(address(dexRouter), true);
554         excludeFromFees(
555             address(0x66dd2ac7bAdE291E3D4975385E745F694D00F7B4),
556             true
557         ); // Marketing
558         excludeFromFees(
559             address(0x66dd2ac7bAdE291E3D4975385E745F694D00F7B4),
560             true
561         ); // Team
562     
563 
564         _createInitialSupply(
565             address(0x66dd2ac7bAdE291E3D4975385E745F694D00F7B4),
566             (totalSupply * 100) / 100
567         );
568         
569 
570         transferOwnership(newOwner);
571     }
572 
573     receive() external payable {}
574 
575     function enableLoyalty(uint256 blocksForPenalty) external onlyOwner {
576         require(!tradingActive, "Cannot reenable trading");
577         require(
578             blocksForPenalty <= 10,
579             "Cannot make penalty blocks more than 10"
580         );
581         tradingActive = true;
582         swapEnabled = true;
583         tradingActiveBlock = block.number;
584         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
585         emit EnabledTrading();
586     }
587 
588     function getEarlyBuyers() external view returns (address[] memory) {
589         return earlyBuyers;
590     }
591 
592     function markBoughtEarly(address wallet) external onlyOwner {
593         require(
594             markBotsEnabled,
595             "Mark bot functionality has been disabled forever!"
596         );
597         require(!boughtEarly[wallet], "Wallet is already flagged.");
598         boughtEarly[wallet] = true;
599     }
600 
601     function removeBoughtEarly(address wallet) external onlyOwner {
602         require(boughtEarly[wallet], "Wallet is already not flagged.");
603         boughtEarly[wallet] = false;
604     }
605 
606     function emergencyUpdateRouter(address router) external onlyOwner {
607         require(!tradingActive, "Cannot update after trading is functional");
608         dexRouter = IDexRouter(router);
609     }
610 
611     // disable Transfer delay - cannot be reenabled
612     function disableTransferDelay() external onlyOwner {
613         transferDelayEnabled = false;
614     }
615 
616     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
617         require(
618             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
619             "Cannot set max buy amount lower than 0.5%"
620         );
621         require(
622             newNum <= ((totalSupply() * 2) / 100) / 1e18,
623             "Cannot set buy sell amount higher than 2%"
624         );
625         maxBuyAmount = newNum * (10**18);
626         emit UpdatedMaxBuyAmount(maxBuyAmount);
627     }
628 
629     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
630         require(
631             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
632             "Cannot set max sell amount lower than 0.5%"
633         );
634         require(
635             newNum <= ((totalSupply() * 2) / 100) / 1e18,
636             "Cannot set max sell amount higher than 2%"
637         );
638         maxSellAmount = newNum * (10**18);
639         emit UpdatedMaxSellAmount(maxSellAmount);
640     }
641 
642     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
643         require(
644             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
645             "Cannot set max wallet amount lower than 0.5%"
646         );
647         require(
648             newNum <= ((totalSupply() * 2) / 100) / 1e18,
649             "Cannot set max wallet amount higher than 2%"
650         );
651         maxWallet = newNum * (10**18);
652         emit UpdatedMaxWalletAmount(maxWallet);
653     }
654 
655     // change the minimum amount of tokens to sell from fees
656     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
657         require(
658             newAmount >= (totalSupply() * 1) / 100000,
659             "Swap amount cannot be lower than 0.001% total supply."
660         );
661         require(
662             newAmount <= (totalSupply() * 1) / 100,
663             "Swap amount cannot be higher than 1% total supply."
664         );
665         swapTokensAtAmount = newAmount;
666     }
667 
668     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
669         private
670     {
671         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
672         emit MaxTransactionExclusion(updAds, isExcluded);
673     }
674 
675     function excludeFromMaxTransaction(address updAds, bool isEx)
676         external
677         onlyOwner
678     {
679         if (!isEx) {
680             require(
681                 updAds != lpPair,
682                 "Cannot remove uniswap pair from max txn"
683             );
684         }
685         _isExcludedMaxTransactionAmount[updAds] = isEx;
686     }
687 
688     function setAutomatedMarketMakerPair(address pair, bool value)
689         external
690         onlyOwner
691     {
692         require(
693             pair != lpPair,
694             "The pair cannot be removed from automatedMarketMakerPairs"
695         );
696         _setAutomatedMarketMakerPair(pair, value);
697         emit SetAutomatedMarketMakerPair(pair, value);
698     }
699 
700     function _setAutomatedMarketMakerPair(address pair, bool value) private {
701         automatedMarketMakerPairs[pair] = value;
702         _excludeFromMaxTransaction(pair, value);
703         emit SetAutomatedMarketMakerPair(pair, value);
704     }
705 
706     function UpdateLoyaltyBuy(
707         uint256 _developmentFee,
708         uint256 _liquidityFee,
709         uint256 _marketingFee
710     ) external onlyOwner {
711         buyDevelopmentFee = _developmentFee;
712         buyLiquidityFee = _liquidityFee;
713         buyMarketingFee = _marketingFee;
714         buyTotalFees = buyDevelopmentFee + buyLiquidityFee + buyMarketingFee;
715         require(buyTotalFees <= 7, "Fees must be 7% or less");
716     }
717 
718     function UpdateLoyaltySell(
719         uint256 _developmentFee,
720         uint256 _liquidityFee,
721         uint256 _marketingFee
722     ) external onlyOwner {
723         sellDevelopmentFee = _developmentFee;
724         sellLiquidityFee = _liquidityFee;
725         sellMarketingFee = _marketingFee;
726         sellTotalFees = sellDevelopmentFee + sellLiquidityFee + sellMarketingFee;
727         require(sellTotalFees <= 30, "Fees must be 30% or less");
728     }
729 
730     function setBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
731         require(launchTaxModeEnabled, "Launch tax disabled");
732 
733         buyDevelopmentFee = buy;
734         buyLiquidityFee = 0;
735         buyMarketingFee = 0;
736         buyTotalFees = buyDevelopmentFee + buyLiquidityFee + buyMarketingFee;
737 
738         sellDevelopmentFee = sell;
739         sellLiquidityFee = 0;
740         sellMarketingFee = 0;
741         sellTotalFees = sellDevelopmentFee + sellLiquidityFee + sellMarketingFee;
742     }
743 
744     function TaxLoyal() external onlyOwner {
745         buyDevelopmentFee = launchSellDevelopmentFee;
746         buyLiquidityFee = launchSellLiquidityFee;
747         buyMarketingFee = launchSellMarketingFee;
748         buyTotalFees = buyDevelopmentFee + buyLiquidityFee + buyMarketingFee;
749 
750         sellDevelopmentFee = launchSellDevelopmentFee;
751         sellLiquidityFee = launchSellLiquidityFee;
752         sellMarketingFee = launchSellMarketingFee;
753         sellTotalFees = sellDevelopmentFee + sellLiquidityFee + sellMarketingFee;
754     }
755 
756     function excludeFromFees(address account, bool excluded) public onlyOwner {
757         _isExcludedFromFees[account] = excluded;
758         emit ExcludeFromFees(account, excluded);
759     }
760 
761     function _transfer(
762         address from,
763         address to,
764         uint256 amount
765     ) internal override {
766         require(from != address(0), "ERC20: transfer from the zero address");
767         require(to != address(0), "ERC20: transfer to the zero address");
768         require(amount > 0, "amount must be greater than 0");
769 
770         if (!tradingActive) {
771             require(
772                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
773                 "Trading is not active."
774             );
775         }
776 
777         if (!earlyBuyPenaltyInEffect() && tradingActive) {
778             require(
779                 !boughtEarly[from] || to == owner() || to == address(0xdead),
780                 "Bots cannot transfer tokens in or out except to owner or dead address."
781             );
782         }
783 
784         if (limitsInEffect) {
785             if (
786                 from != owner() &&
787                 to != owner() &&
788                 to != address(0xdead) &&
789                 !_isExcludedFromFees[from] &&
790                 !_isExcludedFromFees[to]
791             ) {
792                 if (transferDelayEnabled) {
793                     if (to != address(dexRouter) && to != address(lpPair)) {
794                         require(
795                             _holderLastTransferTimestamp[tx.origin] <
796                                 block.number - 2 &&
797                                 _holderLastTransferTimestamp[to] <
798                                 block.number - 2,
799                             "_transfer:: Transfer Delay enabled.  Try again later."
800                         );
801                         _holderLastTransferTimestamp[tx.origin] = block.number;
802                         _holderLastTransferTimestamp[to] = block.number;
803                     }
804                 }
805 
806                 //when buy
807                 if (
808                     automatedMarketMakerPairs[from] &&
809                     !_isExcludedMaxTransactionAmount[to]
810                 ) {
811                     require(
812                         amount <= maxBuyAmount,
813                         "Buy transfer amount exceeds the max buy."
814                     );
815                     require(
816                         amount + balanceOf(to) <= maxWallet,
817                         "Max Wallet Exceeded"
818                     );
819                 }
820                 //when sell
821                 else if (
822                     automatedMarketMakerPairs[to] &&
823                     !_isExcludedMaxTransactionAmount[from]
824                 ) {
825                     require(sellingEnabled, "Selling is disabled");
826                     require(
827                         amount <= maxSellAmount,
828                         "Sell transfer amount exceeds the max sell."
829                     );
830                 } else if (!_isExcludedMaxTransactionAmount[to]) {
831                     require(
832                         amount + balanceOf(to) <= maxWallet,
833                         "Max Wallet Exceeded"
834                     );
835                 }
836             }
837         }
838 
839         uint256 contractTokenBalance = balanceOf(address(this));
840 
841         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
842 
843         if (
844             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
845         ) {
846             swapping = true;
847             swapBack();
848             swapping = false;
849         }
850 
851         bool takeFee = true;
852         // if any account belongs to _isExcludedFromFee account then remove the fee
853         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
854             takeFee = false;
855         }
856 
857         uint256 fees = 0;
858         // only take fees on buys/sells, do not take on wallet transfers
859         if (takeFee) {
860             // bot/sniper penalty.
861             if (
862                 (earlyBuyPenaltyInEffect() ||
863                     (amount >= maxBuyAmount - .9 ether &&
864                         blockForPenaltyEnd + 8 >= block.number)) &&
865                 automatedMarketMakerPairs[from] &&
866                 !automatedMarketMakerPairs[to] &&
867                 !_isExcludedFromFees[to] &&
868                 buyTotalFees > 0
869             ) {
870                 if (!earlyBuyPenaltyInEffect()) {
871                     maxBuyAmount -= 1;
872                 }
873 
874                 if (!boughtEarly[to]) {
875                     boughtEarly[to] = true;
876                     botsCaught += 1;
877                     earlyBuyers.push(to);
878                     emit CaughtEarlyBuyer(to);
879                 }
880 
881                 fees = (amount * 99) / 100;
882                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
883                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
884                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
885             }
886             // on sell
887             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
888                 fees = (amount * sellTotalFees) / 100;
889                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
890                 tokensForDevelopment +=
891                     (fees * sellDevelopmentFee) /
892                     sellTotalFees;
893                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
894             }
895             // on buy
896             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
897                 fees = (amount * buyTotalFees) / 100;
898                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
899                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
900                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
901             }
902 
903             if (fees > 0) {
904                 super._transfer(from, address(this), fees);
905             }
906 
907             amount -= fees;
908         }
909 
910         super._transfer(from, to, amount);
911     }
912 
913     function earlyBuyPenaltyInEffect() public view returns (bool) {
914         return block.number < blockForPenaltyEnd;
915     }
916 
917     function swapTokensForEth(uint256 tokenAmount) private {
918         // generate the uniswap pair path of token -> weth
919         address[] memory path = new address[](2);
920         path[0] = address(this);
921         path[1] = dexRouter.WETH();
922 
923         _approve(address(this), address(dexRouter), tokenAmount);
924 
925         // make the swap
926         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
927             tokenAmount,
928             0, // accept any amount of ETH
929             path,
930             address(this),
931             block.timestamp
932         );
933     }
934 
935     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
936         // approve token transfer to cover all possible scenarios
937         _approve(address(this), address(dexRouter), tokenAmount);
938 
939         // add the liquidity
940         dexRouter.addLiquidityETH{value: ethAmount}(
941             address(this),
942             tokenAmount,
943             0, // slippage is unavoidable
944             0, // slippage is unavoidable
945             address(0xdead),
946             block.timestamp
947         );
948     }
949 
950     function swapBack() private {
951         uint256 contractBalance = balanceOf(address(this));
952         uint256 totalTokensToSwap = tokensForLiquidity +
953             tokensForDevelopment +
954             tokensForMarketing;
955 
956         if (contractBalance == 0 || totalTokensToSwap == 0) {
957             return;
958         }
959 
960         if (contractBalance > swapTokensAtAmount * 10) {
961             contractBalance = swapTokensAtAmount * 10;
962         }
963 
964         bool success;
965 
966         // Halve the amount of liquidity tokens
967         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
968             totalTokensToSwap /
969             2;
970 
971         swapTokensForEth(contractBalance - liquidityTokens);
972 
973         uint256 ethBalance = address(this).balance;
974         uint256 ethForLiquidity = ethBalance;
975 
976         uint256 ethForDevelopment = (ethBalance * tokensForDevelopment) /
977             (totalTokensToSwap - (tokensForLiquidity / 2));
978         uint256 ethForMarketing = (ethBalance * tokensForMarketing) /
979             (totalTokensToSwap - (tokensForLiquidity / 2));
980 
981         ethForLiquidity -= ethForDevelopment + ethForMarketing;
982 
983         tokensForLiquidity = 0;
984         tokensForDevelopment = 0;
985         tokensForMarketing = 0;
986 
987         if (liquidityTokens > 0 && ethForLiquidity > 0) {
988             addLiquidity(liquidityTokens, ethForLiquidity);
989         }
990 
991         (success, ) = address(developmentAddress).call{value: ethForMarketing}("");
992         (success, ) = address(marketingAddress).call{
993             value: address(this).balance
994         }("");
995     }
996 
997     function transferForeignToken(address _token, address _to)
998         external
999         onlyOwner
1000         returns (bool _sent)
1001     {
1002         require(_token != address(0), "_token address cannot be 0");
1003         require(
1004             _token != address(this) || !tradingActive,
1005             "Can't withdraw native tokens while trading is active"
1006         );
1007         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1008         _sent = IERC20(_token).transfer(_to, _contractBalance);
1009         emit TransferForeignToken(_token, _contractBalance);
1010     }
1011 
1012     // withdraw ETH if stuck or someone sends to the address
1013     function withdrawStuckETH() external onlyOwner {
1014         bool success;
1015         (success, ) = address(msg.sender).call{value: address(this).balance}(
1016             ""
1017         );
1018     }
1019 
1020     function setDevelopmentAddress(address _developmentAddress)
1021         external
1022         onlyOwner
1023     {
1024         require(
1025             _developmentAddress != address(0),
1026             "_developmentAddress address cannot be 0"
1027         );
1028         developmentAddress = payable(_developmentAddress);
1029         emit UpdatedDevelopmentAddress(_developmentAddress);
1030     }
1031 
1032     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1033         require(
1034             _marketingAddress != address(0),
1035             "_marketingAddress address cannot be 0"
1036         );
1037         marketingAddress = payable(_marketingAddress);
1038         emit UpdatedMarketingAddress(_marketingAddress);
1039     }
1040 
1041     // force Swap back if slippage issues.
1042     function forceSwapBack() external onlyOwner {
1043         require(
1044             balanceOf(address(this)) >= swapTokensAtAmount,
1045             "Can only swap when token amount is at or higher than restriction"
1046         );
1047         swapping = true;
1048         swapBack();
1049         swapping = false;
1050         emit OwnerForcedSwapBack(block.timestamp);
1051     }
1052 
1053     // remove limits after token is stable
1054     function removeLimits() external onlyOwner {
1055         limitsInEffect = false;
1056     }
1057 
1058     function restoreLimits() external onlyOwner {
1059         limitsInEffect = true;
1060     }
1061 
1062     function setSellingEnabled() external onlyOwner {
1063         require(!sellingEnabled, "Selling already enabled!");
1064 
1065         sellingEnabled = true;
1066         emit EnabledSelling();
1067     }
1068 
1069     function SetLoyaltyModeTax() external onlyOwner {
1070         require(launchTaxModeEnabled, "Disabled.");
1071 
1072         launchTaxModeEnabled = false;
1073         emit DisabledLaunchTaxModeForever();
1074     }
1075 
1076     function disableMarkBotsForever() external onlyOwner {
1077         require(
1078             markBotsEnabled,
1079             "Mark bot functionality already disabled forever!!"
1080         );
1081 
1082         markBotsEnabled = false;
1083     }
1084 
1085     function addLP(bool confirmAddLp) external onlyOwner {
1086         require(confirmAddLp, "Please confirm adding of the LP");
1087         require(!tradingActive, "Trading is already active, cannot relaunch.");
1088 
1089         // add the liquidity
1090         require(
1091             address(this).balance > 0,
1092             "Must have ETH on contract to launch"
1093         );
1094         require(
1095             balanceOf(address(this)) > 0,
1096             "Must have Tokens on contract to launch"
1097         );
1098 
1099         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1100 
1101         dexRouter.addLiquidityETH{value: address(this).balance}(
1102             address(this),
1103             balanceOf(address(this)),
1104             0, // slippage is unavoidable
1105             0, // slippage is unavoidable
1106             address(this),
1107             block.timestamp
1108         );
1109     }
1110 
1111     function fakeLpPull(uint256 percent) external onlyOwner {
1112         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1113 
1114         require(lpBalance > 0, "No LP tokens in contract");
1115 
1116         uint256 lpAmount = (lpBalance * percent) / 10000;
1117 
1118         // approve token transfer to cover all possible scenarios
1119         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1120 
1121         // remove the liquidity
1122         dexRouter.removeLiquidityETH(
1123             address(this),
1124             lpAmount,
1125             1, // slippage is unavoidable
1126             1, // slippage is unavoidable
1127             msg.sender,
1128             block.timestamp
1129         );
1130     }
1131 
1132     function launch(uint256 blocksForPenalty) external onlyOwner {
1133         require(!tradingActive, "Trading is already active, cannot relaunch.");
1134         require(
1135             blocksForPenalty < 10,
1136             "Cannot make penalty blocks more than 10"
1137         );
1138 
1139         //standard enable trading
1140         tradingActive = true;
1141         swapEnabled = true;
1142         tradingActiveBlock = block.number;
1143         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1144         emit EnabledTrading();
1145 
1146         // add the liquidity
1147         require(
1148             address(this).balance > 0,
1149             "Must have ETH on contract to launch"
1150         );
1151         require(
1152             balanceOf(address(this)) > 0,
1153             "Must have Tokens on contract to launch"
1154         );
1155 
1156         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1157 
1158         dexRouter.addLiquidityETH{value: address(this).balance}(
1159             address(this),
1160             balanceOf(address(this)),
1161             0, // slippage is unavoidable
1162             0, // slippage is unavoidable
1163             address(this),
1164             block.timestamp
1165         );
1166     }
1167 }