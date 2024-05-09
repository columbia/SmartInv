1 // SPDX-License-Identifier: MIT
2 /*
3  *  Telegram : https://t.me/JOJOPortal
4  *  Twitter  : https://twitter.com/JOJO_Coin
5  */
6 pragma solidity 0.8.13;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount)
38         external
39         returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender)
49         external
50         view
51         returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(
97         address indexed owner,
98         address indexed spender,
99         uint256 value
100     );
101 }
102 
103 interface IERC20Metadata is IERC20 {
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() external view returns (string memory);
108 
109     /**
110      * @dev Returns the symbol of the token.
111      */
112     function symbol() external view returns (string memory);
113 
114     /**
115      * @dev Returns the decimals places of the token.
116      */
117     function decimals() external view returns (uint8);
118 }
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     string private _name;
128     string private _symbol;
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account)
152         public
153         view
154         virtual
155         override
156         returns (uint256)
157     {
158         return _balances[account];
159     }
160 
161     function transfer(address recipient, uint256 amount)
162         public
163         virtual
164         override
165         returns (bool)
166     {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     function allowance(address owner, address spender)
172         public
173         view
174         virtual
175         override
176         returns (uint256)
177     {
178         return _allowances[owner][spender];
179     }
180 
181     function approve(address spender, uint256 amount)
182         public
183         virtual
184         override
185         returns (bool)
186     {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190 
191     function transferFrom(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) public virtual override returns (bool) {
196         _transfer(sender, recipient, amount);
197 
198         uint256 currentAllowance = _allowances[sender][_msgSender()];
199         require(
200             currentAllowance >= amount,
201             "ERC20: transfer amount exceeds allowance"
202         );
203         unchecked {
204             _approve(sender, _msgSender(), currentAllowance - amount);
205         }
206 
207         return true;
208     }
209 
210     function increaseAllowance(address spender, uint256 addedValue)
211         public
212         virtual
213         returns (bool)
214     {
215         _approve(
216             _msgSender(),
217             spender,
218             _allowances[_msgSender()][spender] + addedValue
219         );
220         return true;
221     }
222 
223     function decreaseAllowance(address spender, uint256 subtractedValue)
224         public
225         virtual
226         returns (bool)
227     {
228         uint256 currentAllowance = _allowances[_msgSender()][spender];
229         require(
230             currentAllowance >= subtractedValue,
231             "ERC20: decreased allowance below zero"
232         );
233         unchecked {
234             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
235         }
236 
237         return true;
238     }
239 
240     function _transfer(
241         address sender,
242         address recipient,
243         uint256 amount
244     ) internal virtual {
245         require(sender != address(0), "ERC20: transfer from the zero address");
246         require(recipient != address(0), "ERC20: transfer to the zero address");
247 
248         uint256 senderBalance = _balances[sender];
249         require(
250             senderBalance >= amount,
251             "ERC20: transfer amount exceeds balance"
252         );
253         unchecked {
254             _balances[sender] = senderBalance - amount;
255         }
256         _balances[recipient] += amount;
257 
258         emit Transfer(sender, recipient, amount);
259     }
260 
261     function _createInitialSupply(address account, uint256 amount)
262         internal
263         virtual
264     {
265         require(account != address(0), "ERC20: mint to the zero address");
266 
267         _totalSupply += amount;
268         _balances[account] += amount;
269         emit Transfer(address(0), account, amount);
270     }
271 
272     function _approve(
273         address owner,
274         address spender,
275         uint256 amount
276     ) internal virtual {
277         require(owner != address(0), "ERC20: approve from the zero address");
278         require(spender != address(0), "ERC20: approve to the zero address");
279 
280         _allowances[owner][spender] = amount;
281         emit Approval(owner, spender, amount);
282     }
283 }
284 
285 contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(
289         address indexed previousOwner,
290         address indexed newOwner
291     );
292 
293     constructor() {
294         address msgSender = _msgSender();
295         _owner = msgSender;
296         emit OwnershipTransferred(address(0), msgSender);
297     }
298 
299     function owner() public view returns (address) {
300         return _owner;
301     }
302 
303     modifier onlyOwner() {
304         require(_owner == _msgSender(), "Ownable: caller is not the owner");
305         _;
306     }
307 
308     function renounceOwnership(bool confirmRenounce)
309         external
310         virtual
311         onlyOwner
312     {
313         require(confirmRenounce, "Please confirm renounce!");
314         emit OwnershipTransferred(_owner, address(0));
315         _owner = address(0);
316     }
317 
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(
320             newOwner != address(0),
321             "Ownable: new owner is the zero address"
322         );
323         emit OwnershipTransferred(_owner, newOwner);
324         _owner = newOwner;
325     }
326 }
327 
328 interface ILpPair {
329     function sync() external;
330 }
331 
332 interface IDexRouter {
333     function factory() external pure returns (address);
334 
335     function WETH() external pure returns (address);
336 
337     function swapExactTokensForETHSupportingFeeOnTransferTokens(
338         uint256 amountIn,
339         uint256 amountOutMin,
340         address[] calldata path,
341         address to,
342         uint256 deadline
343     ) external;
344 
345     function swapExactETHForTokensSupportingFeeOnTransferTokens(
346         uint256 amountOutMin,
347         address[] calldata path,
348         address to,
349         uint256 deadline
350     ) external payable;
351 
352     function addLiquidityETH(
353         address token,
354         uint256 amountTokenDesired,
355         uint256 amountTokenMin,
356         uint256 amountETHMin,
357         address to,
358         uint256 deadline
359     )
360         external
361         payable
362         returns (
363             uint256 amountToken,
364             uint256 amountETH,
365             uint256 liquidity
366         );
367 
368     function getAmountsOut(uint256 amountIn, address[] calldata path)
369         external
370         view
371         returns (uint256[] memory amounts);
372 
373     function removeLiquidityETH(
374         address token,
375         uint256 liquidity,
376         uint256 amountTokenMin,
377         uint256 amountETHMin,
378         address to,
379         uint256 deadline
380     ) external returns (uint256 amountToken, uint256 amountETH);
381 }
382 
383 interface IDexFactory {
384     function createPair(address tokenA, address tokenB)
385         external
386         returns (address pair);
387 }
388 
389 contract JoJo is ERC20, Ownable {
390     uint256 public maxBuyAmount;
391     uint256 public maxSellAmount;
392     uint256 public maxWallet;
393 
394     IDexRouter public dexRouter;
395     address public lpPair;
396 
397     bool private swapping;
398     uint256 public swapTokensAtAmount;
399 
400     address public operationsAddress;
401 
402     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
403     uint256 public blockForPenaltyEnd;
404     mapping(address => bool) public boughtEarly;
405     address[] public earlyBuyers;
406     uint256 public botsCaught;
407 
408     bool public limitsInEffect = true;
409     bool public tradingActive = false;
410     bool public swapEnabled = false;
411     // MEV Bot prevention - cannot be turned off once enabled!!
412     bool public sellingEnabled = false;
413 
414     // Anti-bot and anti-whale mappings and variables
415     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
416     bool public transferDelayEnabled = true;
417 
418     uint256 public buyTotalFees;
419     uint256 public buyOperationsFee;
420     uint256 public buyLiquidityFee;
421 
422     uint256 private originalOperationsFee;
423     uint256 private originalLiquidityFee;
424 
425     uint256 public sellTotalFees;
426     uint256 public sellOperationsFee;
427     uint256 public sellLiquidityFee;
428 
429     uint256 public tokensForOperations;
430     uint256 public tokensForLiquidity;
431 
432     /******************/
433 
434     // exlcude from fees and max transaction amount
435     mapping(address => bool) private _isExcludedFromFees;
436     mapping(address => bool) public _isExcludedMaxTransactionAmount;
437 
438     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
439     // could be subject to a maximum transfer amount
440     mapping(address => bool) public automatedMarketMakerPairs;
441 
442     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
443 
444     event EnabledTrading();
445 
446     event EnabledSellingForever();
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
458     event MaxTransactionExclusion(address _address, bool excluded);
459 
460     event OwnerForcedSwapBack(uint256 timestamp);
461 
462     event CaughtEarlyBuyer(address sniper);
463 
464     event SwapAndLiquify(
465         uint256 tokensSwapped,
466         uint256 ethReceived,
467         uint256 tokensIntoLiquidity
468     );
469 
470     event TransferForeignToken(address token, uint256 amount);
471 
472     constructor() payable ERC20("JoJos Adventure", "JOJO") {
473         address newOwner = msg.sender; // can leave alone if owner is deployer.
474 
475         address _dexRouter;
476 
477         if (block.chainid == 1) {
478             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2 MAINNET
479         } else if (block.chainid == 4) {
480             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2 RINKEBY
481         } else {
482             revert("Chain not configured");
483         }
484 
485         // initialize router
486         dexRouter = IDexRouter(_dexRouter);
487 
488         // create pair
489         lpPair = IDexFactory(dexRouter.factory()).createPair(
490             address(this),
491             dexRouter.WETH()
492         );
493         _excludeFromMaxTransaction(address(lpPair), true);
494         _setAutomatedMarketMakerPair(address(lpPair), true);
495 
496         uint256 totalSupply = 1 * 1e4 * 1e18;
497 
498         maxBuyAmount = (totalSupply * 1) / 100; // 1%
499         maxSellAmount = (totalSupply * 1) / 100; // 1%
500         maxWallet = (totalSupply * 1) / 100; // 1%
501         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
502 
503         buyOperationsFee = 6;
504         buyLiquidityFee = 4;
505         buyTotalFees = buyOperationsFee + buyLiquidityFee;
506 
507         originalOperationsFee = 4;
508         originalLiquidityFee = 1;
509 
510         sellOperationsFee = 6;
511         sellLiquidityFee = 4;
512         sellTotalFees = sellOperationsFee + sellLiquidityFee;
513 
514         operationsAddress = address(0xffa775AdC6fD4488ff205cFd21cc11864335c186);
515 
516         _excludeFromMaxTransaction(newOwner, true);
517         _excludeFromMaxTransaction(address(this), true);
518         _excludeFromMaxTransaction(address(0xdead), true);
519         _excludeFromMaxTransaction(address(operationsAddress), true);
520         _excludeFromMaxTransaction(address(dexRouter), true);
521 
522         excludeFromFees(newOwner, true);
523         excludeFromFees(address(this), true);
524         excludeFromFees(address(0xdead), true);
525         excludeFromFees(address(operationsAddress), true);
526         excludeFromFees(address(dexRouter), true);
527 
528         _createInitialSupply(newOwner, (totalSupply * 75) / 100);
529         _createInitialSupply(address(this), (totalSupply * 25) / 100); // LP
530 
531         transferOwnership(newOwner);
532     }
533 
534     receive() external payable {}
535 
536     function getEarlyBuyers() external view returns (address[] memory) {
537         return earlyBuyers;
538     }
539 
540     function removeBoughtEarly(address wallet) external onlyOwner {
541         require(boughtEarly[wallet], "Wallet is already not flagged.");
542         boughtEarly[wallet] = false;
543     }
544 
545     function markBoughtEarly(address wallet) external onlyOwner {
546         require(!boughtEarly[wallet], "Wallet is already flagged.");
547         boughtEarly[wallet] = true;
548     }
549 
550     // disable Transfer delay - cannot be reenabled
551     function disableTransferDelay() external onlyOwner {
552         transferDelayEnabled = false;
553     }
554 
555     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
556         require(
557             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
558             "Cannot set max buy amount lower than 0.01%"
559         );
560         maxBuyAmount = newNum * (10**18);
561         emit UpdatedMaxBuyAmount(maxBuyAmount);
562     }
563 
564     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
565         require(
566             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
567             "Cannot set max sell amount lower than 0.01%"
568         );
569         maxSellAmount = newNum * (10**18);
570         emit UpdatedMaxSellAmount(maxSellAmount);
571     }
572 
573     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
574         require(
575             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
576             "Cannot set max sell amount lower than 0.5%"
577         );
578         maxWallet = newNum * (10**18);
579         emit UpdatedMaxWalletAmount(maxWallet);
580     }
581 
582     // change the minimum amount of tokens to sell from fees
583     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
584         require(
585             newAmount >= (totalSupply() * 1) / 100000,
586             "Swap amount cannot be lower than 0.001% total supply."
587         );
588         require(
589             newAmount <= (totalSupply() * 1) / 1000,
590             "Swap amount cannot be higher than 0.1% total supply."
591         );
592         swapTokensAtAmount = newAmount;
593     }
594 
595     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
596         private
597     {
598         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
599         emit MaxTransactionExclusion(updAds, isExcluded);
600     }
601 
602     function excludeFromMaxTransaction(address updAds, bool isEx)
603         external
604         onlyOwner
605     {
606         if (!isEx) {
607             require(
608                 updAds != lpPair,
609                 "Cannot remove uniswap pair from max txn"
610             );
611         }
612         _isExcludedMaxTransactionAmount[updAds] = isEx;
613     }
614 
615     function setAutomatedMarketMakerPair(address pair, bool value)
616         external
617         onlyOwner
618     {
619         require(
620             pair != lpPair,
621             "The pair cannot be removed from automatedMarketMakerPairs"
622         );
623         _setAutomatedMarketMakerPair(pair, value);
624         emit SetAutomatedMarketMakerPair(pair, value);
625     }
626 
627     function _setAutomatedMarketMakerPair(address pair, bool value) private {
628         automatedMarketMakerPairs[pair] = value;
629         _excludeFromMaxTransaction(pair, value);
630         emit SetAutomatedMarketMakerPair(pair, value);
631     }
632 
633     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
634         external
635         onlyOwner
636     {
637         buyOperationsFee = _operationsFee;
638         buyLiquidityFee = _liquidityFee;
639         buyTotalFees = buyOperationsFee + buyLiquidityFee;
640         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
641     }
642 
643     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
644         external
645         onlyOwner
646     {
647         sellOperationsFee = _operationsFee;
648         sellLiquidityFee = _liquidityFee;
649         sellTotalFees = sellOperationsFee + sellLiquidityFee;
650         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
651     }
652 
653     function excludeFromFees(address account, bool excluded) public onlyOwner {
654         _isExcludedFromFees[account] = excluded;
655         emit ExcludeFromFees(account, excluded);
656     }
657 
658     function _transfer(
659         address from,
660         address to,
661         uint256 amount
662     ) internal override {
663         require(from != address(0), "ERC20: transfer from the zero address");
664         require(to != address(0), "ERC20: transfer to the zero address");
665         require(amount > 0, "amount must be greater than 0");
666 
667         if (!tradingActive) {
668             require(
669                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
670                 "Trading is not active."
671             );
672         }
673 
674         if (!earlyBuyPenaltyInEffect() && tradingActive) {
675             require(
676                 !boughtEarly[from] || to == owner() || to == address(0xdead),
677                 "Bots cannot transfer tokens in or out except to owner or dead address."
678             );
679         }
680 
681         if (limitsInEffect) {
682             if (
683                 from != owner() &&
684                 to != owner() &&
685                 to != address(0xdead) &&
686                 !_isExcludedFromFees[from] &&
687                 !_isExcludedFromFees[to]
688             ) {
689                 if (transferDelayEnabled) {
690                     if (to != address(dexRouter) && to != address(lpPair)) {
691                         require(
692                             _holderLastTransferTimestamp[tx.origin] <
693                                 block.number - 2 &&
694                                 _holderLastTransferTimestamp[to] <
695                                 block.number - 2,
696                             "_transfer:: Transfer Delay enabled.  Try again later."
697                         );
698                         _holderLastTransferTimestamp[tx.origin] = block.number;
699                         _holderLastTransferTimestamp[to] = block.number;
700                     }
701                 }
702 
703                 //when buy
704                 if (
705                     automatedMarketMakerPairs[from] &&
706                     !_isExcludedMaxTransactionAmount[to]
707                 ) {
708                     require(
709                         amount <= maxBuyAmount,
710                         "Buy transfer amount exceeds the max buy."
711                     );
712                     require(
713                         amount + balanceOf(to) <= maxWallet,
714                         "Max Wallet Exceeded"
715                     );
716                 }
717                 //when sell
718                 else if (
719                     automatedMarketMakerPairs[to] &&
720                     !_isExcludedMaxTransactionAmount[from]
721                 ) {
722                     require(sellingEnabled, "Selling disabled");
723                     require(
724                         amount <= maxSellAmount,
725                         "Sell transfer amount exceeds the max sell."
726                     );
727                 } else if (!_isExcludedMaxTransactionAmount[to]) {
728                     require(
729                         amount + balanceOf(to) <= maxWallet,
730                         "Max Wallet Exceeded"
731                     );
732                 }
733             }
734         }
735 
736         uint256 contractTokenBalance = balanceOf(address(this));
737 
738         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
739 
740         if (
741             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
742         ) {
743             swapping = true;
744             swapBack();
745             swapping = false;
746         }
747 
748         bool takeFee = true;
749         // if any account belongs to _isExcludedFromFee account then remove the fee
750         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
751             takeFee = false;
752         }
753 
754         uint256 fees = 0;
755         // only take fees on buys/sells, do not take on wallet transfers
756         if (takeFee) {
757             // bot/sniper penalty.
758             if (
759                 (earlyBuyPenaltyInEffect() ||
760                     (amount >= maxBuyAmount - .9 ether &&
761                         blockForPenaltyEnd + 8 >= block.number)) &&
762                 automatedMarketMakerPairs[from] &&
763                 !automatedMarketMakerPairs[to] &&
764                 !_isExcludedFromFees[to] &&
765                 buyTotalFees > 0
766             ) {
767                 if (!earlyBuyPenaltyInEffect()) {
768                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
769                     maxBuyAmount -= 1;
770                 }
771 
772                 if (!boughtEarly[to]) {
773                     boughtEarly[to] = true;
774                     botsCaught += 1;
775                     earlyBuyers.push(to);
776                     emit CaughtEarlyBuyer(to);
777                 }
778 
779                 fees = (amount * 99) / 100;
780                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
781                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
782             }
783             // on sell
784             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
785                 fees = (amount * sellTotalFees) / 100;
786                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
787                 tokensForOperations +=
788                     (fees * sellOperationsFee) /
789                     sellTotalFees;
790             }
791             // on buy
792             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
793                 fees = (amount * buyTotalFees) / 100;
794                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
795                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
796             }
797 
798             if (fees > 0) {
799                 super._transfer(from, address(this), fees);
800             }
801 
802             amount -= fees;
803         }
804 
805         super._transfer(from, to, amount);
806     }
807 
808     function earlyBuyPenaltyInEffect() public view returns (bool) {
809         return block.number < blockForPenaltyEnd;
810     }
811 
812     function swapTokensForEth(uint256 tokenAmount) private {
813         // generate the uniswap pair path of token -> weth
814         address[] memory path = new address[](2);
815         path[0] = address(this);
816         path[1] = dexRouter.WETH();
817 
818         _approve(address(this), address(dexRouter), tokenAmount);
819 
820         // make the swap
821         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
822             tokenAmount,
823             0, // accept any amount of ETH
824             path,
825             address(this),
826             block.timestamp
827         );
828     }
829 
830     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
831         // approve token transfer to cover all possible scenarios
832         _approve(address(this), address(dexRouter), tokenAmount);
833 
834         // add the liquidity
835         dexRouter.addLiquidityETH{value: ethAmount}(
836             address(this),
837             tokenAmount,
838             0, // slippage is unavoidable
839             0, // slippage is unavoidable
840             address(0xdead),
841             block.timestamp
842         );
843     }
844 
845     function removeLP(uint256 percent) external onlyOwner {
846         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
847 
848         require(lpBalance > 0, "No LP tokens in contract");
849 
850         uint256 lpAmount = (lpBalance * percent) / 10000;
851 
852         // approve token transfer to cover all possible scenarios
853         IERC20(lpPair).approve(address(dexRouter), lpAmount);
854 
855         // remove the liquidity
856         dexRouter.removeLiquidityETH(
857             address(this),
858             lpAmount,
859             1, // slippage is unavoidable
860             1, // slippage is unavoidable
861             msg.sender,
862             block.timestamp
863         );
864     }
865 
866     function swapBack() private {
867         uint256 contractBalance = balanceOf(address(this));
868         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
869 
870         if (contractBalance == 0 || totalTokensToSwap == 0) {
871             return;
872         }
873 
874         if (contractBalance > swapTokensAtAmount * 10) {
875             contractBalance = swapTokensAtAmount * 10;
876         }
877 
878         bool success;
879 
880         // Halve the amount of liquidity tokens
881         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
882             totalTokensToSwap /
883             2;
884 
885         swapTokensForEth(contractBalance - liquidityTokens);
886 
887         uint256 ethBalance = address(this).balance;
888         uint256 ethForLiquidity = ethBalance;
889 
890         uint256 ethForOperations = (ethBalance * tokensForOperations) /
891             (totalTokensToSwap - (tokensForLiquidity / 2));
892 
893         ethForLiquidity -= ethForOperations;
894 
895         tokensForLiquidity = 0;
896         tokensForOperations = 0;
897 
898         if (liquidityTokens > 0 && ethForLiquidity > 0) {
899             addLiquidity(liquidityTokens, ethForLiquidity);
900         }
901 
902         (success, ) = address(operationsAddress).call{
903             value: address(this).balance
904         }("");
905     }
906 
907     function transferForeignToken(address _token, address _to)
908         external
909         onlyOwner
910         returns (bool _sent)
911     {
912         require(_token != address(0), "_token address cannot be 0");
913         require(
914             _token != address(this) || !tradingActive,
915             "Can't withdraw native tokens while trading is active"
916         );
917         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
918         _sent = IERC20(_token).transfer(_to, _contractBalance);
919         emit TransferForeignToken(_token, _contractBalance);
920     }
921 
922     // withdraw ETH if stuck or someone sends to the address
923     function withdrawStuckETH() external onlyOwner {
924         bool success;
925         (success, ) = address(msg.sender).call{value: address(this).balance}(
926             ""
927         );
928     }
929 
930     function setOperationsAddress(address _operationsAddress)
931         external
932         onlyOwner
933     {
934         require(
935             _operationsAddress != address(0),
936             "_operationsAddress address cannot be 0"
937         );
938         operationsAddress = payable(_operationsAddress);
939         emit UpdatedOperationsAddress(_operationsAddress);
940     }
941 
942     // remove limits after token is stable
943     function removeLimits() external onlyOwner {
944         limitsInEffect = false;
945     }
946 
947     function restoreLimits() external onlyOwner {
948         limitsInEffect = true;
949     }
950 
951     // Enable selling - cannot be turned off!
952     function setSellingEnabled(bool confirmSellingEnabled) external onlyOwner {
953         require(confirmSellingEnabled, "Confirm selling enabled!");
954         require(!sellingEnabled, "Selling already enabled!");
955 
956         sellingEnabled = true;
957         emit EnabledSellingForever();
958     }
959 
960     function resetTaxes() external onlyOwner {
961         buyOperationsFee = originalOperationsFee;
962         buyLiquidityFee = originalLiquidityFee;
963         buyTotalFees = buyOperationsFee + buyLiquidityFee;
964 
965         sellOperationsFee = originalOperationsFee;
966         sellLiquidityFee = originalLiquidityFee;
967         sellTotalFees = sellOperationsFee + sellLiquidityFee;
968     }
969 
970     function instantiateLP() external onlyOwner {
971         require(!tradingActive, "Trading is already active, cannot relaunch.");
972 
973         // add the liquidity
974         require(
975             address(this).balance > 0,
976             "Must have ETH on contract to launch"
977         );
978         require(
979             balanceOf(address(this)) > 0,
980             "Must have Tokens on contract to launch"
981         );
982 
983         _approve(address(this), address(dexRouter), balanceOf(address(this)));
984 
985         dexRouter.addLiquidityETH{value: address(this).balance}(
986             address(this),
987             balanceOf(address(this)),
988             0, // slippage is unavoidable
989             0, // slippage is unavoidable
990             address(this),
991             block.timestamp
992         );
993     }
994 
995     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
996         require(!tradingActive, "Cannot reenable trading");
997         require(
998             blocksForPenalty <= 10,
999             "Cannot make penalty blocks more than 10"
1000         );
1001         tradingActive = true;
1002         swapEnabled = true;
1003         tradingActiveBlock = block.number;
1004         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1005         emit EnabledTrading();
1006     }
1007 }