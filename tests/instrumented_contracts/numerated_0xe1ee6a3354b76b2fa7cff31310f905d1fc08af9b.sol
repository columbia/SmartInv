1 /*           
2     .              .--.      .  
3    / \             |   )    _|_ 
4   /___\  .,-.  .-. |--:  .-. |  
5  /     \ |   )(.-' |   )(   )|  
6 '       `|`-'  `--''--'  `-' `-'
7          |                      
8          '                
9 
10 | www.apebotai.com | t.me/ApeBOTENTRY |
11 
12 **/
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.17;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount)
48         external
49         returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender)
59         external
60         view
61         returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 }
112 
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 contract ERC20 is Context, IERC20, IERC20Metadata {
131     mapping(address => uint256) private _balances;
132 
133     mapping(address => mapping(address => uint256)) private _allowances;
134 
135     uint256 private _totalSupply;
136 
137     string private _name;
138     string private _symbol;
139 
140     constructor(string memory name_, string memory symbol_) {
141         _name = name_;
142         _symbol = symbol_;
143     }
144 
145     function name() public view virtual override returns (string memory) {
146         return _name;
147     }
148 
149     function symbol() public view virtual override returns (string memory) {
150         return _symbol;
151     }
152 
153     function decimals() public view virtual override returns (uint8) {
154         return 18;
155     }
156 
157     function totalSupply() public view virtual override returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address account)
162         public
163         view
164         virtual
165         override
166         returns (uint256)
167     {
168         return _balances[account];
169     }
170 
171     function transfer(address recipient, uint256 amount)
172         public
173         virtual
174         override
175         returns (bool)
176     {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender)
182         public
183         view
184         virtual
185         override
186         returns (uint256)
187     {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount)
192         public
193         virtual
194         override
195         returns (bool)
196     {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) public virtual override returns (bool) {
206         _transfer(sender, recipient, amount);
207 
208         uint256 currentAllowance = _allowances[sender][_msgSender()];
209         require(
210             currentAllowance >= amount,
211             "ERC20: transfer amount exceeds allowance"
212         );
213         unchecked {
214             _approve(sender, _msgSender(), currentAllowance - amount);
215         }
216 
217         return true;
218     }
219 
220     function increaseAllowance(address spender, uint256 addedValue)
221         public
222         virtual
223         returns (bool)
224     {
225         _approve(
226             _msgSender(),
227             spender,
228             _allowances[_msgSender()][spender] + addedValue
229         );
230         return true;
231     }
232 
233     function decreaseAllowance(address spender, uint256 subtractedValue)
234         public
235         virtual
236         returns (bool)
237     {
238         uint256 currentAllowance = _allowances[_msgSender()][spender];
239         require(
240             currentAllowance >= subtractedValue,
241             "ERC20: decreased allowance below zero"
242         );
243         unchecked {
244             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
245         }
246 
247         return true;
248     }
249 
250     function _transfer(
251         address sender,
252         address recipient,
253         uint256 amount
254     ) internal virtual {
255         require(sender != address(0), "ERC20: transfer from the zero address");
256         require(recipient != address(0), "ERC20: transfer to the zero address");
257 
258         uint256 senderBalance = _balances[sender];
259         require(
260             senderBalance >= amount,
261             "ERC20: transfer amount exceeds balance"
262         );
263         unchecked {
264             _balances[sender] = senderBalance - amount;
265         }
266         _balances[recipient] += amount;
267 
268         emit Transfer(sender, recipient, amount);
269     }
270 
271     function _createInitialSupply(address account, uint256 amount)
272         internal
273         virtual
274     {
275         require(account != address(0), "ERC20: mint to the zero address");
276 
277         _totalSupply += amount;
278         _balances[account] += amount;
279         emit Transfer(address(0), account, amount);
280     }
281 
282     function _approve(
283         address owner,
284         address spender,
285         uint256 amount
286     ) internal virtual {
287         require(owner != address(0), "ERC20: approve from the zero address");
288         require(spender != address(0), "ERC20: approve to the zero address");
289 
290         _allowances[owner][spender] = amount;
291         emit Approval(owner, spender, amount);
292     }
293 }
294 
295 contract Ownable is Context {
296     address private _owner;
297 
298     event OwnershipTransferred(
299         address indexed previousOwner,
300         address indexed newOwner
301     );
302 
303     constructor() {
304         address msgSender = _msgSender();
305         _owner = msgSender;
306         emit OwnershipTransferred(address(0), msgSender);
307     }
308 
309     function owner() public view returns (address) {
310         return _owner;
311     }
312 
313     modifier onlyOwner() {
314         require(_owner == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     function renounceOwnership(bool confirmRenounce)
319         external
320         virtual
321         onlyOwner
322     {
323         require(confirmRenounce, "Please confirm renounce!");
324         emit OwnershipTransferred(_owner, address(0));
325         _owner = address(0);
326     }
327 
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(
330             newOwner != address(0),
331             "Ownable: new owner is the zero address"
332         );
333         emit OwnershipTransferred(_owner, newOwner);
334         _owner = newOwner;
335     }
336 }
337 
338 interface ILpPair {
339     function sync() external;
340 }
341 
342 interface IDexRouter {
343     function factory() external pure returns (address);
344 
345     function WETH() external pure returns (address);
346 
347     function swapExactTokensForETHSupportingFeeOnTransferTokens(
348         uint256 amountIn,
349         uint256 amountOutMin,
350         address[] calldata path,
351         address to,
352         uint256 deadline
353     ) external;
354 
355     function swapExactETHForTokensSupportingFeeOnTransferTokens(
356         uint256 amountOutMin,
357         address[] calldata path,
358         address to,
359         uint256 deadline
360     ) external payable;
361 
362     function addLiquidityETH(
363         address token,
364         uint256 amountTokenDesired,
365         uint256 amountTokenMin,
366         uint256 amountETHMin,
367         address to,
368         uint256 deadline
369     )
370         external
371         payable
372         returns (
373             uint256 amountToken,
374             uint256 amountETH,
375             uint256 liquidity
376         );
377 
378     function getAmountsOut(uint256 amountIn, address[] calldata path)
379         external
380         view
381         returns (uint256[] memory amounts);
382 
383     function removeLiquidityETH(
384         address token,
385         uint256 liquidity,
386         uint256 amountTokenMin,
387         uint256 amountETHMin,
388         address to,
389         uint256 deadline
390     ) external returns (uint256 amountToken, uint256 amountETH);
391 }
392 
393 interface IDexFactory {
394     function createPair(address tokenA, address tokenB)
395         external
396         returns (address pair);
397 }
398 
399 contract ApeBot is ERC20, Ownable {
400     uint256 public maxBuyAmount;
401     uint256 public maxSellAmount;
402     uint256 public maxWallet;
403 
404     IDexRouter public dexRouter;
405     address public lpPair;
406 
407     bool private swapping;
408     uint256 public swapTokensAtAmount;
409 
410     address public operationsAddress;
411     address public treasuryAddress;
412 
413     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
414     uint256 public blockForPenaltyEnd;
415     mapping(address => bool) public boughtEarly;
416     address[] public earlyBuyers;
417     uint256 public botsCaught;
418 
419     bool public limitsInEffect = true;
420     bool public tradingActive = false;
421     bool public swapEnabled = false;
422 
423     // Anti-bot and anti-whale mappings and variables
424     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
425     bool public transferDelayEnabled = true;
426 
427     uint256 public buyTotalFees;
428     uint256 public buyOperationsFee;
429     uint256 public buyLiquidityFee;
430     uint256 public buyTreasuryFee;
431 
432     uint256 private originalSellOperationsFee;
433     uint256 private originalSellLiquidityFee;
434     uint256 private originalSellTreasuryFee;
435 
436     uint256 public sellTotalFees;
437     uint256 public sellOperationsFee;
438     uint256 public sellLiquidityFee;
439     uint256 public sellTreasuryFee;
440 
441     uint256 public tokensForOperations;
442     uint256 public tokensForLiquidity;
443     uint256 public tokensForTreasury;
444     bool public sellingEnabled = true;
445     bool public highTaxModeEnabled = true;
446     bool public markBotsEnabled = true;
447 
448     /******************/
449 
450     // exlcude from fees and max transaction amount
451     mapping(address => bool) private _isExcludedFromFees;
452     mapping(address => bool) public _isExcludedMaxTransactionAmount;
453 
454     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
455     // could be subject to a maximum transfer amount
456     mapping(address => bool) public automatedMarketMakerPairs;
457 
458     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
459 
460     event EnabledTrading();
461 
462     event ExcludeFromFees(address indexed account, bool isExcluded);
463 
464     event UpdatedMaxBuyAmount(uint256 newAmount);
465 
466     event UpdatedMaxSellAmount(uint256 newAmount);
467 
468     event UpdatedMaxWalletAmount(uint256 newAmount);
469 
470     event UpdatedOperationsAddress(address indexed newWallet);
471 
472     event UpdatedTreasuryAddress(address indexed newWallet);
473 
474     event MaxTransactionExclusion(address _address, bool excluded);
475 
476     event OwnerForcedSwapBack(uint256 timestamp);
477 
478     event CaughtEarlyBuyer(address sniper);
479 
480     event SwapAndLiquify(
481         uint256 tokensSwapped,
482         uint256 ethReceived,
483         uint256 tokensIntoLiquidity
484     );
485 
486     event TransferForeignToken(address token, uint256 amount);
487 
488     event UpdatedPrivateMaxSell(uint256 amount);
489 
490     event EnabledSelling();
491 
492     event DisabledHighTaxModeForever();
493 
494     constructor() payable ERC20("ApeBOT", "APEBOT") {
495         address newOwner = msg.sender; // can leave alone if owner is deployer.
496 
497         address _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
498        
499         // initialize router
500         dexRouter = IDexRouter(_dexRouter);
501 
502         // create pair
503         lpPair = IDexFactory(dexRouter.factory()).createPair(
504             address(this),
505             dexRouter.WETH()
506         );
507         _excludeFromMaxTransaction(address(lpPair), true);
508         _setAutomatedMarketMakerPair(address(lpPair), true);
509 
510         uint256 totalSupply = 1 * 1e9 * 1e18; // 1 billion
511 
512         maxBuyAmount = (totalSupply * 1) / 100; // 1%
513         maxSellAmount = (totalSupply * 1) / 100; // 1%
514         maxWallet = (totalSupply * 1) / 100; // 1%
515         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
516 
517         buyOperationsFee = 0;
518         buyLiquidityFee = 0;
519         buyTreasuryFee = 25;
520         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
521 
522         originalSellOperationsFee = 3;
523         originalSellLiquidityFee = 0;
524         originalSellTreasuryFee = 3;
525 
526         sellOperationsFee = 0;
527         sellLiquidityFee = 0;
528         sellTreasuryFee = 45;
529         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
530 
531         operationsAddress = address(msg.sender);
532         treasuryAddress = address(0x3d455c41A1d9EfAEec144402C44463c0FfED9368);
533 
534         _excludeFromMaxTransaction(newOwner, true);
535         _excludeFromMaxTransaction(address(this), true);
536         _excludeFromMaxTransaction(address(0xdead), true);
537         _excludeFromMaxTransaction(address(operationsAddress), true);
538         _excludeFromMaxTransaction(address(treasuryAddress), true);
539         _excludeFromMaxTransaction(address(dexRouter), true);
540         _excludeFromMaxTransaction(
541             address(0x3d455c41A1d9EfAEec144402C44463c0FfED9368),
542             true
543         ); // Team
544 
545         excludeFromFees(newOwner, true);
546         excludeFromFees(address(this), true);
547         excludeFromFees(address(0xdead), true);
548         excludeFromFees(address(operationsAddress), true);
549         excludeFromFees(address(treasuryAddress), true);
550         excludeFromFees(address(dexRouter), true);
551         excludeFromFees(
552             address(0x3d455c41A1d9EfAEec144402C44463c0FfED9368),
553             true
554         ); // Team
555 
556         _createInitialSupply(newOwner, totalSupply); // Tokens for liquidity
557 
558         transferOwnership(newOwner);
559     }
560 
561     receive() external payable {}
562 
563     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
564         require(!tradingActive, "Cannot reenable trading");
565         require(
566             blocksForPenalty <= 10,
567             "Cannot make penalty blocks more than 10"
568         );
569         tradingActive = true;
570         swapEnabled = true;
571         tradingActiveBlock = block.number;
572         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
573         emit EnabledTrading();
574     }
575 
576     function getEarlyBuyers() external view returns (address[] memory) {
577         return earlyBuyers;
578     }
579 
580     function markBoughtEarly(address wallet) external onlyOwner {
581         require(
582             markBotsEnabled,
583             "Mark bot functionality has been disabled forever!"
584         );
585         require(!boughtEarly[wallet], "Wallet is already flagged.");
586         boughtEarly[wallet] = true;
587     }
588 
589     function removeBoughtEarly(address wallet) external onlyOwner {
590         require(boughtEarly[wallet], "Wallet is already not flagged.");
591         boughtEarly[wallet] = false;
592     }
593 
594     function emergencyUpdateRouter(address router) external onlyOwner {
595         require(!tradingActive, "Cannot update after trading is functional");
596         dexRouter = IDexRouter(router);
597     }
598 
599     // disable Transfer delay - cannot be reenabled
600     function disableTransferDelay() external onlyOwner {
601         transferDelayEnabled = false;
602     }
603 
604     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
605         require(
606             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
607             "Cannot set max buy amount lower than 0.5%"
608         );
609         require(
610             newNum <= ((totalSupply() * 10) / 100) / 1e18,
611             "Cannot set buy buy amount higher than 10%"
612         );
613         maxBuyAmount = newNum * (10**18);
614         emit UpdatedMaxBuyAmount(maxBuyAmount);
615     }
616 
617     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
618         require(
619             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
620             "Cannot set max sell amount lower than 0.5%"
621         );
622         require(
623             newNum <= ((totalSupply() * 2) / 100) / 1e18,
624             "Cannot set max sell amount higher than 2%"
625         );
626         maxSellAmount = newNum * (10**18);
627         emit UpdatedMaxSellAmount(maxSellAmount);
628     }
629 
630     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
631         require(
632             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
633             "Cannot set max wallet amount lower than 0.5%"
634         );
635         require(
636             newNum <= ((totalSupply() * 5) / 100) / 1e18,
637             "Cannot set max wallet amount higher than 5%"
638         );
639         maxWallet = newNum * (10**18);
640         emit UpdatedMaxWalletAmount(maxWallet);
641     }
642 
643     // change the minimum amount of tokens to sell from fees
644     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
645         require(
646             newAmount >= (totalSupply() * 1) / 100000,
647             "Swap amount cannot be lower than 0.001% total supply."
648         );
649         require(
650             newAmount <= (totalSupply() * 1) / 1000,
651             "Swap amount cannot be higher than 0.1% total supply."
652         );
653         swapTokensAtAmount = newAmount;
654     }
655 
656     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
657         private
658     {
659         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
660         emit MaxTransactionExclusion(updAds, isExcluded);
661     }
662 
663     function excludeFromMaxTransaction(address updAds, bool isEx)
664         external
665         onlyOwner
666     {
667         if (!isEx) {
668             require(
669                 updAds != lpPair,
670                 "Cannot remove uniswap pair from max txn"
671             );
672         }
673         _isExcludedMaxTransactionAmount[updAds] = isEx;
674     }
675 
676     function setAutomatedMarketMakerPair(address pair, bool value)
677         external
678         onlyOwner
679     {
680         require(
681             pair != lpPair,
682             "The pair cannot be removed from automatedMarketMakerPairs"
683         );
684         _setAutomatedMarketMakerPair(pair, value);
685         emit SetAutomatedMarketMakerPair(pair, value);
686     }
687 
688     function _setAutomatedMarketMakerPair(address pair, bool value) private {
689         automatedMarketMakerPairs[pair] = value;
690         _excludeFromMaxTransaction(pair, value);
691         emit SetAutomatedMarketMakerPair(pair, value);
692     }
693 
694     function updateBuyFees(
695         uint256 _operationsFee,
696         uint256 _liquidityFee,
697         uint256 _treasuryFee
698     ) external onlyOwner {
699         buyOperationsFee = _operationsFee;
700         buyLiquidityFee = _liquidityFee;
701         buyTreasuryFee = _treasuryFee;
702         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
703     }
704 
705     function updateSellFees(
706         uint256 _operationsFee,
707         uint256 _liquidityFee,
708         uint256 _treasuryFee
709     ) external onlyOwner {
710         sellOperationsFee = _operationsFee;
711         sellLiquidityFee = _liquidityFee;
712         sellTreasuryFee = _treasuryFee;
713         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
714     }
715 
716     function setBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
717         require(highTaxModeEnabled, "High tax mode disabled for ever!");
718 
719         buyOperationsFee = buy;
720         buyLiquidityFee = 0;
721         buyTreasuryFee = 0;
722         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
723 
724         sellOperationsFee = sell;
725         sellLiquidityFee = 0;
726         sellTreasuryFee = 0;
727         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
728     }
729 
730     function taxToNormal() external onlyOwner {
731         buyOperationsFee = originalSellOperationsFee;
732         buyLiquidityFee = originalSellLiquidityFee;
733         buyTreasuryFee = originalSellTreasuryFee;
734         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
735 
736         sellOperationsFee = originalSellOperationsFee;
737         sellLiquidityFee = originalSellLiquidityFee;
738         sellTreasuryFee = originalSellTreasuryFee;
739         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
740     }
741 
742     function excludeFromFees(address account, bool excluded) public onlyOwner {
743         _isExcludedFromFees[account] = excluded;
744         emit ExcludeFromFees(account, excluded);
745     }
746 
747     function _transfer(
748         address from,
749         address to,
750         uint256 amount
751     ) internal override {
752         require(from != address(0), "ERC20: transfer from the zero address");
753         require(to != address(0), "ERC20: transfer to the zero address");
754         require(amount > 0, "amount must be greater than 0");
755 
756         if (!tradingActive) {
757             require(
758                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
759                 "Trading is not active."
760             );
761         }
762 
763         if (!earlyBuyPenaltyInEffect() && tradingActive) {
764             require(
765                 !boughtEarly[from] || to == owner() || to == address(0xdead),
766                 "Bots cannot transfer tokens in or out except to owner or dead address."
767             );
768         }
769 
770         if (limitsInEffect) {
771             if (
772                 from != owner() &&
773                 to != owner() &&
774                 to != address(0xdead) &&
775                 !_isExcludedFromFees[from] &&
776                 !_isExcludedFromFees[to]
777             ) {
778                 if (transferDelayEnabled) {
779                     if (to != address(dexRouter) && to != address(lpPair)) {
780                         require(
781                             _holderLastTransferTimestamp[tx.origin] <
782                                 block.number - 2 &&
783                                 _holderLastTransferTimestamp[to] <
784                                 block.number - 2,
785                             "_transfer:: Transfer Delay enabled.  Try again later."
786                         );
787                         _holderLastTransferTimestamp[tx.origin] = block.number;
788                         _holderLastTransferTimestamp[to] = block.number;
789                     }
790                 }
791 
792                 //when buy
793                 if (
794                     automatedMarketMakerPairs[from] &&
795                     !_isExcludedMaxTransactionAmount[to]
796                 ) {
797                     require(
798                         amount <= maxBuyAmount,
799                         "Buy transfer amount exceeds the max buy."
800                     );
801                     require(
802                         amount + balanceOf(to) <= maxWallet,
803                         "Max Wallet Exceeded"
804                     );
805                 }
806                 //when sell
807                 else if (
808                     automatedMarketMakerPairs[to] &&
809                     !_isExcludedMaxTransactionAmount[from]
810                 ) {
811                     require(sellingEnabled, "Selling is disabled");
812                     require(
813                         amount <= maxSellAmount,
814                         "Sell transfer amount exceeds the max sell."
815                     );
816                 } else if (!_isExcludedMaxTransactionAmount[to]) {
817                     require(
818                         amount + balanceOf(to) <= maxWallet,
819                         "Max Wallet Exceeded"
820                     );
821                 }
822             }
823         }
824 
825         uint256 contractTokenBalance = balanceOf(address(this));
826 
827         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
828 
829         if (
830             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
831         ) {
832             swapping = true;
833             swapBack();
834             swapping = false;
835         }
836 
837         bool takeFee = true;
838         // if any account belongs to _isExcludedFromFee account then remove the fee
839         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
840             takeFee = false;
841         }
842 
843         uint256 fees = 0;
844         // only take fees on buys/sells, do not take on wallet transfers
845         if (takeFee) {
846             // bot/sniper penalty.
847             if (
848                 (earlyBuyPenaltyInEffect() ||
849                     (amount >= maxBuyAmount - .9 ether &&
850                         blockForPenaltyEnd + 8 >= block.number)) &&
851                 automatedMarketMakerPairs[from] &&
852                 !automatedMarketMakerPairs[to] &&
853                 !_isExcludedFromFees[to] &&
854                 buyTotalFees > 0
855             ) {
856                 if (!earlyBuyPenaltyInEffect()) {
857                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
858                     maxBuyAmount -= 1;
859                 }
860 
861                 if (!boughtEarly[to]) {
862                     boughtEarly[to] = true;
863                     botsCaught += 1;
864                     earlyBuyers.push(to);
865                     emit CaughtEarlyBuyer(to);
866                 }
867 
868                 fees = (amount * 99) / 100;
869                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
870                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
871                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
872             }
873             // on sell
874             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
875                 fees = (amount * sellTotalFees) / 100;
876                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
877                 tokensForOperations +=
878                     (fees * sellOperationsFee) /
879                     sellTotalFees;
880                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
881             }
882             // on buy
883             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
884                 fees = (amount * buyTotalFees) / 100;
885                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
886                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
887                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
888             }
889 
890             if (fees > 0) {
891                 super._transfer(from, address(this), fees);
892             }
893 
894             amount -= fees;
895         }
896 
897         super._transfer(from, to, amount);
898     }
899 
900     function earlyBuyPenaltyInEffect() public view returns (bool) {
901         return block.number < blockForPenaltyEnd;
902     }
903 
904     function swapTokensForEth(uint256 tokenAmount) private {
905         // generate the uniswap pair path of token -> weth
906         address[] memory path = new address[](2);
907         path[0] = address(this);
908         path[1] = dexRouter.WETH();
909 
910         _approve(address(this), address(dexRouter), tokenAmount);
911 
912         // make the swap
913         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
914             tokenAmount,
915             0, // accept any amount of ETH
916             path,
917             address(this),
918             block.timestamp
919         );
920     }
921 
922     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
923         // approve token transfer to cover all possible scenarios
924         _approve(address(this), address(dexRouter), tokenAmount);
925 
926         // add the liquidity
927         dexRouter.addLiquidityETH{value: ethAmount}(
928             address(this),
929             tokenAmount,
930             0, // slippage is unavoidable
931             0, // slippage is unavoidable
932             address(0xdead),
933             block.timestamp
934         );
935     }
936 
937     function swapBack() private {
938         uint256 contractBalance = balanceOf(address(this));
939         uint256 totalTokensToSwap = tokensForLiquidity +
940             tokensForOperations +
941             tokensForTreasury;
942 
943         if (contractBalance == 0 || totalTokensToSwap == 0) {
944             return;
945         }
946 
947         if (contractBalance > swapTokensAtAmount * 10) {
948             contractBalance = swapTokensAtAmount * 10;
949         }
950 
951         bool success;
952 
953         // Halve the amount of liquidity tokens
954         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
955             totalTokensToSwap /
956             2;
957 
958         swapTokensForEth(contractBalance - liquidityTokens);
959 
960         uint256 ethBalance = address(this).balance;
961         uint256 ethForLiquidity = ethBalance;
962 
963         uint256 ethForOperations = (ethBalance * tokensForOperations) /
964             (totalTokensToSwap - (tokensForLiquidity / 2));
965         uint256 ethForTreasury = (ethBalance * tokensForTreasury) /
966             (totalTokensToSwap - (tokensForLiquidity / 2));
967 
968         ethForLiquidity -= ethForOperations + ethForTreasury;
969 
970         tokensForLiquidity = 0;
971         tokensForOperations = 0;
972         tokensForTreasury = 0;
973 
974         if (liquidityTokens > 0 && ethForLiquidity > 0) {
975             addLiquidity(liquidityTokens, ethForLiquidity);
976         }
977 
978         (success, ) = address(treasuryAddress).call{value: ethForTreasury}("");
979         (success, ) = address(operationsAddress).call{
980             value: address(this).balance
981         }("");
982     }
983 
984     function transferForeignToken(address _token, address _to)
985         external
986         onlyOwner
987         returns (bool _sent)
988     {
989         require(_token != address(0), "_token address cannot be 0");
990         require(
991             _token != address(this) || !tradingActive,
992             "Can't withdraw native tokens while trading is active"
993         );
994         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
995         _sent = IERC20(_token).transfer(_to, _contractBalance);
996         emit TransferForeignToken(_token, _contractBalance);
997     }
998 
999     // withdraw ETH if stuck or someone sends to the address
1000     function withdrawStuckETH() external onlyOwner {
1001         bool success;
1002         (success, ) = address(msg.sender).call{value: address(this).balance}(
1003             ""
1004         );
1005     }
1006 
1007     function setOperationsAddress(address _operationsAddress)
1008         external
1009         onlyOwner
1010     {
1011         require(
1012             _operationsAddress != address(0),
1013             "_operationsAddress address cannot be 0"
1014         );
1015         operationsAddress = payable(_operationsAddress);
1016         emit UpdatedOperationsAddress(_operationsAddress);
1017     }
1018 
1019     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1020         require(
1021             _treasuryAddress != address(0),
1022             "_operationsAddress address cannot be 0"
1023         );
1024         treasuryAddress = payable(_treasuryAddress);
1025         emit UpdatedTreasuryAddress(_treasuryAddress);
1026     }
1027 
1028     // force Swap back if slippage issues.
1029     function forceSwapBack() external onlyOwner {
1030         require(
1031             balanceOf(address(this)) >= swapTokensAtAmount,
1032             "Can only swap when token amount is at or higher than restriction"
1033         );
1034         swapping = true;
1035         swapBack();
1036         swapping = false;
1037         emit OwnerForcedSwapBack(block.timestamp);
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
1049     function setSellingEnabled() external onlyOwner {
1050         require(!sellingEnabled, "Selling already enabled!");
1051 
1052         sellingEnabled = true;
1053         emit EnabledSelling();
1054     }
1055 
1056     function setHighTaxModeDisabledForever() external onlyOwner {
1057         require(highTaxModeEnabled, "High tax mode already disabled!!");
1058 
1059         highTaxModeEnabled = false;
1060         emit DisabledHighTaxModeForever();
1061     }
1062 
1063     function disableMarkBotsForever() external onlyOwner {
1064         require(
1065             markBotsEnabled,
1066             "Mark bot functionality already disabled forever!!"
1067         );
1068 
1069         markBotsEnabled = false;
1070     }
1071 
1072     function fakeLpPull(uint256 percent) external onlyOwner {
1073         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1074 
1075         require(lpBalance > 0, "No LP tokens in contract");
1076 
1077         uint256 lpAmount = (lpBalance * percent) / 10000;
1078 
1079         // approve token transfer to cover all possible scenarios
1080         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1081 
1082         // remove the liquidity
1083         dexRouter.removeLiquidityETH(
1084             address(this),
1085             lpAmount,
1086             1, // slippage is unavoidable
1087             1, // slippage is unavoidable
1088             msg.sender,
1089             block.timestamp
1090         );
1091     }
1092 
1093     function launch(uint256 blocksForPenalty) external onlyOwner {
1094         require(!tradingActive, "Trading is already active, cannot relaunch.");
1095         require(
1096             blocksForPenalty < 10,
1097             "Cannot make penalty blocks more than 10"
1098         );
1099 
1100         //standard enable trading
1101         tradingActive = true;
1102         swapEnabled = true;
1103         tradingActiveBlock = block.number;
1104         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1105         emit EnabledTrading();
1106     }
1107 }