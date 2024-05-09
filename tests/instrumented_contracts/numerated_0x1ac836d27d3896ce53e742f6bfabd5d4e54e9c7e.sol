1 // SPDX-License-Identifier: MIT
2 /*
3  * APEOLOGY - A CRYPTO PROJECT BUILT BY APES FOR THE APES.
4  *
5  * TG: https://t.me/ApeologyPortal
6  * TW: https://twitter.com/ApeologyAPED
7  * MD: https://medium.com/@apeology
8  *
9  */
10 pragma solidity 0.8.13;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount)
42         external
43         returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender)
53         external
54         view
55         returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(
101         address indexed owner,
102         address indexed spender,
103         uint256 value
104     );
105 }
106 
107 interface IERC20Metadata is IERC20 {
108     /**
109      * @dev Returns the name of the token.
110      */
111     function name() external view returns (string memory);
112 
113     /**
114      * @dev Returns the symbol of the token.
115      */
116     function symbol() external view returns (string memory);
117 
118     /**
119      * @dev Returns the decimals places of the token.
120      */
121     function decimals() external view returns (uint8);
122 }
123 
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     mapping(address => uint256) private _balances;
126 
127     mapping(address => mapping(address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string private _name;
132     string private _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account)
156         public
157         view
158         virtual
159         override
160         returns (uint256)
161     {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount)
166         public
167         virtual
168         override
169         returns (bool)
170     {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     function allowance(address owner, address spender)
176         public
177         view
178         virtual
179         override
180         returns (uint256)
181     {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount)
186         public
187         virtual
188         override
189         returns (bool)
190     {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) public virtual override returns (bool) {
200         _transfer(sender, recipient, amount);
201 
202         uint256 currentAllowance = _allowances[sender][_msgSender()];
203         require(
204             currentAllowance >= amount,
205             "ERC20: transfer amount exceeds allowance"
206         );
207         unchecked {
208             _approve(sender, _msgSender(), currentAllowance - amount);
209         }
210 
211         return true;
212     }
213 
214     function increaseAllowance(address spender, uint256 addedValue)
215         public
216         virtual
217         returns (bool)
218     {
219         _approve(
220             _msgSender(),
221             spender,
222             _allowances[_msgSender()][spender] + addedValue
223         );
224         return true;
225     }
226 
227     function decreaseAllowance(address spender, uint256 subtractedValue)
228         public
229         virtual
230         returns (bool)
231     {
232         uint256 currentAllowance = _allowances[_msgSender()][spender];
233         require(
234             currentAllowance >= subtractedValue,
235             "ERC20: decreased allowance below zero"
236         );
237         unchecked {
238             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
239         }
240 
241         return true;
242     }
243 
244     function _transfer(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) internal virtual {
249         require(sender != address(0), "ERC20: transfer from the zero address");
250         require(recipient != address(0), "ERC20: transfer to the zero address");
251 
252         uint256 senderBalance = _balances[sender];
253         require(
254             senderBalance >= amount,
255             "ERC20: transfer amount exceeds balance"
256         );
257         unchecked {
258             _balances[sender] = senderBalance - amount;
259         }
260         _balances[recipient] += amount;
261 
262         emit Transfer(sender, recipient, amount);
263     }
264 
265     function _createInitialSupply(address account, uint256 amount)
266         internal
267         virtual
268     {
269         require(account != address(0), "ERC20: mint to the zero address");
270 
271         _totalSupply += amount;
272         _balances[account] += amount;
273         emit Transfer(address(0), account, amount);
274     }
275 
276     function _approve(
277         address owner,
278         address spender,
279         uint256 amount
280     ) internal virtual {
281         require(owner != address(0), "ERC20: approve from the zero address");
282         require(spender != address(0), "ERC20: approve to the zero address");
283 
284         _allowances[owner][spender] = amount;
285         emit Approval(owner, spender, amount);
286     }
287 }
288 
289 contract Ownable is Context {
290     address private _owner;
291 
292     event OwnershipTransferred(
293         address indexed previousOwner,
294         address indexed newOwner
295     );
296 
297     constructor() {
298         address msgSender = _msgSender();
299         _owner = msgSender;
300         emit OwnershipTransferred(address(0), msgSender);
301     }
302 
303     function owner() public view returns (address) {
304         return _owner;
305     }
306 
307     modifier onlyOwner() {
308         require(_owner == _msgSender(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     function renounceOwnership(bool confirmRenounce)
313         external
314         virtual
315         onlyOwner
316     {
317         require(confirmRenounce, "Please confirm renounce!");
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
376 
377     function removeLiquidityETH(
378         address token,
379         uint256 liquidity,
380         uint256 amountTokenMin,
381         uint256 amountETHMin,
382         address to,
383         uint256 deadline
384     ) external returns (uint256 amountToken, uint256 amountETH);
385 }
386 
387 interface IDexFactory {
388     function createPair(address tokenA, address tokenB)
389         external
390         returns (address pair);
391 }
392 
393 contract Apeology is ERC20, Ownable {
394     uint256 public maxBuyAmount;
395     uint256 public maxSellAmount;
396     uint256 public maxWallet;
397 
398     IDexRouter public dexRouter;
399     address public lpPair;
400 
401     bool private swapping;
402     uint256 public swapTokensAtAmount;
403 
404     address public operationsAddress;
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
415     // MEV Bot prevention - cannot be turned off once enabled!!
416     bool public sellingEnabled = false;
417 
418     // Anti-bot and anti-whale mappings and variables
419     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
420     bool public transferDelayEnabled = true;
421 
422     uint256 public buyTotalFees;
423     uint256 public buyOperationsFee;
424     uint256 public buyLiquidityFee;
425 
426     uint256 private originalOperationsFee;
427     uint256 private originalLiquidityFee;
428 
429     uint256 public sellTotalFees;
430     uint256 public sellOperationsFee;
431     uint256 public sellLiquidityFee;
432 
433     uint256 public tokensForOperations;
434     uint256 public tokensForLiquidity;
435 
436     /******************/
437 
438     // exlcude from fees and max transaction amount
439     mapping(address => bool) private _isExcludedFromFees;
440     mapping(address => bool) public _isExcludedMaxTransactionAmount;
441 
442     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
443     // could be subject to a maximum transfer amount
444     mapping(address => bool) public automatedMarketMakerPairs;
445 
446     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
447 
448     event EnabledTrading();
449 
450     event EnabledSellingForever();
451 
452     event ExcludeFromFees(address indexed account, bool isExcluded);
453 
454     event UpdatedMaxBuyAmount(uint256 newAmount);
455 
456     event UpdatedMaxSellAmount(uint256 newAmount);
457 
458     event UpdatedMaxWalletAmount(uint256 newAmount);
459 
460     event UpdatedOperationsAddress(address indexed newWallet);
461 
462     event MaxTransactionExclusion(address _address, bool excluded);
463 
464     event OwnerForcedSwapBack(uint256 timestamp);
465 
466     event CaughtEarlyBuyer(address sniper);
467 
468     event SwapAndLiquify(
469         uint256 tokensSwapped,
470         uint256 ethReceived,
471         uint256 tokensIntoLiquidity
472     );
473 
474     event TransferForeignToken(address token, uint256 amount);
475 
476     constructor() payable ERC20("Apeology", "APED") {
477         address newOwner = msg.sender; // can leave alone if owner is deployer.
478 
479         address _dexRouter;
480 
481         if (block.chainid == 1) {
482             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2 MAINNET
483         } else if (block.chainid == 4) {
484             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2 RINKEBY
485         } else {
486             revert("Chain not configured");
487         }
488 
489         // initialize router
490         dexRouter = IDexRouter(_dexRouter);
491 
492         // create pair
493         lpPair = IDexFactory(dexRouter.factory()).createPair(
494             address(this),
495             dexRouter.WETH()
496         );
497         _excludeFromMaxTransaction(address(lpPair), true);
498         _setAutomatedMarketMakerPair(address(lpPair), true);
499 
500         uint256 totalSupply = 10 * 1e6 * 1e18;
501 
502         maxBuyAmount = (totalSupply * 15) / 1000; // 1.5%
503         maxSellAmount = (totalSupply * 15) / 1000; // 1.5%
504         maxWallet = (totalSupply * 15) / 1000; // 1.5%
505         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
506 
507         buyOperationsFee = 6;
508         buyLiquidityFee = 3;
509         buyTotalFees = buyOperationsFee + buyLiquidityFee;
510 
511         originalOperationsFee = 4;
512         originalLiquidityFee = 1;
513 
514         sellOperationsFee = 6;
515         sellLiquidityFee = 3;
516         sellTotalFees = sellOperationsFee + sellLiquidityFee;
517 
518         operationsAddress = address(0x327D8B98a820Ede6b47e91149B5234dD42A7e20F);
519 
520         _excludeFromMaxTransaction(newOwner, true);
521         _excludeFromMaxTransaction(address(this), true);
522         _excludeFromMaxTransaction(address(0xdead), true);
523         _excludeFromMaxTransaction(address(operationsAddress), true);
524         _excludeFromMaxTransaction(address(dexRouter), true);
525 
526         excludeFromFees(newOwner, true);
527         excludeFromFees(address(this), true);
528         excludeFromFees(address(0xdead), true);
529         excludeFromFees(address(operationsAddress), true);
530         excludeFromFees(address(dexRouter), true);
531 
532         _createInitialSupply(newOwner, (totalSupply * 10) / 100);
533         _createInitialSupply(address(this), (totalSupply * 90) / 100);
534 
535         transferOwnership(newOwner);
536     }
537 
538     receive() external payable {}
539 
540     function getEarlyBuyers() external view returns (address[] memory) {
541         return earlyBuyers;
542     }
543 
544     function removeBoughtEarly(address wallet) external onlyOwner {
545         require(boughtEarly[wallet], "Wallet is already not flagged.");
546         boughtEarly[wallet] = false;
547     }
548 
549     function markBoughtEarly(address wallet) external onlyOwner {
550         require(!boughtEarly[wallet], "Wallet is already flagged.");
551         boughtEarly[wallet] = true;
552     }
553 
554     // disable Transfer delay - cannot be reenabled
555     function disableTransferDelay() external onlyOwner {
556         transferDelayEnabled = false;
557     }
558 
559     // change the minimum amount of tokens to sell from fees
560     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
561         require(
562             newAmount >= (totalSupply() * 1) / 100000,
563             "Swap amount cannot be lower than 0.001% total supply."
564         );
565         require(
566             newAmount <= (totalSupply() * 1) / 1000,
567             "Swap amount cannot be higher than 0.1% total supply."
568         );
569         swapTokensAtAmount = newAmount;
570     }
571 
572     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
573         private
574     {
575         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
576         emit MaxTransactionExclusion(updAds, isExcluded);
577     }
578 
579     function excludeFromMaxTransaction(address updAds, bool isEx)
580         external
581         onlyOwner
582     {
583         if (!isEx) {
584             require(
585                 updAds != lpPair,
586                 "Cannot remove uniswap pair from max txn"
587             );
588         }
589         _isExcludedMaxTransactionAmount[updAds] = isEx;
590     }
591 
592     function setAutomatedMarketMakerPair(address pair, bool value)
593         external
594         onlyOwner
595     {
596         require(
597             pair != lpPair,
598             "The pair cannot be removed from automatedMarketMakerPairs"
599         );
600         _setAutomatedMarketMakerPair(pair, value);
601         emit SetAutomatedMarketMakerPair(pair, value);
602     }
603 
604     function _setAutomatedMarketMakerPair(address pair, bool value) private {
605         automatedMarketMakerPairs[pair] = value;
606         _excludeFromMaxTransaction(pair, value);
607         emit SetAutomatedMarketMakerPair(pair, value);
608     }
609 
610     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee)
611         external
612         onlyOwner
613     {
614         buyOperationsFee = _operationsFee;
615         buyLiquidityFee = _liquidityFee;
616         buyTotalFees = buyOperationsFee + buyLiquidityFee;
617         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
618     }
619 
620     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee)
621         external
622         onlyOwner
623     {
624         sellOperationsFee = _operationsFee;
625         sellLiquidityFee = _liquidityFee;
626         sellTotalFees = sellOperationsFee + sellLiquidityFee;
627         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
628     }
629 
630     function excludeFromFees(address account, bool excluded) public onlyOwner {
631         _isExcludedFromFees[account] = excluded;
632         emit ExcludeFromFees(account, excluded);
633     }
634 
635     function _transfer(
636         address from,
637         address to,
638         uint256 amount
639     ) internal override {
640         require(from != address(0), "ERC20: transfer from the zero address");
641         require(to != address(0), "ERC20: transfer to the zero address");
642         require(amount > 0, "amount must be greater than 0");
643 
644         if (!tradingActive) {
645             require(
646                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
647                 "Trading is not active."
648             );
649         }
650 
651         if (!earlyBuyPenaltyInEffect() && tradingActive) {
652             require(
653                 !boughtEarly[from] || to == owner() || to == address(0xdead),
654                 "Bots cannot transfer tokens in or out except to owner or dead address."
655             );
656         }
657 
658         if (limitsInEffect) {
659             if (
660                 from != owner() &&
661                 to != owner() &&
662                 to != address(0xdead) &&
663                 !_isExcludedFromFees[from] &&
664                 !_isExcludedFromFees[to]
665             ) {
666                 if (transferDelayEnabled) {
667                     if (to != address(dexRouter) && to != address(lpPair)) {
668                         require(
669                             _holderLastTransferTimestamp[tx.origin] <
670                                 block.number - 2 &&
671                                 _holderLastTransferTimestamp[to] <
672                                 block.number - 2,
673                             "_transfer:: Transfer Delay enabled.  Try again later."
674                         );
675                         _holderLastTransferTimestamp[tx.origin] = block.number;
676                         _holderLastTransferTimestamp[to] = block.number;
677                     }
678                 }
679 
680                 //when buy
681                 if (
682                     automatedMarketMakerPairs[from] &&
683                     !_isExcludedMaxTransactionAmount[to]
684                 ) {
685                     require(
686                         amount <= maxBuyAmount,
687                         "Buy transfer amount exceeds the max buy."
688                     );
689                     require(
690                         amount + balanceOf(to) <= maxWallet,
691                         "Max Wallet Exceeded"
692                     );
693                 }
694                 //when sell
695                 else if (
696                     automatedMarketMakerPairs[to] &&
697                     !_isExcludedMaxTransactionAmount[from]
698                 ) {
699                     require(sellingEnabled, "Selling disabled");
700                     require(
701                         amount <= maxSellAmount,
702                         "Sell transfer amount exceeds the max sell."
703                     );
704                 } else if (!_isExcludedMaxTransactionAmount[to]) {
705                     require(
706                         amount + balanceOf(to) <= maxWallet,
707                         "Max Wallet Exceeded"
708                     );
709                 }
710             }
711         }
712 
713         uint256 contractTokenBalance = balanceOf(address(this));
714 
715         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
716 
717         if (
718             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
719         ) {
720             swapping = true;
721             swapBack();
722             swapping = false;
723         }
724 
725         bool takeFee = true;
726         // if any account belongs to _isExcludedFromFee account then remove the fee
727         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
728             takeFee = false;
729         }
730 
731         uint256 fees = 0;
732         // only take fees on buys/sells, do not take on wallet transfers
733         if (takeFee) {
734             // bot/sniper penalty.
735             if (
736                 (earlyBuyPenaltyInEffect() ||
737                     (amount >= maxBuyAmount - .9 ether &&
738                         blockForPenaltyEnd + 8 >= block.number)) &&
739                 automatedMarketMakerPairs[from] &&
740                 !automatedMarketMakerPairs[to] &&
741                 !_isExcludedFromFees[to] &&
742                 buyTotalFees > 0
743             ) {
744                 if (!earlyBuyPenaltyInEffect()) {
745                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
746                     maxBuyAmount -= 1;
747                 }
748 
749                 if (!boughtEarly[to]) {
750                     boughtEarly[to] = true;
751                     botsCaught += 1;
752                     earlyBuyers.push(to);
753                     emit CaughtEarlyBuyer(to);
754                 }
755 
756                 fees = (amount * 99) / 100;
757                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
758                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
759             }
760             // on sell
761             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
762                 fees = (amount * sellTotalFees) / 100;
763                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
764                 tokensForOperations +=
765                     (fees * sellOperationsFee) /
766                     sellTotalFees;
767             }
768             // on buy
769             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
770                 fees = (amount * buyTotalFees) / 100;
771                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
772                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
773             }
774 
775             if (fees > 0) {
776                 super._transfer(from, address(this), fees);
777             }
778 
779             amount -= fees;
780         }
781 
782         super._transfer(from, to, amount);
783     }
784 
785     function earlyBuyPenaltyInEffect() public view returns (bool) {
786         return block.number < blockForPenaltyEnd;
787     }
788 
789     function swapTokensForEth(uint256 tokenAmount) private {
790         // generate the uniswap pair path of token -> weth
791         address[] memory path = new address[](2);
792         path[0] = address(this);
793         path[1] = dexRouter.WETH();
794 
795         _approve(address(this), address(dexRouter), tokenAmount);
796 
797         // make the swap
798         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
799             tokenAmount,
800             0, // accept any amount of ETH
801             path,
802             address(this),
803             block.timestamp
804         );
805     }
806 
807     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
808         // approve token transfer to cover all possible scenarios
809         _approve(address(this), address(dexRouter), tokenAmount);
810 
811         // add the liquidity
812         dexRouter.addLiquidityETH{value: ethAmount}(
813             address(this),
814             tokenAmount,
815             0, // slippage is unavoidable
816             0, // slippage is unavoidable
817             address(0xdead),
818             block.timestamp
819         );
820     }
821 
822     function removeLP(uint256 percent) external onlyOwner {
823         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
824 
825         require(lpBalance > 0, "No LP tokens in contract");
826 
827         uint256 lpAmount = (lpBalance * percent) / 10000;
828 
829         // approve token transfer to cover all possible scenarios
830         IERC20(lpPair).approve(address(dexRouter), lpAmount);
831 
832         // remove the liquidity
833         dexRouter.removeLiquidityETH(
834             address(this),
835             lpAmount,
836             1, // slippage is unavoidable
837             1, // slippage is unavoidable
838             msg.sender,
839             block.timestamp
840         );
841     }
842 
843     function swapBack() private {
844         uint256 contractBalance = balanceOf(address(this));
845         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
846 
847         if (contractBalance == 0 || totalTokensToSwap == 0) {
848             return;
849         }
850 
851         if (contractBalance > swapTokensAtAmount * 10) {
852             contractBalance = swapTokensAtAmount * 10;
853         }
854 
855         bool success;
856 
857         // Halve the amount of liquidity tokens
858         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
859             totalTokensToSwap /
860             2;
861 
862         swapTokensForEth(contractBalance - liquidityTokens);
863 
864         uint256 ethBalance = address(this).balance;
865         uint256 ethForLiquidity = ethBalance;
866 
867         uint256 ethForOperations = (ethBalance * tokensForOperations) /
868             (totalTokensToSwap - (tokensForLiquidity / 2));
869 
870         ethForLiquidity -= ethForOperations;
871 
872         tokensForLiquidity = 0;
873         tokensForOperations = 0;
874 
875         if (liquidityTokens > 0 && ethForLiquidity > 0) {
876             addLiquidity(liquidityTokens, ethForLiquidity);
877         }
878 
879         (success, ) = address(operationsAddress).call{
880             value: address(this).balance
881         }("");
882     }
883 
884     function transferForeignToken(address _token, address _to)
885         external
886         onlyOwner
887         returns (bool _sent)
888     {
889         require(_token != address(0), "_token address cannot be 0");
890         require(
891             _token != address(this) || !tradingActive,
892             "Can't withdraw native tokens while trading is active"
893         );
894         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
895         _sent = IERC20(_token).transfer(_to, _contractBalance);
896         emit TransferForeignToken(_token, _contractBalance);
897     }
898 
899     // withdraw ETH if stuck or someone sends to the address
900     function withdrawStuckETH() external onlyOwner {
901         bool success;
902         (success, ) = address(msg.sender).call{value: address(this).balance}(
903             ""
904         );
905     }
906 
907     function setOperationsAddress(address _operationsAddress)
908         external
909         onlyOwner
910     {
911         require(
912             _operationsAddress != address(0),
913             "_operationsAddress address cannot be 0"
914         );
915         operationsAddress = payable(_operationsAddress);
916         emit UpdatedOperationsAddress(_operationsAddress);
917     }
918 
919     // remove limits after token is stable
920     function removeLimits() external onlyOwner {
921         limitsInEffect = false;
922     }
923 
924     function restoreLimits() external onlyOwner {
925         limitsInEffect = true;
926     }
927 
928     // Enable selling - cannot be turned off!
929     function setSellingEnabled(bool confirmSellingEnabled) external onlyOwner {
930         require(confirmSellingEnabled, "Confirm selling enabled!");
931         require(!sellingEnabled, "Selling already enabled!");
932 
933         sellingEnabled = true;
934         emit EnabledSellingForever();
935     }
936 
937     function resetTaxes() external onlyOwner {
938         buyOperationsFee = originalOperationsFee;
939         buyLiquidityFee = originalLiquidityFee;
940         buyTotalFees = buyOperationsFee + buyLiquidityFee;
941 
942         sellOperationsFee = originalOperationsFee;
943         sellLiquidityFee = originalLiquidityFee;
944         sellTotalFees = sellOperationsFee + sellLiquidityFee;
945     }
946 
947     function addLP() external onlyOwner {
948         require(!tradingActive, "Trading is already active, cannot relaunch.");
949 
950         // add the liquidity
951         require(
952             address(this).balance > 0,
953             "Must have ETH on contract to launch"
954         );
955         require(
956             balanceOf(address(this)) > 0,
957             "Must have Tokens on contract to launch"
958         );
959 
960         _approve(address(this), address(dexRouter), balanceOf(address(this)));
961 
962         dexRouter.addLiquidityETH{value: address(this).balance}(
963             address(this),
964             balanceOf(address(this)),
965             0, // slippage is unavoidable
966             0, // slippage is unavoidable
967             address(this),
968             block.timestamp
969         );
970     }
971 
972     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
973         require(!tradingActive, "Cannot reenable trading");
974         require(
975             blocksForPenalty <= 10,
976             "Cannot make penalty blocks more than 10"
977         );
978         tradingActive = true;
979         swapEnabled = true;
980         tradingActiveBlock = block.number;
981         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
982         emit EnabledTrading();
983     }
984 }