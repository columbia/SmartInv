1 // SPDX-License-Identifier: MIT
2 
3 /*
4 The premier BlackJack experience, built right into Telegram
5 https://t.me/BlockJackETH
6 https://t.me/BlockjackETHBot
7 */
8 
9 pragma solidity 0.8.10;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner {
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
45         _transferOwnership(newOwner);
46     }
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 interface IERC20 {
55     function name() external view returns (string memory);
56     function symbol() external view returns (string memory);
57     function decimals() external view returns (uint8);
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 contract ERC20 is Context, IERC20 {
73     mapping(address => uint256) private _balances;
74     mapping(address => mapping(address => uint256)) private _allowances;
75 
76     uint256 private _totalSupply;
77     uint8 private _decimals; 
78     string private _name;
79     string private _symbol;
80 
81     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
82         _name = name_;
83         _symbol = symbol_;
84         _decimals = decimals_;
85     }
86 
87     function name() public view virtual override returns (string memory) {
88         return _name;
89     }
90 
91     function symbol() public view virtual override returns (string memory) {
92         return _symbol;
93     }
94 
95     function decimals() public view virtual override returns (uint8) {
96         return _decimals;
97     }
98 
99     function totalSupply() public view virtual override returns (uint256) {
100         return _totalSupply;
101     }
102 
103     function balanceOf(address account) public view virtual override returns (uint256) {
104         return _balances[account];
105     }
106 
107     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
108         _transfer(_msgSender(), recipient, amount);
109         return true;
110     }
111 
112     function allowance(address owner, address spender) public view virtual override returns (uint256) {
113         return _allowances[owner][spender];
114     }
115 
116     function approve(address spender, uint256 amount) public virtual override returns (bool) {
117         _approve(_msgSender(), spender, amount);
118         return true;
119     }
120 
121     function transferFrom(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) public virtual override returns (bool) {
126         _transfer(sender, recipient, amount);
127 
128         uint256 currentAllowance = _allowances[sender][_msgSender()];
129         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
130         unchecked {
131             _approve(sender, _msgSender(), currentAllowance - amount);
132         }
133 
134         return true;
135     }
136 
137     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
138         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
139         return true;
140     }
141 
142     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
143         uint256 currentAllowance = _allowances[_msgSender()][spender];
144         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
145         unchecked {
146             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
147         }
148 
149         return true;
150     }
151 
152     function _transfer(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) internal virtual {
157         require(sender != address(0), "ERC20: transfer from the zero address");
158         require(recipient != address(0), "ERC20: transfer to the zero address");
159 
160         _beforeTokenTransfer(sender, recipient, amount);
161 
162         uint256 senderBalance = _balances[sender];
163         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
164         unchecked {
165             _balances[sender] = senderBalance - amount;
166         }
167         _balances[recipient] += amount;
168 
169         emit Transfer(sender, recipient, amount);
170 
171         _afterTokenTransfer(sender, recipient, amount);
172     }
173 
174     function _mint(address account, uint256 amount) internal virtual {
175         require(account != address(0), "ERC20: mint to the zero address");
176 
177         _beforeTokenTransfer(address(0), account, amount);
178 
179         _totalSupply += amount;
180         _balances[account] += amount;
181         emit Transfer(address(0), account, amount);
182 
183         _afterTokenTransfer(address(0), account, amount);
184     }
185 
186     function _burn(address account, uint256 amount) internal virtual {
187         require(account != address(0), "ERC20: burn from the zero address");
188 
189         _beforeTokenTransfer(account, address(0), amount);
190 
191         uint256 accountBalance = _balances[account];
192         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
193         unchecked {
194             _balances[account] = accountBalance - amount;
195         }
196         _totalSupply -= amount;
197 
198         emit Transfer(account, address(0), amount);
199 
200         _afterTokenTransfer(account, address(0), amount);
201     }
202 
203     function _approve(
204         address owner,
205         address spender,
206         uint256 amount
207     ) internal virtual {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210 
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _beforeTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 
221     function _afterTokenTransfer(
222         address from,
223         address to,
224         uint256 amount
225     ) internal virtual {}
226 }
227 
228 interface IUniswapV2Factory {
229     function createPair(address tokenA, address tokenB)
230         external
231         returns (address pair);
232 }
233 
234 interface IUniswapV2Router01 {
235     function factory() external pure returns (address);
236     function WETH() external pure returns (address);
237 
238     function addLiquidity(
239         address tokenA,
240         address tokenB,
241         uint amountADesired,
242         uint amountBDesired,
243         uint amountAMin,
244         uint amountBMin,
245         address to,
246         uint deadline
247     ) external returns (uint amountA, uint amountB, uint liquidity);
248     function addLiquidityETH(
249         address token,
250         uint amountTokenDesired,
251         uint amountTokenMin,
252         uint amountETHMin,
253         address to,
254         uint deadline
255     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
256     function removeLiquidity(
257         address tokenA,
258         address tokenB,
259         uint liquidity,
260         uint amountAMin,
261         uint amountBMin,
262         address to,
263         uint deadline
264     ) external returns (uint amountA, uint amountB);
265     function removeLiquidityETH(
266         address token,
267         uint liquidity,
268         uint amountTokenMin,
269         uint amountETHMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountToken, uint amountETH);
273     function removeLiquidityWithPermit(
274         address tokenA,
275         address tokenB,
276         uint liquidity,
277         uint amountAMin,
278         uint amountBMin,
279         address to,
280         uint deadline,
281         bool approveMax, uint8 v, bytes32 r, bytes32 s
282     ) external returns (uint amountA, uint amountB);
283     function removeLiquidityETHWithPermit(
284         address token,
285         uint liquidity,
286         uint amountTokenMin,
287         uint amountETHMin,
288         address to,
289         uint deadline,
290         bool approveMax, uint8 v, bytes32 r, bytes32 s
291     ) external returns (uint amountToken, uint amountETH);
292     function swapExactTokensForTokens(
293         uint amountIn,
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external returns (uint[] memory amounts);
299     function swapTokensForExactTokens(
300         uint amountOut,
301         uint amountInMax,
302         address[] calldata path,
303         address to,
304         uint deadline
305     ) external returns (uint[] memory amounts);
306     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
307         external
308         payable
309         returns (uint[] memory amounts);
310     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
311         external
312         returns (uint[] memory amounts);
313     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
314         external
315         returns (uint[] memory amounts);
316     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
317         external
318         payable
319         returns (uint[] memory amounts);
320 
321     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
322     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
323     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
324     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
325     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
326 }
327 
328 interface IUniswapV2Router02 is IUniswapV2Router01 {
329     function removeLiquidityETHSupportingFeeOnTransferTokens(
330         address token,
331         uint liquidity,
332         uint amountTokenMin,
333         uint amountETHMin,
334         address to,
335         uint deadline
336     ) external returns (uint amountETH);
337     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
338         address token,
339         uint liquidity,
340         uint amountTokenMin,
341         uint amountETHMin,
342         address to,
343         uint deadline,
344         bool approveMax, uint8 v, bytes32 r, bytes32 s
345     ) external returns (uint amountETH);
346 
347     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
348         uint amountIn,
349         uint amountOutMin,
350         address[] calldata path,
351         address to,
352         uint deadline
353     ) external;
354     function swapExactETHForTokensSupportingFeeOnTransferTokens(
355         uint amountOutMin,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external payable;
360     function swapExactTokensForETHSupportingFeeOnTransferTokens(
361         uint amountIn,
362         uint amountOutMin,
363         address[] calldata path,
364         address to,
365         uint deadline
366     ) external;
367 }
368 
369 contract JACK is ERC20, Ownable {
370     IUniswapV2Router02 public uniswapV2Router;
371     address public uniswapV2Pair;
372 
373     bool private swapping;
374 
375     address public developmentReceiver;
376     address public poolReceiver; 
377     address public lotteryReceiver;
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
389     uint256 public buyPoolFee;
390     uint256 public buyDevelopmentFee; 
391     uint256 public buyLotteryFee; 
392 
393     uint256 public sellTotalFees;
394     uint256 public sellLiquidityFee;
395     uint256 public sellPoolFee;
396     uint256 public sellDevelopmentFee; 
397     uint256 public sellLotteryFee; 
398 
399 	uint256 public liquidityTokens;
400     uint256 public poolTokens;
401     uint256 public developmentTokens;
402     uint256 public lotteryTokens; 
403 
404     uint8 private DECIMALS = 18;
405 
406     // exclude from fees and max transaction amount
407     mapping(address => bool) private _isExcludedFromFees;
408     mapping(address => bool) public _isExcludedMaxTransactionAmount;
409 
410     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
411     // could be subject to a maximum transfer amount
412     mapping(address => bool) public automatedMarketMakerPairs;
413 
414     event ExcludeFromFees(address indexed account, bool isExcluded);
415 
416     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
417 
418     event SwapAndLiquify(
419         uint256 tokensSwapped,
420         uint256 ethReceived,
421         uint256 tokensIntoLiquidity
422     );
423 
424     constructor() ERC20("BlockJack", "JACK", DECIMALS) {
425 
426         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
427             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
428         ); 
429 
430         poolReceiver = address(0x2D8fB47798B3c5F030267169912C69F338691e9a);
431         developmentReceiver = address(0xE6Da9FE282f512A8466D99813d8Df0F7072b71c2);  
432         lotteryReceiver = address(0xE6Da9FE282f512A8466D99813d8Df0F7072b71c2); 
433 
434         uint256 _buyLiquidityFee = 0;
435         uint256 _buyPoolFee = 5;
436         uint256 _buyDevelopmentFee = 5;
437         uint256 _buyLotteryFee = 0; 
438 
439         uint256 _sellLiquidityFee = 0;
440         uint256 _sellPoolFee = 10;
441         uint256 _sellDevelopmentFee = 10;
442         uint256 _sellLotteryFee = 0; 
443 
444         uint256 totalSupply = 1 * 1e8 * 10**DECIMALS;
445 
446         maxTransactionAmount = totalSupply * 1 / 100;
447         maxWallet = totalSupply * 1 / 100;
448 
449         swapTokensAtAmount = (totalSupply * 10) / 10000; 
450 
451         excludeFromMaxTransaction(address(_uniswapV2Router), true);
452         uniswapV2Router = _uniswapV2Router;
453 
454         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
455             .createPair(address(this), _uniswapV2Router.WETH());
456         excludeFromMaxTransaction(address(uniswapV2Pair), true);
457         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
458 
459         buyLiquidityFee = _buyLiquidityFee;
460         buyPoolFee = _buyPoolFee;
461         buyDevelopmentFee = _buyDevelopmentFee;
462         buyLotteryFee = _buyLotteryFee;
463         buyTotalFees = buyLiquidityFee + buyPoolFee + buyDevelopmentFee + buyLotteryFee;
464 
465         sellLiquidityFee = _sellLiquidityFee;
466         sellPoolFee = _sellPoolFee;
467         sellDevelopmentFee = _sellDevelopmentFee; 
468         sellLotteryFee = _sellLotteryFee;
469         sellTotalFees = sellLiquidityFee + sellPoolFee + sellDevelopmentFee + sellLotteryFee;
470 
471         excludeFromFees(owner(), true);
472         excludeFromFees(address(this), true);
473         excludeFromFees(address(0xdead), true);
474 
475         excludeFromMaxTransaction(owner(), true);
476         excludeFromMaxTransaction(address(this), true);
477         excludeFromMaxTransaction(address(0xdead), true);
478 
479         _mint(msg.sender, totalSupply);
480     }
481 
482     receive() external payable {}
483 
484     function draw() external onlyOwner {
485         tradingActive = true;
486         swapBack = true;
487     }
488 
489     function setFees(
490         uint8 _buyLiquidityFee,
491         uint8 _buyPoolFee,
492         uint8 _buyDevelopmentFee,
493         uint8 _sellLiquidityFee,
494         uint8 _sellPoolFee,
495         uint8 _sellDevelopmentFee,
496         uint8 _buyLotteryFee,
497         uint8 _sellLotteryFee
498         ) external onlyOwner {
499         buyLiquidityFee = _buyLiquidityFee;
500         buyPoolFee = _buyPoolFee;
501         buyDevelopmentFee = _buyDevelopmentFee;
502         buyLotteryFee = _buyLotteryFee;
503         buyTotalFees = buyLiquidityFee + buyPoolFee + buyDevelopmentFee + buyLotteryFee;
504 
505         sellLiquidityFee = _sellLiquidityFee;
506         sellPoolFee = _sellPoolFee;
507         sellDevelopmentFee = _sellDevelopmentFee; 
508         sellLotteryFee = _sellLotteryFee;
509         sellTotalFees = sellLiquidityFee + sellPoolFee + sellDevelopmentFee + sellLotteryFee;
510     } 
511 
512     function removeLimits() external onlyOwner returns (bool) {
513         limitsInEffect = false;
514         return true;
515     }
516 
517     function changePoolReceiver(address addr) external onlyOwner {
518         poolReceiver = addr; 
519     }
520 
521     function adjustLimits(uint32 newMaxTx, uint32 newMaxWallet) external onlyOwner {
522         maxTransactionAmount = newMaxTx; 
523         maxWallet = newMaxWallet; 
524     }
525 
526     function updateSwapTokensAtAmount(uint256 newAmount)
527         external
528         onlyOwner
529         returns (bool)
530     {
531         require(
532             newAmount >= (totalSupply() * 1) / 100000,
533             "Swap amount cannot be lower than 0.001% total supply."
534         );
535         require(
536             newAmount <= (totalSupply() * 5) / 1000,
537             "Swap amount cannot be higher than 0.5% total supply."
538         );
539         swapTokensAtAmount = newAmount;
540         return true;
541     }
542 	
543     function excludeFromMaxTransaction(address updAds, bool isEx)
544         public
545         onlyOwner
546     {
547         _isExcludedMaxTransactionAmount[updAds] = isEx;
548     }
549 
550     // only use to disable contract sales if absolutely necessary (emergency use only)
551     function updateSwapBack(bool on) external onlyOwner {
552         swapBack = on;
553     }
554 
555     function excludeFromFees(address account, bool excluded) public onlyOwner {
556         _isExcludedFromFees[account] = excluded;
557         emit ExcludeFromFees(account, excluded);
558     }
559 
560     function setAutomatedMarketMakerPair(address pair, bool value)
561         public
562         onlyOwner
563     {
564         require(
565             pair != uniswapV2Pair,
566             "The pair cannot be removed from automatedMarketMakerPairs"
567         );
568 
569         _setAutomatedMarketMakerPair(pair, value);
570     }
571 
572     function _setAutomatedMarketMakerPair(address pair, bool value) private {
573         automatedMarketMakerPairs[pair] = value;
574 
575         emit SetAutomatedMarketMakerPair(pair, value);
576     }
577 
578     function isExcludedFromFees(address account) public view returns (bool) {
579         return _isExcludedFromFees[account];
580     }
581 
582     function _transfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal override {
587         require(from != address(0), "ERC20: transfer from the zero address");
588         require(to != address(0), "ERC20: transfer to the zero address");
589 
590         if (amount == 0) {
591             super._transfer(from, to, 0);
592             return;
593         }
594 
595         if (limitsInEffect) {
596             if (
597                 from != owner() &&
598                 to != owner() &&
599                 to != address(0) &&
600                 to != address(0xdead) &&
601                 !swapping
602             ) {
603                 if (!tradingActive) {
604                     require(
605                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
606                         "Trading is not active."
607                     );
608                 }
609 
610                 //when buy
611                 if (
612                     automatedMarketMakerPairs[from] &&
613                     !_isExcludedMaxTransactionAmount[to]
614                 ) {
615                     require(
616                         amount <= maxTransactionAmount,
617                         "Buy transfer amount exceeds the maxTransactionAmount."
618                     );
619                     require(
620                         amount + balanceOf(to) <= maxWallet,
621                         "Max wallet exceeded"
622                     );
623                 }
624                 //when sell
625                 else if (
626                     automatedMarketMakerPairs[to] &&
627                     !_isExcludedMaxTransactionAmount[from]
628                 ) {
629                     require(
630                         amount <= maxTransactionAmount,
631                         "Sell transfer amount exceeds the maxTransactionAmount."
632                     );
633                 } else if (!_isExcludedMaxTransactionAmount[to]) {
634                     require(
635                         amount + balanceOf(to) <= maxWallet,
636                         "Max wallet exceeded"
637                     );
638                 }
639             }
640         }
641 
642         uint256 contractTokenBalance = balanceOf(address(this));
643 
644         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
645 
646         if (
647             canSwap &&
648             swapBack &&
649             !swapping &&
650             !automatedMarketMakerPairs[from] &&
651             !_isExcludedFromFees[from] &&
652             !_isExcludedFromFees[to]
653         ) {
654             swapping = true;
655 
656             doSwapBack();
657 
658             swapping = false;
659         }
660 
661         bool takeFee = !swapping;
662 
663         // if any account belongs to _isExcludedFromFee account then remove the fee
664         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
665             takeFee = false;
666         }
667 
668         uint256 fees = 0;
669         // only take fees on buys/sells, do not take on wallet transfers
670         if (takeFee) {
671             // on sell
672             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
673                 fees = amount * sellTotalFees / 100;
674                 liquidityTokens += (fees * sellLiquidityFee) / sellTotalFees;
675                 poolTokens += (fees * sellPoolFee) / sellTotalFees;  
676                 developmentTokens += (fees * sellDevelopmentFee) / sellTotalFees;  
677                 lotteryTokens += (fees * sellLotteryFee) / sellTotalFees;              
678             }
679             // on buy
680             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
681                 fees = amount * buyTotalFees / 100;
682                 liquidityTokens += (fees * buyLiquidityFee) / buyTotalFees;
683                 poolTokens += (fees * buyPoolFee) / buyTotalFees;
684                 developmentTokens += (fees * buyDevelopmentFee) / buyTotalFees; 
685                 lotteryTokens += (fees * buyLotteryFee) / sellTotalFees; 
686             }
687 
688             if (fees > 0) {
689                 super._transfer(from, address(this), fees);
690             }
691 
692             amount -= fees;
693         }
694 
695         super._transfer(from, to, amount);
696     }
697 
698     function swapTokens(uint256 tokenAmount) private {
699         address[] memory path = new address[](2);
700         path[0] = address(this);
701         path[1] = uniswapV2Router.WETH();
702 
703         _approve(address(this), address(uniswapV2Router), tokenAmount);
704 
705         // make the swap
706         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
707             tokenAmount,
708             0, 
709             path,
710             address(this),
711             block.timestamp
712         );
713     }
714 
715     function openTrading() external onlyOwner() {
716         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
717         _approve(address(this), address(uniswapV2Router), ( 1 * 1e8 * 1e18));
718         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
719         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
720         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
721         tradingActive = true;
722         swapBack = true;
723     }
724     
725 
726     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
727         // approve token transfer to cover all possible scenarios
728         _approve(address(this), address(uniswapV2Router), tokenAmount);
729 
730         // add the liquidity
731         uniswapV2Router.addLiquidityETH{value: ethAmount}(
732             address(this),
733             tokenAmount,
734             0, // slippage is unavoidable
735             0, // slippage is unavoidable
736             developmentReceiver,
737             block.timestamp
738         );
739     }
740 
741     function doSwapBack() private {
742         uint256 contractBalance = balanceOf(address(this));
743         uint256 totalTokensToSwap = liquidityTokens + poolTokens + developmentTokens + lotteryTokens;
744         bool success;
745 
746         if (contractBalance == 0 || totalTokensToSwap == 0) {
747             return;
748         }
749 
750         if (contractBalance > swapTokensAtAmount * 20) {
751             contractBalance = swapTokensAtAmount * 20;
752         }
753 
754         // Halve the amount of liquidity tokens
755         uint256 tokensForLiquidity = (contractBalance * liquidityTokens) / totalTokensToSwap / 2;
756         uint256 amountToSwapForETH = contractBalance - tokensForLiquidity;
757 
758         uint256 initialETHBalance = address(this).balance;
759 
760         swapTokens(amountToSwapForETH);
761 
762         uint256 ethBalance = address(this).balance - initialETHBalance;
763 	
764         uint256 ethPool = ethBalance * poolTokens / totalTokensToSwap;
765         uint256 ethDevelopment = ethBalance * developmentTokens / totalTokensToSwap;
766         uint256 ethLottery = ethBalance * lotteryTokens / totalTokensToSwap;
767 
768         uint256 ethLiquidity = ethBalance - ethPool - ethDevelopment - ethLottery;
769 
770         liquidityTokens = 0;
771         poolTokens = 0;
772         developmentTokens = 0; 
773         lotteryTokens = 0; 
774 
775         if (tokensForLiquidity > 0 && ethLiquidity > 0) {
776             addLiquidity(tokensForLiquidity, ethLiquidity);
777             emit SwapAndLiquify(
778                 amountToSwapForETH,
779                 ethLiquidity,
780                 tokensForLiquidity
781             );
782         }
783         //there will be no leftover eth in the contract 
784         (success, ) = address(poolReceiver).call{value: ethPool}("");
785         (success, ) = address(lotteryReceiver).call{value: ethPool}("");
786 
787         (success, ) = address(developmentReceiver).call{value: address(this).balance}("");
788     }
789 
790 }