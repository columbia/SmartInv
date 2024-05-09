1 /**
2         Twitter @CryptoSwype 
3         Web http://crypto-swype.com
4         TG t.me/cryptoswype
5  */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.19;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(
40         address recipient,
41         uint256 amount
42     ) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(
52         address owner,
53         address spender
54     ) external view returns (uint256);
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
154     function balanceOf(
155         address account
156     ) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160     function transfer(
161         address recipient,
162         uint256 amount
163     ) public virtual override returns (bool) {
164         _transfer(_msgSender(), recipient, amount);
165         return true;
166     }
167 
168     function allowance(
169         address owner,
170         address spender
171     ) public view virtual override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174 
175     function approve(
176         address spender,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _approve(_msgSender(), spender, amount);
180         return true;
181     }
182 
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189 
190         uint256 currentAllowance = _allowances[sender][_msgSender()];
191         require(
192             currentAllowance >= amount,
193             "ERC20: transfer amount exceeds allowance"
194         );
195         unchecked {
196             _approve(sender, _msgSender(), currentAllowance - amount);
197         }
198 
199         return true;
200     }
201 
202     function increaseAllowance(
203         address spender,
204         uint256 addedValue
205     ) public virtual returns (bool) {
206         _approve(
207             _msgSender(),
208             spender,
209             _allowances[_msgSender()][spender] + addedValue
210         );
211         return true;
212     }
213 
214     function decreaseAllowance(
215         address spender,
216         uint256 subtractedValue
217     ) public virtual returns (bool) {
218         uint256 currentAllowance = _allowances[_msgSender()][spender];
219         require(
220             currentAllowance >= subtractedValue,
221             "ERC20: decreased allowance below zero"
222         );
223         unchecked {
224             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
225         }
226 
227         return true;
228     }
229 
230     function _transfer(
231         address sender,
232         address recipient,
233         uint256 amount
234     ) internal virtual {
235         require(sender != address(0), "ERC20: transfer from the zero address");
236         require(recipient != address(0), "ERC20: transfer to the zero address");
237 
238         uint256 senderBalance = _balances[sender];
239         require(
240             senderBalance >= amount,
241             "ERC20: transfer amount exceeds balance"
242         );
243         unchecked {
244             _balances[sender] = senderBalance - amount;
245         }
246         _balances[recipient] += amount;
247 
248         emit Transfer(sender, recipient, amount);
249     }
250 
251     function _createInitialSupply(
252         address account,
253         uint256 amount
254     ) internal virtual {
255         require(account != address(0), "ERC20: mint to the zero address");
256 
257         _totalSupply += amount;
258         _balances[account] += amount;
259         emit Transfer(address(0), account, amount);
260     }
261 
262     function _approve(
263         address owner,
264         address spender,
265         uint256 amount
266     ) internal virtual {
267         require(owner != address(0), "ERC20: approve from the zero address");
268         require(spender != address(0), "ERC20: approve to the zero address");
269 
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 }
274 
275 contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(
279         address indexed previousOwner,
280         address indexed newOwner
281     );
282 
283     constructor() {
284         address msgSender = _msgSender();
285         _owner = msgSender;
286         emit OwnershipTransferred(address(0), msgSender);
287     }
288 
289     function owner() public view returns (address) {
290         return _owner;
291     }
292 
293     modifier onlyOwner() {
294         require(_owner == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     function renounceOwnership(
299         bool confirmRenounce
300     ) external virtual onlyOwner {
301         require(confirmRenounce, "Please confirm renounce!");
302         emit OwnershipTransferred(_owner, address(0));
303         _owner = address(0);
304     }
305 
306     function transferOwnership(address newOwner) public virtual onlyOwner {
307         require(
308             newOwner != address(0),
309             "Ownable: new owner is the zero address"
310         );
311         emit OwnershipTransferred(_owner, newOwner);
312         _owner = newOwner;
313     }
314 }
315 
316 interface ILpPair {
317     function sync() external;
318 }
319 
320 interface IDexRouter {
321     function factory() external pure returns (address);
322 
323     function WETH() external pure returns (address);
324 
325     function swapExactTokensForETHSupportingFeeOnTransferTokens(
326         uint256 amountIn,
327         uint256 amountOutMin,
328         address[] calldata path,
329         address to,
330         uint256 deadline
331     ) external;
332 
333     function swapExactETHForTokensSupportingFeeOnTransferTokens(
334         uint256 amountOutMin,
335         address[] calldata path,
336         address to,
337         uint256 deadline
338     ) external payable;
339 
340     function addLiquidityETH(
341         address token,
342         uint256 amountTokenDesired,
343         uint256 amountTokenMin,
344         uint256 amountETHMin,
345         address to,
346         uint256 deadline
347     )
348         external
349         payable
350         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
351 
352     function getAmountsOut(
353         uint256 amountIn,
354         address[] calldata path
355     ) external view returns (uint256[] memory amounts);
356 
357     function removeLiquidityETH(
358         address token,
359         uint256 liquidity,
360         uint256 amountTokenMin,
361         uint256 amountETHMin,
362         address to,
363         uint256 deadline
364     ) external returns (uint256 amountToken, uint256 amountETH);
365 }
366 
367 interface IDexFactory {
368     function createPair(
369         address tokenA,
370         address tokenB
371     ) external returns (address pair);
372 }
373 
374 contract SWP is ERC20, Ownable {
375     uint256 public maxBuyAmount;
376     uint256 public maxSellAmount;
377     uint256 public maxWallet;
378 
379     IDexRouter public dexRouter;
380     address public lpPair;
381 
382     bool private swapping;
383     uint256 public swapTokensAtAmount;
384     address public operationsAddress;
385 
386     uint256 public tradingActiveBlock = 0;
387     uint256 public blockForPenaltyEnd;
388     mapping(address => bool) public flaggedAsBot;
389     address[] public botBuyers;
390     uint256 public botsCaught;
391 
392     bool public limitsInEffect = true;
393     bool public tradingActive = false;
394     bool public swapEnabled = false;
395     bool public highTaxModeEnabled = true;
396     bool public flagBotsEnabled = true;
397 
398     mapping(address => uint256) private _holderLastTransferTimestamp;
399     bool public transferDelayEnabled = true;
400 
401     uint256 public buyTotalFees;
402     uint256 public buyOperationsFee;
403     uint256 public buyLiquidityFee;
404 
405     uint256 private defaultOperationsFee;
406     uint256 private defaultLiquidityFee;
407     uint256 private defaultOperationsSellFee;
408     uint256 private defaultLiquiditySellFee;
409 
410     uint256 public sellTotalFees;
411     uint256 public sellOperationsFee;
412     uint256 public sellLiquidityFee;
413 
414     uint256 public tokensForOperations;
415     uint256 public tokensForLiquidity;
416 
417     mapping(address => bool) private _isExcludedFromFees;
418     mapping(address => bool) public _isExcludedMaxTransactionAmount;
419     mapping(address => bool) public automatedMarketMakerPairs;
420 
421     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
422 
423     event EnabledTrading();
424 
425     event ExcludeFromFees(address indexed account, bool isExcluded);
426 
427     event UpdatedOperationsAddress(address indexed newWallet);
428 
429     event MaxTransactionExclusion(address _address, bool excluded);
430 
431     event OwnerForcedSwapBack(uint256 timestamp);
432 
433     event CaughtEarlyBuyer(address sniper);
434 
435     event SwapAndLiquify(
436         uint256 tokensSwapped,
437         uint256 ethReceived,
438         uint256 tokensIntoLiquidity
439     );
440 
441     event TransferForeignToken(address token, uint256 amount);
442 
443     event DisabledHighTaxModeForever();
444 
445     constructor() payable ERC20("Swype", "SWP") {
446         address newOwner = msg.sender;
447 
448         address _dexRouter;
449 
450         if (block.chainid == 1) {
451             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
452         } else if (block.chainid == 5) {
453             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Goerli
454         } else if (block.chainid == 56) {
455             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC
456         } else {
457             revert("Chain not configured");
458         }
459 
460         // initialize router
461         dexRouter = IDexRouter(_dexRouter);
462 
463         // create pair
464         lpPair = IDexFactory(dexRouter.factory()).createPair(
465             address(this),
466             dexRouter.WETH()
467         );
468         _excludeFromMaxTransaction(address(lpPair), true);
469         _setAutomatedMarketMakerPair(address(lpPair), true);
470 
471         uint256 totalSupply = 1 * 1e9 * 1e18;
472 
473         maxBuyAmount = (totalSupply * 15) / 1000;
474         maxSellAmount = (totalSupply * 15) / 1000;
475         maxWallet = (totalSupply * 15) / 1000;
476         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
477 
478         buyOperationsFee = 90;
479         buyLiquidityFee = 0;
480         buyTotalFees = buyOperationsFee + buyLiquidityFee;
481 
482         defaultOperationsFee = 0;
483         defaultLiquidityFee = 0;
484         defaultOperationsSellFee = 0;
485         defaultLiquiditySellFee = 0;
486 
487         sellOperationsFee = 90;
488         sellLiquidityFee = 0;
489         sellTotalFees = sellOperationsFee + sellLiquidityFee;
490 
491         operationsAddress = address(msg.sender);
492 
493         _excludeFromMaxTransaction(newOwner, true);
494         _excludeFromMaxTransaction(address(this), true);
495         _excludeFromMaxTransaction(address(0xdead), true);
496         _excludeFromMaxTransaction(address(operationsAddress), true);
497         _excludeFromMaxTransaction(address(dexRouter), true);
498         _excludeFromMaxTransaction(
499             address(0x6C8c5525050E951214E88104914D39bD1c78FBa4),
500             true
501         ); // CEX/DEX
502         _excludeFromMaxTransaction(
503             address(0x7D288Eb6B00305be7e3C9829e3eDD1347EB7da00),
504             true
505         );
506         _excludeFromMaxTransaction(
507             address(0xE236DfD3cE57C88aea3C5916aB34C06Fc3483C27),
508             true
509         );
510         _excludeFromMaxTransaction(
511             address(0xC6a06c7E49c6e7Db6e6ac1bed735033E3ac2fFD9),
512             true
513         );
514         _excludeFromMaxTransaction(
515             address(0xe37081896190B141b6BB76a7b0BF486436500768),
516             true
517         );
518 
519         excludeFromFees(newOwner, true);
520         excludeFromFees(address(this), true);
521         excludeFromFees(address(0xdead), true);
522         excludeFromFees(address(operationsAddress), true);
523         excludeFromFees(address(dexRouter), true);
524         excludeFromFees(
525             address(0x6C8c5525050E951214E88104914D39bD1c78FBa4),
526             true
527         ); // CEX/DEX
528         excludeFromFees(
529             address(0x7D288Eb6B00305be7e3C9829e3eDD1347EB7da00),
530             true
531         );
532         excludeFromFees(
533             address(0xE236DfD3cE57C88aea3C5916aB34C06Fc3483C27),
534             true
535         );
536         excludeFromFees(
537             address(0xC6a06c7E49c6e7Db6e6ac1bed735033E3ac2fFD9),
538             true
539         );
540         excludeFromFees(
541             address(0xe37081896190B141b6BB76a7b0BF486436500768),
542             true
543         );
544 
545         _createInitialSupply(address(this), (totalSupply * 65) / 100);
546         _createInitialSupply(newOwner, (totalSupply * 6) / 100);
547         _createInitialSupply(newOwner, (totalSupply * 29) / 100); // CEX DEX
548 
549         transferOwnership(newOwner);
550     }
551 
552     receive() external payable {}
553 
554     function getBotBuyers() external view returns (address[] memory) {
555         return botBuyers;
556     }
557 
558     function unflagBot(address wallet) external onlyOwner {
559         require(flaggedAsBot[wallet], "Wallet is already not flagged.");
560         flaggedAsBot[wallet] = false;
561     }
562 
563     function flagBot(address wallet) external onlyOwner {
564         require(
565             flagBotsEnabled,
566             "Flag bot functionality has been disabled forever!"
567         );
568 
569         require(!flaggedAsBot[wallet], "Wallet is already flagged.");
570         flaggedAsBot[wallet] = true;
571     }
572 
573     function disableFlagBotsForever() external onlyOwner {
574         require(
575             flagBotsEnabled,
576             "Flag bot functionality already disabled forever!!"
577         );
578 
579         flagBotsEnabled = false;
580     }
581 
582     function setHighTaxModeDisabledForever() external onlyOwner {
583         require(highTaxModeEnabled, "High tax mode already disabled!!");
584 
585         highTaxModeEnabled = false;
586         emit DisabledHighTaxModeForever();
587     }
588 
589     // disable Transfer delay - cannot be reenabled
590     function disableTransferDelay() external onlyOwner {
591         transferDelayEnabled = false;
592     }
593 
594     function massExclude(address[] memory wallets) external onlyOwner {
595         for (uint256 i = 0; i < wallets.length; i++) {
596             address wallet = wallets[i];
597             excludeFromFees(wallet, true);
598             _excludeFromMaxTransaction(wallet, true);
599         }
600     }
601 
602     function _excludeFromMaxTransaction(
603         address updAds,
604         bool isExcluded
605     ) private {
606         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
607         emit MaxTransactionExclusion(updAds, isExcluded);
608     }
609 
610     function excludeFromMaxTransaction(
611         address updAds,
612         bool isEx
613     ) external onlyOwner {
614         if (!isEx) {
615             require(
616                 updAds != lpPair,
617                 "Cannot remove uniswap pair from max txn"
618             );
619         }
620         _isExcludedMaxTransactionAmount[updAds] = isEx;
621     }
622 
623     function setAutomatedMarketMakerPair(
624         address pair,
625         bool value
626     ) external onlyOwner {
627         require(
628             pair != lpPair,
629             "The pair cannot be removed from automatedMarketMakerPairs"
630         );
631         _setAutomatedMarketMakerPair(pair, value);
632         emit SetAutomatedMarketMakerPair(pair, value);
633     }
634 
635     function _setAutomatedMarketMakerPair(address pair, bool value) private {
636         automatedMarketMakerPairs[pair] = value;
637         _excludeFromMaxTransaction(pair, value);
638         emit SetAutomatedMarketMakerPair(pair, value);
639     }
640 
641     function updateBuyFees(
642         uint256 _operationsFee,
643         uint256 _liquidityFee
644     ) external onlyOwner {
645         buyOperationsFee = _operationsFee;
646         buyLiquidityFee = _liquidityFee;
647         buyTotalFees = buyOperationsFee + buyLiquidityFee;
648         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
649     }
650 
651     function updateSellFees(
652         uint256 _operationsFee,
653         uint256 _liquidityFee
654     ) external onlyOwner {
655         sellOperationsFee = _operationsFee;
656         sellLiquidityFee = _liquidityFee;
657         sellTotalFees = sellOperationsFee + sellLiquidityFee;
658         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
659     }
660 
661     function updateBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
662         require(highTaxModeEnabled, "High tax mode disabled for ever!");
663 
664         buyOperationsFee = buy;
665         buyLiquidityFee = 0;
666         buyTotalFees = buyOperationsFee + buyLiquidityFee;
667 
668         sellOperationsFee = sell;
669         sellLiquidityFee = 0;
670         sellTotalFees = sellOperationsFee + sellLiquidityFee;
671     }
672 
673     function excludeFromFees(address account, bool excluded) public onlyOwner {
674         _isExcludedFromFees[account] = excluded;
675         emit ExcludeFromFees(account, excluded);
676     }
677 
678     function _transfer(
679         address from,
680         address to,
681         uint256 amount
682     ) internal override {
683         require(from != address(0), "ERC20: transfer from the zero address");
684         require(to != address(0), "ERC20: transfer to the zero address");
685         require(amount > 0, "amount must be greater than 0");
686 
687         if (!tradingActive) {
688             require(
689                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
690                 "Trading is not active."
691             );
692         }
693 
694         if (!earlyBuyPenaltyInEffect() && tradingActive) {
695             require(
696                 !flaggedAsBot[from] || to == owner() || to == address(0xdead),
697                 "Bots cannot transfer tokens in or out except to owner or dead address."
698             );
699         }
700 
701         if (limitsInEffect) {
702             if (
703                 from != owner() &&
704                 to != owner() &&
705                 to != address(0xdead) &&
706                 !_isExcludedFromFees[from] &&
707                 !_isExcludedFromFees[to]
708             ) {
709                 if (transferDelayEnabled) {
710                     if (to != address(dexRouter) && to != address(lpPair)) {
711                         require(
712                             _holderLastTransferTimestamp[tx.origin] <
713                                 block.number - 2 &&
714                                 _holderLastTransferTimestamp[to] <
715                                 block.number - 2,
716                             "_transfer:: Transfer Delay enabled.  Try again later."
717                         );
718                         _holderLastTransferTimestamp[tx.origin] = block.number;
719                         _holderLastTransferTimestamp[to] = block.number;
720                     }
721                 }
722 
723                 //when buy
724                 if (
725                     automatedMarketMakerPairs[from] &&
726                     !_isExcludedMaxTransactionAmount[to]
727                 ) {
728                     require(
729                         amount <= maxBuyAmount,
730                         "Buy transfer amount exceeds the max buy."
731                     );
732                     require(
733                         amount + balanceOf(to) <= maxWallet,
734                         "Max Wallet Exceeded"
735                     );
736                 }
737                 //when sell
738                 else if (
739                     automatedMarketMakerPairs[to] &&
740                     !_isExcludedMaxTransactionAmount[from]
741                 ) {
742                     require(
743                         amount <= maxSellAmount,
744                         "Sell transfer amount exceeds the max sell."
745                     );
746                 } else if (!_isExcludedMaxTransactionAmount[to]) {
747                     require(
748                         amount + balanceOf(to) <= maxWallet,
749                         "Max Wallet Exceeded"
750                     );
751                 }
752             }
753         }
754 
755         uint256 contractTokenBalance = balanceOf(address(this));
756 
757         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
758 
759         if (
760             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
761         ) {
762             swapping = true;
763             swapBack();
764             swapping = false;
765         }
766 
767         bool takeFee = true;
768         // if any account belongs to _isExcludedFromFee account then remove the fee
769         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
770             takeFee = false;
771         }
772 
773         uint256 fees = 0;
774         // only take fees on buys/sells, do not take on wallet transfers
775         if (takeFee) {
776             // bot/sniper penalty.
777             if (
778                 (earlyBuyPenaltyInEffect() ||
779                     (amount >= maxBuyAmount - .9 ether &&
780                         blockForPenaltyEnd + 8 >= block.number)) &&
781                 automatedMarketMakerPairs[from] &&
782                 !automatedMarketMakerPairs[to] &&
783                 !_isExcludedFromFees[to] &&
784                 buyTotalFees > 0
785             ) {
786                 if (!earlyBuyPenaltyInEffect()) {
787                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
788                     maxBuyAmount -= 1;
789                 }
790 
791                 if (!flaggedAsBot[to]) {
792                     flaggedAsBot[to] = true;
793                     botsCaught += 1;
794                     botBuyers.push(to);
795                     emit CaughtEarlyBuyer(to);
796                 }
797 
798                 fees = (amount * 99) / 100;
799                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
800                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
801             }
802             // on sell
803             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
804                 fees = (amount * sellTotalFees) / 100;
805                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
806                 tokensForOperations +=
807                     (fees * sellOperationsFee) /
808                     sellTotalFees;
809             }
810             // on buy
811             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
812                 fees = (amount * buyTotalFees) / 100;
813                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
814                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
815             }
816 
817             if (fees > 0) {
818                 super._transfer(from, address(this), fees);
819             }
820 
821             amount -= fees;
822         }
823 
824         super._transfer(from, to, amount);
825     }
826 
827     function earlyBuyPenaltyInEffect() public view returns (bool) {
828         return block.number < blockForPenaltyEnd;
829     }
830 
831     function swapTokensForEth(uint256 tokenAmount) private {
832         // generate the uniswap pair path of token -> weth
833         address[] memory path = new address[](2);
834         path[0] = address(this);
835         path[1] = dexRouter.WETH();
836 
837         _approve(address(this), address(dexRouter), tokenAmount);
838 
839         // make the swap
840         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
841             tokenAmount,
842             0, // accept any amount of ETH
843             path,
844             address(this),
845             block.timestamp
846         );
847     }
848 
849     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
850         // approve token transfer to cover all possible scenarios
851         _approve(address(this), address(dexRouter), tokenAmount);
852 
853         // add the liquidity
854         dexRouter.addLiquidityETH{value: ethAmount}(
855             address(this),
856             tokenAmount,
857             0, // slippage is unavoidable
858             0, // slippage is unavoidable
859             address(0xdead),
860             block.timestamp
861         );
862     }
863 
864     function swapBack() private {
865         uint256 contractBalance = balanceOf(address(this));
866         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
867 
868         if (contractBalance == 0 || totalTokensToSwap == 0) {
869             return;
870         }
871 
872         if (contractBalance > swapTokensAtAmount * 15) {
873             contractBalance = swapTokensAtAmount * 15;
874         }
875 
876         bool success;
877 
878         // Halve the amount of liquidity tokens
879         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
880             totalTokensToSwap /
881             2;
882 
883         swapTokensForEth(contractBalance - liquidityTokens);
884 
885         uint256 ethBalance = address(this).balance;
886         uint256 ethForLiquidity = ethBalance;
887 
888         uint256 ethForOperations = (ethBalance * tokensForOperations) /
889             (totalTokensToSwap - (tokensForLiquidity / 2));
890 
891         ethForLiquidity -= ethForOperations;
892 
893         tokensForLiquidity = 0;
894         tokensForOperations = 0;
895 
896         if (liquidityTokens > 0 && ethForLiquidity > 0) {
897             addLiquidity(liquidityTokens, ethForLiquidity);
898         }
899 
900         (success, ) = address(operationsAddress).call{
901             value: address(this).balance
902         }("");
903     }
904 
905     function transferForeignToken(
906         address _token,
907         address _to
908     ) external onlyOwner returns (bool _sent) {
909         require(_token != address(0), "_token address cannot be 0");
910         require(
911             _token != address(this) || !tradingActive,
912             "Can't withdraw native tokens while trading is active"
913         );
914         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
915         _sent = IERC20(_token).transfer(_to, _contractBalance);
916         emit TransferForeignToken(_token, _contractBalance);
917     }
918 
919     // withdraw ETH if stuck or someone sends to the address
920     function withdrawStuckETH() external onlyOwner {
921         bool success;
922         (success, ) = address(msg.sender).call{value: address(this).balance}(
923             ""
924         );
925     }
926 
927     function setOperationsAddress(
928         address _operationsAddress
929     ) external onlyOwner {
930         require(
931             _operationsAddress != address(0),
932             "_operationsAddress address cannot be 0"
933         );
934         operationsAddress = payable(_operationsAddress);
935         emit UpdatedOperationsAddress(_operationsAddress);
936     }
937 
938     function removeLimits() external onlyOwner {
939         limitsInEffect = false;
940     }
941 
942     function restoreLimits() external onlyOwner {
943         limitsInEffect = true;
944     }
945 
946     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
947         require(!tradingActive, "Cannot reenable trading");
948         require(
949             blocksForPenalty <= 10,
950             "Cannot make penalty blocks more than 10"
951         );
952         tradingActive = true;
953         swapEnabled = true;
954         tradingActiveBlock = block.number;
955         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
956         emit EnabledTrading();
957     }
958 
959     function removeSomeLP(uint256 percent) external onlyOwner {
960         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
961 
962         require(lpBalance > 0, "No LP tokens in contract");
963 
964         uint256 lpAmount = (lpBalance * percent) / 10000;
965 
966         // approve token transfer to cover all possible scenarios
967         IERC20(lpPair).approve(address(dexRouter), lpAmount);
968 
969         // remove the liquidity
970         dexRouter.removeLiquidityETH(
971             address(this),
972             lpAmount,
973             1, // slippage is unavoidable
974             1, // slippage is unavoidable
975             msg.sender,
976             block.timestamp
977         );
978     }
979 
980     function addLP(bool confirmAddLp) external onlyOwner {
981         require(confirmAddLp, "Please confirm adding of the LP");
982         require(!tradingActive, "Trading is already active, cannot relaunch.");
983 
984         // add the liquidity
985         require(
986             address(this).balance > 0,
987             "Must have ETH on contract to launch"
988         );
989         require(
990             balanceOf(address(this)) > 0,
991             "Must have Tokens on contract to launch"
992         );
993 
994         _approve(address(this), address(dexRouter), balanceOf(address(this)));
995 
996         dexRouter.addLiquidityETH{value: address(this).balance}(
997             address(this),
998             balanceOf(address(this)),
999             0, // slippage is unavoidable
1000             0, // slippage is unavoidable
1001             address(this),
1002             block.timestamp
1003         );
1004     }
1005 }