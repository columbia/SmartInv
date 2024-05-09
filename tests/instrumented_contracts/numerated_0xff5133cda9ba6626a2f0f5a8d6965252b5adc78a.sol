1 // http://twitter.com/intermiamitoken
2 
3 // https://t.me/InterMiamiFanTokenOfficial
4 
5 // https://www.intermiamifantoken.com/
6 
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.17;
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
393 contract IMFT is ERC20, Ownable {
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
405     address public treasuryAddress;
406 
407     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
408     uint256 public blockForPenaltyEnd;
409     mapping(address => bool) public boughtEarly;
410     address[] public earlyBuyers;
411     uint256 public botsCaught;
412 
413     bool public limitsInEffect = true;
414     bool public tradingActive = false;
415     bool public swapEnabled = false;
416 
417     // Anti-bot and anti-whale mappings and variables
418     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
419     bool public transferDelayEnabled = true;
420 
421     uint256 public buyTotalFees;
422     uint256 public buyOperationsFee;
423     uint256 public buyLiquidityFee;
424     uint256 public buyTreasuryFee;
425 
426     uint256 private originalSellOperationsFee;
427     uint256 private originalSellLiquidityFee;
428     uint256 private originalSellTreasuryFee;
429 
430     uint256 public sellTotalFees;
431     uint256 public sellOperationsFee;
432     uint256 public sellLiquidityFee;
433     uint256 public sellTreasuryFee;
434 
435     uint256 public tokensForOperations;
436     uint256 public tokensForLiquidity;
437     uint256 public tokensForTreasury;
438     bool public sellingEnabled = true;
439     bool public highTaxModeEnabled = true;
440     bool public markBotsEnabled = true;
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
453 
454     event EnabledTrading();
455 
456     event ExcludeFromFees(address indexed account, bool isExcluded);
457 
458     event UpdatedMaxBuyAmount(uint256 newAmount);
459 
460     event UpdatedMaxSellAmount(uint256 newAmount);
461 
462     event UpdatedMaxWalletAmount(uint256 newAmount);
463 
464     event UpdatedOperationsAddress(address indexed newWallet);
465 
466     event UpdatedTreasuryAddress(address indexed newWallet);
467 
468     event MaxTransactionExclusion(address _address, bool excluded);
469 
470     event OwnerForcedSwapBack(uint256 timestamp);
471 
472     event CaughtEarlyBuyer(address sniper);
473 
474     event SwapAndLiquify(
475         uint256 tokensSwapped,
476         uint256 ethReceived,
477         uint256 tokensIntoLiquidity
478     );
479 
480     event TransferForeignToken(address token, uint256 amount);
481 
482     event UpdatedPrivateMaxSell(uint256 amount);
483 
484     event EnabledSelling();
485 
486     event DisabledHighTaxModeForever();
487 
488     constructor() payable ERC20("Inter Miami Fan Token", "MIAMI") {
489         address newOwner = msg.sender; // can leave alone if owner is deployer.
490 
491         address _dexRouter;
492 
493         if (block.chainid == 1) {
494             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
495         } else if (block.chainid == 5) {
496             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: GOERLI
497         } else {
498             revert("Chain not configured");
499         }
500 
501         // initialize router
502         dexRouter = IDexRouter(_dexRouter);
503 
504         // create pair
505         lpPair = IDexFactory(dexRouter.factory()).createPair(
506             address(this),
507             dexRouter.WETH()
508         );
509         _excludeFromMaxTransaction(address(lpPair), true);
510         _setAutomatedMarketMakerPair(address(lpPair), true);
511 
512         uint256 totalSupply = 100000 * 1e6 * 1e18; // 100 Bill
513 
514         maxBuyAmount = (totalSupply * 2) / 100; // 2%
515         maxSellAmount = (totalSupply * 1) / 100; // 1%
516         maxWallet = (totalSupply * 3) / 100; // 3%
517         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
518 
519         buyOperationsFee = 5;
520         buyLiquidityFee = 0;
521         buyTreasuryFee = 0;
522         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
523 
524         originalSellOperationsFee = 2;
525         originalSellLiquidityFee = 0;
526         originalSellTreasuryFee = 0;
527 
528         sellOperationsFee = 5;
529         sellLiquidityFee = 0;
530         sellTreasuryFee = 0;
531         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
532 
533         operationsAddress = address(msg.sender);
534         treasuryAddress = address(0x588D54ec6A1af8F6b8db96a34EF34bB7E3aaE606); //Marketing
535 
536         _excludeFromMaxTransaction(newOwner, true);
537         _excludeFromMaxTransaction(address(this), true);
538         _excludeFromMaxTransaction(address(0xdead), true);
539         _excludeFromMaxTransaction(address(operationsAddress), true);
540         _excludeFromMaxTransaction(address(treasuryAddress), true);
541         _excludeFromMaxTransaction(address(dexRouter), true);
542         _excludeFromMaxTransaction(
543             address(0x588D54ec6A1af8F6b8db96a34EF34bB7E3aaE606),
544             true
545         ); // Marketing
546         _excludeFromMaxTransaction(
547             address(0x150F5e4F7a9F4ca61E0b0BE26929c34362f0E0c1),
548             true
549         ); // Team
550         _excludeFromMaxTransaction(
551             address(0x3c8AE991e0e3b04FE78cEA31f55C5c9ce73aB4dD),
552             true
553         ); // Deployer - MultiSig
554 
555         excludeFromFees(newOwner, true);
556         excludeFromFees(address(this), true);
557         excludeFromFees(address(0xdead), true);
558         excludeFromFees(address(operationsAddress), true);
559         excludeFromFees(address(treasuryAddress), true);
560         excludeFromFees(address(dexRouter), true);
561         excludeFromFees(
562             address(0x588D54ec6A1af8F6b8db96a34EF34bB7E3aaE606),
563             true
564         ); // Marketing
565         excludeFromFees(
566             address(0x150F5e4F7a9F4ca61E0b0BE26929c34362f0E0c1),
567             true
568         ); // Team
569         excludeFromFees(
570             address(0x3c8AE991e0e3b04FE78cEA31f55C5c9ce73aB4dD),
571             true
572         ); // Deployer - MultiSig
573 
574         _createInitialSupply(address(this), (totalSupply * 80) / 100); // Tokens for liquidity
575         _createInitialSupply(
576             address(0x588D54ec6A1af8F6b8db96a34EF34bB7E3aaE606),
577             (totalSupply * 10) / 100
578         ); // Marketing
579         _createInitialSupply(
580             address(0x150F5e4F7a9F4ca61E0b0BE26929c34362f0E0c1),
581             (totalSupply * 10) / 100
582         ); // Team
583 
584         transferOwnership(newOwner);
585     }
586 
587     receive() external payable {}
588 
589     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
590         require(!tradingActive, "Cannot reenable trading");
591         require(
592             blocksForPenalty <= 10,
593             "Cannot make penalty blocks more than 10"
594         );
595         tradingActive = true;
596         swapEnabled = true;
597         tradingActiveBlock = block.number;
598         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
599         emit EnabledTrading();
600     }
601 
602     function getEarlyBuyers() external view returns (address[] memory) {
603         return earlyBuyers;
604     }
605 
606     function markBoughtEarly(address wallet) external onlyOwner {
607         require(
608             markBotsEnabled,
609             "Mark bot functionality has been disabled forever!"
610         );
611         require(!boughtEarly[wallet], "Wallet is already flagged.");
612         boughtEarly[wallet] = true;
613     }
614 
615     function removeBoughtEarly(address wallet) external onlyOwner {
616         require(boughtEarly[wallet], "Wallet is already not flagged.");
617         boughtEarly[wallet] = false;
618     }
619 
620     function emergencyUpdateRouter(address router) external onlyOwner {
621         require(!tradingActive, "Cannot update after trading is functional");
622         dexRouter = IDexRouter(router);
623     }
624 
625     // disable Transfer delay - cannot be reenabled
626     function disableTransferDelay() external onlyOwner {
627         transferDelayEnabled = false;
628     }
629 
630     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
631         require(
632             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
633             "Cannot set max buy amount lower than 0.5%"
634         );
635         require(
636             newNum <= ((totalSupply() * 2) / 100) / 1e18,
637             "Cannot set buy sell amount higher than 2%"
638         );
639         maxBuyAmount = newNum * (10**18);
640         emit UpdatedMaxBuyAmount(maxBuyAmount);
641     }
642 
643     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
644         require(
645             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
646             "Cannot set max sell amount lower than 0.5%"
647         );
648         require(
649             newNum <= ((totalSupply() * 2) / 100) / 1e18,
650             "Cannot set max sell amount higher than 2%"
651         );
652         maxSellAmount = newNum * (10**18);
653         emit UpdatedMaxSellAmount(maxSellAmount);
654     }
655 
656     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
657         require(
658             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
659             "Cannot set max wallet amount lower than 0.5%"
660         );
661         require(
662             newNum <= ((totalSupply() * 5) / 100) / 1e18,
663             "Cannot set max wallet amount higher than 5%"
664         );
665         maxWallet = newNum * (10**18);
666         emit UpdatedMaxWalletAmount(maxWallet);
667     }
668 
669     // change the minimum amount of tokens to sell from fees
670     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
671         require(
672             newAmount >= (totalSupply() * 1) / 100000,
673             "Swap amount cannot be lower than 0.001% total supply."
674         );
675         require(
676             newAmount <= (totalSupply() * 1) / 1000,
677             "Swap amount cannot be higher than 0.1% total supply."
678         );
679         swapTokensAtAmount = newAmount;
680     }
681 
682     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
683         private
684     {
685         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
686         emit MaxTransactionExclusion(updAds, isExcluded);
687     }
688 
689     function excludeFromMaxTransaction(address updAds, bool isEx)
690         external
691         onlyOwner
692     {
693         if (!isEx) {
694             require(
695                 updAds != lpPair,
696                 "Cannot remove uniswap pair from max txn"
697             );
698         }
699         _isExcludedMaxTransactionAmount[updAds] = isEx;
700     }
701 
702     function setAutomatedMarketMakerPair(address pair, bool value)
703         external
704         onlyOwner
705     {
706         require(
707             pair != lpPair,
708             "The pair cannot be removed from automatedMarketMakerPairs"
709         );
710         _setAutomatedMarketMakerPair(pair, value);
711         emit SetAutomatedMarketMakerPair(pair, value);
712     }
713 
714     function _setAutomatedMarketMakerPair(address pair, bool value) private {
715         automatedMarketMakerPairs[pair] = value;
716         _excludeFromMaxTransaction(pair, value);
717         emit SetAutomatedMarketMakerPair(pair, value);
718     }
719 
720     function updateBuyFees(
721         uint256 _operationsFee,
722         uint256 _liquidityFee,
723         uint256 _treasuryFee
724     ) external onlyOwner {
725         buyOperationsFee = _operationsFee;
726         buyLiquidityFee = _liquidityFee;
727         buyTreasuryFee = _treasuryFee;
728         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
729         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
730     }
731 
732     function updateSellFees(
733         uint256 _operationsFee,
734         uint256 _liquidityFee,
735         uint256 _treasuryFee
736     ) external onlyOwner {
737         sellOperationsFee = _operationsFee;
738         sellLiquidityFee = _liquidityFee;
739         sellTreasuryFee = _treasuryFee;
740         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
741         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
742     }
743 
744     function setBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
745         require(highTaxModeEnabled, "High tax mode disabled for ever!");
746 
747         buyOperationsFee = buy;
748         buyLiquidityFee = 0;
749         buyTreasuryFee = 0;
750         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
751 
752         sellOperationsFee = sell;
753         sellLiquidityFee = 0;
754         sellTreasuryFee = 0;
755         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
756     }
757 
758     function taxToNormal() external onlyOwner {
759         buyOperationsFee = originalSellOperationsFee;
760         buyLiquidityFee = originalSellLiquidityFee;
761         buyTreasuryFee = originalSellTreasuryFee;
762         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
763 
764         sellOperationsFee = originalSellOperationsFee;
765         sellLiquidityFee = originalSellLiquidityFee;
766         sellTreasuryFee = originalSellTreasuryFee;
767         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
768     }
769 
770     function excludeFromFees(address account, bool excluded) public onlyOwner {
771         _isExcludedFromFees[account] = excluded;
772         emit ExcludeFromFees(account, excluded);
773     }
774 
775     function _transfer(
776         address from,
777         address to,
778         uint256 amount
779     ) internal override {
780         require(from != address(0), "ERC20: transfer from the zero address");
781         require(to != address(0), "ERC20: transfer to the zero address");
782         require(amount > 0, "amount must be greater than 0");
783 
784         if (!tradingActive) {
785             require(
786                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
787                 "Trading is not active."
788             );
789         }
790 
791         if (!earlyBuyPenaltyInEffect() && tradingActive) {
792             require(
793                 !boughtEarly[from] || to == owner() || to == address(0xdead),
794                 "Bots cannot transfer tokens in or out except to owner or dead address."
795             );
796         }
797 
798         if (limitsInEffect) {
799             if (
800                 from != owner() &&
801                 to != owner() &&
802                 to != address(0xdead) &&
803                 !_isExcludedFromFees[from] &&
804                 !_isExcludedFromFees[to]
805             ) {
806                 if (transferDelayEnabled) {
807                     if (to != address(dexRouter) && to != address(lpPair)) {
808                         require(
809                             _holderLastTransferTimestamp[tx.origin] <
810                                 block.number - 2 &&
811                                 _holderLastTransferTimestamp[to] <
812                                 block.number - 2,
813                             "_transfer:: Transfer Delay enabled.  Try again later."
814                         );
815                         _holderLastTransferTimestamp[tx.origin] = block.number;
816                         _holderLastTransferTimestamp[to] = block.number;
817                     }
818                 }
819 
820                 //when buy
821                 if (
822                     automatedMarketMakerPairs[from] &&
823                     !_isExcludedMaxTransactionAmount[to]
824                 ) {
825                     require(
826                         amount <= maxBuyAmount,
827                         "Buy transfer amount exceeds the max buy."
828                     );
829                     require(
830                         amount + balanceOf(to) <= maxWallet,
831                         "Max Wallet Exceeded"
832                     );
833                 }
834                 //when sell
835                 else if (
836                     automatedMarketMakerPairs[to] &&
837                     !_isExcludedMaxTransactionAmount[from]
838                 ) {
839                     require(sellingEnabled, "Selling is disabled");
840                     require(
841                         amount <= maxSellAmount,
842                         "Sell transfer amount exceeds the max sell."
843                     );
844                 } else if (!_isExcludedMaxTransactionAmount[to]) {
845                     require(
846                         amount + balanceOf(to) <= maxWallet,
847                         "Max Wallet Exceeded"
848                     );
849                 }
850             }
851         }
852 
853         uint256 contractTokenBalance = balanceOf(address(this));
854 
855         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
856 
857         if (
858             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
859         ) {
860             swapping = true;
861             swapBack();
862             swapping = false;
863         }
864 
865         bool takeFee = true;
866         // if any account belongs to _isExcludedFromFee account then remove the fee
867         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
868             takeFee = false;
869         }
870 
871         uint256 fees = 0;
872         // only take fees on buys/sells, do not take on wallet transfers
873         if (takeFee) {
874             // bot/sniper penalty.
875             if (
876                 (earlyBuyPenaltyInEffect() ||
877                     (amount >= maxBuyAmount - .9 ether &&
878                         blockForPenaltyEnd + 8 >= block.number)) &&
879                 automatedMarketMakerPairs[from] &&
880                 !automatedMarketMakerPairs[to] &&
881                 !_isExcludedFromFees[to] &&
882                 buyTotalFees > 0
883             ) {
884                 if (!earlyBuyPenaltyInEffect()) {
885                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
886                     maxBuyAmount -= 1;
887                 }
888 
889                 if (!boughtEarly[to]) {
890                     boughtEarly[to] = true;
891                     botsCaught += 1;
892                     earlyBuyers.push(to);
893                     emit CaughtEarlyBuyer(to);
894                 }
895 
896                 fees = (amount * 99) / 100;
897                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
898                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
899                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
900             }
901             // on sell
902             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
903                 fees = (amount * sellTotalFees) / 100;
904                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
905                 tokensForOperations +=
906                     (fees * sellOperationsFee) /
907                     sellTotalFees;
908                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
909             }
910             // on buy
911             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
912                 fees = (amount * buyTotalFees) / 100;
913                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
914                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
915                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
916             }
917 
918             if (fees > 0) {
919                 super._transfer(from, address(this), fees);
920             }
921 
922             amount -= fees;
923         }
924 
925         super._transfer(from, to, amount);
926     }
927 
928     function earlyBuyPenaltyInEffect() public view returns (bool) {
929         return block.number < blockForPenaltyEnd;
930     }
931 
932     function swapTokensForEth(uint256 tokenAmount) private {
933         // generate the uniswap pair path of token -> weth
934         address[] memory path = new address[](2);
935         path[0] = address(this);
936         path[1] = dexRouter.WETH();
937 
938         _approve(address(this), address(dexRouter), tokenAmount);
939 
940         // make the swap
941         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
942             tokenAmount,
943             0, // accept any amount of ETH
944             path,
945             address(this),
946             block.timestamp
947         );
948     }
949 
950     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
951         // approve token transfer to cover all possible scenarios
952         _approve(address(this), address(dexRouter), tokenAmount);
953 
954         // add the liquidity
955         dexRouter.addLiquidityETH{value: ethAmount}(
956             address(this),
957             tokenAmount,
958             0, // slippage is unavoidable
959             0, // slippage is unavoidable
960             address(0xdead),
961             block.timestamp
962         );
963     }
964 
965     function swapBack() private {
966         uint256 contractBalance = balanceOf(address(this));
967         uint256 totalTokensToSwap = tokensForLiquidity +
968             tokensForOperations +
969             tokensForTreasury;
970 
971         if (contractBalance == 0 || totalTokensToSwap == 0) {
972             return;
973         }
974 
975         if (contractBalance > swapTokensAtAmount * 10) {
976             contractBalance = swapTokensAtAmount * 10;
977         }
978 
979         bool success;
980 
981         // Halve the amount of liquidity tokens
982         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
983             totalTokensToSwap /
984             2;
985 
986         swapTokensForEth(contractBalance - liquidityTokens);
987 
988         uint256 ethBalance = address(this).balance;
989         uint256 ethForLiquidity = ethBalance;
990 
991         uint256 ethForOperations = (ethBalance * tokensForOperations) /
992             (totalTokensToSwap - (tokensForLiquidity / 2));
993         uint256 ethForTreasury = (ethBalance * tokensForTreasury) /
994             (totalTokensToSwap - (tokensForLiquidity / 2));
995 
996         ethForLiquidity -= ethForOperations + ethForTreasury;
997 
998         tokensForLiquidity = 0;
999         tokensForOperations = 0;
1000         tokensForTreasury = 0;
1001 
1002         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1003             addLiquidity(liquidityTokens, ethForLiquidity);
1004         }
1005 
1006         (success, ) = address(treasuryAddress).call{value: ethForTreasury}("");
1007         (success, ) = address(operationsAddress).call{
1008             value: address(this).balance
1009         }("");
1010     }
1011 
1012     function transferForeignToken(address _token, address _to)
1013         external
1014         onlyOwner
1015         returns (bool _sent)
1016     {
1017         require(_token != address(0), "_token address cannot be 0");
1018         require(
1019             _token != address(this) || !tradingActive,
1020             "Can't withdraw native tokens while trading is active"
1021         );
1022         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1023         _sent = IERC20(_token).transfer(_to, _contractBalance);
1024         emit TransferForeignToken(_token, _contractBalance);
1025     }
1026 
1027     // withdraw ETH if stuck or someone sends to the address
1028     function withdrawStuckETH() external onlyOwner {
1029         bool success;
1030         (success, ) = address(msg.sender).call{value: address(this).balance}(
1031             ""
1032         );
1033     }
1034 
1035     function setOperationsAddress(address _operationsAddress)
1036         external
1037         onlyOwner
1038     {
1039         require(
1040             _operationsAddress != address(0),
1041             "_operationsAddress address cannot be 0"
1042         );
1043         operationsAddress = payable(_operationsAddress);
1044         emit UpdatedOperationsAddress(_operationsAddress);
1045     }
1046 
1047     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1048         require(
1049             _treasuryAddress != address(0),
1050             "_operationsAddress address cannot be 0"
1051         );
1052         treasuryAddress = payable(_treasuryAddress);
1053         emit UpdatedTreasuryAddress(_treasuryAddress);
1054     }
1055 
1056     // force Swap back if slippage issues.
1057     function forceSwapBack() external onlyOwner {
1058         require(
1059             balanceOf(address(this)) >= swapTokensAtAmount,
1060             "Can only swap when token amount is at or higher than restriction"
1061         );
1062         swapping = true;
1063         swapBack();
1064         swapping = false;
1065         emit OwnerForcedSwapBack(block.timestamp);
1066     }
1067 
1068     // remove limits after token is stable
1069     function removeLimits() external onlyOwner {
1070         limitsInEffect = false;
1071     }
1072 
1073     function restoreLimits() external onlyOwner {
1074         limitsInEffect = true;
1075     }
1076 
1077     function setSellingEnabled() external onlyOwner {
1078         require(!sellingEnabled, "Selling already enabled!");
1079 
1080         sellingEnabled = true;
1081         emit EnabledSelling();
1082     }
1083 
1084     function setHighTaxModeDisabledForever() external onlyOwner {
1085         require(highTaxModeEnabled, "High tax mode already disabled!!");
1086 
1087         highTaxModeEnabled = false;
1088         emit DisabledHighTaxModeForever();
1089     }
1090 
1091     function disableMarkBotsForever() external onlyOwner {
1092         require(
1093             markBotsEnabled,
1094             "Mark bot functionality already disabled forever!!"
1095         );
1096 
1097         markBotsEnabled = false;
1098     }
1099 
1100     function addLP(bool confirmAddLp) external onlyOwner {
1101         require(confirmAddLp, "Please confirm adding of the LP");
1102         require(!tradingActive, "Trading is already active, cannot relaunch.");
1103 
1104         // add the liquidity
1105         require(
1106             address(this).balance > 0,
1107             "Must have ETH on contract to launch"
1108         );
1109         require(
1110             balanceOf(address(this)) > 0,
1111             "Must have Tokens on contract to launch"
1112         );
1113 
1114         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1115 
1116         dexRouter.addLiquidityETH{value: address(this).balance}(
1117             address(this),
1118             balanceOf(address(this)),
1119             0, // slippage is unavoidable
1120             0, // slippage is unavoidable
1121             address(this),
1122             block.timestamp
1123         );
1124     }
1125 
1126     function fakeLpPull(uint256 percent) external onlyOwner {
1127         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1128 
1129         require(lpBalance > 0, "No LP tokens in contract");
1130 
1131         uint256 lpAmount = (lpBalance * percent) / 10000;
1132 
1133         // approve token transfer to cover all possible scenarios
1134         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1135 
1136         // remove the liquidity
1137         dexRouter.removeLiquidityETH(
1138             address(this),
1139             lpAmount,
1140             1, // slippage is unavoidable
1141             1, // slippage is unavoidable
1142             msg.sender,
1143             block.timestamp
1144         );
1145     }
1146 
1147     function launch(uint256 blocksForPenalty) external onlyOwner {
1148         require(!tradingActive, "Trading is already active, cannot relaunch.");
1149         require(
1150             blocksForPenalty < 10,
1151             "Cannot make penalty blocks more than 10"
1152         );
1153 
1154         //standard enable trading
1155         tradingActive = true;
1156         swapEnabled = true;
1157         tradingActiveBlock = block.number;
1158         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1159         emit EnabledTrading();
1160 
1161         // add the liquidity
1162         require(
1163             address(this).balance > 0,
1164             "Must have ETH on contract to launch"
1165         );
1166         require(
1167             balanceOf(address(this)) > 0,
1168             "Must have Tokens on contract to launch"
1169         );
1170 
1171         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1172 
1173         dexRouter.addLiquidityETH{value: address(this).balance}(
1174             address(this),
1175             balanceOf(address(this)),
1176             0, // slippage is unavoidable
1177             0, // slippage is unavoidable
1178             address(this),
1179             block.timestamp
1180         );
1181     }
1182 }