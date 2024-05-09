1 //01010011 01000101 01000011
2 
3 
4 
5 //https://shiteatingclowns.com
6 
7 
8 
9 
10 //https://medium.com/@ShitEatingClowns/the-sec-a-threat-to-defi-8dd587e310a1
11 
12 
13 
14 
15 //https://twitter.com/SecTokenETH
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity =0.8.16;
19 pragma experimental ABIEncoderV2;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 abstract contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39 
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     function renounceOwnership() public virtual onlyOwner { //Change
50         _transferOwnership(address(0));
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         _transferOwnership(newOwner);
56     }
57 
58     function _transferOwnership(address newOwner) internal virtual {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 
65 interface IERC20 {
66 
67     function totalSupply() external view returns (uint256);
68     function balanceOf(address account) external view returns (uint256);
69     function transfer(address recipient, uint256 amount) external returns (bool);
70     function allowance(address owner, address spender) external view returns (uint256);
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86     function symbol() external view returns (string memory);
87     function decimals() external view returns (uint8);
88 }
89 
90 
91 contract ERC20 is Context, IERC20, IERC20Metadata {
92     mapping(address => uint256) private _balances;
93     mapping(address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99 
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view virtual override returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     function balanceOf(address account) public view virtual override returns (uint256) {
122         return _balances[account];
123     }
124 
125     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
126         _transfer(_msgSender(), recipient, amount);
127         return true;
128     }
129 
130     function allowance(address owner, address spender) public view virtual override returns (uint256) {
131         return _allowances[owner][spender];
132     }
133 
134     function approve(address spender, uint256 amount) public virtual override returns (bool) {
135         _approve(_msgSender(), spender, amount);
136         return true;
137     }
138 
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) public virtual override returns (bool) {
144         _transfer(sender, recipient, amount);
145 
146         uint256 currentAllowance = _allowances[sender][_msgSender()];
147         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
148         unchecked {
149             _approve(sender, _msgSender(), currentAllowance - amount);
150         }
151 
152         return true;
153     }
154 
155     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
156         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
157         return true;
158     }
159 
160     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
161         uint256 currentAllowance = _allowances[_msgSender()][spender];
162         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
163         unchecked {
164             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
165         }
166 
167         return true;
168     }
169 
170     function _transfer(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) internal virtual {
175         require(sender != address(0), "ERC20: transfer from the zero address");
176         require(recipient != address(0), "ERC20: transfer to the zero address");
177 
178         _beforeTokenTransfer(sender, recipient, amount);
179 
180         uint256 senderBalance = _balances[sender];
181         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
182         unchecked {
183             _balances[sender] = senderBalance - amount;
184         }
185         _balances[recipient] += amount;
186 
187         emit Transfer(sender, recipient, amount);
188 
189         _afterTokenTransfer(sender, recipient, amount);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194 
195         _beforeTokenTransfer(address(0), account, amount);
196 
197         _totalSupply += amount;
198         _balances[account] += amount;
199         emit Transfer(address(0), account, amount);
200 
201         _afterTokenTransfer(address(0), account, amount);
202     }
203 
204     function _approve(
205         address owner,
206         address spender,
207         uint256 amount
208     ) internal virtual {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211 
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _beforeTokenTransfer(
217         address from,
218         address to,
219         uint256 amount
220     ) internal virtual {}
221 
222     function _afterTokenTransfer(
223         address from,
224         address to,
225         uint256 amount
226     ) internal virtual {}
227 }
228 
229 library SafeMath {
230 
231     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             uint256 c = a + b;
234             if (c < a) return (false, 0);
235             return (true, c);
236         }
237     }
238 
239     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (b > a) return (false, 0);
242             return (true, a - b);
243         }
244     }
245 
246     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             if (a == 0) return (true, 0);
249             uint256 c = a * b;
250             if (c / a != b) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b == 0) return (false, 0);
258             return (true, a / b);
259         }
260     }
261 
262     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (b == 0) return (false, 0);
265             return (true, a % b);
266         }
267     }
268 
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a + b;
271     }
272 
273     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a - b;
275     }
276 
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         return a * b;
279     }
280 
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a / b;
283     }
284 
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a % b;
287     }
288 
289     function sub(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b <= a, errorMessage);
296             return a - b;
297         }
298     }
299 
300     function div(
301         uint256 a,
302         uint256 b,
303         string memory errorMessage
304     ) internal pure returns (uint256) {
305         unchecked {
306             require(b > 0, errorMessage);
307             return a / b;
308         }
309     }
310 
311     function mod(
312         uint256 a,
313         uint256 b,
314         string memory errorMessage
315     ) internal pure returns (uint256) {
316         unchecked {
317             require(b > 0, errorMessage);
318             return a % b;
319         }
320     }
321 }
322 
323 interface IUniswapV2Factory {
324     event PairCreated(
325         address indexed token0,
326         address indexed token1,
327         address pair,
328         uint256
329     );
330 
331     function feeTo() external view returns (address);
332 
333     function feeToSetter() external view returns (address);
334 
335     function getPair(address tokenA, address tokenB)
336         external
337         view
338         returns (address pair);
339 
340     function allPairs(uint256) external view returns (address pair);
341 
342     function allPairsLength() external view returns (uint256);
343 
344     function createPair(address tokenA, address tokenB)
345         external
346         returns (address pair);
347 
348     function setFeeTo(address) external;
349 
350     function setFeeToSetter(address) external;
351 }
352 
353 interface IUniswapV2Pair {
354     event Approval(
355         address indexed owner,
356         address indexed spender,
357         uint256 value
358     );
359     event Transfer(address indexed from, address indexed to, uint256 value);
360 
361     function name() external pure returns (string memory);
362 
363     function symbol() external pure returns (string memory);
364 
365     function decimals() external pure returns (uint8);
366 
367     function totalSupply() external view returns (uint256);
368 
369     function balanceOf(address owner) external view returns (uint256);
370 
371     function allowance(address owner, address spender)
372         external
373         view
374         returns (uint256);
375 
376     function approve(address spender, uint256 value) external returns (bool);
377 
378     function transfer(address to, uint256 value) external returns (bool);
379 
380     function transferFrom(
381         address from,
382         address to,
383         uint256 value
384     ) external returns (bool);
385 
386     function DOMAIN_SEPARATOR() external view returns (bytes32);
387 
388     function PERMIT_TYPEHASH() external pure returns (bytes32);
389 
390     function nonces(address owner) external view returns (uint256);
391 
392     function permit(
393         address owner,
394         address spender,
395         uint256 value,
396         uint256 deadline,
397         uint8 v,
398         bytes32 r,
399         bytes32 s
400     ) external;
401 
402     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
403 
404     event Swap(
405         address indexed sender,
406         uint256 amount0In,
407         uint256 amount1In,
408         uint256 amount0Out,
409         uint256 amount1Out,
410         address indexed to
411     );
412     event Sync(uint112 reserve0, uint112 reserve1);
413 
414     function MINIMUM_LIQUIDITY() external pure returns (uint256);
415 
416     function factory() external view returns (address);
417 
418     function token0() external view returns (address);
419 
420     function token1() external view returns (address);
421 
422     function getReserves()
423         external
424         view
425         returns (
426             uint112 reserve0,
427             uint112 reserve1,
428             uint32 blockTimestampLast
429         );
430 
431     function price0CumulativeLast() external view returns (uint256);
432 
433     function price1CumulativeLast() external view returns (uint256);
434 
435     function kLast() external view returns (uint256);
436 
437     function mint(address to) external returns (uint256 liquidity);
438 
439     function swap(
440         uint256 amount0Out,
441         uint256 amount1Out,
442         address to,
443         bytes calldata data
444     ) external;
445 
446     function skim(address to) external;
447 
448     function sync() external;
449 
450     function initialize(address, address) external;
451 }
452 
453 interface IUniswapV2Router02 {
454     function factory() external pure returns (address);
455 
456     function WETH() external pure returns (address);
457 
458     function addLiquidity(
459         address tokenA,
460         address tokenB,
461         uint256 amountADesired,
462         uint256 amountBDesired,
463         uint256 amountAMin,
464         uint256 amountBMin,
465         address to,
466         uint256 deadline
467     )
468         external
469         returns (
470             uint256 amountA,
471             uint256 amountB,
472             uint256 liquidity
473         );
474 
475     function addLiquidityETH(
476         address token,
477         uint256 amountTokenDesired,
478         uint256 amountTokenMin,
479         uint256 amountETHMin,
480         address to,
481         uint256 deadline
482     )
483         external
484         payable
485         returns (
486             uint256 amountToken,
487             uint256 amountETH,
488             uint256 liquidity
489         );
490 
491     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
492         uint256 amountIn,
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external;
498 
499     function swapExactETHForTokensSupportingFeeOnTransferTokens(
500         uint256 amountOutMin,
501         address[] calldata path,
502         address to,
503         uint256 deadline
504     ) external payable;
505 
506     function swapExactTokensForETHSupportingFeeOnTransferTokens(
507         uint256 amountIn,
508         uint256 amountOutMin,
509         address[] calldata path,
510         address to,
511         uint256 deadline
512     ) external;
513 }
514 
515 contract ShitEatingClowns is ERC20, Ownable {
516     using SafeMath for uint256;
517 
518     IUniswapV2Router02 public immutable uniswapV2Router;
519     address public immutable uniswapV2Pair;
520     address public constant deadAddress = address(0xdead);
521 
522     bool private swapping;
523 
524     address public marketingWallet;
525 
526     uint256 public maxTransactionAmount;
527     uint256 public swapTokensAtAmount;
528     uint256 public maxWallet;
529 
530     bool public tradingActive = false;
531     bool public swapEnabled = false;
532 
533     uint256 public buyTotalFees;
534     uint256 private buyMarketingFee;
535     uint256 private buyLiquidityFee;
536 
537     uint256 public sellTotalFees;
538     uint256 private sellMarketingFee;
539     uint256 private sellLiquidityFee;
540 
541     uint256 private tokensForMarketing;
542     uint256 private tokensForLiquidity;
543     uint256 private previousFee;
544 
545     mapping(address => bool) private _isExcludedFromFees;
546     mapping(address => bool) private _isExcludedMaxTransactionAmount;
547     mapping(address => bool) private automatedMarketMakerPairs;
548     mapping(address => bool) public bots;
549     mapping (address => uint256) public _buyMap;
550     event UpdateUniswapV2Router(
551         address indexed newAddress,
552         address indexed oldAddress
553     );
554 
555     event ExcludeFromFees(address indexed account, bool isExcluded);
556 
557     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
558 
559     event marketingWalletUpdated(
560         address indexed newWallet,
561         address indexed oldWallet
562     );
563 
564     event SwapAndLiquify(
565         uint256 tokensSwapped,
566         uint256 ethReceived,
567         uint256 tokensIntoLiquidity
568     );
569 
570     constructor() ERC20("Shit Eating Clowns", "SEC") {
571         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
572             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
573         );
574 
575         excludeFromMaxTransaction(address(_uniswapV2Router), true);
576         uniswapV2Router = _uniswapV2Router;
577 
578         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
579             .createPair(address(this), _uniswapV2Router.WETH());
580         excludeFromMaxTransaction(address(uniswapV2Pair), true);
581         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
582 
583         uint256 _buyMarketingFee = 10;
584         uint256 _buyLiquidityFee = 0;
585 
586         uint256 _sellMarketingFee = 10;
587         uint256 _sellLiquidityFee = 0;
588 
589         uint256 totalSupply = 1000000000 * 1e18;
590 
591         maxTransactionAmount = 10000000 * 1e18;
592         maxWallet = 10000000 * 1e18;
593         swapTokensAtAmount = (totalSupply * 1) / 1000;
594 
595         buyMarketingFee = _buyMarketingFee;
596         buyLiquidityFee = _buyLiquidityFee;
597         buyTotalFees = buyMarketingFee + buyLiquidityFee;
598 
599         sellMarketingFee = _sellMarketingFee;
600         sellLiquidityFee = _sellLiquidityFee;
601         sellTotalFees = sellMarketingFee + sellLiquidityFee;
602         previousFee = sellTotalFees;
603 
604         marketingWallet = address(0xEB68d0343De04dD0F849091aF215ca615b4a770a);
605 
606         excludeFromFees(owner(), true);
607         excludeFromFees(address(this), true);
608         excludeFromFees(address(0xdead), true);
609 
610         excludeFromMaxTransaction(owner(), true);
611         excludeFromMaxTransaction(address(this), true);
612         excludeFromMaxTransaction(address(0xdead), true);
613 
614         _mint(msg.sender, totalSupply);
615     }
616 
617     receive() external payable {}
618 
619     function enableTrading() external onlyOwner {
620         tradingActive = true;
621         swapEnabled = true;
622     }
623 
624     function updateSwapTokensAtAmount(uint256 newAmount)
625         external
626         onlyOwner
627         returns (bool)
628     {
629         require(
630             newAmount >= (totalSupply() * 1) / 100000,
631             "Swap amount cannot be lower than 0.001% total supply."
632         );
633         require(
634             newAmount <= (totalSupply() * 5) / 1000,
635             "Swap amount cannot be higher than 0.5% total supply."
636         );
637         swapTokensAtAmount = newAmount;
638         return true;
639     }
640 
641     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
642         require(
643             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
644             "Cannot set maxTxn lower than 0.5%"
645         );
646         require(
647             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
648             "Cannot set maxWallet lower than 0.5%"
649         );
650         maxWallet = newMaxWalletNum * (10**18);
651         maxTransactionAmount = newTxnNum * (10**18);
652     }
653 
654     function blockBots(address[] memory bots_) public onlyOwner {
655         for (uint256 i = 0; i < bots_.length; i++) {
656             bots[bots_[i]] = true;
657         }
658     }
659 
660     function unblockBot(address notbot) public onlyOwner {
661         bots[notbot] = false;
662     }
663 
664     function excludeFromMaxTransaction(address updAds, bool isEx)
665         public
666         onlyOwner
667     {
668         _isExcludedMaxTransactionAmount[updAds] = isEx;
669     }
670 
671     function updateBuyFees(
672         uint256 _marketingFee,
673         uint256 _liquidityFee
674     ) external onlyOwner {
675         buyMarketingFee = _marketingFee;
676         buyLiquidityFee = _liquidityFee;
677         buyTotalFees = buyMarketingFee + buyLiquidityFee;
678         require(buyTotalFees <= 3, "Must keep fees at 3% or less");
679     }
680 
681     function updateSellFees(
682         uint256 _marketingFee,
683         uint256 _liquidityFee
684     ) external onlyOwner {
685         sellMarketingFee = _marketingFee;
686         sellLiquidityFee = _liquidityFee;
687         sellTotalFees = sellMarketingFee + sellLiquidityFee;
688         previousFee = sellTotalFees;
689         require(sellTotalFees <= 3, "Must keep fees at 3% or less");
690     }
691 
692     function excludeFromFees(address account, bool excluded) public onlyOwner {
693         _isExcludedFromFees[account] = excluded;
694         emit ExcludeFromFees(account, excluded);
695     }
696 
697     function setAutomatedMarketMakerPair(address pair, bool value)
698         public
699         onlyOwner
700     {
701         require(
702             pair != uniswapV2Pair,
703             "The pair cannot be removed from automatedMarketMakerPairs"
704         );
705 
706         _setAutomatedMarketMakerPair(pair, value);
707     }
708 
709     function _setAutomatedMarketMakerPair(address pair, bool value) private {
710         automatedMarketMakerPairs[pair] = value;
711 
712         emit SetAutomatedMarketMakerPair(pair, value);
713     }
714 
715     function isExcludedFromFees(address account) public view returns (bool) {
716         return _isExcludedFromFees[account];
717     }
718 
719     function _transfer(
720         address from,
721         address to,
722         uint256 amount
723     ) internal override {
724         require(from != address(0), "ERC20: transfer from the zero address");
725         require(to != address(0), "ERC20: transfer to the zero address");
726 
727         if (amount == 0) {
728             super._transfer(from, to, 0);
729             return;
730         }
731 
732                 if (
733                 from != owner() &&
734                 to != owner() &&
735                 to != address(0) &&
736                 to != address(0xdead) &&
737                 !swapping
738             ) {
739                 if (!tradingActive) {
740                     require(
741                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
742                         "Trading is not active."
743                     );
744                 }
745                 
746                 require(!bots[from] && !bots[to], "Your account is blacklisted!");
747 
748                 //when buy
749                 if (
750                     automatedMarketMakerPairs[from] &&
751                     !_isExcludedMaxTransactionAmount[to]
752                 ) {
753                     require(
754                         amount <= maxTransactionAmount,
755                         "Buy transfer amount exceeds the maxTransactionAmount."
756                     );
757                     require(
758                         amount + balanceOf(to) <= maxWallet,
759                         "Max wallet exceeded"
760                     );
761                 }
762                 //when sell
763                 else if (
764                     automatedMarketMakerPairs[to] &&
765                     !_isExcludedMaxTransactionAmount[from]
766                 ) {
767                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
768                 } 
769                 
770                 else if (!_isExcludedMaxTransactionAmount[to]) {
771                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
772                 }
773             }
774 
775         uint256 contractTokenBalance = balanceOf(address(this));
776 
777         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
778 
779         if (
780             canSwap &&
781             swapEnabled &&
782             !swapping &&
783             !automatedMarketMakerPairs[from] &&
784             !_isExcludedFromFees[from] &&
785             !_isExcludedFromFees[to]
786         ) {
787             swapping = true;
788 
789             swapBack();
790 
791             swapping = false;
792         }
793 
794         bool takeFee = !swapping;
795 
796         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
797             takeFee = false;
798         }
799 
800         uint256 fees = 0;
801 
802         if (takeFee) {
803             // on sell
804             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
805                 fees = amount.mul(sellTotalFees).div(100);
806                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
807                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
808             }
809             // on buy
810             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
811                 fees = amount.mul(buyTotalFees).div(100);
812                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
813                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
814             }
815 
816             if (fees > 0) {
817                 super._transfer(from, address(this), fees);
818             }
819 
820             amount -= fees;
821         }
822 
823         super._transfer(from, to, amount);
824         sellTotalFees = previousFee;
825 
826     }
827 
828     function swapTokensForEth(uint256 tokenAmount) private {
829 
830         address[] memory path = new address[](2);
831         path[0] = address(this);
832         path[1] = uniswapV2Router.WETH();
833 
834         _approve(address(this), address(uniswapV2Router), tokenAmount);
835 
836         // make the swap
837         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
838             tokenAmount,
839             0,
840             path,
841             address(this),
842             block.timestamp
843         );
844     }
845 
846     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
847 
848         _approve(address(this), address(uniswapV2Router), tokenAmount);
849 
850         uniswapV2Router.addLiquidityETH{value: ethAmount}(
851             address(this),
852             tokenAmount,
853             0,
854             0,
855             deadAddress,
856             block.timestamp
857         );
858     }
859 
860     function swapBack() private {
861         uint256 contractBalance = balanceOf(address(this));
862         uint256 totalTokensToSwap = tokensForLiquidity +
863             tokensForMarketing;
864         bool success;
865 
866         if (contractBalance == 0 || totalTokensToSwap == 0) {
867             return;
868         }
869 
870         if (contractBalance > swapTokensAtAmount * 20) {
871             contractBalance = swapTokensAtAmount * 20;
872         }
873 
874         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
875             totalTokensToSwap /
876             2;
877         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
878 
879         uint256 initialETHBalance = address(this).balance;
880 
881         swapTokensForEth(amountToSwapForETH);
882 
883         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
884 
885         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
886             totalTokensToSwap
887         );
888 
889         uint256 ethForLiquidity = ethBalance - ethForMarketing;
890 
891         tokensForLiquidity = 0;
892         tokensForMarketing = 0;
893 
894         if (liquidityTokens > 0 && ethForLiquidity > 0) {
895             addLiquidity(liquidityTokens, ethForLiquidity);
896             emit SwapAndLiquify(
897                 amountToSwapForETH,
898                 ethForLiquidity,
899                 tokensForLiquidity
900             );
901         }
902 
903         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
904     }
905 }