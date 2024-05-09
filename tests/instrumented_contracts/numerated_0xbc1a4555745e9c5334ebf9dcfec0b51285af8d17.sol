1 // SPDX-License-Identifier: MIT
2 /*
3     https://twitter.com/CATAIrobot
4     https://t.me/catgirl_ai
5 */
6 pragma solidity 0.8.18;
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
308     function renounceOwnership() external virtual onlyOwner {
309         emit OwnershipTransferred(_owner, address(0));
310         _owner = address(0);
311     }
312 
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(
315             newOwner != address(0),
316             "Ownable: new owner is the zero address"
317         );
318         emit OwnershipTransferred(_owner, newOwner);
319         _owner = newOwner;
320     }
321 }
322 
323 interface ILpPair {
324     function sync() external;
325 }
326 
327 interface IDexRouter {
328     function factory() external pure returns (address);
329 
330     function WETH() external pure returns (address);
331 
332     function swapExactTokensForETHSupportingFeeOnTransferTokens(
333         uint256 amountIn,
334         uint256 amountOutMin,
335         address[] calldata path,
336         address to,
337         uint256 deadline
338     ) external;
339 
340     function swapExactETHForTokensSupportingFeeOnTransferTokens(
341         uint256 amountOutMin,
342         address[] calldata path,
343         address to,
344         uint256 deadline
345     ) external payable;
346 
347     function addLiquidityETH(
348         address token,
349         uint256 amountTokenDesired,
350         uint256 amountTokenMin,
351         uint256 amountETHMin,
352         address to,
353         uint256 deadline
354     )
355         external
356         payable
357         returns (
358             uint256 amountToken,
359             uint256 amountETH,
360             uint256 liquidity
361         );
362 
363     function getAmountsOut(uint256 amountIn, address[] calldata path)
364         external
365         view
366         returns (uint256[] memory amounts);
367 
368     function removeLiquidityETH(
369         address token,
370         uint256 liquidity,
371         uint256 amountTokenMin,
372         uint256 amountETHMin,
373         address to,
374         uint256 deadline
375     ) external returns (uint256 amountToken, uint256 amountETH);
376 }
377 
378 interface IDexFactory {
379     function createPair(address tokenA, address tokenB)
380         external
381         returns (address pair);
382 }
383 
384 contract CATAIV2 is ERC20, Ownable {
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
395     address private operationsAddress;
396     address private developmentAddress;
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
408     // Anti-bot and anti-whale mappings and variables
409     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
410     bool public transferDelayEnabled = true;
411 
412     uint256 public buyTotalFees;
413     uint256 public buyOperationsFee;
414     uint256 public buyLiquidityFee;
415     uint256 public buyDevelopmentFee;
416 
417     uint256 private originalSellOperationsFee;
418     uint256 private originalSellLiquidityFee;
419     uint256 private originalSellDevelopmentFee;
420 
421     uint256 public sellTotalFees;
422     uint256 public sellOperationsFee;
423     uint256 public sellLiquidityFee;
424     uint256 public sellDevelopmentFee;
425 
426     uint256 public tokensForOperations;
427     uint256 public tokensForLiquidity;
428     uint256 public tokensForDevelopment;
429 
430     /******************/
431 
432     // exlcude from fees and max transaction amount
433     mapping(address => bool) private _isExcludedFromFees;
434     mapping(address => bool) public _isExcludedMaxTransactionAmount;
435 
436     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
437     // could be subject to a maximum transfer amount
438     mapping(address => bool) public automatedMarketMakerPairs;
439 
440     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
441 
442     event EnabledTrading();
443 
444     event ExcludeFromFees(address indexed account, bool isExcluded);
445 
446     event UpdatedMaxBuyAmount(uint256 newAmount);
447 
448     event UpdatedMaxSellAmount(uint256 newAmount);
449 
450     event UpdatedMaxWalletAmount(uint256 newAmount);
451 
452     event UpdatedOperationsAddress(address indexed newWallet);
453 
454     event UpdatedDevelopmentAddress(address indexed newWallet);
455 
456     event MaxTransactionExclusion(address _address, bool excluded);
457 
458     event OwnerForcedSwapBack(uint256 timestamp);
459 
460     event CaughtEarlyBuyer(address sniper);
461 
462     event SwapAndLiquify(
463         uint256 tokensSwapped,
464         uint256 ethReceived,
465         uint256 tokensIntoLiquidity
466     );
467 
468     event TransferForeignToken(address token, uint256 amount);
469 
470     event UpdatedPrivateMaxSell(uint256 amount);
471 
472     event EnabledSelling();
473 
474     constructor() payable ERC20("Catgirl AI", "CATAI") {
475         address newOwner = msg.sender; // can leave alone if owner is deployer.
476 
477         address _dexRouter;
478 
479         if (block.chainid == 1) {
480             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
481         } else if (block.chainid == 5) {
482             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: GOERLI
483         } else {
484             revert("Chain not configured");
485         }
486 
487         // initialize router
488         dexRouter = IDexRouter(_dexRouter);
489 
490         // create pair
491         lpPair = IDexFactory(dexRouter.factory()).createPair(
492             address(this),
493             dexRouter.WETH()
494         );
495         _excludeFromMaxTransaction(address(lpPair), true);
496         _setAutomatedMarketMakerPair(address(lpPair), true);
497 
498         uint256 totalSupply = 1 * 1e9 * 1e18;
499 
500         maxBuyAmount = (totalSupply * 2) / 100; // 2%
501         maxSellAmount = (totalSupply * 2) / 100; // 2%
502         maxWallet = (totalSupply * 2) / 100; // 2%
503         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
504 
505         buyOperationsFee = 7;
506         buyLiquidityFee = 0;
507         buyDevelopmentFee = 3;
508         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevelopmentFee;
509 
510         originalSellOperationsFee = 3;
511         originalSellLiquidityFee = 1;
512         originalSellDevelopmentFee = 0;
513 
514         sellOperationsFee = 14;
515         sellLiquidityFee = 0;
516         sellDevelopmentFee = 6;
517         sellTotalFees =
518             sellOperationsFee +
519             sellLiquidityFee +
520             sellDevelopmentFee;
521 
522         operationsAddress = address(0x4B92FF5C8eCB7fC7935322684B4E6F806b7581C8);
523         developmentAddress = address(msg.sender);
524 
525         _excludeFromMaxTransaction(newOwner, true);
526         _excludeFromMaxTransaction(address(this), true);
527         _excludeFromMaxTransaction(address(0xdead), true);
528         _excludeFromMaxTransaction(address(operationsAddress), true);
529         _excludeFromMaxTransaction(address(developmentAddress), true);
530         _excludeFromMaxTransaction(address(dexRouter), true);
531         _excludeFromMaxTransaction(
532             address(0x3eE48b9aCdeD57d6D5ddAdeD1251322Ea161E9D3),
533             true
534         ); // 1st deployer wallet
535         _excludeFromMaxTransaction(
536             address(0x43a2c166617AA5AEEd917f1a2A7F27D24beC8a09),
537             true
538         ); // 2nd deployer wallet
539 
540         excludeFromFees(newOwner, true);
541         excludeFromFees(address(this), true);
542         excludeFromFees(address(0xdead), true);
543         excludeFromFees(address(operationsAddress), true);
544         excludeFromFees(address(developmentAddress), true);
545         excludeFromFees(address(dexRouter), true);
546         excludeFromFees(
547             address(0x3eE48b9aCdeD57d6D5ddAdeD1251322Ea161E9D3),
548             true
549         ); // 1st deployer wallet
550         excludeFromFees(
551             address(0x43a2c166617AA5AEEd917f1a2A7F27D24beC8a09),
552             true
553         ); // 2nd deployer wallet
554 
555         _createInitialSupply(address(this), (totalSupply * 9) / 100); // Tokens for liquidity
556         _createInitialSupply(newOwner, (totalSupply * 91) / 100); // Spare
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
580     function addBoughtEarly(address wallet) external onlyOwner {
581         require(!boughtEarly[wallet], "Wallet is already flagged.");
582         boughtEarly[wallet] = true;
583     }
584 
585     function removeBoughtEarly(address wallet) external onlyOwner {
586         require(boughtEarly[wallet], "Wallet is already not flagged.");
587         boughtEarly[wallet] = false;
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
600     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
601         require(
602             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
603             "Cannot set max buy amount lower than 0.5%"
604         );
605         require(
606             newNum <= ((totalSupply() * 2) / 100) / 1e18,
607             "Cannot set buy sell amount higher than 2%"
608         );
609         maxBuyAmount = newNum * (10**18);
610         emit UpdatedMaxBuyAmount(maxBuyAmount);
611     }
612 
613     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
614         require(
615             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
616             "Cannot set max sell amount lower than 0.5%"
617         );
618         require(
619             newNum <= ((totalSupply() * 2) / 100) / 1e18,
620             "Cannot set max sell amount higher than 2%"
621         );
622         maxSellAmount = newNum * (10**18);
623         emit UpdatedMaxSellAmount(maxSellAmount);
624     }
625 
626     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
627         require(
628             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
629             "Cannot set max wallet amount lower than 0.5%"
630         );
631         require(
632             newNum <= ((totalSupply() * 2) / 100) / 1e18,
633             "Cannot set max wallet amount higher than 2%"
634         );
635         maxWallet = newNum * (10**18);
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
652     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
653         private
654     {
655         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
656         emit MaxTransactionExclusion(updAds, isExcluded);
657     }
658 
659     function excludeFromMaxTransaction(address updAds, bool isEx)
660         external
661         onlyOwner
662     {
663         if (!isEx) {
664             require(
665                 updAds != lpPair,
666                 "Cannot remove uniswap pair from max txn"
667             );
668         }
669         _isExcludedMaxTransactionAmount[updAds] = isEx;
670     }
671 
672     function setAutomatedMarketMakerPair(address pair, bool value)
673         external
674         onlyOwner
675     {
676         require(
677             pair != lpPair,
678             "The pair cannot be removed from automatedMarketMakerPairs"
679         );
680         _setAutomatedMarketMakerPair(pair, value);
681         emit SetAutomatedMarketMakerPair(pair, value);
682     }
683 
684     function _setAutomatedMarketMakerPair(address pair, bool value) private {
685         automatedMarketMakerPairs[pair] = value;
686         _excludeFromMaxTransaction(pair, value);
687         emit SetAutomatedMarketMakerPair(pair, value);
688     }
689 
690     function updateBuyFees(
691         uint256 _operationsFee,
692         uint256 _liquidityFee,
693         uint256 _developmentFee
694     ) external onlyOwner {
695         buyOperationsFee = _operationsFee;
696         buyLiquidityFee = _liquidityFee;
697         buyDevelopmentFee = _developmentFee;
698         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevelopmentFee;
699         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
700     }
701 
702     function updateSellFees(
703         uint256 _operationsFee,
704         uint256 _liquidityFee,
705         uint256 _developmentFee
706     ) external onlyOwner {
707         sellOperationsFee = _operationsFee;
708         sellLiquidityFee = _liquidityFee;
709         sellDevelopmentFee = _developmentFee;
710         sellTotalFees =
711             sellOperationsFee +
712             sellLiquidityFee +
713             sellDevelopmentFee;
714         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
715     }
716 
717     function restoreTaxes() external onlyOwner {
718         buyOperationsFee = originalSellOperationsFee;
719         buyLiquidityFee = originalSellLiquidityFee;
720         buyDevelopmentFee = originalSellDevelopmentFee;
721         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevelopmentFee;
722 
723         sellOperationsFee = originalSellOperationsFee;
724         sellLiquidityFee = originalSellLiquidityFee;
725         sellDevelopmentFee = originalSellDevelopmentFee;
726         sellTotalFees =
727             sellOperationsFee +
728             sellLiquidityFee +
729             sellDevelopmentFee;
730     }
731 
732     function excludeFromFees(address account, bool excluded) public onlyOwner {
733         _isExcludedFromFees[account] = excluded;
734         emit ExcludeFromFees(account, excluded);
735     }
736 
737     function _transfer(
738         address from,
739         address to,
740         uint256 amount
741     ) internal override {
742         require(from != address(0), "ERC20: transfer from the zero address");
743         require(to != address(0), "ERC20: transfer to the zero address");
744         require(amount > 0, "amount must be greater than 0");
745 
746         if (!tradingActive) {
747             require(
748                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
749                 "Trading is not active."
750             );
751         }
752 
753         if (!earlyBuyPenaltyInEffect() && tradingActive) {
754             require(
755                 !boughtEarly[from] || to == owner() || to == address(0xdead),
756                 "Bots cannot transfer tokens in or out except to owner or dead address."
757             );
758         }
759 
760         if (limitsInEffect) {
761             if (
762                 from != owner() &&
763                 to != owner() &&
764                 to != address(0xdead) &&
765                 !_isExcludedFromFees[from] &&
766                 !_isExcludedFromFees[to]
767             ) {
768                 if (transferDelayEnabled) {
769                     if (to != address(dexRouter) && to != address(lpPair)) {
770                         require(
771                             _holderLastTransferTimestamp[tx.origin] <
772                                 block.number - 2 &&
773                                 _holderLastTransferTimestamp[to] <
774                                 block.number - 2,
775                             "_transfer:: Transfer Delay enabled.  Try again later."
776                         );
777                         _holderLastTransferTimestamp[tx.origin] = block.number;
778                         _holderLastTransferTimestamp[to] = block.number;
779                     }
780                 }
781 
782                 //when buy
783                 if (
784                     automatedMarketMakerPairs[from] &&
785                     !_isExcludedMaxTransactionAmount[to]
786                 ) {
787                     require(
788                         amount <= maxBuyAmount,
789                         "Buy transfer amount exceeds the max buy."
790                     );
791                     require(
792                         amount + balanceOf(to) <= maxWallet,
793                         "Max Wallet Exceeded"
794                     );
795                 }
796                 //when sell
797                 else if (
798                     automatedMarketMakerPairs[to] &&
799                     !_isExcludedMaxTransactionAmount[from]
800                 ) {
801                     require(
802                         amount <= maxSellAmount,
803                         "Sell transfer amount exceeds the max sell."
804                     );
805                 } else if (!_isExcludedMaxTransactionAmount[to]) {
806                     require(
807                         amount + balanceOf(to) <= maxWallet,
808                         "Max Wallet Exceeded"
809                     );
810                 }
811             }
812         }
813 
814         uint256 contractTokenBalance = balanceOf(address(this));
815 
816         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
817 
818         if (
819             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
820         ) {
821             swapping = true;
822             swapBack();
823             swapping = false;
824         }
825 
826         bool takeFee = true;
827         // if any account belongs to _isExcludedFromFee account then remove the fee
828         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
829             takeFee = false;
830         }
831 
832         uint256 fees = 0;
833         // only take fees on buys/sells, do not take on wallet transfers
834         if (takeFee) {
835             // bot/sniper penalty.
836             if (
837                 (earlyBuyPenaltyInEffect() ||
838                     (amount >= maxBuyAmount - .9 ether &&
839                         blockForPenaltyEnd + 8 >= block.number)) &&
840                 automatedMarketMakerPairs[from] &&
841                 !automatedMarketMakerPairs[to] &&
842                 !_isExcludedFromFees[to] &&
843                 buyTotalFees > 0
844             ) {
845                 if (!earlyBuyPenaltyInEffect()) {
846                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
847                     maxBuyAmount -= 1;
848                 }
849 
850                 if (!boughtEarly[to]) {
851                     boughtEarly[to] = true;
852                     botsCaught += 1;
853                     earlyBuyers.push(to);
854                     emit CaughtEarlyBuyer(to);
855                 }
856 
857                 fees = (amount * 99) / 100;
858                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
859                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
860                 tokensForDevelopment +=
861                     (fees * buyDevelopmentFee) /
862                     buyTotalFees;
863             }
864             // on sell
865             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
866                 fees = (amount * sellTotalFees) / 100;
867                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
868                 tokensForOperations +=
869                     (fees * sellOperationsFee) /
870                     sellTotalFees;
871                 tokensForDevelopment +=
872                     (fees * sellDevelopmentFee) /
873                     sellTotalFees;
874             }
875             // on buy
876             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
877                 fees = (amount * buyTotalFees) / 100;
878                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
879                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
880                 tokensForDevelopment +=
881                     (fees * buyDevelopmentFee) /
882                     buyTotalFees;
883             }
884 
885             if (fees > 0) {
886                 super._transfer(from, address(this), fees);
887             }
888 
889             amount -= fees;
890         }
891 
892         super._transfer(from, to, amount);
893     }
894 
895     function earlyBuyPenaltyInEffect() public view returns (bool) {
896         return block.number < blockForPenaltyEnd;
897     }
898 
899     function swapTokensForEth(uint256 tokenAmount) private {
900         // generate the uniswap pair path of token -> weth
901         address[] memory path = new address[](2);
902         path[0] = address(this);
903         path[1] = dexRouter.WETH();
904 
905         _approve(address(this), address(dexRouter), tokenAmount);
906 
907         // make the swap
908         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
909             tokenAmount,
910             0, // accept any amount of ETH
911             path,
912             address(this),
913             block.timestamp
914         );
915     }
916 
917     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
918         // approve token transfer to cover all possible scenarios
919         _approve(address(this), address(dexRouter), tokenAmount);
920 
921         // add the liquidity
922         dexRouter.addLiquidityETH{value: ethAmount}(
923             address(this),
924             tokenAmount,
925             0, // slippage is unavoidable
926             0, // slippage is unavoidable
927             address(0xdead),
928             block.timestamp
929         );
930     }
931 
932     function swapBack() private {
933         uint256 contractBalance = balanceOf(address(this));
934         uint256 totalTokensToSwap = tokensForLiquidity +
935             tokensForOperations +
936             tokensForDevelopment;
937 
938         if (contractBalance == 0 || totalTokensToSwap == 0) {
939             return;
940         }
941 
942         if (contractBalance > swapTokensAtAmount * 10) {
943             contractBalance = swapTokensAtAmount * 10;
944         }
945 
946         bool success;
947 
948         // Halve the amount of liquidity tokens
949         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
950             totalTokensToSwap /
951             2;
952 
953         swapTokensForEth(contractBalance - liquidityTokens);
954 
955         uint256 ethBalance = address(this).balance;
956         uint256 ethForLiquidity = ethBalance;
957 
958         uint256 ethForOperations = (ethBalance * tokensForOperations) /
959             (totalTokensToSwap - (tokensForLiquidity / 2));
960         uint256 ethForStaking = (ethBalance * tokensForDevelopment) /
961             (totalTokensToSwap - (tokensForLiquidity / 2));
962 
963         ethForLiquidity -= ethForOperations + ethForStaking;
964 
965         tokensForLiquidity = 0;
966         tokensForOperations = 0;
967         tokensForDevelopment = 0;
968 
969         if (liquidityTokens > 0 && ethForLiquidity > 0) {
970             addLiquidity(liquidityTokens, ethForLiquidity);
971         }
972 
973         (success, ) = address(developmentAddress).call{value: ethForStaking}(
974             ""
975         );
976         (success, ) = address(operationsAddress).call{
977             value: address(this).balance
978         }("");
979     }
980 
981     function transferForeignToken(address _token, address _to)
982         external
983         onlyOwner
984         returns (bool _sent)
985     {
986         require(_token != address(0), "_token address cannot be 0");
987         require(
988             _token != address(this) || !tradingActive,
989             "Can't withdraw native tokens while trading is active"
990         );
991         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
992         _sent = IERC20(_token).transfer(_to, _contractBalance);
993         emit TransferForeignToken(_token, _contractBalance);
994     }
995 
996     // withdraw ETH if stuck or someone sends to the address
997     function withdrawStuckETH() external onlyOwner {
998         bool success;
999         (success, ) = address(msg.sender).call{value: address(this).balance}(
1000             ""
1001         );
1002     }
1003 
1004     function setOperationsAddress(address _operationsAddress)
1005         external
1006         onlyOwner
1007     {
1008         require(
1009             _operationsAddress != address(0),
1010             "_operationsAddress address cannot be 0"
1011         );
1012         operationsAddress = payable(_operationsAddress);
1013         emit UpdatedOperationsAddress(_operationsAddress);
1014     }
1015 
1016     function setDevelopmentAddress(address _developmentAddress)
1017         external
1018         onlyOwner
1019     {
1020         require(
1021             _developmentAddress != address(0),
1022             "_developmentAddress address cannot be 0"
1023         );
1024         developmentAddress = payable(_developmentAddress);
1025         emit UpdatedDevelopmentAddress(_developmentAddress);
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
1049     function airdropToWallets(
1050         address[] memory wallets,
1051         uint256[] memory amountsInTokens
1052     ) external onlyOwner {
1053         require(
1054             wallets.length == amountsInTokens.length,
1055             "arrays must be the same length"
1056         );
1057         require(
1058             wallets.length < 200,
1059             "Can only airdrop 200 wallets per txn due to gas limits"
1060         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
1061         for (uint256 i = 0; i < wallets.length; i++) {
1062             address wallet = wallets[i];
1063             uint256 amount = amountsInTokens[i];
1064             super._transfer(msg.sender, wallet, amount);
1065         }
1066     }
1067 
1068     function addLP(bool confirmAddLp) external onlyOwner {
1069         require(confirmAddLp, "Please confirm adding of the LP");
1070         require(!tradingActive, "Trading is already active, cannot relaunch.");
1071 
1072         // add the liquidity
1073         require(
1074             address(this).balance > 0,
1075             "Must have ETH on contract to launch"
1076         );
1077         require(
1078             balanceOf(address(this)) > 0,
1079             "Must have Tokens on contract to launch"
1080         );
1081 
1082         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1083 
1084         dexRouter.addLiquidityETH{value: address(this).balance}(
1085             address(this),
1086             balanceOf(address(this)),
1087             0, // slippage is unavoidable
1088             0, // slippage is unavoidable
1089             msg.sender,
1090             block.timestamp
1091         );
1092     }
1093 
1094     function launch(uint256 blocksForPenalty) external onlyOwner {
1095         require(!tradingActive, "Trading is already active, cannot relaunch.");
1096         require(
1097             blocksForPenalty < 10,
1098             "Cannot make penalty blocks more than 10"
1099         );
1100 
1101         //standard enable trading
1102         tradingActive = true;
1103         swapEnabled = true;
1104         tradingActiveBlock = block.number;
1105         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1106         emit EnabledTrading();
1107 
1108         // add the liquidity
1109         require(
1110             address(this).balance > 0,
1111             "Must have ETH on contract to launch"
1112         );
1113         require(
1114             balanceOf(address(this)) > 0,
1115             "Must have Tokens on contract to launch"
1116         );
1117 
1118         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1119 
1120         dexRouter.addLiquidityETH{value: address(this).balance}(
1121             address(this),
1122             balanceOf(address(this)),
1123             0, // slippage is unavoidable
1124             0, // slippage is unavoidable
1125             msg.sender,
1126             block.timestamp
1127         );
1128     }
1129 }