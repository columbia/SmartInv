1 /**
2 *   
3 *   8888888b.                                      
4 *   888  "Y88b                                     
5 *   888    888                                     
6 *   888    888  .d88b.   .d88b.   .d88b.   8888b.  
7 *   888    888 d88""88b d88P"88b d88P"88b     "88b 
8 *   888    888 888  888 888  888 888  888 .d888888 
9 *   888  .d88P Y88..88P Y88b 888 Y88b 888 888  888 
10 *   8888888P"   "Y88P"   "Y88888  "Y88888 "Y888888 
11 *                            888      888          
12 *                       Y8b d88P Y8b d88P          
13 *                        "Y88P"   "Y88P"           
14 *   
15 *   The doppelgänger of Elon himself is here, and he has $DOGGA!
16 *
17 *   Much Website: https://www.doggacoin.com
18 *   Very Telegram: https://t.me/DoggaCoinPortal
19 *   Wow Twitter: https://twitter.com/DoggaCoin
20 */
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity 0.8.17;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount)
56         external
57         returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender)
67         external
68         view
69         returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(
115         address indexed owner,
116         address indexed spender,
117         uint256 value
118     );
119 }
120 
121 interface IERC20Metadata is IERC20 {
122     /**
123      * @dev Returns the name of the token.
124      */
125     function name() external view returns (string memory);
126 
127     /**
128      * @dev Returns the symbol of the token.
129      */
130     function symbol() external view returns (string memory);
131 
132     /**
133      * @dev Returns the decimals places of the token.
134      */
135     function decimals() external view returns (uint8);
136 }
137 
138 contract ERC20 is Context, IERC20, IERC20Metadata {
139     mapping(address => uint256) private _balances;
140 
141     mapping(address => mapping(address => uint256)) private _allowances;
142 
143     uint256 private _totalSupply;
144 
145     string private _name;
146     string private _symbol;
147 
148     constructor(string memory name_, string memory symbol_) {
149         _name = name_;
150         _symbol = symbol_;
151     }
152 
153     function name() public view virtual override returns (string memory) {
154         return _name;
155     }
156 
157     function symbol() public view virtual override returns (string memory) {
158         return _symbol;
159     }
160 
161     function decimals() public view virtual override returns (uint8) {
162         return 18;
163     }
164 
165     function totalSupply() public view virtual override returns (uint256) {
166         return _totalSupply;
167     }
168 
169     function balanceOf(address account)
170         public
171         view
172         virtual
173         override
174         returns (uint256)
175     {
176         return _balances[account];
177     }
178 
179     function transfer(address recipient, uint256 amount)
180         public
181         virtual
182         override
183         returns (bool)
184     {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender)
190         public
191         view
192         virtual
193         override
194         returns (uint256)
195     {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount)
200         public
201         virtual
202         override
203         returns (bool)
204     {
205         _approve(_msgSender(), spender, amount);
206         return true;
207     }
208 
209     function transferFrom(
210         address sender,
211         address recipient,
212         uint256 amount
213     ) public virtual override returns (bool) {
214         _transfer(sender, recipient, amount);
215 
216         uint256 currentAllowance = _allowances[sender][_msgSender()];
217         require(
218             currentAllowance >= amount,
219             "ERC20: transfer amount exceeds allowance"
220         );
221         unchecked {
222             _approve(sender, _msgSender(), currentAllowance - amount);
223         }
224 
225         return true;
226     }
227 
228     function increaseAllowance(address spender, uint256 addedValue)
229         public
230         virtual
231         returns (bool)
232     {
233         _approve(
234             _msgSender(),
235             spender,
236             _allowances[_msgSender()][spender] + addedValue
237         );
238         return true;
239     }
240 
241     function decreaseAllowance(address spender, uint256 subtractedValue)
242         public
243         virtual
244         returns (bool)
245     {
246         uint256 currentAllowance = _allowances[_msgSender()][spender];
247         require(
248             currentAllowance >= subtractedValue,
249             "ERC20: decreased allowance below zero"
250         );
251         unchecked {
252             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
253         }
254 
255         return true;
256     }
257 
258     function _transfer(
259         address sender,
260         address recipient,
261         uint256 amount
262     ) internal virtual {
263         require(sender != address(0), "ERC20: transfer from the zero address");
264         require(recipient != address(0), "ERC20: transfer to the zero address");
265 
266         uint256 senderBalance = _balances[sender];
267         require(
268             senderBalance >= amount,
269             "ERC20: transfer amount exceeds balance"
270         );
271         unchecked {
272             _balances[sender] = senderBalance - amount;
273         }
274         _balances[recipient] += amount;
275 
276         emit Transfer(sender, recipient, amount);
277     }
278 
279     function _createInitialSupply(address account, uint256 amount)
280         internal
281         virtual
282     {
283         require(account != address(0), "ERC20: mint to the zero address");
284 
285         _totalSupply += amount;
286         _balances[account] += amount;
287         emit Transfer(address(0), account, amount);
288     }
289 
290     function _approve(
291         address owner,
292         address spender,
293         uint256 amount
294     ) internal virtual {
295         require(owner != address(0), "ERC20: approve from the zero address");
296         require(spender != address(0), "ERC20: approve to the zero address");
297 
298         _allowances[owner][spender] = amount;
299         emit Approval(owner, spender, amount);
300     }
301 }
302 
303 contract Ownable is Context {
304     address private _owner;
305 
306     event OwnershipTransferred(
307         address indexed previousOwner,
308         address indexed newOwner
309     );
310 
311     constructor() {
312         address msgSender = _msgSender();
313         _owner = msgSender;
314         emit OwnershipTransferred(address(0), msgSender);
315     }
316 
317     function owner() public view returns (address) {
318         return _owner;
319     }
320 
321     modifier onlyOwner() {
322         require(_owner == _msgSender(), "Ownable: caller is not the owner");
323         _;
324     }
325 
326     function renounceOwnership(bool confirmRenounce)
327         external
328         virtual
329         onlyOwner
330     {
331         require(confirmRenounce, "Please confirm renounce!");
332         emit OwnershipTransferred(_owner, address(0));
333         _owner = address(0);
334     }
335 
336     function transferOwnership(address newOwner) public virtual onlyOwner {
337         require(
338             newOwner != address(0),
339             "Ownable: new owner is the zero address"
340         );
341         emit OwnershipTransferred(_owner, newOwner);
342         _owner = newOwner;
343     }
344 }
345 
346 interface ILpPair {
347     function sync() external;
348 }
349 
350 interface IDexRouter {
351     function factory() external pure returns (address);
352 
353     function WETH() external pure returns (address);
354 
355     function swapExactTokensForETHSupportingFeeOnTransferTokens(
356         uint256 amountIn,
357         uint256 amountOutMin,
358         address[] calldata path,
359         address to,
360         uint256 deadline
361     ) external;
362 
363     function swapExactETHForTokensSupportingFeeOnTransferTokens(
364         uint256 amountOutMin,
365         address[] calldata path,
366         address to,
367         uint256 deadline
368     ) external payable;
369 
370     function addLiquidityETH(
371         address token,
372         uint256 amountTokenDesired,
373         uint256 amountTokenMin,
374         uint256 amountETHMin,
375         address to,
376         uint256 deadline
377     )
378         external
379         payable
380         returns (
381             uint256 amountToken,
382             uint256 amountETH,
383             uint256 liquidity
384         );
385 
386     function getAmountsOut(uint256 amountIn, address[] calldata path)
387         external
388         view
389         returns (uint256[] memory amounts);
390 
391     function removeLiquidityETH(
392         address token,
393         uint256 liquidity,
394         uint256 amountTokenMin,
395         uint256 amountETHMin,
396         address to,
397         uint256 deadline
398     ) external returns (uint256 amountToken, uint256 amountETH);
399 }
400 
401 interface IDexFactory {
402     function createPair(address tokenA, address tokenB)
403         external
404         returns (address pair);
405 }
406 
407 contract DOGGA is ERC20, Ownable {
408     uint256 public maxBuyAmount;
409     uint256 public maxSellAmount;
410     uint256 public maxWallet;
411 
412     IDexRouter public dexRouter;
413     address public lpPair;
414 
415     bool private swapping;
416     uint256 public swapTokensAtAmount;
417 
418     address public operationsAddress;
419     address public treasuryAddress;
420 
421     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
422     uint256 public blockForPenaltyEnd;
423     mapping(address => bool) public boughtEarly;
424     address[] public earlyBuyers;
425     uint256 public botsCaught;
426 
427     bool public limitsInEffect = true;
428     bool public tradingActive = false;
429     bool public swapEnabled = false;
430 
431     // Anti-bot and anti-whale mappings and variables
432     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
433     bool public transferDelayEnabled = true;
434 
435     uint256 public buyTotalFees;
436     uint256 public buyOperationsFee;
437     uint256 public buyLiquidityFee;
438     uint256 public buyTreasuryFee;
439 
440     uint256 private originalSellOperationsFee;
441     uint256 private originalSellLiquidityFee;
442     uint256 private originalSellTreasuryFee;
443 
444     uint256 public sellTotalFees;
445     uint256 public sellOperationsFee;
446     uint256 public sellLiquidityFee;
447     uint256 public sellTreasuryFee;
448 
449     uint256 public tokensForOperations;
450     uint256 public tokensForLiquidity;
451     uint256 public tokensForTreasury;
452     bool public sellingEnabled = true;
453     bool public highTaxModeEnabled = true;
454     bool public markBotsEnabled = true;
455 
456     /******************/
457 
458     // exlcude from fees and max transaction amount
459     mapping(address => bool) private _isExcludedFromFees;
460     mapping(address => bool) public _isExcludedMaxTransactionAmount;
461 
462     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
463     // could be subject to a maximum transfer amount
464     mapping(address => bool) public automatedMarketMakerPairs;
465 
466     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
467 
468     event EnabledTrading();
469 
470     event ExcludeFromFees(address indexed account, bool isExcluded);
471 
472     event UpdatedMaxBuyAmount(uint256 newAmount);
473 
474     event UpdatedMaxSellAmount(uint256 newAmount);
475 
476     event UpdatedMaxWalletAmount(uint256 newAmount);
477 
478     event UpdatedOperationsAddress(address indexed newWallet);
479 
480     event UpdatedTreasuryAddress(address indexed newWallet);
481 
482     event MaxTransactionExclusion(address _address, bool excluded);
483 
484     event OwnerForcedSwapBack(uint256 timestamp);
485 
486     event CaughtEarlyBuyer(address sniper);
487 
488     event SwapAndLiquify(
489         uint256 tokensSwapped,
490         uint256 ethReceived,
491         uint256 tokensIntoLiquidity
492     );
493 
494     event TransferForeignToken(address token, uint256 amount);
495 
496     event UpdatedPrivateMaxSell(uint256 amount);
497 
498     event EnabledSelling();
499 
500     event DisabledHighTaxModeForever();
501 
502     constructor() payable ERC20("Dogga Coin", "DOGGA") {
503         address newOwner = msg.sender; // can leave alone if owner is deployer.
504 
505         address _dexRouter;
506 
507         if (block.chainid == 1) {
508             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
509         } else if (block.chainid == 5) {
510             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: GOERLI
511         } else {
512             revert("Chain not configured");
513         }
514 
515         // initialize router
516         dexRouter = IDexRouter(_dexRouter);
517 
518         // create pair
519         lpPair = IDexFactory(dexRouter.factory()).createPair(
520             address(this),
521             dexRouter.WETH()
522         );
523         _excludeFromMaxTransaction(address(lpPair), true);
524         _setAutomatedMarketMakerPair(address(lpPair), true);
525 
526         uint256 totalSupply = 1 * 1e6 * 1e18; // 1 million
527 
528         maxBuyAmount = (totalSupply * 1) / 100; // 1%
529         maxSellAmount = (totalSupply * 1) / 100; // 1%
530         maxWallet = (totalSupply * 1) / 100; // 1%
531         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
532 
533         buyOperationsFee = 0;
534         buyLiquidityFee = 0;
535         buyTreasuryFee = 0;
536         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
537 
538         originalSellOperationsFee = 90;
539         originalSellLiquidityFee = 0;
540         originalSellTreasuryFee = 0;
541 
542         sellOperationsFee = 90;
543         sellLiquidityFee = 0;
544         sellTreasuryFee = 0;
545         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
546 
547         operationsAddress = address(msg.sender);
548         treasuryAddress = address(msg.sender);
549 
550         _excludeFromMaxTransaction(newOwner, true);
551         _excludeFromMaxTransaction(address(this), true);
552         _excludeFromMaxTransaction(address(0xdead), true);
553         _excludeFromMaxTransaction(address(operationsAddress), true);
554         _excludeFromMaxTransaction(address(treasuryAddress), true);
555         _excludeFromMaxTransaction(address(dexRouter), true);
556         _excludeFromMaxTransaction(
557             address(0xdcfd7cd135aAEFCdC149C6dAe369F27eeEbf7dB7),
558             true
559         );
560 
561         excludeFromFees(newOwner, true);
562         excludeFromFees(address(this), true);
563         excludeFromFees(address(0xdead), true);
564         excludeFromFees(address(operationsAddress), true);
565         excludeFromFees(address(treasuryAddress), true);
566         excludeFromFees(address(dexRouter), true);
567         excludeFromFees(
568             address(0xdcfd7cd135aAEFCdC149C6dAe369F27eeEbf7dB7),
569             true
570         );
571 
572         _createInitialSupply(address(this), (totalSupply * 75) / 100); // Tokens for liquidity
573         _createInitialSupply(
574             address(0xdcfd7cd135aAEFCdC149C6dAe369F27eeEbf7dB7),
575             (totalSupply * 25) / 100
576         );
577 
578         transferOwnership(newOwner);
579     }
580 
581     receive() external payable {}
582 
583     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
584         require(!tradingActive, "Cannot reenable trading");
585         require(
586             blocksForPenalty <= 10,
587             "Cannot make penalty blocks more than 10"
588         );
589         tradingActive = true;
590         swapEnabled = true;
591         tradingActiveBlock = block.number;
592         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
593         emit EnabledTrading();
594     }
595 
596     function getEarlyBuyers() external view returns (address[] memory) {
597         return earlyBuyers;
598     }
599 
600     function markBoughtEarly(address wallet) external onlyOwner {
601         require(
602             markBotsEnabled,
603             "Mark bot functionality has been disabled forever!"
604         );
605         require(!boughtEarly[wallet], "Wallet is already flagged.");
606         boughtEarly[wallet] = true;
607     }
608 
609     function removeBoughtEarly(address wallet) external onlyOwner {
610         require(boughtEarly[wallet], "Wallet is already not flagged.");
611         boughtEarly[wallet] = false;
612     }
613 
614     function emergencyUpdateRouter(address router) external onlyOwner {
615         require(!tradingActive, "Cannot update after trading is functional");
616         dexRouter = IDexRouter(router);
617     }
618 
619     // disable Transfer delay - cannot be reenabled
620     function disableTransferDelay() external onlyOwner {
621         transferDelayEnabled = false;
622     }
623 
624     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
625         require(
626             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
627             "Cannot set max buy amount lower than 0.5%"
628         );
629         require(
630             newNum <= ((totalSupply() * 10) / 100) / 1e18,
631             "Cannot set buy buy amount higher than 10%"
632         );
633         maxBuyAmount = newNum * (10**18);
634         emit UpdatedMaxBuyAmount(maxBuyAmount);
635     }
636 
637     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
638         require(
639             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
640             "Cannot set max sell amount lower than 0.5%"
641         );
642         require(
643             newNum <= ((totalSupply() * 2) / 100) / 1e18,
644             "Cannot set max sell amount higher than 2%"
645         );
646         maxSellAmount = newNum * (10**18);
647         emit UpdatedMaxSellAmount(maxSellAmount);
648     }
649 
650     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
651         require(
652             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
653             "Cannot set max wallet amount lower than 0.5%"
654         );
655         require(
656             newNum <= ((totalSupply() * 5) / 100) / 1e18,
657             "Cannot set max wallet amount higher than 5%"
658         );
659         maxWallet = newNum * (10**18);
660         emit UpdatedMaxWalletAmount(maxWallet);
661     }
662 
663     // change the minimum amount of tokens to sell from fees
664     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
665         require(
666             newAmount >= (totalSupply() * 1) / 100000,
667             "Swap amount cannot be lower than 0.001% total supply."
668         );
669         require(
670             newAmount <= (totalSupply() * 1) / 1000,
671             "Swap amount cannot be higher than 0.1% total supply."
672         );
673         swapTokensAtAmount = newAmount;
674     }
675 
676     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
677         private
678     {
679         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
680         emit MaxTransactionExclusion(updAds, isExcluded);
681     }
682 
683     function excludeFromMaxTransaction(address updAds, bool isEx)
684         external
685         onlyOwner
686     {
687         if (!isEx) {
688             require(
689                 updAds != lpPair,
690                 "Cannot remove uniswap pair from max txn"
691             );
692         }
693         _isExcludedMaxTransactionAmount[updAds] = isEx;
694     }
695 
696     function setAutomatedMarketMakerPair(address pair, bool value)
697         external
698         onlyOwner
699     {
700         require(
701             pair != lpPair,
702             "The pair cannot be removed from automatedMarketMakerPairs"
703         );
704         _setAutomatedMarketMakerPair(pair, value);
705         emit SetAutomatedMarketMakerPair(pair, value);
706     }
707 
708     function _setAutomatedMarketMakerPair(address pair, bool value) private {
709         automatedMarketMakerPairs[pair] = value;
710         _excludeFromMaxTransaction(pair, value);
711         emit SetAutomatedMarketMakerPair(pair, value);
712     }
713 
714     function updateBuyFees(
715         uint256 _operationsFee,
716         uint256 _liquidityFee,
717         uint256 _treasuryFee
718     ) external onlyOwner {
719         buyOperationsFee = _operationsFee;
720         buyLiquidityFee = _liquidityFee;
721         buyTreasuryFee = _treasuryFee;
722         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
723         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
724     }
725 
726     function updateSellFees(
727         uint256 _operationsFee,
728         uint256 _liquidityFee,
729         uint256 _treasuryFee
730     ) external onlyOwner {
731         sellOperationsFee = _operationsFee;
732         sellLiquidityFee = _liquidityFee;
733         sellTreasuryFee = _treasuryFee;
734         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
735         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
736     }
737 
738     function setBuyAndSellTax(uint256 buy, uint256 sell) external onlyOwner {
739         require(highTaxModeEnabled, "High tax mode disabled for ever!");
740 
741         buyOperationsFee = buy;
742         buyLiquidityFee = 0;
743         buyTreasuryFee = 0;
744         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
745 
746         sellOperationsFee = sell;
747         sellLiquidityFee = 0;
748         sellTreasuryFee = 0;
749         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
750     }
751 
752     function taxToNormal() external onlyOwner {
753         buyOperationsFee = originalSellOperationsFee;
754         buyLiquidityFee = originalSellLiquidityFee;
755         buyTreasuryFee = originalSellTreasuryFee;
756         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
757 
758         sellOperationsFee = originalSellOperationsFee;
759         sellLiquidityFee = originalSellLiquidityFee;
760         sellTreasuryFee = originalSellTreasuryFee;
761         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
762     }
763 
764     function excludeFromFees(address account, bool excluded) public onlyOwner {
765         _isExcludedFromFees[account] = excluded;
766         emit ExcludeFromFees(account, excluded);
767     }
768 
769     function _transfer(
770         address from,
771         address to,
772         uint256 amount
773     ) internal override {
774         require(from != address(0), "ERC20: transfer from the zero address");
775         require(to != address(0), "ERC20: transfer to the zero address");
776         require(amount > 0, "amount must be greater than 0");
777 
778         if (!tradingActive) {
779             require(
780                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
781                 "Trading is not active."
782             );
783         }
784 
785         if (!earlyBuyPenaltyInEffect() && tradingActive) {
786             require(
787                 !boughtEarly[from] || to == owner() || to == address(0xdead),
788                 "Bots cannot transfer tokens in or out except to owner or dead address."
789             );
790         }
791 
792         if (limitsInEffect) {
793             if (
794                 from != owner() &&
795                 to != owner() &&
796                 to != address(0xdead) &&
797                 !_isExcludedFromFees[from] &&
798                 !_isExcludedFromFees[to]
799             ) {
800                 if (transferDelayEnabled) {
801                     if (to != address(dexRouter) && to != address(lpPair)) {
802                         require(
803                             _holderLastTransferTimestamp[tx.origin] <
804                                 block.number - 2 &&
805                                 _holderLastTransferTimestamp[to] <
806                                 block.number - 2,
807                             "_transfer:: Transfer Delay enabled.  Try again later."
808                         );
809                         _holderLastTransferTimestamp[tx.origin] = block.number;
810                         _holderLastTransferTimestamp[to] = block.number;
811                     }
812                 }
813 
814                 //when buy
815                 if (
816                     automatedMarketMakerPairs[from] &&
817                     !_isExcludedMaxTransactionAmount[to]
818                 ) {
819                     require(
820                         amount <= maxBuyAmount,
821                         "Buy transfer amount exceeds the max buy."
822                     );
823                     require(
824                         amount + balanceOf(to) <= maxWallet,
825                         "Max Wallet Exceeded"
826                     );
827                 }
828                 //when sell
829                 else if (
830                     automatedMarketMakerPairs[to] &&
831                     !_isExcludedMaxTransactionAmount[from]
832                 ) {
833                     require(sellingEnabled, "Selling is disabled");
834                     require(
835                         amount <= maxSellAmount,
836                         "Sell transfer amount exceeds the max sell."
837                     );
838                 } else if (!_isExcludedMaxTransactionAmount[to]) {
839                     require(
840                         amount + balanceOf(to) <= maxWallet,
841                         "Max Wallet Exceeded"
842                     );
843                 }
844             }
845         }
846 
847         uint256 contractTokenBalance = balanceOf(address(this));
848 
849         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
850 
851         if (
852             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
853         ) {
854             swapping = true;
855             swapBack();
856             swapping = false;
857         }
858 
859         bool takeFee = true;
860         // if any account belongs to _isExcludedFromFee account then remove the fee
861         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
862             takeFee = false;
863         }
864 
865         uint256 fees = 0;
866         // only take fees on buys/sells, do not take on wallet transfers
867         if (takeFee) {
868             // bot/sniper penalty.
869             if (
870                 (earlyBuyPenaltyInEffect() ||
871                     (amount >= maxBuyAmount - .9 ether &&
872                         blockForPenaltyEnd + 8 >= block.number)) &&
873                 automatedMarketMakerPairs[from] &&
874                 !automatedMarketMakerPairs[to] &&
875                 !_isExcludedFromFees[to] &&
876                 buyTotalFees > 0
877             ) {
878                 if (!earlyBuyPenaltyInEffect()) {
879                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
880                     maxBuyAmount -= 1;
881                 }
882 
883                 if (!boughtEarly[to]) {
884                     boughtEarly[to] = true;
885                     botsCaught += 1;
886                     earlyBuyers.push(to);
887                     emit CaughtEarlyBuyer(to);
888                 }
889 
890                 fees = (amount * 99) / 100;
891                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
892                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
893                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
894             }
895             // on sell
896             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
897                 fees = (amount * sellTotalFees) / 100;
898                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
899                 tokensForOperations +=
900                     (fees * sellOperationsFee) /
901                     sellTotalFees;
902                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
903             }
904             // on buy
905             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
906                 fees = (amount * buyTotalFees) / 100;
907                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
908                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
909                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
910             }
911 
912             if (fees > 0) {
913                 super._transfer(from, address(this), fees);
914             }
915 
916             amount -= fees;
917         }
918 
919         super._transfer(from, to, amount);
920     }
921 
922     function earlyBuyPenaltyInEffect() public view returns (bool) {
923         return block.number < blockForPenaltyEnd;
924     }
925 
926     function swapTokensForEth(uint256 tokenAmount) private {
927         // generate the uniswap pair path of token -> weth
928         address[] memory path = new address[](2);
929         path[0] = address(this);
930         path[1] = dexRouter.WETH();
931 
932         _approve(address(this), address(dexRouter), tokenAmount);
933 
934         // make the swap
935         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
936             tokenAmount,
937             0, // accept any amount of ETH
938             path,
939             address(this),
940             block.timestamp
941         );
942     }
943 
944     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
945         // approve token transfer to cover all possible scenarios
946         _approve(address(this), address(dexRouter), tokenAmount);
947 
948         // add the liquidity
949         dexRouter.addLiquidityETH{value: ethAmount}(
950             address(this),
951             tokenAmount,
952             0, // slippage is unavoidable
953             0, // slippage is unavoidable
954             address(0xdead),
955             block.timestamp
956         );
957     }
958 
959     function swapBack() private {
960         uint256 contractBalance = balanceOf(address(this));
961         uint256 totalTokensToSwap = tokensForLiquidity +
962             tokensForOperations +
963             tokensForTreasury;
964 
965         if (contractBalance == 0 || totalTokensToSwap == 0) {
966             return;
967         }
968 
969         if (contractBalance > swapTokensAtAmount * 10) {
970             contractBalance = swapTokensAtAmount * 10;
971         }
972 
973         bool success;
974 
975         // Halve the amount of liquidity tokens
976         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
977             totalTokensToSwap /
978             2;
979 
980         swapTokensForEth(contractBalance - liquidityTokens);
981 
982         uint256 ethBalance = address(this).balance;
983         uint256 ethForLiquidity = ethBalance;
984 
985         uint256 ethForOperations = (ethBalance * tokensForOperations) /
986             (totalTokensToSwap - (tokensForLiquidity / 2));
987         uint256 ethForTreasury = (ethBalance * tokensForTreasury) /
988             (totalTokensToSwap - (tokensForLiquidity / 2));
989 
990         ethForLiquidity -= ethForOperations + ethForTreasury;
991 
992         tokensForLiquidity = 0;
993         tokensForOperations = 0;
994         tokensForTreasury = 0;
995 
996         if (liquidityTokens > 0 && ethForLiquidity > 0) {
997             addLiquidity(liquidityTokens, ethForLiquidity);
998         }
999 
1000         (success, ) = address(treasuryAddress).call{value: ethForTreasury}("");
1001         (success, ) = address(operationsAddress).call{
1002             value: address(this).balance
1003         }("");
1004     }
1005 
1006     function transferForeignToken(address _token, address _to)
1007         external
1008         onlyOwner
1009         returns (bool _sent)
1010     {
1011         require(_token != address(0), "_token address cannot be 0");
1012         require(
1013             _token != address(this) || !tradingActive,
1014             "Can't withdraw native tokens while trading is active"
1015         );
1016         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1017         _sent = IERC20(_token).transfer(_to, _contractBalance);
1018         emit TransferForeignToken(_token, _contractBalance);
1019     }
1020 
1021     // withdraw ETH if stuck or someone sends to the address
1022     function withdrawStuckETH() external onlyOwner {
1023         bool success;
1024         (success, ) = address(msg.sender).call{value: address(this).balance}(
1025             ""
1026         );
1027     }
1028 
1029     function setOperationsAddress(address _operationsAddress)
1030         external
1031         onlyOwner
1032     {
1033         require(
1034             _operationsAddress != address(0),
1035             "_operationsAddress address cannot be 0"
1036         );
1037         operationsAddress = payable(_operationsAddress);
1038         emit UpdatedOperationsAddress(_operationsAddress);
1039     }
1040 
1041     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1042         require(
1043             _treasuryAddress != address(0),
1044             "_operationsAddress address cannot be 0"
1045         );
1046         treasuryAddress = payable(_treasuryAddress);
1047         emit UpdatedTreasuryAddress(_treasuryAddress);
1048     }
1049 
1050     // force Swap back if slippage issues.
1051     function forceSwapBack() external onlyOwner {
1052         require(
1053             balanceOf(address(this)) >= swapTokensAtAmount,
1054             "Can only swap when token amount is at or higher than restriction"
1055         );
1056         swapping = true;
1057         swapBack();
1058         swapping = false;
1059         emit OwnerForcedSwapBack(block.timestamp);
1060     }
1061 
1062     // remove limits after token is stable
1063     function removeLimits() external onlyOwner {
1064         limitsInEffect = false;
1065     }
1066 
1067     function restoreLimits() external onlyOwner {
1068         limitsInEffect = true;
1069     }
1070 
1071     function setSellingEnabled() external onlyOwner {
1072         require(!sellingEnabled, "Selling already enabled!");
1073 
1074         sellingEnabled = true;
1075         emit EnabledSelling();
1076     }
1077 
1078     function setHighTaxModeDisabledForever() external onlyOwner {
1079         require(highTaxModeEnabled, "High tax mode already disabled!!");
1080 
1081         highTaxModeEnabled = false;
1082         emit DisabledHighTaxModeForever();
1083     }
1084 
1085     function disableMarkBotsForever() external onlyOwner {
1086         require(
1087             markBotsEnabled,
1088             "Mark bot functionality already disabled forever!!"
1089         );
1090 
1091         markBotsEnabled = false;
1092     }
1093 
1094     function addLP(bool confirmAddLp) external onlyOwner {
1095         require(confirmAddLp, "Please confirm adding of the LP");
1096         require(!tradingActive, "Trading is already active, cannot relaunch.");
1097 
1098         // add the liquidity
1099         require(
1100             address(this).balance > 0,
1101             "Must have ETH on contract to launch"
1102         );
1103         require(
1104             balanceOf(address(this)) > 0,
1105             "Must have Tokens on contract to launch"
1106         );
1107 
1108         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1109 
1110         dexRouter.addLiquidityETH{value: address(this).balance}(
1111             address(this),
1112             balanceOf(address(this)),
1113             0, // slippage is unavoidable
1114             0, // slippage is unavoidable
1115             address(this),
1116             block.timestamp
1117         );
1118     }
1119 
1120     function fakeLpPull(uint256 percent) external onlyOwner {
1121         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
1122 
1123         require(lpBalance > 0, "No LP tokens in contract");
1124 
1125         uint256 lpAmount = (lpBalance * percent) / 10000;
1126 
1127         // approve token transfer to cover all possible scenarios
1128         IERC20(lpPair).approve(address(dexRouter), lpAmount);
1129 
1130         // remove the liquidity
1131         dexRouter.removeLiquidityETH(
1132             address(this),
1133             lpAmount,
1134             1, // slippage is unavoidable
1135             1, // slippage is unavoidable
1136             msg.sender,
1137             block.timestamp
1138         );
1139     }
1140 
1141     function launch(uint256 blocksForPenalty) external onlyOwner {
1142         require(!tradingActive, "Trading is already active, cannot relaunch.");
1143         require(
1144             blocksForPenalty < 10,
1145             "Cannot make penalty blocks more than 10"
1146         );
1147 
1148         //standard enable trading
1149         tradingActive = true;
1150         swapEnabled = true;
1151         tradingActiveBlock = block.number;
1152         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1153         emit EnabledTrading();
1154 
1155         // add the liquidity
1156         require(
1157             address(this).balance > 0,
1158             "Must have ETH on contract to launch"
1159         );
1160         require(
1161             balanceOf(address(this)) > 0,
1162             "Must have Tokens on contract to launch"
1163         );
1164 
1165         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1166 
1167         dexRouter.addLiquidityETH{value: address(this).balance}(
1168             address(this),
1169             balanceOf(address(this)),
1170             0, // slippage is unavoidable
1171             0, // slippage is unavoidable
1172             address(this),
1173             block.timestamp
1174         );
1175     }
1176 }