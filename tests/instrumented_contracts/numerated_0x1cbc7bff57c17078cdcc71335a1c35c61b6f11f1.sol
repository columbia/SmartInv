1 // SPDX-License-Identifier: MIT
2 
3 /*
4 The first and biggest token on the Shibarium chain. 
5 Like Shiba Inu, we begin on ETH, then move over
6 https://t.me/ShibariumChomp 
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
55     function totalSupply() external view returns (uint256);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 interface IERC20Metadata is IERC20 {
70     function name() external view returns (string memory);
71     function symbol() external view returns (string memory);
72     function decimals() external view returns (uint8);
73 }
74 
75 contract ERC20 is Context, IERC20, IERC20Metadata {
76     mapping(address => uint256) private _balances;
77     mapping(address => mapping(address => uint256)) private _allowances;
78 
79     uint256 private _totalSupply;
80     string private _name;
81     string private _symbol;
82 
83     constructor(string memory name_, string memory symbol_) {
84         _name = name_;
85         _symbol = symbol_;
86     }
87 
88 
89     function name() public view virtual override returns (string memory) {
90         return _name;
91     }
92 
93     function symbol() public view virtual override returns (string memory) {
94         return _symbol;
95     }
96 
97     function decimals() public view virtual override returns (uint8) {
98         return 18;
99     }
100 
101     function totalSupply() public view virtual override returns (uint256) {
102         return _totalSupply;
103     }
104 
105     function balanceOf(address account) public view virtual override returns (uint256) {
106         return _balances[account];
107     }
108 
109     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
110         _transfer(_msgSender(), recipient, amount);
111         return true;
112     }
113 
114     function allowance(address owner, address spender) public view virtual override returns (uint256) {
115         return _allowances[owner][spender];
116     }
117 
118     function approve(address spender, uint256 amount) public virtual override returns (bool) {
119         _approve(_msgSender(), spender, amount);
120         return true;
121     }
122 
123     function transferFrom(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) public virtual override returns (bool) {
128         _transfer(sender, recipient, amount);
129 
130         uint256 currentAllowance = _allowances[sender][_msgSender()];
131         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
132         unchecked {
133             _approve(sender, _msgSender(), currentAllowance - amount);
134         }
135 
136         return true;
137     }
138 
139     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
140         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
141         return true;
142     }
143 
144     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
145         uint256 currentAllowance = _allowances[_msgSender()][spender];
146         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
147         unchecked {
148             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
149         }
150 
151         return true;
152     }
153 
154     function _transfer(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) internal virtual {
159         require(sender != address(0), "ERC20: transfer from the zero address");
160         require(recipient != address(0), "ERC20: transfer to the zero address");
161 
162         _beforeTokenTransfer(sender, recipient, amount);
163 
164         uint256 senderBalance = _balances[sender];
165         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
166         unchecked {
167             _balances[sender] = senderBalance - amount;
168         }
169         _balances[recipient] += amount;
170 
171         emit Transfer(sender, recipient, amount);
172 
173         _afterTokenTransfer(sender, recipient, amount);
174     }
175 
176     function _mint(address account, uint256 amount) internal virtual {
177         require(account != address(0), "ERC20: mint to the zero address");
178 
179         _beforeTokenTransfer(address(0), account, amount);
180 
181         _totalSupply += amount;
182         _balances[account] += amount;
183         emit Transfer(address(0), account, amount);
184 
185         _afterTokenTransfer(address(0), account, amount);
186     }
187 
188     function _burn(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: burn from the zero address");
190 
191         _beforeTokenTransfer(account, address(0), amount);
192 
193         uint256 accountBalance = _balances[account];
194         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
195         unchecked {
196             _balances[account] = accountBalance - amount;
197         }
198         _totalSupply -= amount;
199 
200         emit Transfer(account, address(0), amount);
201 
202         _afterTokenTransfer(account, address(0), amount);
203     }
204 
205     function _approve(
206         address owner,
207         address spender,
208         uint256 amount
209     ) internal virtual {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212 
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _beforeTokenTransfer(
218         address from,
219         address to,
220         uint256 amount
221     ) internal virtual {}
222 
223     function _afterTokenTransfer(
224         address from,
225         address to,
226         uint256 amount
227     ) internal virtual {}
228 }
229 
230 library SafeMath {
231     function add(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a + b;
233     }
234 
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a - b;
237     }
238 
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a * b;
241     }
242 
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a / b;
245     }
246 
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a % b;
249     }
250 
251     function sub(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         unchecked {
257             require(b <= a, errorMessage);
258             return a - b;
259         }
260     }
261 
262     function div(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         unchecked {
268             require(b > 0, errorMessage);
269             return a / b;
270         }
271     }
272 
273     function mod(
274         uint256 a,
275         uint256 b,
276         string memory errorMessage
277     ) internal pure returns (uint256) {
278         unchecked {
279             require(b > 0, errorMessage);
280             return a % b;
281         }
282     }
283 }
284 
285 interface IUniswapV2Factory {
286     function createPair(address tokenA, address tokenB)
287         external
288         returns (address pair);
289 }
290 
291 interface IUniswapV2Router02 {
292     function factory() external pure returns (address);
293 
294     function WETH() external pure returns (address);
295 
296     function addLiquidityETH(
297         address token,
298         uint256 amountTokenDesired,
299         uint256 amountTokenMin,
300         uint256 amountETHMin,
301         address to,
302         uint256 deadline
303     )
304         external
305         payable
306         returns (
307             uint256 amountToken,
308             uint256 amountETH,
309             uint256 liquidity
310         );
311 
312     function swapExactTokensForETHSupportingFeeOnTransferTokens(
313         uint256 amountIn,
314         uint256 amountOutMin,
315         address[] calldata path,
316         address to,
317         uint256 deadline
318     ) external;
319 }
320 
321 contract Shibarium is ERC20, Ownable {
322     using SafeMath for uint256;
323 
324     IUniswapV2Router02 public immutable uniswapV2Router;
325     address public immutable uniswapV2Pair;
326 
327     bool private swapping;
328 
329     address public devWallet;
330 
331     uint256 public maxTransactionAmount;
332     uint256 public swapTokensAtAmount;
333     uint256 public maxWallet;
334 
335     bool public limitsInEffect = true;
336     bool public tradingActive = false;
337     bool public swapEnabled = false;
338 
339     uint256 public buyTotalFees;
340     uint256 public buyLiquidityFee;
341     uint256 public buyMarketingFee;
342 
343     uint256 public sellTotalFees;
344     uint256 public sellLiquidityFee;
345     uint256 public sellMarketingFee;
346 
347 	uint256 public tokensForLiquidity;
348     uint256 public tokensForMarketing;
349 
350     // exclude from fees and max transaction amount
351     mapping(address => bool) private _isExcludedFromFees;
352     mapping(address => bool) public _isExcludedMaxTransactionAmount;
353 
354     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
355     // could be subject to a maximum transfer amount
356     mapping(address => bool) public automatedMarketMakerPairs;
357 
358     event ExcludeFromFees(address indexed account, bool isExcluded);
359 
360     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
361 
362     event SwapAndLiquify(
363         uint256 tokensSwapped,
364         uint256 ethReceived,
365         uint256 tokensIntoLiquidity
366     );
367 
368     constructor() ERC20("Shibarium", "CHOMP") {
369         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
370             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
371         );
372 
373         excludeFromMaxTransaction(address(_uniswapV2Router), true);
374         uniswapV2Router = _uniswapV2Router;
375 
376         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
377             .createPair(address(this), _uniswapV2Router.WETH());
378         excludeFromMaxTransaction(address(uniswapV2Pair), true);
379         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
380 
381         uint256 _buyLiquidityFee = 0;
382         uint256 _buyMarketingFee = 20;
383 
384         uint256 _sellLiquidityFee = 0;
385         uint256 _sellMarketingFee = 50;
386 
387         uint256 totalSupply = 1 * 1e9 * 1e18;
388 
389         maxTransactionAmount = 15 * 1e6 * 1e18; 
390         maxWallet = 15 * 1e6 * 1e18; 
391         swapTokensAtAmount = (totalSupply * 10) / 10000; 
392 
393         buyLiquidityFee = _buyLiquidityFee;
394         buyMarketingFee = _buyMarketingFee;
395         buyTotalFees = buyLiquidityFee + buyMarketingFee;
396 
397         sellLiquidityFee = _sellLiquidityFee;
398         sellMarketingFee = _sellMarketingFee;
399         sellTotalFees = sellLiquidityFee + sellMarketingFee;
400 
401         devWallet = address(0x8f3f0C7ACC734a7806E28E24c2010BCBF460cB47); 
402 
403         // exclude from paying fees or having max transaction amount
404         excludeFromFees(owner(), true);
405         excludeFromFees(address(this), true);
406         excludeFromFees(address(0xdead), true);
407 
408         excludeFromMaxTransaction(owner(), true);
409         excludeFromMaxTransaction(address(this), true);
410         excludeFromMaxTransaction(address(0xdead), true);
411 
412         _mint(msg.sender, totalSupply);
413     }
414 
415     receive() external payable {}
416 
417     // once enabled, can never be turned off
418     function enableTrading() external onlyOwner {
419         tradingActive = true;
420         swapEnabled = true;
421     }
422 
423     function updateFees(uint256 _buyLiquidityFee, uint256 _buyMarketingFee, uint256 _sellLiquidityFee, uint256 _sellMarketingFee) external onlyOwner {
424         buyLiquidityFee = _buyLiquidityFee;
425         buyMarketingFee = _buyMarketingFee;
426         buyTotalFees = buyLiquidityFee + buyMarketingFee;
427 
428         sellLiquidityFee = _sellLiquidityFee;
429         sellMarketingFee = _sellMarketingFee;
430         sellTotalFees = sellLiquidityFee + sellMarketingFee;
431     } 
432 
433     function removeLimits() external onlyOwner returns (bool) {
434         limitsInEffect = false;
435         return true;
436     }
437 
438     // change the minimum amount of tokens to sell from fees
439     function updateSwapTokensAtAmount(uint256 newAmount)
440         external
441         onlyOwner
442         returns (bool)
443     {
444         require(
445             newAmount >= (totalSupply() * 1) / 100000,
446             "Swap amount cannot be lower than 0.001% total supply."
447         );
448         require(
449             newAmount <= (totalSupply() * 5) / 1000,
450             "Swap amount cannot be higher than 0.5% total supply."
451         );
452         swapTokensAtAmount = newAmount;
453         return true;
454     }
455 	
456     function excludeFromMaxTransaction(address updAds, bool isEx)
457         public
458         onlyOwner
459     {
460         _isExcludedMaxTransactionAmount[updAds] = isEx;
461     }
462 
463     // only use to disable contract sales if absolutely necessary (emergency use only)
464     function updateSwapEnabled(bool enabled) external onlyOwner {
465         swapEnabled = enabled;
466     }
467 
468     function excludeFromFees(address account, bool excluded) public onlyOwner {
469         _isExcludedFromFees[account] = excluded;
470         emit ExcludeFromFees(account, excluded);
471     }
472 
473     function setAutomatedMarketMakerPair(address pair, bool value)
474         public
475         onlyOwner
476     {
477         require(
478             pair != uniswapV2Pair,
479             "The pair cannot be removed from automatedMarketMakerPairs"
480         );
481 
482         _setAutomatedMarketMakerPair(pair, value);
483     }
484 
485     function _setAutomatedMarketMakerPair(address pair, bool value) private {
486         automatedMarketMakerPairs[pair] = value;
487 
488         emit SetAutomatedMarketMakerPair(pair, value);
489     }
490 
491     function isExcludedFromFees(address account) public view returns (bool) {
492         return _isExcludedFromFees[account];
493     }
494 
495     function _transfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal override {
500         require(from != address(0), "ERC20: transfer from the zero address");
501         require(to != address(0), "ERC20: transfer to the zero address");
502 
503         if (amount == 0) {
504             super._transfer(from, to, 0);
505             return;
506         }
507 
508         if (limitsInEffect) {
509             if (
510                 from != owner() &&
511                 to != owner() &&
512                 to != address(0) &&
513                 to != address(0xdead) &&
514                 !swapping
515             ) {
516                 if (!tradingActive) {
517                     require(
518                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
519                         "Trading is not active."
520                     );
521                 }
522 
523                 //when buy
524                 if (
525                     automatedMarketMakerPairs[from] &&
526                     !_isExcludedMaxTransactionAmount[to]
527                 ) {
528                     require(
529                         amount <= maxTransactionAmount,
530                         "Buy transfer amount exceeds the maxTransactionAmount."
531                     );
532                     require(
533                         amount + balanceOf(to) <= maxWallet,
534                         "Max wallet exceeded"
535                     );
536                 }
537                 //when sell
538                 else if (
539                     automatedMarketMakerPairs[to] &&
540                     !_isExcludedMaxTransactionAmount[from]
541                 ) {
542                     require(
543                         amount <= maxTransactionAmount,
544                         "Sell transfer amount exceeds the maxTransactionAmount."
545                     );
546                 } else if (!_isExcludedMaxTransactionAmount[to]) {
547                     require(
548                         amount + balanceOf(to) <= maxWallet,
549                         "Max wallet exceeded"
550                     );
551                 }
552             }
553         }
554 
555         uint256 contractTokenBalance = balanceOf(address(this));
556 
557         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
558 
559         if (
560             canSwap &&
561             swapEnabled &&
562             !swapping &&
563             !automatedMarketMakerPairs[from] &&
564             !_isExcludedFromFees[from] &&
565             !_isExcludedFromFees[to]
566         ) {
567             swapping = true;
568 
569             swapBack();
570 
571             swapping = false;
572         }
573 
574         bool takeFee = !swapping;
575 
576         // if any account belongs to _isExcludedFromFee account then remove the fee
577         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
578             takeFee = false;
579         }
580 
581         uint256 fees = 0;
582         // only take fees on buys/sells, do not take on wallet transfers
583         if (takeFee) {
584             // on sell
585             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
586                 fees = amount.mul(sellTotalFees).div(100);
587                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
588                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;                
589             }
590             // on buy
591             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
592                 fees = amount.mul(buyTotalFees).div(100);
593                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
594                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
595             }
596 
597             if (fees > 0) {
598                 super._transfer(from, address(this), fees);
599             }
600 
601             amount -= fees;
602         }
603 
604         super._transfer(from, to, amount);
605     }
606 
607     function swapTokensForEth(uint256 tokenAmount) private {
608         // generate the uniswap pair path of token -> weth
609         address[] memory path = new address[](2);
610         path[0] = address(this);
611         path[1] = uniswapV2Router.WETH();
612 
613         _approve(address(this), address(uniswapV2Router), tokenAmount);
614 
615         // make the swap
616         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
617             tokenAmount,
618             0, // accept any amount of ETH
619             path,
620             address(this),
621             block.timestamp
622         );
623     }
624 
625     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
626         // approve token transfer to cover all possible scenarios
627         _approve(address(this), address(uniswapV2Router), tokenAmount);
628 
629         // add the liquidity
630         uniswapV2Router.addLiquidityETH{value: ethAmount}(
631             address(this),
632             tokenAmount,
633             0, // slippage is unavoidable
634             0, // slippage is unavoidable
635             devWallet,
636             block.timestamp
637         );
638     }
639 
640     function swapBack() private {
641         uint256 contractBalance = balanceOf(address(this));
642         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
643         bool success;
644 
645         if (contractBalance == 0 || totalTokensToSwap == 0) {
646             return;
647         }
648 
649         if (contractBalance > swapTokensAtAmount * 20) {
650             contractBalance = swapTokensAtAmount * 20;
651         }
652 
653         // Halve the amount of liquidity tokens
654         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
655         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
656 
657         uint256 initialETHBalance = address(this).balance;
658 
659         swapTokensForEth(amountToSwapForETH);
660 
661         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
662 	
663         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
664 
665         uint256 ethForLiquidity = ethBalance - ethForMarketing;
666 
667         tokensForLiquidity = 0;
668         tokensForMarketing = 0;
669 
670         if (liquidityTokens > 0 && ethForLiquidity > 0) {
671             addLiquidity(liquidityTokens, ethForLiquidity);
672             emit SwapAndLiquify(
673                 amountToSwapForETH,
674                 ethForLiquidity,
675                 tokensForLiquidity
676             );
677         }
678         //there will be no leftover eth in the contract 
679         (success, ) = address(devWallet).call{value: address(this).balance}("");
680     }
681 
682 }