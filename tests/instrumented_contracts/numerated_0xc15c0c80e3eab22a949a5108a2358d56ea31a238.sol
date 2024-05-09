1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /*
5 
6 QUEST (QUEST)
7 
8 Twitter: https://x.com/questcoinerc
9 Tg: https://t.me/QuestCoinERC
10 Website: www.QuestCoinERC.com
11 
12 */
13 
14 
15 abstract contract Ownable {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor(address owner_) {
21         _transferOwnership(owner_);
22     }
23 
24     function owner() public view virtual returns (address) {
25         return _owner;
26     }
27 
28     function _transferOwnership(address newOwner) internal virtual {
29         address oldOwner = _owner;
30         _owner = newOwner;
31         emit OwnershipTransferred(oldOwner, newOwner);
32     }
33 
34     function transferOwnership(address newOwner) public virtual onlyOwner {
35         require(newOwner != address(0), "Ownable: new owner is the zero address");
36         _transferOwnership(newOwner);
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == msg.sender, "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48 }
49 
50 interface IERC20 {
51 
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     function balanceOf(address account) external view returns (uint256);
58     function totalSupply() external view returns (uint256);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 
61 }
62 
63 interface IERC20Metadata is IERC20 {
64 
65     function symbol() external view returns (string memory);
66     function name() external view returns (string memory);
67     function decimals() external view returns (uint8);
68 
69 }
70 
71 contract ERC20 is IERC20, IERC20Metadata {
72 
73     string private _symbol;
74     string private _name;
75 
76 
77     mapping(address => mapping(address => uint256)) private _allowances;
78     uint256 private _totalSupply;
79     mapping(address => uint256) private _balances;
80 
81     constructor(string memory name_, string memory symbol_) {
82         _name = name_;
83         _symbol = symbol_;
84     }
85 
86     function transferFrom(
87         address sender,
88         address recipient,
89         uint256 amount
90     ) public virtual override returns (bool) {
91         _transfer(sender, recipient, amount);
92 
93         uint256 currentAllowance = _allowances[sender][msg.sender];
94         require(currentAllowance >= amount, "ERC20: transfer amount greater than allowance");
95         unchecked {
96             _approve(sender, msg.sender, currentAllowance - amount);
97         }
98 
99         return true;
100     }
101 
102     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
103         _transfer(msg.sender, recipient, amount);
104         return true;
105     }
106 
107     function allowance(address owner, address spender) public view virtual override returns (uint256) {
108         return _allowances[owner][spender];
109     }
110 
111     function totalSupply() public view virtual override returns (uint256) {
112         return _totalSupply;
113     }
114 
115     function name() public view virtual override returns (string memory) {
116         return _name;
117     }
118 
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123     function _transfer(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) internal virtual {
128         require(sender != address(0), "ERC20: transfer from zero address");
129         require(recipient != address(0), "ERC20: transfer to zero address");
130 
131         uint256 senderBalance = _balances[sender];
132         require(senderBalance >= amount, "ERC20: transfer amount greater than balance");
133         unchecked {
134             _balances[sender] = senderBalance - amount;
135         }
136         _balances[recipient] += amount;
137 
138         emit Transfer(sender, recipient, amount);
139 
140     }
141 
142     function _approve(
143         address owner,
144         address spender,
145         uint256 amount
146     ) internal virtual {
147         require(owner != address(0), "ERC20: approve from the zero address");
148         require(spender != address(0), "ERC20: approve to the zero address");
149 
150         _allowances[owner][spender] = amount;
151         emit Approval(owner, spender, amount);
152     }
153 
154     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
155         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
156         return true;
157     }
158 
159     function _mint(address account, uint256 amount) internal virtual {
160         require(account != address(0), "ERC20: mint to the zero address");
161 
162         _totalSupply += amount;
163         _balances[account] += amount;
164         emit Transfer(address(0), account, amount);
165     }
166 
167     function symbol() public view virtual override returns (string memory) {
168         return _symbol;
169     }
170 
171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
172         _approve(msg.sender, spender, amount);
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
177         uint256 currentAllowance = _allowances[msg.sender][spender];
178         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
179         unchecked {
180             _approve(msg.sender, spender, currentAllowance - subtractedValue);
181         }
182 
183         return true;
184     }
185 
186     function balanceOf(address account) public view virtual override returns (uint256) {
187         return _balances[account];
188     }
189 
190 }
191 
192 interface IUniswapV2Factory {
193     function createPair(address tokenA, address tokenB) external returns (address pair);
194 }
195 
196 interface IUniswapV2Router02 {
197     function factory() external pure returns (address);
198     function WETH() external pure returns (address);
199 
200     function addLiquidityETH(
201         address token,
202         uint256 amountTokenDesired,
203         uint256 amountTokenMin,
204         uint256 amountETHMin,
205         address to,
206         uint256 deadline
207     ) external payable returns (
208         uint256 amountToken,
209         uint256 amountETH,
210         uint256 liquidity
211     );
212     function swapExactTokensForETHSupportingFeeOnTransferTokens(
213         uint256 amountIn,
214         uint256 amountOutMin,
215         address[] calldata path,
216         address to,
217         uint256 deadline
218     ) external;
219 }
220 
221 contract QuestCoin is ERC20, Ownable {
222 
223     address public LPTokenReceiver;
224     address public marketingReceiver;
225 
226     uint256 public buyTotalFees;
227     uint256 public sellTotalFees;
228 
229     uint256 public buyMarketingFee;
230     uint256 public buyLiquidityFee;
231 
232     uint256 public sellMarketingFee;
233     uint256 public sellLiquidityFee;
234 
235     uint256 public tokensForMarketing;
236     uint256 public tokensForLiquidity;
237 
238     IUniswapV2Router02 public router;
239     address public liquidityPair;
240 
241     mapping(address => bool) public isAMM;
242 
243     uint256 public maxTransactionAmount;
244     uint256 public maxWallet;
245 
246     mapping(address => bool) private isExcludedFromFee;
247     mapping(address => bool) public isExcludedFromWalletLimits;
248 
249     uint256 public feeDenominator = 1000;
250     
251     bool private swapping;
252     uint256 swapThreshold;
253     bool public limitsInEffect = true;
254 
255     // While limits are in effect, an EOA can have exactly one transaction per block
256     mapping(address => mapping(uint256 => uint256)) public blockTransferCount;
257 
258     // This feature can only be enabled and not disabled.
259     // Enabling these will cap the buy or sell fee to some value
260     // a value of 50 => 5% max. A value of 150 => 15% max
261     bool maxSellFeeSet = false;
262     bool maxBuyFeeSet = false;
263     uint256 maxSellFee;
264     uint256 maxBuyFee;
265 
266     bool public airdropComplete = false;
267     bool public vestingFinished = false;
268 
269     mapping(address => uint256) public airdropAmount;
270     uint256 public launchTime;
271     uint256 public vestingPeriods = 30;
272     uint256 public vestingPercent = 3;
273 
274     constructor(
275         address router_,
276         address LPTokenReceiver_,
277         address marketingReceiver_
278     ) ERC20("QUEST", "QUEST") Ownable(msg.sender) {
279 
280         LPTokenReceiver = LPTokenReceiver_;
281         marketingReceiver = marketingReceiver_;
282 
283         router = IUniswapV2Router02(router_);
284 
285         liquidityPair = IUniswapV2Factory(
286             router.factory()
287         ).createPair(
288             address(this),
289             router.WETH()
290         );
291 
292         isAMM[liquidityPair] = true;
293 
294         isExcludedFromWalletLimits[address(liquidityPair)] = true;
295         isExcludedFromWalletLimits[address(router)] = true;
296         isExcludedFromWalletLimits[address(this)] = true;
297         isExcludedFromWalletLimits[address(0xdead)] = true;
298         isExcludedFromWalletLimits[msg.sender] = true;
299         isExcludedFromWalletLimits[LPTokenReceiver] = true;
300 
301         uint256 totalSupply = 800_000_000_000 * 1e18;
302         
303         buyMarketingFee = 15;
304         buyLiquidityFee = 5;
305 
306         sellMarketingFee = 15;
307         sellLiquidityFee = 5;
308 
309         buyTotalFees = buyMarketingFee + buyLiquidityFee;
310         sellTotalFees = sellMarketingFee + sellLiquidityFee;
311 
312         isExcludedFromFee[address(0xdead)] = true;
313         isExcludedFromFee[address(this)] = true;
314         isExcludedFromFee[msg.sender] = true;
315         isExcludedFromFee[LPTokenReceiver] = true;
316 
317         maxTransactionAmount = totalSupply * 5 / 1000;
318         maxWallet = totalSupply * 10 / 1000;
319         swapThreshold = totalSupply / 1000;
320 
321         /*
322             _mint is an internal function in ERC20.sol that is only called here,
323             and CANNOT be called ever again
324         */
325         _mint(msg.sender, totalSupply);
326     }
327 
328     receive() external payable {}
329 
330     function airdropTokens(address[] calldata holders, uint256[] calldata amounts) external onlyOwner {
331         require(!airdropComplete);
332 
333         for (uint i=0; i<holders.length; i++) {
334             super._transfer(address(this), holders[i], amounts[i]);
335             airdropAmount[holders[i]] += amounts[i];
336         }
337     }
338 
339     function finalizeAirdrop() external onlyOwner {
340         require(!airdropComplete);
341         airdropComplete = true;
342     }
343 
344     function addLiquidity(uint256 tokenAmount) external payable onlyOwner {
345         _addLiquidity(tokenAmount, msg.value);
346         launchTime = block.timestamp;
347     }
348 
349     function setBuyFees(uint256 marketingFee, uint256 liquidityFee) external onlyOwner {
350         buyMarketingFee = marketingFee;
351         buyLiquidityFee = liquidityFee;
352 
353         buyTotalFees = buyMarketingFee + buyLiquidityFee;
354 
355         if (maxBuyFeeSet) {
356             require(buyTotalFees <= maxBuyFee);
357         }
358     }
359 
360     function setSellFees(uint256 marketingFee, uint256 liquidityFee) external onlyOwner {
361         sellMarketingFee = marketingFee;
362         sellLiquidityFee = liquidityFee;
363 
364         sellTotalFees = sellMarketingFee + sellLiquidityFee;
365 
366         if (maxSellFeeSet) {
367             require(sellTotalFees <= maxSellFee);
368         }
369     }
370 
371     function setLimits(uint256 maxTransactionAmount_, uint256 maxWallet_) external onlyOwner {
372         maxTransactionAmount = maxTransactionAmount_;
373         maxWallet = maxWallet_;
374     }
375 
376     function removeLimits() external onlyOwner {
377         require(limitsInEffect);
378         limitsInEffect = false;
379     }
380 
381     function setLPTokenReceiver(address newReceiver) external onlyOwner {
382         require(LPTokenReceiver != newReceiver);
383         isExcludedFromFee[newReceiver] = true;
384         isExcludedFromWalletLimits[newReceiver] = true;
385         LPTokenReceiver = newReceiver;
386     }
387 
388     function setMarketingReceiver(address newReceiver) external onlyOwner {
389         require(marketingReceiver != newReceiver);
390         isExcludedFromFee[newReceiver] = true;
391         isExcludedFromWalletLimits[newReceiver] = true;
392         marketingReceiver = newReceiver;
393     }
394 
395     function setAMM(address ammAddress, bool isAMM_) external onlyOwner {
396         isAMM[ammAddress] = isAMM_;
397     }
398 
399     function setWalletExcludedFromLimits(address wallet, bool isExcluded) external onlyOwner {
400         isExcludedFromWalletLimits[wallet] = isExcluded;
401     }
402 
403     function setWalletExcludedFromFees(address wallet, bool isExcluded) external onlyOwner {
404         isExcludedFromFee[wallet] = isExcluded;
405     }
406 
407     function setRouter(address router_) external onlyOwner {
408         router = IUniswapV2Router02(router_);
409     }
410 
411     function setLiquidityPair(address pairAddress) external onlyOwner {
412         liquidityPair = pairAddress;
413     }
414 
415     function enableMaxSellFeeLimit(uint256 limit) external onlyOwner {
416         require(limit <= feeDenominator && limit < maxSellFee);
417         maxSellFee = limit;
418         maxSellFeeSet = true;
419     }
420 
421     function enableMaxBuyFeeLimit(uint256 limit) external onlyOwner {
422         require(limit <= feeDenominator && limit < maxBuyFee);
423         maxBuyFee = limit;
424         maxBuyFeeSet = true;
425     }
426 
427     function _transfer(
428         address from,
429         address to,
430         uint256 amount
431     ) internal override {
432         require(from != address(0), "ERC20: transfer from the zero address");
433         require(to != address(0), "ERC20: transfer to the zero address");
434 
435         if (amount == 0) {
436             super._transfer(from, to, 0);
437             return;
438         }
439 
440         if (!vestingFinished) {            
441             uint256 airdroppedTokenAmount = airdropAmount[from];
442 
443             if (airdroppedTokenAmount > 0) {
444                 
445                 uint256 elapsedPeriods = (block.timestamp - launchTime) / 86400;
446 
447                 if (elapsedPeriods < vestingPeriods) {
448                     uint256 minimumBalance = airdroppedTokenAmount - (
449                         // a number ranging from 0 to 100
450                         elapsedPeriods * vestingPercent
451                         * airdroppedTokenAmount
452                         / 100
453                     );
454                     require(balanceOf(from) - amount >= minimumBalance);
455                 } else {
456                     vestingFinished = true;
457                 }
458             }
459         }
460 
461         bool takeFee = !swapping;
462 
463         if (isExcludedFromFee[from] || isExcludedFromFee[to]) {
464             takeFee = false;
465         }
466 
467         if (takeFee) {
468 
469             uint256 fees = 0;
470 
471             if (isAMM[to] && sellTotalFees > 0) {
472                 uint256 newTokensForMarketing = amount * sellMarketingFee / feeDenominator;
473                 uint256 newTokensForLiquidity = amount * sellLiquidityFee / feeDenominator;
474 
475                 fees = newTokensForMarketing + newTokensForLiquidity;
476 
477                 tokensForMarketing += newTokensForMarketing;
478                 tokensForLiquidity += newTokensForLiquidity;
479             }
480 
481             else if (isAMM[from] && buyTotalFees > 0) {
482                 uint256 newTokensForMarketing = amount * buyMarketingFee / feeDenominator;
483                 uint256 newTokensForLiquidity = amount * buyLiquidityFee / feeDenominator;
484 
485                 fees = newTokensForMarketing + newTokensForLiquidity;
486 
487                 tokensForMarketing += newTokensForMarketing;
488                 tokensForLiquidity += newTokensForLiquidity;
489             }
490 
491             if (fees > 0) {
492                 super._transfer(from, address(this), fees);
493                 amount -= fees;
494             }
495         }
496 
497         if (limitsInEffect) {
498             if (
499                 from != owner() &&
500                 to != owner() &&
501                 to != address(0xdead) &&
502                 !swapping
503             ) {
504                 require(blockTransferCount[tx.origin][block.number] == 0);
505                 blockTransferCount[tx.origin][block.number] = 1;
506 
507                 if (
508                     isAMM[from] &&
509                     !isExcludedFromWalletLimits[to]
510                 ) {
511                     require(
512                         amount <= maxTransactionAmount,
513                         "!maxTransactionAmount."
514                     );
515                     require(
516                         amount + balanceOf(to) <= maxWallet,
517                         "!maxWallet"
518                     );
519                 } else if (
520                     isAMM[to] &&
521                     !isExcludedFromWalletLimits[from]
522                 ) {
523                     require(
524                         amount <= maxTransactionAmount,
525                         "!maxTransactionAmount."
526                     );
527                 } else if (!isExcludedFromWalletLimits[to]) {
528                     require(
529                         amount + balanceOf(to) <= maxWallet,
530                         "!maxWallet"
531                     );
532                 }
533             }
534         }
535 
536         if (
537             !swapping &&
538             from != liquidityPair &&
539             to == liquidityPair &&
540             !isExcludedFromFee[from] &&
541             !isExcludedFromFee[to] &&
542             balanceOf(address(this)) >= swapThreshold
543         ) {
544             swapping = true;
545 
546             swapBack();
547 
548             swapping = false;
549         }
550 
551 
552         super._transfer(from, to, amount);
553     }
554 
555     function swapTokensForEth(uint256 tokenAmount) internal {
556         address[] memory path = new address[](2);
557         path[0] = address(this);
558         path[1] = router.WETH();
559         _approve(address(this), address(router), tokenAmount);
560         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
561             tokenAmount,
562             0,
563             path,
564             address(this),
565             block.timestamp
566         );
567     }
568 
569     function swapBack() internal {
570         if (!airdropComplete) {
571             if (tokensForLiquidity + tokensForMarketing == 0) {
572                 return;
573             }
574         } else {
575             tokensForMarketing = balanceOf(address(this)) - tokensForLiquidity;
576             if (tokensForLiquidity + tokensForMarketing == 0) {
577                 return;
578             }
579         }
580 
581         uint256 liquidity = tokensForLiquidity / 2;
582         uint256 amountToSwapForETH = tokensForMarketing + (tokensForLiquidity - liquidity);
583         swapTokensForEth(amountToSwapForETH);
584 
585         uint256 ethForLiquidity = address(this).balance * (tokensForLiquidity - liquidity) / amountToSwapForETH;
586 
587         if (liquidity > 0 && ethForLiquidity > 0) {
588             _addLiquidity(liquidity, ethForLiquidity);
589         }
590 
591         if (tokensForMarketing > 0) {
592             marketingReceiver.call{value: address(this).balance}("");
593         }
594 
595         tokensForLiquidity = 0;
596         tokensForMarketing = 0;
597     }
598 
599     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
600         _approve(address(this), address(router), tokenAmount);
601         router.addLiquidityETH{value: ethAmount} (
602             address(this),
603             tokenAmount,
604             0,
605             0,
606             LPTokenReceiver,
607             block.timestamp
608         );
609     }
610 
611     function withdrawStuckTokens(address tokenAddress, uint256 amount) external {
612         require(tokenAddress != address(this));
613         uint256 tokenBalance = IERC20(tokenAddress).balanceOf(address(this));
614         uint256 amountToTransfer = amount == 0 ? tokenBalance : amount;
615         _safeTransfer(tokenAddress, marketingReceiver, amountToTransfer);
616     }
617 
618     function withdrawStuckETH() external {
619         (bool success,) = marketingReceiver.call{value: address(this).balance}("");
620         require(success);
621     }
622 
623     function _safeTransfer(address token, address to, uint256 value) private {
624         bytes4 TRANSFERSELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
625 
626         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(TRANSFERSELECTOR, to, value));
627         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TRANSFER_FAILED');
628     }
629 
630 }