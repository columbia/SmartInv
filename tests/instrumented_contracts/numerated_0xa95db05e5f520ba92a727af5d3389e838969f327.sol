1 /*
2 Vibes
3 http://T.me/VibesEthPortal
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity =0.8.16;
8 pragma experimental ABIEncoderV2;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 abstract contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     modifier onlyOwner() {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35         _;
36     }
37 
38     function renounceOwnership() public virtual onlyOwner { //Change
39         _transferOwnership(address(0));
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 interface IERC20 {
55 
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 interface IERC20Metadata is IERC20 {
73 
74     function name() external view returns (string memory);
75     function symbol() external view returns (string memory);
76     function decimals() external view returns (uint8);
77 }
78 
79 
80 contract ERC20 is Context, IERC20, IERC20Metadata {
81     mapping(address => uint256) private _balances;
82 
83     mapping(address => mapping(address => uint256)) private _allowances;
84 
85     uint256 private _totalSupply;
86 
87     string private _name;
88     string private _symbol;
89 
90     constructor(string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95     function name() public view virtual override returns (string memory) {
96         return _name;
97     }
98 
99     function symbol() public view virtual override returns (string memory) {
100         return _symbol;
101     }
102 
103     function decimals() public view virtual override returns (uint8) {
104         return 18;
105     }
106 
107     function totalSupply() public view virtual override returns (uint256) {
108         return _totalSupply;
109     }
110 
111     function balanceOf(address account) public view virtual override returns (uint256) {
112         return _balances[account];
113     }
114 
115     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119 
120     function allowance(address owner, address spender) public view virtual override returns (uint256) {
121         return _allowances[owner][spender];
122     }
123 
124     function approve(address spender, uint256 amount) public virtual override returns (bool) {
125         _approve(_msgSender(), spender, amount);
126         return true;
127     }
128 
129     function transferFrom(
130         address sender,
131         address recipient,
132         uint256 amount
133     ) public virtual override returns (bool) {
134         _transfer(sender, recipient, amount);
135 
136         uint256 currentAllowance = _allowances[sender][_msgSender()];
137         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
138         unchecked {
139             _approve(sender, _msgSender(), currentAllowance - amount);
140         }
141 
142         return true;
143     }
144 
145     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
146         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
147         return true;
148     }
149 
150     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
151         uint256 currentAllowance = _allowances[_msgSender()][spender];
152         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
153         unchecked {
154             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
155         }
156 
157         return true;
158     }
159 
160     function _transfer(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) internal virtual {
165         require(sender != address(0), "ERC20: transfer from the zero address");
166         require(recipient != address(0), "ERC20: transfer to the zero address");
167 
168         _beforeTokenTransfer(sender, recipient, amount);
169 
170         uint256 senderBalance = _balances[sender];
171         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
172         unchecked {
173             _balances[sender] = senderBalance - amount;
174         }
175         _balances[recipient] += amount;
176 
177         emit Transfer(sender, recipient, amount);
178 
179         _afterTokenTransfer(sender, recipient, amount);
180     }
181 
182     function _mint(address account, uint256 amount) internal virtual {
183         require(account != address(0), "ERC20: mint to the zero address");
184 
185         _beforeTokenTransfer(address(0), account, amount);
186 
187         _totalSupply += amount;
188         _balances[account] += amount;
189         emit Transfer(address(0), account, amount);
190 
191         _afterTokenTransfer(address(0), account, amount);
192     }
193 
194     function _approve(
195         address owner,
196         address spender,
197         uint256 amount
198     ) internal virtual {
199         require(owner != address(0), "ERC20: approve from the zero address");
200         require(spender != address(0), "ERC20: approve to the zero address");
201 
202         _allowances[owner][spender] = amount;
203         emit Approval(owner, spender, amount);
204     }
205 
206     function _beforeTokenTransfer(
207         address from,
208         address to,
209         uint256 amount
210     ) internal virtual {}
211 
212     function _afterTokenTransfer(
213         address from,
214         address to,
215         uint256 amount
216     ) internal virtual {}
217 }
218 
219 library SafeMath {
220 
221     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
222         unchecked {
223             uint256 c = a + b;
224             if (c < a) return (false, 0);
225             return (true, c);
226         }
227     }
228 
229     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
230         unchecked {
231             if (b > a) return (false, 0);
232             return (true, a - b);
233         }
234     }
235 
236     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             if (a == 0) return (true, 0);
239             uint256 c = a * b;
240             if (c / a != b) return (false, 0);
241             return (true, c);
242         }
243     }
244 
245     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             if (b == 0) return (false, 0);
248             return (true, a / b);
249         }
250     }
251 
252     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b == 0) return (false, 0);
255             return (true, a % b);
256         }
257     }
258 
259     function add(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a + b;
261     }
262 
263     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a - b;
265     }
266 
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a * b;
269     }
270 
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a / b;
273     }
274 
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a % b;
277     }
278 
279     function sub(
280         uint256 a,
281         uint256 b,
282         string memory errorMessage
283     ) internal pure returns (uint256) {
284         unchecked {
285             require(b <= a, errorMessage);
286             return a - b;
287         }
288     }
289 
290     function div(
291         uint256 a,
292         uint256 b,
293         string memory errorMessage
294     ) internal pure returns (uint256) {
295         unchecked {
296             require(b > 0, errorMessage);
297             return a / b;
298         }
299     }
300 
301     function mod(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b > 0, errorMessage);
308             return a % b;
309         }
310     }
311 }
312 
313 interface IUniswapV2Factory {
314     event PairCreated(
315         address indexed token0,
316         address indexed token1,
317         address pair,
318         uint256
319     );
320 
321     function feeTo() external view returns (address);
322 
323     function feeToSetter() external view returns (address);
324 
325     function getPair(address tokenA, address tokenB)
326         external
327         view
328         returns (address pair);
329 
330     function allPairs(uint256) external view returns (address pair);
331 
332     function allPairsLength() external view returns (uint256);
333 
334     function createPair(address tokenA, address tokenB)
335         external
336         returns (address pair);
337 
338     function setFeeTo(address) external;
339 
340     function setFeeToSetter(address) external;
341 }
342 
343 interface IUniswapV2Pair {
344     event Approval(
345         address indexed owner,
346         address indexed spender,
347         uint256 value
348     );
349     event Transfer(address indexed from, address indexed to, uint256 value);
350 
351     function name() external pure returns (string memory);
352 
353     function symbol() external pure returns (string memory);
354 
355     function decimals() external pure returns (uint8);
356 
357     function totalSupply() external view returns (uint256);
358 
359     function balanceOf(address owner) external view returns (uint256);
360 
361     function allowance(address owner, address spender)
362         external
363         view
364         returns (uint256);
365 
366     function approve(address spender, uint256 value) external returns (bool);
367 
368     function transfer(address to, uint256 value) external returns (bool);
369 
370     function transferFrom(
371         address from,
372         address to,
373         uint256 value
374     ) external returns (bool);
375 
376     function DOMAIN_SEPARATOR() external view returns (bytes32);
377 
378     function PERMIT_TYPEHASH() external pure returns (bytes32);
379 
380     function nonces(address owner) external view returns (uint256);
381 
382     function permit(
383         address owner,
384         address spender,
385         uint256 value,
386         uint256 deadline,
387         uint8 v,
388         bytes32 r,
389         bytes32 s
390     ) external;
391 
392     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
393 
394     event Swap(
395         address indexed sender,
396         uint256 amount0In,
397         uint256 amount1In,
398         uint256 amount0Out,
399         uint256 amount1Out,
400         address indexed to
401     );
402     event Sync(uint112 reserve0, uint112 reserve1);
403 
404     function MINIMUM_LIQUIDITY() external pure returns (uint256);
405 
406     function factory() external view returns (address);
407 
408     function token0() external view returns (address);
409 
410     function token1() external view returns (address);
411 
412     function getReserves()
413         external
414         view
415         returns (
416             uint112 reserve0,
417             uint112 reserve1,
418             uint32 blockTimestampLast
419         );
420 
421     function price0CumulativeLast() external view returns (uint256);
422 
423     function price1CumulativeLast() external view returns (uint256);
424 
425     function kLast() external view returns (uint256);
426 
427     function mint(address to) external returns (uint256 liquidity);
428 
429     function swap(
430         uint256 amount0Out,
431         uint256 amount1Out,
432         address to,
433         bytes calldata data
434     ) external;
435 
436     function skim(address to) external;
437 
438     function sync() external;
439 
440     function initialize(address, address) external;
441 }
442 
443 interface IUniswapV2Router02 {
444     function factory() external pure returns (address);
445 
446     function WETH() external pure returns (address);
447 
448     function addLiquidity(
449         address tokenA,
450         address tokenB,
451         uint256 amountADesired,
452         uint256 amountBDesired,
453         uint256 amountAMin,
454         uint256 amountBMin,
455         address to,
456         uint256 deadline
457     )
458         external
459         returns (
460             uint256 amountA,
461             uint256 amountB,
462             uint256 liquidity
463         );
464 
465     function addLiquidityETH(
466         address token,
467         uint256 amountTokenDesired,
468         uint256 amountTokenMin,
469         uint256 amountETHMin,
470         address to,
471         uint256 deadline
472     )
473         external
474         payable
475         returns (
476             uint256 amountToken,
477             uint256 amountETH,
478             uint256 liquidity
479         );
480 
481     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
482         uint256 amountIn,
483         uint256 amountOutMin,
484         address[] calldata path,
485         address to,
486         uint256 deadline
487     ) external;
488 
489     function swapExactETHForTokensSupportingFeeOnTransferTokens(
490         uint256 amountOutMin,
491         address[] calldata path,
492         address to,
493         uint256 deadline
494     ) external payable;
495 
496     function swapExactTokensForETHSupportingFeeOnTransferTokens(
497         uint256 amountIn,
498         uint256 amountOutMin,
499         address[] calldata path,
500         address to,
501         uint256 deadline
502     ) external;
503 }
504 
505 contract Vibes is ERC20, Ownable {
506     using SafeMath for uint256;
507 
508     IUniswapV2Router02 public immutable uniswapV2Router;
509     address public immutable uniswapV2Pair;
510     address public constant deadAddress = address(0xdead);
511 
512     bool private swapping;
513 
514     address public marketingWallet;
515 
516     uint256 public maxTransactionAmount;
517     uint256 public swapTokensAtAmount;
518     uint256 public maxWallet;
519 
520     bool public tradingActive = false;
521     bool public swapEnabled = false;
522 
523     uint256 public buyTotalFees;
524     uint256 private buyMarketingFee;
525     uint256 private buyLiquidityFee;
526 
527     uint256 public sellTotalFees;
528     uint256 private sellMarketingFee;
529     uint256 private sellLiquidityFee;
530 
531     uint256 private tokensForMarketing;
532     uint256 private tokensForLiquidity;
533     uint256 private previousFee;
534 
535     mapping(address => bool) private _isExcludedFromFees;
536     mapping(address => bool) private _isExcludedMaxTransactionAmount;
537     mapping(address => bool) private automatedMarketMakerPairs;
538 
539     event UpdateUniswapV2Router(
540         address indexed newAddress,
541         address indexed oldAddress
542     );
543 
544     event ExcludeFromFees(address indexed account, bool isExcluded);
545 
546     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
547 
548     event marketingWalletUpdated(
549         address indexed newWallet,
550         address indexed oldWallet
551     );
552 
553     event SwapAndLiquify(
554         uint256 tokensSwapped,
555         uint256 ethReceived,
556         uint256 tokensIntoLiquidity
557     );
558 
559     constructor() ERC20("Vibes", "VIBES") {
560         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
561             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
562         );
563 
564         excludeFromMaxTransaction(address(_uniswapV2Router), true);
565         uniswapV2Router = _uniswapV2Router;
566 
567         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
568             .createPair(address(this), _uniswapV2Router.WETH());
569         excludeFromMaxTransaction(address(uniswapV2Pair), true);
570         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
571 
572         uint256 _buyMarketingFee = 5;
573         uint256 _buyLiquidityFee = 0;
574 
575         uint256 _sellMarketingFee = 5;
576         uint256 _sellLiquidityFee = 0;
577 
578         uint256 totalSupply = 1000000000 * 1e18;
579 
580         maxTransactionAmount = 30000000 * 1e18;
581         maxWallet = 30000000 * 1e18;
582         swapTokensAtAmount = (totalSupply * 5) / 10000;
583 
584         buyMarketingFee = _buyMarketingFee;
585         buyLiquidityFee = _buyLiquidityFee;
586         buyTotalFees = buyMarketingFee + buyLiquidityFee;
587 
588         sellMarketingFee = _sellMarketingFee;
589         sellLiquidityFee = _sellLiquidityFee;
590         sellTotalFees = sellMarketingFee + sellLiquidityFee;
591         previousFee = sellTotalFees;
592 
593         marketingWallet = address(0x5762909ea4adD5efF90B1833dcBC28296ffbd3E6);
594 
595         excludeFromFees(owner(), true);
596         excludeFromFees(address(this), true);
597         excludeFromFees(address(0xdead), true);
598 
599         excludeFromMaxTransaction(owner(), true);
600         excludeFromMaxTransaction(address(this), true);
601         excludeFromMaxTransaction(address(0xdead), true);
602 
603         _mint(msg.sender, totalSupply);
604     }
605 
606     receive() external payable {}
607 
608     function enableTrading() external onlyOwner {
609         tradingActive = true;
610         swapEnabled = true;
611     }
612 
613     function updateSwapTokensAtAmount(uint256 newAmount)
614         external
615         onlyOwner
616         returns (bool)
617     {
618         require(
619             newAmount >= (totalSupply() * 1) / 100000,
620             "Swap amount cannot be lower than 0.001% total supply."
621         );
622         require(
623             newAmount <= (totalSupply() * 5) / 1000,
624             "Swap amount cannot be higher than 0.5% total supply."
625         );
626         swapTokensAtAmount = newAmount;
627         return true;
628     }
629 
630     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
631         require(
632             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
633             "Cannot set maxTxn lower than 0.5%"
634         );
635         require(
636             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
637             "Cannot set maxWallet lower than 0.5%"
638         );
639         maxWallet = newMaxWalletNum * (10**18);
640         maxTransactionAmount = newTxnNum * (10**18);
641     }
642 
643     function excludeFromMaxTransaction(address updAds, bool isEx)
644         public
645         onlyOwner
646     {
647         _isExcludedMaxTransactionAmount[updAds] = isEx;
648     }
649 
650     function updateBuyFees(
651         uint256 _marketingFee,
652         uint256 _liquidityFee
653     ) external onlyOwner {
654         buyMarketingFee = _marketingFee;
655         buyLiquidityFee = _liquidityFee;
656         buyTotalFees = buyMarketingFee + buyLiquidityFee;
657         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
658     }
659 
660     function updateSellFees(
661         uint256 _marketingFee,
662         uint256 _liquidityFee
663     ) external onlyOwner {
664         sellMarketingFee = _marketingFee;
665         sellLiquidityFee = _liquidityFee;
666         sellTotalFees = sellMarketingFee + sellLiquidityFee;
667         previousFee = sellTotalFees;
668         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
669     }
670 
671     function excludeFromFees(address account, bool excluded) public onlyOwner {
672         _isExcludedFromFees[account] = excluded;
673         emit ExcludeFromFees(account, excluded);
674     }
675 
676     function setAutomatedMarketMakerPair(address pair, bool value)
677         public
678         onlyOwner
679     {
680         require(
681             pair != uniswapV2Pair,
682             "The pair cannot be removed from automatedMarketMakerPairs"
683         );
684 
685         _setAutomatedMarketMakerPair(pair, value);
686     }
687 
688     function _setAutomatedMarketMakerPair(address pair, bool value) private {
689         automatedMarketMakerPairs[pair] = value;
690 
691         emit SetAutomatedMarketMakerPair(pair, value);
692     }
693 
694     function isExcludedFromFees(address account) public view returns (bool) {
695         return _isExcludedFromFees[account];
696     }
697 
698     function _transfer(
699         address from,
700         address to,
701         uint256 amount
702     ) internal override {
703         require(from != address(0), "ERC20: transfer from the zero address");
704         require(to != address(0), "ERC20: transfer to the zero address");
705 
706         if (amount == 0) {
707             super._transfer(from, to, 0);
708             return;
709         }
710 
711                 if (
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
748                 } 
749                 
750                 else if (!_isExcludedMaxTransactionAmount[to]) {
751                     require(
752                         amount + balanceOf(to) <= maxWallet,
753                         "Max wallet exceeded"
754                     );
755                 }
756             }
757 
758         uint256 contractTokenBalance = balanceOf(address(this));
759 
760         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
761 
762         if (
763             canSwap &&
764             swapEnabled &&
765             !swapping &&
766             !automatedMarketMakerPairs[from] &&
767             !_isExcludedFromFees[from] &&
768             !_isExcludedFromFees[to]
769         ) {
770             swapping = true;
771 
772             swapBack();
773 
774             swapping = false;
775         }
776 
777         bool takeFee = !swapping;
778 
779         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
780             takeFee = false;
781         }
782 
783         uint256 fees = 0;
784 
785         if (takeFee) {
786             // on sell
787             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
788                 fees = amount.mul(sellTotalFees).div(100);
789                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
790                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
791             }
792             // on buy
793             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
794                 fees = amount.mul(buyTotalFees).div(100);
795                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
796                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
797             }
798 
799             if (fees > 0) {
800                 super._transfer(from, address(this), fees);
801             }
802 
803             amount -= fees;
804         }
805 
806         super._transfer(from, to, amount);
807         sellTotalFees = previousFee;
808 
809     }
810 
811     function swapTokensForEth(uint256 tokenAmount) private {
812 
813         address[] memory path = new address[](2);
814         path[0] = address(this);
815         path[1] = uniswapV2Router.WETH();
816 
817         _approve(address(this), address(uniswapV2Router), tokenAmount);
818 
819         // make the swap
820         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
821             tokenAmount,
822             0,
823             path,
824             address(this),
825             block.timestamp
826         );
827     }
828 
829     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
830 
831         _approve(address(this), address(uniswapV2Router), tokenAmount);
832 
833         uniswapV2Router.addLiquidityETH{value: ethAmount}(
834             address(this),
835             tokenAmount,
836             0,
837             0,
838             deadAddress,
839             block.timestamp
840         );
841     }
842 
843     function swapBack() private {
844         uint256 contractBalance = balanceOf(address(this));
845         uint256 totalTokensToSwap = tokensForLiquidity +
846             tokensForMarketing;
847         bool success;
848 
849         if (contractBalance == 0 || totalTokensToSwap == 0) {
850             return;
851         }
852 
853         if (contractBalance > swapTokensAtAmount * 20) {
854             contractBalance = swapTokensAtAmount * 20;
855         }
856 
857         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
858             totalTokensToSwap /
859             2;
860         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
861 
862         uint256 initialETHBalance = address(this).balance;
863 
864         swapTokensForEth(amountToSwapForETH);
865 
866         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
867 
868         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
869             totalTokensToSwap
870         );
871 
872         uint256 ethForLiquidity = ethBalance - ethForMarketing;
873 
874         tokensForLiquidity = 0;
875         tokensForMarketing = 0;
876 
877         if (liquidityTokens > 0 && ethForLiquidity > 0) {
878             addLiquidity(liquidityTokens, ethForLiquidity);
879             emit SwapAndLiquify(
880                 amountToSwapForETH,
881                 ethForLiquidity,
882                 tokensForLiquidity
883             );
884         }
885 
886         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
887     }
888 }