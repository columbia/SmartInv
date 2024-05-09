1 // SPDX-License-Identifier: MIT
2 /*                                                            
3                                                  
4                 _____                    _____            _____                    _____          
5                 /\    \                  /\    \          /\    \                  /\    \         
6                 /::\    \                /::\____\        /::\    \                /::\    \        
7             /::::\    \              /:::/    /       /::::\    \              /::::\    \       
8             /::::::\    \            /:::/    /       /::::::\    \            /::::::\    \      
9             /:::/\:::\    \          /:::/    /       /:::/\:::\    \          /:::/\:::\    \     
10             /:::/__\:::\    \        /:::/    /       /:::/__\:::\    \        /:::/__\:::\    \    
11         /::::\   \:::\    \      /:::/    /        \:::\   \:::\    \      /::::\   \:::\    \   
12         /::::::\   \:::\    \    /:::/    /       ___\:::\   \:::\    \    /::::::\   \:::\    \  
13         /:::/\:::\   \:::\____\  /:::/    /       /\   \:::\   \:::\    \  /:::/\:::\   \:::\    \ 
14         /:::/  \:::\   \:::|    |/:::/____/       /::\   \:::\   \:::\____\/:::/  \:::\   \:::\____\
15         \::/    \:::\  /:::|____|\:::\    \       \:::\   \:::\   \::/    /\::/    \:::\  /:::/    /
16         \/_____/\:::\/:::/    /  \:::\    \       \:::\   \:::\   \/____/  \/____/ \:::\/:::/    / 
17                 \::::::/    /    \:::\    \       \:::\   \:::\    \               \::::::/    /  
18                 \::::/    /      \:::\    \       \:::\   \:::\____\               \::::/    /   
19                     \::/____/        \:::\    \       \:::\  /:::/    /               /:::/    /    
20                     ~~               \:::\    \       \:::\/:::/    /               /:::/    /     
21                                     \:::\    \       \::::::/    /               /:::/    /      
22                                         \:::\____\       \::::/    /               /:::/    /       
23                                         \::/    /        \::/    /                \::/    /        
24                                         \/____/          \/____/                  \/____/         
25                                                                                                     
26                                                                                                                                                                                                 
27 */
28 
29 pragma solidity 0.8.13;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount)
61         external
62         returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender)
72         external
73         view
74         returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `sender` to `recipient` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(
120         address indexed owner,
121         address indexed spender,
122         uint256 value
123     );
124 }
125 
126 interface IERC20Metadata is IERC20 {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 
143 contract ERC20 is Context, IERC20, IERC20Metadata {
144     mapping(address => uint256) private _balances;
145 
146     mapping(address => mapping(address => uint256)) private _allowances;
147 
148     uint256 private _totalSupply;
149 
150     string private _name;
151     string private _symbol;
152 
153     constructor(string memory name_, string memory symbol_) {
154         _name = name_;
155         _symbol = symbol_;
156     }
157 
158     function name() public view virtual override returns (string memory) {
159         return _name;
160     }
161 
162     function symbol() public view virtual override returns (string memory) {
163         return _symbol;
164     }
165 
166     function decimals() public view virtual override returns (uint8) {
167         return 18;
168     }
169 
170     function totalSupply() public view virtual override returns (uint256) {
171         return _totalSupply;
172     }
173 
174     function balanceOf(address account)
175         public
176         view
177         virtual
178         override
179         returns (uint256)
180     {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount)
185         public
186         virtual
187         override
188         returns (bool)
189     {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender)
195         public
196         view
197         virtual
198         override
199         returns (uint256)
200     {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount)
205         public
206         virtual
207         override
208         returns (bool)
209     {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(
215         address sender,
216         address recipient,
217         uint256 amount
218     ) public virtual override returns (bool) {
219         _transfer(sender, recipient, amount);
220 
221         uint256 currentAllowance = _allowances[sender][_msgSender()];
222         require(
223             currentAllowance >= amount,
224             "ERC20: transfer amount exceeds allowance"
225         );
226         unchecked {
227             _approve(sender, _msgSender(), currentAllowance - amount);
228         }
229 
230         return true;
231     }
232 
233     function increaseAllowance(address spender, uint256 addedValue)
234         public
235         virtual
236         returns (bool)
237     {
238         _approve(
239             _msgSender(),
240             spender,
241             _allowances[_msgSender()][spender] + addedValue
242         );
243         return true;
244     }
245 
246     function decreaseAllowance(address spender, uint256 subtractedValue)
247         public
248         virtual
249         returns (bool)
250     {
251         uint256 currentAllowance = _allowances[_msgSender()][spender];
252         require(
253             currentAllowance >= subtractedValue,
254             "ERC20: decreased allowance below zero"
255         );
256         unchecked {
257             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
258         }
259 
260         return true;
261     }
262 
263     function _transfer(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) internal virtual {
268         require(sender != address(0), "ERC20: transfer from the zero address");
269         require(recipient != address(0), "ERC20: transfer to the zero address");
270 
271         uint256 senderBalance = _balances[sender];
272         require(
273             senderBalance >= amount,
274             "ERC20: transfer amount exceeds balance"
275         );
276         unchecked {
277             _balances[sender] = senderBalance - amount;
278         }
279         _balances[recipient] += amount;
280 
281         emit Transfer(sender, recipient, amount);
282     }
283 
284     function _createInitialSupply(address account, uint256 amount)
285         internal
286         virtual
287     {
288         require(account != address(0), "ERC20: mint to the zero address");
289 
290         _totalSupply += amount;
291         _balances[account] += amount;
292         emit Transfer(address(0), account, amount);
293     }
294 
295     function _approve(
296         address owner,
297         address spender,
298         uint256 amount
299     ) internal virtual {
300         require(owner != address(0), "ERC20: approve from the zero address");
301         require(spender != address(0), "ERC20: approve to the zero address");
302 
303         _allowances[owner][spender] = amount;
304         emit Approval(owner, spender, amount);
305     }
306 }
307 
308 contract Ownable is Context {
309     address private _owner;
310 
311     event OwnershipTransferred(
312         address indexed previousOwner,
313         address indexed newOwner
314     );
315 
316     constructor() {
317         address msgSender = _msgSender();
318         _owner = msgSender;
319         emit OwnershipTransferred(address(0), msgSender);
320     }
321 
322     function owner() public view returns (address) {
323         return _owner;
324     }
325 
326     modifier onlyOwner() {
327         require(_owner == _msgSender(), "Ownable: caller is not the owner");
328         _;
329     }
330 
331     function renounceOwnership() external virtual onlyOwner {
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
390 }
391 
392 interface IDexFactory {
393     function createPair(address tokenA, address tokenB)
394         external
395         returns (address pair);
396 }
397 
398 contract PulseApeCoin is ERC20, Ownable {
399     uint256 public maxBuyAmount;
400     uint256 public maxSellAmount;
401     uint256 public maxWallet;
402 
403     IDexRouter public dexRouter;
404     address public lpPair;
405 
406     bool private swapping;
407     uint256 public swapTokensAtAmount;
408 
409     address public operationsAddress;
410     address public treasuryAddress;
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
421 
422     // Anti-bot and anti-whale mappings and variables
423     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
424     bool public transferDelayEnabled = true;
425 
426     uint256 public buyTotalFees;
427     uint256 public buyOperationsFee;
428     uint256 public buyLiquidityFee;
429     uint256 public buyTreasuryFee;
430 
431     uint256 private originalSellOperationsFee;
432     uint256 private originalSellLiquidityFee;
433     uint256 private originalSellTreasuryFee;
434 
435     uint256 public sellTotalFees;
436     uint256 public sellOperationsFee;
437     uint256 public sellLiquidityFee;
438     uint256 public sellTreasuryFee;
439 
440     uint256 public tokensForOperations;
441     uint256 public tokensForLiquidity;
442     uint256 public tokensForTreasury;
443 
444     /******************/
445 
446     // exlcude from fees and max transaction amount
447     mapping(address => bool) private _isExcludedFromFees;
448     mapping(address => bool) public _isExcludedMaxTransactionAmount;
449 
450     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
451     // could be subject to a maximum transfer amount
452     mapping(address => bool) public automatedMarketMakerPairs;
453 
454     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
455 
456     event EnabledTrading();
457 
458     event ExcludeFromFees(address indexed account, bool isExcluded);
459 
460     event UpdatedMaxBuyAmount(uint256 newAmount);
461 
462     event UpdatedMaxSellAmount(uint256 newAmount);
463 
464     event UpdatedMaxWalletAmount(uint256 newAmount);
465 
466     event UpdatedOperationsAddress(address indexed newWallet);
467 
468     event UpdatedTreasuryAddress(address indexed newWallet);
469 
470     event MaxTransactionExclusion(address _address, bool excluded);
471 
472     event OwnerForcedSwapBack(uint256 timestamp);
473 
474     event CaughtEarlyBuyer(address sniper);
475 
476     event SwapAndLiquify(
477         uint256 tokensSwapped,
478         uint256 ethReceived,
479         uint256 tokensIntoLiquidity
480     );
481 
482     event TransferForeignToken(address token, uint256 amount);
483 
484     event UpdatedPrivateMaxSell(uint256 amount);
485 
486 
487     constructor() payable ERC20("PulseApeCoin", "PLSA") {
488         address newOwner = msg.sender; // Deployer is the owner
489 
490         // initialize router
491         IDexRouter _dexRouter = IDexRouter(
492             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
493         );
494         dexRouter = _dexRouter;
495 
496         lpPair = IDexFactory(dexRouter.factory()).createPair(
497             address(this),
498             dexRouter.WETH()
499         );
500         _excludeFromMaxTransaction(address(lpPair), true);
501         _setAutomatedMarketMakerPair(address(lpPair), true);
502 
503         uint256 totalSupply = 10000000 * 1e18;
504 
505         maxBuyAmount = (totalSupply * 8) / 1000; // 0.8%
506         maxSellAmount = (totalSupply * 8) / 1000; // 0.8%
507         maxWallet = (totalSupply * 2) / 100; // 2%
508         swapTokensAtAmount = (totalSupply * 2) / 10000; // 0.02 %
509 
510         buyOperationsFee = 2;
511         buyLiquidityFee = 1;
512         buyTreasuryFee = 0;
513         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
514 
515         originalSellOperationsFee = 2;
516         originalSellLiquidityFee = 1;
517         originalSellTreasuryFee = 0;
518 
519         sellOperationsFee = 2;
520         sellLiquidityFee = 1;
521         sellTreasuryFee = 0;
522         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
523 
524         operationsAddress = address(0x6f945F2Db1eE3aB1D34443F8C4c1500f41ab68B5);
525         treasuryAddress = address(0x6f945F2Db1eE3aB1D34443F8C4c1500f41ab68B5);
526 
527         _excludeFromMaxTransaction(newOwner, true);
528         _excludeFromMaxTransaction(address(this), true);
529         _excludeFromMaxTransaction(address(0xdead), true);
530         _excludeFromMaxTransaction(address(operationsAddress), true);
531         _excludeFromMaxTransaction(address(treasuryAddress), true);
532 
533         excludeFromFees(newOwner, true);
534         excludeFromFees(address(this), true);
535         excludeFromFees(address(0xdead), true);
536         excludeFromFees(address(operationsAddress), true);
537         excludeFromFees(address(treasuryAddress), true);
538 
539         _createInitialSupply(address(0xdead), (totalSupply * 80) / 100);
540         _createInitialSupply(address(this), (totalSupply * 20) / 100);
541 
542         transferOwnership(newOwner);
543     }
544 
545     receive() external payable {}
546 
547     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
548         require(!tradingActive, "Cannot reenable trading");
549         require(
550             blocksForPenalty <= 10,
551             "Cannot make penalty blocks more than 10"
552         );
553         tradingActive = true;
554         swapEnabled = true;
555         tradingActiveBlock = block.number;
556         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
557         emit EnabledTrading();
558     }
559 
560     function getEarlyBuyers() external view returns (address[] memory) {
561         return earlyBuyers;
562     }
563 
564     function removeBoughtEarly(address wallet) external onlyOwner {
565         require(boughtEarly[wallet], "Wallet is already not flagged.");
566         boughtEarly[wallet] = false;
567     }
568 
569     function emergencyUpdateRouter(address router) external onlyOwner {
570         require(!tradingActive, "Cannot update after trading is functional");
571         dexRouter = IDexRouter(router);
572     }
573 
574     // disable Transfer delay - cannot be reenabled
575     function disableTransferDelay() external onlyOwner {
576         transferDelayEnabled = false;
577     }
578 
579     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
580         require(
581             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
582             "Cannot set max buy amount lower than 0.01%"
583         );
584         require(
585             newNum <= ((totalSupply() * 2) / 100) / 1e18,
586             "Cannot set max buy amount higher than 2%"
587         );
588         maxBuyAmount = newNum * (1e18);
589         emit UpdatedMaxBuyAmount(maxBuyAmount);
590     }
591 
592     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
593         require(
594             newNum >= ((totalSupply() * 1) / 10000) / 1e18,
595             "Cannot set max sell amount lower than 0.01%"
596         );
597         require(
598             newNum <= ((totalSupply() * 2) / 100) / 1e18,
599             "Cannot set max sell amount higher than 2%"
600         );
601         maxSellAmount = newNum * (1e18);
602         emit UpdatedMaxSellAmount(maxSellAmount);
603     }
604 
605     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
606         require(
607             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
608             "Cannot set max wallet amount lower than 0.5%"
609         );
610         require(
611             newNum <= ((totalSupply() * 3) / 100) / 1e18,
612             "Cannot set max wallet amount higher than 3%"
613         );
614         maxWallet = newNum * (1e18);
615         emit UpdatedMaxWalletAmount(maxWallet);
616     }
617 
618     // change the minimum amount of tokens to sell from fees
619     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
620         require(
621             newAmount >= (totalSupply() * 1) / 100000,
622             "Swap amount cannot be lower than 0.001% total supply."
623         );
624         require(
625             newAmount <= (totalSupply() * 1) / 1000,
626             "Swap amount cannot be higher than 0.1% total supply."
627         );
628         swapTokensAtAmount = newAmount;
629     }
630 
631     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
632         private
633     {
634         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
635         emit MaxTransactionExclusion(updAds, isExcluded);
636     }
637 
638     function airdropToWallets(
639         address[] memory wallets,
640         uint256[] memory amountsInTokens
641     ) external onlyOwner {
642         require(
643             wallets.length == amountsInTokens.length,
644             "arrays must be the same length"
645         );
646         require(
647             wallets.length < 200,
648             "Can only airdrop 200 wallets per txn due to gas limits"
649         ); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
650         for (uint256 i = 0; i < wallets.length; i++) {
651             address wallet = wallets[i];
652             uint256 amount = amountsInTokens[i];
653             super._transfer(msg.sender, wallet, amount);
654         }
655     }
656 
657     function excludeFromMaxTransaction(address updAds, bool isEx)
658         external
659         onlyOwner
660     {
661         if (!isEx) {
662             require(
663                 updAds != lpPair,
664                 "Cannot remove uniswap pair from max txn"
665             );
666         }
667         _isExcludedMaxTransactionAmount[updAds] = isEx;
668     }
669 
670     function setAutomatedMarketMakerPair(address pair, bool value)
671         external
672         onlyOwner
673     {
674         require(
675             pair != lpPair,
676             "The pair cannot be removed from automatedMarketMakerPairs"
677         );
678         _setAutomatedMarketMakerPair(pair, value);
679         emit SetAutomatedMarketMakerPair(pair, value);
680     }
681 
682     function _setAutomatedMarketMakerPair(address pair, bool value) private {
683         automatedMarketMakerPairs[pair] = value;
684         _excludeFromMaxTransaction(pair, value);
685         emit SetAutomatedMarketMakerPair(pair, value);
686     }
687 
688     function updateBuyFees(
689         uint256 _operationsFee,
690         uint256 _liquidityFee,
691         uint256 _treasuryFee
692     ) external onlyOwner {
693         buyOperationsFee = _operationsFee;
694         buyLiquidityFee = _liquidityFee;
695         buyTreasuryFee = _treasuryFee;
696         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTreasuryFee;
697         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
698     }
699 
700     function updateSellFees(
701         uint256 _operationsFee,
702         uint256 _liquidityFee,
703         uint256 _treasuryFee
704     ) external onlyOwner {
705         sellOperationsFee = _operationsFee;
706         sellLiquidityFee = _liquidityFee;
707         sellTreasuryFee = _treasuryFee;
708         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
709         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
710     }
711 
712     function restoreTaxes() external onlyOwner {
713         sellOperationsFee = originalSellOperationsFee;
714         sellLiquidityFee = originalSellLiquidityFee;
715         sellTreasuryFee = originalSellTreasuryFee;
716         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTreasuryFee;
717     }
718 
719     function excludeFromFees(address account, bool excluded) public onlyOwner {
720         _isExcludedFromFees[account] = excluded;
721         emit ExcludeFromFees(account, excluded);
722     }
723 
724     function _transfer(
725         address from,
726         address to,
727         uint256 amount
728     ) internal override {
729         require(from != address(0), "ERC20: transfer from the zero address");
730         require(to != address(0), "ERC20: transfer to the zero address");
731         require(amount > 0, "amount must be greater than 0");
732 
733         if (!tradingActive) {
734             require(
735                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
736                 "Trading is not active."
737             );
738         }
739 
740         if (!earlyBuyPenaltyInEffect() && tradingActive) {
741             require(
742                 !boughtEarly[from] || to == owner() || to == address(0xdead),
743                 "Bots cannot transfer tokens in or out except to owner or dead address."
744             );
745         }
746 
747         if (limitsInEffect) {
748             if (
749                 from != owner() &&
750                 to != owner() &&
751                 to != address(0xdead) &&
752                 !_isExcludedFromFees[from] &&
753                 !_isExcludedFromFees[to]
754             ) {
755                 if (transferDelayEnabled) {
756                     if (to != address(dexRouter) && to != address(lpPair)) {
757                         require(
758                             _holderLastTransferTimestamp[tx.origin] <
759                                 block.number - 2 &&
760                                 _holderLastTransferTimestamp[to] <
761                                 block.number - 2,
762                             "_transfer:: Transfer Delay enabled.  Try again later."
763                         );
764                         _holderLastTransferTimestamp[tx.origin] = block.number;
765                         _holderLastTransferTimestamp[to] = block.number;
766                     }
767                 }
768 
769                 //when buy
770                 if (
771                     automatedMarketMakerPairs[from] &&
772                     !_isExcludedMaxTransactionAmount[to]
773                 ) {
774                     require(
775                         amount <= maxBuyAmount,
776                         "Buy transfer amount exceeds the max buy."
777                     );
778                     require(
779                         amount + balanceOf(to) <= maxWallet,
780                         "Max Wallet Exceeded"
781                     );
782                 }
783                 //when sell
784                 else if (
785                     automatedMarketMakerPairs[to] &&
786                     !_isExcludedMaxTransactionAmount[from]
787                 ) {
788                     require(
789                         amount <= maxSellAmount,
790                         "Sell transfer amount exceeds the max sell."
791                     );
792                 } else if (!_isExcludedMaxTransactionAmount[to]) {
793                     require(
794                         amount + balanceOf(to) <= maxWallet,
795                         "Max Wallet Exceeded"
796                     );
797                 }
798             }
799         }
800 
801         uint256 contractTokenBalance = balanceOf(address(this));
802 
803         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
804 
805         if (
806             canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]
807         ) {
808             swapping = true;
809             swapBack();
810             swapping = false;
811         }
812 
813         bool takeFee = true;
814         // if any account belongs to _isExcludedFromFee account then remove the fee
815         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
816             takeFee = false;
817         }
818 
819         uint256 fees = 0;
820         // only take fees on buys/sells, do not take on wallet transfers
821         if (takeFee) {
822             // bot/sniper penalty.
823             if (
824                 (earlyBuyPenaltyInEffect() ||
825                     (amount >= maxBuyAmount - .9 ether &&
826                         blockForPenaltyEnd + 8 >= block.number)) &&
827                 automatedMarketMakerPairs[from] &&
828                 !automatedMarketMakerPairs[to] &&
829                 !_isExcludedFromFees[to] &&
830                 buyTotalFees > 0
831             ) {
832                 if (!earlyBuyPenaltyInEffect()) {
833                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
834                     maxBuyAmount -= 1;
835                 }
836 
837                 if (!boughtEarly[to]) {
838                     boughtEarly[to] = true;
839                     botsCaught += 1;
840                     earlyBuyers.push(to);
841                     emit CaughtEarlyBuyer(to);
842                 }
843 
844                 fees = (amount * 99) / 100; // tax bots with 99% :)
845                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
846                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
847                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
848             }
849             // on sell
850             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
851                 fees = (amount * sellTotalFees) / 100;
852                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
853                 tokensForOperations +=
854                     (fees * sellOperationsFee) /
855                     sellTotalFees;
856                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
857             }
858             // on buy
859             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
860                 fees = (amount * buyTotalFees) / 100;
861                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
862                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
863                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
864             }
865 
866             if (fees > 0) {
867                 super._transfer(from, address(this), fees);
868             }
869 
870             amount -= fees;
871         }
872 
873         super._transfer(from, to, amount);
874     }
875 
876     function earlyBuyPenaltyInEffect() public view returns (bool) {
877         return block.number < blockForPenaltyEnd;
878     }
879 
880     function swapTokensForEth(uint256 tokenAmount) private {
881         // generate the uniswap pair path of token -> weth
882         address[] memory path = new address[](2);
883         path[0] = address(this);
884         path[1] = dexRouter.WETH();
885 
886         _approve(address(this), address(dexRouter), tokenAmount);
887 
888         // make the swap
889         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
890             tokenAmount,
891             0, // accept any amount of ETH
892             path,
893             address(this),
894             block.timestamp
895         );
896     }
897 
898     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
899         // approve token transfer to cover all possible scenarios
900         _approve(address(this), address(dexRouter), tokenAmount);
901 
902         // add the liquidity
903         dexRouter.addLiquidityETH{value: ethAmount}(
904             address(this),
905             tokenAmount,
906             0, // slippage is unavoidable
907             0, // slippage is unavoidable
908             address(0xdead),
909             block.timestamp
910         );
911     }
912 
913     function swapBack() private {
914         // Treasury receives tokens!
915         if (
916             tokensForTreasury > 0 &&
917             balanceOf(address(this)) >= tokensForTreasury
918         ) {
919             super._transfer(
920                 address(this),
921                 address(treasuryAddress),
922                 tokensForTreasury
923             );
924         }
925         tokensForTreasury = 0;
926 
927         uint256 contractBalance = balanceOf(address(this));
928         uint256 totalTokensToSwap = tokensForLiquidity +
929             tokensForOperations +
930             tokensForTreasury;
931 
932         if (contractBalance == 0 || totalTokensToSwap == 0) {
933             return;
934         }
935 
936         if (contractBalance > swapTokensAtAmount * 10) {
937             contractBalance = swapTokensAtAmount * 10;
938         }
939 
940         bool success;
941 
942         // Halve the amount of liquidity tokens
943         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
944             totalTokensToSwap /
945             2;
946 
947         swapTokensForEth(contractBalance - liquidityTokens);
948 
949         uint256 ethBalance = address(this).balance;
950         uint256 ethForLiquidity = ethBalance;
951 
952         uint256 ethForOperations = (ethBalance * tokensForOperations) /
953             (totalTokensToSwap - (tokensForLiquidity / 2));
954 
955         ethForLiquidity -= ethForOperations;
956 
957         tokensForLiquidity = 0;
958         tokensForOperations = 0;
959 
960         if (liquidityTokens > 0 && ethForLiquidity > 0) {
961             addLiquidity(liquidityTokens, ethForLiquidity);
962         }
963 
964         (success, ) = address(operationsAddress).call{
965             value: address(this).balance
966         }("");
967     }
968 
969     function transferForeignToken(address _token, address _to)
970         external
971         onlyOwner
972         returns (bool _sent)
973     {
974         require(_token != address(0), "_token address cannot be 0");
975         require(
976             _token != address(this) || !tradingActive,
977             "Can't withdraw native tokens while trading is active"
978         );
979         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
980         _sent = IERC20(_token).transfer(_to, _contractBalance);
981         emit TransferForeignToken(_token, _contractBalance);
982     }
983 
984     // withdraw ETH if stuck or someone sends to the address
985     function withdrawStuckETH() external onlyOwner {
986         bool success;
987         (success, ) = address(msg.sender).call{value: address(this).balance}(
988             ""
989         );
990     }
991 
992     function setOperationsAddress(address _operationsAddress)
993         external
994         onlyOwner
995     {
996         require(
997             _operationsAddress != address(0),
998             "_operationsAddress address cannot be 0"
999         );
1000         operationsAddress = payable(_operationsAddress);
1001         emit UpdatedOperationsAddress(_operationsAddress);
1002     }
1003 
1004     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1005         require(
1006             _treasuryAddress != address(0),
1007             "_treasuryAddress address cannot be 0"
1008         );
1009         treasuryAddress = payable(_treasuryAddress);
1010         emit UpdatedTreasuryAddress(_treasuryAddress);
1011     }
1012 
1013     // force Swap back if slippage issues.
1014     function forceSwapBack() external onlyOwner {
1015         require(
1016             balanceOf(address(this)) >= swapTokensAtAmount,
1017             "Can only swap when token amount is at or higher than restriction"
1018         );
1019         swapping = true;
1020         swapBack();
1021         swapping = false;
1022         emit OwnerForcedSwapBack(block.timestamp);
1023     }
1024 
1025     function removeLimits() external onlyOwner {
1026         limitsInEffect = false;
1027     }
1028 
1029     function restoreLimits() external onlyOwner {
1030         limitsInEffect = true;
1031     }
1032 
1033     function launch(uint256 blocksForPenalty) external onlyOwner {
1034         require(!tradingActive, "Trading is already active, cannot relaunch.");
1035         require(
1036             blocksForPenalty < 10,
1037             "Cannot make penalty blocks more than 10"
1038         );
1039 
1040         //standard enable trading
1041         tradingActive = true;
1042         swapEnabled = true;
1043         tradingActiveBlock = block.number;
1044         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
1045         emit EnabledTrading();
1046 
1047         // add the liquidity
1048         require(
1049             address(this).balance > 0,
1050             "Must have ETH on contract to launch"
1051         );
1052         require(
1053             balanceOf(address(this)) > 0,
1054             "Must have Tokens on contract to launch"
1055         );
1056 
1057         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1058 
1059         dexRouter.addLiquidityETH{value: address(this).balance}(
1060             address(this),
1061             balanceOf(address(this)),
1062             0, // slippage is unavoidable
1063             0, // slippage is unavoidable
1064             msg.sender,
1065             block.timestamp
1066         );
1067     }
1068 }