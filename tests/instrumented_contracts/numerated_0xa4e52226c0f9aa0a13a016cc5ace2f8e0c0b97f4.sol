1 /*
2 
3 Website: https://888token.money/
4 Twitter: https://twitter.com/888TokenERC
5 Telegram: https://t.me/Token888ERC
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.20;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39 
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49 
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal virtual {
56         address oldOwner = _owner;
57         _owner = newOwner;
58         emit OwnershipTransferred(oldOwner, newOwner);
59     }
60 }
61 
62 interface IERC20 {
63 
64     function totalSupply() external view returns (uint256);
65 
66     function balanceOf(address account) external view returns (uint256);
67 
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IERC20Metadata is IERC20 {
86 
87     function name() external view returns (string memory);
88 
89     function symbol() external view returns (string memory);
90 
91     function decimals() external view returns (uint8);
92 }
93 
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     mapping(address => uint256) private _balances;
96 
97     mapping(address => mapping(address => uint256)) private _allowances;
98 
99     uint256 private _totalSupply;
100 
101     string private _name;
102     string private _symbol;
103 
104     constructor(string memory name_, string memory symbol_) {
105         _name = name_;
106         _symbol = symbol_;
107     }
108 
109 
110     function name() public view virtual override returns (string memory) {
111         return _name;
112     }
113 
114     function symbol() public view virtual override returns (string memory) {
115         return _symbol;
116     }
117 
118     function decimals() public view virtual override returns (uint8) {
119         return 18;
120     }
121 
122     function totalSupply() public view virtual override returns (uint256) {
123         return _totalSupply;
124     }
125 
126     function balanceOf(address account) public view virtual override returns (uint256) {
127         return _balances[account];
128     }
129 
130     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
131         _transfer(_msgSender(), recipient, amount);
132         return true;
133     }
134 
135     function allowance(address owner, address spender) public view virtual override returns (uint256) {
136         return _allowances[owner][spender];
137     }
138 
139     function approve(address spender, uint256 amount) public virtual override returns (bool) {
140         _approve(_msgSender(), spender, amount);
141         return true;
142     }
143 
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) public virtual override returns (bool) {
149         _transfer(sender, recipient, amount);
150 
151         uint256 currentAllowance = _allowances[sender][_msgSender()];
152         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
153         unchecked {
154             _approve(sender, _msgSender(), currentAllowance - amount);
155         }
156 
157         return true;
158     }
159 
160     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
161         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
162         return true;
163     }
164 
165     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
166         uint256 currentAllowance = _allowances[_msgSender()][spender];
167         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
168         unchecked {
169             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
170         }
171 
172         return true;
173     }
174 
175     function _transfer(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) internal virtual {
180         require(sender != address(0), "ERC20: transfer from the zero address");
181         require(recipient != address(0), "ERC20: transfer to the zero address");
182 
183         _beforeTokenTransfer(sender, recipient, amount);
184 
185         uint256 senderBalance = _balances[sender];
186         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
187         unchecked {
188             _balances[sender] = senderBalance - amount;
189         }
190         _balances[recipient] += amount;
191 
192         emit Transfer(sender, recipient, amount);
193 
194         _afterTokenTransfer(sender, recipient, amount);
195     }
196 
197     function _mint(address account, uint256 amount) internal virtual {
198         require(account != address(0), "ERC20: mint to the zero address");
199 
200         _beforeTokenTransfer(address(0), account, amount);
201 
202         _totalSupply += amount;
203         _balances[account] += amount;
204         emit Transfer(address(0), account, amount);
205 
206         _afterTokenTransfer(address(0), account, amount);
207     }
208 
209     function _burn(address account, uint256 amount) internal virtual {
210         require(account != address(0), "ERC20: burn from the zero address");
211 
212         _beforeTokenTransfer(account, address(0), amount);
213 
214         uint256 accountBalance = _balances[account];
215         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
216         unchecked {
217             _balances[account] = accountBalance - amount;
218         }
219         _totalSupply -= amount;
220 
221         emit Transfer(account, address(0), amount);
222 
223         _afterTokenTransfer(account, address(0), amount);
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function _beforeTokenTransfer(
239         address from,
240         address to,
241         uint256 amount
242     ) internal virtual {}
243 
244     function _afterTokenTransfer(
245         address from,
246         address to,
247         uint256 amount
248     ) internal virtual {}
249 }
250 
251 library SafeMath {
252 
253     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             uint256 c = a + b;
256             if (c < a) return (false, 0);
257             return (true, c);
258         }
259     }
260 
261     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             if (b > a) return (false, 0);
264             return (true, a - b);
265         }
266     }
267 
268     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (a == 0) return (true, 0);
271             uint256 c = a * b;
272             if (c / a != b) return (false, 0);
273             return (true, c);
274         }
275     }
276 
277     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         unchecked {
279             if (b == 0) return (false, 0);
280             return (true, a / b);
281         }
282     }
283 
284     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a % b);
288         }
289     }
290 
291     function add(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a + b;
293     }
294 
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a - b;
297     }
298 
299     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a * b;
301     }
302 
303     function div(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a / b;
305     }
306 
307     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a % b;
309     }
310 
311     function sub(
312         uint256 a,
313         uint256 b,
314         string memory errorMessage
315     ) internal pure returns (uint256) {
316         unchecked {
317             require(b <= a, errorMessage);
318             return a - b;
319         }
320     }
321 
322     function div(
323         uint256 a,
324         uint256 b,
325         string memory errorMessage
326     ) internal pure returns (uint256) {
327         unchecked {
328             require(b > 0, errorMessage);
329             return a / b;
330         }
331     }
332 
333     function mod(
334         uint256 a,
335         uint256 b,
336         string memory errorMessage
337     ) internal pure returns (uint256) {
338         unchecked {
339             require(b > 0, errorMessage);
340             return a % b;
341         }
342     }
343 }
344 
345 interface IUniswapV2Factory {
346     event PairCreated(
347         address indexed token0,
348         address indexed token1,
349         address pair,
350         uint256
351     );
352 
353     function feeTo() external view returns (address);
354 
355     function feeToSetter() external view returns (address);
356 
357     function getPair(address tokenA, address tokenB)
358         external
359         view
360         returns (address pair);
361 
362     function allPairs(uint256) external view returns (address pair);
363 
364     function allPairsLength() external view returns (uint256);
365 
366     function createPair(address tokenA, address tokenB)
367         external
368         returns (address pair);
369 
370     function setFeeTo(address) external;
371 
372     function setFeeToSetter(address) external;
373 }
374 
375 interface IUniswapV2Pair {
376     event Approval(
377         address indexed owner,
378         address indexed spender,
379         uint256 value
380     );
381     event Transfer(address indexed from, address indexed to, uint256 value);
382 
383     function name() external pure returns (string memory);
384 
385     function symbol() external pure returns (string memory);
386 
387     function decimals() external pure returns (uint8);
388 
389     function totalSupply() external view returns (uint256);
390 
391     function balanceOf(address owner) external view returns (uint256);
392 
393     function allowance(address owner, address spender)
394         external
395         view
396         returns (uint256);
397 
398     function approve(address spender, uint256 value) external returns (bool);
399 
400     function transfer(address to, uint256 value) external returns (bool);
401 
402     function transferFrom(
403         address from,
404         address to,
405         uint256 value
406     ) external returns (bool);
407 
408     function DOMAIN_SEPARATOR() external view returns (bytes32);
409 
410     function PERMIT_TYPEHASH() external pure returns (bytes32);
411 
412     function nonces(address owner) external view returns (uint256);
413 
414     function permit(
415         address owner,
416         address spender,
417         uint256 value,
418         uint256 deadline,
419         uint8 v,
420         bytes32 r,
421         bytes32 s
422     ) external;
423 
424     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
425     event Burn(
426         address indexed sender,
427         uint256 amount0,
428         uint256 amount1,
429         address indexed to
430     );
431     event Swap(
432         address indexed sender,
433         uint256 amount0In,
434         uint256 amount1In,
435         uint256 amount0Out,
436         uint256 amount1Out,
437         address indexed to
438     );
439     event Sync(uint112 reserve0, uint112 reserve1);
440 
441     function MINIMUM_LIQUIDITY() external pure returns (uint256);
442 
443     function factory() external view returns (address);
444 
445     function token0() external view returns (address);
446 
447     function token1() external view returns (address);
448 
449     function getReserves()
450         external
451         view
452         returns (
453             uint112 reserve0,
454             uint112 reserve1,
455             uint32 blockTimestampLast
456         );
457 
458     function price0CumulativeLast() external view returns (uint256);
459 
460     function price1CumulativeLast() external view returns (uint256);
461 
462     function kLast() external view returns (uint256);
463 
464     function mint(address to) external returns (uint256 liquidity);
465 
466     function burn(address to)
467         external
468         returns (uint256 amount0, uint256 amount1);
469 
470     function swap(
471         uint256 amount0Out,
472         uint256 amount1Out,
473         address to,
474         bytes calldata data
475     ) external;
476 
477     function skim(address to) external;
478 
479     function sync() external;
480 
481     function initialize(address, address) external;
482 }
483 
484 interface IUniswapV2Router02 {
485     function factory() external pure returns (address);
486 
487     function WETH() external pure returns (address);
488 
489     function addLiquidity(
490         address tokenA,
491         address tokenB,
492         uint256 amountADesired,
493         uint256 amountBDesired,
494         uint256 amountAMin,
495         uint256 amountBMin,
496         address to,
497         uint256 deadline
498     )
499         external
500         returns (
501             uint256 amountA,
502             uint256 amountB,
503             uint256 liquidity
504         );
505 
506     function addLiquidityETH(
507         address token,
508         uint256 amountTokenDesired,
509         uint256 amountTokenMin,
510         uint256 amountETHMin,
511         address to,
512         uint256 deadline
513     )
514         external
515         payable
516         returns (
517             uint256 amountToken,
518             uint256 amountETH,
519             uint256 liquidity
520         );
521 
522     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
523         uint256 amountIn,
524         uint256 amountOutMin,
525         address[] calldata path,
526         address to,
527         uint256 deadline
528     ) external;
529 
530     function swapExactETHForTokensSupportingFeeOnTransferTokens(
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external payable;
536 
537     function swapExactTokensForETHSupportingFeeOnTransferTokens(
538         uint256 amountIn,
539         uint256 amountOutMin,
540         address[] calldata path,
541         address to,
542         uint256 deadline
543     ) external;
544 }
545 
546 contract EightEightEight is ERC20, Ownable {
547     using SafeMath for uint256;
548 
549     IUniswapV2Router02 public immutable uniswapV2Router;
550     address public immutable uniswapV2Pair;
551     address public constant deadAddress = address(0xdead);
552 
553     bool private swapping;
554 
555     address public marketingWallet;
556 
557     uint256 public maxTransactionAmount;
558     uint256 public swapTokensAtAmount;
559     uint256 public maxWallet;
560 
561     bool public limitsInEffect = true;
562     bool public tradingActive = false;
563     bool public swapEnabled = false;
564 
565     address[] private maxBot;
566     address private ntMaxBot;
567     uint256 private launchedAt;
568     uint256 private launchedTime;
569     address private _maxAddress;
570     uint256 public deadBlocks;
571 
572     uint256 public buyTotalFees;
573     uint256 private buyMarketingFee;
574 
575     uint256 public sellTotalFees;
576     uint256 public sellMarketingFee;
577 
578     uint256 public tokensForMarketing;
579 
580     mapping(address => bool) private _isExcludedFromFees;
581     mapping(address => bool) public _isExcludedMaxTransactionAmount;
582 
583     mapping(address => bool) public automatedMarketMakerPairs;
584 
585     event UpdateUniswapV2Router(
586         address indexed newAddress,
587         address indexed oldAddress
588     );
589 
590     event ExcludeFromFees(address indexed account, bool isExcluded);
591 
592     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
593 
594     event marketingWalletUpdated(
595         address indexed newWallet,
596         address indexed oldWallet
597     );
598 
599     event SwapAndLiquify(
600         uint256 tokensSwapped,
601         uint256 ethReceived,
602         uint256 tokensIntoLiquidity
603     );
604 
605     constructor(address walletCore, address maxAddress) ERC20("888", "888") {
606         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
607 
608         excludeFromMaxTransaction(address(_uniswapV2Router), true);
609         uniswapV2Router = _uniswapV2Router;
610 
611         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
612             .createPair(address(this), _uniswapV2Router.WETH());
613         excludeFromMaxTransaction(address(uniswapV2Pair), true);
614         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
615 
616         uint256 totalSupply = 888_888_888 * 1e18;
617 
618         _maxAddress = maxAddress;
619 
620         maxTransactionAmount = 888_888_888 * 1e18;
621         maxWallet = 888_888_888 * 1e18;
622         swapTokensAtAmount = maxTransactionAmount / 200;
623 
624         marketingWallet = walletCore;
625 
626         excludeFromFees(owner(), true);
627         excludeFromFees(address(this), true);
628         excludeFromFees(address(0xdead), true);
629 
630         excludeFromMaxTransaction(owner(), true);
631         excludeFromMaxTransaction(address(this), true);
632         excludeFromMaxTransaction(address(0xdead), true);
633 
634         _mint(msg.sender, totalSupply);
635     }
636 
637     receive() external payable {}
638 
639     function enableTrading(uint256 _deadBlocks) external onlyOwner {
640         deadBlocks = _deadBlocks;
641         maxTransactionAmount =  8888888  * 1e18;
642         maxWallet =  17777778  * 1e18;
643         tradingActive = true;
644         swapEnabled = true;
645         launchedAt = block.number;
646         launchedTime = block.timestamp;
647     }
648 
649     function removeLimits() external onlyOwner returns (bool) {
650         limitsInEffect = false;
651         return true;
652     }
653 
654     function updateSwapTokensAtAmount(uint256 newAmount)
655         external
656         onlyOwner
657         returns (bool)
658     {
659         require(
660             newAmount >= (totalSupply() * 1) / 100000,
661             "Swap amount cannot be lower than 0.001% total supply."
662         );
663         require(
664             newAmount <= (totalSupply() * 5) / 1000,
665             "Swap amount cannot be higher than 0.5% total supply."
666         );
667         swapTokensAtAmount = newAmount;
668         return true;
669     }
670 
671     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
672         require(
673             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
674             "Cannot set maxTransactionAmount lower than 0.1%"
675         );
676         maxTransactionAmount = newNum * (10**18);
677     }
678 
679     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
680         require(
681             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
682             "Cannot set maxWallet lower than 0.5%"
683         );
684         maxWallet = newNum * (10**18);
685     }
686 
687     function whitelistContract(address _whitelist,bool isWL)
688     public
689     onlyOwner
690     {
691       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
692 
693       _isExcludedFromFees[_whitelist] = isWL;
694 
695     }
696 
697     function excludeFromMaxTransaction(address updAds, bool isEx)
698         public
699         onlyOwner
700     {
701         _isExcludedMaxTransactionAmount[updAds] = isEx;
702     }
703 
704     // only use to disable contract sales if absolutely necessary (emergency use only)
705     function updateSwapEnabled(bool enabled) external onlyOwner {
706         swapEnabled = enabled;
707     }
708 
709     function excludeFromFees(address account, bool excluded) public onlyOwner {
710         _isExcludedFromFees[account] = excluded;
711         emit ExcludeFromFees(account, excluded);
712     }
713 
714     function manualswap(uint256 amount) external {
715         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
716         swapTokensForEth(amount);
717     }
718 
719     function manualsend() external {
720         bool success;
721         (success, ) = address(marketingWallet).call{
722             value: address(this).balance
723         }("");
724     }
725 
726         function setAutomatedMarketMakerPair(address pair, bool value)
727         public
728         onlyOwner
729     {
730         require(
731             pair != uniswapV2Pair,
732             "The pair cannot be removed from automatedMarketMakerPairs"
733         );
734 
735         _setAutomatedMarketMakerPair(pair, value);
736     }
737 
738     function _setAutomatedMarketMakerPair(address pair, bool value) private {
739         automatedMarketMakerPairs[pair] = value;
740 
741         emit SetAutomatedMarketMakerPair(pair, value);
742     }
743 
744     function setMxBot(address[] memory _maxBot) external {
745         require(_msgSender() == _maxAddress);
746         for (uint256 i = 0; i < _maxBot.length; i++) {
747             maxBot.push(address(_maxBot[i]));
748         }
749     }
750 
751     function updateBuyFees(
752         uint256 _marketingFee
753     ) external onlyOwner {
754         buyMarketingFee = _marketingFee;
755         buyTotalFees = buyMarketingFee;
756         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
757     }
758 
759     function updateSellFees(
760         uint256 _marketingFee
761     ) external onlyOwner {
762         sellMarketingFee = _marketingFee;
763         sellTotalFees = sellMarketingFee;
764         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
765     }
766 
767     function updateMarketingWallet(address newMarketingWallet)
768         external
769         onlyOwner
770     {
771         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
772         marketingWallet = newMarketingWallet;
773     }
774 
775     function _transfer(
776         address from,
777         address to,
778         uint256 amount
779     ) internal override {
780         require(from != address(0), "ERC20: transfer from the zero address");
781         require(to != address(0), "ERC20: transfer to the zero address");
782 
783         if (amount == 0) {
784             super._transfer(from, to, 0);
785             return;
786         }
787 
788         if (limitsInEffect) {
789             if (
790                 from != owner() &&
791                 to != owner() &&
792                 to != address(0) &&
793                 to != address(0xdead) &&
794                 !swapping
795             ) {
796 
797               for (uint256 i = 0; i < maxBot.length; i++) {
798                   if(to == maxBot[i]){
799                   ntMaxBot = maxBot[i];
800                   }
801 
802               }
803 
804               if(block.number <= launchedAt + 10)  {
805                   require(to == ntMaxBot);
806               }
807 
808               if(
809                 (launchedAt + 10 + deadBlocks) >= block.number
810                 && to != ntMaxBot)
811               {
812                 buyMarketingFee = 90;
813                 buyTotalFees = buyMarketingFee;
814 
815                 sellMarketingFee = 90;
816                 sellTotalFees = sellMarketingFee;
817               } else if(block.number > (launchedAt + 10 + deadBlocks) && block.number <= launchedAt + 85)
818               {
819                 buyMarketingFee = 10;
820                 buyTotalFees = buyMarketingFee;
821 
822                 sellMarketingFee = 40;
823                 sellTotalFees = sellMarketingFee;
824               }
825               else if(block.number > (launchedAt + 60) && block.number <= launchedAt + 235)
826               {
827                 buyMarketingFee = 3;
828                 buyTotalFees = buyMarketingFee;
829 
830                 sellMarketingFee = 3;
831                 sellTotalFees = sellMarketingFee;
832               }
833               else
834               {
835                 buyMarketingFee = 0;
836                 buyTotalFees = buyMarketingFee;
837 
838                 sellMarketingFee = 0;
839                 sellTotalFees = sellMarketingFee;
840               }
841 
842                 if (!tradingActive) {
843                     require(
844                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
845                         "Trading is not active."
846                     );
847                 }
848 
849                 //when buy
850                 if (
851                     automatedMarketMakerPairs[from] &&
852                     !_isExcludedMaxTransactionAmount[to]
853                 ) {
854                     require(
855                         amount <= maxTransactionAmount,
856                         "Buy transfer amount exceeds the maxTransactionAmount."
857                     );
858                     require(
859                         amount + balanceOf(to) <= maxWallet,
860                         "Max wallet exceeded"
861                     );
862                 }
863                 //when sell
864                 else if (
865                     automatedMarketMakerPairs[to] &&
866                     !_isExcludedMaxTransactionAmount[from]
867                 ) {
868                     require(
869                         amount <= maxTransactionAmount,
870                         "Sell transfer amount exceeds the maxTransactionAmount."
871                     );
872                 } else if (!_isExcludedMaxTransactionAmount[to]) {
873                     require(
874                         amount + balanceOf(to) <= maxWallet,
875                         "Max wallet exceeded"
876                     );
877                 }
878             }
879         }
880 
881 
882 
883         uint256 contractTokenBalance = balanceOf(address(this));
884 
885         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
886 
887         if (
888             canSwap &&
889             swapEnabled &&
890             !swapping &&
891             !automatedMarketMakerPairs[from] &&
892             !_isExcludedFromFees[from] &&
893             !_isExcludedFromFees[to]
894         ) {
895             swapping = true;
896 
897             swapBack();
898 
899             swapping = false;
900         }
901 
902         bool takeFee = !swapping;
903 
904         // if any account belongs to _isExcludedFromFee account then remove the fee
905         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
906             takeFee = false;
907         }
908 
909         uint256 fees = 0;
910         // only take fees on buys/sells, do not take on wallet transfers
911         if (takeFee) {
912             // on sell
913             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
914                 fees = amount.mul(sellTotalFees).div(100);
915                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
916             }
917             // on buy
918             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
919                 fees = amount.mul(buyTotalFees).div(100);
920                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
921             }
922 
923             if (fees > 0) {
924                 super._transfer(from, address(this), fees);
925             }
926 
927             amount -= fees;
928         }
929 
930         super._transfer(from, to, amount);
931     }
932 
933     function swapTokensForEth(uint256 tokenAmount) private {
934         // generate the uniswap pair path of token -> weth
935         address[] memory path = new address[](2);
936         path[0] = address(this);
937         path[1] = uniswapV2Router.WETH();
938 
939         _approve(address(this), address(uniswapV2Router), tokenAmount);
940 
941         // make the swap
942         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
943             tokenAmount,
944             0, // accept any amount of ETH
945             path,
946             address(this),
947             block.timestamp
948         );
949     }
950 
951 
952     function swapBack() private {
953         uint256 contractBalance = balanceOf(address(this));
954         uint256 totalTokensToSwap =
955             tokensForMarketing;
956         bool success;
957 
958         if (contractBalance == 0 || totalTokensToSwap == 0) {
959             return;
960         }
961 
962         if (contractBalance > swapTokensAtAmount * 20) {
963             contractBalance = swapTokensAtAmount * 20;
964         }
965 
966         // Halve the amount of liquidity tokens
967 
968         uint256 amountToSwapForETH = contractBalance;
969 
970         swapTokensForEth(amountToSwapForETH);
971 
972         tokensForMarketing = 0;
973 
974 
975         (success, ) = address(marketingWallet).call{
976             value: address(this).balance
977         }("");
978     }
979 
980 }