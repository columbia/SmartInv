1 /**
2 
3 */
4 
5 /**
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.18;
11 
12 
13 /*
14 LUCKY DRAGON ($LUCKYMF)
15 
16 "Come not between the Lucky Dragon and his ETH!"
17 
18 A tribute to the art of Matt Furie celebrated in a Chinese inspired mega meme coin.
19 
20 
21 Telegram:
22 https://t.me/LuckyDragonETH
23 
24 Twitter:
25 https://twitter.com/LuckyDragonMF
26 
27 Website:
28 https://luckydragon.site/
29 
30 
31 */
32 
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(owner() == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         _transferOwnership(address(0));
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _transferOwnership(newOwner);
69     }
70     function _transferOwnership(address newOwner) internal virtual {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 interface IERC20 {
78     function totalSupply() external view returns (uint256);
79     function balanceOf(address account) external view returns (uint256);
80     function transfer(address recipient, uint256 amount) external returns (bool);
81     function allowance(address owner, address spender) external view returns (uint256);
82     function approve(address spender, uint256 amount) external returns (bool);
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 interface IERC20Metadata is IERC20 {
93     function name() external view returns (string memory);
94     function symbol() external view returns (string memory);
95     function decimals() external view returns (uint8);
96 }
97 
98 contract ERC20 is Context, IERC20, IERC20Metadata {
99     mapping(address => uint256) private _balances;
100     mapping(address => mapping(address => uint256)) private _allowances;
101 
102     uint256 private _totalSupply;
103     string private _name;
104     string private _symbol;
105 
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111 
112     function name() public view virtual override returns (string memory) {
113         return _name;
114     }
115 
116     function symbol() public view virtual override returns (string memory) {
117         return _symbol;
118     }
119 
120     function decimals() public view virtual override returns (uint8) {
121         return 18;
122     }
123 
124     function totalSupply() public view virtual override returns (uint256) {
125         return _totalSupply;
126     }
127 
128     function balanceOf(address account) public view virtual override returns (uint256) {
129         return _balances[account];
130     }
131 
132     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
133         _transfer(_msgSender(), recipient, amount);
134         return true;
135     }
136 
137     function allowance(address owner, address spender) public view virtual override returns (uint256) {
138         return _allowances[owner][spender];
139     }
140 
141     function approve(address spender, uint256 amount) public virtual override returns (bool) {
142         _approve(_msgSender(), spender, amount);
143         return true;
144     }
145 
146     function transferFrom(
147         address sender,
148         address recipient,
149         uint256 amount
150     ) public virtual override returns (bool) {
151         _transfer(sender, recipient, amount);
152 
153         uint256 currentAllowance = _allowances[sender][_msgSender()];
154         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
155         unchecked {
156             _approve(sender, _msgSender(), currentAllowance - amount);
157         }
158 
159         return true;
160     }
161 
162     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
163         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
164         return true;
165     }
166 
167     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
168         uint256 currentAllowance = _allowances[_msgSender()][spender];
169         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
170         unchecked {
171             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
172         }
173 
174         return true;
175     }
176 
177     function _transfer(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) internal virtual {
182         require(sender != address(0), "ERC20: transfer from the zero address");
183         require(recipient != address(0), "ERC20: transfer to the zero address");
184 
185         _beforeTokenTransfer(sender, recipient, amount);
186 
187         uint256 senderBalance = _balances[sender];
188         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
189         unchecked {
190             _balances[sender] = senderBalance - amount;
191         }
192         _balances[recipient] += amount;
193 
194         emit Transfer(sender, recipient, amount);
195 
196         _afterTokenTransfer(sender, recipient, amount);
197     }
198 
199     function _mint(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: mint to the zero address");
201 
202         _beforeTokenTransfer(address(0), account, amount);
203 
204         _totalSupply += amount;
205         _balances[account] += amount;
206         emit Transfer(address(0), account, amount);
207 
208         _afterTokenTransfer(address(0), account, amount);
209     }
210 
211     function _burn(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: burn from the zero address");
213 
214         _beforeTokenTransfer(account, address(0), amount);
215 
216         uint256 accountBalance = _balances[account];
217         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
218         unchecked {
219             _balances[account] = accountBalance - amount;
220         }
221         _totalSupply -= amount;
222 
223         emit Transfer(account, address(0), amount);
224 
225         _afterTokenTransfer(account, address(0), amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _beforeTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 
246     function _afterTokenTransfer(
247         address from,
248         address to,
249         uint256 amount
250     ) internal virtual {}
251 }
252 
253 library SafeMath {
254     function add(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a + b;
256     }
257 
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a - b;
260     }
261 
262     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a * b;
264     }
265 
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a / b;
268     }
269 
270     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a % b;
272     }
273 
274     function sub(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b <= a, errorMessage);
281             return a - b;
282         }
283     }
284 
285     function div(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290         unchecked {
291             require(b > 0, errorMessage);
292             return a / b;
293         }
294     }
295 
296     function mod(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         unchecked {
302             require(b > 0, errorMessage);
303             return a % b;
304         }
305     }
306 }
307 
308 interface IUniswapV2Factory {
309     function createPair(address tokenA, address tokenB)
310         external
311         returns (address pair);
312 }
313 
314 interface IUniswapV2Router02 {
315     function factory() external pure returns (address);
316 
317     function WETH() external pure returns (address);
318 
319     function addLiquidityETH(
320         address token,
321         uint256 amountTokenDesired,
322         uint256 amountTokenMin,
323         uint256 amountETHMin,
324         address to,
325         uint256 deadline
326     )
327         external
328         payable
329         returns (
330             uint256 amountToken,
331             uint256 amountETH,
332             uint256 liquidity
333         );
334 
335     function swapExactTokensForETHSupportingFeeOnTransferTokens(
336         uint256 amountIn,
337         uint256 amountOutMin,
338         address[] calldata path,
339         address to,
340         uint256 deadline
341     ) external;
342 }
343 
344 contract LUCKYDRAGON is ERC20, Ownable {
345     using SafeMath for uint256;
346 
347     IUniswapV2Router02 public immutable uniswapV2Router;
348     address public immutable uniswapV2Pair;
349 
350     bool private swapping;
351 
352     address public devWallet;
353 
354     uint256 public maxTransactionAmount;
355     uint256 public swapTokensAtAmount;
356     uint256 public maxWallet;
357 
358     bool public limitsInEffect = true;
359     bool public tradingActive = false;
360     bool public swapEnabled = false;
361 
362     uint256 public buyTotalFees;
363     uint256 public buyLiquidityFee;
364     uint256 public buyMarketingFee;
365 
366     uint256 public sellTotalFees;
367     uint256 public sellLiquidityFee;
368     uint256 public sellMarketingFee;
369 
370 	uint256 public tokensForLiquidity;
371     uint256 public tokensForMarketing;
372 
373     // exclude from fees and max transaction amount
374     mapping(address => bool) private _isExcludedFromFees;
375     mapping(address => bool) public _isExcludedMaxTransactionAmount;
376 
377     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
378     // could be subject to a maximum transfer amount
379     mapping(address => bool) public automatedMarketMakerPairs;
380 
381     event ExcludeFromFees(address indexed account, bool isExcluded);
382 
383     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
384 
385     event SwapAndLiquify(
386         uint256 tokensSwapped,
387         uint256 ethReceived,
388         uint256 tokensIntoLiquidity
389     );
390 
391     constructor() ERC20("LUCKY DRAGON", "LUCKYMF") {
392         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
393             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
394         );
395 
396         excludeFromMaxTransaction(address(_uniswapV2Router), true);
397         uniswapV2Router = _uniswapV2Router;
398 
399         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
400             .createPair(address(this), _uniswapV2Router.WETH());
401         excludeFromMaxTransaction(address(uniswapV2Pair), true);
402         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
403 
404         uint256 _buyLiquidityFee = 10;
405         uint256 _buyMarketingFee = 30;
406 
407         uint256 _sellLiquidityFee = 15;
408         uint256 _sellMarketingFee = 50;
409 
410         uint256 totalSupply = 1 * 1e15 * 1e18;
411 
412         maxTransactionAmount = .5 * 1e13 * 1e18; 
413         maxWallet = .5 * 1e13 * 1e18; 
414         swapTokensAtAmount = (totalSupply * 2) / 1000; 
415 
416         buyLiquidityFee = _buyLiquidityFee;
417         buyMarketingFee = _buyMarketingFee;
418         buyTotalFees = buyLiquidityFee + buyMarketingFee;
419 
420         sellLiquidityFee = _sellLiquidityFee;
421         sellMarketingFee = _sellMarketingFee;
422         sellTotalFees = sellLiquidityFee + sellMarketingFee;
423 
424         devWallet = address(0x0062394858469c9A374E3DA0149fc1F303f1952E); 
425 
426         // exclude from paying fees or having max transaction amount
427         excludeFromFees(owner(), true);
428         excludeFromFees(address(this), true);
429         excludeFromFees(address(0xdead), true);
430 
431         excludeFromMaxTransaction(owner(), true);
432         excludeFromMaxTransaction(address(this), true);
433         excludeFromMaxTransaction(address(0xdead), true);
434 
435         _mint(msg.sender, totalSupply);
436     }
437 
438     receive() external payable {}
439 
440     // once enabled, can never be turned off
441     function enableTrading() external onlyOwner {
442         tradingActive = true;
443         swapEnabled = true;
444     }
445 
446     function updateFees(uint256 _buyLiquidityFee, uint256 _buyMarketingFee, uint256 _sellLiquidityFee, uint256 _sellMarketingFee) external onlyOwner {
447         buyLiquidityFee = _buyLiquidityFee;
448         buyMarketingFee = _buyMarketingFee;
449         buyTotalFees = buyLiquidityFee + buyMarketingFee;
450 
451         sellLiquidityFee = _sellLiquidityFee;
452         sellMarketingFee = _sellMarketingFee;
453         sellTotalFees = sellLiquidityFee + sellMarketingFee;
454     } 
455 
456     function removeLimits() external onlyOwner returns (bool) {
457         limitsInEffect = false;
458         return true;
459     }
460 
461     // change the minimum amount of tokens to sell from fees
462     function updateSwapTokensAtAmount(uint256 newAmount)
463         external
464         onlyOwner
465         returns (bool)
466     {
467         require(
468             newAmount >= (totalSupply() * 1) / 100000,
469             "Swap amount cannot be lower than 0.001% total supply."
470         );
471         require(
472             newAmount <= (totalSupply() * 5) / 1000,
473             "Swap amount cannot be higher than 0.5% total supply."
474         );
475         swapTokensAtAmount = newAmount;
476         return true;
477     }
478 	
479     function excludeFromMaxTransaction(address updAds, bool isEx)
480         public
481         onlyOwner
482     {
483         _isExcludedMaxTransactionAmount[updAds] = isEx;
484     }
485 
486     // only use to disable contract sales if absolutely necessary (emergency use only)
487     function updateSwapEnabled(bool enabled) external onlyOwner {
488         swapEnabled = enabled;
489     }
490 
491     function excludeFromFees(address account, bool excluded) public onlyOwner {
492         _isExcludedFromFees[account] = excluded;
493         emit ExcludeFromFees(account, excluded);
494     }
495 
496     function setAutomatedMarketMakerPair(address pair, bool value)
497         public
498         onlyOwner
499     {
500         require(
501             pair != uniswapV2Pair,
502             "The pair cannot be removed from automatedMarketMakerPairs"
503         );
504 
505         _setAutomatedMarketMakerPair(pair, value);
506     }
507 
508     function _setAutomatedMarketMakerPair(address pair, bool value) private {
509         automatedMarketMakerPairs[pair] = value;
510 
511         emit SetAutomatedMarketMakerPair(pair, value);
512     }
513 
514     function isExcludedFromFees(address account) public view returns (bool) {
515         return _isExcludedFromFees[account];
516     }
517 
518     function _transfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal override {
523         require(from != address(0), "ERC20: transfer from the zero address");
524         require(to != address(0), "ERC20: transfer to the zero address");
525 
526         if (amount == 0) {
527             super._transfer(from, to, 0);
528             return;
529         }
530 
531         if (limitsInEffect) {
532             if (
533                 from != owner() &&
534                 to != owner() &&
535                 to != address(0) &&
536                 to != address(0xdead) &&
537                 !swapping
538             ) {
539                 if (!tradingActive) {
540                     require(
541                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
542                         "Trading is not active."
543                     );
544                 }
545 
546                 //when buy
547                 if (
548                     automatedMarketMakerPairs[from] &&
549                     !_isExcludedMaxTransactionAmount[to]
550                 ) {
551                     require(
552                         amount <= maxTransactionAmount,
553                         "Buy transfer amount exceeds the maxTransactionAmount."
554                     );
555                     require(
556                         amount + balanceOf(to) <= maxWallet,
557                         "Max wallet exceeded"
558                     );
559                 }
560                 //when sell
561                 else if (
562                     automatedMarketMakerPairs[to] &&
563                     !_isExcludedMaxTransactionAmount[from]
564                 ) {
565                     require(
566                         amount <= maxTransactionAmount,
567                         "Sell transfer amount exceeds the maxTransactionAmount."
568                     );
569                 } else if (!_isExcludedMaxTransactionAmount[to]) {
570                     require(
571                         amount + balanceOf(to) <= maxWallet,
572                         "Max wallet exceeded"
573                     );
574                 }
575             }
576         }
577 
578         uint256 contractTokenBalance = balanceOf(address(this));
579 
580         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
581 
582         if (
583             canSwap &&
584             swapEnabled &&
585             !swapping &&
586             !automatedMarketMakerPairs[from] &&
587             !_isExcludedFromFees[from] &&
588             !_isExcludedFromFees[to]
589         ) {
590             swapping = true;
591 
592             swapBack();
593 
594             swapping = false;
595         }
596 
597         bool takeFee = !swapping;
598 
599         // if any account belongs to _isExcludedFromFee account then remove the fee
600         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
601             takeFee = false;
602         }
603 
604         uint256 fees = 0;
605         // only take fees on buys/sells, do not take on wallet transfers
606         if (takeFee) {
607             // on sell
608             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
609                 fees = amount.mul(sellTotalFees).div(100);
610                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
611                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;                
612             }
613             // on buy
614             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
615                 fees = amount.mul(buyTotalFees).div(100);
616                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
617                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
618             }
619 
620             if (fees > 0) {
621                 super._transfer(from, address(this), fees);
622             }
623 
624             amount -= fees;
625         }
626 
627         super._transfer(from, to, amount);
628     }
629 
630     function swapTokensForEth(uint256 tokenAmount) private {
631         // generate the uniswap pair path of token -> weth
632         address[] memory path = new address[](2);
633         path[0] = address(this);
634         path[1] = uniswapV2Router.WETH();
635 
636         _approve(address(this), address(uniswapV2Router), tokenAmount);
637 
638         // make the swap
639         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
640             tokenAmount,
641             0, // accept any amount of ETH
642             path,
643             address(this),
644             block.timestamp
645         );
646     }
647 
648     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
649         // approve token transfer to cover all possible scenarios
650         _approve(address(this), address(uniswapV2Router), tokenAmount);
651 
652         // add the liquidity
653         uniswapV2Router.addLiquidityETH{value: ethAmount}(
654             address(this),
655             tokenAmount,
656             0, // slippage is unavoidable
657             0, // slippage is unavoidable
658             devWallet,
659             block.timestamp
660         );
661     }
662 
663     function swapBack() private {
664         uint256 contractBalance = balanceOf(address(this));
665         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
666         bool success;
667 
668         if (contractBalance == 0 || totalTokensToSwap == 0) {
669             return;
670         }
671 
672         if (contractBalance > swapTokensAtAmount * 20) {
673             contractBalance = swapTokensAtAmount * 20;
674         }
675 
676         // Halve the amount of liquidity tokens
677         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
678         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
679 
680         uint256 initialETHBalance = address(this).balance;
681 
682         swapTokensForEth(amountToSwapForETH);
683 
684         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
685 	
686         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
687 
688         uint256 ethForLiquidity = ethBalance - ethForMarketing;
689 
690         tokensForLiquidity = 0;
691         tokensForMarketing = 0;
692 
693         if (liquidityTokens > 0 && ethForLiquidity > 0) {
694             addLiquidity(liquidityTokens, ethForLiquidity);
695             emit SwapAndLiquify(
696                 amountToSwapForETH,
697                 ethForLiquidity,
698                 tokensForLiquidity
699             );
700         }
701         //there will be no leftover eth in the contract 
702         (success, ) = address(devWallet).call{value: address(this).balance}("");
703     }
704 
705 }