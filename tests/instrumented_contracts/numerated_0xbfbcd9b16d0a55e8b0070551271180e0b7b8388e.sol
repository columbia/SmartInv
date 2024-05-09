1 // SPDX-License-Identifier: MIT
2 
3 /*
4     https://t.me/shibaarmysnipe
5 */
6 
7 pragma solidity 0.8.10;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner() {
33         require(owner() == _msgSender(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         _transferOwnership(address(0));
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _transferOwnership(newOwner);
44     }
45     function _transferOwnership(address newOwner) internal virtual {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 interface IERC20 {
53     function name() external view returns (string memory);
54     function symbol() external view returns (string memory);
55     function decimals() external view returns (uint8);
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 contract ERC20 is Context, IERC20 {
71     mapping(address => uint256) private _balances;
72     mapping(address => mapping(address => uint256)) private _allowances;
73 
74     uint256 private _totalSupply;
75     uint8 private _decimals; 
76     string private _name;
77     string private _symbol;
78 
79     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
80         _name = name_;
81         _symbol = symbol_;
82         _decimals = decimals_;
83     }
84 
85     function name() public view virtual override returns (string memory) {
86         return _name;
87     }
88 
89     function symbol() public view virtual override returns (string memory) {
90         return _symbol;
91     }
92 
93     function decimals() public view virtual override returns (uint8) {
94         return _decimals;
95     }
96 
97     function totalSupply() public view virtual override returns (uint256) {
98         return _totalSupply;
99     }
100 
101     function balanceOf(address account) public view virtual override returns (uint256) {
102         return _balances[account];
103     }
104 
105     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(_msgSender(), recipient, amount);
107         return true;
108     }
109 
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         return _allowances[owner][spender];
112     }
113 
114     function approve(address spender, uint256 amount) public virtual override returns (bool) {
115         _approve(_msgSender(), spender, amount);
116         return true;
117     }
118 
119     function transferFrom(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) public virtual override returns (bool) {
124         _transfer(sender, recipient, amount);
125 
126         uint256 currentAllowance = _allowances[sender][_msgSender()];
127         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
128         unchecked {
129             _approve(sender, _msgSender(), currentAllowance - amount);
130         }
131 
132         return true;
133     }
134 
135     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
136         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
137         return true;
138     }
139 
140     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
141         uint256 currentAllowance = _allowances[_msgSender()][spender];
142         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
143         unchecked {
144             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
145         }
146 
147         return true;
148     }
149 
150     function _transfer(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) internal virtual {
155         require(sender != address(0), "ERC20: transfer from the zero address");
156         require(recipient != address(0), "ERC20: transfer to the zero address");
157 
158         _beforeTokenTransfer(sender, recipient, amount);
159 
160         uint256 senderBalance = _balances[sender];
161         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
162         unchecked {
163             _balances[sender] = senderBalance - amount;
164         }
165         _balances[recipient] += amount;
166 
167         emit Transfer(sender, recipient, amount);
168 
169         _afterTokenTransfer(sender, recipient, amount);
170     }
171 
172     function _mint(address account, uint256 amount) internal virtual {
173         require(account != address(0), "ERC20: mint to the zero address");
174 
175         _beforeTokenTransfer(address(0), account, amount);
176 
177         _totalSupply += amount;
178         _balances[account] += amount;
179         emit Transfer(address(0), account, amount);
180 
181         _afterTokenTransfer(address(0), account, amount);
182     }
183 
184     function _burn(address account, uint256 amount) internal virtual {
185         require(account != address(0), "ERC20: burn from the zero address");
186 
187         _beforeTokenTransfer(account, address(0), amount);
188 
189         uint256 accountBalance = _balances[account];
190         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
191         unchecked {
192             _balances[account] = accountBalance - amount;
193         }
194         _totalSupply -= amount;
195 
196         emit Transfer(account, address(0), amount);
197 
198         _afterTokenTransfer(account, address(0), amount);
199     }
200 
201     function _approve(
202         address owner,
203         address spender,
204         uint256 amount
205     ) internal virtual {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208 
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _beforeTokenTransfer(
214         address from,
215         address to,
216         uint256 amount
217     ) internal virtual {}
218 
219     function _afterTokenTransfer(
220         address from,
221         address to,
222         uint256 amount
223     ) internal virtual {}
224 }
225 
226 interface IUniswapV2Factory {
227     function createPair(address tokenA, address tokenB)
228         external
229         returns (address pair);
230 }
231 
232 interface IUniswapV2Router01 {
233     function factory() external pure returns (address);
234     function WETH() external pure returns (address);
235 
236     function addLiquidity(
237         address tokenA,
238         address tokenB,
239         uint amountADesired,
240         uint amountBDesired,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline
245     ) external returns (uint amountA, uint amountB, uint liquidity);
246     function addLiquidityETH(
247         address token,
248         uint amountTokenDesired,
249         uint amountTokenMin,
250         uint amountETHMin,
251         address to,
252         uint deadline
253     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
254     function removeLiquidity(
255         address tokenA,
256         address tokenB,
257         uint liquidity,
258         uint amountAMin,
259         uint amountBMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountA, uint amountB);
263     function removeLiquidityETH(
264         address token,
265         uint liquidity,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountToken, uint amountETH);
271     function removeLiquidityWithPermit(
272         address tokenA,
273         address tokenB,
274         uint liquidity,
275         uint amountAMin,
276         uint amountBMin,
277         address to,
278         uint deadline,
279         bool approveMax, uint8 v, bytes32 r, bytes32 s
280     ) external returns (uint amountA, uint amountB);
281     function removeLiquidityETHWithPermit(
282         address token,
283         uint liquidity,
284         uint amountTokenMin,
285         uint amountETHMin,
286         address to,
287         uint deadline,
288         bool approveMax, uint8 v, bytes32 r, bytes32 s
289     ) external returns (uint amountToken, uint amountETH);
290     function swapExactTokensForTokens(
291         uint amountIn,
292         uint amountOutMin,
293         address[] calldata path,
294         address to,
295         uint deadline
296     ) external returns (uint[] memory amounts);
297     function swapTokensForExactTokens(
298         uint amountOut,
299         uint amountInMax,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external returns (uint[] memory amounts);
304     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
305         external
306         payable
307         returns (uint[] memory amounts);
308     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
309         external
310         returns (uint[] memory amounts);
311     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
312         external
313         returns (uint[] memory amounts);
314     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318 
319     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
320     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
321     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
322     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
323     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
324 }
325 
326 interface IUniswapV2Router02 is IUniswapV2Router01 {
327     function removeLiquidityETHSupportingFeeOnTransferTokens(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountETH);
335     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline,
342         bool approveMax, uint8 v, bytes32 r, bytes32 s
343     ) external returns (uint amountETH);
344 
345     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
346         uint amountIn,
347         uint amountOutMin,
348         address[] calldata path,
349         address to,
350         uint deadline
351     ) external;
352     function swapExactETHForTokensSupportingFeeOnTransferTokens(
353         uint amountOutMin,
354         address[] calldata path,
355         address to,
356         uint deadline
357     ) external payable;
358     function swapExactTokensForETHSupportingFeeOnTransferTokens(
359         uint amountIn,
360         uint amountOutMin,
361         address[] calldata path,
362         address to,
363         uint deadline
364     ) external;
365 }
366 
367 contract SHIBASNIPE is ERC20, Ownable {
368     IUniswapV2Router02 private immutable uniswapV2Router;
369     IUniswapV2Router02 private immutable shibaswapRouter;
370 
371     address public immutable uniswapV2Pair;
372     address public immutable shibaswapPair;
373 
374     bool private swapping;
375 
376     address public sniperDevelopment;
377     address public sniperOwner; 
378 
379     uint256 public maxTransactionAmount;
380     uint256 public swapTokensAtAmount;
381     uint256 public maxWallet;
382 
383     bool public limitsInEffect = true;
384     bool public tradingActive = false;
385     bool public swapBack = false;
386 
387     uint256 public buyTotalFees;
388     uint256 public buyLiquidityFee;
389     uint256 public buyMarketingFee;
390 
391     uint256 public sellTotalFees;
392     uint256 public sellLiquidityFee;
393     uint256 public sellMarketingFee;
394 
395 	uint256 public liquidityTokens;
396     uint256 public marketingTokens;
397     uint256 public tradingActiveBlock; 
398 
399     uint8 private DECIMALS = 18;
400 
401     // exclude from fees and max transaction amount
402     mapping(address => bool) private _isExcludedFromFees;
403     mapping(address => bool) public _isExcludedMaxTransactionAmount;
404 
405     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
406     // could be subject to a maximum transfer amount
407     mapping(address => bool) public AMM;
408 
409     event ExcludeFromFees(address indexed account, bool isExcluded);
410 
411     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
412 
413     constructor() ERC20("Shiba Army", "SHIBASNIPE", DECIMALS) {
414 
415         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
416             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
417         );
418 
419         IUniswapV2Router02 _shibaswapRouter = IUniswapV2Router02(
420             0x03f7724180AA6b939894B5Ca4314783B0b36b329
421         );
422 
423         sniperDevelopment = address(0x3C82888b90f628bc4b5f54F25d4964A74A35781a); 
424         sniperOwner = address(0xC5d3807ccF68821e2954711c1E0EF290b4EdbCF6);
425 
426         uint256 _buyLiquidityFee = 0;
427         uint256 _buyMarketingFee = 30;
428 
429         uint256 _sellLiquidityFee = 0;
430         uint256 _sellMarketingFee = 40;
431 
432         uint256 totalSupply = 1 * 1e9 * 10**DECIMALS;
433 
434         maxTransactionAmount = 2 * 1e7 * 10**DECIMALS;
435         maxWallet = 2 * 1e7 * 10**DECIMALS;
436 
437         swapTokensAtAmount = (totalSupply * 10) / 10000; 
438 
439         excludeFromMaxTransaction(address(_uniswapV2Router), true);
440         uniswapV2Router = _uniswapV2Router;
441 
442         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
443             .createPair(address(this), _uniswapV2Router.WETH());
444         excludeFromMaxTransaction(address(uniswapV2Pair), true);
445         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
446 
447         excludeFromMaxTransaction(address(_shibaswapRouter), true);
448         shibaswapRouter = _shibaswapRouter;
449 
450         shibaswapPair = IUniswapV2Factory(_shibaswapRouter.factory())
451             .createPair(address(this), _shibaswapRouter.WETH());
452         excludeFromMaxTransaction(address(shibaswapPair), true);
453         _setAutomatedMarketMakerPair(address(shibaswapPair), true);
454 
455         buyLiquidityFee = _buyLiquidityFee;
456         buyMarketingFee = _buyMarketingFee;
457         buyTotalFees = buyLiquidityFee + buyMarketingFee;
458 
459         sellLiquidityFee = _sellLiquidityFee;
460         sellMarketingFee = _sellMarketingFee;
461         sellTotalFees = sellLiquidityFee + sellMarketingFee;
462 
463         excludeFromFees(owner(), true);
464         excludeFromFees(address(this), true);
465         excludeFromFees(address(0xdead), true);
466 
467         excludeFromMaxTransaction(owner(), true);
468         excludeFromMaxTransaction(address(this), true);
469         excludeFromMaxTransaction(address(0xdead), true);
470 
471         _mint(msg.sender, totalSupply);
472     }
473 
474     receive() external payable {}
475 
476     // once enabled, can never be turned off
477     function openTrading() external onlyOwner {
478         tradingActive = true;
479         swapBack = true;
480         tradingActiveBlock = block.number;
481     }
482 
483     function setFees(uint256 _buyLiquidityFee, uint256 _buyMarketingFee, uint256 _sellLiquidityFee, uint256 _sellMarketingFee) external onlyOwner {
484         buyLiquidityFee = _buyLiquidityFee;
485         buyMarketingFee = _buyMarketingFee;
486         buyTotalFees = buyLiquidityFee + buyMarketingFee;
487 
488         sellLiquidityFee = _sellLiquidityFee;
489         sellMarketingFee = _sellMarketingFee;
490         sellTotalFees = sellLiquidityFee + sellMarketingFee;
491     } 
492 
493     function removeLimits() external onlyOwner returns (bool) {
494         limitsInEffect = false;
495         return true;
496     }
497 
498     // change the minimum amount of tokens to sell from fees
499     function updateSwapTokensAtAmount(uint256 newAmount)
500         external
501         onlyOwner
502         returns (bool)
503     {
504         swapTokensAtAmount = newAmount;
505         return true;
506     }
507 	
508     function excludeFromMaxTransaction(address updAds, bool isEx)
509         public
510         onlyOwner
511     {
512         _isExcludedMaxTransactionAmount[updAds] = isEx;
513     }
514 
515     // only use to disable contract sales if absolutely necessary (emergency use only)
516     function updateSwapBack(bool on) external onlyOwner {
517         swapBack = on;
518     }
519 
520     function excludeFromFees(address account, bool excluded) public onlyOwner {
521         _isExcludedFromFees[account] = excluded;
522         emit ExcludeFromFees(account, excluded);
523     }
524 
525     function setAutomatedMarketMakerPair(address pair, bool value)
526         public
527         onlyOwner
528     {
529         require(
530             pair != uniswapV2Pair,
531             "The pair cannot be removed from AMM"
532         );
533 
534         _setAutomatedMarketMakerPair(pair, value);
535     }
536 
537     function _setAutomatedMarketMakerPair(address pair, bool value) private {
538         AMM[pair] = value;
539 
540         emit SetAutomatedMarketMakerPair(pair, value);
541     }
542 
543     function isExcludedFromFees(address account) public view returns (bool) {
544         return _isExcludedFromFees[account];
545     }
546 
547     function _transfer(
548         address from,
549         address to,
550         uint256 amount
551     ) internal override {
552         require(from != address(0), "ERC20: transfer from the zero address");
553         require(to != address(0), "ERC20: transfer to the zero address");
554 
555         if (amount == 0) {
556             super._transfer(from, to, 0);
557             return;
558         }
559 
560         if (limitsInEffect) {
561             if (
562                 from != owner() &&
563                 to != owner() &&
564                 to != address(0) &&
565                 to != address(0xdead) &&
566                 !swapping
567             ) {
568                 if (!tradingActive) {
569                     require(
570                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
571                         "Trading is not active."
572                     );
573                 }
574 
575                 //when buy
576                 if (
577                     AMM[from] &&
578                     !_isExcludedMaxTransactionAmount[to]
579                 ) {
580                     require(
581                         amount <= maxTransactionAmount,
582                         "Buy transfer amount exceeds the maxTransactionAmount."
583                     );
584                     require(
585                         amount + balanceOf(to) <= maxWallet,
586                         "Max wallet exceeded"
587                     );
588                 }
589                 //when sell
590                 else if (
591                     AMM[to] &&
592                     !_isExcludedMaxTransactionAmount[from]
593                 ) {
594                     require(
595                         amount <= maxTransactionAmount,
596                         "Sell transfer amount exceeds the maxTransactionAmount."
597                     );
598                 } else if (!_isExcludedMaxTransactionAmount[to]) {
599                     require(
600                         amount + balanceOf(to) <= maxWallet,
601                         "Max wallet exceeded"
602                     );
603                 }
604             }
605         }
606 
607         uint256 contractTokenBalance = balanceOf(address(this));
608 
609         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
610 
611         if (
612             canSwap &&
613             swapBack &&
614             !swapping &&
615             !AMM[from] &&
616             !_isExcludedFromFees[from] &&
617             !_isExcludedFromFees[to]
618         ) {
619             swapping = true;
620 
621             doSwap();
622 
623             swapping = false;
624         }
625 
626         bool takeFee = !swapping;
627 
628         // if any account belongs to _isExcludedFromFee account then remove the fee
629         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
630             takeFee = false;
631         }
632 
633         uint256 fees = 0;
634         // only take fees on buys/sells, do not take on wallet transfers
635         if (takeFee) {
636 
637             // on sell
638             if (AMM[to] && sellTotalFees > 0) {
639                 fees = amount * sellTotalFees / 100;
640                 liquidityTokens += (fees * sellLiquidityFee) / sellTotalFees;
641                 marketingTokens += (fees * sellMarketingFee) / sellTotalFees;                
642             }
643             // on buy
644             else if (AMM[from] && buyTotalFees > 0) {
645                 fees = amount * buyTotalFees / 100;
646                 liquidityTokens += (fees * buyLiquidityFee) / buyTotalFees;
647                 marketingTokens += (fees * buyMarketingFee) / buyTotalFees;
648             }
649 
650             if (fees > 0) {
651                 super._transfer(from, address(this), fees);
652             }
653 
654             amount -= fees;
655         }
656 
657         super._transfer(from, to, amount);
658     }
659 
660     function swapTokens(uint256 tokenAmount) private {
661         address[] memory path = new address[](2);
662         path[0] = address(this);
663         path[1] = uniswapV2Router.WETH();
664 
665         _approve(address(this), address(uniswapV2Router), tokenAmount);
666 
667         // make the swap
668         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
669             tokenAmount,
670             0, 
671             path,
672             address(this),
673             block.timestamp
674         );
675     }
676 
677     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
678         // approve token transfer to cover all possible scenarios
679         _approve(address(this), address(uniswapV2Router), tokenAmount);
680 
681         // add the liquidity
682         uniswapV2Router.addLiquidityETH{value: ethAmount}(
683             address(this),
684             tokenAmount,
685             0, // slippage is unavoidable
686             0, // slippage is unavoidable
687             sniperDevelopment,
688             block.timestamp
689         );
690     }
691 
692     function doSwap() private {
693         uint256 contractBalance = balanceOf(address(this));
694         uint256 totalTokensToSwap = liquidityTokens + marketingTokens;
695         bool success;
696 
697         if (contractBalance == 0 || totalTokensToSwap == 0) {
698             return;
699         }
700 
701         if (contractBalance > swapTokensAtAmount * 20) {
702             contractBalance = swapTokensAtAmount * 20;
703         }
704 
705         // Halve the amount of liquidity tokens
706         uint256 tokensForLiquidity = (contractBalance * liquidityTokens) / totalTokensToSwap / 2;
707         uint256 amountToSwapForETH = contractBalance - tokensForLiquidity;
708 
709         uint256 initialETHBalance = address(this).balance;
710 
711         swapTokens(amountToSwapForETH);
712 
713         uint256 ethBalance = address(this).balance - initialETHBalance;
714 	
715         uint256 ethMarketing = ethBalance * marketingTokens / totalTokensToSwap;
716         uint256 ethForOwner = ethMarketing * 3 / 10;
717 
718         uint256 ethLiquidity = ethBalance - ethMarketing;
719 
720         liquidityTokens = 0;
721         marketingTokens = 0;
722 
723         if (tokensForLiquidity > 0 && ethLiquidity > 0) {
724             addLiquidity(tokensForLiquidity, ethLiquidity);
725         }
726         //there will be no leftover eth in the contract 
727         (success, ) = address(sniperOwner).call{value: ethForOwner}("");
728         (success, ) = address(sniperDevelopment).call{value: address(this).balance}("");
729     }
730 }