1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.16;
4 pragma experimental ABIEncoderV2;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29     modifier onlyOwner() {
30         require(owner() == _msgSender(), "Ownable: caller is not the owner");
31         _;
32     }
33 
34     function renounceOwnership() public virtual onlyOwner { //Change
35         _transferOwnership(address(0));
36     }
37 
38     function transferOwnership(address newOwner) public virtual onlyOwner {
39         require(newOwner != address(0), "Ownable: new owner is the zero address");
40         _transferOwnership(newOwner);
41     }
42 
43     function _transferOwnership(address newOwner) internal virtual {
44         address oldOwner = _owner;
45         _owner = newOwner;
46         emit OwnershipTransferred(oldOwner, newOwner);
47     }
48 }
49 
50 interface IERC20 {
51 
52     function totalSupply() external view returns (uint256);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 interface IERC20Metadata is IERC20 {
69 
70     function name() external view returns (string memory);
71     function symbol() external view returns (string memory);
72     function decimals() external view returns (uint8);
73 }
74 
75 
76 contract ERC20 is Context, IERC20, IERC20Metadata {
77     mapping(address => uint256) private _balances;
78 
79     mapping(address => mapping(address => uint256)) private _allowances;
80 
81     uint256 private _totalSupply;
82 
83     string private _name;
84     string private _symbol;
85 
86     constructor(string memory name_, string memory symbol_) {
87         _name = name_;
88         _symbol = symbol_;
89     }
90 
91     function name() public view virtual override returns (string memory) {
92         return _name;
93     }
94 
95     function symbol() public view virtual override returns (string memory) {
96         return _symbol;
97     }
98 
99     function decimals() public view virtual override returns (uint8) {
100         return 18;
101     }
102 
103     function totalSupply() public view virtual override returns (uint256) {
104         return _totalSupply;
105     }
106 
107     function balanceOf(address account) public view virtual override returns (uint256) {
108         return _balances[account];
109     }
110 
111     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
112         _transfer(_msgSender(), recipient, amount);
113         return true;
114     }
115 
116     function allowance(address owner, address spender) public view virtual override returns (uint256) {
117         return _allowances[owner][spender];
118     }
119 
120     function approve(address spender, uint256 amount) public virtual override returns (bool) {
121         _approve(_msgSender(), spender, amount);
122         return true;
123     }
124 
125     function transferFrom(
126         address sender,
127         address recipient,
128         uint256 amount
129     ) public virtual override returns (bool) {
130         _transfer(sender, recipient, amount);
131 
132         uint256 currentAllowance = _allowances[sender][_msgSender()];
133         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
134         unchecked {
135             _approve(sender, _msgSender(), currentAllowance - amount);
136         }
137 
138         return true;
139     }
140 
141     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
142         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
143         return true;
144     }
145 
146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
147         uint256 currentAllowance = _allowances[_msgSender()][spender];
148         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
149         unchecked {
150             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
151         }
152 
153         return true;
154     }
155 
156     function _transfer(
157         address sender,
158         address recipient,
159         uint256 amount
160     ) internal virtual {
161         require(sender != address(0), "ERC20: transfer from the zero address");
162         require(recipient != address(0), "ERC20: transfer to the zero address");
163 
164         _beforeTokenTransfer(sender, recipient, amount);
165 
166         uint256 senderBalance = _balances[sender];
167         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
168         unchecked {
169             _balances[sender] = senderBalance - amount;
170         }
171         _balances[recipient] += amount;
172 
173         emit Transfer(sender, recipient, amount);
174 
175         _afterTokenTransfer(sender, recipient, amount);
176     }
177 
178     function _mint(address account, uint256 amount) internal virtual {
179         require(account != address(0), "ERC20: mint to the zero address");
180 
181         _beforeTokenTransfer(address(0), account, amount);
182 
183         _totalSupply += amount;
184         _balances[account] += amount;
185         emit Transfer(address(0), account, amount);
186 
187         _afterTokenTransfer(address(0), account, amount);
188     }
189 
190     function _approve(
191         address owner,
192         address spender,
193         uint256 amount
194     ) internal virtual {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197 
198         _allowances[owner][spender] = amount;
199         emit Approval(owner, spender, amount);
200     }
201 
202     function _beforeTokenTransfer(
203         address from,
204         address to,
205         uint256 amount
206     ) internal virtual {}
207 
208     function _afterTokenTransfer(
209         address from,
210         address to,
211         uint256 amount
212     ) internal virtual {}
213 }
214 
215 library SafeMath {
216 
217     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
218         unchecked {
219             uint256 c = a + b;
220             if (c < a) return (false, 0);
221             return (true, c);
222         }
223     }
224 
225     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
226         unchecked {
227             if (b > a) return (false, 0);
228             return (true, a - b);
229         }
230     }
231 
232     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         unchecked {
234             if (a == 0) return (true, 0);
235             uint256 c = a * b;
236             if (c / a != b) return (false, 0);
237             return (true, c);
238         }
239     }
240 
241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         unchecked {
243             if (b == 0) return (false, 0);
244             return (true, a / b);
245         }
246     }
247 
248     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             if (b == 0) return (false, 0);
251             return (true, a % b);
252         }
253     }
254 
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a + b;
257     }
258 
259     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a - b;
261     }
262 
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a * b;
265     }
266 
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a / b;
269     }
270 
271     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a % b;
273     }
274 
275     function sub(
276         uint256 a,
277         uint256 b,
278         string memory errorMessage
279     ) internal pure returns (uint256) {
280         unchecked {
281             require(b <= a, errorMessage);
282             return a - b;
283         }
284     }
285 
286     function div(
287         uint256 a,
288         uint256 b,
289         string memory errorMessage
290     ) internal pure returns (uint256) {
291         unchecked {
292             require(b > 0, errorMessage);
293             return a / b;
294         }
295     }
296 
297     function mod(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b > 0, errorMessage);
304             return a % b;
305         }
306     }
307 }
308 
309 interface IUniswapV2Factory {
310     event PairCreated(
311         address indexed token0,
312         address indexed token1,
313         address pair,
314         uint256
315     );
316 
317     function feeTo() external view returns (address);
318 
319     function feeToSetter() external view returns (address);
320 
321     function getPair(address tokenA, address tokenB)
322         external
323         view
324         returns (address pair);
325 
326     function allPairs(uint256) external view returns (address pair);
327 
328     function allPairsLength() external view returns (uint256);
329 
330     function createPair(address tokenA, address tokenB)
331         external
332         returns (address pair);
333 
334     function setFeeTo(address) external;
335 
336     function setFeeToSetter(address) external;
337 }
338 
339 interface IUniswapV2Pair {
340     event Approval(
341         address indexed owner,
342         address indexed spender,
343         uint256 value
344     );
345     event Transfer(address indexed from, address indexed to, uint256 value);
346 
347     function name() external pure returns (string memory);
348 
349     function symbol() external pure returns (string memory);
350 
351     function decimals() external pure returns (uint8);
352 
353     function totalSupply() external view returns (uint256);
354 
355     function balanceOf(address owner) external view returns (uint256);
356 
357     function allowance(address owner, address spender)
358         external
359         view
360         returns (uint256);
361 
362     function approve(address spender, uint256 value) external returns (bool);
363 
364     function transfer(address to, uint256 value) external returns (bool);
365 
366     function transferFrom(
367         address from,
368         address to,
369         uint256 value
370     ) external returns (bool);
371 
372     function DOMAIN_SEPARATOR() external view returns (bytes32);
373 
374     function PERMIT_TYPEHASH() external pure returns (bytes32);
375 
376     function nonces(address owner) external view returns (uint256);
377 
378     function permit(
379         address owner,
380         address spender,
381         uint256 value,
382         uint256 deadline,
383         uint8 v,
384         bytes32 r,
385         bytes32 s
386     ) external;
387 
388     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
389 
390     event Swap(
391         address indexed sender,
392         uint256 amount0In,
393         uint256 amount1In,
394         uint256 amount0Out,
395         uint256 amount1Out,
396         address indexed to
397     );
398     event Sync(uint112 reserve0, uint112 reserve1);
399 
400     function MINIMUM_LIQUIDITY() external pure returns (uint256);
401 
402     function factory() external view returns (address);
403 
404     function token0() external view returns (address);
405 
406     function token1() external view returns (address);
407 
408     function getReserves()
409         external
410         view
411         returns (
412             uint112 reserve0,
413             uint112 reserve1,
414             uint32 blockTimestampLast
415         );
416 
417     function price0CumulativeLast() external view returns (uint256);
418 
419     function price1CumulativeLast() external view returns (uint256);
420 
421     function kLast() external view returns (uint256);
422 
423     function mint(address to) external returns (uint256 liquidity);
424 
425     function swap(
426         uint256 amount0Out,
427         uint256 amount1Out,
428         address to,
429         bytes calldata data
430     ) external;
431 
432     function skim(address to) external;
433 
434     function sync() external;
435 
436     function initialize(address, address) external;
437 }
438 
439 interface IUniswapV2Router02 {
440     function factory() external pure returns (address);
441 
442     function WETH() external pure returns (address);
443 
444     function addLiquidity(
445         address tokenA,
446         address tokenB,
447         uint256 amountADesired,
448         uint256 amountBDesired,
449         uint256 amountAMin,
450         uint256 amountBMin,
451         address to,
452         uint256 deadline
453     )
454         external
455         returns (
456             uint256 amountA,
457             uint256 amountB,
458             uint256 liquidity
459         );
460 
461     function addLiquidityETH(
462         address token,
463         uint256 amountTokenDesired,
464         uint256 amountTokenMin,
465         uint256 amountETHMin,
466         address to,
467         uint256 deadline
468     )
469         external
470         payable
471         returns (
472             uint256 amountToken,
473             uint256 amountETH,
474             uint256 liquidity
475         );
476 
477     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
478         uint256 amountIn,
479         uint256 amountOutMin,
480         address[] calldata path,
481         address to,
482         uint256 deadline
483     ) external;
484 
485     function swapExactETHForTokensSupportingFeeOnTransferTokens(
486         uint256 amountOutMin,
487         address[] calldata path,
488         address to,
489         uint256 deadline
490     ) external payable;
491 
492     function swapExactTokensForETHSupportingFeeOnTransferTokens(
493         uint256 amountIn,
494         uint256 amountOutMin,
495         address[] calldata path,
496         address to,
497         uint256 deadline
498     ) external;
499 }
500 
501 contract TROLLFACE is ERC20, Ownable {
502     using SafeMath for uint256;
503 
504     IUniswapV2Router02 public immutable uniswapV2Router;
505     address public immutable uniswapV2Pair;
506     address public constant deadAddress = address(0xdead);
507 
508     bool private swapping;
509 
510     address public marketingWallet;
511 
512     uint256 public maxTransactionAmount;
513     uint256 public swapTokensAtAmount;
514     uint256 public maxWallet;
515 
516     bool public tradingActive = false;
517     bool public swapEnabled = false;
518 
519     uint256 public buyTotalFees;
520     uint256 private buyMarketingFee;
521     uint256 private buyLiquidityFee;
522 
523     uint256 public sellTotalFees;
524     uint256 private sellMarketingFee;
525     uint256 private sellLiquidityFee;
526 
527     uint256 private tokensForMarketing;
528     uint256 private tokensForLiquidity;
529     uint256 private previousFee;
530 
531     mapping(address => bool) private _isExcludedFromFees;
532     mapping(address => bool) private _isExcludedMaxTransactionAmount;
533     mapping(address => bool) private automatedMarketMakerPairs;
534 
535     event UpdateUniswapV2Router(
536         address indexed newAddress,
537         address indexed oldAddress
538     );
539 
540     event ExcludeFromFees(address indexed account, bool isExcluded);
541 
542     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
543 
544     event marketingWalletUpdated(
545         address indexed newWallet,
546         address indexed oldWallet
547     );
548 
549     event SwapAndLiquify(
550         uint256 tokensSwapped,
551         uint256 ethReceived,
552         uint256 tokensIntoLiquidity
553     );
554 
555     constructor() ERC20("TROLL", "TROLL") {
556         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
557             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
558         );
559 
560         excludeFromMaxTransaction(address(_uniswapV2Router), true);
561         uniswapV2Router = _uniswapV2Router;
562 
563         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
564             .createPair(address(this), _uniswapV2Router.WETH());
565         excludeFromMaxTransaction(address(uniswapV2Pair), true);
566         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
567 
568         uint256 _buyMarketingFee = 5;
569         uint256 _buyLiquidityFee = 0;
570 
571         uint256 _sellMarketingFee = 15;
572         uint256 _sellLiquidityFee = 0;
573 
574         uint256 totalSupply = 960420000000000 * 1e18;
575 
576         maxTransactionAmount = 9604200000000 * 1e18;
577         maxWallet = 9604200000000 * 1e18;
578         swapTokensAtAmount = (totalSupply * 5) / 10000;
579 
580         buyMarketingFee = _buyMarketingFee;
581         buyLiquidityFee = _buyLiquidityFee;
582         buyTotalFees = buyMarketingFee + buyLiquidityFee;
583 
584         sellMarketingFee = _sellMarketingFee;
585         sellLiquidityFee = _sellLiquidityFee;
586         sellTotalFees = sellMarketingFee + sellLiquidityFee;
587         previousFee = sellTotalFees;
588 
589         marketingWallet = address(0xBE1b4370Bc8d620128d985867DaDd1a8a55D3205);
590 
591         excludeFromFees(owner(), true);
592         excludeFromFees(address(this), true);
593         excludeFromFees(address(0xdead), true);
594 
595         excludeFromMaxTransaction(owner(), true);
596         excludeFromMaxTransaction(address(this), true);
597         excludeFromMaxTransaction(address(0xdead), true);
598 
599         _mint(msg.sender, totalSupply);
600     }
601 
602     receive() external payable {}
603 
604     function enableTrading() external onlyOwner {
605         tradingActive = true;
606         swapEnabled = true;
607     }
608 
609     function updateSwapTokensAtAmount(uint256 newAmount)
610         external
611         onlyOwner
612         returns (bool)
613     {
614         require(
615             newAmount >= (totalSupply() * 1) / 100000,
616             "Swap amount cannot be lower than 0.001% total supply."
617         );
618         require(
619             newAmount <= (totalSupply() * 5) / 1000,
620             "Swap amount cannot be higher than 0.5% total supply."
621         );
622         swapTokensAtAmount = newAmount;
623         return true;
624     }
625 
626     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
627         require(
628             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
629             "Cannot set maxTxn lower than 0.5%"
630         );
631         require(
632             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
633             "Cannot set maxWallet lower than 0.5%"
634         );
635         maxWallet = newMaxWalletNum * (10**18);
636         maxTransactionAmount = newTxnNum * (10**18);
637     }
638 
639     function excludeFromMaxTransaction(address updAds, bool isEx)
640         public
641         onlyOwner
642     {
643         _isExcludedMaxTransactionAmount[updAds] = isEx;
644     }
645 
646     function updateBuyFees(
647         uint256 _marketingFee,
648         uint256 _liquidityFee
649     ) external onlyOwner {
650         buyMarketingFee = _marketingFee;
651         buyLiquidityFee = _liquidityFee;
652         buyTotalFees = buyMarketingFee + buyLiquidityFee;
653         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
654     }
655 
656     function updateSellFees(
657         uint256 _marketingFee,
658         uint256 _liquidityFee
659     ) external onlyOwner {
660         sellMarketingFee = _marketingFee;
661         sellLiquidityFee = _liquidityFee;
662         sellTotalFees = sellMarketingFee + sellLiquidityFee;
663         previousFee = sellTotalFees;
664         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
665     }
666 
667     function excludeFromFees(address account, bool excluded) public onlyOwner {
668         _isExcludedFromFees[account] = excluded;
669         emit ExcludeFromFees(account, excluded);
670     }
671 
672     function setAutomatedMarketMakerPair(address pair, bool value)
673         public
674         onlyOwner
675     {
676         require(
677             pair != uniswapV2Pair,
678             "The pair cannot be removed from automatedMarketMakerPairs"
679         );
680 
681         _setAutomatedMarketMakerPair(pair, value);
682     }
683 
684     function _setAutomatedMarketMakerPair(address pair, bool value) private {
685         automatedMarketMakerPairs[pair] = value;
686 
687         emit SetAutomatedMarketMakerPair(pair, value);
688     }
689 
690     function isExcludedFromFees(address account) public view returns (bool) {
691         return _isExcludedFromFees[account];
692     }
693 
694     function _transfer(
695         address from,
696         address to,
697         uint256 amount
698     ) internal override {
699         require(from != address(0), "ERC20: transfer from the zero address");
700         require(to != address(0), "ERC20: transfer to the zero address");
701 
702         if (amount == 0) {
703             super._transfer(from, to, 0);
704             return;
705         }
706 
707                 if (
708                 from != owner() &&
709                 to != owner() &&
710                 to != address(0) &&
711                 to != address(0xdead) &&
712                 !swapping
713             ) {
714                 if (!tradingActive) {
715                     require(
716                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
717                         "Trading is not active."
718                     );
719                 }
720 
721                 //when buy
722                 if (
723                     automatedMarketMakerPairs[from] &&
724                     !_isExcludedMaxTransactionAmount[to]
725                 ) {
726                     require(
727                         amount <= maxTransactionAmount,
728                         "Buy transfer amount exceeds the maxTransactionAmount."
729                     );
730                     require(
731                         amount + balanceOf(to) <= maxWallet,
732                         "Max wallet exceeded"
733                     );
734                 }
735                 //when sell
736                 else if (
737                     automatedMarketMakerPairs[to] &&
738                     !_isExcludedMaxTransactionAmount[from]
739                 ) {
740                     require(
741                         amount <= maxTransactionAmount,
742                         "Sell transfer amount exceeds the maxTransactionAmount."
743                     );
744                 } 
745                 
746                 else if (!_isExcludedMaxTransactionAmount[to]) {
747                     require(
748                         amount + balanceOf(to) <= maxWallet,
749                         "Max wallet exceeded"
750                     );
751                 }
752             }
753 
754         uint256 contractTokenBalance = balanceOf(address(this));
755 
756         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
757 
758         if (
759             canSwap &&
760             swapEnabled &&
761             !swapping &&
762             !automatedMarketMakerPairs[from] &&
763             !_isExcludedFromFees[from] &&
764             !_isExcludedFromFees[to]
765         ) {
766             swapping = true;
767 
768             swapBack();
769 
770             swapping = false;
771         }
772 
773         bool takeFee = !swapping;
774 
775         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
776             takeFee = false;
777         }
778 
779         uint256 fees = 0;
780 
781         if (takeFee) {
782             // on sell
783             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
784                 fees = amount.mul(sellTotalFees).div(100);
785                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
786                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
787             }
788             // on buy
789             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
790                 fees = amount.mul(buyTotalFees).div(100);
791                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
792                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
793             }
794 
795             if (fees > 0) {
796                 super._transfer(from, address(this), fees);
797             }
798 
799             amount -= fees;
800         }
801 
802         super._transfer(from, to, amount);
803         sellTotalFees = previousFee;
804 
805     }
806 
807     function swapTokensForEth(uint256 tokenAmount) private {
808 
809         address[] memory path = new address[](2);
810         path[0] = address(this);
811         path[1] = uniswapV2Router.WETH();
812 
813         _approve(address(this), address(uniswapV2Router), tokenAmount);
814 
815         // make the swap
816         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
817             tokenAmount,
818             0,
819             path,
820             address(this),
821             block.timestamp
822         );
823     }
824 
825     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
826 
827         _approve(address(this), address(uniswapV2Router), tokenAmount);
828 
829         uniswapV2Router.addLiquidityETH{value: ethAmount}(
830             address(this),
831             tokenAmount,
832             0,
833             0,
834             deadAddress,
835             block.timestamp
836         );
837     }
838 
839     function swapBack() private {
840         uint256 contractBalance = balanceOf(address(this));
841         uint256 totalTokensToSwap = tokensForLiquidity +
842             tokensForMarketing;
843         bool success;
844 
845         if (contractBalance == 0 || totalTokensToSwap == 0) {
846             return;
847         }
848 
849         if (contractBalance > swapTokensAtAmount * 20) {
850             contractBalance = swapTokensAtAmount * 20;
851         }
852 
853         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
854             totalTokensToSwap /
855             2;
856         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
857 
858         uint256 initialETHBalance = address(this).balance;
859 
860         swapTokensForEth(amountToSwapForETH);
861 
862         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
863 
864         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
865             totalTokensToSwap
866         );
867 
868         uint256 ethForLiquidity = ethBalance - ethForMarketing;
869 
870         tokensForLiquidity = 0;
871         tokensForMarketing = 0;
872 
873         if (liquidityTokens > 0 && ethForLiquidity > 0) {
874             addLiquidity(liquidityTokens, ethForLiquidity);
875             emit SwapAndLiquify(
876                 amountToSwapForETH,
877                 ethForLiquidity,
878                 tokensForLiquidity
879             );
880         }
881 
882         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
883     }
884 }