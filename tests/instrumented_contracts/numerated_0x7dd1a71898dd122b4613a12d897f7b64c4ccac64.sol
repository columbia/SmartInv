1 // SPDX-License-Identifier: MIT
2 /*
3     .___  ___.      ___      .______          _______.
4     |   \/   |     /   \     |   _  \        /       |
5     |  \  /  |    /  ^  \    |  |_)  |      |   (----`
6     |  |\/|  |   /  /_\  \   |      /        \   \    
7     |  |  |  |  /  _____  \  |  |\  \----.----)   |   
8     |__|  |__| /__/     \__\ | _| `._____|_______/    
9 
10     https://marsproto.com                                                 
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
373 
374     function removeLiquidityETH(
375         address token,
376         uint256 liquidity,
377         uint256 amountTokenMin,
378         uint256 amountETHMin,
379         address to,
380         uint256 deadline
381     ) external returns (uint256 amountToken, uint256 amountETH);
382 }
383 
384 interface IDexFactory {
385     function createPair(address tokenA, address tokenB)
386         external
387         returns (address pair);
388 }
389 
390 contract MarsProtocol is ERC20, Ownable {
391     uint256 public maxBuyAmount;
392     uint256 public maxSellAmount;
393     uint256 public maxWallet;    
394 
395     IDexRouter public dexRouter;
396     address public lpPair;
397 
398     bool private swapping;
399     uint256 public swapTokensAtAmount;
400 
401     address public operationsAddress;
402     address public treasuryAddress;
403 
404     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
405     uint256 public blockForPenaltyEnd;
406     mapping(address => bool) public boughtEarly;
407     address[] public earlyBuyers;
408     uint256 public botsCaught;
409 
410     bool public limitsInEffect = true;
411     bool public tradingActive = false;
412     bool public swapEnabled = false;
413 
414     // Investor sell limit variables
415     mapping(address => uint256) public nextInvestorSellDate;
416     uint256 public timeBetweenBuys = 360 minutes; // 6 hours
417     uint256 public privateSaleCooldown = 1 minutes; // 1 minutes
418 
419     // Anti-bot and anti-whale mappings and variables
420     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
421     bool public transferDelayEnabled = true;
422 
423     uint256 public buyTotalFees;
424     uint256 public buyOperationsFee;
425     uint256 public buyLiquidityFee;
426     uint256 public buyTreasuryFee;
427 
428     uint256 private originalSellOperationsFee;
429     uint256 private originalSellLiquidityFee;
430     uint256 private originalSellTreasuryFee;
431 
432     uint256 public sellTotalFees;
433     uint256 public sellOperationsFee;
434     uint256 public sellLiquidityFee;
435     uint256 public sellTreasuryFee;
436 
437     uint256 public tokensForOperations;
438     uint256 public tokensForLiquidity;
439     uint256 public tokensForTreasury;
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
463     event UpdatedOperationsAddress(address indexed newWallet);
464 
465     event UpdatedTreasuryAddress(address indexed newWallet);
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
483     constructor() payable ERC20("Mars Protocol", "MARS") {
484         address newOwner = msg.sender; // Deployer is the owner
485 
486         address _dexRouter;
487 
488         if (block.chainid == 1) {
489             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
490         } else if (block.chainid == 4) {
491             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Rinkeby
492         } else {
493             revert("Chain not configured");
494         }
495 
496         // initialize router
497         dexRouter = IDexRouter(_dexRouter);
498 
499         lpPair = IDexFactory(dexRouter.factory()).createPair(
500             address(this),
501             dexRouter.WETH()
502         );
503         _excludeFromMaxTransaction(address(lpPair), true);
504         _setAutomatedMarketMakerPair(address(lpPair), true);        
505 
506         uint256 totalSupply = 1 * 1e12 * 1e18; 
507 
508         maxBuyAmount = (totalSupply * 1) / 100; 
509         maxSellAmount = (totalSupply * 1) / 100; 
510         maxWallet = (totalSupply * 1) / 100; 
511         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
512 
513         buyOperationsFee = 7;
514         buyLiquidityFee = 3;
515         buyTreasuryFee = 0;
516         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
517 
518         originalSellOperationsFee = 4;
519         originalSellLiquidityFee = 1;
520         originalSellTreasuryFee = 0;
521 
522         sellOperationsFee = 7;
523         sellLiquidityFee = 3;
524         sellTreasuryFee = 0;
525         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
526 
527         operationsAddress = address(0xB191d57821E276aa56c69880056C84c7B9919eb4);
528         treasuryAddress = address(0xB191d57821E276aa56c69880056C84c7B9919eb4);
529 
530         _excludeFromMaxTransaction(newOwner, true);
531         _excludeFromMaxTransaction(address(this), true);
532         _excludeFromMaxTransaction(address(0xdead), true);
533         _excludeFromMaxTransaction(address(operationsAddress), true);
534         _excludeFromMaxTransaction(address(treasuryAddress), true);
535         _excludeFromMaxTransaction(address(dexRouter), true);
536 
537         excludeFromFees(newOwner, true);
538         excludeFromFees(address(this), true);
539         excludeFromFees(address(0xdead), true);
540         excludeFromFees(address(operationsAddress), true);
541         excludeFromFees(address(treasuryAddress), true);
542         excludeFromFees(address(dexRouter), true);
543 
544          _createInitialSupply(newOwner, (totalSupply * 30) / 100); // Staking
545          _createInitialSupply(address(this), (totalSupply * 70) / 100); // liquidity
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
569    function unflagBot(address wallet) external onlyOwner {
570         require(boughtEarly[wallet], "Wallet is already not flagged.");
571         boughtEarly[wallet] = false;
572     }
573 
574     function flagBot(address wallet) external onlyOwner {
575         require(!boughtEarly[wallet], "Wallet is already flagged.");
576         boughtEarly[wallet] = true;
577     }
578 
579     function flagMultipleBots(address[] memory wallets) external onlyOwner {
580         require(
581             wallets.length < 600,
582             "Can only mark 600 wallets per txn due to gas limits"
583         );
584         for (uint256 i = 0; i < wallets.length; i++) {
585             address wallet = wallets[i];
586             boughtEarly[wallet] = true;
587         }
588     }
589 
590     function emergencyUpdateRouter(address router) external onlyOwner {
591         require(!tradingActive, "Cannot update after trading is functional");
592         dexRouter = IDexRouter(router);
593     }
594 
595     // disable Transfer delay - cannot be reenabled
596     function disableTransferDelay() external onlyOwner {
597         transferDelayEnabled = false;
598     }
599 
600   function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
601         require(
602             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
603             "Cannot set max buy amount lower than 0.01%"
604         );
605         require(
606             newNum <= ((totalSupply() * 2) / 100) / 1e18,
607             "Cannot set max buy amount higher than 2%"
608         );        
609         maxBuyAmount = newNum * (1e18);
610         emit UpdatedMaxBuyAmount(maxBuyAmount);
611     }
612 
613     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
614         require(
615             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
616             "Cannot set max sell amount lower than 0.01%"
617         );
618         require(
619             newNum <= ((totalSupply() * 2) / 100) / 1e18,
620             "Cannot set max sell amount higher than 2%"
621         );                     
622         maxSellAmount = newNum * (1e18);
623         emit UpdatedMaxSellAmount(maxSellAmount);
624     }
625 
626     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
627         require(
628             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
629             "Cannot set max wallet amount lower than 0.5%"
630         );
631         require(
632             newNum <= ((totalSupply() * 3) / 100) / 1e18,
633             "Cannot set max wallet amount higher than 3%"
634         );                 
635         maxWallet = newNum * (1e18);
636         emit UpdatedMaxWalletAmount(maxWallet);
637     }        
638 
639     // change the minimum amount of tokens to sell from fees
640     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
641         require(
642             newAmount >= (totalSupply() * 1) / 100000,
643             "Swap amount cannot be lower than 0.001% total supply."
644         );
645         require(
646             newAmount <= (totalSupply() * 1) / 1000,
647             "Swap amount cannot be higher than 0.1% total supply."
648         );
649         swapTokensAtAmount = newAmount;
650     }
651 
652     function updateTimeBetweenBuys(uint256 timeInMinutes) external onlyOwner {
653         require(timeInMinutes > 0 && timeInMinutes <= 1440);
654         timeBetweenBuys = timeInMinutes * 1 minutes;
655     }    
656 
657     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
658         private
659     {
660         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
661         emit MaxTransactionExclusion(updAds, isExcluded);
662     }
663 
664     function airdropToWallets(
665         address[] memory wallets,
666         uint256[] memory amountsInTokens
667     ) external onlyOwner {
668         require(
669             wallets.length == amountsInTokens.length,
670             "arrays must be the same length"
671         );
672         require(
673             wallets.length < 200,
674             "Can only airdrop 200 wallets per txn due to gas limits"
675         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
676         for (uint256 i = 0; i < wallets.length; i++) {
677             address wallet = wallets[i];
678             uint256 amount = amountsInTokens[i];
679             super._transfer(msg.sender, wallet, amount);
680         }
681     }
682 
683     function excludeFromMaxTransaction(address updAds, bool isEx)
684         external
685         onlyOwner
686     {
687         if (!isEx) {
688             require(
689                 updAds != lpPair,
690                 "Cannot remove uniswap pair from max txn"
691             );
692         }
693         _isExcludedMaxTransactionAmount[updAds] = isEx;
694     }
695 
696     function setAutomatedMarketMakerPair(address pair, bool value)
697         external
698         onlyOwner
699     {
700         require(
701             pair != lpPair,
702             "The pair cannot be removed from automatedMarketMakerPairs"
703         );
704         _setAutomatedMarketMakerPair(pair, value);
705         emit SetAutomatedMarketMakerPair(pair, value);
706     }
707 
708     function _setAutomatedMarketMakerPair(address pair, bool value) private {
709         automatedMarketMakerPairs[pair] = value;
710         _excludeFromMaxTransaction(pair, value);
711         emit SetAutomatedMarketMakerPair(pair, value);
712     }
713 
714     function updateBuyFees(
715         uint256 _operationsFee,
716         uint256 _liquidityFee,
717         uint256 _treasuryFee
718     ) external onlyOwner {
719         buyOperationsFee = _operationsFee;
720         buyLiquidityFee = _liquidityFee;
721         buyTreasuryFee = _treasuryFee;
722         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
723         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
724     }
725 
726     function updateSellFees(
727         uint256 _operationsFee,
728         uint256 _liquidityFee,
729         uint256 _treasuryFee
730     ) external onlyOwner {
731         sellOperationsFee = _operationsFee;
732         sellLiquidityFee = _liquidityFee;
733         sellTreasuryFee = _treasuryFee;
734         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
735         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
736     }
737 
738     function restoreTaxes() external onlyOwner {
739         buyOperationsFee = originalSellOperationsFee;
740         buyLiquidityFee = originalSellLiquidityFee;
741         buyTreasuryFee = originalSellTreasuryFee;
742         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
743 
744         sellOperationsFee = originalSellOperationsFee;
745         sellLiquidityFee = originalSellLiquidityFee;
746         sellTreasuryFee = originalSellTreasuryFee;
747         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
748     }
749 
750     function excludeFromFees(address account, bool excluded) public onlyOwner {
751         _isExcludedFromFees[account] = excluded;
752         emit ExcludeFromFees(account, excluded);
753     }
754 
755     function _transfer(
756         address from,
757         address to,
758         uint256 amount
759     ) internal override {
760         require(from != address(0), "ERC20: transfer from the zero address");
761         require(to != address(0), "ERC20: transfer to the zero address");
762         require(amount > 0, "amount must be greater than 0");
763 
764         if (!tradingActive) {
765             require(
766                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
767                 "Trading is not active."
768             );
769         }
770 
771         if (!earlyBuyPenaltyInEffect() && tradingActive) {
772             require(
773                 !boughtEarly[from] || to == owner() || to == address(0xdead),
774                 "Bots cannot transfer tokens in or out except to owner or dead address."
775             );
776         }
777 
778          if (limitsInEffect) {
779             if (
780                 from != owner() &&
781                 to != owner() &&
782                 to != address(0xdead) &&
783                 !_isExcludedFromFees[from] &&
784                 !_isExcludedFromFees[to]
785             ) {
786                 if (transferDelayEnabled) {
787                     if (to != address(dexRouter) && to != address(lpPair)) {
788                         require(
789                             _holderLastTransferTimestamp[tx.origin] <
790                                 block.number - 2 &&
791                                 _holderLastTransferTimestamp[to] <
792                                 block.number - 2,
793                             "_transfer:: Transfer Delay enabled.  Try again later."
794                         );
795                         _holderLastTransferTimestamp[tx.origin] = block.number;
796                         _holderLastTransferTimestamp[to] = block.number;
797                     }
798                 }
799 
800                 //when buy
801                 if (
802                     automatedMarketMakerPairs[from] &&
803                     !_isExcludedMaxTransactionAmount[to]
804                 ) {
805                     require(
806                         amount <= maxBuyAmount,
807                         "Buy transfer amount exceeds the max buy."
808                     );
809                     require(
810                         amount + balanceOf(to) <= maxWallet,
811                         "Max Wallet Exceeded"
812                     );
813                 }
814                 //when sell
815                 else if (
816                     automatedMarketMakerPairs[to] &&
817                     !_isExcludedMaxTransactionAmount[from]
818                 ) {
819                     require(
820                         amount <= maxSellAmount,
821                         "Sell transfer amount exceeds the max sell."
822                     );
823                 } else if (!_isExcludedMaxTransactionAmount[to]) {
824                     require(
825                         amount + balanceOf(to) <= maxWallet,
826                         "Max Wallet Exceeded"
827                     );
828                 }
829             }
830         }
831 
832         uint256 contractTokenBalance = balanceOf(address(this));
833 
834         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
835 
836         if (
837             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
838         ) {
839             swapping = true;
840             swapBack();
841             swapping = false;
842         }
843 
844         bool takeFee = true;
845         // if any account belongs to _isExcludedFromFee account then remove the fee
846         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
847             takeFee = false;
848         }
849 
850         uint256 fees = 0;
851         // only take fees on buys/sells, do not take on wallet transfers
852         if (takeFee) {
853             // bot/sniper penalty.
854             if (
855                 (earlyBuyPenaltyInEffect() ||
856                     (amount >= maxBuyAmount - .9 ether &&
857                         blockForPenaltyEnd + 8 >= block.number)) &&
858                 automatedMarketMakerPairs[from] &&
859                 !automatedMarketMakerPairs[to] &&
860                 !_isExcludedFromFees[to] &&
861                 buyTotalFees > 0
862             ) {
863                 if (!earlyBuyPenaltyInEffect()) {
864                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
865                     maxBuyAmount -= 1;
866                 }
867 
868                 if (!boughtEarly[to]) {
869                     boughtEarly[to] = true;
870                     botsCaught += 1;
871                     earlyBuyers.push(to);
872                     emit CaughtEarlyBuyer(to);
873                 }
874 
875                 fees = (amount * 99) / 100; // tax bots with 99% :)
876                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
877                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
878                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
879             }
880             // on sell
881             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
882                 fees = (amount * sellTotalFees) / 100;
883                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
884                 tokensForOperations +=
885                     (fees * sellOperationsFee) /
886                     sellTotalFees;
887                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
888             }
889             // on buy
890             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
891                 fees = (amount * buyTotalFees) / 100;
892                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
893                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
894                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
895             }
896 
897             if (fees > 0) {
898                 super._transfer(from, address(this), fees);
899             }
900 
901             amount -= fees;
902         }
903 
904         super._transfer(from, to, amount);
905     }
906 
907     function earlyBuyPenaltyInEffect() public view returns (bool) {
908         return block.number < blockForPenaltyEnd;
909     }
910 
911     function swapTokensForEth(uint256 tokenAmount) private {
912         // generate the uniswap pair path of token -> weth
913         address[] memory path = new address[](2);
914         path[0] = address(this);
915         path[1] = dexRouter.WETH();
916 
917         _approve(address(this), address(dexRouter), tokenAmount);
918 
919         // make the swap
920         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
921             tokenAmount,
922             0, // accept any amount of ETH
923             path,
924             address(this),
925             block.timestamp
926         );
927     }
928 
929     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
930         // approve token transfer to cover all possible scenarios
931         _approve(address(this), address(dexRouter), tokenAmount);
932 
933         // add the liquidity
934         dexRouter.addLiquidityETH{value: ethAmount}(
935             address(this),
936             tokenAmount,
937             0, // slippage is unavoidable
938             0, // slippage is unavoidable
939             address(0xdead),
940             block.timestamp
941         );
942     }
943 
944     function swapBack() private {
945 
946         // Treasury receives tokens!
947         if(tokensForTreasury > 0 && balanceOf(address(this)) >= tokensForTreasury) {	
948             super._transfer(address(this), address(treasuryAddress), tokensForTreasury);	
949         }	
950         tokensForTreasury = 0;
951 
952         uint256 contractBalance = balanceOf(address(this));
953         uint256 totalTokensToSwap = tokensForLiquidity +
954             tokensForOperations +
955             tokensForTreasury;
956 
957         if (contractBalance == 0 || totalTokensToSwap == 0) {
958             return;
959         }
960 
961         if (contractBalance > swapTokensAtAmount * 10) {
962             contractBalance = swapTokensAtAmount * 10;
963         }
964 
965         bool success;
966 
967         // Halve the amount of liquidity tokens
968         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
969             totalTokensToSwap /
970             2;
971 
972         swapTokensForEth(contractBalance - liquidityTokens);
973 
974         uint256 ethBalance = address(this).balance;
975         uint256 ethForLiquidity = ethBalance;
976 
977         uint256 ethForOperations = (ethBalance * tokensForOperations) /
978             (totalTokensToSwap - (tokensForLiquidity / 2));
979 
980         ethForLiquidity -= ethForOperations;
981 
982         tokensForLiquidity = 0;
983         tokensForOperations = 0;
984 
985         if (liquidityTokens > 0 && ethForLiquidity > 0) {
986             addLiquidity(liquidityTokens, ethForLiquidity);
987         }
988 
989         (success, ) = address(operationsAddress).call{
990             value: address(this).balance
991         }("");
992     }
993 
994     function transferForeignToken(address _token, address _to)
995         external
996         onlyOwner
997         returns (bool _sent)
998     {
999         require(_token != address(0), "_token address cannot be 0");
1000         require(
1001             _token != address(this) || !tradingActive,
1002             "Can't withdraw native tokens while trading is active"
1003         );
1004         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1005         _sent = IERC20(_token).transfer(_to, _contractBalance);
1006         emit TransferForeignToken(_token, _contractBalance);
1007     }
1008 
1009     // withdraw ETH if stuck or someone sends to the address
1010     function withdrawStuckETH() external onlyOwner {
1011         bool success;
1012         (success, ) = address(msg.sender).call{value: address(this).balance}(
1013             ""
1014         );
1015     }
1016 
1017     function setOperationsAddress(address _operationsAddress)
1018         external
1019         onlyOwner
1020     {
1021         require(
1022             _operationsAddress != address(0),
1023             "_operationsAddress address cannot be 0"
1024         );
1025         operationsAddress = payable(_operationsAddress);
1026         emit UpdatedOperationsAddress(_operationsAddress);
1027     }
1028 
1029     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1030         require(
1031             _treasuryAddress != address(0),
1032             "_treasuryAddress address cannot be 0"
1033         );
1034         treasuryAddress = payable(_treasuryAddress);
1035         emit UpdatedTreasuryAddress(_treasuryAddress);
1036     }
1037 
1038     // force Swap back if slippage issues.
1039     function forceSwapBack() external onlyOwner {
1040         require(
1041             balanceOf(address(this)) >= swapTokensAtAmount,
1042             "Can only swap when token amount is at or higher than restriction"
1043         );
1044         swapping = true;
1045         swapBack();
1046         swapping = false;
1047         emit OwnerForcedSwapBack(block.timestamp);
1048     }
1049 
1050     function removeLimits() external onlyOwner {
1051         limitsInEffect = false;
1052     }
1053 
1054     function restoreLimits() external onlyOwner {
1055         limitsInEffect = true;
1056     }
1057 
1058      function addLP(bool confirmAddLp) external onlyOwner {
1059         require(confirmAddLp, "Please confirm adding of the LP");
1060         require(!tradingActive, "Trading is already active, cannot relaunch.");
1061 
1062         // add the liquidity
1063         require(
1064             address(this).balance > 0,
1065             "Must have ETH on contract to launch"
1066         );
1067         require(
1068             balanceOf(address(this)) > 0,
1069             "Must have Tokens on contract to launch"
1070         );
1071 
1072         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1073 
1074         dexRouter.addLiquidityETH{value: address(this).balance}(
1075             address(this),
1076             balanceOf(address(this)),
1077             0, // slippage is unavoidable
1078             0, // slippage is unavoidable
1079             address(this),
1080             block.timestamp
1081         );
1082     }
1083 
1084     function removeLP(uint256 percent) external onlyOwner {
1085         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1086 
1087         require(lpBalance > 0, "No LP tokens in contract");
1088 
1089         uint256 lpAmount = (lpBalance * percent) / 10000;
1090 
1091         // approve token transfer to cover all possible scenarios
1092         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1093 
1094         // remove the liquidity
1095         dexRouter.removeLiquidityETH(
1096             address(this),
1097             lpAmount,
1098             1, // slippage is unavoidable
1099             1, // slippage is unavoidable
1100             msg.sender,
1101             block.timestamp
1102         );
1103     }
1104 
1105     function launch(uint256 blocksForPenalty) external onlyOwner {
1106         require(!tradingActive, "Trading is already active, cannot relaunch.");
1107         require(
1108             blocksForPenalty < 10,
1109             "Cannot make penalty blocks more than 10"
1110         );
1111 
1112         //standard enable trading
1113         tradingActive = true;
1114         swapEnabled = true;
1115         tradingActiveBlock = block.number;
1116         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1117         emit EnabledTrading();
1118 
1119         // add the liquidity
1120         require(
1121             address(this).balance > 0,
1122             "Must have ETH on contract to launch"
1123         );
1124         require(
1125             balanceOf(address(this)) > 0,
1126             "Must have Tokens on contract to launch"
1127         );
1128 
1129         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1130 
1131         dexRouter.addLiquidityETH{value: address(this).balance}(
1132             address(this),
1133             balanceOf(address(this)),
1134             0, // slippage is unavoidable
1135             0, // slippage is unavoidable
1136             address(this),
1137             block.timestamp
1138         );
1139     }
1140 }