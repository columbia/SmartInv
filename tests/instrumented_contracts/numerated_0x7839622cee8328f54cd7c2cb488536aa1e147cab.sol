1 /**
2  
3 https://t.me/mixer_xAI
4 https://xaimixer.com/
5 https://twitter.com/xaiMixer
6 
7 */
8 
9 //  SPDX-License-Identifier: MIT
10 pragma solidity >=0.8.19;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
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
45 
46     function _transferOwnership(address newOwner) internal virtual {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51 }
52 
53 interface IERC20 {
54 
55     function totalSupply() external view returns (uint256);
56 
57     function balanceOf(address account) external view returns (uint256);
58 
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 interface IERC20Metadata is IERC20 {
77 
78     function name() external view returns (string memory);
79 
80     function symbol() external view returns (string memory);
81 
82     function decimals() external view returns (uint8);
83 }
84 
85 contract ERC20 is Context, IERC20, IERC20Metadata {
86     mapping(address => uint256) private _balances;
87 
88     mapping(address => mapping(address => uint256)) private _allowances;
89 
90     uint256 private _totalSupply;
91 
92     string private _name;
93     string private _symbol;
94 
95     constructor(string memory name_, string memory symbol_) {
96         _name = name_;
97         _symbol = symbol_;
98     }
99 
100     function name() public view virtual override returns (string memory) {
101         return _name;
102     }
103 
104     function symbol() public view virtual override returns (string memory) {
105         return _symbol;
106     }
107 
108     function decimals() public view virtual override returns (uint8) {
109         return 18;
110     }
111 
112     function totalSupply() public view virtual override returns (uint256) {
113         return _totalSupply;
114     }
115 
116     function balanceOf(address account) public view virtual override returns (uint256) {
117         return _balances[account];
118     }
119 
120     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
121         _transfer(_msgSender(), recipient, amount);
122         return true;
123     }
124 
125     function allowance(address owner, address spender) public view virtual override returns (uint256) {
126         return _allowances[owner][spender];
127     }
128 
129     function approve(address spender, uint256 amount) public virtual override returns (bool) {
130         _approve(_msgSender(), spender, amount);
131         return true;
132     }
133 
134     function transferFrom(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) public virtual override returns (bool) {
139         _transfer(sender, recipient, amount);
140 
141         uint256 currentAllowance = _allowances[sender][_msgSender()];
142         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
143         unchecked {
144             _approve(sender, _msgSender(), currentAllowance - amount);
145         }
146 
147         return true;
148     }
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
152         return true;
153     }
154 
155     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
156         uint256 currentAllowance = _allowances[_msgSender()][spender];
157         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
158         unchecked {
159             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
160         }
161 
162         return true;
163     }
164 
165     function _transfer(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) internal virtual {
170         require(sender != address(0), "ERC20: transfer from the zero address");
171         require(recipient != address(0), "ERC20: transfer to the zero address");
172 
173         _beforeTokenTransfer(sender, recipient, amount);
174 
175         uint256 senderBalance = _balances[sender];
176         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
177         unchecked {
178             _balances[sender] = senderBalance - amount;
179         }
180         _balances[recipient] += amount;
181 
182         emit Transfer(sender, recipient, amount);
183 
184         _afterTokenTransfer(sender, recipient, amount);
185     }
186 
187     function _mint(address account, uint256 amount) internal virtual {
188         require(account != address(0), "ERC20: mint to the zero address");
189 
190         _beforeTokenTransfer(address(0), account, amount);
191 
192         _totalSupply += amount;
193         _balances[account] += amount;
194         emit Transfer(address(0), account, amount);
195 
196         _afterTokenTransfer(address(0), account, amount);
197     }
198 
199     function _approve(
200         address owner,
201         address spender,
202         uint256 amount
203     ) internal virtual {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206 
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function _beforeTokenTransfer(
212         address from,
213         address to,
214         uint256 amount
215     ) internal virtual {}
216 
217     function _afterTokenTransfer(
218         address from,
219         address to,
220         uint256 amount
221     ) internal virtual {}
222 }
223 
224 library SafeMath {
225 
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a - b;
228     }
229 
230     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a * b;
232     }
233 
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a / b;
236     }
237 } 
238 
239 interface IUniswapV2Factory {
240     event PairCreated(
241         address indexed token0,
242         address indexed token1,
243         address pair,
244         uint256
245     );
246 
247     function feeTo() external view returns (address);
248 
249     function feeToSetter() external view returns (address);
250 
251     function getPair(address tokenA, address tokenB)
252         external
253         view
254         returns (address pair);
255 
256     function allPairs(uint256) external view returns (address pair);
257 
258     function allPairsLength() external view returns (uint256);
259 
260     function createPair(address tokenA, address tokenB)
261         external
262         returns (address pair);
263 
264     function setFeeTo(address) external;
265 
266     function setFeeToSetter(address) external;
267 }
268 
269 interface IUniswapV2Pair {
270     event Approval(
271         address indexed owner,
272         address indexed spender,
273         uint256 value
274     );
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     function name() external pure returns (string memory);
278 
279     function symbol() external pure returns (string memory);
280 
281     function decimals() external pure returns (uint8);
282 
283     function totalSupply() external view returns (uint256);
284 
285     function balanceOf(address owner) external view returns (uint256);
286 
287     function allowance(address owner, address spender)
288         external
289         view
290         returns (uint256);
291 
292     function approve(address spender, uint256 value) external returns (bool);
293 
294     function transfer(address to, uint256 value) external returns (bool);
295 
296     function transferFrom(
297         address from,
298         address to,
299         uint256 value
300     ) external returns (bool);
301 
302     function DOMAIN_SEPARATOR() external view returns (bytes32);
303 
304     function PERMIT_TYPEHASH() external pure returns (bytes32);
305 
306     function nonces(address owner) external view returns (uint256);
307 
308     function permit(
309         address owner,
310         address spender,
311         uint256 value,
312         uint256 deadline,
313         uint8 v,
314         bytes32 r,
315         bytes32 s
316     ) external;
317 
318     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
319     event Burn(
320         address indexed sender,
321         uint256 amount0,
322         uint256 amount1,
323         address indexed to
324     );
325     event Swap(
326         address indexed sender,
327         uint256 amount0In,
328         uint256 amount1In,
329         uint256 amount0Out,
330         uint256 amount1Out,
331         address indexed to
332     );
333     event Sync(uint112 reserve0, uint112 reserve1);
334 
335     function MINIMUM_LIQUIDITY() external pure returns (uint256);
336 
337     function factory() external view returns (address);
338 
339     function token0() external view returns (address);
340 
341     function token1() external view returns (address);
342 
343     function getReserves()
344         external
345         view
346         returns (
347             uint112 reserve0,
348             uint112 reserve1,
349             uint32 blockTimestampLast
350         );
351 
352     function price0CumulativeLast() external view returns (uint256);
353 
354     function price1CumulativeLast() external view returns (uint256);
355 
356     function kLast() external view returns (uint256);
357 
358     function mint(address to) external returns (uint256 liquidity);
359 
360     function burn(address to)
361         external
362         returns (uint256 amount0, uint256 amount1);
363 
364     function swap(
365         uint256 amount0Out,
366         uint256 amount1Out,
367         address to,
368         bytes calldata data
369     ) external;
370 
371     function skim(address to) external;
372 
373     function sync() external;
374 
375     function initialize(address, address) external;
376 }
377 
378 interface IUniswapV2Router02 {
379     function factory() external pure returns (address);
380 
381     function WETH() external pure returns (address);
382 
383     function addLiquidity(
384         address tokenA,
385         address tokenB,
386         uint256 amountADesired,
387         uint256 amountBDesired,
388         uint256 amountAMin,
389         uint256 amountBMin,
390         address to,
391         uint256 deadline
392     )
393         external
394         returns (
395             uint256 amountA,
396             uint256 amountB,
397             uint256 liquidity
398         );
399 
400     function addLiquidityETH(
401         address token,
402         uint256 amountTokenDesired,
403         uint256 amountTokenMin,
404         uint256 amountETHMin,
405         address to,
406         uint256 deadline
407     )
408         external
409         payable
410         returns (
411             uint256 amountToken,
412             uint256 amountETH,
413             uint256 liquidity
414         );
415 
416     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
417         uint256 amountIn,
418         uint256 amountOutMin,
419         address[] calldata path,
420         address to,
421         uint256 deadline
422     ) external;
423 
424     function swapExactETHForTokensSupportingFeeOnTransferTokens(
425         uint256 amountOutMin,
426         address[] calldata path,
427         address to,
428         uint256 deadline
429     ) external payable;
430 
431     function swapExactTokensForETHSupportingFeeOnTransferTokens(
432         uint256 amountIn,
433         uint256 amountOutMin,
434         address[] calldata path,
435         address to,
436         uint256 deadline
437     ) external;
438 }
439 
440 contract MIXER is ERC20, Ownable {
441     using SafeMath for uint256;
442 
443     IUniswapV2Router02 public immutable uniswapV2Router;
444     address public immutable uniswapV2Pair;
445     address public constant deadAddress = address(0xdead);
446 
447     bool private swapping;
448 
449     address public marketingWallet;
450     address public devWallet;
451     address public lpWallet;
452 
453     uint256 public maxTransactionAmount;
454     uint256 public swapTokensAtAmount;
455     uint256 public maxWallet;
456 
457     bool public limitsInEffect = true;
458     bool public tradingActive = true;
459     bool public swapEnabled = true;
460 
461     uint256 public buyTotalFees;
462     uint256 public buyMarketingFee;
463     uint256 public buyLiquidityFee;
464     uint256 public buyDevFee;
465 
466     uint256 public sellTotalFees;
467     uint256 public sellMarketingFee;
468     uint256 public sellLiquidityFee;
469     uint256 public sellDevFee;
470 
471     uint256 public tokensForMarketing;
472     uint256 public tokensForLiquidity;
473     uint256 public tokensForDev;
474 
475     /******************/
476 
477     // exlcude from fees and max transaction amount
478     mapping(address => bool) private _isExcludedFromFees;
479     mapping(address => bool) public _isExcludedMaxTransactionAmount;
480 
481     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
482     // could be subject to a maximum transfer amount
483     mapping(address => bool) public automatedMarketMakerPairs;
484 
485     event UpdateUniswapV2Router(
486         address indexed newAddress,
487         address indexed oldAddress
488     );
489 
490     event LimitsRemoved();
491 
492     event ExcludeFromFees(address indexed account, bool isExcluded);
493 
494     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
495 
496     event marketingWalletUpdated(
497         address indexed newWallet,
498         address indexed oldWallet
499     );
500 
501     event devWalletUpdated(
502         address indexed newWallet,
503         address indexed oldWallet
504     );
505 
506     event lpWalletUpdated(
507         address indexed newWallet,
508         address indexed oldWallet
509     );
510 
511     event SwapAndLiquify(
512         uint256 tokensSwapped,
513         uint256 ethReceived,
514         uint256 tokensIntoLiquidity
515     );
516 
517     constructor() ERC20("xaiMixer", "MIXER") {
518         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
519             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
520         );
521 
522         excludeFromMaxTransaction(address(_uniswapV2Router), true);
523         uniswapV2Router = _uniswapV2Router;
524 
525         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
526             .createPair(address(this), _uniswapV2Router.WETH());
527         excludeFromMaxTransaction(address(uniswapV2Pair), true);
528         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
529 
530         uint256 _buyMarketingFee = 20;
531         uint256 _buyLiquidityFee = 0;
532         uint256 _buyDevFee = 0;
533 
534         uint256 _sellMarketingFee = 40;
535         uint256 _sellLiquidityFee = 0;
536         uint256 _sellDevFee = 0;
537 
538         uint256 totalSupply = 1_000_000 * 1e18;
539 
540         maxTransactionAmount = (totalSupply * 2) / 100;
541         maxWallet = (totalSupply * 2) / 100;
542         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
543 
544         buyMarketingFee = _buyMarketingFee;
545         buyLiquidityFee = _buyLiquidityFee;
546         buyDevFee = _buyDevFee;
547         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
548 
549         sellMarketingFee = _sellMarketingFee;
550         sellLiquidityFee = _sellLiquidityFee;
551         sellDevFee = _sellDevFee;
552         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
553 
554         marketingWallet = address(0xC1BFC373264083cEEfDcBba4814217ccAbffce9A); 
555         devWallet = address(0xC1BFC373264083cEEfDcBba4814217ccAbffce9A);
556         lpWallet = msg.sender;
557 
558         // exclude from paying fees or having max transaction amount
559         excludeFromFees(owner(), true);
560         excludeFromFees(address(this), true);
561         excludeFromFees(address(0xdead), true);
562         excludeFromFees(marketingWallet, true);
563 
564         excludeFromMaxTransaction(owner(), true);
565         excludeFromMaxTransaction(address(this), true);
566         excludeFromMaxTransaction(address(0xdead), true);
567         excludeFromMaxTransaction(marketingWallet, true);
568 
569         /*
570             _mint is an internal function in ERC20.sol that is only called here,
571             and CANNOT be called ever again
572         */
573         _mint(msg.sender, totalSupply);
574     }
575 
576     receive() external payable {}
577 
578     // once enabled, can never be turned off
579     function enableTrading() external onlyOwner {
580         tradingActive = true;
581         swapEnabled = true;
582     }
583 
584     // remove limits after token is stable
585     function removeLimits() external onlyOwner returns (bool) {
586         limitsInEffect = false;
587         emit LimitsRemoved();
588         return true;
589     }
590 
591     // change the minimum amount of tokens to sell from fees
592     function updateSwapTokensAtAmount(uint256 newAmount)
593         external
594         onlyOwner
595         returns (bool)
596     {
597         require(
598             newAmount >= (totalSupply() * 1) / 100000,
599             "Swap amount cannot be lower than 0.001% total supply."
600         );
601         require(
602             newAmount <= (totalSupply() * 5) / 1000,
603             "Swap amount cannot be higher than 0.5% total supply."
604         );
605         swapTokensAtAmount = newAmount;
606         return true;
607     }
608 
609 
610 
611     function excludeFromMaxTransaction(address updAds, bool isEx)
612         public
613         onlyOwner
614     {
615         _isExcludedMaxTransactionAmount[updAds] = isEx;
616     }
617 
618     // only use to disable contract sales if absolutely necessary (emergency use only)
619     function updateSwapEnabled(bool enabled) external onlyOwner {
620         swapEnabled = enabled;
621     }
622 
623     function updateBuyFees(
624         uint256 _marketingFee,
625         uint256 _liquidityFee,
626         uint256 _devFee
627     ) external onlyOwner {
628          require((_marketingFee + _liquidityFee + _devFee) <= 20 ,"Buy fee cant be sent more than 20%");
629         buyMarketingFee = _marketingFee;
630         buyLiquidityFee = _liquidityFee;
631         buyDevFee = _devFee;
632         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
633     }
634 
635     function updateSellFees(
636         uint256 _marketingFee,
637         uint256 _liquidityFee,
638         uint256 _devFee
639     ) external onlyOwner {
640         require((_marketingFee + _liquidityFee + _devFee) <= 20 ,"Sell fee cant be sent more than 20%");
641         sellMarketingFee = _marketingFee;
642         sellLiquidityFee = _liquidityFee;
643         sellDevFee = _devFee;
644         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
645     }
646 
647     function excludeFromFees(address account, bool excluded) public onlyOwner {
648         _isExcludedFromFees[account] = excluded;
649         emit ExcludeFromFees(account, excluded);
650     }
651 
652     function setAutomatedMarketMakerPair(address pair, bool value)
653         public
654         onlyOwner
655     {
656         require(
657             pair != uniswapV2Pair,
658             "The pair cannot be removed from automatedMarketMakerPairs"
659         );
660 
661         _setAutomatedMarketMakerPair(pair, value);
662     }
663 
664     function _setAutomatedMarketMakerPair(address pair, bool value) private {
665         automatedMarketMakerPairs[pair] = value;
666 
667         emit SetAutomatedMarketMakerPair(pair, value);
668     }
669 
670     function updateMarketingWallet(address newMarketingWallet)
671         external
672         onlyOwner
673     {
674         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
675         marketingWallet = newMarketingWallet;
676     }
677 
678     function updateLPWallet(address newLPWallet)
679         external
680         onlyOwner
681     {
682         emit lpWalletUpdated(newLPWallet, lpWallet);
683         lpWallet = newLPWallet;
684     }
685 
686     function updateDevWallet(address newWallet) external onlyOwner {
687         emit devWalletUpdated(newWallet, devWallet);
688         devWallet = newWallet;
689     }
690 
691     function isExcludedFromFees(address account) public view returns (bool) {
692         return _isExcludedFromFees[account];
693     }
694 
695     event BoughtEarly(address indexed sniper);
696 
697     function _transfer(
698         address from,
699         address to,
700         uint256 amount
701     ) internal override {
702         require(from != address(0), "ERC20: transfer from the zero address");
703         require(to != address(0), "ERC20: transfer to the zero address");
704 
705         if (amount == 0) {
706             super._transfer(from, to, 0);
707             return;
708         }
709 
710         if (limitsInEffect) {
711             if (
712                 from != owner() &&
713                 to != owner() &&
714                 to != address(0) &&
715                 to != address(0xdead) &&
716                 !swapping
717             ) {
718                 if (!tradingActive) {
719                     require(
720                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
721                         "Trading is not active."
722                     );
723                 }
724 
725                 //when buy
726                 if (
727                     automatedMarketMakerPairs[from] &&
728                     !_isExcludedMaxTransactionAmount[to]
729                 ) {
730                     require(
731                         amount <= maxTransactionAmount,
732                         "Buy transfer amount exceeds the maxTransactionAmount."
733                     );
734                     require(
735                         amount + balanceOf(to) <= maxWallet,
736                         "Max wallet exceeded"
737                     );
738                 }
739                 //when sell
740                 else if (
741                     automatedMarketMakerPairs[to] &&
742                     !_isExcludedMaxTransactionAmount[from]
743                 ) {
744                     require(
745                         amount <= maxTransactionAmount,
746                         "Sell transfer amount exceeds the maxTransactionAmount."
747                     );
748                 } else if (!_isExcludedMaxTransactionAmount[to]) {
749                     require(
750                         amount + balanceOf(to) <= maxWallet,
751                         "Max wallet exceeded"
752                     );
753                 }
754             }
755         }
756 
757         uint256 contractTokenBalance = balanceOf(address(this));
758 
759         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
760 
761         if (
762             canSwap &&
763             swapEnabled &&
764             !swapping &&
765             !automatedMarketMakerPairs[from] &&
766             !_isExcludedFromFees[from] &&
767             !_isExcludedFromFees[to]
768         ) {
769             swapping = true;
770 
771             swapBack();
772 
773             swapping = false;
774         }
775 
776         bool takeFee = !swapping;
777 
778         // if any account belongs to _isExcludedFromFee account then remove the fee
779         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
780             takeFee = false;
781         }
782 
783         uint256 fees = 0;
784         // only take fees on buys/sells, do not take on wallet transfers
785         if (takeFee) {
786             // on sell
787             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
788                 fees = amount.mul(sellTotalFees).div(100);
789                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
790                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
791                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
792             }
793             // on buy
794             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
795                 fees = amount.mul(buyTotalFees).div(100);
796                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
797                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
798                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
799             }
800 
801             if (fees > 0) {
802                 super._transfer(from, address(this), fees);
803             }
804 
805             amount -= fees;
806         }
807 
808         super._transfer(from, to, amount);
809     }
810 
811     function swapTokensForEth(uint256 tokenAmount) private {
812         // generate the uniswap pair path of token -> weth
813         address[] memory path = new address[](2);
814         path[0] = address(this);
815         path[1] = uniswapV2Router.WETH();
816 
817         _approve(address(this), address(uniswapV2Router), tokenAmount);
818 
819         // make the swap
820         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
821             tokenAmount,
822             0, // accept any amount of ETH
823             path,
824             address(this),
825             block.timestamp
826         );
827     }
828 
829     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
830         // approve token transfer to cover all possible scenarios
831         _approve(address(this), address(uniswapV2Router), tokenAmount);
832 
833         // add the liquidity
834         uniswapV2Router.addLiquidityETH{value: ethAmount}(
835             address(this),
836             tokenAmount,
837             0, // slippage is unavoidable
838             0, // slippage is unavoidable
839             lpWallet,
840             block.timestamp
841         );
842     }
843 
844     function swapBack() private {
845         uint256 contractBalance = balanceOf(address(this));
846         uint256 totalTokensToSwap = tokensForLiquidity +
847             tokensForMarketing +
848             tokensForDev;
849         bool success;
850 
851         if (contractBalance == 0 || totalTokensToSwap == 0) {
852             return;
853         }
854 
855         // Halve the amount of liquidity tokens
856         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
857             totalTokensToSwap /
858             2;
859         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
860 
861         uint256 initialETHBalance = address(this).balance;
862 
863         swapTokensForEth(amountToSwapForETH);
864 
865         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
866 
867         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
868             totalTokensToSwap
869         );
870         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
871 
872         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
873 
874         tokensForLiquidity = 0;
875         tokensForMarketing = 0;
876         tokensForDev = 0;
877 
878         (success, ) = address(devWallet).call{value: ethForDev}("");
879 
880         if (liquidityTokens > 0 && ethForLiquidity > 0) {
881             addLiquidity(liquidityTokens, ethForLiquidity);
882             emit SwapAndLiquify(
883                 amountToSwapForETH,
884                 ethForLiquidity,
885                 tokensForLiquidity
886             );
887         }
888 
889         (success, ) = address(marketingWallet).call{
890             value: address(this).balance
891         }("");
892     }
893 }