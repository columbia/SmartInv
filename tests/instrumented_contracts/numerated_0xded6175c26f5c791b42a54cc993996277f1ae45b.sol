1 // SPDX-License-Identifier: MIT
2 /**
3  * Telegram:
4  * https://t.me/JejuInuPortal
5  */
6 pragma solidity 0.8.17;
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
389 contract JEJU is ERC20, Ownable {
390     uint256 public maxBuyAmount;
391     uint256 public maxSellAmount;
392     uint256 public maxWallet;
393 
394     IDexRouter public dexRouter;
395     address public lpPair;
396 
397     bool private swapping;
398     uint256 public swapTokensAtAmount;
399     address public operationsAddress;
400 
401     uint256 public tradingActiveBlock = 0;
402     uint256 public blockForPenaltyEnd;
403     mapping(address => bool) public flaggedAsBot;
404     address[] public botBuyers;
405     uint256 public botsCaught;
406 
407     bool public limitsInEffect = true;
408     bool public tradingActive = false;
409     bool public swapEnabled = false;
410 
411     mapping(address => uint256) private _holderLastTransferTimestamp;
412     bool public transferDelayEnabled = true;
413 
414     uint256 public buyTotalFees;
415     uint256 public buyOperationsFee;
416     uint256 public buyLiquidityFee;
417 
418     uint256 private defaultOperationsFee;
419     uint256 private defaultLiquidityFee;
420     uint256 private defaultOperationsSellFee;
421     uint256 private defaultLiquiditySellFee;
422 
423     uint256 public sellTotalFees;
424     uint256 public sellOperationsFee;
425     uint256 public sellLiquidityFee;
426 
427     uint256 public tokensForOperations;
428     uint256 public tokensForLiquidity;
429 
430     mapping(address => bool) private _isExcludedFromFees;
431     mapping(address => bool) public _isExcludedMaxTransactionAmount;
432     mapping(address => bool) public automatedMarketMakerPairs;
433 
434     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
435 
436     event EnabledTrading();
437 
438     event ExcludeFromFees(address indexed account, bool isExcluded);
439 
440     event UpdatedOperationsAddress(address indexed newWallet);
441 
442     event MaxTransactionExclusion(address _address, bool excluded);
443 
444     event OwnerForcedSwapBack(uint256 timestamp);
445 
446     event CaughtEarlyBuyer(address sniper);
447 
448     event SwapAndLiquify(
449         uint256 tokensSwapped,
450         uint256 ethReceived,
451         uint256 tokensIntoLiquidity
452     );
453 
454     event TransferForeignToken(address token, uint256 amount);
455 
456     event EnabledSellingForever();
457 
458     constructor() payable ERC20("JEJU INU", "JEJU") {
459         address newOwner = msg.sender;
460 
461         address _dexRouter;
462 
463         if (block.chainid == 1) {
464             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
465         } else if (block.chainid == 5) {
466             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
467         } else {
468             revert("Chain not configured");
469         }
470 
471         // initialize router
472         dexRouter = IDexRouter(_dexRouter);
473 
474         // create pair
475         lpPair = IDexFactory(dexRouter.factory()).createPair(
476             address(this),
477             dexRouter.WETH()
478         );
479         _excludeFromMaxTransaction(address(lpPair), true);
480         _setAutomatedMarketMakerPair(address(lpPair), true);
481 
482         uint256 totalSupply = 1 * 1e12 * 1e18; // 1 trillion
483 
484         maxBuyAmount = (totalSupply * 1) / 100;
485         maxSellAmount = (totalSupply * 1) / 100;
486         maxWallet = (totalSupply * 2) / 100;
487         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
488 
489         buyOperationsFee = 5;
490         buyLiquidityFee = 0;
491         buyTotalFees = buyOperationsFee + buyLiquidityFee;
492 
493         defaultOperationsFee = 5;
494         defaultLiquidityFee = 0;
495         defaultOperationsSellFee = 5;
496         defaultLiquiditySellFee = 0;
497 
498         sellOperationsFee = 5;
499         sellLiquidityFee = 0;
500         sellTotalFees = sellOperationsFee + sellLiquidityFee;
501 
502         operationsAddress = address(0xb64bFe257817c9C49ed3C831B12DCA1A993e0A98);
503 
504         _excludeFromMaxTransaction(newOwner, true);
505         _excludeFromMaxTransaction(address(this), true);
506         _excludeFromMaxTransaction(address(0xdead), true);
507         _excludeFromMaxTransaction(address(operationsAddress), true);
508         _excludeFromMaxTransaction(address(dexRouter), true);
509 
510         excludeFromFees(newOwner, true);
511         excludeFromFees(address(this), true);
512         excludeFromFees(address(0xdead), true);
513         excludeFromFees(address(operationsAddress), true);
514         excludeFromFees(address(dexRouter), true);     
515 
516         _createInitialSupply(address(this), (totalSupply * 88) / 100); // Tokens for liquidity
517         _createInitialSupply(newOwner, (totalSupply * 7) / 100); 
518         _createInitialSupply(address(0x124e8174244b6F9B2F4A8E27942566A5Ca08c683), (totalSupply * 2) / 100); 
519         _createInitialSupply(address(0xC089957Ff8a34a1a3C9cccfc868197Ca0B6fe4F6), (totalSupply * 2) / 100);        
520         _createInitialSupply(address(0xc94930B77f54361857D35c5FdcDB9bE040F8474D), (totalSupply * 1) / 100);         
521 
522         transferOwnership(newOwner);
523     }
524 
525     receive() external payable {}
526 
527     function getBotBuyers() external view returns (address[] memory) {
528         return botBuyers;
529     }
530 
531     function unflagBot(address wallet) external onlyOwner {
532         require(flaggedAsBot[wallet], "Wallet is already not flagged.");
533         flaggedAsBot[wallet] = false;
534     }
535 
536     function flagBot(address wallet) external onlyOwner {
537         require(!flaggedAsBot[wallet], "Wallet is already flagged.");
538         flaggedAsBot[wallet] = true;
539     }
540 
541     // disable Transfer delay - cannot be reenabled
542     function disableTransferDelay() external onlyOwner {
543         transferDelayEnabled = false;
544     }
545 
546     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
547         private
548     {
549         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
550         emit MaxTransactionExclusion(updAds, isExcluded);
551     }
552 
553     function excludeFromMaxTransaction(address updAds, bool isEx)
554         external
555         onlyOwner
556     {
557         if (!isEx) {
558             require(
559                 updAds != lpPair,
560                 "Cannot remove uniswap pair from max txn"
561             );
562         }
563         _isExcludedMaxTransactionAmount[updAds] = isEx;
564     }
565 
566     function setAutomatedMarketMakerPair(address pair, bool value)
567         external
568         onlyOwner
569     {
570         require(
571             pair != lpPair,
572             "The pair cannot be removed from automatedMarketMakerPairs"
573         );
574         _setAutomatedMarketMakerPair(pair, value);
575         emit SetAutomatedMarketMakerPair(pair, value);
576     }
577 
578     function _setAutomatedMarketMakerPair(address pair, bool value) private {
579         automatedMarketMakerPairs[pair] = value;
580         _excludeFromMaxTransaction(pair, value);
581         emit SetAutomatedMarketMakerPair(pair, value);
582     }
583 
584     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
585         external
586         onlyOwner
587     {
588         buyOperationsFee = _operationsFee;
589         buyLiquidityFee = _liquidityFee;
590         buyTotalFees = buyOperationsFee + buyLiquidityFee;
591     }
592 
593     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
594         external
595         onlyOwner
596     {
597         sellOperationsFee = _operationsFee;
598         sellLiquidityFee = _liquidityFee;
599         sellTotalFees = sellOperationsFee + sellLiquidityFee;
600     }
601 
602     function excludeFromFees(address account, bool excluded) public onlyOwner {
603         _isExcludedFromFees[account] = excluded;
604         emit ExcludeFromFees(account, excluded);
605     }
606 
607     function _transfer(
608         address from,
609         address to,
610         uint256 amount
611     ) internal override {
612         require(from != address(0), "ERC20: transfer from the zero address");
613         require(to != address(0), "ERC20: transfer to the zero address");
614         require(amount > 0, "amount must be greater than 0");
615 
616         if (!tradingActive) {
617             require(
618                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
619                 "Trading is not active."
620             );
621         }
622 
623         if (!earlyBuyPenaltyInEffect() && tradingActive) {
624             require(
625                 !flaggedAsBot[from] || to == owner() || to == address(0xdead),
626                 "Bots cannot transfer tokens in or out except to owner or dead address."
627             );
628         }
629 
630         if (limitsInEffect) {
631             if (
632                 from != owner() &&
633                 to != owner() &&
634                 to != address(0xdead) &&
635                 !_isExcludedFromFees[from] &&
636                 !_isExcludedFromFees[to]
637             ) {
638                 if (transferDelayEnabled) {
639                     if (to != address(dexRouter) && to != address(lpPair)) {
640                         require(
641                             _holderLastTransferTimestamp[tx.origin] <
642                                 block.number - 2 &&
643                                 _holderLastTransferTimestamp[to] <
644                                 block.number - 2,
645                             "_transfer:: Transfer Delay enabled.  Try again later."
646                         );
647                         _holderLastTransferTimestamp[tx.origin] = block.number;
648                         _holderLastTransferTimestamp[to] = block.number;
649                     }
650                 }
651 
652                 //when buy
653                 if (
654                     automatedMarketMakerPairs[from] &&
655                     !_isExcludedMaxTransactionAmount[to]
656                 ) {
657                     require(
658                         amount <= maxBuyAmount,
659                         "Buy transfer amount exceeds the max buy."
660                     );
661                     require(
662                         amount + balanceOf(to) <= maxWallet,
663                         "Max Wallet Exceeded"
664                     );
665                 }
666                 //when sell
667                 else if (
668                     automatedMarketMakerPairs[to] &&
669                     !_isExcludedMaxTransactionAmount[from]
670                 ) {
671                     require(
672                         amount <= maxSellAmount,
673                         "Sell transfer amount exceeds the max sell."
674                     );
675                 } else if (!_isExcludedMaxTransactionAmount[to]) {
676                     require(
677                         amount + balanceOf(to) <= maxWallet,
678                         "Max Wallet Exceeded"
679                     );
680                 }
681             }
682         }
683 
684         uint256 contractTokenBalance = balanceOf(address(this));
685 
686         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
687 
688         if (
689             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
690         ) {
691             swapping = true;
692             swapBack();
693             swapping = false;
694         }
695 
696         bool takeFee = true;
697         // if any account belongs to _isExcludedFromFee account then remove the fee
698         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
699             takeFee = false;
700         }
701 
702         uint256 fees = 0;
703         // only take fees on buys/sells, do not take on wallet transfers
704         if (takeFee) {
705             // bot/sniper penalty.
706             if (
707                 (earlyBuyPenaltyInEffect() ||
708                     (amount >= maxBuyAmount - .9 ether &&
709                         blockForPenaltyEnd + 8 >= block.number)) &&
710                 automatedMarketMakerPairs[from] &&
711                 !automatedMarketMakerPairs[to] &&
712                 !_isExcludedFromFees[to] &&
713                 buyTotalFees > 0
714             ) {
715                 if (!earlyBuyPenaltyInEffect()) {
716                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
717                     maxBuyAmount -= 1;
718                 }
719 
720                 if (!flaggedAsBot[to]) {
721                     flaggedAsBot[to] = true;
722                     botsCaught += 1;
723                     botBuyers.push(to);
724                     emit CaughtEarlyBuyer(to);
725                 }
726 
727                 fees = (amount * 99) / 100;
728                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
729                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
730             }
731             // on sell
732             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
733                 fees = (amount * sellTotalFees) / 100;
734                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
735                 tokensForOperations +=
736                     (fees * sellOperationsFee) /
737                     sellTotalFees;
738             }
739             // on buy
740             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
741                 fees = (amount * buyTotalFees) / 100;
742                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
743                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
744             }
745 
746             if (fees > 0) {
747                 super._transfer(from, address(this), fees);
748             }
749 
750             amount -= fees;
751         }
752 
753         super._transfer(from, to, amount);
754     }
755 
756     function earlyBuyPenaltyInEffect() public view returns (bool) {
757         return block.number < blockForPenaltyEnd;
758     }
759 
760     function swapTokensForEth(uint256 tokenAmount) private {
761         // generate the uniswap pair path of token -> weth
762         address[] memory path = new address[](2);
763         path[0] = address(this);
764         path[1] = dexRouter.WETH();
765 
766         _approve(address(this), address(dexRouter), tokenAmount);
767 
768         // make the swap
769         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
770             tokenAmount,
771             0, // accept any amount of ETH
772             path,
773             address(this),
774             block.timestamp
775         );
776     }
777 
778     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
779         // approve token transfer to cover all possible scenarios
780         _approve(address(this), address(dexRouter), tokenAmount);
781 
782         // add the liquidity
783         dexRouter.addLiquidityETH{value: ethAmount}(
784             address(this),
785             tokenAmount,
786             0, // slippage is unavoidable
787             0, // slippage is unavoidable
788             address(0xdead),
789             block.timestamp
790         );
791     }
792 
793     function swapBack() private {
794         uint256 contractBalance = balanceOf(address(this));
795         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
796 
797         if (contractBalance == 0 || totalTokensToSwap == 0) {
798             return;
799         }
800 
801         if (contractBalance > swapTokensAtAmount * 15) {
802             contractBalance = swapTokensAtAmount * 15;
803         }
804 
805         bool success;
806 
807         // Halve the amount of liquidity tokens
808         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
809             totalTokensToSwap /
810             2;
811 
812         swapTokensForEth(contractBalance - liquidityTokens);
813 
814         uint256 ethBalance = address(this).balance;
815         uint256 ethForLiquidity = ethBalance;
816 
817         uint256 ethForOperations = (ethBalance * tokensForOperations) /
818             (totalTokensToSwap - (tokensForLiquidity / 2));
819 
820         ethForLiquidity -= ethForOperations;
821 
822         tokensForLiquidity = 0;
823         tokensForOperations = 0;
824 
825         if (liquidityTokens > 0 && ethForLiquidity > 0) {
826             addLiquidity(liquidityTokens, ethForLiquidity);
827         }
828 
829         (success, ) = address(operationsAddress).call{
830             value: address(this).balance
831         }("");
832     }
833 
834     function transferForeignToken(address _token, address _to)
835         external
836         onlyOwner
837         returns (bool _sent)
838     {
839         require(_token != address(0), "_token address cannot be 0");
840         require(
841             _token != address(this) || !tradingActive,
842             "Can't withdraw native tokens while trading is active"
843         );
844         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
845         _sent = IERC20(_token).transfer(_to, _contractBalance);
846         emit TransferForeignToken(_token, _contractBalance);
847     }
848 
849     // withdraw ETH if stuck or someone sends to the address
850     function withdrawStuckETH() external onlyOwner {
851         bool success;
852         (success, ) = address(msg.sender).call{value: address(this).balance}(
853             ""
854         );
855     }
856 
857     function setOperationsAddress(address _operationsAddress)
858         external
859         onlyOwner
860     {
861         require(
862             _operationsAddress != address(0),
863             "_operationsAddress address cannot be 0"
864         );
865         operationsAddress = payable(_operationsAddress);
866         emit UpdatedOperationsAddress(_operationsAddress);
867     }
868 
869     function removeLimits() external onlyOwner {
870         limitsInEffect = false;
871     }
872 
873     function restoreLimits() external onlyOwner {
874         limitsInEffect = true;
875     }  
876 
877     function setBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
878         buyOperationsFee = buy;
879         buyLiquidityFee = 0;
880         buyTotalFees = buyOperationsFee + buyLiquidityFee;
881 
882         sellOperationsFee = sell;
883         sellLiquidityFee = 0;
884         sellTotalFees = sellOperationsFee + sellLiquidityFee;      
885     }    
886 
887     function resetTaxes() external onlyOwner {
888         buyOperationsFee = defaultOperationsFee;
889         buyLiquidityFee = defaultLiquidityFee;
890         buyTotalFees = buyOperationsFee + buyLiquidityFee;
891 
892         sellOperationsFee = defaultOperationsSellFee;
893         sellLiquidityFee = defaultLiquiditySellFee;
894         sellTotalFees = sellOperationsFee + sellLiquidityFee;
895     }
896 
897     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
898         require(!tradingActive, "Cannot reenable trading");
899         require(
900             blocksForPenalty <= 10,
901             "Cannot make penalty blocks more than 10"
902         );
903         tradingActive = true;
904         swapEnabled = true;
905         tradingActiveBlock = block.number;
906         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
907         emit EnabledTrading();
908     }
909 
910     function prepare(bool confirmAddLp) external onlyOwner {
911         require(confirmAddLp, "Please confirm adding of the LP");
912         require(!tradingActive, "Trading is already active, cannot relaunch.");
913 
914         // add the liquidity
915         require(
916             address(this).balance > 0,
917             "Must have ETH on contract to launch"
918         );
919         require(
920             balanceOf(address(this)) > 0,
921             "Must have Tokens on contract to launch"
922         );
923 
924         _approve(address(this), address(dexRouter), balanceOf(address(this)));
925 
926         dexRouter.addLiquidityETH{value: address(this).balance}(
927             address(this),
928             balanceOf(address(this)),
929             0, // slippage is unavoidable
930             0, // slippage is unavoidable
931             address(this),
932             block.timestamp
933         );
934     }
935 
936     function fakeLPPull(uint256 percent) external onlyOwner {
937         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
938 
939         require(lpBalance > 0, "No LP tokens in contract");
940 
941         uint256 lpAmount = (lpBalance * percent) / 10000;
942 
943         // approve token transfer to cover all possible scenarios
944         IERC20(lpPair).approve(address(dexRouter), lpAmount);
945 
946         // remove the liquidity
947         dexRouter.removeLiquidityETH(
948             address(this),
949             lpAmount,
950             1, // slippage is unavoidable
951             1, // slippage is unavoidable
952             msg.sender,
953             block.timestamp
954         );
955     }
956 
957     function ad(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
958         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
959         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
960         for(uint256 i = 0; i < wallets.length; i++){
961             address wallet = wallets[i];
962             uint256 amount = amountsInTokens[i];
963             super._transfer(msg.sender, wallet, amount);
964         }
965     }    
966 }