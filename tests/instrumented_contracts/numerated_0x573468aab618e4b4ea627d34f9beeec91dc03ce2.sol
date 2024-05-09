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
14 COCAINE BULL ($COKE)
15 
16 Welcome!  Make sure to grab yourself a bag of $COKE.
17 
18 Telegram:
19 https://t.me/CocaineBullToken
20 
21 Twitter:
22 @CocaineBullETH
23 
24 Website:
25 www.cocainebull.vip
26 
27 
28 */
29 
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     function owner() public view virtual returns (address) {
51         return _owner;
52     }
53 
54     modifier onlyOwner() {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         _transferOwnership(address(0));
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _transferOwnership(newOwner);
66     }
67     function _transferOwnership(address newOwner) internal virtual {
68         address oldOwner = _owner;
69         _owner = newOwner;
70         emit OwnershipTransferred(oldOwner, newOwner);
71     }
72 }
73 
74 interface IERC20 {
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool);
78     function allowance(address owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface IERC20Metadata is IERC20 {
90     function name() external view returns (string memory);
91     function symbol() external view returns (string memory);
92     function decimals() external view returns (uint8);
93 }
94 
95 contract ERC20 is Context, IERC20, IERC20Metadata {
96     mapping(address => uint256) private _balances;
97     mapping(address => mapping(address => uint256)) private _allowances;
98 
99     uint256 private _totalSupply;
100     string private _name;
101     string private _symbol;
102 
103     constructor(string memory name_, string memory symbol_) {
104         _name = name_;
105         _symbol = symbol_;
106     }
107 
108 
109     function name() public view virtual override returns (string memory) {
110         return _name;
111     }
112 
113     function symbol() public view virtual override returns (string memory) {
114         return _symbol;
115     }
116 
117     function decimals() public view virtual override returns (uint8) {
118         return 18;
119     }
120 
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134     function allowance(address owner, address spender) public view virtual override returns (uint256) {
135         return _allowances[owner][spender];
136     }
137 
138     function approve(address spender, uint256 amount) public virtual override returns (bool) {
139         _approve(_msgSender(), spender, amount);
140         return true;
141     }
142 
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) public virtual override returns (bool) {
148         _transfer(sender, recipient, amount);
149 
150         uint256 currentAllowance = _allowances[sender][_msgSender()];
151         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
152         unchecked {
153             _approve(sender, _msgSender(), currentAllowance - amount);
154         }
155 
156         return true;
157     }
158 
159     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
160         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
161         return true;
162     }
163 
164     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
165         uint256 currentAllowance = _allowances[_msgSender()][spender];
166         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
167         unchecked {
168             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
169         }
170 
171         return true;
172     }
173 
174     function _transfer(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) internal virtual {
179         require(sender != address(0), "ERC20: transfer from the zero address");
180         require(recipient != address(0), "ERC20: transfer to the zero address");
181 
182         _beforeTokenTransfer(sender, recipient, amount);
183 
184         uint256 senderBalance = _balances[sender];
185         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
186         unchecked {
187             _balances[sender] = senderBalance - amount;
188         }
189         _balances[recipient] += amount;
190 
191         emit Transfer(sender, recipient, amount);
192 
193         _afterTokenTransfer(sender, recipient, amount);
194     }
195 
196     function _mint(address account, uint256 amount) internal virtual {
197         require(account != address(0), "ERC20: mint to the zero address");
198 
199         _beforeTokenTransfer(address(0), account, amount);
200 
201         _totalSupply += amount;
202         _balances[account] += amount;
203         emit Transfer(address(0), account, amount);
204 
205         _afterTokenTransfer(address(0), account, amount);
206     }
207 
208     function _burn(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: burn from the zero address");
210 
211         _beforeTokenTransfer(account, address(0), amount);
212 
213         uint256 accountBalance = _balances[account];
214         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
215         unchecked {
216             _balances[account] = accountBalance - amount;
217         }
218         _totalSupply -= amount;
219 
220         emit Transfer(account, address(0), amount);
221 
222         _afterTokenTransfer(account, address(0), amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232 
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _beforeTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 
243     function _afterTokenTransfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {}
248 }
249 
250 library SafeMath {
251     function add(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a + b;
253     }
254 
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a - b;
257     }
258 
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a * b;
261     }
262 
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a / b;
265     }
266 
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a % b;
269     }
270 
271     function sub(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b <= a, errorMessage);
278             return a - b;
279         }
280     }
281 
282     function div(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b > 0, errorMessage);
289             return a / b;
290         }
291     }
292 
293     function mod(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         unchecked {
299             require(b > 0, errorMessage);
300             return a % b;
301         }
302     }
303 }
304 
305 interface IUniswapV2Factory {
306     function createPair(address tokenA, address tokenB)
307         external
308         returns (address pair);
309 }
310 
311 interface IUniswapV2Router02 {
312     function factory() external pure returns (address);
313 
314     function WETH() external pure returns (address);
315 
316     function addLiquidityETH(
317         address token,
318         uint256 amountTokenDesired,
319         uint256 amountTokenMin,
320         uint256 amountETHMin,
321         address to,
322         uint256 deadline
323     )
324         external
325         payable
326         returns (
327             uint256 amountToken,
328             uint256 amountETH,
329             uint256 liquidity
330         );
331 
332     function swapExactTokensForETHSupportingFeeOnTransferTokens(
333         uint256 amountIn,
334         uint256 amountOutMin,
335         address[] calldata path,
336         address to,
337         uint256 deadline
338     ) external;
339 }
340 
341 contract COCAINEBULL is ERC20, Ownable {
342     using SafeMath for uint256;
343 
344     IUniswapV2Router02 public immutable uniswapV2Router;
345     address public immutable uniswapV2Pair;
346 
347     bool private swapping;
348 
349     address public devWallet;
350 
351     uint256 public maxTransactionAmount;
352     uint256 public swapTokensAtAmount;
353     uint256 public maxWallet;
354 
355     bool public limitsInEffect = true;
356     bool public tradingActive = false;
357     bool public swapEnabled = false;
358 
359     uint256 public buyTotalFees;
360     uint256 public buyLiquidityFee;
361     uint256 public buyMarketingFee;
362 
363     uint256 public sellTotalFees;
364     uint256 public sellLiquidityFee;
365     uint256 public sellMarketingFee;
366 
367 	uint256 public tokensForLiquidity;
368     uint256 public tokensForMarketing;
369 
370     // exclude from fees and max transaction amount
371     mapping(address => bool) private _isExcludedFromFees;
372     mapping(address => bool) public _isExcludedMaxTransactionAmount;
373 
374     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
375     // could be subject to a maximum transfer amount
376     mapping(address => bool) public automatedMarketMakerPairs;
377 
378     event ExcludeFromFees(address indexed account, bool isExcluded);
379 
380     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
381 
382     event SwapAndLiquify(
383         uint256 tokensSwapped,
384         uint256 ethReceived,
385         uint256 tokensIntoLiquidity
386     );
387 
388     constructor() ERC20("COCAINE BULL", "COKE") {
389         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
390             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
391         );
392 
393         excludeFromMaxTransaction(address(_uniswapV2Router), true);
394         uniswapV2Router = _uniswapV2Router;
395 
396         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
397             .createPair(address(this), _uniswapV2Router.WETH());
398         excludeFromMaxTransaction(address(uniswapV2Pair), true);
399         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
400 
401         uint256 _buyLiquidityFee = 10;
402         uint256 _buyMarketingFee = 30;
403 
404         uint256 _sellLiquidityFee = 15;
405         uint256 _sellMarketingFee = 50;
406 
407         uint256 totalSupply = 1 * 1e15 * 1e18;
408 
409         maxTransactionAmount = 2 * 1e13 * 1e18; 
410         maxWallet = 2 * 1e13 * 1e18; 
411         swapTokensAtAmount = (totalSupply * 2) / 1000; 
412 
413         buyLiquidityFee = _buyLiquidityFee;
414         buyMarketingFee = _buyMarketingFee;
415         buyTotalFees = buyLiquidityFee + buyMarketingFee;
416 
417         sellLiquidityFee = _sellLiquidityFee;
418         sellMarketingFee = _sellMarketingFee;
419         sellTotalFees = sellLiquidityFee + sellMarketingFee;
420 
421         devWallet = address(0xe0c58CF17C5e42612936a8EDda64C12B12C9A9Ab); 
422 
423         // exclude from paying fees or having max transaction amount
424         excludeFromFees(owner(), true);
425         excludeFromFees(address(this), true);
426         excludeFromFees(address(0xdead), true);
427 
428         excludeFromMaxTransaction(owner(), true);
429         excludeFromMaxTransaction(address(this), true);
430         excludeFromMaxTransaction(address(0xdead), true);
431 
432         _mint(msg.sender, totalSupply);
433     }
434 
435     receive() external payable {}
436 
437     // once enabled, can never be turned off
438     function enableTrading() external onlyOwner {
439         tradingActive = true;
440         swapEnabled = true;
441     }
442 
443     function updateFees(uint256 _buyLiquidityFee, uint256 _buyMarketingFee, uint256 _sellLiquidityFee, uint256 _sellMarketingFee) external onlyOwner {
444         buyLiquidityFee = _buyLiquidityFee;
445         buyMarketingFee = _buyMarketingFee;
446         buyTotalFees = buyLiquidityFee + buyMarketingFee;
447 
448         sellLiquidityFee = _sellLiquidityFee;
449         sellMarketingFee = _sellMarketingFee;
450         sellTotalFees = sellLiquidityFee + sellMarketingFee;
451     } 
452 
453     function removeLimits() external onlyOwner returns (bool) {
454         limitsInEffect = false;
455         return true;
456     }
457 
458     // change the minimum amount of tokens to sell from fees
459     function updateSwapTokensAtAmount(uint256 newAmount)
460         external
461         onlyOwner
462         returns (bool)
463     {
464         require(
465             newAmount >= (totalSupply() * 1) / 100000,
466             "Swap amount cannot be lower than 0.001% total supply."
467         );
468         require(
469             newAmount <= (totalSupply() * 5) / 1000,
470             "Swap amount cannot be higher than 0.5% total supply."
471         );
472         swapTokensAtAmount = newAmount;
473         return true;
474     }
475 	
476     function excludeFromMaxTransaction(address updAds, bool isEx)
477         public
478         onlyOwner
479     {
480         _isExcludedMaxTransactionAmount[updAds] = isEx;
481     }
482 
483     // only use to disable contract sales if absolutely necessary (emergency use only)
484     function updateSwapEnabled(bool enabled) external onlyOwner {
485         swapEnabled = enabled;
486     }
487 
488     function excludeFromFees(address account, bool excluded) public onlyOwner {
489         _isExcludedFromFees[account] = excluded;
490         emit ExcludeFromFees(account, excluded);
491     }
492 
493     function setAutomatedMarketMakerPair(address pair, bool value)
494         public
495         onlyOwner
496     {
497         require(
498             pair != uniswapV2Pair,
499             "The pair cannot be removed from automatedMarketMakerPairs"
500         );
501 
502         _setAutomatedMarketMakerPair(pair, value);
503     }
504 
505     function _setAutomatedMarketMakerPair(address pair, bool value) private {
506         automatedMarketMakerPairs[pair] = value;
507 
508         emit SetAutomatedMarketMakerPair(pair, value);
509     }
510 
511     function isExcludedFromFees(address account) public view returns (bool) {
512         return _isExcludedFromFees[account];
513     }
514 
515     function _transfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal override {
520         require(from != address(0), "ERC20: transfer from the zero address");
521         require(to != address(0), "ERC20: transfer to the zero address");
522 
523         if (amount == 0) {
524             super._transfer(from, to, 0);
525             return;
526         }
527 
528         if (limitsInEffect) {
529             if (
530                 from != owner() &&
531                 to != owner() &&
532                 to != address(0) &&
533                 to != address(0xdead) &&
534                 !swapping
535             ) {
536                 if (!tradingActive) {
537                     require(
538                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
539                         "Trading is not active."
540                     );
541                 }
542 
543                 //when buy
544                 if (
545                     automatedMarketMakerPairs[from] &&
546                     !_isExcludedMaxTransactionAmount[to]
547                 ) {
548                     require(
549                         amount <= maxTransactionAmount,
550                         "Buy transfer amount exceeds the maxTransactionAmount."
551                     );
552                     require(
553                         amount + balanceOf(to) <= maxWallet,
554                         "Max wallet exceeded"
555                     );
556                 }
557                 //when sell
558                 else if (
559                     automatedMarketMakerPairs[to] &&
560                     !_isExcludedMaxTransactionAmount[from]
561                 ) {
562                     require(
563                         amount <= maxTransactionAmount,
564                         "Sell transfer amount exceeds the maxTransactionAmount."
565                     );
566                 } else if (!_isExcludedMaxTransactionAmount[to]) {
567                     require(
568                         amount + balanceOf(to) <= maxWallet,
569                         "Max wallet exceeded"
570                     );
571                 }
572             }
573         }
574 
575         uint256 contractTokenBalance = balanceOf(address(this));
576 
577         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
578 
579         if (
580             canSwap &&
581             swapEnabled &&
582             !swapping &&
583             !automatedMarketMakerPairs[from] &&
584             !_isExcludedFromFees[from] &&
585             !_isExcludedFromFees[to]
586         ) {
587             swapping = true;
588 
589             swapBack();
590 
591             swapping = false;
592         }
593 
594         bool takeFee = !swapping;
595 
596         // if any account belongs to _isExcludedFromFee account then remove the fee
597         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
598             takeFee = false;
599         }
600 
601         uint256 fees = 0;
602         // only take fees on buys/sells, do not take on wallet transfers
603         if (takeFee) {
604             // on sell
605             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
606                 fees = amount.mul(sellTotalFees).div(100);
607                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
608                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;                
609             }
610             // on buy
611             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
612                 fees = amount.mul(buyTotalFees).div(100);
613                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
614                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
615             }
616 
617             if (fees > 0) {
618                 super._transfer(from, address(this), fees);
619             }
620 
621             amount -= fees;
622         }
623 
624         super._transfer(from, to, amount);
625     }
626 
627     function swapTokensForEth(uint256 tokenAmount) private {
628         // generate the uniswap pair path of token -> weth
629         address[] memory path = new address[](2);
630         path[0] = address(this);
631         path[1] = uniswapV2Router.WETH();
632 
633         _approve(address(this), address(uniswapV2Router), tokenAmount);
634 
635         // make the swap
636         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
637             tokenAmount,
638             0, // accept any amount of ETH
639             path,
640             address(this),
641             block.timestamp
642         );
643     }
644 
645     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
646         // approve token transfer to cover all possible scenarios
647         _approve(address(this), address(uniswapV2Router), tokenAmount);
648 
649         // add the liquidity
650         uniswapV2Router.addLiquidityETH{value: ethAmount}(
651             address(this),
652             tokenAmount,
653             0, // slippage is unavoidable
654             0, // slippage is unavoidable
655             devWallet,
656             block.timestamp
657         );
658     }
659 
660     function swapBack() private {
661         uint256 contractBalance = balanceOf(address(this));
662         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
663         bool success;
664 
665         if (contractBalance == 0 || totalTokensToSwap == 0) {
666             return;
667         }
668 
669         if (contractBalance > swapTokensAtAmount * 20) {
670             contractBalance = swapTokensAtAmount * 20;
671         }
672 
673         // Halve the amount of liquidity tokens
674         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
675         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
676 
677         uint256 initialETHBalance = address(this).balance;
678 
679         swapTokensForEth(amountToSwapForETH);
680 
681         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
682 	
683         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
684 
685         uint256 ethForLiquidity = ethBalance - ethForMarketing;
686 
687         tokensForLiquidity = 0;
688         tokensForMarketing = 0;
689 
690         if (liquidityTokens > 0 && ethForLiquidity > 0) {
691             addLiquidity(liquidityTokens, ethForLiquidity);
692             emit SwapAndLiquify(
693                 amountToSwapForETH,
694                 ethForLiquidity,
695                 tokensForLiquidity
696             );
697         }
698         //there will be no leftover eth in the contract 
699         (success, ) = address(devWallet).call{value: address(this).balance}("");
700     }
701 
702 }