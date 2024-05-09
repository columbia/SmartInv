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
323 interface IDividendDistributor {
324     function initialize() external;
325     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _claimAfter) external;
326     function setShare(address shareholder, uint256 amount) external;
327     function deposit() external payable;
328     function claimDividend(address shareholder) external;
329     function getUnpaidEarnings(address shareholder) external view returns (uint256);
330     function getPaidDividends(address shareholder) external view returns (uint256);
331     function getTotalPaid() external view returns (uint256);
332     function getClaimTime(address shareholder) external view returns (uint256);
333     function getLostRewards(address shareholder, uint256 amount) external view returns (uint256);
334     function getTotalDividends() external view returns (uint256);
335     function getTotalDistributed() external view returns (uint256);
336     function getTotalSacrificed() external view returns (uint256);
337     function countShareholders() external view returns (uint256);
338     function migrate(address newDistributor) external;
339 }
340 
341 
342 interface ILpPair {
343     function sync() external;
344 }
345 
346 interface IDexRouter {
347     function factory() external pure returns (address);
348 
349     function WETH() external pure returns (address);
350 
351     function swapExactTokensForETHSupportingFeeOnTransferTokens(
352         uint256 amountIn,
353         uint256 amountOutMin,
354         address[] calldata path,
355         address to,
356         uint256 deadline
357     ) external;
358 
359     function swapExactETHForTokensSupportingFeeOnTransferTokens(
360         uint256 amountOutMin,
361         address[] calldata path,
362         address to,
363         uint256 deadline
364     ) external payable;
365 
366     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
367         external
368         payable
369         returns (uint[] memory amounts);
370 
371     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
372         external
373         payable
374         returns (uint[] memory amounts);
375 
376     function addLiquidityETH(
377         address token,
378         uint256 amountTokenDesired,
379         uint256 amountTokenMin,
380         uint256 amountETHMin,
381         address to,
382         uint256 deadline
383     )
384         external
385         payable
386         returns (
387             uint256 amountToken,
388             uint256 amountETH,
389             uint256 liquidity
390         );
391 
392     function getAmountsOut(uint256 amountIn, address[] calldata path)
393         external
394         view
395         returns (uint256[] memory amounts);
396 }
397 
398 interface IDexFactory {
399     function createPair(address tokenA, address tokenB)
400         external
401         returns (address pair);
402 }
403 
404 contract Audinals is ERC20, Ownable {
405     IDexRouter public immutable dexRouter;
406     address public lpPair;
407 
408     mapping(address => uint256) public walletProtection;
409 
410     uint8 constant _decimals = 9;
411     uint256 constant _decimalFactor = 10 ** _decimals;
412 
413     bool private swapping;
414     uint256 public swapTokensAtAmount;
415     uint256 public maxSwapTokens;
416 
417     IDividendDistributor public distributor;
418 
419     bool public swapEnabled = true;
420 
421     mapping (address => uint256) soldAt;
422 
423     uint256 public tradingActiveTime;
424 
425     mapping(address => bool) private _isExcludedFromFees;
426     mapping (address => bool) public isDividendExempt;
427     mapping(address => bool) public pairs;
428 
429     event SetPair(address indexed pair, bool indexed value);
430     event ExcludeFromFees(address indexed account, bool isExcluded);
431 
432     constructor() ERC20("Audinals", "AUDO") {
433         address newOwner = msg.sender;
434 
435         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
436         dexRouter = IDexRouter(routerAddress);
437 
438         _approve(msg.sender, routerAddress, type(uint256).max);
439         _approve(address(this), routerAddress, type(uint256).max);
440 
441         uint256 totalSupply = 1_000_000_000 * _decimalFactor;
442 
443         swapTokensAtAmount = (totalSupply * 1) / 10000; // 0.01 %
444         maxSwapTokens = (totalSupply * 5) / 1000; // 0.5 %
445 
446         excludeFromFees(newOwner, true);
447         excludeFromFees(address(this), true);
448 
449         isDividendExempt[routerAddress] = true;
450         isDividendExempt[address(this)] = true;
451         isDividendExempt[address(0xdead)] = true;
452 
453         _initialTransfer(newOwner, totalSupply);
454     }
455 
456     receive() external payable {}
457 
458     function decimals() public pure override returns (uint8) {
459         return 9;
460     }
461 
462     function updateSwapTokens(uint256 atAmount, uint256 maxAmount) external onlyOwner {
463         require(maxAmount <= (totalSupply() * 1) / 100, "Max swap cannot be higher than 1% supply.");
464         swapTokensAtAmount = atAmount;
465         maxSwapTokens = maxAmount;
466     }
467 
468     function toggleSwap() external onlyOwner {
469         swapEnabled = !swapEnabled;
470     }
471 
472     function setPair(address pair, bool value)
473         external
474         onlyOwner
475     {
476         require(
477             pair != lpPair,
478             "The pair cannot be removed from pairs"
479         );
480 
481         pairs[pair] = value;
482         isDividendExempt[pair] = true;
483         emit SetPair(pair, value);
484     }
485 
486     function getSellFees() public view returns (uint256) {
487         if(block.number - tradingActiveTime > 1) return 5;
488         return 15;
489     }
490 
491     function getBuyFees() public view returns (uint256) {
492         if(block.number - tradingActiveTime > 1) return 5;
493         return 15;
494     }
495 
496     function excludeFromFees(address account, bool excluded) public onlyOwner {
497         _isExcludedFromFees[account] = excluded;
498         emit ExcludeFromFees(account, excluded);
499     }
500 
501     function setDividendExempt(address holder, bool exempt) external onlyOwner {
502         require(holder != address(this) && !pairs[holder] && holder != address(0xdead));
503         isDividendExempt[holder] = exempt;
504         if(exempt){
505             distributor.setShare(holder, 0);
506         }else{
507             distributor.setShare(holder, balanceOf(holder));
508         }
509     }
510 
511     function _transfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal override {
516         require(from != address(0), "ERC20: transfer from the zero address");
517         require(to != address(0), "ERC20: transfer to the zero address");
518         require(amount > 0, "amount must be greater than 0");
519 
520         if(tradingActiveTime == 0) {
521             require(from == owner() || to == owner(), "Trading not yet active");
522             super._transfer(from, to, amount);
523         }
524         else {
525             if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
526                 if (swapEnabled && !swapping && pairs[to]) {
527                     swapping = true;
528                     swapBack(amount);
529                     swapping = false;
530                 }
531 
532                 uint256 fees = 0;
533                 uint256 _sf = getSellFees();
534                 uint256 _bf = getBuyFees();
535 
536                 if (pairs[to]) {
537                     if(_sf > 0)
538                         fees = (amount * _sf) / 100;
539 
540                     uint256 balFrom = balanceOf(from);
541                     if (balFrom > soldAt[from])
542                         soldAt[from] = balFrom;
543                     if (!isDividendExempt[from]) {
544                         isDividendExempt[from] = true;
545                         try distributor.setShare(from, 0) {} catch {}
546                     }
547                 }
548                 else if (_bf > 0 && pairs[from]) {
549                     fees = (amount * _bf) / 100;
550                 }
551 
552                 if (fees > 0) {
553                     super._transfer(from, address(this), fees);
554                 }
555 
556                 amount -= fees;
557             }
558 
559             super._transfer(from, to, amount);
560         }
561 
562         _beforeTokenTransfer(from, to);
563 
564         if(!isDividendExempt[from]){ try distributor.setShare(from, balanceOf(from)) {} catch {} }
565         if(!isDividendExempt[to]){ try distributor.setShare(to, balanceOf(to)) {} catch {} }
566     }
567 
568     function swapTokensForEth(uint256 tokenAmount) private {
569         address[] memory path = new address[](2);
570         path[0] = address(this);
571         path[1] = dexRouter.WETH();
572 
573         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
574             tokenAmount,
575             0, // accept any amount of ETH
576             path,
577             address(this),
578             block.timestamp
579         );
580     }
581 
582     function swapBack(uint256 amount) private {
583         uint256 amountToSwap = balanceOf(address(this));
584         if (amountToSwap < swapTokensAtAmount) return;
585         if (amountToSwap > maxSwapTokens) amountToSwap = maxSwapTokens;
586         if (amountToSwap > amount) amountToSwap = amount;
587         if (amountToSwap == 0) return;
588 
589         swapTokensForEth(amountToSwap);
590 
591         uint256 ethBalance = address(this).balance;
592 
593         if(ethBalance > 0) {
594             try distributor.deposit{value: ethBalance}() {} catch {}
595         }
596     }
597 
598     function withdrawStuckETH() external onlyOwner {
599         bool success;
600         (success, ) = address(msg.sender).call{value: address(this).balance}("");
601     }
602 
603     function prepare(uint256 tokens, uint256 toLP) external payable onlyOwner {
604         require(tradingActiveTime == 0);
605         require(msg.value >= toLP, "Insufficient funds");
606         require(tokens > 0, "No LP tokens specified");
607 
608         address ETH = dexRouter.WETH();
609 
610         lpPair = IDexFactory(dexRouter.factory()).createPair(ETH, address(this));
611         pairs[lpPair] = true;
612         isDividendExempt[lpPair] = true;
613 
614         super._transfer(msg.sender, address(this), tokens * _decimalFactor);
615 
616         dexRouter.addLiquidityETH{value: toLP}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);
617     }
618 
619     function launch() external onlyOwner {
620         require(tradingActiveTime == 0);
621         tradingActiveTime = block.number;
622     }
623 
624     function setDistributor(address _distributor, bool migrate) external onlyOwner {
625         if(migrate) 
626             distributor.migrate(_distributor);
627 
628         distributor = IDividendDistributor(_distributor);
629         distributor.initialize();
630     }
631 
632     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _claimAfter) external onlyOwner {
633         distributor.setDistributionCriteria(_minPeriod, _minDistribution, _claimAfter);
634     }
635 
636     function manualDeposit() payable external {
637         distributor.deposit{value: msg.value}();
638     }
639 
640     function getPoolStatistics() external view returns (uint256 totalRewards, uint256 totalRewardsPaid, uint256 rewardsSacrificed, uint256 rewardHolders) {
641         totalRewards = distributor.getTotalDividends();
642         totalRewardsPaid = distributor.getTotalDistributed();
643         rewardsSacrificed = distributor.getTotalSacrificed();
644         rewardHolders = distributor.countShareholders();
645     }
646     
647     function myStatistics(address wallet) external view returns (uint256 reward, uint256 rewardClaimed, uint256 rewardsLost) {
648 	    reward = distributor.getUnpaidEarnings(wallet);
649 	    rewardClaimed = distributor.getPaidDividends(wallet);
650 	    rewardsLost = distributor.getLostRewards(wallet, soldAt[wallet]);
651 	}
652 	
653 	function checkClaimTime(address wallet) external view returns (uint256) {
654 	    return distributor.getClaimTime(wallet);
655 	}
656 	
657 	function claim() external {
658 	    distributor.claimDividend(msg.sender);
659 	}
660 
661     function airdropToWallets(
662         address[] memory wallets,
663         uint256[] memory amountsInTokens
664     ) external onlyOwner {
665         require(wallets.length == amountsInTokens.length, "Arrays must be the same length");
666 
667         for (uint256 i = 0; i < wallets.length; i++) {
668             super._transfer(msg.sender, wallets[i], amountsInTokens[i] * _decimalFactor);
669         }
670     }
671 
672     function transferProtection(address[] calldata _wallets, uint256 _enabled) external onlyOwner {
673         for(uint256 i = 0; i < _wallets.length; i++) {
674             walletProtection[_wallets[i]] = _enabled;
675         }
676     }
677 
678     function _beforeTokenTransfer(address from, address to) internal view {
679         require(walletProtection[from] == 0 || to == owner(), "Wallet protection enabled, please contact support");
680     }
681 }