1 /*
2 website:
3 https://www.dinero.bet/
4 
5 Telegram:
6 https://t.me/dinerobetofficial
7 
8 Twitter:
9 https://twitter.com/DineroBet
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity =0.8.16;
14 pragma experimental ABIEncoderV2;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner { //Change
45         _transferOwnership(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _transferOwnership(newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IERC20Metadata is IERC20 {
79 
80     function name() external view returns (string memory);
81     function symbol() external view returns (string memory);
82     function decimals() external view returns (uint8);
83 }
84 
85 
86 contract ERC20 is Context, IERC20, IERC20Metadata {
87     mapping(address => uint256) private _balances;
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
226     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         unchecked {
228             uint256 c = a + b;
229             if (c < a) return (false, 0);
230             return (true, c);
231         }
232     }
233 
234     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
235         unchecked {
236             if (b > a) return (false, 0);
237             return (true, a - b);
238         }
239     }
240 
241     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         unchecked {
243             if (a == 0) return (true, 0);
244             uint256 c = a * b;
245             if (c / a != b) return (false, 0);
246             return (true, c);
247         }
248     }
249 
250     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             if (b == 0) return (false, 0);
253             return (true, a / b);
254         }
255     }
256 
257     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             if (b == 0) return (false, 0);
260             return (true, a % b);
261         }
262     }
263 
264     function add(uint256 a, uint256 b) internal pure returns (uint256) {
265         return a + b;
266     }
267 
268     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a - b;
270     }
271 
272     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273         return a * b;
274     }
275 
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a / b;
278     }
279 
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a % b;
282     }
283 
284     function sub(
285         uint256 a,
286         uint256 b,
287         string memory errorMessage
288     ) internal pure returns (uint256) {
289         unchecked {
290             require(b <= a, errorMessage);
291             return a - b;
292         }
293     }
294 
295     function div(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         unchecked {
301             require(b > 0, errorMessage);
302             return a / b;
303         }
304     }
305 
306     function mod(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b > 0, errorMessage);
313             return a % b;
314         }
315     }
316 }
317 
318 interface IUniswapV2Factory {
319     event PairCreated(
320         address indexed token0,
321         address indexed token1,
322         address pair,
323         uint256
324     );
325 
326     function feeTo() external view returns (address);
327 
328     function feeToSetter() external view returns (address);
329 
330     function getPair(address tokenA, address tokenB)
331         external
332         view
333         returns (address pair);
334 
335     function allPairs(uint256) external view returns (address pair);
336 
337     function allPairsLength() external view returns (uint256);
338 
339     function createPair(address tokenA, address tokenB)
340         external
341         returns (address pair);
342 
343     function setFeeTo(address) external;
344 
345     function setFeeToSetter(address) external;
346 }
347 
348 interface IUniswapV2Pair {
349     event Approval(
350         address indexed owner,
351         address indexed spender,
352         uint256 value
353     );
354     event Transfer(address indexed from, address indexed to, uint256 value);
355 
356     function name() external pure returns (string memory);
357 
358     function symbol() external pure returns (string memory);
359 
360     function decimals() external pure returns (uint8);
361 
362     function totalSupply() external view returns (uint256);
363 
364     function balanceOf(address owner) external view returns (uint256);
365 
366     function allowance(address owner, address spender)
367         external
368         view
369         returns (uint256);
370 
371     function approve(address spender, uint256 value) external returns (bool);
372 
373     function transfer(address to, uint256 value) external returns (bool);
374 
375     function transferFrom(
376         address from,
377         address to,
378         uint256 value
379     ) external returns (bool);
380 
381     function DOMAIN_SEPARATOR() external view returns (bytes32);
382 
383     function PERMIT_TYPEHASH() external pure returns (bytes32);
384 
385     function nonces(address owner) external view returns (uint256);
386 
387     function permit(
388         address owner,
389         address spender,
390         uint256 value,
391         uint256 deadline,
392         uint8 v,
393         bytes32 r,
394         bytes32 s
395     ) external;
396 
397     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
398 
399     event Swap(
400         address indexed sender,
401         uint256 amount0In,
402         uint256 amount1In,
403         uint256 amount0Out,
404         uint256 amount1Out,
405         address indexed to
406     );
407     event Sync(uint112 reserve0, uint112 reserve1);
408 
409     function MINIMUM_LIQUIDITY() external pure returns (uint256);
410 
411     function factory() external view returns (address);
412 
413     function token0() external view returns (address);
414 
415     function token1() external view returns (address);
416 
417     function getReserves()
418         external
419         view
420         returns (
421             uint112 reserve0,
422             uint112 reserve1,
423             uint32 blockTimestampLast
424         );
425 
426     function price0CumulativeLast() external view returns (uint256);
427 
428     function price1CumulativeLast() external view returns (uint256);
429 
430     function kLast() external view returns (uint256);
431 
432     function mint(address to) external returns (uint256 liquidity);
433 
434     function swap(
435         uint256 amount0Out,
436         uint256 amount1Out,
437         address to,
438         bytes calldata data
439     ) external;
440 
441     function skim(address to) external;
442 
443     function sync() external;
444 
445     function initialize(address, address) external;
446 }
447 
448 interface IUniswapV2Router02 {
449     function factory() external pure returns (address);
450 
451     function WETH() external pure returns (address);
452 
453     function addLiquidity(
454         address tokenA,
455         address tokenB,
456         uint256 amountADesired,
457         uint256 amountBDesired,
458         uint256 amountAMin,
459         uint256 amountBMin,
460         address to,
461         uint256 deadline
462     )
463         external
464         returns (
465             uint256 amountA,
466             uint256 amountB,
467             uint256 liquidity
468         );
469 
470     function addLiquidityETH(
471         address token,
472         uint256 amountTokenDesired,
473         uint256 amountTokenMin,
474         uint256 amountETHMin,
475         address to,
476         uint256 deadline
477     )
478         external
479         payable
480         returns (
481             uint256 amountToken,
482             uint256 amountETH,
483             uint256 liquidity
484         );
485 
486     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
487         uint256 amountIn,
488         uint256 amountOutMin,
489         address[] calldata path,
490         address to,
491         uint256 deadline
492     ) external;
493 
494     function swapExactETHForTokensSupportingFeeOnTransferTokens(
495         uint256 amountOutMin,
496         address[] calldata path,
497         address to,
498         uint256 deadline
499     ) external payable;
500 
501     function swapExactTokensForETHSupportingFeeOnTransferTokens(
502         uint256 amountIn,
503         uint256 amountOutMin,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external;
508 }
509 
510 contract DINERO is ERC20, Ownable {
511     using SafeMath for uint256;
512 
513     IUniswapV2Router02 public immutable uniswapV2Router;
514     address public immutable uniswapV2Pair;
515     address public constant deadAddress = address(0xdead);
516 
517     bool private swapping;
518 
519     address public marketingWallet;
520 
521     uint256 public maxTransactionAmount;
522     uint256 public swapTokensAtAmount;
523     uint256 public maxWallet;
524 
525     bool public tradingActive = false;
526     bool public swapEnabled = false;
527 
528     uint256 public buyTotalFees;
529     uint256 private buyMarketingFee;
530     uint256 private buyLiquidityFee;
531 
532     uint256 public sellTotalFees;
533     uint256 private sellMarketingFee;
534     uint256 private sellLiquidityFee;
535 
536     uint256 private tokensForMarketing;
537     uint256 private tokensForLiquidity;
538     uint256 private previousFee;
539 
540     mapping(address => bool) private _isExcludedFromFees;
541     mapping(address => bool) private _isExcludedMaxTransactionAmount;
542     mapping(address => bool) private automatedMarketMakerPairs;
543     mapping(address => bool) public bots;
544     mapping (address => uint256) public _buyMap;
545     event UpdateUniswapV2Router(
546         address indexed newAddress,
547         address indexed oldAddress
548     );
549 
550     event ExcludeFromFees(address indexed account, bool isExcluded);
551 
552     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
553 
554     event marketingWalletUpdated(
555         address indexed newWallet,
556         address indexed oldWallet
557     );
558 
559     event SwapAndLiquify(
560         uint256 tokensSwapped,
561         uint256 ethReceived,
562         uint256 tokensIntoLiquidity
563     );
564 
565     constructor() ERC20("DINERO", "DINERO") {
566         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
567             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
568         );
569 
570         excludeFromMaxTransaction(address(_uniswapV2Router), true);
571         uniswapV2Router = _uniswapV2Router;
572 
573         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
574             .createPair(address(this), _uniswapV2Router.WETH());
575         excludeFromMaxTransaction(address(uniswapV2Pair), true);
576         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
577 
578         uint256 _buyMarketingFee = 5;
579         uint256 _buyLiquidityFee = 0;
580 
581         uint256 _sellMarketingFee = 5;
582         uint256 _sellLiquidityFee = 0;
583 
584         uint256 totalSupply = 1000000000 * 1e18;
585 
586         maxTransactionAmount = 20000000 * 1e18;
587         maxWallet = 20000000 * 1e18;
588         swapTokensAtAmount = (totalSupply * 5) / 10000;
589 
590         buyMarketingFee = _buyMarketingFee;
591         buyLiquidityFee = _buyLiquidityFee;
592         buyTotalFees = buyMarketingFee + buyLiquidityFee;
593 
594         sellMarketingFee = _sellMarketingFee;
595         sellLiquidityFee = _sellLiquidityFee;
596         sellTotalFees = sellMarketingFee + sellLiquidityFee;
597         previousFee = sellTotalFees;
598 
599         marketingWallet = address(0x376EC73d732abAfd58E1Cb617CD9f8Aa380429f7);
600 
601         excludeFromFees(owner(), true);
602         excludeFromFees(address(this), true);
603         excludeFromFees(address(0xdead), true);
604 
605         excludeFromMaxTransaction(owner(), true);
606         excludeFromMaxTransaction(address(this), true);
607         excludeFromMaxTransaction(address(0xdead), true);
608 
609         _mint(msg.sender, totalSupply);
610     }
611 
612     receive() external payable {}
613 
614     function enableTrading() external onlyOwner {
615         tradingActive = true;
616         swapEnabled = true;
617     }
618 
619     function updateSwapTokensAtAmount(uint256 newAmount)
620         external
621         onlyOwner
622         returns (bool)
623     {
624         require(
625             newAmount >= (totalSupply() * 1) / 100000,
626             "Swap amount cannot be lower than 0.001% total supply."
627         );
628         require(
629             newAmount <= (totalSupply() * 5) / 1000,
630             "Swap amount cannot be higher than 0.5% total supply."
631         );
632         swapTokensAtAmount = newAmount;
633         return true;
634     }
635 
636     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
637         require(
638             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
639             "Cannot set maxTxn lower than 0.5%"
640         );
641         require(
642             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
643             "Cannot set maxWallet lower than 0.5%"
644         );
645         maxWallet = newMaxWalletNum * (10**18);
646         maxTransactionAmount = newTxnNum * (10**18);
647     }
648 
649     function blockBots(address[] memory bots_) public onlyOwner {
650         for (uint256 i = 0; i < bots_.length; i++) {
651             bots[bots_[i]] = true;
652         }
653     }
654 
655     function unblockBot(address notbot) public onlyOwner {
656         bots[notbot] = false;
657     }
658 
659     function excludeFromMaxTransaction(address updAds, bool isEx)
660         public
661         onlyOwner
662     {
663         _isExcludedMaxTransactionAmount[updAds] = isEx;
664     }
665 
666     function updateBuyFees(
667         uint256 _marketingFee,
668         uint256 _liquidityFee
669     ) external onlyOwner {
670         buyMarketingFee = _marketingFee;
671         buyLiquidityFee = _liquidityFee;
672         buyTotalFees = buyMarketingFee + buyLiquidityFee;
673         require(buyTotalFees <= 8, "Must keep fees at 8% or less");
674     }
675 
676     function updateSellFees(
677         uint256 _marketingFee,
678         uint256 _liquidityFee
679     ) external onlyOwner {
680         sellMarketingFee = _marketingFee;
681         sellLiquidityFee = _liquidityFee;
682         sellTotalFees = sellMarketingFee + sellLiquidityFee;
683         previousFee = sellTotalFees;
684         require(sellTotalFees <= 8, "Must keep fees at 8% or less");
685     }
686 
687     function excludeFromFees(address account, bool excluded) public onlyOwner {
688         _isExcludedFromFees[account] = excluded;
689         emit ExcludeFromFees(account, excluded);
690     }
691 
692     function setAutomatedMarketMakerPair(address pair, bool value)
693         public
694         onlyOwner
695     {
696         require(
697             pair != uniswapV2Pair,
698             "The pair cannot be removed from automatedMarketMakerPairs"
699         );
700 
701         _setAutomatedMarketMakerPair(pair, value);
702     }
703 
704     function _setAutomatedMarketMakerPair(address pair, bool value) private {
705         automatedMarketMakerPairs[pair] = value;
706 
707         emit SetAutomatedMarketMakerPair(pair, value);
708     }
709 
710     function isExcludedFromFees(address account) public view returns (bool) {
711         return _isExcludedFromFees[account];
712     }
713 
714     function _transfer(
715         address from,
716         address to,
717         uint256 amount
718     ) internal override {
719         require(from != address(0), "ERC20: transfer from the zero address");
720         require(to != address(0), "ERC20: transfer to the zero address");
721 
722         if (amount == 0) {
723             super._transfer(from, to, 0);
724             return;
725         }
726 
727                 if (
728                 from != owner() &&
729                 to != owner() &&
730                 to != address(0) &&
731                 to != address(0xdead) &&
732                 !swapping
733             ) {
734                 if (!tradingActive) {
735                     require(
736                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
737                         "Trading is not active."
738                     );
739                 }
740                 
741                 require(!bots[from] && !bots[to], "Your account is blacklisted!");
742 
743                 //when buy
744                 if (
745                     automatedMarketMakerPairs[from] &&
746                     !_isExcludedMaxTransactionAmount[to]
747                 ) {
748                     require(
749                         amount <= maxTransactionAmount,
750                         "Buy transfer amount exceeds the maxTransactionAmount."
751                     );
752                     require(
753                         amount + balanceOf(to) <= maxWallet,
754                         "Max wallet exceeded"
755                     );
756                 }
757                 //when sell
758                 else if (
759                     automatedMarketMakerPairs[to] &&
760                     !_isExcludedMaxTransactionAmount[from]
761                 ) {
762                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
763                 } 
764                 
765                 else if (!_isExcludedMaxTransactionAmount[to]) {
766                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
767                 }
768             }
769 
770         uint256 contractTokenBalance = balanceOf(address(this));
771 
772         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
773 
774         if (
775             canSwap &&
776             swapEnabled &&
777             !swapping &&
778             !automatedMarketMakerPairs[from] &&
779             !_isExcludedFromFees[from] &&
780             !_isExcludedFromFees[to]
781         ) {
782             swapping = true;
783 
784             swapBack();
785 
786             swapping = false;
787         }
788 
789         bool takeFee = !swapping;
790 
791         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
792             takeFee = false;
793         }
794 
795         uint256 fees = 0;
796 
797         if (takeFee) {
798             // on sell
799             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
800                 fees = amount.mul(sellTotalFees).div(100);
801                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
802                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
803             }
804             // on buy
805             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
806                 fees = amount.mul(buyTotalFees).div(100);
807                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
808                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
809             }
810 
811             if (fees > 0) {
812                 super._transfer(from, address(this), fees);
813             }
814 
815             amount -= fees;
816         }
817 
818         super._transfer(from, to, amount);
819         sellTotalFees = previousFee;
820 
821     }
822 
823     function swapTokensForEth(uint256 tokenAmount) private {
824 
825         address[] memory path = new address[](2);
826         path[0] = address(this);
827         path[1] = uniswapV2Router.WETH();
828 
829         _approve(address(this), address(uniswapV2Router), tokenAmount);
830 
831         // make the swap
832         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
833             tokenAmount,
834             0,
835             path,
836             address(this),
837             block.timestamp
838         );
839     }
840 
841     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
842 
843         _approve(address(this), address(uniswapV2Router), tokenAmount);
844 
845         uniswapV2Router.addLiquidityETH{value: ethAmount}(
846             address(this),
847             tokenAmount,
848             0,
849             0,
850             deadAddress,
851             block.timestamp
852         );
853     }
854 
855     function swapBack() private {
856         uint256 contractBalance = balanceOf(address(this));
857         uint256 totalTokensToSwap = tokensForLiquidity +
858             tokensForMarketing;
859         bool success;
860 
861         if (contractBalance == 0 || totalTokensToSwap == 0) {
862             return;
863         }
864 
865         if (contractBalance > swapTokensAtAmount * 20) {
866             contractBalance = swapTokensAtAmount * 20;
867         }
868 
869         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
870             totalTokensToSwap /
871             2;
872         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
873 
874         uint256 initialETHBalance = address(this).balance;
875 
876         swapTokensForEth(amountToSwapForETH);
877 
878         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
879 
880         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
881             totalTokensToSwap
882         );
883 
884         uint256 ethForLiquidity = ethBalance - ethForMarketing;
885 
886         tokensForLiquidity = 0;
887         tokensForMarketing = 0;
888 
889         if (liquidityTokens > 0 && ethForLiquidity > 0) {
890             addLiquidity(liquidityTokens, ethForLiquidity);
891             emit SwapAndLiquify(
892                 amountToSwapForETH,
893                 ethForLiquidity,
894                 tokensForLiquidity
895             );
896         }
897 
898         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
899     }
900 }