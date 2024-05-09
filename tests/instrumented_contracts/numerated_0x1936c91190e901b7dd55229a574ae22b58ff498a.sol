1 // SPDX-License-Identifier: MIT
2 /*
3 
4     Website:
5     https://mevfree.com
6 
7     Telegram:
8     https://t.me/mevfree
9 
10     Twitter:
11     https://twitter.com/mevfree
12 
13 
14  */
15 pragma solidity ^0.8.17;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount)
47         external
48         returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender)
58         external
59         view
60         returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address sender,
89         address recipient,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the symbol of the token.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the decimals places of the token.
125      */
126     function decimals() external view returns (uint8);
127 }
128 
129 contract ERC20 is Context, IERC20, IERC20Metadata {
130     mapping(address => uint256) private _balances;
131 
132     mapping(address => mapping(address => uint256)) private _allowances;
133 
134     uint256 private _totalSupply;
135 
136     string private _name;
137     string private _symbol;
138 
139     constructor(string memory name_, string memory symbol_) {
140         _name = name_;
141         _symbol = symbol_;
142     }
143 
144     function name() public view virtual override returns (string memory) {
145         return _name;
146     }
147 
148     function symbol() public view virtual override returns (string memory) {
149         return _symbol;
150     }
151 
152     function decimals() public view virtual override returns (uint8) {
153         return 18;
154     }
155 
156     function totalSupply() public view virtual override returns (uint256) {
157         return _totalSupply;
158     }
159 
160     function balanceOf(address account)
161         public
162         view
163         virtual
164         override
165         returns (uint256)
166     {
167         return _balances[account];
168     }
169 
170     function transfer(address recipient, uint256 amount)
171         public
172         virtual
173         override
174         returns (bool)
175     {
176         _transfer(_msgSender(), recipient, amount);
177         return true;
178     }
179 
180     function allowance(address owner, address spender)
181         public
182         view
183         virtual
184         override
185         returns (uint256)
186     {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount)
191         public
192         virtual
193         override
194         returns (bool)
195     {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) public virtual override returns (bool) {
205         _transfer(sender, recipient, amount);
206 
207         uint256 currentAllowance = _allowances[sender][_msgSender()];
208         require(
209             currentAllowance >= amount,
210             "ERC20: transfer amount exceeds allowance"
211         );
212         unchecked {
213             _approve(sender, _msgSender(), currentAllowance - amount);
214         }
215 
216         return true;
217     }
218 
219     function increaseAllowance(address spender, uint256 addedValue)
220         public
221         virtual
222         returns (bool)
223     {
224         _approve(
225             _msgSender(),
226             spender,
227             _allowances[_msgSender()][spender] + addedValue
228         );
229         return true;
230     }
231 
232     function decreaseAllowance(address spender, uint256 subtractedValue)
233         public
234         virtual
235         returns (bool)
236     {
237         uint256 currentAllowance = _allowances[_msgSender()][spender];
238         require(
239             currentAllowance >= subtractedValue,
240             "ERC20: decreased allowance below zero"
241         );
242         unchecked {
243             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
244         }
245 
246         return true;
247     }
248 
249     function _transfer(
250         address sender,
251         address recipient,
252         uint256 amount
253     ) internal virtual {
254         require(sender != address(0), "ERC20: transfer from the zero address");
255         require(recipient != address(0), "ERC20: transfer to the zero address");
256 
257         uint256 senderBalance = _balances[sender];
258         require(
259             senderBalance >= amount,
260             "ERC20: transfer amount exceeds balance"
261         );
262         unchecked {
263             _balances[sender] = senderBalance - amount;
264         }
265         _balances[recipient] += amount;
266 
267         emit Transfer(sender, recipient, amount);
268     }
269 
270     function _createInitialSupply(address account, uint256 amount)
271         internal
272         virtual
273     {
274         require(account != address(0), "ERC20: mint to the zero address");
275 
276         _totalSupply += amount;
277         _balances[account] += amount;
278         emit Transfer(address(0), account, amount);
279     }
280 
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288 
289         _allowances[owner][spender] = amount;
290         emit Approval(owner, spender, amount);
291     }
292 
293         /**
294      * @dev Destroys `amount` tokens from `account`, reducing the
295      * total supply.
296      *
297      * Emits a {Transfer} event with `to` set to the zero address.
298      *
299      * Requirements:
300      *
301      * - `account` cannot be the zero address.
302      * - `account` must have at least `amount` tokens.
303      */
304     function _burn(address account, uint256 amount) internal virtual {
305         require(account != address(0), "ERC20: burn from the zero address");
306 
307         _beforeTokenTransfer(account, address(0), amount);
308 
309         uint256 accountBalance = _balances[account];
310         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
311         unchecked {
312             _balances[account] = accountBalance - amount;
313         }
314         _totalSupply -= amount;
315 
316         emit Transfer(account, address(0), amount);
317 
318         _afterTokenTransfer(account, address(0), amount);
319     }
320 
321         /**
322      * @dev Hook that is called before any transfer of tokens. This includes
323      * minting and burning.
324      *
325      * Calling conditions:
326      *
327      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
328      * will be transferred to `to`.
329      * - when `from` is zero, `amount` tokens will be minted for `to`.
330      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
331      * - `from` and `to` are never both zero.
332      *
333      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
334      */
335     function _beforeTokenTransfer(
336         address from,
337         address to,
338         uint256 amount
339     ) internal virtual {}
340 
341     /**
342      * @dev Hook that is called after any transfer of tokens. This includes
343      * minting and burning.
344      *
345      * Calling conditions:
346      *
347      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
348      * has been transferred to `to`.
349      * - when `from` is zero, `amount` tokens have been minted for `to`.
350      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
351      * - `from` and `to` are never both zero.
352      *
353      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
354      */
355     function _afterTokenTransfer(
356         address from,
357         address to,
358         uint256 amount
359     ) internal virtual {}
360 
361 }
362 
363 contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(
367         address indexed previousOwner,
368         address indexed newOwner
369     );
370 
371     constructor() {
372         address msgSender = _msgSender();
373         _owner = msgSender;
374         emit OwnershipTransferred(address(0), msgSender);
375     }
376 
377     function owner() public view returns (address) {
378         return _owner;
379     }
380 
381     modifier onlyOwner() {
382         require(_owner == _msgSender(), "Ownable: caller is not the owner");
383         _;
384     }
385 
386     function renounceOwnership(bool confirmRenounce)
387         external
388         virtual
389         onlyOwner
390     {
391         require(confirmRenounce, "Please confirm renounce!");
392         emit OwnershipTransferred(_owner, address(0));
393         _owner = address(0);
394     }
395 
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(
398             newOwner != address(0),
399             "Ownable: new owner is the zero address"
400         );
401         emit OwnershipTransferred(_owner, newOwner);
402         _owner = newOwner;
403     }
404 }
405 
406 interface ILpPair {
407     function sync() external;
408 }
409 
410 interface IDexRouter {
411     function factory() external pure returns (address);
412 
413     function WETH() external pure returns (address);
414 
415     function swapExactTokensForETH(
416         uint amountIn, 
417         uint amountOutMin, 
418         address[] calldata path, 
419         address to, 
420         uint deadline)
421         external
422         returns (uint[] memory amounts);
423 
424     function addLiquidityETH(
425         address token,
426         uint256 amountTokenDesired,
427         uint256 amountTokenMin,
428         uint256 amountETHMin,
429         address to,
430         uint256 deadline
431     )
432         external
433         payable
434         returns (
435             uint256 amountToken,
436             uint256 amountETH,
437             uint256 liquidity
438         );
439 
440     function getAmountsOut(uint256 amountIn, address[] calldata path)
441         external
442         view
443         returns (uint256[] memory amounts);
444 
445     function removeLiquidityETH(
446         address token,
447         uint256 liquidity,
448         uint256 amountTokenMin,
449         uint256 amountETHMin,
450         address to,
451         uint256 deadline
452     ) external returns (uint256 amountToken, uint256 amountETH);
453 }
454 
455 interface IDexFactory {
456     function createPair(address tokenA, address tokenB)
457         external
458         returns (address pair);
459 }
460 
461 contract MEVFree is ERC20, Ownable {
462 
463     uint256 public maxBuyTokenAmount;
464     uint256 public maxSellTokenAmount;
465     uint256 public maxWalletTokenAmount;
466 
467     IDexRouter public dexRouter;
468     address public lpPair;
469 
470     bool private swapping = false;
471     uint256 public swapTokensAtAmount;
472 
473     address public devWallet;
474     address public marketingWallet;
475     address public rewardsWallet;
476 
477     uint256 public launchBlock = 0; // 0 means trading is not active
478     uint public BSL = 0; // blocks since launch
479     uint256 public blockForLaunchPenaltyEnd;
480     uint256 public penaltyBlocks = 0;
481     uint256 public feesLastUpdated = 0;
482     bool public launchPenaltyPeriod = false;
483 
484     bool public limitsInEffect = true;
485     bool public tradingActive = false;
486     bool public swapBackEnabled = false;
487 
488     // launch buy fees
489     uint[10] launchBuyDevFees =       [40, 40, 30, 25, 20, 15, 10, 5, 5, 5];
490     uint[10] launchBuyMarketingFees = [20, 15, 15, 15, 10, 10, 5, 3, 3, 2];
491     uint[10] launchBuyRewardsFees =   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
492     uint[10] launchBuyLiquidityFees = [20, 15, 15, 10, 10, 5, 5, 2, 2, 1];
493     uint[10] launchBuyBurnFees =      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
494 
495     // normal buy fees
496     uint256 private normalBuyDevFee = 4;
497     uint256 private normalBuyMarketingFee = 1;
498     uint256 private normalBuyRewardsFee = 0;
499     uint256 private normalBuyLiquidityFee = 1;
500     uint256 private normalBuyBurnFee = 0;
501 
502     // buy fees
503     uint256 public buyDevFee = 4;
504     uint256 public buyMarketingFee = 1;
505     uint256 public buyRewardsFee = 0;
506     uint256 public buyLiquidityFee = 1;
507     uint256 public buyBurnFee = 0;
508     uint256 public buyTotalFees =  buyDevFee + buyMarketingFee + buyRewardsFee + buyLiquidityFee + buyBurnFee;
509 
510     // launch sell fees
511     uint[10] launchSellDevFees =       [40, 40, 30, 25, 20, 15, 10, 5, 5, 5];
512     uint[10] launchSellMarketingFees = [20, 15, 15, 15, 10, 10, 5, 3, 3, 2];
513     uint[10] launchSellRewardsFees =   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
514     uint[10] launchSellLiquidityFees = [20, 15, 15, 10, 10, 5, 5, 2, 2, 1];
515     uint[10] launchSellBurnFees =      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
516 
517     // normal sell fees
518     uint256 private normalSellDevFee = 4;
519     uint256 private normalSellMarketingFee = 1;
520     uint256 private normalSellRewardsFee = 0;
521     uint256 private normalSellLiquidityFee = 1;
522     uint256 private normalSellBurnFee = 0;
523 
524     // sell fees
525     uint256 public sellDevFee = 4;
526     uint256 public sellMarketingFee = 1;
527     uint256 public sellRewardsFee = 0;
528     uint256 public sellLiquidityFee = 1;
529     uint256 public sellBurnFee = 0;
530     uint256 public sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellLiquidityFee + sellBurnFee;
531 
532     // fee token counters
533     uint256 public tokensForDev;
534     uint256 public tokensForMarketing;
535     uint256 public tokensForRewards;
536     uint256 public tokensForLiquidity;
537     uint256 public tokensForBurn;
538 
539     // exlcude from fees and max transaction amount
540     mapping(address => bool) private _isExcludedFromFees;
541     mapping(address => bool) public _isExcludedMaxTransactionAmount;
542 
543     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
544     // could be subject to a maximum transfer amount
545     mapping(address => bool) public automatedMarketMakerPairs;
546 
547     // Anti-MEV mappings and variables
548     mapping(address => uint256) public blocksOfTrades; // to hold the next block that trading is allowed
549     bool public antiMEVEnabled = true;
550     bool public antiContractSellEnabled = true;
551     uint256 public mevBlocks = 2; // blocks to block same account trades from
552 
553     // mapping to store mev bots or suspected mev bots
554     // additional mapping to store whitelisted address exempt from antiMEV
555     mapping (address => bool) public botsOfMEV;
556     mapping (address => bool) public whitelistedMEV;
557 
558     // mappings to track those who bought during the higher penalty period
559     // so that they always have the tax penalty on sell whilst they hold tokens
560     mapping(address => bool) public launchPenaltyHolder;
561     mapping(address => uint) public launchPenaltySellFee;
562 
563     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
564 
565     event EnabledTrading();
566 
567     event ExcludeFromFees(address indexed account, bool isExcluded);
568 
569     event UpdatedMaxBuyTokenAmount(uint256 newAmount);
570 
571     event UpdatedMaxSellTokenAmount(uint256 newAmount);
572 
573     event UpdatedMaxWalletTokenAmount(uint256 newAmount);
574 
575     event UpdatedDevWallet(address indexed newWallet);
576 
577     event UpdatedMarketingWallet(address indexed newWallet);
578 
579     event UpdatedRewardsWallet(address indexed newWallet);
580 
581     event MaxTransactionExclusion(address _address, bool excluded);
582 
583     event OwnerForcedSwapBackAndBurn(uint256 timestamp);
584 
585     event OwnerForcedSwapOfTokens(uint256 timestamp);
586 
587     event SwapAndLiquify(
588         uint256 tokensSwapped,
589         uint256 ethReceived,
590         uint256 tokensIntoLiquidity
591     );
592 
593     event AutoNukeLP();
594 
595     event ManualNukeLP();
596 
597     event Burn(address indexed user, uint256 amount);
598 
599     event TransferForeignToken(address token, uint256 amount);
600 
601     constructor() payable ERC20("MEVFree", "MEVFree") {
602         address newOwner = msg.sender; // can leave alone if owner is deployer.
603 
604         address _dexRouter;
605 
606         _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap V2 Router
607 
608         // initialize router
609         dexRouter = IDexRouter(_dexRouter);
610 
611         // create pair
612         lpPair = IDexFactory(dexRouter.factory()).createPair(
613             address(this),
614             dexRouter.WETH()
615         );
616         _setAutomatedMarketMakerPair(address(lpPair), true);
617 
618         _excludeFromMaxTransaction(lpPair, true);
619         automatedMarketMakerPairs[lpPair] = true;
620 
621         uint256 totalSupply = 100 * 1e6 * 1e18; // 100 million
622 
623         maxBuyTokenAmount = (totalSupply * 1) / 100; // 1%
624         maxSellTokenAmount = (totalSupply * 1) / 100; // 1%
625         maxWalletTokenAmount = (totalSupply * 2) / 100; // 2%
626         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
627 
628         // set wallets - assume deployer is the dev
629         devWallet = address(0x18234cA263bfE40ACB395119ABFFC5c80f31153A);
630         marketingWallet = address(0x4098BE3E6b13cAEF10373cB398200fdbd4F5f5a3);
631         rewardsWallet = address(0x1A23560fb2946Ab8Fb4056a25834061D8594936C);
632 
633         _excludeFromMaxTransaction(address(this), true);
634         _excludeFromMaxTransaction(address(0xdead), true);
635         _excludeFromMaxTransaction(address(newOwner), true);
636         _excludeFromMaxTransaction(address(devWallet), true);
637         _excludeFromMaxTransaction(address(marketingWallet), true);
638         _excludeFromMaxTransaction(address(rewardsWallet), true);
639         _excludeFromMaxTransaction(address(dexRouter), true);
640         _excludeFromMaxTransaction(address(0xa4fD37C3916824a974df5FA6e136A8Fc7e58044E), true); // Team
641         _excludeFromMaxTransaction(address(0x3C507DC5C57c31fB9C61BB75471B19B71bf16a95), true); // Presale
642 
643         excludeFromFees(newOwner, true);
644         excludeFromFees(address(this), true);
645         excludeFromFees(address(0xdead), true);
646         excludeFromFees(address(devWallet), true);
647         excludeFromFees(address(marketingWallet), true);
648         excludeFromFees(address(rewardsWallet), true);
649         excludeFromFees(address(dexRouter), true);
650         excludeFromFees(address(0xa4fD37C3916824a974df5FA6e136A8Fc7e58044E),true); // Team
651 
652         _createInitialSupply(address(this), (totalSupply * 20) / 100); // Tokens for liquidity
653         _createInitialSupply(address(rewardsWallet),(totalSupply * 15) / 100); // Rewards
654         _createInitialSupply(address(0xa4fD37C3916824a974df5FA6e136A8Fc7e58044E),(totalSupply * 10) / 100); // Team
655         _createInitialSupply(address(0x3C507DC5C57c31fB9C61BB75471B19B71bf16a95),(totalSupply * 35) / 100); // Presale
656         _createInitialSupply(address(newOwner),(totalSupply * 20) / 100); //Additional Liquidity etc
657 
658         transferOwnership(newOwner);
659     }
660 
661     receive() external payable {}
662 
663     function emergencyUpdateRouter(address router) external onlyOwner {
664         require(!tradingActive, "Cannot update after trading is active");
665         dexRouter = IDexRouter(router);
666     }
667 
668     function setAntiMEVMode(bool setting) external onlyOwner {
669         antiMEVEnabled = setting;
670     }
671 
672     function setAntiContractSellMode(bool setting) external onlyOwner {
673         antiContractSellEnabled = setting;
674     }
675 
676     function setMEVBlocks(uint256 _mevBlocks) external onlyOwner {
677         require(_mevBlocks < 8,"Cannot make _mevBlocks more that 8");
678         mevBlocks = _mevBlocks;
679     }
680 
681     // clear state for individual bots
682     function clearMEVBot(address bot) external onlyOwner {
683         botsOfMEV[bot] = false;
684     }
685     
686     // clear state for bulk bots
687     function removeMEVBots(address[] calldata bots_) external onlyOwner {
688         for (uint i = 0; i < bots_.length; i++) {
689             botsOfMEV[bots_[i]] = false;
690         }
691     }
692 
693     // set state for whitelisted address to pass mev checks
694     function setWhitelist(address addr, bool state) external onlyOwner {
695 		whitelistedMEV[addr] = state;
696 	}
697 
698         // clear state for individual bots
699     function clearLaunchPenaltyState(address penaltyAddress) external onlyOwner {
700         launchPenaltyHolder[penaltyAddress] = false;
701         launchPenaltySellFee[penaltyAddress] = 0;
702     }
703 
704     function updateMaxBuyTokenAmount(uint256 newMaxBuy) external onlyOwner {
705         require(
706             newMaxBuy >= ((totalSupply() * 5) / 1000) / 1e18,
707             "Cannot set max buy token amount lower than 0.5%"
708         );
709         require(
710             newMaxBuy <= ((totalSupply() * 2) / 100) / 1e18,
711             "Cannot set max buy token amount higher than 2%"
712         );
713         maxBuyTokenAmount = newMaxBuy * (10**18);
714         emit UpdatedMaxBuyTokenAmount(maxBuyTokenAmount);
715     }
716 
717     function updateMaxSellTokenAmount(uint256 newMaxSell) external onlyOwner {
718         require(
719             newMaxSell >= ((totalSupply() * 5) / 1000) / 1e18,
720             "Cannot set max sell token amount lower than 0.5%"
721         );
722         require(
723             newMaxSell <= ((totalSupply() * 2) / 100) / 1e18,
724             "Cannot set max sell token amount higher than 2%"
725         );
726         maxSellTokenAmount = newMaxSell * (10**18);
727         emit UpdatedMaxSellTokenAmount(maxSellTokenAmount);
728     }
729 
730     function updateMaxWalletTokenAmount(uint256 newMaxWallet) external onlyOwner {
731         require(
732             newMaxWallet >= ((totalSupply() * 5) / 1000) / 1e18,
733             "Cannot set max wallet token amount lower than 0.5%"
734         );
735         require(
736             newMaxWallet <= ((totalSupply() * 5) / 100) / 1e18,
737             "Cannot set max wallet token amount higher than 5%"
738         );
739         maxWalletTokenAmount = newMaxWallet * (10**18);
740         emit UpdatedMaxWalletTokenAmount(maxWalletTokenAmount);
741     }
742 
743     // change the minimum amount of tokens to sell from fees
744     function updateSwapTokensAtAmount(uint256 newSwapAmount) external onlyOwner {
745         require(
746             newSwapAmount >= (totalSupply() * 1) / 100000,
747             "Swap amount cannot be lower than 0.001% total supply."
748         );
749         require(
750             newSwapAmount <= (totalSupply() * 1) / 1000,
751             "Swap amount cannot be higher than 0.1% total supply."
752         );
753         swapTokensAtAmount = newSwapAmount;
754     }
755 
756     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
757         private
758     {
759         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
760         emit MaxTransactionExclusion(updAds, isExcluded);
761     }
762 
763     function excludeFromMaxTransaction(address updAds, bool isEx)
764         external
765         onlyOwner
766     {
767         if (!isEx) {
768             require(
769                 updAds != lpPair,
770                 "Cannot remove uniswap pair from max txn"
771             );
772         }
773         _isExcludedMaxTransactionAmount[updAds] = isEx;
774     }
775 
776     function excludeFromFees(address account, bool excluded) public onlyOwner {
777         _isExcludedFromFees[account] = excluded;
778         emit ExcludeFromFees(account, excluded);
779     }
780 
781     function setAutomatedMarketMakerPair(address pair, bool value)
782         external
783         onlyOwner
784     {
785         require(
786             pair != lpPair,
787             "The pair cannot be removed from automatedMarketMakerPairs"
788         );
789         _setAutomatedMarketMakerPair(pair, value);
790         emit SetAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function _setAutomatedMarketMakerPair(address pair, bool value) private {
794         automatedMarketMakerPairs[pair] = value;
795         _excludeFromMaxTransaction(pair, value);
796         emit SetAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function updateBuyFees(
800         uint256 _devFee,
801         uint256 _marketingFee,
802         uint256 _rewardsFee,
803         uint256 _liquidityFee,
804         uint256 _burnFee
805     ) external onlyOwner {
806         buyDevFee = _devFee;
807         buyMarketingFee = _marketingFee;
808         buyRewardsFee = _rewardsFee;
809         buyLiquidityFee = _liquidityFee;
810         buyBurnFee = _burnFee;
811         buyTotalFees = buyDevFee + buyMarketingFee + buyRewardsFee + buyLiquidityFee + buyBurnFee;
812         require(buyTotalFees <= 15, "Must keep buy fees at 15% or less");
813     }
814 
815     function updateSellFees(
816         uint256 _devFee,
817         uint256 _marketingFee,
818         uint256 _rewardsFee,
819         uint256 _liquidityFee,
820         uint256 _burnFee
821     ) external onlyOwner {
822         sellDevFee = _devFee;
823         sellMarketingFee = _marketingFee;
824         sellRewardsFee = _rewardsFee;
825         sellLiquidityFee = _liquidityFee;
826         sellBurnFee = _burnFee;
827         sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellLiquidityFee + sellBurnFee;
828         require(sellTotalFees <= 25, "Must keep sell fees at 25% or less");
829     }
830 
831     function taxToNormal() external onlyOwner {
832         buyDevFee = normalBuyDevFee;
833         buyMarketingFee = normalBuyMarketingFee;
834         buyRewardsFee = normalBuyRewardsFee;
835         buyLiquidityFee = normalBuyLiquidityFee;
836         buyBurnFee = normalBuyBurnFee;
837         buyTotalFees = buyDevFee + buyMarketingFee + buyRewardsFee + buyLiquidityFee + buyBurnFee;
838 
839         sellDevFee = normalSellDevFee;
840         sellMarketingFee = normalSellMarketingFee;
841         sellRewardsFee = normalSellRewardsFee;
842         sellLiquidityFee = normalSellLiquidityFee;
843         sellBurnFee = normalSellBurnFee;
844         sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellLiquidityFee + sellBurnFee;
845     }
846 
847     function _transfer(
848         address from,
849         address to,
850         uint256 amount
851     ) internal override {
852         require(from != address(0), "ERC20: transfer from the zero address");
853         require(to != address(0), "ERC20: transfer to the zero address");
854         require(amount > 0, "amount must be greater than 0");
855         if (!tradingActive) {
856             require(
857                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
858                 "Trading is not active."
859             );
860         }
861 
862         bool _isBuying = automatedMarketMakerPairs[from] && to != address(dexRouter);
863         bool _isSelling = automatedMarketMakerPairs[to] && from != address(this);
864         bool _mevBot = false;
865 
866         // anti MEV mode blocks trades from the same sender more often than every x blocks
867         // if a mev bot is detected then they are added to the botsOfMEV list and not able to sell
868         // while unlikely, this can block multi block mev from happening, and trap the mev bot buy
869         if (antiMEVEnabled) {
870             if (_isBuying) {
871                 // flag next block allowed for trading
872                 blocksOfTrades[to] = block.number;
873                 //blocksOfTrades[msg.sender] = block.number;
874 
875             } else if (_isSelling && !whitelistedMEV[from]) {
876                 // check to see if seller has been flagged as a mev bot previously and block the sell :)
877                 // mev bot status can be manually removed by owner but not set for safety
878                 if ((block.number < (blocksOfTrades[from] + mevBlocks)) && (block.number < (blocksOfTrades[msg.sender] + mevBlocks))) {
879                     if (!botsOfMEV[from] || !botsOfMEV[msg.sender]) {
880                         botsOfMEV[from] = true;
881                         botsOfMEV[msg.sender] = true;
882                     }
883                     _mevBot = true;
884                 }
885 
886                 if (botsOfMEV[from] && botsOfMEV[msg.sender]) {
887                     _mevBot = true;
888                 }
889 
890                 if (from == msg.sender && antiContractSellEnabled) {
891                     botsOfMEV[from] = true;
892                     botsOfMEV[msg.sender] = true;
893                     _mevBot = true;
894                 }
895             }  
896         }
897 
898         if (limitsInEffect) {
899             if (
900                 from != owner() &&
901                 to != owner() &&
902                 to != address(0xdead) &&
903                 !_isExcludedFromFees[from] &&
904                 !_isExcludedFromFees[to]
905             ) {
906                 //when buy
907                 if (_isBuying && !_isExcludedMaxTransactionAmount[to]) 
908                 {
909                     require(
910                         amount <= maxBuyTokenAmount,
911                         "Buy transfer amount exceeds the max buy."
912                     );
913                     require(
914                         amount + balanceOf(to) <= maxWalletTokenAmount,
915                         "Max Wallet Exceeded"
916                     );
917                 }
918                 //when sell
919                 else if (_isSelling && !_isExcludedMaxTransactionAmount[from]) 
920                 {
921                     require(
922                         amount <= maxSellTokenAmount,
923                         "Sell transfer amount exceeds the max sell."
924                     );
925                 } 
926                 // else simple transfer
927                 else if (!_isExcludedMaxTransactionAmount[to]) {
928                     require(
929                         amount + balanceOf(to) <= maxWalletTokenAmount,
930                         "Max Wallet Exceeded"
931                     );
932                 }
933             }
934         }
935 
936         uint256 contractTokenBalance = balanceOf(address(this));
937         bool okToSwapBack = contractTokenBalance >= swapTokensAtAmount;
938 
939         bool takeFee = true;
940         // if any account belongs to _isExcludedFromFee we do not take any fees
941         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
942             takeFee = false;
943         }
944 
945         // only take fees on buys/sells, do not take on wallet transfers
946         if (takeFee) {
947             uint256 fees = 0;
948             // early buying bot/sniper penalty.
949             if (launchPenaltyPeriod) {
950                 if (feesLastUpdated < block.number) {
951                     updateEarlyPenaltyFees();
952                 }
953                 if (_isBuying && !launchPenaltyHolder[to]) {
954                     launchPenaltyHolder[to] = true;
955                     launchPenaltySellFee[to] = sellTotalFees;
956                 }
957             }
958 
959             // on sell
960             if (_isSelling) {
961                 if (okToSwapBack && swapBackEnabled && !swapping) {
962                     swapping = true;
963                     swapBackAndBurn();
964                     swapping = false;
965                 }
966             // on sell if launch penalty holder then tax according to
967             // the sell taxes at the time of the eoriginal buy
968                 if (launchPenaltyHolder[from]) {
969                     uint _penaltySellFee = launchPenaltySellFee[from];
970                     fees = (amount * _penaltySellFee) / 100;
971                     tokensForDev += fees;
972                 }
973                 // on normal sell
974                 else if (sellTotalFees > 0) {
975                     fees = (amount * sellTotalFees) / 100;
976                     tokensForDev += (fees * sellDevFee) / sellTotalFees;
977                     tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
978                     tokensForRewards += (fees * sellRewardsFee) / sellTotalFees;
979                     tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
980                     tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
981                 }
982             }
983             // on buy
984             else if (_isBuying && buyTotalFees > 0) {
985                 fees = (amount * buyTotalFees) / 100;
986                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
987                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
988                 tokensForRewards += (fees * buyRewardsFee) / buyTotalFees;
989                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
990                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
991             } 
992             // on Transfer
993             else {
994                 // if from wallet has penalties then we also apply to the 
995                 // wallet being transferred to
996                 if (launchPenaltyHolder[from]) {
997                     launchPenaltyHolder[to] = true;
998                     launchPenaltySellFee[to] = launchPenaltySellFee[from];
999                 }
1000             }
1001 
1002             if (fees > 0) {
1003                 super._transfer(from, address(this), fees);
1004             }
1005 
1006             amount -= fees;
1007 
1008         }
1009 
1010         if (!_mevBot || (_mevBot && _isBuying)) {
1011             super._transfer(from, to, amount);
1012         }
1013         
1014     }
1015 
1016     function updateEarlyPenaltyFees() private {
1017         if (block.number == launchBlock) {
1018             buyDevFee = launchBuyDevFees[0];
1019             buyMarketingFee = launchBuyMarketingFees[0];
1020             buyRewardsFee = launchBuyRewardsFees[0];
1021             buyLiquidityFee = launchBuyLiquidityFees[0];
1022             buyBurnFee = launchBuyBurnFees[0];
1023             buyTotalFees = buyDevFee + buyMarketingFee + buyRewardsFee + buyLiquidityFee + buyBurnFee;
1024 
1025             sellDevFee = launchSellDevFees[0];
1026             sellMarketingFee = launchSellMarketingFees[0];
1027             sellRewardsFee = launchSellRewardsFees[0];
1028             sellLiquidityFee = launchSellLiquidityFees[0];
1029             sellBurnFee = launchSellBurnFees[0];
1030             sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellLiquidityFee + sellBurnFee;
1031         } else if (block.number < blockForLaunchPenaltyEnd) {
1032             //BSL = (block.number - launchBlock); // BlocksSinchLaunch
1033             BSL = (block.number - launchBlock) <= 9 ? (block.number - launchBlock) : 9;
1034 
1035             buyDevFee = launchBuyDevFees[BSL] > normalBuyDevFee ? launchBuyDevFees[BSL] : normalBuyDevFee;
1036             buyMarketingFee = launchBuyMarketingFees[BSL] > normalBuyMarketingFee ? launchBuyMarketingFees[BSL] : normalBuyMarketingFee;
1037             buyRewardsFee = launchBuyRewardsFees[BSL] > normalBuyRewardsFee ? launchBuyRewardsFees[BSL] : normalBuyRewardsFee;
1038             buyLiquidityFee = launchBuyLiquidityFees[BSL] > normalBuyLiquidityFee ? launchBuyLiquidityFees[BSL] : normalBuyLiquidityFee;
1039             buyBurnFee = launchBuyBurnFees[BSL] > normalBuyBurnFee ? launchBuyBurnFees[BSL] : normalBuyBurnFee;
1040             buyTotalFees = buyDevFee + buyMarketingFee + buyRewardsFee + buyLiquidityFee + buyBurnFee;
1041 
1042             sellDevFee = launchSellDevFees[BSL] > normalSellDevFee ? launchSellDevFees[BSL] : normalSellDevFee;
1043             sellMarketingFee = launchSellMarketingFees[BSL] > normalSellMarketingFee ? launchSellMarketingFees[BSL] : normalSellMarketingFee;
1044             sellRewardsFee = launchSellRewardsFees[BSL] > normalSellRewardsFee ? launchSellRewardsFees[BSL] : normalSellRewardsFee;
1045             sellLiquidityFee = launchSellLiquidityFees[BSL] > normalSellLiquidityFee ? launchSellLiquidityFees[BSL] : normalSellLiquidityFee;
1046             sellBurnFee = launchSellBurnFees[BSL] > normalSellBurnFee ? launchSellBurnFees[BSL] : normalSellBurnFee;
1047             sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellLiquidityFee + sellBurnFee;
1048         } else if ((block.number >= blockForLaunchPenaltyEnd) && launchPenaltyPeriod) {
1049             buyDevFee = normalBuyDevFee;
1050             buyMarketingFee = normalBuyMarketingFee;
1051             buyRewardsFee = normalBuyRewardsFee;
1052             buyLiquidityFee = normalBuyLiquidityFee;
1053             buyBurnFee = normalBuyBurnFee;
1054             buyTotalFees = buyDevFee + buyMarketingFee + buyRewardsFee + buyLiquidityFee + buyBurnFee;
1055 
1056             sellDevFee = normalSellDevFee;
1057             sellMarketingFee = normalSellMarketingFee;
1058             sellRewardsFee = normalSellRewardsFee;
1059             sellLiquidityFee = normalSellLiquidityFee;
1060             sellBurnFee = normalSellBurnFee;
1061             sellTotalFees = sellDevFee + sellMarketingFee + sellRewardsFee + sellLiquidityFee + sellBurnFee;
1062             launchPenaltyPeriod = false;
1063 
1064         }
1065         feesLastUpdated = block.number;
1066     }
1067 
1068     function swapTokensForEth(uint256 tokenAmount) private {
1069         // generate the uniswap pair path of token -> weth
1070         address[] memory path = new address[](2);
1071         path[0] = address(this);
1072         path[1] = dexRouter.WETH();
1073 
1074         _approve(address(this), address(dexRouter), tokenAmount);
1075 
1076         // make the swap
1077         dexRouter.swapExactTokensForETH(
1078             tokenAmount,
1079             0, // accept any amount of ETH
1080             path,
1081             address(this),
1082             block.timestamp
1083         );
1084     }
1085 
1086     function addLiquidityAndBurn(uint256 tokenAmount, uint256 ethAmount) private {
1087         // approve token transfer to cover all possible scenarios
1088         _approve(address(this), address(dexRouter), tokenAmount);
1089 
1090         // add the liquidity
1091         dexRouter.addLiquidityETH{value: ethAmount}(
1092             address(this),
1093             tokenAmount,
1094             0, // slippage is unavoidable
1095             0, // slippage is unavoidable
1096             address(0xdead),
1097             block.timestamp
1098         );
1099     }
1100 
1101     function swapBackAndBurn() private {
1102         uint256 contractBalance = balanceOf(address(this));
1103         bool success;
1104 
1105         if (tokensForBurn > 0) {
1106             if (tokensForBurn > contractBalance) {
1107                 tokensForBurn = contractBalance;
1108             }
1109             _burnWithEvent(address(this), tokensForBurn);
1110             contractBalance = balanceOf(address(this));
1111         }
1112 
1113         uint256 totalTokensToSwap = tokensForDev +
1114             tokensForMarketing + 
1115             tokensForRewards +
1116             tokensForLiquidity;
1117 
1118         if (contractBalance == 0 || totalTokensToSwap == 0) {
1119             return;
1120         }
1121 
1122         // limit max number of tokens to swap this 
1123         // occurs if no sells have happened in a while
1124         // limiting it this low ensure that no slippage
1125         //  issues or "router clogs" happen
1126         if (contractBalance > swapTokensAtAmount * 5) {
1127             contractBalance = swapTokensAtAmount * 5;
1128         }
1129 
1130         // Halve the amount of liquidity tokens
1131         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1132             totalTokensToSwap /
1133             2;
1134         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1135         uint256 initialETHBalance = address(this).balance;
1136 
1137         swapTokensForEth(amountToSwapForETH);
1138 
1139         uint256 ethBalance = address(this).balance - initialETHBalance;
1140 
1141         uint256 ethForDev = (ethBalance * tokensForDev) / totalTokensToSwap;
1142         uint256 ethForMarketing = (ethBalance * tokensForMarketing) / totalTokensToSwap;
1143         uint256 ethForRewards = (ethBalance * tokensForRewards) / totalTokensToSwap;
1144 
1145         uint256 ethForLiquidity = ethBalance - ethForDev - ethForMarketing - ethForRewards;
1146 
1147         tokensForDev = 0;
1148         tokensForMarketing = 0;
1149         tokensForRewards = 0;
1150         tokensForLiquidity = 0;
1151         tokensForBurn = 0;
1152 
1153         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1154             addLiquidityAndBurn(liquidityTokens, ethForLiquidity);
1155         }
1156 
1157         
1158         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1159         (success, ) = address(rewardsWallet).call{value: ethForRewards}("");
1160         (success, ) = address(devWallet).call{value: address(this).balance}("");
1161 
1162     }
1163 
1164     function burn(uint256 _amount) external {
1165         _burnWithEvent(msg.sender, _amount);
1166     }
1167 
1168     function _burnWithEvent(address _user, uint256 _amount) internal {
1169         _burn(_user, _amount);
1170         emit Burn(_user, _amount);
1171     }
1172 
1173     function transferForeignToken(address _token, address _to)
1174         external
1175         onlyOwner
1176         returns (bool _sent)
1177     {
1178         require(_token != address(0), "_token address cannot be 0");
1179         require(
1180             _token != address(this) || !tradingActive,
1181             "Can't withdraw native tokens while trading is active"
1182         );
1183         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1184         _sent = IERC20(_token).transfer(_to, _contractBalance);
1185         emit TransferForeignToken(_token, _contractBalance);
1186     }
1187 
1188     // withdraw ETH if stuck or someone sends to the address
1189     function withdrawStuckETH() external onlyOwner {
1190         bool success;
1191         (success, ) = address(msg.sender).call{value: address(this).balance}(
1192             ""
1193         );
1194     }
1195 
1196     function setDevWallet(address _devWallet) external onlyOwner
1197     {
1198         require(_devWallet != address(0),"_devWallet address cannot be 0");
1199         devWallet = payable(_devWallet);
1200         emit UpdatedDevWallet(_devWallet);
1201     }
1202 
1203     function setMarketingWallet(address _marketingWallet) external onlyOwner {
1204         require(_marketingWallet != address(0),"_marketingWallet address cannot be 0");
1205         marketingWallet = payable(_marketingWallet);
1206         emit UpdatedMarketingWallet(_marketingWallet);
1207     }
1208 
1209     function setRewardsWallet(address _rewardsWallet) external onlyOwner {
1210         require(_rewardsWallet != address(0),"_rewardsWallet address cannot be 0");
1211         rewardsWallet = payable(_rewardsWallet);
1212         emit UpdatedRewardsWallet(_rewardsWallet);
1213     }
1214 
1215     // force Swap back and burn if slippage issues.
1216     function forceSwapBackAndBurn() external onlyOwner {
1217         require(
1218             balanceOf(address(this)) >= swapTokensAtAmount,
1219             "Can only swap when token amount is at or higher than swapTokensAtAmount"
1220         );
1221         swapping = true;
1222         swapBackAndBurn();
1223         swapping = false;
1224         emit OwnerForcedSwapBackAndBurn(block.timestamp);
1225     }
1226 
1227     // only use to disable contract sales if absolutely necessary (emergency use only)
1228     function updateSwapBackEnabled(bool enabled) external onlyOwner {
1229         swapBackEnabled = enabled;
1230     }
1231 
1232     // remove trading limits
1233     function removeLimits() external onlyOwner {
1234         limitsInEffect = false;
1235     }
1236 
1237     function restoreLimits() external onlyOwner {
1238         limitsInEffect = true;
1239     }
1240 
1241     // combined function to autmatically add and create the initial LP and enable trading
1242     function addLPEnableTradingWithLaunchPenalty(uint256 blocksForPenalty, bool confirmLaunch) external onlyOwner {
1243         require(!tradingActive, "Trading is already active, cannot relaunch.");
1244         require(blocksForPenalty <= 10,"Cannot make penalty blocks more than 10");
1245         require(confirmLaunch, "Please confirm go time!");
1246 
1247         // add the liquidity
1248         require(address(this).balance > 0,"Must have ETH on contract to launch");
1249         require(balanceOf(address(this)) > 0,"Must have Tokens on contract to launch");
1250 
1251         //standard enable trading action
1252         tradingActive = true;
1253         swapBackEnabled = true;
1254         launchBlock = block.number;
1255         blockForLaunchPenaltyEnd = blocksForPenalty > 0 ? launchBlock + blocksForPenalty : launchBlock;
1256         penaltyBlocks = blocksForPenalty > 0 ? blocksForPenalty : 0;
1257         launchPenaltyPeriod = blocksForPenalty > 0 ? true : false;
1258         emit EnabledTrading();
1259 
1260         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1261 
1262         dexRouter.addLiquidityETH{value: address(this).balance}(
1263             address(this),
1264             balanceOf(address(this)),
1265             0, // slippage is unavoidable
1266             0, // slippage is unavoidable
1267             msg.sender,
1268             block.timestamp
1269         );
1270     }
1271 
1272     // add and create initial LP
1273     function addLP(bool _addLP) external onlyOwner {
1274         require(_addLP, "Please confirm add LP");
1275 
1276         // add the liquidity
1277         require(address(this).balance > 0,"Must have ETH on contract to launch");
1278         require(balanceOf(address(this)) > 0,"Must have Tokens on contract to launch");
1279 
1280         _approve(address(this), address(dexRouter), balanceOf(address(this)));
1281 
1282         dexRouter.addLiquidityETH{value: address(this).balance}(
1283             address(this),
1284             balanceOf(address(this)),
1285             0, // slippage is unavoidable
1286             0, // slippage is unavoidable
1287             msg.sender,
1288             block.timestamp
1289         );
1290     }
1291 
1292     // classic enable trading with no launch penalty period:
1293     function enableTrading() external onlyOwner {
1294         require(!tradingActive, "Trading is already active, cannot relaunch.");
1295 
1296         //standard enable trading action
1297         tradingActive = true;
1298         swapBackEnabled = true;
1299         launchBlock = block.number;
1300         penaltyBlocks = 0;
1301         blockForLaunchPenaltyEnd = launchBlock;
1302         launchPenaltyPeriod = false;
1303         emit EnabledTrading();
1304     }
1305 
1306 }