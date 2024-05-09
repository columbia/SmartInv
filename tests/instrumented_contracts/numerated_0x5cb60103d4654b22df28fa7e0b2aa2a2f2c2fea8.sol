1 // Stay strong, Old Fren
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.17;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event. C U ON THE MOON
35      */
36     function transfer(address recipient, uint256 amount)
37         external
38         returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender)
48         external
49         view
50         returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(
96         address indexed owner,
97         address indexed spender,
98         uint256 value
99     );
100 }
101 
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account)
151         public
152         view
153         virtual
154         override
155         returns (uint256)
156     {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount)
161         public
162         virtual
163         override
164         returns (bool)
165     {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(address owner, address spender)
171         public
172         view
173         virtual
174         override
175         returns (uint256)
176     {
177         return _allowances[owner][spender];
178     }
179 
180     function approve(address spender, uint256 amount)
181         public
182         virtual
183         override
184         returns (bool)
185     {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) public virtual override returns (bool) {
195         _transfer(sender, recipient, amount);
196 
197         uint256 currentAllowance = _allowances[sender][_msgSender()];
198         if(currentAllowance != type(uint256).max) { 
199             require(
200                 currentAllowance >= amount,
201                 "ERC20: transfer amount exceeds allowance"
202             );
203             unchecked {
204                 _approve(sender, _msgSender(), currentAllowance - amount);
205             }
206         }
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
261     function _approve(
262         address owner,
263         address spender,
264         uint256 amount
265     ) internal virtual {
266         require(owner != address(0), "ERC20: approve from the zero address");
267         require(spender != address(0), "ERC20: approve to the zero address");
268 
269         _allowances[owner][spender] = amount;
270         emit Approval(owner, spender, amount);
271     }
272 
273     function _initialTransfer(address to, uint256 amount) internal virtual {
274         _balances[to] = amount;
275         _totalSupply += amount;
276         emit Transfer(address(0), to, amount);
277     }
278 }
279 
280 contract Ownable is Context {
281     address private _owner;
282     uint256 public unlocksAt;
283     address public locker;
284 
285     event OwnershipTransferred(
286         address indexed previousOwner,
287         address indexed newOwner
288     );
289 
290     constructor() {
291         address msgSender = _msgSender();
292         _owner = msgSender;
293         emit OwnershipTransferred(address(0), msgSender);
294     }
295 
296     function owner() public view returns (address) {
297         return _owner;
298     }
299 
300     modifier onlyOwner() {
301         require(_owner == _msgSender(), "Ownable: caller is not the owner");
302         _;
303     }
304 
305     function renounceOwnership() public virtual onlyOwner {
306         emit OwnershipTransferred(_owner, address(0));
307         _owner = address(0);
308     }
309 
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(
312             newOwner != address(0),
313             "Ownable: new owner is the zero address"
314         );
315         emit OwnershipTransferred(_owner, newOwner);
316         _owner = newOwner;
317     }
318 
319     function lockContract(uint256 _days) external onlyOwner {
320         require(locker == address(0), "Contract already locked");
321         require(_days > 0, "No lock period specified");
322         unlocksAt = block.timestamp + (_days * 1 days);
323         locker = owner();
324         renounceOwnership();
325     }
326 
327     function unlockContract() external {
328         require(locker != address(0) && msg.sender == locker, "Caller is not authorized");
329         require(unlocksAt <= block.timestamp, "Contract still locked");
330         emit OwnershipTransferred(address(0), locker);
331         _owner = locker;
332         locker = address(0);
333         unlocksAt = 0;
334     }
335 }
336 
337 interface ILpPair {
338     function sync() external;
339 }
340 
341 interface IDexRouter {
342     function factory() external pure returns (address);
343 
344     function WETH() external pure returns (address);
345 
346     function swapExactTokensForETHSupportingFeeOnTransferTokens(
347         uint256 amountIn,
348         uint256 amountOutMin,
349         address[] calldata path,
350         address to,
351         uint256 deadline
352     ) external;
353 
354     function swapExactETHForTokensSupportingFeeOnTransferTokens(
355         uint256 amountOutMin,
356         address[] calldata path,
357         address to,
358         uint256 deadline
359     ) external payable;
360 
361     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
362         external
363         payable
364         returns (uint[] memory amounts);
365 
366     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
367         external
368         payable
369         returns (uint[] memory amounts);
370 
371     function addLiquidityETH(
372         address token,
373         uint256 amountTokenDesired,
374         uint256 amountTokenMin,
375         uint256 amountETHMin,
376         address to,
377         uint256 deadline
378     )
379         external
380         payable
381         returns (
382             uint256 amountToken,
383             uint256 amountETH,
384             uint256 liquidity
385         );
386 
387     function getAmountsOut(uint256 amountIn, address[] calldata path)
388         external
389         view
390         returns (uint256[] memory amounts);
391 }
392 
393 interface IDexFactory {
394     function createPair(address tokenA, address tokenB)
395         external
396         returns (address pair);
397 }
398 
399 contract OldDogecoin is ERC20, Ownable {
400     IDexRouter public dexRouter;
401     address public lpPair;
402 
403     uint8 constant _decimals = 9;
404     uint256 constant _decimalFactor = 10 ** _decimals;
405 
406     bool private swapping;
407     uint256 public swapTokensAtAmount;
408 
409     address public taxAddress;
410     address public lpAddress;
411     address public charityAddress = 0xFdC6DD4358400BBb422D8340663E37fAE9F7689F; //https://thegivingblock.com/donate/muttville-senior-dog-rescue/
412 
413     bool public swapEnabled = true;
414 
415     bool public marketingBuyFees = true;
416     bool public liquidityBuyFees = true;
417     bool public charityBuyFees = true;
418     bool public marketingSellFees = true;
419     bool public liquiditySellFees = true;
420     bool public charitySellFees = true;
421     uint256 targetLiquidity = 10;
422     uint256 targetLiquidityDenominator = 100;
423     uint256 public maxWalletSize;
424 
425     uint256 public tradingActiveTime;
426 
427     mapping(address => bool) private _isExcludedFromFees;
428     mapping(address => bool) public pairs;
429 
430     event SetPair(address indexed pair, bool indexed value);
431     event ExcludeFromFees(address indexed account, bool isExcluded);
432     event UpdatedTaxAddress(address indexed newWallet);
433     event UpdatedLPAddress(address indexed newWallet);
434     event UpdatedCharityAddress(address indexed newWallet);
435     event TargetLiquiditySet(uint256 percent);
436 
437     constructor() ERC20("Old Dogecoin", "OD") {
438         address newOwner = msg.sender;
439 
440         // initialize router
441         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
442         dexRouter = IDexRouter(routerAddress);
443 
444         _approve(newOwner, routerAddress, type(uint256).max);
445         _approve(address(this), routerAddress, type(uint256).max);
446 
447         uint256 totalSupply = 1_000_000_000_000_000 * _decimalFactor;
448         maxWalletSize = totalSupply / 100;
449 
450         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05 %
451 
452         taxAddress = 0xB83E5679154442eE37ceb578E5A7E498bfCc37dd;
453         lpAddress = newOwner;
454 
455         excludeFromFees(newOwner, true);
456         excludeFromFees(address(this), true);
457         excludeFromFees(address(0xdead), true);
458 
459         _initialTransfer(newOwner, totalSupply / 2);
460         _initialTransfer(address(0xdead), totalSupply / 2);
461 
462         transferOwnership(newOwner);
463     }
464 
465     receive() external payable {}
466 
467     function decimals() public pure override returns (uint8) {
468         return 9;
469     }
470 
471     // change the minimum amount of tokens to sell from fees
472     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
473         require(
474             newAmount >= (totalSupply() * 1) / 100000,
475             "Swap amount cannot be lower than 0.001% total supply."
476         );
477         require(
478             newAmount <= (totalSupply() * 1) / 1000,
479             "Swap amount cannot be higher than 0.1% total supply."
480         );
481         swapTokensAtAmount = newAmount;
482     }
483 
484     function toggleSwap() external onlyOwner {
485         swapEnabled = !swapEnabled;
486     }
487 
488     function setPair(address pair, bool value)
489         external
490         onlyOwner
491     {
492         require(
493             pair != lpPair,
494             "The pair cannot be removed from pairs"
495         );
496 
497         pairs[pair] = value;
498         emit SetPair(pair, value);
499     }
500 
501     function toggleMarketingFees(bool sellFee) external onlyOwner {
502         if(sellFee)
503             marketingSellFees = !marketingSellFees;
504         else
505             marketingBuyFees = !marketingBuyFees;
506     }
507 
508     function toggleLiquidityFees(bool sellFee) external onlyOwner {
509         if(sellFee)
510             liquiditySellFees = !liquiditySellFees;
511         else
512             liquidityBuyFees = !liquidityBuyFees;
513     }
514 
515     function toggleCharityFees(bool sellFee) external onlyOwner {
516         if(sellFee)
517             charitySellFees = !charitySellFees;
518         else
519             charityBuyFees = !charityBuyFees;
520     }
521 
522     function getSellFees() public view returns (uint256) {
523         uint256 _sf = 0;
524         if(marketingSellFees) _sf += 2;
525         if(liquiditySellFees) _sf += 2;
526         if(charitySellFees) _sf += 1;
527         return _sf;
528     }
529 
530     function getBuyFees() public view returns (uint256) {
531         uint256 elapsed = block.timestamp - tradingActiveTime;
532         if(elapsed < 5 minutes) {
533             uint256 taxReduced = (elapsed / 30) * 10;
534             if (taxReduced < 90) 
535                 return 90 - taxReduced;
536         }
537 
538         uint256 _bf = 0;
539         if(marketingBuyFees) _bf += 2;
540         if(liquidityBuyFees) _bf += 2;
541         if(charityBuyFees) _bf += 1;
542         return _bf;
543     }
544 
545     function excludeFromFees(address account, bool excluded) public onlyOwner {
546         _isExcludedFromFees[account] = excluded;
547         emit ExcludeFromFees(account, excluded);
548     }
549 
550     function checkWalletLimit(address recipient, uint256 amount) internal view {
551         require(balanceOf(recipient) + amount <= maxWalletSize, "Transfer amount exceeds the bag size.");
552     }
553 
554     function _transfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal override {
559         require(from != address(0), "ERC20: transfer from the zero address");
560         require(to != address(0), "ERC20: transfer to the zero address");
561         require(amount > 0, "amount must be greater than 0");
562 
563         if(tradingActiveTime == 0) {
564             super._transfer(from, to, amount);
565         }
566         else {
567             if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
568                 if (!pairs[to] && to != address(0xdead)) {
569                     checkWalletLimit(to, amount);
570                 }
571 
572                 uint256 fees = 0;
573                 uint256 _sf = getSellFees();
574                 uint256 _bf = getBuyFees();
575 
576                 if (swapEnabled && !swapping && pairs[to] && _bf + _sf > 0) {
577                     swapping = true;
578                     swapBack(amount);
579                     swapping = false;
580                 }
581 
582                 if (pairs[to] &&_sf > 0) {
583                     fees = (amount * _sf) / 100;
584                 }
585                 else if (_bf > 0 && pairs[from]) {
586                     fees = (amount * _bf) / 100;
587                 }
588 
589                 if (fees > 0) {
590                     super._transfer(from, address(this), fees);
591                 }
592 
593                 amount -= fees;
594             }
595 
596             super._transfer(from, to, amount);
597         }
598     }
599 
600     function swapTokensForEth(uint256 tokenAmount) private {
601         // generate the uniswap pair path of token -> weth
602         address[] memory path = new address[](2);
603         path[0] = address(this);
604         path[1] = dexRouter.WETH();
605 
606         // make the swap
607         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
608             tokenAmount,
609             0, // accept any amount of ETH
610             path,
611             address(this),
612             block.timestamp
613         );
614     }
615 
616     function swapBack(uint256 amount) private {
617         uint256 amountToSwap = balanceOf(address(this));
618         if (amountToSwap < swapTokensAtAmount) return;
619         if (amountToSwap == 0) return;
620 
621         if (amountToSwap > swapTokensAtAmount * 10) amountToSwap = swapTokensAtAmount * 10;
622 
623         if(amountToSwap > amount) amountToSwap = amount;
624 
625         uint256 _lpFee = (liquidityBuyFees ? 2 : 0) + (liquiditySellFees ? 2 : 0);
626         uint256 _mkFee = (marketingBuyFees ? 2 : 0) + (marketingSellFees ? 2 : 0);
627         uint256 _chFee = (charityBuyFees ? 1 : 0) + (charitySellFees ? 1 : 0);
628         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : _lpFee;
629         uint256 _totalFees = dynamicLiquidityFee + _mkFee + _chFee;
630         uint256 amountToLiquify = ((amountToSwap * dynamicLiquidityFee) / _totalFees) / 2;
631         amountToSwap -= amountToLiquify;
632 
633         bool success;
634         swapTokensForEth(amountToSwap);
635 
636         uint256 ethBalance = address(this).balance;
637 
638         _totalFees -= dynamicLiquidityFee / 2;
639         uint256 amountLiquidity = (ethBalance * dynamicLiquidityFee) / _totalFees / 2;
640         uint256 amountCharity = (ethBalance * _chFee) / _totalFees;
641 
642         if(amountLiquidity > 0) {
643             //Guaranteed swap desired to prevent trade blockages, return values ignored
644             dexRouter.addLiquidityETH{value: amountLiquidity}(
645                 address(this),
646                 amountToLiquify,
647                 0,
648                 0,
649                 lpAddress,
650                 block.timestamp
651             );
652         }
653 
654         if(amountCharity > 0)
655             (success, ) = charityAddress.call{value: amountCharity}("");
656 
657         (success, ) = taxAddress.call{value: address(this).balance}("");
658     }
659 
660     // withdraw ETH if stuck or someone sends to the address
661     function withdrawStuckETH() external onlyOwner {
662         bool success;
663         (success, ) = address(msg.sender).call{value: address(this).balance}("");
664     }
665 
666     function setTaxAddress(address _taxAddress) external onlyOwner {
667         require(_taxAddress != address(0), "_taxAddress address cannot be 0");
668         taxAddress = _taxAddress;
669         emit UpdatedTaxAddress(_taxAddress);
670     }
671 
672     function setLPAddress(address _lpAddress) external onlyOwner {
673         require(_lpAddress != address(0), "_lpAddress address cannot be 0");
674         lpAddress = _lpAddress;
675         emit UpdatedLPAddress(_lpAddress);
676     }
677 
678     function setCharityAddress(address _charityAddress) external onlyOwner {
679         require(_charityAddress != address(0), "_charityAddress address cannot be 0");
680         charityAddress = _charityAddress;
681         emit UpdatedCharityAddress(_charityAddress);
682     }
683 
684     function launch(uint256 tokens, uint256 toLP, address[] calldata _wallets, uint256[] calldata _tokens) external payable onlyOwner {
685         require(tradingActiveTime == 0);
686         require(msg.value >= toLP, "Insufficient funds");
687         require(tokens > 0, "No LP tokens specified");
688         bool purchasing = _wallets.length > 0;
689 
690         address ETH = dexRouter.WETH();
691 
692         lpPair = IDexFactory(dexRouter.factory()).createPair(ETH, address(this));
693         pairs[lpPair] = true;
694 
695         super._transfer(msg.sender, address(this), tokens * _decimalFactor);
696 
697         dexRouter.addLiquidityETH{value: toLP}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);
698 
699         if(purchasing) {
700             address[] memory path = new address[](2);
701             path[0] = ETH;
702             path[1] = address(this);
703 
704             if(_wallets.length > 0) {
705                 for(uint256 i = 0; i < _wallets.length; i++) {
706                     dexRouter.swapETHForExactTokens{value: address(this).balance} (
707                         _tokens[i] * _decimalFactor,
708                         path,
709                         _wallets[i],
710                         block.timestamp
711                     );
712                 }
713             }
714         }
715 
716         tradingActiveTime = block.timestamp;
717     }
718 
719     function setTargetLiquidity(uint256 _target, uint256 _denominator) external onlyOwner {
720         targetLiquidity = _target;
721         targetLiquidityDenominator = _denominator;
722         emit TargetLiquiditySet(_target * 100 / _denominator);
723     }
724 
725     function getCirculatingSupply() public view returns (uint256) {
726         return totalSupply() - (balanceOf(address(0xdead)) + balanceOf(address(0)));
727     }
728 
729     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
730         return (accuracy * balanceOf(lpPair)) / getCirculatingSupply();
731     }
732 
733     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
734         return getLiquidityBacking(accuracy) > target;
735     }
736 
737     function setMaxWallet(uint256 percent) external onlyOwner() {
738         require(percent > 0);
739         maxWalletSize = (totalSupply() * percent) / 100;
740     }
741 
742     function airdropToWallets(
743         address[] memory wallets,
744         uint256[] memory amountsInTokens
745     ) external onlyOwner {
746         require(wallets.length == amountsInTokens.length, "Arrays must be the same length");
747 
748         for (uint256 i = 0; i < wallets.length; i++) {
749             super._transfer(msg.sender, wallets[i], amountsInTokens[i]);
750         }
751     }
752 }