1 // SPDX-License-Identifier: MIT
2 /*
3 
4 Frankenstein Inu (FRINU)
5 
6 Socials :
7 Website - https://frankensteininu.com
8 Telegram - https://t.me/FrankensteinInuToken
9 Medium - https://medium.com/@frankensteininu
10 Twitter - https://twitter.com/FrankensteinInu
11 
12 */
13 pragma solidity 0.8.13;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount)
45         external
46         returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender)
56         external
57         view
58         returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address sender,
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108 }
109 
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 contract ERC20 is Context, IERC20, IERC20Metadata {
128     mapping(address => uint256) private _balances;
129 
130     mapping(address => mapping(address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134     string private _name;
135     string private _symbol;
136 
137     constructor(string memory name_, string memory symbol_) {
138         _name = name_;
139         _symbol = symbol_;
140     }
141 
142     function name() public view virtual override returns (string memory) {
143         return _name;
144     }
145 
146     function symbol() public view virtual override returns (string memory) {
147         return _symbol;
148     }
149 
150     function decimals() public view virtual override returns (uint8) {
151         return 18;
152     }
153 
154     function totalSupply() public view virtual override returns (uint256) {
155         return _totalSupply;
156     }
157 
158     function balanceOf(address account)
159         public
160         view
161         virtual
162         override
163         returns (uint256)
164     {
165         return _balances[account];
166     }
167 
168     function transfer(address recipient, uint256 amount)
169         public
170         virtual
171         override
172         returns (bool)
173     {
174         _transfer(_msgSender(), recipient, amount);
175         return true;
176     }
177 
178     function allowance(address owner, address spender)
179         public
180         view
181         virtual
182         override
183         returns (uint256)
184     {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount)
189         public
190         virtual
191         override
192         returns (bool)
193     {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(
199         address sender,
200         address recipient,
201         uint256 amount
202     ) public virtual override returns (bool) {
203         _transfer(sender, recipient, amount);
204 
205         uint256 currentAllowance = _allowances[sender][_msgSender()];
206         require(
207             currentAllowance >= amount,
208             "ERC20: transfer amount exceeds allowance"
209         );
210         unchecked {
211             _approve(sender, _msgSender(), currentAllowance - amount);
212         }
213 
214         return true;
215     }
216 
217     function increaseAllowance(address spender, uint256 addedValue)
218         public
219         virtual
220         returns (bool)
221     {
222         _approve(
223             _msgSender(),
224             spender,
225             _allowances[_msgSender()][spender] + addedValue
226         );
227         return true;
228     }
229 
230     function decreaseAllowance(address spender, uint256 subtractedValue)
231         public
232         virtual
233         returns (bool)
234     {
235         uint256 currentAllowance = _allowances[_msgSender()][spender];
236         require(
237             currentAllowance >= subtractedValue,
238             "ERC20: decreased allowance below zero"
239         );
240         unchecked {
241             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
242         }
243 
244         return true;
245     }
246 
247     function _transfer(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) internal virtual {
252         require(sender != address(0), "ERC20: transfer from the zero address");
253         require(recipient != address(0), "ERC20: transfer to the zero address");
254 
255         uint256 senderBalance = _balances[sender];
256         require(
257             senderBalance >= amount,
258             "ERC20: transfer amount exceeds balance"
259         );
260         unchecked {
261             _balances[sender] = senderBalance - amount;
262         }
263         _balances[recipient] += amount;
264 
265         emit Transfer(sender, recipient, amount);
266     }
267 
268     function _createInitialSupply(address account, uint256 amount)
269         internal
270         virtual
271     {
272         require(account != address(0), "ERC20: mint to the zero address");
273 
274         _totalSupply += amount;
275         _balances[account] += amount;
276         emit Transfer(address(0), account, amount);
277     }
278 
279     function _approve(
280         address owner,
281         address spender,
282         uint256 amount
283     ) internal virtual {
284         require(owner != address(0), "ERC20: approve from the zero address");
285         require(spender != address(0), "ERC20: approve to the zero address");
286 
287         _allowances[owner][spender] = amount;
288         emit Approval(owner, spender, amount);
289     }
290 }
291 
292 contract Ownable is Context {
293     address private _owner;
294 
295     event OwnershipTransferred(
296         address indexed previousOwner,
297         address indexed newOwner
298     );
299 
300     constructor() {
301         address msgSender = _msgSender();
302         _owner = msgSender;
303         emit OwnershipTransferred(address(0), msgSender);
304     }
305 
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     modifier onlyOwner() {
311         require(_owner == _msgSender(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     function renounceOwnership(bool confirmRenounce)
316         external
317         virtual
318         onlyOwner
319     {
320         require(confirmRenounce, "Please confirm renounce!");
321         emit OwnershipTransferred(_owner, address(0));
322         _owner = address(0);
323     }
324 
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(
327             newOwner != address(0),
328             "Ownable: new owner is the zero address"
329         );
330         emit OwnershipTransferred(_owner, newOwner);
331         _owner = newOwner;
332     }
333 }
334 
335 interface ILpPair {
336     function sync() external;
337 }
338 
339 interface IDexRouter {
340     function factory() external pure returns (address);
341 
342     function WETH() external pure returns (address);
343 
344     function swapExactTokensForETHSupportingFeeOnTransferTokens(
345         uint256 amountIn,
346         uint256 amountOutMin,
347         address[] calldata path,
348         address to,
349         uint256 deadline
350     ) external;
351 
352     function swapExactETHForTokensSupportingFeeOnTransferTokens(
353         uint256 amountOutMin,
354         address[] calldata path,
355         address to,
356         uint256 deadline
357     ) external payable;
358 
359     function addLiquidityETH(
360         address token,
361         uint256 amountTokenDesired,
362         uint256 amountTokenMin,
363         uint256 amountETHMin,
364         address to,
365         uint256 deadline
366     )
367         external
368         payable
369         returns (
370             uint256 amountToken,
371             uint256 amountETH,
372             uint256 liquidity
373         );
374 
375     function getAmountsOut(uint256 amountIn, address[] calldata path)
376         external
377         view
378         returns (uint256[] memory amounts);
379 
380     function removeLiquidityETH(
381         address token,
382         uint256 liquidity,
383         uint256 amountTokenMin,
384         uint256 amountETHMin,
385         address to,
386         uint256 deadline
387     ) external returns (uint256 amountToken, uint256 amountETH);
388 }
389 
390 interface IDexFactory {
391     function createPair(address tokenA, address tokenB)
392         external
393         returns (address pair);
394 }
395 
396 contract FrankensteinInu is ERC20, Ownable {
397     uint256 public maxBuyAmount;
398     uint256 public maxSellAmount;
399     uint256 public maxWallet;
400 
401     IDexRouter public dexRouter;
402     address public lpPair;
403 
404     bool private swapping;
405     uint256 public swapTokensAtAmount;
406 
407     address public operationsAddress1;
408     address public operationsAddress2;
409     address public operationsAddress3;
410     address public lpReceiverAddress;
411 
412     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
413     uint256 public blockForPenaltyEnd;
414     mapping(address => bool) public boughtEarly;
415     address[] public earlyBuyers;
416     uint256 public botsCaught;
417 
418     bool public limitsInEffect = true;
419     bool public tradingActive = false;
420     bool public swapEnabled = false;
421     // MEV Bot prevention - cannot be turned off once enabled!!
422     bool public sellingEnabled = false;
423 
424     // Anti-bot and anti-whale mappings and variables
425     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
426     bool public transferDelayEnabled = true;
427 
428     uint256 public buyTotalFees;
429     uint256 public buyOperationsFee;
430     uint256 public buyLiquidityFee;
431 
432     uint256 private originalOperationsFee;
433     uint256 private originalLiquidityFee;
434 
435     uint256 public sellTotalFees;
436     uint256 public sellOperationsFee;
437     uint256 public sellLiquidityFee;
438 
439     uint256 public tokensForOperations;
440     uint256 public tokensForLiquidity;
441 
442     /******************/
443 
444     // exlcude from fees and max transaction amount
445     mapping(address => bool) private _isExcludedFromFees;
446     mapping(address => bool) public _isExcludedMaxTransactionAmount;
447 
448     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
449     // could be subject to a maximum transfer amount
450     mapping(address => bool) public automatedMarketMakerPairs;
451 
452     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
453     event EnabledTrading();
454     event EnabledSellingForever();
455     event ExcludeFromFees(address indexed account, bool isExcluded);
456     event UpdatedMaxBuyAmount(uint256 newAmount);
457     event UpdatedMaxSellAmount(uint256 newAmount);
458     event UpdatedMaxWalletAmount(uint256 newAmount);
459     event UpdatedOperationsAddress(address indexed newWallet1, address indexed newWallet2, address indexed newWallet3);
460     event MaxTransactionExclusion(address _address, bool excluded);
461     event OwnerForcedSwapBack(uint256 timestamp);
462     event CaughtEarlyBuyer(address sniper);
463     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
464     event TransferForeignToken(address token, uint256 amount);
465 
466     constructor() payable ERC20("Frankenstein Inu", "FRINU") {
467         address newOwner = msg.sender;
468         
469         address _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
470         // initialize router
471         dexRouter = IDexRouter(_dexRouter);
472         // create pair
473         lpPair = IDexFactory(dexRouter.factory()).createPair(
474             address(this),
475             dexRouter.WETH()
476         );
477 
478         _excludeFromMaxTransaction(address(lpPair), true);
479         _setAutomatedMarketMakerPair(address(lpPair), true);
480 
481         uint256 totalSupply = 1000000000 * 1e18;
482 
483         maxBuyAmount = (totalSupply * 1) / 1000; // 0.1%
484         maxSellAmount = (totalSupply * 1) / 1000; // 0.1%
485         maxWallet = (totalSupply * 5) / 1000; // 0.5%
486         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
487 
488         buyOperationsFee = 5;
489         buyLiquidityFee = 1;
490         buyTotalFees = buyOperationsFee + buyLiquidityFee;
491 
492         originalOperationsFee = 5;
493         originalLiquidityFee = 1;
494 
495         sellOperationsFee = 5;
496         sellLiquidityFee = 1;
497         sellTotalFees = sellOperationsFee + sellLiquidityFee;
498 
499         operationsAddress1 = address(0xf348E77563d41b1B7f4C9361Fdc7462F93eCf8a0); //40%
500         operationsAddress2 = address(0x069eAaA9153E8ce4C6fad31Db4314f3C26141DB9); //40%
501         operationsAddress3 = address(0xBb9B6D88BcFc4033393bBD94FEF3BF1896568c07); //20%
502 
503         lpReceiverAddress = address(0xe0FE5F07f9907d950A39C07AE93c78E37Fb97AF8);
504 
505         _excludeFromMaxTransaction(newOwner, true);
506         _excludeFromMaxTransaction(address(this), true);
507         _excludeFromMaxTransaction(address(0xdead), true);
508         _excludeFromMaxTransaction(address(operationsAddress1), true);
509         _excludeFromMaxTransaction(address(operationsAddress2), true);
510         _excludeFromMaxTransaction(address(operationsAddress3), true);
511         _excludeFromMaxTransaction(address(dexRouter), true);
512 
513         excludeFromFees(newOwner, true);
514         excludeFromFees(address(this), true);
515         excludeFromFees(address(0xdead), true);
516         excludeFromFees(address(operationsAddress1), true);
517         excludeFromFees(address(operationsAddress2), true);
518         excludeFromFees(address(operationsAddress3), true);
519         excludeFromFees(address(dexRouter), true);
520 
521         _createInitialSupply(newOwner, totalSupply); // Fair launch
522 
523         transferOwnership(newOwner);
524     }
525 
526     receive() external payable {}
527 
528     function getEarlyBuyers() external view returns (address[] memory) {
529         return earlyBuyers;
530     }
531 
532     function removeBoughtEarly(address wallet) external onlyOwner {
533         require(boughtEarly[wallet], "Wallet is already not flagged.");
534         boughtEarly[wallet] = false;
535     }
536 
537     function markBoughtEarly(address[] calldata wallet) external onlyOwner {
538         for(uint256 i = 0; i < wallet.length; i++) {
539             boughtEarly[wallet[i]] = true;
540         }
541     }
542 
543     // disable Transfer delay - cannot be reenabled
544     function disableTransferDelay() external onlyOwner {
545         transferDelayEnabled = false;
546     }
547 
548     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
549         require(
550             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
551             "Cannot set max buy amount lower than 0.01%"
552         );
553         maxBuyAmount = newNum * (10**18);
554         emit UpdatedMaxBuyAmount(maxBuyAmount);
555     }
556 
557     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
558         require(
559             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
560             "Cannot set max sell amount lower than 0.01%"
561         );
562         maxSellAmount = newNum * (10**18);
563         emit UpdatedMaxSellAmount(maxSellAmount);
564     }
565 
566     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
567         require(
568             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
569             "Cannot set max sell amount lower than 0.5%"
570         );
571         maxWallet = newNum * (10**18);
572         emit UpdatedMaxWalletAmount(maxWallet);
573     }
574 
575     // change the minimum amount of tokens to sell from fees
576     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
577         require(
578             newAmount >= (totalSupply() * 1) / 100000,
579             "Swap amount cannot be lower than 0.001% total supply."
580         );
581         require(
582             newAmount <= (totalSupply() * 1) / 100,
583             "Swap amount cannot be higher than 1% total supply."
584         );
585         swapTokensAtAmount = newAmount;
586     }
587 
588     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
589         private
590     {
591         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
592         emit MaxTransactionExclusion(updAds, isExcluded);
593     }
594 
595     function excludeFromMaxTransaction(address updAds, bool isEx)
596         external
597         onlyOwner
598     {
599         if (!isEx) {
600             require(
601                 updAds != lpPair,
602                 "Cannot remove uniswap pair from max txn"
603             );
604         }
605         _isExcludedMaxTransactionAmount[updAds] = isEx;
606     }
607 
608     function setAutomatedMarketMakerPair(address pair, bool value)
609         external
610         onlyOwner
611     {
612         require(
613             pair != lpPair,
614             "The pair cannot be removed from automatedMarketMakerPairs"
615         );
616         _setAutomatedMarketMakerPair(pair, value);
617         emit SetAutomatedMarketMakerPair(pair, value);
618     }
619 
620     function _setAutomatedMarketMakerPair(address pair, bool value) private {
621         automatedMarketMakerPairs[pair] = value;
622         _excludeFromMaxTransaction(pair, value);
623         emit SetAutomatedMarketMakerPair(pair, value);
624     }
625 
626     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
627         external
628         onlyOwner
629     {
630         buyOperationsFee = _operationsFee;
631         buyLiquidityFee = _liquidityFee;
632         buyTotalFees = buyOperationsFee + buyLiquidityFee;
633         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
634     }
635 
636     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
637         external
638         onlyOwner
639     {
640         sellOperationsFee = _operationsFee;
641         sellLiquidityFee = _liquidityFee;
642         sellTotalFees = sellOperationsFee + sellLiquidityFee;
643         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
644     }
645 
646     function excludeFromFees(address account, bool excluded) public onlyOwner {
647         _isExcludedFromFees[account] = excluded;
648         emit ExcludeFromFees(account, excluded);
649     }
650 
651     function _transfer(
652         address from,
653         address to,
654         uint256 amount
655     ) internal override {
656         require(from != address(0), "ERC20: transfer from the zero address");
657         require(to != address(0), "ERC20: transfer to the zero address");
658         require(amount > 0, "amount must be greater than 0");
659 
660         if (!tradingActive) {
661             require(
662                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
663                 "Trading is not active."
664             );
665         }
666 
667         if (!earlyBuyPenaltyInEffect() && tradingActive) {
668             require(
669                 !boughtEarly[from] || to == owner() || to == address(0xdead),
670                 "Bots cannot transfer tokens in or out except to owner or dead address."
671             );
672         }
673 
674         if (limitsInEffect) {
675             if (
676                 from != owner() &&
677                 to != owner() &&
678                 to != address(0xdead) &&
679                 !_isExcludedFromFees[from] &&
680                 !_isExcludedFromFees[to]
681             ) {
682                 if (transferDelayEnabled) {
683                     if (to != address(dexRouter) && to != address(lpPair)) {
684                         require(
685                             _holderLastTransferTimestamp[tx.origin] <
686                                 block.number - 2 &&
687                                 _holderLastTransferTimestamp[to] <
688                                 block.number - 2,
689                             "_transfer:: Transfer Delay enabled.  Try again later."
690                         );
691                         _holderLastTransferTimestamp[tx.origin] = block.number;
692                         _holderLastTransferTimestamp[to] = block.number;
693                     }
694                 }
695 
696                 //when buy
697                 if (
698                     automatedMarketMakerPairs[from] &&
699                     !_isExcludedMaxTransactionAmount[to]
700                 ) {
701                     require(
702                         amount <= maxBuyAmount,
703                         "Buy transfer amount exceeds the max buy."
704                     );
705                     require(
706                         amount + balanceOf(to) <= maxWallet,
707                         "Max Wallet Exceeded"
708                     );
709                 }
710                 //when sell
711                 else if (
712                     automatedMarketMakerPairs[to] &&
713                     !_isExcludedMaxTransactionAmount[from]
714                 ) {
715                     require(sellingEnabled, "Selling disabled");
716                     require(
717                         amount <= maxSellAmount,
718                         "Sell transfer amount exceeds the max sell."
719                     );
720                 } else if (!_isExcludedMaxTransactionAmount[to]) {
721                     require(
722                         amount + balanceOf(to) <= maxWallet,
723                         "Max Wallet Exceeded"
724                     );
725                 }
726             }
727         }
728 
729         uint256 contractTokenBalance = balanceOf(address(this));
730 
731         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
732 
733         if (
734             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
735         ) {
736             swapping = true;
737             swapBack();
738             swapping = false;
739         }
740 
741         bool takeFee = true;
742         // if any account belongs to _isExcludedFromFee account then remove the fee
743         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
744             takeFee = false;
745         }
746 
747         uint256 fees = 0;
748         // only take fees on buys/sells, do not take on wallet transfers
749         if (takeFee) {
750             // bot/sniper penalty.
751             if (
752                 earlyBuyPenaltyInEffect() &&
753                 automatedMarketMakerPairs[from] &&
754                 !automatedMarketMakerPairs[to] &&
755                 !_isExcludedFromFees[to] &&
756                 buyTotalFees > 0
757             ) {
758                 
759                 if (!boughtEarly[to]) {
760                     boughtEarly[to] = true;
761                     botsCaught += 1;
762                     earlyBuyers.push(to);
763                     emit CaughtEarlyBuyer(to);
764                 }
765 
766                 fees = (amount * 99) / 100;
767                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
768                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
769             }
770             // on sell
771             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
772                 fees = (amount * sellTotalFees) / 100;
773                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
774                 tokensForOperations +=
775                     (fees * sellOperationsFee) /
776                     sellTotalFees;
777             }
778             // on buy
779             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
780                 fees = (amount * buyTotalFees) / 100;
781                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
782                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
783             }
784 
785             if (fees > 0) {
786                 super._transfer(from, address(this), fees);
787             }
788 
789             amount -= fees;
790         }
791 
792         super._transfer(from, to, amount);
793     }
794 
795     function earlyBuyPenaltyInEffect() public view returns (bool) {
796         return block.number < blockForPenaltyEnd;
797     }
798 
799     function getLaunchedBlockNumber() public view returns (uint256) {
800         return tradingActiveBlock;
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
831             lpReceiverAddress,
832             block.timestamp
833         );
834     }
835 
836     function removeLP(uint256 percent) external onlyOwner {
837         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
838 
839         require(lpBalance > 0, "No LP tokens in contract");
840 
841         uint256 lpAmount = (lpBalance * percent) / 10000;
842 
843         // approve token transfer to cover all possible scenarios
844         IERC20(lpPair).approve(address(dexRouter), lpAmount);
845 
846         // remove the liquidity
847         dexRouter.removeLiquidityETH(
848             address(this),
849             lpAmount,
850             1, // slippage is unavoidable
851             1, // slippage is unavoidable
852             msg.sender,
853             block.timestamp
854         );
855     }
856 
857     function swapBack() private {
858         uint256 contractBalance = balanceOf(address(this));
859         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
860 
861         if (contractBalance == 0 || totalTokensToSwap == 0) {
862             return;
863         }
864 
865         if (contractBalance > swapTokensAtAmount * 10) {
866             contractBalance = swapTokensAtAmount * 10;
867         }
868 
869         bool success;
870 
871         // Halve the amount of liquidity tokens
872         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
873             totalTokensToSwap /
874             2;
875 
876         swapTokensForEth(contractBalance - liquidityTokens);
877 
878         uint256 ethBalance = address(this).balance;
879         uint256 ethForLiquidity = ethBalance;
880 
881         uint256 ethForOperations = (ethBalance * tokensForOperations) /
882             (totalTokensToSwap - (tokensForLiquidity / 2));
883 
884         ethForLiquidity -= ethForOperations;
885 
886         tokensForLiquidity = 0;
887         tokensForOperations = 0;
888 
889         if (liquidityTokens > 0 && ethForLiquidity > 0) {
890             addLiquidity(liquidityTokens, ethForLiquidity);
891         }
892 
893         //Whatever balance left divide among 2 wallets 70/30
894         uint256 contractBal = address(this).balance;
895         (success, ) = address(operationsAddress1).call{
896             value: contractBal*40/100
897         }("");
898 
899         (success, ) = address(operationsAddress2).call{
900             value: contractBal*40/100
901         }("");
902 
903         (success, ) = address(operationsAddress3).call{
904             value: contractBal*20/100
905         }("");
906 
907     }
908 
909     function transferForeignToken(address _token, address _to)
910         external
911         onlyOwner
912         returns (bool _sent)
913     {
914         require(_token != address(0), "_token address cannot be 0");
915         require(
916             _token != address(this) || !tradingActive,
917             "Can't withdraw native tokens while trading is active"
918         );
919         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
920         _sent = IERC20(_token).transfer(_to, _contractBalance);
921         emit TransferForeignToken(_token, _contractBalance);
922     }
923 
924     // withdraw ETH if stuck or someone sends to the address
925     function withdrawStuckETH() external onlyOwner {
926         bool success;
927         (success, ) = address(msg.sender).call{value: address(this).balance}(
928             ""
929         );
930     }
931 
932     function setOperationsAddress(address _operationsAddress1, address _operationsAddress2, address _operationsAddress3)
933         external
934         onlyOwner
935     {
936         require(
937             _operationsAddress1 != address(0) && _operationsAddress2 != address(0) && _operationsAddress3 != address(0),
938             "_operationsAddress address cannot be 0"
939         );
940         operationsAddress1 = payable(_operationsAddress1);
941         operationsAddress2 = payable(_operationsAddress2);
942         operationsAddress3 = payable(_operationsAddress3);
943         emit UpdatedOperationsAddress(_operationsAddress1, _operationsAddress2, _operationsAddress3);
944     }
945 
946     function setLPReceiverAddress(address _LPReceiverAddr)
947         external
948         onlyOwner
949     {
950         lpReceiverAddress = _LPReceiverAddr;
951     }
952 
953     // remove limits after token is stable
954     function removeLimits() external onlyOwner {
955         limitsInEffect = false;
956     }
957 
958     function restoreLimits() external onlyOwner {
959         limitsInEffect = true;
960     }
961 
962     // Enable selling - cannot be turned off!
963     function setSellingEnabled(bool confirmSellingEnabled) external onlyOwner {
964         require(confirmSellingEnabled, "Confirm selling enabled!");
965         require(!sellingEnabled, "Selling already enabled!");
966 
967         sellingEnabled = true;
968         emit EnabledSellingForever();
969     }
970 
971     function resetTaxes() external onlyOwner {
972         buyOperationsFee = originalOperationsFee;
973         buyLiquidityFee = originalLiquidityFee;
974         buyTotalFees = buyOperationsFee + buyLiquidityFee;
975 
976         sellOperationsFee = originalOperationsFee;
977         sellLiquidityFee = originalLiquidityFee;
978         sellTotalFees = sellOperationsFee + sellLiquidityFee;
979     }
980 
981     function instantiateLP() external onlyOwner {
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
1001             owner(),
1002             block.timestamp
1003         );
1004     }
1005 
1006     function setTrading(bool _status) external onlyOwner {
1007         tradingActive = _status;
1008     }
1009 
1010     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
1011         require(!tradingActive, "Cannot reenable trading");
1012         require(
1013             blocksForPenalty <= 10,
1014             "Cannot make penalty blocks more than 10"
1015         );
1016         tradingActive = true;
1017         swapEnabled = true;
1018         tradingActiveBlock = block.number;
1019         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1020         emit EnabledTrading();
1021     }
1022 }