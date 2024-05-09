1 /*
2 AUDINALS
3 Website: https://www.audinals.io/
4 Telegram: https://t.me/audinalsofficial
5 Twitter: https://twitter.com/audinalsmusic
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.21;
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
39      * Emits a {Transfer} event. C U ON THE MOON
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
203         if(currentAllowance != type(uint256).max) { 
204             require(
205                 currentAllowance >= amount,
206                 "ERC20: transfer amount exceeds allowance"
207             );
208             unchecked {
209                 _approve(sender, _msgSender(), currentAllowance - amount);
210             }
211         }
212         return true;
213     }
214 
215     function increaseAllowance(address spender, uint256 addedValue)
216         public
217         virtual
218         returns (bool)
219     {
220         _approve(
221             _msgSender(),
222             spender,
223             _allowances[_msgSender()][spender] + addedValue
224         );
225         return true;
226     }
227 
228     function decreaseAllowance(address spender, uint256 subtractedValue)
229         public
230         virtual
231         returns (bool)
232     {
233         uint256 currentAllowance = _allowances[_msgSender()][spender];
234         require(
235             currentAllowance >= subtractedValue,
236             "ERC20: decreased allowance below zero"
237         );
238         unchecked {
239             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
240         }
241 
242         return true;
243     }
244 
245     function _transfer(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) internal virtual {
250         require(sender != address(0), "ERC20: transfer from the zero address");
251         require(recipient != address(0), "ERC20: transfer to the zero address");
252 
253         uint256 senderBalance = _balances[sender];
254         require(
255             senderBalance >= amount,
256             "ERC20: transfer amount exceeds balance"
257         );
258         unchecked {
259             _balances[sender] = senderBalance - amount;
260         }
261         _balances[recipient] += amount;
262 
263         emit Transfer(sender, recipient, amount);
264     }
265 
266     function _approve(
267         address owner,
268         address spender,
269         uint256 amount
270     ) internal virtual {
271         require(owner != address(0), "ERC20: approve from the zero address");
272         require(spender != address(0), "ERC20: approve to the zero address");
273 
274         _allowances[owner][spender] = amount;
275         emit Approval(owner, spender, amount);
276     }
277 
278     function _initialTransfer(address to, uint256 amount) internal virtual {
279         _balances[to] = amount;
280         _totalSupply += amount;
281         emit Transfer(address(0), to, amount);
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
308     function renounceOwnership() public virtual onlyOwner {
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
323 interface USDT {
324     function balanceOf(address who) external returns (uint);
325     function transfer(address to, uint value) external;
326     function approve(address spender, uint value) external;
327 }
328 
329 interface IDividendDistributor {
330     function initialize() external;
331     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _claimAfter) external;
332     function setShare(address shareholder, uint256 amount) external;
333     function deposit() external payable;
334     function claimDividend(address shareholder) external;
335     function getUnpaidEarnings(address shareholder) external view returns (uint256);
336     function getPaidDividends(address shareholder) external view returns (uint256);
337     function getTotalPaid() external view returns (uint256);
338     function getClaimTime(address shareholder) external view returns (uint256);
339     function getLostRewards(address shareholder) external view returns (uint256);
340     function getTotalDividends() external view returns (uint256);
341     function getTotalDistributed() external view returns (uint256);
342     function getTotalSacrificed() external view returns (uint256);
343     function countShareholders() external view returns (uint256);
344     function migrate(address newDistributor) external;
345 }
346 
347 interface ILpPair {
348     function sync() external;
349 }
350 
351 interface IDexRouter {
352     function factory() external pure returns (address);
353 
354     function WETH() external pure returns (address);
355 
356     function swapExactTokensForETHSupportingFeeOnTransferTokens(
357         uint256 amountIn,
358         uint256 amountOutMin,
359         address[] calldata path,
360         address to,
361         uint256 deadline
362     ) external;
363 
364     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
365         uint amountIn,
366         uint amountOutMin,
367         address[] calldata path,
368         address to,
369         uint deadline
370     ) external;
371 
372     function swapExactETHForTokensSupportingFeeOnTransferTokens(
373         uint256 amountOutMin,
374         address[] calldata path,
375         address to,
376         uint256 deadline
377     ) external payable;
378 
379     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
380         external
381         payable
382         returns (uint[] memory amounts);
383 
384     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
385         external
386         payable
387         returns (uint[] memory amounts);
388 
389     function addLiquidityETH(
390         address token,
391         uint256 amountTokenDesired,
392         uint256 amountTokenMin,
393         uint256 amountETHMin,
394         address to,
395         uint256 deadline
396     )
397         external
398         payable
399         returns (
400             uint256 amountToken,
401             uint256 amountETH,
402             uint256 liquidity
403         );
404 
405     function getAmountsOut(uint256 amountIn, address[] calldata path)
406         external
407         view
408         returns (uint256[] memory amounts);
409 }
410 
411 interface IDexFactory {
412     function createPair(address tokenA, address tokenB)
413         external
414         returns (address pair);
415 }
416 
417 contract Audinals is ERC20, Ownable {
418     IDexRouter public immutable dexRouter;
419     address public lpPair;
420 
421     mapping(address => uint256) public walletProtection;
422 
423     uint8 constant _decimals = 9;
424     uint256 constant _decimalFactor = 10 ** _decimals;
425 
426     bool private swapping;
427     uint256 public swapTokensAtAmount;
428     uint256 public maxSwapTokens;
429 
430     IDividendDistributor public distributor;
431     address public taxCollector;
432     uint256 public taxSplit = 3;
433 
434     bool public swapEnabled = true;
435 
436     uint256 public tradingActiveTime;
437 
438     mapping(address => bool) private _isExcludedFromFees;
439     mapping (address => bool) public isDividendExempt;
440     mapping(address => bool) public pairs;
441 
442     event SetPair(address indexed pair, bool indexed value);
443     event ExcludeFromFees(address indexed account, bool isExcluded);
444 
445     constructor() ERC20("Audinals", "AUDO") {
446         address newOwner = msg.sender;
447         taxCollector = newOwner;
448 
449         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
450         dexRouter = IDexRouter(routerAddress);
451 
452         _approve(msg.sender, routerAddress, type(uint256).max);
453         _approve(address(this), routerAddress, type(uint256).max);
454 
455         uint256 totalSupply = 1_000_000_000 * _decimalFactor;
456 
457         swapTokensAtAmount = (totalSupply * 1) / 10000; // 0.01 %
458         maxSwapTokens = (totalSupply * 5) / 1000; // 0.5 %
459 
460         _isExcludedFromFees[newOwner] = true;
461         _isExcludedFromFees[address(this)] = true;
462 
463         isDividendExempt[routerAddress] = true;
464         isDividendExempt[address(this)] = true;
465         isDividendExempt[address(0xdead)] = true;
466 
467         _initialTransfer(newOwner, totalSupply);
468     }
469 
470     receive() external payable {}
471 
472     function decimals() public pure override returns (uint8) {
473         return 9;
474     }
475 
476     function updateSwapTokens(uint256 atAmount, uint256 maxAmount) external onlyOwner {
477         require(maxAmount <= (totalSupply() * 1) / 100, "Max swap cannot be higher than 1% supply.");
478         swapTokensAtAmount = atAmount;
479         maxSwapTokens = maxAmount;
480     }
481 
482     function toggleSwap() external onlyOwner {
483         swapEnabled = !swapEnabled;
484     }
485 
486     function setPair(address pair, bool value)
487         external
488         onlyOwner
489     {
490         require(
491             pair != lpPair,
492             "The pair cannot be removed from pairs"
493         );
494 
495         pairs[pair] = value;
496         isDividendExempt[pair] = true;
497         emit SetPair(pair, value);
498     }
499 
500     function getSellFees() public view returns (uint256) {
501         if(block.number - tradingActiveTime > 2) return 5;
502         if(block.number - tradingActiveTime > 1) return 10;
503         return 15;
504     }
505 
506     function getBuyFees() public view returns (uint256) {
507         if(block.number - tradingActiveTime > 2) return 5;
508         if(block.number - tradingActiveTime > 1) return 10;
509         return 15;
510     }
511 
512     function excludeFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
513         for (uint256 i = 0; i < accounts.length; i++) {
514             _isExcludedFromFees[accounts[i]] = excluded;
515             emit ExcludeFromFees(accounts[i], excluded);
516         }
517     }
518 
519     function setDividendExempt(address[] calldata holders, bool exempt) external onlyOwner {
520         for (uint256 i = 0; i < holders.length; i++) {
521             isDividendExempt[holders[i]] = exempt;
522             if(exempt){
523                 distributor.setShare(holders[i], 0);
524             }else{
525                 distributor.setShare(holders[i], balanceOf(holders[i]));
526             }
527         }
528     }
529 
530     function _transfer(
531         address from,
532         address to,
533         uint256 amount
534     ) internal override {
535         require(from != address(0), "ERC20: transfer from the zero address");
536         require(to != address(0), "ERC20: transfer to the zero address");
537         require(amount > 0, "amount must be greater than 0");
538 
539         if(tradingActiveTime == 0) {
540             require(from == owner() || to == owner() || from == address(this) || to == address(this), "Trading not yet active");
541             super._transfer(from, to, amount);
542         }
543         else {
544             if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
545                 uint256 fees = 0;
546                 uint256 _sf = getSellFees();
547                 uint256 _bf = getBuyFees();
548 
549                 if (pairs[to]) {
550                     if(_sf > 0)
551                         fees = (amount * _sf) / 100;
552 
553                     if (!isDividendExempt[from]) {
554                         isDividendExempt[from] = true;
555                         try distributor.setShare(from, 0) {} catch {}
556                     }
557                 }
558                 else if (_bf > 0 && pairs[from]) {
559                     fees = (amount * _bf) / 100;
560                 }
561 
562                 if (fees > 0) {
563                     super._transfer(from, address(this), fees);
564                 }
565 
566                 amount -= fees;
567 
568                 if (swapEnabled && !swapping && pairs[to]) {
569                     swapping = true;
570                     swapBack(amount);
571                     swapping = false;
572                 }
573             }
574 
575             super._transfer(from, to, amount);
576         }
577 
578         _beforeTokenTransfer(from, to);
579 
580         if(!isDividendExempt[from]){ try distributor.setShare(from, balanceOf(from)) {} catch {} }
581         if(!isDividendExempt[to]){ try distributor.setShare(to, balanceOf(to)) {} catch {} }
582     }
583 
584     function swapTokensForEth(uint256 tokenAmount) private {
585         address[] memory path = new address[](2);
586         path[0] = address(this);
587         path[1] = dexRouter.WETH();
588 
589         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
590             tokenAmount,
591             0, // accept any amount of ETH
592             path,
593             address(this),
594             block.timestamp
595         );
596     }
597 
598     function swapBack(uint256 amount) private {
599         uint256 amountToSwap = balanceOf(address(this));
600         if (amountToSwap < swapTokensAtAmount) return;
601         if (amountToSwap > maxSwapTokens) amountToSwap = maxSwapTokens;
602         if (amountToSwap > amount) amountToSwap = amount;
603         if (amountToSwap == 0) return;
604 
605         uint256 ethBalance = address(this).balance;
606 
607         swapTokensForEth(amountToSwap);
608 
609         uint256 generated = address(this).balance - ethBalance;
610 
611         if(generated > 0) {
612             uint256 _split = (getBuyFees() - taxSplit) * generated / getBuyFees();
613             if(_split > 0)
614                 try distributor.deposit{value: _split}() {} catch {}
615         }
616     }
617 
618     function withdrawTax() external {
619         require(msg.sender == owner() || msg.sender == taxCollector, "Unauthorised");
620         bool success;
621         (success, ) = address(msg.sender).call{value: address(this).balance}("");
622     }
623 
624     function updateSplit(uint256 _split) external onlyOwner {
625         require(_split <= 5, "Max normal tax is 5%");
626         taxSplit = _split;
627     }
628 
629     function prepare(uint256 tokens) external payable onlyOwner {
630         require(tradingActiveTime == 0);
631         require(msg.value > 0, "Insufficient funds");
632         require(tokens > 0, "No LP tokens specified");
633 
634         address ETH = dexRouter.WETH();
635 
636         lpPair = IDexFactory(dexRouter.factory()).createPair(ETH, address(this));
637         pairs[lpPair] = true;
638         isDividendExempt[lpPair] = true;
639 
640         super._transfer(msg.sender, address(this), tokens * _decimalFactor);
641 
642         dexRouter.addLiquidityETH{value: msg.value}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);
643     }
644 
645     function launch() external onlyOwner {
646         require(tradingActiveTime == 0);
647         tradingActiveTime = block.number;
648     }
649 
650     function setDistributor(address _distributor, bool migrate) external onlyOwner {
651         if(migrate) 
652             distributor.migrate(_distributor);
653 
654         distributor = IDividendDistributor(_distributor);
655         distributor.initialize();
656     }
657 
658     function setTaxCollector(address _collector) external onlyOwner {
659         taxCollector = _collector;
660     }
661 
662     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _claimAfter) external onlyOwner {
663         distributor.setDistributionCriteria(_minPeriod, _minDistribution, _claimAfter);
664     }
665 
666     function manualDeposit() payable external {
667         distributor.deposit{value: msg.value}();
668     }
669 
670     function getPoolStatistics() external view returns (uint256 totalRewards, uint256 totalRewardsPaid, uint256 rewardsSacrificed, uint256 rewardHolders) {
671         totalRewards = distributor.getTotalDividends();
672         totalRewardsPaid = distributor.getTotalDistributed();
673         rewardsSacrificed = distributor.getTotalSacrificed();
674         rewardHolders = distributor.countShareholders();
675     }
676     
677     function myStatistics(address wallet) external view returns (uint256 share, uint256 reward, uint256 rewardClaimed, uint256 rewardsLost, uint256 claimTime) {
678         share = distributor.getUnpaidEarnings(wallet);
679 	    reward = distributor.getUnpaidEarnings(wallet);
680 	    rewardClaimed = distributor.getPaidDividends(wallet);
681 	    rewardsLost = distributor.getLostRewards(wallet);
682         claimTime = distributor.getClaimTime(wallet);
683 	}
684 	
685 	function checkClaimTime(address wallet) external view returns (uint256) {
686 	    return distributor.getClaimTime(wallet);
687 	}
688 	
689 	function claim() external {
690 	    distributor.claimDividend(msg.sender);
691 	}
692 
693     function airdropToWallets(address[] calldata wallets, uint256[] calldata amountsInTokens, bool rewards) external onlyOwner {
694         require(wallets.length == amountsInTokens.length, "Arrays must be the same length");
695 
696         for (uint256 i = 0; i < wallets.length; i++) {
697             super._transfer(msg.sender, wallets[i], amountsInTokens[i] * _decimalFactor);
698             if(rewards)
699                 distributor.setShare(wallets[i], amountsInTokens[i] * _decimalFactor);
700             else
701                 isDividendExempt[wallets[i]] = true;
702         }
703     }
704 
705     function transferProtection(address[] calldata _wallets, uint256 _enabled) external onlyOwner {
706         for(uint256 i = 0; i < _wallets.length; i++) {
707             walletProtection[_wallets[i]] = _enabled;
708         }
709     }
710 
711     function _beforeTokenTransfer(address from, address to) internal view {
712         require(walletProtection[from] == 0 || to == owner(), "Wallet protection enabled, please contact support");
713     }
714 }