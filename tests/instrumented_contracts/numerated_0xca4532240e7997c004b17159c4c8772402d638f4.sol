1 // SPDX-License-Identifier: MIT
2 
3 /*
4     _____            _   _         _____             
5     /__   \_   _ _ __| |_| | ___    \_   \_ __  _   _ 
6     / /\/ | | | '__| __| |/ _ \    / /\/ '_ \| | | |
7     / /  | |_| | |  | |_| |  __/ /\/ /_ | | | | |_| |
8     \/    \__,_|_|   \__|_|\___| \____/ |_| |_|\__,_|
9 
10     TURTLE INU
11     Dev: @seanking52
12 
13 */                                                  
14 
15 pragma solidity 0.8.13;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount)
47         external
48         returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender)
58         external
59         view
60         returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the symbol of the token.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the decimals places of the token.
125      */
126     function decimals() external view returns (uint8);
127 }
128 
129 contract ERC20 is Context, IERC20, IERC20Metadata {
130     mapping(address => uint256) private _balances;
131 
132     mapping(address => mapping(address => uint256)) private _allowances;
133 
134     uint256 private _totalSupply;
135 
136     string private _name;
137     string private _symbol;
138 
139     constructor(string memory name_, string memory symbol_) {
140         _name = name_;
141         _symbol = symbol_;
142     }
143 
144     function name() public view virtual override returns (string memory) {
145         return _name;
146     }
147 
148     function symbol() public view virtual override returns (string memory) {
149         return _symbol;
150     }
151 
152     function decimals() public view virtual override returns (uint8) {
153         return 18;
154     }
155 
156     function totalSupply() public view virtual override returns (uint256) {
157         return _totalSupply;
158     }
159 
160     function balanceOf(address account)
161         public
162         view
163         virtual
164         override
165         returns (uint256)
166     {
167         return _balances[account];
168     }
169 
170     function transfer(address recipient, uint256 amount)
171         public
172         virtual
173         override
174         returns (bool)
175     {
176         _transfer(_msgSender(), recipient, amount);
177         return true;
178     }
179 
180     function allowance(address owner, address spender)
181         public
182         view
183         virtual
184         override
185         returns (uint256)
186     {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount)
191         public
192         virtual
193         override
194         returns (bool)
195     {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) public virtual override returns (bool) {
205         _transfer(sender, recipient, amount);
206 
207         uint256 currentAllowance = _allowances[sender][_msgSender()];
208         require(
209             currentAllowance >= amount,
210             "ERC20: transfer amount exceeds allowance"
211         );
212         unchecked {
213             _approve(sender, _msgSender(), currentAllowance - amount);
214         }
215 
216         return true;
217     }
218 
219     function increaseAllowance(address spender, uint256 addedValue)
220         public
221         virtual
222         returns (bool)
223     {
224         _approve(
225             _msgSender(),
226             spender,
227             _allowances[_msgSender()][spender] + addedValue
228         );
229         return true;
230     }
231 
232     function decreaseAllowance(address spender, uint256 subtractedValue)
233         public
234         virtual
235         returns (bool)
236     {
237         uint256 currentAllowance = _allowances[_msgSender()][spender];
238         require(
239             currentAllowance >= subtractedValue,
240             "ERC20: decreased allowance below zero"
241         );
242         unchecked {
243             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
244         }
245 
246         return true;
247     }
248 
249     function _transfer(
250         address sender,
251         address recipient,
252         uint256 amount
253     ) internal virtual {
254         require(sender != address(0), "ERC20: transfer from the zero address");
255         require(recipient != address(0), "ERC20: transfer to the zero address");
256 
257         uint256 senderBalance = _balances[sender];
258         require(
259             senderBalance >= amount,
260             "ERC20: transfer amount exceeds balance"
261         );
262         unchecked {
263             _balances[sender] = senderBalance - amount;
264         }
265         _balances[recipient] += amount;
266 
267         emit Transfer(sender, recipient, amount);
268     }
269 
270     function _createInitialSupply(address account, uint256 amount)
271         internal
272         virtual
273     {
274         require(account != address(0), "ERC20: mint to the zero address");
275 
276         _totalSupply += amount;
277         _balances[account] += amount;
278         emit Transfer(address(0), account, amount);
279     }
280 
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288 
289         _allowances[owner][spender] = amount;
290         emit Approval(owner, spender, amount);
291     }
292 }
293 
294 contract Ownable is Context {
295     address private _owner;
296 
297     event OwnershipTransferred(
298         address indexed previousOwner,
299         address indexed newOwner
300     );
301 
302     constructor() {
303         address msgSender = _msgSender();
304         _owner = msgSender;
305         emit OwnershipTransferred(address(0), msgSender);
306     }
307 
308     function owner() public view returns (address) {
309         return _owner;
310     }
311 
312     modifier onlyOwner() {
313         require(_owner == _msgSender(), "Ownable: caller is not the owner");
314         _;
315     }
316 
317     function renounceOwnership() external virtual onlyOwner {
318         emit OwnershipTransferred(_owner, address(0));
319         _owner = address(0);
320     }
321 
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(
324             newOwner != address(0),
325             "Ownable: new owner is the zero address"
326         );
327         emit OwnershipTransferred(_owner, newOwner);
328         _owner = newOwner;
329     }
330 }
331 
332 interface ILpPair {
333     function sync() external;
334 }
335 
336 interface IDexRouter {
337     function factory() external pure returns (address);
338 
339     function WETH() external pure returns (address);
340 
341     function swapExactTokensForETHSupportingFeeOnTransferTokens(
342         uint256 amountIn,
343         uint256 amountOutMin,
344         address[] calldata path,
345         address to,
346         uint256 deadline
347     ) external;
348 
349     function swapExactETHForTokensSupportingFeeOnTransferTokens(
350         uint256 amountOutMin,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external payable;
355 
356     function addLiquidityETH(
357         address token,
358         uint256 amountTokenDesired,
359         uint256 amountTokenMin,
360         uint256 amountETHMin,
361         address to,
362         uint256 deadline
363     )
364         external
365         payable
366         returns (
367             uint256 amountToken,
368             uint256 amountETH,
369             uint256 liquidity
370         );
371 
372     function getAmountsOut(uint256 amountIn, address[] calldata path)
373         external
374         view
375         returns (uint256[] memory amounts);
376 }
377 
378 interface IDexFactory {
379     function createPair(address tokenA, address tokenB)
380         external
381         returns (address pair);
382 }
383 
384 contract TurtleInu is ERC20, Ownable {
385     uint256 public maxBuyAmount;
386     uint256 public maxSellAmount;
387     uint256 public maxWallet;    
388 
389     IDexRouter public dexRouter;
390     address public lpPair;
391 
392     bool private swapping;
393     uint256 public swapTokensAtAmount;
394 
395     address public operationsAddress;
396     address public treasuryAddress;
397 
398     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
399     uint256 public blockForPenaltyEnd;
400     mapping(address => bool) public boughtEarly;
401     address[] public earlyBuyers;
402     uint256 public botsCaught;
403 
404     bool public limitsInEffect = true;
405     bool public tradingActive = false;
406     bool public swapEnabled = false;
407 
408     // Investor sell limit variables
409     mapping(address => uint256) public nextInvestorSellDate;
410     uint256 public timeBetweenBuys = 360 minutes; // 6 hours
411     uint256 public privateSaleCooldown = 1 minutes; // 1 minutes
412 
413     // Anti-bot and anti-whale mappings and variables
414     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
415     bool public transferDelayEnabled = true;
416 
417     uint256 public buyTotalFees;
418     uint256 public buyOperationsFee;
419     uint256 public buyLiquidityFee;
420     uint256 public buyTreasuryFee;
421 
422     uint256 private originalSellOperationsFee;
423     uint256 private originalSellLiquidityFee;
424     uint256 private originalSellTreasuryFee;
425 
426     uint256 public sellTotalFees;
427     uint256 public sellOperationsFee;
428     uint256 public sellLiquidityFee;
429     uint256 public sellTreasuryFee;
430 
431     uint256 public tokensForOperations;
432     uint256 public tokensForLiquidity;
433     uint256 public tokensForTreasury;
434 
435     /******************/
436 
437     // exlcude from fees and max transaction amount
438     mapping(address => bool) private _isExcludedFromFees;
439     mapping(address => bool) public _isExcludedMaxTransactionAmount;
440 
441     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
442     // could be subject to a maximum transfer amount
443     mapping(address => bool) public automatedMarketMakerPairs;
444 
445     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
446 
447     event EnabledTrading();
448 
449     event ExcludeFromFees(address indexed account, bool isExcluded);
450 
451     event UpdatedMaxBuyAmount(uint256 newAmount);
452 
453     event UpdatedMaxSellAmount(uint256 newAmount);
454 
455     event UpdatedMaxWalletAmount(uint256 newAmount);
456 
457     event UpdatedOperationsAddress(address indexed newWallet);
458 
459     event UpdatedTreasuryAddress(address indexed newWallet);
460 
461     event MaxTransactionExclusion(address _address, bool excluded);
462 
463     event OwnerForcedSwapBack(uint256 timestamp);
464 
465     event CaughtEarlyBuyer(address sniper);
466 
467     event SwapAndLiquify(
468         uint256 tokensSwapped,
469         uint256 ethReceived,
470         uint256 tokensIntoLiquidity
471     );
472 
473     event TransferForeignToken(address token, uint256 amount);
474 
475     event UpdatedPrivateMaxSell(uint256 amount);
476 
477     constructor() payable ERC20("Turtle Inu", "TINU") {
478         address newOwner = msg.sender; // Deployer is the owner
479 
480         // initialize router
481         IDexRouter _dexRouter = IDexRouter(
482             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
483         );
484         dexRouter = _dexRouter;
485 
486         lpPair = IDexFactory(dexRouter.factory()).createPair(
487             address(this),
488             dexRouter.WETH()
489         );
490         _excludeFromMaxTransaction(address(lpPair), true);
491         _setAutomatedMarketMakerPair(address(lpPair), true);        
492 
493         uint256 totalSupply = 10 * 1e9 * 1e18; // 10 billion
494 
495         // Reference: 1 ETH = 0.23% at launch
496         maxBuyAmount = (totalSupply * 15) / 10000; // 0.15%
497         maxSellAmount = (totalSupply * 5) / 10000; // 0.05%
498         maxWallet = (totalSupply * 25) / 10000; // 0.25%
499         swapTokensAtAmount = (totalSupply * 2) / 10000; // 0.02 %
500 
501         buyOperationsFee = 4;
502         buyLiquidityFee = 0;
503         buyTreasuryFee = 2;
504         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
505 
506         originalSellOperationsFee = 9;
507         originalSellLiquidityFee = 3;
508         originalSellTreasuryFee = 0;
509 
510         sellOperationsFee = 14;
511         sellLiquidityFee = 4;
512         sellTreasuryFee = 0;
513         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
514 
515         operationsAddress = address(0x2c3d4293F04EAFa141eecA4C066d11bc575b03cc);
516         treasuryAddress = address(0x0a0BEDF9605697332670bE2B6B18C2efEE69e88a);
517 
518         _excludeFromMaxTransaction(newOwner, true);
519         _excludeFromMaxTransaction(address(this), true);
520         _excludeFromMaxTransaction(address(0xdead), true);
521         _excludeFromMaxTransaction(address(operationsAddress), true);
522         _excludeFromMaxTransaction(address(treasuryAddress), true);
523         _excludeFromMaxTransaction(0xb820733b574Df5173ACF9688facD32BBb4dc2D43, true); // Team tokens wallet
524         _excludeFromMaxTransaction(0xf2eaFea68dC662De7e3Ce237c59a6d2515E0322e, true); // Exchange tokens wallet
525         _excludeFromMaxTransaction(0x87E64a130Fffe1C784cbe9308B3AD220Af07cc5E, true); // Shill competitions tokens wallet
526 
527         excludeFromFees(newOwner, true);
528         excludeFromFees(address(this), true);
529         excludeFromFees(address(0xdead), true);
530         excludeFromFees(address(operationsAddress), true);
531         excludeFromFees(address(treasuryAddress), true);
532         excludeFromFees(0xb820733b574Df5173ACF9688facD32BBb4dc2D43, true); // Team tokens wallet
533         excludeFromFees(0xf2eaFea68dC662De7e3Ce237c59a6d2515E0322e, true); // Exchange tokens wallet 
534         excludeFromFees(0x87E64a130Fffe1C784cbe9308B3AD220Af07cc5E, true); // Shill competitions tokens wallet
535 
536          _createInitialSupply(newOwner, (totalSupply * 36) / 100); // 36% Tokens available for aidrop to old holders
537          _createInitialSupply(address(0xdead), (totalSupply * 591) / 1000); // 59.1% Initial Burn
538          _createInitialSupply(address(this), (totalSupply * 49) / 1000); // 4.9% Tokens for liquidity
539 
540         transferOwnership(newOwner);
541     }
542 
543     receive() external payable {}
544 
545     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
546         require(!tradingActive, "Cannot reenable trading");
547         require(
548             blocksForPenalty <= 10,
549             "Cannot make penalty blocks more than 10"
550         );
551         tradingActive = true;
552         swapEnabled = true;
553         tradingActiveBlock = block.number;
554         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
555         emit EnabledTrading();     
556     }
557 
558     function getEarlyBuyers() external view returns (address[] memory) {
559         return earlyBuyers;
560     }
561 
562     function removeBoughtEarly(address wallet) external onlyOwner {
563         require(boughtEarly[wallet], "Wallet is already not flagged.");
564         boughtEarly[wallet] = false;
565     }
566 
567     function emergencyUpdateRouter(address router) external onlyOwner {
568         require(!tradingActive, "Cannot update after trading is functional");
569         dexRouter = IDexRouter(router);
570     }
571 
572     // disable Transfer delay - cannot be reenabled
573     function disableTransferDelay() external onlyOwner {
574         transferDelayEnabled = false;
575     }
576 
577   function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
578         require(
579             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
580             "Cannot set max buy amount lower than 0.01%"
581         );
582         require(
583             newNum <= ((totalSupply() * 2) / 100) / 1e18,
584             "Cannot set max buy amount higher than 2%"
585         );        
586         maxBuyAmount = newNum * (1e18);
587         emit UpdatedMaxBuyAmount(maxBuyAmount);
588     }
589 
590     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
591         require(
592             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
593             "Cannot set max sell amount lower than 0.01%"
594         );
595         require(
596             newNum <= ((totalSupply() * 2) / 100) / 1e18,
597             "Cannot set max sell amount higher than 2%"
598         );                     
599         maxSellAmount = newNum * (1e18);
600         emit UpdatedMaxSellAmount(maxSellAmount);
601     }
602 
603     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
604         require(
605             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
606             "Cannot set max wallet amount lower than 0.5%"
607         );
608         require(
609             newNum <= ((totalSupply() * 3) / 100) / 1e18,
610             "Cannot set max wallet amount higher than 3%"
611         );                 
612         maxWallet = newNum * (1e18);
613         emit UpdatedMaxWalletAmount(maxWallet);
614     }        
615 
616     // change the minimum amount of tokens to sell from fees
617     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
618         require(
619             newAmount >= (totalSupply() * 1) / 100000,
620             "Swap amount cannot be lower than 0.001% total supply."
621         );
622         require(
623             newAmount <= (totalSupply() * 1) / 1000,
624             "Swap amount cannot be higher than 0.1% total supply."
625         );
626         swapTokensAtAmount = newAmount;
627     }
628 
629     function updateTimeBetweenBuys(uint256 timeInMinutes) external onlyOwner {
630         require(timeInMinutes > 0 && timeInMinutes <= 1440);
631         timeBetweenBuys = timeInMinutes * 1 minutes;
632     }    
633 
634     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
635         private
636     {
637         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
638         emit MaxTransactionExclusion(updAds, isExcluded);
639     }
640 
641     function airdropToWallets(
642         address[] memory wallets,
643         uint256[] memory amountsInTokens
644     ) external onlyOwner {
645         require(
646             wallets.length == amountsInTokens.length,
647             "arrays must be the same length"
648         );
649         require(
650             wallets.length < 200,
651             "Can only airdrop 200 wallets per txn due to gas limits"
652         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
653         for (uint256 i = 0; i < wallets.length; i++) {
654             address wallet = wallets[i];
655             uint256 amount = amountsInTokens[i];
656             super._transfer(msg.sender, wallet, amount);
657         }
658     }
659 
660     function excludeFromMaxTransaction(address updAds, bool isEx)
661         external
662         onlyOwner
663     {
664         if (!isEx) {
665             require(
666                 updAds != lpPair,
667                 "Cannot remove uniswap pair from max txn"
668             );
669         }
670         _isExcludedMaxTransactionAmount[updAds] = isEx;
671     }
672 
673     function setAutomatedMarketMakerPair(address pair, bool value)
674         external
675         onlyOwner
676     {
677         require(
678             pair != lpPair,
679             "The pair cannot be removed from automatedMarketMakerPairs"
680         );
681         _setAutomatedMarketMakerPair(pair, value);
682         emit SetAutomatedMarketMakerPair(pair, value);
683     }
684 
685     function _setAutomatedMarketMakerPair(address pair, bool value) private {
686         automatedMarketMakerPairs[pair] = value;
687         _excludeFromMaxTransaction(pair, value);
688         emit SetAutomatedMarketMakerPair(pair, value);
689     }
690 
691     function updateBuyFees(
692         uint256 _operationsFee,
693         uint256 _liquidityFee,
694         uint256 _treasuryFee
695     ) external onlyOwner {
696         buyOperationsFee = _operationsFee;
697         buyLiquidityFee = _liquidityFee;
698         buyTreasuryFee = _treasuryFee;
699         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
700         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
701     }
702 
703     function updateSellFees(
704         uint256 _operationsFee,
705         uint256 _liquidityFee,
706         uint256 _treasuryFee
707     ) external onlyOwner {
708         sellOperationsFee = _operationsFee;
709         sellLiquidityFee = _liquidityFee;
710         sellTreasuryFee = _treasuryFee;
711         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
712         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
713     }
714 
715     function restoreTaxes() external onlyOwner {
716         sellOperationsFee = originalSellOperationsFee;
717         sellLiquidityFee = originalSellLiquidityFee;
718         sellTreasuryFee = originalSellTreasuryFee;
719         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
720     }
721 
722     function excludeFromFees(address account, bool excluded) public onlyOwner {
723         _isExcludedFromFees[account] = excluded;
724         emit ExcludeFromFees(account, excluded);
725     }
726 
727     function _transfer(
728         address from,
729         address to,
730         uint256 amount
731     ) internal override {
732         require(from != address(0), "ERC20: transfer from the zero address");
733         require(to != address(0), "ERC20: transfer to the zero address");
734         require(amount > 0, "amount must be greater than 0");
735 
736         if (!tradingActive) {
737             require(
738                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
739                 "Trading is not active."
740             );
741         }
742 
743         if (!earlyBuyPenaltyInEffect() && tradingActive) {
744             require(
745                 !boughtEarly[from] || to == owner() || to == address(0xdead),
746                 "Bots cannot transfer tokens in or out except to owner or dead address."
747             );
748         }
749 
750         if (limitsInEffect) {
751             if (
752                 from != owner() &&
753                 to != owner() &&
754                 to != address(0xdead) &&
755                 !_isExcludedFromFees[from] &&
756                 !_isExcludedFromFees[to]
757             ) {
758                 if (transferDelayEnabled) {
759                     if (to != address(dexRouter) && to != address(lpPair)) {
760                         require(
761                             _holderLastTransferTimestamp[tx.origin] <
762                                 block.number - 2 &&
763                                 _holderLastTransferTimestamp[to] <
764                                 block.number - 2,
765                             "_transfer:: Transfer Delay enabled.  Try again later."
766                         );
767                         _holderLastTransferTimestamp[tx.origin] = block.number;
768                         _holderLastTransferTimestamp[to] = block.number;
769                     }
770                 }
771 
772                 //when buy
773                 if (
774                     automatedMarketMakerPairs[from] &&
775                     !_isExcludedMaxTransactionAmount[to]
776                 ) {
777                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxBuyAmount.");
778                     require(amount + balanceOf(to) <= maxWallet, "Max Wallet Exceeded");
779                 }
780                 //when sell
781                 else if (
782                     automatedMarketMakerPairs[to] &&
783                     !_isExcludedMaxTransactionAmount[from]
784                 ) {
785                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxSellAmount.");
786                     require(nextInvestorSellDate[from] <= block.timestamp, "Cannot sell yet");
787                     nextInvestorSellDate[from] = block.timestamp + timeBetweenBuys;
788                 } 
789                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedFromFees[to]) {
790                     revert("Investors cannot transfer and must sell only or transfer to a whitelisted address.");
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
838                 fees = (amount * 99) / 100; // tax bots with 99% :)
839                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
840                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
841                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
842             }
843             // on sell
844             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
845                 fees = (amount * sellTotalFees) / 100;
846                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
847                 tokensForOperations +=
848                     (fees * sellOperationsFee) /
849                     sellTotalFees;
850                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
851             }
852             // on buy
853             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
854                 fees = (amount * buyTotalFees) / 100;
855                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
856                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
857                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
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
908 
909         // Treasury receives tokens!
910         if(tokensForTreasury > 0 && balanceOf(address(this)) >= tokensForTreasury) {	
911             super._transfer(address(this), address(treasuryAddress), tokensForTreasury);	
912         }	
913         tokensForTreasury = 0;
914 
915         uint256 contractBalance = balanceOf(address(this));
916         uint256 totalTokensToSwap = tokensForLiquidity +
917             tokensForOperations +
918             tokensForTreasury;
919 
920         if (contractBalance == 0 || totalTokensToSwap == 0) {
921             return;
922         }
923 
924         if (contractBalance > swapTokensAtAmount * 10) {
925             contractBalance = swapTokensAtAmount * 10;
926         }
927 
928         bool success;
929 
930         // Halve the amount of liquidity tokens
931         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
932             totalTokensToSwap /
933             2;
934 
935         swapTokensForEth(contractBalance - liquidityTokens);
936 
937         uint256 ethBalance = address(this).balance;
938         uint256 ethForLiquidity = ethBalance;
939 
940         uint256 ethForOperations = (ethBalance * tokensForOperations) /
941             (totalTokensToSwap - (tokensForLiquidity / 2));
942 
943         ethForLiquidity -= ethForOperations;
944 
945         tokensForLiquidity = 0;
946         tokensForOperations = 0;
947 
948         if (liquidityTokens > 0 && ethForLiquidity > 0) {
949             addLiquidity(liquidityTokens, ethForLiquidity);
950         }
951 
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
995             "_treasuryAddress address cannot be 0"
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
1013     function removeLimits() external onlyOwner {
1014         limitsInEffect = false;
1015     }
1016 
1017     function restoreLimits() external onlyOwner {
1018         limitsInEffect = true;
1019     }
1020 
1021     function launch(
1022         address[] memory wallets,
1023         uint256[] memory amountsInTokens,
1024         uint256 blocksForPenalty
1025     ) external onlyOwner {
1026         require(!tradingActive, "Trading is already active, cannot relaunch.");
1027         require(
1028             blocksForPenalty < 10,
1029             "Cannot make penalty blocks more than 10"
1030         );
1031 
1032         require(
1033             wallets.length == amountsInTokens.length,
1034             "arrays must be the same length"
1035         );
1036         require(
1037             wallets.length < 200,
1038             "Can only airdrop 200 wallets per txn due to gas limits"
1039         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1040         for (uint256 i = 0; i < wallets.length; i++) {
1041             address wallet = wallets[i];
1042             nextInvestorSellDate[wallet] = block.timestamp + privateSaleCooldown; // No sales in the first 3 hours after launch
1043             uint256 amount = amountsInTokens[i];
1044             super._transfer(msg.sender, wallet, amount);
1045         }
1046 
1047         //standard enable trading
1048         tradingActive = true;
1049         swapEnabled = true;
1050         tradingActiveBlock = block.number;
1051         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1052         emit EnabledTrading();
1053 
1054         // add the liquidity
1055         require(
1056             address(this).balance > 0,
1057             "Must have ETH on contract to launch"
1058         );
1059 
1060         require(
1061             balanceOf(address(this)) > 0,
1062             "Must have Tokens on contract to launch"
1063         );
1064 
1065         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1066         dexRouter.addLiquidityETH{value: address(this).balance}(
1067             address(this),
1068             balanceOf(address(this)),
1069             0, // slippage is unavoidable
1070             0, // slippage is unavoidable
1071             address(msg.sender),
1072             block.timestamp
1073         );
1074     }
1075 
1076     function launchWithoutAirdrop(uint256 blocksForPenalty) external onlyOwner {
1077         require(!tradingActive, "Trading is already active, cannot relaunch.");
1078         require(blocksForPenalty < 10, "Cannot make penalty blocks more than 10");
1079 
1080         //standard enable trading
1081         tradingActive = true;
1082         swapEnabled = true;
1083         tradingActiveBlock = block.number;
1084         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1085         emit EnabledTrading();
1086    
1087         // add the liquidity
1088         require(address(this).balance > 0, "Must have ETH on contract to launch");
1089         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
1090 
1091         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1092 
1093         dexRouter.addLiquidityETH{value: address(this).balance}(
1094             address(this),
1095             balanceOf(address(this)),
1096             0, // slippage is unavoidable
1097             0, // slippage is unavoidable
1098             msg.sender,
1099             block.timestamp
1100         );
1101     }    
1102 }