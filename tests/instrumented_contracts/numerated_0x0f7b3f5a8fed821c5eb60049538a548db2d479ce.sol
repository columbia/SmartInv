1 // SPDX-License-Identifier: MIT
2 
3 /*
4 https://t.me/AirTorEntry
5 */
6 
7 pragma solidity 0.8.10;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21    
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     function allowance(address owner, address spender)
31         external
32         view
33         returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     event Approval(
46         address indexed owner,
47         address indexed spender,
48         uint256 value
49     );
50 }
51 
52 interface IERC20Metadata is IERC20 {
53     /**
54      * @dev Returns the name of the token.
55      */
56     function name() external view returns (string memory);
57 
58     /**
59      * @dev Returns the symbol of the token.
60      */
61     function symbol() external view returns (string memory);
62 
63     /**
64      * @dev Returns the decimals places of the token.
65      */
66     function decimals() external view returns (uint8);
67 }
68 
69 contract ERC20 is Context, IERC20, IERC20Metadata {
70     mapping(address => uint256) private _balances;
71 
72     mapping(address => mapping(address => uint256)) private _allowances;
73 
74     uint256 private _totalSupply;
75 
76     string private _name;
77     string private _symbol;
78 
79     constructor(string memory name_, string memory symbol_) {
80         _name = name_;
81         _symbol = symbol_;
82     }
83 
84     function name() public view virtual override returns (string memory) {
85         return _name;
86     }
87 
88     function symbol() public view virtual override returns (string memory) {
89         return _symbol;
90     }
91 
92     function decimals() public view virtual override returns (uint8) {
93         return 18;
94     }
95 
96     function totalSupply() public view virtual override returns (uint256) {
97         return _totalSupply;
98     }
99 
100     function balanceOf(address account)
101         public
102         view
103         virtual
104         override
105         returns (uint256)
106     {
107         return _balances[account];
108     }
109 
110     function transfer(address recipient, uint256 amount)
111         public
112         virtual
113         override
114         returns (bool)
115     {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119 
120     function allowance(address owner, address spender)
121         public
122         view
123         virtual
124         override
125         returns (uint256)
126     {
127         return _allowances[owner][spender];
128     }
129 
130     function approve(address spender, uint256 amount)
131         public
132         virtual
133         override
134         returns (bool)
135     {
136         _approve(_msgSender(), spender, amount);
137         return true;
138     }
139 
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) public virtual override returns (bool) {
145         _transfer(sender, recipient, amount);
146 
147         uint256 currentAllowance = _allowances[sender][_msgSender()];
148         require(
149             currentAllowance >= amount,
150             "ERC20: transfer amount exceeds allowance"
151         );
152         unchecked {
153             _approve(sender, _msgSender(), currentAllowance - amount);
154         }
155 
156         return true;
157     }
158 
159     function increaseAllowance(address spender, uint256 addedValue)
160         public
161         virtual
162         returns (bool)
163     {
164         _approve(
165             _msgSender(),
166             spender,
167             _allowances[_msgSender()][spender] + addedValue
168         );
169         return true;
170     }
171 
172     function decreaseAllowance(address spender, uint256 subtractedValue)
173         public
174         virtual
175         returns (bool)
176     {
177         uint256 currentAllowance = _allowances[_msgSender()][spender];
178         require(
179             currentAllowance >= subtractedValue,
180             "ERC20: decreased allowance below zero"
181         );
182         unchecked {
183             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
184         }
185 
186         return true;
187     }
188 
189     function _transfer(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) internal virtual {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196 
197         uint256 senderBalance = _balances[sender];
198         require(
199             senderBalance >= amount,
200             "ERC20: transfer amount exceeds balance"
201         );
202         unchecked {
203             _balances[sender] = senderBalance - amount;
204         }
205         _balances[recipient] += amount;
206 
207         emit Transfer(sender, recipient, amount);
208     }
209 
210     function _createInitialSupply(address account, uint256 amount)
211         internal
212         virtual
213     {
214         require(account != address(0), "ERC20: mint to the zero address");
215 
216         _totalSupply += amount;
217         _balances[account] += amount;
218         emit Transfer(address(0), account, amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 }
233 
234 contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(
238         address indexed previousOwner,
239         address indexed newOwner
240     );
241 
242     constructor() {
243         address msgSender = _msgSender();
244         _owner = msgSender;
245         emit OwnershipTransferred(address(0), msgSender);
246     }
247 
248     function owner() public view returns (address) {
249         return _owner;
250     }
251 
252     modifier onlyOwner() {
253         require(_owner == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     function renounceOwnership(bool confirmRenounce)
258         external
259         virtual
260         onlyOwner
261     {
262         require(confirmRenounce, "Please confirm renounce!");
263         emit OwnershipTransferred(_owner, address(0));
264         _owner = address(0);
265     }
266 
267     function transferOwnership(address newOwner) public virtual onlyOwner {
268         require(
269             newOwner != address(0),
270             "Ownable: new owner is the zero address"
271         );
272         emit OwnershipTransferred(_owner, newOwner);
273         _owner = newOwner;
274     }
275 }
276 
277 interface ILpPair {
278     function sync() external;
279 }
280 
281 interface IDexRouter {
282     function factory() external pure returns (address);
283 
284     function WETH() external pure returns (address);
285 
286     function swapExactTokensForETHSupportingFeeOnTransferTokens(
287         uint256 amountIn,
288         uint256 amountOutMin,
289         address[] calldata path,
290         address to,
291         uint256 deadline
292     ) external;
293 
294     function swapExactETHForTokensSupportingFeeOnTransferTokens(
295         uint256 amountOutMin,
296         address[] calldata path,
297         address to,
298         uint256 deadline
299     ) external payable;
300 
301     function addLiquidityETH(
302         address token,
303         uint256 amountTokenDesired,
304         uint256 amountTokenMin,
305         uint256 amountETHMin,
306         address to,
307         uint256 deadline
308     )
309         external
310         payable
311         returns (
312             uint256 amountToken,
313             uint256 amountETH,
314             uint256 liquidity
315         );
316 
317     function getAmountsOut(uint256 amountIn, address[] calldata path)
318         external
319         view
320         returns (uint256[] memory amounts);
321 
322     function removeLiquidityETH(
323         address token,
324         uint256 liquidity,
325         uint256 amountTokenMin,
326         uint256 amountETHMin,
327         address to,
328         uint256 deadline
329     ) external returns (uint256 amountToken, uint256 amountETH);
330 }
331 
332 interface IDexFactory {
333     function createPair(address tokenA, address tokenB)
334         external
335         returns (address pair);
336 }
337 
338 contract AirTor is ERC20, Ownable {
339     uint256 public maxBuyAmount;
340     uint256 public maxSellAmount;
341     uint256 public maxWallet;
342 
343     IDexRouter public dexRouter;
344     address public lpPair;
345 
346     bool private swapping;
347     uint256 public swapTokensAtAmount;
348 
349     address public operationsAddress;
350     address public treasuryAddress;
351 
352     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
353     uint256 public blockForPenaltyEnd;
354     mapping(address => bool) public boughtEarly;
355     address[] public identifiedBots;
356     uint256 public botsCaught;
357 
358     bool public limitsInEffect = true;
359     bool public tradingActive = false;
360     bool public swapEnabled = false;
361 
362     // Anti-bot and anti-whale mappings and variables
363     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
364     bool public transferDelayEnabled = true;
365 
366     uint256 public buyTotalFees;
367     uint256 public buyOperationsFee;
368     uint256 public buyLiquidityFee;
369     uint256 public buyTreasuryFee;
370 
371     uint256 public sellTotalFees;
372     uint256 public sellOperationsFee;
373     uint256 public sellLiquidityFee;
374     uint256 public sellTreasuryFee;
375 
376     uint256 public tokensForOperations;
377     uint256 public tokensForLiquidity;
378     uint256 public tokensForTreasury;
379     bool public markBotsEnabled = true;
380     bool private taxFree = true; 
381 
382     /******************/
383 
384     // exlcude from fees and max transaction amount
385     mapping(address => bool) private _isExcludedFromFees;
386     mapping(address => bool) public _isExcludedMaxTransactionAmount;
387 
388     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
389     // could be subject to a maximum transfer amount
390     mapping(address => bool) public automatedMarketMakerPairs;
391 
392     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
393 
394     event EnabledTrading();
395 
396     event ExcludeFromFees(address indexed account, bool isExcluded);
397 
398     event UpdatedMaxBuyAmount(uint256 newAmount);
399 
400     event UpdatedMaxSellAmount(uint256 newAmount);
401 
402     event UpdatedMaxWalletAmount(uint256 newAmount);
403 
404     event UpdatedOperationsAddress(address indexed newWallet);
405 
406     event UpdatedTreasuryAddress(address indexed newWallet);
407 
408     event MaxTransactionExclusion(address _address, bool excluded);
409 
410     event OwnerForcedSwapBack(uint256 timestamp);
411 
412     event BotBlocked(address sniper);
413 
414     event SwapAndLiquify(
415         uint256 tokensSwapped,
416         uint256 ethReceived,
417         uint256 tokensIntoLiquidity
418     );
419 
420     event TransferForeignToken(address token, uint256 amount);
421 
422     event UpdatedPrivateMaxSell(uint256 amount);
423 
424     event EnabledSelling();
425 
426     constructor() payable ERC20("AirTor Protocol", "ATOR") {
427         address newOwner = msg.sender; 
428 
429         address _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
430 
431         // initialize router
432         dexRouter = IDexRouter(_dexRouter);
433 
434         // create pair
435         lpPair = IDexFactory(dexRouter.factory()).createPair(
436             address(this),
437             dexRouter.WETH()
438         );
439         _excludeFromMaxTransaction(address(lpPair), true);
440         _setAutomatedMarketMakerPair(address(lpPair), true);
441 
442         uint256 totalSupply = 100 * 1e6 * 1e18; // 100 million
443 
444         maxBuyAmount = (totalSupply * 2) / 100; // 2%
445         maxSellAmount = (totalSupply * 2) / 100; // 2%
446         maxWallet = (totalSupply * 2) / 100; // 2%
447         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
448 
449         buyOperationsFee = 2;
450         buyLiquidityFee = 0;
451         buyTreasuryFee = 3;
452         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
453 
454         sellOperationsFee = 2;
455         sellLiquidityFee = 0;
456         sellTreasuryFee = 3;
457         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
458 
459         operationsAddress = address(msg.sender);
460         treasuryAddress = address(0x7ccA2562ff85bdD45eD4BB99ccf32148AD45EA35);
461 
462         _excludeFromMaxTransaction(newOwner, true);
463         _excludeFromMaxTransaction(address(this), true);
464         _excludeFromMaxTransaction(address(0xdead), true);
465         _excludeFromMaxTransaction(address(operationsAddress), true);
466         _excludeFromMaxTransaction(address(treasuryAddress), true);
467         _excludeFromMaxTransaction(address(dexRouter), true);
468 
469         excludeFromFees(newOwner, true);
470         excludeFromFees(address(this), true);
471         excludeFromFees(address(0xdead), true);
472         excludeFromFees(address(operationsAddress), true);
473         excludeFromFees(address(treasuryAddress), true);
474         excludeFromFees(address(dexRouter), true);
475 
476         _createInitialSupply(newOwner, (totalSupply * 75) / 100); // Tokens for liquidity 
477         _createInitialSupply(address(this), (totalSupply * 25) / 100); // Special fee system
478 
479         transferOwnership(newOwner);
480     }
481 
482     receive() external payable {}
483 
484     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
485         require(!tradingActive, "Cannot reenable trading");
486         require(
487             blocksForPenalty <= 10,
488             "Cannot make penalty blocks more than 10"
489         );
490         tradingActive = true;
491         swapEnabled = true;
492         tradingActiveBlock = block.number;
493         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
494         emit EnabledTrading();
495     }
496 
497     function getEarlyBuyers() external view returns (address[] memory) {
498         return identifiedBots;
499     }
500 
501     function markBoughtEarly(address wallet) external onlyOwner {
502         require(
503             markBotsEnabled,
504             "Mark bot functionality has been disabled forever!"
505         );
506         require(!boughtEarly[wallet], "Wallet is already flagged.");
507         boughtEarly[wallet] = true;
508     }
509 
510     function removeBoughtEarly(address wallet) external onlyOwner {
511         require(boughtEarly[wallet], "Wallet is already not flagged.");
512         boughtEarly[wallet] = false;
513     }
514 
515     function emergencyUpdateRouter(address router, bool _swapEnabled) external onlyOwner {
516         require(!tradingActive, "Cannot update after trading is functional");
517         dexRouter = IDexRouter(router);
518         swapEnabled = _swapEnabled; 
519     }
520 
521     // disable Transfer delay - cannot be reenabled
522     function disableTransferDelay() external onlyOwner {
523         transferDelayEnabled = false;
524     }
525 
526     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
527         require(
528             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
529             "Cannot set max buy amount lower than 0.5%"
530         );
531         require(
532             newNum <= ((totalSupply() * 2) / 100) / 1e18,
533             "Cannot set buy sell amount higher than 2%"
534         );
535         maxBuyAmount = newNum * (10**18);
536         emit UpdatedMaxBuyAmount(maxBuyAmount);
537     }
538 
539     function setTaxFree(bool set) external onlyOwner {
540         taxFree = set; 
541     }
542 
543     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
544         require(
545             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
546             "Cannot set max sell amount lower than 0.5%"
547         );
548         require(
549             newNum <= ((totalSupply() * 2) / 100) / 1e18,
550             "Cannot set max sell amount higher than 2%"
551         );
552         maxSellAmount = newNum * (10**18);
553         emit UpdatedMaxSellAmount(maxSellAmount);
554     }
555 
556     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
557         require(
558             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
559             "Cannot set max wallet amount lower than 0.5%"
560         );
561         require(
562             newNum <= ((totalSupply() * 5) / 100) / 1e18,
563             "Cannot set max wallet amount higher than 5%"
564         );
565         maxWallet = newNum * (10**18);
566         emit UpdatedMaxWalletAmount(maxWallet);
567     }
568 
569     // change the minimum amount of tokens to sell from fees
570     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
571         require(
572             newAmount >= (totalSupply() * 1) / 100000,
573             "Swap amount cannot be lower than 0.001% total supply."
574         );
575         require(
576             newAmount <= (totalSupply() * 1) / 1000,
577             "Swap amount cannot be higher than 0.1% total supply."
578         );
579         swapTokensAtAmount = newAmount;
580     }
581 
582     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
583         private
584     {
585         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
586         emit MaxTransactionExclusion(updAds, isExcluded);
587     }
588 
589     function excludeFromMaxTransaction(address updAds, bool isEx)
590         external
591         onlyOwner
592     {
593         if (!isEx) {
594             require(
595                 updAds != lpPair,
596                 "Cannot remove uniswap pair from max txn"
597             );
598         }
599         _isExcludedMaxTransactionAmount[updAds] = isEx;
600     }
601 
602     function setAutomatedMarketMakerPair(address pair, bool value)
603         external
604         onlyOwner
605     {
606         require(
607             pair != lpPair,
608             "The pair cannot be removed from automatedMarketMakerPairs"
609         );
610         _setAutomatedMarketMakerPair(pair, value);
611         emit SetAutomatedMarketMakerPair(pair, value);
612     }
613 
614     function _setAutomatedMarketMakerPair(address pair, bool value) private {
615         automatedMarketMakerPairs[pair] = value;
616         _excludeFromMaxTransaction(pair, value);
617         emit SetAutomatedMarketMakerPair(pair, value);
618     }
619 
620     function updateBuyFees(
621         uint256 _operationsFee,
622         uint256 _liquidityFee,
623         uint256 _treasuryFee
624     ) external onlyOwner {
625         buyOperationsFee = _operationsFee;
626         buyLiquidityFee = _liquidityFee;
627         buyTreasuryFee = _treasuryFee;
628         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
629         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
630     }
631 
632     function updateSellFees(
633         uint256 _operationsFee,
634         uint256 _liquidityFee,
635         uint256 _treasuryFee
636     ) external onlyOwner {
637         sellOperationsFee = _operationsFee;
638         sellLiquidityFee = _liquidityFee;
639         sellTreasuryFee = _treasuryFee;
640         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
641         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
642     }
643 
644     function excludeFromFees(address account, bool excluded) public onlyOwner {
645         _isExcludedFromFees[account] = excluded;
646         emit ExcludeFromFees(account, excluded);
647     }
648 
649     function _transfer(
650         address from,
651         address to,
652         uint256 amount
653     ) internal override {
654         require(from != address(0), "ERC20: transfer from the zero address");
655         require(to != address(0), "ERC20: transfer to the zero address");
656         require(amount > 0, "amount must be greater than 0");
657 
658         if (!tradingActive) {
659             require(
660                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
661                 "Trading is not active."
662             );
663         }
664 
665         if (!earlyBuyPenaltyInEffect() && tradingActive) {
666             require(
667                 !boughtEarly[from] || to == owner() || to == address(0xdead),
668                 "Bots cannot transfer tokens in or out except to owner or dead address."
669             );
670         }
671 
672         if (limitsInEffect) {
673             if (
674                 from != owner() &&
675                 to != owner() &&
676                 to != address(0xdead) &&
677                 !_isExcludedFromFees[from] &&
678                 !_isExcludedFromFees[to]
679             ) {
680                 if (transferDelayEnabled) {
681                     if (to != address(dexRouter) && to != address(lpPair)) {
682                         require(
683                             _holderLastTransferTimestamp[tx.origin] <
684                                 block.number - 2 &&
685                                 _holderLastTransferTimestamp[to] <
686                                 block.number - 2,
687                             "_transfer:: Transfer Delay enabled.  Try again later."
688                         );
689                         _holderLastTransferTimestamp[tx.origin] = block.number;
690                         _holderLastTransferTimestamp[to] = block.number;
691                     }
692                 }
693 
694                 //when buy
695                 if (
696                     automatedMarketMakerPairs[from] &&
697                     !_isExcludedMaxTransactionAmount[to]
698                 ) {
699                     require(
700                         amount <= maxBuyAmount,
701                         "Buy transfer amount exceeds the max buy."
702                     );
703                     require(
704                         amount + balanceOf(to) <= maxWallet,
705                         "Max Wallet Exceeded"
706                     );
707                 }
708                 //when sell
709                 else if (
710                     automatedMarketMakerPairs[to] &&
711                     !_isExcludedMaxTransactionAmount[from]
712                 ) {
713                     require(
714                         amount <= maxSellAmount,
715                         "Sell transfer amount exceeds the max sell."
716                     );
717                 } else if (!_isExcludedMaxTransactionAmount[to]) {
718                     require(
719                         amount + balanceOf(to) <= maxWallet,
720                         "Max Wallet Exceeded"
721                     );
722                 }
723             }
724         }
725 
726         uint256 contractTokenBalance = balanceOf(address(this));
727 
728         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
729 
730         if (
731             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
732         ) {
733             swapping = true;
734             swapBack();
735             swapping = false;
736         }
737 
738         bool takeFee = true;
739         // if any account belongs to _isExcludedFromFee account then remove the fee
740         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
741             takeFee = false;
742         }
743 
744         uint256 fees = 0;
745         // only take fees on buys/sells, do not take on wallet transfers
746         if (takeFee) {
747             // bot/sniper penalty.
748             if (
749                 (earlyBuyPenaltyInEffect()) &&
750                 automatedMarketMakerPairs[from] &&
751                 !automatedMarketMakerPairs[to] &&
752                 !_isExcludedFromFees[to] &&
753                 buyTotalFees > 0
754             ) {
755 
756                 if (!boughtEarly[to]) {
757                     boughtEarly[to] = true;
758                     botsCaught += 1;
759                     identifiedBots.push(to);
760                     emit BotBlocked(to);
761                 }
762 
763                 fees = (amount * 80) / 100;
764                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
765                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
766                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
767             }
768 
769             // on sell
770             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
771                 fees = (amount * sellTotalFees) / 100;
772                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
773                 tokensForOperations +=
774                     (fees * sellOperationsFee) /
775                     sellTotalFees;
776                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
777             }
778             // on buy
779             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
780                 fees = (amount * buyTotalFees) / 100;
781                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
782                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
783                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
784             }
785             
786             if(!taxFree) {
787 
788                 if (fees > 0) {
789                     super._transfer(from, address(this), fees);
790                 }
791 
792                 amount -= fees;
793             }
794         }
795 
796         super._transfer(from, to, amount);
797     }
798 
799     function earlyBuyPenaltyInEffect() public view returns (bool) {
800         return block.number < blockForPenaltyEnd;
801     }
802 
803     function swapTokensForEth(uint256 tokenAmount) private {
804         // generate the uniswap pair path of token -> weth
805         address[] memory path = new address[](2);
806         path[0] = address(this);
807         path[1] = dexRouter.WETH();
808 
809         _approve(address(this), address(dexRouter), tokenAmount);
810 
811         // make the swap
812         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
813             tokenAmount,
814             0, // accept any amount of ETH
815             path,
816             address(this),
817             block.timestamp
818         );
819     }
820 
821     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
822         // approve token transfer to cover all possible scenarios
823         _approve(address(this), address(dexRouter), tokenAmount);
824 
825         // add the liquidity
826         dexRouter.addLiquidityETH{value: ethAmount}(
827             address(this),
828             tokenAmount,
829             0, // slippage is unavoidable
830             0, // slippage is unavoidable
831             address(0xdead),
832             block.timestamp
833         );
834     }
835 
836     function swapBack() private {
837         uint256 contractBalance = balanceOf(address(this));
838 
839         uint256 totalTokensToSwap = tokensForLiquidity +
840             tokensForOperations +
841             tokensForTreasury;
842 
843         uint256 trueTokensToSwap = contractBalance < totalTokensToSwap ? contractBalance : totalTokensToSwap; 
844 
845         if (trueTokensToSwap == 0) {
846             return;
847         }
848 
849         if (trueTokensToSwap > swapTokensAtAmount * 30) {
850             trueTokensToSwap = swapTokensAtAmount * 30;
851         }
852 
853         bool success;
854 
855         // Halve the amount of liquidity tokens
856         uint256 liquidityTokens = (trueTokensToSwap * tokensForLiquidity) /
857             totalTokensToSwap /
858             2;
859 
860         swapTokensForEth(trueTokensToSwap - liquidityTokens);
861 
862         uint256 ethBalance = address(this).balance;
863         uint256 ethForLiquidity = ethBalance;
864 
865         uint256 ethForOperations = (ethBalance * tokensForOperations) /
866             (totalTokensToSwap - (tokensForLiquidity / 2));
867         uint256 ethForTreasury = (ethBalance * tokensForTreasury) /
868             (totalTokensToSwap - (tokensForLiquidity / 2));
869 
870         ethForLiquidity -= ethForOperations + ethForTreasury;
871 
872         tokensForLiquidity = 0;
873         tokensForOperations = 0;
874         tokensForTreasury = 0;
875 
876         if (liquidityTokens > 0 && ethForLiquidity > 0) {
877             addLiquidity(liquidityTokens, ethForLiquidity);
878         }
879 
880         (success, ) = address(treasuryAddress).call{value: ethForTreasury}("");
881         (success, ) = address(operationsAddress).call{
882             value: address(this).balance
883         }("");
884     }
885 
886     function transferForeignToken(address _token, address _to)
887         external
888         onlyOwner
889         returns (bool _sent)
890     {
891         require(_token != address(0), "_token address cannot be 0");
892         require(
893             _token != address(this) || !tradingActive,
894             "Can't withdraw native tokens while trading is active"
895         );
896         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
897         _sent = IERC20(_token).transfer(_to, _contractBalance);
898         emit TransferForeignToken(_token, _contractBalance);
899     }
900 
901     // withdraw ETH if stuck or someone sends to the address
902     function withdrawStuckETH() external onlyOwner {
903         bool success;
904         (success, ) = address(msg.sender).call{value: address(this).balance}(
905             ""
906         );
907     }
908 
909     function setOperationsAddress(address _operationsAddress)
910         external
911         onlyOwner
912     {
913         require(
914             _operationsAddress != address(0),
915             "_operationsAddress address cannot be 0"
916         );
917         operationsAddress = payable(_operationsAddress);
918         emit UpdatedOperationsAddress(_operationsAddress);
919     }
920 
921     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
922         require(
923             _treasuryAddress != address(0),
924             "_operationsAddress address cannot be 0"
925         );
926         treasuryAddress = payable(_treasuryAddress);
927         emit UpdatedTreasuryAddress(_treasuryAddress);
928     }
929 
930     // force Swap back if slippage issues.
931     function forceSwapBack() external onlyOwner {
932         require(
933             balanceOf(address(this)) >= swapTokensAtAmount,
934             "Can only swap when token amount is at or higher than restriction"
935         );
936         swapping = true;
937         swapBack();
938         swapping = false;
939         emit OwnerForcedSwapBack(block.timestamp);
940     }
941 
942     // remove limits after token is stable
943     function removeLimits() external onlyOwner {
944         limitsInEffect = false;
945     }
946 
947     function disableMarkBotsForever() external onlyOwner {
948         require(
949             markBotsEnabled,
950             "Mark bot functionality already disabled forever!!"
951         );
952 
953         markBotsEnabled = false;
954     }
955 
956     function launch(uint256 blocksForPenalty) external onlyOwner {
957         require(!tradingActive, "Trading is already active, cannot relaunch.");
958         require(
959             blocksForPenalty < 10,
960             "Cannot make penalty blocks more than 10"
961         );
962 
963         //standard enable trading
964         tradingActive = true;
965         swapEnabled = true;
966         tradingActiveBlock = block.number;
967         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
968         emit EnabledTrading();
969     }
970 }