1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.20;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
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
57 
58     function balanceOf(address account) external view returns (uint256);
59 
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 interface IERC20Metadata is IERC20 {
78 
79     function name() external view returns (string memory);
80 
81     function symbol() external view returns (string memory);
82 
83     function decimals() external view returns (uint8);
84 }
85 
86 contract ERC20 is Context, IERC20, IERC20Metadata {
87     mapping(address => uint256) private _balances;
88 
89     mapping(address => mapping(address => uint256)) private _allowances;
90 
91     uint256 private _totalSupply;
92 
93     string private _name;
94     string private _symbol;
95 
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101 
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view virtual override returns (uint8) {
111         return 18;
112     }
113 
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view virtual override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) public virtual override returns (bool) {
141         _transfer(sender, recipient, amount);
142 
143         uint256 currentAllowance = _allowances[sender][_msgSender()];
144         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
145         unchecked {
146             _approve(sender, _msgSender(), currentAllowance - amount);
147         }
148 
149         return true;
150     }
151 
152     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
153         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
154         return true;
155     }
156 
157     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
158         uint256 currentAllowance = _allowances[_msgSender()][spender];
159         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
160         unchecked {
161             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
162         }
163 
164         return true;
165     }
166 
167     function _transfer(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) internal virtual {
172         require(sender != address(0), "ERC20: transfer from the zero address");
173         require(recipient != address(0), "ERC20: transfer to the zero address");
174 
175         _beforeTokenTransfer(sender, recipient, amount);
176 
177         uint256 senderBalance = _balances[sender];
178         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
179         unchecked {
180             _balances[sender] = senderBalance - amount;
181         }
182         _balances[recipient] += amount;
183 
184         emit Transfer(sender, recipient, amount);
185 
186         _afterTokenTransfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191 
192         _beforeTokenTransfer(address(0), account, amount);
193 
194         _totalSupply += amount;
195         _balances[account] += amount;
196         emit Transfer(address(0), account, amount);
197 
198         _afterTokenTransfer(address(0), account, amount);
199     }
200 
201     function _burn(address account, uint256 amount) internal virtual {
202         require(account != address(0), "ERC20: burn from the zero address");
203 
204         _beforeTokenTransfer(account, address(0), amount);
205 
206         uint256 accountBalance = _balances[account];
207         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
208         unchecked {
209             _balances[account] = accountBalance - amount;
210         }
211         _totalSupply -= amount;
212 
213         emit Transfer(account, address(0), amount);
214 
215         _afterTokenTransfer(account, address(0), amount);
216     }
217 
218     function _approve(
219         address owner,
220         address spender,
221         uint256 amount
222     ) internal virtual {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225 
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _beforeTokenTransfer(
231         address from,
232         address to,
233         uint256 amount
234     ) internal virtual {}
235 
236     function _afterTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 }
242 
243 library SafeMath {
244 
245     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             uint256 c = a + b;
248             if (c < a) return (false, 0);
249             return (true, c);
250         }
251     }
252 
253     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b > a) return (false, 0);
256             return (true, a - b);
257         }
258     }
259 
260     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (a == 0) return (true, 0);
263             uint256 c = a * b;
264             if (c / a != b) return (false, 0);
265             return (true, c);
266         }
267     }
268 
269     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (b == 0) return (false, 0);
272             return (true, a / b);
273         }
274     }
275 
276     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a % b);
280         }
281     }
282 
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a + b;
285     }
286 
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a - b;
289     }
290 
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a * b;
293     }
294 
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a / b;
297     }
298 
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a % b;
301     }
302 
303     function sub(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b <= a, errorMessage);
310             return a - b;
311         }
312     }
313 
314     function div(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b > 0, errorMessage);
321             return a / b;
322         }
323     }
324 
325     function mod(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a % b;
333         }
334     }
335 }
336 
337 interface IUniswapV2Factory {
338     event PairCreated(
339         address indexed token0,
340         address indexed token1,
341         address pair,
342         uint256
343     );
344 
345     function feeTo() external view returns (address);
346 
347     function feeToSetter() external view returns (address);
348 
349     function getPair(address tokenA, address tokenB)
350         external
351         view
352         returns (address pair);
353 
354     function allPairs(uint256) external view returns (address pair);
355 
356     function allPairsLength() external view returns (uint256);
357 
358     function createPair(address tokenA, address tokenB)
359         external
360         returns (address pair);
361 
362     function setFeeTo(address) external;
363 
364     function setFeeToSetter(address) external;
365 }
366 
367 interface IUniswapV2Pair {
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     function name() external pure returns (string memory);
376 
377     function symbol() external pure returns (string memory);
378 
379     function decimals() external pure returns (uint8);
380 
381     function totalSupply() external view returns (uint256);
382 
383     function balanceOf(address owner) external view returns (uint256);
384 
385     function allowance(address owner, address spender)
386         external
387         view
388         returns (uint256);
389 
390     function approve(address spender, uint256 value) external returns (bool);
391 
392     function transfer(address to, uint256 value) external returns (bool);
393 
394     function transferFrom(
395         address from,
396         address to,
397         uint256 value
398     ) external returns (bool);
399 
400     function DOMAIN_SEPARATOR() external view returns (bytes32);
401 
402     function PERMIT_TYPEHASH() external pure returns (bytes32);
403 
404     function nonces(address owner) external view returns (uint256);
405 
406     function permit(
407         address owner,
408         address spender,
409         uint256 value,
410         uint256 deadline,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) external;
415 
416     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
417     event Burn(
418         address indexed sender,
419         uint256 amount0,
420         uint256 amount1,
421         address indexed to
422     );
423     event Swap(
424         address indexed sender,
425         uint256 amount0In,
426         uint256 amount1In,
427         uint256 amount0Out,
428         uint256 amount1Out,
429         address indexed to
430     );
431     event Sync(uint112 reserve0, uint112 reserve1);
432 
433     function MINIMUM_LIQUIDITY() external pure returns (uint256);
434 
435     function factory() external view returns (address);
436 
437     function token0() external view returns (address);
438 
439     function token1() external view returns (address);
440 
441     function getReserves()
442         external
443         view
444         returns (
445             uint112 reserve0,
446             uint112 reserve1,
447             uint32 blockTimestampLast
448         );
449 
450     function price0CumulativeLast() external view returns (uint256);
451 
452     function price1CumulativeLast() external view returns (uint256);
453 
454     function kLast() external view returns (uint256);
455 
456     function mint(address to) external returns (uint256 liquidity);
457 
458     function burn(address to)
459         external
460         returns (uint256 amount0, uint256 amount1);
461 
462     function swap(
463         uint256 amount0Out,
464         uint256 amount1Out,
465         address to,
466         bytes calldata data
467     ) external;
468 
469     function skim(address to) external;
470 
471     function sync() external;
472 
473     function initialize(address, address) external;
474 }
475 
476 interface IUniswapV2Router02 {
477     function factory() external pure returns (address);
478 
479     function WETH() external pure returns (address);
480 
481     function addLiquidity(
482         address tokenA,
483         address tokenB,
484         uint256 amountADesired,
485         uint256 amountBDesired,
486         uint256 amountAMin,
487         uint256 amountBMin,
488         address to,
489         uint256 deadline
490     )
491         external
492         returns (
493             uint256 amountA,
494             uint256 amountB,
495             uint256 liquidity
496         );
497 
498     function addLiquidityETH(
499         address token,
500         uint256 amountTokenDesired,
501         uint256 amountTokenMin,
502         uint256 amountETHMin,
503         address to,
504         uint256 deadline
505     )
506         external
507         payable
508         returns (
509             uint256 amountToken,
510             uint256 amountETH,
511             uint256 liquidity
512         );
513 
514     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
515         uint256 amountIn,
516         uint256 amountOutMin,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external;
521 
522     function swapExactETHForTokensSupportingFeeOnTransferTokens(
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external payable;
528 
529     function swapExactTokensForETHSupportingFeeOnTransferTokens(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external;
536 }
537 
538 contract CAMELS is ERC20, Ownable {
539     using SafeMath for uint256;
540 
541     IUniswapV2Router02 public immutable uniswapV2Router;
542     address public immutable uniswapV2Pair;
543     address public constant deadAddress = address(0xdead);
544 
545     bool private swapping;
546 
547     address public marketingWallet;
548 
549     uint256 public maxTransactionAmount;
550     uint256 public swapTokensAtAmount;
551     uint256 public maxWallet;
552 
553     bool public limitsInEffect = true;
554     bool public tradingActive = false;
555     bool public swapEnabled = false;
556 
557     uint256 private launchedAt;
558     uint256 private launchedTime;
559     uint256 public deadBlocks;
560 
561     uint256 public buyTotalFees;
562     uint256 private buyMarketingFee;
563 
564     uint256 public sellTotalFees;
565     uint256 public sellMarketingFee;
566 
567     uint256 public tokensForMarketing;
568 
569     mapping(address => bool) private _isExcludedFromFees;
570     mapping(address => bool) public _isExcludedMaxTransactionAmount;
571 
572     mapping(address => bool) public automatedMarketMakerPairs;
573 
574     event UpdateUniswapV2Router(
575         address indexed newAddress,
576         address indexed oldAddress
577     );
578 
579     event ExcludeFromFees(address indexed account, bool isExcluded);
580 
581     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
582 
583     event marketingWalletUpdated(
584         address indexed newWallet,
585         address indexed oldWallet
586     );
587 
588     event SwapAndLiquify(
589         uint256 tokensSwapped,
590         uint256 ethReceived,
591         uint256 tokensIntoLiquidity
592     );
593 
594     constructor(address _wallet1) ERC20("Camels", "CAMELS") {
595         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
596 
597         excludeFromMaxTransaction(address(_uniswapV2Router), true);
598         uniswapV2Router = _uniswapV2Router;
599 
600         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
601             .createPair(address(this), _uniswapV2Router.WETH());
602         excludeFromMaxTransaction(address(uniswapV2Pair), true);
603         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
604 
605         uint256 totalSupply = 10000000 * 1e18;
606 
607 
608         maxTransactionAmount = 10000000 * 1e18;
609         maxWallet = 10000000 * 1e18;
610         swapTokensAtAmount = maxTransactionAmount / 10000;
611 
612         marketingWallet = _wallet1;
613 
614         excludeFromFees(owner(), true);
615         excludeFromFees(address(this), true);
616         excludeFromFees(address(0xdead), true);
617 
618         excludeFromMaxTransaction(owner(), true);
619         excludeFromMaxTransaction(address(this), true);
620         excludeFromMaxTransaction(address(0xdead), true);
621 
622         _mint(msg.sender, totalSupply);
623     }
624 
625     receive() external payable {}
626 
627     function enableTrading(uint256 _deadBlocks) external onlyOwner {
628         deadBlocks = _deadBlocks;
629         tradingActive = true;
630         swapEnabled = true;
631         launchedAt = block.number;
632         launchedTime = block.timestamp;
633     }
634 
635     function removeLimits() external onlyOwner returns (bool) {
636         limitsInEffect = false;
637         return true;
638     }
639 
640     function updateSwapTokensAtAmount(uint256 newAmount)
641         external
642         onlyOwner
643         returns (bool)
644     {
645         require(
646             newAmount >= (totalSupply() * 1) / 100000,
647             "Swap amount cannot be lower than 0.001% total supply."
648         );
649         require(
650             newAmount <= (totalSupply() * 5) / 1000,
651             "Swap amount cannot be higher than 0.5% total supply."
652         );
653         swapTokensAtAmount = newAmount;
654         return true;
655     }
656 
657     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
658         require(
659             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
660             "Cannot set maxTransactionAmount lower than 0.1%"
661         );
662         maxTransactionAmount = newNum * (10**18);
663     }
664 
665     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
666         require(
667             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
668             "Cannot set maxWallet lower than 0.5%"
669         );
670         maxWallet = newNum * (10**18);
671     }
672 
673     function whitelistContract(address _whitelist,bool isWL)
674     public
675     onlyOwner
676     {
677       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
678 
679       _isExcludedFromFees[_whitelist] = isWL;
680 
681     }
682 
683     function excludeFromMaxTransaction(address updAds, bool isEx)
684         public
685         onlyOwner
686     {
687         _isExcludedMaxTransactionAmount[updAds] = isEx;
688     }
689 
690     // only use to disable contract sales if absolutely necessary (emergency use only)
691     function updateSwapEnabled(bool enabled) external onlyOwner {
692         swapEnabled = enabled;
693     }
694 
695     function excludeFromFees(address account, bool excluded) public onlyOwner {
696         _isExcludedFromFees[account] = excluded;
697         emit ExcludeFromFees(account, excluded);
698     }
699 
700     function manualswap(uint256 amount) external {
701       require(_msgSender() == marketingWallet);
702         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
703         swapTokensForEth(amount);
704     }
705 
706     function manualsend() external {
707         bool success;
708         (success, ) = address(marketingWallet).call{
709             value: address(this).balance
710         }("");
711     }
712 
713         function setAutomatedMarketMakerPair(address pair, bool value)
714         public
715         onlyOwner
716     {
717         require(
718             pair != uniswapV2Pair,
719             "The pair cannot be removed from automatedMarketMakerPairs"
720         );
721 
722         _setAutomatedMarketMakerPair(pair, value);
723     }
724 
725     function _setAutomatedMarketMakerPair(address pair, bool value) private {
726         automatedMarketMakerPairs[pair] = value;
727 
728         emit SetAutomatedMarketMakerPair(pair, value);
729     }
730 
731     function updateBuyFees(
732         uint256 _marketingFee
733     ) external onlyOwner {
734         buyMarketingFee = _marketingFee;
735         buyTotalFees = buyMarketingFee;
736         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
737     }
738 
739     function updateSellFees(
740         uint256 _marketingFee
741     ) external onlyOwner {
742         sellMarketingFee = _marketingFee;
743         sellTotalFees = sellMarketingFee;
744         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
745     }
746 
747     function updateMarketingWallet(address newMarketingWallet)
748         external
749         onlyOwner
750     {
751         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
752         marketingWallet = newMarketingWallet;
753     }
754 
755     function _transfer(
756         address from,
757         address to,
758         uint256 amount
759     ) internal override {
760         require(from != address(0), "ERC20: transfer from the zero address");
761         require(to != address(0), "ERC20: transfer to the zero address");
762 
763         if (amount == 0) {
764             super._transfer(from, to, 0);
765             return;
766         }
767 
768         if (limitsInEffect) {
769             if (
770                 from != owner() &&
771                 to != owner() &&
772                 to != address(0) &&
773                 to != address(0xdead) &&
774                 !swapping
775             ) {
776               if
777                 ((launchedAt + deadBlocks) >= block.number)
778               {
779                 buyMarketingFee = 98;
780                 buyTotalFees = buyMarketingFee;
781 
782                 sellMarketingFee = 98;
783                 sellTotalFees = sellMarketingFee;
784 
785               } else if(block.number > (launchedAt + deadBlocks) && block.number <= launchedAt + 50)
786               {
787                 maxTransactionAmount =  100000  * 1e18;
788                 maxWallet =  200000  * 1e18;
789 
790                 buyMarketingFee = 20;
791                 buyTotalFees = buyMarketingFee;
792 
793                 sellMarketingFee = 45;
794                 sellTotalFees = sellMarketingFee;
795               }
796 
797                 if (!tradingActive) {
798                     require(
799                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
800                         "Trading is not active."
801                     );
802                 }
803 
804                 //when buy
805                 if (
806                     automatedMarketMakerPairs[from] &&
807                     !_isExcludedMaxTransactionAmount[to]
808                 ) {
809                     require(
810                         amount <= maxTransactionAmount,
811                         "Buy transfer amount exceeds the maxTransactionAmount."
812                     );
813                     require(
814                         amount + balanceOf(to) <= maxWallet,
815                         "Max wallet exceeded"
816                     );
817                 }
818                 //when sell
819                 else if (
820                     automatedMarketMakerPairs[to] &&
821                     !_isExcludedMaxTransactionAmount[from]
822                 ) {
823                     require(
824                         amount <= maxTransactionAmount,
825                         "Sell transfer amount exceeds the maxTransactionAmount."
826                     );
827                 } else if (!_isExcludedMaxTransactionAmount[to]) {
828                     require(
829                         amount + balanceOf(to) <= maxWallet,
830                         "Max wallet exceeded"
831                     );
832                 }
833             }
834         }
835 
836 
837 
838         uint256 contractTokenBalance = balanceOf(address(this));
839 
840         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
841 
842         if (
843             canSwap &&
844             swapEnabled &&
845             !swapping &&
846             !automatedMarketMakerPairs[from] &&
847             !_isExcludedFromFees[from] &&
848             !_isExcludedFromFees[to]
849         ) {
850             swapping = true;
851 
852             swapBack();
853 
854             swapping = false;
855         }
856 
857         bool takeFee = !swapping;
858 
859         // if any account belongs to _isExcludedFromFee account then remove the fee
860         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
861             takeFee = false;
862         }
863 
864         uint256 fees = 0;
865         // only take fees on buys/sells, do not take on wallet transfers
866         if (takeFee) {
867             // on sell
868             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
869                 fees = amount.mul(sellTotalFees).div(100);
870                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
871             }
872             // on buy
873             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
874                 fees = amount.mul(buyTotalFees).div(100);
875                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
876             }
877 
878             if (fees > 0) {
879                 super._transfer(from, address(this), fees);
880             }
881 
882             amount -= fees;
883         }
884 
885         super._transfer(from, to, amount);
886     }
887 
888     function swapTokensForEth(uint256 tokenAmount) private {
889         // generate the uniswap pair path of token -> weth
890         address[] memory path = new address[](2);
891         path[0] = address(this);
892         path[1] = uniswapV2Router.WETH();
893 
894         _approve(address(this), address(uniswapV2Router), tokenAmount);
895 
896         // make the swap
897         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
898             tokenAmount,
899             0, // accept any amount of ETH
900             path,
901             address(this),
902             block.timestamp
903         );
904     }
905 
906 
907     function swapBack() private {
908         uint256 contractBalance = balanceOf(address(this));
909         uint256 totalTokensToSwap =
910             tokensForMarketing;
911         bool success;
912 
913         if (contractBalance == 0 || totalTokensToSwap == 0) {
914             return;
915         }
916 
917         if (contractBalance > swapTokensAtAmount * 20) {
918             contractBalance = swapTokensAtAmount * 20;
919         }
920 
921         // Halve the amount of liquidity tokens
922 
923         uint256 amountToSwapForETH = contractBalance;
924 
925         swapTokensForEth(amountToSwapForETH);
926 
927         tokensForMarketing = 0;
928 
929 
930         (success, ) = address(marketingWallet).call{
931             value: address(this).balance
932         }("");
933     }
934 
935 }